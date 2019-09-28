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
    transacciones=`echo "$contenido" | grep -v '^CI.*'`

    IFS=$'\n' # para que el "for" separe por linea
    for j in $transacciones
    do
        tipoOperacion=`echo "$j" | cut -d ',' -f1`
        descripcionOperacion=`echo "$j" | cut -d ',' -f2`
        anio=`echo "$j" | cut -d ',' -f5`
        fechaHora=`echo "$j" | cut -d ',' -f6`
        numeroTarjeta=`echo "$j" | cut -d ',' -f7`
        vencimiento=`echo "$j" | cut -d ',' -f8`
        importe=`echo "$j" | cut -d ',' -f9`
        cuotas=`echo "$j" | cut -d ',' -f10`
        traceNumber=`echo "$j" | cut -d ',' -f11`
        codigoISO=`echo "$j" | cut -d ',' -f12`
        retrievalNumber=`echo "$j" | cut -d ',' -f13`
        ticketNumber=`echo "$j" | cut -d ',' -f14`
        autorizacion=`echo "$j" | cut -d ',' -f15`
        idTrx=`echo "$j" | cut -d ',' -f16`
        trxRelacionada=`echo "$j" | cut -d ',' -f17`
        msjHost=`echo "$j" | cut -d ',' -f18`

        if [ `echo "$msjHost" | grep '[a-zA-Z]' -c` == 0 ];
        then
            echo "No tiene mensaje host"
            #TODO: Falta crear el msjHost a partir del campo codigoISO
        else
            echo "Tiene mensaje host y es $msjHost"
        fi

        contenidoFechaHora=`echo "$fechaHora" | cut -d '>' -f2`
        contenidoImporte=`echo "$importe" | cut -d '>' -f2`
        contenidoAnio=`echo "$anio" | cut -d '>' -f2`

        mes=${contenidoFechaHora:0:2}
        dia=${contenidoFechaHora:2:2}
        hora=${contenidoFechaHora:4:2}:${contenidoFechaHora:6:2}:${contenidoFechaHora:8:2}
        monto=${contenidoImporte:0:10},${contenidoImporte:10:2}

        parseado=$mes,$dia,$hora,$monto
        original=$tipoOperacion,$descripcionOperacion,$anio,$fechaHora,$numeroTarjeta,$vencimiento,$importe,$cuotas,$traceNumber,$codigoISO,$retrievalNumber,$ticketNumber,$autorizacion,$idTrx,$trxRelacionada,$msjHost

        echo $original,$parseado >> TRX_$contenidoAnio$mes$dia.csv

    done

    cd ..
    cd ./$path_aceptados

done

