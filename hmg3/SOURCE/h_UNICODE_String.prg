/*----------------------------------------------------------------------------
 HMG Source File --> h_UNICODE_STRING.prg

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

/*

UNICODE/ANSI                  ANSI Only
------------                  ---------
HMG_LEN()               <=>   LEN()
HMG_PADC()              <=>   PADC()
HMG_PADL()              <=>   PADL()
HMG_PADR()              <=>   PADR()
HMG_CHR()               <=>   CHR()
HMG_ASC()               <=>   ASC()
HMG_ASCPOS()            <=>   ASCPOS()
HMG_AT()                <=>   AT()
HMG_RAT()               <=>   RAT()
HMG_LEFT()              <=>   LEFT()
HMG_RIGHT()             <=>   RIGHT()
HMG_SUBSTR()            <=>   SUBSTR()
HMG_STUFF()             <=>   STUFF()
HMG_LOWER()             <=>   LOWER()
HMG_UPPER()             <=>   UPPER()
HMG_ISALPHA()           <=>   ISALPHA()
HMG_ISDIGIT()           <=>   ISDIGIT()
HMG_ISLOWER()           <=>   ISLOWER()
HMG_ISUPPER()           <=>   ISUPPER()
HMG_ISALPHANUMERIC()    <=>   ISALPHA() .OR. ISDIGIT()
HMG_PEEK()              <=>   HB_BPEEK()
HMG_POKE()              <=>   HB_BPOKE()

*/

