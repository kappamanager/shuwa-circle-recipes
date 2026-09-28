# 手話サークルの企画レシピ

手話サークル運営者向けの企画ネタ集サイト。過去資料から抽出したレクリエーション企画を、フィルタリング可能な一覧で提供する。

公開URL: https://kappamanager.github.io/shuwa-circle-recipes/

## 構成

| ファイル | 役割 |
|---|---|
| `index.html` | サイト本体（Vanilla HTML/CSS/JS、依存はGoogle Fontsのみ） |
| `data.js` | 企画データ（`const ACTIVITIES = [...]`）。`build.py` で再生成される |
| `build.py` | `activities.xlsx` を読んで `data.js` の `ACTIVITIES` を書き換える |
| `init_xlsx.py` | `data.js` から `activities.xlsx` を生成する（xlsx が無いときに1回だけ） |
| `build.bat` | `build.py` を Windows でダブルクリック実行する用 |
| `tools/publish.bat` | 手元の作業フォルダからリポジトリへコピーして push する用（下記参照） |
| `images/`, `robots.txt`, `sitemap.xml` | OGP画像・クローラー向け設定 |

`activities.xlsx` はリポジトリに含めない（`.gitignore`）。`data.js` が正本で、xlsx はそこからいつでも作り直せる。

フィルターの選択肢は表示時に `ACTIVITIES` から自動生成されるので、新しい値を追加しても `index.html` の修正は不要。

## 普段の更新（手元の作業フォルダ構成）

```
93_手話サークル企画リスト/
├─ 003_site/          ← 編集元（index.html, data.js, activities.xlsx, build.py ...）
├─ 004_pages_repo/    ← このリポジトリ
└─ publish.bat        ← tools/publish.bat と同じもの
```

1. `003_site/activities.xlsx` を Excel で編集 → 保存して閉じる
2. `003_site/build.bat` をダブルクリック（`data.js` が再生成される）
3. `publish.bat` をダブルクリック（`003_site` の内容をこのリポジトリへコピー → commit → push）

## PCを入れ替えたとき・リポジトリから復旧するとき

1. リポジトリをクローン
2. `pip install openpyxl`
3. `python init_xlsx.py` で `data.js` から `activities.xlsx` を生成
4. 上記の作業フォルダ構成を作る場合は、クローンした中身を `003_site/` にもコピーし、`tools/publish.bat` を親フォルダに置く
   - リポジトリ内だけで作業する場合は、xlsx 編集 → `build.bat` → `git add data.js && git commit && git push` でも反映できる

## デザイン仕様

- フォント: Shippori Mincho（見出し） + Noto Sans JP（本文）
- カラー: ベージュ #F5F2ED 背景 + テラコッタ #B8533E 差し色
- レイアウト: 罫線区切りのリスト形式 + 縦書き難易度リボン
- レスポンシブ・印刷CSS対応

## データスキーマ（1企画あたり）

```js
{
  id: 1,
  title: "積み木自己紹介",
  catch: "記憶力×自己紹介。アイスブレイクの定番。",
  major: "交流系",                 // "交流系" | "学習系"
  minor: "アイスブレイク",          // 交流系: アイスブレイク / ゲーム / トーク / その他
                                   // 学習系: 表現練習 / 読取練習 / 文法 / その他
  time: "16〜30分",                // "15分以内" | "16〜30分" | "31〜45分" | "46〜60分" | "60分超"
  people: ["〜5人", "6〜15人"],     // 配列。"〜5人" | "6〜15人" | "16人〜"（いずれか一致でヒット）
  diff: "やさしい",                 // "やさしい" | "ふつう" | "しっかり"
  prep: "不要",                    // "不要" | "必要"
  purpose: "目的の説明",
  design: ["設計ポイント1", "設計ポイント2"],  // string | string[]
  flow: ["手順1", "手順2", "手順3"],           // string[]
  schedule: {                                 // null | object
    total: "20分",
    steps: [
      { label: "ルール説明", min: "5分" },
      { label: "自己紹介リレー1周", min: "10分" }
    ]
  },
  tips: ["コツ1", "コツ2"],        // string | string[]
  materials: "特になし"
}
```

### xlsx での書き方

- `people` / `design` / `flow` / `tips`: セル内改行で区切ると配列になる（1行なら文字列。`people` と `flow` は常に配列）
- `schedule_total` と `schedule_steps`: 両方埋めるか両方空（空なら `schedule: null`）
- `schedule_steps`: 1行1ステップで `5分：ルール説明` の形式
