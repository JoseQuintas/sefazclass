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

   METHOD execute()
   METHOD buscaDadosXML()
   METHOD geraPDF()
   METHOD novaPagina()
   METHOD saltaPagina()
   METHOD cabecalho()
   METHOD destinatario()
   METHOD duplicatas()
   METHOD faturas()
   METHOD cabecalhoCobranca(nLinhaFinalCob,nTamanhoCob)
   METHOD canhoto()
   METHOD dadosImposto()
   METHOD dadosTransporte()
   METHOD cabecalhoProdutos()
   METHOD desenhaBoxProdutos(nLinhaFinalProd,nTamanhoProd)
   METHOD produtos()
   METHOD totalServico()
   METHOD dadosAdicionais()
   METHOD rodape()
   METHOD ProcessaItens(cXML,nItem)
   METHOD calculaItens1Folha(nItensInicial)

   VAR nItens1Folha
   VAR nItensDemaisFolhas
   VAR nLarguraDescricao

   VAR cTelefoneEmitente INIT ""
   VAR cSiteEmitente     INIT ""
   VAR cEmailEmitente    INIT ""
   VAR cDesenvolvedor    INIT ""
   VAR cArquivoXML
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
   VAR lLaser INIT .T.
   VAR lPaisagem
   VAR cLogoFile
   VAR nLogoStyle // 1-esquerda, 2-direita, 3-expandido

   VAR nItensFolha
   VAR nLinhaFolha
   VAR nFolhas
   VAR nFolha

   VAR cFile
   VAR lValorDesc INIT .F.
   VAR nCasasQtd INIT 2
   VAR nCasasVUn INIT 2
   VAR aRetorno

   ENDCLASS

METHOD execute() CLASS hbNFeDanfe

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
   ::cChave := SUBS( ::cXML, AT('Id=',::cXML)+3+4,44)

   IF !::buscaDadosXML()
      RETURN(::aRetorno)
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
      ::aRetorno[ 'OK' ] := .F.
      ::aRetorno[ 'MsgErro' ] := 'Problema ao gerar o PDF !'
      RETURN(::aRetorno)
   ENDIF
   ::aRetorno[ 'OK' ] := .T.

   RETURN ::aRetorno

METHOD buscaDadosXML() CLASS hbNFeDanfe

   LOCAL cIde, cEmit, cDest, cRetirada, cEntrega, cICMSTotal, cISSTotal, cRetTrib, ;
         cTransp, cVeicTransp, cReboque, cInfAdic, cObsCont, cObsFisco, ;
         cExporta, cCompra, cInfProt // /////////////////////// cCobranca

   cIde := hbNFe_PegaDadosXML("ide", ::cXML )
   ::aIde := hb_Hash()
   ::aIde[ "cUF" ] := hbNFe_PegaDadosXML("cUF", cIde )
   ::aIde[ "cNF" ] := hbNFe_PegaDadosXML("cNF", cIde )
   ::aIde[ "natOp" ] := hbNFe_PegaDadosXML("natOp", cIde )
   ::aIde[ "indPag" ] := hbNFe_PegaDadosXML("indPag", cIde )
   ::aIde[ "mod" ] := hbNFe_PegaDadosXML("mod", cIde )
   ::aIde[ "serie" ] := hbNFe_PegaDadosXML("serie", cIde )
   ::aIde[ "nNF" ] := hbNFe_PegaDadosXML("nNF", cIde )
   ::aIde[ "dhEmi" ] := hbNFe_PegaDadosXML("dhEmi", cIde )
   IF ::aIde[ "dhEmi" ] = Nil .OR. EMPTY(::aIde[ "dhEmi" ]) // NFE 2.0
      ::aIde[ "dhEmi" ] := hbNFe_PegaDadosXML("dEmi", cIde )
   ENDIF
   ::aIde[ "dhSaiEnt" ] := hbNFe_PegaDadosXML("dhSaiEnt", cIde )
   IF ::aIde[ "dhSaiEnt" ] = Nil .OR. EMPTY(::aIde[ "dhSaiEnt" ]) // NFE 2.0
      ::aIde[ "dhSaiEnt" ] := hbNFe_PegaDadosXML("dSaiEnt", cIde )+"T"+TIME()
   ENDIF
   ::aIde[ "tpNF" ] := hbNFe_PegaDadosXML("tpNF", cIde )
   ::aIde[ "cMunFG" ] := hbNFe_PegaDadosXML("cMunFG", cIde )
   ::aIde[ "tpImp" ] := hbNFe_PegaDadosXML("tpImp", cIde )  // 1 - retrato 2-paisagem
   ::aIde[ "tpEmis" ] := hbNFe_PegaDadosXML("tpEmis", cIde )
   ::aIde[ "cDV" ] := hbNFe_PegaDadosXML("cDV", cIde )
   ::aIde[ "tpAmb" ] := hbNFe_PegaDadosXML("tpAmb", cIde )  // 1- producao 2-homologacao
   ::aIde[ "finNFe" ] := hbNFe_PegaDadosXML("finNFe", cIde ) // finalidade 1-normal/2-complementar 3- de ajuste
   ::aIde[ "procEmi" ] := hbNFe_PegaDadosXML("procEmi", cIde ) //0 - emissão de NF-e com aplicativo do contribuinte 1 - emissão de NF-e avulsa pelo Fisco 2 - emissão de NF-e avulsa pelo contribuinte com seu certificado digital, através do site do Fisco 3- emissão NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.
   ::aIde[ "verProc" ] := hbNFe_PegaDadosXML("verProc", cIde ) // versao sistema

   cEmit := hbNFe_PegaDadosXML("emit", ::cXML )
   ::aEmit := hb_Hash()
   ::aEmit[ "CNPJ" ] := hbNFe_PegaDadosXML("CNPJ", cEmit )
   ::aEmit[ "CPF" ] := hbNFe_PegaDadosXML("CPF", cEmit ) // avulso pelo fisco
   ::aEmit[ "xNome" ] := XmlToString( hbNFe_PegaDadosXML("xNome", cEmit ) )
   ::aEmit[ "xFant" ] := hbNFe_PegaDadosXML("xFant", cEmit )
   ::aEmit[ "xLgr" ] := hbNFe_PegaDadosXML("xLgr", cEmit )
   ::aEmit[ "nro" ] := hbNFe_PegaDadosXML("nro", cEmit )
   ::aEmit[ "xBairro" ] := hbNFe_PegaDadosXML("xBairro", cEmit )
   ::aEmit[ "cMun" ] := hbNFe_PegaDadosXML("cMun", cEmit )
   ::aEmit[ "xMun" ] := hbNFe_PegaDadosXML("xMun", cEmit )
   ::aEmit[ "UF" ] := hbNFe_PegaDadosXML("UF", cEmit )
   ::aEmit[ "CEP" ] := hbNFe_PegaDadosXML("CEP", cEmit )
   ::aEmit[ "cPais" ] := hbNFe_PegaDadosXML("cPais", cEmit )
   ::aEmit[ "xPais" ] := hbNFe_PegaDadosXML("xPais", cEmit )
   ::aEmit[ "fone" ] := hbNFe_PegaDadosXML("fone", cEmit ) // NFE 2.0
   ::aEmit[ "IE" ] := hbNFe_PegaDadosXML("IE", cEmit )
   ::aEmit[ "IEST" ] := hbNFe_PegaDadosXML("IEST", cEmit )
   ::aEmit[ "IM" ] := hbNFe_PegaDadosXML("IM", cEmit )
   ::aEmit[ "CNAE" ] := hbNFe_PegaDadosXML("CNAE", cEmit )
   ::aEmit[ "CRT" ] := hbNFe_PegaDadosXML("CRT", cEmit ) // NFE 2.0 1 simpl nac 2 sim nac ex. sub receita 3 regime normal

   TRY
      ::cTelefoneEmitente := TRANSF( Sonumeros(ALLTRIM(hbNFe_PegaDadosXML("fone", cEmit ))),"@R (99) 99999-9999")
   CATCH
      ::cTelefoneEmitente := ""
   END

   cDest := hbNFe_PegaDadosXML("dest", ::cXML )
   ::aDest := hb_Hash()
   ::aDest[ "CNPJ" ] := hbNFe_PegaDadosXML("CNPJ", cDest )
   ::aDest[ "CPF" ] := hbNFe_PegaDadosXML("CPF", cDest )
   ::aDest[ "xNome" ] := XmlToString( hbNFe_PegaDadosXML("xNome", cDest ) )
   ::aDest[ "xLgr" ] := hbNFe_PegaDadosXML("xLgr", cDest )
   ::aDest[ "nro" ] := hbNFe_PegaDadosXML("nro", cDest )
   ::aDest[ "xBairro" ] := hbNFe_PegaDadosXML("xBairro", cDest )
   ::aDest[ "cMun" ] := hbNFe_PegaDadosXML("cMun", cDest )
   ::aDest[ "xMun" ] := hbNFe_PegaDadosXML("xMun", cDest )
   ::aDest[ "UF" ] := hbNFe_PegaDadosXML("UF", cDest )
   ::aDest[ "CEP" ] := hbNFe_PegaDadosXML("CEP", cDest )
   *IF ( ::aDest[ "CEP" ] = Nil .OR. EMPTY(ALLTRIM(::aDest[ "CEP" ])) ) .AND. ::aDest[ "UF" ]  <> "EX"
   *   ::aRetorno[ 'OK' ] := .F.
   *   ::aRetorno[ 'MsgErro' ] := 'Destinatário sem CEP ou inválido !'
   *   RETURN(.F.)
   *ENDIF
   ::aDest[ "cPais" ] := hbNFe_PegaDadosXML("cPais", cDest )
   ::aDest[ "xPais" ] := hbNFe_PegaDadosXML("xPais", cDest )
   TRY
      ::aDest[ "fone" ] := IF(LEN(hbNFe_PegaDadosXML("fone", cDest ))<=8,"00"+hbNFe_PegaDadosXML("fone", cDest ),hbNFe_PegaDadosXML("fone", cDest ))
   CATCH
      ::aDest[ "fone" ] := ''
   END
   ::aDest[ "IE" ] := hbNFe_PegaDadosXML("IE", cDest )
   ::aDest[ "ISUF" ] := hbNFe_PegaDadosXML("ISUF", cDest ) // NFE 2.0
   ::aDest[ "email" ] := hbNFe_PegaDadosXML("email", cDest ) // NFE 2.0
*   IF ::aDest[ "email" ] = Nil .OR. EMPTY(ALLTRIM(::aDest[ "email" ]))
*      ::aRetorno[ 'OK' ] := .F.
*      ::aRetorno[ 'MsgErro' ] := 'Destinatário sem eMail ou inválido !'
*      RETURN(.F.)
*   ENDIF

   cRetirada := hbNFe_PegaDadosXML("retirada", ::cXML )
   ::aRetirada := hb_Hash()
   ::aRetirada[ "CNPJ" ] := hbNFe_PegaDadosXML("CNPJ", cRetirada ) // NFE 2.0
   ::aRetirada[ "CPF" ] := hbNFe_PegaDadosXML("CPF", cRetirada ) // NFE 2.0
   ::aRetirada[ "xLgr" ] := hbNFe_PegaDadosXML("xLgr", cRetirada )
   ::aRetirada[ "nro" ] := hbNFe_PegaDadosXML("nro", cRetirada )
   ::aRetirada[ "xCpl" ] := hbNFe_PegaDadosXML("xCpl", cRetirada )
   ::aRetirada[ "xBairro" ] := hbNFe_PegaDadosXML("xBairro", cRetirada )
   ::aRetirada[ "cMun" ] := hbNFe_PegaDadosXML("cMun", cRetirada )
   ::aRetirada[ "xMun" ] := hbNFe_PegaDadosXML("xMun", cRetirada )
   ::aRetirada[ "UF" ] := hbNFe_PegaDadosXML("UF", cRetirada )

   cEntrega := hbNFe_PegaDadosXML("entrega", ::cXML )
   ::aEntrega := hb_Hash()
   ::aEntrega[ "CNPJ" ] := hbNFe_PegaDadosXML("CNPJ", cEntrega ) // NFE 2.0
   ::aEntrega[ "CPF" ] := hbNFe_PegaDadosXML("CPF", cEntrega ) // NFE 2.0
   ::aEntrega[ "xLgr" ] := hbNFe_PegaDadosXML("xLgr", cEntrega )
   ::aEntrega[ "nro" ] := hbNFe_PegaDadosXML("nro", cEntrega )
   ::aEntrega[ "xCpl" ] := hbNFe_PegaDadosXML("xCpl", cEntrega )
   ::aEntrega[ "xBairro" ] := hbNFe_PegaDadosXML("xBairro", cEntrega )
   ::aEntrega[ "cMun" ] := hbNFe_PegaDadosXML("cMun", cEntrega )
   ::aEntrega[ "xMun" ] := hbNFe_PegaDadosXML("xMun", cEntrega )
   ::aEntrega[ "UF" ] := hbNFe_PegaDadosXML("UF", cEntrega )



   // totais da NF
   cICMSTotal := hbNFe_PegaDadosXML("ICMSTot", ::cXML )
   ::aICMSTotal := hb_Hash()
   ::aICMSTotal[ "vBC" ] := hbNFe_PegaDadosXML("vBC", cICMSTotal )
   ::aICMSTotal[ "vICMS" ] := hbNFe_PegaDadosXML("vICMS", cICMSTotal )
   ::aICMSTotal[ "vBCST" ] := hbNFe_PegaDadosXML("vBCST", cICMSTotal )
   ::aICMSTotal[ "vST" ] := hbNFe_PegaDadosXML("vST", cICMSTotal )
   ::aICMSTotal[ "vProd" ] := hbNFe_PegaDadosXML("vProd", cICMSTotal )
   ::aICMSTotal[ "vFrete" ] := hbNFe_PegaDadosXML("vFrete", cICMSTotal )
   ::aICMSTotal[ "vSeg" ] := hbNFe_PegaDadosXML("vSeg", cICMSTotal )
   ::aICMSTotal[ "vDesc" ] := hbNFe_PegaDadosXML("vDesc", cICMSTotal )
   ::aICMSTotal[ "vII" ] := hbNFe_PegaDadosXML("vII", cICMSTotal )
   ::aICMSTotal[ "vIPI" ] := hbNFe_PegaDadosXML("vIPI", cICMSTotal )
   ::aICMSTotal[ "vPIS" ] := hbNFe_PegaDadosXML("vPIS", cICMSTotal )
   ::aICMSTotal[ "vCOFINS" ] := hbNFe_PegaDadosXML("vCOFINS", cICMSTotal )
   ::aICMSTotal[ "vOutro" ] := hbNFe_PegaDadosXML("vOutro", cICMSTotal )
   ::aICMSTotal[ "vNF" ] := hbNFe_PegaDadosXML("vNF", cICMSTotal )

   cISSTotal := hbNFe_PegaDadosXML("ISSQNtot", ::cXML )
   ::aISSTotal := hb_Hash()
   ::aISSTotal[ "vServ" ] := hbNFe_PegaDadosXML("vServ", cISSTotal )
   ::aISSTotal[ "vBC" ] := hbNFe_PegaDadosXML("vBC", cISSTotal )
   ::aISSTotal[ "vISS" ] := hbNFe_PegaDadosXML("vISS", cISSTotal )
   ::aISSTotal[ "vPIS" ] := hbNFe_PegaDadosXML("vPIS", cISSTotal )
   ::aISSTotal[ "vCOFINS" ] := hbNFe_PegaDadosXML("vCOFINS", cISSTotal )

   cRetTrib := hbNFe_PegaDadosXML("RetTrib", ::cXML )
   ::aRetTrib := hb_Hash()
   ::aRetTrib[ "vRetPIS" ] := hbNFe_PegaDadosXML("vRetPIS", cRetTrib )
   ::aRetTrib[ "vRetCOFINS" ] := hbNFe_PegaDadosXML("vRetCOFINS", cRetTrib )
   ::aRetTrib[ "vRetCSLL" ] := hbNFe_PegaDadosXML("vRetCSLL", cRetTrib )
   ::aRetTrib[ "vBCIRRF" ] := hbNFe_PegaDadosXML("vBCIRRF", cRetTrib )
   ::aRetTrib[ "vIRRF" ] := hbNFe_PegaDadosXML("vIRRF", cRetTrib )
   ::aRetTrib[ "vBCRetPrev" ] := hbNFe_PegaDadosXML("vBCRetPrev", cRetTrib )
   ::aRetTrib[ "vRetPrev" ] := hbNFe_PegaDadosXML("vRetPrev", cRetTrib )


   cTransp := hbNFe_PegaDadosXML("transp", ::cXML )
   ::aTransp := hb_Hash()
   ::aTransp[ "modFrete" ] := hbNFe_PegaDadosXML("modFrete", cTransp )
   ::aTransp[ "CNPJ" ] := hbNFe_PegaDadosXML("CNPJ", cTransp )
   ::aTransp[ "CPF" ] := hbNFe_PegaDadosXML("CPF", cTransp )
   ::aTransp[ "xNome" ] := hbNFe_PegaDadosXML("xNome", cTransp )
   ::aTransp[ "IE" ] := hbNFe_PegaDadosXML("IE", cTransp ) // NFE 2.0
   ::aTransp[ "xEnder" ] := hbNFe_PegaDadosXML("xEnder", cTransp )
   ::aTransp[ "xMun" ] := hbNFe_PegaDadosXML("xMun", cTransp )
   ::aTransp[ "UF" ] := hbNFe_PegaDadosXML("UF", cTransp )
   // veicTransp
   cVeicTransp := hbNFe_PegaDadosXML("veicTransp", cTransp )
   ::aVeicTransp := hb_Hash()
   ::aVeicTransp[ "placa" ] := hbNFe_PegaDadosXML("placa", cVeicTransp )
   ::aVeicTransp[ "UF" ] := hbNFe_PegaDadosXML("UF", cVeicTransp )
   ::aVeicTransp[ "RNTC" ] := hbNFe_PegaDadosXML("RNTC", cVeicTransp ) //ANTT
   //reboque
   cReboque := hbNFe_PegaDadosXML("veicTransp", cTransp )
   ::aReboque := hb_Hash()
   ::aReboque[ "placa" ] := hbNFe_PegaDadosXML("placa", cReboque )
   ::aReboque[ "UF" ] := hbNFe_PegaDadosXML("UF", cReboque )
   ::aReboque[ "RNTC" ] := hbNFe_PegaDadosXML("RNTC", cReboque ) //ANTT
   // dados transportados
   ::aTransp[ "qVol" ] := hbNFe_PegaDadosXML("qVol", cTransp )
   ::aTransp[ "esp" ] := hbNFe_PegaDadosXML("esp", cTransp )
   ::aTransp[ "marca" ] := hbNFe_PegaDadosXML("marca", cTransp )
   ::aTransp[ "nVol" ] := hbNFe_PegaDadosXML("nVol", cTransp )
   ::aTransp[ "pesoL" ] := hbNFe_PegaDadosXML("pesoL", cTransp )
   ::aTransp[ "pesoB" ] := hbNFe_PegaDadosXML("pesoB", cTransp )
   ::aTransp[ "nLacre" ] := hbNFe_PegaDadosXML("nLacre", cTransp )

   ::cCobranca := hbNFe_PegaDadosXML("cobr", ::cXML )

   cInfAdic := hbNFe_PegaDadosXML("infAdic", ::cXML )
   ::aInfAdic := hb_Hash()

   IF !EMPTY(cInfAdic)   // Mauricio Cruz - 28/09/2011   && Anderson Retirei o + antes do CHR(13)+CHR(10)
      ::aInfAdic[ "infCpl" ] := hbNFe_PegaDadosXML("infCpl", cInfAdic )
	  IF !EMPTY(::aInfAdic[ "infCpl" ])
         ::aInfAdic[ "infCpl" ] := STRTRAN( ::aInfAdic[ "infCpl" ], ";", CHR(13)+CHR(10) )
	   ELSE
         ::aInfAdic[ "infCpl" ] := ""
	  endif
   ELSE
      ::aInfAdic[ "infCpl" ] := ""
   ENDIF
   //obsCont
   cObsCont := hbNFe_PegaDadosXML("obsCont", cInfAdic )
   ::aObsCont := hb_Hash()
   ::aObsCont[ "xCampo" ] := hbNFe_PegaDadosXML("xCampo", cObsCont )
   ::aObsCont[ "xTexto" ] := hbNFe_PegaDadosXML("xTexto", cObsCont )
   //obsFisco
   cObsFisco := hbNFe_PegaDadosXML("obsFisco", cInfAdic )
   ::aObsFisco := hb_Hash()
   ::aObsFisco[ "xCampo" ] := hbNFe_PegaDadosXML("xCampo", cObsFisco )
   ::aObsFisco[ "xTexto" ] := hbNFe_PegaDadosXML("xTexto", cObsFisco )

   cExporta := hbNFe_PegaDadosXML("exporta", ::cXML )
   ::aExporta := hb_Hash()
   ::aExporta[ "UFEmbarq" ] := hbNFe_PegaDadosXML("infCpl", cExporta )
   ::aExporta[ "xLocEmbarq" ] := hbNFe_PegaDadosXML("infCpl", cExporta )

   cCompra := hbNFe_PegaDadosXML("compra", ::cXML )
   ::aCompra := hb_Hash()
   ::aCompra[ "xNEmp" ] := hbNFe_PegaDadosXML("infCpl", cCompra )
   ::aCompra[ "xPed" ] := hbNFe_PegaDadosXML("infCpl", cCompra )
   ::aCompra[ "xCont" ] := hbNFe_PegaDadosXML("infCpl", cCompra )

   cInfProt := hbNFe_PegaDadosXML("infProt", ::cXML, "infProt" )
   //cInfProt := hbNFe_PegaDadosXML("infProt", ::cXML )

   ::aInfProt := hb_Hash()
   ::aInfProt[ "nProt" ] := hbNFe_PegaDadosXML("nProt", cInfProt )
   ::aInfProt[ "dhRecbto" ] := hbNFe_PegaDadosXML("dhRecbto", cInfProt )
   ::aInfProt[ "digVal" ] := hbNFe_PegaDadosXML("digVal", cInfProt )
   ::aInfProt[ "cStat" ] := hbNFe_PegaDadosXML("cStat", cInfProt )
   ::aInfProt[ "xMotivo" ] := hbNFe_PegaDadosXML("xMotivo", cInfProt )

   RETURN .T.

