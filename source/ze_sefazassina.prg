/*
ZE_SPEDASSINA - Assinatura SPED
José Quintas

* Crédito para hbnfe que mostrou como fazer https://github.com/fernandoathayde/hbnfe

2017.11.27.1230 - Opção de usar arquivo PFX
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
#include "hb2xhb.ch"

FUNCTION CapicomAssinaXml( cTxtXml, cCertCN, lRemoveAnterior, cPassword )

   LOCAL oDOMDocument, xmldsig, oCert, oCapicomStore
   LOCAL SIGNEDKEY, DSIGKEY
   LOCAL cXmlTagInicial, cXmlTagFinal, cRetorno := ""
   LOCAL cDllFile, acDllList := { "msxml5.dll", "msxml5r.dll", "capicom.dll" }

   hb_Default( @lRemoveAnterior, .T. )

   AssinaRemoveAssinatura( @cTxtXml, lRemoveAnterior )

   AssinaRemoveDeclaracao( @cTxtXml )

   IF ! AssinaAjustaInformacao( @cTxtXml, @cXmlTagInicial, @cXmlTagFinal, @cRetorno )
      RETURN cRetorno
   ENDIF

   IF ! AssinaLoadXml( @oDOMDocument, cTxtXml, @cRetorno )
      RETURN cRetorno
   ENDIF

   IF ! AssinaLoadCertificado( cCertCN, @ocert, @oCapicomStore, cPassword, @cRetorno )
      RETURN cRetorno
   ENDIF

   BEGIN SEQUENCE WITH __BreakBlock()

      cRetorno := "Erro Assinatura: Não carregado MSXML2.MXDigitalSignature.5.0"
      xmldsig := Win_OleCreateObject( "MSXML2.MXDigitalSignature.5.0" )

      cRetorno := "Erro Assinatura: Template de assinatura não encontrado"
      xmldsig:signature := oDOMDocument:selectSingleNode(".//ds:Signature")

      cRetorno := "Erro assinatura: Certificado pra assinar XmlDSig:Store"
      xmldsig:store := oCapicomStore

      dsigKey  := xmldsig:CreateKeyFromCSP( oCert:PrivateKey:ProviderType, oCert:PrivateKey:ProviderName, oCert:PrivateKey:ContainerName, 0 )
      IF ( dsigKey = NIL )
         cRetorno := "Erro assinatura: Ao criar a chave do CSP."
         BREAK
      ENDIF
      cRetorno := "Erro assinatura: assinar XmlDSig:Sign()"
      SignedKey := XmlDSig:Sign( DSigKey, 2 )

      IF signedKey == NIL
         cRetorno := "Erro Assinatura: Assinatura Falhou."
         BREAK
      ENDIF
      cTxtXml  := AssinaAjustaAssinado( oDOMDocument:Xml )
      cRetorno := "OK"

   END SEQUENCE

   IF cRetorno != "OK" .OR. ! "<Signature" $ cTxtXml
      IF Empty( cRetorno )
         cRetorno := "Erro Assinatura "
      ENDIF
      FOR EACH cDllFile IN acDllList
         IF ! File( "c:\windows\system32\" + cDllFile ) .AND. ! File( "c:\windows\syswow64\" + cDllFile )
            cRetorno += ", verifique " + cDllFile
         ENDIF
      NEXT
   ENDIF

   RETURN cRetorno

STATIC FUNCTION AssinaBlocoAssinatura( cUri )

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

STATIC FUNCTION AssinaRemoveAssinatura( cTxtXml, lRemoveAnterior )

   LOCAL nPosIni, nPosFim

   // Remove assinatura anterior - atenção pra NFS que usa multiplas assinaturas
   IF lRemoveAnterior
      DO WHILE "<Signature" $ cTxtXml .AND. "</Signature>" $ cTxtXml
         nPosIni := At( "<Signature", cTxtXml ) - 1
         nPosFim := At( "</Signature>", cTxtXml ) + 12
         cTxtXml := Substr( cTxtXml, 1, nPosIni ) + Substr( cTxtXml, nPosFim )
      ENDDO
   ENDIF

   RETURN cTxtXml

STATIC FUNCTION AssinaRemoveDeclaracao( cTxtXml )

   IF "<?XML" $ Upper( cTxtXml ) .AND. "?>" $ cTxtXml
      cTxtXml := Substr( cTxtXml, At( "?>", cTxtXml ) + 2 )
      DO WHILE Substr( cTxtXml, 1, 1 ) $ hb_Eol()
         cTxtXml := Substr( cTxtXml, 2 )
      ENDDO
   ENDIF

   RETURN cTxtXml

STATIC FUNCTION AssinaAjustaInformacao( cTxtXml, cXmlTagInicial, cXmlTagFinal, cRetorno )

   LOCAL aDelimitadores, nPos, nPosIni, nPosFim, cURI

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
   IF ( nPos := AScan( aDelimitadores, { | oElement | oElement[ 1 ] $ cTxtXml .AND. oElement[ 2 ] $ cTxtXml } ) ) == 0
      cRetorno := "Erro Assinatura: Não identificado documento"
      RETURN .F.
   ENDIF
   cXmlTagFinal   := aDelimitadores[ nPos, 2 ]
   // Pega URI
   nPosIni := At( [Id=], cTxtXml )
   IF nPosIni = 0
      cRetorno := "Erro Assinatura: Não encontrado início do URI: Id= (com I maiúsculo)"
      RETURN .F.
   ENDIF
   nPosIni := hb_At( ["], cTxtXml, nPosIni + 2 )
   IF nPosIni = 0
      cRetorno := "Erro Assinatura: Não encontrado início do URI: aspas inicial"
      RETURN .F.
   ENDIF
   nPosFim := hb_At( ["], cTxtXml, nPosIni + 1 )
   IF nPosFim = 0
      cRetorno := "Erro Assinatura: Não encontrado início do URI: aspas final"
      RETURN .F.
   ENDIF
   cURI := Substr( cTxtXml, nPosIni + 1, nPosFim - nPosIni - 1 )

   // Adiciona bloco de assinatura no local apropriado
   IF cXmlTagFinal $ cTxtXml
      cTxtXml := Substr( cTxtXml, 1, At( cXmlTagFinal, cTxtXml ) - 1 ) + AssinaBlocoAssinatura( cURI ) + cXmlTagFinal
   ENDIF

   IF ! "</Signature>" $ cTxtXml
      cRetorno := "Erro Assinatura: Bloco Assinatura não encontrado"
      RETURN .F.
   ENDIF

   HB_SYMBOL_UNUSED( cXmlTagInicial )

   RETURN .T.

STATIC FUNCTION AssinaLoadXml( oDomDocument, cTxtXml, cRetorno )

   LOCAL lOk := .F.

   BEGIN SEQUENCE WITH __BreakBlock()

      oDOMDocument := Win_OleCreateObject( "MSXML2.DOMDocument.5.0" )
      oDOMDocument:async              := .F.
      oDOMDocument:resolveExternals   := .F.
      oDOMDocument:validateOnParse    := .T.
      oDOMDocument:preserveWhiteSpace := .T.
      lOk := .T.

   END SEQUENCE

   IF ! lOk
      cRetorno := "Erro Assinatura: Não carregado MSXML2.DomDocument"
      RETURN .F.
   ENDIF

   lOk := .F.

   BEGIN SEQUENCE WITH __BreakBlock()

      oDOMDocument:LoadXML( cTxtXml )
      oDOMDocument:setProperty( "SelectionNamespaces", [xmlns:ds="http://www.w3.org/2000/09/xmldsig#"] )
      lOk := .T.

   END SEQUENCE

   IF ! lOk
      IF oDOMDocument:parseError:errorCode <> 0 // XML não carregado
         cRetorno := "Erro Assinatura: Não foi possivel carregar o documento pois ele não corresponde ao seu Schema" + HB_EOL()
         cRetorno += " Linha: "              + Str( oDOMDocument:parseError:line )    + HB_EOL()
         cRetorno += " Caractere na linha: " + Str( oDOMDocument:parseError:linepos ) + HB_EOL()
         cRetorno += " Causa do erro: "      + oDOMDocument:parseError:reason         + HB_EOL()
         cRetorno += "code: "                + Str( oDOMDocument:parseError:errorCode )
         RETURN .F.
      ENDIF
      cRetorno := "Erro Assinatura: Não foi possível carregar documento"
      RETURN .F.
   ENDIF

   RETURN .T.

STATIC FUNCTION AssinaLoadCertificado( cCertCN, oCert, oCapicomStore, cPassword, cRetorno )

   LOCAL lOk := .F.

   IF Upper( Right( cCertCN, 4 ) ) == ".PFX"
      IF ! File( cCertCn )
         cRetorno := "Erro assinatura: Arquivo PFX não encontrado"
         RETURN .F.
      ENDIF
      IF cPassword == NIL .OR. Empty( cPassword )
         cRetorno := "Erro assinatura: Falta senha do arquivo PFX"
         RETURN .F.
      ENDIF
      oCert := win_OleCreateObject( "CAPICOM.Certificate" )
      oCert:Load( cCertCN, cPassword, 1, 0 )
   ELSE
      oCert := CapicomCertificado( cCertCn )
   ENDIF
   IF oCert == NIL
      cRetorno := "Erro Assinatura: Certificado não encontrado ou vencido"
      RETURN .F.
   ENDIF

   BEGIN SEQUENCE WITH __BreakBlock()

      oCapicomStore := Win_OleCreateObject( "CAPICOM.Store" )
      oCapicomStore:open( _CAPICOM_MEMORY_STORE, 'Memoria', _CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED )
      oCapicomStore:Add( oCert )

      lOk := .T.
   END SEQUENCE
   IF ! lOk
      cRetorno := "Erro assinatura: Problemas no uso do certificado"
      RETURN .F.
   ENDIF

   RETURN .T.

STATIC FUNCTION AssinaAjustaAssinado( cXml )

   LOCAL nPosIni // , nPosFim, nP

   cXml    := StrTran( cXml, Chr(10), "" )
   cXml    := StrTran( cXml, Chr(13), "" )
   nPosIni := RAt( [<SignatureValue>], cXml ) + Len( [<SignatureValue>] )
   cXml    := Substr( cXml, 1, nPosIni - 1 ) + StrTran( Substr( cXml, nPosIni ), " ", "" )
   //nPosIni := hb_At( [<X509Certificate>], cXml, nPosIni ) - 1
   //nP      := nPosIni + 1
   //nPosFim := 0
   //DO WHILE nP <> 0
   //   nPosFim := nP
   //   nP      := hb_At( [<X509Certificate>], cXml, nP + 1 )
   //ENDDO
   //cXml := Substr( cXml, 1, nPosIni ) + Substr( cXml, nPosFim, Len( cXml ) )

   RETURN cXml

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

   // Anotação: carregar PFX e instalar via Capicom
   // oCertStore := win_OleCreateObject( "CAPICOM.Store" )
   // oCert      := win_OleCreateObject( "CAPICOM.Certificate" )
   // oCert:Load( "c:\path\file.pfx", "password", 1, 0 )
   // oCert:Add( oCert )
