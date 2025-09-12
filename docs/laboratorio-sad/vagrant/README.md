# Opción B: Automatización con Vagrant

## 🤖 Descripción

Vagrant es una herramienta de automatización que permite crear y configurar entornos de desarrollo de manera reproducible. Con Vagrant, puedes levantar todo el laboratorio con un solo comando y destruirlo cuando termines.

## 🎯 Ventajas de Usar Vagrant

✅ **Automatización completa**: Un comando levanta todo el lab
✅ **Reproducibilidad**: Mismo entorno en cualquier máquina
✅ **Versionado**: Configuración como código (IaC)
✅ **Snapshots automáticos**: Estados guardados automáticamente
✅ **Limpieza fácil**: `vagrant destroy` elimina todo
✅ **Aprendizaje DevOps**: Herramienta industry-standard

## 📋 Prerrequisitos

### Software Necesario
```bash
# 1. VirtualBox 7.0+
# Descargar desde: https://www.virtualbox.org/

# 2. Vagrant 2.3+
# Descargar desde: https://www.vagrantup.com/

# 3. Git (para clonar repositorio)
# Windows: https://git-scm.com/
# Linux: sudo apt install git
# macOS: brew install git
```

### Verificar Instalación
```bash
# Comprobar versiones
vagrant --version    # Debe mostrar 2.3.x o superior
vboxmanage --version # Debe mostrar 7.0.x o superior
git --version        # Cualquier versión reciente
```

### Plugins Recomendados de Vagrant
```bash
# Plugin para recargar VMs (útil para cambios de kernel)
vagrant plugin install vagrant-reload

# Plugin para mejor gestión de VirtualBox
vagrant plugin install vagrant-vbguest

# Plugin para snapshots automáticos
vagrant plugin install vagrant-auto_network
```

## 🚀 Instalación y Uso

### Paso 1: Obtener el Código

#### Opción A: Clonar repositorio completo
```bash
git clone <url-repositorio>
cd laboratorio-sad/vagrant
```

#### Opción B: Solo archivos Vagrant
```bash
mkdir laboratorio-sad
cd laboratorio-sad
# Descargar archivos individuales de la carpeta vagrant/
```

### Paso 2: Configuración Inicial

#### 2.1 Revisar Vagrantfile
```bash
# Editar configuración si es necesario
nano Vagrantfile

# Ajustar según tu hardware:
# - RAM por VM
# - CPUs por VM  
# - Configuración de red
```

#### 2.2 Verificar recursos disponibles
```bash
# Linux/macOS
free -h           # RAM disponible
nproc            # CPUs disponibles
df -h            # Espacio en disco

# Windows (PowerShell)
Get-ComputerInfo | Select-Object TotalPhysicalMemory, CsProcessors
Get-PSDrive C    # Espacio en disco
```

### Paso 3: Levantar el Laboratorio

#### 3.1 Iniciar todas las VMs
```bash
# Crear y configurar todas las VMs
vagrant up

# Este proceso puede tomar 30-60 minutos en la primera ejecución
# Vagrant descargará las boxes base y ejecutará scripts de provisioning
```

#### 3.2 Iniciar VMs específicas
```bash
# Solo Ubuntu Server
vagrant up ubuntu-server

# Solo herramientas de seguridad
vagrant up kali-security

# Windows Server + Client
vagrant up windows-server windows-client
```

#### 3.3 Verificar estado
```bash
# Estado de todas las VMs
vagrant status

# Estado global más detallado
vagrant global-status
```

### Paso 4: Gestión del Laboratorio

#### 4.1 Conectarse a las VMs
```bash
# SSH a Ubuntu Server
vagrant ssh ubuntu-server

# SSH a Kali (si tiene SSH configurado)
vagrant ssh kali-security

# Para Windows, usar RDP o consola de VirtualBox
```

#### 4.2 Comandos útiles
```bash
# Reiniciar VM específica
vagrant reload ubuntu-server

# Suspender todas las VMs
vagrant suspend

# Reanudar todas las VMs
vagrant resume

# Reconfigurar (ejecutar provisioning de nuevo)
vagrant provision ubuntu-server

# Ver configuración SSH
vagrant ssh-config ubuntu-server
```

#### 4.3 Snapshots y respaldos
```bash
# Crear snapshot de estado actual
vagrant snapshot save ubuntu-server "configuracion-inicial"

# Listar snapshots
vagrant snapshot list ubuntu-server

# Restaurar snapshot
vagrant snapshot restore ubuntu-server "configuracion-inicial"

# Eliminar snapshot
vagrant snapshot delete ubuntu-server "configuracion-inicial"
```

## 📁 Estructura del Proyecto

```
vagrant/
├── Vagrantfile                 # Configuración principal
├── provision/                  # Scripts de configuración
│   ├── common/                # Scripts comunes para todas las VMs
│   │   ├── update-system.sh
│   │   ├── install-basics.sh
│   │   └── configure-network.sh
│   ├── ubuntu-server/         # Específicos para Ubuntu
│   │   ├── install-services.sh
│   │   ├── configure-ssh.sh
│   │   └── setup-firewall.sh
│   ├── windows-server/        # Específicos para Windows Server
│   │   ├── install-roles.ps1
│   │   ├── configure-ad.ps1
│   │   └── setup-dns-dhcp.ps1
│   ├── kali-security/         # Específicos para Kali
│   │   ├── update-tools.sh
│   │   ├── configure-metasploit.sh
│   │   └── setup-wireshark.sh
│   └── storage-backup/        # Específicos para Storage
│       ├── install-backup-tools.sh
│       ├── configure-samba.sh
│       └── setup-bacula.sh
├── configs/                   # Archivos de configuración
│   ├── ssh/
│   ├── network/
│   └── services/
├── boxes/                     # Información sobre boxes base
│   └── box-info.md
└── README.md                  # Esta documentación
```

