
MEMVAR _HMG_SYSDATA

#include "hmg.ch"
#include "hfcl.ch"
#include "common.ch"
#include "fileio.ch"


/*
    GetPropertyEx()
    Enhancement of GetProperty()
*/

*-----------------------------------------------------------------------------*
FUNCTION GetPropertyEx( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8 )
*-----------------------------------------------------------------------------*

LOCAL RetVal, hWnd, cType

DO CASE
CASE PCOUNT() == 3 .AND. VALTYPE( Arg1 ) == "C" .AND. VALTYPE( Arg2 ) == "C" .AND. VALTYPE( Arg3 ) == "C" .AND. ;
   _IsControlDefined( Arg2 , Arg1 )

   hWnd  := GetControlHandle( Arg2, Arg1 )
   cType := GetControlType( Arg2 , Arg1 )
   Arg3  := HMG_UPPER( ALLTRIM( Arg3 ))

   DO CASE
      CASE cType == "RICHEDIT"

         DO CASE
            CASE Arg3 == "HASNONASCIICHARS"
               RetVal := RichEditBox_HasNonAsciiChars( hWnd )
   
            CASE Arg3 == "HASNONANSICHARS"
               RetVal := RichEditBox_HasNonAnsiChars( hWnd )

         ENDCASE

   ENDCASE

CASE PCOUNT() == 4 .AND. VALTYPE( Arg1 ) == "C" .AND. VALTYPE( Arg2 ) == "C" .AND. VALTYPE( Arg3 ) == "N" .AND. VALTYPE( Arg4 ) == "N" .AND. ;
   _IsWindowDefined( Arg1 )

   hWnd := GetFormHandle( Arg1 )
   Arg2 := HMG_UPPER( ALLTRIM( Arg2 ))

   DO CASE
      CASE Arg2 == "GETSCREENPOS"
         RetVal := GetPos_ClientToScreen( hWnd, Arg3, Arg4 )
   
      CASE Arg2 == "GETWINDOWPOS"
         RetVal := GetPos_ScreenToClient( hWnd, Arg3, Arg4 )
   
   ENDCASE

CASE PCOUNT() == 5 .AND. VALTYPE( Arg1 ) == "C" .AND. VALTYPE( Arg2 ) == "C" .AND. VALTYPE( Arg3 ) == "C" .AND. VALTYPE( Arg4 ) == "N" .AND. VALTYPE( Arg5 ) == "N" .AND. ;
   _IsControlDefined( Arg2 , Arg1 )

   hWnd := GetControlHandle( Arg2, Arg1 )
   Arg3 := HMG_UPPER( ALLTRIM( Arg3 ))

   DO CASE
      CASE Arg3 == "GETSCREENPOS"
         RetVal := GetPos_ClientToScreen( hWnd, Arg4, Arg5 )
   
      CASE Arg3 == "GETCONTROLPOS"
         RetVal := GetPos_ScreenToClient( hWnd, Arg4, Arg5 )
   
   ENDCASE

ENDCASE

RETURN RetVal


/*
    DoMethodEx()
    Enhancement of DoMethod()
*/

*-----------------------------------------------------------------------------*
FUNCTION DoMethodEx( Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9 )
*-----------------------------------------------------------------------------*

LOCAL RetVal, hWnd, cType

DO CASE
CASE PCOUNT() >= 2 .AND. VALTYPE( Arg1 ) == "C" .AND. VALTYPE( Arg2 ) == "C" .AND. VALTYPE( Arg3 ) $ "ANU" .AND. VALTYPE( Arg4 ) $ "NU" .AND. ;
   _IsWindowDefined( Arg1 )

   DO CASE
      CASE Arg2 == "DRAWBORDER"
         RetVal := DrawWindowBorder( Arg1, Arg3, Arg4 )

   ENDCASE   

CASE PCOUNT() >= 4 .AND. VALTYPE( Arg1 ) == "C" .AND. VALTYPE( Arg2 ) == "C" .AND. VALTYPE( Arg3 ) == "C" .AND. VALTYPE( Arg4 ) == "C" .AND. ;
   _IsControlDefined( Arg2 , Arg1 )

   hWnd  := GetControlHandle( Arg2, Arg1 )
   cType := GetControlType( Arg2 , Arg1 )
   Arg3  := HMG_UPPER( ALLTRIM( Arg3 ))

   DO CASE
      CASE cType == "RICHEDIT"

         DO CASE
            CASE Arg3 == "LOADFILE"
               RetVal := RichEditBox_LoadFileEx( hWnd, Arg4, Arg5, Arg6 )

            CASE Arg3 == "SAVEFILE"
               RetVal := RichEditBox_SaveFileEx( hWnd, Arg4, Arg5, Arg6 )

         ENDCASE

   ENDCASE

