#! /bin/bash
source ./helpers.sh

logInfo "Proceso" "Id proceso: $$"
logInfo "Proceso" "Id proceso: $$" "initialize.log"

function readAndExport() {
  declare -i errores=0
  while IFS=, read -r a b ; do
      evaluateDirectory $b
      if [ $? -eq "1" ];
        then return 1
      fi
      export $a=$b
      logInfo "Variables Ambiente" "La variable '$a' fue setteada con valor '$b'" "conf/logs/initialize.log"
  done < $1
}

function evaluateDirectory() {
  if [ ! -z $1 ]; 
    then
      if [ -d $1/ ];
      then
      logInfo "Evaluando directorio" "Existe el directorio $1" "conf/logs/initialize.log"
      else
      logAlerta "Evaluando directorio" "No existe el directorio $1, volver a correr el instalador para arreglar el problema"
      logAlerta "Evaluando directorio" "No existe el directorio $1, volver a correr el instalador para arreglar el problema" "conf/logs/initialize.log"
      return 1
      fi
    else
      logAlerta "Evaluando directorio" "Variable no setteada" "conf/logs/initialize.log"
      return 1
  fi 
}

function evaluateDirectories() {
  declare -i errores=0
  evaluateDirectory $bin
  if [ $? -eq "1" ];
    then errores=$errores+1
  fi
  evaluateDirectory $maestros
  if [ $? -eq "1" ];
    then errores=$errores+1
  fi
  evaluateDirectory $novedades
  if [ $? -eq "1" ];
    then errores=$errores+1
  fi
  evaluateDirectory $aceptados
  if [ $? -eq "1" ];
    then errores=$errores+1
  fi
  evaluateDirectory $rechazados
  if [ $? -eq "1" ];
    then errores=$errores+1
  fi
  evaluateDirectory $procesados
  if [ $? -eq "1" ];
    then errores=$errores+1
  fi
  evaluateDirectory $salida
  if [ $? -eq "1" ];
    then errores=$errores+1
  fi
  evaluateDirectory $conf
  if [ $? -eq "1" ];
    then errores=$errores+1
  fi
  return $errores
}

function evaluatePermisionsAndFixit() {
  for i in $(ls -C1 | grep "^[^.]*.sh")
  do
  if [ -w $i ] && [ -x $i ];
  then logInfo "Permisos" "El archivo $1 tiene los permisos correctos" "../conf/logs/initialize.log"
  else $(chmod +wx $i)
  fi
  done
}

cd ..
logInfo "Comienzo" "Me paro en la raiz" "conf/logs/initialize.log"

if [ -z $init ];
  then 
    #Leo el archivo y setteo variables de entorno
    readAndExport conf/config.txt

    if [ $? -eq "0" ];
      then
        logInfo "Directories and export" "Las variables se iniciaron correctamente y los directorios estan todos correctos" "conf/logs/initialize.log"
      else
        logAlerta "Directories and export" "El sistema no fue inicializado, se encontraron errores con los directorios, observar el archivo conf/logs/initialize.log"
        cd $bin/ #Vuelvo a la carpeta de ejecutables
        return 1
    fi
    cd $bin/ #Vuelvo a la carpeta de ejecutables
    evaluatePermisionsAndFixit #Evaluo los permisos y los arreglo
    logInfo "Permisos" "Los permisos fueron todos setteados correctamente" "../conf/logs/initialize.log"
    logInfo "Inicializacion" "El sistema se inicializo correctamente" "../conf/logs/initialize.log"
    export init="1" #Setteo que la inicializacion fue correcta
    . start.sh #Ejecuto el proceso
  else
    evaluateDirectories
    if [ $? -eq "0" ];
    then
      logInfo "Directories" "El sistema ya estaba inicializado y los directorios estan todos correctos" "conf/logs/initialize.log"
    else
      logInfo "Directories" "El sistema ya estaba inicializado y se encontraron errores con los directorios, observar el archivo conf/logs/initialize.log, se reinicializa el sistema"
      cd $bin/
      export init=
      . initialize.sh #Se reinicializa
      return 1
    fi
    cd $bin/
    evaluatePermisionsAndFixit
    logInfo "Permisos" "Los permisos fueron todos setteados correctamente" "../conf/logs/initialize.log"
    logInfo "Inicializacion" "El sistema esta inicializado correctamente"
fi