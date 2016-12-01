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

#define LAYOUT_TITULO          1
#define LAYOUT_LARGURA         2
#define LAYOUT_COLUNAPDF       3
#define LAYOUT_LARGURAPDF      4
#define LAYOUT_DECIMAIS        5
#define LAYOUT_IMPRIME         6
#define LAYOUT_TITULO1         7
#define LAYOUT_TITULO2         8
#define LAYOUT_CONTEUDO        9

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
   METHOD CabecalhoPaisagem()
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
   VAR lPaisagem   INIT .F.
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
      oElement := Array(9)
      oElement[ LAYOUT_IMPRIME ]  := .T.
      oElement[ LAYOUT_TITULO1 ]  := ""
      oElement[ LAYOUT_TITULO2 ]  := ""
      oElement[ LAYOUT_CONTEUDO ] := { || "" }
      oElement[ LAYOUT_LARGURAPDF ] := 1
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

   ::lPaisagem := ( ::lPaisagem .OR. ::aIde[ "tpImp" ] == "2" ) // Se definir .T., força paisagem
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
   //   ::aIde[ "dhSaiEnt" ] := XmlNode( XmlNode( ::cXml, "ide" ), "dSaiEnt" ) + "T" + Time()
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
   ::cTelefoneEmitente := FormatTelefone( ::aEmit[ "fone" ] )
   ::aDest[ "fone" ]   := FormatTelefone( ::aDest[ "fone" ] )
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
   IF ::lPaisagem
      ::CabecalhoPaisagem()
   ELSE
      ::CabecalhoRetrato()
   ENDIF
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
   IF ::lPaisagem
      HPDF_Page_SetSize( ::oPdfPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_LANDSCAPE )
   ELSE
      HPDF_Page_SetSize( ::oPdfPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT )
   ENDIF
   nAltura := HPDF_Page_GetHeight( ::oPdfPage )

   IF ::lPaisagem
      ::nLinhaPdf := nAltura - 10     // Margem Superior
      nAngulo := 30                   /* A rotation of 45 degrees. */
   ELSE
      ::nLinhaPdf := nAltura - 8 // Margem Superior
      nAngulo := 45                   /* A rotation of 45 degrees. */
   ENDIF

   nRadiano := nAngulo / 180 * 3.141592 /* Calcurate the radian value. */

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
      IF ::lPaisagem
         ::DrawLine( 15, 95, 675, 475, 2.0 )
      ELSE
         ::DrawLine( 15, 95, 550, 630, 2.0 )
      ENDIF

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
         IF ::lPaisagem
            ::DrawLine( 15, 95, 675, 475, 2.0 )
         ELSE
            ::DrawLine( 15, 95, 550, 630, 2.0 )
         ENDIF

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
   IF ::lPaisagem
      ::CabecalhoPaisagem()
   ELSE
      ::CabecalhoRetrato()
   ENDIF
   ::cabecalhoProdutos()
   nLinhaFinalProd       := ::nLinhaPdf - ( ::ItensDaFolha() * ::nLayoutFonteAltura ) - 2
   nAlturaQuadroProdutos := ( ::ItensDaFolha() * ::nLayoutFonteAltura ) + 2
   ::desenhaBoxProdutos( nLinhaFinalProd, nAlturaQuadroProdutos )

   RETURN NIL

