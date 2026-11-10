/*
ZE_SEFAZ_WINAPI - Assinatura XML pela API do Windows (sem capicom e sem msxml5)
Jose Quintas

- canonicalizacao C14N 1.0 inclusive pela WWSAPI (webservices.dll, Windows 7 / Server 2008 R2 em diante)
- certificado pelo crypt32, assinatura RSA-SHA1 pelo CSP antigo ou pelo CNG (ncrypt.dll)
- webservices.dll e ncrypt.dll carregadas em tempo de execucao (LoadLibrary/GetProcAddress):
  nao depende de cabecalho nem de biblioteca do compilador
- declaracoes iguais as do Windows SDK, com nomes proprios pra nao colidir:
  WEBSERVICESDLL_ / NCRYPTDLL_ em maiusculas (constantes e tipos), webservicesdll_ / ncryptdll_ (funcoes)

Erro devolvido em 2 partes: categoria e mensagem
   "certificado" - quem resolve e o cliente (nao encontrado, vencido, sem chave, token, PIN)
   "cancelado"   - o usuario cancelou a digitacao do PIN
   "documento"   - XML mal formado, Id nao encontrado
   "rotina"      - DLL/funcao nao carregada ou erro nao previsto
*/

#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <wincrypt.h>
#include <string.h>
#include "hbapi.h"

#ifndef CRYPT_ACQUIRE_ALLOW_NCRYPT_KEY_FLAG
#define CRYPT_ACQUIRE_ALLOW_NCRYPT_KEY_FLAG 0x00010000
#endif
#ifndef CERT_NCRYPT_KEY_SPEC
#define CERT_NCRYPT_KEY_SPEC 0xFFFFFFFF
#endif

/* ---------------- webservices.dll ---------------- */

#define WEBSERVICESDLL_XML_NODE_TYPE_ELEMENT                  1
#define WEBSERVICESDLL_XML_NODE_TYPE_EOF                      8
#define WEBSERVICESDLL_XML_TEXT_TYPE_UTF8                     1
#define WEBSERVICESDLL_XML_READER_ENCODING_TYPE_TEXT          1
#define WEBSERVICESDLL_XML_READER_INPUT_TYPE_BUFFER           1
#define WEBSERVICESDLL_XML_WRITER_ENCODING_TYPE_TEXT          1
#define WEBSERVICESDLL_XML_WRITER_OUTPUT_TYPE_BUFFER          1
#define WEBSERVICESDLL_CHARSET_AUTO                           0
#define WEBSERVICESDLL_CHARSET_UTF8                           1
#define WEBSERVICESDLL_XML_CANONICALIZATION_PROPERTY_ALGORITHM 0
#define WEBSERVICESDLL_INCLUSIVE_XML_CANONICALIZATION_ALGORITHM 2
#define WEBSERVICESDLL_ERROR_PROPERTY_STRING_COUNT            0
#define WEBSERVICESDLL_E_INVALID_FORMAT                       ( ( HRESULT ) 0x803D0000L )

