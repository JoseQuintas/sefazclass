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
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"



HB_FUNC( INITCHECKBOX )
{
	HWND hwnd;
	HWND hbutton;
	int Style;

	hwnd = (HWND) HMG_parnl (1);

	Style = BS_NOTIFY | WS_CHILD | BS_AUTOCHECKBOX ;

	if ( ! hb_parl(10) )
	{
		Style = Style | WS_VISIBLE ;
	}

	if ( ! hb_parl(11) )
	{
		Style = Style | WS_TABSTOP ;
	}

	hbutton = CreateWindowEx( WS_EX_TRANSPARENT , WC_BUTTON /*_TEXT("Button")*/ ,
   HMG_parc(2), Style ,
	hb_parni(4), hb_parni(5) , hb_parni(8), hb_parni(9) ,
	hwnd,(HMENU) HMG_parnl (3), GetModuleHandle(NULL) , NULL ) ;

	HMG_retnl ((LONG_PTR) hbutton);
}


HB_FUNC( INITCHECKBUTTON )
{
	HWND hwnd;
	HWND hbutton;
	int Style;

	hwnd = (HWND) HMG_parnl (1);

	Style = BS_NOTIFY | WS_CHILD | BS_AUTOCHECKBOX | BS_PUSHLIKE ;

	if ( ! hb_parl(10) )
	{
		Style = Style | WS_VISIBLE ;
	}

	if ( ! hb_parl(11) )
	{
		Style = Style | WS_TABSTOP ;
	}

	hbutton = CreateWindowEx( 0L , WC_BUTTON /*_TEXT("Button")*/ ,
   HMG_parc(2), Style ,
	hb_parni(4), hb_parni(5) , hb_parni(8), hb_parni(9),
	hwnd,(HMENU) HMG_parnl (3), GetModuleHandle(NULL) , NULL ) ;

	HMG_retnl ((LONG_PTR) hbutton);

}



// by Dr. Claudio Soto (May 2014)

HBITMAP HMG_LoadPicture ( TCHAR *FileName, int New_Width, int New_Height, HWND hWnd, int ScaleStretch, int Transparent, long BackgroundColor, int AdjustImage, long TransparentColor );

HIMAGELIST HMG_SetButtonImageList (HWND hButton, TCHAR *FileName, int Transparent, UINT uAlign, BOOL SetGray);

HB_FUNC( INITIMAGECHECKBUTTON )
{
   HWND hwnd = (HWND) HMG_parnl (1);
   HWND hButton;
   HBITMAP hBitmap;
   HIMAGELIST hImageList;

   int Style = BS_NOTIFY | BS_BITMAP | WS_CHILD | BS_AUTOCHECKBOX | BS_PUSHLIKE ;

   if ( ! hb_parl(11) )
      Style = Style | WS_VISIBLE ;

   if ( ! hb_parl(12) )
      Style = Style | WS_TABSTOP ;

   hButton = CreateWindowEx ( 0, WC_BUTTON /*_TEXT("Button")*/,
                              HMG_parc(2),
                              Style,
                              hb_parni(4),
                              hb_parni(5),
                              hb_parni(9),
                              hb_parni(10),
                              hwnd,
                              (HMENU) HMG_parnl (3),
                              GetModuleHandle(NULL),
                              NULL);

   TCHAR *FileName = (TCHAR *) HMG_parc (8);

   BOOL _IsAppThemed = (BOOL) hb_parl (13);

   int Transparent = hb_parl (14) ? 0 : 1;

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