#ifdef COMPILE_HMG_UNICODE

  FUNCTION HMG_LEN(cStr)
  LOCAL nByte, nBytes, nLen, lCrawl
    IF HB_ISSTRING(cStr) // HB_ISCHAR(cStr) .OR. HB_ISMEMO(cStr)
      nByte  := 1
      nBytes := LEN(cStr)
      nLen   := 0
      lCrawl := !EMPTY(nBytes)
      WHILE lCrawl
        nByte  := HMG_UTF8CRAWL(cStr, nByte, 1)
        nLen   ++
        lCrawl := (nByte <= nBytes)
      END
    ELSE
      nLen := LEN(cStr)
    END
  RETURN nLen

  FUNCTION HMG_PADC (xValue, nLen, cFillChar)
  LOCAL cText, nSize, cPadText := ""
    IF nLen > 0
      IF HB_ISNIL(cFillChar)
        cFillChar := " "
      ENDIF
      IF ! (cFillChar == "")
         cFillChar := HMG_SUBSTR (cFillChar,1,1)
         cText := HB_VALTOSTR (xValue)
         IF HMG_LEN (cText) >= nLen
           cPadText := HMG_SUBSTR (cText,1,nLen)
         ELSE
           nSize := nLen - HMG_LEN (cText)
           cPadText := REPLICATE (cFillChar, (nSize/2)) + cText + REPLICATE (cFillChar, ((nSize+1)/2))
         ENDIF
      ENDIF
    ENDIF
  RETURN cPadText

  FUNCTION HMG_PADL (xValue, nLen, cFillChar)
  LOCAL cText, nSize, cPadText := ""
    IF nLen > 0
      IF HB_ISNIL(cFillChar)
        cFillChar := " "
      ENDIF
      IF ! (cFillChar == "")
         cFillChar := HMG_SUBSTR (cFillChar,1,1)
         cText := HB_VALTOSTR (xValue)
         IF HMG_LEN (cText) >= nLen
           cPadText := HMG_SUBSTR (cText,1,nLen)
         ELSE
           nSize := nLen - HMG_LEN (cText)
           cPadText := REPLICATE (cFillChar, nSize) + cText
         ENDIF
      ENDIF
    ENDIF
  RETURN cPadText

  FUNCTION HMG_PADR (xValue, nLen, cFillChar)
  LOCAL cText, nSize, cPadText := ""
    IF nLen > 0
      IF HB_ISNIL(cFillChar)
        cFillChar := " "
      ENDIF
      IF ! (cFillChar == "")
         cFillChar := HMG_SUBSTR (cFillChar,1,1)
         cText := HB_VALTOSTR (xValue)
         IF HMG_LEN (cText) >= nLen
           cPadText := HMG_SUBSTR (cText,1,nLen)
         ELSE
           nSize := nLen - HMG_LEN (cText)
           cPadText := cText + REPLICATE (cFillChar, nSize)
         ENDIF
      ENDIF
    ENDIF
  RETURN cPadText

  FUNCTION HMG_CHR(nCode, lCesu8)
  LOCAL cStr, nByte1, nByte2, nByte3, nByte4, nSurr1, nSurr2
    DO CASE
    CASE nCode < 0x10000
      cStr   := HB_UTF8CHR(nCode)
    CASE EMPTY(lCesu8)
      nByte4 := INT(nCode % 0x0040) + 0x80
      nCode  := INT(nCode / 0x0040)
      nByte3 := INT(nCode % 0x0040) + 0x80
      nCode  := INT(nCode / 0x0040)
      nByte2 := INT(nCode % 0x0040) + 0x80
      nCode  := INT(nCode / 0x0040)
      nByte1 :=     nCode           + 0xF0
      cStr   := CHR(nByte1) + CHR(nByte2) + CHR(nByte3) + CHR(nByte4)
    OTHERWISE
      nCode  -= 0x10000
      nSurr1 := INT(nCode / 0x400) + 0xD800
      nSurr2 := INT(nCode % 0x400) + 0xDC00
      cStr   := HB_UTF8CHR(nSurr1) + HB_UTF8CHR(nSurr2)
    END
  RETURN cStr

  FUNCTION HMG_ASC(cStr)
  LOCAL nCode := 0
    HMG_UTF8CRAWL(cStr, 1, 0, @nCode)
  RETURN nCode

  FUNCTION HMG_ASCPOS(cStr, nChar)
  LOCAL nCode := 0
    HMG_UTF8CRAWL(cStr, 0, IF(nChar == NIL, 1, nChar), @nCode)
  RETURN nCode

  FUNCTION HMG_AT(cSmall, cLarge, nStart, nEnd)
  LOCAL lSearch := .Y.
  LOCAL nByte   := 0
  LOCAL nChar   := 0
  LOCAL nLLen   := LEN(cLarge)
  LOCAL nSLen   := LEN(cSmall)
  LOCAL nPos    := 0
    IF nStart == NIL
      nStart := 1
    END
    IF nEnd == NIL
      nEnd := LEN(cLarge)
    END
    WHILE lSearch
      nByte := HMG_UTF8CRAWL(cLarge, nByte, 1)
      nChar ++
      DO CASE
      CASE nChar > nEnd
        lSearch := .N.
      CASE SUBSTR(cLarge, nByte, nSLen) == cSmall .AND. nChar >= nStart
        nPos    := nChar
        lSearch := .N.
      END
      IF nByte > nLLen
        lSearch := .N.
      END
    END
  RETURN nPos

  FUNCTION HMG_RAT(cSmall, cLarge, nStart, nEnd)
  LOCAL lSearch := .Y.
  LOCAL nByte   := 0
  LOCAL nChar   := 0
  LOCAL nLLen   := LEN(cLarge)
  LOCAL nSLen   := LEN(cSmall)
  LOCAL nPos    := 0
    IF nStart == NIL
      nStart := 1
    END
    IF nEnd == NIL
      nEnd := LEN(cLarge)
    END
    WHILE lSearch
      nByte := HMG_UTF8CRAWL(cLarge, nByte, 1)
      nChar ++
      DO CASE
      CASE nChar > nEnd
        lSearch := .N.
      CASE SUBSTR(cLarge, nByte, nSLen) == cSmall .AND. nChar >= nStart
        nPos    := nChar
      END
      IF nByte > nLLen
        lSearch := .N.
      END
    END
  RETURN nPos

  FUNCTION HMG_LEFT(cStr, nChars)
  LOCAL cSubStr := LEFT(cStr, HMG_UTF8CRAWL(cStr, 1, nChars) - 1)
  RETURN cSubStr

  FUNCTION HMG_RIGHT(cStr, nChars)
  LOCAL cSubStr := SUBSTR(cStr, HMG_UTF8CRAWL(cStr, LEN(cStr) + 1, -nChars))
  RETURN cSubStr

  FUNCTION HMG_SUBSTR(cStr, nPos, nChars)
  LOCAL nStByte := ;
    IF(EMPTY(nPos), ;
      1, ;
      IF(nPos >= 0, ;
        HMG_UTF8CRAWL(cStr,             0, nPos), ;
        HMG_UTF8CRAWL(cStr, LEN(cStr) + 1, nPos)  ;
      ) ;
    )
  LOCAL cSubStr := IF(EMPTY(nChars), ;
    SUBSTR(cStr, nStByte), ;
    SUBSTR(cStr, nStByte, HMG_UTF8CRAWL(cStr, nStByte, nChars) - nStByte))
  RETURN cSubStr

  FUNCTION HMG_STUFF(cInStr, nChar, nDelete, cInsert)
  LOCAL nByte    := IF(EMPTY(nChar), 1, HMG_UTF8CRAWL(cInStr, 0, nChar))
  LOCAL cOutStr  := ''
  LOCAL cPreStr  := LEFT(cInStr, nByte - 1)
  LOCAL cPostStr := ''
    IF !EMPTY(nDelete)
      nByte := HMG_UTF8CRAWL(cInStr, nByte, nDelete)
    ENDIF
    cPostStr := SUBSTR(cInStr, nByte)
    cOutStr  := cPreStr + IF(cInsert == NIL, '', cInsert) + cPostStr
  RETURN cOutStr

  FUNCTION HMG_LOWER(cStr); RETURN HMG_UNCESU8(HMG_LOWER_BMP(HMG_CESU8(cStr)))
  FUNCTION HMG_UPPER(cStr); RETURN HMG_UNCESU8(HMG_UPPER_BMP(HMG_CESU8(cStr)))
  FUNCTION HMG_ISALPHA(cStr); RETURN HMG_ISALPHA_BMP(HMG_CESU8(cStr))
  FUNCTION HMG_ISDIGIT(cStr); RETURN HMG_ISDIGIT_BMP(HMG_CESU8(cStr))
  FUNCTION HMG_ISLOWER(cStr); RETURN HMG_ISLOWER_BMP(HMG_CESU8(cStr))
  FUNCTION HMG_ISUPPER(cStr); RETURN HMG_ISUPPER_BMP(HMG_CESU8(cStr))
  FUNCTION HMG_ISALPHANUMERIC(cStr); RETURN HMG_ISALPHANUMERIC_BMP(HMG_CESU8(cStr))

/*
  Defined in c_UNICODE_String.c
  HB_FUNC (HMG_LOWER_BMP)
  HB_FUNC (HMG_UPPER_BMP)
  HB_FUNC (HMG_ISALPHA_BMP)
  HB_FUNC (HMG_ISDIGIT_BMP)
  HB_FUNC (HMG_ISLOWER_BMP)
  HB_FUNC (HMG_ISUPPER_BMP)
  HB_FUNC (HMG_ISALPHANUMERIC_BMP)
*/

  FUNCTION HMG_PEEK(cStr, nChar)
  RETURN HMG_ASCPOS(cStr, nChar)

  FUNCTION HMG_POKE(cStr, nChar, nCode)
    cStr := HMG_STUFF(cStr, nChar, 1, HMG_CHR(nCode))
  RETURN cStr

#else

  FUNCTION HMG_LEN(x); RETURN LEN (x)
  FUNCTION HMG_PADC(x,n,c); RETURN PADC(x,n,c)
  FUNCTION HMG_PADL(x,n,c); RETURN PADL(x,n,c)
  FUNCTION HMG_PADR(x,n,c); RETURN PADR(x,n,c)
  FUNCTION HMG_CHR(n); RETURN CHR(n)
  FUNCTION HMG_ASC(c); RETURN ASC(c)
  FUNCTION HMG_ASCPOS(c,n); RETURN ASCPOS(c,n)
  FUNCTION HMG_AT(s,c,b,e); RETURN HB_AT(s,c,b,e)
  FUNCTION HMG_RAT(s,c,b,e); RETURN HB_RAT(s,c,b,e)
  FUNCTION HMG_LEFT(c,n); RETURN LEFT(c,n)
  FUNCTION HMG_RIGHT(c,n); RETURN RIGHT(c,n)
  FUNCTION HMG_SUBSTR(c,b,n); RETURN SUBSTR(c,b,n)
  FUNCTION HMG_STUFF(c,n,d,s); RETURN STUFF(c,n,d,s)

  FUNCTION HMG_LOWER(c); RETURN LOWER (c)
  FUNCTION HMG_UPPER(c); RETURN UPPER (c)
  FUNCTION HMG_ISALPHA(c); RETURN ISALPHA(c)
  FUNCTION HMG_ISDIGIT(c); RETURN ISDIGIT(c)
  FUNCTION HMG_ISLOWER(c); RETURN ISLOWER(c)
  FUNCTION HMG_ISUPPER(c); RETURN ISUPPER(c)
  FUNCTION HMG_ISALPHANUMERIC(c); RETURN (ISALPHA(c) .OR. ISDIGIT(c))

  FUNCTION HMG_PEEK(c,n); RETURN HB_BPEEK(c,n)
  FUNCTION HMG_POKE(c,n,p); RETURN HB_BPOKE(@c,n,p)

