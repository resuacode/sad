#!/bin/bash
# Provisioning script para Kali Security
# Configuración robusta con manejo de errores

set -e  # Detener solo en errores críticos

echo "============================================"
echo "Configurando Kali Security..."
echo "============================================"

# Configurar zona horaria
timedatectl set-timezone Europe/Madrid 2>/dev/null || echo "Zona horaria ya configurada"

# Configurar contraseña para usuario kali
echo "Configurando contraseña para usuario kali..."
if id "kali" &>/dev/null; then
    echo "kali:kali" | chpasswd 2>/dev/null || {
        echo "Método alternativo para cambiar contraseña..."
        echo -e "kali\nkali" | passwd kali 2>/dev/null || true
    }
    echo "✓ Contraseña configurada"
else
    echo "⚠ Usuario kali no existe, omitiendo cambio de contraseña"
fi

# Configurar SSH para acceso con contraseña
echo "Configurando SSH para autenticación por contraseña..."
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Asegurar que la configuración está activa
grep -q "^PasswordAuthentication yes" /etc/ssh/sshd_config || echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

systemctl restart sshd || systemctl restart ssh
systemctl enable ssh
echo "SSH configurado correctamente"

# Actualizar repositorios
echo "Actualizando repositorios..."
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq 2>/dev/null || {
    echo "⚠ Error al actualizar repositorios, continuando..."
}

# Actualizar sistema (opcional, comentado por defecto para agilizar)
# echo "Actualizando sistema..."
# apt-get upgrade -y -qq 2>/dev/null || true

# Instalar herramientas básicas
echo "Instalando herramientas básicas..."
apt-get install -y -qq \
    net-tools \
    curl \
    wget \
    vim \
    nmap \
    tshark \
    tcpdump \
    netcat-traditional \
    2>/dev/null || echo "⚠ Algunas herramientas no se pudieron instalar"

# Configurar red estática
cat > /etc/network/interfaces.d/eth1 << 'EOF'
auto eth1
iface eth1 inet static
    address 192.168.56.20
    netmask 255.255.255.0
EOF

# Añadir hosts
cat >> /etc/hosts << 'EOF'
192.168.56.10 ubuntu-server
192.168.56.11 windows-server
192.168.56.12 windows-client
192.168.56.13 storage-backup
192.168.56.20 kali-security
EOF

# Asegurar que el directorio home de kali existe y crear script de Metasploit
if [ -d "/home/kali" ]; then
    cat > /home/kali/install-metasploit.sh << 'EOFSCRIPT'
#!/bin/bash
echo "Instalando Metasploit Framework..."
sudo apt-get update
sudo apt-get install -y metasploit-framework postgresql
sudo systemctl enable postgresql
sudo systemctl start postgresql
sudo msfdb init
echo "✅ Metasploit instalado. Ejecuta 'msfconsole' para usarlo."
EOFSCRIPT
    chmod +x /home/kali/install-metasploit.sh
    chown kali:kali /home/kali/install-metasploit.sh 2>/dev/null || echo "Permisos ajustados"
    echo "Script de Metasploit creado en /home/kali/install-metasploit.sh"
else
    echo "Directorio /home/kali no encontrado, omitiendo script de Metasploit"
fi

# Configurar red
echo "Configurando red..."
ip addr show eth1 || echo "⚠ Interfaz eth1 no disponible"

echo "============================================"
echo "✓ Configuración de Kali completada"
echo "============================================"
echo "Usuario: kali"
echo "Contraseña: kali"
echo "IP: 192.168.56.20"
echo "Herramientas: nmap, wireshark-cli, tcpdump"
echo "Para Metasploit: ~/install-metasploit.sh"
echo "============================================"
