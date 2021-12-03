/*----------------------------------------------------------------------------
 HMG Source File --> c_UNICODE_STRING.c

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


#include "HMG_UNICODE.h"

#include <windows.h>
#include <tchar.h>
#include "hbapi.h"


#ifdef COMPILE_HMG_UNICODE

   HB_FUNC (HMG_LOWER_BMP)
   {
      TCHAR *Text   = (TCHAR*)  HMG_parc(1);

      if (Text == NULL)
      {   HMG_retc (NULL);
          return;
      }

      INT   nLen    = (INT)     lstrlen(Text) + 1;
      TCHAR *Buffer = (TCHAR *) hb_xgrab (nLen * sizeof(TCHAR));

      if (Buffer != NULL)
      {   lstrcpy (Buffer, Text);
          CharLower (Buffer);
          HMG_retc (Buffer);
          hb_xfree (Buffer);
      }
      else
          HMG_retc (NULL);
   }


   HB_FUNC (HMG_UPPER_BMP)
   {
      TCHAR *Text   = (TCHAR*)  HMG_parc(1);

      if (Text == NULL)
      {   HMG_retc (NULL);
          return;
      }

      INT   nLen    = (INT)     lstrlen(Text) + 1;
      TCHAR *Buffer = (TCHAR *) hb_xgrab (nLen * sizeof(TCHAR));

      if (Buffer != NULL)
      {   lstrcpy (Buffer, Text);
          CharUpper (Buffer);
          HMG_retc (Buffer);
          hb_xfree (Buffer);
      }
      else
         HMG_retc (NULL);
   }


   HB_FUNC (HMG_ISALPHA_BMP)
   {
      TCHAR *Text = (TCHAR*) HMG_parc(1);
      hb_retl ((BOOL) IsCharAlpha ((TCHAR)Text[0]));
   }


   HB_FUNC (HMG_ISDIGIT_BMP)
   {
      TCHAR *Text = (TCHAR*) HMG_parc(1);
      hb_retl ((BOOL) ( IsCharAlphaNumeric((TCHAR)Text[0]) && !IsCharAlpha((TCHAR)Text[0]) ));
   }


   HB_FUNC (HMG_ISLOWER_BMP)
   {
      TCHAR *Text = (TCHAR*) HMG_parc(1);
      hb_retl ((BOOL) IsCharLower ((TCHAR)Text[0]));
   }


   HB_FUNC (HMG_ISUPPER_BMP)
   {
      TCHAR *Text = (TCHAR*) HMG_parc(1);
      hb_retl ((BOOL) IsCharUpper ((TCHAR)Text[0]));
   }


   HB_FUNC (HMG_ISALPHANUMERIC_BMP)
   {
      TCHAR *Text = (TCHAR*) HMG_parc(1);
      hb_retl ((BOOL) IsCharAlphaNumeric((TCHAR)Text[0]));
   }

#endif


//       HMG_StrCmp_BMP ( Text1 , Text2 , [ lCaseSensitive ] ) --> CmpValue
HB_FUNC (HMG_STRCMP_BMP)
{
   TCHAR *Text1 = (TCHAR *) HMG_parc (1);
   TCHAR *Text2 = (TCHAR *) HMG_parc (2);
   BOOL  lCaseSensitive = (BOOL) hb_parl (3);
   int CmpValue;

   if ( lCaseSensitive == FALSE )
      CmpValue = lstrcmpi (Text1, Text2);
   else
      CmpValue = lstrcmp  (Text1, Text2);

   hb_retni ((int) CmpValue);
}


