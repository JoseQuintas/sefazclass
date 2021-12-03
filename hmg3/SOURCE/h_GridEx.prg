/*----------------------------------------------------------------------------
 HMG Source File --> h_GridEx.prg

 Copyright 2012-2017 by Dr. Claudio Soto (from Uruguay).

 mail: <srvet@adinet.com.uy>
 blog: http://srvet.blogspot.com

 Permission to use, copy, modify, distribute and sell this software
 and its documentation for any purpose is hereby granted without fee,
 provided that the above copyright notice appear in all copies and
 that both that copyright notice and this permission notice appear
 in supporting documentation.
 It is provided "as is" without express or implied warranty.

 ----------------------------------------------------------------------------*/

MEMVAR _HMG_SYSDATA

#include "hmg.ch"


// FUNCTIONS
**********************************************************************************
* _GridEx_ColumnCount         ---> Return the Number of Column on GRID
*
* _GridEx_AddColumnEx         ---> Complement of Method:  AddColumn (nColIndex)
* _GridEx_DeleteColumnEx      ---> Complement of Method:  DeleteColumn (nColIndex)
*
* _GridEx_GetColumnControl    ---> Return specific Control of Column(nColIndex) ==> [cCAPTION, nWIDTH, nJUSTIFY, aCOLUMNCONTROL, bDYNAMICBACKCOLOR, bDYNAMICFORECOLOR, bCOLUMNWHEN, bCOLUMNVALID, bONHEADCLICK]
* _GridEx_SetColumnControl    ---> Set specific Control of Column(nColIndex)    ==> [cCAPTION, nWIDTH, nJUSTIFY, aCOLUMNCONTROL, bDYNAMICBACKCOLOR, bDYNAMICFORECOLOR, bCOLUMNWHEN, bCOLUMNVALID, bONHEADCLICK]
*
* _GridEx_GetColumnDisplayPos ---> Get the position of Column(nColIndex) in that display in the GRID
* _GridEx_SetColumnDisplayPos ---> Set the position of Column(nColIndex) in that display in the GRID
*
* _GridEx_SetBkImage          ---> Set background image in Grid
*
* _GridEx_GetCellValue        ---> Get the value of Cell (nRowIndex, nColIndex)
* _GridEx_SetCellValue        ---> Set the value of Cell (nRowIndex, nColIndex)
**********************************************************************************



// CONSTANTS (nControl)
**********************************************************************************
* _HMG_SYSDATA [ nControl ] [i]
*
* #define _GRID_COLUMN_HEADER_             7
* #define _GRID_COLUMN_ONHEADCLICK_        17
* #define _GRID_COLUMN_HEADERIMAGE_        22
* #define _GRID_COLUMN_HEADER2_            33
* #define _GRID_COLUMN_JUSTIFY_            37
*
* _HMG_SYSDATA [ 40 ] [ i ] [ nControl ]
*
* #define _GRID_COLUMN_CONTROL_            2
* #define _GRID_COLUMN_DYNAMICBACKCOLOR_   3
* #define _GRID_COLUMN_DYNAMICFORECOLOR_   4
* #define _GRID_COLUMN_VALID_              5
* #define _GRID_COLUMN_WHEN_               6
* #define _GRID_COLUMN_WIDTH_              31
* #define _GRID_COLUMN_DYNAMICFONT_        41
* #define _GRID_COLUMN_HEADERFONT_         43
* #define _GRID_COLUMN_HEADERBACKCOLOR_    44
* #define _GRID_COLUMN_HEADERFORECOLOR_    45
**********************************************************************************


// CONSTANTS -->  _GridEx_SetBkImage (nAction)
**********************************************************************************
* #define GRID_SETBKIMAGE_NONE        0
* #define GRID_SETBKIMAGE_NORMAL      1
* #define GRID_SETBKIMAGE_TILE        2
* #define GRID_SETBKIMAGE_WATERMARK   3
**********************************************************************************


// CONSTANTS -->  LISTVIEW_SETCOLUMNWIDTH (nWidth)
**********************************************************************************
* #define GRID_WIDTH_AUTOSIZE         (-1)
* #define GRID_WIDTH_AUTOSIZEHEADER   (-2)
**********************************************************************************




******************
*** Properties ***
******************

*-----------------------------------------------------------------------------------------*
FUNCTION _GridEx_ColumnCount (cControlName , cParentForm)
*-----------------------------------------------------------------------------------------*
#if 1
   LOCAL  i:= GetControlIndex (cControlName , cParentForm)
   RETURN (HMG_LEN(_HMG_SYSDATA [ 7 ] [i]))   // Length of aColumnHeader
#else   // this way produce a bug ( Bound error: array access ) when call DeleteColumn( 1 ) with a Grid with only one column
   LOCAL hWnd := GetControlHandle (cControlName , cParentForm)
   RETURN ListView_GetColumnCount( hWnd )
#endif

*-----------------------------------------------------------------------------------------*
FUNCTION _GridEx_GetColumnControl (cControlName , cParentForm, nControl, nColIndex)
*-----------------------------------------------------------------------------------------*
// cCAPTION, nWIDTH, nJUSTIFY, aCOLUMNCONTROL, bDYNAMICBACKCOLOR, bDYNAMICFORECOLOR, bCOLUMNWHEN, bCOLUMNVALID, bONHEADCLICK
LOCAL Length, i, Data := NIL
  i := GetControlIndex(cControlName,cParentForm)
  IF (nControl = _GRID_COLUMN_ONHEADCLICK_) .OR. (nControl = _GRID_COLUMN_HEADER_) .OR. (nControl = _GRID_COLUMN_JUSTIFY_)
     Length := HMG_LEN(_HMG_SYSDATA [ nControl ] [i])
     IF nColIndex > 0 .AND. nColIndex <= Length
        Data := _HMG_SYSDATA [ nControl ] [i] [nColIndex]
     ELSE
        MsgHMGError ("Grid: Invalid nColIndex. Program Terminated")
     ENDIF
  ELSE
     IF Valtype (_HMG_SYSDATA [ 40 ] [ i ] [ nControl ]) == "A"

        Length := HMG_LEN(_HMG_SYSDATA [ 40 ] [ i ] [ nControl ])
        IF nColIndex > 0 .AND. nColIndex <= Length
           Data := _HMG_SYSDATA [ 40 ] [ i ] [ nControl ] [nColIndex]
           IF nControl = _GRID_COLUMN_WIDTH_
              // Low-level function in C native of HMG (source c_grid.c)
              Data := LISTVIEW_GETCOLUMNWIDTH (GetControlHandle (cControlName, cParentForm), nColIndex-1)
           ENDIF
        ELSE
           MsgHMGError ("Grid: Invalid nColIndex. Program Terminated")
        ENDIF
     ENDIF
  ENDIF
