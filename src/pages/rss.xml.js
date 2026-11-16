import rss from '@astrojs/rss';
import { getPosts } from '../lib/posts.js';
import { url } from '../lib/url.js';

export async function GET(context) {
  const posts = await getPosts();

  return rss({
    title: "Yan's Blog",
    description: 'Notes, projects, and technical retrospectives.',
    site: new URL(import.meta.env.BASE_URL, context.site).href,
    items: posts.map((post) => ({
      title: post.data.title,
      pubDate: post.data.date,
      description: post.data.summary ?? '',
      link: url(`article/${post.id}/`),
      categories: [...post.data.categories, ...post.data.tags],
    })),
    customData: '<language>zh-cn</language>',
  });
}
