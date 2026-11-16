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

/** A short description for listings: explicit summary, else the first paragraph. */
export function postSummary(entry) {
  if (entry.data.summary) return entry.data.summary;

  const body = String(entry.body || '')
    .replace(/^---[\s\S]*?---/, '')
    .replace(/```[\s\S]*?```/g, ' ')
    .replace(/^\s{0,3}#{1,6}\s+.*$/gm, '')
    .replace(/!\[[^\]]*\]\([^)]*\)/g, ' ')
    .replace(/\[([^\]]*)\]\([^)]*\)/g, '$1')
    .replace(/^>\s?/gm, '')
    .replace(/[*_`~]/g, '')
    .replace(/\s+/g, ' ')
    .trim();

  const firstPara = body.split(/(?<=[。！？.!?])\s*/)[0] || body;
  return firstPara.length > 110 ? `${firstPara.slice(0, 110).trim()}…` : firstPara;
}
