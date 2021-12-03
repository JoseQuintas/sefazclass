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
MEMVAR _HMG_GridInplaceEdit_StageEvent   // Pre, Into, Post
MEMVAR _HMG_GridInplaceEdit_ControlHandle
MEMVAR _HMG_GridInplaceEdit_GridIndex
MEMVAR _HMG_GridEx_InplaceEditOption
MEMVAR _HMG_GridEx_InplaceEdit_nMsg


FUNCTION GridInplaceEdit_ControlHandle()
RETURN _HMG_GridInplaceEdit_ControlHandle

FUNCTION GridInplaceEdit_ControlIndex()
RETURN GetControlIndexByHandle( _HMG_GridInplaceEdit_ControlHandle )

FUNCTION GridInplaceEdit_GridName()
RETURN IIF( _HMG_GridInplaceEdit_GridIndex > 0, _HMG_SYSDATA [ 2 ] [ _HMG_GridInplaceEdit_GridIndex ], "")

FUNCTION GridInplaceEdit_ParentName()
LOCAL hWnd, cFormName := ""
   IF _HMG_GridInplaceEdit_GridIndex > 0
      hWnd := GetControlParentHandleByIndex ( _HMG_GridInplaceEdit_GridIndex )
      GetFormNameByHandle (hWnd, @cFormName)
   ENDIF
RETURN cFormName


#define WM_COMMAND  273
#define WM_SETFOCUS 7


#include 'hmg.ch'
#include 'common.ch'

#define _SHOWDELETEREC_   .F.

*-----------------------------------------------------------------------------*
Function _DefineGrid (	ControlName	, ;
			ParentForm	, ;
			x		, ;
			y		, ;
			w		, ;
			h		, ;
         aHeaders, ;
         aWidths, ;
         aRows, ;
			value		, ;
			fontname	, ;
			fontsize	, ;
			tooltip		, ;
			change		, ;
			dblclick	, ;
         aHeadClick	, ;
			gotfocus	, ;
			lostfocus	, ;
			NoGridLines		, ;
         aImage, ;
         aJust, ;
			break		, ;
			HelpId		, ;
			bold		, ;
			italic		, ;
			underline	, ;
			strikeout	, ;
			ownerdata	, ;
			ondispinfo	, ;
			itemcount	, ;
			available0	, ;
			available1	, ;
			available2	, ;
			multiselect	, ;
			available3	, ;
			backcolor	, ;
			fontcolor	, ;
			alloweditInplace	, ;
			editcontrols	, ;
			dynamicbackcolor ,;
			dynamicforecolor ,;
			columnvalid , 	  ;
			columnwhen , 	  ;
			columnheaders ,   ;
			aHeaderImages ,   ;
			cellnavigation ,  ;
			cRecordSource	, ;
         aColumnFields	, ;
			allowappend		, ;
			buffered	, ;
			allowdelete     , ;
         dynamicdisplay, ;
			onsave		, ;
			lockcolumns,;
			OnClick, OnKey, InplaceEditOption,;
         Notrans, NotransHeader,;
         aDynamicFont, OnCheckBoxClicked, OnInplaceEditEvent )
*-----------------------------------------------------------------------------*
Local i , cParentForm , mVar, wBitmap , k
Local ControlHandle
Local FontHandle
Local cParentTabName
Local nHeaderImageListHandle := Nil
Local ldfc := .F.   // ADD3
Local aColumnClassMap := {}
Local aFieldNames := {}
Local j
LOCAL lArrayRows := .T.   // ADD3

Available0 := Nil
Available1 := Nil
Available2 := Nil
Available3 := Nil


   DEFAULT alloweditInplace TO .F.
   DEFAULT columnheaders TO .T.

   DEFAULT multiselect TO .F.
   DEFAULT InplaceEditOption TO GRID_EDIT_DEFAULT

   if ValType ( lockcolumns ) == 'U'
      lockcolumns := 0
   endif

   if ValType ( cRecordSource ) == 'C'

      If Select( cRecordSource ) == 0
         MsgHMGError ("Grid: 'RecordSource' WorkArea must be open at control definition. Program Terminated")
      EndIf

      ownerdata      := .t.
      itemcount      :=  0  // ADD, May 2016  // GridRecCount( cRecordSource )
      cellnavigation := .t.
      buffered       := .t.
      lArrayRows     := .F.   // ADD3

      aSize ( aColumnClassMap , HMG_LEN ( aHeaders ) )

      aSize ( aFieldNames , &cRecordSource->( FCount() ) )

      &cRecordSource->( AFIELDS( aFieldNames ) )

      aFill ( aColumnClassMap , 'E' )

      For i := 1 To HMG_LEN ( aColumnFields )
         For j := 1 To HMG_LEN ( aFieldNames )
            If ALLTRIM( HMG_UPPER( aColumnFields [i] ) ) == ALLTRIM( HMG_UPPER( aFieldNames [j] ) )
               aColumnClassMap [ i ] := 'F'
               Exit
            EndIf
         Next
      Next

      if alloweditInplace
         if ValType(editcontrols) <> 'A'
            MsgHMGError ("Grid: 'ColumnControls' must be specified when 'RecordSource' was set. Program Terminated")
         endif
      endif

   endif


   If ValType(aColumnFields) == 'A'
      If ValType ( cRecordSource ) != 'C'
         MsgHMGError ("Grid: 'ColumnFields' can be specified only for a 'RowSource' bound Grid. Program Terminated")
      Endif
   Endif

   If allowappend == .T.
      If ValType ( cRecordSource ) != 'C'
         MsgHMGError ("Grid: 'AllowAppend' can be specified only for a 'RowSource' bound Grid. Program Terminated")
      Endif
   Endif

   If allowdelete == .T.
      If ValType ( cRecordSource ) != 'C'
         MsgHMGError ("Grid: 'AllowDelete' can be specified only for a 'RowSource' bound Grid. Program Terminated")
      Endif
   Endif

   If buffered == .T.
      If ValType ( cRecordSource ) != 'C'
         MsgHMGError ("Grid: 'Buffered' can be specified only for a 'RowSource' bound Grid. Program Terminated")
      Endif
   Endif

   If ValType(dynamicdisplay) == 'A'
      If ValType ( cRecordSource ) != 'C'
         MsgHMGError ("Grid: 'DynamicDisplay' can be specified only for a 'RowSource' bound Grid. Program Terminated")
      Endif
   Endif

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
		MsgHMGError(_HMG_SYSDATA [ 136 ][1]+ ParentForm + _HMG_SYSDATA [ 136 ][2])
	Endif

	If _IsControlDefined (ControlName,ParentForm)
		MsgHMGError (_HMG_SYSDATA [ 136 ][4] + ControlName + _HMG_SYSDATA [ 136 ][5] + ParentForm + _HMG_SYSDATA [ 136 ][6])
	endif


   // ADD April 2016
