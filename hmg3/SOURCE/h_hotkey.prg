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
#include 'hmg.ch'
*------------------------------------------------------------------------------*
Procedure _DefineHotKey ( cParentForm , nMod , nKey , bAction )
*------------------------------------------------------------------------------*
Local nParentForm , nId , i , nControlCount , k, z

	If _HMG_SYSDATA [ 264 ] = .T.
		cParentForm := _HMG_SYSDATA [ 223 ]
	EndIf

	If ValType ( cParentForm ) == 'U'
		MsgHMGError ("ON KEY: Parent Window Not Specified. Program Terminated")
	EndIf

	// Check if the window/form is defined.
	if ( .not. _IsWindowDefined( cParentForm ) )
		MsgHMGError( "Window: " + cParentForm + " is not defined. Program terminated." )
	Endif

	nParentForm := GetFormHandle ( cParentForm )
	nControlCount := HMG_LEN ( _HMG_SYSDATA [3] )
	z := GetFormIndex (cParentForm)

	For i := 1 To nControlCount
		If _HMG_SYSDATA [1] [i] == 'HOTKEY' .and. _HMG_SYSDATA [4] [i] == nParentForm .and. _HMG_SYSDATA [  7 ] [i] == nMod .and. _HMG_SYSDATA [  8 ] [i] == nKey
			_EraseControl(i,z)
			Exit
		EndIf
	Next i

	nId := _GetId()

	InitHotKey ( nParentForm , nMod , nKey , nId )

	k := _GetControlFree()


	_HMG_SYSDATA [1] [k] :=  "HOTKEY"
	_HMG_SYSDATA [2]  [k] :=   ''
	_HMG_SYSDATA [3]  [k] :=   0
	_HMG_SYSDATA [4]  [k] :=   nParentForm
	_HMG_SYSDATA [  5 ]  [k] :=   nId
	_HMG_SYSDATA [  6 ]  [k] :=   bAction
	_HMG_SYSDATA [  7 ]  [k] :=   nMod
	_HMG_SYSDATA [  8 ]  [k] :=   nKey
	_HMG_SYSDATA [  9 ]  [k] :=   ""
	_HMG_SYSDATA [ 10 ]  [k] :=   ""
	_HMG_SYSDATA [ 11 ]   [k] :=  ""
	_HMG_SYSDATA [ 12 ]  [k] :=   ""
	_HMG_SYSDATA [ 13 ]  [k] :=   .F.
	_HMG_SYSDATA [ 14 ]  [k] :=   Nil
	_HMG_SYSDATA [ 15 ]  [k] :=   Nil
	_HMG_SYSDATA [ 16 ]   [k] :=  ""
	_HMG_SYSDATA [ 17 ]  [k] :=   {}
	_HMG_SYSDATA [ 18 ]  [k] :=   0
	_HMG_SYSDATA [ 19 ]   [k] :=  0
	_HMG_SYSDATA [ 20 ]  [k] :=   0
	_HMG_SYSDATA [ 21 ]  [k] :=   0
	_HMG_SYSDATA [ 22 ]   [k] :=  0
	_HMG_SYSDATA [ 23 ]  [k] :=   0
	_HMG_SYSDATA [ 24 ]   [k] :=  0
	_HMG_SYSDATA [ 25 ]   [k] :=  ""
	_HMG_SYSDATA [ 26 ]   [k] :=  0
	_HMG_SYSDATA [ 27 ]   [k] :=  ''
	_HMG_SYSDATA [ 28 ]  [k] :=   0
	_HMG_SYSDATA [ 29 ]  [k] :=   {.f.,.f.,.f.,.f.}
	_HMG_SYSDATA [ 30 ]   [k] :=   ''
	_HMG_SYSDATA [ 31 ]   [k] :=   0
	_HMG_SYSDATA [ 32 ]   [k] :=   0
	_HMG_SYSDATA [ 33 ]   [k] :=   ''
	_HMG_SYSDATA [ 34 ]   [k] :=   .t.
	_HMG_SYSDATA [ 35 ]  [k] :=    0
	_HMG_SYSDATA [ 36 ]  [k] :=    0
	_HMG_SYSDATA [ 37 ]  [k] :=    0
	_HMG_SYSDATA [ 38 ]  [k] :=    .T.
	_HMG_SYSDATA [ 39 ] [k] := 0
	_HMG_SYSDATA [ 40 ] [k] := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

Return
*------------------------------------------------------------------------------*
Procedure _ReleaseHotKey ( cParentForm, nMod , nKey )
*------------------------------------------------------------------------------*
Local i , nParentFormHandle , nControlCount , z

	nParentFormHandle := GetFormhandle ( cParentForm )
	nControlCount := HMG_LEN ( _HMG_SYSDATA [3] )
	z := GetFormIndex (cParentForm)

	For i := 1 To nControlCount
		If _HMG_SYSDATA [1] [i] == 'HOTKEY' .and. _HMG_SYSDATA [4] [i] == nParentFormHandle .and. _HMG_SYSDATA [  7 ] [i] == nMod .and. _HMG_SYSDATA [  8 ] [i] == nKey
			_EraseControl(i,z)
			Exit
		EndIf
	Next i

Return

*------------------------------------------------------------------------------*
Function _GetHotKey ( cParentForm, nMod , nKey )
*------------------------------------------------------------------------------*
Local i , nParentFormHandle , nControlCount , bRetVal := Nil

	nParentFormHandle := GetFormhandle ( cParentForm )
	nControlCount := HMG_LEN ( _HMG_SYSDATA [3] )

	For i := 1 To nControlCount
		If _HMG_SYSDATA [1] [i] == 'HOTKEY' .and. _HMG_SYSDATA [4] [i] == nParentFormHandle .and. _HMG_SYSDATA [  7 ] [i] == nMod .and. _HMG_SYSDATA [  8 ] [i] == nKey
			bRetVal := _HMG_SYSDATA [  6 ] [i]
			Exit
		EndIf
	Next i

Return ( bRetVal )


*------------------------------------------------------------------------------*
Function _PushKey (nKey)
*------------------------------------------------------------------------------*
   Keybd_Event ( nKey, .F. )
   Keybd_Event ( nKey, .T. )
Return Nil


//*******************************************
//* by Dr. Claudio Soto, April 2016
//*******************************************

//       HMG_PressKey( nVK1, nVK2, ... ) --> return array { nVK1, nVK2, ... }
FUNCTION HMG_PressKey( ... )
LOCAL i, aVK := {}

   FOR i := 1 TO PCount()
      IF ValType( PValue( i ) ) == "N"
         AADD( aVK, PValue( i ) )
      ELSE
         MsgHMGError ("HMG_PressKey: invalid parameter")
      ENDIF
      Keybd_Event( aVK[ i ], .F. )   // KeyDown
   NEXT

   FOR i := HMG_LEN( aVK ) TO 1 STEP -1
      Keybd_Event( aVK[ i ], .T. )   // KeyUp
   NEXT

RETURN aVK


