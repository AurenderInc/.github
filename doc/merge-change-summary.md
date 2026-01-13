# Merge Change Summary 워크플로우

## 📋 개요

Base 브랜치에 merge될 때마다 자동으로 실행되어, 머지된 커밋의 변경사항을 분석하고 한글로 요약한 문서를 생성하는 워크플로우입니다.

## 🎯 주요 기능

- ✅ Base 브랜치 merge 시 자동 실행
- ✅ 변경사항을 AI로 분석하여 한글 요약 생성
- ✅ `changes/` 폴더에 문서 자동 저장
- ✅ 파일명 형식: `YYYY-MM-DD_AuthorName_CHANGE_SUMMARY.md`
- ✅ UTF-8 Unicode 형식의 한글 문서 생성
- ✅ `changes/index.md` 자동 업데이트

## 🔧 설정

### 지원하는 Base 브랜치

다음 브랜치 패턴에 대해 워크플로우가 실행됩니다:

- `aurender/**` (예: `aurender/main`, `aurender/master` 등)
- `main`
- `master`
- `auMpd`
- `auMpd/**`

### 필요한 시크릿

GitHub 리포지토리 Settings > Secrets and variables > Actions에서 다음 secret을 추가해야 합니다:

- **`OPENAI_API_KEY`**: OpenAI API 키 (GPT-4o-mini 모델 사용)

### 필요 권한

워크플로우는 다음 권한이 필요합니다:

- `contents: write` - 파일 커밋 및 푸시

## 📝 사용 방법

### 1단계: 워크플로우 파일 생성

대상 리포지토리의 `.github/workflows/` 폴더에 다음 내용으로 파일을 생성합니다:

```yaml
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

또는 조직 워크플로우를 직접 참조:

```yaml
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

GitHub 리포지토리 Settings > Secrets and variables > Actions에서 `OPENAI_API_KEY`를 추가합니다.

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

## 🔍 동작 원리

1. **트리거**: Base 브랜치에 push 이벤트 발생
2. **커밋 정보 수집**: GitHub API를 통해 커밋 정보, 작성자, 날짜 등 수집
3. **변경사항 추출**: 이전 커밋과 현재 커밋 간의 diff 추출 (changes 폴더 제외)
4. **AI 요약 생성**: OpenAI GPT-4o-mini를 사용하여 한글로 변경사항 요약
5. **문서 저장**: `changes/` 폴더에 UTF-8 인코딩으로 문서 저장
6. **인덱스 업데이트**: `changes/index.md`에 새 문서 링크 추가
7. **커밋 및 푸시**: 생성된 문서를 자동으로 커밋하고 푸시

## ⚙️ 고급 설정

### 특정 브랜치만 제외

특정 브랜치를 제외하려면 워크플로우 파일을 수정:

```yaml
on:
  push:
    branches:
      - 'aurender/**'
      - 'main'
      - 'master'
      - 'auMpd'
      - 'auMpd/**'
    branches-ignore:
      - 'aurender/develop'  # develop 브랜치 제외
```

### 변경사항이 없을 때

변경사항이 없거나 `changes/` 폴더의 변경만 있는 경우, 워크플로우는 자동으로 종료됩니다.

## 🐛 문제 해결

### 워크플로우가 실행되지 않음

1. **브랜치 이름 확인**: Base 브랜치가 지원하는 패턴에 포함되는지 확인
2. **트리거 조건 확인**: `paths-ignore`에 의해 제외되지 않았는지 확인
3. **권한 확인**: `contents: write` 권한이 있는지 확인

### AI 요약 생성 실패

- OpenAI API 키가 올바르게 설정되었는지 확인
- API 사용량 한도 확인
- 실패 시 기본 요약이 생성되지만, 수동 검토가 필요합니다

### 파일명에 특수문자 포함

파일명은 자동으로 안전한 형식으로 변환됩니다:
- 공백 → 하이픈(`-`)
- 특수문자 제거
- 한글, 일본어, 중국어는 유지

### 중복 문서 생성

같은 날짜, 같은 작성자, 같은 요약의 문서가 이미 있으면 인덱스에 중복 추가되지 않습니다.

## 📊 예시

### 입력 (커밋)

```
커밋 메시지: "feat: 새로운 사용자 인증 기능 추가"
작성자: 홍길동
날짜: 2024-12-20
```

### 출력 (생성된 문서)

**파일명**: `changes/2024-12-20_홍길동_새로운-사용자-인증-기능-추가.md`

**내용**:
```markdown
# 변경 요약

## 🧠 변경 요약
사용자 인증 시스템에 새로운 OAuth 2.0 기반 로그인 기능을 추가했습니다.

## 📂 변경 파일
- src/auth/oauth.py
- src/auth/models.py
- tests/test_oauth.py

## 🔑 주요 변경 내용
- OAuth 2.0 프로바이더 연동 구현
- JWT 토큰 기반 인증 로직 추가
- 단위 테스트 작성

## ⚠️ 영향 및 리스크
- 기존 인증 방식과의 호환성 유지 필요
- 새로운 환경 변수 설정 필요 (OAUTH_CLIENT_ID, OAUTH_CLIENT_SECRET)
```

## 🔗 관련 문서

- [워크플로우 인덱스](./index.md)
- [PR 리뷰 워크플로우](./pr-review-and-create-changes.md)

## 📝 참고사항

- 문서는 반드시 UTF-8 Unicode 형식의 한글로 작성됩니다
- `changes/` 폴더의 변경사항은 워크플로우 트리거에서 제외됩니다 (무한 루프 방지)
- 생성된 문서는 `[skip ci]` 태그와 함께 커밋되어 다시 워크플로우를 트리거하지 않습니다

---

**마지막 업데이트**: 2024년 12월