typedef struct { ULONG length; BYTE * bytes; void * dictionary; ULONG id; } WEBSERVICESDLL_XML_STRING;
typedef struct { ULONG length; BYTE * bytes; } WEBSERVICESDLL_BYTES;
typedef struct { ULONG length; WCHAR * chars; } WEBSERVICESDLL_STRING;
typedef struct { int nodeType; } WEBSERVICESDLL_XML_NODE;
typedef struct { int textType; } WEBSERVICESDLL_XML_TEXT;
typedef struct { WEBSERVICESDLL_XML_TEXT text; WEBSERVICESDLL_BYTES value; } WEBSERVICESDLL_XML_UTF8_TEXT;
typedef struct
{
   BYTE singleQuote;
   BYTE isXmlNs;
   WEBSERVICESDLL_XML_STRING * prefix;
   WEBSERVICESDLL_XML_STRING * localName;
   WEBSERVICESDLL_XML_STRING * ns;
   WEBSERVICESDLL_XML_TEXT * value;
} WEBSERVICESDLL_XML_ATTRIBUTE;
typedef struct
{
   WEBSERVICESDLL_XML_NODE node;
   WEBSERVICESDLL_XML_STRING * prefix;
   WEBSERVICESDLL_XML_STRING * localName;
   WEBSERVICESDLL_XML_STRING * ns;
   ULONG attributeCount;
   WEBSERVICESDLL_XML_ATTRIBUTE ** attributes;
   BOOL isEmpty;
} WEBSERVICESDLL_XML_ELEMENT_NODE;
typedef struct { int encodingType; } WEBSERVICESDLL_XML_READER_ENCODING;
typedef struct { WEBSERVICESDLL_XML_READER_ENCODING encoding; int charSet; } WEBSERVICESDLL_XML_READER_TEXT_ENCODING;
typedef struct { int inputType; } WEBSERVICESDLL_XML_READER_INPUT;
typedef struct { WEBSERVICESDLL_XML_READER_INPUT input; void * encodedData; ULONG encodedDataSize; } WEBSERVICESDLL_XML_READER_BUFFER_INPUT;
typedef struct { int encodingType; } WEBSERVICESDLL_XML_WRITER_ENCODING;
typedef struct { WEBSERVICESDLL_XML_WRITER_ENCODING encoding; int charSet; } WEBSERVICESDLL_XML_WRITER_TEXT_ENCODING;
typedef struct { int outputType; } WEBSERVICESDLL_XML_WRITER_OUTPUT;
typedef struct { WEBSERVICESDLL_XML_WRITER_OUTPUT output; } WEBSERVICESDLL_XML_WRITER_BUFFER_OUTPUT;
typedef struct { int id; void * value; ULONG valueSize; } WEBSERVICESDLL_XML_CANONICALIZATION_PROPERTY;

typedef HRESULT ( CALLBACK * WEBSERVICESDLL_WRITE_CALLBACK )( void *, const WEBSERVICESDLL_BYTES *, ULONG, const void *, void * );

typedef HRESULT ( WINAPI * WEBSERVICESDLL_CREATEERROR )( const void *, ULONG, void ** );
typedef void    ( WINAPI * WEBSERVICESDLL_FREEERROR )( void * );
typedef HRESULT ( WINAPI * WEBSERVICESDLL_GETERRORPROPERTY )( void *, int, void *, ULONG );
typedef HRESULT ( WINAPI * WEBSERVICESDLL_GETERRORSTRING )( void *, ULONG, WEBSERVICESDLL_STRING * );
typedef HRESULT ( WINAPI * WEBSERVICESDLL_CREATEREADER )( const void *, ULONG, void **, void * );
typedef void    ( WINAPI * WEBSERVICESDLL_FREEREADER )( void * );
typedef HRESULT ( WINAPI * WEBSERVICESDLL_SETINPUT )( void *, const WEBSERVICESDLL_XML_READER_ENCODING *, const WEBSERVICESDLL_XML_READER_INPUT *, const void *, ULONG, void * );
typedef HRESULT ( WINAPI * WEBSERVICESDLL_GETREADERNODE )( void *, const WEBSERVICESDLL_XML_NODE **, void * );
typedef HRESULT ( WINAPI * WEBSERVICESDLL_READNODE )( void *, void * );
typedef HRESULT ( WINAPI * WEBSERVICESDLL_CREATEWRITER )( const void *, ULONG, void **, void * );
typedef void    ( WINAPI * WEBSERVICESDLL_FREEWRITER )( void * );
typedef HRESULT ( WINAPI * WEBSERVICESDLL_SETOUTPUT )( void *, const WEBSERVICESDLL_XML_WRITER_ENCODING *, const WEBSERVICESDLL_XML_WRITER_OUTPUT *, const void *, ULONG, void * );
typedef HRESULT ( WINAPI * WEBSERVICESDLL_STARTWRITERCANONICALIZATION )( void *, WEBSERVICESDLL_WRITE_CALLBACK, void *, const WEBSERVICESDLL_XML_CANONICALIZATION_PROPERTY *, ULONG, void * );
typedef HRESULT ( WINAPI * WEBSERVICESDLL_ENDWRITERCANONICALIZATION )( void *, void * );
typedef HRESULT ( WINAPI * WEBSERVICESDLL_COPYNODE )( void *, void *, void * );

