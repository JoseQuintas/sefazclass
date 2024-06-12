#include "sefazclass.ch"

FUNCTION ze_sefaz_MDFeEventoEncerramento( Self, cChave, nSequencia, nProt, cUFFim , cMunCarrega , cCertificado, cAmbiente )

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evEncMDFe>]
   cXml +=       XmlTag( "descEvento", "Encerramento" )
   cXml +=       XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=       XmlTag( "dtEnc", DateXml( Date() ) )
   cXml +=       XmlTag( "cUF", ::UFCodigo( cUFFim ) )
   cXml +=       XmlTag( "cMun", cMunCarrega )
   cXml +=    [</evEncMDFe>]
   cXml += [</detEvento>]

   ::MDFeEvento( cChave, nSequencia, "110112", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

