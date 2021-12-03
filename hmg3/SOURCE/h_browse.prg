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
#define SB_CTL          2  // ok
#define CB_SHOWDROPDOWN 335  // ok
memvar aresult
*-----------------------------------------------------------------------------*

#include "SETCompileBrowse.ch"
#ifdef COMPILEBROWSE

Function _DefineBrowse ( ControlName, ;
			ParentForm, ;
			x, ;
			y, ;
			w, ;
			h, ;
			aHeaders, ;
			aWidths, ;
			aFields , ;
			value, ;
			fontname, ;
			fontsize , ;
			tooltip , ;
			change , ;
			dblclick , ;
			aHeadClick , ;
			gotfocus , ;
			lostfocus , ;
			WorkArea , ;
			Delete, ;
			nogrid, ;
			aImage, ;
			aJust , ;
			HelpId , ;
			bold , ;
			italic , ;
			underline , ;
			strikeout , ;
			break , ;
			backcolor , ;
			fontcolor , ;
			lock , ;
			inplace , ;
			novscroll , ;
			appendable , ;
			readonly , ;
			valid , ;
			validmessages , ;
			edit , ;
			dynamicbackcolor , ;
			aWhenFields , ;
			dynamicforecolor , ;
			inputmask , ;
			format , ;
			inputitems , displayitems , aHeaderImages, ;
			NoTrans, NoTransHeader)
*-----------------------------------------------------------------------------*
Local i , cParentForm , mVar, wBitmap , z , ScrollBarHandle , DeltaWidth , k
Local cParentTabName

Local ControlHandle
Local FontHandle
Local hsum := 0
Local ScrollBarButtonHandle
Local nHeaderImageListHandle

	InPlace := .T.

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

	cParentForm = ParentForm

	ParentForm = GetFormHandle (ParentForm)

	if ValType(w) == "U"
		w := 240
	endif
	if ValType(h) == "U"
		h := 120
	endif
	if ValType(value) == "U"
		value := 0
	endif
	if ValType(aFields) == "U"
		aFields := {}
	endif
	if ValType(aJust) == "U"		// Browse+
		aJust := Array( HMG_LEN( aFields ) )
		aFill( aJust, 0 )
	else
		aSize( aJust, HMG_LEN( aFields) )
		aEval( aJust, { |x| x := iif( x == NIL, 0, x ) } )
	endif
	if ValType(aImage) == "U"
		aImage := {}
	endif

	// If splitboxed force no vertical scrollbar

	if ValType(x) == "U" .or. ValType(y) == "U"
		novscroll := .T.
	endif

	if novscroll == .F.
		DeltaWidth := GETVSCROLLBARWIDTH()
	Else
		DeltaWidth := 0
	EndIf

	if ValType(x) == "U" .or. ValType(y) == "U"

		If _HMG_SYSDATA [ 216 ] == 'TOOLBAR'
			Break := .T.
		EndIf

		_HMG_SYSDATA [ 216 ]	:= 'GRID'

		i := GetFormIndex ( cParentForm )

		if i > 0

			ControlHandle := InitBrowse ( ParentForm, 0, x, y, w - DeltaWidth , h , '', 0, iif( nogrid, 0, 1 ) ) // Browse+

			x := GetWindowCol ( Controlhandle )
			y := GetWindowRow ( Controlhandle )

			if ValType(fontname) != "U" .and. ValType(fontsize) != "U"
				FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
			Else
				FontHandle := _SetFont (ControlHandle,_HMG_SYSDATA [ 342 ],_HMG_SYSDATA [ 343 ],bold,italic,underline,strikeout)
			endif

			AddSplitBoxItem ( Controlhandle, _HMG_SYSDATA [ 87 ] [i] , w , break , , , , _HMG_SYSDATA [ 258 ] )
		EndIf

	Else

		ControlHandle := InitBrowse ( ParentForm, 0, x, y, w - DeltaWidth , h , '', 0, iif( nogrid, 0, 1 ) ) // Browse+

		if ValType(fontname) != "U" .and. ValType(fontsize) != "U"
			FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
		Else
			FontHandle := _SetFont (ControlHandle,_HMG_SYSDATA [ 342 ],_HMG_SYSDATA [ 343 ],bold,italic,underline,strikeout)
		endif

	endif

	If ValType (backcolor) != 'U'
		ListView_SetBkColor ( ControlHandle , backcolor[1] , backcolor[2] , backcolor[3] )
		ListView_SetTextBkColor ( ControlHandle , backcolor[1] , backcolor[2] , backcolor[3]  )
	EndIf

	If ValType (fontcolor) != 'U'
		ListView_SetTextColor ( ControlHandle , fontcolor[1] , fontcolor[2] , fontcolor[3]  )
	EndIf

	wBitmap := iif( HMG_LEN( aImage ) > 0, AddListViewBitmap( ControlHandle, aImage, NoTrans ), 0 ) //Add Bitmap Column
	aWidths[1] := max ( aWidths[1], wBitmap + 2 ) // Set Column 1 witth to Bitmap width

	if ValType(aHeadClick) == "U"
		aHeadClick := {}
	endif

	if ValType(change) == "U"
		change := ""
	endif

	if ValType(dblclick) == "U"
		dblclick := ""
	endif

	if ValType(tooltip) != "U"
	        SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
	endif

	k := _GetControlFree()

	Public &mVar. := k

	_HMG_SYSDATA [  1 ] [k] := "BROWSE"
	_HMG_SYSDATA [  2 ] [k] := ControlName
	_HMG_SYSDATA [  3 ] [k] := ControlHandle
	_HMG_SYSDATA [  4 ] [k] := ParentForm
	_HMG_SYSDATA [  5 ] [k] := 0
	_HMG_SYSDATA [  6 ] [k] := aWidths
	_HMG_SYSDATA [  7 ] [k] := aHeaders
	_HMG_SYSDATA [  8 ] [k] := Value
	_HMG_SYSDATA [  9 ] [k] := Lock
	_HMG_SYSDATA [ 10 ] [k] := lostfocus
	_HMG_SYSDATA [ 11 ] [k] := gotfocus
	_HMG_SYSDATA [ 12 ] [k] := change
	_HMG_SYSDATA [ 13 ] [k] := .F.
	_HMG_SYSDATA [ 14 ] [k] := aImage // Browse+
	_HMG_SYSDATA [ 15 ] [k] := inplace
	_HMG_SYSDATA [ 16 ] [k] := dblclick
	_HMG_SYSDATA [ 17 ] [k] := aHeadClick
	_HMG_SYSDATA [ 18 ] [k] := y
	_HMG_SYSDATA [ 19 ] [k] := x
	_HMG_SYSDATA [ 20 ] [k] := w
	_HMG_SYSDATA [ 21 ] [k] := h
	_HMG_SYSDATA [ 22 ] [k] := WorkArea
	_HMG_SYSDATA [ 23 ] [k] := iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 24 ] [k] := iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 25 ] [k] := Delete
	_HMG_SYSDATA [ 26 ] [k] := 0
	_HMG_SYSDATA [ 27 ] [k] := fontname
	_HMG_SYSDATA [ 28 ] [k] := fontsize
	_HMG_SYSDATA [ 29 ] [k] := {bold,italic,underline,strikeout}
	_HMG_SYSDATA [ 30 ] [k] := tooltip
	_HMG_SYSDATA [ 31 ] [k] := aFields
	_HMG_SYSDATA [ 32 ] [k] := {}
	_HMG_SYSDATA [ 33 ] [k] := aHeaders
	_HMG_SYSDATA [ 34 ] [k] := .t.
	_HMG_SYSDATA [ 35 ] [k] := HelpId
	_HMG_SYSDATA [ 36 ] [k] := FontHandle
	_HMG_SYSDATA [ 37 ] [k] := cParentTabName
	_HMG_SYSDATA [ 38 ] [k] := .T.
	_HMG_SYSDATA [ 39 ] [k] := { 0 , appendable , readonly , valid , validmessages , edit , inputitems , displayitems , Nil , Nil , Nil }
	_HMG_SYSDATA [ 40 ] [k] := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

	InitListViewColumns ( ControlHandle , aHeaders , aWidths, aJust ) // Browse+

	// Add to browselist array to update on window activation

	i := k
	aAdd ( _HMG_SYSDATA [ 89 ]	[ GetFormIndex ( cParentForm ) ] , k )

	For z := 1 To HMG_LEN ( _HMG_SYSDATA [  6 ] [i] )
		hsum := hsum + ListView_GetColumnWidth ( _HMG_SYSDATA [3] [i] , z - 1 )
		_HMG_SYSDATA [  6 ] [i] [z] := ListView_GetColumnWidth ( _HMG_SYSDATA [3] [i] , z - 1 )
	Next z

	// Add Vertical scrollbar

	if novscroll == .F.

		if hsum > w - GETVSCROLLBARWIDTH() - 4
			ScrollBarHandle := InitVScrollBar (  ParentForm , x + w - GETVSCROLLBARWIDTH() , y , GETVSCROLLBARWIDTH() , h - GETHSCROLLBARHEIGHT() )
			ScrollBarButtonHandle := InitVScrollBarButton (  ParentForm , x + w - GETVSCROLLBARWIDTH() , y + h - GETHSCROLLBARHEIGHT() , GETVSCROLLBARWIDTH() , GETHSCROLLBARHEIGHT() )
		Else
			ScrollBarHandle := InitVScrollBar (  ParentForm , x + w - GETVSCROLLBARWIDTH() , y , GETVSCROLLBARWIDTH() , h )
			ScrollBarButtonHandle := InitVScrollBarButton (  ParentForm , x + w - GETVSCROLLBARWIDTH() , y + h - GETHSCROLLBARHEIGHT() , 0 , 0 )
		EndIf

		If _HMG_SYSDATA [ 265 ] = .T.
			aAdd ( _HMG_SYSDATA [ 142 ] , { ControlHandle , ScrollBarHandle , ScrollBarButtonHandle } )
		EndIf

	Else

		ScrollBarHandle := 0

		If _HMG_SYSDATA [ 265 ] = .T.
			aAdd ( _HMG_SYSDATA [ 142 ] , ControlHandle )
		EndIf

	EndIf

	_HMG_SYSDATA [  5 ] [i] := ScrollBarHandle
	_HMG_SYSDATA [ 39 ] [i] [1] := ScrollBarButtonHandle


	_HMG_SYSDATA [ 40 ] [k] [1] := dynamicbackcolor
	_HMG_SYSDATA [ 40 ] [k] [2] := dynamicforecolor
	_HMG_SYSDATA [ 40 ] [k] [3] := aWhenFields
	_HMG_SYSDATA [ 40 ] [k] [4] := inputmask
	_HMG_SYSDATA [ 40 ] [k] [5] := format

	If ValType(aHeaderImages) <> "U"
		nHeaderImageListHandle := SetListViewHeaderImages ( ControlHandle , aHeaderImages , aJust, NoTransHeader )
		_HMG_SYSDATA [ 39 ] [k] [9] := aHeaderImages
		_HMG_SYSDATA [ 39 ] [k] [10] := nHeaderImageListHandle
		_HMG_SYSDATA [ 39 ] [k] [11] := aJust
	EndIf