static WEBSERVICESDLL_CREATEERROR                 webservicesdll_CreateError;
static WEBSERVICESDLL_FREEERROR                   webservicesdll_FreeError;
static WEBSERVICESDLL_GETERRORPROPERTY            webservicesdll_GetErrorProperty;
static WEBSERVICESDLL_GETERRORSTRING              webservicesdll_GetErrorString;
static WEBSERVICESDLL_CREATEREADER                webservicesdll_CreateReader;
static WEBSERVICESDLL_FREEREADER                  webservicesdll_FreeReader;
static WEBSERVICESDLL_SETINPUT                    webservicesdll_SetInput;
static WEBSERVICESDLL_GETREADERNODE               webservicesdll_GetReaderNode;
static WEBSERVICESDLL_READNODE                    webservicesdll_ReadNode;
static WEBSERVICESDLL_CREATEWRITER                webservicesdll_CreateWriter;
static WEBSERVICESDLL_FREEWRITER                  webservicesdll_FreeWriter;
static WEBSERVICESDLL_SETOUTPUT                   webservicesdll_SetOutput;
static WEBSERVICESDLL_STARTWRITERCANONICALIZATION webservicesdll_StartWriterCanonicalization;
static WEBSERVICESDLL_ENDWRITERCANONICALIZATION   webservicesdll_EndWriterCanonicalization;
static WEBSERVICESDLL_COPYNODE                    webservicesdll_CopyNode;

static int webservicesdll_status = 0; /* 0 = nao tentado, 1 = ok, -1 = falhou */
static char webservicesdll_falta[ 64 ];

static int webservicesdll_load( void )
{
   if( webservicesdll_status == 0 )
   {
      HMODULE h = LoadLibraryA( "webservices.dll" );
      int ok = h != NULL;

      hb_strncpy( webservicesdll_falta, "webservices.dll", sizeof( webservicesdll_falta ) - 1 );
#define WSLOAD( var, name ) \
      if( ok ) \
      { \
         *( FARPROC * ) &var = GetProcAddress( h, name ); \
         if( var == NULL ) \
         { \
            ok = 0; \
            hb_strncpy( webservicesdll_falta, name, sizeof( webservicesdll_falta ) - 1 ); \
         } \
      }
      WSLOAD( webservicesdll_CreateError,                 "WsCreateError" )
      WSLOAD( webservicesdll_FreeError,                   "WsFreeError" )
      WSLOAD( webservicesdll_GetErrorProperty,            "WsGetErrorProperty" )
      WSLOAD( webservicesdll_GetErrorString,              "WsGetErrorString" )
      WSLOAD( webservicesdll_CreateReader,                "WsCreateReader" )
      WSLOAD( webservicesdll_FreeReader,                  "WsFreeReader" )
      WSLOAD( webservicesdll_SetInput,                    "WsSetInput" )
      WSLOAD( webservicesdll_GetReaderNode,               "WsGetReaderNode" )
      WSLOAD( webservicesdll_ReadNode,                    "WsReadNode" )
      WSLOAD( webservicesdll_CreateWriter,                "WsCreateWriter" )
      WSLOAD( webservicesdll_FreeWriter,                  "WsFreeWriter" )
      WSLOAD( webservicesdll_SetOutput,                   "WsSetOutput" )
      WSLOAD( webservicesdll_StartWriterCanonicalization, "WsStartWriterCanonicalization" )
      WSLOAD( webservicesdll_EndWriterCanonicalization,   "WsEndWriterCanonicalization" )
      WSLOAD( webservicesdll_CopyNode,                    "WsCopyNode" )
#undef WSLOAD
      webservicesdll_status = ok ? 1 : -1;
   }
   return webservicesdll_status == 1;
}

/* ---------------- ncrypt.dll ---------------- */

#define NCRYPTDLL_PAD_PKCS1 0x00000002

