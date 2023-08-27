
/*----------------------------------------------------------------------------
BOS TAURUS - Graphic Library for HMG

Copyright 2012-2016 by Dr. Claudio Soto( from Uruguay).
mail: <srvet@adinet.com.uy>
blog: http://srvet.blogspot.com

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or( at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; IF not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor Boston, MA 02110-1301, USA
(or visit their web site at http://www.gnu.org/).

As a special exception, you have permission for additional uses of the text
contained in this release of BOS TAURUS.

The exception is that, IF you link the BOS TAURUS library with other
files to produce an executable, this does not by itself cause the resulting
executable to be covered by the GNU General Public License.
Your use of that executable is in no way restricted on account of linking the
BOS TAURUS library code into it.
----------------------------------------------------------------------------*/

* ARCHIVO:  BosTaurus.prg
* LENGUAJE: HMG
* FECHA:    Setiembre 2012
* AUTOR:    Dr. CLAUDIO SOTO
* PAIS:     URUGUAY
* E-MAIL:   srvet@adinet.com.uy
* BLOG:     http://srvet.blogspot.com

//#include "hmg.ch"

#include "bostaurus.ch"
#define BLACK { 0, 0, 0 }
#define WHITE {255,255,255}

// **********************************************************************************************************************************
//  INTERNAL Functions PRG
// **********************************************************************************************************************************

FUNCTION bt_FillRectIsNIL( Row, Col, Width, Height, Row_value, Col_value, Width_value, Height_value )

   ROW    := iif( Valtype( Row )    =="U",  Row_value,    Row )
   COL    := iif( Valtype( Col )    =="U",  Col_value,    Col )
   WIDTH  := iif( Valtype( Width )  =="U",  Width_value,  Width )
   HEIGHT := iif( Valtype( Height ) =="U",  Height_value, Height )

   RETURN Nil

FUNCTION bt_AdjustWidthHeightRect( Row, Col, Width, Height, Max_Width, Max_Height )

   WIDTH  := iif( ( Col + Width  > Max_Width ),  ( Max_Width  - Col ), Width )
   HEIGHT := iif( ( Row + Height > Max_Height ), ( Max_Height - Row ), Height )

   RETURN Nil

FUNCTION bt_ListCalledFunctions( nActivation )

   LOCAL cMsg := ""

   nActivation := iif( ValType( nActivation ) <> "N", 1, nActivation )
   DO WHILE .NOT.( ProcName( nActivation ) == "" )
      cMsg := cMsg + "Called from:" + ProcName( nActivation ) + "(" + LTrim( Str( ProcLine( nActivation ) ) ) + ")" + CRLF
      nActivation++
   ENDDO

   RETURN cMsg

   // **********************************************************************************************************************************
   // * BT INFO
   // **********************************************************************************************************************************

FUNCTION BT_InfoName()

   RETURN AllTrim( _BT_INFO_NAME_ )

FUNCTION BT_InfoVersion()

   RETURN AllTrim( Str( _BT_INFO_MAJOR_VERSION_ ) ) + "." + AllTrim( Str( _BT_INFO_MINOR_VERSION_ ) ) + "." + AllTrim( Str( _BT_INFO_PATCHLEVEL_ ) )

FUNCTION BT_InfoAuthor()

   RETURN AllTrim( _BT_INFO_AUTHOR_ )

   // **********************************************************************************************************************************
   // * Handle DC
   // **********************************************************************************************************************************

FUNCTION BT_CreateDC( hWnd, Type, BTstruct )

   LOCAL Handle, hDc

   DO CASE
   CASE Type = BT_HDC_DESKTOP
      Handle := 0
   CASE Type = BT_HDC_BITMAP
      Handle := hWnd
   OTHERWISE
      Handle := hWnd
   END CASE
   BTstruct := BT_DC_CREATE( Type, Handle )
   hDC := BTstruct[3]

   RETURN hDC

FUNCTION BT_DeleteDC( BTstruct )

   LOCAL lRet

   IF Valtype( BTstruct )<> "A"
      //MsgBox( "Error in call to "+PROCNAME()+": The second parameter is not an array" + CRLF + bt_ListCalledFunctions(2),"BT Fatal Error")
      //RELEASE WINDOW ALL
   ELSEIF Len( BTstruct )  <>  50
      //MsgBox( "Error in call to "+PROCNAME()+": The second parameter is an corrupted array " + CRLF + bt_ListCalledFunctions(2),"BT Fatal Error")
      //RELEASE WINDOW ALL
   ENDIF
   lRet:= BT_DC_DELETE( BTstruct )

   RETURN lRet

   // **********************************************************************************************************************************
   //  DRAW Functions
   // **********************************************************************************************************************************

   //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

