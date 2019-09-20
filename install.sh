#!/bin/bash

main () {
    echo -e "Bienvenido, la instalacion a comenzado"
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

ask_subdirectories () {
    read -p "Indique el nombre para el directorio de ejecutables ($s_executable): " s_executable
    read -p "Indique el nombre para el directorio de archivos maestros ($s_master): " s_master
    read -p "Indique el nombre del directorio de los archivos externos a procesar ($s_extern): " s_extern
    read -p "Indique el nombre del directorio de archivos aceptados para procesar ($s_temp): " s_temp
    read -p "Indique el nombre del directorio de los archivos rechazados ($s_rejected): " s_rejected
    read -p "Indique el nombre del directorio de los archivos procesados ($s_processed): " s_processed
    read -p "Indique el nombre del directorio de los archivos de salida ($s_exit): " s_exit
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