---
title: HTML
date: 2026-11-23
tags:
  - HTML
categories:
  - CS
draft: false
---
> 参考课程：[3小时前端三件套速成](https://www.bilibili.com/video/BV1BT4y1W7Aw/?share_source=copy_web&vd_source=f290db4430dc60ad19d813119d3e7628)+[html强化](https://youtu.be/CLUPkcLQm64?si=P1gElt8uUWe-wfoC)

## HTML

HTML(Hypertext Markup Language)是超文本标记语言，用于创建网页的结构和内容。
HTML 是 Web 页面的基础，它描述了页面的语义结构，使浏览器能够正确地显示和解释内容。它使用一系列的标签（也称为元素）来定义文本、图像、链接、表格等在网页上的排布和呈现方式。
标签可以成对出现，称为双标签，比如：

```html
<p>这是一个段落。</p>
```

除了双标签，也存在单标签。单标签通常用于表示**没有内容的元素**，因为内部没有内容，它们以自封闭的方式出现，不需要闭合标签。
如`<img src="image.jpg" />`插入图片，`br`换行。

### 结构简介

一个 HTML 文档通常由以下部分组成：

```HTML
<!DOCTYPE html>
<html>

<head>
    <!-- 这里放置文档的元信息 -->
    <title>文档标题</title>
    <meta charset="UTF-8">
    <!-- 连接外部样式表或脚本文件等 -->
    <link rel="stylesheet" type="text/css" href="styles.css">
    <script src="script.js"></script>
</head>

<body>
<!-- 这里放置页面内容 -->
<h1>这是一个标题</h1>
<p>这是一个段落。</p>
<a href="https://www.example.com">这是一个链接</a>
<!-- 其他内容 -->
</body>

</html>
```

- `<!DOCTYPE html>`：声明文档类型为 HTML5。
- `<html>`：HTML 文档的根元素，包含了整个文档的内容。
- `<head>`：包含一些文档的元信息，如标题、字符编码等。
- `<title>`：定义网页标题，会显示在浏览器的标签页上。
- `<body>`：包含实际的页面内容。

> 可以输入一个!，再tab，那些head等文档声明、元信息，就会自动写入

### 语法

1. `文本内容`：使用 `<p>` 标签定义段落，`<h1>` 到 `<h6>` 标签定义标题，`<strong>`、`<del>` 和 `<em>` 标签可以用于强调文本。

```html
<h1>这是一个一级标题</h1>
<h2>这是一个二级标题</h2>
	<h3>这是一个三级标题</h3>
	<h4>这是一个四级标题</h4>
	<h5>这是一个五级标题</h5>
	<h6>这是一个六级标题</h6>
	<p>这是一个段落。</p>
	<p><strong>重要信息：</strong>这是一个重要的内容。</p>
```

> 标题或者段落的缩进没有任何作用，只能说在 HTML 代码块中会方便查看相互关系，缩进要依靠 CSS才能显示出来。
> 预览可以右键，然后点击 Open with Live Server。
> 有安装 AutoRenamed Tag 插件的改动，左标签、右标签也会随之而动。

| 字体   | 符号                   | 英文                           |
| ------ | ---------------------- | ------------------------------ |
| 加粗   | `<strong> </strong>` | 顾名思义 粗 也可用`<b>`,bold |
| 斜体   | `<em> </em>`         | emphasis 强调                  |
| 下划线 | `<u> </u>`           | underline                      |
| 删除线 | `<del> </del>`       | delete                         |

2.`列表`： 使用 `<ul>` 和 `<li>` 标签创建无序列表，使用 `<ol>` 和 `<li>` 标签创建有序列表。(unordered list 和 ordered list)

```html
<ul>
    <li>无序项目1</li>
    <li>无序项目2</li>
</ul>

<ol>
    <li>有序项目1</li>
    <li>有序项目2</li>
</ol>
```

3. `表格`： 使用 `<table>`、`<tr>`、`<td>`、`<th>` 等标签创建表格，`<table>` 是表格标签的根元素，然后是 `<tr>` 表格的行标签（Table row），在 `<tr>` 内部是列 `<td>` （Table data）与列标题 `<th>`（Table header）。border = “1”，是给表格加了个边框，引号内的数字是边框的粗细。

```html
<table border = "1">
    <tr>
        <th>列A</th>
        <th>列B</th>
        <th>列C</th>
    </tr>
    <tr>
        <td>A1</td>
        <td>B1</td>
        <td>C1</td>
    </tr>
    <tr>
        <td>A2</td>
        <td>B2</td>
        <td>C2</td>
    </tr>
</table>
```

4. `图像`： 使用 `<img>` 标签插入图像。图像常见的属性还有width宽度和height高度，可以用width = "100" height = "50"设置

```html
<img src="图片路径" alt="图片描述">
```

5. `链接`： 使用 `<a>` 标签创建链接。a 代表 anchor，也就是锚点；href 是 hypertext reference，一个超文本引用，代表着会引用到一个目标地址。如果是外链，一定要使用 HTTP 或者 HTTPS 开头，否则会当做相对路径引用。

```html
<a href="https://github.com/">访问 GitHub </a>
```

还可以添加另外一个 target 属性，target 可以等于 self、blank、parent、top，它指定了这个 URL 在浏览器的打开方式，比如说是在一个新窗口打开还是在当前窗口打开等等。
7. `注释`： 使用 `<!-- 注释内容 -->` 添加注释，不会在浏览器中显示。

```html
<!-- 这是一个注释 -->
```

### 属性

在 HTML 中，**每个元素都可以有一个或多个属性**，用于描述元素的特征和行为。属性的基本语法是：`<开始标签 属性名="属性值">`，其中属性名用于标识该属性，属性值则定义该属性的值。属性名和属性值之间用等号 =  隔开，属性值一般要用引号将其括起来，可以是单引号或双引号，示例：

```
<img src="image.png" alt="图片">
```

其中，`src` 是指定图片的文件路径的属性source，`alt` 是指定在无法加载图片时显示的替代文本的属性alternative text。这些属性可以让用户了解图像的内容，同时也有助于调整图片的大小和位置。

> 名称不区分大小写，比如 src 和大写 SRC 没有区别；但是 image 和大写 IMAGE.PNG 是有区别的，属性值对大小写敏感。

属性是用来定义元素的性质和功能的。它们可以指定元素的尺寸、颜色、文字方向、链接目标等，有助于页面的定位和布局。下面是一些常见的属性用法：

1. `class` 属性：`class` 属性是用于向元素添加一个或多个类名，以便通过 CSS 样式表定义样式。此外，类名还可以用来实现 JavaScript 的交互效果。例如：

```
<p class="note">这是一个带有 note 类属性的 p 标签</p>
```

2. `id` 属性：`id` 属性是用于将元素标识为**唯一的标识符**。它使得我们可以通过 JavaScript 或 CSS 来定位和操作该元素。例如：

```

<div id="header">这是一个带有 header id 的 div 标签</div>
```

3. `style` 属性：`style` 属性是用于将CSS样式规则直接应用于元素。它可以用于控制元素的颜色、字体、大小和布局等。例如：

```

<div style="color: red; font-size: 20px;">这是一段红色的文字</div>
```

以上三种是所有标签都有的属性，也有一些标签具有独特的属性，比如 a 标签的 href 属性，img 标签的 src 属性等等。

### 区块

当涉及到 HTML 元素时，可以将它们分为两个主要类别：`行内元素` 和 `块级元素`。这些不同类型的元素在 HTML 文档中的呈现和布局方面有很大的不同。下面是关于这两种类型的元素的详细说明：

1. `块级元素（block）`：块级元素通常用于组织和布局页面的主要结构和内容，例如段落、标题、列表、表格等。它们用于创建页面的主要部分，将内容分隔成逻辑块。
   - 块级元素**通常会从新行开始，并占据整行的宽度**，因此它们会在页面上呈现为一块独立的内容块。
   - 可以包含其他块级元素和行内元素。
   - 常见的块级元素包括 `<div>`, `<p>`, `<h1>` 到 `<h6>`, `<ul>`, `<ol>`, `<li>`, `<table>`, `<form>` 等。
2. `行内元素（inline）`：行内元素通常用于添加文本样式或为文本中的一部分应用样式。它们可以在文本中插入小的元素，例如超链接、强调文本等。
   - 行内元素通常在**同一行内呈现（即使在源代码文件中换行，网页显示出来的也是同一行），不会独占一行**。
   - 它们**只占据其内容所需的宽度，而不是整行的宽度**。
   - 行内元素不能包含块级元素，但可以包含其他行内元素。
   - 常见的行内元素包括 `<span>`, `<a>`, `<strong>`, `<em>`, `<img>`, `<br>`, `<input>` 等
     示例：

```html
<div>这是一个块级元素，它会独占一行。</div>

<p>这也是一个块级元素，通常用于段落。</p>

<a href="https://docs.geeksman.com">这是一个行内元素，它嵌套在段落中。</a>

<span>这是第二个行内元素，span用于包裹一小段文字</span>
```

### 表单form标签

HTML 表单（form）是一种重要的元素， 用于收集和提交用户输入的数据（搜索栏、手机号、短信验证码等等）。表单允许用户输入文本、选择选项、上传文件等，然后将这些数据提交到服务器进行处理。一个基本的HTML表单由以下几个主要部分组成：

1. `<form>` 元素：表单元素是表单的容器，它定义了数据提交到哪里以及使用哪种 HTTP 方法（通常是 GET 或 POST ）来提交数据。它可以包含输入字段、按钮等元素。

```html
<form action="/submit" method="post">
    <!-- 表单元素 -->
</form>
```

2. `输入字段`：`<input>` 标签是 HTML 中用于创建表单元素的最常见标签之一。它允许用户输入文本、选择选项、上传文件等等。`<input>` 元素有多个属性，用于指定不同类型的输入和控制输入的方式。以下是一些常见的 `<input>` 标签的属性和它们的详细说明：
   `type` 属性：指定输入字段的类型，它可以有以下不同的值：

- `text`：创建文本输入框，用于用户输入文本。
- `password`：创建密码输入框，输入内容会被隐藏。
- `radio`：创建单选按钮，用户只能选择一个选项。
- `checkbox`：创建复选框，用户可以选择多个选项。
- `number`：创建数字输入框，允许用户输入数字。
- `email`：创建用于输入电子邮件地址的输入框。
- `file`：创建文件上传字段，用户可以上传文件。
- `submit`：创建提交按钮，用于提交表单数据。
- `reset`：创建重置按钮，用于重置表单数据。
- `button`：创建自定义按钮，通常与 JavaScript 一起使用。

`placeholder`是文本框的背景文字（比如请输入xx内容，你一旦输入了这个背景就消失了，给用户提示作用）；而换成`value`，相当于自动填写，它不是一个真正的背景，而是真实已填入表单的信息。

```
<input type="text" name="username" placeholder="用户名">
<input type="password" name="password" placeholder="密码">
<input type="radio" name="gender" value="male"> 男
<input type="radio" name="gender" value="female"> 女
<input type="checkbox" name="subscribe" value="yes"> 订阅
<select name="country">
    <option value="zh">中国</option>
    <option value="us">美国</option>
    <!-- 其他选项 -->
</select>
```

表单元素可以包含一些属性，以指定表单的行为和样式。常见的表单属性包括：

| 属性   | 描述                                                      |
| ------ | --------------------------------------------------------- |
| action | 指定表单数据提交到服务器的 URL。                          |
| method | 指定用于提交数据的 HTTP 方法，通常为`get` 或 `post`。 |
| name   | 为表单命名，以便在 JavaScript 中引用。                    |
| target | 指定表单提交后的目标窗口或框架。                          |

表单提交方式的区别：

`get`：默认值，主动地获取方式，参数放在 URL 上，数据的容量有限，安全性差，有缓存；`post`：数据存放在请求体中，数据量理论上没有限制，相对安全，没有缓存。

最后，我们使用表单来写一个用户注册的页面，代码如下：

```
<h2>用户注册</h2>
<form action="/submit" method="post">
    <label for="username">用户名：</label>
    <input type="text"><br><br>

    <label for="password">密码：</label>
    <input type="password"><br><br>

    <label for="email">电子邮件地址：</label>
    <input type="text"><br><br>

    <label for="age">年龄：</label>
    <input type="number" width="5"><br><br>

    <label>性别：</label>
    <input type="radio" name="gender" value="male"> 男
    <input type="radio" name="gender" value="female"> 女<br><br>

    <label>喜欢的编程语言：</label>
    <input type="checkbox" name="languages" value="python"> Python
    <input type="checkbox" name="languages" value="javascript"> JavaScript
    <input type="checkbox" name="languages" value="java"> Java
    <input type="checkbox" name="languages" value="cpp"> C++<br><br>

    <input type="submit" value="提交">
</form>
```

### 补充一：`<button>` 的 `type`——表单里的按钮为什么总在「刷新页面」

什么是`<button>`?顾名思义就是一个按钮，但是它不是纯行内元素，他是一个特殊的**行内块**。这个中间态的实际含义是，它像文字一样可以待在一行里，不会被强制换行，但它又能设置 width、height、margin，而且它的内部不仅只是文字，还可以放 HTML，比如说图标。

**结论**：`<button>` 元素**不写 `type`，浏览器默认按 `type="submit"` 处理**。所以只要这个按钮在 `<form>` 里，点一下就会触发表单提交——而表单提交的默认动作是「浏览器自己发请求并把页面导航过去」，表现出来就是**页面刷新、JS 里的状态全部丢光**。

| `type`           | 作用                                          | 用在                        |
| ------------------ | --------------------------------------------- | --------------------------- |
| `submit`（默认） | 提交按钮，触发所属`form` 的 `submit` 事件 | 登录、发消息                |
| `button`         | 普通按钮，**不提交表单**，纯给 JS 用    | 会话的删除 / 重命名、切主题 |
| `reset`          | 把所有表单控件恢复成初始值                    | 少用                        |

**触发链路要记牢**（初学者最容易搞错的一环）：

```
点击 <button type="submit">
    → 浏览器给 <form> 派发一个 submit 事件（注意：是给 form，不是给按钮）
        → 如果没人阻止，浏览器执行默认行为：按 method / action 发请求并跳转页面
            → 页面刷新，JS 状态全丢
```

所以我们自己用 `fetch` 发请求时，要做的事就是**在 form 上监听 submit，然后阻止默认行为**，把「提交」拦下来自己处理。

```html
<form id="login-form">
    <input type="text" id="username" placeholder="用户名">
    <input type="password" id="password" placeholder="密码">
    <!-- 想让它提交表单的这个，明确写 submit -->
    <button type="submit">登录</button>
</form>

<!-- 表单外、纯给 JS 用的按钮，明确写 button -->
<button type="button" id="theme-toggle">切换主题</button>
```

```js
document.querySelector('#login-form').addEventListener('submit', (event) => {
    event.preventDefault();   // 关键：取消浏览器默认的「提交 + 刷新」
    const username = document.querySelector('#username').value;
    const password = document.querySelector('#password').value;
    // 之后自己用 fetch 发请求（见 JS 笔记）
    console.log(username, password);
});
```

两个补充澄清：

- `<input type="submit" value="登录">` 和 `<button type="submit">登录</button>` **都能提交**，但 `<button>` 内部可以放 HTML（图标、多个 `<span>`），所以更常用。
- 「提交」这件事只在按钮**属于某个 `<form>`**（写在 form 内，或用 `form` 属性关联）时才会发生；form 之外的按钮即便 `type="submit"` 也没表单可提交。为免歧义，form 外的按钮一律写 `type="button"`。

### 补充二：`disabled`——布尔属性与「生成中禁用发送」

**结论**：`disabled` 是**布尔属性**：只要这个属性**出现在标签里**就生效，与它的值无关。`disabled`、`disabled=""`、`disabled="disabled"`、甚至 `disabled="false"` **全都是禁用**——因为布尔属性「看有没有，不看值」。

> 同类的布尔属性还有 `checked`、`required`、`selected`、`readonly`、`autofocus`。
> 初学者常写 `disabled="false"` 想「启用」，结果还是禁用——想启用就得**整个属性不写**。

元素被禁用后，会发生四件事：

1. 变灰（浏览器的默认样式），**不再响应点击**（`click` 事件根本不会触发）；
2. 表单提交时**不会**把这个控件的数据带上；
3. 可以用伪类单独写样式：`button:disabled { ... }`；
4. JS 里读写它用**点号属性**：`el.disabled = true`（不带引号、不是 `setAttribute`）。

接不住的一个坑：**别用 `if (el.disabled)` 判断「有没有写 disabled 属性」**，它返回的是当前布尔状态，这才是你要的；但要记得 `disabled` 与 `readonly` 不一样——`readonly` 只限制「内容不能改」，输入框仍能聚焦、仍会被提交。

「生成中禁用发送」的完整写法：

```html
<div class="composer">
    <input id="msg-input" type="text" placeholder="说点什么…">
    <button id="send" type="submit">发送</button>
</div>
```

```js
function setGenerating(isGenerating) {
    const input = document.querySelector('#msg-input');
    const sendBtn = document.querySelector('#send');
    input.disabled = isGenerating;                    // 生成中：禁止继续输入
    sendBtn.disabled = isGenerating;                  // 生成中：禁用发送
    sendBtn.textContent = isGenerating ? '生成中…' : '发送';
}

setGenerating(true);    // 发请求之前
// … 等等，拿到回复
setGenerating(false);   // 收到回复之后
```

CSS 里配一条，禁用时看着像禁用（见 CSS 笔记「体验三件套」）：

```css
button:disabled {
    cursor: not-allowed;
    opacity: .6;
}
```

### 补充三：`data-*`——HTML 与 JS 之间传数据

**结论**：HTML5 允许你自定义 `data-*` 属性，用来给元素挂「跟这条数据有关的信息」。它是 HTML 与 JS 之间的桥：HTML 侧声明，JS 侧用 `el.dataset` 读。

**命名与读取规则**（最容易记混的部分）：

| HTML 里的写法         | JS 里的读法            |
| --------------------- | ---------------------- |
| `data-id="3"`       | `el.dataset.id`      |
| `data-conv-id="3"`  | `el.dataset.convId`  |
| `data-my-thing="3"` | `el.dataset.myThing` |

三条规律：

1. HTML 属性名**只能用小写字母、数字、连字符**（`-`）；
2. JS 里连字符会被**自动转成驼峰**；
3. `dataset` 读出来的**永远是字符串**。`data-id="3"` 得到 `"3"`，要当数字用得 `Number(btn.dataset.id)`。

> ❌ 别写 `data-convId="3"`。HTML 属性名对大小写不敏感，浏览器会把驼峰全小写成 `data-convid`，你按驼峰去读就什么也读不到。

**它解决什么问题**：列表渲染时，每一条数据的「删除 / 重命名」按钮都得知道「我对应哪一条」。把业务 id 写进按钮自己的 `data-id`，点击时从按钮身上读出来——不用给每项单独造闭包变量，也不用靠 index 去数组里找。

```html
<ul id="conv-list">
    <li>
        <span>会话 A</span>
        <button type="button" class="rename" data-id="1">重命名</button>
        <button type="button" class="del" data-id="1">删除</button>
    </li>
    <li>
        <span>会话 B</span>
        <button type="button" class="rename" data-id="2">重命名</button>
        <button type="button" class="del" data-id="2">删除</button>
    </li>
</ul>
```

```js
document.querySelectorAll('.del').forEach((btn) => {
    btn.addEventListener('click', () => {
        const id = Number(btn.dataset.id);   // "1" → 1
        deleteConversation(id);
    });
});
```

**为什么不用 `id` 属性？** `id` 必须全文档唯一、语义是「页面里的锚点标识」；这里挂的是「业务数据的引用」，职责不同。`data-*` 正是为这种场景设计的；`class` 则是「一类样式 / 一组行为」的标记，也不适合存数据。

### 补充四：（可选）无障碍最小集

**结论**：`aria-live` 让「动态变化的文字」被读屏软件念出来。给「生成中…」这类状态提示加一个容器即可：

```html
<div id="status" aria-live="polite"></div>
```

```js
document.querySelector('#status').textContent = '生成中…';  // 读屏软件会念出来
```

`polite` 是「等用户空闲了再念」，`assertive` 是「立刻打断当前朗读」。本项目不做不影响验收，属加分项。
