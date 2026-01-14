# PR Change Summary & Code Review 워크플로우 사용법

## 📋 개요

이 문서는 다른 리포지토리에서 PR Change Summary & Code Review 워크플로우를 사용하는 방법을 설명합니다.

## 🚀 시작하기

### 워크플로우 사용 방법 (권장)

다른 리포지토리에서 이 조직 workflow를 **재사용**하려면, 파일을 복사하지 않고 직접 참조합니다:

### 1단계: Workflow 파일 생성

대상 리포지토리의 `.github/workflows/` 폴더에 다음 내용으로 파일을 생성합니다:

```yaml
# .github/workflows/pr-change-summary.yml
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
```

### 2단계: Secret 설정

GitHub 리포지토리 Settings > Secrets and variables > Actions에서 다음 secret을 추가:

- **`OPENAI_API_KEY`**: OpenAI API 키

**주의**: `GITHUB_TOKEN`은 자동으로 제공되므로 별도로 설정할 필요가 없습니다.

### 3단계: 테스트

PR을 생성하면 자동으로 workflow가 실행되어:
- ✅ 이중 언어(한국어/영어) 변경 요약 생성
- ✅ 파일별 코드 리뷰 수행
- ✅ PR에 코멘트 작성
- ✅ `changes/PR-{번호}-{제목}.md` 파일 생성

## ✨ 장점

이 방식(재사용 가능한 workflow)을 사용하면:
- 📦 **파일 복사 불필요**: 조직 리포에서 직접 참조
- 🔄 **자동 업데이트**: 조직 workflow 수정 시 모든 리포에 자동 반영
- 🛠️ **중앙 관리**: 한 곳에서 모든 리포의 workflow 관리
- 🎯 **일관성 유지**: 모든 프로젝트에서 동일한 리뷰 품질 보장

## ⚙️ 설정

### 필요한 시크릿

- `OPENAI_API_KEY`: OpenAI API 키

### 필요 권한

워크플로우는 다음 권한이 필요합니다:
- `contents: write` - 파일 커밋 및 푸시
- `pull-requests: write` - PR 코멘트 작성

## 📖 상세 문서

더 자세한 내용은 [PR 리뷰 워크플로우 상세 문서](./doc/pr-review-and-create-changes.md)를 참고하세요.

## 🔗 관련 문서

- [워크플로우 인덱스](./doc/index.md)
- [조직 Workflow 설정 가이드](./HowToSetupOrgRepo.md)

---

**마지막 업데이트**: 2024년 12월
