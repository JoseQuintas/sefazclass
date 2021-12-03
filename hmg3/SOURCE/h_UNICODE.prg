/*----------------------------------------------------------------------------
 HMG Source File --> h_UNICODE.prg  

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

MEMVAR _HMG_SYSDATA
#include "common.ch"
#include "hmg.ch"

*-----------------------------------------------------------------------------*
FUNCTION MsgInfoUnicode (Message, Title)
*-----------------------------------------------------------------------------*
   DEFAULT Message TO ''
   DEFAULT Title TO ''
   HMG_MsgInfoUnicode (HMG_ValToStr(Message), hb_ValToStr(Title))
Return Nil


*-----------------------------------------------------------------------------*
FUNCTION MsgDebugUnicode
*-----------------------------------------------------------------------------*
LOCAL i, cMsg
   #define CRLF CHR(13)+CHR(10) 
   cMsg := "Called from: " + ProcName(1) + "(" + LTrim(Str(ProcLine(1))) + ") --> " + PROCFILE (1) + CRLF + CRLF
   FOR i = 1 TO PCount()
       cMsg := cMsg + HB_VALTOEXP (PVALUE (i)) + IIF (i < PCount(), ", ", "")
   NEXT
   HMG_MsgInfoUnicode (cMsg, "DEBUG Unicode INFO")
RETURN cMsg

