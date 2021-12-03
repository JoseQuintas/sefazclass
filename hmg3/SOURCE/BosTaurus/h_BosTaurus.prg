
/*----------------------------------------------------------------------------
 BOS TAURUS - Graphic Library for HMG

 Copyright 2012-2017 by Dr. Claudio Soto (from Uruguay).
 mail: <srvet@adinet.com.uy>
 blog: http://srvet.blogspot.com

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor Boston, MA 02110-1301, USA
 (or visit their web site at http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of BOS TAURUS.

 The exception is that, if you link the BOS TAURUS library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 BOS TAURUS library code into it.
----------------------------------------------------------------------------*/


*******************************************************************************
* ARCHIVO:  BosTaurus.prg
* LENGUAJE: HMG
* FECHA:    Setiembre 2012
* AUTOR:    Dr. CLAUDIO SOTO
* PAIS:     URUGUAY
* E-MAIL:   srvet@adinet.com.uy
* BLOG:     http://srvet.blogspot.com
*******************************************************************************


#include "hmg.ch"
//#include "BosTaurus.CH"


#ifdef _HMG_OFFICIAL_
   MEMVAR _HMG_SYSDATA
#endif


// **********************************************************************************************************************************
//  INTERNAL Functions PRG
// **********************************************************************************************************************************



Function bt_WinHandle (Win)
   LOCAL hWnd := IF (ValType(Win)=="N", Win, GetFormHandle(Win))
Return hWnd



Function bt_FillRectIsNIL (Row, Col, Width, Height, Row_value, Col_value, Width_value, Height_value)
   Row    := IF (Valtype(Row)    =="U",  Row_value,    Row)
   Col    := IF (Valtype(Col)    =="U",  Col_value,    Col)
   Width  := IF (Valtype(Width)  =="U",  Width_value,  Width)
   Height := IF (Valtype(Height) =="U",  Height_value, Height)
Return Nil



Function bt_AdjustWidthHeightRect (Row, Col, Width, Height, Max_Width, Max_Height)
   Width  := IF ((Col + Width  > Max_Width),  (Max_Width  - Col), Width)
   Height := IF ((Row + Height > Max_Height), (Max_Height - Row), Height)
Return Nil



Function bt_ListCalledFunctions (nActivation)
   LOCAL cMsg := ""
   nActivation := IF (ValType(nActivation) <> "N", 1, nActivation)
   DO WHILE .NOT.(PROCNAME(nActivation) == "")
      cMsg := cMsg + "Called from:" + PROCNAME(nActivation) + "(" + LTRIM(STR(PROCLINE(nActivation))) + ")" + CRLF
      nActivation++
   ENDDO
Return cMsg





// **********************************************************************************************************************************
// * BT INFO
// **********************************************************************************************************************************



Function BT_InfoName ()
Return (Alltrim(_BT_INFO_NAME_))


Function BT_InfoVersion ()
Return (Alltrim(Str(_BT_INFO_MAJOR_VERSION_))+"."+Alltrim(Str(_BT_INFO_MINOR_VERSION_))+"."+Alltrim(Str(_BT_INFO_PATCHLEVEL_)))


Function BT_InfoAuthor ()
Return (Alltrim(_BT_INFO_AUTHOR_))





// **********************************************************************************************************************************
// * Handle DC
// **********************************************************************************************************************************



Function BT_CreateDC (Win_or_hBitmap, Type, BTstruct)
   LOCAL Handle, hDc
   DO CASE
      CASE Type = BT_HDC_DESKTOP
           Handle := 0
      CASE Type = BT_HDC_BITMAP
           Handle := Win_or_hBitmap
      OTHERWISE
           Handle := bt_WinHandle (Win_or_hBitmap)
   END CASE
   BTstruct := BT_DC_CREATE (Type, Handle)
   hDC := BTstruct [3]
Return hDC


Function BT_DeleteDC (BTstruct)
   LOCAL lRet
   IF Valtype(BTstruct)<> "A"
      MsgBox ("Error in call to "+PROCNAME()+": The second parameter is not an array" + CRLF + bt_ListCalledFunctions(2),"BT Fatal Error")
      RELEASE WINDOW ALL
   ELSEIF Len(BTstruct)  <>  50
      MsgBox ("Error in call to "+PROCNAME()+": The second parameter is an corrupted array " + CRLF + bt_ListCalledFunctions(2),"BT Fatal Error")
      RELEASE WINDOW ALL
   ENDIF
   lRet:= BT_DC_DELETE (BTstruct)
Return lRet





// **********************************************************************************************************************************
//  DRAW Functions
// **********************************************************************************************************************************





//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function BT_DrawGetPixel (hDC, Row, Col)
   LOCAL aRGBcolor
   aRGBcolor = BT_DRAW_HDC_PIXEL (hDC, Col, Row, BT_HDC_GETPIXEL, 0)
Return aRGBcolor

Function BT_DrawSetPixel (hDC, Row, Col, aRGBcolor)
    LOCAL aRGBcolor_Old
    aRGBcolor_Old = BT_DRAW_HDC_PIXEL (hDC, Col, Row, BT_HDC_SETPIXEL, ArrayRGB_TO_COLORREF(aRGBcolor))
