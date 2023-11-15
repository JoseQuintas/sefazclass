#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeEventoAutor( Self, cChave, cCnpj, cOrgaoAutor, ctpAutor, cverAplic, cAutorCnpj, ctpAutorizacao, cCertificado, cAmbiente )

   LOCAL cDescEvento

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
   hb_Default( @cCnpj, "00000000000000" )
   ::cNFCe := iif( DfeModFis( cChave ) == "65", "S", "N" )
   ::aSoapUrlList := WS_NFE_EVENTO
   ::cUF          := "AN"
   ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRecepcaoEvento4/nfeRecepcaoEventoNF"
   ::Setup( "AN", cCertificado, cAmbiente )

   cDescEvento := "Ator interessado na NF-e"
   cCnpj := DfeEmitente( cChave )

   ::cXmlDocumento := [<evento versao="1.00" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110150] + cChave + "01" + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", "91" )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( iif( Len( cCnpj ) == 11, "CPF", "CNPJ" ), cCnpj )
   ::cXmlDocumento +=       XmlTag( "chNFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110150" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", "1" ) // obrigatoriamente 1
   ::cXmlDocumento +=       XmlTag( "verEvento", "1.00" )
   ::cXmlDocumento +=       [<detEvento versao="1.00">]
   ::cXmlDocumento +=          XmlTag( "descEvento", cDescEvento )
   ::cXmlDocumento +=          XmlTag( "cOrgaoAutor", cOrgaoAutor )
   ::cXmlDocumento +=          XmlTag( "tpAutor", ctpAutor ) // 1-Emitente, 2=Destinat, 3=Transp
   ::cXmlDocumento +=          XmlTag( "verAplic", cverAplic ) // versao aplicativo
   ::cXmlDocumento +=          [<autXML>]
   ::cXmlDocumento +=          XmlTag( iif( Len( cAutorCnpj ) == 11, "CPF", "CNPJ" ), cAutorCnpj )
   ::cXmlDocumento +=          XmlTag( "tpAutorizacao", ctpAutorizacao ) // 0=direto, 1=permite autorizar outros
   IF ctpAutorizacao == "1"
      ::cXmlDocumento +=       XmlTag( "xCondUso", "O emitente ou destinatario" + ;
         " da NF-e, declara que permite o transportador declarado no campo CNPJ/CPF" + ;
         " deste evento a autorizar os transportes subcontratados ou redespachados" + ;
         " a terem acesso ao download da NF-e" )
   ENDIF
   ::cXmlDocumento +=          [</autXML>]
   ::cXmlDocumento +=       [</detEvento>]
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</evento>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := [<envEvento versao="1.00" ] + WS_XMLNS_NFE + [>]
      ::cXmlEnvio +=    XmlTag( "idLote", DfeNumero( cChave ) ) // usado numero da nota
      ::cXmlEnvio +=    ::cXmlDocumento
      ::cXmlEnvio += [</envEvento>]
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::NFeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

