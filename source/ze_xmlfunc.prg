/*
ZE_XMLFUNC - Funções pra trabalhar com XML
José Quintas

2018.10.16 - Horário de verão diferente em 2018
*/

#ifndef DOW_DOMINGO
#define DOW_DOMINGO 1
#endif

FUNCTION XmlTransform( cXml )

   LOCAL nCont, cRemoveTag, lUtf8, cLetra

   cRemoveTag := { ;
      [<?xml version="1.0" encoding="utf-8"?>], ; // Petrobras inventou de usar assim
      [<?xml version="1.0" encoding="ISO-8859-1"?>], ; // Petrobras agora assim
      [<?xml version="1.0" encoding="UTF-8"?>], ; // o mais correto
      [<?xml version="1.00"?>], ;
      [<?xml version="1.0"?>] }

   FOR nCont = 1 TO Len( cRemoveTag )
      cXml := StrTran( cXml, cRemoveTag[ nCont ], "" )
   NEXT
   IF ! ["] $ cXml // Pode ser usado aspas simples
      cXml := StrTran( cXml, ['], ["] )
   ENDIF

   lUtf8 := .F.
   IF Chr(195) $ cXml
      lUtf8 := .T.
   ENDIF
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
      cXml := StrTran( cXml, " />", "/>" )
      cXml := StrTran( cXml, Chr(195) + Chr(173), "i" )
      cXml := StrTran( cXml, Chr(195) + Chr(135), "C" )
      cXml := StrTran( cXml, Chr(195) + Chr(141), "I" )
      cXml := StrTran( cXml, Chr(195) + Chr(163), "a" )
      cXml := StrTran( cXml, Chr(195) + Chr(167), "c" )
      cXml := StrTran( cXml, Chr(195) + Chr(161), "a" )
      cXml := StrTran( cXml, Chr(195) + Chr(131), "A" )
      cXml := StrTran( cXml, Chr(194) + Chr(186), "o." )
      cxml := StrTran( cxml, Chr(195) + Chr(162), "a" )
      cxml := StrTran( cxml, Chr(195) + Chr(161), "a" )
      cxml := StrTran( cxml, Chr(195) + Chr(163), "a" )
      cxml := StrTran( cxml, Chr(195) + Chr(173), "i" )
      cxml := StrTran( cxml, Chr(195) + Chr(179), "o" )
      cxml := StrTran( cxml, Chr(195) + Chr(167), "c" )
      cxml := StrTran( cxml, Chr(195) + Chr(169), "e" )
      cxml := StrTran( cxml, Chr(195) + Chr(170), "e" )
      cxml := StrTran( cxml, Chr(195) + Chr(181), "o" )
      cxml := StrTran( cxml, Chr(195) + Chr(160), "o" )
      cxml := StrTran( cxml, Chr(195) + Chr(181), "o" )
      cxml := StrTran( cxml, Chr(195) + Chr(129), "A" )
      cxml := StrTran( cxml, Chr(226) + Chr(128) + Chr(156), [*] ) // aspas de destaque "cames"
      cxml := StrTran( cxml, Chr(226) + Chr(128) + Chr(157), [*] ) // aspas de destaque "cames"
      cxml := StrTran( cxml, Chr(195) + Chr(180), "o" )
      cxml := StrTran( cxml, Chr(195) + Chr(186), "u" )
      cxml := StrTran( cxml, Chr(195) + Chr(147), "O" )
      cxml := StrTran( cxml, Chr(226) + Chr(128) + Chr(153), [ ] ) // caixa d'agua
      cxml := StrTran( cxml, Chr(226) + Chr(128) + Chr(147), [-] ) // - mesmo
      cxml := StrTran( cxml, Chr(194) + Chr(179), [3] ) // m3
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
      cXml := StrTran( cXml, " " + Chr(241) + " ", " " )
   NEXT
   FOR nCont = 1 TO Len( cXml )
      cLetra := Substr( cXml, nCont, 1 )
      DO CASE
      CASE cLetra $ "abcdefghijklmnopqrstuvwxyz"
      CASE cLetra $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      CASE cLetra $ "01234567889"
      CASE cLetra $ ",.:/;%*$@?<>()+-#=:_" + Chr(34) + Chr(32)
      CASE cLetra $ "çÇ" ; cLetra := "c"
      CASE cLetra $ "ÁÃÂ" ; cLetra := "A"
      CASE cLetra $ "áãâ" ; cLetra := "a"
      CASE cLetra $ "óõô" ; cLetra := "o"
      CASE cLetra $ "ÓÕÔ" ; cLetra := "O"
      CASE cLetra $ "ÉÊ"  ; cLetra := "E"
      CASE cLetra $ "eêé" ; cLetra := "e"
      CASE cLetra $ "í"   ; cLetra := "i"
      CASE cLetra $ "Í"   ; cLetra := "I"
      CASE cLetra $ "ú"   ; cLetra := "u"
      CASE cLetra $ "Ú"   ; cLetra := "U"
      ENDCASE
      cXml := Substr( cXml, 1, nCont - 1 ) + cLetra + Substr( cXml, nCont + 1 )
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
      nFim := hb_At( "</" + cNode + ">", cXml, nInicio )
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
      cResultado := Substr( cXml, nInicio, nFim - nInicio + 1 )
   ENDIF

   RETURN cResultado

FUNCTION XmlDate( cData )

   LOCAL dDate

   dDate := Stod( Substr( cData, 1, 4 ) + Substr( cData, 6, 2 ) + Substr( cData, 9, 2 ) )

   RETURN dDate

FUNCTION XmlTag( cTag, cValue )

   LOCAL cXml

   hb_Default( @cValue, "" )
   cValue := AllTrim( cValue )
   IF Len( cValue ) == 0
      cXml := [<]+ cTag + [/>]
   ELSE
      IF Len( cValue ) == 0
         cValue := " "
      ENDIF
      cXml := [<] + cTag + [>] + cValue + [</] + cTag + [>]
   ENDIF

   RETURN cXml

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

   lHorarioVerao := ( dDate >= HorarioVeraoInicio( Year( dDate ) ) .OR. dDate <= HorarioVeraoTermino( Year( dDate ) - 1 ) )
   cText := Transform( Dtos( dDate ), "@R 9999-99-99" ) + "T" + cTime
   DO CASE
   CASE ! lUTC ; cText += "" // no UTC
   CASE cUF $ "AC"                                             ; cText += "-05:00"
   CASE cUF $ "MT,MS" .AND. lHorarioVerao                      ; cText += "-03:00"
   CASE cUF $ "DF,ES,GO,MG,PR,RJ,RS,SC,SP" .AND. lHorarioVerao ; cText += "-02:00"
   CASE cUF $ "AM,MT,MS,RO,RR"                                 ; cText += "-04:00"
   OTHERWISE                                                   ; cText += "-03:00" // demais casos
   ENDCASE

   RETURN cText

FUNCTION DomingoDePascoa( nAno )

   LOCAL nA, nB, nC, nD, nE, nF, nG, nH, nI, nK, nL, nM, nMes, nDia

   nA   := nAno % 19
   nB   := Int( nAno / 100 )
   nC   := nAno % 100
   nD   := Int( nB / 4 )
   nE   := nB % 4
   nF   := Int( ( nB + 8 ) / 25 )
   nG   := Int( ( nB - nF + 1 ) / 3 )
   nH   := ( 19 * nA + nB - nD - nG + 15 ) % 30
   nI   := Int( nC / 4 )
   nK   := nC % 4
   nL   := ( 32 + 2 * nE + 2 * nI - nH - nK ) % 7
   nM   := Int( ( nA + 11 * nH + 22 * nL ) / 451 )
   nMes := Int( ( nH + nL - 7 * nM + 114 ) / 31 )
   nDia := ( ( nH + nL - 7 * nM + 114 ) % 31 ) + 1

   RETURN Stod( StrZero( nAno, 4 ) + StrZero( nMes, 2 ) + StrZero( nDia, 2 ) )

FUNCTION TercaDeCarnaval( nAno )

   RETURN DomingoDePascoa( nAno ) - 47

FUNCTION HorarioVeraoInicio( nAno )

   LOCAL dPrimeiroDeOutubro, dPrimeiroDomingoDeOutubro, dTerceiroDomingoDeOutubro

   IF nAno == 2018
      dTerceiroDomingodeOutubro := Stod( "20181104" )
   ELSE
      dPrimeiroDeOutubro := Stod( StrZero( nAno, 4 ) + "1001" )
      dPrimeiroDomingoDeOutubro := dPrimeiroDeOutubro + iif( Dow( dPrimeiroDeOutubro ) == DOW_DOMINGO, 0, ( 7 - Dow( dPrimeiroDeOutubro ) + 1 ) )
      dTerceiroDomingoDeOutubro := dPrimeiroDomingoDeOutubro + 14
   ENDIF

   RETURN dTerceiroDomingoDeOutubro

FUNCTION HorarioVeraoTermino( nAno )

   LOCAL dPrimeiroDeFevereiro, dPrimeiroDomingoDeFevereiro, dTerceiroDomingoDeFevereiro

   dPrimeiroDeFevereiro := Stod( StrZero( nAno + 1, 4 ) + "0201" )
   dPrimeiroDomingoDeFevereiro := dPrimeiroDeFevereiro + iif( Dow( dPrimeiroDeFevereiro ) == DOW_DOMINGO, 0, ( 7 - Dow( dPrimeiroDeFevereiro ) + 1 ) )
   dTerceiroDomingoDeFevereiro := dPrimeiroDomingoDeFevereiro + 14
   IF dTerceiroDomingoDeFevereiro == TercaDeCarnaval( nAno + 1 ) - 2 /* nao pode ser domingo de carnaval */
      dTerceiroDomingoDeFevereiro += 7
   ENDIF

   RETURN dTerceiroDomingoDeFevereiro

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

   cTexto := AllTrim( cTexto )
   DO WHILE Space(2) $ cTexto
      cTexto := StrTran( cTexto, Space(2), Space(1) )
   ENDDO
   cTexto := StrTran( cTexto, "&", "E" ) // "&amp;" )
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

FUNCTION MultipleNodeToArray( cXml, cNode )

   LOCAL aNodes := {}

   DO WHILE "<" + cNode + " " $ cXml .OR. "<" + cNode + ">" $ cXml
      Aadd( aNodes , XmlNode( cXml , cNode ) )
      IF ! "</" + cNode $ cXml
         cXml := ""
      ELSE
         cXml := Substr( cXml, At( "</" + cNode + ">", cXml ) + Len( "</" + cNode + ">" ) )
      ENDIF
   ENDDO

   RETURN aNodes

FUNCTION TrimXml( cTexto )

   cTexto := AllTrim( cTexto )
   DO WHILE Space(2) $ cTexto
      cTexto := StrTran( cTexto, Space(2), Space(1) )
   ENDDO

   RETURN cTexto

/*
nItem := Mod( x, 19 ) + 1
aList := { "0414", "0403", "0323", "0411", "0331", "0418", "0408", ;
           "0328", "0416", "0405", "0325", "0413", "0402", "0322", ;
           "0410", "0330", "0417", "0407", "0327" }
d := Stod( StrZero( x, 4 ) + aList[ nItem ]
DO WHILE ! Dow( d ) == DOW_DOMINGO
   d += 1
ENDDO
*/
