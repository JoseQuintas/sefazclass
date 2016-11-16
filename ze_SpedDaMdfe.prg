/*
ZE_SPEDDAMDFE - Documento Auxiliar de Manifesto Eletrônico de Documentos Fiscais
Fontes originais do projeto hbnfe em https://github.com/fernandoathayde/hbnfe
*/

#include "common.ch"
#include "hbclass.ch"
#include "harupdf.ch"
#ifndef __XHARBOUR__
#include "hbwin.ch"
#endif
#define _LOGO_ESQUERDA        1      /* apenas anotado, mas não usado */
#define _LOGO_DIREITA         2
#define _LOGO_EXPANDIDO       3

CREATE CLASS hbnfeDaMDFe INHERIT hbNFeDaGeral

   METHOD execute( cXml, cFilePDF )
   METHOD buscaDadosXML()
   METHOD geraPDF( cFilePDF )
   METHOD novaPagina()
   METHOD cabecalho()

   VAR nItens1Folha
   VAR nItensDemaisFolhas
   VAR nLarguraDescricao
   VAR nLarguraCodigo
   VAR cTelefoneEmitente INIT ""
   VAR cSiteEmitente     INIT ""
   VAR cEmailEmitente    INIT ""
   VAR cDesenvolvedor    INIT ""
   VAR cXml
   VAR cChave
   VAR aIde
   VAR aCompl
   VAR aEmit
   VAR aMunCarreg
   VAR aModal
   VAR aMunDescarga
   VAR aRem
   VAR aTot
   VAR cLacre
   VAR cInfCpl
   VAR cRntrcEmit
   VAR cRntrcProp
   VAR cCiot
   VAR aCondutor
   VAR ainfNF
   VAR ainfNFe
   VAR ainfCTe
   VAR ainfOutros
   VAR aValePed
   VAR aDest
   VAR aLocEnt
   VAR aPrest
   VAR aComp
   VAR aIcms00
   VAR aIcms20
   VAR aIcms45
   VAR aIcms60
   VAR aIcms90
   VAR aIcmsUF
   VAR aIcmsSN
   VAR cAdfisco
   VAR aInfCarga
   VAR aInfQ
   VAR aSeg
   VAR aRodo
   VAR aMoto
   VAR aProp
   VAR aVeiculo
   VAR aProtocolo
   VAR aExped
   VAR aReceb
   VAR aToma

   VAR aICMSTotal
   VAR aISSTotal
   VAR aRetTrib
   VAR aTransp
   VAR aVeicTransp
   VAR aReboque
   VAR cCobranca
   VAR aInfAdic
   VAR aObsCont
   VAR aObsFisco
   VAR aExporta
   VAR aCompra
   VAR aInfProt
   VAR aInfCanc

   VAR aItem
   VAR aItemDI
   VAR aItemAdi
   VAR aItemICMS
   VAR aItemICMSPart
   VAR aItemICMSST
   VAR aItemICMSSN101
   VAR aItemICMSSN102
   VAR aItemICMSSN201
   VAR aItemICMSSN202
   VAR aItemICMSSN500
   VAR aItemICMSSN900
   VAR aItemIPI
   VAR aItemII
   VAR aItemPIS
   VAR aItemPISST
   VAR aItemCOFINS
   VAR aItemCOFINSST
   VAR aItemISSQN

   VAR cFonteNFe     INIT "Times"
   VAR cFonteCode128            // Inserido por Anderson Camilo em 04/04/2012
   VAR cFonteCode128F           // Inserido por Anderson Camilo em 04/04/2012
   VAR oPdf
   VAR oPdfPage
   VAR oPdfFontCabecalho
   VAR oPdfFontCabecalhoBold
   VAR nLinhaPDF
   VAR nLarguraBox INIT 0.5
   VAR lLaser INIT .T.
   VAR lPaisagem
   VAR cLogoFile  INIT ""
   VAR nLogoStyle INIT _LOGO_ESQUERDA // 1-esquerda, 2-direita, 3-expandido

   VAR nItensFolha
   VAR nLinhaFolha
   VAR nFolhas
   VAR nFolha

   VAR lValorDesc INIT .F.
   VAR nCasasQtd INIT 2
   VAR nCasasVUn INIT 2
   VAR cRetorno
   VAR PastaPdf

