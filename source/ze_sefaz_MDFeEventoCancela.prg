#include "sefazclass.ch"

FUNCTION ze_sefaz_MDFeEventoCancela( Self, cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente )

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evCancMDFe>]
   cXml +=       XmlTag( "descEvento", "Cancelamento" )
   cXml +=       XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=       XmlTag( "xJust", xJust )
   cXml +=    [</evCancMDFe>]
   cXml += [</detEvento>]

   ::MDFeEvento( cChave, nSequencia, "110111", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

