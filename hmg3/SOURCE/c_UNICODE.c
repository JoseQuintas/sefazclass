/*----------------------------------------------------------------------------
 HMG Source File --> c_UNICODE.c

 Copyright 2012-2017 by Dr. Claudio Soto (from Uruguay).

 mail: <srvet@adinet.com.uy>
 blog: http://srvet.blogspot.com

 Permission to use, copy, modify, distribute and sell this software
 and its documentation for any purpose is hereby granted without fee,
 provided that the above copyright notice appear in all copies and
 that both that copyright notice and this permission notice appear
 in supporting documentation.
 It is provided "as is" without express or implied warranty.

 ----------------------------------------------------------------------------*/

// All functions this file always compile in Unicode

#define COMPILE_HMG_UNICODE   // Force to compile in Unicode
#include "HMG_UNICODE.h"

#include <windows.h>
#include "hbapi.h"


HB_FUNC (HMG_MSGINFOUNICODE)
{
   MessageBox (GetActiveWindow(), HMG_parc(1), HMG_parc(2), MB_OK | MB_ICONINFORMATION | MB_SYSTEMMODAL);
}


/*

//       HMG_GetUnicodeValue (cText) --> return { n1, n2,..., nn }
HB_FUNC (HMG_GETUNICODEVALUE)
{  INT i, nLen;
   WCHAR *cText = (WCHAR*) HMG_parc (1);
   nLen = wcslen (cText);
   hb_reta (nLen);
   if (nLen > 0)
   {  for (i=0; i < nLen; i++)
            hb_storvnl ((LONG) cText[i], -1, i+1);
   }
}


//       HMG_GetUnicodeCharacter (aCode) --> return cText
HB_FUNC (HMG_GETUNICODECHARACTER)
{
   WCHAR *cText, cBuffer [2] = {0,0};
   INT i, nLen;

   cText = cBuffer;

   if ( HB_ISNUM(1) )
       cBuffer [0] = (WCHAR) hb_parnl (1);
   else if ( HB_ISARRAY (1) )
   {   nLen = hb_parinfa (1, 0);
       if ( nLen > 0 )
       {   cText = (WCHAR *) hb_xgrab ((nLen + 1) * sizeof (WCHAR));
           for (i=0; i < nLen; i++)
                cText [i] = (WCHAR) hb_parvnl (1, i+1);
           cText [nLen] = (WCHAR) 0;
       }
   }
   HMG_retc (cText);
}

*/

//       HMG_UNICODE_TO_ANSI (cTextUNICODE) --> cTextANSI
HB_FUNC (HMG_UNICODE_TO_ANSI)
{
   WCHAR *cTextUNICODE = (WCHAR *) HMG_parc (1);
   CHAR  *cTextANSI    = HMG_WCtoMB (cTextUNICODE);
   hb_retc (cTextANSI);
}


//       HMG_ANSI_TO_UNICODE (cTextANSI) --> cTextUNICODE
HB_FUNC (HMG_ANSI_TO_UNICODE)
{
   CHAR  *cTextANSI    = (CHAR *) hb_parc (1);
   WCHAR *cTextUNICODE = HMG_MBtoWC (cTextANSI);
   HMG_retc (cTextUNICODE);
}

