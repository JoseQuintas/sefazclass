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
#include "common.ch"



*-----------------------------------------------------------------------------*
Function _DefineCombo ( ControlName, ;
			ParentForm, ;
			x, ;
			y, ;
			w, ;
			rows, ;
			value, ;
         fontname, ;
			fontsize, ;
			tooltip, ;
			changeprocedure, ;
			h, ;
         gotfocus, ;
			lostfocus, ;
			uEnter, ;
			HelpId, ;
			invisible, ;
         notabstop, ;
			sort , ;
			bold, ;
			italic, ;
			underline, ;
			strikeout , ;
			itemsource , ;
			valuesource , ;
			displayedit , ;
			ondisplaychangeprocedure , ;
			break , ;
			GripperText , aImage , DroppedWidth , dropdownprocedure , closeupprocedure, oncancel,  NoTransparent )
*-----------------------------------------------------------------------------*
Local i , cParentForm , mVar , ControlHandle , FontHandle , rcount := 0 , BackRec , cset := 0 , WorkArea , cField , ContainerHandle := 0 , k
Local aRet
Local ImageListHandle := Nil
Local aTemp
Local ImageSource
Local cImageField

	DEFAULT w               TO 120
	DEFAULT h               TO 150
	DEFAULT changeprocedure TO ""
	DEFAULT gotfocus	TO ""
	DEFAULT lostfocus	TO ""
	DEFAULT rows		TO {}
	DEFAULT invisible	TO FALSE
	DEFAULT notabstop	TO FALSE
	DEFAULT sort		TO FALSE
	DEFAULT GripperText	TO ""
	DEFAULT DroppedWidth	TO w

	if _HMG_SYSDATA [ 264 ] = TRUE
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

	if ValType ( ItemSource ) != 'U' .And. Sort == .T.
		MsgHMGError ("Sort and ItemSource clauses can't be used simultaneusly. Program Terminated" )
	EndIf

	if ValType ( ValueSource ) != 'U' .And. Sort == .T.
		MsgHMGError ("Sort and ValueSource clauses can't be used simultaneusly. Program Terminated" )
	EndIf

	If ValType ( ItemSource ) == 'A'

		aTemp := ItemSource

		If	HMG_LEN ( ItemSource ) == 1 .And. ValType ( aImage ) = 'U'

			ItemSource	:= aTemp [1]

		ElseIf	HMG_LEN ( ItemSource ) == 2 .And. ValType ( aImage ) = 'A'

			ImageSource	:= aTemp [1]
			ItemSource	:= aTemp [2]

		ElseIf 	HMG_LEN ( ItemSource ) > 2

			MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + "Invalid ItemSource property value. Program Terminated" )

		ElseIf 	HMG_LEN ( ItemSource ) == 0

			ItemSource := Nil

		EndIf

	EndIf

	if valtype ( itemsource ) != 'U'
		if  HB_UAT ( '>',ItemSource ) == 0
			MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " (ItemSource): You must specify a fully qualified field name. Program Terminated" )
		Else
			WorkArea := HB_ULEFT ( ItemSource , HB_UAT ( '>', ItemSource ) - 2 )
			cField := HB_URIGHT ( ItemSource , HMG_LEN (ItemSource) - HB_UAT ( '>', ItemSource ) )
		EndIf
	EndIf

	if valtype ( imagesource ) != 'U'
		if  HB_UAT ( '>',ImageSource ) == 0
			MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " (ItemSource): You must specify a fully qualified field name. Program Terminated" )
		Else
			cImageField := HB_URIGHT ( ImageSource , HMG_LEN (ImageSource) - HB_UAT ( '>', ImageSource ) )
		EndIf
	EndIf

	if ValType(value) == "U"
		value := 0
	endif

	mVar := '_' + ParentForm + '_' + ControlName

	cParentForm := ParentForm

	ParentForm = GetFormHandle (ParentForm)

	if ValType(x) == "U" .or. ValType(y) == "U"

		_HMG_SYSDATA [ 216 ]	:= 'COMBOBOX'

		i := GetFormIndex ( cParentForm )

		If i > 0

			If ValType ( aImage ) == 'U'

				ControlHandle := InitComboBox ( _HMG_SYSDATA [ 87 ] [i], 0, x, y, w, '', 0 , h, invisible, notabstop, sort, displayedit , _HMG_SYSDATA [ 250 ] , DroppedWidth )

			Else

				aRet		:= InitImageCombo ( _HMG_SYSDATA [ 87 ] [i] , y , x , w , h , aImage , displayedit , .Not. invisible , .Not. notabstop , IF ( WINMAJORVERSIONNUMBER() + ( WINMINORVERSIONNUMBER() / 10 ) > 5.1 , .T. , .F. ) , DroppedWidth, NoTransparent )
				ControlHandle	:= aRet [1]
				ImageListHandle	:= aRet [2]

			EndIf

			if ValType(fontname) != "U" .and. ValType(fontsize) != "U"
				FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
			Else
				FontHandle := _SetFont (ControlHandle,_HMG_SYSDATA [ 342 ],_HMG_SYSDATA [ 343 ],bold,italic,underline,strikeout)
			endif

			AddSplitBoxItem ( Controlhandle , _HMG_SYSDATA [ 87 ] [i] , w , break , GripperText , w , , _HMG_SYSDATA [ 258 ] )

			Containerhandle := _HMG_SYSDATA [ 87 ] [i]

		EndIf

	else

		If ValType ( aImage ) == 'U'

			ControlHandle := InitComboBox ( ParentForm, 0, x, y, w, '', 0 , h, invisible, notabstop, sort , displayedit , _HMG_SYSDATA [ 250 ] , DroppedWidth )

		Else

			aRet		:= InitImageCombo ( ParentForm , y , x , w , h , aImage , displayedit , .Not. invisible , .Not. notabstop , IF ( WINMAJORVERSIONNUMBER() + ( WINMINORVERSIONNUMBER() / 10 ) > 5.1 , .T. , .F. ) , DroppedWidth,  NoTransparent )
			ControlHandle	:= aRet [1]
			ImageListHandle	:= aRet [2]

		EndIf

		if ValType(fontname) != "U" .and. ValType(fontsize) != "U"
			FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
		Else
			FontHandle := _SetFont (ControlHandle,_HMG_SYSDATA [ 342 ],_HMG_SYSDATA [ 343 ],bold,italic,underline,strikeout)
		endif

	endif

	If _HMG_SYSDATA [ 265 ] = TRUE
		aAdd ( _HMG_SYSDATA [ 142 ] , Controlhandle )
	EndIf

	if ValType(uEnter) == "U"
		uEnter := ""
	endif

	if ValType(tooltip) != "U"
		SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
	endif

	k := _GetControlFree()

	Public &mVar. := k

	_HMG_SYSDATA [  1 ] [k] := "COMBO"
	_HMG_SYSDATA [  2 ] [k] := ControlName
	_HMG_SYSDATA [  3 ] [k] := ControlHandle
	_HMG_SYSDATA [  4 ] [k] := ParentForm
	_HMG_SYSDATA [  5 ] [k] := 0
	_HMG_SYSDATA [  6 ] [k] := ondisplaychangeprocedure
	_HMG_SYSDATA [  7 ] [k] := cField
	_HMG_SYSDATA [  8 ] [k] := Value
	_HMG_SYSDATA [  9 ] [k] := Nil
	_HMG_SYSDATA [ 10 ] [k] := lostfocus
	_HMG_SYSDATA [ 11 ] [k] := gotfocus
	_HMG_SYSDATA [ 12 ] [k] := changeprocedure
	_HMG_SYSDATA [ 13 ] [k] := FALSE
	_HMG_SYSDATA [ 14 ] [k] := cImageField
	_HMG_SYSDATA [ 15 ] [k] := ImageListHandle
	_HMG_SYSDATA [ 16 ] [k] := uEnter
	_HMG_SYSDATA [ 17 ] [k] := {}
	_HMG_SYSDATA [ 18 ] [k] := y
	_HMG_SYSDATA [ 19 ] [k] := x
	_HMG_SYSDATA [ 20 ] [k] := w
	_HMG_SYSDATA [ 21 ] [k] := h
	_HMG_SYSDATA [ 22 ] [k] := WorkArea
	_HMG_SYSDATA [ 23 ] [k] := iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 24 ] [k] := iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 25 ] [k] := ""
	_HMG_SYSDATA [ 26 ] [k] := ContainerHandle
	_HMG_SYSDATA [ 27 ] [k] := fontname
	_HMG_SYSDATA [ 28 ] [k] := fontsize
	_HMG_SYSDATA [ 29 ] [k] := {bold,italic,underline,strikeout}
	_HMG_SYSDATA [ 30 ] [k] := tooltip
	_HMG_SYSDATA [ 31 ] [k] := 0
	_HMG_SYSDATA [ 32 ] [k] := OnCancel
	_HMG_SYSDATA [ 33 ] [k] := valuesource
	_HMG_SYSDATA [ 34 ] [k] := if(invisible,FALSE,TRUE)
	_HMG_SYSDATA [ 35 ] [k] := HelpId
	_HMG_SYSDATA [ 36 ] [k] := FontHandle
	_HMG_SYSDATA [ 37 ] [k] := closeupprocedure
	_HMG_SYSDATA [ 38 ] [k] := .T.
	_HMG_SYSDATA [ 39 ] [k] := dropdownprocedure
	_HMG_SYSDATA [ 40 ] [k] := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

	If displayedit == .T.
		_HMG_SYSDATA [ 31 ] [k] := FindWindowEx( Controlhandle , 0, "Edit", Nil )
	EndIf

	If  ValType( WorkArea ) == "C"

		If Select ( WorkArea ) != 0

			BackRec := (WorkArea)->(RecNo())

			(WorkArea)->(dbGoTop())

			If ValType ( aImage ) = 'U'

				Do While ! (WorkArea)->(Eof())
					rcount++
	        			if value == (WorkArea)->(RecNo())
						cset := rcount
					EndIf
					ComboAddString (ControlHandle, (WorkArea)->&(cField) )
					(WorkArea)->(dbSkip())
				EndDo

			Else

				Do While ! (WorkArea)->(Eof())
					rcount++
	        			if value == (WorkArea)->(RecNo())
						cset := rcount
					EndIf
					ImageComboAddItem ( ControlHandle , (WorkArea)->&(cImageField) , (WorkArea)->&(cField) , -1 )
					(WorkArea)->(dbSkip())
				EndDo

			EndIf

			(WorkArea)->(dbGoto(BackRec))

			ComboSetCurSel (ControlHandle,cset)

		EndIf

	Else

		If ValType ( aImage ) == 'U'

			for i = 1 to HMG_LEN (rows)
				ComboAddString (ControlHandle,rows[i] )
			next i

		Else

			for i = 1 to HMG_LEN (rows)
				ImageComboAddItem ( ControlHandle , rows[i][1] , rows[i][2] , -1 )
			next i

		EndIf


		if value <> 0
			ComboSetCurSel (ControlHandle,Value)
		endif

	EndIf

	if valtype ( ItemSource ) != 'U'

		if k > 0
			aAdd ( _HMG_SYSDATA [ 89 ]	[ GetFormIndex ( cParentForm ) ] , k )
		Else
			aAdd ( _HMG_SYSDATA [ 89 ]	[ GetFormIndex ( cParentForm ) ] , HMG_LEN (_HMG_SYSDATA [3]) )
		EndIf
	EndIf

	If ValType ( aImage ) <> 'U'

		_HMG_SYSDATA [ 32 ] [k] := SendMessage( Controlhandle, 1030 , 0 , 0 )

	EndIf

