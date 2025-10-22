#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeEventoDataEntrega( Self, cChave, cCnpj, cCodigoEvento, ;
   dData, cAutor, cVerAplic, cCertificado, cAmbiente )

   LOCAL cDescEvento

   hb_Default( @cCnpj, Replicate( "0", 14 ) )
   hb_Default( @cAutor, "1" )
   hb_Default( @cVerAplic, "1.00" )
   ::cUF := "AN"

   cDescEvento := "Atualizacao da Data de Previsao de Entrega"

   ::cXmlDocumento += [<detEvento versao="1.00">]
   ::cXmlDocumento +=    XmlTag( "descEvento", cDescEvento )
   ::cXmlDocumento +=    XmlTag( "cOrgaoAutor", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=    XmlTag( "tpAutor", @cAutor )
   // 1-emitente,2-dest,3-empresa,5-fisco,6-RFB,9-Outros
   ::cXmlDocumento +=    XmlTag( "verAplic", cVerAplic )
   ::cXmlDocumento +=    XmlTag( "dPrevEntrega", XmlDate( dData ) )
   ::cXmlDocumento +=  [</detEvento>]
   ::NFeEvento( cChave, 1, cCodigoEvento, ::cXmlDocumento, cCertificado, cAmbiente, cCnpj )

   RETURN ::cXmlRetorno