Return aRGBcolor_Old

//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function BT_DrawBitmap (hDC, Row, Col, Width, Height, Mode_Stretch, hBitmap)
   LOCAL Width2  := BT_BMP_GETINFO (hBitmap, BT_BITMAP_INFO_WIDTH)
   LOCAL Height2 := BT_BMP_GETINFO (hBitmap, BT_BITMAP_INFO_HEIGHT)
   bt_FillRectIsNIL (@Row, @Col, @Width, @Height, 0, 0, Width2, Height2)
   BT_DRAW_HDC_BITMAP (hDC, Col, Row, Width, Height, hBitmap, 0, 0, Width2, Height2, Mode_Stretch, BT_BITMAP_OPAQUE, 0)
Return Nil


Function BT_DrawBitmapTransparent (hDC, Row, Col, Width, Height, Mode_Stretch, hBitmap, aRGBcolor_transp)
   LOCAL ColorRef_Transp:= IF (Valtype(aRGBcolor_transp) == "U", BT_BMP_GETINFO(hBitmap, BT_BITMAP_INFO_GETCOLORPIXEL, 0, 0), ArrayRGB_TO_COLORREF(aRGBcolor_transp))
   LOCAL Width2  := BT_BMP_GETINFO (hBitmap, BT_BITMAP_INFO_WIDTH)
   LOCAL Height2 := BT_BMP_GETINFO (hBitmap, BT_BITMAP_INFO_HEIGHT)
   bt_FillRectIsNIL (@Row, @Col, @Width, @Height, 0, 0, Width2, Height2)
   BT_DRAW_HDC_BITMAP (hDC, Col, Row, Width, Height, hBitmap, 0, 0, Width2, Height2, Mode_Stretch, BT_BITMAP_TRANSPARENT, ColorRef_Transp)
Return Nil


Function BT_DrawBitmapAlphaBlend (hDC, Row, Col, Width, Height, Alpha, Mode_Stretch, hBitmap)
   LOCAL Width2  := BT_BMP_GETINFO (hBitmap, BT_BITMAP_INFO_WIDTH)
   LOCAL Height2 := BT_BMP_GETINFO (hBitmap, BT_BITMAP_INFO_HEIGHT)
   bt_FillRectIsNIL (@Row, @Col, @Width, @Height, 0, 0, Width2, Height2)
   BT_DRAW_HDC_BITMAPALPHABLEND (hDC, Col, Row, Width, Height, hBitmap, 0, 0, Width2, Height2, Alpha, Mode_Stretch)
Return Nil



//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function BT_DrawDCtoDC (hDC1, Row1, Col1, Width1, Height1, Mode_Stretch, hDC2, Row2, Col2, Width2, Height2)
   BT_DRAW_HDC_TO_HDC (hDC1, Col1, Row1, Width1, Height1, hDC2, Col2, Row2, Width2, Height2, Mode_Stretch, BT_HDC_OPAQUE, 0)
Return Nil


Function BT_DrawDCtoDCTransparent (hDC1, Row1, Col1, Width1, Height1, Mode_Stretch, hDC2, Row2, Col2, Width2, Height2, aRGBcolor_transp)
   LOCAL ColorRef_Transp:= IF (Valtype(aRGBcolor_transp) == "U", ArrayRGB_TO_COLORREF(BT_DrawGetPixel(hDC2,0,0)), ArrayRGB_TO_COLORREF(aRGBcolor_transp))
   BT_DRAW_HDC_TO_HDC (hDC1, Col1, Row1, Width1, Height1, hDC2, Col2, Row2, Width2, Height2, Mode_Stretch, BT_HDC_TRANSPARENT, ColorRef_Transp)
Return Nil

Function BT_DrawDCtoDCAlphaBlend (hDC1, Row1, Col1, Width1, Height1, Alpha, Mode_Stretch, hDC2, Row2, Col2, Width2, Height2)
   BT_DRAW_HDC_TO_HDC_ALPHABLEND (hDC1, Col1, Row1, Width1, Height1, hDC2, Col2, Row2, Width2, Height2, Alpha, Mode_Stretch)
Return Nil

//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function BT_DrawGradientFillHorizontal (hDC, Row, Col, Width, Height, aColorRGBstart, aColorRGBend)
   aColorRGBstart := IF (ValType(aColorRGBstart)  == "U", BLACK, aColorRGBstart)
   aColorRGBend   := IF (ValType(aColorRGBend)    == "U", WHITE, aColorRGBend)
   BT_DRAW_HDC_GRADIENTFILL (hDC, Col, Row, Width, Height, ArrayRGB_TO_COLORREF(aColorRGBstart), ArrayRGB_TO_COLORREF(aColorRGBend), BT_GRADIENTFILL_HORIZONTAL)
Return Nil