ENDCASE

RETURN RetVal


/*
    RichEditBox_LoadFileEx()
    Enhancement of RichEditBox_LoadFile()

    Skips over byte order marks in Unicode text files.
    This function supports UTF-16 BE text files by using HMG_UTF16ByteSwap() 
    to first convert it a UTF-16 BE file to UTF-16 LE and then calling 
    RichEditBox_StreamInEx() on the UTF-16 LE file.
*/ 

*-----------------------------------------------------------------------------*
FUNCTION RichEditBox_LoadFileEx( hWndControl, cFile, lSelection, nType )
*-----------------------------------------------------------------------------*
LOCAL lSuccess := .F.
LOCAL cTempFile

   IF ValType( lSelection ) <> "L"
      lSelection := .F.
   ENDIF
   
   IF ValType( nType ) <> "N"
      nType := RICHEDITFILEEX_RTF
   ENDIF

   lSuccess := RichEditBox_RTFLoadResourceFile( hWndControl, cFile, lSelection )

   IF RichEditBox_RTFLoadResourceFile( hWndControl, cFile, lSelection )
      lSuccess := .T.
   ELSE
      IF nType == RICHEDITFILEEX_UTF16BE
         cTempFile := GETTEMPFOLDER() + "_RichEditLoadFile.txt"
         lSuccess  := HMG_UTF16ByteSwap( cFile, cTempFile )
         IF lSuccess
            lSuccess := RichEditBox_StreamInEx( hWndControl, cTempFile, lSelection, RICHEDITFILEEX_UTF16LE )
         ENDIF
         DELETE FILE ( cTempFile )
      ELSE
         lSuccess := RichEditBox_StreamInEx( hWndControl, cFile, lSelection, nType )
      ENDIF
   ENDIF

RETURN lSuccess



/*
    RichEditBox_SaveFileEx()
    Enhancement of RichEditBox_SaveFile()

    Writes byte order marks to Unicode text files.
    This function supports UTF-16 BE text files by first calling 
    RichEditBox_StreamOutEx() to generate a UTF-16 LE file and then calling 
    HMG_UTF16ByteSwap() to convert the UTF-16 LE file to UTF-16 BE.
*/ 

*-----------------------------------------------------------------------------*
FUNCTION RichEditBox_SaveFileEx( hWndControl, cFile, lSelection, nType )
*-----------------------------------------------------------------------------*
LOCAL lSuccess := .N.
LOCAL cTempFile

   IF ValType( lSelection ) <> "L"
      lSelection := .F.
   ENDIF
   
   IF ValType( nType ) <> "N"
      nType := RICHEDITFILEEX_RTF
   ENDIF

   IF nType == RICHEDITFILEEX_UTF16BE
      cTempFile := GETTEMPFOLDER() + "_RichEditLoadFile.txt"
      lSuccess := RichEditBox_StreamOutEx( hWndControl, cTempFile, lSelection, RICHEDITFILEEX_UTF16LE )
      IF lSuccess
         lSuccess  := HMG_UTF16ByteSwap( cTempFile, cFile )
      ENDIF
      DELETE FILE ( cTempFile )
   ELSE
      lSuccess := RichEditBox_StreamOutEx( hWndControl, cFile, lSelection, nType )
   ENDIF

RETURN lSuccess



/*
    RichEditBox_HasNonAsciiChars()

    This function tests for the presence of non-ASCII characters in a rich 
    edit control.  For efficiency, it does not distinguish between non-ASCII 
    ANSI and non-ASCII Unicode.
*/

*-----------------------------------------------------------------------------*
FUNCTION RichEditBox_HasNonAsciiChars( hWndControl )
*-----------------------------------------------------------------------------*

LOCAL cBuffer := RichEditBox_GetText( hWndControl, .N. )

RETURN HMG_IsNonASCII( cBuffer, .N. )



