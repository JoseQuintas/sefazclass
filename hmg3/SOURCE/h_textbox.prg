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

#include "common.ch"
#include "hmg.ch"

#define EM_REPLACESEL   194   // ok
#define WM_UNDO        772   // ok
#define EM_SETMODIFY    185   // ok
#define WM_PASTE       770   // ok
#define EM_GETLINE      196   // ok
#define EM_SETSEL       177   // ok
#define WM_CLEAR        771   // ok
#define EM_GETSEL       176   // ok
#define EM_UNDO        199    // ok
#define WM_SETTEXT     12      // ok

MEMVAR _HMG_SYSDATA

*--------------------------------------------------------*
function _DefineTextBox( cControlName, cParentForm, nx, ny, nWidth, nHeight, ;
                        cValue, cFontName, nFontSize, cToolTip, nMaxLength, ;
			lUpper, lLower, lNumeric, lPassword, ;
                        uLostFocus, uGotFocus, uChange , uEnter , RIGHT  , ;
			HelpId , readonly , bold, italic, underline, ;
			strikeout , field , backcolor , fontcolor , ;
			invisible , notabstop , disabledbackcolor , disabledfontcolor )
*--------------------------------------------------------*

	local nParentForm
	local nControlHandle
	local mVar
	Local FontHandle
	Local WorkArea
	Local k
	Local cParentTabName

	// Asign STANDARD values to optional params.
	DEFAULT nWidth     TO 120
	DEFAULT nHeight    TO 24
	DEFAULT cValue     TO ""
	DEFAULT uChange    TO ""
	DEFAULT uGotFocus  TO ""
	DEFAULT uLostFocus TO ""
	DEFAULT nMaxLength TO 0 // 255
	DEFAULT lUpper     TO .f.
	DEFAULT lLower     TO .f.
	DEFAULT lNumeric   TO .f.
	DEFAULT lPassword  TO .f.
	DEFAULT uEnter     TO ""

   DEFAULT readonly TO .f.
   DEFAULT bold TO .f.
   DEFAULT italic TO .f.
   DEFAULT underline TO .f.
   DEFAULT strikeout TO .f.
   DEFAULT RIGHT TO .f.
   DEFAULT invisible TO .f.
   DEFAULT notabstop TO .f.


	If ValType ( Field ) != 'U'
		if  HB_UAT ( '>', Field ) == 0
			MsgHMGError ("Control: " + cControlName + " Of " + cParentForm + " : You must specify a fully qualified field name. Program Terminated")
		Else
			WorkArea := HB_ULEFT ( Field , HB_UAT ( '>', Field ) - 2 )
			If Select (WorkArea) != 0
				cValue := &(Field)
			EndIf
		EndIf
	EndIf

	if _HMG_SYSDATA [ 264 ] = .T.
		cParentForm := _HMG_SYSDATA [ 223 ]
		if .Not. Empty (_HMG_SYSDATA [ 224 ]) .And. ValType(cFontName) == "U"
			cFontName := _HMG_SYSDATA [ 224 ]
		EndIf
		if .Not. Empty (_HMG_SYSDATA [ 182 ]) .And. ValType(nFontSize) == "U"
			nFontSize := _HMG_SYSDATA [ 182 ]
		EndIf
	endif

	if _HMG_SYSDATA [ 183 ] > 0
		IF _HMG_SYSDATA [ 240 ] == .F.
		nx 	:= nx + _HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]]
		ny 	:= ny + _HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]]
		cParentForm := _HMG_SYSDATA [ 332 ] [_HMG_SYSDATA [ 183 ]]
		cParentTabName := _HMG_SYSDATA [ 225 ]
		ENDIF
	EndIf

	nParentForm  := GetFormHandle( cParentForm )

	// Check if the window/form is defined.
	if ( .not. _IsWindowDefined( cParentForm ) )
		MsgHMGError( "Window: " + cParentForm + " is not defined. Program terminated." )
	endif

	// Check if the control is already defined.
	if ( _IsControlDefined( cControlName, cParentForm ) )
		MsgHMGError( "Control: " + cControlName + " of " + cParentForm + " already defined. Program Terminated." )
	endif

	mVar := '_' + cParentForm + '_' + cControlName

	// Creates the control window.
	nControlHandle := InitTextBox( nParentForm, 0, nx, ny, nWidth, nHeight, '', 0, nMaxLength, ;
                                 lUpper, lLower, .f., lPassword , RIGHT , readonly , invisible , notabstop )

	if ValType(cfontname) != "U" .and. ValType(nfontsize) != "U"
		FontHandle := _SetFont (nControlHandle,cFontName,nFontSize,bold,italic,underline,strikeout)
	Else
		FontHandle := _SetFont (nControlHandle,_HMG_SYSDATA [ 342 ],_HMG_SYSDATA [ 343 ],bold,italic,underline,strikeout)
	endif

	If _HMG_SYSDATA [ 265 ] = .T.
		aAdd ( _HMG_SYSDATA [ 142 ] , nControlHandle )
	EndIf

	// Add a tooltip if param has value.
	if ( ValType( cToolTip ) != "U" )
		SetToolTip( nControlHandle, cToolTip, GetFormToolTipHandle( cParentForm ) )
	endif

	k := _GetControlFree()

	Public &mVar. := k

	_HMG_SYSDATA [1] [k] := if( lNumeric, "NUMTEXT", "TEXT" )
	_HMG_SYSDATA [2]  [k] :=  cControlName
	_HMG_SYSDATA [3]  [k] :=  nControlHandle
	_HMG_SYSDATA [4]  [k] :=  nParentForm
	_HMG_SYSDATA [  5 ]  [k] :=  0
	_HMG_SYSDATA [  6 ]  [k] :=  ""
	_HMG_SYSDATA [  7 ]  [k] :=  Field
	_HMG_SYSDATA [  8 ]  [k] :=  nil
	_HMG_SYSDATA [  9 ]  [k] :=  ""
	_HMG_SYSDATA [  10 ] [k] :=   uLostFocus
	_HMG_SYSDATA [ 11 ]  [k] := uGotFocus
	_HMG_SYSDATA [ 12 ]  [k] :=  uChange
	_HMG_SYSDATA [ 13 ]  [k] :=  .F.
	_HMG_SYSDATA [ 14 ]  [k] :=  backcolor
	_HMG_SYSDATA [ 15 ] [k] :=   fontcolor
	_HMG_SYSDATA [ 16 ]  [k] :=  uEnter
	_HMG_SYSDATA [ 17 ]  [k] :=  {}
	_HMG_SYSDATA [ 18 ]  [k] :=  ny
	_HMG_SYSDATA [ 19 ]  [k] :=  nx
	_HMG_SYSDATA [ 20 ]   [k] := nwidth
	_HMG_SYSDATA [ 21 ]   [k] := nheight
	_HMG_SYSDATA [ 22 ]  [k] :=  0
	_HMG_SYSDATA [ 23 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 24 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 25 ]  [k] :=  ""
	_HMG_SYSDATA [ 26 ]  [k] :=  0
	_HMG_SYSDATA [ 27 ]  [k] :=  cfontname
	_HMG_SYSDATA [ 28 ]  [k] :=  nfontsize
	_HMG_SYSDATA [ 29 ]  [k] :=  {bold,italic,underline,strikeout}
	_HMG_SYSDATA [ 30 ]  [k] :=   ctooltip
	_HMG_SYSDATA [ 31 ]  [k] :=   cParentTabName
	_HMG_SYSDATA [ 32 ]  [k] :=   0
	_HMG_SYSDATA [ 33 ]  [k] :=   ''
	_HMG_SYSDATA [ 34 ]  [k] :=  .Not.  invisible
	_HMG_SYSDATA [ 35 ]  [k] :=   HelpId
	_HMG_SYSDATA [ 36 ]  [k] :=   FontHandle
	_HMG_SYSDATA [ 37 ]  [k] :=   0
	_HMG_SYSDATA [ 38 ]  [k] :=   .T.
	_HMG_SYSDATA [ 39 ] [k] := 0
	_HMG_SYSDATA [ 40 ] [k] := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

	_HMG_SYSDATA [ 40 ] [k] [  9 ] := DISABLEDBACKCOLOR
	_HMG_SYSDATA [ 40 ] [k] [ 10 ] := DISABLEDFONTCOLOR
	_HMG_SYSDATA [ 40 ] [k] [ 11 ] := readonly


	// With NUMERIC clause, transform numeric value into a string.
	if ( lNumeric )
		If ValType(cValue) != 'C'
			cValue := ALLTRIM( Str( cValue ) )
		EndIf
	EndIf

	// Fill the TEXTBOX with the text given.
	if ( HMG_LEN( cValue ) > 0 )
		SetWindowText ( nControlHandle , cValue )
	endif

	if valtype ( Field ) != 'U'
		aAdd ( _HMG_SYSDATA [ 89 ]	[ GetFormIndex ( cParentForm ) ] , k )
	EndIf

