/*
ZE_SPEDDANFE - Documento Auxiliar da Nota Fiscal Eletrônica
Fontes originais do projeto hbnfe em https://github.com/fernandoathayde/hbnfe
*/

#include "common.ch"
#include "hbclass.ch"
#include "harupdf.ch"
#ifndef __XHARBOUR__
   #include "hbwin.ch"
#endif

#define _LOGO_ESQUERDA         1
#define _LOGO_DIREITA          2
#define _LOGO_EXPANDIDO        3

#define LAYOUT_NAOIMPRIME      0
#define LAYOUT_IMPRIMENORMAL   1
#define LAYOUT_IMPRIMESEGUNDA  2

#define LAYOUT_TITULO          1
#define LAYOUT_LARGURA         2
#define LAYOUT_COLUNAPDF       3
#define LAYOUT_LARGURAPDF      4
#define LAYOUT_DECIMAIS        5
#define LAYOUT_TITULO1         6
#define LAYOUT_TITULO2         7
#define LAYOUT_CONTEUDO        8
#define LAYOUT_IMPRIME         9

#define LAYOUT_CODIGO          1
#define LAYOUT_DESCRICAO       2
#define LAYOUT_NCM             3
#define LAYOUT_CST             4
#define LAYOUT_CFOP            5
#define LAYOUT_UNIDADE         6
#define LAYOUT_QTD             7
#define LAYOUT_UNITARIO        8
#define LAYOUT_TOTAL           9
#define LAYOUT_DESCONTO        10
#define LAYOUT_ICMBAS          11
#define LAYOUT_ICMVAL          12
#define LAYOUT_SUBBAS          13
#define LAYOUT_SUBVAL          14
#define LAYOUT_IPIVAL          15
#define LAYOUT_ICMALI          16
#define LAYOUT_IPIALI          17

CREATE CLASS hbNFeDaNFe INHERIT hbNFeDaGeral

   METHOD Execute( cXmlNota, cFilePDF, cXmlCancel )
   METHOD BuscaDadosXML()
   METHOD GeraPDF( cFilePDF )
   METHOD NovaPagina()
   METHOD SaltaPagina()
   METHOD CabecalhoRetrato()
   METHOD Destinatario()
   METHOD Duplicatas()
   METHOD Faturas()
   METHOD CabecalhoCobranca( nLinhaFinalCob, nTamanhoCob )
   METHOD Canhoto()
   METHOD DadosImposto()
   METHOD DadosTransporte()
   METHOD CabecalhoProdutos()
   METHOD DesenhaBoxProdutos( nLinhaFinalProd, nAlturaQuadroProdutos )
   METHOD Produtos()
   METHOD TotalServico()
   METHOD DadosAdicionais()
   METHOD Rodape()
   METHOD ProcessaItens( cXml, nItem )
   METHOD CalculaLayout()
   METHOD ItensDaFolha( nFolha )
   METHOD Init()
   METHOD DrawTextoProduto( nCampo, nRow, nConteudo, nAlign )
   METHOD DrawBoxProduto( nCampo, nRow, nHeight )
   METHOD DefineColunasProdutos()

   VAR cTelefoneEmitente INIT ""
   VAR cSiteEmitente     INIT ""
   VAR cEmailEmitente    INIT ""
   VAR cDesenvolvedor    INIT ""
   VAR cXml
   VAR cXmlCancel        INIT ""
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

   VAR cFonteNFe  INIT "Times"
   VAR cFonteCode128            // Inserido por Anderson Camilo em 04/04/2012
   VAR cFonteCode128F           // Inserido por Anderson Camilo em 04/04/2012
   VAR oPdf
   VAR oPdfPage
   VAR oPdfFontCabecalho
   VAR oPdfFontCabecalhoBold
   VAR nLinhaPDF
   VAR nLarguraBox INIT 0.2
   VAR lLaser      INIT .T.
   VAR cLogoFile   INIT ""
   VAR nLogoStyle  INIT _LOGO_ESQUERDA
   VAR nFolha
   VAR cRetorno

   VAR nItensFolha
   VAR nLinhaFolha
   VAR nLayoutTotalFolhas
   VAR nLayoutFonteAltura  INIT 7
   VAR lLayoutEspacoDuplo  INIT .T.
   VAR aLayout

   ENDCLASS

METHOD Init() CLASS hbNFeDaNFe

   LOCAL oElement

   ::aLayout := Array(17)
   FOR EACH oElement IN ::aLayout
      oElement := Array(10)
      oElement[ LAYOUT_IMPRIME ]      := LAYOUT_IMPRIMENORMAL
      oElement[ LAYOUT_TITULO1 ]      := ""
      oElement[ LAYOUT_TITULO2 ]      := ""
      oElement[ LAYOUT_CONTEUDO ]     := { || "" }
      oElement[ LAYOUT_LARGURAPDF ]   := 1
   NEXT

   RETURN SELF

METHOD Execute( cXmlNota, cFilePDF, cXmlCancel ) CLASS hbNFeDaNFe

   IF Empty( cXmlNota )
      ::cRetorno := "XML sem conteúdo"
      RETURN ::cRetorno
   ENDIF
   IF ! Empty( cXmlCancel )
      ::cXmlCancel := cXmlCancel
   ENDIF

   ::cXML   := cXmlNota
   ::cChave := SubStr( ::cXML, At( "Id=", ::cXML ) + 3 + 4, 44 )

   IF ! ::BuscaDadosXML()
      RETURN ::cRetorno
   ENDIF

   IF ! ::geraPDF( cFilePDF )
      ::cRetorno := "Problema ao gerar o PDF"
      RETURN ::cRetorno
   ENDIF
   ::cRetorno := "OK"

   RETURN ::cRetorno

METHOD BuscaDadosXML() CLASS hbNFeDaNFe

   ::aIde := XmlToHash( XmlNode( ::cXml, "ide" ), { "cUF", "cNF", "natOp", "indPag", "mod", "serie", "nNF", "dhEmi", "dhSaiEnt", "tpNF", "cMunFG", "tpImp", "tpEmis", ;
             "cDV", "tpAmb", "finNFe", "procEmi", "verProc" } )
   IF Empty( ::aIde[ "dhEmi" ] ) // NFE 2.0
      ::aIde[ "dhEmi" ] := XmlNode( XmlNode( ::cXml, "ide" ), "dEmi" )
   ENDIF
   //IF Empty( ::aIde[ "dhSaiEnt" ] ) // NFE 2.0
   //   ::aIde[ "dhSaiEnt" ] := XmlNode( XmlNode( ::cXml, "ide" ), "dSaiEnt" )
   //ENDIF
   ::aEmit       := XmlToHash( XmlNode( ::cXml, "emit" ), { "CNPJ", "CPF", "xNome", "xFant", "xLgr", "nro", "xBairro", "cMun", "xMun", "UF", "CEP", "cPais", "xPais", ;
                    "fone", "IE", "IEST", "IM", "CNAE", "CRT", "fone" } )
   ::aDest       := XmlToHash( XmlNode( ::cXml, "dest" ), { "CNPJ", "CPF", "xNome", "xLgr", "nro", "xCpl", "xBairro", "cMun", "xMun", "UF", "CEP", "cPais", "xPais", "fone", "IE", "ISUF", "email" } )
   ::aRetirada   := XmlToHash( XmlNode( ::cXml, "retirada" ), { "CNPJ", "CPF", "xLgr", "nro", "xCpl", "xBairro", "cMun", "xMun", "UF" } )
   ::aEntrega    := XmlToHash( XmlNode( ::cXml, "entrega" ), { "CNPJ", "CPF", "xLgr", "nro", "xCpl", "xBairro", "cMun", "xMun", "UF" } )
   ::aICMSTotal  := XmlToHash( XmlNode( ::cXml, "ICMSTot" ), { "vBC", "vICMS", "vBCST", "vST", "vProd", "vFrete", "vSeg", "vDesc", "vII", "vIPI", "vPIS", "vCOFINS", "vOutro", "vNF" } )
   ::aISSTotal   := XmlToHash( XmlNode( ::cXml, "ISSQNtot" ), { "vServ", "vBC", "vISS", "vPIS", "vCOFINS" } )
   ::aRetTrib    := XmlToHash( XmlNode( ::cXml, "RetTrib" ), { "vRetPIS", "vRetCOFINS", "vRetCSLL", "vBCIRRF", "vIRRF", "vBCRetPrev", "vRetPrev" } )
   ::aTransp     := XmlToHash( XmlNode( ::cXml, "transp" ), { "modFrete", "CNPJ", "CPF", "xNome", "IE", "xEnder", "xMun", "UF", "qVol", "esp", "marca", "nVol", "pesoL", "pesoB", "nLacre" } )
   ::aVeicTransp := XmlToHash( XmlNode( XmlNode( ::cXml, "transp" ), "veicTransp" ), { "placa", "UF", "RNTC" } )
   ::aReboque    := XmlToHash( XmlNode( XmlNode( ::cXml, "reboque" ), "veicTransp" ), { "placa", "UF", "RNTC" } )
   ::cCobranca   := XmlNode( ::cXml, "cobr" )
   ::aInfAdic    := XmlToHash( XmlNode( ::cXml, "infAdic" ), { "infCpl" } )
   ::aObsCont    := XmlToHash( XmlNode( XmlNode( ::cXml, "infAdic" ), "obsCont" ), { "xCampo", "xTexto" } )
   ::aObsFisco   := XmlToHash( XmlNode( XmlNode( ::cXml, "infAdic" ), "obsFisco" ), { "xCampo", "xTexto" } )
   ::aExporta    := XmlToHash( XmlNode( XmlNode( ::cXml, "exporta" ), "infCpl" ), { "UFEmbarq", "xLocEmbarq" } )
   ::aCompra     := XmlToHash( XmlNode( ::cXml, "compra" ), { "xNEmp", "xPed", "xCont" } )
   ::aInfProt    := XmlToHash( iif( Empty( ::cXmlCancel ), ::cXml, ::cXmlCancel ), { "nProt", "dhRecbto", "digVal", "cStat", "xMotivo" } )

   ::aEmit[ "xNome" ]  := XmlToString( ::aEmit[ "xNome" ] )
   ::aDest[ "xNome" ]  := XmlToString( ::aDest[ "xNome" ] )
   ::cTelefoneEmitente := ::FormataTelefone( ::aEmit[ "fone" ] )
   ::aDest[ "fone" ]   := ::FormataTelefone( ::aDest[ "fone" ] )
   IF ! Empty( ::aEntrega[ "xLgr" ] )
      ::aInfAdic[ "infCpl" ] += ";" + TrimXml( "LOCAL DE ENTREGA: " + ::aEntrega[ "xLgr" ] + " " + ::aEntrega[ "nro" ] + " " + ;
         ::aEntrega[ "xBairro" ] + " " + ::aEntrega[ "xMun" ] + " " + ::aEntrega[ "UF" ] )
   ENDIF
   IF ! Empty( ::aRetirada[ "xLgr" ] )
      ::aInfAdic[ "infCpl" ] += ";" + TrimXml( "LOCAL DE RETIRADA: " + ::aRetirada[ "xLgr" ] + " " + ::aRetirada[ "nro" ] + " " + ;
         ::aRetirada[ "xBairro" ] + " " + ::aRetirada[ "xMun" ] + " " + ::aRetirada[ "UF" ] )
   ENDIF
   ::aInfAdic[ "infCpl" ] := StrTran( ::aInfAdic[ "infCpl" ], ";;", ";" )
   ::aInfAdic[ "infCpl" ] := StrTran( ::aInfAdic[ "infCpl" ], ";", Chr(13) + Chr(10) )

   RETURN .T.

