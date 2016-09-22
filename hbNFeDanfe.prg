/*
HBNFEDANFE - Funcoes e Classes Relativas a Impressao Danfe PDF
Fontes originais do projeto hbnfe em https://github.com/fernandoathayde/hbnfe
*/

#include "common.ch"
#include "hbclass.ch"
#include "harupdf.ch"
#ifndef __XHARBOUR__
   #include "hbwin.ch"
   #include "hbzebra.ch"
//   #include "hbcompat.ch"
#endif
//#include "hbnfe.ch"
#xcommand TRY  => BEGIN SEQUENCE WITH {| oErr | Break( oErr ) }
#xcommand CATCH [<!oErr!>] => RECOVER [USING <oErr>] <-oErr->
#xcommand FINALLY => ALWAYS
#define _LOGO_ESQUERDA        1
#define _LOGO_DIREITA         2
#define _LOGO_EXPANDIDO       3

CLASS hbNFeDanfe

   METHOD execute( cXmlNota, cFilePDF )
   METHOD buscaDadosXML()
   METHOD geraPDF()
   METHOD novaPagina()
   METHOD saltaPagina()
   METHOD cabecalho()
   METHOD destinatario()
   METHOD duplicatas()
   METHOD faturas()
   METHOD cabecalhoCobranca( nLinhaFinalCob, nTamanhoCob )
   METHOD canhoto()
   METHOD dadosImposto()
   METHOD dadosTransporte()
   METHOD cabecalhoProdutos()
   METHOD desenhaBoxProdutos( nLinhaFinalProd, nTamanhoProd )
   METHOD produtos()
   METHOD totalServico()
   METHOD dadosAdicionais()
   METHOD rodape()
   METHOD ProcessaItens( cXML, nItem )
   METHOD calculaItens1Folha( nItensInicial )

   VAR nItens1Folha
   VAR nItensDemaisFolhas
   VAR nLarguraDescricao

   VAR cTelefoneEmitente INIT ""
   VAR cSiteEmitente     INIT ""
   VAR cEmailEmitente    INIT ""
   VAR cDesenvolvedor    INIT ""
   VAR cXML
   VAR cChave
   VAR aIde
   VAR aEmit
   VAR aDest
   VAR aRetirada
   VAR aEntrega
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

   VAR cFonteNFe
   VAR cFonteCode128            && Inserido por Anderson Camilo em 04/04/2012
   VAR cFonteCode128F           && Inserido por Anderson Camilo em 04/04/2012
   VAR oPdf
   VAR oPdfPage
   VAR oPdfFontCabecalho
   VAR oPdfFontCabecalhoBold
   VAR nLinhaPDF
   VAR nLarguraBox INIT 0.2
   VAR lLaser      INIT .T.
   VAR lPaisagem
   VAR cLogoFile
   VAR nLogoStyle // 1-esquerda, 2-direita, 3-expandido

   VAR nItensFolha
   VAR nLinhaFolha
   VAR nFolhas
   VAR nFolha

   VAR cFile
   VAR lValorDesc INIT .F.
   VAR nCasasQtd  INIT 2
   VAR nCasasVUn  INIT 2
   VAR cRetorno

   ENDCLASS

METHOD execute( cXmlNota, cFilePDF ) CLASS hbNFeDanfe

   IF ::lLaser <> NIL
      ::lLaser := .T.
   ENDIF
   IF ::cFonteNFe = NIL
      ::cFonteNFe := 'Times'
   ENDIF

   IF Empty( cXmlNota )
      ::cRetorno := "XML sem conteúdo"
      RETURN ::cRetorno
   ENDIF

   IF ! Empty( cFilePDF )
      ::cFile := cFilePDF
   ENDIF

   ::cXML := cXmlNota
   ::cChave := Substr( ::cXML, AT('Id=',::cXML)+3+4,44)

   IF !::buscaDadosXML()
      RETURN ::cRetorno
   ENDIF

   IF ::aIde[ "tpImp" ] = "2"  // paisagem
      ::lPaisagem := .T.
      ::nItens1Folha := 16 //inicial pode aumentar variante a servicos etc...
      ::nItensDemaisFolhas := 72
      ::nLarguraDescricao := 45
   ELSE
      ::lPaisagem := .F.
      ::nItens1Folha := 45 // 48 inicial pode aumentar variante a servicos etc...   && anderson camilo diminuiu o numero de itens o original era 48
      ::nItensDemaisFolhas := 105
      ::nLarguraDescricao := 39
   ENDIF
   IF !::geraPDF()
      ::cRetorno := "Problema ao gerar o PDF"
      RETURN ::cRetorno
   ENDIF
   ::cRetorno := "OK"

   RETURN ::cRetorno

METHOD buscaDadosXML() CLASS hbNFeDanfe

   LOCAL cIde, cEmit, cDest, cRetirada, cEntrega, cICMSTotal, cISSTotal, cRetTrib, ;
         cTransp, cVeicTransp, cReboque, cInfAdic, cObsCont, cObsFisco, ;
         cExporta, cCompra, cInfProt // /////////////////////// cCobranca

   cIde := XmlNode( ::cXml, "ide" )
   ::aIde := hb_Hash()
   ::aIde[ "cUF" ]      := XmlNode( cIde, "cUF" )
   ::aIde[ "cNF" ]      := XmlNode( cIde, "cUF" )
   ::aIde[ "natOp" ]    := XmlNode( cIde, "natOp" )
   ::aIde[ "indPag" ]   := XmlNode( cIde, "indPag" )
   ::aIde[ "mod" ]      := XmlNode( cIde, "mod" )
   ::aIde[ "serie" ]    := XmlNode( cIde, "serie" )
   ::aIde[ "nNF" ]      := XmlNode( cIde, "nNF" )
   ::aIde[ "dhEmi" ]    := XmlNode( cIde, "dhEmi" )
   IF Empty( ::aIde[ "dhEmi" ] ) // NFE 2.0
      ::aIde[ "dhEmi" ] := XmlNode( cIde, "dEmi" )
   ENDIF
   ::aIde[ "dhSaiEnt" ] := XmlNode( cIde, "dhSaiEnt" )
   IF Empty(::aIde[ "dhSaiEnt" ] ) // NFE 2.0
      ::aIde[ "dhSaiEnt" ] := XmlNode( cIde, "dSaiEnt" ) + "T" + Time()
   ENDIF
   ::aIde[ "tpNF" ]    := XmlNode( cIde, "tpNF" )
   ::aIde[ "cMunFG" ]  := XmlNode( cIde, "cMunFG" )
   ::aIde[ "tpImp" ]   := XmlNode( cIde, "tpImp" )  // 1 - retrato 2-paisagem
   ::aIde[ "tpEmis" ]  := XmlNode( cIde, "tpEmis" )
   ::aIde[ "cDV" ]     := XmlNode( cIde, "cDV" )
   ::aIde[ "tpAmb" ]   := XmlNode( cIde, "tpAmb" )  // 1- producao 2-homologacao
   ::aIde[ "finNFe" ]  := XmlNode( cIde, "finNFe" ) // finalidade 1-normal/2-complementar 3- de ajuste
   ::aIde[ "procEmi" ] := XmlNode( cIde, "procEmi" ) //0 - emissão de NF-e com aplicativo do contribuinte 1 - emissão de NF-e avulsa pelo Fisco 2 - emissão de NF-e avulsa pelo contribuinte com seu certificado digital, através do site do Fisco 3- emissão NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.
   ::aIde[ "verProc" ] := XmlNode( cIde, "verProc" ) // versao sistema

   cEmit := XmlNode( ::cXml, "emit" )
   ::aEmit := hb_Hash()
   ::aEmit[ "CNPJ" ]    := XmlNode( cEmit, "CNPJ" )
   ::aEmit[ "CPF" ]     := XmlNode( cEmit, "CPF" ) // avulso pelo fisco
   ::aEmit[ "xNome" ]   := XmlToString( XmlNode( cEmit, "xNome" ) )
   ::aEmit[ "xFant" ]   := XmlNode( cEmit, "xFant" )
   ::aEmit[ "xLgr" ]    := XmlNode( cEmit, "xLgr" )
   ::aEmit[ "nro" ]     := XmlNode( cEmit, "nro" )
   ::aEmit[ "xBairro" ] := XmlNode( cEmit, "xBairro" )
   ::aEmit[ "cMun" ]    := XmlNode( cEmit, "cMun" )
   ::aEmit[ "xMun" ]    := XmlNode( cEmit, "xMun" )
   ::aEmit[ "UF" ]      := XmlNode( cEmit, "UF" )
   ::aEmit[ "CEP" ]     := XmlNode( cEmit, "CEP" )
   ::aEmit[ "cPais" ]   := XmlNode( cEmit, "cPais" )
   ::aEmit[ "xPais" ]   := XmlNode( cEmit, "xPais" )
   ::aEmit[ "fone" ]    := XmlNode( cEmit, "fone" ) // NFE 2.0
   ::aEmit[ "IE" ]      := XmlNode( cEmit, "IE" )
   ::aEmit[ "IEST" ]    := XmlNode( cEmit, "IEST" )
   ::aEmit[ "IM" ]      := XmlNode( cEmit, "IM" )
   ::aEmit[ "CNAE" ]    := XmlNode( cEmit, "CNAE" )
   ::aEmit[ "CRT" ]     := XmlNode( cEmit, "CRT" ) // NFE 2.0 1 simpl nac 2 sim nac ex. sub receita 3 regime normal

   ::cTelefoneEmitente := XmlNode( cEmit, "fone" )
   IF .NOT. Empty( ::cTelefoneEmitente )
      ::cTelefoneEmitente := Transform( SoNumeros( ::cTelefoneEmitente ), "@R (99) 99999-9999" )
   ENDIF

   cDest := XmlNode( ::cXml, "dest" )
   ::aDest := hb_Hash()
   ::aDest[ "CNPJ" ]    := XmlNode( cDest, "CNPJ" )
   ::aDest[ "CPF" ]     := XmlNode( cDest, "CPF" )
   ::aDest[ "xNome" ]   := XmlToString( XmlNode( cDest, "xNome" ) )
   ::aDest[ "xLgr" ]    := XmlNode( cDest, "xLgr" )
   ::aDest[ "nro" ]     := XmlNode( cDest, "nro" )
   ::aDest[ "xBairro" ] := XmlNode( cDest, "xBairro" )
   ::aDest[ "cMun" ]    := XmlNode( cDest, "cMun" )
   ::aDest[ "xMun" ]    := XmlNode( cDest, "xMun" )
   ::aDest[ "UF" ]      := XmlNode( cDest, "UF" )
   ::aDest[ "CEP" ]     := XmlNode( cDest, "CEP" )
   *IF ( ::aDest[ "CEP" ] = NIL .OR. EMPTY( AllTrim(::aDest[ "CEP" ])) ) .AND. ::aDest[ "UF" ]  <> "EX"
   *   ::cRetorno := "Destinatário sem CEP ou inválido"
   *   RETURN .F.
   *ENDIF
   ::aDest[ "cPais" ] := XmlNode( cDest, "cPais" )
   ::aDest[ "xPais" ] := XmlNode( cDest, "xPais" )
   ::aDest[ "fone" ]  := XmlNode( cDest, "fone" )
   IF Len( ::aDest[ "fone" ] ) <= 8
      ::aDest[ "fone" ] := "00" + ::aDest[ "fone" ]
   ENDIF
   ::aDest[ "IE" ]    := XmlNode( cDest, "IE" )
   ::aDest[ "ISUF" ]  := XmlNode( cDest, "ISUF" ) // NFE 2.0
   ::aDest[ "email" ] := XmlNode( cDest, "email" ) // NFE 2.0
*   IF ::aDest[ "email" ] = NIL .OR. EMPTY( AllTrim(::aDest[ "email" ]))
*      ::cRetorno := "Destinatário sem eMail ou inválido"
*      RETURN .F.
*   ENDIF

   cRetirada := XmlNode( ::cXml, "retirada" )
   ::aRetirada := hb_Hash()
   ::aRetirada[ "CNPJ" ]    := XmlNode( cRetirada, "CNPJ" ) // NFE 2.0
   ::aRetirada[ "CPF" ]     := XmlNode( cRetirada, "CPF" ) // NFE 2.0
   ::aRetirada[ "xLgr" ]    := XmlNode( cRetirada, "xLgr" )
   ::aRetirada[ "nro" ]     := XmlNode( cRetirada, "nro" )
   ::aRetirada[ "xCpl" ]    := XmlNode( cRetirada, "xCpl" )
   ::aRetirada[ "xBairro" ] := XmlNode( cRetirada, "xBairro" )
   ::aRetirada[ "cMun" ]    := XmlNode( cRetirada, "cMun" )
   ::aRetirada[ "xMun" ]    := XmlNode( cRetirada, "xMun" )
   ::aRetirada[ "UF" ]      := XmlNode( cRetirada, "UF" )

   cEntrega := XmlNode( ::cXml, "entrega" )
   ::aEntrega := hb_Hash()
   ::aEntrega[ "CNPJ" ]    := XmlNode( cEntrega, "CNPJ" ) // NFE 2.0
   ::aEntrega[ "CPF" ]     := XmlNode( cEntrega, "CPF" ) // NFE 2.0
   ::aEntrega[ "xLgr" ]    := XmlNode( cEntrega, "xLgr" )
   ::aEntrega[ "nro" ]     := XmlNode( cEntrega, "nro" )
   ::aEntrega[ "xCpl" ]    := XmlNode( cEntrega, "xCpl" )
   ::aEntrega[ "xBairro" ] := XmlNode( cEntrega, "xBairro" )
   ::aEntrega[ "cMun" ]    := XmlNode( cEntrega, "cMun" )
   ::aEntrega[ "xMun" ]    := XmlNode( cEntrega, "xMun" )
   ::aEntrega[ "UF" ]      := XmlNode( cEntrega, "UF" )

   // totais da NF
   cICMSTotal := XmlNode( ::cXml, "ICMSTot" )
   ::aICMSTotal := hb_Hash()
   ::aICMSTotal[ "vBC" ]     := XmlNode( cICMSTotal, "vBC" )
   ::aICMSTotal[ "vICMS" ]   := XmlNode( cICMSTotal, "vICMS" )
   ::aICMSTotal[ "vBCST" ]   := XmlNode( cICMSTotal, "vBCST" )
   ::aICMSTotal[ "vST" ]     := XmlNode( cICMSTotal, "vST" )
   ::aICMSTotal[ "vProd" ]   := XmlNode( cICMSTotal, "vProd" )
   ::aICMSTotal[ "vFrete" ]  := XmlNode( cICMSTotal, "vFrete" )
   ::aICMSTotal[ "vSeg" ]    := XmlNode( cICMSTotal, "vSeg" )
   ::aICMSTotal[ "vDesc" ]   := XmlNode( cICMSTotal, "vDesc" )
   ::aICMSTotal[ "vII" ]     := XmlNode( cICMSTotal, "vII" )
   ::aICMSTotal[ "vIPI" ]    := XmlNode( cICMSTotal, "vIPI" )
   ::aICMSTotal[ "vPIS" ]    := XmlNode( cICMSTotal, "vPIS" )
   ::aICMSTotal[ "vCOFINS" ] := XmlNode( cICMSTotal, "vCOFINS" )
   ::aICMSTotal[ "vOutro" ]  := XmlNode( cICMSTotal, "vOutro" )
   ::aICMSTotal[ "vNF" ]     := XmlNode( cICMSTotal, "vNF" )

   cISSTotal := XmlNode( ::cXml, "ISSQNtot" )
   ::aISSTotal := hb_Hash()
   ::aISSTotal[ "vServ" ]   := XmlNode( cISSTotal, "vServ" )
   ::aISSTotal[ "vBC" ]     := XmlNode( cISSTotal, "vBC" )
   ::aISSTotal[ "vISS" ]    := XmlNode( cISSTotal, "vISS" )
   ::aISSTotal[ "vPIS" ]    := XmlNode( cISSTotal, "vPIS" )
   ::aISSTotal[ "vCOFINS" ] := XmlNode( cISSTotal, "vCOFINS" )

   cRetTrib := XmlNode( ::cXml, "RetTrib" )
   ::aRetTrib := hb_Hash()
   ::aRetTrib[ "vRetPIS" ]    := XmlNode( cRetTrib, "vRetPIS" )
   ::aRetTrib[ "vRetCOFINS" ] := XmlNode( cRetTrib, "vRetCOFINS" )
   ::aRetTrib[ "vRetCSLL" ]   := XmlNode( cRetTrib, "vRetCSLL" )
   ::aRetTrib[ "vBCIRRF" ]    := XmlNode( cRetTrib, "vBCIRRF" )
   ::aRetTrib[ "vIRRF" ]      := XmlNode( cRetTrib, "vIRRF" )
   ::aRetTrib[ "vBCRetPrev" ] := XmlNode( cRetTrib, "vBCRetPrev" )
   ::aRetTrib[ "vRetPrev" ]   := XmlNode( cRetTrib, "vRetPrev" )


   cTransp := XmlNode( ::cXml, "transp" )
   ::aTransp := hb_Hash()
   ::aTransp[ "modFrete" ] := XmlNode( cTransp, "modFrete" )
   ::aTransp[ "CNPJ" ]     := XmlNode( cTransp, "CNPJ" )
   ::aTransp[ "CPF" ]      := XmlNode( cTransp, "CPF" )
   ::aTransp[ "xNome" ]    := XmlNode( cTransp, "xNome" )
   ::aTransp[ "IE" ]       := XmlNode( cTransp, "IE" ) // NFE 2.0
   ::aTransp[ "xEnder" ]   := XmlNode( cTransp, "xEnder" )
   ::aTransp[ "xMun" ]     := XmlNode( cTransp, "xMun" )
   ::aTransp[ "UF" ]       := XmlNode( cTransp, "UF" )
   // dados transportados
   ::aTransp[ "qVol" ]   := XmlNode( cTransp, "qVol" )
   ::aTransp[ "esp" ]    := XmlNode( cTransp, "esp" )
   ::aTransp[ "marca" ]  := XmlNode( cTransp, "marca" )
   ::aTransp[ "nVol" ]   := XmlNode( cTransp, "nVol" )
   ::aTransp[ "pesoL" ]  := XmlNode( cTransp, "pesoL" )
   ::aTransp[ "pesoB" ]  := XmlNode( cTransp, "pesoB" )
   ::aTransp[ "nLacre" ] := XmlNode( cTransp, "nLacre" )
   // veicTransp
   cVeicTransp := XmlNode( cTransp, "veicTransp" )
   ::aVeicTransp := hb_Hash()
   ::aVeicTransp[ "placa" ] := XmlNode( cVeicTransp, "placa" )
   ::aVeicTransp[ "UF" ]    := XmlNode( cVeicTransp, "UF" )
   ::aVeicTransp[ "RNTC" ]  := XmlNode( cVeicTransp, "RNTC" ) //ANTT
   //reboque
   cReboque := XmlNode( cTransp, "veicTransp" )
   ::aReboque := hb_Hash()
   ::aReboque[ "placa" ] := XmlNode( cReboque, "placa" )
   ::aReboque[ "UF" ]    := XmlNode( cReboque, "UF" )
   ::aReboque[ "RNTC" ]  := XmlNode( cReboque, "RNTC" ) //ANTT

   ::cCobranca := XmlNode( ::cXml, "cobr" )
   cInfAdic    := XmlNode( ::cXml, "infAdic" )
   ::aInfAdic  := hb_Hash()

   IF ! Empty( cInfAdic )   // Mauricio Cruz - 28/09/2011   && Anderson Retirei o + antes do CHR(13)+CHR(10)
      ::aInfAdic[ "infCpl" ] := XmlNode( cInfAdic, "infCpl" )
	  IF ! Empty( ::aInfAdic[ "infCpl" ] )
         ::aInfAdic[ "infCpl" ] := StrTran( ::aInfAdic[ "infCpl" ], ";", CHR(13) + CHR(10) )
	   ELSE
         ::aInfAdic[ "infCpl" ] := ""
	  ENDIF
   ELSE
      ::aInfAdic[ "infCpl" ] := ""
   ENDIF
   //obsCont
   cObsCont := XmlNode( cInfAdic, "obsCont" )
   ::aObsCont := hb_Hash()
   ::aObsCont[ "xCampo" ] := XmlNode( cObsCont, "xCampo" )
   ::aObsCont[ "xTexto" ] := XmlNode( cObsCont, "xTexto" )
   //obsFisco
   cObsFisco := XmlNode( cInfAdic, "obsFisco" )
   ::aObsFisco := hb_Hash()
   ::aObsFisco[ "xCampo" ] := XmlNode( cObsFisco, "xCampo" )
   ::aObsFisco[ "xTexto" ] := XmlNOde( cObsFisco, "xTexto" )

   cExporta := XmlNode( ::cXml, "exporta" )
   ::aExporta := hb_Hash()
   ::aExporta[ "UFEmbarq" ]   := XmlNode( cExporta, "infCpl" )
   ::aExporta[ "xLocEmbarq" ] := XmlNode( cExporta, "infCpl" )

   cCompra := XmlNode( ::cXml, "compra" )
   ::aCompra := hb_Hash()
   ::aCompra[ "xNEmp" ] := XmlNode( cCompra, "infCpl" )
   ::aCompra[ "xPed" ]  := XmlNode( cCompra, "infCpl" )
   ::aCompra[ "xCont" ] := XmlNode( cCompra, "infCpl" )

   cInfProt := XmlNode( ::cXml, "infProt" )
   ::aInfProt := hb_Hash()
   ::aInfProt[ "nProt" ]    := XmlNode( cInfProt, "nProt" )
   ::aInfProt[ "dhRecbto" ] := XmlNode( cInfProt, "dhRecbto" )
   ::aInfProt[ "digVal" ]   := XmlNode( cInfProt, "digVal" )
   ::aInfProt[ "cStat" ]    := XmlNode( cInfProt, "cStat" )
   ::aInfProt[ "xMotivo" ]  := XmlNode( cInfProt, "xMotivo" )

   RETURN .T.

