#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeEventoDesacordo( Self, cChave, nSequencia, cObs, cCertificado, cAmbiente )

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evPrestDesacordo>]
   cXml +=       XmlTag( "descEvento", "Prestacao do Servico em Desacordo" )
   cXml +=       XmlTag( "indDesacordoOper", "1" )
   cXml +=       XmlTag( "xObs", cObs )
   cXml +=    [</evPrestDesacordo>]
   cXml += [</detEvento>]

   ::CTeEvento( cChave, nSequencia, "610110", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

