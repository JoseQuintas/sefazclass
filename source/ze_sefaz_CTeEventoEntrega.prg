#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeEventoEntrega( Self, cChave, nSequencia, nProt, dDataEntrega, cHoraEntrega, ;
   cDoc, cNome, aNfeList, nLatitude, nLongitude, cStrImagem, cCertificado, cAmbiente )

   LOCAL oElement, cXml := "", cHash

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   cHash := hb_Sha1( cChave + hb_Base64Encode( cStrImagem ), .T. )
   cHash := hb_Base64Encode( cHash )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evCECTe>]
   cXml +=       XmlTag( "descEvento", "Comprovante de Entrega do CT-e" )
   cXml +=       XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=       XmlTag( "dhEntrega", DateTimeXml( dDataEntrega, cHoraEntrega, ::cUF ) )
   cXml +=       XmlTag( "nDoc", cDoc )
   cXml +=       XmlTag( "xNome", cNome )
   IF nLatitude != 0 .AND. nLongitude != 0
      cXml +=    XmlTag( "latitude", NumberXml( nLatitude, 16, 6 ) )
      cXml +=    XmlTag( "longitude", NumberXml( nLongitude, 16, 6 ) )
   ENDIF
   cXml +=    XmlTag( "hashEntrega", cHash )
   cXml +=    XmlTag( "dhHashEntrega", DateTimeXml( Date(), Time(), ::cUF ) )
   IF Len( aNfeList ) > 0
      cXml +=    "<infEntrega>"
      FOR EACH oElement IN aNfeList
         cXml +=    XmlTag( "chNFe", oElement )
      NEXT
      cXml +=    "</infEntrega>"
   ENDIF
   cXml +=    [</evCECTe>]
   cXml += [</detEvento>]

   ::CTeEvento( cChave, nSequencia, "110180", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

