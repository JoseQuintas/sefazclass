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
MEMVAR _HMG_TAB_IMAGE_NOTRANSPARET

#include "hmg.ch"


*-----------------------------------------------------------------------------*
Function _DefineTab ( ControlName, ParentForm, x, y, w, h, aCaptions, aPageMap, value, fontname, fontsize , tooltip , change , Buttons , Flat , HotTrack , Vertical , notabstop , aMnemonic , bold, italic, underline, strikeout , Images , multiline, NoTrans)
*-----------------------------------------------------------------------------*
Local r,c,z,i , cParentForm , mVar , Caption , imageFlag := .F. , k
Local ControlHandle
Local FontHandle

	If .Not. _IsWindowDefined (ParentForm)
		MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated")
	Endif

	If _IsControlDefined (ControlName,ParentForm)
		MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated")
	endif

	For z := 1 To HMG_LEN (Images)
		If ValType (Images[z]) == "C"
			ImageFlag := .T.
			Exit
		EndIf
	Next z

	If ImageFlag == .T. .And. IsAppThemed() == .T.

		For z := 1 To HMG_LEN (aCaptions)

			If HB_UAT ( '&' , aCaptions[z] ) != 0
				aCaptions[z] := Space(3) + aCaptions[z]
			EndIf

		Next z

	EndIf

	mVar := '_' + ParentForm + '_' + ControlName

	cParentForm := ParentForm

	ParentForm = GetFormHandle (ParentForm)

	if IsAppThemed() .and. buttons == .f.
		vertical := .f.
	endif

	ControlHandle = InitTabControl 	( ParentForm, 0, x, y, w, h , aCaptions, value, '', 0 , Buttons , Flat , HotTrack , Vertical , notabstop , multiline )

	if ValType(fontname) != "U" .and. ValType(fontsize) != "U"
		FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
	Else
		FontHandle := _SetFont (ControlHandle,_HMG_SYSDATA [ 342 ],_HMG_SYSDATA [ 343 ],bold,italic,underline,strikeout)
	endif

	if ValType(tooltip) != "U"
	        SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
	endif

	if ValType(change) == "U"
		change := ""
	endif

	k := _GetControlFree()

	Public &mVar. := k

	_HMG_SYSDATA [1] [k] := "TAB"
	_HMG_SYSDATA [2] [k] :=   ControlName
	_HMG_SYSDATA [4] [k] :=   ParentForm
	_HMG_SYSDATA [3] [k] :=   Controlhandle
	_HMG_SYSDATA [  5 ]  [k] :=  0
	_HMG_SYSDATA [  7 ]  [k] :=  aPageMap
	_HMG_SYSDATA [  6 ]  [k] :=  ""
	_HMG_SYSDATA [  8 ]  [k] :=  Nil
	_HMG_SYSDATA [  9 ]  [k] :=  0   // hImageList
	_HMG_SYSDATA [ 10 ]  [k] :=  ""
	_HMG_SYSDATA [ 11 ]  [k] :=  ""
	_HMG_SYSDATA [ 12 ]  [k] :=  change
	_HMG_SYSDATA [ 13 ]  [k] :=  .F.
	_HMG_SYSDATA [ 14 ]  [k] :=  Nil
	_HMG_SYSDATA [ 15 ]  [k] :=  Nil
	_HMG_SYSDATA [ 16 ]  [k] :=  ""
	_HMG_SYSDATA [ 17 ]  [k] :=  {}
	_HMG_SYSDATA [ 18 ]  [k] :=  y
	_HMG_SYSDATA [ 19 ]  [k] :=  x
	_HMG_SYSDATA [ 20 ]  [k] :=  w
	_HMG_SYSDATA [ 21 ]   [k] := h
	_HMG_SYSDATA [ 22 ]  [k] :=  0
	_HMG_SYSDATA [ 23 ]  [k] :=  -1
	_HMG_SYSDATA [ 24 ]  [k] :=  -1
	_HMG_SYSDATA [ 25 ]  [k] :=  Images
	_HMG_SYSDATA [ 26 ]  [k] :=  NoTrans
	_HMG_SYSDATA [ 27 ]  [k] :=  fontname
	_HMG_SYSDATA [ 28 ]  [k] :=  fontsize
	_HMG_SYSDATA [ 29 ]  [k] :=  {bold,italic,underline,strikeout}
	_HMG_SYSDATA [ 30 ]   [k] :=  tooltip
	_HMG_SYSDATA [ 31 ]   [k] :=  Buttons
	_HMG_SYSDATA [ 32 ]   [k] :=  0
	_HMG_SYSDATA [ 33 ]   [k] :=  aCaptions
	_HMG_SYSDATA [ 34 ]  [k] :=   .t.
	_HMG_SYSDATA [ 35 ]  [k] :=   0
	_HMG_SYSDATA [ 36 ]   [k] :=  FontHandle
	_HMG_SYSDATA [ 37 ]    [k] := 0
	_HMG_SYSDATA [ 38 ]   [k] :=  .T.
	_HMG_SYSDATA [ 39 ] [k] := 0
	_HMG_SYSDATA [ 40 ] [k] := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

	If ImageFlag == .T.
		_HMG_SYSDATA [  9 ] [ k ] := AddtabBitMap ( ControlHandle , Images , NoTrans )
	EndIf

	For z := 1 To HMG_LEN ( aCaptions )

		Caption := HMG_UPPER ( aCaptions [z] )

		i := HB_UAT ( '&' , Caption )

		If i > 0

			If	HB_USUBSTR ( Caption , i+1 , 1 ) == 'A'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_A , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'B'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_B , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'C'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_C , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'D'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_D , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'E'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_E , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'F'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_F , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'G'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_G , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'H'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_H , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'I'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_I , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'J'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_J , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'K'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_K , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'L'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_L , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'M'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_M , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'N'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_N , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'O'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_O , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'P'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_P , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'Q'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_Q , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'R'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_R , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'S'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_S , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'T'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_T , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'U'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_U , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'V'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_V , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'W'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_W , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'X'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_X , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'Y'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_Y , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == 'Z'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_Z , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == '0'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_0 , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == '1'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_1 , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == '2'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_2 , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == '3'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_3 , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == '4'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_4 , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == '5'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_5 , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == '6'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_6 , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == '7'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_7 , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == '8'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_8 , aMnemonic [z] )
			ElseIf	HB_USUBSTR ( Caption , i+1 , 1 ) == '9'
				_DefineHotKey ( cParentForm , MOD_ALT , VK_9 , aMnemonic [z] )
			EndIf

		EndIf

	Next z

	* Hide all except page to show

   for r = 1 to HMG_LEN ( aPageMap )
      if r <> value

         for c = 1 to HMG_LEN ( aPageMap [r])
            if valtype ( aPageMap [r] [c] ) <> "A"
               HideWindow ( aPageMap [r] [c] )
            else
               for z = 1 to HMG_LEN ( aPageMap [r] [c] )
                  HideWindow ( aPageMap [r] [c] [z] )
               next z
            endif
         Next c

      endif
   Next r

