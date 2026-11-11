# dsh-TUI 한국어 패치

[`@deepseek-harness-tui/dsh-tui`](https://www.npmjs.com/package/@deepseek-harness-tui/dsh-tui) 의 터미널 UI를 한국어로 바꾸는 **비공식** 로컬 패치입니다.

- 대상 버전: **0.19.0**
- 방식: 프로필에 설치된 패키지의 `lib/types` 에 `*.ko.js` 사전 모듈을 추가하고, 언어 분기 코드 10곳을 패치
- 명령어·경로·환경변수·모델명·단축키는 원문 그대로 둡니다.

## 커버리지

| 영역 | 내용 | 상태 |
|---|---|---|
| UI 문자열 | i18n 사전 **2,200키** (`i18n.ko.js`) | ✅ |
| `/tips` 패널 | 팁 **146개** + 그룹 5개 | ✅ |
| `/settings` 목록 | 필드 58 · 옵션 58 · 그룹 8 = **119개** | ✅ |
| 스플래시 태그라인 | codex / claude 브랜드 | ✅ |
| 쿠폰 프롬프트 통화 | `위안` / `달러` | ✅ |
| `/settings` 힌트 문단 | 57개 (포커스 시 우측 패널) | ❌ 영어 유지 |
| 플러그인 자체 설정 섹션 | 해당 플러그인 언어를 따름 | — |

## 요구 사항

- dsh-TUI **0.19.0** (`~/.dsh/profiles/dsh-tui` 에 설치되어 있어야 함)
- Node.js 18+

## 적용

```powershell
git clone https://github.com/artists2/dsh-tui-korean.git
cd dsh-tui-korean
node apply.mjs
```

Windows에서는 `reapply.cmd` 를 더블클릭해도 됩니다.

패키지 경로가 기본값(`~/.dsh/profiles/dsh-tui/node_modules/@deepseek-harness-tui/dsh-tui`)과 다르면:

```powershell
node apply.mjs --pkg "C:\path\to\@deepseek-harness-tui\dsh-tui"
# 또는
node apply.mjs --profile my-profile
# 또는
$env:DSH_TUI_PKG = "C:\path\to\dsh-tui"; node apply.mjs
```

적용 후 TUI를 재시작하고 `/lang` → **한국어** 를 선택하세요. 선택값은 `~/.dsh-tui/lang.json` 에 저장됩니다.

## 동작 방식

`apply.mjs` 가 하는 일:

1. `lib/types/i18n.ko.js`, `tips.ko.js`, `settings.ko.js`, `brand.ko.js` 생성
2. 10개 파일 패치 (각 파일은 첫 실행 시 `*.ko-orig` 로 백업)

| 파일 | 패치 내용 |
|---|---|
| `i18n.js` | `LANGS` 에 `ko` 추가, `isLang`/`PluralRules`/`t()`/`tOr()` 분기 |
| `components/LangPicker.js` | `/lang` 목록에 한국어 |
| `screens/Chat.js` | `/lang` 오버레이 초기 인덱스 |
| `dsh-adapter/channel/command-completions.js` | `/lang` 인자 자동완성 |
| `components/TipsPanel.js` | `TIP_KO` 분기 |
| `components/LogoV2.js` | 브랜드 태그라인 ko |
| `components/StarPrompt.js` | 통화 단위 |
| `screens/Settings.js` | `pick()` 에 ko 분기 |
| `settings/definitions.js` | Language 선택지에 `한국어` |
| `dsh-adapter/plugin.js` | config 스키마 `['zh','en','ko']` |

스크립트는 **멱등**입니다. 여러 번 실행해도 `*.ko-orig` 원본에서 다시 패치하므로 안전합니다.

## TUI 업데이트 후

업데이트는 `lib/types` 를 통째로 교체하므로 패치가 사라집니다. 새 버전에서 다시 실행하세요:

```powershell
node apply.mjs
```

이전 버전의 `*.ko-orig` 백업은 `.applied-version` 을 보고 자동으로 폐기됩니다.
새 버전에 키가 추가되면 그 키만 영어로 표시되고(폴백), 나머지는 한국어로 유지됩니다.

## 되돌리기

```powershell
Get-ChildItem -Recurse "$env:USERPROFILE\.dsh\profiles\dsh-tui\node_modules\@deepseek-harness-tui\dsh-tui\lib\types" -Filter *.ko-orig |
  ForEach-Object { Copy-Item $_.FullName ($_.FullName -replace '\.ko-orig$','') -Force }
```

그다음 `~/.dsh-tui/lang.json` 을 지우면 기본값(중국어)으로 돌아갑니다.

## 알려진 한계

- `/settings` 의 **힌트 문단 57개는 아직 영어**입니다. `settings.ko.json` 에 `hintDescriptions.zh` 를 키로 추가하면 반영됩니다.
- 플러그인이 자체 등록한 설정 섹션 문구는 그 플러그인의 언어를 따릅니다.
- 하위 에이전트/도구가 출력하는 본문은 모델이 쓰는 언어라 이 패치와 무관합니다.
- TUI 업데이트 때마다 재적용이 필요합니다(자동 훅 없음).

## 기여

번역 수정은 각 JSON 을 고친 뒤 `node apply.mjs` 로 반영하면 됩니다.

- `ko.json` — i18n 사전 (`키: 번역`)
- `tips.ko.json` — `{ "groups": {...}, "tips": { "tip-id": "번역" } }`
- `settings.ko.json` — **중국어 원문을 키로** 쓰는 한국어 매핑

## 면책

이 저장소는 dsh-TUI 및 DeepSeek와 **무관한 비공식 팬 번역**입니다. 패치 스크립트와 번역 데이터는 원 저작권자의 권리를 침해할 의도가 없으며, 문제가 될 경우 요청 시 저장소를 내리겠습니다.

## 라이선스

[MIT](LICENSE)
