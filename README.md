# Yan's Blog

A terminal-flavoured personal blog built with [Astro](https://astro.build). Static output, handwritten CSS, close to zero JavaScript.

Live at <https://bornfreeyan.github.io/Blog/>.

## Writing an article

Drop a markdown file into `src/content/posts/`. The file name becomes the slug:

```
src/content/posts/hello-world.md  ->  /article/hello-world/
```

Frontmatter:

```yaml
---
title: 文章标题
date: 2026-11-16
summary: 一句话摘要，显示在列表和 RSS 里（可省略，省略时取正文第一句）
categories:
  - CS
tags:
  - Astro
draft: false
---
```

Set `draft: true` to keep a post out of every listing, feed and route.

## Adding a project

Edit `src/data/projects.json`. Order in the file is the order on the page — no dates involved.

```json
{
  "name": "Project name",
  "desc": "One line description.",
  "href": "https://github.com/BornfreeYan/repo",
  "repo": "BornfreeYan/repo",
  "tags": ["Astro", "CSS"]
}
```

`repo` drives the star count: the page fetches `api.github.com/repos/<repo>` in the browser, caches the result for an hour, and hides the stat on any failure. Omit `repo` for non-GitHub links.

## Commands

```bash
npm install       # install dependencies
npm run dev       # dev server at localhost:4321/Blog
npm run build     # static build into dist/
npm run preview   # serve the built site
```

Use **npm** on this machine — pnpm's default linker needs junctions, which don't resolve here.

## Deploying

Push to `main`. `.github/workflows/deploy.yml` builds the site and publishes `dist/` to GitHub Pages.

The repo is a project site, so `astro.config.mjs` sets `base: '/Blog'`. If the site ever moves to a user/org root (`<name>.github.io`), delete that line and set `site` to the new origin.

## Layout

```
src/
  content/posts/       articles (markdown)
  content/pages/       standalone pages, e.g. about.md
  data/projects.json   project list
  data/site.js         bio + social links
  layouts/Base.astro   html shell, header, footer
  components/          Header, Footer, PageHeader, SectionHeader, ListRow, TimelineRow
  pages/               index, article/index, article/[id], project/index, about, rss.xml.js
  styles/
    tokens.css         every color, size and spacing value
    global.css         reset, layout, UI components
    prose.css          rendered markdown
```

## Design notes

- All colors come from `tokens.css`. No raw hex values elsewhere.
- Five signature elements carry across every page: monospace type with `0.5px` tracking, an amber full stop after large titles, a hatched square before section titles, dotted leaders between a title and its metadata, and hairline rules with generous whitespace.
- Three listing layouts, one type scale: Home uses leaders, Article uses a timeline, Project uses leaders in JSON order.
- Dark only for now. A light theme would be a second `:root` block overriding the same variable names.
