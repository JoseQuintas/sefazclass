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


//#define _WIN32_IE      0x0500
//#define HB_OS_WIN_32_USED
//#define _WIN32_WINNT   0x0400


#include <shlobj.h>
#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbdefs.h"
#include "hbvm.h"


HBITMAP HMG_LoadPicture ( TCHAR *FileName, int New_Width, int New_Height, HWND hWnd, int ScaleStretch, int Transparent, long BackgroundColor, int AdjustImage, long TransparentColor );

BOOL bt_bmp_SaveFile (HBITMAP hBitmap, WCHAR* FileName, INT nTypePicture);


// by Dr. Claudio Soto (May 2014)
void HMG_GrayBitmap (HBITMAP hBitmap, int Transparent)
{
   HDC      memDC;
   BITMAP   Bmp;
   COLORREF TransRGB, RGBcolor;
   BYTE Gray;
   int x, y;

   GetObject (hBitmap, sizeof(BITMAP), &Bmp);
   memDC = CreateCompatibleDC (NULL);
   SelectObject (memDC, hBitmap);
   TransRGB = GetPixel (memDC, 0, 0);

   for (y=0; y < Bmp.bmHeight; y++)
   {   for (x=0; x < Bmp.bmWidth; x++)
       {   RGBcolor = GetPixel (memDC, x, y);
           if ((Transparent != 1) || (RGBcolor != TransRGB))
           {
               #define RGB_TO_GRAY(R,G,B) (BYTE)(INT)((FLOAT)R * 0.299 + (FLOAT)G * 0.587 + (FLOAT)B * 0.114)
               Gray = RGB_TO_GRAY(GetRValue(RGBcolor), GetGValue(RGBcolor), GetBValue(RGBcolor));
               SetPixel (memDC, x, y, RGB (Gray, Gray, Gray));
           }
       }
   }
   DeleteDC (memDC);
}


// by Dr. Claudio Soto (May 2014)

HIMAGELIST HMG_SetButtonImageList (HWND hButton, TCHAR *FileName, int Transparent, UINT uAlign, BOOL SetGray)
{
   HBITMAP hBitmap;
   HIMAGELIST hImageList;
   BITMAP Bmp;
   BUTTON_IMAGELIST bi;

   UNREFERENCED_PARAMETER (SetGray);
                                                     //    ScaleStretch,  Transparent, BackgroundColor,  AdjustImage,   TransparentColor
   hBitmap = HMG_LoadPicture (FileName, -1, -1, NULL,                 0,            0,              -1,            0,                 -1 );
   if ( hBitmap == NULL )
       return NULL;

   GetObject (hBitmap, sizeof(BITMAP), &Bmp);

   TCHAR TempPathFileName [MAX_PATH];
   GetTempPath (MAX_PATH, TempPathFileName);
   lstrcat (TempPathFileName, _TEXT("_HMG_tmp.BMP"));
   bt_bmp_SaveFile (hBitmap, HMG_ToUnicode (TempPathFileName), 0);
   DeleteObject (hBitmap);

   if (Transparent == 1)
      hImageList = ImageList_LoadImage (GetModuleHandle(NULL), TempPathFileName, Bmp.bmWidth, 6, CLR_DEFAULT, IMAGE_BITMAP, LR_LOADFROMFILE | LR_CREATEDIBSECTION | LR_LOADMAP3DCOLORS | LR_LOADTRANSPARENT );
   else
      hImageList = ImageList_LoadImage (GetModuleHandle(NULL), TempPathFileName, Bmp.bmWidth, 6, CLR_NONE,    IMAGE_BITMAP, LR_LOADFROMFILE | LR_CREATEDIBSECTION | LR_LOADMAP3DCOLORS );

   DeleteFile (TempPathFileName);

   bi.himl          = hImageList;
   bi.margin.left   = 10;
   bi.margin.top    = 10;
   bi.margin.bottom = 10;
   bi.margin.right  = 10;
   bi.uAlign        = uAlign;

   SendMessage (hButton, BCM_SETIMAGELIST, (WPARAM) 0, (LPARAM) &bi);

   return hImageList;
}


HB_FUNC( INITBUTTON )
{
   HWND hwnd;
   HWND hButton;
   int Style ;

   hwnd = (HWND) HMG_parnl (1);

   Style =  BS_NOTIFY | WS_CHILD | BS_PUSHBUTTON ;

   if ( hb_parl (10) )
      Style = Style | BS_FLAT ;

   if ( ! hb_parl (11) )
      Style = Style | WS_TABSTOP ;

   if ( ! hb_parl (12) )
      Style = Style | WS_VISIBLE ;

   if ( hb_parl (13) )
      Style = Style | BS_MULTILINE ;


   hButton = CreateWindowEx ( 0, WC_BUTTON /*_TEXT("Button")*/ ,
                           HMG_parc(2),
                           Style ,
                           hb_parni(4) ,
                           hb_parni(5) ,
                           hb_parni(6) ,
                           hb_parni(7) ,
                           hwnd ,
                           (HMENU) HMG_parnl(3) ,
                           GetModuleHandle(NULL) ,
                           NULL ) ;

   HMG_retnl ((LONG_PTR) hButton);
}


