#!/bin/bash

exec 6>&1 #Guardo el stdout default
exec > "stop.log"
ps -ef | grep ".*process.sh" | grep -v grep

if [ $? -eq 0 ]; then
  ps -ef | grep ".*process.sh" | grep -v grep | awk '{print $2}' | xargs kill
  exec 1>&6 6>&-
  echo "El proceso fue finalizado de manera exitosa"
else
  exec 1>&6 6>&-
  echo "No se esta corriendo ningun proceso, no es posible frenarlos"  
  exit
fi
