/*
* ze_xmlfun - Funções para trabalhar com XML
2012.02.11 - José Quintas

...
2016.07.20.1620 - Fuso horário correto SP
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

// Existem 5 caracteres de uso especial no XML:
// (<) &lt. (>) &gt. (&) &amp. (") &quot e (') &apos.
//

FUNCTION UTF8( cTexto )

   cTexto := StrTran( cTexto, "&", "&amp;" )

   RETURN cTexto

FUNCTION DateXml( dDate )

   RETURN Transform( Dtos( dDate ), "@R 9999-99-99" )

FUNCTION DateTimeXml( dDate, cTime, lUTC )

   // AC = -05:00
   // AM,MT,MS,RO,RR = -04:00
   // AL,AP,BA,CE,DF,ES,GO,MA,MG,RS,SC,PA,PB,PE,PR,PR,RJ,RN,RS,SE,SP,TO = -03:00
   hb_Default( @cTime, Time() )
   hb_Default( @lUTC, .T. )

   RETURN Transform( Dtos( dDate ), "@R 9999-99-99" ) + "T" + cTime + iif( lUTC, "-03:00", "" )

FUNCTION NumberXml( nValue, nDecimals )

   hb_Default( @nDecimals, 0 )

   RETURN Ltrim( Str( nValue, 16, nDecimals ) )

FUNCTION SoNumeros( cTxt )

   LOCAL cSoNumeros := "", cChar

   FOR EACH cChar IN cTxt
      IF cChar $ "0123456789"
         cSoNumeros += cChar
      ENDIF
   NEXT

   RETURN cSoNumeros
