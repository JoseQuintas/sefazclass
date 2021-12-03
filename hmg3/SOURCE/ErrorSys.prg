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
#include "error.ch"
#INCLUDE "COMMON.CH"



*------------------------------------------------------------------------------*
PROCEDURE ErrorSys
*------------------------------------------------------------------------------*

   ErrorBlock( { | oError | DefError( oError ) } )

   *OutPutSelect()

   Init()

RETURN


STATIC FUNCTION DefError( oError )
   LOCAL cMessage
   LOCAL cDOSError

   LOCAL n
   Local Ai

   //Html Arch to ErrorLog
   LOCAL HtmArch, xText

   _HMG_SYSDATA [ 347 ] := .F.

   // By default, division by zero results in zero
   IF oError:genCode == EG_ZERODIV
      RETURN 0
   ENDIF

   // Set NetErr() of there was a database open error
   IF oError:genCode == EG_OPEN .AND. ;
      oError:osCode == 32 .AND. ;
      oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF

   // Set NetErr() if there was a lock error on dbAppend()
   IF oError:genCode == EG_APPENDLOCK .AND. ;
      oError:canDefault
      NetErr( .T. )
      RETURN .F.
   ENDIF

   HtmArch := Html_ErrorLog()
   cMessage := ErrorMessage( oError )
   IF ! Empty( oError:osCode )
      cDOSError := "(DOS Error " + LTrim( Str( oError:osCode ) ) + ")"
   ENDIF

   // "Quit" selected

   IF ! Empty( oError:osCode )
      cMessage += " " + cDOSError
   ENDIF
   Html_LineText(HtmArch, '<p class="updated">Date:' + DToC(Date()) + "  " + "Time: " + Time() )
   Html_LineText(HtmArch, cMessage + "</p>" )
   n := 2
   ai = cmessage + CHR(13) + CHR (10) + CHR(13) + CHR (10)
   WHILE ! Empty( ProcName( n ) )
      xText := "Called from " + ProcName( n ) + "(" + ALLTRIM( Str( ProcLine( n++ ) ) ) + ")" +CHR(13) +CHR(10)
      ai = ai + xText
      Html_LineText(HtmArch,xText)
   ENDDO
   Html_Line(HtmArch)

   ShowError(ai)

   QUIT

   RETURN .F.

// [vszakats]

STATIC FUNCTION ErrorMessage( oError )
   LOCAL cMessage

   // start error message
   cMessage := iif( oError:severity > ES_WARNING, "Error", "Warning" ) + " "

   // add subsystem name if available
   IF ISCHARACTER( oError:subsystem )
      cMessage += oError:subsystem()
   ELSE
      cMessage += "???"
   ENDIF

   // add subsystem's error code if available
   IF ISNUMBER( oError:subCode )
      cMessage += "/" + LTrim( Str( oError:subCode ) )
   ELSE
      cMessage += "/???"
   ENDIF

   // add error description if available
   IF ISCHARACTER( oError:description )
      cMessage += "  " + oError:description
   ENDIF

   // add either filename or operation
   DO CASE
   CASE !Empty( oError:filename )
      cMessage += ": " + oError:filename
   CASE !Empty( oError:operation )
      cMessage += ": " + oError:operation
   ENDCASE

   RETURN cMessage


*******************************************
Function ShowError ( ErrorMesssage )
********************************************

	UnloadAllDll()

	dbCloseAll()

	C_MSGSTOP ( ErrorMesssage , 'Program Error' )

	ExitProcess(0)

Return Nil

*------------------------------------------------------------------------------
*-01-01-2003
*-AUTHOR: Antonio Novo
*-Create/Open the ErrorLog.Htm file
*-Note: Is used in: errorsys.prg and h_error.prg
*------------------------------------------------------------------------------
FUNCTION HTML_ERRORLOG
*---------------------
    Local HtmArch
    If .Not. File("\"+CurDir()+"\ErrorLog.Htm")
        HtmArch := HtmL_Ini("\"+CurDir()+"\ErrorLog.Htm","HMG Errorlog File")
        Html_Line(HtmArch)
    Else
        HtmArch := FOpen("\"+CurDir()+"\ErrorLog.Htm",2)
        FSeek(HtmArch,0,2)    //End Of File
    EndIf
RETURN (HtmArch)

*------------------------------------------------------------------------------
*-30-12-2002
*-AUTHOR: Antonio Novo
*-HTML Page Head
*------------------------------------------------------------------------------
FUNCTION HTML_INI(ARCH,TIT)
*-------------------------
    LOCAL HTMARCH
    LOCAL cStilo:= "<style> "                       +;
                     "body{ "                       +;
                       "font-family: sans-serif;"   +;
                       "background-color: #ffffff;" +;
                       "font-size: 75%;"            +;
                       "color: #000000;"            +;
                       "}"                          +;
                     "h1{"                          +;
                       "font-family: sans-serif;"   +;
                       "font-size: 150%;"           +;
                       "color: #0000cc;"            +;
                       "font-weight: bold;"         +;
                       "background-color: #f0f0f0;" +;
                       "}"                          +;
                     ".updated{"                    +;
                       "font-family: sans-serif;"   +;
                       "color: #cc0000;"            +;
                       "font-size: 110%;"           +;
                       "}"                          +;
                     ".normaltext{"                 +;
                      "font-family: sans-serif;"    +;
                      "font-size: 100%;"            +;
                      "color: #000000;"             +;
                      "font-weight: normal;"        +;
                      "text-transform: none;"       +;
                      "text-decoration: none;"      +;
                    "}"                             +;
                    "</style>"

    HTMARCH := FCreate(ARCH)
    FWrite(HTMARCH,"<HTML><HEAD><TITLE>"+TIT+"</TITLE></HEAD>" + cStilo +"<BODY>"+CHR(13)+CHR(10))
    FWrite(HTMARCH,'<H1 Align=Center>'+TIT+'</H1><BR>'+CHR(13)+CHR(10))
RETURN (HTMARCH)

*------------------------------------------------------------------------------
*-30-12-2002
*-AUTHOR: Antonio Novo
*-HTM Page Line
*------------------------------------------------------------------------------
FUNCTION HTML_LINETEXT(HTMARCH,LINEA)
*-----------------------------------
    FWrite(HTMARCH, RTrim( LINEA ) + "<BR>"+CHR(13)+CHR(10))
RETURN (.T.)

*------------------------------------------------------------------------------
*-30-12-2002
*-AUTHOR: Antonio Novo
*-HTM Line
*------------------------------------------------------------------------------
FUNCTION HTML_LINE(HTMARCH)
*-------------------------
    FWrite(HTMARCH,"<HR>"+CHR(13)+CHR(10))
RETURN (.T.)


*-----------------------------------------------------------------------------*
* Pablo César (May 2014)
*-----------------------------------------------------------------------------*
FUNCTION HTML_END( HTMARCH )
   FWrite( HTMARCH, "</BODY></HTML>" )
   FClose( HTMARCH )
Return Nil