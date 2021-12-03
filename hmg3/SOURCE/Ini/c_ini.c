/*----------------------------------------------------------------------------

 * INI Files support procedures

 * (c) 2003 Grigory Filatov
 * (c) 2003 Janusz Pora

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
 contained in this file.

 The exception is that, if you link this code with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking
 this code into it.

*/

/*
  The adaptation of the source code of this file to support UNICODE character set and WIN64 architecture was made
  by Dr. Claudio Soto, November 2012 and June 2014 respectively.
  mail: <srvet@adinet.com.uy>
  blog: http://srvet.blogspot.com
*/

#include "HMG_UNICODE.h"

#include <windows.h>
#include "hbapi.h"

HB_FUNC (GETPRIVATEPROFILESTRING )
{
   TCHAR bBuffer[ 1024 ] = { 0 };
   DWORD dwLen ;
   TCHAR * lpSection  = (TCHAR *) HMG_parc( 1 );
   TCHAR * lpEntry    = HB_ISCHAR(2) ? (TCHAR *) HMG_parc( 2 ) : NULL ;
   TCHAR * lpDefault  = (TCHAR *) HMG_parc( 3 );
   TCHAR * lpFileName = (TCHAR *) HMG_parc( 4 );
   dwLen = GetPrivateProfileString( lpSection , lpEntry ,lpDefault , bBuffer, sizeof(bBuffer)/sizeof(TCHAR) , lpFileName);
   if( dwLen )
      HMG_retclen(bBuffer, dwLen );
   else
      HMG_retc( lpDefault );
}


HB_FUNC( WRITEPRIVATEPROFILESTRING )
{
   TCHAR * lpSection  = (TCHAR *) HMG_parc( 1 );
   TCHAR * lpEntry    = HB_ISCHAR(2) ? (TCHAR *) HMG_parc( 2 ) : NULL ;
   TCHAR * lpData     = HB_ISCHAR(3) ? (TCHAR *) HMG_parc( 3 ) : NULL ;
   TCHAR * lpFileName = (TCHAR *) HMG_parc( 4 );

   if ( WritePrivateProfileString( lpSection , lpEntry , lpData , lpFileName ) )
      hb_retl( TRUE ) ;
   else
      hb_retl(FALSE);
}


HB_FUNC( DELINIENTRY )
{
   hb_retl( WritePrivateProfileString( HMG_parc( 1 ),       // Section
                                     HMG_parc( 2 ),         // Entry
                                     NULL,                 // String
                                     HMG_parc( 3 ) ) );     // INI File
}


HB_FUNC( DELINISECTION )
{
   hb_retl( WritePrivateProfileString( HMG_parc( 1 ),       // Section
                                       NULL,               // Entry
                                       _TEXT(""),          // String
                                       HMG_parc( 2 ) ) );   // INI File
}



//**************************************
//  by Dr. Claudio Soto, December 2014
//**************************************


HB_FUNC ( HMG_CREATEFILE_UTF16LE_BOM )
{
   TCHAR  *FileName = (TCHAR*) HMG_parc (1);
   HANDLE  hFile;
   DWORD   nBytes_Written;
   BYTE    UTF16LE_BOM [] = { 0xFF, 0xFE };

   hFile = CreateFile (FileName, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN, NULL);
   WriteFile(hFile, (LPBYTE) UTF16LE_BOM, sizeof (UTF16LE_BOM), &nBytes_Written, NULL);
   CloseHandle (hFile);
}


TCHAR * FindFirstSubString ( TCHAR * Strings )
{
   TCHAR *p = Strings;
   if (*p == 0)
       p = NULL;
   return p;
}


TCHAR * FindNextSubString ( TCHAR * Strings )
{
   TCHAR *p = Strings;
   p = p + lstrlen (Strings) + 1;
   if (*p == 0)
       p = NULL;
   return p;
}


INT FindLenSubString ( TCHAR * Strings )
{
   INT i = 0;
   TCHAR * p = Strings;
   if ( (p = FindFirstSubString (p)) != NULL )
      for (i=1; (p = FindNextSubString (p)) != NULL; i++);
   return i;
}


//        HMG_GetPrivateProfileSectionNames ( cFileName ) ---> return array { "SectionName1", "SectionName2", ... }
HB_FUNC ( HMG_GETPRIVATEPROFILESECTIONNAMES )
{
   TCHAR  cBuffer [ 32767 ];
   TCHAR *cFileName = (TCHAR *) HMG_parc (1);

   ZeroMemory (cBuffer, sizeof (cBuffer));
   GetPrivateProfileSectionNames ( cBuffer, sizeof(cBuffer) / sizeof(TCHAR), cFileName );

   TCHAR *p = cBuffer;
   INT i, nLen = FindLenSubString ( p );
   hb_reta (nLen);
   if ( nLen > 0)
   {  HMG_storvc ((p = FindFirstSubString (p)), -1, 1);
      for ( i=2; (p = FindNextSubString (p)) != NULL; i++ )
          HMG_storvc (p, -1, i);
   }
}


//        HMG_GetPrivateProfileSection ( cFileName, cSectionName ) ---> return array { "Key1=string1", "Key2=string2", ... }
HB_FUNC ( HMG_GETPRIVATEPROFILESECTION )
{
   TCHAR  cBuffer [ 32767 ];
   TCHAR *cFileName    = (TCHAR *) HMG_parc (1);
   TCHAR *cSectionName = (TCHAR *) HMG_parc (2);

   ZeroMemory (cBuffer, sizeof (cBuffer));
   GetPrivateProfileSection ( cSectionName, cBuffer, sizeof(cBuffer) / sizeof(TCHAR), cFileName );

   TCHAR *p = cBuffer;
   INT i, nLen = FindLenSubString ( p );
   hb_reta (nLen);
   if ( nLen > 0)
   {  HMG_storvc ((p = FindFirstSubString (p)), -1, 1);
      for ( i=2; (p = FindNextSubString (p)) != NULL; i++ )
          HMG_storvc (p, -1, i);
   }
}