RETURN Data


*-----------------------------------------------------------------------------------------------------*
FUNCTION _GridEx_SetColumnControl (cControlName , cParentForm, nControl, nColIndex, Data, lRefresh)
*-----------------------------------------------------------------------------------------------------*
// cCAPTION, nWIDTH, nJUSTIFY, aCOLUMNCONTROL, bDYNAMICBACKCOLOR, bDYNAMICFORECOLOR, bCOLUMNWHEN, bCOLUMNVALID, bONHEADCLICK
LOCAL Length, nColumnCount, i, lGridEnableUpdate

  nColumnCount := _GridEx_ColumnCount(cControlName,cParentForm)
  i := GetControlIndex(cControlName,cParentForm)

  IF Valtype (lRefresh) <> "L"
     lRefresh := .T.
  ENDIF

  IF nControl = _GRID_COLUMN_ONHEADCLICK_ .OR. nControl = _GRID_COLUMN_HEADER_ .OR. nControl = _GRID_COLUMN_JUSTIFY_
     Length := HMG_LEN(_HMG_SYSDATA [ nControl ] [i])
     IF Length < nColumnCount
        ASIZE (_HMG_SYSDATA [ nControl ] [i] , nColumnCount)
     ENDIF

     _GridEx_SET_DEFAULT_COLUMN_CONTROL (cControlName , cParentForm, nControl)

     IF nColIndex > 0 .AND. nColIndex <= nColumnCount
        _HMG_SYSDATA [ nControl ] [i] [nColIndex] := Data
        DO CASE
           CASE nControl = _GRID_COLUMN_HEADER_
                _HMG_SYSDATA [ _GRID_COLUMN_HEADER2_ ] [i] := _HMG_SYSDATA [ _GRID_COLUMN_HEADER_ ] [i]
                SETGRIDCOLOMNHEADER (GetControlHandle(cControlName, cParentForm), nColIndex, Data)   // Low-level function in C native of HMG (source c_grid.c)
           CASE nControl = _GRID_COLUMN_JUSTIFY_
                LISTVIEW_SETCOLUMNJUSTIFY (GetControlHandle(cControlName, cParentForm), nColIndex-1, Data)   // Low-level function in C (source c_GridEx.c)
        ENDCASE
     ELSE
        MsgHMGError ("Grid: Invalid nColIndex. Program Terminated")
     ENDIF

  ELSE
     IF Valtype (_HMG_SYSDATA [ 40 ] [ i ] [ nControl ]) <> "A"
        _HMG_SYSDATA [ 40 ] [ i ] [ nControl ] := {}
     ENDIF

     Length := HMG_LEN(_HMG_SYSDATA [ 40 ] [ i ] [ nControl ])
     IF Length < nColumnCount
        ASIZE (_HMG_SYSDATA [ 40 ] [ i ] [ nControl ], nColumnCount)
     ENDIF

    _GridEx_SET_DEFAULT_COLUMN_CONTROL (cControlName , cParentForm, nControl)

    IF nColIndex > 0 .AND. nColIndex <= nColumnCount
       _HMG_SYSDATA [ 40 ] [ i ] [ nControl ] [nColIndex] := Data

       IF nControl = _GRID_COLUMN_WIDTH_
          // Low-level function in C native of HMG (source c_grid.c)
          LISTVIEW_SETCOLUMNWIDTH (GetControlHandle (cControlName, cParentForm), nColIndex-1, Data)
       ENDIF
    ELSE
       MsgHMGError ("Grid: Invalid nColIndex. Program Terminated")
    ENDIF
  ENDIF

  IF nControl = _GRID_COLUMN_CONTROL_ .AND. lRefresh == .T.
     *******************************************************
     * This change only has effect when write in the item  *
     *******************************************************
     _GridEx_UpdateCellValue (cControlName, cParentForm, nColIndex)   // Force the rewrite the all items of the Column(nColumnIndex)
  ENDIF

  lGridEnableUpdate := _HMG_SYSDATA [ 40 ] [ i ] [ 33 ]
  IF lRefresh == .T. .AND. lGridEnableUpdate == .T.
     DoMethod (cParentForm, cControlName, "Refresh")
  ENDIF

RETURN NIL


*-----------------------------------------------------------------------------------------*
FUNCTION _GridEx_GetColumnDisplayPosition (cControlName, cParentForm, nColIndex)
*-----------------------------------------------------------------------------------------*
LOCAL nPos, nColumnCount, ArrayOrder
   nColumnCount := _GridEx_ColumnCount (cControlName, cParentForm)
   ArrayOrder := LISTVIEW_GETCOLUMNORDERARRAY (GetControlHandle (cControlName, cParentForm), nColumnCount) // Low-level function in C (source c_GridEx.c)
   nPos := ASCAN (ArrayOrder, nColIndex)
RETURN nPos


