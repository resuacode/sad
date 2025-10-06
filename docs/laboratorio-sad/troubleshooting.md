# Troubleshooting - Solución de Problemas

## 🔧 Problemas Comunes y Soluciones

### 1. ❌ Vagrant no encuentra la box

**Síntoma**:
```
The box 'ubuntu/jammy64' could not be found
```

**Solución**:
```bash
# Descargar box manualmente
vagrant box add ubuntu/jammy64

# Verificar boxes instaladas
vagrant box list

# Si falla la descarga, usar mirror alternativo
vagrant box add ubuntu/jammy64 --provider virtualbox
```

---

### 2. ❌ Error de red "vboxnet-sad no existe"

**Síntoma**:
```
Network 'vboxnet-sad' does not exist
```

**Solución**:
```bash
# VirtualBox creará la red automáticamente
# Si persiste, crear manualmente:

# Linux/Mac:
VBoxManage hostonlyif create
VBoxManage hostonlyif ipconfig vboxnet0 --ip 192.168.56.1 --netmask 255.255.255.0

# Windows:
# Archivo → Preferencias → Red → Agregar red Host-Only
# Configurar: 192.168.56.0/24
```

---

### 3. ❌ VM no arranca o se queda colgada

**Síntoma**:
```
Waiting for machine to boot...
```

**Soluciones**:

**A) Reiniciar VM**:
```bash
vagrant halt nombre-vm --force
vagrant up nombre-vm
```

**B) Verificar logs**:
```bash
vagrant up nombre-vm --debug
```

**C) Verificar VT-x/AMD-V** (virtualization):
```bash
# Linux
egrep -c '(vmx|svm)' /proc/cpuinfo
# Debe ser > 0

# Habilitar en BIOS si está desactivado
```

**D) Aumentar timeout**:
En Vagrantfile, añadir:
```ruby
config.vm.boot_timeout = 600
```

---

### 4. ❌ SSH no funciona

**Síntoma**:
```
SSH authentication failed
```

**Soluciones**:

**A) Usar Vagrant SSH**:
```bash
vagrant ssh nombre-vm
# Siempre debe funcionar
```

**B) SSH directo con contraseña**:
```bash
ssh -o PreferredAuthentications=password admin@192.168.56.10
```

**C) Regenerar claves SSH**:
```bash
vagrant halt nombre-vm
vagrant ssh-config nombre-vm > /tmp/ssh-config
ssh -F /tmp/ssh-config nombre-vm
```

---

### 5. ❌ WinRM timeout en Windows

**Síntoma**:
```
WinRM connection timeout
```

**Soluciones**:

**A) Aumentar timeout** en Vagrantfile:
```ruby
config.winrm.timeout = 1800
```

**B) Verificar que WinRM está activo**:
- Conectar por RDP
- Abrir PowerShell como admin:
```powershell
winrm quickconfig
Enable-PSRemoting -Force
```

**C) Reprovisionar**:
```bash
vagrant reload windows-server --provision
```

---

### 6. ❌ Error de espacio en disco

**Síntoma**:
```
No space left on device
```

**Soluciones**:

**A) Limpiar boxes antiguas**:
```bash
vagrant box list
vagrant box prune
```

**B) Limpiar VMs antiguas**:
```bash
vagrant global-status
vagrant destroy <id>
vagrant global-status --prune
```

**C) Compactar discos** (VirtualBox):
```bash
# Desde dentro de la VM:
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY

# Desde el host:
VBoxManage modifymedium disk ruta/al/disco.vdi --compact
```

---

### 7. ❌ Puerto ya en uso

**Síntoma**:
```
Port 2222 is already in use
```

**Solución**:
```bash
# Cambiar puerto en Vagrantfile:
config.vm.network "forwarded_port", guest: 22, host: 2223

# O matar proceso que usa el puerto:
# Linux/Mac:
sudo lsof -i :2222
sudo kill -9 <PID>

# Windows:
netstat -ano | findstr :2222
taskkill /PID <PID> /F
```

---

### 8. ❌ Rendimiento muy lento

**Síntomas**:
- VM tarda mucho en arrancar
- Operaciones lentas

**Soluciones**:

**A) Reducir VMs activas**:
```bash
# Solo levantar las necesarias
vagrant up ubuntu-server kali-security
```