Return Nil
*-----------------------------------------------------------------------------*
Procedure _DataComboRefresh (i)
*-----------------------------------------------------------------------------*
Local BackRec , WorkArea , cField , cImageField , xCurrentValue , Tmp

	Tmp := _HMG_SYSDATA [ 33 ] [i]
	_HMG_SYSDATA [ 33 ] [i] := Nil

	xCurrentValue := _GetValue ( , , i )

	_HMG_SYSDATA [ 33 ] [i] := Tmp

	cField := _HMG_SYSDATA [  7 ] [i]
	cImageField := _HMG_SYSDATA [  14 ] [i]

	WorkArea := _HMG_SYSDATA [ 22 ] [i]

	BackRec := (WorkArea)->(RecNo())

	(WorkArea)->(dbGoTop())

	ComboboxReset ( _HMG_SYSDATA [3] [i] )

	If _HMG_SYSDATA [15] [i] == Nil

		Do While ! (WorkArea)->(Eof())

			ComboAddString ( _HMG_SYSDATA [3] [i] , (WorkArea)->&(cField) )

			(WorkArea)->(dbSkip())

		EndDo

	Else

		Do While ! (WorkArea)->(Eof())
			ComboAddString ( _HMG_SYSDATA [3] [i] , (WorkArea)->&(cField) )
			ImageComboAddItem ( _HMG_SYSDATA [3] [i] , (WorkArea)->&(cImageField) , (WorkArea)->&(cField) , -1 )
			(WorkArea)->(dbSkip())
		EndDo

	EndIf

	If xCurrentValue > 0 .And. xCurrentValue <= (WorkArea)->(LastRec())
		_SetValue ( , , xCurrentValue , i )
	EndIf

	(WorkArea)->(dbGoto(BackRec))

Return

