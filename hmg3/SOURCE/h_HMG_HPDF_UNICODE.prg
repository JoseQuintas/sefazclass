// by Dr. Claudio Soto (May 2014)

MEMVAR _HMG_SYSDATA
#include <hmg.ch>
#include "harupdf.ch"


function _HMG_HPDF_MULTILINE_PRINT_UNICODE ( nRow, nCol, nToRow, nToCol, cFontName, nFontSize, aFontColor, cText, lBold, lItalic, lUnderline, lStrikeout, lColor, lFont, lSize, cAlign )
   local nBitmapWidth, nBitmapHeight, nAlign, cRawImage, hBitmap, BTstruct, hDC, hFont
   local   aBackColor := WHITE
   default cFontName := _HMG_SYSDATA [ 150 ][ 8 ]
   default nFontSize := _HMG_SYSDATA [ 150 ][ 9 ]
   default aFontColor := BLACK
   default lBold := .f.
   default lItalic := .f.
   default lUnderline := .f.
   default lStrikeout := .f.
   default lColor := .f.
   default lFont := .f.
   default lSize := .f.
   default cAlign := ''

   if _HMG_SYSDATA[ 150 ][ 1 ] == nil // PDF object not found!
      _HMG_HPDF_Error( 3 )
      return nil
   endif
   if _HMG_SYSDATA[ 150 ][ 7 ] == nil // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      return nil
   endif

   nBitmapWidth  := _HMG_HPDF_MM2Pixel ( nToCol - nCol )
   nBitmapHeight := _HMG_HPDF_MM2Pixel ( nToRow - nRow )

   IF (nBitmapWidth <= 0) .OR. (nBitmapHeight <= 0)
      RETURN NIL
   ENDIF

   hBitmap := BT_BitmapCreateNew (nBitmapWidth, nBitmapHeight, aBackColor)

   hDC := BT_CreateDC (hBitmap, BT_HDC_BITMAP, @BTstruct)

      #define DT_LEFT     0
      #define DT_CENTER   1
      #define DT_RIGHT    2
      do case
      case HMG_UPPER( cAlign ) == 'CENTER'
           nAlign := DT_CENTER
      case HMG_UPPER( cAlign ) == 'RIGHT'
           nAlign := DT_RIGHT
      case HMG_UPPER( cAlign ) == 'JUSTIFY'   // not support
           nAlign := DT_LEFT
      otherwise
           nAlign := DT_LEFT
      endcase

      hFont := _HMG_HPDF_CREATEFONT (hDC, cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout )

      _HMG_HPDF_DRAWTEXT (hDC, hFont, RGB(aFontColor[1], aFontColor[2], aFontColor[3]), cText, nBitmapWidth, nBitmapHeight, nAlign)

      DeleteObject (hFont)

   BT_DeleteDC (BTstruct)

   cRawImage := GetTempFolder() + "_HMG_HPDF_RawBitmapBits.dat"

   _HMG_HPDF_SAVEBITMAPBITS (hBitmap, cRawImage)
   _HMG_HPDF_DRAWIMAGERAW ( cRawImage, nRow, nCol, nToRow, nToCol, BT_BitmapWidth(hBitmap), BT_BitmapHeight(hBitmap) )

// BT_BitmapSaveFile (hBitmap, "_HMG_HPDF_tmp.BMP")

   BT_BitmapRelease (hBitmap)

   FERASE ( cRawImage )

return nil


function _HMG_HPDF_DRAWIMAGERAW ( cRawImage, nRow, nCol, nToRow, nToCol, nImageWidth, nImageHeight )
   local nHeight := _HMG_SYSDATA[ 150 ][ 5 ]
   local nxPos := _HMG_HPDF_MM2Pixel( nCol )
   local nyPos := nHeight - _HMG_HPDF_MM2Pixel( nRow )
   local oImage := nil

   if _HMG_SYSDATA[ 150 ][ 1 ] == nil // PDF object not found!
      _HMG_HPDF_Error( 3 )
      return nil
   endif
   if _HMG_SYSDATA[ 150 ][ 7 ] == nil // PDF Page object not found!
      _HMG_HPDF_Error( 5 )
      return nil
   endif

   oImage := _HPDF_LOADRAWBITMAP (_HMG_SYSDATA[ 150 ][ 1 ], cRawImage, nImageWidth, nImageHeight)

   IF HB_ISNUMERIC (oImage)
      // MsgHMGError ("Error Nro: "+Str(oImage))
      _HMG_HPDF_Error( 7 )
      return nil
   endif

   if Empty( oImage )
      _HMG_HPDF_Error( 7 )
      return nil
   endif
   HPDF_Page_DrawImage( _HMG_SYSDATA[ 150 ][ 7 ], oImage, nxPos, nyPos - _HMG_HPDF_MM2Pixel( nToRow - nRow ), _HMG_HPDF_MM2Pixel( nToCol - nCol ), _HMG_HPDF_MM2Pixel( nToRow - nRow ) )
return nil





// by Dr. Claudio Soto (May 2014)

#pragma BEGINDUMP

#ifndef COMPILE_HMG_UNICODE
   #define COMPILE_HMG_UNICODE   // Force to compile in UNICODE
#endif

#include "HMG_UNICODE.h"

#include <windows.h>
#include "hbapi.h"
#include "hpdf.h"


