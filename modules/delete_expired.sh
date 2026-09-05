#!/bin/bash
source /etc/tiendassh/assets/theme.conf 2>/dev/null || source ./assets/theme.conf 2>/dev/null

clear
echo -e "${NEON_BLUE}==========================================${NC}"
echo -e "${RED}        🧹 ELIMINAR VENCIDOS${NC}"
echo -e "${NEON_BLUE}==========================================${NC}"

today=$(date +%s)
count=0

while IFS=: read -u 3 -r username password uid gid geocos home shell; do
    if [ "$uid" -ge 1000 ] && [ "$username" != "nobody" ]; then
        exp_raw=$(chage -l "$username" 2>/dev/null | grep "Account expires" | cut -d: -f2)
        if [[ "$exp_raw" != *"never"* ]] && [ -n "$exp_raw" ]; then
            exp_sec=$(date -d "$exp_raw" +%s 2>/dev/null || echo 0)
            if [ "$exp_sec" -gt 0 ] && [ "$exp_sec" -lt "$today" ]; then
                userdel -f "$username" 2>/dev/null
                echo -e "${RED}Eliminado usuario vencido:${NC} $username"
                count=$((count+1))
            fi
        fi
    fi
done 3< /etc/passwd

echo -e "\n${NEON_GREEN}✅ Se eliminaron $count usuarios vencidos.${NC}"
read -p "Presiona Enter para regresar..."
