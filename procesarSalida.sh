source ./helpers.sh

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
    cd ..
    cd ./$path_procesados

    tipoOperacion=`echo "$trailer" | cut -d ',' -f1`
    descripcionOperacion=`echo "$trailer" | cut -d ',' -f2`
    totalTrx=`echo "$trailer" | cut -d ',' -f3`
    fechaCierreLote=`echo "$trailer" | cut -d ',' -f4`
    anio=`echo "$trailer" | cut -d ',' -f5`
    fechaHora=`echo "$trailer" | cut -d ',' -f6`
    traceNumber=`echo "$trailer" | cut -d ',' -f11`
    codigoISO=`echo "$trailer" | cut -d ',' -f12`
    retrievalNumber=`echo "$trailer" | cut -d ',' -f13`
    msjHost=`echo "$trailer" | cut -d ',' -f18`

    contenidoMsjHost=`echo "$msjHost" | cut -d '>' -f2`

    numeroBatch=${contenidoMsjHost:0:3}
    cantidadCompras=${contenidoMsjHost:3:4}
    montoCompras=${contenidoMsjHost:7:12}
    cantidadDevoluciones=${contenidoMsjHost:19:4}
    montoDevoluciones=${contenidoMsjHost:23:12}
    cantidadAnulaciones=${contenidoMsjHost:35:4}
    montoAnulaciones=${contenidoMsjHost:39:12}

    parseados=$numeroBatch,$cantidadCompras,$montoCompras,$cantidadDevoluciones,$montoDevoluciones,$cantidadAnulaciones,$montoAnulaciones

    echo $tipoOperacion,$descripcionOperacion,$totalTrx,$fechaCierreLote,$anio,$fechaHora,$traceNumber,$codigoISO,$retrievalNumber,$msjHost,$parseados >> Cierre_de_Lote.csv

    #Procesar las transacciones

    cd ..
    cd ./$path_aceptados

done

