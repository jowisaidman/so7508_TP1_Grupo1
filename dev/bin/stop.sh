#!/bin/bash
source ./validaciones.sh
source ./helpers.sh

isRunning "process.sh"

if [ $? -eq 0 ]; then
    killProcess "process.sh"
    logInfo "Stop" "El proceso fue finalizado de manera exitosa" "../conf/logs/stop.log"
else
  logAlerta "Stop" "No se esta corriendo ningun proceso, no es posible frenarlos"   "../conf/logs/stop.log"
  return 1
fi
