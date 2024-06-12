/*
use xharbour function !!!!! This is a workaround only !!!!!
use a função do xharbour !!!!! Este é apenas um quebra-galho !!!!!

2024-04-12 - Simple test. Today error/situation about variable ins't a hash
*/


REQUEST HB_CODEPAGE_PTISO

PROCEDURE Main

   LOCAL xValue, xTeste, cTxt

   Set( _SET_CODEPAGE, "PTISO" )
   SET DATE BRITISH
   SetMode( 40, 100 )

   xTeste := hb_Hash()
   xTeste[ "codigo" ] := 1
   xTeste[ "nome" ] := "Jose Quintas"

   cTxt := hb_JsonEncode( xTeste )

   xValue := ze_JsonDecode( cTxt )
   ( xValue )
   Inkey(0)

   RETURN

FUNCTION ze_JsonDecode( cTxt )

   LOCAL xValue

   ze_JsonDecodeValue( cTxt, @xValue )

   RETURN xValue

FUNCTION ze_JsonDecodeValue( cTxt, xValue )

   LOCAL xValue2, lReturn := .F.

   DO WHILE Len( cTxt ) > 0
      DO WHILE Left( cTxt, 1 ) $ " " + Chr(13) + Chr(10) .AND. Len( cTxt ) > 0
         cTxt := Substr( cTxt, 2 )
      ENDDO
      DO CASE
      CASE Left( cTxt, 1 ) $ "]}"
         lReturn := .F.
         cTxt := Substr( cTxt, 2 )
         EXIT
      CASE Left( cTxt, 1 ) == "["
         xValue := {}
         cTxt := Substr( cTxt, 2 )
         DO WHILE ze_JsonDecodeValue( @cTxt, @xValue2 )
            AAdd( xValue, xValue2 )
            xValue2 := Nil
         ENDDO
         lReturn := .T.
         EXIT
      CASE Left( cTxt, 1 ) == "{"
         xValue := hb_Hash()
         cTxt := Substr( cTxt, 2 )
         DO WHILE ze_JsonDecodeValue( @cTxt, @xValue )
         ENDDO
         lReturn := .T.
         EXIT
      CASE Left( cTxt, 1 ) $ "-0123456789"
         xValue := ""
         DO WHILE Left( cTxt, 1 ) $ "-0123456789." .AND. Len( cTxt ) > 0
            xValue += Left( cTxt, 1 )
            cTxt := Substr( cTxt, 2 )
         ENDDO
         xValue := Val( xValue )
         lReturn := .T.
         EXIT
      CASE Left( cTxt, 5 ) == "false"
         xValue := .F.
         cTxt := Substr( cTxt, 6 )
         lReturn := .T.
         EXIT
      CASE Left( cTxt, 4 ) == "null"
         xValue := Nil
         cTxt := Substr( cTxt, 5 )
         lReturn := .T.
         EXIT
      CASE Left( cTxt, 4 ) == "true"
         xValue := .T.
         cTxt := Substr( cTxt, 5 )
         lReturn := .T.
         EXIT
      CASE Left( cTxt, 1 ) == ["]
         // pode ser string ou item hash
         xValue2 := ""
         cTxt := Substr( cTxt, 2 )
         DO WHILE Len( cTxt ) > 0
            DO CASE
            CASE Left( cTxt, 2 ) == [\"]
               xValue2 += ["]
               cTxt := Substr( cTxt, 3 )
               LOOP
            CASE Left( cTxt, 2 ) == "\\"
               xValue2 += "\"
               cTxt := Substr( cTxt, 3 )
               LOOP
            CASE Left( cTxt, 2 ) == "\r" // return
               xValue2 += Chr(13)
               cTxt := Substr( cTxt, 3 )
               LOOP
            CASE Left( cTxt, 2 ) == "\n" // newline
               xValue2 += Chr(10)
               cTxt := Substr( cTxt, 3 )
               LOOP
            CASE Left( cTxt, 2 ) == "\f" // formfeed
               xValue2 += Chr(12)
               cTxt := Substr( cTxt, 3 )
               LOOP
            CASE Left( cTxt, 2 ) == "\b" // backspace
               xValue2 += Chr(8)
               cTxt := Substr( cTxt, 3 )
               LOOP
            CASE Left( cTxt, 2 ) == "\t" // tab
               xValue2 += Chr(9)
               cTxt := Substr( cTxt, 3 )
               LOOP
            ENDCASE
            IF Left( cTxt, 1 ) == ["]
               cTxt := Substr( cTxt, 2 )
               EXIT
            ENDIF
            xValue2 += Left( cTxt, 1 )
            cTxt := Substr( cTxt, 2 )
         ENDDO
         IF Left( cTxt, 1 ) == ":"
            xValue[ xValue2 ] := Nil
            cTxt := Substr( cTxt, 2 )
            ze_JsonDecodeValue( @cTxt, @xValue[ xValue2 ] )
            lReturn := .T.
            EXIT
         ELSE
            IF Len( xValue2 ) == 8 .AND. Dtos( Stod( xValue2 ) ) == xValue2
               xValue := Stod( xValue2 )
            ELSE
               xValue := xValue2
            ENDIF
            lReturn := .T.
            EXIT
         ENDIF
      ENDCASE
      cTxt := Substr( cTxt, 2 )
   ENDDO
   DO WHILE Left( cTxt, 1 ) $ ", " + Chr(13) + Chr(10) .AND. Len( cTxt ) > 0
      cTxt := Substr( cTxt, 2 )
   ENDDO

   RETURN lReturn

FUNCTION AppUserName(); RETURN ""
FUNCTION AppVersaoExe(); RETURN ""