METHOD GeraPDF( cFilePDF ) CLASS hbNFeDaNFe

   ::oPdf := HPDF_New()
   IF ::oPdf == NIL
      ::cRetorno := "Falha da criação do objeto PDF"
      RETURN .F.
   ENDIF
   HPDF_SetCompressionMode( ::oPdf, HPDF_COMP_ALL )
   IF ::cFonteNFe == "Times"
      ::oPdfFontCabecalho     := HPDF_GetFont( ::oPdf, "Times-Roman", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Times-Bold", "CP1252" )
   ELSE
      ::oPdfFontCabecalho     := HPDF_GetFont( ::oPdf, "Courier", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Courier-Bold", "CP1252" )
   ENDIF

#ifdef __XHARBOUR__
   IF ! File( "fontes\Code128bWinLarge.afm" ) .OR. ! File( "fontes\Code128bWinLarge.pfb" )
      ::cRetorno := "Arquivos fontes\Code128bWinLarge, nao encontrados...!"
      RETURN .F.
   ENDIF
   ::cFonteCode128  := HPDF_LoadType1FontFromFile( ::oPdf, "fontes\Code128bWinLarge.afm", "fontes\Code128bWinLarge.pfb" )   // Code 128
   ::cFonteCode128F := HPDF_GetFont( ::oPdf, ::cFonteCode128, "WinAnsiEncoding" )
#endif

   ::nFolha := 1
   ::NovaPagina()

   // Atenção: destas duas linhas depende todo layout
   HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalho, ::nLayoutFonteAltura )
   ::CalculaLayout()

   ::canhoto()
   ::CabecalhoRetrato()
   ::Destinatario()
   ::Duplicatas()
   ::DadosImposto()
   ::DadosTransporte()
   ::CabecalhoProdutos()

   ::Produtos()

   ::TotalServico()
   ::DadosAdicionais()
   ::Rodape()

   HPDF_SaveToFile( ::oPdf, cFilePDF )
   HPDF_Free( ::oPdf )

   RETURN .T.

METHOD NovaPagina() CLASS hbNFeDaNFe

   LOCAL nRadiano, nAltura, nAngulo

   ::oPdfPage := HPDF_AddPage( ::oPdf )
   HPDF_Page_SetSize( ::oPdfPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT )
   nAltura := HPDF_Page_GetHeight( ::oPdfPage )

   ::nLinhaPdf := nAltura - 8                    // Margem Superior
   nAngulo     := 45                             // A rotation of 45 degrees
   nRadiano    := nAngulo / 180 * 3.141592       // Calcurate the radian value

   IF ::aIde[ "tpEmis" ] = "5" // Contingencia
      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText( ::oPdfPage )
      HPDF_Page_SetTextMatrix( ::oPdfPage, Cos( nRadiano ), Sin( nRadiano ), -Sin( nRadiano ), Cos( nRadiano ), 15, 160 )
      HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
      HPDF_Page_ShowText( ::oPdfPage, "DANFE EM CONTINGÊNCIA. IMPRESSO EM" )
      HPDF_Page_EndText( ::oPdfPage )

      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText( ::oPdfPage )
      HPDF_Page_SetTextMatrix( ::oPdfPage, Cos( nRadiano ), Sin( nRadiano ), -Sin( nRadiano ), Cos( nRadiano ), 15, 130 )
      HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
      HPDF_Page_ShowText( ::oPdfPage, "DECORRÊNCIA DE PROBLEMAS TÉCNICOS." )
      HPDF_Page_EndText( ::oPdfPage )

      HPDF_Page_SetRGBFill( ::oPdfPage, 0, 0, 0 ) // reseta cor fontes
   ENDIF

   IF ::aIde[ "tpEmis" ] == "4" // DEPEC
      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText( ::oPdfPage )
      HPDF_Page_SetTextMatrix( ::oPdfPage, Cos( nRadiano ), Sin( nRadiano ), -Sin( nRadiano ), Cos( nRadiano ), 15, 190 )
      HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
      HPDF_Page_ShowText( ::oPdfPage, "DANFE IMPRESSO EM CONTINGÊNCIA - DEPEC" )
      HPDF_Page_EndText( ::oPdfPage )

      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText( ::oPdfPage )
      HPDF_Page_SetTextMatrix( ::oPdfPage, Cos( nRadiano ), Sin( nRadiano ), -Sin( nRadiano ), Cos( nRadiano ), 15, 160 )
      HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
      HPDF_Page_ShowText( ::oPdfPage, "REGULARMENTE RECEBIDO PELA RECEITA" )
      HPDF_Page_EndText( ::oPdfPage )

      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText( ::oPdfPage )
      HPDF_Page_SetTextMatrix( ::oPdfPage, Cos( nRadiano ), Sin( nRadiano ), -Sin( nRadiano ), Cos( nRadiano ), 15, 130 )
      HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
      HPDF_Page_ShowText( ::oPdfPage, "FEDERAL DO BRASIL." )
      HPDF_Page_EndText( ::oPdfPage )

      HPDF_Page_SetRGBFill( ::oPdfPage, 0, 0, 0 ) // reseta cor fontes
   ENDIF

   IF ::aIde[ "tpAmb" ] == "2"

      IF ::aInfProt[ "cStat" ] == '101'
         HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
         HPDF_Page_BeginText( ::oPdfPage )
         HPDF_Page_SetTextMatrix( ::oPdfPage, cos( nRadiano ), sin( nRadiano ), -sin( nRadiano ), cos( nRadiano ), 15, 150 )
         HPDF_Page_SetRGBFill( ::oPdfPage, 1, 0, 0 )
         HPDF_Page_ShowText( ::oPdfPage, ::aInfProt[ "xMotivo" ] )
         HPDF_Page_EndText( ::oPdfPage )
      ENDIF

      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText( ::oPdfPage )
      HPDF_Page_SetTextMatrix( ::oPdfPage, Cos( nRadiano ), Sin( nRadiano ), -Sin( nRadiano ), Cos( nRadiano ), 15, 100 )
      HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
      HPDF_Page_ShowText( ::oPdfPage, "AMBIENTE DE HOMOLOGAÇÃO - SEM VALOR FISCAL" )
      HPDF_Page_EndText( ::oPdfPage )

      HPDF_Page_SetRGBStroke( ::oPdfPage, 0.75, 0.75, 0.75 )
      ::DrawLine( 15, 95, 550, 630, 2.0 )

      HPDF_Page_SetRGBStroke( ::oPdfPage, 0, 0, 0 ) // reseta cor linhas

      HPDF_Page_SetRGBFill( ::oPdfPage, 0, 0, 0 ) // reseta cor fontes
   ENDIF

   IF ::aIde[ "tpAmb" ] == "1"

      IF ::aInfProt[ "cStat" ] $ "101,135,302"

         HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
         HPDF_Page_BeginText( ::oPdfPage )
         HPDF_Page_SetTextMatrix( ::oPdfPage, cos( nRadiano ), sin( nRadiano ), -sin( nRadiano ), cos( nRadiano ), 15, 100)
         HPDF_Page_SetRGBFill(::oPdfPage, 1, 0, 0)
         HPDF_Page_ShowText( ::oPdfPage, ::aInfProt[ "xMotivo" ] )
         HPDF_Page_EndText( ::oPdfPage)

         HPDF_Page_SetRGBStroke( ::oPdfPage, 0.75, 0.75, 0.75 )
         ::DrawLine( 15, 95, 550, 630, 2.0 )

         HPDF_Page_SetRGBStroke( ::oPdfPage, 0, 0, 0 ) // reseta cor linhas

         HPDF_Page_SetRGBFill( ::oPdfPage, 0, 0, 0) // reseta cor fontes

      ENDIF

   ENDIF

   RETURN NIL

METHOD SaltaPagina() CLASS hbNFeDaNFe

   LOCAL nLinhaFinalProd, nAlturaQuadroProdutos

   ::nLinhaPdf -= 2
   ::totalServico()
   ::dadosAdicionais()
   ::rodape()
   ::novaPagina()
   ::nFolha++
   ::nLinhaFolha := 1
   ::canhoto()
   ::CabecalhoRetrato()
   ::cabecalhoProdutos()
   nLinhaFinalProd       := ::nLinhaPdf - ( ::ItensDaFolha() * ::nLayoutFonteAltura ) - 2
   nAlturaQuadroProdutos := ( ::ItensDaFolha() * ::nLayoutFonteAltura ) + 2
   ::desenhaBoxProdutos( nLinhaFinalProd, nAlturaQuadroProdutos )

   RETURN NIL

METHOD Canhoto() CLASS hbNFeDaNFe

   IF ::nFolha != 1
      ::nLinhaPdf -= 18
      ::nLinhaPdf -= 24
      ::nLinhaPdf -= 10
      RETURN NIL
   ENDIF
   ::DrawBox( 5, ::nLinhaPdf - 44, 585, 44, ::nLarguraBox )

   ::DrawTexto( 6, ::nLinhaPdf, 490, NIL, "Recebemos de " + ::aEmit[ "xNome" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
   ::DrawTexto( 6, ::nLinhaPdf - 7, 490, NIL, "os produtos constantes da Nota Fiscal indicada ao lado", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )

   ::DrawBox( 505, ::nLinhaPdf - 44, 85, 44, ::nLarguraBox )
   ::DrawTexto( 506, ::nLinhaPdf - 8, 589, NIL, "NF-e", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
   ::DrawTexto( 506, ::nLinhaPdf - 20, 589, NIL, "Nº: " + Transform( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), "@R 999.999.999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
   ::DrawTexto( 506, ::nLinhaPdf - 32, 589, NIL, "SÉRIE " + ::aIde[ "serie" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
   ::nLinhaPdf -= 18

   ::DrawBox( 5, ::nLinhaPdf - 26, 130, 26, ::nLarguraBox )
   ::DrawTexto( 6, ::nLinhaPdf, 134, NIL, "DATA DE RECEBIMENTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )

   ::DrawBox( 135, ::nLinhaPdf - 26, 370, 26, ::nLarguraBox )
   ::DrawTexto( 136, ::nLinhaPdf, 470, NIL, "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
   ::nLinhaPdf -= 24

   // corte
   IF ::cFonteNFe == "Times"
      ::DrawTexto( 5, ::nLinhaPdf, 590, NIL, Replicate( "- ", 125 ), HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )
   ELSE
      ::DrawTexto( 5, ::nLinhaPdf - 2, 590, NIL, Replicate( "- ", 81 ), HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
   ENDIF
   ::nLinhaPdf -= 10

   RETURN NIL

METHOD CabecalhoRetrato() CLASS hbNFeDaNFe

   ::DrawBox( 5, ::nLinhaPdf - 80, 585, 80, ::nLarguraBox )
   // logo/dados empresa
   ::DrawBox( 5, ::nLinhaPdf - 80, 240, 80, ::nLarguraBox )
   ::DrawTexto( 6, ::nLinhaPdf, 244, NIL, "IDENTIFICAÇÃO DO EMITENTE", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
   IF ::cLogoFile == NIL .OR. Empty( ::cLogoFile )
      ::DrawTexto( 6, ::nLinhaPdf - 6, 244, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
      ::DrawTexto( 6, ::nLinhaPdf - 18, 244, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 2 ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
      ::DrawTexto( 6, ::nLinhaPdf - 30, 244, NIL, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ::DrawTexto( 6, ::nLinhaPdf - 38, 244, NIL, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ::DrawTexto( 6, ::nLinhaPdf - 46, 244, NIL, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ::DrawTexto( 6, ::nLinhaPdf - 54, 244, NIL, iif( Empty( ::cTelefoneEmitente ), "", "FONE: " + ::cTelefoneEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ::DrawTexto( 6, ::nLinhaPdf - 62, 244, NIL, Trim( ::cSiteEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ::DrawTexto( 6, ::nLinhaPdf - 70, 244, NIL, Trim( ::cEmailEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
   ELSE
      IF ::nLogoStyle == _LOGO_EXPANDIDO
         ::DrawJPEGImage( ::cLogoFile, 6, ::nLinhaPdf - ( 72 + 6 ), 238, 72 )
      ELSEIF ::nLogoStyle == _LOGO_ESQUERDA
         ::DrawJPEGImage( ::cLogoFile, 6, ::nLinhaPdf - ( 72 + 6 ), 62, 72 )
         ::DrawTexto( 70, ::nLinhaPdf - 6, 244, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
         ::DrawTexto( 70, ::nLinhaPdf - 30, 244, NIL, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 70, ::nLinhaPdf - 38, 244, NIL, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 70, ::nLinhaPdf - 46, 244, NIL, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 70, ::nLinhaPdf - 54, 244, NIL, iif( Empty( ::cTelefoneEmitente ), "", "FONE: " + ::cTelefoneEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 70, ::nLinhaPdf - 62, 244, NIL, Trim( ::cSiteEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 70, ::nLinhaPdf - 70, 244, NIL, Trim( ::cEmailEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ELSEIF ::nLogoStyle == _LOGO_DIREITA
         ::DrawJPEGImage( ::cLogoFile, 182, ::nLinhaPdf - ( 72 + 6 ), 62, 72 )
         ::DrawTexto( 6, ::nLinhaPdf - 6, 180, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
         ::DrawTexto( 6, ::nLinhaPdf - 18, 180, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 2 ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
         ::DrawTexto( 6, ::nLinhaPdf - 30, 180, NIL, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 6, ::nLinhaPdf - 38, 180, NIL, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 6, ::nLinhaPdf - 46, 180, NIL, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 6, ::nLinhaPdf - 54, 180, NIL, iif( Empty( ::cTelefoneEmitente ), "", "FONE: " + ::cTelefoneEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 6, ::nLinhaPdf - 62, 180, NIL, Trim( ::cSiteEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 6, ::nLinhaPdf - 70, 180, NIL, Trim( ::cEmailEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ENDIF
   ENDIF

   ::DrawBox( 245, ::nLinhaPdf - 80, 125, 80, ::nLarguraBox )
   ::DrawTexto( 246, ::nLinhaPdf - 4, 369, NIL, "DANFE", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
   ::DrawTexto( 246, ::nLinhaPdf - 16, 369, NIL, "Documento Auxiliar da", HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
   ::DrawTexto( 246, ::nLinhaPdf - 24, 369, NIL, "Nota Fiscal Eletrônica", HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )

   ::DrawTexto( 256, ::nLinhaPdf - 36, 349, NIL, "0 - ENTRADA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )
   ::DrawTexto( 256, ::nLinhaPdf - 44, 349, NIL, "1 - SAÍDA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )
   // preenchimento do tipo de nf
   ::DrawBox( 340, ::nLinhaPdf - 52, 20, 16, ::nLarguraBox )
   ::DrawTexto( 341, ::nLinhaPdf - 40, 359, NIL, ::aIde[ "tpNF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )

   ::DrawTexto( 246, ::nLinhaPdf - 56, 369, NIL, "Nº: " + Transform( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), "@R 999.999.999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 10 )
   ::DrawTexto( 246, ::nLinhaPdf - 66, 369, NIL, "SÉRIE: " + ::aIde[ "serie" ] + " - FOLHA " + AllTrim( Str( ::nFolha ) ) + "/" + AllTrim( Str( ::nLayoutTotalFolhas ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 9 )

   // codigo barras
   ::DrawBox( 370, ::nLinhaPdf - 35, 220, 35, ::nLarguraBox )
#ifdef __XHARBOUR__
   // Modificado por Anderson Camilo em 04/04/2012
   // oCode128 := HPDF_LoadType1FontFromFile(::oPdf, 'fontes\Code128bWin.afm', 'fontes\Code128bWin.pfb')
   // oCode128F := HPDF_GetFont( ::oPdf, oCode128, "FontSpecific" )
   // ::DrawTexto( 380, ::nLinhaPdf - 8, 585, NIL, "{"+::cChave+"~", HPDF_TALIGN_CENTER, NIL, oCode128F, 8 )
   // ::DrawTexto( 380, ::nLinhaPdf - 18.2, 585, NIL, "{"+::cChave+"~", HPDF_TALIGN_CENTER, NIL, oCode128F, 8 )

   ::DrawTexto( 380, ::nLinhaPdf - 2, 585, NIL, ::xHarbourCode128c( ::cChave ), HPDF_TALIGN_CENTER, NIL, ::cFonteCode128F, 15 )

#else
   ::DrawBarcode128( ::cChave, 385, ::nLinhaPdf - 32, 0.7, 30 )
#endif

   // chave de acesso
   ::DrawBox( 370, ::nLinhaPdf - 55, 220, 55, ::nLarguraBox )
   ::DrawTexto( 371, ::nLinhaPdf - 36, 589, NIL, "CHAVE DE ACESSO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
   IF ::cFonteNFe == "Times"
      ::DrawTexto( 371, ::nLinhaPdf - 44, 589, NIL, Transform( ::cChave, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
   ELSE
      ::DrawTexto( 371, ::nLinhaPdf - 44, 589, NIL, Transform( ::cChave, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 6 )
   ENDIF
   // mensagem sistema sefaz
   ::DrawBox( 370, ::nLinhaPdf - 80, 220, 80, ::nLarguraBox )
   IF Empty( ::aInfProt[ "nProt" ] )
      ::DrawTexto( 371, ::nLinhaPdf - 55, 589, NIL, "N F E   A I N D A   N Ã O   F O I", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
      ::DrawTexto( 371, ::nLinhaPdf - 63, 589, NIL, "A U T O R I Z A D A   P E L A", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
      ::DrawTexto( 371, ::nLinhaPdf - 71, 589, NIL, "S E F A Z   (SEM VALIDADE FISCAL)", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
   ELSE
      ::DrawTexto( 371, ::nLinhaPdf - 55, 589, NIL, "Consulta de autenticidade no portal nacional", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
      ::DrawTexto( 371, ::nLinhaPdf - 63, 589, NIL, "da NF-e www.nfe.fazenda.gov.br/portal ou", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
      ::DrawTexto( 371, ::nLinhaPdf - 71, 589, NIL, "no site da Sefaz Autorizadora", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
   ENDIF

   ::nLinhaPdf -= 80

   ::DrawBox( 5, ::nLinhaPdf - 16, 365, 16, ::nLarguraBox )
   ::DrawTexto( 6, ::nLinhaPdf - 1,  369, NIL, "NATUREZA DA OPERAÇÃO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 6, ::nLinhaPdf - 5, 369, NIL, ::aIde[ "natOp" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
   // PROTOCOLO
   ::DrawBox( 370, ::nLinhaPdf - 16, 220, 16, ::nLarguraBox )

   // ::DrawTexto(371, ::nLinhaPdf - 1, 589, NIL, "PROTOCOLO DE AUTORIZAÇÃO DE USO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   IF ! Empty( ::aInfProt[ "nProt" ] )

      IF ::aInfProt[ "cStat" ] == '100'
         ::DrawTexto( 371, ::nLinhaPdf - 1, 589, NIL, "PROTOCOLO DE AUTORIZAÇÃO DE USO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ELSEIF ::aInfProt[ "cStat" ] == '101' .OR. ::aInfProt[ "cStat" ] == '135'
         ::DrawTexto( 371, ::nLinhaPdf - 1, 589, NIL, "PROTOCOLO DE HOMOLOGAÇÃO DO CANCELAMENTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ENDIF

      IF ::cFonteNFe == "Times"
         ::DrawTexto( 371, ::nLinhaPdf - 6, 589, NIL, ::aInfProt[ "nProt" ] + " " + SubStr( SubStr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 9, 2 ) + "/" + SubStr( SubStr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 6, 2 ) + "/" + SubStr( SubStr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 1, 4 ) + " " + SubStr( ::aInfProt[ "dhRecbto" ], 12, 8 ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 9 )
      ELSE
         ::DrawTexto( 371, ::nLinhaPdf - 6, 589, NIL, ::aInfProt[ "nProt" ] + " " + SubStr( SubStr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 9, 2 ) + "/" + SubStr( SubStr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 6, 2 ) + "/" + SubStr( SubStr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 1, 4 ) + " " + SubStr( ::aInfProt[ "dhRecbto" ], 12, 8 ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 9 )
      ENDIF
   ENDIF

   ::nLinhaPdf -= 16

   ::DrawBox( 5, ::nLinhaPdf - 16, 240, 16, ::nLarguraBox )
   ::DrawTexto( 6, ::nLinhaPdf - 1,  244, NIL, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 6, ::nLinhaPdf - 5, 244, NIL, ::aEmit[ "IE" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )

   ::DrawBox( 245, ::nLinhaPdf - 16, 225, 16, ::nLarguraBox )
   ::DrawTexto( 246, ::nLinhaPdf - 1,  419, NIL, "INSCRIÇÃO ESTADUAL DO SUBS. TRIBUTÁRIO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 246, ::nLinhaPdf - 5, 419, NIL, "", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )

   ::DrawBox( 470, ::nLinhaPdf - 16, 120, 16, ::nLarguraBox )
   ::DrawTexto( 471, ::nLinhaPdf - 1,  589, NIL, "C.N.P.J.", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 471, ::nLinhaPdf - 5, 589, NIL, Transform( ::aEmit[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )

   ::nLinhaPdf -= 17

   RETURN NIL

METHOD Destinatario() CLASS hbNFeDaNFe

   ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "DESTINATÁRIO/REMETENTE", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )

   ::nLinhaPdf -= 6

   ::DrawBox( 5, ::nLinhaPdf - 16, 415, 16, ::nLarguraBox )
   ::DrawTexto( 6, ::nLinhaPdf - 1,  419, NIL, "NOME / RAZÃO SOCIAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 6, ::nLinhaPdf - 5, 419, NIL, ::aDest[ "xNome" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )

   ::DrawBox( 420, ::nLinhaPdf - 16, 100, 16, ::nLarguraBox )
   ::DrawTexto( 421, ::nLinhaPdf - 1,  519, NIL, "CNPJ/CPF", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   IF !Empty( ::aDest[ "CNPJ" ] )
      ::DrawTexto( 421, ::nLinhaPdf - 5, 519, NIL, Transform( ::aDest[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 9 )
   ELSE
      IF ! Empty( ::aDest[ "CPF" ] )
         ::DrawTexto( 421, ::nLinhaPdf - 5, 519, NIL, Transform( ::aDest[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
      ENDIF
   ENDIF

   ::DrawBox( 520, ::nLinhaPdf - 16, 70, 16, ::nLarguraBox )
   ::DrawTexto( 521, ::nLinhaPdf - 1,  589, NIL, "DATA DE EMISSÃO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 521, ::nLinhaPdf - 5, 589, NIL, SubStr( ::aIde[ "dhEmi" ], 9, 2 ) + "/" + SubStr( ::aIde[ "dhEmi" ], 6, 2 ) + "/" + SubStr( ::aIde[ "dhEmi" ], 1, 4 ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

   ::nLinhaPdf -= 16

   ::DrawBox( 5, ::nLinhaPdf - 16, 265, 16, ::nLarguraBox )
   ::DrawTexto( 6, ::nLinhaPdf - 1,  269, NIL, "ENDEREÇO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 6, ::nLinhaPdf - 5, 269, NIL, ::aDest[ "xLgr" ] + " " + ::aDest[ "nro" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )

   ::DrawBox( 270, ::nLinhaPdf - 16, 190, 16, ::nLarguraBox )
   ::DrawTexto( 271, ::nLinhaPdf - 1,  459, NIL, "BAIRRO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 271, ::nLinhaPdf - 5, 459, NIL, ::aDest[ "xBairro" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )

   ::DrawBox( 460, ::nLinhaPdf - 16, 60, 16, ::nLarguraBox )
   ::DrawTexto( 461, ::nLinhaPdf - 1,  519, NIL, "C.E.P.", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 461, ::nLinhaPdf - 5, 519, NIL, Transform( ::aDest[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

   ::DrawBox( 520, ::nLinhaPdf - 16, 70, 16, ::nLarguraBox )
   ::DrawTexto( 521, ::nLinhaPdf - 1,  589, NIL, "DATA SAIDA/ENTRADA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 521, ::nLinhaPdf - 5, 589, NIL, SubStr( ::aIde[ "dhSaiEnt" ], 9, 2 ) + "/" + SubStr( ::aIde[ "dhSaiEnt" ], 6, 2 ) + "/" + SubStr( ::aIde[ "dhSaiEnt" ], 1, 4 ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

   ::nLinhaPdf -= 16

   ::DrawBox( 5, ::nLinhaPdf - 16, 245, 16, ::nLarguraBox )
   ::DrawTexto( 6, ::nLinhaPdf - 1,  249, NIL, "MUNICIPIO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 6, ::nLinhaPdf - 5, 249, NIL, ::aDest[ "xMun" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )

   ::DrawBox( 250, ::nLinhaPdf - 16, 150, 16, ::nLarguraBox )
   ::DrawTexto( 251, ::nLinhaPdf - 1,  399, NIL, "FONE/FAX", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 251, ::nLinhaPdf - 5, 399, NIL, ::FormataTelefone( ::aDest[ "fone" ] ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

   ::DrawBox( 400, ::nLinhaPdf - 16, 30, 16, ::nLarguraBox )
   ::DrawTexto( 401, ::nLinhaPdf - 1,  429, NIL, "ESTADO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 401, ::nLinhaPdf - 5, 429, NIL, ::aDest[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

   ::DrawBox( 430, ::nLinhaPdf - 16, 90, 16, ::nLarguraBox )
   ::DrawTexto( 431, ::nLinhaPdf - 1,  519, NIL, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 431, ::nLinhaPdf - 5, 519, NIL, ::aDest[ "IE" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

   ::DrawBox( 520, ::nLinhaPdf - 16, 70, 16, ::nLarguraBox )
   ::DrawTexto( 521, ::nLinhaPdf - 1,  589, NIL, "HORA DE SAIDA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 521, ::nLinhaPdf - 5, 589, NIL, SubStr( ::aIde[ "dhSaiEnt" ], 12, 8 ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

   ::nLinhaPdf -= 17

   RETURN NIL

METHOD Duplicatas() CLASS hbNFeDaNFe

   LOCAL nICob, nItensCob, nLinhaFinalCob, nTamanhoCob

   IF ::nFolha == 1
      ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "FATURA/DUPLICATAS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )
      ::nLinhaPdf -= 6

      IF Empty( ::cCobranca )
         ::DrawBox( 5, ::nLinhaPdf - 12, 585, 12, ::nLarguraBox )
         IF ::aIde[ "indPag" ] == "0"
            ::DrawTexto( 6, ::nLinhaPdf - 1,  589, NIL, "PAGAMENTO À VISTA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
         ELSEIF ::aIde[ "indPag" ] == "1"
            ::DrawTexto( 6, ::nLinhaPdf - 1,  589, NIL, "PAGAMENTO À PRAZO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
         ELSE
            ::DrawTexto( 6, ::nLinhaPdf - 1,  589, NIL, "OUTROS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
         ENDIF
         ::nLinhaPdf -= 13
      ELSE
         nICob := Len( MultipleNodeToArray( ::cCobranca, "dup" ) )
         IF nICob < 1
            nICob := 1
         ENDIF
         nItensCob      := Round( nIcob / 3 + 0.99, 0 )
         nLinhaFinalCob := ::nLinhaPdf - ( nItensCob * 7 ) - 2
         nTamanhoCob    := ( nItensCob * 7 ) + 2
         ::CabecalhoCobranca( nLinhaFinalCob, nTamanhoCob )
         ::Faturas()
         ::nLinhaPdf -= 8
      ENDIF
   ENDIF

   RETURN NIL

METHOD CabecalhoCobranca( nLinhaFinalCob, nTamanhoCob ) CLASS hbNFeDaNFe

   LOCAL nTamForm, nCont

   IF ::nFolha == 1
      nTamForm := 585
      FOR nCont = 0 TO 2
         ::DrawBox( 5 + ( ( ( nTamForm ) / 3 ) * nCont ), nLinhaFinalCob, ( ( nTamForm ) / 3 ), nTamanhoCob, ::nLarguraBox )
         ::DrawTexto( 6 + ( ( ( nTamForm ) / 3 ) * nCont ), ::nLinhaPdf - 1,  61 + ( ( ( nTamForm ) / 3 ) * nCont ), NIL, "NÚMERO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 63 + ( ( ( nTamForm ) / 3 ) * nCont ), ::nLinhaPdf - 1, 118 + ( ( ( nTamForm ) / 3 ) * nCont ), NIL, "VENCIMENTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 120 + ( ( ( nTamForm ) / 3 ) * nCont ), ::nLinhaPdf - 1, 195 + ( ( ( nTamForm ) / 3 ) * nCont ), NIL, "VALOR", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
      NEXT
      ::nLinhaPdf -= 6
      FOR nCont = 0 TO 2
         ::DrawLine( 6 + ( ( ( nTamForm ) / 3 ) * nCont ), ::nLinhaPdf - 1.5,  61 + ( ( ( nTamForm ) / 3 ) * nCont ), ::nLinhaPdf - 1.5, ::nLarguraBox )
         ::DrawLine( 63 + ( ( ( nTamForm ) / 3 ) * nCont ), ::nLinhaPdf - 1.5, 118 + ( ( ( nTamForm ) / 3 ) * nCont ), ::nLinhaPdf - 1.5, ::nLarguraBox )
         ::Drawline( 120 + ( ( ( nTamForm ) / 3 ) * nCont ), ::nLinhaPdf - 1.5, 195 + ( ( ( nTamForm ) / 3 ) * nCont ), ::nLinhaPdf - 1.5, ::nLarguraBox )
      NEXT
      ::nLinhaPdf -= 2
   ENDIF

   RETURN NIL

METHOD Faturas() CLASS hbNFeDaNFe

   LOCAL nTamForm, aDups, nColuna, cDup, cNumero, cVencimento, cValor

   IF ::nFolha == 1
      nTamForm := 585
      aDups    := MultipleNodeToArray( ::cCobranca, "dup" )
      nColuna  := 1
      FOR EACH cDup IN aDups
         cNumero := XmlNode( cDup, "nDup" )
         IF Empty( cNumero )
            EXIT
         ENDIF
         cVencimento := XmlNode( cDup, "dVenc" )
         cVencimento := SubStr( cVencimento, 9, 2 ) + "/" + SubStr( cVencimento, 6, 2 ) + "/" + SubStr( cVencimento, 1, 4 )
         cValor      := AllTrim( FormatNumber( Val( XmlNode( cDup, "vDup" ) ), 13, 2 ) )
         ::DrawTexto( 6 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), ::nLinhaPdf - 1,  61 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), NIL, cNumero, HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 63 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), ::nLinhaPdf - 1, 118 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), NIL, cVencimento, HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 120 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), ::nLinhaPdf - 1, 195 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), NIL, cValor, HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 6 )
         nColuna++
         IF nColuna > 3
            ::nLinhaPdf -= 7
            nColuna := 1
         ENDIF
      NEXT
      ::nLinhaPdf -= 7

   ENDIF

   RETURN NIL

METHOD DadosImposto() CLASS hbNFeDaNFe

   IF ::nFolha == 1
      ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "CÁLCULO DO IMPOSTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )

      ::nLinhaPdf -= 6

      ::DrawBox( 5, ::nLinhaPdf - 16, 110, 16, ::nLarguraBox )
      ::DrawTexto( 6, ::nLinhaPdf - 1,  114, NIL, "BASE DE CÁLCULO DO ICMS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 6, ::nLinhaPdf - 5, 114, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vBC" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

      ::DrawBox( 115, ::nLinhaPdf - 16, 100, 16, ::nLarguraBox )
      ::DrawTexto( 116, ::nLinhaPdf - 1,  214, NIL, "VALOR DO ICMS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 116, ::nLinhaPdf - 5, 214, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vICMS" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

      ::DrawBox( 215, ::nLinhaPdf - 16, 130, 16, ::nLarguraBox )
      ::DrawTexto( 216, ::nLinhaPdf - 1,  344, NIL, "BASE DE CÁLCULO DO ICMS SUBS. TRIB.", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 216, ::nLinhaPdf - 5, 344, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vBCST" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

      ::DrawBox( 345, ::nLinhaPdf - 16, 100, 16, ::nLarguraBox )
      ::DrawTexto( 346, ::nLinhaPdf - 1,  444, NIL, "VALOR DO ICMS SUBST.", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 346, ::nLinhaPdf - 5, 444, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vST" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

      ::DrawBox( 445, ::nLinhaPdf - 16, 145, 16, ::nLarguraBox )
      ::DrawTexto( 446, ::nLinhaPdf - 1,  589, NIL, "VALOR TOTAL DOS PRODUTOS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 446, ::nLinhaPdf - 5, 589, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vProd" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 16

      ::DrawBox( 5, ::nLinhaPdf - 16, 88, 16, ::nLarguraBox )
      ::DrawTexto( 6, ::nLinhaPdf - 1,  92, NIL, "VALOR DO FRETE", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 6, ::nLinhaPdf - 5, 92, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vFrete" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

      ::DrawBox( 93, ::nLinhaPdf - 16, 88, 16, ::nLarguraBox )
      ::DrawTexto( 94, ::nLinhaPdf - 1,  180, NIL, "VALOR DO SEGURO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 94, ::nLinhaPdf - 5, 180, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vSeg" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

      ::DrawBox( 181, ::nLinhaPdf - 16, 88, 16, ::nLarguraBox )
      ::DrawTexto( 182, ::nLinhaPdf - 1,  268, NIL, "DESCONTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 182, ::nLinhaPdf - 5, 268, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vDesc" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

      ::DrawBox( 269, ::nLinhaPdf - 16, 88, 16, ::nLarguraBox )
      ::DrawTexto( 270, ::nLinhaPdf - 1,  356, NIL, "OUTRAS DESP. ACESSÓRIAS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 270, ::nLinhaPdf - 5, 356, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vOutro" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

      ::DrawBox( 357, ::nLinhaPdf - 16, 88, 16, ::nLarguraBox )
      ::DrawTexto( 358, ::nLinhaPdf - 1,  444, NIL, "VALOR DO IPI", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 358, ::nLinhaPdf - 5, 444, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vIPI" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

      ::DrawBox( 445, ::nLinhaPdf - 16, 145, 16, ::nLarguraBox )
      ::DrawTexto( 446, ::nLinhaPdf - 1,  589, NIL, "VALOR TOTAL DA NOTA FISCAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 446, ::nLinhaPdf - 5, 589, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vNF" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 17
   ENDIF

   RETURN NIL

METHOD DadosTransporte() CLASS hbNFeDaNFe

   IF ::nFolha == 1
      ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "TRANSPORTADOR / VOLUMES TRANSPORTADOS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )

      ::nLinhaPdf -= 6

      ::DrawBox( 5, ::nLinhaPdf - 16, 215, 16, ::nLarguraBox )
      ::DrawTexto( 6, ::nLinhaPdf - 1,  219, NIL, "NOME/RAZÃO SOCIAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
      ::DrawTexto( 6, ::nLinhaPdf - 5, 219, NIL, ::aTransp[ "xNome" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )

      ::DrawBox( 220, ::nLinhaPdf - 16, 90, 16, ::nLarguraBox )
      ::DrawTexto( 221, ::nLinhaPdf - 1,  309, NIL, "FRETE POR CONTA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      // Modificado por Anderson Camilo em 19/03/2012
      IF ::aTransp[ "modFrete" ] == "0"
         ::DrawTexto( 221, ::nLinhaPdf - 5, 309, NIL, "0-EMITENTE", HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
      ELSEIF ::aTransp[ "modFrete" ] == "1"
         ::DrawTexto( 221, ::nLinhaPdf - 5, 309, NIL, "1-DESTINATARIO", HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
      ELSEIF ::aTransp[ "modFrete" ] == "2"
         ::DrawTexto( 221, ::nLinhaPdf - 5, 309, NIL, "2-TERCEIROS", HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
      ELSEIF ::aTransp[ "modFrete" ] == "9"
         ::DrawTexto( 221, ::nLinhaPdf - 5, 309, NIL, "9-SEM FRETE", HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
      ENDIF

      ::DrawBox( 310, ::nLinhaPdf - 16, 110, 16, ::nLarguraBox )
      ::DrawTexto( 311, ::nLinhaPdf - 1,  419, NIL, "CÓDIGO ANTT", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 311, ::nLinhaPdf - 5, 419, NIL, ::aVeicTransp[ "RNTC" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )

      ::DrawBox( 420, ::nLinhaPdf - 16, 60, 16, ::nLarguraBox )
      ::DrawTexto( 421, ::nLinhaPdf - 1,  479, NIL, "PLACA DO VEÍCULO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 421, ::nLinhaPdf - 5, 479, NIL, ::aVeicTransp[ "placa" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

      ::DrawBox( 480, ::nLinhaPdf - 16, 20, 16, ::nLarguraBox )
      ::DrawTexto( 481, ::nLinhaPdf - 1,  499, NIL, "UF", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 481, ::nLinhaPdf - 5, 499, NIL, ::aVeicTransp[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

      ::DrawBox( 500, ::nLinhaPdf - 16, 90, 16, ::nLarguraBox )
      ::DrawTexto( 501, ::nLinhaPdf - 1,  589, NIL, "CNPJ / CPF", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      IF ! Empty( ::aTransp[ "CNPJ" ] )
         ::DrawTexto( 501, ::nLinhaPdf - 5, 589, NIL, Transform( ::aTransp[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ELSE
         IF ! Empty( ::aTransp[ "CPF" ] )
            ::DrawTexto( 501, ::nLinhaPdf - 5, 589, NIL, Transform( ::aTransp[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         ENDIF
      ENDIF

      ::nLinhaPdf -= 16

      ::DrawBox( 5, ::nLinhaPdf - 16, 265, 16, ::nLarguraBox )
      ::DrawTexto( 6, ::nLinhaPdf - 1,  269, NIL, "ENDEREÇO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 6, ::nLinhaPdf - 5, 269, NIL, ::aTransp[ "xEnder" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )

      ::DrawBox( 270, ::nLinhaPdf - 16, 210, 16, ::nLarguraBox )
      ::DrawTexto( 271, ::nLinhaPdf - 1,  479, NIL, "MUNICÍPIO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 271, ::nLinhaPdf - 5, 479, NIL, ::aTransp[ "xMun" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )

      ::DrawBox( 480, ::nLinhaPdf - 16, 20, 16, ::nLarguraBox )
      ::DrawTexto( 481, ::nLinhaPdf - 1,  499, NIL, "UF", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 481, ::nLinhaPdf - 5, 499, NIL, ::aTransp[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

      ::DrawBox( 500, ::nLinhaPdf - 16, 90, 16, ::nLarguraBox )
      ::DrawTexto( 501, ::nLinhaPdf - 1,  589, NIL, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 501, ::nLinhaPdf - 5, 589, NIL, ::aTransp[ "IE" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 16

      ::DrawBox( 5, ::nLinhaPdf - 16, 95, 16, ::nLarguraBox )
      ::DrawTexto( 6, ::nLinhaPdf - 1,  99, NIL, "QUANTIDADE", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 6, ::nLinhaPdf - 5, 99, NIL, LTrim( FormatNumber( Val( ::aTransp[ "qVol" ] ), 15, 0 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 8 )

      ::DrawBox( 100, ::nLinhaPdf - 16, 100, 16, ::nLarguraBox )
      ::DrawTexto( 101, ::nLinhaPdf - 1,  199, NIL, "ESPÉCIE", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 101, ::nLinhaPdf - 5, 199, NIL, ::aTransp[ "esp" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

      ::DrawBox( 200, ::nLinhaPdf - 16, 100, 16, ::nLarguraBox )
      ::DrawTexto( 201, ::nLinhaPdf - 1,  299, NIL, "MARCA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 201, ::nLinhaPdf - 5, 299, NIL, ::aTransp[ "marca" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

      ::DrawBox( 300, ::nLinhaPdf - 16, 100, 16, ::nLarguraBox )
      ::DrawTexto( 301, ::nLinhaPdf - 1,  399, NIL, "NUMERAÇÃO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 301, ::nLinhaPdf - 5, 399, NIL, ::aTransp[ "nVol" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

      ::DrawBox( 400, ::nLinhaPdf - 16, 100, 16, ::nLarguraBox )
      ::DrawTexto( 401, ::nLinhaPdf - 1,  499, NIL, "PESO BRUTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 401, ::nLinhaPdf - 5, 499, NIL, LTrim( FormatNumber( Val( ::aTransp[ "pesoB" ] ), 15, 3 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

      ::DrawBox( 500, ::nLinhaPdf - 16, 90, 16, ::nLarguraBox )
      ::DrawTexto( 501, ::nLinhaPdf - 1,  589, NIL, "PESO LÍQUIDO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 501, ::nLinhaPdf - 5, 589, NIL, LTrim( FormatNumber( Val( ::aTransp[ "pesoL" ] ), 15, 3 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 17
   ENDIF

   RETURN NIL

METHOD CabecalhoProdutos() CLASS hbNFeDaNFe

   LOCAL oElement

   ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "DADOS DOS PRODUTOS / SERVIÇOS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )
   ::nLinhaPdf -= ::nLayoutFonteAltura
   FOR EACH oELement IN ::aLayout
      ::DrawBoxProduto( oElement:__EnumIndex, ::nLinhaPdf - ( ::nLayoutFonteAltura * 2 + 1 ), ( ::nLayoutFonteAltura * 2 + 1 ), ::nLarguraBox )
      ::DrawTextoProduto( oElement:__EnumIndex, ::nLinhaPdf - 1,                    LAYOUT_TITULO1, HPDF_TALIGN_CENTER )
      ::DrawTextoProduto( oElement:__EnumIndex, ::nLinhaPdf - ::nLayoutFonteAltura, LAYOUT_TITULO2, HPDF_TALIGN_CENTER )
   NEXT
   ::nLinhaPdf -= ::nLayoutFonteAltura * 2 + 1

   RETURN NIL

METHOD DesenhaBoxProdutos( nLinhaFinalProd, nAlturaQuadroProdutos ) CLASS hbNFeDaNFe

   LOCAL oElement

   FOR EACH oElement IN ::aLayout
      ::DrawBoxProduto( oElement:__EnumIndex, nLinhaFinalProd, nAlturaQuadroProdutos, ::nLarguraBox )
   NEXT
   ::nLinhaPdf -= 1

   RETURN NIL

METHOD Produtos() CLASS hbNFeDaNFe

   LOCAL nLinhaFinalProd, nAlturaQuadroProdutos, nItem, nNumLinha, nCont

   nLinhaFinalProd := ::nLinhaPdf - ( ::ItensDaFolha() * ::nLayoutFonteAltura ) - 2
   nAlturaQuadroProdutos := ( ::ItensDaFolha() * ::nLayoutFonteAltura ) + 2
   ::desenhaBoxProdutos( nLinhaFinalProd, nAlturaQuadroProdutos )

   // DADOS PRODUTOS
   nItem := 1
   ::nLinhaFolha := 1
   DO WHILE .T.
      IF ! ::ProcessaItens( ::cXml, nItem )
         EXIT
      ENDIF
      IF ::nLinhaFolha > ::ItensDaFolha()
         ::saltaPagina()
      ENDIF
      ::aItem[ "xProd" ]     := ::FormataMemo( ::aItem[ "xProd" ],     ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] - 2 )
      ::aItem[ "infAdProd" ] := ::FormataMemo( ::aItem[ "infAdProd" ], ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] - 2 )
      ::DrawTextoProduto( LAYOUT_CODIGO,    ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_CENTER )
      ::DrawTextoProduto( LAYOUT_DESCRICAO, ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_LEFT )
      ::DrawTextoProduto( LAYOUT_NCM,       ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_CENTER )
      ::DrawTextoProduto( LAYOUT_CST,       ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_CENTER )
      ::DrawTextoProduto( LAYOUT_CFOP,      ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_CENTER )
      ::DrawTextoProduto( LAYOUT_UNIDADE,   ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_CENTER )
      ::DrawTextoProduto( LAYOUT_QTD,       ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_UNITARIO,  ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_TOTAL,     ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_DESCONTO,  ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_ICMBAS,    ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_ICMVAL,    ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_SUBBAS,    ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_SUBVAL,    ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_IPIVAL,    ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_ICMALI,    ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_IPIALI,    ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::nLinhaPdf -= ::nLayoutFonteAltura
      nItem++
      ::nLinhaFolha++
      FOR nNumLinha = 2 TO MLCount( ::aItem[ "xProd" ], 1000 )
         IF ::nLinhaFolha > ::ItensDaFolha()
            ::saltaPagina()
         ENDIF
         ::DrawTextoProduto( LAYOUT_DESCRICAO, ::nLinhaPdf, MemoLine( ::aItem[ "xProd" ], 1000, nNumLinha ), HPDF_TALIGN_LEFT )
         ::nLinhaFolha++
         ::nLinhaPdf -= ::nLayoutFonteAltura
      NEXT
      FOR nNumLinha = 1 TO MLCount( ::aItem[ "infAdProd" ], 1000 )
         IF ::nLinhaFolha > ::ItensDaFolha()
            ::saltaPagina()
         ENDIF
         ::DrawTextoProduto( LAYOUT_DESCRICAO, ::nLinhaPdf, MemoLine( ::aItem[ "infAdProd" ], 1000, nNumLinha ), HPDF_TALIGN_LEFT )
         ::nLinhaFolha++
         ::nLinhaPdf -= ::nLayoutFonteAltura
      NEXT
      IF ::lLayoutEspacoDuplo
         ::nLinhaPdf -= ::nLayoutFonteAltura
         ::nLinhaFolha++
      ENDIF
      IF ::nLinhaFolha <= ::ItensDaFolha() .AND. ! ::lLayoutEspacoDuplo
         ::DrawLine( 5, ::nLinhaPdf - 0.5, 590, ::nLinhaPdf - 0.5, ::nLarguraBox )
      ENDIF
   ENDDO
   IF MLCount( ::aInfAdic[ "infCpl" ], 1000 ) > Int( 13 * 6 / ::nLayoutFonteAltura )
      ::nLinhaFolha++
      ::nLinhaPdf -= ::nLayoutFonteAltura
      ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "*CONTINUACAO INFORMAÇÕES COMPLEMENTARES*", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, ::nLayoutFonteAltura )
      ::nLinhaFolha++
      ::nLinhaPdf -= ::nLayoutFonteAltura
      FOR nCont = Int( 13 * 6 / ::nLayoutFonteAltura ) + 1 TO MLCount( ::aInfAdic[ "infCpl" ], 1000 )
         IF ::nLinhaFolha > ::ItensDaFolha()
            ::SaltaPagina()
            ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "*CONTINUACAO INFORMAÇÕES COMPLEMENTARES*", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, ::nLayoutFonteAltura )
            ::nLinhaFolha++
            ::nLinhaPdf -= ::nLayoutFonteAltura
         ENDIF
         ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, MemoLine( ::aInfAdic[ "infCpl" ], 1000, nCont ), HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, ::nLayoutFonteAltura )
         ::nLinhaFolha++
         ::nLinhaPdf -= ::nLayoutFonteAltura
      NEXT
   ENDIF
   ::nLinhaPdf -= ( ( ::ItensDaFolha() - ::nLinhaFolha + 1 ) * ::nLayoutFonteAltura )
   ::nLinhaPdf -= 2

   RETURN NIL

METHOD TotalServico() CLASS hbNFeDaNFe

   IF ::nFolha == 1
      IF Val( ::aISSTotal[ "vServ" ] ) > 0
         ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "CALCULO DO ISSQN", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )

         ::nLinhaPdf -= 6

         ::DrawBox( 5, ::nLinhaPdf - 16, 150, 16, ::nLarguraBox )
         ::DrawTexto( 6, ::nLinhaPdf - 1,  154, NIL, "INSCRIÇÃO MUNICIPAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 6, ::nLinhaPdf - 5, 154, NIL, ::aEmit[ "IM" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )

         ::DrawBox( 155, ::nLinhaPdf - 16, 145, 16, ::nLarguraBox )
         ::DrawTexto( 156, ::nLinhaPdf - 1,  299, NIL, "VALOR TOTAL DOS SERVIÇOS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 156, ::nLinhaPdf - 5, 299, NIL, FormatNumber( Val( ::aISSTotal[ "vServ" ] ), 15 ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

         ::DrawBox( 300, ::nLinhaPdf - 16, 145, 16, ::nLarguraBox )
         ::DrawTexto( 301, ::nLinhaPdf - 1,  444, NIL, "BASE DE CÁLCULO DO ISSQN", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 301, ::nLinhaPdf - 5, 444, NIL, FormatNumber( Val( ::aISSTotal[ "vBC" ] ), 15 ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

         ::DrawBox( 445, ::nLinhaPdf - 16, 145, 16, ::nLarguraBox )
         ::DrawTexto( 446, ::nLinhaPdf - 1,  589, NIL, "VALOR DO ISSQN", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 446, ::nLinhaPdf - 5, 589, NIL, FormatNumber( Val( ::aISSTotal[ "vISS" ] ), 15 ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 17
      ENDIF
   ENDIF

   RETURN NIL

METHOD DadosAdicionais() CLASS hbNFeDaNFe

   LOCAL cMemo, nI

   IF ::nFolha == 1
      cMemo := ::aInfAdic[ "infCpl" ]
      ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "DADOS ADICIONAIS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )
      ::nLinhaPdf -= 6

      ::DrawBox( 5, ::nLinhaPdf - 92, 395, 92, ::nLarguraBox )
      ::DrawTexto( 6, ::nLinhaPdf - 1, 399, NIL, "INFORMAÇÕES COMPLEMENTARES", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, ::nLayoutFonteALtura )

      // ::DrawBox( 400, ::nLinhaPdf - 78, 190, 78, ::nLarguraBox )
      ::DrawBox( 400, ::nLinhaPdf - 92, 190, 92, ::nLarguraBox )
      ::DrawTexto( 401, ::nLinhaPdf - 1, 589, NIL, "RESERVADO AO FISCO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
      ::nLinhaPdf -= 7    //
      ::nLinhaPdf -= 4 // ESPAÇO
      FOR nI = 1 TO Min( MLCount( cMemo, 1000 ), Int( 13 * 6 / ::nLayoutFonteAltura ) )
         ::DrawTexto( 6, ::nLinhaPdf, 399, NIL, Trim( MemoLine( cMemo, 1000, nI ) ), HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, ::nLayoutFonteAltura )
         ::nLinhaPdf -= ::nLayoutFonteAltura
      NEXT
      FOR nI = ( MLCount( cMemo, 1000 ) + 1 ) TO Int( 13 * 6 / ::nLayoutFonteAltura )
         ::nLinhaPdf -= ::nLayoutFonteAltura
      NEXT
      ::nLinhaPdf -= 4
   ENDIF

   RETURN NIL

METHOD Rodape() CLASS hbNFeDaNFe

   ::DrawTexto( 5, ::nLinhaPdf, 110, NIL, "DATA DA IMPRESSÃO: " + DToC( Date() ), HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
   ::DrawTexto( 115, ::nLinhaPdf, 589, NIL, ::cDesenvolvedor, HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 6 )

   RETURN NIL

METHOD ProcessaItens( cXml, nItem ) CLASS hbNFeDaNFe

   LOCAL cItem

   cItem := XmlNode( cXml, [det nItem="]  + AllTrim( Str( nItem ) ) + ["] )
   IF Empty( cItem )
      RETURN .F.
   ENDIF
   ::aItem          := XmlToHash( cItem, { "cProd", "cEAN", "xProd", "NCM", "EXTIPI", "CFOP", "uCom", "qCom", "vUnCom", "vProd", "cEANTrib", "uTrib", "qTrib", "vUnTrib", "vFrete", ;
                       "vSeg", "vDesc", "vOutro", "indTot", "infAdProd" } )
   ::aItemDI        := XmlToHash( XmlNode( cItem, "DI" ), { "nDI", "dDI", "xLocDesemb", "UFDesemb", "cExportador" } )
   ::aItemAdi       := XmlToHash( XmlNode( cItem, "adi" ), { "nAdicao", "nSeqAdic", "cFabricante", "vDescDI", "xPed", "nItemPed" } )
   // todo veiculos (veicProd), medicamentos (med), armamentos (arm), combustiveis (comb)
   ::aItemICMS      := XmlToHash( XmlNode( cItem, "ICMS" ), { "orig", "CST", "CSOSN", "vBCSTRet", "vICMSSTRet", "modBC", "pRedBC", "vBC", "pICMS", "vICMS", "motDesICMS", "modBCST", "pMVAST", "pRedBCST", "vBCST", "pICMSST", "vICMSST" } )
   ::aItemICMSPart  := XmlToHash( XmlNode( cItem, "ICMSPart" ), { "orig", "CST", "modBC", "pRedBC", "vBC", "pICMS", "vICMS", "modBCST", "pMVAST", "pRedBCST", "vBCST", "pICMSST", "vICMSST", "pBCOp", "UFST" } )
   ::aItemICMSST    := XmlToHash( XmlNode( cItem, "ICMSST" ), { "orig", "CST", "vBCSTRet", "vICMSSTRet", "vBCSTDest", "vICMSSTDest" } )
   ::aItemICMSSN101 := XmlToHash( XmlNode( cItem, "ICMSSN101" ), { "orig", "CSOSN", "pCredSN", "vCredICMSSN" } )
   ::aItemICMSSN102 := XmlToHash( XmlNode( cItem, "ICMSSN102" ), { "orig", "CSOSN" } )
   ::aItemICMSSN201 := XmlToHash( XmlNode( cItem, "ICMSSN201" ), { "orig", "CSOSN", "modBCST", "pMVAST", "pRedBCST", "vBCST", "pICMSST", "vICMSST", "pCredSN", "vCredICMSSN" } )
   ::aItemICMSSN202 := XmlToHash( XmlNode( cItem, "ICMSSN202" ), { "orig", "CSOSN", "modBCST", "pMVAST", "pRedBCST", "vBCST", "pICMSST", "vICMSST" } )
   ::aItemICMSSN500 := XmlToHash( XmlNode( cItem, "ICMSSN500" ), { "orig", "CSOSN", "vBCSTRet", "vICMSSTRet" } )
   ::aItemICMSSN900 := XmlToHash( XmlNode( cItem, "ICMSSN900" ), { "orig", "CSOSN", "modBC", "pRedBC", "vBC", "pICMS", "vICMS", "modBCST", "pMVAST", "pRedBCST", "vBCST", ;
                       "pICMSST", "vICMSST", "pCredSN", "vCredICMSSN" } )
   ::aItemIPI       := XmlToHash( XmlNode( cItem, "IPI" ), { "clEnq", "CNPJProd", "cSelo", "qSelo", "cEnq", "CST", "vBC", "pIPI", "qUnid", "vUnid", "vIPI" } )
   ::aItemII        := XmlToHash( XmlNode( cItem, "II" ), { "vBC", "vDespAdu", "vII", "vIOF" } )
   ::aItemPIS       := XmlToHash( XmlNode( cItem, "PIS" ), { "CST", "vBC", "pPIS", "vPIS", "qBCProd", "vAliqProd" } )
   ::aItemPISST     := XmlToHash( XmlNode( cItem, "PISST" ), { "vBC", "pPIS", "vPIS", "qBCProd", "vAliqProd" } )
   ::aItemCOFINS    := XmlToHash( XmlNode( cItem, "COFINS" ), { "CST", "vBC", "pCOFINS", "vCOFINS", "qBCProd", "vAliqProd" } )
   ::aItemCOFINSST  := XmlToHash( XmlNode( cItem, "COFINSST" ), { "vBC", "pCOFINS", "vCOFINS", "qBCProd", "vAliqProd" } )
   ::aItemISSQN     := XmlToHash( XmlNode( cItem, "ISSQN" ), { "vBC", "vAliq", "vISSQN", "cMunFG", "cListServ", "cSitTrib" } )

   ::aItem[ "infAdProd" ] := StrTran( ::aItem[ "infAdProd" ], ";", Chr( 13 ) + Chr( 10 ) )

   RETURN .T.

METHOD CalculaLayout() CLASS hbNFeDaNFe

   LOCAL nItem, nQtdLinhas

   ::DefineColunasProdutos()
   ::aInfAdic[ "infCpl" ] := ::FormataMemo( ::aInfAdic[ "infCpl" ], 392 )
   // Linhas necessárias pra imprimir ítens
   nQtdLinhas := 1
   nItem      := 1
   DO WHILE .T.
      IF ! ::ProcessaItens( ::cXml, nItem )
         EXIT
      ENDIF
      ::aItem[ "xProd" ] := ::FormataMemo( ::aItem[ "xProd" ], ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] - 2 )
      nQtdLinhas += MLCount( ::aItem[ "xProd" ], 1000 )
      IF Len( ::aItem[ "infAdProd" ] ) > 0
         ::aItem[ "infAdProd" ] := ::FormataMemo( ::aItem[ "infAdProd" ], ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] - 2 )
         nQtdLinhas += MLCount( ::aItem[ "infAdProd" ], 1000 )
      ENDIF
      IF ::lLayoutEspacoDuplo
         nQtdLinhas += 1
      ENDIF
      nItem += 1
   ENDDO

   // Linhas extras pra informações adicionais
   IF MLCount( ::ainfAdic[ "infCpl" ], 1000 ) > Int( 13 * 6 / ::nLayoutFonteAltura )
      nQtdLinhas += 2 + MLCount( ::ainfAdic[ "infCpl" ], 1000 ) - Int( 13 * 6 / ::nLayoutFonteAltura )
   ENDIF

   // Total de folhas necessárias
   ::nLayoutTotalFolhas := 1
   IF nQtdLinhas > ::ItensDaFolha( 1 )
      ::nLayoutTotalFolhas += Int( ( nQtdLinhas - ::ItensDaFolha( 1 ) + ::ItensDaFolha( 9 ) - 1 ) / ::ItensDaFolha( 9 ) )
   ENDIF

   RETURN NIL

METHOD ItensDaFolha( nFolha ) CLASS hbNFeDaNFe

   LOCAL nTotal

   nFolha := iif( nFolha == NIL, ::nFolha, nFolha )

   IF nFolha == 1
      nTotal := 45 + ;
                iif( ::lLaser, 9, 0  ) + ;
                iif( Empty( ::cCobranca ), 2, 0 ) + ;
                iif( Val( ::aIssTotal[ "vServ" ] ) <= 0, 4, 0 )
   ELSE
      nTotal := 105
   ENDIF
   nTotal := Int( nTotal * 6 / ::nLayoutFonteAltura )

   RETURN nTotal

METHOD DrawTextoProduto( nCampo, nRow, nConteudo, nAlign ) CLASS hbNFeDaNFe

   LOCAL nColunaInicial, nColunaFinal, cTexto

   IF ::aLayout[ nCampo, LAYOUT_IMPRIME ] == LAYOUT_IMPRIMENORMAL
      nColunaInicial := ::aLayout[ nCampo, LAYOUT_COLUNAPDF ]
      nColunaFinal   := ::aLayout[ nCampo, LAYOUT_COLUNAPDF ] + ::aLayout[ nCampo, LAYOUT_LARGURAPDF ] - 2
      IF ValType( nConteudo ) == "C"
         cTexto := nConteudo
      ELSE
         cTexto := ::aLayout[ nCampo, nConteudo ]
         IF nConteudo == LAYOUT_CONTEUDO
            cTexto := Eval( cTexto )
         ENDIF
      ENDIF
      ::DrawTexto( nColunaInicial, nRow, nColunaFinal, NIL, cTexto, nAlign, ::oPDFFontCabecalho, ::nLayoutFonteAltura )
   ENDIF

   RETURN NIL

METHOD DrawBoxProduto( nCampo, nRow, nHeight ) CLASS hbNfeDaNFe

   IF ::aLayout[ nCampo, LAYOUT_IMPRIME ] == LAYOUT_IMPRIMENORMAL
      ::DrawBox( ::aLayout[ nCampo, LAYOUT_COLUNAPDF ] - 1, nRow, ::aLayout[ nCampo, LAYOUT_LARGURAPDF ], nHeight, ::nLarguraBox )
   ENDIF

   RETURN NIL

METHOD DefineColunasProdutos() CLASS hbNFeDaNFe

   LOCAL oElement, nItem, nCont, nColunaFinal

   ::ProcessaItens( ::cXml, 1 ) // precisa de ::aItem pra gerar o codeblock
   ::aLayout[ LAYOUT_CODIGO,    LAYOUT_TITULO1 ]   := "CÓDIGO"
   ::aLayout[ LAYOUT_CODIGO,    LAYOUT_CONTEUDO ]  := { || ::aItem[ "cProd" ] }
   ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_TITULO1 ]   := "DESCRIÇÃO DO PRODUTO / SERVIÇO"
   ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_CONTEUDO ]  := { || MemoLine( ::aItem[ "xProd" ], ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURA ], 1 ) }
   ::aLayout[ LAYOUT_NCM,       LAYOUT_TITULO1 ]   := "NCM/SH"
   ::aLayout[ LAYOUT_NCM,       LAYOUT_CONTEUDO ]  := { || ::aItem[ "NCM" ] }
   ::aLayout[ LAYOUT_CST,       LAYOUT_TITULO1 ]   := "CST"
   ::aLayout[ LAYOUT_CST,       LAYOUT_TITULO2 ]   := "CSOSN"
   ::aLayout[ LAYOUT_CST,       LAYOUT_CONTEUDO ]  := { || ::aItemICMS[ "orig" ] + iif( ::aEmit[ "CRT" ] == "1", ::aItemICMS[ "CSOSN" ], ::aItemICMS[ "CST" ] ) }
   ::aLayout[ LAYOUT_CFOP,      LAYOUT_TITULO1 ]   := "CFOP"
   ::aLayout[ LAYOUT_CFOP,      LAYOUT_CONTEUDO ]  := { || ::aItem[ "CFOP" ] }
   ::aLayout[ LAYOUT_UNIDADE,   LAYOUT_TITULO1 ]   := "UNID"
   ::aLayout[ LAYOUT_UNIDADE,   LAYOUT_CONTEUDO ]  := { || ::aItem[ "uCom" ] }
   ::aLayout[ LAYOUT_QTD,       LAYOUT_TITULO1 ]   := "QUANT"
   ::aLayout[ LAYOUT_QTD,       LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItem[ "qCom" ] ), 15, ::aLayout[ LAYOUT_QTD, LAYOUT_DECIMAIS ] ) ) }
   ::aLayout[ LAYOUT_UNITARIO,  LAYOUT_TITULO1 ]   := "VALOR"
   ::aLayout[ LAYOUT_UNITARIO,  LAYOUT_TITULO2 ]   := "UNITÁRIO"
   ::aLayout[ LAYOUT_UNITARIO,  LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItem[ "vUnCom" ] ), 15, ::aLayout[ LAYOUT_UNITARIO, LAYOUT_DECIMAIS ] ) ) }
   //::aLayout[ LAYOUT_TOTAL,     LAYOUT_TITULO1 ]   := "VALOR TOTAL"
   ::aLayout[ LAYOUT_TOTAL,     LAYOUT_TITULO1 ]   := "VALOR"
   ::aLayout[ LAYOUT_TOTAL,     LAYOUT_TITULO2 ]   := "TOTAL"
   ::aLayout[ LAYOUT_TOTAL,     LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItem[ "vProd" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_DESCONTO,  LAYOUT_TITULO1 ]   := "VALOR"
   ::aLayout[ LAYOUT_DESCONTO,  LAYOUT_TITULO2 ]   := "DESCTO."
   ::aLayout[ LAYOUT_DESCONTO,  LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItem[ "vDesc" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_ICMBAS,    LAYOUT_TITULO1 ]   := "B.CÁLC."
   ::aLayout[ LAYOUT_ICMBAS,    LAYOUT_TITULO2 ]   := "DO ICMS"
   ::aLayout[ LAYOUT_ICMBAS,    LAYOUT_CONTEUDO ]  := { || Alltrim( FormatNumber( Val( ::aItemICMS[ "vBC" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_ICMVAL,    LAYOUT_TITULO1 ]   := "VALOR"
   ::aLayout[ LAYOUT_ICMVAL,    LAYOUT_TITULO2 ]   := "ICMS"
   ::aLayout[ LAYOUT_ICMVAL,    LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItemICMS[ "vICMS" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_SUBBAS,    LAYOUT_TITULO1 ]   := "B.CÁLC.ICMS"
   ::aLayout[ LAYOUT_SUBBAS,    LAYOUT_TITULO2 ]   := "SUBST.TRIB"
   ::aLayout[ LAYOUT_SUBBAS,    LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItemICMS[ "vBCST" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_SUBVAL,    LAYOUT_TITULO1 ]   := "VALOR ICMS"
   ::aLayout[ LAYOUT_SUBVAL,    LAYOUT_TITULO2 ]   := "SUBST.TRIB"
   ::aLayout[ LAYOUT_SUBVAL,    LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItemICMS[ "vICMSST" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_IPIVAL,    LAYOUT_TITULO1 ]   := "VALOR"
   ::aLayout[ LAYOUT_IPIVAL,    LAYOUT_TITULO2 ]   := "IPI"
   ::aLayout[ LAYOUT_IPIVAL,    LAYOUT_CONTEUDO ]  := { || Alltrim( FormatNumber( Val( ::aItemIPI[ "vIPI" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_ICMALI,    LAYOUT_TITULO1 ]   := "ALÍQ"
   ::aLayout[ LAYOUT_ICMALI,    LAYOUT_TITULO2 ]   := "ICMS"
   ::aLayout[ LAYOUT_ICMALI,    LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItemICMS[ "pICMS" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_IPIALI,    LAYOUT_TITULO1 ]   := "ALÍQ"
   ::aLayout[ LAYOUT_IPIALI,    LAYOUT_TITULO2 ]   := "IPI"
   ::aLayout[ LAYOUT_IPIALI,    LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItemIPI[ "pIPI" ] ), 15, 2 ) ) }

   ::aLayout[ LAYOUT_DESCONTO, LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
   ::aLayout[ LAYOUT_SUBBAS,   LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
   ::aLayout[ LAYOUT_SUBVAL,   LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
   ::aLayout[ LAYOUT_IPIVAL,   LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
   ::aLayout[ LAYOUT_IPIALI,   LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
   ::aLayout[ LAYOUT_IPIALI,   LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
   // Define decimais default, mas será ajustado conforme conteúdo do XML
   ::aLayout[ LAYOUT_QTD, LAYOUT_DECIMAIS ]      := 0
   ::aLayout[ LAYOUT_UNITARIO, LAYOUT_DECIMAIS ] := 2
   FOR EACH oElement IN ::aLayout
      oElement[ LAYOUT_LARGURA ] := Max( Len( oElement[ LAYOUT_TITULO1 ] ), Len( oElement[ LAYOUT_TITULO2 ] ) )
   NEXT
   nItem := 1
   DO WHILE .T.
      IF ! ::ProcessaItens( ::cXml, nItem )
         EXIT
      ENDIF
      nItem += 1
      ::aLayout[ LAYOUT_QTD,      LAYOUT_DECIMAIS ] := ::DefineDecimais( ::aItem[ "qCom" ],   ::aLayout[ LAYOUT_QTD,    LAYOUT_DECIMAIS ] )
      ::aLayout[ LAYOUT_UNITARIO, LAYOUT_DECIMAIS ] := ::DefineDecimais( ::aItem[ "vUnCom" ], ::aLayout[ LAYOUT_UNITARIO, LAYOUT_DECIMAIS ] )
      FOR EACH oElement IN ::aLayout
         oElement[ LAYOUT_LARGURA ] := Max( oElement[ LAYOUT_LARGURA ], Len( Eval( oElement[ LAYOUT_CONTEUDO ] ) ) )
         oElement[ LAYOUT_LARGURAPDF ] := Max( oElement[ LAYOUT_LARGURAPDF ], ::LarguraTexto( Eval( oElement[ LAYOUT_CONTEUDO ] ) ) )
      NEXT
      IF Val( ::aItemIPI[ "pIPI" ]  ) > 0 .OR. Val( ::aItemIPI[ "vIPI" ] ) > 0 // Se houver IPI no XML, habilita coluna
         ::aLayout[ LAYOUT_IPIVAL, LAYOUT_IMPRIME ] := LAYOUT_IMPRIMENORMAL
         ::aLayout[ LAYOUT_IPIALI, LAYOUT_IMPRIME ] := LAYOUT_IMPRIMENORMAL
      ENDIF
      IF Val( ::aItemICMS[ "vBCST" ] ) > 0 .OR. Val( ::aItemICMS[ "vICMSST" ] ) > 0
         ::aLayout[ LAYOUT_SUBBAS, LAYOUT_IMPRIME ] := LAYOUT_IMPRIMENORMAL
         ::aLayout[ LAYOUT_SUBVAL, LAYOUT_IMPRIME ] := LAYOUT_IMPRIMENORMAL
      ENDIF
      IF Val( ::aItem[ "vDesc" ] ) > 0
         ::aLayout[ LAYOUT_DESCONTO, LAYOUT_IMPRIME ] := LAYOUT_IMPRIMENORMAL
      ENDIF
   ENDDO
   // Define tamanho de colunas
   FOR EACH oElement IN ::aLayout
      oElement[ LAYOUT_LARGURA ] += 1
      oElement[ LAYOUT_LARGURAPDF ] := Max( oElement[ LAYOUT_LARGURAPDF ], ::LarguraTexto( oElement[ LAYOUT_TITULO1 ] ) )
      oElement[ LAYOUT_LARGURAPDF ] := Max( oElement[ LAYOUT_LARGURAPDF ], ::LarguraTexto( oELement[ LAYOUT_TITULO2 ] ) )
      oElement[ LAYOUT_LARGURAPDF ] += 4
   NEXT

   // Desativa colunas não impressas
   AEval( ::aLayout, { | oElement | oElement[ LAYOUT_LARGURAPDF ] := iif( oElement[ LAYOUT_IMPRIME ] == LAYOUT_IMPRIMENORMAL, oElement[ LAYOUT_LARGURAPDF ], 0 ) } )

   // Calcula posição das colunas
   nColunaFinal := 592
   ::aLayout[ LAYOUT_IPIALI,    LAYOUT_COLUNAPDF ]  := nColunaFinal - ::aLayout[ LAYOUT_IPIALI,   LAYOUT_LARGURAPDF ]
   FOR nCont = Len( ::aLayout ) - 1 TO 3 STEP -1
      ::aLayout[ nCont, LAYOUT_COLUNAPDF ] := ::aLayout[ nCont + 1, LAYOUT_COLUNAPDF ] - ::aLayout[ nCont, LAYOUT_LARGURAPDF ]
   NEXT
   ::aLayout[ LAYOUT_CODIGO,    LAYOUT_COLUNAPDF ]  := 6
   ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_COLUNAPDF ]  := ::aLayout[ LAYOUT_CODIGO, LAYOUT_COLUNAPDF ] + ::aLayout[ LAYOUT_CODIGO, LAYOUT_LARGURAPDF ]

   // Define largura da descrição conforme espaço que sobra
   ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] := ::aLayout[ LAYOUT_NCM, LAYOUT_COLUNAPDF ] - ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_COLUNAPDF ]
   ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURA ]    := 100 // tanto faz

   RETURN NIL