return nil
*-----------------------------------------------------------------------------*
Function _DefineMaskedTextbox ( ControlName, ParentForm, x, y, inputmask , width , value , fontname, fontsize , tooltip , lostfocus ,gotfocus , change , height , enter , rightalign  , HelpId , Format , bold, italic, underline, strikeout , field  , backcolor , fontcolor , readonly  , invisible , notabstop  , disabledbackcolor , disabledfontcolor )
*-----------------------------------------------------------------------------*
Local i, cParentForm ,c,mVar , WorkArea , k
Local ControlHandle
Local FontHandle
Local cParentTabName

* Unused Parameters
RightAlign := NIL
*
   DEFAULT readonly TO .f.
   DEFAULT bold TO .f.
   DEFAULT italic TO .f.
   DEFAULT underline TO .f.
   DEFAULT strikeout TO .f.
   DEFAULT RightAlign TO .f. // not used, but is defined as argument
   DEFAULT invisible TO .f.
   DEFAULT notabstop TO .f.


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

	if ValType(Format) == "U"
		Format := ""
	endif

	For i := 1 To HMG_LEN (InputMask)

		c := HB_USUBSTR ( InputMask , i , 1 )

#ifdef COMPILE_HMG_UNICODE
      if c != '9' .and.  c != '$' .and. c != '*' .and. c !='.' .and. c != ','  .and. c != ' ' .and. c != '€' .and. c != 'â‚¬'
