

MEMVAR  _HMG_SYSDATA

#include 'hmg.ch'
#include 'hbclass.ch'
#include 'common.ch'

CREATE CLASS TPRINT

DATA cprintlibrary      INIT "MINIPRINT"  PROTECTED
DATA nmhor              INIT (10)/4.75    PROTECTED
DATA nmver              INIT (10)/2.45    PROTECTED
DATA nhfij              INIT (12/3.70)    PROTECTED
DATA nvfij              INIT (12/1.65)    PROTECTED
DATA cunits             INIT "ROWCOL"     PROTECTED
DATA cprinter           INIT ""           PROTECTED

DATA aprinters          INIT {}           PROTECTED
DATA aports             INIT {}           PROTECTED

DATA lprerror           INIT .F.
DATA exit               INIT .F.          PROTECTED
DATA acolor             INIT {1,1,1}      PROTECTED
DATA cfontname          INIT "courier new" PROTECTED
DATA nfontsize          INIT 10            PROTECTED
DATA nwpen              INIT 0.1   PROTECTED //// ancho del pen
DATA tempfile           INIT gettempdir()+"T"+ALLTRIM(STR(int(hb_random(999999)),8))+".prn" PROTECTED
DATA impreview          INIT .F. PROTECTED
DATA cversion            INIT "V1.2" PROTECTED

*-------------------------
METHOD init(clibx)
*-------------------------
*-------------------------
METHOD begindoc(cdoc)
*-------------------------
*-------------------------
METHOD enddoc()

method printdos()
*-------------------------
*-------------------------
METHOD beginpage()
*-------------------------

METHOD condendos()

METHOD NORMALDOS()

*-------------------------
METHOD endpage()
*-------------------------
*-------------------------
METHOD release()
*-------------------------
*-------------------------
METHOD printdata(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen)
*-------------------------
*-------------------------
METHOD printimage
*-------------------------
*-------------------------
METHOD printline
*-------------------------

METHOD printrectangle
*-------------------------

METHOD selprinter( lselect , lpreview, llandscape , npapersize ,cprinterx)
*-------------------------
*-------------------------

METHOD getdefprinter()
*-------------------------

*-------------------------
METHOD setcolor(atColor)
*-------------------------

*-------------------------
METHOD setpreviewsize(ntam)
*-------------------------

*-------------------------
METHOD setunits(cunitsx)   ////// mm o rowcol
*-------------------------

METHOD printroundrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen )

METHOD version()  INLINE ::cversion

ENDCLASS


METHOD condenDOS() CLASS TPRINT
if ::cprintlibrary="DOS"
   @ prow(), pcol() say CHR(15)
endif
return nil


method normaldos() CLASS TPRINT
if ::cprintlibrary="DOS"
   @ prow(), pcol() say CHR(18)
endif
return nil

METHOD setpreviewsize(ntam)
if ntam=NIL .or. ntam>5
   ntam=1
endif
return nil

*-------------------------
METHOD release() CLASS TPRINT
*-------------------------
if ::exit
   return nil
endif
do case
endcase
RETURN NIL


*-------------------------
METHOD init(clibx) CLASS TPRINT
*-------------------------

clibx := NIL   // ADD

if _IsWindowDefined ( "_HMG_PRINTER_SHOWPREVIEW" )
  msgstop("Print preview pending, close first")
  ::exit:=.T.
  return nil
endif

::aprinters:=aprinters()

do case

case ::cprintlibrary="DOS"
     ::impreview:=.F.
endcase

return nil

*-------------------------
METHOD selprinter( lselect , lpreview, llandscape , npapersize ,cprinterx) CLASS TPRINT
*-------------------------
local Worientation, lsucess := .T.
if ::exit
   ::lprerror:=.T.
   return nil
endif

SETPRC(0,0)

DEFAULT llandscape to .F.

do case