#define DEFAULT_COLUMNHEADER  "Column "
#define DEFAULT_COLUMNWIDTH   150
   IF lArrayRows == .T.
      IF ValType( aRows ) == "A" .AND. HMG_LEN( aRows ) > 0
         IF ValType( aHeaders ) == "U" .AND. ValType ( aWidths ) == "U"
            aHeaders := ARRAY( HMG_LEN( aRows[ 1 ] ))
            aWidths  := ARRAY( HMG_LEN( aRows[ 1 ] ))
            AEVAL( aHeaders, { |xValue,nIndex| xValue:= NIL, aHeaders[ nIndex ] := DEFAULT_COLUMNHEADER + hb_ntos( nIndex ) } )
            AFILL( aWidths,  DEFAULT_COLUMNWIDTH )
         ELSEIF ValType( aHeaders ) == "A" .AND. ValType ( aWidths ) == "U"
            aWidths  := ARRAY( HMG_LEN( aHeaders ))
            AFILL( aWidths,  DEFAULT_COLUMNWIDTH )
         ELSEIF ValType( aHeaders ) == "U" .AND. ValType ( aWidths ) == "A"
            aHeaders := ARRAY( HMG_LEN( aWidths ))
            AEVAL( aHeaders, { |xValue,nIndex| xValue:= NIL, aHeaders[ nIndex ] := DEFAULT_COLUMNHEADER + hb_ntos( nIndex ) } )
         ENDIF
      ELSE
         IF ValType( aHeaders ) == "U" .AND. ValType ( aWidths ) == "U"
            aHeaders := {}
            aWidths  := {}
         ELSEIF ValType( aHeaders ) == "A" .AND. ValType ( aWidths ) == "U"
            aWidths  := ARRAY( HMG_LEN( aHeaders ))
            AFILL( aWidths,  DEFAULT_COLUMNWIDTH )
         ELSEIF ValType( aHeaders ) == "U" .AND. ValType ( aWidths ) == "A"
            aHeaders := ARRAY( HMG_LEN( aWidths ))
            AEVAL( aHeaders, { |xValue,nIndex| xValue:= NIL, aHeaders[ nIndex ] := DEFAULT_COLUMNHEADER + hb_ntos( nIndex ) } )
         ENDIF
      ENDIF
   ENDIF

   if ValType ( aWidths ) == 'U'
      MsgHMGError ("Grid: WIDTHS not defined .Program Terminated")
   EndIf

   if columnheaders == .F.
      aHeaders := array ( HMG_LEN ( aWidths ) )
      afill ( aHeaders , '' )
   endif

   if ValType ( aHeaders ) == 'U'
      MsgHMGError ("Grid: HEADERS not defined .Program Terminated")
   EndIf

   if HMG_LEN ( aHeaders ) != HMG_LEN ( aWidths )
      MsgHMGError ("Browse/Grid: FIELDS/HEADERS/WIDTHS array size mismatch .Program Terminated")
   EndIf

   if ValType (aRows) != 'U' .AND. lArrayRows == .T.   // ADD3
      if HMG_LEN (aRows) > 0 .AND. ValType (aRows [1]) == 'A'   // ADD
         if HMG_LEN (aRows[1]) != HMG_LEN ( aHeaders )
            MsgHMGError ("Grid: ITEMS length mismatch. Program Terminated")
         EndIf
      EndIf
   EndIf

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm = ParentForm

   ParentForm = GetFormHandle (ParentForm)

	if ValType(w) == "U"
		w := 240
	endif
	if ValType(h) == "U"
		h := 120
	endif
	if ValType(value) == "U" .and. !MultiSelect
		value := 0
	endif
	if ValType(aRows) == "U"
		aRows := {}
	endif
	if ValType(aJust) == "U"		// Grid+
		aJust := Array( HMG_LEN( aHeaders ) )
		aFill( aJust, 0 )
	else
		aSize( aJust, HMG_LEN( aHeaders ) )
		aEval( aJust, { |x| x := iif( x == NIL, 0, x ) } )
	endif
	if ValType(aImage) == "U"  		// Grid+
		aImage := {}
	endif

	if ValType(x) == "U" .or. ValType(y) == "U"

		If _HMG_SYSDATA [ 216 ] == 'TOOLBAR'
			Break := .T.
		EndIf

		_HMG_SYSDATA [ 216 ]	:= 'GRID'

		i := GetFormIndex ( cParentForm )

		if i > 0

			ControlHandle := InitListView ( _HMG_SYSDATA [ 87 ] [i] , 0, 0, 0, w, h ,'',0, NoGridLines, ownerdata , itemcount , multiselect , columnheaders )

			if ValType(fontname) != "U" .and. ValType(fontsize) != "U"
				FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
			Else
				FontHandle := _SetFont (ControlHandle,_HMG_SYSDATA [ 342 ],_HMG_SYSDATA [ 343 ],bold,italic,underline,strikeout)
			endif

			AddSplitBoxItem ( Controlhandle, _HMG_SYSDATA [ 87 ] [i] , w , break , , , , _HMG_SYSDATA [ 258 ] )
		EndIf

	Else

		ControlHandle := InitListView ( ParentForm, 0, x, y, w, h ,'',0, NoGridLines, ownerdata  , itemcount  , multiselect , columnheaders )

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

	wBitmap := iif( HMG_LEN( aImage ) > 0, AddListViewBitmap( ControlHandle, aImage, Notrans ), 0 )

   IF HMG_LEN( aWidths ) == 0
      aWidths := {0}   // ADD April 2016
   ENDIF

	aWidths[1] := max ( aWidths[1], wBitmap + 2 ) // Set Column 1 width to Bitmap width

	If _HMG_SYSDATA [ 265 ] = .T.
		aAdd ( _HMG_SYSDATA [ 142 ] , ControlHandle )
	EndIf

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

   IF ValType (aDynamicFont) == "A"
      if HMG_LEN ( aHeaders ) <> HMG_LEN ( aDynamicFont )
         MsgHMGError ("Grid: DYNAMIC FONT array size mismatch .Program Terminated")
      EndIf
   ENDIF

	k := _GetControlFree()

	Public &mVar. := k

	_HMG_SYSDATA [  1 ] [k] :=  if ( multiselect , "MULTIGRID" , "GRID" )
	_HMG_SYSDATA [  2 ] [k] :=  ControlName
	_HMG_SYSDATA [  3 ] [k] :=  ControlHandle
	_HMG_SYSDATA [  4 ] [k] :=  ParentForm
	_HMG_SYSDATA [  5 ] [k] :=  ListView_GetHeader ( ControlHandle )
	_HMG_SYSDATA [  6 ] [k] :=  ondispinfo
	_HMG_SYSDATA [  7 ] [k] :=  aHeaders
	_HMG_SYSDATA [  8 ] [k] :=  Value
	_HMG_SYSDATA [  9 ] [k] :=  Nil
	_HMG_SYSDATA [ 10 ] [k] :=  lostfocus
	_HMG_SYSDATA [ 11 ] [k] :=  gotfocus
	_HMG_SYSDATA [ 12 ] [k] :=  change
	_HMG_SYSDATA [ 13 ] [k] :=  .F.
	_HMG_SYSDATA [ 14 ] [k] :=  aImage
	_HMG_SYSDATA [ 15 ] [k] :=  1       // nCol cellnavigation
	_HMG_SYSDATA [ 16 ] [k] :=  dblclick
	_HMG_SYSDATA [ 17 ] [k] :=  aHeadClick
	_HMG_SYSDATA [ 18 ] [k] :=  y
	_HMG_SYSDATA [ 19 ] [k] :=  x
	_HMG_SYSDATA [ 20 ] [k] :=  w
	_HMG_SYSDATA [ 21 ] [k] :=  h
	_HMG_SYSDATA [ 22 ] [k] :=  Nil
	_HMG_SYSDATA [ 23 ] [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 24 ] [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 25 ] [k] :=  Nil
	_HMG_SYSDATA [ 26 ] [k] :=  0  // nHeaderImageListHandle
	_HMG_SYSDATA [ 27 ] [k] :=  fontname
	_HMG_SYSDATA [ 28 ] [k] :=  fontsize
	_HMG_SYSDATA [ 29 ] [k] :=  {bold,italic,underline,strikeout}
	_HMG_SYSDATA [ 30 ] [k] :=  tooltip
	_HMG_SYSDATA [ 31 ] [k] :=  cParentTabName
	_HMG_SYSDATA [ 32 ] [k] :=  cellnavigation
	_HMG_SYSDATA [ 33 ] [k] :=  aHeaders
	_HMG_SYSDATA [ 34 ] [k] :=  .t.
	_HMG_SYSDATA [ 35 ] [k] :=  HelpId
	_HMG_SYSDATA [ 36 ] [k] :=  FontHandle
	_HMG_SYSDATA [ 37 ] [k] :=  aJust
	_HMG_SYSDATA [ 38 ] [k] :=  .T.
	_HMG_SYSDATA [ 39 ] [k] :=  0       // nRow cellnavigation
	_HMG_SYSDATA [ 40 ] [k] := Array (47)


	_HMG_SYSDATA [ 40 ] [ K ] [  1 ] := alloweditInplace   // Allow ENTER
	_HMG_SYSDATA [ 40 ] [ K ] [  2 ] := editcontrols
	_HMG_SYSDATA [ 40 ] [ K ] [  3 ] := dynamicbackcolor
	_HMG_SYSDATA [ 40 ] [ K ] [  4 ] := dynamicforecolor
	_HMG_SYSDATA [ 40 ] [ K ] [  5 ] := columnvalid
	_HMG_SYSDATA [ 40 ] [ K ] [  6 ] := columnwhen
   _HMG_SYSDATA [ 40 ] [ K ] [  7 ] := NIL // old internal dynamicforecolor --> ARRAY (nRowCount , nColCount)
   _HMG_SYSDATA [ 40 ] [ K ] [  8 ] := NIL // old internal dynamicforecolor --> ARRAY (nRowCount , nColCount)
	_HMG_SYSDATA [ 40 ] [ K ] [  9 ] := OWNERDATA
	_HMG_SYSDATA [ 40 ] [ K ] [ 10 ] := cRecordSource
	_HMG_SYSDATA [ 40 ] [ K ] [ 11 ] := aColumnFields
	_HMG_SYSDATA [ 40 ] [ K ] [ 12 ] := allowappend   // Allow ALT+A
	_HMG_SYSDATA [ 40 ] [ K ] [ 13 ] := if ( ValType (aColumnFields) == 'A' , array ( HMG_LEN (aColumnFields) ) , Nil )
	_HMG_SYSDATA [ 40 ] [ K ] [ 14 ] := .F.   // old Grid
	_HMG_SYSDATA [ 40 ] [ K ] [ 15 ] := buffered
	_HMG_SYSDATA [ 40 ] [ K ] [ 16 ] := ldfc
	_HMG_SYSDATA [ 40 ] [ K ] [ 17 ] := allowdelete   // Allow ALT+D and ALT+R
	_HMG_SYSDATA [ 40 ] [ K ] [ 18 ] := dynamicdisplay
	_HMG_SYSDATA [ 40 ] [ K ] [ 19 ] := .F.
	_HMG_SYSDATA [ 40 ] [ K ] [ 20 ] := .F. // Pending Edit Updates Flag
	_HMG_SYSDATA [ 40 ] [ K ] [ 21 ] := {}  // Edit Updates Buffer
	_HMG_SYSDATA [ 40 ] [ K ] [ 22 ] := 0   // Appended Record Buffer Count ( Negative )
	_HMG_SYSDATA [ 40 ] [ K ] [ 23 ] := ItemCount // Buffered Session Initial ItemCount
	_HMG_SYSDATA [ 40 ] [ K ] [ 24 ] :=  0 // Deleted / Recalled record count
	_HMG_SYSDATA [ 40 ] [ K ] [ 25 ] := {} // Delete / Recall Buffer Array { nLogicalRow , nPhysicalRow , cStatus ( 'D' or 'R' ) }
	_HMG_SYSDATA [ 40 ] [ K ] [ 26 ] := OnSave
	_HMG_SYSDATA [ 40 ] [ K ] [ 27 ] := NIL // old internal Enable Virtual Database Grid Optimization
	_HMG_SYSDATA [ 40 ] [ K ] [ 28 ] := backcolor
	_HMG_SYSDATA [ 40 ] [ K ] [ 29 ] := fontcolor
	_HMG_SYSDATA [ 40 ] [ K ] [ 30 ] := aColumnClassMap
	_HMG_SYSDATA [ 40 ] [ K ] [ 31 ] := aWidths
	_HMG_SYSDATA [ 40 ] [ K ] [ 32 ] := lockcolumns
	_HMG_SYSDATA [ 40 ] [ K ] [ 33 ] := .T.  // ENABLEUPDATE = .T. | DISABLEUPDATE = .F.
	_HMG_SYSDATA [ 40 ] [ K ] [ 34 ] := .T.
   _HMG_SYSDATA [ 40 ] [ K ] [ 35 ] := OnClick   // ADD
   _HMG_SYSDATA [ 40 ] [ K ] [ 36 ] := OnKey     // ADD
   _HMG_SYSDATA [ 40 ] [ K ] [ 37 ] := {0,0}   // CellRowClicked and CellColClicked       // ADD
   _HMG_SYSDATA [ 40 ] [ K ] [ 38 ] := IF (ValType(InplaceEditOption) == "N", InplaceEditOption, 0)
   _HMG_SYSDATA [ 40 ] [ K ] [ 39 ] := NotransHeader
   _HMG_SYSDATA [ 40 ] [ K ] [ 40 ] := cParentForm    // ADD
   _HMG_SYSDATA [ 40 ] [ K ] [ 41 ] := aDynamicFont   // ADD
   _HMG_SYSDATA [ 40 ] [ K ] [ 42 ] := 0              // hFont_Dynamic
   _HMG_SYSDATA [ 40 ] [ K ] [ 43 ] := NIL            // aHeaderFont
   _HMG_SYSDATA [ 40 ] [ K ] [ 44 ] := NIL            // aHeaderBackColor
   _HMG_SYSDATA [ 40 ] [ K ] [ 45 ] := NIL            // aHeaderForeColor
   _HMG_SYSDATA [ 40 ] [ K ] [ 46 ] := OnCheckBoxClicked
   _HMG_SYSDATA [ 40 ] [ K ] [ 47 ] := OnInplaceEditEvent

   InitListViewColumns ( ControlHandle, aHeaders , aWidths, aJust )


IF ValType ( cRecordSource ) == 'C'   // ADD, May 2016
   ItemCount := GridRecCount( K )
   _HMG_SYSDATA [ 40 ] [ K ] [ 23 ] := ItemCount
   ListView_SetItemCount ( ControlHandle , ItemCount )
ENDIF


IF lArrayRows == .T.   // ADD3
   for i := 1 to HMG_LEN (aRows)
      _AddGridRow ( ControlName, cParentForm, aRows [i] )
   next
ENDIF

	if multiselect == .T.

		if ValType ( value ) == 'A'
			ListViewSetMultiSel (ControlHandle,value)
		endif

	Else

		If CellNavigation == .T.
			_SetValue ( , , Value , k )
		Else

			if Value <> 0
				ListView_SetCursel (ControlHandle , Value )
			endif

		EndIf

	EndIf

	If ValType(aHeaderImages) <> "U"
		nHeaderImageListHandle := SetListViewHeaderImages ( ControlHandle , aHeaderImages , aJust, NotransHeader )
		_HMG_SYSDATA [ 22 ] [k] := aHeaderImages
		_HMG_SYSDATA [ 26 ] [k] := nHeaderImageListHandle
	EndIf


Return Nil




//*****************************************************
//* by Dr. Claudio Soto, April 2014
//*****************************************************


FUNCTION _HMG_GridOnClickAndOnKeyEvent
LOCAL ret := NIL, lInplacedEdit := .F.
LOCAL i := ASCAN ( _HMG_SYSDATA [3] ,  EventHWND() )

   IF i > 0 .AND. ( EventHWND() == _HMG_GridInplaceEdit_ControlHandle )
      i := _HMG_GridInplaceEdit_GridIndex
      lInplacedEdit := .T.
   ENDIF

   IF i > 0 .AND. ( _HMG_SYSDATA [1] [i] == "GRID" .OR. _HMG_SYSDATA [1] [i] == "MULTIGRID" )

      _HMG_GridEx_InplaceEdit_nMsg  := EventMSG()
      _HMG_GridEx_InplaceEditOption := _HMG_SYSDATA [40] [i] [38]

      IF EventMSG() == WM_SETFOCUS
         HMG_GetLastCharacterEx()
      ENDIF

      IF ( EventMSG() == WM_LBUTTONDOWN .OR. EventMSG() == WM_LBUTTONDBLCLK ) .AND. ValType( _HMG_SYSDATA [40] [i] [35] ) == "B"
         IF lInplacedEdit == .F.
            _HMG_SYSDATA [40] [i] [37] := _GetGridCellData (i)   // { CellRowClicked, CellColClicked }
         ENDIF
         ret := EVAL ( _HMG_SYSDATA [40] [i] [35] )   // OnClick Event
      ENDIF

      IF EventIsKeyboardMessage() == .T. .AND. ValType( _HMG_SYSDATA [40] [i] [36] ) == "B"
         ret := EVAL ( _HMG_SYSDATA [40] [i] [36] )   // OnKey Event
      ENDIF

      IF lInplacedEdit == .F.
         IF ValType(ret) <> "N" .AND. EventMSG() == WM_CHAR .AND. _HMG_GridEx_InplaceEditOption >= 1 .AND. _HMG_GridEx_InplaceEditOption <= 4
            ret := Events (0, WM_COMMAND, 1, 0)
         ENDIF
      ENDIF

   ENDIF

RETURN ret


FUNCTION _HMG_GridInplaceEditEvent
__THREAD STATIC Flag := .F.

   IF ValType (_HMG_GridInplaceEdit_ControlHandle) == "N" .AND. _HMG_GridInplaceEdit_ControlHandle <> 0
      IF Flag == .F.
         Flag := .T.

         IF _HMG_GridEx_InplaceEdit_nMsg == WM_LBUTTONDBLCLK
            HMG_GetLastCharacterEx()
         ENDIF

         IF _HMG_GridEx_InplaceEditOption == 2
            _PushKey (VK_END)
         ELSEIF _HMG_GridEx_InplaceEditOption == 3
            SendMessage (_HMG_GridInplaceEdit_ControlHandle, WM_KEYDOWN, VK_END, 0)
            SendMessage (_HMG_GridInplaceEdit_ControlHandle, WM_KEYUP,   VK_END, 0)
            HMG_SendCharacterEx (_HMG_GridInplaceEdit_ControlHandle, HMG_GetLastCharacterEx())
            _PushKey (VK_END)
         ELSEIF _HMG_GridEx_InplaceEditOption == 4
            IF _HMG_GridEx_InplaceEdit_nMsg == WM_LBUTTONDBLCLK
               _PushKey (VK_BACK)
            ELSE
               HMG_SendCharacter (_HMG_GridInplaceEdit_ControlHandle, HMG_GetLastCharacterEx())
            ENDIF
         ENDIF
      ENDIF
   ELSE
      Flag := .F.
   ENDIF
RETURN NIL



