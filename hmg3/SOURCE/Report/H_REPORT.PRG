/*
 * DO REPORT Command support procedures For HMG Library.
 * (c) Ciro vargas Clemow [gerente@sistemascvc.com]

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this file.

 The exception is that, if you link this code with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking
 this code into it.

*/
MEMVAR _HMG_SYSDATA
#include 'hbclass.ch'
#include 'common.ch'
#include 'hmg.ch'


MEMVAR CLINEA
MEMVAR OPRINT
MEMVAR LNOPROP
MEMVAR CLINEA1
MEMVAR CLINEA2
MEMVAR NSPACE
MEMVAR TI
MEMVAR NMEMO
MEMVAR WFIELDT
MEMVAR _HMG_PRINTLIBRARY
MEMVAR SWMEMO



MEMVAR NPOS
MEMVAR NPOS1
MEMVAR NPOS2
MEMVAR LIN
MEMVAR SW
MEMVAR SW1
MEMVAR CREPORT
MEMVAR cgraphicalt
MEMVAR WLARLIN
MEMVAR AFIELDS
MEMVAR LSELECT
MEMVAR LDOS
MEMVAR NGRPBY
MEMVAR LLANDSCAPE
MEMVAR AHEADERS1
MEMVAR AHEADERS2
MEMVAR CTITLE
MEMVAR CGRAPHIC
MEMVAR WFIELD
MEMVAR WFIELDA
MEMVAR ATOTALS
MEMVAR AFORMATS
MEMVAR AWIDTHS
MEMVAR NPOSGRP
MEMVAR NLLMARGIN
MEMVAR CROMPE
MEMVAR CHDRGRP
MEMVAR WFILEREPO
MEMVAR CALIAS
MEMVAR NLPP
MEMVAR NCPL
MEMVAR LPREVIEW
MEMVAR CFILEREPO
MEMVAR LMUL
MEMVAR PAGE
MEMVAR EXT
MEMVAR NFI
MEMVAR NCI
MEMVAR NFF
MEMVAR NCF
MEMVAR Npapersize
MEMVAR Apapeles
MEMVAR ipaper
MEMVAR repobject
MEMVAR sicvar
MEMVAR ctitle1
MEMVAR cheader
MEMVAR _HMG_activeprintlibrary
MEMVAR _sw_report
MEMVAR CPRINTER
MEMVAR WORIENTATION
MEMVAR LSUCESS
MEMVAR CBAT


FUNCTION easyreport(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,lnoprop)
local cheader
PRIVATE ctitle1,sicvar,_sw_report

if lnoprop=NIL
   lnoprop=.F.
endif

if nlpp=NIL
   nlpp:=58
endif
if ncpl=NIL
   ncpl:=80
endif

  ctitle1:=HMG_LOWER(HB_USUBSTR(ctitle,HB_UAT('|',ctitle)+1))+'...'

  cheader:=''

  _sw_report:=.F.

  action_timer(CTITLE,AHEADERS1,AHEADERS2,AFIELDS,AWIDTHS,ATOTALS,NLPP,LDOS,LPREVIEW,CGRAPHIC,NFI,NCI,NFF,NCF,LMUL,CGRPBY,CHDRGRP,LLANDSCAPE,NCPL,LSELECT,CALIAS,NLLMARGIN,AFORMATS,NPAPERSIZE,CHEADER,lnoprop)

RETURN NIL

function action_timer(CTITLE,AHEADERS1,AHEADERS2,AFIELDS,AWIDTHS,ATOTALS,NLPP,LDOS,LPREVIEW,CGRAPHIC,NFI,NCI,NFF,NCF,LMUL,CGRPBY,CHDRGRP,LLANDSCAPE,NCPL,LSELECT,CALIAS,NLLMARGIN,AFORMATS,NPAPERSIZE,CHEADER,lnoprop)

if .not. _sw_report
    _sw_report:=.T.
   _LISTREPORT(CTITLE,AHEADERS1,AHEADERS2,AFIELDS,AWIDTHS,ATOTALS,NLPP,LDOS,LPREVIEW,CGRAPHIC,NFI,NCI,NFF,NCF,LMUL,CGRPBY,CHDRGRP,LLANDSCAPE,NCPL,LSELECT,CALIAS,NLLMARGIN,AFORMATS,NPAPERSIZE,CHEADER,lnoprop)
