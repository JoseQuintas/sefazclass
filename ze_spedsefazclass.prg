*****************************************************************
* ZE_SEFAZ - ROTINAS PRA SPED NFE/CTE/MDFE
* 2012.01.01
*****************************************************************

* 26.03.13 - Alterado pra nao parar com erro
* 2013.04.25.1908 - Apenas ajuste de fonte
* 2013.05.28.2346 - Ajuste no envelope pra mdfe
* 2013.05.30.1030 - Organizado fonte
* 2013.06.08.2109 - Organizado fonte e variaveis
* 2013.06.26.1115 - Organizado e liberado
*----------------------------------------------------------------

#include "hbclass.ch"

#define WSCTERECEPCAO              1   // falta webservices
#define WSCTECONSULTAPROTOCOLO     2   // falta webservices
#define WSCTESTATUSSERVICO         3   // falta webservices
#define WSNFECANCELAMENTO          4
#define WSNFECONSULTACADASTRO      5
#define WSNFECONSULTAPROTOCOLO     6
#define WSNFEINUTILIZACAO          7
#define WSNFERECEPCAO              8
#define WSNFERECEPCAOEVENTO        9
#define WSNFERETRECEPCAO           10
#define WSNFESTATUSSERVICO         11
#define WSNFEDOWNLOADNF            12
#define WSNFECONSULTADEST          13
#define WSMDFERECEPCAO             14
#define WSMDFERETRECEPCAO          15
#define WSMDFERECEPCAOEVENTO       16
#define WSMDFECONSULTAPROTOCOLO    17
#define WSMDFESTATUSSERVICO        18

#define WSHOMOLOGACAO   "2"
#define WSPRODUCAO      "1"

CREATE CLASS SefazClass

   VAR    cAmbiente     INIT WSPRODUCAO
   VAR    cScan         INIT "N"
   VAR    cUF           INIT "SP"
   VAR    cVersao       INIT ""
   VAR    cServico      INIT ""
   VAR    cSoapAction   INIT ""
   VAR    cWebService   INIT ""
   VAR    cCertificado  INIT ""
   VAR    cXmlDados     INIT ""
   VAR    cXmlSoap      INIT ""
   VAR    cXmlRetorno   INIT "*ERRO*"
   VAR    cProjeto      INIT "nfe"   // nfe, cte, mdfe
   METHOD CteConsulta( cChave, cCertificado )
   METHOD CteLoteEnvia( cXml, cLote, cUf, cCertificado )
   METHOD CteStatus( cUf, cCertificado )
   METHOD MdfeConsulta( cChave, cCertificado )
   METHOD NfeCancela( cUf, cXml, cCertificado )
   METHOD NfeCadastro( cUf, cCnpj, cCertificado )
   METHOD NfeConsulta( cChave, cCertificado )
   METHOD NfeEventoEnvia( cChave, cXml, cCertificado )
   METHOD NfeLoteEnvia( cXml, cLote, cUf, cCertificado )
   METHOD NfeConsultaRecibo( cRecibo, cUf, cCertificado )
   METHOD NfeStatus( cUf, cCertificado )
   METHOD TipoXml( cXml )
   METHOD GetWebService( cUf, cServico )
   METHOD XmlSoapEnvelope()
   METHOD XmlSoapPost()
   METHOD MicrosoftXmlSoapPost()
   ENDCLASS


