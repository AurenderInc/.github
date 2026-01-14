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

### Base 브랜치 머지 변경사항 요약
- Base 브랜치 merge 시 자동 실행
- 변경사항을 AI로 분석하여 한글 요약 생성
- `YYYY-MM-DD_AuthorName_CHANGE_SUMMARY.md` 형식으로 문서 저장
- UTF-8 Unicode 형식의 한글 문서 생성

## 📁 프로젝트 구조

```
.github/
├── workflows/              # GitHub Actions 워크플로우
│   ├── pr-review-and-create-changes.yml
│   └── merge-change-summary.yml
├── doc/                    # 워크플로우 상세 문서
│   ├── index.md
│   ├── pr-review-and-create-changes.md
│   └── merge-change-summary.md
├── PR-REVIEW-USAGE.md      # PR 리뷰 워크플로우 사용법
├── MERGE-CHANGE-SUMMARY-USAGE.md  # Merge Change Summary 워크플로우 사용법
├── HowToSetupOrgRepo.md    # 조직 Workflow 설정 가이드
└── README.md              # 프로젝트 소개 문서
```

## 🚀 시작하기

### 워크플로우 사용 방법

다른 리포지토리에서 이 조직 workflow를 **재사용**하려면, 파일을 복사하지 않고 직접 참조합니다.

각 워크플로우의 상세한 사용법은 다음 문서를 참고하세요:

- **[PR Change Summary & Code Review 사용법](./PR-REVIEW-USAGE.md)** - PR 리뷰 워크플로우 설정 및 사용 가이드
- **[Merge Change Summary 사용법](./MERGE-CHANGE-SUMMARY-USAGE.md)** - Base 브랜치 머지 시 변경사항 요약 워크플로우 설정 및 사용 가이드

### 장점

이 방식(재사용 가능한 workflow)을 사용하면:
- 📦 **파일 복사 불필요**: 조직 리포에서 직접 참조
- 🔄 **자동 업데이트**: 조직 workflow 수정 시 모든 리포에 자동 반영
- 🛠️ **중앙 관리**: 한 곳에서 모든 리포의 workflow 관리
- 🎯 **일관성 유지**: 모든 프로젝트에서 동일한 리뷰 품질 보장

## 📚 문서

### 사용자 가이드
- **[조직 Workflow 설정 가이드](./HowToSetupOrgRepo.md)** - 조직 공통 workflow 리포지토리 설정 방법 (관리자용)

### 워크플로우 사용법
- **[PR Change Summary & Code Review 사용법](./PR-REVIEW-USAGE.md)** - PR 리뷰 워크플로우 설정 및 사용 가이드
- **[Merge Change Summary 사용법](./MERGE-CHANGE-SUMMARY-USAGE.md)** - Base 브랜치 머지 시 변경사항 요약 워크플로우 설정 및 사용 가이드

### 워크플로우 상세 문서
- [인덱스](./doc/index.md) - 모든 워크플로우 개요
- [PR 리뷰 워크플로우](./doc/pr-review-and-create-changes.md) - AI 기반 코드 리뷰 상세 가이드
- [Merge Change Summary 워크플로우](./doc/merge-change-summary.md) - Base 브랜치 머지 변경사항 요약 상세 가이드

## ⚙️ 설정

### 필요한 시크릿

각 워크플로우마다 필요한 시크릿을 GitHub 리포지토리 설정에서 추가해야 합니다.

#### 공통 시크릿
- `OPENAI_API_KEY`: OpenAI API 키 (모든 워크플로우에서 사용)

**주의**: `GITHUB_TOKEN`은 자동으로 제공되므로 별도로 설정할 필요가 없습니다.

### 필요 권한

워크플로우는 다음 권한이 필요합니다:
- `contents: write` - 파일 커밋 및 푸시
- `pull-requests: write` - PR 코멘트 작성 (PR 리뷰 워크플로우만)

## 📖 워크플로우 설명

### PR Change Summary & Code Review

**파일**: `workflows/pr-review-and-create-changes.yml`

PR이 열리거나 업데이트될 때 자동으로 실행되어:
- 코드 변경사항을 한국어/영어로 요약
- 각 파일에 대해 AI 코드 리뷰 수행
- PR에 상세한 리뷰 코멘트 작성
- 변경사항을 `changes/` 폴더에 기록

**사용법**: [PR Change Summary & Code Review 사용법](./PR-REVIEW-USAGE.md)  
**상세 문서**: [PR 리뷰 워크플로우 문서](./doc/pr-review-and-create-changes.md)

### Merge Change Summary

**파일**: `workflows/merge-change-summary.yml`

Base 브랜치에 merge될 때마다 자동으로 실행되어:
- 머지된 커밋의 변경사항을 AI로 분석
- 한글로 변경사항 요약 문서 생성
- `changes/` 폴더에 `YYYY-MM-DD_AuthorName_CHANGE_SUMMARY.md` 형식으로 저장
- UTF-8 Unicode 형식의 한글 문서 생성

**사용법**: [Merge Change Summary 사용법](./MERGE-CHANGE-SUMMARY-USAGE.md)  
**상세 문서**: [Merge Change Summary 워크플로우 문서](./doc/merge-change-summary.md)

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

