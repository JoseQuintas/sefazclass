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
#include "common.ch"
#include "hmg.ch"

*-----------------------------------------------------------------------------*
Function _DefineToolBar (	cControlName		, ;
				cParentWindowName	, ;
				nButtonWidth		, ;
				nButtonHeight		, ;
				lFlat			, ;
				lBottom			, ;
				lRightText		, ;
				lBorder			, ;
				cFontName		, ;
				nFontSize		, ;
				lBold			, ;
				lItalic			, ;
				lUnderLine		, ;
				lStrikeOut		, ;
				cToolTip		, ;
				cGripperText		, ;
				lBreak			, ;
				nImageWidth		, ;
				nImageHeight		, ;
				lStrictWidth		  ;
			)
*-----------------------------------------------------------------------------*
* Local Variables
Local nParentWindowHandle
Local nControlHandle
Local mVar
Local k
Local nId
Local aTemp
LOCAL lSplitBoxActive

Default nImageWidth	To -1
Default nImageHeight	To -1

	* Set Public ToolBar Support Variables
	_HMG_SYSDATA [ 309 ]	:= 0
	_HMG_SYSDATA [ 313 ]	:= cGripperText
	_HMG_SYSDATA [ 261 ]	:= lBreak

   lSplitBoxActive := _HMG_SYSDATA [ 262 ]   // ADD

	if lSplitBoxActive == .T.
		_HMG_SYSDATA [ 216 ]	:= 'TOOLBAR'
	EndIf

	* If inside DEFINE WINDOW structure gets window name

	If _HMG_SYSDATA [ 264 ] = .T.
		cParentWindowName := _HMG_SYSDATA [ 223 ]
	EndIf

	_HMG_SYSDATA [ 311 ] := cParentWindowName

	* Error Checking

	If .Not. _IsWindowDefined ( cParentWindowName )
		MsgHMGError("Window: "+ cParentWindowName + " is not defined. Program terminated")
		ExitProcess(0)
		Return Nil
	Endif

	If _IsControlDefined ( cControlName , cParentWindowName )
		MsgHMGError ("Control: " + cControlName + " Of " + cParentWindowName + " Already defined. Program Terminated")
		ExitProcess(0)
		Return Nil
	endif

	* Create Public control variable
	mVar := '_' + cParentWindowName + '_' + cControlName

	* Get Parent Window Handle
	nParentWindowHandle := GetFormHandle ( cParentWindowName )
	_HMG_SYSDATA [ 312 ] := nParentWindowHandle

	* Get Id For Control
	nId := _GetId()

	* Create Control
	aTemp := InitToolBar ( nParentWindowHandle , nId , nButtonWidth , nButtonHeight , lBorder , lFlat , lBottom , lRightText , lSplitBoxActive , nImageWidth , nImageHeight , lStrictWidth )

	nControlHandle := atemp[1]

	_HMG_SYSDATA [ 315 ]	:= aTemp [2]
	_HMG_SYSDATA [ 300 ]	:= aTemp [3]

	_HMG_SYSDATA [ 310 ] := nControlHandle

	* Set Font
	// unused nFontHandle := _SetFont (...   . asistex
	If ValType(cFontName) != "U" .and. ValType(nFontSize) != "U"
		_SetFont (nControlHandle,cFontName,nFontSize,lbold,litalic,lunderline,lstrikeout)
	Else
		_SetFont (nControlHandle,_HMG_SYSDATA [ 342 ],_HMG_SYSDATA [ 343 ],lbold,litalic,lunderline,lstrikeout)
	Endif

	if ValType(cToolTip) != "U"
	        SetToolTip ( nControlHandle , cToolTip , GetFormToolTipHandle (cParentWindowName) )
	endif

	* Get Position In Control Arrays
	k := _GetControlFree()

	Public &mVar. := k

	_HMG_SYSDATA [1]		[k] := "TOOLBAR"
	_HMG_SYSDATA [2]		[k] := cControlName
	_HMG_SYSDATA [3]		[k] := nControlHandle
	_HMG_SYSDATA [4]		[k] := nParentWindowHandle
	_HMG_SYSDATA [  5 ]		[k] := nId
	_HMG_SYSDATA [  6 ]		[k] := Nil
	_HMG_SYSDATA [  7 ]		[k] := {}
	_HMG_SYSDATA [  8 ]		[k] := Nil
	_HMG_SYSDATA [  9 ]		[k] := ""
	_HMG_SYSDATA [ 10 ]		[k] := ""
	_HMG_SYSDATA [ 11 ]		[k] := ""
	_HMG_SYSDATA [ 12 ]		[k] := ""
	_HMG_SYSDATA [ 13 ]		[k] := .F.
	_HMG_SYSDATA [ 14 ]		[k] := Nil
	_HMG_SYSDATA [ 15 ]		[k] := Nil
	_HMG_SYSDATA [ 16 ]		[k] := ""
	_HMG_SYSDATA [ 17 ]		[k] := {}
	_HMG_SYSDATA [ 18 ]		[k] := IF (VALTYPE (lBottom) == "L",         lBottom,         .F.)   // ADD
	_HMG_SYSDATA [ 19 ]		[k] := IF (VALTYPE (lSplitBoxActive) == "L", lSplitBoxActive, .F.)   // ADD
	_HMG_SYSDATA [ 20 ]		[k] := nButtonWidth
	_HMG_SYSDATA [ 21 ]		[k] := nButtonHeight
	_HMG_SYSDATA [ 22 ]		[k] := 0
	_HMG_SYSDATA [ 23 ]		[k] := -1
	_HMG_SYSDATA [ 24 ]		[k] := -1
	_HMG_SYSDATA [ 25 ]		[k] := ""
	_HMG_SYSDATA [ 26 ]		[k] := 0
	_HMG_SYSDATA [ 27 ]		[k] := ""
	_HMG_SYSDATA [ 28 ]		[k] := 0
	_HMG_SYSDATA [ 29 ]		[k] := {.f.,.f.,.f.,.f.}
	_HMG_SYSDATA [ 30 ]		[k] := ""
	_HMG_SYSDATA [ 31 ]		[k] := 0
	_HMG_SYSDATA [ 32 ]		[k] := 0
	_HMG_SYSDATA [ 33 ]		[k] := ""
	_HMG_SYSDATA [ 34 ]		[k] := .t.
	_HMG_SYSDATA [ 35 ]		[k] := 0
	_HMG_SYSDATA [ 36 ]		[k] := 0
	_HMG_SYSDATA [ 37 ]		[k] := 0
	_HMG_SYSDATA [ 38 ]		[k] := .T.
	_HMG_SYSDATA [ 39 ]		[k] := 0
	_HMG_SYSDATA [ 40 ] 		[k] := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }


