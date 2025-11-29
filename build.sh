#!/bin/bash

PYTORCH_VERSION=v2.9.1
PYTHON_VERSION=3.14
SYSTEM_ARCH=`uname -m`

git clone -b $PYTORCH_VERSION https://github.com/pytorch/pytorch && cd pytorch && git submodule sync && git submodule update --init --recursive
chmod -R 777 .
python$PYTHON_VERSION -m venv torch-venv
. ./torch-venv/bin/activate
pip install -r requirements.txt
#if [[ "$SYSTEM_ARCH" == "x86_64" ]]; then
#    pip install mkl mkl-devel mkl-static mkl-include
#fi
_PYTHON_HOST_PLATFORM=macos-11.0-$SYSTEM_ARCH CMAKE_POLICY_VERSION_MINIMUM=3.5 MAX_JOBS=$(sysctl -n hw.logicalcpu) CMAKE_OSX_ARCHITECTURES=$SYSTEM_ARCH BUILD_TEST=0 CC=clang CXX=clang++ MACOSX_DEPLOYMENT_TARGET=11.0 USE_FBGEMM=0 USE_MIMALLOC=1  python$PYTHON_VERSION setup.py bdist_wheel -d "$(pwd)" --plat-name macosx_11_0_$SYSTEM_ARCH
