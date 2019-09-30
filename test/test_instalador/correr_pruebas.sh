#!/bin/bash
echo "Bienvenido, en este script se correran todas las pruebas disponibles para el instalador. Cada prueba tiene un escenario que servira unicamente para la primera vez que se corre este script."
echo ""
read -p "La prueba finalizo. Precione cualquier tecla para comenzar..."
clear
echo ""
echo "#########################################"
echo "#     PRUEBA 1: PRIMERA INSTALACION     #"
echo "#########################################"
echo ""
cd test_primera_instalacion
bash install.sh
cd ..
echo ""
read -p "La prueba finalizo. Precione cualquier tecla para continuar a la siguiente prueba..."
clear
echo ""
echo "#######################################################"
echo "#     PRUEBA 2: REINSTALACION, CARPETAS FALTANTES     #"
echo "#######################################################"
echo ""
cd test_reinstalacion_carpetas_faltantes
bash install.sh
cd ..
echo ""
read -p "La prueba finalizo. Precione cualquier tecla para continuar a la siguiente prueba..."
clear
echo ""
echo "##############################################################"
echo "#     PRUEBA 3: REINSTALACION, ARCHIVO CONFIG.TXT DAÑADO     #"
echo "##############################################################"
echo ""
cd test_reinstalacion_configtxt_dañado
bash install.sh
cd ..
echo ""
read -p "La prueba finalizo. Precione cualquier tecla para continuar a la siguiente prueba..."
clear
echo ""
echo "#######################################################"
echo "#     PRUEBA 4: REINSTALACION, FALTAN EJECUTABLES     #"
echo "#######################################################"
echo ""
cd test_reinstalacion_ejecutables_faltantes
bash install.sh
cd ..
echo ""
read -p "La prueba finalizo. Precione cualquier tecla para continuar a la siguiente prueba..."
clear
echo ""
echo "#############################################################"
echo "#     PRUEBA 5: REINSTALACION, FALTA ARCHIVO CONFIG.TXT     #"
echo "#############################################################"
echo ""
cd test_reinstalacion_falta_configtxt
bash install.sh
cd ..
