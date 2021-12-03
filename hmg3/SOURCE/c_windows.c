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




#define WM_TASKBAR     WM_USER+1043  // User define message

#include <shlobj.h>
#include <windows.h>
#include <tchar.h>
#include <commctrl.h>
#include <windowsx.h>
#include <winreg.h>
#include <richedit.h>

#include "hbthread.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "hbapi.h"

extern HB_CRITICAL_T _HMG_Mutex;   // global Mutex variable defined into c_Thread.c

LRESULT CALLBACK WndProc (HWND, UINT, WPARAM, LPARAM);   // function moved to the file: c_EventsCB.c

//-------------------------------------------------------------------------------------//

static __TLS__ int nCountMessageLoop = 0;

//-------------------------------------------------------------------------------------//
HB_FUNC ( DOMESSAGELOOP )
//-------------------------------------------------------------------------------------//
{
   MSG  Msg;
   HWND hDlgModeless = NULL;

_THREAD_LOCK();
   nCountMessageLoop ++;
_THREAD_UNLOCK();

   while( GetMessage( &Msg, NULL, 0, 0) )
   {
      hDlgModeless = GetActiveWindow();   // this is not better way of take Handle of Modeless Dialog Box

      if ( hDlgModeless == NULL || !IsDialogMessage ( hDlgModeless, &Msg ) )
      {
         TranslateMessage( &Msg );
         DispatchMessage ( &Msg );
      }
   }

_THREAD_LOCK();
   nCountMessageLoop --;
_THREAD_UNLOCK();

}


//        IsRunMessageLoop()
HB_FUNC ( ISRUNMESSAGELOOP )
{
_THREAD_LOCK();
   hb_retl ((BOOL) (nCountMessageLoop > 0 ? TRUE : FALSE));
_THREAD_UNLOCK();
}


//-------------------------------------------------------------------------------------//
HB_FUNC ( DOEVENTS )
//-------------------------------------------------------------------------------------//
{
   MSG Msg;
   HWND hDlgModeless = NULL;
   while( PeekMessage ( &Msg, NULL, 0, 0, PM_REMOVE ) )
   {
      hDlgModeless = GetActiveWindow();   // this is not better way of take Handle of Modeless Dialog Box

      if ( hDlgModeless == NULL || !IsDialogMessage ( hDlgModeless, &Msg ) )   // ADD June 2015
      {
         TranslateMessage ( &Msg );
         DispatchMessage  ( &Msg );
      }
   }
}



//****************************************************************************************************************************//


HB_FUNC ( INITWINDOW )
{
   HWND hwnd;
   int Style = WS_POPUP;
   int ExStyle = 0;

   if ( hb_parl (16) )
      ExStyle = WS_EX_CONTEXTHELP ;
   else
   {
      ExStyle = 0 ;
      if ( ! hb_parl (6) )
         Style = Style | WS_MINIMIZEBOX ;

      if ( ! hb_parl (7) )
         Style = Style | WS_MAXIMIZEBOX ;
   }

   if ( ! hb_parl (8) )
      Style = Style | WS_SIZEBOX ;

   if ( ! hb_parl (9) )
      Style = Style | WS_SYSMENU ;

   if ( ! hb_parl (10) )
      Style = Style | WS_CAPTION ;

   if ( hb_parl (11) )
      ExStyle = ExStyle | WS_EX_TOPMOST ;

   if ( hb_parl (14) )
      Style = Style | WS_VSCROLL ;

   if ( hb_parl (15) )
      Style = Style | WS_HSCROLL ;

   if ( hb_parl (17) ) // Panel
   {
      Style = WS_CHILD ;
      ExStyle = ExStyle | WS_EX_CONTROLPARENT | WS_EX_STATICEDGE ;
   }


   hwnd = CreateWindowEx ( ExStyle , HMG_parc(12) ,
                           HMG_parc(1), Style ,
                           hb_parni(2),
                           hb_parni(3),
                           hb_parni(4),
                           hb_parni(5),
                           (HWND) HMG_parnl (13),
                           (HMENU) NULL,
                           GetModuleHandle( NULL ),
                           NULL);

   if (hwnd == NULL)
   {
      MessageBox(0, _TEXT("Window Creation Failed!"), _TEXT("Error!"),
      MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);
      return;
   }

   HMG_retnl ((LONG_PTR) hwnd );
}


HB_FUNC ( INITMODALWINDOW )
{
   HWND parent ;
   HWND hwnd ;
   int Style = 0;
   int ExStyle = 0 ;

   if ( hb_parl (13) )
        ExStyle = WS_EX_CONTEXTHELP ;

   if ( hb_parl (14) )
        ExStyle = WS_EX_TOOLWINDOW ;

   parent = (HWND) HMG_parnl (6);

   Style = WS_POPUP;

   if ( ! hb_parl (7) )
      Style = Style | WS_SIZEBOX ;

   if ( ! hb_parl (8) )
      Style = Style | WS_SYSMENU ;

   if ( ! hb_parl (9) )
      Style = Style | WS_CAPTION ;

   if ( hb_parl (11) )
      Style = Style | WS_VSCROLL ;

   if ( hb_parl (12) )
      Style = Style | WS_HSCROLL ;

   hwnd = CreateWindowEx ( ExStyle, HMG_parc(10),
                           HMG_parc(1),
                           Style,
                           hb_parni(2),
                           hb_parni(3),
                           hb_parni(4),
                           hb_parni(5),
                           parent,
                           (HMENU) NULL,
                           GetModuleHandle (NULL),
                           NULL );

   if(hwnd == NULL)
   {
      MessageBox(0, _TEXT("Window Creation Failed!"), _TEXT("Error!"),
      MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);
      return;
   }

   HMG_retnl ((LONG_PTR) hwnd );
}



HB_FUNC ( SHOWWINDOW )
{
   ShowWindow( (HWND) HMG_parnl (1), SW_SHOW);
}


HB_FUNC ( EXITPROCESS )
{
   UINT uExitCode = (UINT) hb_parnl (1);
   ExitProcess(uExitCode);
}


HB_FUNC ( INITSTATUS )
{
	HWND hwnd;
	HWND hs;
   TCHAR *Text = (TCHAR*) HMG_parc(2);

	hwnd = (HWND) HMG_parnl (1);

	hs = CreateStatusWindow ( WS_CHILD | WS_BORDER | WS_VISIBLE, _TEXT("") , hwnd, hb_parni(3) );

	SendMessage (hs, SB_SIMPLE, (WPARAM) TRUE, (LPARAM) 0 );
	SendMessage (hs, SB_SETTEXT,(WPARAM) 255,  (LPARAM) Text );

	HMG_retnl ((LONG_PTR) hs );

}

HB_FUNC ( SETSTATUS )
{
	HWND hwnd;
    TCHAR *Text = (TCHAR *) HMG_parc(2);

	hwnd = (HWND) HMG_parnl (1);

	SendMessage(hwnd,SB_SIMPLE, (WPARAM) TRUE, (LPARAM) 0 );
	SendMessage(hwnd,SB_SETTEXT,(WPARAM) 255,  (LPARAM) Text );

}

HB_FUNC (MAXIMIZE)
{
	ShowWindow( (HWND) HMG_parnl (1), SW_MAXIMIZE);
}

HB_FUNC (MINIMIZE)
{
	ShowWindow( (HWND) HMG_parnl (1), SW_MINIMIZE);
}

HB_FUNC (RESTORE)
{
	ShowWindow( (HWND) HMG_parnl (1), SW_RESTORE);
}

HB_FUNC( GETACTIVEWINDOW )
{
   HWND hwnd = GetActiveWindow();
   HMG_retnl ((LONG_PTR) hwnd );
}

HB_FUNC( SETACTIVEWINDOW )
{
   HWND hwnd = (HWND) HMG_parnl (1);
   SetActiveWindow (hwnd);
}

HB_FUNC( POSTQUITMESSAGE )
{
   PostQuitMessage ( hb_parnl (1) );
}

HB_FUNC ( DESTROYWINDOW )
{
	DestroyWindow( (HWND) HMG_parnl (1) );
}

HB_FUNC (ISWINDOWENABLED)
{
   HWND hwnd = (HWND) HMG_parnl (1);
   hb_retl ((BOOL) IsWindowEnabled (hwnd) );
}

HB_FUNC (ENABLEWINDOW)
{
   HWND hwnd = (HWND) HMG_parnl (1);
   EnableWindow ( hwnd , TRUE );
}

