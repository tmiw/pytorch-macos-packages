#!/bin/bash

PYTORCH_VERSION=v2.7.1
PYTHON_VERSION=3.12
SYSTEM_ARCH=`uname -m`

git clone -b $PYTORCH_VERSION https://github.com/pytorch/pytorch && cd pytorch && git submodule sync && git submodule update --init --recursive
python$PYTHON_VERSION -m venv torch-venv
. ./torch-venv/bin/activate
pip install -r requirements.txt
if [[ "$SYSTEM_ARCH" == "x86_64" ]]; then
    pip install mkl-static mkl-include
    export USE_MKL=1

    # Make sure system doesn't accidentally compile the wrong architecture
    export CFLAGS="-arch x86_64"
    export CXXFLAGS="-arch x86_64"
else
    export CFLAGS="-arch arm64"
    export CXXFLAGS="-arch arm64"
fi
MAX_JOBS=$(sysctl -n hw.logicalcpu) BUILD_TEST=0 CMAKE_ONLY=1 CC=clang CXX=clang++ CMAKE_OSX_ARCHITECTURES=$SYSTEM_ARCH USE_MIMALLOC=1 MACOSX_DEPLOYMENT_TARGET=11.0 USE_FBGEMM=0  python$PYTHON_VERSION setup.py bdist_wheel --plat-name macosx_11_0_$SYSTEM_ARCH
