#!/bin/bash

set -eu

echo "Installing prerequisite packages"
( dpkg-query -W -f='${Status}\n'  gcc-multilib | grep "install ok installed" ) || \
sudo apt-get install gcc-multilib

echo -n "Creating directory structure... "

BASE=`pwd`

ROOT=`mktemp -d --tmpdir=/tmp`
echo $ROOT

cd $ROOT
echo "Done."

echo -n "Downloading nacl sdk and patching libnacl.a... "
wget http://storage.googleapis.com/nativeclient-mirror/nacl/nacl_sdk/nacl_sdk.zip 
unzip nacl_sdk.zip
pushd nacl_sdk
./naclsdk install pepper_27
cp $BASE/libnacl.a pepper_27/toolchain/linux_x86_newlib/x86_64-nacl/lib/libnacl.a 
popd
echo "Done."

echo "Downloading Gromacs sources..."
wget ftp://ftp.gromacs.org/pub/gromacs/gromacs-4.6.2.tar.gz
tar -xzf gromacs-4.6.2.tar.gz
echo "Done."

cd gromacs-4.6.2

echo -n "Applying the patch..."
patch -p1 < $BASE/gromacs.patch
echo "Done."

echo "Building Gromacs with NaCl"
export PATH=$ROOT/nacl_sdk/pepper_27/toolchain/linux_x86_newlib/x86_64-nacl/bin:\
$ROOT/nacl_sdk/pepper_27/toolchain/linux_x86_newlib/bin:$PATH
gcc --version

mkdir nacl-build
cd nacl-build
cmake -DGMX_CPU_ACCELERATION=SSE2 -DGMX_BUILD_OWN_FFTW=yes -DGMX_PREFER_STATIC_LIBS=yes -DBUILD_SHARED_LIBS=no .. 
make mdrun -j7 || make mdrun VERBOSE=1

echo -n "Renaming mdrun to mdrun.nexe"
mv src/kernel/mdrun src/kernel/mdrun.nexe
echo "Done."

echo "Validating with ncval..."
$ROOT/nacl_sdk/pepper_27/tools/ncval_x86_64 src/kernel/mdrun.nexe
echo "Done."

echo "mdrun.nexe is available at $ROOT/gromacs-4.6.2/nacl-build/src/kernel/mdrun.nexe"