FUNCTION BT_DrawGetPixel( hDC, Row, Col )

   LOCAL aRGBcolor

   aRGBcolor = BT_DRAW_HDC_PIXEL( hDC, Col, Row, BT_HDC_GETPIXEL, 0 )

   RETURN aRGBcolor

FUNCTION BT_DrawSetPixel( hDC, Row, Col, aRGBcolor )

   LOCAL aRGBcolor_Old

   aRGBcolor_Old = BT_DRAW_HDC_PIXEL( hDC, Col, Row, BT_HDC_SETPIXEL, ArrayRGB_TO_COLORREF( aRGBcolor ) )

   RETURN aRGBcolor_Old

   //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

FUNCTION BT_DrawBitmap( hDC, Row, Col, Width, Height, Mode_Stretch, hBitmap )

   LOCAL Width2  := BT_BMP_GETINFO( hBitmap, BT_BITMAP_INFO_WIDTH )
   LOCAL Height2 := BT_BMP_GETINFO( hBitmap, BT_BITMAP_INFO_HEIGHT )

   bt_FillRectIsNIL( @Row, @Col, @Width, @Height, 0, 0, Width2, Height2 )
   BT_DRAW_HDC_BITMAP( hDC, Col, Row, Width, Height, hBitmap, 0, 0, Width2, Height2, Mode_Stretch, BT_BITMAP_OPAQUE, 0 )

   RETURN Nil

FUNCTION BT_DrawBitmapTransparent( hDC, Row, Col, Width, Height, Mode_Stretch, hBitmap, aRGBcolor_transp )

   LOCAL ColorRef_Transp := iif( Valtype( aRGBcolor_transp ) == "U", BT_BMP_GETINFO( hBitmap, BT_BITMAP_INFO_GETCOLORPIXEL, 0, 0 ), ArrayRGB_TO_COLORREF( aRGBcolor_transp ) )
   LOCAL Width2  := BT_BMP_GETINFO( hBitmap, BT_BITMAP_INFO_WIDTH )
   LOCAL Height2 := BT_BMP_GETINFO( hBitmap, BT_BITMAP_INFO_HEIGHT )

   bt_FillRectIsNIL( @Row, @Col, @Width, @Height, 0, 0, Width2, Height2 )
   BT_DRAW_HDC_BITMAP( hDC, Col, Row, Width, Height, hBitmap, 0, 0, Width2, Height2, Mode_Stretch, BT_BITMAP_TRANSPARENT, ColorRef_Transp )

   RETURN Nil

FUNCTION BT_DrawBitmapAlphaBlend( hDC, Row, Col, Width, Height, Alpha, Mode_Stretch, hBitmap )

   LOCAL Width2  := BT_BMP_GETINFO( hBitmap, BT_BITMAP_INFO_WIDTH )
   LOCAL Height2 := BT_BMP_GETINFO( hBitmap, BT_BITMAP_INFO_HEIGHT )

   bt_FillRectIsNIL( @Row, @Col, @Width, @Height, 0, 0, Width2, Height2 )
   BT_DRAW_HDC_BITMAPALPHABLEND( hDC, Col, Row, Width, Height, hBitmap, 0, 0, Width2, Height2, Alpha, Mode_Stretch )

   RETURN Nil

   //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

FUNCTION BT_DrawDCtoDC( hDC1, Row1, Col1, Width1, Height1, Mode_Stretch, hDC2, Row2, Col2, Width2, Height2 )

   BT_DRAW_HDC_TO_HDC( hDC1, Col1, Row1, Width1, Height1, hDC2, Col2, Row2, Width2, Height2, Mode_Stretch, BT_HDC_OPAQUE, 0 )

   RETURN Nil

FUNCTION BT_DrawDCtoDCTransparent( hDC1, Row1, Col1, Width1, Height1, Mode_Stretch, hDC2, Row2, Col2, Width2, Height2, aRGBcolor_transp )

   LOCAL ColorRef_Transp:= iif( Valtype( aRGBcolor_transp ) == "U", ArrayRGB_TO_COLORREF( BT_DrawGetPixel( hDC2, 0, 0 ) ), ArrayRGB_TO_COLORREF( aRGBcolor_transp ) )

   BT_DRAW_HDC_TO_HDC( hDC1, Col1, Row1, Width1, Height1, hDC2, Col2, Row2, Width2, Height2, Mode_Stretch, BT_HDC_TRANSPARENT, ColorRef_Transp )

   RETURN Nil

