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

CREATE CLASS hbCteDacte

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

   DATA cFile
   DATA ohbNFe
   DATA lValorDesc INIT .F.
   DATA nCasasQtd INIT 2
   DATA nCasasVUn INIT 2
   DATA aRetorno
   DATA PastaPdf

   ENDCLASS

METHOD Execute() CLASS hbCteDacte

   IF ::lLaser <> Nil
      ::lLaser := .T.
   ENDIF
   IF ::cFonteNFe = Nil
      ::cFonteNFe := 'Times'
   ENDIF

   ::aRetorno := hb_Hash()

   IF ! File( ::cArquivoXML )
      ::aRetorno[ 'OK' ]      := .F.
      ::aRetorno[ 'MsgErro' ] := 'Arquivo não encontrado ! ' + ::cArquivoXML
      RETURN(::aRetorno)
   ENDIF

   ::cXML   := MEMOREAD( ::cArquivoXML )
   ::cChave := SUBS( ::cXML, AT( 'Id=', ::cXML ) + 3 + 4, 44 )

   IF !::buscaDadosXML()
      RETURN ::aRetorno
   ENDIF

   ::lPaisagem          := .F.
   ::nItens1Folha       := 45 // 48 inicial pode aumentar variante a servicos etc...   && anderson camilo diminuiu o numero de itens o original era 48
   ::nItensDemaisFolhas := 105
   ::nLarguraDescricao  := 39
   ::nLarguraCodigo     := 13

   IF ::lImprimir
   	IF ! ::GeraPdf()
      	::aRetorno[ 'OK' ]      := .F.
      	::aRetorno[ 'MsgErro' ] := 'Problema ao gerar o PDF !'
      	RETURN ::aRetorno
   	ENDIF
	ENDIF

   ::aRetorno[ 'OK' ] := .T.

   RETURN ::aRetorno

METHOD BuscaDadosXML() CLASS hbCteDacte

   LOCAL cIde, cCompl , cEmit, cRem , cinfNF , cinfNFe , cinfOutros , cDest , cLocEnt , cPrest , cComp, cImp
   LOCAL cIcms00 , cIcms20 , cIcms45 , cIcms60 , cIcms90 , cIcmsUF , cIcmsSN
   LOCAL cinfCTeNorm , cInfCarga , cSeg , cRodo , cVeiculo , cProtocolo , cExped
   LOCAL cReceb , cInfQ , cValePed , cMoto , cProp
   LOCAL nInicio:=0

   cIde := XmlNodeInvertido( "ide", ::cXML )
   ::aIde := hb_Hash()
   ::aIde[ "cUF" ]        := XmlNodeInvertido( "cUF", cIde )
   ::aIde[ "cCT" ]        := XmlNodeInvertido( "cCT", cIde )
   ::aIde[ "CFOP" ]       := XmlNodeInvertido( "CFOP", cIde )
   ::aIde[ "natOp" ]      := XmlNodeInvertido( "natOp", cIde )
   ::aIde[ "forPag" ]     := XmlNodeInvertido( "forPag", cIde )
   ::aIde[ "mod" ]        := XmlNodeInvertido( "mod", cIde )
   ::aIde[ "serie" ]      := XmlNodeInvertido( "serie", cIde )
   ::aIde[ "nCT" ]        := XmlNodeInvertido( "nCT", cIde )
   ::aIde[ "dhEmi" ]      := XmlNodeInvertido( "dhEmi", cIde )
   ::aIde[ "tpImp" ]      := XmlNodeInvertido( "tpImp", cIde )
   ::aIde[ "tpEmis" ]     := XmlNodeInvertido( "tpEmis", cIde )
   ::aIde[ "cDV" ]        := XmlNodeInvertido( "cDV", cIde )
   ::aIde[ "tpAmb" ]      := XmlNodeInvertido( "tpAmb", cIde )  // 1 - retrato 2-paisagem
   ::aIde[ "tpCTe" ]      := XmlNodeInvertido( "tpCTe", cIde )
   ::aIde[ "procEmi" ]    := XmlNodeInvertido( "procEmi", cIde )
   ::aIde[ "verProc" ]    := XmlNodeInvertido( "verProc", cIde )  // 1- producao 2-homologacao
   ::aIde[ "cMunEnv" ]    := XmlNodeInvertido( "cMunEnv", cIde ) // finalidade 1-normal/2-complementar 3- de ajuste
   ::aIde[ "xMunEnv" ]    := XmlNodeInvertido( "xMunEnv", cIde ) //0 - emissão de NF-e com aplicativo do contribuinte 1 - emissão de NF-e avulsa pelo Fisco 2 - emissão de NF-e avulsa pelo contribuinte com seu certificado digital, através do site do Fisco 3- emissão NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.
   ::aIde[ "UFEnv" ]      := XmlNodeInvertido( "UFEnv", cIde ) // versao sistema
   ::aIde[ "modal" ]      := XmlNodeInvertido( "modal", cIde ) // versao sistema
   ::aIde[ "tpServ" ]     := XmlNodeInvertido( "tpServ", cIde ) // versao sistema
   ::aIde[ "cMunIni" ]    := XmlNodeInvertido( "cMunIni", cIde ) // versao sistema
   ::aIde[ "xMunIni" ]    := XmlNodeInvertido( "xMunIni", cIde ) // versao sistema
   ::aIde[ "UFIni" ]      := XmlNodeInvertido( "UFIni", cIde ) // versao sistema
   ::aIde[ "cMunFim" ]    := XmlNodeInvertido( "cMunFim", cIde ) // versao sistema
   ::aIde[ "xMunFim" ]    := XmlNodeInvertido( "xMunFim", cIde ) // versao sistema
   ::aIde[ "UFFim" ]      := XmlNodeInvertido( "UFFim", cIde ) // versao sistema
   ::aIde[ "retira" ]     := XmlNodeInvertido( "retira", cIde ) // versao sistema
   ::aIde[ "xDetRetira" ] := XmlNodeInvertido( "xDetRetira", cIde ) // versao sistema

   cIde := XmlNodeInvertido( "toma03", cIde )
   ::aIde[ "toma" ] := XmlNodeInvertido( "toma", cIde ) // versao sistema

   cCompl := XmlNodeInvertido( "compl", ::cXML )
   ::aCompl := hb_Hash()
   ::aCompl[ "xObs" ] := XmlNodeInvertido( "xObs", cCompl )

   ::aObsCont := hb_Hash()
   ::aObsCont[ "xTexto" ] := XmlNodeInvertido( "xTexto", cCompl )

   cEmit := XmlNodeInvertido( "emit", ::cXML )
   ::aEmit := hb_Hash()
   ::aEmit[ "CNPJ" ]  := XmlNodeInvertido( "CNPJ", cEmit )
   ::aEmit[ "IE" ]    := XmlNodeInvertido( "IE", cEmit ) // avulso pelo fisco
   ::aEmit[ "xNome" ] := XmlToSTring( XmlNodeInvertido( "xNome", cEmit ) )
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
   ::cTelefoneEmitente  := SoNumeros( XmlNode( cEmit, "fone" ) )
   IF ! Empty( ::cTelefoneEmitente )
      ::cTelefoneEmitente := Transform( ::cTelefoneEmitente, "@E (99) 9999-9999" )
   ENDIF

   //   ::cSiteEmitente := ::ohbNFe:cSiteEmitente
   //   ::cEmailEmitente := ::ohbNFe:cEmailEmitente

   cRem := XmlNodeInvertido( "rem", ::cXML )
   ::aRem := hb_Hash()
   ::aRem[ "CNPJ" ]    := XmlNodeInvertido( "CNPJ", cRem )
   ::aRem[ "CPF" ]     := XmlNodeInvertido( "CPF", cRem )
   ::aRem[ "IE" ]      := XmlNodeInvertido( "IE", cRem ) // avulso pelo fisco
   ::aRem[ "xNome" ]   := XmlToString( XmlNodeInvertido( "xNome", cRem ) )
   ::aRem[ "xFant" ]   := XmlNodeInvertido( "xFant", cRem )
   ::aRem[ "fone" ]    := XmlNodeInvertido( "fone", cRem )
   ::aRem[ "xLgr" ]    := XmlNodeInvertido( "xLgr", cRem )
   ::aRem[ "nro" ]     := XmlNodeInvertido( "nro", cRem )
   ::aRem[ "xCpl" ]    := XmlNodeInvertido( "xCpl", cRem )
   ::aRem[ "xBairro" ] := XmlNodeInvertido( "xBairro", cRem )
   ::aRem[ "cMun" ]    := XmlNodeInvertido( "cMun", cRem )
   ::aRem[ "xMun" ]    := XmlNodeInvertido( "xMun", cRem )
   ::aRem[ "CEP" ]     := XmlNodeInvertido( "CEP", cRem )
   ::aRem[ "UF" ]      := XmlNodeInvertido( "UF", cRem )
   ::aRem[ "cPais" ]   := XmlNodeInvertido( "cPais", cRem )
   ::aRem[ "xPais" ]   := XmlNodeInvertido( "xPais", cRem ) // NFE 2.0

   cRem := XmlNodeInvertido( "infDoc", ::cXML ) // versao 2.0

	::ainfNF := {}
	nInicio  := 0
	DO WHILE .T.
	   cinfNF := XmlNodeInvertido( "infNF", cRem , , @nInicio )
		IF Empty( cinfNF )
			EXIT
		ENDIF
		Aadd(	::ainfNF,{ XmlNodeInvertido( "nRoma", cinfNF ) , +;
							  XmlNodeInvertido( "nPed", cinfNF ) , +;
							  XmlNodeInvertido( "mod", cinfNF ) , +;
							  XmlNodeInvertido( "serie", cinfNF ) , +;
						     XmlNodeInvertido( "nDoc", cinfNF ) , +;
							  XmlNodeInvertido( "dEmi", cinfNF ) , +;
						     XmlNodeInvertido( "vBC", cinfNF ) , +;
							  XmlNodeInvertido( "vICMS", cinfNF ) , +;
							  XmlNodeInvertido( "vBCST", cinfNF ) , +;
							  XmlNodeInvertido( "vST", cinfNF ) , +;
							  XmlNodeInvertido( "vProd", cinfNF ) , +;
							  XmlNodeInvertido( "vNF", cinfNF ) , +;
							  XmlNodeInvertido( "nCFOP", cinfNF ) , +;
							  XmlNodeInvertido( "nPeso", cinfNF ) , +;
							  XmlNodeInvertido( "PIN", cinfNF ) } )
	ENDDO

	::ainfNFe := {}
	nInicio   := 0
