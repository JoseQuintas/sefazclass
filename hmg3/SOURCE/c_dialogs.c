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


#define MINIMUM_WEIGHT_BOLD   550


//#define _WIN32_IE      0x0500
//#define HB_OS_WIN_32_USED
//#define _WIN32_WINNT   0x0400


#include <shlobj.h>
#include <windows.h>
#include <commctrl.h>
#include <tchar.h>

#include "hbthread.h"
#include "hbvm.h"
#include "hbapiitm.h"
#include "hbapi.h"

extern HB_CRITICAL_T _HMG_Mutex;   // global Mutex variable defined into c_Thread.c

HB_FUNC( GETNEXTDLGTABITEM )
{
 // hwndCtrl = GetNextDlgTabItem( hDlg, hwndCtrl, bPrevious );
   HWND hWnd = GetNextDlgTabItem( (HWND) HMG_parnl(1), (HWND) HMG_parnl(2), hb_parl(3) );
   HMG_retnl ((LONG_PTR) hWnd );
}


HB_FUNC ( CHECKDLGBUTTON )
{
   CheckDlgButton ((HWND) HMG_parnl(1), hb_parni(2), (hb_parl(3) ? BST_CHECKED : BST_UNCHECKED));
}


HB_FUNC ( ISDLGBUTTONCHECKED )
{
   UINT r = IsDlgButtonChecked ((HWND) HMG_parnl(1), hb_parni(2));
   hb_retl ((BOOL) (r == BST_CHECKED ? TRUE : FALSE));
}


HB_FUNC ( SETDLGITEMTEXT )
{
   SetDlgItemText ((HWND) HMG_parnl(1), hb_parni(2), (LPCTSTR) HMG_parc(3));
}


HB_FUNC( GETDLGITEMTEXT )
{
   HWND hDlg  = (HWND) HMG_parnl (1);
   INT  id    = (INT)  hb_parni  (2);
   INT  nLen  = (INT)  SendMessage (GetDlgItem (hDlg, id), WM_GETTEXTLENGTH, 0, 0);
   TCHAR cText [ nLen + 2 ];
   GetDlgItemText (hDlg, id, (LPTSTR) cText, nLen + 1);
   HMG_retc (cText);
}


HB_FUNC( SETDLGITEMINT )
{
   SetDlgItemInt ((HWND) HMG_parnl(1), (INT) hb_parni(2), (UINT) hb_parni(3), (BOOL) hb_parl(4));
}


HB_FUNC( GETDLGITEMINT )
{
   BOOL bTranslated;
   hb_retni ((INT) GetDlgItemInt((HWND) HMG_parnl(1), (INT) hb_parni(2), &bTranslated, (BOOL) hb_parl(4)));
   if (HB_ISBYREF (3))
      hb_storl (bTranslated, 3);
}


HB_FUNC( ENDDIALOG )
{
   EndDialog ((HWND) HMG_parnl(1), hb_parni(2));
}


HB_FUNC( GETDLGITEM )
{
   HWND CtrlItem = GetDlgItem ((HWND) HMG_parnl (1), hb_parni (2));
   HMG_retnl ((LONG_PTR) CtrlItem);
}


HB_FUNC( GETDLGCTRLID )
{
   hb_retni ((INT) GetDlgCtrlID ((HWND) HMG_parnl (1)));
}


HB_FUNC ( SENDDLGITEMMESSAGE )
{
   SendDlgItemMessage ((HWND) HMG_parnl(1), (INT) hb_parni(2), (UINT) hb_parni(3), (WPARAM) HMG_parnl(4), (LPARAM) HMG_parnl(5));
}


/*
HB_FUNC ( MB_GETSTRING )
{
   HMG_retc ((LPCWSTR) MB_GetString ((UINT) hb_parni(1)));
}
*/


/*********************************************************************************************************************/