HB_FUNC (DISABLEWINDOW)
{
   HWND hwnd = (HWND) HMG_parnl (1);
   EnableWindow( hwnd , FALSE );
}

HB_FUNC (SETFOREGROUNDWINDOW)
{
   HWND hwnd = (HWND) HMG_parnl (1);
   SetForegroundWindow ( hwnd );
}

HB_FUNC (BRINGWINDOWTOTOP)
{
   HWND hwnd = (HWND) HMG_parnl (1);
   BringWindowToTop ( hwnd );
}


HB_FUNC (GETFOREGROUNDWINDOW)
{
   HWND hWnd = GetForegroundWindow();
   HMG_retnl ((LONG_PTR) hWnd );
}

HB_FUNC (GETNEXTWINDOW)
{
   HWND hWnd     = (HWND) HMG_parnl (1);
   HWND hWndNext = GetWindow (hWnd, GW_HWNDNEXT);
   HMG_retnl ((LONG_PTR) hWndNext );
}

HB_FUNC (GETPREVWINDOW)
{
   HWND hWnd     = (HWND) HMG_parnl (1);
   HWND hWndPrev = GetWindow ( hWnd, GW_HWNDPREV );
   HMG_retnl ((LONG_PTR) hWndPrev );
}

HB_FUNC ( SETWINDOWTEXT )
{
   //TCHAR *Text = (TCHAR *) HMG_parc(2);
   SetWindowText( (HWND) HMG_parnl (1), (LPCTSTR) HMG_parc(2) );
}


HB_FUNC (C_CENTER)
{
   int w, h, x, y;
   HWND hWnd = (HWND) HMG_parnl (1);
   HWND hWndParent = (HWND) HMG_parnl (2);
   RECT Rect;
   GetWindowRect (hWnd, &Rect);
   w = Rect.right  - Rect.left;
   h = Rect.bottom - Rect.top;

   RECT rect2;

   if (IsWindow (hWndParent))
   {
      GetWindowRect (hWndParent, &rect2);
      x = rect2.right  - rect2.left;
      y = rect2.bottom - rect2.top;
   }
   else if (hb_parnl (2) == 1)
   {
      SystemParametersInfo (SPI_GETWORKAREA, 1, &rect2, 0);
      x = rect2.right  - rect2.left;
      y = rect2.bottom - rect2.top;
   }
   else
   {
      SetRectEmpty (&rect2);
      x = GetSystemMetrics (SM_CXSCREEN);
      y = GetSystemMetrics (SM_CYSCREEN);
   }

   SetWindowPos (hWnd, HWND_TOP, ((x-w)/2 + rect2.left), ((y-h)/2 + rect2.top), 0, 0, SWP_NOSIZE | SWP_NOACTIVATE);
}


HB_FUNC ( GETWINDOWTEXT )
{
   int iLen = GetWindowTextLength( (HWND) HMG_parnl (1) );
   TCHAR *cText = (TCHAR*) hb_xgrab((iLen+1) * sizeof(TCHAR));
   GetWindowText( (HWND) HMG_parnl (1), (LPTSTR) cText, (iLen+1));
   HMG_retc( cText );
   hb_xfree( cText );
}


HB_FUNC ( SENDMESSAGE )
{
   HMG_retnl ((LONG_PTR) SendMessage ((HWND) HMG_parnl (1), (UINT) hb_parnl (2), (WPARAM) HMG_parnl (3), (LPARAM) HMG_parnl (4)));
}

HB_FUNC ( UPDATEWINDOW )
{
   hb_retl ((BOOL) UpdateWindow ((HWND) HMG_parnl (1)));
}


HB_FUNC ( GETNOTIFYCODE )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   NMHDR *nmhdr = (NMHDR *) lParam;
   hb_retni ( nmhdr->code );
}


HB_FUNC ( GETHWNDFROM )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   NMHDR *nmhdr = (NMHDR *) lParam;
   HMG_retnl ((LONG_PTR) nmhdr->hwndFrom );
}


HB_FUNC ( GETIDFROM )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   NMHDR *nmhdr = (NMHDR *) lParam;
   HMG_retnl ((LONG_PTR) nmhdr->idFrom );
}


/*
HB_FUNC ( GETDRAWITEMHANDLE )
{
   HMG_retnl ((LONG_PTR) ((((DRAWITEMSTRUCT FAR *) HMG_parnl(1)))->hwndItem));
}
*/


/*
HB_FUNC ( GETITEMPOS )
{
   HMG_retnl( (LONG_PTR) (((NMMOUSE FAR *) HMG_parnl (1))->dwItemSpec) );
}
*/


HB_FUNC ( GETFOCUS )
{
   HWND hWnd = GetFocus ();
   HMG_retnl ((LONG_PTR) hWnd );
}


HB_FUNC ( MOVEWINDOW )
{
   hb_retl((BOOL) MoveWindow(
                       (HWND) HMG_parnl(1),
                       hb_parni(2),
                       hb_parni(3),
                       hb_parni(4),
                       hb_parni(5),
                       (HB_ISNIL(6) ? TRUE : hb_parl(6))
                      ));
}

HB_FUNC ( GETWINDOWRECT )
{
  RECT rect;
  hb_retl( GetWindowRect( (HWND) HMG_parnl (1), &rect));
  hb_storvnl(rect.left,2,1);
  hb_storvnl(rect.top,2,2);
  hb_storvnl(rect.right,2,3);
  hb_storvnl(rect.bottom,2,4);
}

HB_FUNC ( REGISTERWINDOW )
{
	WNDCLASS WndClass;

	HBRUSH hbrush = 0 ;

	WndClass.style         = CS_HREDRAW | CS_VREDRAW | CS_OWNDC ;
	WndClass.lpfnWndProc   = WndProc;
	WndClass.cbClsExtra    = 0;
	WndClass.cbWndExtra    = 0;
	WndClass.hInstance     = GetModuleHandle( NULL );
	WndClass.hIcon         = LoadIcon(GetModuleHandle(NULL),  HMG_parc(1) );
	if (WndClass.hIcon==NULL)
	{
		WndClass.hIcon= (HICON) LoadImage( GetModuleHandle(NULL),  HMG_parc(1) , IMAGE_ICON, 0, 0, LR_LOADFROMFILE + LR_DEFAULTSIZE ) ;
	}
	if (WndClass.hIcon==NULL)
	{
		WndClass.hIcon= LoadIcon(NULL, IDI_APPLICATION);
	}
	WndClass.hCursor       = LoadCursor(NULL, IDC_ARROW);

	if ( hb_parvni(3, 1) == -1 )
	{
		WndClass.hbrBackground = (HBRUSH)( COLOR_BTNFACE + 1 );
	}
	else
	{
		hbrush = CreateSolidBrush( RGB(hb_parvni(3, 1), hb_parvni(3, 2), hb_parvni(3, 3)) );
		WndClass.hbrBackground = hbrush ;
	}

	WndClass.lpszMenuName  = NULL;
	WndClass.lpszClassName = HMG_parc(2);

	if(!RegisterClass(&WndClass))
	{
      MessageBox(0, _TEXT("Window Registration Failed!"), _TEXT("Error!"), MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);
      ExitProcess(0);
	}
	HMG_retnl ((LONG_PTR) hbrush ) ;
}

HB_FUNC ( UNREGISTERWINDOW )
{
   UnregisterClass (HMG_parc(1), GetModuleHandle (NULL));
}

HB_FUNC (GETDESKTOPWIDTH)
{
   hb_retni (GetSystemMetrics (SM_CXSCREEN));
}

HB_FUNC (GETVSCROLLBARWIDTH)
{
   hb_retni (GetSystemMetrics (SM_CXVSCROLL));
}

HB_FUNC (GETHSCROLLBARHEIGHT)
{
   hb_retni (GetSystemMetrics (SM_CYHSCROLL));
}

HB_FUNC (GETDESKTOPHEIGHT)
{
   hb_retni (GetSystemMetrics (SM_CYSCREEN));
}

HB_FUNC (GETWINDOWROW)
{
	RECT rect;
	int y ;
	GetWindowRect( (HWND) HMG_parnl (1), &rect) ;
	y = rect.top ;
	hb_retni(y);
}

HB_FUNC (GETWINDOWCOL)
{
	RECT rect;
	int x ;
	GetWindowRect( (HWND) HMG_parnl (1), &rect) ;
	x = rect.left ;
	hb_retni(x);
}

