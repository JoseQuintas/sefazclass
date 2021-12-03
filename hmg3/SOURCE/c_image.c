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


/*
  The adaptation of the source code of this file to support UNICODE character set and WIN64 architecture was made
  by Dr. Claudio Soto, November 2012 and June 2014 respectively.
  mail: <srvet@adinet.com.uy>
  blog: http://srvet.blogspot.com
*/

#include "HMG_UNICODE.h"



#ifndef CINTERFACE
   #define CINTERFACE
#endif


//#define _WIN32_IE      0x0500
//#define HB_OS_WIN_32_USED
//#define _WIN32_WINNT   0x0400
//#define WINVER  0x0410


#include <windows.h>
#include <commctrl.h>
#include <tchar.h>
#include "hbapi.h"

HBITMAP bt_bmp_create_24bpp (int Width, int Height);
HBITMAP bt_LoadOLEPicture (WCHAR * FileName, WCHAR * TypePictureResource);
HBITMAP bt_LoadGDIPlusPicture (WCHAR *FileName, WCHAR *TypePictureResource);
BOOL bt_bmp_SaveFile (HBITMAP hBitmap, WCHAR* FileName, INT nTypePicture);


HBITMAP HMG_LoadPicture ( TCHAR *FileName, int New_Width, int New_Height, HWND hWnd, int ScaleStretch, int Transparent, long BackgroundColor, int AdjustImage, long TransparentColor );


HB_FUNC (INITIMAGE)
{
  // 1) hParentForm,
  // 2) x
  // 3) y
  // 4) invisible
  // 5) action and tooltip

        HWND  h;
        HWND hwnd;
        int Style;

        hwnd = (HWND) HMG_parnl (1);

        Style = WS_CHILD | SS_BITMAP ;

        if ( ! hb_parl (4) )
             Style = Style | WS_VISIBLE ;

        if ( hb_parl (5) )
             Style = Style | SS_NOTIFY ;

        h = CreateWindowEx ( 0L , WC_STATIC /*_TEXT("Static")*/ ,
                            _TEXT(""), Style, hb_parni(2), hb_parni(3), 0, 0, hwnd, NULL, GetModuleHandle(NULL) , NULL ) ;

        HMG_retnl ((LONG_PTR) h);
}


HB_FUNC (C_SETPICTURE)
{

// 1. CONTROL HANDLE
// 2. FILENAME
// 3. WIDTH
// 4. HEIGHT
// 5. ScaleStretch
// 6. Transparent
// 7. BackgroundColor
// 8. AdjustImage
// 9. TransparentColor

    HBITMAP hBitmap;
    int  ScaleStretch     = hb_parni(5);
    int  Transparent      = hb_parni(6);
    long BackgroundColor  = hb_parnl(7);
    int  AdjustImage      = hb_parni(8);
    long TransparentColor = hb_parnl(9);

    hBitmap = HMG_LoadPicture ((TCHAR*)HMG_parc(2), hb_parni(3), hb_parni(4), (HWND) HMG_parnl(1), ScaleStretch, Transparent, BackgroundColor, AdjustImage, TransparentColor);

    if (hBitmap!=NULL)
        SendMessage ( (HWND) HMG_parnl(1), (UINT)STM_SETIMAGE, (WPARAM)IMAGE_BITMAP, (LPARAM)hBitmap);

    HMG_retnl ((LONG_PTR) hBitmap);
}



// by Dr. Claudio Soto ( May 2013 )



