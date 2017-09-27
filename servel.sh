#!/bin/bash
#
# Script que automatizara las tareas de recoleccion, parseo y generacion de script SQL 
# de los documentos del padron electoral
. ./conf.ini 2> /dev/null # ignore warning
# Obtener XML si no usar el existente
wget --continue ${RUTA_XML} -O ${XML_LOCAL_NAME}
# Ejecutar Script para generar URL de descarga de PDF
python servel.py
sh padron.sh
# # Ejecutar Script para pasar de PDF a Texto
sh totext.sh
# # Ejecutar Script para pasar de Texto a CSV
# sh tocsv.sh
# # Ejecutar Sctipt para pasar de Texto a Script SQL
# sh tosql.sh