HB_FUNC (GETWINDOWWIDTH)
{
	RECT rect;
	int w ;
	GetWindowRect( (HWND) HMG_parnl (1), &rect) ;
	w = rect.right - rect.left ;
	hb_retni(w);
}

HB_FUNC (GETWINDOWHEIGHT)
{
	RECT rect;
	int h ;
	GetWindowRect( (HWND) HMG_parnl (1), &rect) ;
	h = rect.bottom - rect.top ;
	hb_retni(h);
}

HB_FUNC (GETTITLEHEIGHT)
{
   hb_retni (GetSystemMetrics (SM_CYCAPTION));
}

HB_FUNC (GETBORDERHEIGHT)
{
   hb_retni (GetSystemMetrics (SM_CYSIZEFRAME));
}

HB_FUNC (GETBORDERWIDTH)
{
   hb_retni (GetSystemMetrics (SM_CXSIZEFRAME));
}

HB_FUNC (GETMENUBARHEIGHT)
{
   hb_retni (GetSystemMetrics (SM_CYMENU));
}

HB_FUNC (GETSYSTEMMETRICS)
{
   hb_retni (GetSystemMetrics ( hb_parni(1) ));
}


HB_FUNC ( ISWINDOWVISIBLE )
{
   hb_retl (IsWindowVisible ((HWND) HMG_parnl (1)));
}



//        GetClientAreaWidth ( hWnd )
HB_FUNC ( GETCLIENTAREAWIDTH )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   RECT Rect;
   GetClientRect ( hWnd, &Rect );
   hb_retnl ( Rect.right );
}


//        GetClientAreaHeight ( hWnd )
HB_FUNC ( GETCLIENTAREAHEIGHT )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   RECT Rect;
   GetClientRect ( hWnd, &Rect );
   hb_retnl ( Rect.bottom );
}


//-----------------------------------------------------------------------------
// by Pablo Cesar, November 2014

HB_FUNC (GETDESKTOPREALTOP)
{
   RECT Rect;
   SystemParametersInfo ( SPI_GETWORKAREA, 0, &Rect, 0 );
   hb_retni ( Rect.top );
}


HB_FUNC (GETDESKTOPREALLEFT)
{
   RECT Rect;
   SystemParametersInfo ( SPI_GETWORKAREA, 0, &Rect, 0 );
   hb_retni( Rect.left );
}


HB_FUNC (GETDESKTOPREALWIDTH)
{
   RECT Rect;
   SystemParametersInfo ( SPI_GETWORKAREA, 0, &Rect, 0 );
   hb_retni ((Rect.right - Rect.left));
}


HB_FUNC (GETDESKTOPREALHEIGHT)
{
   RECT Rect;
   SystemParametersInfo ( SPI_GETWORKAREA, 0, &Rect, 0 );
   hb_retni ((Rect.bottom - Rect.top));
}


//----------------------------------------------------------------------------//

void ShowNotifyIcon(HWND hWnd, BOOL bAdd, HICON hIcon, TCHAR *szText)
{
  NOTIFYICONDATA nid;
  ZeroMemory(&nid,sizeof(nid));
  nid.cbSize=sizeof(NOTIFYICONDATA);
  nid.hWnd=hWnd;
  nid.uID=0;
  nid.uFlags=NIF_ICON | NIF_MESSAGE | NIF_TIP;
  nid.uCallbackMessage=WM_TASKBAR;
  nid.hIcon=hIcon;
  lstrcpy(nid.szTip,szText);

  if(bAdd)
    Shell_NotifyIcon(NIM_ADD,&nid);
  else
    Shell_NotifyIcon(NIM_DELETE,&nid);
}


HB_FUNC ( SHOWNOTIFYICON )
{
   TCHAR * Text = (TCHAR *) HMG_parc(4);
   ShowNotifyIcon ( (HWND) HMG_parnl (1), (BOOL) hb_parl(2), (HICON) HMG_parnl (3), Text );
}

//----------------------------------------------------------------------------//


HB_FUNC ( GETINSTANCE )
{
   HMODULE hInstance = GetModuleHandle (NULL);
   HMG_retnl ((LONG_PTR) hInstance );
}

HB_FUNC ( GETCURSORPOS )
{
   POINT pt;
   GetCursorPos( &pt );

   if (HB_ISBYREF(1))
       hb_stornl ((LONG) pt.x, 1);
   if (HB_ISBYREF(2))
       hb_stornl ((LONG) pt.y, 2);

   hb_reta( 2 );
   hb_storvni( pt.y, -1, 1 );
   hb_storvni( pt.x, -1, 2 );
}

HB_FUNC (LOADTRAYICON)
{
	HICON himage;
	HINSTANCE hInstance  = (HINSTANCE) HMG_parnl (1);  // handle to application instance
	TCHAR *IconName =  (TCHAR*)  HMG_parc(2);   // name string or resource identifier

   himage = LoadIcon( hInstance ,  IconName );
	if (himage==NULL)
	{
		himage = (HICON) LoadImage( hInstance ,  IconName , IMAGE_ICON, 0, 0, LR_LOADFROMFILE + LR_DEFAULTSIZE ) ;
	}
	HMG_retnl ((LONG_PTR) himage );
}


void ChangeNotifyIcon(HWND hWnd, HICON hIcon, TCHAR *szText)
{
  NOTIFYICONDATA nid;
  ZeroMemory(&nid,sizeof(nid));
  nid.cbSize=sizeof(NOTIFYICONDATA);
  nid.hWnd=hWnd;
  nid.uID=0;
  nid.uFlags=NIF_ICON | NIF_MESSAGE | NIF_TIP;
  nid.uCallbackMessage=WM_TASKBAR;
  nid.hIcon=hIcon;
  lstrcpy(nid.szTip,szText);

  Shell_NotifyIcon(NIM_MODIFY,&nid);
}


HB_FUNC ( CHANGENOTIFYICON )
{
   TCHAR * Text = (TCHAR *) HMG_parc(3);
   ChangeNotifyIcon( (HWND) HMG_parnl(1), (HICON) HMG_parnl(2), Text);
}


HB_FUNC ( INITSPLITBOX )
{
	HWND hwndOwner = (HWND) HMG_parnl (1);
	REBARINFO     rbi;
	HWND   hwndRB;
	INITCOMMONCONTROLSEX icex;

	int Style = 	WS_CHILD |
			WS_VISIBLE |
			WS_CLIPSIBLINGS |
			WS_CLIPCHILDREN |
			RBS_BANDBORDERS |
			RBS_VARHEIGHT |
			RBS_FIXEDORDER;


	if ( hb_parl (2) )
	{
		Style = Style | CCS_BOTTOM ;
	}

	if ( hb_parl (3) )
	{
		Style = Style  | CCS_VERT ;
	}


	icex.dwSize = sizeof(INITCOMMONCONTROLSEX);
	icex.dwICC   = ICC_COOL_CLASSES|ICC_BAR_CLASSES;
	InitCommonControlsEx(&icex);

	hwndRB = CreateWindowEx( WS_EX_TOOLWINDOW | WS_EX_DLGMODALFRAME , REBARCLASSNAME /*_TEXT("ReBarWindow32")*/,
                           TEXT(""), Style ,
                           0, 0, 0, 0,
                           hwndOwner,
                           NULL,
                           GetModuleHandle(NULL),
                           NULL);

	// Initialize and send the REBARINFO structure.
	rbi.cbSize = sizeof(REBARINFO);  // Required when using this struct.
	rbi.fMask  = 0;
	rbi.himl   = (HIMAGELIST)NULL;
	SendMessage(hwndRB, RB_SETBARINFO, 0, (LPARAM)&rbi) ;

	HMG_retnl ((LONG_PTR) hwndRB );

}

HB_FUNC ( INITSPLITCHILDWINDOW )
{
	HWND hwnd;
	int Style;

	Style = WS_POPUP ;

	if ( !hb_parl(4) )
	{
		Style = Style | WS_CAPTION ;
	}

	if ( hb_parl (7) )
	{
		Style = Style | WS_VSCROLL ;
	}

	if ( hb_parl (8) )
	{
		Style = Style | WS_HSCROLL ;
	}

	hwnd = CreateWindowEx( WS_EX_STATICEDGE | WS_EX_TOOLWINDOW , HMG_parc(3) ,
   HMG_parc(5), Style,
	0,
	0,
	hb_parni(1),
	hb_parni(2),
	0,(HMENU)NULL, GetModuleHandle( NULL ) ,NULL);

	if(hwnd == NULL)
	{
	MessageBox(0, _TEXT("Window Creation Failed!"), _TEXT("Error!"),
	MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);
	return;
	}

	HMG_retnl ((LONG_PTR) hwnd );
}

