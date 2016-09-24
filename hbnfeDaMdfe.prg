/*
HBNFEDAMDFE - DOCUMENTO AUXILIAR DO MDFE
Fontes originais do projeto hbnfe em https://github.com/fernandoathayde/hbnfe

2016.09.24.1100 - Incluso, faltam alterações
*/

#include "common.ch"
#include "hbclass.ch"
#include "harupdf.ch"
#ifndef __XHARBOUR__
   #include "hbwin.ch"
   #include "hbzebra.ch"
#endif

CLASS hbMDFeDaMdfe

   METHOD execute()
   METHOD buscaDadosXML()
   METHOD geraPDF()
   METHOD novaPagina()
   METHOD cabecalho()

   DATA nItens1Folha
   DATA nItensDemaisFolhas
   DATA nLarguraDescricao
   DATA nLarguraCodigo
   DATA lImprimir INIT .T.
   DATA cTelefoneEmitente INIT ""
   DATA cSiteEmitente INIT ""
   DATA cEmailEmitente INIT ""
   DATA cArquivoXML
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
   DATA cFonteCode128            && Inserido por Anderson Camilo em 04/04/2012
   DATA cFonteCode128F           && Inserido por Anderson Camilo em 04/04/2012
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

   DATA cFile
   DATA ohbNFe
   DATA lValorDesc INIT .F.
   DATA nCasasQtd INIT 2
   DATA nCasasVUn INIT 2
   DATA aRetorno
   DATA PastaPdf

   ENDCLASS

METHOD execute() CLASS hbMDFeDaMdfe

   IF ::lLaser <> Nil
      ::lLaser := .T.
   ENDIF
   IF ::cFonteNFe = Nil
      ::cFonteNFe := 'Times'
   ENDIF

   ::aRetorno := hb_Hash()

   IF !FILE(::cArquivoXML)
      ::aRetorno[ 'OK' ] := .F.
      ::aRetorno[ 'MsgErro' ] := 'Arquivo não encontrado ! '+::cArquivoXML
      RETURN(::aRetorno)
   ENDIF

   ::cXML := MEMOREAD( ::cArquivoXML )
   ::cChave := SUBS( ::cXML, AT('Id=',::cXML)+8,44)

   IF !::buscaDadosXML()
      RETURN(::aRetorno)
   ENDIF

   ::lPaisagem := .F.
   ::nItens1Folha := 45 // 48 inicial pode aumentar variante a servicos etc...   && anderson camilo diminuiu o numero de itens o original era 48
   ::nItensDemaisFolhas := 105
   ::nLarguraDescricao := 39
   ::nLarguraCodigo := 13

   If ::lImprimir
   	If !::GeraPdf()
      	::aRetorno[ 'OK' ] := .F.
      	::aRetorno[ 'MsgErro' ] := 'Problema ao gerar o PDF !'
      	Return(::aRetorno)
   	EndIf
	EndIf

   ::aRetorno[ 'OK' ] := .T.

   RETURN ::aRetorno