#endif

// #xtranslate UTF8_BOM => E"\xEF\xBB\xBF" // HB_UTF8CHR(0xFEFF)

FUNCTION HMG_IsUTF8WithBOM ( cString )
RETURN (HB_BLEFT (cString, HB_BLEN (UTF8_BOM)) == UTF8_BOM)

FUNCTION HMG_UTF8RemoveBOM ( cString )
  IF HMG_IsUTF8WithBOM (cString) == .T.
    cString := HB_BSUBSTR (cString, HB_BLEN ( UTF8_BOM ) + 1)
  ENDIF
RETURN cString

FUNCTION HMG_UTF8InsertBOM ( cString )
  IF HMG_IsUTF8WithBOM (cString) == .F.
    cString := UTF8_BOM + cString
  ENDIF
RETURN cString

FUNCTION HMG_STRCMP ( cStr1, cStr2, lCaseSens )
RETURN HMG_STRCMP_BMP (HMG_CESU8 (cStr1), HMG_CESU8 (cStr2), lCaseSens )

//***************************************************************************

/*

FUNCTION HMG_IsUTF8 ( cString )   // code from Harbour Project, now is implemented as HB_StrIsUTF8()
LOCAL lASCII := .T.
LOCAL nOctets := 0
LOCAL nChar
LOCAL tmp
  FOR EACH tmp IN cString
    nChar := HB_BCODE( tmp )
    IF HB_bitAND ( nChar, 0x80 ) != 0
      lASCII := .F.
    ENDIF
    IF nOctets != 0
      IF HB_bitAND ( nChar, 0xC0 ) != 0x80
        RETURN .F.
      ENDIF
      --nOctets
    ELSEIF HB_bitAND ( nChar, 0x80 ) != 0
      DO WHILE HB_bitAND ( nChar, 0x80 ) != 0
        nChar := HB_bitAND ( HB_bitSHIFT ( nChar, 1 ), 0xFF )
        ++nOctets
      ENDDO
      --nOctets
      IF nOctets == 0
        RETURN .F.
      ENDIF
    ENDIF
  NEXT
RETURN !( nOctets > 0 .OR. lASCII )

FUNCTION HMG_IsUTF8 ( cString )   // returns .F. on pure ASCII, replaced with function below
RETURN HB_StrIsUTF8 ( cString )

*/