METHOD Canhoto() CLASS hbNFeDaNFe

   IF ::nFolha == 1
      IF ::lPaisagem
         ::DrawBox(   5, 20, 50, 565, ::nLarguraBox )
         // recebemos
         ::DrawTexto(  14, 21, 14 + 8, ::nLinhaPdf, "Recebemos de " + Trim( ::aEmit[ "xNome" ] ) + " os produtos constantes da Nota Fiscal indicada ao lado", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 7, 90 )
         // quadro numero da NF
         ::DrawBox(   5, 505, 50, 80, ::nLarguraBox )
         ::DrawTexto(  14, 506, 14 + 8, NIL, "NOTA FISCAL", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8, 90 )
         ::DrawTexto(  30, 506, 30 + 8, NIL, "Nº: " + Transform( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), "@R 999.999.999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8, 90 )
         ::DrawTexto(  46, 506, 46 + 8, NIL, "SÉRIE " + ::aIde[ "serie" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8, 90 )

         // data recebimento
         ::DrawBox(  20, 20, 35, 120, ::nLarguraBox )
         ::DrawTexto( 26, 21, 26 + 8, NIL, "DATA DE RECEBIMENTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6, 90 )
         // identificacao
         ::DrawBox(  20, 140, 35, 365, ::nLarguraBox )
         ::DrawTexto(  26, 141, 26 + 8, NIL, "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6, 90 )

         // corte
         IF ::cFonteNFe == "Times"
            ::DrawTexto( 62, 20, 62 + 8, NIL, Replicate( "- ", 110 ), HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8, 90 )
         ELSE
            ::DrawTexto( 65, 20, 65 + 6, NIL, Replicate( "- ", 78 ), HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6, 90 )
         ENDIF
      ELSE // retrato
         ::DrawBox( 5, ::nLinhaPdf - 44, 585, 44, ::nLarguraBox )
         // recebemos
         ::DrawTexto( 6, ::nLinhaPdf, 490, NIL, "Recebemos de " + ::aEmit[ "xNome" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
         ::DrawTexto( 6, ::nLinhaPdf - 7, 490, NIL, "os produtos constantes da Nota Fiscal indicada ao lado", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
         // quadro numero da NF
         ::DrawBox( 505, ::nLinhaPdf - 44, 85, 44, ::nLarguraBox )
         ::DrawTexto( 506, ::nLinhaPdf - 8, 589, NIL, "NF-e", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
         ::DrawTexto( 506, ::nLinhaPdf - 20, 589, NIL, "Nº: " + Transform( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), "@R 999.999.999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
         ::DrawTexto( 506, ::nLinhaPdf - 32, 589, NIL, "SÉRIE " + ::aIde[ "serie" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
         ::nLinhaPdf -= 18

         // data recebimento
         ::DrawBox(   5, ::nLinhaPdf - 26, 130, 26, ::nLarguraBox )
         ::DrawTexto( 6, ::nLinhaPdf, 134, NIL, "DATA DE RECEBIMENTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         // identificacao
         ::DrawBox( 135, ::nLinhaPdf - 26, 370, 26, ::nLarguraBox )
         ::DrawTexto( 136, ::nLinhaPdf, 470, NIL, "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::nLinhaPdf -= 24

         // corte
         IF ::cFonteNFe == "Times"
            ::DrawTexto(  5, ::nLinhaPdf, 590, NIL, Replicate( "- ", 125 ), HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )
         ELSE
            ::DrawTexto(  5, ::nLinhaPdf - 2, 590, NIL, Replicate( "- ", 81 ), HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ENDIF
         ::nLinhaPdf -= 10
      ENDIF
   ELSE
      IF ! ::lPaisagem
         ::nLinhaPdf -= 18
         ::nLinhaPdf -= 24
         ::nLinhaPdf -= 10
      ENDIF
   ENDIF

   RETURN NIL

METHOD CabecalhoPaisagem() CLASS hbNFeDaNFe

   LOCAL oImage

   ::DrawBox( 70, ::nLinhaPdf - 80, 760, 80, ::nLarguraBox )
   // logo/dados empresa
   ::DrawBox( 70, ::nLinhaPdf - 80, 330, 80, ::nLarguraBox )
   IF ::cLogoFile == NIL .OR. Empty( ::cLogoFile )
      ::DrawTexto( 71, ::nLinhaPdf, 399, NIL, "IDENTIFICAÇÃO DO EMITENTE", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
      ::DrawTexto( 71, ::nLinhaPdf - 6, 399, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
      ::DrawTexto( 71, ::nLinhaPdf - 18, 399, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 2 ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
      ::DrawTexto( 71, ::nLinhaPdf - 30, 399, NIL, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ::DrawTexto( 71, ::nLinhaPdf - 38, 399, NIL, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ::DrawTexto( 71, ::nLinhaPdf - 46, 399, NIL, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ::DrawTexto( 71, ::nLinhaPdf - 54, 399, NIL, iif( Empty( ::cTelefoneEmitente ), "", "FONE: " + ::cTelefoneEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ::DrawTexto( 71, ::nLinhaPdf - 62, 399, NIL, Trim( ::cSiteEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ::DrawTexto( 71, ::nLinhaPdf - 70, 399, NIL, Trim( ::cEmailEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
   ELSE
      oImage := ::LoadJPEGImage( ::oPDF, ::cLogoFile )
      IF ::nLogoStyle == _LOGO_EXPANDIDO
         HPDF_Page_DrawImage( ::oPdfPage, oImage, 71, ::nLinhaPdf - ( 72 + 6 ), 238, 72 )
      ELSEIF ::nLogoStyle == _LOGO_ESQUERDA
         HPDF_Page_DrawImage( ::oPdfPage, oImage, 71, ::nLinhaPdf - ( 72 + 6 ), 62, 72 )
         ::DrawTexto( 135, ::nLinhaPdf - 6, 399, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
         ::DrawTexto( 135, ::nLinhaPdf - 18, 399, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 2 ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
         ::DrawTexto( 135, ::nLinhaPdf - 30, 399, NIL, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 135, ::nLinhaPdf - 38, 399, NIL, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 135, ::nLinhaPdf - 46, 399, NIL, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 135, ::nLinhaPdf - 54, 399, NIL, IF( Empty( ::cTelefoneEmitente ), "", "FONE: " + ::cTelefoneEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 135, ::nLinhaPdf - 62, 399, NIL, Trim( ::cSiteEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 135, ::nLinhaPdf - 70, 399, NIL, Trim( ::cEmailEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ELSEIF ::nLogoStyle == _LOGO_DIREITA
         HPDF_Page_DrawImage( ::oPdfPage, oImage, 337, ::nLinhaPdf - ( 72 + 6 ), 62, 72 )
         ::DrawTexto( 71, ::nLinhaPdf - 6, 335, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
         ::DrawTexto( 71, ::nLinhaPdf - 18, 335, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 2 ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
         ::DrawTexto( 71, ::nLinhaPdf - 30, 335, NIL, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 71, ::nLinhaPdf - 38, 335, NIL, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 71, ::nLinhaPdf - 46, 335, NIL, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 71, ::nLinhaPdf - 54, 335, NIL, iif( Empty( ::cTelefoneEmitente ), "", "FONE: " + ::cTelefoneEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 71, ::nLinhaPdf - 62, 335, NIL, Trim( ::cSiteEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 71, ::nLinhaPdf - 70, 335, NIL, Trim( ::cEmailEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ENDIF
   ENDIF

   // numero nf tipo
   ::DrawBox( 400, ::nLinhaPdf - 80, 125, 80, ::nLarguraBox )
   ::DrawTexto( 401, ::nLinhaPdf - 4, 524, NIL, "DANFE", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
   ::DrawTexto( 401, ::nLinhaPdf - 16, 524, NIL, "Documento Auxiliar da", HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
   ::DrawTexto( 401, ::nLinhaPdf - 24, 524, NIL, "Nota Fiscal Eletrônica", HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )

   ::DrawTexto( 411, ::nLinhaPdf - 36, 524, NIL, "0 - ENTRADA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )
   ::DrawTexto( 411, ::nLinhaPdf - 44, 524, NIL, "1 - SAÍDA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )
   // preenchimento do tipo de nf
   ::DrawBox( 495, ::nLinhaPdf - 52, 20, 16, ::nLarguraBox )
   ::DrawTexto( 496, ::nLinhaPdf - 40, 514, NIL, ::aIde[ "tpNF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )

   ::DrawTexto( 401, ::nLinhaPdf - 56, 524, NIL, "Nº: " + Transform( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), "@R 999.999.999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 10 )
   ::DrawTexto( 401, ::nLinhaPdf - 66, 524, NIL, "SÉRIE: " + ::aIde[ "serie" ] + " - FOLHA " + AllTrim( Str( ::nFolha ) ) + "/" + AllTrim( Str( ::nLayoutTotalFolhas ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 10 )

   // codigo barras
   ::DrawBox( 525, ::nLinhaPdf - 35, 305, 35, ::nLarguraBox )
#ifdef __XHARBOUR__
   // oCode128 := HPDF_LoadType1FontFromFile(::oPdf, 'fontes\Code128bWin.afm', 'fontes\Code128bWin.pfb')
   // oCode128F := HPDF_GetFont( ::oPdf, oCode128, "FontSpecific" )
   // ::DrawTexto( 540, ::nLinhaPdf - 4.5, 815, NIL, "{" + ::cChave + "~", HPDF_TALIGN_CENTER, NIL, oCode128F, 11 )
   // ::DrawTexto( 540, ::nLinhaPdf - 19, 815, NIL, "{" + ::cChave + "~", HPDF_TALIGN_CENTER, NIL, oCode128F, 11 )
   ::DrawTexto( 540, ::nLinhaPdf - 1.5, 815, NIL, hbnfe_CodificaCode128c( ::cChave ), HPDF_TALIGN_CENTER, NIL, ::cFonteCode128F, 15 )
#else
   ::DrawBarcode( ::cChave, ::oPdfPage, 540, ::nLinhaPdf - 32, 1.0, 30 )
#endif
   // chave de acesso
   ::DrawBox( 525, ::nLinhaPdf - 55, 305, 55, ::nLarguraBox )
   ::DrawTexto( 526, ::nLinhaPdf - 36, 829, NIL, "CHAVE DE ACESSO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
   IF ::cFonteNFe == "Times"
      ::DrawTexto( 526, ::nLinhaPdf - 44, 829, NIL, Transform( ::cChave, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 9 )
   ELSE
      ::DrawTexto( 526, ::nLinhaPdf - 44, 829, NIL, Transform( ::cChave, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
   ENDIF
   // mensagem sistema sefaz
   ::DrawBox( 525, ::nLinhaPdf - 80, 305, 80, ::nLarguraBox )
   IF Empty( ::aInfProt[ "nProt" ] )
      ::DrawTexto( 526, ::nLinhaPdf - 55, 829, NIL, "N F E   A I N D A   N Ã O   F O I", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
      ::DrawTexto( 526, ::nLinhaPdf - 63, 829, NIL, "A U T O R I Z A D A   P E L A", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
      ::DrawTexto( 526, ::nLinhaPdf - 71, 829, NIL, "S E F A Z   (SEM VALIDADE FISCAL)", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
   ELSE
      ::DrawTexto( 526, ::nLinhaPdf - 55, 829, NIL, "Consulta de autenticidade no portal nacional", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
      ::DrawTexto( 526, ::nLinhaPdf - 63, 829, NIL, "da NF-e www.nfe.fazenda.gov.br/portal ou", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
      ::DrawTexto( 526, ::nLinhaPdf - 71, 829, NIL, "no site da Sefaz Autorizadora", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 8 )
   ENDIF

   ::nLinhaPdf -= 80

   // NATUREZA
   ::DrawBox( 70, ::nLinhaPdf - 16, 455, 16, ::nLarguraBox )
   ::DrawTexto( 71, ::nLinhaPdf - 1, 524, NIL, "NATUREZA DA OPERAÇÃO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 71, ::nLinhaPdf - 5, 524, NIL, ::aIde[ "natOp" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
   // PROTOCOLO
   ::DrawBox( 525, ::nLinhaPdf - 16, 305, 16, ::nLarguraBox )
   //::DrawTexto( 526, ::nLinhaPdf - 1, 829, NIL, "PROTOCOLO DE AUTORIZAÇÃO DE USO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   IF ! Empty( ::aInfProt[ "nProt" ] )
      IF ::aInfProt[ "cStat" ] == '100'
         ::DrawTexto( 526, ::nLinhaPdf - 1, 829, NIL, "PROTOCOLO DE AUTORIZAÇÃO DE USO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ELSEIF ::aInfProt[ "cStat" ] == '101' .OR. ::aInfProt[ "cStat" ] == '135'
         ::DrawTexto( 526, ::nLinhaPdf - 1, 829, NIL, "PROTOCOLO DE HOMOLOGAÇÃO DO CANCELAMENTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ENDIF
      IF ::cFonteNFe == "Times"
         ::DrawTexto( 526, ::nLinhaPdf - 6, 829, NIL, ::aInfProt[ "nProt" ] + " " + SubStr( SubStr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 9, 2 ) + "/" + SubStr( SubStr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 6, 2 ) + "/" + SubStr( SubStr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 1, 4 ) + " " + SubStr( ::aInfProt[ "dhRecbto" ], 12, 8 ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 9 )
      ELSE
         ::DrawTexto( 526, ::nLinhaPdf - 6, 829, NIL, ::aInfProt[ "nProt" ] + " " + SubStr( SubStr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 9, 2 ) + "/" + SubStr( SubStr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 6, 2 ) + "/" + SubStr( SubStr( ::aInfProt[ "dhRecbto" ], 1, 10 ), 1, 4 ) + " " + SubStr( ::aInfProt[ "dhRecbto" ], 12, 8 ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 9 )
      ENDIF
   ENDIF

   ::nLinhaPdf -= 16

   // I.E.
   ::DrawBox( 70, ::nLinhaPdf - 16, 240, 16, ::nLarguraBox )
   ::DrawTexto( 71, ::nLinhaPdf - 1, 309, NIL, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 71, ::nLinhaPdf - 5, 309, NIL, ::aEmit[ "IE" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
   // I.E. SUBS. TRIB.
   ::DrawBox( 310, ::nLinhaPdf - 16, 400, 16, ::nLarguraBox )
   ::DrawTexto( 311, ::nLinhaPdf - 1, 709, NIL, "INSCRIÇÃO ESTADUAL DO SUBS. TRIBUTÁRIO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 311, ::nLinhaPdf - 5, 709, NIL, "", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
   // CNPJ
   ::DrawBox( 710, ::nLinhaPdf - 16, 120, 16, ::nLarguraBox )
   ::DrawTexto( 711, ::nLinhaPdf - 1,  829, NIL, "C.N.P.J.", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 711, ::nLinhaPdf - 5, 829, NIL, Transform( ::aEmit[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )

   ::nLinhaPdf -= 17

   RETURN NIL

METHOD CabecalhoRetrato() CLASS hbNFeDaNFe

   LOCAL oImage

   ::DrawBox(  5, ::nLinhaPdf - 80, 585, 80, ::nLarguraBox )
   // logo/dados empresa
   ::DrawBox(  5, ::nLinhaPdf - 80, 240, 80, ::nLarguraBox )
   ::DrawTexto(  6, ::nLinhaPdf, 244, NIL, "IDENTIFICAÇÃO DO EMITENTE", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
   IF ::cLogoFile == NIL .OR. Empty( ::cLogoFile )
      ::DrawTexto(  6, ::nLinhaPdf - 6, 244, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
      ::DrawTexto(  6, ::nLinhaPdf - 18, 244, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 2 ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
      ::DrawTexto(  6, ::nLinhaPdf - 30, 244, NIL, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ::DrawTexto(  6, ::nLinhaPdf - 38, 244, NIL, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ::DrawTexto(  6, ::nLinhaPdf - 46, 244, NIL, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ::DrawTexto(  6, ::nLinhaPdf - 54, 244, NIL, iif( Empty( ::cTelefoneEmitente ), "", "FONE: " + ::cTelefoneEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ::DrawTexto(  6, ::nLinhaPdf - 62, 244, NIL, Trim( ::cSiteEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ::DrawTexto(  6, ::nLinhaPdf - 70, 244, NIL, Trim( ::cEmailEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
   ELSE
      oImage := ::LoadJPEGImage( ::oPDF, ::cLogoFile )
      IF ::nLogoStyle == _LOGO_EXPANDIDO
         HPDF_Page_DrawImage( ::oPdfPage, oImage, 6, ::nLinhaPdf - ( 72 + 6 ), 238, 72 )
      ELSEIF ::nLogoStyle == _LOGO_ESQUERDA
         HPDF_Page_DrawImage( ::oPdfPage, oImage, 6, ::nLinhaPdf - ( 72 + 6 ), 62, 72 )
         ::DrawTexto( 70, ::nLinhaPdf - 6, 244, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
         ::DrawTexto( 70, ::nLinhaPdf - 30, 244, NIL, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 70, ::nLinhaPdf - 38, 244, NIL, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 70, ::nLinhaPdf - 46, 244, NIL, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 70, ::nLinhaPdf - 54, 244, NIL, iif( Empty( ::cTelefoneEmitente ), "", "FONE: " + ::cTelefoneEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 70, ::nLinhaPdf - 62, 244, NIL, Trim( ::cSiteEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto( 70, ::nLinhaPdf - 70, 244, NIL, Trim( ::cEmailEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ELSEIF ::nLogoStyle == _LOGO_DIREITA
         HPDF_Page_DrawImage( ::oPdfPage, oImage, 182, ::nLinhaPdf - ( 72 + 6 ), 62, 72 )
         ::DrawTexto(  6, ::nLinhaPdf - 6, 180, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
         ::DrawTexto(  6, ::nLinhaPdf - 18, 180, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 2 ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
         ::DrawTexto(  6, ::nLinhaPdf - 30, 180, NIL, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto(  6, ::nLinhaPdf - 38, 180, NIL, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto(  6, ::nLinhaPdf - 46, 180, NIL, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto(  6, ::nLinhaPdf - 54, 180, NIL, iif( Empty( ::cTelefoneEmitente ), "", "FONE: " + ::cTelefoneEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto(  6, ::nLinhaPdf - 62, 180, NIL, Trim( ::cSiteEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ::DrawTexto(  6, ::nLinhaPdf - 70, 180, NIL, Trim( ::cEmailEmitente ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
      ENDIF
   ENDIF
   // numero nf tipo
   ::DrawBox( 245, ::nLinhaPdf - 80, 125, 80, ::nLarguraBox )
   ::DrawTexto( 246, ::nLinhaPdf - 4, 369, NIL, "DANFE", HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 12 )
   ::DrawTexto( 246, ::nLinhaPdf - 16, 369, NIL, "Documento Auxiliar da", HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
   ::DrawTexto( 246, ::nLinhaPdf - 24, 369, NIL, "Nota Fiscal Eletrônica", HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )

   ::DrawTexto( 256, ::nLinhaPdf - 36, 349, NIL, "0 - ENTRADA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )
   ::DrawTexto( 256, ::nLinhaPdf - 44, 349, NIL, "1 - SAÍDA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )
   // preenchimento do tipo de nf
   ::DrawBox( 340, ::nLinhaPdf - 52, 20, 16, ::nLarguraBox )
   ::DrawTexto( 341, ::nLinhaPdf - 40, 359, NIL, ::aIde[ "tpNF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )

   ::DrawTexto( 246, ::nLinhaPdf - 56, 369, NIL, "Nº: " + SubStr( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), 1, 3 ) + "." + SubStr( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), 4, 3 ) + "." + SubStr( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), 7, 3 ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 10 )
   ::DrawTexto( 246, ::nLinhaPdf - 66, 369, NIL, "SÉRIE: " + ::aIde[ "serie" ] + " - FOLHA " + AllTrim( Str( ::nFolha ) ) + "/" + AllTrim( Str( ::nLayoutTotalFolhas ) ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalhoBold, 9 )

   // codigo barras
   ::DrawBox( 370, ::nLinhaPdf - 35, 220, 35, ::nLarguraBox )
#ifdef __XHARBOUR__
   // Modificado por Anderson Camilo em 04/04/2012
   // oCode128 := HPDF_LoadType1FontFromFile(::oPdf, 'fontes\Code128bWin.afm', 'fontes\Code128bWin.pfb')
   // oCode128F := HPDF_GetFont( ::oPdf, oCode128, "FontSpecific" )
   // ::DrawTexto( 380, ::nLinhaPdf - 8, 585, NIL, "{"+::cChave+"~", HPDF_TALIGN_CENTER, NIL, oCode128F, 8 )
   // ::DrawTexto( 380, ::nLinhaPdf - 18.2, 585, NIL, "{"+::cChave+"~", HPDF_TALIGN_CENTER, NIL, oCode128F, 8 )

   ::DrawTexto( 380, ::nLinhaPdf - 2, 585, NIL, hbnfe_CodificaCode128c( ::cChave ), HPDF_TALIGN_CENTER, NIL, ::cFonteCode128F, 15 )

#else
   ::DrawBarcode( ::cChave, ::oPdfPage, 385, ::nLinhaPdf - 32, 0.7, 30 )
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

   // NATUREZA
   ::DrawBox(  5, ::nLinhaPdf - 16, 365, 16, ::nLarguraBox )
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

   // I.E.
   ::DrawBox(  5, ::nLinhaPdf - 16, 240, 16, ::nLarguraBox )
   ::DrawTexto( 6, ::nLinhaPdf - 1,  244, NIL, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 6, ::nLinhaPdf - 5, 244, NIL, ::aEmit[ "IE" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
   // I.E. SUBS. TRIB.
   ::DrawBox( 245, ::nLinhaPdf - 16, 225, 16, ::nLarguraBox )
   ::DrawTexto( 246, ::nLinhaPdf - 1,  419, NIL, "INSCRIÇÃO ESTADUAL DO SUBS. TRIBUTÁRIO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 246, ::nLinhaPdf - 5, 419, NIL, "", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
   // CNPJ
   ::DrawBox( 470, ::nLinhaPdf - 16, 120, 16, ::nLarguraBox )
   ::DrawTexto( 471, ::nLinhaPdf - 1,  589, NIL, "C.N.P.J.", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
   ::DrawTexto( 471, ::nLinhaPdf - 5, 589, NIL, Transform( ::aEmit[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )

   ::nLinhaPdf -= 17

   RETURN NIL

METHOD Destinatario() CLASS hbNFeDaNFe

   IF ::lPaisagem
      ::DrawTexto( 70, ::nLinhaPdf, 830, NIL, "DESTINATÁRIO/REMETENTE", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )

      ::nLinhaPdf -= 6

      // RAZAO SOCIAL
      ::DrawBox( 70, ::nLinhaPdf - 16, 590, 16, ::nLarguraBox )
      ::DrawTexto( 71, ::nLinhaPdf - 1,  659, NIL, "NOME / RAZÃO SOCIAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 71, ::nLinhaPdf - 5, 659, NIL, ::aDest[ "xNome" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
      // CNPJ/CPF
      ::DrawBox( 660, ::nLinhaPdf - 16, 100, 16, ::nLarguraBox )
      ::DrawTexto( 661, ::nLinhaPdf - 1,  759, NIL, "CNPJ/CPF", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      IF ! Empty( ::aDest[ "CNPJ" ] )
         ::DrawTexto( 661, ::nLinhaPdf - 5, 759, NIL, Transform( ::aDest[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 9 )
      ELSE
         IF ! Empty( ::aDest[ "CPF" ] )
            ::DrawTexto( 661, ::nLinhaPdf - 5, 759, NIL, Transform( ::aDest[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         ENDIF
      ENDIF
      // DATA DE EMISSAO
      ::DrawBox( 760, ::nLinhaPdf - 16, 70, 16, ::nLarguraBox )
      ::DrawTexto( 761, ::nLinhaPdf - 1,  829, NIL, "DATA DE EMISSÃO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 761, ::nLinhaPdf - 5, 829, NIL, SubStr( ::aIde[ "dhEmi" ], 9, 2 ) + "/" + SubStr( ::aIde[ "dhEmi" ], 6, 2 ) + "/" + SubStr( ::aIde[ "dhEmi" ], 1, 4 ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 16

      // ENDEREÇO
      ::DrawBox( 70, ::nLinhaPdf - 16, 440, 16, ::nLarguraBox )
      ::DrawTexto( 71, ::nLinhaPdf - 1,  509, NIL, "ENDEREÇO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 71, ::nLinhaPdf - 5, 509, NIL, ::aDest[ "xLgr" ] + " " + ::aDest[ "nro" ] + " " + ::aDest[ "xCpl" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )
      // BAIRRO
      ::DrawBox( 510, ::nLinhaPdf - 16, 190, 16, ::nLarguraBox )
      ::DrawTexto( 511, ::nLinhaPdf - 1,  699, NIL, "BAIRRO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 511, ::nLinhaPdf - 5, 699, NIL, ::aDest[ "xBairro" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
      // CEP
      ::DrawBox( 700, ::nLinhaPdf - 16, 60, 16, ::nLarguraBox )
      ::DrawTexto( 701, ::nLinhaPdf - 1,  759, NIL, "C.E.P.", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )

      ::DrawTexto( 704, ::nLinhaPdf - 5, 759, NIL, Transform( ::aDest[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
      // DATA DE SAIDA/ENTRADA
      ::DrawBox( 760, ::nLinhaPdf - 16, 70, 16, ::nLarguraBox )
      ::DrawTexto( 761, ::nLinhaPdf - 1,  829, NIL, "DATA SAIDA/ENTRADA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 761, ::nLinhaPdf - 5, 829, NIL, SubStr( ::aIde[ "dhSaiEnt" ], 9, 2 ) + "/" + SubStr( ::aIde[ "dhSaiEnt" ], 6, 2 ) + "/" + SubStr( ::aIde[ "dhSaiEnt" ], 1, 4 ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 16

      // MUNICIPIO
      ::DrawBox( 70, ::nLinhaPdf - 16, 410, 16, ::nLarguraBox )
      ::DrawTexto( 71, ::nLinhaPdf - 1,  479, NIL, "MUNICIPIO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 71, ::nLinhaPdf - 5, 479, NIL, ::aDest[ "xMun" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
      // FONE/FAX
      ::DrawBox( 480, ::nLinhaPdf - 16, 150, 16, ::nLarguraBox )
      ::DrawTexto( 481, ::nLinhaPdf - 1,  629, NIL, "FONE/FAX", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 481, ::nLinhaPdf - 5, 629, NIL, FormatTelefone( ::aDest[ "fone" ] ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
      // ESTADO
      ::DrawBox( 630, ::nLinhaPdf - 16, 30, 16, ::nLarguraBox )
      ::DrawTexto( 631, ::nLinhaPdf - 1,  659, NIL, "ESTADO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 631, ::nLinhaPdf - 5, 659, NIL, ::aDest[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
      // INSC. EST.
      ::DrawBox( 660, ::nLinhaPdf - 16, 100, 16, ::nLarguraBox )
      ::DrawTexto( 661, ::nLinhaPdf - 1,  759, NIL, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 661, ::nLinhaPdf - 5, 759, NIL, ::aDest[ "IE" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
      // DATA DE SAIDA/ENTRADA
      ::DrawBox( 760, ::nLinhaPdf - 16, 70, 16, ::nLarguraBox )
      ::DrawTexto( 761, ::nLinhaPdf - 1,  829, NIL, "HORA DE SAIDA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 761, ::nLinhaPdf - 5, 589, NIL, SubStr( ::aIde[ "dhSaiEnt" ], 9, 2 ) + "/" + SubStr( ::aIde[ "dhSaiEnt" ], 6, 2 ) + "/" + SubStr( ::aIde[ "dhSaiEnt" ], 1, 4 ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 17
   ELSE
      ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "DESTINATÁRIO/REMETENTE", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )

      ::nLinhaPdf -= 6

      // RAZAO SOCIAL
      ::DrawBox(  5, ::nLinhaPdf - 16, 415, 16, ::nLarguraBox )
      ::DrawTexto( 6, ::nLinhaPdf - 1,  419, NIL, "NOME / RAZÃO SOCIAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 6, ::nLinhaPdf - 5, 419, NIL, ::aDest[ "xNome" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
      // CNPJ/CPF
      ::DrawBox( 420, ::nLinhaPdf - 16, 100, 16, ::nLarguraBox )
      ::DrawTexto( 421, ::nLinhaPdf - 1,  519, NIL, "CNPJ/CPF", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      IF !Empty( ::aDest[ "CNPJ" ] )
         ::DrawTexto( 421, ::nLinhaPdf - 5, 519, NIL, Transform( ::aDest[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 9 )
      ELSE
         IF ::aDest[ "CPF" ] <> NIL
            ::DrawTexto( 421, ::nLinhaPdf - 5, 519, NIL, Transform( ::aDest[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         ENDIF
      ENDIF
      // DATA DE EMISSAO
      ::DrawBox( 520, ::nLinhaPdf - 16, 70, 16, ::nLarguraBox )
      ::DrawTexto( 521, ::nLinhaPdf - 1,  589, NIL, "DATA DE EMISSÃO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 521, ::nLinhaPdf - 5, 589, NIL, SubStr( ::aIde[ "dhEmi" ], 9, 2 ) + "/" + SubStr( ::aIde[ "dhEmi" ], 6, 2 ) + "/" + SubStr( ::aIde[ "dhEmi" ], 1, 4 ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 16

      // ENDEREÇO
      ::DrawBox(  5, ::nLinhaPdf - 16, 265, 16, ::nLarguraBox )
      ::DrawTexto( 6, ::nLinhaPdf - 1,  269, NIL, "ENDEREÇO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 6, ::nLinhaPdf - 5, 269, NIL, ::aDest[ "xLgr" ] + " " + ::aDest[ "nro" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )
      // BAIRRO
      ::DrawBox( 270, ::nLinhaPdf - 16, 190, 16, ::nLarguraBox )
      ::DrawTexto( 271, ::nLinhaPdf - 1,  459, NIL, "BAIRRO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 271, ::nLinhaPdf - 5, 459, NIL, ::aDest[ "xBairro" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
      // CEP
      ::DrawBox( 460, ::nLinhaPdf - 16, 60, 16, ::nLarguraBox )
      ::DrawTexto( 461, ::nLinhaPdf - 1,  519, NIL, "C.E.P.", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 461, ::nLinhaPdf - 5, 519, NIL, Transform( ::aDest[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
      // DATA DE SAIDA/ENTRADA
      ::DrawBox( 520, ::nLinhaPdf - 16, 70, 16, ::nLarguraBox )
      ::DrawTexto( 521, ::nLinhaPdf - 1,  589, NIL, "DATA SAIDA/ENTRADA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 521, ::nLinhaPdf - 5, 589, NIL, SubStr( ::aIde[ "dhSaiEnt" ], 9, 2 ) + "/" + SubStr( ::aIde[ "dhSaiEnt" ], 6, 2 ) + "/" + SubStr( ::aIde[ "dhSaiEnt" ], 1, 4 ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 16

      // MUNICIPIO
      ::DrawBox(  5, ::nLinhaPdf - 16, 245, 16, ::nLarguraBox )
      ::DrawTexto( 6, ::nLinhaPdf - 1,  249, NIL, "MUNICIPIO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 6, ::nLinhaPdf - 5, 249, NIL, ::aDest[ "xMun" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
      // FONE/FAX
      ::DrawBox( 250, ::nLinhaPdf - 16, 150, 16, ::nLarguraBox )
      ::DrawTexto( 251, ::nLinhaPdf - 1,  399, NIL, "FONE/FAX", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 251, ::nLinhaPdf - 5, 399, NIL, FormatTelefone( ::aDest[ "fone" ] ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
      // ESTADO
      ::DrawBox( 400, ::nLinhaPdf - 16, 30, 16, ::nLarguraBox )
      ::DrawTexto( 401, ::nLinhaPdf - 1,  429, NIL, "ESTADO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 401, ::nLinhaPdf - 5, 429, NIL, ::aDest[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
      // INSC. EST.
      ::DrawBox( 430, ::nLinhaPdf - 16, 90, 16, ::nLarguraBox )
      ::DrawTexto( 431, ::nLinhaPdf - 1,  519, NIL, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 431, ::nLinhaPdf - 5, 519, NIL, ::aDest[ "IE" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
      // DATA DE SAIDA/ENTRADA
      ::DrawBox( 520, ::nLinhaPdf - 16, 70, 16, ::nLarguraBox )
      ::DrawTexto( 521, ::nLinhaPdf - 1,  589, NIL, "HORA DE SAIDA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
      ::DrawTexto( 521, ::nLinhaPdf - 5, 589, NIL, SubStr( ::aIde[ "dhSaiEnt" ], 12, 8 ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

      ::nLinhaPdf -= 17
   ENDIF

   RETURN NIL

METHOD Duplicatas() CLASS hbNFeDaNFe

   LOCAL nICob, nItensCob, nLinhaFinalCob, nTamanhoCob

   IF ::nFolha == 1
      IF ::lPaisagem
         ::DrawTexto( 70, ::nLinhaPdf, 760, NIL, "FATURA/DUPLICATAS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )
         ::nLinhaPdf -= 6

         IF Empty( ::cCobranca )
            // FATURAS
            ::DrawBox( 70, ::nLinhaPdf - 12, 760, 12, ::nLarguraBox )
            IF ::aIde[ "indPag" ] == "0"
               ::DrawTexto( 71, ::nLinhaPdf - 1,  824, NIL, "PAGAMENTO À VISTA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
            ELSEIF ::aIde[ "indPag" ] == "1"
               ::DrawTexto( 71, ::nLinhaPdf - 1,  824, NIL, "PAGAMENTO À PRAZO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
            ELSE
               ::DrawTexto( 71, ::nLinhaPdf - 1,  824, NIL, "OUTROS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
            ENDIF
            ::nLinhaPdf -= 13
         ELSE
            nICob := Len( hb_ATokens( ::cCobranca, "<dup>", .F., .F. ) ) - 1
            IF nICob < 0
               nICob := 0
            ENDIF
            nItensCob := Int( nIcob / 4 ) + IF( ( nIcob / 4 ) -Int( ( nICob / 4 ) ) > 0, 1, 0 ) + 1
            nLinhaFinalCob := ::nLinhaPdf - ( nItensCob * 7 ) - 2
            nTamanhoCob := ( nItensCob * 7 ) + 2
            ::cabecalhoCobranca( nLinhaFinalCob, nTamanhoCob )
            ::faturas()
            ::nLinhaPdf -= 4 // ESPAÇO
         ENDIF
      ELSE
         ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "FATURA/DUPLICATAS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )
         ::nLinhaPdf -= 6

         IF Empty( ::cCobranca )
            // FATURAS
            ::DrawBox(  5, ::nLinhaPdf - 12, 585, 12, ::nLarguraBox )
            IF ::aIde[ "indPag" ] == "0"
               ::DrawTexto( 6, ::nLinhaPdf - 1,  589, NIL, "PAGAMENTO À VISTA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
            ELSEIF ::aIde[ "indPag" ] == "1"
               ::DrawTexto( 6, ::nLinhaPdf - 1,  589, NIL, "PAGAMENTO À PRAZO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
            ELSE
               ::DrawTexto( 6, ::nLinhaPdf - 1,  589, NIL, "OUTROS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
            ENDIF
            ::nLinhaPdf -= 13
         ELSE
            nICob := Len( hb_ATokens( ::cCobranca, "<dup>", .F., .F. ) ) - 1
            IF nICob < 0
               nICob := 0
            ENDIF
            nItensCob := Int( nIcob / 3 ) + IF( ( nIcob / 3 ) -Int( ( nICob / 3 ) ) > 0, 1, 0 ) + 1
            nLinhaFinalCob := ::nLinhaPdf - ( nItensCob * 7 ) - 2
            nTamanhoCob := ( nItensCob * 7 ) + 2
            ::CabecalhoCobranca( nLinhaFinalCob, nTamanhoCob )
            ::Faturas()
            ::nLinhaPdf -= 4 // ESPAÇO
         ENDIF
      ENDIF
   ENDIF

   RETURN NIL

METHOD CabecalhoCobranca( nLinhaFinalCob, nTamanhoCob ) CLASS hbNFeDaNFe

   LOCAL nTamForm

   IF ::nFolha == 1
      IF ::lPaisagem
         nTamForm := 830 - 70

         // COLUNA 1
         ::DrawBox(  70, nLinhaFinalCob, ( ( nTamForm ) / 4 ), nTamanhoCob, ::nLarguraBox )
         ::DrawTexto( 71, ::nLinhaPdf - 1,  126, NIL, "NÚMERO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 128, ::nLinhaPdf - 1,  183, NIL, "VENCIMENTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 185, ::nLinhaPdf - 1,  259, NIL, "VALOR", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         // COLUNA 2
         ::DrawBox( 70 + ( ( nTamForm ) / 4 ), nLinhaFinalCob, ( ( nTamForm ) / 4 ), nTamanhoCob, ::nLarguraBox )
         ::DrawTexto( 71 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1, 126 + ( ( nTamForm ) / 4 ), NIL, "NÚMERO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 128 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1, 183 + ( ( nTamForm ) / 4 ), NIL, "VENCIMENTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 185 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1, 259 + ( ( nTamForm ) / 4 ), NIL, "VALOR", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         // COLUNA 3
         ::DrawBox( 70 + ( ( ( nTamForm ) / 4 ) * 2 ), nLinhaFinalCob, ( ( nTamForm ) / 4 ), nTamanhoCob, ::nLarguraBox )
         ::DrawTexto( 71 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1, 126 + ( ( ( nTamForm ) / 4 ) * 2 ), NIL, "NÚMERO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 128 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1, 183 + ( ( ( nTamForm ) / 4 ) * 2 ), NIL, "VENCIMENTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 185 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1, 259 + ( ( ( nTamForm ) / 4 ) * 2 ), NIL, "VALOR", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         // COLUNA 4
         ::DrawBox( 70 + ( ( ( nTamForm ) / 4 ) * 3 ), nLinhaFinalCob, ( ( nTamForm ) / 4 ), nTamanhoCob, ::nLarguraBox )
         ::DrawTexto( 71 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1, 126 + ( ( ( nTamForm ) / 4 ) * 3 ), NIL, "NÚMERO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 128 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1, 183 + ( ( ( nTamForm ) / 4 ) * 3 ), NIL, "VENCIMENTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 185 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1, 259 + ( ( ( nTamForm ) / 4 ) * 3 ), NIL, "VALOR", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::nLinhaPdf -= 6

         // COLUNA 1
         ::DrawLine(  71, ::nLinhaPdf - 1.5, 126, ::nLinhaPdf - 1.5, ::nLarguraBox )
         ::DrawLine(  128, ::nLinhaPdf - 1.5, 183, ::nLinhaPdf - 1.5, ::nLarguraBox )
         ::DrawLine(  185, ::nLinhaPdf - 1.5, 259, ::nLinhaPdf - 1.5, ::nLarguraBox )
         // COLUNA 2
         ::DrawLine(  71 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1.5, 126 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1.5, ::nLarguraBox )
         ::DrawLine(  128 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1.5, 183 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1.5, ::nLarguraBox )
         ::DrawLine(  185 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1.5, 259 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1.5, ::nLarguraBox )
         // COLUNA 3
         ::DrawLine(  71 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1.5, 126 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1.5, ::nLarguraBox )
         ::DrawLine(  128 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1.5, 183 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1.5, ::nLarguraBox )
         ::DrawLine(  185 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1.5, 259 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1.5, ::nLarguraBox )
         // COLUNA 4
         ::DrawLine(  71 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1.5, 126 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1.5, ::nLarguraBox )
         ::DrawLine(  128 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1.5, 183 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1.5, ::nLarguraBox )
         ::DrawLine(  185 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1.5, 259 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1.5, ::nLarguraBox )

         ::nLinhaPdf -= 2 // ESPAÇO
      ELSE
         nTamForm := 585

         // COLUNA 1
         ::DrawBox(  5, nLinhaFinalCob, ( ( nTamForm ) / 3 ), nTamanhoCob, ::nLarguraBox )
         ::DrawTexto(  6, ::nLinhaPdf - 1,   61, NIL, "NÚMERO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 63, ::nLinhaPdf - 1,  118, NIL, "VENCIMENTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 120, ::nLinhaPdf - 1,  195, NIL, "VALOR", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         // COLUNA 2
         ::DrawBox( 5 + ( ( nTamForm ) / 3 ), nLinhaFinalCob, ( ( nTamForm ) / 3 ), nTamanhoCob, ::nLarguraBox )
         ::DrawTexto(  6 + ( ( nTamForm ) / 3 ), ::nLinhaPdf - 1,  61 + ( ( nTamForm ) / 3 ), NIL, "NÚMERO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 63 + ( ( nTamForm ) / 3 ), ::nLinhaPdf - 1, 118 + ( ( nTamForm ) / 3 ), NIL, "VENCIMENTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 120 + ( ( nTamForm ) / 3 ), ::nLinhaPdf - 1, 195 + ( ( nTamForm ) / 3 ), NIL, "VALOR", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         // COLUNA 3
         ::DrawBox( 5 + ( ( ( nTamForm ) / 3 ) * 2 ), nLinhaFinalCob, ( ( nTamForm ) / 3 ), nTamanhoCob, ::nLarguraBox )
         ::DrawTexto(  6 + ( ( ( nTamForm ) / 3 ) * 2 ), ::nLinhaPdf - 1,  61 + ( ( ( nTamForm ) / 3 ) * 2 ), NIL, "NÚMERO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 63 + ( ( ( nTamForm ) / 3 ) * 2 ), ::nLinhaPdf - 1, 118 + ( ( ( nTamForm ) / 3 ) * 2 ), NIL, "VENCIMENTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 120 + ( ( ( nTamForm ) / 3 ) * 2 ), ::nLinhaPdf - 1, 195 + ( ( ( nTamForm ) / 3 ) * 2 ), NIL, "VALOR", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::nLinhaPdf -= 6

         // COLUNA 1
         ::DrawLine(  6, ::nLinhaPdf - 1.5,  61, ::nLinhaPdf - 1.5, ::nLarguraBox )
         ::DrawLine(  63, ::nLinhaPdf - 1.5, 118, ::nLinhaPdf - 1.5, ::nLarguraBox )
         ::DrawLine(  120, ::nLinhaPdf - 1.5, 195, ::nLinhaPdf - 1.5, ::nLarguraBox )
         // COLUNA 2
         ::DrawLine(  6 + ( ( nTamForm ) / 3 ), ::nLinhaPdf - 1.5,  61 + ( ( nTamForm ) / 3 ), ::nLinhaPdf - 1.5, ::nLarguraBox )
         ::DrawLine(  63 + ( ( nTamForm ) / 3 ), ::nLinhaPdf - 1.5, 118 + ( ( nTamForm ) / 3 ), ::nLinhaPdf - 1.5, ::nLarguraBox )
         ::DrawLine(  120 + ( ( nTamForm ) / 3 ), ::nLinhaPdf - 1.5, 195 + ( ( nTamForm ) / 3 ), ::nLinhaPdf - 1.5, ::nLarguraBox )
         // COLUNA 3
         ::DrawLine(  6 + ( ( ( nTamForm ) / 3 ) * 2 ), ::nLinhaPdf - 1.5,  61 + ( ( ( nTamForm ) / 3 ) * 2 ), ::nLinhaPdf - 1.5, ::nLarguraBox )
         ::DrawLine(  63 + ( ( ( nTamForm ) / 3 ) * 2 ), ::nLinhaPdf - 1.5, 118 + ( ( ( nTamForm ) / 3 ) * 2 ), ::nLinhaPdf - 1.5, ::nLarguraBox )
         ::Drawline(  120 + ( ( ( nTamForm ) / 3 ) * 2 ), ::nLinhaPdf - 1.5, 195 + ( ( ( nTamForm ) / 3 ) * 2 ), ::nLinhaPdf - 1.5, ::nLarguraBox )

         ::nLinhaPdf -= 2 // ESPAÇO
      ENDIF
   ENDIF

   RETURN NIL

METHOD Faturas() CLASS hbNFeDaNFe

   LOCAL nTamForm, cDups, nColuna, cDup, cNumero, cVencimento, cValor // ////////////////////////// nI

   IF ::nFolha == 1
      IF ::lPaisagem
         nTamForm := 830 - 70

         cDups := ::cCobranca
         nColuna := 0
         DO WHILE At( "<dup>", cDups ) > 0
            nColuna++
            cDup := XmlNode( cDups, "dup" )

            cNumero := XmlNode( cDup, "nDup" )
            IF ! Empty( cNumero )
               cVencimento := XmlNode( cDup, "dVenc" )
               cVencimento := SubStr( cVencimento, 9, 2 ) + "/" + SubStr( cVencimento, 6, 2 ) + "/" + SubStr( cVencimento, 1, 4 )
               cValor := AllTrim( FormatNumber( Val( XmlNode( cDup, "vDup" ) ), 13, 2 ) )
            ELSE
               nColuna--
               EXIT
            ENDIF
            IF nColuna == 1
               ::DrawTexto( 71, ::nLinhaPdf - 1,  126, NIL, cNumero, HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
               ::DrawTexto( 128, ::nLinhaPdf - 1,  183, NIL, cVencimento, HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 7 )
               ::DrawTexto( 185, ::nLinhaPdf - 1,  259, NIL, cValor, HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 7 )
            ELSEIF nColuna == 2
               ::DrawTexto( 71 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1, 126 + ( ( nTamForm ) / 4 ), NIL, cNumero, HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
               ::DrawTexto( 128 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1, 183 + ( ( nTamForm ) / 4 ), NIL, cVencimento, HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 7 )
               ::DrawTexto( 185 + ( ( nTamForm ) / 4 ), ::nLinhaPdf - 1, 259 + ( ( nTamForm ) / 4 ), NIL, cValor, HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 7 )
            ELSEIF nColuna == 3
               ::DrawTexto( 71 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1, 126 + ( ( ( nTamForm ) / 4 ) * 2 ), NIL, cNumero, HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
               ::DrawTexto( 128 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1, 183 + ( ( ( nTamForm ) / 4 ) * 2 ), NIL, cVencimento, HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 7 )
               ::DrawTexto( 185 + ( ( ( nTamForm ) / 4 ) * 2 ), ::nLinhaPdf - 1, 259 + ( ( ( nTamForm ) / 4 ) * 2 ), NIL, cValor, HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 7 )
            ELSEIF nColuna == 4
               ::DrawTexto( 71 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1, 126 + ( ( ( nTamForm ) / 4 ) * 3 ), NIL, cNumero, HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
               ::DrawTexto( 128 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1, 183 + ( ( ( nTamForm ) / 4 ) * 3 ), NIL, cVencimento, HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 7 )
               ::DrawTexto( 185 + ( ( ( nTamForm ) / 4 ) * 3 ), ::nLinhaPdf - 1, 259 + ( ( ( nTamForm ) / 4 ) * 3 ), NIL, cValor, HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 7 )
               ::nLinhaPdf -= 7
               nColuna := 0
            ENDIF
            cDups := SubStr( cDups, At( "</dup>", ::cCobranca ) + 1 )
         ENDDO
         IF nColuna > 0
            ::nLinhaPdf -= 7
         ENDIF

      ELSE
         nTamForm := 585

         cDups := ::cCobranca
         nColuna := 0
         DO WHILE At( "<dup>", cDups ) > 0
            nColuna++
            cDup := XmlNode( cDups, "dup" )

            cNumero := XmlNode( cDup, "nDup" )
            IF ! Empty( cNumero )
               cVencimento := XmlNode( cDup, "dVenc" )
               cVencimento := SubStr( cVencimento, 9, 2 ) + "/" + SubStr( cVencimento, 6, 2 ) + "/" + SubStr( cVencimento, 1, 4 )
               cValor := AllTrim( FormatNumber( Val( XmlNode( cDup, "vDup" ) ), 13, 2 ) )
            ELSE
               nColuna--
               EXIT
            ENDIF
            IF nColuna == 1
               ::DrawTexto(  6, ::nLinhaPdf - 1,   61, NIL, cNumero, HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
               ::DrawTexto( 63, ::nLinhaPdf - 1,  118, NIL, cVencimento, HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 7 )
               ::DrawTexto( 120, ::nLinhaPdf - 1,  195, NIL, cValor, HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 7 )
            ELSEIF nColuna == 2
               ::DrawTexto(  6 + ( ( nTamForm ) / 3 ), ::nLinhaPdf - 1,  61 + ( ( nTamForm ) / 3 ), NIL, cNumero, HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
               ::DrawTexto( 63 + ( ( nTamForm ) / 3 ), ::nLinhaPdf - 1, 118 + ( ( nTamForm ) / 3 ), NIL, cVencimento, HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 7 )
               ::DrawTexto( 120 + ( ( nTamForm ) / 3 ), ::nLinhaPdf - 1, 195 + ( ( nTamForm ) / 3 ), NIL, cValor, HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 7 )
            ELSEIF nColuna == 3
               ::DrawTexto(  6 + ( ( ( nTamForm ) / 3 ) * 2 ), ::nLinhaPdf - 1,  61 + ( ( ( nTamForm ) / 3 ) * 2 ), NIL, cNumero, HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
               ::DrawTexto( 63 + ( ( ( nTamForm ) / 3 ) * 2 ), ::nLinhaPdf - 1, 118 + ( ( ( nTamForm ) / 3 ) * 2 ), NIL, cVencimento, HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 7 )
               ::DrawTexto( 120 + ( ( ( nTamForm ) / 3 ) * 2 ), ::nLinhaPdf - 1, 195 + ( ( ( nTamForm ) / 3 ) * 2 ), NIL, cValor, HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 7 )
               ::nLinhaPdf -= 7
               nColuna := 0
            ENDIF
            cDups := SubStr( cDups, At( "</dup>", ::cCobranca ) + 1 )
         ENDDO
         IF nColuna > 0
            ::nLinhaPdf -= 7
         ENDIF

      ENDIF
   ENDIF

   RETURN NIL

METHOD DadosImposto() CLASS hbNFeDaNFe

   IF ::nFolha == 1
      IF ::lPaisagem
         ::DrawTexto( 70, ::nLinhaPdf, 830, NIL, "CÁLCULO DO IMPOSTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )

         ::nLinhaPdf -= 6

         // BASE DE CALCULO DO ICMS
         ::DrawBox( 70, ::nLinhaPdf - 16, 145, 16, ::nLarguraBox )
         ::DrawTexto( 71, ::nLinhaPdf - 1,  149, NIL, "BASE DE CÁLCULO DO ICMS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 71, ::nLinhaPdf - 5, 149, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vBC" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // VALOR ICMS
         ::DrawBox( 215, ::nLinhaPdf - 16, 135, 16, ::nLarguraBox )
         ::DrawTexto( 216, ::nLinhaPdf - 1,  349, NIL, "VALOR DO ICMS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 216, ::nLinhaPdf - 5, 349, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vICMS" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // BASE DE CALCULO DO ICMS ST
         ::DrawBox( 350, ::nLinhaPdf - 16, 165, 16, ::nLarguraBox )
         ::DrawTexto( 351, ::nLinhaPdf - 1,  514, NIL, "BASE DE CÁLCULO DO ICMS SUBS. TRIB.", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 351, ::nLinhaPdf - 5, 514, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vBCST" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // VALOR ICMS ST
         ::DrawBox( 515, ::nLinhaPdf - 16, 135, 16, ::nLarguraBox )
         ::DrawTexto( 516, ::nLinhaPdf - 1,  649, NIL, "VALOR DO ICMS SUBST.", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 516, ::nLinhaPdf - 5, 649, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vST" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // VALOR TOTAL DOS PRODUTOS
         ::DrawBox( 650, ::nLinhaPdf - 16, 180, 16, ::nLarguraBox )
         ::DrawTexto( 651, ::nLinhaPdf - 1,  829, NIL, "VALOR TOTAL DOS PRODUTOS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 651, ::nLinhaPdf - 5, 8299, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vProd" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 16

         // VALOR DO FRETE
         ::DrawBox( 70, ::nLinhaPdf - 16, 116, 16, ::nLarguraBox )
         ::DrawTexto( 71, ::nLinhaPdf - 1, 185, NIL, "VALOR DO FRETE", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 71, ::nLinhaPdf - 5, 185, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vFrete" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // VALOR DO SEGURO
         ::DrawBox( 186, ::nLinhaPdf - 16, 116, 16, ::nLarguraBox )
         ::DrawTexto( 187, ::nLinhaPdf - 1,  301, NIL, "VALOR DO SEGURO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 187, ::nLinhaPdf - 5, 301, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vSeg" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // DESCONTO
         ::DrawBox( 302, ::nLinhaPdf - 16, 116, 16, ::nLarguraBox )
         ::DrawTexto( 303, ::nLinhaPdf - 1,  417, NIL, "DESCONTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 303, ::nLinhaPdf - 5, 417, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vDesc" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // OUTRAS DESP. ACESSO.
         ::DrawBox( 418, ::nLinhaPdf - 16, 116, 16, ::nLarguraBox )
         ::DrawTexto( 419, ::nLinhaPdf - 1,  533, NIL, "OUTRAS DESP. ACESSÓRIAS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 419, ::nLinhaPdf - 5, 533, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vOutro" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // VALOR DO IPI
         ::DrawBox( 534, ::nLinhaPdf - 16, 116, 16, ::nLarguraBox )
         ::DrawTexto( 535, ::nLinhaPdf - 1,  649, NIL, "VALOR DO IPI", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 535, ::nLinhaPdf - 5, 649, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vIPI" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // VALOR TOTAL DA NF
         ::DrawBox( 650, ::nLinhaPdf - 16, 180, 16, ::nLarguraBox )
         ::DrawTexto( 651, ::nLinhaPdf - 1,  829, NIL, "VALOR TOTAL DA NOTA FISCAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 651, ::nLinhaPdf - 5, 829, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vNF" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 17
      ELSE
         ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "CÁLCULO DO IMPOSTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )

         ::nLinhaPdf -= 6

         // BASE DE CALCULO DO ICMS
         ::DrawBox( 5, ::nLinhaPdf - 16, 110, 16, ::nLarguraBox )
         ::DrawTexto( 6, ::nLinhaPdf - 1,  114, NIL, "BASE DE CÁLCULO DO ICMS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 6, ::nLinhaPdf - 5, 114, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vBC" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // VALOR ICMS
         ::DrawBox( 115, ::nLinhaPdf - 16, 100, 16, ::nLarguraBox )
         ::DrawTexto( 116, ::nLinhaPdf - 1,  214, NIL, "VALOR DO ICMS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 116, ::nLinhaPdf - 5, 214, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vICMS" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // BASE DE CALCULO DO ICMS ST
         ::DrawBox( 215, ::nLinhaPdf - 16, 130, 16, ::nLarguraBox )
         ::DrawTexto( 216, ::nLinhaPdf - 1,  344, NIL, "BASE DE CÁLCULO DO ICMS SUBS. TRIB.", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 216, ::nLinhaPdf - 5, 344, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vBCST" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // VALOR ICMS ST
         ::DrawBox( 345, ::nLinhaPdf - 16, 100, 16, ::nLarguraBox )
         ::DrawTexto( 346, ::nLinhaPdf - 1,  444, NIL, "VALOR DO ICMS SUBST.", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 346, ::nLinhaPdf - 5, 444, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vST" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // VALOR TOTAL DOS PRODUTOS
         ::DrawBox( 445, ::nLinhaPdf - 16, 145, 16, ::nLarguraBox )
         ::DrawTexto( 446, ::nLinhaPdf - 1,  589, NIL, "VALOR TOTAL DOS PRODUTOS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 446, ::nLinhaPdf - 5, 589, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vProd" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 16

         // VALOR DO FRETE
         ::DrawBox( 5, ::nLinhaPdf - 16, 88, 16, ::nLarguraBox )
         ::DrawTexto( 6, ::nLinhaPdf - 1,  92, NIL, "VALOR DO FRETE", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 6, ::nLinhaPdf - 5, 92, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vFrete" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // VALOR DO SEGURO
         ::DrawBox( 93, ::nLinhaPdf - 16, 88, 16, ::nLarguraBox )
         ::DrawTexto( 94, ::nLinhaPdf - 1,  180, NIL, "VALOR DO SEGURO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 94, ::nLinhaPdf - 5, 180, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vSeg" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // DESCONTO
         ::DrawBox( 181, ::nLinhaPdf - 16, 88, 16, ::nLarguraBox )
         ::DrawTexto( 182, ::nLinhaPdf - 1,  268, NIL, "DESCONTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 182, ::nLinhaPdf - 5, 268, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vDesc" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // OUTRAS DESP. ACESSO.
         ::DrawBox( 269, ::nLinhaPdf - 16, 88, 16, ::nLarguraBox )
         ::DrawTexto( 270, ::nLinhaPdf - 1,  356, NIL, "OUTRAS DESP. ACESSÓRIAS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 270, ::nLinhaPdf - 5, 356, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vOutro" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // VALOR DO IPI
         ::DrawBox( 357, ::nLinhaPdf - 16, 88, 16, ::nLarguraBox )
         ::DrawTexto( 358, ::nLinhaPdf - 1,  444, NIL, "VALOR DO IPI", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 358, ::nLinhaPdf - 5, 444, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vIPI" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // VALOR TOTAL DA NF
         ::DrawBox( 445, ::nLinhaPdf - 16, 145, 16, ::nLarguraBox )
         ::DrawTexto( 446, ::nLinhaPdf - 1,  589, NIL, "VALOR TOTAL DA NOTA FISCAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 446, ::nLinhaPdf - 5, 589, NIL, AllTrim( FormatNumber( Val( ::aICMSTotal[ "vNF" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 17
      ENDIF
   ENDIF

   RETURN NIL

METHOD DadosTransporte() CLASS hbNFeDaNFe

   IF ::nFolha == 1
      IF ::lPaisagem
         ::DrawTexto( 70, ::nLinhaPdf, 830, NIL, "TRANSPORTADOR / VOLUMES TRANSPORTADOS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )

         ::nLinhaPdf -= 6

         // NOME/RAZAO SOCIAL
         ::DrawBox( 70, ::nLinhaPdf - 16, 410, 16, ::nLarguraBox )
         ::DrawTexto( 71, ::nLinhaPdf - 1,  429, NIL, "NOME/RAZÃO SOCIAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 71, ::nLinhaPdf - 7, 429, NIL, ::aTransp[ "xNome" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )
         // TIPO FRETE
         ::DrawBox( 430, ::nLinhaPdf - 16, 100, 16, ::nLarguraBox )
         ::DrawTexto( 431, ::nLinhaPdf - 1,  529, NIL, "FRETE POR CONTA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         // Modificado por Anderson Camilo em 19/03/2012
         IF ::aTransp[ "modFrete" ] == "0"
            ::DrawTexto( 431, ::nLinhaPdf - 5, 529, NIL, "0-EMITENTE", HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         ELSEIF ::aTransp[ "modFrete" ] == "1"
            ::DrawTexto( 431, ::nLinhaPdf - 5, 529, NIL, "1-DESTINATARIO", HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         ELSEIF ::aTransp[ "modFrete" ] == "2"
            ::DrawTexto( 431, ::nLinhaPdf - 5, 529, NIL, "2-TERCEIROS", HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         ELSEIF ::aTransp[ "modFrete" ] == "9"
            ::DrawTexto( 431, ::nLinhaPdf - 5, 529, NIL, "9-SEM FRETE", HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         ENDIF
         // ANTT
         ::DrawBox( 530, ::nLinhaPdf - 16, 130, 16, ::nLarguraBox )
         ::DrawTexto( 531, ::nLinhaPdf - 1,  659, NIL, "CÓDIGO ANTT", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 531, ::nLinhaPdf - 5, 659, NIL, ::aVeicTransp[ "RNTC" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         // PLACA
         ::DrawBox( 660, ::nLinhaPdf - 16, 60, 16, ::nLarguraBox )
         ::DrawTexto( 661, ::nLinhaPdf - 1,  719, NIL, "PLACA DO VEÍCULO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 661, ::nLinhaPdf - 5, 719, NIL, ::aVeicTransp[ "placa" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         // UF
         ::DrawBox( 720, ::nLinhaPdf - 16, 20, 16, ::nLarguraBox )
         ::DrawTexto( 721, ::nLinhaPdf - 1,  739, NIL, "UF", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 721, ::nLinhaPdf - 5, 739, NIL, ::aVeicTransp[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         // CNPJ/CPF
         ::DrawBox( 740, ::nLinhaPdf - 16, 90, 16, ::nLarguraBox )
         ::DrawTexto( 741, ::nLinhaPdf - 1,  829, NIL, "CNPJ / CPF", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         IF ! Empty( ::aTransp[ "CNPJ" ] )
            ::DrawTexto( 741, ::nLinhaPdf - 7, 829, NIL, Transform( ::aTransp[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         ELSE
            IF ! Empty( ::aTransp[ "CPF" ] )
               ::DrawTexto( 741, ::nLinhaPdf - 5, 829, NIL, Transform( ::aTransp[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
            ENDIF
         ENDIF

         ::nLinhaPdf -= 16

         // ENDEREÇO
         ::DrawBox( 70, ::nLinhaPdf - 16, 440, 16, ::nLarguraBox )
         ::DrawTexto( 71, ::nLinhaPdf - 1,  509, NIL, "ENDEREÇO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 71, ::nLinhaPdf - 7, 509, NIL, ::aTransp[ "xEnder" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )
         // MUNICIPIO
         ::DrawBox( 510, ::nLinhaPdf - 16, 210, 16, ::nLarguraBox )
         ::DrawTexto( 511, ::nLinhaPdf - 1,  719, NIL, "MUNICÍPIO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 511, ::nLinhaPdf - 5, 719, NIL, ::aTransp[ "xMun" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
         // UF
         ::DrawBox( 720, ::nLinhaPdf - 16, 20, 16, ::nLarguraBox )
         ::DrawTexto( 721, ::nLinhaPdf - 1,  739, NIL, "UF", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 721, ::nLinhaPdf - 5, 739, NIL, ::aTransp[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         // I.E.
         ::DrawBox( 740, ::nLinhaPdf - 16, 90, 16, ::nLarguraBox )
         ::DrawTexto( 741, ::nLinhaPdf - 1,  829, NIL, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 741, ::nLinhaPdf - 5, 829, NIL, ::aTransp[ "IE" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 16

         // QUANTIDADE VOLUME
         ::DrawBox( 70, ::nLinhaPdf - 16, 130, 16, ::nLarguraBox )
         ::DrawTexto( 71, ::nLinhaPdf - 1, 199, NIL, "QUANTIDADE", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 71, ::nLinhaPdf - 5, 199, NIL, LTrim( FormatNumber( Val( ::aTransp[ "qVol" ] ), 15, 0 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 8 )
         // ESPECIE
         ::DrawBox( 200, ::nLinhaPdf - 16, 130, 16, ::nLarguraBox )
         ::DrawTexto( 201, ::nLinhaPdf - 1,  329, NIL, "ESPÉCIE", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 201, ::nLinhaPdf - 5, 329, NIL, ::aTransp[ "esp" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         // MARCA
         ::DrawBox( 330, ::nLinhaPdf - 16, 120, 16, ::nLarguraBox )
         ::DrawTexto( 331, ::nLinhaPdf - 1,  449, NIL, "MARCA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 331, ::nLinhaPdf - 5, 449, NIL, ::aTransp[ "marca" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         // NUMERACAO
         ::DrawBox( 450, ::nLinhaPdf - 16, 120, 16, ::nLarguraBox )
         ::DrawTexto( 451, ::nLinhaPdf - 1,  569, NIL, "NUMERAÇÃO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 451, ::nLinhaPdf - 5, 569, NIL, ::aTransp[ "nVol" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         // PESO BRUTO
         ::DrawBox( 570, ::nLinhaPdf - 16, 130, 16, ::nLarguraBox )
         ::DrawTexto( 571, ::nLinhaPdf - 1,  699, NIL, "PESO BRUTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 571, ::nLinhaPdf - 5, 699, NIL, LTrim( FormatNumber( Val( ::aTransp[ "pesoB" ] ), 15, 3 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // PESO LÍQUIDO
         ::DrawBox( 700, ::nLinhaPdf - 16, 130, 16, ::nLarguraBox )
         ::DrawTexto( 701, ::nLinhaPdf - 1,  829, NIL, "PESO LÍQUIDO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 701, ::nLinhaPdf - 5, 829, NIL, LTrim( FormatNumber( Val( ::aTransp[ "pesoL" ] ), 15, 3 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 17
      ELSE
         ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "TRANSPORTADOR / VOLUMES TRANSPORTADOS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )

         ::nLinhaPdf -= 6

         // NOME/RAZAO SOCIAL
         ::DrawBox(  5, ::nLinhaPdf - 16, 215, 16, ::nLarguraBox )
         ::DrawTexto( 6, ::nLinhaPdf - 1,  219, NIL, "NOME/RAZÃO SOCIAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::DrawTexto( 6, ::nLinhaPdf - 5, 219, NIL, ::aTransp[ "xNome" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )
         // TIPO FRETE
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
         // ANTT
         ::DrawBox( 310, ::nLinhaPdf - 16, 110, 16, ::nLarguraBox )
         ::DrawTexto( 311, ::nLinhaPdf - 1,  419, NIL, "CÓDIGO ANTT", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 311, ::nLinhaPdf - 5, 419, NIL, ::aVeicTransp[ "RNTC" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 8 )
         // PLACA
         ::DrawBox( 420, ::nLinhaPdf - 16, 60, 16, ::nLarguraBox )
         ::DrawTexto( 421, ::nLinhaPdf - 1,  479, NIL, "PLACA DO VEÍCULO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 421, ::nLinhaPdf - 5, 479, NIL, ::aVeicTransp[ "placa" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         // UF
         ::DrawBox( 480, ::nLinhaPdf - 16, 20, 16, ::nLarguraBox )
         ::DrawTexto( 481, ::nLinhaPdf - 1,  499, NIL, "UF", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 481, ::nLinhaPdf - 5, 499, NIL, ::aVeicTransp[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         // CNPJ/CPF
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

         // ENDEREÇO
         ::DrawBox(  5, ::nLinhaPdf - 16, 265, 16, ::nLarguraBox )
         ::DrawTexto( 6, ::nLinhaPdf - 1,  269, NIL, "ENDEREÇO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 6, ::nLinhaPdf - 5, 269, NIL, ::aTransp[ "xEnder" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )
         // MUNICIPIO
         ::DrawBox( 270, ::nLinhaPdf - 16, 210, 16, ::nLarguraBox )
         ::DrawTexto( 271, ::nLinhaPdf - 1,  479, NIL, "MUNICÍPIO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 271, ::nLinhaPdf - 5, 479, NIL, ::aTransp[ "xMun" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 10 )
         // UF
         ::DrawBox( 480, ::nLinhaPdf - 16, 20, 16, ::nLarguraBox )
         ::DrawTexto( 481, ::nLinhaPdf - 1,  499, NIL, "UF", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 481, ::nLinhaPdf - 5, 499, NIL, ::aTransp[ "UF" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         // I.E.
         ::DrawBox( 500, ::nLinhaPdf - 16, 90, 16, ::nLarguraBox )
         ::DrawTexto( 501, ::nLinhaPdf - 1,  589, NIL, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 501, ::nLinhaPdf - 5, 589, NIL, ::aTransp[ "IE" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 16

         // QUANTIDADE VOLUME
         ::DrawBox(  5, ::nLinhaPdf - 16, 95, 16, ::nLarguraBox )
         ::DrawTexto( 6, ::nLinhaPdf - 1,  99, NIL, "QUANTIDADE", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 6, ::nLinhaPdf - 5, 99, NIL, LTrim( FormatNumber( Val( ::aTransp[ "qVol" ] ), 15, 0 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 8 )
         // ESPECIE
         ::DrawBox( 100, ::nLinhaPdf - 16, 100, 16, ::nLarguraBox )
         ::DrawTexto( 101, ::nLinhaPdf - 1,  199, NIL, "ESPÉCIE", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 101, ::nLinhaPdf - 5, 199, NIL, ::aTransp[ "esp" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         // MARCA
         ::DrawBox( 200, ::nLinhaPdf - 16, 100, 16, ::nLarguraBox )
         ::DrawTexto( 201, ::nLinhaPdf - 1,  299, NIL, "MARCA", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 201, ::nLinhaPdf - 5, 299, NIL, ::aTransp[ "marca" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         // NUMERACAO
         ::DrawBox( 300, ::nLinhaPdf - 16, 100, 16, ::nLarguraBox )
         ::DrawTexto( 301, ::nLinhaPdf - 1,  399, NIL, "NUMERAÇÃO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 301, ::nLinhaPdf - 5, 399, NIL, ::aTransp[ "nVol" ], HPDF_TALIGN_CENTER, ::oPdfFontCabecalho, 10 )
         // PESO BRUTO
         ::DrawBox( 400, ::nLinhaPdf - 16, 100, 16, ::nLarguraBox )
         ::DrawTexto( 401, ::nLinhaPdf - 1,  499, NIL, "PESO BRUTO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 401, ::nLinhaPdf - 5, 499, NIL, LTrim( FormatNumber( Val( ::aTransp[ "pesoB" ] ), 15, 3 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
         // PESO LÍQUIDO
         ::DrawBox( 500, ::nLinhaPdf - 16, 90, 16, ::nLarguraBox )
         ::DrawTexto( 501, ::nLinhaPdf - 1,  589, NIL, "PESO LÍQUIDO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
         ::DrawTexto( 501, ::nLinhaPdf - 5, 589, NIL, LTrim( FormatNumber( Val( ::aTransp[ "pesoL" ] ), 15, 3 ) ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

         ::nLinhaPdf -= 17
      ENDIF
   ENDIF

   RETURN NIL

METHOD CabecalhoProdutos() CLASS hbNFeDaNFe

   LOCAL oElement

   ::DrawTexto( iif( ::lPaisagem, 70, 5 ), ::nLinhaPdf, iif( ::lPaisagem, 830, 589 ), NIL, "DADOS DOS PRODUTOS / SERVIÇOS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )
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
      ::aItem[ "infAdPros" ] := ::FormataMemo( ::aItem[ "infAdProd" ], ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] - 2 )
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
         ::DrawLine( iif( ::lPaisagem, 70, 5 ), ::nLinhaPdf - 0.5, iif( ::lPaisagem, 830, 590 ), ::nLinhaPdf - 0.5, ::nLarguraBox )
      ENDIF
   ENDDO
   IF MLCount( ::aInfAdic[ "infCpl" ], 1000 ) > Int( iif( ::lPaisagem, 11, 13 ) * 6 / ::nLayoutFonteAltura )
      ::nLinhaFolha++
      ::nLinhaPdf -= ::nLayoutFonteAltura
      ::DrawTexto( iif( ::lPaisagem, 70, 5 ), ::nLinhaPdf, iif( ::lPaisagem, 830, 589 ), NIL, "*CONTINUACAO INFORMAÇÕES COMPLEMENTARES*", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, ::nLayoutFonteAltura )
      ::nLinhaFolha++
      ::nLinhaPdf -= ::nLayoutFonteAltura
      FOR nCont = Int( iif( ::lPaisagem, 11, 13 ) * 6 / ::nLayoutFonteAltura ) + 1 TO MLCount( ::aInfAdic[ "infCpl" ], 1000 )
         IF ::nLinhaFolha > ::ItensDaFolha()
            ::SaltaPagina()
            ::DrawTexto( iif( ::lPaisagem, 70, 5 ), ::nLinhaPdf, iif( ::lPaisagem, 830, 589 ), NIL, "*CONTINUACAO INFORMAÇÕES COMPLEMENTARES*", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, ::nLayoutFonteAltura )
            ::nLinhaFolha++
            ::nLinhaPdf -= ::nLayoutFonteAltura
         ENDIF
         ::DrawTexto( iif( ::lPaisagem, 70, 5 ), ::nLinhaPdf, iif( ::lPaisagem, 830, 589 ), NIL, MemoLine( ::aInfAdic[ "infCpl" ], 1000, nCont ), HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, ::nLayoutFonteAltura )
         ::nLinhaFolha++
         ::nLinhaPdf -= ::nLayoutFonteAltura
      NEXT
   ENDIF
   ::nLinhaPdf -= ( ( ::ItensDaFolha() - ::nLinhaFolha + 1 ) * ::nLayoutFonteAltura )
   ::nLinhaPdf -= 2

   RETURN NIL

METHOD TotalServico() CLASS hbNFeDaNFe

   IF ::nFolha == 1
      IF Val( IF( ::aISSTotal[ "vServ" ] <> NIL, ::aISSTotal[ "vServ" ], "0" ) ) > 0 // com servico
         IF ::lPaisagem
            ::DrawTexto( 70, ::nLinhaPdf, 830, NIL, "CALCULO DO ISSQN", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )

            ::nLinhaPdf -= 6

            // INSCRICAO
            ::DrawBox(  70, ::nLinhaPdf - 16, 200, 16, ::nLarguraBox )
            ::DrawTexto( 71, ::nLinhaPdf - 1,  269, NIL, "INSCRIÇÃO MUNICIPAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
            ::DrawTexto( 71, ::nLinhaPdf - 5, 269, NIL, ::aEmit[ "IM" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )
            // VALOR SERV.
            ::DrawBox( 270, ::nLinhaPdf - 16, 190, 16, ::nLarguraBox )
            ::DrawTexto( 271, ::nLinhaPdf - 1,  459, NIL, "VALOR TOTAL DOS SERVIÇOS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
            ::DrawTexto( 271, ::nLinhaPdf - 5, 459, NIL, FormatNumber( Val( IF( ::aISSTotal[ "vServ" ] <> NIL, ::aISSTotal[ "vServ" ], "0" ) ), 15 ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
            // BASE DE CALC
            ::DrawBox( 460, ::nLinhaPdf - 16, 190, 16, ::nLarguraBox )
            ::DrawTexto( 461, ::nLinhaPdf - 1,  649, NIL, "BASE DE CÁLCULO DO ISSQN", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
            ::DrawTexto( 461, ::nLinhaPdf - 5, 649, NIL, FormatNumber( Val( IF( ::aISSTotal[ "vBC" ] <> NIL, ::aISSTotal[ "vBC" ], "0" ) ), 15 ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
            // VALOR DO ISSQN
            ::DrawBox( 650, ::nLinhaPdf - 16, 180, 16, ::nLarguraBox )
            ::DrawTexto( 651, ::nLinhaPdf - 1,  829, NIL, "VALOR DO ISSQN", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
            ::DrawTexto( 651, ::nLinhaPdf - 5, 829, NIL, FormatNumber( Val( IF( ::aISSTotal[ "vISS" ] <> NIL, ::aISSTotal[ "vISS" ], "0" ) ), 15 ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

            ::nLinhaPdf -= 17
         ELSE
            ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "CALCULO DO ISSQN", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )

            ::nLinhaPdf -= 6

            // INSCRICAO
            ::DrawBox(  5, ::nLinhaPdf - 16, 150, 16, ::nLarguraBox )
            ::DrawTexto( 6, ::nLinhaPdf - 1,  154, NIL, "INSCRIÇÃO MUNICIPAL", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
            ::DrawTexto( 6, ::nLinhaPdf - 5, 154, NIL, ::aEmit[ "IM" ], HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 8 )
            // VALOR SERV.
            ::DrawBox( 155, ::nLinhaPdf - 16, 145, 16, ::nLarguraBox )
            ::DrawTexto( 156, ::nLinhaPdf - 1,  299, NIL, "VALOR TOTAL DOS SERVIÇOS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
            ::DrawTexto( 156, ::nLinhaPdf - 5, 299, NIL, FormatNumber( Val( IF( ::aISSTotal[ "vServ" ] <> NIL, ::aISSTotal[ "vServ" ], "0" ) ), 15 ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
            // BASE DE CALC
            ::DrawBox( 300, ::nLinhaPdf - 16, 145, 16, ::nLarguraBox )
            ::DrawTexto( 301, ::nLinhaPdf - 1,  444, NIL, "BASE DE CÁLCULO DO ISSQN", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
            ::DrawTexto( 301, ::nLinhaPdf - 5, 444, NIL, FormatNumber( Val( IF( ::aISSTotal[ "vBC" ] <> NIL, ::aISSTotal[ "vBC" ], "0" ) ), 15 ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )
            // VALOR DO ISSQN
            ::DrawBox( 445, ::nLinhaPdf - 16, 145, 16, ::nLarguraBox )
            ::DrawTexto( 446, ::nLinhaPdf - 1,  589, NIL, "VALOR DO ISSQN", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 5 )
            ::DrawTexto( 446, ::nLinhaPdf - 5, 589, NIL, FormatNumber( Val( IF( ::aISSTotal[ "vISS" ] <> NIL, ::aISSTotal[ "vISS" ], "0" ) ), 15 ), HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 10 )

            ::nLinhaPdf -= 17
         ENDIF
      ENDIF
   ENDIF

   RETURN NIL

METHOD DadosAdicionais() CLASS hbNFeDaNFe

   LOCAL cMemo, nI

   IF ::nFolha == 1
      cMemo := ::aInfAdic[ "infCpl" ]
      IF ::lPaisagem
         ::DrawTexto( 70, ::nLinhaPdf, 830, NIL, "DADOS ADICIONAIS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )
         ::nLinhaPdf -= 6
         // INF. COMPL.
         ::DrawBox( 70, ::nLinhaPdf - 78, 495, 78, ::nLarguraBox )
         ::DrawTexto( 71, ::nLinhaPdf - 1, 564, NIL, "INFORMAÇÕES COMPLEMENTARES", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, ::nLayoutFonteALtura )
         // RESERVADO FISCO
         ::DrawBox( 565, ::nLinhaPdf - 78, 265, 78, ::nLarguraBox )
         ::DrawTexto( 566, ::nLinhaPdf - 1, 829, NIL, "RESERVADO AO FISCO", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
         ::nLinhaPdf -= 7
         ::nLinhaPdf -= 4 // ESPAÇO
         FOR nI = 1 TO Min( MLCount( cMemo, 1000 ), Int( 11 * 6 / ::nLayoutFonteAltura ) )
            ::DrawTexto( 71, ::nLinhaPdf,564, NIL, Trim( MemoLine( cMemo, 1000, nI ) ), HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, ::nLayoutFonteAltura )
            ::nLinhaPdf -= ::nLayoutFonteAltura
         NEXT
         FOR nI = ( MLCount( cMemo, 1000 ) + 1 ) TO Int( 11 * 6 / ::nLayoutFonteAltura )
            ::nLinhaPdf -= ::nLayoutFonteAltura
         NEXT
         ::nLinhaPdf -= 2
      ELSE
         ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "DADOS ADICIONAIS", HPDF_TALIGN_LEFT, ::oPdfFontCabecalhoBold, 5 )
         ::nLinhaPdf -= 6
         // INF. COMPL.
         ::DrawBox(  5, ::nLinhaPdf - 92, 395, 92, ::nLarguraBox )
         ::DrawTexto( 6, ::nLinhaPdf - 1, 399, NIL, "INFORMAÇÕES COMPLEMENTARES", HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, ::nLayoutFonteALtura )
         // RESERVADO FISCO
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
   ENDIF

   RETURN NIL

METHOD Rodape() CLASS hbNFeDaNFe

   IF ::lPaisagem
      ::DrawTexto( 70, ::nLinhaPdf, 175, NIL, "DATA DA IMPRESSÃO: " + DToC( Date() ), HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
      ::DrawTexto( 185, ::nLinhaPdf, 829, NIL, ::cDesenvolvedor, HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 6 )
   ELSE
      ::DrawTexto( 5, ::nLinhaPdf, 110, NIL, "DATA DA IMPRESSÃO: " + DToC( Date() ), HPDF_TALIGN_LEFT, ::oPdfFontCabecalho, 6 )
      ::DrawTexto( 115, ::nLinhaPdf, 589, NIL, ::cDesenvolvedor, HPDF_TALIGN_RIGHT, ::oPdfFontCabecalho, 6 )
   ENDIF

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
   ::aInfAdic[ "infCpl" ] := ::FormataMemo( ::aInfAdic[ "infCpl" ], 392 + iif( ::lPaisagem, 100, 0 ) )
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
   IF MLCount( ::ainfAdic[ "infCpl" ], 1000 ) > Int( iif( ::lPaisagem, 11, 13 ) * 6 / ::nLayoutFonteAltura )
      nQtdLinhas += 2 + MLCount( ::ainfAdic[ "infCpl" ], 1000 ) - Int( iif( ::lPaisagem, 11, 13 ) * 6 / ::nLayoutFonteAltura )
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
      nTotal := iif( ::lPaisagem, 16, 45 ) + ;
                iif( ::lLaser, 9, 0  ) + ;
                iif( Empty( ::cCobranca ), 2, 0 ) + ;
                iif( Val( ::aIssTotal[ "vServ" ] ) <= 0, 4, 0 )
   ELSE
      nTotal := iif( ::lPaisagem, 72, 105 )
   ENDIF
   nTotal := Int( nTotal * 6 / ::nLayoutFonteAltura )

   RETURN nTotal

METHOD DrawTextoProduto( nCampo, nRow, nConteudo, nAlign ) CLASS hbNFeDaNFe

   LOCAL nColunaInicial, nColunaFinal, cTexto

   IF ::aLayout[ nCampo, LAYOUT_IMPRIME ]
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

   IF ::aLayout[ nCampo, LAYOUT_IMPRIME ]
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

   // Define o que sai, conforme retrato/paisagem
   ::aLayout[ LAYOUT_DESCONTO, LAYOUT_IMPRIME ] := ::lPaisagem
   ::aLayout[ LAYOUT_SUBBAS,   LAYOUT_IMPRIME ] := ::lPaisagem
   ::aLayout[ LAYOUT_SUBVAL,   LAYOUT_IMPRIME ] := ::lPaisagem
   ::aLayout[ LAYOUT_IPIVAL,   LAYOUT_IMPRIME ] := .T. // Se .F., decide baseado no XML
   ::aLayout[ LAYOUT_IPIALI,   LAYOUT_IMPRIME ] := .T. // Se .F., decide baseado no XML
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
         ::aLayout[ LAYOUT_IPIVAL, LAYOUT_IMPRIME ] := .T.
         ::aLayout[ LAYOUT_IPIALI, LAYOUT_IMPRIME ] := .T.
      ENDIF
      IF ::lPaisagem
         IF Val( ::aItemICMS[ "vBCST" ] ) > 0 .OR. Val( ::aItemICMS[ "vICMSST" ] ) > 0
            ::aLayout[ LAYOUT_SUBBAS, LAYOUT_IMPRIME ] := .T.
            ::aLayout[ LAYOUT_SUBVAL, LAYOUT_IMPRIME ] := .T.
         ENDIF
         IF Val( ::aItem[ "vDesc" ] ) > 0
            ::aLayout[ LAYOUT_DESCONTO, LAYOUT_IMPRIME ] := .T.
         ENDIF
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
   AEval( ::aLayout, { | oElement | oElement[ LAYOUT_LARGURAPDF ] := iif( oElement[ LAYOUT_IMPRIME ], oElement[ LAYOUT_LARGURAPDF ], 0 ) } )

   // Calcula posição das colunas
   nColunaFinal := iif( ::lPaisagem, 832, 592 )
   ::aLayout[ LAYOUT_IPIALI,    LAYOUT_COLUNAPDF ]  := nColunaFinal - ::aLayout[ LAYOUT_IPIALI,   LAYOUT_LARGURAPDF ]
   FOR nCont = Len( ::aLayout ) - 1 TO 3 STEP -1
      ::aLayout[ nCont, LAYOUT_COLUNAPDF ] := ::aLayout[ nCont + 1, LAYOUT_COLUNAPDF ] - ::aLayout[ nCont, LAYOUT_LARGURAPDF ]
   NEXT
   ::aLayout[ LAYOUT_CODIGO,    LAYOUT_COLUNAPDF ]  := iif( ::lPaisagem, 70, 6 )
   ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_COLUNAPDF ]  := ::aLayout[ LAYOUT_CODIGO, LAYOUT_COLUNAPDF ] + ::aLayout[ LAYOUT_CODIGO, LAYOUT_LARGURAPDF ]

   // Define largura da descrição conforme espaço que sobra
   ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] := ::aLayout[ LAYOUT_NCM, LAYOUT_COLUNAPDF ] - ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_COLUNAPDF ]
   ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURA ]    := 100 // tanto faz

   RETURN NIL

// Funções repetidas em NFE, CTE, MDFE e EVENTO
// STATIC pra permitir uso simultâneo com outras rotinas

#ifdef __XHARBOUR__
STATIC FUNCTION hbnfe_Codifica_Code128c( pcCodigoBarra )

   // Parameters de entrada : O codigo de barras no formato Code128C "somente numeros" campo tipo caracter
   // Retorno               : Retorna o código convertido e com o caracter de START e STOP mais o checksum
   // : para impressão do código de barras utilizando a fonte Code128bWin, é necessário
   // : para utilizar essa fonte os arquivos Code128bWin.ttf, Code128bWin.afm e Code128bWin.pfb
   // Autor                  : Anderson Camilo
   // Data                   : 19/03/2012

   LOCAL nI := 0, checksum := 0, nValorCar, cCode128 := '', cCodigoBarra

   cCodigoBarra == pcCodigoBarra
   IF Len( cCodigoBarra ) > 0    // Verifica se os caracteres são válidos (somente números)
      IF Int( Len( cCodigoBarra ) / 2 ) == Len( cCodigoBarra ) / 2    // Tem ser par o tamanho do código de barras
         FOR nI = 1 TO Len( cCodigoBarra )
            IF ( Asc( SubStr( cCodigoBarra, nI, 1 ) ) < 48 .OR. Asc( SubStr( cCodigoBarra, nI, 1 ) ) > 57 )
               nI := 0
               EXIT
            ENDIF
         NEXT
      ENDIF
      IF nI > 0
         nI := 1 // nI é o índice da cadeia
         cCode128 := Chr( 155 )
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
            IF nValorCar == 128
               nValorCar := 0
            ELSEIF nValorCar < 127
               nValorCar -= 32
            ELSE
               nValorCar -=  50
            ENDIF
            IF nI == 1
               checksum := nValorCar
            ENDIF
            checksum := Mod( ( checksum + ( nI - 1 ) * nValorCar ), 103 )
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

STATIC FUNCTION FormatTelefone( cTelefone )

   LOCAL cPicture := ""

   cTelefone := iif( ValType( cTelefone ) == "N", iif( cTelefone > 100, Ltrim( Str( cTelefone ) ), "" ), cTelefone )
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
