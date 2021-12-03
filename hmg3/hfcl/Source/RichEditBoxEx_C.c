
#include "HMG_UNICODE.h"


#include <windows.h>
#include <commctrl.h>
#include <richedit.h>
#include <shlwapi.h>
#include "hbapi.h"


/*
    RichEditBox_StreamInEx ( hWndControl, cFileName, lSelection, nDataFormat )
    Enhancement of RichEditBox_StreamIn()

    This function skips over byte order marks in Unicode text files.
    This function does not directly support UTF-16 BE text files.
    RichEditBox_LoadFileEx() supports it by using HMG_UTF16ByteSwap() to
    first convert a UTF-16 BE file to UTF-16 LE and then calling this
    function on the UTF-16 LE file.
*/
DWORD CALLBACK EditStreamCallbackReadEx (DWORD_PTR dwCookie, LPBYTE lpBuff, LONG cb, LONG *pcb)
{
    HANDLE hFile = (HANDLE)dwCookie;
    if ( ReadFile (hFile, (LPVOID) lpBuff, (DWORD) cb, (LPDWORD) pcb, NULL) )
       return  0;
    else
       return -1;
}
HB_FUNC ( RICHEDITBOX_STREAMINEX )
{
   HWND       hWndControl = (HWND)   HMG_parnl (1);
   TCHAR     *cFileName   = (TCHAR*) HMG_parc (2);
   BOOL       lSelection  = (BOOL)   hb_parl  (3);
   LONG       nDataFormat = (LONG)   hb_parnl (4);
   HANDLE     hFile;
   BYTE       bUtf8Bom[3];
   BYTE       bUtf16Bom[2];
   DWORD      dwRead;
   EDITSTREAM es;
   LONG       Format;

   switch( nDataFormat )
   {
      case 1:   Format = SF_TEXT; break; // ANSI or UTF-8 with BOM or mixed (UTF-8 BOM is removed, overlong UTF-8 is accepted, invalid UTF-8 is read as ANSI)
      case 2:   Format = ( CP_UTF8 << 16 ) | SF_USECODEPAGE | SF_TEXT; break; // UTF-8 without BOM (BOM is not removed)
      case 3:   Format = SF_TEXT | SF_UNICODE; break; // UTF-16 LE without BOM (BOM is not removed)
      case 4:   Format = SF_RTF; break;
      default:  Format = SF_RTF; break;
   }

   if ( lSelection )
        Format = Format | SFF_SELECTION;

   if( ( hFile = CreateFile (cFileName, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_FLAG_SEQUENTIAL_SCAN, NULL )) == INVALID_HANDLE_VALUE )
   {   hb_retl (FALSE);
       return;
   }

   switch( nDataFormat )
   {
      case 1:   break;
      case 2:
         if ( ! ReadFile (hFile, bUtf8Bom, 3, &dwRead, NULL) ) // read past BOM if present
            hb_retl (FALSE);
         if ( ! ( dwRead == 3 && bUtf8Bom[0] == 0xEF && bUtf8Bom[1] == 0xBB && bUtf8Bom[2] == 0xBF ) )
            SetFilePointer (hFile, 0, 0, FILE_BEGIN);
         break;
      case 3:
         if ( ! ReadFile (hFile, bUtf16Bom, 2, &dwRead, NULL) ) // read past BOM if present
            hb_retl (FALSE);
         if ( ! ( dwRead == 2 && bUtf16Bom[0] == 0xFF && bUtf16Bom[1] == 0xFE ) )
            SetFilePointer (hFile, 0, 0, FILE_BEGIN);
         break;
      case 4:   break;
      default:  break;
   }
   es.pfnCallback = EditStreamCallbackReadEx;
   es.dwCookie    = (DWORD_PTR) hFile;
   es.dwError     = 0;

   SendMessage ( hWndControl, EM_STREAMIN, (WPARAM) Format, (LPARAM) &es );

   CloseHandle (hFile);

   if( es.dwError )
      hb_retl (FALSE);
   else
      hb_retl (TRUE);
}