endif

return nil

FUNCTION _listreport(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader,lnoprop)
private repobject,sicvar


repobject:=_HMG_REPORT()
sicvar:=_HMG_SYSDATA [ 339 ]
SET INTERACTIVECLOSE ON
repobject:easyreport1(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader,lnoprop)
_HMG_SYSDATA [ 339 ]:=sicvar
release repobject
return nil

FUNCTION extreport(cfilerep,cheader)
PRIVATE repobject
repobject:=_HMG_REPORT()
repobject:extreport1(cfilerep,cheader)
release repobject
RETURN NIL


function JUSTIFICALINEA(WPR_LINE,WTOPE)
LOCAL I,WLARLIN
// Local j,ncount
WLARLIN=HMG_LEN(RTRIM(WPR_LINE))
FOR I=1 TO WLARLIN
   if wlarlin=wtope
      exit
   endif
   IF HB_USUBSTR(WPR_LINE,I,1)=SPACE(1) .AND. HB_USUBSTR(WPR_LINE,I-1,1)#SPACE(1) //////// .AND. HB_USUBSTR(WPR_LINE,I+1,1)#SPACE(1)
      WPR_LINE=LTRIM(HB_USUBSTR(WPR_LINE,1,I-1))+SPACE(2)+LTRIM(HB_USUBSTR(WPR_LINE,I+1,HMG_LEN(WPR_LINE)-I))
      WLARLIN=WLARLIN+1
   ENDIF
NEXT I
RETURN WPR_LINE


CREATE CLASS _HMG_REPORT

Private oprint

VAR npager    INIT 0
VAR angrpby   INIT {}
VAR nlmargin  INIT 0
VAR nfsize    INIT 0
VAR swt       INIT .F.
VAR nmhor     INIT 0
VAR nmver     INIT 0
VAR nhfij     INIT 0
VAR nvfij     INIT 0

VAR aline     INIT {}

METHOD easyreport1(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader,lnoprop)
METHOD headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
METHOD extreport1(cfilerep,cheader)
METHOD leadato(cName,cPropmet,cDefault)
METHOD leaimage(cName,cPropmet,cDefault)
METHOD leadatoh(cName,cPropmet,cDefault,npar)
METHOD leadatologic(cName,cPropmet,cDefault)
METHOD clean(cfvalue)
METHOD learowi(cname,npar)
METHOD leacoli(cname,npar)

ENDCLASS


METHOD easyreport1(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader,lnoprop) CLASS _HMG_REPORT
local nlin,i,aresul,lmode,swt:=0,grpby,k  // ,ncvcopt,ncol
private  wfield
if nllmargin = NIL
   repobject:nlmargin:=0
else
   repobject:nlmargin:=nllmargin
endif
if aformats==NIL
   aformats:=array(HMG_LEN(afields))
   for i:=1 to HMG_LEN(afields)
       aformats[i]:=NIL
   next i
endif
if atotals==NIL
   atotals:=array(HMG_LEN(afields))
   for i:=1 to HMG_LEN(afields)
       atotals[i]:=.F.
   next i
endif
repobject:npager:=0
grpby:=cgrpby
aresul:=array(HMG_LEN(afields))
repobject:angrpby:=array(HMG_LEN(afields))
for i:=1 to HMG_LEN(afields)
    afields[i]:=HMG_UPPER(afields[i])
next i
if grpby<>NIL
   grpby:=HMG_UPPER(grpby)
endif
select(calias)
lmode:=.T.
if nlpp= NIL
   nlpp=50
endif
setprc(0,0)
if ncpl = NIL
   ncpl:=80
   repobject:nfsize=12
