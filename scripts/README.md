# Scripts de Automatización - Laboratorio SAD

Este directorio contiene scripts de automatización y utilidades para el laboratorio virtual de Seguridad y Alta Disponibilidad.

## 📁 Estructura de Scripts

```
scripts/
├── README.md                        # Esta documentación
├── configure-proxy.sh               # Configuración manual de proxy
├── proxy-auto-detect.sh             # Detección automática de proxy
├── install-proxy-autodetect.sh      # Instalador para integración en OVAs
└── systemd/
    └── proxy-auto-detect.service    # Servicio systemd para detección automática
```

## 🏢 Scripts de Configuración de Proxy

### 📋 Información General

Estos scripts están diseñados para facilitar el uso del laboratorio SAD **dentro de la red del centro educativo** que requiere configuración de proxy para acceso a Internet.

> ⚠️ **Importante**: Solo son necesarios cuando las VMs se ejecutan en la red del centro. Para uso doméstico, no es necesario ejecutarlos.

### 🔧 Scripts Disponibles

#### 1. `configure-proxy.sh` - Configuración Manual Interactiva

**Propósito**: Configurar proxy manualmente en una VM ya en funcionamiento.

**Uso**:
```bash
# Ejecutar en la VM que necesita proxy
cd ~/sad-scripts
./configure-proxy.sh
```

**Características**:
- ✅ Configuración interactiva paso a paso
- ✅ Detección automática del sistema operativo
- ✅ Soporte para Debian/Ubuntu/Kali
- ✅ Configuración de APT, curl, wget, git
- ✅ Verificación de conectividad
- ✅ Script de desinstalación incluido

**Sistemas soportados**:
- Ubuntu Server 22.04 LTS
- Debian 12 (Storage VM)
- Kali Linux (Security VM)

---

#### 2. `proxy-auto-detect.sh` - Detección Automática

**Propósito**: Detectar automáticamente si la VM está en la red del centro y configurar proxy.

**Uso**:
```bash
# Ejecutar como root
sudo ./proxy-auto-detect.sh

# Ver estado actual
sudo ./proxy-auto-detect.sh status

# Forzar activación/desactivación
sudo ./proxy-auto-detect.sh force-enable
sudo ./proxy-auto-detect.sh force-disable
```

**Características**:
- ✅ Detección automática de red del centro
- ✅ Configuración transparente para el usuario
- ✅ Logging detallado
- ✅ Integración con systemd
- ✅ Notificaciones para usuarios

**Métodos de detección**:
1. Ping al proxy del centro
2. Verificación del gateway de red
3. Resolución del DNS del centro
4. Test de conectividad directa

---

#### 3. `install-proxy-autodetect.sh` - Instalador para OVAs

**Propósito**: Integrar la detección automática de proxy **antes** de exportar las OVAs.

**Uso**:
```bash
# Ejecutar en la VM ANTES de exportar como OVA
sudo ./install-proxy-autodetect.sh
```

**Características**:
- ✅ Instala servicio systemd para arranque automático
- ✅ Crea configuración por defecto personalizable
- ✅ Instala comando simplificado para estudiantes
- ✅ Configura logging y rotación de logs
- ✅ Documentación integrada

**Archivos instalados**:
- `/usr/local/bin/proxy-auto-detect.sh` - Script principal
- `/usr/local/bin/sad-proxy` - Comando para estudiantes
- `/etc/systemd/system/proxy-auto-detect.service` - Servicio
- `/etc/default/sad-proxy` - Configuración
- `/var/log/proxy-auto-detect.log` - Logs

---

## 🎯 Casos de Uso

### Para Profesores: Preparación de OVAs

1. **Crear VM base** (Ubuntu/Debian/Kali)
2. **Instalar software del laboratorio**
3. **Ejecutar integración**:
   ```bash
   cd /path/to/sad-scripts
   sudo ./install-proxy-autodetect.sh
   ```
4. **Personalizar configuración**:
   ```bash
   sudo nano /etc/default/sad-proxy
   # Ajustar CENTRO_PROXY_HOST, CENTRO_GATEWAY, etc.
   ```
5. **Probar funcionamiento**:
   ```bash
   sudo systemctl start proxy-auto-detect
   sudo /usr/local/bin/proxy-auto-detect.sh status
   ```
6. **Exportar OVA**

### Para Estudiantes: Uso en Centro Educativo

#### Opción A: OVAs Pre-configuradas (Recomendado)

Si las OVAs ya tienen integrada la detección automática:

```bash
# 1. Importar OVA normalmente
# 2. Iniciar VM
# 3. Verificar estado del proxy
sad-proxy status

# El proxy se configura automáticamente al detectar red del centro
```

#### Opción B: Configuración Manual

Si las OVAs no tienen la detección automática:

```bash
# 1. Copiar scripts a la VM
# 2. Ejecutar configuración manual
cd ~/sad-scripts
./configure-proxy.sh
```

### Para Estudiantes: Uso en Casa

**No es necesario hacer nada**. Los scripts detectan automáticamente que no están en la red del centro y no configuran proxy.

---

## 🔧 Configuración por Centro Educativo

### Configuración Típica A (Proxy Básico)
```bash
# /etc/default/sad-proxy
CENTRO_PROXY_HOST="proxy.centro.edu"
CENTRO_PROXY_PORT="8080"
CENTRO_GATEWAY="192.168.1.1"
CENTRO_DNS="192.168.1.1"
CENTRO_DOMAIN="centro.edu"
```

### Configuración Típica B (Con IP)
```bash
# /etc/default/sad-proxy
CENTRO_PROXY_HOST="10.0.0.1"
CENTRO_PROXY_PORT="3128"
CENTRO_GATEWAY="10.0.0.1"
CENTRO_DNS="10.0.0.1"
CENTRO_DOMAIN="centro.local"
```

### Configuración Típica C (Proxy con Autenticación)
```bash
# Requiere modificar scripts para incluir credenciales
# O configurar autenticación transparente en el proxy
```

---

## 📊 Comandos de Diagnóstico

### Para Estudiantes

```bash
# Estado general del proxy
sad-proxy status

# Verificar conectividad
curl http://httpbin.org/ip

# Ver configuración actual
env | grep -i proxy
```

### Para Profesores/Administradores

```bash
# Estado detallado del servicio
sudo systemctl status proxy-auto-detect

# Logs del sistema
sudo journalctl -u proxy-auto-detect

# Logs específicos
sudo tail -f /var/log/proxy-auto-detect.log

# Ejecutar detección manual
sudo /usr/local/bin/proxy-auto-detect.sh

# Estado completo
sudo /usr/local/bin/proxy-auto-detect.sh status
```

---

## 🔍 Solución de Problemas

### Problema: Script no detecta red del centro

**Causa**: Configuración incorrecta en `/etc/default/sad-proxy`

**Solución**:
```bash
sudo nano /etc/default/sad-proxy
# Verificar CENTRO_PROXY_HOST, CENTRO_GATEWAY, etc.
# Usar datos reales del centro
```

### Problema: Proxy configurado pero sin conectividad

**Causa**: Datos incorrectos del proxy o proxy del centro caído

**Solución**:
```bash
# Verificar proxy del centro
ping proxy.centro.edu

# Probar configuración manual
export http_proxy="http://proxy.centro.edu:8080"
curl http://httpbin.org/ip
```

### Problema: Servicio no arranca automáticamente

**Causa**: Servicio systemd no habilitado correctamente

**Solución**:
```bash
sudo systemctl enable proxy-auto-detect
sudo systemctl start proxy-auto-detect
sudo systemctl status proxy-auto-detect
```

---

## 📚 Documentación Adicional

- **[Configuración de Proxy - Documentación Principal](../docs/laboratorio-sad/configuracion-proxy/README.md)**
- **[Guía para Estudiantes](../docs/laboratorio-sad/configuracion-proxy/proxy-estudiantes.md)**
- **[Troubleshooting Detallado](../docs/laboratorio-sad/configuracion-proxy/troubleshooting-proxy.md)**

---

## 📝 Notas para Desarrolladores

### Extensión de Scripts

Para añadir soporte a otros sistemas operativos:

1. Modificar función `detect_os()` en `configure-proxy.sh`
2. Añadir funciones específicas de configuración
3. Actualizar documentación

### Personalización por Centro

Los scripts están diseñados para ser fácilmente personalizables:

- Variables de configuración centralizadas
- Configuración separada por archivos
- Logging detallado para debugging
- Comandos de diagnóstico integrados

### Testing

```bash
# Test en diferentes redes
# 1. Red del centro (debe configurar proxy)
# 2. Red doméstica (no debe configurar proxy)
# 3. Red con proxy diferente (debe detectar correctamente)
```

---

**Última actualización**: Diciembre 2024  
**Versión**: 1.0  
**Mantenedor**: [Nombre del profesor]