Return Nil

*-----------------------------------------------------------------------------*
Procedure _BrowseUpdate( ControlName,ParentName , z )
*-----------------------------------------------------------------------------*
Local PageLength , aTemp, cTemp , Fields , _BrowseRecMap := {} , i , x , j , First , Image , _Rec , ColorMap , ColorRow , processdbc , processdfc , k
Local dbc
Local dFc

local fcolormap
local fcolorrow

Local dim
Local processdim

Local dft
Local processdft

Local teval

Local aDisplayItems
Local aDisplayItemsLengths
Local aProcessDisplayItems
Local lFound
Local p
Local cTempType	// added by Marek Olszewski 2016.05.25


	If PCount() == 2
		i := GetControlIndex(ControlName,ParentName)
	Else
		i := z
	EndIf

	If Select() == 0
		Return
	EndIf

	*

	aDisplayItems := _HMG_SYSDATA [39] [I] [8]

	aProcessDisplayItems := array ( HMG_LEN (_HMG_SYSDATA [ 31 ] [i]) )
	aDisplayItemsLengths := array ( HMG_LEN (_HMG_SYSDATA [ 31 ] [i]) )

	if valtype (aDisplayItems) = 'A'

		For k := 1 To HMG_LEN ( aProcessDisplayItems )

			if valtype ( aDisplayItems [k] ) = 'A'
				aProcessDisplayItems [k] := .T.
				aDisplayItemsLengths [k] := HMG_LEN ( aDisplayItems [k] )
			else
				aProcessDisplayItems [k] := .F.
				aDisplayItemsLengths [k] := 0
			endif

		Next k

	else

		For k := 1 To HMG_LEN ( aProcessDisplayItems )
			aProcessDisplayItems [k] := .F.
			aDisplayItemsLengths [k] := 0
		Next k

	endif

	*

	dim := 	_HMG_SYSDATA [40] [I] [4]

	processdim := array ( HMG_LEN (_HMG_SYSDATA [ 31 ] [i]) )

	if valtype (dim) = 'A'

		For k := 1 To HMG_LEN ( processdim )
			if valtype ( dim [k] ) = 'C'
				if .not. empty ( dim [k] )
					processdim [k] := .T.
				else
					processdim [k] := .F.
				endif
			else
				processdim [k] := .F.
			endif
		Next k

	else

		For k := 1 To HMG_LEN ( processdim )
			processdim [k] := .F.
		Next k

	endif

	dft := 	_HMG_SYSDATA [40] [I] [5]

	processdft := array ( HMG_LEN (_HMG_SYSDATA [ 31 ] [i]) )

	if valtype (dft) = 'A'

		For k := 1 To HMG_LEN ( processdft )
			if valtype ( dft [k] ) = 'C'
				if .not. empty ( dft [k] )
					processdft [k] := .T.
				else
					processdft [k] := .F.
				endif
			else
				processdft [k] := .F.
			endif
		Next k

	else

		For k := 1 To HMG_LEN ( processdft )
			processdft [k] := .F.
		Next k

	endif

	dbc := 	_HMG_SYSDATA [ 40 ] [i] [1]

	processdbc := if ( valtype (dbc) = 'A' , .t. , .f. )

	dfc := 	_HMG_SYSDATA [ 40 ] [i] [2]

	processdFc := if ( valtype (dFc) = 'A' , .t. , .f. )

	_HMG_SYSDATA [ 26 ] [i] := 0

	First   := iif( HMG_LEN( _HMG_SYSDATA [ 14 ][i] ) == 0, 1, 2 ) // Browse+ ( 2= bitmap definido, se cargan campos a partir de 2º )

	Fields := _HMG_SYSDATA [ 31 ] [i]

	ListViewReset ( _HMG_SYSDATA [3][i] )
	PageLength := ListViewGetCountPerPage ( _HMG_SYSDATA [3][i] )


	if processdbc == .t.
		colormap := {}
		colorrow := {}
	endif

	if processdfc == .t.
		fcolormap := {}
		fcolorrow := {}
	endif

	for x := 1 to PageLength

		aTemp := {}

		If First == 2						// Browse+
			cTemp := Fields [1]

			if Type (cTemp) == 'N'				// ..
				image := &cTemp

			elseif Type (cTemp) == 'L'			// ..
				image := iif( &cTemp, 1, 0 )

			else						// ..
				image := 0

			endif						// ..
			aadd ( aTemp , NIL )

			if processdbc == .t.
				if valtype ( dbc ) = 'A'
					if HMG_LEN ( dbc ) = HMG_LEN ( Fields )
						aadd ( colorrow , -1 )
					endif
				endif
			endif
			if processdfc == .t.
				if valtype ( dfc ) = 'A'
					if HMG_LEN ( dfc ) = HMG_LEN ( Fields )
						aadd ( fcolorrow , -1 )
					endif
				endif
			endif

		EndIf							// Browse+

		For j := First To HMG_LEN (Fields)

			cTemp := Fields [j]
			cTempType := ValType(&cTemp)


			If aProcessDisplayItems [ j ] == .T.

				lFound := .F.

				For p := 1 To aDisplayItemsLengths [ j ]
					If aDisplayItems [ j ] [ p ] [ 2 ] = &cTemp
						aadd ( aTemp , RTRIM ( aDisplayItems [ j ] [ p ] [ 1 ] ) )
						lFound := .T.
						Exit
					EndIf
				Next p

				If lFound == .F.
					aadd ( aTemp , '' )
				EndIf

			ElseIf cTempType == 'N'

				if	processdim [j] == .f. .and. processdft [j] == .f.

					aadd ( aTemp , LTRIM ( STR (&cTemp) ) )

				elseif	processdim [j] == .t. .and. processdft [j] == .f.

					aadd ( aTemp , TransForm ( &cTemp , dim [j] ) )

				elseif	processdim [j] == .f. .and. processdft [j] == .t.

					aadd ( aTemp , TransForm ( &cTemp , '@' + dft [j] ) )

				elseif	processdim [j] == .t. .and. processdft [j] == .t.

					aadd ( aTemp , TransForm ( &cTemp , '@' + dft [j] + ' ' + dim [j] ) )

				endif

			ElseIf cTempType == 'D'

				aadd ( aTemp , DToC(&cTemp) )

			ElseIf cTempType == 'L'

				aadd ( aTemp , IIF ( &cTemp == .T. , '.T.' , '.F.' ) )

			ElseIf cTempType == 'C'

				if processdim [j] == .t.
					aadd ( aTemp , RTRIM ( _BrowseCharMaskDisplay ( &cTemp , dim [j] ) ) )
				else
					aadd ( aTemp , RTRIM ( &cTemp ) )
				endif

			ElseIf cTempType == 'M'

				aadd ( aTemp , '<Memo>' )

			ElseIf cTempType == 'N'

				if	processdim [j] == .f. .and. processdft [j] == .f.

					aadd ( aTemp , LTRIM ( STR (&cTemp) ) )

				elseif	processdim [j] == .t. .and. processdft [j] == .f.

					aadd ( aTemp , TransForm ( &cTemp , dim [j] ) )

				elseif	processdim [j] == .f. .and. processdft [j] == .t.

					aadd ( aTemp , TransForm ( &cTemp , '@' + dft [j] ) )

				elseif	processdim [j] == .t. .and. processdft [j] == .t.

					aadd ( aTemp , TransForm ( &cTemp , '@' + dft [j] + ' ' + dim [j] ) )

				endif

			ElseIf cTempType == 'D'

				aadd ( aTemp , DToC(&cTemp) )

			ElseIf cTempType == 'L'

				aadd ( aTemp , IIF ( &cTemp == .T. , '.T.' , '.F.' ) )

			ElseIf cTempType == 'C'

				if processdim [j] == .t.
					aadd ( aTemp , RTRIM ( _BrowseCharMaskDisplay ( &cTemp , dim [j] ) ) )
				else
					aadd ( aTemp , RTRIM ( &cTemp ) )
				endif

			ElseIf cTempType == 'M'

				aadd ( aTemp , '<Memo>' )

			Else
				aadd ( aTemp , 'Nil' )

			EndIf

			if processdbc == .t.

				if valtype ( dbc ) = 'A'

					if HMG_LEN ( dbc ) = HMG_LEN ( Fields )

						if valtype ( dbc [j] ) = 'B'

							tEval := eval ( dbc [j] )

							IF VALTYPE ( TEVAL ) == 'A'
								IF HMG_LEN ( TEVAL ) == 3
									TEVAL := RGB ( TEVAL [1] , TEVAL [2] , TEVAL [3] )
								ENDIF
							ENDIF

							aadd ( colorrow , tEval )

						else
							aadd ( colorrow , -1 )
						endif

					endif

				endif

			endif

			if processdfc == .t.

				if valtype ( dfc ) = 'A'

					if HMG_LEN ( dfc ) = HMG_LEN ( Fields )

						if valtype ( dfc [j] ) = 'B'

							tEval := eval ( dfc [j] )

							IF VALTYPE ( TEVAL ) == 'A'
								IF HMG_LEN ( TEVAL ) == 3
									TEVAL := RGB ( TEVAL [1] , TEVAL [2] , TEVAL [3] )
								ENDIF
							ENDIF

							aadd ( fcolorrow , tEval )

						else
							aadd ( fcolorrow , -1 )
						endif

					endif

				endif

			endif

		Next j

		AddListViewItems ( _HMG_SYSDATA [3][i] , aTemp , Image )

		_Rec := RecNo()

		aadd ( _BrowseRecMap , _Rec )

		if processdbc == .t.
			aadd ( colormap , colorrow )
			colorrow := {}
		endif

		if processdfc == .t.
			aadd ( fcolormap , fcolorrow )
			fcolorrow := {}
		endif

		Skip

		If Eof()
			_HMG_SYSDATA [ 26 ] [i] := 1
			Go Bottom
			Exit
		EndIf

	Next x

	if processdbc == .t.

		_HMG_SYSDATA [ 40 ] [ I ] [ 6 ] := colormap

	else

		_HMG_SYSDATA [ 40 ] [ I ] [ 6 ] := Nil

	endif

	if processdfc == .t.

		_HMG_SYSDATA [ 40 ] [ I ] [ 7 ] := fcolormap

	else

		_HMG_SYSDATA [ 40 ] [ I ] [ 7 ] := Nil

	endif

	_HMG_SYSDATA [ 32 ] [i] := _BrowseRecMap