Return Nil

*-----------------------------------------------------------------------------*
Function _DefineToolButton ( cControlName , ;
		cPicture , ;
		cCaption , ;
		bAction , ;
		lSeparator , ;
		lAutoSize , ;
		lCheck , ;
		lGroup , ;
		lDropdown , ;
		lWholeDropDown , ;
		cToolTip , ;
		notrans )

Local nId
Local nControlHandle
Local cParentWindowName
Local nParentWindowHandle
Local mVar
Local k
Local i
Local c
Local nToolBarIndex
Local nButtonPos

	* Gets Toolbar Parent Window Name
	cParentWindowName := _HMG_SYSDATA [ 311 ]

	* Error Checking

	If .Not. _IsWindowDefined ( cParentWindowName )
		MsgHMGError("Window: "+ cParentWindowName + " is not defined. Program terminated")
		ExitProcess(0)
		Return Nil
	Endif

	If _IsControlDefined ( cControlName , cParentWindowName )
		MsgHMGError ("Control: " + cControlName + " Of " + cParentWindowName + " Already defined. Program Terminated")
		ExitProcess(0)
		Return Nil
	endif

	If lDropdown == .T. .And. ValType(bAction) = 'U'
		MsgHMGError ("Control: " + cControlName + " Of " + cParentWindowName + ". ToolBar DropDown buttons must have an associated action (Use WholeDropDown style for no action). Program Terminated")
		ExitProcess(0)
		Return Nil
	EndIf

	* Get Parent Window Handle
	nParentWindowHandle := _HMG_SYSDATA [ 312 ]

	* Create Public control variable
	mVar := '_' + cParentWindowName + '_' + cControlName

	* Get Id
	nId := _GetId()

	* Increment ToolBar Button Count
	_HMG_SYSDATA [ 309 ]++

	* Create Control
	nControlHandle := InitToolButton (		;
			_HMG_SYSDATA [ 310 ]	, ;
			cPicture			, ;
			cCaption			, ;
			nId				, ;
			lSeparator			, ;
			lAutoSize			, ;
			lCheck				, ;
			lGroup				, ;
			lDropdown			, ;
			lWholeDropDown			, ;
			_HMG_SYSDATA [ 315 ]	, ;
			_HMG_SYSDATA [ 300 ], ;
         notrans )


	k := _GetControlFree()

	Public &mVar. := k

	_HMG_SYSDATA [1]		[k] := "TOOLBUTTON"
	_HMG_SYSDATA [2]		[k] :=  cControlName
	_HMG_SYSDATA [3]		[k] :=  nControlHandle
	_HMG_SYSDATA [4]		[k] :=  nParentWindowHandle
	_HMG_SYSDATA [  5 ]		[k] :=  nId
	_HMG_SYSDATA [  6 ]		[k] :=  bAction
	_HMG_SYSDATA [  7 ]		[k] :=  {}
	_HMG_SYSDATA [  8 ]		[k] :=  _HMG_SYSDATA [ 309 ]   // ToolBar Button Count
	_HMG_SYSDATA [  9 ]		[k] :=  ""
	_HMG_SYSDATA [ 10 ]		[k] :=  ""
	_HMG_SYSDATA [ 11 ]		[k] :=  ""
	_HMG_SYSDATA [ 12 ]		[k] :=  ""
	_HMG_SYSDATA [ 13 ]		[k] :=  .F.
	_HMG_SYSDATA [ 14 ]		[k] :=  Nil
	_HMG_SYSDATA [ 15 ]		[k] :=  Nil
	_HMG_SYSDATA [ 16 ]		[k] := ""
	_HMG_SYSDATA [ 17 ]		[k] := {}
	_HMG_SYSDATA [ 18 ]		[k] := Nil
	_HMG_SYSDATA [ 19 ]		[k] := Nil
	_HMG_SYSDATA [ 20 ]		[k] := 0
	_HMG_SYSDATA [ 21 ]		[k] := 0
	_HMG_SYSDATA [ 22 ]		[k] := 0
	_HMG_SYSDATA [ 23 ]		[k] := -1
	_HMG_SYSDATA [ 24 ]		[k] := -1
	_HMG_SYSDATA [ 25 ]		[k] := cPicture
	_HMG_SYSDATA [ 26 ]		[k] := _HMG_SYSDATA [ 310 ]   // ToolBar Handle
	_HMG_SYSDATA [ 27 ]		[k] := ''
	_HMG_SYSDATA [ 28 ]		[k] := 0
	_HMG_SYSDATA [ 29 ]		[k] := {.f.,.f.,.f.,.f.}
	_HMG_SYSDATA [ 30 ]		[k] := cToolTip
	_HMG_SYSDATA [ 31 ]		[k] := 0
	_HMG_SYSDATA [ 32 ]		[k] := notrans
	_HMG_SYSDATA [ 33 ]		[k] := cCaption
	_HMG_SYSDATA [ 34 ]		[k] := .t.
	_HMG_SYSDATA [ 35 ]		[k] := 0
	_HMG_SYSDATA [ 36 ]		[k] := 0
	_HMG_SYSDATA [ 37 ]		[k] := 0
	_HMG_SYSDATA [ 38 ]		[k] := .T.
	_HMG_SYSDATA [ 39 ]		[k] := 0
	_HMG_SYSDATA [ 40 ] 		[k] := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

	If ValType ( cCaption ) != 'U'

      SetToolButtonCaption ( _HMG_SYSDATA [26] [k] , _HMG_SYSDATA [5] [k] , cCaption)   // ADD HMG 3.0.45
		cCaption := HMG_UPPER ( cCaption )

		i := HB_UAT ( '&' , cCaption )

		If i > 0
			c := ASC ( HB_USUBSTR ( cCaption , i+1 , 1 ) )

			If c >= 48 .And. c <= 90

				nToolBarIndex := aScan ( _HMG_SYSDATA [ 3 ] , _HMG_SYSDATA [ 310 ] )
				nButtonPos := _HMG_SYSDATA [ 309 ]

				If lWholeDropDown == .T.
					bAction := { || _DropDownShortcut ( nId , nParentWindowHandle , nToolBarIndex , nButtonPos ) }
				EndIf

				_DefineHotKey ( cParentWindowName , MOD_ALT , c , bAction )

			EndIf
		EndIf

	EndIf

