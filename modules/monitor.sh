#!/bin/bash
source /etc/tiendassh/assets/theme.conf 2>/dev/null || source ./assets/theme.conf 2>/dev/null

clear
echo -e "${NEON_BLUE}==========================================${NC}"
echo -e "${NEON_GREEN}    📊 MONITOR DE CONEXIONES EN TIEMPO REAL${NC}"
echo -e "${NEON_BLUE}==========================================${NC}"

echo -e "${WHITE}👥 Usuarios de sistema conectados (who):${NC}"
who | awk '{print "  • " $1 " desde " $5 " (" $3 " " $4 ")"}'

echo -e "\n${WHITE}🔒 Conexiones SSH activas (ss):${NC}"
if command -v ss &>/dev/null; then
    ss -tnp | grep ssh | awk '{print "  • Local: " $4 " <-> Remoto: " $5 " (" $6 ")"}'
else
    netstat -tnp 2>/dev/null | grep ssh | awk '{print "  • " $4 " <-> " $5}'
fi

echo -e "\n${NEON_BLUE}==========================================${NC}"
if [ "$1" != "--no-wait" ]; then
    read -p "Presiona Enter para regresar..."
fi
