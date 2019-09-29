#!/bin/bash
source ./validaciones.sh

echo $$

exec 6>&1 #Guardo el stdout default
exec >> "start.log"

echo $$

isRunning "process.sh"   

if [ $? -ne 0 ]; then
  echo "$(date +'%d/%m/%Y %T') Se Corre el proceso correctamente"
  bash ./process.sh
else
  echo "$(date +'%d/%m/%Y %T') No se puede correr el proceso, ya que hay otro corriendo"
  exec 1>&6 6>&-
  return 1
fi
exec 1>&6 6>&-

