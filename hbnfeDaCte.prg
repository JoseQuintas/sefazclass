/*
HBNFEDACTE - DOCUMENTO AUXILIAR DO CTE
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

CLASS hbCteDacte
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
   DATA cXML
   DATA cChave
   DATA aIde
   DATA aCompl
   DATA aObsCont
   DATA aEmit
   DATA aRem
   DATA ainfNF
   DATA ainfNFe
   DATA ainfOutros
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
	DATA vTotTrib
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
   DATA aInfCanc //

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

METHOD execute() CLASS hbCteDacte

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
   ::cChave := SUBS( ::cXML, AT('Id=',::cXML)+3+4,44)

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

METHOD buscaDadosXML() CLASS hbCteDacte
LOCAL cIde, cCompl , cEmit, cRem , cinfNF , cinfNFe , cinfOutros , cDest , cLocEnt , cPrest , cComp
LOCAL cIcms00 , cIcms20 , cIcms45 , cIcms60 , cIcms90 , cIcmsUF , cIcmsSN
LOCAL cinfCTeNorm , cInfCarga , cSeg , cRodo , cVeiculo , cProtCTe , cProtocolo , cExped
LOCAL cReceb , cInfQ , cValePed , cMoto , cProp , cObsCont
LOCAL nInicio:=0

   oFuncoes := hbNFeFuncoes()

// Identifacao

   cIde := hbCte_PegaDadosXML("ide", ::cXML )
   ::aIde := hash()
   ::aIde[ "cUF" ] := hbCte_PegaDadosXML("cUF", cIde )
   ::aIde[ "cCT" ] := hbCte_PegaDadosXML("cCT", cIde )
   ::aIde[ "CFOP" ] := hbCte_PegaDadosXML("CFOP", cIde )
   ::aIde[ "natOp" ] := hbCte_PegaDadosXML("natOp", cIde )
   ::aIde[ "forPag" ] := hbCte_PegaDadosXML("forPag", cIde )
   ::aIde[ "mod" ] := hbCte_PegaDadosXML("mod", cIde )
   ::aIde[ "serie" ] := hbCte_PegaDadosXML("serie", cIde )
   ::aIde[ "nCT" ] := hbCte_PegaDadosXML("nCT", cIde )
   ::aIde[ "dhEmi" ] := hbCte_PegaDadosXML("dhEmi", cIde )
   ::aIde[ "tpImp" ] := hbCte_PegaDadosXML("tpImp", cIde )
   ::aIde[ "tpEmis" ] := hbCte_PegaDadosXML("tpEmis", cIde )
   ::aIde[ "cDV" ] := hbCte_PegaDadosXML("cDV", cIde )
   ::aIde[ "tpAmb" ] := hbCte_PegaDadosXML("tpAmb", cIde )  // 1 - retrato 2-paisagem
   ::aIde[ "tpCTe" ] := hbCte_PegaDadosXML("tpCTe", cIde )
   ::aIde[ "procEmi" ] := hbCte_PegaDadosXML("procEmi", cIde )
   ::aIde[ "verProc" ] := hbCte_PegaDadosXML("verProc", cIde )  // 1- producao 2-homologacao
   ::aIde[ "cMunEnv" ] := hbCte_PegaDadosXML("cMunEnv", cIde ) // finalidade 1-normal/2-complementar 3- de ajuste
   ::aIde[ "xMunEnv" ] := hbCte_PegaDadosXML("xMunEnv", cIde ) //0 - emissão de NF-e com aplicativo do contribuinte 1 - emissão de NF-e avulsa pelo Fisco 2 - emissão de NF-e avulsa pelo contribuinte com seu certificado digital, através do site do Fisco 3- emissão NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.
   ::aIde[ "UFEnv" ] := hbCte_PegaDadosXML("UFEnv", cIde ) // versao sistema
   ::aIde[ "modal" ] := hbCte_PegaDadosXML("modal", cIde ) // versao sistema
   ::aIde[ "tpServ" ] := hbCte_PegaDadosXML("tpServ", cIde ) // versao sistema
   ::aIde[ "cMunIni" ] := hbCte_PegaDadosXML("cMunIni", cIde ) // versao sistema
   ::aIde[ "xMunIni" ] := hbCte_PegaDadosXML("xMunIni", cIde ) // versao sistema
   ::aIde[ "UFIni" ] := hbCte_PegaDadosXML("UFIni", cIde ) // versao sistema
   ::aIde[ "cMunFim" ] := hbCte_PegaDadosXML("cMunFim", cIde ) // versao sistema
   ::aIde[ "xMunFim" ] := hbCte_PegaDadosXML("xMunFim", cIde ) // versao sistema
   ::aIde[ "UFFim" ] := hbCte_PegaDadosXML("UFFim", cIde ) // versao sistema
   ::aIde[ "retira" ] := hbCte_PegaDadosXML("retira", cIde ) // versao sistema
   ::aIde[ "xDetRetira" ] := hbCte_PegaDadosXML("xDetRetira", cIde ) // versao sistema

   cIde := hbCte_PegaDadosXML("toma03", cIde )
   ::aIde[ "toma" ] := hbCte_PegaDadosXML("toma", cIde ) // versao sistema

   cCompl := hbCte_PegaDadosXML("compl", ::cXML )
   ::aCompl := hash()
   ::aCompl[ "xObs" ] := hbCte_PegaDadosXML("xObs", cCompl )

   cObsCont := hbCte_PegaDadosXML("XObsCont xCampo", ::cXML )
   ::aObsCont := hash()
//   ::aObsCont[ "xCampo" ] := hbCte_PegaDadosXML("xCampo", cObsCont )
   ::aObsCont[ "xTexto" ] := hbCte_PegaDadosXML("xTexto", cCompl )

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
   TRY
      ::cTelefoneEmitente := TRANSF(::oFuncoes:eliminaString(ALLTRIM(hbCte_PegaDadosXML("fone", cEmit )),"()- ,.+"),"@R (99) 9999-9999")
   CATCH
      ::cTelefoneEmitente := ""
   END

//   ::cSiteEmitente := ::ohbNFe:cSiteEmitente
//   ::cEmailEmitente := ::ohbNFe:cEmailEmitente

// Remetente

   cRem := hbCte_PegaDadosXML("rem", ::cXML )
   ::aRem := hash()
   ::aRem[ "CNPJ" ] := hbCte_PegaDadosXML("CNPJ", cRem )
   ::aRem[ "CPF" ] := hbCte_PegaDadosXML("CPF", cRem )
   ::aRem[ "IE" ] := hbCte_PegaDadosXML("IE", cRem ) // avulso pelo fisco
   ::aRem[ "xNome" ] := oFuncoes:parseDecode( hbCte_PegaDadosXML("xNome", cRem ) )
   ::aRem[ "xFant" ] := hbCte_PegaDadosXML("xFant", cRem )
   ::aRem[ "fone" ] := hbCte_PegaDadosXML("fone", cRem )

//   cRem := hbCte_PegaDadosXML("enderReme", cRem )

   ::aRem[ "xLgr" ] := hbCte_PegaDadosXML("xLgr", cRem )
   ::aRem[ "nro" ] := hbCte_PegaDadosXML("nro", cRem )
   ::aRem[ "xCpl" ] := hbCte_PegaDadosXML("xCpl", cRem )
   ::aRem[ "xBairro" ] := hbCte_PegaDadosXML("xBairro", cRem )
   ::aRem[ "cMun" ] := hbCte_PegaDadosXML("cMun", cRem )
   ::aRem[ "xMun" ] := hbCte_PegaDadosXML("xMun", cRem )
   ::aRem[ "CEP" ] := hbCte_PegaDadosXML("CEP", cRem )
   ::aRem[ "UF" ] := hbCte_PegaDadosXML("UF", cRem )
   ::aRem[ "cPais" ] := hbCte_PegaDadosXML("cPais", cRem )
   ::aRem[ "xPais" ] := hbCte_PegaDadosXML("xPais", cRem ) // NFE 2.0

//   cRem := hbCte_PegaDadosXML("rem", ::cXML ) versao 1.04
   cRem := hbCte_PegaDadosXML("infDoc", ::cXML ) // versao 2.0

// nota fiscais

	::ainfNF:={}
	nInicio:=0

	Do While .T.

	   cinfNF := hbCte_PegaDadosXML( "infNF", cRem , , @nInicio )

		If cinfNF = Nil
			Exit
		Endif
		Aadd(	::ainfNF,{ hbCte_PegaDadosXML("nRoma", cinfNF ) , +;
							  hbCte_PegaDadosXML("nPed", cinfNF ) , +;
							  hbCte_PegaDadosXML("mod", cinfNF ) , +;
							  hbCte_PegaDadosXML("serie", cinfNF ) , +;
						     hbCte_PegaDadosXML("nDoc", cinfNF ) , +;
							  hbCte_PegaDadosXML("dEmi", cinfNF ) , +;
						     hbCte_PegaDadosXML("vBC", cinfNF ) , +;
							  hbCte_PegaDadosXML("vICMS", cinfNF ) , +;
							  hbCte_PegaDadosXML("vBCST", cinfNF ) , +;
							  hbCte_PegaDadosXML("vST", cinfNF ) , +;
							  hbCte_PegaDadosXML("vProd", cinfNF ) , +;
							  hbCte_PegaDadosXML("vNF", cinfNF ) , +;
							  hbCte_PegaDadosXML("nCFOP", cinfNF ) , +;
							  hbCte_PegaDadosXML("nPeso", cinfNF ) , +;
							  hbCte_PegaDadosXML("PIN", cinfNF ) } )
	Enddo

// NFe's

	::ainfNFe:={}
	nInicio:=0
//  	cRem := hbCte_PegaDadosXML("rem", ::cXML ) versao 1.04
  	cRem := hbCte_PegaDadosXML("infDoc", ::cXML ) // versao 2.0

	Do While .T.

   	cinfNFe := hbCte_PegaDadosXML("infNFe", cRem , , @nInicio )

		If cinfNFe = Nil
			Exit
		Endif

		Aadd( ::ainfNFe , { hbCte_PegaDadosXML("chave", cinfNFe ) , +;
								  hbCte_PegaDadosXML("PIN", cinfNFe ) } )

	Enddo

// Outros Documentos

	::ainfOutros:={}
	nInicio:=0
//  	cRem := hbCte_PegaDadosXML("rem", ::cXML ) versao 1.04
  	cRem := hbCte_PegaDadosXML("infDoc", ::cXML ) // versao 2.0
	Do While .T.

   	cinfOutros := hbCte_PegaDadosXML("infOutros", cRem , , @nInicio )

		If cinfOutros = Nil
			Exit
		Endif

		Aadd( ::ainfOutros , { hbCte_PegaDadosXML("tpDoc", cinfOutros ) , +;
									  hbCte_PegaDadosXML("descOutros", cinfOutros ) , +;
									  hbCte_PegaDadosXML("nDoc", cinfOutros ) , +;
									  hbCte_PegaDadosXML("dEmi", cinfOutros ) , +;
									  hbCte_PegaDadosXML("vDocFisc", cinfOutros ) } )

	Enddo

// destinatario

   cDest := hbCte_PegaDadosXML("dest", ::cXML )
   ::aDest := hash()
   ::aDest[ "CNPJ" ] := hbCte_PegaDadosXML("CNPJ", cDest )
   ::aDest[ "CPF" ] := hbCte_PegaDadosXML("CPF", cDest )
   ::aDest[ "IE" ] := hbCte_PegaDadosXML("IE", cDest )
   ::aDest[ "xNome" ] := oFuncoes:parseDecode( hbCte_PegaDadosXML("xNome", cDest ) )
   ::aDest[ "fone" ] := oFuncoes:parseDecode( hbCte_PegaDadosXML("fone", cDest ) )
   ::aDest[ "ISUF" ] := oFuncoes:parseDecode( hbCte_PegaDadosXML("ISUF", cDest ) )
   ::aDest[ "email" ] := oFuncoes:parseDecode( hbCte_PegaDadosXML("email", cDest ) )

   cDest := hbCte_PegaDadosXML("enderDest", cDest )
   ::aDest[ "xLgr" ]    := hbCte_PegaDadosXML("xLgr", cDest )
   ::aDest[ "nro" ]     := hbCte_PegaDadosXML("nro", cDest )
   ::aDest[ "xCpl" ]    := hbCte_PegaDadosXML("xCpl", cDest )
   ::aDest[ "xBairro" ] := hbCte_PegaDadosXML("xBairro", cDest )
   ::aDest[ "cMun" ]    := hbCte_PegaDadosXML("cMun", cDest )
   ::aDest[ "xMun" ]    := hbCte_PegaDadosXML("xMun", cDest )
   ::aDest[ "UF" ]      := hbCte_PegaDadosXML("UF", cDest )
   ::aDest[ "CEP" ]     := hbCte_PegaDadosXML("CEP", cDest )
   ::aDest[ "cPais" ]   := hbCte_PegaDadosXML("cPais", cDest )
   ::aDest[ "xPais" ]   := hbCte_PegaDadosXML("xPais", cDest )

// local de entrega

   clocEnt := hbCte_PegaDadosXML("locEnt", cDest )
   ::alocEnt := hash()

   ::alocEnt[ "CNPJ" ]    := hbCte_PegaDadosXML("CNPJ", clocEnt )
   ::alocEnt[ "CPF" ]     := hbCte_PegaDadosXML("CPF", clocEnt )
   ::alocEnt[ "xNome" ]   := hbCte_PegaDadosXML("xNome", clocEnt )
   ::alocEnt[ "xLgr" ]    := hbCte_PegaDadosXML("xLgr", clocEnt )
   ::alocEnt[ "nro"]    := hbCte_PegaDadosXML("nro", clocEnt )
   ::alocEnt[ "xCpl" ]    := hbCte_PegaDadosXML("xCpl", clocEnt )
   ::alocEnt[ "xBairro" ] := hbCte_PegaDadosXML("xBairro", clocEnt )
   ::alocEnt[ "xMun" ]    := hbCte_PegaDadosXML("xMun", clocEnt )
   ::alocEnt[ "UF" ]      := hbCte_PegaDadosXML("UF", clocEnt )

// Expedidor

   cExped := hbCte_PegaDadosXML("exped", ::cXML )

   ::aExped := hash()
   ::aExped[ "CNPJ" ] := hbCte_PegaDadosXML("CNPJ", cExped )
   ::aExped[ "CPF" ] := hbCte_PegaDadosXML("CPF", cExped )
   ::aExped[ "IE" ] := hbCte_PegaDadosXML("IE", cExped )
   ::aExped[ "xNome" ] := oFuncoes:parseDecode( hbCte_PegaDadosXML("xNome", cExped ) )
   ::aExped[ "fone" ] := oFuncoes:parseDecode( hbCte_PegaDadosXML("fone", cExped ) )
   ::aExped[ "email" ] := oFuncoes:parseDecode( hbCte_PegaDadosXML("email", cExped ) )

   cExped := hbCte_PegaDadosXML("enderExped", cExped )
   ::aExped[ "xLgr" ] := hbCte_PegaDadosXML("xLgr", cExped )
   ::aExped[ "nro" ] := hbCte_PegaDadosXML("nro", cExped )
   ::aExped[ "xCpl" ] := hbCte_PegaDadosXML("xCpl", cExped )
   ::aExped[ "xBairro" ] := hbCte_PegaDadosXML("xBairro", cExped )
   ::aExped[ "cMun" ] := hbCte_PegaDadosXML("cMun", cExped )
   ::aExped[ "xMun" ] := hbCte_PegaDadosXML("xMun", cExped )
   ::aExped[ "UF" ] := hbCte_PegaDadosXML("UF", cExped )
   ::aExped[ "CEP" ] := hbCte_PegaDadosXML("CEP", cExped )
   ::aExped[ "cPais" ] := hbCte_PegaDadosXML("cPais", cExped )
   ::aExped[ "xPais" ] := hbCte_PegaDadosXML("xPais", cExped )

// Recebedor

   cReceb := hbCte_PegaDadosXML("receb", ::cXML )
   ::aReceb := hash()
   ::aReceb[ "CNPJ" ] := hbCte_PegaDadosXML("CNPJ", cReceb )
   ::aReceb[ "CPF" ] := hbCte_PegaDadosXML("CPF", cReceb )
   ::aReceb[ "IE" ] := hbCte_PegaDadosXML("IE", cReceb )
   ::aReceb[ "xNome" ] := oFuncoes:parseDecode( hbCte_PegaDadosXML("xNome", cReceb ) )
   ::aReceb[ "fone" ] := oFuncoes:parseDecode( hbCte_PegaDadosXML("fone", cReceb ) )
   ::aReceb[ "email" ] := oFuncoes:parseDecode( hbCte_PegaDadosXML("email", cReceb ) )

   cReceb := hbCte_PegaDadosXML("enderReceb", cReceb )
   ::aReceb[ "xLgr" ] := hbCte_PegaDadosXML("xLgr", cReceb )
   ::aReceb[ "nro" ] := hbCte_PegaDadosXML("nro", cReceb )
   ::aReceb[ "xCpl" ] := hbCte_PegaDadosXML("xCpl", cReceb )
   ::aReceb[ "xBairro" ] := hbCte_PegaDadosXML("xBairro", cReceb )
   ::aReceb[ "cMun" ] := hbCte_PegaDadosXML("cMun", cReceb )
   ::aReceb[ "xMun" ] := hbCte_PegaDadosXML("xMun", cReceb )
   ::aReceb[ "UF" ] := hbCte_PegaDadosXML("UF", cReceb )
   ::aReceb[ "CEP" ] := hbCte_PegaDadosXML("CEP", cReceb )
   ::aReceb[ "cPais" ] := hbCte_PegaDadosXML("cPais", cReceb )
   ::aReceb[ "xPais" ] := hbCte_PegaDadosXML("xPais", cReceb )

// Valor da Prestacao

   cPrest := hbCte_PegaDadosXML("vPrest", ::cXML )
   ::aPrest := hash()
   ::aPrest[ "vTPrest" ] := hbCte_PegaDadosXML("vTPrest", cPrest )
   ::aPrest[ "vRec" ] := hbCte_PegaDadosXML("vRec", cPrest )

	::aComp:={}
	nInicio:=0
  	cPrest := hbCte_PegaDadosXML("vPrest", ::cXML )

	Do While .T.

   	cComp := hbCte_PegaDadosXML("Comp", cPrest , , @nInicio )

		If cComp = Nil
			Exit
		Endif

		Aadd( ::aComp , { hbCte_PegaDadosXML("xNome", cComp ) , +;
	                     hbCte_PegaDadosXML("vComp", cComp ) } )
	Enddo

// Imposto

   cImp := hbCte_PegaDadosXML("imp", ::cXML )

   cIcms00 := hbCte_PegaDadosXML("ICMS00", cImp )
   ::aIcms00 := hash()

   ::aIcms00[ "CST" ] := hbCte_PegaDadosXML("CST", cIcms00 ) // NFE 2.0
   ::aIcms00[ "vBC" ] := hbCte_PegaDadosXML("vBC", cIcms00 ) // NFE 2.0
   ::aIcms00[ "pICMS" ] := hbCte_PegaDadosXML("pICMS", cIcms00 )
   ::aIcms00[ "vICMS" ] := hbCte_PegaDadosXML("vICMS", cIcms00 )

   cIcms20 := hbCte_PegaDadosXML("ICMS20", cImp )
   ::aIcms20 := hash()

   ::aIcms20[ "CST" ] := hbCte_PegaDadosXML("CST", cIcms20 ) // NFE 2.0
   ::aIcms20[ "vBC" ] := hbCte_PegaDadosXML("vBC", cIcms20 ) // NFE 2.0
   ::aIcms20[ "pRedBC" ] := hbCte_PegaDadosXML("pRedBC", cIcms20 ) // NFE 2.0
   ::aIcms20[ "pICMS" ] := hbCte_PegaDadosXML("pICMS", cIcms20 )
   ::aIcms20[ "vICMS" ] := hbCte_PegaDadosXML("vICMS", cIcms20 )

   cIcms45 := hbCte_PegaDadosXML("ICMS45", cImp )
   ::aIcms45 := hash()

   ::aIcms45[ "CST" ] := hbCte_PegaDadosXML("CST", cIcms45 ) // NFE 2.0

   cIcms60 := hbCte_PegaDadosXML("ICMS60", cImp )
   ::aIcms60 := hash()

   ::aIcms60[ "CST" ] := hbCte_PegaDadosXML("CST", cIcms60 ) // NFE 2.0
   ::aIcms60[ "vBCSTRet" ] := hbCte_PegaDadosXML("vBCSTRet", cIcms60 ) // NFE 2.0
   ::aIcms60[ "vICMSSTRet" ] := hbCte_PegaDadosXML("vICMSSTRet", cIcms60 ) // NFE 2.0
   ::aIcms60[ "pICMSSTRet" ] := hbCte_PegaDadosXML("pICMSSTRet", cIcms60 )
   ::aIcms60[ "vCred" ] := hbCte_PegaDadosXML("vCred", cIcms60 )

   cIcms90 := hbCte_PegaDadosXML("ICMS90", cImp )
   ::aIcms90 := hash()

   ::aIcms90[ "CST" ] := hbCte_PegaDadosXML("CST", cIcms90 ) // NFE 2.0
   ::aIcms90[ "pRedBC" ] := hbCte_PegaDadosXML("pRedBC", cIcms90 ) // NFE 2.0
   ::aIcms90[ "vBC" ] := hbCte_PegaDadosXML("vBC", cIcms90 ) // NFE 2.0
   ::aIcms90[ "pICMS" ] := hbCte_PegaDadosXML("pICMS", cIcms90 )
   ::aIcms90[ "vICMS" ] := hbCte_PegaDadosXML("vICMS", cIcms90 )
   ::aIcms90[ "vCred" ] := hbCte_PegaDadosXML("vCred", cIcms90 )

   cIcmsUF := hbCte_PegaDadosXML("ICMSOutraUF", cImp )
   ::aIcmsUF := hash()

   ::aIcmsUF[ "CST" ] := hbCte_PegaDadosXML("CST", cIcmsUF ) // NFE 2.0
   ::aIcmsUF[ "pRedBCOutraUF" ] := hbCte_PegaDadosXML("pRedBCOutraUF", cIcmsUF ) // NFE 2.0
   ::aIcmsUF[ "vBCOutraUF" ] := hbCte_PegaDadosXML("vBCOutraUF", cIcmsUF ) // NFE 2.0
   ::aIcmsUF[ "pICMSOutraUF" ] := hbCte_PegaDadosXML("pICMSOutraUF", cIcmsUF )
   ::aIcmsUF[ "vICMSOutraUF" ] := hbCte_PegaDadosXML("vICMSOutraUF", cIcmsUF )

   cIcmsSN := hbCte_PegaDadosXML("ICMSSN", cImp )
   ::aIcmsSN := hash()

   ::aIcmsSN[ "indSN" ] := hbCte_PegaDadosXML("indSN", cIcmsSN ) // NFE 2.0

	::vTotTrib := '0'
	::vTotTrib := hbCte_PegaDadosXML("vTotTrib", ::cXML )

   ::cAdFisco := hbCte_PegaDadosXML("infAdFisco", cImp )

// Informacoes do CTe Normal

   cinfCTeNorm := hbCte_PegaDadosXML("infCTeNorm", ::cXML )

   cinfCarga := hbCte_PegaDadosXML("infCarga", cinfCTeNorm )

   ::aInfCarga := hash()
   ::aInfCarga[ "vCarga" ] := hbCte_PegaDadosXML("vCarga", cInfCarga ) // NFE 2.0
   ::aInfCarga[ "proPred" ] := hbCte_PegaDadosXML("proPred", cInfCarga ) // NFE 2.0
   ::aInfCarga[ "xOutCat" ] := hbCte_PegaDadosXML("xOutCat", cInfCarga )

	::aInfQ:={}
	nInicio:=0
	Do While .T.

   	cInfQ := hbCte_PegaDadosXML("infQ", cInfCarga , , @nInicio )
		If cInfQ = Nil
			Exit
		Endif

		Aadd( ::aInfQ , { hbCte_PegaDadosXML("cUnid", cInfQ ) , +;
	                     hbCte_PegaDadosXML("tpMed", cInfQ ) , +;
	                     hbCte_PegaDadosXML("qCarga", cInfQ ) } )

	Enddo

   cSeg := hbCte_PegaDadosXML("seg", cinfCTeNorm )

   ::aSeg := hash()
   ::aSeg[ "respSeg" ] := hbCte_PegaDadosXML("respSeg", cSeg ) // NFE 2.0
   ::aSeg[ "xSeg" ] := hbCte_PegaDadosXML("xSeg", cSeg ) // NFE 2.0
   ::aSeg[ "nApol" ] := hbCte_PegaDadosXML("nApol", cSeg ) // NFE 2.0
   ::aSeg[ "nAver" ] := hbCte_PegaDadosXML("nAver", cSeg ) // NFE 2.0
   ::aSeg[ "vCarga" ] := hbCte_PegaDadosXML("vCarga", cSeg ) // NFE 2.0

   cRodo := hbCte_PegaDadosXML("rodo", cinfCTeNorm )

   ::aRodo := hash()
   ::aRodo[ "RNTRC" ] := hbCte_PegaDadosXML("RNTRC", cRodo ) // NFE 2.0
   ::aRodo[ "dPrev" ] := hbCte_PegaDadosXML("dPrev", cRodo ) // NFE 2.0
   ::aRodo[ "lota" ] := hbCte_PegaDadosXML("lota", cRodo ) // NFE 2.0
   ::aRodo[ "CIOT" ] := hbCte_PegaDadosXML("CIOT", cRodo ) // NFE 2.0
   ::aRodo[ "nLacre" ] := hbCte_PegaDadosXML("nLacre", cRodo ) // NFE 2.0

   cMoto := hbCte_PegaDadosXML("moto", cinfCTeNorm )
   ::aMoto := hash()
	::aMoto[ "xNome" ] := hbCte_PegaDadosXML("xNome", cMoto ) // NFE 2.0
   ::aMoto[ "CPF" ] := hbCte_PegaDadosXML("CPF", cMoto ) // NFE 2.0

   cValePed := hbCte_PegaDadosXML("valePed", cRodo )
   ::aValePed := hash()
	::aValePed[ "CNPJForn" ] := hbCte_PegaDadosXML("CNPJForn", cValePed ) // NFE 2.0
	::aValePed[ "nCompra" ] := hbCte_PegaDadosXML("nCompra", cValePed ) // NFE 2.0
	::aValePed[ "CNPJPg" ] := hbCte_PegaDadosXML("CNPJPg", cValePed ) // NFE 2.0

   cProp := hbCte_PegaDadosXML("prop", cRodo )
   ::aProp := hash()
	::aProp[ "CPF" ] := hbCte_PegaDadosXML("CPF", cProp ) // NFE 2.0
	::aProp[ "CNPJ" ] := hbCte_PegaDadosXML("CNPJ", cProp ) // NFE 2.0
	::aProp[ "RNTRC" ] := hbCte_PegaDadosXML("RNTRC", cProp ) // NFE 2.0
	::aProp[ "xNome" ] := hbCte_PegaDadosXML("xNome", cProp ) // NFE 2.0
	::aProp[ "IE" ] := hbCte_PegaDadosXML("IE", cProp ) // NFE 2.0
	::aProp[ "UF" ] := hbCte_PegaDadosXML("UF", cProp ) // NFE 2.0
	::aProp[ "tpProp" ] := hbCte_PegaDadosXML("tpProp", cProp ) // NFE 2.0

	::aVeiculo:={}
	nInicio:=0

	Do While .T.

   	cVeiculo := hbCte_PegaDadosXML("veic", cRodo , , @nInicio )

		If cVeiculo = Nil
			Exit
		Endif

		Aadd( ::aVeiculo , { hbCte_PegaDadosXML("cInt", cVeiculo ) , +;
	                     hbCte_PegaDadosXML("RENAVAM", cVeiculo ) , +;
	                     hbCte_PegaDadosXML("placa", cVeiculo ) , +;
	                     hbCte_PegaDadosXML("tara", cVeiculo ) , +;
	                     hbCte_PegaDadosXML("capKG", cVeiculo ) , +;
	                     hbCte_PegaDadosXML("capM3", cVeiculo ) , +;
	                     hbCte_PegaDadosXML("tpProp", cVeiculo ) , +;
	                     hbCte_PegaDadosXML("tpVeic", cVeiculo ) , +;
	                     hbCte_PegaDadosXML("tpRod", cVeiculo ) , +;
	                     hbCte_PegaDadosXML("tpCar", cVeiculo ) , +;
	                     hbCte_PegaDadosXML("UF", cVeiculo ) } )
	Enddo

   cProtocolo := hbCte_PegaDadosXML("infProt", ::cXML )

   ::aProtocolo := hash()
   ::aProtocolo[ "nProt" ] := hbCte_PegaDadosXML("nProt", cProtocolo ) // NFE 2.0
   ::aProtocolo[ "dhRecbto" ] := hbCte_PegaDadosXML("dhRecbto", cProtocolo ) // NFE 2.0

   If ::aIde['toma'] = '0'
      ::aToma:= ::aRem
   ElseIf ::aIde['toma'] = '1'
      ::aToma:= ::aExped
   ElseIf ::aIde['toma'] = '2'
      ::aToma:= ::aReceb
   ElseIf ::aIde['toma'] = '3'
      ::aToma:= ::aDest
	Endif

RETURN(.T.)

METHOD geraPDF() CLASS hbCteDacte
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

METHOD novaPagina() CLASS hbCteDacte
LOCAL nRadiano, nAltura, nLargura, nAngulo

   ::oPdfPage := HPDF_AddPage( ::oPdf )

   HPDF_Page_SetSize( ::oPdfPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT )

   nAltura := HPDF_Page_GetHeight( ::oPdfPage )
   nLargura := HPDF_Page_GetWidth( ::oPdfPage )

   ::nLinhaPdf := nAltura - 3     && Margem Superior
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

METHOD cabecalho() CLASS hbCteDacte
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
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-119 , 295 , 119 , ::nLarguraBox )
oImage:= HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
HPDF_Page_DrawImage( ::oPdfPage, oImage, 115 , ::nLinhaPdf - (52+1), 100, 052)
If Len(::aEmit[ "xNome" ]) <= 25
	hbCte_Texto_Hpdf( ::oPdfPage,  3, ::nLinhaPdf-056, 295, Nil, ::aEmit[ "xNome" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
Else
	hbCte_Texto_Hpdf( ::oPdfPage,  3, ::nLinhaPdf-056, 295, Nil, ::aEmit[ "xNome" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-070, 295, Nil, ::aEmit[ "xLgr" ]+" "+Iif(::aEmit[ "nro" ]  != Nil,::aEmit[ "nro" ],'')+" "+Iif(::aEmit[ "xCpl" ] != Nil,::aEmit[ "xCpl" ],''), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-078, 295, Nil, ::aEmit[ "xBairro" ]+" - "+TRANSF( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-086, 295, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-094, 295, Nil, 'Fone/Fax:('+Subs(::aEmit[ "fone" ],1,2)+')'+Subs(::aEmit[ "fone" ],3,4)+'-'+Subs(::aEmit[ "fone" ],7,4) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-107, 295, Nil, 'CNPJ/CPF:'+TRANSF( ::aEmit[ "CNPJ" ] , "@R 99.999.999/9999-99")+'       Inscr.Estadual:'+ConfIE(::aEmit[ "UF" ],Alltrim(::aEmit[ "IE" ]),,.F.) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )

// box do nome do documento
hbCte_Box_Hpdf( ::oPdfPage, 303 , ::nLinhaPdf-032 , 145 , 032 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 303 , ::nLinhaPdf-001 , 448, Nil, "DACTE" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
hbCte_Texto_Hpdf( ::oPdfPage, 303 , ::nLinhaPdf-010 , 448, Nil, "Documento Auxiliar do" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 303 , ::nLinhaPdf-016 , 448, Nil, "Conhecimento de Transporte" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 303 , ::nLinhaPdf-022 , 448, Nil, "Eletrônico" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )

// box do modal
hbCte_Box_Hpdf( ::oPdfPage, 453 , ::nLinhaPdf-032 , 140 , 032 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 453 , ::nLinhaPdf-001 , 588, Nil, "MODAL" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
hbCte_Texto_Hpdf( ::oPdfPage, 453 , ::nLinhaPdf-015 , 588, Nil, aModal[Val(::aIde[ "modal" ])] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )

// box do modelo
hbCte_Box_Hpdf( ::oPdfPage, 303 , ::nLinhaPdf-060 , 035 , 025 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 303 , ::nLinhaPdf-040 , 338, Nil, "Modelo" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 303 , ::nLinhaPdf-047 , 338, Nil, ::aIde[ "mod" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10)

// box da serie
hbCte_Box_Hpdf( ::oPdfPage, 338 , ::nLinhaPdf-060 , 035 , 025 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 338 , ::nLinhaPdf-040 , 373, Nil, "Série" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 338 , ::nLinhaPdf-047 , 373, Nil, ::aIde[ "serie" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10)

// box do numero
hbCte_Box_Hpdf( ::oPdfPage, 373 , ::nLinhaPdf-060 , 060 , 025 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 373 , ::nLinhaPdf-040 , 433, Nil, "Número" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 373 , ::nLinhaPdf-047 , 433, Nil, ::aIde[ "nCT" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10)

// box do fl
hbCte_Box_Hpdf( ::oPdfPage, 433 , ::nLinhaPdf-060 , 035 , 025 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 433 , ::nLinhaPdf-040 , 468, Nil, "FL" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 433 , ::nLinhaPdf-047 , 468, Nil, "1/1" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10)

// box do data e hora
hbCte_Box_Hpdf( ::oPdfPage, 468 , ::nLinhaPdf-060 , 125 , 025 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 468 , ::nLinhaPdf-040 , 588, Nil, "Data e Hora de Emissão" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 468 , ::nLinhaPdf-047 , 588, Nil, SUBS(::aIde[ "dhEmi" ],9,2)+"/"+SUBS(::aIde[ "dhEmi" ],6,2)+"/"+SUBS(::aIde[ "dhEmi" ],1,4)+' '+SUBS(::aIde[ "dhEmi" ],12) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10)

// box do controle do fisco
hbCte_Box_Hpdf( ::oPdfPage, 303 , ::nLinhaPdf-129 , 290 , 066 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 303 , ::nLinhaPdf-065 , 588, Nil, "CONTROLE DO FISCO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 09 )
hbCte_Texto_Hpdf( ::oPdfPage, 303 , ::nLinhaPdf-075 , 588, Nil, CTe_CodificaCode128c(::cChave), HPDF_TALIGN_CENTER, Nil, ::cFonteCode128F, 17 )
hbCte_Texto_Hpdf( ::oPdfPage, 303 , ::nLinhaPdf-110 , 588, Nil, "Chave de acesso para consulta de autenticidade no site www.cte.fazenda.gov.br" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 303 , ::nLinhaPdf-119 , 588, Nil, TRANSF(::cChave, "@R 99.9999.99.999.999/9999-99-99-999-999.999.999-999.999.999-9") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )

// box do tipo do cte
hbCte_Box_Hpdf( ::oPdfPage, 003 , ::nLinhaPdf-154 , 060 , 032 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 003 , ::nLinhaPdf-125 , 060, Nil, "Tipo do CTe" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 003 , ::nLinhaPdf-135 , 060, Nil, aTipoCte[Val(::aIde[ "tpCTe" ])+1] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10)

// box do tipo do servico
hbCte_Box_Hpdf( ::oPdfPage, 063 , ::nLinhaPdf-154 , 070 , 032 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 063 , ::nLinhaPdf-125 , 133, Nil, "Tipo Serviço" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 063 , ::nLinhaPdf-135 , 133, Nil, aTipoServ[Val(::aIde[ "tpServ" ])+1] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10)

// box do tipo do Tomador do Servico
hbCte_Box_Hpdf( ::oPdfPage, 133 , ::nLinhaPdf-154 , 070 , 032 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 133 , ::nLinhaPdf-125 , 203, Nil, "Tomador" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 133 , ::nLinhaPdf-135 , 203, Nil, aTomador[Val(::aIde[ "toma" ])+1] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10)

// box do tipo Forma de Pagamento
hbCte_Box_Hpdf( ::oPdfPage, 203 , ::nLinhaPdf-154 , 095 , 032 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 203 , ::nLinhaPdf-125 , 298, Nil, "Forma de Pagamento" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 203 , ::nLinhaPdf-135 , 298, Nil, aPagto[Val(::aIde[ "forPag" ])+1] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10)
// box do No. do Protocolo
hbCte_Box_Hpdf( ::oPdfPage, 303 , ::nLinhaPdf-154 , 165 , 022 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 303 , ::nLinhaPdf-135 , 468, Nil, "No. PROTOCOLO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
If ::aProtocolo[ "nProt" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 303 , ::nLinhaPdf-143 , 468, Nil, ::aProtocolo[ "nProt" ]+' - '+SUBS(::aProtocolo[ "dhRecbto" ],9,2)+"/"+SUBS(::aProtocolo[ "dhRecbto" ],6,2)+"/"+SUBS(::aProtocolo[ "dhRecbto" ],1,4)+' '+SUBS(::aProtocolo[ "dhRecbto" ],12) , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalhoBold, 9 )
Endif

// box da Insc. da Suframa
hbCte_Box_Hpdf( ::oPdfPage, 468 , ::nLinhaPdf-154 , 125 , 022 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 468 , ::nLinhaPdf-135 , 588, Nil, "INSC. SUFRAMA DO DEST." , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
//hbCte_Texto_Hpdf( ::oPdfPage, 468 , ::nLinhaPdf-145 , 568, Nil, ::aDest[ "ISUF" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 6 )
hbCte_Texto_Hpdf( ::oPdfPage, 468 , ::nLinhaPdf-143 , 588, Nil, 'xxxxx xxxxxxxxxxxxxxx' , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 9 )

// box da Natureza da Prestacao
hbCte_Box_Hpdf( ::oPdfPage, 003 , ::nLinhaPdf-179 , 590 , 022 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-160 , 588, Nil, "CFOP - Natureza da Prestação" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-168 , 588, Nil, ::aIde[ "CFOP" ]+' - '+::aIde[ "natOp" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )

// Box da Origem da Prestação
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-204 , 295 , 022 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-185 , 295, Nil, "Origem da Prestação" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-193 , 295, Nil, ::aIde[ "xMunIni" ]+' - '+::aIde[ "UFIni" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )

// Box do Destino da Prestação
hbCte_Box_Hpdf( ::oPdfPage,  303 , ::nLinhaPdf-204 , 290 , 022 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 308 , ::nLinhaPdf-185 , 588, Nil, "Destino da Prestação" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 308 , ::nLinhaPdf-193 , 588, Nil, ::aIde[ "xMunFim" ]+' - '+::aIde[ "UFFim" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )

// Box do Remetente
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-261 , 295 , 054 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-207 , 040, Nil, "Remetente " , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-208 , 295, Nil, ::aRem[ "xNome" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-215 , 040, Nil, "Endereço" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-216 , 295, Nil, ::aRem[ "xLgr" ]+" "+Iif(::aRem[ "nro" ]  != Nil,::aRem[ "nro" ],'')+" "+Iif(::aRem[ "xCpl" ] != Nil,::aRem[ "xCpl" ],''), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-224 , 295, Nil, ::aRem[ "xBairro" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-232 , 040, Nil, "Município" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-233 , 240, Nil, ::aRem[ "xMun" ]+" "+::aRem[ "UF" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 240 , ::nLinhaPdf-232 , 260, Nil, "CEP" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
Try
	hbCte_Texto_Hpdf( ::oPdfPage, 260 , ::nLinhaPdf-233 , 295, Nil, Subs(::aRem[ "CEP" ],1,5)+'-'+Subs(::aRem[ "CEP" ],6,3) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Catch
End
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-240 , 042, Nil, "CNPJ/CPF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
Try
	If Val(::aRem[ "CNPJ" ]) > 0
		hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-241 , 150, Nil, TRANSF(::aRem[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
	Endif
Catch
	Try
		If Val(::aRem[ "CPF" ]) > 0
			hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-241 , 150, Nil, TRANSF(::aRem[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
		Endif
	Catch
	End
End
hbCte_Texto_Hpdf( ::oPdfPage, 150 , ::nLinhaPdf-240 , 250, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 245 , ::nLinhaPdf-241 , 295, Nil, ConfIE(::aRem[ "UF" ],Alltrim(::aRem[ "IE" ]),,.F.) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-248 , 042, Nil, "Pais" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-249 , 150, Nil, ::aRem[ "xPais" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 225 , ::nLinhaPdf-248 , 250, Nil, "FONE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aRem[ "fone" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 250 , ::nLinhaPdf-249 , 295, Nil, TRANSF( Val(::aRem[ "fone" ]) , "@R (99)9999-9999") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif

// Box do Destinatario
hbCte_Box_Hpdf( ::oPdfPage,  303 , ::nLinhaPdf-261 , 290 , 054 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 305 , ::nLinhaPdf-207 , 340, Nil, "Destinatário" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 342 , ::nLinhaPdf-208 , 595, Nil, ::aDest[ "xNome" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 305 , ::nLinhaPdf-215 , 340, Nil, "Endereço" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 342 , ::nLinhaPdf-216 , 588, Nil, ::aDest[ "xLgr" ]+" "+Iif(::aDest[ "nro" ]  != Nil,::aDest[ "nro" ],'')+" "+Iif(::aDest[ "xCpl" ] != Nil,::aDest[ "xCpl" ],''), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 342 , ::nLinhaPdf-224 , 588, Nil, ::aDest[ "xBairro" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 305 , ::nLinhaPdf-232 , 340, Nil, "Município" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 342 , ::nLinhaPdf-233 , 540, Nil, ::aDest[ "xMun" ]+" "+::aDest[ "UF" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 535 , ::nLinhaPdf-232 , 555, Nil, "CEP" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
Try
	hbCte_Texto_Hpdf( ::oPdfPage, 555 , ::nLinhaPdf-233 , 588, Nil, Subs(::aDest[ "CEP" ],1,5)+'-'+Subs(::aDest[ "CEP" ],6,3) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Catch
End
hbCte_Texto_Hpdf( ::oPdfPage, 305 , ::nLinhaPdf-240 , 342, Nil, "CNPJ/CPF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
Try
	If Val(::aDest[ "CNPJ" ]) > 0
		hbCte_Texto_Hpdf( ::oPdfPage, 342 , ::nLinhaPdf-241 , 450, Nil, TRANS(::aDest[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
	Endif
Catch
	Try
		If Val(::aDest[ "CPF" ]) > 0
			hbCte_Texto_Hpdf( ::oPdfPage, 342 , ::nLinhaPdf-241 , 450, Nil, TRANS(::aDest[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
		Endif
	Catch
	End
End
hbCte_Texto_Hpdf( ::oPdfPage, 430 , ::nLinhaPdf-240 , 530, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )

Try
	If Upper(Alltrim(::aDest[ "IE" ])) = 'ISENTO'
		hbCte_Texto_Hpdf( ::oPdfPage, 530 , ::nLinhaPdf-241 , 595, Nil, Alltrim(::aDest[ "IE" ]) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
	Else
		hbCte_Texto_Hpdf( ::oPdfPage, 530 , ::nLinhaPdf-241 , 595, Nil, ConfIE(::aDest[ "UF" ],Alltrim(::aDest[ "IE" ]),,.F.) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
	Endif
Catch
End
hbCte_Texto_Hpdf( ::oPdfPage, 305 , ::nLinhaPdf-248 , 342, Nil, "Pais" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 342 , ::nLinhaPdf-249 , 450, Nil, ::aDest[ "xPais" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Try
	hbCte_Texto_Hpdf( ::oPdfPage, 520 , ::nLinhaPdf-248 , 545, Nil, "FONE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
Catch
End
Try
If ::aDest[ "fone" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 545 , ::nLinhaPdf-249 , 595, Nil, '('+Subs(::aDest[ "fone" ],1,2)+')'+Subs(::aDest[ "fone" ],3,4)+'-'+Subs(::aDest[ "fone" ],7,4) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
Catch
End
// Box do Expedidor
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-318 , 295 , 054 , ::nLarguraBox )

hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-264 , 040, Nil, "Expedidor" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aExped[ "xNome" ] != Nil
   hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-265 , 295, Nil, ::aExped[ "xNome" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-272 , 040, Nil, "Endereço" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aExped[ "xLgr" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-273 , 295, Nil, ::aExped[ "xLgr" ]+" "+Iif(::aExped[ "nro" ]  != Nil,::aExped[ "nro" ],'')+" "+Iif(::aExped[ "xCpl" ] != Nil,::aExped[ "xCpl" ],''), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
If ::aExped[ "xBairro" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-280 , 295, Nil, ::aExped[ "xBairro" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-288 , 040, Nil, "Município" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aExped[ "xMun" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-289 , 240, Nil, ::aExped[ "xMun" ]+" "+::aExped[ "UF" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 240 , ::nLinhaPdf-288 , 260, Nil, "CEP" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aExped[ "CEP" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 260 , ::nLinhaPdf-289 , 295, Nil, Subs(::aExped[ "CEP" ],1,5)+'-'+Subs(::aExped[ "CEP" ],6,3) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-296 , 042, Nil, "CNPJ/CPF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aExped[ "CNPJ" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-297 , 150, Nil, TRANSF(::aExped[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
If ::aExped[ "CPF" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-297 , 150, Nil, TRANSF(::aExped[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 150 , ::nLinhaPdf-296 , 250, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aExped[ "IE" ] != Nil
	If Upper(Alltrim(::aExped[ "IE" ])) = 'ISENTO'
		hbCte_Texto_Hpdf( ::oPdfPage, 245 , ::nLinhaPdf-297 , 295, Nil, Alltrim(::aExped[ "IE" ]) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
	Else
		hbCte_Texto_Hpdf( ::oPdfPage, 245 , ::nLinhaPdf-297 , 295, Nil, ConfIE(::aExped[ "UF" ],Alltrim(::aExped[ "IE" ]),,.F.) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
	Endif
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-304 , 042, Nil, "Pais" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aExped[ "xPais" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-305 , 150, Nil, ::aExped[ "xPais" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 225 , ::nLinhaPdf-304 , 250, Nil, "FONE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aExped[ "fone" ] != Nil
   hbCte_Texto_Hpdf( ::oPdfPage, 250 , ::nLinhaPdf-305 , 295, Nil, '('+Subs(::aExped[ "fone" ],1,2)+')'+Subs(::aExped[ "fone" ],3,4)+'-'+Subs(::aExped[ "fone" ],7,4) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif

// Box do Recebedor
hbCte_Box_Hpdf( ::oPdfPage,  303 , ::nLinhaPdf-318 , 290 , 054 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 305 , ::nLinhaPdf-264 , 340, Nil, "Recebedor" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
If ::aReceb[ "xNome" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 342 , ::nLinhaPdf-265 , 595, Nil, ::aReceb[ "xNome" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 305 , ::nLinhaPdf-272 , 340, Nil, "Endereço" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aReceb[ "xLgr" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 342 , ::nLinhaPdf-273 , 588, Nil, ::aReceb[ "xLgr" ]+" "+Iif(::aReceb[ "nro" ]  != Nil,::aReceb[ "nro" ],'')+" "+Iif(::aReceb[ "xCpl" ] != Nil,::aReceb[ "xCpl" ],''), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
If ::aReceb[ "xBairro" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 342 , ::nLinhaPdf-280 , 588, Nil, ::aReceb[ "xBairro" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 305 , ::nLinhaPdf-288 , 340, Nil, "Município" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aReceb[ "xMun" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 342 , ::nLinhaPdf-289 , 540, Nil, ::aReceb[ "xMun" ]+" "+::aReceb[ "UF" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 535 , ::nLinhaPdf-288 , 555, Nil, "CEP" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aReceb[ "CEP" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 555 , ::nLinhaPdf-289 , 588, Nil, Subs(::aReceb[ "CEP" ],1,5)+'-'+Subs(::aReceb[ "CEP" ],6,3) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 305 , ::nLinhaPdf-296 , 342, Nil, "CNPJ/CPF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aReceb[ "CNPJ" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 342 , ::nLinhaPdf-297 , 450, Nil, TRANSF(::aReceb[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
If ::aReceb[ "CPF" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 342 , ::nLinhaPdf-297 , 450, Nil, TRANSF(::aReceb[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 440 , ::nLinhaPdf-296 , 540, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aReceb[ "IE" ] != Nil
	If Upper(Alltrim(::aReceb[ "IE" ])) = 'ISENTO'
		hbCte_Texto_Hpdf( ::oPdfPage, 540 , ::nLinhaPdf-297 , 590, Nil, Alltrim(::aReceb[ "IE" ]) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
	Else
		hbCte_Texto_Hpdf( ::oPdfPage, 540 , ::nLinhaPdf-297 , 590, Nil, ConfIE(::aReceb[ "UF" ],Alltrim(::aReceb[ "IE" ]),,.F.) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
	Endif
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 305 , ::nLinhaPdf-304 , 342, Nil, "Pais" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aReceb[ "xPais" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 342 , ::nLinhaPdf-305 , 450, Nil, ::aReceb[ "xPais" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 520 , ::nLinhaPdf-304 , 545, Nil, "FONE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aReceb[ "fone" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 545 , ::nLinhaPdf-305 , 595, Nil, '('+Subs(::aReceb[ "fone" ],1,2)+')'+Subs(::aReceb[ "fone" ],3,4)+'-'+Subs(::aReceb[ "fone" ],7,4) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif

// Box do Tomador
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-347 , 590 , 026 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-321 , 075, Nil, "Tomador do Serviço" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 077 , ::nLinhaPdf-322 , 330, Nil, ::aToma[ "xNome" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 337 , ::nLinhaPdf-321 , 372, Nil, "Município" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 373 , ::nLinhaPdf-322 , 460, Nil, ::aToma[ "xMun" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 495 , ::nLinhaPdf-321 , 510, Nil, "UF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 512 , ::nLinhaPdf-322 , 534, Nil, ::aToma[ "UF" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 530 , ::nLinhaPdf-321 , 550, Nil, "CEP" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 552 , ::nLinhaPdf-322 , 590, Nil, Subs(::aToma[ "CEP" ],1,5)+'-'+Subs(::aToma[ "CEP" ],6,3) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-329 , 040, Nil, "Endereço" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-330 , 590, Nil, ::aToma[ "xLgr" ]+" "+Iif(::aToma[ "nro" ]  != Nil,::aToma[ "nro" ],'')+" "+Iif(::aToma[ "xCpl" ] != Nil,::aToma[ "xCpl" ],'')+' - '+::aToma[ "xBairro" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-337 , 042, Nil, "CNPJ/CPF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )

Try
	If Val(::aToma[ "CNPJ" ]) > 0
		hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-338 , 150, Nil, TRANSF(::aToma[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
	Endif
Catch
	Try
		If Val(::aToma[ "CPF" ]) > 0
			hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-338 , 150, Nil, TRANSF(::aToma[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
		Endif
	Catch
	End
End

hbCte_Texto_Hpdf( ::oPdfPage, 150 , ::nLinhaPdf-337 , 250, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If Upper(Alltrim(::aToma[ "IE" ])) = 'ISENTO'
	hbCte_Texto_Hpdf( ::oPdfPage, 245 , ::nLinhaPdf-338 , 295, Nil, Alltrim(::aToma[ "IE" ]) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Else
	hbCte_Texto_Hpdf( ::oPdfPage, 245 , ::nLinhaPdf-338 , 295, Nil, ConfIE(::aToma[ "UF" ],Alltrim(::aToma[ "IE" ]),,.F.) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 425 , ::nLinhaPdf-337 , 465, Nil, "Pais" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 442 , ::nLinhaPdf-338 , 500, Nil, ::aToma[ "xPais" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 520 , ::nLinhaPdf-337 , 560, Nil, "FONE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aToma[ "fone" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 542 , ::nLinhaPdf-338 , 590, Nil, '('+Subs(::aToma[ "fone" ],1,2)+')'+Subs(::aToma[ "fone" ],3,4)+'-'+Subs(::aToma[ "fone" ],7,4) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif

// Box do Produto Predominante
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-373 , 340 , 023 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-350 , 150, Nil, "Produto Predominante" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-360 , 330, Nil, ::aInfCarga[ "proPred" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10)
hbCte_Box_Hpdf( ::oPdfPage,  343 , ::nLinhaPdf-373 , 125 , 023 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 348 , ::nLinhaPdf-350 , 470, Nil, "Outras Características da Carga" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 348 , ::nLinhaPdf-360 , 470, Nil, ::aInfCarga[ "xOutCat" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10)
hbCte_Box_Hpdf( ::oPdfPage,  468 , ::nLinhaPdf-373 , 125 , 023 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 473 , ::nLinhaPdf-350 , 590, Nil, "Valot Total da Mercadoria" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 473 , ::nLinhaPdf-358 , 580, Nil, Trans( Val(::aInfCarga[ "vCarga" ]) , '@E 9,999,999.99' ) , HPDF_TALIGN_RIGHT , Nil, ::oPdfFontCabecalhoBold, 12 )

// Box das Quantidades
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-398 , 090 , 025 , ::nLarguraBox )
hbCte_Box_Hpdf( ::oPdfPage,  093 , ::nLinhaPdf-398 , 090 , 025 , ::nLarguraBox )
hbCte_Box_Hpdf( ::oPdfPage,  183 , ::nLinhaPdf-398 , 090 , 025 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-373 , 090, Nil, "QT./UN./Medida" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If Len(::aInfQ) > 0
	hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-383 , 098, Nil, Alltrim(Tran( Val(::aInfQ[ 1 , 3 ] ) , '@E 999,999.999' ))+'/'+aUnid[Val(::aInfQ[ 1 , 1 ])+1]+'/'+::aInfQ[ 1 , 2 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 098 , ::nLinhaPdf-373 , 190, Nil, "QT./UN./Medida" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If Len(::aInfQ) > 1
	hbCte_Texto_Hpdf( ::oPdfPage, 098 , ::nLinhaPdf-383 , 188, Nil, Alltrim(Tran( Val(::aInfQ[ 2 , 3 ] ) , '@E 999,999.999' ))+'/'+aUnid[Val(::aInfQ[ 2 , 1 ])+1]+'/'+::aInfQ[ 2 , 2 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 188 , ::nLinhaPdf-373 , 250, Nil, "QT./UN./Medida" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If Len(::aInfQ) > 2
	hbCte_Texto_Hpdf( ::oPdfPage, 188 , ::nLinhaPdf-383 , 273, Nil, Alltrim(Tran( Val(::aInfQ[ 3 , 3 ] ) , '@E 999,999.999' ))+'/'+aUnid[Val(::aInfQ[ 3 , 1 ])+1]+'/'+::aInfQ[ 3 , 2 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Endif

// Box da Seguradora
hbCte_Box_Hpdf( ::oPdfPage,  273 , ::nLinhaPdf-383 , 320 , 010 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 278 , ::nLinhaPdf-373 , 400, Nil, "Nome da Seguradora" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 405 , ::nLinhaPdf-373 , 580, Nil, ::aSeg[ "xSeg" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Box_Hpdf( ::oPdfPage,  273 , ::nLinhaPdf-398 , 097 , 015 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 278 , ::nLinhaPdf-383 , 370, Nil, "Responsável" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
Try
	hbCte_Texto_Hpdf( ::oPdfPage, 278 , ::nLinhaPdf-389 , 370, Nil, aResp[Val(::aSeg[ "respSeg" ])+1] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
Catch
End
hbCte_Box_Hpdf( ::oPdfPage,  370 , ::nLinhaPdf-398 , 098 , 015 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 375 , ::nLinhaPdf-383 , 465, Nil, "Número da Apólice" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 375 , ::nLinhaPdf-389 , 468, Nil, ::aSeg[ "nApol" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
hbCte_Box_Hpdf( ::oPdfPage,  468 , ::nLinhaPdf-398 , 125 , 015 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 473 , ::nLinhaPdf-383 , 590, Nil, "Número da Averbação" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
hbCte_Texto_Hpdf( ::oPdfPage, 473 , ::nLinhaPdf-389 , 590, Nil, ::aSeg[ "nAver" ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 7 )

// Box dos Componentes do Valor da Prestação do Serviço
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-410 , 590 , 009 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 003 , ::nLinhaPdf-400 , 590, Nil, "Componentes do Valor da Prestação do Serviço" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalho, 8 )
// Box de Servicos e Valores
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-475 , 165 , 062 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-413 , 085, Nil, "Nome" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 085 , ::nLinhaPdf-413 , 165, Nil, "Valor" , HPDF_TALIGN_RIGHT , Nil, ::oPdfFontCabecalho, 8 )
hbCte_Box_Hpdf( ::oPdfPage,  168 , ::nLinhaPdf-475 , 165 , 062 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 171 , ::nLinhaPdf-413 , 251, Nil, "Nome" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 251 , ::nLinhaPdf-413 , 330, Nil, "Valor" , HPDF_TALIGN_RIGHT , Nil, ::oPdfFontCabecalho, 8 )
hbCte_Box_Hpdf( ::oPdfPage,  333 , ::nLinhaPdf-475 , 165 , 062 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 338 , ::nLinhaPdf-413 , 418, Nil, "Nome" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 418 , ::nLinhaPdf-413 , 495, Nil, "Valor" , HPDF_TALIGN_RIGHT , Nil, ::oPdfFontCabecalho, 8 )
hbCte_Box_Hpdf( ::oPdfPage,  498 , ::nLinhaPdf-444 , 095 , 031 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 498 , ::nLinhaPdf-417 , 590, Nil, "Valor Total do Serviço" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 498 , ::nLinhaPdf-427 , 580, Nil, Trans( Val(::aPrest[ "vTPrest" ]) , '@E 999,999.99' ) , HPDF_TALIGN_RIGHT , Nil, ::oPdfFontCabecalhoBold, 12 )
hbCte_Box_Hpdf( ::oPdfPage,  498 , ::nLinhaPdf-475 , 095 , 031 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 498 , ::nLinhaPdf-447 , 590, Nil, "Valor a Receber" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 498 , ::nLinhaPdf-457 , 580, Nil, Trans( Val(::aPrest[ "vRec" ]) , '@E 999,999.99' ) , HPDF_TALIGN_RIGHT , Nil, ::oPdfFontCabecalhoBold, 12 )

nLinha:=423
I:=0
For I = 1 To Len(::aComp) Step 3

   Try
      hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-nLinha , 165, Nil, ::aComp[ I , 1 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
      hbCte_Texto_Hpdf( ::oPdfPage, 085 , ::nLinhaPdf-nlinha , 165, Nil, Trans( Val(::aComp[ I , 2 ]) , '@E 999,999.99' ) , HPDF_TALIGN_RIGHT , Nil, ::oPdfFontCabecalhoBold, 8 )
   Catch
   End

   Try
      hbCte_Texto_Hpdf( ::oPdfPage, 171 , ::nLinhaPdf-nLinha , 251, Nil, ::aComp[ I+1 ,1 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
      hbCte_Texto_Hpdf( ::oPdfPage, 251 , ::nLinhaPdf-nLinha , 330, Nil, Trans( Val(::aComp[ I+1 , 2 ]) , '@E 999,999.99' ) , HPDF_TALIGN_RIGHT , Nil, ::oPdfFontCabecalhoBold, 8 )
   Catch
   End

   Try
      hbCte_Texto_Hpdf( ::oPdfPage, 338 , ::nLinhaPdf-nLinha , 418, Nil, ::aComp[ I+2 ,1 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
      hbCte_Texto_Hpdf( ::oPdfPage, 418 , ::nLinhaPdf-nLinha , 495, Nil, Trans( Val(::aComp[ I+2 , 2 ]) , '@E 999,999.99' ) , HPDF_TALIGN_RIGHT , Nil, ::oPdfFontCabecalhoBold, 8 )
   Catch
   End
	nLinha+=10

Next

// Box das Informações Relativas ao Imposto
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-487 , 590 , 009 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 003 , ::nLinhaPdf-478 , 590, Nil, "Informações Relativas ao Imposto" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalho, 8 )
// Box da Situação Tributária
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-514 , 155 , 027 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-488 , 155, Nil, "Situação Tributária" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
If ::aIcmsSN[ "indSN" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-500 , 155, Nil, "SIMPLES NACIONAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
ElseIf ::aIcms00[ "CST" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-500 , 155, Nil, "00 - Tributação normal do ICMS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
	nBase:=::aIcms00[ "vBC" ]
	nAliq:=::aIcms00[ "pICMS" ]
	nValor:=::aIcms00[ "vICMS" ]
	nReduc:=''
	nST:=''
ElseIf ::aIcms20[ "CST" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-500 , 155, Nil, "20 - Tributação com BC reduzida do ICMS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
	nBase:=::aIcms20[ "vBC" ]
	nAliq:=::aIcms20[ "pICMS" ]
	nValor:=::aIcms20[ "vICMS" ]
	nReduc:=::aIcms20[ "pRedBC" ]
	nST:=''
ElseIf ::aIcms45[ "CST" ] != Nil
	If ::aIcms45[ "CST" ] = '40'
		hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-500 , 155, Nil, "40 - ICMS isenção" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
	ElseIf ::aIcms45[ "CST" ] = '41'
		hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-500 , 155, Nil, "41 - ICMS não tributada" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
	ElseIf ::aIcms45[ "CST" ] = '51'
		hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-500 , 155, Nil, "51 - ICMS diferido" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
	Endif
ElseIf ::aIcms60[ "CST" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-500 , 155, Nil, "60 - ICMS cobrado anteriormente por substituição tributária" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
	nBase:=::aIcms60[ "vBCSTRet" ]
	nAliq:=::aIcms60[ "pICMSSTRet" ]
	nValor:=::aIcms60[ "vICMSSTRet" ]
	nReduc:=''
	nST:=::aIcms60[ "vCred" ]
ElseIf ::aIcms90[ "CST" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-500 , 155, Nil, "90 - ICMS Outros" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
	nBase:=::aIcms60[ "vBC" ]
	nAliq:=::aIcms60[ "pICMS" ]
	nValor:=::aIcms60[ "vICMS" ]
	nReduc:=::aIcms90[ "pRedBC" ]
	nST:=::aIcms60[ "vCred" ]
ElseIf ::aIcmsUF[ "CST" ] != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-500 , 155, Nil, "90 - ICMS Outros" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
	nBase:=::aIcmsUF[ "vBCOutraUF" ]
	nAliq:=::aIcmsUF[ "pICMSOutraUF" ]
	nValor:=::aIcmsUF[ "vICMSOutraUF" ]
	nReduc:=::aIcmsUF[ "pRedBCOutraUF" ]
	nST:=''
Else
	hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-500 , 155, Nil, "Sem Imposto de ICMS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
Endif

// Box da Base De Calculo
hbCte_Box_Hpdf( ::oPdfPage,  158 , ::nLinhaPdf-514 , 080 , 027 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 160 , ::nLinhaPdf-488 , 238, Nil, "Base De Calculo" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 160 , ::nLinhaPdf-498 , 238, Nil, Trans( Val(nBase) , '@E 999,999.99' ) , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
// Box da Alíq ICMS
hbCte_Box_Hpdf( ::oPdfPage,  238 , ::nLinhaPdf-514 , 080 , 027 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 240 , ::nLinhaPdf-488 , 318, Nil, "Alíq ICMS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 240 , ::nLinhaPdf-498 , 318, Nil, Trans( Val(nAliq) , '@E 999,999.99' ) , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
// Box do Valor ICMS
hbCte_Box_Hpdf( ::oPdfPage,  318 , ::nLinhaPdf-514 , 080 , 027 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 320 , ::nLinhaPdf-488 , 398, Nil, "Valor ICMS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 320 , ::nLinhaPdf-498 , 398, Nil, Trans( Val(nValor) , '@E 999,999.99' ) , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
// Box da % Red. BC ICMS
hbCte_Box_Hpdf( ::oPdfPage,  398 , ::nLinhaPdf-514 , 080 , 027 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 400 , ::nLinhaPdf-488 , 478, Nil, "% Red. BC ICMS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 400 , ::nLinhaPdf-498 , 478, Nil, Trans( Val(nReduc) , '@E 999,999.99' ) , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
// Box do ICMS ST
hbCte_Box_Hpdf( ::oPdfPage,  478 , ::nLinhaPdf-514 , 115 , 027 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 480 , ::nLinhaPdf-488 , 590, Nil, "ICMS ST" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 480 , ::nLinhaPdf-498 , 590, Nil, Trans( Val(nSt)   , '@E 999,999.99' ) , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )

// Box dos Documentos Originários
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-526 , 590 , 009 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 003 , ::nLinhaPdf-517 , 590, Nil, "Documentos Originários" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalho, 8 )
// Box dos documentos a esquerda
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-626 , 295 , 100 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-526 , 050, Nil, "Tipo DOC" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
If Len(::aInfNF) > 0
	hbCte_Texto_Hpdf( ::oPdfPage, 050 , ::nLinhaPdf-526 , 240, Nil, "CNPJ/CPF Emitente" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
ElseIf Len(::aInfOutros) > 0
	hbCte_Texto_Hpdf( ::oPdfPage, 170 , ::nLinhaPdf-526 , 240, Nil, "CNPJ/CPF Emitente" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
ElseIf Len(::aInfNFe) > 0
	hbCte_Texto_Hpdf( ::oPdfPage, 050 , ::nLinhaPdf-526 , 240, Nil, "CHAVE DE ACESSO DA NF-e" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
Else
	hbCte_Texto_Hpdf( ::oPdfPage, 050 , ::nLinhaPdf-526 , 240, Nil, "CNPJ/CPF Emitente" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 240 , ::nLinhaPdf-526 , 295, Nil, "Série/Nro. Doc." , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )

// Box dos documentos a direita
hbCte_Box_Hpdf( ::oPdfPage,  298 , ::nLinhaPdf-626 , 295 , 100 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 300 , ::nLinhaPdf-526 , 345, Nil, "Tipo DOC" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
If Len(::aInfNF) > 0
	hbCte_Texto_Hpdf( ::oPdfPage, 345 , ::nLinhaPdf-526 , 535, Nil, "CNPJ/CPF Emitente" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
ElseIf Len(::aInfOutros) > 0
	hbCte_Texto_Hpdf( ::oPdfPage, 465 , ::nLinhaPdf-526 , 535, Nil, "CNPJ/CPF Emitente" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
ElseIf Len(::aInfNFe) > 0
	hbCte_Texto_Hpdf( ::oPdfPage, 345 , ::nLinhaPdf-526 , 535, Nil, "CHAVE DE ACESSO DA NF-e" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
Else
	hbCte_Texto_Hpdf( ::oPdfPage, 345 , ::nLinhaPdf-526 , 535, Nil, "CNPJ/CPF Emitente" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
Endif
hbCte_Texto_Hpdf( ::oPdfPage, 535 , ::nLinhaPdf-526 , 590, Nil, "Série/Nro. Doc." , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )

If Len(::aInfNFe) > 0

	nLinha:=536
	I:=0

	For I = 1 To Len(::aInfNFe) Step 2

	 	Try
			If !Empty(::aInfNFe[ I , 1 ])
				hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-nLinha , 353, Nil, "NF-E" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
				hbCte_Texto_Hpdf( ::oPdfPage, 050 , ::nLinhaPdf-nLinha , 240, Nil, ::aInfNFe[ I , 1 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
				hbCte_Texto_Hpdf( ::oPdfPage, 240 , ::nLinhaPdf-nLinha , 295, Nil, Subs(::aInfNFe[ I , 1 ],23,3)+'/'+Subs(::aInfNFe[ I , 1 ],26,9) , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
			Endif
		Catch
		End

	 	Try
			If !Empty(::aInfNFe[ I+1 , 1 ])
				hbCte_Texto_Hpdf( ::oPdfPage, 300 , ::nLinhaPdf-nLinha , 353, Nil, "NF-E" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
				hbCte_Texto_Hpdf( ::oPdfPage, 345 , ::nLinhaPdf-nLinha , 535, Nil, ::aInfNFe[ I+1 , 1 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
				hbCte_Texto_Hpdf( ::oPdfPage, 535 , ::nLinhaPdf-nLinha , 590, Nil, Subs(::aInfNFe[ I+1 , 1 ],23,3)+'/'+Subs(::aInfNFe[ I+1 , 1 ],26,9) , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
			Endif
		Catch
		End

		nLinha+=10

	Next

Endif

If Len(::aInfNF) > 0

	nLinha:=536
	I:=0

	For I = 1 To Len(::aInfNF) Step 2

	 	Try
	 		If !Empty(::aInfNF[ I , 4 ])
				hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-nLinha-2 , 353, Nil, "NOTA FISCAL" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
				Try
					If Val(::aRem[ "CNPJ" ]) > 0
						hbCte_Texto_Hpdf( ::oPdfPage, 050 , ::nLinhaPdf-nLinha , 240, Nil, TRANSF(::aRem[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
					Endif
				Catch
					Try
						If Val(::aRem[ "CPF" ]) > 0
							hbCte_Texto_Hpdf( ::oPdfPage, 050 , ::nLinhaPdf-nLinha , 240, Nil, TRANSF(::aRem[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
						Endif
					Catch
					End
				End
				hbCte_Texto_Hpdf( ::oPdfPage, 240 , ::nLinhaPdf-nLinha , 295, Nil, ::aInfNF[ I , 4 ]+'/'+::aInfNF[ I , 5 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
			Endif
		Catch
		End

	 	Try
	 		If !Empty(::aInfNF[ I+1 , 4 ])
				hbCte_Texto_Hpdf( ::oPdfPage, 300 , ::nLinhaPdf-nLinha-2 , 353, Nil, "NOTA FISCAL" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
				Try
					If Val(::aRem[ "CNPJ" ]) > 0
						hbCte_Texto_Hpdf( ::oPdfPage, 345 , ::nLinhaPdf-nLinha , 535, Nil, TRANSF(::aRem[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
					Endif
				Catch
					Try
						If Val(::aRem[ "CPF" ]) > 0
							hbCte_Texto_Hpdf( ::oPdfPage, 345 , ::nLinhaPdf-nLinha , 535, Nil, TRANSF(::aRem[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
						Endif
					Catch
					End
				End
				hbCte_Texto_Hpdf( ::oPdfPage, 535 , ::nLinhaPdf-nLinha , 590, Nil, ::aInfNF[ I+1 , 4 ]+'/'+::aInfNF[ I+1 , 5 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
			Endif
		Catch
		End

		nLinha+=10

	Next

Endif

If Len(::aInfOutros) > 0

	nLinha:=536
	I:=0

	For I = 1 To Len(::aInfOutros) Step 2

	 	Try

			If ::aInfOutros[ I , 1 ] = '00'
				cOutros:='DECLARAÇÃO'
			ElseIf ::aInfOutros[ I , 1 ] = '10'
				cOutros:='DUTOVIÁRIO'
			ElseIf ::aInfOutros[ I , 1 ] = '99'
				cOutros:=::aInfOutros[ I , 2 ]
			Endif

			hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-nLinha , 240, Nil, cOutros , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
			Try
				If Val(::aRem[ "CNPJ" ]) > 0
		 			hbCte_Texto_Hpdf( ::oPdfPage, 170 , ::nLinhaPdf-nLinha , 240, Nil, TRANSF(::aRem[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
				Endif
			Catch
				Try
					If Val(::aRem[ "CPF" ]) > 0
			 			hbCte_Texto_Hpdf( ::oPdfPage, 170 , ::nLinhaPdf-nLinha , 240, Nil, TRANSF(::aRem[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
					Endif
				Catch
				End
			End
			hbCte_Texto_Hpdf( ::oPdfPage, 240 , ::nLinhaPdf-nLinha , 295, Nil, ::aInfOutros[ I , 3 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )

		Catch
		End

	 	Try

			If ::aInfOutros[ I+1 , 1 ] = '00'
				cOutros:='DECLARAÇÃO'
			ElseIf ::aInfOutros[ I+1 , 1 ] = '10'
				cOutros:='DUTOVIÁRIO'
			ElseIf ::aInfOutros[ I+1 , 1 ] = '99'
				cOutros:=::aInfOutros[ I+1 , 2 ]
			Endif

			hbCte_Texto_Hpdf( ::oPdfPage, 300 , ::nLinhaPdf-nLinha , 535, Nil, cOutros , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
			Try
				If Val(::aRem[ "CNPJ" ]) > 0
					hbCte_Texto_Hpdf( ::oPdfPage, 465 , ::nLinhaPdf-nLinha , 535, Nil, TRANSF(::aRem[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
				Endif
			Catch
				Try
					If Val(::aRem[ "CPF" ]) > 0
						hbCte_Texto_Hpdf( ::oPdfPage, 465 , ::nLinhaPdf-nLinha , 535, Nil, TRANSF(::aRem[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
					Endif
				Catch
				End
			End
			hbCte_Texto_Hpdf( ::oPdfPage, 535 , ::nLinhaPdf-nLinha , 590, Nil, ::aInfOutros[ I+1 , 3 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )

		Catch
		End

		nLinha+=10

	Next

Endif

// Box das Observações Gerais
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-638 , 590 , 009 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 003 , ::nLinhaPdf-629 , 590, Nil, "Observações Gerais" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalho, 8 )
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-668 , 590 , 030 , ::nLarguraBox )
/*
::aCompl[ "xObs" ]:=Upper('Este documento tem por objetivo a definição das especificações e critérios técnicos necessários' +;
' para a integração entre os Portais das Secretarias de Fazendas dos Estados e os sistemas de' +;
' informações das empresas emissoras de Conhecimento de Transporte eletrônico - CT-e.')
*/
Try

   If Len(::aCompl) > 0
      SEPARA(::aCompl[ "xObs" ],120,120,120,120,,,,,,,,,,,,,,,,,@aObserv)
   Endif

   If !Empty(::cAdFisco)
      SEPARA(::cAdFisco[1],120,120,120,120,,,,,,,,,,,,,,,,,@aObserv)
   Endif

   If ::alocEnt[ 'xNome' ] != Nil

      cEntrega:='Local de Entrega : '
      If ::alocEnt["CNPJ"] != Nil
         cEntrega+='CNPJ:'+::alocEnt["CNPJ"]
      Endif
      If ::alocEnt["CNPJ"] != Nil
         cEntrega+='CPF:'+::alocEnt["CPF"]
      Endif
      If ::alocEnt["xNome"] != Nil
         cEntrega+=' - '+::alocEnt["xNome"]
      Endif
      If ::alocEnt["xLgr"] != Nil
         cEntrega+=' - '+::alocEnt["xLgr"]
      Endif
      If ::alocEnt["nro"] != Nil
         cEntrega+=','+::alocEnt["nro"]
      Endif
      If ::alocEnt["xCpl"] != Nil
         cEntrega+=::alocEnt["xCpl"]
      Endif
      If ::alocEnt["xBairro"] != Nil
         cEntrega+=::alocEnt["xBairro"]
      Endif
      If ::alocEnt["xMun"] != Nil
         cEntrega+=::alocEnt["xMun"]
      Endif
      If ::alocEnt["UF"] != Nil
         cEntrega+=::alocEnt["UF"]
      Endif

      SEPARA(cEntrega,120,120,120,120,,,,,,,,,,,,,,,,,@aObserv)

   EndIf

