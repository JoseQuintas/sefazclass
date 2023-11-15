#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeEventoCancela( Self, cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente )

   LOCAL cXml := ""

   cXml += [<detEvento versao="1.00">]
   cXml +=    XmlTag( "descEvento", "Cancelamento" )
   cXml +=    XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=    XmlTag( "xJust", xJust )
   cXml += [</detEvento>]

   ::NFeEvento( cChave, nSequencia, "110111", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

