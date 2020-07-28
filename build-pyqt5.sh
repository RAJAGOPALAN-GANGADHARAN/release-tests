#!/bin/sh -ex

pip3 install sip

PyQt5_DIRNAME="PyQt5-${PyQt5_VERSION}"
PyQt5_ARCHIVE="${PyQt5_DIRNAME}.tar.gz"
curl --progress-bar -L -OJ https://files.pythonhosted.org/packages/source/P/PyQt5/$PyQt5_ARCHIVE
tar xf $PyQt5_ARCHIVE
cd $PyQt5_DIRNAME
# Use --concatenate to speed up build
# Install executables to Qt bin dir to avoid $PATH issues
# Disable modules which are not used in qutebrowser
python3 configure.py --qmake $(which qmake) --bindir=$QTDIR/bin --confirm-license --concatenate \
    --no-designer-plugin \
    --disable=QtMultimedia \
    --disable=QtMultimediaWidgets \
    --disable=QtXml \
    --disable=QtDBus \
    --disable=QtSensors \
    --disable=QtSvg \
    --disable=QtPositioning \
    --disable=QtWebChannel \
    --disable=QtLocation \
    --disable=QtQml \
    --disable=QtQuick
make -j $HOST_N_CORES
sudo make install
cd ..