Return Nil

*------------------------------------------------------------------------------*
Function UpdateTab (y) // Internal Function
*------------------------------------------------------------------------------*
Local r,w,s,z

	* Hide All Pages
	for r = 1 to HMG_LEN ( _HMG_SYSDATA [  7 ] [y] )
		for w = 1 to HMG_LEN (_HMG_SYSDATA [  7 ] [y] [r])
			if valtype ( _HMG_SYSDATA [  7 ] [y] [r] [w] ) <> "A"
				HideWindow ( _HMG_SYSDATA [  7 ] [y] [r] [w] )
         else
				for z = 1 to HMG_LEN ( _HMG_SYSDATA [  7 ] [y] [r] [w] )
               HideWindow ( _HMG_SYSDATA [  7 ] [y] [r] [w] [z] )
				Next z
			endif
		Next w
	Next r

	* Show New Active Page
	s = TabCtrl_GetCurSel (_HMG_SYSDATA [3] [y] )
	for w = 1 to HMG_LEN (_HMG_SYSDATA [  7 ] [y] [s])
		if valtype (_HMG_SYSDATA [  7 ] [y] [s] [w]) <> "A"

			if _IsControlVisibleFromHandle ( _HMG_SYSDATA [  7 ] [y] [s] [w] )

				CShowControl ( _HMG_SYSDATA [  7 ] [y] [s] [w] )

			ElseIf _IsWindowVisibleFromHandle ( _HMG_SYSDATA [  7 ] [y] [s] [w] )

				CShowControl ( _HMG_SYSDATA [  7 ] [y] [s] [w] )

			EndIf

		else

			if _IsControlVisibleFromHandle ( _HMG_SYSDATA [  7 ] [y] [s] [w] [1] )

				for z = 1 to HMG_LEN ( _HMG_SYSDATA [  7 ] [y] [s] [w] )
   		                        CShowControl ( _HMG_SYSDATA [  7 ] [y] [s] [w] [z] )
				next z

			EndIf

		endif
	Next w

