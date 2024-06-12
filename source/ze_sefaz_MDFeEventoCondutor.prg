#include "sefazclass.ch"

FUNCTION ze_sefaz_MDFeEventoCondutor( Self, cChave, nSequencia, cNome, cCpf, cCertificado, cAmbiente )

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evIncCondutorMDFe>]
   cXml +=       XmlTag( "descEvento", "Inclusao Condutor" )
   cXml +=       [<condutor>]
   cXml +=          XmlTag( "xNome", cNome )
   cXml +=          XmlTag( "CPF", cCPF)
   cXml +=       [</condutor>]
   cXml +=    [</evIncCondutorMDFe>]
   cXml += [</detEvento>]

   ::MDFeEvento( cChave, nSequencia, "110114", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

