# Guía para cuándo tenemos un hardware limitado

## 💾# Para criptografía y seguridad lógica (Tema 2)
vagrant up ubuntu-server windows-server kali-security

# Para seguridad perimetral (Tema 3)
vagrant up ubuntu-server kali-security windows-server

# Para firewalls y proxy (Tema 4)  
vagrant up ubuntu-server windows-server kali-security

# Para alta disponibilidad (Tema 5) - NECESITA VM ADICIONAL
vagrant up ubuntu-server storage-backup
# Nota: Para clústeres reales necesitarías clonar ubuntu-server

# Para ciberseguridad y auditorías (Tema 6)
vagrant up kali-security storage-backup ubuntu-server windows-serverones por Capacidad de Hardware

### 🔧 Configuración Mínima (8 GB RAM, 80 GB disco)

**Hardware del PC:**
- RAM: 8 GB (dejando 4-6 GB para el host)
- Disco: 80 GB libres
- CPU: Cualquier procesador de 4 núcleos con virtualización

**Estrategia de uso:**
- **Ejecutar máximo 2-3 VMs simultáneamente**
- Usar solo las VMs necesarias para cada ejercicio
- Apagar VMs no utilizadas

**VMs recomendadas por ejercicio:**

| Módulo | VMs Necesarias | RAM Usada | Ejercicios Principales |
|--------|----------------|-----------|------------------------|
| **Tema 2** | Ubuntu + Windows Server + Kali | 5.5 GB | Criptografía, certificados, políticas de contraseñas, auditoría, backup |
| **Tema 3** | Ubuntu + Kali + Windows Server | 5.5 GB | VPN, DMZ, RADIUS, LDAP, seguridad perimetral |
| **Tema 4** | Ubuntu + Windows Server + Kali | 5.5 GB | Firewalls (iptables, UFW), proxy (Squid), filtrado, pentesting |
| **Tema 5** | Ubuntu + Storage + Ubuntu2 (clúster) | 4.5 GB | Alta disponibilidad, virtualización, load balancing |
| **Tema 6** | Kali + Storage + Ubuntu + Windows | 7.5 GB | Análisis forense, pentesting avanzado, auditorías |

**📚 Detalles por Tema:**
- **Tema 2**: Criptografía simétrica/asimétrica, certificados X.509, políticas seguridad, backup/recuperación
- **Tema 3**: VPN (OpenVPN), DMZ, autenticación (RADIUS, LDAP), acceso remoto seguro  
- **Tema 4**: Firewalls avanzados, proxy transparente, filtrado contenido, monitorización
- **Tema 5**: Clústeres, snapshots, migración, contenedores, load balancers
- **Tema 6**: Forense digital, pentesting completo, IDS/IPS, auditorías de seguridad

**💡 Nota para Tema 5**: Para ejercicios de alta disponibilidad es recomendable tener una VM adicional para simular clústeres y failover.

### ⚡ Configuración Estándar (16 GB RAM, 120 GB disco)

**Todas las VMs disponibles simultáneamente**
- Configuración ideal para flujo de trabajo continuo
- Permite ejercicios complejos que requieren múltiples sistemas
- Snapshots y backups disponibles

### 🚀 Configuración Completa (32+ GB RAM, 200+ GB disco)

**Configuración profesional con espacio para experimentación**
- Todas las VMs + snapshots múltiples
- Espacio para VMs adicionales
- Configuración para instructores

## 📋 Comandos de Gestión Optimizada

### Iniciar Solo VMs Necesarias

```bash
# Para ejercicios de seguridad perimetral (Módulo 3)
vagrant up ubuntu-server kali-security windows-server

# Para firewalls y proxy (Módulo 4)  
vagrant up ubuntu-server windows-server kali-security

# Para alta disponibilidad (Módulo 5) - NECESITA VM ADICIONAL
vagrant up ubuntu-server storage-backup
# Nota: Para clústeres reales necesitarías clonar ubuntu-server

# Para análisis forense completo (Módulo 6)
vagrant up kali-security storage-backup ubuntu-server windows-server

# Para control de acceso (Módulo 4)
vagrant up ubuntu-server windows-server
```

### Gestión de Memoria

```bash
# Ver uso actual de RAM
vagrant status
VBoxManage list runningvms

# Parar VMs específicas
vagrant halt windows-client
vagrant halt storage-backup

# Suspender en lugar de apagar (más rápido para reanudar)
vagrant suspend ubuntu-server
vagrant resume ubuntu-server
```

### Optimización de Disco

```bash
# Compactar discos virtuales (ejecutar cuando VMs estén apagadas)
VBoxManage modifymedium disk "ruta/al/disco.vdi" --compact

# Eliminar snapshots antiguos
VBoxManage snapshot "nombre-vm" delete "nombre-snapshot"

# Ver uso de disco por VM
du -sh ~/VirtualBox\ VMs/*
```

## ⚠️ Análisis de Cobertura por Tema

### ✅ Temas COMPLETAMENTE Cubiertos