ENDCLASS

METHOD execute( cXml, cFilePDF ) CLASS hbnfeDaMdfe

   IF cXml == NIL .OR. Empty( cXml )
      ::cRetorno := "Sem conteúdo XML pra gerar PDF"
      RETURN ::cRetorno
   ENDIF

   ::cXML := cXml
   ::cChave := SubStr( ::cXML, At( 'Id=', ::cXML ) + 8, 44 )

   IF !::buscaDadosXML()
      RETURN ::cRetorno
   ENDIF

   ::lPaisagem := .F.
   ::nItens1Folha := 45 // 48 inicial pode aumentar variante a servicos etc...   && anderson camilo diminuiu o numero de itens o original era 48
   ::nItensDemaisFolhas := 105
   ::nLarguraDescricao := 39
   ::nLarguraCodigo := 13

   IF ! ::GeraPdf( cFilePDF )
      ::cRetorno := "Problema ao gerar o PDF !"
      Return ::cRetorno
   ENDIF

   ::cRetorno := "OK"

   RETURN ::cRetorno

METHOD buscaDadosXML() CLASS hbnfeDaMdfe

   LOCAL cinfNF, cinfNFe, cText, cNF, cchCT, cchNFe

   ::aIde         := XmlToHash( XmlNode( ::cXml, "ide" ), { "cUF", "tpAmb", "tpEmis", "mod", "serie", "nMDF", "cMDF", "cDV", "modal", ;
                     "dhEmi", "tpEmis", "procEmi", "verProc", "UFIni", "UFFim" } )
   ::aMunCarreg   := XmlToHash( XmlNode( ::cXml, "infMunCarrega" ), { "cMunCarrega" } )
   ::aEmit        := XmlToHash( XmlNode( ::cXml, "emit" ), { "CNPJ", "IE", "xNome", "xFant", "fone" } )
   ::aEmit        := XmlToHash( XmlNode( XmlNode( ::cXml, "emit" ), "enderEmit" ), { "xLgr", "nro", "xCpl", "xBairro", "cMun", "xMun", "CEP", "UF" }, ::aEmit )
   ::aModal       := XmlNode( XmlNode( ::cXml, "rem" ), "versaoModal" )
   ::aMunDescarga := XmlToHash( XmlNode( ::cXml, "infMunDescarga" ), { "cMunDescarga", "xMunDescarga" } )

   ::ainfCTe := {}
   cText     := XmlNode( ::cXml, "infCTe" )
   DO WHILE "<chCT" $ cText
      cchCT := XmlNode( cText, "chCT" )
      cText := SubStr( cText, At( "</chCT", cText ) + 7 )
      AAdd( ::ainfCTe, cchCT )
   ENDDO

   ::ainfNF := {}
   cinfNF   := XmlNode( ::cXml, "infNF" )
   cText    := cInfNF
   DO WHILE "<infNF" $ cText .AND. "</infNF" $ cText // precaucao inicio/fim
      cNF   := XmlNode( cText, "infNF" )
      cText := SubStr( cText, At( "</infNF", cText ) + 8 )
      AAdd( ::ainfNF, { ;
         XmlNode( cNF, "CNPJ" ), ;
         XmlNode( cNF, "UF" ), ;
         XmlNode( cNF, "nNF" ), ;
         XmlNode( cNF, "serie" ), ;
         XmlNode( cNF, "dEmi" ), ;
         XmlNode( cNF, "vNF" ), ;
         XmlNode( cNF, "PIN" ) } )
   ENDDO
   ::ainfNFe := {}
   cinfNFe   := XmlNode( ::cXml, "infNFe" ) // versao 2.0
   cText     := cInfNFe
   DO WHILE "<chNFe" $ cText .AND. "</chNFe" $ cText
      cchNFe := XmlNode( cText, "chNFe" )
      cText  := SubStr( cText, At( "</chNFe", cText ) + 8 )
      AAdd( ::ainfNFe, XmlNode( cchNFe, "chNFe" ) )
   ENDDO

   ::aTot       := XmlToHash( XmlNode( ::cXml, "tot" ), { "qCTe", "qCT", "qNFe", "qNF", "vCarga", "cUnid", "qCarga" } )
   ::cLacre     := XmlNode( ::cXml, "nLacre" )
   ::cInfCpl    := XmlNode( ::cXml, "infCpl" )
   ::cRntrcEmit := XmlNode( XmlNode( ::cXml, "rodo" ), "RNTRC" )
   ::cCiot      := XmlNode( XmlNode( ::cXml, "rodo" ), "CIOT" )
   ::aVeiculo   := XmlToHash( XmlNode( ::cXml, "veicTracao" ), { "placa", "tara" } )
   ::aProp      := XmlToHash( XmlNode( ::cXml, "prop" ), { "RNTRC" } )
   ::aCondutor  := XmlToHash( XmlNode( ::cXml, "condutor" ), { "xNome", "CPF" } )
   ::aReboque   := XmlToHash( XmlNode( ::cXml, "veicReboque" ), { "placa", "tara", "capKG", "RNTRC" } )
   ::aValePed   := XmlToHash( XmlNode( ::cXml, "valePed" ), { "CNPJForn", "CNPJPg", "nCompra" } )
   ::aProtocolo := XmlToHash( XmlNode( ::cXml, "infProt" ), { "nProt", "dhRecbto" } )

   RETURN .T.

