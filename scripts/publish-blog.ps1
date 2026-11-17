<#
.SYNOPSIS
    Publish every note in the knowledge base marked `publish: True` to the blog,
    then commit and push.

.DESCRIPTION
    One full cycle:

      1. scan the vault for `publish: True`
      2. normalise frontmatter into the blog's schema
      3. validate the batch with a throwaway build
      4. replace src/content/posts/ with the validated batch
      5. build for real, commit
      6. push to origin/main

    Nothing is deleted until a build of the new batch has passed. Any failure
    stops the script with src/content/posts/ untouched, so the worst outcome is
    that nothing happened.

    Temp files live under .publish-tmp\ in the repo and are removed on the way
    out, including on Ctrl+C. They sit beside the repo rather than in %TEMP%
    because Astro renames build intermediates into the output directory, and a
    rename across drives fails with EXDEV.

.EXAMPLE
    & "D:\KnowledgeBase\6 Info\64 Projects\Blog\scripts\publish-blog.ps1"

.NOTES
    Windows PowerShell 5.1. Uses npm, because pnpm's default linker needs
    junctions and junctions do not resolve on this machine.
#>

#Requires -Version 5.1

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------

$BlogRoot  = Split-Path -Parent $PSScriptRoot
$PostsDir  = Join-Path $BlogRoot 'src\content\posts'
$VaultRoot = [System.IO.Path]::GetFullPath((Join-Path $BlogRoot '..\..\..'))

$Stamp    = Get-Date -Format 'yyyyMMdd-HHmmss'

# Temp lives beside the repo, not in %TEMP%: Astro renames build intermediates
# into the output directory, and a rename across drives fails with EXDEV.
$TempRoot = Join-Path $BlogRoot ".publish-tmp\$Stamp-$PID"
$StageDir = Join-Path $TempRoot 'posts'
$DistDir  = Join-Path $TempRoot 'dist'

# Sweep directories left behind by an earlier run that was killed outright.
$TempParent = Split-Path -Parent $TempRoot
if (Test-Path -LiteralPath $TempParent) {
    Get-ChildItem -LiteralPath $TempParent -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -lt (Get-Date).AddHours(-6) } |
        ForEach-Object { Remove-Item -LiteralPath $_.FullName -Recurse -Force -ErrorAction SilentlyContinue }
}

# Never publish from these. Raw material is read-only by policy; Projects are
# independent git repositories that happen to sit inside the vault.
$ExcludePatterns = @(
    '\\node_modules\\'
    '\\\.git\\'
    '\\\.astro\\'
    '\\\d+ Raw\\'
    '\\\d+ Projects\\'
)

# ---------------------------------------------------------------------------
# Output
# ---------------------------------------------------------------------------

function Write-Step   { param([string]$Text) Write-Host "`n$Text" -ForegroundColor Cyan }
function Write-Ok     { param([string]$Text) Write-Host "      OK   $Text" -ForegroundColor Green }
function Write-Warn   { param([string]$Text) Write-Host "      WARN $Text" -ForegroundColor Yellow }
function Write-Fail   { param([string]$Text) Write-Host "      FAIL $Text" -ForegroundColor Red }
function Write-Detail { param([string]$Text) Write-Host "           $Text" -ForegroundColor DarkGray }

