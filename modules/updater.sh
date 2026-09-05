#!/bin/bash
source /etc/tiendassh/assets/theme.conf 2>/dev/null || source ./assets/theme.conf 2>/dev/null

clear
echo -e "${NEON_BLUE}==========================================${NC}"
echo -e "${NEON_GREEN}      🔄 ACTUALIZADOR TIENDASSH${NC}"
echo -e "${NEON_BLUE}==========================================${NC}"

REPO="https://github.com/Tiendassh/tiendassh"
echo -e "${WHITE}Descargando e instalando última versión...${NC}"

if command -v curl &>/dev/null; then
    curl -sSL "$REPO/raw/main/install_tiendassh.sh" -o /tmp/update.sh 2>/dev/null || true
elif command -v wget &>/dev/null; then
    wget -O /tmp/update.sh "$REPO/raw/main/install_tiendassh.sh" 2>/dev/null || true
fi

if [ -s /tmp/update.sh ]; then
    chmod +x /tmp/update.sh
    bash /tmp/update.sh
else
    echo -e "${NEON_YELLOW}⚠️ No se pudo descargar actualización desde el repositorio remoto.${NC}"
    echo -e "${NEON_GREEN}Sistemas locales al día.${NC}"
fi

read -p "Presiona Enter para regresar..."
