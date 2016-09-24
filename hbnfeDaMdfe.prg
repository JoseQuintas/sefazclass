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
#include "hbnfe.ch"

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
   DATA aValePed
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
   DATA nCopias

   DATA cFile
   DATA oFuncoes
   DATA ohbNFe
   DATA lValorDesc INIT .F.
   DATA nCasasQtd INIT 2
   DATA nCasasVUn INIT 2
   DATA aRetorno
   DATA PastaPdf

ENDCLASS

METHOD execute() CLASS hbMDFeDaMdfe

	::oFuncoes := hbNFeFuncoes()
   IF ::lLaser <> Nil
      ::lLaser := .T.
   ENDIF
   IF ::cFonteNFe = Nil
      ::cFonteNFe := 'Times'
   ENDIF

   IF ::nCopias = Nil
      ::nCopias := 1
   ENDIF

   ::aRetorno := hash()

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
RETURN(::aRetorno)

METHOD buscaDadosXML() CLASS hbMDFeDaMdfe
LOCAL cIde, cCompl , cEmit, cRem , cinfNF , cinfNFe , cinfOutros , cDest , cLocEnt , cPrest , cComp
LOCAL cIcms00 , cIcms20 , cIcms45 , cIcms60 , cIcms90 , cIcmsUF , cIcmsSN , cinfCTe , cchCT , cchNFe
LOCAL cinfCTeNorm , cInfCarga , cSeg , cRodo , cVeiculo , cProtCTe , cProtocolo , cExped , cNF
LOCAL cReceb , cInfQ , cValePed , cMoto , cProp, cMunCarreg , cModal , cMunDescarga , cTot
LOCAL nInicio:=0 , cCondutor , cReboque

   oFuncoes := hbNFeFuncoes()

// Identifacao

   cIde := hbCte_PegaDadosXML("ide", ::cXML )
   ::aIde := hash()
   ::aIde[ "cUF" ] := hbCte_PegaDadosXML("cUF", cIde )
   ::aIde[ "tpAmb" ] := hbCte_PegaDadosXML("tpAmb", cIde )  // 1 - retrato 2-paisagem
   ::aIde[ "tpEmis" ] := hbCte_PegaDadosXML("tpEmis", cIde )
   ::aIde[ "mod" ] := hbCte_PegaDadosXML("mod", cIde )
   ::aIde[ "serie" ] := hbCte_PegaDadosXML("serie", cIde )
   ::aIde[ "nMDF" ] := hbCte_PegaDadosXML("nMDF", cIde )
   ::aIde[ "cMDF" ] := hbCte_PegaDadosXML("cMDF", cIde )
   ::aIde[ "cDV" ] := hbCte_PegaDadosXML("cDV", cIde )
   ::aIde[ "modal" ] := hbCte_PegaDadosXML("modal", cIde ) // versao sistema
   ::aIde[ "dhEmi" ] := hbCte_PegaDadosXML("dhEmi", cIde )
   ::aIde[ "tpEmis" ] := hbCte_PegaDadosXML("tpEmis", cIde )
   ::aIde[ "procEmi" ] := hbCte_PegaDadosXML("procEmi", cIde )
   ::aIde[ "verProc" ] := hbCte_PegaDadosXML("verProc", cIde )  // 1- producao 2-homologacao
   ::aIde[ "UFIni" ] := hbCte_PegaDadosXML("UFIni", cIde ) // versao sistema
   ::aIde[ "UFFim" ] := hbCte_PegaDadosXML("UFFim", cIde ) // versao sistema

// Municipio de carregamento
   cMunCarreg := hbCte_PegaDadosXML("infMunCarrega", ::cXML )
   ::aMunCarreg := hash()
   ::aMunCarreg[ "cMunCarrega" ] := hbCte_PegaDadosXML("cMunCarrega", cMunCarreg )

