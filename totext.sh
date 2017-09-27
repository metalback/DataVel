#!/bin/bash
echo 'Procesando Documentos PDF a Texto'
for PDF in $(find .pdf ./padron/* | grep pdf); do
        NAME=${PDF%\.pdf}".txt"
        echo $PDF' a '$NAME
        pdftotext -layout $PDF $NAME
done