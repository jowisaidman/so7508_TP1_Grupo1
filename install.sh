#!/bin/bash

main () {
    echo "Bienvenido, la instalacion a comenzado"
    installation_accepted="NO"
    assign_default_subdirectories
    while [ "$installation_accepted" != "SI" ] 
    do
        ask_subdirectories "$s_executable" "$s_master" "$s_extern" "$s_temp" "$s_rejected" "$s_processed" "$s_exit"
        print_details "$s_executable" "$s_master" "$s_extern" "$s_temp" "$s_rejected" "$s_processed" "$s_exit"
        read -p "¿Confirma la instalacion? (SI-NO): " installation_accepted
    done
}

assign_default_subdirectories () {
    grupo="GRUPO01"
    s_executable="bin"
    s_master="maestros"
    s_extern="nuevos"
    s_temp="temp"
    s_rejected="rechazados"
    s_processed="procesados"
    s_exit="salida"
}

#la idea es pasar el parametro con su pregunta y si se toca enter que se
#quede el valor por defecto de la variable
#falta validar que no ponga un directorio que ya puso (una lista con constantes)
validate_subdirectorie () {
    zero=0
    read -p "$1" value
    lenght=${#value}
    if [ "$value" -eq "$zero" ]
    then
        echo El largo de $string es $lenght
    fi
}

#entre parentesis es el valor por defecto, si se toca enter queda el valor por defecto
ask_subdirectories () {
    zero=0
    echo Para dejar el valor mostrado entre parentesis precione enter

    read -p "Indique el nombre para el directorio de ejecutables ($s_executable): " temp_var
    lenght=${#temp_var}
    if [ "$lenght" -eq "$zero" ]
    then
        echo El valor no cambio
    else 
        s_executable=$temp_var
    fi    

    read -p "Indique el nombre para el directorio de archivos maestros ($s_master): " temp_var
    lenght=${#temp_var}
    if [ "$lenght" -eq "$zero" ]
    then
        echo El valor no cambio
    else 
        s_master=$temp_var
    fi 

    read -p "Indique el nombre del directorio de los archivos externos a procesar ($s_extern): " temp_var
    lenght=${#temp_var}
    if [ "$lenght" -eq "$zero" ]
    then
        echo El valor no cambio
    else 
        s_extern=$temp_var
    fi 

    read -p "Indique el nombre del directorio de archivos aceptados para procesar ($s_temp): " temp_var
    lenght=${#temp_var}
    if [ "$lenght" -eq "$zero" ]
    then
        echo El valor no cambio
    else 
        ss_temp=$temp_var
    fi 

    read -p "Indique el nombre del directorio de los archivos rechazados ($s_rejected): " temp_var
    lenght=${#temp_var}
    if [ "$lenght" -eq "$zero" ]
    then
        echo El valor no cambio
    else 
        s_rejected=$temp_var
    fi 

    read -p "Indique el nombre del directorio de los archivos procesados ($s_processed): " temp_var
    lenght=${#temp_var}
    if [ "$lenght" -eq "$zero" ]
    then
        echo El valor no cambio
    else 
        s_processed=$temp_var
    fi 

    read -p "Indique el nombre del directorio de los archivos de salida ($s_exit): " temp_var
    lenght=${#temp_var}
    if [ "$lenght" -eq "$zero" ]
    then
        echo El valor no cambio
    else 
        s_exit=$temp_var
    fi 
}

print_details () {
    echo 
    echo TP SO7508 2º Cuatrimestre 2019. Copyright © Grupo 01
    echo Directorio padre: $grupo
    echo Directorio de configuración:  /conf
    echo Archivos de log: /conf/log
    echo Libreria de ejecutables: /$s_executable
    echo Repositorio de maestros: /$s_master
    echo Directorio para las novedades… /$s_extern
    echo Directorio para los archivos aceptados… /$s_temp
    echo Directorio para los archivos rechazados… /$s_rejected
    echo Directorio para Archivos procesados… /$s_processed
    echo Directorio para los archivos de salida… /$s_exit
    echo
    echo ATENCION: Los logs del sistema se depositan en /conf/log
    echo
    echo Estado de la instalacion: LISTA
}

main