typedef struct { LPCWSTR pszAlgId; } NCRYPTDLL_PKCS1_PADDING_INFO;
typedef LONG ( WINAPI * NCRYPTDLL_SIGNHASH )( ULONG_PTR, void *, PBYTE, DWORD, PBYTE, DWORD, DWORD *, DWORD );
typedef LONG ( WINAPI * NCRYPTDLL_FREEOBJECT )( ULONG_PTR );

static NCRYPTDLL_SIGNHASH   ncryptdll_SignHash;
static NCRYPTDLL_FREEOBJECT ncryptdll_FreeObject;
static int ncryptdll_status = 0;

static int ncryptdll_load( void )
{
   if( ncryptdll_status == 0 )
   {
      HMODULE h = LoadLibraryA( "ncrypt.dll" );

      if( h )
      {
         *( FARPROC * ) &ncryptdll_SignHash   = GetProcAddress( h, "NCryptSignHash" );
         *( FARPROC * ) &ncryptdll_FreeObject = GetProcAddress( h, "NCryptFreeObject" );
      }
      ncryptdll_status = ( ncryptdll_SignHash && ncryptdll_FreeObject ) ? 1 : -1;
   }
   return ncryptdll_status == 1;
}

/* ---------------- erros ---------------- */

static void sefaz_erro( int iCategoria, int iMensagem, const char * cCategoria, const char * cMensagem )
{
   hb_storc( cCategoria, iCategoria );
   hb_storc( cMensagem, iMensagem );
}

/* codigo do Windows na assinatura -> categoria e texto */
static void sefaz_erro_chave( int iCategoria, int iMensagem, const char * cEtapa, unsigned long nCodigo )
{
   const char * cCategoria = "certificado", * cTexto;
   char cMensagem[ 300 ];

   switch( nCodigo )
   {
      case 0x8009200BUL: cTexto = "certificado sem chave privada (instalado so o .cer, sem o PFX)"; break;
      case 0x80090016UL: cTexto = "chave privada do certificado nao encontrada"; break;
      case 0x80090010UL: cTexto = "sem permissao para usar a chave do certificado"; break;
      case 0x8010000CUL:
      case 0x80100069UL: cTexto = "token/cartao do certificado nao conectado"; break;
      case 0x8010002EUL: cTexto = "leitor do token/cartao nao encontrado"; break;
      case 0x8010006BUL: cTexto = "PIN do certificado errado"; break;
      case 0x8010006CUL: cTexto = "PIN do certificado bloqueado"; break;
      case 0x8010006EUL:
      case 0x80090036UL:
      case 0x800704C7UL:
      case 0x000004C7UL: cCategoria = "cancelado"; cTexto = "digitacao do PIN cancelada"; break;
      default:           cCategoria = "rotina"; cTexto = "erro nao previsto"; break;
   }
   hb_snprintf( cMensagem, sizeof( cMensagem ), "%s (%s 0x%08lX)", cTexto, cEtapa, nCodigo );
   sefaz_erro( iCategoria, iMensagem, cCategoria, cMensagem );
}

/* ---------------- canonicalizacao ---------------- */

typedef struct { char * buf; HB_SIZE len, cap; } SEFAZ_OUTBUF;

static HRESULT CALLBACK sefaz_c14n_write( void * state, const WEBSERVICESDLL_BYTES * buffers, ULONG count, const void * async, void * error )
{
   SEFAZ_OUTBUF * o = ( SEFAZ_OUTBUF * ) state;
   ULONG i;

   HB_SYMBOL_UNUSED( async );
   HB_SYMBOL_UNUSED( error );
   for( i = 0; i < count; i++ )
   {
      if( o->len + buffers[ i ].length > o->cap )
      {
         o->cap = ( o->len + buffers[ i ].length ) * 2 + 1024;
         o->buf = ( char * ) hb_xrealloc( o->buf, o->cap );
      }
      memcpy( o->buf + o->len, buffers[ i ].bytes, buffers[ i ].length );
      o->len += buffers[ i ].length;
   }
   return S_OK;
}

