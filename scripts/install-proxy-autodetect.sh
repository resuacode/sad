#!/bin/bash
# install-proxy-autodetect.sh - Instalar detección automática de proxy en OVAs
# Este script debe ejecutarse ANTES de exportar las OVAs para pre-configurarlas

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║    Instalador de Detección Automática de Proxy - SAD     ║${NC}"
echo -e "${BLUE}║              Para integración en OVAs                    ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo

# Verificar privilegios
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Este script debe ejecutarse como root${NC}"
    echo "Uso: sudo $0"
    exit 1
fi

# Verificar sistema
if [ ! -f /etc/debian_version ] && [ ! -f /etc/redhat-release ]; then
    echo -e "${RED}Sistema no soportado${NC}"
    echo "Solo soporta Debian/Ubuntu y RedHat/CentOS"
    exit 1
fi

echo -e "${GREEN}Configurando detección automática de proxy...${NC}"

# 1. Crear directorios necesarios
echo -e "${YELLOW}Creando estructura de directorios...${NC}"
mkdir -p /usr/local/bin
mkdir -p /usr/local/share/doc/sad-proxy
mkdir -p /etc/systemd/system

# 2. Copiar script de detección
echo -e "${YELLOW}Instalando script de detección...${NC}"
if [ -f ./proxy-auto-detect.sh ]; then
    cp ./proxy-auto-detect.sh /usr/local/bin/
    chmod +x /usr/local/bin/proxy-auto-detect.sh
    echo -e "${GREEN}  ✓ Script instalado en /usr/local/bin/${NC}"
else
    echo -e "${RED}  ✗ Script proxy-auto-detect.sh no encontrado${NC}"
    exit 1
fi

# 3. Instalar servicio systemd
echo -e "${YELLOW}Configurando servicio systemd...${NC}"
if [ -f ./systemd/proxy-auto-detect.service ]; then
    cp ./systemd/proxy-auto-detect.service /etc/systemd/system/
    
    # Recargar systemd
    systemctl daemon-reload
    
    # Habilitar servicio
    systemctl enable proxy-auto-detect.service
    
    echo -e "${GREEN}  ✓ Servicio systemd configurado${NC}"
else
    echo -e "${RED}  ✗ Archivo de servicio no encontrado${NC}"
    exit 1
fi

# 4. Configurar variables por defecto (ajustar según centro)
echo -e "${YELLOW}Configurando variables por defecto...${NC}"
cat > /etc/default/sad-proxy <<EOF
# Configuración por defecto del proxy del centro educativo
# Editar según la configuración de tu centro

# Datos del proxy del centro
CENTRO_PROXY_HOST="proxy.centro.edu"
CENTRO_PROXY_PORT="8080"

# Red del centro (para detección automática)
CENTRO_GATEWAY="192.168.1.1"
CENTRO_DNS="10.0.0.1"
CENTRO_DOMAIN="centro.edu"

# Dominios sin proxy
NO_PROXY="localhost,127.0.0.1,10.*,192.168.*,.centro.edu,.local"

# Log
LOG_LEVEL="INFO"
LOG_FILE="/var/log/proxy-auto-detect.log"
EOF

echo -e "${GREEN}  ✓ Configuración por defecto creada${NC}"

# 5. Crear documentación
echo -e "${YELLOW}Instalando documentación...${NC}"
cat > /usr/local/share/doc/sad-proxy/README.md <<'EOF'
# Detección Automática de Proxy - Laboratorio SAD

## Descripción

Este sistema detecta automáticamente si la máquina virtual está ejecutándose
en la red del centro educativo y configura el proxy correspondiente.

## Funcionamiento

1. **Al inicio del sistema**: El servicio `proxy-auto-detect.service` se ejecuta
2. **Detección**: Verifica si está en la red del centro mediante:
   - Ping al proxy del centro
   - Verificación del gateway
   - Resolución de dominio del centro
3. **Configuración**: Si detecta red del centro, configura proxy automáticamente
4. **Log**: Registra todas las acciones en `/var/log/proxy-auto-detect.log`

## Configuración

Editar `/etc/default/sad-proxy` con los datos de tu centro:

```bash
CENTRO_PROXY_HOST="tu-proxy.centro.edu"
CENTRO_PROXY_PORT="8080"
CENTRO_GATEWAY="192.168.1.1"
```

## Comandos Útiles

