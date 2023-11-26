#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeEnvio( Self, cXml, cUF, cCertificado, cAmbiente )

   LOCAL oDoc, cBlocoXml, aList, cURLConsulta := "http:", nPos

   ::cProjeto := WS_PROJETO_CTE
   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::aSoapUrlList := SoapList()
   ::Setup( cUF, cCertificado, cAmbiente )
   IF ::cVersao == "3.00"
      ::cSoapAction := "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcao/cteRecepcaoLote"
   ELSE
      ::cSoapAction := "http://www.portalfiscal.inf.br/cte/wsdl/CTeRecepcaoSincV4/cteRecepcao"
      ::lEnvioSinc := .T.
   ENDIF
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
   IF ::lEnvioSinc // 4.00 obrigatório
      ::cXmlEnvio := ::cXmlDocumento
   ELSE
      ::cXmlEnvio := [<enviCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
      ::cXmlEnvio +=    XmlTag( "idLote", "1" )
      ::cXmlEnvio += ::cXmlDocumento
      ::cXmlEnvio += [</enviCTe>]
   ENDIF
   ::XmlSoapPost()
   ::cXmlRecibo := ::cXmlRetorno
   ::cRecibo    := XmlNode( ::cXmlRecibo, "nRec" )
   ::cStatus    := Pad( XmlNode( ::cXmlRecibo, "cStatus" ), 3 )
   ::cMotivo    := XmlNode( ::cXmlRecibo, "xMotivo" )
   IF ::lEnvioSinc .OR. ( ! Empty( ::cRecibo ) .AND. ::cStatus != "999" )
      IF ::lEnvioSinc
         ::cXmlProtocolo := ::cXmlRecibo
      ELSE
         Inkey( ::nTempoEspera )
         ::CteRetEnvio()
      ENDIF
      ::CteGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo ) // runner
   ENDIF

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

   RETURN { ;
   ;
   { "MG",   "3.00P", "https://cte.fazenda.mg.gov.br/cte/services/CteRecepcao" }, ;
   { "MS",   "3.00P", "https://producao.cte.ms.gov.br/ws/CteRecepcao" }, ;
   { "MT",   "3.00P", "https://cte.sefaz.mt.gov.br/ctews/services/CteRecepcao" }, ;
   { "PR",   "3.00P", "https://cte.fazenda.pr.gov.br/cte/CteRecepcao" }, ;
   { "SP",   "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
   { "SVSP", "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
   { "SVRS", "3.00P", "https://cte.svrs.rs.gov.br/ws/cterecepcao/CteRecepcao.asmx" }, ;
   ;
   { "SP",   "3.00H", "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
   { "PR",   "3.00H", "https://homologacao.cte.fazenda.pr.gov.br/cte/CteRecepcao" }, ;
   { "SVRS", "3.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/cterecepcao/CteRecepcao.asmx" }, ;
   ;
   { "SP",   "4.00P", "https://nfe.fazenda.sp.gov.br/CTeWS/WS/CTeRecepcaoSincV4.asmx" }, ;
   { "PR",   "4.00P", "https://cte.fazenda.pr.gov.br/cte4/CTeRecepcaoSincV4" }, ;
   ;
   { "SP",   "4.00H", "https://homologacao.nfe.fazenda.sp.gov.br/CTeWS/WS/CTeRecepcaoSincV4.asmx" }, ;
   { "PR",   "4.00H", "https://homologacao.cte.fazenda.pr.gov.br/cte4/CTeRecepcaoSincV4" } }
