#!/usr/bin/env bash
set -euo pipefail

# Generador de keys TiendaSSH.
DB_PATH="${DB_PATH:-./data/keys.db}"
USER_ID="${1:?Telegram user ID is required}"
USER_NAME="${2:?Telegram user name is required}"
PLAN="${3:-30}"
DATE="$(date '+%Y-%m-%d %H:%M:%S')"
KEY="$(openssl rand -hex 16)"

escape_sql() {
    printf '%s' "$1" | sed "s/'/''/g"
}

mkdir -p "$(dirname "$DB_PATH")"
sqlite3 "$DB_PATH" <<SQL
CREATE TABLE IF NOT EXISTS keys (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  key TEXT UNIQUE NOT NULL,
  user_id TEXT NOT NULL,
  user_name TEXT NOT NULL,
  plan TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pendiente',
  created_at TEXT NOT NULL,
  activated_at TEXT,
  expires_at TEXT
);
INSERT INTO keys (key, user_id, user_name, plan, status, created_at)
VALUES ('$(escape_sql "$KEY")', '$(escape_sql "$USER_ID")',
        '$(escape_sql "$USER_NAME")', '$(escape_sql "$PLAN")',
        'pendiente', '$(escape_sql "$DATE")');
SQL

INSTALLER_URL="${INSTALLER_URL:-https://raw.githubusercontent.com/vutrehelsin-web/script-tienda-ssh/main/install/instalador.sh}"
cat <<EOF
📦 Instalador TiendaSSH (copiar y pegar en tu VPS)

wget $INSTALLER_URL -O instalador.sh
chmod +x instalador.sh
./instalador.sh --key=$KEY

---------------------------------------------

🔑 Tu key de instalación:
$KEY

⏳ Validez: $PLAN días
👤 Usuario: @$USER_NAME
EOF