//*******************************************************************************************************
//* HMG_LoadImage (TCHAR *FileName) ---> Return hBitmap (Load: BMP, GIF, JPG, TIF, WMF, CUR, PNG)
//*******************************************************************************************************
HBITMAP HMG_LoadImage (TCHAR *FileName)
{
    HBITMAP hBitmap;

  // First find BMP image in resourses (.EXE file)
     hBitmap = (HBITMAP) LoadImage (GetModuleHandle(NULL), FileName, IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION);

  // If fail: find BMP in disk
     if (hBitmap == NULL)
         hBitmap = (HBITMAP) LoadImage (NULL, FileName, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_CREATEDIBSECTION);

  // If fail: find JPG Image in resourses
     if (hBitmap == NULL)
         hBitmap = bt_LoadOLEPicture (HMG_ToUnicode(FileName), HMG_ToUnicode(_TEXT("JPG")));

  // If fail: find GIF Image in resourses
     if (hBitmap == NULL)
         hBitmap = bt_LoadOLEPicture (HMG_ToUnicode(FileName), HMG_ToUnicode(_TEXT("GIF")));

   // If fail: find WMF Image in resourses
     if (hBitmap == NULL)
         hBitmap = bt_LoadOLEPicture (HMG_ToUnicode(FileName), HMG_ToUnicode(_TEXT("WMF")));

   // If fail: find EMF Image in resourses
     if (hBitmap == NULL)
         hBitmap = bt_LoadOLEPicture (HMG_ToUnicode(FileName), HMG_ToUnicode(_TEXT("EMF")));

  // If fail: find CUR Image in resourses
     if (hBitmap == NULL)
         hBitmap = bt_LoadOLEPicture (HMG_ToUnicode(FileName), HMG_ToUnicode(_TEXT("CUR")));

  // If fail: find TIF Image in resourses
     if (hBitmap == NULL)
         hBitmap = bt_LoadOLEPicture (HMG_ToUnicode(FileName), HMG_ToUnicode(_TEXT("TIF")));

  // If fail: find PNG Image in resourses
     if (hBitmap == NULL)
         hBitmap = bt_LoadGDIPlusPicture (HMG_ToUnicode(FileName), HMG_ToUnicode(_TEXT("PNG")));

  // If fail: find JPG, GIF, WMF, EMF and TIF Image in disk
     if (hBitmap == NULL)
         hBitmap = bt_LoadOLEPicture (HMG_ToUnicode(FileName), NULL);

  // If fail: find PNG Image in disk
     if (hBitmap == NULL)
         hBitmap = bt_LoadGDIPlusPicture (HMG_ToUnicode(FileName), NULL);

/*
  // Convert DIB into Compatible Bitmap

     HBITMAP hBitmapCompatible = NULL;
     if (hBitmap != NULL)
         hBitmapCompatible = CopyImage (hBitmap, IMAGE_BITMAP, 0, 0, LR_COPYDELETEORG);
     return hBitmapCompatible;
*/

   return hBitmap;
}



//********************************************************************************************************************************
//* HMG_LoadPicture (FileName, New_Width, New_Height, ...) ---> Return hBitmap (Load: BMP, GIF, JPG, TIF, WMF, CUR, PNG)
//********************************************************************************************************************************
HBITMAP HMG_LoadPicture ( TCHAR *FileName, int New_Width, int New_Height, HWND hWnd, int ScaleStretch, int Transparent, long BackgroundColor, int AdjustImage, long TransparentColor )
{
   HBITMAP hBitmap_New, hBitmap;
   RECT rect, rect2;
   BITMAP bm;
   long Image_Width, Image_Height;
   HDC hDC, memDC1, memDC2;
   POINT Point;
   COLORREF color_transp;
   HBRUSH hBrush;

   hBitmap = HMG_LoadImage (FileName);
   if (hBitmap == NULL)
       return NULL;

   GetObject (hBitmap, sizeof(BITMAP), &bm);
   Image_Width  = bm.bmWidth;
   Image_Height = bm.bmHeight;

   if (New_Width < 0)   // load image with original Width
       New_Width  = Image_Width;

   if (New_Height < 0) // load image with original Height
       New_Height = Image_Height;


   if (New_Width == 0 || New_Height == 0)
       GetClientRect (hWnd, &rect);   // ???, may be better --->  return NULL;
   else
       SetRect(&rect, 0, 0, New_Width, New_Height);

   SetRect(&rect2, 0, 0, rect.right, rect.bottom);

   if (hWnd == NULL)
       hWnd   = GetDesktopWindow();

   hDC    = GetDC (hWnd);
   memDC2 = CreateCompatibleDC (hDC);
   memDC1 = CreateCompatibleDC (hDC);


   if (ScaleStretch == 0)
   {  if ((int)Image_Width * rect.bottom / Image_Height <= rect.right)
         rect.right  = (int)Image_Width * rect.bottom / Image_Height;
      else
         rect.bottom = (int)Image_Height * rect.right / Image_Width;

      if (AdjustImage == 1)
      {   New_Width  = (long)rect.right;
          New_Height = (long)rect.bottom;
      }
      else
      {   // Center Image
          rect.left = (int)(New_Width  - rect.right ) / 2;
          rect.top  = (int)(New_Height - rect.bottom) / 2;
      }
   }


   hBitmap_New = CreateCompatibleBitmap (hDC, New_Width, New_Height);
   // hBitmap_New = bt_bmp_create_24bpp (New_Width, New_Height);

   SelectObject (memDC1, hBitmap);
   SelectObject (memDC2, hBitmap_New);

   if (BackgroundColor == -1)
       FillRect(memDC2, &rect2,(HBRUSH) GetSysColorBrush(COLOR_BTNFACE));
   else
   {   hBrush = CreateSolidBrush(BackgroundColor);
       FillRect(memDC2, &rect2, hBrush);
       DeleteObject(hBrush);
   }

   GetBrushOrgEx (memDC2, &Point);
   SetStretchBltMode (memDC2, HALFTONE);
   SetBrushOrgEx (memDC2, Point.x, Point.y, NULL);


   if (Transparent == 1)
   {  if (TransparentColor == -1)
          color_transp = GetPixel (memDC1, 0, 0);
      else
          color_transp = (COLORREF) TransparentColor;
      TransparentBlt (memDC2, rect.left, rect.top, rect.right, rect.bottom, memDC1, 0, 0, Image_Width, Image_Height, color_transp);
   }
   else
      StretchBlt (memDC2, rect.left, rect.top, rect.right, rect.bottom, memDC1, 0, 0, Image_Width, Image_Height, SRCCOPY);

   DeleteDC  (memDC1);
   DeleteDC  (memDC2);
   ReleaseDC (hWnd, hDC);

   DeleteObject (hBitmap);

   return hBitmap_New;
}



