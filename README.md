[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">

  <h3 align="center">GnuCOBOL in WASM</h3>

  <p align="center">
    GnuCOBOL for your browser.
    <a href="https://github.com/wmealing/cob-webber/wiki/">View Demo</a>
    ·
    <a href="https://github.com/wmealing/cob-webber/issues">Report Bug</a>
    ·
    <a href="https://github.com/wmealing/cob-webber/issues">Request Feature</a>
  </p>
</div>



<!-- ABOUT THE PROJECT -->
## About The Project

This is not the official cobweb from cloudflare.   It is something that I am working on to make working in GnuCOBOL work in webassembly to further extend the life of this monster (and I use that term lovingly) 

This projects should allow: basic input and output, working on getting "ncurses" working (not working).


### Built With

- <a href="https://gnucobol.sourceforge.io/">GnuCOBOL</a>
- <a href="https://emscripten.org/">Emscripten</a>
- Love.

<!-- GETTING STARTED -->
## Getting Started

This has been tested on Fedora 36, with the current shipping versions of GnuCOBOL (3.1.2) I have found
that generating the source files, but compiling it with different libcob versions can lead to compile
errors (unsurprisingly). 

This example works for a single .cob file, but I believe it is a good starting point for a more 
complex scenario where there may be multiple cobol source files.

### Prerequisites

- The system will need gnucobol and git installed.  Exactly how this is acheived depends on your operating system and distribution.  The authors configuration is Fedora 36, GnuCOBOL 3.1.2.0,  Other versions may work, but this is what is tested.  Its probably a good idea to match the version of cobol (native) on your system with the built version (3.1.2 ) at this time.

### Installation

Listed below is an example on how to install gnucobol-mode on a Linux:

1. Clone this git repo.

    ```sh
    git clone http://github.com/wmealing/cob-webber.git
    ```

2. Install the submodules.

    At this time, the GnuCOBOL code is entirely in my git tree, because it is hosted
    on sourceforge in a svn repository, and I can't have a subversion submodule.

    However, lets activate the emsdk submodule.

    ```sh
    git submodule init
    git submodule update
    ```

3. Activate the emscripten sdk.

   ```sh
 	cd ./deps/emsdk/
	./emsdk install latest
	./emsdk activate latest
    ```

    The results will tell you to activate the sdk, do so, you may need to modify paths.
    
    ```sh
    source "./deps/emsdk/emsdk_env.sh
    ```

4. Build the tooling.

    ```sh
    make gmp
    make cob
    ```

    Building these individually, gmp and cob should end up putting .a (static archives)
    in the /dist/lib directory.
    
    Optional.
    
    These archives should contain webassembly object files (not native objects).
    This can be verified with the ar command:
    
    ```sh
    $ ar xv dist/lib/libcob.a
    ....
     
    $ file *o
    
     file *o
     call.o:      WebAssembly (wasm) binary module version 0x1 (MVP)
     cobgetopt.o: WebAssembly (wasm) binary module version 0x1 (MVP)
     common.o:    WebAssembly (wasm) binary module version 0x1 (MVP)
     fileio.o:    WebAssembly (wasm) binary module version 0x1 (MVP)
     intrinsic.o: WebAssembly (wasm) binary module version 0x1 (MVP)
     mlio.o:      WebAssembly (wasm) binary module version 0x1 (MVP)
     move.o:      WebAssembly (wasm) binary module version 0x1 (MVP)
     numeric.o:   WebAssembly (wasm) binary module version 0x1 (MVP)
     reportio.o:  WebAssembly (wasm) binary module version 0x1 (MVP)
     screenio.o:  WebAssembly (wasm) binary module version 0x1 (MVP)
     strings.o:   WebAssembly (wasm) binary module version 0x1 (MVP)
     termio.o:    WebAssembly (wasm) binary module version 0x1 (MVP)

   # clean up the object files you just extracted
   $ rm *.o
   
    ```

5. Build your GnuCOBOL code.

    ```sh
    $ ./compile.sh hello_world.cob
    ```

6. Serve up your cobol.

    Serving the page up through a webserver, seemed to work on more browsers,
    there was some odd behavior when it was using file:// urls, so just fire up
    a python webserver (or make it availble over http on your favorite hosting platform)

     ```sh
     python3 -m http.server
     ```

Now visit http://127.0.0.1:8000/out.html in your browser.


## Advanced Usage.

The demonstration compile.sh is a single file compile, it uses a combination of c and GnuCOBOL
conventions to work together. I'm not sure these are the best way, but its what I have working.

The cobc compiler generates a function name to the same name as the function defined as the program id.

Because of this, you can link it with a C program by creating the c code from gnucobol, then calling it
with the known program id (in all caps)

<!-- ROADMAP -->
## Roadmap


* [x] Make my local working example reproduce on my machine
* [x] Upload to github
* [ ] Test it from a completely clean install (container maybe ?)
  * [ ] host an example and take a screenshot
  * [ ] put screenshot in this readme.
* [ ] Make ncurses work
* [ ] Get GnuCOBOL changes upstream (maybe ?)
  *  [ ] Open thread on the sourceforge discussions page.
  *  [ ] Send patch with feedback to the gnucobol legends.

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- LICENSE -->
## License

Distributed under the GPL License. See `LICENSE` for more information.

<!-- CONTACT -->
## Contact

Wade Mealing - [@wademealing](https://twitter.com/wmealing) - on twitter.

Project Link: [https://github.com/wmealing/cob-webber](https://github.com/wmealing/cob-webber)

## FAQ 

Q: Is this different from cobweb ?

A: Yes this is different from the other cobol packages named cobweb.

  - Cobweb the cobol web framework/toolchain:
    - Cobweb is a bunch of tools to run on a webserver, like cgi and more.
    - It does much more than cob-webber, which doesn't do anything like this.

  - Cobweb from cloudflare:
    - Ncurses, updated gnucobol (from 2.2 to 3.1.2)
    - Example program with xterm.js
    - integration with lumen (planned).



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/wmealing/cob-webber.svg?style=for-the-badge
[contributors-url]: https://github.com/wmealing/cob-webber/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/wmealing/cob-webber.svg?style=for-the-badge
[forks-url]: https://github.com/wmealing/cob-webber/network/members
[stars-shield]: https://img.shields.io/github/stars/wmealing/cob-webber.svg?style=for-the-badge
[stars-url]: https://github.com/wmealing/cob-webber/stargazers
[issues-shield]: https://img.shields.io/github/issues/wmealing/cob-webber.svg?style=for-the-badge
[issues-url]: https://github.com/wmealing/cob-webber/issues
[license-shield]: https://img.shields.io/github/license/wmealing/cob-webber.svg?style=for-the-badge
[license-url]: https://github.com/wmealing/cob-webber/blob/master/LICENSE.txt

