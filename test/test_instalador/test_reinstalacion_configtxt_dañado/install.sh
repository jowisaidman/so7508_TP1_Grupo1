#!/bin/bash
source ./helpers.sh
repair_installation=$1

declare -a DIRECTORIOSREALES=("bin" "maestros" "novedades" "aceptados" "rechazados" "procesados" "salida" )

logInfo() {
    output="/dev/tty"
    if [[ ! -z "$3" ]]; then
        output="$3"
        if [[ ! -f "$output" ]]; then
            echo > $output
        fi
    fi
    echo `date` - $USERNAME - $1 - INF - $2 >> "$output"
}

main () {
    if [ -d "GRUPO01/" ]; then
        reinstallation_is_posible="NO"
        check_installation "$reinstallation_is_posible"
        if [[ "$reinstallation_is_posible" = "SI" ]]; then
            return
        fi
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
    save_original_package
    move_files "$s_executable"
    remove_useless_files
    showOutputs "Estado de instalacion" "La instalacion finalizo correctamente"
}

#Guarda el paquete de instalacion en el directorio original_package
save_original_package () {
    echo ""
    showOutputs "Estado de instalacion" "Guardando archivos originales"
    echo ""
    mkdir original_package
    cp "files.zip" "original_package"
    cp "install.sh" "original_package"
}

#Elimina los archivos que ya no son de utilidad
remove_useless_files () {
    echo ""
    showOutputs "Estado de instalacion" "Eliminando archivos innecesarios"
    echo ""
    rm files.zip
    # rm install.sh
}

#Imprime mensaje de bienvenida
show_ini () {
    echo "Bienvenido, la instalacion a comenzado!"
    echo "Debera seleccionar los nombres de los directorios, debe tener en cuenta que NO se puede: "
    echo "    -Utilizar nombres repetidos
    -Utilizar nombres de palabras reservadas"
    echo ""
    sleep 1    
}

#Asigna los valores por defecto a los subdirectorios de GRUPO01 y a GRUPO01
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

#Guarda en el archivo de configuracion los nombres de directorio eligidos por el usuario
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

#Recibe como parametro un arreglo de directorios (strings) y verifica que sean validos.
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

#Recibe como paramtro un arreglo y dos strings. Se encarga de obtener los directorios 
#que el usuario quiere elegir. Hasta  no obtener una confirmacion del usuario 
#seguira ejecutandose.
get_subdirectories () {
    reapeat_directory="NO"
    installation_accepted="NO"
    while [ "$installation_accepted" != "SI" ] || [ "$reapeat_directory" != "NO" ]
    do 
        reapeat_directory="NO"
        ask_subdirectories "${dir[0]}" "${dir[1]}" "${dir[2]}" "${dir[3]}" "${dir[4]}" "${dir[5]}" "${dir[6]}"
        dir=("$s_executable" "$s_master" "$s_extern" "$ss_temp" "$s_rejected" "$s_processed" "$s_exit" "$s_conf" "$grupo")
        print_details "$dir"
        read -p "¿Confirma la instalacion? (SI-NO): " installation_accepted
        logInfo "Estado de instalacion" "La opcion elegida para confirmar la instalacion fue: $installation_accepted" "GRUPO01/conf/logs/instalacion.log"
        validate_subdirectories "$dir" "$reapeat_directory"
    done
}

#Se encarga de obtener el valor de cada subdirectorio.
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


#Recibe como parametro un arreglo que contiene los nombres de los directorios
#que el usuario eligio e imprime los detalles de instalacion. 
print_details () {
    echo ""
    echo "INFORMACION"
    echo ""
    echo "  TP SO7508 2º Cuatrimestre 2019. Copyright © Grupo 01"
    echo "  Directorio padre: GRUPO01"
    echo "  Directorio de configuración:  /conf"
    echo "  Archivos de log: /conf/logs/instalacion.log
    echo "  Libreria de ejecutables: /${dir[0]}"
    echo "  Repositorio de maestros: /${dir[1]}"
    echo "  Directorio para las novedades… /${dir[2]}"
    echo "  Directorio para los archivos aceptados… /${dir[3]}"
    echo "  Directorio para los archivos rechazados… /${dir[4]}"
    echo "  Directorio para Archivos procesados… /${dir[5]}"
    echo "  Directorio para los archivos de salida… /${dir[6]}"
    echo ""
    echo "ATENCION: Los logs del sistema se depositan en /conf/logs/instalacion.log
    echo ""
    echo "Estado de la instalacion: LISTA"
}

