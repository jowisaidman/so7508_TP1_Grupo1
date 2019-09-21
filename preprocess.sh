path_novedades='Novedades' #TODO: Cambiar por path configurado.
path_aceptados='Aceptados' #TODO: Cambiar por path configurado.
path_rechazados='Rechazados' #TODO: Cambiar por path configurado.
path_procesados='Procesados' #TODO: Cambiar por path configurado.

cd ./$path_novedades

archivos_procesables=`ls | grep 'Lote_[0-9][0-9]\?\.csv'` #Lista de todos los archivos del formato Lote_XX.csv

for i in $archivos_procesables
do
	if [ -s $i ];
	then
        	echo El archivo $i no esta vacio. #TODO: Meter al log correspondiente.
	else
        	echo El archivo $i esta vacio. #TODO: Meter al log correspondiente.
		mv $i ../$path_rechazados
		continue
	fi

	cd ..
	cd ./$path_procesados

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
