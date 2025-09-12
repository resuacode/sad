#!/bin/bash
# configure-proxy.sh - Configuración automática de proxy para laboratorio SAD
# Uso: ./configure-proxy.sh
# Solo necesario cuando se ejecuta en la red del centro educativo

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración del proxy (AJUSTAR SEGÚN TU CENTRO)
PROXY_HOST="proxy.centro.edu"
PROXY_PORT="8080"
PROXY_USER=""  # Dejar vacío si no requiere autenticación
PROXY_PASS=""
NO_PROXY="localhost,127.0.0.1,10.*,192.168.*,.centro.edu,.local"

# Banner
echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║           Configurador de Proxy - Laboratorio SAD        ║${NC}"
echo -e "${BLUE}║              Solo para red del centro educativo          ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo

# Verificar si estamos en un entorno que necesita proxy
check_proxy_needed() {
    echo -e "${YELLOW}Verificando si el proxy es necesario...${NC}"
    
    # Test de conectividad directa
    if curl -s --connect-timeout 5 http://httpbin.org/ip > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Conectividad directa a Internet disponible${NC}"
        echo -e "${YELLOW}¿Configurar proxy de todas formas? (s/N):${NC}"
        read -r force_proxy
        if [[ ! "$force_proxy" =~ ^[Ss]$ ]]; then
            echo -e "${BLUE}Proxy no configurado - conexión directa funcional${NC}"
            exit 0
        fi
    else
        echo -e "${YELLOW}⚠ No hay conectividad directa - proxy necesario${NC}"
    fi
}

# Detectar sistema operativo
detect_os() {
    if [ -f /etc/debian_version ]; then
        OS="debian"
        echo -e "${GREEN}Sistema detectado: Debian/Ubuntu${NC}"
    elif [ -f /etc/redhat-release ]; then
        OS="redhat"
        echo -e "${GREEN}Sistema detectado: RedHat/CentOS${NC}"
    elif [ -f /etc/kali_version ]; then
        OS="kali"
        echo -e "${GREEN}Sistema detectado: Kali Linux${NC}"
    else
        echo -e "${RED}Sistema no soportado por este script${NC}"
        exit 1
    fi
}

# Solicitar configuración del proxy
get_proxy_config() {
    echo -e "${YELLOW}Configuración del proxy del centro:${NC}"
    echo
    
    # Host del proxy
    echo -e "${BLUE}Host del proxy [${PROXY_HOST}]:${NC}"
    read -r input_host
    if [ -n "$input_host" ]; then
        PROXY_HOST="$input_host"
    fi
    
    # Puerto del proxy
    echo -e "${BLUE}Puerto del proxy [${PROXY_PORT}]:${NC}"
    read -r input_port
    if [ -n "$input_port" ]; then
        PROXY_PORT="$input_port"
    fi
    
    # Autenticación
    echo -e "${BLUE}¿Requiere autenticación? (s/N):${NC}"
    read -r needs_auth
    if [[ "$needs_auth" =~ ^[Ss]$ ]]; then
        echo -e "${BLUE}Usuario:${NC}"
        read -r PROXY_USER
        echo -e "${BLUE}Contraseña:${NC}"
        read -rs PROXY_PASS
        echo
    fi
    
    # Mostrar configuración
    echo -e "${GREEN}Configuración a aplicar:${NC}"
    echo -e "  Host: ${PROXY_HOST}"
    echo -e "  Puerto: ${PROXY_PORT}"
    if [ -n "$PROXY_USER" ]; then
        echo -e "  Usuario: ${PROXY_USER}"
        echo -e "  Contraseña: [oculta]"
    fi
    echo -e "  Excepciones: ${NO_PROXY}"
    echo
}

