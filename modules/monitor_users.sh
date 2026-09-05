#!/bin/bash
source /etc/tiendassh/assets/theme.conf 2>/dev/null || source ./assets/theme.conf 2>/dev/null

clear
echo -e "${NEON_BLUE}==========================================${NC}"
echo -e "${NEON_BLUE}       📊 MONITOR DE CONEXIONES${NC}"
echo -e "${NEON_BLUE}==========================================${NC}"

printf "%-18s %-10s %-20s\n" "USUARIO" "PIDs" "CONEXIONES ACTIVAS"
echo "------------------------------------------"

who | awk '{print $1}' | sort | uniq -c | while read count user; do
    printf "%-18s %-10s %-20s\n" "$user" "-" "$count conexiones SSH"
done

echo -e "${NEON_BLUE}==========================================${NC}"
read -p "Presiona Enter para regresar..."