/*
    RichEditBox_StreamOutEx ( hWndControl, cFileName, lSelection, nDataFormat )
    Enhancement of RichEditBox_StreamOut()

    This function writes byte order mark in Unicode text files.
    This function does not directly support a UTF-16 BE text file.
    RichEditBox_SaveFileEx() supports it by first calling this function to
    generate a UTF-16 LE file and then calling HMG_UTF16ByteSwap() to
    convert the UTF-16 LE file to UTF-16 BE.
*/
DWORD CALLBACK EditStreamCallbackWriteEx (DWORD_PTR dwCookie, LPBYTE lpBuff, LONG cb, LONG *pcb)
{
    HANDLE hFile = (HANDLE) dwCookie;
    if ( WriteFile (hFile, (LPVOID) lpBuff, (DWORD) cb, (LPDWORD) pcb, NULL) )
       return  0;
    else
       return -1;
}
HB_FUNC ( RICHEDITBOX_STREAMOUTEX )
{
   HWND       hWndControl = (HWND)   HMG_parnl (1);
   TCHAR     *cFileName   = (TCHAR*) HMG_parc (2);
   BOOL       lSelection  = (BOOL)   hb_parl  (3);
   LONG       nDataFormat = (LONG)   hb_parnl (4);
   HANDLE     hFile;
   BYTE       bUtf8Bom[3]  = {0xEF, 0xBB, 0xBF};
   BYTE       bUtf16Bom[2] = {0xFF, 0xFE};
   DWORD      dwWritten;
   EDITSTREAM es;
   LONG       Format;

   switch( nDataFormat )
   {
      case 1:   Format = SF_TEXT; break; // ANSI (non-ANSI characters are converted to question marks)
      case 2:   Format = ( CP_UTF8 << 16 ) | SF_USECODEPAGE | SF_TEXT; break; // UTF-8 without BOM
      case 3:   Format = SF_TEXT | SF_UNICODE; break; // UTF-16 LE without BOM
      case 4:   Format = SF_RTF;  break;
      default:  Format = SF_RTF; break;
   }

   if ( lSelection )
        Format = Format | SFF_SELECTION;

   if( ( hFile = CreateFile (cFileName, GENERIC_WRITE, FILE_SHARE_WRITE, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL )) == INVALID_HANDLE_VALUE )
   {   hb_retl (FALSE);
       return;
   }

   switch( nDataFormat )
   {
      case 1:   break;
      case 2:   WriteFile( hFile, bUtf8Bom, 3, &dwWritten, NULL ); break; // write UTF-8 BOM at head of file
      case 3:   WriteFile( hFile, bUtf16Bom, 2, &dwWritten, NULL ); break; // write UTF-16 LE BOM at head of file
      case 4:   break;
      default:  break;
   }
   es.pfnCallback = EditStreamCallbackWriteEx;
   es.dwCookie    = (DWORD_PTR) hFile;
   es.dwError     = 0;

   SendMessage ( hWndControl, EM_STREAMOUT, (WPARAM) Format, (LPARAM) &es );

   CloseHandle (hFile);

   if( es.dwError )
      hb_retl (FALSE);
   else
      hb_retl (TRUE);
}

HB_FUNC ( _HMG_PRINTER_PRINTDIALOG_EX )
{
   PRINTDLG pd ;
   LPDEVMODE   pDevMode;

   pd.lStructSize = sizeof(PRINTDLG);
   pd.hDevMode = (HANDLE) NULL;
   pd.hDevNames = (HANDLE) NULL;
   pd.Flags = PD_RETURNDC | PD_PRINTSETUP ;
   pd.hwndOwner = HB_ISNIL(1) ? GetActiveWindow() : (HWND) HMG_parnl (1) ;
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

