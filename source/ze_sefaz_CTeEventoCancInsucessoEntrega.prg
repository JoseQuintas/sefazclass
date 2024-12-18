#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeEventoCancInsucessoEntrega( Self, cChave, nSequencia, nProt, nProtEntrega, cCertificado, cAmbiente )

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evCancIECTe>]
   cXml +=       XmlTag( "descEvento", "Cancelamento do Insucesso de Entrega do CT-e" )
   cXml +=       XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=       XmlTag( "nProtIE", LTrim( Str( nProtEntrega ) ) )
   cXml +=    [</evCancIECTe>]
   cXml += [</detEvento>]

   ::CTeEvento( cChave, nSequencia, "110191", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno
