#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeEventoInsucessoEntrega( Self, cChave, nSequencia, nProt, ;
   dDataEntrega, cHoraEntrega, nTentativa, cMotivo, cJustificativa, nLatitude, ;
   nLongitude, cStrImagem, aChaveNfeList, cCertificado, cAmbiente )

   LOCAL cChaveNfe, cXml := "", cHash

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   cHash := hb_Sha1( cChave + hb_Base64Encode( cStrImagem ), .T. )
   cHash := hb_Base64Encode( cHash )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evIECTe>]
   cXml +=       XmlTag( "descEvento", "Insucesso na Entrega do CT-e" )
   cXml +=       XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=       XmlTag( "dhTentativaEntrega", DateTimeXml( dDataEntrega, cHoraEntrega, ::cUF ) )
   cXml +=       XmlTag( "nTentativa", StrZero( nTentativa, 3 ) )
   cXml +=       XmlTag( "tpMotivo", Ltrim( cMotivo ) )

   if Alltrim(cMotivo) == '4'
      cXml +=    XmlTag( "xJustMotivo", Ltrim( cJustificativa ) )
   endif

   IF nLatitude != 0 .AND. nLongitude != 0
      cXml +=    XmlTag( "latitude", NumberXml( nLatitude, 16, 6 ) )
      cXml +=    XmlTag( "longitude", NumberXml( nLongitude, 16, 6 ) )
   ENDIF

   cXml +=    XmlTag( "hashTentativaEntrega", cHash )
   cXml +=    XmlTag( "dhHashTentativaEntrega", DateTimeXml( Date(), Time(), ::cUF ) )

   FOR EACH cChaveNfe IN aChaveNfeList
      cXml +=    "<infEntrega>"
      cXml +=    XmlTag( "chNFe", cChaveNfe )
      cXml +=    "</infEntrega>"
   NEXT

   cXml +=    [</evIECTe>]
   cXml += [</detEvento>]

   ::CTeEvento( cChave, nSequencia, "110190", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

