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
#define BM_GETCHECK      240   // ok
#define BST_UNCHECKED    0     // ok
#define BST_CHECKED      1     // ok
#define BM_SETCHECK      241   // ok
#include "hmg.ch"
#include "common.ch"
*-----------------------------------------------------------------------------*
Function _DefineCheckBox ( ControlName, ParentForm, x, y, Caption, Value, ;
                           fontname, fontsize, tooltip, changeprocedure, w, h,;
                           lostfocus, gotfocus, HelpId, invisible, notabstop , bold, italic, underline, strikeout , field  , backcolor , fontcolor , transparent, OnEnter )
*-----------------------------------------------------------------------------*
Local cParentForm , mVar , k
Local ControlHandle
Local FontHandle
Local WorkArea
Local cParentTabName := ''
Local cParentWindowName := ''

   DEFAULT value           TO FALSE
   DEFAULT w               TO 100
   DEFAULT h               TO 28
   DEFAULT lostfocus       TO ""
   DEFAULT gotfocus        TO ""
   DEFAULT changeprocedure TO ""
   DEFAULT invisible       TO FALSE
   DEFAULT notabstop       TO FALSE

	If ValType ( Field ) != 'U'
		if  HB_UAT ( '>', Field ) == 0
			MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " : You must specify a fully qualified field name. Program Terminated" )
		Else
			WorkArea := HB_ULEFT ( Field , HB_UAT ( '>', Field ) - 2 )
			If Select (WorkArea) != 0
				Value := &(Field)
			EndIf
		EndIf
	EndIf

	if _HMG_SYSDATA [ 264 ] = .T.
		ParentForm := _HMG_SYSDATA [ 223 ]
		if .Not. Empty (_HMG_SYSDATA [ 224 ]) .And. ValType(FontName) == "U"
			FontName := _HMG_SYSDATA [ 224 ]
		EndIf
		if .Not. Empty (_HMG_SYSDATA [ 182 ]) .And. ValType(FontSize) == "U"
			FontSize := _HMG_SYSDATA [ 182 ]
		EndIf
	endif
	if _HMG_SYSDATA [ 183 ] > 0
		IF _HMG_SYSDATA [ 240 ] == .F.
		x 	:= x + _HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]]
		y 	:= y + _HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]]
		ParentForm	:= _HMG_SYSDATA [ 332 ] [_HMG_SYSDATA [ 183 ]]

		cParentTabName := _HMG_SYSDATA [ 225 ]
		cParentWindowName := ParentForm
		ENDIF
	EndIf

	If .Not. _IsWindowDefined (ParentForm)
		MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
	Endif

	If _IsControlDefined (ControlName,ParentForm)
		MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
	endif

	mVar := '_' + ParentForm + '_' + ControlName

	cParentForm := ParentForm

	ParentForm = GetFormHandle (ParentForm)

	Controlhandle := InitCheckBox ( ParentForm, Caption, 0, x, y, '', 0 , w , h, invisible, notabstop )

	if ValType(fontname) != "U" .and. ValType(fontsize) != "U"
		FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
	Else
		FontHandle := _SetFont (ControlHandle,_HMG_SYSDATA [ 342 ],_HMG_SYSDATA [ 343 ],bold,italic,underline,strikeout)
	endif

	If _HMG_SYSDATA [ 265 ] = .T.
		aAdd ( _HMG_SYSDATA [ 142 ] , Controlhandle )
	EndIf

	if ValType(tooltip) != "U"
		SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
	endif

	k := _GetControlFree()

	Public &mVar. := k

	_HMG_SYSDATA [1] [k] := "CHECKBOX"
	_HMG_SYSDATA [2] [k] :=   ControlName
	_HMG_SYSDATA [3] [k] :=   ControlHandle
	_HMG_SYSDATA [4] [k] :=   ParentForm
	_HMG_SYSDATA [  5 ] [k] :=   0
	_HMG_SYSDATA [  6 ] [k] :=   OnEnter
	_HMG_SYSDATA [  7 ] [k] :=   Field
	_HMG_SYSDATA [  8 ] [k] :=   Nil
	_HMG_SYSDATA [  9 ] [k] :=   transparent
	_HMG_SYSDATA [ 10 ] [k] :=   lostfocus
	_HMG_SYSDATA [ 11 ] [k] :=   gotfocus
	_HMG_SYSDATA [ 12 ] [k] :=   changeprocedure
	_HMG_SYSDATA [ 13 ] [k] :=   .F.
	_HMG_SYSDATA [ 14 ] [k] :=   backcolor
	_HMG_SYSDATA [ 15 ] [k] :=   fontcolor
	_HMG_SYSDATA [ 16 ] [k] :=   _HMG_SYSDATA [ 266 ]
	_HMG_SYSDATA [ 17 ] [k] :=   {}
	_HMG_SYSDATA [ 18 ]  [k] :=  y
	_HMG_SYSDATA [ 19 ] [k] :=   x
	_HMG_SYSDATA [ 20 ]  [k] :=  w
	_HMG_SYSDATA [ 21 ] [k] :=   h
	_HMG_SYSDATA [ 22 ]  [k] :=  0
	_HMG_SYSDATA [ 23 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 24 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 25 ]  [k] :=  ""
	_HMG_SYSDATA [ 26 ]  [k] :=  0
	_HMG_SYSDATA [ 27 ]  [k] :=  fontname
	_HMG_SYSDATA [ 28 ]  [k] :=  fontsize
	_HMG_SYSDATA [ 29 ]  [k] :=  {bold,italic,underline,strikeout}
	_HMG_SYSDATA [ 30 ]  [k] :=   tooltip
	_HMG_SYSDATA [ 31 ]  [k] :=  cParentTabName
	_HMG_SYSDATA [ 32 ]  [k] :=  cParentWindowName
	_HMG_SYSDATA [ 33 ]  [k] :=  Caption
	_HMG_SYSDATA [ 34 ]  [k] :=  if(invisible,FALSE,TRUE)
	_HMG_SYSDATA [ 35 ]  [k] :=  HelpId
	_HMG_SYSDATA [ 36 ]  [k] := FontHandle
	_HMG_SYSDATA [ 37 ] [k] :=  0
	_HMG_SYSDATA [ 38 ] [k] :=  .T.
	_HMG_SYSDATA [ 39 ] [k] := 0
	_HMG_SYSDATA [ 40 ] [k] := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

	if value = .t.
	     	SendMessage( Controlhandle , BM_SETCHECK  , BST_CHECKED , 0 )
	endif

	if valtype ( Field ) != 'U'
		if k > 0
			aAdd ( _HMG_SYSDATA [ 89 ]	[ GetFormIndex ( cParentForm ) ] , k )
		Else
			aAdd ( _HMG_SYSDATA [ 89 ]	[ GetFormIndex ( cParentForm ) ] , HMG_LEN (_HMG_SYSDATA [3]) )
		EndIf
	EndIf

