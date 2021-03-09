# Rmath: a library of useful statistical functions from R

Need an implementation of a statistical function? Many common statistical
functions, such as the quantile of Student's t distribution, have no analytic
solution and require a numerical approximation. The accuracy of the
approximation heavily depends on the approximation chosen and the care with
which it is implemented. Don't program your own if there is a battle-hardened
implementation already available.


Fortunately, there [R Project](https://www.r-project.org/) has a very robust
implementation of many important functions in a library called `Rmath`. It is
also fortunate that the developers have made it relatively easy to build a
standalone version of the library.

This repo contains a `Makefile` which downloads the R source and compiles
`Rmath`. The following files will be available after running `make`.

* include/Rmath.h
* lib/libRmath.a
* lib/libRmath.so

## Building

All the steps for building the library are contained in the Makefile. Simply
run `make` to build then `make test` to perform a simple check.

```shell
$ make
$ make test
```

If the example program built during the simple test phase passes, it will
report that the output is identical to what was expected.

## Usage

The file `tests/example.c` shows how to use the library. The `Makefile` also
gives an example of how to compile the example and link against `libRmath.a`.

Note: there is no documentation for the standalone functions in `libRmath` but
each requires the same arguments which the corresponding R function uses.
Thus, the [R manuals](https://cran.r-project.org/manuals.html) can be used.

## Contributing

1. Fork the repo by clicking on the fork button in the upper right corner of
   the [repo page](https://github.com/mkgvt/rmath) then clone the repo locally
   by either clicking on the download code button or using the command line:

   ```shell
   $ git clone git@github.com:your-github-username/rmath.git
   ```

2. Create a branch and make whatever changes you desire:

   ```shell
   $ git checkout -b fix-bug-foo
   ```

3. Commit your changes:

   ```shell
   $ git commit -am 'Fixes bug foo'
   ```

4. Push to the branch:

   ```shell
   $ git push origin fix-bug-foo
   ```

5. Submit a pull request through the Github interface.

## Dependencies

An effort has been made to minimize the amount of code that needs to be
compiled. Rather than building all of R, only a subset is built. Unfortunately,
that subset includes things that aren't needed in the final library. You will
need to have the following installed even though they aren't used by anything
but the configuration script.

* subversion
* gfortran
* zlib
* libbz2
* liblzma
* libpcre2
* libcurl

For the convenience of [NixOS](https://nixos.org/) developers, a `shell.nix`
and an `.envrc` for installing the dependencies is provided. You can either
install the dependencies manually with

```shell
$ nix-shell
```

or use [`direnv`](https://direnv.net/) with either `nix-shell` or
[`lorri`](https://github.com/target/lorri) to automatically create an
environment with the dependencies installed.

## History

The versions are kept in sync with R. The first version of this repo is from R
4.0.4. Most likely you will want the latest version. Updates will happen
sporadically to the latest version from R at the time of the update. Please
feel empowered to update to a newer version, test to make sure the example
still works, and submit a pull request.

## Credits

All credit goes to the [R Project](https://www.r-project.org/). All this repo
does is compile the `Rmath` library for use in other projects.

## Licenses

* The source code for `Rmath` from R is licensed under the GPL 2.0. A copy of
  the license file (COPYING) from the original source is placed in the the
  same directory as the Makefile after compilation and called COPYING.rmath.

* The files in this repo are also licensed under the GPL 2.0. The license can
  be found in LICENSE. It is identical to the R license file above.