Return Nil


*------------------------------------------------------------------------------*
Function _BeginTab( name , parent , row , col , w , h , value , f , s , tooltip , change , buttons , flat , hottrack , vertical , notabstop , bold, italic, underline, strikeout , multiline , NoTrans )
*------------------------------------------------------------------------------*
Local aMnemonic := {}

	If _HMG_SYSDATA [ 265 ] = .T.
		MsgHMGError("DEFINE TAB Structures can't be nested. Program terminated")
	EndIf

	if _HMG_SYSDATA [ 264 ] = .T.
		if .Not. Empty (_HMG_SYSDATA [ 224 ]) .And. ValType(F) == "U"
			F := _HMG_SYSDATA [ 224 ]
		EndIf
		if .Not. Empty (_HMG_SYSDATA [ 182 ]) .And. ValType(S) == "U"
			S := _HMG_SYSDATA [ 182 ]
		EndIf
	endif

	if _HMG_SYSDATA [ 183 ] > 0
		col 	:= col + _HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]]
		row 	:= row + _HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]]
		Parent	:= _HMG_SYSDATA [ 332 ] [_HMG_SYSDATA [ 183 ]]
	EndIf

	if valtype (parent) == 'U'
		parent := _HMG_SYSDATA [ 223 ]
	EndIf
	if valtype (value) == 'U'
		value := 1
	EndIf

	_HMG_SYSDATA [ 183 ]++

	_HMG_SYSDATA [ 332 ]	[_HMG_SYSDATA [ 183 ]] := parent
	_HMG_SYSDATA [ 333 ]	[_HMG_SYSDATA [ 183 ]] := row
	_HMG_SYSDATA [ 334 ]	[_HMG_SYSDATA [ 183 ]] := col

	_HMG_SYSDATA [ 265 ] 	:= .T.
	_HMG_SYSDATA [ 184 ] 	:= 0
	_HMG_SYSDATA [ 140 ] 	:= {}
	_HMG_SYSDATA [ 141 ] 	:= {}
	_HMG_SYSDATA [ 305 ] 	:= {}
	_HMG_SYSDATA [ 142 ]	:= {}
	_HMG_SYSDATA [ 225 ] 	:= name
	_HMG_SYSDATA [ 226 ]	:= parent
	_HMG_SYSDATA [ 185 ]	:= row
	_HMG_SYSDATA [ 186 ]	:= col
	_HMG_SYSDATA [ 187 ]	:= w
	_HMG_SYSDATA [ 188 ]	:= h
	_HMG_SYSDATA [ 189 ]	:= value
	_HMG_SYSDATA [ 227 ]	:= f
	_HMG_SYSDATA [ 190 ]	:= s
	_HMG_SYSDATA [ 228 ]	:= tooltip
	_HMG_SYSDATA [ 308 ]	:= change

	_HMG_SYSDATA [ 266 ]	:= Buttons
	_HMG_SYSDATA [ 267 ]	:= Flat
	_HMG_SYSDATA [ 268 ]	:= HotTrack
	_HMG_SYSDATA [ 269 ]	:= Vertical
	_HMG_SYSDATA [ 270 ]	:= NotabStop

	_HMG_SYSDATA [ 301 ]	:= Bold
	_HMG_SYSDATA [ 302 ]	:= Italic
	_HMG_SYSDATA [ 303 ]	:= Underline
	_HMG_SYSDATA [ 304 ]	:= Strikeout
	_HMG_SYSDATA [ 204 ]	:= Multiline