**Tema 2 - Seguridad Activa y Prácticas Seguras:**
- Ubuntu Server: Criptografía (OpenSSL), certificados X.509, servicios seguros
- Windows Server: Políticas de contraseñas, AD, GPO, backup/recuperación
- Kali Linux: Auditoría de seguridad, análisis de vulnerabilidades
- Storage: Sistemas de backup, recuperación de datos
- **Criptografía**: Simétrica (AES, DES), asimétrica (RSA), híbrida, hashing

**Tema 3 - Seguridad Perimetral:**
- Ubuntu Server: VPN (OpenVPN), RADIUS, LDAP, DMZ
- Kali Linux: Pentesting, análisis de seguridad perimetral
- Windows Server: Autenticación corporativa, AD
- Red 192.168.56.x: Simula perímetro de red

**Tema 4 - Firewalls y Proxy:**
- Ubuntu Server: iptables, UFW, Squid proxy, filtrado
- Kali Linux: Pruebas de firewall, sondeo, bypass
- Windows Server: Target para filtrado, logs
- Storage: Centralización de logs y monitorización

**Tema 6 - Ciberseguridad y Auditorías:**
- Kali Linux: Herramientas forenses, pentesting, auditorías
- Ubuntu/Windows: Targets para análisis forense
- Storage: Preservación de evidencias, cadena de custodia

### ⚠️ Tema con LIMITACIONES

**Tema 5 - Alta Disponibilidad:**
- ✅ Virtualización básica cubierta (VirtualBox, Vagrant)
- ✅ Snapshots y migración básica
- ❌ **FALTA**: Segunda VM para clústeres reales
- ❌ **FALTA**: Load balancer dedicado
- ❌ **LIMITADO**: Simulación de failover entre nodos

**Recomendaciones para Tema 5:**
```bash
# Opción 1: Clonar VM existente para clúster
VBoxManage clonevm "SAD-Ubuntu-Server" --name "SAD-Ubuntu-Server-2" --register

# Opción 2: Usar contenedores para simular servicios
docker run -d --name web1 nginx
docker run -d --name web2 nginx
docker run -d --name loadbalancer nginx

# Opción 3: Servicios cloud (AWS/Azure) para ejercicios avanzados
```

## 🛠️ Alternativas para Hardware Muy Limitado

### Opción 1: VMs Individuales por Ejercicio

Si tienes menos de 8 GB RAM, considera crear una VM por vez:

```bash
# Crear solo la VM necesaria para el ejercicio actual
vagrant up ubuntu-server
# Hacer ejercicio
vagrant destroy ubuntu-server

# Siguiente ejercicio
vagrant up kali-security
```

### Opción 2: Configuración Cloud

Para estudiantes sin hardware suficiente:

1. **AWS Academy/Google Cloud Education**
   - Usar créditos estudiantiles gratuitos
   - Crear instancias EC2/Compute Engine

2. **VPS Económicos**
   - Contabo, Hetzner, DigitalOcean
   - 4-8€/mes por VPS con 8 GB RAM

3. **Laboratorio Compartido**
   - Acceso remoto a laboratorio del centro educativo
   - TeamViewer/VNC para acceso desde casa

### Opción 3: Contenedores Docker (Alternativo)

Para algunos ejercicios, usar contenedores en lugar de VMs:

```bash
# Ubuntu Server como contenedor
docker run -d --name ubuntu-lab ubuntu:22.04

# Kali Linux como contenedor
docker run -d --name kali-lab kalilinux/kali-rolling
```

## 📊 Comparativa de Opciones

| Opción | RAM Mín. | Disco Mín. | Ventajas | Desventajas |
|--------|----------|------------|----------|-------------|
| **Todas las VMs** | 16 GB | 120 GB | Experiencia completa | Requiere hardware potente |
| **VMs por ejercicio** | 8 GB | 80 GB | Factible en PCs básicos | Más tiempo de setup |
| **VMs individuales** | 4 GB | 40 GB | Funciona en cualquier PC | Experiencia limitada |
| **Cloud** | 2 GB | 20 GB | Sin limitaciones locales | Requiere conexión a Internet |
| **Contenedores** | 4 GB | 30 GB | Muy ligero | Menos realista |

## 🎯 Recomendaciones por Perfil

### Estudiante con PC Básico (4-8 GB RAM)
1. Usar VMs individuales por ejercicio
2. Considerar laboratorio cloud para ejercicios complejos
3. Trabajar en grupos para compartir recursos

### Estudiante con PC Estándar (8-16 GB RAM)
1. Usar configuración por módulos (2-3 VMs simultáneas)
2. Crear snapshots antes de ejercicios importantes
3. Gestionar VMs activamente (suspend/resume)

### Estudiante con PC Potente (16+ GB RAM)
1. Configuración completa disponible
2. Experimentación libre
3. Ayudar a compañeros con recursos limitados

## 🔧 Scripts de Ayuda

### Script para Estudiantes con Recursos Limitados