*------------------------------------------------------------------------------------------------*
FUNCTION _GridEx_SetColumnDisplayPosition (cControlName, cParentForm, nColIndex, nPos_Display)
*------------------------------------------------------------------------------------------------*
LOCAL nOld_Pos, ArrayOrder
LOCAL nColumnCount := _GridEx_ColumnCount (cControlName, cParentForm)
LOCAL lGridEnableUpdate, i

   // Low-level function in C (source c_GridEx.c)
   ArrayOrder := LISTVIEW_GETCOLUMNORDERARRAY (GetControlHandle (cControlName, cParentForm), nColumnCount)
   nOld_Pos := ASCAN (ArrayOrder, nColIndex)

   IF nOld_pos >= 1 .AND. nPos_Display <> nOld_Pos
      ADEL (ArrayOrder, nOld_Pos)
      AINS (ArrayOrder, nPos_Display)
      ArrayOrder [nPos_Display] := nColIndex

      // Low-level function in C (source c_GridEx.c)
      LISTVIEW_SETCOLUMNORDERARRAY (GetControlHandle (cControlName, cParentForm), nColumnCount, ArrayOrder)

      i := GetControlIndex (cControlName, cParentForm)
      lGridEnableUpdate := _HMG_SYSDATA [ 40 ] [ i ] [ 33 ]
      IF lGridEnableUpdate == .T.
         DoMethod (cParentForm, cControlName, "Refresh")
      ENDIF
   ENDIF
RETURN nOld_Pos



*----------------------------------------------------------------------------------------------*
FUNCTION _GridEx_SetBkImage (cControlName, cParentForm, nAction, cPicture, yOffset, xOffset)
*----------------------------------------------------------------------------------------------*
   // Low-level function in C (source c_GridEx.c)
   LISTVIEW_SETBKIMAGE (GetControlHandle (cControlName, cParentForm), cPicture, xOffset, yOffset, nAction)
RETURN NIL



*----------------------------------------------------------------------------------------------*
FUNCTION _GridEx_GetBkImage (cControlName, cParentForm)
*----------------------------------------------------------------------------------------------*
                     // Low-level function in C (source c_GridEx.c)
LOCAL aBKIMAGEinfo := LISTVIEW_GETBKIMAGE (GetControlHandle (cControlName, cParentForm))
RETURN aBKIMAGEinfo



*---------------------------------------------------------------------------------------------------*
FUNCTION  _GridEx_GetCellValue (cControlName, cParentForm, nRowIndex, nColIndex)
*---------------------------------------------------------------------------------------------------*
LOCAL AEDITCONTROLS, XRES, AEC, CTYPE, CFORMAT, AITEMS, ALABELS, X, Z
LOCAL xData := NIL

LOCAL cItemCell := LISTVIEW_GETITEMTEXT (GetControlHandle (cControlName, cParentForm), nRowIndex-1, nColIndex-1)

   AEDITCONTROLS := ARRAY (1)
   AEDITCONTROLS [1] := _GridEx_GetColumnControl (cControlName , cParentForm, _GRID_COLUMN_CONTROL_, nColIndex)
   XRES := _HMG_PARSEGRIDCONTROLS (AEDITCONTROLS, 1)

   AEC         := XRES [1]
   CTYPE       := HMG_UPPER( XRES [2] )
// unused   CINPUTMASK  := XRES [3] // asistex
   CFORMAT     := XRES [4]
   AITEMS      := XRES [5]
// unused   ARANGE      := XRES [6] // asistex
// unused   DTYPE       := XRES [7] // asistex
   ALABELS     := XRES [8]

   IF AEC == 'TEXTBOX'
      IF CTYPE == 'NUMERIC'
         IF CFORMAT = 'E'
            xData := GetNumFromCellTextSp (cItemCell)
         ELSE
            xData := GetNumFromCellText (cItemCell)
         ENDIF
      ELSEIF CTYPE == 'DATE'
             xData := CTOD (cItemCell)
      ELSEIF CTYPE == 'PASSWORD'  // By Pablo on February, 2015
             xData := cItemCell
      ELSEIF CTYPE == 'CHARACTER'
             xData := cItemCell
      ENDIF

   ELSEIF AEC == 'DATEPICKER'
          xData := CTOD (cItemCell)

   ELSEIF AEC == 'EDITBOX'    // By Pablo on February, 2015
          xData := cItemCell

   ELSEIF AEC == 'TIMEPICKER'
          xData := cItemCell

   ELSEIF AEC == 'COMBOBOX'
          Z := 0
          FOR X := 1 TO HMG_LEN (AITEMS)
              IF HMG_UPPER (ALLTRIM(cItemCell)) == HMG_UPPER (ALLTRIM(AITEMS [X]))
                 Z := X
                 EXIT
              ENDIF
          NEXT
          xData := Z

   ELSEIF AEC == 'SPINNER'
         xData := VAL (cItemCell)

   ELSEIF AEC == 'CHECKBOX'
         IF ALLTRIM(HMG_UPPER(cItemCell)) == ALLTRIM(HMG_UPPER(ALABELS [1]))
            xData := .T.
         ELSEIF ALLTRIM(HMG_UPPER(cItemCell)) == ALLTRIM(HMG_UPPER(ALABELS [2]))
            xData := .F.
         ENDIF
   ENDIF

RETURN xData


*---------------------------------------------------------------------------------------------------*
FUNCTION  _GridEx_SetCellValue (cControlName, cParentForm, nRowIndex, nColIndex, xData)
*---------------------------------------------------------------------------------------------------*
LOCAL AEDITCONTROLS, XRES, AEC, CTYPE, CINPUTMASK, CFORMAT, AITEMS, ALABELS, aux
LOCAL cItemCell := ""

   AEDITCONTROLS := ARRAY (1)
   AEDITCONTROLS [1] := _GridEx_GetColumnControl (cControlName , cParentForm, _GRID_COLUMN_CONTROL_, nColIndex)
   XRES := _HMG_PARSEGRIDCONTROLS (AEDITCONTROLS, 1)

   AEC         := XRES [1]
   CTYPE       := HMG_UPPER( XRES [2] )
   CINPUTMASK  := XRES [3]
   CFORMAT     := XRES [4]
   AITEMS      := XRES [5]