METHOD buscaDadosXML() CLASS hbMDFeDaMdfe

   LOCAL cIde, cEmit, cinfNF, cinfNFe
   LOCAL cinfCTe , cchCT , cchNFe
   LOCAL cRodo , cVeiculo , cProtocolo , cNF
   LOCAL cValePed , cProp, cMunCarreg , cModal , cMunDescarga , cTot
   LOCAL nInicio:=0 , cCondutor , cReboque

   cIde := XmlNodeInvertido( "ide", ::cXML )
   ::aIde := hb_Hash()
      ::aIde[ "cUF" ]     := XmlNodeInvertido( "cUF", cIde )
      ::aIde[ "tpAmb" ]   := XmlNodeInvertido( "tpAmb", cIde )  // 1 - retrato 2-paisagem
      ::aIde[ "tpEmis" ]  := XmlNodeInvertido( "tpEmis", cIde )
      ::aIde[ "mod" ]     := XmlNodeInvertido( "mod", cIde )
      ::aIde[ "serie" ]   := XmlNodeInvertido( "serie", cIde )
      ::aIde[ "nMDF" ]    := XmlNodeInvertido( "nMDF", cIde )
      ::aIde[ "cMDF" ]    := XmlNodeInvertido( "cMDF", cIde )
      ::aIde[ "cDV" ]     := XmlNodeInvertido( "cDV", cIde )
      ::aIde[ "modal" ]   := XmlNodeInvertido( "modal", cIde ) // versao sistema
      ::aIde[ "dhEmi" ]   := XmlNodeInvertido( "dhEmi", cIde )
      ::aIde[ "tpEmis" ]  := XmlNodeInvertido( "tpEmis", cIde )
      ::aIde[ "procEmi" ] := XmlNodeInvertido( "procEmi", cIde )
      ::aIde[ "verProc" ] := XmlNodeInvertido( "verProc", cIde )  // 1- producao 2-homologacao
      ::aIde[ "UFIni" ]   := XmlNodeInvertido( "UFIni", cIde ) // versao sistema
      ::aIde[ "UFFim" ]   := XmlNodeInvertido( "UFFim", cIde ) // versao sistema

   cMunCarreg := XmlNodeInvertido( "infMunCarrega", ::cXML )
      ::aMunCarreg := hb_Hash()
      ::aMunCarreg[ "cMunCarrega" ] := XmlNodeInvertido( "cMunCarrega", cMunCarreg )

   cEmit := XmlNodeInvertido( "emit", ::cXML )
      ::aEmit := hb_Hash()
      ::aEmit[ "CNPJ" ]  := XmlNodeInvertido( "CNPJ", cEmit )
      ::aEmit[ "IE" ]    := XmlNodeInvertido( "IE", cEmit ) // avulso pelo fisco
      ::aEmit[ "xNome" ] := XmlToString( XmlNodeInvertido( "xNome", cEmit ) )
      ::aEmit[ "xFant" ] := XmlNodeInvertido( "xFant", cEmit )

      cEmit := XmlNodeInvertido( "enderEmit", cEmit )
         ::aEmit[ "xLgr" ]    := XmlNodeInvertido( "xLgr", cEmit )
         ::aEmit[ "nro" ]     := XmlNodeInvertido( "nro", cEmit )
         ::aEmit[ "xCpl" ]    := XmlNodeInvertido( "xCpl", cEmit )
         ::aEmit[ "xBairro" ] := XmlNodeInvertido( "xBairro", cEmit )
         ::aEmit[ "cMun" ]    := XmlNodeInvertido( "cMun", cEmit )
         ::aEmit[ "xMun" ]    := XmlNodeInvertido( "xMun", cEmit )
         ::aEmit[ "CEP" ]     := XmlNodeInvertido( "CEP", cEmit )
         ::aEmit[ "UF" ]      := XmlNodeInvertido( "UF", cEmit )
         ::aEmit[ "fone" ]    := XmlNodeInvertido( "fone", cEmit ) // NFE 2.0

   cModal := XmlNodeInvertido( "rem", ::cXML )
      ::aModal := hb_Hash()
      ::aModal[ "versaoModal" ] := XmlNodeInvertido( "versaoModal", cModal )

   cMunDescarga := XmlNodeInvertido( "infMunDescarga", ::cXML )
      ::aMunDescarga := hb_Hash()
      ::aMunDescarga[ "cMunDescarga" ] := XmlNodeInvertido( "cMunDescarga", cMunDescarga )
      ::aMunDescarga[ "xMunDescarga" ] := XmlNodeInvertido( "xMunDescarga", cMunDescarga )