Function BT_DrawGradientFillVertical (hDC, Row, Col, Width, Height, aColorRGBstart, aColorRGBend)
   aColorRGBstart := IF (ValType(aColorRGBstart)  == "U", WHITE, aColorRGBstart)
   aColorRGBend   := IF (ValType(aColorRGBend)    == "U", BLACK, aColorRGBend)
   BT_DRAW_HDC_GRADIENTFILL (hDC, Col, Row, Width, Height, ArrayRGB_TO_COLORREF(aColorRGBstart), ArrayRGB_TO_COLORREF(aColorRGBend), BT_GRADIENTFILL_VERTICAL)
Return Nil



//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function BT_DrawText (hDC, Row, Col, cText, cFontName, nFontSize, aFontColor, aBackColor, nTypeText, nAlingText, nOrientation)
   aFontColor   := IF (ValType(aFontColor)   == "U", BLACK,                        aFontColor)
   aBackColor   := IF (ValType(aBackColor)   == "U", WHITE,                        aBackColor)
   nTypeText    := IF (ValType(nTypeText)    == "U", BT_TEXT_OPAQUE,               nTypeText)
   nAlingText   := IF (ValType(nAlingText)   == "U", (BT_TEXT_LEFT + BT_TEXT_TOP), nAlingText)
   nOrientation := IF (ValType(nOrientation) == "U", BT_TEXT_NORMAL_ORIENTATION,   nOrientation)
   BT_DRAW_HDC_TEXTOUT (hDC, Col, Row, cText, cFontName, nFontSize, ArrayRGB_TO_COLORREF(aFontColor), ArrayRGB_TO_COLORREF(aBackColor), nTypeText, nAlingText, nOrientation)
Return Nil


Function BT_DrawTextEx (hDC, Row, Col, Width, Height, cText, cFontName, nFontSize, aFontColor, aBackColor, nTypeText, nAlingText, nOrientation)
   aFontColor   := IF (ValType(aFontColor)   == "U", BLACK,                        aFontColor)
   aBackColor   := IF (ValType(aBackColor)   == "U", WHITE,                        aBackColor)
   nTypeText    := IF (ValType(nTypeText)    == "U", BT_TEXT_OPAQUE,               nTypeText)
   nAlingText   := IF (ValType(nAlingText)   == "U", (BT_TEXT_LEFT + BT_TEXT_TOP), nAlingText)
   nOrientation := IF (ValType(nOrientation) == "U", BT_TEXT_NORMAL_ORIENTATION,   nOrientation)
   BT_DRAW_HDC_DRAWTEXT (hDC, Col, Row, Width, Height, cText, cFontName, nFontSize, ArrayRGB_TO_COLORREF(aFontColor), ArrayRGB_TO_COLORREF(aBackColor), nTypeText, nAlingText, nOrientation)
Return Nil


Function BT_DrawTextSize (hDC, cText, cFontName, nFontSize, nTypeText)
LOCAL aSize := BT_DRAW_HDC_TEXTSIZE (hDC, cText, cFontName, nFontSize, nTypeText)
Return aSize


//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function BT_DrawPolyLine (hDC, aPointY, aPointX, aColorRGBLine, nWidthLine)
   nWidthLine := IF (Valtype (nWidthLine) == "U", 1, nWidthLine)
   BT_DRAW_HDC_POLY (hDC, aPointX, aPointY, ArrayRGB_TO_COLORREF(aColorRGBLine), nWidthLine, 0, BT_DRAW_POLYLINE)
Return Nil


Function BT_DrawPolygon (hDC, aPointY, aPointX, aColorRGBLine, nWidthLine, aColorRGBFill)
   nWidthLine := IF (Valtype (nWidthLine) == "U", 1, nWidthLine)
   BT_DRAW_HDC_POLY (hDC, aPointX, aPointY, ArrayRGB_TO_COLORREF(aColorRGBLine), nWidthLine, ArrayRGB_TO_COLORREF(aColorRGBFill), BT_DRAW_POLYGON)
Return Nil


Function BT_DrawPolyBezier (hDC, aPointY, aPointX, aColorRGBLine, nWidthLine)
   nWidthLine := IF (Valtype (nWidthLine) == "U", 1, nWidthLine)
   BT_DRAW_HDC_POLY (hDC, aPointX, aPointY, ArrayRGB_TO_COLORREF(aColorRGBLine), nWidthLine, 0, BT_DRAW_POLYBEZIER)
Return Nil


Function BT_DrawArc (hDC, Row1, Col1, Row2, Col2, RowStartArc, ColStartArc, RowEndArc, ColEndArc, aColorRGBLine, nWidthLine)
   nWidthLine := IF (Valtype (nWidthLine) == "U", 1, nWidthLine)
   BT_DRAW_HDC_ARCX (hDC, Col1, Row1, Col2, Row2, ColStartArc, RowStartArc, ColEndArc, RowEndArc, ArrayRGB_TO_COLORREF(aColorRGBLine), nWidthLine, 0, BT_DRAW_ARC)
Return Nil


Function BT_DrawChord (hDC, Row1, Col1, Row2, Col2, RowStartArc, ColStartArc, RowEndArc, ColEndArc, aColorRGBLine, nWidthLine, aColorRGBFill)
   nWidthLine := IF (Valtype (nWidthLine) == "U", 1, nWidthLine)
   BT_DRAW_HDC_ARCX (hDC, Col1, Row1, Col2, Row2, ColStartArc, RowStartArc, ColEndArc, RowEndArc, ArrayRGB_TO_COLORREF(aColorRGBLine), nWidthLine, ArrayRGB_TO_COLORREF(aColorRGBFill), BT_DRAW_CHORD)
