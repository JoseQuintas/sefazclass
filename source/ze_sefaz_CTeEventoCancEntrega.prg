#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeEventoCancEntrega( Self, cChave, nSequencia, nProt, nProtEntrega, cCertificado, cAmbiente )

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evCancCECTe>]
   cXml +=       XmlTag( "descEvento", "Cancelamento do Comprovante de Entrega do CT-e" )
   cXml +=       XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=       XmlTag( "nProtCE", LTrim( Str( nProtEntrega ) ) )
   cXml +=    [</evCancCECTe>]
   cXml += [</detEvento>]

   ::CTeEvento( cChave, nSequencia, "110181", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

