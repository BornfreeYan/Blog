/**
 * Site-wide content that isn't a collection: the bio block and social links.
 * Edit this file to change the Home page intro without touching markup.
 */
export const site = {
  name: 'Yan',
  handle: 'BornfreeYan',
  bio: [
    'Hi, 这里是 <strong>Yan</strong>，技术 ID 为 <strong>BornfreeYan</strong>。欢迎访问我的 Blog，这里记录了我的学习笔记、技术实践和项目复盘，也会偶尔写一些生活观察。',
    '希望我的 Blog 可以为你带来价值！',
  ],
  links: [
    { label: 'Homepage', href: '#' },
    { label: 'GitHub', href: 'https://github.com/BornfreeYan' },
    { label: 'Bilibili', href: '#' },
    { label: 'Redbook', href: '#' },
    { label: 'Instagram', href: '#' },
    { label: 'Email', href: 'mailto:' },
  ],
  homeArticleCount: 5,
  projectArticleCount: 5,
};