HB_FUNC (SIZEREBAR)
{
	SendMessage(  (HWND) HMG_parnl (1) , RB_SHOWBAND , 0 , (LPARAM) FALSE );
	SendMessage(  (HWND) HMG_parnl (1) , RB_SHOWBAND , 0 , (LPARAM) TRUE  );
}


//*******************************************************************
//    by Dr. Claudio Soto (July 2014)
//*******************************************************************

HB_FUNC ( REBAR_GETHEIGHT )
{
   HWND hWnd  = (HWND) HMG_parnl (1);
   UINT nHeight = SendMessage (hWnd, RB_GETBARHEIGHT, 0, 0);
   hb_retni ((INT) nHeight);
}


HB_FUNC ( REBAR_GETBANDCOUNT )
{
   HWND hWnd  = (HWND) HMG_parnl (1);
   UINT nBandCount = SendMessage (hWnd, RB_GETBANDCOUNT, 0, 0);
   hb_retni ((INT) nBandCount);
}


HB_FUNC ( REBAR_GETBARRECT )
{
   HWND hWnd  = (HWND) HMG_parnl (1);
   UINT nBand = (UINT) hb_parni  (2);
   RECT Rect;
   SendMessage (hWnd, RB_GETRECT, (WPARAM) nBand, (LPARAM) &Rect);
   hb_reta (6);
   hb_storvnl  ((LONG) Rect.left,                 -1, 1);
   hb_storvnl  ((LONG) Rect.top,                  -1, 2);
   hb_storvnl  ((LONG) Rect.right,                -1, 3);
   hb_storvnl  ((LONG) Rect.bottom,               -1, 4);
   hb_storvnl  ((LONG) (Rect.right  - Rect.left), -1, 5);   // nWidth
   hb_storvnl  ((LONG) (Rect.bottom - Rect.top),  -1, 6);   // nHeight
}


HB_FUNC ( REBAR_GETBANDBORDERS )
{
   HWND hWnd  = (HWND) HMG_parnl (1);
   UINT nBand = (UINT) hb_parni  (2);
   RECT Rect;
   SendMessage (hWnd, RB_GETBANDBORDERS , (WPARAM) nBand, (LPARAM) &Rect);
   hb_reta (4);
   hb_storvnl  ((LONG) Rect.left,   -1, 1);
   hb_storvnl  ((LONG) Rect.top,    -1, 2);
   hb_storvnl  ((LONG) Rect.right,  -1, 3);
   hb_storvnl  ((LONG) Rect.bottom, -1, 4);
}


HB_FUNC ( REBAR_SETMINCHILDSIZE )
{
   HWND hWnd  = (HWND) HMG_parnl (1);
   UINT nBand = (UINT) hb_parni  (2);
   UINT yMin  = (UINT) hb_parni  (3);

   REBARBANDINFO rbbi;

   rbbi.cbSize = sizeof (REBARBANDINFO);
   rbbi.fMask  = RBBIM_CHILDSIZE;
   rbbi.cxMinChild = 0;
   rbbi.cyMinChild = yMin;
   rbbi.cx = 0;
   SendMessage (hWnd, RB_SETBANDINFO, (WPARAM) nBand, (LPARAM) &rbbi);
}


HB_FUNC ( REBAR_GETBANDINFO )
{
   HWND hWnd  = (HWND) HMG_parnl (1);
   UINT uBand = (UINT) hb_parni  (2);
   REBARBANDINFO rbbi;

   rbbi.cbSize = sizeof (REBARBANDINFO);
   rbbi.fMask  = RBBIM_CHILDSIZE | RBBIM_SIZE;
   SendMessage (hWnd, RB_GETBANDINFO, (WPARAM) uBand, (LPARAM) &rbbi);
   hb_reta (7);
   hb_storvnl  ((LONG) rbbi.cxMinChild, -1, 1);
   hb_storvnl  ((LONG) rbbi.cyMinChild, -1, 2);
   hb_storvnl  ((LONG) rbbi.cx,         -1, 3);
   hb_storvnl  ((LONG) rbbi.cyChild,    -1, 4);
   hb_storvnl  ((LONG) rbbi.cyMaxChild, -1, 5);
   hb_storvnl  ((LONG) rbbi.cyIntegral, -1, 6);
   hb_storvnl  ((LONG) rbbi.cxIdeal,    -1, 7);
}


//***********************************************************************************************


HB_FUNC( SETSCROLLRANGE )
{
   hb_retl( SetScrollRange( (HWND) HMG_parnl (1),
                            hb_parni( 2 )       ,
                            hb_parni( 3 )       ,
                            hb_parni( 4 )       ,
                            hb_parl( 5 )
                          ) ) ;
}

HB_FUNC( GETSCROLLPOS )
{
   hb_retni( GetScrollPos( (HWND) HMG_parnl (1), hb_parni( 2 ) ) ) ;
}

HB_FUNC( GETWINDOWSTATE )
{
	WINDOWPLACEMENT wp ;
	wp.length = sizeof(WINDOWPLACEMENT) ;
	GetWindowPlacement( (HWND) HMG_parnl (1), &wp );
	hb_retni ( wp.showCmd ) ;
}