METHOD geraPDF() CLASS hbNFeDanfe

   LOCAL nItem, nIdes, nItensNF, nItens1Folha

   // criacao objeto pdf
   ::oPdf := HPDF_New()
   IF ::oPdf == NIL
      ::cRetorno := "Falha da criação do objeto PDF"
      RETURN .F.
   ENDIF
   /* set compression mode */
   HPDF_SetCompressionMode( ::oPdf, HPDF_COMP_ALL )
   /* setando fonte */
   IF ::cFonteNFe == "Times"
      ::oPdfFontCabecalho     := HPDF_GetFont( ::oPdf, "Times-Roman", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Times-Bold", "CP1252" )
   ELSE
      ::oPdfFontCabecalho     := HPDF_GetFont( ::oPdf, "Courier", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Courier-Bold", "CP1252" )
   ENDIF

   &&  Alterado por Anderson Camilo em 06/11/2012

   #ifdef __XHARBOUR__
     IF ! File( "fontes\Code128bWinLarge.afm" ) .or. ! File( "fontes\Code128bWinLarge.pfb" )
        ::cRetorno := "Arquivos fontes\Code128bWinLarge, nao encontrados...!"
        RETURN .F.
     ENDIF

      && Inserido por Anderson Camilo em 04/04/2012

   ::cFonteCode128  := HPDF_LoadType1FontFromFile( ::oPdf, "fontes\Code128bWinLarge.afm", "fontes\Code128bWinLarge.pfb" )   && Code 128
   ::cFonteCode128F := HPDF_GetFont( ::oPdf, ::cFonteCode128, "WinAnsiEncoding" )
   #endif
   // final da criacao e definicao do objeto pdf

   ::nFolha := 1

   // calculando quantidade de itens
   nItem := 1
   DO WHILE .T.
      ::ProcessaItens( ::cXML, nItem )
      IF ::aItem[ "cProd" ] = NIL
         EXIT
      ENDIF
      nItem ++
      FOR nIdes = 2 TO MLCOUNT( ::aItem[ "xProd" ],::nLarguraDescricao )
         nItem ++
      NEXT
   ENDDO
   nItensNF := ( nItem - 1 )
   // calcula itens 1a Folha
   nItens1Folha := ::calculaItens1Folha( ::nItens1Folha )
   // calcula itens demais folhas
   nItensNF -= nItens1Folha
   ::nFolhas := 1
   IF nItensNF > 0
      ::nFolhas += INT( nItensNF / ::nItensDemaisFolhas )
      IF ! INT( nItensNF / ::nItensDemaisFolhas ) == nItensNF / ::nItensDemaisFolhas
         ::nFolhas++
      ENDIF
   ENDIF
   // fim

   ::novaPagina()

   ::canhoto()
   ::cabecalho()
   ::destinatario()
   ::duplicatas()
   ::dadosImposto()
   ::dadosTransporte()
   ::cabecalhoProdutos()

   ::produtos()

   ::totalServico()
   ::dadosAdicionais()
   ::rodape()

   ::cFile := iif( ::cFile == NIL, ::cChave + ".pdf", ::cFile )
   HPDF_SaveToFile( ::oPdf, ::cFile )
   HPDF_Free( ::oPdf )

   RETURN .T.

METHOD calculaItens1Folha( nItensInicial ) CLASS hbNFeDanfe

   IF ::lLaser = .T. // LASER
      nItensInicial += 9
   ENDIF
   IF EMPTY( ::cCobranca )
      nItensInicial += 2
   ENDIF
   IF VAL( IF( ::aISSTotal[ "vServ" ] <> NIL, ::aISSTotal[ "vServ" ], "0" ) ) <= 0 // sem servico
      nItensInicial += 4
   ENDIF

   RETURN nItensInicial

METHOD novaPagina() CLASS hbNFeDanfe

   LOCAL nRadiano, nAltura, nAngulo // //////////////////////////// nLargura

   ::oPdfPage := HPDF_AddPage( ::oPdf )
   IF ::lPaisagem = .T.
      HPDF_Page_SetSize( ::oPdfPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_LANDSCAPE )
   ELSE
      HPDF_Page_SetSize( ::oPdfPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT )
   ENDIF
   nAltura := HPDF_Page_GetHeight( ::oPdfPage )
   // ///////////////////////////nLargura := HPDF_Page_GetWidth( ::oPdfPage )

   IF ::lPaisagem = .T. // paisagem
      ::nLinhaPdf := nAltura - 10 && Margem Superior
      nAngulo := 30                   /* A rotation of 45 degrees. */
   ELSE
      ::nLinhaPdf := nAltura - 8 && Margem Superior
      nAngulo := 45                   /* A rotation of 45 degrees. */
   ENDIF

   nRadiano := nAngulo / 180 * 3.141592 /* Calcurate the radian value. */

   IF ::aIde[ "tpEmis" ] = "5" // Contingencia
      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText( ::oPdfPage)
      HPDF_Page_SetTextMatrix( ::oPdfPage, cos( nRadiano ), sin( nRadiano ), -sin( nRadiano ), cos( nRadiano ), 15, 160 )
      HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
      HPDF_Page_ShowText( ::oPdfPage, "DANFE EM CONTINGÊNCIA. IMPRESSO EM" )
      HPDF_Page_EndText( ::oPdfPage )

      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText( ::oPdfPage )
      HPDF_Page_SetTextMatrix( ::oPdfPage, cos( nRadiano ), sin( nRadiano ), -sin( nRadiano ), cos( nRadiano ), 15, 130 )
      HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
      HPDF_Page_ShowText( ::oPdfPage, "DECORRÊNCIA DE PROBLEMAS TÉCNICOS." )
      HPDF_Page_EndText( ::oPdfPage )

      HPDF_Page_SetRGBFill( ::oPdfPage, 0, 0, 0 ) // reseta cor fontes
   ENDIF

   IF ::aIde[ "tpEmis" ] = "4" // DEPEC
      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText( ::oPdfPage)
      HPDF_Page_SetTextMatrix(::oPdfPage, cos( nRadiano ), sin( nRadiano ), -sin( nRadiano ), cos( nRadiano ), 15, 190 )
      HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
      HPDF_Page_ShowText( ::oPdfPage, "DANFE IMPRESSO EM CONTINGÊNCIA - DEPEC" )
      HPDF_Page_EndText( ::oPdfPage )

      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText( ::oPdfPage )
      HPDF_Page_SetTextMatrix( ::oPdfPage, cos( nRadiano ), sin( nRadiano ), -sin( nRadiano ), cos( nRadiano ), 15, 160 )
      HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
      HPDF_Page_ShowText( ::oPdfPage, "REGULARMENTE RECEBIDO PELA RECEITA" )
      HPDF_Page_EndText( ::oPdfPage )

      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText( ::oPdfPage )
      HPDF_Page_SetTextMatrix( ::oPdfPage, cos( nRadiano ), sin( nRadiano ), -sin( nRadiano ), cos( nRadiano ), 15, 130 )
      HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
      HPDF_Page_ShowText( ::oPdfPage, "FEDERAL DO BRASIL." )
      HPDF_Page_EndText( ::oPdfPage )

      HPDF_Page_SetRGBFill(::oPdfPage, 0, 0, 0) // reseta cor fontes
   ENDIF

   IF ::aIde[ "tpAmb" ] = "2"
      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText( ::oPdfPage )
      HPDF_Page_SetTextMatrix( ::oPdfPage, cos( nRadiano ), sin( nRadiano ), -sin( nRadiano ), cos( nRadiano ), 15, 100 )
      HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
      HPDF_Page_ShowText( ::oPdfPage, "AMBIENTE DE HOMOLOGAÇÃO - SEM VALOR FISCAL" )
      HPDF_Page_EndText( ::oPdfPage )

      HPDF_Page_SetRGBStroke( ::oPdfPage, 0.75, 0.75, 0.75 )
      IF ::lPaisagem = .T. // paisagem
         hbNFe_Line_Hpdf( ::oPdfPage, 15, 95, 675, 475, 2.0 )
      ELSE
         hbNFe_Line_Hpdf( ::oPdfPage, 15, 95, 550, 630, 2.0 )
      ENDIF

      HPDF_Page_SetRGBStroke( ::oPdfPage, 0, 0, 0 ) // reseta cor linhas

      HPDF_Page_SetRGBFill( ::oPdfPage, 0, 0, 0 ) // reseta cor fontes
   ENDIF

   RETURN NIL

METHOD saltaPagina() CLASS hbNFeDanfe

   LOCAL nLinhaFinalProd, nTamanhoProd

   //IF ::nLinhaFolha > ::nItensFolha
      ::nLinhaPdf -= 2
      ::totalServico()
      ::dadosAdicionais()
      ::rodape()
      ::novaPagina()
      ::nFolha ++
      ::nLinhaFolha := 1
      ::nItensFolha := ::nItensDemaisFolhas
      ::canhoto()
      ::cabecalho()
      ::cabecalhoProdutos()
      nLinhaFinalProd := ::nLinhaPdf - ( ::nItensFolha * 6 ) - 2
      nTamanhoProd := ( ::nItensFolha * 6 ) + 2
      ::desenhaBoxProdutos( nLinhaFinalProd, nTamanhoProd )
   //ENDIF

   RETURN NIL

METHOD canhoto() CLASS hbNFeDanfe

   IF ::nFolha = 1
      IF ::lPaisagem = .T. // paisagem
         hbNFe_Box_Hpdf( ::oPdfPage,   5, 20, 50, 565, ::nLarguraBox )
         // recebemos
         hbNFe_Texto_Hpdf( ::oPdfPage,  14, 21, 14 + 8, ::nLinhaPdf, "Recebemos de " + Trim( ::aEmit[ "xNome" ] ) + " os produtos constantes da Nota Fiscal indicada ao lado", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 7, 90 )
         // quadro numero da NF
         hbNFe_Box_Hpdf( ::oPdfPage,   5, 505, 50, 80, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,  14, 506, 14 + 8, NIL, "NOTA FISCAL", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8, 90 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  30, 506, 30 + 8, NIL, "Nº: " + Transform( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), "@R 999.999.999" ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8, 90 )
         hbNFe_Texto_Hpdf( ::oPdfPage,  46, 506, 46 + 8, NIL, "SÉRIE " + ::aIde[ "serie" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8, 90 )

         // data recebimento
         hbNFe_Box_Hpdf( ::oPdfPage,  20, 20, 35, 120, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 26, 21, 26 + 8, NIL, "DATA DE RECEBIMENTO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6, 90 )
         // identificacao
         hbNFe_Box_Hpdf( ::oPdfPage,  20, 140, 35, 365, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,  26, 141, 26 + 8, NIL, "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6, 90 )

         // corte
         IF ::cFonteNFe == "Times"
            hbNFe_Texto_Hpdf( ::oPdfPage, 62, 20, 62 + 8, NIL, Replicate( "- ",110 ), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 8, 90 )
         ELSE
            hbNFe_Texto_Hpdf( ::oPdfPage, 65, 20, 65 + 6, NIL, Replicate( "- ",78 ), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6, 90 )
         ENDIF
      ELSE // retrato
         hbNFe_Box_Hpdf( ::oPdfPage, 5, ::nLinhaPdf - 44, 585, 44, ::nLarguraBox )
         // recebemos
         hbNFe_Texto_Hpdf( ::oPdfPage, 6, ::nLinhaPdf, 490, NIL, "Recebemos de "+::aEmit[ "xNome" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 6, ::nLinhaPdf-7, 490, NIL, "os produtos constantes da Nota Fiscal indicada ao lado", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8 )
         // quadro numero da NF
         hbNFe_Box_Hpdf( ::oPdfPage, 505, ::nLinhaPdf - 44, 85, 44, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 506, ::nLinhaPdf - 8, 589, NIL, "NF-e", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8 )
           hbNFe_Texto_Hpdf( ::oPdfPage, 506, ::nLinhaPdf - 20, 589, NIL, "Nº: " + Transform( StrZero( VAL( ::aIde[ "nNF" ] ), 9 ), "@R 999.999.999" ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 506, ::nLinhaPdf - 32, 589, NIL, "SÉRIE "+::aIde[ "serie" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8 )
         ::nLinhaPdf -= 18

         // data recebimento
         hbNFe_Box_Hpdf( ::oPdfPage,   5, ::nLinhaPdf - 26, 130, 26, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 6, ::nLinhaPdf, 134, NIL, "DATA DE RECEBIMENTO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         // identificacao
         hbNFe_Box_Hpdf( ::oPdfPage, 135, ::nLinhaPdf - 26, 370, 26, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 136, ::nLinhaPdf, 470, NIL, "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         ::nLinhaPdf -= 24

         // corte
         IF ::cFonteNFe == "Times"
            hbNFe_Texto_Hpdf( ::oPdfPage,  5, ::nLinhaPdf, 590, NIL, REPLIC("- ",125), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 8 )
         ELSE
            hbNFe_Texto_Hpdf( ::oPdfPage,  5, ::nLinhaPdf - 2, 590, NIL, REPLIC("- ",81), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         ENDIF
         ::nLinhaPdf -= 10
      ENDIF
   ELSE
      IF ::lPaisagem = .T. // paisagem
      ELSE // retrato
         ::nLinhaPdf -= 18
         ::nLinhaPdf -= 24
         ::nLinhaPdf -= 10
      ENDIF
   ENDIF

   RETURN NIL

METHOD cabecalho() CLASS hbNFeDanfe

   LOCAL oImage, hZebra

   IF ::lPaisagem = .T. // paisagem
      hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-80, 760, 80, ::nLarguraBox )
      // logo/dados empresa
      hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-80, 330, 80, ::nLarguraBox )
      IF EMPTY( ::cLogoFile )
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf, 399, NIL, "IDENTIFICAÇÃO DO EMITENTE", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 6, 399, NIL, TRIM( MEMOLINE( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 12 )
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 18, 399, NIL, TRIM( MEMOLINE( ::aEmit[ "xNome" ], 30, 2 ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 12 )
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 30, 399, NIL, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 38, 399, NIL, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 46, 399, NIL, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 54, 399, NIL, TRIM( iif( ! EMPTY( ::cTelefoneEmitente ), "FONE: " + ::cTelefoneEmitente, "" ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 62, 399, NIL, TRIM( ::cSiteEmitente ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 70, 399, NIL, TRIM( ::cEmailEmitente ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
       ELSE
          IF ::nLogoStyle = _LOGO_EXPANDIDO
             oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
             HPDF_Page_DrawImage( ::oPdfPage, oImage, 6, ::nLinhaPdf - ( 72 + 6 ), 328, 72 )
          ELSEIF ::nLogoStyle = _LOGO_ESQUERDA
             oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
             HPDF_Page_DrawImage( ::oPdfPage, oImage, 71, ::nLinhaPdf - ( 72 + 6 ), 62, 72 )
              hbNFe_Texto_Hpdf( ::oPdfPage, 135, ::nLinhaPdf - 6, 399, NIL, TRIM( MEMOLINE( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 12 )
              hbNFe_Texto_Hpdf( ::oPdfPage, 135, ::nLinhaPdf - 18, 399, NIL, TRIM( MEMOLINE( ::aEmit[ "xNome" ], 30, 2 ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 12 )
              hbNFe_Texto_Hpdf( ::oPdfPage, 135, ::nLinhaPdf - 30, 399, NIL, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
              hbNFe_Texto_Hpdf( ::oPdfPage, 135, ::nLinhaPdf - 38, 399, NIL, ::aEmit[ "xBairro" ]+" - "+Transform( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
              hbNFe_Texto_Hpdf( ::oPdfPage, 135, ::nLinhaPdf - 46, 399, NIL, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
              hbNFe_Texto_Hpdf( ::oPdfPage, 135, ::nLinhaPdf - 54, 399, NIL, TRIM( IF( ! EMPTY( ::cTelefoneEmitente ), "FONE: " + ::cTelefoneEmitente, "" ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
              hbNFe_Texto_Hpdf( ::oPdfPage, 135, ::nLinhaPdf - 62, 399, NIL, TRIM( ::cSiteEmitente), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
              hbNFe_Texto_Hpdf( ::oPdfPage, 135, ::nLinhaPdf - 70, 399, NIL, TRIM( ::cEmailEmitente), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
          ELSEIF ::nLogoStyle = _LOGO_DIREITA
             oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
             HPDF_Page_DrawImage( ::oPdfPage, oImage, 337, ::nLinhaPdf - ( 72 + 6 ), 62, 72 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 6, 335, NIL, TRIM( MEMOLINE( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 12 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 18, 335, NIL, TRIM( MEMOLINE( ::aEmit[ "xNome" ], 30, 2 ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 12 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 30, 335, NIL, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 38, 335, NIL, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 46, 335, NIL, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 54, 335, NIL, TRIM( iif( ! EMPTY( ::cTelefoneEmitente ), "FONE: " + ::cTelefoneEmitente, "" ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 62, 335, NIL, TRIM( ::cSiteEmitente ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 70, 335, NIL, TRIM( ::cEmailEmitente ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
           ENDIF
      ENDIF

      // numero nf tipo
      hbNFe_Box_Hpdf( ::oPdfPage, 400, ::nLinhaPdf - 80, 125, 80, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage, 401, ::nLinhaPdf - 4, 524, NIL, "DANFE", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 12 )
      hbNFe_Texto_Hpdf( ::oPdfPage, 401, ::nLinhaPdf - 16, 524, NIL, "Documento Auxiliar da", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
      hbNFe_Texto_Hpdf( ::oPdfPage, 401, ::nLinhaPdf - 24, 524, NIL, "Nota Fiscal Eletrônica", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )

      hbNFe_Texto_Hpdf( ::oPdfPage, 411, ::nLinhaPdf - 36, 524, NIL, "0 - ENTRADA", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 8 )
      hbNFe_Texto_Hpdf( ::oPdfPage, 411, ::nLinhaPdf - 44, 524, NIL, "1 - SAÍDA", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 8 )
      // preenchimento do tipo de nf
      hbNFe_Box_Hpdf( ::oPdfPage, 495, ::nLinhaPdf - 52, 20, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage, 496, ::nLinhaPdf - 40, 514, NIL, ::aIde[ "tpNF" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )

      hbNFe_Texto_Hpdf( ::oPdfPage, 401, ::nLinhaPdf - 56, 524, NIL, "Nº: " + Transform( StrZero( VAL( ::aIde[ "nNF" ] ), 9 ), "@R 999.999.999" ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 10 )
      hbNFe_Texto_Hpdf( ::oPdfPage, 401, ::nLinhaPdf - 66, 524, NIL, "SÉRIE: "+::aIde[ "serie" ] + " - FOLHA " + AllTrim( STR( ::nFolha ) ) + "/" + AllTrim( STR( ::nFolhas ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 10 )

      // codigo barras
      hbNFe_Box_Hpdf( ::oPdfPage,525, ::nLinhaPdf-35, 305, 35, ::nLarguraBox )
      #ifdef __XHARBOUR__
*         oCode128 = HPDF_LoadType1FontFromFile(::oPdf, 'fontes\Code128bWin.afm', 'fontes\Code128bWin.pfb')
*         oCode128F := HPDF_GetFont( ::oPdf, oCode128, "FontSpecific" )
*         hbNFe_Texto_Hpdf( ::oPdfPage,540, ::nLinhaPdf-4.5, 815, NIL, "{"+::cChave+"~", HPDF_TALIGN_CENTER, NIL, oCode128F, 11 )
*         hbNFe_Texto_Hpdf( ::oPdfPage,540, ::nLinhaPdf-19, 815, NIL, "{"+::cChave+"~", HPDF_TALIGN_CENTER, NIL, oCode128F,11 )

                       && Modificado por Anderson Camilo em 04/04/2012
          hbNFe_Texto_Hpdf( ::oPdfPage, 540, ::nLinhaPdf - 1.5, 815, NIL, CodificaCode128c( ::cChave ), HPDF_TALIGN_CENTER, NIL, ::cFonteCode128F, 15 )


      #else
          hZebra := hb_zebra_create_code128( ::cChave, NIL )
          hbNFe_Zebrea_Draw_Hpdf( hZebra, ::oPdfPage, 540, ::nLinhaPdf - 32, 1.0, 30 )
      #endif
      // chave de acesso
      hbNFe_Box_Hpdf( ::oPdfPage, 525, ::nLinhaPdf - 55, 305, 55, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage, 526, ::nLinhaPdf - 36, 829, NIL, "CHAVE DE ACESSO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
      IF ::cFonteNFe == "Times"
         hbNFe_Texto_Hpdf( ::oPdfPage, 526, ::nLinhaPdf - 44, 829, NIL, Transform( ::cChave, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999" ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 9 )
      ELSE
         hbNFe_Texto_Hpdf( ::oPdfPage, 526, ::nLinhaPdf - 44, 829, NIL, Transform( ::cChave, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999" ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
      ENDIF
      // mensagem sistema sefaz
      hbNFe_Box_Hpdf( ::oPdfPage, 525, ::nLinhaPdf - 80, 305, 80, ::nLarguraBox )
      IF ::aInfProt[ "nProt" ] = NIL .OR. EMPTY( ::aInfProt[ "nProt" ] )
         hbNFe_Texto_Hpdf( ::oPdfPage, 526, ::nLinhaPdf - 55, 829, NIL, "N F E   A I N D A   N Ã O   F O I", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 526, ::nLinhaPdf - 63, 829, NIL, "A U T O R I Z A D A   P E L A", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 526, ::nLinhaPdf - 71, 829, NIL, "S E F A Z   (SEM VALIDADE FISCAL)", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8 )
      ELSE
         hbNFe_Texto_Hpdf( ::oPdfPage, 526, ::nLinhaPdf - 55, 829, NIL, "Consulta de autenticidade no portal nacional", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 526, ::nLinhaPdf - 63, 829, NIL, "da NF-e www.nfe.fazenda.gov.br/portal ou", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 526, ::nLinhaPdf - 71, 829, NIL, "no site da Sefaz Autorizadora", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8 )
      ENDIF

      ::nLinhaPdf -= 80

      // NATUREZA
      hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf - 16, 455, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 1, 524, NIL, "NATUREZA DA OPERAÇÃO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 5, 524, NIL, ::aIde[ "natOp" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
      // PROTOCOLO
      hbNFe_Box_Hpdf( ::oPdfPage, 525, ::nLinhaPdf - 16, 305, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage, 526, ::nLinhaPdf - 1, 829, NIL, "PROTOCOLO DE AUTORIZAÇÃO DE USO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      IF ::aInfProt[ "nProt" ] <> NIL
   	     IF ::aInfProt[ "cStat" ] = '100'
            hbNFe_Texto_Hpdf( ::oPdfPage, 526, ::nLinhaPdf - 1, 829, NIL, "PROTOCOLO DE AUTORIZAÇÃO DE USO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         ELSEIF ::aInfProt[ "cStat" ] = '101' .OR. ::aInfProt[ "cStat" ] = '135'
            hbNFe_Texto_Hpdf( ::oPdfPage, 526, ::nLinhaPdf - 1, 829, NIL, "PROTOCOLO DE HOMOLOGAÇÃO DO CANCELAMENTO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
   	     ENDIF

         IF ::cFonteNFe == "Times"
            hbNFe_Texto_Hpdf( ::oPdfPage, 526, ::nLinhaPdf - 6, 829, NIL, ::aInfProt[ "nProt" ] + " " + Substr( Substr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 9, 2 ) + "/" + Substr( Substr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 6, 2 ) + "/" + Substr( Substr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 1, 4 ) + " " + Substr( ::aInfProt[ "dhRecbto" ], 12, 8 ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 9 )
         ELSE
            hbNFe_Texto_Hpdf( ::oPdfPage, 526, ::nLinhaPdf - 6, 829, NIL, ::aInfProt[ "nProt" ] + " " + Substr( Substr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 9, 2 ) + "/" + Substr( Substr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 6, 2 ) + "/" + Substr( Substr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 1, 4 ) +" " + Substr( ::aInfProt[ "dhRecbto" ], 12, 8 ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 9 )
         ENDIF
      ENDIF

      ::nLinhaPdf -= 16

      // I.E.
      hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf - 16, 240, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 1, 309, NIL, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 5, 309, NIL, ::aEmit[ "IE" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
      // I.E. SUBS. TRIB.
      hbNFe_Box_Hpdf( ::oPdfPage, 310, ::nLinhaPdf - 16, 400, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage, 311, ::nLinhaPdf - 1, 709, NIL, "INSCRIÇÃO ESTADUAL DO SUBS. TRIBUTÁRIO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage, 311, ::nLinhaPdf - 5, 709, NIL, "", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
      // CNPJ
      hbNFe_Box_Hpdf( ::oPdfPage, 710, ::nLinhaPdf - 16, 120, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage, 711, ::nLinhaPdf - 1,  829, NIL, "C.N.P.J.", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage, 711, ::nLinhaPdf-5, 829, NIL, Transform(::aEmit[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 17
   ELSE
      hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf - 80, 585, 80, ::nLarguraBox )
      // logo/dados empresa
      hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf - 80, 240, 80, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf, 244, NIL, "IDENTIFICAÇÃO DO EMITENTE", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
      IF EMPTY( ::cLogoFile )
          hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-6, 244, NIL, TRIM( MemoLine( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 12 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-18, 244, NIL, TRIM( MemoLine( ::aEmit[ "xNome" ], 30, 2 ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 12 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-30, 244, NIL, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-38, 244, NIL, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-46, 244, NIL, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-54, 244, NIL, TRIM( iif( ! Empty( ::cTelefoneEmitente ), "FONE: " + ::cTelefoneEmitente, "" ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-62, 244, NIL, TRIM(::cSiteEmitente), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-70, 244, NIL, TRIM(::cEmailEmitente), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
      ELSE
          IF ::nLogoStyle = _LOGO_EXPANDIDO
             oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
             HPDF_Page_DrawImage( ::oPdfPage, oImage, 6, ::nLinhaPdf - ( 72 + 6 ), 238, 72 )
          ELSEIF ::nLogoStyle = _LOGO_ESQUERDA
             oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
             HPDF_Page_DrawImage( ::oPdfPage, oImage, 6, ::nLinhaPdf - ( 72 + 6 ), 62, 72 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf - 6, 244, NIL, TRIM( MEMOLINE( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 12 )
             && Anderson camilo   30/12/2011  Comentei esta linha porque a razão social estava saindo um nome sobre o outro
*            hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-18, 244, NIL, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,2)), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 12 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf - 30, 244, NIL, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf - 38, 244, NIL, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf - 46, 244, NIL, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf - 54, 244, NIL, TRIM( iif( ! EMPTY( ::cTelefoneEmitente ), "FONE: " + ::cTelefoneEmitente, "" ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf - 62, 244, NIL, TRIM( ::cSiteEmitente ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf - 70, 244, NIL, TRIM( ::cEmailEmitente ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
          ELSEIF ::nLogoStyle = _LOGO_DIREITA
             oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
             HPDF_Page_DrawImage( ::oPdfPage, oImage,182, ::nLinhaPdf - ( 72 + 6 ), 62, 72 )
            hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-6, 180, NIL, TRIM( MEMOLINE( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 12 )
            hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-18, 180, NIL, TRIM( MEMOLINE( ::aEmit[ "xNome" ],30, 2 ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 12 )
            hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-30, 180, NIL, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-38, 180, NIL, ::aEmit[ "xBairro" ]+" - "+Transform( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-46, 180, NIL, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-54, 180, NIL, TRIM( iif( ! EMPTY( ::cTelefoneEmitente ), "FONE: " + ::cTelefoneEmitente, "" ) ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-62, 180, NIL, TRIM( ::cSiteEmitente ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-70, 180, NIL, TRIM( ::cEmailEmitente ), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
           ENDIF
      ENDIF
      // numero nf tipo
      hbNFe_Box_Hpdf( ::oPdfPage,245, ::nLinhaPdf-80, 125, 80, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,246, ::nLinhaPdf-4, 369, NIL, "DANFE", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 12 )
      hbNFe_Texto_Hpdf( ::oPdfPage,246, ::nLinhaPdf-16, 369, NIL, "Documento Auxiliar da", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
      hbNFe_Texto_Hpdf( ::oPdfPage,246, ::nLinhaPdf-24, 369, NIL, "Nota Fiscal Eletrônica", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )

      hbNFe_Texto_Hpdf( ::oPdfPage,256, ::nLinhaPdf-36, 349, NIL, "0 - ENTRADA", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 8 )
      hbNFe_Texto_Hpdf( ::oPdfPage,256, ::nLinhaPdf-44, 349, NIL, "1 - SAÍDA", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 8 )
      // preenchimento do tipo de nf
      hbNFe_Box_Hpdf( ::oPdfPage,340, ::nLinhaPdf-52, 20, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,341, ::nLinhaPdf-40, 359, NIL, ::aIde[ "tpNF" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )

      hbNFe_Texto_Hpdf( ::oPdfPage,246, ::nLinhaPdf-56, 369, NIL, "Nº: " + Substr( strzero( Val(::aIde[ "nNF" ]),9),1,3)+"." + Substr( strzero( Val(::aIde[ "nNF" ]),9),4,3)+"." + Substr( strzero( Val(::aIde[ "nNF" ]),9),7,3), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 10 )
      hbNFe_Texto_Hpdf( ::oPdfPage,246, ::nLinhaPdf-66, 369, NIL, "SÉRIE: "+::aIde[ "serie" ]+" - FOLHA "+AllTrim(STR(::nFolha))+"/"+AllTrim(STR(::nFolhas)), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 9 )

      // codigo barras
      hbNFe_Box_Hpdf( ::oPdfPage,370, ::nLinhaPdf-35, 220, 35, ::nLarguraBox )
      #ifdef __XHARBOUR__
            && Modificado por Anderson Camilo em 04/04/2012
*         oCode128 = HPDF_LoadType1FontFromFile(::oPdf, 'fontes\Code128bWin.afm', 'fontes\Code128bWin.pfb')
*         oCode128F := HPDF_GetFont( ::oPdf, oCode128, "FontSpecific" )
*          hbNFe_Texto_Hpdf( ::oPdfPage,380, ::nLinhaPdf-8, 585, NIL, "{"+::cChave+"~", HPDF_TALIGN_CENTER, NIL, oCode128F, 8 )
*          hbNFe_Texto_Hpdf( ::oPdfPage,380, ::nLinhaPdf-18.2, 585, NIL, "{"+::cChave+"~", HPDF_TALIGN_CENTER, NIL, oCode128F, 8 )

           hbNFe_Texto_Hpdf( ::oPdfPage,380, ::nLinhaPdf-2, 585, NIL, CodificaCode128c(::cChave), HPDF_TALIGN_CENTER, NIL, ::cFonteCode128F, 15 )

      #else
         hZebra := hb_zebra_create_code128( ::cChave, NIL )
         hbNFe_Zebrea_Draw_Hpdf( hZebra, ::oPdfPage, 385, ::nLinhaPdf-32, 0.7, 30 )
      #endif


      // chave de acesso
      hbNFe_Box_Hpdf( ::oPdfPage, 370, ::nLinhaPdf - 55, 220, 55, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage, 371, ::nLinhaPdf - 36, 589, NIL, "CHAVE DE ACESSO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
      IF ::cFonteNFe == "Times"
         hbNFe_Texto_Hpdf( ::oPdfPage, 371, ::nLinhaPdf - 44, 589, NIL, Transform(::cChave, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
      ELSE
         hbNFe_Texto_Hpdf( ::oPdfPage, 371, ::nLinhaPdf - 44, 589, NIL, Transform(::cChave, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      ENDIF
      // mensagem sistema sefaz
      hbNFe_Box_Hpdf( ::oPdfPage, 370, ::nLinhaPdf-80, 220, 80, ::nLarguraBox )
      IF ::aInfProt[ "nProt" ] = NIL .OR. EMPTY( ::aInfProt[ "nProt" ] )
         hbNFe_Texto_Hpdf( ::oPdfPage, 371, ::nLinhaPdf - 55, 589, NIL, "N F E   A I N D A   N Ã O   F O I", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 371, ::nLinhaPdf - 63, 589, NIL, "A U T O R I Z A D A   P E L A", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 371, ::nLinhaPdf - 71, 589, NIL, "S E F A Z   (SEM VALIDADE FISCAL)", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8 )
      ELSE
         hbNFe_Texto_Hpdf( ::oPdfPage, 371, ::nLinhaPdf - 55, 589, NIL, "Consulta de autenticidade no portal nacional", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 371, ::nLinhaPdf - 63, 589, NIL, "da NF-e www.nfe.fazenda.gov.br/portal ou", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 371, ::nLinhaPdf - 71, 589, NIL, "no site da Sefaz Autorizadora", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalhoBold, 8 )
      ENDIF

      ::nLinhaPdf -= 80

      // NATUREZA
      hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf - 16, 365, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf - 1,  369, NIL, "NATUREZA DA OPERAÇÃO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf - 5, 369, NIL, ::aIde[ "natOp" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
      // PROTOCOLO
      hbNFe_Box_Hpdf( ::oPdfPage,370, ::nLinhaPdf - 16, 220, 16, ::nLarguraBox )

	  // Alterado por Anderson Camilo em 06/08/2013
*      hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-1, 589, NIL, "PROTOCOLO DE AUTORIZAÇÃO DE USO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      IF ::aInfProt[ "nProt" ] <> NIL

         IF ::aInfProt[ "cStat" ] = '100'
            hbNFe_Texto_Hpdf( ::oPdfPage, 371, ::nLinhaPdf - 1, 589, NIL, "PROTOCOLO DE AUTORIZAÇÃO DE USO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         ELSEIF ::aInfProt[ "cStat" ] = '101' .OR. ::aInfProt[ "cStat" ] = '135'
            hbNFe_Texto_Hpdf( ::oPdfPage, 371, ::nLinhaPdf - 1, 589, NIL, "PROTOCOLO DE HOMOLOGAÇÃO DO CANCELAMENTO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         ENDIF

         IF ::cFonteNFe == "Times"
            hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-6, 589, NIL, ::aInfProt[ "nProt" ]+" " + Substr(Substr(::aInfProt[ "dhRecbto" ],1,10),9,2)+"/" + Substr(Substr(::aInfProt[ "dhRecbto" ],1,10),6,2)+"/" + Substr(Substr(::aInfProt[ "dhRecbto" ],1,10),1,4)+" " + Substr(::aInfProt[ "dhRecbto" ],12,8), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 9 )
         ELSE
            hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-6, 589, NIL, ::aInfProt[ "nProt" ]+" " + Substr(Substr(::aInfProt[ "dhRecbto" ],1,10),9,2)+"/" + Substr(Substr(::aInfProt[ "dhRecbto" ],1,10),6,2)+"/" + Substr(Substr(::aInfProt[ "dhRecbto" ],1,10),1,4)+" " + Substr(::aInfProt[ "dhRecbto" ],12,8), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 9 )
         ENDIF
      ENDIF

      ::nLinhaPdf -= 16

      // I.E.
      hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-16, 240, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf - 1,  244, NIL, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5, 244, NIL, ::aEmit[ "IE" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
      // I.E. SUBS. TRIB.
      hbNFe_Box_Hpdf( ::oPdfPage,245, ::nLinhaPdf-16, 225, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,246, ::nLinhaPdf - 1,  419, NIL, "INSCRIÇÃO ESTADUAL DO SUBS. TRIBUTÁRIO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,246, ::nLinhaPdf-5, 419, NIL, "", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
      // CNPJ
      hbNFe_Box_Hpdf( ::oPdfPage,470, ::nLinhaPdf-16, 120, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,471, ::nLinhaPdf - 1,  589, NIL, "C.N.P.J.", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,471, ::nLinhaPdf-5, 589, NIL, Transform(::aEmit[ "CNPJ" ], "@R 99.999.999/9999-99"), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 17
   ENDIF

   RETURN NIL

METHOD destinatario() CLASS hbNFeDanfe

   IF ::lPaisagem = .T. // paisagem
      hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf, 830, NIL, "DESTINATÁRIO/REMETENTE", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalhoBold, 5 )

      ::nLinhaPdf -= 6

      // RAZAO SOCIAL
      hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-16, 590, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf - 1,  659, NIL, "NOME / RAZÃO SOCIAL", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-5, 659, NIL, ::aDest[ "xNome" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
      // CNPJ/CPF
      hbNFe_Box_Hpdf( ::oPdfPage,660, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,661, ::nLinhaPdf - 1,  759, NIL, "CNPJ/CPF", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      IF !EMPTY(::aDest[ "CNPJ" ])
         hbNFe_Texto_Hpdf( ::oPdfPage,661, ::nLinhaPdf-5, 759, NIL, Transform(::aDest[ "CNPJ" ], "@R 99.999.999/9999-99"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 9 )
      ELSE
         IF ::aDest[ "CPF" ] <> NIL
         hbNFe_Texto_Hpdf( ::oPdfPage,661, ::nLinhaPdf-5, 759, NIL, Transform(::aDest[ "CPF" ], "@R 999.999.999-99"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         ENDIF
      ENDIF
      // DATA DE EMISSAO
      hbNFe_Box_Hpdf( ::oPdfPage,760, ::nLinhaPdf-16, 70, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,761, ::nLinhaPdf - 1,  829, NIL, "DATA DE EMISSÃO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,761, ::nLinhaPdf-5, 829, NIL, Substr(::aIde[ "dEmi" ],9,2)+"/" + Substr(::aIde[ "dEmi" ],6,2)+"/" + Substr(::aIde[ "dEmi" ],1,4), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 16

      // ENDEREÇO
      hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-16, 440, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf - 1,  509, NIL, "ENDEREÇO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-5, 509, NIL, ::aDest[ "xLgr" ]+" "+::aDest[ "nro" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 8 )
      // BAIRRO
      hbNFe_Box_Hpdf( ::oPdfPage,510, ::nLinhaPdf-16, 190, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf - 1,  699, NIL, "BAIRRO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-5, 699, NIL, ::aDest[ "xBairro" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
      // CEP
      hbNFe_Box_Hpdf( ::oPdfPage,700, ::nLinhaPdf-16, 60, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,701, ::nLinhaPdf - 1,  759, NIL, "C.E.P.", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )

      TRY                 && Modificado por Anderson  Camilo 15/02/2012
         hbNFe_Texto_Hpdf( ::oPdfPage,704, ::nLinhaPdf-5, 759, NIL, Transform(::aDest[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
      CATCH
      end
      // DATA DE SAIDA/ENTRADA
      hbNFe_Box_Hpdf( ::oPdfPage,760, ::nLinhaPdf-16, 70, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,761, ::nLinhaPdf - 1,  829, NIL, "DATA SAIDA/ENTRADA", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      TRY
         hbNFe_Texto_Hpdf( ::oPdfPage,761, ::nLinhaPdf-5, 829, NIL, Substr(::aIde[ "dSaiEnt" ],9,2)+"/" + Substr(::aIde[ "dSaiEnt" ],6,2)+"/" + Substr(::aIde[ "dSaiEnt" ],1,4), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
      CATCH
      END

      ::nLinhaPdf -= 16

      // MUNICIPIO
      hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-16, 410, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf - 1,  479, NIL, "MUNICIPIO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-5, 479, NIL, ::aDest[ "xMun" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
      // FONE/FAX
      hbNFe_Box_Hpdf( ::oPdfPage,480, ::nLinhaPdf-16, 150, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,481, ::nLinhaPdf - 1,  629, NIL, "FONE/FAX", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      IF LEN(::aDest[ "fone" ])=10
         hbNFe_Texto_Hpdf( ::oPdfPage,481, ::nLinhaPdf-5, 629, NIL, Transform(::aDest[ "fone" ], "@R (99) 99999-9999"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
      ELSEIF LEN(::aDest[ "fone" ])>10
         hbNFe_Texto_Hpdf( ::oPdfPage,481, ::nLinhaPdf-5, 629, NIL, Transform(::aDest[ "fone" ], "@R +99 (99) 99999-9999"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
      ENDIF
      // ESTADO
      hbNFe_Box_Hpdf( ::oPdfPage,630, ::nLinhaPdf-16, 30, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,631, ::nLinhaPdf - 1,  659, NIL, "ESTADO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,631, ::nLinhaPdf-5, 659, NIL, ::aDest[ "UF" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
      // INSC. EST.
      hbNFe_Box_Hpdf( ::oPdfPage,660, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,661, ::nLinhaPdf - 1,  759, NIL, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,661, ::nLinhaPdf-5, 759, NIL, ::aDest[ "IE" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
      // DATA DE SAIDA/ENTRADA
      hbNFe_Box_Hpdf( ::oPdfPage,760, ::nLinhaPdf-16, 70, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,761, ::nLinhaPdf - 1,  829, NIL, "HORA DE SAIDA", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,761, ::nLinhaPdf-5, 829, NIL, TIME(), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 17
   ELSE
      hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf, 589, NIL, "DESTINATÁRIO/REMETENTE", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalhoBold, 5 )

      ::nLinhaPdf -= 6

      // RAZAO SOCIAL
      hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-16, 415, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf - 1,  419, NIL, "NOME / RAZÃO SOCIAL", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5, 419, NIL, ::aDest[ "xNome" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
      // CNPJ/CPF
      hbNFe_Box_Hpdf( ::oPdfPage,420, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,421, ::nLinhaPdf - 1,  519, NIL, "CNPJ/CPF", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      IF !EMPTY(::aDest[ "CNPJ" ])
         hbNFe_Texto_Hpdf( ::oPdfPage,421, ::nLinhaPdf-5, 519, NIL, Transform(::aDest[ "CNPJ" ], "@R 99.999.999/9999-99"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 9 )
      ELSE
         IF ::aDest[ "CPF" ] <> NIL
            hbNFe_Texto_Hpdf( ::oPdfPage,421, ::nLinhaPdf-5, 519, NIL, Transform(::aDest[ "CPF" ], "@R 999.999.999-99"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         ENDIF
      ENDIF
      // DATA DE EMISSAO
      hbNFe_Box_Hpdf( ::oPdfPage,520, ::nLinhaPdf-16, 70, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,521, ::nLinhaPdf - 1,  589, NIL, "DATA DE EMISSÃO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,521, ::nLinhaPdf-5, 589, NIL, Substr(::aIde[ "dhEmi" ],9,2)+"/" + Substr(::aIde[ "dhEmi" ],6,2)+"/" + Substr(::aIde[ "dhEmi" ],1,4), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 16

      // ENDEREÇO
      hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-16, 265, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf - 1,  269, NIL, "ENDEREÇO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5, 269, NIL, ::aDest[ "xLgr" ]+" "+::aDest[ "nro" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 8 )
      // BAIRRO
      hbNFe_Box_Hpdf( ::oPdfPage,270, ::nLinhaPdf-16, 190, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf - 1,  459, NIL, "BAIRRO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-5, 459, NIL, ::aDest[ "xBairro" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
      // CEP
      hbNFe_Box_Hpdf( ::oPdfPage,460, ::nLinhaPdf-16, 60, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,461, ::nLinhaPdf - 1,  519, NIL, "C.E.P.", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      TRY
         hbNFe_Texto_Hpdf( ::oPdfPage,461, ::nLinhaPdf-5, 519, NIL, Transform(::aDest[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
      CATCH
      END
      // DATA DE SAIDA/ENTRADA
      hbNFe_Box_Hpdf( ::oPdfPage,520, ::nLinhaPdf-16, 70, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,521, ::nLinhaPdf - 1,  589, NIL, "DATA SAIDA/ENTRADA", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      TRY
         hbNFe_Texto_Hpdf( ::oPdfPage,521, ::nLinhaPdf-5, 589, NIL, Substr(::aIde[ "dhSaiEnt" ],9,2)+"/" + Substr(::aIde[ "dhSaiEnt" ],6,2)+"/" + Substr(::aIde[ "dhSaiEnt" ],1,4), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
      CATCH
      END

      ::nLinhaPdf -= 16

      // MUNICIPIO
      hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-16, 245, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf - 1,  249, NIL, "MUNICIPIO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5, 249, NIL, ::aDest[ "xMun" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
      // FONE/FAX
      hbNFe_Box_Hpdf( ::oPdfPage,250, ::nLinhaPdf-16, 150, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,251, ::nLinhaPdf - 1,  399, NIL, "FONE/FAX", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      IF LEN(::aDest[ "fone" ])=10
         hbNFe_Texto_Hpdf( ::oPdfPage,251, ::nLinhaPdf-5, 399, NIL, Transform(::aDest[ "fone" ], "@R (99) 99999-9999"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
      ELSEIF LEN(::aDest[ "fone" ])>10
         hbNFe_Texto_Hpdf( ::oPdfPage,251, ::nLinhaPdf-5, 399, NIL, Transform(::aDest[ "fone" ], "@R +99 (99) 99999-9999"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
      ENDIF
      // ESTADO
      hbNFe_Box_Hpdf( ::oPdfPage,400, ::nLinhaPdf-16, 30, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,401, ::nLinhaPdf - 1,  429, NIL, "ESTADO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,401, ::nLinhaPdf-5, 429, NIL, ::aDest[ "UF" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
      // INSC. EST.
      hbNFe_Box_Hpdf( ::oPdfPage,430, ::nLinhaPdf-16, 90, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,431, ::nLinhaPdf - 1,  519, NIL, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,431, ::nLinhaPdf-5, 519, NIL, ::aDest[ "IE" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
      // DATA DE SAIDA/ENTRADA
      hbNFe_Box_Hpdf( ::oPdfPage,520, ::nLinhaPdf-16, 70, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,521, ::nLinhaPdf - 1,  589, NIL, "HORA DE SAIDA", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,521, ::nLinhaPdf-5, 589, NIL, Substr(::aIde[ "dhSaiEnt" ],12,8), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 17
   ENDIF

   RETURN NIL

METHOD duplicatas() CLASS hbNFeDanfe

   LOCAL nICob, nItensCob, nLinhaFinalCob, nTamanhoCob

   IF ::nFolha = 1
      IF ::lPaisagem = .T. // paisagem
         hbNFe_Texto_Hpdf( ::oPdfPage,70, ::nLinhaPdf, 760, NIL, "FATURA/DUPLICATAS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalhoBold, 5 )
         ::nLinhaPdf -= 6

         IF EMPTY(::cCobranca)
             // FATURAS
             hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-12, 760, 12, ::nLarguraBox )
             IF ::aIde[ "indPag" ] == "0"
                hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf - 1,  824, NIL, "PAGAMENTO À VISTA", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
             ELSEIF ::aIde[ "indPag" ] == "1"    && Alterado por Anderson Camilo em 31/07/2012
                hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf - 1,  824, NIL, "PAGAMENTO À PRAZO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
             ELSE
                hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf - 1,  824, NIL, "OUTROS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
             ENDIF
             ::nLinhaPdf -= 13
          ELSE
             nICob := LEN(HB_ATokens( ::cCobranca, "<dup>", .F., .F. ))-1
             IF nICob < 0
                nICob := 0
             ENDIF
             nItensCob := INT(nIcob/4)+IF((nIcob/4)-INT((nICob/4))>0,1,0)+1
            nLinhaFinalCob := ::nLinhaPdf-(nItensCob*7)-2
            nTamanhoCob := (nItensCob*7)+2
             ::cabecalhoCobranca(nLinhaFinalCob,nTamanhoCob)
            ::faturas()
            ::nLinhaPdf -= 4 //ESPAÇO
         ENDIF
     ELSE
         hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf, 589, NIL, "FATURA/DUPLICATAS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalhoBold, 5 )
         ::nLinhaPdf -= 6

         IF EMPTY(::cCobranca)
             // FATURAS
             hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-12, 585, 12, ::nLarguraBox )
             IF ::aIde[ "indPag" ] == "0"
                hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf - 1,  589, NIL, "PAGAMENTO À VISTA", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
             ELSEIF ::aIde[ "indPag" ] == "1"    && Alterado por Anderson Camilo em 31/07/2012
                hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf - 1,  589, NIL, "PAGAMENTO À PRAZO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
             ELSE
                hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf - 1,  589, NIL, "OUTROS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
             ENDIF
              ::nLinhaPdf -= 13
          ELSE
             nICob := LEN(HB_ATokens( ::cCobranca, "<dup>", .F., .F. ))-1
             IF nICob < 0
                nICob := 0
             ENDIF
             nItensCob := INT(nIcob/3)+IF((nIcob/3)-INT((nICob/3))>0,1,0)+1
            nLinhaFinalCob := ::nLinhaPdf-(nItensCob*7)-2
            nTamanhoCob := (nItensCob*7)+2
             ::cabecalhoCobranca(nLinhaFinalCob,nTamanhoCob)
            ::faturas()
            ::nLinhaPdf -= 4 //ESPAÇO
         ENDIF
      ENDIF
   ENDIF

   RETURN NIL

METHOD cabecalhoCobranca(nLinhaFinalCob,nTamanhoCob) CLASS hbNFeDanfe

   LOCAL nTamForm

   IF ::nFolha = 1
      IF ::lPaisagem = .T. // paisagem
         nTamForm := 830-70

         // COLUNA 1
         hbNFe_Box_Hpdf(  ::oPdfPage, 70, nLinhaFinalCob, ((nTamForm ) / 4 ), nTamanhoCob, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 1,  126, NIL, "NÚMERO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,128, ::nLinhaPdf - 1,  183, NIL, "VENCIMENTO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,185, ::nLinhaPdf - 1,  259, NIL, "VALOR", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         // COLUNA 2
         hbNFe_Box_Hpdf( ::oPdfPage, 70 + ( ( nTamForm ) / 4 ), nLinhaFinalCob, ((nTamForm ) / 4 ), nTamanhoCob, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 71 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1, 126 + ( ( nTamForm ) / 4 ), NIL, "NÚMERO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,128 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1, 183 + ( ( nTamForm ) / 4 ), NIL, "VENCIMENTO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,185 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1, 259 + ( ( nTamForm ) / 4 ), NIL, "VALOR", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         // COLUNA 3
         hbNFe_Box_Hpdf( ::oPdfPage, 70 + ( ( ( nTamForm ) / 4 ) * 2 ), nLinhaFinalCob, ((nTamForm ) / 4 ), nTamanhoCob, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 71 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1, 126 + ( ( ( nTamForm ) / 4 ) * 2 ), NIL, "NÚMERO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,128 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1, 183 + ( ( ( nTamForm ) / 4 ) * 2 ), NIL, "VENCIMENTO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,185 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1, 259 + ( ( ( nTamForm ) / 4 ) * 2 ), NIL, "VALOR", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         // COLUNA 4
         hbNFe_Box_Hpdf( ::oPdfPage, 70 + ( ( ( nTamForm ) / 4 ) * 3 ), nLinhaFinalCob, ((nTamForm ) / 4 ), nTamanhoCob, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 71 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1, 126 + ( ( ( nTamForm ) / 4 ) * 3 ), NIL, "NÚMERO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,128 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1, 183 + ( ( ( nTamForm ) / 4 ) * 3 ), NIL, "VENCIMENTO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,185 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1, 259 + ( ( ( nTamForm ) / 4 ) * 3 ), NIL, "VALOR", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         ::nLinhaPdf -= 6

         // COLUNA 1
         hbNFe_Line_Hpdf(  ::oPdfPage, 71, ::nLinhaPdf-1.5, 126, ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,128, ::nLinhaPdf-1.5, 183, ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,185, ::nLinhaPdf-1.5, 259, ::nLinhaPdf-1.5, ::nLarguraBox)
         // COLUNA 2
         hbNFe_Line_Hpdf(  ::oPdfPage, 71 + ( ( nTamForm ) / 4 ), ::nLinhaPdf-1.5, 126 + ( ( nTamForm ) / 4 ), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,128 + ( ( nTamForm ) / 4 ), ::nLinhaPdf-1.5, 183 + ( ( nTamForm ) / 4 ), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,185 + ( ( nTamForm ) / 4 ), ::nLinhaPdf-1.5, 259 + ( ( nTamForm ) / 4 ), ::nLinhaPdf-1.5, ::nLarguraBox)
         // COLUNA 3
         hbNFe_Line_Hpdf(  ::oPdfPage, 71 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf-1.5, 126 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,128 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf-1.5, 183 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,185 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf-1.5, 259 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf-1.5, ::nLarguraBox)
         // COLUNA 4
         hbNFe_Line_Hpdf(  ::oPdfPage, 71 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf-1.5, 126 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,128 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf-1.5, 183 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,185 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf-1.5, 259 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf-1.5, ::nLarguraBox)

         ::nLinhaPdf -= 2 //ESPAÇO
      ELSE
         nTamForm := 585

         // COLUNA 1
         hbNFe_Box_Hpdf(  ::oPdfPage, 5, nLinhaFinalCob, ((nTamForm)/3), nTamanhoCob, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf - 1,   61, NIL, "NÚMERO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 63, ::nLinhaPdf - 1,  118, NIL, "VENCIMENTO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,120, ::nLinhaPdf - 1,  195, NIL, "VALOR", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         // COLUNA 2
         hbNFe_Box_Hpdf( ::oPdfPage, 5 + ( ( nTamForm)/3), nLinhaFinalCob, ((nTamForm)/3), nTamanhoCob, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,  6 + ( ( nTamForm)/3), ::nLinhaPdf - 1,  61 + ( ( nTamForm)/3), NIL, "NÚMERO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 63 + ( ( nTamForm)/3), ::nLinhaPdf - 1, 118 + ( ( nTamForm)/3), NIL, "VENCIMENTO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,120 + ( ( nTamForm)/3), ::nLinhaPdf - 1, 195 + ( ( nTamForm)/3), NIL, "VALOR", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         // COLUNA 3
         hbNFe_Box_Hpdf( ::oPdfPage, 5 + ( ( ( nTamForm)/3) * 2 ), nLinhaFinalCob, ((nTamForm)/3), nTamanhoCob, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,  6 + ( ( ( nTamForm)/3) * 2 ), ::nLinhaPdf - 1,  61 + ( ( ( nTamForm)/3) * 2 ), NIL, "NÚMERO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 63 + ( ( ( nTamForm)/3) * 2 ), ::nLinhaPdf - 1, 118 + ( ( ( nTamForm)/3) * 2 ), NIL, "VENCIMENTO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,120 + ( ( ( nTamForm)/3) * 2 ), ::nLinhaPdf - 1, 195 + ( ( ( nTamForm)/3) * 2 ), NIL, "VALOR", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         ::nLinhaPdf -= 6

         // COLUNA 1
         hbNFe_Line_Hpdf(  ::oPdfPage,  6, ::nLinhaPdf-1.5,  61, ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage, 63, ::nLinhaPdf-1.5, 118, ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,120, ::nLinhaPdf-1.5, 195, ::nLinhaPdf-1.5, ::nLarguraBox)
         // COLUNA 2
         hbNFe_Line_Hpdf(  ::oPdfPage,  6 + ( ( nTamForm)/3), ::nLinhaPdf-1.5,  61 + ( ( nTamForm)/3), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage, 63 + ( ( nTamForm)/3), ::nLinhaPdf-1.5, 118 + ( ( nTamForm)/3), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,120 + ( ( nTamForm)/3), ::nLinhaPdf-1.5, 195 + ( ( nTamForm)/3), ::nLinhaPdf-1.5, ::nLarguraBox)
         // COLUNA 3
         hbNFe_Line_Hpdf(  ::oPdfPage,  6 + ( ( ( nTamForm)/3) * 2 ), ::nLinhaPdf-1.5,  61 + ( ( ( nTamForm)/3) * 2 ), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage, 63 + ( ( ( nTamForm)/3) * 2 ), ::nLinhaPdf-1.5, 118 + ( ( ( nTamForm)/3) * 2 ), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,120 + ( ( ( nTamForm)/3) * 2 ), ::nLinhaPdf-1.5, 195 + ( ( ( nTamForm)/3) * 2 ), ::nLinhaPdf-1.5, ::nLarguraBox)

         ::nLinhaPdf -= 2 //ESPAÇO
      ENDIF
   ENDIF

   RETURN NIL

METHOD faturas() CLASS hbNFeDanfe

   LOCAL nTamForm, cDups, nColuna, cDup, cNumero, cVencimento, cValor // ////////////////////////// nI

   IF ::nFolha = 1
      IF ::lPaisagem = .T. // paisagem
         nTamForm := 830-70

         cDups := ::cCobranca
         nColuna := 0
         DO WHILE AT("<dup>", cDups) > 0
            nColuna ++
            cDup := hbNFe_PegaDadosXml( "dup", cDups )

            cNumero := hbNFe_PegaDadosXml( "nDup", cDup )
            IF !EMPTY(cNumero)
               cVencimento := hbNFe_PegaDadosXml( "dVenc", cDup )
               cVencimento := Substr(cVencimento,9,2)+"/" + Substr(cVencimento,6,2)+"/" + Substr(cVencimento,1,4)
               cValor := AllTrim( FormatNumber( Val(hbNFe_PegaDadosXml( "vDup", cDup )),13,2))
            ELSE
               nColuna --
               EXIT
            ENDIF
            IF nColuna = 1
               hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 1,  126, NIL, cNumero, HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
               hbNFe_Texto_Hpdf( ::oPdfPage,128, ::nLinhaPdf - 1,  183, NIL, cVencimento, HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 7 )
               hbNFe_Texto_Hpdf( ::oPdfPage,185, ::nLinhaPdf - 1,  259, NIL, cValor, HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 7 )
            ELSEIF nColuna = 2
               hbNFe_Texto_Hpdf( ::oPdfPage, 71 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1, 126 + ( ( nTamForm ) / 4 ), NIL, cNumero, HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
               hbNFe_Texto_Hpdf( ::oPdfPage,128 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1, 183 + ( ( nTamForm ) / 4 ), NIL, cVencimento, HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 7 )
               hbNFe_Texto_Hpdf( ::oPdfPage,185 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1, 259 + ( ( nTamForm ) / 4 ), NIL, cValor, HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 7 )
            ELSEIF nColuna = 3
               hbNFe_Texto_Hpdf( ::oPdfPage, 71 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1, 126 + ( ( ( nTamForm ) / 4 ) * 2 ), NIL, cNumero, HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
               hbNFe_Texto_Hpdf( ::oPdfPage,128 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1, 183 + ( ( ( nTamForm ) / 4 ) * 2 ), NIL, cVencimento, HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 7 )
               hbNFe_Texto_Hpdf( ::oPdfPage,185 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1, 259 + ( ( ( nTamForm ) / 4 ) * 2 ), NIL, cValor, HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 7 )
            ELSEIF nColuna = 4
               hbNFe_Texto_Hpdf( ::oPdfPage, 71 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1, 126 + ( ( ( nTamForm ) / 4 ) * 3 ), NIL, cNumero, HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
               hbNFe_Texto_Hpdf( ::oPdfPage,128 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1, 183 + ( ( ( nTamForm ) / 4 ) * 3 ), NIL, cVencimento, HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 7 )
               hbNFe_Texto_Hpdf( ::oPdfPage,185 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1, 259 + ( ( ( nTamForm ) / 4 ) * 3 ), NIL, cValor, HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 7 )
               ::nLinhaPdf -= 7
               nColuna := 0
            ENDIF
            cDups := Substr(cDups,AT("</dup>",::cCobranca)+1)
         ENDDO
         IF nColuna > 0
            ::nLinhaPdf -= 7
         ENDIF

      ELSE
         nTamForm := 585

         cDups := ::cCobranca
         nColuna := 0
         DO WHILE AT("<dup>", cDups) > 0
            nColuna ++
            cDup := hbNFe_PegaDadosXml( "dup", cDups )

            cNumero := hbNFe_PegaDadosXml( "nDup", cDup )
            IF !EMPTY(cNumero)
               cVencimento := hbNFe_PegaDadosXml( "dVenc", cDup )
               cVencimento := Substr(cVencimento,9,2)+"/" + Substr(cVencimento,6,2)+"/" + Substr(cVencimento,1,4)
               cValor := AllTrim( FormatNumber( Val(hbNFe_PegaDadosXml( "vDup", cDup )),13,2))
            ELSE
               nColuna --
               EXIT
            ENDIF
            IF nColuna = 1
               hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf - 1,   61, NIL, cNumero, HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
               hbNFe_Texto_Hpdf( ::oPdfPage, 63, ::nLinhaPdf - 1,  118, NIL, cVencimento, HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 7 )
               hbNFe_Texto_Hpdf( ::oPdfPage,120, ::nLinhaPdf - 1,  195, NIL, cValor, HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 7 )
            ELSEIF nColuna = 2
               hbNFe_Texto_Hpdf( ::oPdfPage,  6 + ( ( nTamForm)/3), ::nLinhaPdf - 1,  61 + ( ( nTamForm)/3), NIL, cNumero, HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
               hbNFe_Texto_Hpdf( ::oPdfPage, 63 + ( ( nTamForm)/3), ::nLinhaPdf - 1, 118 + ( ( nTamForm)/3), NIL, cVencimento, HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 7 )
               hbNFe_Texto_Hpdf( ::oPdfPage,120 + ( ( nTamForm)/3), ::nLinhaPdf - 1, 195 + ( ( nTamForm)/3), NIL, cValor, HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 7 )
            ELSEIF nColuna = 3
               hbNFe_Texto_Hpdf( ::oPdfPage,  6 + ( ( ( nTamForm)/3) * 2 ), ::nLinhaPdf - 1,  61 + ( ( ( nTamForm)/3) * 2 ), NIL, cNumero, HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
               hbNFe_Texto_Hpdf( ::oPdfPage, 63 + ( ( ( nTamForm)/3) * 2 ), ::nLinhaPdf - 1, 118 + ( ( ( nTamForm)/3) * 2 ), NIL, cVencimento, HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 7 )
               hbNFe_Texto_Hpdf( ::oPdfPage,120 + ( ( ( nTamForm)/3) * 2 ), ::nLinhaPdf - 1, 195 + ( ( ( nTamForm)/3) * 2 ), NIL, cValor, HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 7 )
               ::nLinhaPdf -= 7
               nColuna := 0
            ENDIF
            cDups := Substr(cDups,AT("</dup>",::cCobranca)+1)
         ENDDO
         IF nColuna > 0
            ::nLinhaPdf -= 7
         ENDIF

      ENDIF
   ENDIF

   RETURN NIL

METHOD dadosImposto() CLASS hbNFeDanfe

   IF ::nFolha = 1
      IF ::lPaisagem = .T. // paisagem
         hbNFe_Texto_Hpdf( ::oPdfPage,70, ::nLinhaPdf, 830, NIL, "CÁLCULO DO IMPOSTO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalhoBold, 5 )

         ::nLinhaPdf -= 6

         // BASE DE CALCULO DO ICMS
         hbNFe_Box_Hpdf( ::oPdfPage,70, ::nLinhaPdf-16, 145, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf - 1,  149, NIL, "BASE DE CÁLCULO DO ICMS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-5, 149, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vBC" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // VALOR ICMS
         hbNFe_Box_Hpdf( ::oPdfPage,215, ::nLinhaPdf-16, 135, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,216, ::nLinhaPdf - 1,  349, NIL, "VALOR DO ICMS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,216, ::nLinhaPdf-5, 349, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vICMS" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // BASE DE CALCULO DO ICMS ST
         hbNFe_Box_Hpdf( ::oPdfPage,350, ::nLinhaPdf-16, 165, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,351, ::nLinhaPdf - 1,  514, NIL, "BASE DE CÁLCULO DO ICMS SUBS. TRIB.", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,351, ::nLinhaPdf-5, 514, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vBCST" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // VALOR ICMS ST
         hbNFe_Box_Hpdf( ::oPdfPage,515, ::nLinhaPdf-16, 135, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,516, ::nLinhaPdf - 1,  649, NIL, "VALOR DO ICMS SUBST.", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,516, ::nLinhaPdf-5, 649, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vST" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // VALOR TOTAL DOS PRODUTOS
         hbNFe_Box_Hpdf( ::oPdfPage,650, ::nLinhaPdf-16, 180, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,651, ::nLinhaPdf - 1,  829, NIL, "VALOR TOTAL DOS PRODUTOS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,651, ::nLinhaPdf-5, 8299, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vProd" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 16

         // VALOR DO FRETE
         hbNFe_Box_Hpdf( ::oPdfPage,70, ::nLinhaPdf-16,116, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf - 1, 185, NIL, "VALOR DO FRETE", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-5,185, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vFrete" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // VALOR DO SEGURO
         hbNFe_Box_Hpdf( ::oPdfPage,186, ::nLinhaPdf-16,116, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,187, ::nLinhaPdf - 1,  301, NIL, "VALOR DO SEGURO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,187, ::nLinhaPdf-5, 301, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vSeg" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // DESCONTO
         hbNFe_Box_Hpdf( ::oPdfPage,302, ::nLinhaPdf-16,116, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,303, ::nLinhaPdf - 1,  417, NIL, "DESCONTO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,303, ::nLinhaPdf-5, 417, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vDesc" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // OUTRAS DESP. ACESSO.
         hbNFe_Box_Hpdf( ::oPdfPage,418, ::nLinhaPdf-16,116, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,419, ::nLinhaPdf - 1,  533, NIL, "OUTRAS DESP. ACESSÓRIAS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,419, ::nLinhaPdf-5, 533, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vOutro" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // VALOR DO IPI
         hbNFe_Box_Hpdf( ::oPdfPage,534, ::nLinhaPdf-16,116, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,535, ::nLinhaPdf - 1,  649, NIL, "VALOR DO IPI", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,535, ::nLinhaPdf-5, 649, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vIPI" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // VALOR TOTAL DA NF
         hbNFe_Box_Hpdf( ::oPdfPage,650, ::nLinhaPdf-16, 180, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,651, ::nLinhaPdf - 1,  829, NIL, "VALOR TOTAL DA NOTA FISCAL", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,651, ::nLinhaPdf-5, 829, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vNF" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 17
      ELSE
         hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf, 589, NIL, "CÁLCULO DO IMPOSTO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalhoBold, 5 )

         ::nLinhaPdf -= 6

         // BASE DE CALCULO DO ICMS
         hbNFe_Box_Hpdf( ::oPdfPage, 5, ::nLinhaPdf-16, 110, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf - 1,  114, NIL, "BASE DE CÁLCULO DO ICMS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5, 114, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vBC" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // VALOR ICMS
         hbNFe_Box_Hpdf( ::oPdfPage,115, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,116, ::nLinhaPdf - 1,  214, NIL, "VALOR DO ICMS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,116, ::nLinhaPdf-5, 214, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vICMS" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // BASE DE CALCULO DO ICMS ST
         hbNFe_Box_Hpdf( ::oPdfPage,215, ::nLinhaPdf-16, 130, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,216, ::nLinhaPdf - 1,  344, NIL, "BASE DE CÁLCULO DO ICMS SUBS. TRIB.", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,216, ::nLinhaPdf-5, 344, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vBCST" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // VALOR ICMS ST
         hbNFe_Box_Hpdf( ::oPdfPage,345, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,346, ::nLinhaPdf - 1,  444, NIL, "VALOR DO ICMS SUBST.", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,346, ::nLinhaPdf-5, 444, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vST" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // VALOR TOTAL DOS PRODUTOS
         hbNFe_Box_Hpdf( ::oPdfPage,445, ::nLinhaPdf-16, 145, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,446, ::nLinhaPdf - 1,  589, NIL, "VALOR TOTAL DOS PRODUTOS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,446, ::nLinhaPdf-5, 589, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vProd" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 16

         // VALOR DO FRETE
         hbNFe_Box_Hpdf( ::oPdfPage, 5, ::nLinhaPdf-16, 88, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf - 1,  92, NIL, "VALOR DO FRETE", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5, 92, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vFrete" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // VALOR DO SEGURO
         hbNFe_Box_Hpdf( ::oPdfPage,93, ::nLinhaPdf-16, 88, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,94, ::nLinhaPdf - 1,  180, NIL, "VALOR DO SEGURO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,94, ::nLinhaPdf-5, 180, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vSeg" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // DESCONTO
         hbNFe_Box_Hpdf( ::oPdfPage,181, ::nLinhaPdf-16, 88, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,182, ::nLinhaPdf - 1,  268, NIL, "DESCONTO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,182, ::nLinhaPdf-5, 268, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vDesc" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // OUTRAS DESP. ACESSO.
         hbNFe_Box_Hpdf( ::oPdfPage,269, ::nLinhaPdf-16, 88, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,270, ::nLinhaPdf - 1,  356, NIL, "OUTRAS DESP. ACESSÓRIAS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,270, ::nLinhaPdf-5, 356, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vOutro" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // VALOR DO IPI
         hbNFe_Box_Hpdf( ::oPdfPage,357, ::nLinhaPdf-16, 88, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,358, ::nLinhaPdf - 1,  444, NIL, "VALOR DO IPI", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,358, ::nLinhaPdf-5, 444, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vIPI" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // VALOR TOTAL DA NF
         hbNFe_Box_Hpdf( ::oPdfPage,445, ::nLinhaPdf-16, 145, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,446, ::nLinhaPdf - 1,  589, NIL, "VALOR TOTAL DA NOTA FISCAL", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,446, ::nLinhaPdf-5, 589, NIL, AllTrim( FormatNumber( Val(::aICMSTotal[ "vNF" ]),15,2)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 17
      ENDIF
   ENDIF

   RETURN NIL

METHOD dadosTransporte() CLASS hbNFeDanfe

   IF ::nFolha = 1
      IF ::lPaisagem = .T. // paisagem
         hbNFe_Texto_Hpdf( ::oPdfPage,70, ::nLinhaPdf, 830, NIL, "TRANSPORTADOR / VOLUMES TRANSPORTADOS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalhoBold, 5 )

         ::nLinhaPdf -= 6

         // NOME/RAZAO SOCIAL
         hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-16, 440, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf - 1,  509, NIL, "NOME/RAZÃO SOCIAL", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-7, 509, NIL, ::aTransp[ "xNome" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 8 )
         // TIPO FRETE
         hbNFe_Box_Hpdf( ::oPdfPage,510, ::nLinhaPdf-16, 90, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf - 1,  599, NIL, "FRETE POR CONTA", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         && Modificado por Anderson Camilo em 19/03/2012
         IF ::aTransp[ "modFrete" ] == "0"
            hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-5, 599, NIL, "0-EMITENTE", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         ELSEIF ::aTransp[ "modFrete" ] == "1"
            hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-5, 599, NIL, "1-DESTINATARIO", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         ELSEIF ::aTransp[ "modFrete" ] == "2"
            hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-5, 599, NIL, "2-TERCEIROS", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         ELSEIF ::aTransp[ "modFrete" ] == "9"
            hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-5, 599, NIL, "9-SEM FRETE", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
        ENDIF
         // ANTT
         hbNFe_Box_Hpdf( ::oPdfPage,600, ::nLinhaPdf-16, 60, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,601, ::nLinhaPdf - 1,  659, NIL, "CÓDIGO ANTT", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,601, ::nLinhaPdf-5, 659, NIL, ::aVeicTransp[ "RNTC" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         // PLACA
         hbNFe_Box_Hpdf( ::oPdfPage,660, ::nLinhaPdf-16, 60, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,661, ::nLinhaPdf - 1,  719, NIL, "PLACA DO VEÍCULO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,661, ::nLinhaPdf-5, 719, NIL, ::aVeicTransp[ "placa" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         // UF
         hbNFe_Box_Hpdf( ::oPdfPage,720, ::nLinhaPdf-16, 20, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,721, ::nLinhaPdf - 1,  739, NIL, "UF", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,721, ::nLinhaPdf-5, 739, NIL, ::aVeicTransp[ "UF" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         // CNPJ/CPF
         hbNFe_Box_Hpdf( ::oPdfPage,740, ::nLinhaPdf-16, 90, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,741, ::nLinhaPdf - 1,  829, NIL, "CNPJ / CPF", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         IF !EMPTY(::aTransp[ "CNPJ" ])
            hbNFe_Texto_Hpdf( ::oPdfPage,741, ::nLinhaPdf-7, 829, NIL, Transform(::aTransp[ "CNPJ" ], "@R 99.999.999/9999-99"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 8 )
         ELSE
            IF ::aTransp[ "CPF" ] <> NIL
               hbNFe_Texto_Hpdf( ::oPdfPage,741, ::nLinhaPdf-5, 829, NIL, Transform(::aTransp[ "CPF" ], "@R 999.999.999-99"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
            ENDIF
         ENDIF

         ::nLinhaPdf -= 16

         // ENDEREÇO
         hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-16, 440, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf - 1,  509, NIL, "ENDEREÇO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-7, 509, NIL, ::aTransp[ "xEnder" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 8 )
         // MUNICIPIO
         hbNFe_Box_Hpdf( ::oPdfPage,510, ::nLinhaPdf-16, 210, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf - 1,  719, NIL, "MUNICÍPIO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-5, 719, NIL, ::aTransp[ "xMun" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
         // UF
         hbNFe_Box_Hpdf( ::oPdfPage,720, ::nLinhaPdf-16, 20, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,721, ::nLinhaPdf - 1,  739, NIL, "UF", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,721, ::nLinhaPdf-5, 739, NIL, ::aTransp[ "UF" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         // I.E.
         hbNFe_Box_Hpdf( ::oPdfPage,740, ::nLinhaPdf-16, 90, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,741, ::nLinhaPdf - 1,  829, NIL, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,741, ::nLinhaPdf-5, 829, NIL, ::aTransp[ "IE" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 16

         // QUANTIDADE VOLUME
         hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-16,130, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf - 1, 199, NIL, "QUANTIDADE", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-5,199, NIL, Ltrim( FormatNumber( Val( ::aTransp[ "qVol" ] ), 15, 0 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 8 )
         // ESPECIE
         hbNFe_Box_Hpdf( ::oPdfPage,200, ::nLinhaPdf-16, 130, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,201, ::nLinhaPdf - 1,  329, NIL, "ESPÉCIE", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,201, ::nLinhaPdf-5, 329, NIL, ::aTransp[ "esp" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         // MARCA
         hbNFe_Box_Hpdf( ::oPdfPage,330, ::nLinhaPdf-16, 120, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,331, ::nLinhaPdf - 1,  449, NIL, "MARCA", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,331, ::nLinhaPdf-5, 449, NIL, ::aTransp[ "marca" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         // NUMERACAO
         hbNFe_Box_Hpdf( ::oPdfPage,450, ::nLinhaPdf-16, 120, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,451, ::nLinhaPdf - 1,  569, NIL, "NUMERAÇÃO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,451, ::nLinhaPdf-5, 569, NIL, ::aTransp[ "nVol" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         // PESO BRUTO
         hbNFe_Box_Hpdf( ::oPdfPage,570, ::nLinhaPdf-16, 130, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,571, ::nLinhaPdf - 1,  699, NIL, "PESO BRUTO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,571, ::nLinhaPdf-5, 699, NIL, Ltrim( FormatNumber( Val( ::aTransp[ "pesoB" ] ), 15, 3 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // PESO LÍQUIDO
         hbNFe_Box_Hpdf( ::oPdfPage,700, ::nLinhaPdf-16,130, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,701, ::nLinhaPdf - 1,  829, NIL, "PESO LÍQUIDO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,701, ::nLinhaPdf-5, 829, NIL, Ltrim( FormatNumber( Val( ::aTransp[ "pesoL" ] ), 15, 3 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 17
      ELSE
         hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf, 589, NIL, "TRANSPORTADOR / VOLUMES TRANSPORTADOS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalhoBold, 5 )

         ::nLinhaPdf -= 6

         // NOME/RAZAO SOCIAL
         hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-16, 265, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf - 1,  269, NIL, "NOME/RAZÃO SOCIAL", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5, 269, NIL, ::aTransp[ "xNome" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 8 )
         // TIPO FRETE
         hbNFe_Box_Hpdf( ::oPdfPage,270, ::nLinhaPdf-16, 90, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf - 1,  359, NIL, "FRETE POR CONTA", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         && Modificado por Anderson Camilo em 19/03/2012
         IF ::aTransp[ "modFrete" ] == "0"
            hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-5, 359, NIL, "0-EMITENTE", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         ELSEIF ::aTransp[ "modFrete" ] == "1"
            hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-5, 359, NIL, "1-DESTINATARIO", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         ELSEIF ::aTransp[ "modFrete" ] == "2"
            hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-5, 359, NIL, "2-TERCEIROS", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         ELSEIF ::aTransp[ "modFrete" ] == "9"
            hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-5, 359, NIL, "9-SEM FRETE", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         ENDIF
         // ANTT
         hbNFe_Box_Hpdf( ::oPdfPage,360, ::nLinhaPdf-16, 60, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,361, ::nLinhaPdf - 1,  419, NIL, "CÓDIGO ANTT", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,361, ::nLinhaPdf-5, 419, NIL, ::aVeicTransp[ "RNTC" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         // PLACA
         hbNFe_Box_Hpdf( ::oPdfPage,420, ::nLinhaPdf-16, 60, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,421, ::nLinhaPdf - 1,  479, NIL, "PLACA DO VEÍCULO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,421, ::nLinhaPdf-5, 479, NIL, ::aVeicTransp[ "placa" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         // UF
         hbNFe_Box_Hpdf( ::oPdfPage,480, ::nLinhaPdf-16, 20, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,481, ::nLinhaPdf - 1,  499, NIL, "UF", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,481, ::nLinhaPdf-5, 499, NIL, ::aVeicTransp[ "UF" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         // CNPJ/CPF
         hbNFe_Box_Hpdf( ::oPdfPage,500, ::nLinhaPdf-16, 90, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,501, ::nLinhaPdf - 1,  589, NIL, "CNPJ / CPF", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         IF !EMPTY(::aTransp[ "CNPJ" ])
            hbNFe_Texto_Hpdf( ::oPdfPage,501, ::nLinhaPdf-5, 589, NIL, Transform(::aTransp[ "CNPJ" ], "@R 99.999.999/9999-99"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         ELSE
            IF ::aTransp[ "CPF" ] <> NIL
               hbNFe_Texto_Hpdf( ::oPdfPage,501, ::nLinhaPdf-5, 589, NIL, Transform(::aTransp[ "CPF" ], "@R 999.999.999-99"), HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
            ENDIF
         ENDIF

         ::nLinhaPdf -= 16

         // ENDEREÇO
         hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-16, 265, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf - 1,  269, NIL, "ENDEREÇO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5, 269, NIL, ::aTransp[ "xEnder" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 8 )
         // MUNICIPIO
         hbNFe_Box_Hpdf( ::oPdfPage,270, ::nLinhaPdf-16, 210, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf - 1,  479, NIL, "MUNICÍPIO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-5, 479, NIL, ::aTransp[ "xMun" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 10 )
         // UF
         hbNFe_Box_Hpdf( ::oPdfPage,480, ::nLinhaPdf-16, 20, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,481, ::nLinhaPdf - 1,  499, NIL, "UF", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,481, ::nLinhaPdf-5, 499, NIL, ::aTransp[ "UF" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         // I.E.
         hbNFe_Box_Hpdf( ::oPdfPage,500, ::nLinhaPdf-16, 90, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,501, ::nLinhaPdf - 1,  589, NIL, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,501, ::nLinhaPdf-5, 589, NIL, ::aTransp[ "IE" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 16

         // QUANTIDADE VOLUME
         hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-16, 95, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf - 1,  99, NIL, "QUANTIDADE", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5, 99, NIL, Ltrim( FormatNumber( Val( ::aTransp[ "qVol" ] ), 15, 0 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 8 )
         // ESPECIE
         hbNFe_Box_Hpdf( ::oPdfPage,100, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,101, ::nLinhaPdf - 1,  199, NIL, "ESPÉCIE", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,101, ::nLinhaPdf-5, 199, NIL, ::aTransp[ "esp" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         // MARCA
         hbNFe_Box_Hpdf( ::oPdfPage,200, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,201, ::nLinhaPdf - 1,  299, NIL, "MARCA", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,201, ::nLinhaPdf-5, 299, NIL, ::aTransp[ "marca" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         // NUMERACAO
         hbNFe_Box_Hpdf( ::oPdfPage,300, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,301, ::nLinhaPdf - 1,  399, NIL, "NUMERAÇÃO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,301, ::nLinhaPdf-5, 399, NIL, ::aTransp[ "nVol" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 10 )
         // PESO BRUTO
         hbNFe_Box_Hpdf( ::oPdfPage,400, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,401, ::nLinhaPdf - 1,  499, NIL, "PESO BRUTO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,401, ::nLinhaPdf-5, 499, NIL, LTrim( FormatNumber( Val( ::aTransp[ "pesoB" ] ), 15, 3 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
         // PESO LÍQUIDO
         hbNFe_Box_Hpdf( ::oPdfPage,500, ::nLinhaPdf-16, 90, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,501, ::nLinhaPdf - 1,  589, NIL, "PESO LÍQUIDO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,501, ::nLinhaPdf-5, 589, NIL, Ltrim( FormatNumber( Val( ::aTransp[ "pesoL" ] ), 15, 3 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 17
      ENDIF
   ENDIF

   RETURN NIL

METHOD cabecalhoProdutos() CLASS hbNFeDanfe

   IF ::lPaisagem = .T. // paisagem
      hbNFe_Texto_Hpdf( ::oPdfPage,70, ::nLinhaPdf, 830, NIL, "DADOS DOS PRODUTOS / SERVIÇOS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalhoBold, 5 )
      ::nLinhaPdf -= 6

      // CODIGO
      hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-13, 55, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf - 1, 124, NIL, "CÓDIGO", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-6,124, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      // DESCRI
      hbNFe_Box_Hpdf( ::oPdfPage,125, ::nLinhaPdf-13, 235, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,126, ::nLinhaPdf - 1,  359, NIL, "DESCRIÇÃO DO PRODUTO / SERVIÇO", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,126, ::nLinhaPdf-6, 359, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      // NCM
      hbNFe_Box_Hpdf( ::oPdfPage,360, ::nLinhaPdf-13, 35, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,361, ::nLinhaPdf - 1,  394, NIL, "NCM/SH", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,361, ::nLinhaPdf-6, 394, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      IF ::aEmit[ "CRT" ] = "1" // CSOSN
          // CSOSN
          hbNFe_Box_Hpdf( ::oPdfPage,395, ::nLinhaPdf-13, 15, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,396, ::nLinhaPdf - 1,  409, NIL, "CSOSN", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 4 )
          hbNFe_Texto_Hpdf( ::oPdfPage,396, ::nLinhaPdf-6, 409, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 4 )
      ELSE
          // CST
          hbNFe_Box_Hpdf( ::oPdfPage,395, ::nLinhaPdf-13, 15, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,396, ::nLinhaPdf - 1,  409, NIL, "CST", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,396, ::nLinhaPdf-6, 409, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
       ENDIF
      // CFOP
      hbNFe_Box_Hpdf( ::oPdfPage,410, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,411, ::nLinhaPdf - 1,  429, NIL, "CFOP", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,411, ::nLinhaPdf-6, 429, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      // UNID
      hbNFe_Box_Hpdf( ::oPdfPage,430, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,431, ::nLinhaPdf - 1,  449, NIL, "UNID", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,431, ::nLinhaPdf-6, 449, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      // QUANT.
      hbNFe_Box_Hpdf( ::oPdfPage,450, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,451, ::nLinhaPdf - 1,  489, NIL, "QUANT.", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,451, ::nLinhaPdf-6, 489, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      // VALOR UNITARIO
      hbNFe_Box_Hpdf( ::oPdfPage,490, ::nLinhaPdf-13, 45, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,491, ::nLinhaPdf - 1,  534, NIL, "VALOR", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,491, ::nLinhaPdf-6, 534, NIL, "UNITÁRIO", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      // VALOR LÍQUIDO
      hbNFe_Box_Hpdf( ::oPdfPage,535, ::nLinhaPdf-13, 45, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,536, ::nLinhaPdf - 1,  579, NIL, "VALOR TOTAL", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
	      && Linha comentada por Anderson Camilo no dia 20/07/2012   o nome correto é VALOR TOTAL
*      hbNFe_Texto_Hpdf( ::oPdfPage,536, ::nLinhaPdf-6, 579, NIL, "LÍQUIDO", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      // BC ICMS
      hbNFe_Box_Hpdf( ::oPdfPage,580, ::nLinhaPdf-13, 45, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,581, ::nLinhaPdf - 1,  624, NIL, "B. CÁLC.", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,581, ::nLinhaPdf-6, 624, NIL, "DO ICMS", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      // VALOR ICMS
      hbNFe_Box_Hpdf( ::oPdfPage,625, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,626, ::nLinhaPdf - 1,  664, NIL, "VALOR", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,626, ::nLinhaPdf-6, 664, NIL, "ICMS", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      // BC ICMS ST
      hbNFe_Box_Hpdf( ::oPdfPage,665, ::nLinhaPdf-13, 45, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,666, ::nLinhaPdf - 1,  709, NIL, "B.CÁLC.ICMS", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,666, ::nLinhaPdf-6, 709, NIL, "SUBST.TRIB.", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      // VALOR ICMS ST
      hbNFe_Box_Hpdf( ::oPdfPage,710, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,711, ::nLinhaPdf - 1,  749, NIL, "VALOR ICMS", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,711, ::nLinhaPdf-6, 749, NIL, "SUBST.TRIB", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      // VALOR IPI
      hbNFe_Box_Hpdf( ::oPdfPage,750, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,751, ::nLinhaPdf - 1,  789, NIL, "VALOR", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,751, ::nLinhaPdf-6, 789, NIL, "IPI", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      // ALIQ ICMS
      hbNFe_Box_Hpdf( ::oPdfPage,790, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,791, ::nLinhaPdf - 1,  809, NIL, "ALÍQ.", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,791, ::nLinhaPdf-6, 809, NIL, "ICMS", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      // ALIQ IPI
      hbNFe_Box_Hpdf( ::oPdfPage,810, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,811, ::nLinhaPdf - 1,  829, NIL, "ALÍQ.", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,811, ::nLinhaPdf-6, 829, NIL, "IPI", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )

      ::nLinhaPdf -= 13
   ELSE
      IF ::lValorDesc = .F. // Layout Padrão
          hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf, 589, NIL, "DADOS DOS PRODUTOS / SERVIÇOS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalhoBold, 5 )
          ::nLinhaPdf -= 6

          // CODIGO
          hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-13, 55, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf - 1,  59, NIL, "CÓDIGO", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-6, 59, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // DESCRI
          hbNFe_Box_Hpdf( ::oPdfPage,60, ::nLinhaPdf-13, 145, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,61, ::nLinhaPdf - 1,  204, NIL, "DESCRIÇÃO DO PRODUTO / SERVIÇO", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,61, ::nLinhaPdf-6, 204, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // NCM
          hbNFe_Box_Hpdf( ::oPdfPage,205, ::nLinhaPdf-13, 35, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,206, ::nLinhaPdf - 1,  239, NIL, "NCM/SH", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,206, ::nLinhaPdf-6, 239, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          IF ::aEmit[ "CRT" ] = "1" // CSOSN
              // CSOSN
              hbNFe_Box_Hpdf( ::oPdfPage,240, ::nLinhaPdf-13, 15, 13, ::nLarguraBox )
              hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf - 1,  254, NIL, "CSOSN", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 4 )
              hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf-6, 254, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 4 )
          ELSE
              // CST
              hbNFe_Box_Hpdf( ::oPdfPage,240, ::nLinhaPdf-13, 15, 13, ::nLarguraBox )
              hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf - 1,  254, NIL, "CST", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
              hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf-6, 254, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
           ENDIF
          // CFOP
          hbNFe_Box_Hpdf( ::oPdfPage,255, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,256, ::nLinhaPdf - 1,  274, NIL, "CFOP", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,256, ::nLinhaPdf-6, 274, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // UNID
          hbNFe_Box_Hpdf( ::oPdfPage,275, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,276, ::nLinhaPdf - 1,  294, NIL, "UNID", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,276, ::nLinhaPdf-6, 294, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // QUANT.
          hbNFe_Box_Hpdf( ::oPdfPage,295, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,296, ::nLinhaPdf - 1,  334, NIL, "QUANT.", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,296, ::nLinhaPdf-6, 334, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // VALOR UNITARIO
          hbNFe_Box_Hpdf( ::oPdfPage,335, ::nLinhaPdf-13, 45, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,336, ::nLinhaPdf - 1,  379, NIL, "VALOR", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,336, ::nLinhaPdf-6, 379, NIL, "UNITÁRIO", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // VALOR LÍQUIDO
          hbNFe_Box_Hpdf( ::oPdfPage,380, ::nLinhaPdf-13, 45, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,381, ::nLinhaPdf - 1,  424, NIL, "VALOR TOTAL", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
	      && Linha comentada por Anderson Camilo no dia 20/07/2012   o nome correto é VALOR TOTAL
*          hbNFe_Texto_Hpdf( ::oPdfPage,381, ::nLinhaPdf-6, 424, NIL, "LÍQUIDO", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // BC ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,425, ::nLinhaPdf-13, 45, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,426, ::nLinhaPdf - 1,  469, NIL, "B. CÁLC.", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,426, ::nLinhaPdf-6, 469, NIL, "DO ICMS", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // VALOR ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,470, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,471, ::nLinhaPdf - 1,  509, NIL, "VALOR", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,471, ::nLinhaPdf-6, 509, NIL, "ICMS", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // VALOR IPI
          hbNFe_Box_Hpdf( ::oPdfPage,510, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf - 1,  549, NIL, "VALOR", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-6, 549, NIL, "IPI", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // ALIQ ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,550, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,551, ::nLinhaPdf - 1,  569, NIL, "ALÍQ.", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,551, ::nLinhaPdf-6, 569, NIL, "ICMS", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // ALIQ IPI
          hbNFe_Box_Hpdf( ::oPdfPage,570, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,571, ::nLinhaPdf - 1,  589, NIL, "ALÍQ.", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,571, ::nLinhaPdf-6, 589, NIL, "IPI", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      ELSE
          hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf, 589, NIL, "DADOS DOS PRODUTOS / SERVIÇOS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalhoBold, 5 )
          ::nLinhaPdf -= 6

          // CODIGO
          hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-13, 55, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf - 1,  59, NIL, "CÓDIGO", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-6, 59, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // DESCRI
          hbNFe_Box_Hpdf( ::oPdfPage,60, ::nLinhaPdf-13, 145, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,61, ::nLinhaPdf - 1,  204, NIL, "DESCRIÇÃO DO PRODUTO / SERVIÇO", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,61, ::nLinhaPdf-6, 204, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // NCM
          hbNFe_Box_Hpdf( ::oPdfPage,205, ::nLinhaPdf-13, 35, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,206, ::nLinhaPdf - 1,  239, NIL, "NCM/SH", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,206, ::nLinhaPdf-6, 239, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          IF ::aEmit[ "CRT" ] = "1" // CSOSN
              // CSOSN
              hbNFe_Box_Hpdf( ::oPdfPage,240, ::nLinhaPdf-13, 15, 13, ::nLarguraBox )
              hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf - 1,  254, NIL, "CSOSN", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 4 )
              hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf-6, 254, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 4 )
          ELSE
              // CST
              hbNFe_Box_Hpdf( ::oPdfPage,240, ::nLinhaPdf-13, 15, 13, ::nLarguraBox )
              hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf - 1,  254, NIL, "CST", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
              hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf-6, 254, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
           ENDIF
          // CFOP
          hbNFe_Box_Hpdf( ::oPdfPage,255, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,256, ::nLinhaPdf - 1,  274, NIL, "CFOP", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,256, ::nLinhaPdf-6, 274, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // UNID
          hbNFe_Box_Hpdf( ::oPdfPage,275, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,276, ::nLinhaPdf - 1,  294, NIL, "UNID", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,276, ::nLinhaPdf-6, 294, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // QUANT.
          hbNFe_Box_Hpdf( ::oPdfPage,295, ::nLinhaPdf-13, 35, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,296, ::nLinhaPdf - 1,  329, NIL, "QUANT.", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,296, ::nLinhaPdf-6, 329, NIL, "", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // VALOR UNITARIO
          hbNFe_Box_Hpdf( ::oPdfPage,330, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,331, ::nLinhaPdf - 1,  369, NIL, "VALOR", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,331, ::nLinhaPdf-6, 369, NIL, "UNITÁRIO", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // VALOR LÍQUIDO
          hbNFe_Box_Hpdf( ::oPdfPage,370, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf - 1,  409, NIL, "VALOR", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
	      && Linha comentada por Anderson Camilo no dia 20/07/2012   o nome correto é VALOR TOTAL
          hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-6, 409, NIL, "TOTAL", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
*          hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-6, 409, NIL, "LÍQUIDO", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // VALOR DESCONTO
          hbNFe_Box_Hpdf( ::oPdfPage,410, ::nLinhaPdf-13, 35, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,411, ::nLinhaPdf - 1,  444, NIL, "VALOR", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,411, ::nLinhaPdf-6, 444, NIL, "DESCTO.", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // BC ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,445, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,446, ::nLinhaPdf - 1,  484, NIL, "B. CÁLC.", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,446, ::nLinhaPdf-6, 484, NIL, "DO ICMS", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // VALOR ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,485, ::nLinhaPdf-13, 35, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,486, ::nLinhaPdf - 1,  519, NIL, "VALOR", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,486, ::nLinhaPdf-6, 519, NIL, "ICMS", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // VALOR IPI
          hbNFe_Box_Hpdf( ::oPdfPage,520, ::nLinhaPdf-13, 30, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,521, ::nLinhaPdf - 1,  549, NIL, "VALOR", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,521, ::nLinhaPdf-6, 549, NIL, "IPI", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // ALIQ ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,550, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,551, ::nLinhaPdf - 1,  569, NIL, "ALÍQ.", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,551, ::nLinhaPdf-6, 569, NIL, "ICMS", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          // ALIQ IPI
          hbNFe_Box_Hpdf( ::oPdfPage,570, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,571, ::nLinhaPdf - 1,  589, NIL, "ALÍQ.", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,571, ::nLinhaPdf-6, 589, NIL, "IPI", HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
      ENDIF
      ::nLinhaPdf -= 13
   ENDIF

   RETURN NIL

METHOD desenhaBoxProdutos(nLinhaFinalProd,nTamanhoProd) CLASS hbNFeDanfe

   IF ::lPaisagem = .T. // paisagem
      // CODIGO
      hbNFe_Box_Hpdf( ::oPdfPage, 70, nLinhaFinalProd, 55, nTamanhoProd, ::nLarguraBox )
      // DESCRI
      hbNFe_Box_Hpdf( ::oPdfPage,125, nLinhaFinalProd,235, nTamanhoProd, ::nLarguraBox )
      // NCM
      hbNFe_Box_Hpdf( ::oPdfPage,360, nLinhaFinalProd, 35, nTamanhoProd, ::nLarguraBox )
      // CST/CSOSN
      hbNFe_Box_Hpdf( ::oPdfPage,395, nLinhaFinalProd, 15, nTamanhoProd, ::nLarguraBox )
      // CFOP
      hbNFe_Box_Hpdf( ::oPdfPage,410, nLinhaFinalProd, 20, nTamanhoProd, ::nLarguraBox )
      // UNID
      hbNFe_Box_Hpdf( ::oPdfPage,430, nLinhaFinalProd, 20, nTamanhoProd, ::nLarguraBox )
      // QUANT.
      hbNFe_Box_Hpdf( ::oPdfPage,450, nLinhaFinalProd, 40, nTamanhoProd, ::nLarguraBox )
      // VALOR UNITARIO
      hbNFe_Box_Hpdf( ::oPdfPage,490, nLinhaFinalProd, 45, nTamanhoProd, ::nLarguraBox )
      // VALOR LÍQUIDO
      hbNFe_Box_Hpdf( ::oPdfPage,535, nLinhaFinalProd, 45, nTamanhoProd, ::nLarguraBox )
      // BC ICMS
      hbNFe_Box_Hpdf( ::oPdfPage,580, nLinhaFinalProd, 45, nTamanhoProd, ::nLarguraBox )
      // VALOR ICMS
      hbNFe_Box_Hpdf( ::oPdfPage,625, nLinhaFinalProd, 40, nTamanhoProd, ::nLarguraBox )
      // BC ICMS ST
      hbNFe_Box_Hpdf( ::oPdfPage,665, nLinhaFinalProd, 45, nTamanhoProd, ::nLarguraBox )
      // VALOR ICMS ST
      hbNFe_Box_Hpdf( ::oPdfPage,710, nLinhaFinalProd, 40, nTamanhoProd, ::nLarguraBox )
      // VALOR IPI
      hbNFe_Box_Hpdf( ::oPdfPage,750, nLinhaFinalProd, 40, nTamanhoProd, ::nLarguraBox )
      // ALIQ ICMS
      hbNFe_Box_Hpdf( ::oPdfPage,790, nLinhaFinalProd, 20, nTamanhoProd, ::nLarguraBox )
      // ALIQ IPI
      hbNFe_Box_Hpdf( ::oPdfPage,810, nLinhaFinalProd, 20, nTamanhoProd, ::nLarguraBox )

      ::nLinhaPdf -= 1
   ELSE
      IF ::lValorDesc = .F. // Layout Padrão
          // CODIGO
          hbNFe_Box_Hpdf( ::oPdfPage,  5, nLinhaFinalProd, 55, nTamanhoProd, ::nLarguraBox )
          // DESCRI
          hbNFe_Box_Hpdf( ::oPdfPage, 60, nLinhaFinalProd,145, nTamanhoProd, ::nLarguraBox )
          // NCM
          hbNFe_Box_Hpdf( ::oPdfPage,205, nLinhaFinalProd, 35, nTamanhoProd, ::nLarguraBox )
          // CST/CSOSN
          hbNFe_Box_Hpdf( ::oPdfPage,240, nLinhaFinalProd, 15, nTamanhoProd, ::nLarguraBox )
          // CFOP
          hbNFe_Box_Hpdf( ::oPdfPage,255, nLinhaFinalProd, 20, nTamanhoProd, ::nLarguraBox )
          // UNID
          hbNFe_Box_Hpdf( ::oPdfPage,275, nLinhaFinalProd, 20, nTamanhoProd, ::nLarguraBox )
          // QUANT.
          hbNFe_Box_Hpdf( ::oPdfPage,295, nLinhaFinalProd, 40, nTamanhoProd, ::nLarguraBox )
          // VALOR UNITARIO
          hbNFe_Box_Hpdf( ::oPdfPage,335, nLinhaFinalProd, 45, nTamanhoProd, ::nLarguraBox )
          // VALOR LÍQUIDO
          hbNFe_Box_Hpdf( ::oPdfPage,380, nLinhaFinalProd, 45, nTamanhoProd, ::nLarguraBox )
          // BC ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,425, nLinhaFinalProd, 45, nTamanhoProd, ::nLarguraBox )
          // VALOR ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,470, nLinhaFinalProd, 40, nTamanhoProd, ::nLarguraBox )
          // VALOR IPI
          hbNFe_Box_Hpdf( ::oPdfPage,510, nLinhaFinalProd, 40, nTamanhoProd, ::nLarguraBox )
          // ALIQ ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,550, nLinhaFinalProd, 20, nTamanhoProd, ::nLarguraBox )
          // ALIQ IPI
          hbNFe_Box_Hpdf( ::oPdfPage,570, nLinhaFinalProd, 20, nTamanhoProd, ::nLarguraBox )
      ELSE
          // CODIGO
          hbNFe_Box_Hpdf( ::oPdfPage,  5, nLinhaFinalProd, 55, nTamanhoProd, ::nLarguraBox )
          // DESCRI
          hbNFe_Box_Hpdf( ::oPdfPage, 60, nLinhaFinalProd,145, nTamanhoProd, ::nLarguraBox )
          // NCM
          hbNFe_Box_Hpdf( ::oPdfPage,205, nLinhaFinalProd, 35, nTamanhoProd, ::nLarguraBox )
          // CST/CSOSN
          hbNFe_Box_Hpdf( ::oPdfPage,240, nLinhaFinalProd, 15, nTamanhoProd, ::nLarguraBox )
          // CFOP
          hbNFe_Box_Hpdf( ::oPdfPage,255, nLinhaFinalProd, 20, nTamanhoProd, ::nLarguraBox )
          // UNID
          hbNFe_Box_Hpdf( ::oPdfPage,275, nLinhaFinalProd, 20, nTamanhoProd, ::nLarguraBox )
          // QUANT.
          hbNFe_Box_Hpdf( ::oPdfPage,295, nLinhaFinalProd, 35, nTamanhoProd, ::nLarguraBox )
          // VALOR UNITARIO
          hbNFe_Box_Hpdf( ::oPdfPage,330, nLinhaFinalProd, 40, nTamanhoProd, ::nLarguraBox )
          // VALOR LÍQUIDO
          hbNFe_Box_Hpdf( ::oPdfPage,370, nLinhaFinalProd, 40, nTamanhoProd, ::nLarguraBox )
          // VALOR DESCONTO
          hbNFe_Box_Hpdf( ::oPdfPage,410, nLinhaFinalProd, 35, nTamanhoProd, ::nLarguraBox )
          // BC ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,445, nLinhaFinalProd, 40, nTamanhoProd, ::nLarguraBox )
          // VALOR ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,485, nLinhaFinalProd, 35, nTamanhoProd, ::nLarguraBox )
          // VALOR IPI
          hbNFe_Box_Hpdf( ::oPdfPage,520, nLinhaFinalProd, 30, nTamanhoProd, ::nLarguraBox )
          // ALIQ ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,550, nLinhaFinalProd, 20, nTamanhoProd, ::nLarguraBox )
          // ALIQ IPI
          hbNFe_Box_Hpdf( ::oPdfPage,570, nLinhaFinalProd, 20, nTamanhoProd, ::nLarguraBox )
      ENDIF
      ::nLinhaPdf -= 1
   ENDIF

   RETURN NIL

METHOD produtos() CLASS hbNFeDanfe

   LOCAL nLinhaFinalProd, nTamanhoProd, nItem, nIdes

   ::nItensFolha := ::calculaItens1Folha( ::nItens1Folha )

   nLinhaFinalProd := ::nLinhaPdf - ( ::nItensFolha * 6 ) - 2
   nTamanhoProd := ( ::nItensFolha * 6 ) + 2
   ::desenhaBoxProdutos( nLinhaFinalProd, nTamanhoProd )

   // DADOS PRODUTOS
   nItem := 1
   ::nLinhaFolha := 1
   DO WHILE .T.
      IF ::nLinhaFolha > ::nItensFolha
         ::saltaPagina()
      ENDIF
      ::ProcessaItens( ::cXML, nItem )
      IF ::aItem[ "cProd" ] = NIL
         EXIT
      ENDIF

      IF ::lPaisagem = .T. // paisagem
         /* CODIGO */ hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf, 124, NIL, ::aItem[ "cProd" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
         /* DESCRI */ hbNFe_Texto_Hpdf( ::oPdfPage,126, ::nLinhaPdf, 359, NIL, TRIM(MEMOLINE(::aItem[ "xProd" ],::nLarguraDescricao,1)), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         /* NCM    */ hbNFe_Texto_Hpdf( ::oPdfPage,361, ::nLinhaPdf, 394, NIL, ::aItem[ "NCM" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
         IF ::aEmit[ "CRT" ] = "1" // CSOSN
            /* CST/CSOSN */ hbNFe_Texto_Hpdf( ::oPdfPage,396, ::nLinhaPdf, 409, NIL, ::aItemICMS[ "orig" ]+::aItemICMS[ "CSOSN" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 5 )
         ELSE
            /* CST */ hbNFe_Texto_Hpdf( ::oPdfPage,396, ::nLinhaPdf, 409, NIL, ::aItemICMS[ "orig" ]+::aItemICMS[ "CST" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
         ENDIF
         /* CFOP */        hbNFe_Texto_Hpdf( ::oPdfPage,411, ::nLinhaPdf, 429, NIL, ::aItem[ "CFOP" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
         /* UNID */        hbNFe_Texto_Hpdf( ::oPdfPage,431, ::nLinhaPdf, 449, NIL, ::aItem[ "uCom" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
         /* QUANT. */      hbNFe_Texto_Hpdf( ::oPdfPage,451, ::nLinhaPdf, 489, NIL, AllTrim( FormatNumber( Val( ::aItem[ "qCom" ] ), 15, ::nCasasQtd ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
         /* VAL UNIT */    hbNFe_Texto_Hpdf( ::oPdfPage,491, ::nLinhaPdf, 534, NIL, AllTrim( FormatNumber( Val( ::aItem[ "vUnCom" ] ), 15, ::nCasasVUn ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
         /* VAL LIQ */     hbNFe_Texto_Hpdf( ::oPdfPage,536, ::nLinhaPdf, 579, NIL, AllTrim( FormatNumber( Val( ::aItem[ "vProd" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
         /* BC ICMS */     hbNFe_Texto_Hpdf( ::oPdfPage,581, ::nLinhaPdf, 624, NIL, AllTrim( FormatNumber( Val( iif( ::aItemICMS[ "vBC" ] <> NIL, ::aItemICMS[ "vBC" ], "0" ) ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
         /* VAL ICMS */    hbNFe_Texto_Hpdf( ::oPdfPage,626, ::nLinhaPdf, 664, NIL, AllTrim( FormatNumber( Val( iif( ::aItemICMS[ "vICMS" ] <> NIL, ::aItemICMS[ "vICMS" ], "0" ) ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
         /* BC ICMS ST */  hbNFe_Texto_Hpdf( ::oPdfPage,666, ::nLinhaPdf, 709, NIL, AllTrim( FormatNumber( Val( iif( ::aItemICMS[ "vBCST" ] <> NIL, ::aItemICMS[ "vBCST" ], "0" ) ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
         /* VAL ICMS ST */ hbNFe_Texto_Hpdf( ::oPdfPage,711, ::nLinhaPdf, 749, NIL, AllTrim( FormatNumber( Val( iif( ::aItemICMS[ "vICMSST" ] <> NIL, ::aItemICMS[ "vICMSST" ], "0" ) ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
         /* VALOR IPI */   hbNFe_Texto_Hpdf( ::oPdfPage,751, ::nLinhaPdf, 789, NIL, AllTrim( FormatNumber( Val( iif( ::aItemIPI[ "vIPI" ] <> NIL, ::aItemIPI[ "vIPI" ], "0" ) ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
         /* ALIQ ICMS */   hbNFe_Texto_Hpdf( ::oPdfPage,791, ::nLinhaPdf, 809, NIL, AllTrim( FormatNumber( Val( iif( ::aItemICMS[ "pICMS" ] <> NIL, ::aItemICMS[ "pICMS" ], "0" ) ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
         /* ALIQ IPI */    hbNFe_Texto_Hpdf( ::oPdfPage,811, ::nLinhaPdf, 829, NIL, AllTrim( FormatNumber( Val( iif( ::aItemIPI[ "pIPI" ] <> NIL, ::aItemIPI[ "pIPI" ], "0" ) ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
         ::nLinhaPdf -= 6

         nItem++
         ::nLinhaFolha ++
         FOR nIdes = 2 TO MLCOUNT( ::aItem[ "xProd" ], ::nLarguraDescricao )
            IF ::nLinhaFolha > ::nItensFolha
               ::saltaPagina()
            ENDIF
            /* DESCRI */ hbNFe_Texto_Hpdf( ::oPdfPage,126, ::nLinhaPdf, 359, NIL, TRIM(MEMOLINE(::aItem[ "xProd" ],::nLarguraDescricao,nIdes)), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
            ::nLinhaFolha ++
            ::nLinhaPdf -= 6
         NEXT
         TRY
            FOR nIDes = 1 TO MLCOUNT(::aItem[ "infAdProd" ],::nLarguraDescricao )
                IF ::nLinhaFolha > ::nItensFolha
                   ::saltaPagina()
                ENDIF
                /* DESCRI */ hbNFe_Texto_Hpdf( ::oPdfPage,126, ::nLinhaPdf, 359, NIL, TRIM(MEMOLINE(::aItem[ "infAdProd" ],::nLarguraDescricao,nIdes)), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
                ::nLinhaFolha ++
                ::nLinhaPdf -= 6
            NEXT
         CATCH
         END
         IF ::nLinhaFolha <= ::nItensFolha
            hbNFe_Line_Hpdf( ::oPdfPage,70, ::nLinhaPdf-0.5, 830, ::nLinhaPdf-0.5, ::nLarguraBox)
         ENDIF
      ELSE
         IF ::lValorDesc = .F. // Layout Padrão
             /* CODIGO */ hbNFe_Texto_Hpdf( ::oPdfPage, 6, ::nLinhaPdf, 59, NIL, ::aItem[ "cProd" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
             /* DESCRI */ hbNFe_Texto_Hpdf( ::oPdfPage, 61, ::nLinhaPdf, 204, NIL, TRIM(MEMOLINE(::aItem[ "xProd" ],::nLarguraDescricao,1)), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
             /* NCM */ hbNFe_Texto_Hpdf( ::oPdfPage, 206, ::nLinhaPdf, 239, NIL, ::aItem[ "NCM" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
             IF ::aEmit[ "CRT" ] = "1" // CSOSN
                 /* CSOSN */ hbNFe_Texto_Hpdf( ::oPdfPage, 241, ::nLinhaPdf, 254, NIL, ::aItemICMS[ "orig" ]+::aItemICMS[ "CSOSN" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 5 )
             ELSE
                 /* CST */ hbNFe_Texto_Hpdf( ::oPdfPage, 241, ::nLinhaPdf, 254, NIL, ::aItemICMS[ "orig" ]+::aItemICMS[ "CST" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
              ENDIF
             /* CFOP */           hbNFe_Texto_Hpdf( ::oPdfPage, 256, ::nLinhaPdf, 274, NIL, ::aItem[ "CFOP" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
             /* UNID */           hbNFe_Texto_Hpdf( ::oPdfPage, 276, ::nLinhaPdf, 294, NIL, ::aItem[ "uCom" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
             /* QUANT */          hbNFe_Texto_Hpdf( ::oPdfPage, 296, ::nLinhaPdf, 334, NIL, AllTrim( FormatNumber( Val( ::aItem[ "qCom" ] ), 15, ::nCasasQtd ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 5 )
             /* VALOR UNITARIO */ hbNFe_Texto_Hpdf( ::oPdfPage, 336, ::nLinhaPdf, 379, NIL, AllTrim( FormatNumber( Val( ::aItem[ "vUnCom" ] ), 15, ::nCasasVUn ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
             /* VALOR LÍQUIDO */  hbNFe_Texto_Hpdf( ::oPdfPage, 381, ::nLinhaPdf, 424, NIL, AllTrim( FormatNumber( Val( ::aItem[ "vProd" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
             /* BC ICMS */        hbNFe_Texto_Hpdf( ::oPdfPage, 426, ::nLinhaPdf, 469, NIL, AllTrim( FormatNumber( Val( iif( ::aItemICMS[ "vBC" ] <> NIL, ::aItemICMS[ "vBC" ], "0" ) ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
             /* VALOR ICMS */     hbNFe_Texto_Hpdf( ::oPdfPage, 471, ::nLinhaPdf, 509, NIL, AllTrim( FormatNumber( Val( iif( ::aItemICMS[ "vICMS" ] <> NIL, ::aItemICMS[ "vICMS" ], "0" ) ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
             /* VALOR IPI */      hbNFe_Texto_Hpdf( ::oPdfPage, 511, ::nLinhaPdf, 549, NIL, AllTrim( FormatNumber( Val( iif( ::aItemIPI[ "vIPI" ] <> NIL, ::aItemIPI[ "vIPI" ], "0" ) ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
             /* ALIQ ICMS */      hbNFe_Texto_Hpdf( ::oPdfPage, 551, ::nLinhaPdf, 569, NIL, AllTrim( FormatNumber( Val( iif( ::aItemICMS[ "pICMS" ] <> NIL, ::aItemICMS[ "pICMS" ], "0" ) ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
             /* ALIQ IPI */       hbNFe_Texto_Hpdf( ::oPdfPage, 571, ::nLinhaPdf, 589, NIL, AllTrim( FormatNumber( Val( iif( ::aItemIPI[ "pIPI" ] <> NIL, ::aItemIPI[ "pIPI" ], "0" ) ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
             ::nLinhaPdf -= 6

             nItem++
             ::nLinhaFolha ++
             FOR nIdes = 2 TO MLCount( ::aItem[ "xProd" ], ::nLarguraDescricao )
                IF ::nLinhaFolha > ::nItensFolha
                   ::saltaPagina()
                ENDIF
                /* DESCRI */ hbNFe_Texto_Hpdf( ::oPdfPage, 61, ::nLinhaPdf, 204, NIL, Trim( MemoLine( ::aItem[ "xProd" ], ::nLarguraDescricao, nIdes ) ), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
                ::nLinhaFolha ++
                ::nLinhaPdf -= 6
             NEXT
             TRY
               FOR nIDes = 1 TO MLCount( ::aItem[ "infAdProd" ], ::nLarguraDescricao )
                  IF ::nLinhaFolha > ::nItensFolha
                     ::saltaPagina()
                  ENDIF
                  /* DESCRI */ hbNFe_Texto_Hpdf( ::oPdfPage, 61, ::nLinhaPdf, 204, NIL, Trim( MemoLine( ::aItem[ "infAdProd" ], ::nLarguraDescricao, nIdes ) ), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
                  ::nLinhaFolha ++
                  ::nLinhaPdf -= 6
               NEXT
            CATCH
            END
          ELSE
             /* CODIGO */ hbNFe_Texto_Hpdf( ::oPdfPage, 6, ::nLinhaPdf, 59, NIL, ::aItem[ "cProd" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
             /* DESCRI */ hbNFe_Texto_Hpdf( ::oPdfPage, 61, ::nLinhaPdf, 204, NIL, Trim( MemoLine( ::aItem[ "xProd" ], ::nLarguraDescricao, 1 ) ), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
             /* NCM */    hbNFe_Texto_Hpdf( ::oPdfPage, 206, ::nLinhaPdf, 239, NIL, ::aItem[ "NCM" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
            IF ::aEmit[ "CRT" ] = "1" // CSOSN
                 /* CSOSN */ hbNFe_Texto_Hpdf( ::oPdfPage, 241, ::nLinhaPdf, 254, NIL, ::aItemICMS[ "orig" ] + ::aItemICMS[ "CSOSN" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 5 )
            ELSE
                 /* CST */ hbNFe_Texto_Hpdf( ::oPdfPage, 241, ::nLinhaPdf, 254, NIL, ::aItemICMS[ "orig" ] + ::aItemICMS[ "CST" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
              ENDIF
             /* CFOP */           hbNFe_Texto_Hpdf( ::oPdfPage, 256, ::nLinhaPdf, 274, NIL, ::aItem[ "CFOP" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
             /* UNID */           hbNFe_Texto_Hpdf( ::oPdfPage, 276, ::nLinhaPdf, 294, NIL, ::aItem[ "uCom" ], HPDF_TALIGN_CENTER, NIL, ::oPdfFontCabecalho, 6 )
             /* QUANT. */         hbNFe_Texto_Hpdf( ::oPdfPage, 296, ::nLinhaPdf, 329, NIL, AllTrim( FormatNumber( Val(::aItem[ "qCom" ] ), 15, ::nCasasQtd)), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 5 )
             /* VALOR UNITARIO */ hbNFe_Texto_Hpdf( ::oPdfPage, 331, ::nLinhaPdf, 369, NIL, AllTrim( FormatNumber( Val(::aItem[ "vUnCom" ] ), 15, ::nCasasVUn ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
             /* VALOR LÍQUIDO */  hbNFe_Texto_Hpdf( ::oPdfPage, 371, ::nLinhaPdf, 409, NIL, AllTrim( FormatNumber( Val(::aItem[ "vProd" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
             TRY
                /* VALOR DESCONTO */ hbNFe_Texto_Hpdf( ::oPdfPage, 411, ::nLinhaPdf, 444, NIL, AllTrim( FormatNumber( Val( ::aItem[ "vDesc" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
             CATCH
                /* VALOR DESCONTO */ hbNFe_Texto_Hpdf( ::oPdfPage, 411, ::nLinhaPdf, 444, NIL, AllTrim( FormatNumber( Val( "0.00"), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
             END
             /* BC ICMS */    hbNFe_Texto_Hpdf( ::oPdfPage, 446, ::nLinhaPdf, 484, NIL, AllTrim( FormatNumber( Val( iif( ::aItemICMS[ "vBC" ] <> NIL,::aItemICMS[ "vBC" ], "0" ) ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
             /* VALOR ICMS */ hbNFe_Texto_Hpdf( ::oPdfPage, 486, ::nLinhaPdf, 519, NIL, AllTrim( FormatNumber( Val( iif( ::aItemICMS[ "vICMS" ] <> NIL,::aItemICMS[ "vICMS" ], "0" ) ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
             /* VALOR IPI */  hbNFe_Texto_Hpdf( ::oPdfPage, 521, ::nLinhaPdf, 549, NIL, AllTrim( FormatNumber( Val( iif( ::aItemIPI[ "vIPI" ] <> NIL,::aItemIPI[ "vIPI" ], "0" ) ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
             /* ALIQ ICMS */  hbNFe_Texto_Hpdf( ::oPdfPage, 551, ::nLinhaPdf, 569, NIL, AllTrim( FormatNumber( Val( iif( ::aItemICMS[ "pICMS" ] <> NIL,::aItemICMS[ "pICMS" ], "0" ) ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
             /* ALIQ IPI */   hbNFe_Texto_Hpdf( ::oPdfPage, 571, ::nLinhaPdf, 589, NIL, AllTrim( FormatNumber( Val( iif( ::aItemIPI[ "pIPI" ] <> NIL,::aItemIPI[ "pIPI" ], "0" ) ), 15, 2 ) ), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
             ::nLinhaPdf -= 6

             nItem++
             ::nLinhaFolha ++
             FOR nIdes = 2 TO MLCOUNT(::aItem[ "xProd" ],::nLarguraDescricao)
                IF ::nLinhaFolha > ::nItensFolha
                   ::saltaPagina()
                ENDIF
                // DESCRI
                hbNFe_Texto_Hpdf( ::oPdfPage,61, ::nLinhaPdf, 204, NIL, TRIM(MEMOLINE(::aItem[ "xProd" ],::nLarguraDescricao,nIdes)), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
                ::nLinhaFolha ++
                ::nLinhaPdf -= 6
             NEXT
             TRY
               FOR nIDes = 1 TO MLCOUNT(::aItem[ "infAdProd" ],::nLarguraDescricao)
                  IF ::nLinhaFolha > ::nItensFolha
                     ::saltaPagina()
                  ENDIF
                  // DESCRI
                  hbNFe_Texto_Hpdf( ::oPdfPage,61, ::nLinhaPdf, 204, NIL, TRIM(MEMOLINE(::aItem[ "infAdProd" ],::nLarguraDescricao,nIdes)), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
                  ::nLinhaFolha ++
                  ::nLinhaPdf -= 6
               NEXT
            CATCH
            END
         ENDIF
         IF ::nLinhaFolha <= ::nItensFolha
            hbNFe_Line_Hpdf( ::oPdfPage, 5, ::nLinhaPdf-0.5, 590, ::nLinhaPdf-0.5, ::nLarguraBox)
         ENDIF
      ENDIF
   ENDDO
   ::nLinhaPdf -= ((::nItensFolha-::nLinhaFolha+1)*6)

   ::nLinhaPdf -= 2

   RETURN NIL

METHOD totalServico() CLASS hbNFeDanfe

   IF ::nFolha = 1
      IF VAL(IF(::aISSTotal[ "vServ" ]<>NIL,::aISSTotal[ "vServ" ],"0")) > 0 // com servico
         IF ::lPaisagem = .T. // paisagem
            hbNFe_Texto_Hpdf( ::oPdfPage,70, ::nLinhaPdf, 830, NIL, "CALCULO DO ISSQN", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalhoBold, 5 )

            ::nLinhaPdf -= 6

            // INSCRICAO
            hbNFe_Box_Hpdf( ::oPdfPage,  70, ::nLinhaPdf-16, 200, 16, ::nLarguraBox )
            hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf - 1,  269, NIL, "INSCRIÇÃO MUNICIPAL", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
            hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-5, 269, NIL, ::aEmit[ "IM" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 8 )
            // VALOR SERV.
            hbNFe_Box_Hpdf( ::oPdfPage,270, ::nLinhaPdf-16,190, 16, ::nLarguraBox )
            hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf - 1,  459, NIL, "VALOR TOTAL DOS SERVIÇOS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
            hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-5, 459, NIL, FormatNumber( Val(IF(::aISSTotal[ "vServ" ]<>NIL,::aISSTotal[ "vServ" ],"0")),15), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
            // BASE DE CALC
            hbNFe_Box_Hpdf( ::oPdfPage,460, ::nLinhaPdf-16, 190, 16, ::nLarguraBox )
            hbNFe_Texto_Hpdf( ::oPdfPage,461, ::nLinhaPdf - 1,  649, NIL, "BASE DE CÁLCULO DO ISSQN", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
            hbNFe_Texto_Hpdf( ::oPdfPage,461, ::nLinhaPdf-5, 649, NIL, FormatNumber( Val(IF(::aISSTotal[ "vBC" ]<>NIL,::aISSTotal[ "vBC" ],"0")),15), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
            // VALOR DO ISSQN
            hbNFe_Box_Hpdf( ::oPdfPage,650, ::nLinhaPdf-16, 180, 16, ::nLarguraBox )
            hbNFe_Texto_Hpdf( ::oPdfPage,651, ::nLinhaPdf - 1,  829, NIL, "VALOR DO ISSQN", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
            hbNFe_Texto_Hpdf( ::oPdfPage,651, ::nLinhaPdf-5, 829, NIL, FormatNumber( Val(IF(::aISSTotal[ "vISS" ]<>NIL,::aISSTotal[ "vISS" ],"0")),15), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )

            ::nLinhaPdf -= 17
         ELSE
            hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf, 589, NIL, "CALCULO DO ISSQN", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalhoBold, 5 )

            ::nLinhaPdf -= 6

            // INSCRICAO
            hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-16, 150, 16, ::nLarguraBox )
            hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf - 1,  154, NIL, "INSCRIÇÃO MUNICIPAL", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
            hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5, 154, NIL, ::aEmit[ "IM" ], HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 8 )
            // VALOR SERV.
            hbNFe_Box_Hpdf( ::oPdfPage,155, ::nLinhaPdf-16,145, 16, ::nLarguraBox )
            hbNFe_Texto_Hpdf( ::oPdfPage,156, ::nLinhaPdf - 1,  299, NIL, "VALOR TOTAL DOS SERVIÇOS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
            hbNFe_Texto_Hpdf( ::oPdfPage,156, ::nLinhaPdf-5, 299, NIL, FormatNumber( Val(IF(::aISSTotal[ "vServ" ]<>NIL,::aISSTotal[ "vServ" ],"0")),15), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
            // BASE DE CALC
            hbNFe_Box_Hpdf( ::oPdfPage,300, ::nLinhaPdf-16, 145, 16, ::nLarguraBox )
            hbNFe_Texto_Hpdf( ::oPdfPage,301, ::nLinhaPdf - 1,  444, NIL, "BASE DE CÁLCULO DO ISSQN", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
            hbNFe_Texto_Hpdf( ::oPdfPage,301, ::nLinhaPdf-5, 444, NIL, FormatNumber( Val(IF(::aISSTotal[ "vBC" ]<>NIL,::aISSTotal[ "vBC" ],"0")),15), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )
            // VALOR DO ISSQN
            hbNFe_Box_Hpdf( ::oPdfPage,445, ::nLinhaPdf-16, 145, 16, ::nLarguraBox )
            hbNFe_Texto_Hpdf( ::oPdfPage,446, ::nLinhaPdf - 1,  589, NIL, "VALOR DO ISSQN", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 5 )
            hbNFe_Texto_Hpdf( ::oPdfPage,446, ::nLinhaPdf-5, 589, NIL, FormatNumber( Val(IF(::aISSTotal[ "vISS" ]<>NIL,::aISSTotal[ "vISS" ],"0")),15), HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 10 )

            ::nLinhaPdf -= 17
         ENDIF
      ENDIF
   ENDIF

   RETURN NIL

METHOD dadosAdicionais() CLASS hbNFeDanfe

   LOCAL cMemo, nI

   IF ::nFolha = 1
      IF ::lPaisagem = .T. // paisagem
         hbNFe_Texto_Hpdf( ::oPdfPage,70, ::nLinhaPdf, 830, NIL, "DADOS ADICIONAIS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalhoBold, 5 )

         ::nLinhaPdf -= 6

         // INF. COMPL.
         hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf - 78, 495, 78, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf - 1, 564, NIL, "INFORMAÇÕES COMPLEMENTARES", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         // RESERVADO FISCO
         hbNFe_Box_Hpdf( ::oPdfPage, 565, ::nLinhaPdf - 78, 265, 78, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 566, ::nLinhaPdf - 1, 829, NIL, "RESERVADO AO FISCO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         ::nLinhaPdf -= 7
         ::nLinhaPdf -= 4 //ESPAÇO


         cMemo := IF( ::aInfAdic[ "infCpl" ] <> NIL, ::aInfAdic[ "infCpl" ], "" )
         cMemo := StrTran( cMemo, ";", CHR(13) + CHR(10) )
         FOR nI = 1 TO MLCount( cMemo, 100 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf  ,564, NIL, Trim( MemoLine( cMemo, 100, nI ) ), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
            ::nLinhaPdf -= 6
         NEXT
         FOR nI = ( MLCount( cMemo, 100 ) + 1 ) TO 11
            ::nLinhaPdf -= 6
         NEXT
         ::nLinhaPdf -= 2
      ELSE
         hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf, 589, NIL, "DADOS ADICIONAIS", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalhoBold, 5 )

         ::nLinhaPdf -= 6

         // INF. COMPL.    && Alterado por anderson em 18/07/2012
*         hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-78, 395, 78, ::nLarguraBox )

         hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf - 92, 395, 92, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 6, ::nLinhaPdf - 1, 399, NIL, "INFORMAÇÕES COMPLEMENTARES", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         // RESERVADO FISCO

                           && Alterado por anderson em 18/07/2012
*        hbNFe_Box_Hpdf( ::oPdfPage, 400, ::nLinhaPdf - 78, 190, 78, ::nLarguraBox )
         hbNFe_Box_Hpdf( ::oPdfPage, 400, ::nLinhaPdf - 92, 190, 92, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 401, ::nLinhaPdf - 1, 589, NIL, "RESERVADO AO FISCO", HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
         ::nLinhaPdf -= 7    //
         ::nLinhaPdf -= 4 //ESPAÇO


         cMemo := IF(::aInfAdic[ "infCpl" ] <> NIL, ::aInfAdic[ "infCpl" ],"")
         cMemo := StrTran( cMemo, ";", CHR(13) + CHR(10) )
         FOR nI = 1 TO MLCount( cMemo, 100 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 6, ::nLinhaPdf, 399, NIL, Trim( MemoLine( cMemo, 100, nI ) ), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
            ::nLinhaPdf -= 6
         NEXT

         FOR nI = ( MLCount( cMemo, 100 ) + 1 ) TO 13    && Alterado por anderson  o original era TO 11
            ::nLinhaPdf -= 6
         NEXT
         ::nLinhaPdf -= 4                          && Alterado por anderson  o original era -2
      ENDIF
   ENDIF

   RETURN NIL

METHOD rodape() CLASS hbNFeDanfe

   IF ::lPaisagem = .T. // paisagem
      hbNFe_Texto_Hpdf( ::oPdfPage,70, ::nLinhaPdf, 175, NIL, "DATA DA IMPRESSÃO: " + Dtoc( Date() ), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,185, ::nLinhaPdf, 829, NIL, ::cDesenvolvedor, HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
   ELSE
      hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf, 110, NIL, "DATA DA IMPRESSÃO: " + Dtoc( Date() ), HPDF_TALIGN_LEFT, NIL, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,115, ::nLinhaPdf, 589, NIL, ::cDesenvolvedor, HPDF_TALIGN_RIGHT, NIL, ::oPdfFontCabecalho, 6 )
   ENDIF

   RETURN NIL

METHOD ProcessaItens(cXML,nItem) CLASS hbNFeDanfe

   LOCAL cItem, cItemDI, cItemAdi, cItemICMS, cItemICMSPart, cItemICMSST,;
         cItemICMSSN101, cItemICMSSN102, cItemICMSSN201, cItemICMSSN202, cItemICMSSN500, cItemICMSSN900,;
         cItemIPI, cItemII, cItemPIS, cItemPISST, cItemCOFINS, cItemCOFINSST, cItemISSQN


   cItem := hbNFe_PegaDadosXML('det nItem="'+AllTrim(STR(nItem))+'"', cXML, "det" )
   ::aItem := hb_Hash()
   ::aItem[ "cProd" ] := hbNFe_PegaDadosXml( "cProd", cItem )
   ::aItem[ "cEAN" ] := hbNFe_PegaDadosXml( "cEAN", cItem )
   ::aItem[ "xProd" ] := hbNFe_PegaDadosXml( "xProd", cItem )
   ::aItem[ "NCM" ] := hbNFe_PegaDadosXml( "NCM", cItem )
   ::aItem[ "EXTIPI" ] := hbNFe_PegaDadosXml( "EXTIPI", cItem )
   ::aItem[ "CFOP" ] := hbNFe_PegaDadosXml( "CFOP", cItem )
   ::aItem[ "uCom" ] := hbNFe_PegaDadosXml( "uCom", cItem )
   ::aItem[ "qCom" ] := hbNFe_PegaDadosXml( "qCom", cItem )
   ::aItem[ "vUnCom" ] := hbNFe_PegaDadosXml( "vUnCom", cItem )
   ::aItem[ "vProd" ] := hbNFe_PegaDadosXml( "vProd", cItem )
   ::aItem[ "cEANTrib" ] := hbNFe_PegaDadosXml( "cEANTrib", cItem )
   ::aItem[ "uTrib" ] := hbNFe_PegaDadosXml( "uTrib", cItem )
   ::aItem[ "qTrib" ] := hbNFe_PegaDadosXml( "qTrib", cItem ) // NFE 2.0
   ::aItem[ "vUnTrib" ] := hbNFe_PegaDadosXml( "vUnTrib", cItem ) // NFE 2.0
   ::aItem[ "vFrete" ] := hbNFe_PegaDadosXml( "vFrete", cItem )
   ::aItem[ "vSeg" ] := hbNFe_PegaDadosXml( "vSeg", cItem )
   ::aItem[ "vDesc" ] := hbNFe_PegaDadosXml( "vDesc", cItem )
   ::aItem[ "vOutro" ] := hbNFe_PegaDadosXml( "vOutro", cItem ) // NFE 2.0
   ::aItem[ "indTot" ] := hbNFe_PegaDadosXml( "indTot", cItem ) // NFE 2.0
   ::aItem[ "infAdProd" ] := hbNFe_PegaDadosXml( "infAdProd", cItem )
   IF ::aItem[ "infAdProd" ] <> NIL
      ::aItem[ "infAdProd" ] := STRTRAN( ::aItem[ "infAdProd" ], ";", CHR(13)+CHR(10) )
   ENDIF

   cItemDI := hbNFe_PegaDadosXML('DI', cItem )
   ::aItemDI := hb_Hash()
   ::aItemDI[ "nDI" ] := hbNFe_PegaDadosXml( "nDI", cItemDI )
   ::aItemDI[ "dDI" ] := hbNFe_PegaDadosXml( "dDI", cItemDI )
   ::aItemDI[ "xLocDesemb" ] := hbNFe_PegaDadosXml( "xLocDesemb", cItemDI )
   ::aItemDI[ "UFDesemb" ] := hbNFe_PegaDadosXml( "UFDesemb", cItemDI )
   ::aItemDI[ "dDesemb" ] := hbNFe_PegaDadosXml( "dDesemb", cItemDI )
   ::aItemDI[ "cExportador" ] := hbNFe_PegaDadosXml( "cExportador", cItemDI )

   cItemAdi := hbNFe_PegaDadosXML('adi', cItem )
   ::aItemAdi := hb_Hash()
   ::aItemAdi[ "nAdicao" ] := hbNFe_PegaDadosXml( "nAdicao", cItemAdi )
   ::aItemAdi[ "nSeqAdic" ] := hbNFe_PegaDadosXml( "nSeqAdic", cItemAdi )
   ::aItemAdi[ "cFabricante" ] := hbNFe_PegaDadosXml( "cFabricante", cItemAdi )
   ::aItemAdi[ "vDescDI" ] := hbNFe_PegaDadosXml( "vDescDI", cItemAdi )
   ::aItemAdi[ "xPed" ] := hbNFe_PegaDadosXml( "xPed", cItemAdi ) // NFE 2.0
   ::aItemAdi[ "nItemPed" ] := hbNFe_PegaDadosXml( "nItemPed", cItemAdi ) // NFE 2.0

   // todo veiculos (veicProd), medicamentos (med), armamentos (arm), combustiveis (comb)

   cItemICMS := hbNFe_PegaDadosXML('ICMS', cItem )
   ::aItemICMS := hb_Hash()
   ::aItemICMS[ "orig" ] := hbNFe_PegaDadosXml( "orig", cItemICMS )
   ::aItemICMS[ "CST" ] := hbNFe_PegaDadosXml( "CST", cItemICMS )
   ::aItemICMS[ "CSOSN" ] := hbNFe_PegaDadosXml( "CSOSN", cItemICMS )
   ::aItemICMS[ "vBCSTRet" ] := hbNFe_PegaDadosXml( "vBCSTRet", cItemICMS )
   ::aItemICMS[ "vICMSSTRet" ] := hbNFe_PegaDadosXml( "vICMSSTRet", cItemICMS )
   ::aItemICMS[ "modBC" ] := hbNFe_PegaDadosXml( "modBC", cItemICMS )
   ::aItemICMS[ "pRedBC" ] := hbNFe_PegaDadosXml( "pRedBC", cItemICMS )
   ::aItemICMS[ "vBC" ] := hbNFe_PegaDadosXml( "vBC", cItemICMS )
   ::aItemICMS[ "pICMS" ] := hbNFe_PegaDadosXml( "pICMS", cItemICMS )
   ::aItemICMS[ "vICMS" ] := hbNFe_PegaDadosXml( "vICMS", cItemICMS )
   ::aItemICMS[ "motDesICMS" ] := hbNFe_PegaDadosXml( "motDesICMS", cItemICMS )
   ::aItemICMS[ "modBCST" ] := hbNFe_PegaDadosXml( "nItemICMS", cItemICMS )
   ::aItemICMS[ "pMVAST" ] := hbNFe_PegaDadosXml( "pMVAST", cItemICMS )
   ::aItemICMS[ "pRedBCST" ] := hbNFe_PegaDadosXml( "pRedBCST", cItemICMS )
   ::aItemICMS[ "vBCST" ] := hbNFe_PegaDadosXml( "vBCST", cItemICMS )
   ::aItemICMS[ "pICMSST" ] := hbNFe_PegaDadosXml( "pICMSST", cItemICMS )
   ::aItemICMS[ "vICMSST" ] := hbNFe_PegaDadosXml( "vICMSST", cItemICMS )

   cItemICMSPart := hbNFe_PegaDadosXML('ICMSPart', cItem )
   ::aItemICMSPart := hb_Hash()
   ::aItemICMSPart[ "orig" ] := hbNFe_PegaDadosXml( "orig", cItemICMSPart )
   ::aItemICMSPart[ "CST" ] := hbNFe_PegaDadosXml( "CST", cItemICMSPart )
   ::aItemICMSPart[ "modBC" ] := hbNFe_PegaDadosXml( "modBC", cItemICMSPart )
   ::aItemICMSPart[ "pRedBC" ] := hbNFe_PegaDadosXml( "pRedBC", cItemICMSPart )
   ::aItemICMSPart[ "vBC" ] := hbNFe_PegaDadosXml( "vBC", cItemICMSPart )
   ::aItemICMSPart[ "pICMS" ] := hbNFe_PegaDadosXml( "pICMS", cItemICMSPart )
   ::aItemICMSPart[ "vICMS" ] := hbNFe_PegaDadosXml( "vICMS", cItemICMSPart )
   ::aItemICMSPart[ "modBCST" ] := hbNFe_PegaDadosXml( "nItemICMSPart", cItemICMSPart )
   ::aItemICMSPart[ "pMVAST" ] := hbNFe_PegaDadosXml( "pMVAST", cItemICMSPart )
   ::aItemICMSPart[ "pRedBCST" ] := hbNFe_PegaDadosXml( "pRedBCST", cItemICMSPart )
   ::aItemICMSPart[ "vBCST" ] := hbNFe_PegaDadosXml( "vBCST", cItemICMSPart )
   ::aItemICMSPart[ "pICMSST" ] := hbNFe_PegaDadosXml( "pICMSST", cItemICMSPart )
   ::aItemICMSPart[ "vICMSST" ] := hbNFe_PegaDadosXml( "vICMSST", cItemICMSPart )
   ::aItemICMSPart[ "pBCOp" ] := hbNFe_PegaDadosXml( "pBCOp", cItemICMSPart )
   ::aItemICMSPart[ "UFST" ] := hbNFe_PegaDadosXml( "UFST", cItemICMSPart )

   cItemICMSST := hbNFe_PegaDadosXML('ICMSST', cItem )
   ::aItemICMSST := hb_Hash()
   ::aItemICMSST[ "orig" ] := hbNFe_PegaDadosXml( "orig", cItemICMSST )
   ::aItemICMSST[ "CST" ] := hbNFe_PegaDadosXml( "CST", cItemICMSST )
   ::aItemICMSST[ "vBCSTRet" ] := hbNFe_PegaDadosXml( "vBCSTRet", cItemICMSST )
   ::aItemICMSST[ "vICMSSTRet" ] := hbNFe_PegaDadosXml( "vICMSSTRet", cItemICMSST )
   ::aItemICMSST[ "vBCSTDest" ] := hbNFe_PegaDadosXml( "vBCSTDest", cItemICMSST )
   ::aItemICMSST[ "vICMSSTDest" ] := hbNFe_PegaDadosXml( "vICMSSTDest", cItemICMSST )

   cItemICMSSN101 := hbNFe_PegaDadosXML('ICMSSN101', cItem )
   ::aItemICMSSN101 := hb_Hash()
   ::aItemICMSSN101[ "orig" ] := hbNFe_PegaDadosXml( "orig", cItemICMSSN101 )
   ::aItemICMSSN101[ "CSOSN" ] := hbNFe_PegaDadosXml( "CSOSN", cItemICMSSN101 )
   ::aItemICMSSN101[ "pCredSN" ] := hbNFe_PegaDadosXml( "pCredSN", cItemICMSSN101 )
   ::aItemICMSSN101[ "vCredICMSSN" ] := hbNFe_PegaDadosXml( "vCredICMSSN", cItemICMSSN101 )

   cItemICMSSN102 := hbNFe_PegaDadosXML('ICMSSN102', cItem ) //102,103,300 ou 400
   ::aItemICMSSN102 := hb_Hash()
   ::aItemICMSSN102[ "orig" ] := hbNFe_PegaDadosXml( "orig", cItemICMSSN102 )
   ::aItemICMSSN102[ "CSOSN" ] := hbNFe_PegaDadosXml( "CSOSN", cItemICMSSN102 )

   cItemICMSSN201 := hbNFe_PegaDadosXML('ICMSSN201', cItem )
   ::aItemICMSSN201 := hb_Hash()
   ::aItemICMSSN201[ "orig" ] := hbNFe_PegaDadosXml( "orig", cItemICMSSN201 )
   ::aItemICMSSN201[ "CSOSN" ] := hbNFe_PegaDadosXml( "CSOSN", cItemICMSSN201 )
   ::aItemICMSSN201[ "modBCST" ] := hbNFe_PegaDadosXml( "modBCST", cItemICMSSN201 )
   ::aItemICMSSN201[ "pMVAST" ] := hbNFe_PegaDadosXml( "pMVAST", cItemICMSSN201 )
   ::aItemICMSSN201[ "pRedBCST" ] := hbNFe_PegaDadosXml( "pRedBCST", cItemICMSSN201 )
   ::aItemICMSSN201[ "vBCST" ] := hbNFe_PegaDadosXml( "vBCST", cItemICMSSN201 )
   ::aItemICMSSN201[ "pICMSST" ] := hbNFe_PegaDadosXml( "pICMSST", cItemICMSSN201 )
   ::aItemICMSSN201[ "vICMSST" ] := hbNFe_PegaDadosXml( "vICMSST", cItemICMSSN201 )
   ::aItemICMSSN201[ "pCredSN" ] := hbNFe_PegaDadosXml( "pCredSN", cItemICMSSN201 )
   ::aItemICMSSN201[ "vCredICMSSN" ] := hbNFe_PegaDadosXml( "vCredICMSSN", cItemICMSSN201 )

   cItemICMSSN202 := hbNFe_PegaDadosXML('ICMSSN202', cItem )  // 202 ou 203
   ::aItemICMSSN202 := hb_Hash()
   ::aItemICMSSN202[ "orig" ] := hbNFe_PegaDadosXml( "orig", cItemICMSSN202 )
   ::aItemICMSSN202[ "CSOSN" ] := hbNFe_PegaDadosXml( "CSOSN", cItemICMSSN202 )
   ::aItemICMSSN202[ "modBCST" ] := hbNFe_PegaDadosXml( "modBCST", cItemICMSSN202 )
   ::aItemICMSSN202[ "pMVAST" ] := hbNFe_PegaDadosXml( "pMVAST", cItemICMSSN202 )
   ::aItemICMSSN202[ "pRedBCST" ] := hbNFe_PegaDadosXml( "pRedBCST", cItemICMSSN202 )
   ::aItemICMSSN202[ "vBCST" ] := hbNFe_PegaDadosXml( "vBCST", cItemICMSSN202 )
   ::aItemICMSSN202[ "pICMSST" ] := hbNFe_PegaDadosXml( "pICMSST", cItemICMSSN202 )
   ::aItemICMSSN202[ "vICMSST" ] := hbNFe_PegaDadosXml( "vICMSST", cItemICMSSN202 )

   cItemICMSSN500 := hbNFe_PegaDadosXML('ICMSSN500', cItem )
   ::aItemICMSSN500 := hb_Hash()
   ::aItemICMSSN500[ "orig" ] := hbNFe_PegaDadosXml( "orig", cItemICMSSN500 )
   ::aItemICMSSN500[ "CSOSN" ] := hbNFe_PegaDadosXml( "CSOSN", cItemICMSSN500 )
   ::aItemICMSSN500[ "vBCSTRet" ] := hbNFe_PegaDadosXml( "vBCSTRet", cItemICMSSN500 )
   ::aItemICMSSN500[ "vICMSSTRet" ] := hbNFe_PegaDadosXml( "vICMSSTRet", cItemICMSSN500 )

   cItemICMSSN900 := hbNFe_PegaDadosXML('ICMSSN900', cItem )
   ::aItemICMSSN900 := hb_Hash()
   ::aItemICMSSN900[ "orig" ] := hbNFe_PegaDadosXml( "orig", cItemICMSSN900 )
   ::aItemICMSSN900[ "CSOSN" ] := hbNFe_PegaDadosXml( "CSOSN", cItemICMSSN900 )
   ::aItemICMSSN900[ "modBC" ] := hbNFe_PegaDadosXml( "modBC", cItemICMSSN900 )
   ::aItemICMSSN900[ "pRedBC" ] := hbNFe_PegaDadosXml( "pRedBC", cItemICMSSN900 )
   ::aItemICMSSN900[ "vBC" ] := hbNFe_PegaDadosXml( "vBC", cItemICMSSN900 )
   ::aItemICMSSN900[ "pICMS" ] := hbNFe_PegaDadosXml( "pICMS", cItemICMSSN900 )
   ::aItemICMSSN900[ "vICMS" ] := hbNFe_PegaDadosXml( "vICMS", cItemICMSSN900 )
   ::aItemICMSSN900[ "modBCST" ] := hbNFe_PegaDadosXml( "modBCST", cItemICMSSN900 )
   ::aItemICMSSN900[ "pMVAST" ] := hbNFe_PegaDadosXml( "pMVAST", cItemICMSSN900 )
   ::aItemICMSSN900[ "pRedBCST" ] := hbNFe_PegaDadosXml( "pRedBCST", cItemICMSSN900 )
   ::aItemICMSSN900[ "vBCST" ] := hbNFe_PegaDadosXml( "vBCST", cItemICMSSN900 )
   ::aItemICMSSN900[ "pICMSST" ] := hbNFe_PegaDadosXml( "pICMSST", cItemICMSSN900 )
   ::aItemICMSSN900[ "vICMSST" ] := hbNFe_PegaDadosXml( "vICMSST", cItemICMSSN900 )
   ::aItemICMSSN900[ "pCredSN" ] := hbNFe_PegaDadosXml( "pCredSN", cItemICMSSN900 )
   ::aItemICMSSN900[ "vCredICMSSN" ] := hbNFe_PegaDadosXml( "vCredICMSSN", cItemICMSSN900 )


   cItemIPI := hbNFe_PegaDadosXML('IPI', cItem )
   ::aItemIPI := hb_Hash()
   ::aItemIPI[ "clEnq" ] := hbNFe_PegaDadosXml( "clEnq", cItemIPI )
   ::aItemIPI[ "CNPJProd" ] := hbNFe_PegaDadosXml( "CNPJProd", cItemIPI )
   ::aItemIPI[ "cSelo" ] := hbNFe_PegaDadosXml( "cSelo", cItemIPI )
   ::aItemIPI[ "qSelo" ] := hbNFe_PegaDadosXml( "qSelo", cItemIPI )
   ::aItemIPI[ "cEnq" ] := hbNFe_PegaDadosXml( "cEnq", cItemIPI )

   ::aItemIPI[ "CST" ] := hbNFe_PegaDadosXml( "CST", cItemIPI )
   ::aItemIPI[ "vBC" ] := hbNFe_PegaDadosXml( "vBC", cItemIPI )
   ::aItemIPI[ "pIPI" ] := hbNFe_PegaDadosXml( "pIPI", cItemIPI )
   ::aItemIPI[ "qUnid" ] := hbNFe_PegaDadosXml( "qUnid", cItemIPI )
   ::aItemIPI[ "vUnid" ] := hbNFe_PegaDadosXml( "vUnid", cItemIPI )
   ::aItemIPI[ "vIPI" ] := hbNFe_PegaDadosXml( "vIPI", cItemIPI )

   cItemII := hbNFe_PegaDadosXML('II', cItem )
   ::aItemII := hb_Hash()
   ::aItemII[ "vBC" ] := hbNFe_PegaDadosXml( "vBC", cItemII )
   ::aItemII[ "vDespAdu" ] := hbNFe_PegaDadosXml( "vDespAdu", cItemII )
   ::aItemII[ "vII" ] := hbNFe_PegaDadosXml( "vII", cItemII )
   ::aItemII[ "vIOF" ] := hbNFe_PegaDadosXml( "vIOF", cItemII )

   cItemPIS := hbNFe_PegaDadosXML('PIS', cItem )
   ::aItemPIS := hb_Hash()
   ::aItemPIS[ "CST" ] := hbNFe_PegaDadosXml( "CST", cItemPIS )
   ::aItemPIS[ "vBC" ] := hbNFe_PegaDadosXml( "vBC", cItemPIS )
   ::aItemPIS[ "pPIS" ] := hbNFe_PegaDadosXml( "pPIS", cItemPIS )
   ::aItemPIS[ "vPIS" ] := hbNFe_PegaDadosXml( "vPIS", cItemPIS )

   ::aItemPIS[ "qBCProd" ] := hbNFe_PegaDadosXml( "qBCProd", cItemPIS )
   ::aItemPIS[ "vAliqProd" ] := hbNFe_PegaDadosXml( "vAliqProd", cItemPIS )

   cItemPISST := hbNFe_PegaDadosXML('PISST', cItem )
   ::aItemPISST := hb_Hash()
   ::aItemPISST[ "vBC" ] := hbNFe_PegaDadosXml( "vBC", cItemPISST )
   ::aItemPISST[ "pPIS" ] := hbNFe_PegaDadosXml( "pPIS", cItemPISST )
   ::aItemPISST[ "vPIS" ] := hbNFe_PegaDadosXml( "vPIS", cItemPISST )
   ::aItemPISST[ "qBCProd" ] := hbNFe_PegaDadosXml( "qBCProd", cItemPISST )
   ::aItemPISST[ "vAliqProd" ] := hbNFe_PegaDadosXml( "vAliqProd", cItemPISST )

   cItemCOFINS := hbNFe_PegaDadosXML('COFINS', cItem )
   ::aItemCOFINS := hb_Hash()
   ::aItemCOFINS[ "CST" ] := hbNFe_PegaDadosXml( "CST", cItemCOFINS )
   ::aItemCOFINS[ "vBC" ] := hbNFe_PegaDadosXml( "vBC", cItemCOFINS )
   ::aItemCOFINS[ "pCOFINS" ] := hbNFe_PegaDadosXml( "pCOFINS", cItemCOFINS )
   ::aItemCOFINS[ "vCOFINS" ] := hbNFe_PegaDadosXml( "vCOFINS", cItemCOFINS )

   ::aItemCOFINS[ "qBCProd" ] := hbNFe_PegaDadosXml( "qBCProd", cItemCOFINS )
   ::aItemCOFINS[ "vAliqProd" ] := hbNFe_PegaDadosXml( "vAliqProd", cItemCOFINS )

   cItemCOFINSST := hbNFe_PegaDadosXML('COFINSST', cItem )
   ::aItemCOFINSST := hb_Hash()
   ::aItemCOFINSST[ "vBC" ] := hbNFe_PegaDadosXml( "vBC", cItemCOFINSST )
   ::aItemCOFINSST[ "pCOFINS" ] := hbNFe_PegaDadosXml( "pCOFINS", cItemCOFINSST )
   ::aItemCOFINSST[ "vCOFINS" ] := hbNFe_PegaDadosXml( "vCOFINS", cItemCOFINSST )
   ::aItemCOFINSST[ "qBCProd" ] := hbNFe_PegaDadosXml( "qBCProd", cItemCOFINSST )
   ::aItemCOFINSST[ "vAliqProd" ] := hbNFe_PegaDadosXml( "vAliqProd", cItemCOFINSST )

   cItemISSQN := hbNFe_PegaDadosXML('ISSQN', cItem )
   ::aItemISSQN := hb_Hash()
   ::aItemISSQN[ "vBC" ] := hbNFe_PegaDadosXml( "vBC", cItemISSQN )
   ::aItemISSQN[ "vAliq" ] := hbNFe_PegaDadosXml( "vAliq", cItemISSQN )
   ::aItemISSQN[ "vISSQN" ] := hbNFe_PegaDadosXml( "vISSQN", cItemISSQN )
   ::aItemISSQN[ "cMunFG" ] := hbNFe_PegaDadosXml( "cMunFG", cItemISSQN )
   ::aItemISSQN[ "cListServ" ] := hbNFe_PegaDadosXml( "cListServ", cItemISSQN )
   ::aItemISSQN[ "cSitTrib" ] := hbNFe_PegaDadosXml( "cSitTrib", cItemISSQN )  // N – NORMAL R – RETIDA S –SUBSTITUTA I – ISENTA. (v.2.0)

   RETURN NIL

FUNCTION hbNFe_PegaDadosXML(cElemento, cStringXML, cElemento2)

   LOCAL InicioDoDado,FinalDoDado,nPosIni,nPosFim, cRet := NIL

   IF cStringXML = NIL
      RETURN cRet
   ENDIF
   InicioDoDado := Iif( cElemento2 == NIL, "<" + cElemento + ">", "<" + cElemento )
   FinalDoDado  := Iif( cElemento2 == NIL, "</" + cElemento + ">", '</' + cElemento2 + '>' )
   nPosIni      := At( InicioDoDado, cStringXML )
   nPosFim      := hb_At( FinalDoDado, cStringXML, nPosIni )

   IF nPosIni==0 .OR. nPosFim==0
      RETURN cRet
   ENDIF
   cRet := Substr( cStringXML, nPosIni + Len( IniciodoDado ), nPosFim - nPosIni - Len( FinalDoDado ) + 1 )

   RETURN cRet

FUNCTION hbNFe_Texto_Hpdf( oPdfPage2, x1, y1, x2, y2, cText, align, desconhecido, oFontePDF, nTamFonte, nAngulo )

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
      HPDF_Page_SetTextMatrix( oPdfPage2, cos( nRadiano ), sin( nRadiano ), -sin( nRadiano ), cos( nRadiano ), x1, y1 )
      HPDF_Page_ShowText( oPdfPage2, cText )
   ENDIF
   HPDF_Page_EndText  ( oPdfPage2 )

   HB_SYMBOL_UNUSED( desconhecido )

   RETURN NIL

FUNCTION hbNFe_Box_Hpdf( oPdfPage2, x1, y1, x2, y2, nPen)

   HPDF_Page_SetLineWidth( oPdfPage2, nPen )
   HPDF_Page_Rectangle( oPdfPage2, x1, y1, x2, y2 )
   HPDF_Page_Stroke( oPdfPage2 )

   RETURN NIL

FUNCTION hbNFe_Line_Hpdf( oPdfPage2, x1, y1, x2, y2, nPen, FLAG)

   HPDF_Page_SetLineWidth(oPdfPage2, nPen)
   IF FLAG <> NIL
      HPDF_Page_SetLineCap( oPdfPage2, FLAG)
   ENDIF
   HPDF_Page_MoveTo(oPdfPage2, x1, y1)
   HPDF_Page_LineTo(oPdfPage2, x2, y2)
   HPDF_Page_Stroke(oPdfPage2)
   IF FLAG <> NIL
      HPDF_Page_SetLineCap(oPdfPage2, HPDF_BUTT_END)
   ENDIF

   RETURN NIL

#ifndef __XHARBOUR__
FUNCTION hbNFe_Zebrea_Draw_Hpdf( hZebra, page, ... )

   IF hb_zebra_GetError( hZebra ) != 0
      RETURN HB_ZEBRA_ERROR_INVALIDZEBRA
   ENDIF

   hb_zebra_draw( hZebra, {| x, y, w, h | HPDF_Page_Rectangle( page, x, y, w, h ) }, ... )

   HPDF_Page_Fill( page )

   RETURN 0
#endif

FUNCTION CodificaCode128c(pcCodigoBarra)

&&  Parameters de entrada : O codigo de barras no formato Code128C "somente numeros" campo tipo caracter
&&  Retorno               : Retorna o código convertido e com o caracter de START e STOP mais o checksum
&&                        : para impressão do código de barras utilizando a fonte Code128bWin, é necessário
&&                        : para utilizar essa fonte os arquivos Code128bWin.ttf, Code128bWin.afm e Code128bWin.pfb
&& Autor                  : Anderson Camilo
&& Data                   : 19/03/2012

LOCAL nI :=0, checksum :=0, nValorCar, cCode128 := '', cCodigoBarra

   cCodigoBarra = pcCodigoBarra
   IF len( cCodigoBarra ) > 0    && Verifica se os caracteres são válidos (somente números)
      IF int( len( cCodigoBarra ) / 2 ) = len( cCodigoBarra ) / 2    && Tem ser par o tamanho do código de barras
         FOR nI = 1 to len( cCodigoBarra )
            IF ( Asc( substr( cCodigoBarra, nI, 1 ) ) < 48 .OR. Asc( substr( cCodigoBarra, nI, 1 ) ) > 57 )
                nI = 0
	            EXIT
            ENDIF
         NEXT
      ENDIF
      IF nI > 0
         nI = 1 &&  nI é o índice da cadeia
         cCode128 = chr(155)
         DO WHILE nI <= len ( cCodigoBarra )
            nValorCar = val ( substr( cCodigoBarra, nI, 2 ) )
            IF nValorCar = 0
                nValorCar += 128
             ELSEIF nValorCar < 95
                nValorCar += 32
             ELSE
                nValorCar +=  50
             ENDIF
             cCode128 += Chr( nValorCar )
             nI = nI + 2
         ENDDO
         && Calcula o checksum
         FOR nI = 1 TO len( cCode128 )
            nValorCar = asc ( substr( cCode128, nI, 1 ) )
            IF nValorCar = 128
               nValorCar = 0
            ELSEIF nValorCar < 127
               nValorCar -= 32
            ELSE
               nValorCar -=  50
            ENDIF
            IF nI = 1
		         checksum = nValorCar
            ENDIF
            checksum = mod( ( checksum + ( nI - 1 ) * nValorCar ), 103 )
         NEXT
	      &&  Cálculo código ASCII do checkSum
         IF checksum = 0
            checksum += 128
         ELSEIF checksum < 95
            checksum += 32
         ELSE
            checksum +=  50
         ENDIF
         && Adiciona o checksum e STOP
         cCode128 = cCode128 + Chr( checksum ) +  chr(156)
      ENDIF
   ENDIF

   RETURN cCode128