HB_FUNC ( INITIMAGEBUTTON )
{
   HWND hwnd = (HWND) HMG_parnl (1);
   HWND hButton;
   HBITMAP hBitmap;
   HIMAGELIST hImageList;
   BOOL _IsAppThemed = (BOOL) hb_parl (13);
   TCHAR *FileName = (TCHAR *) HMG_parc (8);

   int Style = BS_NOTIFY | BS_BITMAP | WS_CHILD | BS_PUSHBUTTON;

   if ( hb_parl (9) )
      Style = Style | BS_FLAT ;

   if ( ! hb_parl (11) )
      Style = Style | WS_VISIBLE ;

   if ( ! hb_parl (12) )
      Style = Style | WS_TABSTOP ;

   hButton = CreateWindowEx ( 0, WC_BUTTON /*_TEXT("Button")*/ ,
                           HMG_parc(2),
                           Style ,
                           hb_parni(4) ,
                           hb_parni(5) ,
                           hb_parni(6) ,
                           hb_parni(7) ,
                           hwnd ,
                           (HMENU) HMG_parnl(3) ,
                           GetModuleHandle(NULL) ,
                           NULL ) ;

   int Transparent = hb_parl(10) ? 0 : 1;

   if ( _IsAppThemed == FALSE )
   {                                                     //    ScaleStretch, Transparent, BackgroundColor,  AdjustImage,   TransparentColor
      hBitmap = HMG_LoadPicture ( FileName, -1, -1, NULL,                 0, Transparent,              -1,            0,                 -1 );

      SendMessage ( hButton, (UINT) BM_SETIMAGE, (WPARAM) IMAGE_BITMAP, (LPARAM) hBitmap);

      hb_reta (2);
      HMG_storvnl ((LONG_PTR) hButton,  -1, 1);
      HMG_storvnl ((LONG_PTR) hBitmap , -1, 2);
   }
   else
   {
      hImageList = HMG_SetButtonImageList (hButton, FileName, Transparent, BUTTON_IMAGELIST_ALIGN_CENTER, FALSE);

      hb_reta (2);
      HMG_storvnl ((LONG_PTR) hButton,      -1, 1);
      HMG_storvnl ((LONG_PTR) hImageList,   -1, 2);
   }
}


HB_FUNC( INITMIXEDBUTTON )
{
   HWND  hwnd = (HWND) HMG_parnl (1);
   TCHAR *FileName = (TCHAR *) HMG_parc (13);
   HIMAGELIST hImageList;
   HWND hButton;

   int Style = BS_NOTIFY | WS_CHILD | BS_PUSHBUTTON;

   if ( hb_parl (10) )
      Style = Style | BS_FLAT ;

   if ( ! hb_parl (11) )
      Style = Style | WS_TABSTOP ;

   if ( ! hb_parl (12) )
      Style = Style | WS_VISIBLE ;

   if ( hb_parl (15) )
      Style = Style | BS_MULTILINE ;

   hButton = CreateWindowEx( 0 , WC_BUTTON /*_TEXT("Button")*/ ,
                           HMG_parc(2),
                           Style ,
                           hb_parni(4) ,
                           hb_parni(5) ,
                           hb_parni(6) ,
                           hb_parni(7) ,
                           hwnd ,
                           (HMENU) HMG_parnl(3) ,
                           GetModuleHandle(NULL) ,
                           NULL ) ;

   int Transparent = hb_parl(16) ? 0 : 1;

   hImageList = HMG_SetButtonImageList (hButton, FileName, Transparent, hb_parni(14), FALSE);

   hb_reta (2);
   HMG_storvnl ((LONG_PTR) hButton,      -1, 1);
   HMG_storvnl ((LONG_PTR) hImageList,   -1, 2);
}


HB_FUNC( _SETBTNPICTURE)
{
   HWND   hButton  = (HWND)    HMG_parnl (1);
   TCHAR *FileName = (TCHAR *) HMG_parc  (2);
   HBITMAP hBitmap;
   BOOL SetGray = (BOOL) hb_parl(4);

   int  Transparent = hb_parl(3) ? 0 : 1;
                                                       //    ScaleStretch, Transparent, BackgroundColor,  AdjustImage,   TransparentColor
   hBitmap = HMG_LoadPicture ( FileName, -1, -1, NULL,                  0, Transparent,              -1,            0,                 -1 );

   if (SetGray == TRUE)
       HMG_GrayBitmap (hBitmap, Transparent);

   SendMessage(hButton, BM_SETIMAGE, (WPARAM) IMAGE_BITMAP, (LPARAM) hBitmap);

   HMG_retnl ((LONG_PTR) hBitmap);
}


HB_FUNC( _SETMIXEDBTNPICTURE)
{
   HWND  hButton   = (HWND)    HMG_parnl (1);
   TCHAR *FileName = (TCHAR *) HMG_parc  (2);
   HIMAGELIST hImageList;
   BOOL SetGray = (BOOL) hb_parl(5);

   int Transparent = hb_parl(4) ? 0 : 1;

   hImageList = HMG_SetButtonImageList (hButton, FileName, Transparent, hb_parni(3), SetGray);

   HMG_retnl ((LONG_PTR) hImageList);
}