#else
      if c != '9' .and.  c != '$' .and. c != '*' .and. c !='.' .and. c != ','  .and. c != ' ' .and. c != '€'
#endif
         MsgHMGError("@...TEXTBOX: Wrong InputMask Definition" )
      EndIf

	Next i

	For i := 1 To HMG_LEN (Format)

		c := HB_USUBSTR ( Format , i , 1 )

        	if c!='C' .and. c!='X' .and. c!= '('  .and. c!= 'E'
			MsgHMGError("@...TEXTBOX: Wrong Format Definition" )
		EndIf

	Next i

	if ValType(change) == "U"
		change := ""
	endif

	if ValType(gotfocus) == "U"
		gotfocus := ""
	endif

	if ValType(enter) == "U"
		enter := ""
	endif

	if ValType(lostfocus) == "U"
		lostfocus := ""
	endif

	if ValType(Width) == "U"
		Width := 120
	endif

	if ValType(height) == "U"
		height := 24
	endif

	if ValType(Value) == "U"
		Value := ""
	endif

	If .Not. Empty (Format)
		Format := '@' + ALLTRIM(Format)
	EndIf

	InputMask :=  Format + ' ' + InputMask

	Value := Transform ( value , InputMask )

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
		cParentTabName := _HMG_SYSDATA [ 225 ]
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

	ControlHandle := InitMaskedTextBox ( ParentForm, 0, x, y, width , '' , 0  , 255 , .f. , .f. , height , .t. , readonly  , invisible , notabstop )
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

	_HMG_SYSDATA [1] [k] := "MASKEDTEXT"
	_HMG_SYSDATA [2]  [k] :=  ControlName
	_HMG_SYSDATA [3] [k] :=   ControlHandle
	_HMG_SYSDATA [4] [k] :=   ParentForm
	_HMG_SYSDATA [  5 ]  [k] :=  0
	_HMG_SYSDATA [  6 ]  [k] :=  ""
	_HMG_SYSDATA [  7 ] [k] :=   InputMask
	_HMG_SYSDATA [  8 ]  [k] :=  Nil
	_HMG_SYSDATA [  9 ]  [k] :=  GetNumMask ( InputMask )
	_HMG_SYSDATA [ 10 ]  [k] :=  lostfocus
	_HMG_SYSDATA [ 11 ]  [k] :=  gotfocus
	_HMG_SYSDATA [ 12 ]  [k] :=  Change
	_HMG_SYSDATA [ 13 ]  [k] :=  .F.
	_HMG_SYSDATA [ 14 ]  [k] :=  backcolor
	_HMG_SYSDATA [ 15 ]  [k] :=  fontcolor
	_HMG_SYSDATA [ 16 ]  [k] :=  enter
	_HMG_SYSDATA [ 17 ]  [k] :=  Field
	_HMG_SYSDATA [ 18 ]  [k] :=  y
	_HMG_SYSDATA [ 19 ]  [k] :=  x
	_HMG_SYSDATA [ 20 ]  [k] :=  width
	_HMG_SYSDATA [ 21 ]  [k] :=  height
	_HMG_SYSDATA [ 22 ]  [k] :=  .F.
	_HMG_SYSDATA [ 23 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 24 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 25 ]   [k] := ""
	_HMG_SYSDATA [ 26 ]  [k] :=  0
	_HMG_SYSDATA [ 27 ]  [k] :=  fontname
	_HMG_SYSDATA [ 28 ]  [k] :=  fontsize
	_HMG_SYSDATA [ 29 ]  [k] :=  {bold,italic,underline,strikeout}
	_HMG_SYSDATA [ 30 ]   [k] :=  tooltip
	_HMG_SYSDATA [ 31 ]  [k] :=   cParentTabName
	_HMG_SYSDATA [ 32 ]  [k] :=   0
	_HMG_SYSDATA [ 33 ]  [k] :=   ''
	_HMG_SYSDATA [ 34 ]  [k] :=  .Not.  invisible
	_HMG_SYSDATA [ 35 ]  [k] :=   HelpId
	_HMG_SYSDATA [ 36 ]  [k] :=   FontHandle
	_HMG_SYSDATA [ 37 ]   [k] :=  0
	_HMG_SYSDATA [ 38 ]  [k] :=   .T.
	_HMG_SYSDATA [ 39 ] [k] := 0
	_HMG_SYSDATA [ 40 ] [k] := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

	_HMG_SYSDATA [ 40 ] [k] [  9 ] := DISABLEDBACKCOLOR
	_HMG_SYSDATA [ 40 ] [k] [ 10 ] := DISABLEDFONTCOLOR
	_HMG_SYSDATA [ 40 ] [k] [ 11 ] := readonly


	SetWindowText ( ControlHandle , value )

	if valtype ( Field ) != 'U'
		aAdd ( _HMG_SYSDATA [ 89 ]	[ GetFormIndex ( cParentForm ) ] , k )
	EndIf

