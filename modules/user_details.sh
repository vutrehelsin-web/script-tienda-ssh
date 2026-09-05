#!/bin/bash
source /etc/tiendassh/assets/theme.conf 2>/dev/null || source ./assets/theme.conf 2>/dev/null

clear
echo -e "${NEON_BLUE}==========================================${NC}"
echo -e "${NEON_GREEN}       📋 DETALLES DE USUARIOS${NC}"
echo -e "${NEON_BLUE}==========================================${NC}"

printf "%-18s %-15s %-12s\n" "USUARIO" "EXPIRACIÓN" "ESTADO"
echo "------------------------------------------"

while IFS=: read -u 3 -r username password uid gid geocos home shell; do
    if [ "$uid" -ge 1000 ] && [ "$username" != "nobody" ]; then
        exp_raw=$(chage -l "$username" 2>/dev/null | grep "Account expires" | cut -d: -f2)
        if [[ "$exp_raw" == *"never"* ]]; then
            exp_date="Nunca"
        else
            exp_date=$(date -d "$exp_raw" +%Y-%m-%d 2>/dev/null || echo "$exp_raw")
        fi
        
        status_code=$(passwd -S "$username" 2>/dev/null | awk '{print $2}')
        if [ "$status_code" == "L" ]; then
            status="${RED}Bloqueado${NC}"
        else
            status="${NEON_GREEN}Activo${NC}"
        fi
        printf "%-18s %-15s %-12b\n" "$username" "$exp_date" "$status"
    fi
done 3< /etc/passwd

echo -e "${NEON_BLUE}==========================================${NC}"
read -p "Presiona Enter para regresar..."