// unused   ARANGE      := XRES [6] // asistex
// unused   DTYPE       := XRES [7] // asistex
   ALABELS     := XRES [8]


   IF AEC == 'TEXTBOX'
      IF CTYPE == 'CHARACTER'
         IF EMPTY (CINPUTMASK)
            cItemCell := xData
         ELSE
            cItemCell := TRANSFORM (xData, CINPUTMASK)
         ENDIF
      ELSEIF CTYPE == 'NUMERIC'
         IF EMPTY (CINPUTMASK)
            cItemCell := STR (xData)
         ELSE
            IF EMPTY (CFORMAT)
               cItemCell := TRANSFORM (xData ,CINPUTMASK)
            ELSE
               cItemCell := TRANSFORM (xData, '@' + CFORMAT + ' ' + CINPUTMASK)
            ENDIF
         ENDIF
      ELSEIF CTYPE == 'DATE'
          cItemCell := DTOC (xData)
      ELSEIF CTYPE == 'PASSWORD'  // By Pablo on February, 2015
         cItemCell :=  xData
      ENDIF

   ELSEIF AEC == 'DATEPICKER'
          aux = SET (_SET_DATEFORMAT)
          SET CENTURY ON
          cItemCell := DTOC (xData)
          SET (_SET_DATEFORMAT, aux)

   ELSEIF AEC == 'EDITBOX'    // By Pablo on February, 2015
          cItemCell := xData

   ELSEIF AEC == 'TIMEPICKER'
          cItemCell := HMG_TimeToTime (xData, CFORMAT)

   ELSEIF AEC == 'COMBOBOX'
          IF xData == 0
             cItemCell := ''
          ELSE
             cItemCell := AITEMS [ xData ]
          ENDIF

   ELSEIF AEC == 'SPINNER'
          cItemCell := STR (xData)

   ELSEIF AEC == 'CHECKBOX'
          IF xData == .T.
             cItemCell := ALABELS [1]
          ELSE
             cItemCell := ALABELS [2]
          ENDIF

   ELSEIF ValType( cItemCell ) <> "C"
          cItemCell := hb_ValToStr( cItemCell )

   ENDIF

   LISTVIEW_SETITEMTEXT (GetControlHandle (cControlName, cParentForm), nRowIndex-1, nColIndex-1, cItemCell)

RETURN cItemCell



*----------------------------------------------------------------------------------------------*
FUNCTION CellNavigationColor (nIndex, xData)
*----------------------------------------------------------------------------------------------*
MEMVAR _HMG_GRID_SELECTEDROW_DISPLAYCOLOR
MEMVAR _HMG_GRID_SELECTEDCELL_DISPLAYCOLOR
LOCAL  aRGB_old, aRGB

   IF nIndex == _SELECTEDROW_DISPLAYCOLOR .AND. ValType (xData) == "L"
      _HMG_GRID_SELECTEDROW_DISPLAYCOLOR := xData
      RETURN NIL
   ENDIF

   IF nIndex == _SELECTEDCELL_DISPLAYCOLOR .AND. ValType (xData) == "L"
      _HMG_GRID_SELECTEDCELL_DISPLAYCOLOR := xData
      RETURN NIL
   ENDIF

   IF nIndex >= 348 .AND. nIndex <= 351
      aRGB := xData
      aRGB_old := _HMG_SYSDATA [ nIndex ]
      IF ValType (aRGB) == "A" .AND. HMG_LEN (aRGB) == 3
         _HMG_SYSDATA [ nIndex ] := aRGB
      ELSEIF ValType (aRGB) <> "U"
         MsgHMGError ("Grid Cell Navigation Color: Invalid parameter aRGB color. Program Terminated")
      ENDIF
   ELSE
      MsgHMGError ("Grid Cell Navigation Color: Invalid parameters. Program Terminated")
   ENDIF
RETURN aRGB_old



**********************************************************************************************************
*** Internal Functions ***
**********************************************************************************************************


*----------------------------------------------------------------------------------------------*
FUNCTION _GridEx_AddColumnEx (cControlName, cParentForm, nColIndex)
*----------------------------------------------------------------------------------------------*
LOCAL nColumnCount := _GridEx_ColumnCount (cControlName , cParentForm)
   _GridEx_ADD_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_HEADER_,           nColIndex, nColumnCount)
   _GridEx_ADD_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_HEADER2_,          nColIndex, nColumnCount)
   _GridEx_ADD_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_HEADERIMAGE_,      nColIndex, nColumnCount)
   _GridEx_ADD_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_WIDTH_,            nColIndex, nColumnCount)
   _GridEx_ADD_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_JUSTIFY_,          nColIndex, nColumnCount)
   _GridEx_ADD_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_CONTROL_,          nColIndex, nColumnCount)
   _GridEx_ADD_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_DYNAMICBACKCOLOR_, nColIndex, nColumnCount)
   _GridEx_ADD_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_DYNAMICFORECOLOR_, nColIndex, nColumnCount)
   _GridEx_ADD_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_WHEN_,             nColIndex, nColumnCount)
   _GridEx_ADD_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_VALID_,            nColIndex, nColumnCount)
   _GridEx_ADD_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_ONHEADCLICK_,      nColIndex, nColumnCount)
   _GridEx_ADD_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_DYNAMICFONT_,      nColIndex, nColumnCount)
   _GridEx_ADD_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_HEADERFONT_,       nColIndex, nColumnCount)
   _GridEx_ADD_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_HEADERBACKCOLOR_,  nColIndex, nColumnCount)
   _GridEx_ADD_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_HEADERFORECOLOR_,  nColIndex, nColumnCount)
RETURN NIL