// Emitente

   cEmit := hbCte_PegaDadosXML("emit", ::cXML )
   ::aEmit := hash()
   ::aEmit[ "CNPJ" ] := hbCte_PegaDadosXML("CNPJ", cEmit )
   ::aEmit[ "IE" ] := hbCte_PegaDadosXML("IE", cEmit ) // avulso pelo fisco
   ::aEmit[ "xNome" ] := oFuncoes:parseDecode( hbCte_PegaDadosXML("xNome", cEmit ) )
   ::aEmit[ "xFant" ] := hbCte_PegaDadosXML("xFant", cEmit )

   cEmit := hbCte_PegaDadosXML("enderEmit", cEmit )

   ::aEmit[ "xLgr" ] := hbCte_PegaDadosXML("xLgr", cEmit )
   ::aEmit[ "nro" ] := hbCte_PegaDadosXML("nro", cEmit )
   ::aEmit[ "xCpl" ] := hbCte_PegaDadosXML("xCpl", cEmit )
   ::aEmit[ "xBairro" ] := hbCte_PegaDadosXML("xBairro", cEmit )
   ::aEmit[ "cMun" ] := hbCte_PegaDadosXML("cMun", cEmit )
   ::aEmit[ "xMun" ] := hbCte_PegaDadosXML("xMun", cEmit )
   ::aEmit[ "CEP" ] := hbCte_PegaDadosXML("CEP", cEmit )
   ::aEmit[ "UF" ] := hbCte_PegaDadosXML("UF", cEmit )
   ::aEmit[ "fone" ] := hbCte_PegaDadosXML("fone", cEmit ) // NFE 2.0

// Informacao sobre o modal

   cModal := hbCte_PegaDadosXML("rem", ::cXML )
   ::aModal := hash()
   ::aModal[ "versaoModal" ] := hbCte_PegaDadosXML("versaoModal", cModal )

// Municipio de descarga
   cMunDescarga := hbCte_PegaDadosXML("infMunDescarga", ::cXML )
   ::aMunDescarga := hash()
   ::aMunDescarga[ "cMunDescarga" ] := hbCte_PegaDadosXML("cMunDescarga", cMunDescarga )
   ::aMunDescarga[ "xMunDescarga" ] := hbCte_PegaDadosXML("xMunDescarga", cMunDescarga )


// cte

	::ainfCTe:={}
	nInicio:=0
   cinfCTe := hbCte_PegaDadosXML("infCTe", ::cXML )

	Do While .T.

	   cchCT := hbCte_PegaDadosXML( "chCT", cinfCTe , , @nInicio )

		If cchCT = Nil
			Exit
		Endif

		Aadd(	::ainfCTe, hbCte_PegaDadosXML("chCT", cchCT ) )

	Enddo

// nota fiscais

	::ainfNF:={}
	nInicio:=0

   cinfNF := hbCte_PegaDadosXML("infNF", ::cXML )

	Do While .T.

	   cNF := hbCte_PegaDadosXML( "infNF", cinfNF , , @nInicio )

		If cNF = Nil
			Exit
		Endif

		Aadd(	::ainfNF,{ hbCte_PegaDadosXML("CNPJ", cNF ) , +;
							  hbCte_PegaDadosXML("UF", cNF ) , +;
							  hbCte_PegaDadosXML("nNF", cNF ) , +;
							  hbCte_PegaDadosXML("serie", cNF ) , +;
							  hbCte_PegaDadosXML("dEmi", cNF ) , +;
						     hbCte_PegaDadosXML("vNF", cNF ) , +;
							  hbCte_PegaDadosXML("PIN", cNF ) } )
	Enddo

// NFe's

	::ainfNFe:={}
	nInicio:=0

  	cinfNFe := hbCte_PegaDadosXML( "infNFe" , ::cXML ) // versao 2.0

	Do While .T.

   	cchNFe := hbCte_PegaDadosXML("chNFe", cinfNFe , , @nInicio )

		If cchNFe = Nil
			Exit
		Endif

		Aadd( ::ainfNFe , hbCte_PegaDadosXML("chNFe", cchNFe ) )

	Enddo