HB_FUNC ( REDRAWWINDOW )
{
   RedrawWindow ( (HWND) HMG_parnl (1), NULL , NULL , RDW_ERASE | RDW_FRAME | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
}

HB_FUNC ( REDRAWWINDOWCONTROLRECT )
{
   RECT Rect;
   Rect.top    = hb_parni(2) ;
   Rect.left   = hb_parni(3) ;
   Rect.bottom = hb_parni(4) ;
   Rect.right  = hb_parni(5) ;

   RedrawWindow ( (HWND) HMG_parnl (1), &Rect , NULL, RDW_ERASE  | RDW_FRAME | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
}


// 1 - hWndCtrl
// 2 - hWndSplitBox
// 3 - nWidth
// 4 - lBreak
// 5 - GripperText
// 6 - nWidth
// 7 - nHeight
// 8 - lHorizontal
HB_FUNC ( ADDSPLITBOXITEM )
{
	REBARBANDINFO rbBand;
	RECT          rc;
    TCHAR * Text;

	int Style = RBBS_CHILDEDGE | RBBS_GRIPPERALWAYS ;

	if ( hb_parl (4) )
	{
		Style = Style | RBBS_BREAK ;
	}

	GetWindowRect ( (HWND) HMG_parnl (1), &rc ) ;

	rbBand.cbSize = sizeof(REBARBANDINFO);
	rbBand.fMask  = RBBIM_TEXT | RBBIM_STYLE | RBBIM_CHILD | RBBIM_CHILDSIZE | RBBIM_SIZE ;
	rbBand.fStyle = Style ;
	rbBand.hbmBack= 0;

    Text = (TCHAR *) HMG_parc(5);
	rbBand.lpText     = Text;
	rbBand.hwndChild  = (HWND) HMG_parnl (1);


	if ( !hb_parl (8) )
	{
		// Not Horizontal
		rbBand.cxMinChild = hb_parni(6) ? hb_parni(6) : 0 ;       //0 ; JP 61
		rbBand.cyMinChild = hb_parni(7) ? hb_parni(7) : rc.bottom - rc.top ; // JP 61
		rbBand.cx         = hb_parni(3) ;
	}
	else
	{
		// Horizontal
		if ( hb_parni(6) == 0 && hb_parni(7) == 0 )
		{
			// Not ToolBar
			rbBand.cxMinChild = 0 ;
			rbBand.cyMinChild = rc.right - rc.left ;
			rbBand.cx         = rc.bottom - rc.top ;
		}
		else
		{
			// ToolBar
			rbBand.cxMinChild = hb_parni(7) ? hb_parni(7) : rc.bottom - rc.top ; // JP 61
			rbBand.cyMinChild = hb_parni(6) ? hb_parni(6) : 0 ;
			rbBand.cx         = hb_parni(7) ? hb_parni(7) : rc.bottom - rc.top ;

		}
	}

	SendMessage( (HWND) HMG_parnl (2), RB_INSERTBAND , (WPARAM)-1 , (LPARAM) &rbBand ) ;

}

HB_FUNC (C_SETWINDOWRGN)
{
   HRGN hrgn;
   if ( hb_parni(6)==0)
          SetWindowRgn(GetActiveWindow(),NULL,TRUE);
   else
     {
     if ( hb_parni(6)==1 )
        hrgn=CreateRectRgn(hb_parni(2),hb_parni(3),hb_parni(4),hb_parni(5));
     else
        hrgn=CreateEllipticRgn(hb_parni(2),hb_parni(3),hb_parni(4),hb_parni(5));
     SetWindowRgn(GetActiveWindow(),hrgn,TRUE);
     // Should be hb_parnl(1) instead of GetActiveWindow()
     }
}

HB_FUNC (C_SETPOLYWINDOWRGN)
{
 HRGN hrgn;
 POINT lppt[512];
 int i,fnPolyFillMode;
 int cPoints = hb_parinfa(2,0);

 if(hb_parni(4)==1)
         fnPolyFillMode=WINDING;
 else
         fnPolyFillMode=ALTERNATE;

 for(i = 0; i <= cPoints-1; i++)
  {
   lppt[i].x=hb_parvni(2,i+1);
   lppt[i].y=hb_parvni(3,i+1);
  }
  hrgn=CreatePolygonRgn(lppt,cPoints,fnPolyFillMode);
  SetWindowRgn(GetActiveWindow(),hrgn,TRUE);
  // Should be hb_parnl(1) instead of GetActiveWindow()
}

HB_FUNC ( GETHELPDATA )
{
   HMG_retnl( (LONG_PTR) (((HELPINFO *) HMG_parnl (1))->hItemHandle) );
}

HB_FUNC ( GETMSKTEXTMESSAGE )
{
   HMG_retnl( (LONG_PTR) (((MSGFILTER *) HMG_parnl (1))->msg) );
}

HB_FUNC ( GETMSKTEXTWPARAM )
{
   HMG_retnl( (LONG_PTR) (((MSGFILTER *) HMG_parnl (1))->wParam) );
}

HB_FUNC ( GETMSKTEXTLPARAM )
{
   HMG_retnl( (LONG_PTR) (((MSGFILTER *) HMG_parnl (1))->lParam) );
}


HB_FUNC ( GETESCAPESTATE )
{
	 hb_retni ( GetKeyState( VK_ESCAPE ) ) ;
}

HB_FUNC ( GETALTSTATE )
{
	 hb_retni ( GetKeyState( VK_MENU ) ) ;
}

HB_FUNC ( GETCURSORROW )
{
   POINT pt;
   GetCursorPos( &pt );
   hb_retni( pt.y );
}

HB_FUNC ( GETCURSORCOL )
{
   POINT pt;
   GetCursorPos( &pt );
   hb_retni( pt.x );
}


HB_FUNC ( ISINSERTACTIVE )
{
	 hb_retl ( GetKeyState( VK_INSERT ) ) ;
}

HB_FUNC ( ISCAPSLOCKACTIVE )
{
	 hb_retl ( GetKeyState( VK_CAPITAL ) ) ;
}

HB_FUNC ( ISNUMLOCKACTIVE )
{
	 hb_retl ( GetKeyState( VK_NUMLOCK ) ) ;
}

HB_FUNC ( ISSCROLLLOCKACTIVE )
{
	 hb_retl ( GetKeyState( VK_SCROLL ) ) ;
}

HB_FUNC( FINDWINDOWEX )
{
   HMG_retnl ((LONG_PTR)  FindWindowEx ( (HWND) HMG_parnl (1),
                                         (HWND) HMG_parnl (2),
                                                HMG_parc  (3),
                                                HMG_parc  (4)  ));
}

HB_FUNC( INITDUMMY )
{
	CreateWindowEx( 0L , WC_STATIC /*_TEXT("Static")*/ ,
   _TEXT("") , WS_CHILD ,
	0, 0 , 0, 0,
	(HWND) HMG_parnl (1), (HMENU)NULL , GetModuleHandle(NULL) , NULL ) ;

}

HB_FUNC ( REGISTERSPLITCHILDWINDOW )
{
	WNDCLASS WndClass;

	HBRUSH hbrush = 0 ;

	WndClass.style         = CS_OWNDC ;
	WndClass.lpfnWndProc   = WndProc;
	WndClass.cbClsExtra    = 0;
	WndClass.cbWndExtra    = 0;
	WndClass.hInstance     = GetModuleHandle( NULL );
	WndClass.hIcon         = LoadIcon(GetModuleHandle(NULL),  HMG_parc(1) );
	if (WndClass.hIcon==NULL)
	{
		WndClass.hIcon= (HICON) LoadImage( GetModuleHandle(NULL),  HMG_parc(1) , IMAGE_ICON, 0, 0, LR_LOADFROMFILE + LR_DEFAULTSIZE ) ;
	}
	if (WndClass.hIcon==NULL)
	{
		WndClass.hIcon= LoadIcon(NULL, IDI_APPLICATION);
	}
	WndClass.hCursor       = LoadCursor(NULL, IDC_ARROW);

	if ( hb_parvni(3, 1) == -1 )
	{
		WndClass.hbrBackground = (HBRUSH)( COLOR_BTNFACE + 1 );
	}
	else
	{
		hbrush = CreateSolidBrush( RGB(hb_parvni(3, 1), hb_parvni(3, 2), hb_parvni(3, 3)) );
		WndClass.hbrBackground = hbrush ;
	}

	WndClass.lpszMenuName  = NULL;
	WndClass.lpszClassName = HMG_parc(2);

	if(!RegisterClass(&WndClass))
	{
	MessageBox(0, _TEXT("Window Registration Failed!"), _TEXT("Error!"),
	MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);
	ExitProcess(0);
	}
	HMG_retnl ((LONG_PTR) hbrush );
}

HB_FUNC ( SETWINDOWCURSOR )
{
	HCURSOR ch;

	if( HB_ISCHAR(2) )
	{
		ch = LoadCursor( GetModuleHandle( NULL ), HMG_parc( 2 ) ) ;

		if ( ch == NULL )
		{
			ch = LoadCursorFromFile ( HMG_parc( 2 ) ) ;
		}
	}
	else
	{
		ch = LoadCursor( NULL, MAKEINTRESOURCE( hb_parni( 2 ) ) ) ;
	}

	SetClassLongPtr ( (HWND) HMG_parnl(1),    // window handle
		GCLP_HCURSOR,      // change cursor
		(LONG_PTR) ch );   // new cursor

}

LRESULT APIENTRY HyperLinkSubClassFunc ( HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam );

static __TLS__  WNDPROC HyperLinklpfnOldWndProc;

HB_FUNC( INITHYPERLINKCURSOR )
{
_THREAD_LOCK();
	HWND hwnd;
	hwnd = (HWND) HMG_parnl (1);
	HyperLinklpfnOldWndProc = (WNDPROC) SetWindowLongPtr ( hwnd , GWLP_WNDPROC, (LONG_PTR) HyperLinkSubClassFunc);
_THREAD_UNLOCK();
}

LRESULT APIENTRY HyperLinkSubClassFunc( HWND hWnd, UINT nMsg, WPARAM wParam, LPARAM lParam )
{
	if ( nMsg == WM_MOUSEMOVE )
	{
		SetCursor( LoadCursor( GetModuleHandle( NULL ) , _TEXT("HMG_FINGER") ) ) ;
		return CallWindowProc(HyperLinklpfnOldWndProc, hWnd, 0 , 0, 0 ) ;
	}
	else
	{
		return CallWindowProc(HyperLinklpfnOldWndProc, hWnd, nMsg , wParam, lParam ) ;
	}

}



HB_FUNC ( UPDATEGRAPH )
{
	RedrawWindow ( (HWND) HMG_parnl (1), NULL , NULL , RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW ) ;
}

HB_FUNC ( _GETTABBEDCONTROLBRUSH )
{
	RECT rc;
   HBRUSH hBrush;
	SetBkMode( (HDC) HMG_parnl(1), TRANSPARENT ) ;
	GetWindowRect( (HWND) HMG_parnl (2), &rc);
	MapWindowPoints( NULL, (HWND) HMG_parnl (3), (LPPOINT)(&rc), 2);
	SetBrushOrgEx( (HDC) HMG_parnl (1), -rc.left, -rc.top, NULL);
   hBrush = (HBRUSH) HMG_parnl (4);
   HMG_retnl ((LONG_PTR) hBrush);
}


HB_FUNC( _GETTABBRUSH )
{
	HBRUSH hBrush ;
	RECT rc;
	HDC hDC ;
	HDC hDCMem  ;
	HBITMAP hBmp ;
	HBITMAP hBmp2 ;

// ADD2 (for Tab Custom Draw)
// if( Tab_Custom_Draw )
//   hBrush = CreateSolidBrush (RGB(255,255,255));   // set custom draw background color
//   HMG_retnl ((LONG_PTR) hBrush);
//   return;
// ENDIF

	GetWindowRect ( (HWND) HMG_parnl (1), &rc ) ;
	hDC = GetDC( (HWND) HMG_parnl (1) ) ;
	hDCMem = CreateCompatibleDC(hDC);
	hBmp = CreateCompatibleBitmap(hDC, rc.right - rc.left, rc.bottom - rc.top);
	hBmp2 = (HBITMAP)(SelectObject(hDCMem, hBmp));
	SendMessage( (HWND) HMG_parnl (1), WM_PRINTCLIENT , (WPARAM)(hDCMem) , (LPARAM)(PRF_ERASEBKGND | PRF_CLIENT | PRF_NONCLIENT ) ) ;
	hBrush = CreatePatternBrush(hBmp);

   HMG_retnl ((LONG_PTR) hBrush);

	SelectObject( hDCMem , hBmp2 ) ;

	DeleteObject(hBmp);
	DeleteDC(hDCMem);
	ReleaseDC( (HWND) HMG_parnl (1) , hDC);

}

HB_FUNC ( _GETDDLMESSAGE )
{
   UINT g_dDLMessage = RegisterWindowMessage(DRAGLISTMSGSTRING);
   hb_retnl ( (LONG) g_dDLMessage );
}

HB_FUNC ( GET_DRAG_LIST_NOTIFICATION_CODE )
{
	LPARAM	lParam	= (LPARAM) HMG_parnl (1);
	LPDRAGLISTINFO   lpdli  = (LPDRAGLISTINFO)lParam;
	hb_retni ( lpdli->uNotification ) ;
}

HB_FUNC ( GET_DRAG_LIST_DRAGITEM )
{
	int nDragItem;
	LPARAM	lParam	= (LPARAM) HMG_parnl (1);
	LPDRAGLISTINFO   lpdli  = (LPDRAGLISTINFO)lParam;
	nDragItem = LBItemFromPt(lpdli->hWnd, lpdli->ptCursor, TRUE);
	hb_retnl ((LONG) nDragItem ) ;
}

HB_FUNC ( DRAG_LIST_DRAWINSERT )
{
	HWND hwnd = (HWND) HMG_parnl (1);
	LPARAM	lParam	= (LPARAM) HMG_parnl(2);
	int nItem = hb_parni(3);
	LPDRAGLISTINFO   lpdli  = (LPDRAGLISTINFO)lParam;
	int nItemCount ;
	nItemCount = SendMessage( (HWND) lpdli->hWnd , LB_GETCOUNT , 0, 0 ) ;
	if ( nItem < nItemCount )
	{
		DrawInsert( hwnd , lpdli->hWnd, nItem ) ;
	}
	else
	{
		DrawInsert( hwnd , lpdli->hWnd, -1 ) ;
	}
}

HB_FUNC ( DRAG_LIST_SETCURSOR_UP )
{
	SetCursor( LoadCursor( GetModuleHandle( NULL ) , _TEXT("HMG_DRAGUP") ) ) ;

}

HB_FUNC ( DRAG_LIST_SETCURSOR_DOWN )
{
	SetCursor( LoadCursor( GetModuleHandle( NULL ) , _TEXT("HMG_DRAGDOWN") ) ) ;

}

HB_FUNC ( DRAG_LIST_MOVE_ITEMS )
{
	LPARAM		lParam		= (LPARAM) HMG_parnl (1);
	LPDRAGLISTINFO	lpdli		= (LPDRAGLISTINFO)lParam;

	TCHAR		string[1024];
   int r;

	r = ListBox_GetText       (lpdli->hWnd, hb_parni(2), string);
	r = ListBox_DeleteString  (lpdli->hWnd, hb_parni(2));
	r = ListBox_InsertString  (lpdli->hWnd, hb_parni(3), string);
	r = ListBox_SetCurSel     (lpdli->hWnd, hb_parni(3));
   hb_retni (r);
}

HB_FUNC ( DRAG_LIST_GET_ITEM_COUNT )
{
	LPARAM	lParam	= (LPARAM) HMG_parnl (1);
	LPDRAGLISTINFO   lpdli  = (LPDRAGLISTINFO)lParam;
	int nItemCount ;
	nItemCount = SendMessage( (HWND) lpdli->hWnd , LB_GETCOUNT , 0, 0 ) ;
	hb_retni( nItemCount );
}

HB_FUNC ( GETASYNCKEYSTATE )
{
	hb_retni(GetAsyncKeyState(hb_parni(1)));
}

HB_FUNC( _HMG_CLOSEMENU )
{
	EndMenu();
}

//*************************************************************************************************
// INVALIDATERECT ( hWnd , [ {x_left, y_top, x_right, y_bottom} ] , lEraseBackground )
//*************************************************************************************************
HB_FUNC (INVALIDATERECT)
{
   RECT rect;
   PHB_ITEM pArrayRect;

   if ( ! HB_ISARRAY (2) )
       hb_retl ((BOOL) InvalidateRect( (HWND) HMG_parnl (1), NULL, hb_parl (3))); // Invalidate all client area
   else
   {
      pArrayRect = hb_param (2, HB_IT_ARRAY);

      if (hb_arrayLen (pArrayRect) == 4)
      {   rect.left   = hb_arrayGetNL (pArrayRect, 1);
          rect.top    = hb_arrayGetNL (pArrayRect, 2);
          rect.right  = hb_arrayGetNL (pArrayRect, 3);
          rect.bottom = hb_arrayGetNL (pArrayRect, 4);
          hb_retl ((BOOL) InvalidateRect( (HWND) HMG_parnl (1), &rect, hb_parl (3))); // Invalidate specific region of client area
      }
      else
         hb_retl ((BOOL) FALSE);
   }
}


HB_FUNC ( GETNOTIFYHWND )
{
   HMG_retnl( (LONG_PTR) (((NMHDR *) HMG_parnl (1))->hwndFrom) );
}



HB_FUNC ( GETNOTIFYCHAR )
{
   HMG_retnl( (LONG_PTR) (((NMCHAR *) HMG_parnl (1))->ch) );
}


//   by Dr. Claudio Soto (January 2013)

//        GetNotifyLink ( lParam, @Link_wParam , @Link_lParam , @Link_cpMin , @Link_cpMax )   -> return Link_nMsg
HB_FUNC ( GETNOTIFYLINK )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   ENLINK *pENLink = (ENLINK *) lParam;
   hb_retnl   ((LONG)     pENLink->msg);   // WM_LBUTTONDBLCLK, WM_LBUTTONDOWN, WM_LBUTTONUP, WM_MOUSEMOVE, WM_RBUTTONDBLCLK, WM_RBUTTONDOWN, WM_RBUTTONUP, WM_SETCURSOR
   HMG_stornl ((LONG_PTR) pENLink->wParam,     2);
   HMG_stornl ((LONG_PTR) pENLink->lParam,     3);
   hb_stornl  ((LONG)     pENLink->chrg.cpMin, 4);
   hb_stornl  ((LONG)     pENLink->chrg.cpMax, 5);
}


//   by Dr. Claudio Soto (April 2014)
//        Make_NOTIFYCODE ( hWndFrom, idFrom, code ) --> return lParam

static __TLS__ NMHDR NM;

HB_FUNC ( MAKE_NOTIFYCODE )
{
_THREAD_LOCK();
   NM.hwndFrom = (HWND) HMG_parnl (1);
   NM.idFrom   = (UINT) hb_parnl (2);
   NM.code     = (UINT) hb_parnl (3);
   LPARAM lParam = (LPARAM) &NM;
   HMG_retnl ((LONG_PTR) lParam);
_THREAD_UNLOCK();
}


//*****************************************************************************************************************//
//*   by Dr. Claudio Soto (June 2013)                                                                             *//
//*****************************************************************************************************************//


//        HMG_SendMessage (hWnd, nMsg, @wParam, @lParam) --> Return LRESULT
HB_FUNC ( HMG_SENDMESSAGE )
{  HWND hWnd     = (HWND)   HMG_parnl (1);
   UINT nMsg     = (UINT)   hb_parnl  (2);
   WPARAM wParam = (WPARAM) HMG_parnl (3);
   LPARAM lParam = (LPARAM) HMG_parnl (4);
   LRESULT lResult;

   lResult = SendMessage (hWnd, nMsg, (WPARAM) &wParam, (LPARAM) &lParam);
   HMG_retnl ((LONG_PTR) lResult);

   if (HB_ISBYREF(3))
       HMG_stornl ((LONG_PTR) wParam, 3);
   if (HB_ISBYREF(4))
       HMG_stornl ((LONG_PTR) lParam, 4);
}



/*
//       SendMessage_WM_SETTEXT (hWnd, cText)
HB_FUNC (SENDMESSAGE_WM_SETTEXT)
{
   SendMessage ( (HWND) HMG_parnl (1), WM_SETTEXT, 0, (LPARAM) HMG_parc(2));
}


//       SendMessage_WM_GETTEXT (hWnd) --> Return cText
HB_FUNC (SENDMESSAGE_WM_GETTEXT)
{  UINT nLen = 0;
   TCHAR *cText = NULL;
   nLen = (UINT) SendMessage ( (HWND) HMG_parnl (1), WM_GETTEXTLENGTH, 0, 0);
   if (nLen > 0)
   {  cText = (TCHAR*) hb_xgrab ((nLen+1) * sizeof(TCHAR));
      if (cText)
      {   SendMessage ( (HWND) HMG_parnl (1), WM_GETTEXT, (WPARAM) nLen+1, (LPARAM) cText);
          HMG_retc( cText );
          hb_xfree( cText );
      }
      else
      HMG_retc(_TEXT(""));
   }
   else
      HMG_retc(_TEXT(""));
}
*/


HB_FUNC ( GETCLASSNAME )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   TCHAR cClassName [1024];
   GetClassName ( hWnd, cClassName, sizeof (cClassName) / sizeof (TCHAR) );
   HMG_retc ( cClassName );
}

