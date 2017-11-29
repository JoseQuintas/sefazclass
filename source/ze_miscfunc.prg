/*
ZE_MISCFUNC - Miscelânea de funções
*/

FUNCTION SoNumeros( cTxt )

   LOCAL cSoNumeros := "", cChar

   FOR EACH cChar IN cTxt
      IF cChar $ "0123456789"
         cSoNumeros += cChar
      ENDIF
   NEXT

   RETURN cSoNumeros

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
