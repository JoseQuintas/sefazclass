/*
HBNFEDAMDFE - DOCUMENTO AUXILIAR DO MDFE
Fontes originais do projeto hbnfe em https://github.com/fernandoathayde/hbnfe

2016.09.24.1100 - Incluso, faltam alterações
2016.09.25.0940 - Ainda não houve geração de PDF
*/

#include "common.ch"
#include "hbclass.ch"
#include "harupdf.ch"
#ifndef __XHARBOUR__
#include "hbwin.ch"
#include "hbzebra.ch"
#endif

CLASS hbnfeDaMdfe

   METHOD execute( cXml, cFilePDF )
   METHOD buscaDadosXML()
   METHOD geraPDF( cFilePDF )
   METHOD novaPagina()
   METHOD cabecalho()

   DATA nItens1Folha
   DATA nItensDemaisFolhas
   DATA nLarguraDescricao
   DATA nLarguraCodigo
   DATA cTelefoneEmitente INIT ""
   DATA cSiteEmitente     INIT ""
   DATA cEmailEmitente    INIT ""
   DATA cXml
   DATA cChave
   DATA aIde
   DATA aCompl
   DATA aEmit
   DATA aMunCarreg
   DATA aModal
   DATA aMunDescarga
   DATA aRem
   DATA aTot
   DATA cLacre
   DATA cInfCpl
   DATA cRntrcEmit
   DATA cRntrcProp
   DATA cCiot
   DATA aCondutor
   DATA ainfNF
   DATA ainfNFe
   DATA ainfCTe
   DATA ainfOutros
   DATA aValePed
   DATA aDest
   DATA aLocEnt
   DATA aPrest
   DATA aComp
   DATA aIcms00
   DATA aIcms20
   DATA aIcms45
   DATA aIcms60
   DATA aIcms90
   DATA aIcmsUF
   DATA aIcmsSN
   DATA cAdfisco
   DATA aInfCarga
   DATA aInfQ
   DATA aSeg
   DATA aRodo
   DATA aMoto
   DATA aProp
   DATA aVeiculo
   DATA aProtocolo
   DATA aExped
   DATA aReceb
   DATA aToma

   DATA aICMSTotal
   DATA aISSTotal
   DATA aRetTrib
   DATA aTransp
   DATA aVeicTransp
   DATA aReboque
   DATA cCobranca
   DATA aInfAdic
   DATA aObsCont
   DATA aObsFisco
   DATA aExporta
   DATA aCompra
   DATA aInfProt
   DATA aInfCanc

   DATA aItem
   DATA aItemDI
   DATA aItemAdi
   DATA aItemICMS
   DATA aItemICMSPart
   DATA aItemICMSST
   DATA aItemICMSSN101
   DATA aItemICMSSN102
   DATA aItemICMSSN201
   DATA aItemICMSSN202
   DATA aItemICMSSN500
   DATA aItemICMSSN900
   DATA aItemIPI
   DATA aItemII
   DATA aItemPIS
   DATA aItemPISST
   DATA aItemCOFINS
   DATA aItemCOFINSST
   DATA aItemISSQN

   DATA cFonteNFe
   DATA cFonteCode128            // Inserido por Anderson Camilo em 04/04/2012
   DATA cFonteCode128F           // Inserido por Anderson Camilo em 04/04/2012
   DATA oPdf
   DATA oPdfPage
   DATA oPdfFontCabecalho
   DATA oPdfFontCabecalhoBold
   DATA nLinhaPDF
   DATA nLarguraBox INIT 0.5
   DATA lLaser INIT .T.
   DATA lPaisagem
   DATA cLogoFile
   DATA nLogoStyle // 1-esquerda, 2-direita, 3-expandido

   DATA nItensFolha
   DATA nLinhaFolha
   DATA nFolhas
   DATA nFolha

   DATA lValorDesc INIT .F.
   DATA nCasasQtd INIT 2
   DATA nCasasVUn INIT 2
   DATA cRetorno
   DATA PastaPdf

ENDCLASS

