REQUEST HB_CODEPAGE_PTISO

#include "inkey.ch"
#include "set.ch"
#include "hbgtinfo.ch"
#include "directry.ch"
#include "sefazclass.ch"

#ifndef WIN_SW_SHOWNORMAL
   #define WIN_SW_SHOWNORMAL 0
#endif

MEMVAR cVersao, cCertificado, cUF, cAmbiente, cNFCe, cEvento, cCnpj, cChave

FUNCTION Main( cXmlDocumento, cLogoFile, cXmlAuxiliar )

   LOCAL nOpc := 1, GetList := {}, cTexto := ""
   LOCAL cXmlRetorno
   LOCAL oSefaz, cXml, oDanfe, cTempFile, nHandle, cRecibo := Space(20)

   cVersao      := "4.00"
   cCertificado := ""
   cUF          := "SP"
   cAmbiente    := WS_AMBIENTE_HOMOLOGACAO
   cNFCe        := "N"
   cEvento      := "210210"
   cCnpj        := Space(14)
   cChave       := Space(44)

   SET DATE BRITISH
   SetupHarbour()
   SetMode( 33, 80 )
   Set( _SET_CODEPAGE, "PTISO" )
   SetColor( "W/B,N/W,,,W/B" )

   //? Extenso( Date(), .T. )
   //? Extenso( Date() )
   //? Extenso( 545454.54 )
   //? Extenso( 1000000 )
   //Inkey(0)
   IF cXmlDocumento != NIL
      IF File( cXmlDocumento )
         cXmlDocumento := MemoRead( cXmlDocumento )
      ENDIF
      IF cXmlAuxiliar != NIL
         IF File( cXmlAuxiliar )
            cXmlAuxiliar := MemoRead( cXmlAuxiliar )
         ENDIF
      ENDIF
      IF cLogoFile != NIL
         IF File( cLogoFile )
            cLogoFile := MemoRead( cLogoFile )
         ENDIF
      ENDIF
      nHandle := hb_FTempCreateEx( @cTempFile, hb_DirTemp(), "", ".PDF" )
      fClose( nHandle )
      oDanfe := hbNFeDaGeral():New()
      oDanfe:cDesenvolvedor := "JoséQuintas"
      oDanfe:cLogoFile      := cLogoFile
      oDanfe:ToPDF( cXmlDocumento, cTempFile, cXmlAuxiliar )
      PDFOpen( cTempFile )
      RETURN NIL
   ENDIF

   DO WHILE .T.
      oSefaz              := SefazClass():New()
      oSefaz:cUF          := cUF
      oSefaz:cVersao      := cVersao
      oSefaz:cCertificado := cCertificado
      oSefaz:cAmbiente    := cAmbiente
      oSefaz:cNFCe        := cNFCe

      CLS
      @ Row() + 1, 5 PROMPT "01-Teste Danfe"
      @ Row() + 1, 5 PROMPT "02-Seleciona certificado (atual=" + cCertificado + ")"
      @ Row() + 1, 5 PROMPT "03-UF (atual=" + cUF + ")"
      @ Row() + 1, 5 PROMPT "04-Versao NFE (atual=" + cVersao + ")"
      @ Row() + 1, 5 PROMPT "05-Ambiente (atual=" + iif( cAmbiente == WS_AMBIENTE_PRODUCAO, "Produção", "Homologação" ) + ")"
      @ Row() + 1, 5 PROMPT "06-Nota (atual=" + iif( cNFCe == "S", "NFCE", "NFE" ) + ")"
      @ Row() + 1, 5 PROMPT "07-Consulta Status NFE"
      @ Row() + 1, 5 PROMPT "08-Consulta Cadastro NFE"
      @ Row() + 1, 5 PROMPT "09-Protocolo NFE"
      @ Row() + 1, 5 PROMPT "10-Protocolo CTE 3.00"
      @ Row() + 1, 5 PROMPT "11-Protocolo MDFE 3.00"
      @ Row() + 1, 5 PROMPT "12-Consulta Destinadas"
      @ Row() + 1, 5 PROMPT "13-Valida XML (Basico)"
      @ Row() + 1, 5 PROMPT "14-Teste de assinatura"
      @ Row() + 1, 5 PROMPT "15-Consulta Recibo"
      @ Row() + 1, 5 PROMPT "16-Envio de XML*"
      @ Row() + 1, 5 PROMPT "17-Envio de arquivo NFe/CTe/MDFe em disco"
      @ Row() + 1, 5 PROMPT "18-Assinatura arquivo externo (esocial,etc)"
      @ Row() + 1, 5 PROMPT "19-Manifestacao Destinatario"
      @ Row() + 1, 5 PROMPT "20-Download DFE (Documentos)"
      MENU TO nOpc
      DO CASE
      CASE LastKey() == K_ESC
         EXIT

      CASE nOpc == 1
         TestDanfe()

      CASE nOpc == 2
         cCertificado := CapicomEscolheCertificado()
         wapi_MessageBox( , cCertificado )
         LOOP

      CASE nOpc == 3
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 0 SAY "Qual UF:" GET cUF PICTURE "@!"
         READ

      CASE nOpc == 4
         cVersao := iif( cVersao == "3.10", "4.00", "3.10" )

      CASE nOpc == 5
         cAmbiente := iif( cAmbiente == WS_AMBIENTE_PRODUCAO, WS_AMBIENTE_HOMOLOGACAO, WS_AMBIENTE_PRODUCAO )

      CASE nOpc == 6
         cNFCe := iif( cNFCe == "S", "N", "S" )

      CASE nOpc == 7
         cXmlRetorno := oSefaz:NfeStatusServico()
         //wapi_MessageBox( , oSefaz:cXmlSoap, "XML enviado" )
         wapi_MessageBox( , oSefaz:cXmlRetorno, "XML retornado" )
         cTexto := "Tipo Ambiente:"     + XmlNode( cXmlRetorno, "tpAmb" ) + hb_Eol()
         cTexto += "Versão Aplicativo:" + XmlNode( cXmlRetorno, "verAplic" ) + hb_Eol()
         cTexto += "Status:"            + XmlNode( cXmlRetorno, "cStat" ) + hb_Eol()
         cTexto += "Motivo:"            + XmlNode( cXmlRetorno, "xMotivo" ) + hb_Eol()
         cTexto += "UF:"                + XmlNode( cXmlRetorno, "cUF" ) + hb_Eol()
         cTexto += "Data/Hora:"         + XmlNode( cXmlRetorno, "dhRecbto" ) + hb_Eol()
         cTexto += "Tempo Médio:"       + XmlNode( cXmlRetorno, "tMed" ) + hb_Eol()
         wapi_MessageBox( , cTexto, "Informação Extraída" )

      CASE nOpc == 8
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 0 SAY "UF"   GET cUF PICTURE "@!"
         @ 9, 0 SAY "CNPJ" GET cCnpj PICTURE "@R 99.999.999/9999-99"
         READ
         IF LastKey() == K_ESC
            LOOP
         ENDIF
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         oSefaz:cProjeto := "nfe"
         cXmlRetorno := oSefaz:NfeConsultaCadastro( cCnpj, cUF )
         wapi_MessageBox( , oSefaz:cXmlSoap, "XML Enviado" )
         wapi_MessageBox( , oSefaz:cXmlRetorno, "XML Retornado" )
         cTexto := "versao:    " + XmlNode( cXmlRetorno, "versao" ) + hb_Eol()
         cTexto += "Aplicativo:" + XmlNode( cXmlRetorno, "verAplic" ) + hb_Eol()
         cTexto += "Status:    " + XmlNode( cXmlRetorno, "cStat" ) + hb_Eol()
         cTexto += "Motivo:    " + XmlNode( cXmlRetorno, "xMotivo" ) + hb_Eol()
         cTexto += "UF:        " + XmlNode( cXmlRetorno, "UF" ) + hb_Eol()
         cTexto += "IE:        " + XmlNode( cXmlRetorno, "IE" ) + hb_Eol()
         cTexto += "CNPJ:      " + XmlNode( cXmlRetorno, "CNPJ" ) + hb_Eol()
         cTexto += "CPF:       " + XmlNode( cXmlRetorno, "CPF" ) + hb_Eol()
         cTexto += "Data/Hora: " + XmlNode( cXmlRetorno, "dhCons" ) + hb_Eol()
         cTexto += "UF:        " + XmlNode( cXmlRetorno, "cUF" ) + hb_Eol()
         cTexto += "Nome(1):   " + XmlNode( cXmlRetorno, "xNome" ) + hb_Eol()
         cTexto += "CNAE(1):   " + XmlNode( cXmlRetorno, "CNAE" ) + hb_Eol()
         cTexto += "Lograd(1): " + XmlNode( cXmlRetorno, "xLgr" ) + hb_Eol()
         cTexto += "nro(1):    " + XmlNode( cXmlRetorno, "nro" ) + hb_Eol()
         cTexto += "Compl(1):  " + XmlNode( cXmlRetorno, "xCpl" ) + hb_Eol()
         cTexto += "Bairro(1): " + XmlNode( cXmlRetorno, "xBairro" ) + hb_Eol()
         cTexto += "Cod.Mun(1):" + XmlNode( cXmlRetorno, "cMun" ) + hb_Eol()
         cTexto += "Municip(1):" + XmlNode( cXmlRetorno, "xMun" ) + hb_Eol()
         cTexto += "CEP(1):    " + XmlNode( cXmlRetorno, "CEP" ) + hb_Eol()
         cTexto += "Etc pode ter vários endereços..."
         wapi_MessageBox( , cTexto, "Informação Extraída" )

      CASE nOpc == 9
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 1 GET cChave PICTURE "@R 99-99/99-99.999.999/9999-99.99.999.999999999.9.99999999.9"
         READ
         IF LastKey() == K_ESC
            EXIT
         ENDIF
         oSefaz:NfeConsultaProtocolo( cChave )
         wapi_MessageBox( , oSefaz:cXmlSoap )
         wapi_MessageBox( , oSefaz:cXmlRetorno )

      CASE nOpc == 10
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 1 GET cChave PICTURE "@R 99-99/99-99.999.999/9999-99.99.999.999999999.9.99999999.9"
         READ
         IF LastKey() == K_ESC
            EXIT
         ENDIF
         oSefaz:cVersao := "3.00"
         oSefaz:CteConsultaProtocolo( cChave )
         wapi_MessageBox( , oSefaz:cXmlSoap )
         wapi_MessageBox( , oSefaz:cXmlRetorno )

      CASE nOpc == 11
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 1 GET cChave PICTURE "@R 99-99/99-99.999.999/9999-99.99.999.999999999.9.99999999.9"
         READ
         IF LastKey() == K_ESC
            EXIT
         ENDIF
         oSefaz:cVersao := "3.00"
         oSefaz:MDFeConsultaProtocolo( cChave )
         wapi_MessageBox( , oSefaz:cXmlSoap )
         wapi_MessageBox( , oSefaz:cXmlRetorno )

      CASE nOpc == 12
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 9, 1 GET cCnpj PICTURE "@9"
         READ
         IF LastKey() == K_ESC
            EXIT
         ENDIF
         oSefaz:nfeDistribuicaoDFe( cCnpj, "0" )
         wapi_MessageBox( , oSefaz:cXmlSoap )
         wapi_MessageBox( , oSefaz:cXmlRetorno )

         oSefaz:nfeConsultaDest( cCnpj, "0" )
         wapi_MessageBox( , oSefaz:cXmlSoap )
         wapi_MessageBox( , oSefaz:cXmlRetorno )

      CASE nOpc == 13
         cXml := MemoRead( win_GetOpenFileName(, "Arquivo a assinar", "importa\", "XML", "*.XML", 1 ) )
         ? oSefaz:ValidaXml( cXml ) // , "d:\cdrom\fontes\integra\schemmas\pl_008i2_cfop_externo\nfe_v3.10.xsd" )
         Inkey(0)

      CASE nOpc == 14
         oSefaz:cXmlDocumento := [<NFe><infNFe Id="Nfe0001"></infNFe></NFe>]
         oSefaz:AssinaXml()
         ? oSefaz:cXmlRetorno
         ? oSefaz:cXmlDocumento
         Inkey(0)

      CASE nOpc == 15
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 1 GET cRecibo PICTURE "@9"
         READ
         IF LastKey() != K_ESC .AND. ! Empty( cRecibo )
            oSefaz:NfeConsultaRecibo( cRecibo )
            ? oSefaz:cXmlRetorno
            Inkey(0)
         ENDIF

      CASE nOpc == 16
         oSefaz:NfeLoteEnvia( [<NFe><infNFe Id="Nfe0001"></infNFe></NFe>] )
         ? oSefaz:cXmlRetorno
         Inkey(0)

      CASE nOpc == 17
         cXml := MemoRead( win_GetOpenFileName(, "Arquivo a transmitir", ".\", "XML", "*.XML", 1 ) )
         DO CASE
         CASE "<infMDFe" $ cXml ; ? "autorizando CTE"; oSefaz:cVersao := "3.00"; oSefaz:CteLoteEnvia( cXml )
         CASE "<infCTe"  $ cXml ; ? "autorizando MDFE"; oSefaz:cVersao := "3.00"; oSefaz:MDFeLoteEnvia( cXml )
         CASE "<infNFe"  $ cXml ; ? "autorizando NFE"; oSefaz:NfeLoteEnvia( cXml )
         OTHERWISE              ; ? "Documento não reconhecido"
         ENDCASE
         ? oSefaz:cXmlRetorno
         hb_MemoWrit( "testeassinado.xml", oSefaz:cXmlDocumento )
         hb_MemoWrit( "testeautorizado.xml", oSefaz:cXmlAutorizado )
         Inkey(0)

      CASE nOpc == 18
         oSefaz:cXmlDocumento := MemoRead( win_GetOpenFileName(, "Arquivo a assinar", ".\", "XML", "*.XML", 1 ) )
         oSefaz:AssinaXml()
         ? oSefaz:cXmlRetorno
         ? oSefaz:cXmlDocumento
         hb_MemoWrit( "testassina.xml", oSefaz:cXmlDocumento )
         Inkey(0)

      CASE nOpc == 19
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @  8, 1 GET cChave  PICTURE "@9"
         @  9, 1 GET cCnpj   PICTURE "@9"
         @ 10, 1 GET cEvento PICTURE "@9" VALID cEvento $ "210200,210210,210220,210240"
         READ
         IF LastKey() != K_ESC
            oSefaz:NfeEventoManifestacao( cChave, cCnpj, cEvento )
            ? oSefaz:cXmlRetorno
            Inkey(0)
         ENDIF

      CASE nOpc == 20
         Scroll( 8, 0, MaxRow(), MaxCol(), 0 )
         @ 8, 1 GET cChave PICTURE "@9"
         @ 9, 1 GET cCnpj  PICTURE "@9"
         READ
         IF LastKey() != K_ESC
            oSefaz:NfeDownload( cCnpj, cChave, cCertificado, cAmbiente )
            ? oSefaz:cXmlRetorno
            IF oSefaz:cStatus == "138"
               hb_MemoWrit( "arquivo.zip", hb_Base64Decode( XmlNode( oSefaz:cXmlRetorno, "docZip" ) ) )
            ENDIF
            Inkey(0)
         ENDIF
      ENDCASE
   ENDDO

   RETURN NIL

FUNCTION SetupHarbour()

#ifndef __XHARBOUR__
   hb_gtInfo( HB_GTI_INKEYFILTER, { | nKey | MyInkeyFilter( nKey ) } ) // pra funcionar control-V
#endif
   SET( _SET_EVENTMASK, INKEY_ALL - INKEY_MOVE )
   SET CONFIRM ON

   RETURN NIL

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
      oDanfe:cDesenvolvedor := "www.josequintas.com.br"
      oDanfe:ToPDF( oFile[ F_NAME ], cFilePdf )
      ? oFile[ F_NAME ], oDanfe:cRetorno
      PDFOpen( cFilePdf )
   NEXT

   RETURN NIL

FUNCTION PDFOpen( cFile )

   IF File( cFile )
      WAPI_ShellExecute( NIL, "open", cFile, "",, WIN_SW_SHOWNORMAL )
      Inkey(1)
   ENDIF

   RETURN NIL

#ifndef __XHARBOUR__

FUNCTION JPEGImage()

#pragma __binarystreaminclude "jpatecnologia.jpg"        | RETURN %s

#endif