Return Nil


Function BT_DrawPie (hDC, Row1, Col1, Row2, Col2, RowStartArc, ColStartArc, RowEndArc, ColEndArc, aColorRGBLine, nWidthLine, aColorRGBFill)
   nWidthLine := IF (Valtype (nWidthLine) == "U", 1, nWidthLine)
   BT_DRAW_HDC_ARCX (hDC, Col1, Row1, Col2, Row2, ColStartArc, RowStartArc, ColEndArc, RowEndArc, ArrayRGB_TO_COLORREF(aColorRGBLine), nWidthLine, ArrayRGB_TO_COLORREF(aColorRGBFill), BT_DRAW_PIE)
Return Nil


Function BT_DrawLine (hDC, Row1, Col1, Row2, Col2, aColorRGBLine, nWidthLine)
   LOCAL aPointX := {Col1, Col2}
   LOCAL aPointY := {Row1, Row2}
   nWidthLine := IF (Valtype (nWidthLine) == "U", 1, nWidthLine)
   BT_DrawPolyLine (hDC, aPointY, aPointX, aColorRGBLine, nWidthLine)
Return Nil


Function BT_DrawRectangle (hDC, Row, Col, Width, Height, aColorRGBLine, nWidthLine)
   LOCAL aPointX := Array (5)
   LOCAL aPointY := Array (5)
   aPointX[1]:= Col;          aPointY[1]:= Row
   aPointX[2]:= Col+Width;    aPointY[2]:= Row
   aPointX[3]:= Col+Width;    aPointY[3]:= Row+Height
   aPointX[4]:= Col;          aPointY[4]:= Row+Height
   aPointX[5]:= Col;          aPointY[5]:= Row
   nWidthLine := IF (Valtype (nWidthLine) == "U", 1, nWidthLine)
   BT_DrawPolyLine (hDC, aPointY, aPointX, aColorRGBLine, nWidthLine)
Return Nil


Function BT_DrawEllipse (hDC, Row1, Col1, Width, Height, aColorRGBLine, nWidthLine)
   LOCAL ColStartArc, ColEndArc
   LOCAL RowStartArc, RowEndArc
   LOCAL Col2, Row2
   Col2 := Col1 + Width
   Row2 := Row1 + Height
   ColStartArc := ColEndArc := Col1
   RowStartArc := RowEndArc := Row1
   nWidthLine := IF (Valtype (nWidthLine) == "U", 1, nWidthLine)
   BT_DrawArc (hDC, Row1, Col1, Row2, Col2, RowStartArc, ColStartArc, RowEndArc, ColEndArc, aColorRGBLine, nWidthLine)
Return Nil



//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function BT_DrawFillRectangle (hDC, Row, Col, Width, Height, aColorRGBFill, aColorRGBLine, nWidthLine)
   aColorRGBLine := IF (Valtype (nWidthLine) == "U", aColorRGBFill, aColorRGBLine)
   nWidthLine := IF (Valtype (nWidthLine) == "U", 1, nWidthLine)
   BT_DRAW_HDC_FILLEDOBJECT (hDC, Col, Row, Width, Height, ArrayRGB_TO_COLORREF(aColorRGBFill), ArrayRGB_TO_COLORREF(aColorRGBLine), nWidthLine, BT_FILLRECTANGLE, 0, 0)
Return Nil


Function BT_DrawFillEllipse (hDC, Row, Col, Width, Height, aColorRGBFill, aColorRGBLine, nWidthLine)
   aColorRGBLine := IF (Valtype (nWidthLine) == "U", aColorRGBFill, aColorRGBLine)
   nWidthLine := IF (Valtype (nWidthLine) == "U", 1, nWidthLine)
   BT_DRAW_HDC_FILLEDOBJECT (hDC, Col, Row, Width, Height, ArrayRGB_TO_COLORREF(aColorRGBFill), ArrayRGB_TO_COLORREF(aColorRGBLine), nWidthLine, BT_FILLELLIPSE, 0, 0)
Return Nil


Function BT_DrawFillRoundRect (hDC, Row, Col, Width, Height, RoundWidth, RoundHeight, aColorRGBFill, aColorRGBLine, nWidthLine)
   aColorRGBLine := IF (Valtype (nWidthLine) == "U", aColorRGBFill, aColorRGBLine)
   nWidthLine := IF (Valtype (nWidthLine) == "U", 1, nWidthLine)
   BT_DRAW_HDC_FILLEDOBJECT (hDC, Col, Row, Width, Height, ArrayRGB_TO_COLORREF(aColorRGBFill), ArrayRGB_TO_COLORREF(aColorRGBLine), nWidthLine, BT_FILLROUNDRECT, RoundWidth, RoundHeight)
Return Nil


