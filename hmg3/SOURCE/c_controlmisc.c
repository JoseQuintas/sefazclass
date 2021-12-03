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



//#if defined(_MSC_VER)
//#define UDM_SETPOS32 (WM_USER+113)   // ok
//#define UDM_GETPOS32 (WM_USER+114)   // ok
//#endif


#include <shlobj.h>
#include <windows.h>
#include <shlwapi.h>
#include <commctrl.h>
#include <olectl.h>
#include <lmcons.h>
#include <tchar.h>
#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"

#include "hbthread.h"
extern HB_CRITICAL_T _HMG_Mutex;   // global Mutex variable defined into c_Thread.c

HBITMAP HMG_LoadImage (TCHAR *FileName);


typedef HRESULT(WINAPI *LPAtlAxGetControl)(HWND hwnd,IUnknown** unk);
typedef HRESULT(WINAPI *LPAtlAxWinInit)(void);


HB_FUNC ( DELETEOBJECT )
{
   hb_retl ( DeleteObject( (HGDIOBJ) HMG_parnl (1) ) ) ;
}

HB_FUNC ( CSHOWCONTROL )
{
	HWND hwnd;

	hwnd = (HWND) HMG_parnl (1);

	ShowWindow(hwnd, SW_SHOW);
}


HB_FUNC( INITTOOLTIP )
{
   HWND hWnd_ToolTip;
   int Style = TTS_ALWAYSTIP;

   if ( hb_parl(2) )
       Style = Style | TTS_BALLOON ;

   // InitCommonControls();

   INITCOMMONCONTROLSEX icex;
   icex.dwSize = sizeof(INITCOMMONCONTROLSEX);
   icex.dwICC = ICC_BAR_CLASSES;
   InitCommonControlsEx (&icex);

   hWnd_ToolTip = CreateWindowEx( 0L , TOOLTIPS_CLASS /*_TEXT("tooltips_class32")*/ ,
                                _TEXT(""),
                                Style,
                                0,
                                0,
                                0,
                                0,
                                (HWND) HMG_parnl (1),
                                (HMENU) NULL,
                                GetModuleHandle ( NULL ),
                                NULL ) ;

   HMG_retnl ((LONG_PTR) hWnd_ToolTip) ;
}


HB_FUNC ( SETTOOLTIP )
{
   HWND hWnd         = (HWND)   HMG_parnl (1);
   TCHAR *Text       = (TCHAR*) HMG_parc  (2);
   HWND hWnd_ToolTip = (HWND)   HMG_parnl (3);

   TOOLINFO ti;
   memset ( &ti, 0, sizeof(ti) );

   ti.cbSize = sizeof(ti);
   ti.uFlags = TTF_SUBCLASS|TTF_IDISHWND;
   ti.hwnd   = GetParent (hWnd);
   ti.uId    = (UINT_PTR) hWnd;

   if ( SendMessage ( hWnd_ToolTip, TTM_GETTOOLINFO, 0, (LPARAM) &ti ) )
        SendMessage ( hWnd_ToolTip, TTM_DELTOOL,     0, (LPARAM) &ti );

   ti.cbSize   = sizeof(ti);
   ti.uFlags   = TTF_SUBCLASS|TTF_IDISHWND;
   ti.hwnd     = GetParent (hWnd);
   ti.uId      = (UINT_PTR) hWnd;
   ti.lpszText = Text;

   hb_retl ((BOOL) SendMessage(hWnd_ToolTip, TTM_ADDTOOL, 0, (LPARAM)&ti) );
}


/*********************************************************************************************************************/

// by Dr. Claudio Soto, December 2014


HB_FUNC ( TOOLTIP_INITMENU )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   HWND hWnd_ToolTip;
   int Style = TTS_NOPREFIX;

   if ( hb_parl(2) )
       Style = Style | TTS_BALLOON ;

   INITCOMMONCONTROLSEX icex;
   icex.dwSize = sizeof(INITCOMMONCONTROLSEX);
   icex.dwICC = ICC_BAR_CLASSES;
   InitCommonControlsEx (&icex);

   hWnd_ToolTip = CreateWindowEx( 0L , TOOLTIPS_CLASS /*_TEXT("tooltips_class32")*/ ,
                                _TEXT(""),
                                Style,
                                0,
                                0,
                                0,
                                0,
                                (HWND) hWnd,
                                (HMENU) NULL,
                                GetModuleHandle ( NULL ),
                                NULL ) ;

   HMG_retnl ((LONG_PTR) hWnd_ToolTip) ;
}


//        SetToolTipMenuItem ( hWnd, cText, MenuItemID, hWndToolTip )
HB_FUNC ( SETTOOLTIPMENUITEM )
{
   HWND     hWnd        = (HWND)     HMG_parnl (1);
   TCHAR   *cText       = (TCHAR*)   HMG_parc  (2);
   UINT_PTR MenuItemID  = (UINT_PTR) HMG_parnl (3);
   HWND     hWndToolTip = (HWND)     HMG_parnl (4);

   TOOLINFO ti;
   memset ( &ti, 0, sizeof(ti) );

   ti.cbSize = sizeof(ti);
   ti.uFlags = TTF_SUBCLASS | TTF_TRANSPARENT | TTF_TRACK | TTF_ABSOLUTE;
   ti.hwnd   = hWnd;
   ti.uId    = MenuItemID;

   if ( SendMessage ( hWndToolTip, TTM_GETTOOLINFO, 0, (LPARAM) &ti ) )
        SendMessage ( hWndToolTip, TTM_DELTOOL,     0, (LPARAM) &ti );

   ti.cbSize   = sizeof(ti);
   ti.uFlags   = TTF_SUBCLASS | TTF_TRANSPARENT | TTF_TRACK | TTF_ABSOLUTE;
   ti.hwnd     = hWnd;
   ti.uId      = MenuItemID;
   ti.lpszText = cText;

   hb_retl ((BOOL) SendMessage(hWndToolTip, TTM_ADDTOOL, 0, (LPARAM) &ti) );
}


void ToolTip_ShowMenu (HWND hWndToolTip, HWND hWnd, UINT_PTR nMenuItemID, BOOL bShow)
{
   TOOLINFO ti;
   ti.cbSize = sizeof(TOOLINFO);
   ti.uFlags = TTF_SUBCLASS | TTF_TRANSPARENT | TTF_TRACK | TTF_ABSOLUTE;
   ti.hwnd   = hWnd;
   ti.uId    = nMenuItemID;
   SendMessage (hWndToolTip, TTM_TRACKACTIVATE, (WPARAM) bShow, (LPARAM) &ti);
}


//        ToolTip_ShowMenu ( hWndToolTip, hWndMenu, nMenuItemID, lShow )
HB_FUNC ( TOOLTIP_SHOWMENU )
{
   HWND     hWndToolTip = (HWND)     HMG_parnl (1);
   HWND     hWndMenu    = (HWND)     HMG_parnl (2);   // Parent Window of Menu
   UINT_PTR nMenuItemID = (UINT_PTR) HMG_parnl (3);
   BOOL     bShow       = (BOOL)     hb_parni  (4);

   ToolTip_ShowMenu (hWndToolTip, hWndMenu, nMenuItemID, bShow);
}


//        ToolTip_MenuDisplay ( hWndToolTip, hWndMenu, hMenu, nMenuItemID, nMenuFlags, hFont )
HB_FUNC ( TOOLTIP_MENUDISPLAY )
{
   HWND     hWndToolTip = (HWND)     HMG_parnl (1);
   HWND     hWndMenu    = (HWND)     HMG_parnl (2);   // Parent Window of Menu
   HMENU    hMenu       = (HMENU)    HMG_parnl (3);
   UINT_PTR nMenuItemID = (UINT_PTR) HMG_parnl (4);
   UINT     nMenuFlags  = (UINT)     hb_parni  (5);
   HFONT    hFont       = (HFONT)    HMG_parnl (6);

   if ( hWndToolTip == NULL )
        return;

   SendMessage (hWndToolTip, WM_SETFONT, (WPARAM) hFont, MAKELPARAM (TRUE, 0));

   if ( nMenuFlags & MF_POPUP || (nMenuFlags == 0xFFFF && hMenu == NULL) )
   {   ToolTip_ShowMenu (hWndToolTip, hWndMenu, nMenuItemID, FALSE);
       return;
   }

   RECT Rect = {0,0,0,0};
   int nItem;
   for ( nItem = 0; nItem < GetMenuItemCount (hMenu); nItem++ )
   {  if ( GetMenuItemID (hMenu, nItem) == nMenuItemID )
      {    GetMenuItemRect (NULL, hMenu, nItem, &Rect);
           break;
      }
   }

   SendMessage (hWndToolTip, TTM_TRACKPOSITION, 0, (LPARAM) MAKELPARAM (Rect.right + 10, Rect.top + 2));

   SetWindowPos (hWndToolTip, HWND_TOPMOST, 0,0,0,0, SWP_NOSIZE|SWP_NOACTIVATE|SWP_NOMOVE);

   ToolTip_ShowMenu (hWndToolTip, hWndMenu, nMenuItemID, TRUE);
}


HB_FUNC ( TOOLTIP_CUSTOMDRAW )
{
   LPARAM    lParam    = (LPARAM)   HMG_parnl (1);
   COLORREF  BackColor = (COLORREF) hb_parni  (2);
   COLORREF  TextColor = (COLORREF) hb_parni  (3);

   LPNMTTCUSTOMDRAW lpNMTTCustomDraw = (LPNMTTCUSTOMDRAW) lParam;

   if( lpNMTTCustomDraw->nmcd.dwDrawStage == CDDS_PREPAINT )
   {
      if ( BackColor != (COLORREF) -1 )
         SetBkColor( lpNMTTCustomDraw->nmcd.hdc, BackColor );

      if ( TextColor != (COLORREF) -1 )
         SetTextColor( lpNMTTCustomDraw->nmcd.hdc, TextColor );

      lpNMTTCustomDraw->uDrawFlags = DT_CALCRECT | DT_EDITCONTROL | DT_WORDBREAK;

   }
   hb_retni( CDRF_DODEFAULT );
}


//        ToolTip_SetTitle ( hwndToolTip, [ cTitle ] , [ cIconName | nIconName ] )
HB_FUNC ( TOOLTIP_SETTITLE)
{
   HWND  hwndToolTip = (HWND)    HMG_parnl (1);
   TCHAR *cTitle     = (TCHAR *) HMG_parc  (2);
   TCHAR *cIconName  = (TCHAR *) HMG_parc  (3);
   INT    nIconName  = (INT)     hb_parni  (3);

   if ( HB_ISNUM ( 3 ) )
      SendMessage(hwndToolTip, TTM_SETTITLE, (WPARAM) nIconName, (LPARAM) cTitle);
   else
   {
      HICON hIcon = NULL;

      if ( cIconName != NULL )
      {    hIcon = LoadImage (GetModuleHandle (NULL), cIconName, IMAGE_ICON, 0, 0, LR_DEFAULTSIZE | LR_LOADTRANSPARENT);
           if ( hIcon == NULL )
                hIcon = LoadImage (NULL, cIconName, IMAGE_ICON, 0, 0, LR_DEFAULTSIZE | LR_LOADFROMFILE | LR_LOADTRANSPARENT);
      }

      SendMessage(hwndToolTip, TTM_SETTITLE, (WPARAM) hIcon, (LPARAM) cTitle);

      if ( hIcon != NULL )
         DestroyIcon(hIcon);
   }
}


/*********************************************************************************************************************/


HB_FUNC ( HIDEWINDOW )
{
   ShowWindow ((HWND) HMG_parnl (1), SW_HIDE);
}


HB_FUNC ( SETFOCUS )
{
   HWND hWnd = SetFocus( (HWND) HMG_parnl (1) );
   HMG_retnl ((LONG_PTR) hWnd );
}


/*********************************************************************************************************************/


HB_FUNC ( SETSPINNERVALUE )
{
   SendMessage( (HWND) HMG_parnl (1), (UINT) UDM_SETPOS32, (WPARAM) 0, (LPARAM) hb_parni (2) );
}

HB_FUNC ( GETSPINNERVALUE )
{
   hb_retnl ( SendMessage ( (HWND) HMG_parnl (1), (UINT) UDM_GETPOS32, (WPARAM) 0, (LPARAM) 0 ) );
}

HB_FUNC ( INSERTTAB )
{

	keybd_event(
		VK_TAB	,	// virtual-key code
		0,		// hardware scan code
		0,		// flags specifying various function options
		0		// additional data associated with keystroke
	);

}