endif
oprint:=TPRINT()
oprint:normaldos()
do case
        case ncpl= 80
            // ncvcopt:=1       Variable 'NCVCOPT' is assigned but not used in function
            repobject:nfsize:=12
            if lnoprop
               oprint:nfontsize:=12
            endif
         case ncpl= 96
            // ncvcopt:=2       Variable 'NCVCOPT' is assigned but not used in function
            repobject:nfsize=10
            if lnoprop
               oprint:nfontsize:=10
            endif
         case ncpl= 120
            // ncvcopt:=3    Variable 'NCVCOPT' is assigned but not used in function
            repobject:nfsize:=8
            if lnoprop
               oprint:nfontsize:=8
            endif
         case ncpl= 140
            // ncvcopt:=4    Variable 'NCVCOPT' is assigned but not used in function
           repobject:nfsize:=7
           if lnoprop
              oprint:nfontsize:=7
           endif
         case ncpl= 160
            // ncvcopt:=5     Variable 'NCVCOPT' is assigned but not used in function
            repobject:nfsize:=6
            if lnoprop
                oprint:nfontsize:=6
            endif
         otherwise
            // ncvcopt:=1 Variable 'NCVCOPT' is assigned but not used in function
            repobject:nfsize:=12
            if lnoprop
                oprint:nfontsize:=12
            endif
endcase

*****************=======================================

if ldos
   oprint:init("DOS")
   if ncpl<= 80
      oprint:normaldos()
   else
      oprint:condendos()
   endif
else
   IF type("_hmg_printlibrary")="U"
      _hmg_PRINTLIBRARY="HBPRINTER"
   ENDIF
   oprint:init(_HMG_printlibrary)
   if _hmg_PRINTLIBRARY="DOS"
      if ncpl<=80
         oprint:normaldos()
       else
         oprint:condendos()
      endif
   endif
endif

oprint:selprinter(lselect,lpreview,llandscape,npapersize)
if oprint:lprerror
   oprint:release()
   RETURN NIL
endif
oprint:begindoc()
oprint:beginpage()
nlin:=1
if cgraphic<>NIL
   if .not. File(cgraphic)
      msgstop('graphic file not found','error')
   else
      oprint:printimage(nfi,nci+repobject:nlmargin,nff,ncf+repobject:nlmargin,cgraphic)
   endif
endif
ngrpby:=0
nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
for i:=1 to HMG_LEN(afields)
    aresul[i]:=0
    repobject:angrpby[i]:=0
next i
if grpby<> NIL
   crompe:=&grpby
endif
do while .not. eof()
   do events
////   ncol:=repobject:nlmargin
   swt:=0
   if grpby<>NIL
      if .not.(&grpby = crompe)
            if ascan(atotals,.T.)>0
               oprint:printdata(nlin,repobject:nlmargin, '** Subtotal **',,repobject:nfsize,.T.)
               nlin++
            endif
**************
            clinea:=""
            for i:=1 to HMG_LEN(afields)
                 if atotals[i]
                    clinea:=clinea +iif(.not.(aformats[i]==NIL),space(awidths[i]-HMG_LEN(transform(repobject:angrpby[i],aformats[i])))+transform(repobject:angrpby[i],aformats[i]),STR(repobject:angrpby[i],awidths[i]))+ space(awidths[i] -   HMG_LEN(  iif(.not.(aformats[i]==''),space(awidths[i]-HMG_LEN(transform(repobject:angrpby[i],aformats[i])))+transform(repobject:angrpby[i],aformats[i]),STR(repobject:angrpby[i],awidths[i])))   )+" "
                 else
                  clinea:=clinea+ space(awidths[i])+" "
                endif
             next i
             oprint:printdata(nlin,0+repobject:nlmargin,clinea,,repobject:nfsize ,.T.)

**************

        for i:=1 to HMG_LEN(afields)
          repobject:angrpby[i]:=0
        next i
        crompe:=&grpby
        nlin++
        oprint:printdata(nlin,repobject:nlmargin,  '** ' +hb_oemtoansi(chdrgrp)+' ** '+hb_oemtoansi(&grpby),,repobject:nfsize,.T.)
        nlin++
      endif
   endif
