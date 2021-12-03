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

MEMVAR _HMG_MsgDebugTitle
MEMVAR _HMG_MsgDebugType
MEMVAR _HMG_MsgDebugTimeOut

#include "hmg.ch"
#include 'common.ch'


*-----------------------------------------------------------------------------*
Function MsgYesNo ( Message , Title , RevertDefault )
*-----------------------------------------------------------------------------*
Local Retval, t
   DEFAULT Message TO ''
   DEFAULT Title TO ''

   If ValType ( RevertDefault ) == 'L'
      If RevertDefault == .T.
         t := c_msgyesno_id(HMG_ValToStr(Message), hb_ValToStr(Title))
      Else
         t := c_msgyesno(HMG_ValToStr(Message), hb_ValToStr(Title))
      EndIf
   Else
      t := c_msgyesno(HMG_ValToStr(Message), hb_ValToStr(Title))
   EndIf
   
   if t = 6 
      RetVal := .t.
   Else
      RetVal := .f.
   Endif
Return (RetVal)


*-----------------------------------------------------------------------------*
Function MsgRetryCancel ( Message , Title )
*-----------------------------------------------------------------------------*
Local Retval, t
   DEFAULT Message TO ''
   DEFAULT Title TO ''
   t := c_msgretrycancel (HMG_ValToStr(Message), hb_ValToStr(Title))
   if t = 4 
      RetVal := .t.
   Else
      RetVal := .f.
   Endif
Return (RetVal)


*-----------------------------------------------------------------------------*
Function MsgOkCancel ( Message , Title )
*-----------------------------------------------------------------------------*
Local Retval, t
   DEFAULT Message TO ''
   DEFAULT Title TO ''
   t := c_msgokcancel(HMG_ValToStr(Message), hb_ValToStr(Title))
   if t = 1 
      RetVal := .t.
   Else
      RetVal := .f.
   Endif
Return (RetVal)


*-----------------------------------------------------------------------------*
Function MsgInfo ( Message , Title )
*-----------------------------------------------------------------------------*
   DEFAULT Message TO ''
   DEFAULT Title TO ''
   c_msginfo(HMG_ValToStr(Message), hb_ValToStr(Title))
Return Nil


*-----------------------------------------------------------------------------*
Function MsgStop ( Message , Title )
*-----------------------------------------------------------------------------*
   DEFAULT Message TO ''
   DEFAULT Title TO ''
   c_msgstop(HMG_ValToStr(Message), hb_ValToStr(Title))
Return Nil


*-----------------------------------------------------------------------------*
Function MsgExclamation ( Message , Title )
*-----------------------------------------------------------------------------*
   DEFAULT Message TO ''
   DEFAULT Title TO ''
   c_msgexclamation(HMG_ValToStr(Message), hb_ValToStr(Title))
Return Nil


*-----------------------------------------------------------------------------*
Function MsgBox ( Message , Title )
*-----------------------------------------------------------------------------*
   DEFAULT Message TO ''
   DEFAULT Title TO ''
   c_msgbox(HMG_ValToStr(Message), hb_ValToStr(Title))
Return Nil



// by Dr. Claudio Soto, April 2013
*-------------------------------------------------------*
FUNCTION HMG_ValToStr (Msg)
*-------------------------------------------------------*
LOCAL i, cText:= ""
   IF ValType (Msg) == "A"
      FOR i = 1 TO HMG_LEN (Msg)
          cText := cText + HB_VALTOSTR ( Msg [i] )
      NEXT
   ELSE
      cText := HB_VALTOSTR ( Msg )
   ENDIF
RETURN cText





// by Dr. Claudio Soto (April 2013, October 2013)
*-----------------------------------------------------------------------------*
FUNCTION MsgDebug
*-----------------------------------------------------------------------------*
LOCAL i, cMsg, cTitle
   #define CRLF CHR(13)+CHR(10)
   cMsg := "Called from: " + ProcName(1) + "(" + LTrim(Str(ProcLine(1))) + ") --> " + PROCFILE (1) + CRLF + CRLF
   FOR i = 1 TO PCount()
       cMsg := cMsg + HB_VALTOEXP (PVALUE (i)) + IIF (i < PCount(), ", ", "")
   NEXT
   // MsgBox (cMsg)
   cTitle := _HMG_MsgDebugTitle
   HMG_MessageBoxTimeout ( cMsg, MsgDebugTitle(), MsgDebugType(), MsgDebugTimeOut() )
   cMsg := cTitle + CRLF + cMsg
RETURN cMsg


FUNCTION MsgDebugTitle ( Title )
LOCAL cPreviusTitle := _HMG_MsgDebugTitle
   IF ValType (Title) == "U"
      _HMG_MsgDebugTitle := "DEBUG INFO"
   ELSE
      _HMG_MsgDebugTitle := HB_VALTOSTR ( Title )
   ENDIF
RETURN cPreviusTitle


FUNCTION MsgDebugType ( nTypeIconButton )
LOCAL nPreviusType := _HMG_MsgDebugType
   IF ValType (nTypeIconButton) == "N"
      _HMG_MsgDebugType := nTypeIconButton
   ELSE
      _HMG_MsgDebugType := MB_OK + MB_SYSTEMMODAL
   ENDIF
RETURN nPreviusType


FUNCTION MsgDebugTimeOut ( nMilliseconds )
LOCAL nPreviusTimeOut := _HMG_MsgDebugTimeOut
   IF ValType (nMilliseconds) == "N"
      _HMG_MsgDebugTimeOut := nMilliseconds
   ELSE
      _HMG_MsgDebugTimeOut := NIL
   ENDIF
RETURN nPreviusTimeOut




*--------------------------------------------------------------------------------*
Function MessageBoxTimeout ( Message , Title , nTypeIconButton , nMilliseconds )
*--------------------------------------------------------------------------------*
   LOCAL nRetValue
   DEFAULT Message TO ''
   DEFAULT Title TO ''
   nRetValue := HMG_MessageBoxTimeout ( HMG_ValToStr(Message), hb_ValToStr(Title), nTypeIconButton, nMilliseconds )
Return nRetValue

