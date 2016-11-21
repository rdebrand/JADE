#!/bin/bash
set -x
if [ ! -f $1 ]; then
echo "File ->"$1"<- does not exist."
exit
fi
cp  $1 ./datajade.bos
########################################################################
export GFORTRAN_CONVERT_UNIT='big_endian'
cat superv.card   | superv 
#> superv.log
########################################################################
export GFORTRAN_CONVERT_UNIT='native;big_endian:2,22'
cat ze4v.card     | ze4v 
#> ze4v.log
########################################################################
export GFORTRAN_CONVERT_UNIT='native'
cat  jzread.card  | jzread >jzread.log
########################################################################
export GFORTRAN_CONVERT_UNIT='native;big_endian:2,22'
cat  jtjob.card   | jtjob >jtjob.log
########################################################################
#mkdir -p output
#mv *.stat *.bos *.ze4v *.root *.histo *.cprod *.log output