Return Nil

*-----------------------------------------------------------------------------*
Function _EndToolBar ()
*-----------------------------------------------------------------------------*
Local i

	ActivateToolBar ( _HMG_SYSDATA [ 310 ] )

	if _HMG_SYSDATA [ 262 ] == .T.
		i := GetFormIndex ( _HMG_SYSDATA [ 222 ] )

		AddSplitBoxItem ( _HMG_SYSDATA [ 310 ] , ;
				_HMG_SYSDATA [ 87 ] [i] ,  ;
				 GetToolBarWidth(_HMG_SYSDATA [ 310 ]) , ;
				_HMG_SYSDATA [ 261 ] , ;
				_HMG_SYSDATA [ 313 ] , ;
				GetToolBarWidth(_HMG_SYSDATA [ 310 ]) , ;
				GetToolBarHeight(_HMG_SYSDATA [ 310 ]) , ;
				_HMG_SYSDATA [ 258 ] ;
				)

	EndIf
Return Nil

// #define WM_USER     1024        // ok (MinGW)
#define WM_USER         0x0400        // ok
#define TB_SETHOTITEM    (WM_USER+72)   // ok

*------------------------------------------------------------------------------*
Procedure _DropDownShortcut ( nToolButtonId , nParentWindowHandle , i , nButtonPos )
*------------------------------------------------------------------------------*
Local aPos
Local aSize
Local x


	x  := Ascan ( _HMG_SYSDATA [  5 ] , nToolButtonId )

	if x > 0 .And. _HMG_SYSDATA [1] [x] = "TOOLBUTTON"
		aPos:= {0,0,0,0}
		GetWindowRect(_HMG_SYSDATA [3] [i],aPos)
		aSize := GetToolButtonSize ( _HMG_SYSDATA [3] [i] , _HMG_SYSDATA [  8 ] [ x ] - 1 )

		SendMessage( _HMG_SYSDATA [3] [i] , TB_SETHOTITEM, nButtonPos - 1 ,  0 )

		TrackPopupMenu ( _HMG_SYSDATA [ 32 ] [x] , aPos[1] + aSize [1] , aPos[2] + aSize [2] + ( aPos[4] - aPos[2] - aSize [2] ) / 2 , nParentWindowHandle )

		SendMessage( _HMG_SYSDATA [3] [i] , TB_SETHOTITEM, -1 ,  0 )

    	EndIf


Return


// by Dr. Claudio Soto (May 2014)
*------------------------------------------------------------------------------*
PROCEDURE RepositionToolBar (nIndex)
*------------------------------------------------------------------------------*
LOCAL nRow, nCol, cFormName

   DEFAULT nIndex TO GetLastActiveFormIndex()
   IF nIndex > 0
      cFormName := GetFormNameByIndex (nIndex)
      IF BT_StatusBarHeight (cFormName) > 0 .AND. BT_ToolBarBottomHeight (cFormName) > 0
         nCol := GETWINDOWCOL (BT_ToolBarBottomHandle(cFormName))
         ScreenToClient (GetFormHandle(cFormName), @nCOL, NIL)
         nRow := BT_ClientAreaHeight(cFormName) - BT_ToolBarBottomHeight(cFormName) - BT_StatusBarHeight (cFormName)
         SetWindowPos (BT_ToolBarBottomHandle(cFormName), 0, nCol, nRow, 0, 0, SWP_NOSIZE + SWP_NOZORDER)
      ENDIF
   ENDIF

RETURN

