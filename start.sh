#!/bin/bash

CORRIENDO=0

exec 6>&1 #Guardo el stdout default
exec > "stop.log"
ps -ef | grep ".*process.sh" | grep -v grep   

if [ $? -ne 0 ]; then
  exec 1>&6 6>&-
  echo "Se Corre el proceso correctamente"
  bash ./process.sh
else
  exec 1>&6 6>&-
  echo "No se puede correr el roceso, ya que hay otro corriendo"
  exit
fi


