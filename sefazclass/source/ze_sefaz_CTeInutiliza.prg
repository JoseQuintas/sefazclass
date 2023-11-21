#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeInutiliza( Self, cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::cProjeto := WS_PROJETO_CTE
   ::aSoapUrlList := SoapList()
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "http://www.portalfiscal.inf.br/cte/wsdl/CteInutilizacao/cteInutilizacaoCT"
   cCnpj := SoNumeros( cCnpj )

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
   ::cXmlDocumento +=       XmlTag( iif( Len( cCnpj ) == 11, "CPF", "CNPJ" ), cCnpj )
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

STATIC FUNCTION SoapList()

RETURN { ;
   ;
   { "MG",   "3.00P", "https://cte.fazenda.mg.gov.br/cte/services/CteInutilizacao" }, ;
   { "MS",   "3.00P", "https://producao.cte.ms.gov.br/ws/CteInutilizacao" }, ;
   { "MT",   "3.00P", "https://cte.sefaz.mt.gov.br/ctews/services/CteInutilizacao" }, ;
   { "PR",   "3.00P", "https://cte.fazenda.pr.gov.br/cte/CteInutilizacao" }, ;
   { "SP",   "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteInutilizacao.asmx" }, ;
   { "SVRS", "3.00P", "https://cte.svrs.rs.gov.br/ws/cteinutilizacao/cteinutilizacao.asmx" }, ;
   ;
   { "SP",   "3.00H", "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteInutilizacao.asmx" }, ;
   { "PR",   "3.00H", "https://homologacao.cte.fazenda.pr.gov.br/cte/CteInutilizacao" }, ;
   { "SVRS", "3.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/cteinutilizacao/cteinutilizacao.asmx" } }

