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




//#define _WIN32_IE 0x0500


#include <windows.h>
#include <wingdi.h>
#include <winuser.h>
#include <commctrl.h>
#include "hbapi.h"


//#define TBIF_TEXT 2

//#define TB_SETBUTTONINFO	(WM_USER+66)
//#define TBSTYLE_LIST	0x1000

//#define TBSTYLE_DROPDOWN	8
//#define TBSTYLE_FLAT	2048
//#define TBSTYLE_AUTOSIZE	16
//#define TBSTYLE_EX_DRAWDDARROWS	1
//#define TB_SETEXTENDEDSTYLE	(WM_USER+84)
//#define TB_GETMAXSIZE		(WM_USER+83)

//#define BTNS_CHECK	TBSTYLE_CHECK
//#define BTNS_GROUP	TBSTYLE_GROUP
//#define BTNS_DROPDOWN	TBSTYLE_DROPDOWN
//#define BTNS_WHOLEDROPDOWN	0x0080




HBITMAP HMG_LoadPicture ( TCHAR *FileName, int New_Width, int New_Height, HWND hWnd, int ScaleStretch, int Transparent, long BackgroundColor, int AdjustImage, long TransparentColor );

// ----------------------------------------------------------------------------
// InitToolBar Function
// ----------------------------------------------------------------------------
//
// Parameters:
//
//	1.  Parent Window Handle
//	2.  ToolBar Id
//	3.  Button Width
//	4.  Button Height
//	5.  Border
//	6.  Flat
//	7.  Bottom
//	8.  RightText
//	9.  SplitBox Active
//	10. ImageWidth
//	11. ImageHeight
//	12. StrictWidth
//
// ----------------------------------------------------------------------------
HB_FUNC ( INITTOOLBAR )
{

	HWND hwndParent = (HWND) HMG_parnl (1);
	HWND hwndTB ;
	int Style = WS_CHILD | WS_VISIBLE | WS_CLIPCHILDREN | WS_CLIPSIBLINGS | TBSTYLE_TOOLTIPS ;
	int ExStyle = 0 ;

	int imagewidth , imageheight ;

//  InitCommonControls();
   INITCOMMONCONTROLSEX icex;
   icex.dwSize = sizeof(INITCOMMONCONTROLSEX);
   icex.dwICC = ICC_BAR_CLASSES;
   InitCommonControlsEx (&icex);


	if ( hb_parl (5) )
	{
		ExStyle = ExStyle | WS_EX_CLIENTEDGE ;
	}
	if ( hb_parl (6) )
	{
		Style = Style | TBSTYLE_FLAT ;
	}
	if ( hb_parl (7) )
	{
		Style = Style | CCS_BOTTOM ;
	}
	if ( hb_parl (8) )
	{
		Style = Style | TBSTYLE_LIST ;
	}
	if ( hb_parl (9) )
	{
		Style = Style | CCS_NOPARENTALIGN | CCS_NODIVIDER | CCS_NORESIZE;
	}

	// Create the toolbar.
// Create the toolbar window.

	hwndTB = CreateWindowEx ( ExStyle , TOOLBARCLASSNAME /*_TEXT("ToolbarWindow32")*/,
				TEXT(""), Style ,
            0, 0, 0, 0,
				hwndParent,
				(HMENU) HMG_parnl(2),
				GetModuleHandle( NULL ) ,
				NULL
				) ;

	SendMessage ( hwndTB,TB_SETEXTENDEDSTYLE,0,(LPARAM) TBSTYLE_EX_DRAWDDARROWS );

	// Send the TB_BUTTONSTRUCTSIZE message.
	SendMessage ( hwndTB, TB_BUTTONSTRUCTSIZE, (WPARAM) sizeof(TBBUTTON), 0);

	// Set Button Size
	SendMessage	( hwndTB , TB_SETBUTTONSIZE , 0 , (LPARAM) MAKELONG ( hb_parni(3) , hb_parni(4) ) ) ;

	// Force Button Width
	if ( hb_parl (12) )
	{
		SendMessage	( hwndTB , TB_SETBUTTONWIDTH , 0 , (LPARAM) MAKELONG ( hb_parni(3) , hb_parni(3) ) ) ;
	}

	// Set Bitmap Size

	if ( hb_parni(10) == -1 && hb_parni(11) == -1 ) // Auto Image Size
	{

		if ( hb_parl (8) ) // RightText
		{
			SendMessage	( hwndTB , TB_SETBITMAPSIZE , 0 , (LPARAM) MAKELONG ( hb_parni(4) , hb_parni(4) ) ) ;
			imagewidth	= hb_parni(4) ;
			imageheight	= hb_parni(4) ;

		}
		else // Bottom Text
		{
			SendMessage	( hwndTB , TB_SETBITMAPSIZE , 0 , (LPARAM) MAKELONG ( hb_parni(3) * .72 , hb_parni(4) * .72 ) ) ;
			imagewidth	= hb_parni(3) * .72 ;
			imageheight	= hb_parni(4) * .72 ;

		}

	}
	else // User Defined Image Size
	{

		SendMessage	( hwndTB , TB_SETBITMAPSIZE , 0 , (LPARAM) MAKELONG ( hb_parni(10) , hb_parni(11) ) ) ;
		imagewidth	= hb_parni(10);
		imageheight	= hb_parni(11);

	}

	hb_reta( 3 );
	HMG_storvnl ((LONG_PTR) hwndTB,      -1, 1 );
	hb_storvni  ((INT)      imagewidth,  -1, 2 );
	hb_storvni  ((INT)      imageheight, -1, 3 );

}
// ----------------------------------------------------------------------------
// InitToolButton Function
// ----------------------------------------------------------------------------
//
// Parameters:
//
//  1. ToolBar Handle
//  2. Button BitMap
//  3. Button Text
//  4. Button Id
//  5. Separator
//  6. AutoSize
//  7. Check
//  8. Group
//  9. DropDown
// 10. WholeDropDown
// 11. Image Width
// 12. Image Height
// 13. NoTransparent
//
// ----------------------------------------------------------------------------