// Enhanced by Dr. Claudio Soto (April 2013)
*-----------------------------------------------------------------------------*
Function _AddGridRow ( ControlName, ParentForm, aItem, nRowIndex )
*-----------------------------------------------------------------------------*
Local i, hWnd, k
LOCAL iImage := 0, aTemp

   i := GetControlIndex  ( ControlName, ParentForm )

   hWnd := GetControlHandle ( ControlName, ParentForm )

   IF ValType (nRowIndex) == "U"
      nRowIndex := ListView_GetItemCount (hWnd) + 1
   ELSEIF nRowIndex > (ListView_GetItemCount(hWnd) + 1)
      MsgHMGError ("Grid.AddItem (nRowIndex = " +ALLTRIM(Str(nRowIndex))+ "): Invalid nRowIndex. Program Terminated")
   ENDIF

   if HMG_LEN ( _HMG_SYSDATA [ 7 ] [i] ) != HMG_LEN ( aItem )
      MsgHMGError ("Grid.AddItem (nRowIndex = " +ALLTRIM(Str(nRowIndex))+ "): Item size mismatch. Program Terminated")
   EndIf

   IF ValType ( _HMG_SYSDATA [40] [i] [2] ) == 'A'   // editcontrols

      aTemp := ARRAY ( HMG_LEN(aItem) )
      AFILL ( aTemp , '' )
      if HMG_LEN( _HMG_SYSDATA [14] [i] ) > 0   // aImage
         iImage   := aItem[1]
         aItem[1] := NIL
         aTemp[1] := NIL
      endif
      AddListViewItems ( hWnd , aTemp , iImage , nRowIndex-1)
      _SetItem ( ControlName , ParentForm , nRowIndex , aItem )

   ELSE

      if HMG_LEN( _HMG_SYSDATA [ 14 ][i] ) > 0   // aImage
         iImage   := aItem[1]
         aItem[1] := NIL
      endif

      aTemp := ACLONE( aItem )
      FOR k := 1 TO HMG_LEN( aTemp )   // by Dr. Claudio Soto, April 2016
         IF ValType( aTemp[ k ] ) <> "C" .AND. ValType( aTemp[ k ] ) <> "U"
            aTemp[ k ] := hb_ValToStr( aTemp[ k ] )
         ENDIF
      NEXT

      AddListViewItems ( hWnd , aTemp, iImage , nRowIndex-1)

   ENDIF
Return Nil



// by Dr. Claudio Soto (April 2013)
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
Procedure _AddGridColumn ( cControlName , cParentForm , nColIndex , cCaption , nWidth , nJustify, aColumnControl)
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
LOCAL lRefresh
LOCAL k, nWidth_sum := 0

   If ValType ( nColIndex ) == 'U'
      nColIndex := _GridEx_ColumnCount (cControlName , cParentForm) + 1
   EndIf

   If ValType ( cCaption ) == 'U'
      cCaption := ''
   EndIf

   If ValType ( nWidth ) == 'U'
      nWidth := 120
   EndIf

   If ValType ( nJustify ) == 'U'
      nJustify := GRID_JTFY_LEFT
   EndIf

   If ValType ( aColumnControl ) == 'U'
      aColumnControl := {'TEXTBOX','CHARACTER'}
   EndIf

   _GridEx_AddColumnEx (cControlName, cParentForm, nColIndex)
   lRefresh := .F.
   _GridEx_SetColumnControl (cControlName, cParentForm, _GRID_COLUMN_HEADER_,    nColIndex, cCaption,       lRefresh)
   _GridEx_SetColumnControl (cControlName, cParentForm, _GRID_COLUMN_WIDTH_,     nColIndex, nWidth,         lRefresh)
   _GridEx_SetColumnControl (cControlName, cParentForm, _GRID_COLUMN_JUSTIFY_,   nColIndex, nJustify,       lRefresh)
   _GridEx_SetColumnControl (cControlName, cParentForm, _GRID_COLUMN_CONTROL_,   nColIndex, aColumnControl, lRefresh)

   LISTVIEW_ADDCOLUMN (GetControlHandle(cControlName,cParentForm), nColIndex , nWidth , cCaption , nJustify )   // Call C-Level Routine (source c_grid.c)

   IF SET_GRID_DELETEALLITEMS () == .T.
      RETURN   // for compatibility with old behavior of ADDCOLUMN and DELETECOLUMN
   ENDIF

   FOR k = 1 TO _GridEx_ColumnCount(cControlName,cParentForm)
       nWidth_sum := nWidth_sum + LISTVIEW_GETCOLUMNWIDTH (GetControlHandle (cControlName, cParentForm), k-1)
   NEXT
   IF nWidth_sum > GetProperty (cParentForm, cControlName, "Width")
      #define SB_HORZ   0
      #define SB_VERT   1
      #define SB_CTL    2
      #define SB_BOTH   3
      k := GetScrollRangeMax ( GetControlHandle(cControlName,cParentForm), SB_HORZ )
      SETSCROLLRANGE ( GetControlHandle(cControlName,cParentForm), SB_HORZ, 0, k + LISTVIEW_GETCOLUMNWIDTH (GetControlHandle (cControlName, cParentForm), nColIndex-1), .T. )
      SHOWSCROLLBAR (GetControlHandle(cControlName,cParentForm), SB_HORZ, .T.)
   ENDIF

   _GridEx_UpdateCellValue (cControlName, cParentForm, nColIndex)   // Force the rewrite the all items of the Column(nColumnIndex)

   REDRAWWINDOW (GetControlHandle (cControlName, cParentForm))
   UpdateWindow (GetControlHandle (cControlName, cParentForm))
Return


// by Dr. Claudio Soto (April 2013)
*-----------------------------------------------------------------------------------*
Procedure _DeleteGridColumn ( cControlName , cParentForm , nColIndex)
*-----------------------------------------------------------------------------------*
LOCAL nItemCount
   _GridEx_DeleteColumnEx (cControlName, cParentForm, nColIndex)
   ListView_DeleteColumn ( GetControlHandle(cControlName,cParentForm), nColIndex )   // Call C-Level Routine (source c_grid.c)

   IF SET_GRID_DELETEALLITEMS () == .T.
      RETURN   // for compatibility with old behavior of ADDCOLUMN and DELETECOLUMN
   ENDIF

   nItemCount := ListView_GetItemCount (GetControlHandle(cControlName,cParentForm))
   LISTVIEW_REDRAWITEMS (GetControlHandle(cControlName,cParentForm) , 0, nItemCount-1)
   REDRAWWINDOW (GetControlHandle (cControlName, cParentForm))
   UpdateWindow (GetControlHandle (cControlName, cParentForm))
Return



*-----------------------------------------------------------------------------*
FUNCTION _HMG_GRIDINPLACEEDIT(IDX)
*-----------------------------------------------------------------------------*
Local r , c , h , aTemp , ri , ci , DW := 0, DH := 0 , DR := 0 , DC := 0
LOCAL AEDITCONTROLS
LOCAL AEC := 'TEXTBOX'
LOCAL AITEMS
LOCAL ARANGE
LOCAL DTYPE
LOCAL ALABELS := { '.T.' ,'.F.' }
LOCAL CTYPE := 'CHARACTER'
LOCAL CINPUTMASK := ''
LOCAL CFORMAT := ''
LOCAL XRES
LOCAL CVA
LOCAL CWH
LOCAL WHEN
LOCAL GFN
LOCAL GFS
LOCAL V
Local nWx := 0
Local nHx := 0
LOCAL ARETURNVALUES
LOCAL Z
Local xValue := 0
Local cRecordSource
Local cTextFile
LOCAL nIndex, cProc

_HMG_GridInplaceEdit_GridIndex := IDX  // ADD

/*
   AEDITCONTROLS := _HMG_SYSDATA [ 40 ] [ IDX ] [ 2 ]
   IF ValType (AEDITCONTROLS) == "A" .AND. HMG_LEN (AEDITCONTROLS) >= This.CellRowIndex
      IF ValType (AEDITCONTROLS [This.CellRowIndex]) == "A" .AND. HMG_LEN (AEDITCONTROLS [This.CellRowIndex]) >= 2
         IF ValType (AEDITCONTROLS [This.CellRowIndex] [1]) == "C" .AND. ValType (AEDITCONTROLS [This.CellRowIndex] [2]) == "B"
            IF HMG_UPPER (AEDITCONTROLS [This.CellRowIndex] [1]) == 'CUSTOM'
               EVAL (AEDITCONTROLS [This.CellRowIndex] [2])
               RETURN .T.
            ENDIF
         ENDIF
      ENDIF
   ENDIF
*/

   If _HMG_SYSDATA [ 232 ] == 'GRID_WHEN'
      MsgHMGError("GRID: Editing within a grid 'when' event procedure is not allowed. Program terminated" )
   EndIf
   If _HMG_SYSDATA [ 232 ] == 'GRID_VALID'
      MsgHMGError("GRID: Editing within a grid 'valid' event procedure is not allowed. Program terminated" )
   EndIf


   IF _HMG_SYSDATA [32] [idx] == .F.

      If This.CellRowIndex != LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [ idx ] )
         Return .f.
      EndIf

   ELSE

      If This.CellRowIndex != _HMG_SYSDATA [39] [ idx ]
         Return .f.
      EndIf

   ENDIF

   ri := This.CellRowIndex
   ci := This.CellColIndex


   if ri == 0 .or. ci == 0
      return  .f.
   endif


   IF ValType ( _HMG_SYSDATA [ 40 ] [ idx ] [ 10 ] ) == 'C'

      if IsDataGridDeleted ( idx , ri )
         return .f.
      endif

      cRecordSource   := _HMG_SYSDATA [ 40 ] [ idx ] [ 10 ]

      if &cRecordSource->(rddName()) == 'PGRDD'
         MsgHMGError("GRID: Modify PostGre RDD tables is not allowed. Program terminated" )
      endif

      if &cRecordSource->(rddName()) == 'SQLMIX'
         MsgHMGError("GRID: Modify SQLMIX RDD tables is not allowed. Program terminated" )
      endif

   endif

   GFN := _HMG_SYSDATA [ 27 ] [idx]   // FontName
   GFS := _HMG_SYSDATA [ 28 ] [idx]   // FontSize


//Problem3031

   IF _HMG_SYSDATA [ 40 ] [ idx ] [ 9 ] == .F.

      aTemp := this.item(ri)

      v := aTemp [ci]

   ELSE

      _HMG_SYSDATA [ 201 ] := ri   // QueryRowIndex

      _HMG_SYSDATA [ 202 ] := ci   // QueryColIndex

      _HMG_SYSDATA [ 320 ] := .T.

      IF ValType ( _HMG_SYSDATA [ 40 ] [ idx ] [ 10 ] ) == 'C'

         GetDataGridCellData ( idx , .t. )

      ELSE

         Eval( _HMG_SYSDATA [  6 ] [ idx ]  )

      ENDIF


      _HMG_SYSDATA [ 320 ] := .F.


      v := _HMG_SYSDATA [ 230 ]      // QueryData

   ENDIF

   CWH :=    _HMG_SYSDATA [40] [IDX] [6]   // ColumnWhen

//Problem3031

   IF ValType ( CWH ) = 'A'

      IF HMG_LEN ( CWH ) >= CI

         IF ValType ( CWH [CI] ) = 'B'

            _HMG_SYSDATA [ 318 ] := V

            _HMG_SYSDATA [ 232 ] := 'GRID_WHEN'

            WHEN := EVAL ( CWH [CI] )

            _HMG_SYSDATA [ 232 ] := ''

            IF WHEN = .F.
               _HMG_SYSDATA [ 256 ] := .F.
               RETURN .f.
            ENDIF

         ENDIF

      ENDIF

   ENDIF

   h := _HMG_SYSDATA [3] [IDX]   // ControlHandle

//   This.CellRow    --> _HMG_SYSDATA [ 197 ]
//   This.CellCol    --> _HMG_SYSDATA [ 198 ]
//   This.CellWidth  --> _HMG_SYSDATA [ 199 ]
//   This.CellHeight --> _HMG_SYSDATA [ 200 ]

   r := This.CellRow + GetWindowRow ( h ) - this.row - 1

   if _HMG_SYSDATA [ 23 ]  [idx] <> -1
      r := r - _HMG_SYSDATA [ 23 ] [idx]
   endif

   c := This.CellCol + GetWindowCol ( h ) - this.col + 2

   if _HMG_SYSDATA [ 24 ] [idx] <> -1
      c := c - _HMG_SYSDATA [ 24 ] [idx]
   endif


   AEDITCONTROLS := _HMG_SYSDATA [ 40 ] [ IDX ] [ 2 ]

   CVA :=    _HMG_SYSDATA [ 40 ] [ IDX ] [ 5 ]

   XRES := _HMG_PARSEGRIDCONTROLS ( AEDITCONTROLS , CI )

   AEC      := XRES [1]
   CTYPE      := HMG_UPPER( XRES [2] )
   CINPUTMASK   := XRES [3]
   CFORMAT      := XRES [4]
   AITEMS      := XRES [5]
   ARANGE      := XRES [6]
   DTYPE      := XRES [7]
   ALABELS      := XRES [8]
   ARETURNVALUES   := XRES [9]

   IF AEC = 'COMBOBOX'
      DH := 1
   ELSEIF AEC = 'CHECKBOX'
      DR := 3
      DH := -7
   ELSEIF AEC = 'EDITBOX'
      _HMG_SYSDATA [321] := .T.
   ENDIF

   _HMG_SYSDATA [ 109 ] := GetActiveWindow()


   // Grid Valid Event Procedure Values

   _HMG_SYSDATA [ 209 ] := idx

   *

   _HMG_SYSDATA [ 245 ] := .F.

   IF AEC = 'EDITBOX'

      DEFINE WINDOW _HMG_GRID_InplaceEdit AT 0 , 0 ;
         WIDTH   350    ;
         HEIGHT   350 + IF ( IsAppThemed() , 3 , 0 ) ;
         TITLE _HMG_SYSDATA [  7 ] [ idx ] [ ci ] ;
         MODAL ;
         NOSIZE ;
         SHORTTITLEBAR

   else

      DEFINE WINDOW _HMG_GRID_InplaceEdit AT r + DR , c + DC ;
         WIDTH This.CellWidth +  DW ;
         HEIGHT This.CellHeight + 6 + DH ;
         TITLE '' ;
         MODAL NOSIZE NOCAPTION

   endif

   ON KEY ESCAPE ACTION ( _HMG_SYSDATA [ 256 ] := .T., _HMG_SYSDATA [ 340 ] := 1, THISWINDOW.RELEASE )   // ADD June 2016


