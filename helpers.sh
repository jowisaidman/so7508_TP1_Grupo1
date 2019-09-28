#! /bin/bash

#Parametros:
#1) Nombre del proceso/archivo desde donde se loguea
#2) Mensaje
logInfo() {
    echo `date` - $USERNAME - $1 - INF - $2
}