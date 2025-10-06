# Post-Configuración del Laboratorio

Pasos recomendados después de la instalación inicial del laboratorio.

## ✅ Checklist Post-Instalación

### 1. 🧪 Verificar Conectividad

```bash
# Ejecutar test automático
cd ~/laboratorio-sad
./test-conectividad.sh

# Verificar estado de VMs
vagrant status

# Verificar IPs
vagrant ssh ubuntu-server -c "ip addr show"
vagrant ssh kali-security -c "ip addr show"
vagrant ssh storage-backup -c "ip addr show"
```

**Resultado esperado**:
- ✅ Todas las VMs responden a ping
- ✅ Servicios SSH/RDP accesibles
- ✅ Servicios web (Apache, IIS) funcionando

---

### 2. 💾 Crear Snapshots Iniciales

**¿Por qué?**
- Poder restaurar estado limpio
- Recuperarse de errores
- Probar configuraciones sin miedo

**Cómo crear snapshots**:

```bash
# Opción A: Con VirtualBox (recomendado)
VBoxManage snapshot "SAD-Ubuntu-Server" take "instalacion-inicial" --description "Estado limpio después de instalación"
VBoxManage snapshot "SAD-Windows-Server" take "instalacion-inicial"
VBoxManage snapshot "SAD-Windows-Client" take "instalacion-inicial"
VBoxManage snapshot "SAD-Storage-Backup" take "instalacion-inicial"
VBoxManage snapshot "SAD-Kali-Security" take "instalacion-inicial"

# Opción B: Script automatizado
for vm in "SAD-Ubuntu-Server" "SAD-Windows-Server" "SAD-Windows-Client" "SAD-Storage-Backup" "SAD-Kali-Security"; do
    VBoxManage snapshot "$vm" take "instalacion-inicial-$(date +%Y%m%d)"
done
```

**Verificar snapshots**:
```bash
VBoxManage snapshot "SAD-Ubuntu-Server" list
```

**Restaurar snapshot**:
```bash
# Detener VM primero
vagrant halt ubuntu-server

# Restaurar
VBoxManage snapshot "SAD-Ubuntu-Server" restore "instalacion-inicial"

# Reiniciar
vagrant up ubuntu-server
```

---

### 3. 🔄 Actualizar Sistemas

**⚠️ Importante**: Crear snapshot ANTES de actualizar.

#### Ubuntu Server:
```bash
vagrant ssh ubuntu-server
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
exit
```

#### Kali Security:
```bash
vagrant ssh kali-security
sudo apt update
sudo apt upgrade -y
exit
```

#### Storage Backup:
```bash
vagrant ssh storage-backup
sudo apt update
sudo apt upgrade -y
exit
```

#### Windows (RDP):
```powershell
# En PowerShell como Administrador
sconfig  # Opción 6: Download and Install Updates

# O Windows Update desde configuración
```

---

### 4. 🔐 Cambiar Contraseñas (Opcional)

Si compartes el laboratorio o quieres más seguridad:

#### Linux:
```bash
vagrant ssh ubuntu-server
passwd admin
# Introducir nueva contraseña
exit
```

#### Windows:
```powershell
# RDP como labadmin
net user labadmin NuevaPassword123!
```

**📝 Documentar**: Anotar nuevas contraseñas en lugar seguro.

---

### 5. 📊 Configurar Monitorización

#### Instalar herramientas de monitorización:

**Ubuntu Server**:
```bash
vagrant ssh ubuntu-server
sudo apt install -y htop iotop nethogs
exit
```

**Kali Security**:
```bash
vagrant ssh kali-security
# htop ya incluido en Kali
sudo apt install -y iftop
exit
```

#### Verificar recursos:
```bash
# Desde el host
VBoxManage list runningvms
VBoxManage metrics list

# Ver uso de CPU/RAM
VBoxManage metrics query "SAD-Ubuntu-Server" CPU/Load/User,RAM/Usage/Used
```

---

### 6. 🌐 Configurar Acceso a Internet

Todas las VMs tienen NAT por defecto, pero verifica:

```bash
# Test desde cada VM
vagrant ssh ubuntu-server -c "ping -c 3 8.8.8.8"
vagrant ssh ubuntu-server -c "curl -I https://www.google.com"
```

Si falla:
```bash
# Verificar ruta por defecto
vagrant ssh ubuntu-server -c "ip route"

# Debe mostrar:
# default via 10.0.2.2 dev eth0  (NAT)
# 192.168.56.0/24 dev eth1  (Host-Only)
```

---

### 7. 📁 Configurar Carpetas Compartidas (Opcional)

Para compartir archivos entre host y VMs:

**En Vagrantfile**, añadir:
```ruby
config.vm.synced_folder "./compartido", "/vagrant/compartido"
```

**Uso**:
```bash
# Crear carpeta en host
mkdir ~/laboratorio-sad/compartido

# Recargar VM
vagrant reload ubuntu-server

# Acceder desde VM
vagrant ssh ubuntu-server
ls /vagrant/compartido
```

---

### 8. 🔥 Configurar Firewall (Producción)

**⚠️ Solo si el laboratorio estará en red pública**.

