#!/bin/bash
set -x
if [ -z ${CMAKE+x} ]; then
export CMAKE=cmake
fi
mkdir -p jadesoft/bin
export TOP=$(pwd)/installed
mkdir -p $TOP
########################################################################
cd picocernlib
rm -rf outputs CMakeFiles  CMakeCache.txt
$CMAKE CMakeLists.txt -DCMAKE_Fortran_COMPILER=gfortran -DCMAKE_INSTALL_PREFIX=$TOP
make -f Makefile clean
make -f Makefile  ||  { echo 'make failed' ; exit 1; }
make install
cd ..

########################################################################
cd jadesoft
rm -rf outputs CMakeFiles  CMakeCache.txt
$CMAKE CMakeLists.txt -DCMAKE_Fortran_COMPILER=gfortran  -DCMAKE_INSTALL_PREFIX=$TOP  -DPICOCERNLIB=$TOP/lib64/libpicocernlib.a
make -f Makefile clean
make -f Makefile   ||  { echo 'make failed' ; cat CMakeCache.txt; exit 1; }
make install
cd ..
########################################################################
cd convert
rm -rf outputs CMakeFiles  CMakeCache.txt
$CMAKE CMakeLists.txt -DCMAKE_Fortran_COMPILER=gfortran  -DCMAKE_INSTALL_PREFIX=$TOP
make -f Makefile clean
make -f Makefile  ||  { echo 'make failed' ; exit 1; } 
make install
cd ..

########################################################################
cd jtuple
rm -rf outputs CMakeFiles  CMakeCache.txt
$CMAKE CMakeLists.txt -DCMAKE_Fortran_COMPILER=gfortran  -DCMAKE_INSTALL_PREFIX=$TOP  -DPICOCERNLIB=$TOP/lib64/libpicocernlib.a -DJADELIB_ROOT_DIR=$TOP
make -f Makefile clean
make -f Makefile  ||  { echo 'make failed' ; exit 1; }
make install
cd ..
########################################################################
cd fptobos
rm -rf outputs CMakeFiles  CMakeCache.txt
$CMAKE CMakeLists.txt -DCMAKE_Fortran_COMPILER=gfortran  -DCMAKE_INSTALL_PREFIX=$TOP  -DPICOCERNLIB=$TOP/lib64/libpicocernlib.a -DJADELIB_ROOT_DIR=$TOP
make -f Makefile clean
make -f Makefile  ||  { echo 'make failed' ; exit 1; }
make install
cd ..