**********
///   ncol:=0+repobject:nlmargin
   clinea:=""
   swmemo:=.F.
   for i:=1 to HMG_LEN(afields)
       wfielda:=afields[i]
       wfield:=&(wfielda)
       if type('&wfielda')=='M'
          swmemo=.T.
          wfieldt:=wfield
          ti:=i
       endif
       do case
               case type('&wfielda')=='C'
                 clinea:=clinea+HB_USUBSTR(wfield,1,awidths[i])+space(awidths[i]-HMG_LEN(HB_USUBSTR(wfield,1,awidths[i]) ))+" "
               case type('&wfielda')=='N'
                    clinea:=clinea + iif(.not.(aformats[i]==NIL),space(awidths[i]-HMG_LEN(transform(wfield,aformats[i])))+transform(wfield,aformats[i]),STR(wfield,awidths[i]))+ space(awidths[i] -   HMG_LEN(  iif(.not.(aformats[i]==''),space(awidths[i]-HMG_LEN(transform(wfield,aformats[i])))+transform(wfield,aformats[i]),STR(wfield,awidths[i])))   )+" "
               case type('&wfielda')=='D'
                    clinea:=clinea+ HB_USUBSTR(dtoc(wfield),1,awidths[i])+space(awidths[i]-HMG_LEN(HB_USUBSTR(dtoc(wfield),1,awidths[i])) )+" "
               case type('&wfielda')=='L'
                    If &wfielda
                       clinea:=clinea+".T."+" "
                    Else
                       clinea:=clinea+".F."+" "
                    EndIf
              case type('&wfielda')=='M' .or. type('&wfielda')=='C' //// ojo no quitar la a
                  nmemo:=mlcount(RTRIM(wfield),awidths[i])
                  if nmemo>0
                     clinea:=clinea + RTRIM(justificalinea(memoline(RTRIM(wfield),awidths[i] ,1),awidths[i]))+space(awidths[i]-HMG_LEN(RTRIM(justificalinea(memoline(RTRIM(wfield),awidths[i] ,1),awidths[i])) ) )+" "
                  else
                     clinea:=clinea + space(awidths[i])+" "
                  endif
               otherwise
               clinea:=clinea+REPLICATE('_',awidths[i])+" "
        endcase
       if atotals[i]
          aresul[i]:=aresul[i]+wfield
          swt:=1
          if grpby<>NIL
             repobject:angrpby[i]:=repobject:angrpby[i]+wfield
          endif
       endif
next i
oprint:printdata(nlin,repobject:nlmargin,clinea,,repobject:nfsize)
nlin++
if nlin>nlpp
   nlin:=1
   if .not. ldos
      oprint:endpage()
      oprint:beginpage()
      if cgraphic<>NIL .and. lmul
         if .not. File(cgraphic)
         msgstop('graphic file not found','error')
      else
         oprint:printimage(nfi,nci+repobject:nlmargin,nff,repobject:nfc,cgraphic )
      endif
   endif
endif
nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
endif
**************resto de memo
if swmemo
   if nmemo > 1
   clinea:=""
   nspace:=0
   for k:=1 to ti-1
       nspace:=nspace+awidths[k]+1
   next k
   for k:=2 to nmemo
       clinea:=space(nspace)+justificalinea(memoline(RTRIM(wfieldt),awidths[ti] ,k),awidths[ti] )
       oprint:printdata(nlin,0+repobject:nlmargin,clinea , , repobject:nfsize ,  )
       nlin++
       if nlin>nlpp
          nlin:=1
          oprint:endpage()
          oprint:beginpage()
    if cgraphic<>NIL .and. lmul
             if .not. File(cgraphic)
           msgstop('graphic file not found','error')
             else
                 oprint:printimage(nfi,nci+repobject:nlmargin,nff,repobject:nfc,cgraphic )
             endif
   endif
   nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
       endif
    next k
////    nlin--
   endif
endif
**************
skip
enddo

if swt==1
   // ncol:=0+repobject:nlmargin  // Variable 'NCOL' is assigned but not used in function
   if grpby<>NIL
      if .not.(&grpby == crompe)
         if ascan(atotals,.T.)>0
            oprint:printdata(nlin,repobject:nlmargin,  '** Subtotal **',,repobject:nfsize,.T.)
