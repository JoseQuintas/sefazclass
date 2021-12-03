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




//#define ENM_CHANGE        1       // ok
//#define ENM_KEYEVENTS     65536   // ok
//#define EM_SETEVENTMASK   1093    // ok
//#define EM_SETEVENTMASK   (WM_USER+69)   // ok (MinGW)


//#define _WIN32_IE      0x0500
//#define HB_OS_WIN_32_USED
//#define _WIN32_WINNT   0x0400


#include <shlobj.h>
#include <windows.h>
#include <commctrl.h>
#include <richedit.h>
#include <winreg.h>
#include <tchar.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"


HB_FUNC( INITMASKEDTEXTBOX )
{
	HWND hwnd;
	HWND hbutton;

	int Style ;

	hwnd = (HWND) HMG_parnl (1);

	Style = WS_CHILD | ES_AUTOHSCROLL ;

	if ( hb_parl (9) )
	{
		Style = Style | ES_UPPERCASE ;
	}

	if ( hb_parl (10) )
	{
		Style = Style | ES_LOWERCASE ;
	}

	if ( hb_parl (12) )
	{
		Style = Style | ES_RIGHT ;
	}

	if ( hb_parl (13) )
	{
		Style = Style | ES_READONLY;
	}

	if ( ! hb_parl (14) )
	{
		Style = Style | WS_VISIBLE ;
	}

	if ( ! hb_parl (15) )
	{
		Style = Style | WS_TABSTOP ;
	}

	hbutton = CreateWindowEx( WS_EX_CLIENTEDGE , WC_EDIT /*_TEXT("Edit")*/ ,
   _TEXT("") , Style,
	hb_parni(3), hb_parni(4) , hb_parni(5) , hb_parni(11) ,
	hwnd,(HMENU) HMG_parnl (2), GetModuleHandle(NULL) , NULL ) ;

	HMG_retnl ((LONG_PTR) hbutton );
}

HB_FUNC( INITTEXTBOX )
{
  HWND hwnd;         // Handle of the parent window/form.
  HWND hedit;        // Handle of the child window/control.
  int  iStyle;       // TEXTBOX window base style.

  // Get the handle of the parent window/form.
  hwnd = (HWND) HMG_parnl(1);

  iStyle = WS_CHILD | ES_AUTOHSCROLL;

  if ( hb_parl(12) ) // if <lNumeric> is TRUE, then ES_NUMBER style is added.
  {
    iStyle = iStyle | ES_NUMBER ;
    // Set to a numeric TEXTBOX, so don't worry about other "textual" styles.
  }
  else
  {

    if ( hb_parl(10) ) // if <lUpper> is TRUE, then ES_UPPERCASE style is added.
    {
      iStyle = iStyle | ES_UPPERCASE;
    }

    if ( hb_parl(11) )  // if <lLower> is TRUE, then ES_LOWERCASE style is added.
    {
      iStyle = iStyle | ES_LOWERCASE;
    }

  }

  if ( hb_parl(13) )  // if <lPassword> is TRUE, then ES_PASSWORD style is added.
  {
    iStyle = iStyle | ES_PASSWORD;
  }

  if ( hb_parl(14) )
  {
    iStyle = iStyle | ES_RIGHT;
  }

  if ( hb_parl (15) )
  {
    iStyle = iStyle | ES_READONLY;
  }

	if ( ! hb_parl (16) )
	{
		iStyle = iStyle | WS_VISIBLE ;
	}

	if ( ! hb_parl (17) )
	{
		iStyle = iStyle | WS_TABSTOP ;
	}

  // Creates the child control.
  hedit = CreateWindowEx( WS_EX_CLIENTEDGE , WC_EDIT /*_TEXT("Edit")*/ ,
                         _TEXT(""), iStyle,
                         hb_parni(3),
                         hb_parni(4),
                         hb_parni(5),
                         hb_parni(6),
                         hwnd,
                         (HMENU) HMG_parnl(2),
                         GetModuleHandle(NULL),
                         NULL);

	SendMessage(hedit, EM_LIMITTEXT, (WPARAM)hb_parnl(9), 0);

	HMG_retnl ((LONG_PTR) hedit );

}

HB_FUNC( INITCHARMASKTEXTBOX )
{
	HWND hwnd;
	HWND hbutton;

	int Style ;

	hwnd = (HWND) HMG_parnl (1);

	Style = WS_CHILD | ES_AUTOHSCROLL ;

	if ( hb_parl (9) )
	{
		Style = Style | ES_UPPERCASE ;
	}

	if ( hb_parl (10) )
	{
		Style = Style | ES_LOWERCASE ;
	}

	if ( hb_parl (12) )
	{
		Style = Style | ES_RIGHT ;
	}

	if ( hb_parl (13) )
	{
		Style = Style | ES_READONLY;
	}

	if ( ! hb_parl (14) )
	{
		Style = Style | WS_VISIBLE ;
	}

	if ( ! hb_parl (15) )
	{
		Style = Style | WS_TABSTOP ;
	}

	hbutton = CreateWindowEx( WS_EX_CLIENTEDGE , WC_EDIT /*_TEXT("Edit")*/ ,
   _TEXT("") , Style,
	hb_parni(3), hb_parni(4) , hb_parni(5) , hb_parni(11) ,
	hwnd,(HMENU) HMG_parnl (2), GetModuleHandle(NULL) , NULL ) ;

	HMG_retnl ((LONG_PTR) hbutton );
}


HB_FUNC( SETTEXTEDITREADONLY )
{
	SendMessage( (HWND) HMG_parnl (1), EM_SETREADONLY, (WPARAM)hb_parl(2), 0);
}


