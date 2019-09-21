#!/bin/bash
source ./validaciones.sh

exec 6>&1 #Guardo el stdout default
exec >> "stop.log"

isRunning "process.sh"

if [ $? -eq 0 ]; then
  ps -ef | grep ".*process.sh" | grep -v grep | awk '{print $2}' | xargs kill
  echo "$(date +'%d/%m/%Y %T') El proceso fue finalizado de manera exitosa"
else
  echo "$(date +'%d/%m/%Y %T') No se esta corriendo ningun proceso, no es posible frenarlos"  
  exit
fi