Return

*-----------------------------------------------------------------------------*
Procedure _BrowseNext ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , PageLength , _Alias , _RecNo , _BrowseArea , _BrowseRecMap , _DeltaScroll, s

	If PCount() == 2
		i := GetControlIndex ( ControlName , ParentForm )
	Else
		i := z
	EndIf

	_DeltaScroll := ListView_GetSubItemRect ( _HMG_SYSDATA [3][i] , 0 , 0 )

	_BrowseRecMap := _HMG_SYSDATA [ 32 ] [i]

	PageLength := LISTVIEWGETCOUNTPERPAGE ( _HMG_SYSDATA [3][i] )

	s := LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] )

	If  s == PageLength

		if _HMG_SYSDATA [ 26 ] [i] != 0
			Return
		EndIf

		_Alias := Alias()
		_BrowseArea := _HMG_SYSDATA [ 22 ] [i]
		If Select (_BrowseArea) == 0
			Return
		EndIf
		Select &_BrowseArea
		_RecNo := RecNo()

		Go _BrowseRecMap [PageLength]
		_BrowseUpdate( ControlName , ParentForm , i )
		_BrowseVscrollUpdate( i )
		ListView_Scroll( _HMG_SYSDATA [3][i] , _DeltaScroll[2] * (-1) , 0 )
		ListView_SetCursel ( _HMG_SYSDATA [3] [i] , HMG_LEN(_HMG_SYSDATA [ 32 ] [i] ) )
		Go _RecNo
		if Select( _Alias ) != 0
			Select &_Alias
		Else
			Select 0
		Endif

	Else

		ListView_SetCursel ( _HMG_SYSDATA [3] [i] , HMG_LEN(_BrowseRecMap) )
		_BrowseVscrollFastUpdate ( i , PageLength - s )

	EndIf

	_BrowseOnChange (i)

Return
*-----------------------------------------------------------------------------*
Procedure _BrowsePrior ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , _Alias , _RecNo , _BrowseArea , _BrowseRecMap , _DeltaScroll

	If PCount() == 2
		i := GetControlIndex ( ControlName , ParentForm )
	Else
		i := z
	EndIf

	_DeltaScroll := ListView_GetSubItemRect ( _HMG_SYSDATA [3][i] , 0 , 0 )

	_BrowseRecMap := _HMG_SYSDATA [ 32 ] [i]

	If LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] ) == 1
		_Alias := Alias()
		_BrowseArea := _HMG_SYSDATA [ 22 ] [i]
		If Select (_BrowseArea) == 0
			Return
		EndIf
		Select &_BrowseArea
		_RecNo := RecNo()
		Go _BrowseRecMap [1]
		Skip - LISTVIEWGETCOUNTPERPAGE ( _HMG_SYSDATA [3][i] ) + 1
		_BrowseVscrollUpdate( i )
		_BrowseUpdate(ControlName , ParentForm , i )
		ListView_Scroll( _HMG_SYSDATA [3][i] , _DeltaScroll[2] * (-1) , 0 )
		Go _RecNo
		if Select( _Alias ) != 0
			Select &_Alias
		Else
			Select 0
		Endif

	Else

		_BrowseVscrollFastUpdate ( i , 1 - LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] ) )

	EndIf

	ListView_SetCursel ( _HMG_SYSDATA [3] [i] , 1 )

	_BrowseOnChange (i)

Return
*-----------------------------------------------------------------------------*
Procedure _BrowseHome ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , _Alias , _RecNo , _BrowseArea , _DeltaScroll

	If PCount() == 2
		i := GetControlIndex ( ControlName , ParentForm )
	Else
		i := z
	EndIf

	_DeltaScroll := ListView_GetSubItemRect ( _HMG_SYSDATA [3][i] , 0 , 0 )

	_Alias := Alias()
	_BrowseArea := _HMG_SYSDATA [ 22 ] [i]
	If Select (_BrowseArea) == 0
		Return
	EndIf
	Select &_BrowseArea
	_RecNo := RecNo()
	Go Top
	_BrowseVscrollUpdate( i )
	_BrowseUpdate( ControlName , ParentForm , i )
	ListView_Scroll( _HMG_SYSDATA [3][i] , _DeltaScroll[2] * (-1) , 0 )
	Go _RecNo
	if Select( _Alias ) != 0
		Select &_Alias
	Else
		Select 0
	Endif

	ListView_SetCursel ( _HMG_SYSDATA [3] [i] , 1 )

	_BrowseOnChange (i)