METHOD execute( cXml, cFilePDF ) CLASS hbnfeDaMdfe

   IF ::lLaser <> Nil
      ::lLaser := .T.
   ENDIF
   IF ::cFonteNFe = Nil
      ::cFonteNFe := 'Times'
   ENDIF

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

   LOCAL cIde, cEmit, cinfNF, cinfNFe, cText
   LOCAL cchCT, cchNFe
   LOCAL cRodo, cVeiculo, cProtocolo, cNF
   LOCAL cValePed, cProp, cMunCarreg, cModal, cMunDescarga, cTot
   LOCAL cCondutor, cReboque

   cIde := XmlNode( ::cXml, "ide" )
   ::aIde := hb_Hash()
   ::aIde[ "cUF" ]     := XmlNode( cIde, "cUF" )
   ::aIde[ "tpAmb" ]   := XmlNode( cIde, "tpAmb" )
   ::aIde[ "tpEmis" ]  := XmlNode( cIde, "tpEmis" )
   ::aIde[ "mod" ]     := XmlNode( cIde, "mod" )
   ::aIde[ "serie" ]   := XmlNode( cIde, "serie" )
   ::aIde[ "nMDF" ]    := XmlNode( cIde, "nMDF" )
   ::aIde[ "cMDF" ]    := XmlNode( cIde, "cMDF" )
   ::aIde[ "cDV" ]     := XmlNode( cIde, "cDV" )
   ::aIde[ "modal" ]   := XmlNode( cIde, "modal" )
   ::aIde[ "dhEmi" ]   := XmlNode( cIde, "dhEmi" )
   ::aIde[ "tpEmis" ]  := XmlNode( cIde, "tpEmis" )
   ::aIde[ "procEmi" ] := XmlNode( cIde, "procEmi" )
   ::aIde[ "verProc" ] := XmlNode( cIde, "verProc" )
   ::aIde[ "UFIni" ]   := XmlNode( cIde, "UFIni" )
   ::aIde[ "UFFim" ]   := XmlNode( cIde, "UFFim" )

   cMunCarreg := XmlNode( ::cXml, "infMunCarrega" )
   ::aMunCarreg := hb_Hash()
   ::aMunCarreg[ "cMunCarrega" ] := XmlNode( cMunCarreg, "cMunCarrega" )

   cEmit := XmlNode( ::cXml, "emit" )
   ::aEmit := hb_Hash()
   ::aEmit[ "CNPJ" ]  := XmlNode( cEmit, "CNPJ" )
   ::aEmit[ "IE" ]    := XmlNode( cEmit, "IE" )
   ::aEmit[ "xNome" ] := XmlNode( cEmit, "xNome" )
   ::aEmit[ "xFant" ] := XmlNode( cEmit, "xFant" )
   ::aEmit[ "fone" ]  := XmlNOde( cEmit, "fone" )

   cEmit := XmlNode( cEmit, "enderEmit" )
   ::aEmit[ "xLgr" ]    := XmlNode( cEmit, "xLgr" )
   ::aEmit[ "nro" ]     := XmlNode( cEmit, "nro" )
   ::aEmit[ "xCpl" ]    := XmlNode( cEmit, "xCpl" )
   ::aEmit[ "xBairro" ] := XmlNode( cEmit, "xBairro" )
   ::aEmit[ "cMun" ]    := XmlNode( cEmit, "cMun" )
   ::aEmit[ "xMun" ]    := XmlNode( cEmit, "xMun" )
   ::aEmit[ "CEP" ]     := XmlNode( cEmit, "CEP" )
   ::aEmit[ "UF" ]      := XmlNode( cEmit, "UF" )

   cModal := XmlNode( ::cXml, "rem" )
   ::aModal := hb_Hash()
   ::aModal[ "versaoModal" ] := XmlNode( cModal, "versaoModal" )

   cMunDescarga := XmlNode( ::cXml, "infMunDescarga" )
   ::aMunDescarga := hb_Hash()
   ::aMunDescarga[ "cMunDescarga" ] := XmlNode( cMunDescarga, "cMunDescarga" )
   ::aMunDescarga[ "xMunDescarga" ] := XmlNode( cMunDescarga, "xMunDescarga" )

   // cte

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

   cTot := XmlNode( ::cXml, "tot" )
   ::aTot := hb_Hash()
   ::aTot[ "qCTe" ]   := XmlNode( cTot, "qCTe" )
   ::aTot[ "qCT" ]    := XmlNode( cTot, "qCT" )
   ::aTot[ "qNFe" ]   := XmlNode( cTot, "qNFe" )
   ::aTot[ "qNF" ]    := XmlNode( cTot, "qNF" )
   ::aTot[ "vCarga" ] := XmlNode( cTot, "vCarga" )
   ::aTot[ "cUnid" ]  := XmlNode( cTot, "cUnid" )
   ::aTot[ "qCarga" ] := XmlNode( cTot, "qCarga" )

   ::cLacre := XmlNode( ::cXml, "nLacre" )

   ::cInfCpl := XmlNode( ::cXml, "infCpl" )

   cRodo := XmlNode( ::cXml, "rodo" )
   ::cRntrcEmit := XmlNode( cRodo, "RNTRC" )
   ::cCiot      := XmlNode( cRodo, "CIOT" )

   cVeiculo := XmlNode( ::cXml, "veicTracao" )
   ::aVeiculo := hb_Hash()
   ::aVeiculo[ "placa" ] := XmlNode( cVeiculo, "placa" )
   ::aVeiculo[ "tara" ]  := XmlNode( cVeiculo, "tara" )

   cProp := XmlNode( ::cXml, "prop" )
   ::aProp := hb_Hash()
   ::aProp[ "RNTRC" ] := XmlNode( cProp, "RNTRC" )

   cCondutor := XmlNode( ::cXml, "condutor" )
   ::aCondutor := hb_Hash()
   ::aCondutor[ "xNome" ] := XmlNode( cCondutor, "xNome" )
   ::aCondutor[ "CPF" ]   := XmlNode( cCondutor, "CPF" )

   cReboque := XmlNode( ::cXml, "veicReboque" )
   ::aReboque := hb_Hash()
   ::aReboque[ "placa" ] := XmlNode( cReboque, "placa" )
   ::aReboque[ "tara" ]  := XmlNode( cReboque, "tara" )
   ::aReboque[ "capKG" ] := XmlNode( cReboque, "capKG" )
   ::aReboque[ "RNTRC" ] := XmlNode( cReboque, "RNTRC" )

   cValePed := XmlNode( ::cXml, "valePed" )
   ::aValePed := hb_Hash()
   ::aValePed[ "CNPJForn" ] := XmlNode( cValePed, "CNPJForn" )
   ::aValePed[ "CNPJPg" ]   := XmlNode( cValePed, "CNPJPg" )
   ::aValePed[ "nCompra" ]  := XmlNode( cValePed, "nCompra" )

   cProtocolo := XmlNode( ::cXml, "infProt" )
   ::aProtocolo := hb_Hash()
   ::aProtocolo[ "nProt" ]    := XmlNode( cProtocolo, "nProt" ) // NFE 2.0
   ::aProtocolo[ "dhRecbto" ] := XmlNode( cProtocolo, "dhRecbto" ) // NFE 2.0

   RETURN .T.