HB_FUNC ( CHOOSEFONT )
{
   CHOOSEFONT cf;
   LOGFONT    lf;
   long PointSize;
   BOOL lBold;
   HWND hWnd;
   HDC  hDC;

   hWnd = HB_ISNIL(1) ? GetActiveWindow() : (HWND) HMG_parnl (1);
   hDC  = GetDC ( hWnd );

   ZeroMemory ( &lf, sizeof (lf) );

   lstrcpy ( lf.lfFaceName , HMG_parc(2) );

   lf.lfHeight = - MulDiv ( hb_parnl(3), GetDeviceCaps (hDC, LOGPIXELSY), 72 );

   if ( hb_parl (4) )
      lf.lfWeight = FW_BOLD;
   else
      lf.lfWeight = FW_NORMAL;

   if ( hb_parl (5) )
      lf.lfItalic = TRUE ;
   else
      lf.lfItalic = FALSE ;

   if ( hb_parl (7) )
      lf.lfUnderline = TRUE ;
   else
      lf.lfUnderline = FALSE ;

   if ( hb_parl (8) )
      lf.lfStrikeOut = TRUE ;
   else
      lf.lfStrikeOut = FALSE ;

   lf.lfCharSet = HB_ISNIL (9) ? DEFAULT_CHARSET :(BYTE) hb_parni (9);

   ZeroMemory ( &cf, sizeof (cf) );

   cf.lStructSize = sizeof (CHOOSEFONT);
   cf.hwndOwner = hWnd;
   cf.lpLogFont = &lf;
   cf.Flags = CF_INITTOLOGFONTSTRUCT | CF_EFFECTS | CF_FORCEFONTEXIST | CF_SCREENFONTS;
   cf.rgbColors = hb_parnl (6) ;


   if ( ChooseFont (&cf) )
   {
      PointSize = - MulDiv ( lf.lfHeight, 72, GetDeviceCaps (hDC, LOGPIXELSY) );

      if ( lf.lfWeight >= MINIMUM_WEIGHT_BOLD )
         lBold = TRUE;
      else
         lBold = FALSE;

      hb_reta( 8 );
      HMG_storvc (       lf.lfFaceName,  -1, 1 );
      hb_storvnl ((LONG) PointSize,      -1, 2 );
      hb_storvl  ((BOOL) lBold,          -1, 3 );
      hb_storvl  ((BOOL) lf.lfItalic,    -1, 4 );
      hb_storvnl ((LONG) cf.rgbColors,   -1, 5 );
      hb_storvl  ((BOOL) lf.lfUnderline, -1, 6 );
      hb_storvl  ((BOOL) lf.lfStrikeOut, -1, 7 );
      hb_storvni ((INT)  lf.lfCharSet,   -1, 8 );
   }
   else
   {
      hb_reta( 8 );
      HMG_storvc (       _TEXT(""),  -1, 1 );
      hb_storvnl ((LONG) 0,          -1, 2 );
      hb_storvl  ((BOOL) 0,          -1, 3 );
      hb_storvl  ((BOOL) 0,          -1, 4 );
      hb_storvnl ((LONG) 0,          -1, 5 );
      hb_storvl  ((BOOL) 0,          -1, 6 );
      hb_storvl  ((BOOL) 0,          -1, 7 );
      hb_storvni ((INT)  0,          -1, 8 );
   }

   ReleaseDC ( hWnd, hDC );
}