Return
*-----------------------------------------------------------------------------*
Procedure _BrowseEnd ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , _Alias , _RecNo , _BrowseArea , _DeltaScroll, _BottomRec

	If PCount() == 2
		i := GetControlIndex ( ControlName , ParentForm )
	Else
		i := z
	EndIf

	_DeltaScroll := ListView_GetSubItemRect ( _HMG_SYSDATA [3][i] , 0 , 0 )

	_Alias := Alias()
	_BrowseArea := _HMG_SYSDATA [ 22 ] [i]
	If Select (_BrowseArea) == 0
		Return
	EndIf
	Select &_BrowseArea
	_RecNo := RecNo()
	Go Bottom
	_BottomRec := RecNo()

	_BrowseVscrollUpdate( i )
	Skip - LISTVIEWGETCOUNTPERPAGE ( _HMG_SYSDATA [3][i] ) + 1
	_BrowseUpdate(ControlName , ParentForm , i )
	ListView_Scroll( _HMG_SYSDATA [3][i] , _DeltaScroll[2] * (-1) , 0 )
	Go _RecNo
	if Select( _Alias ) != 0
		Select &_Alias
	Else
		Select 0
	Endif

	ListView_SetCursel ( _HMG_SYSDATA [3] [i] , ascan ( _HMG_SYSDATA [ 32 ] [i] , _BottomRec ) )

	_BrowseOnChange (i)

Return
*-----------------------------------------------------------------------------*
Procedure _BrowseUp ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , s  , _Alias , _RecNo , _BrowseArea, _BrowseRecMap , _DeltaScroll

	If PCount() == 2
		i := GetControlIndex ( ControlName , ParentForm )
	Else
		i := z
	EndIf

	_DeltaScroll := ListView_GetSubItemRect ( _HMG_SYSDATA [3][i] , 0 , 0 )

	_BrowseRecMap := _HMG_SYSDATA [ 32 ] [i]

	s := LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] )

	If s == 1
		_Alias := Alias()
		_BrowseArea := _HMG_SYSDATA [ 22 ] [i]
		If Select (_BrowseArea) == 0
			Return
		EndIf
		Select &_BrowseArea
		_RecNo := RecNo()
		Go _BrowseRecMap [1]
		Skip - 1
		_BrowseVscrollUpdate( i )
		_BrowseUpdate(ControlName , ParentForm , i )
		ListView_Scroll( _HMG_SYSDATA [3][i] , _DeltaScroll[2] * (-1) , 0 )
		Go _RecNo
		if Select( _Alias ) != 0
			Select &_Alias
		Else
			Select 0
		Endif
		ListView_SetCursel ( _HMG_SYSDATA [3] [i] , 1 )

	Else
		ListView_SetCursel ( _HMG_SYSDATA [3] [i] , s - 1 )
		_BrowseVscrollFastUpdate ( i , -1 )
	EndIf

	_BrowseOnChange (i)

Return
*-----------------------------------------------------------------------------*
Procedure _BrowseDown ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , PageLength , s , _Alias , _RecNo , _BrowseArea , _BrowseRecMap , _DeltaScroll

	If PCount() == 2
		i := GetControlIndex ( ControlName , ParentForm )
	Else
		i := z
	EndIf

	_DeltaScroll := ListView_GetSubItemRect ( _HMG_SYSDATA [3][i] , 0 , 0 )

	_BrowseRecMap := _HMG_SYSDATA [ 32 ] [i]

	s := LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] )

	PageLength := LISTVIEWGETCOUNTPERPAGE ( _HMG_SYSDATA [3][i] )

	If s == PageLength

		if _HMG_SYSDATA [ 26 ] [i] != 0
			Return
		EndIf

		_Alias := Alias()
		_BrowseArea := _HMG_SYSDATA [ 22 ] [i]
		If Select (_BrowseArea) == 0
			Return
		EndIf
		Select &_BrowseArea
		_RecNo := RecNo()

		Go _BrowseRecMap [1]
		Skip
		_BrowseUpdate( ControlName , ParentForm , i )
		_BrowseVscrollUpdate( i )
		ListView_Scroll( _HMG_SYSDATA [3][i] , _DeltaScroll[2] * (-1) , 0 )
		Go _RecNo
		if Select( _Alias ) != 0
			Select &_Alias
		Else
			Select 0
		Endif

		ListView_SetCursel ( _HMG_SYSDATA [3] [i] , HMG_LEN(_HMG_SYSDATA [ 32 ] [i]) )

	Else

		ListView_SetCursel ( _HMG_SYSDATA [3] [i] , s+1 )
		_BrowseVscrollFastUpdate ( i , 1 )

	EndIf

	_BrowseOnChange (i)

Return
*-----------------------------------------------------------------------------*
Procedure _BrowseRefresh ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , s , _Alias , _RecNo , _BrowseArea , _DeltaScroll
Local v
MEMVAR cMacroVar
Private cMacroVar


	If PCount() == 2
		i := GetControlIndex ( ControlName , ParentForm )
	Else
		i := z
	EndIf

	v := _BrowseGetValue ( '','' , i )

	_DeltaScroll := ListView_GetSubItemRect ( _HMG_SYSDATA [3][i] , 0 , 0 )

	s := LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] )

	_Alias := Alias()
	_BrowseArea := _HMG_SYSDATA [ 22 ] [i]


	If Select (_BrowseArea) == 0
		ListViewReset ( _HMG_SYSDATA [3][i] )
		Return
	EndIf

	Select &_BrowseArea
	_RecNo := RecNo()

	if v <= 0
		v := _RecNo
	EndIf

	Go v

	if s == 1 .or. s == 0
		cMacroVar := dbFilter()
		If HMG_LEN (cMacroVar) > 0
			If ! &cMacroVar
				Skip
			EndIf
		EndIf
	EndIf

	if s == 0 .or. s == 1
		if IndexOrd() != 0
			if ordKeyVal() == Nil
				Go Top
			endif
		EndIf
	endif

	if s == 0 .or. s == 1
		if Set ( _SET_DELETED ) == .T.
			if Deleted() == .T.
				Go Top
			endif
		EndIf
	endif


	If Eof()

		ListViewReset ( _HMG_SYSDATA [3][i] )

		Go _RecNo

		if Select( _Alias ) != 0
			Select &_Alias
		Else
			Select 0
		Endif

		Return

	EndIf


	_BrowseVscrollUpdate( i )

	if s != 0
		Skip -s+1
	EndIf


	_BrowseUpdate( '' , '' , i )


	ListView_Scroll( _HMG_SYSDATA [3][i] , _DeltaScroll[2] * (-1) , 0 )
	ListView_SetCursel ( _HMG_SYSDATA [3] [i] , ascan ( _HMG_SYSDATA [ 32 ] [i] , v ) )


	Go _RecNo
	if Select( _Alias ) != 0
		Select &_Alias
	Else
		Select 0
	Endif

Return
*-----------------------------------------------------------------------------*
Procedure _BrowseSetValue ( ControlName , ParentForm , Value , z , mp )
*-----------------------------------------------------------------------------*
Local i  , _Alias , _RecNo , _BrowseArea , _DeltaScroll, m
MEMVAR cMacroVar
Private cMacroVar

	If Value <= 0
		Return
	EndIf

	If valtype ( z ) == 'U'
		i := GetControlIndex ( ControlName , ParentForm )
	Else
		i := z
	EndIf

	If _HMG_SYSDATA [ 232 ] == 'BROWSE_ONCHANGE'
		If i == _HMG_SYSDATA [ 203 ]
			MsgHMGError ("BROWSE: Value property can't be changed inside ONCHANGE event. Program Terminated" )
		EndIf
	EndIf

	_Alias := Alias()
	_BrowseArea := _HMG_SYSDATA [ 22 ] [i]

	If Select (_BrowseArea) == 0
		Return
	EndIf

	If Value == (_BrowseArea)->(RecCount()) + 1
		_HMG_SYSDATA [  8 ] [i] := Value
		ListViewReset ( _HMG_SYSDATA [3][i] )
		_BrowseOnChange (i)
		Return
	EndIf

	If Value > (_BrowseArea)->(RecCount()) + 1
		Return
	EndIf

	If Select (_BrowseArea) == 0
		Return
	EndIf

	If valtype ( mp ) == 'U'
		m := int ( ListViewGetCountPerPage ( _HMG_SYSDATA [3][i] ) / 2 )
	else
		m := mp
	endif

	_DeltaScroll := ListView_GetSubItemRect ( _HMG_SYSDATA [3][i] , 0 , 0 )

	Select &_BrowseArea

	_RecNo := RecNo()

	Go Value

	cMacroVar := dbFilter()

	If HMG_LEN (cMacroVar) > 0

		If ! &cMacroVar

			Go _RecNo
			if Select( _Alias ) != 0
				Select &_Alias
			Else
				Select 0
			Endif

			Return

		EndIf

	EndIf

	If Eof()
		Go _RecNo
		if Select( _Alias ) != 0
			Select &_Alias
		Else
			Select 0
		Endif
		Return
	Else
		if PCount() < 5
			_BrowseVscrollUpdate( i )
		EndIf
		Skip -m + 1
	EndIf

	_HMG_SYSDATA [  8 ] [i] := Value
	_BrowseUpdate( '' , '' , i )
	Go _RecNo
	if Select( _Alias ) != 0
		Select &_Alias
	Else
		Select 0
	Endif

	ListView_Scroll( _HMG_SYSDATA [3][i] , _DeltaScroll[2] * (-1) , 0 )
	ListView_SetCursel ( _HMG_SYSDATA [3] [i] , ascan ( _HMG_SYSDATA [ 32 ] [i] , Value ) )

	_HMG_SYSDATA [ 232 ] := 'BROWSE_ONCHANGE'
	_BrowseOnChange (i)
	_HMG_SYSDATA [ 232 ] := ''

