function isRunning() {  
  ps -ef | grep ".*$1.*" | grep -v -q grep   
}

function verificarExistenciaDirectorios() {
  for dir in $@
    do echo $dir
    a=$dir
    if [ -d $a ];
    then
    echo "Sí, sí existe."
    else
    echo "Explicar como corregir la no existencia de este directorio '$dir'"
    echo "No, no existe"
    fi
    done
}