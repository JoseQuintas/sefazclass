/*
test

2021.08.23 - BEGIN SEQUENCE estava impedindo seleção de certificado
*/

REQUEST HB_CODEPAGE_PTISO

#include "inkey.ch"
#include "set.ch"
#include "hbgtinfo.ch"
#include "directry.ch"
#include "sefazclass.ch"

#ifndef WIN_SW_SHOWNORMAL
#define WIN_SW_SHOWNORMAL 0
#endif

#define OPC_DANFE           1
#define OPC_CERTIFICADO     2
#define OPC_CERT_VALIDADE   3
#define OPC_UF              4
#define OPC_AMBIENTE        5
#define OPC_NFCE            6
#define OPC_STATUS_NFE      7
#define OPC_STATUS_CTE      8
#define OPC_STATUS_CTE4     9
#define OPC_STATUS_MDFE     10
#define OPC_CADASTRO        11
#define OPC_PROTOCOLO_NFE   12
#define OPC_PROTOCOLO_CTE   13
#define OPC_PROTOCOLO_MDFE  14
#define OPC_DESTINADAS      15
#define OPC_VALIDA_XML      16
#define OPC_ASSINA_TESTE    17
#define OPC_ASSINA_USUARIO  18
#define OPC_CONSULTA_RECIBO 19
#define OPC_ENVIO_TESTE     20
#define OPC_ENVIO_USUARIO   21
#define OPC_MANIFESTACAO    22
#define OPC_DOWNLOAD_NFE    23
#define OPC_CERT_REMOVE     24
#define OPC_STATUSGERAL     25

#define VAR_CERTIFICADO 1
#define VAR_UF          2
#define VAR_AMBIENTE    3
#define VAR_NFCE        4
#define VAR_EVENTO      5
#define VAR_CNPJ        6
#define VAR_CHAVE       7
#define VAR_RECIBO      8
#define VAR_VALIDFROM   9

MEMVAR aVarList, oSefaz

