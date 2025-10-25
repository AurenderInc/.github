#!/bin/bash

# GitHub Organization Workflow Update Script
# 조직의 모든 리포지토리에 PR Change Summary 워크플로우를 적용합니다.

set -e

# 설정
GITHUB_ORG="AurenderInc"  # 조직 이름을 여기에 입력하세요
WORKFLOW_FILE=".github/workflows/pr-change-summary.yml"
COMMIT_MESSAGE="Add/Update PR Change Summary & Code Review workflow"
RESULT_FILE="result.md"

# GitHub CLI가 설치되어 있는지 확인
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh)가 설치되어 있지 않습니다."
    echo "설치 방법: https://cli.github.com/"
    exit 1
fi

# GitHub CLI 인증 확인
if ! gh auth status &> /dev/null; then
    echo "❌ GitHub CLI 인증이 필요합니다."
    echo "실행: gh auth login"
    exit 1
fi

# 워크플로우 내용
read -r -d '' WORKFLOW_CONTENT << 'EOF'
name: PR Change Summary & Code Review (OpenAI)

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  call-centralized-workflow:
    uses: AurenderInc/.github/.github/workflows/pr-review-and-create-changes.yml@main
    with:
      pr_number: ${{ github.event.pull_request.number }}
      pr_title: ${{ github.event.pull_request.title }}
      pr_head_ref: ${{ github.head_ref }}
      pr_base_ref: ${{ github.event.pull_request.base.ref }}
      repo: ${{ github.repository }}
    secrets: inherit
EOF

echo "======================================"
echo "GitHub Organization Workflow Updater"
echo "======================================"
echo "조직: $GITHUB_ORG"
echo "워크플로우 파일: $WORKFLOW_FILE"
echo ""

# 임시 디렉토리 생성
TEMP_DIR=$(mktemp -d)
echo "📁 임시 디렉토리: $TEMP_DIR"
echo ""

# 조직의 모든 리포지토리 가져오기
echo "🔍 조직의 리포지토리 목록을 가져오는 중..."
REPOS=$(gh repo list "$GITHUB_ORG" --limit 1000 --json name,isArchived,isFork --jq '.[] | select(.isArchived == false and .isFork == false) | .name')

if [ -z "$REPOS" ]; then
    echo "❌ 리포지토리를 찾을 수 없습니다."
    exit 1
fi

REPO_COUNT=$(echo "$REPOS" | wc -l | tr -d ' ')
echo "✅ $REPO_COUNT 개의 활성 리포지토리를 찾았습니다."
echo ""

# 결과 파일 초기화
cat > "$RESULT_FILE" << 'HEADER'
# Workflow Update Results

| Repository | URL | Primary Branch | Status | Details |
|------------|-----|----------------|--------|---------|
HEADER

# 각 리포지토리 처리
SUCCESS_COUNT=0
SKIP_COUNT=0
ERROR_COUNT=0

for REPO_NAME in $REPOS; do
    echo "----------------------------------------"
    echo "📦 처리 중: $REPO_NAME"

    REPO_FULL="$GITHUB_ORG/$REPO_NAME"
    REPO_DIR="$TEMP_DIR/$REPO_NAME"
    REPO_URL="https://github.com/$REPO_FULL"

    # 리포지토리 클론
    echo "  ⬇️  클론 중..."
    if ! gh repo clone "$REPO_FULL" "$REPO_DIR" -- --quiet 2>/dev/null; then
        echo "  ❌ 클론 실패 (권한 없음 또는 접근 불가)"
        echo "| $REPO_NAME | $REPO_URL | N/A | ❌ Failed | Clone failed |" >> "$RESULT_FILE"
        ((ERROR_COUNT++))
        continue
    fi

    cd "$REPO_DIR"

    # 기본 브랜치 확인
    DEFAULT_BRANCH=$(gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name')
    echo "  📌 Primary 브랜치: $DEFAULT_BRANCH"

    # .github/workflows 디렉토리 생성
    mkdir -p .github/workflows

    # 워크플로우 파일이 이미 존재하는지 확인
    FILE_EXISTS=false
    if [ -f "$WORKFLOW_FILE" ]; then
        echo "  📝 기존 워크플로우 파일 발견 - 업데이트합니다."
        FILE_EXISTS=true
    else
        echo "  ➕ 새 워크플로우 파일을 생성합니다."
    fi

    # 워크플로우 파일 작성
    echo "$WORKFLOW_CONTENT" > "$WORKFLOW_FILE"

    # 변경사항 확인
    if git diff --quiet && git diff --cached --quiet; then
        echo "  ⏭️  변경사항 없음 - 건너뜁니다."
        echo "| $REPO_NAME | $REPO_URL | $DEFAULT_BRANCH | ⏭️ Skipped | No changes needed |" >> "$RESULT_FILE"
        ((SKIP_COUNT++))
        cd "$TEMP_DIR"
        continue
    fi

    # 변경사항 커밋
    git add "$WORKFLOW_FILE"
    git commit -m "$COMMIT_MESSAGE" --quiet

    # Primary 브랜치에 직접 푸시
    echo "  ⬆️  Primary 브랜치에 푸시 중..."
    if git push origin "$DEFAULT_BRANCH" --quiet 2>/dev/null; then
        if [ "$FILE_EXISTS" = true ]; then
            echo "  ✅ 워크플로우 업데이트 완료"
            echo "| $REPO_NAME | $REPO_URL | $DEFAULT_BRANCH | ✅ Updated | Workflow file updated |" >> "$RESULT_FILE"
        else
            echo "  ✅ 워크플로우 추가 완료"
            echo "| $REPO_NAME | $REPO_URL | $DEFAULT_BRANCH | ✅ Added | Workflow file added |" >> "$RESULT_FILE"
        fi
        ((SUCCESS_COUNT++))
    else
        echo "  ❌ 푸시 실패"
        echo "| $REPO_NAME | $REPO_URL | $DEFAULT_BRANCH | ❌ Failed | Push failed |" >> "$RESULT_FILE"
        ((ERROR_COUNT++))
    fi

    cd "$TEMP_DIR"
done

# 임시 디렉토리 정리
echo ""
echo "🧹 임시 디렉토리 정리 중..."
rm -rf "$TEMP_DIR"

# 결과 파일에 요약 추가
cat >> "$RESULT_FILE" << EOF

## Summary

- **Total Repositories**: $REPO_COUNT
- **✅ Successfully Applied**: $SUCCESS_COUNT
- **⏭️ Skipped (No Changes)**: $SKIP_COUNT
- **❌ Failed**: $ERROR_COUNT

---
*Generated on $(date '+%Y-%m-%d %H:%M:%S')*
EOF

# 결과 요약
echo ""
echo "======================================"
echo "처리 완료"
echo "======================================"
echo "✅ 성공: $SUCCESS_COUNT"
echo "⏭️  건너뜀: $SKIP_COUNT"
echo "❌ 실패: $ERROR_COUNT"
echo "📊 전체: $REPO_COUNT"
echo ""
echo "📄 결과가 $RESULT_FILE 파일에 저장되었습니다."
echo "======================================"

if [ $ERROR_COUNT -gt 0 ]; then
    exit 1
fi
