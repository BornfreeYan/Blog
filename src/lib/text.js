/**
 * Rough word count / reading time for mixed Chinese + English text.
 * Chinese is counted per character (300 chars/min), English per word (200 w/min).
 */
export function countText(body = '') {
  const text = String(body)
    .replace(/```[\s\S]*?```/g, ' ')
    .replace(/`[^`]*`/g, ' ')
    .replace(/!\[[^\]]*\]\([^)]*\)/g, ' ')
    .replace(/\[([^\]]*)\]\([^)]*\)/g, '$1')
    .replace(/^\s{0,3}#{1,6}\s+/gm, '')
    .replace(/https?:\/\/\S+/g, ' ')
    .replace(/[*_>~|#-]/g, ' ');

  const cjk = (text.match(/[㐀-䶿一-鿿぀-ヿ가-힯]/g) || []).length;
  const latin = (text.match(/[A-Za-z0-9][A-Za-z0-9'’._-]*/g) || []).length;

  return {
    words: cjk + latin,
    minutes: Math.max(1, Math.ceil(cjk / 300 + latin / 200)),
  };
}
