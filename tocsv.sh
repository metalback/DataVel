#!/bin/bash
echo 'Procesando Documentos PDF a Texto'
IFS=$'\n' # Se setea de esta manera para que no divida los nombres separados por espacio
for PDF in $(find ./padron/ | grep ".pdf"); do
        NAME=${PDF%\.pdf}".csv"
        echo $PDF' a '$NAME
        pdftotext -layout $PDF $NAME    
        # sed -i '/ELECCIONES PRESIDENCIAL/ {N;N;N;d;}' $NAME
        # sed -i 's/\s\{3,\}/;/g' $NAME
done
unset IFS