HB_FUNC ( _HMG_HPDF_DRAWTEXT )
{
   HDC    hDC   = (HDC)     HMG_parnl (1);
   HFONT  hFont = (HFONT)   HMG_parnl (2);
   COLORREF RGBcolor = (COLORREF) hb_parni (3);
   TCHAR *cText = (TCHAR *) HMG_parc  (4);
   RECT rect = {0,0,0,0};
   rect.right  = hb_parni (5);
   rect.bottom = hb_parni (6);
   UINT nAlign = (UINT) hb_parni (7);


   SetGraphicsMode (hDC, GM_ADVANCED);

   SelectObject (hDC, hFont);
   SetTextColor (hDC, RGBcolor);
// SetBkColor (hDC, RGB (255,255,255));
   SetBkMode (hDC, TRANSPARENT);

   DrawText (hDC, cText, -1, &rect, DT_NOCLIP | DT_WORDBREAK | /*DT_EXTERNALLEADING |*/ DT_NOPREFIX | nAlign);
}


HB_FUNC ( _HMG_HPDF_CREATEFONT )
{
   HFONT hFont ;
   int bold = FW_NORMAL;
   int italic = 0;
   int underline = 0;
   int strikeout = 0;

   if ( hb_parl (4) )
      bold = FW_BOLD;

   if ( hb_parl (5) )
      italic = 1;

   if ( hb_parl (6) )
      underline = 1;

   if ( hb_parl (7) )
      strikeout = 1;

   HDC hDC = (HDC) HMG_parnl (1);
   TCHAR *FontName = (TCHAR *) HMG_parc (2);
   INT FontSize = hb_parni (3);

   SetGraphicsMode (hDC, GM_ADVANCED);

   FontSize = FontSize * GetDeviceCaps (hDC, LOGPIXELSY) / 72;   // Size of font in logic points

   hFont = CreateFont (0-FontSize, 0, 0, 0, bold, italic, underline, strikeout,
           DEFAULT_CHARSET, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_DONTCARE, FontName);

   HMG_retnl ((LONG_PTR) hFont );
}


extern HPDF_Doc hb_HPDF_Doc_par (int);

HB_FUNC ( _HPDF_LOADRAWBITMAP )
{
    char       *FileName;
    HPDF_Doc    hpdf_Doc;
    HPDF_Image  image;
    UINT        nWidth, nHeight;

    hpdf_Doc = (HPDF_Doc) hb_HPDF_Doc_par (1);
    FileName = (char *)   hb_parc (2);
    nWidth   = (UINT)     hb_parni (3);
    nHeight  = (UINT)     hb_parni (4);

    image = HPDF_LoadRawImageFromFile (hpdf_Doc, FileName, nWidth, nHeight, HPDF_CS_DEVICE_RGB);

    if (image == NULL)
        hb_retnl((LONG) HPDF_GetError (hpdf_Doc));
    else
        hb_retptr ((void *) image); // Return image (void* ptr)
}



HB_FUNC ( _HMG_HPDF_SAVEBITMAPBITS )
{
   HBITMAP hBitmap  = (HBITMAP) HMG_parnl (1);
   TCHAR  *FileName = (TCHAR*)  HMG_parc  (2);
   HGLOBAL hBits;
   LPBYTE  lp_Bits, _R, _B;
   BYTE aux;
   DWORD nBytes_Bits;
   HDC memDC;
   BITMAPINFO BI;
   BITMAP bm;
   HANDLE  hFile;
   DWORD nBytes_Written;
   INT y, x;

   GetObject(hBitmap, sizeof(BITMAP), (LPBYTE)&bm);

   BI.bmiHeader.biSize          = sizeof(BITMAPINFOHEADER);
   BI.bmiHeader.biWidth         = bm.bmWidth;
   BI.bmiHeader.biHeight        = - bm.bmHeight;
   BI.bmiHeader.biPlanes        = 1;
   BI.bmiHeader.biBitCount      = 24;
   BI.bmiHeader.biCompression   = BI_RGB;
   BI.bmiHeader.biSizeImage     = 0;
   BI.bmiHeader.biXPelsPerMeter = 0;
   BI.bmiHeader.biYPelsPerMeter = 0;
   BI.bmiHeader.biClrUsed       = 0;
   BI.bmiHeader.biClrImportant  = 0;

   bm.bmWidthBytes = (bm.bmWidth * BI.bmiHeader.biBitCount + 31) / 32 * 4;
   nBytes_Bits  = (DWORD)(bm.bmWidthBytes * labs(bm.bmHeight));

   hBits = GlobalAlloc (GHND, (DWORD) nBytes_Bits);
   if (hBits == NULL)
       return;
   else
      lp_Bits = (LPBYTE) GlobalLock (hBits);

   memDC = CreateCompatibleDC(NULL);
   GetDIBits (memDC, hBitmap, 0, bm.bmHeight, (LPVOID) lp_Bits, &BI, DIB_RGB_COLORS);

   hFile = CreateFile (FileName, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN, NULL);

   for (y = 0; y < bm.bmHeight; y++)
   {
#define RBG_SWAP
#ifdef RBG_SWAP
      for (x=0; x < bm.bmWidth; x++)
      {
         _R = (LPBYTE)(lp_Bits + (LONG)(y) * bm.bmWidthBytes + x*3 + 0);
      // _G = (LPBYTE)(lp_Bits + (LONG)(y) * bm.bmWidthBytes + x*3 + 1);
         _B = (LPBYTE)(lp_Bits + (LONG)(y) * bm.bmWidthBytes + x*3 + 2);

         aux  = *_R;
         *_R = *_B;
         *_B = aux;
      }
#endif
      WriteFile (hFile, (LPBYTE)(lp_Bits + (LONG)(y) * bm.bmWidthBytes),  (bm.bmWidth * 3),  &nBytes_Written, NULL);
   }

   CloseHandle (hFile);

   DeleteDC (memDC);
   GlobalUnlock (hBits);
   GlobalFree (hBits);
}


#pragma enddump
