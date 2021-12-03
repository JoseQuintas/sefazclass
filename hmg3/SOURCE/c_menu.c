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



// #define WINVER  0x0500
// #define _WIN32_IE      0x0500
// #define HB_OS_WIN_32_USED
// #define _WIN32_WINNT   0x0400


#include <shlobj.h>
#include <windows.h>
#include <commctrl.h>
#include <tchar.h>
#include "hbapi.h"

//#include "hbvm.h"
//#include "hbstack.h"
//#include "hbapiitm.h"
//#include "winreg.h"


HBITMAP HMG_LoadPicture ( TCHAR *FileName, int New_Width, int New_Height, HWND hWnd, int ScaleStretch, int Transparent, long BackgroundColor, int AdjustImage, long TransparentColor );



LONG_PTR HMG_ChangeWindowStyle ( HWND hWnd, LONG_PTR Add, LONG_PTR Remove, BOOL ExStyle, BOOL lRedrawWindow )
{
   int nIndex  = ExStyle ? GWL_EXSTYLE : GWL_STYLE;

   LONG_PTR OldStyle = GetWindowLongPtr ( hWnd, nIndex );
   LONG_PTR NewStyle = (OldStyle | Add) & ( ~Remove );
   LONG_PTR Style    = SetWindowLongPtr ( hWnd, nIndex, NewStyle );

   if ( lRedrawWindow )
      SetWindowPos ( hWnd, NULL, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED );

   return Style;
}


BOOL HMG_IsWindowStyle ( HWND hWnd, LONG_PTR Style, BOOL ExStyle )
{
   int nIndex   = ExStyle ? GWL_EXSTYLE : GWL_STYLE;
   LONG_PTR OldStyle = GetWindowLongPtr ( hWnd, nIndex );
   return ((BOOL) (OldStyle & Style));
}


HB_FUNC ( TRACKPOPUPMENU )
{
   HWND hWnd = (HWND) HMG_parnl (4);

   SetForegroundWindow( hWnd );

   BOOL lTopMost = HMG_IsWindowStyle( hWnd, WS_EX_TOPMOST, TRUE );

   if( lTopMost )   // ADD September 2015
      SetWindowPos( hWnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_SHOWWINDOW | SWP_NOACTIVATE | SWP_ASYNCWINDOWPOS | SWP_NOOWNERZORDER | SWP_NOMOVE | SWP_NOSIZE );

   TrackPopupMenu ( (HMENU) HMG_parnl(1), TPM_LEFTALIGN | TPM_TOPALIGN | TPM_LEFTBUTTON, hb_parni(2), hb_parni(3), 0, hWnd, NULL );

   if( lTopMost )   // ADD September 2015
      SetWindowPos( hWnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_SHOWWINDOW | SWP_NOACTIVATE | SWP_ASYNCWINDOWPOS | SWP_NOOWNERZORDER | SWP_NOMOVE | SWP_NOSIZE );

// PostMessage( hWnd, WM_NULL, 0, 0 );
}


HB_FUNC ( APPENDMENUSTRING )
{
   // AppendMenu() return BOOL value
	hb_retnl ( AppendMenu( (HMENU) HMG_parnl (1), MF_STRING , hb_parni(2), HMG_parc(3)) ) ;
}


HB_FUNC ( APPENDMENUSEPARATOR )
{
   // AppendMenu() return BOOL value
	hb_retnl ( AppendMenu( (HMENU) HMG_parnl (1), MF_SEPARATOR , 0 , NULL ) ) ;
}


HB_FUNC ( APPENDMENUPOPUP )
{
   // AppendMenu() return BOOL value
	hb_retnl ( AppendMenu( (HMENU) HMG_parnl (1), MF_POPUP | MF_STRING , hb_parni(2), HMG_parc(3)) ) ;
}


HB_FUNC ( CREATEMENU )
{
	HMG_retnl ((LONG_PTR) CreateMenu() );
}


HB_FUNC ( CREATEPOPUPMENU )
{
	HMG_retnl ((LONG_PTR) CreatePopupMenu() );
}


HB_FUNC ( SETMENU )
{
	SetMenu( (HWND) HMG_parnl (1), (HMENU) HMG_parnl (2) ) ;
}


HB_FUNC ( XENABLEMENUITEM )
{
	EnableMenuItem ( (HMENU) HMG_parnl (1), hb_parni(2)  , MF_ENABLED ) ;
}


HB_FUNC ( XDISABLEMENUITEM )
{
	EnableMenuItem ( (HMENU) HMG_parnl (1), hb_parni(2)  , MF_GRAYED ) ;
}


HB_FUNC ( XCHECKMENUITEM )
{
	CheckMenuItem ( (HMENU) HMG_parnl (1), hb_parni(2)  , MF_CHECKED ) ;
}


HB_FUNC ( XUNCHECKMENUITEM )
{
	CheckMenuItem ( (HMENU) HMG_parnl (1), hb_parni(2)  , MF_UNCHECKED ) ;
}


HB_FUNC ( XGETMENUCHECKSTATE )
{
	UINT r = GetMenuState(  (HMENU) HMG_parnl (1), hb_parni(2) , MF_BYCOMMAND ) ;

	if ( r == MF_CHECKED )
      hb_retni (1);
	else
      hb_retni (0);
}


