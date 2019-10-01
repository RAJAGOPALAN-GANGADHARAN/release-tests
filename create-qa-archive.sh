#!/bin/sh -ex
find $QTDIR -name '*.debug' -exec rm {} \;
find $QTDIR -name '*.a' -exec rm {} \;
find $QTDIR -name '*.la' -exec rm {} \;
find $QTDIR -name '*.prl' -exec rm {} \;
find $QTDIR -name '*.lib' -exec rm {} \;
find $QTDIR -name '*d.dll' -exec rm {} \;
rm -rf $QTDIR/include
rm -rf $QTDIR/doc
rm -rf $QTDIR/mkspecs
rm -rf $QTDIR/lib/cmake
rm -rf $QTDIR/lib/pkgconfig
7z a -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on qa-${TRAVIS_JOB_NUMBER}-${TRAVIS_OS_NAME}.7z $QTDIR
du -hs qa-${TRAVIS_JOB_NUMBER}-${TRAVIS_OS_NAME}.7z
md5sum qa-${TRAVIS_JOB_NUMBER}-${TRAVIS_OS_NAME}.7z
