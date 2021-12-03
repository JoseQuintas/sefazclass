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

MEMVAR _HMG_SYSDATA


#include 'hmg.ch'
#include 'common.ch'
#include 'fileio.ch'

*-------------------------------------------------------------
FUNCTION BeginIni(name, cIniFile )
*-------------------------------------------------------------
    LOCAL hFile := 0

    * Unused Parameter
    name := Nil
    *

    if HB_UAT("\",cIniFile)==0
       cIniFile := ".\"+cIniFile
    endif

    If ! File( cIniFile )
        // by Dr. Claudio Soto, December 2014
        IF HMG_IsCurrentCodePageUnicode() == .T.
           HMG_CreateFile_UTF16LE_BOM ( cIniFile )   // The Windows native Unicode character set is in UTF-16LE
        ELSE
            hFile := FCreate( cIniFile )
        ENDIF
    Else
        hFile := FOpen( cIniFile, FO_READ + FO_SHARED )
    EndIf

    If FError() != 0
       MsgInfo( "Error opening a file INI. DOS ERROR: " + STR( FError(), 2, 0 ) )
       Return ""
    else
       _HMG_SYSDATA [ 219 ] := cIniFile
    EndIf

    FClose( hFile )
Return Nil


// Code GetIni and SetIni based on sorce of Grigory Filatov

Function _GetIni( cSection, cEntry, cDefault, uVar )
    Local cFile, cVar :=''

    If !empty(_HMG_SYSDATA [ 219 ])
      if valtype(cDefault) == 'U'
        cDefault:=cVar
      endif
      cFile:=_HMG_SYSDATA [ 219 ]
      cVar := GetPrivateProfileString(cSection, cEntry, xChar( cDefault ), cFile )
    else
      if cDefault != NIL
          cVar := xChar( cDefault )
      endif
    endif
    uVar :=xValue(cVar,ValType( uVar))
Return uVar


Function _SetIni( cSection, cEntry, cValue )
    Local ret:=.f., cFile
    If !empty(_HMG_SYSDATA [ 219 ])
        cFile:= _HMG_SYSDATA [ 219 ]
        ret :=WritePrivateProfileString( cSection, cEntry, xChar(cValue), cFile )
    endif
Return ret


Function  _DelIniEntry( cSection, cEntry )
    Local ret:=.f., cFile
    If !empty(_HMG_SYSDATA [ 219 ])
        cFile:= _HMG_SYSDATA [ 219 ]
        ret := DelIniEntry( cSection, cEntry, cFile )
    endif
Return ret


Function  _DelIniSection( cSection )
    Local ret:=.f., cFile
    If !empty(_HMG_SYSDATA [ 219 ])
        cFile:= _HMG_SYSDATA [ 219 ]
        ret := DelIniSection( cSection, cFile )
    endif
Return ret


*-------------------------------------------------------------
Function _EndIni()
*-------------------------------------------------------------
   _HMG_SYSDATA [ 219 ] :=''
Return Nil



FUNCTION xChar( xValue )
   LOCAL cType := ValType( xValue )
   LOCAL cValue := "", nDecimals := Set( _SET_DECIMALS)
   DO CASE
      CASE cType $  "CM";  cValue := xValue
//    CASE cType == "N" ;  cValue := LTRIM( STR( xValue, 20, nDecimals ) )
      CASE cType == "N" ;  nDecimals := IIF( xValue == Int( xValue ), 0, nDecimals ) ; cValue := LTrim( Str( xValue, 20, nDecimals ) )
      CASE cType == "D" ;  cValue := DToS( xValue )
      CASE cType == "L" ;  cValue := IIF( xValue, "T", "F" )
      CASE cType == "A" ;  cValue := AToC( xValue )
      CASE cType $  "UE";  cValue := "NIL"
      CASE cType == "B" ;  cValue := "{|| ... }"
      CASE cType == "O";   cValue := "{" + xValue:className + "}"
   ENDCASE
RETURN cValue


FUNCTION xValue( cValue, cType )
   LOCAL xValue
   DO CASE
      CASE cType $  "CM";  xValue := cValue
      CASE cType == "D" ;  xValue := SToD( cValue )
      CASE cType == "N" ;  xValue := Val( cValue )
      CASE cType == "L" ;  xValue := ( cValue == 'T' )
      CASE cType == "A" ;  xValue := CToA( cValue )
      OTHERWISE;           xValue := NIL                     // nil, block, object
   ENDCASE
RETURN xValue


FUNCTION AToC( aArray )
   LOCAL i, nLen := HMG_LEN( aArray )
   LOCAL cType, cElement, cArray := ""
   FOR i := 1 TO nLen
      cElement := xChar( aArray[ i ] )
      IF ( cType := ValType( aArray[ i ] ) ) == "A"
         cArray += cElement
      ELSE
         cArray += HB_ULEFT( cType, 1) + STR( HMG_LEN( cElement ),4 ) + cElement
      ENDIF
   ENDFOR
RETURN "A" + STR( HMG_LEN( cArray ),4 ) + cArray


FUNCTION CToA( cArray )
   LOCAL cType, nLen, aArray := {}

   cArray := HB_USUBSTR( cArray, 6 )    // strip off array and length

     WHILE HMG_LEN( cArray ) > 0
      nLen := Val( HB_USUBSTR( cArray, 2, 4 ) )
      IF ( cType := HB_ULEFT( cArray, 1 ) ) == "A"
          AAdd( aArray, CToA( HB_USUBSTR( cArray, 1, nLen + 5 ) ) )
      ELSE
          AAdd( aArray, xValue( HB_USUBSTR( cArray, 6, nLen ), cType ) )
      ENDIF
      cArray := HB_USUBSTR( cArray, 6 + nLen )
   END
RETURN aArray