//**************************************************************************
// by Dr. Claudio Soto (June 2014)
//**************************************************************************


HIMAGELIST HMG_ImageListLoadFirst (TCHAR *FileName, int cGrow, int Transparent, int *nWidth, int *nHeight)
{
   HIMAGELIST hImageList;
   HBITMAP hBitmap;
   BITMAP Bmp;
                                                     //    ScaleStretch,  Transparent, BackgroundColor,  AdjustImage,   TransparentColor
   hBitmap = HMG_LoadPicture (FileName, -1, -1, NULL,                 0,            0,              -1,            0,                 -1 );
   if (hBitmap == NULL)
       return NULL;

   GetObject (hBitmap, sizeof(BITMAP), &Bmp);

   if (nWidth != NULL)
      *nWidth = Bmp.bmWidth;

   if (nHeight != NULL)
      *nHeight = Bmp.bmHeight;

   TCHAR TempPathFileName [MAX_PATH];
   GetTempPath (MAX_PATH, TempPathFileName);
   lstrcat (TempPathFileName, _TEXT("_HMG_tmp.BMP"));
   bt_bmp_SaveFile (hBitmap, HMG_ToUnicode (TempPathFileName), 0);
   DeleteObject (hBitmap);

   if (Transparent == 1)
      hImageList = ImageList_LoadImage (GetModuleHandle(NULL), TempPathFileName, Bmp.bmWidth, cGrow, CLR_DEFAULT, IMAGE_BITMAP, LR_LOADFROMFILE | LR_CREATEDIBSECTION | LR_LOADMAP3DCOLORS | LR_LOADTRANSPARENT );
   else
      hImageList = ImageList_LoadImage (GetModuleHandle(NULL), TempPathFileName, Bmp.bmWidth, cGrow, CLR_NONE,    IMAGE_BITMAP, LR_LOADFROMFILE | LR_CREATEDIBSECTION | LR_LOADMAP3DCOLORS );

   DeleteFile (TempPathFileName);

   return hImageList;
}


void HMG_ImageListAdd (HIMAGELIST hImageList, TCHAR *FileName, int Transparent)
{
   HBITMAP hBitmap;
   if (hImageList == NULL)
       return;
                                                     //    ScaleStretch,  Transparent, BackgroundColor,  AdjustImage,   TransparentColor
   hBitmap = HMG_LoadPicture (FileName, -1, -1, NULL,                 0,            0,              -1,            0,                 -1 );
   if (hBitmap == NULL)
       return;

   if (Transparent == 1)
      ImageList_AddMasked (hImageList, hBitmap, CLR_DEFAULT);
   else
      ImageList_AddMasked (hImageList, hBitmap, CLR_NONE);

   DeleteObject (hBitmap);
}

