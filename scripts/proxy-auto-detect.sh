#!/bin/bash
# proxy-auto-detect.sh - Detección automática de red del centro y configuración de proxy
# Este script puede ser ejecutado automáticamente al inicio del sistema

# Configuración (AJUSTAR SEGÚN TU CENTRO)
CENTRO_PROXY_HOST="proxy.centro.edu"
CENTRO_PROXY_PORT="8080"
CENTRO_GATEWAY="192.168.1.1"  # Gateway típico del centro
CENTRO_DNS="10.0.0.1"         # DNS del centro
CENTRO_DOMAIN="centro.edu"     # Dominio del centro

LOG_FILE="/var/log/proxy-auto-detect.log"

# Función de logging
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Detectar si estamos en la red del centro
detect_centro_network() {
    log_message "Detectando red del centro educativo..."
    
    # Test 1: Ping al proxy del centro
    if ping -c 1 -W 2 "$CENTRO_PROXY_HOST" &>/dev/null; then
        log_message "✓ Proxy del centro accesible: $CENTRO_PROXY_HOST"
        return 0
    fi
    
    # Test 2: Verificar gateway
    CURRENT_GATEWAY=$(ip route | grep default | awk '{print $3}' | head -n1)
    if [ "$CURRENT_GATEWAY" = "$CENTRO_GATEWAY" ]; then
        log_message "✓ Gateway del centro detectado: $CENTRO_GATEWAY"
        return 0
    fi
    
    # Test 3: Verificar DNS del centro
    CURRENT_DNS=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}' | head -n1)
    if [ "$CURRENT_DNS" = "$CENTRO_DNS" ]; then
        log_message "✓ DNS del centro detectado: $CENTRO_DNS"
        return 0
    fi
    
    # Test 4: Verificar dominio
    if nslookup "$CENTRO_DOMAIN" &>/dev/null; then
        log_message "✓ Dominio del centro resuelto: $CENTRO_DOMAIN"
        return 0
    fi
    
    # Test 5: Verificar conectividad directa
    if curl -s --connect-timeout 5 http://httpbin.org/ip &>/dev/null; then
        log_message "✓ Conectividad directa disponible - Red externa"
        return 1
    else
        log_message "⚠ Sin conectividad directa - Posible red del centro"
        return 0
    fi
}

# Activar configuración de proxy
activate_proxy() {
    log_message "Activando configuración de proxy del centro..."
    
    # Verificar si ya está configurado
    if grep -q "proxy.centro.edu" /etc/environment 2>/dev/null; then
        log_message "✓ Proxy ya configurado en /etc/environment"
        source /etc/environment
        return 0
    fi
    
    # Configurar proxy
    PROXY_URL="http://$CENTRO_PROXY_HOST:$CENTRO_PROXY_PORT"
    NO_PROXY="localhost,127.0.0.1,10.*,192.168.*,.centro.edu,.local"
    
    # Backup
    if [ -f /etc/environment ]; then
        cp /etc/environment /etc/environment.backup.autodetect
    fi
    
    # Configurar variables de entorno
    cat >> /etc/environment <<EOF

# Proxy del centro (configurado automáticamente - $(date))
export http_proxy="$PROXY_URL"
export https_proxy="$PROXY_URL"
export ftp_proxy="$PROXY_URL"
export no_proxy="$NO_PROXY"
export HTTP_PROXY="$PROXY_URL"
export HTTPS_PROXY="$PROXY_URL"
export FTP_PROXY="$PROXY_URL"
export NO_PROXY="$NO_PROXY"
EOF

    # Configurar APT
    mkdir -p /etc/apt/apt.conf.d
    cat > /etc/apt/apt.conf.d/95proxies <<EOF
Acquire::http::Proxy "$PROXY_URL";
Acquire::https::Proxy "$PROXY_URL";
EOF

    log_message "✓ Proxy configurado automáticamente"
    
    # Aplicar configuración
    source /etc/environment
    
    # Verificar conectividad
    if curl -s --connect-timeout 10 http://httpbin.org/ip &>/dev/null; then
        log_message "✓ Conectividad verificada con proxy"
        return 0
    else
        log_message "✗ Error de conectividad con proxy"
        return 1
    fi
}

# Desactivar configuración de proxy
deactivate_proxy() {
    log_message "Desactivando configuración de proxy..."
    
    # Remover de /etc/environment
    sed -i '/# Proxy del centro/,+10d' /etc/environment
    
    # Remover configuración APT
    rm -f /etc/apt/apt.conf.d/95proxies
    
    log_message "✓ Configuración de proxy desactivada"
}

# Crear indicador visual para el usuario
create_user_notification() {
    local message="$1"
    local type="$2"  # info, warning, error
    
    # Crear notificación para usuarios conectados
    for user in $(who | awk '{print $1}' | sort -u); do
        user_home=$(eval echo ~$user)
        if [ -d "$user_home" ]; then
            cat > "$user_home/.proxy-status" <<EOF
PROXY_STATUS="$type"
PROXY_MESSAGE="$message"
PROXY_TIMESTAMP="$(date)"
EOF
            chown $user:$user "$user_home/.proxy-status" 2>/dev/null || true
        fi
    done
    
    # Log del mensaje
    log_message "Notificación: $message"
}

# Función principal
main() {
    log_message "=== Iniciando detección automática de proxy ==="
    
    # Verificar privilegios
    if [ "$EUID" -ne 0 ]; then
        log_message "ERROR: Este script debe ejecutarse como root"
        exit 1
    fi
    
    # Esperar a que la red esté lista
    sleep 5
    
    # Detectar red del centro
    if detect_centro_network; then
        log_message "Red del centro detectada - Configurando proxy"
        
        if activate_proxy; then
            create_user_notification "Proxy del centro configurado automáticamente" "info"
        else
            create_user_notification "Error al configurar proxy del centro" "error"
        fi
    else
        log_message "Red externa detectada - Proxy no necesario"
        
        # Verificar si hay configuración de proxy activa y removerla
        if grep -q "proxy.centro.edu" /etc/environment 2>/dev/null; then
            deactivate_proxy
            create_user_notification "Configuración de proxy desactivada (red externa)" "info"
        fi
    fi
    
    log_message "=== Detección automática completada ==="
}

# Mostrar estado del proxy (para debugging)
show_status() {
    echo "=== Estado del Proxy ==="
    echo "Fecha: $(date)"
    echo
    
    echo "Variables de entorno:"
    env | grep -i proxy || echo "No configurado"
    echo
    
    echo "Configuración APT:"
    if [ -f /etc/apt/apt.conf.d/95proxies ]; then
        cat /etc/apt/apt.conf.d/95proxies
    else
        echo "No configurado"
    fi
    echo
    
    echo "Conectividad:"
    if curl -s --connect-timeout 5 http://httpbin.org/ip; then
        echo "✓ OK"
    else
        echo "✗ Error"
    fi
    echo
    
    echo "Log reciente:"
    tail -n 10 "$LOG_FILE" 2>/dev/null || echo "No hay logs"
}

# Manejar argumentos
case "${1:-}" in
    "status")
        show_status
        ;;
    "force-enable")
        log_message "Forzando activación de proxy"
        activate_proxy
        ;;
    "force-disable")
        log_message "Forzando desactivación de proxy"
        deactivate_proxy
        ;;
    *)
        main
        ;;
esac
