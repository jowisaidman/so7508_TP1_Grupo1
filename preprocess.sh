#TODO: Cambiar para que tome los paths configurados.
path_novedades='Novedades'
path_aceptados='Aceptados'
path_rechazados='Rechazados'
path_procesados='Procesados'

cd ./$path_novedades

#Lista de todos los archivos del formato Lote_XX.csv
archivos_procesables=`ls | grep 'Lote_[0-9][0-9]\?\.csv'`

#Lista de todos los archivos que no respetan el formato de nombre.
archivos_no_procesables=`ls | grep -v 'Lote_[0-9][0-9]\?\.csv'`

#Rechazo los archivos de nombre invalido.
for i in $archivos_no_procesables
do
    echo El archivo $i no tiene un nombre valido.
    mv $i ../$path_rechazados
done

for i in $archivos_procesables
do
	#Valido que el archivo no este vacio.
	if [ -s $i ];
	then
        echo El archivo $i no esta vacio.
	else
        echo El archivo $i esta vacio.
		mv $i ../$path_rechazados
		continue
	fi

	cd ..
	cd ./$path_procesados

	#Valido que el archivo no haya sido procesado.
	if test -f $i;
	then
		echo El archivo $i ya fue procesado con anterioridad.
		mv $i ../$path_rechazados
		continue
	else
		echo El archivo $i no fue procesado.
	fi

	cd ..
	cd ./$path_novedades

	mv $i ../$path_aceptados

	echo Fin exitoso del preprocesamiento de $i.
done
