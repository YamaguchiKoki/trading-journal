#!/bin/bash
# gog を非対話で呼ぶラッパー
# Usage: gog.sh <gog のサブコマンドと引数...>
# - アカウントは Vault ルートの config.json (git 追跡外) から読む
# - keyring パスワードは macOS キーチェーン (サービス名 gogcli-keyring) から読む

set -euo pipefail

VAULT_ROOT="$(cd "$(dirname "$0")/../../../.." && pwd)"
CONFIG_FILE="${VAULT_ROOT}/config.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "エラー: ${CONFIG_FILE} が見つかりません。config.example.json をコピーして作成してください。" >&2
  exit 1
fi

ACCOUNT=$(python3 -c "import json,sys; print(json.load(open(sys.argv[1]))['google_account'])" "$CONFIG_FILE")

export GOG_KEYRING_BACKEND="${GOG_KEYRING_BACKEND:-file}"
if [ -z "${GOG_KEYRING_PASSWORD:-}" ]; then
  if ! GOG_KEYRING_PASSWORD=$(security find-generic-password -s gogcli-keyring -w 2>/dev/null); then
    echo "エラー: キーチェーンに gogcli-keyring がありません。以下を実行して登録してください:" >&2
    echo '  security add-generic-password -a "$USER" -s gogcli-keyring -w' >&2
    exit 1
  fi
  export GOG_KEYRING_PASSWORD
fi

exec gog -a "$ACCOUNT" --no-input "$@"
