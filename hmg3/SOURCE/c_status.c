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




//#define WINVER  0x0500
//#define _WIN32_IE      0x0500
//#define HB_OS_WIN_32_USED
//#define _WIN32_WINNT   0x0400


#define WM_TASKBAR     WM_USER+1043   // User define message

#include <shlobj.h>
#include <windows.h>
#include "richedit.h"
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include <commctrl.h>

//#define SB_SETTIPTEXTA          (WM_USER+16)
//#define SBT_TOOLTIPS            0x0800
//#define SB_SETICON              (WM_USER+15)
//#define SB_SETTIPTEXT           SB_SETTIPTEXTA


// ----------------------------------------------------------------------------
// InitStatusBar Function
// ----------------------------------------------------------------------------
//
// Parameters:
//
//	1.  Parent Window Handle
//	2.  StatusBar Id
//	3.  Captions Array
//	4.  Widths Arrays
//	5.  Images Arrays
//	6.  ToolTip Array
//	7.  Styles Array
//	8.  Top
//
// ----------------------------------------------------------------------------
HB_FUNC ( INITSTATUSBAR )
{

	HICON hIcon ;
	HWND hwndStatus;
	HLOCAL hloc;
	LPINT lpParts;
	int i, nWidth , nParts , cx , cy , style , top ;
	RECT rect ;
   TCHAR *text;

	HWND     hwndParent = (HWND) HMG_parnl (1);
	LONG_PTR statusbarid = HMG_parnl(2); /*hb_parvni(2);*/   // Change

	nParts = hb_parinfa( 3, 0 ) ;

   // InitCommonControls();

   INITCOMMONCONTROLSEX icex;
   icex.dwSize = sizeof(INITCOMMONCONTROLSEX);
   icex.dwICC = ICC_BAR_CLASSES;
   InitCommonControlsEx (&icex);


	if ( hb_parl(8) )
	{
		top = CCS_TOP ;
	}
	else
	{
		top = 0 ;
	}

	hwndStatus = CreateWindowEx( 0L , STATUSCLASSNAME /*_TEXT("msctls_statusbar32")*/ ,
		TEXT(""),
		WS_CHILD | WS_VISIBLE | SBT_TOOLTIPS | top ,
		0, 0, 0, 0,
		hwndParent,
		(HMENU) statusbarid,
		GetModuleHandle(NULL) ,
		NULL);


	// Set Widths /////////////////////////////////////////////////////////

	hloc = LocalAlloc(LHND, sizeof(int) * nParts);
	lpParts = LocalLock(hloc);

	nWidth = 0 ;

	for ( i = 0 ; i < nParts ; i++ )
	{
		nWidth = nWidth + hb_parvni ( 4 , i + 1 ) ;
		lpParts[i] = nWidth;
	}

	SendMessage(hwndStatus, SB_SETPARTS, (WPARAM) nParts, (LPARAM) lpParts);

	// Set Captions And Styles ////////////////////////////////////////////

	for (i = 0 ; i<nParts ; i++ )
	{
		style = hb_parvni ( 7 , i + 1 ) ;

		if ( style == 0 )
		{
         text = (TCHAR*) HMG_parvc ( 3 , i + 1 );
			SendMessage(hwndStatus, SB_SETTEXT, (WPARAM) i , (LPARAM) text ) ;
		}
		else if ( style == 1 )
		{
			text = (TCHAR*) HMG_parvc ( 3 , i + 1 );
         SendMessage(hwndStatus, SB_SETTEXT, (WPARAM) i | SBT_NOBORDERS , (LPARAM) text ) ;
		}
		else if ( style == 2 )
		{
         text = (TCHAR*) HMG_parvc ( 3 , i + 1 );
			SendMessage(hwndStatus, SB_SETTEXT, (WPARAM) i | SBT_POPOUT , (LPARAM)  text ) ;
		}

	}

	// Set Icons //////////////////////////////////////////////////////////

	GetClientRect(hwndStatus , &rect);

	cy = rect.bottom - rect.top-4;
	cx = cy;

	for (i = 0 ; i<nParts ; i++ )
	{
        hIcon = NULL;
        text = (TCHAR*) HMG_parvc ( 5 , i + 1 );

if (text != NULL)
{
		hIcon = (HICON)LoadImage(GetModuleHandle(NULL), text, IMAGE_ICON ,cx,cy, 0 );

		if (hIcon==NULL)
		{
			hIcon = (HICON)LoadImage(0, text, IMAGE_ICON ,cx,cy, LR_LOADFROMFILE );
		}
}

		SendMessage(hwndStatus,SB_SETICON,(WPARAM) i , (LPARAM)hIcon );

	}

	// Set ToolTips ///////////////////////////////////////////////////////

	for (i = 0 ; i<nParts ; i++ )
	{
      text = (TCHAR*) HMG_parvc ( 6 , i + 1 );
		SendMessage(hwndStatus, SB_SETTIPTEXT , (WPARAM) i , (LPARAM) text ) ;
	}

	// End ////////////////////////////////////////////////////////////////

	LocalUnlock(hloc);
	LocalFree(hloc);

	HMG_retnl ((LONG_PTR) hwndStatus );

}