static int sefaz_c14n_achou( const WEBSERVICESDLL_XML_ELEMENT_NODE * e, const char * cId, HB_SIZE nId, const char * cTag, HB_SIZE nTag )
{
   ULONG i;

   if( cTag )
      return e->localName->length == nTag && memcmp( e->localName->bytes, cTag, nTag ) == 0;
   for( i = 0; i < e->attributeCount; i++ )
   {
      const WEBSERVICESDLL_XML_ATTRIBUTE * a = e->attributes[ i ];
      if( a->isXmlNs || a->localName->length != 2 || memcmp( a->localName->bytes, "Id", 2 ) != 0 )
         continue;
      if( a->value && a->value->textType == WEBSERVICESDLL_XML_TEXT_TYPE_UTF8 )
      {
         const WEBSERVICESDLL_XML_UTF8_TEXT * t = ( const WEBSERVICESDLL_XML_UTF8_TEXT * ) a->value;
         if( t->value.length == nId && memcmp( t->value.bytes, cId, nId ) == 0 )
            return 1;
      }
   }
   return 0;
}

/* SEFAZ_WINAPI_C14N( cXml, cId, cTag, @cCategoria, @cMensagem ) -> cCanonico ou ""
   procura o elemento com atributo Id=cId, ou o primeiro elemento cTag quando cTag informado */
