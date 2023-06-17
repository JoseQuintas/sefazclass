/*
ZE_SEFAZCLASS_MDFE - Rotinas pra MDFe
*/

#include "hbclass.ch"
#include "sefazclass.ch"
#include "hb2xhb.ch"

#ifdef __XHARBOUR__
#define ALL_PARAMETERS P1, P2, P3, P4, P5, P6, P7, P8, P9, P10
#else
#define ALL_PARAMETERS ...
#endif

CREATE CLASS SefazClass_MDFE

   METHOD MDFeConsNaoEnc( CUF, cCNPJ , cCertificado, cAmbiente )
   METHOD MDFeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD MDFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
   METHOD MDFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente )
   METHOD MDFeEvento( cChave, nSequencia, cTipoEvento, cXml, cCertificado, cAmbiente )
   METHOD MDFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente )
   METHOD MDFeEventoEncerramento( cChave, nSequencia, nProt, cUFFim, cMunCarrega, cCertificado, cAmbiente )
   METHOD MDFeEventoInclusaoCondutor( cChave, nSequencia, cNome, cCpf, cCertificado, cAmbiente )
   METHOD MDFeEventoPagamento( cChave, nSequencia, cXmlPagamento, cCertificado, cAmbiente )
   METHOD MDFeGeraAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD MDFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD MDFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente )
   //METHOD MDFeRecepcaoSinc( cXml, cUF, cCertificado, cAmbiente )
   METHOD MDFeStatusServico( cUF, cCertificado, cAmbiente )
   METHOD SoapUrlMdfe( aSoapList, cUF, cVersao )

   ENDCLASS

