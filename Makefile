# WASM BUILD. 


GNUCOBOL_VER=3.1.2

DEPS_OUT = $(PWD)/dist
CFLAGS=-I$(DEPS_OUT)/include -L$(DEPS_OUT)/lib 

all: gmp cob 

gmp: $(DEPS_OUT)/lib/libgmp.a
cob: $(DEPS_OUT)/lib/libcob.a
ncurses: $(DEPS_OUT)/lib/libncurses.a

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
	make -C ./deps/gnucobol-$(GNUCOBOL_VER) CFLAGS="$(CFLAGS)  -DCOB_BORKED_DLOPEN -DHAVE_UNISTD_H=false"  libcob  
	make -C ./deps/gnucobol-$(GNUCOBOL_VER) install
	cp ./deps/gnucobol-$(GNUCOBOL_VER)/libcob.h $(DEPS_OUT)/include


fallback:
	# now we build a 'falback terminfo to be embedded in the lib'
	cd ./deps/ncurses-6.1/ncurses && tinfo/MKfallback.sh \
					$(TERMINFO) " " \
					../misc/terminfo.src \
					`which tic` \
					linux vt100 xterm xterm-color >fallback.c

# mental note, this is a patched ncurses.61
$(DEPS_OUT)/lib/libncurses.a: fallback
	# Configure and make the native components
	# the native is used because its used to generate $(GNUCOBOL_VER) during the build process.
	# need terminfo or curses wont work... boo.
	cd ./deps/ncurses-6.1 && ./configure  --without-cxx-binding  --prefix=$(DEPS_OUT) \
					      --disable-gnat-projects \
					      --disable-home-termifo 
	make -C ./deps/ncurses-6.1
#	make -C ./deps/ncurses-6.1 install

	# we end up building it twice but i dont think there is a better way.
	# Configure and make the Emscripten components
	cd ./deps/ncurses-6.1 && emconfigure ./configure --host none \
                                 --without-cxx-binding CFLAGS="$(CFLAGS) "  \
				 --disable-database --disable-gnat-projects \
				 --disable-home-terminfo \
                                 --build none --prefix=$(DEPS_OUT) \
				 --with-fallbacks=linux,vt100,xterm,xterm-color

	# these two patches prevent the webasm version of the webasm builds
	# smashing the native builds.
	make -C ./deps/ncurses-6.1 install.libs
	make -C ./deps/ncurses-6.1 install.data
	make -C ./deps/ncurses-6.1 install.includes

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
