# Guía para agregar contenido al sitio de SAD

## 📁 Estructura de carpetas

El sitio está organizado por temas dentro de la carpeta `docs/`:

```
docs/
├── intro.mdx                     # Página principal de la documentación
├── tema-01-legislacion/          # Tema 1: Legislación
├── tema-02-identificacion-autenticacion/  # Tema 2: Identificación y Autenticación
├── tema-03-control-acceso/       # Tema 3: Control de Acceso
├── tema-04-seguridad-fisica/     # Tema 4: Seguridad Física
├── tema-05-criptografia/         # Tema 5: Criptografía
├── tema-06-seguridad-redes/      # Tema 6: Seguridad en Redes
├── tema-07-alta-disponibilidad/  # Tema 7: Alta Disponibilidad
└── tema-08-backup-recuperacion/  # Tema 8: Backup y Recuperación
```

## ✍️ Cómo agregar contenido

### 1. Crear un nuevo apartado en un tema

Para agregar un nuevo apartado a un tema existente, simplemente crea un archivo `.mdx` en la carpeta del tema:

```bash
# Ejemplo: Agregar "Controles de Acceso" al Tema 3
touch docs/tema-03-control-acceso/02-controles-acceso.mdx
```

**Contenido del archivo:**
```markdown
---
sidebar_position: 2
title: Controles de Acceso
---

# Controles de Acceso

Tu contenido aquí...
```

### 2. Crear subapartados con subcarpetas

Para organizar contenido complejo, puedes crear subcarpetas:

```bash
# Crear subcarpeta
mkdir docs/tema-03-control-acceso/modelos-acceso

# Agregar archivo índice
touch docs/tema-03-control-acceso/modelos-acceso/index.mdx

# Agregar subapartados
touch docs/tema-03-control-acceso/modelos-acceso/01-dac.mdx
touch docs/tema-03-control-acceso/modelos-acceso/02-mac.mdx
touch docs/tema-03-control-acceso/modelos-acceso/03-rbac.mdx
```

### 3. Configurar el frontmatter

Cada archivo debe tener frontmatter YAML al inicio:

```yaml
---
sidebar_position: 1    # Orden en la sidebar (número)
title: Título del apartado  # Título que aparece en la sidebar
---
```

## 🚀 Funcionalidades automáticas

### Sidebar autogenerada
- La sidebar izquierda se genera automáticamente basándose en los archivos de cada tema
- Solo muestra los apartados del tema actual
- Se ordena según `sidebar_position`

### Navegación superior
- El menú "Temas" en la barra superior da acceso directo a cada tema
- Cada enlace lleva al primer apartado de cada tema

### Enlaces automáticos
- Los enlaces entre páginas se generan automáticamente
- Formato: `/docs/tema-XX-nombre/apartado`

## 📝 Formato de archivos

### Extensiones soportadas
- `.md` - Markdown estándar
- `.mdx` - Markdown con componentes React

### Sintaxis recomendada

#### Títulos
```markdown
# Título principal (H1)
## Sección (H2)
### Subsección (H3)
#### Subsubsección (H4)
```

#### Código
```markdown
\`\`\`bash
# Código de bash
comando --opcion valor
\`\`\`

\`\`\`python
# Código de Python
def funcion():
    return "Hola mundo"
\`\`\`
```

#### Alertas y cajas
```markdown
:::tip Consejo
Esto es un consejo útil
:::

:::warning Advertencia
Esto es una advertencia
:::

:::danger Peligro
Esto es información crítica
:::
```

#### Tablas
```markdown
| Columna 1 | Columna 2 | Columna 3 |
|-----------|-----------|-----------|
| Dato 1    | Dato 2    | Dato 3    |
| Dato 4    | Dato 5    | Dato 6    |
```

## 🔧 Comandos útiles

### Desarrollo
```bash
# Iniciar servidor de desarrollo
npm run start

# Limpiar caché
npm run clear

# Verificar enlaces rotos
npm run build
```

### Producción
```bash
# Construir sitio para producción
npm run build

# Servir sitio construido localmente
npm run serve

# Desplegar a GitHub Pages
npm run deploy
```

## 📋 Ejemplos prácticos

### Ejemplo 1: Agregar ejercicios prácticos
```markdown
---
sidebar_position: 5
title: Ejercicios Prácticos
---

# Ejercicios del Tema 2

## Ejercicio 1: Configuración de MFA

### Objetivo
Configurar autenticación multifactor en un servidor web.

### Pasos
1. Instalar Google Authenticator
2. Configurar TOTP
3. Probar el acceso

### Solución
\`\`\`bash
# Comandos de la solución
\`\`\`
```

### Ejemplo 2: Agregar referencias
```markdown
## Referencias

- [RFC 6238 - TOTP](https://tools.ietf.org/html/rfc6238)
- [NIST SP 800-63B](https://pages.nist.gov/800-63-3/sp800-63b.html)
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
```

## ❗ Importante

1. **Nombrado de archivos**: Usa nombres descriptivos con prefijos numéricos para el orden
2. **Enlaces**: Verifica que todos los enlaces internos funcionen
3. **Imágenes**: Coloca las imágenes en `static/img/` y referencialas con `/img/nombre.png`
4. **Construcción**: Siempre ejecuta `npm run build` para verificar que no hay errores

¡La estructura está lista para que añadas todo el contenido del módulo!
