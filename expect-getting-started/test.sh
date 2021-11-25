#!/bin/bash
echo -n "Ingrese su nombre: "
read name
echo -n "Ingrese su email: "
read email
echo -n "Desea recibir un reporte diario a su email? [s/n]: "
read response
echo
echo "****************************"
echo "Sus datos son: $name <$email>"
echo "Reporte diario: `[ $response = 's' ] && echo 'SI' || echo 'NO'`"
echo "****************************"
