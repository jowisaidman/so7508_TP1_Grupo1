#! /bin/bash
source ./helpers.sh

logInfo "Proceso" $$

exec 6>&1 #Guardo el stdout default
exec > "initialize.log"

logInfo "Proceso" $$

function readAndExport() {
  declare -i errores=0
  while IFS=, read -r a b ; do
      evaluateDirectory $b
      if [ $? -eq "1" ];
        then return 1
      fi
      export $a=$b
      logInfo $$ "La variable '$a' fue setteada con valor '$b'"
  done < $1
}

function evaluateDirectory() {
  if [ ! -z $1 ]; 
    then
      if [ -d $1/ ];
      then
      logInfo $$ "Existe el directorio $1"
      else
      logInfo $$ "No existe  el directorio $1, explicar"
      return 1
      fi
    else
      logInfo $$ "Variable no setteada"
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
  then logInfo "Permisos" "El archivo $1 tiene los permisos correctos"
  else $(chmod +wx $i)
  fi
  done
}

cd ..
logInfo "Comienzo" "Me paro en la raiz"

if [ -z $init ];
  then 
    #Leo el archivo y setteo variables de entorno
    readAndExport conf/config.txt

    if [ $? -eq "0" ];
      then
        logInfo "Directories and export" "Las variables se iniciaron correctamente y los directorios estan todos correctos"
      else
        logInfo "Directories and export" "El sistema no fue inicializado, se encontraron errores con los directorios, observar el archivo initialize.log"
        cd $bin/ #Vuelvo a la carpeta de ejecutables
        exec 1>&6 6>&- #Retorno el outuput a la terminal
        return 1
    fi
    cd $bin/ #Vuelvo a la carpeta de ejecutables
    evaluatePermisionsAndFixit #Evaluo los permisos y los arreglo
    logInfo "Permisos" "Los permisos fueron todos setteados correctamente"
    exec 1>&6 6>&- #Retorno el outuput a la terminal
    echo "El sistema se inicializo correctamente"
    export init="1" #Setteo que la inicializacion fue correcta
    . start.sh #Ejecuto el proceso
  else
    evaluateDirectories
    if [ $? -eq "0" ];
    then
      logInfo "Directories" "El sistema ya estaba incializado y los directorios estan todos correctos"
    else
      logInfo "Directories" "El sistema ya estaba incializado y se encontraron errores con los directorios, observar el archivo initialize.log, se reinicializa el sistema"
      cd $bin/
      export init=
      . initialize.sh
      exec 1>&6 6>&-
      return 1
    fi
    cd $bin/
    evaluatePermisionsAndFixit
    logInfo "Permisos" "Los permisos fueron todos setteados correctamente"
    exec 1>&6 6>&-
    echo "El sistema esta inicializado correctamente"
fi