HB_FUNC ( REALGETWINDOWCLASS )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   TCHAR cWinType [1024];
   RealGetWindowClass ( hWnd, cWinType, sizeof (cWinType) / sizeof (TCHAR) );
   HMG_retc ( cWinType );
}


//        GetParent(hWnd)
HB_FUNC ( GETPARENT )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   HMG_retnl ((LONG_PTR) GetParent(hWnd) );
}


//        SetParent (hWndChild, hWndNewParent)
HB_FUNC ( SETPARENT )
{
   HWND hWndChild     = (HWND) HMG_parnl (1);
   HWND hWndNewParent = (HWND) HMG_parnl (2);
   HMG_retnl ((LONG_PTR)  SetParent (hWndChild, hWndNewParent) );
}


//        GetWindow (hWnd, uCmd)
HB_FUNC ( GETWINDOW )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   UINT uCmd = (UINT) hb_parni  (2);
   HWND hWndGet = GetWindow (hWnd, uCmd);
   HMG_retnl ((LONG_PTR) hWndGet );
}


//       SetWindowPos (hWnd, hWndInsertAfter, x, y, cx, cy, uFlags)
HB_FUNC (SETWINDOWPOS)
{
   HWND hWnd             = (HWND) HMG_parnl (1);
   HWND  hWndInsertAfter = (HWND) HMG_parnl (2);
   INT  x                = (INT)  hb_parnl  (3);
   INT  y                = (INT)  hb_parnl  (4);
   INT  cx               = (INT)  hb_parnl  (5);
   INT  cy               = (INT)  hb_parnl  (6);
   UINT uFlags           = (UINT) hb_parnl  (7);
   hb_retl((BOOL) SetWindowPos (hWnd, hWndInsertAfter, x, y, cx, cy, uFlags));
}


