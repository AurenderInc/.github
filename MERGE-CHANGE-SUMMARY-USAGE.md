# Merge Change Summary 워크플로우 사용법

## 📋 개요

이 문서는 다른 리포지토리에서 Merge Change Summary 워크플로우를 사용하는 방법을 설명합니다.

## 🚀 시작하기

### 워크플로우 사용 방법 (권장)

다른 리포지토리에서 이 조직 workflow를 **재사용**하려면, 파일을 복사하지 않고 직접 참조합니다:

### 1단계: Workflow 파일 생성

대상 리포지토리의 `.github/workflows/` 폴더에 다음 내용으로 파일을 생성합니다:

```yaml
# .github/workflows/merge-change-summary.yml
name: Merge Change Summary (Base Branch)

on:
  push:
    branches:
      - 'aurender/**'
      - 'main'
      - 'master'
      - 'auMpd'
      - 'auMpd/**'
    paths-ignore:
      - 'changes/**'

jobs:
  call-merge-summary:
    uses: AurenderInc/.github/.github/workflows/merge-change-summary.yml@main
    secrets: inherit
```

### 2단계: Secret 설정

GitHub 리포지토리 Settings > Secrets and variables > Actions에서 다음 secret을 추가:

- **`OPENAI_API_KEY`**: OpenAI API 키

**주의**: `GITHUB_TOKEN`은 자동으로 제공되므로 별도로 설정할 필요가 없습니다.

### 3단계: 테스트

Base 브랜치에 커밋을 push하거나 PR을 merge하면 자동으로 워크플로우가 실행되어:
- ✅ 변경사항 분석
- ✅ 한글 요약 문서 생성
- ✅ `changes/` 폴더에 저장
- ✅ `changes/index.md` 업데이트

## 📄 생성되는 문서 형식

### 파일명 형식

```
YYYY-MM-DD_AuthorName_CHANGE_SUMMARY.md
```

예시:
- `2024-12-20_홍길동_새로운-기능-추가.md`
- `2024-12-20_김철수_버그-수정.md`

### 문서 내용 구조

생성되는 문서는 다음 섹션을 포함합니다:

```markdown
# 변경 요약

## 🧠 변경 요약
전체 변경사항을 1-2문장으로 요약

## 📂 변경 파일
변경된 파일 목록

## 🔑 주요 변경 내용
중요한 변경사항을 상세히 설명

## ⚠️ 영향 및 리스크
이 변경으로 인한 영향과 잠재적 리스크
```

## ⚙️ 설정

### 지원하는 Base 브랜치

다음 브랜치 패턴에 대해 워크플로우가 실행됩니다:

- `aurender/**` (예: `aurender/main`, `aurender/master` 등)
- `main`
- `master`
- `auMpd`
- `auMpd/**`

### 필요한 시크릿

- `OPENAI_API_KEY`: OpenAI API 키

### 필요 권한

워크플로우는 다음 권한이 필요합니다:
- `contents: write` - 파일 커밋 및 푸시

## 🔍 동작 원리

1. **트리거**: Base 브랜치에 push 이벤트 발생
2. **커밋 정보 수집**: GitHub API를 통해 커밋 정보, 작성자, 날짜 등 수집
3. **변경사항 추출**: 이전 커밋과 현재 커밋 간의 diff 추출 (changes 폴더 제외)
4. **AI 요약 생성**: OpenAI GPT-4o-mini를 사용하여 한글로 변경사항 요약
5. **문서 저장**: `changes/` 폴더에 UTF-8 인코딩으로 문서 저장
6. **인덱스 업데이트**: `changes/index.md`에 새 문서 링크 추가
7. **커밋 및 푸시**: 생성된 문서를 자동으로 커밋하고 푸시

## ✨ 장점

이 방식(재사용 가능한 workflow)을 사용하면:
- 📦 **파일 복사 불필요**: 조직 리포에서 직접 참조
- 🔄 **자동 업데이트**: 조직 workflow 수정 시 모든 리포에 자동 반영
- 🛠️ **중앙 관리**: 한 곳에서 모든 리포의 workflow 관리
- 🎯 **일관성 유지**: 모든 프로젝트에서 동일한 요약 품질 보장

## 🐛 문제 해결

### 워크플로우가 실행되지 않음

1. **브랜치 이름 확인**: Base 브랜치가 지원하는 패턴에 포함되는지 확인
2. **트리거 조건 확인**: `paths-ignore`에 의해 제외되지 않았는지 확인
3. **권한 확인**: `contents: write` 권한이 있는지 확인

### AI 요약 생성 실패

- OpenAI API 키가 올바르게 설정되었는지 확인
- API 사용량 한도 확인
- 실패 시 기본 요약이 생성되지만, 수동 검토가 필요합니다

## 📖 상세 문서

더 자세한 내용은 [Merge Change Summary 워크플로우 상세 문서](./doc/merge-change-summary.md)를 참고하세요.

## 🔗 관련 문서

- [워크플로우 인덱스](./doc/index.md)
- [조직 Workflow 설정 가이드](./HowToSetupOrgRepo.md)

---

**마지막 업데이트**: 2024년 12월
