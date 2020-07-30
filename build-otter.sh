#!/bin/bash -ex
git clone --depth 1 https://github.com/OtterBrowser/otter-browser.git
mkdir otter-browser-build
cmake -Botter-browser-build -Hotter-browser -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$QTDIR $CMAKE_ARGS -G "$CMAKE_GENERATOR"
cmake --build otter-browser-build --config Release -j $HOST_N_CORES
echo "Built successfully, trying to run result"
export QT_QPA_PLATFORM=minimal
UNAME=$(uname)

BUILD_DIR=otter-browser-build
if [ "${CMAKE_GENERATOR:0:5}" = "Visua" ]; then
    BUILD_DIR=otter-browser-build/Release
fi

ls -la $BUILD_DIR

if [ "$UNAME" = "Darwin" ]; then
    "$BUILD_DIR/Otter Browser.app/Contents/MacOS/Otter Browser" --version
else
    $BUILD_DIR/otter-browser --version
fi

PYTHON=python3
if which py >& /dev/null; then
    PYTHON=py
fi
### msvc
# QT_INSTALL_DIR/Tools/OpenSSL/Win_x64/   libcrypto-1_1-x64.dll  libssl-1_1-x64.dll
### mingw
# 
mkdir otter-browser-packages

if [ "$TOOLCHAIN" = "win64_msvc2017_64" ]; then
    PREFIX="$QT_INSTALL_DIR/Tools/OpenSSL/Win_x64/bin"
    $PYTHON otter-browser/packaging/deploy.py --build-path=$BUILD_DIR --target-path=otter-browser-packages --extra-libs $PREFIX/libcrypto-1_1-x64.dll $PREFIX/libssl-1_1-x64.dll 
elif [ "$TOOLCHAIN" = "win32_msvc2017" ]; then
    PREFIX="$QT_INSTALL_DIR/Tools/OpenSSL/Win_x86/bin"
    $PYTHON otter-browser/packaging/deploy.py --build-path=$BUILD_DIR --target-path=otter-browser-packages --extra-libs $PREFIX/libcrypto-1_1.dll $PREFIX/libssl-1_1.dll 
elif [ "$TOOLCHAIN" = "win32_mingw73" ]; then
    PREFIX="$QT_INSTALL_DIR/Tools/mingw730_32/opt/bin"
    $PYTHON otter-browser/packaging/deploy.py --build-path=$BUILD_DIR --target-path=otter-browser-packages --extra-libs $PREFIX/ssleay32.dll $PREFIX/libeay32.dll 
else
    $PYTHON otter-browser/packaging/deploy.py --build-path=$BUILD_DIR --target-path=otter-browser-packages
fi

find otter-browser-packages
