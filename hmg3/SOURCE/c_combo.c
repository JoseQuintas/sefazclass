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
#include <tchar.h>
#include "hbapi.h"
//#include "hbvm.h"
//#include "hbstack.h"
//#include "hbapiitm.h"
//#include "winreg.h"


HIMAGELIST HMG_ImageListLoadFirst (TCHAR *FileName, int cGrow, int Transparent, int *nWidth, int *nHeight);
void HMG_ImageListAdd (HIMAGELIST hImageList, TCHAR *FileName, int Transparent);


HB_FUNC( INITCOMBOBOX )
{
	HWND hwnd;
	HWND hbutton;
	int Style;

	hwnd = (HWND) HMG_parnl (1);

	Style = WS_CHILD | WS_VSCROLL ;

	if ( ! hb_parl(9) )
	{
		Style = Style | WS_VISIBLE ;
	}

	if ( ! hb_parl(10) )
	{
		Style = Style | WS_TABSTOP ;
	}

	if ( hb_parl(11) )
	{
		Style = Style | CBS_SORT ;
	}

	if ( !hb_parl(12) )
	{
		Style = Style | CBS_DROPDOWNLIST ;
	}
	else
	{
		Style = Style | CBS_DROPDOWN ;
	}

	if ( hb_parl(13) )
	{
		Style = Style | CBS_NOINTEGRALHEIGHT ;
	}

	hbutton = CreateWindowEx( 0L , WC_COMBOBOX /*_TEXT("ComboBox")*/ ,
                           _TEXT("") ,
                           Style ,
                           hb_parni(3) ,
                           hb_parni(4) ,
                           hb_parni(5) ,
                           hb_parni(8) ,
                           hwnd ,
                           (HMENU) HMG_parnl(2) ,
                           GetModuleHandle(NULL) ,
                           NULL ) ;

	SendMessage( (HWND) hbutton ,(UINT) CB_SETDROPPEDWIDTH, (WPARAM) hb_parni(14), 0);

	HMG_retnl ((LONG_PTR) hbutton);
}

HB_FUNC ( COMBOADDSTRING )
{
   TCHAR *cString = (TCHAR *) HMG_parc(2);
   SendMessage( (HWND) HMG_parnl (1), CB_ADDSTRING, 0, (LPARAM) cString );
}

HB_FUNC ( COMBOINSERTSTRING )
{
   TCHAR *cString = (TCHAR *) HMG_parc(2);
   SendMessage( (HWND) HMG_parnl (1), CB_INSERTSTRING, (WPARAM) (hb_parni(3) - 1) , (LPARAM) cString );
}

HB_FUNC ( COMBOSETCURSEL )
{
   SendMessage( (HWND) HMG_parnl (1), CB_SETCURSEL, (WPARAM) (hb_parni(2)-1), 0);
}

HB_FUNC ( COMBOGETCURSEL )
{
   hb_retni ( SendMessage( (HWND) HMG_parnl (1), CB_GETCURSEL , 0 , 0 )  + 1 );
}

HB_FUNC (COMBOBOXDELETESTRING )
{
   SendMessage( (HWND) HMG_parnl (1), CB_DELETESTRING, (WPARAM) (hb_parni(2)-1), 0);
}

HB_FUNC ( COMBOBOXRESET )
{
   SendMessage( (HWND) HMG_parnl (1), CB_RESETCONTENT, 0, 0 );
}

HB_FUNC ( COMBOGETSTRING )
{
   TCHAR cString [1024] = _TEXT("") ;
   SendMessage( (HWND) HMG_parnl(1), CB_GETLBTEXT , (WPARAM) (hb_parni(2) - 1), (LPARAM) cString );
   HMG_retc (cString);
}

HB_FUNC ( COMBOBOXGETITEMCOUNT )
{
   HMG_retnl ((LONG_PTR) SendMessage( (HWND) HMG_parnl (1), CB_GETCOUNT , 0, 0 ) ) ;
}


