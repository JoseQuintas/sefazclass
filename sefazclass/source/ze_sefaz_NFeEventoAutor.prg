#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeEventoAutor( Self, cChave, cCnpj, cOrgaoAutor, ctpAutor, cverAplic, cAutorCnpj, ctpAutorizacao, cCertificado, cAmbiente )

   LOCAL cDescEvento

   hb_Default( @cCnpj, "00000000000000" )
   ::cUF          := "AN"

   cDescEvento   := "Ator interessado na NF-e"

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
   ::NFeEvento( cChave, 1, "110150", ::cXmlDocumento, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