HB_FUNC ( XGETMENUENABLEDSTATE )
{
	UINT r = GetMenuState(  (HMENU) HMG_parnl (1), hb_parni(2) , MF_BYCOMMAND ) ;

	if ( r == MF_GRAYED )
       hb_retni (0);
	else
      hb_retni (1);
}


HB_FUNC ( MENUITEM_SETBITMAPS )
{
   HMENU hMenu       = (HMENU)   HMG_parnl (1);
   INT   nID         = (INT)     hb_parni  (2);
   TCHAR *FileName1  = (TCHAR *) HMG_parc  (3);
   TCHAR *FileName2  = (TCHAR *) HMG_parc  (4);

   int   Transparent = hb_parl (5) ? 0 : 1;
                                                          //    ScaleStretch, Transparent, BackgroundColor,  AdjustImage,   TransparentColor
   HBITMAP hBitmap1 = HMG_LoadPicture (FileName1, -1, -1, NULL,            0, Transparent,              -1,            0,                 -1 );
   HBITMAP hBitmap2 = HMG_LoadPicture (FileName2, -1, -1, NULL,            0, Transparent,              -1,            0,                 -1 );

   SetMenuItemBitmaps (hMenu, nID, MF_BYCOMMAND, hBitmap1, hBitmap2);
}


// Dr. Claudio Soto (March 2013 )


HB_FUNC (DELETEMAINMENU)
{
   HWND  hWnd = (HWND) HMG_parnl (1);
   HMENU hMainMenu = GetMenu (hWnd);
   DestroyMenu( hMainMenu );
   SetMenu (hWnd, NULL);
/*
   HMENU hMainMenu = GetMenu (hWnd);
   while (GetMenuItemCount (hMainMenu) > 0)
          DeleteMenu (hMainMenu, 0, MF_BYPOSITION);
   DrawMenuBar (hWnd);
*/
}


HB_FUNC (EXISTMAINMENU)
{
   HWND  hWnd = (HWND) HMG_parnl (1);
   HMENU hMainMenu = GetMenu (hWnd);
   if (hMainMenu == NULL)
       hb_retl (FALSE);
   else
       hb_retl (TRUE);
}


HB_FUNC (DESTROYMENU)
{
   HMENU hMenu = (HMENU) HMG_parnl (1);
   hb_retl (DestroyMenu(hMenu));
}


HB_FUNC (GETMENU)
{
   HWND  hWnd  = (HWND) HMG_parnl (1);
   HMENU hMenu = GetMenu (hWnd);
   HMG_retnl ((LONG_PTR) hMenu);
}


HB_FUNC (GETSUBMENU)
{
   HMENU hMenu = (HMENU) HMG_parnl (1);
   INT   nPos  = (INT)   hb_parni(2);
   HMG_retnl ((LONG_PTR)  GetSubMenu (hMenu, nPos) );
}


HB_FUNC (GETMENUITEMCOUNT)
{
   HMENU hMenu = (HMENU) HMG_parnl (1);
   hb_retni ((INT) GetMenuItemCount (hMenu));
}


HB_FUNC (GETMENUITEMID)
{
   HMENU hMenu = (HMENU) HMG_parnl (1);
   INT   nPos  = (INT)   hb_parni(2);
   hb_retnl ((LONG) GetMenuItemID (hMenu, nPos));
}


HB_FUNC (ISMENU)
{
   HMENU hMenu = (HMENU) HMG_parnl (1);
   hb_retl ((BOOL) IsMenu (hMenu));
}


//        SetMenuBkColor (hWnd, {r,g,b}, lSubMenu)
HB_FUNC ( SETMENUBKCOLOR )
{
   HMENU      iMenu;
   MENUINFO   iMenuInfo ;

   HWND  hWnd     = (HWND) HMG_parnl (1);
   INT   nRed     = (INT)  hb_parvni (2,1);
   INT   nGreen   = (INT)  hb_parvni (2,2);
   INT   nBlue    = (INT)  hb_parvni (2,3);
   BOOL  lSubMenu = (BOOL) hb_parl   (3);

   iMenu = GetMenu ( hWnd );
   GetMenuInfo(iMenu, &iMenuInfo);
   iMenuInfo.cbSize   = sizeof(MENUINFO);
   if (lSubMenu)
      iMenuInfo.fMask    = MIM_BACKGROUND | MIM_APPLYTOSUBMENUS;
   else
      iMenuInfo.fMask    = MIM_BACKGROUND;

   iMenuInfo.hbrBack = CreateSolidBrush ( RGB (nRed, nGreen, nBlue) );
   SetMenuInfo(iMenu, &iMenuInfo);
   DrawMenuBar( (HWND) HMG_parnl (1) );
}


HB_FUNC ( GETSYSTEMMENU )
{
   HWND  hWnd    = (HWND) HMG_parnl (1);
   BOOL  bRevert = (BOOL) HB_ISLOG  (2) ? hb_parl (2) : FALSE;
   HMENU hSysMenu = GetSystemMenu ( hWnd, bRevert );
   HMG_retnl ((LONG_PTR) hSysMenu );
}


HB_FUNC ( GETMENUSTATE )
{
   HMENU hMenu  = (HMENU) HMG_parnl (1);
   UINT  MenuID = (UINT)  hb_parni  (2);
   UINT  uFlags = (UINT)  HB_ISNUM  (3) ? hb_parni (3) : MF_BYCOMMAND;
   UINT  uState = GetMenuState ( hMenu, MenuID, uFlags );
   hb_retni ((INT) uState);
}