## ⚙️ Configuración Detallada

### Vagrantfile Principal

El archivo principal define:
- **5 VMs** con sus especificaciones
- **Red privada** 192.168.56.0/24
- **Scripts de provisioning** automáticos
- **Forwarded ports** para acceso desde host
- **Configuración de recursos** adaptable

### Scripts de Provisioning

Cada VM ejecuta scripts específicos:

#### Ubuntu Server
- Actualización del sistema
- Instalación de Docker, SSH, UFW
- Configuración de servicios de red
- Herramientas de monitoreo (htop, iotop)

#### Windows Server
- Instalación de roles AD DS, DNS, DHCP
- Configuración de dominio SAD.local
- Políticas de grupo básicas
- Herramientas administrativas

#### Kali Security
- Actualización de herramientas
- Configuración de Metasploit
- Wireshark con permisos
- Scripts personalizados

#### Storage Backup
- Servicios Samba y NFS
- Cliente Bacula
- Scripts de backup automatizados
- Configuración de rclone

## 🔧 Personalización

### Modificar Recursos de VMs
```ruby
# En Vagrantfile, buscar sección de cada VM:
config.vm.provider "virtualbox" do |vb|
  vb.memory = "4096"    # Cambiar RAM
  vb.cpus = 2          # Cambiar CPUs
  vb.gui = false       # true para ver interfaz gráfica
end
```

### Añadir Software Personalizado
```bash
# Crear script en provision/custom/
# Añadir al Vagrantfile:
config.vm.provision "shell", path: "provision/custom/mi-software.sh"
```

### Configurar Red Diferente
```ruby
# Cambiar rango de red en Vagrantfile:
config.vm.network "private_network", ip: "10.0.1.10"  # Nueva IP
```

## 🎓 Comandos de Aprendizaje

### Para Estudiantes Nuevos en Vagrant
```bash
# Tutorial básico
vagrant init ubuntu/jammy64    # Crear Vagrantfile básico
vagrant up                     # Levantar VM
vagrant ssh                    # Conectar por SSH
vagrant halt                   # Apagar VM
vagrant destroy                # Eliminar VM

# Ver ayuda
vagrant --help
vagrant <comando> --help
```

### Workflow Típico de Desarrollo
```bash
# 1. Levantar laboratorio
vagrant up

# 2. Trabajar en ejercicios
vagrant ssh ubuntu-server

# 3. Hacer cambios, crear snapshot
vagrant snapshot save "ejercicio-completado"

# 4. Si algo se rompe, restaurar
vagrant snapshot restore "ejercicio-completado"

# 5. Al terminar, limpiar
vagrant destroy
```

## 📊 Monitoreo y Logs

### Ver logs de provisioning
```bash
# Logs en tiempo real
vagrant up --debug

# Logs específicos de VM
vagrant provision ubuntu-server --debug
```

### Verificar estado de servicios
```bash
# Ejecutar comandos remotos
vagrant ssh ubuntu-server -c "systemctl status ssh"
vagrant ssh kali-security -c "service metasploit status"
```

## 🚨 Troubleshooting Vagrant

### Problema: Box no se descarga
```bash
# Agregar box manualmente
vagrant box add ubuntu/jammy64
vagrant box add kalilinux/rolling

# Verificar boxes instaladas
vagrant box list
```

### Problema: VM no inicia
```bash
# Reiniciar con logs detallados
vagrant destroy
vagrant up --debug

# Verificar configuración VirtualBox
VBoxManage list vms
VBoxManage showvminfo <vm-name>
```

### Problema: Provisioning falla
```bash
# Re-ejecutar solo provisioning
vagrant provision ubuntu-server

# Ejecutar shell específico
vagrant ssh ubuntu-server -c "sudo /vagrant/provision/ubuntu-server/install-services.sh"
```

### Problema: Red no funciona
```bash
# Verificar configuración de red
vagrant ssh ubuntu-server -c "ip addr show"
vagrant ssh ubuntu-server -c "ping 192.168.56.1"

# Reiniciar red en VM
vagrant reload ubuntu-server
```

## 📖 Recursos de Aprendizaje

### Documentación Oficial
- [Vagrant Docs](https://www.vagrantup.com/docs)
- [VirtualBox Manual](https://www.virtualbox.org/manual/)

### Tutoriales Recomendados
- [Vagrant Tutorial - HashiCorp Learn](https://learn.hashicorp.com/vagrant)
- [Infrastructure as Code with Vagrant](https://www.infracloud.io/blogs/vagrant-infrastructure-as-code/)

### Comunidad
- [Vagrant GitHub](https://github.com/hashicorp/vagrant)
- [Stack Overflow - Vagrant](https://stackoverflow.com/questions/tagged/vagrant)

## 📖 Siguiente Paso

Una vez completada la instalación con Vagrant:
👉 **[Configuración Post-Instalación](../documentacion/post-configuracion.md)**

## 🏆 Ejercicios Avanzados con Vagrant

Después de dominar lo básico, prueba:
1. **Multi-provider**: Usar AWS/Azure además de VirtualBox
2. **Vagrant Cloud**: Compartir boxes personalizadas
3. **Ansible integration**: Provisioning con Ansible
4. **Custom boxes**: Crear tus propias boxes