FUNCTION BT_DrawDCtoDCAlphaBlend( hDC1, Row1, Col1, Width1, Height1, Alpha, Mode_Stretch, hDC2, Row2, Col2, Width2, Height2)

   BT_DRAW_HDC_TO_HDC_ALPHABLEND( hDC1, Col1, Row1, Width1, Height1, hDC2, Col2, Row2, Width2, Height2, Alpha, Mode_Stretch)

   RETURN Nil

   //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

FUNCTION BT_DrawGradientFillHorizontal( hDC, Row, Col, Width, Height, aColorRGBstart, aColorRGBend )

   aColorRGBstart := iif( ValType(aColorRGBstart)  == "U", BLACK, aColorRGBstart )
   aColorRGBend   := iif( ValType(aColorRGBend)    == "U", WHITE, aColorRGBend )
   BT_DRAW_HDC_GRADIENTFILL( hDC, Col, Row, Width, Height, ArrayRGB_TO_COLORREF( aColorRGBstart ), ArrayRGB_TO_COLORREF( aColorRGBend ), BT_GRADIENTFILL_HORIZONTAL )

   RETURN Nil

FUNCTION BT_DrawGradientFillVertical( hDC, Row, Col, Width, Height, aColorRGBstart, aColorRGBend )

   aColorRGBstart := iif( ValType( aColorRGBstart )  == "U", WHITE, aColorRGBstart )
   aColorRGBend   := iif( ValType( aColorRGBend )    == "U", BLACK, aColorRGBend )
   BT_DRAW_HDC_GRADIENTFILL( hDC, Col, Row, Width, Height, ArrayRGB_TO_COLORREF( aColorRGBstart ), ArrayRGB_TO_COLORREF( aColorRGBend ), BT_GRADIENTFILL_VERTICAL )

   RETURN Nil

   //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

FUNCTION BT_DrawText( hDC, Row, Col, cText, cFontName, nFontSize, aFontColor, aBackColor, nTypeText, nAlingText, nOrientation )

   aFontColor   := iif( ValType( aFontColor )   == "U", BLACK,                          aFontColor )
   aBackColor   := iif( ValType( aBackColor )   == "U", WHITE,                          aBackColor )
   nTypeText    := iif( ValType( nTypeText )    == "U", BT_TEXT_OPAQUE,                 nTypeText )
   nAlingText   := iif( ValType( nAlingText )   == "U", ( BT_TEXT_LEFT + BT_TEXT_TOP ), nAlingText )
   nOrientation := iif( ValType( nOrientation ) == "U", BT_TEXT_NORMAL_ORIENTATION,     nOrientation )
   BT_DRAW_HDC_TEXTOUT( hDC, Col, Row, cText, cFontName, nFontSize, ArrayRGB_TO_COLORREF(aFontColor), ArrayRGB_TO_COLORREF(aBackColor), nTypeText, nAlingText, nOrientation)

   RETURN Nil

FUNCTION BT_DrawTextEx( hDC, Row, Col, Width, Height, cText, cFontName, nFontSize, aFontColor, aBackColor, nTypeText, nAlingText, nOrientation )

   aFontColor   := iif( ValType( aFontColor )   == "U", BLACK,                         aFontColor )
   aBackColor   := iif( ValType( aBackColor )   == "U", WHITE,                         aBackColor )
   nTypeText    := iif( ValType( nTypeText )    == "U", BT_TEXT_OPAQUE,                nTypeText )
   nAlingText   := iif( ValType( nAlingText )   == "U",( BT_TEXT_LEFT + BT_TEXT_TOP ), nAlingText )
   nOrientation := iif( ValType( nOrientation ) == "U", BT_TEXT_NORMAL_ORIENTATION,    nOrientation )
   BT_DRAW_HDC_DRAWTEXT( hDC, Col, Row, Width, Height, cText, cFontName, nFontSize, ArrayRGB_TO_COLORREF( aFontColor ), ArrayRGB_TO_COLORREF( aBackColor ), nTypeText, nAlingText, nOrientation )

   RETURN Nil