Function BT_DrawFillFlood (hDC, Row, Col, aColorRGBFill)
   BT_DRAW_HDC_FILLEDOBJECT (hDC, Col, Row, NIL, NIL, ArrayRGB_TO_COLORREF(aColorRGBFill), NIL, NIL, BT_FILLFLOOD, NIL, NIL)
Return Nil



//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function BT_GetDesktopHandle ()
Return BT_SCR_GETDESKTOPHANDLE ()


Function BT_DesktopWidth ()
   LOCAL Width := BT_SCR_GETINFO (0, BT_SCR_DESKTOP, BT_SCR_INFO_WIDTH)
Return Width


Function BT_DesktopHeight ()
  // LOCAL Win := BT_GetDesktopHandle ()   Variable 'WIN' is assigned but not used in function
  LOCAL Height := BT_SCR_GETINFO (0, BT_SCR_DESKTOP, BT_SCR_INFO_HEIGHT)
Return Height


Function BT_WindowWidth (Win)
   LOCAL Width := BT_SCR_GETINFO (bt_WinHandle(Win), BT_SCR_WINDOW, BT_SCR_INFO_WIDTH)
Return Width


Function BT_WindowHeight (Win)
  LOCAL Height := BT_SCR_GETINFO (bt_WinHandle(Win), BT_SCR_WINDOW, BT_SCR_INFO_HEIGHT)
Return Height


Function BT_ClientAreaWidth (Win)
   LOCAL Width := BT_SCR_GETINFO (bt_WinHandle(Win), BT_SCR_CLIENTAREA, BT_SCR_INFO_WIDTH)
Return Width


Function BT_ClientAreaHeight (Win)
   LOCAL Height := BT_SCR_GETINFO (bt_WinHandle(Win), BT_SCR_CLIENTAREA, BT_SCR_INFO_HEIGHT)
Return Height



//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function bt_StatusBarHandle (Win)
   LOCAL hWnd := bt_WinHandle (Win)
   LOCAL k, hWndStatusBar := 0
   FOR k := 1 TO HMG_LEN (_HMG_SYSDATA [1])
       IF _HMG_SYSDATA [1] [k] == "STATUSBAR" .AND. _HMG_SYSDATA [4] [k] == hWnd
          hWndStatusBar := _HMG_SYSDATA [3] [k]
       ENDIF
   NEXT
Return hWndStatusBar


Function BT_StatusBarWidth (Win)
   LOCAL hWnd := bt_StatusBarHandle (Win)
   LOCAL Width :=0
   IF hWnd <> 0
      Width := BT_SCR_GETINFO (hWnd, BT_SCR_WINDOW, BT_SCR_INFO_WIDTH)
   ENDIF
Return Width


Function BT_StatusBarHeight (Win)
   LOCAL hWnd := bt_StatusBarHandle (Win)
   LOCAL Height :=0
   IF hWnd > 0
      Height := BT_SCR_GETINFO (hWnd, BT_SCR_WINDOW, BT_SCR_INFO_HEIGHT)
   ENDIF
Return Height



//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function bt_ToolBarBottomHandle (Win)
   LOCAL hWnd := bt_WinHandle (Win)
   LOCAL k, hWndToolBar := 0
   FOR k := 1 TO HMG_LEN (_HMG_SYSDATA [1])
       IF _HMG_SYSDATA [1] [k] == "TOOLBAR" .AND. _HMG_SYSDATA [4] [k] == hWnd .AND. _HMG_SYSDATA [18] [k] == .T. .AND. _HMG_SYSDATA [19] [k] == .F.
          hWndToolBar := _HMG_SYSDATA [3] [k]
       ENDIF
   NEXT
Return hWndToolBar


Function BT_ToolBarBottomHeight (Win)
   LOCAL hWnd := bt_ToolBarBottomHandle (bt_WinHandle (Win))
   LOCAL nHeight := 0
   IF hWnd <> 0
      nHeight := BT_SCR_GETINFO (hWnd, BT_SCR_WINDOW, BT_SCR_INFO_HEIGHT)
   ENDIF
Return nHeight


Function BT_ToolBarBottomWidth (Win)
   LOCAL hWnd := bt_ToolBarBottomHandle (bt_WinHandle (Win))
   LOCAL nWidth := 0
   IF hWnd <> 0
      nWidth := BT_SCR_GETINFO (hWnd, BT_SCR_WINDOW, BT_SCR_INFO_WIDTH)
   ENDIF
Return nWidth



//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function bt_ToolBarTopHandle (Win)
   LOCAL hWnd := bt_WinHandle (Win)
   LOCAL k, hWndToolBar := 0
   FOR k := 1 TO HMG_LEN (_HMG_SYSDATA [1])
       IF _HMG_SYSDATA [1] [k] == "TOOLBAR" .AND. _HMG_SYSDATA [4] [k] == hWnd .AND. _HMG_SYSDATA [18] [k] == .F. .AND. _HMG_SYSDATA [19] [k] == .F.
          hWndToolBar := _HMG_SYSDATA [3] [k]
       ENDIF
   NEXT
Return hWndToolBar


Function BT_ToolBarTopHeight (Win)
   LOCAL hWnd := bt_ToolBarTopHandle (bt_WinHandle (Win))
   LOCAL nHeight := 0
   IF hWnd <> 0
      nHeight := BT_SCR_GETINFO (hWnd, BT_SCR_WINDOW, BT_SCR_INFO_HEIGHT)
   ENDIF
