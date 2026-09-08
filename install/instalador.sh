#!/usr/bin/env bash
set -euo pipefail

KEY=""
for argument in "$@"; do
    case "$argument" in
        --key=*) KEY="${argument#--key=}" ;;
        *) [[ -z "$KEY" ]] && KEY="$argument" ;;
    esac
done
REPOSITORY_URL="${REPOSITORY_URL:-https://github.com/vutrehelsin-web/script-tienda-ssh.git}"
INSTALL_ROOT="${INSTALL_ROOT:-/etc/tiendassh}"

if [[ ! "$KEY" =~ ^[a-fA-F0-9]{32}$ ]]; then
    echo "Uso: $0 --key=<key-de-32-caracteres>" >&2
    exit 2
fi

if [[ "${EUID}" -ne 0 ]]; then
    echo "Este instalador debe ejecutarse como root." >&2
    exit 1
fi

if command -v apt-get >/dev/null; then
    apt-get update -y
    apt-get install -y git sqlite3 curl wget openssl
elif command -v dnf >/dev/null; then
    dnf install -y git sqlite curl wget openssl
elif command -v yum >/dev/null; then
    yum install -y git sqlite curl wget openssl
elif command -v apk >/dev/null; then
    apk add --no-cache git sqlite curl wget openssl
elif command -v pacman >/dev/null; then
    pacman -Sy --noconfirm git sqlite curl wget openssl
else
    echo "No se encontró apt-get, dnf, yum, apk ni pacman." >&2
    echo "Instalá manualmente: git, sqlite3, curl, wget y openssl." >&2
    exit 1
fi

command -v git >/dev/null || { echo "Falta git; instalalo antes de continuar." >&2; exit 1; }
command -v sqlite3 >/dev/null || { echo "Falta sqlite3; instalalo antes de continuar." >&2; exit 1; }

tmp_dir="$(mktemp -d)"
cleanup() { rm -rf "$tmp_dir"; }
trap cleanup EXIT

git clone --depth 1 "$REPOSITORY_URL" "$tmp_dir/repository" >/dev/null
mkdir -p "$INSTALL_ROOT"/{modules,assets,bin}
cp -r "$tmp_dir/repository/modules/." "$INSTALL_ROOT/modules/"
cp -r "$tmp_dir/repository/assets/." "$INSTALL_ROOT/assets/" 2>/dev/null || true
cp -r "$tmp_dir/repository/bin/." "$INSTALL_ROOT/bin/" 2>/dev/null || true

printf '%s\n' "$KEY" > "$INSTALL_ROOT/key.txt"
chmod 600 "$INSTALL_ROOT/key.txt"
chmod +x "$INSTALL_ROOT/modules/"*.sh 2>/dev/null || true

echo "TiendaSSH instalado correctamente."
echo "Key: $KEY"
