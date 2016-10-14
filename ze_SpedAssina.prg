/*
ZE_SPEDASSINA - ASSINATURA SPED

2016.07.07.1230 - Apenas formatação
*/

#define _CAPICOM_STORE_OPEN_READ_ONLY                 0           // Somente Smart Card em Modo de Leitura

#define _CAPICOM_MEMORY_STORE                         0
#define _CAPICOM_LOCAL_MACHINE_STORE                  1
#define _CAPICOM_CURRENT_USER_STORE                   2
#define _CAPICOM_ACTIVE_DIRECTORY_USER_STORE          3
#define _CAPICOM_SMART_CARD_USER_STORE                4

#define _CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED           2
#define _CAPICOM_CERTIFICATE_FIND_SHA1_HASH           0           // Retorna os Dados Criptografados com Hash SH1
#define _CAPICOM_CERTIFICATE_FIND_EXTENDED_PROPERTY   6
#define _CAPICOM_CERTIFICATE_FIND_TIME_VALID          9           // Retorna Certificados Válidos
#define _CAPICOM_CERTIFICATE_FIND_KEY_USAGE           12          // Retorna Certificados que contém dados.
#define _CAPICOM_DIGITAL_SIGNATURE_KEY_USAGE          0x00000080  // Permitir o uso da Chave Privada para assinatura Digital
#define _CAPICOM_AUTHENTICATED_ATTRIBUTE_SIGNING_TIME 0           // Este atributo contém o tempo em que a assinatura foi criada.
#define _CAPICOM_INFO_SUBJECT_SIMPLE_NAME             0           // Retorna o nome de exibição do certificado.
#define _CAPICOM_ENCODE_BASE64                        0           // Os dados são guardados como uma string base64-codificado.
#define _CAPICOM_E_CANCELLED                          -2138568446 // A operação foi cancelada pelo usuário.
#define _CERT_KEY_SPEC_PROP_ID                        6
#define _CAPICOM_CERT_INFO_ISSUER_EMAIL_NAME          0
#define _SIG_KEYINFO                                  2

#include "common.ch"
#include "hbclass.ch"

