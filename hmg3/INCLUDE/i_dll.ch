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
	Copyright 1999-2003, http://www.harbour-project.org/

	"WHAT32"
	Copyright 2002 AJ Wos <andrwos@aust1.net> 

	"HWGUI"
  	Copyright 2001-2007 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/

//FLAGS

#define  DC_MICROSOFT           0x0000      
#define  DC_BORLAND             0x0001      
#define  DC_CALL_CDECL          0x0010      
#define  DC_CALL_STD            0x0020      

// TYPES

#define DLL_TYPE_VOID           0
#define DLL_TYPE_UINT          -3 
#define DLL_TYPE_INT            3 
#define DLL_TYPE_HANDLE        -4 
#define DLL_TYPE_HICON         -4 
#define DLL_TYPE_HBITMAP       -4 
#define DLL_TYPE_HCURSOR       -4 
#define DLL_TYPE_HBRUSH        -4 
#define DLL_TYPE_LPCSTR        10 
#define DLL_TYPE_WNDPROC       -4 
#define DLL_TYPE_BOOL           4 
#define DLL_TYPE_LPVOID         7 
#define DLL_TYPE_DWORD         -4 
#define DLL_TYPE_WORD          -2 
#define DLL_TYPE_LPCTSTR       10 
#define DLL_TYPE_COLORREF      -4 
#define DLL_TYPE_BYTE           1 
#define DLL_TYPE_TCHAR         -1 
#define DLL_TYPE_HINSTANCE     -4 
#define DLL_TYPE_HWND          -4 
#define DLL_TYPE_LPARAM         4 
#define DLL_TYPE_HGLOBAL       -4 
#define DLL_TYPE_WPARAM         3 
#define DLL_TYPE_HKEY          -4 
#define DLL_TYPE_CHAR          -1 
#define DLL_TYPE_LONG           4 
#define DLL_TYPE_BCHAR         -1 
#define DLL_TYPE_WCHAR         -2 
#define DLL_TYPE_DOUBLE         6 
#define DLL_TYPE_LPTSTR        10 
#define DLL_TYPE_LPSTR         10 
#define DLL_TYPE_ULONG         -4 
#define DLL_TYPE_UCHAR         -1 
#define DLL_TYPE_SHORT          2
#define DLL_TYPE_USHORT        -2 
#define DLL_TYPE_LPOFNHOOKPROC   -4 
#define DLL_TYPE_LPCFHOOKPROC    -4
#define DLL_TYPE_LPFRHOOKPROC    -4
#define DLL_TYPE_LPPAGESETUPHOOK -4
#define DLL_TYPE_LPPAGEPAINTHOOK -4
#define DLL_TYPE_LPPRINTHOOKPROC -4  
#define DLL_TYPE_LPSETUPHOOKPROC -4  
#define DLL_TYPE_BFFCALLBACK     -4 
#define DLL_TYPE_HDC           -4  
#define DLL_TYPE_HIMAGELIST    -4


#xcommand DECLARE <return> [<static:STATIC>] <FuncName>( [ <type1> <uParam1>  ] ;
                                                     [, <typeN> <uParamN> ] ) ;
             IN <*DllName*> [FLAGS <flags>]  ;
       => ;
	[<static>] function <FuncName> ( [<uParam1>] [,<uParamN>] ) ;;
	local uResult ;;
	uResult = CallDLL32( <(FuncName)> , <(DllName)> [, <uParam1> ] [, <uParamN> ] ) ;;
	return uResult

#xcommand DECLARE <return> [<static:STATIC>] <FuncName>( [ <type1> <uParam1>  ] ;
                                                     [, <typeN> <uParamN> ] ) ;
             IN <DllName> ALIAS <alias> [FLAGS <flags>]  ;
       => ;
	[<static>] function <alias> ( [<uParam1>] [,<uParamN>] ) ;;
	local uResult ;;
	uResult = CallDLL32( <(FuncName)> , <(DllName)> [, <uParam1> ] [, <uParamN> ] ) ;;
	return uResult



