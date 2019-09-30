#!/bin/bash
source ./validaciones.sh
source ./helpers.sh

isRunning "process.sh"   

if [ -z $init ]; then
  logInfo "Start" "No se puede correr ya que el sistema no fue inicializado"
  logInfo "Start" "No se puede correr ya que el sistema no fue inicializado" "../conf/logs/start.log"
  return
fi

if [ $? -ne 0 ]; then
  logInfo "Start" "Se Corre el proceso correctamente" "../conf/logs/start.log"
  # bash ./process.sh
else
  logInfo "start" "No se puede correr el proceso, ya que hay otro corriendo" "../conf/logs/start.log"
  return 1
fi