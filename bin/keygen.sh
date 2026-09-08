#!/usr/bin/env bash
set -euo pipefail

MODULE="/etc/tiendassh/modules/keygen.sh"
if [[ ! -x "$MODULE" ]]; then
    MODULE="$(dirname "$0")/../modules/keygen.sh"
fi

if [[ $# -eq 0 ]]; then
    USER_ID="${USER_ID:-0}"
    USER_NAME="${USER_NAME:-local}"
    PLAN="${PLAN:-30}"
else
    USER_ID="$1"
    USER_NAME="${2:-local}"
    PLAN="${3:-30}"
fi

exec bash "$MODULE" "$USER_ID" "$USER_NAME" "$PLAN"
