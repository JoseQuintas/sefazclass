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

#require "hbzebra"
#include "hmg.ch"

FUNCTION  HMG_CreateBarCode( cCode, cType, nLineWidth, nLineHeight, lShowdigits, cImageFileName, aBarColor, aBackColor, lCheckSum, lWide2_5, lWide3 )

   LOCAL hBitmap, cTextCode, nFlags
   DEFAULT nLineWidth := 2
   DEFAULT nLineHeight := 100
   DEFAULT aBarColor := BLACK
   DEFAULT aBackColor := WHITE
   DEFAULT lCheckSum := .f.
   DEFAULT lWide2_5 := .f.
   DEFAULT lWide3 := .f.
   DEFAULT lShowDigits := .f.
   DEFAULT cImageFileName := ''

   nFlags := 0
   IF lChecksum
      nFlags := nFlags + HB_ZEBRA_FLAG_CHECKSUM
   ENDIF
   IF lWide2_5
      nFlags := nFlags + HB_ZEBRA_FLAG_WIDE2_5
   ENDIF
   IF lWide3
      nFlags := nFlags + HB_ZEBRA_FLAG_WIDE3
   ENDIF

   IF nFlags == 0
      nFlags := Nil
   ENDIF

   cTextCode   := ""
   hBitmap := HMG_Zebra_CreateBitmapBarCode ( aBarColor, aBackColor, nLineWidth, nLineHeight, cType, cCode, nFlags, lShowdigits, @cTextCode )

   IF hBitmap == 0
      RETURN hBitmap
   ENDIF

   IF HMG_len( cImageFileName ) <> 0
      BT_BitmapSaveFile( hBitmap, cImageFileName, BT_FILEFORMAT_PNG )
      BT_BitmapRelease ( hBitmap )
      RETURN 1
   ENDIF

RETURN hBitmap




*-----------------------------------------------------------------------------------------------------------------------*
FUNCTION HMG_Zebra_CreateBitmapBarCode (aBarColor, aBackColor, nLineWidth, nLineHeight, cType, cCode, nFlags, lShowdigits, cTextCode)
*-----------------------------------------------------------------------------------------------------------------------*
LOCAL hBitmap:=0, hZebra
LOCAL hDC, BTstruct, nFontSize
LOCAL cFont := 'Arial'
LOCAL nSizeWidth, nSizeHeight

   SWITCH cType
   CASE "EAN13"      ; hZebra := hb_zebra_create_ean13( cCode, nFlags )   ; EXIT
   CASE "EAN8"       ; hZebra := hb_zebra_create_ean8( cCode, nFlags )    ; EXIT
   CASE "UPCA"       ; hZebra := hb_zebra_create_upca( cCode, nFlags )    ; EXIT
   CASE "UPCE"       ; hZebra := hb_zebra_create_upce( cCode, nFlags )    ; EXIT
   CASE "CODE39"     ; hZebra := hb_zebra_create_code39( cCode, nFlags )  ; EXIT
   CASE "ITF"        ; hZebra := hb_zebra_create_itf( cCode, nFlags )     ; EXIT
   CASE "MSI"        ; hZebra := hb_zebra_create_msi( cCode, nFlags )     ; EXIT
   CASE "CODABAR"    ; hZebra := hb_zebra_create_codabar( cCode, nFlags ) ; EXIT
   CASE "CODE93"     ; hZebra := hb_zebra_create_code93( cCode, nFlags )  ; EXIT
   CASE "CODE11"     ; hZebra := hb_zebra_create_code11( cCode, nFlags )  ; EXIT
   CASE "CODE128"    ; hZebra := hb_zebra_create_code128( cCode, nFlags ) ; EXIT
   CASE "PDF417"     ; hZebra := hb_zebra_create_pdf417( cCode, nFlags ); nLineHeight := nLineWidth * 3 ; lShowDigits := .f.; EXIT
   CASE "DATAMATRIX" ; hZebra := hb_zebra_create_datamatrix( cCode, nFlags ); nLineHeight := nLineWidth ; lShowDigits := .f.; EXIT
   CASE "QRCODE"     ; hZebra := hb_zebra_create_qrcode( cCode, nFlags ); nLineHeight := nLineWidth ; lShowDigits := .f.; EXIT
   ENDSWITCH

   IF hZebra != NIL
      IF hb_zebra_geterror( hZebra ) == 0
         cTextCode   := hb_zebra_getcode (hZebra)
         nSizeWidth  := HMG_Zebra_GetWidth  (hZebra, nLineWidth, nLineHeight, NIL)
         nSizeHeight := HMG_Zebra_GetHeight (hZebra, nLineWidth, nLineHeight, NIL) + IIF( lShowDigits, ( nLineWidth * 10 ) + 20, 0 )
         hBitmap := BT_BitmapCreateNew ( nSizeWidth, nSizeHeight, aBackColor )
         hDC := BT_CreateDC ( hBitmap, BT_HDC_BITMAP, @BTstruct)
         HMG_Zebra_Draw ( hZebra, hDC, aBarColor, 0, 0, nLineWidth, nLineHeight, NIL )
         IF lShowDigits
            nFontSize := ( ( nSizeWidth / HMG_LEN(cTextCode))/ 96 * 72 * 1 )
            BT_DrawText ( hDC, nSizeHeight - (( nLineWidth * 10 ) + 20 ) + 5, nSizeWidth/2, cTextCode, cFont, nFontSize, aBarColor, aBackColor, ,BT_TEXT_CENTER )
         ENDIF
         BT_DeleteDC (BTstruct)
      ELSE
         MsgInfo ("Type "+ cType + CRLF +"Code "+ cCode+ CRLF+ "Error  "+LTrim(hb_valtostr(hb_zebra_geterror(hZebra))))
      ENDIF
      hb_zebra_destroy (hZebra)
   ELSE
      MsgStop("Invalid barcode type !", cType)
   ENDIF
