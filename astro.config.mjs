import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// GitHub Pages project site: https://bornfreeyan.github.io/Blog/
export default defineConfig({
  site: 'https://bornfreeyan.github.io',
  base: '/Blog',
  trailingSlash: 'ignore',
  build: { format: 'directory' },
  integrations: [sitemap()],
  markdown: {
    shikiConfig: {
      theme: 'github-dark-dimmed',
      // code scrolls rather than wraps: wrapped code loses its indentation cues
      wrap: false,
    },
  },
});