**B) Aumentar recursos**:
En Vagrantfile:
```ruby
vb.memory = "2048"  # Aumentar RAM
vb.cpus = 2         # Aumentar CPUs
```

**C) Usar suspend en lugar de halt**:
```bash
vagrant suspend nombre-vm    # Más rápido
vagrant resume nombre-vm
```

**D) Desactivar GUI**:
```ruby
vb.gui = false  # Ya está en el Vagrantfile
```

---

### 9. ❌ Error de provisioning

**Síntoma**:
```
Script provision failed
```

**Soluciones**:

**A) Ver logs detallados**:
```bash
vagrant up nombre-vm --provision --debug
```

**B) Reprovisionar manualmente**:
```bash
vagrant ssh nombre-vm
# Ejecutar script manualmente:
sudo bash /vagrant/provision/nombre-script.sh
```

**C) Omitir provisioning y hacerlo manual**:
```bash
vagrant up nombre-vm --no-provision
```

---

### 10. ❌ No puedo hacer ping entre VMs

**Síntoma**:
```
ping: Destination Host Unreachable
```

**Soluciones**:

**A) Verificar red**:
```bash
# Desde la VM:
ip addr show
# Debe tener IP 192.168.56.X

# Si no tiene IP:
sudo dhclient eth1
```

**B) Verificar firewall**:
```bash
# Linux:
sudo ufw status
sudo ufw disable  # Temporal

# Windows (PowerShell admin):
netsh advfirewall set allprofiles state off
```

**C) Verificar configuración VirtualBox**:
- Todas las VMs deben estar en la misma red Host-Only
- Adaptador 2: Red Host-Only (vboxnet-sad)

---

### 11. ❌ Guest Additions no funcionan

**Síntoma**:
- Carpetas compartidas no funcionan
- Resolución de pantalla incorrecta

**Solución**:
```bash
# Instalar plugin:
vagrant plugin install vagrant-vbguest

# Reinstalar Guest Additions:
vagrant vbguest nombre-vm --do install --force
```

---

### 12. ❌ Windows no encuentra el dominio

**Nota**: Este laboratorio NO usa Active Directory. Las VMs Windows están en grupo de trabajo `LAB-SAD`.

Si necesitas unir a dominio:
1. Instalar AD manualmente en Windows Server
2. Configurar DNS correctamente
3. Unir cliente al dominio

---

## 🆘 Comandos de Recuperación

### Reset completo de una VM:
```bash
vagrant destroy nombre-vm --force
vagrant up nombre-vm
```

### Reset de toda red:
```bash
vagrant halt
VBoxManage list hostonlyifs
VBoxManage hostonlyif remove vboxnet0  # Cuidado!
vagrant up
```

### Backup antes de cambios:
```bash
# Snapshot con VirtualBox:
VBoxManage snapshot "SAD-Ubuntu-Server" take "pre-cambio"

# Restaurar:
VBoxManage snapshot "SAD-Ubuntu-Server" restore "pre-cambio"
```

---

## 📞 Obtener Ayuda

1. **Logs de Vagrant**:
```bash
vagrant up --debug > vagrant.log 2>&1
```

2. **Logs de VirtualBox**:
- VirtualBox GUI → VM → Configuración → Logs

3. **Estado del sistema**:
```bash
vagrant global-status
vagrant status
VBoxManage list runningvms
```

4. **Información de red**:
```bash
VBoxManage list hostonlyifs
VBoxManage list dhcpservers
```

---

## 🔄 Procedimiento de Reset Total

Si nada funciona:

```bash
# 1. Destruir todas las VMs
vagrant destroy --force

# 2. Limpiar boxes
vagrant box prune

# 3. Eliminar datos de Vagrant
rm -rf .vagrant/

# 4. Reiniciar VirtualBox Host-Only
VBoxManage list hostonlyifs
# Anotar nombre (ej: vboxnet0)
VBoxManage hostonlyif remove vboxnet0

# 5. Volver a crear
vagrant up
```

---

**Nota**: Si el problema persiste después de estos pasos, puede ser necesario:
- Reinstalar VirtualBox
- Reinstalar Vagrant
- Verificar hardware (VT-x/AMD-V, espacio en disco, RAM)

---

**Versión**: 2.0  
**Última actualización**: Octubre 2025