// totais

   cTot := hbCte_PegaDadosXML("tot", ::cXML )
   ::aTot := hash()
   ::aTot[ "qCTe" ] := hbCte_PegaDadosXML("qCTe", cTot )
   ::aTot[ "qCT" ] := hbCte_PegaDadosXML("qCT", cTot )
   ::aTot[ "qNFe" ] := hbCte_PegaDadosXML("qNFe", cTot )
   ::aTot[ "qNF" ] := hbCte_PegaDadosXML("qNF", cTot )
   ::aTot[ "vCarga" ] := hbCte_PegaDadosXML("vCarga", cTot )
   ::aTot[ "cUnid" ] := hbCte_PegaDadosXML("cUnid", cTot )
   ::aTot[ "qCarga" ] := hbCte_PegaDadosXML("qCarga", cTot )


// Numero do Lacre

   ::cLacre := hbCte_PegaDadosXML("nLacre", ::cXML )

// informacao complementar

   ::cInfCpl := hbCte_PegaDadosXML("infCpl", ::cXML )

// RNTRC do Emitente e CIOT

   cRodo := hbCte_PegaDadosXML("rodo", ::cXML )
   ::cRntrcEmit := hbCte_PegaDadosXML("RNTRC", cRodo )
   ::cCiot  := hbCte_PegaDadosXML("CIOT", cRodo )

// veiculo tracao

  	cVeiculo := hbCte_PegaDadosXML("veicTracao", ::cXml )

   ::aVeiculo := hash()
	::aVeiculo[ "placa" ] := hbCte_PegaDadosXML("placa", cVeiculo )
   ::aVeiculo[ "tara" ] := hbCte_PegaDadosXML("tara", cVeiculo )

// RNTRC do proprietario
   cProp := hbCte_PegaDadosXML("prop", ::cXml )

   ::aProp := hash()
	::aProp[ "RNTRC" ] := hbCte_PegaDadosXML("RNTRC", cProp ) // NFE 2.0

// condutor

  	cCondutor := hbCte_PegaDadosXML("condutor", ::cXml )

   ::aCondutor := hash()
	::aCondutor[ "xNome" ] := hbCte_PegaDadosXML("xNome", cCondutor )
   ::aCondutor[ "CPF" ] := hbCte_PegaDadosXML("CPF", cCondutor )

// reboque

  	cReboque := hbCte_PegaDadosXML("veicReboque", ::cXml )

   ::aReboque := hash()
	::aReboque[ "placa" ] := hbCte_PegaDadosXML("placa", cReboque )
   ::aReboque[ "tara" ] := hbCte_PegaDadosXML("tara", cReboque )
   ::aReboque[ "capKG" ] := hbCte_PegaDadosXML("capKG", cReboque )
   ::aReboque[ "RNTRC" ] := hbCte_PegaDadosXML("RNTRC", cReboque )

// vale pegadio

  	cValePed := hbCte_PegaDadosXML("valePed", ::cXml )

   ::aValePed := hash()
	::aValePed[ "CNPJForn" ] := hbCte_PegaDadosXML("CNPJForn", cValePed )
   ::aValePed[ "CNPJPg" ] := hbCte_PegaDadosXML("CNPJPg", cValePed )
   ::aValePed[ "nCompra" ] := hbCte_PegaDadosXML("nCompra", cValePed )

// protocolo

   cProtocolo := hbCte_PegaDadosXML("infProt", ::cXML )

   ::aProtocolo := hash()
   ::aProtocolo[ "nProt" ] := hbCte_PegaDadosXML("nProt", cProtocolo ) // NFE 2.0
   ::aProtocolo[ "dhRecbto" ] := hbCte_PegaDadosXML("dhRecbto", cProtocolo ) // NFE 2.0