Return nHeight


Function BT_ToolBarTopWidth (Win)
   LOCAL hWnd := bt_ToolBarTopHandle (bt_WinHandle (Win))
   LOCAL nWidth := 0
   IF hWnd <> 0
      nWidth := BT_SCR_GETINFO (hWnd, BT_SCR_WINDOW, BT_SCR_INFO_WIDTH)
   ENDIF
Return nWidth



//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function BT_ClientAreaInvalidateAll (Win, lErase)
   lErase = IF (Valtype(lErase) == "U", .F., lErase)
   BT_SCR_INVALIDATERECT (bt_WinHandle(Win), NIL, lErase)
Return Nil


Function BT_ClientAreaInvalidateRect (Win, Row, Col, Width, Height, lErase)
   lErase = IF (Valtype(lErase) == "U", .F., lErase)
   bt_FillRectIsNIL (@Row, @Col, @Width, @Height, 0, 0, BT_ClientAreaWidth(Win), BT_ClientAreaHeight(Win))
   BT_SCR_INVALIDATERECT (bt_WinHandle(Win), {Col, Row, Col+Width, Row+Height}, lErase)
Return Nil





// **********************************************************************************************************************************
//  BITMAP  Functions
// **********************************************************************************************************************************





//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function BT_BitmapIsValidFileImage( cFileName )
LOCAL lRet := .F.
LOCAL hBitmap := BT_BitmapLoadFile( cFileName )
   IF hBitmap <> 0
      BT_BitmapRelease ( hBitmap )
      lRet := .T.
   ENDIF
Return lRet


Function BT_BitmapLoadFile (cFileName)
   LOCAL hBitmap := BT_BMP_LOADFILE (cFileName)
Return hBitmap


Function BT_BitmapSaveFile (hBitmap, cFileName, nTypePicture)
   LOCAL lRet
   nTypePicture := IF (Valtype(nTypePicture) == "U", BT_FILEFORMAT_BMP, nTypePicture)
   lRet := BT_BMP_SAVEFILE (hBitmap, cFileName, nTypePicture)
Return lRet



//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function BT_BitmapCreateNew (Width, Height, aRGBcolor_Fill_Bk)
   LOCAL New_hBitmap
   aRGBcolor_Fill_Bk := IF (Valtype(aRGBColor_Fill_Bk) == "U", BLACK, aRGBcolor_Fill_Bk)
   New_hBitmap := BT_BMP_CREATE (Width, Height, ArrayRGB_TO_COLORREF(aRGBColor_Fill_Bk))
Return New_hBitmap


Function BT_BitmapRelease (hBitmap)
   BT_BMP_RELEASE (hBitmap)
Return Nil



//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function BT_BitmapWidth (hBitmap)
   LOCAL Width := BT_BMP_GETINFO (hBitmap, BT_BITMAP_INFO_WIDTH)
Return Width


Function BT_BitmapHeight (hBitmap)
   LOCAL Height := BT_BMP_GETINFO (hBitmap, BT_BITMAP_INFO_HEIGHT)
Return Height


Function BT_BitmapBitsPerPixel (hBitmap)
   LOCAL BitsPixel := BT_BMP_GETINFO (hBitmap, BT_BITMAP_INFO_BITSPIXEL)
Return BitsPixel



//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function BT_BitmapInvert (hBitmap)
   BT_BMP_PROCESS (hBitmap, BT_BMP_PROCESS_INVERT)
Return Nil

Function BT_BitmapGrayness (hBitmap, Gray_Level)
   BT_BMP_PROCESS (hBitmap, BT_BMP_PROCESS_GRAYNESS, Gray_Level)
Return Nil

Function BT_BitmapBrightness (hBitmap, Light_Level)
   BT_BMP_PROCESS (hBitmap, BT_BMP_PROCESS_BRIGHTNESS, Light_Level)
Return Nil

Function BT_BitmapContrast (hBitmap, ContrastAngle)
   BT_BMP_PROCESS (hBitmap, BT_BMP_PROCESS_CONTRAST, ContrastAngle)
Return Nil

Function BT_BitmapModifyColor (hBitmap, RedLevel, GreenLevel, BlueLevel)
   BT_BMP_PROCESS (hBitmap, BT_BMP_PROCESS_MODIFYCOLOR, {RedLevel, GreenLevel, BlueLevel})
Return Nil

Function BT_BitmapGammaCorrect (hBitmap, RedGamma, GreenGamma, BlueGamma)
   BT_BMP_PROCESS (hBitmap, BT_BMP_PROCESS_GAMMACORRECT, {RedGamma, GreenGamma, BlueGamma})
Return Nil

Function BT_BitmapConvolutionFilter3x3 (hBitmap, aFilter)
   BT_BMP_FILTER3x3 (hBitmap, aFilter)
Return Nil