#Crea los directorios iniciales y el archivo de log de la instalacion
create_initial_directories () {
    if [ ! -d "GRUPO01/" ]; then
        echo "Creando directorios iniciales"
        mkdir "$grupo"
        echo "Se creo directorio ($grupo)"
    else
        showOutputs "Estado de intalacion" "La carpeta $grupo ya se encuentra creada"
    fi
    sleep 1
    if [ ! -d "$grupo/$s_conf" ]; then
        mkdir "$grupo/$s_conf"
        echo "Se creo directorio ($grupo/$s_conf)"
    else
        showOutputs "Estado de intalacion" "La carpeta $grupo/$s_conf ya se encuentra creada"
    fi
    sleep 1
    if [ ! -d "$grupo/$s_conf/logs" ]; then
        mkdir "$grupo/$s_conf/logs"
        echo "Se creo directorio ($grupo/$s_conf/logs)"
    else
        showOutputs "Estado de intalacion" "La carpeta $grupo/$s_conf/logs ya se encuentra creada"
    fi
    if [ -f "GRUPO01/conf/logs/instalacion.log" ]; then
        showOutputs "Estado de intalacion" "El archivo GRUPO01/conf/logs/instalacion.log ya se encuentra creado"
    else
        touch "GRUPO01/conf/logs/instalacion.log"
        showOutputs "Estado de intalacion" "Se creo el archivo instalacion.log"
        logInfo "Estado de instalacion" "La instalacion comenzo" "GRUPO01/conf/logs/instalacion.log"
        logInfo "Estado de instalacion" "Se crearon los directorios inciales GRUPO01 y conf" "GRUPO01/conf/logs/instalacion.log" 
    fi   
    sleep 1
    echo ""
}

#Crea los directorios elegidos por el usuario
create_directories () {
    showOutputs "Estado de instalacion" "Paso 2: Creacion de los directorios" "GRUPO01/conf/logs/instalacion.log" 
    arr=("$@")
    for j in "${!arr[@]}"; do
        mkdir -p GRUPO01/"${arr[j]}"
        showOutputs "Estado de instalacion" "Se creo directorio (GRUPO01/${arr[j]})"
        sleep 1         
    done
    echo ""
}

#Descomprime el arhcivo files.zip 
unzip_files () {
    showOutputs "Estado de instalacion" "Paso 3: Descomprimiendo archivos"
    unzip files.zip
    showOutputs "Estado de instalacion" "Archivos descomprimidos"
    echo ""
    sleep 2
}

#Recive un arreglo de directorios y los mueve a los lugares correspondientes 
move_files () {
    showOutputs "Estado de instalacion" "Paso 4: Moviendo archivos"

    for i in $(ls -C1 | grep "^[^.]*.sh")
    do
        sudo mv  $i "GRUPO01/$1"
        showOutputs "Estado de instalacion" "Moviendo $i GRUPO01/$1"
        sleep 1
    done
    sudo mv "codigos.csv" "GRUPO01/$s_master"
    showOutputs "Estado de instalacion" "Archivos movidos"
    echo ""
}

#Verifica si es necesario realizar una reinstalacion, en caso de serlo
#se encarga que se realize de forma exitosa.
check_installation () {
    print_ini_reparation
    declare -a dir=()
    declare -a created_directories=()
    declare -a missing_directories=()
    config_file_is_ok="NO"
    check_config_file "$config_file_is_ok"
    if [[ "$config_file_is_ok" = "NO" ]]; then
        showOutputs "Estado de instalacion" "ATENCION: No es posible realizar la reinstalacion dado que el archivo GRUPO01/conf/config.txt esta dañado. Se instalara desde el comienzo"
        echo ""
        return
    fi
    reinstallation_is_posible="SI"
    read_conf_file "$dir"
    get_created_directories "$created_directories"
    check_directories "$dir" "$created_directories" "$missing_directories"
    if [ "${#missing_directories[@]}" -eq 0 ]; then
        files_are_ok="NO"
        check_files "${dir[0]}" "$files_are_ok"
        if [[ "$files_are_ok" != "SI" ]]; then
            showOutputs "Estado de instalacion" "Se van reparar los archivos ejecutables"
            repair_files "$dir"
        fi
    else
        showOutputs "Estado de instalacion" "Faltan los directorios:"
        ( IFS=$'    \n'; showOutputs "Estado de instalacion" "${missing_directories[*]}" )
        echo ""
        execute_reparation "$missing_directories" "$dir"
    fi
    print_details "$dir"
    showOutputs "Estado de instalacion" "La instalacion finalizo correctamente"
}

