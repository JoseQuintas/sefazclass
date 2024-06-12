#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeRetEnvio( Self, cRecibo, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::cProjeto := WS_PROJETO_CTE
   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF
   ::aSoapUrlList := SoapList()
   ::Setup( cUF, cCertificado, cAmbiente )

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

STATIC FUNCTION SoapList()

RETURN { ;
   ;
   { "MG",      "3.00H", "https://hcte.fazenda.mg.gov.br/cte/services/CteRetRecepcao", "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao/cteRetRecepcao" }, ;
   { "MS",      "3.00H", "https://homologacao.cte.ms.gov.br/ws/CteRetRecepcao", "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao/cteRetRecepcao" }, ;
   { "MT",      "3.00H", "https://homologacao.sefaz.mt.gov.br/ctews/services/CteRetRecepcao", "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao/cteRetRecepcao" }, ;
   { "PR",      "3.00H", "https://homologacao.cte.fazenda.pr.gov.br/cte/CteRetRecepcao", "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao/cteRetRecepcao" }, ;
   { "RS/SVRS", "3.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/cteretrecepcao/cteRetRecepcao.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao/cteRetRecepcao" }, ;
   { "SP/SVSP", "3.00H", "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteRetRecepcao.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao/cteRetRecepcao" }, ;
   ;
   { "MG",      "3.00P", "https://cte.fazenda.mg.gov.br/cte/services/CteRetRecepcao", "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao/cteRetRecepcao" }, ;
   { "MS",      "3.00P", "https://producao.cte.ms.gov.br/ws/CteRetRecepcao", "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao/cteRetRecepcao" }, ;
   { "MT",      "3.00P", "https://cte.sefaz.mt.gov.br/ctews/services/CteRetRecepcao", "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao/cteRetRecepcao" }, ;
   { "PR",      "3.00P", "https://cte.fazenda.pr.gov.br/cte/CteRetRecepcao", "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao/cteRetRecepcao" }, ;
   { "RS/SVRS", "3.00P", "https://cte.svrs.rs.gov.br/ws/cteretrecepcao/cteRetRecepcao.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao/cteRetRecepcao" }, ;
   { "SP/SVSP", "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRetRecepcao.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao/cteRetRecepcao" } }
