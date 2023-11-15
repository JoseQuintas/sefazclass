#include "sefazclass.ch"

FUNCTION ze_Sefaz_NFeEnvio( Self, cXml, cUF, cCertificado, cAmbiente, lSincrono )

   LOCAL oDoc, cChave

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   IF lSincrono != Nil .AND. ValType( lSincrono ) == "L"
      ::lSincrono := lSincrono
   ENDIF
   ::cProjeto := WS_PROJETO_NFE

   ::aSoapUrlList := WS_NFE_AUTORIZACAO
   ::Setup( cUF, cCertificado, cAmbiente )
   IF ::lSincrono
      // reservado pra implementacao futura em gzip
      ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote"
   ELSE
      ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote"
   ENDIF

   IF cXml != NIL
      ::cXmlDocumento := cXml
   ENDIF
   IF ::AssinaXml() != "OK"
      RETURN ::cXmlRetorno
   ENDIF
   IF ::cNFCe == "S"
      GeraQRCode( @::cXmlDocumento, ::cIdToken, ::cCSC, ::cVersao, ::cVersaoQrCode )
   ENDIF

   ::cXmlEnvio    := [<enviNFe versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   // FOR EACH cXmlNota IN aXmlNotas
   ::cXmlEnvio    += XmlTag( "idLote", "1" )
   ::cXmlEnvio    += XmlTag( "indSinc",iif( ::lSincrono, "1", "0" ) )
   ::cXmlEnvio    += ::cXmlDocumento
   // NEXT
   ::cXmlEnvio    += [</enviNFe>]
   ::XmlSoapPost()
   IF ! ::lSincrono
      ::cXmlRecibo := ::cXmlRetorno
      ::cRecibo    := XmlNode( ::cXmlRecibo, "nRec" )
      ::cStatus    := Pad( XmlNode( ::cXmlRecibo, "cStat" ), 3 )
      ::cMotivo    := XmlNode( ::cXmlRecibo, "xMotivo" )
      IF ! Empty( ::cRecibo )
         Inkey( ::nTempoEspera )
         ::NfeRetEnvio()
         IF hb_ASCan( { "104", "105" }, ::cStatus,,, .T. ) != 0
            oDoc   := XmlToDoc( ::cXmlDocumento, .F. )
            cChave := oDoc:cChave
            Inkey( ::nTempoEspera )
            ::NfeProtocolo( cChave, ::cUF, ::cCertificado, ::cAmbiente )
            IF ! Empty( XmlNode( ::cXmlRetorno, "infProt" ) )
               ::cXmlProtocolo := ::cXmlRetorno
            ENDIF
         ENDIF
         ::NfeGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
      ENDIF
   ELSE
      ::cXmlRecibo    := ::cXmlRetorno
      ::cXmlProtocolo := ::cXmlRetorno
      ::cRecibo       := ""
      ::NfeGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

STATIC FUNCTION GeraQRCode( cXmlAssinado, cIdToken, cCSC, cVersao, cVersaoQrCode )

   LOCAL QRCODE_cTag, QRCODE_Url, QRCODE_chNFe, QRCODE_nVersao, QRCODE_tpAmb
   LOCAL QRCODE_cDest, QRCODE_dhEmi, QRCODE_vNF, QRCODE_vICMS, QRCODE_digVal
   LOCAL QRCODE_cIdToken, QRCODE_cCSC, QRCODE_cHash, QRCODE_UrlChave, QRCODE_tpEmis
   LOCAL cInfNFe, cSignature, cAmbiente, cUF, nPos
   LOCAL aUrlList := WS_NFE_QRCODE

   hb_Default( @cIdToken, StrZero( 0, 6 ) )
   hb_Default( @cCsc, StrZero( 0, 36 ) )
   hb_Default( @cVersaoQRCode, "2.00" )

   cInfNFe    := XmlNode( cXmlAssinado, "infNFe", .T. )
   cSignature := XmlNode( cXmlAssinado, "Signature", .T. )

   cAmbiente  := XmlNode( XmlNode( cInfNFe, "ide" ), "tpAmb" )
   cUF        := Sefazclass():UFSigla( XmlNode( XmlNode( cInfNFe, "ide" ), "cUF" ) )

   // 1¦ Parte ( Endereco da Consulta - Fonte: http://nfce.encat.org/desenvolvedor/qrcode/ )
   nPos       := hb_AScan( aUrlList, { | e | e[ 1 ] == cUF .AND. ;
      ( e[ 2 ] == cVersao + iif( cAmbiente == WS_AMBIENTE_HOMOLOGACAO, "H", "P" ) .OR. ;
      e[ 2 ] == "4.00"  + iif( cAmbiente == WS_AMBIENTE_HOMOLOGACAO, "H", "P" ) ) } )
   QRCode_Url := iif( nPos == 0, "", aUrlList[ nPos, 3 ] )

   // 2¦ Parte (Parametros)
   QRCODE_chNFe    := AllTrim( Substr( XmlElement( cInfNFe, "Id" ), 4 ) )
   QRCODE_nVersao  := SoNumeros( cVersaoQRCode )
   QRCODE_tpAmb    := cAmbiente
   QRCODE_cDest    := XmlNode( XmlNode( cInfNFe, "dest" ), "CPF" )
   IF Empty( QRCODE_cDest )
      QRCODE_cDest := XmlNode( XmlNode( cInfNFe, "dest" ), "CNPJ" )
   ENDIF

   QRCODE_dhEmi    := XmlNode( XmlNode( cInfNFe, "ide" ), "dhEmi" )
   QRCODE_vNF      := XmlNode( XmlNode( XmlNode( cInfNFe, "total" ), "ICMSTot" ), "vNF" )
   QRCODE_vICMS    := XmlNode( XmlNode( XmlNode( cInfNFe, "total" ), "ICMSTot" ), "vICMS" )
   QRCODE_digVal   := hb_StrToHex( XmlNode( XmlNode( XmlNode( cSignature, "SignedInfo" ), "Reference" ), "DigestValue" ) )
   QRCODE_cIdToken := cIdToken
   QRCODE_cCSC     := cCsc
   QRCODE_tpEmis   := XmlNode( XmlNode( cInfNFe, "ide" ), "tpEmis" )

   IF ! Empty( QRCODE_chNFe ) .AND. ! Empty( QRCODE_nVersao ) .AND. ! Empty( QRCODE_tpAmb ) .AND. ! Empty( QRCODE_dhEmi ) .AND. !Empty( QRCODE_vNF ) .AND. ;
         ! Empty( QRCODE_vICMS ) .AND. ! Empty( QRCODE_digVal  ) .AND. ! Empty( QRCODE_cIdToken ) .AND. ! Empty( QRCODE_cCSC  )

      IF cVersaoQRCode == "2.00"
         IF QRCODE_tpEmis != "9"
            QRCODE_chNFe    := QRCODE_chNFe    + "|"
            QRCODE_nVersao  := "2"             + "|"
            QRCODE_tpAmb    := QRCODE_tpAmb    + "|"
            QRCODE_cIdToken := Ltrim( Str( Val( QRCODE_cIdToken ), 16, 0 ) )

            // 3¦ Parte (cHashQRCode)
            QRCODE_cHash := ( "|" + Upper( hb_SHA1( QRCODE_chNFe + QRCODE_nVersao + QRCODE_tpAmb + QRCODE_cIdToken + QRCODE_cCSC ) ) )

            // Resultado da URL formada a ser incluida na imagem QR Code
            QRCODE_cTag  := "<![CDATA[" + QRCODE_Url + "p=" + QRCODE_chNFe + QRCODE_nVersao + ;
               QRCODE_tpAmb + QRCODE_cIdToken  + QRCODE_cHash + "]]>"
         ELSE
            QRCODE_chNFe    := QRCODE_chNFe                  + "|"
            QRCODE_nVersao  := "2"                            + "|"
            QRCODE_tpAmb    := QRCODE_tpAmb                   + "|"
            QRCODE_dhEmi    := Substr( QRCODE_dhEmi, 9, 2 ) + "|"
            QRCODE_vNF      := QRCODE_vNF                     + "|"
            QRCODE_digVal   := QRCODE_digVal                  + "|"
            QRCODE_cIdToken := LTrim( Str( Val( QRCODE_cIdToken ), 16, 0 ) )
            QRCODE_cCSC     := QRCODE_cCSC

            // 3¦ Parte (cHashQRCode)
            //QRCODE_cHash := ( "|" + Upper(hb_SHA1( QRCODE_chNFe + QRCODE_nVersao + QRCODE_tpAmb + QRCODE_dhEmi + QRCODE_vNF + QRCODE_digVal + QRCODE_cIdToken + QRCODE_cCSC ) ) )

            QRCODE_cHash := Upper( hb_SHA1( QRCODE_chNFe + QRCODE_nVersao + QRCODE_tpAmb + QRCODE_dhEmi + QRCODE_vNF + QRCODE_digVal + QRCODE_cIdToken + QRCODE_cCSC ) )

            // Resultado da URL formada a ser incluida na imagem QR Code
            QRCODE_cTag  := "<![CDATA[" + QRCODE_Url + "p=" + QRCODE_chNFe + QRCODE_nVersao + ;
               QRCODE_tpAmb + QRCODE_dhEmi + QRCODE_vNF + QRCODE_digVal + QRCODE_cIdToken + "|" + ;
               QRCODE_cHash + "]]>"
         ENDIF
      ELSE
         QRCODE_chNFe    := "chNFe="    + QRCODE_chNFe    + "&"
         QRCODE_nVersao  := "nVersao="  + QRCODE_nVersao  + "&"
         QRCODE_tpAmb    := "tpAmb="    + QRCODE_tpAmb    + "&"
         // Na hipotese do consumidor nao se identificar na NFC-e, nao existira o parametro cDest no QR Code
         // e tambem nao devera ser incluido o parametro cDest na sequencia sobre a qual sera aplicado o hash do QR Code
         IF !Empty( QRCODE_cDest )
            QRCODE_cDest := "cDest="    + QRCODE_cDest    + "&"
         ENDIF
         QRCODE_dhEmi    := "dhEmi="    + QRCODE_dhEmi    + "&"
         QRCODE_vNF      := "vNF="      + QRCODE_vNF      + "&"
         QRCODE_vICMS    := "vICMS="    + QRCODE_vICMS    + "&"
         QRCODE_digVal   := "digVal="   + QRCODE_digVal   + "&"
         QRCODE_cIdToken := "cIdToken=" + QRCODE_cIdToken

         // 3¦ Parte (cHashQRCode)
         QRCODE_cHash := ( "&cHashQRCode=" + ;
            hb_SHA1( QRCODE_chNFe + QRCODE_nVersao + QRCODE_tpAmb + QRCODE_cDest + QRCODE_dhEmi + QRCODE_vNF + QRCODE_vICMS + QRCODE_digVal + QRCODE_cIdToken + QRCODE_cCSC ) )

         // Resultado da URL formada a ser incluida na imagem QR Code
         QRCODE_cTag  := "<![CDATA[" + QRCODE_Url + QRCODE_chNFe + QRCODE_nVersao + ;
            QRCODE_tpAmb + QRCODE_cDest + QRCODE_dhEmi + QRCODE_vNF + QRCODE_vICMS + ;
            QRCODE_digVal + QRCODE_cIdToken + QRCODE_cHash + "]]>"

      ENDIF

      // XML com a Tag do QRCode
      cXmlAssinado := [<NFe xmlns="http://www.portalfiscal.inf.br/nfe">]
      cXmlAssinado += cInfNFe
      cXmlAssinado += [<] + "infNFeSupl"+[>]
      cXmlAssinado += [<] + "qrCode"+[>] + QRCODE_cTag + [</] + "qrCode" + [>]

      IF cVersao == "4.00"
         aUrlList := WS_NFE_CHAVE
         nPos     := hb_AScan( aUrlList, { | e | e[ 1 ] == cUF .AND. ;
            e[ 2 ] == cVersaoQrCode + iif( cAmbiente == WS_AMBIENTE_HOMOLOGACAO, "H", "P" ) } )
         QRCode_UrlChave := iif( nPos == 0, "", aUrlList[ nPos, 3 ] )
         cXmlAssinado += XmlTag( "urlChave", QRCode_UrlChave )
      ENDIF

      cXmlAssinado += [</] + "infNFeSupl"+[>]
      cXmlAssinado += cSignature
      cXmlAssinado += [</NFe>]
   ELSE
      RETURN "Erro na geracao do QRCode"
   ENDIF

   RETURN "OK"

FUNCTION ze_sefaz_NFeContingencia( Self, cXml, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
   ::cUF           := iif( cUF == NIL, ::cUF, cUF )
   ::cCertificado  := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   ::cAmbiente     := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   ::cXmlDocumento := iif( cXml == NIL, ::cXmlDocumento, cXml )
   ::AssinaXml()
   IF ::cNFCe == "S"
      GeraQRCode( @::cXmlDocumento, ::cIdToken, ::cCSC, ::cVersao, ::cVersaoQrCode )
   ENDIF

   RETURN ::cXmlDocumento
