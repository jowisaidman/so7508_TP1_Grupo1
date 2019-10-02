#!/bin/bash
source ./helpers.sh

if [ -z $init ]; then
  logAlerta "Start" "No se puede correr ya que el sistema no fue inicializado"
  logAlerta "Start" "No se puede correr ya que el sistema no fue inicializado" "../conf/logs/start.log"
  return
fi

isRunning "process.sh"   

if [ $? -ne 0 ]; then
  logInfo "Start" "Se Corre el proceso correctamente" "../conf/logs/start.log"
  bash ./process.sh
else
  logAlerta "Start" "No se puede correr el proceso, ya que hay otro corriendo" "../conf/logs/start.log"
  return 1
fi
