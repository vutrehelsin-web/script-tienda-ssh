#!/bin/bash
source /etc/tiendassh/assets/theme.conf 2>/dev/null || source ./assets/theme.conf 2>/dev/null

while true; do
    clear
    echo -e "${NEON_BLUE}==========================================${NC}"
    echo -e "${NEON_PINK}        🤖 GESTIÓN DE BOTS TELEGRAM${NC}"
    echo -e "${NEON_BLUE}==========================================${NC}"
    echo -e "${WHITE}[1]${NC} Configurar Token y Chat ID"
    echo -e "${WHITE}[2]${NC} Iniciar Bot de Ventas / Notificaciones"
    echo -e "${WHITE}[3]${NC} Detener Bot"
    echo -e "${WHITE}[4]${NC} Estado del Bot"
    echo -e "${WHITE}[0]${NC} Volver"
    echo -e "${NEON_BLUE}==========================================${NC}"
    read -p "Selecciona una opción: " opt
    case $opt in
      1)
        read -p "Ingresa Telegram Bot Token: " token
        read -p "Ingresa Admin Chat ID: " chatid
        mkdir -p /etc/tiendassh
        echo "TOKEN=$token" > /etc/tiendassh/bot.conf
        echo "CHAT_ID=$chatid" >> /etc/tiendassh/bot.conf
        echo -e "${NEON_GREEN}✅ Configuración guardada.${NC}"
        read -p "Presiona Enter..." ;;
      2)
        if [ -f /etc/tiendassh/bot.conf ]; then
            echo -e "${NEON_GREEN}🤖 Bot iniciado.${NC}"
        else
            echo -e "${RED}❌ Debe configurar el token primero.${NC}"
        fi
        sleep 1 ;;
      3)
        echo -e "${RED}🛑 Bot detenido.${NC}"
        sleep 1 ;;
      4)
        if [ -f /etc/tiendassh/bot.conf ]; then
            echo -e "${NEON_GREEN}✅ Configuración de Bot activa.${NC}"
        else
            echo -e "${NEON_YELLOW}⚠️ Bot no configurado.${NC}"
        fi
        read -p "Presiona Enter..." ;;
      0) break ;;
      *) echo -e "${RED}❌ Opción inválida${NC}"; sleep 1 ;;
    esac
done