case ::cprintlibrary="MINIPRINT"

   if llandscape
      Worientation:= PRINTER_ORIENT_LANDSCAPE
   else
      Worientation:= PRINTER_ORIENT_PORTRAIT
   endif

   if lselect .and. lpreview .and. cprinterx = NIL
      ::cPrinter := GetPrinter()
      If Empty (::cPrinter)
         ::lprerror:=.T.
         Return Nil
      EndIf

      if npapersize#NIL
         SELECT PRINTER ::cprinter to lsucess ;
         ORIENTATION worientation ;
         PAPERSIZE npapersize       ;
         PREVIEW
      else
         SELECT PRINTER ::cprinter to lsucess ;
         ORIENTATION worientation ;
         PREVIEW
      endif
   endif

   if (.not. lselect) .and. lpreview .and. cprinterx = NIL

      if npapersize#NIL
         SELECT PRINTER DEFAULT TO lsucess ;
         ORIENTATION worientation  ;
         PAPERSIZE npapersize       ;
         PREVIEW
      else
         SELECT PRINTER DEFAULT TO lsucess ;
         ORIENTATION worientation  ;
         PREVIEW
      endif
   endif

   if (.not. lselect) .and. (.not. lpreview) .and. cprinterx = NIL

      if npapersize#NIL
         SELECT PRINTER DEFAULT TO lsucess  ;
         ORIENTATION worientation  ;
         PAPERSIZE npapersize
      else
         SELECT PRINTER DEFAULT TO lsucess  ;
         ORIENTATION worientation
      endif
   endif

   if lselect .and. .not. lpreview .and. cprinterx = NIL
      ::cPrinter := GetPrinter()
      If Empty (::cPrinter)
         ::lprerror:=.T.
         Return Nil
      EndIf

      if npapersize#NIL
         SELECT PRINTER ::cprinter to lsucess ;
         ORIENTATION worientation ;
         PAPERSIZE npapersize
      else
         SELECT PRINTER ::cprinter to lsucess ;
         ORIENTATION worientation
      endif
   endif

   if cprinterx # NIL .AND. lpreview
      If Empty (cprinterx)
         ::lprerror:=.T.
         Return Nil
      EndIf

      if npapersize#NIL
         SELECT PRINTER cprinterx to lsucess ;
         ORIENTATION worientation ;
         PAPERSIZE npapersize ;
         PREVIEW
      else
         SELECT PRINTER cprinterx to lsucess ;
         ORIENTATION worientation ;
         PREVIEW
      endif
   endif

   if cprinterx # NIL .AND. .not. lpreview
      If Empty (cprinterx)
         ::lprerror:=.T.
         Return Nil
      EndIf

      if npapersize#NIL
         SELECT PRINTER cprinterx to lsucess ;
         ORIENTATION worientation ;
         PAPERSIZE npapersize
      else
         SELECT PRINTER cprinterx to lsucess ;
         ORIENTATION worientation
      endif
   endif

   IF .NOT. lsucess
      ::lprerror:=.T.
      return nil
   ENDIF

case ::cprintlibrary="DOS"
   do while file(::tempfile)
      ::tempfile:=gettempdir()+"T"+ALLTRIM(STR(int(hb_random(999999)),8))+".prn"
   enddo
   if lpreview
      ::impreview:=.T.
   endif
endcase

RETURN nil



*-------------------------
METHOD BEGINDOC(cdoc) CLASS TPRINT
*-------------------------

do case
case ::cprintlibrary="MINIPRINT"
   START PRINTDOC NAME cDoc   //// modificaicon en esta linea
case ::cprintlibrary="DOS"
   SET PRINTER TO &(::tempfile)
   SET DEVICE TO PRINT
endcase
RETURN self

*-------------------------
METHOD ENDDOC() CLASS TPRINT
*-------------------------
local _nhandle,wr
do case
case ::cprintlibrary="MINIPRINT"
   END PRINTDOC
case ::cprintlibrary="DOS"
   SET DEVICE TO SCREEN
   SET PRINTER TO
   _nhandle:=FOPEN(::tempfile,0+64)
   if ::impreview
         wr:= HB_MemoRead ((::tempfile))   // ADD
   DEFINE WINDOW PRINT_PREVIEW  ;
   	AT 10,10 ;
   	   WIDTH 640 HEIGHT 480 ;
   	   TITLE 'Preview -----> ' + ::tempfile ;
   	   MODAL

   	@ 0,0 EDITBOX EDIT_P ;
   	OF PRINT_PREVIEW ;
   	WIDTH 590 ;
   	HEIGHT 440 ;
   	VALUE WR ;
   	READONLY ;
   	FONT 'Courier new' ;
   	SIZE 10

        @ 10,600 button but_4 caption "X" width 30 action ( print_preview.release() )
        @ 110,600 button but_1 caption "+ +" width 30 action zoom("+")
        @ 210,600 button but_2 caption "- -" width 30 action zoom("-")
        @ 310,600 button but_3 caption "P" width 30 action (::printdos())


   END WINDOW

   CENTER WINDOW PRINT_PREVIEW
   ACTIVATE WINDOW PRINT_PREVIEW

   else

      ::PRINTDOS()

   endif

   IF FILE(::tempfile)
      fclose(_nhandle)
      ERASE &(::tempfile)
   ENDIF
