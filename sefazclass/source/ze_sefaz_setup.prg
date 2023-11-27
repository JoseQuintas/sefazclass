#include "sefazclass.ch"

FUNCTION ze_sefaz_Setup( Self, cUF, cCertificado, cAmbiente, lEnvioSinc, lEnvioZip )

   LOCAL cProjeto, lConsumidor, cScan, cVersao

   IF cCertificado != Nil
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != Nil
      ::cAmbiente := cAmbiente
   ENDIF
   IF lEnvioSinc != Nil
      IF ValType( lEnvioSinc ) == "L"
         ::lEnvioSinc := lEnvioSinc
      ELSEIF ValType( lEnvioSinc ) == "C"
         ::lEnvioSinc := ( lEnvioSinc == "1" )
      ENDIF
   ENDIF
   IF lEnvioZip != Nil
      IF ValType( lEnvioZip ) == "L"
         ::lEnvioZip := lEnvioZip
      ENDIF
   ENDIF

   DO CASE
   CASE cUF == NIL
   CASE Len( SoNumeros( cUF ) ) != 0
      ::cUF := ::UFSigla( Left( cUF, 2 ) )
   OTHERWISE
      ::cUF := cUF
   ENDCASE
   ::cSoapURL    := ""
   cAmbiente     := ::cAmbiente
   cUF           := ::cUF
   cProjeto      := ::cProjeto
   lConsumidor   := ::lConsumidor
   cScan         := ::cScan
   cVersao       := ::cVersao + iif( cAmbiente == WS_AMBIENTE_PRODUCAO, "P", "H" )
   DO CASE
   CASE cProjeto == WS_PROJETO_BPE
      ::cSoapUrl := SoapUrlBpe( ::aSoapUrlList, cUF, cVersao )
   CASE cProjeto == WS_PROJETO_CTE
      DO CASE
      CASE cSCan == "SVCAN" .AND. cUF $ "MG,PR,RS," + "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,RS,SC,SE,TO"
         ::cSoapURL := SoapURLCTe( ::aSoapUrlList, "SVSP", cVersao ) // SVC_SP não existe
      CASE cScan == "SVCAN" .AND. cUF $ "MS,MT,SP," + "AP,PE,RR"
         ::cSoapURL := SoapUrlCTe( ::aSoapUrlList, "SVRS", cVersao ) // SVC_RS não existe
      CASE ::lContingencia
      OTHERWISE
         ::cSoapUrl := SoapUrlCTe( ::aSoapUrlList, cUF, cVersao )
      ENDCASE
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
      CASE cScan == "SVCAN" .AND. cUF $ "AM,BA,CE,GO,MA,MS,MT,PA,PE,PI,PR"
         ::cSoapURL := ::SoapURLNfe( ::aSoapUrlList, "SVCRS", cVersao )
      CASE cScan == "SVCAN"
         ::cSoapURL := ::SoapUrlNFe( ::aSoapUrlList, "SVCAN", cVersao )
      OTHERWISE
         IF ::lContingencia
            DO CASE
            CASE cUF $ "AN," + "AC,AL,AP,CE,DF,ES,MG,,PA,PB,PI,RJ,RN,RO,RR,RS,SC,SE,SP,TO"
               ::cSoapUrl := ::SoapUrlNfe( ::aSoapUrlList, "SVCAN", cVersao )
            CASE cUF $ "AM,BA,GO,MA,MS,MT,PE,PR"
               ::cSoapUrl := ::SoapUrlNfe( ::aSoapUrlList, "SVCRS", cVersao )
            ENDCASE
         ELSE
            ::cSoapUrl := ::SoapUrlNfe( ::aSoapUrlList, cUF, cVersao )
            IF Empty( ::cSoapUrl )
               DO CASE
               CASE cUF $ "MA"
                  ::cSoapUrl := ::SoapUrlNFe( ::aSoapUrlList, "SVAN", cVersao )
               CASE cUF $ "AC,AL,AP,CE,DF,ES,PA,PB,PI,RJ,RN,RO,RR,SC,SE,TO"
                  ::cSoapUrl := ::SoapUrlNFe( ::aSoapUrlList, "SVRS", cVersao )
               ENDCASE
            ENDIF
         ENDIF
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
