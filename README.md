# Primer Trabajo Práctico Sistemas Operativos

Para comenzar a utilizar el servicio, debe ingresar a la carpeta entrega.
Luego seguir los pasos explicados a continuacion:

## Instalacion
unzip paquete_instalacion.zip<br />
bash install.sh

La instalacion crea una estructur donde trabajara el procesos. En la carpetade ejectuables(bin) se encontraran los archivos ejecutables necesarios para la ejecucion del servicio. 

Una vez instalado todo debe dirijirse a la carpeta de los ejecutables (bin en su defecto), y alli ejecutar la inicializacion.

## Inicializacion
Este proceso se ejecuta con el comando:<br />
. initialize.sh

Una vez que la inicializacion fue correcta, el proceso se inicia.

## stop
Comando para frenar la ejecucion de proceso.<br />
. stop.sh

## start
Comando para iniciar el proceso, si fue parado con anterioridad.<br />
. start.sh

## Logs
Para ver los Logs de los procesos, debe dirigirse a la carpeta(desde la raiz) ***conf/logs/***