FUNCTION BT_DrawTextSize( hDC, cText, cFontName, nFontSize, nTypeText )

   LOCAL aSize := BT_DRAW_HDC_TEXTSIZE( hDC, cText, cFontName, nFontSize, nTypeText )

   RETURN aSize

   //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

FUNCTION BT_DrawPolyLine( hDC, aPointY, aPointX, aColorRGBLine, nWidthLine )

   nWidthLine := iif( Valtype( nWidthLine ) == "U", 1, nWidthLine )
   BT_DRAW_HDC_POLY( hDC, aPointX, aPointY, ArrayRGB_TO_COLORREF( aColorRGBLine ), nWidthLine, 0, BT_DRAW_POLYLINE )

   RETURN Nil

FUNCTION BT_DrawPolygon( hDC, aPointY, aPointX, aColorRGBLine, nWidthLine, aColorRGBFill )

   nWidthLine := iif( Valtype( nWidthLine ) == "U", 1, nWidthLine )
   BT_DRAW_HDC_POLY( hDC, aPointX, aPointY, ArrayRGB_TO_COLORREF( aColorRGBLine ), nWidthLine, ArrayRGB_TO_COLORREF( aColorRGBFill ), BT_DRAW_POLYGON )

   RETURN Nil

FUNCTION BT_DrawPolyBezier( hDC, aPointY, aPointX, aColorRGBLine, nWidthLine )

   nWidthLine := iif( Valtype( nWidthLine ) == "U", 1, nWidthLine )
   BT_DRAW_HDC_POLY( hDC, aPointX, aPointY, ArrayRGB_TO_COLORREF( aColorRGBLine ), nWidthLine, 0, BT_DRAW_POLYBEZIER )

   RETURN Nil

FUNCTION BT_DrawArc( hDC, Row1, Col1, Row2, Col2, RowStartArc, ColStartArc, RowEndArc, ColEndArc, aColorRGBLine, nWidthLine )

   nWidthLine := iif( Valtype( nWidthLine ) == "U", 1, nWidthLine )
   BT_DRAW_HDC_ARCX( hDC, Col1, Row1, Col2, Row2, ColStartArc, RowStartArc, ColEndArc, RowEndArc, ArrayRGB_TO_COLORREF( aColorRGBLine ), nWidthLine, 0, BT_DRAW_ARC )

   RETURN Nil

FUNCTION BT_DrawChord( hDC, Row1, Col1, Row2, Col2, RowStartArc, ColStartArc, RowEndArc, ColEndArc, aColorRGBLine, nWidthLine, aColorRGBFill )

   nWidthLine := iif( Valtype( nWidthLine ) == "U", 1, nWidthLine )
   BT_DRAW_HDC_ARCX( hDC, Col1, Row1, Col2, Row2, ColStartArc, RowStartArc, ColEndArc, RowEndArc, ArrayRGB_TO_COLORREF( aColorRGBLine ), nWidthLine, ArrayRGB_TO_COLORREF( aColorRGBFill ), BT_DRAW_CHORD )

   RETURN Nil

FUNCTION BT_DrawPie( hDC, Row1, Col1, Row2, Col2, RowStartArc, ColStartArc, RowEndArc, ColEndArc, aColorRGBLine, nWidthLine, aColorRGBFill )

   nWidthLine := iif( Valtype( nWidthLine ) == "U", 1, nWidthLine )
   BT_DRAW_HDC_ARCX( hDC, Col1, Row1, Col2, Row2, ColStartArc, RowStartArc, ColEndArc, RowEndArc, ArrayRGB_TO_COLORREF( aColorRGBLine ), nWidthLine, ArrayRGB_TO_COLORREF( aColorRGBFill ), BT_DRAW_PIE )

   RETURN Nil

FUNCTION BT_DrawLine( hDC, Row1, Col1, Row2, Col2, aColorRGBLine, nWidthLine )

   LOCAL aPointX := { Col1, Col2 }
   LOCAL aPointY := { Row1, Row2 }

   nWidthLine := iif( Valtype( nWidthLine ) == "U", 1, nWidthLine )
   BT_DrawPolyLine( hDC, aPointY, aPointX, aColorRGBLine, nWidthLine )

   RETURN Nil