Return Nil

Function GetNumFromText ( Text , i )
Local x , c , s

	s := ''

	For x := 1 To HMG_LEN ( Text )

		c := hb_USubStr(Text,x,1)

		If c='0' .or. c='1' .or. c='2' .or. c='3' .or. c='4' .or. c='5' .or. c='6' .or. c='7' .or. c='8' .or. c='9' .or. c='.' .or. c='-'
			s := s + c
		EndIf

	Next x

	If HB_ULEFT ( ALLTRIM(Text) , 1 ) == '(' .OR.  HB_URIGHT ( ALLTRIM(Text) , 2 ) == 'DB'
		s := '-' + s
	EndIf

	s := Transform ( Val(s) , _HMG_SYSDATA [  9 ] [i] )

Return Val(s)

Function GetNumMask ( Text )
Local i , c , s

	s := ''

	For i := 1 To HMG_LEN ( Text )

		c := hb_USubStr(Text,i,1)

		If c='9' .or. c='.'
			s := s + c
		EndIf

		if c = '$' .or. c = '*'
			s := s+'9'
		EndIf

	Next i

Return s

*-----------------------------------------------------------------------------*
Function _DefineCharMaskTextbox ( ControlName, ParentForm, x, y, inputmask , width , value , fontname, fontsize , tooltip , lostfocus ,gotfocus , change , height , enter , rightalign  , HelpId , bold, italic, underline, strikeout , field  , backcolor , fontcolor , date , readonly  , invisible , notabstop , disabledbackcolor , disabledfontcolor )
*-----------------------------------------------------------------------------*
Local cParentForm, mVar, WorkArea , dateformat , k
Local ControlHandle
Local FontHandle
Local cParentTabName

   DEFAULT invisible  TO .F.

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

	if ValType(date) == "U"
		date := .F.
	endif

	if ValType(change) == "U"
		change := ""
	endif

	if ValType(gotfocus) == "U"
		gotfocus := ""
	endif

	if ValType(enter) == "U"
		enter := ""
	endif

	if ValType(lostfocus) == "U"
		lostfocus := ""
	endif

	if ValType(Width) == "U"
		Width := 120
	endif

	if ValType(height) == "U"
		height := 24
	endif

	if ValType(Value) == "U"
		if date == .F.
			Value := ""
		else
			Value := ctod ('  /  /  ')
		endif
	endif

	dateformat := set ( _SET_DATEFORMAT )

	if date == .t.
		if HMG_LOWER ( HB_ULEFT ( dateformat , 4 ) ) == "yyyy"

			if '/' $ dateformat
				Inputmask := '9999/99/99'
			Elseif '.' $ dateformat
				Inputmask := '9999.99.99'
			Elseif '-' $ dateformat
				Inputmask := '9999-99-99'
			EndIf

		elseif HMG_LOWER ( HB_URIGHT ( dateformat , 4 ) ) == "yyyy"

			if '/' $ dateformat
				Inputmask := '99/99/9999'
			Elseif '.' $ dateformat
				Inputmask := '99.99.9999'
			Elseif '-' $ dateformat
				Inputmask := '99-99-9999'
			EndIf

		else

			if '/' $ dateformat
				Inputmask := '99/99/99'
			Elseif '.' $ dateformat
				Inputmask := '99.99.99'
			Elseif '-' $ dateformat
				Inputmask := '99-99-99'
			EndIf

		endif
	endif

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
		cParentTabName := _HMG_SYSDATA [ 225 ]
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

	ControlHandle := InitCharMaskTextBox ( ParentForm, 0, x, y, width , '' , 0  , 255 , .f. , .f. , height , rightalign , readonly  , invisible , notabstop )
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

	_HMG_SYSDATA [1] [k] := "CHARMASKTEXT"
	_HMG_SYSDATA [2] [k] := ControlName
	_HMG_SYSDATA [3] [k] := ControlHandle
	_HMG_SYSDATA [4] [k] := ParentForm
	_HMG_SYSDATA [  5 ] [k] := 0
	_HMG_SYSDATA [  6 ] [k] := ""
	_HMG_SYSDATA [  7 ] [k] := Field
	_HMG_SYSDATA [  8 ] [k] := Nil
	_HMG_SYSDATA [  9 ] [k] := InputMask
	_HMG_SYSDATA [ 10 ] [k] := lostfocus
	_HMG_SYSDATA [ 11 ] [k] := gotfocus
	_HMG_SYSDATA [ 12 ] [k] := Change
	_HMG_SYSDATA [ 13 ] [k] := .F.
	_HMG_SYSDATA [ 14 ] [k] := backcolor
	_HMG_SYSDATA [ 15 ] [k] := fontcolor
	_HMG_SYSDATA [ 16 ] [k] := enter
	_HMG_SYSDATA [ 17 ]  [k] :=date
	_HMG_SYSDATA [ 18 ] [k] := y
	_HMG_SYSDATA [ 19 ] [k] := x
	_HMG_SYSDATA [ 20 ] [k] := width
	_HMG_SYSDATA [ 21 ] [k] := height
	_HMG_SYSDATA [ 22 ] [k] := 0
	_HMG_SYSDATA [ 23 ] [k] := iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 24 ] [k] := iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 25 ] [k] := ""
	_HMG_SYSDATA [ 26 ] [k] := 0
	_HMG_SYSDATA [ 27 ] [k] := fontname
	_HMG_SYSDATA [ 28 ] [k] := fontsize
	_HMG_SYSDATA [ 29 ] [k] := {bold,italic,underline,strikeout}
	_HMG_SYSDATA [ 30 ]  [k] := tooltip
	_HMG_SYSDATA [ 31 ] [k] :=  cParentTabName
	_HMG_SYSDATA [ 32 ] [k] :=  0
	_HMG_SYSDATA [ 33 ] [k] :=  ''
	_HMG_SYSDATA [ 34 ] [k] := .Not.  invisible
	_HMG_SYSDATA [ 35 ]  [k] := HelpId
	_HMG_SYSDATA [ 36 ] [k] :=  FontHandle
	_HMG_SYSDATA [ 37 ]  [k] := 0
	_HMG_SYSDATA [ 38 ] [k] :=  .T.
	_HMG_SYSDATA [ 39 ] [k] := 0
	_HMG_SYSDATA [ 40 ] [k] := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

	_HMG_SYSDATA [ 40 ] [k] [  9 ] := DISABLEDBACKCOLOR
	_HMG_SYSDATA [ 40 ] [k] [ 10 ] := DISABLEDFONTCOLOR
	_HMG_SYSDATA [ 40 ] [k] [ 11 ] := readonly

	if date == .F.
		SetWindowText ( ControlHandle , Value  )
	Else
		SetWindowText ( ControlHandle , dtoc ( Value ) )
	endif

	if valtype ( Field ) != 'U'
		aAdd ( _HMG_SYSDATA [ 89 ]	[ GetFormIndex ( cParentForm ) ] , k )
	EndIf

