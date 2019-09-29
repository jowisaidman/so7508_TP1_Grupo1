#!/bin/bash
source ./validaciones.sh

exec 6>&1 #Guardo el stdout default
exec >> "stop.log"


function killProcess() {
  ps -ef | grep ".*$1.*" | grep -v grep | awk '{print $2}' | xargs kill
}

isRunning "process.sh"

if [ $? -eq 0 ]; then
    killProcess "process.sh"
    echo "$(date +'%d/%m/%Y %T') El proceso fue finalizado de manera exitosa"
else
  echo "$(date +'%d/%m/%Y %T') No se esta corriendo ningun proceso, no es posible frenarlos"  
  exec 1>&6 6>&-
  return 1
fi
exec 1>&6 6>&-