HB_FUNC ( C_GETFILE )
{
   #define _MAXMULTISELECTFILE   1024
   OPENFILENAME ofn;
   TCHAR buffer    [ _MAXMULTISELECTFILE  *  MAX_PATH ];
   TCHAR cFullName [ _MAXMULTISELECTFILE ] [ MAX_PATH ];
   TCHAR cCurDir   [ MAX_PATH ];
   TCHAR cFileName [ MAX_PATH ];
   int iPosition    = 0;
   int iNumSelected = 0;

   int flags = OFN_FILEMUSTEXIST | OFN_EXPLORER;

   memset ((void*)&buffer, 0, sizeof(buffer));

   if ( hb_parl(4) )
      flags = flags | OFN_ALLOWMULTISELECT ;

   if ( hb_parl(5) )
      flags = flags | OFN_NOCHANGEDIR ;



//******************************************************************************************************//
// ofn.lpstrFilter = A buffer containing pairs of null-terminated filter strings.
//                   The last string in the buffer must be terminated by two NULL characters.
// The following code converts a ANSI (CHAR) filter string into a UNICODE (UNSIGNED INT) filter string

   #define _MAX_FILTER 5*1024
   INT i, j=0, cont=0;
   CHAR *p = (CHAR*) hb_parc(1);
   TCHAR Filter [ _MAX_FILTER ];
   memset((void*) &Filter, 0, sizeof(Filter));

   for (i=0; *p != '\0'; i++)
   {  cont = cont + strlen (p) + 1;
      if (cont < _MAX_FILTER)
      {   lstrcpy ( &Filter[j], HMG_CHAR_TO_WCHAR(p) );
          j = j + lstrlen ( HMG_CHAR_TO_WCHAR (p) ) + 1;
          p = p + strlen (p) + 1;
      }
      else
         break;
   }
//**********************************************************************//

   memset( (void*) &ofn, 0, sizeof( OPENFILENAME ) );

   ofn.lStructSize      = sizeof(OPENFILENAME);
   ofn.hwndOwner        = GetActiveWindow();
   ofn.lpstrFilter      = (LPCTSTR) &Filter;
   ofn.nFilterIndex     = ((hb_parni(6) > 0) ? (DWORD) hb_parni(6) : 1);
   ofn.lpstrFile        = (LPTSTR) &buffer;
   ofn.nMaxFile         = sizeof(buffer) / sizeof(TCHAR);
   ofn.lpstrInitialDir  = (LPCTSTR) HMG_parc(3);
   ofn.lpstrTitle       = (LPCTSTR) HMG_parc(2);
   ofn.Flags            = flags;

   if( GetOpenFileName (&ofn) )
   {
      if ( ofn.nFileExtension !=0 )
         HMG_retc (ofn.lpstrFile);
      else
      {
         wsprintf ( cCurDir, _TEXT("%s"), &buffer [iPosition] );
         iPosition = iPosition + lstrlen (cCurDir) + 1;
         do
         {
            iNumSelected ++;
            wsprintf ( cFileName, _TEXT("%s"), &buffer [iPosition] );
            iPosition = iPosition + lstrlen (cFileName) + 1;
            wsprintf ( cFullName [iNumSelected], _TEXT("%s\\%s"), cCurDir, cFileName);
         }
         while (( lstrlen(cFileName) !=0 ) && ( iNumSelected < _MAXMULTISELECTFILE ));

         if (iNumSelected > 1)
         {
            hb_reta (iNumSelected - 1);
            for (i = 1; i < iNumSelected; i++)
               HMG_storvc (cFullName[i], -1, i );
         }
         else
            HMG_retc( &buffer[0] );
      }
   }
   else
      HMG_retc( _TEXT("") );
}



HB_FUNC ( C_PUTFILE )
{

 OPENFILENAME ofn;
 TCHAR buffer[1024];

 int flags = OFN_OVERWRITEPROMPT | OFN_EXPLORER ;

 if ( hb_parl(4) )
 {
  flags = flags | OFN_NOCHANGEDIR ;
 }

//******************************************************************************************************//
// ofn.lpstrFilter = A buffer containing pairs of null-terminated filter strings.
//                   The last string in the buffer must be terminated by two NULL characters.
// The following code converts a ANSI (CHAR) filter string into a UNICODE (UNSIGNED INT) filter string

   #define _MAX_FILTER 5*1024
   INT i, j=0, cont=0;
   CHAR *p = (CHAR*) hb_parc(1);
   TCHAR Filter [_MAX_FILTER];
   memset((void*) &Filter, 0, sizeof(Filter));

   for (i=0; *p != '\0'; i++)
   {  cont = cont + strlen (p) + 1;
      if (cont < _MAX_FILTER)
      {   lstrcpy ( &Filter[j], HMG_CHAR_TO_WCHAR (p) );
          j = j + lstrlen ( HMG_CHAR_TO_WCHAR (p) ) + 1;
          p = p + strlen (p) + 1;
      }
      else
         break;
   }
//**********************************************************************//

 lstrcpy (buffer, HMG_parc(5));

 memset( (void*) &ofn, 0, sizeof( OPENFILENAME ) );
 ofn.lStructSize = sizeof(OPENFILENAME);
 ofn.hwndOwner = GetActiveWindow() ;
 ofn.lpstrFilter = (LPCTSTR) &Filter;
 ofn.nFilterIndex = ((hb_parni(7)) > 0 ? (DWORD) hb_parni(7) : 1);
 ofn.lpstrFile = (LPTSTR) &buffer;
 ofn.nMaxFile = sizeof(buffer) / sizeof(TCHAR);
 ofn.lpstrInitialDir = (LPCTSTR) HMG_parc(3);
 ofn.lpstrTitle = (LPCTSTR) HMG_parc(2);
 ofn.Flags = flags;
 ofn.lpstrDefExt = (LPCTSTR) HMG_parc(6);

 if ( GetSaveFileName (&ofn) )
 {
     if (HB_ISBYREF(6))
     {  if (ofn.nFileExtension > ofn.nFileOffset)
            HMG_storc (&ofn.lpstrFile [ofn.nFileExtension], 6);
        else
            HMG_storc (_TEXT(""), 6);
     }

     if (HB_ISBYREF(7))
        hb_storni ((INT) ofn.nFilterIndex, 7);

     HMG_retc(ofn.lpstrFile);
 }
 else
     HMG_retc( _TEXT("") );
}


