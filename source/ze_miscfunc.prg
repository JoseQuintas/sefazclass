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

FUNCTION ze_Feriado( dDate, cUF )

   LOCAL lFeriado
   LOCAL aList := { ;
      { "BR", "0101" }, ; // Ano Novo
      { "BR", "0421" }, ; // Tiradentes
      { "BR", "0501" }, ; // Dia do Trabalho
      { "BR", "0907" }, ; // Independência
      { "BR", "1012" }, ; // N S Aparecida
      { "BR", "1102" }, ; // Finados
      { "BR", "1115" }, ; // Proclamação da República
      { "BR", "1225" }, ;  // Natal
      { "SP", "0125" }, ; // Fundação de SP
      { "SP", "0419" }, ; // Paixao de Cristo
      { "SP", "0620" }, ; // Corpus Christi
      { "SP", "0709" }, ; // Revolução Constitucionalista
      { "SP", "1120" } }  // Consciência Negra

   hb_Default( @cUF, "" )

   lFeriado := AScan( aList, { | e | e[ 1 ] == "BR" .OR. e[ 1 ] == cUF .AND. e[ 2 ] == Right( Dtos( dDate ), 4 ) } ) != 0
   IF ! lFeriado
      IF AScan( { 0, 1 }, dDate - TercaDeCarnaval( Year( dDate ) ) ) != 0
         lFeriado := .T.
      ENDIF
   ENDIF

   RETURN lFeriado
