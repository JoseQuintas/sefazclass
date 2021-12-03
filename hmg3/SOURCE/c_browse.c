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



#include "SETCompileBrowse.ch"
#ifdef COMPILEBROWSE


//#define _WIN32_IE      0x0500
//#define HB_OS_WIN_32_USED
//#define _WIN32_WINNT   0x0400


#include <shlobj.h>
#include <windows.h>
#include <commctrl.h>
#include <tchar.h>
#include "hbthread.h"
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
//#include "winreg.h"

extern HB_CRITICAL_T _HMG_Mutex;   // global Mutex variable defined into c_Thread.c

LRESULT APIENTRY SubClassFunc ( HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam );

static __TLS__  WNDPROC lpfnOldWndProc;

HB_FUNC (INITBROWSE)
{
	HWND hwnd;
	HWND hbutton;

	INITCOMMONCONTROLSEX  i;

	i.dwSize = sizeof(INITCOMMONCONTROLSEX);
	//i.dwICC = ICC_DATE_CLASSES;
   i.dwICC = ICC_LISTVIEW_CLASSES;
	InitCommonControlsEx(&i);

	hwnd = (HWND) HMG_parnl (1);

	hbutton = CreateWindowEx ( WS_EX_CLIENTEDGE,
                              WC_LISTVIEW /*_TEXT("SysListView32")*/ ,
                              _TEXT(""),
                              LVS_SINGLESEL | LVS_SHOWSELALWAYS | WS_CHILD | WS_TABSTOP | WS_VISIBLE | LVS_REPORT,
                              hb_parni(3),
                              hb_parni(4),
                              hb_parni(5),
                              hb_parni(6),
                              hwnd,
                              (HMENU) HMG_parnl(2),
                              GetModuleHandle(NULL),
                              NULL );

   // Browse+
	SendMessage(hbutton,LVM_SETEXTENDEDLISTVIEWSTYLE, 0, (LPARAM) (hb_parni(9) | LVS_EX_FULLROWSELECT | LVS_EX_HEADERDRAGDROP) );   // add (LPARAM)

_THREAD_LOCK();
   lpfnOldWndProc = (WNDPROC) SetWindowLongPtr ( hbutton , GWLP_WNDPROC, (LONG_PTR) SubClassFunc);
_THREAD_UNLOCK();

	HMG_retnl ((LONG_PTR) hbutton);

}

LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{

	// TCHAR res[20];

	if ( msg == WM_MOUSEWHEEL )
	{

                // wsprintf( res,_TEXT("zDelta: %d"), (short) HIWORD (wParam) );
       	        // MessageBox( GetActiveWindow(), res, _TEXT(""), MB_OK | MB_ICONINFORMATION );

		if ( (short) HIWORD (wParam) > 0 )
		{

			keybd_event(
			VK_UP	,	// virtual-key code
			0,		// hardware scan code
			0,		// flags specifying various function options
			0		// additional data associated with keystroke
			);

		}
		else
		{

			keybd_event(
			VK_DOWN	,	// virtual-key code
			0,		// hardware scan code
			0,		// flags specifying various function options
			0		// additional data associated with keystroke
			);

		}

		return CallWindowProc(lpfnOldWndProc, hWnd, 0 , 0, 0 ) ;

	}
	else
	{
		return CallWindowProc(lpfnOldWndProc, hWnd, msg , wParam, lParam ) ;
	}

}

HB_FUNC (INITVSCROLLBAR)
{
	HWND hwnd;
	HWND hscrollbar;

	hwnd = (HWND) HMG_parnl (1);

	hscrollbar = CreateWindowEx( 0L , WC_SCROLLBAR /*_TEXT("ScrollBar")*/ ,
   _TEXT(""),	WS_CHILD | WS_VISIBLE | SBS_VERT ,
	hb_parni(2) , hb_parni(3) , hb_parni(4) , hb_parni(5),
	hwnd,(HMENU) NULL , GetModuleHandle(NULL) , NULL ) ;

	SetScrollRange(
	hscrollbar,	// handle of window with scroll bar
	SB_CTL,		// scroll bar flag
	1,		// minimum scrolling position
	100,		// maximum scrolling position
	1 		// redraw flag
	);

	HMG_retnl ((LONG_PTR) hscrollbar);

}

HB_FUNC (INSERTUP)
{

			keybd_event(
			VK_UP	,	// virtual-key code
			0,		// hardware scan code
			0,		// flags specifying various function options
			0		// additional data associated with keystroke
			);

}

HB_FUNC (INSERTDOWN)
{

			keybd_event(
			VK_DOWN	,	// virtual-key code
			0,		// hardware scan code
			0,		// flags specifying various function options
			0		// additional data associated with keystroke
			);

}

HB_FUNC (INSERTPRIOR)
{

			keybd_event(
			VK_PRIOR	,	// virtual-key code
			0,		// hardware scan code
			0,		// flags specifying various function options
			0		// additional data associated with keystroke
			);

}

HB_FUNC (INSERTNEXT)
{

			keybd_event(
			VK_NEXT	,	// virtual-key code
			0,		// hardware scan code
			0,		// flags specifying various function options
			0		// additional data associated with keystroke
			);

}


HB_FUNC( INITVSCROLLBARBUTTON )
{
	HWND hwnd;
	HWND hbutton;
	int Style ;

	hwnd = (HWND) HMG_parnl (1);

	Style =  WS_CHILD | WS_VISIBLE | SS_SUNKEN ;

	hbutton = CreateWindowEx( 0L , WC_STATIC /*_TEXT("Static")*/ ,
                           _TEXT("") ,
                           Style ,
                           hb_parni(2) ,
                           hb_parni(3) ,
                           hb_parni(4) ,
                           hb_parni(5) ,
                           hwnd ,
                           (HMENU) NULL ,
                           GetModuleHandle(NULL) ,
                           NULL ) ;

	HMG_retnl ((LONG_PTR) hbutton);
}

HB_FUNC( SETSCROLLINFO )
{
	SCROLLINFO lpsi;
	lpsi.cbSize = sizeof(SCROLLINFO);
	lpsi.fMask = SIF_PAGE | SIF_POS | SIF_RANGE ;
	lpsi.nMin   = 1;
	lpsi.nMax   = hb_parni(2);
	lpsi.nPage = hb_parni(4);
	lpsi.nPos  = hb_parni(3);

	hb_retnl( SetScrollInfo( (HWND) HMG_parnl (1),
 							 SB_CTL       ,
    						 (LPSCROLLINFO) &lpsi,
							 1
							 ) );
}


#endif