// _HMG_SYSDATA [ 463 ] := NoTrans

PUBLIC _HMG_TAB_IMAGE_NOTRANSPARET := NoTrans

	aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 1 )  ) } )
	aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 2 )  ) } )
	aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 3 )  ) } )
	aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 4 )  ) } )
	aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 5 )  ) } )
	aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 6 )  ) } )
	aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 7 )  ) } )
	aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 8 )  ) } )
	aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 9 )  ) } )
	aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 10 ) ) } )
	aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 11 ) ) } )
	aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 12 ) ) } )
	aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 13 ) ) } )
	aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 14 ) ) } )
	aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 15 ) ) } )
	aAdd ( aMnemonic , {|| ( _SetValue ( name , parent , 16 ) ) } )

	_HMG_SYSDATA [ 229 ] := aMnemonic

Return Nil
*------------------------------------------------------------------------------*
Function _BeginTabPage ( caption , image )
*------------------------------------------------------------------------------*

	_HMG_SYSDATA [ 184 ]++
	aAdd ( _HMG_SYSDATA [ 141 ] , caption )
	aAdd ( _HMG_SYSDATA [ 305 ] , image )

Return Nil
*------------------------------------------------------------------------------*
Function _EndTabPage()
*------------------------------------------------------------------------------*

	aAdd ( _HMG_SYSDATA [ 140 ] , _HMG_SYSDATA [ 142 ] )
	_HMG_SYSDATA [ 142 ] := {}

Return Nil
*------------------------------------------------------------------------------*
Function _EndTab()
*------------------------------------------------------------------------------*

	_DefineTab ( _HMG_SYSDATA [ 225 ] ,;
                _HMG_SYSDATA [ 226 ] ,;
                _HMG_SYSDATA [ 186 ] ,;
                _HMG_SYSDATA [ 185 ] ,;
                _HMG_SYSDATA [ 187 ] ,;
                _HMG_SYSDATA [ 188 ] ,;
                _HMG_SYSDATA [ 141 ] ,;
                _HMG_SYSDATA [ 140 ] ,;
                _HMG_SYSDATA [ 189 ] ,;
                _HMG_SYSDATA [ 227 ] ,;
                _HMG_SYSDATA [ 190 ] ,;
                _HMG_SYSDATA [ 228 ] ,;
                _HMG_SYSDATA [ 308 ] ,;
                _HMG_SYSDATA [ 266 ] ,;
                _HMG_SYSDATA [ 267 ] ,;
                _HMG_SYSDATA [ 268 ] ,;
                _HMG_SYSDATA [ 269 ] ,;
                _HMG_SYSDATA [ 270 ] ,;
                _HMG_SYSDATA [ 229 ] ,;
                _HMG_SYSDATA [ 301 ] ,;
                _HMG_SYSDATA [ 302 ] ,;
                _HMG_SYSDATA [ 303 ] ,;
                _HMG_SYSDATA [ 304 ] ,;
                _HMG_SYSDATA [ 305 ] ,;
                _HMG_SYSDATA [ 204 ] ,;
                /*_HMG_SYSDATA [ 463 ]*/ _HMG_TAB_IMAGE_NOTRANSPARET )

   _HMG_SYSDATA [ 265 ] := .F.
   _HMG_SYSDATA [ 183 ]--
Return Nil


*------------------------------------------------------------------------------*
Function _AddTabPage ( ControlName , ParentForm , Position , Caption , cImage )
*------------------------------------------------------------------------------*
Local i

	If ValType (Caption) == 'U'
		Caption := ''
	EndIf

	If ValType (cImage) == 'U'
		cImage := ''
	EndIf

	i := GetControlIndex ( Controlname , ParentForm )

	TABCTRL_INSERTITEM ( _HMG_SYSDATA [3] [i] , Position - 1 , Caption )

	aAdd ( _HMG_SYSDATA [  7 ][i] , Nil )
	aIns ( _HMG_SYSDATA [  7 ][i] , Position )
	_HMG_SYSDATA [  7 ] [i] [Position] := {}   // aPageMap

	aAdd ( _HMG_SYSDATA [ 33 ][i] , Nil )
	aIns ( _HMG_SYSDATA [ 33 ][i] , Position )
	_HMG_SYSDATA [ 33 ] [i] [Position] := Caption

	aAdd ( _HMG_SYSDATA [ 25 ][i] , Nil )
	aIns ( _HMG_SYSDATA [ 25 ][i] , Position )
	_HMG_SYSDATA [ 25 ] [i] [Position] := cImage

