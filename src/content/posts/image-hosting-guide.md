---
title: 搭建国内外图床教程（转载）
date: 2026-11-08
summary: 从 Cloudflare-ImgBed 零成本部署，到用 Gitea + StackEdit 搭一个国内可访问的图床，两条路线都走一遍。
categories:
  - 技术博客
tags:
  - 图床
  - Cloudflare
  - Gitea
  - Markdown
draft: false
---

> 最近有搭建博客的想法，之前搭建过一个 cloudflare 的图床，但国内访问不稳定，遂又搭建了一个方便国内访问的 gitea 图床。
> 以下文章**均为转载**，已标明原文作者和链接，如有侵权请联系删除

---

## 文章1：不需要服务器，0成本，搭建属于自己的个人图床

> **作者**：fqzlr（番茄主理人）
> **发布日期**：2026-05-07
> **原文链接**：<https://blog.fqzlr.top/posts/tech/personal-img-bed/>

### 什么是图床

简单说就是一个专门存图片、能生成图片链接的服务。写博客、发公众号、做文档的时候经常会用到，有了图床就不用把图片塞在项目里占空间，也不用担心某个平台的图片链接失效。

市面上免费图床不少，但第三方图床总有跑路风险。自己搭一个最安心，而且用 Cloudflare 的方案完全免费。

### 为什么选 Cloudflare-ImgBed