METHOD MDFeConsNaoEnc( cUF, cCNPJ , cCertificado, cAmbiente ) CLASS SefazClass_MDFE

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   ::cProjeto := WS_PROJETO_MDFE
   ::cSoapAction  := "mdfeConsNaoEnc"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeConsNaoEnc"
   ::aSoapUrlList := WS_MDFE_CONSULTANAOENCERRADOS
   ::Setup( cUF, cCertificado, cAmbiente )

   ::cXmlEnvio := [<consMDFeNaoEnc versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "xServ", "CONSULTAR NÃO ENCERRADOS" )
   ::cXmlEnvio +=    XmlTag( iif( ::lEmitenteCPF, "CPF", "CNPJ" ), cCNPJ )
   ::cXmlEnvio += [</consMDFeNaoEnc>]
   ::XmlSoapPost()
   IF ::cStatus != "999"
      ::cStatus := Pad( XmlNode( XmlNode( ::cXmlRetorno , "retConsMDFeNaoEnc" ) , "cStat" ), 3 )
      ::cMotivo := XmlNode( XmlNode( ::cXmlRetorno , "retConsMDFeNaoEnc" ) , "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno

METHOD MDFeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass_MDFE

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   ::cProjeto := WS_PROJETO_MDFE
   ::aSoapUrlList := WS_MDFE_CONSULTAPROTOCOLO
   ::Setup( cChave, cCertificado, cAmbiente )
   ::cSoapAction  := "mdfeConsultaMDF"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeConsulta"

   ::cXmlEnvio := [<consSitMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio +=    XmlTag( "chMDFe", cChave )
   ::cXmlEnvio += [</consSitMDFe>]
   IF DfeModFis( cChave ) != "58"
      ::cXmlRetorno := [<erro text="*ERRO* MDFEConsultaProtocolo() Chave não se refere a MDFE" />]
   ELSE
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
   ENDIF
   IF ::cStatus != "999"
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno

METHOD MDFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass_MDFE

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   ::cProjeto := WS_PROJETO_MDFE
   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF
   ::aSoapUrlList := WS_MDFE_RETAUTORIZACAO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "mdfeRetRecepcao"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRetRecepcao"

   ::cXmlEnvio := [<consReciMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "nRec", ::cRecibo )
   ::cXmlEnvio += [</consReciMDFe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno
   IF ::cStatus != "999"
      IF ! Empty( XmlNode( ::cXmlRetorno, "infProt" ) )
         ::cStatus       := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
         ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
      ELSE
         ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStat" ), 3 )
         ::cMotivo  := XmlNode( ::cXmlRetorno, "xMotivo" )
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

   // 2016.01.31.2200 Iniciado apenas

METHOD MDFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente ) CLASS SefazClass_MDFE

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   hb_Default( @cUltNSU, "0" )
   hb_Default( @cNSU, "" )
   ::cProjeto := WS_PROJETO_MDFE

   ::aSoapUrlList := WS_MDFE_DISTRIBUICAO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "mdfeDistDFeInteresse" // verificar na comunicação
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/MDFeDistribuicaoDFe"

   ::cXmlEnvio    := [<distDFeInt versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "cUFAutor", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio    +=    XmlTag( "CNPJ", cCnpj )
   IF Empty( cNSU )
      ::cXmlEnvio +=   [<distNSU>]
      ::cXmlEnvio +=      XmlTag( "ultNSU", cUltNSU )
      ::cXmlEnvio +=   [</distNSU>]
   ELSE
      ::cXmlEnvio +=   [<consNSU>]
      ::cXmlEnvio +=      XmlTag( "NSU", cNSU )
      ::cXmlEnvio +=   [</consNSU>]
   ENDIF
   ::cXmlEnvio    += [</distDFeInt>]
   ::XmlSoapPost()
   // UltNSU = ultimo NSU pesquisado
   // maxUSU = número máximo existente
   // docZIP = Documento em formato ZIP
   // NSU    = NSU do documento fiscal
   // schema = schemma de validação do XML anexado ex. procMDFe_v1.00.xsd, procEventoMDFe_V1.00.xsd

   RETURN NIL

METHOD MDFeEvento( cChave, nSequencia, cTipoEvento, cXml, cCertificado, cAmbiente ) CLASS SefazClass_MDFE

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   hb_Default( @nSequencia, 1 )
   ::cProjeto := WS_PROJETO_MDFE

   ::aSoapUrlList := WS_MDFE_EVENTO
   ::cSoapAction  := "mdfeRecepcaoEvento"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcaoEvento"
   ::Setup( cChave, cCertificado, cAmbiente )

   ::cXmlDocumento := [<eventoMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID] + cTipoEvento + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( iif( ::lEmitenteCPF, "CPF", "CNPJ" ), DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chMDFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", cTipoEvento )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       cXml
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</eventoMDFe>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := ::cXmlDocumento
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::MDFeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD MDFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass_MDFE

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   ::cProjeto := WS_PROJETO_MDFE
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evCancMDFe>]
   cXml +=       XmlTag( "descEvento", "Cancelamento" )
   cXml +=       XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=       XmlTag( "xJust", xJust )
   cXml +=    [</evCancMDFe>]
   cXml += [</detEvento>]

   ::MDFeEvento( cChave, nSequencia, "110111", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD MDFeEventoEncerramento( cChave, nSequencia, nProt, cUFFim , cMunCarrega , cCertificado, cAmbiente ) CLASS SefazClass_MDFE

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   ::cProjeto := WS_PROJETO_MDFE
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evEncMDFe>]
   cXml +=       XmlTag( "descEvento", "Encerramento" )
   cXml +=       XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=       XmlTag( "dtEnc", DateXml( Date() ) )
   cXml +=       XmlTag( "cUF", ::UFCodigo( cUFFim ) )
   cXml +=       XmlTag( "cMun", cMunCarrega )
   cXml +=    [</evEncMDFe>]
   cXml += [</detEvento>]

   ::MDFeEvento( cChave, nSequencia, "110112", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD MDFeEventoInclusaoCondutor( cChave, nSequencia, cNome, cCpf, cCertificado, cAmbiente )

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   ::cProjeto := WS_PROJETO_MDFE
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evIncCondutorMDFe>]
   cXml +=       XmlTag( "descEvento", "Inclusao Condutor" )
   cXml +=       [<condutor>]
   cXml +=          XmlTag( "xNome", cNome )
   cXml +=          XmlTag( "CPF", cCPF)
   cXml +=       [</condutor>]
   cXml +=    [</evIncCondutorMDFe>]
   cXml += [</detEvento>]

   ::MDFeEvento( cChave, nSequencia, "110114", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD MDFeEventoPagamento( cChave, nSequencia, cXmlPagamento, cCertificado, cAmbiente )

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   ::cProjeto := WS_PROJETO_MDFE
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml += cXmlPagamento
   cXml += [</detEvento>]

   ::MDFeEvento( cChave, nSequencia, "110116", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD MDFeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass_MDFE

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   ::cProjeto := WS_PROJETO_MDFE
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   IF ! Empty( XmlNode( ::cXmlRetorno, "infProt" ) )
      ::cStatus       := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
      ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
   ELSE
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF
   //::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protMDFe" ), "cStat" ), 3 )
   IF ! ::cStatus $ "100,101,150,301,302"
      ::cXmlRetorno := [<erro text="*ERRO* MDFEGeraAutorizado() Não autorizado" />] + ::cXmlProtocolo
      RETURN ::cXmlRetorno
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<mdfeProc versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlAUtorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protMDFe", .T. )
   ::cXmlAutorizado += [</mdfeProc>]

   RETURN NIL

METHOD MDFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass_MDFE

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   ::cProjeto := WS_PROJETO_MDFE
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "retEventoMDFe" ), "cStat" ), 3 )
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "retEventoMDFe" ), "xMotivo" ) // hb_utf8tostr()
   IF ! ::cStatus $ "135,136"
      ::cXmlRetorno := [<erro Text="*ERRO* MDFeGeraEventoAutorizado() Status inválido" />] + ::cXmlRetorno
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<procEventoMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEventoMDFe versao="] + ::cVersao + [">]
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "retEventoMDFe" ) // hb_Utf8ToStr(
   ::cXmlAutorizado += [</retEventoMDFe>]
   ::cXmlAutorizado += [</procEventoMDFe>]
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "infEvento" ), "xMotivo" ) // hb_Utf8ToStr

   RETURN NIL

