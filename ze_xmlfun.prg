/*
ze_xmlfun - Funções pra trabalhar com XML
2012.02.11 - José Quintas

...
2016.07.20.1620 - Fuso horário correto SP
2016.08.12.1740 - Parâmetro ref UTC (da forma anterior confunde)
*/

FUNCTION XmlNode( cXml, cNode, lComTag )

   LOCAL mInicio, mFim, cResultado := ""

   hb_Default( @lComTag, .F. )
   IF " " $ cNode
      cNode := Substr( cNode, 1, At( " ", cNode ) - 1 )
   ENDIF
   mInicio := At( "<" + cNode, cXml )
   IF mInicio != 0
      IF .NOT. lComTag
         mInicio := mInicio + Len( cNode ) + 2
         IF mInicio != 1 .AND. Substr( cXml, mInicio - 1, 1 ) != ">" // Quando tem elementos no bloco
            mInicio := hb_At( ">", cXml, mInicio ) + 1
         ENDIF
      ENDIF
   ENDIF
   IF mInicio != 0
      mFim = hb_At( "</" + cNode + ">", cXml, mInicio )
      IF mFim != 0
         mFim -=1
         IF lComTag
            mFim := mFim + Len( cNode ) + 3
         ENDIF
      ENDIF
      IF mFim <> 0
         cResultado := Substr( cXml, mInicio, mFim - mInicio + 1 )
      ENDIF
   ENDIF

   RETURN cResultado

FUNCTION XmlElement( cXml, cElement )

   LOCAL mInicio, mFim, cResultado := ""

   mInicio := At( cElement + "=", cXml )
   IF mInicio != 0
      mInicio += 1
      mInicio := hb_At( "=", cXml, mInicio ) + 2
   ENDIF
   mFim    := hb_At( ["], cXml, mInicio ) - 1
   IF mInicio > 0 .AND. mFim > 0 .AND. mFim > mInicio
      cResultado = Substr( cXml, mInicio, mFim - mInicio + 1 )
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

FUNCTION UTF8( cTexto )

   cTexto := StrTran( cTexto, "&", "&amp;" ) // (<) &lt; (>) &gt; (&) &amp; (") &quot; (') &apos;

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
   CASE .NOT. lUTC ; cText += "" // no UTC
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

FUNCTION MsgExclamation( cText )

   wapi_MessageBox( wapi_GetActiveWindow(), cText, "Atenção", WIN_MB_ICONASTERISK )

   RETURN NIL

// só pra não aparecer erro

FUNCTION SayScroll( ... )

   RETURN NIL
