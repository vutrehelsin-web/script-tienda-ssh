#!/bin/bash
# Install script for TiendaSSH

echo "🚀 Instalando TiendaSSH..."

# Update packages if apt is available
if command -v apt &>/dev/null; then
    apt update -y && apt upgrade -y
    apt install -y git curl wget unzip nano screen gcc make 2>/dev/null || true
fi

# Create system directories
mkdir -p /etc/tiendassh/modules /etc/tiendassh/assets /etc/tiendassh/bin /usr/local/bin /root/bin

# Generate unique key based on HWID/hostname and date if key doesn't exist
if [ ! -f /etc/tiendassh/key.txt ]; then
    KEY=$(echo "$(hostname)-$(date +%Y%m%d)" | md5sum | cut -d' ' -f1)
    echo "$KEY" > /etc/tiendassh/key.txt
    echo "🔑 Nueva Key generada: $KEY"
else
    echo "🔑 Key existente detectada: $(cat /etc/tiendassh/key.txt)"
fi

# Copy binary dtunel / dttunel
if [ -f bin/dttunel ]; then
    cp bin/dttunel /usr/bin/dttunel
    chmod +x /usr/bin/dttunel
elif [ -f src/dttunel.c ]; then
    gcc -O2 src/dttunel.c -o /usr/bin/dttunel 2>/dev/null || true
    chmod +x /usr/bin/dttunel 2>/dev/null || true
fi

if [ -f bin/dtunel ]; then
    cp bin/dtunel /etc/tiendassh/bin/dtunel
    cp bin/dtunel /usr/bin/dtunel
    chmod +x /etc/tiendassh/bin/dtunel /usr/bin/dtunel
fi

# Copy keycheck
if [ -f bin/keycheck ]; then
    cp bin/keycheck /etc/tiendassh/bin/keycheck
    cp bin/keycheck /usr/local/bin/keycheck
    chmod +x /etc/tiendassh/bin/keycheck /usr/local/bin/keycheck
fi

# Copy modules
if [ -d modules ]; then
    cp -r modules/* /etc/tiendassh/modules/
    chmod +x /etc/tiendassh/modules/*.sh
fi

# Copy assets
if [ -d assets ]; then
    cp -r assets/* /etc/tiendassh/assets/
fi

# Copy main menu script and create symlinks
if [ -f bin/menu ]; then
    cp bin/menu /etc/tiendassh/bin/menu
    cp bin/menu /usr/local/bin/menu
    cp bin/menu /usr/bin/menu
    chmod +x /etc/tiendassh/bin/menu /usr/local/bin/menu /usr/bin/menu
fi

# Validate key
if [ -f /etc/tiendassh/bin/keycheck ]; then
    bash /etc/tiendassh/bin/keycheck
fi

echo "====================================================="
echo "✅ Instalación de TiendaSSH completada con key propia."
echo "Escriba 'menu' para iniciar el panel de control."
echo "====================================================="
