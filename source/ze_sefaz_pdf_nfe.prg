/*
ZE_SPEDDANFE - Documento Auxiliar da Nota Fiscal Eletr�nica
Baseado no projeto hbnfe em https://github.com/fernandoathayde/hbnfe

Anota��o (manual do usu�rio 6.0):
Os campos que podem ser colocados na mesma coluna s�o:
- �C�digo do Produto/Servi�o� com �NCM/SH� ;
- �CST� com �CFOP� ;
- �CSOSN� com �CFOP� ;
- �Quantidade� com �Unidade� ;
- �Valor Unit�rio� com �Desconto� ;
- �Valor Total� com �Base de C�lculo do ICMS� ;
- �Base de C�lculo do ICMS por Substitui��o Tribut�ria� com �Valor do ICMS por Substitui��o Tribut�ria� ;
- �Valor do ICMS Pr�prio� com �Valor do IPI�
- �Al�quota do ICMS� com �Al�quota do IPI�.

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
#define LAYOUT_IMPRIME2XMLTEM  4

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
#define LAYOUT_UN_TRIB         19
#define LAYOUT_QTD_TRIB        20
#define LAYOUT_VALOR_TRIB      21

#define LAYOUT_TOTCOLUNAS      21

#define LAYOUT_FONTSIZE      8

CREATE CLASS hbNFeDaNFe INHERIT hbNFeDaGeral

   METHOD ToPDF( cXmlNFE, cFilePDF, cXmlCancel, oPDF, lEnd )
   METHOD BuscaDadosXML()
   METHOD GeraPDF( cFilePDF, oPDF, lEnd )
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
   METHOD ItensDaFolha( nFolha )
   METHOD Init()
   METHOD DrawTextoProduto( nCampo, nRow, nConteudo, nAlign )
   METHOD DrawBoxProduto( nCampo, nRow, nHeight )
   METHOD DefineColunasQuadroProdutos()
   METHOD SetDescontoOff()      INLINE ::aLayout[ LAYOUT_DESCONTO,   LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
   METHOD SetSubBasOff()        INLINE ::aLayout[ LAYOUT_SUBBAS,     LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
   METHOD SetSubValOff()        INLINE ::aLayout[ LAYOUT_SUBVAL,     LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
   METHOD SetIpiValOff()        INLINE ::aLayout[ LAYOUT_IPIVAL,     LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
   METHOD SetIpiAliOff()        INLINE ::aLayout[ LAYOUT_IPIALI,     LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
   METHOD SetEanOff()           INLINE ::aLayout[ LAYOUT_EAN,        LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
   METHOD SetDadosTribOff()     INLINE ::aLayout[ LAYOUT_UN_TRIB,    LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME, ;
                                       ::aLayout[ LAYOUT_QTD_TRIB,   LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME, ;
                                       ::aLayout[ LAYOUT_VALOR_TRIB, LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME

   VAR lGroupPDF         INIT .F.
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
   VAR aInfCanc

   VAR aItem
   VAR aItemDI
   VAR aItemAdi
   VAR aItemArma
   VAR aItemVeicProd
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
   VAR cFonteCode128
   VAR cFonteCode128F
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
   VAR lFantasiaCabecalho  INIT .F.
   VAR lLayoutPreview      INIT .F.
   VAR aLayout
   VAR aPageList           INIT {}
   VAR aPageRow            INIT { 0, 0, 0 }

   ENDCLASS

METHOD Init() CLASS hbNFeDaNFe

   LOCAL oElement

   ::aLayout := Array( LAYOUT_TOTCOLUNAS )
   FOR EACH oElement IN ::aLayout
      oElement := Array(10)
      oElement[ LAYOUT_IMPRIME ]    := LAYOUT_IMPRIMENORMAL
      oElement[ LAYOUT_TITULO1 ]    := ""
      oElement[ LAYOUT_TITULO2 ]    := ""
      oElement[ LAYOUT_CONTEUDO ]   := { || "" }
      oElement[ LAYOUT_LARGURAPDF ] := 1
   NEXT
   ::aLayout[ LAYOUT_DESCONTO,   LAYOUT_IMPRIME ] := LAYOUT_IMPRIMEXMLTEM
   ::aLayout[ LAYOUT_SUBBAS,     LAYOUT_IMPRIME ] := LAYOUT_IMPRIMEXMLTEM
   ::aLayout[ LAYOUT_SUBVAL,     LAYOUT_IMPRIME ] := LAYOUT_IMPRIMEXMLTEM
   ::aLayout[ LAYOUT_IPIVAL,     LAYOUT_IMPRIME ] := LAYOUT_IMPRIMEXMLTEM
   ::aLayout[ LAYOUT_IPIALI,     LAYOUT_IMPRIME ] := LAYOUT_IMPRIMEXMLTEM
   ::aLayout[ LAYOUT_EAN,        LAYOUT_IMPRIME ] := LAYOUT_IMPRIMEXMLTEM
   ::aLayout[ LAYOUT_UN_TRIB,    LAYOUT_IMPRIME ] := LAYOUT_IMPRIMEXMLTEM
   ::aLayout[ LAYOUT_QTD_TRIB,   LAYOUT_IMPRIME ] := LAYOUT_IMPRIMEXMLTEM
   ::aLayout[ LAYOUT_VALOR_TRIB, LAYOUT_IMPRIME ] := LAYOUT_IMPRIMEXMLTEM

   RETURN SELF

METHOD ToPDF( cXmlNFE, cFilePDF, cXmlCancel, oPDF, lEnd ) CLASS hbNFeDaNFe

   hb_Default( @lEnd, .T. )

   IF Empty( cXmlNFE )
      ::cRetorno := "XML sem conte�do"
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

   IF ! lEnd
      ::GeraPDF( cFilePDF, oPDF, lEnd )
      oPDF := ::oPDF
      RETURN oPDF
   ENDIF
   IF ! ::GeraPDF( cFilePDF )
      ::cRetorno := "Problema ao gerar o PDF"
      RETURN ::cRetorno
   ENDIF
   ::cRetorno := "OK"

   RETURN ::cRetorno

METHOD BuscaDadosXML() CLASS hbNFeDaNFe

   LOCAL cText, aNFRef, oElement, cItem

   ::cXml := XmlToString( ::cXml )
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
   IF Empty( ::aEmit[ "CNPJ" ] )
      ::aEmit[ "CNPJ" ] := ::aEmit[ "CPF" ]
   ENDIF
   ::aDest       := XmlToHash( XmlNode( ::cXml, "dest" ), { "CNPJ", "CPF", "xNome", "xLgr", "nro", "xCpl", "xBairro", "cMun", "xMun", "UF", "CEP", "cPais", "xPais", "fone", "IE", "ISUF", "email", "idEstrangeiro" } )
   IF ! Empty( ::aDest[ "idEstrangeiro" ] )
      ::aDest[ "IE" ] := ::aDest[ "idEstrangeiro" ]
   ENDIF
   IF Empty( ::aDest[ "CNPJ" ] )
      ::aDest[ "CNPJ" ] := ::aDest[ "CPF" ]
   ENDIF
   ::aRetirada   := XmlToHash( XmlNode( ::cXml, "retirada" ), { "CNPJ", "CPF", "xNome", "xLgr", "nro", "xCpl", "xBairro", "CEP", "cMun", "xMun", "UF", "fone", "IE" } )
   IF Empty( ::aRetirada[ "CNPJ" ] )
      ::aRetirada[ "CNPJ" ] := ::aRetirada[ "CPF" ]
   ENDIF
   ::aEntrega    := XmlToHash( XmlNode( ::cXml, "entrega" ), { "CNPJ", "CPF", "xNome", "xLgr", "nro", "xCpl", "xBairro", "CEP", "cMun", "xMun", "UF", "fone", "IE" } )
   IF Empty( ::aEntrega[ "CNPJ" ] )
      ::aEntrega[ "CNPJ" ] := ::aEntrega[ "CPF" ]
   ENDIF
   ::aICMSTotal  := XmlToHash( XmlNode( ::cXml, "ICMSTot" ), { "vBC", "vICMS", "vBCST", "vST", "vProd", "vFrete", "vSeg", "vDesc", "vII", "vIPI", "vPIS", "vCOFINS", "vOutro", "vNF" } )
   ::aISSTotal   := XmlToHash( XmlNode( ::cXml, "ISSQNtot" ), { "vServ", "vBC", "vISS", "vPIS", "vCOFINS" } )
   ::aRetTrib    := XmlToHash( XmlNode( ::cXml, "RetTrib" ), { "vRetPIS", "vRetCOFINS", "vRetCSLL", "vBCIRRF", "vIRRF", "vBCRetPrev", "vRetPrev" } )
   ::aTransp     := XmlToHash( XmlNode( ::cXml, "transp" ), { "modFrete", "CNPJ", "CPF", "xNome", "IE", "xEnder", "xMun", "UF", "qVol", "esp", "marca", "nVol", "pesoL", "pesoB", "nLacre" } )
   ::aVeicTransp := XmlToHash( XmlNode( XmlNode( ::cXml, "transp" ), "veicTransp" ), { "placa", "UF", "RNTC" } )
   ::aReboque    := XmlToHash( XmlNode( XmlNode( ::cXml, "reboque" ), "veicTransp" ), { "placa", "UF", "RNTC" } )
   ::cCobranca   := XmlNode( ::cXml, "cobr" )
   ::aDetPag     := MultipleNodeToArray( XmlNode( ::cXml, "pag" ), "detPag" )
   ::aInfAdic    := XmlToHash( XmlNode( ::cXml, "infAdic" ), { "infAdFisco", "infCpl" } )
   // NF premiada MS
   cText         := XmlNode( ::cXml, "cMsg" )
   IF Alltrim( cText ) == "200"
      ::aInfAdic[ "infAdFisco" ] += " "
      FOR EACH cItem IN hb_ATokens( XmlNode( ::cXml, "xMsg" ), "|" )
         ::aInfAdic[ "infAdFisco" ] += Alltrim( cItem ) + iif( cItem:__EnumIsLast(), "", hb_Eol() )
      NEXT
      ::aInfAdic[ "infAdFisco" ] := Alltrim( ::aInfAdic[ "infAdFisco" ] )
   ENDIF
   ::aObsCont    := XmlToHash( XmlNode( XmlNode( ::cXml, "infAdic" ), "obsCont" ), { "xCampo", "xTexto" } )
   ::aObsFisco   := XmlToHash( XmlNode( XmlNode( ::cXml, "infAdic" ), "obsFisco" ), { "xCampo", "xTexto" } )
   ::aExporta    := XmlToHash( XmlNode( XmlNode( ::cXml, "exporta" ), "infCpl" ), { "UFEmbarq", "xLocEmbarq" } )
   ::aCompra     := XmlToHash( XmlNode( ::cXml, "compra" ), { "xNEmp", "xPed", "xCont" } )
   ::aInfProt    := XmlToHash( ::cXml, { "nProt", "dhRecbto", "digVal", "cStat", "xEvento", "dhRegEvento", "xMotivo" } )
   ::aInfCanc    := XmlToHash( iif( Empty( ::cXmlCancel ), "", ::cXmlCancel ), { "nProt", "dhRecbto", "digVal", "cStat", "xEvento", "dhRegEvento", "xMotivo" } )
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
   aNFRef := MultipleNodeToArray( ::cXml, "refNFe" )
   IF ! Empty( aNFRef )
      cText := "NFe Referenciadas: "
      FOR EACH oElement IN aNFRef
         cText += oElement + iif( oElement:__EnumIsLast(), "", ", " )
      NEXT
      ::aInfAdic[ "infCpl" ] := cText + " " + ::aInfAdic[ "infCpl" ]
   ENDIF

   RETURN .T.

METHOD GeraPDF( cFilePDF, oPDF, lEnd ) CLASS hbNFeDaNFe

   LOCAL oPage

   hb_Default( @lEnd, .T. )
   IF oPdf != Nil
      ::oPdf := oPdf
   ELSE
      ::oPdf := HPDF_New()
      IF ::oPdf == Nil
         ::cRetorno := "Falha da cria��o do objeto PDF"
         RETURN .F.
      ENDIF
      HPDF_SetCompressionMode( ::oPdf, HPDF_COMP_ALL )
   ENDIF
   IF ::cFonteNFe == "Times"
      ::oPDFFontNormal     := HPDF_GetFont( ::oPdf, "Times-Roman", "CP1252" )
      ::oPDFFontBold := HPDF_GetFont( ::oPdf, "Times-Bold", "CP1252" )
   ELSE
      ::oPDFFontNormal     := HPDF_GetFont( ::oPdf, "Courier", "CP1252" )
      ::oPDFFontBold := HPDF_GetFont( ::oPdf, "Courier-Bold", "CP1252" )
   ENDIF

   ::nFolha := 1
   ::NovaPagina()

   // Aten��o: destas duas linhas depende todo layout
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
   IF Len( ::aPageList ) != 0
      FOR EACH oPage IN ::aPageList
         ::oPDFPage := oPage
         ::DrawTexto( ::aPageRow[ 1 ], ::aPageRow[ 2 ], ::aPageRow[ 3 ], NIL, "S�RIE: " + ::aIde[ "serie" ] + ;
            " - FOLHA " + Alltrim( Str( oPage:__EnumIndex() ) ) + "/" + Alltrim( Str( Len( ::aPageList ) ) ), ;
            HPDF_TALIGN_CENTER, ::oPDFFontBold, 9 )
      NEXT
   ENDIF
   IF ! lEnd
      oPdf := ::oPdf
      RETURN oPdf
   ENDIF
   HPDF_SaveToFile( ::oPdf, cFilePDF )
   HPDF_Free( ::oPdf )

   RETURN .T.

METHOD NovaPagina() CLASS hbNFeDaNFe

   ::oPdfPage := HPDF_AddPage( ::oPdf )
   AAdd( ::aPageList, ::oPDFPage )

   HPDF_Page_SetSize( ::oPdfPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT )

   IF ::lLayoutPreview
      ::DrawAviso( "PREVIEW - SEM VALOR FISCAL" )
   ENDIF
   IF ::aIde[ "tpEmis" ] = "5" // Contingencia
      ::DrawContingencia( "", "DANFE EM CONTING�NCIA. IMPRESSO EM", "DECORR�NCIA DE PROBLEMAS T�CNICOS" )
   ENDIF
   IF ::aIde[ "tpEmis" ] == "4" // DEPEC
      ::DrawContingencia( "DANFE IMPRESSO EM CONTING�NCIA - DPEC", "REGULARMENTE RECEBIDO PELA RECEITA", "FEDERAL" )
   ENDIF
   IF ::aIde[ "tpAmb" ] == "2"
      ::DrawHomologacao()
   ELSEIF ! Empty( ::aInfCanc[ "nProt" ] )
      ::DrawAviso( "CANCELADO EM " + ::aInfCanc[ "dhRegEvento" ] + " nProt " + ::aInfCanc[ "nProt" ] )
   ELSEIF ::aInfProt[ "cStat" ] $ "205,302"
      ::DrawAviso( ::aInfProt[ "xMotivo" ] + " " + ::aInfProt[ "dhRecbto" ] + " nProt " + ::aInfProt[ "nProt" ] )
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
   nAlturaQuadroProdutos := ( ::ItensDaFolha() * LAYOUT_FONTSIZE ) + 2
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
   cTexto += " EMISS�O " + Substr( ::aIde[ "dhEmi" ], 9, 2 ) + "/" + Substr( ::aIde[ "dhEmi" ], 6, 2 ) + "/" + Substr( ::aIde[ "dhEmi" ], 1, 4 )
   cTexto += " VALOR TOTAL R$ " + Alltrim( FormatNumber( Val( ::aICMSTotal[ "vNF" ] ), 15, 2 ) )
   cTexto += " DESTINAT�RIO " + ::aDest[ "xNome" ]
   ::DrawTexto( 6, ::nLinhaPdf, 490, NIL, Upper( cTexto ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )

   ::DrawBox( 505, ::nLinhaPdf - 44, 85, 44, ::nLarguraBox )
   ::DrawTexto( 506, ::nLinhaPdf - 8, 589, NIL, "NF-e", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   ::DrawTexto( 506, ::nLinhaPdf - 20, 589, NIL, "N�: " + Transform( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), "@R 999.999.999" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   ::DrawTexto( 506, ::nLinhaPdf - 32, 589, NIL, "S�RIE " + ::aIde[ "serie" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   ::nLinhaPdf -= 18

   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 130, 26, "DATA DE RECEBIMENTO", "", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   ::DrawBoxTituloTexto( 135, ::nLinhaPdf, 370, 26, "IDENTIFICA��O E ASSINATURA DO RECEBEDOR", "", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
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

   LOCAL cTexto, cEmpresaNome

   IF ::lFantasiaCabecalho
      cEmpresaNome := ::aEmit[ "xFant" ]
   ELSE
      cEmpresaNome := ::aEmit[ "xNome" ]
   ENDIF
   ::DrawBox( 5, ::nLinhaPdf - 80, 585, 80, ::nLarguraBox )
   // logo/dados empresa
   ::DrawBox( 5, ::nLinhaPdf - 80, 240, 80, ::nLarguraBox )
   ::DrawTexto( 6, ::nLinhaPdf, 244, NIL, "IDENTIFICA��O DO EMITENTE", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   IF ::cLogoFile == NIL .OR. Empty( ::cLogoFile )
      ::DrawTexto( 6, ::nLinhaPdf - 6,  244, NIL, Trim( MemoLine( cEmpresaNome, 30, 1 ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
      ::DrawTexto( 6, ::nLinhaPdf - 18, 244, NIL, Trim( MemoLine( cEmpresaNome, 30, 2 ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
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
         cTexto := ::FormataMemo( cEmpresaNome, 180 )
         ::DrawTexto( 64, ::nLinhaPdf - 6,  244, NIL,  MemoLine( cTexto, 1000, 1 ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
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
         ::DrawTexto( 6, ::nLinhaPdf - 6, 180, NIL, Trim( MemoLine( cEmpresaNome, 30, 1 ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
         ::DrawTexto( 6, ::nLinhaPdf - 18, 180, NIL, Trim( MemoLine( cEmpresaNome, 30, 2 ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
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
   ::DrawTexto( 246, ::nLinhaPdf - 24, 369, NIL, "Nota Fiscal Eletr�nica", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )

   ::DrawTexto( 256, ::nLinhaPdf - 36, 349, NIL, "0 - ENTRADA", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
   ::DrawTexto( 256, ::nLinhaPdf - 44, 349, NIL, "1 - SA�DA", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
   // preenchimento do tipo de nf
   ::DrawBox( 340, ::nLinhaPdf - 52, 20, 16, ::nLarguraBox )
   ::DrawTexto( 341, ::nLinhaPdf - 40, 359, NIL, ::aIde[ "tpNF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )

   ::DrawTexto( 246, ::nLinhaPdf - 56, 369, NIL, "N�: " + Transform( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), "@R 999.999.999" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )
   ::aPageRow := { 246, ::nLinhaPdf - 66, 369 }
//   ::DrawTexto( 246, ::nLinhaPdf - 66, 369, NIL, "S�RIE: " + ::aIde[ "serie" ] + " - FOLHA " + Alltrim( Str( ::nFolha ) ) + "/" + Alltrim( Str( ::nLayoutTotalFolhas ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 9 )

   // codigo barras
   ::DrawBox( 370, ::nLinhaPdf - 35, 220, 35, ::nLarguraBox )
   ::DrawBarcode128( ::cChave, 385, ::nLinhaPdf - 32, 0.7, 30 )

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
      ::DrawTexto( 371, ::nLinhaPdf - 55, 589, NIL, "N F E   A I N D A   N � O   F O I", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
      ::DrawTexto( 371, ::nLinhaPdf - 63, 589, NIL, "A U T O R I Z A D A   P E L A", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
      ::DrawTexto( 371, ::nLinhaPdf - 71, 589, NIL, "S E F A Z   (SEM VALIDADE FISCAL)", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   ELSE
      ::DrawTexto( 371, ::nLinhaPdf - 55, 589, NIL, "Consulta de autenticidade no portal nacional", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
      ::DrawTexto( 371, ::nLinhaPdf - 63, 589, NIL, "da NF-e www.nfe.fazenda.gov.br/portal ou", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
      ::DrawTexto( 371, ::nLinhaPdf - 71, 589, NIL, "no site da Sefaz Autorizadora", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   ENDIF
   ::nLinhaPdf -= 80
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 365, 16, "NATUREZA DA OPERA��O", ::FormataString( ::aIde[ "natOp" ], 365, 10 ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   // PROTOCOLO
   ::DrawBox( 370, ::nLinhaPdf - 16, 220, 16, ::nLarguraBox )
   // ::DrawTexto(371, ::nLinhaPdf - 1, 589, NIL, "PROTOCOLO DE AUTORIZA��O DE USO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 5 )
   IF ! Empty( ::aInfProt[ "nProt" ] )
      IF ::aInfProt[ "cStat" ] == "100"
         ::DrawTexto( 371, ::nLinhaPdf - 1, 589, NIL, "PROTOCOLO DE AUTORIZA��O DE USO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 5 )
      ENDIF
      IF ::cFonteNFe == "Times"
         ::DrawTexto( 371, ::nLinhaPdf - 6, 589, NIL, ::aInfProt[ "nProt" ] + " " + Substr( ::aInfProt[ "dhRecbto" ], 9, 2 ) + "/" + Substr( ::aInfProt[ "dhRecbto" ], 6, 2 ) + "/" + Substr( ::aInfProt[ "dhRecbto" ], 1, 4 ) + " " + Substr( ::aInfProt[ "dhRecbto" ], 12, 8 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 9 )
      ELSE
         ::DrawTexto( 371, ::nLinhaPdf - 6, 589, NIL, ::aInfProt[ "nProt" ] + " " + Substr( ::aInfProt[ "dhRecbto" ], 9, 2 ) + "/" + Substr( ::aInfProt[ "dhRecbto" ], 6, 2 ) + "/" + Substr( ::aInfProt[ "dhRecbto" ], 1, 4 ) + " " + Substr( ::aInfProt[ "dhRecbto" ], 12, 8 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 9 )
      ENDIF
   ENDIF
   ::nLinhaPdf -= 16
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 240, 16, "INSCRI��O ESTADUAL", ::aEmit[ "IE" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 245, ::nLinhaPdf, 225, 16, "INSCRI��O ESTADUAL DO SUBS. TRIBUT�RIO", ::aEmit[ "IEST" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 470, ::nLinhaPdf, 120, 16, "CNPJ/CPF", FormatCnpj( ::aEmit[ "CNPJ" ] ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::nLinhaPdf -= 17

   RETURN NIL

METHOD QuadroDestinatario() CLASS hbNFeDaNFe

   ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "DESTINAT�RIO/REMETENTE", HPDF_TALIGN_LEFT, ::oPDFFontBold, 5 )
   ::nLinhaPdf -= 6
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 415, 16, "NOME / RAZ�O SOCIAL", ::FormataString( ::aDest[ "xNome" ], 415, 10 ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 420, ::nLinhaPdf, 100, 16, "CNPJ/CPF", FormatCnpj( ::aDest[ "CNPJ" ] ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 9 )
   ::DrawBoxTituloTexto( 520, ::nLinhaPdf, 70, 16, "DATA DE EMISS�O",  ;
      Substr( ::aIde[ "dhEmi" ], 9, 2 ) + "/" + Substr( ::aIde[ "dhEmi" ], 6, 2 ) + "/" + Substr( ::aIde[ "dhEmi" ], 1, 4 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::nLinhaPdf -= 16
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 265, 16, "ENDERE�O", ::aDest[ "xLgr" ] + " " + ::aDest[ "nro" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
   ::DrawBoxTituloTexto( 270, ::nLinhaPdf, 190, 16, "BAIRRO", ::aDest[ "xBairro" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 460, ::nLinhaPdf, 60, 16, "C.E.P.", Transform( ::aDest[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 520, ::nLinhaPdf, 70, 16, "DATA SAIDA/ENTRADA", ;
      Substr( ::aIde[ "dhSaiEnt" ], 9, 2 ) + "/" + Substr( ::aIde[ "dhSaiEnt" ], 6, 2 ) + "/" + Substr( ::aIde[ "dhSaiEnt" ], 1, 4 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::nLinhaPdf -= 16
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 245, 16, "MUNICIPIO", ::aDest[ "xMun" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 250, ::nLinhaPdf, 30, 16, "ESTADO", ::aDest[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 280, ::nLinhaPdf, 150, 16, "FONE/FAX", ::FormataTelefone( ::aDest[ "fone" ] ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 430, ::nLinhaPdf, 90, 16, "INSCRI��O ESTADUAL", ::aDest[ "IE" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 520, ::nLinhaPdf, 70, 16, "HORA DE SAIDA", Substr( ::aIde[ "dhSaiEnt" ], 12, 8 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
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
         cValor      := Alltrim( FormatNumber( Val( XmlNode( cDup, "vDup" ) ), 13, 2 ) )
         IF nColuna > 3
            ::nLinhaPdf -= 8
            nColuna := 1
         ENDIF
         ::DrawTexto( 6 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), ::nLinhaPdf - 1,  70 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), NIL, cNumero, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
         ::DrawTexto( 72 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), ::nLinhaPdf - 1, 128 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), NIL, cVencimento, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
         ::DrawTexto( 130 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), ::nLinhaPdf - 1, 195 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), NIL, cValor, HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 8 )
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
         cValor  := Alltrim( FormatNumber( Val( XmlNode( cTPag, "vPag" ) ), 13, 2 ) )
         IF nColuna > 3
            ::nLinhaPdf -= 8
            nColuna := 1
         ENDIF
         IF ( nPos := hb_AScan( aList, { | e | e[ 1 ] == cNumero } ) ) != 0
            ::DrawTexto( 6 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), ::nLinhaPdf - 1, ;
            122 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), NIL, ;
            iif( cNumero == "99", XmlNode( cTPag, "xPag" ), aList[ nPos, 2 ] ), ;
            HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
         ENDIF
         ::DrawTexto( 130 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), ::nLinhaPdf - 1, 195 + ( ( ( nTamForm ) / 3 ) * ( nColuna - 1 ) ), NIL, cValor, HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 8 )
         nColuna++
      NEXT
      ::nLinhaPdf -= 12
   OTHERWISE
      ::DrawBox( 5, ::nLinhaPdf - 12, 585, 12, ::nLarguraBox )
      IF ! Empty( ::aIde[ "indPag" ] )
         IF ::aIde[ "indPag" ] == "0"
            ::DrawTexto( 6, ::nLinhaPdf - 1,  589, NIL, "PAGAMENTO � VISTA", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
         ELSEIF ::aIde[ "indPag" ] == "1"
            ::DrawTexto( 6, ::nLinhaPdf - 1,  589, NIL, "PAGAMENTO � PRAZO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
         ELSE
            ::DrawTexto( 6, ::nLinhaPdf - 1,  589, NIL, "OUTROS", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
         ENDIF
      ENDIF
      ::nLinhaPdf -= 12
   ENDCASE

   RETURN NIL

METHOD QuadroImposto() CLASS hbNFeDaNFe

   IF ::nFolha == 1
      ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "C�LCULO DO IMPOSTO", HPDF_TALIGN_LEFT, ::oPDFFontBold, 5 )
      ::nLinhaPdf -= 6
      ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 110, 16, "BASE DE C�LCULO DO ICMS", Alltrim( FormatNumber( Val( ::aICMSTotal[ "vBC" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 115, ::nLinhaPdf, 100, 16, "VALOR DO ICMS", Alltrim( FormatNumber( Val( ::aICMSTotal[ "vICMS" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 215, ::nLinhaPdf, 130, 16, "BASE DE C�LCULO DO ICMS SUBS. TRIB.", Alltrim( FormatNumber( Val( ::aICMSTotal[ "vBCST" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 345, ::nLinhaPdf, 100, 16, "VALOR DO ICMS SUBST.", Alltrim( FormatNumber( Val( ::aICMSTotal[ "vST" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 445, ::nLinhaPdf, 145, 16, "VALOR TOTAL DOS PRODUTOS", Alltrim( FormatNumber( Val( ::aICMSTotal[ "vProd" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::nLinhaPdf -= 16
      ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 88, 16, "VALOR DO FRETE", Alltrim( FormatNumber( Val( ::aICMSTotal[ "vFrete" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 93, ::nLinhaPdf, 88, 16, "VALOR DO SEGURO", Alltrim( FormatNumber( Val( ::aICMSTotal[ "vSeg" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 181, ::nLinhaPdf, 88, 16, "DESCONTO", Alltrim( FormatNumber( Val( ::aICMSTotal[ "vDesc" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 269, ::nLinhaPdf, 88, 16, "OUTRAS DESP. ACESS�RIAS", Alltrim( FormatNumber( Val( ::aICMSTotal[ "vOutro" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 357, ::nLinhaPdf, 88, 16, "VALOR DO IPI", Alltrim( FormatNumber( Val( ::aICMSTotal[ "vIPI" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 445, ::nLinhaPdf, 145, 16, "VALOR TOTAL DA NOTA FISCAL", Alltrim( FormatNumber( Val( ::aICMSTotal[ "vNF" ] ), 15, 2 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::nLinhaPdf -= 17
   ENDIF

   RETURN NIL

METHOD QuadroTransporte() CLASS hbNFeDaNFe

   IF ::nFolha == 1
      ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "TRANSPORTADOR / VOLUMES TRANSPORTADOS", HPDF_TALIGN_LEFT, ::oPDFFontBold, 5 )
      ::nLinhaPdf -= 6
      ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 215, 16, "NOME/RAZ�O SOCIAL", ::FormataString( ::aTransp[ "xNome" ], 215, 8 ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
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
      ::DrawBoxTituloTexto( 310, ::nLinhaPdf, 110, 16, "C�DIGO ANTT", ::aVeicTransp[ "RNTC" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ::DrawBoxTituloTexto( 420, ::nLinhaPdf, 60, 16, "PLACA DO VE�CULO", ::aVeicTransp[ "placa" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 480, ::nLinhaPdf, 20, 16, "UF", ::aVeicTransp[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 500, ::nLinhaPdf, 90, 16, "CNPJ/CPF", FormatCnpj( ::aTransp[ "CNPJ" ] ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ::nLinhaPdf -= 16
      ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 265, 16, "ENDERE�O", ::aTransp[ "xEnder" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
      ::DrawBoxTituloTexto( 270, ::nLinhaPdf, 210, 16, "MUNIC�PIO", ::aTransp[ "xMun" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 480, ::nLinhaPdf, 20, 16, "UF", ::aTransp[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 500, ::nLinhaPdf, 90, 16, "INSCRI��O ESTADUAL", ::aTransp[ "IE" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ::nLinhaPdf -= 16
      ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 95, 16, "QUANTIDADE", LTrim( FormatNumber( Val( ::aTransp[ "qVol" ] ), 15, 0 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 8 )
      ::DrawBoxTituloTexto( 100, ::nLinhaPdf, 100, 16, "ESP�CIE", ::aTransp[ "esp" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 200, ::nLinhaPdf, 100, 16, "MARCA", ::aTransp[ "marca" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 300, ::nLinhaPdf, 100, 16, "NUMERA��O", ::aTransp[ "nVol" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 400, ::nLinhaPdf, 100, 16, "PESO BRUTO", LTrim( FormatNumber( Val( ::aTransp[ "pesoB" ] ), 15, 3 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::DrawBoxTituloTexto( 500, ::nLinhaPdf, 90, 16, "PESO L�QUIDO", LTrim( FormatNumber( Val( ::aTransp[ "pesoL" ] ), 15, 3 ) ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
      ::nLinhaPdf -= 17
   ENDIF

   RETURN NIL

METHOD QuadroProdutosTitulo() CLASS hbNFeDaNFe

   LOCAL oElement

   ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "DADOS DOS PRODUTOS / SERVI�OS", HPDF_TALIGN_LEFT, ::oPDFFontBold, 5 )
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

   nLinhaFinalProd := ::nLinhaPdf - ( ::ItensDaFolha() * LAYOUT_FONTSIZE ) - 2
   nAlturaQuadroProdutos := ( ::ItensDaFolha() * LAYOUT_FONTSIZE ) + 2
   ::QuadroProdutosDesenho( nLinhaFinalProd, nAlturaQuadroProdutos )

   nItem := 1
   ::nLinhaFolha := 0
   DO WHILE .T.
      IF ! ::ProcessaItens( ::cXml, nItem )
         EXIT
      ENDIF
      ::aItem[ "xProd" ]     := ::FormataMemo( ::aItem[ "xProd" ],     ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] - 2 )
      ::aItem[ "infAdProd" ] := ::FormataMemo( ::aItem[ "infAdProd" ], ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] - 2 )
      IF ::nLinhaFolha + MLCount( ::aItem[ "xProd" ], 1000 ) + MLCount( ::aItem[ "infAdProd" ], 1000 ) > ::ItensDaFolha()
         ::saltaPagina()
      ENDIF
      ::DrawTextoProduto( LAYOUT_CODIGO,     ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_CENTER )
      ::DrawTextoProduto( LAYOUT_DESCRICAO,  ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_LEFT )
      ::DrawTextoProduto( LAYOUT_NCM,        ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_CENTER )
      ::DrawTextoProduto( LAYOUT_EAN,        ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_CENTER )
      ::DrawTextoProduto( LAYOUT_CST,        ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_CENTER )
      ::DrawTextoProduto( LAYOUT_CFOP,       ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_CENTER )
      ::DrawTextoProduto( LAYOUT_UNIDADE,    ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_CENTER )
      ::DrawTextoProduto( LAYOUT_QTD,        ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_UNITARIO,   ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_TOTAL,      ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_DESCONTO,   ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_ICMBAS,     ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_ICMVAL,     ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_SUBBAS,     ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_SUBVAL,     ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_IPIVAL,     ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_ICMALI,     ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_IPIALI,     ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_UN_TRIB,    ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_QTD_TRIB,   ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::DrawTextoProduto( LAYOUT_VALOR_TRIB, ::nLinhaPdf, LAYOUT_CONTEUDO, HPDF_TALIGN_RIGHT )
      ::nLinhaPdf -= LAYOUT_FONTSIZE
      nItem++
      ::nLinhaFolha++
      FOR nNumLinha = 2 TO MLCount( ::aItem[ "xProd" ], 1000 )
//         IF ::nLinhaFolha > ::ItensDaFolha()
//            ::saltaPagina()
//         ENDIF
         ::DrawTextoProduto( LAYOUT_DESCRICAO, ::nLinhaPdf, MemoLine( ::aItem[ "xProd" ], 1000, nNumLinha ), HPDF_TALIGN_LEFT )
         ::nLinhaFolha++
         ::nLinhaPdf -= LAYOUT_FONTSIZE
      NEXT
      FOR nNumLinha = 1 TO MLCount( ::aItem[ "infAdProd" ], 1000 )
//         IF ::nLinhaFolha > ::ItensDaFolha()
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
      IF ::nLinhaFolha <= ::ItensDaFolha() .AND. ! ::lLayoutEspacoDuplo
         ::DrawLine( 5, ::nLinhaPdf - 0.5, 590, ::nLinhaPdf - 0.5, ::nLarguraBox )
      ENDIF
   ENDDO
   IF MLCount( ::aInfAdic[ "infCpl" ], 1000 ) > Int( 78 / LAYOUT_FONTSIZE )
      ::nLinhaFolha++
      ::nLinhaPdf -= LAYOUT_FONTSIZE
      ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "*CONTINUACAO INFORMA��ES COMPLEMENTARES*", HPDF_TALIGN_LEFT, ::oPDFFontNormal, LAYOUT_FONTSIZE )
      ::nLinhaFolha++
      ::nLinhaPdf -= LAYOUT_FONTSIZE
      FOR nCont = Int( 78 / LAYOUT_FONTSIZE ) + 1 TO MLCount( ::aInfAdic[ "infCpl" ], 1000 )
         IF ::nLinhaFolha > ::ItensDaFolha()
            ::SaltaPagina()
            ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "*CONTINUACAO INFORMA��ES COMPLEMENTARES*", HPDF_TALIGN_LEFT, ::oPDFFontNormal, LAYOUT_FONTSIZE )
            ::nLinhaFolha++
            ::nLinhaPdf -= LAYOUT_FONTSIZE
         ENDIF
         ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, MemoLine( ::aInfAdic[ "infCpl" ], 1000, nCont ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, LAYOUT_FONTSIZE )
         ::nLinhaFolha++
         ::nLinhaPdf -= LAYOUT_FONTSIZE
      NEXT
   ENDIF
   ::nLinhaPdf -= ( ( ::ItensDaFolha() - ::nLinhaFolha + 1 ) * LAYOUT_FONTSIZE )
   ::nLinhaPdf -= 2

   RETURN NIL

METHOD QuadroTotalServico() CLASS hbNFeDaNFe

   IF ::nFolha == 1
      IF Val( ::aISSTotal[ "vServ" ] ) > 0
         ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "CALCULO DO ISSQN", HPDF_TALIGN_LEFT, ::oPDFFontBold, 5 )
         ::nLinhaPdf -= 6
         ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 150, 16, "INSCRI��O MUNICIPAL", ::aEmit[ "IM" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
         ::DrawBoxTituloTexto( 155, ::nLinhaPdf, 145, 16, "VALOR TOTAL DOS SERVI�OS", FormatNumber( Val( ::aISSTotal[ "vServ" ] ), 15 ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
         ::DrawBoxTituloTexto( 300, ::nLinhaPdf, 145, 16, "BASE DE C�LCULO DO ISSQN", FormatNumber( Val( ::aISSTotal[ "vBC" ] ), 15 ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 10 )
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
      ::DrawTexto( 6, ::nLinhaPdf - 1, 399, NIL, "INFORMA��ES COMPLEMENTARES", HPDF_TALIGN_LEFT, ::oPDFFontNormal, LAYOUT_FONTSIZE )

      ::DrawBox( 400, ::nLinhaPdf - 92, 190, 92, ::nLarguraBox )
      ::DrawTexto( 401, ::nLinhaPdf - 1, 589, NIL, "RESERVADO AO FISCO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
      ::nLinhaPdf -= 7    //
      ::nLinhaPdf -= 4 // ESPA�O
      FOR nCont = 1 TO Min( MLCount( cMemo, 1000 ), Int( 78 / LAYOUT_FONTSIZE ) )
         ::DrawTexto( 6, ::nLinhaPDF - ( ( nCont - 1 ) * LAYOUT_FONTSIZE ), 399, NIL, Trim( MemoLine( cMemo, 1000, nCont ) ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, LAYOUT_FONTSIZE )
      NEXT
      cMemo := ::FormataMemo( ::aInfAdic[ "infAdFisco" ], 170 )
      FOR nCont = 1 TO Min( MLCount( cMemo, 1000 ), Int( 78 / LAYOUT_FONTSIZE ) )
         ::DrawTexto( 401, ::nLinhaPDF - ( ( nCont - 1 ) * LAYOUT_FONTSIZE ), 588, NIL, Trim( MemoLine( cMemo, 1000, nCont ) ), HPDF_TALIGN_LEFT, ::oPDFFontBold, LAYOUT_FONTSIZE )
      NEXT
      ::nLinhaPDF -= 78 + 4
   ENDIF

   RETURN NIL

METHOD ProcessaItens( cXml, nItem ) CLASS hbNFeDaNFe

   LOCAL cItem, aItem, cDetalhamentoArma, cDetalhamentoVeiculo, xValue, cTxt

   aItem := MultipleNodeToArray( cXml, "det" )
   IF Len( aItem ) < nItem
      RETURN .F.
   ELSE
      cItem := aItem[ nItem ]

      ::aItem          := XmlToHash( cItem, { "cProd", "cEAN", "xProd", "NCM", "EXTIPI", "CFOP", "uCom", "qCom", "vUnCom", "vProd", "cEANTrib", "uTrib", "qTrib", "vUnTrib", "vFrete", ;
         "vSeg", "vDesc", "vOutro", "indTot", "infAdProd", "cProdANP", "descANP", "nFCI" } )
      ::aItem[ "cEAN" ] := iif( ::aItem[ "cEAN" ] == "SEM GTIN", "", ::aItem[ "cEAN" ] )
      ::aItem[ "cEANTrib" ] := iif( ::aItem[ "cEANTrib" ] == "SEM GTIN", "", ::aItem[ "cEANTrib" ] )
      ::aItemDI        := XmlToHash( XmlNode( cItem, "DI" ), { "nDI", "dDI", "xLocDesemb", "UFDesemb", "cExportador" } )
      ::aItemAdi       := XmlToHash( XmlNode( cItem, "adi" ), { "nAdicao", "nSeqAdic", "cFabricante", "vDescDI", "xPed", "nItemPed" } )
      ::aItemArma      := XmlToHash( XmlNode( cItem, "arma" ), { "tpArma", "nSerie", "nCano", "descr" } )
      ::aItemVeicProd  := XmlToHash( XmlNode( cItem, "veicProd" ), { "tpOp", "chassi", "cCor", "xCor", "pot", "cilin", "pesoL", "pesoB", "nSerie", "tpComb", "nMotor", "CMT", "dist", "anoMod", "anoFab", "tpPint", "tpVeic", "espVeic", "VIN", "condVeic", "cMod", "cCorDENATRAN", "lota", "tpRest" } )

      // todo medicamentos (med), combustiveis (comb)
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
      IF ! Empty( ::aItemArma[ "nSerie" ] )
         cDetalhamentoArma := "TIPO DA ARMA: " + ::aItemArma[ "tpArma" ] + iif( Val( ::aItemArma[ "tpArma" ] ) == 0, "-Uso Permitido", "-Uso Restrito" ) + hb_Eol()
         cDetalhamentoArma += "N� SERIE ARMA: " + ::aItemArma[ "nSerie" ] + hb_Eol()
         cDetalhamentoArma += "N� SERIE CANO: " + ::aItemArma[ "nCano" ] + hb_Eol()
         cDetalhamentoArma += "DESCRICAO ARMA: " + ::aItemArma[ "descr" ] + hb_Eol()
      ELSE
         cDetalhamentoArma := ""
      ENDIF

      IF Empty( ::aItemVeicProd[ "chassi" ] )
         cTxt := ""
      ELSE
         cTxt := "TIPO DE OPERACAO: "     + ::aItemVeicProd[ "tpOp" ]
         cTxt +=    Veiculo_TipoOperacao( Alltrim(::aItemVeicProd[ "tpOp" ] ) )
         cTxt += " CHASSI: "              + Alltrim( ::aItemVeicProd[ "chassi" ] )
         cTxt += " COR: "                 + Alltrim( ::aItemVeicProd[ "cCor" ] )
         cTxt +=    "-" + Alltrim( ::aItemVeicProd[ "xCor" ] )
         cTxt += " POTENCIA: "            + Alltrim( ::aItemVeicProd[ "pot" ] ) + " CV"
         cTxt += " CILINDRADAS: "         + Alltrim( ::aItemVeicProd[ "cilin" ] ) + " CC"
         cTxt += " PESO LIQ: "            + Alltrim( ::aItemVeicProd[ "pesoL" ] )
         cTxt += " PESO BRUTO: "          + Alltrim( ::aItemVeicProd[ "pesoB" ] )
         cTxt += " SERIE: "               + Alltrim( ::aItemVeicProd[ "nSerie" ] )
         cTxt += " COMBUSTIVEL: "         + Alltrim( ::aItemVeicProd[ "tpComb" ] )
         cTxt += " OBS MOTOR: "           + Alltrim( ::aItemVeicProd[ "nMotor" ] )
         cTxt += " CAPACIDADE MAX TRACAO: " + Alltrim( ::aItemVeicProd[ "CMT" ] )
         cTxt += " DIST. ENTRE EIXOS: "   + Alltrim( ::aItemVeicProd[ "dist" ] )
         cTxt += " ANO MODELO: "          + Alltrim( ::aItemVeicProd[ "anoMod" ] )
         cTxt += " ANO FABRICACAO: "      + Alltrim( ::aItemVeicProd[ "anoFab" ] )
         cTxt += " TIPO PINTURA: "        + Alltrim( ::aItemVeicProd[ "tpPint" ] )
         cTxt += " TIPO VEICULO: "        + Alltrim( ::aItemVeicProd[ "tpVeic" ] )
         cTxt += Veiculo_Tipo( Alltrim( ::aItemVeicProd[ "tpVeic" ] ) )
         cTxt += " ESPECIE VEICULO: "     + Alltrim( ::aItemVeicProd[ "espVeic" ] )
         cTxt +=    Veiculo_Especie( Alltrim( ::aItemVeicProd[ "espVeic" ] ) )
         cTxt += " VIN (CHASSI): "        + Alltrim( ::aItemVeicProd[ "VIN" ] )
         xValue := Alltrim( ::aItemVeicProd[ "VIN" ] )
         cTxt += iif( xValue == 'R', "-REMARCADO", iif( xValue == 'N', "-NORMAL", "" ) )
         xValue := Alltrim( ::aItemVeicProd[ "condVeic" ] )
         cTxt += " CONDICAO VEICULO: "    + Alltrim( ::aItemVeicProd[ "condVeic" ] )
         cTxt += iif( xValue == '1', "-ACABADO", iif( xValue == '2', ;
            "-INACABADO", iif( xValue == '3', "-SEMIACABADO", "" ) ) )
         cTxt += " CODIGO MARCA/MODELO: " + Alltrim( ::aItemVeicProd[ "cMod" ] )
         cTxt += " COR DENATRAN: "        + Alltrim( ::aItemVeicProd[ "cCorDENATRAN" ] )
         cTxt +=    Veiculo_Cor( Alltrim(::aItemVeicProd[ "cCorDENATRAN"] ) )
         cTxt += " LOTACAO MAX: "         + Alltrim( ::aItemVeicProd[ "lota" ] )
         cTxt += " RESTRICAO: "           + Alltrim( ::aItemVeicProd[ "tpRest" ] )
         cTxt +=    Veiculo_Restricao( Alltrim(::aItemVeicProd[ "tpRest"] ) ) + hb_Eol()
      ENDIF
      cDetalhamentoVeiculo := cTxt
      ::aItem[ "infAdProd" ] := StrTran( ::aItem[ "infAdProd" ] + cDetalhamentoArma + cDetalhamentoVeiculo, ";", hb_Eol() )
      IF ! Empty( ::aItem[ "descANP" ] )
         ::aItem[ "infAdProd" ] += ;
            iif( Empty( ::aItem[ "infAdProd" ] ), "", hb_Eol() ) + ;
            "C�d.ANP " + ::aItem[ "cProdANP" ] + ;
            " Desc.ANP " + ::aItem[ "descANP" ]
      ENDIF
      IF ! Empty( ::aItem[ "nFCI" ] )
         ::aItem[ "infAdProd" ] += ;
            iif( Empty( ::aItem[ "infAdProd" ] ), "", hb_Eol() ) + ;
            "nFCI " + ::aItem[ "nFCI" ]
      ENDIF

   ENDIF

   RETURN .T.

METHOD CalculaLayout() CLASS hbNFeDaNFe

   /* LOCAL nItem, nQtdLinhas */

   ::DefineColunasQuadroProdutos()
   ::aInfAdic[ "infCpl" ] := ::FormataMemo( ::aInfAdic[ "infCpl" ], 392 )
   /*
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
      IF nQtdLinhas + MLCount( ::aItem[ "xProd" ], 1000 ) + MLCount( ::aItem[ "infAdProd" ], 1000 ) > ::ItensDaFolha( ::nLayoutTotalFolhas )
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
   // Linhas extras pra informa��es adicionais
   IF MLCount( ::ainfAdic[ "infCpl" ], 1000 ) > Int( 78 / LAYOUT_FONTSIZE )
      nQtdLinhas += 2 + MLCount( ::ainfAdic[ "infCpl" ], 1000 ) - Int( 78 / LAYOUT_FONTSIZE )
   ENDIF
   IF nQtdLinhas > ::ItensDaFolha( ::nLayoutTotalFolhas )
      ::nLayoutTotalFolhas += 1
   ENDIF
   */

   RETURN NIL

