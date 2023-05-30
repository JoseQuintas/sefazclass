/*
ZE_SPEDDANFE - Documento Auxiliar da Nota Fiscal Eletrônica
Fontes originais do projeto hbnfe em https://github.com/fernandoathayde/hbnfe

Anotação (manual do usuário 6.0):
Os campos que podem ser colocados na mesma coluna são:
- “Código do Produto/Serviço” com “NCM/SH” ;
- “CST” com “CFOP” ;
- “CSOSN” com “CFOP” ;
- “Quantidade” com “Unidade” ;
- “Valor Unitário” com “Desconto” ;
- “Valor Total” com “Base de Cálculo do ICMS” ;
- “Base de Cálculo do ICMS por Substituição Tributária” com “Valor do ICMS por Substituição Tributária” ;
- “Valor do ICMS Próprio” com “Valor do IPI”
- “Alíquota do ICMS” com “Alíquota do IPI”.

2019 - Quadros opcionais para Local de Coleta e Local de Entrega
*/

#include "common.ch"
#include "hbclass.ch"
#include "harupdf.ch"

#define LAYOUT_LOGO_ESQUERDA   1
#define LAYOUT_LOGO_DIREITA    2
#define LAYOUT_LOGO_EXPANDIDO  3

#define LAYOUT_NAOIMPRIME      0
#define LAYOUT_IMPRIMENORMAL   1
#define LAYOUT_IMPRIMESEGUNDA  2
#define LAYOUT_IMPRIMEXMLTEM   3

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
#define LAYOUT_EAN             4
#define LAYOUT_CST             5
#define LAYOUT_CFOP            6
#define LAYOUT_UNIDADE         7
#define LAYOUT_QTD             8
#define LAYOUT_UNITARIO        9
#define LAYOUT_TOTAL           10
#define LAYOUT_DESCONTO        11
#define LAYOUT_ICMBAS          12
#define LAYOUT_ICMVAL          13
#define LAYOUT_SUBBAS          14
#define LAYOUT_SUBVAL          15
#define LAYOUT_IPIVAL          16
#define LAYOUT_ICMALI          17
#define LAYOUT_IPIALI          18

#define LAYOUT_FONTSIZE      8