_HMG_GridInplaceEdit_ControlHandle := 0   //ADD

   IF AEC = 'EDITBOX'

      ON KEY CONTROL+W ACTION IF ( _ISWINDOWACTIVE ( '_HMG_GRID_InplaceEdit' ),;
								 ( _HMG_SYSDATA [ 256 ] := .F. ,;
                           _HMG_GRIDINPLACEEDITOK( IDX , CI , RI , AEC , ALABELS , CTYPE , CINPUTMASK , CFORMAT , CVA , aReturnValues, V ) ),;  // ADD V parameter, by Pablo on February, 2015
                                   NIL )


      define button OK
         row   298
         col   278 - IF ( IsAppThemed() , 1 , 0 )
         width   28
         height   28
         action   IF ( _ISWINDOWACTIVE ( '_HMG_GRID_InplaceEdit' ),;
                     ( _HMG_SYSDATA [ 256 ] := .F. , _HMG_GRIDINPLACEEDITOK( IDX , CI , RI , AEC , ALABELS , CTYPE , CINPUTMASK , CFORMAT , CVA , aReturnValues, V ) ),;  // ADD V parameter, by Pablo on February, 2015
                       NIL )
         picture   'GRID_MSAV'
         tooltip _hmg_sysdata [ 133 ] [ 12 ] + ' [Ctrl+W]'
      end button

      define button CANCEL
         row   298
         col   312 - IF ( IsAppThemed() , 1 , 0 )
         width   28
         height   28
         action   ( _HMG_SYSDATA [ 256 ] := .T. , THISWINDOW.RELEASE )
         picture   'GRID_MCAN'
         tooltip _hmg_sysdata [ 133 ] [ 13 ] + ' [Esc]'
      end button


   ELSE

      ON KEY RETURN ACTION IIF ( _ISWINDOWACTIVE ( '_HMG_GRID_InplaceEdit' ),;
                               ( _HMG_SYSDATA [ 256 ] := .F. , _HMG_GRIDINPLACEEDITOK( IDX , CI , RI , AEC , ALABELS , CTYPE , CINPUTMASK , CFORMAT , CVA , aReturnValues, V ) ) ,;  // ADD V parameter, by Pablo on February, 2015
                                 NIL )

      ON KEY TAB    ACTION ( _HMG_SYSDATA [ 285 ] := .T. , InsertReturn() )

   ENDIF


   ON KEY F2 ACTION IF ( _ISWINDOWACTIVE ( '_HMG_GRID_InplaceEdit' ),;
                       ( _HMG_SYSDATA [ 256 ] := .F. , _HMG_GRIDINPLACEEDITOK( IDX , CI , RI , AEC , ALABELS , CTYPE , CINPUTMASK , CFORMAT , CVA , aReturnValues, V ) ) ,;  // ADD V parameter, by Pablo on February, 2015
                         NIL )


   IF AEC == 'TEXTBOX' //*****************************************

      IF _HMG_SYSDATA [321] == .F.

         DEFINE TEXTBOX T

      ELSE

         DEFINE EDITBOX T
               HSCROLLBAR      .F.
               VSCROLLBAR      .F.

      ENDIF

      FONTNAME   GFN
      FONTSIZE   GFS

      ROW   0
      COL   0
      WIDTH    This.CellWidth      + nWx
      HEIGHT   This.CellHeight + 6   + nHx

      IF CTYPE == 'NUMERIC'
         NUMERIC .T.
	  ELSEIF CTYPE == 'PASSWORD'  // By Pablo on February, 2015
         PASSWORD .T.
      ELSEIF CTYPE == 'DATE'
         DATE .T.
      ENDIF

      VALUE   v

      IF ! EMPTY ( CINPUTMASK )
         INPUTMASK CINPUTMASK
      ENDIF

      IF ! EMPTY ( CFORMAT )
         FORMAT CFORMAT
      ENDIF

      IF _HMG_SYSDATA [321] == .F.
         END TEXTBOX
      ELSE
         END EDITBOX
      ENDIF

_HMG_GridInplaceEdit_ControlHandle := GetControlHandle ("t","_HMG_GRID_InplaceEdit")   //ADD

   ELSEIF AEC == 'EDITBOX' //**********************************************

	  If ":" $ V .and. File(V)                        // By Pablo on February, 2015
          cTextFile:=hb_MemoRead(V)
      ElseIf "\" $ V .and. File(GetCurrentFolder()+V)
         cTextFile:=hb_MemoRead(GetCurrentFolder()+V)
	  ElseIf HMG_LOWER(V)=="<memo>" .or. IsDataGridMemo ( Idx, ci )
	     cTextFile:=GetDataGridCellData ( idx , .t. )
      Else
         cTextFile:=V
      Endif

      DEFINE EDITBOX T
         HSCROLLBAR .T.
         VSCROLLBAR .T.
         FONTNAME   GFN
         FONTSIZE   GFS
         ROW        2
         COL        2
         WIDTH      340
         HEIGHT     292
         VALUE      cTextFile  // By Pablo on February, 2015
      END EDITBOX

_HMG_GridInplaceEdit_ControlHandle := GetControlHandle ("t","_HMG_GRID_InplaceEdit")   //ADD


   ELSEIF AEC == 'DATEPICKER' //*******************************************

      DEFINE DATEPICKER D
         FONTNAME   GFN
         FONTSIZE   GFS
         ROW      0
         COL      0
         WIDTH      This.CellWidth
         HEIGHT      This.CellHeight + 6
         VALUE      V
         SHOWNONE   .T.

         IF DTYPE = 'DROPDOWN'
            UPDOWN .F.
         ELSEIF DTYPE = 'UPDOWN'
            UPDOWN .T.
         ENDIF

      END DATEPICKER

_HMG_GridInplaceEdit_ControlHandle := GetControlHandle ("D","_HMG_GRID_InplaceEdit")   //ADD


   ELSEIF AEC == 'TIMEPICKER' //*******************************************   ( Dr. Claudio Soto, April 2013 )

      DEFINE TIMEPICKER TPICK
         FONTNAME   GFN
         FONTSIZE   GFS
         ROW        0
         COL        0
         WIDTH      This.CellWidth
         HEIGHT     This.CellHeight + 6
         VALUE      V
         SHOWNONE   .F.
         FORMAT     CFORMAT
      END TIMEPICKER

_HMG_GridInplaceEdit_ControlHandle := GetControlHandle ("tpick","_HMG_GRID_InplaceEdit")   //ADD


   ELSEIF AEC == 'COMBOBOX' //********************************************

      DEFINE COMBOBOX C
         FONTNAME   GFN
         FONTSIZE   GFS
         ROW   0
         COL   0
         WIDTH    This.CellWidth
         ITEMS   AITEMS

         IF HMG_LEN ( ARETURNVALUES ) == 0
            VALUE   v
         ELSE

            For z := 1 To HMG_LEN ( aReturnValues )

               if v = aReturnValues [z]

                  xValue := z
                  exit

               endif

            Next z

            if xValue == 0
               xValue := 1
            endif

            VALUE xValue

         ENDIF

         ONDROPDOWN   _hmg_grid_disablekeys()
         ONCLOSEUP   _hmg_grid_enablekeys( IDX , CI , RI , AEC , ALABELS , CTYPE , CINPUTMASK , CFORMAT , CVA , aReturnValues )

      END COMBOBOX

_HMG_GridInplaceEdit_ControlHandle := GetControlHandle ("C","_HMG_GRID_InplaceEdit")   //ADD


   ELSEIF AEC == 'SPINNER' //*********************************************

      DEFINE SPINNER S
         FONTNAME   GFN
         FONTSIZE   GFS
         ROW        0
         COL        0
         WIDTH      This.CellWidth
         HEIGHT     This.CellHeight + 6
         VALUE      V
         RANGEMIN   ARANGE [1]
         RANGEMAX   ARANGE [2]
         INCREMENT  ARANGE [3]  // By Pablo on February, 2015
      END SPINNER

_HMG_GridInplaceEdit_ControlHandle := GetControlHandle ("S","_HMG_GRID_InplaceEdit")


   ELSEIF AEC == 'CHECKBOX' //********************************************

      DEFINE CHECKBOX C
         FONTNAME   GFN
         FONTSIZE   GFS
         ROW      0
         COL      0
         WIDTH       This.CellWidth + DW
         HEIGHT      This.CellHeight + 6 + DH
         VALUE      V

         IF V == .T.
            CAPTION ALABELS [1]
         ELSEIF V == .F.
            CAPTION ALABELS [2]
         ENDIF

         BACKCOLOR WHITE
         ONCHANGE IF ( THIS.VALUE == .T. , THIS.CAPTION := ALABELS [1] , THIS.CAPTION := ALABELS [2] )
      END CHECKBOX

_HMG_GridInplaceEdit_ControlHandle := GetControlHandle ("C","_HMG_GRID_InplaceEdit")   //ADD


   ENDIF

   END WINDOW

   IF ValType( _HMG_GridInplaceEdit_ControlHandle ) == "A"
      _HMG_GridInplaceEdit_ControlHandle := _HMG_GridInplaceEdit_ControlHandle [1]
   ENDIF

   _HMG_GridInplaceEdit_StageEvent := 1   // PreEvent
   _HMG_OnInplaceEditEvent( IDX )

   _HMG_GridInplaceEdit_StageEvent := 2   // Into Event
   cProc := "_HMG_OnInplaceEditEvent( " + hb_ntos( IDX ) + " ) "
   nIndex := EventCreate( cProc, NIL, NIL )   // by Dr. Claudio Soto, April 2016

   IF AEC = 'EDITBOX'

      SETFOCUS ( GetControlHandle( 't' , '_HMG_GRID_InplaceEdit' ) )

      CENTER WINDOW _HMG_GRID_InplaceEdit

   ENDIF

   ACTIVATE WINDOW _HMG_GRID_InplaceEdit

// MsgDebug ("InplaceEdit END")

 IF nIndex > 0   // by Dr. Claudio Soto, April 2016
   EventRemove ( nIndex )
 ENDIF

 _HMG_GridInplaceEdit_StageEvent := 3   // PostEvent
 _HMG_OnInplaceEditEvent( IDX )

_HMG_GridInplaceEdit_StageEvent    := 0   //ADD
_HMG_GridInplaceEdit_ControlHandle := 0   //ADD
_HMG_GridInplaceEdit_GridIndex     := 0   //ADD

   _HMG_SYSDATA [ 109 ] := 0

   SETFOCUS ( _HMG_SYSDATA [3] [IDX] )

   _HMG_SYSDATA [321] := .F.

RETURN .t.


FUNCTION _HMG_OnInplaceEditEvent( nIndex )
LOCAL Ret := NIL
   IF _HMG_GridInplaceEdit_ControlHandle <> 0 .AND. ValType( _HMG_SYSDATA [ 40 ] [ nIndex ] [ 47 ] ) == "B"
      Ret := Eval( _HMG_SYSDATA [ 40 ] [ nIndex ] [ 47 ] )
   ENDIF
RETURN Ret


procedure _hmg_grid_disablekeys

	RELEASE KEY RETURN OF _HMG_GRID_InplaceEdit
	RELEASE KEY ESCAPE OF _HMG_GRID_InplaceEdit

return


procedure _hmg_grid_enablekeys( IDX , CI , RI , AEC , ALABELS , CTYPE , CINPUTMASK , CFORMAT , CVA , aReturnValues )

	ON KEY RETURN OF _HMG_GRID_InplaceEdit ACTION IF ( _ISWINDOWACTIVE ( '_HMG_GRID_InplaceEdit' ),;
                                                    ( _HMG_SYSDATA [ 256 ] := .F. , _HMG_GRIDINPLACEEDITOK ( IDX , CI , RI , AEC , ALABELS , CTYPE , CINPUTMASK , CFORMAT , CVA , aReturnValues ) ),;
                                                      NIL )

	ON KEY ESCAPE OF _HMG_GRID_InplaceEdit ACTION ( _HMG_SYSDATA [ 256 ] := .T. , _HMG_GRID_InplaceEdit.RELEASE )

return


