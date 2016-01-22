*----------------------------------------------------------------
* ZE_XMLFUN - FUNCOES XML
* 2012.02.11 - José M. C. Quintas
*----------------------------------------------------------------

* ...
* 2015.01.07.0100 - Parâmetro opcional
* 2015.05.28.1420 - Assinatura FAKE
* 2015.08.07.1120 - Teste ref salvar corretamente no GIT
* 2016.01.21.2300 - Ajustes antes de salvar no git
*----------------------------------------------------------------


FUNCTION XmlNode( cXml, cNode, lComTag )

   LOCAL mInicio, mFim, cResultado := ""

   lComTag := iif( lComTag == NIL,.F., lComTag )
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

   cConteudo := Iif( cConteudo == NIL, "", cConteudo )
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

   cTexto := StrTran( cTexto, "&", "&amp;" )
   RETURN cTexto


FUNCTION DateXml( dDate )

   RETURN Transform( Dtos( dDate ), "@R 9999-99-99" )


FUNCTION DateTimeXml( dDate, cTime )

   cTime := iif( cTime == NIL, Time(), cTime )
   RETURN Transform( Dtos( dDate ), "@R 9999-99-99" ) + "T" + cTime + "+04:00"


FUNCTION NumberXml( nValue, nDecimals )

   nDecimals := iif( nDecimals == NIL, 0, nDecimals )
   RETURN Ltrim( Str( nValue, 16, nDecimals ) )


FUNCTION SoNumeros( cTxt )

   LOCAL cSoNumeros := "", cChar

   FOR EACH cChar IN cTxt
      IF cChar $ "0123456789"
         cSoNumeros += cChar
      ENDIF
   NEXT
   RETURN cSoNumeros