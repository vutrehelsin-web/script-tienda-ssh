#!/bin/bash
source /etc/tiendassh/assets/theme.conf 2>/dev/null || source ./assets/theme.conf 2>/dev/null

clear
echo -e "${NEON_BLUE}==========================================${NC}"
echo -e "${NEON_YELLOW}         🔄 RENOVAR USUARIO${NC}"
echo -e "${NEON_BLUE}==========================================${NC}"

read -p "Nombre del usuario a renovar: " username
if ! id "$username" &>/dev/null; then
    echo -e "${RED}❌ El usuario '$username' no existe.${NC}"
    read -p "Presiona Enter para regresar..."
    builtin exit 1
fi

read -p "Días adicionales a agregar (ej. 30): " days
if ! [[ "$days" =~ ^[0-9]+$ ]]; then
    days=30
fi

new_exp=$(date -d "+$days days" +%Y-%m-%d)
chage -E "$new_exp" "$username" 2>/dev/null
passwd -u "$username" 2>/dev/null

echo -e "${NEON_GREEN}✅ Usuario '$username' renovado hasta $new_exp.${NC}"
read -p "Presiona Enter para regresar..."