Return
*-----------------------------------------------------------------------------*
Function _BrowseGetValue ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , RetVal , _BrowseRecMap , _BrowseArea

	If PCount() == 2
		i := GetControlIndex ( ControlName , ParentForm )
	Else
		i := z
	EndIf

	_BrowseArea := _HMG_SYSDATA [ 22 ] [i]

	If Select (_BrowseArea) == 0
		Return 0
	EndIf

	_BrowseRecMap := _HMG_SYSDATA [ 32 ] [i]

	If LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] ) != 0
		RetVal := _BrowseRecMap [ LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] ) ]
	Else
		RetVal := 0
	EndIf

Return ( RetVal )

*-----------------------------------------------------------------------------*
Function  _BrowseDelete (  ControlName , ParentForm , z  )
*-----------------------------------------------------------------------------*
Local i , _BrowseRecMap , Value , _Alias , _RecNo , _BrowseArea

	If PCount() == 2
		i := GetControlIndex ( ControlName , ParentForm )
	Else
		i := z
	EndIf

	If LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] ) == 0
		Return Nil
	EndIf

	_BrowseRecMap := _HMG_SYSDATA [ 32 ] [i]

	Value := _BrowseRecMap [ LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] ) ]

	If Value == 0
		Return Nil
	EndIf

	_Alias := Alias()
	_BrowseArea := _HMG_SYSDATA [ 22 ] [i]
	If Select (_BrowseArea) == 0
		Return Nil
	EndIf
	Select &_BrowseArea
	_RecNo := RecNo()

	Go Value

	If _HMG_SYSDATA [  9 ] [i] == .t.
		If RLock()
			Delete
			Skip
			if Eof()
				Go Bottom
			EndIf

			If Set ( _SET_DELETED ) == .T.
				_BrowseSetValue( '' , '' , RecNo() , i , LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] ) )
			EndIf

		Else

			MsgStop('Record is being editied by another user. Retry later','Delete Record')

		EndIf

	Else

		Delete
		Skip
		if Eof()
			Go Bottom
		EndIf
		If Set ( _SET_DELETED ) == .T.
			_BrowseSetValue( '' , '' , RecNo() , i  , LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] ) )
		EndIf

	EndIf

	Go _RecNo
	if Select( _Alias ) != 0
		Select &_Alias
	Else
		Select 0
	Endif

Return Nil
*------------------------------------------------------------------------------*
Function _BrowseEdit ( GridHandle , aValid , aValidMessages , aReadOnly , lock , append , inplace , INPUTITEMS )
*------------------------------------------------------------------------------*
Private aWhen
Private aWhenVarNames

	InPlace := .T.

	If LISTVIEW_GETFIRSTITEM (GridHandle) == 0
		If Valtype (append) != 'U'
			If append == .f.
				Return Nil
			EndIf
		EndIf
	EndIf

	If InPlace
		_BrowseInPlaceEdit ( GridHandle , aValid , aValidMessages , aReadOnly , lock , append , INPUTITEMS )
		Return Nil
	EndIf

Return Nil

*------------------------------------------------------------------------------*
Function _BrowseInPlaceEdit ( GridHandle , aValid , aValidMessages , aReadOnly , lock , append , aInputItems )
*------------------------------------------------------------------------------*
Local GridCol , GridRow , i , nrec , _GridWorkArea , BackArea , BackRec , _GridFields , FieldName , CellData, CellColIndex , x
Local aFieldNames
Local aTypes
Local aWidths
Local aDecimals