METHOD geraPDF( cFilePDF ) CLASS hbnfeDaMdfe

   // criacao objeto pdf
   ::oPDF := HPDF_New()
   If ::oPDF == NIL
      ::cRetorno := "Falha da criação do objeto PDF !"
      RETURN .F.
   ENDIF
   /* set compression mode */
   HPDF_SetCompressionMode( ::oPDF, HPDF_COMP_ALL )
   /* setando fonte */
   ::oPdfFontCabecalho     := HPDF_GetFont( ::oPDF, "Times-Roman", "CP1252" )
   ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPDF, "Times-Bold", "CP1252" )

#ifdef __XHARBOUR__
   // Inserido por Anderson Camilo em 04/04/2012
   ::cFonteCode128  := HPDF_LoadType1FontFromFile( ::oPDF, 'fontes\Code128bWinLarge.afm', 'fontes\Code128bWinLarge.pfb' )   // Code 128
   ::cFonteCode128F := HPDF_GetFont( ::oPDF, ::cFonteCode128, "WinAnsiEncoding" )
#endif
   // final da criacao e definicao do objeto pdf

   ::nFolha := 1
   ::novaPagina()
   ::cabecalho()
   HPDF_SaveToFile( ::oPDF, cFilePDF )
   HPDF_Free( ::oPdf )

   RETURN .T.

METHOD NovaPagina() CLASS hbnfeDaMdfe

   LOCAL nRadiano, nAngulo

   ::oPdfPage := HPDF_AddPage( ::oPdf )

   HPDF_Page_SetSize( ::oPdfPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT )

   ::nLinhaPdf := HPDF_Page_GetHeight( ::oPDFPage ) -20    // Margem Superior
   nAngulo := 45                   /* A rotation of 45 degrees. */

   nRadiano := nAngulo / 180 * 3.141592 /* Calcurate the radian value. */

   IF ::aIde[ "tpAmb" ] = "2" .OR. ::aProtocolo[ "nProt" ] = Nil

      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText( ::oPdfPage )
      HPDF_Page_SetTextMatrix( ::oPdfPage, Cos( nRadiano ), Sin( nRadiano ), -Sin( nRadiano ), Cos( nRadiano ), 15, 100 )
      HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
      HPDF_Page_ShowText( ::oPdfPage, "AMBIENTE DE HOMOLOGAÇÃO - SEM VALOR FISCAL" )
      HPDF_Page_EndText( ::oPdfPage )

      HPDF_Page_SetRGBStroke( ::oPdfPage, 0.75, 0.75, 0.75 )
      hbNFe_Line_Hpdf( ::oPdfPage, 15, 100, 550, 630, 2.0 )

      HPDF_Page_SetRGBStroke( ::oPdfPage, 0, 0, 0 ) // reseta cor linhas

      HPDF_Page_SetRGBFill( ::oPdfPage, 0, 0, 0 ) // reseta cor fontes

   ENDIF

   IF ::aIde[ "tpAmb" ] = "1"
