#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeProtocolo( Self, cChave, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::cProjeto := WS_PROJETO_CTE
   ::aSoapUrlList := WS_CTE_CONSULTAPROTOCOLO
   ::Setup( cChave, cCertificado, cAmbiente )
   IF ::cVersao == "3.00"
      ::cSoapAction := "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta/cteConsultaCT"
   ELSE
      ::cSoapAction := "http://www.portalfiscal.inf.br/cte/wsdl/CTeConsultaV4/cteConsultaCT"
   ENDIF

   ::cXmlEnvio    := [<consSitCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio    +=    XmlTag( "chCTe", cChave )
   ::cXmlEnvio    += [</consSitCTe>]
   IF ! DfeModFis( cChave ) $ "57,67"
      ::cXmlRetorno := [<erro text="*ERRO* CteProtocolo() Chave não se refere a CTE" />]
   ELSE
      ::XmlSoapPost()
   ENDIF
   IF ::cStatus != "999"
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno
