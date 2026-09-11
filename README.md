# 끓임 시간 계산기 — GitHub Pages 배포 안내

## Supabase 설정 (배포 전 딱 한 번)

1. https://supabase.com 에서 GitHub 계정으로 로그인 → New Project 생성
2. 왼쪽 메뉴 SQL Editor → 이 폴더의 `supabase_setup.sql` 내용을 그대로 붙여넣고 Run
3. 왼쪽 메뉴 Project Settings → API → **Project URL**과 **anon public 키** 복사
4. `index.html`을 열어서 아래 두 줄을 본인 값으로 교체:
   ```js
   const SUPABASE_URL = 'YOUR-PROJECT.supabase.co';       // ← Project URL로 교체
   const SUPABASE_ANON_KEY = 'YOUR-ANON-PUBLIC-KEY';       // ← anon public 키로 교체
   ```
   (anon public 키는 클라이언트 코드에 그대로 노출돼도 되는 값입니다. **service_role 키는 절대 여기 넣지 마세요.**)

이 네 단계만 하면 크라우드소싱 제보가 실제로 여러 사람 사이에서 공유되는 데이터베이스에 쌓입니다.

## 폴더 구조
```
index.html                      ← 계산기 본체
manifest.json                   ← PWA 설정 (앱 이름, 아이콘, 색상)
sw.js                           ← 오프라인 캐싱용 서비스 워커
icons/icon-192.png              ← PWA 아이콘 (작은 크기)
icons/icon-512.png              ← PWA 아이콘 (큰 크기)
data/official-experiment.json   ← 공식 실험 데이터 (계산에 쓰이는 숫자들)
data/experiment-raw.xlsx        ← 실험 원자료 엑셀 (다운로드 버튼용)
supabase_setup.sql              ← Supabase에서 한 번만 실행하면 되는 테이블/보안규칙 생성 스크립트
```

## 배포 방법 (GitHub Pages)

1. GitHub에서 새 저장소(repository)를 만듭니다. (이름은 뭐든 상관없음, 예: `boiling-calculator`)
2. 이 폴더 안의 파일 전체(`index.html`, `manifest.json`, `sw.js`, `icons/`, `data/`)를 저장소 루트에 그대로 업로드합니다.
   - GitHub 웹사이트에서 "Add file → Upload files"로 드래그해서 올려도 되고, git 명령어를 쓸 줄 아시면 `git add . && git commit -m "deploy" && git push`도 됩니다.
   - **폴더 구조를 그대로 유지해야 합니다.** (`data/`, `icons/` 폴더 안에 파일이 들어있는 상태 그대로)
3. 저장소의 `Settings` → `Pages` 메뉴로 들어갑니다.
4. `Source`를 `Deploy from a branch`로, `Branch`를 `main`(또는 `master`) / `/(root)`로 설정하고 저장합니다.
5. 몇 분 기다리면 `https://<사용자아이디>.github.io/<저장소이름>/` 주소로 접속 가능해집니다.
6. 모바일 브라우저로 그 주소에 들어간 뒤 "홈 화면에 추가"를 누르면 앱처럼 아이콘이 생기고 전체화면으로 실행됩니다.

## ⚠️ 로컬에서 미리 테스트할 때 주의할 점

`index.html` 파일을 그냥 더블클릭해서 열면(`file://` 방식) **실험 데이터가 안 불러와집니다.** 브라우저 보안 정책 때문에 `file://` 환경에서는 `fetch()`로 옆에 있는 JSON 파일을 못 읽어옵니다.

로컬에서 확인하고 싶다면 터미널에서 이 폴더 위치로 이동한 뒤:
```
python3 -m http.server 8000
```
그리고 브라우저에서 `http://localhost:8000` 으로 접속하면 정상 작동합니다. (GitHub Pages에 올리면 이 문제 자체가 없습니다 — https로 서빙되니까요.)

## 나중에 데이터만 교체하고 싶을 때

- **공식 실험 데이터 교체** (예: 아두이노 실험 완료 후): `data/official-experiment.json` 파일 내용만 새 값으로 바꿔서 다시 업로드하면 끝. `index.html`은 건드릴 필요 없습니다.
- **엑셀 다운로드 파일 교체**: `data/experiment-raw.xlsx` 파일만 새 파일로 교체(같은 파일명 유지)하면 끝.
- **크라우드소싱 데이터베이스 (Supabase)**: `crowd_entries` 테이블에 모든 제보가 저장됩니다. 데이터를 직접 보거나 내려받고 싶으면 Supabase 대시보드 → Table Editor에서 확인하거나, SQL Editor에서 `select * from crowd_entries;` 실행 후 CSV로 내보내면 됩니다.
- **설정 방법**: `index.html` 상단 `SUPABASE_URL`, `SUPABASE_ANON_KEY` 두 값을 본인 프로젝트 값으로 바꾸고, `supabase_setup.sql`을 Supabase SQL Editor에서 한 번 실행하면 끝입니다.

## 화면에 뜨는 안내 문구

`SUPABASE_URL` / `SUPABASE_ANON_KEY`를 아직 채우지 않았다면 크라우드소싱 탭에 "데이터베이스 연결 설정이 안 됐어요"라는 안내가 뜨고 제보 버튼이 비활성화됩니다. 값을 채우면 자동으로 사라집니다.