Function BT_BitmapTransform (hBitmap, Mode, Angle, aRGBColor_Fill_Bk)
   LOCAL New_hBitmap
   LOCAL ColorRef_Fill_Bk:= IF (Valtype(aRGBColor_Fill_Bk) == "U", BT_BMP_GETINFO(hBitmap, BT_BITMAP_INFO_GETCOLORPIXEL, 0, 0), ArrayRGB_TO_COLORREF(aRGBColor_Fill_Bk))
   New_hBitmap := BT_BMP_TRANSFORM (hBitmap, Mode, Angle, ColorRef_Fill_Bk)
Return New_hBitmap



//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


Function BT_BitmapClone (hBitmap, Row, Col, Width, Height)
   LOCAL New_hBitmap
   LOCAL Max_Width  := BT_BitmapWidth(hBitmap)
   LOCAL Max_Height := BT_BitmapHeight(hBitmap)
   bt_FillRectIsNIL (@Row, @Col, @Width, @Height, 0, 0, Max_Width, Max_Height)
   bt_AdjustWidthHeightRect (Row, Col, @Width, @Height, Max_Width, Max_Height)
   New_hBitmap := BT_BMP_CLONE (hBitmap, Col, Row, Width, Height)
Return New_hBitmap


Function BT_BitmapCopyAndResize (hBitmap, New_Width, New_Height, Mode_Stretch, Algorithm)
   LOCAL New_hBitmap
   Mode_Stretch := IF (Valtype (Mode_Stretch) == "U", BT_STRETCH, Mode_Stretch)
   Algorithm    := IF (Valtype (Algorithm)    == "U", BT_RESIZE_HALFTONE, Algorithm)
   New_hBitmap  := BT_BMP_COPYANDRESIZE (hBitmap, New_Width, New_Height, Mode_Stretch, Algorithm)
Return New_hBitmap


Function BT_BitmapPaste (hBitmap_D, Row_D, Col_D, Width_D, Height_D, Mode_Stretch, hBitmap_O)
   LOCAL Max_Width_D  := BT_BitmapWidth  (hBitmap_D)
   LOCAL Max_Height_D := BT_BitmapHeight (hBitmap_D)
   LOCAL Width_O      := BT_BitmapWidth  (hBitmap_O)
   LOCAL Height_O     := BT_BitmapHeight (hBitmap_O)
   bt_FillRectIsNIL (@Row_D, @Col_D, @Width_D, @Height_D, 0, 0, Max_Width_D, Max_Height_D)
   BT_BMP_PASTE (hBitmap_D, Col_D, Row_D, Width_D, Height_D, hBitmap_O, 0, 0, Width_O, Height_O, Mode_Stretch, BT_BITMAP_OPAQUE, 0)
Return Nil


Function BT_BitmapPasteTransparent (hBitmap_D, Row_D, Col_D, Width_D, Height_D, Mode_Stretch, hBitmap_O, aRGBcolor_transp)
   LOCAL Max_Width_D  := BT_BitmapWidth  (hBitmap_D)
   LOCAL Max_Height_D := BT_BitmapHeight (hBitmap_D)
   LOCAL Width_O      := BT_BitmapWidth  (hBitmap_O)
   LOCAL Height_O     := BT_BitmapHeight (hBitmap_O)
   LOCAL ColorRef_Transp:= IF (Valtype(aRGBcolor_transp) == "U", BT_BMP_GETINFO(hBitmap_O, BT_BITMAP_INFO_GETCOLORPIXEL, 0, 0), ArrayRGB_TO_COLORREF(aRGBcolor_transp))
   bt_FillRectIsNIL (@Row_D, @Col_D, @Width_D, @Height_D, 0, 0, Max_Width_D, Max_Height_D)
   BT_BMP_PASTE (hBitmap_D, Col_D, Row_D, Width_D, Height_D, hBitmap_O, 0, 0, Width_O, Height_O, Mode_Stretch, BT_BITMAP_TRANSPARENT, ColorRef_Transp)
Return Nil


Function BT_BitmapPasteAlphaBlend (hBitmap_D, Row_D, Col_D, Width_D, Height_D, Alpha, Mode_Stretch, hBitmap_O)
   LOCAL Max_Width_D  := BT_BitmapWidth  (hBitmap_D)
   LOCAL Max_Height_D := BT_BitmapHeight (hBitmap_D)
   LOCAL Width_O      := BT_BitmapWidth  (hBitmap_O)
   LOCAL Height_O     := BT_BitmapHeight (hBitmap_O)
   bt_FillRectIsNIL (@Row_D, @Col_D, @Width_D, @Height_D, 0, 0, Max_Width_D, Max_Height_D)
   BT_BMP_PASTE_ALPHABLEND (hBitmap_D, Col_D, Row_D, Width_D, Height_D, hBitmap_O, 0, 0, Width_O, Height_O, Alpha, Mode_Stretch)
Return Nil


//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function BT_BitmapCaptureDesktop (Row, Col, Width, Height)
   LOCAL New_hBitmap
   LOCAL Win := BT_GetDesktopHandle()
   LOCAL Max_Width  := BT_DesktopWidth()
   LOCAL Max_Height := BT_DesktopHeight()
   bt_FillRectIsNIL (@Row, @Col, @Width, @Height, 0, 0, Max_Width, Max_Height)
   bt_AdjustWidthHeightRect (Row, Col, @Width, @Height, Max_Width, Max_Height)
   New_hBitmap := BT_BMP_CAPTURESCR (bt_WinHandle(Win), Col, Row, Width, Height, BT_BITMAP_CAPTURE_DESKTOP)