HB_FUNC ( CHOOSECOLOR )
{
   CHOOSECOLOR cc ;
   COLORREF crCustClr[16] ;
   int i ;

   for( i = 0 ; i <16 ; i++ )
   {  if ( HB_ISARRAY(3) )
          crCustClr[i] = hb_parvnl (3, i+1);
      else
          crCustClr[i] = GetSysColor ( COLOR_BTNFACE );
   }

   ZeroMemory ( &cc, sizeof(cc) );

   cc.lStructSize    = sizeof ( CHOOSECOLOR ) ;
   cc.hwndOwner      = HB_ISNIL(1) ? GetActiveWindow() : (HWND) HMG_parnl (1);
   cc.rgbResult      = (COLORREF) HB_ISNIL(2) ?  0 : hb_parnl (2);
   cc.lpCustColors   = crCustClr ;
   cc.Flags          = CC_ANYCOLOR | CC_RGBINIT  | ( hb_parl (4) ? CC_FULLOPEN : CC_PREVENTFULLOPEN ) ;

   if ( ChooseColor (&cc) )
      hb_retnl ( cc.rgbResult );
   else
      hb_retnl ( -1 );


   if ( HB_ISBYREF (3) )   // Dr. Claudio Soto, January 2014
   {
       PHB_ITEM pArray = hb_param (3, HB_IT_ANY );
       hb_arrayNew ( pArray, 16 );
       PHB_ITEM pSubarray = hb_itemNew ( NULL );

       for ( i=0; i < 16; i++ )
       {
           hb_arrayNew   ( pSubarray, 3 );
           hb_arraySetNL ( pSubarray, 1, GetRValue (crCustClr[i]) );
           hb_arraySetNL ( pSubarray, 2, GetGValue (crCustClr[i]) );
           hb_arraySetNL ( pSubarray, 3, GetBValue (crCustClr[i]) );

           hb_arraySet( pArray, i+1, pSubarray );
       }

       hb_itemRelease( pSubarray );
    }
}



// Dr. Claudio Soto (September 2013)


typedef struct {
    TCHAR *cInitPath;
    TCHAR *cInvalidDataMsg;
} BROWSEFORFOLDERTEXT;


int CALLBACK BrowseCallbackProc( HWND hWnd, UINT uMsg, LPARAM lParam, LPARAM lpData )
{

/*
Msg :
BFFM_INITIALIZED    : The dialog box has finished initializing.
BFFM_IUNKNOWN       : An IUnknown interface is available to the dialog box.
BFFM_SELCHANGED     : The selection has changed in the dialog box.
BFFM_VALIDATEFAILED : The user typed an invalid name into the dialog's edit box. A nonexistent folder is considered an invalid name.

SendMessage ()
BFFM_SETSELECTION   : Specifies the path of a folder to select. The path can be specified as a string or a PIDL.
BFFM_ENABLEOK       : Enables or disables the dialog box's OK button.
BFFM_SETOKTEXT      : Sets the text that is displayed on the dialog box's OK button.
BFFM_SETEXPANDED    : Specifies the path of a folder to expand in the Browse dialog box. The path can be specified as a Unicode string or a PIDL.
BFFM_SETSTATUSTEXT  : Sets the status text. Set theBrowseCallbackProc lpData parameter to point to a null-terminated string with the desired text.

*/

  TCHAR cTitle [ GetWindowTextLength(hWnd) + 1];

  GetWindowText(hWnd, cTitle, sizeof(cTitle)/sizeof(TCHAR));

  UNREFERENCED_PARAMETER (lParam);   // avoid warning message: lParam defined but not used

  BROWSEFORFOLDERTEXT *BrowseForFolderText = (BROWSEFORFOLDERTEXT *) lpData;

   switch( uMsg )
   {
      case BFFM_INITIALIZED:
           if (BrowseForFolderText->cInitPath)
               SendMessage( hWnd, BFFM_SETSELECTION, (WPARAM) TRUE, (LPARAM) BrowseForFolderText->cInitPath);
           break;

      case BFFM_VALIDATEFAILED:
           if (BrowseForFolderText->cInvalidDataMsg)
               MessageBox (hWnd, BrowseForFolderText->cInvalidDataMsg, cTitle, MB_ICONHAND | MB_OK | MB_SYSTEMMODAL);   // (TCHAR *)lParam ---> cFolderName
           else
               MessageBeep (MB_ICONHAND);
           return 1;
   }
   return 0;
}