/*
    RichEditBox_HasNonAnsiChars()

    This function tests for the presence of non-ANSI characters in a rich 
    edit control.  It is slower than RichEditBox_HasNonAsciiChars but does 
    not reject any Unicode characters that are in ANSI.
*/

*-----------------------------------------------------------------------------*
FUNCTION RichEditBox_HasNonAnsiChars( hWndControl )
*-----------------------------------------------------------------------------*

LOCAL cBuffer := RichEditBox_GetText( hWndControl, .N. )

RETURN HMG_UTF8IsNonANSI( cBuffer )


/*
    GetRichEditFileType()

    This function returns the file type of an RTF file or text file, which 
    can be used as the file type parameter in the LoadFile, RtfLoadFile, 
    SaveFile, and RtfSaveFile methods.  This function examines the first few 
    bytes of the file to see if there is an RTF header or Unicode byte order 
    mark.
      
    When there is no RTF header or byte order mark:  If the optional 
    lUtf8Test argument is .T., then the whole file is scanned to see if it is 
    in UTF-8 format.  If so, then the file type is returned as UTF-8.  
    Otherwise the file type is returned as ANSI.

*/ 

*-----------------------------------------------------------------------------*
FUNCTION GetRichEditFileType( cFile, lUtf8Test )
*-----------------------------------------------------------------------------*

LOCAL hFile    := FOPEN( cFile, FO_READ )
LOCAL cBuffer  := SPACE( 5 )
LOCAL nBufRead := 0
LOCAL nType    := 0

LOCAL bIsUtf8NonAscii := {||
   LOCAL lUtf8NonAscii := .N.
   LOCAL cPartial := ''
      cBuffer  := SPACE( 0x400 )
      nBufRead := 1
      BEGIN SEQUENCE
         WHILE nBufRead > 0
            nBufRead := FREAD( hFile, @cBuffer, 0x400 )
            IF nBufRead > 0 .AND. HMG_IsUtf8Ex( cPartial + cBuffer, .N., .Y., @cPartial )
               lUtf8NonAscii := .Y.
               BREAK
            ENDIF
         ENDDO
         IF ! EMPTY( cPartial )
            lUtf8NonAscii := .N.
         ENDIF
      END SEQUENCE
   RETURN lUtf8NonAscii
   }

   BEGIN SEQUENCE

      IF hFile < 0
         BREAK
      ENDIF
      nBufRead := FREAD( hFile, @cBuffer, 5 )
      DO CASE
      CASE nBufRead >= 5 .AND. LEFT( cBuffer, 5 ) == "{\rtf"
         nType := RICHEDITFILEEX_RTF
      CASE nBufRead >= 3 .AND. LEFT( cBuffer, 3 ) == E"\xEF\xBB\xBF"
         nType := RICHEDITFILEEX_UTF8
      CASE nBufRead >= 2 .AND. LEFT( cBuffer, 2 ) == E"\xFF\xFE"
         nType := RICHEDITFILEEX_UTF16LE
      CASE nBufRead >= 2 .AND. LEFT( cBuffer, 2 ) == E"\xFE\xFF"
         nType := RICHEDITFILEEX_UTF16BE
      CASE ! EMPTY( lUtf8Test ) .AND. bIsUtf8NonAscii:EVAL( )
         nType := RICHEDITFILEEX_UTF8
      OTHERWISE
         nType := RICHEDITFILEEX_ANSI
      ENDCASE

   END SEQUENCE

   FCLOSE( hFile )

RETURN nType   

/*
    HMG_IsUTF8Ex()
    Enhancement of HMG_IsUTF8()

    Tests whether input string is UTF8.
    When cString is the empty string or is all ASCII:  If the optional 
      lAllowASCII argument is .T., then the return value is .T.  Otherwise 
      the return value is .F.
    When cString is valid UTF-8 except that it ends with an incomplete 
      UTF-8 byte sequence:  If the optional lAllowPartial argument is .T., 
      then the return value is .T. and the incomplete byte sequence is 
      passed back through the cPartial argument.  Otherwise the return 
      value is .F.  This is useful when cString is a file buffer.
    The return value is .F. if cString encodes any code point greater than 
      the Unicode limit of 0x10FFFF, or if it encodes any surrogate 
      character, or if it contains an overlong UTF-8 byte sequence.  One 
      overlong sequnce is accepted, the 2-byte overlong sequence for the 
      null character (0xC0 0x80), which is commonly accepted by UTF-8 
      parsers.
*/ 