Local Width
Local Decimals
Local sFieldname
Local r
Local ControlType
Local Ldelta := 0
Local aTemp
Local E
LOCAL aInputMask
LOCAL aFormat
LOCAL BFN
LOCAL BFS
Local lInputItems := .F.
Local aItems := {}
Local p
Local aValues := {}
Local ii
Local ba
Local br

	If _HMG_SYSDATA [ 232 ] == 'BROWSE_WHEN'
		MsgHMGError("BROWSE: Editing within a browse 'when' event procedure is not allowed. Program terminated" )
	EndIf
	If _HMG_SYSDATA [ 232 ] == 'BROWSE_VALID'
		MsgHMGError("BROWSE: Editing within a browse 'valid' event procedure is not allowed. Program terminated" )
	EndIf


	If append

		I := ascan ( _HMG_SYSDATA [3] , GridHandle )

		_BrowseInPlaceAppend ( '' , '' , i )

		Return Nil

	EndIf

	If This.CellRowIndex != LISTVIEW_GETFIRSTITEM ( GridHandle )
		Return Nil
	EndIf

	I := ascan ( _HMG_SYSDATA [3] , GridHandle )

	BFN := _HMG_SYSDATA [ 27 ] [i]
	BFS := _HMG_SYSDATA [ 28 ] [i]

	aInputMask := _HMG_SYSDATA [ 40 ] [ I ] [ 4 ]

	aFormat := _HMG_SYSDATA [40] [I] [5]

	_GridWorkArea := _HMG_SYSDATA [ 22 ] [i]

	_GridFields := _HMG_SYSDATA [ 31 ] [i]

	CellColIndex := This.CellColIndex

	If CellColIndex < 1 .or. CellColIndex > HMG_LEN (_GridFields)
		Return Nil
	EndIf

	if HMG_LEN ( _HMG_SYSDATA [ 14 ] [i] ) > 0 .And. CellColIndex == 1
		PlayHand()
		Return Nil
	EndIf

	If valType ( aInputItems ) == 'A'
		If HMG_LEN ( aInputItems ) >= CellColIndex
			If ValType ( aInputItems [ CellColIndex ] ) == 'A'
				lInputItems := .T.
			EndIf
		EndIf
	EndIf

	If ValType ( aReadOnly ) == 'A'
		If HMG_LEN ( aReadOnly ) >= CellColIndex
			If aReadOnly [ CellColIndex ] != Nil
				If aReadOnly [ CellColIndex ] == .T.
					_HMG_SYSDATA [ 256 ] := .F.
					Return Nil
				EndIf
			EndIf
		EndIf
	EndIf

	FieldName := _GridFields [  CellColIndex ]

	// If the specified area does not exists, set recorcount to 0 and
	// return

	If Select (_GridWorkArea) == 0
		Return Nil
	EndIf

	// Save Original WorkArea
	BackArea := Alias()

	// Save Original Record Pointer
	BackRec := RecNo()

	// Selects Grid's WorkArea

	Select &_GridWorkArea

	nRec := _GetValue ( '','',i )
	Go nRec

	// If LOCK clause is present, try to lock.

	If lock == .T.
		If RLock() == .F.
			MsgExclamation(_HMG_SYSDATA [ 136 ][9],_HMG_SYSDATA [ 136 ][10])
			// Restore Original Record Pointer
			Go BackRec
			// Restore Original WorkArea
			If Select (BackArea) != 0
				Select &BackArea
			Else
				Select 0
			EndIf
			Return Nil
		EndIf
	EndIf

	aTemp := _HMG_SYSDATA [40] [i] [3]

	IF VALTYPE ( aTemp ) = 'A'
		IF HMG_LEN (aTemp) == HMG_LEN (_GridFields)
			IF VALTYPE ( aTemp [CellColIndex] ) = 'B'
				ba := Alias()
				br := RecNo()
				_HMG_SYSDATA [ 232 ] := 'BROWSE_WHEN'
				E := EVAL ( aTemp [CellColIndex] )
				_HMG_SYSDATA [ 232 ] := ''
				IF E == .F.
					PlayHand()
					// Restore Original Record Pointer
					Go BackRec
					// Restore Original WorkArea
					If Select (BackArea) != 0
						Select &BackArea
					Else
						Select 0
					EndIf
					_HMG_SYSDATA [ 256 ] := .F.
					Return Nil
				ENDIF
				Select (ba)
				Go br
			ENDIF
		ENDIF
	ENDIF

	CellData := &FieldName

        aFieldNames	:= ARRAY(FCount())
        aTypes		:= ARRAY(FCount())
        aWidths		:= ARRAY(FCount())
        aDecimals	:= ARRAY(FCount())

        AFIELDS(aFieldNames, aTypes, aWidths, aDecimals)

	r := HB_UAT ('>',FieldName)

	if r != 0
		sFieldName := HB_URIGHT ( FieldName, HMG_LEN(Fieldname) - r )
	Else
		sFieldName := FieldName
	EndIf

	x := FieldPos ( sFieldName )

	If x > 0
	        Width		:= aWidths [x]
        	Decimals	:= aDecimals [x]
	EndIf

	GridRow := GetWIndowRow (GridHandle)
	GridCol := GetWIndowCol (GridHandle)

	If lInputItems == .T.
		ControlType := 'X'
		Ldelta := 1
	ElseIf Type (FieldName) == 'C'
		ControlType := 'C'
	ElseIf Type (FieldName) == 'D'
		ControlType := 'D'
	ElseIf Type (FieldName) == 'L'
		ControlType := 'L'
		Ldelta := 1
	ElseIf Type (FieldName) == 'M'
		ControlType := 'M'
	ElseIf Type (FieldName) == 'N'
		If Decimals == 0
			ControlType := 'I'
		Else
			ControlType := 'F'
		EndIf
	EndIf

	If ControlType == 'M'

		r := InputBox ( '' , _HMG_SYSDATA [ 33 ] [I] [CellColIndex] , hb_utf8StrTran(CellData,CHR(141),' ') , , , .T. )

		If _HMG_SYSDATA [ 257 ] == .F.
			Replace &FieldName With r
			_HMG_SYSDATA [ 256 ] := .F.
		Else
			_HMG_SYSDATA [ 256 ] := .T.
		EndIf

	Else

		_HMG_SYSDATA [ 109 ] := GetActiveWindow()

		DEFINE WINDOW _InPlaceEdit ;
			AT This.CellRow + GridRow - _HMG_SYSDATA [ 18 ] [i] - 1 , This.CellCol + GridCol - _HMG_SYSDATA [ 19 ] [i] + 2 ;
			WIDTH This.CellWidth ;
			HEIGHT This.CellHeight + 6 + Ldelta ;
			MODAL ;
			NOCAPTION ;
			NOSIZE


			ON KEY CONTROL+W ACTION if ( _IsWindowActive ( '_InPlaceEdit' ) , _InPlaceEditOk ( i , Fieldname , _InPlaceEdit.Control_1.Value , ControlType , aValid , CellColIndex , sFieldName , _GridWorkArea , aValidMessages , lock , aInputItems ) , Nil )
			ON KEY RETURN ACTION if ( _IsWindowActive ( '_InPlaceEdit' ) , _InPlaceEditOk ( i , Fieldname , _InPlaceEdit.Control_1.Value , ControlType , aValid , CellColIndex , sFieldName , _GridWorkArea , aValidMessages , lock , aInputItems ) , Nil )
			ON KEY ESCAPE ACTION ( _HMG_SYSDATA [ 256 ] := .T. , dbRUnlock() , _InPlaceEdit.Release , setfocus ( _HMG_SYSDATA [3] [i] ) )

			If lInputItems == .T.

				* Fill Items Array

				For p := 1 To HMG_LEN ( aInputItems [ CellColIndex ] )
					aadd ( aItems , aInputItems [ CellColIndex ] [p] [1] )
				Next p

				* Fill Values Array

				For p := 1 To HMG_LEN ( aInputItems [ CellColIndex ] )
					aadd ( aValues , aInputItems [ CellColIndex ] [p] [2] )
				Next p

				ii := aScan ( aValues , CellData )

				if ii == 0
					ii := 1
				endif

				DEFINE COMBOBOX Control_1
					FONTNAME BFN
					FONTSIZE BFS
					ROW 0
					COL 0
					ITEMS aItems
					WIDTH This.CellWidth
					VALUE ii
				END COMBOBOX

			ElseIf ControlType == 'C'
				CellData := RTRIM ( CellData )

				DEFINE TEXTBOX Control_1
					FONTNAME BFN
					FONTSIZE BFS

					ROW 0
					COL 0
					WIDTH This.CellWidth
					HEIGHT This.CellHeight + 6
					VALUE CellData
					MAXLENGTH Width

					IF VALTYPE ( AINPUTMASK ) == 'A'
						IF HMG_LEN ( AINPUTMASK ) >= CellColIndex
							IF VALTYPE ( AINPUTMASK [CellColIndex] ) == 'C'
								IF ! EMPTY ( AINPUTMASK [CellColIndex] )
									INPUTMASK AINPUTMASK [CellColIndex]
								ENDIF
							ENDIF
						ENDIF
					ENDIF

				END TEXTBOX

			ElseIf ControlType == 'D'

				DEFINE DATEPICKER Control_1
					FONTNAME BFN
					FONTSIZE BFS
					ROW 0
					COL 0
					HEIGHT This.CellHeight + 6
					WIDTH This.CellWidth
					VALUE CellData
					UPDOWN .T.
					SHOWNONE .T.
				END DATEPICKER

			ElseIf ControlType == 'L'

				DEFINE COMBOBOX Control_1
					FONTNAME BFN
					FONTSIZE BFS
					ROW 0
					COL 0
					ITEMS { '.T.','.F.' }
					WIDTH This.CellWidth
					VALUE If ( CellData , 1 , 2 )
				END COMBOBOX

			ElseIf ControlType == 'I'

				DEFINE TEXTBOX Control_1
					FONTNAME BFN
					FONTSIZE BFS
					ROW 0
					COL 0
					NUMERIC	.T.
					WIDTH This.CellWidth
					HEIGHT This.CellHeight + 6
					VALUE CellData

					IF VALTYPE ( AINPUTMASK ) == 'A'
						IF HMG_LEN ( AINPUTMASK ) >= CellColIndex
							IF VALTYPE ( AINPUTMASK [CellColIndex] ) == 'C'
								IF ! EMPTY ( AINPUTMASK [CellColIndex] )
									INPUTMASK AINPUTMASK [CellColIndex]
								ELSE
									MAXLENGTH Width
								ENDIF
							ELSE
								MAXLENGTH Width
							ENDIF
						ELSE
							MAXLENGTH Width
						ENDIF
					ELSE
						MAXLENGTH Width
					ENDIF

					IF VALTYPE ( AFORMAT ) == 'A'
						IF HMG_LEN ( AFORMAT ) >= CellColIndex
							IF VALTYPE ( AFORMAT [CellColIndex] ) == 'C'
								IF ! EMPTY ( AFORMAT [CellColIndex] )
									FORMAT AFORMAT [CellColIndex]
								ENDIF
							ENDIF
						ENDIF
					ENDIF

				END TEXTBOX

			ElseIf ControlType == 'F'

				DEFINE TEXTBOX Control_1
					FONTNAME BFN
					FONTSIZE BFS
					ROW 0
					COL 0
					NUMERIC	.T.
					WIDTH This.CellWidth
					HEIGHT This.CellHeight + 6
					VALUE CellData

					IF VALTYPE ( AINPUTMASK ) == 'A'
						IF HMG_LEN ( AINPUTMASK ) >= CellColIndex
							IF VALTYPE ( AINPUTMASK [CellColIndex] ) == 'C'
								IF ! EMPTY ( AINPUTMASK [CellColIndex] )
									INPUTMASK AINPUTMASK [CellColIndex]
								ELSE
									INPUTMASK REPLICATE ( '9', Width - Decimals - 1 ) + '.' + REPLICATE ( '9', Decimals )
								ENDIF
							ELSE
								INPUTMASK REPLICATE ( '9', Width - Decimals - 1 ) + '.' + REPLICATE ( '9', Decimals )
							ENDIF
						ELSE
							INPUTMASK REPLICATE ( '9', Width - Decimals - 1 ) + '.' + REPLICATE ( '9', Decimals )
						ENDIF
					ELSE
						INPUTMASK REPLICATE ( '9', Width - Decimals - 1 ) + '.' + REPLICATE ( '9', Decimals )
					ENDIF

					IF VALTYPE ( AFORMAT ) == 'A'
						IF HMG_LEN ( AFORMAT ) >= CellColIndex
							IF VALTYPE ( AFORMAT [CellColIndex] ) == 'C'
								IF ! EMPTY ( AFORMAT [CellColIndex] )
									FORMAT AFORMAT [CellColIndex]
								ENDIF
							ENDIF
						ENDIF
					ENDIF

				END TEXTBOX

			EndIf

		END WINDOW

		ACTIVATE WINDOW _InPlaceEdit

		_HMG_SYSDATA [ 109 ] := 0

	EndIf

	// Restore Original Record Pointer
	Go BackRec

	// Restore Original WorkArea
	If Select (BackArea) != 0
		Select &BackArea
	Else
		Select 0
	EndIf

