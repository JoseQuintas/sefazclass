#include "sefazclass.ch"

FUNCTION ze_sefaz_Setup( Self, cUF, cCertificado, cAmbiente ) // , lContingencia, lSincrono, lZip )

   LOCAL cProjeto, lConsumidor, cScan, cVersao

   IF cCertificado != Nil
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != Nil
      ::cAmbiente := cAmbiente
   ENDIF
   //IF lContingencia != Nil
   //   ::lContingencia := lContingencia
   //ENDIF
   //IF lSincrono != Nil
   //   ::lSincrono := lSincrono
   //ENDIF
   //hb_Default( @lZip, .F. )
   DO CASE
   CASE cUF == NIL
   CASE Len( SoNumeros( cUF ) ) != 0
      ::cUF := ::UFSigla( Left( cUF, 2 ) )
   OTHERWISE
      ::cUF := cUF
   ENDCASE
   ::cSoapURL := ""
   cAmbiente  := ::cAmbiente
   cUF        := ::cUF
   cProjeto   := ::cProjeto
   lConsumidor := ::lConsumidor
   cScan      := ::cScan
   cVersao    := ::cVersao + iif( cAmbiente == WS_AMBIENTE_PRODUCAO, "P", "H" )
   DO CASE
   CASE cProjeto == WS_PROJETO_BPE
      ::cSoapUrl := SoapUrlBpe( ::aSoapUrlList, cUF, cVersao )
   CASE cProjeto == WS_PROJETO_CTE
      IF cScan == "SVCAN"
         IF cUF $ "MG,PR,RS," + "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,RS,SC,SE,TO"
            ::cSoapURL := SoapURLCTe( ::aSoapUrlList, "SVSP", cVersao ) // SVC_SP não existe
         ELSEIF cUF $ "MS,MT,SP," + "AP,PE,RR"
            ::cSoapURL := SoapUrlCTe( ::aSoapUrlList, "SVRS", cVersao ) // SVC_RS não existe
         ENDIF
      ELSE
         ::cSoapUrl := SoapUrlCTe( ::aSoapUrlList, cUF, cVersao )
      ENDIF
   CASE cProjeto == WS_PROJETO_MDFE
      ::cSoapURL := SoapURLMDFe( ::aSoapUrlList, "SVRS", cVersao )
   CASE cProjeto == WS_PROJETO_NFE
      DO CASE
      CASE lConsumidor
         ::cSoapUrl := ::SoapUrlNFCe( ::aSoapUrlList, cUF, cVersao )
         IF Empty( ::cSoapUrl )
            ::cSoapUrl := ::SoapUrlNfe( ::aSoapUrlList, cUF, cVersao )
         ENDIF
      CASE cScan == "SCAN"
         ::cSoapURL := ::SoapUrlNFe( ::aSoapUrlList, "SCAN", cVersao )
      CASE cScan == "SVAN"
         ::cSoapUrl := ::SoapUrlNFe( ::aSoapUrlList, "SVAN", cVersao )
      CASE cScan == "SVCAN"
         IF cUF $ "AM,BA,CE,GO,MA,MS,MT,PA,PE,PI,PR"
            ::cSoapURL := ::SoapURLNfe( ::aSoapUrlList, "SVCRS", cVersao )
         ELSE
            ::cSoapURL := ::SoapUrlNFe( ::aSoapUrlList, "SVCAN", cVersao )
         ENDIF
      OTHERWISE
         ::cSoapUrl := ::SoapUrlNfe( ::aSoapUrlList, cUF, cVersao )
      ENDCASE
   ENDCASE

   RETURN NIL

FUNCTION SoapUrlBpe( aSoapList, cUF, cVersao )

   LOCAL nPos, cUrl

   nPos := hb_AScan( aSoapList, { | e | cUF == e[ 1 ] .AND. cVersao == e[ 2 ] } )
   IF nPos != 0
      cUrl := aSoapList[ nPos, 3 ]
   ENDIF

   RETURN cUrl

FUNCTION SoapUrlCte( aSoapList, cUF, cVersao )

   LOCAL nPos, cUrl

   hb_Default( cVersao, WS_CTE_DEFAULT )
   nPos := hb_AScan( aSoapList, { | e | cUF == e[ 1 ] .AND. cVersao == e[ 2 ] } )
   IF nPos != 0
      cUrl := aSoapList[ nPos, 3 ]
   ENDIF
   IF Empty( cUrl )
      IF cUF $ "AP,PE,RR"
         cUrl := SoapUrlCTe( aSoapList, "SVSP", cVersao )
      ELSEIF cUF $ "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,RS,SC,SE,TO"
         cUrl := SoapUrlCTe( aSoapList, "SVRS", cVersao )
      ENDIF
   ENDIF

   RETURN cUrl

FUNCTION SoapUrlMdfe( aSoapList, cUF, cVersao )

   LOCAL cUrl, nPos

   nPos := hb_AScan( aSoapList, { | e | cVersao == e[ 2 ] } )
   IF nPos != 0
      cUrl := aSoapList[ nPos, 3 ]
   ENDIF
   HB_SYMBOL_UNUSED( cUF )

   RETURN cUrl

