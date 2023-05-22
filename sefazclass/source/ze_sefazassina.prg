/*
ZE_SPEDASSINA - Assinatura SPED
José Quintas

* Crédito para hbnfe que mostrou como fazer https://github.com/fernandoathayde/hbnfe

2017.11.27 - Opção de usar arquivo PFX
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
#ifdef __XHARBOUR__
   #include "hb2xhb.ch"
#endif

FUNCTION CapicomAssinaXml( cTxtXml, cCertCN, lRemoveAnterior, cPassword, lComURI )

   LOCAL oDOMDocument, xmldsig, oCert, oCapicomStore
   LOCAL SIGNEDKEY, DSIGKEY
   LOCAL cXmlTagInicial, cXmlTagFinal, cRetorno := ""
   LOCAL cDllFile, acDllList := { "msxml5.dll", "msxml5r.dll", "capicom.dll" }

   hb_Default( @lRemoveAnterior, .T. )
   hb_Default( @lComURI, .T. )

   AssinaRemoveAssinatura( @cTxtXml, lRemoveAnterior )

   AssinaRemoveDeclaracao( @cTxtXml )

   IF ! AssinaAjustaInformacao( @cTxtXml, @cXmlTagInicial, @cXmlTagFinal, @cRetorno, @lComURI )
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
      xmldsig := win_OleCreateObject( "MSXML2.MXDigitalSignature.5.0" )

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

   ENDSEQUENCE

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

STATIC FUNCTION AssinaBlocoAssinatura( cURI, lComURI )

   LOCAL cSignatureNode := ""

   IF lComURI
      cURI := "#" + cURI
   ENDIF
   cSignatureNode += [<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">]
   cSignatureNode +=    [<SignedInfo>]
   cSignatureNode +=       [<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>]
   cSignatureNode +=       [<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />]
   cSignatureNode +=       [<Reference URI="] + cURI + [">]
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

STATIC FUNCTION AssinaAjustaInformacao( cTxtXml, cXmlTagInicial, cXmlTagFinal, cRetorno, lComURI )

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
      { "<evtInfoEmpregador",     "</eSocial>" }, ;
      { "<PedidoEnvioLoteRPS",    "</RPS>" }, ;
      { "<PedidoEnvioRPS",        "</PedidoEnvioRPS>" }, ;
      { "<infPedidoCancelamento", "</Pedido>" }, ;               // NFSE ABRASF Cancelamento
      { "<LoteRps",               "</EnviarLoteRpsEnvio>" }, ;   // NFSE ABRASF Lote
      { "<infRps",                "</Rps>" } }                   // NFSE ABRASF RPS

   // Define Tipo de Documento
   IF ( nPos := hb_AScan( aDelimitadores, { | oElement | oElement[ 1 ] $ cTxtXml .AND. oElement[ 2 ] $ cTxtXml } ) ) == 0
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
      cTxtXml := Substr( cTxtXml, 1, At( cXmlTagFinal, cTxtXml ) - 1 ) + AssinaBlocoAssinatura( cURI, lComURI ) + cXmlTagFinal
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

      oDOMDocument := win_OleCreateObject( "MSXML2.DOMDocument.5.0" )
      oDOMDocument:async              := .F.
      oDOMDocument:resolveExternals   := .F.
      oDOMDocument:validateOnParse    := .T.
      oDOMDocument:preserveWhiteSpace := .T.
      lOk := .T.

   ENDSEQUENCE

   IF ! lOk
      cRetorno := "Erro Assinatura: Não carregado MSXML2.DomDocument"
      RETURN .F.
   ENDIF

   lOk := .F.

   BEGIN SEQUENCE WITH __BreakBlock()

      oDOMDocument:LoadXML( cTxtXml )
      oDOMDocument:setProperty( "SelectionNamespaces", [xmlns:ds="http://www.w3.org/2000/09/xmldsig#"] )
      lOk := .T.

   ENDSEQUENCE

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

      oCapicomStore := win_OleCreateObject( "CAPICOM.Store" )
      oCapicomStore:open( _CAPICOM_MEMORY_STORE, 'Memoria', _CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED )
      oCapicomStore:Add( oCert )

      lOk := .T.
   ENDSEQUENCE
   IF ! lOk
      cRetorno := "Erro assinatura: Problemas no uso do certificado"
      RETURN .F.
   ENDIF

   RETURN .T.

STATIC FUNCTION AssinaAjustaAssinado( cXml )

   LOCAL nPosIni, nPosFim

   cXml    := StrTran( cXml, Chr(10), "" )
   cXml    := StrTran( cXml, Chr(13), "" )
   nPosIni := RAt( [<SignatureValue>], cXml ) + Len( [<SignatureValue>] )
   cXml    := Substr( cXml, 1, nPosIni - 1 ) + StrTran( Substr( cXml, nPosIni ), " ", "" )

   // Ocorrência estranha: <X509Data> duplicado num cliente com A3
   nPosIni := At( "</X509Data><X509Data>", cXml )
   IF nPosIni != 0
      nPosFim := hb_At( "</X509Data>", cXml, nPosIni + 5 )
      cXml    := Substr( cXml, 1, nPosIni - 1 ) + Substr( cXml, nPosFim )
   ENDIF

   //nPosIni := hb_At( [<X509Certificate>], cXml, nPosIni ) - 1
   //nP      := nPosIni + 1
   //nPosFim := 0
   //DO WHILE nP <> 0
   //   nPosFim := nP
   //   nP      := hb_At( [<X509Certificate>], cXml, nP + 1 )
   //ENDDO
   //cXml := Substr( cXml, 1, nPosIni ) + Substr( cXml, nPosFim, Len( cXml ) )

   RETURN cXml

   // Anotação: carregar PFX e instalar via Capicom
   // oCertStore := win_OleCreateObject( "CAPICOM.Store" )
   // oCert      := win_OleCreateObject( "CAPICOM.Certificate" )
   // oCert:Load( "c:\path\file.pfx", "password", 1, 0 )
   // oCert:Add( oCert )
