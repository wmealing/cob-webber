# WASM BUILD. 


GNUCOBOL_VER=3.1.2

DEPS_OUT = $(PWD)/dist
CFLAGS=-I$(DEPS_OUT)/include -L$(DEPS_OUT)/lib 

all: gmp cob 

gmp: $(DEPS_OUT)/lib/libgmp.a
cob: $(DEPS_OUT)/lib/libcob.a

$(DEPS_OUT)/lib/libgmp.a:
	cd ./deps/gmp-wasm && \
		emconfigure ./configure --disable-assembly --build none --disable-assembly 
	make -C ./deps/gmp-wasm
	rm -rf ./deps/gmp-wasm/*.o

	cd ./deps/gmp-wasm && \
		emconfigure ./configure --disable-assembly --build none \
		--disable-cxx --disable-shared \
		--prefix=$(DEPS_OUT)
	make -C ./deps/gmp-wasm
	make -C ./deps/gmp-wasm install


# mental note, this is patched libcob	        
$(DEPS_OUT)/lib/libcob.a: $(DEPS_OUT)/lib/libgmp.a
	cd ./deps/gnucobol-$(GNUCOBOL_VER) && emconfigure ./configure --host none --build none \
	 	--without-db  CFLAGS="$(CFLAGS)" AR="emar" --disable-hardening \
	 	--with-gmp=$(DEPS_OUT) --prefix=$(DEPS_OUT) 
#	cp gnucobol-no-popen.patch ./deps/gnucobol-$(GNUCOBOL_VER)
#	cp gnucobol-no-dlopen.patch ./deps/gnucobol-$(GNUCOBOL_VER)
#	cp gnucobol-no-unused-arguements.patch ./deps/gnucobol-$(GNUCOBOL_VER)
#	cd ./deps/gnucobol-$(GNUCOBOL_VER) && patch -p0 < gnucobol-no-popen.patch
#	cd ./deps/gnucobol-$(GNUCOBOL_VER) && patch -p0 < gnucobol-no-dlopen.patch
#	cd ./deps/gnucobol-$(GNUCOBOL_VER) && patch -p0 < gnucobol-no-unused-arguements.patch
#	exit 
	make -C ./deps/gnucobol-$(GNUCOBOL_VER) CFLAGS="$(CFLAGS)  -DCOB_BORKED_DLOPEN -DHAVE_UNISTD_H=false"  libcob  
	make -C ./deps/gnucobol-$(GNUCOBOL_VER) install
	cp ./deps/gnucobol-$(GNUCOBOL_VER)/libcob.h $(DEPS_OUT)/include

clean:
	make -C ./deps/gmp-wasm clean || true
	make -C ./deps/gnucobol-$(GNUCOBOL_VER) clean || true
	rm -rf deps/gnucobol-$(GNUCOBOL_VER)/cobc/*.o
	rm -rf deps/gnucobol-$(GNUCOBOL_VER)/libcob/.deps
	rm -rf deps/gnucobol-$(GNUCOBOL_VER)/config.log
	rm -rf ./dist/

test:
	./test.sh
	python3 -m http.server

rst:
	rm -rf ./dist/lib/libcob*
	rm -rf deps/gnucobol-$(GNUCOBOL_VER)/
	cp -rf deps/gnucobol-$(GNUCOBOL_VER).pristine deps/gnucobol-$(GNUCOBOL_VER)
