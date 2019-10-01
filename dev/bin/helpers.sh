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

#Parametros:
#1) Nombre del proceso/archivo desde donde se loguea
#2) Mensaje
#3) Salida (por defecto es la terminal)
logAlerta() {
    output="/dev/tty"
    if [[ ! -z "$3" ]]; then
        output="$3"
        if [[ ! -f "$output" ]]; then
            echo > $output
        fi
    fi
    echo `date` - $USERNAME - $1 - ALE - $2 >> "$output"
}

#Funcion para matar el proceso pasado por parametro
function killProcess() {
  ps -ef | grep ".*$1.*" | grep -v grep | awk '{print $2}' | xargs kill
}