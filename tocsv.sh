#!/bin/bash
RUTA="/home/mauro/servel/Victoria.txt"
CSV="/home/mauro/servel/victoria.csv"
rm -f $CSV
touch $CSV
while read LINEA
do
        NOMBRE=$(echo $LINEA | awk '{ split($0, a, /[0-9]/); print a[1]}')
        RUT=$(echo $LINEA | awk '{ if( match($0, /[0-9\.\-]+/, a) > 0 ) { print a[0] }}')
        GENERO=$(echo $LINEA | awk '{ if( match($0, /VAR|MUJ/, a) > 0 ) { print a[0] }}')
        MESA=$(echo $LINEA | awk '{ split($0, a, /\ VAR\ |\ MUJ\ /); print a[2]}' | sed 's/\ +$//' | awk '{ if( match($0, /[0-9\ ]+[A-Z]$/, a) > 0 ) { print a[0] }}')
        DIRECCION_COMUNA=$(echo "$LINEA" | awk '{ split($0, a, /\ VAR\ |\ MUJ\ /); print a[2]}' | sed 's/\ +$//' | awk '{ split($0, a, /[0-9\ ]+[A-Z]$/); print a[1]}' | awk '{ split($0, a, /[0-9]+$/); print a[1]}')
        COMUNA=$(echo "$DIRECCION_COMUNA" | awk '{if( match($0, /[\ ]{2,}[A-Z]+$/, a) > 0 ) { print a[0] }}' | sed 's/[\ ]*//')
        DIRECCION=$(echo "$DIRECCION_COMUNA" | awk '{ split($0, a, "'$COMUNA'"); print a[1]}')
        echo $NOMBRE';'$RUT';'$GENERO';'$COMUNA';'$DIRECCION';'$MESA >> $CSV
done < $RUTA