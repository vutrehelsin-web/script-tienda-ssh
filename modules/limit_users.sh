#!/bin/bash
source /etc/tiendassh/assets/theme.conf 2>/dev/null || source ./assets/theme.conf 2>/dev/null

clear
echo -e "${NEON_BLUE}==========================================${NC}"
echo -e "${NEON_YELLOW}         ⚙️ LIMITAR CUENTAS${NC}"
echo -e "${NEON_BLUE}==========================================${NC}"

read -p "Usuario a configurar límite: " username
if ! id "$username" &>/dev/null; then
    echo -e "${RED}❌ Usuario no encontrado.${NC}"
    read -p "Presiona Enter para regresar..."
    builtin exit 1
fi

read -p "Nuevo límite de conexiones simultáneas: " limit
if ! [[ "$limit" =~ ^[0-9]+$ ]]; then
    limit=1
fi

echo "$username|$limit|$(date +%Y-%m-%d)" >> /etc/tiendassh/users.db 2>/dev/null || true
echo -e "${NEON_GREEN}✅ Límite de $limit conexiones asignado a '$username'.${NC}"
read -p "Presiona Enter para regresar..."
