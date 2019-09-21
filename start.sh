#!/bin/bash
source ./validaciones.sh

exec 6>&1 #Guardo el stdout default
exec >> "start.log"

isRunning "process.sh"   

if [ $? -ne 0 ]; then
  echo "$(date +'%d/%m/%Y %T') Se Corre el proceso correctamente"
  bash ./process.sh
else
  echo "$(date +'%d/%m/%Y %T') No se puede correr el proceso, ya que hay otro corriendo"
  exit
fi


