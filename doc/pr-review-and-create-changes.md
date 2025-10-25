# PR Change Summary & Code Review (OpenAI)

## 개요

이 워크플로우는 Pull Request가 열리거나 업데이트될 때 자동으로 실행되어, OpenAI GPT 모델을 활용하여 코드 변경사항을 분석하고 요약하며, 파일별 상세 코드 리뷰를 수행합니다.

## 트리거 조건

- **이벤트**: Pull Request가 `opened` 또는 `synchronize` 상태일 때
- **트리거**: PR이 처음 열리거나 새로운 커밋이 추가되었을 때

## 주요 기능

### 1. 변경사항 요약 (Bilingual Summary)

OpenAI GPT-4o-mini 모델을 사용하여 코드 변경사항을 한국어와 영어로 요약합니다.

**생성되는 내용:**
- 🧠 변경 요약 (Korean): 개요, 변경 파일, 주요 변경 내용, 영향 및 리스크
- 💬 Change Summary (English): Overview, Changed Files, Key Changes, Impact/Risks

**저장 위치**: `changes/{date}-{sha}-{title}.md`

### 2. 파일별 코드 리뷰

변경된 각 파일에 대해 상세한 코드 리뷰를 수행합니다.

**리뷰하는 파일 유형:**
- Python (`.py`)
- JavaScript/TypeScript (`.js`, `.ts`, `.tsx`, `.jsx`)
- Java (`.java`)
- Go (`.go`)
- Ruby (`.rb`)
- PHP (`.php`)
- C/C++ (`.c`, `.cpp`)
- C# (`.cs`)
- YAML (`.yaml`, `.yml`)
- JSON (`.json`)

**리뷰 항목:**
- 📋 파일 개요: 주요 변경사항 요약
- ✅ 잘된 점: 좋은 코딩 관행이나 개선사항
- 🐛 발견된 이슈: 버그, 잠재적 문제, 에러 처리 누락 (심각도별 분류)
- 💡 개선 제안: 성능, 가독성, 유지보수성 개선 방안
- 🔒 보안 고려사항: 보안 취약점 분석

**제한사항:**
- 최대 10개 파일까지만 리뷰 (API 비용 절감)
- 삭제된 파일이나 바이너리 파일은 자동으로 스킵

### 3. PR 코멘트 자동 작성

코드 리뷰 결과를 PR에 코멘트로 자동 작성합니다.

**코멘트 내용:**
- 리뷰된 파일 목록
- 각 파일의 추가/삭제 라인 수
- 상세한 리뷰 내용
- 심각도별 이슈 분류

### 4. 변경사항 인덱스 관리

`changes/index.md` 파일을 자동으로 생성/업데이트하여 모든 변경사항을 관리합니다.

**인덱스 형식:**
```markdown
# Change Index

- [2024.01.15 feature-user-auth](./2024.01.15-abc123-feature-user-auth.md)
- [2024.01.14 bugfix-login-error](./2024.01.14-def456-bugfix-login-error.md)
```

**정렬**: 날짜 기준 내림차순

## 워크플로우 단계

### Step 1: Checkout source
- PR의 head 브랜치를 체크아웃
- 전체 히스토리 fetch (fetch-depth: 0)

### Step 2: Set up Python
- Python 3.11 환경 설정

### Step 3: Install dependencies
- `openai`, `requests` 패키지 설치

### Step 4: Get commit info
- 커밋 날짜, SHA, 제목 정보 추출
- 파일명에 사용할 안전한 형식으로 변환

### Step 5: Extract diff
- base 브랜치와의 차이점 추출
- `diff.patch` 파일로 저장

### Step 6: AI Summary & File-by-File Review
- OpenAI API를 사용하여 변경사항 요약 생성
- GitHub API를 통해 변경된 파일 목록 가져오기
- 각 파일에 대해 AI 코드 리뷰 수행
- 결과를 PR에 코멘트로 작성
- `changes/` 폴더에 요약 파일 저장

### Step 7: Commit and push summary + index
- 생성된 요약 파일과 인덱스를 커밋
- GitHub Actions 봇 계정으로 커밋 (CI 스킵)

### Step 8: Comment index.md to PR
- `changes/index.md`를 PR에 sticky 코멘트로 추가
- sticky 코멘트는 기존 코멘트를 업데이트함

## 필요한 시크릿

### OPENAI_API_KEY
- OpenAI API 키
- GPT-4o-mini 모델을 사용하기 위한 인증

### GITHUB_TOKEN
- GitHub API 접근을 위한 토큰
- 기본적으로 자동 제공됨

## 필요한 권한

- `contents: write`: 파일 커밋 및 푸시
- `pull-requests: write`: PR 코멘트 작성

## 출력 예시

### 변경사항 요약 파일
```markdown
# 🧠 변경 요약 (Korean)

## 개요
사용자 인증 기능을 추가했습니다.

## 변경 파일
- src/auth.py
- src/models.py

## 주요 변경 내용
- JWT 토큰 기반 인증 구현
- 사용자 모델에 비밀번호 해싱 추가

## 영향 및 리스크
- 기존 API 엔드포인트는 영향 없음
- 새 인증 미들웨어 추가 필요
```

### 코드 리뷰 코멘트
```markdown
## 🤖 AI Code Review

**총 2개 파일 리뷰 완료**

---

## 📄 `src/auth.py`
*+50 -10*

### 📋 파일 개요
JWT 기반 인증 로직을 구현했습니다.

### ✅ 잘된 점
- 환경 변수를 통한 시크릿 관리
- 명확한 에러 메시지

### 🐛 발견된 이슈
- [WARNING] 토큰 만료 시간 검증 누락

### 💡 개선 제안
- 토큰 refresh 로직 추가 고려
```

## 비용 관리

- GPT-4o-mini 모델 사용 (비용 효율적)
- 최대 10개 파일만 리뷰 (자동 제한)
- 큰 diff는 처음 15,000자만 요약에 사용

## 이점

1. **자동화된 코드 리뷰**: PR마다 일관된 리뷰 제공
2. **다국어 지원**: 한국어와 영어로 요약 생성
3. **히스토리 관리**: 모든 변경사항을 `changes/` 폴더에 기록
4. **신속한 피드백**: PR 작성 즉시 리뷰 제공
5. **비용 효율적**: GPT-4o-mini 사용 및 파일 수 제한

## 주의사항

1. **API 비용**: OpenAI API 사용으로 인한 비용 발생
2. **AI 의존성**: 리뷰 내용은 AI가 생성한 것이므로 항상 검증 필요
3. **파일 제한**: 10개 파일을 초과하는 변경사항은 전체 리뷰 불가
4. **보안**: 시크릿 관리에 주의 필요