**** ojo
            nlin++
         endif
         clinea:=""
         for i:=1 to HMG_LEN(afields)
                if atotals[i]
                   clinea:=clinea +iif(.not.(aformats[i]==NIL),space(awidths[i]-HMG_LEN(transform(repobject:angrpby[i],aformats[i])))+transform(repobject:angrpby[i],aformats[i]),STR(repobject:angrpby[i],awidths[i]))+ space(awidths[i] -   HMG_LEN(  iif(.not.(aformats[i]==''),space(awidths[i]-HMG_LEN(transform(repobject:angrpby[i],aformats[i])))+transform(repobject:angrpby[i],aformats[i]),STR(repobject:angrpby[i],awidths[i])))   )+" "
                else
                   clinea:=clinea+ space(awidths[i])+" "
                endif
/////                ncol:=ncol+awidths[i]+1
         next i
        oprint:printdata(nlin,repobject:nlmargin, clinea , ,repobject:nfsize ,.T. )
        for i:=1 to HMG_LEN(afields)
          repobject:angrpby[i]:=0
        next i
        crompe:=&grpby
      endif
   endif
**************
   nlin++
/////   ncol:=0+repobject:nlmargin
   if nlin>nlpp
      nlin:=1
      oprint:endpage()
      oprint:beginpage()
      nlin:=repobject:headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader)
   endif
   if ascan(atotals,.T.)>0
      oprint:printdata(nlin, 0+repobject:nlmargin,'*** Total ***',,repobject:nfsize,.T.)
   endif
   nlin++
   clinea:=""
   for i:=1 to HMG_LEN(afields)
       if atotals[i]
          clinea:=clinea +iif(.not.(aformats[i]==NIL),space(awidths[i]-HMG_LEN(transform(aresul[i],aformats[i])))+transform(aresul[i],aformats[i]),STR(aresul[i],awidths[i]))+ space(awidths[i] -   HMG_LEN(  iif(.not.(aformats[i]==''),space(awidths[i]-HMG_LEN(transform(aresul[i],aformats[i])))+transform(aresul[i],aformats[i]),STR(aresul[i],awidths[i])))   )+" "
        else
         clinea:=clinea+ space(awidths[i])+" "
       endif
   next i
    oprint:printdata(nlin,0+repobject:nlmargin,clinea, ,repobject:nfsize ,.T.)
   nlin++
   oprint:printdata(nlin,repobject:nlmargin," ")
endif
  oprint:endpage()
  oprint:enddoc()
  oprint:release()
****release nlmargin
return Nil

METHOD headers(aheaders1,aheaders2,awidths,nlin,ctitle,lmode,grpby,chdrgrp,cheader) CLASS _HMG_REPORT
local i,nsum,ncenter,ncenter2,npostitle,ctitle1,ctitle2
nsum:=0

lmode := NIL   // ADD

for i:=1 to HMG_LEN(awidths)
    nsum:=nsum+awidths[i]
next i
npostitle:=HB_UAT('|',ctitle)
// ctitle1:=ctitle2:=''  Variable 'CTITLE1' is assigned but not used in function
ctitle2:=''
if npostitle>0
   ctitle1:=HB_ULEFT(ctitle,npostitle-1)
   ctitle2:=TRIM(HB_USUBSTR(ctitle,npostitle+1,HMG_LEN(ctitle)))
else
   ctitle1:=ctitle
endif

ctitle1:=TRIM(ctitle1)+cheader
ncenter:=((nsum-HMG_LEN(ctitle1))/2)-1
if HMG_LEN(ctitle2)>0
   ncenter2:=((nsum-HMG_LEN(ctitle2))/2)-1
endif
repobject:npager++
clinea:=TRIM( _HMG_SYSDATA [ 331 ] [8])+ space(6-HMG_LEN(TRIM( _HMG_SYSDATA [ 331 ] [8]))) + STR(repobject:npager,4)
clinea1:=space(ncenter)+ctitle1
clinea2:=space(nsum+HMG_LEN(awidths)-11)+dtoc(date())
oprint:printdata(nlin,repobject:nlmargin , clinea,,repobject:nfsize )
oprint:printdata(nlin,repobject:nlmargin , clinea1,,repobject:nfsize+1,.T. )
oprint:printdata(nlin,repobject:nlmargin , clinea2,,repobject:nfsize )