HB_FUNC ( INSERTSHIFTTAB )
{

	keybd_event(
		VK_SHIFT,	// virtual-key code
		0,		// hardware scan code
		0,		// flags specifying various function options
		0		// additional data associated with keystroke
	);

	keybd_event(
		VK_TAB	,	// virtual-key code
		0,		// hardware scan code
		0,		// flags specifying various function options
		0		// additional data associated with keystroke
	);

	keybd_event(
		VK_SHIFT,	// virtual-key code
		0,		// hardware scan code
		KEYEVENTF_KEYUP,// flags specifying various function options
		0		// additional data associated with keystroke
	);

}



HB_FUNC ( RELEASECONTROL )
{
   SendMessage( (HWND) HMG_parnl (1), WM_SYSCOMMAND , (WPARAM) SC_CLOSE , 0 ) ;
}


HB_FUNC ( INSERTBACKSPACE )
{

	keybd_event(
		VK_BACK	,	// virtual-key code
		0,		// hardware scan code
		0,		// flags specifying various function options
		0		// additional data associated with keystroke
	);

}

HB_FUNC ( INSERTPOINT )
{

	keybd_event(
		VK_DECIMAL		,	// virtual-key code
		0,		// hardware scan code
		0,		// flags specifying various function options
		0		// additional data associated with keystroke
	);

}



HB_FUNC (SETCURSORPOS)
{
   SetCursorPos( hb_parni( 1 ), hb_parni( 2 ) );
}

HB_FUNC (SHOWCURSOR)
{
   hb_retni( ShowCursor( hb_parl( 1 ) ) );
}



HB_FUNC( SYSTEMPARAMETERSINFO )
{
   if( SystemParametersInfo ((UINT) hb_parni(1), (UINT) hb_parni(2), (VOID *) HMG_parc(3), (UINT) hb_parni(4)))
      hb_retl( TRUE );
   else
      hb_retl( FALSE );
}


HB_FUNC( GETTEXTWIDTH )  // returns the Width of a string in pixels
{
   HDC   hDC         = (HDC)    HMG_parnl (1);
   TCHAR *Text       = (TCHAR*) HMG_parc  (2);
   HFONT hFont       = (HFONT)  HMG_parnl (3);
   HWND  hWnd = NULL ;
   HFONT hOldFont = NULL;
   BOOL  bDestroyDC = FALSE;
   SIZE sz;

   if ( hDC == NULL )
   {
      bDestroyDC = TRUE;
      hWnd = GetActiveWindow();
      hDC = GetDC( hWnd );
   }

   if ( hFont )
      hOldFont = ( HFONT ) SelectObject( hDC, hFont );

   GetTextExtentPoint32( hDC, Text, lstrlen (Text), &sz );

   if ( hFont )
      SelectObject( hDC, hOldFont );

   if ( bDestroyDC )
       ReleaseDC( hWnd, hDC );

   hb_retni ((INT) sz.cx );
}


HB_FUNC( GETTEXTHEIGHT )  // returns the Height of a string in pixels
{
   HDC   hDC         = (HDC)    HMG_parnl (1);
   TCHAR *Text       = (TCHAR*) HMG_parc  (2);
   HFONT hFont       = (HFONT)  HMG_parnl (3);
   HWND  hWnd = NULL ;
   HFONT hOldFont = NULL;
   BOOL  bDestroyDC = FALSE;
   SIZE sz;

   if ( hDC == NULL )
   {
      bDestroyDC = TRUE;
      hWnd = GetActiveWindow();
      hDC = GetDC( hWnd );
   }

   if ( hFont )
      hOldFont = ( HFONT ) SelectObject( hDC, hFont );

   GetTextExtentPoint32( hDC, Text, lstrlen (Text), &sz );

   if ( hFont )
      SelectObject( hDC, hOldFont );

   if ( bDestroyDC )
       ReleaseDC( hWnd, hDC );

   hb_retni ((INT) sz.cy );
}


HB_FUNC ( KEYBD_EVENT )
{

	keybd_event(
		hb_parni(1),				// virtual-key code
		MapVirtualKey( hb_parni(1), 0 ),	// hardware scan code
		hb_parl(2) ? KEYEVENTF_KEYUP: 0,	// flags specifying various function options
		0					// additional data associated with keystroke
	);

}

HB_FUNC ( INSERTRETURN )
{

	keybd_event(
		VK_RETURN	, // virtual-key code
		0,		// hardware scan code
		0,		// flags specifying various function options
		0		// additional data associated with keystroke
	);

}


// Pablo César (January 2015)

#define VK_Z    90

HB_FUNC( INSERTCONTROLZ )
{
    keybd_event(
        VK_CONTROL, // virtual-key code
        0,          // hardware scan code
        0,          // flags specifying various function options
        0           // additional data associated with keystroke
    );

    keybd_event(
        VK_Z,   // virtual-key code
        0,      // hardware scan code
        0,      // flags specifying various function options
        0       // additional data associated with keystroke
    );

    keybd_event(
        VK_CONTROL,      // virtual-key code
        0,               // hardware scan code
        KEYEVENTF_KEYUP, // flags specifying various function options
        0                // additional data associated with keystroke
    );
}


HB_FUNC ( GETSHOWCMD )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   WINDOWPLACEMENT WP;
   WP.length = sizeof(WINDOWPLACEMENT) ;
   GetWindowPlacement ((HWND) hWnd, &WP) ;
   hb_retni ((INT) WP.showCmd);
}

HB_FUNC( GETPROGRAMFILENAME )
{
   TCHAR Buffer [ MAX_PATH + 1 ];
   GetModuleFileName ( GetModuleHandle(NULL), Buffer, MAX_PATH ) ;
   HMG_retc (Buffer);
}


HB_FUNC( GETMODULEFILENAME )
{
   TCHAR szBuffer [ MAX_PATH + 1 ];
   HMODULE hModule = HB_ISNIL(1) ? GetModuleHandle(NULL) : (HMODULE) HMG_parnl (1);
   GetModuleFileName (hModule, szBuffer, MAX_PATH);
   HMG_retc(szBuffer);
}


///////////////////////////////////////////////////////////////////////////////
// LOW LEVEL C PRINT ROUTINES
///////////////////////////////////////////////////////////////////////////////


#include <windows.h>
#include <stdio.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include <winuser.h>
#include <wingdi.h>
#include "commctrl.h"
#include "olectl.h"


HB_FUNC ( _HMG_PRINTER_STARTDOC )
{
   DOCINFO docInfo;
   HDC hdcPrint = (HDC) HMG_parnl (1);

   if ( hdcPrint != 0 )
   {
      ZeroMemory ( &docInfo, sizeof(docInfo) );
      docInfo.cbSize = sizeof (docInfo);
      docInfo.lpszDocName = (TCHAR *) HMG_parc(2);

      hb_retni ( StartDoc(hdcPrint, &docInfo) );
   }
}


HB_FUNC ( _HMG_PRINTER_STARTPAGE )
{
   HDC hdcPrint = (HDC) HMG_parnl (1);
   if ( hdcPrint != 0 )
      hb_retni ( StartPage(hdcPrint) );
}


HB_FUNC ( _HMG_PRINTER_ENDPAGE )
{
   HDC hdcPrint = (HDC) HMG_parnl (1);
   if ( hdcPrint != 0 )
      hb_retni ( EndPage(hdcPrint) );
}


HB_FUNC ( _HMG_PRINTER_ENDDOC )
{
   HDC hdcPrint = (HDC) HMG_parnl (1);
   if ( hdcPrint != 0 )
      hb_retni ( EndDoc(hdcPrint) );
}


HB_FUNC ( _HMG_PRINTER_ABORTDOC )
{
   HDC hdcPrint = (HDC) HMG_parnl (1);
   if ( hdcPrint != 0 )
      hb_retni ( AbortDoc(hdcPrint) );
}


HB_FUNC ( _HMG_PRINTER_DELETEDC )
{
   HDC hdcPrint = (HDC) HMG_parnl (1);
   if ( hdcPrint != 0 )
      DeleteDC(hdcPrint);
}