FUNCTION HMG_ISUTF8(cStr)

LOCAL cChar   := ''
LOCAL lIsUtf8 := .Y.
LOCAL nByte   := 1
LOCAL nBytes  := 1
LOCAL nChar   := 0

FOR EACH cChar IN cStr
  nChar := ASC(cChar)
  SWITCH nBytes
  CASE 1
    DO CASE
    CASE nChar <= 0x7F
    CASE nChar <= 0xBF
      lIsUtf8 := .N.
    CASE nChar <= 0xC1
      lIsUtf8 := .N.
    CASE nChar <= 0xDF
      nBytes  := 2
      nByte   := 1
    CASE nChar <= 0xEF
      nBytes  := 3
      nByte   := 1
    CASE nChar <= 0xF4
      nBytes  := 4
      nByte   := 1
    OTHERWISE
      lIsUtf8 := .N.
    END
    EXIT
  CASE 2
    DO CASE
    CASE nChar <= 0x7F
      lIsUtf8 := .N.
    CASE nChar <= 0xBF
      IF ++nByte == 2
        nBytes := 1
      END
    OTHERWISE
      lIsUtf8 := .N.
    END
    EXIT
  CASE 3
    DO CASE
    CASE nChar <= 0x7F
      lIsUtf8 := .N.
    CASE nChar <= 0xBF
      IF ++nByte == 3
        nBytes := 1
      END
    OTHERWISE
      lIsUtf8 := .N.
    END
    EXIT
  CASE 4
    DO CASE
    CASE nChar <= 0x7F
      lIsUtf8 := .N.
    CASE nChar <= 0xBF
      IF ++nByte == 4
        nBytes := 1
      END
    OTHERWISE
      lIsUtf8 := .N.
    END
    EXIT
  END
NEXT

RETURN lIsUtf8 // HMG_ISUTF8

//***************************************************************************

FUNCTION HMG_UTF8TOESCAPE(cUniStr)

LOCAL cChar   := ''
LOCAL cEscStr := ''
LOCAL nByte   := 0
LOCAL nCode   := 0
LOCAL nLen    := LEN(cUniStr)
LOCAL lCrawl  := (nLen > 0)

WHILE lCrawl
  nByte := HMG_UTF8CRAWL(cUniStr, nByte, 1, @nCode, @cChar)
  IF nByte <= nLen
    DO CASE
    CASE nCode <= 0x1F
      SWITCH nCode
      CASE 0x08
        cEscStr += '\b'
        EXIT
      CASE 0x09
        cEscStr += '\t'
        EXIT
      CASE 0x0A
        cEscStr += '\n'
        EXIT
      CASE 0x0C
        cEscStr += '\f'
        EXIT
      CASE 0x0D
        cEscStr += '\r'
        EXIT
      OTHERWISE
        cEscStr += '\x' + HB_NUMTOHEX(nCode, 2)
      END
    CASE nCode <= 0xFF
      SWITCH nCode
      CASE 0x22
        cEscStr += '\"'
        EXIT
      CASE 0x5C
        cEscStr += '\\'
        EXIT
      OTHERWISE
        cEscStr += cChar
      END
    CASE nCode <= 0xFFFF
      cEscStr += '\u' + HB_NUMTOHEX(nCode, 4)
    OTHERWISE
      cEscStr += '\U' + HB_NUMTOHEX(nCode, 8)
    END
  ELSE
    lCrawl  := .N.
  END
END

RETURN cEscStr // HMG_UTF8TOESCAPE

//***************************************************************************