HB_FUNC( SEFAZ_WINAPI_C14N )
{
   const char * cXml = hb_parc( 1 ), * cId = hb_parc( 2 );
   const char * cTag = hb_parclen( 3 ) > 0 ? hb_parc( 3 ) : NULL;
   HB_SIZE nXml = hb_parclen( 1 ), nId = hb_parclen( 2 ), nTag = hb_parclen( 3 );
   void * pErro = NULL, * pReader = NULL, * pWriter = NULL;
   WEBSERVICESDLL_XML_READER_TEXT_ENCODING   rEnc;
   WEBSERVICESDLL_XML_READER_BUFFER_INPUT    rIn;
   WEBSERVICESDLL_XML_WRITER_TEXT_ENCODING   wEnc;
   WEBSERVICESDLL_XML_WRITER_BUFFER_OUTPUT   wOut;
   WEBSERVICESDLL_XML_CANONICALIZATION_PROPERTY aProp[ 1 ];
   int nAlgoritmo = WEBSERVICESDLL_INCLUSIVE_XML_CANONICALIZATION_ALGORITHM;
   SEFAZ_OUTBUF o = { NULL, 0, 0 };
   const char * cEtapa = "inicio";
   HRESULT hr = S_OK;
   int lAchou = 0;

   hb_retc_null();
   if( ! cXml || ( ! cId && ! cTag ) )
   {
      sefaz_erro( 4, 5, "rotina", "parametros invalidos na canonicalizacao" );
      return;
   }
   if( ! webservicesdll_load() )
   {
      char cMensagem[ 128 ];
      hb_snprintf( cMensagem, sizeof( cMensagem ), "nao carregado %s", webservicesdll_falta );
      sefaz_erro( 4, 5, "rotina", cMensagem );
      return;
   }

   hr = webservicesdll_CreateError( NULL, 0, &pErro );
   if( SUCCEEDED( hr ) ) { cEtapa = "leitor"; hr = webservicesdll_CreateReader( NULL, 0, &pReader, pErro ); }
   if( SUCCEEDED( hr ) )
   {
      memset( &rEnc, 0, sizeof( rEnc ) );
      rEnc.encoding.encodingType = WEBSERVICESDLL_XML_READER_ENCODING_TYPE_TEXT;
      rEnc.charSet = WEBSERVICESDLL_CHARSET_AUTO;
      memset( &rIn, 0, sizeof( rIn ) );
      rIn.input.inputType = WEBSERVICESDLL_XML_READER_INPUT_TYPE_BUFFER;
      rIn.encodedData = ( void * ) cXml;
      rIn.encodedDataSize = ( ULONG ) nXml;
      hr = webservicesdll_SetInput( pReader, &rEnc.encoding, &rIn.input, NULL, 0, pErro );
   }
   cEtapa = "leitura do XML";
   while( SUCCEEDED( hr ) )
   {
      const WEBSERVICESDLL_XML_NODE * pNode;
      hr = webservicesdll_GetReaderNode( pReader, &pNode, pErro );
      if( FAILED( hr ) || pNode->nodeType == WEBSERVICESDLL_XML_NODE_TYPE_EOF )
         break;
      if( pNode->nodeType == WEBSERVICESDLL_XML_NODE_TYPE_ELEMENT &&
          sefaz_c14n_achou( ( const WEBSERVICESDLL_XML_ELEMENT_NODE * ) pNode, cId, nId, cTag, nTag ) )
      {
         lAchou = 1;
         break;
      }
      hr = webservicesdll_ReadNode( pReader, pErro );
   }
   if( SUCCEEDED( hr ) && ! lAchou )
   {
      char cMensagem[ 128 ];
      hb_snprintf( cMensagem, sizeof( cMensagem ), cTag ? "nao encontrado %s" : "nao encontrado Id=%s", cTag ? cTag : cId );
      sefaz_erro( 4, 5, "documento", cMensagem );
      hr = S_FALSE;
   }
   if( hr == S_OK ) { cEtapa = "escritor"; hr = webservicesdll_CreateWriter( NULL, 0, &pWriter, pErro ); }
   if( hr == S_OK )
   {
      memset( &wEnc, 0, sizeof( wEnc ) );
      wEnc.encoding.encodingType = WEBSERVICESDLL_XML_WRITER_ENCODING_TYPE_TEXT;
      wEnc.charSet = WEBSERVICESDLL_CHARSET_UTF8;
      memset( &wOut, 0, sizeof( wOut ) );
      wOut.output.outputType = WEBSERVICESDLL_XML_WRITER_OUTPUT_TYPE_BUFFER;
      hr = webservicesdll_SetOutput( pWriter, &wEnc.encoding, &wOut.output, NULL, 0, pErro );
   }
   if( hr == S_OK )
   {
      cEtapa = "canonicalizacao";
      aProp[ 0 ].id = WEBSERVICESDLL_XML_CANONICALIZATION_PROPERTY_ALGORITHM;
      aProp[ 0 ].value = &nAlgoritmo;
      aProp[ 0 ].valueSize = sizeof( nAlgoritmo );
      hr = webservicesdll_StartWriterCanonicalization( pWriter, sefaz_c14n_write, &o, aProp, 1, pErro );
   }
   if( hr == S_OK ) { cEtapa = "copia do elemento"; hr = webservicesdll_CopyNode( pWriter, pReader, pErro ); }
   if( hr == S_OK ) { cEtapa = "fim da canonicalizacao"; hr = webservicesdll_EndWriterCanonicalization( pWriter, pErro ); }

   if( hr == S_OK )
   {
      hb_retclen( o.buf ? o.buf : "", o.len );
      sefaz_erro( 4, 5, "", "" );
   }
   else if( FAILED( hr ) )
   {
      char cMensagem[ 600 ], cTexto[ 400 ] = "";
      ULONG nQtd = 0;
      WEBSERVICESDLL_STRING sTexto;

      if( pErro && SUCCEEDED( webservicesdll_GetErrorProperty( pErro, WEBSERVICESDLL_ERROR_PROPERTY_STRING_COUNT, &nQtd, sizeof( nQtd ) ) ) &&
          nQtd > 0 && SUCCEEDED( webservicesdll_GetErrorString( pErro, 0, &sTexto ) ) )
      {
         ULONG i, n = 0;
         for( i = 0; i < sTexto.length && n < sizeof( cTexto ) - 1; i++ )
            cTexto[ n++ ] = ( char ) ( sTexto.chars[ i ] < 256 ? sTexto.chars[ i ] : '?' );
         cTexto[ n ] = '\0';
      }
      hb_snprintf( cMensagem, sizeof( cMensagem ), "%s %s(%s 0x%08lX)", hr == WEBSERVICESDLL_E_INVALID_FORMAT ? "XML mal formado:" : "erro",
                   cTexto, cEtapa, ( unsigned long ) hr );
      sefaz_erro( 4, 5, hr == WEBSERVICESDLL_E_INVALID_FORMAT ? "documento" : "rotina", cMensagem );
   }
   if( o.buf )
      hb_xfree( o.buf );
   if( pWriter )
      webservicesdll_FreeWriter( pWriter );
   if( pReader )
      webservicesdll_FreeReader( pReader );
   if( pErro )
      webservicesdll_FreeError( pErro );
}