*----------------------------------------------------------------------------------------------*
FUNCTION _GridEx_DeleteColumnEx (cControlName, cParentForm, nColIndex)
*----------------------------------------------------------------------------------------------*
LOCAL nColumnCount := _GridEx_ColumnCount (cControlName , cParentForm)
   _GridEx_DELETE_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_HEADER_,           nColIndex, nColumnCount)
   _GridEx_DELETE_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_HEADER2_,          nColIndex, nColumnCount)
   _GridEx_DELETE_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_HEADERIMAGE_,      nColIndex, nColumnCount)
   _GridEx_DELETE_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_WIDTH_,            nColIndex, nColumnCount)
   _GridEx_DELETE_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_JUSTIFY_,          nColIndex, nColumnCount)
   _GridEx_DELETE_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_CONTROL_,          nColIndex, nColumnCount)
   _GridEx_DELETE_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_DYNAMICBACKCOLOR_, nColIndex, nColumnCount)
   _GridEx_DELETE_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_DYNAMICFORECOLOR_, nColIndex, nColumnCount)
   _GridEx_DELETE_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_WHEN_,             nColIndex, nColumnCount)
   _GridEx_DELETE_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_VALID_,            nColIndex, nColumnCount)
   _GridEx_DELETE_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_ONHEADCLICK_,      nColIndex, nColumnCount)
   _GridEx_DELETE_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_DYNAMICFONT_,      nColIndex, nColumnCount)
   _GridEx_DELETE_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_HEADERFONT_,       nColIndex, nColumnCount)
   _GridEx_DELETE_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_HEADERBACKCOLOR_,  nColIndex, nColumnCount)
   _GridEx_DELETE_COLUMN_CONTROL (cControlName, cParentForm, _GRID_COLUMN_HEADERFORECOLOR_,  nColIndex, nColumnCount)
RETURN NIL


*----------------------------------------------------------------------------------------------*
FUNCTION _GridEx_SET_DEFAULT_COLUMN_CONTROL (cControlName , cParentForm, nControl)
*----------------------------------------------------------------------------------------------*
LOCAL k, DefaultData
LOCAL i := GetControlIndex(cControlName,cParentForm)
LOCAL nColumnCount := _GridEx_ColumnCount(cControlName,cParentForm)

   DO CASE
      CASE nControl = _GRID_COLUMN_HEADER_ .OR. nControl = _GRID_COLUMN_HEADER2_ .OR. nControl == _GRID_COLUMN_HEADERIMAGE_
           DefaultData := ""
      CASE nControl = _GRID_COLUMN_JUSTIFY_
           DefaultData := GRID_JTFY_LEFT
      CASE nControl = _GRID_COLUMN_ONHEADCLICK_
           DefaultData := {||NIL}
      CASE nControl = _GRID_COLUMN_WIDTH_
           DefaultData := 120
      CASE nControl = _GRID_COLUMN_CONTROL_
           DefaultData := {'TEXTBOX','CHARACTER'}
      CASE nControl = _GRID_COLUMN_DYNAMICBACKCOLOR_
           DefaultData := NIL // {||NIL}
      CASE nControl = _GRID_COLUMN_DYNAMICFORECOLOR_
           DefaultData := NIL // {||NIL}
      CASE nControl = _GRID_COLUMN_VALID_
           DefaultData := {||.T.}
      CASE nControl = _GRID_COLUMN_WHEN_
           DefaultData := {||.T.}
      CASE nControl = _GRID_COLUMN_DYNAMICFONT_
           DefaultData := NIL   // {||NIL}
      CASE nControl = _GRID_COLUMN_HEADERFONT_
           DefaultData := NIL   // {||NIL}
      CASE nControl = _GRID_COLUMN_HEADERBACKCOLOR_
           DefaultData := NIL   // {||NIL}
      CASE nControl = _GRID_COLUMN_HEADERFORECOLOR_
           DefaultData := NIL   // {||NIL}
   ENDCASE

   IF nControl == _GRID_COLUMN_ONHEADCLICK_ .OR. nControl == _GRID_COLUMN_HEADER_ .OR. nControl == _GRID_COLUMN_HEADER2_ .OR. nControl == _GRID_COLUMN_HEADERIMAGE_ .OR. nControl == _GRID_COLUMN_JUSTIFY_
      IF Valtype (_HMG_SYSDATA [ nControl ] [i]) == "A"
         FOR k = 1 TO nColumnCount
             IF Valtype (_HMG_SYSDATA [ nControl ] [i] [k]) == "U"
                _HMG_SYSDATA [ nControl ] [i] [k] := DefaultData
             ENDIF
         NEXT
      ENDIF
   ELSE
      IF Valtype (_HMG_SYSDATA [ 40 ] [ i ] [ nControl ]) == "A"
         FOR k = 1 TO nColumnCount
             IF Valtype (_HMG_SYSDATA [ 40 ] [ i ] [ nControl ] [k]) == "U"
                _HMG_SYSDATA [ 40 ] [ i ] [ nControl ] [k] := DefaultData
             ENDIF
         NEXT
      ENDIF
   ENDIF

RETURN NIL



*---------------------------------------------------------------------------------------------------------*
FUNCTION _GridEx_DELETE_COLUMN_CONTROL (cControlName , cParentForm, nControl, nColIndex, nColumnCount)
*---------------------------------------------------------------------------------------------------------*
LOCAL i := GetControlIndex(cControlName,cParentForm)

  IF nControl == _GRID_COLUMN_ONHEADCLICK_ .OR. nControl == _GRID_COLUMN_HEADER_ .OR. nControl == _GRID_COLUMN_HEADER2_ .OR. nControl == _GRID_COLUMN_HEADERIMAGE_ .OR. nControl == _GRID_COLUMN_JUSTIFY_
     IF Valtype (_HMG_SYSDATA [ nControl ] [i]) == "A"
        IF nColIndex > 0 .AND. nColIndex <= nColumnCount
           ADEL  (_HMG_SYSDATA [ nControl ] [i], nColIndex)
           ASIZE (_HMG_SYSDATA [ nControl ] [i], nColumnCount-1)
        ELSE
           MsgHMGError ("Grid: Invalid nColIndex. Program Terminated")
        ENDIF
     ENDIF
  ELSE
     IF Valtype (_HMG_SYSDATA [ 40 ] [ i ] [ nControl ]) == "A"
        IF nColIndex > 0 .AND. nColIndex <= nColumnCount
           ADEL  (_HMG_SYSDATA [ 40 ] [ i ] [ nControl ], nColIndex)
           ASIZE (_HMG_SYSDATA [ 40 ] [ i ] [ nControl ], nColumnCount-1)
        ELSE
           MsgHMGError ("Grid: Invalid nColIndex. Program Terminated")
        ENDIF
     ENDIF
  ENDIF

  _GridEx_SET_DEFAULT_COLUMN_CONTROL (cControlName , cParentForm, nControl)

