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

HB_FUNC ( INITDATEPICK )
{
	HWND hwnd;
	HWND hbutton;
	int Style = WS_CHILD ;

	INITCOMMONCONTROLSEX  i;
	i.dwSize = sizeof(INITCOMMONCONTROLSEX);
	i.dwICC = ICC_DATE_CLASSES;
	InitCommonControlsEx(&i);

	hwnd = (HWND) HMG_parnl (1);

	if ( hb_parl (9) )
	{
		Style = Style | DTS_SHOWNONE ;
	}

	if ( hb_parl (10) )
	{
		Style = Style | DTS_UPDOWN ;
	}

	if ( hb_parl (11) )
	{
		Style = Style | DTS_RIGHTALIGN ;
	}

	if ( ! hb_parl (12) )
	{
		Style = Style | WS_VISIBLE ;
	}

	if ( ! hb_parl (13) )
	{
		Style = Style | WS_TABSTOP ;
	}

	hbutton = CreateWindowEx( WS_EX_CLIENTEDGE , DATETIMEPICK_CLASS /*_TEXT("SysDateTimePick32")*/ ,
   _TEXT(""), Style ,
	hb_parni(3), hb_parni(4) ,hb_parni(5) ,hb_parni(6) ,
	hwnd,(HMENU) HMG_parnl (2), GetModuleHandle(NULL) , NULL ) ;

	HMG_retnl ((LONG_PTR) hbutton);
}

HB_FUNC ( SETDATEPICK )
{
	HWND hwnd;
	SYSTEMTIME sysTime;
	int y;
	int m;
	int d;

	hwnd = (HWND) HMG_parnl (1);

	y = hb_parni(2);
	m = hb_parni(3);
	d = hb_parni(4);

	sysTime.wYear = y;
	sysTime.wMonth = m;
	sysTime.wDay = d;
	sysTime.wDayOfWeek = 0;

	sysTime.wHour = 0;
	sysTime.wMinute = 0;
	sysTime.wSecond = 0;
	sysTime.wMilliseconds = 0;

	SendMessage(hwnd, DTM_SETSYSTEMTIME,GDT_VALID, (LPARAM) &sysTime);
}

HB_FUNC ( GETDATEPICKYEAR )
{
	HWND hwnd;
	SYSTEMTIME st;
	hwnd = (HWND) HMG_parnl (1);

	SendMessage(hwnd, DTM_GETSYSTEMTIME, 0, (LPARAM) &st);
	hb_retni(st.wYear);
}

HB_FUNC ( GETDATEPICKMONTH )
{
	HWND hwnd;
	SYSTEMTIME st;
	hwnd = (HWND) HMG_parnl (1);

	SendMessage(hwnd, DTM_GETSYSTEMTIME, 0, (LPARAM) &st);
	hb_retni(st.wMonth);
}

HB_FUNC ( GETDATEPICKDAY )
{
	HWND hwnd;
	SYSTEMTIME st;
	hwnd = (HWND) HMG_parnl (1);

	SendMessage(hwnd, DTM_GETSYSTEMTIME, 0, (LPARAM) &st);
	hb_retni(st.wDay);
}

HB_FUNC ( SETDATEPICKNULL )
{
	HWND hwnd;

	hwnd = (HWND) HMG_parnl (1);

	SendMessage(hwnd, DTM_SETSYSTEMTIME,GDT_NONE, (LPARAM) 0 );
}


