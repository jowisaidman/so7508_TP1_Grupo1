#!/bin/bash

repair_installation=$1

main () {
    if [ -d "GRUPO01/" ]; then
        check_installation
        return
    fi
    show_ini 
    assign_default_subdirectories
    create_initial_directories "$grupo" "$s_conf"
    reapeat_directory="NO"
    installation_accepted="NO"
    declare -a directories_array=("$s_executable" "$s_master" "$s_extern" "$s_temp" "$s_rejected" "$s_processed" "$s_exit" "$s_conf" "$grupo")
    while [ "$installation_accepted" != "SI" ] || [ "$reapeat_directory" != "NO" ] #este ciclo deberia ir en una funcion
    do 
        reapeat_directory="NO"
        ask_subdirectories "$s_executable" "$s_master" "$s_extern" "$s_temp" "$s_rejected" "$s_processed" "$s_exit"
        directories_array=("$s_executable" "$s_master" "$s_extern" "$s_temp" "$s_rejected" "$s_processed" "$s_exit" "$s_conf" "$grupo")
        print_details "$directories_array"
        read -p "¿Confirma la instalacion? (SI-NO): " installation_accepted
        validate_subdirectories "$directories_array" "$reapeat_directory"
    done
    new_directories=("$s_executable" "$s_master" "$s_extern" "$s_temp" "$s_rejected" "$s_processed" "$s_exit")
    save_configuration "$new_directories"
    create_directories "${new_directories[@]}"
    unzip_files
    move_files "$s_executable"
    echo "La instalacion finalizo correctamente"
}

show_ini () {
    echo "Bienvenido, la instalacion a comenzado!"
    echo "Debera seleccionar los nombres de los directorios, debe tener en cuenta que NO se puede: "
    echo "    -Utilizar nombres repetidos
    -Utilizar nombres de palabras reservadas"
    echo ""
    sleep 1    
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
    s_conf="conf"
}

save_configuration () {
    echo "Guardando configuracion de los directorios"
    for j in "${!new_directories[@]}"; do
        if [ ! -e "GRUPO01/conf/conf.txt" ]; then
            echo ${new_directories[j]} >> "GRUPO01/conf/config.txt"
        else
            echo ${new_directories[j]} > "GRUPO01/conf/config.txt"
        fi
    done
    echo "conf" >> "GRUPO01/conf/config.txt"
    echo "Configuracion guardada"
    echo ""    
    sleep 1
}

validate_subdirectories () {
    for i in "${!directories_array[@]}"; do
        for j in "${!directories_array[@]}"; do
            if [ "${directories_array[i]}" == "${directories_array[j]}" ] && [ "$i" != "$j" ]; then
                echo
                echo "ERROR: El directorio (${directories_array[j]}) esta duplicado!"
                echo
                reapeat_directory="SI"
                return
            fi
        done
    done
    echo ""
}