HB_FUNC ( _HMG_PRINTER_C_PRINT )
{

	// 1:  Hdc
	// 2:  y
	// 3:  x
	// 4:  FontName
	// 5:  FontSize
	// 6:  R Color
	// 7:  G Color
	// 8:  B Color
	// 9:  Text
	// 10: Bold
	// 11: Italic
	// 12: Underline
	// 13: StrikeOut
	// 14: Color Flag
	// 15: FontName Flag
	// 16: FontSize Flag
   // 17: Orientation (Angle 0 to 360º)

	HGDIOBJ hgdiobj ;

	TCHAR FontName [32] ;
	int FontSize ;

	DWORD fdwItalic ;
	DWORD fdwUnderline ;
	DWORD fdwStrikeOut ;

	int fnWeight ;
	int r ;
	int g ;
	int b ;

	int x = hb_parni(3) ;
	int y = hb_parni(2) ;

	HFONT hfont ;

	HDC hdcPrint = (HDC) HMG_parnl (1);

	int FontHeight ;

	if ( hdcPrint != 0 )
	{

		// Bold

		if ( hb_parl(10) )
		{
			fnWeight = FW_BOLD ;
		}
		else
		{
			fnWeight = FW_NORMAL ;
		}

		// Italic

		if ( hb_parl(11) )
		{
			fdwItalic = TRUE ;
		}
		else
		{
			fdwItalic = FALSE ;
		}

		// UnderLine

		if ( hb_parl(12) )
		{
			fdwUnderline = TRUE ;
		}
		else
		{
			fdwUnderline = FALSE ;
		}

		// StrikeOut

		if ( hb_parl(13) )
		{
			fdwStrikeOut = TRUE ;
		}
		else
		{
			fdwStrikeOut = FALSE ;
		}

		// Color

		if ( hb_parl(14) )
		{
			r = hb_parni(6) ;
			g = hb_parni(7) ;
			b = hb_parni(8) ;
		}
		else
		{
			r = 0 ;
			g = 0 ;
			b = 0 ;
		}

		// Fontname

		if ( hb_parl(15) )
		{
			lstrcpy ( FontName , HMG_parc(4) ) ;
		}
		else
		{
			lstrcpy( FontName , _TEXT("Arial") ) ;
		}

		// FontSize

		if ( hb_parl(16) )
		{
			FontSize = hb_parni(5) ;
		}
		else
		{
			FontSize = 10 ;
		}

		FontHeight = -MulDiv ( FontSize , GetDeviceCaps ( hdcPrint , LOGPIXELSY ) , 72 ) ;

   double Orientation = (double) hb_parnd (17);

   if ((Orientation < (double) -360.0) || (Orientation > (double) 360.0))
       Orientation = (double) 0.0;

   Orientation = Orientation * (double) 10.0;   // Angle in tenths of degrees


		hfont = CreateFont
			(
			FontHeight,
			0,
			(int)Orientation, (int)Orientation,
			fnWeight ,
			fdwItalic ,
			fdwUnderline ,
			fdwStrikeOut ,
			DEFAULT_CHARSET,
			OUT_TT_PRECIS,
			CLIP_DEFAULT_PRECIS,
			DEFAULT_QUALITY,
			FF_DONTCARE,
			FontName
			);

		hgdiobj = SelectObject ( hdcPrint , hfont ) ;

		SetTextColor( hdcPrint , RGB ( r , g , b ) ) ;
		SetBkMode( hdcPrint , TRANSPARENT );

		TextOut( hdcPrint ,
			( x * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ,
			( y * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY ) ,
			HMG_parc(9),
			lstrlen(HMG_parc(9)) ) ;

		SelectObject ( hdcPrint , hgdiobj ) ;

		DeleteObject ( hfont ) ;

	}

}

HB_FUNC ( _HMG_PRINTER_C_MULTILINE_PRINT )
{

	// 1:  Hdc
	// 2:  y
	// 3:  x
	// 4:  FontName
	// 5:  FontSize
	// 6:  R Color
	// 7:  G Color
	// 8:  B Color
	// 9:  Text
	// 10: Bold
	// 11: Italic
	// 12: Underline
	// 13: StrikeOut
	// 14: Color Flag
	// 15: FontName Flag
	// 16: FontSize Flag
	// 17: ToRow
	// 18: ToCol
	// 19: Alignment

	UINT uFormat = 0 ;

	HGDIOBJ hgdiobj ;

	TCHAR FontName [32] ;
	int FontSize ;

	DWORD fdwItalic ;
	DWORD fdwUnderline ;
	DWORD fdwStrikeOut ;

	RECT rect ;

	int fnWeight ;
	int r ;
	int g ;
	int b ;

	int x = hb_parni(3) ;
	int y = hb_parni(2) ;
	int toy = hb_parni(17) ;
	int tox = hb_parni(18) ;

	HFONT hfont ;

	HDC hdcPrint = (HDC) HMG_parnl (1);

	int FontHeight ;

	if ( hdcPrint != 0 )
	{

		// Bold

		if ( hb_parl(10) )
		{
			fnWeight = FW_BOLD ;
		}
		else
		{
			fnWeight = FW_NORMAL ;
		}

		// Italic

		if ( hb_parl(11) )
		{
			fdwItalic = TRUE ;
		}
		else
		{
			fdwItalic = FALSE ;
		}

		// UnderLine

		if ( hb_parl(12) )
		{
			fdwUnderline = TRUE ;
		}
		else
		{
			fdwUnderline = FALSE ;
		}

		// StrikeOut

		if ( hb_parl(13) )
		{
			fdwStrikeOut = TRUE ;
		}
		else
		{
			fdwStrikeOut = FALSE ;
		}

		// Color

		if ( hb_parl(14) )
		{
			r = hb_parni(6) ;
			g = hb_parni(7) ;
			b = hb_parni(8) ;
		}
		else
		{
			r = 0 ;
			g = 0 ;
			b = 0 ;
		}

		// Fontname

		if ( hb_parl(15) )
		{
			lstrcpy ( FontName , HMG_parc(4) ) ;
		}
		else
		{
			lstrcpy( FontName , _TEXT("Arial") ) ;
		}

		// FontSize

		if ( hb_parl(16) )
		{
			FontSize = hb_parni(5) ;
		}
		else
		{
			FontSize = 10 ;
		}

		FontHeight = -MulDiv ( FontSize , GetDeviceCaps ( hdcPrint , LOGPIXELSY ) , 72 ) ;

		hfont = CreateFont
			(
			FontHeight,
			0,
			0,
			0,
			fnWeight ,
			fdwItalic ,
			fdwUnderline ,
			fdwStrikeOut ,
			DEFAULT_CHARSET,
			OUT_TT_PRECIS,
			CLIP_DEFAULT_PRECIS,
			DEFAULT_QUALITY,
			FF_DONTCARE,
			FontName
			);

		if ( hb_parni(19) == 0 )
		{
			uFormat = DT_END_ELLIPSIS | DT_NOPREFIX | DT_WORDBREAK | DT_LEFT ;
		}
		else if ( hb_parni(19) == 2 )
		{
			uFormat = DT_END_ELLIPSIS | DT_NOPREFIX | DT_WORDBREAK | DT_RIGHT ;
		}
		else if ( hb_parni(19) == 6 )
		{
			uFormat = DT_END_ELLIPSIS | DT_NOPREFIX | DT_WORDBREAK | DT_CENTER ;
		}

		hgdiobj = SelectObject ( hdcPrint , hfont ) ;

		SetTextColor( hdcPrint , RGB ( r , g , b ) ) ;
		SetBkMode( hdcPrint , TRANSPARENT );

		rect.left	= ( x * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ;
		rect.top	= ( y * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY )  ;
		rect.right	= ( tox * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ;
		rect.bottom	= ( toy * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY ) ;

		DrawText ( hdcPrint ,
			HMG_parc(9),
			lstrlen(HMG_parc(9)),
			&rect ,
			uFormat
			) ;


		SelectObject ( hdcPrint , hgdiobj ) ;

		DeleteObject ( hfont ) ;

	}

}


HB_FUNC ( _HMG_PRINTER_PRINTDIALOG )
{
   PRINTDLG pd ;
   LPDEVMODE   pDevMode;

   pd.lStructSize = sizeof(PRINTDLG);
   pd.hDevMode = (HANDLE) NULL;
   pd.hDevNames = (HANDLE) NULL;
   pd.Flags = PD_RETURNDC | PD_PRINTSETUP ;
   pd.hwndOwner = NULL ;
   pd.hDC = NULL;
   pd.nFromPage = 1;
   pd.nToPage = 1;
   pd.nMinPage = 0;
   pd.nMaxPage = 0;
   pd.nCopies = 1;
   pd.hInstance = (HANDLE) NULL;
   pd.lCustData = 0L;
   pd.lpfnPrintHook = (LPPRINTHOOKPROC) NULL;
   pd.lpfnSetupHook = (LPSETUPHOOKPROC) NULL;
   pd.lpPrintTemplateName = NULL;
   pd.lpSetupTemplateName = NULL;
   pd.hPrintTemplate = (HANDLE) NULL;
   pd.hSetupTemplate = (HANDLE) NULL;

   if ( PrintDlg(&pd) )
   {
      pDevMode = (LPDEVMODE) GlobalLock(pd.hDevMode);

      hb_reta (4);
      HMG_storvnl ((LONG_PTR) pd.hDC,                      -1, 1 );
      HMG_storvc  ((const TCHAR *) pDevMode->dmDeviceName, -1, 2 );
      hb_storvni  ( pDevMode->dmCopies,                    -1, 3 );
      hb_storvni  ( pDevMode->dmCollate,                   -1, 4 );

      GlobalUnlock(pd.hDevMode);
   }
   else
   {
      hb_reta (4);
      hb_storvnl ( 0,         -1, 1 );
      HMG_storvc ( _TEXT(""), -1, 2 );
      hb_storvni ( 0,         -1, 3 );
      hb_storvni ( 0,         -1, 4 );
   }
}

HB_FUNC (APRINTERS)
{

	OSVERSIONINFO osvi ;

	BYTE *cBuffer ;
	BYTE *pBuffer ;

	DWORD dwSize = 0;
	DWORD dwPrinters = 0;
	DWORD i;

	PRINTER_INFO_4* pInfo4 = NULL ;
	PRINTER_INFO_5* pInfo = NULL ;

	osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);

	GetVersionEx(&osvi);

	if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
	{
		EnumPrinters(PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS , NULL,4, NULL, 0, &dwSize, &dwPrinters);
	}
	else
	{
		EnumPrinters(PRINTER_ENUM_LOCAL , NULL,5, NULL, 0, &dwSize, &dwPrinters);
	}

// pBuffer = GlobalAlloc(GPTR, dwSize);
   pBuffer = hb_xgrab( dwSize );
	if (pBuffer == NULL)
	{
		hb_reta(0);
		return;
	}

	if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
	{
		EnumPrinters( PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS , NULL,4, pBuffer, dwSize, &dwSize, &dwPrinters);
	}
	else
	{
		EnumPrinters( PRINTER_ENUM_LOCAL , NULL,5, pBuffer, dwSize, &dwSize, &dwPrinters);
	}

	if (dwPrinters == 0)
	{
		hb_reta(0);
		return;
	}

// cBuffer = GlobalAlloc(GPTR, dwPrinters*256);
   cBuffer = hb_xgrab( dwPrinters * 256 );
	if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
	{
		pInfo4 = (PRINTER_INFO_4*)pBuffer;
	}
	else
	{
		pInfo = (PRINTER_INFO_5*)pBuffer;
	}

	hb_reta( dwPrinters );

	if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
	{
		for ( i = 0; i < dwPrinters; i++, pInfo4++)
		{
			HMG_storvc(  pInfo4->pPrinterName , -1 , i+1 );
		}
	}
	else
	{
		for ( i = 0; i < dwPrinters; i++, pInfo++)
		{
			HMG_storvc(  pInfo->pPrinterName , -1 , i+1 );
		}
	}

// GlobalFree(pBuffer);
// GlobalFree(cBuffer);
   hb_xfree (pBuffer);
   hb_xfree (cBuffer);
}

HB_FUNC ( _HMG_PRINTER_C_RECTANGLE )
{

	// 1: hDC
	// 2: y
	// 3: x
	// 4: toy
	// 5: tox
	// 6: width
	// 7: R Color
	// 8: G Color
	// 9: B Color
	// 10: lWindth
	// 11: lColor
	// 12: lfilled

	int r ;
	int g ;
	int b ;

	int x = hb_parni(3) ;
	int y = hb_parni(2) ;

	int tox = hb_parni(5) ;
	int toy = hb_parni(4) ;

	int width ;

	HDC hdcPrint = (HDC) HMG_parnl (1);
	HGDIOBJ hgdiobj;
	HPEN hpen = NULL;
	HBRUSH hbrush = NULL;

	if ( hdcPrint != 0 )
	{

		// Width

		if ( hb_parl(10) )
		{
			width = hb_parni(6) ;
		}
		else
		{
			width = 1 * 10000 / 254 ;
		}

		// Color

		if ( hb_parl(11) )
		{
			r = hb_parni(7) ;
			g = hb_parni(8) ;
			b = hb_parni(9) ;
		}
		else
		{
			r = 0 ;
			g = 0 ;
			b = 0 ;
		}

		if (hb_parl(12) )
		{
			hbrush = CreateSolidBrush((COLORREF) RGB((int) r,(int) g,(int) b));
			hgdiobj = SelectObject( hdcPrint , hbrush );
        }
        else
        {
			hpen = CreatePen( (int) PS_SOLID, ( width * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ), (COLORREF) RGB( r , g , b ) );
			hgdiobj = SelectObject( hdcPrint , hpen );
	    }

		Rectangle( hdcPrint ,
			( x * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ,
			( y * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY ) ,
			( tox * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ,
			( toy * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY )
			);

		SelectObject( hdcPrint , (HGDIOBJ) hgdiobj );

		DeleteObject( hpen );
		DeleteObject( hbrush );


	}

}

HB_FUNC ( _HMG_PRINTER_C_ROUNDRECTANGLE )
{

	// 1: hDC
	// 2: y
	// 3: x
	// 4: toy
	// 5: tox
	// 6: width
	// 7: R Color
	// 8: G Color
	// 9: B Color
	// 10: lWindth
	// 11: lColor
	// 12: lfilled

	int r ;
	int g ;
	int b ;

	int x = hb_parni(3) ;
	int y = hb_parni(2) ;

	int tox = hb_parni(5) ;
	int toy = hb_parni(4) ;

	int width ;

	int w , h , p ;

	HDC hdcPrint = (HDC) HMG_parnl (1);
	HGDIOBJ hgdiobj;
	HPEN hpen = NULL;
	HBRUSH hbrush = NULL;

	if ( hdcPrint != 0 )
	{

		// Width

		if ( hb_parl(10) )
		{
			width = hb_parni(6) ;
		}
		else
		{
			width = 1 * 10000 / 254 ;
		}

		// Color

		if ( hb_parl(11) )
		{
			r = hb_parni(7) ;
			g = hb_parni(8) ;
			b = hb_parni(9) ;
		}
		else
		{
			r = 0 ;
			g = 0 ;
			b = 0 ;
		}
		if ( hb_parl(12) )
		{
			hbrush = CreateSolidBrush((COLORREF) RGB((int) r,(int) g,(int) b));
			hgdiobj = SelectObject( hdcPrint , hbrush );
	    }
		else
		{
		   hpen = CreatePen( (int) PS_SOLID, ( width * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ), (COLORREF) RGB( r , g , b ) );

		   hgdiobj = SelectObject( hdcPrint , hpen );
	    }

		w = ( tox * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - ( x * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) ;
		h = ( toy * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - ( y * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) ;
		p = ( w + h ) / 2 ;
		p = p / 10 ;

		RoundRect( hdcPrint ,
			( x * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ,
			( y * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY ) ,
			( tox * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ,
			( toy * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY ) ,
			p ,
			p
			) ;

		SelectObject( hdcPrint , (HGDIOBJ) hgdiobj );

		DeleteObject( hpen );
		DeleteObject( hbrush );

	}

}

HB_FUNC ( _HMG_PRINTER_C_LINE )
{

	// 1: hDC
	// 2: y
	// 3: x
	// 4: toy
	// 5: tox
	// 6: width
	// 7: R Color
	// 8: G Color
	// 9: B Color
	// 10: lWindth
	// 11: lColor

	int r ;
	int g ;
	int b ;

	int x = hb_parni(3) ;
	int y = hb_parni(2) ;

	int tox = hb_parni(5) ;
	int toy = hb_parni(4) ;

	int width ;

	HDC hdcPrint = (HDC) HMG_parnl (1);
	HGDIOBJ hgdiobj;
	HPEN hpen;

	if ( hdcPrint != 0 )
	{

		// Width

		if ( hb_parl(10) )
		{
			width = hb_parni(6) ;
		}
		else
		{
			width = 1 * 10000 / 254 ;
		}

		// Color

		if ( hb_parl(11) )
		{
			r = hb_parni(7) ;
			g = hb_parni(8) ;
			b = hb_parni(9) ;
		}
		else
		{
			r = 0 ;
			g = 0 ;
			b = 0 ;
		}

		hpen = CreatePen( (int) PS_SOLID, ( width * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ), (COLORREF) RGB( r , g , b ) );

		hgdiobj = SelectObject( hdcPrint , hpen );

		MoveToEx( hdcPrint ,
			( x * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ,
			( y * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY ) ,
			NULL
			);

		LineTo ( hdcPrint ,
			( tox * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ,
			( toy * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY )
			);

		SelectObject( hdcPrint , (HGDIOBJ) hgdiobj );

		DeleteObject( hpen );

	}

}

HB_FUNC ( _HMG_PRINTER_SETPRINTERPROPERTIES )
{
	HANDLE hPrinter = NULL;
	DWORD dwNeeded = 0;
	PRINTER_INFO_2 *pi2 ;
	DEVMODE *pDevMode = NULL;
	BOOL bFlag;
	LONG lFlag;

	HDC hdcPrint ;

	int fields = 0 ;

	bFlag = OpenPrinter( (LPTSTR)HMG_parc(1) , &hPrinter, NULL);
    // bFlag = OpenPrinter(NULL , &hPrinter, NULL);

	if (!bFlag || (hPrinter == NULL))
	{
		MessageBox(0, _TEXT("Printer Configuration Failed! (001)"), _TEXT("Error!"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

		hb_reta( 4 );
		hb_storvnl	( 0 	, -1, 1 );
		HMG_storvc	( _TEXT(""), -1, 2 );
		hb_storvni	( 0	, -1, 3 );
		hb_storvni	( 0	, -1, 4 );

		return;
	}

	SetLastError(0);

	bFlag = GetPrinter(hPrinter, 2, 0, 0, &dwNeeded);

   // if ((!bFlag) && (GetLastError() != ERROR_INSUFFICIENT_BUFFER) || (dwNeeded == 0))
   if( (! bFlag) && ((GetLastError() != ERROR_INSUFFICIENT_BUFFER) || (dwNeeded == 0)) )    // ADD parentheses ---> is correct ???
	{
		ClosePrinter(hPrinter);
		MessageBox(0, _TEXT("Printer Configuration Failed! (002)"), _TEXT("Error!"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

		hb_reta( 4 );
		hb_storvnl	( 0 	, -1, 1 );
		HMG_storvc	( _TEXT("")	, -1, 2 );
		hb_storvni	( 0	, -1, 3 );
		hb_storvni	( 0	, -1, 4 );

		return;
	}

// pi2 = (PRINTER_INFO_2 *)GlobalAlloc(GPTR, dwNeeded);
   pi2 = (PRINTER_INFO_2 *) hb_xgrab( dwNeeded );

	if (pi2 == NULL)
	{
		ClosePrinter(hPrinter);
		MessageBox(0, _TEXT("Printer Configuration Failed! (003)"), _TEXT("Error!"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

		hb_reta( 4 );
		hb_storvnl	( 0 	, -1, 1 );
		HMG_storvc	( _TEXT(""), -1, 2 );
		hb_storvni	( 0	, -1, 3 );
		hb_storvni	( 0	, -1, 4 );

		return;
	}

	bFlag = GetPrinter(hPrinter, 2, (LPBYTE)pi2, dwNeeded, &dwNeeded);

	if (!bFlag)
	{
		hb_xfree(pi2);
		ClosePrinter(hPrinter);
		MessageBox(0, _TEXT("Printer Configuration Failed! (004)"), _TEXT("Error!"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

		hb_reta( 4 );
		hb_storvnl	( 0 	, -1, 1 );
		HMG_storvc	( _TEXT(""), -1, 2 );
		hb_storvni	( 0	, -1, 3 );
		hb_storvni	( 0	, -1, 4 );

		return;
	}

	if (pi2->pDevMode == NULL)
	{
		dwNeeded = DocumentProperties(NULL, hPrinter, (LPTSTR)HMG_parc(1), NULL, NULL, 0);
		if (dwNeeded <= 0)
		{
			hb_xfree(pi2);
			ClosePrinter(hPrinter);
			MessageBox(0, _TEXT("Printer Configuration Failed! (005)"), _TEXT("Error!"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_storvnl	( 0 	, -1, 1 );
			HMG_storvc	( _TEXT(""), -1, 2 );
			hb_storvni	( 0	, -1, 3 );
			hb_storvni	( 0	, -1, 4 );

			return;
		}

//    pDevMode = (DEVMODE *)GlobalAlloc(GPTR, dwNeeded);
      pDevMode = (DEVMODE *) hb_xgrab ( dwNeeded );
		if (pDevMode == NULL)
		{
			hb_xfree(pi2);
			ClosePrinter(hPrinter);
			MessageBox(0, _TEXT("Printer Configuration Failed! (006)"), _TEXT("Error! (006)"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_storvnl	( 0 	, -1, 1 );
			HMG_storvc	( _TEXT(""), -1, 2 );
			hb_storvni	( 0	, -1, 3 );
			hb_storvni	( 0	, -1, 4 );

			return;
		}

		lFlag = DocumentProperties(NULL, hPrinter, (LPTSTR)HMG_parc(1), pDevMode, NULL,DM_OUT_BUFFER);
		if (lFlag != IDOK || pDevMode == NULL)
		{
			hb_xfree(pDevMode);
			hb_xfree(pi2);
			ClosePrinter(hPrinter);
			MessageBox(0, _TEXT("Printer Configuration Failed! (007)"), _TEXT("Error!"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_storvnl	( 0 	, -1, 1 );
			HMG_storvc	( _TEXT(""), -1, 2 );
			hb_storvni	( 0	, -1, 3 );
			hb_storvni	( 0	, -1, 4 );

			return;
		}

		pi2->pDevMode = pDevMode;
	}

	///////////////////////////////////////////////////////////////////////
	// Specify Fields
	//////////////////////////////////////////////////////////////////////
	// Orientation
	if ( hb_parni(2) != -999 )
	{
		fields = fields | DM_ORIENTATION ;
	}

	// PaperSize
	if ( hb_parni(3) != -999 )
	{
		fields = fields | DM_PAPERSIZE ;
	}

	// PaperLength
	if ( hb_parni(4) != -999 )
	{
		fields = fields | DM_PAPERLENGTH ;
	}

	// PaperWidth
	if ( hb_parni(5) != -999 )
	{
		fields = fields | DM_PAPERWIDTH	 ;
	}

	// Copies
	if ( hb_parni(6) != -999 )
	{
		fields = fields | DM_COPIES ;
	}

	// Default Source
	if ( hb_parni(7) != -999 )
	{
		fields = fields | DM_DEFAULTSOURCE ;
	}

	// Print Quality
	if ( hb_parni(8) != -999 )
	{
		fields = fields | DM_PRINTQUALITY ;
	}

	// Print Color
	if ( hb_parni(9) != -999 )
	{
		fields = fields | DM_COLOR ;
	}

	// Print Duplex Mode
	if ( hb_parni(10) != -999 )
	{
		fields = fields | DM_DUPLEX ;
	}

	// Print Collate
	if ( hb_parni(11) != -999 )
	{
		fields = fields | DM_COLLATE ;
	}

	pi2->pDevMode->dmFields = fields ;

	///////////////////////////////////////////////////////////////////////
	// Load Fields
	//////////////////////////////////////////////////////////////////////
	// Orientation
	if ( hb_parni(2) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_ORIENTATION))
		{
			MessageBox(0, _TEXT("Printer Configuration Failed: ORIENTATION Property Not Supported By Selected Printer"), _TEXT("Error!"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_storvnl	( 0 	, -1, 1 );
			HMG_storvc	( _TEXT(""), -1, 2 );
			hb_storvni	( 0	, -1, 3 );
			hb_storvni	( 0	, -1, 4 );

			return;
		}

		pi2->pDevMode->dmOrientation = (short) hb_parni(2);
	}

	// PaperSize
	if ( hb_parni(3) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_PAPERSIZE ))
		{
			MessageBox(0, _TEXT("Printer Configuration Failed: PAPERSIZE Property Not Supported By Selected Printer"), _TEXT("Error!"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_storvnl	( 0 	, -1, 1 );
			HMG_storvc	( _TEXT(""), -1, 2 );
			hb_storvni	( 0	, -1, 3 );
			hb_storvni	( 0	, -1, 4 );

			return;
		}

		pi2->pDevMode->dmPaperSize = (short) hb_parni(3);
	}

	// PaperLength
	if ( hb_parni(4) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_PAPERLENGTH ))
		{
			MessageBox(0, _TEXT("Printer Configuration Failed: PAPERLENGTH Property Not Supported By Selected Printer"), _TEXT("Error!"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_storvnl	( 0 	, -1, 1 );
			HMG_storvc	( _TEXT(""), -1, 2 );
			hb_storvni	( 0	, -1, 3 );
			hb_storvni	( 0	, -1, 4 );

			return;
		}

		pi2->pDevMode->dmPaperLength = (short) hb_parni(4) * 10 ;
	}

	// PaperWidth
	if ( hb_parni(5) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_PAPERWIDTH))
		{
			MessageBox(0, _TEXT("Printer Configuration Failed: PAPERWIDTH Property Not Supported By Selected Printer"), _TEXT("Error!"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_storvnl	( 0 	, -1, 1 );
			HMG_storvc	( _TEXT(""), -1, 2 );
			hb_storvni	( 0	, -1, 3 );
			hb_storvni	( 0	, -1, 4 );

			return;
		}

		pi2->pDevMode->dmPaperWidth = (short) hb_parni(5) * 10 ;
	}

	// Copies
	if ( hb_parni(6) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_COPIES ))
		{
			MessageBox(0, _TEXT("Printer Configuration Failed: COPIES Property Not Supported By Selected Printer"), _TEXT("Error!"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_storvnl	( 0 	, -1, 1 );
			HMG_storvc	( _TEXT(""), -1, 2 );
			hb_storvni	( 0	, -1, 3 );
			hb_storvni	( 0	, -1, 4 );

			return;
		}

		pi2->pDevMode->dmCopies = (short) hb_parni(6);
	}

	// Default Source
	if ( hb_parni(7) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_DEFAULTSOURCE ))
		{
			MessageBox(0, _TEXT("Printer Configuration Failed: DEFAULTSOURCE Property Not Supported By Selected Printer"), _TEXT("Error!"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_storvnl	( 0 	, -1, 1 );
			HMG_storvc	( _TEXT(""), -1, 2 );
			hb_storvni	( 0	, -1, 3 );
			hb_storvni	( 0	, -1, 4 );

			return;
		}

		pi2->pDevMode->dmDefaultSource = (short) hb_parni(7);
	}

	// Print Quality
	if ( hb_parni(8) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_PRINTQUALITY ))
		{
			MessageBox(0, _TEXT("Printer Configuration Failed: QUALITY Property Not Supported By Selected Printer"), _TEXT("Error!"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_storvnl	( 0 	, -1, 1 );
			HMG_storvc	( _TEXT(""), -1, 2 );
			hb_storvni	( 0	, -1, 3 );
			hb_storvni	( 0	, -1, 4 );

			return;
		}

		pi2->pDevMode->dmPrintQuality = (short) hb_parni(8);
	}

	// Print Color
	if ( hb_parni(9) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_COLOR ))
		{
			MessageBox(0, _TEXT("Printer Configuration Failed: COLOR Property Not Supported By Selected Printer"), _TEXT("Error!"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_storvnl	( 0 	, -1, 1 );
			HMG_storvc	( _TEXT(""), -1, 2 );
			hb_storvni	( 0	, -1, 3 );
			hb_storvni	( 0	, -1, 4 );

			return;
		}

		pi2->pDevMode->dmColor = (short) hb_parni(9);
	}

	// Print Duplex
	if ( hb_parni(10) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_DUPLEX ))
		{
			MessageBox(0, _TEXT("Printer Configuration Failed: DUPLEX Property Not Supported By Selected Printer"), _TEXT("Error!"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_storvnl	( 0 	, -1, 1 );
			HMG_storvc	( _TEXT(""), -1, 2 );
			hb_storvni	( 0	, -1, 3 );
			hb_storvni	( 0	, -1, 4 );

			return;
		}

		pi2->pDevMode->dmDuplex = (short) hb_parni(10);
	}

	// Print Collate
	if ( hb_parni(11) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_COLLATE ))
		{
			MessageBox(0, _TEXT("Printer Configuration Failed: COLLATE Property Not Supported By Selected Printer"), _TEXT("Error!"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_storvnl	( 0 	, -1, 1 );
			HMG_storvc	( _TEXT(""), -1, 2 );
			hb_storvni	( 0	, -1, 3 );
			hb_storvni	( 0	, -1, 4 );

			return;
		}

		pi2->pDevMode->dmCollate = (short) hb_parni(11);
	}

	//////////////////////////////////////////////////////////////////////

	pi2->pSecurityDescriptor = NULL;

	lFlag = DocumentProperties(NULL, hPrinter, (LPTSTR)HMG_parc(1), pi2->pDevMode, pi2->pDevMode,DM_IN_BUFFER | DM_OUT_BUFFER);

	if (lFlag != IDOK)
	{
		hb_xfree(pi2);
		ClosePrinter(hPrinter);
		if (pDevMode)
		{
			hb_xfree(pDevMode);
		}
		MessageBox(0, _TEXT("Printer Configuration Failed! (008)"), _TEXT("Error!"),MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

		hb_reta( 4 );
		hb_storvnl	( 0 	, -1, 1 );
		HMG_storvc	( _TEXT(""), -1, 2 );
		hb_storvni	( 0	, -1, 3 );
		hb_storvni	( 0	, -1, 4 );

		return;
	}

	hdcPrint = CreateDC(NULL, HMG_parc(1), NULL, pi2->pDevMode);

	if ( hdcPrint != NULL )
	{
		hb_reta( 4 );
      HMG_storvnl ((LONG_PTR) hdcPrint, -1, 1 );
		HMG_storvc	( HMG_parc(1)			, -1, 2 );
		hb_storvni	( (INT) pi2->pDevMode->dmCopies	, -1, 3 );
		hb_storvni	( (INT) pi2->pDevMode->dmCollate, -1, 4 );
	}
	else
	{
		hb_reta( 4 );
		HMG_storvnl ((LONG_PTR) 0 , -1, 1 );
		HMG_storvc	( _TEXT(""), -1, 2 );
		hb_storvni	( 0	, -1, 3 );
		hb_storvni	( 0	, -1, 4 );
	}

	if (pi2)
	{
		hb_xfree(pi2);
	}

	if (hPrinter)
	{
		ClosePrinter(hPrinter);
	}

	if (pDevMode)
	{
		hb_xfree(pDevMode);
	}

}


HB_FUNC (GETDEFAULTPRINTER)
{

	OSVERSIONINFO osvi;
	LPPRINTER_INFO_5 PrinterInfo;
	DWORD Needed , Returned ;
	DWORD BufferSize = 254;

	TCHAR DefaultPrinter [254] ;

	osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);

	GetVersionEx(&osvi);

	if (osvi.dwPlatformId == VER_PLATFORM_WIN32_WINDOWS)
	{

		EnumPrinters(PRINTER_ENUM_DEFAULT,NULL,5,NULL,0,&Needed,&Returned);
		PrinterInfo = (LPPRINTER_INFO_5) LocalAlloc(LPTR,Needed);
		EnumPrinters(PRINTER_ENUM_DEFAULT,NULL,5,(LPBYTE) PrinterInfo,Needed,&Needed,&Returned);
		lstrcpy(DefaultPrinter,PrinterInfo->pPrinterName);
		LocalFree(PrinterInfo);

	}
	else if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
	{

		GetProfileString(_TEXT("windows"),_TEXT("device"),_TEXT(""),DefaultPrinter,BufferSize);
		// strtok(DefaultPrinter, ",");
      _tcstok (DefaultPrinter, _TEXT(","));

	}

	HMG_retc(DefaultPrinter);

}

HB_FUNC ( _HMG_PRINTER_STARTPAGE_PREVIEW )
{

	HDC tmpDC ;
	RECT emfrect ;

	SetRect(&emfrect,0,0,GetDeviceCaps( (HDC) HMG_parnl (1), HORZSIZE)*100 , GetDeviceCaps( (HDC) HMG_parnl (1), VERTSIZE)*100 ) ;

	tmpDC = CreateEnhMetaFile ( (HDC) HMG_parnl (1), HMG_parc(2) , &emfrect , _TEXT("") ) ;

	HMG_retnl ((LONG_PTR) tmpDC) ;

}

HB_FUNC ( _HMG_PRINTER_ENDPAGE_PREVIEW )
{
	DeleteEnhMetaFile(CloseEnhMetaFile( (HDC) HMG_parnl (1) ));
}


HB_FUNC ( _HMG_PRINTER_SHOWPAGE )
{
   HENHMETAFILE hEMF = GetEnhMetaFile ( HMG_parc(1) );
   HWND hWnd       = (HWND) HMG_parnl (2);
   HDC  hDCPrinter = (HDC)  HMG_parnl (3);
   HDC  hDC        = (HDC)  HMG_parnl (8);   // ADD, July 2015
   RECT Rect;

// hDC = GetDC (hWnd);   // REMOVE, July 2015

   GetClientRect (hWnd,&Rect);

   FillRect (hDC, &Rect, (HBRUSH) GetStockObject(GRAY_BRUSH));   // ADD April 2014

   int ClientWidth  = Rect.right  - Rect.left;
   int ClientHeight = Rect.bottom - Rect.left;

   int zw = hb_parni(5) * GetDeviceCaps (hDCPrinter, HORZSIZE) / 750 ;
   int zh = hb_parni(5) * GetDeviceCaps (hDCPrinter, VERTSIZE) / 750 ;

   int xOffset = ( ClientWidth -  ( GetDeviceCaps (hDCPrinter, HORZSIZE)  * hb_parni(4) / 10000 ) ) / 2 ;
   int yOffset = ( ClientHeight - ( GetDeviceCaps (hDCPrinter, VERTSIZE)  * hb_parni(4) / 10000 ) ) / 2 ;

   SetRect (&Rect,
   xOffset + hb_parni(6) - zw ,
   yOffset + hb_parni(7) - zh ,
   xOffset + ( GetDeviceCaps (hDCPrinter, HORZSIZE) * hb_parni(4) / 10000 ) + hb_parni(6) + zw ,
   yOffset + ( GetDeviceCaps (hDCPrinter, VERTSIZE) * hb_parni(4) / 10000 ) + hb_parni(7) + zh
   ) ;

   FillRect (hDC, &Rect, (HBRUSH) RGB(255,255,255));

   PlayEnhMetaFile (hDC, hEMF, &Rect);

   DeleteEnhMetaFile (hEMF);

// ReleaseDC (hWnd, hDC);   // REMOVE, July 2015

   // ADD April 2014
   hb_reta (4);
   hb_storvnl ((LONG) Rect.top,    -1, 1);
   hb_storvnl ((LONG) Rect.left,   -1, 2);
   hb_storvnl ((LONG) Rect.bottom, -1, 3);
   hb_storvnl ((LONG) Rect.right,  -1, 4);
}


HB_FUNC ( _HMG_PRINTER_GETPAGEWIDTH )
{
	hb_retni ( GetDeviceCaps( (HDC) HMG_parnl (1), HORZSIZE ) ) ;
}

HB_FUNC ( _HMG_PRINTER_GETPAGEHEIGHT )
{
	hb_retni ( GetDeviceCaps( (HDC) HMG_parnl (1), VERTSIZE ) ) ;
}

HB_FUNC ( _HMG_PRINTER_PRINTPAGE )
{

	HENHMETAFILE hEMF ;

	RECT rect ;

	hEMF = GetEnhMetaFile( HMG_parc(2) ) ;

	SetRect(&rect,0,0,GetDeviceCaps( (HDC) HMG_parnl (1), HORZRES), GetDeviceCaps( (HDC) HMG_parnl(1), VERTRES));

	StartPage( (HDC) HMG_parnl (1) );

	PlayEnhMetaFile( (HDC) HMG_parnl (1) , (HENHMETAFILE) hEMF , &rect ) ;

	EndPage( (HDC) HMG_parnl (1) );

	DeleteEnhMetaFile(hEMF);

}


HB_FUNC ( _HMG_PRINTER_PREVIEW_ENABLESCROLLBARS )
{
	EnableScrollBar( (HWND) HMG_parnl (1), SB_BOTH , ESB_ENABLE_BOTH ) ;
}

HB_FUNC ( _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS )
{
	EnableScrollBar( (HWND) HMG_parnl (1), SB_BOTH , ESB_DISABLE_BOTH ) ;
}

HB_FUNC ( _HMG_PRINTER_PREVIEW_DISABLEHSCROLLBAR )
{
	EnableScrollBar( (HWND) HMG_parnl (1), SB_HORZ , ESB_DISABLE_BOTH ) ;
}

HB_FUNC ( _HMG_PRINTER_SETVSCROLLVALUE )
{

	SendMessage ( (HWND) HMG_parnl (1), WM_VSCROLL , (WPARAM) MAKEWPARAM (SB_THUMBPOSITION , hb_parni(2) ) , 0 ) ;

}

HB_FUNC ( _HMG_PRINTER_SETHSCROLLVALUE )
{

	SendMessage ( (HWND) HMG_parnl (1), WM_HSCROLL , (WPARAM) MAKEWPARAM (SB_THUMBPOSITION , hb_parni(2) ) , 0 ) ;

}

HB_FUNC ( _HMG_PRINTER_GETPRINTERWIDTH )
{
	HDC hdc = (HDC) HMG_parnl (1);
	hb_retnl ( GetDeviceCaps ( hdc , HORZSIZE ) ) ;
}

HB_FUNC ( _HMG_PRINTER_GETPRINTERHEIGHT )
{
	HDC hdc = (HDC) HMG_parnl (1);
	hb_retnl ( GetDeviceCaps ( hdc , VERTSIZE ) ) ;
}

HB_FUNC ( _HMG_PRINTER_GETPRINTABLEAREAPHYSICALOFFSETX )
{
	HDC hdc = (HDC) HMG_parnl (1);
	hb_retnl ( GetDeviceCaps ( hdc , PHYSICALOFFSETX ) ) ;
}

HB_FUNC ( _HMG_PRINTER_GETPRINTABLEAREALOGPIXELSX )
{
	HDC hdc = (HDC) HMG_parnl (1);
	hb_retnl ( GetDeviceCaps ( hdc , LOGPIXELSX ) ) ;
}

HB_FUNC ( _HMG_PRINTER_GETPRINTABLEAREAPHYSICALOFFSETY )
{
	HDC hdc = (HDC) HMG_parnl (1);
	hb_retnl ( GetDeviceCaps ( hdc , PHYSICALOFFSETY ) ) ;
}

HB_FUNC ( _HMG_PRINTER_GETPRINTABLEAREALOGPIXELSY )
{
	HDC hdc = (HDC) HMG_parnl (1);
	hb_retnl ( GetDeviceCaps ( hdc , LOGPIXELSY ) ) ;
}



// by Dr. Claudio Soto (June 2014)

HB_FUNC ( _HMG_PRINTER_C_IMAGE )
{

// 1: hDC
// 2: Image File
// 3: Row
// 4: Col
// 5: Height
// 6: Width
// 7: Stretch
// 8: lTransparent
// 9: aTransparentColor

   HDC   hdcPrint  = (HDC)     HMG_parnl (1);
   TCHAR *FileName = (TCHAR *) HMG_parc  (2);
   HBITMAP hBitmap;
   HRGN hRgn;
   INT nWidth, nHeight;
   POINT Point;
   BITMAP Bmp;
   int r   = hb_parni (3);   // Row
   int c   = hb_parni (4);   // Col
   int odr = hb_parni (5);   // Height
   int odc = hb_parni (6);   // Width
   int dr ;
   int dc ;

   if ( hdcPrint != NULL )
   {
      c  = ( c   * GetDeviceCaps ( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint, PHYSICALOFFSETX );
      r  = ( r   * GetDeviceCaps ( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint, PHYSICALOFFSETY );
      dc = ( odc * GetDeviceCaps ( hdcPrint, LOGPIXELSX ) / 1000 );
      dr = ( odr * GetDeviceCaps ( hdcPrint, LOGPIXELSY ) / 1000 );

      hBitmap = HMG_LoadImage (FileName);
      if (hBitmap == NULL)
         return;

      GetObject (hBitmap, sizeof(BITMAP), &Bmp);
      nWidth  = Bmp.bmWidth;
      nHeight = Bmp.bmHeight;

      if ( ! hb_parl (7) ) // Scale
      {
         if ( odr * nHeight / nWidth <= odr )
            dr = odc * GetDeviceCaps ( hdcPrint, LOGPIXELSY ) / 1000 * nHeight / nWidth;
         else
            dc = odr * GetDeviceCaps ( hdcPrint, LOGPIXELSX ) / 1000 * nWidth / nHeight;
      }

      GetViewportOrgEx (hdcPrint, &Point);

      hRgn = CreateRectRgn ( c + Point.x,
                             r + Point.y,
                             c + dc + Point.x - 1,
                             r + dr + Point.y - 1);

      SelectClipRgn (hdcPrint, hRgn);

      GetBrushOrgEx (hdcPrint, &Point);
      SetStretchBltMode (hdcPrint, HALFTONE);
      SetBrushOrgEx (hdcPrint, Point.x, Point.y, NULL);

      HDC memDC = CreateCompatibleDC (hdcPrint);
      SelectObject (memDC, hBitmap);

      BOOL Transparent      = (BOOL) hb_parl (8);
      int  TransparentColor = HB_ISARRAY (9) ? (int) RGB (hb_parvnl(9,1), hb_parvnl(9,2), hb_parvnl(9,3)) : -1;
      COLORREF color_transp;

      if (( Transparent == TRUE ) || ( TransparentColor != -1 ))
      {  if (TransparentColor == -1)
            color_transp = GetPixel (memDC, 0, 0);
         else
            color_transp = (COLORREF) TransparentColor;
         TransparentBlt (hdcPrint, c, r, dc, dr, memDC, 0, 0, nWidth, nHeight, color_transp);
      }
      else
         StretchBlt (hdcPrint, c, r, dc, dr, memDC, 0, 0, nWidth, nHeight, SRCCOPY);

      SelectClipRgn (hdcPrint, NULL);

      DeleteObject (hBitmap);
      DeleteDC (memDC);
   }
}


//        GetJobInfo ( cPrinterName, nJobID ) --> { nJobID, cPrinterName, cMachineName, cUserName, cDocument, cDataType, cStatus, nStatus
//                                                  nPriorityLevel, nPositionPrintQueue, nTotalPages, nPagesPrinted, cLocalDate, cLocalTime }
HB_FUNC ( _HMG_PRINTGETJOBINFO )
{
   TCHAR *cPrinterName = (TCHAR *) HMG_parc (1);
   DWORD  nJobID       = (DWORD)   hb_parni (2);
   HANDLE hPrinter     = NULL;

   if ( OpenPrinter (cPrinterName, &hPrinter, NULL) )
   {
      DWORD nBytesNeeded = 0;
      DWORD nBytesUsed = 0;
      JOB_INFO_1 *Job_Info_1 = NULL;

      GetJob (hPrinter, nJobID, 1, NULL, 0, &nBytesNeeded);

      if (nBytesNeeded > 0)
      {
         Job_Info_1 = (JOB_INFO_1 *) hb_xgrab (nBytesNeeded);
         ZeroMemory(Job_Info_1, nBytesNeeded);

         if ( GetJob (hPrinter, nJobID, 1, (LPBYTE)Job_Info_1, nBytesNeeded, &nBytesUsed) )
         {
            hb_reta (14);
            hb_storvni ((INT) Job_Info_1->JobId,          -1,   1);
            HMG_storvc (      Job_Info_1->pPrinterName,   -1,   2);
            HMG_storvc (      Job_Info_1->pMachineName,   -1,   3);
            HMG_storvc (      Job_Info_1->pUserName,      -1,   4);
            HMG_storvc (      Job_Info_1->pDocument,      -1,   5);
            HMG_storvc (      Job_Info_1->pDatatype,      -1,   6);
            HMG_storvc (      Job_Info_1->pStatus,        -1,   7);
            hb_storvni ((INT) Job_Info_1->Status,         -1,   8);
            hb_storvni ((INT) Job_Info_1->Priority,       -1,   9);
            hb_storvni ((INT) Job_Info_1->Position,       -1,  10);
            hb_storvni ((INT) Job_Info_1->TotalPages,     -1,  11);
            hb_storvni ((INT) Job_Info_1->PagesPrinted,   -1,  12);

            TCHAR cDateTime [256];
            SYSTEMTIME LocalSystemTime;
            SystemTimeToTzSpecificLocalTime (NULL, &Job_Info_1->Submitted, &LocalSystemTime);

            wsprintf (cDateTime, _TEXT("%d/%d/%d"), LocalSystemTime.wYear, LocalSystemTime.wMonth,  LocalSystemTime.wDay);
            HMG_storvc (cDateTime,   -1,   13);

            wsprintf (cDateTime, _TEXT("%d:%d:%d"), LocalSystemTime.wHour, LocalSystemTime.wMinute, LocalSystemTime.wSecond);
            HMG_storvc (cDateTime,   -1,   14);
         }
         else
            hb_reta(0);

         if ( Job_Info_1 )
            hb_xfree ((void *) Job_Info_1 );
      }
      else
         hb_reta(0);
      ClosePrinter (hPrinter);
   }
   else
      hb_reta(0);
}


HB_FUNC ( _HMG_PRINTERGETSTATUS )
{
   TCHAR *cPrinterName = (TCHAR *) HMG_parc (1);
   HANDLE hPrinter     = NULL;
   DWORD  nBytesNeeded = 0;
   DWORD  nBytesUsed   = 0;
   PRINTER_INFO_6 *Printer_Info_6 = NULL;

   if( OpenPrinter (cPrinterName, &hPrinter, NULL) )
   {
      GetPrinter (hPrinter, 6, NULL, 0, &nBytesNeeded);
      if (nBytesNeeded > 0)
      {
         Printer_Info_6 = (PRINTER_INFO_6 *) hb_xgrab (nBytesNeeded);
         ZeroMemory(Printer_Info_6, nBytesNeeded);

         if ( GetPrinter (hPrinter, 6, (LPBYTE)Printer_Info_6, nBytesNeeded, &nBytesUsed) )
            hb_retnl ( Printer_Info_6->dwStatus );
         else
            hb_retnl ( PRINTER_STATUS_NOT_AVAILABLE );

         if ( Printer_Info_6 )
            hb_xfree ((void *) Printer_Info_6 );
      }
      else
         hb_retnl ( PRINTER_STATUS_NOT_AVAILABLE );
      ClosePrinter (hPrinter);
   }
   else
      hb_retnl ( PRINTER_STATUS_NOT_AVAILABLE );
}



HB_FUNC( GETTEXTALIGN )
{
   hb_retni( GetTextAlign( (HDC) HMG_parnl (1) ) ) ;
}

HB_FUNC( SETTEXTALIGN )
{
   hb_retni( SetTextAlign( (HDC) HMG_parnl (1), (UINT) hb_parni( 2 ) ) ) ;
}



HB_FUNC( INITACTIVEX )
{

	HMODULE hlibrary = NULL;
	HWND hchild;
	IUnknown *pUnk;
	IDispatch *pDisp;
	LPAtlAxWinInit    AtlAxWinInit;
	LPAtlAxGetControl AtlAxGetControl;

	hlibrary = LoadLibrary( _TEXT("Atl.Dll") );
	AtlAxWinInit    = ( LPAtlAxWinInit )    GetProcAddress( hlibrary, "AtlAxWinInit" );
	AtlAxGetControl = ( LPAtlAxGetControl ) GetProcAddress( hlibrary, "AtlAxGetControl" );
	AtlAxWinInit();

	hchild = CreateWindowEx( 0L , _TEXT("AtlAxWin") ,
            HMG_parc(2), WS_CHILD | WS_VISIBLE , hb_parni(3), hb_parni(4), hb_parni(5), hb_parni(6), (HWND) HMG_parnl (1), 0 , 0 , 0 );

	AtlAxGetControl( (HWND) hchild , &pUnk );
	pUnk->lpVtbl->QueryInterface(pUnk,&IID_IDispatch,(void**)&pDisp);

	hb_reta (3);
	HMG_storvnl ((LONG_PTR) hchild,   -1, 1 );
	HMG_storvnl ((LONG_PTR) pDisp,    -1, 2 );
	HMG_storvnl ((LONG_PTR) hlibrary, -1, 3 );

}



HB_FUNC ( GETSCROLLRANGEMAX )
{

   int MinPos, MaxPos;

   GetScrollRange( (HWND) HMG_parnl (1), hb_parni( 2 ),&MinPos,&MaxPos) ;

   hb_retni( MaxPos );

}

HB_FUNC ( EXITGRIDCELL )
{

	keybd_event(
		VK_F2		, // virtual-key code
		0,		// hardware scan code
		0,		// flags specifying various function options
		0		// additional data associated with keystroke
	);

}

HB_FUNC ( INSERTESC )
{

	keybd_event(
		VK_ESCAPE	,	// virtual-key code
		0,		// hardware scan code
		0,		// flags specifying various function options
		0		// additional data associated with keystroke
	);

}



//************************************************************************************************
//  by Dr. Claudio Soto (July 2013)
//************************************************************************************************


//        GetDeviceDPI (cDriverName, cDeviceName, @DPIx, @DPIy) --> Return TRUE or FALSE
HB_FUNC ( GETDEVICEDPI )
{
   INT DPIx, DPIy;
   HDC hDC = CreateDC(HMG_parc(1), HMG_parc(2), NULL, NULL);
   if (hDC)
   {
     DPIx = GetDeviceCaps(hDC, LOGPIXELSX);
     if (HB_ISBYREF(3))
        hb_stornl ((LONG) DPIx, 3);

     DPIy = GetDeviceCaps(hDC, LOGPIXELSY);
     if (HB_ISBYREF(4))
        hb_stornl ((LONG) DPIy, 4);

      DeleteDC (hDC);

      hb_retl (TRUE);
   }
   else
      hb_retl (FALSE);
}


//        HMG_GetAverageFontSize (hWnd, @nWidth, @nHeight)
HB_FUNC ( HMG_GETAVERAGEFONTSIZE )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   HDC hDC = GetDC (hWnd);
   TEXTMETRIC TextMetric;
   hb_retl ((BOOL) GetTextMetrics ( hDC, &TextMetric ));
   if (HB_ISBYREF(2))
       hb_stornl ((LONG) TextMetric.tmAveCharWidth, 2);
   if (HB_ISBYREF(3))
       hb_stornl ((LONG) TextMetric.tmHeight, 3);
   ReleaseDC (hWnd, hDC);
}


//        HMG_GetCharWidth (hWnd, ch, @A, @B, @C)
HB_FUNC ( HMG_GETCHARWIDTH )
{
   HWND  hWnd = (HWND) HMG_parnl (1);
   TCHAR *ch  = (TCHAR*) HMG_parc (2);
   UINT iFirstChar, iLastChar;
   HDC hDC = GetDC (hWnd);
   ABCFLOAT ABCfloat;
   iFirstChar = (UINT) ch [0];
   iLastChar  = (UINT) ch [0];
   GetCharABCWidthsFloat (hDC, iFirstChar, iLastChar, &ABCfloat);
   ReleaseDC (hWnd, hDC);
   hb_retnd ((double) (FLOAT)(ABCfloat.abcfA + ABCfloat.abcfB + ABCfloat.abcfC));
   if (HB_ISBYREF(3))
       hb_stornd ((double) ABCfloat.abcfA, 3);
   if (HB_ISBYREF(4))
       hb_stornd ((double) ABCfloat.abcfB, 4);
   if (HB_ISBYREF(5))
       hb_stornd ((double) ABCfloat.abcfC, 5);
}


//       HMG_EditControlGetChar (hWnd, nPos)
HB_FUNC (HMG_EDITCONTROLGETCHAR)
{
   HLOCAL hMemLocal;
   TCHAR *pCh, Text [2] = {0,0};
   HWND hWnd = (HWND) HMG_parnl (1);
   int  nPos = (int)  hb_parnl (2);
   hMemLocal = (HLOCAL) SendMessage (hWnd, EM_GETHANDLE, 0, 0);
   if (hMemLocal)
   {   pCh = (TCHAR *) LocalLock (hMemLocal);
       Text [0] = *(pCh + nPos);
       LocalUnlock (hMemLocal);
       HMG_retc (Text);
   }
   else
      HMG_retc (Text);
}


//       HMG_EditControlSetChar (hWnd, nPos, ch)
HB_FUNC (HMG_EDITCONTROLSETCHAR)
{
   HLOCAL hMemLocal;
   HWND hWnd   = (HWND)    HMG_parnl (1);
   int  nPos   = (int)     hb_parnl (2);
   TCHAR *Text = (TCHAR *) HMG_parc (3);
   TCHAR *pCh;
   TCHAR Ch = HB_ISCHAR (3) ? Text [0] : (TCHAR) hb_parnl(3);

   hMemLocal = (HLOCAL) SendMessage (hWnd, EM_GETHANDLE, 0, 0);
   if (hMemLocal)
   {   pCh = (TCHAR *) LocalLock (hMemLocal);
       *(pCh + nPos) = Ch;
       LocalUnlock (hMemLocal);
       hb_retl (TRUE);
   }
   else
      hb_retl (FALSE);
}


//        HMG_EditControlGetSel (hWnd, @nStart, @nEnd)
HB_FUNC ( HMG_EDITCONTROLGETSEL )
{
   HWND hWnd   = (HWND) HMG_parnl (1);
   LONG nStart, nEnd;
   SendMessage (hWnd, EM_GETSEL, (WPARAM) &nStart, (LPARAM) &nEnd);
   if (HB_ISBYREF(2))
       hb_stornl ((LONG) nStart, 2);
   if (HB_ISBYREF(3))
       hb_stornl ((LONG) nEnd, 3);

}


//        HMG_EditControlSetSel (hWnd, nStart, nEnd)
HB_FUNC ( HMG_EDITCONTROLSETSEL )
{
   HWND hWnd   = (HWND) HMG_parnl (1);
   LONG nStart = (LONG) hb_parnl (2);
   LONG nEnd   = (LONG) hb_parnl (3);
   SendMessage (hWnd, EM_SETSEL, (WPARAM) nStart, (LPARAM) nEnd);
}


//        HMG_EditControlReplaceSel (hWnd, bUnDone, Text)
HB_FUNC ( HMG_EDITCONTROLREPLACESEL )
{
   HWND hWnd    = (HWND)   HMG_parnl (1);
   BOOL bUnDone = (BOOL)   hb_parl  (2);
   TCHAR *Text  = (TCHAR*) HMG_parc (3);
   TCHAR Ch []  = {(TCHAR) hb_parnl (3), 0};

   SendMessage (hWnd, EM_REPLACESEL, (WPARAM) bUnDone, (LPARAM) (HB_ISCHAR (3) ? Text : (TCHAR*) Ch));
}


//        CreateCaret (hWnd, hBitmap, nWidth, nHeight)
HB_FUNC ( CREATECARET )
{
   HWND hWnd       = (HWND)    HMG_parnl (1);
   HBITMAP hBitmap = (HBITMAP) HMG_parnl (2);
   int nWidth      = (int)     hb_parnl (3);
   int nHeight     = (int)     hb_parnl (4);
   hb_retl ((BOOL) CreateCaret (hWnd, hBitmap, nWidth, nHeight));
}


//        DestroyCaret()
HB_FUNC ( DESTROYCARET )
{
   hb_retl ((BOOL) DestroyCaret());
}


//        ShowCaret (hWnd)
HB_FUNC ( SHOWCARET )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   hb_retl ((BOOL) ShowCaret (hWnd));
}


//        HideCaret (hWnd)
HB_FUNC ( HIDECARET )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   hb_retl ((BOOL) HideCaret (hWnd));
}


//        GetCaretPos ( @X, @Y )
HB_FUNC ( GETCARETPOS )
{
   POINT Point;
   hb_retl ((BOOL) GetCaretPos (&Point));   // The caret position is always given in the client coordinates of the window that contains the caret.
   if (HB_ISBYREF(1))
       hb_stornl ((LONG) Point.x, 1);
   if (HB_ISBYREF(2))
       hb_stornl ((LONG) Point.y, 2);
}


//        SetCaretPos ( X, Y )
HB_FUNC ( SETCARETPOS )
{
   int X = (int) hb_parnl (1);
   int Y = (int) hb_parnl (2);
   hb_retl ((BOOL) SetCaretPos ( X, Y ));   // The caret position is always given in the client coordinates of the window that contains the caret.
}


//        GetCaretBlinkTime()
HB_FUNC ( GETCARETBLINKTIME )
{
   UINT uMSeconds = GetCaretBlinkTime();
   hb_retnl ((LONG) uMSeconds);
}


//        SetCaretBlinkTime (uMSeconds)
HB_FUNC ( SETCARETBLINKTIME )
{
   UINT uMSeconds = (UINT) hb_parnl (1);
   hb_retl ((BOOL) SetCaretBlinkTime (uMSeconds));
}





//************************************************************************************************
//  by Dr. Claudio Soto (October 2013)
//************************************************************************************************


//        SetCursorSystem ( nIDC ) --> hCursorPrevious
HB_FUNC ( SETCURSORSYSTEM )
{
   int nIDC = hb_parni (1);
   HCURSOR hCursor = SetCursor (LoadCursor (NULL, MAKEINTRESOURCE (nIDC)));
   HMG_retnl ((LONG_PTR) hCursor);
}


HB_FUNC (HMG_SETCURSOR)
{
   HCURSOR hCursorPrevious;
   hCursorPrevious = SetCursor ( (HCURSOR) HMG_parnl (1) );
   HMG_retnl ((LONG_PTR) hCursorPrevious);
}


HB_FUNC (HMG_GETCURSOR)
{
   HCURSOR hCursor = GetCursor ();
   HMG_retnl ((LONG_PTR) hCursor);
}




HB_FUNC( GETCOMPUTERNAME )
{
   TCHAR cBuffer [ MAX_COMPUTERNAME_LENGTH + 1 ];
   DWORD nSize   = MAX_COMPUTERNAME_LENGTH + 1 ;
   GetComputerName( cBuffer, &nSize );
   HMG_retc ( cBuffer );
}


HB_FUNC( GETUSERNAME )
{
   TCHAR cBuffer [ UNLEN + 1 ];
   DWORD nSize   = UNLEN + 1;
   GetUserName ( cBuffer, &nSize );
   HMG_retc ( cBuffer );
}


HB_FUNC( SETCOMPUTERNAME )
{
   TCHAR * cComputerName = (TCHAR *) HMG_parc(1);
   hb_retl ((BOOL) SetComputerName ( cComputerName ));
}



/*
// GetBinaryType() --> nBinaryType

#define SCS_32BIT_BINARY   0 // A 32-bit Windows-based application
#define SCS_64BIT_BINARY   6 // A 64-bit Windows-based application.
#define SCS_DOS_BINARY     1 // An MS-DOS – based application
#define SCS_OS216_BINARY   5 // A 16-bit OS/2-based application
#define SCS_PIF_BINARY     3 // A PIF file that executes an MS-DOS – based application
#define SCS_POSIX_BINARY   4 // A POSIX – based application
#define SCS_WOW_BINARY     2 // A 16-bit Windows-based application

*/

//        GetBinaryType ( cApplicationName ) --> nBinaryType
HB_FUNC ( GETBINARYTYPE )
{
   TCHAR * cApplicationName = (TCHAR *) HMG_parc(1);
   DWORD nBinaryType;
   if( GetBinaryType( cApplicationName, &nBinaryType ) )
      hb_retni( nBinaryType );
   else
      hb_retni( -1 );
}



//*********************************************
// by Dr. Claudio Soto (January 2014)
//*********************************************

#include "hbthread.h"
extern HB_CRITICAL_T _HMG_Mutex;   // global Mutex variable defined into c_Thread.c

static __TLS__ PHB_ITEM pArray    = NULL;
static __TLS__ PHB_ITEM pSubarray = NULL;

typedef struct
{
   INT  CharSet;
   INT  Pitch;
   INT  FontType;

} HMG_FontFamiliesFilter;


int CALLBACK EnumFontFamiliesCallBack ( ENUMLOGFONT *lplf, NEWTEXTMETRIC *lpntm, DWORD FullFontType, LPARAM lParam )
{
   UNREFERENCED_PARAMETER ( lpntm );
   HMG_FontFamiliesFilter *FontFamiliesFilter = (HMG_FontFamiliesFilter *) lParam;
   INT FontType;

   if ( FullFontType & TRUETYPE_FONTTYPE )
      FontType = 3;
   else if ( FullFontType & RASTER_FONTTYPE )
      FontType = 2;
   else
      FontType = 1;   // Vector FontType

   if ( ( FontFamiliesFilter->CharSet        == -1 || FontFamiliesFilter->CharSet        == (INT) lplf->elfLogFont.lfCharSet ) &&
        ( FontFamiliesFilter->Pitch          == -1 || FontFamiliesFilter->Pitch          == (INT) (lplf->elfLogFont.lfPitchAndFamily & 0x03) ) &&
        ( FontFamiliesFilter->FontType       == -1 || FontFamiliesFilter->FontType       == (INT) FontType ) )
   {
      if ( lplf->elfLogFont.lfFaceName [0] != '@' )
      {
         hb_arrayNew    ( pSubarray, 4 );

         hb_arraySetC  ( pSubarray,  1,  HMG_WCHAR_TO_CHAR (lplf->elfLogFont.lfFaceName) );
         hb_arraySetNI ( pSubarray,  2,  (INT) lplf->elfLogFont.lfCharSet );
         hb_arraySetNI ( pSubarray,  3,  (INT) (lplf->elfLogFont.lfPitchAndFamily & 0x03) );
         hb_arraySetNI ( pSubarray,  4,  (INT) FontType );

         hb_arrayAddForward ( pArray, pSubarray );
      }
   }

   return 1;
}


//        EnumFonts ( [ hDC ] , [ cFontFamilyName ] , [ nCharSet ] , [ nPitch ] , [ nFontType ] , [ SortCodeBlock ] , [ @aFontName ] )   --> return array { { cFontName, nCharSet, nPitchAndFamily, nFontType } , ... }
HB_FUNC ( ENUMFONTS)
{
   HDC    hDC             = HB_ISNIL(1) ? GetDC (NULL) : (HDC) HMG_parnl (1);
   TCHAR *cFontFamilyName = (TCHAR *) HMG_parc(2);

_THREAD_LOCK();

   pArray    = hb_itemArrayNew ( 0 );
   pSubarray = hb_itemNew ( NULL );

   HMG_FontFamiliesFilter FontFamiliesFilter = { -1, -1, -1 };   // default without filter

   if ( HB_ISNUM (3) )
   {   FontFamiliesFilter.CharSet = ( hb_parni (3) == DEFAULT_CHARSET ? GetTextCharset ( hDC ) : hb_parni (3) );
       if ( FontFamiliesFilter.CharSet == DEFAULT_CHARSET )   // if fail GetTextCharset() return DEFAULT_CHARSET
           FontFamiliesFilter.CharSet = -1;
   }

   if ( HB_ISNUM (4) )
   {   FontFamiliesFilter.Pitch = hb_parni (4);
       if ( FontFamiliesFilter.Pitch == DEFAULT_PITCH )
            FontFamiliesFilter.Pitch = -1;
   }

   if ( HB_ISNUM (5) )
       FontFamiliesFilter.FontType = hb_parnl (5);


   EnumFontFamilies ( hDC, cFontFamilyName, (FONTENUMPROC) EnumFontFamiliesCallBack, (LPARAM) &FontFamiliesFilter );
   DeleteDC ( hDC );


   if ( HB_ISBLOCK (6) && pArray )
      hb_arraySort ( pArray, NULL, NULL, hb_param (6, HB_IT_BLOCK) );


   if ( HB_ISBYREF (7) && pArray )
   {
       PHB_ITEM aFontName;
      int nLen, i;

       aFontName = hb_param (7, HB_IT_ANY );
       nLen = hb_arrayLen ( pArray );

       hb_arrayNew ( aFontName, nLen );

       for ( i=1; i <= nLen; i++ )
       {
           hb_arrayGet  ( pArray,     i, pSubarray );
           hb_arraySetC ( aFontName,  i, hb_arrayGetC ( pSubarray, 1 ) );
       }
   }

   hb_itemRelease ( pSubarray );
   hb_itemReturnRelease ( pArray );

   pArray    = NULL;
   pSubarray = NULL;

_THREAD_UNLOCK();

}




/****************************************************************************
   HMG_LoadResourceRawFile ( cFileName, cTypeResource | nTypeResourceID )   *
*****************************************************************************/

/*
// Standard resource type ID ( constant defined in i_controlmisc.ch )

#define RT_CURSOR       (1)
#define RT_FONT         (8)
#define RT_BITMAP       (2)
#define RT_ICON         (3)
#define RT_MENU         (4)
#define RT_DIALOG       (5)
#define RT_STRING       (6)
#define RT_FONTDIR      (7)
#define RT_ACCELERATOR  (9)
#define RT_RCDATA       (10)
#define RT_MESSAGETABLE (11)
#define DIFFERENCE      (11)
#define RT_GROUP_CURSOR ( RT_CURSOR + DIFFERENCE )
#define RT_GROUP_ICON   ( RT_ICON   + DIFFERENCE )
#define RT_VERSION      (16)
#define RT_DLGINCLUDE   (17)
#define RT_PLUGPLAY     (19)
#define RT_VXD          (20)
#define RT_ANICURSOR    (21)
#define RT_ANIICON      (22)
#define RT_HTML         (23)
#define RT_MANIFEST     (24)
*/

//        HMG_LoadResourceRawFile ( cFileName, cTypeResource | nTypeResourceID )
HB_FUNC ( HMG_LOADRESOURCERAWFILE )
{
   HRSRC   hResourceData;
   HGLOBAL hGlobalResource;
   LPVOID  lpGlobalResource = NULL;
   DWORD   nFileSize;
   TCHAR   *FileName     = (TCHAR*) HMG_parc(1);
   TCHAR   *TypeResource = HB_ISCHAR (2) ? (TCHAR*) HMG_parc(2) : MAKEINTRESOURCE ( hb_parni(2) );

   hResourceData = FindResource ( NULL, FileName, TypeResource );
   if ( hResourceData != NULL )
   {
       hGlobalResource = LoadResource ( NULL, hResourceData );
       if ( hGlobalResource != NULL )
       {
           lpGlobalResource = LockResource ( hGlobalResource );
           if ( lpGlobalResource != NULL )
           {
               nFileSize = SizeofResource ( NULL, hResourceData );
               hb_retclen ( (const CHAR *) lpGlobalResource, (HB_SIZE) nFileSize );
           }
           FreeResource ( hGlobalResource );
       }
   }

   if ( lpGlobalResource == NULL )
        hb_retclen ( (const CHAR *) NULL, (HB_SIZE) 0 );
}



/******************************************************************/
/*   Keyboard Layout Functions (by Dr. Claudio Soto, June 2014)   */
/******************************************************************/


HB_FUNC ( GETKEYBOARDLAYOUTNAME )
{
   TCHAR cKLID [ KL_NAMELENGTH + 1 ];
   GetKeyboardLayoutName (cKLID);
   HMG_retc (cKLID);
}


HB_FUNC ( ACTIVATEKEYBOARDLAYOUT )
{
   HKL hkl     = (HKL)  HMG_parnl (1);
   UINT Flags  = (UINT) hb_parni  (2);
   HKL old_hkl = ActivateKeyboardLayout (hkl, Flags);
   HMG_retnl ((LONG_PTR) old_hkl );
}


HB_FUNC ( GETKEYBOARDLAYOUT )
{
   DWORD idThread = (DWORD) hb_parni (1);   // Zero for the current thread
   HKL hkl = GetKeyboardLayout (idThread);
   HMG_retnl ((LONG_PTR) hkl );
}


HB_FUNC ( GETKEYBOARDLAYOUTLIST )
{
   int nCount = GetKeyboardLayoutList (0, NULL);
   if ( nCount > 0 )
   {  int i;
      hb_reta (nCount);
      HKL List [nCount];
      GetKeyboardLayoutList (nCount, List);
      for (i=0; i < nCount; i++)
           HMG_storvnl ((LONG_PTR) List [i], -1, i+1);
   }
}


HB_FUNC ( LOADKEYBOARDLAYOUT )
{
   // http://msdn.microsoft.com/en-us/library/windows/desktop/dd318693(v=vs.85).aspx
   TCHAR *cKLID = (TCHAR*) HMG_parc (1);
   UINT Flags   = (UINT)   hb_parni (2);
   HKL hkl = LoadKeyboardLayout (cKLID, Flags);
   HMG_retnl ((LONG_PTR) hkl );
}


HB_FUNC ( UNLOADKEYBOARDLAYOUT )
{
   HKL hkl = (HKL)  HMG_parnl (1);
   hb_retl ((BOOL) UnloadKeyboardLayout (hkl));
}



/******************************************************************/
/*   Change Notification Functions (by Dr. Claudio Soto, July 2014)   */
/******************************************************************/


HB_FUNC ( FINDFIRSTCHANGENOTIFICATION )
{
   TCHAR *cPathName     = (TCHAR *) HMG_parc (1);
   BOOL  bWatchSubtree  = (BOOL)    hb_parl  (2);   // if TRUE  the function monitors the directory tree rooted at the specified directory.
                                                    // if FALSE the function monitors only the specified directory.
   DWORD dwNotifyFilter = (LONG)    hb_parnl (3);
   HANDLE hChangeHandle = FindFirstChangeNotification (cPathName, bWatchSubtree, dwNotifyFilter);
   if (hChangeHandle == INVALID_HANDLE_VALUE)
      hChangeHandle = NULL;
   HMG_retnl ((LONG_PTR) hChangeHandle);
}


HB_FUNC ( FINDNEXTCHANGENOTIFICATION )
{
   HANDLE hChangeHandle = (HANDLE) HMG_parnl (1);
   BOOL ret = FindNextChangeNotification (hChangeHandle);
   hb_retl ((BOOL) ret);
}


HB_FUNC ( FINDCLOSECHANGENOTIFICATION )
{
   HANDLE hChangeHandle = (HANDLE) HMG_parnl (1);
   BOOL ret = FindCloseChangeNotification (hChangeHandle);
   hb_retl ((BOOL) ret);
}


HB_FUNC ( WAITFORSINGLEOBJECT )
{
   HANDLE hHandle       = (HANDLE) HMG_parnl (1);
   DWORD dwMilliseconds = (DWORD)  hb_parnl  (2);
   DWORD ret = WaitForSingleObject (hHandle, dwMilliseconds);
   hb_retnl ((LONG) ret);
}


HB_FUNC ( WAITFORMULTIPLEOBJECTS )
{
   DWORD     nCount         = (DWORD)    hb_parnl (1);
   PHB_ITEM  pArray         = (PHB_ITEM) hb_param (2, HB_IT_ARRAY);
   BOOL      bWaitAll       = (BOOL)     hb_parl  (3);
   DWORD     dwMilliseconds = (DWORD)    hb_parnl (4);
   int       nLen           = min ( min (hb_arrayLen (pArray), nCount),  MAXIMUM_WAIT_OBJECTS );   // MAXIMUM_WAIT_OBJECTS --> 64
   DWORD ret;
   int i;

   if ( nLen > 0 )
   {  nCount = 0;
      HANDLE Handle, ArrayHandle [ nLen ];
      for (i=1; i <= nLen; i++)
      {   Handle = (HANDLE) (LONG_PTR) hb_arrayGetNLL (pArray, i);
          if (Handle != NULL)
              ArrayHandle [ nCount++ ] = Handle;
      }
      if (nCount > 0)
         ret = WaitForMultipleObjects (nCount, ArrayHandle, bWaitAll, dwMilliseconds);
      else
         ret = WAIT_FAILED;
   }
   else
      ret = WAIT_FAILED;

   hb_retnl ((LONG) ret);
}


// by Dr. Claudio Soto, December 2014

#ifdef UNICODE
   HMG_DEFINE_DLL_FUNC ( win_AssocQueryString ,                               // user function name
                         "Shlwapi.dll",                                       // dll name
                         HRESULT,                                             // function return type
                         WINAPI,                                              // function type
                         "AssocQueryStringW",                                 // dll function name
                         (ASSOCF flags, ASSOCSTR str, LPCWSTR pszAssoc, LPCWSTR pszExtra, LPWSTR pszOut, DWORD *pcchOut),   // dll function parameters (types and names)
                         (flags, str, pszAssoc, pszExtra, pszOut, pcchOut),   // function parameters (only names)
                         -1                                                   // return value if fail call function of dll
                        )
#else
   HMG_DEFINE_DLL_FUNC ( win_AssocQueryString,                                // user function name
                         "Shlwapi.dll",                                       // dll name
                         HRESULT,                                             // function return type
                         WINAPI,                                              // function type
                         "AssocQueryStringA",                                 // dll function name
                         (ASSOCF flags, ASSOCSTR str, LPCSTR pszAssoc, LPCSTR pszExtra, LPSTR pszOut, DWORD *pcchOut),   // dll function parameters (types and names)
                         (flags, str, pszAssoc, pszExtra, pszOut, pcchOut),   // function parameters (only names)
                         -1                                                   // return value if fail call function of dll
                        )
#endif

//        HMG_GetFileAssociatedWithExtension ( cExt )   // Extension with point, e.g. ".TXT"
HB_FUNC ( HMG_GETFILEASSOCIATEDWITHEXTENSION )
{
   TCHAR *cExt = (TCHAR *) HMG_parc (1);
   TCHAR cBuffer [ 2048 ];
   DWORD nCharOut = sizeof(cBuffer) / sizeof(TCHAR);
   ZeroMemory (cBuffer, sizeof (cBuffer));
   win_AssocQueryString ( 0, ASSOCSTR_EXECUTABLE, cExt, NULL, cBuffer, (DWORD *) &nCharOut );
   HMG_retc (cBuffer);
}


//        HMG_IsRunAppInWin32
HB_FUNC ( HMG_ISRUNAPPINWIN32 )
{
   SYSTEM_INFO SysInfo;
   GetNativeSystemInfo (&SysInfo);
   if ( SysInfo.wProcessorArchitecture != PROCESSOR_ARCHITECTURE_UNKNOWN )
       hb_retl ((BOOL) (SysInfo.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_INTEL));   // x86 32-bits
}


//        HMG_IsWinVistaOrLater()
HB_FUNC ( HMG_ISWINVISTAORLATER )
{
   // Initialize the OSVERSIONINFOEX structure.
    OSVERSIONINFOEX osvi;
    ZeroMemory (&osvi, sizeof(OSVERSIONINFOEX));
    osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);
    osvi.dwMajorVersion = 6;
    osvi.dwMinorVersion = 0;

    // Initialize the condition mask.
    DWORDLONG dwlConditionMask = 0;
    VER_SET_CONDITION (dwlConditionMask, VER_MAJORVERSION, VER_GREATER_EQUAL);
    VER_SET_CONDITION (dwlConditionMask, VER_MINORVERSION, VER_GREATER_EQUAL);

    // Perform the test.
    hb_retl ((BOOL) VerifyVersionInfo (&osvi, VER_MAJORVERSION | VER_MINORVERSION, dwlConditionMask));
 }


HMG_DEFINE_DLL_FUNC ( win_DisableProcessWindowsGhosting,                  // user function name
                      "User32.dll",                                       // dll name
                      VOID,                                               // function return type
                      WINAPI,                                             // function type
                      "DisableProcessWindowsGhosting",                    // dll function name
                      (VOID),                                             // dll function parameters (types and names)
                      (),                                                 // function parameters (only names)
                      0                                                   // return value if fail call function of dll
                    )

//        DisableProcessWindowsGhosting
HB_FUNC ( DISABLEPROCESSWINDOWSGHOSTING )
{
   win_DisableProcessWindowsGhosting ();
}


HB_FUNC( HMG_DOPROC )
{
   char * cProcName = (char *) hb_parc( 1 );
   if( cProcName )
   {  PHB_DYNS pDynSym = hb_dynsymFindName( cProcName );
      if( pDynSym )
      {  hb_vmPushSymbol( hb_dynsymSymbol( pDynSym ) );
         hb_vmPushNil();
         hb_vmDo( 0 );
      }
      else
         hb_ret();
   }
   else
      hb_ret();
}


HB_FUNC( HMG_EVAL )
{
   PHB_ITEM pItemBlock = hb_param( 1, HB_IT_BLOCK );
   if( pItemBlock )
   {   hb_vmEvalBlock( pItemBlock );
       hb_vmDestroyBlockOrMacro( pItemBlock );
   }
   else
      hb_ret();
}