//        AnimateWindow (hWnd, dwTime, dwFlags)
HB_FUNC ( ANIMATEWINDOW )
{
   HWND  hWnd    = (HWND)  HMG_parnl (1);
   DWORD dwTime  = (DWORD) hb_parnl (2);
   DWORD dwFlags = (DWORD) hb_parnl (3);
   hb_retl ((BOOL) AnimateWindow ( hWnd, dwTime, dwFlags ));
}


//        FlashWindowEx (hWnd, dwFlags, uCount, dwTimeout)
HB_FUNC ( FLASHWINDOWEX )
{
   FLASHWINFO FlashWinInfo;
   FlashWinInfo.cbSize    = sizeof (FLASHWINFO);
   FlashWinInfo.hwnd      = (HWND)  HMG_parnl (1);
   FlashWinInfo.dwFlags   = (DWORD) hb_parnl (2);
   FlashWinInfo.uCount    = (UINT)  hb_parnl (3);
   FlashWinInfo.dwTimeout = (DWORD) hb_parnl (4);
   hb_retl ((BOOL) FlashWindowEx (&FlashWinInfo));
}


//        SetLayeredWindowAttributes (hWnd, crKey, bAlpha, dwFlags)
HB_FUNC ( SETLAYEREDWINDOWATTRIBUTES )
{
   HWND     hWnd    = (HWND)     HMG_parnl (1);
   COLORREF crKey   = (COLORREF) hb_parnl (2);
   BYTE     bAlpha  = (BYTE)     hb_parni (3);
   DWORD    dwFlags = (DWORD)    hb_parnl (4);

   if (!(GetWindowLongPtr (hWnd, GWL_EXSTYLE) & WS_EX_LAYERED))
       SetWindowLongPtr (hWnd, GWL_EXSTYLE, (GetWindowLongPtr (hWnd, GWL_EXSTYLE) | WS_EX_LAYERED));

   hb_retl ((BOOL) SetLayeredWindowAttributes (hWnd, crKey, bAlpha, dwFlags));
}


//        SetWindowTransparentStyle (hWnd)
HB_FUNC ( SETWINDOWTRANSPARENTSTYLE )
{
   HWND  hWnd  = (HWND) HMG_parnl (1);
   SetWindowLongPtr (hWnd, GWL_EXSTYLE, (GetWindowLongPtr (hWnd, GWL_EXSTYLE) | WS_EX_TRANSPARENT));
}


//        CCM_SETVERSION (hWnd, nVersion)
HB_FUNC ( CCM_SETVERSION )
{
   HWND   hWnd      = (HWND)   HMG_parnl (1);
   WPARAM nVersion  = (WPARAM) hb_parnl (2);
   hb_retnl ((LONG) SendMessage (hWnd, CCM_SETVERSION, (WPARAM) nVersion, 0));
}


//        CCM_GETVERSION (hWnd)
HB_FUNC ( CCM_GETVERSION )
{
   HWND    hWnd      = (HWND) HMG_parnl (1);
   LRESULT nVersion  = (WPARAM) SendMessage (hWnd, CCM_GETVERSION, 0, 0);
   hb_retnl ((LONG) nVersion);
}


//       GetLastActivePopup (hWnd) --> return hWnd
HB_FUNC (GETLASTACTIVEPOPUP)
{  HWND hWnd = (HWND) HMG_parnl (1);
   HMG_retnl ((LONG_PTR) GetLastActivePopup (hWnd) );
}


//       WindowFromPoint (x,y) --> return hWnd
HB_FUNC (WINDOWFROMPOINT)
{
   LONG x  = (LONG) hb_parnl (1);
   LONG y  = (LONG) hb_parnl (2);
   POINT Point;
   Point.x = x;
   Point.y = y;
   HWND hWnd = WindowFromPoint (Point);
   HMG_retnl ((LONG_PTR) hWnd );
}


//       ChildWindowFromPoint (hWndParent, x, y) --> return hWndChild
HB_FUNC (CHILDWINDOWFROMPOINT)
{
   HWND hWndParent = (HWND) HMG_parnl (1);
   LONG x          = (LONG) hb_parnl (2);
   LONG y          = (LONG) hb_parnl (3);
   POINT Point;
   Point.x = x;
   Point.y = y;
   HWND hWndChild = ChildWindowFromPoint (hWndParent, Point);
   HMG_retnl ((LONG_PTR) hWndChild );
}


//       RealChildWindowFromPoint (hWndParent, x, y) --> return hWndChild
HB_FUNC (REALCHILDWINDOWFROMPOINT)
{
   HWND hWndParent = (HWND) HMG_parnl (1);
   LONG x          = (LONG) hb_parnl (2);
   LONG y          = (LONG) hb_parnl (3);
   POINT Point;
   Point.x = x;
   Point.y = y;
   HWND hWndChild = RealChildWindowFromPoint (hWndParent, Point);
   HMG_retnl ((LONG_PTR) hWndChild );
}


