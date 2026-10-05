#!/usr/bin/env bash
# 把作品集同步进 Hexo 博客：blog/source/portfolio/
# 用法：在 zuopingji 目录里改完内容后运行  ./sync-to-blog.sh
# 之后在 blog 目录 hexo clean && hexo generate && hexo deploy 即可发布
set -euo pipefail
cd "$(dirname "$0")"

node build.js

BLOG_DIR="$(cd .. && pwd)/blog"
if [ ! -d "$BLOG_DIR/source" ]; then
  echo "错误: 找不到 $BLOG_DIR/source，请确认 blog 目录与 zuopingji 同级"
  exit 1
fi

rm -rf "$BLOG_DIR/source/portfolio"
mkdir -p "$BLOG_DIR/source/portfolio"
cp -r css js data projects assets index.html project.html "$BLOG_DIR/source/portfolio/"

echo "✓ 已同步到 $BLOG_DIR/source/portfolio"
echo "  下一步: cd $BLOG_DIR && npx hexo clean && npx hexo generate && npx hexo deploy"