FUNCTION AssinaXml( cTxtXml, cCertCN )

   LOCAL oDOMDoc, nPosIni, nPosFim, xmlHeaderAntes, xmldsig, dsigns, oCert, oCapicomStore, xmlHeaderDepois
   LOCAL XMLAssinado, SIGNEDKEY, DSIGKEY, SCONTAINER, SPROVIDER, ETYPE, cURI, nP, nResult
   LOCAL aDelimitadores, nCont, cXmlTagInicial, cXmlTagFinal, cRetorno := "Erro: Problemas pra assinar XML"

   aDelimitadores := { ;
      { "<enviMDFe",              "</MDFe></enviMDFe>" }, ;
      { "<eventoMDFe",            "</eventoMDFe>" }, ;
      { "<eventoCTe",             "</eventoCTe>" }, ;
      { "<infMDFe",               "</MDFe>" }, ;
      { "<infCte",                "</CTe>" }, ;
      { "<infNFe",                "</NFe>" }, ;
      { "<infDPEC",               "</envDPEC>" }, ;
      { "<infInut",               "<inutNFe>" }, ;
      { "<infCanc",               "</cancNFe>" }, ;
      { "<infInut",               "</inutNFe>" }, ;
      { "<infInut",               "</inutCTe>" }, ;
      { "<infEvento",             "</evento>" }, ;
      { "<infPedidoCancelamento", "</Pedido>" }, ;               // NFSE ABRASF Cancelamento
      { "<LoteRps",               "</EnviarLoteRpsEnvio>" }, ;   // NFSE ABRASF Lote
      { "<infRps",                "</Rps>" } }                   // NFSE ABRASF RPS

   // Define Tipo de Documento

   IF AT( [<Signature], cTxtXml ) <= 0
      cXmlTagInicial := ""
      cXmlTagFinal := ""
      FOR nCont = 1 TO Len( aDelimitadores )
         IF aDelimitadores[ nCont, 1 ] $ cTxtXml .AND. aDelimitadores[ nCont, 2 ] $ cTxtXml
            cXmlTagInicial := aDelimitadores[ nCont, 1 ]
            cXmlTagFinal := aDelimitadores[ nCont, 2 ]
            EXIT
         ENDIF
      NEXT
      IF Empty( cXmlTagInicial ) .OR. Empty( cXmlTagFinal )
         cRetorno := "Erro Assinatura: Não identificado documento"
         RETURN cRetorno
      ENDIF
      // Pega URI
      nPosIni := At( [Id=], cTxtXml )
      IF nPosIni = 0
         cRetorno := "Erro Assinatura: Não encontrado início do URI: Id="
         RETURN cRetorno
      ENDIF
      nPosIni := hb_At( ["], cTxtXml, nPosIni + 2 )
      IF nPosIni = 0
         cRetorno := "Erro Assinatura: Não encontrado início do URI: aspas inicial"
         RETURN cRetorno
      ENDIF
      nPosFim := hb_At( ["], cTxtXml, nPosIni + 1 )
      IF nPosFim = 0
         cRetorno := "Erro Assinatura: Não encontrado início do URI: aspas final"
         RETURN cRetorno
      ENDIF
      cURI := Substr( cTxtXml, nPosIni + 1, nPosFim - nPosIni - 1 )

      // Adiciona bloco de assinatura no local apropriado
      IF cXmlTagFinal $ cTxtXml
         cTxtXml := Substr( cTxtXml, 1, At( cXmlTagFinal, cTxtXml ) - 1 ) + SignatureNode( cURI ) + cXmlTagFinal
      ENDIF
   ENDIF

   //   HB_MemoWrit( "NFE\Ultimo-1.XML", cTxtXml )
   // Lendo Header antes de assinar //
   xmlHeaderAntes := ''
   nPosIni        := AT( [?>], cTxtXml )
   IF nPosIni > 0
      xmlHeaderAntes := Substr( cTxtXml, 1, nPosIni + 1 )
   ENDIF

   BEGIN SEQUENCE WITH __BreakBlock()

      oDOMDoc := Win_OleCreateObject( "MSXML2.DOMDocument.5.0" )
      //RECOVER
      //   cRetorno := "Erro Assinatura: Não carregado MSXML2.DOMDocument.5.0"
      //   RETURN cRetorno

      oDOMDoc:async              := .F.
      oDOMDoc:resolveExternals   := .F.
      oDOMDoc:validateOnParse    := .T.
      oDOMDoc:preserveWhiteSpace := .T.

      xmldsig := Win_OleCreateObject( "MSXML2.MXDigitalSignature.5.0" )
      //RECOVER
      //   cRetorno := "Erro Assinatura: Não carregado MSXML2.MXDigitalSignature.5.0"
      //   RETURN cRetorno
      oDOMDoc:LoadXML( cTxtXml )
      IF oDOMDoc:parseError:errorCode <> 0 // XML não carregado
         cRetorno := "Erro Assinatura: Não foi possivel carregar o documento pois ele não corresponde ao seu Schema" + HB_EOL()
         cRetorno += " Linha: "              + Str( oDOMDoc:parseError:line )    + HB_EOL()
         cRetorno += " Caractere na linha: " + Str( oDOMDoc:parseError:linepos ) + HB_EOL()
         cRetorno += " Causa do erro: "      + oDOMDoc:parseError:reason         + HB_EOL()
         cRetorno += "code: "                + Str( oDOMDoc:parseError:errorCode )
      ENDIF

      DSIGNS = [xmlns:ds="http://www.w3.org/2000/09/xmldsig#"]
      oDOMDoc:setProperty( "SelectionNamespaces", DSIGNS )

      IF .NOT. "</Signature>" $ cTxtXml
         cRetorno := "Erro Assinatura: Bloco Assinatura não encontrado"
      ENDIF
      xmldsig:signature := oDOMDoc:selectSingleNode(".//ds:Signature")
      //RECOVER
      //   cRetorno := "Erro Assinatura: Template de assinatura não encontrado"

      oCert:= CapicomCertificado( cCertCn )
      IF oCert == NIL
         cRetorno := "Erro Assinatura: Certificado não encontrado ou vencido"
      ENDIF

      oCapicomStore := Win_OleCreateObject( "CAPICOM.Store" )
      oCapicomStore:open( _CAPICOM_MEMORY_STORE, 'Memoria', _CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED )
      //RECOVER USING oError
      //   cRetorno := "Erro Assinatura: Ao criar espaço certificado na memória " + HB_EOL()
      //   cRetorno += "Error: "     + Transform( oError:GenCode, NIL )   + ";"   + HB_EOL()
      //   cRetorno += "SubC: "      + Transform( oError:SubCode, NIL )   + ";"   + HB_EOL()
      //   cRetorno += "OSCode: "    + Transform( oError:OsCode,  NIL )   + ";"   + HB_EOL()
      //   cRetorno += "SubSystem: " + Transform( oError:SubSystem, NIL ) + ";"   + HB_EOL()
      //   cRetorno += "Mensagem: "  + oError:Description

      oCapicomStore:Add( oCert )
      //RECOVER USING oError
      //   cRetorno := "Erro Assinatura: Ao adicionar certificado na memória " + HB_EOL()
      //   cRetorno += "Error: "     + Transform( oError:GenCode, NIL) + ";"   + HB_EOL()
      //   cRetorno += "SubC: "      + Transform( oError:SubCode, NIL) + ";"   + HB_EOL()
      //   cRetorno += "OSCode: "    + Transform( oError:OsCode,  NIL) + ";"   + HB_EOL()
      //   cRetorno += "SubSystem: " + Transform( oError:SubSystem, NIL) + ";" + HB_EOL()
      //   cRetorno += "Mensagem: "  + oError:Description

      xmldsig:store := oCapicomStore

      //---> Dados necessários para gerar a assinatura
      eType      := oCert:PrivateKey:ProviderType
      sProvider  := oCert:PrivateKey:ProviderName
      sContainer := oCert:PrivateKey:ContainerName
      dsigKey    := xmldsig:CreateKeyFromCSP( eType, sProvider, sContainer, 0 )
      IF ( dsigKey = NIL )
         cRetorno := "Erro Assinatura: Ao criar a chave do CSP."
      ENDIF

      SignedKey := XmlDSig:Sign( DSigKey, 2 )

      IF ( signedKey <> NIL )
         XMLAssinado := oDOMDoc:xml
         XMLAssinado := StrTran( XMLAssinado, Chr(10), "" )
         XMLAssinado := StrTran( XMLAssinado, Chr(13), "" )
         nPosIni     := At( [<SignatureValue>], XMLAssinado ) + Len( [<SignatureValue>] )
         XMLAssinado := Substr( XMLAssinado, 1, nPosIni - 1 ) + StrTran( Substr( XMLAssinado, nPosIni, Len( XMLAssinado ) ), " ", "" )
         nPosIni     := At( [<X509Certificate>], XMLAssinado ) - 1
         nP          := At( [<X509Certificate>], XMLAssinado )
         nResult     := 0
         DO WHILE nP <> 0
            nResult := nP
            nP      := hb_At( [<X509Certificate>], XMLAssinado, nP + 1 )
         ENDDO
         nPosFim     := nResult
         XMLAssinado := Substr( XMLAssinado, 1, nPosIni ) + Substr( XMLAssinado, nPosFim, Len( XMLAssinado ) )
      ELSE
         cRetorno := "Erro Assinatura: Assinatura Falhou."
      ENDIF

      IF xmlHeaderAntes <> ""
         nPosIni := At( XMLAssinado, [?>] )
         IF nPosIni > 0
            xmlHeaderDepois := Substr( XMLAssinado, 1, nPosIni + 1 )
            IF xmlHeaderAntes <> xmlHeaderDepois
               * ? "entrou stuff"
               * XMLAssinado := StuffString( XMLAssinado, 1, Length( xmlHeaderDepois ), xmlHeaderAntes )
            ENDIF
         ELSE
            XMLAssinado := xmlHeaderAntes + XMLAssinado
         ENDIF
      ENDIF
      cRetorno := "OK"
      cTxtXml    := XmlAssinado

   END SEQUENCE

   RETURN cRetorno

STATIC FUNCTION SignatureNode( cUri )

   LOCAL cSignatureNode := ""

   cSignatureNode += [<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">]
   cSignatureNode +=    [<SignedInfo>]
   cSignatureNode +=       [<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>]
   cSignatureNode +=       [<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />]
   cSignatureNode +=       [<Reference URI="#] + cURI + [">]
   cSignatureNode +=       [<Transforms>]
   cSignatureNode +=          [<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />]
   cSignatureNode +=          [<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />]
   cSignatureNode +=       [</Transforms>]
   cSignatureNode +=       [<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" />]
   cSignatureNode +=       [<DigestValue>]
   cSignatureNode +=       [</DigestValue>]
   cSignatureNode +=       [</Reference>]
   cSignatureNode +=    [</SignedInfo>]
   cSignatureNode +=    [<SignatureValue>]
   cSignatureNode +=    [</SignatureValue>]
   cSignatureNode +=    [<KeyInfo>]
   cSignatureNode +=    [</KeyInfo>]
   cSignatureNode += [</Signature>]

   RETURN cSignatureNode

FUNCTION FakeSignature( cUri )

   LOCAL cXml

   cUri := iif( cUri == NIL, [#ProjetoChave], cUri )
   cXml := [<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">]
   cXml += [<SignedInfo>]
   cXml += [<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>]
   cXml += [<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>]
   cXml += [<Reference URI="] + cUri + [">]
   cXml += [<Transforms>]
   cXml += [<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>]
   cXml += [<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>]
   cXml += [</Transforms>]
   cXml += [<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/>]
   cXml += [<DigestValue>WWU2T2WF45DPmD82mTOb6mJ7fYg=</DigestValue>]
   cXml += [</Reference>]
   cXml += [</SignedInfo>]
   cXml += [<SignatureValue>]
   cXml += [GbNNpKX/2BjzNDcnUmE8GnJFwzKHqr6Mk9CO0pvBc0pIh1DtyWyIb7WOsOknxlZ46Z8nHyCbRmGtoQftktYG01cOMibHfukWbFLs]
   cXml += [tHAslX5THfXo4jh+WXw1idyNq2FC7+g16cO5DEoyiOcPsFFjUmieYaZHZ/bgoBtSPE3dOooX2My6ATvf11/n5kmFdMj/DTX6HIC3]
   cXml += [KlNiok2du5XoV8ExwZ7i8jI3WjjU2ha49tJLXZqiJ1ySc46coqmuuXp1NkucRMR8VEBSOZt+xVfldHUyAg9K+fsmB/wvCywqILEv]
   cXml += [Z7OYzrlszhB3quVQJtGxU9p0rqtUXxy/xoAD0RcCEA==</SignatureValue><KeyInfo><X509Data><X509Certificate>MII]
   cXml += [IVDCCBjygAwIBAgIQS95TYS8G5+BftP3vKfMOtjANBgkqhkiG9w0BAQsFADB4MQswCQYDVQQGEwJCUjETMBEGA1UEChMKSUNQLUJ]
   cXml += [yYXNpbDE2MDQGA1UECxMtU2VjcmV0YXJpYSBkYSBSZWNlaXRhIEZlZGVyYWwgZG8gQnJhc2lsIC0gUkZCMRwwGgYDVQQDExNBQyB]
   cXml += [DZXJ0aXNpZ24gUkZCIEc0MB4XDTE1MDMwNDAwMDAwMFoXDTE2MDMwMjIzNTk1OVowgfIxCzAJBgNVBAYTAkJSMRMwEQYDVQQKFAp]
   cXml += [JQ1AtQnJhc2lsMQswCQYDVQQIEwJTUDESMBAGA1UEBxQJU0FPIFBBVUxPMTYwNAYDVQQLFC1TZWNyZXRhcmlhIGRhIFJlY2VpdGE]
   cXml += [gRmVkZXJhbCBkbyBCcmFzaWwgLSBSRkIxFjAUBgNVBAsUDVJGQiBlLUNOUEogQTExJDAiBgNVBAsUG0F1dGVudGljYWRvIHBvciB]
   cXml += [BUiBBdHJpYnV0bzE3MDUGA1UEAxMuQ0FSQk9MVUIgTFVCUklGSUNBTlRFUyBMVERBIEVQUDowODM5ODU2NjAwMDEyNTCCASIwDQY]
   cXml += [JKoZIhvcNAQEBBQADggEPADCCAQoCggEBAIN+DwBGJTXzmNDdD9fbpkQ6DdBk3pVwxsSjiWQIMkwR4Hh6TIWeL/bKqQ9wUOBHj7z]
   cXml += [LDZeBphc/Ufungt6EmWWawv0mTFCi6Sn3wypvR7mjQ3MgaKfTo5PR+bRI+40DXuHdB6M/hnvma0XnQvpkUefn1bpbeUu6R//iQRb]
   cXml += [OzaOHkVl4va1ABdBEVLcXfa6MaE/iGKlrHw2xrcgulV+CmsyQv+1zBMI8DLwmE0emuzmZtzXHSDspEE6hkP8103224UJSl8Wtpt7]
   cXml += [OXJrqpAfeGI9yIxHkdwDBbnZ8y0lJ6qn4nnYfQ/fQSxCiBIiXmPhjJPjUYlNl7IP+EIttbCKVNj8CAwEAAaOCA10wggNZMIHCBgN]
   cXml += [VHREEgbowgbegOAYFYEwBAwSgLwQtMDEwOTE5NTI5MDUxMDkwOTg2ODAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwoCkGBWBMAQM]
   cXml += [CoCAEHk1BUklBIERFT0xJTkRBIE1PUkFJUyBDT1JERUlST6AZBgVgTAEDA6AQBA4wODM5ODU2NjAwMDEyNaAXBgVgTAEDB6AOBAw]
   cXml += [wMDAwMDAwMDAwMDCBHGFkbUBjb21lcmNpYWxjb3JkZWlyby5jb20uYnIwCQYDVR0TBAIwADAfBgNVHSMEGDAWgBQukerWbeWyWYL]
   cXml += [cOIUpdjQWVjzQPjAOBgNVHQ8BAf8EBAMCBeAwfwYDVR0gBHgwdjB0BgZgTAECAQwwajBoBggrBgEFBQcCARZcaHR0cDovL2ljcC1]
   cXml += [icmFzaWwuY2VydGlzaWduLmNvbS5ici9yZXBvc2l0b3Jpby9kcGMvQUNfQ2VydGlzaWduX1JGQi9EUENfQUNfQ2VydGlzaWduX1J]
   cXml += [GQi5wZGYwggEWBgNVHR8EggENMIIBCTBXoFWgU4ZRaHR0cDovL2ljcC1icmFzaWwuY2VydGlzaWduLmNvbS5ici9yZXBvc2l0b3J]
   cXml += [pby9sY3IvQUNDZXJ0aXNpZ25SRkJHNC9MYXRlc3RDUkwuY3JsMFagVKBShlBodHRwOi8vaWNwLWJyYXNpbC5vdXRyYWxjci5jb20]
   cXml += [uYnIvcmVwb3NpdG9yaW8vbGNyL0FDQ2VydGlzaWduUkZCRzQvTGF0ZXN0Q1JMLmNybDBWoFSgUoZQaHR0cDovL3JlcG9zaXRvcml]
   cXml += [vLmljcGJyYXNpbC5nb3YuYnIvbGNyL0NlcnRpc2lnbi9BQ0NlcnRpc2lnblJGQkc0L0xhdGVzdENSTC5jcmwwHQYDVR0lBBYwFAY]
   cXml += [IKwYBBQUHAwIGCCsGAQUFBwMEMIGbBggrBgEFBQcBAQSBjjCBizBfBggrBgEFBQcwAoZTaHR0cDovL2ljcC1icmFzaWwuY2VydGl]
   cXml += [zaWduLmNvbS5ici9yZXBvc2l0b3Jpby9jZXJ0aWZpY2Fkb3MvQUNfQ2VydGlzaWduX1JGQl9HNC5wN2MwKAYIKwYBBQUHMAGGHGh]
   cXml += [0dHA6Ly9vY3NwLmNlcnRpc2lnbi5jb20uYnIwDQYJKoZIhvcNAQELBQADggIBANZORnRtX82sWrkhdyIs16PnzSYUBOsnrrXTlhr]
   cXml += [fFH39ELl64Hqc6mSHz0XNKx3pac5l6wh287xZJqErbw4zVt2iruJt4d5HFZw3utKv3T79IpN/NGzTcMopz2pi3jrHFLx4BCg9U/z]
   cXml += [WWeiIGJpEOPV5VCn6kRpo1Qe8riZoryVr4ikGUb2i8uchGXb1NWBXch8X9n/Z4C4clPDtLcM8FXC5CzxnB9Ti8BakwcpvCEJydHj]
   cXml += [B3CmjFPUP5se2NwjjqRZNcoXBFToi3U9ZHJ4UynFfSaD1V/Mu11Px/SrSU/9OAZzUrmQGuzh5TN7eQUSjnLqYjOn1rgC3g7rzibH]
   cXml += [VrMjH5GC2XtiTQIrItXKyEmmz+f5qSmhts2NoKVLiX7wn/iZ7SfT+PnedgQuFUemL3KV+tTfR1s/aFB3C06xRuRZqB8usrrCwnr+]
   cXml += [n2jyn2bjMY7S+vl+z3dimwzSQiH9gZOyJkDzv3H081LmyaYvcaps0ZrwdXL0wNACTXqDc0fiwAYn2AxEzs5V+omGOPJuGl8qQxMp]
   cXml += [IWQlpxdtaes5Gt3GQjU12ElC7m1IHpNLY4+U86pfCvIqLOQXjmxhSh2T+4mZJWm5gE7l+M1Vj7UDVTTMkEWKmJJBp+y06JN8VWbi]
   cXml += [NFseFokoj802R+AYJeE7gz/YoVmY0Ro7pVf1fOvfeC9h6]
   cXml += [</X509Certificate>]
   cXml += [</X509Data>]
   cXml += [</KeyInfo>]
   cXml += [</Signature>]

   RETURN cXml
