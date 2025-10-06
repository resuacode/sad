# Laboratorio SAD v2.0 - Guía Completa

## 📋 Descripción

Laboratorio virtualizado para el módulo de **Seguridad y Alta Disponibilidad**, con 5 máquinas virtuales configuradas para prácticas de seguridad, administración de sistemas y redes.

### 🎯 Características principales:
- ✅ Configuración simplificada y estable
- ✅ SSH funcional en todas las VMs Linux
- ✅ Red host-only para comunicación entre VMs
- ✅ Servicios básicos preconfigurados
- ✅ Credenciales claras y documentadas
- ✅ Export a OVA sin problemas

## 🖥️ Máquinas Virtuales

| VM | IP | OS | RAM | Servicios |
|---|---|---|---|---|
| **Ubuntu Server** | 192.168.56.10 | Ubuntu 22.04 | 1.5GB | Apache, MySQL, SSH |
| **Windows Server** | 192.168.56.11 | Win Server 2022 | 2GB | IIS, SMB, RDP |
| **Windows Client** | 192.168.56.12 | Windows 10 | 2GB | RDP |
| **Storage Backup** | 192.168.56.13 | Debian 12 | 1GB | Samba, NFS, SSH |
| **Kali Security** | 192.168.56.20 | Kali Rolling | 2GB | Herramientas pentesting |

**Total recursos**: ~8.5GB RAM, ~85GB disco

## 📦 Requisitos Previos

### Software necesario:
- **VirtualBox** 7.0 o superior
- **Vagrant** 2.3 o superior (para instalación con Vagrant)
- **8GB RAM** mínimo (16GB recomendado)
- **100GB espacio** en disco libre

### Verificar instalación:
```bash
VBoxManage --version
vagrant --version
```

## 🚀 Instalación

### Opción 1: Con Vagrant (Recomendado)

1. **Crear directorio de trabajo**:
```bash
mkdir ~/laboratorio-sad
cd ~/laboratorio-sad
```

2. **Copiar el Vagrantfile** (desde `guia-instalacion.mdx`)

3. **Crear carpeta de provisioning**:
```bash
mkdir -p provision
```

4. **Copiar scripts de provisioning** (desde `guia-instalacion.mdx`)

5. **Desplegar el laboratorio**:
```bash
# Todas las VMs
vagrant up

# Solo una VM específica
vagrant up ubuntu-server

# VMs necesarias para una práctica
vagrant up ubuntu-server kali-security
```

### Opción 2: Importar OVAs

1. **Descargar OVAs** desde los enlaces proporcionados
2. **Importar en VirtualBox**: Archivo → Importar servicio virtualizado
3. **Verificar configuración de red**: Debe ser `vboxnet-sad` (192.168.56.0/24)
4. **Iniciar máquinas** según necesidad

## 🔑 Credenciales de Acceso

Ver archivo [CREDENCIALES.md](CREDENCIALES.md) para detalles completos.

**Resumen rápido**:
- Ubuntu Server: `admin / adminSAD2024!`
- Windows Server: `labadmin / Password123!`
- Windows Client: `cliente / User123!`
- Storage Backup: `backup / backup123`
- Kali Security: `kali / kali`

## 🧪 Verificación del Laboratorio

### Test automático:
```bash
./test-conectividad.sh
```

### Test manual:
```bash
# Verificar estado de VMs
vagrant status

# Ping a las VMs
ping 192.168.56.10  # Ubuntu
ping 192.168.56.11  # Windows Server
ping 192.168.56.20  # Kali

# SSH a VMs Linux
ssh admin@192.168.56.10
ssh kali@192.168.56.20
ssh backup@192.168.56.13

# RDP a VMs Windows
xfreerdp /u:labadmin /p:Password123! /v:192.168.56.11
```

## 📚 Comandos Útiles

### Gestión con Vagrant:

```bash
# Ver estado
vagrant status

# Iniciar VM
vagrant up <nombre-vm>

# Detener VM
vagrant halt <nombre-vm>

# Suspender (más rápido)
vagrant suspend <nombre-vm>

# Reanudar
vagrant resume <nombre-vm>

# SSH a VM Linux
vagrant ssh <nombre-vm>

# Reiniciar VM
vagrant reload <nombre-vm>

# Destruir VM
vagrant destroy <nombre-vm>

# Reprovisionar
vagrant provision <nombre-vm>
```

### Snapshots (desde VirtualBox):

```bash
# Crear snapshot
VBoxManage snapshot "SAD-Ubuntu-Server" take "snapshot-inicial"

# Listar snapshots
VBoxManage snapshot "SAD-Ubuntu-Server" list

# Restaurar snapshot
VBoxManage snapshot "SAD-Ubuntu-Server" restore "snapshot-inicial"
```

## 🎓 Casos de Uso por Módulo

### Módulo 2-3: Criptografía y PKI
**VMs necesarias**: Ubuntu Server, Kali Security
```bash
vagrant up ubuntu-server kali-security
```

### Módulo 4: Seguridad en Redes
**VMs necesarias**: Ubuntu Server, Kali Security, Windows Server
```bash
vagrant up ubuntu-server kali-security windows-server
```

### Módulo 5: Alta Disponibilidad
**VMs necesarias**: Ubuntu Server, Storage Backup
```bash
vagrant up ubuntu-server storage-backup
```

### Módulo 6: Análisis Forense
**VMs necesarias**: Kali Security, Ubuntu Server, Storage Backup
```bash
vagrant up kali-security ubuntu-server storage-backup
```

## 🔧 Solución de Problemas

Ver [troubleshooting.md](troubleshooting.md) para problemas comunes.

### Problemas frecuentes:

**1. VM no arranca**:
```bash
vagrant halt <vm>
vagrant up <vm>
```

**2. Error de red**:
- Verificar que existe `vboxnet-sad` en VirtualBox
- Configuración: 192.168.56.0/24

**3. SSH no funciona**:
```bash
vagrant ssh <vm>  # Usar Vagrant inicialmente
```

**4. Poco espacio/RAM**:
- Levantar solo las VMs necesarias
- Usar `vagrant suspend` en lugar de `halt`

## 📖 Documentación Adicional

- **[CREDENCIALES.md](CREDENCIALES.md)** - Todas las credenciales
- **[guia-instalacion.mdx](guia-instalacion.mdx)** - Guía detallada con código
- **[configuracion-proxy.md](configuracion-proxy.md)** - Configurar proxy
- **[post-configuracion.md](post-configuracion.md)** - Pasos post-instalación
- **[troubleshooting.md](troubleshooting.md)** - Resolución de problemas

## 📞 Soporte

Para problemas o sugerencias:
1. Revisar [troubleshooting.md](troubleshooting.md)
2. Consultar documentación de VirtualBox/Vagrant
3. Recrear VM problemática: `vagrant destroy <vm> && vagrant up <vm>`

## ⚠️ Notas Importantes

- **Primer arranque**: Puede tardar 30-60 minutos en descargar boxes
- **Snapshots**: Crear snapshot después del primer arranque exitoso
- **Recursos**: Ajustar RAM/CPU según tu hardware
- **Red**: No cambiar configuración de red sin entender las implicaciones
- **Uso educativo**: Este laboratorio es solo para fines educativos

---

**Versión**: 2.0  
**Última actualización**: Octubre 2025
