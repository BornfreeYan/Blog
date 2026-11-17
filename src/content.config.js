import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

/**
 * URL slug for a post, derived from its file name.
 *
 * Astro's default slugger collapses `.` into nothing, so notes named the way
 * this vault names them (`1.Python.md`) end up at `/article/1python/`. This
 * turns every run of non-alphanumeric characters into a single hyphen:
 *
 *   1.Python.md          -> 1-python
 *   2.FastAPI.md         -> 2-fastapi
 *   Git-version-control  -> git-version-control
 *
 * Only the `entry` path is used, never the frontmatter, so renaming a title
 * never moves a URL.
 */
function postId({ entry, base }) {
  const relative = entry.startsWith(base) ? entry.slice(base.length) : entry;
  return relative
    .replace(/\.mdx?$/i, '')
    .replace(/[^a-zA-Z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .toLowerCase();
}

// Articles: one markdown file per post in src/content/posts/.
// The file name becomes the URL slug: hello-world.md -> /article/hello-world/
//
// POSTS_DIR lets the publish script validate a staged batch without touching
// src/content/posts/ first: it points this at a temp folder, runs a build, and
// only promotes the files once the build passes. Unset in normal use.
// The glob loader wants either a root-relative path or an absolute file URL.
const postsBase = process.env.POSTS_DIR
  ? pathToFileURL(path.resolve(process.env.POSTS_DIR)).href
  : './src/content/posts';

const posts = defineCollection({
  loader: glob({
    pattern: '**/*.md',
    base: postsBase,
    generateId: postId,
  }),
  schema: z.object({
    title: z.string(),
    date: z.coerce.date(),
    summary: z.string().optional(),
    categories: z.array(z.string()).default([]),
    tags: z.array(z.string()).default([]),
    draft: z.boolean().default(false),
  }),
});

// Standalone pages written in markdown (About). Not listed anywhere.
const pages = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/pages' }),
  schema: z.object({
    title: z.string().optional(),
  }),
});

export const collections = { posts, pages };