/* ---------------- certificado e assinatura ---------------- */

static void sefaz_thumbprint( PCCERT_CONTEXT pCert, char * cThumb )
{
   BYTE aHash[ 20 ];
   DWORD nLen = sizeof( aHash ), i;

   cThumb[ 0 ] = '\0';
   if( CertGetCertificateContextProperty( pCert, CERT_HASH_PROP_ID, aHash, &nLen ) )
      for( i = 0; i < nLen; i++ )
         hb_snprintf( cThumb + i * 2, 3, "%02X", aHash[ i ] );
}

/* mesmo criterio do CapicomCertificado(): nome contido no SubjectName ou thumbprint igual;
   prefere dentro da validade e, entre os validos, o "PJ A1" */
static PCCERT_CONTEXT sefaz_acha_certificado( HCERTSTORE hStore, const char * cNome, int * lVencido )
{
   PCCERT_CONTEXT pCert = NULL, pValido = NULL, pVencido = NULL;
   char cSubject[ 1024 ], cThumb[ 41 ];

   while( ( pCert = CertEnumCertificatesInStore( hStore, pCert ) ) != NULL )
   {
      CertNameToStrA( X509_ASN_ENCODING, &pCert->pCertInfo->Subject, CERT_X500_NAME_STR, cSubject, sizeof( cSubject ) );
      sefaz_thumbprint( pCert, cThumb );
      if( strstr( cSubject, cNome ) == NULL && hb_stricmp( cThumb, cNome ) != 0 )
         continue;
      if( CertVerifyTimeValidity( NULL, pCert->pCertInfo ) != 0 )
      {
         if( pVencido == NULL )
            pVencido = CertDuplicateCertificateContext( pCert );
      }
      else if( pValido == NULL || strstr( cSubject, "PJ A1" ) != NULL )
      {
         if( pValido )
            CertFreeCertificateContext( pValido );
         pValido = CertDuplicateCertificateContext( pCert );
      }
   }
   *lVencido = ( pValido == NULL && pVencido != NULL );
   if( pValido )
   {
      if( pVencido )
         CertFreeCertificateContext( pVencido );
      return pValido;
   }
   return pVencido;
}

/* SEFAZ_WINAPI_ASSINA( cCertificado, cHashSha1, @cCertDer, @cCategoria, @cMensagem ) -> cAssinatura ou ""
   cCertificado = parte do nome (CN) ou thumbprint; cHashSha1 = 20 bytes; assinatura em big-endian */