FUNCTION HMG_ESCAPETOUTF8(cEscStr)

LOCAL cChar   := ''
LOCAL cSeq    := ''
LOCAL cUniStr := ''
LOCAL lSlash  := .N.
LOCAL nBytes  := 0

FOR EACH cChar IN cEscStr
  DO CASE
  CASE !EMPTY(nBytes)
    IF cChar $ '0123456789ABCDEFabcdef'
      cSeq += cChar
      IF LEN(cSeq) == nBytes
        cUniStr += HMG_CHR(HB_HEXTONUM(cSeq))
        cSeq    := ''
        nBytes  := 0
      END
    ELSE
      IF !EMPTY(cSeq)
        cUniStr += HMG_CHR(HB_HEXTONUM(cSeq))
      END
      IF cChar == '\'
        lSlash  := .Y.
      ELSE
        cUniStr += cChar
        lSlash  := .N.
      END
      cSeq   := ''
      nBytes := 0
    END
  CASE lSlash
    SWITCH cChar
    CASE 'b'
      cUniStr += E"\x08"
      EXIT
    CASE 't'
      cUniStr += E"\x09"
      EXIT
    CASE 'n'
      cUniStr += E"\x0A"
      EXIT
    CASE 'f'
      cUniStr += E"\x0C"
      EXIT
    CASE 'r'
      cUniStr += E"\x0D"
      EXIT
    CASE '"'
      cUniStr += '"'
      EXIT
    CASE '\'
      cUniStr += '\'
      EXIT
    CASE 'x'
      nBytes  := 2
      EXIT
    CASE 'u'
      nBytes  := 4
      EXIT
    CASE 'U'
      nBytes  := 8
      EXIT
    OTHERWISE
      cUniStr += cChar
    END
    lSlash := .N.
  CASE cChar == '\'
    lSlash := .Y.
  OTHERWISE
    cUniStr += cChar
  END
NEXT

IF !EMPTY(cSeq)
  cUniStr += HMG_CHR(HB_HEXTONUM(cSeq))
END

RETURN cUniStr // HMG_ESCAPETOUTF8

//***************************************************************************

FUNCTION HMG_GETUNICODEVALUE(cStr)

LOCAL anCodes := {}
LOCAL nByte   := 0
LOCAL nCode   := 0
LOCAL nLen    := LEN(cStr)
LOCAL lCrawl  := !EMPTY(nLen)

WHILE lCrawl
  nByte := HMG_UTF8CRAWL(cStr, nByte, 1, @nCode)
  IF nByte <= nLen
    AADD(anCodes, nCode)
  ELSE
    lCrawl  := .N.
  END
END

RETURN anCodes // HMG_GETUNICODEVALUE

//***************************************************************************

FUNCTION HMG_GETUNICODECHARACTER(anCodes)

LOCAL cStr := ''
LOCAL nCode

FOR EACH nCode IN anCodes
  cStr += HMG_CHR(nCode)
NEXT

RETURN cStr // HMG_GETUNICODECHARACTER

//***************************************************************************

FUNCTION HMG_HASSPCHAR(cStr)

LOCAL lHasSpc := .N.
LOCAL nByte   := 0
LOCAL nCode   := 0
LOCAL nLen    := LEN(cStr)
LOCAL lCrawl  := !EMPTY(nLen)

WHILE lCrawl
  nByte := HMG_UTF8CRAWL(cStr, nByte, 1, @nCode)
  IF nByte <= nLen
    IF nCode >= 0x10000
      lHasSpc := .Y.
    END
  ELSE
    lCrawl  := .N.
  END
END

RETURN lHasSpc // HMG_HASSPCHAR

//***************************************************************************

FUNCTION HMG_CESU8(cInStr)

LOCAL cOutStr := ''
LOCAL nByte   := 0
LOCAL nCode   := 0
LOCAL nLen    := LEN(cInStr)
LOCAL lCrawl  := !EMPTY(nLen)