RETURN NIL


*---------------------------------------------------------------------------------------------------*
FUNCTION _GridEx_ADD_COLUMN_CONTROL (cControlName , cParentForm, nControl, nColIndex, nColumnCount)
*---------------------------------------------------------------------------------------------------*
LOCAL i := GetControlIndex(cControlName,cParentForm)

  IF nControl == _GRID_COLUMN_ONHEADCLICK_ .OR. nControl == _GRID_COLUMN_HEADER_ .OR. nControl == _GRID_COLUMN_HEADER2_ .OR. nControl == _GRID_COLUMN_HEADERIMAGE_ .OR. nControl == _GRID_COLUMN_JUSTIFY_
     IF Valtype (_HMG_SYSDATA [ nControl ] [i]) == "A"
        IF nColIndex > 0 .AND. nColIndex <= nColumnCount+1
           ASIZE (_HMG_SYSDATA [ nControl ] [i], nColumnCount+1)
           AINS  (_HMG_SYSDATA [ nControl ] [i], nColIndex)
        ELSE
           MsgHMGError ("Grid: Invalid nColIndex. Program Terminated")
        ENDIF
     ENDIF
  ELSE
     IF Valtype (_HMG_SYSDATA [ 40 ] [ i ] [ nControl ]) == "A"
        IF nColIndex > 0 .AND. nColIndex <= nColumnCount+1
           ASIZE (_HMG_SYSDATA [ 40 ] [ i ] [ nControl ], nColumnCount+1)
           AINS  (_HMG_SYSDATA [ 40 ] [ i ] [ nControl ], nColIndex)
        ELSE
           MsgHMGError ("Grid: Invalid nColIndex. Program Terminated")
        ENDIF
     ENDIF
  ENDIF

  _GridEx_SET_DEFAULT_COLUMN_CONTROL (cControlName , cParentForm, nControl)

RETURN NIL


*-----------------------------------------------------------------------------------------*
FUNCTION _GridEx_UpdateCellValue (cControlName, cParentForm, nColIndex)
*-----------------------------------------------------------------------------------------*
LOCAL nColFirst, nColEnd
LOCAL nRow, nCol, xCellValue

   IF Valtype (nColIndex) == "U"   // if nColIndex = NIL update all cell of the GRID
      nColFirst := 1
      nColEnd   := _GridEx_ColumnCount(cControlName,cParentForm)
   ELSE
      nColFirst := nColEnd := nColIndex
   ENDIF

   FOR nRow = 1 TO GetProperty (cParentForm, cControlName, "ItemCount")
       FOR nCol = nColFirst TO nColEnd
           xCellValue := _GridEx_GetCellValue (cControlName, cParentForm, nRow, nCol) // Get Grid xData
           _GridEx_SetCellValue (cControlName, cParentForm, nRow, nCol, xCellValue)   // Transforms xData into the new format if necessary and rewrites in cell
       NEXT
   NEXT

RETURN NIL


*---------------------------------------------------------------------------------------------------*
FUNCTION  _GridEx_GetRawCellValue (cControlName, cParentForm, nItemCount, nColumnCount)
*---------------------------------------------------------------------------------------------------*
LOCAL i, k, aRawItem
   aRawItem := ARRAY (nItemCount)
   FOR i := 1 TO nItemCount
       aRawItem [i] := ARRAY (nColumnCount)
       FOR k := 1 TO nColumnCount
           aRawItem [i] [k] := LISTVIEW_GETITEMTEXT (GetControlHandle(cControlName, cParentForm), i-1, k-1)
       NEXT
   NEXT
RETURN aRawItem


*---------------------------------------------------------------------------------------------------*
FUNCTION  _GridEx_SetRawCellValue (cControlName, cParentForm, nItemCount, nColumnCount, aRawItem)
*---------------------------------------------------------------------------------------------------*
LOCAL i, k
   FOR i := 1 TO nItemCount
       FOR k := 1 TO nColumnCount
           LISTVIEW_SETITEMTEXT (GetControlHandle(cControlName, cParentForm), i-1, k-1, aRawItem [i] [k])
       NEXT
   NEXT
RETURN NIL



// by Dr. Claudio Soto (July 2014)