METHOD geraPDF() CLASS hbNFeDanfe

   LOCAL nItem, nIdes, nItensNF, nItens1Folha

   // criacao objeto pdf
   ::oPdf := HPDF_New()
   IF ::oPdf == NIL
      ::aRetorno[ 'OK' ] := .F.
      ::aRetorno[ 'MsgErro' ] := 'Falha da criação do objeto PDF !'
      RETURN(.F.)
   ENDIF
   /* set compression mode */
   HPDF_SetCompressionMode( ::oPdf, HPDF_COMP_ALL )
   /* setando fonte */
   IF ::cFonteNFe == "Times"
      ::oPdfFontCabecalho := HPDF_GetFont( ::oPdf, "Times-Roman", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Times-Bold", "CP1252" )
   ELSE
      ::oPdfFontCabecalho := HPDF_GetFont( ::oPdf, "Courier", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Courier-Bold", "CP1252" )
   ENDIF

   &&  Alterado por Anderson Camilo em 06/11/2012

   #ifdef __XHARBOUR__
     if !file('fontes\Code128bWinLarge.afm') .or. !file('fontes\Code128bWinLarge.pfb')
        ::aRetorno[ 'OK' ] := .F.
        ::aRetorno[ 'MsgErro' ] := 'Arquivos: fontes\Code128bWinLarge, nao encontrados...!'
        RETURN(.F.)
     endif

      && Inserido por Anderson Camilo em 04/04/2012

   ::cFonteCode128 := HPDF_LoadType1FontFromFile(::oPdf, 'fontes\Code128bWinLarge.afm', 'fontes\Code128bWinLarge.pfb')   && Code 128
   ::cFonteCode128F := HPDF_GetFont( ::oPdf, ::cFonteCode128, "WinAnsiEncoding" )
   #endif
   // final da criacao e definicao do objeto pdf

   ::nFolha := 1

   // calculando quantidade de itens
   nItem := 1
   DO WHILE .T.
      ::ProcessaItens(::cXML,nItem)
      IF ::aItem[ "cProd" ] = Nil
         EXIT
      ENDIF
      nItem ++
      FOR nIdes = 2 TO MLCOUNT(::aItem[ "xProd" ],::nLarguraDescricao)
         nItem ++
      NEXT
   ENDDO
   nItensNF := (nItem-1)
   // calcula itens 1a Folha
   nItens1Folha := ::calculaItens1Folha(::nItens1Folha)
   // calcula itens demais folhas
   nItensNF -= nItens1Folha
   ::nFolhas := 1
   IF nItensNF > 0
      ::nFolhas += INT( nItensNF/::nItensDemaisFolhas )
      IF !INT( nItensNF/::nItensDemaisFolhas ) == nItensNF/::nItensDemaisFolhas
         ::nFolhas ++
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

METHOD calculaItens1Folha(nItensInicial) CLASS hbNFeDanfe

   LOCAL nRetorno

   IF ::lLaser = .T. // LASER
      nItensInicial += 9
   ENDIF
   IF EMPTY(::cCobranca)
      nItensInicial += 2
   ENDIF
   IF VAL(IF(::aISSTotal[ "vServ" ]<>Nil,::aISSTotal[ "vServ" ],"0")) <= 0 // sem servico
      nItensInicial += 4
   ENDIF
   nRetorno := nItensInicial

   RETURN nRetorno

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
      HPDF_Page_BeginText(::oPdfPage)
      HPDF_Page_SetTextMatrix(::oPdfPage, cos(nRadiano), sin(nRadiano), -sin(nRadiano), cos(nRadiano), 15, 160)
      HPDF_Page_SetRGBFill(::oPdfPage, 0.75, 0.75, 0.75)
      HPDF_Page_ShowText(::oPdfPage, "DANFE EM CONTINGÊNCIA. IMPRESSO EM")
      HPDF_Page_EndText(::oPdfPage)

      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText(::oPdfPage)
      HPDF_Page_SetTextMatrix(::oPdfPage, cos(nRadiano), sin(nRadiano), -sin(nRadiano), cos(nRadiano), 15, 130)
      HPDF_Page_SetRGBFill(::oPdfPage, 0.75, 0.75, 0.75)
      HPDF_Page_ShowText(::oPdfPage, "DECORRÊNCIA DE PROBLEMAS TÉCNICOS.")
      HPDF_Page_EndText(::oPdfPage)

      HPDF_Page_SetRGBFill(::oPdfPage, 0, 0, 0) // reseta cor fontes
   ENDIF

   IF ::aIde[ "tpEmis" ] = "4" // DEPEC
      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText(::oPdfPage)
      HPDF_Page_SetTextMatrix(::oPdfPage, cos(nRadiano), sin(nRadiano), -sin(nRadiano), cos(nRadiano), 15, 190)
      HPDF_Page_SetRGBFill(::oPdfPage, 0.75, 0.75, 0.75)
      HPDF_Page_ShowText(::oPdfPage, "DANFE IMPRESSO EM CONTINGÊNCIA - DEPEC")
      HPDF_Page_EndText(::oPdfPage)

      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText(::oPdfPage)
      HPDF_Page_SetTextMatrix(::oPdfPage, cos(nRadiano), sin(nRadiano), -sin(nRadiano), cos(nRadiano), 15, 160)
      HPDF_Page_SetRGBFill(::oPdfPage, 0.75, 0.75, 0.75)
      HPDF_Page_ShowText(::oPdfPage, "REGULARMENTE RECEBIDO PELA RECEITA")
      HPDF_Page_EndText(::oPdfPage)

      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText(::oPdfPage)
      HPDF_Page_SetTextMatrix(::oPdfPage, cos(nRadiano), sin(nRadiano), -sin(nRadiano), cos(nRadiano), 15, 130)
      HPDF_Page_SetRGBFill(::oPdfPage, 0.75, 0.75, 0.75)
      HPDF_Page_ShowText(::oPdfPage, "FEDERAL DO BRASIL.")
      HPDF_Page_EndText(::oPdfPage)

      HPDF_Page_SetRGBFill(::oPdfPage, 0, 0, 0) // reseta cor fontes
   ENDIF

   IF ::aIde[ "tpAmb" ] = "2"
      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText(::oPdfPage)
      HPDF_Page_SetTextMatrix(::oPdfPage, cos(nRadiano), sin(nRadiano), -sin(nRadiano), cos(nRadiano), 15, 100)
      HPDF_Page_SetRGBFill(::oPdfPage, 0.75, 0.75, 0.75)
      HPDF_Page_ShowText(::oPdfPage, "AMBIENTE DE HOMOLOGAÇÃO - SEM VALOR FISCAL")
      HPDF_Page_EndText(::oPdfPage)

      HPDF_Page_SetRGBStroke(::oPdfPage, 0.75, 0.75, 0.75)
      IF ::lPaisagem = .T. // paisagem
         hbNFe_Line_Hpdf( ::oPdfPage, 15, 95, 675, 475, 2.0)
      ELSE
         hbNFe_Line_Hpdf( ::oPdfPage, 15, 95, 550, 630, 2.0)
      ENDIF

      HPDF_Page_SetRGBStroke(::oPdfPage, 0, 0, 0) // reseta cor linhas

      HPDF_Page_SetRGBFill(::oPdfPage, 0, 0, 0) // reseta cor fontes
   ENDIF

   RETURN NIL

METHOD saltaPagina() CLASS hbNFeDanfe

   LOCAL nLinhaFinalProd, nTamanhoProd

   IF ::nLinhaFolha > ::nItensFolha
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
      nLinhaFinalProd := ::nLinhaPdf-(::nItensFolha*6)-2
      nTamanhoProd := (::nItensFolha*6)+2
      ::desenhaBoxProdutos(nLinhaFinalProd,nTamanhoProd)
   ENDIF

   RETURN NIL

METHOD canhoto() CLASS hbNFeDanfe

   IF ::nFolha = 1
      IF ::lPaisagem = .T. // paisagem
         hbNFe_Box_Hpdf( ::oPdfPage,   5, 20, 50, 565, ::nLarguraBox )
         // recebemos
         hbNFe_Texto_Hpdf( ::oPdfPage,  14, 21, 14+8, ::nLinhaPdf, "Recebemos de "+TRIM(::aEmit[ "xNome" ])+" os produtos constantes da Nota Fiscal indicada ao lado", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 7, 90 )
         // quadro numero da NF
         hbNFe_Box_Hpdf( ::oPdfPage,   5, 505, 50, 80, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,  14, 506, 14+8, Nil, "NOTA FISCAL", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8, 90 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  30, 506, 30+8, Nil, "Nº: "+SUBS(STRZERO(VAL(::aIde[ "nNF" ]),9),1,3)+"."+SUBS(STRZERO(VAL(::aIde[ "nNF" ]),9),4,3)+"."+SUBS(STRZERO(VAL(::aIde[ "nNF" ]),9),7,3), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8, 90 )
         hbNFe_Texto_Hpdf( ::oPdfPage,  46, 506, 46+8, Nil, "SÉRIE "+::aIde[ "serie" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8, 90 )

         // data recebimento
         hbNFe_Box_Hpdf( ::oPdfPage,  20, 20, 35, 120, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 26, 21, 26+8, Nil, "DATA DE RECEBIMENTO", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6, 90 )
         // identificacao
         hbNFe_Box_Hpdf( ::oPdfPage,  20, 140, 35, 365, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,  26, 141, 26+8, Nil, "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6, 90 )

         // corte
         IF ::cFonteNFe == "Times"
            hbNFe_Texto_Hpdf( ::oPdfPage, 62, 20, 62+8, Nil, REPLIC("- ",110), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8, 90 )
         ELSE
            hbNFe_Texto_Hpdf( ::oPdfPage, 65, 20, 65+6, Nil, REPLIC("- ",78), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6, 90 )
         ENDIF
      ELSE // retrato
         hbNFe_Box_Hpdf( ::oPdfPage, 5, ::nLinhaPdf-44, 585, 44, ::nLarguraBox )
         // recebemos
         hbNFe_Texto_Hpdf( ::oPdfPage, 6, ::nLinhaPdf, 490, Nil, "Recebemos de "+::aEmit[ "xNome" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 6, ::nLinhaPdf-7, 490, Nil, "os produtos constantes da Nota Fiscal indicada ao lado", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
         // quadro numero da NF
         hbNFe_Box_Hpdf( ::oPdfPage, 505, ::nLinhaPdf-44, 85, 44, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 506, ::nLinhaPdf-8, 589, Nil, "NF-e", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
           hbNFe_Texto_Hpdf( ::oPdfPage, 506, ::nLinhaPdf-20, 589, Nil, "Nº: "+SUBS(STRZERO(VAL(::aIde[ "nNF" ]),9),1,3)+"."+SUBS(STRZERO(VAL(::aIde[ "nNF" ]),9),4,3)+"."+SUBS(STRZERO(VAL(::aIde[ "nNF" ]),9),7,3), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 506, ::nLinhaPdf-32, 589, Nil, "SÉRIE "+::aIde[ "serie" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
         ::nLinhaPdf -= 18

         // data recebimento
         hbNFe_Box_Hpdf( ::oPdfPage,   5, ::nLinhaPdf-26, 130, 26, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 6, ::nLinhaPdf,134, Nil, "DATA DE RECEBIMENTO", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         // identificacao
         hbNFe_Box_Hpdf( ::oPdfPage, 135, ::nLinhaPdf-26, 370, 26, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 136, ::nLinhaPdf, 470, Nil, "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         ::nLinhaPdf -= 24

         // corte
         IF ::cFonteNFe == "Times"
            hbNFe_Texto_Hpdf( ::oPdfPage,  5, ::nLinhaPdf, 590, Nil, REPLIC("- ",125), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
         ELSE
            hbNFe_Texto_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-2, 590, Nil, REPLIC("- ",81), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
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
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf   , 399, Nil, "IDENTIFICAÇÃO DO EMITENTE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-6 , 399, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,1)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-18, 399, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,2)), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-30, 399, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-38, 399, Nil, ::aEmit[ "xBairro" ]+" - "+TRANSF( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-46, 399, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-54, 399, Nil, TRIM(IF(!EMPTY(::cTelefoneEmitente),"FONE: "+::cTelefoneEmitente,"")), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-62, 399, Nil, TRIM(::cSiteEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-70, 399, Nil, TRIM(::cEmailEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
       ELSE
          IF ::nLogoStyle = _LOGO_EXPANDIDO
             oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
             HPDF_Page_DrawImage( ::oPdfPage, oImage, 6, ::nLinhaPdf - (72+6), 328, 72 )
          ELSEIF ::nLogoStyle = _LOGO_ESQUERDA
             oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
             HPDF_Page_DrawImage( ::oPdfPage, oImage,71, ::nLinhaPdf - (72+6), 62, 72 )
              hbNFe_Texto_Hpdf( ::oPdfPage,135, ::nLinhaPdf-6 , 399, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,1)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
              hbNFe_Texto_Hpdf( ::oPdfPage,135, ::nLinhaPdf-18, 399, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,2)), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
              hbNFe_Texto_Hpdf( ::oPdfPage,135, ::nLinhaPdf-30, 399, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
              hbNFe_Texto_Hpdf( ::oPdfPage,135, ::nLinhaPdf-38, 399, Nil, ::aEmit[ "xBairro" ]+" - "+TRANSF( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
              hbNFe_Texto_Hpdf( ::oPdfPage,135, ::nLinhaPdf-46, 399, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
              hbNFe_Texto_Hpdf( ::oPdfPage,135, ::nLinhaPdf-54, 399, Nil, TRIM(IF(!EMPTY(::cTelefoneEmitente),"FONE: "+::cTelefoneEmitente,"")), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
              hbNFe_Texto_Hpdf( ::oPdfPage,135, ::nLinhaPdf-62, 399, Nil, TRIM(::cSiteEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
              hbNFe_Texto_Hpdf( ::oPdfPage,135, ::nLinhaPdf-70, 399, Nil, TRIM(::cEmailEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          ELSEIF ::nLogoStyle = _LOGO_DIREITA
             oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
             HPDF_Page_DrawImage( ::oPdfPage, oImage,337, ::nLinhaPdf - (72+6), 62, 72 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-6 , 335, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,1)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-18, 335, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,2)), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-30, 335, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-38, 335, Nil, ::aEmit[ "xBairro" ]+" - "+TRANSF( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-46, 335, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-54, 335, Nil, TRIM(IF(!EMPTY(::cTelefoneEmitente),"FONE: "+::cTelefoneEmitente,"")), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-62, 335, Nil, TRIM(::cSiteEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-70, 335, Nil, TRIM(::cEmailEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
           ENDIF
      ENDIF

      // numero nf tipo
      hbNFe_Box_Hpdf( ::oPdfPage,400, ::nLinhaPdf-80, 125, 80, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,401, ::nLinhaPdf-4, 524, Nil, "DANFE" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
      hbNFe_Texto_Hpdf( ::oPdfPage,401, ::nLinhaPdf-16, 524, Nil, "Documento Auxiliar da" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
      hbNFe_Texto_Hpdf( ::oPdfPage,401, ::nLinhaPdf-24, 524, Nil, "Nota Fiscal Eletrônica" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )

      hbNFe_Texto_Hpdf( ::oPdfPage,411, ::nLinhaPdf-36, 524, Nil, "0 - ENTRADA" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
      hbNFe_Texto_Hpdf( ::oPdfPage,411, ::nLinhaPdf-44, 524, Nil, "1 - SAÍDA" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
      // preenchimento do tipo de nf
      hbNFe_Box_Hpdf( ::oPdfPage,495, ::nLinhaPdf-52, 20, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,496, ::nLinhaPdf-40, 514, Nil, ::aIde[ "tpNF" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )

      hbNFe_Texto_Hpdf( ::oPdfPage,401, ::nLinhaPdf-56, 524, Nil, "Nº: "+SUBS(STRZERO(VAL(::aIde[ "nNF" ]),9),1,3)+"."+SUBS(STRZERO(VAL(::aIde[ "nNF" ]),9),4,3)+"."+SUBS(STRZERO(VAL(::aIde[ "nNF" ]),9),7,3) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
      hbNFe_Texto_Hpdf( ::oPdfPage,401, ::nLinhaPdf-66, 524, Nil, "SÉRIE: "+::aIde[ "serie" ]+" - FOLHA "+ALLTRIM(STR(::nFolha))+"/"+ALLTRIM(STR(::nFolhas)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

      // codigo barras
      hbNFe_Box_Hpdf( ::oPdfPage,525, ::nLinhaPdf-35, 305, 35, ::nLarguraBox )
      #ifdef __XHARBOUR__
*         oCode128 = HPDF_LoadType1FontFromFile(::oPdf, 'fontes\Code128bWin.afm', 'fontes\Code128bWin.pfb')
*         oCode128F := HPDF_GetFont( ::oPdf, oCode128, "FontSpecific" )
*         hbNFe_Texto_Hpdf( ::oPdfPage,540, ::nLinhaPdf-4.5, 815, Nil, "{"+::cChave+"~" , HPDF_TALIGN_CENTER, Nil, oCode128F, 11 )
*         hbNFe_Texto_Hpdf( ::oPdfPage,540, ::nLinhaPdf-19, 815, Nil, "{"+::cChave+"~" , HPDF_TALIGN_CENTER, Nil, oCode128F,11 )

                       && Modificado por Anderson Camilo em 04/04/2012
          hbNFe_Texto_Hpdf( ::oPdfPage,540, ::nLinhaPdf-1.5, 815, Nil, CodificaCode128c(::cChave), HPDF_TALIGN_CENTER, Nil, ::cFonteCode128F, 15 )


      #else
          hZebra := hb_zebra_create_code128( ::cChave, Nil )
          hbNFe_Zebrea_Draw_Hpdf( hZebra, ::oPdfPage, 540, ::nLinhaPdf-32, 1.0, 30 )
      #endif
      // chave de acesso
      hbNFe_Box_Hpdf( ::oPdfPage,525, ::nLinhaPdf-55, 305, 55, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,526, ::nLinhaPdf-36   , 829, Nil, "CHAVE DE ACESSO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
      IF ::cFonteNFe == "Times"
         hbNFe_Texto_Hpdf( ::oPdfPage,526, ::nLinhaPdf-44   , 829, Nil, TRANSF(::cChave, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 9 )
      ELSE
         hbNFe_Texto_Hpdf( ::oPdfPage,526, ::nLinhaPdf-44   , 829, Nil, TRANSF(::cChave, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
      ENDIF
      // mensagem sistema sefaz
      hbNFe_Box_Hpdf( ::oPdfPage,525, ::nLinhaPdf-80, 305, 80, ::nLarguraBox )
      IF ::aInfProt[ "nProt" ] = NIL .OR. EMPTY( ::aInfProt[ "nProt" ] )
         hbNFe_Texto_Hpdf( ::oPdfPage,526, ::nLinhaPdf-55   , 829, Nil, "N F E   A I N D A   N Ã O   F O I" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage,526, ::nLinhaPdf-63   , 829, Nil, "A U T O R I Z A D A   P E L A" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage,526, ::nLinhaPdf-71   , 829, Nil, "S E F A Z   (SEM VALIDADE FISCAL)" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
      ELSE
         hbNFe_Texto_Hpdf( ::oPdfPage,526, ::nLinhaPdf-55   , 829, Nil, "Consulta de autenticidade no portal nacional" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage,526, ::nLinhaPdf-63   , 829, Nil, "da NF-e www.nfe.fazenda.gov.br/portal ou" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage,526, ::nLinhaPdf-71   , 829, Nil, "no site da Sefaz Autorizadora" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
      ENDIF

      ::nLinhaPdf -= 80

      // NATUREZA
      hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-16, 455, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-1  , 524, Nil, "NATUREZA DA OPERAÇÃO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-5  , 524, Nil, ::aIde[ "natOp" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
      // PROTOCOLO
      hbNFe_Box_Hpdf( ::oPdfPage,525, ::nLinhaPdf-16, 305, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,526, ::nLinhaPdf-1   , 829, Nil, "PROTOCOLO DE AUTORIZAÇÃO DE USO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      IF ::aInfProt[ "nProt" ] <> Nil
   	     IF ::aInfProt[ "cStat" ] = '100'
            hbNFe_Texto_Hpdf( ::oPdfPage,526, ::nLinhaPdf-1   , 829, Nil, "PROTOCOLO DE AUTORIZAÇÃO DE USO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         ELSEIF ::aInfProt[ "cStat" ] = '101' .OR. ::aInfProt[ "cStat" ] = '135'
            hbNFe_Texto_Hpdf( ::oPdfPage,526, ::nLinhaPdf-1   , 829, Nil, "PROTOCOLO DE HOMOLOGAÇÃO DO CANCELAMENTO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
   	     ENDIF

         IF ::cFonteNFe == "Times"
            hbNFe_Texto_Hpdf( ::oPdfPage,526, ::nLinhaPdf-6   , 829, Nil, ::aInfProt[ "nProt" ]+" "+SUBS(SUBS(::aInfProt[ "dhRecbto" ],1,10),9,2)+"/"+SUBS(SUBS(::aInfProt[ "dhRecbto" ],1,10),6,2)+"/"+SUBS(SUBS(::aInfProt[ "dhRecbto" ],1,10),1,4)+" "+SUBS(::aInfProt[ "dhRecbto" ],12,8) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 9 )
         ELSE
            hbNFe_Texto_Hpdf( ::oPdfPage,526, ::nLinhaPdf-6   , 829, Nil, ::aInfProt[ "nProt" ]+" "+SUBS(SUBS(::aInfProt[ "dhRecbto" ],1,10),9,2)+"/"+SUBS(SUBS(::aInfProt[ "dhRecbto" ],1,10),6,2)+"/"+SUBS(SUBS(::aInfProt[ "dhRecbto" ],1,10),1,4)+" "+SUBS(::aInfProt[ "dhRecbto" ],12,8) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 9 )
         ENDIF
      ENDIF

      ::nLinhaPdf -= 16

      // I.E.
      hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-16, 240, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-1  , 309, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-5  , 309, Nil, ::aEmit[ "IE" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
      // I.E. SUBS. TRIB.
      hbNFe_Box_Hpdf( ::oPdfPage,310, ::nLinhaPdf-16, 400, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,311, ::nLinhaPdf-1  , 709, Nil, "INSCRIÇÃO ESTADUAL DO SUBS. TRIBUTÁRIO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,311, ::nLinhaPdf-5  , 709, Nil, "" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
      // CNPJ
      hbNFe_Box_Hpdf( ::oPdfPage,710, ::nLinhaPdf-16, 120, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,711, ::nLinhaPdf-1  , 829, Nil, "C.N.P.J." , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,711, ::nLinhaPdf-5  , 829, Nil, TRANSF(::aEmit[ "CNPJ" ], "@R 99.999.999/9999-99"), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 17
   ELSE
      hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-80, 585, 80, ::nLarguraBox )
      // logo/dados empresa
      hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-80, 240, 80, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf   , 244, Nil, "IDENTIFICAÇÃO DO EMITENTE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
      IF EMPTY( ::cLogoFile )
          hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-6 , 244, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,1)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-18, 244, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,2)), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-30, 244, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-38, 244, Nil, ::aEmit[ "xBairro" ]+" - "+TRANSF( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-46, 244, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-54, 244, Nil, TRIM(IF(!EMPTY(::cTelefoneEmitente),"FONE: "+::cTelefoneEmitente,"")), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-62, 244, Nil, TRIM(::cSiteEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-70, 244, Nil, TRIM(::cEmailEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
      ELSE
          IF ::nLogoStyle = _LOGO_EXPANDIDO
             oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
             HPDF_Page_DrawImage( ::oPdfPage, oImage, 6, ::nLinhaPdf - (72+6), 238, 72 )
          ELSEIF ::nLogoStyle = _LOGO_ESQUERDA
             oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
             HPDF_Page_DrawImage( ::oPdfPage, oImage, 6, ::nLinhaPdf - (72+6), 62, 72 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-6 , 244, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,1)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
             && Anderson camilo   30/12/2011  Comentei esta linha porque a razão social estava saindo um nome sobre o outro
*            hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-18, 244, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,2)), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-30, 244, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-38, 244, Nil, ::aEmit[ "xBairro" ]+" - "+TRANSF( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-46, 244, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-54, 244, Nil, TRIM(IF(!EMPTY(::cTelefoneEmitente),"FONE: "+::cTelefoneEmitente,"")), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-62, 244, Nil, TRIM(::cSiteEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-70, 244, Nil, TRIM(::cEmailEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          ELSEIF ::nLogoStyle = _LOGO_DIREITA
             oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
             HPDF_Page_DrawImage( ::oPdfPage, oImage,182, ::nLinhaPdf - (72+6), 62, 72 )
            hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-6 , 180, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,1)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
            hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-18, 180, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,2)), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
            hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-30, 180, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-38, 180, Nil, ::aEmit[ "xBairro" ]+" - "+TRANSF( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-46, 180, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-54, 180, Nil, TRIM(IF(!EMPTY(::cTelefoneEmitente),"FONE: "+::cTelefoneEmitente,"")), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-62, 180, Nil, TRIM(::cSiteEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-70, 180, Nil, TRIM(::cEmailEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
           ENDIF
      ENDIF
      // numero nf tipo
      hbNFe_Box_Hpdf( ::oPdfPage,245, ::nLinhaPdf-80, 125, 80, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,246, ::nLinhaPdf-4, 369, Nil, "DANFE" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
      hbNFe_Texto_Hpdf( ::oPdfPage,246, ::nLinhaPdf-16, 369, Nil, "Documento Auxiliar da" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
      hbNFe_Texto_Hpdf( ::oPdfPage,246, ::nLinhaPdf-24, 369, Nil, "Nota Fiscal Eletrônica" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )

      hbNFe_Texto_Hpdf( ::oPdfPage,256, ::nLinhaPdf-36, 349, Nil, "0 - ENTRADA" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
      hbNFe_Texto_Hpdf( ::oPdfPage,256, ::nLinhaPdf-44, 349, Nil, "1 - SAÍDA" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
      // preenchimento do tipo de nf
      hbNFe_Box_Hpdf( ::oPdfPage,340, ::nLinhaPdf-52, 20, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,341, ::nLinhaPdf-40, 359, Nil, ::aIde[ "tpNF" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )

      hbNFe_Texto_Hpdf( ::oPdfPage,246, ::nLinhaPdf-56, 369, Nil, "Nº: "+SUBS(STRZERO(VAL(::aIde[ "nNF" ]),9),1,3)+"."+SUBS(STRZERO(VAL(::aIde[ "nNF" ]),9),4,3)+"."+SUBS(STRZERO(VAL(::aIde[ "nNF" ]),9),7,3) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
      hbNFe_Texto_Hpdf( ::oPdfPage,246, ::nLinhaPdf-66, 369, Nil, "SÉRIE: "+::aIde[ "serie" ]+" - FOLHA "+ALLTRIM(STR(::nFolha))+"/"+ALLTRIM(STR(::nFolhas)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 9 )

      // codigo barras
      hbNFe_Box_Hpdf( ::oPdfPage,370, ::nLinhaPdf-35, 220, 35, ::nLarguraBox )
      #ifdef __XHARBOUR__
            && Modificado por Anderson Camilo em 04/04/2012
*         oCode128 = HPDF_LoadType1FontFromFile(::oPdf, 'fontes\Code128bWin.afm', 'fontes\Code128bWin.pfb')
*         oCode128F := HPDF_GetFont( ::oPdf, oCode128, "FontSpecific" )
*          hbNFe_Texto_Hpdf( ::oPdfPage,380, ::nLinhaPdf-8, 585, Nil, "{"+::cChave+"~" , HPDF_TALIGN_CENTER, Nil, oCode128F, 8 )
*          hbNFe_Texto_Hpdf( ::oPdfPage,380, ::nLinhaPdf-18.2, 585, Nil, "{"+::cChave+"~" , HPDF_TALIGN_CENTER, Nil, oCode128F, 8 )

           hbNFe_Texto_Hpdf( ::oPdfPage,380, ::nLinhaPdf-2, 585, Nil, CodificaCode128c(::cChave), HPDF_TALIGN_CENTER, Nil, ::cFonteCode128F, 15 )

      #else
         hZebra := hb_zebra_create_code128( ::cChave, Nil )
         hbNFe_Zebrea_Draw_Hpdf( hZebra, ::oPdfPage, 385, ::nLinhaPdf-32, 0.7, 30 )
      #endif


      // chave de acesso
      hbNFe_Box_Hpdf( ::oPdfPage,370, ::nLinhaPdf-55, 220, 55, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-36   , 589, Nil, "CHAVE DE ACESSO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
      IF ::cFonteNFe == "Times"
         hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-44   , 589, Nil, TRANSF(::cChave, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
      ELSE
         hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-44   , 589, Nil, TRANSF(::cChave, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      ENDIF
      // mensagem sistema sefaz
      hbNFe_Box_Hpdf( ::oPdfPage,370, ::nLinhaPdf-80, 220, 80, ::nLarguraBox )
      IF ::aInfProt[ "nProt" ] = NIL .OR. EMPTY( ::aInfProt[ "nProt" ] )
         hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-55   , 589, Nil, "N F E   A I N D A   N Ã O   F O I" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-63   , 589, Nil, "A U T O R I Z A D A   P E L A" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-71   , 589, Nil, "S E F A Z   (SEM VALIDADE FISCAL)" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
      ELSE
         hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-55   , 589, Nil, "Consulta de autenticidade no portal nacional" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-63   , 589, Nil, "da NF-e www.nfe.fazenda.gov.br/portal ou" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
         hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-71   , 589, Nil, "no site da Sefaz Autorizadora" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
      ENDIF

      ::nLinhaPdf -= 80

      // NATUREZA
      hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-16, 365, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-1  , 369, Nil, "NATUREZA DA OPERAÇÃO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5  , 369, Nil, ::aIde[ "natOp" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
      // PROTOCOLO
      hbNFe_Box_Hpdf( ::oPdfPage,370, ::nLinhaPdf-16, 220, 16, ::nLarguraBox )

	  // Alterado por Anderson Camilo em 06/08/2013
*      hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-1   , 589, Nil, "PROTOCOLO DE AUTORIZAÇÃO DE USO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      IF ::aInfProt[ "nProt" ] <> Nil

         IF ::aInfProt[ "cStat" ] = '100'
            hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-1   , 589, Nil, "PROTOCOLO DE AUTORIZAÇÃO DE USO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         ELSEIF ::aInfProt[ "cStat" ] = '101' .OR. ::aInfProt[ "cStat" ] = '135'
            hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-1   , 589, Nil, "PROTOCOLO DE HOMOLOGAÇÃO DO CANCELAMENTO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         ENDIF

         IF ::cFonteNFe == "Times"
            hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-6   , 589, Nil, ::aInfProt[ "nProt" ]+" "+SUBS(SUBS(::aInfProt[ "dhRecbto" ],1,10),9,2)+"/"+SUBS(SUBS(::aInfProt[ "dhRecbto" ],1,10),6,2)+"/"+SUBS(SUBS(::aInfProt[ "dhRecbto" ],1,10),1,4)+" "+SUBS(::aInfProt[ "dhRecbto" ],12,8) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 9 )
         ELSE
            hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-6   , 589, Nil, ::aInfProt[ "nProt" ]+" "+SUBS(SUBS(::aInfProt[ "dhRecbto" ],1,10),9,2)+"/"+SUBS(SUBS(::aInfProt[ "dhRecbto" ],1,10),6,2)+"/"+SUBS(SUBS(::aInfProt[ "dhRecbto" ],1,10),1,4)+" "+SUBS(::aInfProt[ "dhRecbto" ],12,8) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 9 )
         ENDIF
      ENDIF

      ::nLinhaPdf -= 16

      // I.E.
      hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-16, 240, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-1  , 244, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5  , 244, Nil, ::aEmit[ "IE" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
      // I.E. SUBS. TRIB.
      hbNFe_Box_Hpdf( ::oPdfPage,245, ::nLinhaPdf-16, 225, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,246, ::nLinhaPdf-1  , 419, Nil, "INSCRIÇÃO ESTADUAL DO SUBS. TRIBUTÁRIO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,246, ::nLinhaPdf-5  , 419, Nil, "" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
      // CNPJ
      hbNFe_Box_Hpdf( ::oPdfPage,470, ::nLinhaPdf-16, 120, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,471, ::nLinhaPdf-1  , 589, Nil, "C.N.P.J." , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,471, ::nLinhaPdf-5  , 589, Nil, TRANSF(::aEmit[ "CNPJ" ], "@R 99.999.999/9999-99"), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 17
   ENDIF

   RETURN NIL

METHOD destinatario() CLASS hbNFeDanfe

   IF ::lPaisagem = .T. // paisagem
      hbNFe_Texto_Hpdf( ::oPdfPage, 70, ::nLinhaPdf  , 830, Nil, "DESTINATÁRIO/REMETENTE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 5 )

      ::nLinhaPdf -= 6

      // RAZAO SOCIAL
      hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-16, 590, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-1  , 659, Nil, "NOME / RAZÃO SOCIAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-5  , 659, Nil, ::aDest[ "xNome" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
      // CNPJ/CPF
      hbNFe_Box_Hpdf( ::oPdfPage,660, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,661, ::nLinhaPdf-1  , 759, Nil, "CNPJ/CPF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      IF !EMPTY(::aDest[ "CNPJ" ])
         hbNFe_Texto_Hpdf( ::oPdfPage,661, ::nLinhaPdf-5  , 759, Nil, TRANSF(::aDest[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 9 )
      ELSE
         IF ::aDest[ "CPF" ] <> Nil
         hbNFe_Texto_Hpdf( ::oPdfPage,661, ::nLinhaPdf-5  , 759, Nil, TRANSF(::aDest[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         ENDIF
      ENDIF
      // DATA DE EMISSAO
      hbNFe_Box_Hpdf( ::oPdfPage,760, ::nLinhaPdf-16, 70, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,761, ::nLinhaPdf-1  , 829, Nil, "DATA DE EMISSÃO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,761, ::nLinhaPdf-5  , 829, Nil, SUBS(::aIde[ "dEmi" ],9,2)+"/"+SUBS(::aIde[ "dEmi" ],6,2)+"/"+SUBS(::aIde[ "dEmi" ],1,4) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 16

      // ENDEREÇO
      hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-16, 440, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-1  , 509, Nil, "ENDEREÇO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-5  , 509, Nil, ::aDest[ "xLgr" ]+" "+::aDest[ "nro" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
      // BAIRRO
      hbNFe_Box_Hpdf( ::oPdfPage,510, ::nLinhaPdf-16, 190, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-1  , 699, Nil, "BAIRRO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-5  , 699, Nil, ::aDest[ "xBairro" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
      // CEP
      hbNFe_Box_Hpdf( ::oPdfPage,700, ::nLinhaPdf-16, 60, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,701, ::nLinhaPdf-1  , 759, Nil, "C.E.P." , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )

      TRY                 && Modificado por Anderson  Camilo 15/02/2012
         hbNFe_Texto_Hpdf( ::oPdfPage,704, ::nLinhaPdf-5  , 759, Nil, TRANSF(::aDest[ "CEP" ], "@R 99999-999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
      CATCH
      end
      // DATA DE SAIDA/ENTRADA
      hbNFe_Box_Hpdf( ::oPdfPage,760, ::nLinhaPdf-16, 70, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,761, ::nLinhaPdf-1  , 829, Nil, "DATA SAIDA/ENTRADA" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      TRY
         hbNFe_Texto_Hpdf( ::oPdfPage,761, ::nLinhaPdf-5  , 829, Nil, SUBS(::aIde[ "dSaiEnt" ],9,2)+"/"+SUBS(::aIde[ "dSaiEnt" ],6,2)+"/"+SUBS(::aIde[ "dSaiEnt" ],1,4) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
      CATCH
      END

      ::nLinhaPdf -= 16

      // MUNICIPIO
      hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-16, 410, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-1  , 479, Nil, "MUNICIPIO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-5  , 479, Nil, ::aDest[ "xMun" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
      // FONE/FAX
      hbNFe_Box_Hpdf( ::oPdfPage,480, ::nLinhaPdf-16, 150, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,481, ::nLinhaPdf-1  , 629, Nil, "FONE/FAX" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      IF LEN(::aDest[ "fone" ])=10
         hbNFe_Texto_Hpdf( ::oPdfPage,481, ::nLinhaPdf-5  , 629, Nil, TRANSF(::aDest[ "fone" ], "@R (99) 99999-9999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
      ELSEIF LEN(::aDest[ "fone" ])>10
         hbNFe_Texto_Hpdf( ::oPdfPage,481, ::nLinhaPdf-5  , 629, Nil, TRANSF(::aDest[ "fone" ], "@R +99 (99) 99999-9999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
      ENDIF
      // ESTADO
      hbNFe_Box_Hpdf( ::oPdfPage,630, ::nLinhaPdf-16, 30, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,631, ::nLinhaPdf-1  , 659, Nil, "ESTADO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,631, ::nLinhaPdf-5  , 659, Nil, ::aDest[ "UF" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
      // INSC. EST.
      hbNFe_Box_Hpdf( ::oPdfPage,660, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,661, ::nLinhaPdf-1  , 759, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,661, ::nLinhaPdf-5  , 759, Nil, ::aDest[ "IE" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
      // DATA DE SAIDA/ENTRADA
      hbNFe_Box_Hpdf( ::oPdfPage,760, ::nLinhaPdf-16, 70, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,761, ::nLinhaPdf-1  , 829, Nil, "HORA DE SAIDA" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,761, ::nLinhaPdf-5  , 829, Nil, TIME() , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 17
   ELSE
      hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf  , 589, Nil, "DESTINATÁRIO/REMETENTE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 5 )

      ::nLinhaPdf -= 6

      // RAZAO SOCIAL
      hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-16, 415, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-1  , 419, Nil, "NOME / RAZÃO SOCIAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5  , 419, Nil, ::aDest[ "xNome" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
      // CNPJ/CPF
      hbNFe_Box_Hpdf( ::oPdfPage,420, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,421, ::nLinhaPdf-1  , 519, Nil, "CNPJ/CPF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      IF !EMPTY(::aDest[ "CNPJ" ])
         hbNFe_Texto_Hpdf( ::oPdfPage,421, ::nLinhaPdf-5  , 519, Nil, TRANSF(::aDest[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 9 )
      ELSE
         IF ::aDest[ "CPF" ] <> Nil
            hbNFe_Texto_Hpdf( ::oPdfPage,421, ::nLinhaPdf-5  , 519, Nil, TRANSF(::aDest[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         ENDIF
      ENDIF
      // DATA DE EMISSAO
      hbNFe_Box_Hpdf( ::oPdfPage,520, ::nLinhaPdf-16, 70, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,521, ::nLinhaPdf-1  , 589, Nil, "DATA DE EMISSÃO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,521, ::nLinhaPdf-5  , 589, Nil, SUBS(::aIde[ "dhEmi" ],9,2)+"/"+SUBS(::aIde[ "dhEmi" ],6,2)+"/"+SUBS(::aIde[ "dhEmi" ],1,4) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 16

      // ENDEREÇO
      hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-16, 265, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-1  , 269, Nil, "ENDEREÇO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5  , 269, Nil, ::aDest[ "xLgr" ]+" "+::aDest[ "nro" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
      // BAIRRO
      hbNFe_Box_Hpdf( ::oPdfPage,270, ::nLinhaPdf-16, 190, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-1  , 459, Nil, "BAIRRO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-5  , 459, Nil, ::aDest[ "xBairro" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
      // CEP
      hbNFe_Box_Hpdf( ::oPdfPage,460, ::nLinhaPdf-16, 60, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,461, ::nLinhaPdf-1  , 519, Nil, "C.E.P." , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      TRY
         hbNFe_Texto_Hpdf( ::oPdfPage,461, ::nLinhaPdf-5  , 519, Nil, TRANSF(::aDest[ "CEP" ], "@R 99999-999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
      CATCH
      END
      // DATA DE SAIDA/ENTRADA
      hbNFe_Box_Hpdf( ::oPdfPage,520, ::nLinhaPdf-16, 70, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,521, ::nLinhaPdf-1  , 589, Nil, "DATA SAIDA/ENTRADA" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      TRY
         hbNFe_Texto_Hpdf( ::oPdfPage,521, ::nLinhaPdf-5  , 589, Nil, SUBS(::aIde[ "dhSaiEnt" ],9,2)+"/"+SUBS(::aIde[ "dhSaiEnt" ],6,2)+"/"+SUBS(::aIde[ "dhSaiEnt" ],1,4) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
      CATCH
      END

      ::nLinhaPdf -= 16

      // MUNICIPIO
      hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-16, 245, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-1  , 249, Nil, "MUNICIPIO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5  , 249, Nil, ::aDest[ "xMun" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
      // FONE/FAX
      hbNFe_Box_Hpdf( ::oPdfPage,250, ::nLinhaPdf-16, 150, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,251, ::nLinhaPdf-1  , 399, Nil, "FONE/FAX" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      IF LEN(::aDest[ "fone" ])=10
         hbNFe_Texto_Hpdf( ::oPdfPage,251, ::nLinhaPdf-5  , 399, Nil, TRANSF(::aDest[ "fone" ], "@R (99) 99999-9999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
      ELSEIF LEN(::aDest[ "fone" ])>10
         hbNFe_Texto_Hpdf( ::oPdfPage,251, ::nLinhaPdf-5  , 399, Nil, TRANSF(::aDest[ "fone" ], "@R +99 (99) 99999-9999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
      ENDIF
      // ESTADO
      hbNFe_Box_Hpdf( ::oPdfPage,400, ::nLinhaPdf-16, 30, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,401, ::nLinhaPdf-1  , 429, Nil, "ESTADO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,401, ::nLinhaPdf-5  , 429, Nil, ::aDest[ "UF" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
      // INSC. EST.
      hbNFe_Box_Hpdf( ::oPdfPage,430, ::nLinhaPdf-16, 90, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,431, ::nLinhaPdf-1  , 519, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,431, ::nLinhaPdf-5  , 519, Nil, ::aDest[ "IE" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
      // DATA DE SAIDA/ENTRADA
      hbNFe_Box_Hpdf( ::oPdfPage,520, ::nLinhaPdf-16, 70, 16, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,521, ::nLinhaPdf-1  , 589, Nil, "HORA DE SAIDA" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
      hbNFe_Texto_Hpdf( ::oPdfPage,521, ::nLinhaPdf-5  , 589, Nil, SUBS(::aIde[ "dhSaiEnt" ],12,8) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 17
   ENDIF

   RETURN NIL

METHOD duplicatas() CLASS hbNFeDanfe

   LOCAL nICob, nItensCob, nLinhaFinalCob, nTamanhoCob

   IF ::nFolha = 1
      IF ::lPaisagem = .T. // paisagem
         hbNFe_Texto_Hpdf( ::oPdfPage,70, ::nLinhaPdf  , 760, Nil, "FATURA/DUPLICATAS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 5 )
         ::nLinhaPdf -= 6

         IF EMPTY(::cCobranca)
             // FATURAS
             hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-12, 760, 12, ::nLarguraBox )
             IF ::aIde[ "indPag" ] == "0"
                hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-1  , 824, Nil, "PAGAMENTO À VISTA" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
             ELSEIF ::aIde[ "indPag" ] == "1"    && Alterado por Anderson Camilo em 31/07/2012
                hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-1  , 824, Nil, "PAGAMENTO À PRAZO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
             ELSE
                hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-1  , 824, Nil, "OUTROS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
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
         hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf  , 589, Nil, "FATURA/DUPLICATAS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 5 )
         ::nLinhaPdf -= 6

         IF EMPTY(::cCobranca)
             // FATURAS
             hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-12, 585, 12, ::nLarguraBox )
             IF ::aIde[ "indPag" ] == "0"
                hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-1  , 589, Nil, "PAGAMENTO À VISTA" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
             ELSEIF ::aIde[ "indPag" ] == "1"    && Alterado por Anderson Camilo em 31/07/2012
                hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-1  , 589, Nil, "PAGAMENTO À PRAZO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
             ELSE
                hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-1  , 589, Nil, "OUTROS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
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
         hbNFe_Box_Hpdf(  ::oPdfPage, 70, nLinhaFinalCob, ((nTamForm)/4), nTamanhoCob, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-1  , 126, Nil, "NÚMERO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,128, ::nLinhaPdf-1  , 183, Nil, "VENCIMENTO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,185, ::nLinhaPdf-1  , 259, Nil, "VALOR" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         // COLUNA 2
         hbNFe_Box_Hpdf( ::oPdfPage, 70+((nTamForm)/4), nLinhaFinalCob, ((nTamForm)/4), nTamanhoCob, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 71+((nTamForm)/4), ::nLinhaPdf-1  ,126+((nTamForm)/4), Nil, "NÚMERO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,128+((nTamForm)/4), ::nLinhaPdf-1  ,183+((nTamForm)/4), Nil, "VENCIMENTO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,185+((nTamForm)/4), ::nLinhaPdf-1  ,259+((nTamForm)/4), Nil, "VALOR" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         // COLUNA 3
         hbNFe_Box_Hpdf( ::oPdfPage, 70+(((nTamForm)/4)*2), nLinhaFinalCob, ((nTamForm)/4), nTamanhoCob, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 71+(((nTamForm)/4)*2), ::nLinhaPdf-1  ,126+(((nTamForm)/4)*2), Nil, "NÚMERO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,128+(((nTamForm)/4)*2), ::nLinhaPdf-1  ,183+(((nTamForm)/4)*2), Nil, "VENCIMENTO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,185+(((nTamForm)/4)*2), ::nLinhaPdf-1  ,259+(((nTamForm)/4)*2), Nil, "VALOR" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         // COLUNA 4
         hbNFe_Box_Hpdf( ::oPdfPage, 70+(((nTamForm)/4)*3), nLinhaFinalCob, ((nTamForm)/4), nTamanhoCob, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage, 71+(((nTamForm)/4)*3), ::nLinhaPdf-1  ,126+(((nTamForm)/4)*3), Nil, "NÚMERO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,128+(((nTamForm)/4)*3), ::nLinhaPdf-1  ,183+(((nTamForm)/4)*3), Nil, "VENCIMENTO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,185+(((nTamForm)/4)*3), ::nLinhaPdf-1  ,259+(((nTamForm)/4)*3), Nil, "VALOR" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         ::nLinhaPdf -= 6

         // COLUNA 1
         hbNFe_Line_Hpdf(  ::oPdfPage, 71, ::nLinhaPdf-1.5, 126, ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,128, ::nLinhaPdf-1.5, 183, ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,185, ::nLinhaPdf-1.5, 259, ::nLinhaPdf-1.5, ::nLarguraBox)
         // COLUNA 2
         hbNFe_Line_Hpdf(  ::oPdfPage, 71+((nTamForm)/4), ::nLinhaPdf-1.5, 126+((nTamForm)/4), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,128+((nTamForm)/4), ::nLinhaPdf-1.5, 183+((nTamForm)/4), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,185+((nTamForm)/4), ::nLinhaPdf-1.5, 259+((nTamForm)/4), ::nLinhaPdf-1.5, ::nLarguraBox)
         // COLUNA 3
         hbNFe_Line_Hpdf(  ::oPdfPage, 71+(((nTamForm)/4)*2), ::nLinhaPdf-1.5, 126+(((nTamForm)/4)*2), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,128+(((nTamForm)/4)*2), ::nLinhaPdf-1.5, 183+(((nTamForm)/4)*2), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,185+(((nTamForm)/4)*2), ::nLinhaPdf-1.5, 259+(((nTamForm)/4)*2), ::nLinhaPdf-1.5, ::nLarguraBox)
         // COLUNA 4
         hbNFe_Line_Hpdf(  ::oPdfPage, 71+(((nTamForm)/4)*3), ::nLinhaPdf-1.5, 126+(((nTamForm)/4)*3), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,128+(((nTamForm)/4)*3), ::nLinhaPdf-1.5, 183+(((nTamForm)/4)*3), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,185+(((nTamForm)/4)*3), ::nLinhaPdf-1.5, 259+(((nTamForm)/4)*3), ::nLinhaPdf-1.5, ::nLarguraBox)

         ::nLinhaPdf -= 2 //ESPAÇO
      ELSE
         nTamForm := 585

         // COLUNA 1
         hbNFe_Box_Hpdf(  ::oPdfPage, 5, nLinhaFinalCob, ((nTamForm)/3), nTamanhoCob, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-1  ,  61, Nil, "NÚMERO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 63, ::nLinhaPdf-1  , 118, Nil, "VENCIMENTO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,120, ::nLinhaPdf-1  , 195, Nil, "VALOR" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         // COLUNA 2
         hbNFe_Box_Hpdf( ::oPdfPage, 5+((nTamForm)/3), nLinhaFinalCob, ((nTamForm)/3), nTamanhoCob, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,  6+((nTamForm)/3), ::nLinhaPdf-1  , 61+((nTamForm)/3), Nil, "NÚMERO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 63+((nTamForm)/3), ::nLinhaPdf-1  ,118+((nTamForm)/3), Nil, "VENCIMENTO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,120+((nTamForm)/3), ::nLinhaPdf-1  ,195+((nTamForm)/3), Nil, "VALOR" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         // COLUNA 3
         hbNFe_Box_Hpdf( ::oPdfPage, 5+(((nTamForm)/3)*2), nLinhaFinalCob, ((nTamForm)/3), nTamanhoCob, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,  6+(((nTamForm)/3)*2), ::nLinhaPdf-1  , 61+(((nTamForm)/3)*2), Nil, "NÚMERO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage, 63+(((nTamForm)/3)*2), ::nLinhaPdf-1  ,118+(((nTamForm)/3)*2), Nil, "VENCIMENTO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,120+(((nTamForm)/3)*2), ::nLinhaPdf-1  ,195+(((nTamForm)/3)*2), Nil, "VALOR" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         ::nLinhaPdf -= 6

         // COLUNA 1
         hbNFe_Line_Hpdf(  ::oPdfPage,  6, ::nLinhaPdf-1.5,  61, ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage, 63, ::nLinhaPdf-1.5, 118, ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,120, ::nLinhaPdf-1.5, 195, ::nLinhaPdf-1.5, ::nLarguraBox)
         // COLUNA 2
         hbNFe_Line_Hpdf(  ::oPdfPage,  6+((nTamForm)/3), ::nLinhaPdf-1.5,  61+((nTamForm)/3), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage, 63+((nTamForm)/3), ::nLinhaPdf-1.5, 118+((nTamForm)/3), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,120+((nTamForm)/3), ::nLinhaPdf-1.5, 195+((nTamForm)/3), ::nLinhaPdf-1.5, ::nLarguraBox)
         // COLUNA 3
         hbNFe_Line_Hpdf(  ::oPdfPage,  6+(((nTamForm)/3)*2), ::nLinhaPdf-1.5,  61+(((nTamForm)/3)*2), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage, 63+(((nTamForm)/3)*2), ::nLinhaPdf-1.5, 118+(((nTamForm)/3)*2), ::nLinhaPdf-1.5, ::nLarguraBox)
         hbNFe_Line_Hpdf(  ::oPdfPage,120+(((nTamForm)/3)*2), ::nLinhaPdf-1.5, 195+(((nTamForm)/3)*2), ::nLinhaPdf-1.5, ::nLarguraBox)

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
            cDup := hbNFe_PegaDadosXML("dup", cDups )

            cNumero := hbNFe_PegaDadosXML("nDup", cDup )
            IF !EMPTY(cNumero)
               cVencimento := hbNFe_PegaDadosXML("dVenc", cDup )
               cVencimento := SUBS(cVencimento,9,2)+"/"+SUBS(cVencimento,6,2)+"/"+SUBS(cVencimento,1,4)
               cValor := ALLTRIM(FormatNumber(VAL(hbNFe_PegaDadosXML("vDup", cDup )),13,2))
            ELSE
               nColuna --
               EXIT
            ENDIF
            IF nColuna = 1
               hbNFe_Texto_Hpdf( ::oPdfPage, 71, ::nLinhaPdf-1  , 126, Nil, cNumero , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
               hbNFe_Texto_Hpdf( ::oPdfPage,128, ::nLinhaPdf-1  , 183, Nil, cVencimento , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
               hbNFe_Texto_Hpdf( ::oPdfPage,185, ::nLinhaPdf-1  , 259, Nil, cValor , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 7 )
            ELSEIF nColuna = 2
               hbNFe_Texto_Hpdf( ::oPdfPage, 71+((nTamForm)/4), ::nLinhaPdf-1  ,126+((nTamForm)/4), Nil, cNumero , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
               hbNFe_Texto_Hpdf( ::oPdfPage,128+((nTamForm)/4), ::nLinhaPdf-1  ,183+((nTamForm)/4), Nil, cVencimento , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
               hbNFe_Texto_Hpdf( ::oPdfPage,185+((nTamForm)/4), ::nLinhaPdf-1  ,259+((nTamForm)/4), Nil, cValor , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 7 )
            ELSEIF nColuna = 3
               hbNFe_Texto_Hpdf( ::oPdfPage, 71+(((nTamForm)/4)*2), ::nLinhaPdf-1  ,126+(((nTamForm)/4)*2), Nil, cNumero , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
               hbNFe_Texto_Hpdf( ::oPdfPage,128+(((nTamForm)/4)*2), ::nLinhaPdf-1  ,183+(((nTamForm)/4)*2), Nil, cVencimento , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
               hbNFe_Texto_Hpdf( ::oPdfPage,185+(((nTamForm)/4)*2), ::nLinhaPdf-1  ,259+(((nTamForm)/4)*2), Nil, cValor , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 7 )
            ELSEIF nColuna = 4
               hbNFe_Texto_Hpdf( ::oPdfPage, 71+(((nTamForm)/4)*3), ::nLinhaPdf-1  ,126+(((nTamForm)/4)*3), Nil, cNumero , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
               hbNFe_Texto_Hpdf( ::oPdfPage,128+(((nTamForm)/4)*3), ::nLinhaPdf-1  ,183+(((nTamForm)/4)*3), Nil, cVencimento , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
               hbNFe_Texto_Hpdf( ::oPdfPage,185+(((nTamForm)/4)*3), ::nLinhaPdf-1  ,259+(((nTamForm)/4)*3), Nil, cValor , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 7 )
               ::nLinhaPdf -= 7
               nColuna := 0
            ENDIF
            cDups := SUBS(cDups,AT("</dup>",::cCobranca)+1)
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
            cDup := hbNFe_PegaDadosXML("dup", cDups )

            cNumero := hbNFe_PegaDadosXML("nDup", cDup )
            IF !EMPTY(cNumero)
               cVencimento := hbNFe_PegaDadosXML("dVenc", cDup )
               cVencimento := SUBS(cVencimento,9,2)+"/"+SUBS(cVencimento,6,2)+"/"+SUBS(cVencimento,1,4)
               cValor := ALLTRIM(FormatNumber(VAL(hbNFe_PegaDadosXML("vDup", cDup )),13,2))
            ELSE
               nColuna --
               EXIT
            ENDIF
            IF nColuna = 1
               hbNFe_Texto_Hpdf( ::oPdfPage,  6, ::nLinhaPdf-1  ,  61, Nil, cNumero , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
               hbNFe_Texto_Hpdf( ::oPdfPage, 63, ::nLinhaPdf-1  , 118, Nil, cVencimento , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
               hbNFe_Texto_Hpdf( ::oPdfPage,120, ::nLinhaPdf-1  , 195, Nil, cValor , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 7 )
            ELSEIF nColuna = 2
               hbNFe_Texto_Hpdf( ::oPdfPage,  6+((nTamForm)/3), ::nLinhaPdf-1  , 61+((nTamForm)/3), Nil, cNumero , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
               hbNFe_Texto_Hpdf( ::oPdfPage, 63+((nTamForm)/3), ::nLinhaPdf-1  ,118+((nTamForm)/3), Nil, cVencimento , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
               hbNFe_Texto_Hpdf( ::oPdfPage,120+((nTamForm)/3), ::nLinhaPdf-1  ,195+((nTamForm)/3), Nil, cValor , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 7 )
            ELSEIF nColuna = 3
               hbNFe_Texto_Hpdf( ::oPdfPage,  6+(((nTamForm)/3)*2), ::nLinhaPdf-1  , 61+(((nTamForm)/3)*2), Nil, cNumero , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
               hbNFe_Texto_Hpdf( ::oPdfPage, 63+(((nTamForm)/3)*2), ::nLinhaPdf-1  ,118+(((nTamForm)/3)*2), Nil, cVencimento , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
               hbNFe_Texto_Hpdf( ::oPdfPage,120+(((nTamForm)/3)*2), ::nLinhaPdf-1  ,195+(((nTamForm)/3)*2), Nil, cValor , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 7 )
               ::nLinhaPdf -= 7
               nColuna := 0
            ENDIF
            cDups := SUBS(cDups,AT("</dup>",::cCobranca)+1)
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
         hbNFe_Texto_Hpdf( ::oPdfPage,70, ::nLinhaPdf  , 830, Nil, "CÁLCULO DO IMPOSTO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 5 )

         ::nLinhaPdf -= 6

         // BASE DE CALCULO DO ICMS
         hbNFe_Box_Hpdf( ::oPdfPage,70, ::nLinhaPdf-16, 145, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-1  , 149, Nil, "BASE DE CÁLCULO DO ICMS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-5  , 149, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vBC" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // VALOR ICMS
         hbNFe_Box_Hpdf( ::oPdfPage,215, ::nLinhaPdf-16, 135, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,216, ::nLinhaPdf-1  , 349, Nil, "VALOR DO ICMS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,216, ::nLinhaPdf-5  , 349, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vICMS" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // BASE DE CALCULO DO ICMS ST
         hbNFe_Box_Hpdf( ::oPdfPage,350, ::nLinhaPdf-16, 165, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,351, ::nLinhaPdf-1  , 514, Nil, "BASE DE CÁLCULO DO ICMS SUBS. TRIB." , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,351, ::nLinhaPdf-5  , 514, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vBCST" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // VALOR ICMS ST
         hbNFe_Box_Hpdf( ::oPdfPage,515, ::nLinhaPdf-16, 135, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,516, ::nLinhaPdf-1  , 649, Nil, "VALOR DO ICMS SUBST." , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,516, ::nLinhaPdf-5  , 649, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vST" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // VALOR TOTAL DOS PRODUTOS
         hbNFe_Box_Hpdf( ::oPdfPage,650, ::nLinhaPdf-16, 180, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,651, ::nLinhaPdf-1  , 829, Nil, "VALOR TOTAL DOS PRODUTOS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,651, ::nLinhaPdf-5  , 8299, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vProd" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 16

         // VALOR DO FRETE
         hbNFe_Box_Hpdf( ::oPdfPage,70, ::nLinhaPdf-16,116, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-1  ,185, Nil, "VALOR DO FRETE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-5  ,185, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vFrete" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // VALOR DO SEGURO
         hbNFe_Box_Hpdf( ::oPdfPage,186, ::nLinhaPdf-16,116, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,187, ::nLinhaPdf-1  , 301, Nil, "VALOR DO SEGURO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,187, ::nLinhaPdf-5  , 301, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vSeg" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // DESCONTO
         hbNFe_Box_Hpdf( ::oPdfPage,302, ::nLinhaPdf-16,116, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,303, ::nLinhaPdf-1  , 417, Nil, "DESCONTO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,303, ::nLinhaPdf-5  , 417, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vDesc" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // OUTRAS DESP. ACESSO.
         hbNFe_Box_Hpdf( ::oPdfPage,418, ::nLinhaPdf-16,116, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,419, ::nLinhaPdf-1  , 533, Nil, "OUTRAS DESP. ACESSÓRIAS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,419, ::nLinhaPdf-5  , 533, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vOutro" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // VALOR DO IPI
         hbNFe_Box_Hpdf( ::oPdfPage,534, ::nLinhaPdf-16,116, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,535, ::nLinhaPdf-1  , 649, Nil, "VALOR DO IPI" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,535, ::nLinhaPdf-5  , 649, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vIPI" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // VALOR TOTAL DA NF
         hbNFe_Box_Hpdf( ::oPdfPage,650, ::nLinhaPdf-16, 180, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,651, ::nLinhaPdf-1  , 829, Nil, "VALOR TOTAL DA NOTA FISCAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,651, ::nLinhaPdf-5  , 829, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vNF" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 17
      ELSE
         hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf  , 589, Nil, "CÁLCULO DO IMPOSTO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 5 )

         ::nLinhaPdf -= 6

         // BASE DE CALCULO DO ICMS
         hbNFe_Box_Hpdf( ::oPdfPage, 5, ::nLinhaPdf-16, 110, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-1  , 114, Nil, "BASE DE CÁLCULO DO ICMS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5  , 114, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vBC" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // VALOR ICMS
         hbNFe_Box_Hpdf( ::oPdfPage,115, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,116, ::nLinhaPdf-1  , 214, Nil, "VALOR DO ICMS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,116, ::nLinhaPdf-5  , 214, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vICMS" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // BASE DE CALCULO DO ICMS ST
         hbNFe_Box_Hpdf( ::oPdfPage,215, ::nLinhaPdf-16, 130, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,216, ::nLinhaPdf-1  , 344, Nil, "BASE DE CÁLCULO DO ICMS SUBS. TRIB." , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,216, ::nLinhaPdf-5  , 344, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vBCST" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // VALOR ICMS ST
         hbNFe_Box_Hpdf( ::oPdfPage,345, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,346, ::nLinhaPdf-1  , 444, Nil, "VALOR DO ICMS SUBST." , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,346, ::nLinhaPdf-5  , 444, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vST" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // VALOR TOTAL DOS PRODUTOS
         hbNFe_Box_Hpdf( ::oPdfPage,445, ::nLinhaPdf-16, 145, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,446, ::nLinhaPdf-1  , 589, Nil, "VALOR TOTAL DOS PRODUTOS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,446, ::nLinhaPdf-5  , 589, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vProd" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 16

         // VALOR DO FRETE
         hbNFe_Box_Hpdf( ::oPdfPage, 5, ::nLinhaPdf-16, 88, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-1  , 92, Nil, "VALOR DO FRETE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5  , 92, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vFrete" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // VALOR DO SEGURO
         hbNFe_Box_Hpdf( ::oPdfPage,93, ::nLinhaPdf-16, 88, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,94, ::nLinhaPdf-1  , 180, Nil, "VALOR DO SEGURO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,94, ::nLinhaPdf-5  , 180, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vSeg" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // DESCONTO
         hbNFe_Box_Hpdf( ::oPdfPage,181, ::nLinhaPdf-16, 88, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,182, ::nLinhaPdf-1  , 268, Nil, "DESCONTO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,182, ::nLinhaPdf-5  , 268, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vDesc" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // OUTRAS DESP. ACESSO.
         hbNFe_Box_Hpdf( ::oPdfPage,269, ::nLinhaPdf-16, 88, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,270, ::nLinhaPdf-1  , 356, Nil, "OUTRAS DESP. ACESSÓRIAS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,270, ::nLinhaPdf-5  , 356, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vOutro" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // VALOR DO IPI
         hbNFe_Box_Hpdf( ::oPdfPage,357, ::nLinhaPdf-16, 88, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,358, ::nLinhaPdf-1  , 444, Nil, "VALOR DO IPI" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,358, ::nLinhaPdf-5  , 444, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vIPI" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // VALOR TOTAL DA NF
         hbNFe_Box_Hpdf( ::oPdfPage,445, ::nLinhaPdf-16, 145, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,446, ::nLinhaPdf-1  , 589, Nil, "VALOR TOTAL DA NOTA FISCAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,446, ::nLinhaPdf-5  , 589, Nil, ALLTRIM(FormatNumber(VAL(::aICMSTotal[ "vNF" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 17
      ENDIF
   ENDIF

   RETURN NIL

METHOD dadosTransporte() CLASS hbNFeDanfe

   IF ::nFolha = 1
      IF ::lPaisagem = .T. // paisagem
         hbNFe_Texto_Hpdf( ::oPdfPage,70, ::nLinhaPdf  , 830, Nil, "TRANSPORTADOR / VOLUMES TRANSPORTADOS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 5 )

         ::nLinhaPdf -= 6

         // NOME/RAZAO SOCIAL
         hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-16, 440, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-1  , 509, Nil, "NOME/RAZÃO SOCIAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-7  , 509, Nil, ::aTransp[ "xNome" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
         // TIPO FRETE
         hbNFe_Box_Hpdf( ::oPdfPage,510, ::nLinhaPdf-16, 90, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-1  , 599, Nil, "FRETE POR CONTA" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         && Modificado por Anderson Camilo em 19/03/2012
         IF ::aTransp[ "modFrete" ] == "0"
            hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-5  , 599, Nil, "0-EMITENTE" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         ELSEIF ::aTransp[ "modFrete" ] == "1"
            hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-5  , 599, Nil, "1-DESTINATARIO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         ELSEIF ::aTransp[ "modFrete" ] == "2"
            hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-5  , 599, Nil, "2-TERCEIROS" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         ELSEIF ::aTransp[ "modFrete" ] == "9"
            hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-5  , 599, Nil, "9-SEM FRETE" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
        ENDIF
         // ANTT
         hbNFe_Box_Hpdf( ::oPdfPage,600, ::nLinhaPdf-16, 60, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,601, ::nLinhaPdf-1  , 659, Nil, "CÓDIGO ANTT" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,601, ::nLinhaPdf-5  , 659, Nil, ::aVeicTransp[ "RNTC" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         // PLACA
         hbNFe_Box_Hpdf( ::oPdfPage,660, ::nLinhaPdf-16, 60, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,661, ::nLinhaPdf-1  , 719, Nil, "PLACA DO VEÍCULO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,661, ::nLinhaPdf-5  , 719, Nil, ::aVeicTransp[ "placa" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         // UF
         hbNFe_Box_Hpdf( ::oPdfPage,720, ::nLinhaPdf-16, 20, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,721, ::nLinhaPdf-1  , 739, Nil, "UF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,721, ::nLinhaPdf-5  , 739, Nil, ::aVeicTransp[ "UF" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         // CNPJ/CPF
         hbNFe_Box_Hpdf( ::oPdfPage,740, ::nLinhaPdf-16, 90, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,741, ::nLinhaPdf-1  , 829, Nil, "CNPJ / CPF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         IF !EMPTY(::aTransp[ "CNPJ" ])
            hbNFe_Texto_Hpdf( ::oPdfPage,741, ::nLinhaPdf-7  , 829, Nil, TRANSF(::aTransp[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
         ELSE
            IF ::aTransp[ "CPF" ] <> Nil
               hbNFe_Texto_Hpdf( ::oPdfPage,741, ::nLinhaPdf-5  , 829, Nil, TRANSF(::aTransp[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
            ENDIF
         ENDIF

         ::nLinhaPdf -= 16

         // ENDEREÇO
         hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-16, 440, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-1  , 509, Nil, "ENDEREÇO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-7  , 509, Nil, ::aTransp[ "xEnder" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
         // MUNICIPIO
         hbNFe_Box_Hpdf( ::oPdfPage,510, ::nLinhaPdf-16, 210, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-1  , 719, Nil, "MUNICÍPIO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-5  , 719, Nil, ::aTransp[ "xMun" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
         // UF
         hbNFe_Box_Hpdf( ::oPdfPage,720, ::nLinhaPdf-16, 20, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,721, ::nLinhaPdf-1  , 739, Nil, "UF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,721, ::nLinhaPdf-5  , 739, Nil, ::aTransp[ "UF" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         // I.E.
         hbNFe_Box_Hpdf( ::oPdfPage,740, ::nLinhaPdf-16, 90, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,741, ::nLinhaPdf-1  , 829, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,741, ::nLinhaPdf-5  , 829, Nil, ::aTransp[ "IE" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 16

         // QUANTIDADE VOLUME
         hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-16,130, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-1  ,199, Nil, "QUANTIDADE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-5  ,199, Nil, Ltrim( FormatNumber( Val( ::aTransp[ "qVol" ] ), 15, 0 ) ) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 8 )
         // ESPECIE
         hbNFe_Box_Hpdf( ::oPdfPage,200, ::nLinhaPdf-16, 130, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,201, ::nLinhaPdf-1  , 329, Nil, "ESPÉCIE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,201, ::nLinhaPdf-5  , 329, Nil, ::aTransp[ "esp" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         // MARCA
         hbNFe_Box_Hpdf( ::oPdfPage,330, ::nLinhaPdf-16, 120, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,331, ::nLinhaPdf-1  , 449, Nil, "MARCA" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,331, ::nLinhaPdf-5  , 449, Nil, ::aTransp[ "marca" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         // NUMERACAO
         hbNFe_Box_Hpdf( ::oPdfPage,450, ::nLinhaPdf-16, 120, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,451, ::nLinhaPdf-1  , 569, Nil, "NUMERAÇÃO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,451, ::nLinhaPdf-5  , 569, Nil, ::aTransp[ "nVol" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         // PESO BRUTO
         hbNFe_Box_Hpdf( ::oPdfPage,570, ::nLinhaPdf-16, 130, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,571, ::nLinhaPdf-1  , 699, Nil, "PESO BRUTO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,571, ::nLinhaPdf-5  , 699, Nil, Ltrim( FormatNumber( Val( ::aTransp[ "pesoB" ] ), 15, 3 ) ) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // PESO LÍQUIDO
         hbNFe_Box_Hpdf( ::oPdfPage,700, ::nLinhaPdf-16,130, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,701, ::nLinhaPdf-1  , 829, Nil, "PESO LÍQUIDO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,701, ::nLinhaPdf-5  , 829, Nil, Ltrim( FormatNumber( Val( ::aTransp[ "pesoL" ] ), 15, 3 ) ), HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 17
      ELSE
         hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf  , 589, Nil, "TRANSPORTADOR / VOLUMES TRANSPORTADOS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 5 )

         ::nLinhaPdf -= 6

         // NOME/RAZAO SOCIAL
         hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-16, 265, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-1  , 269, Nil, "NOME/RAZÃO SOCIAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5  , 269, Nil, ::aTransp[ "xNome" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
         // TIPO FRETE
         hbNFe_Box_Hpdf( ::oPdfPage,270, ::nLinhaPdf-16, 90, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-1  , 359, Nil, "FRETE POR CONTA" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         && Modificado por Anderson Camilo em 19/03/2012
         IF ::aTransp[ "modFrete" ] == "0"
            hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-5  , 359, Nil, "0-EMITENTE" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         ELSEIF ::aTransp[ "modFrete" ] == "1"
            hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-5  , 359, Nil, "1-DESTINATARIO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         ELSEIF ::aTransp[ "modFrete" ] == "2"
            hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-5  , 359, Nil, "2-TERCEIROS" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         ELSEIF ::aTransp[ "modFrete" ] == "9"
            hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-5  , 359, Nil, "9-SEM FRETE" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         ENDIF
         // ANTT
         hbNFe_Box_Hpdf( ::oPdfPage,360, ::nLinhaPdf-16, 60, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,361, ::nLinhaPdf-1  , 419, Nil, "CÓDIGO ANTT" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,361, ::nLinhaPdf-5  , 419, Nil, ::aVeicTransp[ "RNTC" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         // PLACA
         hbNFe_Box_Hpdf( ::oPdfPage,420, ::nLinhaPdf-16, 60, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,421, ::nLinhaPdf-1  , 479, Nil, "PLACA DO VEÍCULO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,421, ::nLinhaPdf-5  , 479, Nil, ::aVeicTransp[ "placa" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         // UF
         hbNFe_Box_Hpdf( ::oPdfPage,480, ::nLinhaPdf-16, 20, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,481, ::nLinhaPdf-1  , 499, Nil, "UF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,481, ::nLinhaPdf-5  , 499, Nil, ::aVeicTransp[ "UF" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         // CNPJ/CPF
         hbNFe_Box_Hpdf( ::oPdfPage,500, ::nLinhaPdf-16, 90, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,501, ::nLinhaPdf-1  , 589, Nil, "CNPJ / CPF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         IF !EMPTY(::aTransp[ "CNPJ" ])
            hbNFe_Texto_Hpdf( ::oPdfPage,501, ::nLinhaPdf-5  , 589, Nil, TRANSF(::aTransp[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         ELSE
            IF ::aTransp[ "CPF" ] <> Nil
               hbNFe_Texto_Hpdf( ::oPdfPage,501, ::nLinhaPdf-5  , 589, Nil, TRANSF(::aTransp[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
            ENDIF
         ENDIF

         ::nLinhaPdf -= 16

         // ENDEREÇO
         hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-16, 265, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-1  , 269, Nil, "ENDEREÇO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5  , 269, Nil, ::aTransp[ "xEnder" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
         // MUNICIPIO
         hbNFe_Box_Hpdf( ::oPdfPage,270, ::nLinhaPdf-16, 210, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-1  , 479, Nil, "MUNICÍPIO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-5  , 479, Nil, ::aTransp[ "xMun" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 10 )
         // UF
         hbNFe_Box_Hpdf( ::oPdfPage,480, ::nLinhaPdf-16, 20, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,481, ::nLinhaPdf-1  , 499, Nil, "UF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,481, ::nLinhaPdf-5  , 499, Nil, ::aTransp[ "UF" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         // I.E.
         hbNFe_Box_Hpdf( ::oPdfPage,500, ::nLinhaPdf-16, 90, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,501, ::nLinhaPdf-1  , 589, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,501, ::nLinhaPdf-5  , 589, Nil, ::aTransp[ "IE" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 16

         // QUANTIDADE VOLUME
         hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-16, 95, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-1  , 99, Nil, "QUANTIDADE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5  , 99, Nil, Ltrim( FormatNumber( Val( ::aTransp[ "qVol" ] ), 15, 0 ) ), HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 8 )
         // ESPECIE
         hbNFe_Box_Hpdf( ::oPdfPage,100, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,101, ::nLinhaPdf-1  , 199, Nil, "ESPÉCIE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,101, ::nLinhaPdf-5  , 199, Nil, ::aTransp[ "esp" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         // MARCA
         hbNFe_Box_Hpdf( ::oPdfPage,200, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,201, ::nLinhaPdf-1  , 299, Nil, "MARCA" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,201, ::nLinhaPdf-5  , 299, Nil, ::aTransp[ "marca" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         // NUMERACAO
         hbNFe_Box_Hpdf( ::oPdfPage,300, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,301, ::nLinhaPdf-1  , 399, Nil, "NUMERAÇÃO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,301, ::nLinhaPdf-5  , 399, Nil, ::aTransp[ "nVol" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
         // PESO BRUTO
         hbNFe_Box_Hpdf( ::oPdfPage,400, ::nLinhaPdf-16, 100, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,401, ::nLinhaPdf-1  , 499, Nil, "PESO BRUTO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,401, ::nLinhaPdf-5  , 499, Nil, LTrim( FormatNumber( Val( ::aTransp[ "pesoB" ] ), 15, 3 ) ), HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
         // PESO LÍQUIDO
         hbNFe_Box_Hpdf( ::oPdfPage,500, ::nLinhaPdf-16, 90, 16, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,501, ::nLinhaPdf-1  , 589, Nil, "PESO LÍQUIDO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
         hbNFe_Texto_Hpdf( ::oPdfPage,501, ::nLinhaPdf-5  , 589, Nil, Ltrim( FormatNumber( Val( ::aTransp[ "pesoL" ] ), 15, 3 ) ), HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 17
      ENDIF
   ENDIF

   RETURN NIL

METHOD cabecalhoProdutos() CLASS hbNFeDanfe

   IF ::lPaisagem = .T. // paisagem
      hbNFe_Texto_Hpdf( ::oPdfPage,70, ::nLinhaPdf  , 830, Nil, "DADOS DOS PRODUTOS / SERVIÇOS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 5 )
      ::nLinhaPdf -= 6

      // CODIGO
      hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-13, 55, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-1  ,124, Nil, "CÓDIGO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-6  ,124, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      // DESCRI
      hbNFe_Box_Hpdf( ::oPdfPage,125, ::nLinhaPdf-13, 235, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,126, ::nLinhaPdf-1  , 359, Nil, "DESCRIÇÃO DO PRODUTO / SERVIÇO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,126, ::nLinhaPdf-6  , 359, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      // NCM
      hbNFe_Box_Hpdf( ::oPdfPage,360, ::nLinhaPdf-13, 35, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,361, ::nLinhaPdf-1  , 394, Nil, "NCM/SH" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,361, ::nLinhaPdf-6  , 394, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      IF ::aEmit[ "CRT" ] = "1" // CSOSN
          // CSOSN
          hbNFe_Box_Hpdf( ::oPdfPage,395, ::nLinhaPdf-13, 15, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,396, ::nLinhaPdf-1  , 409, Nil, "CSOSN" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 4 )
          hbNFe_Texto_Hpdf( ::oPdfPage,396, ::nLinhaPdf-6  , 409, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 4 )
      ELSE
          // CST
          hbNFe_Box_Hpdf( ::oPdfPage,395, ::nLinhaPdf-13, 15, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,396, ::nLinhaPdf-1  , 409, Nil, "CST" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,396, ::nLinhaPdf-6  , 409, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
       ENDIF
      // CFOP
      hbNFe_Box_Hpdf( ::oPdfPage,410, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,411, ::nLinhaPdf-1  , 429, Nil, "CFOP" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,411, ::nLinhaPdf-6  , 429, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      // UNID
      hbNFe_Box_Hpdf( ::oPdfPage,430, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,431, ::nLinhaPdf-1  , 449, Nil, "UNID" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,431, ::nLinhaPdf-6  , 449, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      // QUANT.
      hbNFe_Box_Hpdf( ::oPdfPage,450, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,451, ::nLinhaPdf-1  , 489, Nil, "QUANT." , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,451, ::nLinhaPdf-6  , 489, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      // VALOR UNITARIO
      hbNFe_Box_Hpdf( ::oPdfPage,490, ::nLinhaPdf-13, 45, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,491, ::nLinhaPdf-1  , 534, Nil, "VALOR" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,491, ::nLinhaPdf-6  , 534, Nil, "UNITÁRIO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      // VALOR LÍQUIDO
      hbNFe_Box_Hpdf( ::oPdfPage,535, ::nLinhaPdf-13, 45, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,536, ::nLinhaPdf-1  , 579, Nil, "VALOR TOTAL" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
	      && Linha comentada por Anderson Camilo no dia 20/07/2012   o nome correto é VALOR TOTAL
*      hbNFe_Texto_Hpdf( ::oPdfPage,536, ::nLinhaPdf-6  , 579, Nil, "LÍQUIDO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      // BC ICMS
      hbNFe_Box_Hpdf( ::oPdfPage,580, ::nLinhaPdf-13, 45, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,581, ::nLinhaPdf-1  , 624, Nil, "B. CÁLC." , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,581, ::nLinhaPdf-6  , 624, Nil, "DO ICMS" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      // VALOR ICMS
      hbNFe_Box_Hpdf( ::oPdfPage,625, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,626, ::nLinhaPdf-1  , 664, Nil, "VALOR" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,626, ::nLinhaPdf-6  , 664, Nil, "ICMS" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      // BC ICMS ST
      hbNFe_Box_Hpdf( ::oPdfPage,665, ::nLinhaPdf-13, 45, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,666, ::nLinhaPdf-1  , 709, Nil, "B.CÁLC.ICMS" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,666, ::nLinhaPdf-6  , 709, Nil, "SUBST.TRIB." , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      // VALOR ICMS ST
      hbNFe_Box_Hpdf( ::oPdfPage,710, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,711, ::nLinhaPdf-1  , 749, Nil, "VALOR ICMS" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,711, ::nLinhaPdf-6  , 749, Nil, "SUBST.TRIB" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      // VALOR IPI
      hbNFe_Box_Hpdf( ::oPdfPage,750, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,751, ::nLinhaPdf-1  , 789, Nil, "VALOR" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,751, ::nLinhaPdf-6  , 789, Nil, "IPI" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      // ALIQ ICMS
      hbNFe_Box_Hpdf( ::oPdfPage,790, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,791, ::nLinhaPdf-1  , 809, Nil, "ALÍQ." , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,791, ::nLinhaPdf-6  , 809, Nil, "ICMS" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      // ALIQ IPI
      hbNFe_Box_Hpdf( ::oPdfPage,810, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
      hbNFe_Texto_Hpdf( ::oPdfPage,811, ::nLinhaPdf-1  , 829, Nil, "ALÍQ." , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,811, ::nLinhaPdf-6  , 829, Nil, "IPI" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )

      ::nLinhaPdf -= 13
   ELSE
      IF ::lValorDesc = .F. // Layout Padrão
          hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf  , 589, Nil, "DADOS DOS PRODUTOS / SERVIÇOS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 5 )
          ::nLinhaPdf -= 6

          // CODIGO
          hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-13, 55, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-1  , 59, Nil, "CÓDIGO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-6  , 59, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // DESCRI
          hbNFe_Box_Hpdf( ::oPdfPage,60, ::nLinhaPdf-13, 145, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,61, ::nLinhaPdf-1  , 204, Nil, "DESCRIÇÃO DO PRODUTO / SERVIÇO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,61, ::nLinhaPdf-6  , 204, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // NCM
          hbNFe_Box_Hpdf( ::oPdfPage,205, ::nLinhaPdf-13, 35, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,206, ::nLinhaPdf-1  , 239, Nil, "NCM/SH" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,206, ::nLinhaPdf-6  , 239, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          IF ::aEmit[ "CRT" ] = "1" // CSOSN
              // CSOSN
              hbNFe_Box_Hpdf( ::oPdfPage,240, ::nLinhaPdf-13, 15, 13, ::nLarguraBox )
              hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf-1  , 254, Nil, "CSOSN" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 4 )
              hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf-6  , 254, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 4 )
          ELSE
              // CST
              hbNFe_Box_Hpdf( ::oPdfPage,240, ::nLinhaPdf-13, 15, 13, ::nLarguraBox )
              hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf-1  , 254, Nil, "CST" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
              hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf-6  , 254, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
           ENDIF
          // CFOP
          hbNFe_Box_Hpdf( ::oPdfPage,255, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,256, ::nLinhaPdf-1  , 274, Nil, "CFOP" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,256, ::nLinhaPdf-6  , 274, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // UNID
          hbNFe_Box_Hpdf( ::oPdfPage,275, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,276, ::nLinhaPdf-1  , 294, Nil, "UNID" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,276, ::nLinhaPdf-6  , 294, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // QUANT.
          hbNFe_Box_Hpdf( ::oPdfPage,295, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,296, ::nLinhaPdf-1  , 334, Nil, "QUANT." , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,296, ::nLinhaPdf-6  , 334, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // VALOR UNITARIO
          hbNFe_Box_Hpdf( ::oPdfPage,335, ::nLinhaPdf-13, 45, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,336, ::nLinhaPdf-1  , 379, Nil, "VALOR" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,336, ::nLinhaPdf-6  , 379, Nil, "UNITÁRIO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // VALOR LÍQUIDO
          hbNFe_Box_Hpdf( ::oPdfPage,380, ::nLinhaPdf-13, 45, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,381, ::nLinhaPdf-1  , 424, Nil, "VALOR TOTAL" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
	      && Linha comentada por Anderson Camilo no dia 20/07/2012   o nome correto é VALOR TOTAL
*          hbNFe_Texto_Hpdf( ::oPdfPage,381, ::nLinhaPdf-6  , 424, Nil, "LÍQUIDO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // BC ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,425, ::nLinhaPdf-13, 45, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,426, ::nLinhaPdf-1  , 469, Nil, "B. CÁLC." , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,426, ::nLinhaPdf-6  , 469, Nil, "DO ICMS" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // VALOR ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,470, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,471, ::nLinhaPdf-1  , 509, Nil, "VALOR" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,471, ::nLinhaPdf-6  , 509, Nil, "ICMS" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // VALOR IPI
          hbNFe_Box_Hpdf( ::oPdfPage,510, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-1  , 549, Nil, "VALOR" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf-6  , 549, Nil, "IPI" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // ALIQ ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,550, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,551, ::nLinhaPdf-1  , 569, Nil, "ALÍQ." , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,551, ::nLinhaPdf-6  , 569, Nil, "ICMS" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // ALIQ IPI
          hbNFe_Box_Hpdf( ::oPdfPage,570, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,571, ::nLinhaPdf-1  , 589, Nil, "ALÍQ." , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,571, ::nLinhaPdf-6  , 589, Nil, "IPI" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
      ELSE
          hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf  , 589, Nil, "DADOS DOS PRODUTOS / SERVIÇOS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 5 )
          ::nLinhaPdf -= 6

          // CODIGO
          hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-13, 55, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-1  , 59, Nil, "CÓDIGO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-6  , 59, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // DESCRI
          hbNFe_Box_Hpdf( ::oPdfPage,60, ::nLinhaPdf-13, 145, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,61, ::nLinhaPdf-1  , 204, Nil, "DESCRIÇÃO DO PRODUTO / SERVIÇO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,61, ::nLinhaPdf-6  , 204, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // NCM
          hbNFe_Box_Hpdf( ::oPdfPage,205, ::nLinhaPdf-13, 35, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,206, ::nLinhaPdf-1  , 239, Nil, "NCM/SH" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,206, ::nLinhaPdf-6  , 239, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          IF ::aEmit[ "CRT" ] = "1" // CSOSN
              // CSOSN
              hbNFe_Box_Hpdf( ::oPdfPage,240, ::nLinhaPdf-13, 15, 13, ::nLarguraBox )
              hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf-1  , 254, Nil, "CSOSN" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 4 )
              hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf-6  , 254, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 4 )
          ELSE
              // CST
              hbNFe_Box_Hpdf( ::oPdfPage,240, ::nLinhaPdf-13, 15, 13, ::nLarguraBox )
              hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf-1  , 254, Nil, "CST" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
              hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf-6  , 254, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
           ENDIF
          // CFOP
          hbNFe_Box_Hpdf( ::oPdfPage,255, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,256, ::nLinhaPdf-1  , 274, Nil, "CFOP" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,256, ::nLinhaPdf-6  , 274, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // UNID
          hbNFe_Box_Hpdf( ::oPdfPage,275, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,276, ::nLinhaPdf-1  , 294, Nil, "UNID" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,276, ::nLinhaPdf-6  , 294, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // QUANT.
          hbNFe_Box_Hpdf( ::oPdfPage,295, ::nLinhaPdf-13, 35, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,296, ::nLinhaPdf-1  , 329, Nil, "QUANT." , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,296, ::nLinhaPdf-6  , 329, Nil, "" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // VALOR UNITARIO
          hbNFe_Box_Hpdf( ::oPdfPage,330, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,331, ::nLinhaPdf-1  , 369, Nil, "VALOR" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,331, ::nLinhaPdf-6  , 369, Nil, "UNITÁRIO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // VALOR LÍQUIDO
          hbNFe_Box_Hpdf( ::oPdfPage,370, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-1  , 409, Nil, "VALOR" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
	      && Linha comentada por Anderson Camilo no dia 20/07/2012   o nome correto é VALOR TOTAL
          hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-6  , 409, Nil, "TOTAL" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
*          hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf-6  , 409, Nil, "LÍQUIDO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // VALOR DESCONTO
          hbNFe_Box_Hpdf( ::oPdfPage,410, ::nLinhaPdf-13, 35, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,411, ::nLinhaPdf-1  , 444, Nil, "VALOR" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,411, ::nLinhaPdf-6  , 444, Nil, "DESCTO." , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // BC ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,445, ::nLinhaPdf-13, 40, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,446, ::nLinhaPdf-1  , 484, Nil, "B. CÁLC." , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,446, ::nLinhaPdf-6  , 484, Nil, "DO ICMS" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // VALOR ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,485, ::nLinhaPdf-13, 35, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,486, ::nLinhaPdf-1  , 519, Nil, "VALOR" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,486, ::nLinhaPdf-6  , 519, Nil, "ICMS" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // VALOR IPI
          hbNFe_Box_Hpdf( ::oPdfPage,520, ::nLinhaPdf-13, 30, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,521, ::nLinhaPdf-1  , 549, Nil, "VALOR" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,521, ::nLinhaPdf-6  , 549, Nil, "IPI" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // ALIQ ICMS
          hbNFe_Box_Hpdf( ::oPdfPage,550, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,551, ::nLinhaPdf-1  , 569, Nil, "ALÍQ." , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,551, ::nLinhaPdf-6  , 569, Nil, "ICMS" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          // ALIQ IPI
          hbNFe_Box_Hpdf( ::oPdfPage,570, ::nLinhaPdf-13, 20, 13, ::nLarguraBox )
          hbNFe_Texto_Hpdf( ::oPdfPage,571, ::nLinhaPdf-1  , 589, Nil, "ALÍQ." , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_Hpdf( ::oPdfPage,571, ::nLinhaPdf-6  , 589, Nil, "IPI" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
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

   ::nItensFolha := ::calculaItens1Folha(::nItens1Folha)

   nLinhaFinalProd := ::nLinhaPdf-(::nItensFolha*6)-2
   nTamanhoProd := (::nItensFolha*6)+2
   ::desenhaBoxProdutos(nLinhaFinalProd,nTamanhoProd)

   // DADOS PRODUTOS
   nItem := 1
   ::nLinhaFolha := 1
   DO WHILE .T.
      ::saltaPagina()
      ::ProcessaItens(::cXML,nItem)
      IF ::aItem[ "cProd" ] = Nil
         EXIT
      ENDIF

      IF ::lPaisagem = .T. // paisagem
         // CODIGO
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf  , 124, Nil, ::aItem[ "cProd" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
         // DESCRI
         hbNFe_Texto_Hpdf( ::oPdfPage,126, ::nLinhaPdf  , 359, Nil, TRIM(MEMOLINE(::aItem[ "xProd" ],::nLarguraDescricao,1)) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         // NCM
         hbNFe_Texto_Hpdf( ::oPdfPage,361, ::nLinhaPdf  , 394, Nil, ::aItem[ "NCM" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
         IF ::aEmit[ "CRT" ] = "1" // CSOSN
            // CST/CSOSN
            hbNFe_Texto_Hpdf( ::oPdfPage,396, ::nLinhaPdf  , 409, Nil, ::aItemICMS[ "orig" ]+::aItemICMS[ "CSOSN" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 5 )
         ELSE
            // CST
            hbNFe_Texto_Hpdf( ::oPdfPage,396, ::nLinhaPdf  , 409, Nil, ::aItemICMS[ "orig" ]+::aItemICMS[ "CST" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
         ENDIF
         // CFOP
         hbNFe_Texto_Hpdf( ::oPdfPage,411, ::nLinhaPdf  , 429, Nil, ::aItem[ "CFOP" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
         // UNID
         hbNFe_Texto_Hpdf( ::oPdfPage,431, ::nLinhaPdf  , 449, Nil, ::aItem[ "uCom" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
         // QUANT.
         hbNFe_Texto_Hpdf( ::oPdfPage,451, ::nLinhaPdf  , 489, Nil, ALLTRIM(FormatNumber(VAL(::aItem[ "qCom" ]),15,::nCasasQtd)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
         // VALOR UNITARIO
         hbNFe_Texto_Hpdf( ::oPdfPage,491, ::nLinhaPdf  , 534, Nil, ALLTRIM(FormatNumber(VAL(::aItem[ "vUnCom" ]),15,::nCasasVUn)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
         // VALOR LÍQUIDO
         hbNFe_Texto_Hpdf( ::oPdfPage,536, ::nLinhaPdf  , 579, Nil, ALLTRIM(FormatNumber(VAL(::aItem[ "vProd" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
         // BC ICMS
         hbNFe_Texto_Hpdf( ::oPdfPage,581, ::nLinhaPdf  , 624, Nil, ALLTRIM(FormatNumber(VAL(IF(::aItemICMS[ "vBC" ]<>Nil,::aItemICMS[ "vBC" ],"0")),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
         // VALOR ICMS
         hbNFe_Texto_Hpdf( ::oPdfPage,626, ::nLinhaPdf  , 664, Nil, ALLTRIM(FormatNumber(VAL(IF(::aItemICMS[ "vICMS" ]<>Nil,::aItemICMS[ "vICMS" ],"0")),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
         // BC ICMS ST
         hbNFe_Texto_Hpdf( ::oPdfPage,666, ::nLinhaPdf  , 709, Nil, ALLTRIM(FormatNumber(VAL(IF(::aItemICMS[ "vBCST" ]<>Nil,::aItemICMS[ "vBCST" ],"0")),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
         // VALOR ICMS ST
         hbNFe_Texto_Hpdf( ::oPdfPage,711, ::nLinhaPdf  , 749, Nil, ALLTRIM(FormatNumber(VAL(IF(::aItemICMS[ "vICMSST" ]<>Nil,::aItemICMS[ "vICMSST" ],"0")),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
         // VALOR IPI
           hbNFe_Texto_Hpdf( ::oPdfPage,751, ::nLinhaPdf  , 789, Nil, ALLTRIM(FormatNumber(VAL(IF(::aItemIPI[ "vIPI" ]<>Nil,::aItemIPI[ "vIPI" ],"0")),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
         // ALIQ ICMS
         hbNFe_Texto_Hpdf( ::oPdfPage,791, ::nLinhaPdf  , 809, Nil, ALLTRIM(FormatNumber(VAL(IF(::aItemICMS[ "pICMS" ]<>Nil,::aItemICMS[ "pICMS" ],"0")),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
         // ALIQ IPI
           hbNFe_Texto_Hpdf( ::oPdfPage,811, ::nLinhaPdf  , 829, Nil, ALLTRIM(FormatNumber(VAL(IF(::aItemIPI[ "pIPI" ]<>Nil,::aItemIPI[ "pIPI" ],"0")),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
         ::nLinhaPdf -= 6

         nItem++
         ::nLinhaFolha ++
         FOR nIdes = 2 TO MLCOUNT(::aItem[ "xProd" ],::nLarguraDescricao)
            ::saltaPagina()
            // DESCRI
            hbNFe_Texto_Hpdf( ::oPdfPage,126, ::nLinhaPdf  , 359, Nil, TRIM(MEMOLINE(::aItem[ "xProd" ],::nLarguraDescricao,nIdes)) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
            ::nLinhaFolha ++
            ::nLinhaPdf -= 6
         NEXT
         TRY
            FOR nIDes = 1 TO MLCOUNT(::aItem[ "infAdProd" ],::nLarguraDescricao)
                ::saltaPagina()
                // DESCRI
                hbNFe_Texto_Hpdf( ::oPdfPage,126, ::nLinhaPdf  , 359, Nil, TRIM(MEMOLINE(::aItem[ "infAdProd" ],::nLarguraDescricao,nIdes)) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
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
             // CODIGO
             hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf  , 59, Nil, ::aItem[ "cProd" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
             // DESCRI
             hbNFe_Texto_Hpdf( ::oPdfPage,61, ::nLinhaPdf  , 204, Nil, TRIM(MEMOLINE(::aItem[ "xProd" ],::nLarguraDescricao,1)) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
             // NCM
             hbNFe_Texto_Hpdf( ::oPdfPage,206, ::nLinhaPdf  , 239, Nil, ::aItem[ "NCM" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
             IF ::aEmit[ "CRT" ] = "1" // CSOSN
                 // CSOSN
                 hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf  , 254, Nil, ::aItemICMS[ "orig" ]+::aItemICMS[ "CSOSN" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 5 )
             ELSE
                 // CST
                 hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf  , 254, Nil, ::aItemICMS[ "orig" ]+::aItemICMS[ "CST" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
              ENDIF
             // CFOP
             hbNFe_Texto_Hpdf( ::oPdfPage,256, ::nLinhaPdf  , 274, Nil, ::aItem[ "CFOP" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
             // UNID
             hbNFe_Texto_Hpdf( ::oPdfPage,276, ::nLinhaPdf  , 294, Nil, ::aItem[ "uCom" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
             // QUANT.
             hbNFe_Texto_Hpdf( ::oPdfPage,296, ::nLinhaPdf  , 334, Nil, ALLTRIM(FormatNumber(VAL(::aItem[ "qCom" ]),15,::nCasasQtd)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 5 )
             // VALOR UNITARIO
             hbNFe_Texto_Hpdf( ::oPdfPage,336, ::nLinhaPdf  , 379, Nil, ALLTRIM(FormatNumber(VAL(::aItem[ "vUnCom" ]),15,::nCasasVUn)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
             // VALOR LÍQUIDO
             hbNFe_Texto_Hpdf( ::oPdfPage,381, ::nLinhaPdf  , 424, Nil, ALLTRIM(FormatNumber(VAL(::aItem[ "vProd" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
             // BC ICMS
             hbNFe_Texto_Hpdf( ::oPdfPage,426, ::nLinhaPdf  , 469, Nil, ALLTRIM(FormatNumber(VAL(IF(::aItemICMS[ "vBC" ]<>Nil,::aItemICMS[ "vBC" ],"0")),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
             // VALOR ICMS
             hbNFe_Texto_Hpdf( ::oPdfPage,471, ::nLinhaPdf  , 509, Nil, ALLTRIM(FormatNumber(VAL(IF(::aItemICMS[ "vICMS" ]<>Nil,::aItemICMS[ "vICMS" ],"0")),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
             // VALOR IPI
               hbNFe_Texto_Hpdf( ::oPdfPage,511, ::nLinhaPdf  , 549, Nil, ALLTRIM(FormatNumber(VAL(IF(::aItemIPI[ "vIPI" ]<>Nil,::aItemIPI[ "vIPI" ],"0")),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
             // ALIQ ICMS
             hbNFe_Texto_Hpdf( ::oPdfPage,551, ::nLinhaPdf  , 569, Nil, ALLTRIM(FormatNumber(VAL(IF(::aItemICMS[ "pICMS" ]<>Nil,::aItemICMS[ "pICMS" ],"0")),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
             // ALIQ IPI
               hbNFe_Texto_Hpdf( ::oPdfPage,571, ::nLinhaPdf  , 589, Nil, ALLTRIM(FormatNumber(VAL(IF(::aItemIPI[ "pIPI" ]<>Nil,::aItemIPI[ "pIPI" ],"0")),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
             ::nLinhaPdf -= 6

             nItem++
             ::nLinhaFolha ++
             FOR nIdes = 2 TO MLCOUNT(::aItem[ "xProd" ],::nLarguraDescricao)
                ::saltaPagina()
                // DESCRI
                hbNFe_Texto_Hpdf( ::oPdfPage,61, ::nLinhaPdf  , 204, Nil, TRIM(MEMOLINE(::aItem[ "xProd" ],::nLarguraDescricao,nIdes)) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
                ::nLinhaFolha ++
                ::nLinhaPdf -= 6
             NEXT
             TRY
               FOR nIDes = 1 TO MLCOUNT(::aItem[ "infAdProd" ],::nLarguraDescricao)
                  ::saltaPagina()
                  // DESCRI
                  hbNFe_Texto_Hpdf( ::oPdfPage,61, ::nLinhaPdf  , 204, Nil, TRIM(MEMOLINE(::aItem[ "infAdProd" ],::nLarguraDescricao,nIdes)) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
                  ::nLinhaFolha ++
                  ::nLinhaPdf -= 6
               NEXT
            CATCH
            END
          ELSE
             // CODIGO
             hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf  , 59, Nil, ::aItem[ "cProd" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
             // DESCRI
             hbNFe_Texto_Hpdf( ::oPdfPage,61, ::nLinhaPdf  , 204, Nil, TRIM(MEMOLINE(::aItem[ "xProd" ],::nLarguraDescricao,1)) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
             // NCM
             hbNFe_Texto_Hpdf( ::oPdfPage,206, ::nLinhaPdf  , 239, Nil, ::aItem[ "NCM" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
            IF ::aEmit[ "CRT" ] = "1" // CSOSN
                 // CSOSN
                 hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf  , 254, Nil, ::aItemICMS[ "orig" ]+::aItemICMS[ "CSOSN" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 5 )
            ELSE
                 // CST
                 hbNFe_Texto_Hpdf( ::oPdfPage,241, ::nLinhaPdf  , 254, Nil, ::aItemICMS[ "orig" ]+::aItemICMS[ "CST" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
              ENDIF
             // CFOP
             hbNFe_Texto_Hpdf( ::oPdfPage,256, ::nLinhaPdf  , 274, Nil, ::aItem[ "CFOP" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
             // UNID
             hbNFe_Texto_Hpdf( ::oPdfPage,276, ::nLinhaPdf  , 294, Nil, ::aItem[ "uCom" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
             // QUANT.
             hbNFe_Texto_Hpdf( ::oPdfPage,296, ::nLinhaPdf  , 329, Nil, ALLTRIM(FormatNumber(VAL(::aItem[ "qCom" ]),15,::nCasasQtd)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 5 )
             // VALOR UNITARIO
             hbNFe_Texto_Hpdf( ::oPdfPage,331, ::nLinhaPdf  , 369, Nil, ALLTRIM(FormatNumber(VAL(::aItem[ "vUnCom" ]),15,::nCasasVUn)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
             // VALOR LÍQUIDO
             hbNFe_Texto_Hpdf( ::oPdfPage,371, ::nLinhaPdf  , 409, Nil, ALLTRIM(FormatNumber(VAL(::aItem[ "vProd" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
             // VALOR DESCONTO
             TRY
                hbNFe_Texto_Hpdf( ::oPdfPage,411, ::nLinhaPdf  , 444, Nil, ALLTRIM(FormatNumber(VAL(::aItem[ "vDesc" ]),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
             CATCH
                hbNFe_Texto_Hpdf( ::oPdfPage,411, ::nLinhaPdf  , 444, Nil, ALLTRIM(FormatNumber(VAL('0.00'),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
             END
             // BC ICMS
             hbNFe_Texto_Hpdf( ::oPdfPage,446, ::nLinhaPdf  , 484, Nil, ALLTRIM(FormatNumber(VAL(IF(::aItemICMS[ "vBC" ]<>Nil,::aItemICMS[ "vBC" ],"0")),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
             // VALOR ICMS
             hbNFe_Texto_Hpdf( ::oPdfPage,486, ::nLinhaPdf  , 519, Nil, ALLTRIM(FormatNumber(VAL(IF(::aItemICMS[ "vICMS" ]<>Nil,::aItemICMS[ "vICMS" ],"0")),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
             // VALOR IPI
               hbNFe_Texto_Hpdf( ::oPdfPage,521, ::nLinhaPdf  , 549, Nil, ALLTRIM(FormatNumber(VAL(IF(::aItemIPI[ "vIPI" ]<>Nil,::aItemIPI[ "vIPI" ],"0")),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
             // ALIQ ICMS
             hbNFe_Texto_Hpdf( ::oPdfPage,551, ::nLinhaPdf  , 569, Nil, ALLTRIM(FormatNumber(VAL(IF(::aItemICMS[ "pICMS" ]<>Nil,::aItemICMS[ "pICMS" ],"0")),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
             // ALIQ IPI
               hbNFe_Texto_Hpdf( ::oPdfPage,571, ::nLinhaPdf  , 589, Nil, ALLTRIM(FormatNumber(VAL(IF(::aItemIPI[ "pIPI" ]<>Nil,::aItemIPI[ "pIPI" ],"0")),15,2)) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
             ::nLinhaPdf -= 6

             nItem++
             ::nLinhaFolha ++
             FOR nIdes = 2 TO MLCOUNT(::aItem[ "xProd" ],::nLarguraDescricao)
                ::saltaPagina()
                // DESCRI
                hbNFe_Texto_Hpdf( ::oPdfPage,61, ::nLinhaPdf  , 204, Nil, TRIM(MEMOLINE(::aItem[ "xProd" ],::nLarguraDescricao,nIdes)) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
                ::nLinhaFolha ++
                ::nLinhaPdf -= 6
             NEXT
             TRY
               FOR nIDes = 1 TO MLCOUNT(::aItem[ "infAdProd" ],::nLarguraDescricao)
                  ::saltaPagina()
                  // DESCRI
                  hbNFe_Texto_Hpdf( ::oPdfPage,61, ::nLinhaPdf  , 204, Nil, TRIM(MEMOLINE(::aItem[ "infAdProd" ],::nLarguraDescricao,nIdes)) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
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
      IF VAL(IF(::aISSTotal[ "vServ" ]<>Nil,::aISSTotal[ "vServ" ],"0")) > 0 // com servico
         IF ::lPaisagem = .T. // paisagem
            hbNFe_Texto_Hpdf( ::oPdfPage,70, ::nLinhaPdf  , 830, Nil, "CALCULO DO ISSQN" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 5 )

            ::nLinhaPdf -= 6

            // INSCRICAO
            hbNFe_Box_Hpdf( ::oPdfPage,  70, ::nLinhaPdf-16, 200, 16, ::nLarguraBox )
            hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-1  , 269, Nil, "INSCRIÇÃO MUNICIPAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
            hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-5  , 269, Nil, ::aEmit[ "IM" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
            // VALOR SERV.
            hbNFe_Box_Hpdf( ::oPdfPage,270, ::nLinhaPdf-16,190, 16, ::nLarguraBox )
            hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-1  , 459, Nil, "VALOR TOTAL DOS SERVIÇOS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
            hbNFe_Texto_Hpdf( ::oPdfPage,271, ::nLinhaPdf-5  , 459, Nil, FormatNumber(VAL(IF(::aISSTotal[ "vServ" ]<>Nil,::aISSTotal[ "vServ" ],"0")),15) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
            // BASE DE CALC
            hbNFe_Box_Hpdf( ::oPdfPage,460, ::nLinhaPdf-16, 190, 16, ::nLarguraBox )
            hbNFe_Texto_Hpdf( ::oPdfPage,461, ::nLinhaPdf-1  , 649, Nil, "BASE DE CÁLCULO DO ISSQN" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
            hbNFe_Texto_Hpdf( ::oPdfPage,461, ::nLinhaPdf-5  , 649, Nil, FormatNumber(VAL(IF(::aISSTotal[ "vBC" ]<>Nil,::aISSTotal[ "vBC" ],"0")),15) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
            // VALOR DO ISSQN
            hbNFe_Box_Hpdf( ::oPdfPage,650, ::nLinhaPdf-16, 180, 16, ::nLarguraBox )
            hbNFe_Texto_Hpdf( ::oPdfPage,651, ::nLinhaPdf-1  , 829, Nil, "VALOR DO ISSQN" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
            hbNFe_Texto_Hpdf( ::oPdfPage,651, ::nLinhaPdf-5  , 829, Nil, FormatNumber(VAL(IF(::aISSTotal[ "vISS" ]<>Nil,::aISSTotal[ "vISS" ],"0")),15) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )

            ::nLinhaPdf -= 17
         ELSE
            hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf  , 589, Nil, "CALCULO DO ISSQN" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 5 )

            ::nLinhaPdf -= 6

            // INSCRICAO
            hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-16, 150, 16, ::nLarguraBox )
            hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-1  , 154, Nil, "INSCRIÇÃO MUNICIPAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
            hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-5  , 154, Nil, ::aEmit[ "IM" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
            // VALOR SERV.
            hbNFe_Box_Hpdf( ::oPdfPage,155, ::nLinhaPdf-16,145, 16, ::nLarguraBox )
            hbNFe_Texto_Hpdf( ::oPdfPage,156, ::nLinhaPdf-1  , 299, Nil, "VALOR TOTAL DOS SERVIÇOS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
            hbNFe_Texto_Hpdf( ::oPdfPage,156, ::nLinhaPdf-5  , 299, Nil, FormatNumber(VAL(IF(::aISSTotal[ "vServ" ]<>Nil,::aISSTotal[ "vServ" ],"0")),15) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
            // BASE DE CALC
            hbNFe_Box_Hpdf( ::oPdfPage,300, ::nLinhaPdf-16, 145, 16, ::nLarguraBox )
            hbNFe_Texto_Hpdf( ::oPdfPage,301, ::nLinhaPdf-1  , 444, Nil, "BASE DE CÁLCULO DO ISSQN" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
            hbNFe_Texto_Hpdf( ::oPdfPage,301, ::nLinhaPdf-5  , 444, Nil, FormatNumber(VAL(IF(::aISSTotal[ "vBC" ]<>Nil,::aISSTotal[ "vBC" ],"0")),15) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )
            // VALOR DO ISSQN
            hbNFe_Box_Hpdf( ::oPdfPage,445, ::nLinhaPdf-16, 145, 16, ::nLarguraBox )
            hbNFe_Texto_Hpdf( ::oPdfPage,446, ::nLinhaPdf-1  , 589, Nil, "VALOR DO ISSQN" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 5 )
            hbNFe_Texto_Hpdf( ::oPdfPage,446, ::nLinhaPdf-5  , 589, Nil, FormatNumber(VAL(IF(::aISSTotal[ "vISS" ]<>Nil,::aISSTotal[ "vISS" ],"0")),15) , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 10 )

            ::nLinhaPdf -= 17
         ENDIF
      ENDIF
   ENDIF

   RETURN NIL

METHOD dadosAdicionais() CLASS hbNFeDanfe

   LOCAL cMemo, nI

   IF ::nFolha = 1
      IF ::lPaisagem = .T. // paisagem
         hbNFe_Texto_Hpdf( ::oPdfPage,70, ::nLinhaPdf  , 830, Nil, "DADOS ADICIONAIS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 5 )

         ::nLinhaPdf -= 6

         // INF. COMPL.
         hbNFe_Box_Hpdf( ::oPdfPage, 70, ::nLinhaPdf-78, 495, 78, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf-1  ,564, Nil, "INFORMAÇÕES COMPLEMENTARES" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         // RESERVADO FISCO
         hbNFe_Box_Hpdf( ::oPdfPage,565, ::nLinhaPdf-78, 265, 78, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,566, ::nLinhaPdf-1  ,829, Nil, "RESERVADO AO FISCO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         ::nLinhaPdf -= 7
         ::nLinhaPdf -= 4 //ESPAÇO


         cMemo := IF(::aInfAdic[ "infCpl" ]<>Nil,::aInfAdic[ "infCpl" ],"")
         cMemo := STRTRAN( cMemo , ";", CHR(13)+CHR(10) )
         FOR nI = 1 TO MLCOUNT( cMemo, 100 )
            hbNFe_Texto_Hpdf( ::oPdfPage,71, ::nLinhaPdf    ,564, Nil, TRIM(MEMOLINE(cMemo,100,nI)) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
            ::nLinhaPdf -= 6
         NEXT
         FOR nI=(MLCOUNT( cMemo, 100 )+1) TO 11
            ::nLinhaPdf -= 6
         NEXT
         ::nLinhaPdf -= 2
      ELSE
         hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf  , 589, Nil, "DADOS ADICIONAIS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 5 )

         ::nLinhaPdf -= 6

         // INF. COMPL.    && Alterado por anderson em 18/07/2012
*         hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-78, 395, 78, ::nLarguraBox )

         hbNFe_Box_Hpdf( ::oPdfPage,  5, ::nLinhaPdf-92, 395, 92, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf-1  ,399, Nil, "INFORMAÇÕES COMPLEMENTARES" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         // RESERVADO FISCO

                           && Alterado por anderson em 18/07/2012
*        hbNFe_Box_Hpdf( ::oPdfPage,400, ::nLinhaPdf-78, 190, 78, ::nLarguraBox )
         hbNFe_Box_Hpdf( ::oPdfPage,400, ::nLinhaPdf-92, 190, 92, ::nLarguraBox )
         hbNFe_Texto_Hpdf( ::oPdfPage,401, ::nLinhaPdf-1  ,589, Nil, "RESERVADO AO FISCO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         ::nLinhaPdf -= 7    //
         ::nLinhaPdf -= 4 //ESPAÇO


         cMemo := IF(::aInfAdic[ "infCpl" ]<>Nil,::aInfAdic[ "infCpl" ],"")
         cMemo := STRTRAN( cMemo , ";", CHR(13)+CHR(10) )
         FOR nI = 1 TO MLCOUNT( cMemo, 100 )
            hbNFe_Texto_Hpdf( ::oPdfPage,6, ::nLinhaPdf    ,399, Nil, TRIM(MEMOLINE(cMemo,100,nI)) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
            ::nLinhaPdf -= 6
         NEXT

         FOR nI=(MLCOUNT( cMemo, 100 )+1) TO 13    && Alterado por anderson  o original era TO 11
            ::nLinhaPdf -= 6
         NEXT
         ::nLinhaPdf -= 4                          && Alterado por anderson  o original era -2
      ENDIF
   ENDIF

   RETURN NIL

METHOD rodape() CLASS hbNFeDanfe

   IF ::lPaisagem = .T. // paisagem
      hbNFe_Texto_Hpdf( ::oPdfPage,70, ::nLinhaPdf  , 175, Nil, "DATA DA IMPRESSÃO: "+DTOC(DATE()) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,185, ::nLinhaPdf  , 829, Nil, ::cDesenvolvedor , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
   ELSE
      hbNFe_Texto_Hpdf( ::oPdfPage, 5, ::nLinhaPdf  , 110, Nil, "DATA DA IMPRESSÃO: "+DTOC(DATE()) , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
      hbNFe_Texto_Hpdf( ::oPdfPage,115, ::nLinhaPdf  , 589, Nil, ::cDesenvolvedor , HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 6 )
   ENDIF

   RETURN NIL

METHOD ProcessaItens(cXML,nItem) CLASS hbNFeDanfe

   LOCAL cItem, cItemDI, cItemAdi, cItemICMS, cItemICMSPart, cItemICMSST,;
         cItemICMSSN101, cItemICMSSN102, cItemICMSSN201, cItemICMSSN202, cItemICMSSN500, cItemICMSSN900,;
         cItemIPI, cItemII, cItemPIS, cItemPISST, cItemCOFINS, cItemCOFINSST, cItemISSQN


   cItem := hbNFe_PegaDadosXML('det nItem="'+ALLTRIM(STR(nItem))+'"', cXML, "det" )
   ::aItem := hb_Hash()
   ::aItem[ "cProd" ] := hbNFe_PegaDadosXML("cProd", cItem )
   ::aItem[ "cEAN" ] := hbNFe_PegaDadosXML("cEAN", cItem )
   ::aItem[ "xProd" ] := hbNFe_PegaDadosXML("xProd", cItem )
   ::aItem[ "NCM" ] := hbNFe_PegaDadosXML("NCM", cItem )
   ::aItem[ "EXTIPI" ] := hbNFe_PegaDadosXML("EXTIPI", cItem )
   ::aItem[ "CFOP" ] := hbNFe_PegaDadosXML("CFOP", cItem )
   ::aItem[ "uCom" ] := hbNFe_PegaDadosXML("uCom", cItem )
   ::aItem[ "qCom" ] := hbNFe_PegaDadosXML("qCom", cItem )
   ::aItem[ "vUnCom" ] := hbNFe_PegaDadosXML("vUnCom", cItem )
   ::aItem[ "vProd" ] := hbNFe_PegaDadosXML("vProd", cItem )
   ::aItem[ "cEANTrib" ] := hbNFe_PegaDadosXML("cEANTrib", cItem )
   ::aItem[ "uTrib" ] := hbNFe_PegaDadosXML("uTrib", cItem )
   ::aItem[ "qTrib" ] := hbNFe_PegaDadosXML("qTrib", cItem ) // NFE 2.0
   ::aItem[ "vUnTrib" ] := hbNFe_PegaDadosXML("vUnTrib", cItem ) // NFE 2.0
   ::aItem[ "vFrete" ] := hbNFe_PegaDadosXML("vFrete", cItem )
   ::aItem[ "vSeg" ] := hbNFe_PegaDadosXML("vSeg", cItem )
   ::aItem[ "vDesc" ] := hbNFe_PegaDadosXML("vDesc", cItem )
   ::aItem[ "vOutro" ] := hbNFe_PegaDadosXML("vOutro", cItem ) // NFE 2.0
   ::aItem[ "indTot" ] := hbNFe_PegaDadosXML("indTot", cItem ) // NFE 2.0
   ::aItem[ "infAdProd" ] := hbNFe_PegaDadosXML("infAdProd", cItem )
   IF ::aItem[ "infAdProd" ] <> Nil
      ::aItem[ "infAdProd" ] := STRTRAN( ::aItem[ "infAdProd" ] , ";", CHR(13)+CHR(10) )
   ENDIF

   cItemDI := hbNFe_PegaDadosXML('DI', cItem )
   ::aItemDI := hb_Hash()
   ::aItemDI[ "nDI" ] := hbNFe_PegaDadosXML("nDI", cItemDI )
   ::aItemDI[ "dDI" ] := hbNFe_PegaDadosXML("dDI", cItemDI )
   ::aItemDI[ "xLocDesemb" ] := hbNFe_PegaDadosXML("xLocDesemb", cItemDI )
   ::aItemDI[ "UFDesemb" ] := hbNFe_PegaDadosXML("UFDesemb", cItemDI )
   ::aItemDI[ "dDesemb" ] := hbNFe_PegaDadosXML("dDesemb", cItemDI )
   ::aItemDI[ "cExportador" ] := hbNFe_PegaDadosXML("cExportador", cItemDI )

   cItemAdi := hbNFe_PegaDadosXML('adi', cItem )
   ::aItemAdi := hb_Hash()
   ::aItemAdi[ "nAdicao" ] := hbNFe_PegaDadosXML("nAdicao", cItemAdi )
   ::aItemAdi[ "nSeqAdic" ] := hbNFe_PegaDadosXML("nSeqAdic", cItemAdi )
   ::aItemAdi[ "cFabricante" ] := hbNFe_PegaDadosXML("cFabricante", cItemAdi )
   ::aItemAdi[ "vDescDI" ] := hbNFe_PegaDadosXML("vDescDI", cItemAdi )
   ::aItemAdi[ "xPed" ] := hbNFe_PegaDadosXML("xPed", cItemAdi ) // NFE 2.0
   ::aItemAdi[ "nItemPed" ] := hbNFe_PegaDadosXML("nItemPed", cItemAdi ) // NFE 2.0

   // todo veiculos (veicProd), medicamentos (med), armamentos (arm), combustiveis (comb)

   cItemICMS := hbNFe_PegaDadosXML('ICMS', cItem )
   ::aItemICMS := hb_Hash()
   ::aItemICMS[ "orig" ] := hbNFe_PegaDadosXML("orig", cItemICMS )
   ::aItemICMS[ "CST" ] := hbNFe_PegaDadosXML("CST", cItemICMS )
   ::aItemICMS[ "CSOSN" ] := hbNFe_PegaDadosXML("CSOSN", cItemICMS )
   ::aItemICMS[ "vBCSTRet" ] := hbNFe_PegaDadosXML("vBCSTRet", cItemICMS )
   ::aItemICMS[ "vICMSSTRet" ] := hbNFe_PegaDadosXML("vICMSSTRet", cItemICMS )
   ::aItemICMS[ "modBC" ] := hbNFe_PegaDadosXML("modBC", cItemICMS )
   ::aItemICMS[ "pRedBC" ] := hbNFe_PegaDadosXML("pRedBC", cItemICMS )
   ::aItemICMS[ "vBC" ] := hbNFe_PegaDadosXML("vBC", cItemICMS )
   ::aItemICMS[ "pICMS" ] := hbNFe_PegaDadosXML("pICMS", cItemICMS )
   ::aItemICMS[ "vICMS" ] := hbNFe_PegaDadosXML("vICMS", cItemICMS )
   ::aItemICMS[ "motDesICMS" ] := hbNFe_PegaDadosXML("motDesICMS", cItemICMS )
   ::aItemICMS[ "modBCST" ] := hbNFe_PegaDadosXML("nItemICMS", cItemICMS )
   ::aItemICMS[ "pMVAST" ] := hbNFe_PegaDadosXML("pMVAST", cItemICMS )
   ::aItemICMS[ "pRedBCST" ] := hbNFe_PegaDadosXML("pRedBCST", cItemICMS )
   ::aItemICMS[ "vBCST" ] := hbNFe_PegaDadosXML("vBCST", cItemICMS )
   ::aItemICMS[ "pICMSST" ] := hbNFe_PegaDadosXML("pICMSST", cItemICMS )
   ::aItemICMS[ "vICMSST" ] := hbNFe_PegaDadosXML("vICMSST", cItemICMS )

   cItemICMSPart := hbNFe_PegaDadosXML('ICMSPart', cItem )
   ::aItemICMSPart := hb_Hash()
   ::aItemICMSPart[ "orig" ] := hbNFe_PegaDadosXML("orig", cItemICMSPart )
   ::aItemICMSPart[ "CST" ] := hbNFe_PegaDadosXML("CST", cItemICMSPart )
   ::aItemICMSPart[ "modBC" ] := hbNFe_PegaDadosXML("modBC", cItemICMSPart )
   ::aItemICMSPart[ "pRedBC" ] := hbNFe_PegaDadosXML("pRedBC", cItemICMSPart )
   ::aItemICMSPart[ "vBC" ] := hbNFe_PegaDadosXML("vBC", cItemICMSPart )
   ::aItemICMSPart[ "pICMS" ] := hbNFe_PegaDadosXML("pICMS", cItemICMSPart )
   ::aItemICMSPart[ "vICMS" ] := hbNFe_PegaDadosXML("vICMS", cItemICMSPart )
   ::aItemICMSPart[ "modBCST" ] := hbNFe_PegaDadosXML("nItemICMSPart", cItemICMSPart )
   ::aItemICMSPart[ "pMVAST" ] := hbNFe_PegaDadosXML("pMVAST", cItemICMSPart )
   ::aItemICMSPart[ "pRedBCST" ] := hbNFe_PegaDadosXML("pRedBCST", cItemICMSPart )
   ::aItemICMSPart[ "vBCST" ] := hbNFe_PegaDadosXML("vBCST", cItemICMSPart )
   ::aItemICMSPart[ "pICMSST" ] := hbNFe_PegaDadosXML("pICMSST", cItemICMSPart )
   ::aItemICMSPart[ "vICMSST" ] := hbNFe_PegaDadosXML("vICMSST", cItemICMSPart )
   ::aItemICMSPart[ "pBCOp" ] := hbNFe_PegaDadosXML("pBCOp", cItemICMSPart )
   ::aItemICMSPart[ "UFST" ] := hbNFe_PegaDadosXML("UFST", cItemICMSPart )

   cItemICMSST := hbNFe_PegaDadosXML('ICMSST', cItem )
   ::aItemICMSST := hb_Hash()
   ::aItemICMSST[ "orig" ] := hbNFe_PegaDadosXML("orig", cItemICMSST )
   ::aItemICMSST[ "CST" ] := hbNFe_PegaDadosXML("CST", cItemICMSST )
   ::aItemICMSST[ "vBCSTRet" ] := hbNFe_PegaDadosXML("vBCSTRet", cItemICMSST )
   ::aItemICMSST[ "vICMSSTRet" ] := hbNFe_PegaDadosXML("vICMSSTRet", cItemICMSST )
   ::aItemICMSST[ "vBCSTDest" ] := hbNFe_PegaDadosXML("vBCSTDest", cItemICMSST )
   ::aItemICMSST[ "vICMSSTDest" ] := hbNFe_PegaDadosXML("vICMSSTDest", cItemICMSST )

   cItemICMSSN101 := hbNFe_PegaDadosXML('ICMSSN101', cItem )
   ::aItemICMSSN101 := hb_Hash()
   ::aItemICMSSN101[ "orig" ] := hbNFe_PegaDadosXML("orig", cItemICMSSN101 )
   ::aItemICMSSN101[ "CSOSN" ] := hbNFe_PegaDadosXML("CSOSN", cItemICMSSN101 )
   ::aItemICMSSN101[ "pCredSN" ] := hbNFe_PegaDadosXML("pCredSN", cItemICMSSN101 )
   ::aItemICMSSN101[ "vCredICMSSN" ] := hbNFe_PegaDadosXML("vCredICMSSN", cItemICMSSN101 )

   cItemICMSSN102 := hbNFe_PegaDadosXML('ICMSSN102', cItem ) //102,103,300 ou 400
   ::aItemICMSSN102 := hb_Hash()
   ::aItemICMSSN102[ "orig" ] := hbNFe_PegaDadosXML("orig", cItemICMSSN102 )
   ::aItemICMSSN102[ "CSOSN" ] := hbNFe_PegaDadosXML("CSOSN", cItemICMSSN102 )

   cItemICMSSN201 := hbNFe_PegaDadosXML('ICMSSN201', cItem )
   ::aItemICMSSN201 := hb_Hash()
   ::aItemICMSSN201[ "orig" ] := hbNFe_PegaDadosXML("orig", cItemICMSSN201 )
   ::aItemICMSSN201[ "CSOSN" ] := hbNFe_PegaDadosXML("CSOSN", cItemICMSSN201 )
   ::aItemICMSSN201[ "modBCST" ] := hbNFe_PegaDadosXML("modBCST", cItemICMSSN201 )
   ::aItemICMSSN201[ "pMVAST" ] := hbNFe_PegaDadosXML("pMVAST", cItemICMSSN201 )
   ::aItemICMSSN201[ "pRedBCST" ] := hbNFe_PegaDadosXML("pRedBCST", cItemICMSSN201 )
   ::aItemICMSSN201[ "vBCST" ] := hbNFe_PegaDadosXML("vBCST", cItemICMSSN201 )
   ::aItemICMSSN201[ "pICMSST" ] := hbNFe_PegaDadosXML("pICMSST", cItemICMSSN201 )
   ::aItemICMSSN201[ "vICMSST" ] := hbNFe_PegaDadosXML("vICMSST", cItemICMSSN201 )
   ::aItemICMSSN201[ "pCredSN" ] := hbNFe_PegaDadosXML("pCredSN", cItemICMSSN201 )
   ::aItemICMSSN201[ "vCredICMSSN" ] := hbNFe_PegaDadosXML("vCredICMSSN", cItemICMSSN201 )

   cItemICMSSN202 := hbNFe_PegaDadosXML('ICMSSN202', cItem )  // 202 ou 203
   ::aItemICMSSN202 := hb_Hash()
   ::aItemICMSSN202[ "orig" ] := hbNFe_PegaDadosXML("orig", cItemICMSSN202 )
   ::aItemICMSSN202[ "CSOSN" ] := hbNFe_PegaDadosXML("CSOSN", cItemICMSSN202 )
   ::aItemICMSSN202[ "modBCST" ] := hbNFe_PegaDadosXML("modBCST", cItemICMSSN202 )
   ::aItemICMSSN202[ "pMVAST" ] := hbNFe_PegaDadosXML("pMVAST", cItemICMSSN202 )
   ::aItemICMSSN202[ "pRedBCST" ] := hbNFe_PegaDadosXML("pRedBCST", cItemICMSSN202 )
   ::aItemICMSSN202[ "vBCST" ] := hbNFe_PegaDadosXML("vBCST", cItemICMSSN202 )
   ::aItemICMSSN202[ "pICMSST" ] := hbNFe_PegaDadosXML("pICMSST", cItemICMSSN202 )
   ::aItemICMSSN202[ "vICMSST" ] := hbNFe_PegaDadosXML("vICMSST", cItemICMSSN202 )

   cItemICMSSN500 := hbNFe_PegaDadosXML('ICMSSN500', cItem )
   ::aItemICMSSN500 := hb_Hash()
   ::aItemICMSSN500[ "orig" ] := hbNFe_PegaDadosXML("orig", cItemICMSSN500 )
   ::aItemICMSSN500[ "CSOSN" ] := hbNFe_PegaDadosXML("CSOSN", cItemICMSSN500 )
   ::aItemICMSSN500[ "vBCSTRet" ] := hbNFe_PegaDadosXML("vBCSTRet", cItemICMSSN500 )
   ::aItemICMSSN500[ "vICMSSTRet" ] := hbNFe_PegaDadosXML("vICMSSTRet", cItemICMSSN500 )

   cItemICMSSN900 := hbNFe_PegaDadosXML('ICMSSN900', cItem )
   ::aItemICMSSN900 := hb_Hash()
   ::aItemICMSSN900[ "orig" ] := hbNFe_PegaDadosXML("orig", cItemICMSSN900 )
   ::aItemICMSSN900[ "CSOSN" ] := hbNFe_PegaDadosXML("CSOSN", cItemICMSSN900 )
   ::aItemICMSSN900[ "modBC" ] := hbNFe_PegaDadosXML("modBC", cItemICMSSN900 )
   ::aItemICMSSN900[ "pRedBC" ] := hbNFe_PegaDadosXML("pRedBC", cItemICMSSN900 )
   ::aItemICMSSN900[ "vBC" ] := hbNFe_PegaDadosXML("vBC", cItemICMSSN900 )
   ::aItemICMSSN900[ "pICMS" ] := hbNFe_PegaDadosXML("pICMS", cItemICMSSN900 )
   ::aItemICMSSN900[ "vICMS" ] := hbNFe_PegaDadosXML("vICMS", cItemICMSSN900 )
   ::aItemICMSSN900[ "modBCST" ] := hbNFe_PegaDadosXML("modBCST", cItemICMSSN900 )
   ::aItemICMSSN900[ "pMVAST" ] := hbNFe_PegaDadosXML("pMVAST", cItemICMSSN900 )
   ::aItemICMSSN900[ "pRedBCST" ] := hbNFe_PegaDadosXML("pRedBCST", cItemICMSSN900 )
   ::aItemICMSSN900[ "vBCST" ] := hbNFe_PegaDadosXML("vBCST", cItemICMSSN900 )
   ::aItemICMSSN900[ "pICMSST" ] := hbNFe_PegaDadosXML("pICMSST", cItemICMSSN900 )
   ::aItemICMSSN900[ "vICMSST" ] := hbNFe_PegaDadosXML("vICMSST", cItemICMSSN900 )
   ::aItemICMSSN900[ "pCredSN" ] := hbNFe_PegaDadosXML("pCredSN", cItemICMSSN900 )
   ::aItemICMSSN900[ "vCredICMSSN" ] := hbNFe_PegaDadosXML("vCredICMSSN", cItemICMSSN900 )


   cItemIPI := hbNFe_PegaDadosXML('IPI', cItem )
   ::aItemIPI := hb_Hash()
   ::aItemIPI[ "clEnq" ] := hbNFe_PegaDadosXML("clEnq", cItemIPI )
   ::aItemIPI[ "CNPJProd" ] := hbNFe_PegaDadosXML("CNPJProd", cItemIPI )
   ::aItemIPI[ "cSelo" ] := hbNFe_PegaDadosXML("cSelo", cItemIPI )
   ::aItemIPI[ "qSelo" ] := hbNFe_PegaDadosXML("qSelo", cItemIPI )
   ::aItemIPI[ "cEnq" ] := hbNFe_PegaDadosXML("cEnq", cItemIPI )

   ::aItemIPI[ "CST" ] := hbNFe_PegaDadosXML("CST", cItemIPI )
   ::aItemIPI[ "vBC" ] := hbNFe_PegaDadosXML("vBC", cItemIPI )
   ::aItemIPI[ "pIPI" ] := hbNFe_PegaDadosXML("pIPI", cItemIPI )
   ::aItemIPI[ "qUnid" ] := hbNFe_PegaDadosXML("qUnid", cItemIPI )
   ::aItemIPI[ "vUnid" ] := hbNFe_PegaDadosXML("vUnid", cItemIPI )
   ::aItemIPI[ "vIPI" ] := hbNFe_PegaDadosXML("vIPI", cItemIPI )

   cItemII := hbNFe_PegaDadosXML('II', cItem )
   ::aItemII := hb_Hash()
   ::aItemII[ "vBC" ] := hbNFe_PegaDadosXML("vBC", cItemII )
   ::aItemII[ "vDespAdu" ] := hbNFe_PegaDadosXML("vDespAdu", cItemII )
   ::aItemII[ "vII" ] := hbNFe_PegaDadosXML("vII", cItemII )
   ::aItemII[ "vIOF" ] := hbNFe_PegaDadosXML("vIOF", cItemII )

   cItemPIS := hbNFe_PegaDadosXML('PIS', cItem )
   ::aItemPIS := hb_Hash()
   ::aItemPIS[ "CST" ] := hbNFe_PegaDadosXML("CST", cItemPIS )
   ::aItemPIS[ "vBC" ] := hbNFe_PegaDadosXML("vBC", cItemPIS )
   ::aItemPIS[ "pPIS" ] := hbNFe_PegaDadosXML("pPIS", cItemPIS )
   ::aItemPIS[ "vPIS" ] := hbNFe_PegaDadosXML("vPIS", cItemPIS )

   ::aItemPIS[ "qBCProd" ] := hbNFe_PegaDadosXML("qBCProd", cItemPIS )
   ::aItemPIS[ "vAliqProd" ] := hbNFe_PegaDadosXML("vAliqProd", cItemPIS )

   cItemPISST := hbNFe_PegaDadosXML('PISST', cItem )
   ::aItemPISST := hb_Hash()
   ::aItemPISST[ "vBC" ] := hbNFe_PegaDadosXML("vBC", cItemPISST )
   ::aItemPISST[ "pPIS" ] := hbNFe_PegaDadosXML("pPIS", cItemPISST )
   ::aItemPISST[ "vPIS" ] := hbNFe_PegaDadosXML("vPIS", cItemPISST )
   ::aItemPISST[ "qBCProd" ] := hbNFe_PegaDadosXML("qBCProd", cItemPISST )
   ::aItemPISST[ "vAliqProd" ] := hbNFe_PegaDadosXML("vAliqProd", cItemPISST )

   cItemCOFINS := hbNFe_PegaDadosXML('COFINS', cItem )
   ::aItemCOFINS := hb_Hash()
   ::aItemCOFINS[ "CST" ] := hbNFe_PegaDadosXML("CST", cItemCOFINS )
   ::aItemCOFINS[ "vBC" ] := hbNFe_PegaDadosXML("vBC", cItemCOFINS )
   ::aItemCOFINS[ "pCOFINS" ] := hbNFe_PegaDadosXML("pCOFINS", cItemCOFINS )
   ::aItemCOFINS[ "vCOFINS" ] := hbNFe_PegaDadosXML("vCOFINS", cItemCOFINS )

   ::aItemCOFINS[ "qBCProd" ] := hbNFe_PegaDadosXML("qBCProd", cItemCOFINS )
   ::aItemCOFINS[ "vAliqProd" ] := hbNFe_PegaDadosXML("vAliqProd", cItemCOFINS )

   cItemCOFINSST := hbNFe_PegaDadosXML('COFINSST', cItem )
   ::aItemCOFINSST := hb_Hash()
   ::aItemCOFINSST[ "vBC" ] := hbNFe_PegaDadosXML("vBC", cItemCOFINSST )
   ::aItemCOFINSST[ "pCOFINS" ] := hbNFe_PegaDadosXML("pCOFINS", cItemCOFINSST )
   ::aItemCOFINSST[ "vCOFINS" ] := hbNFe_PegaDadosXML("vCOFINS", cItemCOFINSST )
   ::aItemCOFINSST[ "qBCProd" ] := hbNFe_PegaDadosXML("qBCProd", cItemCOFINSST )
   ::aItemCOFINSST[ "vAliqProd" ] := hbNFe_PegaDadosXML("vAliqProd", cItemCOFINSST )

   cItemISSQN := hbNFe_PegaDadosXML('ISSQN', cItem )
   ::aItemISSQN := hb_Hash()
   ::aItemISSQN[ "vBC" ] := hbNFe_PegaDadosXML("vBC", cItemISSQN )
   ::aItemISSQN[ "vAliq" ] := hbNFe_PegaDadosXML("vAliq", cItemISSQN )
   ::aItemISSQN[ "vISSQN" ] := hbNFe_PegaDadosXML("vISSQN", cItemISSQN )
   ::aItemISSQN[ "cMunFG" ] := hbNFe_PegaDadosXML("cMunFG", cItemISSQN )
   ::aItemISSQN[ "cListServ" ] := hbNFe_PegaDadosXML("cListServ", cItemISSQN )
   ::aItemISSQN[ "cSitTrib" ] := hbNFe_PegaDadosXML("cSitTrib", cItemISSQN )  // N – NORMAL R – RETIDA S –SUBSTITUTA I – ISENTA. (v.2.0)

   RETURN NIL

FUNCTION hbNFe_PegaDadosXML(cElemento, cStringXML, cElemento2)

   LOCAL InicioDoDado,FinalDoDado,nPosIni,nPosFim, cRet := Nil

   IF cStringXML = NIL
      RETURN cRet
   ENDIF
   InicioDoDado := Iif( cElemento2 == Nil, "<" + cElemento + ">" , "<" + cElemento )
   FinalDoDado  := Iif( cElemento2 == Nil, "</" + cElemento + ">", '</' + cElemento2 + '>' )
   nPosIni      := At( InicioDoDado, cStringXML )
   nPosFim      := hb_At( FinalDoDado, cStringXML, nPosIni )

   IF nPosIni==0 .OR. nPosFim==0
      RETURN cRet
   ENDIF
   cRet := Substr( cStringXML, nPosIni + Len( IniciodoDado ), nPosFim - nPosIni - Len( FinalDoDado ) + 1 )

   RETURN cRet

FUNCTION hbNFe_Texto_Hpdf( oPdfPage2, x1, y1, x2, y2, cText, align, desconhecido, oFontePDF, nTamFonte, nAngulo )

   LOCAL nRadiano

   IF oFontePDF <> Nil
      HPDF_Page_SetFontAndSize( oPdfPage2, oFontePDF, nTamFonte )
   ENDIF
   IF x2 = Nil
      x2 := x1 - nTamFonte
   ENDIF
   HPDF_Page_BeginText( oPdfPage2 )
   IF nAngulo == Nil // horizontal normal
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
            checksum = mod( ( checksum + ( nI - 1 ) * nValorCar ) , 103 )
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