// cte

	::ainfCTe := {}
	nInicio   := 0
   cinfCTe   := XmlNodeInvertido( "infCTe", ::cXML )
   DO WHILE .T.
	   cchCT := XmlNodeInvertido( "chCT", cinfCTe , , @nInicio )
		IF Empty( cchCT )
			EXIT
		ENDIF
		Aadd(	::ainfCTe, XmlNodeInvertido( "chCT", cchCT ) )
	ENDDO

	::ainfNF := {}
	nInicio  := 0
   cinfNF   := XmlNodeInvertido( "infNF", ::cXML )
	DO WHILE .T.
	   cNF := XmlNodeInvertido( "infNF", cinfNF , , @nInicio )
		IF Empty( cNF )
			EXIT
		ENDIF
		Aadd(	::ainfNF,{ XmlNodeInvertido( "CNPJ", cNF ), + ;
							  XmlNodeInvertido( "UF", cNF ), + ;
							  XmlNodeInvertido( "nNF", cNF ), + ;
							  XmlNodeInvertido( "serie", cNF ), + ;
							  XmlNodeInvertido( "dEmi", cNF ), + ;
						     XmlNodeInvertido( "vNF", cNF ), + ;
							  XmlNodeInvertido( "PIN", cNF ) } )
	ENDDO

	::ainfNFe := {}
	nInicio   := 0
  	cinfNFe   := XmlNodeInvertido( "infNFe" , ::cXML ) // versao 2.0
	DO WHILE .T.
   	cchNFe := XmlNodeInvertido( "chNFe", cinfNFe , , @nInicio )
		IF Empty( cchNFe )
			EXIT
		ENDIF
		Aadd( ::ainfNFe, XmlNodeInvertido( "chNFe", cchNFe ) )
	ENDDO

   cTot := XmlNodeInvertido( "tot", ::cXML )
      ::aTot := hb_Hash()
      ::aTot[ "qCTe" ]   := XmlNodeInvertido( "qCTe", cTot )
      ::aTot[ "qCT" ]    := XmlNodeInvertido( "qCT", cTot )
      ::aTot[ "qNFe" ]   := XmlNodeInvertido( "qNFe", cTot )
      ::aTot[ "qNF" ]    := XmlNodeInvertido( "qNF", cTot )
      ::aTot[ "vCarga" ] := XmlNodeInvertido( "vCarga", cTot )
      ::aTot[ "cUnid" ]  := XmlNodeInvertido( "cUnid", cTot )
      ::aTot[ "qCarga" ] := XmlNodeInvertido( "qCarga", cTot )

   ::cLacre := XmlNodeInvertido( "nLacre", ::cXML )

   ::cInfCpl := XmlNodeInvertido( "infCpl", ::cXML )

   cRodo := XmlNodeInvertido( "rodo", ::cXML )
      ::cRntrcEmit := XmlNodeInvertido( "RNTRC", cRodo )
      ::cCiot      := XmlNodeInvertido( "CIOT", cRodo )

  	cVeiculo := XmlNodeInvertido( "veicTracao", ::cXml )
      ::aVeiculo := hb_Hash()
	   ::aVeiculo[ "placa" ] := XmlNodeInvertido( "placa", cVeiculo )
      ::aVeiculo[ "tara" ]  := XmlNodeInvertido( "tara", cVeiculo )

   cProp := XmlNodeInvertido( "prop", ::cXml )
      ::aProp := hb_Hash()
	   ::aProp[ "RNTRC" ] := XmlNodeInvertido( "RNTRC", cProp ) // NFE 2.0

  	cCondutor := XmlNodeInvertido( "condutor", ::cXml )
      ::aCondutor := hb_Hash()
	   ::aCondutor[ "xNome" ] := XmlNodeInvertido( "xNome", cCondutor )
      ::aCondutor[ "CPF" ]   := XmlNodeInvertido( "CPF", cCondutor )

  	cReboque := XmlNodeInvertido( "veicReboque", ::cXml )
      ::aReboque := hb_Hash()
   	::aReboque[ "placa" ] := XmlNodeInvertido( "placa", cReboque )
      ::aReboque[ "tara" ]  := XmlNodeInvertido( "tara", cReboque )
      ::aReboque[ "capKG" ] := XmlNodeInvertido( "capKG", cReboque )
      ::aReboque[ "RNTRC" ] := XmlNodeInvertido( "RNTRC", cReboque )

  	cValePed := XmlNodeInvertido( "valePed", ::cXml )
      ::aValePed := hb_Hash()
      ::aValePed[ "CNPJForn" ] := XmlNodeInvertido( "CNPJForn", cValePed )
      ::aValePed[ "CNPJPg" ] := XmlNodeInvertido( "CNPJPg", cValePed )
      ::aValePed[ "nCompra" ] := XmlNodeInvertido( "nCompra", cValePed )

   cProtocolo := XmlNodeInvertido( "infProt", ::cXML )
      ::aProtocolo := hb_Hash()
      ::aProtocolo[ "nProt" ]    := XmlNodeInvertido( "nProt", cProtocolo ) // NFE 2.0
      ::aProtocolo[ "dhRecbto" ] := XmlNodeInvertido( "dhRecbto", cProtocolo ) // NFE 2.0

   RETURN .T.

