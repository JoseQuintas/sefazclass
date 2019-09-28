/*
ZE_SPEDSSINACHK - Checagem de assinatura
José Quintas
*/

#ifdef __XHARBOUR__
   #include "hb2xhb.ch"
#endif
#define DSIGNS "xmlns:ds='http://www.w3.org/2000/09/xmldsig#'"

FUNCTION ChkSignature( cXml, cCertificadoCN )

   LOCAL XmlDoc, XmlDSig, cXmlRetorno := "Undefined Error"
   LOCAL oKeyInfo, oPubKey, oVerifiedKey, oSignature, oCapicomChain

   BEGIN SEQUENCE WITH __BreakBlock()

      XmlDoc        := win_OleCreateObject( "MSXML2.DOMDocument.5.0" )
      XmlDSig       := win_OleCreateObject( "MSXML2.MXDigitalSignature.5.0" )
      oCapicomChain := Win_OleCreateObject( "CAPICOM.Chain" )

      XmlDoc:Async              := .F.
      XmlDoc:PreserveWhiteSpace := .T.
      XmlDoc:ValidateOnParse    := .F.
      XmlDoc:ResolveExternals   := .F.

      IF ! XmlDoc:LoadXml( cXml )
         cXmlRetorno := "Cannot load file. reason " + XmlDoc:ParseError:Reason
         BREAK
      ENDIF
      XmlDoc:SetProperty( "SelectionNamespaces", DSIGNS )
      oSignature := XmlDoc:SelectSingleNode( ".//ds:Signature" )
      IF oSignature == NIL
         cXmlRetorno := "Not Found Signature"
         BREAK
      ENDIF
      XmlDSig:Signature := oSignature
      oKeyInfo := XmlDoc:selectSingleNode( ".//ds:KeyInfo/ds:X509Data" )
      IF oKeyInfo == NIL
         cXmlRetorno := "Invalid <KeyInfo> Element"
         BREAK
      ENDIF
      oPubKey := XmlDSig:CreateKeyFromNode( oKeyInfo )
      IF oPubKey == NIL
         cXmlRetorno := "Cannot generate public key for verification"
         BREAK
      ENDIF
      cXmlRetorno := "Invalid Signature"
      oVerifiedKey := XmlDSig:Verify( oPubKey )
      IF oVerifiedKey == NIL
         cXmlRetorno := "Signature not verified"
         BREAK
      ENDIF
      cXmlRetorno := "OK"

   ENDSEQUENCE
   IF cXmlRetorno == "OK" // pelo temo que demora, melhor não usar
      oCapicomChain:Build( oVerifiedKey:GetVerifyingCertificate )
      cCertificadoCN := oCapicomChain:Certificates[ 1 ]:SubjectName()
      //FOR oCert = 1 TO Len( oCapicomChain:Certificates )
      //   SayScroll( "subject:" + oCapicomChain:Certificates[ oCert ]:SubjectName() ) // + " " + oCapicomChain:Certificates[ oCert ]:IssuerName() )
      //NEXT
   ENDIF
   HB_SYMBOL_UNUSED( cCertificadoCN )

   RETURN cXmlRetorno