这个项目（[github.com/MarSeventh/CloudFlare-ImgBed](https://github.com/MarSeventh/CloudFlare-ImgBed)）支持多种存储方式（R2、KV、D1、Telegram），部署在 Cloudflare Workers 上，全球 CDN 加速，而且支持通过 GitHub Actions 自动更新。

核心优势：零成本、无服务器、全球加速、数据可控。

### 准备工作

需要这些东西，后面一步步拿：

- GitHub 账号
- Cloudflare 账号（免费注册）
- Cloudflare Account ID
- Cloudflare API Token
- KV 或 D1 数据库（二选一）

不需要装任何软件，全程浏览器操作。

### 部署步骤

#### 第一步：Fork 项目

打开 [CloudFlare-ImgBed](https://github.com/MarSeventh/CloudFlare-ImgBed) 仓库，点右上角 Fork。

#### 第二步：获取 Cloudflare 信息

**拿 Account ID 和 API Token：**

1. 登录 [Cloudflare Dashboard](https://dash.cloudflare.com/)
2. 右上角头像 → **我的个人资料** → **API 令牌**
3. 创建令牌，选模板「编辑 Cloudflare Workers」，一路下一步
4. 生成的 Token **立刻复制保存**，它只显示一次
5. 回到 Dashboard 首页，右侧复制 Account ID

**创建数据库（KV 和 D1 二选一）：**

方案 A - KV（读写更快）：

1. 存储和数据库 → Workers KV → 创建
2. 名称填 `img_url`
3. 复制命名空间 ID

方案 B - D1（免费额度更高）：

1. 存储和数据库 → D1 SQL 数据库 → 创建
2. 名称填 `img_d1`
3. 复制数据库 ID
4. 进入控制台，执行项目提供的 `init.sql` 初始化

**可选：创建 R2 存储桶**（用来存图片）

存储和数据库 → R2 对象存储 → 创建，名称随意。

#### 第三步：配置 GitHub Secrets

进入你 Fork 的仓库 → Settings → Secrets and variables → Actions → New repository secret，依次添加：

| Secret 名称 | 值 | 必填 |
| --- | --- | --- |
| `CLOUDFLARE_API_TOKEN` | 你的 API Token | 是 |
| `CLOUDFLARE_ACCOUNT_ID` | 你的 Account ID | 是 |
| `KV_NAMESPACE_ID` | KV 命名空间 ID | KV/D1 二选一 |
| `D1_DATABASE_ID` | D1 数据库 ID | KV/D1 二选一 |
| `R2_BUCKET_NAME` | R2 存储桶名 | 可选 |

注意一定要用 **Secrets** 而不是 Variables，Variables 是公开的。

#### 第四步：部署

1. 进入仓库 Actions 页面
2. 选择 **Deploy to Cloudflare Workers**
3. 点 **Run workflow**，分支选 main
4. 等 1-3 分钟

看到绿色勾就部署成功了。

如果想以后自动同步上游更新，可以启用 **Upstream Sync** workflow，以后上游有新版本会自动同步并重新部署。

### 部署后

访问 Worker 地址就能使用图床了。不过第一次使用需要先在后台管理面板配置存储渠道（R2 或 Telegram），配好之后才能正常上传图片。

### 常见问题

- **部署失败**：检查 Secrets 有没有填错，Token 权限对不对
- **无法上传图片**：还没配置存储渠道，去后台绑定 R2 或 Telegram
- **链接打不开**：确认 Worker 已启用，名称和子域名拼写正确

> 文字版教程：[fqzlr.com/posts/blog/img-bed](https://fqzlr.com/posts/blog/img-bed/)
>
> 视频链接：[BV1MFRtBbE9B](https://www.bilibili.com/video/BV1MFRtBbE9B)
>
> 项目地址：[github.com/MarSeventh/CloudFlare-ImgBed](https://github.com/MarSeventh/CloudFlare-ImgBed)

*本文内容版权归原作者 fqzlr 所有，此处保存仅供个人阅读备份。*

---

## 文章2：用 Gitea 给 StackEdit 搭一个「图床」

> **作者**：码事漫谈
> **发布日期**：2025-10-31
> **原文链接**：<https://juejin.cn/post/7567251884826689542>
>
> 关键词：StackEdit、Gitea、图床、OAuth2、Markdown —— 十分钟配置，终身免折腾。

### 1. 为什么要自己折腾

- 公有图床随时挂 / 防盗链
- 完全免费
- Git 仓自带版本管理，图片也能回滚
- 写完 Markdown `push` 即发布，一次配置，全平台通用

### 2. 最终效果

在 StackEdit 里：

1. `Ctrl+V` 粘贴图片 → 自动上传到你的 Gitea 仓库
2. 生成的 Markdown 链接永久可用，自带 CDN 加速（jsDelivr 可再套一层，本文不提）

### 3. 准备工作

1. 一个 **Gitea 账号**（示例用官方站 [gitea.com](https://gitea.com)，自建同理）
2. 新建 **公开仓库** `img`（私有仓也能用，但公有仓方便直链）
3. StackEdit 中文版 → [stackedit.cn](https://stackedit.cn) 登录（GitHub / Gitee 一键登录即可）

### 4. 步骤总览

| 阶段 | 目标 |
| --- | --- |
| ① | 在 Gitea 创建 OAuth2 应用，拿到 `Client ID / Secret` |
| ② | 把 ID 和 Secret 填回 StackEdit，完成授权 |
| ③ | 配置图床路径（按日期分文件夹） |
| ④ | 测试粘贴图片，验证成功 |

### 5. 详细操作

#### 5.1 创建 OAuth2 应用

1. 登录 Gitea → 右上角头像 → **Settings** → **Applications** → **OAuth2 Applications** → **Create a new OAuth2 Application**
2. 填写内容
   - **Application Name（应用名称）**：`StackEditCN`（随意）
   - **Redirect URI（重定向URI）**：必须填 `https://stackedit.cn/oauth2/callback`
3. 点击 **Create** 之后会看到
   - Client ID → 对应 StackEdit 的 **Application ID**
   - Client Secret → 对应 StackEdit 的 **Application Secret**（只显示一次，先复制到记事本）

#### 5.2 在 StackEdit 里绑定 Gitea

1. 打开 StackEdit 图片设置
2. 在弹出框里填写
   - **Gitea URL**：`https://gitea.com`（注意：只填域名，别带仓库路径）
   - **Application ID**：刚才的 **Client ID**
   - **Application Secret**：刚才的 **Client Secret**
3. 点击 **Confirm**，页面会跳到 Gitea 询问授权 → **Allow** → 自动回到 StackEdit，绑定完成
4. 再次进入 **Gitea 设置**（同一窗口）：

| 字段 | 推荐值 | 说明 |
| --- | --- | --- |
| **Repository URL** | `https://gitea.com/<你的用户名>/img` | 不带 `.git` |
| **Folder Path** | `imgs/{YYYY}-{MM}-{DD}` | 自动按日期归档 |
| **Branch** | `master` 或 `main` | 看你仓库默认分支 |

点击 **Confirm** 保存。

#### 5.3 上传测试

1. 新建或打开任意 Markdown
2. 直接 `Ctrl+V` 粘贴一张截图
3. 观察编辑器内链接变为 `https://gitea.com/xxx/raw/branch/...` → 成功
4. 回到仓库页面，能看到对应日期文件夹里多了一张图片

### 6. 常见问题速查

| 现象 | 解决 |
| --- | --- |
| 授权后 404 | **Gitea URL** 填成了仓库地址，应只填域名 |
| 上传失败 403 | 仓库是私有的，把链接前面的 `raw` 换成 `media` 需带 token；或干脆用公开仓 |
| 想换路径 | 修改 **Folder Path** 即可，老图片不动，新图片走新目录 |

### 7. 进阶玩法（本文不展开）

- jsDelivr 加速：`https://cdn.jsdelivr.net/gh/<用户>/img@master/imgs/2025-10-31/pic.png`
- PicGo + Gitea 插件，本地截图一键传
- 私有仓 + Personal Access Token，CI 自动部署

*本文内容版权归原作者「码事漫谈」所有，此处保存仅供个人阅读备份。*