WHILE lCrawl
  nByte := HMG_UTF8CRAWL(cInStr, nByte, 1, @nCode)
  IF nByte <= nLen
    cOutStr += HMG_CHR(nCode, .Y.)
  ELSE
    lCrawl := .N.
  END
END

RETURN cOutStr // HMG_CESU8

//***************************************************************************

FUNCTION HMG_UNCESU8(cInStr)

LOCAL cOutStr := ''
LOCAL nByte   := 0
LOCAL nCode   := 0
LOCAL nLen    := LEN(cInStr)
LOCAL lCrawl  := !EMPTY(nLen)

WHILE lCrawl
  nByte := HMG_UTF8CRAWL(cInStr, nByte, 1, @nCode)
  IF nByte <= nLen
    cOutStr += HMG_CHR(nCode, .N.)
  ELSE
    lCrawl := .N.
  END
END

RETURN cOutStr // HMG_UNCESU8

//***************************************************************************

FUNCTION HMG_UTF8CRAWL(cStr, nOByte, nChars, nCode, cChar)

LOCAL lSeek  := .Y.
LOCAL lSurr  := .N.
LOCAL nByte1 := 0
LOCAL nByte2 := 0
LOCAL nByte3 := 0
LOCAL nByte4 := 0
LOCAL nByte5 := 0
LOCAL nByte6 := 0
LOCAL nBytes := 0
LOCAL nCByte := 0
LOCAL nChar  := 0
LOCAL nCode1 := 0
LOCAL nCode2 := 0
LOCAL nLen   := LEN(cStr)
LOCAL nNByte := nOByte

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

LOCAL bWord := {|nWLen, nChar1, nChar2, nChar3, nChar4|
  LOCAL nWord := 0
  SWITCH nWLen
  CASE 0
    nWord := 0
    EXIT
  CASE 1
    nWord := nChar1
    EXIT
  CASE 2
    nWord := INT( ;
      (nChar1 % 0x20) * 0x0040 + ;
      (nChar2 % 0x40)            )
    EXIT
  CASE 3
    nWord := INT( ;
      (nChar1 % 0x10) * 0x1000 + ;
      (nChar2 % 0x40) * 0x0040 + ;
      (nChar3 % 0x40)            )
    EXIT
  CASE 4
    nWord := INT( ;
      (nChar1 % 0x08) * 0x040000 + ;
      (nChar2 % 0x40) * 0x001000 + ;
      (nChar3 % 0x40) * 0x000040 + ;
      (nChar4 % 0x40)              )
    EXIT
  END
  RETURN nWord
  } // bWord

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

LOCAL bForSkip := {|nSByte|
  LOCAL nSBytes := -1
  nCByte := nSByte
  nByte1 := ASCPOS(cStr, nSByte)
  lSurr  := .N.
  DO CASE
  CASE EMPTY(nLen) .OR. nSByte < 0 .OR. nSByte > nLen
    nSBytes := 0
  CASE nSByte == 0
    nSBytes := 1
  CASE nByte1 >= 0x00 .AND. nByte1 <= 0x7F
    nSBytes := 1
  CASE nByte1 >= 0xC0 .AND. nByte1 <= 0xDF
    nSBytes := 2
  CASE nByte1 >= 0xE0 .AND. nByte1 <= 0xEF
    IF ( ;
      nByte1                              == 0xED .AND. ;
     (nByte2 := ASCPOS(cStr, nSByte + 1)) >= 0xA0 .AND. nByte2 <= 0xAF .AND. ;
     (nByte3 := ASCPOS(cStr, nSByte + 2)) >= 0x80 .AND. nByte3 <= 0xBF       )
      lSurr   := .Y.
      nSBytes := 6
    ELSE
      nSBytes := 3
    END
  CASE nByte1 >= 0xF0 .AND. nByte1 <= 0xF4
    nSBytes := 4
  OTHERWISE
    nSBytes := 1
  END
  RETURN nSBytes
  } // bForSkip

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

