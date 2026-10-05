# LZH 作品集

与 [LZH Code Blog](https://lzhcodeblog.site) 同源的「暖纸印刷」设计体系：骨纸底色、碳黑墨迹、陶土橙点缀。布局与博客镜像——**左侧个人信息栏 + 顶部导航栏 + 右侧三列项目卡片网格**，点卡片进入项目详情页。

纯静态 HTML/CSS/JS，零依赖、零构建框架。

## 目录结构

```
zuopingji/
├── index.html            # 首页：侧栏 + 三列卡片网格 + 分类筛选
├── project.html          # 项目详情页（project.html?p=slug）
├── css/style.css         # 设计体系（与博客 csdn-style 主题同源）
├── js/main.js            # 渲染逻辑：侧栏 / 卡片 / 筛选 / 详情
├── js/marked.min.js      # 本地 Markdown 渲染（无 CDN 依赖）
├── build.js              # 扫描 projects/*.md → data/projects.json
├── data/profile.json     # 左侧栏个人信息（头像 / 简介 / 社交链接）
├── projects/             # 每个项目一个 Markdown 文件
│   ├── _template.md      # 新项目模板（下划线开头不会被发布）
│   └── *.md
└── assets/
    ├── covers/           # 卡片封面图
    └── screenshots/      # 详情页截图
```

## 本地预览

必须通过 HTTP 访问（直接双击 HTML 无法 fetch 数据）：

```bash
cd zuopingji
python3 -m http.server 8642
# 打开 http://127.0.0.1:8642
```

## 如何添加新项目

1. 复制模板：`cp projects/_template.md projects/我的项目.md`（文件名即 URL 中的 slug）
2. 编辑 frontmatter 和正文
3. 重新构建：`node build.js`
4. 刷新页面即可看到新卡片

### frontmatter 字段说明

| 字段 | 必填 | 说明 |
|------|------|------|
| `title` | ✅ | 项目名称（卡片标题 + 详情页标题） |
| `description` | ✅ | 一句话简介，显示在卡片上，建议 40 字以内 |
| `category` | 建议 | 分类，如 `Web` / `AI` / `工具`；分类会自动生成导航和筛选 |
| `tags` | 建议 | 技术栈数组 `[Python, FastAPI]`，自动聚合进侧栏「技术栈」 |
| `cover` | 可选 | 封面图路径（放 `assets/covers/`）；留空显示首字母占位块 |
| `date` | 建议 | 日期 `YYYY-MM-DD`，用于排序和展示 |
| `status` | 可选 | `已完成` / `开发中` / `已归档`，显示为卡片左上角徽章 |
| `featured` | 可选 | `true` 置顶排序 |
| `github` | 可选 | GitHub 仓库链接，显示在卡片底部和详情页按钮 |
| `demo` | 可选 | 在线演示链接，同上 |

正文是标准 Markdown，支持标题、列表、表格、代码块、图片（截图放 `assets/screenshots/`）。

### 修改个人信息

编辑 `data/profile.json`：`name`、`avatar`（图片放站点任意路径后填相对路径，留空显示首字母）、`bio`、`social.github` / `social.email` / `social.blog`。

> 记得把 `github` 占位链接换成你自己的，并核对 index.html 顶部「博客 ↗」的地址。

## 部署

构建产物就是整个目录（`data/projects.json` 需要随 `projects/` 一起更新），可托管到任何静态服务：

- **GitHub Pages**：推送到仓库，Settings → Pages 指向根目录或 `/docs`
- **Vercel / Netlify / 服务器 Nginx**：直接指向该目录，无需任何构建配置

## 并入博客（已接入）

作品集已通过 Hexo 的 `skip_render` 机制并入博客，线上地址为 `https://lzhcodeblog.site/portfolio/`：

- 博客侧改动（一次性，已完成）：
  - `blog/_config.yml`：`skip_render: [portfolio/**]`，让 Hexo 原样拷贝不渲染
  - `blog/themes/csdn-style/_config.yml`：菜单加了 `"作品集": /portfolio/`
- 作品集站点内所有链接都是相对路径，单独预览（`python3 -m http.server`）和挂在 `/portfolio/` 子路径下都能正常工作

### 日常更新流程

```bash
# 1. 在 zuopingji 里添加/修改项目 md、改样式等
# 2. 一键同步（内部会先跑 node build.js）
./sync-to-blog.sh
# 3. 发布
cd ../blog
npx hexo clean && npx hexo generate && npx hexo deploy
```

`zuopingji/` 仍然是唯一的源：改内容、加项目都在这里做，`sync-to-blog.sh` 把构建产物拷贝进 `blog/source/portfolio/`（要求两个目录同级）。博客本地预览时 `http://localhost:4001/portfolio/` 即可查看合并效果。

### 后续可做的深度整合（可选）

- 用 Hexo 生成器直接从 `projects/*.md` 生成卡片数据，省掉 `build.js` 一步（需要写一个 Hexo generator 插件）
- 让作品集复用博客的页头导航，视觉上完全一体（目前是各自独立的页头，像博客的一个专栏）