FUNCTION BT_DrawRectangle( hDC, Row, Col, Width, Height, aColorRGBLine, nWidthLine )

   LOCAL aPointX := Array(5)
   LOCAL aPointY := Array(5)

   aPointX[ 1 ] := Col;          aPointY[ 1 ] := Row
   aPointX[ 2 ] := Col + Width;  aPointY[ 2 ] := Row
   aPointX[ 3 ] := Col + Width;  aPointY[ 3 ] := Row + Height
   aPointX[ 4 ] := Col;          aPointY[ 4 ] := Row + Height
   aPointX[ 5 ] := Col;          aPointY[ 5 ] := Row
   nWidthLine := iif( Valtype( nWidthLine ) == "U", 1, nWidthLine )
   BT_DrawPolyLine( hDC, aPointY, aPointX, aColorRGBLine, nWidthLine )

   RETURN Nil

FUNCTION BT_DrawEllipse( hDC, Row1, Col1, Width, Height, aColorRGBLine, nWidthLine )

   LOCAL ColStartArc, ColEndArc
   LOCAL RowStartArc, RowEndArc
   LOCAL Col2, Row2

   Col2 := Col1 + Width
   Row2 := Row1 + Height
   ColStartArc := ColEndArc := Col1
   RowStartArc := RowEndArc := Row1
   nWidthLine := iif( Valtype( nWidthLine) == "U", 1, nWidthLine )
   BT_DrawArc( hDC, Row1, Col1, Row2, Col2, RowStartArc, ColStartArc, RowEndArc, ColEndArc, aColorRGBLine, nWidthLine )

   RETURN Nil

   //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

FUNCTION BT_DrawFillRectangle( hDC, Row, Col, Width, Height, aColorRGBFill, aColorRGBLine, nWidthLine )

   aColorRGBLine := iif( Valtype( nWidthLine) == "U", aColorRGBFill, aColorRGBLine )
   nWidthLine := iif( Valtype( nWidthLine ) == "U", 1, nWidthLine )
   BT_DRAW_HDC_FILLEDOBJECT( hDC, Col, Row, Width, Height, ArrayRGB_TO_COLORREF( aColorRGBFill ), ArrayRGB_TO_COLORREF( aColorRGBLine ), nWidthLine, BT_FILLRECTANGLE, 0, 0 )

   RETURN Nil

FUNCTION BT_DrawFillEllipse( hDC, Row, Col, Width, Height, aColorRGBFill, aColorRGBLine, nWidthLine )

   aColorRGBLine := iif( Valtype( nWidthLine ) == "U", aColorRGBFill, aColorRGBLine )
   nWidthLine := iif( Valtype( nWidthLine ) == "U", 1, nWidthLine )
   BT_DRAW_HDC_FILLEDOBJECT( hDC, Col, Row, Width, Height, ArrayRGB_TO_COLORREF( aColorRGBFill ), ArrayRGB_TO_COLORREF( aColorRGBLine ), nWidthLine, BT_FILLELLIPSE, 0, 0 )

   RETURN Nil

FUNCTION BT_DrawFillRoundRect( hDC, Row, Col, Width, Height, RoundWidth, RoundHeight, aColorRGBFill, aColorRGBLine, nWidthLine )

   aColorRGBLine := iif( Valtype( nWidthLine ) == "U", aColorRGBFill, aColorRGBLine )
   nWidthLine := iif( Valtype( nWidthLine ) == "U", 1, nWidthLine )
   BT_DRAW_HDC_FILLEDOBJECT( hDC, Col, Row, Width, Height, ArrayRGB_TO_COLORREF( aColorRGBFill ), ArrayRGB_TO_COLORREF(aColorRGBLine), nWidthLine, BT_FILLROUNDRECT, RoundWidth, RoundHeight )

   RETURN Nil

FUNCTION BT_DrawFillFlood( hDC, Row, Col, aColorRGBFill )

   BT_DRAW_HDC_FILLEDOBJECT( hDC, Col, Row, NIL, NIL, ArrayRGB_TO_COLORREF( aColorRGBFill ), NIL, NIL, BT_FILLFLOOD, NIL, NIL )

   RETURN Nil

   //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

FUNCTION BT_GetDesktopHandle()

   RETURN BT_SCR_GETDESKTOPHANDLE()

FUNCTION BT_DesktopWidth()

   LOCAL Width := BT_SCR_GETINFO( 0, BT_SCR_DESKTOP, BT_SCR_INFO_WIDTH )

   RETURN Width

FUNCTION BT_DesktopHeight()

   LOCAL hWnd := BT_GetDesktopHandle()
   LOCAL Height := BT_SCR_GETINFO( hWnd, BT_SCR_DESKTOP, BT_SCR_INFO_HEIGHT )

   RETURN Height