*-----------------------------------------------------------------------------*
FUNCTION _HMG_PARSEGRIDCONTROLS ( AEDITCONTROLS , CI )
*-----------------------------------------------------------------------------*
LOCAL AEC := 'TEXTBOX'
LOCAL AITEMS := {}
LOCAL ARANGE := {}
LOCAL DTYPE := 'D'
LOCAL ALABELS := { '.T.' ,'.F.' }
LOCAL CTYPE := 'CHARACTER'
LOCAL CINPUTMASK := ''
LOCAL CFORMAT := ''
LOCAL ARET
LOCAL ARETURNVALUES := {}

	IF ValType ( AEDITCONTROLS ) = 'A'

		IF HMG_LEN ( AEDITCONTROLS ) >= ci

			IF ValType ( AEDITCONTROLS [CI] ) = 'A'

				IF HMG_LEN ( AEDITCONTROLS [CI] ) >= 1

					AEC := AEDITCONTROLS [CI] [1]



					IF HMG_LEN ( AEDITCONTROLS [CI] ) >= 2 ;
						.AND. ;
						AEC == 'TEXTBOX'

						IF ValType ( AEDITCONTROLS [CI] [2] ) = 'C'
							CTYPE := HMG_UPPER( AEDITCONTROLS [CI] [2] )
						ENDIF

						IF HMG_LEN ( AEDITCONTROLS [CI] ) >= 3
							IF ValType ( AEDITCONTROLS [CI] [3] ) = 'C'
								CINPUTMASK := AEDITCONTROLS [CI] [3]
							ENDIF
						ENDIF

						IF HMG_LEN ( AEDITCONTROLS [CI] ) >= 4
							IF ValType ( AEDITCONTROLS [CI] [4] ) = 'C'
								CFORMAT := AEDITCONTROLS [CI] [4]
							ENDIF
						ENDIF

					ENDIF

					IF HMG_LEN ( AEDITCONTROLS [CI] ) >= 2 ;
						.AND. ;
						AEC == 'COMBOBOX'

						IF ValType ( AEDITCONTROLS [CI] [2] ) = 'A'
							AITEMS := AEDITCONTROLS [CI] [2]
						ENDIF

						IF HMG_LEN ( AEDITCONTROLS [CI] ) == 3
							IF ValType ( AEDITCONTROLS [CI] [3] ) = 'A'
								ARETURNVALUES := AEDITCONTROLS [CI] [3]
							ENDIF
						ENDIF

					ENDIF

               IF HMG_LEN ( AEDITCONTROLS [CI] ) >= 3 .AND. AEC == 'SPINNER'

                  IF ValType ( AEDITCONTROLS [CI] [2] ) = 'N' .AND. ValType ( AEDITCONTROLS [CI] [3] ) = 'N'
                     ARANGE := { AEDITCONTROLS [CI] [2] , AEDITCONTROLS [CI] [3] , 1 }
                  ENDIF
                  IF HMG_LEN (AEDITCONTROLS [CI]) == 4 .AND. ValType ( AEDITCONTROLS [CI] [4] ) = 'N'
                     ARANGE [3] := AEDITCONTROLS [CI] [4]
                  ENDIF

               ENDIF

					IF HMG_LEN ( AEDITCONTROLS [CI] ) >= 2 ;
						.AND. ;
						AEC == 'DATEPICKER'
						IF 	ValType ( AEDITCONTROLS [CI] [2] ) = 'C'
							DTYPE := AEDITCONTROLS [CI] [2]
						ENDIF
					ENDIF

					IF HMG_LEN ( AEDITCONTROLS [CI] ) >= 2 ;
						.AND. ;
						AEC == 'TIMEPICKER'
						IF ValType ( AEDITCONTROLS [CI] [2] ) = 'C'
							CFORMAT := AEDITCONTROLS [CI] [2]
						ENDIF
					ENDIF


					IF HMG_LEN ( AEDITCONTROLS [CI] ) == 3   .AND.   AEC == 'CHECKBOX'
// unused						DW := -4
// unused						DH := -7
// unused						DR := 3
// unused						DC := 2
						IF ValType ( AEDITCONTROLS [CI] [2] ) = 'C'   .AND.   ValType ( AEDITCONTROLS [CI] [3] ) = 'C'
							ALABELS := { AEDITCONTROLS [CI] [2] , AEDITCONTROLS [CI] [3] }
						ENDIF
					ENDIF

				ENDIF

			ENDIF

		ENDIF

	ENDIF

	ARET := { AEC , CTYPE , CINPUTMASK , CFORMAT , AITEMS , ARANGE , DTYPE , ALABELS , ARETURNVALUES }

RETURN ( ARET )

*-----------------------------------------------------------------------------*
PROCEDURE _HMG_GRIDINPLACEEDITOK( IDX , CI , RI , AEC , ALABELS , CTYPE , CINPUTMASK , CFORMAT , CVA , aReturnValues, cValCell ) // ADD cValCell parameter, by Pablo on February, 2015
*-----------------------------------------------------------------------------*
LOCAL VALID, aTemp
LOCAL Z
Local cTextFile:="" /* By Pablo on February, 2015 */

ALABELS    := NIL   // ADD
CTYPE      := NIL   // ADD
CINPUTMASK := NIL   // ADD
CFORMAT    := NIL   // ADD


   HMG_GetLastCharacterEx()   // Clean key char buffer

	IF ValType ( CVA ) = 'A'

		IF HMG_LEN ( CVA ) >= CI

			IF ValType ( CVA [CI] ) = 'B'

				IF	AEC == 'TEXTBOX' .or. AEC == 'EDITBOX'
					_HMG_SYSDATA [ 318 ] := GetProperty ( "_HMG_GRID_InplaceEdit","t","value")
				ELSEIF	AEC == 'DATEPICKER'
					_HMG_SYSDATA [ 318 ] := _HMG_GRID_InplaceEdit.d.value

            ELSEIF   AEC == 'TIMEPICKER'
               _HMG_SYSDATA [ 318 ] := _HMG_GRID_InplaceEdit.tpick.value

				ELSEIF	AEC == 'COMBOBOX'

					IF HMG_LEN ( ARETURNVALUES ) == 0

						_HMG_SYSDATA [ 318 ] := _HMG_GRID_InplaceEdit.c.value

					ELSE

						_HMG_SYSDATA [ 318 ] := aReturnValues [_HMG_GRID_InplaceEdit.c.value ]

					ENDIF

				ELSEIF	AEC == 'SPINNER'
					_HMG_SYSDATA [ 318 ] := _HMG_GRID_InplaceEdit.s.value
				ELSEIF	AEC == 'CHECKBOX'
					_HMG_SYSDATA [ 318 ] := _HMG_GRID_InplaceEdit.c.value
				ENDIF

				_HMG_SYSDATA [ 232 ] := 'GRID_VALID'

				_DoControlEventProcedure ( CVA [CI] , _HMG_SYSDATA [ 209 ] )

				VALID := _HMG_SYSDATA [ 293 ]

				_HMG_SYSDATA [ 232 ] := ''

				IF VALID = .F.

					MSGEXCLAMATION ( _HMG_SYSDATA [ 136 ][11] )
					RETURN

				ENDIF

				redrawwindow( _HMG_SYSDATA [3] [IDX] )

			ENDIF

		ENDIF

	ENDIF

	IF _HMG_SYSDATA [ 40 ] [ idx ] [ 9 ] == .F.

		aTemp := _GetItem (  ,  , ri , idx )

	ELSE

		aTemp := array ( HMG_LEN( _HMG_SYSDATA [  7 ] [ idx ] ) )

		aTemp := aFill ( aTemp , '' )

		FOR Z := 1 TO HMG_LEN ( _HMG_SYSDATA [  7 ] [ idx ] )

			_HMG_SYSDATA [ 201 ] := ri	// QueryRowIndex

			_HMG_SYSDATA [ 202 ] := z	// QueryColIndex

			IF ValType ( _HMG_SYSDATA [ 40 ] [ idx ] [ 10 ] ) == 'C'

				GetDataGridCellData ( idx , .t. )

			ELSE

				Eval( _HMG_SYSDATA [  6 ] [ idx ]  )

			ENDIF

			aTemp [z] := _HMG_SYSDATA [ 230 ]	// QueryData

		NEXT Z

	ENDIF

	IF	AEC == 'TEXTBOX' .OR. AEC = 'EDITBOX'
		aTemp [ci] := GetProperty ( "_HMG_GRID_InplaceEdit","t","value")
	ELSEIF	AEC == 'DATEPICKER'
		aTemp [ci] := _HMG_GRID_InplaceEdit.d.value

   ELSEIF   AEC == 'TIMEPICKER'
      aTemp [ci] := _HMG_GRID_InplaceEdit.tpick.value

   ELSEIF	AEC == 'COMBOBOX'

		IF HMG_LEN ( ARETURNVALUES ) == 0

			aTemp [ci] := _HMG_GRID_InplaceEdit.c.value

		ELSE

			aTemp [ci] := aReturnValues [_HMG_GRID_InplaceEdit.c.value ]

		ENDIF

	ELSEIF	AEC == 'SPINNER'
		aTemp [ci] := _HMG_GRID_InplaceEdit.s.value
	ELSEIF	AEC == 'CHECKBOX'
		aTemp [ci] := _HMG_GRID_InplaceEdit.c.value
	ENDIF

   IF _HMG_SYSDATA [ 40 ] [ idx ] [ 9 ] == .F.

      If AEC == 'EDITBOX'  // By Pablo on February, 2015
         If ":" $ cValCell .and. File(cValCell)
            cTextFile:=cValCell
         ElseIf "\" $ cValCell .and. File(GetCurrentFolder()+cValCell)
            cTextFile:=GetCurrentFolder()+cValCell
         ElseIf HMG_LOWER(cValCell)=="<memo>" .or. IsDataGridMemo ( Idx, ci )
            cTextFile:=GetDataGridCellData ( idx , .t. )
         Else
            cTextFile:=""
         Endif
      Endif
      If Empty(cTextFile)
         _SetItem ( , , ri , aTemp , idx )
      Else
          hb_MemoWrit(cTextFile,aTemp[ci])   // By Pablo on February, 2015
       Endif

   ENDIF

	IF ValType ( _HMG_SYSDATA [ 40 ] [ idx ] [ 10 ] ) == 'C'

		_HMG_SYSDATA [ 196 ] := ci

		SaveDataGridField ( idx , aTemp [ci] )

	endif

	_HMG_GRID_InplaceEdit.RELEASE

RETURN



*-----------------------------------------------------------------------------*
Procedure _HMG_SetGridCellEditValue ( arg )
*-----------------------------------------------------------------------------*

	IF	ValType ( arg ) == 'C'

		If _IsControlDefined ( 't' , "_HMG_GRID_InplaceEdit")

			SetProperty ( "_HMG_GRID_InplaceEdit" , "t" , "value" , arg )

		EndIf

	ELSEIF	ValType ( arg ) == 'D'

		If _IsControlDefined ( 't' , "_HMG_GRID_InplaceEdit")

			SetProperty ( "_HMG_GRID_InplaceEdit" , "t" , "value" , arg )

		ElseIf _IsControlDefined ( 'd' , "_HMG_GRID_InplaceEdit")

			SetProperty ( "_HMG_GRID_InplaceEdit" , "d" , "value" , arg )

		EndIf

	ELSEIF	ValType ( arg ) == 'N'

		If _IsControlDefined ( 'c' , "_HMG_GRID_InplaceEdit")

			SetProperty ( "_HMG_GRID_InplaceEdit" , "c" , "value" , arg )

		ElseIf _IsControlDefined ( 's' , "_HMG_GRID_InplaceEdit")

			SetProperty ( "_HMG_GRID_InplaceEdit" , "s" , "value" , arg )

		ElseIf _IsControlDefined ( 't' , "_HMG_GRID_InplaceEdit")

			SetProperty ( "_HMG_GRID_InplaceEdit" , "t" , "value" , arg )

		EndIf

	ELSEIF	ValType ( arg ) == 'L'

		SetProperty ( "_HMG_GRID_InplaceEdit" , "c" , "value" , arg )

	ENDIF

return


Function GetControlSafeRow (i)
Return IF (ValType(_HMG_SYSDATA [18] [i]) == "N", _HMG_SYSDATA [18] [i], 0)   // for SplitBox

Function GetControlSafeCol (i)
Return IF (ValType(_HMG_SYSDATA [19] [i]) == "N", _HMG_SYSDATA [19] [i], 0)   // for SplitBox


*-----------------------------------------------------------------------------*
PROCEDURE _HMG_GRIDINPLACEKBDEDIT(i)
*-----------------------------------------------------------------------------*
LOCAL TmpRow
LOCAL XS
LOCAL XD
LOCAL R
LOCAL IPE_MAXCOL


	IPE_MAXCOL := HMG_LEN ( _HMG_SYSDATA [ 33 ] [i] )

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

		xs :=	( ( GetControlSafeCol(i) + r [2] ) +( r[3] ))  -  ( GetControlSafeCol(i) + _HMG_SYSDATA [ 20 ] [i] )

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

		_HMG_SYSDATA [ 197 ] := GetControlSafeRow(i) + r [1]
		_HMG_SYSDATA [ 198 ] := GetControlSafeCol(i) + r [2]
		_HMG_SYSDATA [ 199 ] := r[3]
		_HMG_SYSDATA [ 200 ] := r[4]

		*
		_HMG_SYSDATA [ 194 ] := ascan ( _HMG_SYSDATA [ 67  ] , _HMG_SYSDATA [4][i] )
		_HMG_SYSDATA [ 231 ] := 'C'
		_HMG_SYSDATA [ 203 ] := i
		_HMG_SYSDATA [ 316 ] :=  _HMG_SYSDATA [  66 ] [ _HMG_SYSDATA [ 194 ] ]
		_HMG_SYSDATA [ 317 ] :=  _HMG_SYSDATA [2] [_HMG_SYSDATA [ 203 ]]
		*

		_HMG_GRIDINPLACEEDIT(I)

		_HMG_SYSDATA [ 203 ] := 0
		_HMG_SYSDATA [ 231 ] := ''

		_HMG_SYSDATA [ 195 ] := 0
		_HMG_SYSDATA [ 196 ] := 0
		_HMG_SYSDATA [ 197 ] := 0
		_HMG_SYSDATA [ 198 ] := 0
		_HMG_SYSDATA [ 199 ] := 0
		_HMG_SYSDATA [ 200 ] := 0

		*
		_HMG_SYSDATA [ 194 ] := 0
		_HMG_SYSDATA [ 232 ] := ''
		_HMG_SYSDATA [ 316 ] :=  ''
		_HMG_SYSDATA [ 317 ] := ''
		*

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

RETURN


*------------------------------------------------------------------------------*
Function GetNumFromCellText ( Text )
*------------------------------------------------------------------------------*
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

Return Val(s)


*------------------------------------------------------------------------------*
Function GETNumFromCellTextSP(Text)
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

Return Val(s)

