#!/bin/bash
source /etc/tiendassh/assets/theme.conf 2>/dev/null || source ./assets/theme.conf 2>/dev/null

clear
echo -e "${NEON_BLUE}==========================================${NC}"
echo -e "${NEON_GREEN}      👤 CREAR NUEVO USUARIO SSH/HWID${NC}"
echo -e "${NEON_BLUE}==========================================${NC}"

read -p "Ingresa nombre de usuario: " username
if [ -z "$username" ]; then
    echo -e "${RED}❌ El nombre de usuario no puede estar vacío.${NC}"
    read -p "Presiona Enter para continuar..."
    builtin exit 1
fi

if id "$username" &>/dev/null; then
    echo -e "${RED}❌ El usuario '$username' ya existe.${NC}"
    read -p "Presiona Enter para continuar..."
    builtin exit 1
fi

read -p "Ingresa contraseña: " password
if [ -z "$password" ]; then
    echo -e "${RED}❌ La contraseña no puede estar vacía.${NC}"
    read -p "Presiona Enter para continuar..."
    builtin exit 1
fi

read -p "Días de validez (ej. 30): " days
if ! [[ "$days" =~ ^[0-9]+$ ]]; then
    days=30
fi

read -p "Límite de conexiones simultáneas (ej. 1): " limit
if ! [[ "$limit" =~ ^[0-9]+$ ]]; then
    limit=1
fi

# Crear usuario en el sistema
exp_date=$(date -d "+$days days" +%Y-%m-%d)
useradd -M -s /bin/false -e "$exp_date" "$username" 2>/dev/null || useradd -M -s /bin/false "$username" 2>/dev/null
echo "$username:$password" | chpasswd

mkdir -p /etc/tiendassh/
echo "$username|$limit|$exp_date" >> /etc/tiendassh/users.db 2>/dev/null || true

echo -e "\n${NEON_GREEN}✅ Usuario creado con éxito:${NC}"
echo -e "${WHITE}• Usuario:${NC} $username"
echo -e "${WHITE}• Contraseña:${NC} $password"
echo -e "${WHITE}• Expiración:${NC} $exp_date ($days días)"
echo -e "${WHITE}• Límite conexiones:${NC} $limit"
echo -e "${NEON_BLUE}==========================================${NC}"
read -p "Presiona Enter para regresar..."
