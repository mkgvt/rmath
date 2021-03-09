# Load libnmath.a dependencies
with import <nixpkgs> {};
mkShell {
  buildInputs = [
    # Needed to build R's libnmath.a
    subversion
    gfortran
    zlib
    bzip2
    lzma
    pcre2
    curl
    # Needed to extract nmath.h from *.c files
    indent
    # Needed to develop README.md
    pandoc
  ];
}