Return Nil
*-----------------------------------------------------------------------------*
Function _DefineCheckButton ( ControlName, ParentForm, x, y, Caption, Value, ;
                              fontname, fontsize, tooltip, changeprocedure, ;
                              w, h, lostfocus, gotfocus, HelpId, invisible, ;
                              notabstop , bold, italic, underline, strikeout, OnEnter )
*-----------------------------------------------------------------------------*
Local cParentForm , mVar , k
Local ControlHandle
Local FontHandle

   DEFAULT value           TO FALSE
   DEFAULT w               TO 100
   DEFAULT h               TO 28
   DEFAULT lostfocus       TO ""
   DEFAULT gotfocus        TO ""
   DEFAULT changeprocedure TO ""
   DEFAULT invisible       TO FALSE
   DEFAULT notabstop       TO FALSE

	if _HMG_SYSDATA [ 264 ] = .T.
		ParentForm := _HMG_SYSDATA [ 223 ]
		if .Not. Empty (_HMG_SYSDATA [ 224 ]) .And. ValType(FontName) == "U"
			FontName := _HMG_SYSDATA [ 224 ]
		EndIf
		if .Not. Empty (_HMG_SYSDATA [ 182 ]) .And. ValType(FontSize) == "U"
			FontSize := _HMG_SYSDATA [ 182 ]
		EndIf
	endif
	if _HMG_SYSDATA [ 183 ] > 0
		IF _HMG_SYSDATA [ 240 ] == .F.
		x 	:= x + _HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]]
		y 	:= y + _HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]]
		ParentForm := _HMG_SYSDATA [ 332 ] [_HMG_SYSDATA [ 183 ]]
		ENDIF
	EndIf

	If .Not. _IsWindowDefined (ParentForm)
		MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
	Endif

	If _IsControlDefined (ControlName,ParentForm)
		MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
	endif

	mVar := '_' + ParentForm + '_' + ControlName

	cParentForm := ParentForm

	ParentForm = GetFormHandle (ParentForm)

	Controlhandle := InitCheckButton ( ParentForm, Caption, 0, x, y, '', 0 , w , h, invisible, notabstop )

	if ValType(fontname) != "U" .and. ValType(fontsize) != "U"
		FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
	Else
		FontHandle := _SetFont (ControlHandle,_HMG_SYSDATA [ 342 ],_HMG_SYSDATA [ 343 ],bold,italic,underline,strikeout)
	endif

	If _HMG_SYSDATA [ 265 ] = .T.
		aAdd ( _HMG_SYSDATA [ 142 ] , ControlHandle )
	EndIf

	if ValType(tooltip) != "U"
		SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
	endif

	k := _GetControlFree()

	Public &mVar. := k

	_HMG_SYSDATA [1] [k] := "CHECKBOX"
	_HMG_SYSDATA [2] [k] :=   ControlName
	_HMG_SYSDATA [3] [k] :=   ControlHandle
	_HMG_SYSDATA [4] [k] :=   ParentForm
	_HMG_SYSDATA [  5 ] [k] :=   0
	_HMG_SYSDATA [  6 ] [k] :=  OnEnter
	_HMG_SYSDATA [  7 ]  [k] :=  {}
	_HMG_SYSDATA [  8 ]  [k] :=  Nil
	_HMG_SYSDATA [  9 ]   [k] := ""
	_HMG_SYSDATA [ 10 ]  [k] :=  lostfocus
	_HMG_SYSDATA [ 11 ]  [k] :=  gotfocus
	_HMG_SYSDATA [ 12 ]  [k] :=  changeprocedure
	_HMG_SYSDATA [ 13 ]  [k] :=  .F.
	_HMG_SYSDATA [ 14 ]   [k] := Nil
	_HMG_SYSDATA [ 15 ]   [k] := Nil
	_HMG_SYSDATA [ 16 ]   [k] := ""
	_HMG_SYSDATA [ 17 ]  [k] :=  {}
	_HMG_SYSDATA [ 18 ]  [k] :=  y
	_HMG_SYSDATA [ 19 ]   [k] := x
	_HMG_SYSDATA [ 20 ]   [k] := w
	_HMG_SYSDATA [ 21 ]   [k] := h
	_HMG_SYSDATA [ 22 ]   [k] := 0
	_HMG_SYSDATA [ 23 ]   [k] := iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 24 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 25 ]  [k] :=  ""
	_HMG_SYSDATA [ 26 ]  [k] :=  0
	_HMG_SYSDATA [ 27 ]   [k] := fontname
	_HMG_SYSDATA [ 28 ]   [k] := fontsize
	_HMG_SYSDATA [ 29 ]   [k] := {bold,italic,underline,strikeout}
	_HMG_SYSDATA [ 30 ]  [k] :=   tooltip
	_HMG_SYSDATA [ 31 ]   [k] :=  0
	_HMG_SYSDATA [ 32 ]   [k] :=  0
	_HMG_SYSDATA [ 33 ]   [k] :=  Caption
	_HMG_SYSDATA [ 34 ]  [k] :=   if(invisible,FALSE,TRUE)
	_HMG_SYSDATA [ 35 ]  [k] :=   HelpId
	_HMG_SYSDATA [ 36 ]   [k] :=  FontHandle
	_HMG_SYSDATA [ 37 ]   [k] :=  0
	_HMG_SYSDATA [ 38 ]  [k] :=   .T.
	_HMG_SYSDATA [ 39 ] [k] := 0
	_HMG_SYSDATA [ 40 ] [k] := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

	if value = .t.
	     	SendMessage( Controlhandle , BM_SETCHECK  , BST_CHECKED , 0 )
	endif

