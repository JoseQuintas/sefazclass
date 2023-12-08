#include "sefazclass.ch"

FUNCTION ze_Sefaz_NFeEnvio( Self, cXml, cUF, cCertificado, cAmbiente, lEnvioSinc, lEnvioZip )

   LOCAL oDoc, cChave

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   hb_Default( @lEnvioZip, .F. )
   ::cProjeto := WS_PROJETO_NFE
   IF lEnvioSinc != Nil
      ::lEnvioSinc := lEnvioSinc
   ENDIF
   IF lEnvioZip != Nil
      ::lEnvioZip := lEnvioZip
   ENDIF
   ::aSoapUrlList := SoapList()
   ::Setup( cUF, cCertificado, cAmbiente, @lEnvioSinc )
   IF ::lEnvioZip
      ::cSoapAction += "Zip"
   ENDIF

   IF cXml != NIL
      ::cXmlDocumento := cXml
   ENDIF
   IF ::AssinaXml() != "OK"
      RETURN ::cXmlRetorno
   ENDIF
   IF ::lConsumidor
      GeraQRCode( @::cXmlDocumento, ::cIdToken, ::cCSC, ::cVersao, ::cVersaoQrCode )
   ENDIF

   ::cXmlEnvio := [<enviNFe versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio += XmlTag( "idLote", "1" )
   ::cXmlEnvio += XmlTag( "indSinc",iif( ::lEnvioSinc, "1", "0" ) )
   ::cXmlEnvio += ::cXmlDocumento
   ::cXmlEnvio += [</enviNFe>]
   ::XmlSoapPost()
   IF ! ::lEnvioSinc
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
   IF ::lConsumidor
      GeraQRCode( @::cXmlDocumento, ::cIdToken, ::cCSC, ::cVersao, ::cVersaoQrCode )
   ENDIF

   RETURN ::cXmlDocumento

STATIC FUNCTION SoapList()

RETURN { ;
   ;
   { "AM",    "4.00H", "https://homnfe.sefaz.am.gov.br/services2/services/NfeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "BA",    "4.00H", "https://hnfe.sefaz.ba.gov.br/webservices/NFeAutorizacao4/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "CE",    "4.00H", "https://nfeh.sefaz.ce.gov.br/nfe4/services/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "GO",    "4.00H", "https://homolog.sefaz.go.gov.br/nfe/services/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "MG",    "4.00H", "https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "MS",    "4.00H", "https://hom.nfe.sefaz.ms.gov.br/ws/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "MT",    "4.00H", "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "PE",    "4.00H", "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "PR",    "4.00H", "https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "RS",    "4.00H", "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "SP",    "4.00H", "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeautorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "SVAN",  "4.00H", "https://hom.sefazvirtual.fazenda.gov.br/NFeAutorizacao4/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "SVCAN", "4.00H", "https://hom.svc.fazenda.gov.br/NFeAutorizacao4/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "SVCRS", "4.00H", "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "SVRS",  "4.00H", "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   ;
   { "AM",    "4.00HC", "https://homnfe.sefaz.am.gov.br/services2/services/NfeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "AM",    "4.00HC", "https://homnfce.sefaz.am.gov.br/nfce-services/services/NfeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "GO",    "4.00HC", "https://homolog.sefaz.go.gov.br/nfe/services/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "MS",    "4.00HC", "https://hom.nfce.sefaz.ms.gov.br/ws/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "MT",    "4.00HC", "https://homologacao.sefaz.mt.gov.br/nfcews/services/NfeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "PR",    "4.00HC", "https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "RS",    "4.00HC", "https://nfce-homologacao.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "SP",    "4.00HC", "https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "SVRS",  "4.00HC", "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   ;
   { "AM",    "4.00P", "https://nfe.sefaz.am.gov.br/services2/services/NfeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "BA",    "4.00P", "https://nfe.sefaz.ba.gov.br/webservices/NFeAutorizacao4/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "GO",    "4.00P", "https://nfe.sefaz.go.gov.br/nfe/services/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "MG",    "4.00P", "https://nfe.fazenda.mg.gov.br/nfe2/services/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "MS",    "4.00P", "https://nfe.sefaz.ms.gov.br/ws/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "MT",    "4.00P", "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "PE",    "4.00P", "https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "PR",    "4.00P", "https://nfe.sefa.pr.gov.br/nfe/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "RS",    "4.00P", "https://nfe.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "SP",    "4.00P", "https://nfe.fazenda.sp.gov.br/ws/nfeautorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "SVAN",  "4.00P", "https://www.sefazvirtual.fazenda.gov.br/NFeAutorizacao4/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "SVCAN", "4.00P", "https://www.svc.fazenda.gov.br/NFeAutorizacao4/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "SVCRS", "4.00P", "https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "SVRS",  "4.00P", "https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   ;
   { "AM",    "4.00PC", "https://nfce.sefaz.am.gov.br/nfce-services/services/NfeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "GO",    "4.00PC", "https://nfe.sefaz.go.gov.br/nfe/services/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "MG",    "4.00PC", "https://nfce.fazenda.mg.gov.br/nfce/services/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "MS",    "4.00PC", "https://nfce.sefaz.ms.gov.br/ws/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "MT",    "4.00PC", "https://nfce.sefaz.mt.gov.br/nfcews/services/NfeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "PR",    "4.00PC", "https://nfce.sefa.pr.gov.br/nfce/NFeAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "RS",    "4.00PC", "https://nfce.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "SP",    "4.00PC", "https://nfce.fazenda.sp.gov.br/ws/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" }, ;
   { "SVRS",  "4.00PC", "https://nfce.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4/nfeAutorizacaoLote" } }
