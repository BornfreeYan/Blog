import { getCollection } from 'astro:content';

/**
 * Published posts, newest first.
 * `draft: true` entries are dropped from every listing, feed and route.
 */
export async function getPosts() {
  const posts = await getCollection('posts', ({ data }) => !data.draft);
  return posts.sort((a, b) => b.data.date.valueOf() - a.data.date.valueOf());
}

/** URL path for a post entry. */
export function postHref(entry) {
  return `article/${entry.id}/`;
}

/** Strips inline markdown down to readable text. */
function toPlainText(markdown) {
  return String(markdown)
    .replace(/```[\s\S]*?```/g, ' ')
    .replace(/!\[[^\]]*\]\([^)]*\)/g, ' ')
    .replace(/\[([^\]]*)\]\([^)]*\)/g, '$1')
    .replace(/^\s{0,3}#{1,6}\s+/gm, '')
    .replace(/^>\s?/gm, '')
    .replace(/[*_`~]/g, '')
    .replace(/\s+/g, ' ')
    .trim();
}

/** Trims to a sentence-ish length without cutting mid-word where avoidable. */
function clamp(text, limit = 110) {
  if (text.length <= limit) return text;
  return `${text.slice(0, limit).trim()}…`;
}

/**
 * The blurb shown under a post's title in listings.
 *
 * Order of preference:
 *   1. a `summary` in frontmatter, when the author set one
 *   2. the first blockquote in the body — the convention for a hand-written
 *      intro, since `> …` right under the frontmatter reads as a standfirst
 *   3. the first paragraph
 *
 * Headings are skipped: on these notes the first thing after the frontmatter
 * is usually `## Intro`, which says nothing.
 */
export function postSummary(entry) {
  if (entry.data.summary) return clamp(entry.data.summary, 160);

  const body = String(entry.body || '').replace(/^---[\s\S]*?---/, '');
  const lines = body.split('\n');

  let inFence = false;
  let block = [];
  let blockKind = null; // 'quote' | 'para'

  const flush = () => ({ kind: blockKind, lines: block });

  for (const raw of lines) {
    const line = raw.trim();

    if (line.startsWith('```')) {
      inFence = !inFence;
      if (block.length) return fromBlock(flush());
      continue;
    }
    if (inFence) continue;

    if (line === '') {
      if (block.length) return fromBlock(flush());
      continue;
    }

    const isQuote = line.startsWith('>');
    const isHeading = /^#{1,6}\s/.test(line);
    const isList = /^([-*+]|\d+\.)\s/.test(line);
    const isRule = /^(-{3,}|\*{3,}|_{3,})$/.test(line);

    // Only the first meaningful block counts. Headings and rules are skipped
    // so a leading `## Intro` does not become the summary of the next thing.
    if (isHeading || isRule) {
      if (block.length) return fromBlock(flush());
      continue;
    }

    if (isQuote) {
      if (blockKind === 'para') return fromBlock(flush());
      blockKind = 'quote';
      block.push(line.replace(/^>\s?/, ''));
      continue;
    }

    // A list is only meaningful as part of a quote (numbered intro points).
    if (isList) {
      if (blockKind === 'quote') {
        block.push(line);
        continue;
      }
      if (block.length) return fromBlock(flush());
      continue;
    }

    if (blockKind === 'quote') return fromBlock(flush());
    blockKind = 'para';
    block.push(line);
  }

  return block.length ? fromBlock(flush()) : '';

  function fromBlock({ kind, lines: blockLines }) {
    const text = toPlainText(blockLines.join(' '));
    if (text) return clamp(text);
    return kind === 'quote' ? '' : clamp(text);
  }
}