/*
*------------------------------------------------------------------------------*
FUNCTION _HMG_GETGRIDCELLVALUE ( CONTROLNAME , PARENTFORM , ROW , COL )
*------------------------------------------------------------------------------*
LOCAL A
LOCAL V

	A := _GetItem ( CONTROLNAME , PARENTFORM , ROW  )

	V := A [ COL ]

RETURN V

*------------------------------------------------------------------------------*
PROCEDURE _HMG_SETGRIDCELLVALUE ( CONTROLNAME , PARENTFORM , ROW , COL , CELLVALUE )
*------------------------------------------------------------------------------*
LOCAL A

	A := _GetItem ( CONTROLNAME , PARENTFORM , ROW  )

	A [ COL ] := CELLVALUE

	_SetItem ( CONTROLNAME , PARENTFORM , ROW , A )

RETURN
*/



*-----------------------------------------------------------------------------*
PROCEDURE _HMG_GRIDINPLACEKBDEDIT_2(i)
*-----------------------------------------------------------------------------*
LOCAL R
LOCAL S
Local aColumnWhen := _HMG_SYSDATA [ 40 ] [ i ] [  6 ]
Local j
Local nWhenRow
Local xTmpCellValue
Local aTemp
Local nStart, nEnd, lResult

//Problem3031

   _HMG_GRID_KBDSCROLL(I)

   If _HMG_SYSDATA [ 15 ] [i] == 1   // nCol cellnavigation
                                                        // nRow cellnavigation
      r := LISTVIEW_GETITEMRECT ( _HMG_SYSDATA [3] [i]  , _HMG_SYSDATA [ 39 ] [i] - 1 )
   Else
                                                        //   nRow cellnavigation          nCol cellnavigation
      r := LISTVIEW_GETSUBITEMRECT ( _HMG_SYSDATA [3] [i]  , _HMG_SYSDATA [ 39 ] [i]- 1 , _HMG_SYSDATA [ 15 ] [i] - 1 )
   EndIf


// MsgDebug( _HMG_SYSDATA [ 195 ] , _HMG_SYSDATA [ 39 ] [i], _HMG_SYSDATA [ 341 ] )

IF _HMG_SYSDATA [ 195 ] == 0 .AND. _HMG_SYSDATA [ 39 ] [i] > 0   // ADD, march 2017
   _HMG_SYSDATA [ 195 ] := _HMG_SYSDATA [ 39 ] [i]
ENDIF


   nWhenRow := _HMG_SYSDATA [ 195 ]   // This.CellRowIndex

   _HMG_SYSDATA [ 197 ] := GetControlSafeRow(i) + r [1]   // This.CellRow
   _HMG_SYSDATA [ 198 ] := GetControlSafeCol(i) + r [2]   // This.CellCol
   _HMG_SYSDATA [ 199 ] := r [3]                   // This.CellWidth
   _HMG_SYSDATA [ 200 ] := r [4]                   // This.CellHeight


   *
   _HMG_SYSDATA [ 194 ] := ascan ( _HMG_SYSDATA [ 67  ] , _HMG_SYSDATA [4][i] )
   _HMG_SYSDATA [ 231 ] := 'C'
   _HMG_SYSDATA [ 203 ] := i
   _HMG_SYSDATA [ 316 ] :=  _HMG_SYSDATA [  66 ] [ _HMG_SYSDATA [ 194 ] ]
   _HMG_SYSDATA [ 317 ] :=  _HMG_SYSDATA [2] [_HMG_SYSDATA [ 203 ]]
   *

   S := _HMG_GRIDINPLACEEDIT(I)

   IF _HMG_SYSDATA [ 32 ] [I] .AND. _HMG_SYSDATA [ 245 ] == .F.

      IF   _HMG_SYSDATA [ 15 ] [I] < HMG_LEN(_HMG_SYSDATA [  7 ] [I])

         IF _HMG_SYSDATA [ 40 ] [ I ] [ 32 ] == 0

            IF S

               IF .NOT. _HMG_SYSDATA [ 285 ]
*!!!!
                  IF _HMG_SYSDATA [ 284 ]
                     IF .NOT. _HMG_SYSDATA [ 256 ]
                        InsertDown()
                        InsertReturn()
                     ENDIF
                  ELSE
                     _HMG_SYSDATA [ 15 ] [I]++
                  ENDIF

               ELSE

                  _HMG_SYSDATA [ 15 ] [I]++
                  _HMG_SYSDATA [ 285 ] := .F.
                  InsertReturn()

               ENDIF


               If ValType ( aColumnWhen ) == 'A'

                  nStart := _HMG_SYSDATA [ 15 ] [I]

                  nEnd := HMG_LEN ( aColumnWhen )

                  For j := nStart To nEnd

                     If ValType ( aColumnWhen [j] ) == 'B'

*******************************************************************************************************************************
                        IF _HMG_SYSDATA [ 40 ] [ i ] [ 9 ] == .F.
                           aTemp := this.item( nWhenRow )
                           xTmpCellValue := aTemp [j]
                        ELSE
                           _HMG_SYSDATA [ 201 ] := nWhenRow // QueryRowIndex
                           _HMG_SYSDATA [ 202 ] := j   // QueryColIndex
                           _HMG_SYSDATA [ 320 ] := .T.
                           IF ValType ( _HMG_SYSDATA [ 40 ] [ i ] [ 10 ] ) == 'C'
                              GetDataGridCellData ( i , .t. )
                           ELSE
                              Eval( _HMG_SYSDATA [  6 ] [ i ]  )
                           ENDIF
                           _HMG_SYSDATA [ 320 ] := .F.
                           xTmpCellValue := _HMG_SYSDATA [ 230 ]
                        ENDIF
********************************************************************************************************************************

                        _HMG_SYSDATA [ 318 ] := xTmpCellValue

                        _HMG_SYSDATA [ 232 ] := 'GRID_WHEN'

                        lResult := Eval ( aColumnWhen [j] )

                        _HMG_SYSDATA [ 232 ] := ''

                        If lResult == .F.

                           _HMG_SYSDATA [ 15 ] [I]++

                        Else

                           Exit

                        EndIf

                     EndIf

                  Next j

                  IF .NOT. _HMG_SYSDATA [ 284 ]

                     IF _HMG_SYSDATA [ 15 ] [I] > nEnd

                        _HMG_SYSDATA [ 15 ] [I] := nStart - 1

                     ENDIF

                  ENDIF

               EndIf

            ENDIF

         ENDIF

      ELSEIF _HMG_SYSDATA [ 15 ] [I] == HMG_LEN(_HMG_SYSDATA [  7 ] [I])

         IF _HMG_SYSDATA [ 40 ] [ I ] [ 32 ] == 0

            IF S

               IF .NOT. _HMG_SYSDATA [ 285 ]

                  IF .NOT. _HMG_SYSDATA [ 284 ]
                     _HMG_SYSDATA [ 15 ] [I] := 1
                  ELSE
                     IF .NOT. _HMG_SYSDATA [ 256 ]
                        InsertDown()
                        InsertReturn()
                     ENDIF
                  ENDIF

               ELSE

                  _HMG_SYSDATA [ 15 ] [I] := 1
                  _HMG_SYSDATA [ 285 ] := .F.

               ENDIF

            ENDIF

         ENDIF

      ENDIF

      LISTVIEW_REDRAWITEMS( _HMG_SYSDATA[3][I] , _HMG_SYSDATA[39][I]-1 , _HMG_SYSDATA[39][I]-1 )
      _DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )

   ENDIF

   _HMG_SYSDATA [ 203 ] := 0
   _HMG_SYSDATA [ 231 ] := ''

   _HMG_SYSDATA [ 195 ] := 0
   _HMG_SYSDATA [ 196 ] := 0
   _HMG_SYSDATA [ 197 ] := 0
   _HMG_SYSDATA [ 198 ] := 0
   _HMG_SYSDATA [ 199 ] := 0
   _HMG_SYSDATA [ 200 ] := 0

   *
   _HMG_SYSDATA [ 194 ] := 0
   _HMG_SYSDATA [ 232 ] := ''
   _HMG_SYSDATA [ 316 ] :=  ''
   _HMG_SYSDATA [ 317 ] := ''
   *

RETURN

*-----------------------------------------------------------------------------*
PROCEDURE _HMG_GRID_KBDSCROLL(I)
*-----------------------------------------------------------------------------*
LOCAL R ,XS , XD

   _HMG_SYSDATA [ 195 ] := _HMG_SYSDATA [ 39 ] [i]
   _HMG_SYSDATA [ 196 ] := _HMG_SYSDATA [ 15 ] [i]

   If _HMG_SYSDATA [ 15 ] [i] == 1
      r := LISTVIEW_GETITEMRECT ( _HMG_SYSDATA [3] [i]  , _HMG_SYSDATA [ 39 ] [i] - 1 )
   Else
      r := LISTVIEW_GETSUBITEMRECT ( _HMG_SYSDATA [3] [i]  , _HMG_SYSDATA [ 39 ] [i] - 1 , _HMG_SYSDATA [ 15 ] [i] - 1 )
   EndIf

   xs := ( ( GetControlSafeCol(i) + r [2] ) +( r[3] ))  -  ( GetControlSafeCol(i) + _HMG_SYSDATA [ 20 ] [i] )
   xd := 20

   If xs > -xd
      ListView_Scroll( _HMG_SYSDATA [3] [i], xs + xd, 0 )
   Else
      If r [2] < 0
         ListView_Scroll( _HMG_SYSDATA [3] [i], r[2], 0 )
      EndIf
   endIf

RETURN



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   VIRTUAL GRID DATABASE FUNCTIONS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define _IS_DBFILTER_ON_      ( ! Empty( &cRecordSource->( dbFilter() ) ) )
#define _IS_SETDELETED_ON_    ( Set ( _SET_DELETED ) )
#define _IS_ORDFOR_ON_        ( ! Empty( &cRecordSource->( ordFor() ) ) )

#define _IS_ACTIVE_FILTER_    ( _IS_DBFILTER_ON_ .OR. _IS_SETDELETED_ON_ .OR. _IS_ORDFOR_ON_ )


**************************************************
Function GridRecCount( index )
**************************************************
Local nCount := 0
Local nOldRecno
Local cRecordSource := _HMG_SYSDATA [ 40 ] [ index ] [ 10 ]
   IF _IS_ACTIVE_FILTER_
      nOldRecno := &cRecordSource->( RecNo() )
      &cRecordSource->( dbGoTop() )
      &cRecordSource->( dbEval( {|| nCount++ } ) )   // Dbeval  --> not ignore set delete, preceess only not deleleted records
      &cRecordSource->( dbGoto( nOldRecno ) )
   ELSE
      nCount := &cRecordSource->( ordKeyCount() )    // OrdKeyCount --> ignore set delete, proceess deleted and non deleted records
   ENDIF
Return nCount


***********************************************
Function GetGridFieldName ( index , nField )
***********************************************
Local cRecordSource   := _HMG_SYSDATA [ 40 ] [ index ] [ 10 ]
Local aColumnFields   := _HMG_SYSDATA [ 40 ] [ index ] [ 11 ]
Local aColumnClassMap := _HMG_SYSDATA [ 40 ] [ index ] [ 30 ]
Local cFieldName
   IF aColumnClassMap [ nField ] == 'F'
      cFieldName := cRecordSource + '->' + aColumnFields[ nField ]   //  Field in this Area
   ELSE
      cFieldName := aColumnFields[ nField ]   // Field in other Area
   ENDIF
Return cFieldName


*********************************************
Function IsDataGridMemo ( index , nField )
*********************************************
Local cFieldName := GetGridFieldName ( index , nField )
   IF TYPE ( cFieldName ) == 'M'
      Return .T.
   ENDIF
Return .F.


*************************************************
Function IsDataGridDeleted ( index , nRecno )
*************************************************
Local lRet := .F.
Local cRecordSource := _HMG_SYSDATA [ 40 ] [ index ] [ 10 ]
Local nOldRecno := &cRecordSource->( RecNo() )
   &cRecordSource->( ordKeyGoto( nRecno ) )
   if &cRecordSource->( Deleted() )
      lRet := .T.
   endif
   &cRecordSource->( dbGoto( nOldRecno ) )
Return lRet


************************************************
function SetDataGridRecNo ( index , nRecNo  )
************************************************
Local cRecordSource
Local aValue
Local nLogicalPos
Local lOk
Local nBackRecNo
LOCAL nNewRecno

   cRecordSource  := _HMG_SYSDATA [ 40 ] [ index ] [ 10 ]
   nBackRecNo     := &cRecordSource->( RecNo() )
   aValue         := _GetValue (  ,  ,  index )

   if _IS_ACTIVE_FILTER_
      lOk := .f.
      nLogicalPos := 1
      &cRecordSource->( dbGoTop() )

      Do While .Not. Eof()
         If &cRecordSource->( RecNo() ) == nRecNo
            lOk := .t.
            nNewRecNo   := &cRecordSource->( RecNo() )   // ADD, march 2017 // unused nNewRecNo. asistex
            Exit
         EndIf
         &cRecordSource->( dbSkip() )
         nLogicalPos++
      EndDo
   else
      lOk := .t.
      &cRecordSource->( DBGOTO ( nRecNo ) )
      nLogicalPos := &cRecordSource->( ORDKEYNO () )
      nNewRecNo   := &cRecordSource->( RecNo() )   // ADD, march 2017 // unused nNewRecNo. asistex
   endif

   If lOk
//      &cRecordSource->( dbGoto( nNewRecNo ) )   // ADD, march 2017
   else
      &cRecordSource->( dbGoto( nBackRecNo ) )
   endif

   If lOk
      _SetValue (  ,  ,  {  nLogicalPos , aValue [2] } , index )
   EndIf

return nil


*************************************
function GetDataGridRecno( index )
*************************************
Local cRecordSource

Local aValue
Local nRecNo
Local nBackRecNo

