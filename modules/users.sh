#!/bin/bash
source /etc/tiendassh/assets/theme.conf 2>/dev/null || source ./assets/theme.conf 2>/dev/null

BASE_DIR="/etc/tiendassh/modules"
if [ ! -d "$BASE_DIR" ]; then
    BASE_DIR="./modules"
fi

while true; do
    clear
    echo -e "${NEON_BLUE}==========================================${NC}"
    echo -e "${NEON_GREEN}     👥 ADMINISTRACIÓN DE USUARIOS HWID${NC}"
    echo -e "${NEON_BLUE}==========================================${NC}"
    echo -e "${WHITE}[1]${NC} Nuevo usuario"
    echo -e "${WHITE}[2]${NC} Remover usuario"
    echo -e "${WHITE}[3]${NC} Renovar usuario"
    echo -e "${WHITE}[4]${NC} Bloquear/Desbloquear usuario"
    echo -e "${WHITE}[5]${NC} Detalles de usuarios"
    echo -e "${WHITE}[6]${NC} Monitor de conexiones"
    echo -e "${WHITE}[7]${NC} Limitar cuentas"
    echo -e "${WHITE}[8]${NC} Eliminar vencidos"
    echo -e "${WHITE}[9]${NC} Eliminar todos"
    echo -e "${WHITE}[0]${NC} Volver"
    echo -e "${NEON_BLUE}==========================================${NC}"
    read -p "Selecciona una opción: " opt
    case $opt in
      1) bash "$BASE_DIR/create_user.sh" ;;
      2) bash "$BASE_DIR/remove_user.sh" ;;
      3) bash "$BASE_DIR/renew_user.sh" ;;
      4) bash "$BASE_DIR/block_user.sh" ;;
      5) bash "$BASE_DIR/user_details.sh" ;;
      6) bash "$BASE_DIR/monitor_users.sh" ;;
      7) bash "$BASE_DIR/limit_users.sh" ;;
      8) bash "$BASE_DIR/delete_expired.sh" ;;
      9) bash "$BASE_DIR/delete_all_users.sh" ;;
      0) break ;;
      *) echo -e "${RED}❌ Opción inválida${NC}"; sleep 1 ;;
    esac
done