*-----------------------------------------------------------------------------*
Function _GridEx_DoGridCustomDraw ( i, a, lParam )
*-----------------------------------------------------------------------------*
Local DefaultBackColor := RGB (255, 255, 255)   // WHITE
Local DefaultForeColor := RGB (  0,   0,   0)   // BLACK
Local BackColor  := _HMG_SYSDATA [40] [i] [28]
Local FontColor  := _HMG_SYSDATA [40] [i] [29]
Local nRow := a[1]
Local nCol := a[2]
LOCAL aDynamicBackColor := _HMG_SYSDATA [40] [i] [ _GRID_COLUMN_DYNAMICBACKCOLOR_ ]
LOCAL aDynamicForeColor := _HMG_SYSDATA [40] [i] [ _GRID_COLUMN_DYNAMICFORECOLOR_ ]
LOCAL nRGB_BackColor, nRGB_ForeColor, aRGB
LOCAL CallThisData := .F.
LOCAL hFont

   IF ValType (BackColor) == "A"
      DefaultBackColor := RGB (BackColor[1], BackColor[2], BackColor[3])
   ENDIF

   IF ValType (FontColor) == "A"
      DefaultForeColor := RGB (FontColor[1], FontColor[2], FontColor[3])
   ENDIF

   nRGB_BackColor := DefaultBackColor
   nRGB_ForeColor := DefaultForeColor

   IF ValType (aDynamicBackColor) == "A" .AND. ValType (aDynamicBackColor [nCol]) == "B"
      IF CallThisData == .F.
         CallThisData := .T.
         _GridEx_SetThisGridData (i, nRow, nCol)
      ENDIF

      aRGB := EVAL (aDynamicBackColor [nCol])

      IF ValType (aRGB) == "A"
         nRGB_BackColor := RGB (aRGB[1], aRGB[2], aRGB[3])
      ENDIF
   ENDIF

   IF ValType (aDynamicForeColor) == "A" .AND. (ValType (aDynamicForeColor [nCol]) == "B" .OR. ValType (aDynamicForeColor [nCol]) == "C")
      IF CallThisData == .F.
         CallThisData := .T.
         _GridEx_SetThisGridData (i, nRow, nCol)
      ENDIF
      IF ValType (aDynamicForeColor [nCol]) == "B"
         aRGB := Eval( aDynamicForeColor [nCol] )
      ELSE
         aRGB := HMG_DoProc( aDynamicForeColor [nCol] )
      ENDIF
      IF ValType (aRGB) == "A"
         nRGB_ForeColor := RGB (aRGB[1], aRGB[2], aRGB[3])
      ENDIF
   ENDIF

   hFont := _GridEx_DoGridCustomDrawFont ( i, a, lParam, CallThisData )

Return GRID_SetBCFC (lParam , nRGB_BackColor, nRGB_ForeColor, hFont)



*-----------------------------------------------------------------------------*
Function _GridEx_DoGridCustomDrawFont ( i, a, lParam, lCallThisData )
*-----------------------------------------------------------------------------*
LOCAL cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeOut
LOCAL hFontDynamic
LOCAL nRow := a[1]
LOCAL nCol := a[2]
LOCAL aDynamicFont := _HMG_SYSDATA [40] [i] [ _GRID_COLUMN_DYNAMICFONT_ ]
LOCAL DynamicData
LOCAl DefaultFontHandle := _HMG_SYSDATA [36] [i]

   IF ValType (aDynamicFont) == "A" .AND. ValType (aDynamicFont [nCol]) == "B"

      IF lCallThisData == .F.
         _GridEx_SetThisGridData (i, nRow, nCol)
      ENDIF

      DynamicData := EVAL (aDynamicFont [nCol])

      IF ValType (DynamicData) == "A"
         IF HMG_LEN (DynamicData) < 6
            ASIZE (DynamicData, 6 )   // { cFontName, nFontSize, [ lBold, lItalic, lUnderline, lStrikeOut ] }
         ENDIF

         IF ValType (DynamicData [1]) == "C" .AND. .NOT. Empty(DynamicData [1]) .AND. ValType (DynamicData [2]) == "N" .AND. DynamicData [2] > 0
            cFontName  := DynamicData [1]
            nFontSize  := DynamicData [2]
            lBold      := DynamicData [3]
            lItalic    := DynamicData [4]
            lUnderline := DynamicData [5]
            lStrikeOut := DynamicData [6]

            hFontDynamic := _HMG_SYSDATA [40] [i] [42]
            IF hFontDynamic <> 0
               DeleteObject (hFontDynamic)
            ENDIF

            hFontDynamic := HMG_CreateFont (ListView_CustomDraw_GetHDC (lParam), cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeOut )
            _HMG_SYSDATA [40] [i] [42] := hFontDynamic
            RETURN hFontDynamic   // <=== return new handle
         ENDIF

      ENDIF
   ENDIF

Return DefaultFontHandle


*-----------------------------------------------------------------------------*
PROCEDURE _GridEx_SetThisGridData (i, nRow, nCol)
*-----------------------------------------------------------------------------*
LOCAL xThisValue ,cControlName, cParentForm

   IF _HMG_SYSDATA [40] [i] [9] == .T.   // OWNERDATA
      xThisValue   := _GridEx_GetCellVirtualValueByIndex ( i, nRow , nCol )
   ELSE
      cControlName := _HMG_SYSDATA [ 2 ]  [ i ]
      cParentForm  := _HMG_SYSDATA [ 40 ] [ i ] [ 40 ]
      xThisValue   := _GridEx_GetCellValue (cControlName, cParentForm, nRow, nCol)
   ENDIF

   _HMG_SYSDATA [ 195 ] := nRow         // This.CellRowIndex
   _HMG_SYSDATA [ 196 ] := nCol         // This.CellColIndex
   _HMG_SYSDATA [ 318 ] := xThisValue   // This.CellValue

RETURN


*-----------------------------------------------------------------------------*
Function _GridEx_GetCellVirtualValueByIndex ( i, nRow , nCol )
*-----------------------------------------------------------------------------*
   _HMG_SYSDATA [ 201 ] := nRow        // This.QueryRowIndex
   _HMG_SYSDATA [ 202 ] := nCol        // This.QueryColIndex

   IF ValType ( _HMG_SYSDATA [ 40 ] [ i ] [ 10 ] ) == 'C' .AND. Used() == .T.   // RecordSource
      GetDataGridCellData (i, .T.)   // ADD    March 2015
   ELSEIF ValType (_HMG_SYSDATA [6] [i]) == 'B'
      EVAL (_HMG_SYSDATA [6] [i])      // OnQueryData Event
   ENDIF
Return _HMG_SYSDATA [ 230 ]            // This.QueryData




*-----------------------------------------------------------------------------*
Function _GridEx_DoHeaderCustomDraw ( i, lParam, nCol )
*-----------------------------------------------------------------------------*
#define COLOR_BTNFACE   15   // ok
Local DefaultBackColor := GetSysColor ( COLOR_BTNFACE )
Local DefaultForeColor := RGB (  0,   0,   0)   // BLACK
LOCAL aHeaderBackColor := _HMG_SYSDATA [40] [i] [ _GRID_COLUMN_HEADERBACKCOLOR_ ]   // Not work
LOCAL aHeaderForeColor := _HMG_SYSDATA [40] [i] [ _GRID_COLUMN_HEADERFORECOLOR_ ]
LOCAL nRGB_BackColor, nRGB_ForeColor, aRGB
LOCAL hFont

   _HMG_SYSDATA [ 195 ] := 0      // This.CellRowIndex
   _HMG_SYSDATA [ 196 ] := nCol   // This.CellColIndex
