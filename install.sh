#!/bin/bash
source ./helpers.sh
repair_installation=$1

declare -a DIRECTORIOSREALES=("bin" "maestros" "novedades" "aceptados" "rechazados" "procesados" "salida" )

main () {
    if [ -d "GRUPO01/" ]; then
        check_installation
        return
    fi
    show_ini 
    assign_default_subdirectories
    create_initial_directories "$grupo" "$s_conf"
    declare -a dir=("$s_executable" "$s_master" "$s_extern" "$s_temp" "$s_rejected" "$s_processed" "$s_exit" "$s_conf" "$grupo")
    get_subdirectories "$dir" "$s_conf" "$grupo"
    new_directories=("$s_executable" "$s_master" "$s_extern" "$s_temp" "$s_rejected" "$s_processed" "$s_exit")
    save_configuration "$new_directories"
    create_directories "${new_directories[@]}"
    unzip_files
    move_files "$s_executable"
    showOutputs "Estado de instalacion" "La instalacion finalizo correctamente"
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
    showOutputs "Estado de instalacion" "Guardando configuracion de los directorios"
    for j in "${!new_directories[@]}"; do
        if [ ! -e "GRUPO01/conf/conf.txt" ]; then
            echo ${DIRECTORIOSREALES[j]},${new_directories[j]} >> "GRUPO01/conf/config.txt"
        else
            echo ${DIRECTORIOSREALES[j]},${new_directories[j]} > "GRUPO01/conf/config.txt"
        fi
    done
    echo "conf,conf" >> "GRUPO01/conf/config.txt"
    showOutputs "Estado de instalacion" "Configuracion guardada"
    echo ""    
    sleep 1
}

validate_subdirectories () {
    for i in "${!dir[@]}"; do
        for j in "${!dir[@]}"; do
            if [ "${dir[i]}" == "${dir[j]}" ] && [ "$i" != "$j" ]; then
                echo ""
                showOutputs "Estado de instalacion" "ERROR: El directorio (${dir[j]}) esta duplicado!"
                echo ""
                reapeat_directory="SI"
                return
            fi
        done
    done
    echo ""
}

get_subdirectories () {
    reapeat_directory="NO"
    installation_accepted="NO"
    while [ "$installation_accepted" != "SI" ] || [ "$reapeat_directory" != "NO" ]
    do 
        reapeat_directory="NO"
        ask_subdirectories "${dir[0]}" "${dir[1]}" "${dir[2]}" "${dir[3]}" "${dir[4]}" "${dir[5]}" "${dir[6]}"
        dir=("${dir[0]}" "${dir[1]}" "${dir[2]}" "${dir[3]}" "${dir[4]}" "${dir[5]}" "${dir[6]}" "$s_conf" "$grupo")
        print_details "$dir"
        read -p "¿Confirma la instalacion? (SI-NO): " installation_accepted
        validate_subdirectories "$dir" "$reapeat_directory"
    done
}