//       MenuItemFromPoint (hWnd, hMenu, x, y) --> return nPosition
HB_FUNC (MENUITEMFROMPOINT)
{  HWND  hWnd  = (HWND)  HMG_parnl (1);
   HMENU hMenu = (HMENU) HMG_parnl (2);
   LONG x      = (LONG)  hb_parnl (3);
   LONG y      = (LONG)  hb_parnl (4);
   POINT Point;
   Point.x = x;
   Point.y = y;
   hb_retni ((INT) MenuItemFromPoint (hWnd, hMenu, Point));
}


//       GetMenuItemRect (hWnd, hMenu, nItem, @x1, @y1, @x2, @y2)
HB_FUNC (GETMENUITEMRECT)
{  HWND  hWnd  = (HWND)  HMG_parnl (1);
   HMENU hMenu = (HMENU) HMG_parnl (2);
   UINT  nItem = (UINT)  hb_parni (3);
   RECT  Rect;

   hb_retl ((BOOL) GetMenuItemRect (hWnd, hMenu, nItem, &Rect));

   if (HB_ISBYREF(4))
       hb_stornl ((LONG) Rect.left, 4);
   if (HB_ISBYREF(5))
       hb_stornl ((LONG) Rect.top, 5);
   if (HB_ISBYREF(6))
       hb_stornl ((LONG) Rect.right, 6);
   if (HB_ISBYREF(7))
       hb_stornl ((LONG) Rect.bottom, 7);
}


//       PtInRect (x, y, x1, y1, x2, y2) --> return lBoolean
HB_FUNC (PTINRECT)
{  RECT  Rect;
   POINT pt;
   pt.x        = (LONG) hb_parnl (1);
   pt.y        = (LONG) hb_parnl (2);
   Rect.left   = (LONG) hb_parnl (3);
   Rect.top    = (LONG) hb_parnl (4);
   Rect.right  = (LONG) hb_parnl (5);
   Rect.bottom = (LONG) hb_parnl (6);
   hb_retl ((BOOL) PtInRect (&Rect, pt));
}


//       ScreenToClient (hWnd, @x, @y)
HB_FUNC (SCREENTOCLIENT)
{
   HWND hWnd = (HWND) HMG_parnl (1);
   LONG x    = (LONG) hb_parnl (2);
   LONG y    = (LONG) hb_parnl (3);
   POINT Point;
   Point.x = x;
   Point.y = y;
   hb_retl (ScreenToClient(hWnd, &Point));
   if (HB_ISBYREF(2))
       hb_stornl ((LONG) Point.x, 2);
   if (HB_ISBYREF(3))
       hb_stornl ((LONG) Point.y, 3);
}

//       ScreenToClientRow (hWnd, Row) --> New_Row
HB_FUNC (SCREENTOCLIENTROW)
{
   HWND hWnd = (HWND) HMG_parnl (1);
   LONG y    = (LONG) hb_parnl (2);
   POINT Point;
   Point.x = 0;
   Point.y = y;
   ScreenToClient(hWnd, &Point);
   hb_retnl ((LONG) Point.y );
}

//       ScreenToClientCol (hWnd, Col) --> New_Col
HB_FUNC (SCREENTOCLIENTCOL)
{
   HWND hWnd = (HWND) HMG_parnl (1);
   LONG x    = (LONG) hb_parnl (2);
   POINT Point;
   Point.x = x;
   Point.y = 0;
   ScreenToClient(hWnd, &Point);
   hb_retnl ((LONG) Point.x );
}


//       ClientToScreen (hWnd, @x, @y)
HB_FUNC (CLIENTTOSCREEN)
{
   HWND hWnd = (HWND) HMG_parnl (1);
   LONG x    = (LONG) hb_parnl (2);
   LONG y    = (LONG) hb_parnl (3);
   POINT Point;
   Point.x = x;
   Point.y = y;
   hb_retl (ClientToScreen(hWnd, &Point));
   if (HB_ISBYREF(2))
       hb_stornl ((LONG) Point.x, 2);
   if (HB_ISBYREF(3))
       hb_stornl ((LONG) Point.y, 3);
}

//       ClientToScreenRow (hWnd, Row) --> New_Row
HB_FUNC (CLIENTTOSCREENROW)
{
   HWND hWnd = (HWND) HMG_parnl (1);
   LONG y    = (LONG) hb_parnl (2);
   POINT Point;
   Point.x = 0;
   Point.y = y;
   ClientToScreen(hWnd, &Point);
   hb_retnl ((LONG) Point.y );
}

//       ClientToScreenCol (hWnd, Col) --> New_Col
HB_FUNC (CLIENTTOSCREENCOL)
{
   HWND hWnd = (HWND) HMG_parnl (1);
   LONG x    = (LONG) hb_parnl (2);
   POINT Point;
   Point.x = x;
   Point.y = 0;
   ClientToScreen(hWnd, &Point);
   hb_retnl ((LONG) Point.x );
}


//        EnableWindowRedraw ( hWnd, lRedrawOnOff, lRedrawWindow )
HB_FUNC ( ENABLEWINDOWREDRAW )
{
   HWND hWnd          = (HWND) HMG_parnl (1);
   BOOL lRedrawOnOff  = (BOOL) hb_parl   (2);
   BOOL lRedrawWindow = (BOOL) hb_parl   (3);

   SendMessage ( hWnd, WM_SETREDRAW, (WPARAM) lRedrawOnOff, 0 );

   if ((lRedrawOnOff == TRUE) && (lRedrawWindow == TRUE))
       RedrawWindow (hWnd, NULL, NULL, RDW_ERASE | RDW_FRAME | RDW_INVALIDATE | RDW_ALLCHILDREN);
}


//       HMG_ChangeWindowStyle ( hWnd, [ nAddStyle ], [ nRemoveStyle ], [ lExStyle ], [ lRedrawWindow ] )
HB_FUNC( HMG_CHANGEWINDOWSTYLE )
{
   HWND     hWnd          = (HWND)     HMG_parnl (1);
   LONG_PTR Add           = (LONG_PTR) HMG_parnl (2);
   LONG_PTR Remove        = (LONG_PTR) HMG_parnl (3);
   BOOL     ExStyle       = (BOOL)     hb_parl   (4);
   BOOL     lRedrawWindow = ( HB_ISLOG (5) ? (BOOL) hb_parl (5) : TRUE );

   int      nIndex  = ExStyle ? GWL_EXSTYLE : GWL_STYLE;

   LONG_PTR OldStyle = GetWindowLongPtr ( hWnd, nIndex );
   LONG_PTR NewStyle = (OldStyle | Add) & ( ~Remove );
   LONG_PTR Style    = SetWindowLongPtr ( hWnd, nIndex, NewStyle );

   if ( lRedrawWindow )
      SetWindowPos ( hWnd, NULL, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED );

   HMG_retnl ((LONG_PTR) Style);
}


//        HMG_IsWindowStyle ( hWnd, nStyle, [ lExStyle ] )
HB_FUNC ( HMG_ISWINDOWSTYLE )
{
   HWND     hWnd     = (HWND)     HMG_parnl (1);
   LONG_PTR Style    = (LONG_PTR) HMG_parnl (2);
   BOOL     ExStyle  = (BOOL)     hb_parl (3);
   int      nIndex   = ExStyle ? GWL_EXSTYLE : GWL_STYLE;
   LONG_PTR OldStyle = GetWindowLongPtr ( hWnd, nIndex );

   hb_retl ((BOOL) (OldStyle & Style));
}


//        IsValidWindowHandle ( hWnd )
HB_FUNC ( ISVALIDWINDOWHANDLE )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   hb_retl ((BOOL) IsWindow ( hWnd ) );
}


//        IsMinimized ( hWnd )
HB_FUNC ( ISMINIMIZED )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   hb_retl ((BOOL) IsIconic ( hWnd ) );
}


//        IsMaximized ( hWnd )
HB_FUNC ( ISMAXIMIZED )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   hb_retl ((BOOL) IsZoomed ( hWnd ) );
}


//        GetDesktopWindow () --> hWndDesktop
HB_FUNC ( GETDESKTOPWINDOW )
{
   HWND hWnd = GetDesktopWindow();
   HMG_retnl ((LONG_PTR) hWnd );
}