// ADD
   IF _HMG_SYSDATA [ 9 ] [ i ] <> 0
      IMAGELIST_DESTROY ( _HMG_SYSDATA [ 9 ] [ i ] )
   ENDIF
   _HMG_SYSDATA [ 9 ] [ i ] := AddtabBitMap ( _HMG_SYSDATA [3] [i] , _HMG_SYSDATA [ 25 ][i] , _HMG_SYSDATA [ 26 ][i] )
//

	UpdateTab (i)

Return Nil


*------------------------------------------------------------------------------*
Function _AddTabControl ( TabName , ControlName , ParentForm , PageNumber , Row , Col )
*------------------------------------------------------------------------------*
Local i , h , x

	i := GetControlIndex ( TabName , ParentForm )

	x := GetControlIndex ( ControlName , ParentForm )

	h := _HMG_SYSDATA [3] [x]

	If	_HMG_SYSDATA [1] [x] == "CHECKBOX"	;
		.or.					;
		_HMG_SYSDATA [1] [x] == "FRAME"		;

		_HMG_SYSDATA [31] [x] := TabName
		_HMG_SYSDATA [32] [x] := ParentForm

	EndIf

	aadd ( _HMG_SYSDATA [  7 ] [i] [PageNumber] , h )

	_HMG_SYSDATA [ 23 ] [x] := _HMG_SYSDATA [ 18 ] [i]
	_HMG_SYSDATA [ 24 ] [x] := _HMG_SYSDATA [ 19 ] [i]

	_SetControlRow ( ControlName , ParentForm , Row )
	_SetControlCol ( ControlName , ParentForm , Col )

	UpdateTab (i)

Return Nil


*------------------------------------------------------------------------------*
Function _DeleteTabPage ( ControlName , ParentForm , Position )
*------------------------------------------------------------------------------*
Local i , NewValue , j , NewMap := {}

	i := GetControlIndex ( Controlname , ParentForm )

	if i > 0

		// Control Map

		For j := 1 To HMG_LEN ( _HMG_SYSDATA [  7 ] [i] )

			if j <> position
				aAdd ( NewMap , _HMG_SYSDATA [  7 ] [i] [j] )
			endif

		Next j

		_HMG_SYSDATA [  7 ] [i] := NewMap


		// Images

		NewMap := {}

		For j := 1 To HMG_LEN ( _HMG_SYSDATA [ 25 ] [i] )

			if j <> position
				aAdd ( NewMap , _HMG_SYSDATA [ 25 ] [i] [j] )
			endif

		Next j

		_HMG_SYSDATA [ 25 ] [i] := NewMap


		// Captions

		NewMap := {}

		For j := 1 To HMG_LEN ( _HMG_SYSDATA [ 33 ] [i] )

			if j <> position
				aAdd ( NewMap , _HMG_SYSDATA [ 33 ] [i] [j] )
			endif

		Next j

		_HMG_SYSDATA [ 33 ] [i] := NewMap


		TabCtrl_DeleteItem(_HMG_SYSDATA [3][i] , Position - 1 )

		NewValue := Position - 1

		If NewValue == 0
			NewValue := 1
		EndIf

		AddTabBitMap ( _HMG_SYSDATA [3] [i] , _HMG_SYSDATA [ 25 ][i] , _HMG_SYSDATA [ 26 ][i] )

		TABCTRL_SETCURSEL ( _HMG_SYSDATA [3][i] , NewValue )

      IF HMG_LEN ( _HMG_SYSDATA [ 7 ] [i] ) > 0
         UpdateTab (i)
      ENDIF

	EndIf

Return Nil
