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

事前準備:

1. gogcli を認証し(`gog auth add <email>`)、Google Cloud で Calendar API を有効化
2. `gog -a <email> calendar create-calendar "米経済指標"` でカレンダーを作成
3. `config.example.json` を `config.json` にコピーし、アカウントと手順2のカレンダー ID を設定
4. gog の keyring パスワードをキーチェーンに登録: `security add-generic-password -a "$USER" -s gogcli-keyring -w`