//       c_GetFolder ( [<cTitle>], [<nFlags>], [<nCSIDL_FolderType>], [<cInvalidDataTitle>], [<cInitPath>] )
HB_FUNC( C_GETFOLDER )
{
   HWND           hWnd = GetActiveWindow();
   BROWSEINFO     BrowseInfo;
   TCHAR          cBuffer [ MAX_PATH ];
   LPITEMIDLIST   ItemIDList;

   SHGetSpecialFolderLocation ( hWnd, HB_ISNIL(3)? CSIDL_DRIVES : hb_parnl(3), &ItemIDList );

// BrowseInfo.ulFlags
// ------------------
// BIF_RETURNONLYFSDIRS   : Only return file system directories.
// BIF_DONTGOBELOWDOMAIN  : Do not include network folders below the domain level in the dialog box's tree view control.
// BIF_STATUSTEXT         : Include a status area in the dialog box ( not supported when BIF_NEWDIALOGSTYLE )
// BIF_RETURNFSANCESTORS  : Only return file system ancestors. An ancestor is a subfolder that is beneath the root folder in the namespace hierarchy.
// BIF_EDITBOX            : Include an edit control in the browse dialog box that allows the user to type the name of an item.
// BIF_VALIDATE           : If the user types an invalid name into the edit box, the browse dialog box calls the application's BrowseCallbackProc
//                          with the BFFM_VALIDATEFAILED message ( ignored if BIF_EDITBOX is not specified)
// BIF_NEWDIALOGSTYLE     : Use the new user interface. Setting this flag provides the user with a larger dialog box that can be resized.
//                          The dialog box has several new capabilities, including: drag-and-drop capability within the dialog box,
//                          reordering, shortcut menus, new folders, delete, and other shortcut menu commands.
// BIF_BROWSEINCLUDEURLS  : The browse dialog box can display URLs. The BIF_USENEWUI and BIF_BROWSEINCLUDEFILES flags must also be set.
// BIF_USENEWUI           : equivalent to BIF_EDITBOX + BIF_NEWDIALOGSTYLE.
// BIF_UAHINT             : When combined with BIF_NEWDIALOGSTYLE, adds a usage hint to the dialog box, in place of the edit box (BIF_EDITBOX overrides this flag)
// BIF_NONEWFOLDERBUTTON  : Do not include the New Folder button in the browse dialog box.
// BIF_NOTRANSLATETARGETS : When the selected item is a shortcut, return the PIDL of the shortcut itself rather than its target.
// BIF_BROWSEFORCOMPUTER  : Only return computers
// BIF_BROWSEFORPRINTER   : Only allow the selection of printers. In Windows XP and later systems, the best practice is to use a Windows XP-style dialog,
//                          setting the root of the dialog to the Printers and Faxes folder (CSIDL_PRINTERS).
// BIF_BROWSEINCLUDEFILES : The browse dialog box displays files as well as folders.
// BIF_SHAREABLE          : The browse dialog box can display sharable resources on remote systems. The BIF_NEWDIALOGSTYLE flag must also be set.
// BIF_BROWSEFILEJUNCTIONS: Windows 7 and later. Allow folder junctions such as a library or a compressed file with a .zip file name extension to be browsed.

   BROWSEFORFOLDERTEXT BrowseForFolderText;
   BrowseForFolderText.cInvalidDataMsg = (TCHAR *) HMG_parc (4);
   BrowseForFolderText.cInitPath = (TCHAR *) HMG_parc (5);

   BrowseInfo.hwndOwner      = hWnd;
   BrowseInfo.pidlRoot       = ItemIDList;
   BrowseInfo.pszDisplayName = cBuffer;
   BrowseInfo.lpszTitle      = HMG_parc (1);
   BrowseInfo.ulFlags        = hb_parnl (2);
   BrowseInfo.lpfn           = BrowseCallbackProc;
   BrowseInfo.lParam         = (LPARAM) &BrowseForFolderText;
   BrowseInfo.iImage         = 0;

   ItemIDList = SHBrowseForFolder( &BrowseInfo );

   if( ItemIDList )
   {
      SHGetPathFromIDList (ItemIDList, cBuffer);
      HMG_retc (cBuffer);
   }
   else
      HMG_retc (_TEXT(""));

   CoTaskMemFree ((LPVOID) ItemIDList);   // It is the responsibility of the calling application to call CoTaskMemFree to free the IDList returned
                                          // by SHBrowseForFolder when it is no longer needed.
}