Return Nil
///////////////////////////////////////////////////////////////////////////////
Procedure _InPlaceEditOk ( i , Fieldname , r , ControlType , aValid , CellColIndex , sFieldName , AreaName , aValidMessages , lock , aInputItems )
///////////////////////////////////////////////////////////////////////////////
Local b , Result , mVar , TmpName

	If ControlType == 'X' .Or. ControlType == 'L'

		If GetDroppedState ( GetControlHandle ('Control_1' , '_InPlaceEdit' ) ) == 1
			SendMessage ( GetControlHandle ('Control_1' , '_InPlaceEdit' ) , CB_SHOWDROPDOWN , 0 , 0 )
			InsertReturn()
			Return
		EndIf

	EndIf

	If ValType ( aValid ) == 'A'
		If HMG_LEN ( aValid ) >= CellColIndex
			If aValid [ CellColIndex ] != Nil
				Result := _GetValue ( 'Control_1' , '_InPlaceEdit' )

				If ControlType == 'L'
					Result := if ( Result == 0 .or. Result == 2 , .F. , .T. )
				EndIf

				TmpName := 'MemVar' + AreaName + sFieldname
				mVar := TmpName
				&mVar := Result

				_HMG_SYSDATA [ 232 ] := 'BROWSE_VALID'

				b := Eval ( aValid [ CellColIndex ] )

				_HMG_SYSDATA [ 232 ] := ''

				If b == .f.

					If ValType ( aValidMessages ) == 'A'

						If HMG_LEN ( aValidMessages ) >= CellColIndex

							If aValidMessages [CellColIndex] != Nil

								MsgExclamation ( aValidMessages [CellColIndex] )

							Else

								MsgExclamation (_HMG_SYSDATA [ 136 ][11])

							EndIf

						Else

							MsgExclamation (_HMG_SYSDATA [ 136 ][11])

						EndIf

					Else

						MsgExclamation (_HMG_SYSDATA [ 136 ][11])

					EndIf

				Else

					If ControlType == 'L'
						r := if ( r == 0 .or. r == 2 , .F. , .T. )

					ElseIf ControlType == 'X'

						r := aInputItems [ CellColIndex ] [ r ] [ 2 ]

					EndIf

					If lock == .t.
						Replace &FieldName With r
						Unlock

						_BrowseRefresh ( '' , '' , i )

						_InPlaceEdit.Release
					Else
						Replace &FieldName With r

						_BrowseRefresh ( '' , '' , i )

						_InPlaceEdit.Release
					EndIf

				EndIf

			Else

				If ControlType == 'L'

					r := if ( r == 0 .or. r == 2 , .F. , .T. )

				ElseIf ControlType == 'X'

					r := aInputItems [ CellColIndex ] [ r ] [ 2 ]

				EndIf

				If lock == .t.

					Replace &FieldName With r
					Unlock

					_BrowseRefresh ( '' , '' , i )

					_InPlaceEdit.Release

				Else

					Replace &FieldName With r

					_BrowseRefresh ( '' , '' , i )

					_InPlaceEdit.Release

				EndIf

			EndIf

		EndIf

	Else

		If ControlType == 'L'

			r := if ( r == 0 .or. r == 2 , .F. , .T. )

		ElseIf ControlType == 'X'

			r := aInputItems [ CellColIndex ] [ r ] [ 2 ]

		EndIf

		If lock == .t.

			Replace &FieldName With r
			Unlock

			_BrowseRefresh ( '' , '' , i )

			_InPlaceEdit.Release

		Else

			Replace &FieldName With r

			_BrowseRefresh ( '' , '' , i )

			_InPlaceEdit.Release

		EndIf

	EndIf


	_HMG_SYSDATA [ 256 ] := .F.

	setfocus ( _HMG_SYSDATA [3] [i] )

Return
*------------------------------------------------------------------------------*
Procedure ProcessInPlaceKbdEdit(i)
*------------------------------------------------------------------------------*
Local r
Local IPE_MAXCOL
Local TmpRow
Local xs,xd

	If _HMG_SYSDATA [ 15 ] [ i ] == .F.
		Return
	EndIf

	if LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] ) == 0
		Return
	EndIf

	IPE_MAXCOL := HMG_LEN ( _HMG_SYSDATA [ 31 ] [i] )

	Do While .T.

		TmpRow := LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] )

		If TmpRow != _HMG_SYSDATA [ 341 ]

			_HMG_SYSDATA [ 341 ] := TmpRow

			if HMG_LEN ( _HMG_SYSDATA [ 14 ] [i] ) > 0
				_HMG_SYSDATA [ 340 ] := 2
			Else
				_HMG_SYSDATA [ 340 ] := 1
			EndIf

		EndIf

		_HMG_SYSDATA [ 195 ] := _HMG_SYSDATA [ 341 ]
		_HMG_SYSDATA [ 196 ] := _HMG_SYSDATA [ 340 ]

		If _HMG_SYSDATA [ 340 ] == 1
			r := LISTVIEW_GETITEMRECT ( _HMG_SYSDATA [3] [i]  , _HMG_SYSDATA [ 341 ] - 1 )
		Else
			r := LISTVIEW_GETSUBITEMRECT ( _HMG_SYSDATA [3] [i]  , _HMG_SYSDATA [ 341 ] - 1 , _HMG_SYSDATA [ 340 ] - 1 )
		EndIf

		xs :=	( ( _HMG_SYSDATA [ 19 ] [i] + r [2] ) +( r[3] ))  -  ( _HMG_SYSDATA [ 19 ] [i] + _HMG_SYSDATA [ 20 ] [i] )

		xd := 20

		If xs > -xd
			ListView_Scroll( _HMG_SYSDATA [3] [i] ,	xs + xd , 0 )
		Else

        		If r [2] < 0
                	     ListView_Scroll( _HMG_SYSDATA [3] [i] , r[2]	, 0 )
	                EndIf

		endIf

		If _HMG_SYSDATA [ 340 ] == 1
			r := LISTVIEW_GETITEMRECT ( _HMG_SYSDATA [3] [i]  , _HMG_SYSDATA [ 341 ] - 1 )
		Else
			r := LISTVIEW_GETSUBITEMRECT ( _HMG_SYSDATA [3] [i]  , _HMG_SYSDATA [ 341 ] - 1 , _HMG_SYSDATA [ 340 ] - 1 )
		EndIf

		_HMG_SYSDATA [ 197 ] := _HMG_SYSDATA [ 18 ] [i] + r [1]
		_HMG_SYSDATA [ 198 ] := _HMG_SYSDATA [ 19 ] [i] + r [2]
		_HMG_SYSDATA [ 199 ] := r[3]
		_HMG_SYSDATA [ 200 ] := r[4]
		_BrowseEdit ( _HMG_SYSDATA [3][i] , _HMG_SYSDATA [ 39 ] [i] [4] , _HMG_SYSDATA [ 39 ] [i] [5] , _HMG_SYSDATA [ 39 ] [i] [3] , _HMG_SYSDATA [  9 ] [i] , .f. , _HMG_SYSDATA [ 15 ] [i] , _HMG_SYSDATA [ 39 ] [i] [7] )
		_HMG_SYSDATA [ 203 ] := 0
		_HMG_SYSDATA [ 231 ] := ''

		_HMG_SYSDATA [ 195 ] := 0
		_HMG_SYSDATA [ 196 ] := 0
		_HMG_SYSDATA [ 197 ] := 0
		_HMG_SYSDATA [ 198 ] := 0
		_HMG_SYSDATA [ 199 ] := 0
		_HMG_SYSDATA [ 200 ] := 0

		If _HMG_SYSDATA [ 256 ] == .T.

			If _HMG_SYSDATA [ 340 ] == IPE_MAXCOL

				if HMG_LEN ( _HMG_SYSDATA [ 14 ] [i] ) > 0
					_HMG_SYSDATA [ 340 ] := 2
				Else
					_HMG_SYSDATA [ 340 ] := 1
				EndIf

				ListView_Scroll( _HMG_SYSDATA [3] [i] ,	-10000  , 0 )
			EndIf

			Exit

		Else

			_HMG_SYSDATA [ 340 ]++

			If _HMG_SYSDATA [ 340 ] > IPE_MAXCOL

				if HMG_LEN ( _HMG_SYSDATA [ 14 ] [i] ) > 0
					_HMG_SYSDATA [ 340 ] := 2
				Else
					_HMG_SYSDATA [ 340 ] := 1
				EndIf

				ListView_Scroll( _HMG_SYSDATA [3] [i] ,	-10000  , 0 )
				Exit
			EndIf

		EndIf

	EndDo

Return
*------------------------------------------------------------------------------*
Procedure _BrowseSync (i)
*------------------------------------------------------------------------------*
Local _Alias
Local _BrowseArea
Local _RecNo
Local _CurrentValue

	If _HMG_SYSDATA [ 254 ] == .T.

		_Alias := Alias()
		_BrowseArea := _HMG_SYSDATA [ 22 ] [i]
		If Select (_BrowseArea) == 0
			Return
		EndIf
		Select &_BrowseArea
		_RecNo := RecNo()

                _CurrentValue := _BrowseGetValue ( '' , '' , i )

		If _RecNo != _CurrentValue
			Go _CurrentValue
		EndIf

		if Select( _Alias ) != 0
			Select &_Alias
		Else
			Select 0
		Endif

	EndIf

