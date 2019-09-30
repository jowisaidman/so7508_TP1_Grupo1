#!/bin/bash
source ./validaciones.sh
source ./helpers.sh

isRunning "process.sh"   

if [ $? -ne 0 ]; then
  logInfo "Start" "Se Corre el proceso correctamente" "start.log"
  bash ./process.sh
else
  logInfo "start" "No se puede correr el proceso, ya que hay otro corriendo" "start.log"
  return 1
fi