METHOD ItensDaFolha( nFolha ) CLASS hbNFeDaNFe

   LOCAL nQuadro := 630, nParcelas

   nFolha := iif( nFolha == NIL, ::nFolha, nFolha )

   IF nFolha == 1
      nQuadro := 292 + ;
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

METHOD DefineColunasQuadroProdutos() CLASS hbNFeDaNFe

   LOCAL oElement, nItem, nCont, nColunaFinal, nTentativa

   ::ProcessaItens( ::cXml, 1 ) // precisa de ::aItem pra gerar o codeblock
   ::aLayout[ LAYOUT_CODIGO,     LAYOUT_TITULO1 ]   := "C�DIGO"
   ::aLayout[ LAYOUT_CODIGO,     LAYOUT_CONTEUDO ]  := { || ::aItem[ "cProd" ] }
   ::aLayout[ LAYOUT_DESCRICAO,  LAYOUT_TITULO1 ]   := "DESCRI��O DO PRODUTO / SERVI�O"
   ::aLayout[ LAYOUT_DESCRICAO,  LAYOUT_CONTEUDO ]  := { || MemoLine( ::aItem[ "xProd" ], ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURA ], 1 ) }
   ::aLayout[ LAYOUT_NCM,        LAYOUT_TITULO1 ]   := "NCM/SH"
   ::aLayout[ LAYOUT_NCM,        LAYOUT_CONTEUDO ]  := { || ::aItem[ "NCM" ] }
   ::aLayout[ LAYOUT_EAN,        LAYOUT_TITULO1 ]   := "EAN"
   ::aLayout[ LAYOUT_EAN,        LAYOUT_CONTEUDO ]  := { || ::aItem[ "cEAN" ] }
   ::aLayout[ LAYOUT_CST,        LAYOUT_TITULO1 ]   := "CST"
   ::aLayout[ LAYOUT_CST,        LAYOUT_TITULO2 ]   := "CSOSN"
   ::aLayout[ LAYOUT_CST,        LAYOUT_CONTEUDO ]  := { || ::aItemICMS[ "orig" ] + ::aItemICMS[ "CSOSN" ] + ::aItemICMS[ "CST" ] }
   ::aLayout[ LAYOUT_CFOP,       LAYOUT_TITULO1 ]   := "CFOP"
   ::aLayout[ LAYOUT_CFOP,       LAYOUT_CONTEUDO ]  := { || ::aItem[ "CFOP" ] }
   ::aLayout[ LAYOUT_UNIDADE,    LAYOUT_TITULO1 ]   := "UN"
   ::aLayout[ LAYOUT_UNIDADE,    LAYOUT_CONTEUDO ]  := { || ::aItem[ "uCom" ] }
   ::aLayout[ LAYOUT_QTD,        LAYOUT_TITULO1 ]   := "QTD"
   ::aLayout[ LAYOUT_QTD,        LAYOUT_CONTEUDO ]  := { || Alltrim( FormatNumber( Val( ::aItem[ "qCom" ] ), 15, ::aLayout[ LAYOUT_QTD, LAYOUT_DECIMAIS ] ) ) }
   ::aLayout[ LAYOUT_UNITARIO,   LAYOUT_TITULO1 ]   := "VALOR"
   ::aLayout[ LAYOUT_UNITARIO,   LAYOUT_TITULO2 ]   := "UNIT�RIO"
   ::aLayout[ LAYOUT_UNITARIO,   LAYOUT_CONTEUDO ]  := { || Alltrim( FormatNumber( Val( ::aItem[ "vUnCom" ] ), 15, ::aLayout[ LAYOUT_UNITARIO, LAYOUT_DECIMAIS ] ) ) }
   ::aLayout[ LAYOUT_TOTAL,      LAYOUT_TITULO1 ]   := "VALOR"
   ::aLayout[ LAYOUT_TOTAL,      LAYOUT_TITULO2 ]   := "TOTAL"
   ::aLayout[ LAYOUT_TOTAL,      LAYOUT_CONTEUDO ]  := { || Alltrim( FormatNumber( Val( ::aItem[ "vProd" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_DESCONTO,   LAYOUT_TITULO1 ]   := "VALOR"
   ::aLayout[ LAYOUT_DESCONTO,   LAYOUT_TITULO2 ]   := "DESCTO"
   ::aLayout[ LAYOUT_DESCONTO,   LAYOUT_CONTEUDO ]  := { || Alltrim( FormatNumber( Val( ::aItem[ "vDesc" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_ICMBAS,     LAYOUT_TITULO1 ]   := "B.C�LC."
   ::aLayout[ LAYOUT_ICMBAS,     LAYOUT_TITULO2 ]   := "ICMS"
   ::aLayout[ LAYOUT_ICMBAS,     LAYOUT_CONTEUDO ]  := { || Alltrim( FormatNumber( Val( ::aItemICMS[ "vBC" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_ICMVAL,     LAYOUT_TITULO1 ]   := "VALOR"
   ::aLayout[ LAYOUT_ICMVAL,     LAYOUT_TITULO2 ]   := "ICMS"
   ::aLayout[ LAYOUT_ICMVAL,     LAYOUT_CONTEUDO ]  := { || Alltrim( FormatNumber( Val( ::aItemICMS[ "vICMS" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_SUBBAS,     LAYOUT_TITULO1 ]   := "B.C�LC."
   ::aLayout[ LAYOUT_SUBBAS,     LAYOUT_TITULO2 ]   := "ICMS ST"
   ::aLayout[ LAYOUT_SUBBAS,     LAYOUT_CONTEUDO ]  := { || Alltrim( FormatNumber( Val( ::aItemICMS[ "vBCST" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_SUBVAL,     LAYOUT_TITULO1 ]   := "VALOR"
   ::aLayout[ LAYOUT_SUBVAL,     LAYOUT_TITULO2 ]   := "ICMS ST"
   ::aLayout[ LAYOUT_SUBVAL,     LAYOUT_CONTEUDO ]  := { || Alltrim( FormatNumber( Val( ::aItemICMS[ "vICMSST" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_IPIVAL,     LAYOUT_TITULO1 ]   := "VALOR"
   ::aLayout[ LAYOUT_IPIVAL,     LAYOUT_TITULO2 ]   := "IPI"
   ::aLayout[ LAYOUT_IPIVAL,     LAYOUT_CONTEUDO ]  := { || Alltrim( FormatNumber( Val( ::aItemIPI[ "vIPI" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_ICMALI,     LAYOUT_TITULO1 ]   := "AL�Q"
   ::aLayout[ LAYOUT_ICMALI,     LAYOUT_TITULO2 ]   := "ICMS"
   ::aLayout[ LAYOUT_ICMALI,     LAYOUT_CONTEUDO ]  := { || Alltrim( FormatNumber( Val( ::aItemICMS[ "pICMS" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_IPIALI,     LAYOUT_TITULO1 ]   := "AL�Q"
   ::aLayout[ LAYOUT_IPIALI,     LAYOUT_TITULO2 ]   := "IPI"
   ::aLayout[ LAYOUT_IPIALI,     LAYOUT_CONTEUDO ]  := { || Alltrim( FormatNumber( Val( ::aItemIPI[ "pIPI" ] ), 15, 2 ) ) }
   ::aLayout[ LAYOUT_UN_TRIB,    LAYOUT_TITULO1 ]   := "UN"
   ::aLayout[ LAYOUT_UN_TRIB,    LAYOUT_TITULO2 ]   := "TRIB"
   ::aLayout[ LAYOUT_UN_TRIB,    LAYOUT_CONTEUDO ]  := { || ::aItem[ "uTrib" ] }
   ::aLayout[ LAYOUT_QTD_TRIB,   LAYOUT_TITULO1 ]   := "QTD"
   ::aLayout[ LAYOUT_QTD_TRIB,   LAYOUT_TITULO2 ]   := "TRIB"
   ::aLayout[ LAYOUT_QTD_TRIB,   LAYOUT_CONTEUDO ]  := { || Alltrim( FormatNumber( Val( ::aItem[ "qTrib" ] ), 15, ::aLayout[ LAYOUT_QTD_TRIB, LAYOUT_DECIMAIS ] ) ) }
   ::aLayout[ LAYOUT_VALOR_TRIB, LAYOUT_TITULO1 ]   := "VALOR"
   ::aLayout[ LAYOUT_VALOR_TRIB, LAYOUT_TITULO2 ]   := "TRIB"
   ::aLayout[ LAYOUT_VALOR_TRIB, LAYOUT_CONTEUDO ]  := { || Alltrim( FormatNumber( Val( ::aItem[ "vUnTrib" ] ), 15, ::aLayout[ LAYOUT_VALOR_TRIB, LAYOUT_DECIMAIS ] ) ) }

   // Define decimais default, mas ser� ajustado conforme conte�do do XML
   ::aLayout[ LAYOUT_QTD,        LAYOUT_DECIMAIS ] := 0
   ::aLayout[ LAYOUT_UNITARIO,   LAYOUT_DECIMAIS ] := 2
   ::aLayout[ LAYOUT_QTD_TRIB,   LAYOUT_DECIMAIS ] := 0
   ::aLayout[ LAYOUT_VALOR_TRIB, LAYOUT_DECIMAIS ] := 2
   FOR EACH oElement IN ::aLayout
      oElement[ LAYOUT_LARGURA ] := Max( Len( oElement[ LAYOUT_TITULO1 ] ), Len( oElement[ LAYOUT_TITULO2 ] ) )
   NEXT
   nItem := 1
   DO WHILE .T.
      IF ! ::ProcessaItens( ::cXml, nItem )
         EXIT
      ENDIF
      ::aLayout[ LAYOUT_QTD,      LAYOUT_DECIMAIS ] := ::DefineDecimais( ::aItem[ "qCom" ],   ::aLayout[ LAYOUT_QTD,      LAYOUT_DECIMAIS ] )
      ::aLayout[ LAYOUT_UNITARIO, LAYOUT_DECIMAIS ] := ::DefineDecimais( ::aItem[ "vUnCom" ], ::aLayout[ LAYOUT_UNITARIO, LAYOUT_DECIMAIS ] )
      ::aLayout[ LAYOUT_QTD_TRIB, LAYOUT_DECIMAIS ] := ::DefineDecimais( ::aItem[ "qTrib" ],  ::aLayout[ LAYOUT_QTD_TRIB, LAYOUT_DECIMAIS ] )
      FOR EACH oElement IN ::aLayout
         oElement[ LAYOUT_LARGURA ] := Max( oElement[ LAYOUT_LARGURA ], Len( Eval( oElement[ LAYOUT_CONTEUDO ] ) ) )
      NEXT
      IF Val( ::aItemIPI[ "pIPI" ]  ) > 0 .OR. Val( ::aItemIPI[ "vIPI" ] ) > 0
         AtivaImprime( @::aLayout[ LAYOUT_IPIVAL, LAYOUT_IMPRIME ] )
         AtivaImprime( @::aLayout[ LAYOUT_IPIALI, LAYOUT_IMPRIME ] )
      ENDIF
      IF Val( ::aItemICMS[ "vBCST" ] ) > 0 .OR. Val( ::aItemICMS[ "vICMSST" ] ) > 0
         AtivaImprime( @::aLayout[ LAYOUT_SUBBAS, LAYOUT_IMPRIME ] )
         AtivaImprime( @::aLayout[ LAYOUT_SUBVAL, LAYOUT_IMPRIME ] )
      ENDIF
      IF Val( ::aItem[ "vDesc" ] ) > 0
         AtivaImprime( @::aLayout[ LAYOUT_DESCONTO, LAYOUT_IMPRIME ] )
      ENDIF
      IF ! Empty( ::aItem[ "cEAN" ] )
         AtivaImprime( @::aLayout[ LAYOUT_EAN, LAYOUT_IMPRIME ] )
      ENDIF
      IF ! Alltrim( ::aItem[ "uCom" ] ) == Alltrim( ::aItem[ "uTrib" ] )
         AtivaImprime( @::aLayout[ LAYOUT_UN_TRIB, LAYOUT_IMPRIME ] )
      ENDIF
      IF ! Alltrim( ::aItem[ "qCom" ] ) == Alltrim( ::aItem[ "qTrib" ] )
         AtivaImprime( @::aLayout[ LAYOUT_QTD_TRIB, LAYOUT_IMPRIME ] )
      ENDIF
      IF ! Alltrim( ::aItem[ "vUnCom" ] ) == Alltrim( ::aItem[ "vUnTrib" ] )
         AtivaImprime( @::aLayout[ LAYOUT_VALOR_TRIB, LAYOUT_IMPRIME ] )
      ENDIF
      nItem += 1
   ENDDO

   // De novo, porque larguraPDF s� d� certo depois de definir decimais
   nItem := 1
   DO WHILE .T.
      IF ! ::ProcessaItens( ::cXml, nItem )
         EXIT
      ENDIF
      FOR EACH oElement IN ::aLayout
         oElement[ LAYOUT_LARGURAPDF ] := Max( oElement[ LAYOUT_LARGURAPDF ], ::LarguraTexto( Eval( oElement[ LAYOUT_CONTEUDO ] ) ) )
      NEXT
      nItem += 1
   ENDDO

   // Define tamanho de colunas
   FOR EACH oElement IN ::aLayout
      IF oElement[ LAYOUT_IMPRIME ] == LAYOUT_IMPRIMEXMLTEM
         oElement[ LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME  // n�o tem no XML, ent�o n�o sai
      ENDIF
      oElement[ LAYOUT_LARGURA ] += 1
      oElement[ LAYOUT_LARGURAPDF ] := Max( oElement[ LAYOUT_LARGURAPDF ], ::LarguraTexto( oElement[ LAYOUT_TITULO1 ] ) )
      oElement[ LAYOUT_LARGURAPDF ] := Max( oElement[ LAYOUT_LARGURAPDF ], ::LarguraTexto( oElement[ LAYOUT_TITULO2 ] ) )
      oElement[ LAYOUT_LARGURAPDF ] += 4
   NEXT

   FOR nTentativa = 1 TO 6
      // Desativa colunas n�o impressas - talvez linha 2
      AEval( ::aLayout, { | oElement | oElement[ LAYOUT_LARGURAPDF ] := iif( oElement[ LAYOUT_IMPRIME ] == LAYOUT_IMPRIMENORMAL, oElement[ LAYOUT_LARGURAPDF ], 0 ) } )
      // Calcula posi��o das colunas
      nColunaFinal := 592
      ::aLayout[ LAYOUT_TOTCOLUNAS, LAYOUT_COLUNAPDF ] := nColunaFinal - ::aLayout[ LAYOUT_TOTCOLUNAS,   LAYOUT_LARGURAPDF ]
      FOR nCont = LAYOUT_TOTCOLUNAS - 1 TO 3 STEP -1
         ::aLayout[ nCont, LAYOUT_COLUNAPDF ] := ::aLayout[ nCont + 1, LAYOUT_COLUNAPDF ] - ::aLayout[ nCont, LAYOUT_LARGURAPDF ]
      NEXT
      ::aLayout[ LAYOUT_CODIGO,    LAYOUT_COLUNAPDF ]  := 6
      ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_COLUNAPDF ]  := ::aLayout[ LAYOUT_CODIGO, LAYOUT_COLUNAPDF ] + ::aLayout[ LAYOUT_CODIGO, LAYOUT_LARGURAPDF ]

      // Define largura da descri��o conforme espa�o que sobra
      ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] := ::aLayout[ LAYOUT_NCM, LAYOUT_COLUNAPDF ] - ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_COLUNAPDF ]
      ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURA ]    := 100 // tanto faz

      // MsgExclamation( "Largura descri��o " + Str( ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] ) )
      IF ::aLayout[ LAYOUT_DESCRICAO, LAYOUT_LARGURAPDF ] > 150
         EXIT
      ENDIF
      // Se n�o sobrar espa�o suficiente pra descri��o, desativa colunas
      DO CASE
      CASE nTentativa == 1 ; ::aLayout[ LAYOUT_EAN, LAYOUT_IMPRIME ]      := LAYOUT_NAOIMPRIME
      CASE nTentativa == 2 ; ::aLayout[ LAYOUT_SUBBAS, LAYOUT_IMPRIME ]   := LAYOUT_NAOIMPRIME
      CASE nTentativa == 3 ; ::aLayout[ LAYOUT_DESCONTO, LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
      CASE nTentativa == 4 ; ::aLayout[ LAYOUT_SUBVAL, LAYOUT_IMPRIME ]   := LAYOUT_NAOIMPRIME
      CASE nTentativa == 5
         ::aLayout[ LAYOUT_UN_TRIB, LAYOUT_IMPRIME ]    := LAYOUT_NAOIMPRIME
         ::aLayout[ LAYOUT_QTD_TRIB, LAYOUT_IMPRIME ]   := LAYOUT_NAOIMPRIME
         ::aLayout[ LAYOUT_VALOR_TRIB, LAYOUT_IMPRIME ] := LAYOUT_NAOIMPRIME
      ENDCASE
   NEXT

// Pode juntar na mesma coluna:
// C�digo do produto/NCM
// CST e CFOP
// Qtde. e unidade
// valor unit�rio e desconto
// valor total e base icms
// base icms e base st
// icms e ipi
// aliquota icms e ipi

   RETURN NIL

METHOD QuadroLocalRetirada() CLASS hbNFeDaNFe

   ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "INFORMA��ES DO LOCAL DE RETIRADA", HPDF_TALIGN_LEFT, ::oPDFFontBold, 5 )
   ::nLinhaPdf -= 6
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 485, 16, "NOME / RAZ�O SOCIAL", ::aRetirada[ "xNome" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 490, ::nLinhaPdf, 100, 16, "CNPJ/CPF", FormatCnpj( ::aRetirada[ "CNPJ" ] ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 9 )
   ::nLinhaPdf -= 16
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 335, 16, "ENDERE�O", ::aRetirada[ "xLgr" ] + " " + ::aRetirada[ "nro" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
   ::DrawBoxTituloTexto( 340, ::nLinhaPdf, 190, 16, "BAIRRO", ::aRetirada[ "xBairro" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 530, ::nLinhaPdf, 60, 16, "C.E.P.", Transform( ::aRetirada[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::nLinhaPdf -= 16
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 315, 16, "MUNICIPIO", ::aRetirada[ "xMun" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 320, ::nLinhaPdf, 30, 16, "ESTADO", ::aRetirada[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 350, ::nLinhaPdf, 150, 16, "FONE/FAX", ::FormataTelefone( ::aRetirada[ "fone" ] ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 500, ::nLinhaPdf, 90, 16, "INSCRI��O ESTADUAL", ::aRetirada[ "IE" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::nLinhaPdf -= 17

   RETURN NIL

METHOD QuadroLocalEntrega() CLASS hbNFeDaNFe

   ::DrawTexto( 5, ::nLinhaPdf, 589, NIL, "INFORMA��ES DO LOCAL DE ENTREGA", HPDF_TALIGN_LEFT, ::oPDFFontBold, 5 )
   ::nLinhaPdf -= 6
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 485, 16, "NOME / RAZ�O SOCIAL", ::aEntrega[ "xNome" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 490, ::nLinhaPdf, 100, 16, "CNPJ/CPF", FormatCnpj( ::aEntrega[ "CNPJ" ] ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 9 )
   ::nLinhaPdf -= 16
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 335, 16, "ENDERE�O", ::aEntrega[ "xLgr" ] + " " + ::aEntrega[ "nro" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 8 )
   ::DrawBoxTituloTexto( 340, ::nLinhaPdf, 190, 16, "BAIRRO", ::aEntrega[ "xBairro" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 530, ::nLinhaPdf, 60, 16, "C.E.P.", Transform( ::aEntrega[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::nLinhaPdf -= 16
   ::DrawBoxTituloTexto( 5, ::nLinhaPdf, 315, 16, "MUNICIPIO", ::aEntrega[ "xMun" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 320, ::nLinhaPdf, 30, 16, "ESTADO", ::aEntrega[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 350, ::nLinhaPdf, 150, 16, "FONE/FAX", ::FormataTelefone( ::aEntrega[ "fone" ] ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::DrawBoxTituloTexto( 500, ::nLinhaPdf, 90, 16, "INSCRI��O ESTADUAL", ::aEntrega[ "IE" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 10 )
   ::nLinhaPdf -= 17

   RETURN NIL

STATIC FUNCTION AtivaImprime( nImprime )

   IF nImprime == LAYOUT_IMPRIMEXMLTEM
      nImprime := LAYOUT_IMPRIMENORMAL
   ELSEIF nImprime == LAYOUT_IMPRIME2XMLTEM
      nImprime := LAYOUT_IMPRIMESEGUNDA
   ENDIF

   RETURN Nil

STATIC FUNCTION Veiculo_Restricao( xValue )

LOCAL cTxt := ''

   DO CASE
   CASE xValue == '0' ; cTxt := '-NAO HA'
   CASE xValue == '1' ; cTxt := '-ALIENACAO FIDUCIARIA'
   CASE xValue == '2' ; cTxt := '-ARRENDAMENTO MERCANTIL'
   CASE xValue == '3' ; cTxt := '-RESERVA DE DOMINIO'
   CASE xValue == '4' ; cTxt := '-PENHOR DE VEICULOS'
   CASE xValue == '9' ; cTxt := '-OUTRAS'
   ENDCASE

   RETURN cTxt

STATIC FUNCTION Veiculo_TipoOperacao( xValue )

   LOCAL cTxt := ''

   DO CASE
   CASE xValue == '0' ; cTxt := '-OUTROS'
   CASE xValue == '1' ; cTxt := '-VENDA CONCESSIONARIA'
   CASE xValue == '2' ; cTxt := '-FATURAMENTO DIRETO PARA CONSUMIDOR FINAL'
   CASE xValue == '3' ; cTxt := '-VENDA DIRETA PARA GRANDES CONSUMIDORES'
   ENDCASE

   RETURN cTxt

STATIC FUNCTION Veiculo_Tipo( xValue )

   LOCAL cTxt := ''

   DO CASE
   CASE xValue == '02' ; cTxt := '-CICLOMOTOR'
   CASE xValue == '03' ; cTxt := '-MOTONETA'
   CASE xValue == '04' ; cTxt := '-MOTOCICLETA'
   CASE xValue == '05' ; cTxt := '-TRICICLO'
   CASE xValue == '06' ; cTxt := '-AUTOMOVEL'
   CASE xValue == '07' ; cTxt := '-MICRO ONIBUS'
   CASE xValue == '08' ; cTxt := '-ONIBUS'
   CASE xValue == '10' ; cTxt := '-REBOQUE'
   CASE xValue == '11' ; cTxt := '-SEMIRREBOQUE'
   CASE xValue == '13' ; cTxt := '-CAMINHONETA'
   CASE xValue == '14' ; cTxt := '-CAMINHAO'
   CASE xValue == '17' ; cTxt := '-C.TRATOR'
   CASE xValue == '18' ; cTxt := '-TR.RODAS'
   CASE xValue == '19' ; cTxt := '-TR.ESTEIRAS'
   CASE xValue == '20' ; cTxt := '-TR.MISTO'
   CASE xValue == '21' ; cTxt := '-QUADRICICLO'
   CASE xValue == '22' ; cTxt := '-CHASSIS-PLATAFORMA'
   CASE xValue == '23' ; cTxt := '-CAMINHONETE'
   CASE xValue == '25' ; cTxt := '-UTILITARIO'
   CASE xValue == '26' ; cTxt := '-MOTORCASA'
   ENDCASE

   RETURN cTxt

STATIC FUNCTION Veiculo_Especie( xValue )

   LOCAL cTxt := ''

   DO CASE
   CASE xValue == '1' ; cTxt := '-PASSAGEIRO'
   CASE xValue == '2' ; cTxt := '-CARGA'
   CASE xValue == '3' ; cTxt := '-MISTO'
   CASE xValue == '4' ; cTxt := '-CORRIDA'
   CASE xValue == '5' ; cTxt := '-TRACAO'
   CASE xValue == '6' ; cTxt := '-ESPECIAL'
   ENDCASE

   RETURN cTxt

STATIC FUNCTION Veiculo_Cor( xValue )

   LOCAL cTxt := ''

   DO CASE
   CASE xValue == '01' ; cTxt := '-AMARELO'
   CASE xValue == '02' ; cTxt := '-AZUL'
   CASE xValue == '03' ; cTxt := '-BEGE'
   CASE xValue == '04' ; cTxt := '-BRANCA'
   CASE xValue == '05' ; cTxt := '-CINZA'
   CASE xValue == '06' ; cTxt := '-DOURADA'
   CASE xValue == '07' ; cTxt := '-GRENA'
   CASE xValue == '08' ; cTxt := '-LARANJA'
   CASE xValue == '09' ; cTxt := '-MARROM'
   CASE xValue == '10' ; cTxt := '-PRATA'
   CASE xValue == '11' ; cTxt := '-PRETA'
   CASE xValue == '12' ; cTxt := '-ROSA'
   CASE xValue == '13' ; cTxt := '-ROXA'
   CASE xValue == '14' ; cTxt := '-VERDE'
   CASE xValue == '15' ; cTxt := '-VERMELHA'
   CASE xValue == '16' ; cTxt := '-FANTASIA'
   ENDCASE

   RETURN cTxt
