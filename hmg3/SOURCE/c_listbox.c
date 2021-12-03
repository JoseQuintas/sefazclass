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

HB_FUNC( INITLISTBOX )
{

	HWND hwnd;
	HWND hbutton;
	int Style = WS_CHILD | WS_VSCROLL | LBS_DISABLENOSCROLL | LBS_NOTIFY | LBS_NOINTEGRALHEIGHT; // | WS_HSCROLL;

	hwnd = (HWND) HMG_parnl (1);

	if ( ! hb_parl (9) )
	{
		Style = Style | WS_VISIBLE ;
	}

	if ( ! hb_parl (10) )
	{
		Style = Style | WS_TABSTOP ;
	}

	if ( hb_parl (11) )
	{
		Style = Style | LBS_SORT ;
	}

	hbutton = CreateWindowEx( WS_EX_CLIENTEDGE , WC_LISTBOX /*_TEXT("ListBox")*/ ,
                             _TEXT(""),
                             Style ,
                             hb_parni(3) ,
                             hb_parni(4) ,
                             hb_parni(5) ,
                             hb_parni(6) ,
                             hwnd ,
                             (HMENU) HMG_parnl (2),
                             GetModuleHandle(NULL) ,
                             NULL ) ;

	if ( hb_parl (12) )
	{
		MakeDragList(hbutton);
	}

	HMG_retnl ((LONG_PTR) hbutton);

}

HB_FUNC ( LISTBOXADDSTRING )
{
   TCHAR *cString = (TCHAR*)HMG_parc( 2 );
   SendMessage( (HWND) HMG_parnl (1), LB_ADDSTRING, 0, (LPARAM) cString );
}

HB_FUNC ( LISTBOXGETSTRING )
{

	TCHAR cString [1024] = _TEXT("");
	SendMessage( (HWND) HMG_parnl (1), LB_GETTEXT, (WPARAM) hb_parni(2) - 1, (LPARAM) cString );
	HMG_retc(cString) ;

}

HB_FUNC ( LISTBOXINSERTSTRING )
{
   TCHAR *cString = (TCHAR*)HMG_parc( 2 );
   SendMessage( (HWND) HMG_parnl (1), LB_INSERTSTRING, (WPARAM) hb_parni(3) - 1 , (LPARAM) cString );
}


HB_FUNC ( LISTBOXSETCURSEL )
{
   SendMessage( (HWND) HMG_parnl (1), LB_SETCURSEL, (WPARAM) hb_parni(2)-1, 0);
}

HB_FUNC ( LISTBOXGETCURSEL )
{
	hb_retni ( SendMessage( (HWND) HMG_parnl (1), LB_GETCURSEL , 0 , 0 )  + 1 );
}

HB_FUNC ( LISTBOXDELETESTRING )
{
	SendMessage( (HWND) HMG_parnl (1), LB_DELETESTRING, (WPARAM) hb_parni(2)-1, 0);
}

HB_FUNC ( LISTBOXRESET )
{
	SendMessage( (HWND) HMG_parnl (1), LB_RESETCONTENT, 0, 0 );
}

HB_FUNC( INITMULTILISTBOX )
{
	HWND hwnd;
	HWND hbutton;
	int Style = LBS_EXTENDEDSEL | WS_CHILD | WS_VSCROLL | LBS_DISABLENOSCROLL | LBS_NOTIFY  | LBS_MULTIPLESEL  | LBS_NOINTEGRALHEIGHT ;

	hwnd = (HWND) HMG_parnl (1);

	if ( ! hb_parl (9) )
	{
		Style = Style | WS_VISIBLE ;
	}

	if ( ! hb_parl (10) )
	{
		Style = Style | WS_TABSTOP ;
	}

	if ( hb_parl (11) )
	{
		Style = Style | LBS_SORT ;
	}

	hbutton = CreateWindowEx( WS_EX_CLIENTEDGE , WC_LISTBOX /*_TEXT("ListBox")*/ ,
                             _TEXT(""),
                             Style ,
                             hb_parni(3) ,
                             hb_parni(4) ,
                             hb_parni(5) ,
                             hb_parni(6) ,
                             hwnd ,
                             (HMENU) HMG_parnl (2),
                             GetModuleHandle(NULL) ,
                             NULL ) ;

	if ( hb_parl (12) )
	{
		MakeDragList(hbutton);
	}

	HMG_retnl ((LONG_PTR) hbutton);
}

HB_FUNC ( LISTBOXGETMULTISEL )
{

	HWND hwnd = (HWND) HMG_parnl (1);
	int i ;
	int buffer [32768] ;
	int n ;

	n = SendMessage( hwnd, LB_GETSELCOUNT, 0, 0);

	SendMessage(hwnd, LB_GETSELITEMS, (WPARAM)(n), (LPARAM)buffer);

	hb_reta( n );

	for( i=0 ; i<n ; i++ )
	{
		hb_storvni( buffer [i] + 1 , -1 , i+1 );
	}

}

HB_FUNC( LISTBOXSETMULTISEL )
{
   PHB_ITEM wArray;

   HWND     hwnd = (HWND) HMG_parnl (1);

   int      i;
   int      n;
   int      l;

   wArray = hb_param( 2, HB_IT_ARRAY );

   l = hb_parinfa( 2, 0 ) - 1;

   n = SendMessage( hwnd, LB_GETCOUNT, 0, 0 );

   // CLEAR CURRENT SELECTIONS

   for( i = 0; i < n; i++ )
   {
      SendMessage( hwnd, LB_SETSEL, (WPARAM) (0), (LPARAM) i );
   }

   // SET NEW SELECTIONS

   for( i = 0; i <= l; i++ )
   {
      SendMessage( hwnd, LB_SETSEL, (WPARAM) (1), (LPARAM) (hb_arrayGetNI(wArray, i + 1)) - 1 );
   }
}

HB_FUNC ( LISTBOXGETITEMCOUNT )
{
   HMG_retnl ( SendMessage( (HWND) HMG_parnl (1), LB_GETCOUNT , 0, 0 ) ) ;
}


