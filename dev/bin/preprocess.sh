source ./helpers.sh

path_novedades=$novedades
path_aceptados=$aceptados
path_rechazados=$rechazados
path_procesados=$procesados
path_bin=$bin

if [ -z $init ];
then 
    logAlerta $0 "No esta inicializado." "../conf/logs/process.log"
    exit 1
fi

cd ../$path_novedades

logInfo $0 "Comienza el preprocesamiento." "../conf/logs/process.log"

#Lista de todos los archivos del formato Lote_XX.csv
archivos_procesables=`ls | grep '^Lote_\(0[1-9]\|[1-9][0-9]\).csv'`

#Lista de todos los archivos que no respetan el formato de nombre.
archivos_no_procesables=`ls | grep -v '^Lote_\(0[1-9]\|[1-9][0-9]\).csv'`

#Rechazo los archivos de nombre invalido.
IFS_DEFAULT=$IFS
IFS=$'\n' # para que el "for" separe por linea
for i in $archivos_no_procesables
do
    logInfo $0 "El archivo $i no tiene un nombre valido." "../conf/logs/process.log"
    mv $i ../$path_rechazados
done
IFS=$IFS_DEFAULT

#Preproceso los archivos con nombre valido.
for i in $archivos_procesables
do
	#Valido que el archivo no este vacio.
	if [ -s $i ];
	then
        logInfo $0 "El archivo $i no esta vacio." "../conf/logs/process.log"
	else
        logInfo $0 "El archivo $i esta vacio." "../conf/logs/process.log"
		mv $i ../$path_rechazados
		continue
	fi

    #Valido que el archivo sea de texto
    tipoArchivo=`file $i`
    esArchivoTexto=`echo "$tipoArchivo" | grep '.*text.*' -c`
    if [ $esArchivoTexto == 1 ];
    then
        logInfo $0 "El archivo $i es de un formato valido." "../conf/logs/process.log"
    else
        logInfo $0 "El archivo $i es de un formato invalido." "../conf/logs/process.log"
		mv $i ../$path_rechazados
		continue
    fi

	#Valido que el archivo no haya sido procesado.
	cd ..
	cd ./$path_procesados

	if test -f $i;
	then
		logInfo $0 "El archivo $i ya fue procesado con anterioridad." "../conf/logs/process.log"
		mv $i ../$path_rechazados
		continue
	else
		logInfo $0 "El archivo $i no fue procesado." "../conf/logs/process.log"
	fi

	cd ..
	cd ./$path_novedades

	mv $i ../$path_aceptados

	logInfo $0 "Fin exitoso del preprocesamiento de $i." "../conf/logs/process.log"
done

cd ..
cd ./$path_bin

logInfo $0 "Fin del preprocesamiento." "../conf/logs/process.log"