// _HMG_SYSDATA [ 318 ] := NIL    // This.CellValue

   nRGB_BackColor := DefaultBackColor
   nRGB_ForeColor := DefaultForeColor

   IF ValType (aHeaderBackColor) == "A" .AND. ValType (aHeaderBackColor [nCol]) == "B"
      aRGB := EVAL (aHeaderBackColor [nCol])
      IF ValType (aRGB) == "A"
         nRGB_BackColor := RGB (aRGB[1], aRGB[2], aRGB[3])
      ENDIF
   ENDIF

   IF ValType (aHeaderForeColor) == "A" .AND. ValType (aHeaderForeColor [nCol]) == "B"
      aRGB := EVAL (aHeaderForeColor [nCol])
      IF ValType (aRGB) == "A"
         nRGB_ForeColor := RGB (aRGB[1], aRGB[2], aRGB[3])
      ENDIF
   ENDIF

   hFont := _GridEx_DoHeaderCustomDrawFont ( i, lParam, nCol )

Return HEADER_SetFont (lParam , nRGB_BackColor, nRGB_ForeColor, hFont)


*-----------------------------------------------------------------------------*
Function _GridEx_DoHeaderCustomDrawFont ( i, lParam, nCol )
*-----------------------------------------------------------------------------*
LOCAL cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeOut
LOCAL hFont
LOCAL aHeaderFont := _HMG_SYSDATA [40] [i] [ _GRID_COLUMN_HEADERFONT_ ]
LOCAL DynamicData
LOCAl DefaultFontHandle := _HMG_SYSDATA [36] [i]

   IF ValType (aHeaderFont) == "A" .AND. ValType (aHeaderFont [nCol]) == "B"
      DynamicData := EVAL (aHeaderFont [nCol])

      IF ValType (DynamicData) == "A"
         IF HMG_LEN (DynamicData) < 6
            ASIZE (DynamicData, 6 )   // { cFontName, nFontSize, [ lBold, lItalic, lUnderline, lStrikeOut ] }
         ENDIF

         IF ValType (DynamicData [1]) == "C" .AND. .NOT. Empty(DynamicData [1]) .AND. ValType (DynamicData [2]) == "N" .AND. DynamicData [2] > 0
            cFontName  := DynamicData [1]
            nFontSize  := DynamicData [2]
            lBold      := DynamicData [3]
            lItalic    := DynamicData [4]
            lUnderline := DynamicData [5]
            lStrikeOut := DynamicData [6]

            hFont := _HMG_SYSDATA [40] [i] [42]
            IF hFont <> 0
               DeleteObject (hFont)
            ENDIF

            hFont := HMG_CreateFont (Header_CustomDraw_GetHDC (lParam), cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeOut )
            _HMG_SYSDATA [40] [i] [42] := hFont
            RETURN hFont   // <=== return new handle
         ENDIF

      ENDIF
   ENDIF

Return DefaultFontHandle



FUNCTION SetGridCustomDrawNewBehavior ( lValue )
LOCAL i, OldValue := _HMG_SYSDATA [ 514 ]
   IF ValType ( lValue ) == "L"
      _HMG_SYSDATA [ 514 ] := lValue
      i := ASCAN ( _HMG_SYSDATA [ 3 ], GetFocus () )
      IF i > 0 .AND. ( _HMG_SYSDATA [ 1 ] [ i ] == 'GRID' .OR. _HMG_SYSDATA [ 1 ] [ i ] == 'MULTIGRID' )
         SetEventProcessHMGWindowsMessage ( .NOT. lValue )
      ENDIF
   ENDIF
RETURN OldValue



*******************************************************************************************


PROCEDURE _GridEx_CheckBoxAllItems ( cControlName, cParentName, lCheck )
LOCAL i
   FOR i := 1 TO GetProperty (cParentName ,cControlName, "ItemCount")
      SetProperty (cParentName ,cControlName, "CheckBoxItem", i, lCheck )
   NEXT
RETURN


PROCEDURE _GridEx_GroupDeleteAllItems ( cControlName, cParentName, nGroupID )
LOCAL i
   IF GetProperty (cParentName ,cControlName, "GroupExist", nGroupID) == .T.
      FOR i := 1 TO GetProperty (cParentName ,cControlName, "ItemCount")
         IF GetProperty (cParentName ,cControlName, "GroupItemID", i) == nGroupID
            DoMethod (cParentName ,cControlName, "DeleteItem", i)
         ENDIF
      NEXT
   ENDIF
RETURN


FUNCTION _GridEx_GroupGetAllItemIndex ( cControlName, cParentName, nGroupID )
LOCAL i, aItemIndex := {}
   IF GetProperty (cParentName ,cControlName, "GroupExist", nGroupID) == .T.
      FOR i := 1 TO GetProperty (cParentName ,cControlName, "ItemCount")
         IF GetProperty (cParentName ,cControlName, "GroupItemID", i) == nGroupID
            AADD (aItemIndex, i)
         ENDIF
      NEXT
   ENDIF
RETURN aItemIndex


PROCEDURE _GridEx_GroupCheckBoxAllItems ( cControlName, cParentName, nGroupID, lCheck )
LOCAL i, aItemIndex := _GridEx_GroupGetAllItemIndex ( cControlName, cParentName, nGroupID )
   IF GetProperty (cParentName ,cControlName, "GroupExist", nGroupID) == .T.
      FOR i := 1 TO HMG_LEN (aItemIndex)
         SetProperty (cParentName ,cControlName, "CheckBoxItem", aItemIndex [i], lCheck )
      NEXT
   ENDIF
RETURN


