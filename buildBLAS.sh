#!/bin/bash

# Call script with directory as argument. Doesn't accept symbolic links.
DIR="$1"

LAPACK_URL="http://www.netlib.org/lapack/lapack-3.8.0.tar.gz"
MAN_PAGES="http://www.netlib.org/lapack/manpages.tgz"


BLAS_VERSION="3.8.0"
echo "Version: $BLAS_VERSION"

BLAS_FILE="blas-$BLAS_VERSION.tgz"

BLAS_URL="http://www.netlib.org/blas/$BLAS_FILE"
echo "URL: $BLAS_URL"
echo ""

BASEDIR=$(pwd)

set -e

if [ -z "$DIR" ]; then
    echo "Directory not set!"
    exit 1
fi

if [ ! -d "$DIR" ]; then
    echo "Directory does not exist! Creating directory..."
    echo ""
    mkdir "$DIR"
fi

LIB_NAME="libblas.a"

if [ -d "$DIR" ]; then
    cd "$DIR"

    wget "$BLAS_URL"
    tar -xvzf "$BLAS_FILE"

    wget http://www.netlib.org/blas/blast-forum/cblas.tgz
    tar -xvzf cblas.tgz

    cd "BLAS-$BLAS_VERSION"

    gfortran -c -O3 *.f

    ar rv "$LIB_NAME" *.o

    mv "$LIB_NAME" "../CBLAS/lib/$LIB_NAME"

    rm -f *.o

    cd "$BASEDIR"

    cp "exampleMakefile" "$DIR/CBLAS/examples/Makefile"
    cp "Makefile.in" "$DIR/CBLAS/Makefile.in"
    cp "srcMakefile" "$DIR/CBLAS/src/Makefile"

    echo ""
    echo "Building CBLAS library..."
    echo ""
    cd "$DIR/CBLAS/src"
    make all
fi

