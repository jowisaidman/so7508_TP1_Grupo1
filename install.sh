#!/bin/bash
# Ask the user for their name
grupo="GRUPO01"
echo Bienvenido, la installacion a comenzado!
read -p "Indique el nombre para el directorio de ejecutables: " s_executable
read -p "Indique el nombre para el directorio de archivos maestros: " s_master
read -p "Indique el nombre del directorio de los archivos externos a procesar: " s_extern
read -p "Indique el nombre del directorio de archivos aceptados para procesar: " s_temp
read -p "Indique el nombre del directorio de los archivos rechazados: " s_rejected
read -p "Indique el nombre del directorio de los archivos procesados: " s_processed
read -p "Indique el nombre del directorio de los archivos de salida: " s_exit
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
read -p "¿Confirma la instalacion? (SI-NO):" instalation_accepted 