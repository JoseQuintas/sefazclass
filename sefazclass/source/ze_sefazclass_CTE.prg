/*
ZE_SEFAZCLASS_CTE - Rotinas pra CTE
*/

#include "hbclass.ch"
#include "sefazclass.ch"
#include "hb2xhb.ch"

#ifdef __XHARBOUR__
#define ALL_PARAMETERS P1, P2, P3, P4, P5, P6, P7, P8, P9, P10
#else
#define ALL_PARAMETERS ...
#endif

CREATE CLASS SefazClass_CTE

   METHOD CTeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD CTeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
   METHOD CTeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente )
   METHOD CTeEvento( cChave, nSequencia, cTipoEvento, cXml, cCertificado, cAmbiente )
   METHOD CTeEventoCarta( cChave, nSequencia, aAlteracoes, cCertificado, cAmbiente )
   METHOD CTeEventoDesacordo( cChave, nSequencia, cObs, cCertificado, cAmbiente )
   METHOD CTeEventoEntrega( cChave, nSequencia, nProt, dDataEntrega, cHoraEntrega, cDoc, cNome, aNfeList, nLatitude, nLongitude, cStrImagem, cCertificado, cAmbiente )
   METHOD CTeEventoCancEntrega( cChave, nSequencia, nProt, nProtEntrega, cCertificado, cAmbiente )
   METHOD CTeGeraAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD CTeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD CTeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente )
   METHOD CTeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente )
   METHOD CTeStatusServico( cUF, cCertificado, cAmbiente )
   METHOD CTeAddCancelamento( cXmlAssinado, cXmlCancelamento )
   METHOD SoapUrlCte( aSoapList, cUF, cVersao )

   ENDCLASS

