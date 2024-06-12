#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeEventoCancela( Self, cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente )

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evCancCTe>]
   cXml +=       XmlTag( "descEvento", "Cancelamento" )
   cXml +=       XmlTag( "nProt", Ltrim( Str( nProt, 16 ) ) )
   cXml +=       XmlTag( "xJust", xJust )
   cXml +=    [</evCancCTe>]
   cXml += [</detEvento>]

   ::CTeEvento( cChave, nSequencia, "110111", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