HB_FUNC ( INITTOOLBUTTON )
{
   HWND hwndTB = (HWND) HMG_parnl (1);
   TBADDBITMAP tbab;
   TBBUTTON tbb;
   INT_PTR StringIndex ;
   int BitMapIndex = 0;
   HBITMAP hBitmap = NULL;
   int Style = TBSTYLE_BUTTON ;
   TCHAR *text;

   // AutoSize
   if ( hb_parl(6) )
      Style = Style | TBSTYLE_AUTOSIZE ;

   // Check
   if ( hb_parl(7) )
      Style = Style | BTNS_CHECK ;

   // Group
   if ( hb_parl(8) )
      Style = Style | BTNS_GROUP ;

   // DropDown
   if ( hb_parl(9) )
      Style = Style | BTNS_DROPDOWN ;


   // WholeDropDown
   if ( hb_parl(10) )
      Style = Style | BTNS_WHOLEDROPDOWN ;


   // Add bitmap.

   int Transparent = hb_parl(13) ? 0 : 1;
                                                                      //    ScaleStretch, Transparent, BackgroundColor,  AdjustImage,   TransparentColor
   hBitmap = HMG_LoadPicture ((TCHAR*) HMG_parc(2) , -1, -1, (HWND) hwndTB,            0, Transparent,              -1,            0,                 -1 ) ;

   tbab.hInst = NULL;
   tbab.nID   = (UINT_PTR) (HBITMAP) hBitmap;

   if (hBitmap != NULL)
      BitMapIndex = SendMessage (hwndTB, TB_ADDBITMAP, (WPARAM) 1, (LPARAM) &tbab);
   else
      BitMapIndex = -1;   // ADD


   // Add string.
   text = (TCHAR *) HMG_parc(3);
   StringIndex = SendMessage (hwndTB, TB_ADDSTRING, (WPARAM) 0, (LPARAM) text );

   // Fill the TBBUTTON array.
   tbb.iBitmap   = BitMapIndex ;
   tbb.idCommand = hb_parni(4) ;
   tbb.fsState   = TBSTATE_ENABLED;
   tbb.fsStyle   = Style ;
   tbb.dwData    = 0;
   tbb.iString   = StringIndex ;

   SendMessage (hwndTB, TB_BUTTONSTRUCTSIZE, (WPARAM) sizeof (TBBUTTON), 0);   // ADD
   SendMessage (hwndTB, TB_ADDBUTTONS, (WPARAM) 1 , (LPARAM) (LPTBBUTTON) &tbb);


   // Separator
   if ( hb_parl (5) )
   {
      tbb.iBitmap = 0 ;
      tbb.idCommand = 0 ;
      tbb.fsState = TBSTATE_ENABLED ;
      tbb.dwData = 0;
      tbb.iString = 0 ;
      tbb.fsStyle = TBSTYLE_SEP ;

      SendMessage (hwndTB, TB_BUTTONSTRUCTSIZE, (WPARAM) sizeof (TBBUTTON), 0);   // ADD
      SendMessage (hwndTB, TB_ADDBUTTONS, (WPARAM) 1 , (LPARAM) (LPTBBUTTON) &tbb);
   }

   HMG_retnl ((LONG_PTR) hBitmap );
}


