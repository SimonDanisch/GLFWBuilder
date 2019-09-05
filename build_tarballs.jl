# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

version = v"3.3"

# Collection of sources required to build glfw
sources = [
    "https://github.com/glfw/glfw/archive/3.3.tar.gz" =>
    "81bf5fde487676a8af55cb317830703086bb534c53968d71936e7b48ee5a0f3e",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd glfw-3.3/
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -DBUILD_SHARED_LIBS=ON -DGLFW_BUILD_EXAMPLES=false -DGLFW_BUILD_TESTS=false
make -j${ncore}
make install
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libglfw", :libglfw)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/giordano/Yggdrasil/releases/download/X11-v1.6.8/build_X11.v1.6.8.jl",
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "glfw", version, sources, script, platforms, products, dependencies)
