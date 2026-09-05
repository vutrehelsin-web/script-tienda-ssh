🧩 agent.md — Guía de implementación para Jules
📘 Proyecto: TiendaSSH
Objetivo: Crear un script completo con autenticación propia (key única), interfaz tipo Rufus, y funciones equivalentes al panel original ADMRufu, incluyendo integración con el binario dtunel.

🧱 Estructura general del proyecto
TiendaSSH/
├── install_tiendassh.sh
├── bin/
│   ├── dtunel
│   ├── keycheck
│   └── menu
├── modules/
│   ├── users.sh
│   ├── protocols.sh
│   ├── bots.sh
│   ├── system.sh
│   └── updater.sh
├── assets/
│   ├── logo.txt
│   ├── banner.txt
│   └── theme.conf
└── README.md

🔐 Sistema de autenticación con key propia
1. Generación de key:
   KEY=$(echo "$(hostname)-$(date +%Y%m%d)" | md5sum | cut -d' ' -f1)
   echo "$KEY" > /etc/tiendassh/key.txt

2. Validación de key:
   El script bin/keycheck valida la key contra el servidor remoto https://api.tiendassh.net/validate

🖥️ Portada tipo Rufus
Visualización en ANSI con colores tipo neón.

⚙️ Funciones principales
- Administración de usuarios HWID / SSH
- Administrador de protocolos (SSH, Dropbear, Squid, OpenVPN, WireGuard, Stunnel, BadVPN, V2Ray/XRay, FileBrowser)
- Integración con binario dtunel (x86_64)
- Actualización automática vía updater.sh