Return Nil

*------------------------------------------------------------------------------*
PROCEDURE ProcessCharMask ( i , d )
*------------------------------------------------------------------------------*
Local InBuffer , OutBuffer := '' , icp , x , CB , CM , BadEntry := .F. , InBufferLeft , InBufferRight , Mask , OldChar , BackInbuffer
Local pc := 0
Local fnb := 0
Local dc := 0
Local pFlag := .F.
Local ncp
Local NegativeZero := .F.
Local Output
Local ol := 0

* Unused Parameters
d := Nil
*

	If ValType (_HMG_SYSDATA [ 22 ] [i] ) == 'L'
		If _HMG_SYSDATA [ 22 ] [i] == .F.
			Return
		EndIf
	EndIf

	Mask := _HMG_SYSDATA [  9 ] [i]

	// Store Initial CaretPos

	icp := HiWord ( SendMessage( _HMG_SYSDATA [3] [i] , EM_GETSEL , 0 , 0 ) )

	// Get Current Content

	InBuffer := GetWindowText ( _HMG_SYSDATA [3] [i] )

	// RL 104

	If HB_ULEFT ( ALLTRIM(InBuffer) , 1 ) == '-' .And. Val(InBuffer) == 0
		// Tone (1000,1)
		NegativeZero := .T.
	EndIf

	//

	If PCount() > 1

		// Point Count For Numeric InputMask

		For x := 1 To HMG_LEN ( InBuffer )
			CB := HB_USUBSTR (InBuffer , x , 1 )
			If CB == '.' .or. ;
            CB == ","   // MOL, April 2016
			     pc++
			EndIf
		Next x

		// RL 89
		If HB_ULEFT (InbuFfer,1) == '.' .or. ;
         HB_ULEFT (InbuFfer,1) == ','   // MOL, April 2016
			pFlag := .T.
		EndIf
		//

		// Find First Non-Blank Position

		For x := 1 To HMG_LEN ( InBuffer )
			CB := HB_USUBSTR (InBuffer , x , 1 )
			If CB != ' '
				fnb := x
				Exit
			EndIf
		Next x

	EndIf

	//

	BackInBuffer := InBuffer

	OldChar := HB_USUBSTR ( InBuffer , icp+1 , 1 )

	If HMG_LEN ( InBuffer ) < HMG_LEN ( Mask )

		InBufferLeft := HB_ULEFT ( InBuffer , icp )

		InBufferRight := HB_URIGHT ( InBuffer , HMG_LEN (InBuffer) - icp )

   // JK

                if CharMaskTekstOK(InBufferLeft + ' ' + InBufferRight,Mask) .and. CharMaskTekstOK(InBufferLeft + InBufferRight,Mask)==.f.
                  InBuffer := InBufferLeft + ' ' + InBufferRight
              else
                   InBuffer := InBufferLeft +InBufferRight
                endif

	EndIf

	If HMG_LEN ( InBuffer ) > HMG_LEN ( Mask )

		InBufferLeft := HB_ULEFT ( InBuffer , icp )

		InBufferRight := HB_URIGHT ( InBuffer , HMG_LEN (InBuffer) - icp - 1 )

		InBuffer := InBufferLeft + InBufferRight

	EndIf

	// Process Mask

	For x := 1 To HMG_LEN (Mask)

		CB := HB_USUBSTR (InBuffer , x , 1 )
		CM := HB_USUBSTR (Mask , x , 1 )

		Do Case

			Case (CM) == '!'

				OutBuffer := OutBuffer + HMG_UPPER(CB)

			Case (CM) == 'A'

			        If HMG_ISALPHA ( CB ) .Or. CB == ' '

					OutBuffer := OutBuffer + CB

				Else

					if x == icp
						BadEntry := .T.
						OutBuffer := OutBuffer + OldChar
					Else
						OutBuffer := OutBuffer + ' '
					EndIf

				EndIf

			Case CM == '9'

				If HMG_ISDIGIT ( CB ) .Or. CB == ' ' .Or. ( CB == '-' .And. x == fnb .And. PCount() > 1 )

					OutBuffer := OutBuffer + CB

				Else

					if x == icp
						BadEntry := .T.
						OutBuffer := OutBuffer + OldChar
					Else
						OutBuffer := OutBuffer + ' '
					EndIf

				EndIf

			Case CM == ' '

				If CB == ' '

					OutBuffer := OutBuffer + CB

				Else

					if x == icp
						BadEntry := .T.
						OutBuffer := OutBuffer + OldChar
					Else
						OutBuffer := OutBuffer + ' '
					EndIf

				EndIf


			OtherWise

				OutBuffer := OutBuffer + CM

		End Case

	Next x

	// Replace Content

	If ! ( BackInBuffer == OutBuffer )
		SetWindowText ( _HMG_SYSDATA [3] [i] , OutBuffer )
	EndIf

	If pc > 1

		If NegativeZero == .T.

			Output := Transform ( GetNumFromText ( GetWindowText ( _HMG_SYSDATA [3] [i] ) , i ) , Mask )

			Output := HB_URIGHT (Output , ol - 1 )

			Output := '-' + Output

			// Replace Text

			SetWindowText ( _HMG_SYSDATA [3] [i] , Output )
		      	SendMessage( _HMG_SYSDATA [3] [i] , EM_SETSEL , hb_UAt('.',OutBuffer) + dc , hb_UAt('.',OutBuffer) + dc )

		Else

			SetWindowText ( _HMG_SYSDATA [3] [i] , Transform ( GetNumFromText ( GetWindowText ( _HMG_SYSDATA [3] [i] ) , i ) , Mask ) )
		      	SendMessage( _HMG_SYSDATA [3] [i] , EM_SETSEL , hb_UAt('.',OutBuffer) + dc , hb_UAt('.',OutBuffer) + dc )

		EndIf

	Else

		If pFlag == .T.
			ncp := HB_UAT ( '.' , GetWindowText ( _HMG_SYSDATA [3] [i] ) )
			SendMessage( _HMG_SYSDATA [3] [i] , EM_SETSEL , ncp , ncp )

		Else

			// Restore Initial CaretPos

			If BadEntry
	      			icp--
			EndIf

      			SendMessage( _HMG_SYSDATA [3] [i] , EM_SETSEL , icp , icp )

			// Skip Protected Characters

			For x := 1 To HMG_LEN (OutBuffer)

				CB := HB_USUBSTR ( OutBuffer , icp+x , 1 )
				CM := HB_USUBSTR ( Mask , icp+x , 1 )

				If ( .Not. HMG_ISDIGIT(CB) ) .And. ( .Not. HMG_ISALPHA(CB) ) .And. ( ( .Not. CB = ' ' ) .or. ( CB == ' ' .and. CM == ' ' ) )
			      		SendMessage( _HMG_SYSDATA [3] [i] , EM_SETSEL , icp+x , icp+x )
				Else
					Exit
				EndIf

			Next x

		EndIf

	EndIf