if HMG_LEN(ctitle2)>0
   nlin++
   clinea1:=space(ncenter2)+ctitle2
   clinea2:=space(nsum+HMG_LEN(awidths)-11)+time()
   oprint:printdata(nlin,repobject:nlmargin, clinea1,,repobject:nfsize+1,.T. )
   oprint:printdata(nlin,repobject:nlmargin, clinea2,,repobject:nfsize )
else
   nlin++
   clinea2:=space(nsum+HMG_LEN(awidths)-11)+time()
   oprint:printdata(nlin,repobject:nlmargin , clinea2,,repobject:nfsize )
endif

nlin++
nlin++
clinea:=""
for i:=1 to  HMG_LEN(awidths)
    clinea:=clinea+ REPLICATE('-',awidths[i])+" "
next i
oprint:printdata(nlin,repobject:nlmargin, clinea,,repobject:nfsize  )
nlin++

clinea:=""
for i:=1 to HMG_LEN(awidths)
  clinea:= clinea + HB_USUBSTR(aheaders1[i],1,awidths[i] ) + space( awidths[i]-HMG_LEN(aheaders1[i] )) +" "
next i
oprint:printdata(nlin,repobject:nlmargin, clinea,,repobject:nfsize ,.T.)
nlin++

clinea:=""
for i:=1 to HMG_LEN(awidths)
    clinea:= clinea + HB_USUBSTR(aheaders2[i],1,awidths[i] ) + space( awidths[i]-HMG_LEN(aheaders2[i] )) +" "
next i
   oprint:printdata(nlin,repobject:nlmargin, clinea,,repobject:nfsize ,.T.)
nlin++

clinea:=""
for i:=1 to  HMG_LEN(awidths)
    clinea:=clinea + REPLICATE('-',awidths[i])+" "
next i
oprint:printdata(nlin,repobject:nlmargin, clinea,,repobject:nfsize   )
nlin:=nlin+2

if grpby<>NIL
    oprint:printdata(nlin,repobject:nlmargin, '** ' +chdrgrp+' ** '+   &grpby , ,repobject:nfsize ,.T.   )
       nlin++
endif
_HMG_SYSDATA [ 339 ]:=sicvar
return nlin


