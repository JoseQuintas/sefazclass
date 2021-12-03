/*----------------------------------------------------------------------------
 HMG - Harbour Windows GUI library source code

 Copyright 2002-2017 Roberto Lopez <mail.box.hmg@gmail.com>
 http://sites.google.com/site/hmgweb/

 Head of HMG project:

      2002-2012 Roberto Lopez <mail.box.hmg@gmail.com>
      http://sites.google.com/site/hmgweb/

      2012-2017 Dr. Claudio Soto <srvet@adinet.com.uy>
      http://srvet.blogspot.com

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
 contained in this release of HMG.

 The exception is that, if you link the HMG library with other 
 files to produce an executable, this does not by itself cause the resulting 
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the 
 HMG library code into it.

 Parts of this project are based upon:

	"Harbour GUI framework for Win32"
 	Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 	Copyright 2001 Antonio Linares <alinares@fivetech.com>
	www - http://www.harbour-project.org

	"Harbour Project"
	Copyright 1999-2008, http://www.harbour-project.org/

	"WHAT32"
	Copyright 2002 AJ Wos <andrwos@aust1.net> 

	"HWGUI"
  	Copyright 2001-2008 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/

MEMVAR _HMG_SYSDATA
#include "hmg.ch"


Function MsgHMGError ( Message )
    Local n, ai, HtmArch, xText

   _HMG_SYSDATA [ 347 ] := .F.

    HtmArch := Html_ErrorLog()
    Html_LineText(HtmArch,"Date:"+DToC(Date())+"  "+"Time: "+Time())
    n := 1
    ai := "" + HMGVersion()+CHR(13) + CHR(10) + Message + CHR(13) + CHR (10) + CHR(13) + CHR (10)
    Html_LineText(HtmArch,"Error: " + HMGVersion())
    Html_LineText(HtmArch,Message)
    WHILE ! Empty( ProcName( n ) )
       xText := "Called from " + ProcName( n ) + "(" + ALLTRIM( Str( ProcLine( n++ ) ) ) + ")" +CHR(13) +CHR(10)
       ai += xText
       Html_LineText(HtmArch,xText)
    ENDDO
    Html_Line(HtmArch)
    ShowError(ai)
Return Nil



*************************************************************
*   by Dr. Claudio Soto (January 2015)
*************************************************************


FUNCTION HMG_MakeVersion ( cVersion_NUMBER , cVersion_WIN32_STABLE , cVersion_WIN64_STABLE , cVersion_PATCH, Is64Bits )
LOCAL cVersion := ""
   IF .NOT. EMPTY ( AllTrim (cVersion_NUMBER) )
      cVersion := alltrim (cVersion_NUMBER) + " "; 
                  + IF ( Is64Bits, alltrim(cVersion_WIN64_STABLE), alltrim(cVersion_WIN32_STABLE) ) ;
                  + IF (.NOT. Empty(alltrim(cVersion_PATCH)) , " Patch "+alltrim(cVersion_PATCH), "") ;
                  + IF ( Is64Bits, " (64 bits)", " (32 bits)" )
   ENDIF
RETURN (cVersion)


FUNCTION HMGVersion()   // constants defined in minigui.ch
LOCAL cVersion := HMG_MakeVersion ( _HMG_VERSION_NUMBER_ , _HMG_VERSION_WIN32_STABLE_ , _HMG_VERSION_WIN64_STABLE_ , _HMG_VERSION_PATCH_ , HMG_Is64Bits() )
RETURN (cVersion)


Function HMG_GetCompileVersionRaw ( HMG_cPath )
LOCAL i, pPP, cCommandPP, cCommand, Number 
LOCAL aVersion := { {"_HMG_VERSION_NUMBER_",       ""},;
                    {"_HMG_VERSION_WIN32_STABLE_", ""},;
                    {"_HMG_VERSION_WIN64_STABLE_", ""},;
                    {"_HMG_VERSION_PATCH_",        ""},;
                    {"_HMG_VERSION_STABLE_",       ""} }   // for compatibility whit old version

   pPP := __pp_Init ( HMG_cPath + "\INCLUDE" , "HMG.CH" )   // Init Harbour PreProcesor

   FOR i := 1 TO HMG_LEN (aVersion)
      cCommand := ALLTRIM (aVersion [i] [1])
      cCommandPP := __pp_Process ( pPP, cCommand )   // Run Harbour PreProcesor

      cCommandPP := HB_UTF8STRTRAN ( cCommandPP, '"' )
      cCommandPP := HB_UTF8STRTRAN ( cCommandPP, "'" )
      cCommandPP := ALLTRIM ( cCommandPP )

      IF HMG_StrCmp (cCommand, cCommandPP) <> 0
         aVersion [i] [2] := cCommandPP
      ENDIF
   NEXT


/*   Adjusts necessary for compatibility with old version prior that HMG.3.4.0   */


   IF TYPE (aVersion [1] [2]) == "N"   // _HMG_VERSION_NUMBER_ is defined as Number
      Number := aVersion [1] [2]
      aVersion [1] [2] := "HMG " + hb_USubStr(Number,1,1) +"."+ hb_USubStr(Number,2,1) +"."+ hb_USubStr(Number,3,1)
   ENDIF

   IF TYPE (aVersion [4] [2]) == "N"   // _HMG_VERSION_PATCH_ is defined as Number
      IF aVersion [4] [2] == "0"
         aVersion [4] [2] := ""
      ENDIF
   ENDIF

   IF .NOT. EMPTY (aVersion [5] [2])   // _HMG_VERSION_WIN32_STABLE_ is not defined, is defined as _HMG_VERSION_STABLE_
      aVersion [2] [2] := aVersion [5] [2]
   ENDIF
   HB_ADEL (aVersion, 5, .T.)

RETURN aVersion


FUNCTION HMG_GetCompileVersion32 ( HMG_cPath )
LOCAL cVersion := "", aVersion := HMG_GetCompileVersionRaw  ( HMG_cPath )
   IF .NOT. EMPTY (aVersion [2] [2])   // _HMG_VERSION_WIN32_STABLE_
      cVersion := HMG_MakeVersion ( aVersion [1] [2], aVersion [2] [2], aVersion [3] [2], aVersion [4] [2], .F. )
   ENDIF
   IF EMPTY (cVersion)
      cVersion := AllTrim (HB_MEMOREAD (HMG_cPath + "\Version.txt"))
   ENDIF
RETURN cVersion


FUNCTION HMG_GetCompileVersion64 ( HMG_cPath )
LOCAL cVersion := "", aVersion := HMG_GetCompileVersionRaw  ( HMG_cPath )
   IF .NOT. EMPTY (aVersion [3] [2])   // _HMG_VERSION_WIN64_STABLE_
      cVersion := HMG_MakeVersion ( aVersion [1] [2], aVersion [2] [2], aVersion [3] [2], aVersion [4] [2], .F. )
   ENDIF
   IF EMPTY (cVersion)
      cVersion := AllTrim (HB_MEMOREAD (HMG_cPath + "\Version64.txt"))
   ENDIF
RETURN cVersion