RETURN(.T.)

METHOD geraPDF() CLASS hbMDFeDaMdfe
   LOCAL nItem, nIdes, nItensNF, nItens1Folha
	LOCAL nVias:=0

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

	For nVias = 1 TO ::nCopias

	   ::nFolha := 1

		::novaPagina()

   	::cabecalho()

	Next

   ::cFile := ::PastaPdf+::cChave+".pdf"

   HPDF_SaveToFile( ::oPdf, ::cFile )
   HPDF_Free( ::oPdf )

RETURN(.T.)

METHOD novaPagina() CLASS hbMDFeDaMdfe
LOCAL nRadiano, nAltura, nLargura, nAngulo

   ::oPdfPage := HPDF_AddPage( ::oPdf )

   HPDF_Page_SetSize( ::oPdfPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT )

   nAltura := HPDF_Page_GetHeight( ::oPdfPage )
   nLargura := HPDF_Page_GetWidth( ::oPdfPage )

// ::nLinhaPdf := nAltura - 3     && Margem Superior
   ::nLinhaPdf := nAltura - 20    && Margem Superior
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

RETURN Nil

METHOD cabecalho() CLASS hbMDFeDaMdfe
LOCAL oImage, hZebra
LOCAL aModal:={'Rodoviário','Aéreo','Aquaviário','Ferroviário','Dutoviário'}
LOCAL aTipoCte:={'Normal','Compl.Val','Anul.Val.','Substituto'}
LOCAL aTipoServ:={'Normal','Subcontratação','Redespacho','Redesp. Int.'}
LOCAL aTomador:={'Remetente','Expedidor','Recebedor','Destinatário'}
LOCAL aPagto:={'Pago','A pagar','Outros'}
LOCAL aUnid:={'M3','KG','TON','UN','LI','MMBTU'}
LOCAL aResp:={'Remetente','Expedidor','Recebedor','Destinatário','Emitente do CT-e','Tomador de Serviço'}
LOCAL aTipoCar:={'não aplicável','Aberta','Fechada/Baú','Granelera','Porta Container','Sider'}
LOCAL aRazao:={}
LOCAL cOutros:=''
LOCAL cEntrega:=''
LOCAL aObserv:={}
LOCAL cMensa:=''
LOCAL nLinha:=0
LOCAL nBase:=''
LOCAL nAliq:=''
LOCAL nValor:=''
LOCAL nReduc:=''
LOCAL nST:=''
LOCAL DASH_MODE3 := {8, 7, 2, 7}

// box do logotipo e dados do emitente

