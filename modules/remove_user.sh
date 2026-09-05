#!/bin/bash
source /etc/tiendassh/assets/theme.conf 2>/dev/null || source ./assets/theme.conf 2>/dev/null

clear
echo -e "${NEON_BLUE}==========================================${NC}"
echo -e "${RED}         🗑️ REMOVER USUARIO${NC}"
echo -e "${NEON_BLUE}==========================================${NC}"

read -p "Nombre del usuario a remover: " username
if [ -z "$username" ]; then
    echo -e "${RED}❌ Usuario no especificado.${NC}"
    read -p "Presiona Enter para continuar..."
    builtin exit 1
fi

if id "$username" &>/dev/null; then
    userdel -f "$username" 2>/dev/null
    if [ -f /etc/tiendassh/users.db ]; then
        sed -i "/^$username|/d" /etc/tiendassh/users.db 2>/dev/null
    fi
    echo -e "${NEON_GREEN}✅ Usuario '$username' eliminado correctamente.${NC}"
else
    echo -e "${RED}❌ El usuario '$username' no existe.${NC}"
fi

read -p "Presiona Enter para regresar..."