# Configurar proxy del sistema
configure_system_proxy() {
    echo -e "${GREEN}Configurando proxy del sistema...${NC}"
    
    if [ -n "$PROXY_USER" ]; then
        PROXY_URL="http://$PROXY_USER:$PROXY_PASS@$PROXY_HOST:$PROXY_PORT"
    else
        PROXY_URL="http://$PROXY_HOST:$PROXY_PORT"
    fi
    
    # Backup del archivo original
    if [ -f /etc/environment ]; then
        sudo cp /etc/environment /etc/environment.backup.$(date +%Y%m%d_%H%M%S)
        echo -e "${BLUE}  ✓ Backup creado: /etc/environment.backup.$(date +%Y%m%d_%H%M%S)${NC}"
    fi
    
    # Remover configuración anterior de proxy
    sudo sed -i '/# Proxy del centro educativo/,+10d' /etc/environment
    
    # Configurar variables de entorno
    sudo tee -a /etc/environment > /dev/null <<EOF

# Proxy del centro educativo (configurado automáticamente - $(date))
export http_proxy="$PROXY_URL"
export https_proxy="$PROXY_URL"
export ftp_proxy="$PROXY_URL"
export no_proxy="$NO_PROXY"
export HTTP_PROXY="$PROXY_URL"
export HTTPS_PROXY="$PROXY_URL"
export FTP_PROXY="$PROXY_URL"
export NO_PROXY="$NO_PROXY"
EOF
    
    echo -e "${GREEN}  ✓ Variables de entorno configuradas${NC}"
}

# Configurar APT (Debian/Ubuntu)
configure_apt_proxy() {
    if [ "$OS" = "debian" ] || [ "$OS" = "kali" ]; then
        echo -e "${GREEN}Configurando proxy para APT...${NC}"
        
        sudo mkdir -p /etc/apt/apt.conf.d
        
        # Configurar proxy para APT
        sudo tee /etc/apt/apt.conf.d/95proxies > /dev/null <<EOF
// Proxy del centro educativo (configurado automáticamente - $(date))
Acquire::http::Proxy "$PROXY_URL";
Acquire::https::Proxy "$PROXY_URL";
Acquire::ftp::Proxy "$PROXY_URL";
EOF
        
        echo -e "${GREEN}  ✓ APT configurado${NC}"
    fi
}

# Configurar herramientas específicas de Kali
configure_kali_tools() {
    if [ "$OS" = "kali" ] || command -v kali-tweaks &> /dev/null; then
        echo -e "${GREEN}Configurando herramientas específicas de Kali...${NC}"
        
        # Configurar curl
        echo "proxy = $PROXY_HOST:$PROXY_PORT" > ~/.curlrc
        if [ -n "$PROXY_USER" ]; then
            echo "proxy-user = $PROXY_USER:$PROXY_PASS" >> ~/.curlrc
        fi
        echo -e "${GREEN}  ✓ curl configurado${NC}"
        
        # Configurar wget
        cat > ~/.wgetrc <<EOF
# Proxy del centro educativo
http_proxy = $PROXY_URL
https_proxy = $PROXY_URL
ftp_proxy = $PROXY_URL
EOF
        echo -e "${GREEN}  ✓ wget configurado${NC}"
        
        # Configurar git
        git config --global http.proxy "$PROXY_URL"
        git config --global https.proxy "$PROXY_URL"
        echo -e "${GREEN}  ✓ git configurado${NC}"
    fi
}

