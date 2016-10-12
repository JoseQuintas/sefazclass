/*
ze_xmlfun - Funções pra trabalhar com XML
2012.02.11 - José Quintas

...
2016.07.20.1620 - Fuso horário correto SP
2016.08.12.1740 - Parâmetro ref UTC (da forma anterior confunde)
2016
*/

#define DOW_DOMINGO   1

FUNCTION XmlTransform( cXml )

   LOCAL nCont, cRemoveTag, lUtf8

   cRemoveTag := { ;
      [<?xml version="1.0" encoding="utf-8"?>], ; // Petrobras inventou de usar assim
      [<?xml version="1.0" encoding="UTF-8"?>] }  // Alguns usam assim

   FOR nCont = 1 TO Len( cRemoveTag )
      cXml := StrTran( cXml, cRemoveTag[ nCont ], "" )
   NEXT
   IF ! ["] $ cXml // Petrobras usa aspas simples
      cXml := StrTran( cXml, ['], ["] )
   ENDIF

   lUtf8 := .F.
   IF Substr( cXml, 1, 1 ) $ Chr(239) + Chr(187) + Chr(191)
      lUtf8 := .T.
   ENDIF
   FOR nCont = 128 TO 159
      IF Chr( nCont ) $ cXml
         lUtf8 := .T.
      ENDIF
   NEXT
   IF lUtf8
      cXml := hb_Utf8ToStr( cXml )
   ENDIF
   FOR nCont = 1 TO 2
      cXml := StrTran( cXml, Chr(26), "" )
      cXml := StrTran( cXml, Chr(13), "" )
      cXml := StrTran( cXml, Chr(10), "" )
      IF Substr( cXml, 1, 1 ) $ Chr(239) + Chr(187) + Chr(191)
         cXml := Substr( cXml, 2 )
      ENDIF
      cXml := StrTran( cXml, " />", "/>" ) // Diferenca entre versoes do emissor
      cXml := StrTran( cXml, Chr(195) + Chr(173), "i" ) // i acentuado minusculo
      cXml := StrTran( cXml, Chr(195) + Chr(135), "C" ) // c cedilha maiusculo
      cXml := StrTran( cXml, Chr(195) + Chr(141), "I" ) // i acentuado maiusculo
      cXml := StrTran( cXml, Chr(195) + Chr(163), "a" ) // a acentuado minusculo
      cXml := StrTran( cXml, Chr(195) + Chr(167), "c" ) // c acentuado minusculo
      cXml := StrTran( cXml, Chr(195) + Chr(161), "a" ) // a acentuado minusculo
      cXml := StrTran( cXml, Chr(195) + Chr(131), "A" ) // a acentuado maiusculo
      cXml := StrTran( cXml, Chr(194) + Chr(186), "o." ) // numero simbolo
      // so pra corrigir no MySql
      cXml := StrTran( cXml, "+" + Chr(129), "A" )
      cXml := StrTran( cXml, "+" + Chr(137), "E" )
      cXml := StrTran( cXml, "+" + Chr(131), "A" )
      cXml := StrTran( cXml, "+" + Chr(135), "C" )
      cXml := StrTran( cXml, "?" + Chr(167), "c" )
      cXml := StrTran( cXml, "?" + Chr(163), "a" )
      cXml := StrTran( cXml, "?" + Chr(173), "i" )
      cXml := StrTran( cXml, "?" + Chr(131), "A" )
      cXml := StrTran( cXml, "?" + Chr(161), "a" )
      cXml := StrTran( cXml, "?" + Chr(141), "I" )
      cXml := StrTran( cXml, "?" + Chr(135), "C" )
      cXml := StrTran( cXml, Chr(195) + Chr(156), "a" )
      cXml := StrTran( cXml, Chr(195) + Chr(159), "A" )
      cXml := StrTran( cXml, "?" + Chr(129), "A" )
      cXml := StrTran( cXml, "?" + Chr(137), "E" )
      cXml := StrTran( cXml, Chr(195) + "?", "C" )
      cXml := StrTran( cXml, "?" + Chr(149), "O" )
      cXml := StrTran( cXml, "?" + Chr(154), "U" )
      cXml := StrTran( cXml, "+" + Chr(170), "o" )
      cXml := StrTran( cXml, "?" + Chr(128), "A" )
      cXml := StrTran( cXml, Chr(195) + Chr(166), "e" )
      cXml := StrTran( cXml, Chr(135) + Chr(227), "ca" )
      cXml := StrTran( cXml, "n" + Chr(227), "na" )
      cXml := StrTran( cXml, Chr(162), "o" )
   NEXT

   RETURN cXml

FUNCTION XmlNode( cXml, cNode, lComTag )

   LOCAL nInicio, nFim, cResultado := ""

   hb_Default( @lComTag, .F. )
   nInicio := At( "<" + cNode, cXml )
   // a linha abaixo é depois de pegar o início, senão falha
   IF " " $ cNode
      cNode := Substr( cNode, 1, At( " ", cNode ) - 1 )
   ENDIF
   IF nInicio != 0
      IF ! lComTag
         nInicio := nInicio + Len( cNode ) + 2
         IF nInicio != 1 .AND. Substr( cXml, nInicio - 1, 1 ) != ">" // Quando tem elementos no bloco
            nInicio := hb_At( ">", cXml, nInicio ) + 1
         ENDIF
      ENDIF
      nFim = hb_At( "</" + cNode + ">", cXml, nInicio )
      IF nFim != 0
         nFim -=1
         IF lComTag
            nFim := nFim + Len( cNode ) + 3
         ENDIF
         cResultado := Substr( cXml, nInicio, nFim - nInicio + 1 )
      ENDIF
   ENDIF

   RETURN cResultado

FUNCTION XmlElement( cXml, cElement )

   LOCAL nInicio, nFim, cResultado := ""

   nInicio := At( cElement + "=", cXml )
   IF nInicio != 0
      nInicio += 1
      nInicio := hb_At( "=", cXml, nInicio ) + 2
   ENDIF
   nFim    := hb_At( ["], cXml, nInicio ) - 1
   IF nInicio > 0 .AND. nFim > 0 .AND. nFim > nInicio
      cResultado = Substr( cXml, nInicio, nFim - nInicio + 1 )
   ENDIF

   RETURN cResultado

FUNCTION XmlDate( cData )

   LOCAL dDate

   dDate := Ctod( Substr( cData, 9, 2 ) + "/" + Substr( cData, 6, 2 ) + "/" + Substr( cData, 1, 4 ) )

   RETURN dDate

FUNCTION XmlTag( cTag, cConteudo )

   LOCAL cTexto := ""

   hb_Default( @cConteudo, "" )
   cConteudo := AllTrim( cConteudo )
   IF Len( Trim( cConteudo ) ) = 0
      cTexto := [<]+ cTag + [/>]
   ELSE
      cConteudo := AllTrim( cConteudo )
      IF Len( cConteudo ) == 0
         cConteudo := " "
      ENDIF
      cTexto := cTexto + [<] + cTag + [>] + cConteudo + [</] + cTag + [>]
   ENDIF

   RETURN cTexto

FUNCTION DateXml( dDate )

   RETURN Transform( Dtos( dDate ), "@R 9999-99-99" )

FUNCTION NumberXml( nValue, nDecimals )

   hb_Default( @nDecimals, 0 )

   RETURN Ltrim( Str( nValue, 16, nDecimals ) )

FUNCTION DateTimeXml( dDate, cTime, cUF, lUTC )

   LOCAL cText, lHorarioVerao

   hb_Default( @dDate, Date() )
   hb_Default( @cTime, Time() )
   hb_Default( @cUF, "SP" )
   hb_Default( @lUTC, .T. )

   lHorarioVerao := ( dDate >= HorarioVeraoInicio( Year( dDate ) ) .AND. dDate <= HorarioVeraoTermino( Year( dDate - 1 ) ) )
   cText := Transform( Dtos( dDate ), "@R 9999-99-99" ) + "T" + cTime
   DO CASE
   CASE ! lUTC ; cText += "" // no UTC
   CASE cUF $ "AC"                                             ; cText += "-05:00"
   CASE cUF $ "MT,MS" .AND. lHorarioVerao                      ; cText += "-05:00"
   CASE cUF $ "DF,ES,GO,MG,PR,RJ,RS,SC,SP" .AND. lHorarioVerao ; cText += "-04:00"
   CASE cUF $ "AM,MT,MS,RO,RR"                                 ; cText += "-04:00"
   OTHERWISE                                                   ; cText += "-03:00"
   ENDCASE

   RETURN cText

FUNCTION DomingoDePascoa( iAno )

   LOCAL iA, iB, iC, iD, iE, iF, iG, iH, iI, iK, iL, iM, iMes, iDia

   iA := iAno % 19
   iB := Int( iAno / 100 )
   iC := iAno % 100
   iD := Int( iB / 4 )
   iE := iB % 4
   iF := Int( ( iB + 8 ) / 25 )
   iG := Int( ( iB - iF + 1 ) / 3 )
   iH := ( 19 * iA + iB - iD - iG + 15 ) % 30
   iI := Int( iC / 4 )
   iK := iC % 4
   iL := ( 32 + 2 * iE + 2 * iI - iH - iK ) % 7
   iM := Int( ( iA + 11 * iH + 22 * iL) / 451 )
   iMes := Int( ( iH + iL - 7 * iM + 114 ) / 31 )
   iDia := ( ( iH + iL - 7 * iM + 114 ) % 31 ) + 1

   RETURN Stod( StrZero( iAno, 4 ) + StrZero( iMes, 2 ) + StrZero( iDia, 2 ) )

FUNCTION TercaDeCarnaval( iAno )

   RETURN DomingoDePascoa( iAno ) - 47

FUNCTION HorarioVeraoInicio( iAno )

   LOCAL dPrimeiroDeOutubro, dPrimeiroDomingoDeOutubro, dTerceiroDomingoDeOutubro

   dPrimeiroDeOutubro := Stod( StrZero( iAno, 4 ) + "1001" )
   dPrimeiroDomingoDeOutubro := dPrimeiroDeOutubro + iif( Dow( dPrimeiroDeOutubro ) == DOW_DOMINGO, 0, ( 7 - Dow( dPrimeiroDeOutubro ) + 1 ) )
   dTerceiroDomingoDeOutubro := dPrimeiroDomingoDeOutubro + 14

   RETURN dTerceiroDomingoDeOutubro

FUNCTION HorarioVeraoTermino( iAno )

   LOCAL dPrimeiroDeFevereiro, dPrimeiroDomingoDeFevereiro, dTerceiroDomingoDeFevereiro

   dPrimeiroDeFevereiro := Stod( StrZero( iAno + 1, 4 ) + "0201" )
   dPrimeiroDomingoDeFevereiro := dPrimeiroDeFevereiro + iif( Dow( dPrimeiroDeFevereiro ) == DOW_DOMINGO, 0, ( 7 - Dow( dPrimeiroDeFevereiro ) + 1 ) )
   dTerceiroDomingoDeFevereiro := dPrimeiroDomingoDeFevereiro + 14
   IF dTerceiroDomingoDeFevereiro == TercaDeCarnaval( iAno + 1 ) - 2 /* nao pode ser domingo de carnaval */
      dTerceiroDomingoDeFevereiro += 7
   ENDIF

   RETURN dTerceiroDomingoDeFevereiro

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

FUNCTION XmlToString( cTexto )

   cTexto := Strtran( cTexto, "&amp;", "&" )
   cTexto := StrTran( cTexto, "&quot;", ["] )
   cTexto := StrTran( cTexto, "&#39;", "'" )
   cTexto := StrTran( cTexto, "&lt;", "<" )
   cTexto := StrTran( cTexto, "&gt;", ">" )
   cTexto := StrTran( cTexto, "&#176;", "º" )
   cTexto := StrTran( cTexto, "&#170;", "ª" )

   RETURN cTexto

FUNCTION StringToXml( cTexto )

   cTexto := StrTran( cTexto, "&", "&amp;" )
   cTexto := StrTran( cTexto, ["], "&quot;" )
   cTexto := StrTran( cTexto, "'", "&#39;" )
   cTexto := StrTran( cTexto, "<", "&lt;" )
   cTexto := StrTran( cTexto, ">", "&gt;" )
   cTexto := StrTran( cTexto, "º", "&#176;" )
   cTexto := StrTran( cTexto, "ª", "&#170;" )

   RETURN cTexto


FUNCTION XmlToHash( cXml, aTagList, oVar )

   LOCAL oElement

   oVar := iif( oVar == NIL, hb_Hash(), oVar )

   FOR EACH oElement IN aTagList
      oVar[ oElement ] := XmlNode( cXml, oElement )
   NEXT

   RETURN oVar

FUNCTION MultipleNodeToArray(cXml,cNode) // runner
	LOCAL aNodes :={}
	DO WHILE '<'+cNode $ cXml
	   Aadd( aNodes , XmlNode(cXml , cNode) )
	   cXml := Subs(cXml,At('<'+cNode+'>',cXml)+Len('<'+cNode+'>'))
	ENDDO
	RETURN aNodes