hbCte_Box_Hpdf( ::oPdfPage,  020 , ::nLinhaPdf-150 , 555 , 150 , ::nLarguraBox )
oImage:= HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
HPDF_Page_DrawImage( ::oPdfPage, oImage, 025 , ::nLinhaPdf - (142+1), 200, 132)
hbCte_Texto_Hpdf( ::oPdfPage,240, ::nLinhaPdf-018, 560, Nil, ::aEmit[ "xNome" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 16 )
hbCte_Texto_Hpdf( ::oPdfPage,240, ::nLinhaPdf-060, 560, Nil, 'CNPJ: '+TRANSF( ::aEmit[ "CNPJ" ] , "@R 99.999.999/9999-99")+'       Inscrição Estadual: '+ConfIE(::aEmit[ "UF" ],Alltrim(::aEmit[ "IE" ]),,.F.) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10)
hbCte_Texto_Hpdf( ::oPdfPage,240, ::nLinhaPdf-072, 560, Nil, 'Logradouro: '+::aEmit[ "xLgr" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10)
hbCte_Texto_Hpdf( ::oPdfPage,240, ::nLinhaPdf-084, 560, Nil, "No.: "+Iif(::aEmit[ "nro" ]  != Nil,::aEmit[ "nro" ],'')+Iif(::aEmit[ "xCpl" ] != Nil," - Complemento: "+::aEmit[ "xCpl" ],''), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10)
hbCte_Texto_Hpdf( ::oPdfPage,240, ::nLinhaPdf-096, 560, Nil, 'Bairro: '+::aEmit[ "xBairro" ]+" - CEP: "+TRANSF( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10)
hbCte_Texto_Hpdf( ::oPdfPage,240, ::nLinhaPdf-108, 560, Nil, 'Município: '+::aEmit[ "xMun" ]+" - Estado: "+::aEmit[ "UF" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10)
If ::aEmit[ "fone" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage,240, ::nLinhaPdf-120, 560, Nil, 'Fone/Fax:('+Subs(::aEmit[ "fone" ],1,2)+')'+Subs(::aEmit[ "fone" ],3,4)+'-'+Subs(::aEmit[ "fone" ],7,4) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10)
Endif

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
If ::aProtocolo[ "nProt" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-326 , 575, Nil, ::aProtocolo[ "nProt" ]+' - '+SUBS(::aProtocolo[ "dhRecbto" ],9,2)+"/"+SUBS(::aProtocolo[ "dhRecbto" ],6,2)+"/"+SUBS(::aProtocolo[ "dhRecbto" ],1,4)+' '+SUBS(::aProtocolo[ "dhRecbto" ],12) , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalhoBold, 12)
Else
	hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-326 , 575, Nil, 'MDFe sem Autorização de Uso da SEFAZ' , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalhoBold, 12)
Endif

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
If !Empty(::aProp[ "RNTRC" ])
	hbCte_Texto_Hpdf( ::oPdfPage, 115 , ::nLinhaPdf-475 , 240, Nil, ::aProp[ "RNTRC" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
Else
	hbCte_Texto_Hpdf( ::oPdfPage, 115 , ::nLinhaPdf-475 , 240, Nil, ::cRntrcEmit , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
Endif
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
If Valtype(::aValePed[ "CNPJPg" ])!= 'U'
	hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-580 , 095, Nil, TRANSF(::aValePed[ "CNPJPg" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 08 )
Endif
If Valtype(::aValePed[ "CNPJForn" ])!= 'U'
	hbCte_Texto_Hpdf( ::oPdfPage, 100 , ::nLinhaPdf-580 , 170, Nil, TRANSF(::aValePed[ "CNPJForn" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 08 )
Endif
If Valtype(::aValePed[ "nCompra" ])!= 'U'
	hbCte_Texto_Hpdf( ::oPdfPage, 175 , ::nLinhaPdf-580 , 240, Nil, ::aValePed[ "nCompra" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 08 )
Endif
hbCte_Box_Hpdf( ::oPdfPage, 020 , ::nLinhaPdf-775 , 555 , 150 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-625 , 210, Nil, "Observações" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 12 )
hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-640 , 560, Nil, ::cInfCpl , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
If !Empty(::cLacre)
	hbCte_Texto_Hpdf( ::oPdfPage, 025 , ::nLinhaPdf-655 , 560, Nil, 'No. do Lacre: '+::cLacre , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
Endif

// Data e Desenvolvedor da Impressao
hbCte_Texto_Hpdf( ::oPdfPage, 025, ::nLinhaPdf-800 , 300, Nil , "DATA DA IMPRESSÃO: "+DTOC(DATE()) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
hbCte_Texto_Hpdf( ::oPdfPage, 400, ::nLinhaPdf-800 , 560, Nil , "VesSystem" , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalhoBold, 6 )

RETURN Nil

Function hbCte_PegaDadosXML(cElemento, cStringXML, cElemento2 , nInicio )
   Local InicioDoDado,FinalDoDado,nPosIni,nPosFim
	Local cRet := nil

	If cStringXML = Nil
      Return cRet
   Endif

   If nInicio = Nil
		nInicio := 0
	Endif
/*
	If cElemento = "Comp"
	   exibir(nInicio)
	   exibirmysql(cStringXML)
	Endif
*/
   If nInicio > 0
		cStringXML:=Subs(cStringXML,nInicio+1)
/*
		If cElemento = "Comp"
			Exibir(cStringXML)
		Endif
*/
	Endif

	InicioDoDado := Iif(cElemento2==Nil,"<"+cElemento+">" , "<"+cElemento )
   FinalDoDado  := Iif(cElemento2==Nil,"</"+cElemento+">",'</'+cElemento2+'>')

	If nInicio > 0
	   nPosIni      := 1
	Else
	   nPosIni      := At(InicioDoDado,cStringXML)
   Endif

	If nPosIni = 0
		InicioDoDado := "<"+cElemento
	   nPosIni      := At(InicioDoDado,cStringXML)
   Endif

	nPosFim      := At(FinalDoDado,cStringXML,nPosIni)

   If nPosIni==0 .or. nPosFim==0
      Return cRet
   Endif
/*
	If cElemento = "Comp"
		exibir(str(nPosIni)+' - '+str(nPosFim))
 	Endif
*/

	cRet := Substr(cStringXML,nPosIni+Len(IniciodoDado),nPosFim-nPosIni-Len(FinalDoDado)+1)
/*
	If cElemento = "Comp"
		exibir(cRet)
	Endif
*/
	nInicio+=nPosFim+Len(FinalDoDado)-1

Return( cRet )

FUNCTION hbCte_Texto_Hpdf( oPdfPage2, x1, y1, x2, y2, cText, align, desconhecido, oFontePDF, nTamFonte, nAngulo)
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

RETURN Nil

FUNCTION hbCte_Box_Hpdf( oPdfPage2, x1, y1, x2, y2, nPen)
   HPDF_Page_SetLineWidth( oPdfPage2, nPen )
   HPDF_Page_Rectangle( oPdfPage2, x1, y1, x2, y2 )
   HPDF_Page_Stroke( oPdfPage2 )
RETURN Nil

FUNCTION hbCte_Line_Hpdf( oPdfPage2, x1, y1, x2, y2, nPen, FLAG)
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
RETURN Nil

#ifndef __XHARBOUR__
FUNCTION hbCte_Zebra_Draw_Hpdf( hZebra, page, ... )

   IF hb_zebra_GetError( hZebra ) != 0
      RETURN HB_ZEBRA_ERROR_INVALIDZEBRA
   ENDIF

   hb_zebra_draw( hZebra, {| x, y, w, h | HPDF_Page_Rectangle( page, x, y, w, h ) }, ... )

   HPDF_Page_Fill( page )

   RETURN 0
#endif

****************************************
function Cte_CodificaCode128c(pcCodigoBarra)
****************************************

&&  Parameters de entrada : O codigo de barras no formato Code128C "somente numeros" campo tipo caracter
&&  Retorno               : Retorna o código convertido e com o caracter de START e STOP mais o checksum
&&                        : para impressão do código de barras utilizando a fonte Code128bWin, é necessário
&&                        : para utilizar essa fonte os arquivos Code128bWin.ttf, Code128bWin.afm e Code128bWin.pfb
&& Autor                  : Anderson Camilo
&& Data                   : 19/03/2012

local  nI :=0, checksum :=0, nValorCar :=0, cCode128 := '', cCodigoBarra :=''

cCodigoBarra = pcCodigoBarra
if len(cCodigoBarra) > 0    && Verifica se os caracteres são válidos (somente números)
   if int(len(cCodigoBarra) / 2) = len(cCodigoBarra) / 2    && Tem ser par o tamanho do código de barras
      for nI = 1 to len(cCodigoBarra)
          if (Asc( substr ( cCodigoBarra, nI, 1) ) < 48 .or. Asc( substr ( cCodigoBarra, nI, 1) ) > 57)
             nI = 0
	         exit
          endif
      next nI
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
       next nI
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

return cCode128

