# Opción A: Instalación con OVAs Preconfiguradas

## 📦 Descripción

Las OVAs (Open Virtual Appliance) son máquinas virtuales preconfiguradas que se pueden importar directamente en VirtualBox. Esta opción es ideal para estudiantes que quieren empezar rápidamente sin lidiar con instalaciones desde cero.

## 📋 Lista de OVAs Disponibles

| OVA | Tamaño | Checksum SHA256 | Enlace de Descarga |
|-----|--------|-----------------|-------------------|
| **WindowsServer2022-SAD.ova** | ~8 GB | `9cf99d48...` | [Descargar](./enlaces/windows-server) |
| **Windows11-Client-SAD.ova** | ~6 GB | `72eed97c...` | [Descargar](./enlaces/windows-client) |
| **Ubuntu-Server-SAD.ova** | ~3 GB | `058240a0...` | [Descargar](./enlaces/ubuntu-server) |
| **Kali-Security-SAD.ova** | ~4 GB | `e6857d6e...` | [Descargar](./enlaces/kali-security) |
| **Debian-Storage-SAD.ova** | ~2 GB | `057863f8...` | [Descargar](./enlaces/storage-backup) |

## 🚀 Proceso de Instalación

### Paso 1: Preparación del Entorno

#### 1.1 Configurar Red Host-Only en VirtualBox
```bash
# Abrir VirtualBox Manager
# Ir a: Archivo → Administrador de red anfitrión
# Crear nueva red:
Nombre: vboxnet-sad
IPv4: 192.168.100.1/24
DHCP: Deshabilitado
```

#### 1.2 Crear directorio de trabajo
```bash
# Windows
mkdir C:\laboratorio-sad
cd C:\laboratorio-sad

# Linux/macOS
mkdir ~/laboratorio-sad
cd ~/laboratorio-sad
```

### Paso 2: Descarga de OVAs

#### 2.1 Verificar espacio disponible
```bash
# Necesitarás aproximadamente 25 GB libres
# Windows: dir
# Linux/macOS: df -h
```

#### 2.2 Descargar archivos (elegir uno)

**Opción A: Descarga individual**
- Descargar solo las OVAs necesarias para ejercicios específicos
- Comenzar con Ubuntu-Server y Kali-Security para ejercicios básicos

**Opción B: Descarga completa**
- Descargar todas las OVAs para tener el laboratorio completo
- Recomendado si tienes buena conexión a Internet

### Paso 3: Verificación de Integridad

```bash
# Windows (PowerShell)
Get-FileHash -Algorithm SHA256 .\WindowsServer2022-SAD.ova

# Linux/macOS
sha256sum WindowsServer2022-SAD.ova

# Comparar con checksums de la tabla anterior
```

### Paso 4: Importación en VirtualBox

#### 4.1 Importar OVA
```
1. Abrir VirtualBox
2. Archivo → Importar aplicación virtual
3. Seleccionar archivo .ova
4. Revisar configuración:
   - Nombre: Mantener sugerido
   - CPU: Ajustar según tu hardware
   - RAM: Verificar límites
   - Red: Cambiar a "Red solo anfitrión" (vboxnet-sad)
5. Importar
```

#### 4.2 Configuración post-importación
```
Para cada VM importada:
1. Clic derecho → Configuración
2. Red → Adaptador 1:
   - Conectado a: Red solo anfitrión
   - Nombre: vboxnet-sad
3. Sistema → Procesador:
   - Ajustar CPUs según tu hardware
4. Almacenamiento:
   - Verificar controlador SATA
```

### Paso 5: Primera Ejecución

#### 5.1 Iniciar VMs en orden
```
1. Ubuntu-Server (infraestructura base)
2. Windows-Server (servicios de dominio)
3. Windows-Client (después de que Server esté listo)
4. Kali-Security (cuando necesites herramientas)
5. Storage-Backup (cuando hagas ejercicios de backup)
```

#### 5.2 Verificar conectividad
```bash
# Desde Ubuntu-Server (192.168.100.30)
ping 192.168.100.10  # Windows-Server
ping 192.168.100.20  # Windows-Client
ping 192.168.100.40  # Kali-Security

# Desde Windows-Client
ping 192.168.100.30  # Ubuntu-Server
```

## 🔧 Configuraciones Incluidas

### Windows Server 2022
- **Roles instalados**: AD DS, DNS, DHCP, File Services
- **Características**: .NET Framework, PowerShell ISE
- **Software adicional**: Sysinternals Suite, 7-Zip
- **Configuración de red**: IP estática 192.168.100.10

### Windows 11 Client
- **Dominio**: Preconfigurado para unirse a dominio SAD.local
- **Software**: Office 365 (trial), Browsers actualizados
- **Herramientas**: Process Monitor, Wireshark
- **Configuración de red**: DHCP desde Windows Server

### Ubuntu Server 22.04
- **Servicios**: SSH, UFW configurado
- **Software**: curl, wget, git, vim, htop
- **Docker**: Instalado y configurado
- **Configuración de red**: IP estática 192.168.100.30

### Kali Linux 2023
- **Herramientas**: Suite completa de pentesting
- **Metasploit**: Configurado y actualizado
- **Wireshark**: Instalado con permisos
- **Configuración de red**: IP estática 192.168.100.40

### Debian Storage
- **Servicios**: SSH, Samba, NFS, rsync
- **Software**: Bacula (cliente), rclone
- **Configuración**: Carpetas compartidas preconfiguradas
- **Configuración de red**: IP estática 192.168.100.50

## 📋 Lista de Verificación Post-Instalación

### ✅ Checklist Básico
- [ ] Todas las VMs importadas correctamente
- [ ] Red host-only configurada (vboxnet-sad)
- [ ] IPs estáticas asignadas correctamente
- [ ] Conectividad entre VMs verificada
- [ ] Credenciales por defecto funcionando
- [ ] Snapshots iniciales creados

### ✅ Checklist Avanzado
- [ ] Windows Server promovido a controlador de dominio
- [ ] DNS resolviendo correctamente
- [ ] DHCP funcionando para clientes
- [ ] Ubuntu Server accesible por SSH
- [ ] Kali con herramientas actualizadas
- [ ] Storage con servicios de backup funcionando

## 🆘 Troubleshooting Común

### Problema: VM no inicia
**Solución**:
```
1. Verificar que VT-x/AMD-V esté habilitado en BIOS
2. Comprobar que Hyper-V esté deshabilitado (Windows)
3. Reducir RAM asignada si es necesario
4. Verificar espacio en disco disponible
```

### Problema: Sin conectividad de red
**Solución**:
```
1. Verificar que vboxnet-sad esté creada
2. Comprobar configuración de adaptador de red en VM
3. Verificar IPs estáticas en cada VM
4. Reiniciar servicios de red
```

### Problema: Rendimiento lento
**Solución**:
```
1. Asignar más RAM si está disponible
2. Habilitar aceleración de hardware
3. Cerrar VMs no necesarias
4. Usar SSD si es posible
```

## 📖 Siguiente Paso

Una vez completada la instalación, continúa con:
👉 **[Guía del Estudiante](../documentacion/guia-estudiante.md)**

## 📞 Soporte

Si encuentras problemas durante la instalación:
1. Consulta **[Troubleshooting](../documentacion/troubleshooting.md)**
2. Revisa logs de VirtualBox
3. Reporta issue en el repositorio con detalles del error
