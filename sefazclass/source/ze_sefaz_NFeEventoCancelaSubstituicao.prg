#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeEventoCancelaSubstituicao( Self, cChave, cOrgaoAutor, cAutor, cVersaoAplicativo, cProtocolo, cJust, cNFRef, cCertificado, cAmbiente )

   LOCAL cXml := "", nSequencia := 1

   cXml += [<detEvento versao="1.00">]
   cXml +=    XmlTag( "descEvento", "Cancelamento por substituicao" ) // acentos?
   cXml +=    XmlTag( "cOrgaoAutor", cOrgaoAutor )
   cXml +=    XmlTag( "tpAutor", cAutor )
   cXml +=    XmlTag( "verAplic", cVersaoAplicativo )
   cXml +=    XmlTag( "nProt", cProtocolo )
   cXml +=    XmlTag( "xJust", cJust )
   cXml +=    XmlTag( "chNFeRef", cNfRef )
   cXml += [</detEvento>]

   ::NFeEvento( cChave, nSequencia, "110112", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