endcase
RETURN self

METHOD SETCOLOR(atColor) CLASS TPRINT
::acolor:=atColor
RETURN NIL

*-------------------------
METHOD beginPAGE() CLASS TPRINT
*-------------------------
do case
case ::cprintlibrary="MINIPRINT"
   START PRINTPAGE
case ::cprintlibrary="DOS"
   @ 0,0 SAY ""
endcase
RETURN self

*-------------------------
METHOD ENDPAGE() CLASS TPRINT
*-------------------------
do case
case ::cprintlibrary="MINIPRINT"
   END PRINTPAGE
case ::cprintlibrary="DOS"
   EJECT
endcase
RETURN self

*-------------------------
METHOD getdefprinter() CLASS TPRINT
*-------------------------
local cdefprinter
do case
case ::cprintlibrary="MINIPRINT"
   cdefprinter:=GetDefaultPrinter()
endcase
RETURN cdefprinter


*-------------------------
METHOD setunits(cunitsx) CLASS TPRINT
*-------------------------

if cunitsx="MM"
   ::cunits:="MM"
else
   ::cunits:="ROWCOL"
endif
RETURN nil

*-------------------------
METHOD printdata(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen) CLASS TPRINT
*-------------------------
local ctext,cspace
// Local i,caux
do case
    case valtype(data)=='C'
                ctext:=data
    case valtype(data)=='N'
                ctext:=ALLTRIM(STR(data))
    case valtype(data)=='D'
                ctext:=dtoc(data)
    case valtype(data)=='L'
               ctext:= iif(data,'T','F')
    case valtype(data)=='M'
               ctext:=data
    otherwise
               ctext:=""
endcase

DEFAULT calign to "L"


DEFAULT nlen to 15

do case
   case calign = "C"
        cspace=  space( (int(nlen)-HMG_LEN(ctext))/2 )
   case calign = "R"
        cspace = space(int(nlen)-HMG_LEN(ctext))
   otherwise
        cspace:=""
endcase

DEFAULT nlin to 1

DEFAULT ncol to 1

DEFAULT ctext to ""

DEFAULT lbold to .F.

DEFAULT cfont to ::cfontname

DEFAULT nsize to ::nfontsize

DEFAULT acolor to ::acolor

if ::cunits="MM"
   ::nmver:=1
   ::nvfij:=0
   ::nmhor:=1
   ::nhfij:=0
else
   ::nmhor  := (::nfontsize)/4.75
   ::nmver  := (::nfontsize)/2.45
   ::nvfij  := (12/1.65)
   ::nhfij  := (12/3.70)
endif

ctext:= cspace + ctext

do case
case ::cprintlibrary="MINIPRINT"
 if .not. lbold
      if calign="R"

       @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2  +((nlen+1)*nsize/4.75) PRINT (ctext) font cfont size nsize COLOR ::acolor RIGHT
      else
         @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 PRINT (ctext) font cfont size nsize COLOR ::acolor
      endif
   else
      if calign="R"
             @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2+((nlen+1)*nsize/4.75) PRINT (ctext) font cfont size nsize  BOLD COLOR ::acolor RIGHT
      else
         @ nlin*::nmver+::nvfij, ncol*::nmhor+ ::nhfij*2 PRINT (ctext) font cfont size nsize  BOLD COLOR ::acolor
      endif
   endif

case ::cprintlibrary="DOS"
   if .not. lbold
       @ nlin,ncol say (ctext)
   else
       @ nlin,ncol say (ctext)
       @ nlin,ncol say (ctext)
   endif
endcase
RETURN self

*-------------------------
METHOD printimage(nlin,ncol,nlinf,ncolf,cimage) CLASS TPRINT
*-------------------------

DEFAULT nlin to 1

DEFAULT ncol to 1

DEFAULT cimage to ""

DEFAULT nlinf to 4

DEFAULT ncolf to 4

if ::cunits="MM"
   ::nmver:=1
   ::nvfij:=0
   ::nmhor:=1
   ::nhfij:=0
else
   ::nmhor  := (::nfontsize)/4.75
   ::nmver  := (::nfontsize)/2.45
   ::nvfij  := (12/1.65)
   ::nhfij  := (12/3.70)
