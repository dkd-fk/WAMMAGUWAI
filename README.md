# 끓임 시간 계산기 — GitHub Pages 배포 안내

## 폴더 구조
```
index.html                      ← 계산기 본체
manifest.json                   ← PWA 설정 (앱 이름, 아이콘, 색상)
sw.js                           ← 오프라인 캐싱용 서비스 워커
icons/icon-192.png              ← PWA 아이콘 (작은 크기)
icons/icon-512.png              ← PWA 아이콘 (큰 크기)
data/official-experiment.json   ← 공식 실험 데이터 (계산에 쓰이는 숫자들)
data/experiment-raw.xlsx        ← 실험 원자료 엑셀 (다운로드 버튼용)
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
- **크라우드소싱 제보 데이터 확인/추출**: 지금 버전은 `window.storage`(claude.ai 전용 저장소)가 없는 환경에서는 방문자의 브라우저 `localStorage`에만 저장됩니다 — 즉 **다른 사람 데이터와 서버에서 합쳐지지 않습니다.** 여러 사람의 제보를 한 곳에 모으려면 Firebase, Supabase 같은 무료 백엔드 연동이 필요합니다. 이건 이후 단계에서 `index.html` 안의 `storageSet` / `storageGet` / `storageListKeys` 세 함수만 해당 서비스 API 호출로 바꿔주면 나머지 코드는 그대로 동작하도록 만들어뒀습니다.

## 화면에 뜨는 안내 문구

크라우드소싱 탭을 열면 "지금 이 버전은 공용 서버가 연결되기 전이라 이 브라우저에만 저장돼요"라는 안내가 자동으로 표시됩니다. 백엔드를 연동하면 이 문구는 `HAS_CLAUDE_STORAGE` 관련 로직을 정리하면서 같이 정리하면 됩니다.