//  	cRem := XmlNodeInvertido( "rem", ::cXML ) versao 1.04
  	cRem := XmlNodeInvertido( "infDoc", ::cXML ) // versao 2.0
	DO WHILE .T.
   	cinfNFe := XmlNodeInvertido( "infNFe", cRem , , @nInicio )
		IF Empty( cinfNFe )
			EXIT
		ENDIF
		Aadd( ::ainfNFe , { XmlNodeInvertido( "chave", cinfNFe ) , +;
								  XmlNodeInvertido( "PIN", cinfNFe ) } )
	ENDDO

	::ainfOutros := {}
	nInicio      := 0
//  	cRem := XmlNodeInvertido("rem", ::cXML ) versao 1.04
  	cRem := XmlNodeInvertido( "infDoc", ::cXML ) // versao 2.0
	DO WHILE .T.
   	cinfOutros := XmlNodeInvertido( "infOutros", cRem , , @nInicio )
		IF Empty( cinfOutros )
			EXIT
		ENDIF
		Aadd( ::ainfOutros , { XmlNodeInvertido( "tpDoc", cinfOutros ) , +;
									  XmlNodeInvertido( "descOutros", cinfOutros ) , +;
									  XmlNodeInvertido( "nDoc", cinfOutros ) , +;
									  XmlNodeInvertido( "dEmi", cinfOutros ) , +;
									  XmlNodeInvertido( "vDocFisc", cinfOutros ) } )
	ENDDO

   cDest := XmlNodeInvertido( "dest", ::cXML )
      ::aDest := hb_Hash()
      ::aDest[ "CNPJ" ] := XmlNodeInvertido("CNPJ", cDest )
      ::aDest[ "CPF" ] := XmlNodeInvertido("CPF", cDest )
      ::aDest[ "IE" ] := XmlNodeInvertido("IE", cDest )
      ::aDest[ "xNome" ] := XmlToString( XmlNodeInvertido("xNome", cDest ) )
      ::aDest[ "fone" ] := XmlToString( XmlNodeInvertido("fone", cDest ) )
      ::aDest[ "ISUF" ] := XmlToString( XmlNodeInvertido("ISUF", cDest ) )
      ::aDest[ "email" ] := XmlToString( XmlNodeInvertido("email", cDest ) )

   cDest := XmlNodeInvertido( "enderDest", cDest )
      ::aDest[ "xLgr" ]    := XmlNodeInvertido( "xLgr", cDest )
      ::aDest[ "nro" ]     := XmlNodeInvertido( "nro", cDest )
      ::aDest[ "xCpl" ]    := XmlNodeInvertido( "xCpl", cDest )
      ::aDest[ "xBairro" ] := XmlNodeInvertido( "xBairro", cDest )
      ::aDest[ "cMun" ]    := XmlNodeInvertido( "cMun", cDest )
      ::aDest[ "xMun" ]    := XmlNodeInvertido( "xMun", cDest )
      ::aDest[ "UF" ]      := XmlNodeInvertido( "UF", cDest )
      ::aDest[ "CEP" ]     := XmlNodeInvertido( "CEP", cDest )
      ::aDest[ "cPais" ]   := XmlNodeInvertido( "cPais", cDest )
      ::aDest[ "xPais" ]   := XmlNodeInvertido( "xPais", cDest )

   clocEnt := XmlNodeInvertido( "locEnt", cDest )
      ::alocEnt := hb_Hash()
      ::alocEnt[ "CNPJ" ]    := XmlNodeInvertido( "CNPJ", clocEnt )
      ::alocEnt[ "CPF" ]     := XmlNodeInvertido( "CPF", clocEnt )
      ::alocEnt[ "xNome" ]   := XmlNodeInvertido( "xNome", clocEnt )
      ::alocEnt[ "xLgr" ]    := XmlNodeInvertido( "xLgr", clocEnt )
      ::alocEnt[ "nro"]      := XmlNodeInvertido( "nro", clocEnt )
      ::alocEnt[ "xCpl" ]    := XmlNodeInvertido( "xCpl", clocEnt )
      ::alocEnt[ "xBairro" ] := XmlNodeInvertido( "xBairro", clocEnt )
      ::alocEnt[ "xMun" ]    := XmlNodeInvertido( "xMun", clocEnt )
      ::alocEnt[ "UF" ]      := XmlNodeInvertido( "UF", clocEnt )

   cExped := XmlNodeInvertido("exped", ::cXML )
      ::aExped := hb_Hash()
      ::aExped[ "CNPJ" ]  := XmlNodeInvertido( "CNPJ", cExped )
      ::aExped[ "CPF" ]   := XmlNodeInvertido( "CPF", cExped )
      ::aExped[ "IE" ]    := XmlNodeInvertido( "IE", cExped )
      ::aExped[ "xNome" ] := XmlToString( XmlNodeInvertido( "xNome", cExped ) )
      ::aExped[ "fone" ]  := XmlToString( XmlNodeInvertido( "fone", cExped ) )
      ::aExped[ "email" ] := XmlToString( XmlNodeInvertido( "email", cExped ) )

   cExped := XmlNodeInvertido( "enderExped", cExped )
      ::aExped[ "xLgr" ]    := XmlNodeInvertido( "xLgr", cExped )
      ::aExped[ "nro" ]     := XmlNodeInvertido( "nro", cExped )
      ::aExped[ "xCpl" ]    := XmlNodeInvertido( "xCpl", cExped )
      ::aExped[ "xBairro" ] := XmlNodeInvertido( "xBairro", cExped )
      ::aExped[ "cMun" ]    := XmlNodeInvertido( "cMun", cExped )
      ::aExped[ "xMun" ]    := XmlNodeInvertido( "xMun", cExped )
      ::aExped[ "UF" ]      := XmlNodeInvertido( "UF", cExped )
      ::aExped[ "CEP" ]     := XmlNodeInvertido( "CEP", cExped )
      ::aExped[ "cPais" ]   := XmlNodeInvertido( "cPais", cExped )
      ::aExped[ "xPais" ]   := XmlNodeInvertido( "xPais", cExped )

   cReceb := XmlNodeInvertido( "receb", ::cXML )
      ::aReceb := hb_Hash()
      ::aReceb[ "CNPJ" ] := XmlNodeInvertido( "CNPJ", cReceb )
      ::aReceb[ "CPF" ] := XmlNodeInvertido( "CPF", cReceb )
      ::aReceb[ "IE" ] := XmlNodeInvertido( "IE", cReceb )
      ::aReceb[ "xNome" ] := XmlToString( XmlNodeInvertido( "xNome", cReceb ) )
      ::aReceb[ "fone" ] := XmlToString( XmlNodeInvertido( "fone", cReceb ) )
      ::aReceb[ "email" ] := XmlToString( XmlNodeInvertido( "email", cReceb ) )

   cReceb := XmlNodeInvertido( "enderReceb", cReceb )
      ::aReceb[ "xLgr" ]    := XmlNodeInvertido( "xLgr", cReceb )
      ::aReceb[ "nro" ]     := XmlNodeInvertido( "nro", cReceb )
      ::aReceb[ "xCpl" ]    := XmlNodeInvertido( "xCpl", cReceb )
      ::aReceb[ "xBairro" ] := XmlNodeInvertido( "xBairro", cReceb )
      ::aReceb[ "cMun" ]    := XmlNodeInvertido( "cMun", cReceb )
      ::aReceb[ "xMun" ]    := XmlNodeInvertido( "xMun", cReceb )
      ::aReceb[ "UF" ]      := XmlNodeInvertido( "UF", cReceb )
      ::aReceb[ "CEP" ]     := XmlNodeInvertido( "CEP", cReceb )
      ::aReceb[ "cPais" ]   := XmlNodeInvertido( "cPais", cReceb )
      ::aReceb[ "xPais" ]   := XmlNodeInvertido( "xPais", cReceb )

   cPrest := XmlNodeInvertido( "vPrest", ::cXML )
      ::aPrest := hb_Hash()
      ::aPrest[ "vTPrest" ] := XmlNodeInvertido( "vTPrest", cPrest )
      ::aPrest[ "vRec" ]    := XmlNodeInvertido( "vRec", cPrest )

	::aComp := {}
	nInicio := 0
  	cPrest  := XmlNodeInvertido( "vPrest", ::cXML )
   DO WHILE .T.
   	cComp := XmlNodeInvertido( "Comp", cPrest , , @nInicio )
		IF Empty( cComp )
			EXIT
		ENDIF
		Aadd( ::aComp , { XmlNodeInvertido( "xNome", cComp ) , +;
	                     XmlNodeInvertido( "vComp", cComp ) } )
	ENDDO
   cImp := XmlNodeInvertido( "imp", ::cXML )
      cIcms00 := XmlNodeInvertido( "ICMS00", cImp )
         ::aIcms00 := hb_Hash()
         ::aIcms00[ "CST" ]   := XmlNodeInvertido( "CST", cIcms00 ) // NFE 2.0
         ::aIcms00[ "vBC" ]   := XmlNodeInvertido( "vBC", cIcms00 ) // NFE 2.0
         ::aIcms00[ "pICMS" ] := XmlNodeInvertido( "pICMS", cIcms00 )
         ::aIcms00[ "vICMS" ] := XmlNodeInvertido( "vICMS", cIcms00 )
      cIcms20 := XmlNodeInvertido( "ICMS20", cImp )
         ::aIcms20 := hb_Hash()
         ::aIcms20[ "CST" ]    := XmlNodeInvertido( "CST", cIcms20 ) // NFE 2.0
         ::aIcms20[ "vBC" ]    := XmlNodeInvertido( "vBC", cIcms20 ) // NFE 2.0
         ::aIcms20[ "pRedBC" ] := XmlNodeInvertido( "pRedBC", cIcms20 ) // NFE 2.0
         ::aIcms20[ "pICMS" ]  := XmlNodeInvertido( "pICMS", cIcms20 )
         ::aIcms20[ "vICMS" ]  := XmlNodeInvertido( "vICMS", cIcms20 )
      cIcms45 := XmlNodeInvertido( "ICMS45", cImp )
         ::aIcms45 := hb_Hash()
         ::aIcms45[ "CST" ] := XmlNodeInvertido( "CST", cIcms45 ) // NFE 2.0
      cIcms60 := XmlNodeInvertido( "ICMS60", cImp )
         ::aIcms60 := hb_Hash()
         ::aIcms60[ "CST" ]        := XmlNodeInvertido( "CST", cIcms60 ) // NFE 2.0
         ::aIcms60[ "vBCSTRet" ]   := XmlNodeInvertido( "vBCSTRet", cIcms60 ) // NFE 2.0
         ::aIcms60[ "vICMSSTRet" ] := XmlNodeInvertido( "vICMSSTRet", cIcms60 ) // NFE 2.0
         ::aIcms60[ "pICMSSTRet" ] := XmlNodeInvertido( "pICMSSTRet", cIcms60 )
         ::aIcms60[ "vCred" ]      := XmlNodeInvertido( "vCred", cIcms60 )
      cIcms90 := XmlNodeInvertido("ICMS90", cImp )
         ::aIcms90 := hb_Hash()
         ::aIcms90[ "CST" ]    := XmlNodeInvertido( "CST", cIcms90 ) // NFE 2.0
         ::aIcms90[ "pRedBC" ] := XmlNodeInvertido( "pRedBC", cIcms90 ) // NFE 2.0
         ::aIcms90[ "vBC" ]    := XmlNodeInvertido( "vBC", cIcms90 ) // NFE 2.0
         ::aIcms90[ "pICMS" ]  := XmlNodeInvertido( "pICMS", cIcms90 )
         ::aIcms90[ "vICMS" ]  := XmlNodeInvertido( "vICMS", cIcms90 )
         ::aIcms90[ "vCred" ]  := XmlNodeInvertido( "vCred", cIcms90 )
      cIcmsUF := XmlNodeInvertido( "ICMSOutraUF", cImp )
         ::aIcmsUF := hb_Hash()
         ::aIcmsUF[ "CST" ] := XmlNodeInvertido( "CST", cIcmsUF ) // NFE 2.0
         ::aIcmsUF[ "pRedBCOutraUF" ] := XmlNodeInvertido( "pRedBCOutraUF", cIcmsUF ) // NFE 2.0
         ::aIcmsUF[ "vBCOutraUF" ]    := XmlNodeInvertido( "vBCOutraUF", cIcmsUF ) // NFE 2.0
         ::aIcmsUF[ "pICMSOutraUF" ]  := XmlNodeInvertido( "pICMSOutraUF", cIcmsUF )
         ::aIcmsUF[ "vICMSOutraUF" ]  := XmlNodeInvertido( "vICMSOutraUF", cIcmsUF )
      cIcmsSN := XmlNodeInvertido( "ICMSSN", cImp )
         ::aIcmsSN := hb_Hash()
         ::aIcmsSN[ "indSN" ] := XmlNodeInvertido( "indSN", cIcmsSN ) // NFE 2.0
   ::cAdFisco := XmlNodeInvertido( "infAdFisco", cImp )

	::vTotTrib  := '0'
	::vTotTrib  := XmlNodeInvertido( "vTotTrib", ::cXML )

   cinfCTeNorm := XmlNodeInvertido( "infCTeNorm", ::cXML )
   cinfCarga   := XmlNodeInvertido( "infCarga", cinfCTeNorm )
      ::aInfCarga := hb_Hash()
      ::aInfCarga[ "vCarga" ]  := XmlNodeInvertido( "vCarga", cInfCarga ) // NFE 2.0
      ::aInfCarga[ "proPred" ] := XmlNodeInvertido( "proPred", cInfCarga ) // NFE 2.0
      ::aInfCarga[ "xOutCat" ] := XmlNodeInvertido( "xOutCat", cInfCarga )

	::aInfQ := {}
	nInicio := 0
	DO WHILE .T.
   	cInfQ := XmlNodeInvertido( "infQ", cInfCarga , , @nInicio )
		IF Empty( cInfQ )
			EXIT
		ENDIF
		Aadd( ::aInfQ , { XmlNodeInvertido( "cUnid", cInfQ ), + ;
	                     XmlNodeInvertido( "tpMed", cInfQ ), + ;
	                     XmlNodeInvertido( "qCarga", cInfQ ) } )
	ENDDO

   cSeg := XmlNodeInvertido( "seg", cinfCTeNorm )
      ::aSeg := hb_Hash()
      ::aSeg[ "respSeg" ] := XmlNodeInvertido( "respSeg", cSeg ) // NFE 2.0
      ::aSeg[ "xSeg" ]    := XmlNodeInvertido( "xSeg", cSeg ) // NFE 2.0
      ::aSeg[ "nApol" ]   := XmlNodeInvertido( "nApol", cSeg ) // NFE 2.0
      ::aSeg[ "nAver" ]   := XmlNodeInvertido( "nAver", cSeg ) // NFE 2.0
      ::aSeg[ "vCarga" ]  := XmlNodeInvertido( "vCarga", cSeg ) // NFE 2.0

   cRodo := XmlNodeInvertido( "rodo", cinfCTeNorm )
      ::aRodo := hb_Hash()
      ::aRodo[ "RNTRC" ]  := XmlNodeInvertido( "RNTRC", cRodo ) // NFE 2.0
      ::aRodo[ "dPrev" ]  := XmlNodeInvertido( "dPrev", cRodo ) // NFE 2.0
      ::aRodo[ "lota" ]   := XmlNodeInvertido( "lota", cRodo ) // NFE 2.0
      ::aRodo[ "CIOT" ]   := XmlNodeInvertido( "CIOT", cRodo ) // NFE 2.0
      ::aRodo[ "nLacre" ] := XmlNodeInvertido( "nLacre", cRodo ) // NFE 2.0

   cMoto := XmlNodeInvertido( "moto", cinfCTeNorm )
      ::aMoto := hb_Hash()
	   ::aMoto[ "xNome" ] := XmlNodeInvertido( "xNome", cMoto ) // NFE 2.0
      ::aMoto[ "CPF" ]   := XmlNodeInvertido( "CPF", cMoto ) // NFE 2.0

   cValePed := XmlNodeInvertido( "valePed", cRodo )
      ::aValePed := hb_Hash()
	   ::aValePed[ "CNPJForn" ] := XmlNodeInvertido( "CNPJForn", cValePed ) // NFE 2.0
	   ::aValePed[ "nCompra" ]  := XmlNodeInvertido( "nCompra", cValePed ) // NFE 2.0
	   ::aValePed[ "CNPJPg" ]   := XmlNodeInvertido( "CNPJPg", cValePed ) // NFE 2.0

   cProp := XmlNodeInvertido( "prop", cRodo )
      ::aProp := hb_Hash()
	   ::aProp[ "CPF" ]    := XmlNodeInvertido( "CPF", cProp ) // NFE 2.0
	   ::aProp[ "CNPJ" ]   := XmlNodeInvertido( "CNPJ", cProp ) // NFE 2.0
	   ::aProp[ "RNTRC" ]  := XmlNodeInvertido( "RNTRC", cProp ) // NFE 2.0
	   ::aProp[ "xNome" ]  := XmlNodeInvertido( "xNome", cProp ) // NFE 2.0
	   ::aProp[ "IE" ]     := XmlNodeInvertido( "IE", cProp ) // NFE 2.0
	   ::aProp[ "UF" ]     := XmlNodeInvertido( "UF", cProp ) // NFE 2.0
	   ::aProp[ "tpProp" ] := XmlNodeInvertido( "tpProp", cProp ) // NFE 2.0

	::aVeiculo := {}
	nInicio    := 0
	DO WHILE .T.
   	cVeiculo := XmlNodeInvertido( "veic", cRodo , , @nInicio )
		IF Empty( cVeiculo )
			EXIT
		ENDIF
		Aadd( ::aVeiculo , { XmlNodeInvertido( "cInt", cVeiculo ) , +;
	                     XmlNodeInvertido( "RENAVAM", cVeiculo ) , +;
	                     XmlNodeInvertido( "placa", cVeiculo ) , +;
	                     XmlNodeInvertido( "tara", cVeiculo ) , +;
	                     XmlNodeInvertido( "capKG", cVeiculo ) , +;
	                     XmlNodeInvertido( "capM3", cVeiculo ) , +;
	                     XmlNodeInvertido( "tpProp", cVeiculo ) , +;
	                     XmlNodeInvertido( "tpVeic", cVeiculo ) , +;
	                     XmlNodeInvertido( "tpRod", cVeiculo ) , +;
	                     XmlNodeInvertido( "tpCar", cVeiculo ) , +;
	                     XmlNodeInvertido( "UF", cVeiculo ) } )
	ENDDO

   cProtocolo := XmlNodeInvertido( "infProt", ::cXML )
      ::aProtocolo := hb_Hash()
      ::aProtocolo[ "nProt" ]    := XmlNodeInvertido( "nProt", cProtocolo ) // NFE 2.0
      ::aProtocolo[ "dhRecbto" ] := XmlNodeInvertido( "dhRecbto", cProtocolo ) // NFE 2.0

   DO CASE
   CASE ::aIde[ 'toma' ] = '0' ; ::aToma:= ::aRem
   CASE ::aIde[ 'toma' ] = '1' ; ::aToma:= ::aExped
   CASE ::aIde[ 'toma' ] = '2' ; ::aToma:= ::aReceb
   CASE ::aIde[ 'toma' ] = '3' ; ::aToma:= ::aDest
	ENDCASE

   RETURN .T.