CREATE CLASS hbNFeDaNFe INHERIT hbNFeDaGeral

   METHOD ToPDF( cXmlNFE, cFilePDF, cXmlCancel )
   METHOD BuscaDadosXML()
   METHOD GeraPDF( cFilePDF )
   METHOD NovaPagina()
   METHOD SaltaPagina()
   METHOD QuadroNotaFiscal()
   METHOD QuadroDestinatario()
   METHOD QuadroLocalRetirada()
   METHOD QuadroLocalEntrega()
   METHOD QuadroDuplicatas()
   METHOD QuadroCanhoto()
   METHOD QuadroImposto()
   METHOD QuadroTransporte()
   METHOD QuadroProdutosTitulo()
   METHOD QuadroProdutosDesenho( nLinhaFinalProd, nAlturaQuadroProdutos )
   METHOD QuadroProdutos()
   METHOD QuadroTotalServico()
   METHOD QuadroDadosAdicionais()
   METHOD ProcessaItens( cXml, nItem )
   METHOD CalculaLayout()
   METHOD LinhasPraProduto( nFolha )
   METHOD Init()
   METHOD DrawTextoProduto( nCampo, nRow, nConteudo, nAlign )
   METHOD DrawBoxProduto( nCampo, nRow, nHeight )
   METHOD DefineColunasProdutos()
   METHOD SetDescontoOff()      INLINE ::aLayout[ LAYOUT_DESCONTO, LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
   METHOD SetSubBasOff()        INLINE ::aLayout[ LAYOUT_SUBBAS,   LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
   METHOD SetSubValOff()        INLINE ::aLayout[ LAYOUT_SUBVAL,   LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
   METHOD SetIpiValOff()        INLINE ::aLayout[ LAYOUT_IPIVAL,   LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
   METHOD SetIpiAliOff()        INLINE ::aLayout[ LAYOUT_IPIALI,   LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
   METHOD SetEanOff()           INLINE ::aLayout[ LAYOUT_EAN,      LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME

   VAR cTelefoneEmitente INIT ""
   VAR cSiteEmitente     INIT ""
   VAR cEmailEmitente    INIT ""
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
   VAR aDetPag
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
   VAR oPDFFontNormal
   VAR oPDFFontBold
   VAR nLinhaPDF
   VAR nLarguraBox INIT 0.3
   VAR lLaser      INIT .T.
   VAR cLogoFile   INIT ""
   VAR nLogoStyle  INIT LAYOUT_LOGO_ESQUERDA
   VAR nFolha
   VAR cRetorno

   VAR nItensFolha
   VAR nLinhaFolha
   VAR nLayoutTotalFolhas
   VAR lLayoutEspacoDuplo  INIT .T.
   VAR aLayout

   ENDCLASS

METHOD Init() CLASS hbNFeDaNFe

   LOCAL oElement

   ::aLayout := Array(18)
   FOR EACH oElement IN ::aLayout
      oElement := Array(10)
      oElement[ LAYOUT_IMPRIME ]      := LAYOUT_IMPRIMENORMAL
      oElement[ LAYOUT_TITULO1 ]      := ""
      oElement[ LAYOUT_TITULO2 ]      := ""
      oElement[ LAYOUT_CONTEUDO ]     := { || "" }
      oElement[ LAYOUT_LARGURAPDF ]   := 1
   NEXT
   ::aLayout[ LAYOUT_DESCONTO, LAYOUT_IMPRIME ] := LAYOUT_IMPRIMEXMLTEM
   ::aLayout[ LAYOUT_SUBBAS,   LAYOUT_IMPRIME ] := LAYOUT_IMPRIMEXMLTEM
   ::aLayout[ LAYOUT_SUBVAL,   LAYOUT_IMPRIME ] := LAYOUT_IMPRIMEXMLTEM
   ::aLayout[ LAYOUT_IPIVAL,   LAYOUT_IMPRIME ] := LAYOUT_IMPRIMEXMLTEM
   ::aLayout[ LAYOUT_IPIALI,   LAYOUT_IMPRIME ] := LAYOUT_IMPRIMEXMLTEM
   ::aLayout[ LAYOUT_EAN,      LAYOUT_IMPRIME ] := LAYOUT_IMPRIMEXMLTEM

   RETURN SELF

METHOD ToPDF( cXmlNFE, cFilePDF, cXmlCancel ) CLASS hbNFeDaNFe

   IF Empty( cXmlNFE )
      ::cRetorno := "XML sem conteúdo"
      RETURN ::cRetorno
   ENDIF
   IF ! Empty( cXmlCancel )
      ::cXmlCancel := cXmlCancel
   ENDIF

   ::cXML   := cXmlNFE
   ::cChave := Substr( ::cXML, At( "Id=", ::cXML ) + 3 + 4, 44 )

   IF ! ::BuscaDadosXML()
      RETURN ::cRetorno
   ENDIF

   IF ! ::GeraPDF( cFilePDF )
      ::cRetorno := "Problema ao gerar o PDF"
      RETURN ::cRetorno
   ENDIF
   ::cRetorno := "OK"

   RETURN ::cRetorno

METHOD BuscaDadosXML() CLASS hbNFeDaNFe

   LOCAL cText, aNFRef, oElement

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
   ::aRetirada   := XmlToHash( XmlNode( ::cXml, "retirada" ), { "CNPJ", "CPF", "xNome", "xLgr", "nro", "xCpl", "xBairro", "CEP", "cMun", "xMun", "UF", "fone", "IE" } )
   ::aEntrega    := XmlToHash( XmlNode( ::cXml, "entrega" ), { "CNPJ", "CPF", "xNome", "xLgr", "nro", "xCpl", "xBairro", "CEP", "cMun", "xMun", "UF", "fone", "IE" } )
   ::aICMSTotal  := XmlToHash( XmlNode( ::cXml, "ICMSTot" ), { "vBC", "vICMS", "vBCST", "vST", "vProd", "vFrete", "vSeg", "vDesc", "vII", "vIPI", "vPIS", "vCOFINS", "vOutro", "vNF" } )
   ::aISSTotal   := XmlToHash( XmlNode( ::cXml, "ISSQNtot" ), { "vServ", "vBC", "vISS", "vPIS", "vCOFINS" } )
   ::aRetTrib    := XmlToHash( XmlNode( ::cXml, "RetTrib" ), { "vRetPIS", "vRetCOFINS", "vRetCSLL", "vBCIRRF", "vIRRF", "vBCRetPrev", "vRetPrev" } )
   ::aTransp     := XmlToHash( XmlNode( ::cXml, "transp" ), { "modFrete", "CNPJ", "CPF", "xNome", "IE", "xEnder", "xMun", "UF", "qVol", "esp", "marca", "nVol", "pesoL", "pesoB", "nLacre" } )
   ::aVeicTransp := XmlToHash( XmlNode( XmlNode( ::cXml, "transp" ), "veicTransp" ), { "placa", "UF", "RNTC" } )
   ::aReboque    := XmlToHash( XmlNode( XmlNode( ::cXml, "reboque" ), "veicTransp" ), { "placa", "UF", "RNTC" } )
   ::cCobranca   := XmlNode( ::cXml, "cobr" )
   ::aDetPag     := MultipleNodeToArray( XmlNode( ::cXml, "pag" ), "detPag" )
   ::aInfAdic    := XmlToHash( XmlNode( ::cXml, "infAdic" ), { "infAdFisco", "infCpl" } )
   ::aObsCont    := XmlToHash( XmlNode( XmlNode( ::cXml, "infAdic" ), "obsCont" ), { "xCampo", "xTexto" } )
   ::aObsFisco   := XmlToHash( XmlNode( XmlNode( ::cXml, "infAdic" ), "obsFisco" ), { "xCampo", "xTexto" } )
   ::aExporta    := XmlToHash( XmlNode( XmlNode( ::cXml, "exporta" ), "infCpl" ), { "UFEmbarq", "xLocEmbarq" } )
   ::aCompra     := XmlToHash( XmlNode( ::cXml, "compra" ), { "xNEmp", "xPed", "xCont" } )
   ::aInfProt    := XmlToHash( iif( Empty( ::cXmlCancel ), ::cXml, ::cXmlCancel ), { "nProt", "dhRecbto", "digVal", "cStat", "xEvento", "dhRegEvento", "xMotivo" } )
   IF ! Empty( ::aInfProt[ "dhRegEvento" ]  )
      ::aInfProt[ "dhRecbto" ] := ::aInfProt[ "dhRegEvento" ]
   ENDIF

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
   FOR EACH cText IN { ";;", ";", "|" }
      ::aInfAdic[ "infCpl" ]     := StrTran( ::aInfAdic[ "infCpl" ], cText, hb_Eol() )
      ::aInfAdic[ "infAdFisco" ] := StrTran( ::aInfAdic[ "infAdFisco" ], cText, hb_Eol() )
   NEXT
   IF ! Empty( ::aInfAdic[ "infAdFisco" ] )
      ::aInfAdic[ "infCpl" ]     := ::aInfAdic[ "infAdFisco" ] + hb_Eol() + ::aInfAdic[ "infCpl" ]
      ::aInfAdic[ "infAdFisco" ] := ""
   ENDIF
   aNFRef := MultipleNodeToArray( ::cXml, "refNFe" )
   IF ! Empty( aNFRef )
      cText := "NFe Referenciadas: "
      FOR EACH oElement IN aNFRef
         cText += oElement + iif( oElement:__EnumIsLast, "", ", " )
      NEXT
      ::ainfAdic[ "infCpl" ] := cText + " " + ::aInfAdic[ "infCpl" ]
   ENDIF

   RETURN .T.

METHOD GeraPDF( cFilePDF ) CLASS hbNFeDaNFe

   ::oPdf := HPDF_New()
   IF ::oPdf == NIL
      ::cRetorno := "Falha da criação do objeto PDF"
      RETURN .F.
   ENDIF
   HPDF_SetCompressionMode( ::oPdf, HPDF_COMP_ALL )
   IF ::cFonteNFe == "Times"
      ::oPDFFontNormal     := HPDF_GetFont( ::oPdf, "Times-Roman", "CP1252" )
      ::oPDFFontBold := HPDF_GetFont( ::oPdf, "Times-Bold", "CP1252" )
   ELSE
      ::oPDFFontNormal     := HPDF_GetFont( ::oPdf, "Courier", "CP1252" )
      ::oPDFFontBold := HPDF_GetFont( ::oPdf, "Courier-Bold", "CP1252" )
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
   HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPDFFontNormal, LAYOUT_FONTSIZE )
   ::CalculaLayout()

   ::QuadroCanhoto()
   ::QuadroNotaFiscal()
   ::QuadroDestinatario()
   IF ::lQuadroEntrega
      IF ! Empty( ::aRetirada[ "xLgr" ] )
         ::QuadroLocalRetirada()
      ENDIF
      IF ! Empty( ::aEntrega[ "xLgr" ] )
         ::QuadroLocalEntrega()
      ENDIF
   ENDIF
   ::QuadroDuplicatas()
   ::QuadroImposto()
   ::QuadroTransporte()
   ::QuadroProdutosTitulo()
   ::QuadroProdutos()
   ::QuadroTotalServico()
   ::QuadroDadosAdicionais()
   ::Desenvolvedor()

   HPDF_SaveToFile( ::oPdf, cFilePDF )
   HPDF_Free( ::oPdf )

   RETURN .T.

METHOD NovaPagina() CLASS hbNFeDaNFe

   ::oPdfPage := HPDF_AddPage( ::oPdf )
   HPDF_Page_SetSize( ::oPdfPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT )

   IF ::aIde[ "tpEmis" ] = "5" // Contingencia
      ::DrawContingencia( "", "DANFE EM CONTINGÊNCIA. IMPRESSO EM", "DECORRÊNCIA DE PROBLEMAS TÉCNICOS" )
   ENDIF

   IF ::aIde[ "tpEmis" ] == "4" // DEPEC
      ::DrawContingencia( "DANFE IMPRESSO EM CONTINGÊNCIA - DPEC", "REGULARMENTE RECEBIDO PELA RECEITA", "FEDERAL" )
   ENDIF

   IF ::aIde[ "tpAmb" ] == "2"
      ::DrawHomologacao()
   ENDIF
   IF ::aInfProt[ "cStat" ] $ "101,135,302" .OR. ! Empty( ::cXmlCancel )
      ::DrawAviso( ::aInfProt[ "xEvento" ] + " " + ::aInfProt[ "dhRegEvento" ] + " " + ::aInfProt[ "xMotivo" ] )
   ENDIF
   ::nLinhaPdf := HPDF_Page_GetHeight( ::oPDFPage ) - 8                    // Margem Superior

   RETURN NIL

METHOD SaltaPagina() CLASS hbNFeDaNFe

   LOCAL nLinhaFinalProd, nAlturaQuadroProdutos

   ::nLinhaPdf -= 2
   ::QuadroTotalServico()
   ::QuadroDadosAdicionais()
   ::Desenvolvedor()
   ::NovaPagina()
   ::nFolha++
   ::nLinhaFolha := 1
   ::QuadroCanhoto()
   ::QuadroNotaFiscal()
   ::QuadroProdutosTitulo()
   nAlturaQuadroProdutos := ( ::LinhasPraProduto() * LAYOUT_FONTSIZE ) + 2
   nLinhaFinalProd       := ::nLinhaPdf - nAlturaQuadroProdutos
   ::QuadroProdutosDesenho( nLinhaFinalProd, nAlturaQuadroProdutos )

   RETURN NIL

METHOD QuadroCanhoto() CLASS hbNFeDaNFe

   LOCAL cTexto

   IF ::nFolha != 1
      ::nLinhaPdf -= 18
      ::nLinhaPdf -= 24
      ::nLinhaPdf -= 10
      RETURN NIL
   ENDIF
   ::DrawBox( 5, ::nLinhaPdf - 44, 585, 44, ::nLarguraBox )

   cTexto := "RECEBEMOS DE " + ::aEmit[ "xNome" ] + " OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO,"
   cTexto += " EMISSÃO " + Substr( ::aIde[ "dhEmi" ], 9, 2 ) + "/" + Substr( ::aIde[ "dhEmi" ], 6, 2 ) + "/" + Substr( ::aIde[ "dhEmi" ], 1, 4 )
   cTexto += " VALOR TOTAL R$ " + AllTrim( FormatNumber( Val( ::aICMSTotal[ "vNF" ] ), 15, 2 ) )
   cTexto += " DESTINATÁRIO " + ::aDest[ "xNome" ]
   ::DrawTexto( 6, ::nLinhaPdf, 490, NIL, Upper( cTexto ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )

   ::DrawBox( 505, ::nLinhaPdf - 44, 85, 44, ::nLarguraBox )
   ::DrawTexto( 506, ::nLinhaPdf - 8, 589, NIL, "NF-e", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   ::DrawTexto( 506, ::nLinhaPdf - 20, 589, NIL, "Nº: " + Transform( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), "@R 999.999.999" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   ::DrawTexto( 506, ::nLinhaPdf - 32, 589, NIL, "SÉRIE " + ::aIde[ "serie" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   ::nLinhaPdf -= 18

   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 130, 26, "DATA DE RECEBIMENTO", "", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   ::DrawBoxTituloTexto( 135, ::nLinhaPdf, 370, 26, "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR", "", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   ::nLinhaPdf -= 24

   // corte
   IF ::cFonteNFe == "Times"
      ::DrawTexto( 5, ::nLinhaPdf, 590, NIL, Replicate( "- ", 125 ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
   ELSE
      ::DrawTexto( 5, ::nLinhaPdf - 2, 590, NIL, Replicate( "- ", 81 ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   ENDIF
   ::nLinhaPdf -= 10

   RETURN NIL

METHOD QuadroNotaFiscal() CLASS hbNFeDaNFe

   LOCAL cTexto

   ::DrawBox( 5, ::nLinhaPdf - 80, 585, 80, ::nLarguraBox )
   // logo/dados empresa
   ::DrawBox( 5, ::nLinhaPdf - 80, 240, 80, ::nLarguraBox )
   ::DrawTexto( 6, ::nLinhaPdf, 244, NIL, "IDENTIFICAÇÃO DO EMITENTE", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   IF ::cLogoFile == NIL .OR. Empty( ::cLogoFile )
      ::DrawTexto( 6, ::nLinhaPdf - 6, 244, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
      ::DrawTexto( 6, ::nLinhaPdf - 18, 244, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 2 ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
      ::DrawTexto( 6, ::nLinhaPdf - 30, 244, NIL, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ::DrawTexto( 6, ::nLinhaPdf - 38, 244, NIL, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ::DrawTexto( 6, ::nLinhaPdf - 46, 244, NIL, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ::DrawTexto( 6, ::nLinhaPdf - 54, 244, NIL, iif( Empty( ::cTelefoneEmitente ), "", "FONE: " + ::cTelefoneEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ::DrawTexto( 6, ::nLinhaPdf - 62, 244, NIL, Trim( ::cSiteEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ::DrawTexto( 6, ::nLinhaPdf - 70, 244, NIL, Trim( ::cEmailEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ELSE
      IF ::nLogoStyle == LAYOUT_LOGO_EXPANDIDO
         ::DrawJPEGImage( ::cLogoFile, 6, ::nLinhaPdf - ( 72 + 6 ), 238, 72 )
      ELSEIF ::nLogoStyle == LAYOUT_LOGO_ESQUERDA
         ::DrawJPEGImage( ::cLogoFile, 6, ::nLinhaPdf - ( 60 + 6 ), 54, 48 )
         HPDF_Page_SetFontAndSize( ::oPDFPage, ::oPDFFontBold, 12 )
         cTexto := ::FormataMemo( ::aEmit[ "xNome" ], 180 )
         ::DrawTexto( 64, ::nLinhaPdf - 6, 244, NIL,  MemoLine( cTexto, 1000, 1 ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
         ::DrawTexto( 64, ::nLinhaPDF - 18, 244, NIL, MemoLine( cTexto, 1000, 2 ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
         ::DrawTexto( 64, ::nLinhaPDF - 30, 244, NIL, MemoLine( cTexto, 1000, 3 ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
         ::DrawTexto( 64, ::nLinhaPdf - 42, 244, NIL, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
         ::DrawTexto( 64, ::nLinhaPdf - 50, 244, NIL, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
         ::DrawTexto( 64, ::nLinhaPdf - 58, 244, NIL, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
         ::DrawTexto( 64, ::nLinhaPdf - 66, 244, NIL, iif( Empty( ::cTelefoneEmitente ), "", "FONE: " + ::cTelefoneEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
         //::DrawTexto( 50, ::nLinhaPdf - 74, 244, NIL, Trim( ::cSiteEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
         //::DrawTexto( 50, ::nLinhaPdf - 82, 244, NIL, Trim( ::cEmailEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ELSEIF ::nLogoStyle == LAYOUT_LOGO_DIREITA
         ::DrawJPEGImage( ::cLogoFile, 182, ::nLinhaPdf - ( 72 + 6 ), 62, 72 )
         ::DrawTexto( 6, ::nLinhaPdf - 6, 180, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
         ::DrawTexto( 6, ::nLinhaPdf - 18, 180, NIL, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 2 ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
         ::DrawTexto( 6, ::nLinhaPdf - 30, 180, NIL, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
         ::DrawTexto( 6, ::nLinhaPdf - 38, 180, NIL, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
         ::DrawTexto( 6, ::nLinhaPdf - 46, 180, NIL, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
         ::DrawTexto( 6, ::nLinhaPdf - 54, 180, NIL, iif( Empty( ::cTelefoneEmitente ), "", "FONE: " + ::cTelefoneEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
         ::DrawTexto( 6, ::nLinhaPdf - 62, 180, NIL, Trim( ::cSiteEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
         ::DrawTexto( 6, ::nLinhaPdf - 70, 180, NIL, Trim( ::cEmailEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ENDIF
   ENDIF

   ::DrawBox( 245, ::nLinhaPdf - 80, 125, 80, ::nLarguraBox )
   ::DrawTexto( 246, ::nLinhaPdf - 4, 369, NIL, "DANFE", HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
   ::DrawTexto( 246, ::nLinhaPdf - 16, 369, NIL, "Documento Auxiliar da", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 246, ::nLinhaPdf - 24, 369, NIL, "Nota Fiscal Eletrônica", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )

   ::DrawTexto( 256, ::nLinhaPdf - 36, 349, NIL, "0 - ENTRADA", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
   ::DrawTexto( 256, ::nLinhaPdf - 44, 349, NIL, "1 - SAÍDA", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
   // preenchimento do tipo de nf
   ::DrawBox( 340, ::nLinhaPdf - 52, 20, 16, ::nLarguraBox )
   ::DrawTexto( 341, ::nLinhaPdf - 40, 359, NIL, ::aIde[ "tpNF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )

   ::DrawTexto( 246, ::nLinhaPdf - 56, 369, NIL, "Nº: " + Transform( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), "@R 999.999.999" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )
   ::DrawTexto( 246, ::nLinhaPdf - 66, 369, NIL, "SÉRIE: " + ::aIde[ "serie" ] + " - FOLHA " + AllTrim( Str( ::nFolha ) ) + "/" + AllTrim( Str( ::nLayoutTotalFolhas ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 9 )

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
   ::DrawTexto( 371, ::nLinhaPdf - 36, 589, NIL, "CHAVE DE ACESSO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   IF ::cFonteNFe == "Times"
      ::DrawTexto( 371, ::nLinhaPdf - 44, 589, NIL, Transform( ::cChave, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ELSE
      ::DrawTexto( 371, ::nLinhaPdf - 44, 589, NIL, Transform( ::cChave, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 6 )
   ENDIF
   // mensagem sistema sefaz
   ::DrawBox( 370, ::nLinhaPdf - 80, 220, 80, ::nLarguraBox )
   IF Empty( ::aInfProt[ "nProt" ] )
      ::DrawTexto( 371, ::nLinhaPdf - 55, 589, NIL, "N F E   A I N D A   N Ã O   F O I", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
      ::DrawTexto( 371, ::nLinhaPdf - 63, 589, NIL, "A U T O R I Z A D A   P E L A", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
      ::DrawTexto( 371, ::nLinhaPdf - 71, 589, NIL, "S E F A Z   (SEM VALIDADE FISCAL)", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   ELSE
      ::DrawTexto( 371, ::nLinhaPdf - 55, 589, NIL, "Consulta de autenticidade no portal nacional", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
      ::DrawTexto( 371, ::nLinhaPdf - 63, 589, NIL, "da NF-e www.nfe.fazenda.gov.br/portal ou", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
      ::DrawTexto( 371, ::nLinhaPdf - 71, 589, NIL, "no site da Sefaz Autorizadora", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   ENDIF
   ::nLinhaPdf -= 80
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 365, 16, "NATUREZA DA OPERAÇÃO", ::FormataString( ::aIde[ "natOp" ], 365, 10 ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   // PROTOCOLO
   ::DrawBox( 370, ::nLinhaPdf - 16, 220, 16, ::nLarguraBox )
   // ::DrawTexto(371, ::nLinhaPdf - 1, 589, NIL, "PROTOCOLO DE AUTORIZAÇÃO DE USO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 5 )
   IF ! Empty( ::aInfProt[ "nProt" ] )
      IF ::aInfProt[ "cStat" ] == '100'
         ::DrawTexto( 371, ::nLinhaPdf - 1, 589, NIL, "PROTOCOLO DE AUTORIZAÇÃO DE USO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 5 )
      ELSEIF ::aInfProt[ "cStat" ] == '101' .OR. ::aInfProt[ "cStat" ] == '135'
         ::DrawTexto( 371, ::nLinhaPdf - 1, 589, NIL, "PROTOCOLO DE HOMOLOGAÇÃO DO CANCELAMENTO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 5 )
      ENDIF
      IF ::cFonteNFe == "Times"
         ::DrawTexto( 371, ::nLinhaPdf - 6, 589, NIL, ::aInfProt[ "nProt" ] + " " + Substr( ::aInfProt[ "dhRecbto" ], 9, 2 ) + "/" + Substr( ::aInfProt[ "dhRecbto" ], 6, 2 ) + "/" + Substr( ::aInfProt[ "dhRecbto" ], 1, 4 ) + " " + Substr( ::aInfProt[ "dhRecbto" ], 12, 8 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 9 )
      ELSE
         ::DrawTexto( 371, ::nLinhaPdf - 6, 589, NIL, ::aInfProt[ "nProt" ] + " " + Substr( ::aInfProt[ "dhRecbto" ], 9, 2 ) + "/" + Substr( ::aInfProt[ "dhRecbto" ], 6, 2 ) + "/" + Substr( ::aInfProt[ "dhRecbto" ], 1, 4 ) + " " + Substr( ::aInfProt[ "dhRecbto" ], 12, 8 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 9 )
      ENDIF
   ENDIF
   ::nLinhaPdf -= 16
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 240, 16, "INSCRIÇÃO ESTADUAL", ::aEmit[ "IE" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 245, ::nLinhaPdf, 225, 16, "INSCRIÇÃO ESTADUAL DO SUBS. TRIBUTÁRIO", ::aEmit[ "IEST" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 470, ::nLinhaPdf, 120, 16, "C.N.P.J.", Transform( ::aEmit[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::nLinhaPdf -= 17

   RETURN NIL

METHOD QuadroDestinatario() CLASS hbNFeDaNFe

   ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "DESTINATÁRIO/REMETENTE", HPDF_TALIGN_LEFT, ::oPDFFontBold, 5 )
   ::nLinhaPdf -= 6
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 415, 16, "NOME / RAZÃO SOCIAL", ::aDest[ "xNome" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   IF ! Empty( ::aDest[ "CNPJ" ] )
      ::DrawBoxTituloTexto( 420, ::nLinhaPdf, 100, 16, "CNPJ/CPF", Transform( ::aDest[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 9 )
   ELSEIF ! Empty( ::aDest[ "CPF" ] )
      ::DrawBoxTituloTexto( 420, ::nLinhaPdf, 100, 16, "CNPJ/CPF", Transform( ::aDest[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ENDIF
   ::DrawBoxTituloTexto( 520, ::nLinhaPdf, 70, 16, "DATA DE EMISSÃO",  ;
      Substr( ::aIde[ "dhEmi" ], 9, 2 ) + "/" + Substr( ::aIde[ "dhEmi" ], 6, 2 ) + "/" + Substr( ::aIde[ "dhEmi" ], 1, 4 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::nLinhaPdf -= 16
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 265, 16, "ENDEREÇO", ::aDest[ "xLgr" ] + " " + ::aDest[ "nro" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
   ::DrawBoxTituloTexto( 270, ::nLinhaPdf, 190, 16, "BAIRRO", ::aDest[ "xBairro" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 460, ::nLinhaPdf, 60, 16, "C.E.P.", Transform( ::aDest[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 520, ::nLinhaPdf, 70, 16, "DATA SAIDA/ENTRADA", ;
      Substr( ::aIde[ "dhSaiEnt" ], 9, 2 ) + "/" + Substr( ::aIde[ "dhSaiEnt" ], 6, 2 ) + "/" + Substr( ::aIde[ "dhSaiEnt" ], 1, 4 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::nLinhaPdf -= 16
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 245, 16, "MUNICIPIO", ::aDest[ "xMun" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 250, ::nLinhaPdf, 30, 16, "ESTADO", ::aDest[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 280, ::nLinhaPdf, 150, 16, "FONE/FAX", ::FormataTelefone( ::aDest[ "fone" ] ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 430, ::nLinhaPdf, 90, 16, "INSCRIÇÃO ESTADUAL", ::aDest[ "IE" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 520, ::nLinhaPdf, 70, 16, "HORA DE SAIDA", Substr( ::aIde[ "dhSaiEnt" ], 12, 8 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::nLinhaPdf -= 17

   RETURN NIL

METHOD QuadroLocalRetirada() CLASS hbNFeDaNFe

   ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "INFORMAÇÕES DO LOCAL DE RETIRADA", HPDF_TALIGN_LEFT, ::oPDFFontBold, 5 )
   ::nLinhaPdf -= 6
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 485, 16, "NOME / RAZÃO SOCIAL", ::aRetirada[ "xNome" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   IF ! Empty( ::aDest[ "CNPJ" ] )
      ::DrawBoxTituloTexto( 490, ::nLinhaPdf, 100, 16, "CNPJ/CPF", Transform( ::aRetirada[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 9 )
   ELSEIF ! Empty( ::aDest[ "CPF" ] )
      ::DrawBoxTituloTexto( 490, ::nLinhaPdf, 100, 16, "CNPJ/CPF", Transform( ::aRetirada[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ENDIF
   ::nLinhaPdf -= 16
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 335, 16, "ENDEREÇO", ::aRetirada[ "xLgr" ] + " " + ::aRetirada[ "nro" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
   ::DrawBoxTituloTexto( 340, ::nLinhaPdf, 190, 16, "BAIRRO", ::aRetirada[ "xBairro" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 530, ::nLinhaPdf, 60, 16, "C.E.P.", Transform( ::aRetirada[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::nLinhaPdf -= 16
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 315, 16, "MUNICIPIO", ::aRetirada[ "xMun" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 320, ::nLinhaPdf, 30, 16, "ESTADO", ::aRetirada[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 350, ::nLinhaPdf, 150, 16, "FONE/FAX", ::FormataTelefone( ::aRetirada[ "fone" ] ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 500, ::nLinhaPdf, 90, 16, "INSCRIÇÃO ESTADUAL", ::aRetirada[ "IE" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::nLinhaPdf -= 17

   RETURN NIL

METHOD QuadroLocalEntrega() CLASS hbNFeDaNFe

   ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "INFORMAÇÕES DO LOCAL DE ENTREGA", HPDF_TALIGN_LEFT, ::oPDFFontBold, 5 )
   ::nLinhaPdf -= 6
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 485, 16, "NOME / RAZÃO SOCIAL", ::aEntrega[ "xNome" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   IF ! Empty( ::aDest[ "CNPJ" ] )
      ::DrawBoxTituloTexto( 490, ::nLinhaPdf, 100, 16, "CNPJ/CPF", Transform( ::aEntrega[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 9 )
   ELSEIF ! Empty( ::aDest[ "CPF" ] )
      ::DrawBoxTituloTexto( 490, ::nLinhaPdf, 100, 16, "CNPJ/CPF", Transform( ::aEntrega[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ENDIF
   ::nLinhaPdf -= 16
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 335, 16, "ENDEREÇO", ::aEntrega[ "xLgr" ] + " " + ::aEntrega[ "nro" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
   ::DrawBoxTituloTexto( 340, ::nLinhaPdf, 190, 16, "BAIRRO", ::aEntrega[ "xBairro" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 530, ::nLinhaPdf, 60, 16, "C.E.P.", Transform( ::aEntrega[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::nLinhaPdf -= 16
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 315, 16, "MUNICIPIO", ::aEntrega[ "xMun" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 320, ::nLinhaPdf, 30, 16, "ESTADO", ::aEntrega[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 350, ::nLinhaPdf, 150, 16, "FONE/FAX", ::FormataTelefone( ::aEntrega[ "fone" ] ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 500, ::nLinhaPdf, 90, 16, "INSCRIÇÃO ESTADUAL", ::aEntrega[ "IE" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::nLinhaPdf -= 17

   RETURN NIL

METHOD QuadroDuplicatas() CLASS hbNFeDaNFe

   LOCAL nICob, nItensCob, nLinhaFinalCob, nTamanhoCob, aList, cTPag, nPos
   LOCAL nTamForm, aDups, nColuna, cDup, cNumero, cVencimento, cValor, nCont

   IF ::nFolha != 1
      RETURN NIL
   ENDIF
   ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "FATURA/DUPLICATAS", HPDF_TALIGN_LEFT, ::oPDFFontBold, 5 )
   ::nLinhaPdf -= 6
   nICob := Len( MultipleNodeToArray( ::cCobranca, "dup" ) )
   DO CASE
   CASE nICob > 0
      nItensCob      := 1 + Int( ( nIcob - 1 ) / 3 )
      nLinhaFinalCob := ::nLinhaPdf - ( nItensCob * 8 ) - 2
      nTamanhoCob    := ( nItensCob * 8 ) + 2
      nTamForm := 585
      FOR nCont = 0 TO 2
         ::DrawBox( 5 + ( ( nTamForm / 3 ) * nCont ), nLinhaFinalCob, ( nTamForm / 3 ), nTamanhoCob, ::nLarguraBox )
      NEXT
      nTamForm := 585
      aDups    := MultipleNodeToArray( ::cCobranca, "dup" )
      nColuna  := 1
      FOR EACH cDup IN aDups
         cNumero := XmlNode( cDup, "nDup" )
         IF Empty( cNumero )
            EXIT
         ENDIF
         cVencimento := XmlNode( cDup, "dVenc" )
         cVencimento := Substr( cVencimento, 9, 2 ) + "/" + Substr( cVencimento, 6, 2 ) + "/" + Substr( cVencimento, 1, 4 )
         cValor      := AllTrim( FormatNumber( Val( XmlNode( cDup, "vDup" ) ), 13, 2 ) )
         IF nColuna > 3
            ::nLinhaPdf -= 8
            nColuna := 1
         ENDIF
         ::DrawTexto( 6 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), ::nLinhaPdf - 1,  80 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), NIL, cNumero, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
         ::DrawTexto( 82 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), ::nLinhaPdf - 1, 138 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), NIL, cVencimento, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
         ::DrawTexto( 140 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), ::nLinhaPdf - 1, 195 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), NIL, cValor, HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 8 )
         nColuna++
      NEXT
      ::nLinhaPdf -= 12
   CASE Len( ::aDetPag ) > 0
      aList := { ;
         { "01", "DINHEIRO" }, ;
         { "02", "CHEQUE" }, ;
         { "03", "CARTAO DE CREDITO" }, ;
         { "04", "CARTAO DE DEBITO" }, ;
         { "05", "CREDITO LOJA" }, ;
         { "10", "VALE ALIMENTACAO" }, ;
         { "11", "VALE REFEICAO" }, ;
         { "12", "VALE PRESENTE" }, ;
         { "13", "VALE COMBUSTIVEL" }, ;
         { "15", "BOLETO BANCARIO" }, ;
         { "90", "SEM PAGAMENTO" }, ;
         { "99", "OUTROS" } }
      nItensCob      := 1 + Int( ( Len( ::aDetPag ) - 1 ) / 3 )
      nLinhaFinalCob := ::nLinhaPdf - ( nItensCob * 8 ) - 2
      nTamanhoCob    := ( nItensCob * 8 ) + 2
      nTamForm       := 585
      FOR nCont = 0 TO 2
         ::DrawBox( 5 + ( ( nTamForm / 3 ) * nCont ), nLinhaFinalCob, ( nTamForm / 3 ), nTamanhoCob, ::nLarguraBox )
      NEXT
      nTamForm := 585
      nColuna  := 1
      FOR EACH cTPag IN ::aDetPag
         cNumero := XmlNode( cTPag, "tPag" )
         cValor  := AllTrim( FormatNumber( Val( XmlNode( cTPag, "vPag" ) ), 13, 2 ) )
         IF nColuna > 3
            ::nLinhaPdf -= 8
            nColuna := 1
         ENDIF
         IF ( nPos := hb_AScan( aList, { | e | e[ 1 ] == cNumero } ) ) != 0
            ::DrawTexto( 6 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), ::nLinhaPdf - 1, 122 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), NIL, aList[ nPos, 2 ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
         ENDIF
         ::DrawTexto( 130 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), ::nLinhaPdf - 1, 195 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), NIL, cValor, HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 8 )
         nColuna++
      NEXT
      ::nLinhaPdf -= 12
   OTHERWISE
      ::DrawBox( 5, ::nLinhaPdf - 12, 585, 12, ::nLarguraBox )
      IF ! Empty( ::aIde[ "indPag" ] )
         IF ::aIde[ "indPag" ] == "0"
            ::DrawTexto( 6, ::nLinhaPdf - 1,  589, NIL, "PAGAMENTO À VISTA", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
         ELSEIF ::aIde[ "indPag" ] == "1"
            ::DrawTexto( 6, ::nLinhaPdf - 1,  589, NIL, "PAGAMENTO À PRAZO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
         ELSE
            ::DrawTexto( 6, ::nLinhaPdf - 1,  589, NIL, "OUTROS", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
         ENDIF
      ENDIF
      ::nLinhaPdf -= 12
   ENDCASE

   RETURN NIL

METHOD QuadroImposto() CLASS hbNFeDaNFe

   IF ::nFolha == 1
      ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "CÁLCULO DO IMPOSTO", HPDF_TALIGN_LEFT, ::oPDFFontBold, 5 )
      ::nLinhaPdf -= 6
      ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 110, 16, "BASE DE CÁLCULO DO ICMS", AllTrim( FormatNumber( Val( ::aICMSTotal[ "vBC" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 115, ::nLinhaPdf, 100, 16, "VALOR DO ICMS", AllTrim( FormatNumber( Val( ::aICMSTotal[ "vICMS" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 215, ::nLinhaPdf, 130, 16, "BASE DE CÁLCULO DO ICMS SUBS. TRIB.", AllTrim( FormatNumber( Val( ::aICMSTotal[ "vBCST" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 345, ::nLinhaPdf, 100, 16, "VALOR DO ICMS SUBST.", AllTrim( FormatNumber( Val( ::aICMSTotal[ "vST" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 445, ::nLinhaPdf, 145, 16, "VALOR TOTAL DOS PRODUTOS", AllTrim( FormatNumber( Val( ::aICMSTotal[ "vProd" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::nLinhaPdf -= 16
      ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 88, 16, "VALOR DO FRETE", AllTrim( FormatNumber( Val( ::aICMSTotal[ "vFrete" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 93, ::nLinhaPdf, 88, 16, "VALOR DO SEGURO", AllTrim( FormatNumber( Val( ::aICMSTotal[ "vSeg" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 181, ::nLinhaPdf, 88, 16, "DESCONTO", AllTrim( FormatNumber( Val( ::aICMSTotal[ "vDesc" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 269, ::nLinhaPdf, 88, 16, "OUTRAS DESP. ACESSÓRIAS", AllTrim( FormatNumber( Val( ::aICMSTotal[ "vOutro" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 357, ::nLinhaPdf, 88, 16, "VALOR DO IPI", AllTrim( FormatNumber( Val( ::aICMSTotal[ "vIPI" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 445, ::nLinhaPdf, 145, 16, "VALOR TOTAL DA NOTA FISCAL", AllTrim( FormatNumber( Val( ::aICMSTotal[ "vNF" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::nLinhaPdf -= 17
   ENDIF

   RETURN NIL

METHOD QuadroTransporte() CLASS hbNFeDaNFe

   IF ::nFolha == 1
      ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "TRANSPORTADOR / VOLUMES TRANSPORTADOS", HPDF_TALIGN_LEFT, ::oPDFFontBold, 5 )
      ::nLinhaPdf -= 6
      ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 215, 16, "NOME/RAZÃO SOCIAL", ::FormataString( XmlToString( ::aTransp[ "xNome" ] ), 215, 8 ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
      IF ::aTransp[ "modFrete" ] == "0"
         ::DrawBoxTituloTexto( 220, ::nLinhaPdf, 90, 16, "FRETE POR CONTA", "0-EMITENTE", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ELSEIF ::aTransp[ "modFrete" ] == "1"
         ::DrawBoxTituloTexto( 220, ::nLinhaPdf, 90, 16, "FRETE POR CONTA", "1-DESTINATARIO", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ELSEIF ::aTransp[ "modFrete" ] == "2"
         ::DrawBoxTituloTexto( 220, ::nLinhaPdf, 90, 16, "FRETE POR CONTA", "2-TERCEIROS", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ELSEIF ::aTransp[ "modFrete" ] == "9"
         ::DrawBoxTituloTexto( 220, ::nLinhaPdf, 90, 16, "FRETE POR CONTA", "9-SEM FRETE", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ELSE
         ::DrawBoxTituloTexto( 220, ::nLinhaPdf, 90, 16, "FRETE POR CONTA", "", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ENDIF
      ::DrawBoxTituloTexto( 310, ::nLinhaPdf, 110, 16, "CÓDIGO ANTT", ::aVeicTransp[ "RNTC" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ::DrawBoxTituloTexto( 420, ::nLinhaPdf, 60, 16, "PLACA DO VEÍCULO", ::aVeicTransp[ "placa" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 480, ::nLinhaPdf, 20, 16, "UF", ::aVeicTransp[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      IF ! Empty( ::aTransp[ "CNPJ" ] )
         ::DrawBoxTituloTexto( 500, ::nLinhaPdf, 90, 16, "CNPJ / CPF", Transform( ::aTransp[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ELSEIF ! Empty( ::aTransp[ "CPF" ] )
         ::DrawBoxTituloTexto( 500, ::nLinhaPdf, 90, 16, "CNPJ / CPF", Transform( ::aTransp[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ELSE
         ::DrawBoxTituloTexto( 500, ::nLinhaPdf, 90, 16, "CNPJ / CPF", "", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ENDIF
      ::nLinhaPdf -= 16
      ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 265, 16, "ENDEREÇO", ::aTransp[ "xEnder" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
      ::DrawBoxTituloTexto( 270, ::nLinhaPdf, 210, 16, "MUNICÍPIO", ::aTransp[ "xMun" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 480, ::nLinhaPdf, 20, 16, "UF", ::aTransp[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 500, ::nLinhaPdf, 90, 16, "INSCRIÇÃO ESTADUAL", ::aTransp[ "IE" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ::nLinhaPdf -= 16
      ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 95, 16, "QUANTIDADE", LTrim( FormatNumber( Val( ::aTransp[ "qVol" ] ), 15, 0 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 8 )
      ::DrawBoxTituloTexto( 100, ::nLinhaPdf, 100, 16, "ESPÉCIE", ::aTransp[ "esp" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 200, ::nLinhaPdf, 100, 16, "MARCA", ::aTransp[ "marca" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 300, ::nLinhaPdf, 100, 16, "NUMERAÇÃO", ::aTransp[ "nVol" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 400, ::nLinhaPdf, 100, 16, "PESO BRUTO", LTrim( FormatNumber( Val( ::aTransp[ "pesoB" ] ), 15, 3 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 500, ::nLinhaPdf, 90, 16, "PESO LÍQUIDO", LTrim( FormatNumber( Val( ::aTransp[ "pesoL" ] ), 15, 3 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::nLinhaPdf -= 17
   ENDIF

   RETURN NIL

METHOD QuadroProdutosTitulo() CLASS hbNFeDaNFe

   LOCAL oElement

   ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "DADOS DOS PRODUTOS / SERVIÇOS", HPDF_TALIGN_LEFT, ::oPDFFontBold, 5 )
   ::nLinhaPdf -= LAYOUT_FONTSIZE
   FOR EACH oElement IN ::aLayout
      ::DrawBoxProduto( oElement:__EnumIndex, ::nLinhaPdf - ( LAYOUT_FONTSIZE * 2 + 1 ), ( LAYOUT_FONTSIZE * 2 + 1 ), ::nLarguraBox )
      ::DrawTextoProduto( oElement:__EnumIndex, ::nLinhaPdf - 1,                  LAYOUT_TITULO1, HPDF_TALIGN_CENTER )
      ::DrawTextoProduto( oElement:__EnumIndex, ::nLinhaPdf - LAYOUT_FONTSIZE, LAYOUT_TITULO2, HPDF_TALIGN_CENTER )
   NEXT
   ::nLinhaPdf -= LAYOUT_FONTSIZE * 2 + 1

   RETURN NIL

METHOD QuadroProdutosDesenho( nLinhaFinalProd, nAlturaQuadroProdutos ) CLASS hbNFeDaNFe

   LOCAL oElement

   FOR EACH oElement IN ::aLayout
      ::DrawBoxProduto( oElement:__EnumIndex, nLinhaFinalProd, nAlturaQuadroProdutos, ::nLarguraBox )
   NEXT
   ::nLinhaPdf -= 1

   RETURN NIL

METHOD QuadroProdutos() CLASS hbNFeDaNFe

   LOCAL nLinhaFinalProd, nAlturaQuadroProdutos, nItem, nNumLinha, nCont

   nLinhaFinalProd := ::nLinhaPdf - ( ::LinhasPraProduto() * LAYOUT_FONTSIZE ) - 2
   nAlturaQuadroProdutos := ( ::LinhasPraProduto() * LAYOUT_FONTSIZE ) + 2
   ::QuadroProdutosDesenho( nLinhaFinalProd, nAlturaQuadroProdutos )

   nItem := 1
   ::nLinhaFolha := 0
   DO WHILE .T.
      IF ! ::ProcessaItens( ::cXml, nItem )
         EXIT
      ENDIF
      ::aItem[ "xProd" ]     := ::FormataMemo( ::aItem[ "xProd" ],     ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] - 2 )
      ::aItem[ "infAdProd" ] := ::FormataMemo( ::aItem[ "infAdProd" ], ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] - 2 )
      IF ::nLinhaFolha + MLCount( ::aItem[ "xProd" ], 1000 ) + MLCount( ::aItem[ "infAdProd" ], 1000 ) > ::LinhasPraProduto()
         ::saltaPagina()
      ENDIF
      ::DrawTextoProduto( LAYOUT_CODIGO,    ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_CENTER )
      ::DrawTextoProduto( LAYOUT_DESCRICAO, ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_LEFT )
      ::DrawTextoProduto( LAYOUT_NCM,       ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_CENTER )
      ::DrawTextoProduto( LAYOUT_EAN,       ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_CENTER )
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
      ::nLinhaPdf -= LAYOUT_FONTSIZE
      nItem++
      ::nLinhaFolha++
      FOR nNumLinha = 2 TO MLCount( ::aItem[ "xProd" ], 1000 )
//         IF ::nLinhaFolha > ::LinhasPraProduto()
//            ::saltaPagina()
//         ENDIF
         ::DrawTextoProduto( LAYOUT_DESCRICAO, ::nLinhaPdf, MemoLine( ::aItem[ "xProd" ], 1000, nNumLinha ), HPDF_TALIGN_LEFT )
         ::nLinhaFolha++
         ::nLinhaPdf -= LAYOUT_FONTSIZE
      NEXT
      FOR nNumLinha = 1 TO MLCount( ::aItem[ "infAdProd" ], 1000 )
//         IF ::nLinhaFolha > ::LinhasPraProduto()
//            ::saltaPagina()
//         ENDIF
         ::DrawTextoProduto( LAYOUT_DESCRICAO, ::nLinhaPdf, MemoLine( ::aItem[ "infAdProd" ], 1000, nNumLinha ), HPDF_TALIGN_LEFT )
         ::nLinhaFolha++
         ::nLinhaPdf -= LAYOUT_FONTSIZE
      NEXT
      IF ::lLayoutEspacoDuplo
         ::nLinhaPdf -= LAYOUT_FONTSIZE
         ::nLinhaFolha++
      ENDIF
      IF ::nLinhaFolha <= ::LinhasPraProduto() .AND. ! ::lLayoutEspacoDuplo
         ::DrawLine( 5, ::nLinhaPdf - 0.5, 590, ::nLinhaPdf - 0.5, ::nLarguraBox )
      ENDIF
   ENDDO
   IF MLCount( ::aInfAdic[ "infCpl" ], 1000 ) > Int( 78 / LAYOUT_FONTSIZE )
      ::nLinhaFolha++
      ::nLinhaPdf -= LAYOUT_FONTSIZE
      ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "*CONTINUACAO INFORMAÇÕES COMPLEMENTARES*", HPDF_TALIGN_LEFT, ::oPDFFontNormal, LAYOUT_FONTSIZE )
      ::nLinhaFolha++
      ::nLinhaPdf -= LAYOUT_FONTSIZE
      FOR nCont = Int( 78 / LAYOUT_FONTSIZE ) + 1 TO MLCount( ::aInfAdic[ "infCpl" ], 1000 )
         IF ::nLinhaFolha > ::LinhasPraProduto()
            ::SaltaPagina()
            ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "*CONTINUACAO INFORMAÇÕES COMPLEMENTARES*", HPDF_TALIGN_LEFT, ::oPDFFontNormal, LAYOUT_FONTSIZE )
            ::nLinhaFolha++
            ::nLinhaPdf -= LAYOUT_FONTSIZE
         ENDIF
         ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, MemoLine( ::aInfAdic[ "infCpl" ], 1000, nCont ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, LAYOUT_FONTSIZE )
         ::nLinhaFolha++
         ::nLinhaPdf -= LAYOUT_FONTSIZE
      NEXT
   ENDIF
   ::nLinhaPdf -= ( ( ::LinhasPraProduto() - ::nLinhaFolha + 1 ) * LAYOUT_FONTSIZE )
   ::nLinhaPdf -= 2

   RETURN NIL

METHOD QuadroTotalServico() CLASS hbNFeDaNFe

   IF ::nFolha == 1
      IF Val( ::aISSTotal[ "vServ" ] ) > 0
         ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "CALCULO DO ISSQN", HPDF_TALIGN_LEFT, ::oPDFFontBold, 5 )

         ::nLinhaPdf -= 6

         ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 150, 16, "INSCRIÇÃO MUNICIPAL", ::aEmit[ "IM" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )

         ::DrawBoxTituloTexto( 155, ::nLinhaPdf, 145, 16, "VALOR TOTAL DOS SERVIÇOS", FormatNumber( Val( ::aISSTotal[ "vServ" ] ), 15 ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )

         ::DrawBoxTituloTexto( 300, ::nLinhaPdf, 145, 16, "BASE DE CÁLCULO DO ISSQN", FormatNumber( Val( ::aISSTotal[ "vBC" ] ), 15 ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )

         ::DrawBoxTituloTexto( 445, ::nLinhaPdf, 145, 16, "VALOR DO ISSQN", FormatNumber( Val( ::aISSTotal[ "vISS" ] ), 15 ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )

         ::nLinhaPdf -= 17
      ENDIF
   ENDIF

   RETURN NIL

METHOD QuadroDadosAdicionais() CLASS hbNFeDaNFe

   LOCAL cMemo, nCont

   IF ::nFolha == 1
      cMemo := ::aInfAdic[ "infCpl" ]
      ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "DADOS ADICIONAIS", HPDF_TALIGN_LEFT, ::oPDFFontBold, 5 )
      ::nLinhaPdf -= 6

      ::DrawBox( 5, ::nLinhaPdf - 92, 395, 92, ::nLarguraBox )
      ::DrawTexto( 6, ::nLinhaPdf - 1, 399, NIL, "INFORMAÇÕES COMPLEMENTARES", HPDF_TALIGN_LEFT, ::oPDFFontNormal, LAYOUT_FONTSIZE )

      ::DrawBox( 400, ::nLinhaPdf - 92, 190, 92, ::nLarguraBox )
      ::DrawTexto( 401, ::nLinhaPdf - 1, 589, NIL, "RESERVADO AO FISCO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
      ::nLinhaPdf -= 7    //
      ::nLinhaPdf -= 4 // ESPAÇO
      FOR nCont = 1 TO Min( MLCount( cMemo, 1000 ), Int( 78 / LAYOUT_FONTSIZE ) )
         ::DrawTexto( 6, ::nLinhaPDF - ( ( nCont - 1 ) * LAYOUT_FONTSIZE ), 399, NIL, Trim( MemoLine( cMemo, 1000, nCont ) ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, LAYOUT_FONTSIZE )
      NEXT
      //cMemo := ::FormataMemo( ::aInfAdic[ "infAdFisco" ], 186 )
      //FOR nCont = 1 TO Min( MLCount( cMemo, 1000 ), Int( 78 / LAYOUT_FONTSIZE ) )
      //   ::DrawTexto( 401, ::nLinhaPDF - ( ( nCont - 1 ) * LAYOUT_FONTSIZE ), 588, NIL, Trim( MemoLine( cMemo, 1000, nCont ) ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, LAYOUT_FONTSIZE )
      //NEXT
      ::nLinhaPDF -= 78 + 4
   ENDIF

   RETURN NIL

METHOD ProcessaItens( cXml, nItem ) CLASS hbNFeDaNFe

   LOCAL cItem, aItem

   aItem := MultipleNodeToArray( cXml, "det" )
   IF Len( aItem ) < nItem
      RETURN .F.
   ELSE
      cItem := aItem[ nItem ]
      ::aItem          := XmlToHash( cItem, { "cProd", "cEAN", "xProd", "NCM", "EXTIPI", "CFOP", "uCom", "qCom", "vUnCom", "vProd", "cEANTrib", "uTrib", "qTrib", "vUnTrib", "vFrete", ;
         "vSeg", "vDesc", "vOutro", "indTot", "infAdProd" } )
      ::aItem[ "cEAN" ] := iif( ::aItem[ "cEAN" ] == "SEM GTIN", "", ::aItem[ "cEAN" ] )
      ::aItem[ "cEANTrib" ] := iif( ::aItem[ "cEANTrib" ] == "SEM GTIN", "", ::aItem[ "cEANTrib" ] )
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
   ENDIF

   RETURN .T.

METHOD CalculaLayout() CLASS hbNFeDaNFe

   LOCAL nItem, nQtdLinhas

   ::DefineColunasProdutos()
   ::aInfAdic[ "infCpl" ] := ::FormataMemo( ::aInfAdic[ "infCpl" ], 392 )
   ::nLayoutTotalFolhas := 1
   nQtdLinhas := 0
   nItem      := 1
   DO WHILE .T.
      IF ! ::ProcessaItens( ::cXml, nItem )
         EXIT
      ENDIF
      ::aItem[ "xProd" ] := ::FormataMemo( ::aItem[ "xProd" ], ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] - 2 )
      IF Len( ::aItem[ "infAdProd" ] ) > 0
         ::aItem[ "infAdProd" ] := ::FormataMemo( ::aItem[ "infAdProd" ], ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] - 2 )
      ENDIF
      IF nQtdLinhas + MLCount( ::aItem[ "xProd" ], 1000 ) + MLCount( ::aItem[ "infAdProd" ], 1000 ) > ::LinhasPraProduto( ::nLayoutTotalFolhas )
         ::nLayoutTotalFolhas += 1
         nQtdLinhas := 0
      ENDIF
      nQtdLinhas += MLCount( ::aItem[ "xProd" ], 1000 )
      nQtdLinhas += MLCount( ::aItem[ "infAdProd" ], 1000 )
      IF ::lLayoutEspacoDuplo
         nQtdLinhas += 1
      ENDIF
      nItem += 1
   ENDDO
   IF ::lLayoutEspacoDuplo
      nQtdLinhas -= 1
   ENDIF
   // Linhas extras pra informações adicionais
   IF MLCount( ::ainfAdic[ "infCpl" ], 1000 ) > Int( 78 / LAYOUT_FONTSIZE )
      nQtdLinhas += 2 + MLCount( ::ainfAdic[ "infCpl" ], 1000 ) - Int( 78 / LAYOUT_FONTSIZE )
   ENDIF
   IF nQtdLinhas > ::LinhasPraProduto( ::nLayoutTotalFolhas )
      ::nLayoutTotalFolhas += 1
   ENDIF

   RETURN NIL

METHOD LinhasPraProduto( nFolha ) CLASS hbNFeDaNFe

   LOCAL nQuadro := 630, nParcelas

   nFolha := iif( nFolha == NIL, ::nFolha, nFolha )

   IF nFolha == 1
      nQuadro := 291 + ;
         iif( ::lLaser, 54, 0  ) + ;
         iif( Val( ::aIssTotal[ "vServ" ] ) <= 0, 24, 0 )
      nParcelas := Len( MultipleNodeToArray( ::cCobranca, "dup" ) )
      IF nParcelas > 0
         nQuadro -= ( ( 1 + Int( ( nParcelas - 1 ) / 3 ) ) ) * 8 + 2
      ELSEIF Len( ::aDetPag ) > 0
         nQuadro -= ( ( 1 + Int( ( Len( ::aDetPag ) - 1 ) / 3 ) ) ) * 8 + 2
      ENDIF
      IF ::lQuadroEntrega
         IF ! Empty( ::aEntrega[ "xLgr" ] )
            nQuadro -= 55
         ENDIF
         IF ! Empty( ::aRetirada[ "xLgr" ] )
            nQuadro -= 55
         ENDIF
      ENDIF
   ENDIF

   RETURN Int( nQuadro / LAYOUT_FONTSIZE )

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
      IF ::aLayout[ nCampo, LAYOUT_IMPRIME ] == LAYOUT_IMPRIMESEGUNDA
         nRow -= LAYOUT_FONTSIZE
      ENDIF
      ::DrawTexto( nColunaInicial, nRow, nColunaFinal, NIL, cTexto, nAlign, ::oPDFFontNormal, LAYOUT_FONTSIZE )
   ENDIF

   RETURN NIL

METHOD DrawBoxProduto( nCampo, nRow, nHeight ) CLASS hbNfeDaNFe

   IF ::aLayout[ nCampo, LAYOUT_IMPRIME ] == LAYOUT_IMPRIMENORMAL
      ::DrawBox( ::aLayout[ nCampo, LAYOUT_COLUNAPDF ] - 1, nRow, ::aLayout[ nCampo, LAYOUT_LARGURAPDF ], nHeight, ::nLarguraBox )
   ENDIF

   RETURN NIL

METHOD DefineColunasProdutos() CLASS hbNFeDaNFe

   LOCAL oElement, nItem, nCont, nColunaFinal, nTentativa

   ::ProcessaItens( ::cXml, 1 ) // precisa de ::aItem pra gerar o codeblock
   ::aLayout[ LAYOUT_CODIGO,    LAYOUT_TITULO1 ]   := "CÓDIGO"
   ::aLayout[ LAYOUT_CODIGO,    LAYOUT_CONTEUDO ]  := { || ::aItem[ "cProd" ] }
   ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_TITULO1 ]   := "DESCRIÇÃO DO PRODUTO / SERVIÇO"
   ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_CONTEUDO ]  := { || MemoLine( ::aItem[ "xProd" ], ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURA ], 1 ) }
   ::aLayout[ LAYOUT_NCM,       LAYOUT_TITULO1 ]   := "NCM/SH"
   ::aLayout[ LAYOUT_NCM,       LAYOUT_CONTEUDO ]  := { || ::aItem[ "NCM" ] }
   ::aLayout[ LAYOUT_EAN,       LAYOUT_TITULO1 ]   := "EAN"
   ::aLayout[ LAYOUT_EAN,       LAYOUT_CONTEUDO ]  := { || ::aItem[ "cEAN" ] }
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
   ::aLayout[ LAYOUT_TOTAL,     LAYOUT_TITULO1 ]   := "VALOR"
   ::aLayout[ LAYOUT_TOTAL,     LAYOUT_TITULO2 ]   := "TOTAL"
   ::aLayout[ LAYOUT_TOTAL,     LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItem[ "vProd" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_DESCONTO,  LAYOUT_TITULO1 ]   := "VALOR"
   ::aLayout[ LAYOUT_DESCONTO,  LAYOUT_TITULO2 ]   := "DESCTO"
   ::aLayout[ LAYOUT_DESCONTO,  LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItem[ "vDesc" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_ICMBAS,    LAYOUT_TITULO1 ]   := "B.CÁLC."
   ::aLayout[ LAYOUT_ICMBAS,    LAYOUT_TITULO2 ]   := "ICMS"
   ::aLayout[ LAYOUT_ICMBAS,    LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItemICMS[ "vBC" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_ICMVAL,    LAYOUT_TITULO1 ]   := "VALOR"
   ::aLayout[ LAYOUT_ICMVAL,    LAYOUT_TITULO2 ]   := "ICMS"
   ::aLayout[ LAYOUT_ICMVAL,    LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItemICMS[ "vICMS" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_SUBBAS,    LAYOUT_TITULO1 ]   := "B.CÁLC."
   ::aLayout[ LAYOUT_SUBBAS,    LAYOUT_TITULO2 ]   := "ICMS ST"
   ::aLayout[ LAYOUT_SUBBAS,    LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItemICMS[ "vBCST" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_SUBVAL,    LAYOUT_TITULO1 ]   := "VALOR"
   ::aLayout[ LAYOUT_SUBVAL,    LAYOUT_TITULO2 ]   := "ICMS ST"
   ::aLayout[ LAYOUT_SUBVAL,    LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItemICMS[ "vICMSST" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_IPIVAL,    LAYOUT_TITULO1 ]   := "VALOR"
   ::aLayout[ LAYOUT_IPIVAL,    LAYOUT_TITULO2 ]   := "IPI"
   ::aLayout[ LAYOUT_IPIVAL,    LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItemIPI[ "vIPI" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_ICMALI,    LAYOUT_TITULO1 ]   := "ALÍQ"
   ::aLayout[ LAYOUT_ICMALI,    LAYOUT_TITULO2 ]   := "ICMS"
   ::aLayout[ LAYOUT_ICMALI,    LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItemICMS[ "pICMS" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_IPIALI,    LAYOUT_TITULO1 ]   := "ALÍQ"
   ::aLayout[ LAYOUT_IPIALI,    LAYOUT_TITULO2 ]   := "IPI"
   ::aLayout[ LAYOUT_IPIALI,    LAYOUT_CONTEUDO ]  := { || AllTrim( FormatNumber( Val( ::aItemIPI[ "pIPI" ] ), 15, 2 ) ) }

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
         IF ::aLayout[ LAYOUT_IPIVAL, LAYOUT_IMPRIME ] == LAYOUT_IMPRIMEXMLTEM
            ::aLayout[ LAYOUT_IPIVAL, LAYOUT_IMPRIME ] := LAYOUT_IMPRIMENORMAL
         ENDIF
         IF ::aLayout[ LAYOUT_IPIALI, LAYOUT_IMPRIME ] == LAYOUT_IMPRIMEXMLTEM
            ::aLayout[ LAYOUT_IPIALI, LAYOUT_IMPRIME ] := LAYOUT_IMPRIMENORMAL
         ENDIF
      ENDIF
      IF Val( ::aItemICMS[ "vBCST" ] ) > 0 .OR. Val( ::aItemICMS[ "vICMSST" ] ) > 0
         IF ::aLayout[ LAYOUT_SUBBAS, LAYOUT_IMPRIME ] == LAYOUT_IMPRIMEXMLTEM
            ::aLayout[ LAYOUT_SUBBAS, LAYOUT_IMPRIME ] := LAYOUT_IMPRIMENORMAL
         ENDIF
         IF ::aLayout[ LAYOUT_SUBVAL, LAYOUT_IMPRIME ] == LAYOUT_IMPRIMEXMLTEM
            ::aLayout[ LAYOUT_SUBVAL, LAYOUT_IMPRIME ] := LAYOUT_IMPRIMENORMAL
         ENDIF
      ENDIF
      IF Val( ::aItem[ "vDesc" ] ) > 0
         IF ::aLayout[ LAYOUT_DESCONTO, LAYOUT_IMPRIME ] == LAYOUT_IMPRIMEXMLTEM
            ::aLayout[ LAYOUT_DESCONTO, LAYOUT_IMPRIME ] := LAYOUT_IMPRIMENORMAL
         ENDIF
      ENDIF
      IF ! Empty( ::aItem[ "cEAN" ] )
         IF ::aLayout[ LAYOUT_EAN, LAYOUT_IMPRIME ] == LAYOUT_IMPRIMEXMLTEM
            ::aLayout[ LAYOUT_EAN, LAYOUT_IMPRIME ] := LAYOUT_IMPRIMENORMAL
         ENDIF
      ENDIF
   ENDDO
   // Define tamanho de colunas
   FOR EACH oElement IN ::aLayout
      IF oElement[ LAYOUT_IMPRIME ] == LAYOUT_IMPRIMEXMLTEM
         oElement[ LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME  // não tem no XML, então não sai
      ENDIF
      oElement[ LAYOUT_LARGURA ] += 1
      oElement[ LAYOUT_LARGURAPDF ] := Max( oElement[ LAYOUT_LARGURAPDF ], ::LarguraTexto( oElement[ LAYOUT_TITULO1 ] ) )
      oElement[ LAYOUT_LARGURAPDF ] := Max( oElement[ LAYOUT_LARGURAPDF ], ::LarguraTexto( oELement[ LAYOUT_TITULO2 ] ) )
      oElement[ LAYOUT_LARGURAPDF ] += 4
   NEXT

   FOR nTentativa = 1 TO 5
      // Desativa colunas não impressas - talvez linha 2
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

      // MsgExclamation( "Largura descrição " + Str( ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] ) )
      IF ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] > 150
         EXIT
      ENDIF
      // Se não sobrar espaço pra descrição, desativa colnas
      DO CASE
      CASE nTentativa == 1 ; ::aLayout[ LAYOUT_EAN, LAYOUT_IMPRIME ]      := LAYOUT_NAOIMPRIME
      CASE nTentativa == 2 ; ::aLayout[ LAYOUT_SUBBAS, LAYOUT_IMPRIME ]   := LAYOUT_NAOIMPRIME
      CASE nTentativa == 3 ; ::aLayout[ LAYOUT_DESCONTO, LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
      CASE nTentativa == 4 ; ::aLayout[ LAYOUT_SUBVAL, LAYOUT_IMPRIME ]   := LAYOUT_NAOIMPRIME
      ENDCASE
   NEXT

   RETURN NIL
