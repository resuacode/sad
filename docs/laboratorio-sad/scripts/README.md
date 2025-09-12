# Scripts de Automatización del Laboratorio

Esta carpeta contiene scripts y herramientas auxiliares para facilitar la gestión del laboratorio SAD.

## 📁 Contenido Disponible

### Scripts de Utilidad
👉 **[Ver Scripts de Utilidad](utilidades.md)** - Scripts completos para gestión del laboratorio

**Incluye:**
- 🔍 **Scripts de validación**: Verificar conectividad y servicios
- ⚙️ **Scripts de configuración**: Setup automático para estudiantes
- 💾 **Scripts de backup**: Gestión de trabajo y configuraciones
- 📊 **Scripts de monitoreo**: Supervisión de recursos del sistema
- 🔄 **Scripts de reset**: Restaurar laboratorio a estado inicial

### Scripts por Categoría

**Validación y Diagnóstico:**
- `check_network.sh` - Verificar conectividad entre VMs
- `check_services.sh` - Validar servicios en funcionamiento
- `monitor_resources.sh` - Supervisar uso de recursos

**Gestión del Laboratorio:**
- `setup_student_env.sh` - Configuración inicial para estudiantes
- `low_resource_lab.sh` - Gestión para hardware limitado
- `reset_lab.sh` - Reiniciar laboratorio a estado inicial
- `backup_work.sh` - Crear backup del trabajo del estudiante

## 🚀 Uso Rápido

### Para Estudiantes
```bash
# Configurar entorno inicial
./setup_student_env.sh

# Verificar que todo funciona
./check_network.sh
./check_services.sh

# Gestión de recursos limitados
./low_resource_lab.sh tema2  # Solo VMs para Tema 2
```

### Para Instructores
```bash
# Monitorear recursos
./monitor_resources.sh

# Reset completo del laboratorio
./reset_lab.sh

# Backup masivo de trabajos
./backup_work.sh
```

## 📋 Plantillas y Configuraciones

- **Plantillas de informes** en `../documentacion/`
- **Configuraciones de red** optimizadas
- **Archivos de ejemplo** para ejercicios
- **Scripts de provisioning** para Vagrant

## 🔗 Enlaces Relacionados

- 📚 [Guía del Estudiante](../documentacion/guia-estudiante.md)
- 🔧 [Troubleshooting](../documentacion/troubleshooting.md)
- 💾 [Recursos Limitados](../documentacion/recursos-limitados.md)
- 🎯 [Ejercicios Prácticos](../documentacion/ejercicios-practicos.md)