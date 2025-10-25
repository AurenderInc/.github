# 조직 공통 GitHub Actions Workflow 리포지토리 설정 가이드

## 📋 개요

이 문서는 조직의 여러 리포지토리에서 공통으로 사용할 수 있는 재사용 가능한 GitHub Actions workflow를 설정하는 과정을 설명합니다.

## 🎯 목적

- 여러 리포지토리에서 동일한 workflow를 중앙에서 관리
- workflow 업데이트 시 한 곳에서만 수정하면 모든 리포지토리에 자동 반영
- 코드 중복 제거 및 유지보수성 향상

## 🛠️ 설정 과정

### 1단계: 조직 `.github` 리포지토리 생성

```bash
# 조직 레벨에서 .github 리포지토리 생성
gh repo create <조직명>/.github --public
```

**중요**:
- GitHub Team 플랜에서는 재사용 가능한 workflow를 사용하려면 리포지토리가 **public**이어야 합니다
- GitHub Enterprise Cloud를 사용하는 경우 private 리포지토리도 사용 가능합니다

### 2단계: Workflow 파일 생성

조직 리포지토리에 재사용 가능한 workflow 파일을 생성합니다:

```
.github/
└── workflows/
    └── pr-review-and-create-changes.yml
```

**workflow_call 트리거 사용**:
```yaml
on:
  workflow_call:
    inputs:
      pr_number:
        required: true
        type: number
      # ... 기타 inputs
    secrets:
      OPENAI_API_KEY:
        required: true
      # GITHUB_TOKEN은 시스템 예약 이름이므로 secrets에 정의하지 않음
```

### 3단계: Actions 권한 설정

조직 리포지토리의 workflow를 다른 리포지토리에서 사용할 수 있도록 권한을 설정합니다:

```bash
# 조직 내 모든 리포지토리에서 workflow 접근 허용
gh api -X PUT repos/<조직명>/.github/actions/permissions/access \
  -f access_level='organization'
```

또는 GitHub 웹 UI에서:
1. 조직 `.github` 리포지토리 → **Settings** → **Actions** → **General**
2. "Access" 섹션에서 **"Accessible from repositories in the '<조직명>' organization"** 선택
3. 저장

### 4단계: 주의사항

#### ❌ 피해야 할 오류

1. **GITHUB_TOKEN을 workflow_call의 secrets로 정의**
   ```yaml
   # ❌ 잘못된 예시
   secrets:
     GITHUB_TOKEN:
       required: true
   ```
   에러: `secret name 'GITHUB_TOKEN' within 'workflow_call' can not be used since it would collide with system reserved name`

2. **YAML 구문 오류**
   - 큰따옴표 안에 템플릿 표현식 사용 시 주의
   ```yaml
   # ❌ 잘못된 예시
   run: echo "Test message: ${{ inputs.test_message }}"

   # ✅ 올바른 예시
   run: echo 'Test message - ${{ inputs.test_message }}'
   ```

3. **잘못된 workflow 경로**
   - 조직 `.github` 리포지토리의 경우 경로에 `.github`이 두 번 포함됩니다
   ```yaml
   # ✅ 올바른 경로
   uses: <조직명>/.github/.github/workflows/workflow-name.yml@main
   ```

#### ✅ 올바른 설정

```yaml
on:
  workflow_call:
    inputs:
      pr_number:
        required: true
        type: number
    secrets:
      OPENAI_API_KEY:
        required: true
      # GITHUB_TOKEN은 secrets: inherit로 자동 전달됨

jobs:
  my-job:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}  # secrets: inherit로 전달받음
```

### 5단계: 테스트

테스트용 PR을 생성하여 workflow가 정상 작동하는지 확인합니다:

```bash
# 테스트 브랜치 생성
git checkout -b test-centralized-workflow

# 테스트 파일 생성
echo "# Test" > test-file.md
git add test-file.md
git commit -m "test: verify centralized workflow"
git push -u origin test-centralized-workflow

# PR 생성
gh pr create --title "Test: Centralized Workflow" \
  --body "Testing the centralized GitHub Actions workflow"
```

## 🔧 트러블슈팅

### Workflow가 실행되지 않음 (jobs가 0개)

**증상**: GitHub Actions에서 workflow run은 생성되지만 jobs가 0개로 표시됨

**원인**:
1. 리포지토리가 private이고 Team 플랜을 사용 중
2. GITHUB_TOKEN이 secrets에 정의됨
3. YAML 구문 오류
4. Actions 권한 미설정

**해결책**:
1. 리포지토리를 public으로 변경하거나 Enterprise Cloud로 업그레이드
2. GITHUB_TOKEN을 secrets에서 제거
3. YAML linter로 구문 검증
4. Actions 권한 설정 (3단계 참조)

### Workflow 파일을 찾을 수 없음

**증상**: `error parsing called workflow: ... not found`

**해결책**: workflow 경로가 올바른지 확인
```yaml
# 조직 .github 리포지토리의 경우
uses: <조직명>/.github/.github/workflows/filename.yml@main
```

## 📊 성공 확인

Workflow가 성공적으로 실행되면:
- ✅ PR에 이중 언어 요약 코멘트 생성
- ✅ PR에 파일별 코드 리뷰 코멘트 생성
- ✅ `changes/` 디렉토리에 요약 파일 생성 (`PR-{번호}-{제목}.md`)
- ✅ `changes/index.md` 자동 업데이트

## 🔄 유지보수

### Workflow 업데이트

조직 `.github` 리포지토리에서 workflow 파일을 수정하면, 해당 workflow를 사용하는 모든 리포지토리에 자동으로 반영됩니다 (재실행 시).

```bash
cd <조직-workflow-리포>
# workflow 파일 수정
git add .github/workflows/
git commit -m "fix: update workflow logic"
git push
```

### 버전 관리

특정 버전을 고정하려면 브랜치 대신 태그 사용:

```yaml
# 최신 버전 사용 (권장하지 않음)
uses: Org/.github/.github/workflows/workflow.yml@main

# 특정 태그 버전 사용 (권장)
uses: Org/.github/.github/workflows/workflow.yml@v1.0.0

# 특정 커밋 SHA 사용 (가장 안전)
uses: Org/.github/.github/workflows/workflow.yml@abc123
```

## 📚 참고 자료

- [GitHub Actions: Reusing workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- [GitHub Actions: workflow_call trigger](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_call)
- [GitHub Team vs Enterprise Cloud 비교](https://docs.github.com/en/get-started/learning-about-github/githubs-plans)