METHOD geraPDF() CLASS hbCteDacte

   ::oPdf := HPDF_New()
   If ::oPdf == NIL
      ::aRetorno[ 'OK' ]      := .F.
      ::aRetorno[ 'MsgErro' ] := 'Falha da criação do objeto PDF !'
      Return(.F.)
   Endif
   HPDF_SetCompressionMode( ::oPdf, HPDF_COMP_ALL )
   IF ::cFonteNFe == "Times"
      ::oPdfFontCabecalho     := HPDF_GetFont( ::oPdf, "Times-Roman", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Times-Bold", "CP1252" )
   ELSE
      ::oPdfFontCabecalho     := HPDF_GetFont( ::oPdf, "Courier", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Courier-Bold", "CP1252" )
   ENDIF

   && Inserido por Anderson Camilo em 04/04/2012

   ::cFonteCode128  := HPDF_LoadType1FontFromFile(::oPdf, 'fontes\Code128bWinLarge.afm', 'fontes\Code128bWinLarge.pfb')   && Code 128
   ::cFonteCode128F := HPDF_GetFont( ::oPdf, ::cFonteCode128, "WinAnsiEncoding" )

   // final da criacao e definicao do objeto pdf

   ::nFolha := 1

	::novaPagina()

   ::cabecalho()

   ::cFile := ::PastaPdf+::cChave+".pdf"

   HPDF_SaveToFile( ::oPdf, ::cFile )
   HPDF_Free( ::oPdf )

   RETURN .T.

METHOD novaPagina() CLASS hbCteDacte

   LOCAL nRadiano, nAngulo

   ::oPdfPage := HPDF_AddPage( ::oPdf )

   HPDF_Page_SetSize( ::oPdfPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT )

   ::nLinhaPdf := HPDF_Page_GetHeight( ::oPDFPage ) - 3     && Margem Superior
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

   LOCAL oImage
   LOCAL aModal     := { 'Rodoviário', 'Aéreo', 'Aquaviário', 'Ferroviário', 'Dutoviário' }
   LOCAL aTipoCte   := { 'Normal', 'Compl.Val', 'Anul.Val.', 'Substituto' }
   LOCAL aTipoServ  := { 'Normal', 'Subcontratação', 'Redespacho', 'Redesp. Int.'}
   LOCAL aTomador   := { 'Remetente', 'Expedidor', 'Recebedor', 'Destinatário'}
   LOCAL aPagto     := { 'Pago', 'A pagar', 'Outros'}
   LOCAL aUnid      := { 'M3', 'KG', 'TON', 'UN', 'LI', 'MMBTU'}
   LOCAL aResp      := { 'Remetente', 'Expedidor', 'Recebedor', 'Destinatário', 'Emitente do CT-e', 'Tomador de Serviço' }
   LOCAL aTipoCar   := { 'não aplicável', 'Aberta', 'Fechada/Baú', 'Granelera', 'Porta Container', 'Sider'}
   LOCAL cOutros    := ''
   LOCAL cEntrega   := ''
   LOCAL aObserv    := {}
   LOCAL cMensa
   LOCAL nLinha
   LOCAL nBase      := ''
   LOCAL nAliq      := ''
   LOCAL nValor     := ''
   LOCAL nReduc     := ''
   LOCAL nST        := ''
   LOCAL DASH_MODE3 := { 8, 7, 2, 7 }
   LOCAL I, oElement

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
   hbCte_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-107, 295, Nil, 'CNPJ/CPF:'+TRANSF( ::aEmit[ "CNPJ" ] , "@R 99.999.999/9999-99")+'       Inscr.Estadual:'+FormatIE( ::aEmit[ "IE" ], ::aEmit[ "UF" ] ) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )

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
   IF ::aProtocolo[ "nProt" ] != Nil
	   hbCte_Texto_Hpdf( ::oPdfPage, 303 , ::nLinhaPdf-143 , 468, Nil, ::aProtocolo[ "nProt" ]+' - '+SUBS(::aProtocolo[ "dhRecbto" ],9,2)+"/"+SUBS(::aProtocolo[ "dhRecbto" ],6,2)+"/"+SUBS(::aProtocolo[ "dhRecbto" ],1,4)+' '+SUBS(::aProtocolo[ "dhRecbto" ],12) , HPDF_TALIGN_CENTER , Nil, ::oPdfFontCabecalhoBold, 9 )
   ENDIF

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
   hbCte_Texto_Hpdf( ::oPdfPage, 260 , ::nLinhaPdf-233 , 295, Nil, Subs(::aRem[ "CEP" ],1,5)+'-'+Subs(::aRem[ "CEP" ],6,3) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-240 , 042, Nil, "CNPJ/CPF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   IF ! Empty( ::aRem[ "CNPJ" ] )
	   hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-241 , 150, Nil, Transform( ::aRem[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   IF ! Empty( ::aRem[ "CPF" ] )
      hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-241 , 150, Nil, Transform( ::aRem[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbCte_Texto_Hpdf( ::oPdfPage, 150 , ::nLinhaPdf-240 , 250, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbCte_Texto_Hpdf( ::oPdfPage, 245 , ::nLinhaPdf-241 , 295, Nil, FormatIE( ::aRem[ "IE" ], ::aRem[ "UF" ] ) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
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
   hbCte_Texto_Hpdf( ::oPdfPage, 555 , ::nLinhaPdf-233 , 588, Nil, Subs(::aDest[ "CEP" ],1,5)+'-'+Subs(::aDest[ "CEP" ],6,3) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbCte_Texto_Hpdf( ::oPdfPage, 305 , ::nLinhaPdf-240 , 342, Nil, "CNPJ/CPF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   IF ! Empty( ::aDest[ "CNPJ" ] )
      hbCte_Texto_Hpdf( ::oPdfPage, 342 , ::nLinhaPdf-241 , 450, Nil, TRANS(::aDest[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   IF ! Empty( ::aDest[ "CPF" ] )
      hbCte_Texto_Hpdf( ::oPdfPage, 342 , ::nLinhaPdf-241 , 450, Nil, TRANS(::aDest[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbCte_Texto_Hpdf( ::oPdfPage, 430 , ::nLinhaPdf-240 , 530, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )

   hbCte_Texto_Hpdf( ::oPdfPage, 530 , ::nLinhaPdf-241 , 595, Nil, Alltrim(::aDest[ "IE" ], ::aDest[ "UF" ] ) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbCte_Texto_Hpdf( ::oPdfPage, 305 , ::nLinhaPdf-248 , 342, Nil, "Pais" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbCte_Texto_Hpdf( ::oPdfPage, 342 , ::nLinhaPdf-249 , 450, Nil, ::aDest[ "xPais" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbCte_Texto_Hpdf( ::oPdfPage, 520 , ::nLinhaPdf-248 , 545, Nil, "FONE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   IF ! Empty( ::aDest[ "fone" ] )
      hbCte_Texto_Hpdf( ::oPdfPage, 545 , ::nLinhaPdf-249 , 595, Nil, '('+Subs(::aDest[ "fone" ],1,2)+')'+Subs(::aDest[ "fone" ],3,4)+'-'+Subs(::aDest[ "fone" ],7,4) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
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
   hbCte_Texto_Hpdf( ::oPdfPage, 245 , ::nLinhaPdf-297 , 295, Nil, Alltrim(::aExped[ "IE" ]) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
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
   hbCte_Texto_Hpdf( ::oPdfPage, 540 , ::nLinhaPdf-297 , 590, Nil, FormatIE( ::aReceb[ "IE" ], ::aReceb[ "UF" ] ) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
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

   IF ! Empty( ::aToma[ "CNPJ" ] )
      hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-338 , 150, Nil, TRANSF(::aToma[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   IF ! Empty( ::aToma[ "CPF" ] )
      hbCte_Texto_Hpdf( ::oPdfPage, 042 , ::nLinhaPdf-338 , 150, Nil, TRANSF(::aToma[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF

   hbCte_Texto_Hpdf( ::oPdfPage, 150 , ::nLinhaPdf-337 , 250, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbCte_Texto_Hpdf( ::oPdfPage, 245 , ::nLinhaPdf-338 , 295, Nil, FormatIE( ::aToma[ "IE" ], ::aToma[ "UF" ] ) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
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
   hbCte_Texto_Hpdf( ::oPdfPage, 278 , ::nLinhaPdf-389 , 370, Nil, aResp[Val(::aSeg[ "respSeg" ])+1] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
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

   nLinha := 423
   For I = 1 To Len(::aComp) Step 3
      hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-nLinha , 165, Nil, ::aComp[ I , 1 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
      hbCte_Texto_Hpdf( ::oPdfPage, 085 , ::nLinhaPdf-nlinha , 165, Nil, Trans( Val(::aComp[ I , 2 ]) , '@E 999,999.99' ) , HPDF_TALIGN_RIGHT , Nil, ::oPdfFontCabecalhoBold, 8 )

      hbCte_Texto_Hpdf( ::oPdfPage, 171 , ::nLinhaPdf-nLinha , 251, Nil, ::aComp[ I+1 ,1 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
      hbCte_Texto_Hpdf( ::oPdfPage, 251 , ::nLinhaPdf-nLinha , 330, Nil, Trans( Val(::aComp[ I+1 , 2 ]) , '@E 999,999.99' ) , HPDF_TALIGN_RIGHT , Nil, ::oPdfFontCabecalhoBold, 8 )

      hbCte_Texto_Hpdf( ::oPdfPage, 338 , ::nLinhaPdf-nLinha , 418, Nil, ::aComp[ I+2 ,1 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
      hbCte_Texto_Hpdf( ::oPdfPage, 418 , ::nLinhaPdf-nLinha , 495, Nil, Trans( Val(::aComp[ I+2 , 2 ]) , '@E 999,999.99' ) , HPDF_TALIGN_RIGHT , Nil, ::oPdfFontCabecalhoBold, 8 )
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
	   For I = 1 To Len(::aInfNFe) Step 2
         If !Empty(::aInfNFe[ I , 1 ])
		      hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-nLinha , 353, Nil, "NF-E" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
			   hbCte_Texto_Hpdf( ::oPdfPage, 050 , ::nLinhaPdf-nLinha , 240, Nil, ::aInfNFe[ I , 1 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
			   hbCte_Texto_Hpdf( ::oPdfPage, 240 , ::nLinhaPdf-nLinha , 295, Nil, Subs(::aInfNFe[ I , 1 ],23,3)+'/'+Subs(::aInfNFe[ I , 1 ],26,9) , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
		   Endif
			If !Empty(::aInfNFe[ I+1 , 1 ])
				hbCte_Texto_Hpdf( ::oPdfPage, 300 , ::nLinhaPdf-nLinha , 353, Nil, "NF-E" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
				hbCte_Texto_Hpdf( ::oPdfPage, 345 , ::nLinhaPdf-nLinha , 535, Nil, ::aInfNFe[ I+1 , 1 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
				hbCte_Texto_Hpdf( ::oPdfPage, 535 , ::nLinhaPdf-nLinha , 590, Nil, Subs(::aInfNFe[ I+1 , 1 ],23,3)+'/'+Subs(::aInfNFe[ I+1 , 1 ],26,9) , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
			Endif
		   nLinha+=10
	   Next
   Endif

   If Len(::aInfNF) > 0
      nLinha:=536
      For I = 1 To Len(::aInfNF) Step 2
	 		If !Empty(::aInfNF[ I , 4 ])
				hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-nLinha-2 , 353, Nil, "NOTA FISCAL" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
				If Val(::aRem[ "CNPJ" ]) > 0
					hbCte_Texto_Hpdf( ::oPdfPage, 050 , ::nLinhaPdf-nLinha , 240, Nil, TRANSF(::aRem[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
				Endif
				If Val(::aRem[ "CPF" ]) > 0
					hbCte_Texto_Hpdf( ::oPdfPage, 050 , ::nLinhaPdf-nLinha , 240, Nil, TRANSF(::aRem[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
				Endif
				hbCte_Texto_Hpdf( ::oPdfPage, 240 , ::nLinhaPdf-nLinha , 295, Nil, ::aInfNF[ I , 4 ]+'/'+::aInfNF[ I , 5 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
			Endif
	 		If !Empty(::aInfNF[ I+1 , 4 ])
				hbCte_Texto_Hpdf( ::oPdfPage, 300 , ::nLinhaPdf-nLinha-2 , 353, Nil, "NOTA FISCAL" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
				If Val(::aRem[ "CNPJ" ]) > 0
					hbCte_Texto_Hpdf( ::oPdfPage, 345 , ::nLinhaPdf-nLinha , 535, Nil, TRANSF(::aRem[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
				Endif
				If Val(::aRem[ "CPF" ]) > 0
					hbCte_Texto_Hpdf( ::oPdfPage, 345 , ::nLinhaPdf-nLinha , 535, Nil, TRANSF(::aRem[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
				Endif
				hbCte_Texto_Hpdf( ::oPdfPage, 535 , ::nLinhaPdf-nLinha , 590, Nil, ::aInfNF[ I+1 , 4 ]+'/'+::aInfNF[ I+1 , 5 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
			Endif
   		nLinha+=10
   	Next
   Endif
   If Len(::aInfOutros) > 0
   	nLinha:=536
   	For I = 1 To Len(::aInfOutros) Step 2
			If ::aInfOutros[ I , 1 ] = '00'
				cOutros:='DECLARAÇÃO'
			ElseIf ::aInfOutros[ I , 1 ] = '10'
				cOutros:='DUTOVIÁRIO'
			ElseIf ::aInfOutros[ I , 1 ] = '99'
				cOutros:=::aInfOutros[ I , 2 ]
			Endif
			hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-nLinha , 240, Nil, cOutros , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
			If Val(::aRem[ "CNPJ" ]) > 0
		 		hbCte_Texto_Hpdf( ::oPdfPage, 170 , ::nLinhaPdf-nLinha , 240, Nil, TRANSF(::aRem[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
			Endif
			If Val(::aRem[ "CPF" ]) > 0
				hbCte_Texto_Hpdf( ::oPdfPage, 170 , ::nLinhaPdf-nLinha , 240, Nil, TRANSF(::aRem[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
			Endif
			hbCte_Texto_Hpdf( ::oPdfPage, 240 , ::nLinhaPdf-nLinha , 295, Nil, ::aInfOutros[ I , 3 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
			If ::aInfOutros[ I+1 , 1 ] = '00'
				cOutros:='DECLARAÇÃO'
			ElseIf ::aInfOutros[ I+1 , 1 ] = '10'
				cOutros:='DUTOVIÁRIO'
			ElseIf ::aInfOutros[ I+1 , 1 ] = '99'
				cOutros:=::aInfOutros[ I+1 , 2 ]
			Endif
			hbCte_Texto_Hpdf( ::oPdfPage, 300 , ::nLinhaPdf-nLinha , 535, Nil, cOutros , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 6 )
			If Val(::aRem[ "CNPJ" ]) > 0
				hbCte_Texto_Hpdf( ::oPdfPage, 465 , ::nLinhaPdf-nLinha , 535, Nil, TRANSF(::aRem[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
			Endif
			If Val(::aRem[ "CPF" ]) > 0
				hbCte_Texto_Hpdf( ::oPdfPage, 465 , ::nLinhaPdf-nLinha , 535, Nil, TRANSF(::aRem[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
			Endif
			hbCte_Texto_Hpdf( ::oPdfPage, 535 , ::nLinhaPdf-nLinha , 590, Nil, ::aInfOutros[ I+1 , 3 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
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
   IF ! Empty( ::aCompl )
      AAdd( aObserv, ::aCompl )
   Endif
   If ! Empty( ::cAdFisco )
      AAdd( aObserv, ::cAdFisco )
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
      AAdd( aObserv, cEntrega )
   EndIf
   nLinha:=638
   FOR EACH oElement IN aObserv
      DO WHILE Len( oElement ) > 0
	      hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-nLinha , 590, Nil, Pad( oElement, 120 ), HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
         oElement := Substr( oElement, 121 )
	      nLinha += 10
      ENDDO
   NEXT
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
	hbCte_Texto_Hpdf( ::oPdfPage, 215 , ::nLinhaPdf-688 , 243, Nil, Iif( Val(::aRodo[ "lota" ]) = 0,'Não','Sim') , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
   //Box do Data Prevista de Entrega
   hbCte_Box_Hpdf( ::oPdfPage,  243 , ::nLinhaPdf-698 , 115 , 018 , ::nLarguraBox )
   hbCte_Texto_Hpdf( ::oPdfPage, 245 , ::nLinhaPdf-680 , 358, Nil, "Data Prevista de Entrega" , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalho, 8 )
	hbCte_Texto_Hpdf( ::oPdfPage, 245 , ::nLinhaPdf-688 , 358, Nil, SUBS(::aRodo[ "dPrev" ],9,2)+"/"+SUBS(::aRodo[ "dPrev" ],6,2)+"/"+SUBS(::aRodo[ "dPrev" ],1,4) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
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
   For I = 1 To Len(::aVeiculo)
      hbCte_Texto_Hpdf( ::oPdfPage, 005 , ::nLinhaPdf-nLinha , 055, Nil, aTipoCar[Val(::aVeiculo[ I , 10 ])+1] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 6 )
      hbCte_Texto_Hpdf( ::oPdfPage, 060 , ::nLinhaPdf-nlinha , 115, Nil, ::aVeiculo[ I , 03 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 6 )
      hbCte_Texto_Hpdf( ::oPdfPage, 115 , ::nLinhaPdf-nlinha , 133, Nil, ::aVeiculo[ I , 11 ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 6 )
  	   hbCte_Texto_Hpdf( ::oPdfPage, 135 , ::nLinhaPdf-nlinha , 260, Nil, ::aProp[ "RNTRC" ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 6 )
	   hbCte_Texto_Hpdf( ::oPdfPage, 135 , ::nLinhaPdf-nlinha , 260, Nil, ::aRodo[ "RNTRC" ] , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 6 )
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
   hbCte_Texto_Hpdf( ::oPdfPage, 330 , ::nLinhaPdf-737 , 383, Nil, TRANS( ::aMoto[ "CPF" ] , "@R 999.999.999-99" ) , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 6 )
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
   IF Len( ::aEmit[ "xNome" ] ) <= 40
      hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-813 , 593, Nil, Substr( ::aEmit[ "xNome" ], 1, 20 ), HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 8 )
      hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-820 , 593, Nil, Substr( ::aEmit[ "xNome" ], 21, 20 ), HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 8 )
   ELSE
      hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-808 , 593, Nil, Substr( ::aEmit[ "xNome" ], 1, 30 ), HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 6 )
      hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-815 , 593, Nil, Substr( ::aEmit[ "xNome" ], 31, 30 ), HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 6 )
      hbCte_Texto_Hpdf( ::oPdfPage, 445 , ::nLinhaPdf-822 , 593, Nil, Substr( ::aEmit[ "xNome" ], 61, 30 ), HPDF_TALIGN_CENTER , Nil , ::oPdfFontCabecalhoBold, 6 )
   ENDIF

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

   RETURN NIL

//STATIC FUNCTION hbCte_Line_Hpdf( oPdfPage2, x1, y1, x2, y2, nPen, FLAG)
//   HPDF_Page_SetLineWidth(oPdfPage2, nPen)
//   IF FLAG <> Nil
//      HPDF_Page_SetLineCap( oPdfPage2, FLAG)
//   ENDIF
//   HPDF_Page_MoveTo(oPdfPage2, x1, y1)
//   HPDF_Page_LineTo(oPdfPage2, x2, y2)
//   HPDF_Page_Stroke(oPdfPage2)
//   IF FLAG <> Nil
//      HPDF_Page_SetLineCap(oPdfPage2, HPDF_BUTT_END)
//   ENDIF
//RETURN Nil

//STATIC FUNCTION hbCte_Zebra_Draw_Hpdf( hZebra, page, ... )
//
//   IF hb_zebra_GetError( hZebra ) != 0
//      RETURN HB_ZEBRA_ERROR_INVALIDZEBRA
//   ENDIF
//
//   hb_zebra_draw( hZebra, {| x, y, w, h | HPDF_Page_Rectangle( page, x, y, w, h ) }, ... )/
//
//   HPDF_Page_Fill( page )
//
//   RETURN 0

STATIC FUNCTION Cte_CodificaCode128c(pcCodigoBarra)

   &&  Parameters de entrada : O codigo de barras no formato Code128C "somente numeros" campo tipo caracter
   &&  Retorno               : Retorna o código convertido e com o caracter de START e STOP mais o checksum
   &&                        : para impressão do código de barras utilizando a fonte Code128bWin, é necessário
   &&                        : para utilizar essa fonte os arquivos Code128bWin.ttf, Code128bWin.afm e Code128bWin.pfb
   && Autor                  : Anderson Camilo
   && Data                   : 19/03/2012

   LOCAL nI :=0, checksum :=0, nValorCar, cCode128 := '', cCodigoBarra

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

STATIC FUNCTION XmlNodeInvertido( a, b, c )

   RETURN XmlNode( b, a, c )

STATIC FUNCTION FormatIE( cIE, cUF )

   cIE := AllTrim( cIE )
   IF cIE == "ISENTO" .OR. Empty( cIE )
      RETURN cIE
   ENDIF
   cIE := SoNumeros( cIE )

   HB_SYMBOL_UNUSED( cUF )
   RETURN cIE