*-----------------------------------------------------------------------------*
FUNCTION HMG_IsUTF8Ex( cString, lAllowASCII, lAllowPartial, cPartial )
*-----------------------------------------------------------------------------*

LOCAL lASCII  := .T.
LOCAL lCheck  := .F.
LOCAL lUTF8   := .T.
LOCAL nCBytes := 0
LOCAL nRBytes := 0
LOCAL cChar, nChar, nLead

   IF lAllowASCII == NIL
      lAllowASCII := .F.
   ENDIF
   IF lAllowPartial == NIL
      lAllowPartial := .F.
   ENDIF

   BEGIN SEQUENCE

      FOR EACH cChar IN cString

         nChar := HB_BCODE( cChar )

         IF nCBytes > 0 // check continuation bytes

            IF nChar < 0x80 .OR. nChar > 0xBF // disallow invalid continuation byte
               BREAK
            ENDIF
            IF lCheck // check first continuation byte for partially valid lead byte
               SWITCH nLead
               CASE 0xC0 // disallow 2-byte overlongs except overlong null character
                  IF nChar != 0x80
                     BREAK
                  ENDIF
                  EXIT
               CASE 0xE0 // disallow 3-byte overlongs
                  IF nChar < 0xA0
                     BREAK
                  ENDIF
                  EXIT
               CASE 0xED // disallow surrogates
                  IF nChar > 0x9F
                     BREAK
                  ENDIF
                  EXIT
               CASE 0xF0 // disallow 4-byte overlongs
                  IF nChar < 0x90
                     BREAK
                  ENDIF
                  EXIT
               CASE 0xF4 // disallow 4-byte sequences beyond end of Unicode
                  IF nChar > 0x8F
                     BREAK
                  ENDIF
                  EXIT
               ENDSWITCH
               lCheck := .F.
            ENDIF
            nCBytes --
            nRBytes ++

         ELSEIF nChar >= 0x80 // check lead byte

            lASCII := .F.
            nLead := nChar
            IF nLead < 0xC0 .OR. nLead == 0xC1 .OR. nLead > 0xF4 // disallow invalid lead bytes
               BREAK
            ENDIF
            lCheck := ( nLead == 0xC0 .OR. nLead == 0xE0 .OR. nLead == 0xED .OR. ;
              nLead == 0xF0 .OR. nLead == 0xF4 ) // partially valid lead bytes

            DO CASE // compute number of continuation bytes
            CASE nLead <= 0xDF
              nCBytes := 1
            CASE nLead <= 0xEF
              nCBytes := 2
            OTHERWISE
              nCBytes := 3
            ENDCASE
            nRBytes := 1

         ENDIF

      NEXT

   RECOVER

      lUTF8 := .F.

   END SEQUENCE

   IF lUTF8 .AND. nCBytes > 0
      IF lAllowPartial
         cPartial := RIGHT( cString, nRBytes )
      ELSE
         lUTF8 := .F.
      ENDIF
   ELSE
      IF lAllowPartial
         cPartial := ''
      ENDIF
   ENDIF

   IF ! lAllowASCII .AND. lASCII
      lUTF8 := .F.
   ENDIF

RETURN lUTF8


/*
    HMG_IsNonASCII()

    Tests whether a string contains any non-ASCII characters.
*/

*-----------------------------------------------------------------------------*
FUNCTION HMG_IsNonASCII( cString )
*-----------------------------------------------------------------------------*

LOCAL lNonASCII := .F.
LOCAL cChar

   BEGIN SEQUENCE
      FOR EACH cChar IN cString
         IF cChar >= CHR( 0x80 )
            lNonASCII := .T.
            BREAK
         ENDIF
      NEXT
   END SEQUENCE

RETURN lNonASCII


/*
    HMG_UTF8IsNonANSI()

    Determines whether a UTF-8 string contains any non-ANSI characters.
    It does not check whether the string is valid UTF-8.
*/

*-----------------------------------------------------------------------------*
FUNCTION HMG_UTF8IsNonANSI( cUtf8Str )
*-----------------------------------------------------------------------------*