METHOD extreport1(cfilerep,cheader) CLASS _HMG_REPORT
local nContlin,i,ctitle,aheaders1,aheaders2,afields,awidths,atotals,aformats
local nlpp,ncpl,nllmargin,calias,ldos,lpreview,lselect,cgraphic,lmul,nfi,nci
local nff,ncf,cgrpby,chdrgrp,llandscape
       if .not. file(cfilerep+'.rpt')
          msginfo('('+cfilerep+'.rpt)  File not found','Information')
          return Nil
       endif

       creport:= HB_MemoRead (cfilerep+'.rpt')   // ADD
       nContlin:=mlcount(Creport)
       For i:=1 to nContlin
          aAdd (repobject:Aline,memoline(Creport,500,i))
       next i
       ctitle:=repobject:leadato('REPORT','TITLE','')
       if HMG_LEN(ctitle)>0
          ctitle:=&ctitle
       endif
       aheaders1:=repobject:leadatoh('REPORT','HEADERS','{}',1)
       aheaders1:=&aheaders1
       aheaders2:=repobject:leadatoh('REPORT','HEADERS','{}',2)
       aheaders2:=&aheaders2
       afields:=repobject:leadato('REPORT','FIELDS','{}')
       if HMG_LEN(afields)=0
          msginfo('Fields not defined','Information')
          return Nil
       endif
       afields:=&afields
       awidths:=repobject:leadato('REPORT','WIDTHS','{}')
       if HMG_LEN(awidths)=0
          msginfo('Widths not defined','Information')
          return Nil
       endif
       awidths:=&awidths
       atotals:=repobject:leadato('REPORT','TOTALS',NIL)
       if atotals<>NIL
          atotals:=&atotals
       endif
       aformats:=repobject:leadato('REPORT','NFORMATS',NIL)
       if aformats<>NIL
          aformats:=&aformats
       endif
       nlpp:=val(repobject:leadato('REPORT','LPP',''))
       ncpl:=val(repobject:leadato('REPORT','CPL',''))
       nllmargin:=val(repobject:leadato('REPORT','LMARGIN','0'))
       npapersize:=repobject:leadato('REPORT','PAPERSIZE','DMPAPER_LETTER')
       if npapersize='DMPAPER_USER'
          npapersize=255
       endif
       if HMG_LEN(npapersize)=0
          npapersize:=NIL
       else
          ipaper := ascan ( apapeles , npapersize )
          if ipaper=0
             ipaper=1
          endif
          npapersize:=ipaper
       endif
       calias:=repobject:leadato('REPORT','WORKAREA','')
       ldos:=repobject:leadatologic('REPORT','DOSMODE',.F.)
       lpreview:=repobject:leadatologic('REPORT','PREVIEW',.F.)
       lselect:=repobject:leadatologic('REPORT','SELECT',.F.)
       lmul:=repobject:leadatologic('REPORT','MULTIPLE',.F.)
       lnoprop:=repobject:leadatologic('REPORT','NOFIXED',.F.)

       cgraphic:=repobject:clean(repobject:leaimage('REPORT','IMAGE',''))
       if HMG_LEN(cgraphic)==0
          cgraphic:=NIL
       endif
       nfi:=val((repobject:learowi('IMAGE',1)))
       nci:=val((repobject:leacoli('IMAGE',1)))
       nff:=val((repobject:learowi('IMAGE',2)))
       ncf:=val((repobject:leacoli('IMAGE',2)))
       cgraphicalt:=(repobject:leadato('DEFINE REPORT','IMAGE',''))
       if HMG_LEN(cgraphicalt)>0  &&& para sintaxis DEFINE REPORT
          cgraphicalt:=&cgraphicalt
          cgraphic:=cgraphicalt[1]
          nfi:=cgraphicalt[2]
          nci:=cgraphicalt[3]
          nff:=cgraphicalt[4]
          ncf:=cgraphicalt[5]
       endif
       cgrpby:=repobject:leadato('REPORT','GROUPED BY','')
       if HMG_LEN(cgrpby)=0
          cgrpby=NIL
       endif
       chdrgrp:=repobject:clean(repobject:leadato('REPORT','HEADRGRP',''))
       llandscape:=repobject:leadatologic('REPORT','LANDSCAPE',.F.)
       easyreport(ctitle,aheaders1,aheaders2,afields,awidths,atotals,nlpp,ldos,lpreview,cgraphic,nfi,nci,nff,ncf,lmul,cgrpby,chdrgrp,llandscape,ncpl,lselect,calias,nllmargin,aformats,npapersize,cheader,lnoprop)
return Nil

METHOD leadato(cName,cPropmet,cDefault) CLASS _HMG_REPORT
local i,sw,cfvalue
sw:=0
For i:=1 to HMG_LEN(repobject:aline)
if .not. HB_UAT(HMG_UPPER(cname)+' ',HMG_UPPER(repobject:aline[i]))==0
   sw:=1
else
   if sw==1
      npos:=HB_UAT(HMG_UPPER(cPropmet)+' ',HMG_UPPER(repobject:aline[i]))
      if HMG_LEN(TRIM(repobject:aline[i]))==0
         // i=HMG_LEN(repobject:aline)+1 // Variable 'I' is assigned but not used in function
         return cDefault
      endif
      if npos>0
         cfvalue:=HB_USUBSTR(repobject:aline[i],npos+HMG_LEN(Cpropmet),HMG_LEN(repobject:aline[i]))
         // i:=HMG_LEN(repobject:aline)+1  // Variable 'I' is assigned but not used in function ?
         cfvalue:=TRIM(cfvalue)
         if HB_URIGHT(cfvalue,1)=';'
            cfvalue:=HB_USUBSTR(cfvalue,1,HMG_LEN(cfvalue)-1)
         else
            cfvalue:=HB_USUBSTR(cfvalue,1,HMG_LEN(cfvalue))
         endif
         return ALLTRIM(cfvalue)
      endif
   endif
endif
Next i
return cDefault

