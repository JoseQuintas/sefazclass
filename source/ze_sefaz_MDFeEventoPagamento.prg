#include "sefazclass.ch"

FUNCTION ze_sefaz_MDFeEventoPagamento( Self, cChave, nSequencia, cXmlPagamento, cCertificado, cAmbiente )

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml += cXmlPagamento
   cXml += [</detEvento>]

   ::MDFeEvento( cChave, nSequencia, "110116", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

