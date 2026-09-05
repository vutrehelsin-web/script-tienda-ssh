#!/bin/bash
source /etc/tiendassh/assets/theme.conf 2>/dev/null || source ./assets/theme.conf 2>/dev/null

clear
echo -e "${NEON_BLUE}==========================================${NC}"
echo -e "${NEON_PURPLE}     🔒 BLOQUEAR / DESBLOQUEAR USUARIO${NC}"
echo -e "${NEON_BLUE}==========================================${NC}"

read -p "Nombre del usuario: " username
if ! id "$username" &>/dev/null; then
    echo -e "${RED}❌ El usuario '$username' no existe.${NC}"
    read -p "Presiona Enter para regresar..."
    builtin exit 1
fi

status=$(passwd -S "$username" 2>/dev/null | awk '{print $2}')
if [ "$status" == "L" ]; then
    echo -e "Estado actual: ${RED}BLOQUEADO${NC}"
    read -p "¿Deseas desbloquear a $username? (s/n): " confirm
    if [[ "$confirm" =~ ^[Ss]$ ]]; then
        passwd -u "$username" 2>/dev/null
        echo -e "${NEON_GREEN}✅ Usuario desbloqueado.${NC}"
    fi
else
    echo -e "Estado actual: ${NEON_GREEN}ACTIVO${NC}"
    read -p "¿Deseas bloquear a $username? (s/n): " confirm
    if [[ "$confirm" =~ ^[Ss]$ ]]; then
        passwd -l "$username" 2>/dev/null
        pkill -u "$username" 2>/dev/null
        echo -e "${RED}🔒 Usuario bloqueado y conexiones cerradas.${NC}"
    fi
fi

read -p "Presiona Enter para regresar..."
