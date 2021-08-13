/*
ZE_INSCESTADUAL - Checagem de inscrição estadual
José Quintas
*/

FUNCTION ValidIE( cInscricao, cUF )

   LOCAL lOk := .T., nLen

   IF Trim( cInscricao ) == "ISENTO" .OR. Trim( cInscricao ) == "NAOCONTRIBUINTE"
      RETURN .T.
   ENDIF
   nLen       := Len( cInscricao )
   cInscricao := SoNumeros( cInscricao )
   DO CASE
   CASE cUf == "AC" ; lOk := ValidIE_AC( @cInscricao )
   CASE cUf == "AL" ; lOk := ValidIE_AL( @cInscricao )
   CASE cUf == "AP" ; lOk := ValidIE_AP( @cInscricao )
   CASE cUf == "AM" ; lOk := ValidIE_AM( @cInscricao )
   CASE cUf == "BA" ; lOk := ValidIE_BA( @cInscricao )
   CASE cUf == "CE" ; lOk := ValidIE_CE( @cInscricao )
   CASE cUf == "DF" ; lOk := ValidIE_DF( @cInscricao )
   CASE cUf == "ES" ; lOk := ValidIE_ES( @cInscricao )
   CASE cUf == "GO" ; lOk := ValidIE_GO( @cInscricao )
   CASE cUf == "MA" ; lOk := ValidIE_MA( @cInscricao )
   CASE cUf == "MG" ; lOk := ValidIE_MG( @cInscricao )
   CASE cUf == "MS" ; lOk := ValidIE_MS( @cInscricao )
   CASE cUf == "MT" ; lOk := ValidIE_MT( @cInscricao )
   CASE cUf == "PA" ; lOk := ValidIE_PA( @cInscricao )
   CASE cUf == "PB" ; lOk := ValidIE_PB( @cInscricao )
   CASE cUf == "PE" ; lOk := ValidIE_PE( @cInscricao )
   CASE cUf == "PI" ; lOk := ValidIE_PI( @cInscricao )
   CASE cUf == "PR" ; lOk := ValidIE_PR( @cInscricao )
   CASE cUf == "RJ" ; lOk := ValidIE_RJ( @cInscricao )
   CASE cUf == "RN" ; lOk := ValidIE_RN( @cInscricao )
   CASE cUf == "RR" ; lOk := ValidIE_RR( @cInscricao )
   CASE cUf == "RS" ; lOk := ValidIE_RS( @cInscricao )
   CASE cUf == "RO" ; lOk := ValidIE_RO( @cInscricao )
   CASE cUf == "SC" ; lOk := ValidIE_SC( @cInscricao )
   CASE cUf == "SE" ; lOk := ValidIE_SE( @cInscricao )
   CASE cUf == "SP" ; lOk := ValidIE_SP( @cInscricao )
   CASE cUf == "TO" ; lOk := ValidIE_TO( @cInscricao )
   ENDCASE
   cInscricao := Pad( cInscricao, nLen )

   RETURN lOk

