#!/usr/bin/env bash
set -euo pipefail
KEY=""
for argument in "$@"; do case "$argument" in --key=*) KEY="${argument#--key=}";; *) [[ -z "$KEY" ]] && KEY="$argument";; esac; done
REPOSITORY_URL="${REPOSITORY_URL:-https://github.com/vutrehelsin-web/script-tienda-ssh.git}"
INSTALL_ROOT="${INSTALL_ROOT:-/etc/tiendassh}"
[[ "$KEY" =~ ^[a-fA-F0-9]{32}$ ]] || { echo "Uso: $0 --key=<key-de-32-caracteres>" >&2; exit 2; }
[[ "${EUID}" -eq 0 ]] || { echo "Este instalador debe ejecutarse como root." >&2; exit 1; }
if command -v apt-get >/dev/null; then apt-get update -y; apt-get install -y git sqlite3 curl wget openssl python3
elif command -v dnf >/dev/null; then dnf install -y git sqlite curl wget openssl python3
elif command -v yum >/dev/null; then yum install -y git sqlite curl wget openssl python3
elif command -v apk >/dev/null; then apk add --no-cache git sqlite curl wget openssl python3
elif command -v pacman >/dev/null; then pacman -Sy --noconfirm git sqlite curl wget openssl python3
else echo "No se encontró un gestor de paquetes compatible." >&2; exit 1; fi
command -v git >/dev/null || { echo "Falta git." >&2; exit 1; }; command -v sqlite3 >/dev/null || { echo "Falta sqlite3." >&2; exit 1; }
tmp_dir="$(mktemp -d)"; trap 'rm -rf "$tmp_dir"' EXIT
git clone --depth 1 "$REPOSITORY_URL" "$tmp_dir/repository" >/dev/null
mkdir -p "$INSTALL_ROOT"/{modules,assets,bin,data,api}
cp -r "$tmp_dir/repository/modules/." "$INSTALL_ROOT/modules/"; cp -r "$tmp_dir/repository/assets/." "$INSTALL_ROOT/assets/" 2>/dev/null || true; cp -r "$tmp_dir/repository/bin/." "$INSTALL_ROOT/bin/"; cp "$tmp_dir/repository/api/key_api.py" "$INSTALL_ROOT/api/key_api.py"
sqlite3 "$INSTALL_ROOT/data/keys.db" <<'SQL'
CREATE TABLE IF NOT EXISTS keys (id INTEGER PRIMARY KEY AUTOINCREMENT,key TEXT UNIQUE NOT NULL,user_id TEXT NOT NULL,user_name TEXT NOT NULL,plan TEXT NOT NULL,status TEXT NOT NULL DEFAULT 'pendiente',created_at TEXT NOT NULL,activated_at TEXT,expires_at TEXT);
SQL
printf '%s\n' "$KEY" > "$INSTALL_ROOT/key.txt"; chmod 600 "$INSTALL_ROOT/key.txt"; chmod +x "$INSTALL_ROOT/bin/"* "$INSTALL_ROOT/modules/"*.sh 2>/dev/null || true
if [[ ! -f "$INSTALL_ROOT/api.env" ]]; then printf 'KEY_API_TOKEN=%s\nKEY_API_PORT=8890\nDB_PATH=%s/data/keys.db\n' "$(openssl rand -hex 32)" "$INSTALL_ROOT" > "$INSTALL_ROOT/api.env"; chmod 600 "$INSTALL_ROOT/api.env"; fi
cat > /etc/systemd/system/tiendassh-key-api.service <<EOF
[Unit]
Description=TiendaSSH key API
After=network-online.target
[Service]
Type=simple
EnvironmentFile=$INSTALL_ROOT/api.env
ExecStart=/usr/bin/python3 $INSTALL_ROOT/api/key_api.py
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
if command -v systemctl >/dev/null; then systemctl daemon-reload; systemctl enable --now tiendassh-key-api.service; fi
ln -sf "$INSTALL_ROOT/bin/menu" /usr/local/bin/menu; ln -sf "$INSTALL_ROOT/bin/tiendassh" /usr/local/bin/tiendassh
echo "TiendaSSH instalado correctamente."; echo "API token: cat $INSTALL_ROOT/api.env"; echo "Panel: menu"