Local aTemp
Local nBuffLogicalRow
Local nBuffPhysicalRow
Local k

// unused   nHandle        := _HMG_SYSDATA [  3 ] [ index ]
// unused   aColumnFields  := _HMG_SYSDATA [ 40 ] [ index ] [ 11 ]
   cRecordSource  := _HMG_SYSDATA [ 40 ] [ index ] [ 10 ]
   nBackRecNo     := &cRecordSource->( RecNo() )
   aValue         := _GetValue (  ,  ,  index )

   if _IS_ACTIVE_FILTER_
      &cRecordSource->( dbGoTop() )
      &cRecordSource->( dbSkip( aValue[1] - 1 ) )
   else
      &cRecordSource->( ORDKEYGOTO ( aValue[1] ) )
   endif

   If &cRecordSource->(Eof())
      nRecNo := 0
      // Try to get the buffer record number (if available)
      aTemp := _HMG_SYSDATA [ 40 ] [ index ] [21]
      For k := 1 To HMG_LEN ( aTemp )
         // Get Buffer Data
         nBuffLogicalRow  := aTemp [ k ] [ 1 ]
         nBuffPhysicalRow := aTemp [ k ] [ 4 ]
         If nBuffLogicalRow == _HMG_SYSDATA [ 39 ] [ index ]
            nRecNo := nBuffPhysicalRow
            Exit
         EndIf
      Next
   Else
      nRecNo := &cRecordSource->( RecNo() )
   EndIf

   &cRecordSource->( dbGoto( nBackRecNo ) )

return nRecNo


*************************************
Function DataGridDelete ( index )
*************************************
Local cOperation
Local nLogicalRow
Local nPhysicalRow
Local x

   // Set Operation Type
   cOperation := 'D'

   // Get Logical Row
   nLogicalRow := _HMG_SYSDATA [ 39 ] [index]

   // Get Physical Row
   nPhysicalRow := GetDataGridRecNo(index)

   // Process Double-Deleted/Recalled
   For x := 1 To _HMG_SYSDATA [ 40 ] [ index ] [ 24 ]
      If _HMG_SYSDATA [ 40 ] [ index ] [ 25 ] [ x ] [ 1 ] == nLogicalRow
         _HMG_SYSDATA [ 40 ] [ index ] [ 25 ] [ x ] [ 3 ] := 'D'
         Return .T.
      EndIf
   Next

   // Not Double Deleted/Recalled *********************************************

   // Append Record To Deleted / Recalled Buffer
   aadd ( _HMG_SYSDATA [ 40 ] [ index ] [ 25 ] , { nLogicalRow , nPhysicalRow , cOperation } )

   // Update Deleted / Recalled Buffer Count
   _HMG_SYSDATA [ 40 ] [ index ] [ 24 ]++

   // Set Pending Updates Flag
   _HMG_SYSDATA [ 40 ] [ index ] [ 20 ] := .T.

Return .T.


*************************************
Function DataGridRecall ( index )
*************************************
Local cOperation
Local nLogicalRow
Local nPhysicalRow
Local x

   // Set Operation Type
   cOperation := 'R'

   // Get Logical Row
   nLogicalRow := _HMG_SYSDATA [ 39 ] [index]

   // Get Physical Row
   nPhysicalRow := GetDataGridRecNo(index)

   // Process Double-Deleted/Recalled
   For x := 1 To _HMG_SYSDATA [ 40 ] [ index ] [ 24 ]
      If _HMG_SYSDATA [ 40 ] [ index ] [ 25 ] [ x ] [ 1 ] == nLogicalRow
         _HMG_SYSDATA [ 40 ] [ index ] [ 25 ] [ x ] [ 3 ] := 'R'
         Return .T.
      EndIf
   Next


   // Not Double Deleted/Recalled *******************************************

   // Append Record To Deleted / Recalled Buffer
   aadd ( _HMG_SYSDATA [ 40 ] [ index ] [ 25 ] , { nLogicalRow , nPhysicalRow , cOperation } )

   // Update Deleted / Recalled Buffer Count
   _HMG_SYSDATA [ 40 ] [ index ] [ 24 ]++

   // Set Pending Updates Flag
   _HMG_SYSDATA [ 40 ] [ index ] [ 20 ] := .T.

Return .T.


/*
****************************************
Function IsDataGridFiltered ( index )
****************************************
Local cRecordSource, lRet, nRecNo
   cRecordSource := _HMG_SYSDATA [ 40 ] [ index ] [ 10 ]
   if _IS_ACTIVE_FILTER_
      lRet := .t.
   else
      lRet := .f.
   endif
Return lRet
*/


***********************************************
Function SaveDataGridField ( index , Value )
***********************************************
Local nLogicalRow
Local nLogicalCol
Local lReEdit := .F.
Local aTemp
Local nBufferRow
Local x, nRecNo

   // Get Logical Position
   nLogicalRow := _HMG_SYSDATA [ 39 ] [index]
   nLogicalCol := _HMG_SYSDATA [ 15 ] [index]

   // Get Selected Row Record Number
   nRecNo := GetDataGridRecNo(index)

   // New Buffered Record Without a True RecNo
   If nRecNo == 0
      nRecNo := _HMG_SYSDATA [ 40 ] [ index ] [ 23 ] - nLogicalRow
   EndIf

   // Is re-edit of the same cell ?
   If _HMG_SYSDATA [ 40 ] [ index ] [ 20 ] == .T.
      aTemp := _HMG_SYSDATA [ 40 ] [ index ] [21]
      For x := 1 To HMG_LEN ( aTemp )
         If aTemp [ x ] [ 1 ] == nLogicalRow
            If aTemp [ x ] [ 2 ] == nLogicalCol
               lReEdit := .T.
               nBufferRow := x
               Exit
            EndIf
         EndIf
      Next
   EndIf

   // Add Data to Pending Updates Buffer
   If lReEdit
      _HMG_SYSDATA [ 40 ] [ index ] [21] [ nBufferRow ] := { nLogicalRow , nLogicalCol , Value , nRecNo }
   Else
      aadd ( _HMG_SYSDATA [ 40 ] [ index ] [21] , { nLogicalRow , nLogicalCol , Value , nRecNo } )
   EndIf

   // Set Pending Updates Flag
   _HMG_SYSDATA [ 40 ] [ index ] [ 20 ] := .T.

Return .T.


***********************************
Function DataGridAppend( index )
***********************************
Local cRecordSource
Local nItemCount
Local nHandle
Local aColumnFields
Local j

   // Get Control Data
   nHandle        := _HMG_SYSDATA [  3 ] [ index ]
   aColumnFields  := _HMG_SYSDATA [ 40 ] [ index ] [ 11 ]
   cRecordSource  := _HMG_SYSDATA [ 40 ] [ index ] [ 10 ]
   nItemCount     := ListView_GetItemCount ( nHandle )

   // Append a Row To The Grid
   ListView_SetItemCount ( nHandle , 0 )
   ListView_SetItemCount ( nHandle , nItemCount + 1 )

   &cRecordSource->( dbGoTop() )
   &cRecordSource->( dbGoBottom() )

   nItemCount := ListView_GetItemCount ( nHandle )
   _SetValue ( , , { nItemCount , 1 } , index )

   // Update New Record Buffer Count (Negative)
   _HMG_SYSDATA [ 40 ] [ index ] [ 22 ]--

   // Set Default Values For The New Record
   for j := 1 to HMG_LEN ( _HMG_SYSDATA [ 40 ] [ index ] [ 13 ] )
      if type ( aColumnFields [j] ) == 'C'
         _HMG_SYSDATA [ 40 ] [ index ] [ 13 ] [j] := ''
      elseif type ( aColumnFields [j] ) == 'N'
         _HMG_SYSDATA [ 40 ] [ index ] [ 13 ] [j] := 0
      elseif   type ( aColumnFields [j] ) == 'D'
         _HMG_SYSDATA [ 40 ] [ index ] [ 13 ] [j] := ctod('  /  /  ')
      elseif   type ( aColumnFields [j] ) == 'L'
         _HMG_SYSDATA [ 40 ] [ index ] [ 13 ] [j] := .F.
      elseif   type ( aColumnFields [j] ) == 'M'
         _HMG_SYSDATA [ 40 ] [ index ] [ 13 ] [j] := '<Memo>'
      endif
      aadd ( _HMG_SYSDATA [ 40 ] [ index ] [21] , { nItemCount , j , _HMG_SYSDATA [ 40 ] [ index ] [ 13 ] [j] , _HMG_SYSDATA [ 40 ] [ index ] [ 22 ] } )
   next

   // Set Pending Updates Flag
   _HMG_SYSDATA [ 40 ] [ index ] [ 20 ] := .T.

Return .T.


******************************
Function DataGridSave(index)
******************************
Local x
Local z
Local n
Local l
Local j
Local k
Local aTemp
Local g
Local h
Local aAppendBuffer
Local aEditBuffer
Local aMarkBuffer
Local nColumnCount
Local nAppendRecordCount
Local aRecord
Local aColumnClassMap
Local cRecordSource, aColumnFields, nHandle, nItemCount, nRecNo, nLogicalCol, xValue, nPhysicalRow, cCommand

   // If Not Buffered Data Then Return ************************************
   If _HMG_SYSDATA [ 40 ] [ index ] [ 20 ] == .F.
      Return .F.
   EndIf

   // Get Control Data ****************************************************
   nHandle           := _HMG_SYSDATA [  3 ] [ index ]
   cRecordSource     := _HMG_SYSDATA [ 40 ] [ index ] [ 10 ]
   aColumnFields     := _HMG_SYSDATA [ 40 ] [ index ] [ 11 ]
   aColumnClassMap   := _HMG_SYSDATA [ 40 ] [ index ] [ 30 ]
   nItemCount        := ListView_GetItemCount ( nHandle )   // unused nItemCount. To check what it does ListView_GetItemCount(). asistex

   // Backup Record Number ************************************************
   nRecNo := &cRecordSource->( RecNo() )

   // If OnSave Specified, Process It And Exit ****************************
   If ValType ( _HMG_SYSDATA [ 40 ] [ index ] [ 26 ] ) == 'B'

      // Create User Buffer Arrays From Internal Ones ****************
      aAppendBuffer  := {}
      aEditBuffer    := {}
      aMarkBuffer    := _HMG_SYSDATA [ 40 ] [ index ] [ 25 ]
      aTemp := _HMG_SYSDATA [ 40 ] [ index ] [ 21 ] // Internal Buffer

      nColumnCount := HMG_LEN ( aColumnFields )
      nAppendRecordCount := _HMG_SYSDATA [ 40 ] [ index ] [ 22 ]

      // Create User Append Buffer ***********************************
      for h := -1 To nAppendRecordCount Step -1
         aRecord := array ( nColumnCount )
         for g := 1 To HMG_LEN ( aTemp )
            if aTemp [ g ] [ 4 ] == h
               aRecord [ aTemp [ g ] [ 2 ] ] := aTemp [ g ] [ 3 ]
            endif
         next
         aadd ( aAppendBuffer , aRecord )
      next

      // Create User Edit Buffer *******************************************
      for g := 1 To HMG_LEN ( aTemp )
         h := aTemp [ g ] [ 4 ]
         if h > 0
            aadd ( aEditBuffer , aTemp [ g ] )
         endif
      next

      // Set This.*Buffer Properties
      _HMG_SYSDATA [ 278 ] := aClone ( aEditBuffer )
      _HMG_SYSDATA [ 279 ] := aClone ( aMarkBuffer )
      _HMG_SYSDATA [ 280 ] := aClone ( aAppendBuffer )

      // Execute It!
      Eval ( _HMG_SYSDATA [ 40 ] [ index ] [ 26 ] )

      // Cleanup ********************************************

      // Set Pending Updates Flag
      _HMG_SYSDATA [ 40 ] [ index ] [ 20 ] := .F.

      // Clean Data Buffer
      _HMG_SYSDATA [ 40 ] [ index ] [21] := {}

      // Update New Records Buffer Count
      _HMG_SYSDATA [ 40 ] [ index ] [ 22 ] := 0

      // Reset Buffered Session Initial Item Count
      _HMG_SYSDATA [ 40 ] [ index ] [ 23 ] := GridRecCount( index )

      // Reset Deleted / Recalled Buffer Count
      _HMG_SYSDATA [ 40 ] [ index ] [ 24 ] :=  0

      // Reset Deleted / Recalled Buffer
      _HMG_SYSDATA [ 40 ] [ index ] [ 25 ] := {}

      // Refresh
      DataGridRefresh(index)

      // The End
      Return .T.

   EndIf


///////////////////////////////////////////////////////////////////////
// RDD DEPENDANT CODE
///////////////////////////////////////////////////////////////////////

   if &cRecordSource->( rddName() ) == 'SQLMIX'
      MsgHMGError("GRID: Modify SQLMIX RDD tables are not allowed. Program terminated" )
   ElseIf   &cRecordSource->(rddName()) == 'PGRDD'
      MsgHMGError("GRID: Modify PostGre RDD tables are not allowed. Program terminated" )
   Else
      _HMG_SYSDATA [ 347 ] := .F.   // Grid Automatic Update

      // Process Existing Records *************************************************
      aTemp := _HMG_SYSDATA [ 40 ] [ index ] [ 21 ]
      For x := 1 To HMG_LEN ( aTemp )

         // Get Buffer Data
