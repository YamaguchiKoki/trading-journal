# trading-journal

ドル円1分足スキャルピングのトレード日誌(Obsidian Vault)。損益は pips のみで記録する。

- [ルール](ルール.md)
- `日誌/` 毎日のノート(テンプレ: `テンプレ/デイリー.md`, `テンプレ/トレード.md`)
- `指標/` 月ごとの米経済指標スケジュール

## Claude Code スキル

この Vault で Claude Code を起動して使う。

### 経済指標をカレンダーに登録

```
/register-indicators 11月分
```

公式スケジュールで発表日時を確認し、Google カレンダーの「米経済指標」カレンダー(Notion Calendar にも表示される)に登録して、`指標/YYYY-MM.md` にまとめる。

事前準備: Google カレンダーで「米経済指標」カレンダーを作成し、Claude Code から Google Calendar コネクタを使えるようにしておく。
