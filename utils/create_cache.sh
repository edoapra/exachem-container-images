#!/bin/bash
# arg: local of container image
if [ -z "$1" ]; then
    echo "*** create_cache.sh not set"
    echo "*** defaulting to exachem.simg"
    myimg=exachem.simg
else
    myimg=$1
fi
        mkdir -p ~/cache || true
        apptainer exec $myimg cp -r /opt/mpi ~/cache
        apptainer exec $myimg ls -l /opt/install/exachem/include || true
        apptainer exec $myimg ls -l /opt/install/exachem || true
        VER=$(apptainer exec $myimg ls -l /opt/install/exachem/lib/libint2.so.2 |tail |cut -d . -f 5-)
        echo $?
        echo @@@ $VER @@@
        if [  -z $VER ] ; then libint_libs=" /opt/install/exachem/lib/libint2.a"  ; else \
        libint_libs="/opt/install/exachem/lib/libint2.so /opt/install/exachem/lib/libint2.so.2 /opt/install/exachem/lib/libint2.so.$VER"
        fi
        echo libint_libs is $libint_libs
        apptainer exec $myimg tar -chjvf ~/cache/libint.tar.bz2 /opt/install/exachem/include/libint2/  /opt/install/exachem/include/libint2.hpp /opt/install/exachem/include/libint2.h  /opt/install/exachem/share/libint /opt/install/exachem/lib/cmake/libint2 $libint_libs   /opt/install/exachem/lib/libeigen_blas.so /opt/install/exachem/lib/libeigen_blas_static.a /opt/install/exachem/lib/libeigen_lapack.so /opt/install/exachem/lib/libeigen_lapack_static.a /opt/install/exachem/share/eigen3 /opt/install/exachem/include/eigen3 /opt/install/exachem/share/pkgconfig/eigen3.pc
        VER=$(apptainer exec $myimg ls -l /opt/install/exachem/lib/libxc.so |tail |cut -d . -f 4-)
        echo $?
        echo @@@ $VER @@@
        if [  -z $VER ] ; then libxc_libs=" /opt/install/exachem/lib/libxc.a"  ; else \
        libxc_libs="/opt/install/exachem/lib/libxc.so /opt/install/exachem/lib/libxc.so.$VER"
        fi
        echo libxc_libs is $libxc_libs
        apptainer exec $myimg tar cjvf ~/cache/libxc.tar.bz2  $libxc_libs  /opt/install/exachem/lib/pkgconfig/libxc.pc /opt/install/exachem/lib/cmake/Libxc /opt/install/exachem/bin/xc-info \
        /opt/install/exachem/include/xc.h /opt/install/exachem/include/xc_funcs.h /opt/install/exachem/include/xc_funcs_removed.h /opt/install/exachem/include/xc_funcs_worker.h /opt/install/exachem/include/xc_version.h
        ELPA_VER=$(apptainer exec $myimg ls /opt/install/exachem/include/ 2> /dev/null|grep elpa|tail -1 |cut -d - -f 2)
        if [ ! -z $ELPA_VER ] ; then \
        libelpa_libs=/opt/install/exachem/lib/libelpa.a
        VER=$(apptainer exec $myimg ls -l /opt/install/exachem/lib/libelpa.so |tail |cut -d . -f 4-)
        VER2=$(echo $VER |cut -d . -f 1)
        if [ ! -z $VER ]; then libelpa_libs="$libelpa_libs /opt/install/exachem/lib/libelpa.so /opt/install/exachem/lib/libelpa.so.$VER /opt/install/exachem/lib/libelpa.so.$VER2"; fi
        echo libelpa_libs $libelpa_libs
        apptainer exec $myimg tar cjvf ~/cache/libelpa.tar.bz2  /opt/install/exachem/include/elpa-$ELPA_VER /opt/install/exachem/lib/pkgconfig/elpa.pc $libelpa_libs
        fi