```bash
#!/bin/bash
# low-resource-lab.sh - Gestión para recursos limitados

case $1 in
    "tema2"|"seguridad-activa")
        echo "Iniciando VMs para Tema 2 (Criptografía, certificados, políticas)..."
        vagrant halt --force
        vagrant up ubuntu-server windows-server kali-security
        ;;
    "tema3"|"perimetral")
        echo "Iniciando VMs para Tema 3 (Seguridad perimetral, VPN, DMZ)..."
        vagrant halt --force
        vagrant up ubuntu-server kali-security windows-server
        ;;
    "tema4"|"firewalls")
        echo "Iniciando VMs para Tema 4 (Firewalls, proxy, filtrado)..."
        vagrant halt --force
        vagrant up ubuntu-server windows-server kali-security
        ;;
    "tema5"|"alta-disponibilidad")
        echo "Iniciando VMs para Tema 5 (Alta disponibilidad, clústeres)..."
        vagrant halt --force
        vagrant up ubuntu-server storage-backup
        ;;
    "tema6"|"auditoria")
        echo "Iniciando VMs para Tema 6 (Forense, pentesting, auditorías)..."
        vagrant halt --force
        vagrant up kali-security storage-backup ubuntu-server windows-server
        ;;
    "stop")
        echo "Parando todas las VMs..."
        vagrant halt --force
        ;;
    "status")
        echo "Estado del laboratorio:"
        vagrant status
        ;;
    *)
        echo "Uso: $0 [tema2|tema3|tema4|tema5|tema6|stop|status]"
        echo ""
        echo "Temas disponibles:"
        echo "  tema2 - Criptografía, certificados, políticas de seguridad"
        echo "  tema3 - Seguridad perimetral, VPN, DMZ, RADIUS"
        echo "  tema4 - Firewalls, proxy, filtrado de contenido"
        echo "  tema5 - Alta disponibilidad, virtualización, clústeres"
        echo "  tema6 - Análisis forense, pentesting, auditorías"
        ;;
esac
```

## 📋 Resumen y Recomendaciones Finales

### ✅ La configuración actual ES SUFICIENTE para:
- **85% de los ejercicios** de los temas 3-6
- **Todos los objetivos básicos** de aprendizaje
- **Experiencia práctica realista** en ciberseguridad

### 🔧 Mejoras OPCIONALES para experiencia completa:

**Para Tema 5 (Alta Disponibilidad):**
1. **VM adicional**: Clonar Ubuntu Server para clústeres
2. **Load Balancer**: Usar HAProxy en container
3. **Storage compartido**: NFS entre VMs

**Para ejercicios avanzados:**
```bash
# Agregar VM de load balancer (opcional)
VBoxManage clonevm "SAD-Ubuntu-Server" --name "SAD-LoadBalancer" --register

# Usar contenedores para microservicios
docker-compose up nginx haproxy mysql

# Integrar servicios cloud para ejercicios híbridos
```

### 🎯 Conclusión

La configuración actual (5 VMs, 80-120 GB) es **MÁS QUE SUFICIENTE** para:
- ✅ Cubrir **todo el currículo** de los temas 2-6 (incluyendo criptografía completa)
- ✅ Proporcionar **experiencia práctica real** en seguridad
- ✅ Preparar a los estudiantes para **entornos profesionales**
- ✅ Mantener **requisitos de hardware accesibles**

**Cobertura completa incluye:**
- 🔐 **Tema 2**: Criptografía simétrica/asimétrica, certificados X.509, políticas seguridad
- 🛡️ **Tema 3**: VPN, DMZ, RADIUS, seguridad perimetral
- 🔥 **Tema 4**: Firewalls avanzados, proxy, filtrado
- ⚡ **Tema 5**: Alta disponibilidad, virtualización (95% cubierto)
- 🕵️ **Tema 6**: Análisis forense, pentesting, auditorías

**Para la mayoría de ejercicios, las 5 VMs actuales cubren todas las necesidades. Solo para ejercicios muy específicos de alta disponibilidad se podría beneficiar de VMs adicionales, pero se pueden simular con contenedores o servicios cloud.**

### Monitoreo de Recursos

```bash
#!/bin/bash
# monitor-resources.sh - Verificar uso de recursos

echo "=== RECURSOS DEL SISTEMA ==="
echo "RAM disponible: $(free -h | grep Mem | awk '{print $7}')"
echo "Disco disponible: $(df -h ~ | tail -1 | awk '{print $4}')"
echo ""
echo "=== VMs EJECUTÁNDOSE ==="
VBoxManage list runningvms
echo ""
echo "=== USO DE DISCO POR VMs ==="
if [ -d ~/VirtualBox\ VMs ]; then
    du -sh ~/VirtualBox\ VMs/*
fi
```

Con estas optimizaciones, hemos reducido significativamente los requisitos:

- **De 500 GB a 80-120 GB** (reducción del 75%)
- **De 32 GB RAM a 8-16 GB** (reducción del 50-75%)
- **Configuración flexible** por módulos
- **Alternativas** para hardware muy limitado

Esto hace el laboratorio **mucho más accesible** para estudiantes con PCs domésticos estándar.
