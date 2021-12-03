# Scripts to compile HMG on GitHub

These scripts are to compile HMG official 32bit unicode with MinGW 9.30

  - 2020-10-27  hmg34offi_libhmg_hb32_mgw930_32b_uni.yml
  
      Output= HMG library.

  - 2020-10-27  hmg34offi_all_hb32_mgw930_32b_uni.yml
  
      Output= All HMG libraries.

  - 2020-10-27  hb32_mgw930_32b_2020_10_27.zip
  
      Harbour binaries compiled, ziped.

  - 2020-10-27  hmg34asistex_all_hb32_mgw930_32b_uni.yml
  
      Output= All HMG libraries. with asistex sources

### Compile HMG on different forks

 To compile your fork you should replace the lines where exist "HMG-Official/HMG" in yaml scripts and put your github fork site.

 **Avoid to change this line unless you have a different source of harbour binaries**

         (new-object System.Net.WebClient).DownloadFile('https://github.com/asistex/HMG/raw/master/workflows/hb32_mgw930_32b_2020_10_27.zip', 'C:\temp\harbour.zip')


replace
 ```
    - name: Checkout hmg repo
      uses: actions/checkout@v2
      with:
        repository: HMG-Official/HMG
        path: HMG-Official/HMG
  to
    - name: Checkout hmg repo
      uses: actions/checkout@v2
      with:
        repository: asistex/HMG
        path: asistex/HMG


      run: |
        cd HMG-Official\hmg
  to
      run: |
        cd asistex\hmg


      run: |
        mkdir output
        robocopy HMG-Official\hmg\ output\ /E
  to
      run: |
        mkdir output
        robocopy asistex\hmg\ output\ /E
 ```


### HMG official
  https://github.com/HMG-Official/HMG

### harbour source
  https://github.com/asistex/HMG/raw/master/workflows/hb32_mgw930_32b_2020_10_27.zip
  * set HB_BUILD_MODE=c
  * set HB_USER_PRGFLAGS=-l-
  * set HB_BUILD_PARTS=all
  * set HB_BUILD_CONTRIBS= 
  * set HB_WITH_OPENSSL=C:\OpenSSL\include
  * set HB_WITH_CURL=C:\curl\include
  * set HB_WITH_ADS=C:\acesdk 
  * set HB_STATIC_OPENSSL=yes
  * set HB_STATIC_CURL=yes       
  * set HB_COMPILER=mingw
  * set HB_BUILD_CONTRIB_DYN=no
  * set HB_BUILD_DYN=no
  * set HB_WITH_LIBHARU=c:\harbour\contrib\hbhpdf


### mingw source
  https://bitbucket.org/lorenzodla/mod_harbour_actions_resources/downloads/mingw32.zip
  * gcc version

    winlibs personal build version gcc-9.3.0-llvm-10.0.0-mingw-w64-7.0.0-r4

    This is the winlibs 32-bit standalone build of:

     - GCC 9.3.0
     - GDB 9.1
     - LLVM/Clang/LLD/LLDB 10.0.0- MinGW-w64 7.0.0
     - GNU Binutils 2.34
     - GNU Make 4.3
     - PExports 0.47
     - dos2unix 7.4.1
     - Yasm 1.3.0
     - NASM 2.14.02

     This build was compiled with GCC 9.3.0 on 2020-04-29.
     Please check out http://winlibs.com/ for the latest personal build.
