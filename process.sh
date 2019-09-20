#!/bin/bash

exec > EXIT_LOG.log #redirecciono salida estandar
#exec 2>stdoin #redirecciono entrada estandar
echo $BASHPID

(
declare -i count=1
declare -i increment=1
while true; do
    echo "Actual count is: $count"
    #Proceso info
    count=$((count + increment))
    sleep 1
done
)& #Lo mando a bg (background) -> pasa a ser un proceso deamon
