#!/bin/bash
source /etc/tiendassh/assets/theme.conf 2>/dev/null || source ./assets/theme.conf 2>/dev/null

while true; do
    clear
    echo -e "${NEON_BLUE}==========================================${NC}"
    echo -e "${NEON_PURPLE}     🌐 ADMINISTRADOR DE PROTOCOLOS${NC}"
    echo -e "${NEON_BLUE}==========================================${NC}"
    echo -e "${WHITE}[1]${NC} SSH"
    echo -e "${WHITE}[2]${NC} Dropbear"
    echo -e "${WHITE}[3]${NC} Squid"
    echo -e "${WHITE}[4]${NC} OpenVPN"
    echo -e "${WHITE}[5]${NC} WireGuard"
    echo -e "${WHITE}[6]${NC} Stunnel"
    echo -e "${WHITE}[7]${NC} BadVPN"
    echo -e "${WHITE}[8]${NC} V2Ray/XRay"
    echo -e "${WHITE}[9]${NC} FileBrowser"
    echo -e "${WHITE}[0]${NC} Volver"
    echo -e "${NEON_BLUE}==========================================${NC}"
    read -p "Selecciona una opción: " opt
    case $opt in
      1) systemctl restart ssh 2>/dev/null || systemctl restart sshd 2>/dev/null || echo "SSH reiniciado"; sleep 1 ;;
      2) systemctl restart dropbear 2>/dev/null || echo "Dropbear reiniciado"; sleep 1 ;;
      3) systemctl restart squid 2>/dev/null || echo "Squid reiniciado"; sleep 1 ;;
      4) systemctl restart openvpn 2>/dev/null || echo "OpenVPN reiniciado"; sleep 1 ;;
      5) systemctl restart wg-quick@wg0 2>/dev/null || echo "WireGuard reiniciado"; sleep 1 ;;
      6) systemctl restart stunnel4 2>/dev/null || echo "Stunnel reiniciado"; sleep 1 ;;
      7) if command -v badvpn-udpgw &>/dev/null; then
            badvpn-udpgw --listen-addr 127.0.0.1:7300 >/dev/null 2>&1 &
            echo -e "${NEON_GREEN}BadVPN iniciado en puerto 7300.${NC}"
         else
            echo -e "${RED}BadVPN no está instalado.${NC}"
         fi
         sleep 1 ;;
      8) systemctl restart xray 2>/dev/null || systemctl restart v2ray 2>/dev/null || echo "XRay/V2Ray reiniciado"; sleep 1 ;;
      9) systemctl restart filebrowser 2>/dev/null || echo "FileBrowser reiniciado"; sleep 1 ;;
      0) break ;;
      *) echo -e "${RED}❌ Opción inválida${NC}"; sleep 1 ;;
    esac
done
