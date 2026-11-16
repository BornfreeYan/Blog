const BASE = import.meta.env.BASE_URL;

/**
 * Build an internal URL that respects the configured `base`.
 * url('article/') -> '/Blog/article/'
 */
export function url(path = '') {
  const base = BASE.endsWith('/') ? BASE : `${BASE}/`;
  return base + String(path).replace(/^\/+/, '');
}

/**
 * Is `pathname` inside the given top-level section?
 * Used for the nav's aria-current.
 */
export function isActive(pathname, section = '') {
  const base = BASE.replace(/\/$/, '');
  const rel = String(pathname ?? '')
    .slice(base.length)
    .replace(/^\/+|\/+$/g, '');
  if (!section) return rel === '';
  return rel === section || rel.startsWith(`${section}/`);
}