#entre parentesis es el valor por defecto, si se toca enter queda el valor por defecto
ask_subdirectories () {
    zero=0
    echo "Paso 1: Seleccionar directorios"
    echo "ATENCION: Para dejar el valor mostrado entre parentesis presione enter"
    read -p "Indique el nombre para el directorio de ejecutables ($s_executable): " temp_var
    lenght=${#temp_var}
    if [ "$lenght" != "$zero" ]; then
        s_executable=$temp_var
    fi    

    read -p "Indique el nombre para el directorio de archivos maestros ($s_master): " temp_var
    lenght=${#temp_var}
    if [ "$lenght" != "$zero" ]; then
        s_master=$temp_var
    fi 

    read -p "Indique el nombre del directorio de los archivos externos a procesar ($s_extern): " temp_var
    lenght=${#temp_var}
    if [ "$lenght" != "$zero" ]; then
        s_extern=$temp_var
    fi 

    read -p "Indique el nombre del directorio de archivos aceptados para procesar ($s_temp): " temp_var
    lenght=${#temp_var}
    if [ "$lenght" != "$zero" ]; then
        ss_temp=$temp_var
    fi 

    read -p "Indique el nombre del directorio de los archivos rechazados ($s_rejected): " temp_var
    lenght=${#temp_var}
    if [ "$lenght" != "$zero" ]; then
        s_rejected=$temp_var
    fi 

    read -p "Indique el nombre del directorio de los archivos procesados ($s_processed): " temp_var
    lenght=${#temp_var}
    if [ "$lenght" != "$zero" ]; then
        s_processed=$temp_var
    fi 

    read -p "Indique el nombre del directorio de los archivos de salida ($s_exit): " temp_var
    lenght=${#temp_var}
    if [ "$lenght" != "$zero" ]; then
        s_exit=$temp_var
    fi 
}

print_details () { #cambiar funcion, que maneje un array
    echo ""
    echo "INFORMACION"
    echo ""
    echo "  TP SO7508 2º Cuatrimestre 2019. Copyright © Grupo 01"
    echo "  Directorio padre: GRUPO01"
    echo "  Directorio de configuración:  /conf"
    echo "  Archivos de log: /conf/log"
    echo "  Libreria de ejecutables: /${directories_array[0]}"
    echo "  Repositorio de maestros: /${directories_array[1]}"
    echo "  Directorio para las novedades… /${directories_array[2]}"
    echo "  Directorio para los archivos aceptados… /${directories_array[3]}"
    echo "  Directorio para los archivos rechazados… /${directories_array[4]}"
    echo "  Directorio para Archivos procesados… /${directories_array[5]}"
    echo "  Directorio para los archivos de salida… /${directories_array[6]}"
    echo ""
    echo "ATENCION: Los logs del sistema se depositan en /conf/log"
    echo ""
    echo "Estado de la instalacion: LISTA"
}

create_initial_directories () {
    echo "Creando directorios iniciales"
    mkdir "$grupo"
    echo "Se creo directorio ($grupo)"
    sleep 1
    mkdir "$grupo/$s_conf"
    echo "Se creo directorio ($grupo/$s_conf)"
    sleep 1
    echo ""
}

create_directories () {
    echo "Paso 2: Creacion de los directorios"
    arr=("$@")
    for j in "${!arr[@]}"; do
        mkdir -p GRUPO01/"${arr[j]}"
        echo "Se creo directorio (GRUPO01/${arr[j]})"
        sleep 1         
    done
    echo ""
}

unzip_files () {
    echo "Paso 3: Descomprimiendo archivos"
    unzip files.zip
    echo "Archivos descomprimidos"
    echo ""
    sleep 2
}

move_files () {
    echo "Paso 4: Moviendo archivos"

    sudo mv  "start.sh" "GRUPO01/$1"
    echo "Moviendo start.sh GRUPO01/$1"
    sleep 1
    
    sudo mv  "stop.sh" "GRUPO01/$1"
    echo "Moviendo stop.sh GRUPO01/$1"
    sleep 1

    sudo mv  "validaciones.sh" "GRUPO01/$1"
    echo "validaciones.sh GRUPO01/$1"
    sleep 1

    sudo mv  "process.sh" "GRUPO01/$1"
    echo "Moviendo process.sh GRUPO01/$1"
    sleep 1

    sudo mv  "preprocess.sh" "GRUPO01/$1"
    echo "Moviendo preprocess.sh GRUPO01/$1"
    sleep 1

    echo "Archivos movidos"
    echo ""
}

check_installation () {
    if [ ${#repair_installation} -eq 0 ]; then #solo detecta si ingresaron un parametro no -r. (probe comparar contra -r y daba mal)
        echo "Bienvenido, detectamos que el programa ya esta instalado, se verificaran los datos de instalacion"
    else
        echo "Bienvenido, el modo reparacion a comenzado"
    fi
    echo ""

    installation_is_ok=0 #0=false; 1=true
    declare -a directories_array=()
    declare -a created_directories=()
    declare -a missing_directories=()
    read_conf_file "$directories_array"
    get_created_directories "$created_directories"
    check_directories "$directories_array" "$created_directories" "$missing_directories"
    if [ "${#missing_directories[@]}" -eq 0 ]; then
        print_details "$directories_array"
        return
    else
        echo "Faltan los directorios:"
        printf '    %s\n' "${missing_directories[@]}"
        echo ""
    fi
    
    declare -i option_choose=-1
    print_options "$option_choose"
    if [ "$option_choose" -eq 0 ]; then
        echo "Reanudando la instalacion"
        create_directories "${missing_directories[@]}"
        unzip_files
        printf '    %s' "${directories_array[@]}"
        move_files "${directories_array[0]}"
        echo "La instalacion finalizo correctamente"
        return
    elif [ "$option_choose" -eq 1 ]; then
        echo "Finalizo la instalacion"
    elif [ "$option_choose" -eq 2 ]; then 
        echo "Borrando archivos"
        rm -r "GRUPO01"
        sleep 1
        echo "Archivos borrados, finalizo el instador"
    else 
        echo "Opcion invalida, finalizando instalacion" #podria hacer un bucle(?)
    fi 
}

print_options () {
    echo "[0] Para continuar con la instalacion"
    echo "[1] Para finalizar instalacion"
    echo "[2] Para eliminar archivos"
    echo ""
    read -p "Elija la opcion deseada: " option_choose
    echo ""
}

read_conf_file () {
    input="$PWD/GRUPO01/conf/config.txt"
    while IFS= read -r line
    do
      directories_array+=("$line")
    done < "$input"
}

get_created_directories () {
    cd GRUPO01
    for d in */ ; do
        created_directories+=("${d::-1}")
    done
    cd ..
}

check_directories () {
    #missing_directories=$(${config_directories[@]} ${created_directories[@]} | tr ' ' '\n' | sort | uniq -u) #magic
    for i in "${!directories_array[@]}"; do
        containsElement "${directories_array[i]}" "${created_directories[@]}"
        declare -i exists=$?
        if [ "$exists" -eq 0 ]; then
            missing_directories+=("${directories_array[i]}")
            echo "ATENCION: El directorio ${directories_array[i]} NO existe"
        else
            echo "El directorio ${directories_array[i]} existe"
        fi
        sleep 1
    done
    echo ""
}

containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 1; done
  return 0
}

main 