HB_FUNC ( INITSTATUSBARSIZE )
{

	HLOCAL hloc;
	LPINT lpParts;

	HWND hwndStatus = (HWND) HMG_parnl (1);
	int nParts = hb_parinfa( 2, 0 ) ;
	int nWidth ;
	int i ;

	// Set Widths /////////////////////////////////////////////////////////

	hloc = LocalAlloc(LHND, sizeof(int) * nParts);
	lpParts = LocalLock(hloc) ;

	nWidth = 0 ;

	for ( i = 0 ; i < nParts ; i++ )
	{
		nWidth = nWidth + hb_parvni ( 2 , i + 1 ) ;
		lpParts[i] = nWidth;
	}

	SendMessage(hwndStatus, SB_SETPARTS, (WPARAM) nParts, (LPARAM) lpParts);

	MoveWindow((HWND) hwndStatus, 0, 0, 0, 0, TRUE);

	LocalUnlock(hloc);
	LocalFree(hloc);

}

HB_FUNC ( GETSTATUSBARITEMPOS )
{
	hb_retnl( (LONG) (((NMMOUSE FAR *) HMG_parnl (1))->dwItemSpec) );
}

HB_FUNC (SETSTATUSITEMTEXT)
{
   TCHAR * text = (TCHAR *) HMG_parc(2);
   WORD nDraw = HIWORD ( SendMessage ((HWND) HMG_parnl (1), SB_GETTEXTLENGTH, (WPARAM) hb_parnl (3), 0) );   // ADD (nDraw), December 2014
   SendMessage( (HWND) HMG_parnl (1) , SB_SETTEXT , (WPARAM) (nDraw | hb_parnl (3)) , (LPARAM) text ) ;      // ADD (nDraw), December 2014
}

HB_FUNC (GETSTATUSITEMTEXT)
{
   WORD nLen = LOWORD ( SendMessage ((HWND) HMG_parnl (1), SB_GETTEXTLENGTH, (WPARAM) hb_parnl (2), 0) );
   if (nLen > 0)
   {  TCHAR text [ nLen + 1 ];
      SendMessage( (HWND) HMG_parnl (1) , SB_GETTEXT , (WPARAM) hb_parnl (2) , (LPARAM) text ) ;
      HMG_retc (text);
   }
   else
      HMG_retc (_TEXT(""));
}



HB_FUNC ( SETSTATUSITEMICON )
{

	HWND  hwnd;
	RECT  rect;
	HICON hIcon = NULL ;
	int   cx;
	int   cy;

	hwnd = (HWND) HMG_parnl (1);

	// Unloads from memory current icon

	DestroyIcon ( (HICON) SendMessage(hwnd,SB_GETICON, (WPARAM) hb_parnl(2), (LPARAM) 0 ) ) ;

	//

	GetClientRect(hwnd, &rect);

	cy = rect.bottom - rect.top - 4 ;
	cx = cy;


TCHAR * text = (TCHAR*) HMG_parc(3);

if (text != NULL)
{
	hIcon = (HICON)LoadImage(GetModuleHandle(NULL),text,IMAGE_ICON ,cx,cy, 0 );

	if (hIcon==NULL)
	{
		hIcon = (HICON)LoadImage(0, text,IMAGE_ICON ,cx,cy, LR_LOADFROMFILE );
	}
}
else if ( HB_ISNUM (4) )
     hIcon = (HICON) HMG_parnl (4);

	SendMessage(hwnd,SB_SETICON,(WPARAM) hb_parnl(2), (LPARAM)hIcon );

}

