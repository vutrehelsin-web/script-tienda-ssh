# 📘 TiendaSSH - Panel de Administración SSH / VPN

TiendaSSH es un script de administración completo con sistema de autenticación por Key única (basada en HWID y fecha), interfaz interactiva con tema tipo Rufus Neon, e integración completa con el binario `dtunel` y múltiples protocolos.

---

## 🧱 Estructura General del Proyecto

```text
TiendaSSH/
├── install_tiendassh.sh
├── bin/
│   ├── dtunel
│   ├── keycheck
│   └── menu
├── modules/
│   ├── users.sh
│   ├── create_user.sh
│   ├── remove_user.sh
│   ├── renew_user.sh
│   ├── block_user.sh
│   ├── user_details.sh
│   ├── monitor_users.sh
│   ├── limit_users.sh
│   ├── delete_expired.sh
│   ├── delete_all_users.sh
│   ├── protocols.sh
│   ├── bots.sh
│   ├── system.sh
│   └── updater.sh
├── src/
│   └── dttunel.c
├── assets/
│   ├── logo.txt
│   ├── banner.txt
│   └── theme.conf
└── README.md
```

---

## 🔐 Sistema de Autenticación con Key Propia

### 1. Generación de Key
Cada instalación genera automáticamente una Key única combinando el hostname del servidor y la fecha actual:

```bash
KEY=$(echo "$(hostname)-$(date +%Y%m%d)" | md5sum | cut -d' ' -f1)
echo "$KEY" > /etc/tiendassh/key.txt
```

### 2. Validación de Key
El script `bin/keycheck` valida la key guardada en `/etc/tiendassh/key.txt` consultando el servidor remoto `https://api.tiendassh.net/validate?key=...`.

---

## 🚀 Instalación y Uso

### Instalación
Para instalar TiendaSSH en el VPS (compatible con Ubuntu 20.04 y 22.04):

```bash
chmod +x install_tiendassh.sh
./install_tiendassh.sh
```

### Iniciar el Panel
Una vez instalado, ejecuta el comando:

```bash
menu
```

---

## ⚙️ Funcionalidades Principales

- **👥 Administración de Usuarios (HWID/SSH):** Crear, remover, renovar, bloquear/desbloquear, monitorear conexiones en tiempo real, limitar cuentas simultáneas y purgar expirados.
- **🌐 Administrador de Protocolos:** Control de SSH, Dropbear, Squid, OpenVPN, WireGuard, Stunnel, BadVPN, V2Ray/XRay y FileBrowser.
- **🔒 Integración DTunel:** Inicio y gestión del daemon de túnel seguro `dttunel` compilado en C para x86_64.
- **🤖 Bots de Telegram:** Configuración de token y administración.
- **💻 Herramientas de Sistema:** Limpieza de RAM/cache, monitor top, speedtest y reinicio.
- **🔄 Actualización Automática:** Sincronización continua desde el repositorio oficial.