LOCAL aAnsiTrans := { ;
   0x20AC, ; // ANSI 0x80 - EURO SIGN
   0x201A, ; // ANSI 0x82 - SINGLE LOW-9 QUOTATION MARK
   0x0192, ; // ANSI 0x83 - LATIN SMALL LETTER F WITH HOOK
   0x201E, ; // ANSI 0x84 - DOUBLE LOW-9 QUOTATION MARK
   0x2026, ; // ANSI 0x85 - HORIZONTAL ELLIPSIS
   0x2020, ; // ANSI 0x86 - DAGGER
   0x2021, ; // ANSI 0x87 - DOUBLE DAGGER
   0x02C6, ; // ANSI 0x88 - MODIFIER LETTER CIRCUMFLEX ACCENT
   0x2030, ; // ANSI 0x89 - PER MILLE SIGN
   0x0160, ; // ANSI 0x8A - LATIN CAPITAL LETTER S WITH CARON
   0x2039, ; // ANSI 0x8B - SINGLE LEFT-POINTING ANGLE QUOTATION MARK
   0x0152, ; // ANSI 0x8C - LATIN CAPITAL LIGATURE OE
   0x017D, ; // ANSI 0x8E - LATIN CAPITAL LETTER Z WITH CARON
   0x2018, ; // ANSI 0x91 - LEFT SINGLE QUOTATION MARK
   0x2019, ; // ANSI 0x92 - RIGHT SINGLE QUOTATION MARK
   0x201C, ; // ANSI 0x93 - LEFT DOUBLE QUOTATION MARK
   0x201D, ; // ANSI 0x94 - RIGHT DOUBLE QUOTATION MARK
   0x2022, ; // ANSI 0x95 - BULLET
   0x2013, ; // ANSI 0x96 - EN DASH
   0x2014, ; // ANSI 0x97 - EM DASH
   0x02DC, ; // ANSI 0x98 - SMALL TILDE
   0x2122, ; // ANSI 0x99 - TRADE MARK SIGN
   0x0161, ; // ANSI 0x9A - LATIN SMALL LETTER S WITH CARON
   0x203A, ; // ANSI 0x9B - SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
   0x0153, ; // ANSI 0x9C - LATIN SMALL LIGATURE OE
   0x017E, ; // ANSI 0x9E - LATIN SMALL LETTER Z WITH CARON
   0x0178  } // ANSI 0x9F - LATIN CAPITAL LETTER Y WITH DIAERESIS
LOCAL aAnsiSkip  := { ;
   0x81, ;
   0x8D, ;
   0x8F, ;
   0x90, ;
   0x9D  }

LOCAL lNonANSI := .F.
LOCAL nOctets  := 0
LOCAL cChar, nChar, nCode

   BEGIN SEQUENCE

      FOR EACH cChar IN cUtf8Str

         nChar := HB_BCODE( cChar )

         IF nOctets != 0

            --nOctets
            nCode := HB_BITOR( HB_BITSHIFT( nCode, 6 ), HB_BITAND( nChar, 0x3F ) )
            IF nOctets == 0
               DO CASE
               CASE nCode >= 0x100
                  IF ASCAN( aAnsiTrans, nCode ) == 0
                     lNonANSI := .T.
                  ENDIF
               CASE nCode >= 0xA0
               CASE nCode >= 0x80
                  IF ASCAN( aAnsiSkip, nCode ) == 0
                     lNonANSI := .T.
                  ENDIF                  
               ENDCASE
            ENDIF

         ELSEIF HB_BITAND( nChar, 0x80 ) != 0

            DO WHILE HB_BITAND( nChar, 0x80 ) != 0
               nChar := HB_BITAND( HB_BITSHIFT ( nChar, 1 ), 0xFF )
               ++nOctets
            ENDDO
            --nOctets
            nCode := HB_BITAND( HB_BCODE( cChar ), HB_BITSHIFT( 1, nOctets ) - 1 )

         ENDIF

      NEXT

   END SEQUENCE

RETURN lNonANSI


/*
    HMG_UTF16ByteSwap()

    Converts between UTF-16 LE and UTF-16 BE file contents.
*/

*-----------------------------------------------------------------------------*
FUNCTION HMG_UTF16ByteSwap( cInFile, cOutFile )
*-----------------------------------------------------------------------------*

