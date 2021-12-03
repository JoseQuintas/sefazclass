/*----------------------------------------------------------------------------
 HMG Source File --> HMG_TString.prg

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

#include "hmg.ch"
#include "hbclass.ch"

CREATE CLASS HMG_TGeneral
   // AS <type> ( ARRAY, BLOCK, CHARACTER, DATE, HASH, LOGICAL, NIL, NUMERIC, SYMBOL, TIMESTAMP, POINTER, USUAL )
   VAR cargo   AS USUAL   INIT Nil   EXPORTED // User-definable variable
   ENDCLASS

CREATE CLASS HMG_TString   INHERIT HMG_TGeneral

   EXPORTED:

      METHOD New()   INLINE ( Self )   // Constructor

      METHOD Chr( nCode )                                 INLINE   HB_UCHAR( nCode )   // return string with U+nCode character in HVM CP encoding
      METHOD Char( nCode )                                INLINE   HB_UCHAR( nCode )   // return string with U+nCode character in HVM CP encoding
      METHOD Asc( cString )                               INLINE   HB_UCODE( cString )   // return unicode value of 1-st character (not byte) in given string
      METHOD Code( cString )                              INLINE   HB_UCODE( cString )   // return unicode value of 1-st character (not byte) in given string
      METHOD Len( cString )                               INLINE   HB_ULEN( cString )    // return string length in characters
      METHOD ByteLen( cString )                           INLINE   HB_BLEN( cString )    // return string length in bytes
      METHOD Peek( cString, n )                           INLINE   HB_UPEEK( cString, n ) // return unicode value of <n>-th character in given string
      METHOD Poke( cString, n, nVal )                     INLINE   HB_UPOKE( cString, n, nVal ) // change <n>-th character in given string to unicode <nVal> one and return modified text
      METHOD SubStr( cString, nStart, nCount )            INLINE   HB_USUBSTR( cString, nStart, nCount )
      METHOD Left( cString, nCount )                      INLINE   HB_ULEFT( cString, nCount )
      METHOD Right( cString, nCount )                     INLINE   HB_URIGHT( cString, nCount )
      METHOD At( cSubString, cString, nFrom, nTo )        INLINE   HB_UAT( cSubString, cString, nFrom, nTo )
      METHOD Rat( cSearch, cTarget )                      INLINE   HB_UTF8RAT( cSearch, cTarget )
      METHOD Stuff( cString, nStart, nDelete, cInsert )   INLINE   HB_UTF8STUFF( cString, nStart, nDelete, cInsert )

      METHOD BLen( cString )                              INLINE   HB_BLEN( cString )    // return string length in bytes
      METHOD BLeft( cString, nCount  )                    INLINE   HB_BLEFT( cString, nCount )
      METHOD BRight( cString, nCount )                    INLINE   HB_BRIGHT( cString, nCount )
      METHOD BSubStr( cString, nStart, nCount )           INLINE   HB_BSUBSTR( cString, nStart, nCount )

      METHOD LTrim( cString )                                        INLINE   LTRIM( cString )
      METHOD RTrim( cString )                                        INLINE   RTRIM( cString )
      METHOD AllTrim( cString )                                      INLINE   ALLTRIM( cString )
      METHOD StrTran( cString, cSearch, cReplace, nStart, nCount )   INLINE   HB_UTF8STRTRAN( cString, cSearch, cReplace, nStart, nCount )
      METHOD Replicate( cString, nCount )                            INLINE   REPLICATE( cString, nCount )
      METHOD Space( nCount )                                         INLINE   SPACE( nCount )

      METHOD StrToUTF8( cStr, cCPID )                                INLINE   HB_STRTOUTF8( cStr, cCPID )
      METHOD UTF8ToStr( cUTF8Str, cCPID )                            INLINE   HB_UTF8TOSTR( cUTF8Str, cCPID )
      METHOD IsUTF8( cString )                                       INLINE   HMG_ISUTF8( cString )

      METHOD EOL()                                                   INLINE   HB_EOL()       // CR+LF
      METHOD OsNewLine()                                             INLINE   HB_OSNEWLINE() // CR+LF

      METHOD Lower( cString )                      INLINE   HMG_LOWER( cString )
      METHOD Upper( cString )                      INLINE   HMG_UPPER( cString )
      METHOD PadC( cString, nLength, cFillChar )   INLINE   HMG_PADC( cString, nLength, cFillChar )
      METHOD PadL( cString, nLength, cFillChar )   INLINE   HMG_PADL( cString, nLength, cFillChar )
      METHOD PadR( cString, nLength, cFillChar )   INLINE   HMG_PADR( cString, nLength, cFillChar )
      METHOD IsAlpha( cString )                    INLINE   HMG_ISALPHA( cString )
      METHOD IsDigit( cString )                    INLINE   HMG_ISDIGIT( cString )
      METHOD IsLower( cString )                    INLINE   HMG_ISLOWER( cString )
      METHOD IsUpper( cString )                    INLINE   HMG_ISUPPER( cString )
      METHOD IsAlphaNumeric( cString )             INLINE   HMG_ISALPHANUMERIC( cString )   // return (ISALPHA(c) .OR. ISDIGIT(c))

      METHOD StrCmp( cString1, cString2, lCaseSensitive )   INLINE   HMG_StrCmp( cString1, cString2, lCaseSensitive )   // return -1, 0 , +1

ENDCLASS

