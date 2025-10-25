# GitHub Organization Actions

이 리포지토리는 GitHub Organization에서 사용할 재사용 가능한 GitHub Actions 워크플로우를 제공합니다.

## 📋 개요

이 Organization 템플릿 리포지토리는 여러 프로젝트에서 공통으로 사용할 수 있는 GitHub Actions 워크플로우를 중앙에서 관리합니다. 각 팀 프로젝트에서 이 워크플로우를 참조하여 일관된 CI/CD 파이프라인을 구축할 수 있습니다.

## 🎯 주요 기능

### AI 기반 PR 리뷰
- OpenAI GPT 모델을 활용한 자동 코드 리뷰
- 한국어/영어 이중 언어 변경사항 요약
- 파일별 상세 분석 및 개선 제안
- 보안 취약점 자동 감지

## 📁 프로젝트 구조

```
.github/
├── workflows/              # GitHub Actions 워크플로우
│   └── pr-review-and-create-changes.yml
├── doc/                    # 워크플로우 상세 문서
│   ├── index.md
│   └── pr-review-and-create-changes.md
└── README.md              # 프로젝트 소개 문서
```

## 🚀 시작하기

### 워크플로우 사용 방법

다른 리포지토리에서 이 워크플로우를 사용하려면:

1. 대상 리포지토리의 `.github/workflows/` 폴더에 워크플로우 파일 복사
2. 필요한 시크릿 설정 (GitHub 리포지토리 Settings > Secrets)

```yaml
# .github/workflows/pr-review.yml
name: PR Review

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    uses: your-org/.github/.github/workflows/pr-review-and-create-changes.yml@main
    secrets:
      OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
```

### 워크플로우 직접 포함

Organization 템플릿으로 사용하거나, 워크플로우 파일을 직접 복사하여 사용할 수 있습니다.

```bash
# 워크플로우 파일 복사
cp .github/workflows/pr-review-and-create-changes.yml \
   /path/to/your/repo/.github/workflows/
```

## 📚 문서

각 워크플로우에 대한 상세한 설명은 [doc](./doc/) 폴더를 참조하세요.

- [인덱스](./doc/index.md) - 모든 워크플로우 개요
- [PR 리뷰 워크플로우](./doc/pr-review-and-create-changes.md) - AI 기반 코드 리뷰 상세 가이드

## ⚙️ 설정

### 필요한 시크릿

각 워크플로우마다 필요한 시크릿을 GitHub 리포지토리 설정에서 추가해야 합니다.

#### PR 리뷰 워크플로우
- `OPENAI_API_KEY`: OpenAI API 키

### 필요 권한

워크플로우는 다음 권한이 필요합니다:
- `contents: write` - 파일 커밋 및 푸시
- `pull-requests: write` - PR 코멘트 작성

## 📖 워크플로우 설명

### PR Change Summary & Code Review

**파일**: `workflows/pr-review-and-create-changes.yml`

PR이 열리거나 업데이트될 때 자동으로 실행되어:
- 코드 변경사항을 한국어/영어로 요약
- 각 파일에 대해 AI 코드 리뷰 수행
- PR에 상세한 리뷰 코멘트 작성
- 변경사항을 `changes/` 폴더에 기록

**상세 문서**: [PR 리뷰 워크플로우 문서](./doc/pr-review-and-create-changes.md)

## 🔧 개발 및 기여

### 새로운 워크플로우 추가

1. `.github/workflows/` 폴더에 새로운 워크플로우 파일 추가
2. `doc/` 폴더에 상세 문서 작성
3. `doc/index.md` 업데이트

### 워크플로우 수정

1. 워크플로우 파일 수정
2. 해당 문서 업데이트
3. 테스트 진행

## 📝 라이선스

MIT License

## 🤝 기여자

이 리포지토리에 기여해주셔서 감사합니다!

## 📞 문의

문제가 발생하거나 질문이 있으시면 이슈를 등록해주세요.

---

**마지막 업데이트**: 2024년

