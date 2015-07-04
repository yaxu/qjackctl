#!/bin/sh

set -e
set -x


########## CONFIGURE
###################################3

if [ ! -f is_configured ] ; then

    cp mingw32/mingw32_config.h src/config.h

    if [ ! -f is_patched ] ; then
        patch -p1 <mingw32/diff.diff
    fi
    touch is_patched

    if [ ! -f is_autogenned ] ; then
        ./autogen.sh
    fi
    touch is_autogenned

    mingw32-qmake-qt4

fi
touch is_configured




######### BUILD
####################################

EXTRAFLAGS="-I../mingw32/weakjack -I../mingw32/include -I../mingw32/portaudio/include  -DNO_JACK_METADATA -DUSE_WEAK_JACK"

mingw32-make CC="i686-w64-mingw32-gcc $EXTRAFLAGS" CXX="i686-w64-mingw32-gcc $EXTRAFLAGS" LINK="../mingw32/linker.sh"





######### DIST
###################################

rm -fr release

mkdir release

cp src/release/qjackctl.exe release/

cp /usr/i686-w64-mingw32/sys-root/mingw/bin/QtCore4.dll release/
cp /usr/i686-w64-mingw32/sys-root/mingw/bin/QtGui4.dll release/
cp /usr/i686-w64-mingw32/sys-root/mingw/bin/QtXml4.dll release/

cp /usr/i686-w64-mingw32/sys-root/mingw/bin/libgcc_s_sjlj-1.dll release/
cp /usr/i686-w64-mingw32/sys-root/mingw/bin/libstdc++-6.dll release/
cp /usr/i686-w64-mingw32/sys-root/mingw/bin/zlib1.dll release/
cp /usr/i686-w64-mingw32/sys-root/mingw/bin/libwinpthread-1.dll release/
cp /usr/i686-w64-mingw32/sys-root/mingw/bin/libpng16-16.dll release/