FUNCTION Main( cXmlDocumento, cLogoFile, cXmlAuxiliar )

   LOCAL nOpc := 1, GetList := {}, cTexto := "", cUF, cAmbiente
   LOCAL cXml, cXmlRetorno, cFileName
   PRIVATE aVarList, oSefaz

   aVarList := Array( 11 )
   aVarList[ VAR_CERTIFICADO ] := ""
   aVarList[ VAR_UF ]          := "SP"
   aVarList[ VAR_AMBIENTE ]    := WS_AMBIENTE_HOMOLOGACAO
   aVarList[ VAR_NFCE ]        := "N"
   aVarList[ VAR_EVENTO ]      := "210210"
   aVarList[ VAR_CNPJ ]        := Space(14)
   aVarList[ VAR_CHAVE ]       := Space(44)
   aVarList[ VAR_RECIBO ]      := Space(20)

   SetupHarbour()

   SetColor( "W/B,N/W,,,W/B" )

   IF cXmlDocumento != Nil
      DanfeAutomatico( cXmlDocumento, cLogoFile, cXmlAuxiliar )
      RETURN Nil
   ENDIF

   DO WHILE .T.
      oSefaz := SefazClass():New()
      oSefaz:cUF          := aVarList[ VAR_UF ]
      oSefaz:cCertificado := aVarList[ VAR_CERTIFICADO ]
      oSefaz:cAmbiente    := aVarList[ VAR_AMBIENTE ]
      oSefaz:cNFCE        := aVarList[ VAR_NFCE ]

      CLS
      @ Row() + 1, 5 PROMPT Str( OPC_DANFE, 2 )           + "-Teste Danfe (path atual)"
      @ Row() + 1, 5 PROMPT Str( OPC_CERTIFICADO, 2 )     + "-Seleciona certificado (atual=" + aVarList[ VAR_CERTIFICADO ] + ")"
      @ Row() + 1, 5 PROMPT Str( OPC_CERT_VALIDADE, 2 )   + "-Validade do certificado"
      @ Row() + 1, 5 PROMPT Str( OPC_UF, 2 )              + "-UF (atual=" + aVarList[ VAR_UF ] + ")"
      @ Row() + 1, 5 PROMPT Str( OPC_AMBIENTE, 2 )        + "-Ambiente (atual=" + iif( aVarList[ VAR_AMBIENTE ] == WS_AMBIENTE_PRODUCAO, "Produção", "Homologação" ) + ")"
      @ Row() + 1, 5 PROMPT Str( OPC_NFCE, 2 )            + "-Nota (atual=" + iif( aVarList[ VAR_NFCE ] == "S", "NFCE", "NFE" ) + ")"
      @ Row() + 1, 5 PROMPT Str( OPC_STATUS_NFE, 2 )      + "-Consulta Status NFE"
      @ Row() + 1, 5 PROMPT Str( OPC_STATUS_CTE, 2 )      + "-Consulta Status CTE"
      @ Row() + 1, 5 PROMPT Str( OPC_STATUS_CTE4, 2 )     + "-Consulta Status CTE 4.0"
      @ Row() + 1, 5 PROMPT Str( OPC_STATUS_MDFE, 2 )     + "-Consulta Status MDFE"
      @ Row() + 1, 5 PROMPT Str( OPC_CADASTRO, 2 )        + "-Consulta Cadastro NFE (digitado)"
      @ Row() + 1, 5 PROMPT Str( OPC_PROTOCOLO_NFE, 2 )   + "-Protocolo NFE (digitado)"
      @ Row() + 1, 5 PROMPT Str( OPC_PROTOCOLO_CTE, 2 )   + "-Protocolo CTE 3.00 (digitado)"
      @ Row() + 1, 5 PROMPT Str( OPC_PROTOCOLO_MDFE, 2 )  + "-Protocolo MDFE 3.00 (digitado)"
      @ Row() + 1, 5 PROMPT Str( OPC_DESTINADAS, 2 )      + "-Consulta Destinadas (digitado)"
      @ Row() + 1, 5 PROMPT Str( OPC_VALIDA_XML, 2 )      + "-Valida XML (Basico) (disco)"
      @ Row() + 1, 5 PROMPT Str( OPC_ASSINA_TESTE, 2 )    + "-Assinatura - arquivo teste"
      @ Row() + 1, 5 PROMPT Str( OPC_ASSINA_USUARIO, 2 )  + "-Assinatura - arquivo do usuário (disco)"
      @ Row() + 1, 5 PROMPT Str( OPC_CONSULTA_RECIBO, 2 ) + "-Consulta Recibo - número do usuário"
      @ Row() + 1, 5 PROMPT Str( OPC_ENVIO_TESTE, 2 )     + "-Envio de XML de teste"
      @ Row() + 1, 5 PROMPT Str( OPC_ENVIO_USUARIO, 2 )   + "-Envio de XML do usuário (disco)"
      @ Row() + 1, 5 PROMPT Str( OPC_MANIFESTACAO, 2 )    + "-Manifestacao Destinatario (digitado)"
      @ Row() + 1, 5 PROMPT Str( OPC_DOWNLOAD_NFE, 2 )    + "-Download DFE (Documentos) (digitado)"
      @ Row() + 1, 5 PROMPT Str( OPC_CERT_REMOVE, 2 )     + "-Remove Certificado"
      @ Row() + 1, 5 PROMPT Str( OPC_STATUSGERAL, 2 )     + "-Status Geral"
      MENU TO nOpc
      DO CASE
      CASE LastKey() == K_ESC
         EXIT

      CASE nOpc == OPC_DANFE
         TestDanfe()

      CASE nOpc == OPC_CERTIFICADO
         CertificadoEscolhe( @aVarList[ VAR_CERTIFICADO ] )
         LOOP

      CASE nOpc == OPC_CERT_VALIDADE
         CertificadoValidade( aVarList[ VAR_CERTIFICADO ] )

      CASE nOpc == OPC_UF
         DigitaUF( @avarList[ VAR_UF ] )

      CASE nOpc == OPC_AMBIENTE
         aVarList[ VAR_AMBIENTE ] := iif( aVarList[ VAR_AMBIENTE ] == WS_AMBIENTE_PRODUCAO, WS_AMBIENTE_HOMOLOGACAO, WS_AMBIENTE_PRODUCAO )

      CASE nOpc == OPC_NFCE
         aVarList[ VAR_NFCE ] := iif( aVarList[ VAR_NFCE ] == "S", "N", "S" )

      CASE nOpc == OPC_STATUS_NFE
         cXmlRetorno := oSefaz:NfeStatusServico()
         //wapi_MessageBox( , oSefaz:cXmlSoap, "XML enviado" )
         wapi_MessageBox( , oSefaz:cXmlRetorno, "XML retornado" )
         cTexto := "Tipo Ambiente:"     + XmlNode( cXmlRetorno, "tpAmb" )    + hb_Eol()
         cTexto += "Versão Aplicativo:" + XmlNode( cXmlRetorno, "verAplic" ) + hb_Eol()
         cTexto += "Status:"            + XmlNode( cXmlRetorno, "cStat" )    + hb_Eol()
         cTexto += "Motivo:"            + XmlNode( cXmlRetorno, "xMotivo" )  + hb_Eol()
         cTexto += "UF:"                + XmlNode( cXmlRetorno, "cUF" )      + hb_Eol()
         cTexto += "Data/Hora:"         + XmlNode( cXmlRetorno, "dhRecbto" ) + hb_Eol()
         cTexto += "Tempo Médio:"       + XmlNode( cXmlRetorno, "tMed" )     + hb_Eol()
         wapi_MessageBox( , cTexto, "Informação Extraída" )

      CASE nOpc == OPC_STATUS_CTE
         oSefaz:cVersao := "3.00"
         cXmlRetorno := oSefaz:CteStatusServico()
         //wapi_MessageBox( , oSefaz:cXmlSoap, "XML enviado" )
         wapi_MessageBox( , oSefaz:cXmlRetorno, "XML retornado" )
         cTexto := "Tipo Ambiente:"     + XmlNode( cXmlRetorno, "tpAmb" )    + hb_Eol()
         cTexto += "Versão Aplicativo:" + XmlNode( cXmlRetorno, "verAplic" ) + hb_Eol()
         cTexto += "Status:"            + XmlNode( cXmlRetorno, "cStat" )    + hb_Eol()
         cTexto += "Motivo:"            + XmlNode( cXmlRetorno, "xMotivo" )  + hb_Eol()
         cTexto += "UF:"                + XmlNode( cXmlRetorno, "cUF" )      + hb_Eol()
         cTexto += "Data/Hora:"         + XmlNode( cXmlRetorno, "dhRecbto" ) + hb_Eol()
         cTexto += "Tempo Médio:"       + XmlNode( cXmlRetorno, "tMed" )     + hb_Eol()
         wapi_MessageBox( , cTexto, "Informação Extraída" )

      CASE nOpc == OPC_STATUS_CTE4
         oSefaz:cVersao := "4.00"
         cXmlRetorno := oSefaz:CteStatusServico()
         wapi_MessageBox( , oSefaz:cXmlSoap, "XML enviado" )
         wapi_MessageBox( , oSefaz:cXmlRetorno, "XML retornado" )
         cTexto := "Tipo Ambiente:"     + XmlNode( cXmlRetorno, "tpAmb" )    + hb_Eol()
         cTexto += "Versão Aplicativo:" + XmlNode( cXmlRetorno, "verAplic" ) + hb_Eol()
         cTexto += "Status:"            + XmlNode( cXmlRetorno, "cStat" )    + hb_Eol()
         cTexto += "Motivo:"            + XmlNode( cXmlRetorno, "xMotivo" )  + hb_Eol()
         cTexto += "UF:"                + XmlNode( cXmlRetorno, "cUF" )      + hb_Eol()
         cTexto += "Data/Hora:"         + XmlNode( cXmlRetorno, "dhRecbto" ) + hb_Eol()
         cTexto += "Tempo Médio:"       + XmlNode( cXmlRetorno, "tMed" )     + hb_Eol()
         wapi_MessageBox( , cTexto, "Informação Extraída" )

      CASE nOpc == OPC_STATUS_MDFE
         oSefaz:cVersao := "3.00"
         cXmlRetorno := oSefaz:MdfeStatusServico()
         //wapi_MessageBox( , oSefaz:cXmlSoap, "XML enviado" )
         wapi_MessageBox( , oSefaz:cXmlRetorno, "XML retornado" )
         cTexto := "Tipo Ambiente:"     + XmlNode( cXmlRetorno, "tpAmb" )    + hb_Eol()
         cTexto += "Versão Aplicativo:" + XmlNode( cXmlRetorno, "verAplic" ) + hb_Eol()
         cTexto += "Status:"            + XmlNode( cXmlRetorno, "cStat" )    + hb_Eol()
         cTexto += "Motivo:"            + XmlNode( cXmlRetorno, "xMotivo" )  + hb_Eol()
         cTexto += "UF:"                + XmlNode( cXmlRetorno, "cUF" )      + hb_Eol()
         cTexto += "Data/Hora:"         + XmlNode( cXmlRetorno, "dhRecbto" ) + hb_Eol()
         cTexto += "Tempo Médio:"       + XmlNode( cXmlRetorno, "tMed" )     + hb_Eol()
         wapi_MessageBox( , cTexto, "Informação Extraída" )

      CASE nOpc == OPC_CADASTRO
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 0 SAY "UF"   GET aVarList[ VAR_UF ] PICTURE "@!"
         @ 9, 0 SAY "CNPJ" GET aVarList[ VAR_CNPJ ] PICTURE "@R 99.999.999/9999-99"
         READ
         IF LastKey() == K_ESC
            LOOP
         ENDIF
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         oSefaz:cProjeto := "nfe"
         cXmlRetorno := oSefaz:NfeConsultaCadastro( aVarList[ VAR_CNPJ ], aVarList[ VAR_UF ] )
         wapi_MessageBox( , oSefaz:cXmlSoap, "XML Enviado" )
         wapi_MessageBox( , oSefaz:cXmlRetorno, "XML Retornado" )
         cTexto := "versao:    " + XmlNode( cXmlRetorno, "versao" )   + hb_Eol()
         cTexto += "Aplicativo:" + XmlNode( cXmlRetorno, "verAplic" ) + hb_Eol()
         cTexto += "Status:    " + XmlNode( cXmlRetorno, "cStat" )    + hb_Eol()
         cTexto += "Motivo:    " + XmlNode( cXmlRetorno, "xMotivo" )  + hb_Eol()
         cTexto += "UF:        " + XmlNode( cXmlRetorno, "UF" )       + hb_Eol()
         cTexto += "IE:        " + XmlNode( cXmlRetorno, "IE" )       + hb_Eol()
         cTexto += "CNPJ:      " + XmlNode( cXmlRetorno, "CNPJ" )     + hb_Eol()
         cTexto += "CPF:       " + XmlNode( cXmlRetorno, "CPF" )      + hb_Eol()
         cTexto += "Data/Hora: " + XmlNode( cXmlRetorno, "dhCons" )   + hb_Eol()
         cTexto += "UF:        " + XmlNode( cXmlRetorno, "cUF" )      + hb_Eol()
         cTexto += "Nome(1):   " + XmlNode( cXmlRetorno, "xNome" )    + hb_Eol()
         cTexto += "CNAE(1):   " + XmlNode( cXmlRetorno, "CNAE" )     + hb_Eol()
         cTexto += "Lograd(1): " + XmlNode( cXmlRetorno, "xLgr" )     + hb_Eol()
         cTexto += "nro(1):    " + XmlNode( cXmlRetorno, "nro" )      + hb_Eol()
         cTexto += "Compl(1):  " + XmlNode( cXmlRetorno, "xCpl" )     + hb_Eol()
         cTexto += "Bairro(1): " + XmlNode( cXmlRetorno, "xBairro" )  + hb_Eol()
         cTexto += "Cod.Mun(1):" + XmlNode( cXmlRetorno, "cMun" )     + hb_Eol()
         cTexto += "Municip(1):" + XmlNode( cXmlRetorno, "xMun" )     + hb_Eol()
         cTexto += "CEP(1):    " + XmlNode( cXmlRetorno, "CEP" )      + hb_Eol()
         cTexto += "Etc pode ter vários endereços..."
         wapi_MessageBox( , cTexto, "Informação Extraída" )

      CASE nOpc == OPC_PROTOCOLO_NFE
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 1 GET aVarList[ VAR_CHAVE ] PICTURE "@R 99-99/99-99.999.999/9999-99.99.999.999999999.9.99999999.9"
         READ
         IF LastKey() == K_ESC
            EXIT
         ENDIF
         oSefaz:NfeConsultaProtocolo( aVarList[ VAR_CHAVE ] )
         wapi_MessageBox( , oSefaz:cXmlSoap )
         wapi_MessageBox( , oSefaz:cXmlRetorno )

      CASE nOpc == OPC_PROTOCOLO_CTE
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 1 GET aVarList[ VAR_CHAVE ] PICTURE "@R 99-99/99-99.999.999/9999-99.99.999.999999999.9.99999999.9"
         READ
         IF LastKey() == K_ESC
            EXIT
         ENDIF
         oSefaz:cVersao := "3.00"
         oSefaz:CteConsultaProtocolo( aVarList[ VAR_CHAVE ] )
         wapi_MessageBox( , oSefaz:cXmlSoap )
         wapi_MessageBox( , oSefaz:cXmlRetorno )

      CASE nOpc == OPC_PROTOCOLO_MDFE
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 1 GET aVarList[ VAR_CHAVE ] PICTURE "@R 99-99/99-99.999.999/9999-99.99.999.999999999.9.99999999.9"
         READ
         IF LastKey() == K_ESC
            EXIT
         ENDIF
         oSefaz:cVersao := "3.00"
         oSefaz:MDFeConsultaProtocolo( aVarList[ VAR_CHAVE ] )
         wapi_MessageBox( , oSefaz:cXmlSoap )
         wapi_MessageBox( , oSefaz:cXmlRetorno )
         hb_MemoWrit( "consultamdfe.xml", oSefaz:cXmlRetorno )

      CASE nOpc == OPC_DESTINADAS
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 9, 1 GET aVarList[ VAR_CNPJ ] PICTURE "@9"
         READ
         IF LastKey() == K_ESC
            EXIT
         ENDIF
         oSefaz:nfeDistribuicaoDFe( aVarList[ VAR_CNPJ ], "0" )
         wapi_MessageBox( , oSefaz:cXmlSoap )
         wapi_MessageBox( , oSefaz:cXmlRetorno )

         oSefaz:nfeConsultaDest( aVarList[ VAR_CNPJ ] , "0" )
         wapi_MessageBox( , oSefaz:cXmlSoap )
         wapi_MessageBox( , oSefaz:cXmlRetorno )

      CASE nOpc == OPC_VALIDA_XML
         cXml := MemoRead( win_GetOpenFileName(, "Arquivo a validar", "importa\", "XML", "*.XML", 1 ) )
         ? oSefaz:ValidaXml( cXml ) // , "d:\cdrom\fontes\integra\schemmas\pl_008i2_cfop_externo\nfe_v3.10.xsd" )
         Inkey(0)

      CASE nOpc == OPC_ASSINA_TESTE
         oSefaz:cXmlDocumento := [<NFe><infNFe Id="Nfe0001"></infNFe></NFe>]
         oSefaz:AssinaXml()
         ? oSefaz:cXmlRetorno
         ? oSefaz:cXmlDocumento
         Inkey(0)

      CASE nOpc == OPC_CONSULTA_RECIBO
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 1 GET aVarList[ VAR_RECIBO ] PICTURE "@9"
         READ
         IF LastKey() != K_ESC .AND. ! Empty( aVarList[ VAR_RECIBO ] )
            oSefaz:NfeConsultaRecibo( aVarList[ VAR_RECIBO ] )
            ? oSefaz:cXmlRetorno
            Inkey(0)
         ENDIF

      CASE nOpc == OPC_ENVIO_TESTE
         oSefaz:NfeLoteEnvia( [<NFe><infNFe Id="Nfe0001"></infNFe></NFe>] )
         ? oSefaz:cXmlRetorno
         Inkey(0)

      CASE nOpc == OPC_ENVIO_USUARIO
         cXml := MemoRead( win_GetOpenFileName(, "Arquivo a transmitir", ".\", "XML", "*.XML", 1 ) )
         DO CASE
         CASE "<infMDFe" $ cXml ; ? "autorizando MDFE"; oSefaz:cVersao  := "3.00"; oSefaz:MDFeLoteEnvia( cXml )
         CASE "<infCTe"  $ cXml ; ? "autorizando CTE"; oSefaz:cVersao := "3.00"; oSefaz:CTeLoteEnvia( cXml )
         CASE "<infNFe"  $ cXml ; ? "autorizando NFE"; oSefaz:cVersao := "4.00"; oSefaz:NfeLoteEnvia( cXml )
         OTHERWISE              ; ? "Documento não reconhecido"
         ENDCASE
         ? oSefaz:cXmlRetorno
         hb_MemoWrit( "testeassinado.xml", oSefaz:cXmlDocumento )
         hb_MemoWrit( "testeautorizado.xml", oSefaz:cXmlAutorizado )
         Inkey(0)

      CASE nOpc == OPC_ASSINA_USUARIO
         cFileName := win_GetOpenFileName(, "Arquivo a assinar", ".\", "XML", "*.XML", 1 )
         oSefaz:cXmlDocumento := MemoRead( cFileName )
         oSefaz:AssinaXml()
         ? oSefaz:cXmlRetorno
         ? oSefaz:cXmlDocumento
         hb_MemoWrit( Substr( cFileName, 1, Rat( ".", cFileName ) - 1 ) + "-assinado.xml", oSefaz:cXmlDocumento )
         Inkey(0)

      CASE nOpc == OPC_MANIFESTACAO
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @  8, 1 GET aVarList[ VAR_CHAVE ]  PICTURE "@9"
         @  9, 1 GET aVarList[ VAR_CNPJ ]   PICTURE "@9"
         @ 10, 1 GET aVarList[ VAR_EVENTO ] PICTURE "@9" VALID aVarList[ VAR_EVENTO ] $ "210200,210210,210220,210240"
         READ
         IF LastKey() != K_ESC
            oSefaz:NfeEventoManifestacao( aVarList[ VAR_CHAVE ], aVarList[ VAR_CNPJ ], aVarList[ VAR_EVENTO ] )
            ? oSefaz:cXmlRetorno
            Inkey(0)
         ENDIF

      CASE nOpc == OPC_DOWNLOAD_NFE
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 1 GET aVarList[ VAR_CHAVE ] PICTURE "@9"
         @ 9, 1 GET aVarList[ VAR_CNPJ ] PICTURE "@9"
         READ
         IF LastKey() != K_ESC
            oSefaz:NfeDownload( aVarList[ VAR_CNPJ ], aVarList[ VAR_CHAVE ], aVarList[ VAR_CERTIFICADO ], aVarList[ VAR_AMBIENTE ] )
            ? oSefaz:cXmlRetorno
            IF oSefaz:cStatus == "138"
               hb_MemoWrit( "arquivo.zip", hb_Base64Decode( XmlNode( oSefaz:cXmlRetorno, "docZip" ) ) )
            ENDIF
            Inkey(0)
         ENDIF

      CASE nOpc == OPC_CERT_REMOVE
         CapicomRemoveCertificado( aVarList[ VAR_CERTIFICADO ] )

      CASE nOpc == OPC_STATUSGERAL
         FOR EACH cAmbiente IN { "1", "2" }
            FOR EACH cUF IN { "AM", "BA", "CE", "GO", "MG", "MS", "MT", "PE", "PR", "RS", "SP" }
               oSefaz:cUF       := cUF
               oSefaz:cAmbiente := cAmbiente
               oSefaz:NfeStatusServico()
               //? oSefaz:cXmlRetorno
               ? oSefaz:cAmbiente, oSefaz:cUF, oSefaz:cStatus
               Inkey(2)
            NEXT
         NEXT
         Inkey(0)

      ENDCASE
   ENDDO

   RETURN Nil

FUNCTION SetupHarbour()

   SetMode( 33, 80 )
   CLS
   SET DATE BRITISH
   Set( _SET_CODEPAGE, "PTISO" )
   Set( _SET_EVENTMASK, INKEY_ALL - INKEY_MOVE )
   SET CONFIRM ON

#ifndef __XHARBOUR__
   hb_gtInfo( HB_GTI_INKEYFILTER, { | nKey | MyInkeyFilter( nKey ) } ) // pra funcionar control-V
#endif

   RETURN Nil

#ifndef __XHARBOUR__
   // rotina do ctrl-v

FUNCTION MyInkeyFilter( nKey )

   LOCAL nBits, lIsKeyCtrl

   nBits := hb_GtInfo( HB_GTI_KBDSHIFTS )
   lIsKeyCtrl := ( nBits == hb_BitOr( nBits, HB_GTI_KBD_CTRL ) )
   SWITCH nKey
   CASE K_CTRL_V
      IF lIsKeyCtrl
         hb_GtInfo( HB_GTI_CLIPBOARDPASTE )
         RETURN 0
      ENDIF
   ENDSWITCH

   RETURN nKey
#endif

FUNCTION TestDanfe()

   LOCAL oDanfe, oFile, oFileList, cFilePdf

   oFileList := Directory( "*.xml" )
   FOR EACH oFile IN oFileList
      oDanfe := hbNfeDaGeral():New()
      cFilePdf := Substr( oFile[ F_NAME ], 1, At( ".", oFile[ F_NAME ] ) ) + "pdf"
      fErase( cFilePdf )
      //oDanfe:cLogoFile := JPEGImage()
      oDanfe:cDesenvolvedor := "www.jpatecnologia.com.br"
      oDanfe:lQuadroEntrega := .T.
      oDanfe:ToPDF( oFile[ F_NAME ], cFilePdf )
      ? oFile[ F_NAME ], oDanfe:cRetorno
      PDFOpen( cFilePdf )
   NEXT

   RETURN Nil

FUNCTION PDFOpen( cFile )

   IF File( cFile )
      WAPI_ShellExecute( Nil, "open", cFile, "",, WIN_SW_SHOWNORMAL )
      Inkey(1)
   ENDIF

   RETURN Nil

#ifndef __XHARBOUR__

FUNCTION JPEGImage()

#pragma __binarystreaminclude "jpatecnologia.jpg"        | RETURN %s

#endif

STATIC FUNCTION CertificadoEscolhe( cCertificado )

   LOCAL dValidFrom, dValidTo

   BEGIN SEQUENCE WITH __BreakBlock()
      cCertificado := CapicomEscolheCertificado()
      dValidFrom   := CapicomCertificado( cCertificado ):ValidFromDate
      dValidTo     := CapicomCertificado( cCertificado ):ValidToDate
      wapi_MessageBox( , "Validade " + Dtoc( dValidFrom ) + " a " + Dtoc( dValidTo ) + ;
         iif( dValidTo < Date(), "VENCIDO!!!!!!", "" ) )
   ENDSEQUENCE

   RETURN Nil

STATIC FUNCTION CertificadoValidade( cCertificado )

   LOCAL dValidFrom, dValidTo

   //BEGIN SEQUENCE WITH __BreakBlock()
   dValidFrom := CapicomCertificado( cCertificado ):ValidFromDate
   dValidTo   := CapicomCertificado( cCertificado ):ValidToDate
   wapi_MessageBox( , cCertificado + hb_Eol() + ;
      "Validade " + Dtoc( dValidFrom ) + " a " + Dtoc( dValidTo ) + ;
      iif( dValidTo < Date(), " VENCIDO!!!!!!", "" ) )
   //ENDSEQUENCE

   RETURN Nil

STATIC FUNCTION DigitaUF( cUF )

   LOCAL GetList := {}

   Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
   @ 8, 0 SAY "Qual UF:" GET cUF PICTURE "@!"
   READ

   RETURN Nil

STATIC FUNCTION DanfeAutomatico( cXmlDocumento, cLogoFile, cXmlAuxiliar )

   LOCAL hFileOutput, oDanfe, cTempFile

   IF File( cXmlDocumento )
      cXmlDocumento := MemoRead( cXmlDocumento )
   ENDIF
   IF cXmlAuxiliar != Nil
      IF File( cXmlAuxiliar )
         cXmlAuxiliar := MemoRead( cXmlAuxiliar )
      ENDIF
   ENDIF
   IF cLogoFile != Nil
      IF File( cLogoFile )
         cLogoFile := MemoRead( cLogoFile )
      ENDIF
   ENDIF
   hFileOutput := hb_FTempCreateEx( @cTempFile, hb_DirTemp(), "", ".PDF" )
   fClose( hFileOutput )
   oDanfe := hbNFeDaGeral():New()
   oDanfe:lQuadroEntrega := .T.
   oDanfe:cDesenvolvedor := "hbnfe/sefazclass"
   oDanfe:cLogoFile      := cLogoFile
   oDanfe:ToPDF( cXmlDocumento, cTempFile, cXmlAuxiliar )
   PDFOpen( cTempFile )

   RETURN Nil

FUNCTION AppVersaoExe(); RETURN ""
