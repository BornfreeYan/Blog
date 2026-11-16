/** ISO-style date, always UTC so a date never shifts by a day. */
export function isoDate(value) {
  const d = value instanceof Date ? value : new Date(value);
  const y = d.getUTCFullYear();
  const m = String(d.getUTCMonth() + 1).padStart(2, '0');
  const day = String(d.getUTCDate()).padStart(2, '0');
  return `${y}-${m}-${day}`;
}
