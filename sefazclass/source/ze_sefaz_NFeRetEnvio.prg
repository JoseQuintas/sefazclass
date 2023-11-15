#include "sefazclass.ch"

FUNCTION ze_Sefaz_NFeRetEnvio( Self, cRecibo, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF

   ::aSoapUrlList := WS_NFE_RETAUTORIZACAO
   ::Setup( cUF, cCertificado, cAmbiente )
   //mg aqui funcionou caindo nas duas condicoes
   IF ::cUF $ "MA,MS,MT,PI,GO,MG"
      ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/NFeRetAutorizacao"
    ELSE
      ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote"
   ENDIF
   ::cXmlEnvio     := [<consReciNFe versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio     +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio     +=    XmlTag( "nRec", ::cRecibo )
   ::cXmlEnvio     += [</consReciNFe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno
   IF "<infProt" $ ::cXmlRetorno
      ::cStatus := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
      ::cMotivo := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
   ELSEIF ::cStatus != "999"
      ::cMotivo       := XmlNode( ::cXmlRetorno, "xMotivo" )
      ::cStatus       := XmlNode( ::cXmlRetorno, "cStat" )
   ENDIF

   RETURN ::cXmlRetorno