STATIC FUNCTION ValidIE_AC( cInscricao )

   LOCAL lOk := .T., nSoma

   IF Len( cInscricao ) != 13 .AND. Len( cInscricao ) != 9
      lOk := .F.
   ELSEIF Left( cInscricao, 2 ) != "01" // Sempre 01
      lOk := .F.
   ELSEIF Len( cInscricao ) == 9 // ate 11/99
      nSoma := SomaModulo11( Substr( cInscricao, 1, 8 ) )
      nSoma := 11 - Mod( nSoma, 11 )
      nSoma := iif( nSoma > 9, nSoma - 10, nSoma )
      IF nSoma != Val( Substr( cInscricao, 9, 1 ) )
         lOk := .F.
      ENDIF
   ELSE // a partir de 11/99 - 13 digitos
      IF CalculaDigito( Substr( cInscricao, 1, 11 ), "11" ) != Substr( cInscricao, 12, 1 )
         lOk := .F.
      ENDIF
      IF CalculaDigito( Substr( cInscricao, 1, 12 ), "11" ) != Substr( cInscricao, 13, 1 )
         lOk := .F.
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 99.999.999/999-99" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_AL( cInscricao )

   LOCAL lOk := .T., nSoma

   DO CASE
   CASE Len( cInscricao ) != 9
      lOk := .F.
   CASE Left( cInscricao, 2 ) != "24" // Sempre 24
      lOk := .F.
   CASE ! Substr( cInscricao, 3, 1 ) $ "023578" // o=normal,3=prod.rural,8=ME
      lOk := .F.                       // 5=substituta 7=ME ambulante
   OTHERWISE
      nSoma := SomaModulo11( Substr( cInscricao, 1, 8 ) )
      nSoma  := nSoma * 10
      nSoma  := nSoma - ( Int( nSoma / 11 ) * 11 )
      nSoma  := iif( nSoma == 10, 0, nSoma )
      IF nSoma != Val( Substr( cInscricao, 9, 1 ) )
         lOk := .F.
      ENDIF
   ENDCASE
   IF lOk
      cInscricao := Transform( cInscricao, "@R 999999999" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_AM( cInscricao )

   LOCAL lOk := .T.

   IF Len( cInscricao ) != 9
      lOk := .F.
   ELSE
      IF CalculaDigito( Substr( cInscricao, 1, 8 ), "11" ) != Substr( cInscricao, 9, 1 )
         lOk := .F.
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 99.999.999-9" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_AP( cInscricao )

   LOCAL lOk := .T., nValor1, nValor2, nSoma

   IF Len( cInscricao ) != 9
      lOk := .F.
   ELSEIF Left( cInscricao, 2 ) != "03" // Sempre 03
      lOk := .F.
   ELSE
      IF Val( Substr( cInscricao, 1, 8 ) ) < 3017001
         nValor1 := 5
         nValor2 := 0
      ELSEIF Val( Substr( cInscricao, 1, 8 ) ) < 3019023
         nValor1 := 9
         nValor2 := 1
      ELSE
         nValor1 := 0
         nValor2 := 0
      ENDIF
      nSoma := nValor1 + SomaModulo11( Substr( cInscricao, 1, 8 ) )
      nSoma := 11 - Mod( nSoma, 11 )
      IF nSoma == 11
         nSoma := nValor2
      ELSEIF nSoma == 10
         nSoma := 0
      ENDIF
      IF nSoma != Val( Substr( cInscricao, 9, 1 ) )
         lOk := .F.
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 999999999" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_BA( cInscricao )

   LOCAL lOk := .T., nSoma, oElement, nModulo, cTmp

   IF Len( cInscricao ) != 8 .AND. Len( cInscricao ) != 9
      lOk := .F.
   ELSEIF Len( cInscricao ) == 8
      IF Left( cInscricao, 1 ) $ "0123458" // A formula varia conforme inicio
         nSoma := SomaModulo11( Substr( cInscricao, 1, 6 ) )
         nSoma := 10 - Mod( nSoma, 10 )
         IF nSoma == 10
            nSoma := 0
         ENDIF
         IF nSoma != Val( Substr( cInscricao, 8, 1 ) ) // Compara com 2o.digito
            lOk := .F.
         ELSE                                   // Primeiro digito
            nSoma := SomaModulo11( Substr( cInscricao, 1, 6 ) + Substr( cInscricao, 8, 1 ) )
            nSoma := 10 - Mod( nSoma, 10 )
            IF nSoma == 10
               nSoma := 0
            ENDIF
            IF nSoma != Val( Substr( cInscricao, 7, 1 ) ) // Compara com 1o.digito
               lOk := .F.
            ENDIF
         ENDIF
      ELSE // iniciando com 6,7,9
         IF CalculaDigito( Substr( cInscricao, 1, 6 ), "11" ) != Substr( cInscricao, 8, 1 ) // Compara com 2o.digito
            lOk := .F.
         ELSE // Primeiro digito
            IF CalculaDigito( Substr( cInscricao, 1, 6 ) + Substr( cInscricao, 8, 1 ), "11" ) != Substr( cInscricao, 7, 1 ) // Compara com 1o.digito
               lOk := .F.
            ENDIF
         ENDIF
      ENDIF
      IF lOk
         cInscricao := Transform( cInscricao, "@R 999.999-99" )
      ENDIF
   ELSEIF Len( cInscricao ) == 9
      nSoma   := 0
      nModulo := iif( Substr( cInscricao, 2, 1 ) $ "0,1,2,3,4,5,8", 10, 11 )
      FOR EACH oElement IN Substr( cInscricao, 1, 7 ) DESCEND
         nSoma += Val( oElement ) * ( 9 - oElement:__EnumIndex  )
      NEXT
      nSoma := nModulo - Mod( nSoma, nModulo )
      IF nSoma > 9
         nSoma := 0
      ENDIF
      IF Str( nSoma, 1 ) != Substr( cInscricao, 9, 1 )
         lOk := .F.
      ENDIF
      nSoma := 0
      cTmp := Substr( cInscricao, 1, 7 ) + Substr( cInscricao, 9, 1 )
      FOR EACH oElement IN cTmp DESCEND
         nSoma += Val( oElement ) * ( 10 - oElement:__EnumIndex  )
      NEXT
      nSoma := nModulo - Mod( nSoma, nModulo )
      IF nSoma > 9
         nSoma := 0
      ENDIF
      IF Str( nSoma, 1 ) != Substr( cInscricao, 8, 1 )
         lOk := .F.
      ENDIF

   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_CE( cInscricao )

   LOCAL lOk := .T.

   IF Len( cInscricao ) != 9
      lOk := .F.
   ELSE
      IF CalculaDigito( Substr( cInscricao, 1, 8 ), "11" ) != Substr( cInscricao, 9, 1 )
         lOk := .F.
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 99.999999-9" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_DF( cInscricao )

   LOCAL lOk := .T.

   IF Len( cInscricao ) != 13
      lOk := .F.
   //ELSEIF Left( cInscricao, 2 ) != "07" // Alterado em 23/07 p/ 2 dig
   //   lOk := .F.
   ELSE
      IF CalculaDigito( Substr( cInscricao, 1, 11 ), "11" ) != Substr( cInscricao, 12, 1 )
         lOk := .F.
      ELSE
         IF CalculaDigito( Substr( cInscricao, 1, 12 ), "11" ) != Substr( cInscricao, 13, 1 )
            lOk := .F.
         ENDIF
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 99.999999.999-99" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_ES( cInscricao )

   LOCAL lOk := .T.

   IF Len( cInscricao ) != 9
      lOk := .F.
   ELSE
      IF CalculaDigito( Substr( cInscricao, 1, 8 ), "11" ) != Substr( cInscricao, 9, 1 )
         lOk := .F.
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 999.999.99-9" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_GO( cInscricao )

   LOCAL lOk, nSoma

   IF Len( cInscricao ) != 9
      lOk := .F.
   ELSE
      nSoma := SomaModulo11( Substr( cInscricao, 1, 8 ) )
      nSoma := Mod( nSoma, 11 )
      IF Substr( cInscricao, 1, 8 ) == "11094402"
         lOk := Substr( cInscricao, 9, 1 ) $ "01"
      ELSE
         IF nSoma == 0
            lOk := Substr( cInscricao, 9, 1 ) == "0"
         ELSEIF nSoma == 1
            IF Substr( cInscricao, 1, 8 ) >= "10103105" .AND. Substr( cInscricao, 1, 8 ) <= "10119997"
               lOk := Substr( cInscricao, 9, 1 ) == "1"
            ELSE
               lOk := Substr( cInscricao, 9, 1 ) == "0"
            ENDIF
         ELSE
            nSoma := 11 - nSoma
            lOk := Substr( cInscricao, 9, 1 ) == Str( nSoma, 1 )
         ENDIF
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 99.999.999-9" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_MA( cInscricao )

   LOCAL lOk := .T., nSoma

   IF Len( cInscricao ) != 9
      lOk := .F.
   ELSEIF Left( cInscricao, 2 ) != "12"
      lOk := .F.
   ELSE
      nSoma := SomaModulo11( Substr( cInscricao, 1, 8 ) )
      nSoma := 11 - Mod( nSoma, 11 )
      IF nSoma > 9
         nSoma := 0
      ENDIF
      IF nSoma != Val( Substr( cInscricao, 9, 1 ) )
         lOk := .F.
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 999999999" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_MG( cInscricao )

   LOCAL lOk := .T., nSoma, cNumero, nMultip, cChecar, nCont

   IF Len( cInscricao ) != 13
      lOk := .F.
   ELSE
      cNumero := ""
      nMultip := 1
      cChecar := Substr( cInscricao, 1, 3 ) + "0" + Substr( cInscricao, 4, 8 )
      FOR nCont = 1 to Len(cChecar)
         cNumero := cNumero + LTrim( Str( Val( Substr( cChecar, nCont, 1 ) ) * nMultip ) )
         nMultip := iif( nMultip == 1, 2, 1 )
      NEXT
      nSoma := 0
      FOR nCont = 1 to Len( cNumero )
         nSoma += Val( Substr( cNumero, nCont, 1 ) )
      NEXT
      nSoma := Mod( nSoma, 10 )
      IF nSoma != 0
         nSoma := 10 - nSoma
      ENDIF
      IF nSoma != Val( Substr( cInscricao, 12, 1 ) )
         lOk := .F.
      ELSE
         nSoma := 0
         nMultip := 2
         FOR nCont = 12 to 1 step -1
            nSoma += ( nMultip * Val( Substr( cInscricao, nCont, 1 ) ) )
            nMultip += 1
            nMultip := iif( nMultip == 12, 2, nMultip )
         NEXT
         nSoma := 11 - Mod( nSoma, 11 )
         nSoma := iif( nSoma > 9, 0, nSoma )
         IF nSoma != Val( Substr( cInscricao, 13, 1 ) )
            lOk := .F.
         ENDIF
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 999.999.999/9999" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_MS( cInscricao )

   LOCAL lOk := .T.

   IF Len( cInscricao ) != 9
      lOk := .F.
   ELSEIF Left( cInscricao, 2 ) != "28"
      lOk := .F.
   ELSE
      IF CalculaDigito( Substr( cInscricao, 1, 8 ), "11" ) != Substr( cInscricao, 9, 1 )
         lOk := .F.
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 99.999.999-9" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_MT( cInscricao )

   LOCAL lOk := .T.

   IF Len( cInscricao ) > 11
      lOk := .F.
   ELSE
      cInscricao := StrZero( Val( cInscricao ), 11 )
      IF CalculaDigito( Substr( cInscricao, 1, 10 ), "11" ) != Substr( cInscricao, 11, 1 )
         lOk := .F.
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 9999999999-9" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_PA( cInscricao )

   LOCAL lOk := .T.

   IF Len( cInscricao ) != 9
      lOk := .F.
   ELSEIF Left( cInscricao, 2 ) != "15"
      lOk := .F.
   ELSE
      IF CalculaDigito( Substr( cInscricao, 1, 8 ), "11" ) != Substr( cInscricao, 9, 1 )
         lOk := .F.
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 99-999999-9" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_PB( cInscricao )

   LOCAL lOk := .T.

   IF Len( cInscricao ) != 9
      lOk := .F.
   ELSE
      IF CalculaDigito( Substr( cInscricao, 1, 8 ), "11" ) != Substr( cInscricao, 9, 1 )
         lOk := .F.
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 99999999-9" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_PE( cInscricao )

   LOCAL lOk := .T.

   IF Len( cInscricao ) != 9
      lOk := .F.
   ELSE
      IF CalculaDigito( Substr( cInscricao, 1, 7 ), "11" ) != Substr( cInscricao, 8, 1 )
         lOk := .F.
      ELSE
         IF CalculaDigito( Substr( cInscricao, 1, 8 ), "11" ) != Substr( cInscricao, 9, 1 )
            lOk := .F.
         ENDIF
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 9999999-99" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_PI( cInscricao )

   LOCAL lOk := .T.

   IF Len( cInscricao ) != 9
      lOk := .F.
   ELSE
      IF CalculaDigito( Substr( cInscricao, 1, 8 ), "11" ) != Substr( cInscricao, 9, 1 )
         lOk := .F.
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 99.999.999-9" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_PR( cInscricao )

   LOCAL lOk := .T., nSoma

   IF Len( cInscricao ) != 10
      lOk := .F.
   ELSE
      // Peso 2 a 7 e nao 2 a 9 como nas demais
      nSoma := SomaModulo11( Substr( cInscricao, 1, 2 ) ) + SomaModulo11( Substr( cInscricao, 3, 6 ) )
      nSoma := 11 - Mod( nSoma, 11 )
      IF nSoma > 9
         nSoma := 0
      ENDIF
      IF nSoma != Val( Substr( cInscricao, 9, 1 ) )
         lOk := .F.
      ELSE
         nSoma := SomaModulo11( Substr( cInscricao, 1, 3 ) ) + SomaModulo11( Substr( cInscricao, 4, 6 ) )
         nSoma := 11 - Mod( nSoma, 11 )
         IF nSoma > 9
            nSoma := 0
         ENDIF
         IF nSoma != Val( Substr( cInscricao, 10, 1 ) )
            lOk := .F.
         ENDIF
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 999.99999-99" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_RJ( cInscricao )

   LOCAL lOk := .T., nSoma

   IF Len( cInscricao ) != 8
      lOk := .F.
   ELSE
      // Peso 2 a 7, diferente dos demais
      nSoma := SomaModulo11( Substr( cInscricao, 1, 1 ) ) + SomaModulo11( Substr( cInscricao, 2, 6 ) )
      nSoma := 11 - Mod( nSoma, 11 )
      IF nSoma > 9
         nSoma := 0
      ENDIF
      IF nSoma != Val( Substr( cInscricao, 8, 1 ) )
         lOk := .F.
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 99.999.99-9" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_RN( cInscricao )

   LOCAL lOk := .T.

   IF Len( cInscricao ) != 9
      lOk := .F.
   ELSE
      IF CalculaDigito( Substr( cInscricao, 1, 8 ), "11" ) != Substr( cInscricao, 9, 1 )
         lOk := .F.
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 99.999.999-9" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_RO( cInscricao )

   LOCAL lOk := .T., nSoma

   IF Len( cInscricao ) != 14 .AND. Len( cInscricao ) != 9
      lOk := .F.
   ELSEIF Len( cInscricao ) == 9 // ate 07/2000
      nSoma := SomaModulo11( Substr( cInscricao, 1, 8 ) )
      nSoma := 11 - Mod( nSoma, 11 )
      nSoma := iif( nSoma > 9, nSoma - 10, nSoma )
      IF nSoma != Val( Substr( cInscricao, 9, 1 ) )
         lOk := .F.
      ENDIF
   ELSE // apos 07/2000
      nSoma := SomaModulo11( Substr( cInscricao, 1, 13 ) )
      nSoma := 11 - Mod( nSoma, 11 )
      nSoma := iif( nSoma > 9, nSoma - 10, nSoma )
      IF nSoma != Val( Substr( cInscricao, 14, 1 ) )
         lOk := .F.
      ENDIF
   ENDIF
   // Sem formatação de IE

   RETURN lOk

STATIC FUNCTION ValidIE_RR( cInscricao )

   LOCAL lOk := .T., nSoma, nCont

   IF Len( cInscricao ) != 9
      lOk := .F.
   ELSEIF Substr( cInscricao, 1, 2 ) != "24"
      lOk := .F.
   ELSE
      nSoma := 0
      FOR nCont = 1 to 8
         nSoma := nSoma + ( ( Val( Substr( cInscricao, nCont, 1 ) ) ) * nCont)
      NEXT
      nSoma := Mod( nSoma, 9 )
      IF nSoma != Val( Substr( cInscricao, 9, 1 ) )
         lOk := .F.
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 99.999.999-9" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_RS( cInscricao )

   LOCAL lOk := .T.

   IF Len( cInscricao ) != 10
      lOk := .F.
   ELSEIF Val( Substr(cInscricao, 1, 3 ) ) < 1
      lOk := .F.
   ELSE
      IF CalculaDigito( Substr( cInscricao, 1, 9 ), "11" ) != Substr( cInscricao, 10, 1 )
         lOk := .F.
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 999/9999999" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_SC( cInscricao )

   LOCAL lOk := .T.

   IF Len(cInscricao) != 9
      lOk := .F.
   ELSE
      IF CalculaDigito( Substr( cInscricao, 1, 8 ), "11" ) != Substr( cInscricao, 9, 1 )
         lOk := .F.
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 999.999.999" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_SE( cInscricao )

   LOCAL lOk := .T.

   IF Len( cInscricao ) != 9
      lOk := .F.
   ELSE
      IF CalculaDigito( Substr( cInscricao, 1, 8 ), "11" ) != Substr( cInscricao, 9, 1 )
         lOk := .F.
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 99.999.999-9" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_SP( cInscricao )

   LOCAL lOk := .T., nSoma

   IF Len( cInscricao ) != 12 .AND. Len( cInscricao ) != 13
      lOk := .F.
   ELSEIF Len( cInscricao ) == 13 // produtor rural
      IF Substr( cInscricao, 1, 1 ) != "P"
         lOk := .F.
      ELSE
         nSoma := ( Val( Substr( cInscricao, 2, 1 ) ) * 1 ) + ;
            ( Val( Substr( cInscricao, 3, 1 ) ) * 3 ) + ;
            ( Val( Substr( cInscricao, 4, 1 ) ) * 4 ) + ;
            ( Val( Substr( cInscricao, 5, 1 ) ) * 5 ) + ;
            ( Val( Substr( cInscricao, 6, 1 ) ) * 6 ) + ;
            ( Val( Substr( cInscricao, 7, 1 ) ) * 7 ) + ;
            ( Val( Substr( cInscricao, 8, 1 ) ) * 8 ) + ;
            ( Val( Substr( cInscricao, 9, 1 ) ) * 10 )
         nSoma := Mod( nSoma, 11 )
         nSoma := iif( nSoma > 9, nSoma - 10, nSoma )
         IF nSoma != Val( Substr( cInscricao, 10, 1 ) ) // Corrigido 22/04
            lOk := .F.
         ENDIF
      ENDIF
   ELSE // menos produtor rural
      nSoma := ( Val( Substr( cInscricao, 1, 1 ) ) * 1 ) + ;
         ( Val( Substr( cInscricao, 2, 1 ) ) * 3 ) + ;
         ( Val( Substr( cInscricao, 3, 1 ) ) * 4 ) + ;
         ( Val( Substr( cInscricao, 4, 1 ) ) * 5 ) + ;
         ( Val( Substr( cInscricao, 5, 1 ) ) * 6 ) + ;
         ( Val( Substr( cInscricao, 6, 1 ) ) * 7 ) + ;
         ( Val( Substr( cInscricao, 7, 1 ) ) * 8 ) + ;
         ( Val( Substr( cInscricao, 8, 1 ) ) * 10 )
      nSoma := Mod( nSoma, 11 )
      IF nSoma > 9
         nSoma := nSoma - 10
      ENDIF
      IF nSoma != Val( Substr( cInscricao, 9, 1 ) )
         lOk := .F.
      ELSE
         nSoma := SomaModulo11( Substr( cInscricao, 1, 2 ) ) + ;
            ( Val( Substr( cInscricao, 3, 1 ) ) * 10 ) + ;
            SomaModulo11( Substr( cInscricao, 4, 8 ) )
         nSoma := Mod( nSoma, 11 )
         IF nSoma > 9
            nSoma := nSoma - 10 // No manual nao fala sobre isto
         ENDIF
         IF nSoma != Val( Substr( cInscricao, 12, 1 ) )
            lOk := .F.
         ENDIF
      ENDIF
      IF ! lOk // Pode ser produtor rural, apesar de nao iniciar com P
         IF Val( Substr( cInscricao, 1, 1 ) ) != 0
            lOk := .F.
         ELSE
            nSoma := Val( Substr( cInscricao, 1, 1 ) ) + ;
               Val( Substr( cInscricao, 2, 1 ) ) * 3 + ;
               Val( Substr( cInscricao, 3, 1 ) ) * 4 + ;
               Val( Substr( cInscricao, 4, 1 ) ) * 5 + ;
               Val( Substr( cInscricao, 5, 1 ) ) * 6 + ;
               Val( Substr( cInscricao, 6, 1 ) ) * 6 + ;
               Val( Substr( cInscricao, 7, 1 ) ) * 7 + ;
               Val( Substr( cInscricao, 8, 1 ) ) * 8 + ;
               Val( Substr( cInscricao, 9, 1 ) ) * 10
            nSoma := nSoma - Mod( nSoma, 11 )
            IF nSoma > 9
               nSoma -= 10
            ENDIF
            IF nSoma != Val( Substr( cInscricao, 10, 1 ) )
               lOk := .F.
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   IF lOk
      cInscricao := Transform( cInscricao, "@R 999.999.999.999" )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidIE_TO( cInscricao )

   LOCAL lOk := .T.

   IF Len( cInscricao ) != 11 .AND. Len( cInscricao ) != 9
      lOk := .F.
   ELSEIF Substr( cInscricao, 1, 2 ) <> "29"
      lOk := .F.
   ELSEIF Len( cInscricao ) == 11 .AND. ! Substr( cInscricao, 3, 2 ) $ "01,02,03,99"
      lOk := .F.
   ELSE
      IF CalculaDigito( Substr( cInscricao, 1, 2 ) + Substr( cInscricao, Len( cInscricao ) - 6, 6 ), "11" ) != Right( cInscricao, 1 )
         lOk := .F.
      ENDIF
      IF Len( cInscricao ) == 11
         cInscricao := Transform( cInscricao, "@R 99.99.999999-9" )
      ELSE
         cInscricao := Transform( cInscricao, "@R 99.999.999-9" )
      ENDIF
   ENDIF

   RETURN lOk

STATIC FUNCTION SomaModulo11( cNumero )

   LOCAL nSoma := 0, nMultip := 2, nCont

   FOR nCont = 1 to Len( cNumero )
      nSoma += ( Val( Substr( cNumero, Len( cNumero ) - nCont + 1, 1 ) ) * nMultip )
      nMultip := iif( nMultip == 9, 2, nMultip + 1 )
   NEXT

   RETURN nSoma