ask_subdirectories () {
    zero=0
    showOutputs "Estado de instalacion" "Paso 1: Seleccionar directorios" 
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

print_details () {

    echo ""

    echo "INFORMACION"
    echo ""
    echo "  TP SO7508 2º Cuatrimestre 2019. Copyright © Grupo 01"
    echo "  Directorio padre: GRUPO01"
    echo "  Directorio de configuración:  /conf"
    echo "  Archivos de log: /conf/log"
    echo "  Libreria de ejecutables: /${dir[0]}"
    echo "  Repositorio de maestros: /${dir[1]}"
    echo "  Directorio para las novedades… /${dir[2]}"
    echo "  Directorio para los archivos aceptados… /${dir[3]}"
    echo "  Directorio para los archivos rechazados… /${dir[4]}"
    echo "  Directorio para Archivos procesados… /${dir[5]}"
    echo "  Directorio para los archivos de salida… /${dir[6]}"
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
    touch "GRUPO01/conf/log.txt"
    showOutputs "Estado de intalacion" "Se creo el archivo log.txt"
    logInfo "Estado de instalacion" "La instalacion comenzo" "GRUPO01/conf/log.txt"
    logInfo "Estado de instalacion" "Se crearon los directorios inciales GRUPO01 y conf" "GRUPO01/conf/log.txt"    
    sleep 1
    echo ""
}

create_directories () {
    showOutputs "Estado de instalacion" "Paso 2: Creacion de los directorios" "GRUPO01/conf/log.txt" 
    arr=("$@")
    for j in "${!arr[@]}"; do
        mkdir -p GRUPO01/"${arr[j]}"
        showOutputs "Estado de instalacion" "Se creo directorio (GRUPO01/${arr[j]})"
        sleep 1         
    done
    echo ""
}

unzip_files () {
    showOutputs "Estado de instalacion" "Paso 3: Descomprimiendo archivos"
    unzip files.zip
    showOutputs "Estado de instalacion" "Archivos descomprimidos"
    echo ""
    sleep 2
}

move_files () {
    showOutputs "Estado de instalacion" "Paso 4: Moviendo archivos"

    for i in $(ls -C1 | grep "^[^.]*.sh" | grep -v "install.sh")
    do
        sudo mv  $i "GRUPO01/$1"
        showOutputs "Estado de instalacion" "Moviendo $i GRUPO01/$1"
        sleep 1
    done
    showOutputs "Estado de instalacion" "Archivos movidos"
    echo ""
}

check_installation () {
    if [ ${#repair_installation} -eq 0 ]; then #solo detecta si ingresaron un parametro no -r. (probe comparar contra -r y daba mal)
        echo "Bienvenido, detectamos que el programa ya esta instalado, se verificaran los datos de instalacion"
        logInfo "Estado de instalacion" "Verificando instalacion" "GRUPO01/conf/log.txt"   
    else
        echo "Bienvenido, el modo reparacion a comenzado"
        logInfo "Estado de instalacion" "Reparando instalacion" "GRUPO01/conf/log.txt"
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
        showOutputs "Estado de instalacion" "Faltan los directorios:"
        ( IFS=$'    \n'; showOutputs "Estado de instalacion" "${missing_directories[*]}" )
        echo ""
    fi
    
    declare -i option_choose=-1
    print_options "$option_choose"
    if [ "$option_choose" -eq 0 ]; then
        showOutputs "Estado de instalacion" "Reanudando la instalacion"
        create_directories "${missing_directories[@]}"
        unzip_files
        printf '    %s' "${directories_array[@]}"
        move_files "${directories_array[0]}"
        showOutputs "Estado de instalacion" "La instalacion finalizo correctamente"
        return
    elif [ "$option_choose" -eq 1 ]; then
        showOutputs "Estado de instalacion" "Finalizo la instalacion"
    elif [ "$option_choose" -eq 2 ]; then 
        showOutputs "Estado de instalacion" "Borrando archivos"
        rm -r "GRUPO01"
        sleep 1
        showOutputs "Estado de instalacion" "Archivos borrados, finalizo el instador"
    else 
        echo "Opcion invalida, finalizando instalacion" #podria hacer un bucle(?)
        logInfo "Estado de instalacion" "Finalizo la instalacion" "GRUPO01/conf/log.txt"
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
    while IFS=, read -r a b ; do
      directories_array+=("$b")
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
    for i in "${!directories_array[@]}"; do
        containsElement "${directories_array[i]}" "${created_directories[@]}"
        declare -i exists=$?
        if [ "$exists" -eq 0 ]; then
            missing_directories+=("${directories_array[i]}")
            showOutputs "Estado de instalacion" "ATENCION: El directorio ${directories_array[i]} NO existe"
        else
            showOutputs "Estado de instalacion" "El directorio ${directories_array[i]} existe"
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

showOutputs () {
    logInfo "$1" "$2"
    logInfo "$1" "$2" "GRUPO01/conf/log.txt"    
}

main 