#### Ubuntu Server:
```bash
vagrant ssh ubuntu-server
sudo ufw enable
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 3306/tcp  # MySQL
sudo ufw allow from 192.168.56.0/24  # Red local
sudo ufw status
exit
```

#### Windows:
```powershell
# Habilitar firewall
netsh advfirewall set allprofiles state on

# Mantener reglas de ping, RDP ya configuradas
```

---

### 9. 📚 Instalar Software Adicional

#### Ubuntu Server - Herramientas útiles:
```bash
vagrant ssh ubuntu-server
sudo apt install -y \
    net-tools \
    vim \
    curl \
    wget \
    git \
    tree \
    tcpdump \
    netcat
exit
```

#### Kali - Metasploit (si se necesita):
```bash
vagrant ssh kali-security
sudo ~/install-metasploit.sh
# Esto instalará Metasploit Framework
exit
```

#### Windows Server - Herramientas admin:
```powershell
# Desde RDP como labadmin
# Instalar Chocolatey (gestor de paquetes)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Instalar herramientas
choco install -y sysinternals procexp notepadplusplus
```

---

### 10. 📝 Documentar Tu Entorno

Crear archivo `mi-configuracion.md`:

```markdown
# Mi Configuración del Laboratorio

## Información del Sistema Host
- OS: [tu OS]
- RAM total: [X GB]
- VirtualBox versión: [X.X.X]
- Vagrant versión: [X.X.X]

## Snapshots Creados
- [Fecha]: instalacion-inicial
- [Fecha]: pre-practica-modulo-3

## Contraseñas Modificadas
- Ubuntu admin: [nueva contraseña]
- Windows labadmin: [nueva contraseña]

## Software Adicional Instalado
- Ubuntu: [lista de paquetes]
- Kali: [lista de herramientas]
- Windows: [lista de aplicaciones]

## Notas
- [Tus observaciones]
- [Problemas encontrados y soluciones]
```

---

### 11. 🎓 Preparar Ejercicios

Crear estructura para prácticas:

```bash
mkdir -p ~/laboratorio-sad/ejercicios/{modulo2,modulo3,modulo4,modulo5,modulo6}
mkdir -p ~/laboratorio-sad/evidencias
mkdir -p ~/laboratorio-sad/backups
```

---

### 12. 🚀 Optimizar Rendimiento

#### A) Usar Linked Clones (ya configurado en Vagrantfile):
```ruby
vb.linked_clone = true
```

#### B) Ajustar recursos según tu hardware:

**Si tienes 8GB RAM**:
```ruby
# Ubuntu: 1GB en lugar de 1.5GB
vb.memory = "1024"
```

**Si tienes 16GB RAM o más**:
```ruby
# Puedes aumentar recursos
vb.memory = "2048"
vb.cpus = 2
```

#### C) Usar suspend en lugar de halt:
```bash
# Más rápido para trabajar día a día
vagrant suspend --all    # Al terminar
vagrant resume --all     # Al continuar
```

---

### 13. 📤 Exportar OVAs (Para compartir)

Si quieres compartir las VMs configuradas:

```bash
# Detener VM
vagrant halt ubuntu-server

# Exportar
VBoxManage export "SAD-Ubuntu-Server" \
    --output ubuntu-server-v1.0.ova \
    --manifest \
    --vsys 0 \
    --description "Ubuntu Server - Lab SAD v2.0" \
    --version "1.0"

# Calcular checksum
sha256sum ubuntu-server-v1.0.ova
```

---

### 14. 🧹 Mantenimiento Regular

#### Semanal:
```bash
# Verificar espacio en disco
df -h

# Limpiar logs antiguos (en VMs)
vagrant ssh ubuntu-server -c "sudo journalctl --vacuum-time=7d"
```

#### Mensual:
```bash
# Actualizar sistemas
# Limpiar snapshots antiguos
VBoxManage snapshot "SAD-Ubuntu-Server" list
VBoxManage snapshot "SAD-Ubuntu-Server" delete "snapshot-antiguo"

# Compactar discos
VBoxManage modifymedium disk ruta/al/disco.vdi --compact
```

---

## ✅ Checklist Final

Marca cuando completes cada paso:

- [ ] Test de conectividad exitoso
- [ ] Snapshots iniciales creados
- [ ] Sistemas actualizados
- [ ] Contraseñas documentadas
- [ ] Herramientas de monitorización instaladas
- [ ] Acceso a Internet verificado
- [ ] Carpetas compartidas configuradas (opcional)
- [ ] Firewall configurado (si necesario)
- [ ] Software adicional instalado
- [ ] Entorno documentado
- [ ] Estructura de ejercicios creada
- [ ] Rendimiento optimizado
- [ ] OVAs exportadas (si necesario)

---

## 🆘 Próximos Pasos

1. **Familiarizarse**: Explora cada VM, servicios instalados
2. **Probar ejercicios**: Empezar con prácticas básicas
3. **Crear más snapshots**: Antes de cada módulo
4. **Documentar**: Anotar problemas y soluciones
5. **Compartir**: Si trabajas en equipo, compartir configuración

---

**Recuerda**: Siempre crear snapshot antes de cambios importantes.

---

**Versión**: 2.0  
**Última actualización**: Octubre 2025
