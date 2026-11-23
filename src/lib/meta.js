import { url } from './url.js';

const ABSOLUTE_URL = /^https?:\/\//i;

/** Absolute http(s) URL? Used to decide whether a path needs the site/base prefix. */
export function isAbsoluteUrl(value) {
  return ABSOLUTE_URL.test(String(value ?? '').trim());
}

/**
 * An image URL suitable for og:image / twitter:image.
 *
 * Covers are usually hosted on an image bed, so absolute URLs are passed
 * through untouched. Anything else is treated as a site-relative path and
 * resolved against the origin + BASE_URL (`/Blog` on GitHub Pages):
 *
 *   /covers/a.png  -> https://bornfreeyan.github.io/Blog/covers/a.png
 *   https://...    -> https://...
 */
export function absoluteImage(image, site) {
  const value = String(image ?? '').trim();
  if (!value) return null;
  if (ABSOLUTE_URL.test(value)) return value;
  if (!site) return null;
  return new URL(url(value), site).href;
}

/**
 * Absolute canonical URL for the current page.
 *
 * `Astro.url.pathname` already includes BASE_URL, so strip it first and let
 * `url()` add it back. That keeps the result identical in dev (where the
 * pathname is `/Blog/...`) and in the static build, without hardcoding the
 * domain or the base in a layout.
 */
export function canonicalUrl(pathname, site) {
  if (!site) return null;

  const base = import.meta.env.BASE_URL.replace(/\/$/, '');
  let path = String(pathname ?? '/');

  if (base && (path === base || path.startsWith(`${base}/`))) {
    path = path.slice(base.length);
  }

  return new URL(url(path || '/'), site).href;
}
