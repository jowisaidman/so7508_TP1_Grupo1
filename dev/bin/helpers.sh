#! /bin/bash

#Parametros:
#1) Nombre del proceso/archivo desde donde se loguea
#2) Mensaje
#3) Salida (por defecto es la terminal)
logInfo() {
    output="/dev/tty"
    if [[ ! -z "$3" ]]; then
        output="$3"
        if [[ ! -f "$output" ]]; then
            echo > $output
        fi
    fi
    echo `date` - $USERNAME - $1 - INF - $2 >> "$output"
}