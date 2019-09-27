#!/bin/bash

repair_installation=$1

main () {
    if [ -d "GRUPO01/" ]; then
        check_installation
        return
    fi
    show_ini 
    assign_default_subdirectories
    reapeat_directory="NO"
    installation_accepted="NO"
    declare -a directories_array
    while [ "$installation_accepted" != "SI" ] || [ "$reapeat_directory" != "NO" ] #este ciclo deberia ir en una funcion
    do 
        reapeat_directory="NO"
        ask_subdirectories "$s_executable" "$s_master" "$s_extern" "$s_temp" "$s_rejected" "$s_processed" "$s_exit"
        print_details "$s_executable" "$s_master" "$s_extern" "$s_temp" "$s_rejected" "$s_processed" "$s_exit"
        read -p "¿Confirma la instalacion? (SI-NO): " installation_accepted
        directories_array=("$grupo" "$s_executable" "$s_master" "$s_extern" "$s_temp" "$s_rejected" "$s_processed" "$s_exit")
        validate_subdirectories "$directories_array" "$reapeat_directory"
    done
    new_directories=("conf" "$s_executable" "$s_master" "$s_extern" "$s_temp" "$s_rejected" "$s_processed" "$s_exit")
    create_directories "$new_directories"
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
    sleep 3    
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
    echo "  Directorio padre: $grupo"
    echo "  Directorio de configuración:  /conf"
    echo "  Archivos de log: /conf/log"
    echo "  Libreria de ejecutables: /$s_executable"
    echo "  Repositorio de maestros: /$s_master"
    echo "  Directorio para las novedades… /$s_extern"
    echo "  Directorio para los archivos aceptados… /$s_temp"
    echo "  Directorio para los archivos rechazados… /$s_rejected"
    echo "  Directorio para Archivos procesados… /$s_processed"
    echo "  Directorio para los archivos de salida… /$s_exit"
    echo ""
    echo "ATENCION: Los logs del sistema se depositan en /conf/log"
    echo ""
    echo "Estado de la instalacion: LISTA"
}

create_directories () {
    mkdir -p GRUPO01
    echo "Paso 2: Creacion de los directorios"
    for j in "${!new_directories[@]}"; do
        if [ ! -d GRUPO01/"${new_directories[j]}" ]; then
            mkdir -p GRUPO01/"${new_directories[j]}"
            echo "Se creo directorio (GRUPO01/${new_directories[j]})"
        else
            echo "El directorio (GRUPO01/${new_directories[j]}) ya esta creado"
        fi
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

    sudo mv  "start.sh" "GRUPO01/$s_executable/start.sh"
    echo "Moviendo start.sh GRUPO01//$s_executable/start.sh"
    sleep 1
    
    sudo mv  "stop.sh" "GRUPO01/$s_executable"
    echo "Moviendo stop.sh GRUPO01/$s_executable"
    sleep 1

    sudo mv  "validaciones.sh" "GRUPO01/$s_executable"
    echo "validaciones.sh GRUPO01/$s_executable"
    sleep 1

    sudo mv  "process.sh" "GRUPO01/$s_executable"
    echo "Moviendo process.sh GRUPO01/$s_executable"
    sleep 1

    sudo mv  "preprocess.sh" "GRUPO01/$s_executable"
    echo "Moviendo preprocess.sh GRUPO01/$s_executable"
    sleep 1

    echo "Archivos movidos"
    echo ""
}

check_installation () {
    #ejemplo de como comparar strings (con los paramtros no me funciona)
    #ee="aa"
    #if [[ "$ee" = "aa" ]]; then
    #  echo "son igual"
    #fi

    if [ ${#repair_installation} -eq 0 ]; then #solo detecta si ingresaron un parametro no -r. (probe comparar contra -r y daba mal)
        echo "Bienvenido, detectamos que el programa ya esta instalado, se verificaran los datos de instalacion"
    else
        echo "Bienvenido, el modo reparacion a comenzado"
    fi
    echo ""

    installation_is_ok=0 #0=false; 1=true
    declare -a config_directories=()
    declare -a created_directories=()
    declare -a missing_directories=()
    read_conf_file "$config_directories"
    get_created_directories "$created_directories"
    check_directories "$config_directories" "$created_directories" "$missing_directories"
    if [ "${#missing_directories[@]}" -eq 0 ]; then
        echo "Todo en orden"
    else
        echo "Faltan los directorios:"
        printf '    %s\n' "${missing_directories[@]}"
        echo ""
    fi
}

read_conf_file () {
    input="$PWD/GRUPO01/conf/config.txt"
    while IFS= read -r line
    do
      config_directories+=("$line/")
    done < "$input"
}

get_created_directories () {
    cd GRUPO01
    for d in */ ; do
        created_directories+=("$d")
    done
    cd ..
}

check_directories () {
    #printf '%s ' "${config_directories[@]}"
    #echo ""
    #printf '%s ' "${created_directories[@]}"
    #echo ""
    #missing_directories=$(${config_directories[@]} ${created_directories[@]} | tr ' ' '\n' | sort | uniq -u) #magic
    for i in "${!config_directories[@]}"; do
        containsElement "${config_directories[i]}" "${created_directories[@]}"
        declare -i exists=$?
        if [ "$exists" -eq 0 ]; then
            missing_directories+=("${config_directories[i]}")
            echo "ATENCION: El directorio ${config_directories[i]} NO existe"
        else
            echo "El directorio ${config_directories[i]} existe"
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