HB_FUNC( INITIMAGECOMBO )
{
   // Parameter Description
   // 01: Parent Window Handle
   // 02: Row
   // 03: Col
   // 04: Width
   // 05: Height
   // 06: Images
   // 07: DisplayEdit
   // 08: Visible
   // 09: TabStop
   // 10: NonIntegralHeight (XP and later trick :)
   // 11: DroppedWidth
   // 12: NoTransparent

   int i, nCount;
   HIMAGELIST hImageList = NULL;
   TCHAR *FileName;
   HWND hCombo;

   int Style = WS_BORDER | WS_CHILD ;

   INITCOMMONCONTROLSEX icex;
   icex.dwSize = sizeof(INITCOMMONCONTROLSEX);
   icex.dwICC = ICC_USEREX_CLASSES;
   InitCommonControlsEx(&icex);

   if ( hb_parl(7) )
      Style = Style | CBS_DROPDOWN;
   else
      Style = Style | CBS_DROPDOWNLIST;

   if ( hb_parl(8) )
      Style = Style | WS_VISIBLE;

   if ( hb_parl(9) )
      Style = Style | WS_TABSTOP;

   if ( hb_parl(10) )
      Style = Style | CBS_NOINTEGRALHEIGHT ;


   hCombo = CreateWindowEx (0, WC_COMBOBOXEX /*_TEXT("ComboBoxEx32")*/,
                           NULL,
                           Style,
                           hb_parni(3),
                           hb_parni(2),
                           hb_parni(4),
                           hb_parni(5),
                           (HWND) HMG_parnl (1),
                           NULL,
                           GetModuleHandle(NULL),
                           NULL);

   SendMessage ((HWND) hCombo, (UINT) CB_SETDROPPEDWIDTH, (WPARAM) hb_parni(11), (LPARAM) 0);

   // Create the imagelist for the control.

   nCount = hb_parinfa (6, 0);

   if ( nCount > 0 )
   {
      int Transparent = hb_parl(12) ? 0 : 1;

      for (i=1; i <= nCount; i++)
      {
         FileName = (TCHAR*) HMG_parvc (6, i);
         if ( hImageList == NULL )
            hImageList = HMG_ImageListLoadFirst (FileName, nCount, Transparent, NULL, NULL);
         else
            HMG_ImageListAdd (hImageList, FileName, Transparent);
      }

      if ( hImageList != NULL )
         SendMessage (hCombo, CBEM_SETIMAGELIST, 0, (LPARAM) hImageList);
   }

   hb_reta (2) ;
   HMG_storvnl ((LONG_PTR) hCombo,     -1, 1);
   HMG_storvnl ((LONG_PTR) hImageList, -1, 2);
}


HB_FUNC( IMAGECOMBOADDITEM )
{
   TCHAR *text = (TCHAR *) HMG_parc(3);
   COMBOBOXEXITEM cbei;
   cbei.mask           = CBEIF_TEXT | CBEIF_SELECTEDIMAGE | CBEIF_IMAGE;
   cbei.iItem          = hb_parni(4);
   cbei.pszText        = text;
   cbei.cchTextMax     = lstrlen (text) + 1;
   cbei.iImage         = hb_parni(2)-1;
   cbei.iSelectedImage = hb_parni(2)-1;

   SendMessage ((HWND) HMG_parnl (1), CBEM_INSERTITEM, 0, (LPARAM) &cbei);
}


HB_FUNC( IMAGECOMBOGETITEM )
{
   TCHAR text [1024] ;
   COMBOBOXEXITEM cbei;
   cbei.mask           = CBEIF_TEXT | CBEIF_SELECTEDIMAGE | CBEIF_IMAGE;
   cbei.iItem          = hb_parni(2)-1;
   cbei.pszText        = text;
   cbei.cchTextMax     = sizeof (text) / sizeof(TCHAR);
   cbei.iImage         = 0;
   cbei.iSelectedImage = 0;

   SendMessage ((HWND) HMG_parnl(1), CBEM_GETITEM, 0, (LPARAM) &cbei);

   hb_reta (2);
   hb_storvni (cbei.iImage,  -1, 1);
   HMG_storvc (cbei.pszText, -1, 2);
}


HB_FUNC( GETDROPPEDSTATE )
{
   hb_retni (SendMessage ((HWND) HMG_parnl(1), CB_GETDROPPEDSTATE, 0, 0));
}


