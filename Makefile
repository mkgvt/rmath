#
# Build libnmath from R.
#
# Dependencies: subversion gfortran zlib libbz2 liblzma libpcre2 libcurl
#

## Version of R and the mirror to use (change as needed)
VERSION   = 4.0.4
MIRROR    = http://ftp.ussg.iu.edu/CRAN/src/base/R-4
SRC       = R-$(VERSION).tar.gz
SRCDIR    = R-$(VERSION)
TIMESTAMP = R-$(VERSION)/TIMESTAMP

TARGETS = COPYING.nmath lib/libnmath.a include/nmath.h

.PHONY: all
all: $(TARGETS)

## Fetch and extract the source code
$(SRC):
	wget $(MIRROR)/$(SRC)

$(SRCDIR): $(TIMESTAMP)

$(TIMESTAMP): $(SRC)
	tar -zxpf $(SRC)
	touch $(TIMESTAMP)

## Propagate license file
COPYING.nmath: $(SRCDIR)
	cp $(SRCDIR)/COPYING COPYING.nmath

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
	ORIG="SUBDIRS = scripts include extra appl nmath unix main modules library" ; \
	NEW="SUBDIRS = include nmath" ; \
	sed -i.orig "s/$$ORIG/$$NEW/" src/Makefile

## Build libnmath.a
$(SRCDIR)/src/nmath/libnmath.a: $(SRCDIR)/src/Makefile
	cd $(SRCDIR) && make R

## Save libnmath.a
lib/libnmath.a: $(SRCDIR)/src/nmath/libnmath.a
	mkdir -p lib
	cp -p $^ $@

## Generate C header
#  Use indent to clean up sources so that the functions are of the form
#  "^double function(<args>)" which makes it easier to extract them.
include/nmath.h: $(SRCDIR)/src/Makefile.orig
	mkdir -p include
	echo '/* Generated from $(SRCDIR)/src/nmath/*.c */' > $@ ; \
	echo '#ifndef __NMATH_H' >> $@ ; \
	echo '#define __NMATH_H' >> $@ ; \
	for f in $(SRCDIR)/src/nmath/*.c ; do \
		(indent -kr -l200 $$f -st 2>/dev/null || true) \
			| grep -h ^double \
			| egrep -v 'attribute_hidden|F77_NAME|atanpi| = ' \
			| sed -e 's/^/extern /' -e 's/$$/;/' \
			| sort -u >> $@ ; \
	done ; \
	echo '#endif' >> $@

## Optional: generate HTML
README.html: README.md
	pandoc $^ > $@

## Compile and execute the example
example: example.c include/nmath.h lib/libnmath.a
	gcc -Wall -o example example.c -I ./include -L ./lib -lnmath

## Clean
.PHONY:
clean:
	rm -rf $(SRCDIR) $(SRC)

.PHONY: distclean
distclean: clean
	rm -rf COPYING.nmath include lib
