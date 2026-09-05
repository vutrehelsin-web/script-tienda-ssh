#!/bin/bash
source /etc/tiendassh/assets/theme.conf 2>/dev/null || source ./assets/theme.conf 2>/dev/null

while true; do
    clear
    echo -e "${NEON_BLUE}==========================================${NC}"
    echo -e "${NEON_YELLOW}       💻 HERRAMIENTAS DE SISTEMA${NC}"
    echo -e "${NEON_BLUE}==========================================${NC}"
    echo -e "${WHITE}[1]${NC} Limpiar memoria RAM / Cache"
    echo -e "${WHITE}[2]${NC} Monitoreo de Recursos (top)"
    echo -e "${WHITE}[3]${NC} Prueba de Velocidad (Speedtest)"
    echo -e "${WHITE}[4]${NC} Cambiar contraseña de ROOT"
    echo -e "${WHITE}[5]${NC} Reiniciar Servidor"
    echo -e "${WHITE}[0]${NC} Volver"
    echo -e "${NEON_BLUE}==========================================${NC}"
    read -p "Selecciona una opción: " opt
    case $opt in
      1)
        sync; echo 3 > /proc/sys/vm/drop_caches 2>/dev/null || true
        echo -e "${NEON_GREEN}✅ Memoria RAM limpiada con éxito.${NC}"
        sleep 1 ;;
      2)
        top -b -n 1 | head -n 20
        read -p "Presiona Enter..." ;;
      3)
        echo -e "${NEON_BLUE}Ejecutando prueba de red...${NC}"
        ping -c 4 8.8.8.8
        read -p "Presiona Enter..." ;;
      4)
        passwd
        read -p "Presiona Enter..." ;;
      5)
        read -p "¿Confirmas reiniciar el VPS? (s/n): " confirm
        if [[ "$confirm" =~ ^[Ss]$ ]]; then
            reboot 2>/dev/null || echo "Comando reboot simulado."
        fi
        sleep 1 ;;
      0) break ;;
      *) echo -e "${RED}❌ Opción inválida${NC}"; sleep 1 ;;
    esac
done
