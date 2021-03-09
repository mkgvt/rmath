# nmath: a library of useful statistical functions from R

Need an implementation of a statistical function but don't want to program
your own? Good choice. Don't program your own if there is a battle-hardened
implementation already available.

Many common statistical functions, such as the quantile
of Student's t distribution, have no analytic solution and require a numerical
approximation. The accuracy of the approximation heavily depends on the
approximation chosen and the care with which it is implemented.

Fortunately, there [R Project](https://www.r-project.org/) has a very robust
implementation of many important functions in a library called `nmath`.
Unfortunately, the library has not been made available separate from the R
software environment.

This repo contains a Makefile which compiles `nmath` into a static library and
generates a C header file.

## Building

All the steps for building the library are contained in the Makefile. Simply
run make:

```shell
$ make
```

## Usage

The functions in `libnmath.a` are used in C source code in the usual way:

TODO

```C
#include "nmath.h"

int main(int argc, char *argv[]) {
}
```

## Contributing

1. Fork the repo by clicking on the fork button in the upper right corner of
   the [repo page](https://github.com/mkgvt/nmath) the clone the repo locally
   by either clicking on the download code button or using the command line:

   ```shell
   $ git clone git@github.com:your-github-username/nmath.git
   ```

2. Create your feature branch and make whatever changes you desire:

   ```shell
   $ git checkout -b my-new-feature
   ```

3. Commit your changes:

   ```shell
   $ git commit -am 'Add some feature'
   ```

4. Push to the branch:

   ```shell
   $ git push origin my-new-feature
   ```

5. Submit a pull request through the Github interface.

## Dependencies

An effort has been made to minimize the amount of code that needs to be
compile. Rather than building all of R, only a subset is built. Unfortunately,
that subset includes things that aren't needed in the final library. You will
need to have the following installed even though they aren't needed by the
library.

* subversion
* gfortran
* zlib
* libbz2
* liblzma
* libpcre2
* libcurl

For the convenience of [NixOS](https://nixos.org/) users, a `shell.nix` and an
`.envrc` for installing the dependencies is provided. You can either install
the dependencies manually with

```shell
$ nix-shell
```

or use [`direnv`](https://direnv.net/) with either `nix-shell` or
[`lorri`](https://github.com/target/lorri) to automatically create an
environment with the dependencies installed.

## History

The versions are kept in sync with R. The first version of this repo is from R
4.0.4. Most likely you will want the latest version. Updates will happen
sporadically to the latest version from R at the time of the update.

## Credits

All credit goes to the [R Project](https://www.r-project.org/). All this repo
does is extract and compile the R `nmath` library for use in other projects.

## License

* The source code for `nmath` from R is licensed under the GPL 2.0. A copy of
  the license file (COPYING) from the original source is placed in the the
  same directory as the Makefile after compilation and called COPYING.nmath.

* The files in this repo are also licensed under the GPL 2.0. The license can
  be found in LICENSE. It is identical to the R license file above.
