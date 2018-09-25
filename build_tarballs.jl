# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "LibNUMA"
version = v"2.0.12"

# Collection of sources required to build LibNUMA
sources = [
    "https://github.com/numactl/numactl/releases/download/v2.0.12/numactl-2.0.12.tar.gz" =>
    "55bbda363f5b32abd057b6fbb4551dd71323f5dbb66335ba758ba93de2ada729",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd numactl-2.0.12/
./configure --prefix=$prefix --host=$target
make -j${nproc}
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    Linux(:i686, libc=:musl),
    Linux(:x86_64, libc=:musl),
    Linux(:aarch64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libnuma", Symbol(""))
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