HB_FUNC( TB_REPLACEBITMAP )
{
   HWND    hwndTB     = (HWND)    HMG_parnl (1);
   HBITMAP hBitmapOld = (HBITMAP) HMG_parnl (2);
   int     nButtonID  = (int)     hb_parni  (5);
   int     BitMapIndex;
   int     Transparent = hb_parl(4) ? 0 : 1;
                                                                                 //    ScaleStretch, Transparent, BackgroundColor,  AdjustImage,   TransparentColor
   HBITMAP hBitmapNew = HMG_LoadPicture ((TCHAR*) HMG_parc(3) , -1, -1, (HWND) hwndTB,            0, Transparent,              -1,            0,                 -1 ) ;

   if(( hBitmapOld != NULL ) && ( hBitmapNew != NULL ))
   {
      TBREPLACEBITMAP tbrb;
      tbrb.hInstOld = NULL;
      tbrb.nIDOld   = (UINT_PTR) hBitmapOld;
      tbrb.hInstNew = NULL;
      tbrb.nIDNew   = (UINT_PTR) hBitmapNew;
      tbrb.nButtons = 1;
      SendMessage ( hwndTB, TB_REPLACEBITMAP, 0, (LPARAM) &tbrb );
   }
   else
   {
      if (hBitmapNew != NULL)
      {  TBADDBITMAP tbab;
         tbab.hInst = NULL;
         tbab.nID   = (UINT_PTR) hBitmapNew;
         BitMapIndex = SendMessage (hwndTB, TB_ADDBITMAP, (WPARAM) 1, (LPARAM) &tbab);
         //SendMessage ( hwndTB, TB_CHANGEBITMAP, (WPARAM) nButtonID, (LPARAM) BitMapIndex );
      }
      else
         BitMapIndex = -1;

      TBBUTTONINFO tbbi;
      ZeroMemory ( &tbbi, sizeof (tbbi) );
      tbbi.cbSize = sizeof (tbbi);
      tbbi.dwMask = TBIF_IMAGE;
      tbbi.iImage = BitMapIndex;
      SendMessage ( hwndTB, TB_SETBUTTONINFO, (WPARAM) nButtonID, (LPARAM) &tbbi );
   }

   HMG_retnl ((LONG_PTR) hBitmapNew );
}


HB_FUNC( GETTOOLBARHEIGHT )
{
   SIZE lpSize;
   SendMessage( (HWND) HMG_parnl (1), TB_GETMAXSIZE, 0, (LPARAM)&lpSize);
   hb_retni( lpSize.cy );
}


HB_FUNC( GETTOOLBARWIDTH )
{
   SIZE lpSize;
   int i ;
   int ButtonCount ;
   TBBUTTON tbb;
   OSVERSIONINFO osvi;

   SendMessage ((HWND) HMG_parnl(1), TB_GETMAXSIZE, 0, (LPARAM)&lpSize);

   osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
   GetVersionEx(&osvi);

   ButtonCount = SendMessage ((HWND) HMG_parnl(1), TB_BUTTONCOUNT, 0, 0);

   for ( i = 0 ; i < ButtonCount ; i++ )
   {
      SendMessage( (HWND) HMG_parnl(1),TB_GETBUTTON, (WPARAM) i, (LPARAM)  &tbb);

      if (osvi.dwPlatformId != VER_PLATFORM_WIN32_NT )
      {
         if (tbb.fsStyle & BTNS_DROPDOWN )
            lpSize.cx = lpSize.cx + 12 ;
      }
   }

   hb_retnl ( lpSize.cx );
}


