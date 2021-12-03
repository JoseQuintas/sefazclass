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

HB_FUNC( INITSPINNER )
{
	HWND hwnd;
	HWND hbutton;
	HWND hupdown;
	int Style1 = ES_NUMBER | WS_CHILD | ES_AUTOHSCROLL ;
	int Style2 = UDS_ARROWKEYS | WS_CHILD | WS_BORDER | UDS_ALIGNRIGHT | UDS_SETBUDDYINT | UDS_NOTHOUSANDS ;

	INITCOMMONCONTROLSEX  i;

	i.dwSize = sizeof(INITCOMMONCONTROLSEX);
	InitCommonControlsEx(&i);

	hwnd = (HWND) HMG_parnl (1);

	if ( !hb_parl (11) )
	{
		Style1 = Style1 | WS_VISIBLE ;
		Style2 = Style2 | WS_VISIBLE ;
	}

	if ( !hb_parl (12) )
	{
		Style1 = Style1 | WS_TABSTOP ;
	}

	if ( hb_parl (13) )
	{
		Style2 = Style2 | UDS_WRAP ;
	}

	if ( hb_parl (14) )
	{
		Style1 = Style1 | ES_READONLY ;
	}

	hbutton = CreateWindowEx( WS_EX_CLIENTEDGE , WC_EDIT /*_TEXT("Edit")*/ ,
                             _TEXT(""),
                             Style1 ,
                             hb_parni(3) ,
                             hb_parni(4) ,
                             hb_parni(5) ,
                             hb_parni(10) ,
                             hwnd ,
                             (HMENU) HMG_parnl (2),
                             GetModuleHandle(NULL) ,
                             NULL ) ;

	hupdown = CreateWindowEx( WS_EX_CLIENTEDGE , UPDOWN_CLASS /*_TEXT("msctls_updown32")*/,
                             _TEXT(""),
                             Style2 ,
                             hb_parni(3)+hb_parni(5) ,
                             hb_parni(4) ,
                             15 ,
                             hb_parni(10) ,
                             hwnd ,
                             (HMENU) NULL,
                             GetModuleHandle(NULL) ,
                             NULL ) ;

	SendMessage ( hupdown, UDM_SETBUDDY, (WPARAM)hbutton, (LPARAM)NULL ) ;
	SendMessage ( hupdown, UDM_SETRANGE32, (WPARAM)hb_parni(8) , (LPARAM) hb_parni(9) ) ;

	if ( hb_parl (14) )
	{
		EnableWindow( hupdown , FALSE );
	}

	hb_reta (2);
	HMG_storvnl ((LONG_PTR) hbutton, -1, 1);
	HMG_storvnl ((LONG_PTR) hupdown, -1, 2);

}


HB_FUNC( SETSPINNERRANGE )
{
	SendMessage ( (HWND) HMG_parnl (1), UDM_SETRANGE32, (WPARAM)hb_parni(2) , (LPARAM) hb_parni(3) ) ;
}

HB_FUNC( SETSPINNERINCREMENT )
{
   UDACCEL inc ;
   inc.nSec = 0;
   inc.nInc = hb_parnl(2);
 	SendMessage ( (HWND) HMG_parnl (1), UDM_SETACCEL, (WPARAM) 1 , (LPARAM) &inc ) ;
}