RETURN
// JK

*------------------------------------------------------------------------------*
Function CharMaskTekstOK(cString,cMask)
*------------------------------------------------------------------------------*

Local lPassed:=.f.,CB,CM,x

For x := 1 To Min(HMG_LEN(cString),HMG_LEN(cMask))

	CB := HB_USUBSTR ( cString , x , 1 )
	CM := HB_USUBSTR ( cMask , x , 1 )

	Do Case

		Case (CM) == '!'

		        If HMG_ISUPPER ( CB ) .Or. CB == ' '
				lPassed:=.t.
			EndIf

		Case (CM) == 'A'

		        If HMG_ISALPHA ( CB ) .Or. CB == ' '
				lPassed:=.t.
			Else
			        lPassed:=.f.
				Return lPassed
			EndIf

		Case CM == '9'

			If HMG_ISDIGIT ( CB ) .Or. CB == ' '
				lPassed:=.t.
			Else
				lPassed:=.f.
				Return lPassed
			EndIf

		Case CM == ' '

			If CB == ' '
				lPassed:=.t.
			Else
			        lPassed:=.f.
				Return lPassed
			EndIf

		OtherWise

			lPassed:=.t.

		End Case

next i

Return lPassed
*------------------------------------------------------------------------------*
Procedure _DataTextBoxRefresh (i)
*------------------------------------------------------------------------------*
Local Field

	If _HMG_SYSDATA [1] [i] == "MASKEDTEXT"
		Field		:= _HMG_SYSDATA [ 17 ] [i]
	Else
		Field		:= _HMG_SYSDATA [  7 ] [i]
	EndIf

	If Type ( Field ) == 'C'
		_SetValue ( '' , '' , RTrim( &(Field)) , i )
	Else
		_SetValue ( '' , '' , &(Field) , i )
	EndIf

