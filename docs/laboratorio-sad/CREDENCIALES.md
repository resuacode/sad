# Credenciales del Laboratorio SAD v2.0

## 🔐 Credenciales por Máquina Virtual

### 🐧 Ubuntu Server (192.168.56.10)
| Usuario | Contraseña | Permisos | Uso |
|---------|------------|----------|-----|
| `vagrant` | `vagrant` | sudo | Vagrant SSH automático |
| `admin` | `adminSAD2024!` | sudo | Usuario principal para prácticas |

**Base de datos MySQL**:
- Usuario: `labsad`
- Contraseña: `labsad123`
- Base de datos: `labsad`

**Acceso**:
```bash
# SSH directo
ssh admin@192.168.56.10

# SSH por puerto forwarded
ssh -p 2210 admin@localhost

# Vagrant SSH (como vagrant)
vagrant ssh ubuntu-server

# MySQL
mysql -u labsad -p labsad
```

---

### 🪟 Windows Server (192.168.56.11)
| Usuario | Contraseña | Permisos | Uso |
|---------|------------|----------|-----|
| `vagrant` | `vagrant` | Administrador | WinRM/Vagrant |
| `labadmin` | `Password123!` | Administrador | Usuario principal para prácticas |

**Servicios**:
- IIS: http://192.168.56.11
- SMB Share: `\\192.168.56.11\Public`
- Grupo de trabajo: `LAB-SAD`

**Acceso**:
```bash
# RDP directo
xfreerdp /u:labadmin /p:Password123! /v:192.168.56.11

# RDP por puerto forwarded
xfreerdp /u:labadmin /p:Password123! /v:localhost:3389

# Desde Windows
mstsc /v:192.168.56.11
```

---

### 💻 Windows Client (192.168.56.12)
| Usuario | Contraseña | Permisos | Uso |
|---------|------------|----------|-----|
| `vagrant` | `vagrant` | Usuario estándar | WinRM/Vagrant |
| `cliente` | `User123!` | Usuario estándar | Usuario principal para prácticas |

**Acceso**:
```bash
# RDP directo
xfreerdp /u:cliente /p:User123! /v:192.168.56.12

# RDP por puerto forwarded
xfreerdp /u:cliente /p:User123! /v:localhost:3390
```

---

### 💾 Storage Backup (192.168.56.13)
| Usuario | Contraseña | Permisos | Uso |
|---------|------------|----------|-----|
| `vagrant` | `vagrant` | sudo | Vagrant SSH automático |
| `backup` | `backup123` | sudo | Usuario principal para prácticas |

**Servicios**:
- Samba: `//192.168.56.13/public` (usuario: backup, contraseña: backup123)
- NFS: `192.168.56.13:/srv/nfs/shared`

**Acceso**:
```bash
# SSH directo
ssh backup@192.168.56.13

# SSH por puerto forwarded  
ssh -p 2213 backup@localhost

# Vagrant SSH (como vagrant)
vagrant ssh storage-backup

# Montar share Samba (desde Linux)
sudo mount -t cifs //192.168.56.13/public /mnt -o user=backup,password=backup123

# Montar NFS (desde Linux)
sudo mount -t nfs 192.168.56.13:/srv/nfs/shared /mnt
```

---

### 🥷 Kali Security (192.168.56.20)
| Usuario | Contraseña | Permisos | Uso |
|---------|------------|----------|-----|
| `vagrant` | `vagrant` | sudo | Vagrant SSH automático |
| `kali` | `kali` | sudo | Usuario principal para prácticas |

**Acceso**:
```bash
# SSH directo
ssh kali@192.168.56.20

# SSH por puerto forwarded
ssh -p 2220 kali@localhost

# Vagrant SSH (como vagrant)
vagrant ssh kali-security
```

---

## 🔗 Matriz de Acceso Rápido

### SSH (Linux)
```bash
ssh admin@192.168.56.10    # Ubuntu Server
ssh backup@192.168.56.13   # Storage Backup  
ssh kali@192.168.56.20     # Kali Security
```

### RDP (Windows)
```bash
xfreerdp /u:labadmin /p:Password123! /v:192.168.56.11  # Windows Server
xfreerdp /u:cliente /p:User123! /v:192.168.56.12      # Windows Client
```

### Servicios Web
- Apache: http://192.168.56.10 o http://localhost:8080
- IIS: http://192.168.56.11 o http://localhost:8081

### Shares
- SMB Windows: `\\192.168.56.11\Public`
- Samba Linux: `//192.168.56.13/public`
- NFS: `192.168.56.13:/srv/nfs/shared`

---

## ⚠️ Notas de Seguridad

1. **Contraseñas simples**: Solo para entorno de laboratorio
2. **Firewall desactivado**: En algunas VMs para facilitar prácticas
3. **Acceso SSH con contraseña**: Habilitado para facilitar acceso
4. **Usuarios con sudo**: Para facilitar administración
5. **Shares abiertos**: Configuración permisiva para prácticas

**🔒 En producción**: Cambiar todas las contraseñas, habilitar firewall, usar claves SSH, restringir permisos.

---

## 📝 Cambiar Contraseñas

### Linux:
```bash
# Cambiar contraseña del usuario actual
passwd

# Cambiar contraseña de otro usuario (como root/sudo)
sudo passwd nombre_usuario
```

### Windows:
```powershell
# Cambiar contraseña (PowerShell como administrador)
net user nombre_usuario nueva_contraseña
```

---

## 🆘 Recuperación de Acceso

Si pierdes las credenciales:

**Vagrant (más fácil)**:
```bash
vagrant ssh nombre-vm
# Entras automáticamente como vagrant con sudo
```

**VirtualBox**:
1. Iniciar VM en modo recovery/single user
2. Resetear contraseña con `passwd`
3. Reiniciar

**Última opción**:
```bash
vagrant destroy nombre-vm
vagrant up nombre-vm
# Recrear VM con credenciales originales
```

---

**Versión**: 2.0  
**Última actualización**: Octubre 2025