/*
      IF ::aInfCanc[ "nProt" ] <> Nil

       HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
       HPDF_Page_BeginText(::oPdfPage)
       HPDF_Page_SetTextMatrix(::oPdfPage, cos(nRadiano), sin(nRadiano), -sin(nRadiano), cos(nRadiano), 15, 100)
       HPDF_Page_SetRGBFill(::oPdfPage, 1, 0, 0)
       HPDF_Page_ShowText(::oPdfPage, ::aInfCanc[ "xEvento" ])
       HPDF_Page_EndText(::oPdfPage)

       HPDF_Page_SetRGBStroke(::oPdfPage, 0.75, 0.75, 0.75)
       IF ::lPaisagem
          hbnfe_Line_hpdf( ::oPdfPage, 15, 95, 675, 475, 2.0)
       ELSE
          hbnfe_Line_hpdf( ::oPdfPage, 15, 95, 550, 630, 2.0)
       ENDIF

       HPDF_Page_SetRGBStroke(::oPdfPage, 0, 0, 0) // reseta cor linhas

       HPDF_Page_SetRGBFill(::oPdfPage, 0, 0, 0) // reseta cor fontes

  ENDIF
*/
   ENDIF

   RETURN NIL

METHOD cabecalho() CLASS hbnfeDaMdfe

   LOCAL oImage

   // box do logotipo e dados do emitente

   hbnfe_Box_hpdf( ::oPdfPage,  020, ::nLinhaPdf - 150, 555, 150, ::nLarguraBox )
   IF ::cLogoFile != NIL .AND. ! Empty( ::cLogoFile )
      oImage := ::LoadJPEGImage( ::oPDF, ::cLogoFile )
      HPDF_Page_DrawImage( ::oPdfPage, oImage, 025, ::nLinhaPdf - ( 142 + 1 ), 200, 132 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf -018, 560, Nil, ::aEmit[ "xNome" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 16 )
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf -060, 560, Nil, 'CNPJ: ' + TRANSF( ::aEmit[ "CNPJ" ], "@R 99.999.999/9999-99" ) + '       Inscrição Estadual: ' + FormatIE( ::aEmit[ "IE" ], ::aEmit[ "UF" ] ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf -072, 560, Nil, 'Logradouro: ' + ::aEmit[ "xLgr" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf -084, 560, Nil, "No.: " + ::aEmit[ "nro" ] + " " + ::aEmit[ "xCpl" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf -096, 560, Nil, 'Bairro: ' + ::aEmit[ "xBairro" ] + " - CEP: " + TRANSF( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf -108, 560, Nil, 'Município: ' + ::aEmit[ "xMun" ] + " - Estado: " + ::aEmit[ "UF" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf -120, 560, Nil, 'Fone/Fax:' + FormatTelefone( ::aEmit[ "fone" ] ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )

   // box do nome do documento
   hbnfe_Box_hpdf( ::oPdfPage, 020, ::nLinhaPdf - 180, 555, 025, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 158, 100, Nil, "DAMDFE", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 16 )
   hbnfe_Texto_hpdf( ::oPdfPage, 100, ::nLinhaPdf - 161, 560, Nil, "Documento Auxiliar de Manifesto Eletrônico de Documentos Fiscais", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )

   // box do controle do fisco
   hbnfe_Box_hpdf( ::oPdfPage, 020, ::nLinhaPdf - 345, 555, 160, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 020, ::nLinhaPdf - 185, 560, Nil, "CONTROLE DO FISCO", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 09 )
#ifdef __XHARBOUR__
   hbnfe_Texto_hpdf( ::oPdfPage, 020, ::nLinhaPdf - 197, 575, Nil, hbnfe_Codifica_Code128c( ::cChave ), HPDF_TALIGN_CENTER, Nil, ::cFonteCode128F, 35 )
#else
   // atenção - chute inicial
   ::DrawBarcode( ::cChave, ::oPdfPage, 150, ::nLinhaPDF - 232, 0.9, 30 )
#endif
   hbnfe_Line_hpdf( ::oPdfPage, 020, ::nLinhaPdf - 277, 575, ::nLinhaPdf - 277, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 278, 575, Nil, "Chave de acesso para consulta de autenticidade no site www.mdfe.fazenda.gov.br", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 040, ::nLinhaPdf - 293, 575, Nil, TRANSF( ::cChave, "@R 99.9999.99.999.999/9999-99-99-999-999.999.999-999.999.999-9" ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
   hbnfe_Line_hpdf( ::oPdfPage, 020, ::nLinhaPdf - 310, 575, ::nLinhaPdf - 310, ::nLarguraBox )
   // box do No. do Protocolo
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 311, 575, Nil, "Protocolo de autorização de uso", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 12 )
   IF ! Empty( ::aProtocolo[ "nProt" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 326, 575, Nil, ::aProtocolo[ "nProt" ] + ' - ' + SubStr( ::aProtocolo[ "dhRecbto" ], 9, 2 ) + "/" + SubStr( ::aProtocolo[ "dhRecbto" ], 6, 2 ) + "/" + SubStr( ::aProtocolo[ "dhRecbto" ], 1, 4 ) + ' ' + SubStr( ::aProtocolo[ "dhRecbto" ], 12 ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
   ELSE
      hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 326, 575, Nil, 'MDFe sem Autorização de Uso da SEFAZ', HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
   ENDIF

   // box do modelo
   hbnfe_Box_hpdf( ::oPdfPage, 020, ::nLinhaPdf - 385, 555, 035, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 350, 100, Nil, "Modelo", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 365, 100, Nil, ::aIde[ "mod" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   // box da serie
   hbnfe_Line_hpdf( ::oPdfPage, 100, ::nLinhaPdf - 385, 100, ::nLinhaPdf - 350, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 105, ::nLinhaPdf - 350, 180, Nil, "Série", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 105, ::nLinhaPdf - 365, 180, Nil, ::aIde[ "serie" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   // box do numero
   hbnfe_Line_hpdf( ::oPdfPage, 180, ::nLinhaPdf - 385, 180, ::nLinhaPdf - 350, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 185, ::nLinhaPdf - 350, 285, Nil, "Número", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 185, ::nLinhaPdf - 365, 285, Nil, StrZero( Val( ::aIde[ "nMDF" ] ), 6 ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   // box do fl
   hbnfe_Line_hpdf( ::oPdfPage, 285, ::nLinhaPdf - 385, 285, ::nLinhaPdf - 350, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 290, ::nLinhaPdf - 350, 330, Nil, "FL", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 290, ::nLinhaPdf - 365, 330, Nil, "1/1", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   // box do data e hora
   hbnfe_Line_hpdf( ::oPdfPage, 330, ::nLinhaPdf - 385, 330, ::nLinhaPdf - 350, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 335, ::nLinhaPdf - 350, 500, Nil, "Data e Hora de Emissão", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 335, ::nLinhaPdf - 365, 500, Nil, SubStr( ::aIde[ "dhEmi" ], 9, 2 ) + "/" + SubStr( ::aIde[ "dhEmi" ], 6, 2 ) + "/" + SubStr( ::aIde[ "dhEmi" ], 1, 4 ) + ' ' + SubStr( ::aIde[ "dhEmi" ], 12 ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   // UF de carregamento
   hbnfe_Line_hpdf( ::oPdfPage, 500, ::nLinhaPdf - 385, 500, ::nLinhaPdf - 350, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 505, ::nLinhaPdf - 350, 560, Nil, "UF Carreg.", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 505, ::nLinhaPdf - 365, 560, Nil, ::aIde[ "UFIni" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   // box do modal
   hbnfe_Box_hpdf( ::oPdfPage, 020, ::nLinhaPdf - 410, 555, 020, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 393, 560, Nil, "Modal Rodoviário de Carga", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
   hbnfe_Box_hpdf( ::oPdfPage, 020, ::nLinhaPdf - 445, 555, 035, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 410, 140, Nil, "CIOT", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 425, 140, Nil, ::cCiot, HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   hbnfe_Line_hpdf( ::oPdfPage, 140, ::nLinhaPdf - 445, 140, ::nLinhaPdf - 410, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 145, ::nLinhaPdf - 410, 210, Nil, "Qtd. CTe", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 145, ::nLinhaPdf - 425, 210, Nil, ::aTot[ "qCTe" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   hbnfe_Line_hpdf( ::oPdfPage, 210, ::nLinhaPdf - 445, 210, ::nLinhaPdf - 410, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 215, ::nLinhaPdf - 410, 280, Nil, "Qtd. CTRC", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 215, ::nLinhaPdf - 425, 280, Nil, ::aTot[ "qCT" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   hbnfe_Line_hpdf( ::oPdfPage, 280, ::nLinhaPdf - 445, 280, ::nLinhaPdf - 410, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 285, ::nLinhaPdf - 410, 350, Nil, "Qtd. NFe", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 285, ::nLinhaPdf - 425, 350, Nil, ::aTot[ "qNFe" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   hbnfe_Line_hpdf( ::oPdfPage, 350, ::nLinhaPdf - 445, 350, ::nLinhaPdf - 410, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 355, ::nLinhaPdf - 410, 420, Nil, "Qtd. NF", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 355, ::nLinhaPdf - 425, 420, Nil, ::aTot[ "qNF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   hbnfe_Line_hpdf( ::oPdfPage, 425, ::nLinhaPdf - 445, 425, ::nLinhaPdf - 410, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 430, ::nLinhaPdf - 410, 560, Nil, "Peso Total (KG)", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 430, ::nLinhaPdf - 425, 560, Nil, AllTrim( Tran( Val( ::aTot[ "qCarga" ] ), '@E 9,999,999.9999' ) ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   hbnfe_Box_hpdf( ::oPdfPage, 020, ::nLinhaPdf - 620, 555, 175, ::nLarguraBox )
   hbnfe_Line_hpdf( ::oPdfPage, 240, ::nLinhaPdf - 460, 240, ::nLinhaPdf - 445, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 445, 240, Nil, "Veiculo", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 245, ::nLinhaPdf - 445, 560, Nil, "Condutor", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 12 )

   hbnfe_Box_hpdf( ::oPdfPage, 020, ::nLinhaPdf - 475, 555, 015, ::nLarguraBox )
   hbnfe_Line_hpdf( ::oPdfPage, 110, ::nLinhaPdf - 550, 110, ::nLinhaPdf - 460, ::nLarguraBox )
   hbnfe_Line_hpdf( ::oPdfPage, 240, ::nLinhaPdf - 620, 240, ::nLinhaPdf - 460, ::nLarguraBox )
   hbnfe_Line_hpdf( ::oPdfPage, 320, ::nLinhaPdf - 620, 320, ::nLinhaPdf - 460, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 460, 110, Nil, "Placa", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbnfe_Texto_hpdf( ::oPdfPage, 115, ::nLinhaPdf - 460, 240, Nil, "RNTRC", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbnfe_Texto_hpdf( ::oPdfPage, 245, ::nLinhaPdf - 460, 320, Nil, "CPF", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbnfe_Texto_hpdf( ::oPdfPage, 325, ::nLinhaPdf - 460, 560, Nil, "Nome", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbnfe_Box_hpdf( ::oPdfPage, 020, ::nLinhaPdf - 550, 220, 075, ::nLarguraBox )

   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 475, 110, Nil, ::aVeiculo[ "placa" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   IF !Empty( ::aProp[ "RNTRC" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 115, ::nLinhaPdf - 475, 240, Nil, ::aProp[ "RNTRC" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   ELSE
      hbnfe_Texto_hpdf( ::oPdfPage, 115, ::nLinhaPdf - 475, 240, Nil, ::cRntrcEmit, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 245, ::nLinhaPdf - 475, 320, Nil, TRANSF( ::aCondutor[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   hbnfe_Texto_hpdf( ::oPdfPage, 325, ::nLinhaPdf - 475, 560, Nil, ::aCondutor[ "xNome" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )

   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 490, 110, Nil, ::aReboque[ "placa" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   hbnfe_Texto_hpdf( ::oPdfPage, 115, ::nLinhaPdf - 490, 240, Nil, ::aReboque[ "RNTRC" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )

   hbnfe_Box_hpdf( ::oPdfPage, 020, ::nLinhaPdf - 565, 220, 015, ::nLarguraBox )
   hbnfe_Line_hpdf( ::oPdfPage, 100, ::nLinhaPdf - 620, 100, ::nLinhaPdf - 565, ::nLarguraBox )
   hbnfe_Line_hpdf( ::oPdfPage, 170, ::nLinhaPdf - 620, 170, ::nLinhaPdf - 565, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 552, 110, Nil, "Vale Pedágio", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 565, 095, Nil, "Responsável CNPJ", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 08 )
   hbnfe_Texto_hpdf( ::oPdfPage, 100, ::nLinhaPdf - 565, 170, Nil, "Fornecedor CNPJ", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 08 )
   hbnfe_Texto_hpdf( ::oPdfPage, 175, ::nLinhaPdf - 565, 240, Nil, "No.Comprovante", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 08 )
   IF ! Empty( ::aValePed[ "CNPJPg" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 580, 095, Nil, TRANSF( ::aValePed[ "CNPJPg" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 08 )
   ENDIF
   IF ! Empty( ::aValePed[ "CNPJForn" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 100, ::nLinhaPdf - 580, 170, Nil, TRANSF( ::aValePed[ "CNPJForn" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 08 )
   ENDIF
   IF ! Empty( ::aValePed[ "nCompra" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 175, ::nLinhaPdf - 580, 240, Nil, ::aValePed[ "nCompra" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 08 )
   ENDIF
   hbnfe_Box_hpdf( ::oPdfPage, 020, ::nLinhaPdf - 775, 555, 150, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 625, 210, Nil, "Observações", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 640, 560, Nil, ::cInfCpl, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   IF ! Empty( ::cLacre )
      hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 655, 560, Nil, 'No. do Lacre: ' + ::cLacre, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   ENDIF

   // Data e Desenvolvedor da Impressao
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 800, 300, NIL, "DATA DA IMPRESSÃO: " + DToC( Date() ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
   hbnfe_Texto_hpdf( ::oPdfPage, 400, ::nLinhaPdf - 800, 560, NIL, ::cDesenvolvedor, HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalhoBold, 6 )

   RETURN NIL

STATIC FUNCTION FormatIE( cIE, cUF )

   cIE := AllTrim( cIE )
   IF cIE == "ISENTO" .OR. Empty( cIE )
      RETURN cIE
   ENDIF
   cIE := SoNumeros( cIE )

   HB_SYMBOL_UNUSED( cUF )

   RETURN cIE
// Funções repetidas em NFE, CTE, MDFE e EVENTO
// STATIC pra permitir uso simultâneo com outras rotinas

STATIC FUNCTION hbNFe_Texto_Hpdf( oPdfPage2, x1, y1, x2, y2, cText, align, desconhecido, oFontePDF, nTamFonte, nAngulo )

   LOCAL nRadiano

   IF oFontePDF <> NIL
      HPDF_Page_SetFontAndSize( oPdfPage2, oFontePDF, nTamFonte )
   ENDIF
   IF x2 = NIL
      x2 := x1 - nTamFonte
   ENDIF
   HPDF_Page_BeginText( oPdfPage2 )
   IF nAngulo == NIL // horizontal normal
      HPDF_Page_TextRect ( oPdfPage2,  x1, y1, x2, y2, cText, align, NIL )
   ELSE
      nRadiano := nAngulo / 180 * 3.141592 /* Calcurate the radian value. */
      HPDF_Page_SetTextMatrix( oPdfPage2, Cos( nRadiano ), Sin( nRadiano ), -Sin( nRadiano ), Cos( nRadiano ), x1, y1 )
      HPDF_Page_ShowText( oPdfPage2, cText )
   ENDIF
   HPDF_Page_EndText  ( oPdfPage2 )

   HB_SYMBOL_UNUSED( desconhecido )

   RETURN NIL


#ifdef __XHARBOUR__
STATIC FUNCTION hbnfe_Codifica_Code128c( pcCodigoBarra )

   // Parameters de entrada : O codigo de barras no formato Code128C "somente numeros" campo tipo caracter
   // Retorno               : Retorna o código convertido e com o caracter de START e STOP mais o checksum
   // : para impressão do código de barras utilizando a fonte Code128bWin, é necessário
   // : para utilizar essa fonte os arquivos Code128bWin.ttf, Code128bWin.afm e Code128bWin.pfb
   // Autor                  : Anderson Camilo
   // Data                   : 19/03/2012

   LOCAL nI := 0, checksum := 0, nValorCar, cCode128 := '', cCodigoBarra

   cCodigoBarra := pcCodigoBarra
   IF Len( cCodigoBarra ) > 0    // Verifica se os caracteres são válidos (somente números)
      IF Int( Len( cCodigoBarra ) / 2 ) = Len( cCodigoBarra ) / 2    // Tem ser par o tamanho do código de barras
         FOR nI = 1 TO Len( cCodigoBarra )
            IF ( Asc( SubStr( cCodigoBarra, nI, 1 ) ) < 48 .OR. Asc( SubStr( cCodigoBarra, nI, 1 ) ) > 57 )
               nI := 0
               EXIT
            ENDIF
         NEXT
      ENDIF
      IF nI > 0
         nI := 1 // nI é o índice da cadeia
         cCode128 = Chr( 155 )
         DO WHILE nI <= Len( cCodigoBarra )
            nValorCar := Val( SubStr( cCodigoBarra, nI, 2 ) )
            IF nValorCar == 0
               nValorCar += 128
            ELSEIF nValorCar < 95
               nValorCar += 32
            ELSE
               nValorCar +=  50
            ENDIF
            cCode128 += Chr( nValorCar )
            nI += 2
         ENDDO
         // Calcula o checksum
         FOR nI = 1 TO Len( cCode128 )
            nValorCar := Asc ( SubStr( cCode128, nI, 1 ) )
            IF nValorCar := 128
               nValorCar := 0
            ELSEIF nValorCar < 127
               nValorCar -= 32
            ELSE
               nValorCar -=  50
            ENDIF
            IF nI == 1
               checksum := nValorCar
            ENDIF
            checksum := Mod( ( checksum + ( nI -1 ) * nValorCar ), 103 )
         NEXT
         // Cálculo código ASCII do checkSum
         IF checksum == 0
            checksum += 128
         ELSEIF checksum < 95
            checksum += 32
         ELSE
            checksum +=  50
         ENDIF
         // Adiciona o checksum e STOP
         cCode128 := cCode128 + Chr( checksum ) +  Chr( 156 )
      ENDIF
   ENDIF

   RETURN cCode128
#endif

STATIC FUNCTION hbNFe_Line_Hpdf( oPdfPage2, x1, y1, x2, y2, nPen, FLAG )

   HPDF_Page_SetLineWidth( oPdfPage2, nPen )
   IF FLAG != NIL
      HPDF_Page_SetLineCap( oPdfPage2, FLAG )
   ENDIF
   HPDF_Page_MoveTo( oPdfPage2, x1, y1 )
   HPDF_Page_LineTo( oPdfPage2, x2, y2 )
   HPDF_Page_Stroke( oPdfPage2 )
   IF FLAG <> NIL
      HPDF_Page_SetLineCap( oPdfPage2, HPDF_BUTT_END )
   ENDIF

   RETURN NIL

STATIC FUNCTION hbNFe_Box_Hpdf( oPdfPage2, x1, y1, x2, y2, nPen )

   HPDF_Page_SetLineWidth( oPdfPage2, nPen )
   HPDF_Page_Rectangle( oPdfPage2, x1, y1, x2, y2 )
   HPDF_Page_Stroke( oPdfPage2 )

   RETURN NIL

STATIC FUNCTION FormatTelefone( cTelefone )

   LOCAL cPicture := ""

   cTelefone := iif( ValType( cTelefone ) == "N", Ltrim( Str( cTelefone ) ), cTelefone )
   cTelefone := SoNumeros( cTelefone )
   DO CASE
   CASE Len( cTelefone ) == 8  ; cPicture := "@R 9999-9999"
   CASE Len( cTelefone ) == 9  ; cPicture := "@R 99999-9999"
   CASE Len( cTelefone ) == 10 ; cPicture := "@R (99) 9999-9999"
   CASE Len( cTelefone ) == 11 ; cPicture := "@R (99) 99999-9999"
   CASE Len( cTelefone ) == 12 ; cPicture := "@R +99 (99) 9999-9999"
   CASE Len( cTelefone ) == 13 ; cPicture := "@R +99 (99) 99999-9999"
   ENDCASE

   RETURN Transform( cTelefone, cPicture )