#Verifica que sea correcta la cantidad de archivos dentro del directorio de ejecutables
check_files () {
    cd "GRUPO01/$1"
    number_of_files=$(ls -l | grep -v ^l | wc -l)
    if [[ "$number_of_files" = "9" ]]; then
        files_are_ok="SI"
    fi
    cd ..
    cd ..
}

#Verifica que el archivo de configuracion se encuentre en buen estado
check_config_file () {
    if [ -f "GRUPO01/conf/config.txt" ]; then
        number_of_lines=$(< "GRUPO01/conf/config.txt" wc -l)
        if [[ "$number_of_lines" = "8" ]]; then
            config_file_is_ok="SI"
        fi
    fi
}

#Imprime mensaje de inicio de la reinstalacion
print_ini_reparation () {
    if [ ${#repair_installation} -eq 0 ]; then
        echo "Bienvenido, detectamos que el programa ya esta instalado, se verificaran los datos de instalacion"
        logInfo "Estado de instalacion" "Verificando instalacion" "GRUPO01/conf/logs/instalacion.log"   
    else
        echo "Bienvenido, el modo reparacion a comenzado"
        logInfo "Estado de instalacion" "Reparando instalacion" "GRUPO01/conf/logs/instalacion.log"
    fi
    echo ""    
}

execute_reparation () {
    finish_reparation="NO"
    while [ "$finish_reparation" != "SI" ]
    do
        option_choose="-1"
        print_options "$option_choose"
        if [ "$option_choose" = "0" ]; then
            resume_instation "$missing_directories" "$dir"
            finish_reparation="SI"
        elif [ "$option_choose" = "1" ]; then
            showOutputs "Estado de instalacion" "Finalizo la instalacion"
            finish_reparation="SI"
        elif [ "$option_choose" = "2" ]; then 
            delete_instalation
            finish_reparation="SI"
        else 
            echo "Opcion invalida, finalizando instalacion"
        fi
    done 
}

repair_files () {
    unzip_files
    save_original_package
    ( IFS=$'    \n'; showOutputs "Estado de instalacion" "${dir[*]}" )
    move_files "${dir[0]}"
    remove_useless_files
}

#Reanuda la instalacion
resume_instation () {
    showOutputs "Estado de instalacion" "Reanudando la instalacion"
    create_directories "${missing_directories[@]}"
    repair_files "$dir"
}

#Borra la carpeta del programa.
delete_instalation () {
    showOutputs "Estado de instalacion" "Borrando archivos"
    rm -r "GRUPO01"
    sleep 1
    echo "Archivos borrados, finalizo el instador"    
}

#Imprime las opciones disponibles que tiene el usuario
print_options () {
    echo "[0] Para continuar con la instalacion"
    echo "[1] Para finalizar instalacion"
    echo "[2] Para eliminar archivos"
    echo ""
    read -p "Elija la opcion deseada: " option_choose
    echo ""
    logInfo "Estado de instalacion" "La opcion elegida para reinstalar fue $option_chose" "GRUPO01/conf/logs/instalacion.log"
}

#Lee el archivo de configuracion
read_conf_file () {
    input="$PWD/GRUPO01/conf/config.txt"
    while IFS=, read -r a b ; do
      dir+=("$b")
    done < "$input"
}

#Obtiene los directorios que existen dentro de la carpeta GRUPO01
get_created_directories () {
    cd GRUPO01
    for d in */ ; do
        created_directories+=("${d::-1}")
    done
    cd ..
}

#Verifica que directorios existen dentro de GRUPO01.
check_directories () {
    for i in "${!dir[@]}"; do
        containsElement "${dir[i]}" "${created_directories[@]}"
        declare -i exists=$?
        if [ "$exists" -eq 0 ]; then
            missing_directories+=("${dir[i]}")
            showOutputs "Estado de instalacion" "ATENCION: El directorio ${dir[i]} NO existe"
        else
            showOutputs "Estado de instalacion" "El directorio ${dir[i]} existe"
        fi
        sleep 1
    done
    echo ""
}

#Recibe como parametro un arreglo y un string y verifica si el arreglo contiene al string
containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 1; done
  return 0
}

#Muestra mensaje en la salida standar y lo guarda en el log
showOutputs () {
    logInfo "$1" "$2"
    logInfo "$1" "$2" "GRUPO01/conf/logs/instalacion.log"    
}

main 