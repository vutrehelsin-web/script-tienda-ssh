#!/bin/bash
source /etc/tiendassh/assets/theme.conf 2>/dev/null || source ./assets/theme.conf 2>/dev/null

clear
echo -e "${NEON_BLUE}==========================================${NC}"
echo -e "${RED}        ⚠️ ELIMINAR TODOS LOS USUARIOS${NC}"
echo -e "${NEON_BLUE}==========================================${NC}"

read -p "¿ESTÁS SEGURO? Se eliminarán TODOS los usuarios clientes (s/n): " confirm
if [[ "$confirm" =~ ^[Ss]$ ]]; then
    count=0
    while IFS=: read -u 3 -r username password uid gid geocos home shell; do
        if [ "$uid" -ge 1000 ] && [ "$username" != "nobody" ] && [ "$username" != "ubuntu" ]; then
            userdel -f "$username" 2>/dev/null
            count=$((count+1))
        fi
    done 3< /etc/passwd
    echo -e "${NEON_GREEN}✅ Se eliminaron $count usuarios.${NC}"
else
    echo -e "${NEON_YELLOW}Operación cancelada.${NC}"
fi

read -p "Presiona Enter para regresar..."