METHOD CteConsulta( cChave, cCertificado ) CLASS SefazClass

   ::cCertificado:= cCertificado
   ::cVersao     := "1.04"
   ::cUf         := Substr( cChave, 1, 2 )
   ::cServico    := "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta"
   ::cSoapAction := "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta/cteConsultaCT"
   ::cWebService := ::GetWebService( UfCodigo( ::cUf ), WSCTECONSULTAPROTOCOLO )
   ::cXmlDados   := ""
   ::cXmlDados += [<consSitCTe versao="] + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlDados += [<tpAmb>] + ::cAmbiente + [</tpAmb>]
   ::cXmlDados += [<xServ>CONSULTAR</xServ>]
   ::cXmlDados += [<chCTe>] + cChave + [</chCTe>]
   ::cXmlDados += [</consSitCTe>]
   ::XmlSoapPost()
   RETURN ::cXmlRetorno


METHOD CteLoteEnvia( cXml, cLote, cUf, cCertificado ) CLASS SefazClass

   ::cCertificado := cCertificado
   ::cUf          := UfCodigo( cUf )
   ::cVersao      := "1.00"
   ::cServico     := "http://www.portalfiscal.inf.br/cte/wsdl/cteRecepcao"
   ::cWebService  := ::GetWebService( cUf, WSCTERECEPCAO )
   ::cXmlDados    := ""
   ::cXmlDados    += [<envicte versao="] + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   // FOR nCont = 1 TO Len( Lotes )
   ::cXmlDados += [<idLote>] + cLote + [</idLote>]
   ::cXmlDados += cXml
   // NEXT
   ::cXmlDados += [</envicte>]
   ::XmlSoapPost()
   RETURN ::cXmlRetorno


METHOD CteStatus( cUf, cCertificado ) CLASS SefazClass

   ::cCertificado := cCertificado
   ::cVersao      := "1.04"
   ::cUf          := UfCodigo( cUf )
   ::cServico     := "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico"
   ::cSoapAction  := "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico/cteStatusServicoCT"
   ::cWebService  := ::GetWebService( cUf, WSCTESTATUSSERVICO )
   ::cXmlDados    := ""
   ::cXmlDados := [<consStatServCte versao="]  + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/cte" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >]
   ::cXmlDados +=    [<tpAmb>] + ::cAmbiente + [</tpAmb>]
   ::cXmlDados +=    [<xServ>STATUS</xServ>]
   ::cXmlDados += [</consStatServCte>]
   ::XmlPost()
   RETURN ::cXmlRetorno


METHOD MdfeConsulta( cChave, cCertificado ) CLASS SefazClass

   ::cCertificado := cCertificado
   ::cVersao     := "1.00"
   ::cUf         := Substr( cChave, 1, 2 )
   ::cServico    := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeConsulta"
   ::cSoapAction := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeConsulta/MDFeConsultaMDF"
   ::cWebService := ::GetWebService( UfCodigo( ::cUf ), WSMDFECONSULTAPROTOCOLO )
   ::cXmlDados   := ""
   ::cXmlDados += [<consSitMDFe versao="] + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlDados += [<tpAmb>] + ::cAmbiente + [</tpAmb>]
   ::cXmlDados += [<xServ>CONSULTAR</xServ>]
   ::cXmlDados += [<chMDFe>] + cChave + [</chMDFe>]
   ::cXmlDados += [</consSitMDFe>]
   ::XmlSoapPost()
   RETURN ::cXmlRetorno


METHOD NfeCancela( cUf, cXml, cCertificado ) CLASS SefazClass

   ::cCertificado := cCertificado
   ::cVersao      := "2.00"
   ::cUf          := UfCodigo( cUf )
   ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeCancelamento2"
   ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeCancelamento2/nfeCancelamentoNF2"
   ::cWebService  := ::GetWebService( cUf, WSNFECANCELAMENTO )
   ::cXmlDados    := cXml
   ::XmlSoapPost()
   RETURN ::cXmlRetorno


METHOD NfeCadastro( cUf, cCnpj, cCertificado ) CLASS SefazClass

   ::cCertificado := cCertificado
   ::cVersao      := "2.00"
   ::cUf          := UfCodigo( cUf )
   ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro2"
   ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro2"
   ::cWebService  := ::GetWebService( cUf, WSNFECONSULTACADASTRO )
   ::cXmlDados    := ""
   ::cXmlDados    += [<ConsCad versao="2.00" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados    += [<infCons>]
   ::cXmlDados    += [<xServ>CONS-CAD</xServ>]
   ::cXmlDados    += [<UF>] + cUf + [</UF>]
   ::cXmlDados    += [<CNPJ>] + cCNPJ + [</CNPJ>]
   ::cXmlDados    += [</infCons>]
   ::cXmlDados    += [</ConsCad>]
   IF .NOT. cUf $ "AM,RS" // UFs que dependem de estar cadastrado, ou sem webservice de consulta
      IF Empty( ::cWebService )
         ::cXmlRetorno := ""
      ELSE
         ::XmlSoapPost()
      ENDIF
   ENDIF
   RETURN ::cXmlRetorno


METHOD NfeConsulta( cChave, cCertificado ) CLASS SefazClass

   ::cCertificado:= cCertificado
   ::cVersao     := "2.01"
   ::cUf         := Substr( cChave, 1, 2 )
   ::cServico    := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2"
   ::cSoapAction := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2"
   ::cWebService := ::GetWebService( UfCodigo( ::cUf ), WSNFECONSULTAPROTOCOLO )
   ::cXmlDados   := ""
   ::cXmlDados   += [<consSitNFe versao="] + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados   += [<tpAmb>] + ::cAmbiente + [</tpAmb>]
   ::cXmlDados   += [<xServ>CONSULTAR</xServ>]
   ::cXmlDados   += [<chNFe>] + cChave + [</chNFe>]
   ::cXmlDados   += [</consSitNFe>]
   ::XmlSoapPost()
   RETURN ::cXmlRetorno


METHOD NfeEventoEnvia( cChave, cXml, cCertificado ) CLASS SefazClass

   ::cCertificado := cCertificado
   ::cVersao      := "1.00"
   ::cUf          := Substr( cChave, 1, 2 )
   ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento"
   ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento/nfeRecepcaoEvento"
   ::cWebService  := ::GetWebService( UfCodigo( ::cUf ), WSNFERECEPCAOEVENTO )
   ::cXmlDados    := ""
   ::cXmlDados    += [<envEvento versao="] + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados    += [<idLote>] + Substr( cChave, 26, 9 ) + [</idLote>] // usado numero da nota
   ::cXmlDados    += cXml
   ::cXmlDados += [</envEvento>]
   ::XmlSoapPost()
   RETURN ::cXmlRetorno


METHOD NfeLoteEnvia( cXml, cLote, cUf, cCertificado ) CLASS SefazClass

   ::cCertificado := cCertificado
   ::cXmlDados    := ""
   ::cUf          := UfCodigo( cUf )
   ::cVersao      := "2.00"
   ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeRecepcao2"
   ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeRecepcao2/nfeRecepcaoLote2"
   ::cWebService  := ::GetWebService( cUf, WSNFERECEPCAO )
   ::cXmlDados    += [<enviNFe versao="] + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   // FOR nCont = 1 TO Len( Lotes )
   ::cXmlDados += [<idLote>] + cLote + [</idLote>]
   ::cXmlDados += cXml
   // NEXT
   ::cXmlDados += [</enviNFe>]
   ::XmlSoapPost()
   RETURN ::cXmlRetorno


METHOD NfeConsultaRecibo( cRecibo, cUf, cCertificado ) CLASS SefazClass

   ::cCertificado := cCertificado
   ::cVersao      := "2.00"
   ::cUf          := UfCodigo( cUf )
   ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetRecepcao2"
   ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetRecepcao2/nfeRetRecepcao2"
   ::cWebService  := ::GetWebService( cUf, WSNFERETRECEPCAO )
   ::cXmlDados    := ""
   ::cXmlDados := [<consReciNFe versao="] + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados +=    [<tpAmb>] + ::cAmbiente + [</tpAmb>]
   ::cXmlDados +=    [<nRec>] + cRecibo + [</nRec>]
   ::cXmlDados += [</consReciNFe>]
   ::XmlSoapPost()
   RETURN ::cXmlRetorno


METHOD NfeStatus( cUf, cCertificado ) CLASS SefazClass

   ::cCertificado := cCertificado
   ::cVersao      := "2.00"
   ::cUf          := UfCodigo( cUf )
   ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2"
   ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2/nfeStatusServicoNF2"
   ::cWebService  := ::GetWebService( cUf, WSNFESTATUSSERVICO )
   ::cXmlDados    := ""
   ::cXmlDados := [<consStatServ versao="] + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/nfe" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">]
   ::cXmlDados +=    [<tpAmb>] + ::cAmbiente + [</tpAmb>]
   ::cXmlDados +=    [<cUF>] + ::cUf + [</cUF>]
   ::cXmlDados +=    [<xServ>STATUS</xServ>]
   ::cXmlDados += [</consStatServ>]
   ::XmlPost()
   RETURN ::cXmlRetorno


METHOD TipoXml( cXml ) CLASS SefazClass

   LOCAL aTipos, cTipoXml, nCont, cTipoEvento

   aTipos := { ;
      { [<infMDFe],   [MDFE] }, ; // primeiro, pois tem nfe e cte
      { [<infCte],    [CTE]  }, ;   // segundo, pois tem nfe
      { [<cancCTe],   [CTEC] }, ;
      { [<infNFe],    [NFE]  }, ;
      { [<infCanc],   [NFEC] }, ;
      { [<infInut],   [INUT] }, ;
      { [<infEvento], [EVEN] } }
   cTipoXml := "XX"
   FOR nCont = 1 TO Len( aTipos )
      IF Upper( aTipos[ nCont, 1 ] ) $ Upper( cXml )
         cTipoXml := aTipos[ nCont, 2 ]
         IF cTipoXml == "EVEN"
            cTipoEvento := XmlNode( cXml, "tpEvento" )
            DO CASE
            CASE cTipoEvento == "110111"
               IF "<chNFe" $ cXml
                  cTipoXml := "NFEC"
               ENDIF
            CASE cTipoEvento == "110110"
               cTipoXml := "CCE"
            OTHERWISE
               cTipoXml := "OUTROEVENTO"
            ENDCASE
         ENDIF
         EXIT
      ENDIF
   NEXT
   RETURN cTipoXml


METHOD GetWebService( cUf, cServico ) CLASS SefazClass

   LOCAL cTexto

   // SVAN: ES,MA,PA,PI,RN
   // SVRS: AC,AL,AM,AP,DF,MS,PB,RJ,RO,RR,SC,SE,TO
   // Autorizadores: AM,BA,CE,GO,MG,MS,MT,PE,PR,RN,RS,SP,SVAN,SVRS,SCAN
   IF ::cScan == "S"
      cTexto := UrlWebService( "SCAN", ::cAmbiente, cServico )
   ELSEIF ::cProjeto == "mdfe" // mdfe esta no RS
      cTexto := UrlWebService( "RS", ::cAmbiente, cServico )
   ELSE
      cTexto := UrlWebService( cUf, ::cAmbiente, cServico )
   ENDIF
   IF Empty( cTexto )
      IF cUf $ "AC,AL,AM,AP,DF,MS,PB,RJ,RO,RR,SC,SE,TO" // Sefaz Virtual RS
         cTexto := UrlWebService( "SVRS", ::cAmbiente, cServico )
      ELSEIF cUf $ "ES,MA,PA,PI,RN" // Sefaz Virtual
         cTexto := UrlWebService( "SVAN", ::cAmbiente, cServico )
      ENDIF
   ENDIF
   RETURN cTexto


METHOD XmlSoapPost() CLASS SefazClass

   ::XmlSoapEnvelope()
   ::MicrosoftXmlSoapPost()
   RETURN NIL


METHOD XmlSoapEnvelope() CLASS SefazClass

// Toda comunicacao SOAP depende de um envelope
// O envelope e um XML que contem o XML dos dados, algo como envelopeinicio + xmldados + envelopefim
// Por enquanto ha tres tipos de envelope: nfe, cte e mdfe
   ::cXmlSoap := ""
   ::cXmlSoap += [<?xml version="1.0" encoding="UTF-8"?>]
   ::cXmlSoap += [<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ] + ;
                [xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">]
   ::cXmlSoap +=    [<soap12:Header>]
   ::cXmlSoap +=       [<] + ::cProjeto + [CabecMsg xmlns="] + ::cServico + [">]
   ::cXmlSoap +=          [<cUF>] + ::cUf + [</cUF>]
   ::cXmlSoap +=          [<versaoDados>] + ::cVersao + [</versaoDados>]
   ::cXmlSoap +=       [</] + ::cProjeto + [CabecMsg>]
   ::cXmlSoap +=    [</soap12:Header>]
   ::cXmlSoap +=    [<soap12:Body>]
   ::cXmlSoap +=       [<] + ::cProjeto + [DadosMsg xmlns="] + ::cServico + [">]
   ::cXmlSoap += ::cXmlDados
   ::cXmlSoap +=    [</] + ::cProjeto + [DadosMsg>]
   ::cXmlSoap +=    [</soap12:Body>]
   ::cXmlSoap += [</soap12:Envelope>]
   RETURN ::cXmlSoap


METHOD MicrosoftXmlSoapPost() CLASS SefazClass

   LOCAL oServer, nCont, cRetorno := "*ERRO*"

   BEGIN SEQUENCE WITH { |e| Break(e) }
      oServer := win_OleCreateObject( "MSXML2.ServerXMLHTTP")
      IF ::cCertificado != NIL
         oServer:setOption( 3, "CURRENT_USER\MY\" + ::cCertificado )
      ENDIF
      oServer:Open( "POST", ::cWebService, .F. )
      oServer:SetRequestHeader( "SOAPAction", ::cSoapAction )
      oServer:SetRequestHeader( "Content-Type", "application/soap+xml; charset=utf-8" )
      oServer:Send( ::cXmlSoap )
      oServer:WaitForResponse( 500 )
      cRetorno := oServer:ResponseBody
   ENDSEQUENCE
   IF ValType( cRetorno ) == "C"
      ::cXmlRetorno := cRetorno
   ELSEIF cRetorno == NIL
      ::cXmlRetorno := "*ERRO*"
   ELSE
      ::cXmlRetorno := ""
      FOR nCont = 1 TO Len( cRetorno )
         ::cXmlRetorno += Chr( cRetorno[ nCont ] )
      NEXT
   ENDIF
   // IF .NOT. "<cStat>" $ cRetorno
   //   cRetorno := "<cStat>ERRO NO RETORNO</cStat>" + cRetorno
   // ENDIF
   RETURN NIL


FUNCTION UfCodigo( cChave )

   LOCAL cUFs, cUf, nPosicao

   cUFs = "AC,12,AL,27,AM,13,AP,16,BA,29,CE,23,DF,53,ES,32,GO,52,MG,31,MS,50,MT,51,MA,21,PA,15,PB,25,PE,26,PI,22,PR,41,RJ,33,RO,11,RN,24,RR,14,RS,43,SC,42,SE,28,SP,35,TO,17,"
   nPosicao = At( Substr( cChave, 1, 2 ), cUfs )
   IF nPosicao < 1
      cUf = "XX"
   ELSE
      IF Val( cChave ) > 0 // codigo pra nome
         cUf := Substr( cUFs, nPosicao - 3, 2 )
      ELSE
         cUf := Substr( cUFs, nPosicao + 3, 2 )
      ENDIF
   ENDIF
   RETURN cUf


STATIC FUNCTION UrlWebService( cUf, cAmbiente, nWsService )

   LOCAL cUrlWs := ""

   DO CASE
   CASE cUf == "AM" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeCancelamento2"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/cadconsultacadastro2"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeConsulta2"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeInutilizacao2"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeRecepcao2"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/RecepcaoEvento"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeRetRecepcao2"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeStatusServico2"
      ENDCASE

   CASE cUf == "AM" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeCancelamento2"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/cadconsultacadastro2"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeConsulta2"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeInutilizacao2"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeRecepcao2"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/RecepcaoEvento"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeRetRecepcao2"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeStatusServico2"
      ENDCASE

   CASE cUf == "BA" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeCancelamento2.asmx"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/nfenw/CadConsultaCadastro2.asmx"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeConsulta2.asmx"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeInutilizacao2.asmx"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeRecepcao2.asmx"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/sre/RecepcaoEvento.asmx"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeRetRecepcao2.asmx"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeStatusServico2.asmx"
      ENDCASE

   CASE cUf == "BA" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeCancelamento2.asmx"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/CadConsultaCadastro2.asmx"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeConsulta2.asmx"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeInutilizacao2.asmx"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeRecepcao2.asmx"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/sre/RecepcaoEvento.asmx"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeRetRecepcao2.asmx"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeStatusServico2.asmx"
      ENDCASE

   CASE cUf == "CE" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeCancelamento2"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/CadConsultaCadastro2"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeConsulta2"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeInutilizacao2"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRecepcao2"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/RecepcaoEvento"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRetRecepcao2"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeStatusServico2"
      ENDCASE

   CASE cUf == "CE" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeCancelamento2"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/CadConsultaCadastro2"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeConsulta2"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeInutilizacao2"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRecepcao2"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/RecepcaoEvento"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRetRecepcao2"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeStatusServico2"
      ENDCASE

   CASE cUf == "GO" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeCancelamento2?wsdl"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/CadConsultaCadastro2?wsdl"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeConsulta2?wsdl"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeInutilizacao2?wsdl"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRecepcao2?wsdl"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRecepcaoEvento?wsdl"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRetRecepcao2?wsdl"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeStatusServico2?wsdl"
      ENDCASE

   CASE cUf == "GO" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeCancelamento2?wsdl"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/CadConsultaCadastro2?wsdl"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeConsulta2?wsdl"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeInutilizacao2?wsdl"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRecepcao2?wsdl"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRecepcaoEvento?wsdl"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRetRecepcao2?wsdl"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeStatusServico2?wsdl"
      ENDCASE

   CASE cUf == "MT" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeCancelamento2?wsdl"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/CadConsultaCadastro"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta2?wsdl"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao2?wsdl"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRecepcao2?wsdl"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento?wsdl"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRetRecepcao2?wsdl"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl"
      ENDCASE

   CASE cUf == "MT" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeCancelamento2?wsdl"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta2?wsdl"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao2?wsdl"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRecepcao2?wsdl"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento?wsdl"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRetRecepcao2?wsdl"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl"
      ENDCASE

   CASE cUf == "MS" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeCancelamento2"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/CadConsultaCadastro2"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeConsulta2"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeInutilizacao2"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeRecepcao2"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/RecepcaoEvento"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeRetRecepcao2"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeStatusServico2"
      ENDCASE

   CASE cUf == "MS" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeCancelamento2"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/CadConsultaCadastro2"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeConsulta2"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeInutilizacao2"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeRecepcao2"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/RecepcaoEvento"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeRetRecepcao2"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeStatusServico2"
      ENDCASE

   CASE cUf == "MG" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeCancelamento2"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/cadconsultacadastro2"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeConsulta2"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeInutilizacao2"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRecepcao2"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/RecepcaoEvento"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRetRecepcao2"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeStatus2"
      ENDCASE

   CASE cUf == "MG" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeCancelamento2"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/cadconsultacadastro2"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeConsulta2"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeInutilizacao2"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeRecepcao2"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/RecepcaoEvento"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeRetRecepcao2"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeStatusServico2"
      ENDCASE

   CASE cUf == "PR" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe2.fazenda.pr.gov.br/nfe/NFeCancelamento2?wsdl"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe2.fazenda.pr.gov.br/nfe/CadConsultaCadastro2?wsdl"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe2.fazenda.pr.gov.br/nfe/NFeConsulta2?wsdl"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe2.fazenda.pr.gov.br/nfe/NFeInutilizacao2?wsdl"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://nfe2.fazenda.pr.gov.br/nfe/NFeRecepcao2?wsdl"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe2.fazenda.pr.gov.br/nfe-evento/NFeRecepcaoEvento?wsdl"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe2.fazenda.pr.gov.br/nfe/NFeRetRecepcao2?wsdl"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe2.fazenda.pr.gov.br/nfe/NFeStatusServico2?wsdl"
      ENDCASE

   CASE cUf == "PR" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeCancelamento2?wsdl"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/CadConsultaCadastro2?wsdl"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeConsulta2?wsdl"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeInutilizacao2?wsdl"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeRecepcao2?wsdl"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe-evento/NFeRecepcaoEvento?wsdl"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeRetRecepcao2?wsdl"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeStatusServico2?wsdl"
      ENDCASE

   CASE cUf == "PE" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeCancelamento2"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/CadConsultaCadastro2"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeInutilizacao2"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRecepcao2"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/RecepcaoEvento"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRetRecepcao2"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeStatusServico2"
      ENDCASE

   CASE cUf == "PE" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeCancelamento2"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeInutilizacao2"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeRecepcao2"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/RecepcaoEvento"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeRetRecepcao2"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeStatusServico2"
      ENDCASE

   CASE cUf == "RN" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://webservice.set.rn.gov.br/projetonfeprod/set_nfe/servicos/CadConsultaCadastroWS.asmx"
      ENDCASE

   CASE cUf == "RN" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://webservice.set.rn.gov.br/projetonfehomolog/set_nfe/servicos/CadConsultaCadastroWS.asmx"
      ENDCASE

   CASE cUf == "RS" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsService == WSMDFECONSULTAPROTOCOLO ;     cUrlWs := "https://mdfe.sefaz.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx"
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/NfeCancelamento/NfeCancelamento2.asmx"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://sef.sefaz.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/Nferecepcao/NFeRecepcao2.asmx"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/NfeRetRecepcao/NfeRetRecepcao2.asmx"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx"
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://homologacao.nfe.sefaz.rs.gov.br/ws/NfeCancelamento/NfeCancelamento2.asmx"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://homologacao.nfe.sefaz.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://homologacao.nfe.sefaz.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://homologacao.nfe.sefaz.rs.gov.br/ws/Nferecepcao/NFeRecepcao2.asmx"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://homologacao.nfe.sefaz.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://homologacao.nfe.sefaz.rs.gov.br/ws/NfeRetRecepcao/NfeRetRecepcao2.asmx"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://homologacao.nfe.sefaz.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx"
      ENDCASE

   CASE cUf == "SP" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsService == WSCTECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx"
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.fazenda.sp.gov.br/nfeweb/services/nfecancelamento2.asmx"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.fazenda.sp.gov.br/nfeweb/services/cadconsultacadastro2.asmx"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.fazenda.sp.gov.br/nfeweb/services/nfeconsulta2.asmx"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.fazenda.sp.gov.br/nfeweb/services/nfeinutilizacao2.asmx"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://nfe.fazenda.sp.gov.br/nfeweb/services/nferecepcao2.asmx"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.fazenda.sp.gov.br/eventosWEB/services/RecepcaoEvento.asmx"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.fazenda.sp.gov.br/nfeweb/services/nferetrecepcao2.asmx"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.fazenda.sp.gov.br/nfeweb/services/nfestatusservico2.asmx"

      ENDCASE

   CASE cUf == "SP" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;           cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/NfeCancelamento2.asmx"
      CASE nWsService == WSNFECONSULTACADASTRO ;       cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/CadConsultaCadastro2.asmx"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/NfeConsulta2.asmx"
      CASE nWsService == WSNFEINUTILIZACAO ;           cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/NfeInutilizacao2.asmx"
      CASE nWsService == WSNFERECEPCAO ;               cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/NfeRecepcao2.asmx"
      CASE nWsService == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/eventosWEB/services/RecepcaoEvento.asmx"
      CASE nWsService == WSNFERETRECEPCAO ;            cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/NfeRetRecepcao2.asmx"
      CASE nWsService == WSNFESTATUSSERVICO ;          cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/NfeStatusServico2.asmx"
      ENDCASE

   CASE cUf == "SVAN" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;         cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeCancelamento2/NfeCancelamento2.asmx"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;    cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx"
      CASE nWsService == WSNFEINUTILIZACAO ;         cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx"
      CASE nWsService == WSNFERECEPCAO ;             cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx"
      CASE nWsService == WSNFERECEPCAOEVENTO ;       cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx"
      CASE nWsService == WSNFERETRECEPCAO ;          cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx"
      CASE nWsService == WSNFESTATUSSERVICO ;        cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx"
      ENDCASE

   CASE cUf == "SVAN" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;         cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeCancelamento2/NfeCancelamento2.asmx"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;    cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx"
      CASE nWsService == WSNFEDOWNLOADNF ;           cUrlWs := "https://hom.nfe.fazenda.gov.br/nfedownloadnf/nfedownloadnf.asmx"
      CASE nWsService == WSNFEINUTILIZACAO ;         cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx"
      CASE nWsService == WSNFERECEPCAO ;             cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx"
      CASE nWsService == WSNFERECEPCAOEVENTO ;       cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx"
      CASE nWsService == WSNFERETRECEPCAO ;          cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx"
      CASE nWsService == WSNFESTATUSSERVICO ;        cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx"
      ENDCASE

   CASE cUf == "SVRS" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;         cUrlWs := "https://nfe.sefazvirtual.rs.gov.br/ws/NfeCancelamento/NfeCancelamento2.asmx"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;    cUrlWs := "https://nfe.sefazvirtual.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx"
      CASE nWsService == WSNFEINUTILIZACAO ;         cUrlWs := "https://nfe.sefazvirtual.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx"
      CASE nWsService == WSNFERECEPCAO ;             cUrlWs := "https://nfe.sefazvirtual.rs.gov.br/ws/Nferecepcao/NFeRecepcao2.asmx"
      CASE nWsService == WSNFERECEPCAOEVENTO ;       cUrlWs := "https://nfe.sefazvirtual.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx"
      CASE nWsService == WSNFERETRECEPCAO ;          cUrlWs := "https://nfe.sefazvirtual.rs.gov.br/ws/NfeRetRecepcao/NfeRetRecepcao2.asmx"
      CASE nWsService == WSNFESTATUSSERVICO ;        cUrlWs := "https://nfe.sefazvirtual.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx"
      ENDCASE

   CASE cUf == "SVRS" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;         cUrlWs := "https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/NfeCancelamento/NfeCancelamento2.asmx"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;    cUrlWs := "https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx"
      CASE nWsService == WSNFEINUTILIZACAO ;         cUrlWs := "https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx"
      CASE nWsService == WSNFERECEPCAO ;             cUrlWs := "https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/Nferecepcao/NFeRecepcao2.asmx"
      CASE nWsService == WSNFERECEPCAOEVENTO ;       cUrlWs := "https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx"
      CASE nWsService == WSNFERETRECEPCAO ;          cUrlWs := "https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/NfeRetRecepcao/NfeRetRecepcao2.asmx"
      CASE nWsService == WSNFESTATUSSERVICO ;        cUrlWs := "https://homologacao.nfe.sefazvirtual.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx"
      ENDCASE

   CASE cUf == "SCAN" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;         cUrlWs := "https://www.scan.fazenda.gov.br/NfeCancelamento2/NfeCancelamento2.asmx"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;    cUrlWs := "https://www.scan.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx"
      CASE nWsService == WSNFEINUTILIZACAO ;         cUrlWs := "https://www.scan.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx"
      CASE nWsService == WSNFERECEPCAO ;             cUrlWs := "https://www.scan.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx"
      CASE nWsService == WSNFERETRECEPCAO ;          cUrlWs := "https://www.scan.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx"
      CASE nWsService == WSNFESTATUSSERVICO ;        cUrlWs := "https://www.scan.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx"
      ENDCASE

   CASE cUf == "SCAN" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsService == WSNFECANCELAMENTO ;         cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeCancelamento2/NfeCancelamento2.asmx"
      CASE nWsService == WSNFECONSULTAPROTOCOLO ;    cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeConsulta2/NfeConsulta2.asmx"
      CASE nWsService == WSNFEINUTILIZACAO ;         cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeInutilizacao2/NfeInutilizacao2.asmx"
      CASE nWsService == WSNFERECEPCAO ;             cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeRecepcao2/NfeRecepcao2.asmx"
      CASE nWsService == WSNFERETRECEPCAO ;          cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeRetRecepcao2/NfeRetRecepcao2.asmx"
      CASE nWsService == WSNFESTATUSSERVICO ;        cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeStatusServico2/NfeStatusServico2.asmx"
      ENDCASE

   ENDCASE
   RETURN cUrlWs