```bash
# Ver estado del servicio
systemctl status proxy-auto-detect

# Ver logs
journalctl -u proxy-auto-detect

# Ejecutar manualmente
sudo /usr/local/bin/proxy-auto-detect.sh

# Ver estado actual
sudo /usr/local/bin/proxy-auto-detect.sh status

# Forzar activación
sudo /usr/local/bin/proxy-auto-detect.sh force-enable

# Forzar desactivación
sudo /usr/local/bin/proxy-auto-detect.sh force-disable
```

## Archivos Importantes

- `/usr/local/bin/proxy-auto-detect.sh` - Script principal
- `/etc/systemd/system/proxy-auto-detect.service` - Servicio systemd
- `/etc/default/sad-proxy` - Configuración
- `/var/log/proxy-auto-detect.log` - Logs del sistema
EOF

echo -e "${GREEN}  ✓ Documentación instalada${NC}"

# 6. Crear log file con permisos correctos
touch /var/log/proxy-auto-detect.log
chmod 644 /var/log/proxy-auto-detect.log

# 7. Configurar logrotate
cat > /etc/logrotate.d/sad-proxy <<EOF
/var/log/proxy-auto-detect.log {
    weekly
    rotate 4
    compress
    delaycompress
    missingok
    notifempty
    create 644 root root
}
EOF

echo -e "${GREEN}  ✓ Configuración de logs completada${NC}"

# 8. Crear comando de usuario para estudiantes
cat > /usr/local/bin/sad-proxy <<'EOF'
#!/bin/bash
# sad-proxy - Comando simplificado para estudiantes

case "${1:-status}" in
    "status")
        echo "=== Estado del Proxy del Centro ==="
        if systemctl is-active --quiet proxy-auto-detect; then
            echo "✓ Servicio activo"
        else
            echo "✗ Servicio inactivo"
        fi
        
        if env | grep -q http_proxy; then
            echo "✓ Proxy configurado: $(env | grep http_proxy | cut -d= -f2)"
        else
            echo "✗ Proxy no configurado"
        fi
        
        echo
        echo "Para más información: sudo /usr/local/bin/proxy-auto-detect.sh status"
        ;;
    "help"|"--help"|"-h")
        echo "Uso: sad-proxy [comando]"
        echo
        echo "Comandos disponibles:"
        echo "  status    - Ver estado actual (por defecto)"
        echo "  help      - Mostrar esta ayuda"
        echo
        echo "Comandos avanzados (requieren sudo):"
        echo "  sudo /usr/local/bin/proxy-auto-detect.sh force-enable"
        echo "  sudo /usr/local/bin/proxy-auto-detect.sh force-disable"
        ;;
    *)
        echo "Comando no reconocido. Uso: sad-proxy help"
        exit 1
        ;;
esac
EOF

chmod +x /usr/local/bin/sad-proxy
echo -e "${GREEN}  ✓ Comando de usuario 'sad-proxy' creado${NC}"

# 9. Verificar instalación
echo
echo -e "${GREEN}Verificando instalación...${NC}"

# Verificar archivos
files=(
    "/usr/local/bin/proxy-auto-detect.sh"
    "/usr/local/bin/sad-proxy"
    "/etc/systemd/system/proxy-auto-detect.service"
    "/etc/default/sad-proxy"
    "/usr/local/share/doc/sad-proxy/README.md"
)

all_ok=true
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}  ✓ $file${NC}"
    else
        echo -e "${RED}  ✗ $file${NC}"
        all_ok=false
    fi
done

# Verificar servicio
if systemctl is-enabled --quiet proxy-auto-detect; then
    echo -e "${GREEN}  ✓ Servicio habilitado${NC}"
else
    echo -e "${RED}  ✗ Servicio no habilitado${NC}"
    all_ok=false
fi

echo
if [ "$all_ok" = true ]; then
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              Instalación completada con éxito            ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${YELLOW}Notas importantes:${NC}"
    echo -e "  1. Editar ${BLUE}/etc/default/sad-proxy${NC} con los datos de tu centro"
    echo -e "  2. El servicio se activará automáticamente en el próximo reinicio"
    echo -e "  3. Los estudiantes pueden usar: ${BLUE}sad-proxy status${NC}"
    echo -e "  4. Para probar: ${BLUE}sudo /usr/local/bin/proxy-auto-detect.sh${NC}"
    echo
    echo -e "${YELLOW}Antes de exportar la OVA:${NC}"
    echo -e "  - Verificar configuración en /etc/default/sad-proxy"
    echo -e "  - Probar funcionamiento del servicio"
    echo -e "  - Documentar configuración específica del centro"
else
    echo -e "${RED}✗ Instalación completada con errores${NC}"
    echo -e "${YELLOW}Revisar los archivos marcados con ✗${NC}"
    exit 1
fi
