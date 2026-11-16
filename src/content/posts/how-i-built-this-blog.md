---
title: How I Built This Blog
date: 2026-11-16
summary: A terminal-flavoured Astro blog in about 400 lines of CSS, and why every page shares the same skeleton.
categories:
  - CS
tags:
  - Astro
  - CSS
  - JavaScript
draft: false
---

This site is built with **Astro**, plain CSS, and almost no JavaScript. This post walks through the decisions behind it — mostly so future me remembers why some things are the way they are.

## Why Astro

The requirements were narrow: markdown articles, a JSON-driven project list, and full control over the CSS. Astro handles all three without a framework runtime.

- Content collections read markdown at build time and hand back typed frontmatter
- `import projects from '../data/projects.json'` just works
- The output is static HTML with zero JavaScript unless a page asks for it

The alternative — a theme-driven generator like Hexo — would have meant fighting someone else's template to get this exact look.

## The design language

Everything comes from a token file. No raw hex values appear anywhere else:

```css
:root {
  --bg: #121212;
  --text: #d4d4d4;
  --accent: #d2994a;
  --accent-soft: #d4ba85;
  --border: #333333;
  --font-mono: "SFMono-Regular", Consolas, Menlo, monospace;
}
```

Five signature elements carry the identity across pages:

1. Monospace type with `0.5px` tracking
2. An amber full stop after every large title
3. A hatched square before every section title
4. Dotted leaders between a title and its metadata
5. Hairline `1px` rules and a lot of empty space

### Lists, three ways

Each listing keeps the same type scale and hover colour but changes its metadata slot:

| Page | Layout | Order |
| --- | --- | --- |
| Home | title … date | newest first |
| Article | timeline, dot on a rail | newest first |
| Project | title … language | JSON order, no timeline |

That last row matters: a project list ordered by date is a lie about how projects work.

## Small details worth keeping

> Good defaults beat configuration. Every link hovers to the same amber, every focus ring is the same `1px` outline, and nothing italicises.

A few things I had to get right:

1. **Contrast** — `#737373` on `#121212` is only ~4:1, below AA for small text. Body-adjacent greys moved up to `#808080`; `#666666` is now decorative only.
2. **Code blocks** — Shiki writes an inline background. Left alone, every block is a foreign slab of colour, so `pre` gets `background-color: var(--bg-elev) !important`.
3. **Reduced motion** — `prefers-reduced-motion` kills the transitions. The reading progress ring still updates, it just doesn't glide.

## What is deliberately missing

No light theme yet, no comments, no analytics, no client-side search. Each one is a real feature and each one can wait until the writing habit exists.

The theme button from the prototype is gone rather than disabled — a control that does nothing is worse than no control.

## Next

The list is short: deploy on a push, keep the CSS honest, and write more than I refactor.
