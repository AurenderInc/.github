# GitHub Actions 워크플로우 문서

이 디렉토리는 `.github/workflows` 폴더에 있는 GitHub Actions 워크플로우들에 대한 상세한 문서를 제공합니다.

## 워크플로우 목록

### [PR Change Summary & Code Review](./pr-review-and-create-changes.md)

**요약**: Pull Request가 열리거나 업데이트될 때 AI를 활용하여 코드 변경사항을 분석하고 요약하며, 파일별 상세 코드 리뷰를 자동으로 수행합니다.

**주요 기능**:
- ✅ 한국어/영어 이중 언어 요약 생성
- ✅ 파일별 AI 코드 리뷰 (최대 10개 파일)
- ✅ PR에 자동 코멘트 작성
- ✅ 변경사항 히스토리 관리 (`changes/` 폴더)

**사용 기술**: OpenAI GPT-4o-mini, Python, GitHub API

**트리거**: PR `opened`, `synchronize` 이벤트

---

### [Merge Change Summary](./merge-change-summary.md)

**요약**: Base 브랜치에 merge될 때마다 자동으로 실행되어, 머지된 커밋의 변경사항을 AI로 분석하고 한글로 요약한 문서를 생성합니다.

**주요 기능**:
- ✅ Base 브랜치 merge 시 자동 실행
- ✅ 변경사항을 AI로 분석하여 한글 요약 생성
- ✅ `changes/` 폴더에 문서 자동 저장
- ✅ 파일명 형식: `YYYY-MM-DD_AuthorName_CHANGE_SUMMARY.md`
- ✅ UTF-8 Unicode 형식의 한글 문서 생성
- ✅ `changes/index.md` 자동 업데이트

**사용 기술**: OpenAI GPT-4o-mini, Python, GitHub API

**트리거**: Base 브랜치 `push` 이벤트 (aurender/**, main, master, auMpd 등)

---

## 시작하기

각 워크플로우 문서를 클릭하여 상세한 설명, 설정 방법, 사용 예시를 확인하세요.

## 공통 시크릿 설정

모든 워크플로우는 GitHub 저장소의 Settings > Secrets and variables > Actions에서 다음 시크릿을 설정해야 합니다:

- `OPENAI_API_KEY`: OpenAI API 키 (워크플로우에서 필요시)

## 문제 해결

워크플로우 실행 중 문제가 발생하면:
1. GitHub Actions 탭에서 실패한 워크플로우 확인
2. 각 단계의 로그 확인
3. 시크릿 설정 확인
4. 권한 설정 확인

## 기여하기

워크플로우를 개선하려면:
1. 새로운 워크플로우 추가
2. 기존 워크플로우 개선
3. 문서 업데이트

**마지막 업데이트**: 2024년

