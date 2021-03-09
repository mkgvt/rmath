#
# Build standalone libRmath from R.
#
# Dependencies: subversion gfortran zlib libbz2 liblzma libpcre2 libcurl
#

## Version of R and the mirror to use (change as needed)
VERSION   = 4.0.4
MIRROR    = http://ftp.ussg.iu.edu/CRAN/src/base/R-4
SRC       = R-$(VERSION).tar.gz
SRCDIR    = R-$(VERSION)
TIMESTAMP = R-$(VERSION)/TIMESTAMP

TARGETS = COPYING.Rmath lib/libRmath.a lib/libRmath.so include/Rmath.h

.PHONY: all
all: build test docs

.PHONY:
build: lib/libRmath.a lib/libRmath.so include/Rmath.h COPYING.Rmath

.PHONY:
docs: README.html

## Fetch and extract the source code
$(SRC):
	wget $(MIRROR)/$(SRC)

$(SRCDIR): $(TIMESTAMP)

$(TIMESTAMP): $(SRC)
	tar -zxpf $(SRC)
	touch $(TIMESTAMP)

## Propagate license file
COPYING.Rmath: $(SRCDIR)
	cp $(SRCDIR)/COPYING COPYING.Rmath

## Configure with as few of options as possible
$(SRCDIR)/src/Makefile: $(TIMESTAMP)
	cd $(SRCDIR) ; \
	./configure \
		--enable-java=no \
		--enable-byte-compiled-packages=no \
		--enable-static=yes \
		--enable-shared=no \
		--disable-openmp \
		--disable-nls \
		--without-blas \
		--without-lapack \
		--without-readline \
		--without-tcltk \
		--without-cairo \
		--without-libpng \
		--without-libtiff \
		--without-x \
		--without-recommended-packages ; \

#/* #undef MATHLIB_STANDALONE */

## Build libRmath.a and libRmath.so
$(SRCDIR)/src/nmath/standalone/libRmath.a: $(SRCDIR)/src/Makefile
	make -C $(SRCDIR)/src/nmath/standalone

## Save libRmath.a and libRmath.so
lib/libRmath.a: $(SRCDIR)/src/nmath/standalone/libRmath.a
	mkdir -p lib
	cp -p $^ $@

lib/libRmath.so: $(SRCDIR)/src/nmath/standalone/libRmath.so
	mkdir -p lib
	cp -p $^ $@

## Generate C header
include/Rmath.h: $(SRCDIR)/src/include/Rmath.h
	mkdir -p include
	sed 's:/\* #undef MATHLIB_STANDALONE \*/:#define MATHLIB_STANDALONE:' $^ > $@

## Optional: generate HTML
README.html: README.md
	pandoc $^ > $@

## Compile and execute the example as a simple test
#  The file example.out.GOOD has been verified using
#  - https://en.wikipedia.org/wiki/Normal_distribution#Quantile_function
#  - https://en.wikipedia.org/wiki/Student%27s_t-distribution#Table_of_selected_values
.PHONY:
test: tests/example.out
	diff -su tests/example.out.GOOD tests/example.out

tests/example.out: tests/example
	tests/example > tests/example.out

tests/example: include/Rmath.h
tests/example: tests/example.c lib/libRmath.a
	gcc -Wall -o $@ $^ -I ./include -lm

## Clean
.PHONY:
clean:
	rm -rf $(SRCDIR) $(SRC) tests/example tests/example.out README.html

.PHONY: distclean
distclean: clean
	rm -rf COPYING.Rmath include lib