//********************************************************************
// by Dr. Claudio Soto ( January 2014 )
//********************************************************************

#define MAX_FINDREPLACE   1024

static __TLS__ TCHAR cFindWhat     [ MAX_FINDREPLACE ];
static __TLS__ TCHAR cReplaceWith  [ MAX_FINDREPLACE ];
static __TLS__ FINDREPLACE FindReplace;
static __TLS__ HWND hDlgFindReplace = NULL;


HB_FUNC ( REGISTERFINDMSGSTRING )
{
   UINT MessageID  = RegisterWindowMessage ( FINDMSGSTRING );
   hb_retnl ((LONG) MessageID);
}


HB_FUNC ( FINDREPLACEDLG )
{
_THREAD_LOCK();
   HWND hWnd           = HB_ISNIL (1) ? GetActiveWindow() : (HWND) HMG_parnl (1);
   BOOL NoUpDown       = (BOOL) (HB_ISNIL (2) ? FALSE : hb_parl (2));
   BOOL NoMatchCase    = (BOOL) (HB_ISNIL (3) ? FALSE : hb_parl (3));
   BOOL NoWholeWord    = (BOOL) (HB_ISNIL (4) ? FALSE : hb_parl (4));
   BOOL CheckDown      = (BOOL) (HB_ISNIL (5) ? TRUE  : hb_parl (5));
   BOOL CheckMatchCase = (BOOL) (HB_ISNIL (6) ? FALSE : hb_parl (6));
   BOOL CheckWholeWord = (BOOL) (HB_ISNIL (7) ? FALSE : hb_parl (7));

   if ( hDlgFindReplace == NULL )
   {
      ZeroMemory( &FindReplace,  sizeof(FindReplace) );

      lstrcpy ( cFindWhat,    HMG_parc (8) );
      lstrcpy ( cReplaceWith, HMG_parc (9) );

      BOOL lReplace = (BOOL) hb_parl (10);

      FindReplace.lStructSize      = sizeof(FindReplace);
      FindReplace.Flags            =   (NoUpDown  ? FR_HIDEUPDOWN : 0) | (NoMatchCase    ? FR_HIDEMATCHCASE : 0) | (NoWholeWord    ? FR_HIDEWHOLEWORD : 0)
                                     | (CheckDown ? FR_DOWN : 0)       | (CheckMatchCase ? FR_MATCHCASE : 0)     | (CheckWholeWord ? FR_WHOLEWORD : 0);
      FindReplace.hwndOwner        = hWnd;
      FindReplace.lpstrFindWhat    = cFindWhat;
      FindReplace.wFindWhatLen     = sizeof(cFindWhat)/sizeof(TCHAR);
      FindReplace.lpstrReplaceWith = cReplaceWith;
      FindReplace.wReplaceWithLen  = sizeof(cReplaceWith)/sizeof(TCHAR);

      if ( lReplace )
         hDlgFindReplace = ReplaceText ( &FindReplace );
      else
         hDlgFindReplace = FindText    ( &FindReplace );

      TCHAR *cTitle = (TCHAR*) HMG_parc (11);
      if ( HB_ISCHAR (11) )
         SetWindowText ( hDlgFindReplace, cTitle );

      ShowWindow ( hDlgFindReplace, SW_SHOW );
   }
_THREAD_UNLOCK();
}