Return New_hBitmap


Function BT_BitmapCaptureWindow (Win, Row, Col, Width, Height)
   LOCAL New_hBitmap
   LOCAL Max_Width  := BT_WindowWidth(Win)
   LOCAL Max_Height := BT_WindowHeight(Win)
   bt_FillRectIsNIL (@Row, @Col, @Width, @Height, 0, 0, Max_Width, Max_Height)
   bt_AdjustWidthHeightRect (Row, Col, @Width, @Height, Max_Width, Max_Height)
   New_hBitmap := BT_BMP_CAPTURESCR (bt_WinHandle(Win), Col, Row, Width, Height, BT_BITMAP_CAPTURE_WINDOW)
Return New_hBitmap


Function BT_BitmapCaptureClientArea (Win, Row, Col, Width, Height)
   LOCAL New_hBitmap
   LOCAL Max_Width  := BT_ClientAreaWidth(Win)
   LOCAL Max_Height := BT_ClientAreaHeight(Win)
   bt_FillRectIsNIL (@Row, @Col, @Width, @Height, 0, 0, Max_Width, Max_Height)
   bt_AdjustWidthHeightRect (Row, Col, @Width, @Height, Max_Width, Max_Height)
   New_hBitmap := BT_BMP_CAPTURESCR (bt_WinHandle(Win), Col, Row, Width, Height, BT_BITMAP_CAPTURE_CLIENTAREA)
Return New_hBitmap



//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Function BT_BitmapClipboardGet (Win)
   LOCAL hBitmap
   hBitmap := BT_BMP_GET_CLIPBOARD(bt_WinHandle(Win))
Return hBitmap


Function BT_BitmapClipboardPut (Win, hBitmap)
   LOCAL lRet := BT_BMP_PUT_CLIPBOARD(bt_WinHandle(Win), hBitmap)
Return lRet


Function BT_BitmapClipboardClean (Win)
   LOCAL lRet := BT_BMP_CLEAN_CLIPBOARD(bt_WinHandle(Win))
Return lRet


Function BT_BitmapClipboardIsEmpty ()
   LOCAL lRet := BT_BMP_CLIPBOARD_ISEMPTY()
Return lRet




// **********************************************************************************************************************************
//  HMG Functions
// **********************************************************************************************************************************



Function BT_HMGGetImage (cFormName, cControlName)
LOCAL k, hBitmap := 0
   k := GetControlIndex (cControlName, cFormName)
   IF k > 0 .AND. GetControlType (cControlName, cFormName) == "IMAGE"
      #ifdef __HMG__    // HMG Extended
         hBitmap := _HMG_aControlContainerHandle [k]
      #else             // HMG Official
         hBitmap := _HMG_SYSDATA [37, k]
      #endif
   ENDIF
Return hBitmap



Function BT_HMGCloneImage (cFormName, cControlName)
LOCAL hBitmap := BT_HMGGetImage (cFormName, cControlName)
Return IIF ( hBitmap <> 0, BT_BitmapClone (hBitmap), 0 )


Function BT_HMGSetImage (cFormName, cControlName, hBitmap, lReleasePreviousBitmap)
LOCAL hWnd, k

   IF ValType (lReleasePreviousBitmap) <> "L"
      lReleasePreviousBitmap := .T.
   ENDIF

   k := GetControlIndex (cControlName, cFormName)
   IF k > 0 .AND. GetControlType (cControlName, cFormName) == "IMAGE"

      #ifdef __HMG__    // HMG Extended
         IF _HMG_aControlContainerHandle [k] <> 0 .AND. lReleasePreviousBitmap == .T.
            BT_BitmapRelease (_HMG_aControlContainerHandle [k])
         ENDIF
         _HMG_aControlContainerHandle [k] := hBitmap
         _HMG_aControlWidth  [k] := BT_BitmapWidth  (hBitmap)
         _HMG_aControlHeight [k] := BT_BitmapHeight (hBitmap)
      #else             // HMG Official
         IF _HMG_SYSDATA [37, k] <> 0 .AND. lReleasePreviousBitmap == .T.
            BT_BitmapRelease (_HMG_SYSDATA [37, k])
         ENDIF
         _HMG_SYSDATA [37, k] := hBitmap
         _HMG_SYSDATA [20, k] := BT_BitmapWidth  (hBitmap)
         _HMG_SYSDATA [21, k] := BT_BitmapHeight (hBitmap)
      #endif

      hWnd := GetControlHandle (cControlName, cFormName)
      #define _STM_SETIMAGE_ 0x0172
      #define _IMAGE_BITMAP_ 0
      SendMessage (hWnd, _STM_SETIMAGE_, _IMAGE_BITMAP_, hBitmap)
      #undef _IMAGE_BITMAP_
      #undef _STM_SETIMAGE_
   ENDIF
Return NIL