Return
*------------------------------------------------------------------------------*
Procedure _BrowseOnChange (i)
*------------------------------------------------------------------------------*

	_BrowseSync (i)

	_DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )

Return

*-----------------------------------------------------------------------------*
Procedure _BrowseInPlaceAppend ( ControlName , ParentForm , z )
*-----------------------------------------------------------------------------*
Local i , _Alias , _RecNo , _BrowseArea , _NewRec , aTemp

	If PCount() == 2
		i := GetControlIndex ( ControlName , ParentForm )
	Else
		i := z
	EndIf

	_Alias := Alias()
	_BrowseArea := _HMG_SYSDATA [ 22 ] [i]
	If Select (_BrowseArea) == 0
		Return
	EndIf
	Select &_BrowseArea
	_RecNo := RecNo()
	Go Bottom

	_NewRec := RecCount() + 1

	if ListView_GetItemCount(_HMG_SYSDATA [3][i] ) != 0
		_BrowseVscrollUpdate( i )
		Skip - LISTVIEWGETCOUNTPERPAGE ( _HMG_SYSDATA [3][i] ) + 2
		_BrowseUpdate(ControlName , ParentForm , i )
	endif

	append blank

	Go _RecNo
	if Select( _Alias ) != 0
		Select &_Alias
	Else
		Select 0
	Endif

	aTemp := array ( HMG_LEN (_HMG_SYSDATA [ 31 ] [i]) )
	afill ( aTemp , '' )
	aadd ( _HMG_SYSDATA [ 32 ] [i] , _NewRec )

	AddListViewItems ( _HMG_SYSDATA [3][i] , aTemp , 0 )

	ListView_SetCursel ( _HMG_SYSDATA [3] [i] , HMG_LEN ( _HMG_SYSDATA [ 32 ] [i] ) )

	_BrowseOnChange (i)

	_HMG_SYSDATA [ 341 ] := 1
	_HMG_SYSDATA [ 340 ] := 1

Return

*------------------------------------------------------------------------------*
Procedure _BrowseVscrollUpdate (i)
*------------------------------------------------------------------------------*
Local ActualRecord , RecordCount , KeyCount

	// If vertical scrollbar is used it must be updated
	If _HMG_SYSDATA [  5 ] [i] != 0

		KeyCount := ordKeyCount()
		If KeyCount > 0
			ActualRecord := ordKeyNo()
			RecordCount := KeyCount
		Else
			ActualRecord := RecNo()
			RecordCount := RecCount()
		EndIf

		_HMG_SYSDATA [ 37 ] [i] := RecordCount

		If RecordCount < 100
			SetScrollRange (_HMG_SYSDATA [  5 ] [i] , 2 , 1 , RecordCount , .t. )
			SetScrollPos ( _HMG_SYSDATA [  5 ] [i] , 2 , ActualRecord , .T. )
		Else
			SetScrollRange (_HMG_SYSDATA [  5 ] [i] , 2 , 1 , 100 , .t. )
			SetScrollPos ( _HMG_SYSDATA [  5 ] [i] , 2 , Int ( ActualRecord * 100 / RecordCount ) , .T. )
		EndIf

	EndIf

Return

*------------------------------------------------------------------------------*
Procedure _BrowseVscrollFastUpdate ( i , d )
*------------------------------------------------------------------------------*
Local ActualRecord , RecordCount

	// If vertical scrollbar is used it must be updated
	If _HMG_SYSDATA [  5 ] [i] != 0

		RecordCount := _HMG_SYSDATA [ 37 ] [i]

                If ValType(RecordCount) <> 'N'
			Return
		EndIf

		If RecordCount == 0
			Return
		EndIf

		If RecordCount < 100
	                ActualRecord := GetScrollPos(_HMG_SYSDATA [  5 ] [i],2)
	                ActualRecord := ActualRecord + d
			SetScrollRange (_HMG_SYSDATA [  5 ] [i] , 2 , 1 , RecordCount , .t. )
			SetScrollPos ( _HMG_SYSDATA [  5 ] [i] , 2 , ActualRecord , .T. )
		EndIf

	EndIf

Return

*------------------------------------------------------------------------------*
Function _SetBrowseAllowEdit ( cControlName , cWindowName , lValue )
*------------------------------------------------------------------------------*
Local i

	If ValType ( lValue ) <> 'L'
		MsgHMGError("Wrong Parameter Type (Logical Required). Program terminated" )
	Endif

	i := GetControlIndex ( cControlName , cWindowName )

	_HMG_SYSDATA [ 39 ] [i] [6] := lValue

Return Nil

*------------------------------------------------------------------------------*
Function _SetBrowseAllowAppend ( cControlName , cWindowName , lValue )
*------------------------------------------------------------------------------*
Local i

	If ValType ( lValue ) <> 'L'
		MsgHMGError("Wrong Parameter Type (Logical Required). Program terminated" )
	Endif

	i := GetControlIndex ( cControlName , cWindowName )

	_HMG_SYSDATA [ 39 ] [i] [2] := lValue

Return Nil

*------------------------------------------------------------------------------*
Function _SetBrowseAllowDelete ( cControlName , cWindowName , lValue )
*------------------------------------------------------------------------------*
Local i

	If ValType ( lValue ) <> 'L'
		MsgHMGError("Wrong Parameter Type (Logical Required). Program terminated" )
	Endif

	i := GetControlIndex ( cControlName , cWindowName )

	_HMG_SYSDATA [ 25 ] [i] := lValue

Return Nil

*------------------------------------------------------------------------------*
Function _SetBrowseInputItems ( cControlName , cWindowName , aValue )
*------------------------------------------------------------------------------*
Local i
	If ValType ( aValue ) <> 'A'
		MsgHMGError("Wrong Parameter Type (Array Required). Program terminated" )
	Endif

	i := GetControlIndex ( cControlName , cWindowName )

	_HMG_SYSDATA [ 39 ] [ i ] [ 7 ] := aValue

Return Nil

*------------------------------------------------------------------------------*
Function _SetBrowseDisplayItems ( cControlName , cWindowName , aValue )
*------------------------------------------------------------------------------*
Local i
	If ValType ( aValue ) <> 'A'
		MsgHMGError("Wrong Parameter Type (Array Required). Program terminated" )
	Endif

	i := GetControlIndex ( cControlName , cWindowName )

	_HMG_SYSDATA [ 39 ] [ i ] [ 8 ] := aValue

Return Nil

*------------------------------------------------------------------------------*
Function _GetBrowseInputItems ( cControlName , cWindowName )
*------------------------------------------------------------------------------*
Local i

	i := GetControlIndex ( cControlName , cWindowName )

Return _HMG_SYSDATA [ 39 ] [i] [7]

*------------------------------------------------------------------------------*
Function _GetBrowseDisplayItems ( cControlName , cWindowName )
*------------------------------------------------------------------------------*
Local i

	i := GetControlIndex ( cControlName , cWindowName )

Return _HMG_SYSDATA [ 39 ] [i] [8]

*------------------------------------------------------------------------------*
Function _GetBrowseAllowEdit ( cControlName , cWindowName )
*------------------------------------------------------------------------------*
Local i

	i := GetControlIndex ( cControlName , cWindowName )

Return _HMG_SYSDATA [ 39 ] [i] [6]

*------------------------------------------------------------------------------*
Function _GetBrowseAllowAppend ( cControlName , cWindowName , lValue )
*------------------------------------------------------------------------------*
Local i

lValue := NIL   // ADD

	i := GetControlIndex ( cControlName , cWindowName )

Return _HMG_SYSDATA [ 39 ] [i] [2]

*------------------------------------------------------------------------------*
Function _GetBrowseAllowDelete ( cControlName , cWindowName , lValue )
*------------------------------------------------------------------------------*
Local i

lValue := NIL   // ADD

	i := GetControlIndex ( cControlName , cWindowName )

Return _HMG_SYSDATA [ 25 ] [i]

*------------------------------------------------------------------------------*
Function _BrowseCharMaskDisplay ( cText , cMask )
*------------------------------------------------------------------------------*
Local i
Local Out
Local m
Local t

	Out := ''

	For i := 1 To HMG_LEN ( cMask )

		t := HB_USUBSTR ( cText , i , 1 )
		m := HB_USUBSTR ( cMask , i , 1 )

		if	m = '!'

			Out := Out + HMG_UPPER (t)

		elseif	m = 'A' .or. m = '9'

			Out := Out + t

		else

			Out := Out + m

		endif

	Next i

Return Out


#endif