# Configurar navegadores
configure_browsers() {
    echo -e "${GREEN}Configurando navegadores...${NC}"
    
    # Firefox - Crear archivo de configuración de proxy
    FIREFOX_PROFILES_DIR="$HOME/.mozilla/firefox"
    if [ -d "$FIREFOX_PROFILES_DIR" ]; then
        for profile in "$FIREFOX_PROFILES_DIR"/*.default*; do
            if [ -d "$profile" ]; then
                cat > "$profile/user.js" <<EOF
// Configuración de proxy del centro educativo
user_pref("network.proxy.type", 1);
user_pref("network.proxy.http", "$PROXY_HOST");
user_pref("network.proxy.http_port", $PROXY_PORT);
user_pref("network.proxy.ssl", "$PROXY_HOST");
user_pref("network.proxy.ssl_port", $PROXY_PORT);
user_pref("network.proxy.no_proxies_on", "$NO_PROXY");
EOF
                echo -e "${GREEN}  ✓ Firefox configurado${NC}"
            fi
        done
    fi
}

# Verificar conectividad
test_connectivity() {
    echo -e "${GREEN}Verificando conectividad...${NC}"
    
    # Aplicar configuración actual
    source /etc/environment
    
    # Test con curl
    echo -e "${YELLOW}  Probando con curl...${NC}"
    if curl -s --connect-timeout 10 http://httpbin.org/ip > /dev/null; then
        echo -e "${GREEN}  ✓ curl: Conectividad OK${NC}"
    else
        echo -e "${RED}  ✗ curl: Error de conectividad${NC}"
    fi
    
    # Test con wget
    echo -e "${YELLOW}  Probando con wget...${NC}"
    if wget -q --timeout=10 --tries=1 -O /dev/null http://httpbin.org/ip; then
        echo -e "${GREEN}  ✓ wget: Conectividad OK${NC}"
    else
        echo -e "${RED}  ✗ wget: Error de conectividad${NC}"
    fi
    
    # Test de APT (solo en Debian/Ubuntu)
    if [ "$OS" = "debian" ] || [ "$OS" = "kali" ]; then
        echo -e "${YELLOW}  Probando APT...${NC}"
        if sudo apt update &> /dev/null; then
            echo -e "${GREEN}  ✓ APT: Actualización OK${NC}"
        else
            echo -e "${RED}  ✗ APT: Error de actualización${NC}"
        fi
    fi
}

# Crear script de desinstalación
create_uninstall_script() {
    cat > ~/remove-proxy.sh <<'EOF'
#!/bin/bash
# remove-proxy.sh - Eliminar configuración de proxy

echo "Eliminando configuración de proxy..."

# Restaurar /etc/environment
sudo sed -i '/# Proxy del centro educativo/,+10d' /etc/environment

# Eliminar configuración APT
sudo rm -f /etc/apt/apt.conf.d/95proxies

# Limpiar configuraciones de usuario
rm -f ~/.curlrc ~/.wgetrc
git config --global --unset http.proxy 2>/dev/null
git config --global --unset https.proxy 2>/dev/null

echo "Configuración de proxy eliminada"
echo "Reiniciar sesión para aplicar cambios"
EOF
    chmod +x ~/remove-proxy.sh
    echo -e "${BLUE}Script de desinstalación creado: ~/remove-proxy.sh${NC}"
}

# Función principal
main() {
    # Verificar permisos
    if [ "$EUID" -eq 0 ]; then
        echo -e "${RED}No ejecutar como root. Usar sudo cuando sea necesario.${NC}"
        exit 1
    fi
    
    # Verificar dependencias
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}curl no está instalado. Instalar con: sudo apt install curl${NC}"
        exit 1
    fi
    
    # Ejecutar pasos
    check_proxy_needed
    detect_os
    get_proxy_config
    
    # Confirmar configuración
    echo -e "${YELLOW}¿Proceder con la configuración? (s/N):${NC}"
    read -r confirm
    if [[ ! "$confirm" =~ ^[Ss]$ ]]; then
        echo "Cancelado por el usuario"
        exit 0
    fi
    
    echo
    echo -e "${BLUE}Iniciando configuración...${NC}"
    
    configure_system_proxy
    configure_apt_proxy
    configure_kali_tools
    configure_browsers
    create_uninstall_script
    
    echo
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                Configuración completada                  ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${YELLOW}Para aplicar los cambios:${NC}"
    echo -e "  1. Reiniciar sesión O ejecutar: ${BLUE}source /etc/environment${NC}"
    echo -e "  2. Para eliminar la configuración: ${BLUE}~/remove-proxy.sh${NC}"
    echo
    
    test_connectivity
}

# Ejecutar función principal
main "$@"
