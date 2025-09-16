# Storage Backup - Descarga OVA

## 📦 Debian 12 - Servidor de Almacenamiento y Backup

**Archivo:** `Debian-Storage-SAD.ova`  
**Tamaño:** ~2.8 GB  
**Sistema:** Debian 12 "Bookworm" Server  
**Configuración:** 1.5 GB RAM, 1 vCPU, 50 GB disco  

## 🔐 Credenciales Preconfiguradas

- **Usuario principal:** `backup`
- **Contraseña:** `Backup123!`
- **Usuario root:** `root`
- **Contraseña root:** `Backup123!`

## 🔗 [Enlace de Descarga](https://iesarmandocotarelovall-my.sharepoint.com/:u:/g/personal/dresua_iescotarelo_org/EbmRoBIpooBKm_ehhOxrg00BJ6csaEHQvJB4ZF9BdgEtDw?e=OmOWxG)


## ✅ Verificación de Integridad

**SHA256 Checksum:**
```
057863f808eb5da0cf0d50548558fec2c190f6f7054ec466736fca6dd637adca
```

**Verificar en Linux/macOS:**
```bash
sha256sum Debian-Storage-SAD.ova
```

**Verificar en Windows:**
```powershell
Get-FileHash -Path "Debian-Storage-SAD.ova" -Algorithm SHA256
```

## 📋 Software Preinstalado

### Servicios de Almacenamiento
- **Samba** - Compartición de archivos Windows/Linux
- **NFS** - Sistema de archivos en red
- **FTP** - Servidor de transferencia de archivos
- **SFTP** - Transferencia segura de archivos

### Herramientas de Backup
- **rsync** - Sincronización y backup incremental
- **tar** - Archivado y compresión
- **gzip/bzip2** - Compresión de archivos
- **cron** - Programación de tareas automatizadas

### Monitorización
- **htop** - Monitor de sistema
- **iotop** - Monitor de E/S de disco
- **df/du** - Uso de espacio en disco
- **lsof** - Archivos abiertos por procesos

### Seguridad
- **SSH** - Acceso remoto seguro
- **UFW** - Firewall simplificado
- **logrotate** - Rotación de logs
- **aide** - Detección de intrusiones

## 🔧 Configuración Post-Importación

1. **Verificar red:** Debe estar en `vboxnet-sad` (192.168.56.0/24)
2. **Confirmar IP:** 192.168.56.20
3. **Probar SSH:** `ssh backup@192.168.56.20`
4. **Verificar servicios:** Samba, NFS y SSH deben estar activos
5. **Comprobar espacios:** Verificar particiones y espacio disponible

## 💾 Estructura de Almacenamiento

### Directorios Principales
```
/storage/
├── backups/          # Copias de seguridad automáticas
├── shared/           # Archivos compartidos via Samba/NFS
├── ftp/             # Directorio FTP público
├── users/           # Directorios de usuario
└── logs/            # Logs de sistema y servicios
```

### Configuración de Samba
- **Share principal:** `//192.168.56.20/shared`
- **Credenciales:** `backup / Backup123!`
- **Permisos:** Lectura/escritura para usuarios autorizados

### Configuración de NFS
- **Export:** `/storage/shared 192.168.56.0/24(rw,sync,no_subtree_check)`
- **Mount desde cliente:** `mount -t nfs 192.168.56.20:/storage/shared /mnt/nfs`

## 🔄 Tareas de Backup Automatizadas

### Scripts Preconfigurados
- **daily-backup.sh** - Backup diario de configuraciones
- **weekly-full.sh** - Backup completo semanal
- **sync-servers.sh** - Sincronización entre servidores
- **cleanup-old.sh** - Limpieza de backups antiguos

### Programación Cron
```bash
# Backup diario a las 02:00
0 2 * * * /usr/local/bin/daily-backup.sh

# Backup completo los domingos a las 01:00  
0 1 * * 0 /usr/local/bin/weekly-full.sh

# Limpieza mensual el día 1 a las 03:00
0 3 1 * * /usr/local/bin/cleanup-old.sh
```

## 🎯 Casos de Uso en el Laboratorio

### Módulo 3: Seguridad en Sistemas
- Implementación de políticas de backup
- Configuración de accesos compartidos
- Auditoría de sistemas de archivos
- Monitorización de accesos

### Módulo 4: Seguridad en Redes
- Configuración segura de servicios de red
- Implementación de protocolos seguros
- Análisis de tráfico de red
- Segmentación de almacenamiento

### Módulo 6: Análisis Forense
- Preservación de evidencias
- Creación de imágenes forenses
- Backup de logs y evidencias
- Cadena de custodia digital

## 📊 Monitorización y Alertas

### Métricas Disponibles
- **Espacio en disco:** Alertas cuando uso > 85%
- **Procesos de backup:** Estado y logs de ejecución
- **Conexiones activas:** Usuarios conectados a shares
- **Transferencias:** Velocidad y volumen de datos

### Logs Importantes
- **Samba:** `/var/log/samba/`
- **SSH:** `/var/log/auth.log`
- **Backups:** `/var/log/backup.log`
- **Sistema:** `/var/log/syslog`

## 📞 Soporte

- 📚 **Documentación:** [Troubleshooting](../../documentacion/troubleshooting.md)

---

**⚠️ Nota:** Esta OVA está configurada únicamente para fines educativos. No usar en entornos de producción.