METHOD geraPDF( cFilePDF ) CLASS hbnfeDaMdfe

   // criacao objeto pdf
   ::oPdf := HPDF_New()
   If ::oPdf == NIL
      ::cRetorno := "Falha da criação do objeto PDF !"
      RETURN .F.
   ENDIF
   /* set compression mode */
   HPDF_SetCompressionMode( ::oPdf, HPDF_COMP_ALL )
   /* setando fonte */
   If ::cFonteNFe == "Times"
      ::oPdfFontCabecalho     := HPDF_GetFont( ::oPdf, "Times-Roman", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Times-Bold", "CP1252" )
   ELSE
      ::oPdfFontCabecalho     := HPDF_GetFont( ::oPdf, "Courier", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Courier-Bold", "CP1252" )
   ENDIF

   // Inserido por Anderson Camilo em 04/04/2012

   ::cFonteCode128  := HPDF_LoadType1FontFromFile( ::oPdf, 'fontes\Code128bWinLarge.afm', 'fontes\Code128bWinLarge.pfb' )   // Code 128
   ::cFonteCode128F := HPDF_GetFont( ::oPdf, ::cFonteCode128, "WinAnsiEncoding" )

   // final da criacao e definicao do objeto pdf

   ::nFolha := 1
   ::novaPagina()
   ::cabecalho()
   HPDF_SaveToFile( ::oPdf, cFilePDF )
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
       IF ::lPaisagem = .T. // paisagem
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

   LOCAL oImage, hZebra

   // box do logotipo e dados do emitente

   hbnfe_Box_hpdf( ::oPdfPage,  020, ::nLinhaPdf - 150, 555, 150, ::nLarguraBox )
   IF ! Empty( ::cLogoFile )
      oImage := HPDF_LoadJpegImageFromFile( ::oPdf, ::cLogoFile )
      HPDF_Page_DrawImage( ::oPdfPage, oImage, 025, ::nLinhaPdf - ( 142 + 1 ), 200, 132 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf -018, 560, Nil, ::aEmit[ "xNome" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 16 )
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf -060, 560, Nil, 'CNPJ: ' + TRANSF( ::aEmit[ "CNPJ" ], "@R 99.999.999/9999-99" ) + '       Inscrição Estadual: ' + FormatIE( ::aEmit[ "IE" ], ::aEmit[ "UF" ] ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf -072, 560, Nil, 'Logradouro: ' + ::aEmit[ "xLgr" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf -084, 560, Nil, "No.: " + iif( ::aEmit[ "nro" ]  != Nil, ::aEmit[ "nro" ], '' ) + iif( ::aEmit[ "xCpl" ] != Nil, " - Complemento: " + ::aEmit[ "xCpl" ], '' ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf -096, 560, Nil, 'Bairro: ' + ::aEmit[ "xBairro" ] + " - CEP: " + TRANSF( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf -108, 560, Nil, 'Município: ' + ::aEmit[ "xMun" ] + " - Estado: " + ::aEmit[ "UF" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf -120, 560, Nil, 'Fone/Fax:(' + SubStr( ::aEmit[ "fone" ], 1, 2 ) + ')' + SubStr( ::aEmit[ "fone" ], 3, 4 ) + '-' + SubStr( ::aEmit[ "fone" ], 7, 4 ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )

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
   hZebra := hb_zebra_create_code128( ::cChave, Nil )
   hbNFe_Zebra_Draw_Hpdf( hZebra, ::oPdfPage, 300, ::nLinhaPDF -232, 0.9, 30 )
#endif
   hbnfe_Line_hpdf( ::oPdfPage, 020, ::nLinhaPdf - 277, 575, ::nLinhaPdf - 277, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 278, 575, Nil, "Chave de acesso para consulta de autenticidade no site www.mdfe.fazenda.gov.br", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 040, ::nLinhaPdf - 293, 575, Nil, TRANSF( ::cChave, "@R 99.9999.99.999.999/9999-99-99-999-999.999.999-999.999.999-9" ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
   hbnfe_Line_hpdf( ::oPdfPage, 020, ::nLinhaPdf - 310, 575, ::nLinhaPdf - 310, ::nLarguraBox )
   // box do No. do Protocolo
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 311, 575, Nil, "Protocolo de autorização de uso", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 12 )
   IF ::aProtocolo[ "nProt" ] != Nil
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
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 580, 095, Nil, TRANSF( ::aValePed[ "CNPJPg" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 08 )
   hbnfe_Texto_hpdf( ::oPdfPage, 100, ::nLinhaPdf - 580, 170, Nil, TRANSF( ::aValePed[ "CNPJForn" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 08 )
   hbnfe_Texto_hpdf( ::oPdfPage, 175, ::nLinhaPdf - 580, 240, Nil, ::aValePed[ "nCompra" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 08 )
   hbnfe_Box_hpdf( ::oPdfPage, 020, ::nLinhaPdf - 775, 555, 150, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 625, 210, Nil, "Observações", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 640, 560, Nil, ::cInfCpl, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   IF ! Empty( ::cLacre )
      hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 655, 560, Nil, 'No. do Lacre: ' + ::cLacre, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   ENDIF

   // Data e Desenvolvedor da Impressao
   hbnfe_Texto_hpdf( ::oPdfPage, 025, ::nLinhaPdf - 800, 300, NIL, "DATA DA IMPRESSÃO: " + DToC( Date() ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
   hbnfe_Texto_hpdf( ::oPdfPage, 400, ::nLinhaPdf - 800, 560, NIL, "VesSystem", HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalhoBold, 6 )

   RETURN NIL

STATIC FUNCTION FormatIE( cIE, cUF )

   cIE := AllTrim( cIE )
   IF cIE == "ISENTO" .OR. Empty( cIE )
      RETURN cIE
   ENDIF
   cIE := SoNumeros( cIE )

   HB_SYMBOL_UNUSED( cUF )

   RETURN cIE
