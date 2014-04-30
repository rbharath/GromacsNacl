##!/bin/bash
#
set -eu
export GMX_MAXBACKUP=-1
#
##echo "Installing prerequisite packages"
##( dpkg-query -W -f='${Status}\n'  gcc-multilib | grep "install ok installed" ) || \
##sudo apt-get install gcc-multilib
#
#echo -n "Creating directory structure... "
#
BASE=/home/bramsundar/GromacsNacl/Gromacs

#ROOT=`mktemp -d --tmpdir=/tmp`
ROOT=/tmp/tmp.HiL3NNISuF
echo $ROOT

cd $ROOT
echo "Done."
#
#echo -n "Downloading nacl sdk and patching libnacl.a... "
#wget http://storage.googleapis.com/nativeclient-mirror/nacl/nacl_sdk/nacl_sdk.zip 
#unzip nacl_sdk.zip
#pushd nacl_sdk
#./naclsdk install pepper_33
##cp $BASE/libnacl.a pepper_33/toolchain/linux_x86_newlib/x86_64-nacl/lib/libnacl.a 
#popd
#echo "Done."
#
#echo "Downloading Gromacs sources..."
#wget ftp://ftp.gromacs.org/pub/gromacs/gromacs-4.6.5.tar.gz
#tar -xzf gromacs-4.6.5.tar.gz
#echo "Done."
#
cd gromacs-4.6.5
#
#
#echo -n "Applying the patch..."
#patch -p1 < $BASE/gromacs.patch
#echo "Done."
#
#echo "Building Gromacs with NaCl"
#export PATH=$ROOT/nacl_sdk/pepper_33/toolchain/linux_x86_newlib/x86_64-nacl/bin:\
#$ROOT/nacl_sdk/pepper_33/toolchain/linux_x86_newlib/bin:$PATH
#gcc --version
#
#mkdir -p nacl-build
cd nacl-build
pwd
#cmake -DGMX_CPU_ACCELERATION=SSE2 -DGMX_BUILD_OWN_FFTW=yes -DGMX_PREFER_STATIC_LIBS=yes -DBUILD_SHARED_LIBS=no -DCMAKE_CXX_COMPILER=g++ -DCMAKE_C_COMPILER=gcc ..
#make mdrun -j7 || make mdrun VERBOSE=1
#
#echo -n "Renaming mdrun to mdrun.nexe"
#mv src/kernel/mdrun src/kernel/mdrun.nexe
#echo "Done."

echo "Validating with ncval..."
#$ROOT/nacl_sdk/pepper_33/tools/ncval_x86_64 src/kernel/mdrun.nexe
/tmp/tmp.HiL3NNISuF/nacl_sdk/pepper_33/tools/ncval src/kernel/mdrun.nexe
echo "Done."

echo "mdrun.nexe is available at $ROOT/gromacs-4.6.5/nacl-build/src/kernel/mdrun.nexe"
#$ROOT/nacl_sdk/pepper_33/tools/sel_ldr_x86_64 -B $ROOT/nacl_sdk/pepper_33/tools/irt_core_x86_64.nexe $ROOT/gromacs-4.6.5/nacl-build/src/kernel/mdrun.nexe
#$ROOT/nacl_sdk/pepper_33/tools/sel_ldr_x86_64 -a -B $ROOT/nacl_sdk/pepper_33/tools/irt_core_x86_64.nexe $ROOT/gromacs-4.6.5/nacl-build/src/kernel/mdrun.nexe -v -nt 1 -deffnm md-c2 -noappend