METHOD geraPDF() CLASS hbMDFeDaMdfe

   // criacao objeto pdf
   ::oPdf := HPDF_New()
   If ::oPdf == NIL
      ::aRetorno[ 'OK' ] := .F.
      ::aRetorno[ 'MsgErro' ] := 'Falha da criação do objeto PDF !'
      Return(.F.)
   Endif
   /* set compression mode */
   HPDF_SetCompressionMode( ::oPdf, HPDF_COMP_ALL )
   /* setando fonte */
   If ::cFonteNFe == "Times"
      ::oPdfFontCabecalho := HPDF_GetFont( ::oPdf, "Times-Roman", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Times-Bold", "CP1252" )
   Else
      ::oPdfFontCabecalho := HPDF_GetFont( ::oPdf, "Courier", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Courier-Bold", "CP1252" )
   Endif

      && Inserido por Anderson Camilo em 04/04/2012

   ::cFonteCode128 := HPDF_LoadType1FontFromFile(::oPdf, 'fontes\Code128bWinLarge.afm', 'fontes\Code128bWinLarge.pfb')   && Code 128
   ::cFonteCode128F := HPDF_GetFont( ::oPdf, ::cFonteCode128, "WinAnsiEncoding" )

   // final da criacao e definicao do objeto pdf

   ::nFolha := 1
   ::novaPagina()
   ::cabecalho()
   ::cFile := ::PastaPdf + ::cChave + ".pdf"
   HPDF_SaveToFile( ::oPdf, ::cFile )
   HPDF_Free( ::oPdf )

   RETURN .T.

METHOD NovaPagina() CLASS hbMDFeDaMdfe

   LOCAL nRadiano, nAngulo

   ::oPdfPage := HPDF_AddPage( ::oPdf )

   HPDF_Page_SetSize( ::oPdfPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT )

   ::nLinhaPdf := HPDF_Page_GetHeight( ::oPDFPage ) - 20    && Margem Superior
   nAngulo := 45                   /* A rotation of 45 degrees. */

   nRadiano := nAngulo / 180 * 3.141592 /* Calcurate the radian value. */

   IF ::aIde[ "tpAmb" ] = "2" .Or. ::aProtocolo[ "nProt" ] = Nil

      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText(::oPdfPage)
      HPDF_Page_SetTextMatrix(::oPdfPage, cos(nRadiano), sin(nRadiano), -sin(nRadiano), cos(nRadiano), 15, 100)
      HPDF_Page_SetRGBFill(::oPdfPage, 0.75, 0.75, 0.75)
      HPDF_Page_ShowText(::oPdfPage, "AMBIENTE DE HOMOLOGAÇÃO - SEM VALOR FISCAL")
      HPDF_Page_EndText(::oPdfPage)

      HPDF_Page_SetRGBStroke(::oPdfPage, 0.75, 0.75, 0.75)
      hbNFe_Line_Hpdf( ::oPdfPage, 15,100, 550, 630, 2.0)

      HPDF_Page_SetRGBStroke(::oPdfPage, 0, 0, 0) // reseta cor linhas

      HPDF_Page_SetRGBFill(::oPdfPage, 0, 0, 0) // reseta cor fontes

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
      	   hbCte_Line_Hpdf( ::oPdfPage, 15, 95, 675, 475, 2.0)
	      ELSE
   	      hbCte_Line_Hpdf( ::oPdfPage, 15, 95, 550, 630, 2.0)
      	ENDIF

	      HPDF_Page_SetRGBStroke(::oPdfPage, 0, 0, 0) // reseta cor linhas

      	HPDF_Page_SetRGBFill(::oPdfPage, 0, 0, 0) // reseta cor fontes

		ENDIF
*/
   ENDIF

   RETURN NIL

METHOD cabecalho() CLASS hbMDFeDaMdfe

   LOCAL oImage

   // box do logotipo e dados do emitente

   hbCte_Box_Hpdf( ::oPdfPage,  020 , ::nLinhaPdf-150 , 555 , 150 , ::nLarguraBox )
   oImage:= HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
   HPDF_Page_DrawImage( ::oPdfPage, oImage, 025 , ::nLinhaPdf - (142+1), 200, 132)
   hbCte_Texto_Hpdf( ::oPdfPage,240, ::nLinhaPdf-018, 560, Nil, ::aEmit[ "xNome" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 16 )
   hbCte_Texto_Hpdf( ::oPdfPage,240, ::nLinhaPdf-060, 560, Nil, 'CNPJ: '+TRANSF( ::aEmit[ "CNPJ" ] , "@R 99.999.999/9999-99")+'       Inscrição Estadual: '+FormatIE( ::aEmit[ "IE" ], ::aEmit[ "UF" ] ) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10)
   hbCte_Texto_Hpdf( ::oPdfPage,240, ::nLinhaPdf-072, 560, Nil, 'Logradouro: '+::aEmit[ "xLgr" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10)
   hbCte_Texto_Hpdf( ::oPdfPage,240, ::nLinhaPdf-084, 560, Nil, "No.: "+Iif(::aEmit[ "nro" ]  != Nil,::aEmit[ "nro" ],'')+Iif(::aEmit[ "xCpl" ] != Nil," - Complemento: "+::aEmit[ "xCpl" ],''), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10)
   hbCte_Texto_Hpdf( ::oPdfPage,240, ::nLinhaPdf-096, 560, Nil, 'Bairro: '+::aEmit[ "xBairro" ]+" - CEP: "+TRANSF( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10)
   hbCte_Texto_Hpdf( ::oPdfPage,240, ::nLinhaPdf-108, 560, Nil, 'Município: '+::aEmit[ "xMun" ]+" - Estado: "+::aEmit[ "UF" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10)
   hbCte_Texto_Hpdf( ::oPdfPage,240, ::nLinhaPdf-120, 560, Nil, 'Fone/Fax:(' + Subs(::aEmit[ "fone" ], 1, 2 ) + ')' + Subs( ::aEmit[ "fone" ], 3, 4 ) + '-' + Subs( ::aEmit[ "fone" ], 7, 4 ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10)

   // box do nome do documento
   hbCte_Box_Hpdf( ::oPdfPage, 020 , ::nLinhaPdf-180 , 555 , 025 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-158 , 100, Nil, "DAMDFE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 16 )
   hbCte_Texto_Hpdf( ::oPdfPage, 100 , ::nLinhaPdf-161 , 560, Nil, "Documento Auxiliar de Manifesto Eletrônico de Documentos Fiscais" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalhoBold, 12)

   // box do controle do fisco
   hbCte_Box_Hpdf( ::oPdfPage, 020 , ::nLinhaPdf-345 , 555 , 160 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 020 , ::nLinhaPdf-185 , 560, Nil, "CONTROLE DO FISCO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 09 )
   hbCte_Texto_Hpdf( ::oPdfPage, 020 , ::nLinhaPdf-197 , 575, Nil, CTe_CodificaCode128c(::cChave), HPDF_TALIGN_CENTER, Nil, ::cFonteCode128F, 35 )
   hbCte_Line_Hpdf( ::oPdfPage, 020 , ::nLinhaPdf-277 , 575 , ::nLinhaPdf-277 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-278 , 575, Nil, "Chave de acesso para consulta de autenticidade no site www.mdfe.fazenda.gov.br" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 12)
   hbCte_Texto_Hpdf( ::oPdfPage, 040 , ::nLinhaPdf-293 , 575, Nil, TRANSF(::cChave, "@R 99.9999.99.999.999/9999-99-99-999-999.999.999-999.999.999-9") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12)
   hbCte_Line_Hpdf( ::oPdfPage, 020 , ::nLinhaPdf-310 , 575 , ::nLinhaPdf-310 , ::nLarguraBox )
   // box do No. do Protocolo
   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-311 , 575, Nil, "Protocolo de autorização de uso" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 12)
   IF ::aProtocolo[ "nProt" ] != Nil
	   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-326 , 575, Nil, ::aProtocolo[ "nProt" ]+' - '+SUBS(::aProtocolo[ "dhRecbto" ],9,2)+"/"+SUBS(::aProtocolo[ "dhRecbto" ],6,2)+"/"+SUBS(::aProtocolo[ "dhRecbto" ],1,4)+' '+SUBS(::aProtocolo[ "dhRecbto" ],12) , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalhoBold, 12)
   ELSE
	   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-326 , 575, Nil, 'MDFe sem Autorização de Uso da SEFAZ' , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalhoBold, 12)
   ENDIF

   // box do modelo
   hbCte_Box_Hpdf( ::oPdfPage, 020 , ::nLinhaPdf-385 , 555 , 035 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-350 , 100, Nil, "Modelo" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12)
   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-365 , 100, Nil, ::aIde[ "mod" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10)

   // box da serie
   hbCte_Line_Hpdf( ::oPdfPage, 100 , ::nLinhaPdf-385 , 100 , ::nLinhaPdf-350 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 105 , ::nLinhaPdf-350 , 180, Nil, "Série" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12)
   hbCte_Texto_Hpdf( ::oPdfPage, 105 , ::nLinhaPdf-365 , 180, Nil, ::aIde[ "serie" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10)

   // box do numero
   hbCte_Line_Hpdf( ::oPdfPage, 180 , ::nLinhaPdf-385 , 180 , ::nLinhaPdf-350 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 185 , ::nLinhaPdf-350 , 285, Nil, "Número" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12)
   hbCte_Texto_Hpdf( ::oPdfPage, 185 , ::nLinhaPdf-365 , 285, Nil, StrZero(Val(::aIde[ "nMDF" ]),6) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10)

   // box do fl
   hbCte_Line_Hpdf( ::oPdfPage, 285 , ::nLinhaPdf-385 , 285 , ::nLinhaPdf-350 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 290 , ::nLinhaPdf-350 , 330, Nil, "FL" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12)
   hbCte_Texto_Hpdf( ::oPdfPage, 290 , ::nLinhaPdf-365 , 330, Nil, "1/1" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10)

   // box do data e hora
   hbCte_Line_Hpdf( ::oPdfPage, 330 , ::nLinhaPdf-385 , 330 , ::nLinhaPdf-350 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 335 , ::nLinhaPdf-350 , 500, Nil, "Data e Hora de Emissão" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12)
   hbCte_Texto_Hpdf( ::oPdfPage, 335 , ::nLinhaPdf-365 , 500, Nil, SUBS(::aIde[ "dhEmi" ],9,2)+"/"+SUBS(::aIde[ "dhEmi" ],6,2)+"/"+SUBS(::aIde[ "dhEmi" ],1,4)+' '+SUBS(::aIde[ "dhEmi" ],12) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10)

   // UF de carregamento
   hbCte_Line_Hpdf( ::oPdfPage, 500 , ::nLinhaPdf-385 , 500 , ::nLinhaPdf-350 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 505 , ::nLinhaPdf-350 , 560, Nil, "UF Carreg." , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12)
   hbCte_Texto_Hpdf( ::oPdfPage, 505 , ::nLinhaPdf-365 , 560, Nil, ::aIde[ "UFIni" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10)

   // box do modal
   hbCte_Box_Hpdf( ::oPdfPage, 020 , ::nLinhaPdf-410 , 555 , 020 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-393 , 560, Nil, "Modal Rodoviário de Carga" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
   hbCte_Box_Hpdf( ::oPdfPage, 020 , ::nLinhaPdf-445 , 555 , 035 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-410 , 140, Nil, "CIOT" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalho, 12)
   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-425 , 140, Nil, ::cCiot , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10)

   hbCte_Line_Hpdf( ::oPdfPage, 140 , ::nLinhaPdf-445 , 140 , ::nLinhaPdf-410 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 145 , ::nLinhaPdf-410 , 210, Nil, "Qtd. CTe" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12 )
   hbCte_Texto_Hpdf( ::oPdfPage, 145 , ::nLinhaPdf-425 , 210, Nil, ::aTot[ "qCTe" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   hbCte_Line_Hpdf( ::oPdfPage, 210 , ::nLinhaPdf-445 , 210 , ::nLinhaPdf-410 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 215 , ::nLinhaPdf-410 , 280, Nil, "Qtd. CTRC" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12 )
   hbCte_Texto_Hpdf( ::oPdfPage, 215 , ::nLinhaPdf-425 , 280, Nil, ::aTot[ "qCT" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   hbCte_Line_Hpdf( ::oPdfPage, 280 , ::nLinhaPdf-445 , 280 , ::nLinhaPdf-410 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 285 , ::nLinhaPdf-410 , 350, Nil, "Qtd. NFe" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12 )
   hbCte_Texto_Hpdf( ::oPdfPage, 285 , ::nLinhaPdf-425 , 350, Nil, ::aTot[ "qNFe" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   hbCte_Line_Hpdf( ::oPdfPage, 350 , ::nLinhaPdf-445 , 350 , ::nLinhaPdf-410 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 355 , ::nLinhaPdf-410 , 420, Nil, "Qtd. NF" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12 )
   hbCte_Texto_Hpdf( ::oPdfPage, 355 , ::nLinhaPdf-425 , 420, Nil, ::aTot[ "qNF" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   hbCte_Line_Hpdf( ::oPdfPage, 425 , ::nLinhaPdf-445 , 425 , ::nLinhaPdf-410 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 430 , ::nLinhaPdf-410 , 560, Nil, "Peso Total (KG)" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 12 )
   hbCte_Texto_Hpdf( ::oPdfPage, 430 , ::nLinhaPdf-425 , 560, Nil, Alltrim(Tran( Val(::aTot[ "qCarga" ] ) , '@E 9,999,999.9999' )) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   hbCte_Box_Hpdf( ::oPdfPage, 020 , ::nLinhaPdf-620 , 555 , 175 , ::nLarguraBox )
   hbCte_Line_Hpdf( ::oPdfPage, 240 , ::nLinhaPdf-460 , 240 , ::nLinhaPdf-445 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-445 , 240, Nil, "Veiculo" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 12 )
   hbCte_Texto_Hpdf( ::oPdfPage, 245 , ::nLinhaPdf-445 , 560, Nil, "Condutor" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 12 )

   hbCte_Box_Hpdf( ::oPdfPage, 020 , ::nLinhaPdf-475 , 555 , 015 , ::nLarguraBox )
   hbCte_Line_Hpdf( ::oPdfPage, 110 , ::nLinhaPdf-550 , 110 , ::nLinhaPdf-460 , ::nLarguraBox )
   hbCte_Line_Hpdf( ::oPdfPage, 240 , ::nLinhaPdf-620 , 240 , ::nLinhaPdf-460 , ::nLarguraBox )
   hbCte_Line_Hpdf( ::oPdfPage, 320 , ::nLinhaPdf-620 , 320 , ::nLinhaPdf-460 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-460 , 110, Nil, "Placa" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbCte_Texto_Hpdf( ::oPdfPage, 115 , ::nLinhaPdf-460 , 240, Nil, "RNTRC" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbCte_Texto_Hpdf( ::oPdfPage, 245 , ::nLinhaPdf-460 , 320, Nil, "CPF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbCte_Texto_Hpdf( ::oPdfPage, 325 , ::nLinhaPdf-460 , 560, Nil, "Nome" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
   hbCte_Box_Hpdf( ::oPdfPage, 020 , ::nLinhaPdf-550 , 220 , 075 , ::nLarguraBox )

   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-475 , 110, Nil, ::aVeiculo[ "placa" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   IF !Empty(::aProp[ "RNTRC" ])
	   hbCte_Texto_Hpdf( ::oPdfPage, 115 , ::nLinhaPdf-475 , 240, Nil, ::aProp[ "RNTRC" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   ELSE
	   hbCte_Texto_Hpdf( ::oPdfPage, 115 , ::nLinhaPdf-475 , 240, Nil, ::cRntrcEmit , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   ENDIF
   hbCte_Texto_Hpdf( ::oPdfPage, 245 , ::nLinhaPdf-475 , 320, Nil, TRANSF(::aCondutor[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   hbCte_Texto_Hpdf( ::oPdfPage, 325 , ::nLinhaPdf-475 , 560, Nil, ::aCondutor[ "xNome" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )

   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-490 , 110, Nil, ::aReboque[ "placa" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   hbCte_Texto_Hpdf( ::oPdfPage, 115 , ::nLinhaPdf-490 , 240, Nil, ::aReboque[ "RNTRC" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )

   hbCte_Box_Hpdf( ::oPdfPage, 020 , ::nLinhaPdf-565 , 220 , 015 , ::nLarguraBox )
   hbCte_Line_Hpdf( ::oPdfPage, 100 , ::nLinhaPdf-620 , 100 , ::nLinhaPdf-565 , ::nLarguraBox )
   hbCte_Line_Hpdf( ::oPdfPage, 170 , ::nLinhaPdf-620 , 170 , ::nLinhaPdf-565 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-552 , 110, Nil, "Vale Pedágio" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 12 )
   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-565 , 095, Nil, "Responsável CNPJ" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 08 )
   hbCte_Texto_Hpdf( ::oPdfPage, 100 , ::nLinhaPdf-565 , 170, Nil, "Fornecedor CNPJ" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 08 )
   hbCte_Texto_Hpdf( ::oPdfPage, 175 , ::nLinhaPdf-565 , 240, Nil, "No.Comprovante" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 08 )
   IF Valtype(::aValePed[ "CNPJPg" ])!= 'U'
	   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-580 , 095, Nil, TRANSF(::aValePed[ "CNPJPg" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 08 )
   ENDIF
   IF Valtype(::aValePed[ "CNPJForn" ])!= 'U'
	   hbCte_Texto_Hpdf( ::oPdfPage, 100 , ::nLinhaPdf-580 , 170, Nil, TRANSF(::aValePed[ "CNPJForn" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 08 )
   ENDIF
   IF Valtype(::aValePed[ "nCompra" ])!= 'U'
	   hbCte_Texto_Hpdf( ::oPdfPage, 175 , ::nLinhaPdf-580 , 240, Nil, ::aValePed[ "nCompra" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 08 )
   ENDIF
   hbCte_Box_Hpdf( ::oPdfPage, 020 , ::nLinhaPdf-775 , 555 , 150 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-625 , 210, Nil, "Observações" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 12 )
   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-640 , 560, Nil, ::cInfCpl , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   IF ! Empty(::cLacre)
	   hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-655 , 560, Nil, 'No. do Lacre: '+::cLacre , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   ENDIF

   // Data e Desenvolvedor da Impressao
   hbCte_Texto_Hpdf( ::oPdfPage, 025, ::nLinhaPdf-800 , 300, Nil , "DATA DA IMPRESSÃO: "+DTOC(DATE()) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
   hbCte_Texto_Hpdf( ::oPdfPage, 400, ::nLinhaPdf-800 , 560, Nil , "VesSystem" , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalhoBold, 6 )

   RETURN NIL

STATIC FUNCTION hbCte_Texto_Hpdf( oPdfPage2, x1, y1, x2, y2, cText, align, Dummy, oFontePDF, nTamFonte, nAngulo)

   LOCAL nRadiano

   IF oFontePDF <> Nil
      HPDF_Page_SetFontAndSize( oPdfPage2, oFontePDF, nTamFonte )
   ENDIF
   IF x2 = Nil
      x2 := x1 - nTamFonte
   ENDIF
   HPDF_Page_BeginText( oPdfPage2 )
   IF nAngulo == Nil // horizontal normal
      HPDF_Page_TextRect ( oPdfPage2,  x1, y1, x2, y2, cText, align, NIL)
   ELSE
      nRadiano := nAngulo / 180 * 3.141592 /* Calcurate the radian value. */
      HPDF_Page_SetTextMatrix( oPdfPage2, cos(nRadiano), sin(nRadiano), -sin(nRadiano), cos(nRadiano), x1, y1)
      HPDF_Page_ShowText( oPdfPage2, cText )
   ENDIF
   HPDF_Page_EndText  ( oPdfPage2 )
   HB_SYMBOL_UNUSED( Dummy )

   RETURN NIL

STATIC FUNCTION hbCte_Box_Hpdf( oPdfPage2, x1, y1, x2, y2, nPen)

   HPDF_Page_SetLineWidth( oPdfPage2, nPen )
   HPDF_Page_Rectangle( oPdfPage2, x1, y1, x2, y2 )
   HPDF_Page_Stroke( oPdfPage2 )

   RETURN Nil

STATIC FUNCTION hbCte_Line_Hpdf( oPdfPage2, x1, y1, x2, y2, nPen, FLAG)

   HPDF_Page_SetLineWidth(oPdfPage2, nPen)
   IF FLAG <> Nil
      HPDF_Page_SetLineCap( oPdfPage2, FLAG)
   ENDIF
   HPDF_Page_MoveTo(oPdfPage2, x1, y1)
   HPDF_Page_LineTo(oPdfPage2, x2, y2)
   HPDF_Page_Stroke(oPdfPage2)
   IF FLAG <> Nil
      HPDF_Page_SetLineCap(oPdfPage2, HPDF_BUTT_END)
   ENDIF

   RETURN NIL

//STATIC FUNCTION hbCte_Zebra_Draw_Hpdf( hZebra, page, ... )
//
//   IF hb_zebra_GetError( hZebra ) != 0
//      RETURN HB_ZEBRA_ERROR_INVALIDZEBRA
//   ENDIF
//
//   hb_zebra_draw( hZebra, {| x, y, w, h | HPDF_Page_Rectangle( page, x, y, w, h ) }, ... )
//
//   HPDF_Page_Fill( page )
//
//   RETURN 0
//#endif

STATIC FUNCTION Cte_CodificaCode128c(pcCodigoBarra)

   &&  Parameters de entrada : O codigo de barras no formato Code128C "somente numeros" campo tipo caracter
   &&  Retorno               : Retorna o código convertido e com o caracter de START e STOP mais o checksum
   &&                        : para impressão do código de barras utilizando a fonte Code128bWin, é necessário
   &&                        : para utilizar essa fonte os arquivos Code128bWin.ttf, Code128bWin.afm e Code128bWin.pfb
   && Autor                  : Anderson Camilo
   && Data                   : 19/03/2012

   LOCAL nI :=0, checksum :=0, cCode128 := '', cCodigoBarra, nValorCar

   cCodigoBarra = pcCodigoBarra
   if len(cCodigoBarra) > 0    && Verifica se os caracteres são válidos (somente números)
      if int(len(cCodigoBarra) / 2) = len(cCodigoBarra) / 2    && Tem ser par o tamanho do código de barras
         for nI = 1 to len(cCodigoBarra)
             if (Asc( substr ( cCodigoBarra, nI, 1) ) < 48 .or. Asc( substr ( cCodigoBarra, nI, 1) ) > 57)
                nI = 0
	            exit
             endif
         next
      endif
      if nI > 0
         nI = 1 &&  nI é o índice da cadeia
         cCode128 = chr(155)

         do while nI <= len ( cCodigoBarra )
            nValorCar = val ( substr( cCodigoBarra, nI, 2) )
            if nValorCar = 0
               nValorCar += 128
            elseif nValorCar < 95
               nValorCar += 32
            else
               nValorCar +=  50
            endif
            cCode128 += Chr(nValorCar)
            nI = nI + 2
         enddo

         && Calcula o checksum
         for nI = 1 to len(cCode128)
            nValorCar = asc ( substr( cCode128, nI, 1 ) )
            if nValorCar = 128
               nValorCar = 0
            elseif nValorCar < 127
               nValorCar -= 32
            else
               nValorCar -=  50
            endif
            if nI = 1
		         checksum = nValorCar
            endif
            checksum = mod( (checksum + (nI - 1) * nValorCar ) , 103)
         next
	      &&  Cálculo código ASCII do checkSum
         if checksum = 0
            checksum += 128
         elseif checksum < 95
            checksum += 32
         else
            checksum +=  50
         endif
         && Adiciona o checksum e STOP
         cCode128 = cCode128 + Chr(checksum) +  chr(156)
      endif
   endif

   RETURN cCode128

STATIC FUNCTION hbNFe_Line_Hpdf( oPdfPage2, x1, y1, x2, y2, nPen, FLAG )

   HPDF_Page_SetLineWidth( oPdfPage2, nPen )
   IF FLAG <> NIL
      HPDF_Page_SetLineCap( oPdfPage2, FLAG )
   ENDIF
   HPDF_Page_MoveTo( oPdfPage2, x1, y1 )
   HPDF_Page_LineTo( oPdfPage2, x2, y2 )
   HPDF_Page_Stroke( oPdfPage2 )
   IF FLAG <> NIL
      HPDF_Page_SetLineCap( oPdfPage2, HPDF_BUTT_END )
   ENDIF

   RETURN NIL

STATIC FUNCTION FormatIE( cIE, cUF )

   cIE := AllTrim( cIE )
   IF cIE == "ISENTO" .OR. Empty( cIE )
      RETURN cIE
   ENDIF
   cIE := SoNumeros( cIE )

   HB_SYMBOL_UNUSED( cUF )
   RETURN cIE

STATIC FUNCTION XmlNodeInvertido( a, b, c )

   RETURN XmlNode( b, a, c )