METHOD leaimage(cName,cPropmet,cDefault) CLASS _HMG_REPORT
local i,sw1,npos1,npos2
sw1:=0
lin:=0
cname:=''
cpropmet:=''
For i:=1 to HMG_LEN(repobject:aline)
    if HB_UAT(HMG_UPPER('IMAGE'),repobject:aline[i])>0
       npos1:=HB_UAT(HMG_UPPER('IMAGE'),HMG_UPPER(repobject:aline[i]))+6
       npos2:=HB_UAT(HMG_UPPER('HB_UAT'),HMG_UPPER(repobject:aline[i]))-1
       lin:=i
       i:=HMG_LEN(repobject:aline)+1
       sw1:=1
    endif
next i
if sw1=1
   return HB_USUBSTR(repobject:aline[lin],npos1,npos2-npos1+1)
endif
return cDefault

METHOD leadatoh(cName,cPropmet,cDefault,npar) CLASS _HMG_REPORT
local i,npos1,npos2,sw1
sw1:=0
lin:=0
cName:=''
cPropmet:=''
For i:=1 to HMG_LEN(repobject:aline)
        if HB_UAT(HMG_UPPER('HEADERS'),repobject:aline[i])>0
            if npar=1
               npos1:=HB_UAT(HMG_UPPER('{'),HMG_UPPER(repobject:aline[i]))
               npos2:=HB_UAT(HMG_UPPER('}'),HMG_UPPER(repobject:aline[i]))
            else
               npos1:=HB_UTF8RAT(HMG_UPPER('{'),HMG_UPPER(repobject:aline[i]))
               npos2:=HB_UTF8RAT(HMG_UPPER('}'),HMG_UPPER(repobject:aline[i]))
            endif
            lin:=i
            i:=HMG_LEN(repobject:aline)+1
            sw1:=1
        endif
next i
if sw1=1
   return HB_USUBSTR(repobject:aline[lin],npos1,npos2-npos1+1)
endif
return cDefault

METHOD leadatologic(cName,cPropmet,cDefault) CLASS _HMG_REPORT
local i,sw
sw:=0
For i:=1 to HMG_LEN(repobject:aline)
if HB_UAT(HMG_UPPER(cname)+' ',HMG_UPPER(repobject:aline[i]))#0
   sw:=1
else
   if sw==1
      if HB_UAT(HMG_UPPER(cPropmet)+' ',HMG_UPPER(repobject:aline[i]))>0
         return .T.
      endif
      if HMG_LEN(TRIM(repobject:aline[i]))==0
         // i=HMG_LEN(repobject:aline)+1 // Variable 'I' is assigned but not used in function
         return cDefault
      endif
   endif
endif
Next i
return cDefault

METHOD clean(cfvalue) CLASS _HMG_REPORT
cfvalue:=HB_UTF8STRTRAN(cfvalue,'"','')
cfvalue:=HB_UTF8STRTRAN(cfvalue,"'","")
return cfvalue

METHOD learowi(cname,npar) CLASS _HMG_REPORT
local i,npos1,nrow
sw:=0
nrow:='0'
cname:=''
For i:=1 to HMG_LEN(repobject:aline)
    if HB_UAT(HMG_UPPER('IMAGE')+' ',HMG_UPPER(repobject:aline[i]))#0
       if npar=1
          npos1:=HB_UAT("HB_UAT",HMG_UPPER(repobject:aline[i]))
       else
          npos1:=HB_UAT("TO",HMG_UPPER(repobject:aline[i]))
       endif
       nrow:=HB_USUBSTR(repobject:aline[i],npos1+3,4)
       i:=HMG_LEN(repobject:aline)
    endif
Next i
return nrow

METHOD leacoli(cname,npar) CLASS _HMG_REPORT
local i,npos,ncol
ncol:='0'
cname:=''
For i:=1 to HMG_LEN(repobject:aline)
if HB_UAT(HMG_UPPER('IMAGE')+' ',HMG_UPPER(repobject:aline[i]))#0
   if npar=1
      npos:=HB_UAT(",",repobject:aline[i])
   else
      npos:=HB_UTF8RAT(",",repobject:aline[i])
   endif
   ncol:=HB_USUBSTR(repobject:aline[i],npos+1,4)
   i:=HMG_LEN(repobject:aline)
endif
Next i
return ncol
