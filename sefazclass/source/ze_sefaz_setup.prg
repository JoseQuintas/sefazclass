#include "sefazclass.ch"

FUNCTION ze_sefaz_Setup( Self, cUF, cCertificado, cAmbiente, lEnvioSinc )

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
      OTHERWISE
         ::cSoapUrl := SoapUrlCTe( ::aSoapUrlList, cUF, cVersao, ::lContingencia )
      ENDCASE
   CASE cProjeto == WS_PROJETO_MDFE
      ::cSoapURL := SoapURLMDFe( ::aSoapUrlList, "SVRS", cVersao )
   CASE cProjeto == WS_PROJETO_NFE
      IF lConsumidor
         ::cSoapUrl := SoapUrlNFCe( ::aSoapUrlList, cUF, cVersao )
      ELSE
         ::cSoapUrl := SoapUrlNfe( ::aSoapUrlList, cUF, cVersao, ::lContingencia )
      ENDIF
   ENDCASE

   RETURN NIL

STATIC FUNCTION SoapUrlBpe( aList, cUF, cVersao )

   LOCAL nPos, cUrl

   nPos := hb_AScan( aList, { | e | cUF == e[ 1 ] .AND. cVersao == e[ 2 ] } )
   IF nPos != 0
      cUrl := aList[ nPos, 3 ]
   ENDIF

   RETURN cUrl

STATIC FUNCTION SoapUrlCte( aList, cUF, cVersao, lContingencia )

   LOCAL nPos, cUrl

   hb_Default( @lContingencia, .F. )
   IF lContingencia
      IF cUF $ "MG,PR,RS," + "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,RS,SC,SE,TO"
         cURL := SoapURLCTe( aList, "SVSP", cVersao )
         IF Empty( cUrl )
            cURL := SoapURLCTe( aList, "SP", cVersao )
         ENDIF
      ELSEIF cUF $ "MS,MT,SP," + "AP,PE,RR"
         cURL := SoapUrlCTe( aList, "SVRS", cVersao )
         IF Empty( cUrl )
            cURL := SoapUrlCTe( aList, "RS", cVersao )
         ENDIF
      ENDIF
   ELSE
      nPos := hb_AScan( aList, { | e | cUF == e[ 1 ] .AND. cVersao == e[ 2 ] } )
      IF nPos != 0
         cUrl := aList[ nPos, 3 ]
      ELSE
         IF cUF $ "AP,PE,RR"
            cUrl := SoapUrlCTe( aList, "SVSP", cVersao )
            IF Empty( cUrl )
               cUrl := SoapUrlCte( aList, "SP", cVersao )
            ENDIF
         ELSEIF cUF $ "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,RS,SC,SE,TO"
            cUrl := SoapUrlCTe( aList, "SVRS", cVersao )
            IF Empty( cUrl )
               cUrl := SoapUrlCTe( aList, "RS", cVersao )
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   RETURN cUrl

STATIC FUNCTION SoapUrlMdfe( aList, cUF, cVersao )

   LOCAL cUrl, nPos

   nPos := hb_AScan( aList, { | e | cVersao == e[ 2 ] } )
   IF nPos != 0
      cUrl := aList[ nPos, 3 ]
   ENDIF
   HB_SYMBOL_UNUSED( cUF )

   RETURN cUrl

STATIC FUNCTION SoapUrlNfe( aList, cUF, cVersao, lContingencia )

   LOCAL nPos, cUrl

   hb_Default( @lContingencia, .F. )

   IF lContingencia
      DO CASE
      CASE cUF $ "AN,AC,AL,AP,CE,DF,ES,MG,,PA,PB,PI,RJ,RN,RO,RR,RS,SC,SE,SP,TO"
         cUrl := SoapUrlNfe( aList, "SVCAN", cVersao )
      CASE cUF $ "AM,BA,GO,MA,MS,MT,PE,PR"
         cUrl := SoapUrlNfe( aList, "SVCRS", cVersao )
      ENDCASE
   ELSE
      nPos := hb_AScan( aList, { | e | ( cUF == e[ 1 ] .OR. e[ 1 ] == "**" ) .AND. cVersao == e[ 2 ] } )
      IF nPos != 0
         cUrl := aList[ nPos, 3 ]
      ELSE
         DO CASE
         CASE cUF $ "MA"
            cUrl := SoapUrlNFe( aList, "SVAN", cVersao, lContingencia )
         CASE cUF $ "AC,AL,AP,CE,DF,ES,PA,PB,PI,RJ,RN,RO,RR,SC,SE,TO"
            cURL := SoapURLNFe( aList, "SVRS", cVersao, lContingencia )
         ENDCASE
      ENDIF
   ENDIF

   RETURN cUrl

STATIC FUNCTION SoapUrlNFCe( aList, cUf, cVersao )

   LOCAL cUrl, nPos

   nPos := hb_AScan( aList, { | e | cUF == e[ 1 ] .AND. cVersao + "C" == e[ 2 ] } )
   IF nPos != 0
      cUrl := aList[ nPos, 3 ]
   ELSE
      IF cUF $ "AC,ES,RO,RR"
         cUrl := SoapUrlNFCe( aList, "SVRS", cVersao  )
      ENDIF
   ENDIF
   IF Empty( cUrl )
      cUrl := SoapUrlNFe( aList, cUF, cVersao ) // tenta NFE normal
   ENDIF

   RETURN cUrl