FUNCTION BT_WindowWidth( hWnd )

   LOCAL Width := BT_SCR_GETINFO( hWnd, BT_SCR_WINDOW, BT_SCR_INFO_WIDTH )

   RETURN Width

FUNCTION BT_WindowHeight( hWnd )

   LOCAL Height := BT_SCR_GETINFO( hWnd, BT_SCR_WINDOW, BT_SCR_INFO_HEIGHT )

   RETURN Height

FUNCTION BT_ClientAreaWidth( hWnd )

   LOCAL Width := BT_SCR_GETINFO( hWnd, BT_SCR_CLIENTAREA, BT_SCR_INFO_WIDTH )

   RETURN Width

FUNCTION BT_ClientAreaHeight( hWnd )

   LOCAL Height := BT_SCR_GETINFO( hWnd, BT_SCR_CLIENTAREA, BT_SCR_INFO_HEIGHT )

   RETURN Height

   //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

FUNCTION BT_ClientAreaInvalidateAll( hWnd, lErase )

   lErase = iif( Valtype( lErase ) == "U", .F., lErase )
   BT_SCR_INVALIDATERECT( hWnd, NIL, lErase)

   RETURN Nil

FUNCTION BT_ClientAreaInvalidateRect( hWnd, Row, Col, Width, Height, lErase )

   lErase = iif( Valtype( lErase ) == "U", .F., lErase )
   bt_FillRectIsNIL( @Row, @Col, @Width, @Height, 0, 0, BT_ClientAreaWidth( hWnd ), BT_ClientAreaHeight( hWnd ) )
   BT_SCR_INVALIDATERECT( hWnd, { Col, Row, Col + Width, Row + Height }, lErase )

   RETURN Nil

   // **********************************************************************************************************************************
   //  BITMAP  Functions
   // **********************************************************************************************************************************

   //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

FUNCTION BT_BitmapLoadFile( cFileName )

   LOCAL hBitmap := BT_BMP_LOADFILE( cFileName )

   RETURN hBitmap

FUNCTION BT_BitmapSaveFile( hBitmap, cFileName, nTypePicture )

   LOCAL lRet

   nTypePicture := iif( Valtype( nTypePicture ) == "U", BT_FILEFORMAT_BMP, nTypePicture )
   lRet := BT_BMP_SAVEFILE( hBitmap, cFileName, nTypePicture )

   RETURN lRet

   //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

FUNCTION BT_BitmapCreateNew( Width, Height, aRGBcolor_Fill_Bk )

   LOCAL New_hBitmap

   aRGBcolor_Fill_Bk := iif( Valtype( aRGBColor_Fill_Bk ) == "U", BLACK, aRGBcolor_Fill_Bk )
   New_hBitmap := BT_BMP_CREATE( Width, Height, ArrayRGB_TO_COLORREF( aRGBColor_Fill_Bk ) )

   RETURN New_hBitmap

FUNCTION BT_BitmapRelease( hBitmap )

   BT_BMP_RELEASE( hBitmap )

   RETURN Nil

   //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

FUNCTION BT_BitmapWidth( hBitmap)

   LOCAL Width := BT_BMP_GETINFO( hBitmap, BT_BITMAP_INFO_WIDTH )

   RETURN Width

FUNCTION BT_BitmapHeight( hBitmap )

   LOCAL Height := BT_BMP_GETINFO( hBitmap, BT_BITMAP_INFO_HEIGHT )

   RETURN Height

FUNCTION BT_BitmapBitsPerPixel( hBitmap )

   LOCAL BitsPixel := BT_BMP_GETINFO( hBitmap, BT_BITMAP_INFO_BITSPIXEL )

   RETURN BitsPixel

   //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

FUNCTION BT_BitmapInvert( hBitmap )

   BT_BMP_PROCESS( hBitmap, BT_BMP_PROCESS_INVERT )

   RETURN Nil

FUNCTION BT_BitmapGrayness( hBitmap, Gray_Level )

   BT_BMP_PROCESS( hBitmap, BT_BMP_PROCESS_GRAYNESS, Gray_Level )

   RETURN Nil

FUNCTION BT_BitmapBrightness( hBitmap, Light_Level )

   BT_BMP_PROCESS( hBitmap, BT_BMP_PROCESS_BRIGHTNESS, Light_Level )

   RETURN Nil

FUNCTION BT_BitmapContrast( hBitmap, ContrastAngle )

   BT_BMP_PROCESS( hBitmap, BT_BMP_PROCESS_CONTRAST, ContrastAngle )

   RETURN Nil