METHOD CTeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass_CTE

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::cProjeto := WS_PROJETO_CTE
   ::aSoapUrlList := WS_CTE_CONSULTAPROTOCOLO
   ::Setup( cChave, cCertificado, cAmbiente )
   ::cSoapAction  := "cteConsultaCT"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta"

   ::cXmlEnvio    := [<consSitCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio    +=    XmlTag( "chCTe", cChave )
   ::cXmlEnvio    += [</consSitCTe>]
   IF ! DfeModFis( cChave ) $ "57,67"
      ::cXmlRetorno := [<erro text="*ERRO* CteConsultaProtocolo() Chave não se refere a CTE" />]
   ELSE
      ::XmlSoapPost()
   ENDIF
   IF ::cStatus != "999"
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass_CTE

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::cProjeto := WS_PROJETO_CTE
   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF
   ::aSoapUrlList := WS_CTE_RETAUTORIZACAO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "cteRetRecepcao"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao"

   ::cXmlEnvio     := [<consReciCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlEnvio     +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio     +=    XmlTag( "nRec",  ::cRecibo )
   ::cXmlEnvio     += [</consReciCTe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno  // ? hb_Utf8ToStr()
   IF ::cStatus != "999"
      ::cStatus       := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
      ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno // ? hb_Utf8ToStr()

METHOD CTeEvento( cChave, nSequencia, cTipoEvento, cXml, cCertificado, cAmbiente ) CLASS SefazClass_CTE

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   hb_Default( @nSequencia, 1 )
   ::cProjeto := WS_PROJETO_CTE
   ::aSoapUrlList := WS_CTE_ENVIAEVENTO
   ::cSoapAction  := "cteRecepcaoEvento"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento"
   ::Setup( cChave, cCertificado, cAmbiente )

   ::cXmlDocumento := [<eventoCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID] + cTipoEvento + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( iif( ::lEmitenteCPF, "CPF", "CNPJ" ), DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chCTe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", cTipoEvento )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       cXml
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</eventoCTe>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := ::cXmlDocumento
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      IF ::cStatus != "999"
         ::CTeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass_CTE

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::cProjeto := WS_PROJETO_CTE
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evCancCTe>]
   cXml +=       XmlTag( "descEvento", "Cancelamento" )
   cXml +=       XmlTag( "nProt", Ltrim( Str( nProt, 16 ) ) )
   cXml +=       XmlTag( "xJust", xJust )
   cXml +=    [</evCancCTe>]
   cXml += [</detEvento>]

   ::CTeEvento( cChave, nSequencia, "110111", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD CTeEventoCarta( cChave, nSequencia, aAlteracoes, cCertificado, cAmbiente ) CLASS SefazClass_CTE

   LOCAL oElement, cXml := ""

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::cProjeto := WS_PROJETO_CTE
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=      [<evCCeCTe>]
   cXml +=          XmlTag( "descEvento", "Carta de Correcao" )
   FOR EACH oElement IN aAlteracoes
      cXml +=       [<infCorrecao>]
      cXml +=          XmlTag( "grupoAlterado", oElement[ 1 ] )
      cXml +=          XmlTag( "campoAlterado", oElement[ 2 ] )
      cXml +=          XmlTag( "valorAlterado", oElement[ 3 ] )
      cXml +=       [</infCorrecao>]
   NEXT
   cXml +=       [<xCondUso>]
   cXml +=          "A Carta de Correcao e disciplinada pelo Art. 58-B "
   cXml +=          "do CONVENIO/SINIEF 06/89: Fica permitida a utilizacao de carta "
   cXml +=          "de correcao, para regularizacao de erro ocorrido na emissao de "
   cXml +=          "documentos fiscais relativos a prestacao de servico de transporte, "
   cXml +=          "desde que o erro nao esteja relacionado com: I - as variaveis que "
   cXml +=          "determinam o valor do imposto tais como: base de calculo, aliquota, "
   cXml +=          "diferenca de preco, quantidade, valor da prestacao;II - a correcao "
   cXml +=          "de dados cadastrais que implique mudanca do emitente, tomador, "
   cXml +=          "remetente ou do destinatario;III - a data de emissao ou de saida."
   cXml +=       [</xCondUso>]
   cXml +=    [</evCCeCTe>]
   cXml += [</detEvento>]

   ::CTeEvento( cChave, nSequencia, "110110", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD CTeEventoDesacordo( cChave, nSequencia, cObs, cCertificado, cAmbiente ) CLASS SefazClass_CTE

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::cProjeto := WS_PROJETO_CTE
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evPrestDesacordo>]
   cXml +=       XmlTag( "descEvento", "Prestacao do Servico em Desacordo" )
   cXml +=       XmlTag( "indDesacordoOper", "1" )
   cXml +=       XmlTag( "xObs", cObs )
   cXml +=    [</evPrestDesacordo>]
   cXml += [</detEvento>]

   ::CTeEvento( cChave, nSequencia, "610110", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD CTeEventoEntrega( cChave, nSequencia, nProt, dDataEntrega, cHoraEntrega, cDoc, cNome, aNfeList, nLatitude, nLongitude, cStrImagem, cCertificado, cAmbiente ) CLASS SefazClass_CTE

   LOCAL oElement, cXml := "", cHash

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::cProjeto := WS_PROJETO_CTE
   cHash := hb_Sha1( cChave + hb_Base64Encode( cStrImagem ), .T. )
   cHash := hb_Base64Encode( cHash )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evCECTe>]
   cXml +=       XmlTag( "descEvento", "Comprovante de Entrega do CT-e" )
   cXml +=       XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=       XmlTag( "dhEntrega", DateTimeXml( dDataEntrega, cHoraEntrega, ::cUF ) )
   cXml +=       XmlTag( "nDoc", cDoc )
   cXml +=       XmlTag( "xNome", cNome )
   IF nLatitude != 0 .AND. nLongitude != 0
      cXml +=    XmlTag( "latitude", NumberXml( nLatitude, 16, 6 ) )
      cXml +=    XmlTag( "longitude", NumberXml( nLongitude, 16, 6 ) )
   ENDIF
   IF .F. // hash da imagem que não existe no xml ?????
      cXml +=    XmlTag( "hashEntrega", cHash )
      cXml +=    XmlTag( "dhHashEntrega", DateTimeXml( Date(), Time(), ::cUF ) )
   ENDIF
   IF Len( aNfeList ) > 0
      cXml +=    "<InfEntrega>"
      FOR EACH oElement IN aNfeList
         cXml +=    XmlTag( "chNFe", oElement )
      NEXT
      cXml +=    "</InfEntrega>"
   ENDIF
   cXml +=    [</evCECTe>]
   cXml += [</detEvento>]

   ::CTeEvento( cChave, nSequencia, "110180", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD CTeEventoCancEntrega( cChave, nSequencia, nProt, nProtEntrega, cCertificado, cAmbiente ) CLASS SefazClass_CTE

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::cProjeto := WS_PROJETO_CTE
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evCancCECTe>]
   cXml +=       XmlTag( "descEvento", "Cancelamento do Comprovante de Entrega do CT-e" )
   cXml +=       XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=       XmlTag( "nProtCE", LTrim( Str( nProtEntrega ) ) )
   cXml +=    [</evCancCECTe>]
   cXml += [</detEvento>]

   ::CTeEvento( cChave, nSequencia, "110181", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD CTeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass_CTE

   ::cProjeto := WS_PROJETO_CTE
   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   IF ! Empty( XmlNode( ::cXmlRetorno, "infProt" ) )
      ::cStatus       := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
      ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
   ELSE
      ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStat" ), 3 )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF
   //::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protCTe" ), "cStat" ), 3 )
   IF ! ::cStatus $ "100,101,150,301,302"
      ::cXmlRetorno := [<erro text="*ERRO* CTEGeraAutorizado() Não autorizado" />] + cXmlProtocolo
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<cteProc versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protCTe", .T. ) // ?hb_Utf8ToStr()
   ::cXmlAutorizado += [</cteProc>]

   RETURN ::cXmlAutorizado

METHOD CTeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass_CTE

   ::cProjeto := WS_PROJETO_CTE
   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "retEventoCTe" ), "cStat" ), 3 )
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "retEventoCTe" ), "xMotivo" ) // runner
   IF ! ::cStatus $ "135,155"
      ::cXmlRetorno := [<erro text="*ERRO* CteGeraEventoAutorizado() Não autorizado" />] + cXmlProtocolo
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<procEventoCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEventoCTe versao="] + ::cVersao + [">]
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "retEventoCTe" ) // hb_UTF8ToStr()
   ::cXmlAutorizado += [</retEventoCTe>]
   ::cXmlAutorizado += [</procEventoCTe>]
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "infEvento" ), "xMotivo" ) // hb_UTF8ToStr()

   RETURN NIL

