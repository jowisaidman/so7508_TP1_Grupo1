source ./helpers.sh

path_aceptados=$aceptados
path_rechazados=$rechazados
path_procesados=$procesados
path_salida=$salida
path_bin=$bin

if [ -z $init ];
then 
    logAlerta $0 "No esta inicializado." "../conf/logs/process.log"
    exit 1
fi

#Se debe loguear correctamente cada paso

#Leer uno a uno los archivos de la carpeta "Aceptados"
cd ../$path_aceptados

for i in `ls`
do
    logInfo $0 "Procesando el archivo $i" "../conf/logs/process.log"

    contenido=`cat $i`

    #Verificar si el archivo tiene UN cierre de lote (trailer)
    cantidadTrailers=`echo "$contenido" | grep '^CI.*' -c`
    if [ $cantidadTrailers == 1 ];
	then
        logInfo $0 "El archivo $i tiene un cierre de lote." "../conf/logs/process.log"
	else
        logInfo $0 "El archivo $i tiene $cantidadTrailers cierre de lote y debería tener 1." "../conf/logs/process.log"
        mv $i ../$path_rechazados
		continue
	fi

    #Verificar que la cantidad de transacciones sea igual a las indicadas en el trailer
    trailer=`echo "$contenido" | grep '^CI.*'`

    formatoValido=$(echo "$trailer" | grep "^.\+,.\+,.\+,.\+,.\+,.\+,,,,,.\+,.\+,.\+,,,,,.\+" -c)

    if [ $formatoValido == 0 ];
    then 
        logAlerta $0 "El trailer tiene un formato inválido." "../conf/logs/process.log"
        mv $i ../$path_rechazados
        continue
    else
        logInfo $0 "El trailer tiene un formato válido." "../conf/logs/process.log"
    fi

    cantidadTransaccionesSegunTrailer=`echo "$trailer" | cut -d ',' -f3`
    cantidadTransacciones=`echo "$contenido" | grep -v '^CI.*' -c`

    logInfo $0 "El archivo $i tiene $cantidadTransacciones transacciones contabilizadas y $cantidadTransaccionesSegunTrailer segun el trailer" "../conf/logs/process.log"

    if [ $cantidadTransaccionesSegunTrailer == $cantidadTransacciones ];
	then
        logInfo $0 "El archivo $i tiene $cantidadTransacciones transacciones." "../conf/logs/process.log"
	else
        logInfo $0 "No coinciden la cantidad de transacciones del trailer con las leidas del archivo $i" "../conf/logs/process.log"
        mv $i ../$path_rechazados
		continue
	fi

    #Grabar el cierre de lote
    cd ..
    cd ./$path_salida

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

    IFS_DEFAULT=$IFS
    IFS=$'\n' # para que el "for" separe por linea
    for j in $transacciones
    do
        formatoValido=$(echo "$j" | grep "^.\+,.\+,,,.\+,.\+,.\+,.\+,.\+,.\+,.\+,.\+,.\+,.\+,.*,.\+,.*" -c)

        if [ $formatoValido == 0 ];
        then 
            logAlerta $0 "La transacción tiene un formato inválido." "../conf/logs/process.log"
            continue
        else
            logInfo $0 "La transacción tiene un formato válido." "../conf/logs/process.log"
        fi

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
            logInfo $0 "No tiene mensaje host" "../conf/logs/process.log"
            contenidoCodigoISO=`echo "$codigoISO" | cut -d '>' -f2`
            msjHost=$(cat ../$maestros/codigos.csv | grep "^$contenidoCodigoISO,.*" | sed "s-\([^,]*\)\,\([^,]*\),\([^,]*\)-\2\|\ \3-g" | sed "s-,--g")
        else
            logInfo $0 "Tiene mensaje host y es $msjHost" "../conf/logs/process.log"
        fi

        if [ -z $msjHost ];
        then 
            logAlerta $0 "La transacción tiene un código ISO inválido. Codigo: $contenidoCodigoISO" "../conf/logs/process.log"
            continue
        fi

        contenidoFechaHora=`echo "$fechaHora" | cut -d '>' -f2`
        contenidoImporte=`echo "$importe" | cut -d '>' -f2`
        contenidoAnio=`echo "$anio" | cut -d '>' -f2`

        mes=${contenidoFechaHora:0:2}
        dia=${contenidoFechaHora:2:2}
        hora=${contenidoFechaHora:4:2}:${contenidoFechaHora:6:2}:${contenidoFechaHora:8:2}
        monto=${contenidoImporte:0:10},${contenidoImporte:10:2}

        parseado=$mes,$dia,$hora,$monto
        original=$tipoOperacion,$descripcionOperacion,$anio,$fechaHora,$numeroTarjeta,$vencimiento,$importe,$cuotas,$traceNumber,$codigoISO,$retrievalNumber,$ticketNumber,$autorizacion,$idTrx,$trxRelacionada

        echo $original,"$msjHost",$parseado >> TRX_$contenidoAnio$mes$dia.csv

    done
    IFS=$IFS_DEFAULT

    cd ..
    cd ./$path_aceptados
    mv $i ../$path_procesados

done

cd ..
cd ./$path_bin