endif
do case
case ::cprintlibrary="MINIPRINT"
   @  nlin*::nmver+::nvfij , ncol*::nmhor+::nhfij*2 PRINT IMAGE cimage WIDTH ((ncolf - ncol-1)*::nmhor + ::nhfij) HEIGHT ((nlinf+0.5 - nlin)*::nmver+::nvfij)
endcase
RETURN nil


*-------------------------
METHOD printline(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPRINT
*-------------------------

DEFAULT nlin to 1

DEFAULT ncol to 1

DEFAULT nlinf to 4

DEFAULT ncolf to 4

DEFAULT atcolor to ::acolor

DEFAULT ntwpen to ::nwpen

if ::cunits="MM"
   ::nmver:=1
   ::nvfij:=0
   ::nmhor:=1
   ::nhfij:=0
else
   ::nmhor  := (::nfontsize)/4.75
   ::nmver  := (::nfontsize)/2.45
   ::nvfij  := (12/1.65)
   ::nhfij  := (12/3.70)
endif


do case
case ::cprintlibrary="MINIPRINT"
   @  (nlin+.2)*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 PRINT LINE TO  (nlinf+.2)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2  COLOR atcolor PENWIDTH ntwpen  //// CPEN
case ::cprintlibrary="DOS"
  if nlin=nlinf
     @ nlin,ncol say REPLICATE("-",ncolf-ncol+1)
  endif
endcase
RETURN nil

*-------------------------
METHOD printrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPRINT
*-------------------------


DEFAULT nlin to 1

DEFAULT ncol to 1

DEFAULT nlinf to 4

DEFAULT ncolf to 4

DEFAULT atcolor to ::acolor

DEFAULT ntwpen to ::nwpen

if ::cunits="MM"
   ::nmver:=1
   ::nvfij:=0
   ::nmhor:=1
   ::nhfij:=0
else
   ::nmhor  := (::nfontsize)/4.75
   ::nmver  := (::nfontsize)/2.45
   ::nvfij  := (12/1.65)
   ::nhfij  := (12/3.70)
endif
do case
case ::cprintlibrary="MINIPRINT"
   @  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 PRINT RECTANGLE TO  (nlinf+0.5)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2 COLOR atcolor  PENWIDTH ntwpen  //// CPEN
endcase
RETURN nil


METHOD printroundrectangle(nlin,ncol,nlinf,ncolf,atcolor,ntwpen ) CLASS TPRINT
*-------------------------

DEFAULT nlin to 1

DEFAULT ncol to 1

DEFAULT nlinf to 4

DEFAULT ncolf to 4

DEFAULT atcolor to ::acolor

DEFAULT ntwpen to ::nwpen

if ::cunits="MM"
   ::nmver:=1
   ::nvfij:=0
   ::nmhor:=1
   ::nhfij:=0
else
   ::nmhor  := (::nfontsize)/4.75
   ::nmver  := (::nfontsize)/2.45
   ::nvfij  := (12/1.65)
   ::nhfij  := (12/3.70)
endif
do case
case ::cprintlibrary="MINIPRINT"
   @  nlin*::nmver+::nvfij,ncol*::nmhor+::nhfij*2 PRINT RECTANGLE TO  (nlinf+0.5)*::nmver+::nvfij,ncolf*::nmhor+::nhfij*2 COLOR atcolor  PENWIDTH ntwpen  ROUNDED //// CPEN
endcase
RETURN nil

method printdos() CLASS TPRINT
local cbat, nHdl
    cbat:='b'+ALLTRIM(STR(random(999999),6))+'.bat'
    nHdl := FCREATE( cBat )
    FWRITE( nHdl, "copy " + ::tempfile + " prn" + CHR( 13 ) + CHR( 10 ) )
    FWRITE( nHdl, "rem comando auxiliar de impresion" + CHR( 13 ) + CHR( 10 ) )
    FCLOSE( nHdl )
    waitrun( cBat, 0 )
    erase &cbat
return nil


STATIC function zoom(cOp)

if cop="+" .and. print_preview.edit_p.fontsize <= 24
  print_preview.edit_p.fontsize:=  print_preview.edit_p.fontsize + 2
endif

if cop="-" .and. print_preview.edit_p.fontsize > 7
  print_preview.edit_p.fontsize:=  print_preview.edit_p.fontsize - 2
endif
return nil