Return
*------------------------------------------------------------------------------*
Procedure _DataTextBoxSave ( ControlName , ParentForm)
*------------------------------------------------------------------------------*
Local Field , i

	i := GetControlIndex ( ControlName , ParentForm)

	If _HMG_SYSDATA [1] [i] == "MASKEDTEXT"
		Field		:= _HMG_SYSDATA [ 17 ] [i]
	Else
		Field		:= _HMG_SYSDATA [  7 ] [i]
	EndIf

	&(Field) := _GetValue ( Controlname , ParentForm )

Return
*------------------------------------------------------------------------------*
PROCEDURE ProcessNumText ( i )
*------------------------------------------------------------------------------*
Local InBuffer , OutBuffer := '' , icp , x , CB , BackInBuffer , BadEntry := .F. , fnb

	// Store Initial CaretPos
	icp := HiWord ( SendMessage( _HMG_SYSDATA [3] [i] , EM_GETSEL , 0 , 0 ) )

	// Get Current Content

	InBuffer := GetWindowText ( _HMG_SYSDATA [3] [i] )

	BackInBuffer := InBuffer

	// Find First Non-Blank Position

	For x := 1 To HMG_LEN ( InBuffer )
		CB := HB_USUBSTR (InBuffer , x , 1 )
		If CB != ' '
			fnb := x
			Exit
		EndIf
	Next x

	// Process Mask

	For x := 1 To HMG_LEN(InBuffer)

		CB := hb_USubStr(InBuffer , x , 1 )

		If HMG_ISDIGIT ( CB ) .Or. ( CB == '-' .And. x == fnb ) .or. (CB == '.' .and. HB_UAT (CB, OutBuffer) == 0)  .or. ;
         (CB == ',' .and. HB_UAT ('.', OutBuffer) == 0)   // MOL, April 2016

			OutBuffer := OutBuffer + CB
		Else
			BadEntry  := .t.
		EndIf

	Next x

	If BadEntry
	      	icp--
	EndIf

	// JK Replace Content

	If ! ( BackInBuffer == OutBuffer )
		SetWindowText ( _HMG_SYSDATA [3] [i] , OutBuffer )
	EndIf

	// Restore Initial CaretPos

      	SendMessage( _HMG_SYSDATA [3] [i] , EM_SETSEL , icp , icp )

RETURN

*------------------------------------------------------------------------------*
Function GETNumFromTextSP(Text,i)
*------------------------------------------------------------------------------*
Local x , c , s

	s := ''

	For x := 1 To HMG_LEN ( Text )

		c := hb_USubStr(Text,x,1)

		If c='0' .or. c='1' .or. c='2' .or. c='3' .or. c='4' .or. c='5' .or. c='6' .or. c='7' .or. c='8' .or. c='9' .or. c=',' .or. c='-' .or. c = '.'

			if c == '.'
				c :=''
			endif

			IF C == ','
				C:= '.'
			ENDIF

			s := s + c

		EndIf

	Next x

	If HB_ULEFT ( ALLTRIM(Text) , 1 ) == '(' .OR.  HB_URIGHT ( ALLTRIM(Text) , 2 ) == 'DB'
		s := '-' + s
	EndIf

	s := Transform ( Val(s) , _HMG_SYSDATA [  9 ] [i] )

Return Val(s)