Return Nil
*-----------------------------------------------------------------------------*
Function _DefineImageCheckButton ( ControlName, ParentForm, x, y, Picture, ;
                                   Value, fontname, fontsize, tooltip, ;
                                   changeprocedure, w, h, lostfocus, gotfocus,;
                                   HelpId, invisible, notabstop, notrans, OnEnter )
*-----------------------------------------------------------------------------*
Local cParentForm , mVar , k
Local ControlHandle
Local aRet

   DEFAULT value           TO FALSE
   DEFAULT w               TO 100
   DEFAULT h               TO 28
   DEFAULT lostfocus       TO ""
   DEFAULT gotfocus        TO ""
   DEFAULT changeprocedure TO ""
   DEFAULT invisible       TO FALSE
   DEFAULT notabstop       TO FALSE

	if _HMG_SYSDATA [ 264 ] = .T.
		ParentForm := _HMG_SYSDATA [ 223 ]
	endif
	if _HMG_SYSDATA [ 183 ] > 0
		IF _HMG_SYSDATA [ 240 ] == .F.
		x 	:= x + _HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]]
		y 	:= y + _HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]]
		ParentForm := _HMG_SYSDATA [ 332 ] [_HMG_SYSDATA [ 183 ]]
		ENDIF
	EndIf

	If .Not. _IsWindowDefined (ParentForm)
		MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
	Endif

	If _IsControlDefined (ControlName,ParentForm)
		MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
	endif

	mVar := '_' + ParentForm + '_' + ControlName

	cParentForm := ParentForm

	ParentForm = GetFormHandle (ParentForm)

	if IsAppThemed ()
		aRet := InitImageCheckButton ( ParentForm, "", 0, x, y, '', 0, Picture, w, h, invisible, notabstop, .T., notrans )
		Controlhandle := aRet [1]
	else
		aRet := InitImageCheckButton ( ParentForm, "", 0, x, y, '', 0, Picture, w, h, invisible, notabstop, .F., notrans )
		Controlhandle := aRet [1]
	endif

	If _HMG_SYSDATA [ 265 ] = .T.
		aAdd ( _HMG_SYSDATA [ 142 ] , ControlHandle )
	EndIf

	if ValType(tooltip) != "U"
		SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
	endif

	k := _GetControlFree()

	Public &mVar. := k

	_HMG_SYSDATA [  1 ]  [k] :=  "CHECKBOX"
	_HMG_SYSDATA [  2 ]  [k] :=  ControlName
	_HMG_SYSDATA [  3 ]  [k] :=  ControlHandle
	_HMG_SYSDATA [  4 ]  [k] :=  ParentForm
	_HMG_SYSDATA [  5 ]  [k] :=  0
	_HMG_SYSDATA [  6 ]  [k] :=  OnEnter
	_HMG_SYSDATA [  7 ]  [k] :=  {}
	_HMG_SYSDATA [  8 ]  [k] :=  Nil
	_HMG_SYSDATA [  9 ]  [k] :=  ""
	_HMG_SYSDATA [ 10 ]  [k] :=  lostfocus
	_HMG_SYSDATA [ 11 ]  [k] :=  gotfocus
	_HMG_SYSDATA [ 12 ]  [k] :=  changeprocedure
	_HMG_SYSDATA [ 13 ]  [k] :=  .F.
	_HMG_SYSDATA [ 14 ]  [k] :=  Nil
	_HMG_SYSDATA [ 15 ]  [k] :=  Nil
	_HMG_SYSDATA [ 16 ]  [k] :=  ""
	_HMG_SYSDATA [ 17 ]  [k] :=  {}
	_HMG_SYSDATA [ 18 ]  [k] :=  y
	_HMG_SYSDATA [ 19 ]  [k] :=  x
	_HMG_SYSDATA [ 20 ]  [k] :=  w
	_HMG_SYSDATA [ 21 ]  [k] :=  h
	_HMG_SYSDATA [ 22 ]  [k] :=  0
	_HMG_SYSDATA [ 23 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 24 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 25 ]  [k] :=  Picture
	_HMG_SYSDATA [ 26 ]  [k] :=  4 // BUTTON_IMAGELIST_ALIGN_CENTER
	_HMG_SYSDATA [ 27 ]  [k] :=  fontname
	_HMG_SYSDATA [ 28 ]  [k] :=  fontsize
	_HMG_SYSDATA [ 29 ]  [k] :=  {.f.,.f.,.f.,.f.}
	_HMG_SYSDATA [ 30 ]  [k] :=  tooltip
	_HMG_SYSDATA [ 31 ]  [k] :=  0
	_HMG_SYSDATA [ 32 ]  [k] :=  notrans // ADD
	_HMG_SYSDATA [ 33 ]  [k] :=  ''
	_HMG_SYSDATA [ 34 ]  [k] :=  if (invisible,FALSE,TRUE)
	_HMG_SYSDATA [ 35 ]  [k] :=  HelpId
	_HMG_SYSDATA [ 36 ]  [k] :=  0
	_HMG_SYSDATA [ 37 ]  [k] :=  aRet [2]
	_HMG_SYSDATA [ 38 ]  [k] :=  .T.
	_HMG_SYSDATA [ 39 ]  [k] :=  1
	_HMG_SYSDATA [ 40 ]  [k] :=  { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

	if value = .t.
	    	SendMessage( Controlhandle , BM_SETCHECK  , BST_CHECKED , 0 )
	endif

Return Nil

Procedure _DataCheckBoxRefresh (i)
Local Field

	Field		:= _HMG_SYSDATA [  7 ] [i]
	_SetValue ( '' , '' , &Field , i )

Return

Procedure _DataCheckBoxSave ( ControlName , ParentForm)
Local Field , i

	i := GetControlIndex ( ControlName , ParentForm)

	Field := _HMG_SYSDATA [  7 ] [i]

	REPLACE &Field WITH _GetValue ( Controlname , ParentForm )

Return