HB_FUNC ( FINDREPLACEDLGSETTITLE )
{
_THREAD_LOCK();
   TCHAR *cTitle = (TCHAR*) HMG_parc (1);
   if ( hDlgFindReplace != NULL  )
        SetWindowText ( hDlgFindReplace, cTitle );
_THREAD_UNLOCK();
}


HB_FUNC ( FINDREPLACEDLGGETTITLE )
{
_THREAD_LOCK();
   if ( hDlgFindReplace != NULL  )
   {  TCHAR cTitle [ GetWindowTextLength (hDlgFindReplace) + 1];
      GetWindowText ( hDlgFindReplace, cTitle, sizeof(cTitle)/sizeof(TCHAR) );
      HMG_retc ( cTitle );
   }
   else
      HMG_retc (_TEXT(""));
_THREAD_UNLOCK();
}


HB_FUNC ( FINDREPLACEDLGSHOW )
{
_THREAD_LOCK();
   BOOL lShow = HB_ISNIL (1) ? TRUE : hb_parl (1);
   if ( hDlgFindReplace != NULL )
   {   if ( lShow )
          ShowWindow ( hDlgFindReplace, SW_SHOW );
       else
          ShowWindow ( hDlgFindReplace, SW_HIDE );
   }
_THREAD_UNLOCK();
}


HB_FUNC ( FINDREPLACEDLGGETHANDLE )
{
_THREAD_LOCK();
   HMG_retnl ((LONG_PTR) hDlgFindReplace);
_THREAD_UNLOCK();
}


HB_FUNC ( FINDREPLACEDLGISRELEASE )
{
_THREAD_LOCK();
   hb_retl ((BOOL) (hDlgFindReplace == NULL));
_THREAD_UNLOCK();
}


HB_FUNC ( FINDREPLACEDLGRELEASE )
{
_THREAD_LOCK();
   BOOL lDestroy = HB_ISNIL (1) ? TRUE : hb_parl (1);
   if ( hDlgFindReplace != NULL && lDestroy )
       DestroyWindow ( hDlgFindReplace );
   hDlgFindReplace = NULL;
_THREAD_UNLOCK();
}


HB_FUNC ( FINDREPLACEDLGGETOPTIONS )
{
   LPARAM lParam = (LPARAM) hb_parnl (1);
   FINDREPLACE *FR = (FINDREPLACE *) lParam;
   LONG nRet = -1;

   if ( FR->Flags & FR_DIALOGTERM )
       nRet =  0;

   if ( FR->Flags & FR_FINDNEXT )
       nRet =  1;

   if ( FR->Flags & FR_REPLACE )
       nRet =  2;

   if ( FR->Flags & FR_REPLACEALL )
       nRet =  3;

   hb_reta (6);

   hb_storvnl ( (LONG) nRet,                       -1,  1 );
   HMG_storvc (  FR->lpstrFindWhat,                -1,  2 );
   HMG_storvc (  FR->lpstrReplaceWith,             -1,  3 );
   hb_storvl  ( (BOOL) (FR->Flags & FR_DOWN),      -1,  4 );
   hb_storvl  ( (BOOL) (FR->Flags & FR_MATCHCASE), -1,  5 );
   hb_storvl  ( (BOOL) (FR->Flags & FR_WHOLEWORD), -1,  6 );
}



//********************************************************************
// by Dr. Claudio Soto ( Febraury 2014 )
//********************************************************************

static __TLS__ struct
{
   INT Col, Row;
   BOOL Center, Process;
   HWND hWnd;
   PHB_ITEM pCodeBlock_Row;
   PHB_ITEM pCodeBlock_Col;

} _HMG_DialogBoxPosSizeInfo;