FUNCTION BT_BitmapModifyColor( hBitmap, RedLevel, GreenLevel, BlueLevel )

   BT_BMP_PROCESS( hBitmap, BT_BMP_PROCESS_MODIFYCOLOR, { RedLevel, GreenLevel, BlueLevel } )

   RETURN Nil

FUNCTION BT_BitmapGammaCorrect( hBitmap, RedGamma, GreenGamma, BlueGamma )

   BT_BMP_PROCESS( hBitmap, BT_BMP_PROCESS_GAMMACORRECT, { RedGamma, GreenGamma, BlueGamma } )

   RETURN Nil

FUNCTION BT_BitmapConvolutionFilter3x3( hBitmap, aFilter )

   BT_BMP_FILTER3x3( hBitmap, aFilter )

   RETURN Nil

FUNCTION BT_BitmapTransform( hBitmap, Mode, Angle, aRGBColor_Fill_Bk )

   LOCAL New_hBitmap
   LOCAL ColorRef_Fill_Bk:= iif( Valtype( aRGBColor_Fill_Bk ) == "U", BT_BMP_GETINFO( hBitmap, BT_BITMAP_INFO_GETCOLORPIXEL, 0, 0 ), ArrayRGB_TO_COLORREF( aRGBColor_Fill_Bk ) )

   New_hBitmap := BT_BMP_TRANSFORM( hBitmap, Mode, Angle, ColorRef_Fill_Bk )

   RETURN New_hBitmap

   //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

FUNCTION BT_BitmapClone( hBitmap, Row, Col, Width, Height )

   LOCAL New_hBitmap
   LOCAL Max_Width  := BT_BitmapWidth( hBitmap )
   LOCAL Max_Height := BT_BitmapHeight( hBitmap )

   bt_FillRectIsNIL( @Row, @Col, @Width, @Height, 0, 0, Max_Width, Max_Height )
   bt_AdjustWidthHeightRect( Row, Col, @Width, @Height, Max_Width, Max_Height )
   New_hBitmap := BT_BMP_CLONE( hBitmap, Col, Row, Width, Height )

   RETURN New_hBitmap

FUNCTION BT_BitmapCopyAndResize( hBitmap, New_Width, New_Height, Mode_Stretch, Algorithm )

   LOCAL New_hBitmap

   Mode_Stretch := iif( Valtype( Mode_Stretch ) == "U", BT_STRETCH, Mode_Stretch )
   Algorithm    := iif( Valtype( Algorithm )    == "U", BT_RESIZE_HALFTONE, Algorithm )
   New_hBitmap  := BT_BMP_COPYANDRESIZE( hBitmap, New_Width, New_Height, Mode_Stretch, Algorithm )

   RETURN New_hBitmap

FUNCTION BT_BitmapPaste( hBitmap_D, Row_D, Col_D, Width_D, Height_D, Mode_Stretch, hBitmap_O )

   LOCAL Max_Width_D  := BT_BitmapWidth ( hBitmap_D )
   LOCAL Max_Height_D := BT_BitmapHeight( hBitmap_D )
   LOCAL Width_O      := BT_BitmapWidth ( hBitmap_O )
   LOCAL Height_O     := BT_BitmapHeight( hBitmap_O )

   bt_FillRectIsNIL( @Row_D, @Col_D, @Width_D, @Height_D, 0, 0, Max_Width_D, Max_Height_D )
   BT_BMP_PASTE( hBitmap_D, Col_D, Row_D, Width_D, Height_D, hBitmap_O, 0, 0, Width_O, Height_O, Mode_Stretch, BT_BITMAP_OPAQUE, 0 )

   RETURN Nil

FUNCTION BT_BitmapPasteTransparent( hBitmap_D, Row_D, Col_D, Width_D, Height_D, Mode_Stretch, hBitmap_O, aRGBcolor_transp )

   LOCAL Max_Width_D  := BT_BitmapWidth ( hBitmap_D )
   LOCAL Max_Height_D := BT_BitmapHeight( hBitmap_D )
   LOCAL Width_O      := BT_BitmapWidth ( hBitmap_O )
   LOCAL Height_O     := BT_BitmapHeight( hBitmap_O )
   LOCAL ColorRef_Transp:= iif( Valtype( aRGBcolor_transp ) == "U", BT_BMP_GETINFO( hBitmap_O, BT_BITMAP_INFO_GETCOLORPIXEL, 0, 0 ), ArrayRGB_TO_COLORREF( aRGBcolor_transp ) )

   bt_FillRectIsNIL( @Row_D, @Col_D, @Width_D, @Height_D, 0, 0, Max_Width_D, Max_Height_D )
   BT_BMP_PASTE( hBitmap_D, Col_D, Row_D, Width_D, Height_D, hBitmap_O, 0, 0, Width_O, Height_O, Mode_Stretch, BT_BITMAP_TRANSPARENT, ColorRef_Transp )

   RETURN Nil

