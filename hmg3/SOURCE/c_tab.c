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
//#include "hbvm.h"
//#include "hbstack.h"
//#include "hbapiitm.h"
//#include "winreg.h"
#include <tchar.h>


HIMAGELIST HMG_ImageListLoadFirst (TCHAR *FileName, int cGrow, int Transparent, int *nWidth, int *nHeight);
void HMG_ImageListAdd (HIMAGELIST hImageList, TCHAR *FileName, int Transparent);



HB_FUNC( INITTABCONTROL )
{

	HWND hwnd;
	HWND hbutton;
	TC_ITEM tie;
	int l;
	int i;

	int Style = WS_CHILD | WS_VISIBLE ;

	if ( hb_parl (11) )
	{
		Style = Style | TCS_BUTTONS ;
	}

	if ( hb_parl (12) )
	{
		Style = Style | TCS_FLATBUTTONS ;
	}

	if ( hb_parl (13) )
	{
		Style = Style | TCS_HOTTRACK ;
	}

	if ( hb_parl (14) )
	{
		Style = Style | TCS_VERTICAL ;
	}

	if ( ! hb_parl (15) )
	{
		Style = Style | WS_TABSTOP ;
	}

	if ( hb_parl (16) )
	{
		Style = Style | TCS_MULTILINE ;
	}

	l = hb_parinfa( 7, 0 ) - 1 ;

	hwnd = (HWND) HMG_parnl (1);

	hbutton = CreateWindowEx( 0L , WC_TABCONTROL /*_TEXT("SysTabControl32")*/ ,
   TEXT("") , Style ,
	hb_parni(3), hb_parni(4) , hb_parni(5), hb_parni(6) ,
	hwnd,(HMENU) HMG_parnl (2), GetModuleHandle(NULL) , NULL ) ;

	tie.mask = TCIF_TEXT ;
	tie.iImage = -1;

	for (i = l ; i>=0 ; i=i-1 )
		{

		tie.pszText =  (LPTSTR) HMG_parvc ( 7 , i + 1 );

		TabCtrl_InsertItem(hbutton, 0, &tie);
		}

	TabCtrl_SetCurSel( hbutton , hb_parni(8) - 1 );

	HMG_retnl ((LONG_PTR) hbutton);
}

HB_FUNC (TABCTRL_SETCURSEL)
{

	HWND hwnd;
	int s;

	hwnd = (HWND) HMG_parnl (1);

	s = hb_parni (2);

	TabCtrl_SetCurSel( hwnd , s-1 );

}

HB_FUNC (TABCTRL_GETCURSEL)
{
	HWND hwnd;
	hwnd = (HWND) HMG_parnl (1);
	hb_retni ( TabCtrl_GetCurSel( hwnd ) + 1 ) ;
}

HB_FUNC (TABCTRL_INSERTITEM)
{
	HWND hwnd ;
	TC_ITEM tie ;
	int i ;

	hwnd = (HWND) HMG_parnl (1);
	i = hb_parni (2) ;

	tie.mask = TCIF_TEXT ;
	tie.iImage = -1 ;
	tie.pszText = (LPTSTR) HMG_parc(3) ;

	TabCtrl_InsertItem(hwnd, i, &tie) ;

}

HB_FUNC (TABCTRL_DELETEITEM)
{
	HWND hwnd ;
	int i ;

	hwnd = (HWND) HMG_parnl (1);
	i = hb_parni (2) ;

	TabCtrl_DeleteItem(hwnd, i) ;

}

HB_FUNC( SETTABCAPTION )
{

	TC_ITEM tie;

	tie.mask = TCIF_TEXT ;

	tie.pszText =  (LPTSTR) HMG_parc(3) ;

	TabCtrl_SetItem ( (HWND) HMG_parnl (1), hb_parni (2)-1 , &tie);

}


HB_FUNC ( ADDTABBITMAP )
{
   HWND hTab = (HWND) HMG_parnl (1);
   TC_ITEM TCI;
   HIMAGELIST hImageList = NULL;
   TCHAR *FileName;
   int nCount, i;

   nCount = hb_parinfa (2, 0);

   if ( nCount > 0 )
   {
      int Transparent = hb_parl(3) ? 0 : 1;

      for (i=1; i <= nCount; i++)
      {
         FileName = (TCHAR*) HMG_parvc (2, i);
         if ( hImageList == NULL )
            hImageList = HMG_ImageListLoadFirst (FileName, nCount, Transparent, NULL, NULL);
         else
            HMG_ImageListAdd (hImageList, FileName, Transparent);
      }

      if (hImageList != NULL)
         SendMessage (hTab, TCM_SETIMAGELIST, (WPARAM) 0, (LPARAM) hImageList);

      for ( i = 0 ; i < nCount ; i++ )
      {
         TCI.mask   = TCIF_IMAGE ;
         TCI.iImage = i;
         TabCtrl_SetItem (hTab, i, &TCI);
      }
   }

   HMG_retnl ((LONG_PTR) hImageList );
}


HB_FUNC(IMAGELIST_DESTROY)
{
   hb_retl ((BOOL) ImageList_Destroy ( (HIMAGELIST) HMG_parnl (1) ) );
}


// by Dr. Claudio Soto, April 2015

HB_FUNC ( TABCTRL_ADJUSTRECT )
{
   HWND hWnd    = (HWND) HMG_parnl (1);
   BOOL fLarger = (BOOL) hb_parl   (2);
   RECT Rect = {0,0,0,0};
   TabCtrl_AdjustRect( hWnd, fLarger, &Rect );
   hb_reta (4);
   hb_storvnl (Rect.left,   -1, 1);
   hb_storvnl (Rect.top,    -1, 2);
   hb_storvnl (Rect.right,  -1, 3);
   hb_storvnl (Rect.bottom, -1, 4);

}


HB_FUNC ( TABCTRL_GETITEMRECT )
{
   HWND hWnd   = (HWND) HMG_parnl (1);
   INT  nItem  = (INT)  hb_parni  (2);
   RECT Rect = {0,0,0,0};
   TabCtrl_GetItemRect (hWnd, nItem, &Rect);
   hb_reta (4);
   hb_storvnl (Rect.left,   -1, 1);
   hb_storvnl (Rect.top,    -1, 2);
   hb_storvnl (Rect.right,  -1, 3);
   hb_storvnl (Rect.bottom, -1, 4);
}