HB_FUNC ( _HMG_DIALOGBOXPROPERTY )
{
_THREAD_LOCK();

   static __TLS__ BOOL flag = FALSE;

   if (flag == FALSE)
   {  ZeroMemory (&_HMG_DialogBoxPosSizeInfo, sizeof (_HMG_DialogBoxPosSizeInfo));
      flag = TRUE;
   }

   _HMG_DialogBoxPosSizeInfo.Row     = (INT)  HB_ISNUM  (1) ? hb_parni (1) : HMG_INTNIL;
   _HMG_DialogBoxPosSizeInfo.Col     = (INT)  HB_ISNUM  (2) ? hb_parni (2) : HMG_INTNIL;
   _HMG_DialogBoxPosSizeInfo.Center  = (BOOL) hb_parl   (3);
   _HMG_DialogBoxPosSizeInfo.hWnd    = (HWND) HMG_parnl (4);
   _HMG_DialogBoxPosSizeInfo.Process = (BOOL) hb_parl   (5);

   if (_HMG_DialogBoxPosSizeInfo.pCodeBlock_Row)
      hb_itemRelease (_HMG_DialogBoxPosSizeInfo.pCodeBlock_Row);

   if (_HMG_DialogBoxPosSizeInfo.pCodeBlock_Col)
      hb_itemRelease (_HMG_DialogBoxPosSizeInfo.pCodeBlock_Col);

   _HMG_DialogBoxPosSizeInfo.pCodeBlock_Row = (HB_ISBLOCK (1) ? hb_itemClone (hb_param (1, HB_IT_BLOCK)) : NULL);
   _HMG_DialogBoxPosSizeInfo.pCodeBlock_Col = (HB_ISBLOCK (2) ? hb_itemClone (hb_param (2, HB_IT_BLOCK)) : NULL);

_THREAD_UNLOCK();
}


HB_FUNC ( _HMG_DIALOGBOXPROCEDURE )
{
_THREAD_LOCK();

   UINT nMsg = (UINT) hb_parni (1);
   HWND hWnd = GetActiveWindow();

   if ( _HMG_DialogBoxPosSizeInfo.Process && IsWindow (hWnd) )
   {
       TCHAR szClassName [16];
       HWND hWndParent;
       RECT rDlg, rParent;
       INT  nCol, nRow, nWidth, nHeight;

       if ( nMsg == WM_WINDOWPOSCHANGING && GetClassName (hWnd, szClassName, 16) && lstrcmpi (szClassName, _TEXT("#32770")) == 0 )
       {
          GetWindowRect(hWnd, &rDlg);

          nCol    = _HMG_DialogBoxPosSizeInfo.Col;
          nRow    = _HMG_DialogBoxPosSizeInfo.Row;
          nWidth  = rDlg.right  - rDlg.left;
          nHeight = rDlg.bottom - rDlg.top;

          if ( _HMG_DialogBoxPosSizeInfo.pCodeBlock_Row )
          {   PHB_ITEM pItem = (PHB_ITEM) hb_vmEvalBlock ( _HMG_DialogBoxPosSizeInfo.pCodeBlock_Row );
              if (hb_itemType (pItem) & HB_IT_NUMERIC)
                  nRow = hb_itemGetNI (pItem);
          }

          if ( _HMG_DialogBoxPosSizeInfo.pCodeBlock_Col )
          {   PHB_ITEM pItem = (PHB_ITEM) hb_vmEvalBlock ( _HMG_DialogBoxPosSizeInfo.pCodeBlock_Col );
              if (hb_itemType (pItem) & HB_IT_NUMERIC)
                  nCol = hb_itemGetNI (pItem);
          }

          if ( _HMG_DialogBoxPosSizeInfo.Center )
          {
              if ( IsWindow (_HMG_DialogBoxPosSizeInfo.hWnd))
                 hWndParent = _HMG_DialogBoxPosSizeInfo.hWnd;
              else
                 hWndParent = GetParent (hWnd);

              if ( IsWindow (hWndParent) )
              {
                  GetWindowRect(hWndParent, &rParent);
                  nCol = rParent.left + (((rParent.right  - rParent.left) - nWidth)  /2);
                  nRow = rParent.top  + (((rParent.bottom - rParent.top ) - nHeight) /2);
              }
              else
                  nCol = nRow = HMG_INTNIL;
          }

          if ( nCol == HMG_INTNIL )
               nCol = rDlg.left;

          if ( nRow == HMG_INTNIL )
               nRow = rDlg.top;

          if ( nCol < 0 )
               nCol = 0;

          if ( nRow < 0 )
               nRow = 0;

          if ( nCol + nWidth > GetSystemMetrics(SM_CXSCREEN) )
               nCol = GetSystemMetrics(SM_CXSCREEN) - nWidth;

          if ( nRow + nHeight > GetSystemMetrics(SM_CYSCREEN) )
               nRow = GetSystemMetrics(SM_CYSCREEN) - nHeight;

          SetWindowPos ( hWnd, 0, nCol, nRow, 0, 0, SWP_NOOWNERZORDER + SWP_NOSIZE);
       }
   }
_THREAD_UNLOCK();
}

