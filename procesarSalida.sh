#Parametros:
#1) Nombre del proceso/archivo desde donde se loguea
#2) Mensaje
logInfo() {
    echo `date` - $USERNAME - $1 - INF - $2
}

#TODO: Cambiar para que tome los paths configurados.
path_aceptados='Aceptados'
path_rechazados='Rechazados'
path_procesados='Procesados'

#Se debe loguear correctamente cada paso

#Leer uno a uno los archivos de la carpeta "Aceptados"
cd ./$path_aceptados

for i in `ls`
do
    logInfo $0 Procesando el archivo $i

    contenido=`more $i`

    #Verificar si el archivo tiene UN cierre de lote (trailer)
    cantidadTrailers=`echo "$contenido" | grep '^CI.*' -c`
    if [ $cantidadTrailers == 1 ];
	then
        logInfo $0 "El archivo $i tiene un cierre de lote."
	else
        logInfo $0 "El archivo $i tiene $cantidadTrailers cierre de lote y debería tener 1."
        mv $i ../$path_rechazados
		continue
	fi

    #Verificar que la cantidad de transacciones sea igual a las indicadas en el trailer
    trailer=`echo "$contenido" | grep '^CI.*'`
    cantidadTransaccionesSegunTrailer=`echo "$trailer" | cut -d ',' -f3`
    cantidadTransacciones=`echo "$contenido" | grep -v '^CI.*' -c`

    if [ $cantidadTransaccionesSegunTrailer == $cantidadTransacciones ];
	then
        logInfo $0 "El archivo $i tiene $cantidadTransacciones transacciones."
	else
        logInfo $0 "No coinciden la cantidad de transacciones del trailer con las leidas del archivo $i"
        mv $i ../$path_rechazados
		continue
	fi

    #Grabar el cierre de lote
    #Procesar las transacciones
done