//         nLogicalRow    := aTemp [ x ] [ 1 ]  // unused nLogicalRow. asistex
         nLogicalCol    := aTemp [ x ] [ 2 ]
         xValue         := aTemp [ x ] [ 3 ]
         nPhysicalRow   := aTemp [ x ] [ 4 ]

         // Position in Physical Row ..............
         If nPhysicalRow > 0
            &cRecordSource->( dbGoto( nPhysicalRow ) )

            // Attempt To Lock To Save ....................................
            If RLock() == .F.
               MsgExclamation(_HMG_SYSDATA [ 136 ][9],_HMG_SYSDATA [ 136 ][10])
               &cRecordSource->( dbGoto( nRecNo ) )
               Return .f.
            endif

            // Save Data ..................................................
            if aColumnClassMap[ nLogicalCol ] == 'F'
               &cRecordSource->&( aColumnFields[ nLogicalCol ] ) := xValue
            Else
               &( aColumnFields[ nLogicalCol ] ) := xValue
            EndIf

            // Unlock .....................................................
            &cRecordSource->( dbRUnlock( &cRecordSource->( RecNo() ) ) )
         EndIf
      Next x

      // Process New Records ************************************************
      l := HMG_LEN(aTemp)
      For z := 1 To l
         If aTemp [ z ] [ 4 ] < 0
            // If the new record is marked as 'Deleted' do not append.
            If ! IsBufferedRecordMarkedForDeletion( index , aTemp [ z ] [ 4 ] )
               &cRecordSource->( dbAppend() )
               n := aTemp [ z ] [ 4 ]
               For j := 1 To l
                  If aTemp [j] [4] == n
                     // Attempt To Lock To Save .............
                     If RLock() == .F.
                        MsgExclamation(_HMG_SYSDATA [ 136 ][9],_HMG_SYSDATA [ 136 ][10])
                        &cRecordSource->( dbGoto( nRecNo ) )
                        Return .f.
                     endif

                     // Save Data ...........................
                     if aColumnClassMap[ aTemp [j] [2] ] == 'F'
                        &cRecordSource->&( aColumnFields[ aTemp [j] [2] ] ) := aTemp [j] [3]
                     else
                        &( aColumnFields[ aTemp [j] [2] ] ) := aTemp [j] [3]   // Add, May 2016
                     EndIf

                     // Unlock ..............................
                     &cRecordSource->( dbRUnlock( &cRecordSource->( RecNo() ) ) )

                     // CleanUp .............................
                     aTemp [j] [1] := 0
                     aTemp [j] [2] := 0
                     aTemp [j] [3] := Nil
                     aTemp [j] [4] := 0
                  Endif
               Next j
            EndIf
         EndIf
      Next z

      // Precess Delete / ReCall Commands ****************************
      For k := 1 To _HMG_SYSDATA [ 40 ] [ index ] [ 24 ]

         // Get Row And Command
         nPhysicalRow := _HMG_SYSDATA [ 40 ] [ index ] [ 25 ] [ k ] [ 2 ]
         cCommand := _HMG_SYSDATA [ 40 ] [ index ] [ 25 ] [ k ] [ 3 ]

         // Position On The Record To Process
         &cRecordSource->( dbGoto( nPhysicalRow ) )

         // Lock Record
         If RLock() == .F.
            MsgExclamation(_HMG_SYSDATA [ 136 ][9],_HMG_SYSDATA [ 136 ][10])
            return .f.
         endif

         // Excute Command **************************************
         If cCommand == 'D'
            &cRecordSource->( dbDelete() )
         ElseIf cCommand == 'R'
            &cRecordSource->( dbRecall() )
         EndIf

         // Unlock **********************************************
         &cRecordSource->( dbRUnlock( &cRecordSource->( RecNo() ) ) )
      Next

      _HMG_SYSDATA [347] := .T.   // Grid Automatic Update

   EndIf

///////////////////////////////////////////////////////////////////////
// END RDD DEPENDANT CODE
///////////////////////////////////////////////////////////////////////


   // Cleanup ********************************************

   // Restore Original Record Number **************************************
   &cRecordSource->( dbGoto( nRecNo ) )

   // Set Pending Updates Flag ********************************************
   _HMG_SYSDATA [ 40 ] [ index ] [ 20 ] := .F.

   // Clean Data Buffer ***************************************************
   _HMG_SYSDATA [ 40 ] [ index ] [21] := {}

   // Update New Records Buffer Count *************************************
   _HMG_SYSDATA [ 40 ] [ index ] [ 22 ] := 0

   // Reset Buffered Session Initial Item Count
   _HMG_SYSDATA [ 40 ] [ index ] [ 23 ] := GridRecCount( index )

   // Reset Deleted / Recalled Buffer Count
   _HMG_SYSDATA [ 40 ] [ index ] [ 24 ] :=  0

   // Reset Deleted / Recalled Buffer
   _HMG_SYSDATA [ 40 ] [ index ] [ 25 ] := {}

   // Refresh
   DataGridRefresh(index)

Return .t.


********************************************************************
Function IsBufferedRecordMarkedForDeletion( index , nPhysicalRow )
********************************************************************
Local lRetVal := .F.
Local k, cCommand

   For k := 1 To _HMG_SYSDATA [ 40 ] [ index ] [ 24 ]
      cCommand := _HMG_SYSDATA [ 40 ] [ index ] [ 25 ] [ k ] [ 3 ]
      If cCommand == 'D'
         If nPhysicalRow == _HMG_SYSDATA [ 40 ] [ index ] [ 25 ] [ k ] [ 2 ]
            lRetVal := .T.
            Exit
         EndIf
      EndIf
   Next

Return lRetVal


************************************************************
Function DataGridRefresh( index , lPreserveSelection )
*************************************************************
Local cRecordSource
Local nHandle
Local aValue

   DEFAULT lPreserveSelection TO .F.

   // Get Control Data ****************************************************
   nHandle       := _HMG_SYSDATA [  3 ] [ index ]
   cRecordSource := _HMG_SYSDATA [ 40 ] [ index ] [ 10 ]
   IF ValType ( cRecordSource ) <> 'C'
      return .F.   // Not Grid with cRecordSource ( DataBase )
   ENDIF

   if lPreserveSelection
      aValue := _GetValue ( , , index )
   endif

   // Reset Cell Position Data ********************************************
   _HMG_SYSDATA [ 39 ] [ index ] := 0
   _HMG_SYSDATA [ 15 ] [ index ] := 0

   // Set New ItemCount ***************************************************
// ListView_SetItemCount ( nHandle , 0 )
   ListView_SetItemCount ( nHandle , GridRecCount( index ) )

   // ReSet Selected Row **************************************************
   if lPreserveSelection
      _SetValue (  ,  , aValue , index )
   Else
      _SetValue (  ,  , {1,1} , index )
   EndIf

//   RedrawWindow( nHandle )
Return .t.


***************************************
Function DataGridClearBuffer(index)
***************************************

   // Get Control Data ****************************************************
//   nHandle        := _HMG_SYSDATA [  3 ] [ index ]        // unused nHandle. asistex
//   cRecordSource  := _HMG_SYSDATA [ 40 ] [ index ] [ 10 ] // unused cRecordSource. asistex

   // Set Pending Updates Flag ********************************************
   _HMG_SYSDATA [ 40 ] [ index ] [ 20 ] := .F.

   // Clean Data Buffer ***************************************************
   _HMG_SYSDATA [ 40 ] [ index ] [21] := {}

   // Update New Records Buffer Count *************************************
   _HMG_SYSDATA [ 40 ] [ index ] [ 22 ] := 0

   // Reset Deleted / Recalled Buffer Count *******************************
   _HMG_SYSDATA [ 40 ] [ index ] [ 24 ] :=  0

   // Reset Deleted / Recalled Buffer *************************************
   _HMG_SYSDATA [ 40 ] [ index ] [ 25 ] := {}

   // Refresh *************************************************************
   DataGridRefresh(index)

Return .t.


*******************************************************
Procedure GetDataGridCellData ( index , lTrueData )
*******************************************************
__THREAD STATIC nLastLogicalRecord := 0
__THREAD STATIC nLastHandle := 0
__THREAD STATIC nLastPhysicalRecord := 0
Local x, aTemp
Local cRecordSource
Local xBufferedCellValue
Local lBufferedCell := .F.
LOCAL nRecNo

   IF _HMG_SYSDATA [ 347 ] == .F.   // Grid Automatic Update
      RETURN
   ENDIF

   IF _HMG_SYSDATA [ 40 ] [ index ] [ 33 ] == .F.  // ENABLEUPDATE = .T. | DISABLEUPDATE = .F.
      RETURN
   ENDIF

   cRecordSource     := _HMG_SYSDATA [ 40 ] [ index ] [ 10 ]
// unused   aColumnFields     := _HMG_SYSDATA [ 40 ] [ index ] [ 11 ]

   nRecNo := &cRecordSource->( RecNo() )   // ADD, march 2017

   // Update Physical Record position
   If nLasthandle <> _HMG_SYSDATA [3] [ Index ] .OR. nLastLogicalRecord <> This.QueryRowIndex .OR. ListView_GetItemCount( _HMG_SYSDATA [3] [ Index ] ) == 1
      nLasthandle := _HMG_SYSDATA [3] [ Index ]
      nLastLogicalRecord := This.QueryRowIndex
      nLastPhysicalRecord := GridSetPhysicalRecord( index, This.QueryRowIndex )
   else
      &cRecordSource->( dbGoto( nLastPhysicalRecord ) )   // ADD, march 2017
   endif

   // Determine If The Required Cell Is Buffered
   IF _HMG_SYSDATA [ 40 ] [ index ] [ 20 ] == .T.  // Pending Edit Updates Flag
      aTemp := _HMG_SYSDATA [ 40 ] [ index ] [ 21 ]   // { nLogicalRow , nLogicalCol , xValue , nRecNo }
      lBufferedCell := .F.
      FOR x := 1 TO HMG_LEN ( aTemp )
         IF  aTemp [ x ] [ 1 ] == This.QueryRowIndex .and. aTemp [ x ] [ 2 ] == This.QueryColIndex
            lBufferedCell := .T.
            xBufferedCellValue := aTemp [ x ] [ 3 ]
            Exit
         ENDIF
      NEXT
   ENDIF


   // This started like a nice and compact piece of code, but it is becoming terribly complicated now
   if IsDataGridMemo( index , This.QueryColIndex ) == .T.
      If lTrueData
         This.QueryData := iif( lBufferedCell == .T., xBufferedCellValue, GetFiledData( index , This.QueryColIndex ) )
      else
         This.QueryData := '<Memo>'
      EndIf
   else
      If lTrueData
         This.QueryData := iif( lBufferedCell == .T., xBufferedCellValue, GetFiledData( index , This.QueryColIndex ) )
      else
         If ValType ( _HMG_SYSDATA [ 40 ] [ index ] [ 18 ] ) = 'A' // DynamicDisplay
            This.CellRowIndex := This.QueryRowIndex
            This.CellColIndex := This.QueryColIndex
            This.CellValueEx := iif( lBufferedCell == .T., xBufferedCellValue, GetFiledData( index , This.QueryColIndex ) )
            This.QueryData := EVAL ( _HMG_SYSDATA [ 40 ] [ index ] [ 18 ] [ This.QueryColIndex ] )   // Eval DynamicDisplay CodeBlock
         Else
            This.QueryData := iif( lBufferedCell == .T., xBufferedCellValue, GetFiledData( index , This.QueryColIndex ) )
         EndIf
      Endif
   Endif

   &cRecordSource->( dbGoto( nRecNo ) )   // ADD, march 2017

Return


************************************************************
Function GetFiledData ( index, nField )   // ADD May 2016
************************************************************
Local cRecordSource   := _HMG_SYSDATA [ 40 ] [ index ] [ 10 ]
Local aColumnFields   := _HMG_SYSDATA [ 40 ] [ index ] [ 11 ]
Local aColumnClassMap := _HMG_SYSDATA [ 40 ] [ index ] [ 30 ]
Local xData
   IF aColumnClassMap [ nField ] == 'F'
   // xData := &cRecordSource->( FieldGet( &cRecordSource->( FieldPos( aColumnFields[ nField ] ) ) ) )
      xData := &cRecordSource->&( aColumnFields[ nField ] )   //  Field in this Area
   ELSE
      xData := &( aColumnFields[ nField ] )   // Field in other Area
   ENDIF
Return xData


***********************************************************************************
Function GridSetPhysicalRecord( index, nLogicalRecno )   // ADD May 2016
***********************************************************************************
Local cRecordSource   := _HMG_SYSDATA [ 40 ] [ index ] [ 10 ]
Local nPhysicalRecord := 0
Local nLogicalRecord  := 0
Local nOldWorkArea

   IF _IS_ACTIVE_FILTER_
/*
      &cRecordSource->( dbGoTop() )
      WHILE .NOT. &cRecordSource->( Eof() )
         IF &cRecordSource->( Deleted() ) == .F.
            nLogicalRecord ++
            IF nLogicalRecord == nLogicalRecno
               nPhysicalRecord := &cRecordSource->( RecNo() )
               EXIT
            ENDIF
         ENDIF
         &cRecordSource->( dbSkip() )
      ENDDO
*/
      nOldWorkArea := Select()
      Select( cRecordSource )
      dbGoTop()
      // if Set Delete is On, dbEval() not process deleted records
      dbEval( {|| nLogicalRecord++, nPhysicalRecord := RecNo() }, NIL, {|| nLogicalRecord <> nLogicalRecno } )
      dbGoto( nPhysicalRecord )
      Select( nOldWorkArea )
   ELSE
      nLogicalRecord := nLogicalRecno
      &cRecordSource->( ordKeyGoto( nLogicalRecord ) )
      nPhysicalRecord := &cRecordSource->( RecNo() )
   ENDIF
RETURN nPhysicalRecord



