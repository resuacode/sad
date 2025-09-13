# Windows Server - Descarga OVA

## 📦 Windows Server 2022 - Controlador de Dominio

**Archivo:** `WindowsServer2022-SAD.ova`  
**Tamaño:** ~8 GB  
**Sistema:** Windows Server 2022 Standard  
**Configuración:** 3 GB RAM, 2 vCPU, 40 GB disco  

## 🔐 Credenciales Preconfiguradas

- **Usuario Administrador:** `Administrador`
- **Contraseña:** `Admin123!`
- **Dominio:** `sad.local`
- **Usuario dominio:** `saduser`
- **Contraseña dominio:** `User123!`

## 🔗 [Enlace de Descarga](https://iesarmandocotarelovall-my.sharepoint.com/:u:/g/personal/dresua_iescotarelo_org/Ea5YcdlFF4NCoPTz_aTAqvMBfMWEp3ItfInNCYZZ9P2GRQ?e=jDjzko)

## ✅ Verificación de Integridad

**SHA256 Checksum:**
```
a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1f2
```

**Verificar en Linux/macOS:**
```bash
sha256sum WindowsServer2022-SAD.ova
```

**Verificar en Windows:**
```powershell
Get-FileHash -Path "WindowsServer2022-SAD.ova" -Algorithm SHA256
```

## 📋 Servicios Preconfigurados

### Active Directory
- **Dominio:** `sad.local`
- **Nivel funcional:** Windows Server 2022
- **DNS:** Integrado con AD
- **DHCP:** Configurado para la red del laboratorio

### Autoridad Certificadora (CA)
- **CA Raíz:** `SAD-RootCA`
- **CA Subordinada:** `SAD-IssuingCA`
- **Plantillas:** Usuario, Servidor Web, VPN
- **CRL:** Publicada automáticamente

### Servicios de Red
- **DNS:** 192.168.56.11 (IP del servidor)
- **DHCP:** Rango 192.168.56.50-100
- **IIS:** Instalado con certificados SSL
- **Terminal Services:** Habilitado para administración

### Usuarios y Grupos Preconfigurados

#### Usuarios del Dominio
- **saduser** - Usuario estándar del dominio
- **admin.sad** - Administrador del dominio
- **prof.sad** - Cuenta del profesor
- **estudiante1-20.sad** - Cuentas para estudiantes

#### Grupos de Seguridad
- **SAD-Admins** - Administradores del laboratorio
- **SAD-Users** - Usuarios estándar
- **SAD-Crypto** - Usuarios con permisos de certificados

## 🔧 Configuración Post-Importación

1. **Verificar red:** Debe estar en `vboxnet-sad` (192.168.56.0/24)
2. **Confirmar IP:** 192.168.56.11
3. **Probar RDP:** `mstsc /v:192.168.56.11`
4. **Verificar AD:** Debe resolver `sad.local`
5. **Comprobar CA:** MMC → Certificados → Autoridad de certificación

## 🎯 Casos de Uso en el Laboratorio

### Módulo 2: Criptografía y PKI
- **Gestión de CA:** Emisión y revocación de certificados
- **Plantillas:** Configuración de plantillas personalizadas  
- **OCSP:** Validación online de certificados
- **Cadenas de confianza:** Jerarquías de CA

### Módulo 3: Seguridad en Sistemas
- **Políticas de grupo:** GPOs de seguridad
- **Auditoría:** Logs de eventos de seguridad
- **Control de acceso:** RBAC y ACLs
- **Gestión de usuarios:** Creación y administración

### Módulo 4: Seguridad en Redes
- **Autenticación 802.1X:** Con certificados
- **VPN:** Servidor RRAS con certificados
- **IPSec:** Políticas de cifrado
- **Firewall:** Windows Defender con reglas avanzadas

### Módulo 5: Seguridad Web
- **IIS con SSL:** Certificados de servidor
- **Autenticación integrada:** Kerberos/NTLM
- **Aplicaciones web:** ASP.NET con autenticación AD
- **Certificados cliente:** Autenticación por certificado

## 🔑 Certificados Preinstalados

### Autoridad Raíz
- **Nombre:** SAD-RootCA
- **Validez:** 20 años
- **Ubicación:** Almacén raíz de confianza

### CA Emisora
- **Nombre:** SAD-IssuingCA  
- **Validez:** 10 años
- **Plantillas activas:** Usuario, Servidor Web, VPN

### Certificados de Servidor
- **Servidor web:** `servidor.sad.local`
- **RDP:** Para conexiones de escritorio remoto
- **VPN:** Para servidor RRAS


- 📚 **Documentación:** [Troubleshooting](../../documentacion/troubleshooting.md)

---

**⚠️ Nota:** Esta OVA está configurada únicamente para fines educativos. No usar en entornos de producción.
