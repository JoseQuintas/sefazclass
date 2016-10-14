FUNCTION SoNumeros( cTxt )

   LOCAL cSoNumeros := "", cChar

   FOR EACH cChar IN cTxt
      IF cChar $ "0123456789"
         cSoNumeros += cChar
      ENDIF
   NEXT

   RETURN cSoNumeros

STATIC FUNCTION ValidCnpj( cCnpj )

   LOCAL cNumero, lOk

   cNumero := SoNumeros( cCnpj )
   cNumero := Left( cNumero + Replicate( "0", 12 ), 12 )
   cNumero := cNumero + CalculaDigito( cNumero, "11" )
   cNumero := cNumero + CalculaDigito( cNumero, "11" )
   lOk     := ( SoNumeros( cNumero ) == SoNumeros( cCnpj ) )
   RETURN lOk

STATIC FUNCTION ValidCpf( cCpf )

   LOCAL cNumero, lOk

   cNumero := SoNumeros( cCpf )
   cNumero := Left( cNumero + Replicate( "0", 9 ), 9 )
   cNumero := cNumero + CalculaDigito( cNumero, "10" )
   cNumero := cNumero + CalculaDigito( cNumero, "10" )
   lOk     := ( SoNumeros( cCpf ) == SoNumeros( cNumero ) )

   RETURN lOk

FUNCTION ValidCnpjCpf( cCnpj )

   LOCAL lOk

   lOk := ( ValidCnpj( cCnpj ) .OR. ValidCpf( cCnpj ) )

   RETURN lOk

FUNCTION CalculaDigito( cNumero, cModulo )

   LOCAL nFator, nCont, nSoma, nResto, nModulo, cCalculo

   IF Empty( cNumero )
      RETURN ""
   ENDIF
   cCalculo := AllTrim( cNumero )
   IF cModulo $ "10,11"
      nModulo := Val( cModulo )
      nFator  := 2
      nSoma   := 0
      IF nModulo == 10
         FOR nCont = Len( cCalculo ) To 1 Step -1
            nSoma += Val( Substr( cCalculo, nCont, 1 ) ) * nFator
            nFator += 1
         NEXT
      ELSE
         FOR nCont = Len( cCalculo ) To 1 Step -1
            nSoma += Val( Substr( cCalculo, nCont, 1 ) ) * nFator
            IF nFator == 9
               nFator := 2
            ELSE
               nFator += 1
            ENDIF
         NEXT
      ENDIF
      nResto := nSoma - ( Int( nSoma / 11 ) * 11 )
      nResto := 11 - nResto
      IF nResto > 9
         nResto := 0
      ENDIF
      cCalculo := Str(nResto,1)
   ENDIF

   RETURN cCalculo

// só pra não aparecer erro

FUNCTION SayScroll( ... )

   RETURN NIL

FUNCTION FormatNumber( nValor, nTamanho, nDecimais )

   LOCAL cPicture

   hb_Default( @nDecimais, 2 )
   hb_Default( @nTamanho, 15 )

   IF ValType( nValor ) == "C" // será perigoso ??
      nValor := Val( nValor )
   ENDIF

   cPicture := Replicate( "9", nTamanho - iif( nDecimais == 0, 0, nDecimais + 1 ) )
   cPicture := Ltrim( Transform( Val( cPicture ), "999,999,999,999,999" ) )
   IF nDecimais != 0
      cPicture += "." + Replicate( "9", nDecimais )
   ENDIF

   RETURN Transform( nValor, "@E " + cPicture )