function Remove-TempRoot {
    if (Test-Path -LiteralPath $TempRoot) {
        Remove-Item -LiteralPath $TempRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
    # Drop the parent too once the last run's folder is gone.
    if ((Test-Path -LiteralPath $TempParent) -and
        -not (Get-ChildItem -LiteralPath $TempParent -Force -ErrorAction SilentlyContinue)) {
        Remove-Item -LiteralPath $TempParent -Force -ErrorAction SilentlyContinue
    }
}

# Returns the indented '- item' lines that follow index $StartIndex.
function Get-ListItemRange {
    param([string[]]$Source, [int]$StartIndex)

    $items = New-Object System.Collections.Generic.List[string]
    $j = $StartIndex + 1
    while ($j -lt $Source.Count -and $Source[$j] -match '^\s+-\s*(.*)$') {
        $items.Add($Matches[1].Trim())
        $j++
    }
    return [pscustomobject]@{ Items = $items; Next = $j }
}

# Runs an npm script in the blog directory and returns exit code + output.
function Invoke-NpmBuild {
    param([string]$PostsDirOverride, [string]$OutDir)

    $previous = $env:POSTS_DIR
    if ($PostsDirOverride) { $env:POSTS_DIR = $PostsDirOverride }
    else { Remove-Item Env:\POSTS_DIR -ErrorAction SilentlyContinue }

    Push-Location -LiteralPath $BlogRoot
    try {
        $output = & npm run build --silent -- --outDir $OutDir 2>&1
        $code   = $LASTEXITCODE
    } finally {
        Pop-Location
        if ($previous) { $env:POSTS_DIR = $previous }
        else { Remove-Item Env:\POSTS_DIR -ErrorAction SilentlyContinue }
    }

    return [pscustomobject]@{ Code = $code; Output = $output }
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

$exitCode = 0

try {
    New-Item -ItemType Directory -Path $StageDir -Force | Out-Null

    # -- 1. Scan ------------------------------------------------------------

    Write-Step '[1/6] Scanning the knowledge base for publish: True ...'

    $allNotes = @(
        Get-ChildItem -LiteralPath $VaultRoot -Recurse -Filter '*.md' -File -ErrorAction SilentlyContinue |
            Where-Object {
                $p = $_.FullName
                -not ($ExcludePatterns | Where-Object { $p -match $_ })
            }
    )
    Write-Detail ("scanned {0} markdown files" -f $allNotes.Count)

    $pending = New-Object System.Collections.ArrayList

    foreach ($note in $allNotes) {
        $head = @(Get-Content -LiteralPath $note.FullName -TotalCount 40 -Encoding UTF8 -ErrorAction SilentlyContinue)
        if ($head.Count -lt 2 -or $head[0].Trim() -ne '---') { continue }

        $closeIdx = -1
        for ($i = 1; $i -lt $head.Count; $i++) {
            if ($head[$i].Trim() -eq '---') { $closeIdx = $i; break }
        }
        if ($closeIdx -lt 2) { continue }

        $fm = @($head[1..($closeIdx - 1)])

        $publishIdx = -1
        $publishVal = ''
        for ($i = 0; $i -lt $fm.Count; $i++) {
            if ($fm[$i] -match '^publish\s*:\s*(.*)$') {
                $publishIdx = $i
                $publishVal = $Matches[1].Trim()
                break
            }
        }
        if ($publishIdx -lt 0) { continue }

        if ([string]::IsNullOrWhiteSpace($publishVal) -and $publishIdx + 1 -lt $fm.Count) {
            if ($fm[$publishIdx + 1] -match '^\s*-\s*(.+)$') { $publishVal = $Matches[1].Trim() }
        }
        if ($publishVal -notmatch '^(true|yes|1)$') { continue }

        [void]$pending.Add([pscustomobject]@{
            FullPath = $note.FullName
            Relative = $note.FullName.Substring($VaultRoot.Length).TrimStart('\')
            FileName = $note.Name
        })
    }

    if ($pending.Count -eq 0) {
        Write-Warn 'No notes are marked publish: True. Nothing to do.'
        Write-Host "`n[DONE] src/content/posts/ left as-is." -ForegroundColor Yellow
        Remove-TempRoot
        exit 0
    }

    Write-Ok ("{0} note(s) marked for publishing" -f $pending.Count)

    $dupes = $pending | Group-Object FileName | Where-Object { $_.Count -gt 1 }
    if ($dupes) {
        foreach ($d in $dupes) {
            Write-Fail ("duplicate file name: {0}" -f $d.Name)
            $d.Group | ForEach-Object { Write-Detail $_.Relative }
        }
        throw 'Two or more notes share a file name; rename one, then run again.'
    }

    # -- 2. Normalise -------------------------------------------------------

    Write-Step '[2/6] Normalising frontmatter ...'

    $written = 0

    foreach ($note in $pending) {
        $raw = [System.IO.File]::ReadAllText($note.FullPath, [System.Text.Encoding]::UTF8)
        $raw = $raw -replace "^\uFEFF", ''
        $raw = $raw -replace "`r`n", "`n"

        $m = [regex]::Match($raw, '^---\n(.*?)\n---\n?(.*)$', 'Singleline')
        if (-not $m.Success) {
            Write-Warn ("{0}: no parseable frontmatter, skipped" -f $note.FileName)
            continue
        }

        $front = $m.Groups[1].Value
        $body  = $m.Groups[2].Value
        $lines = @($front -split "`n")

        $out       = New-Object System.Collections.Generic.List[string]
        $hasDate   = $false

        for ($i = 0; $i -lt $lines.Count; $i++) {
            $line = $lines[$i]

            # Blog schema differs from the vault: publish -> draft, no state,
            # and description is intentionally not carried over.
            # `publish:` is usually followed by an indented list item
            # (`  - True`), so the whole key block has to be skipped together;
            # otherwise that item gets absorbed by the preceding list.
            if ($line -match '^(publish|state|description)\s*:') {
                $grab = Get-ListItemRange -Source $lines -StartIndex $i
                $i = $grab.Next - 1
                continue
            }

            if ($line -match '^date\s*:\s*(.*)$') {
                if ([string]::IsNullOrWhiteSpace($Matches[1])) {
                    $fallback = (Get-Item -LiteralPath $note.FullPath).LastWriteTime.ToString('yyyy-MM-dd')
                    $out.Add("date: $fallback")
                    Write-Warn ("{0}: date was empty, used file date {1}" -f $note.FileName, $fallback)
                } else {
                    $out.Add($line)
                }
                $hasDate = $true
                continue
            }

            # `tags:` with no value parses to null, which the schema rejects.
            if ($line -match '^(tags|categories)\s*:\s*(.*)$') {
                $key  = $Matches[1]
                $rest = $Matches[2].Trim()

                if ($rest -eq '') {
                    $grab = Get-ListItemRange -Source $lines -StartIndex $i
                    if ($grab.Items.Count -eq 0) {
                        $out.Add("${key}: []")
                        Write-Warn ("{0}: {1} was empty, wrote {1}: []" -f $note.FileName, $key)
                        $i = $grab.Next - 1
                        continue
                    }
                }
                $out.Add($line)
                continue
            }

            $out.Add($line)
        }

        if (-not $hasDate) {
            $fallback = (Get-Item -LiteralPath $note.FullPath).LastWriteTime.ToString('yyyy-MM-dd')
            $out.Add("date: $fallback")
            Write-Warn ("{0}: had no date field, added {1}" -f $note.FileName, $fallback)
        }

        $out.Add('draft: false')

        $staged = "---`n" + ($out -join "`n") + "`n---`n" + $body
        $target = Join-Path $StageDir $note.FileName
        # UTF-8 without BOM, LF endings: what Astro expects.
        [System.IO.File]::WriteAllText($target, $staged, (New-Object System.Text.UTF8Encoding($false)))
        $written++
    }

    if ($written -eq 0) { throw 'Nothing survived normalisation.' }
    Write-Ok ("{0} file(s) staged" -f $written)

    # -- 3. Validate --------------------------------------------------------

    Write-Step '[3/6] Validating the batch with a throwaway build ...'

    $check = Invoke-NpmBuild -PostsDirOverride $StageDir -OutDir $DistDir
    if ($check.Code -ne 0) {
        $check.Output | Select-Object -Last 25 | ForEach-Object { Write-Detail $_ }
        throw 'Validation build failed.'
    }
    Write-Ok 'validation build passed'

    # -- 4. Replace ---------------------------------------------------------

    Write-Step '[4/6] Replacing src/content/posts/ ...'

    $removed = 0
    $old = @(Get-ChildItem -LiteralPath $PostsDir -Filter '*.md' -File -ErrorAction SilentlyContinue)
    foreach ($f in $old) {
        Remove-Item -LiteralPath $f.FullName -Force
        $removed++
    }

    foreach ($f in Get-ChildItem -LiteralPath $StageDir -Filter '*.md' -File) {
        Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $PostsDir $f.Name) -Force
    }

    # The content index caches entry metadata; a wholesale swap would otherwise
    # leave stale entries behind.
    $astroCache = Join-Path $BlogRoot '.astro'
    if (Test-Path -LiteralPath $astroCache) {
        Remove-Item -LiteralPath $astroCache -Recurse -Force -ErrorAction SilentlyContinue
    }

    Write-Ok ("removed {0}, wrote {1}" -f $removed, $written)

    # -- 5. Build and commit ------------------------------------------------

    Write-Step '[5/6] Building and committing ...'

    $final = Invoke-NpmBuild -PostsDirOverride '' -OutDir (Join-Path $BlogRoot 'dist')
    if ($final.Code -ne 0) {
        $final.Output | Select-Object -Last 25 | ForEach-Object { Write-Detail $_ }
        throw 'Production build failed after the swap. Files are in place but nothing was committed.'
    }
    Write-Ok 'production build passed'

    & git -C $BlogRoot add -A | Out-Null
    if ($LASTEXITCODE -ne 0) { throw 'git add failed.' }

    & git -C $BlogRoot diff --cached --quiet
    if ($LASTEXITCODE -eq 0) {
        Write-Warn 'No changes to commit: the blog already matches the vault.'
        Write-Host "`n[DONE] Nothing to push." -ForegroundColor Yellow
        Remove-TempRoot
        exit 0
    }

    $message = "Publish $written note(s) from the vault`n`nCo-Authored-By: Claude Code <noreply@anthropic.com>"
    & git -C $BlogRoot commit -q -m $message
    if ($LASTEXITCODE -ne 0) { throw 'git commit failed.' }

    $sha = (& git -C $BlogRoot rev-parse --short HEAD).Trim()
    Write-Ok ("committed {0}" -f $sha)

    # -- 6. Push ------------------------------------------------------------

    Write-Step '[6/6] Pushing to origin/main ...'

    $delays = @(2, 4, 8)
    $pushed = $false

    for ($attempt = 1; $attempt -le 3; $attempt++) {
        $pushLog = & git -C $BlogRoot push origin main 2>&1
        if ($LASTEXITCODE -eq 0) { $pushed = $true; break }

        $reason = ($pushLog | Select-Object -Last 1)
        if ($attempt -lt 3) {
            $wait = $delays[$attempt - 1]
            Write-Warn ("attempt {0}/3 failed: {1}" -f $attempt, $reason)
            Write-Detail ("retrying in {0}s" -f $wait)
            Start-Sleep -Seconds $wait
        } else {
            Write-Fail ("attempt {0}/3 failed: {1}" -f $attempt, $reason)
        }
    }

    if (-not $pushed) {
        Write-Host ''
        Write-Host '[PUSH FAILED] The commit is saved locally and posts are in place.' -ForegroundColor Red
        Write-Host '  Push manually once the network recovers:' -ForegroundColor Yellow
        Write-Host "    git -C `"$BlogRoot`" push origin main" -ForegroundColor White
        Write-Host '  Or undo the commit entirely:' -ForegroundColor Yellow
        Write-Host "    git -C `"$BlogRoot`" reset --hard HEAD~1" -ForegroundColor White
        $exitCode = 1
    } else {
        Write-Ok 'pushed to origin/main'
        Write-Host ''
        Write-Host ("[DONE] {0} note(s) published. Commit {1}." -f $written, $sha) -ForegroundColor Green
        Write-Host '       Actions needs 1-2 min, then: https://bornfreeyan.github.io/Blog/' -ForegroundColor DarkGray
    }
}
catch {
    Write-Host ''
    Write-Fail $_.Exception.Message
    Write-Host "`n[ABORTED] src/content/posts/ was not modified." -ForegroundColor Red
    $exitCode = 1
}
finally {
    Remove-TempRoot
    Write-Detail 'temp directory cleaned up.'
}

exit $exitCode
