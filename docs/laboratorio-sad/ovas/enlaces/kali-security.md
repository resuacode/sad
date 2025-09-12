# Kali Security - Descarga OVA

## 📦 Kali Linux 2023.3 - Auditoría y Seguridad

**Archivo:** `Kali-Security-SAD.ova`  
**Tamaño:** ~8 GB  
**Sistema:** Kali Linux 2023.3 (optimizado)  
**Configuración:** 3 GB RAM, 2 vCPU, 35 GB disco  

## 🔐 Credenciales Preconfiguradas

- **Usuario principal:** `kali`
- **Contraseña:** `kali123!`
- **Usuario root:** `root`
- **Contraseña root:** `toor123!`

## 🔗 Enlaces de Descarga

### Opción 1: Google Drive
```
https://drive.google.com/file/d/1ZZZZZZZZZZZZZZZ/view?usp=sharing
```

### Opción 2: OneDrive Educativo
```
https://educacion-my.sharepoint.com/personal/profesor_centro_edu/Documents/SAD/Kali-Security-SAD.ova
```

### Opción 3: Servidor del Centro
```
http://servidor.centro.edu/laboratorios/sad/Kali-Security-SAD.ova
```

## ✅ Verificación de Integridad

**SHA256 Checksum:**
```
f1g2h3i4j5k6l7m8n9o0p1q2r3s4t5u6v7w8x9y0z1a2b3c4d5e6f7g8h9i0j1k2
```

**Verificar en Linux/macOS:**
```bash
sha256sum Kali-Security-SAD.ova
```

**Verificar en Windows:**
```powershell
Get-FileHash -Path "Kali-Security-SAD.ova" -Algorithm SHA256
```

## 🛠️ Herramientas Preinstaladas

### Análisis de Red
- **nmap** - Escáner de puertos y servicios
- **wireshark** - Captura y análisis de tráfico
- **tcpdump** - Captura de paquetes por línea de comandos
- **netcat** - Utilidad de red multiuso

### Auditoría Web
- **burpsuite** - Suite de pruebas de aplicaciones web
- **owasp-zap** - Proxy de seguridad web
- **nikto** - Escáner de vulnerabilidades web
- **dirb/gobuster** - Descubrimiento de directorios

### Criptografía y PKI
- **openssl** - Toolkit de criptografía
- **gpg** - Cifrado y firmas digitales
- **john** - Cracking de passwords
- **hashcat** - Herramienta de hash cracking

### Análisis Forense
- **autopsy** - Plataforma de análisis forense
- **volatility** - Análisis de memoria
- **binwalk** - Análisis de firmware
- **strings** - Extracción de cadenas

### Utilidades Generales
- **metasploit** - Framework de explotación
- **sqlmap** - Detección de inyección SQL
- **hydra** - Brute force login cracker
- **aircrack-ng** - Suite de auditoría WiFi

## 🔧 Configuración Post-Importación

1. **Verificar red:** Debe estar en `vboxnet-sad` (192.168.56.0/24)
2. **Confirmar IP:** 192.168.56.15
3. **Probar SSH:** `ssh kali@192.168.56.15`
4. **Verificar herramientas:** Ejecutar `kali-tools-check`
5. **Actualizar base de datos:** `sudo updatedb && sudo mlocate burpsuite`

## 🎯 Casos de Uso en el Laboratorio

### Módulo 2: Criptografía y PKI
- Análisis de certificados SSL/TLS
- Cracking de hashes y passwords
- Validación de algoritmos criptográficos
- Auditoría de implementaciones PKI

### Módulo 3: Seguridad en Sistemas
- Escaneo de vulnerabilidades
- Análisis de configuraciones
- Pruebas de penetración básicas
- Auditoría de servicios

### Módulo 4: Seguridad en Redes
- Captura y análisis de tráfico
- Detección de intrusiones
- Análisis de protocolos
- Monitorización de red

### Módulo 5: Seguridad Web
- Auditoría de aplicaciones web
- Detección de vulnerabilidades OWASP
- Análisis de código
- Pruebas de inyección

### Módulo 6: Análisis Forense
- Análisis de evidencias digitales
- Recuperación de datos
- Análisis de malware
- Timeline de incidentes

## 📚 Documentación Adicional

- **Guías de herramientas:** `/home/kali/Documentation/`
- **Scripts personalizados:** `/home/kali/sad-scripts/`
- **Ejemplos de laboratorio:** `/home/kali/lab-examples/`
- **Cheatsheets:** `/home/kali/cheatsheets/`

## 📞 Soporte

- 📚 **Documentación:** [Troubleshooting](../../documentacion/troubleshooting.md)

---

**⚠️ Nota:** Esta OVA está configurada únicamente para fines educativos. No usar en entornos de producción.
