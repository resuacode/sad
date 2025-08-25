#!/bin/bash

# Script para eliminar automáticamente las carpetas problemáticas
# Se puede ejecutar periódicamente o manualmente

CARPETAS_PROBLEMATICAS=(
    "tema-01-legislacion"
    "tema-02-identificacion-autenticacion" 
    "tema-03-control-acceso"
    "tema-04-seguridad-fisica"
    "tema-05-criptografia"
    "tema-06-seguridad-redes"
    "tema-07-alta-disponibilidad"
    "tema-08-backup-recuperacion"
)

echo "🔍 Verificando carpetas problemáticas..."

ENCONTRADAS=0
for carpeta in "${CARPETAS_PROBLEMATICAS[@]}"; do
    if [ -d "docs/$carpeta" ]; then
        echo "❌ Encontrada carpeta problemática: docs/$carpeta"
        rm -rf "docs/$carpeta"
        echo "✅ Eliminada: docs/$carpeta"
        ENCONTRADAS=$((ENCONTRADAS + 1))
    fi
done

if [ $ENCONTRADAS -eq 0 ]; then
    echo "✅ No se encontraron carpetas problemáticas"
else
    echo "🧹 Eliminadas $ENCONTRADAS carpetas problemáticas"
    echo "🧹 Limpiando caché de Docusaurus..."
    npm run clear > /dev/null 2>&1
fi