METHOD CTeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente ) CLASS SefazClass_CTE

   ::cProjeto := WS_PROJETO_CTE
   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::aSoapUrlList := WS_CTE_INUTILIZA
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "cteInutilizacaoCT"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteInutilizacao"

   IF Len( cAno ) != 2
      cAno := Right( cAno, 2 )
   ENDIF
   ::cXmlDocumento := [<inutCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlDocumento +=    [<infInut Id="ID] + ::UFCodigo( ::cUF ) + cCnpj + cMod + StrZero( Val( cSerie ), 3 )
   ::cXmlDocumento +=    StrZero( Val( cNumIni ), 9 ) + StrZero( Val( cNumFim ), 9 ) + [">]
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "xServ", "INUTILIZAR" )
   ::cXmlDocumento +=       XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlDocumento +=       XmlTag( "ano", cAno )
   ::cXmlDocumento +=       XmlTag( "CNPJ", SoNumeros( cCnpj ) )
   ::cXmlDocumento +=       XmlTag( "mod", cMod )
   ::cXmlDocumento +=       XmlTag( "serie", cSerie )
   ::cXmlDocumento +=       XmlTag( "nCTIni", LTrim( Str( Val( cNumIni ), 9, 0 ) ) )
   ::cXmlDocumento +=       XmlTag( "nCTFin", LTrim( Str( Val( cNumFim ), 9, 0 ) ) )
   ::cXmlDocumento +=       XmlTag( "xJust", cJustificativa )
   ::cXmlDocumento +=    [</infInut>]
   ::cXmlDocumento += [</inutCTe>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := ::cXmlDocumento
      ::XmlSoapPost()
      IF ::cStatus != "999"
         ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStat" ), 3 )
         ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
      ENDIF
      IF ::cStatus == "102"
         ::cXmlAutorizado := XML_UTF8
         ::cXmlAutorizado += [<ProcInutCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
         ::cXmlAutorizado += ::cXmlDocumento
         ::cXmlAutorizado += XmlNode( ::cXmlRetorno , "retInutCTe", .T. )
         ::cXmlAutorizado += [</ProcInutCTe>]
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente ) CLASS SefazClass_CTE

   LOCAL oDoc, cBlocoXml, aList, cURLConsulta := "http:", nPos

   ::cProjeto := WS_PROJETO_CTE
   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   IF Empty( cLote )
      cLote := "1"
   ENDIF
   ::aSoapUrlList := WS_CTE_AUTORIZACAO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "cteRecepcaoLote"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcao"

   IF cXml != NIL
      ::cXmlDocumento := cXml
   ENDIF
   IF ::AssinaXml() != "OK"
      RETURN ::cXmlRetorno
   ENDIF

   oDoc := XmlToDoc( cXml, .F. )
   aList := WS_CTE_QRCODE
   nPos := hb_ASCan( aList, { | e | e[ 1 ] == DfeUF( oDoc:cChave ) .AND. e[ 2 ] == ::cVersao + iif( oDoc:cAmbiente == "1", "P", "H" ) } )
   IF nPos != 0
      cURLConsulta := aList[ nPos, 3 ]
   ENDIF
	cBlocoXml := "<infCTeSupl>"
	cBlocoXml += "<qrCodCTe>"
	cBlocoXml += "<![CDATA["
	cBlocoXml += cURLConsulta + "?chCTe=" + oDoc:cChave + "&" + "tpAmb=" + oDoc:cAmbiente
	cBlocoXml += "]]>"
	cBlocoXml += "</qrCodCTe>"
	cBlocoXml += "</infCTeSupl>"
	::cXmlDocumento := StrTran( ::cXmlDocumento, "</infCte>", "</infCte>" + cBlocoXml )

   ::cXmlEnvio    := [<enviCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlEnvio    +=    XmlTag( "idLote", cLote )
   ::cXmlEnvio    +=    ::cXmlDocumento
   ::cXmlEnvio    += [</enviCTe>]
   ::XmlSoapPost()
   ::cXmlRecibo := ::cXmlRetorno
   ::cRecibo    := XmlNode( ::cXmlRecibo, "nRec" )
   ::cStatus    := Pad( XmlNode( ::cXmlRecibo, "cStatus" ), 3 )
   ::cMotivo    := XmlNode( ::cXmlRecibo, "xMotivo" )
   IF ! Empty( ::cRecibo ) .AND. ::cStatus != "999"
      Inkey( ::nTempoEspera )
      ::CteConsultaRecibo()
      ::CteGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo ) // runner
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass_CTE

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::cProjeto := WS_PROJETO_CTE
   ::aSoapUrlList := WS_CTE_STATUSSERVICO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "cteStatusServicoCT"
   IF ::cVersao == "3.00"
      ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico"
      ::cXmlEnvio    := [<consStatServCte versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
      ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
      ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
      ::cXmlEnvio    += [</consStatServCte>]
   ELSE
      ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CTeStatusServicoV4"
      ::cXmlEnvio    := [<consStatServCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
      ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
      ::cXmlEnvio    +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
      ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
      ::cXmlEnvio    += [</consStatServCTe>]
   ENDIF
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD CTeAddCancelamento( cXmlAssinado, cXmlCancelamento ) CLASS SefazClass_CTE

   LOCAL cDigVal, cXmlAutorizado

   cDigVal := XmlNode( cXmlAssinado , "Signature" )
   cDigVal := XmlNode( cDigVal , "SignedInfo" )
   cDigVal := XmlNode( cDigVal , "Reference" )
   cDigVal := XmlNode( cDigVal , "DigestValue" )

   cXmlAutorizado := XML_UTF8
   cXmlAutorizado += [<cteProc versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   cXmlAutorizado +=    cXmlAssinado
   cXmlAutorizado +=    [<protCTe versao="] + ::cVersao + [">]
   cXmlAutorizado +=       [<infProt>]
   cXmlAutorizado +=          XmlTag( "tpAmb" , XmlNode( XmlNode( XmlNode( cXmlCancelamento, "retEventoCTe" ) , "infEvento" ), "tpAmb" ) ) // runner
   cXmlAutorizado +=          XmlTag( "verAplic", XmlNode( XmlNode( XmlNode( cXmlCancelamento, "retEventoCTe" ) , "infEvento" ), "verAplic" ) )
   cXmlAutorizado +=          XmlTag( "chCTe" , XmlNode( XmlNode( XmlNode( cXmlCancelamento, "retEventoCTe" ) , "infEvento" ), "chCTe" ) ) // runner
   cXmlAutorizado +=          XmlTag( "dhRecbto" , XmlNode( XmlNode( XmlNode( cXmlCancelamento, "retEventoCTe" ) , "infEvento" ), "dhRegEvento" ) ) // runner
   cXmlAutorizado +=          XmlTag( "nProt" , XmlNode( XmlNode( XmlNode( cXmlCancelamento, "retEventoCTe" ) , "infEvento" ), "nProt" ) ) // runner
   cXmlAutorizado +=          XmlTag( "digVal", cDigVal)
   cXmlAutorizado +=          XmlTag( "cStat", XmlNode( XmlNode( XmlNode( cXmlCancelamento, "retEventoCTe" ) , "infEvento" ), "cStat" ) )
   cXmlAutorizado +=          XmlTag( "xMotivo", 'Cancelamento do CTe homologado')
   cXmlAutorizado +=       [</infProt>]
   cXmlAutorizado +=    [</protNFe>]
   cXmlAutorizado += [</cteProc>]

   RETURN cXmlAutorizado

METHOD SoapUrlCte( aSoapList, cUF, cVersao ) CLASS Sefazclass_cte

   LOCAL nPos, cUrl

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   nPos := hb_AScan( aSoapList, { | e | cUF == e[ 1 ] .AND. cVersao == e[ 2 ] } )
   IF nPos != 0
      cUrl := aSoapList[ nPos, 3 ]
   ENDIF
   IF Empty( cUrl )
      IF cUF $ "AP,PE,RR"
         cUrl := ::SoapUrlCTe( aSoapList, "SVSP", cVersao )
      ELSEIF cUF $ "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,RS,SC,SE,TO"
         cUrl := ::SoapUrlCTe( aSoapList, "SVRS", cVersao )
      ENDIF
   ENDIF

   RETURN cUrl

