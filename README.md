# 手話サークルの企画レシピ

手話サークル運営者向けの企画ネタ集サイト。過去資料から抽出したレクリエーション企画を、フィルタリング可能な一覧で提供する。

公開URL: https://kappamanager.github.io/shuwa-circle-recipes/

## 構成

| ファイル | 役割 |
|---|---|
| `index.html` | サイト本体（Vanilla HTML/CSS/JS、依存はGoogle Fontsのみ） |
| `build.py` | `activities.xlsx` を読んで `index.html` の `ACTIVITIES` を書き換える |
| `init_xlsx.py` | 初回セットアップ（`index.html` から `activities.xlsx` を生成） |
| `build.bat` | `build.py` を Windows でダブルクリック実行する用 |

`activities.xlsx` はリポジトリに含まれていない。各自手元で生成して使う。

## 編集ワークフロー

1. リポジトリをクローン
2. 初回のみ `python init_xlsx.py` で `activities.xlsx` を生成
3. Excel で `activities.xlsx` を編集 → 保存
4. `build.bat` をダブルクリック（または `python build.py`）
5. `git add index.html && git commit && git push` で反映

## デザイン仕様

- フォント: Shippori Mincho（見出し） + Noto Sans JP（本文）
- カラー: ベージュ #F5F2ED 背景 + テラコッタ #B8533E 差し色
- レイアウト: 罫線区切りのリスト形式 + 縦書き難易度リボン
- レスポンシブ・印刷CSS対応

## データスキーマ（1企画あたり）

```json
{
  "id": 1,
  "title": "歯車トーク",
  "catch": "1対1のトークを繰り返す純度高めなトーク企画",
  "major": "交流系",
  "minor": "トーク",
  "time": "〜1時間",
  "people": "6〜15人",
  "diff": "やさしい",
  "prep": "不要",
  "purpose": "目的の説明",
  "design": ["設計ポイント1", "設計ポイント2"],
  "flow": ["手順1", "手順2", "手順3"],
  "schedule": {
    "total": "40分",
    "steps": [
      {"label": "ルール説明", "min": "5分"},
      {"label": "会話①", "min": "10分"}
    ]
  },
  "tips": "コツやアレンジ",
  "materials": "特になし"
}
```