// ----------------------------------------------------------------------------
// ActivateToolBar Function
// ----------------------------------------------------------------------------
//
// Parameters:
//
// 1. ToolBar Handle
//
// ----------------------------------------------------------------------------
HB_FUNC ( ACTIVATETOOLBAR )
{
   HWND hwndTB = (HWND) HMG_parnl (1);
   SendMessage( hwndTB ,TB_AUTOSIZE,0,0);
}


HB_FUNC ( SHOWTOOLBUTTONTIP )
{
   LPTOOLTIPTEXT lpttt;
   lpttt = (LPTOOLTIPTEXT) HMG_parnl (1);
   lpttt->hinst = GetModuleHandle (NULL) ;
   lpttt->lpszText =  (LPTSTR) HMG_parc(2) ;
}

HB_FUNC ( GETTOOLBUTTONID )
{
   LPTOOLTIPTEXT lpttt;
   lpttt = (LPTOOLTIPTEXT) HMG_parnl (1);
   hb_retni ( lpttt->hdr.idFrom ) ;
}

HB_FUNC ( GETTOOLBUTTONDDID )
{
   hb_retnl( (((NMTOOLBAR FAR *) HMG_parnl (1))->iItem) );
}

HB_FUNC( GETTOOLBUTTONSIZE )
{

	RECT rc;
	SendMessage( (HWND) HMG_parnl(1), TB_GETITEMRECT,(WPARAM) hb_parnl(2),(LPARAM) &rc);
	hb_retnl( MAKELONG(rc.left,rc.bottom) );

	hb_reta( 2 );
	hb_storvni( (INT) rc.left , -1, 1 );
	hb_storvni( (INT) rc.bottom , -1, 2 );

 }

HB_FUNC (ISTOOLBUTTONCHECKED)
{
   int r;
   TBBUTTON lpBtn;

   if ( HB_ISNUM (3) )
      r = SendMessage ( (HWND) HMG_parnl(1), TB_ISBUTTONCHECKED, (WPARAM) hb_parni(3), 0 );   // ADD
   else
   {   SendMessage ( (HWND) HMG_parnl(1), TB_GETBUTTON, (WPARAM) hb_parni(2), (LPARAM) &lpBtn );
       r = SendMessage ( (HWND) HMG_parnl(1), TB_ISBUTTONCHECKED, (WPARAM) lpBtn.idCommand, 0 );
   }

   if ( r == 0 )
      hb_retl ( FALSE );
   else
      hb_retl ( TRUE );
}

HB_FUNC( CHECKTOOLBUTTON )
{
   TBBUTTON lpBtn;

   if ( HB_ISNUM (4) )
      SendMessage( (HWND) HMG_parnl (1), TB_CHECKBUTTON , (WPARAM) hb_parni(4) , (LPARAM) hb_parl(3) );   // ADD
   else
   {   SendMessage( (HWND) HMG_parnl (1), TB_GETBUTTON, (WPARAM) hb_parni(2), (LPARAM)  &lpBtn);
       SendMessage( (HWND) HMG_parnl (1), TB_CHECKBUTTON , (WPARAM) lpBtn.idCommand , (LPARAM) hb_parl(3) );
   }
}

HB_FUNC( ENABLETOOLBUTTON )
{

   long RetVal;
   RetVal = SendMessage( (HWND) HMG_parnl (1), TB_ENABLEBUTTON, (WPARAM) hb_parni(2), (LPARAM) MAKELONG(1,0));
   hb_retnl( RetVal );

}

HB_FUNC( DISABLETOOLBUTTON )
{

   long RetVal;
   RetVal = SendMessage( (HWND) HMG_parnl (1), TB_ENABLEBUTTON, (WPARAM) hb_parni(2), (LPARAM) MAKELONG(0,0));
   hb_retnl( RetVal );

}

HB_FUNC( SETTOOLBUTTONCAPTION )
{

	TBBUTTONINFO tbinfo ;
	tbinfo.cbSize = sizeof(tbinfo) ;
	tbinfo.dwMask = TBIF_TEXT ;
	tbinfo.pszText =  (LPTSTR) HMG_parc(3) ;

	SendMessage( (HWND) HMG_parnl (1), TB_SETBUTTONINFO, (WPARAM) hb_parni(2) , (LPARAM)&tbinfo) ;

}