HB_FUNC( SEFAZ_WINAPI_ASSINA )
{
   const char * cNome = hb_parc( 1 ), * cHash = hb_parc( 2 );
   HCERTSTORE hStore;
   PCCERT_CONTEXT pCert;
   ULONG_PTR hChave = 0;
   DWORD nSpec = 0, nAssinatura = 0;
   BOOL lLiberar = FALSE;
   BYTE * pAssinatura = NULL;
   int lVencido = 0, lOk = 0;

   hb_retc_null();
   if( ! cNome || hb_parclen( 1 ) == 0 || hb_parclen( 2 ) != 20 )
   {
      sefaz_erro( 4, 5, "rotina", "parametros invalidos na assinatura" );
      return;
   }
   hStore = CertOpenStore( CERT_STORE_PROV_SYSTEM_A, 0, 0, CERT_SYSTEM_STORE_CURRENT_USER | CERT_STORE_READONLY_FLAG, "MY" );
   if( ! hStore )
   {
      char cMensagem[ 100 ];
      hb_snprintf( cMensagem, sizeof( cMensagem ), "erro abrindo certificados do Windows (0x%08lX)", ( unsigned long ) GetLastError() );
      sefaz_erro( 4, 5, "rotina", cMensagem );
      return;
   }
   pCert = sefaz_acha_certificado( hStore, cNome, &lVencido );
   if( ! pCert )
   {
      CertCloseStore( hStore, 0 );
      sefaz_erro( 4, 5, "certificado", "certificado nao encontrado no Windows" );
      return;
   }
   if( lVencido )
   {
      SYSTEMTIME st;
      char cMensagem[ 100 ];
      FileTimeToSystemTime( &pCert->pCertInfo->NotAfter, &st );
      hb_snprintf( cMensagem, sizeof( cMensagem ), "certificado venceu em %02d/%02d/%04d", st.wDay, st.wMonth, st.wYear );
      sefaz_erro( 4, 5, "certificado", cMensagem );
   }
   else if( ! CryptAcquireCertificatePrivateKey( pCert, CRYPT_ACQUIRE_ALLOW_NCRYPT_KEY_FLAG, NULL, ( void * ) &hChave, &nSpec, &lLiberar ) )
      sefaz_erro_chave( 4, 5, "chave", ( unsigned long ) GetLastError() );
   else if( nSpec == CERT_NCRYPT_KEY_SPEC )
   {
      if( ! ncryptdll_load() )
         sefaz_erro( 4, 5, "rotina", "nao carregado ncrypt.dll" );
      else
      {
         NCRYPTDLL_PKCS1_PADDING_INFO oPadding;
         LONG nStatus;

         oPadding.pszAlgId = L"SHA1";
         nStatus = ncryptdll_SignHash( hChave, &oPadding, ( PBYTE ) cHash, 20, NULL, 0, &nAssinatura, NCRYPTDLL_PAD_PKCS1 );
         if( nStatus == 0 )
         {
            pAssinatura = ( BYTE * ) hb_xgrab( nAssinatura );
            nStatus = ncryptdll_SignHash( hChave, &oPadding, ( PBYTE ) cHash, 20, pAssinatura, nAssinatura, &nAssinatura, NCRYPTDLL_PAD_PKCS1 );
         }
         if( nStatus == 0 )
            lOk = 1;
         else
            sefaz_erro_chave( 4, 5, "NCryptSignHash", ( unsigned long ) nStatus );
      }
      if( lLiberar && ncryptdll_FreeObject )
         ncryptdll_FreeObject( hChave );
   }
   else
   {
      HCRYPTHASH hHash = 0;
      DWORD i;

      if( ! CryptCreateHash( ( HCRYPTPROV ) hChave, CALG_SHA1, 0, 0, &hHash ) ||
          ! CryptSetHashParam( hHash, HP_HASHVAL, ( BYTE * ) cHash, 0 ) ||
          ! CryptSignHashA( hHash, nSpec, NULL, 0, NULL, &nAssinatura ) )
         sefaz_erro_chave( 4, 5, "CryptSignHash", ( unsigned long ) GetLastError() );
      else
      {
         pAssinatura = ( BYTE * ) hb_xgrab( nAssinatura );
         if( ! CryptSignHashA( hHash, nSpec, NULL, 0, pAssinatura, &nAssinatura ) )
            sefaz_erro_chave( 4, 5, "CryptSignHash", ( unsigned long ) GetLastError() );
         else
         {
            /* CryptoAPI devolve little-endian */
            for( i = 0; i < nAssinatura / 2; i++ )
            {
               BYTE b = pAssinatura[ i ];
               pAssinatura[ i ] = pAssinatura[ nAssinatura - 1 - i ];
               pAssinatura[ nAssinatura - 1 - i ] = b;
            }
            lOk = 1;
         }
      }
      if( hHash )
         CryptDestroyHash( hHash );
      if( lLiberar )
         CryptReleaseContext( ( HCRYPTPROV ) hChave, 0 );
   }

   hb_storclen( ( const char * ) pCert->pbCertEncoded, pCert->cbCertEncoded, 3 );
   if( lOk )
   {
      hb_retclen( ( const char * ) pAssinatura, nAssinatura );
      sefaz_erro( 4, 5, "", "" );
   }
   if( pAssinatura )
      hb_xfree( pAssinatura );
   CertFreeCertificateContext( pCert );
   CertCloseStore( hStore, 0 );
}
