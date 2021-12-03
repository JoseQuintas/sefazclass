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
//#define UDM_SETPOS32 (WM_USER+113)
//#define UDM_GETPOS32 (WM_USER+114)
//#endif

#include <shlobj.h>
#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"

HFONT PrepareFont (TCHAR *Fontname, int FontSize, int Weight, int Italic, int Underline, int StrikeOut )
{
   HDC  hDC;
   int cyp;

	hDC = GetDC ( HWND_DESKTOP ) ;

	cyp = GetDeviceCaps ( hDC, LOGPIXELSY ) ;

	ReleaseDC ( HWND_DESKTOP, hDC ) ;

	FontSize = ( FontSize * cyp ) / 72 ;

	return CreateFont ( 0-FontSize, 0, 0, 0, Weight, Italic, Underline, StrikeOut,
		DEFAULT_CHARSET, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS,
		DEFAULT_QUALITY, FF_DONTCARE, Fontname ) ;
}

HB_FUNC ( _SETFONT )
{
	HFONT font ;
	int bold = FW_NORMAL;
	int italic = 0;
	int underline = 0;
	int strikeout = 0;

	if ( hb_parl (4) )
	{
		bold = FW_BOLD;
	}

	if ( hb_parl (5) )
	{
		italic = 1;
	}

	if ( hb_parl (6) )
	{
		underline = 1;
	}

	if ( hb_parl (7) )
	{
		strikeout = 1;
	}

	font = PrepareFont ( (TCHAR*) HMG_parc(2), hb_parni(3), bold, italic, underline, strikeout ) ;

	SendMessage( (HWND) HMG_parnl (1), (UINT) WM_SETFONT, (WPARAM) font, (LPARAM) TRUE ) ;

	HMG_retnl ((LONG_PTR) font );
}


//        SetFontNameSize ( hWnd , cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout )
HB_FUNC ( SETFONTNAMESIZE )
{
	int bold = FW_NORMAL;
	int italic = 0;
	int underline = 0;
	int strikeout = 0;

	if ( hb_parl (4) )
	{
		bold = FW_BOLD;
	}

	if ( hb_parl (5) )
	{
		italic = 1;
	}

	if ( hb_parl (6) )
	{
		underline = 1;
	}

	if ( hb_parl (7) )
	{
		strikeout = 1;
	}

	SendMessage( (HWND) HMG_parnl(1), (UINT) WM_SETFONT , (WPARAM) PrepareFont ((TCHAR*)HMG_parc(2), hb_parni(3),bold,italic,underline,strikeout) , (LPARAM) TRUE );
}



//*****************************************************************************************************************//
//*   by Dr. Claudio Soto (January 2014)                                                                             *//
//*****************************************************************************************************************//


//        GetWindowFont ( hWnd ) --> hFont
HB_FUNC ( GETWINDOWFONT )
{
   HWND  hWnd  = (HWND) HMG_parnl (1);
   HFONT hFont = (HFONT) SendMessage ( hWnd, WM_GETFONT, 0, 0 );
   HMG_retnl ((LONG_PTR) hFont);
}


//        SetWindowFont ( hWnd, hFont, lRedraw )
HB_FUNC ( SETWINDOWFONT )
{
   HWND  hWnd    = (HWND)  HMG_parnl (1);
   HFONT hFont   = (HFONT) HMG_parnl (2);
   BOOL  fRedraw = HB_ISNIL (3) ? TRUE : (BOOL) hb_parl (3);
   SendMessage ( hWnd, WM_SETFONT, (WPARAM) hFont,  MAKELPARAM (fRedraw, 0) );
}



//        HMG_CreateFont ( [ hDC ] , cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeOut ) --> hFont
HB_FUNC ( HMG_CREATEFONT )
{
   HFONT hFont;
   HDC  hDC;
   TCHAR *cFontName;
   INT nFontSize;
   INT nBold, nItalic, nUnderline, nStrikeOut;
   INT nOrientation = 0;

   if ( HB_ISNIL (1) || HMG_parnl (1) == 0)
      hDC = GetDC ( GetDesktopWindow() );
   else
      hDC = (HDC) HMG_parnl (1);

   cFontName   = (TCHAR *) HMG_parc  (2);
   nFontSize   = (INT)     hb_parni  (3);
   nBold       = hb_parl (4) ? FW_BOLD : FW_NORMAL;
   nItalic     = hb_parl (5) ? 1 : 0;
   nUnderline  = hb_parl (6) ? 1 : 0;
   nStrikeOut  = hb_parl (7) ? 1 : 0;

   nFontSize = nFontSize * GetDeviceCaps (hDC, LOGPIXELSY) / 72;

        // CreateFont (Height, Width, Escapement, Orientation, Weight, Italic, Underline, StrikeOut,
        //             CharSet, OutputPrecision, ClipPrecision, Quality, PitchAndFamily, Face);
   hFont = CreateFont (0-nFontSize, 0, nOrientation, nOrientation, nBold, nItalic, nUnderline, nStrikeOut,
           DEFAULT_CHARSET, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_DONTCARE, cFontName);

   HMG_retnl ((LONG_PTR) hFont);

  if ( HB_ISNIL (1) || HMG_parnl (1) == 0 )
      ReleaseDC (GetDesktopWindow(), hDC);

}