FUNCTION BT_BitmapPasteAlphaBlend( hBitmap_D, Row_D, Col_D, Width_D, Height_D, Alpha, Mode_Stretch, hBitmap_O )

   LOCAL Max_Width_D  := BT_BitmapWidth ( hBitmap_D )
   LOCAL Max_Height_D := BT_BitmapHeight( hBitmap_D )
   LOCAL Width_O      := BT_BitmapWidth ( hBitmap_O )
   LOCAL Height_O     := BT_BitmapHeight( hBitmap_O )

   bt_FillRectIsNIL( @Row_D, @Col_D, @Width_D, @Height_D, 0, 0, Max_Width_D, Max_Height_D )
   BT_BMP_PASTE_ALPHABLEND( hBitmap_D, Col_D, Row_D, Width_D, Height_D, hBitmap_O, 0, 0, Width_O, Height_O, Alpha, Mode_Stretch )

   RETURN Nil

   //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

FUNCTION BT_BitmapCaptureDesktop( Row, Col, Width, Height )

   LOCAL New_hBitmap
   LOCAL hWnd := BT_GetDesktopHandle()
   LOCAL Max_Width  := BT_DesktopWidth()
   LOCAL Max_Height := BT_DesktopHeight()

   bt_FillRectIsNIL( @Row, @Col, @Width, @Height, 0, 0, Max_Width, Max_Height )
   bt_AdjustWidthHeightRect( Row, Col, @Width, @Height, Max_Width, Max_Height )
   New_hBitmap := BT_BMP_CAPTURESCR( hWnd, Col, Row, Width, Height, BT_BITMAP_CAPTURE_DESKTOP )

   RETURN New_hBitmap

FUNCTION BT_BitmapCaptureWindow( hWnd, Row, Col, Width, Height )

   LOCAL New_hBitmap
   LOCAL Max_Width  := BT_WindowWidth( hWnd )
   LOCAL Max_Height := BT_WindowHeight( hWnd )

   bt_FillRectIsNIL( @Row, @Col, @Width, @Height, 0, 0, Max_Width, Max_Height )
   bt_AdjustWidthHeightRect( Row, Col, @Width, @Height, Max_Width, Max_Height )
   New_hBitmap := BT_BMP_CAPTURESCR( hWnd, Col, Row, Width, Height, BT_BITMAP_CAPTURE_WINDOW )

   RETURN New_hBitmap

FUNCTION BT_BitmapCaptureClientArea( hWnd, Row, Col, Width, Height )

   LOCAL New_hBitmap
   LOCAL Max_Width  := BT_ClientAreaWidth( hWnd )
   LOCAL Max_Height := BT_ClientAreaHeight( hWnd )

   bt_FillRectIsNIL( @Row, @Col, @Width, @Height, 0, 0, Max_Width, Max_Height )
   bt_AdjustWidthHeightRect( Row, Col, @Width, @Height, Max_Width, Max_Height )
   New_hBitmap := BT_BMP_CAPTURESCR( hWnd, Col, Row, Width, Height, BT_BITMAP_CAPTURE_CLIENTAREA )

   RETURN New_hBitmap

   //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

FUNCTION BT_BitmapClipboardGet( hWnd )

   LOCAL hBitmap

   hBitmap := BT_BMP_GET_CLIPBOARD( hWnd )

   RETURN hBitmap

FUNCTION BT_BitmapClipboardPut( hWnd, hBitmap )

   LOCAL lRet := BT_BMP_PUT_CLIPBOARD( hWnd, hBitmap )

   RETURN lRet

FUNCTION BT_BitmapClipboardClean( hWnd )

   LOCAL lRet := BT_BMP_CLEAN_CLIPBOARD( hWnd )

   RETURN lRet

FUNCTION BT_BitmapClipboardIsEmpty()

   LOCAL lRet := BT_BMP_CLIPBOARD_ISEMPTY()

   RETURN lRet