Catch
End

nLinha:=638
I:=0

For I = 1 To Len(aObserv)

	hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-nLinha , 590, Nil, aObserv[I] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
	nLinha+=10

Next
/*
If ::vTotTrib != Nil
	hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-675 , 590, Nil, 'Valor aproximado total de tributos federais, estaduais e municipais conf. Disposto na Lei nº 12741/12 : R$ '+Alltrim(Trans( Val(::vTotTrib) , '@E 999,999.99' )) , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
Endif
*/
// Box dos DADOS ESPECÍFICOS DO MODAL RODOVIÁRIO - CARGA FRACIONADA
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-680 , 590 , 009 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 003 , ::nLinhaPdf-671 , 590, Nil, "DADOS ESPECÍFICOS DO MODAL RODOVIÁRIO - CARGA FRACIONADA" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalho, 8 )
//Box do RNTRC Da Empresa
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-698 , 140 , 018 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-680 , 143, Nil, "RNTRC Da Empresa" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-688 , 143, Nil, ::aRodo[ "RNTRC" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
//Box do CIOT
hbCte_Box_Hpdf( ::oPdfPage,  143 , ::nLinhaPdf-698 , 070 , 018 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 145 , ::nLinhaPdf-680 , 213, Nil, "CIOT" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 145 , ::nLinhaPdf-688 , 213, Nil, ::aRodo[ "CIOT" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
//Box do Lotação
hbCte_Box_Hpdf( ::oPdfPage,  213 , ::nLinhaPdf-698 , 030 , 018 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 215 , ::nLinhaPdf-680 , 243, Nil, "Lotação" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
Try
	hbCte_Texto_Hpdf( ::oPdfPage, 215 , ::nLinhaPdf-688 , 243, Nil, Iif( Val(::aRodo[ "lota" ]) = 0,'Não','Sim') , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
Catch
End
//Box do Data Prevista de Entrega
hbCte_Box_Hpdf( ::oPdfPage,  243 , ::nLinhaPdf-698 , 115 , 018 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 245 , ::nLinhaPdf-680 , 358, Nil, "Data Prevista de Entrega" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
Try
	hbCte_Texto_Hpdf( ::oPdfPage, 245 , ::nLinhaPdf-688 , 358, Nil, SUBS(::aRodo[ "dPrev" ],9,2)+"/"+SUBS(::aRodo[ "dPrev" ],6,2)+"/"+SUBS(::aRodo[ "dPrev" ],1,4) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
Catch
End
//Box da Legislação
hbCte_Box_Hpdf( ::oPdfPage,  358 , ::nLinhaPdf-698 , 235 , 018 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 360 , ::nLinhaPdf-680 , 590, Nil, "ESTE CONHECIMENTO DE TRANSPORTE ATENDE" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 360 , ::nLinhaPdf-688 , 590, Nil, "À LEGISLAÇÃO DE TRANSPORTE RODOVIÁRIO EM VIGOR" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalho, 8 )

// Box da IDENTIFICAÇÃO DO CONJUNTO TRANSPORTADOR
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-706 , 260 , 008 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 003 , ::nLinhaPdf-698 , 260, Nil, "IDENTIFICAÇÃO DO CONJUNTO TRANSPORTADOR" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalhoBold, 6 )
// Box das INFORMAÇÕES RELATIVAS AO VALE PEDÁGIO
hbCte_Box_Hpdf( ::oPdfPage,  263 , ::nLinhaPdf-706 , 330 , 008 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 263 , ::nLinhaPdf-698 , 590, Nil, "INFORMAÇÕES RELATIVAS AO VALE PEDÁGIO" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalhoBold, 6 )

// Box do Tipo
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-714 , 055 , 008 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-707 , 055, Nil, "TIPO" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
// Box do PLACA
hbCte_Box_Hpdf( ::oPdfPage,  058 , ::nLinhaPdf-714 , 055 , 008 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 060 , ::nLinhaPdf-707 , 115, Nil, "PLACA" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
// Box da UF
hbCte_Box_Hpdf( ::oPdfPage,  113 , ::nLinhaPdf-714 , 020 , 008 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 115 , ::nLinhaPdf-707 , 133, Nil, "UF" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
// Box da RNTRC
hbCte_Box_Hpdf( ::oPdfPage,  133 , ::nLinhaPdf-714 , 130 , 008 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 135 , ::nLinhaPdf-707 , 260, Nil, "RNTRC" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
// Box dos Dados acima
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-736 , 260 , 022 , ::nLarguraBox )
nLinha:=714
I:=0
For I = 1 To Len(::aVeiculo)

   Try
      hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-nLinha , 055, Nil, aTipoCar[Val(::aVeiculo[ I , 10 ])+1] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 6 )
   Catch
   End

   Try
      hbCte_Texto_Hpdf( ::oPdfPage, 060 , ::nLinhaPdf-nlinha , 115, Nil, ::aVeiculo[ I , 03 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 6 )
   Catch
   End

   Try
      hbCte_Texto_Hpdf( ::oPdfPage, 115 , ::nLinhaPdf-nlinha , 133, Nil, ::aVeiculo[ I , 11 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 6 )
   Catch
   End

   Try
  	   hbCte_Texto_Hpdf( ::oPdfPage, 135 , ::nLinhaPdf-nlinha , 260, Nil, ::aProp[ "RNTRC" ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 6 )
  	Catch
		Try
  		   hbCte_Texto_Hpdf( ::oPdfPage, 135 , ::nLinhaPdf-nlinha , 260, Nil, ::aRodo[ "RNTRC" ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 6 )
  		Catch
		End
	End
	nLinha+=05

Next

// Box do CNPJ EMPRESA FORNECEDORA
hbCte_Box_Hpdf( ::oPdfPage,  263 , ::nLinhaPdf-736 , 110 , 030 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 265 , ::nLinhaPdf-707 , 373, Nil, "CNPJ EMPRESA FORNECEDORA" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
hbCte_Texto_Hpdf( ::oPdfPage, 265 , ::nLinhaPdf-717 , 373, Nil, ::aValePed[ "CNPJForn" ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
// Box do CNPJ EMPRESA FORNECEDORA
hbCte_Box_Hpdf( ::oPdfPage,  373 , ::nLinhaPdf-736 , 110 , 030 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 375 , ::nLinhaPdf-707 , 483, Nil, "NÚMERO DO COMPROVANTE" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
hbCte_Texto_Hpdf( ::oPdfPage, 375 , ::nLinhaPdf-717 , 483, Nil, ::aValePed[ "nCompra" ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
// Box do CNPJ RESPONSAVEL PAGAMENTO
hbCte_Box_Hpdf( ::oPdfPage,  483 , ::nLinhaPdf-736 , 110 , 030 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 485 , ::nLinhaPdf-707 , 590, Nil, "CNPJ RESPONSAVEL PAGAMENTO" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
hbCte_Texto_Hpdf( ::oPdfPage, 375 , ::nLinhaPdf-717 , 483, Nil, ::aValePed[ "CNPJPg" ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
// Box do Nome do Motorista
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-744 , 260 , 008 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-737 , 050, Nil, "MOTORISTA:" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
hbCte_Texto_Hpdf( ::oPdfPage, 060 , ::nLinhaPdf-737 , 260, Nil, ::aMoto[ "xNome" ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 6 )
// Box do CPF do Motorista
hbCte_Box_Hpdf( ::oPdfPage, 263 , ::nLinhaPdf-744 , 120 , 008 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 265 , ::nLinhaPdf-737 , 325, Nil, "CPF MOTORISTA:" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
Try
	hbCte_Texto_Hpdf( ::oPdfPage, 330 , ::nLinhaPdf-737 , 383, Nil, TRANS( ::aMoto[ "CPF" ] , "@R 999.999.999-99" ) , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 6 )
Catch
End
// Box do IDENT. LACRE EM TRANSP:
hbCte_Box_Hpdf( ::oPdfPage, 383 , ::nLinhaPdf-744 , 210 , 008 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 385 , ::nLinhaPdf-737 , 495, Nil, "IDENT. LACRE EM TRANSP." , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
hbCte_Texto_Hpdf( ::oPdfPage, 500 , ::nLinhaPdf-737 , 590, Nil, ::aRodo[ "nLacre" ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 6 )

// Box do USO EXCLUSIVO DO EMISSOR DO CT-E
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-752 , 380 , 008 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-745 , 385, Nil, "USO EXCLUSIVO DO EMISSOR DO CT-E" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalho, 6 )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-753 , 385, Nil, ::aObsCont[ "xTexto" ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )

// Box do RESERVADO AO FISCO
hbCte_Box_Hpdf( ::oPdfPage,  383 , ::nLinhaPdf-752 , 210 , 008 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 385 , ::nLinhaPdf-745 , 495, Nil, "RESERVADO AO FISCO" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalho, 6 )

hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-762 , 380 , 010 , ::nLarguraBox )
hbCte_Box_Hpdf( ::oPdfPage,  383 , ::nLinhaPdf-762 , 210 , 010 , ::nLarguraBox )

// Data e Desenvolvedor da Impressao
hbCte_Texto_Hpdf( ::oPdfPage, 005, ::nLinhaPdf-763 , 200, Nil , "DATA E HORA DA IMPRESSÃO : "+DTOC(DATE())+' - '+TIME(), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 4 )
hbCte_Texto_Hpdf( ::oPdfPage, 500, ::nLinhaPdf-763 , 593, Nil , "VesSystem" , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalhoBold, 4 )

// linha tracejada
HPDF_Page_SetDash(::oPdfPage, DASH_MODE3, 4, 0)
HPDF_Page_SetLineWidth( ::oPdfPage , 0.5 )
HPDF_Page_MoveTo( ::oPdfPage , 003 , ::nLinhaPdf-769)
HPDF_Page_LineTo( ::oPdfPage , 595 , ::nLinhaPdf-769)
HPDF_Page_Stroke( ::oPdfPage )
HPDF_Page_SetDash(::oPdfPage, NIL, 0, 0)

cMensa:='DECLARO QUE RECEBI OS VOLUMES DESTE CONHECIMENTO EM PERFEITO ESTADO PELO QUE DOU POR CUMPRIDO O PRESENTE CONTRATO DE TRANSPORTE'
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-782 , 590 , 009 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 003 , ::nLinhaPdf-773 , 590, Nil, cMensa , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalhoBold, 7 )
// Box do Nome
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-807 , 160 , 025 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-782 , 163, Nil, "Nome" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
// Box do RG
hbCte_Box_Hpdf( ::oPdfPage,  003 , ::nLinhaPdf-832 , 160 , 025 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-807 , 163, Nil, "RG" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
// Box da ASSINATURA / CARIMBO
hbCte_Box_Hpdf( ::oPdfPage,  163 , ::nLinhaPdf-832 , 160 , 050 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 165 , ::nLinhaPdf-822 , 323, Nil, "ASSINATURA / CARIMBO" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalho, 8 )
// Box da CHEGADA DATA/HORA
hbCte_Box_Hpdf( ::oPdfPage,  323 , ::nLinhaPdf-807 , 120 , 025 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 325 , ::nLinhaPdf-782 , 443, Nil, "CHEGADA DATA/HORA" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalho, 6 )
// Box da SAÍDA DATA/HORA
hbCte_Box_Hpdf( ::oPdfPage,  323 , ::nLinhaPdf-832 , 120 , 025 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 325 , ::nLinhaPdf-807 , 443, Nil, "SAÍDA DATA/HORA" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalho, 6 )
// Box do Número da CTe / Série
hbCte_Box_Hpdf( ::oPdfPage,  443 , ::nLinhaPdf-807 , 150 , 025 , ::nLarguraBox )
hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-782 , 593, Nil, "Número da CTe / Série" , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalho, 8 )
hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-792 , 593, Nil, ::aIde[ "nCT" ]+' / '+::aIde[ "serie" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10)
// Box do nome do emitente
hbCte_Box_Hpdf( ::oPdfPage,  443 , ::nLinhaPdf-832 , 150 , 025 , ::nLarguraBox )
// Razao Social do Emitente

If Len(Alltrim(::aEmit[ "xNome" ])) <= 25

   hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-813 , 593, Nil, Alltrim(::aEmit[ "xNome" ]) , HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 8 )

ElseIf Len(Alltrim(::aEmit[ "xNome" ])) > 25 .And. Len(Alltrim(::aEmit[ "xNome" ])) <= 30

   SEPARA(Alltrim(::aEmit[ "xNome" ]),020,020,020,020,020,020,,,,,,,,,,,,,,,@aRazao)
   If Len(aRazao) = 1
      hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-813 , 593, Nil, aRazao[ 1 ] , HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 8 )
   ElseIf Len(aRazao) = 2
      hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-813 , 593, Nil, aRazao[ 1 ] , HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 8 )
      hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-820 , 593, Nil, aRazao[ 2 ] , HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 8 )
   ElseIf Len(aRazao) = 3
      hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-808 , 593, Nil, aRazao[ 1 ] , HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 8 )
      hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-815 , 593, Nil, aRazao[ 2 ] , HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 8 )
      hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-822 , 593, Nil, aRazao[ 3 ] , HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 8 )
   Endif

ElseIf Len(Alltrim(::aEmit[ "xNome" ])) > 30

   SEPARA(Alltrim(::aEmit[ "xNome" ]),030,030,030,030,030,030,,,,,,,,,,,,,,,@aRazao)
   If Len(aRazao) = 1
      hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-813 , 593, Nil, aRazao[ 1 ] , HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 6 )
   ElseIf Len(aRazao) = 2
      hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-813 , 593, Nil, aRazao[ 1 ] , HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 6 )
      hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-820 , 593, Nil, aRazao[ 2 ] , HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 6 )
   ElseIf Len(aRazao) = 3
      hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-808 , 593, Nil, aRazao[ 1 ] , HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 6 )
      hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-815 , 593, Nil, aRazao[ 2 ] , HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 6 )
      hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-822 , 593, Nil, aRazao[ 3 ] , HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 6 )
   Endif

Endif

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