METHOD MDFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente ) CLASS SefazClass_MDFE

   LOCAL oDoc, cBlocoXml, aList, nPos, cURLConsulta := "http:"

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   hb_Default( @cLote, "1" )
   ::cProjeto := WS_PROJETO_MDFE
   ::aSoapUrlList := WS_MDFE_AUTORIZACAO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "MDFeRecepcao"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcao"

   IF cXml != NIL
      ::cXmlDocumento := cXml
   ENDIF
   IF ::AssinaXml() != "OK"
      RETURN ::cXmlRetorno
   ENDIF
   oDoc := XmlToDoc( cXml, .F. )
   aList := WS_MDFE_QRCODE
   nPos := hb_ASCan( aList, { | e | e[ 2 ] == ::cVersao + iif( oDoc:cAmbiente == "1", "P", "H" ) } )
   IF nPos != 0
      cURLConsulta := aList[ nPos, 3 ]
   ENDIF
   IF ! "<infMDFeSupl>" $ ::cXmlDocumento
      cBlocoXml := "<infMDFeSupl>"
      cBlocoXml += "<qrCodMDFe>"
      cBlocoXml += "<![CDATA["
      cBlocoXml += cURLConsulta + "?chMDFe=" + oDoc:cChave + "&" + "tpAmb=" + ::cAmbiente
      cBlocoXml += "]]>"
      cBlocoXml += "</qrCodMDFe>"
      cBlocoXml += "</infMDFeSupl>"
      ::cXmlDocumento := StrTran( ::cXmlDocumento, "</infMDFe>", "</infMDFe>" + cBlocoXml )
   ENDIF
   ::cXmlEnvio  := [<enviMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio  +=    XmlTag( "idLote", cLote )
   ::cXmlEnvio  +=    ::cXmlDocumento
   ::cXmlEnvio  += [</enviMDFe>]
   ::XmlSoapPost()
   ::cXmlRecibo := ::cXmlRetorno
   ::cRecibo    := XmlNode( ::cXmlRecibo, "nRec" )
   IF ::cStatus != "999"
      ::cStatus    := Pad( XmlNode( ::cXmlRecibo, "cStatus" ), 3 )
      ::cMotivo    := XmlNode( ::cXmlRecibo, "xMotivo" )
   ENDIF
   IF ! Empty( ::cRecibo ) .AND. ::cStatus != "999"
      Inkey( ::nTempoEspera )
      ::MDFeConsultaRecibo()
      ::MDFeGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

// METHOD MDFeRecepcaoSinc( cXml, cUF, cCertificado, cAmbiente ) CLASS SefazClass_MDFE
//
//   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
//   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
//   ::aSoapUrlList := WS_MDFE_RECEPCAOSINC
//   ::Setup( cUF, cCertificado, cAmbiente )
//   ::cSoapAction := ""
//   ::cSoapService := ""
//
//   IF cXml != NIL
//      ::cXmlDocumento := cXml
//   ENDIF
//   IF ::AssinaXml() != "OK"
//      RETURN ::cXmlRetorno
///   ENDIF
//   ::cXmlEnvio := "falta definir aqui"
//   ::XmlSoapPost()
//   IF ::cXmlStatus != "999"
//      ::cStatus := XmlNode( ::cXmlRetorno, "cStatus" )
//      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
//      ::MDFeGeraAutorizado( ::cXmlDocumento, ::cXmlRetorno )
//   ENDIF

//   RETURN ::cXmlRetorno

METHOD MDFeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass_MDFE

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   ::cProjeto := WS_PROJETO_MDFE
   ::aSoapUrlList := WS_MDFE_STATUSSERVICO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "mdfeStatusServicoMDF"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeStatusServico"

   ::cXmlEnvio := [<consStatServMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   //::cXmlEnvio += XmlTag( "cUF", ::UFCodigo( ::cUF ) ) // MDFE não importa UF
   ::cXmlEnvio +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio += [</consStatServMDFe>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD SoapUrlMdfe( aSoapList, cUF, cVersao ) CLASS Sefazclass_mdfe

   LOCAL cUrl, nPos

   nPos := hb_AScan( aSoapList, { | e | cVersao == e[ 2 ] } )
   IF nPos != 0
      cUrl := aSoapList[ nPos, 3 ]
   ENDIF
   HB_SYMBOL_UNUSED( cUF )

   RETURN cUrl

