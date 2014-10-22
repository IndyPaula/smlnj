#!/bin/bash

# Requires $srcdir (..) and $pkgdir (destdir) to be provided as arguments

export srcdir="$1"
export pkgdir="$2"

URLGETTER="$srcdir/smlnj/urlgetter.sh"

# Parallel builds won't work
unset MAKEFLAGS

# Confuses install.sh
unset SMLNJ_HOME

cd "$srcdir/smlnj"

# Uses $pkgdir
config/install.sh