RETURN hBitmap


*-----------------------------------------------------------------------------------------------*
FUNCTION HMG_Zebra_Draw ( hZebra, hDC, aBarColor, nRow, nCol, nLineWidth, nLineHeight, iFlags )
*-----------------------------------------------------------------------------------------------*
   IF hb_zebra_GetError( hZebra ) != 0
      RETURN HB_ZEBRA_ERROR_INVALIDZEBRA
   ENDIF
//     hb_zebra_draw ( hZebra,   bCodeBlock,                                                           dX,   dY,     dWidth,     dHeight, iFlags )
RETURN hb_zebra_draw ( hZebra, {| x, y, w, h | BT_DrawFillRectangle ( hDC, y, x, w, h, aBarColor )}, nCol, nRow, nLineWidth, nLineHeight, iFlags )


*-----------------------------------------------------------------------------------------------*
FUNCTION HMG_Zebra_GetWidth (hZebra, nLineWidth, nLineHeight, iFlags)
*-----------------------------------------------------------------------------------------------*
LOCAL x1:= 0, y1 := 0, nBarWidth := 0, nBarHeight := 0
   // always --> nBarHeight = nLineHeight
   IF hb_zebra_GetError( hZebra ) != 0
      RETURN HB_ZEBRA_ERROR_INVALIDZEBRA
   ENDIF
// hb_zebra_draw ( hZebra,   bCodeBlock,                                            dX, dY,     dWidth,     dHeight, iFlags )
//   hb_zebra_draw ( hZebra, {| x, y, w, h | nBarWidth:=x+w-x1, nBarHeight:=y+h-y1 }, x1, y1, nLineWidth, nLineHeight, iFlags )
//REPORT BUG FOR EDK
hb_zebra_draw ( hZebra, {| x, y, w, h | nBarWidth:=MAX(x+w-x1, nBarWidth), nBarHeight:=MAX(y+h-y1, nBarHeight) }, x1, y1, nLineWidth, nLineHeight, iFlags )

RETURN nBarWidth


*-----------------------------------------------------------------------------------------------*
FUNCTION HMG_Zebra_GetHeight (hZebra, nLineWidth, nLineHeight, iFlags)
*-----------------------------------------------------------------------------------------------*
LOCAL x1:= 0, y1 := 0, nBarWidth := 0, nBarHeight := 0
   // always --> nBarHeight = nLineHeight
   IF hb_zebra_GetError( hZebra ) != 0
      RETURN HB_ZEBRA_ERROR_INVALIDZEBRA
   ENDIF
// hb_zebra_draw ( hZebra,   bCodeBlock,                                            dX, dY,     dWidth,     dHeight, iFlags )
//   hb_zebra_draw ( hZebra, {| x, y, w, h | nBarWidth:=x+w-x1, nBarHeight:=y+h-y1 }, x1, y1, nLineWidth, nLineHeight, iFlags )
//REPORT BUG FOR EDK
   hb_zebra_draw ( hZebra, {| x, y, w, h | nBarWidth:=MAX(x+w-x1, nBarWidth), nBarHeight:=MAX(y+h-y1, nBarHeight) }, x1, y1, nLineWidth, nLineHeight, iFlags )
RETURN nBarHeight