LOCAL hInFile   := FOPEN( cInFile , FO_READ )
LOCAL hOutFile  := FCREATE( cOutFile )
LOCAL cInBuffer := SPACE( 0x400 )
LOCAL nBufRead  := 1
LOCAL lSuccess  := .N.
LOCAL cOutBuffer, cBytePair, nBufWrite, nByte

   BEGIN SEQUENCE

      IF hInFile < 0
         BREAK
      ENDIF
      IF hOutFile < 0
         BREAK
      ENDIF

      WHILE nBufRead > 0

         cOutBuffer := ""
         nBufRead   := FREAD( hInFile, @cInBuffer, 0x400 )
         IF nBufRead > 0
            FOR nByte := 1 TO nBufRead STEP 2
               cBytePair  := SUBSTR( cInBuffer, nByte, 2 )
               cOutBuffer += RIGHT( cBytePair, 1 ) + LEFT( cBytePair, 1 )
            NEXT
            nBufWrite := FWRITE( hOutFile, cOutBuffer )
            IF nBufWrite < nBufRead
               BREAK
            ENDIF
         ENDIF

      ENDDO

      lSuccess := .Y.
    
   END SEQUENCE

   FCLOSE( hInFile )
   FCLOSE( hOutFile )

RETURN lSuccess


/*
    HMG_PrintDialogEx()

    Displays print dialog as child of parent window.
*/

*-----------------------------------------------------------------------------*
FUNCTION HMG_PrintDialogEx( cParentForm )
*-----------------------------------------------------------------------------*

LOCAL nParentForm, aPrintSelect

  IF EMPTY(cParentForm) .AND. _HMG_SYSDATA[ 264 ]
    cParentForm := _HMG_SYSDATA[ 223 ]
  ENDIF
  IF !EMPTY(cParentForm)
    nParentForm := GetFormHandle(cParentForm)
  ENDIF
  aPrintSelect := _HMG_PRINTER_PrintDialog_Ex( nParentForm )

RETURN aPrintSelect


/*
    GetPos_ClientToScreen()

    Converts window or control coordinates to screen coordinates.
*/

*-----------------------------------------------------------------------------*
FUNCTION GetPos_ClientToScreen( hWnd, nClientRow, nClientCol )
*-----------------------------------------------------------------------------*

LOCAL nScreenRow := nClientRow
LOCAL nScreenCol := nClientCol
LOCAL aScreenRowCol

  ClientToScreen(hWnd, @nScreenCol, @nScreenRow)
  aScreenRowCol := {nScreenRow, nScreenCol}

RETURN aScreenRowCol


/*
    GetPos_ScreenToClient()

    Converts screen coordinates to window or control coordinates.
*/

*-----------------------------------------------------------------------------*
FUNCTION GetPos_ScreenToClient( hWnd, nScreenRow, nScreenCol )
*-----------------------------------------------------------------------------*

LOCAL nClientRow := nScreenRow
LOCAL nClientCol := nScreenCol
LOCAL aClientRowCol

  ScreenToClient(hWnd, @nClientCol, @nClientRow)
  aClientRowCol := {nClientRow, nClientCol}

RETURN aClientRowCol


/*
    GetPos_ScreenToClient()

    Converts screen coordinates to window or control coordinates.
*/

*-----------------------------------------------------------------------------*
PROCEDURE DrawWindowBorder( cWindow, aColor, nThick )
*-----------------------------------------------------------------------------*

LOCAL nWidth  := GETPROPERTY( cWindow, 'WIDTH'  )
LOCAL nHeight := GETPROPERTY( cWindow, 'HEIGHT' )
LOCAL nOTop, nITop, nOLeft, nILeft, nOBottom, nIBottom, nORight, nIRight, nHThick

  IF EMPTY( nThick )
    nThick := 1
  ENDIF
  nHThick  := INT(( nThick + 1 ) / 2 )
  nOTop    := 0
  nITop    := nHThick - 1
  nOLeft   := 0
  nILeft   := nHThick - 1
  nOBottom := nHeight - 1
  nIBottom := nHeight - nHThick
  nORight  := nWidth  - 1
  nIRight  := nWidth  - nHThick

  DRAWLINE( cWindow, nOTop   , nILeft , nOBottom, nILeft , aColor, nThick )
  DRAWLINE( cWindow, nOTop   , nIRight, nOBottom, nIRight, aColor, nThick )
  DRAWLINE( cWindow, nITop   , nOLeft , nITop   , nORight, aColor, nThick )
  DRAWLINE( cWindow, nIBottom, nOLeft , nIBottom, nORight, aColor, nThick )

RETURN

