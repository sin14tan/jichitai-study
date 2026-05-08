#!/bin/bash
# ============================================================
# JichitaiStudy GitHub デプロイ補助スクリプト
# ============================================================
# 使い方:
#   1. 初回のみ: GitHubでリポジトリ "jichitai-study" を作成しておく
#   2. このスクリプトを実行: bash deploy.sh
#
# 注意: GITHUB_USERNAME を自分のGitHubユーザー名に書き換えてください
# ============================================================

set -e

# === 設定 ===
GITHUB_USERNAME="YOUR-USERNAME"   # ← 自分のユーザー名に書き換える
REPO_NAME="jichitai-study"
COMMIT_MESSAGE="${1:-Update content}"

# === 色付き出力 ===
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== JichitaiStudy デプロイスクリプト ===${NC}"
echo ""

# === ユーザー名チェック ===
if [ "$GITHUB_USERNAME" = "YOUR-USERNAME" ]; then
  echo -e "${RED}エラー: GITHUB_USERNAME が設定されていません${NC}"
  echo "deploy.sh を編集して、自分のGitHubユーザー名に書き換えてください"
  exit 1
fi

# === Git 初期化チェック ===
if [ ! -d ".git" ]; then
  echo -e "${BLUE}[1/5] Git を初期化します${NC}"
  git init
  git branch -M main
else
  echo -e "${GREEN}[1/5] Git は初期化済みです${NC}"
fi

# === リモート設定チェック ===
if ! git remote | grep -q "^origin$"; then
  echo -e "${BLUE}[2/5] リモートリポジトリを設定します${NC}"
  git remote add origin "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
else
  echo -e "${GREEN}[2/5] リモートは設定済みです${NC}"
fi

# === ファイル追加 ===
echo -e "${BLUE}[3/5] ファイルをステージングします${NC}"
git add .

# === コミット ===
if git diff --cached --quiet; then
  echo -e "${GREEN}[4/5] コミットする変更はありません${NC}"
else
  echo -e "${BLUE}[4/5] コミットします: ${COMMIT_MESSAGE}${NC}"
  git commit -m "${COMMIT_MESSAGE}"
fi

# === プッシュ ===
echo -e "${BLUE}[5/5] GitHubへプッシュします${NC}"
git push -u origin main

echo ""
echo -e "${GREEN}=== デプロイ完了 ===${NC}"
echo ""
echo "公開URL（GitHub Pages 有効化後・反映に数分かかる場合あり）:"
echo -e "  ${BLUE}https://${GITHUB_USERNAME}.github.io/${REPO_NAME}/${NC}"
echo ""
echo "GitHub Pages がまだ有効でない場合は、以下を実行してください:"
echo "  1. https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/settings/pages にアクセス"
echo "  2. Source: Deploy from a branch"
echo "  3. Branch: main / root を選んで Save"