LOCAL bBackSkip := {|nSByte|
  LOCAL nSBytes := -1
  lSurr := .N.
  DO CASE
  CASE EMPTY(nLen) .OR. nSByte < 1 .OR. nSByte > nLen + 1
    nSBytes := 0
  CASE nSByte == 1 .OR. ;
      ((nByte1 := ASCPOS(cStr, nSByte - 1)) >= 0x00 .AND. nByte1 <= 0x7F)
    nSBytes := 1
  CASE (nByte1 := ASCPOS(cStr, nSByte - 2)) >= 0xC0 .AND. nByte1 <= 0xDF
    nSBytes := 2
  CASE (nByte1 := ASCPOS(cStr, nSByte - 3)) >= 0xE0 .AND. nByte1 <= 0xEF
    IF ( ;
       nByte1                              == 0xED .AND. ;
      (nByte2 := ASCPOS(cStr, nSByte - 2)) >= 0xB0 .AND. nByte2 <= 0xBF .AND. ;
      (nByte3 := ASCPOS(cStr, nSByte - 1)) >= 0x80 .AND. nByte3 <= 0xBF       )
      lSurr   := .Y.
      nSBytes := 6
    ELSE
      nSBytes := 3
    END
  CASE (nByte1 := ASCPOS(cStr, nSByte - 4)) >= 0xF0 .AND. nByte1 <= 0xF4
    nSBytes := 4
  OTHERWISE
    nSBytes := 1
  END
  nCByte := nSByte - nSBytes
  RETURN nSBytes
  } // bBackSkip

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

IF nChars == NIL
  nChars := 1
END

DO CASE
CASE nChars == 0
  nBytes := bForSkip:EVAL(nNByte)
CASE nChars == 1
  nBytes := bForSkip:EVAL(nNByte)
  nNByte += nBytes
  nBytes := bForSkip:EVAL(nNByte)
CASE nChars == -1
  nBytes := bBackSkip:EVAL(nNByte)
  nNByte -= nBytes
CASE nChars > 0
  WHILE lSeek
    nBytes := bForSkip:EVAL(nNByte)
    nNByte += nBytes
    nChar  ++
    IF EMPTY(nBytes) .OR. nChar == nChars
      lSeek := .N.
    END
  END
  nBytes := bForSkip:EVAL(nNByte)
CASE nChars < 0
  WHILE lSeek
    nBytes := bBackSkip:EVAL(nNByte)
    nNByte -= nBytes
    nChar  --
    IF EMPTY(nBytes) .OR. nChar == nChars
      lSeek := .N.
    END
  END
END

IF !lSurr
  nByte1 := ASCPOS(cStr, nNByte    )
  nByte2 := ASCPOS(cStr, nNByte + 1)
  nByte3 := ASCPOS(cStr, nNByte + 2)
  nByte4 := ASCPOS(cStr, nNByte + 3)
  nCode  := bWord:EVAL(nBytes, nByte1, nByte2, nByte3, nByte4)
ELSE
  nByte1 := ASCPOS(cStr, nNByte    )
  nByte2 := ASCPOS(cStr, nNByte + 1)
  nByte3 := ASCPOS(cStr, nNByte + 2)
  nByte4 := ASCPOS(cStr, nNByte + 3)
  nByte5 := ASCPOS(cStr, nNByte + 4)
  nByte6 := ASCPOS(cStr, nNByte + 5)
  nCode1 := bWord:EVAL(3, nByte1, nByte2, nByte3)
  nCode2 := bWord:EVAL(3, nByte4, nByte5, nByte6)
  nCode  := (nCode1 - 0xD800) * 0x400 + (nCode2 - 0xDC00) + 0x10000
END
cChar := SUBSTR(cStr, nNByte, nBytes)

RETURN nNByte // HMG_UTF8CRAWL

//***************************************************************************
