#!/bin/bash

# Script para monitorear la creación de carpetas problemáticas
# Ejecutar en background: ./monitor-carpetas.sh &

WATCH_DIR="/home/dani/sad/docs"
LOG_FILE="/home/dani/sad/carpetas-creadas.log"

echo "$(date): Iniciando monitoreo de $WATCH_DIR" >> $LOG_FILE

# Monitorear cambios en la carpeta docs
inotifywait -m -r -e create,moved_to "$WATCH_DIR" --format '%T %w%f %e' --timefmt '%Y-%m-%d %H:%M:%S' |
while read timestamp file event; do
    # Verificar si es una de las carpetas problemáticas
    if echo "$file" | grep -E "(tema-0[1-8]-(legislacion|identificacion|control-acceso|seguridad-fisica|criptografia|seguridad-redes|alta-disponibilidad|backup-recuperacion))"; then
        echo "$timestamp: CARPETA PROBLEMÁTICA CREADA: $file ($event)" >> $LOG_FILE
        echo "$timestamp: PROCESO QUE LA CREÓ:" >> $LOG_FILE
        ps aux | grep -E "(docusaurus|node|npm)" >> $LOG_FILE
        echo "----------------------------------------" >> $LOG_FILE
    fi
done
