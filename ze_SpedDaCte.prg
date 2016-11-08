/*
ZE_SPEDDACTE - Documento Auxiliar de Conhecimento Eletrônico
Fontes originais do projeto hbnfe em https://github.com/fernandoathayde/hbnfe
*/

#include "common.ch"
#include "hbclass.ch"
#include "harupdf.ch"
#ifndef __XHARBOUR__
#include "hbwin.ch"
#include "hbzebra.ch"
#endif

CREATE CLASS hbnfeDacte

   METHOD Execute( cXml, cFilePDF, cXmlCancel )
   METHOD BuscaDadosXML()
   METHOD GeraPDF( cFilePDF )
   METHOD NovaPagina()
   METHOD Cabecalho()

   VAR nLarguraDescricao
   VAR nLarguraCodigo
   VAR cTelefoneEmitente INIT ""
   VAR cSiteEmitente     INIT ""
   VAR cEmailEmitente    INIT ""
   VAR cDesenvolvedor    INIT ""
   VAR cXML
   VAR cXmlCancel        INIT ""
   VAR cChave
   VAR aIde
   VAR aCompl
   VAR aObsCont
   VAR aEmit
   VAR aRem
   VAR ainfNF
   VAR ainfNFe
   VAR ainfOutros
   VAR aDest
   VAR aLocEnt
   VAR aPrest
   VAR aComp
   VAR aIcms00
   VAR aIcms20
   VAR aIcms45
   VAR aIcms60
   VAR aIcms90
   VAR aIcmsUF
   VAR aIcmsSN
   VAR vTotTrib
   VAR cAdfisco
   VAR aInfCarga
   VAR aInfQ
   VAR aSeg
   VAR aRodo
   VAR aMoto
   VAR aProp
   VAR aValePed
   VAR aVeiculo
   VAR aInfProt
   VAR aExped
   VAR aReceb
   VAR aToma

   VAR aICMSTotal
   VAR aISSTotal
   VAR aRetTrib
   VAR aTransp
   VAR aVeicTransp
   VAR aReboque
   VAR cCobranca
   VAR aInfAdic
   VAR aObsFisco
   VAR aExporta
   VAR aCompra
   VAR aInfCanc

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

   VAR cFonteNFe      INIT "Times"
   VAR cFonteCode128            // Inserido por Anderson Camilo em 04/04/2012
   VAR cFonteCode128F           // Inserido por Anderson Camilo em 04/04/2012
   VAR oPdf
   VAR oPdfPage
   VAR oPdfFontCabecalho
   VAR oPdfFontCabecalhoBold
   VAR nLinhaPDF
   VAR nLarguraBox INIT 0.5
   VAR lLaser INIT .T.
   VAR lPaisagem
   VAR cLogoFile
   VAR nLogoStyle // 1-esquerda, 2-direita, 3-expandido

   VAR nItensFolha
   VAR nLinhaFolha
   VAR nFolhas
   VAR nFolha

   VAR lValorDesc INIT .F.
   VAR nCasasQtd INIT 2
   VAR nCasasVUn INIT 2
   VAR cRetorno

   ENDCLASS

METHOD Execute( cXml, cFilePDF, cXmlCancel ) CLASS hbnfeDaCte

   IF cXml == NIL
      ::cRetorno := "Não informado texto do XML"
      RETURN ::cRetorno
   ENDIF
   ::cXmlCancel := iif( cXmlCancel == NIL, "", cXmlCancel )

   ::cXML   := cXml
   ::cChave := SubStr( ::cXML, At( 'Id=', ::cXML ) + 3 + 4, 44 )

   IF !::buscaDadosXML()
      RETURN ::cRetorno
   ENDIF

   ::lPaisagem          := .F.
   ::nLarguraDescricao  := 39
   ::nLarguraCodigo     := 13

   IF ! ::GeraPdf( cFilePDF )
      ::cRetorno := "Problema ao gerar o PDF !"
      RETURN ::cRetorno
   ENDIF

   ::cRetorno := "OK"

   RETURN ::cRetorno

METHOD BuscaDadosXML() CLASS hbnfeDaCte

   LOCAL cIde, cCompl, cEmit, cinfNF, cinfNFe, cinfOutros, cDest, cPrest, cComp, cImp, cText, oElement
   LOCAL cinfCTeNorm, cInfCarga, cRodo, cVeiculo, cExped
   LOCAL cReceb, cInfQ

   cIde := XmlNode( ::cXml, "ide" )
   ::aIde := XmlToHash( cIde, { "cUF", "cCT", "CFOP", "natOp", "forPag", "mod", "serie", "nCT", "dhEmi", "tpImp", "tpEmis", ;
             "cDV", "tpAmb", "tpCTe", "procEmi", "verProc", "cMunEnv", "xMunEnv", "UFEnv", "modal", "tpServ", "cMunIni", ;
             "xMunIni", "UFIni", "cMunFim", "xMunFim", "UFFim", "retira", "xDetRetira" } )
   cIde := XmlNode( cIde, "toma03" )
   ::aIde[ "toma" ] := XmlNode( cIde, "toma" )

   cCompl := XmlNode( ::cXml, "compl" )
   ::aCompl := hb_Hash()
   ::aCompl[ "xObs" ] := XmlNode( cCompl, "xObs" )
   ::aObsCont := hb_Hash()
   ::aObsCont[ "xTexto" ] := XmlNode( cCompl, "xTexto" )

   cEmit := XmlNode( ::cXml, "emit" )
   ::aEmit := XmlToHash( cEmit, { "CNPJ", "IE", "xNome", "xFant", "fone" } )
   ::aEmit[ "xNome" ] := XmlToSTring( ::aEmit[ "xNome" ] )
   ::cTelefoneEmitente  := SoNumeros( ::aEmit[ "fone" ] )
   IF ! Empty( ::cTelefoneEmitente )
      ::cTelefoneEmitente := Transform( ::cTelefoneEmitente, "@E (99) 9999-9999" )
   ENDIF
   cEmit := XmlNode( cEmit, "enderEmit" )
   FOR EACH oElement IN { "xLgr", "nro", "xCpl", "xBairro", "cMun", "xMun", "CEP", "UF" }
      ::aEmit[ oElement ] := XmlNode( cEmit, oElement )
   NEXT

   ::aRem            := XmlToHash( XmlNode( ::cXml, "rem" ), { "CNPJ", "CPF", "IE", "xNome", "xFant", "fone", "xLgr", "nro", "xCpl", "xBairro", "cMun", "xMun", "CEP", "UF", "cPais", "xPais" } )
   ::aRem[ "xNome" ] := XmlToString( ::aRem[ "xNome" ] )

   cText := XmlNode( ::cXml, "infDoc" )
   ::ainfNF := {}
   DO WHILE "<infNF" $ cText .AND. "</infNF" $ cText
      cinfNF := XmlNode( cText, "infNF" )
      cText  := SubStr( cText, At( "</infNF", cText ) + 8 )
      AAdd( ::ainfNF, { ;
         XmlNode( cInfNf, "nRoma" ), ;
         XmlNode( cInfNf, "nPed" ), ;
         XmlNode( cInfNf, "mod" ), ;
         XmlNode( cInfNf, "serie" ), ;
         XmlNode( cInfNf, "nDoc" ), ;
         XmlNode( cInfNf, "dEmi" ), ;
         XmlNode( cInfNf, "vBC" ), ;
         XmlNode( cInfNf, "vICMS" ), ;
         XmlNode( cInfNf, "vBCST" ), ;
         XmlNode( cInfNf, "vST" ), ;
         XmlNOde( cInfNf, "vProd" ), ;
         XmlNode( cInfNf, "vNF" ), ;
         XmlNode( cInfNf, "nCFOP" ), ;
         XmlNode( cInfNf, "nPeso" ), ;
         XmlNode( cInfNf, "PIN" ) } )
   ENDDO

   ::ainfNFe := {}
   cText := XmlNode( ::cXml, "infDoc" ) // versao 2.0
   DO WHILE "<infNFe" $ cText .AND. "</infNFe" $ cText
      cinfNFe := XmlNode( cText, "infNFe" )
      cText   := SubStr( cText, At( "</infNFe", cText ) + 9 )
      AAdd( ::ainfNFe, { ;
         XmlNode( cInfNFE, "chave" ), + ;
         XmlNode( cInfNFE, "PIN" ) } )
   ENDDO

   ::ainfOutros := {}
   cText := XmlNode( ::cXml, "infDoc" ) // versao 2.0
   DO WHILE "<infOutros" $ cText .AND. "</infOutros" $ cText
      cinfOutros := XmlNode( cText, "infOutros" )
      cText      := SubStr( cText, At( "</infOutros", cText ) + 12 )
      AAdd( ::ainfOutros, { ;
         XmlNode( cInfOutros, "tpDoc" ), ;
         XmlNode( cInfOutros, "descOutros" ), ;
         XmlNode( cInfOutros, "nDoc" ), ;
         XmlNode( cInfOutros, "dEmi" ), ;
         XmlNode( cInfOutros, "vDocFisc" ) } )
   ENDDO

   cDest := XmlNode( ::cXml, "dest" )
   ::aDest := XmlToHash( cDest, { "CNPJ", "CPF", "IE", "xNome", "fone", "ISUF", "email" } )
   ::aDest[ "xNome" ] := XmlToString( ::aDest[ "xNome" ] )
   ::aDest[ "email" ] := XmlToString( ::aDest[ "email" ] )

   cDest := XmlNode( cDest, "enderDest" )
   FOR EACH oElement IN { "xLgr", "nro", "xCpl", "xBairro", "cMun", "xMun", "UF", "CEP", "cPais", "xPais" }
      ::aDest[ oElement ] := XmlNode( cDest, oElement )
   NEXT

   ::alocEnt := XmlToHash( XmlNode( cDest, "locEnt" ), { "CNPJ", "CPF", "xNome", "xLgr", "nro", "xCpl", "xBairro", "xMun", "UF" } )

   cExped := XmlNode( ::cXml, "exped" )
   ::aExped := XmlToHash( cExped, { "CNPJ", "CPF", "IE", "xNome", "fone", "email" } )
   ::aExped[ "xNome" ] := XmlToString( ::aExped[ "xNome" ] )
   ::aExped[ "email" ] := XmlToString( ::aExped[ "email" ] )

   cExped := XmlNode( cExped, "enderExped" )
   FOR EACH oElement IN { "xLgr", "nro", "xCpl", "xBairro", "cMun", "xMun", "UF", "CEP", "cPais", "xPais" }
      ::aExped[ oElement ] := XmlNode( cExped, oElement )
   NEXT

   cReceb := XmlNode( ::cXml, "receb" )
   ::aReceb := XmlToHash( cReceb, { "CNPJ", "CPF", "IE", "xNome", "fone", "email" } )
   ::aReceb[ "xNome" ] := XmlToString( ::aReceb[ "xNome" ] )
   ::aReceb[ "email" ] := XmlToString( ::aReceb[ "email" ] )

   cReceb := XmlNode( cReceb, "enderReceb" )
   FOR EACH oElement IN { "xLgr", "nro", "xCpl", "xBairro", "cMun", "xMun", "UF", "CEP", "cPais", "xPais" }
      ::aReceb[ oElement ] := XmlNode( cReceb, oElement )
   NEXT

   ::aPrest := XmlToHash( XmlNode( ::cXml, "vPrest" ), { "vTPrest", "vRec" } )

   ::aComp := {}
   cPrest  := XmlNode( ::cXml, "vPrest" )
   cText   := cPrest
   DO WHILE "<Comp" $ cText .AND. "</Comp" $ cText
      cComp := XmlNode( cText, "Comp" )
      cText := SubStr( cText, At( "</Comp", cText ) + 7 )
      AAdd( ::aComp, { ;
         XmlNode( cComp, "xNome" ), ;
         XmlNode( cComp, "vComp" ) } ) // runner
   ENDDO

   cImp        := XmlNode( ::cXml, "imp" )
   ::aIcms00   := XmlToHash( XmlNode( cImp, "ICMS00" ), { "CST", "vBC", "pICMS", "vICMS" } )
   ::aIcms20   := XmlToHash( XmlNode( cImp, "ICMS20" ), { "CST", "vBC", "pRedBC", "pICMS", "vICMS" } )
   ::aIcms45   := XmlToHash( XmlNode( cImp, "ICMS45" ), { "CST" } )
   ::aIcms60   := XmlToHash( XmlNode( cImp, "ICMS60" ), { "CST", "vBCSTRet", "vICMSSTRet", "pICMSSTRet", "vCred" } )
   ::aIcms90   := XmlToHash( XmlNode( cImp, "ICMS90" ), { "CST", "pRedBC", "vBC", "pICMS", "vICMS", "vCred" } )
   ::aIcmsUF   := XmlToHash( XmlNode( cImp, "ICMSOutraUF" ), { "CST", "pRedBCOutraUF", "vBCOutraUF", "pICMSOutraUF", "vICMSOutraUF" } )
   ::aIcmsSN   := XmlToHash( XmlNode( cImp, "ICMSSN" ), { "indSN" } )
   ::cAdFisco  := XmlNode( cImp, "infAdFisco" )
   ::vTotTrib  := XmlNode( ::cXml, "vTotTrib" )
   cinfCTeNorm := XmlNode( ::cXml, "infCTeNorm" )
   cinfCarga   := XmlNode( cInfCteNorm, "infCarga" )
   ::aInfCarga := hb_Hash()
   FOR EACH oElement IN { "vCarga", "proPred", "xOutCat" }
      ::aInfCarga[ oElement ] := XmlNode( cInfCarga, oElement )
   NEXT

   ::aInfQ := {}
   cText := XmlNode( cInfCteNorm, "infCarga" )
   DO WHILE "<infQ" $ cText .AND. "</infQ" $ cText
      cInfQ := XmlNode( cText, "infQ" )
      cText := SubStr( cText, At( "</infQ", cText ) + 7 )
      AAdd( ::aInfQ, { ;
         XmlNode( cInfQ, "cUnid" ), + ;
         XmlNode( cInfQ, "tpMed" ), + ;
         XmlNode( cInfQ, "qCarga" ) } )
   ENDDO

   ::aSeg     := XmlToHash( XmlNode( cInfCteNorm, "seg" ), { "respSeg", "xSeg", "nApol", "nAver", "vCarga" } )
   ::aMoto    := XmlToHash( XmlNode( cInfCteNorm, "moto" ), { "xNome", "CPF" } )
   cRodo      := XmlNode( cInfCteNorm, "rodo" )
   ::aRodo    := XmlToHash( cRodo, { "RNTRC", "dPrev", "lota", "CIOT", "nLacre" } )
   ::aValePed := XmlToHash( XmlNode( cRodo, "valePed" ), { "CNPJForn", "nCompra", "CNPJPg" } )
   ::aProp    := XmlToHash( XmlNode( cRodo, "prop" ), { "CPF", "CNPJ", "RNTRC", "xNome", "IE", "UF", "tpProp" } )

   ::aVeiculo := {}
   cText := XmlNode( cinfCteNorm, "rodo" )
   DO WHILE "<veic" $ cText .AND. "</veic" $ cText
      cVeiculo := XmlNode( cText, "veic" )
      cText    := SubStr( cText, At( "</veic", cText ) + 7 )
      AAdd( ::aVeiculo, { ;
         XmlNode( cVeiculo, "cInt" ), ;
         XmlNode( cVeiculo, "RENAVAM" ), ;
         XmlNode( cVeiculo, "placa" ), ;
         XmlNode( cVeiculo, "tara" ), ;
         XmlNode( cVeiculo, "capKG" ), ;
         XmlNode( cVeiculo, "capM3" ), ;
         XmlNode( cVeiculo, "tpProp" ), ;
         XmlNode( cVeiculo, "tpVeic" ), ;
         XmlNode( cVeiculo, "tpRod" ), ;
         XmlNode( cVeiculo, "tpCar" ), ;
         XmlNode( cVeiculo, "UF" ) } )
   ENDDO

   ::aInfProt   := XmlToHash( XmlNode( ::cXml, "infProt" ), { "nProt", "dhRecbto", "digVal", "cStat", "xMotivo" } )
   ::aInfCanc   := XmlToHash( XmlNode( iif( Empty( ::cXmlCancel ), ::cXml, ::cXmlCancel ), "infProt" ), { "nProt", "dhRecbto", "digVal", "cStat", "xMotivo" } )

   DO CASE
   CASE ::aIde[ 'toma' ] = '0' ; ::aToma := ::aRem
   CASE ::aIde[ 'toma' ] = '1' ; ::aToma := ::aExped
   CASE ::aIde[ 'toma' ] = '2' ; ::aToma := ::aReceb
   CASE ::aIde[ 'toma' ] = '3' ; ::aToma := ::aDest
   ENDCASE

   RETURN .T.

METHOD GeraPDF( cFilePDF ) CLASS hbnfeDaCte

   ::oPdf := HPDF_New()
   If ::oPdf == NIL
      ::cRetorno := "Falha da criação do objeto PDF !"
      RETURN .F.
   ENDIF
   HPDF_SetCompressionMode( ::oPdf, HPDF_COMP_ALL )
   ::oPdfFontCabecalho     := HPDF_GetFont( ::oPdf, "Times-Roman", "CP1252" )
   ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Times-Bold",  "CP1252" )

#ifdef __XHARBOUR__
   // Inserido por Anderson Camilo em 04/04/2012
   ::cFonteCode128  := HPDF_LoadType1FontFromFile( ::oPdf, 'fontes\Code128bWinLarge.afm', 'fontes\Code128bWinLarge.pfb' )   // Code 128
   ::cFonteCode128F := HPDF_GetFont( ::oPdf, ::cFonteCode128, "WinAnsiEncoding" )
#endif

   ::nFolha := 1
   ::novaPagina()
   ::cabecalho()

   HPDF_SaveToFile( ::oPdf, cFilePDF )
   HPDF_Free( ::oPdf )

   RETURN .T.

METHOD NovaPagina() CLASS hbnfeDaCte

   LOCAL nRadiano, nAngulo

   ::oPdfPage := HPDF_AddPage( ::oPdf )

   HPDF_Page_SetSize( ::oPdfPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT )

   ::nLinhaPdf := HPDF_Page_GetHeight( ::oPDFPage ) - 3     // Margem Superior
   nAngulo := 45                   /* A rotation of 45 degrees. */

   nRadiano := nAngulo / 180 * 3.141592 /* Calcurate the radian value. */

   IF ::aIde[ "tpAmb" ] = "2" .OR. Empty( ::ainfProt[ "nProt" ] )

      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
      HPDF_Page_BeginText( ::oPdfPage )
      HPDF_Page_SetTextMatrix( ::oPdfPage, Cos( nRadiano ), Sin( nRadiano ), -Sin( nRadiano ), Cos( nRadiano ), 15, 100 )
      HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
      HPDF_Page_ShowText( ::oPdfPage, "AMBIENTE DE HOMOLOGAÇÃO - SEM VALOR FISCAL" )
      HPDF_Page_EndText( ::oPdfPage )

      HPDF_Page_SetRGBStroke( ::oPdfPage, 0.75, 0.75, 0.75 )
      hbNFe_Line_Hpdf( ::oPdfPage, 15, 100, 550, 630, 2.0 )

      HPDF_Page_SetRGBStroke( ::oPdfPage, 0, 0, 0 ) // reseta cor linhas

      HPDF_Page_SetRGBFill( ::oPdfPage, 0, 0, 0 ) // reseta cor fontes

   ENDIF

   IF .NOT. Empty( ::aInfCanc[ "nProt" ] ) .AND. ::aInfCanc[ "cStat" ] $ "101,135,302" // 302=denegada

       HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPdfFontCabecalhoBold, 30 )
       HPDF_Page_BeginText(::oPdfPage)
       HPDF_Page_SetTextMatrix(::oPdfPage, cos(nRadiano), sin(nRadiano), -sin(nRadiano), cos(nRadiano), 15, 150)
       HPDF_Page_SetRGBFill(::oPdfPage, 1, 0, 0)
       HPDF_Page_ShowText(::oPdfPage, ::aInfCanc[ "xMotivo" ])
       HPDF_Page_EndText(::oPdfPage)

       HPDF_Page_SetRGBStroke(::oPdfPage, 0.75, 0.75, 0.75)
       IF ::lPaisagem = .T. // paisagem
          hbnfe_Line_hpdf( ::oPdfPage, 15, 95, 675, 475, 2.0)
       ELSE
          hbnfe_Line_hpdf( ::oPdfPage, 15, 95, 550, 630, 2.0)
       ENDIF

       HPDF_Page_SetRGBStroke(::oPdfPage, 0, 0, 0) // reseta cor linhas

       HPDF_Page_SetRGBFill(::oPdfPage, 0, 0, 0) // reseta cor fontes

   ENDIF

   RETURN NIL

METHOD Cabecalho() CLASS hbnfeDaCte

   LOCAL oImage
   LOCAL aModal     := { 'Rodoviário', 'Aéreo', 'Aquaviário', 'Ferroviário', 'Dutoviário' }
   LOCAL aTipoCte   := { 'Normal', 'Compl.Val', 'Anul.Val.', 'Substituto' }
   LOCAL aTipoServ  := { 'Normal', 'Subcontratação', 'Redespacho', 'Redesp. Int.' }
   LOCAL aTomador   := { 'Remetente', 'Expedidor', 'Recebedor', 'Destinatário' }
   LOCAL aPagto     := { 'Pago', 'A pagar', 'Outros' }
   LOCAL aUnid      := { 'M3', 'KG', 'TON', 'UN', 'LI', 'MMBTU' }
   LOCAL aResp      := { 'Remetente', 'Expedidor', 'Recebedor', 'Destinatário', 'Emitente do CT-e', 'Tomador de Serviço' }
   LOCAL aTipoCar   := { 'não aplicável', 'Aberta', 'Fechada/Baú', 'Granelera', 'Porta Container', 'Sider' }
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
   LOCAL I, oElement, hZebra

   // box do logotipo e dados do emitente
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 119, 295, 119, ::nLarguraBox )

   IF ! Empty( ::cLogoFile )
      oImage := HPDF_LoadJpegImageFromFile( ::oPdf, ::cLogoFile )
      HPDF_Page_DrawImage( ::oPdfPage, oImage, 115, ::nLinhaPdf - ( 52 + 1 ), 100, 052 )
   ENDIF
   IF Len( ::aEmit[ "xNome" ] ) <= 25
      hbnfe_Texto_hpdf( ::oPdfPage,  3, ::nLinhaPdf - 056, 295, Nil, ::aEmit[ "xNome" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
   ELSE
      hbnfe_Texto_hpdf( ::oPdfPage,  3, ::nLinhaPdf - 056, 295, Nil, ::aEmit[ "xNome" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage,  6, ::nLinhaPdf - 070, 295, Nil, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ] + " " + ::aEmit[ "xCpl" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage,  6, ::nLinhaPdf - 078, 295, Nil, ::aEmit[ "xBairro" ] + " - " + TRANSF( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage,  6, ::nLinhaPdf - 086, 295, Nil, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   IF ! Empty( ::aEmit[ "fone" ] )
      hbnfe_Texto_hpdf( ::oPdfPage,  6, ::nLinhaPdf - 094, 295, Nil, 'Fone/Fax:(' + SubStr( ::aEmit[ "fone" ], 1, 2 ) + ')' + SubStr( ::aEmit[ "fone" ], 3, 4 ) + '-' + SubStr( ::aEmit[ "fone" ], 7, 4 ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage,  6, ::nLinhaPdf - 107, 295, Nil, 'CNPJ/CPF:' + TRANSF( ::aEmit[ "CNPJ" ], "@R 99.999.999/9999-99" ) + '       Inscr.Estadual:' + FormatIE( ::aEmit[ "IE" ], ::aEmit[ "UF" ] ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )

   // box do nome do documento
   hbnfe_Box_hpdf( ::oPdfPage, 303, ::nLinhaPdf - 032, 145, 032, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 303, ::nLinhaPdf - 001, 448, Nil, "DACTE", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
   hbnfe_Texto_hpdf( ::oPdfPage, 303, ::nLinhaPdf - 010, 448, Nil, "Documento Auxiliar do", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 303, ::nLinhaPdf - 016, 448, Nil, "Conhecimento de Transporte", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 303, ::nLinhaPdf - 022, 448, Nil, "Eletrônico", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )

   // box do modal
   hbnfe_Box_hpdf( ::oPdfPage, 453, ::nLinhaPdf - 032, 140, 032, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 453, ::nLinhaPdf - 001, 588, Nil, "MODAL", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 10 )
   hbnfe_Texto_hpdf( ::oPdfPage, 453, ::nLinhaPdf - 015, 588, Nil, aModal[ Val( ::aIde[ "modal" ] ) ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )

   // box do modelo
   hbnfe_Box_hpdf( ::oPdfPage, 303, ::nLinhaPdf - 060, 035, 025, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 303, ::nLinhaPdf - 040, 338, Nil, "Modelo", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 303, ::nLinhaPdf - 047, 338, Nil, ::aIde[ "mod" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   // box da serie
   hbnfe_Box_hpdf( ::oPdfPage, 338, ::nLinhaPdf - 060, 035, 025, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 338, ::nLinhaPdf - 040, 373, Nil, "Série", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 338, ::nLinhaPdf - 047, 373, Nil, ::aIde[ "serie" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   // box do numero
   hbnfe_Box_hpdf( ::oPdfPage, 373, ::nLinhaPdf - 060, 060, 025, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 373, ::nLinhaPdf - 040, 433, Nil, "Número", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 373, ::nLinhaPdf - 047, 433, Nil, ::aIde[ "nCT" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   // box do fl
   hbnfe_Box_hpdf( ::oPdfPage, 433, ::nLinhaPdf - 060, 035, 025, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 433, ::nLinhaPdf - 040, 468, Nil, "FL", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 433, ::nLinhaPdf - 047, 468, Nil, "1/1", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   // box do data e hora
   hbnfe_Box_hpdf( ::oPdfPage, 468, ::nLinhaPdf - 060, 125, 025, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 468, ::nLinhaPdf - 040, 588, Nil, "Data e Hora de Emissão", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 468, ::nLinhaPdf - 047, 588, Nil, SubStr( ::aIde[ "dhEmi" ], 9, 2 ) + "/" + SubStr( ::aIde[ "dhEmi" ], 6, 2 ) + "/" + SubStr( ::aIde[ "dhEmi" ], 1, 4 ) + ' ' + SubStr( ::aIde[ "dhEmi" ], 12 ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   // box do controle do fisco
   hbnfe_Box_hpdf( ::oPdfPage, 303, ::nLinhaPdf - 129, 290, 066, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 303, ::nLinhaPdf - 065, 588, Nil, "CONTROLE DO FISCO", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 09 )
#ifdef __XHARBOUR__
   hbnfe_Texto_hpdf( ::oPdfPage, 303, ::nLinhaPdf - 075, 588, Nil, hbnfe_Codifica_Code128c( ::cChave ), HPDF_TALIGN_CENTER, Nil, ::cFonteCode128F, 17 )
#else
   // atenção - chute inicial
   hZebra := hb_zebra_create_code128( ::cChave, Nil )
   hbNFe_Zebra_Draw_Hpdf( hZebra, ::oPdfPage, 320, ::nLinhaPDF -110, 0.9, 30 )
#endif
   hbnfe_Texto_hpdf( ::oPdfPage, 303, ::nLinhaPdf - 110, 588, Nil, "Chave de acesso para consulta de autenticidade no site www.cte.fazenda.gov.br", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 303, ::nLinhaPdf - 119, 588, Nil, TRANSF( ::cChave, "@R 99.9999.99.999.999/9999-99-99-999-999.999.999-999.999.999-9" ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )

   // box do tipo do cte
   hbnfe_Box_hpdf( ::oPdfPage, 003, ::nLinhaPdf - 154, 060, 032, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 003, ::nLinhaPdf - 125, 060, Nil, "Tipo do CTe", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 003, ::nLinhaPdf - 135, 060, Nil, aTipoCte[ Val( ::aIde[ "tpCTe" ] ) + 1 ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   // box do tipo do servico
   hbnfe_Box_hpdf( ::oPdfPage, 063, ::nLinhaPdf - 154, 070, 032, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 063, ::nLinhaPdf - 125, 133, Nil, "Tipo Serviço", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 063, ::nLinhaPdf - 135, 133, Nil, aTipoServ[ Val( ::aIde[ "tpServ" ] ) + 1 ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   // box do tipo do Tomador do Servico
   hbnfe_Box_hpdf( ::oPdfPage, 133, ::nLinhaPdf - 154, 070, 032, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 133, ::nLinhaPdf - 125, 203, Nil, "Tomador", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 133, ::nLinhaPdf - 135, 203, Nil, aTomador[ Val( ::aIde[ "toma" ] ) + 1 ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )

   // box do tipo Forma de Pagamento
   hbnfe_Box_hpdf( ::oPdfPage, 203, ::nLinhaPdf - 154, 095, 032, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 203, ::nLinhaPdf - 125, 298, Nil, "Forma de Pagamento", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 203, ::nLinhaPdf - 135, 298, Nil, aPagto[ Val( ::aIde[ "forPag" ] ) + 1 ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
   // box do No. do Protocolo
   hbnfe_Box_hpdf( ::oPdfPage, 303, ::nLinhaPdf - 154, 165, 022, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 303, ::nLinhaPdf - 135, 468, Nil, "No. PROTOCOLO", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   IF ! Empty( ::aInfProt[ "nProt" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 303, ::nLinhaPdf - 143, 468, Nil, ::aInfProt[ "nProt" ] + ' - ' + SubStr( ::aInfProt[ "dhRecbto" ], 9, 2 ) + "/" + SubStr( ::aInfProt[ "dhRecbto" ], 6, 2 ) + "/" + SubStr( ::aInfProt[ "dhRecbto" ], 1, 4 ) + ' ' + SubStr( ::aInfProt[ "dhRecbto" ], 12 ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 9 )
   ENDIF

   // box da Insc. da Suframa
   hbnfe_Box_hpdf( ::oPdfPage, 468, ::nLinhaPdf - 154, 125, 022, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 468, ::nLinhaPdf - 135, 588, Nil, "INSC. SUFRAMA DO DEST.", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   // hbnfe_Texto_hpdf( ::oPdfPage, 468 , ::nLinhaPdf-145 , 568, Nil, ::aDest[ "ISUF" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 6 )
   hbnfe_Texto_hpdf( ::oPdfPage, 468, ::nLinhaPdf - 143, 588, Nil, 'xxxxx xxxxxxxxxxxxxxx', HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 9 )

   // box da Natureza da Prestacao
   hbnfe_Box_hpdf( ::oPdfPage, 003, ::nLinhaPdf - 179, 590, 022, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 160, 588, Nil, "CFOP - Natureza da Prestação", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 168, 588, Nil, ::aIde[ "CFOP" ] + ' - ' + ::aIde[ "natOp" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )

   // Box da Origem da Prestação
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 204, 295, 022, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 185, 295, Nil, "Origem da Prestação", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 193, 295, Nil, ::aIde[ "xMunIni" ] + ' - ' + ::aIde[ "UFIni" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )

   // Box do Destino da Prestação
   hbnfe_Box_hpdf( ::oPdfPage,  303, ::nLinhaPdf - 204, 290, 022, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 308, ::nLinhaPdf - 185, 588, Nil, "Destino da Prestação", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 308, ::nLinhaPdf - 193, 588, Nil, ::aIde[ "xMunFim" ] + ' - ' + ::aIde[ "UFFim" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )

   // Box do Remetente
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 261, 295, 054, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 207, 040, Nil, "Remetente ", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 042, ::nLinhaPdf - 208, 295, Nil, ::aRem[ "xNome" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 215, 040, Nil, "Endereço", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 042, ::nLinhaPdf - 216, 295, Nil, ::aRem[ "xLgr" ] + " " + ::aRem[ "nro" ] + " " + ::aRem[ "xCpl" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 042, ::nLinhaPdf - 224, 295, Nil, ::aRem[ "xBairro" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 232, 040, Nil, "Município", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 042, ::nLinhaPdf - 233, 240, Nil, ::aRem[ "xMun" ] + " " + ::aRem[ "UF" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf - 232, 260, Nil, "CEP", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 260, ::nLinhaPdf - 233, 295, Nil, SubStr( ::aRem[ "CEP" ], 1, 5 ) + '-' + SubStr( ::aRem[ "CEP" ], 6, 3 ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 240, 042, Nil, "CNPJ/CPF", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   IF ! Empty( ::aRem[ "CNPJ" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 042, ::nLinhaPdf - 241, 150, Nil, Transform( ::aRem[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   IF ! Empty( ::aRem[ "CPF" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 042, ::nLinhaPdf - 241, 150, Nil, Transform( ::aRem[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 150, ::nLinhaPdf - 240, 250, Nil, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 245, ::nLinhaPdf - 241, 295, Nil, FormatIE( ::aRem[ "IE" ], ::aRem[ "UF" ] ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 248, 042, Nil, "Pais", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 042, ::nLinhaPdf - 249, 150, Nil, ::aRem[ "xPais" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 225, ::nLinhaPdf - 248, 250, Nil, "FONE", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   If ! Empty( ::aRem[ "fone" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 250, ::nLinhaPdf - 249, 295, Nil, TRANSF( Val( ::aRem[ "fone" ] ), "@R (99)9999-9999" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF

   // Box do Destinatario
   hbnfe_Box_hpdf( ::oPdfPage,  303, ::nLinhaPdf - 261, 290, 054, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 305, ::nLinhaPdf - 207, 340, Nil, "Destinatário", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 342, ::nLinhaPdf - 208, 595, Nil, ::aDest[ "xNome" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 305, ::nLinhaPdf - 215, 340, Nil, "Endereço", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 342, ::nLinhaPdf - 216, 588, Nil, ::aDest[ "xLgr" ] + " " + ::aDest[ "nro" ] + " " + ::aDest[ "xCpl" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 342, ::nLinhaPdf - 224, 588, Nil, ::aDest[ "xBairro" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 305, ::nLinhaPdf - 232, 340, Nil, "Município", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 342, ::nLinhaPdf - 233, 540, Nil, ::aDest[ "xMun" ] + " " + ::aDest[ "UF" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 535, ::nLinhaPdf - 232, 555, Nil, "CEP", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 555, ::nLinhaPdf - 233, 588, Nil, SubStr( ::aDest[ "CEP" ], 1, 5 ) + '-' + SubStr( ::aDest[ "CEP" ], 6, 3 ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 305, ::nLinhaPdf - 240, 342, Nil, "CNPJ/CPF", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   IF ! Empty( ::aDest[ "CNPJ" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 342, ::nLinhaPdf - 241, 450, Nil, TRANS( ::aDest[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   IF ! Empty( ::aDest[ "CPF" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 342, ::nLinhaPdf - 241, 450, Nil, TRANS( ::aDest[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 430, ::nLinhaPdf - 240, 530, Nil, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )

   hbnfe_Texto_hpdf( ::oPdfPage, 530, ::nLinhaPdf - 241, 595, Nil, AllTrim( ::aDest[ "IE" ], ::aDest[ "UF" ] ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 305, ::nLinhaPdf - 248, 342, Nil, "Pais", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 342, ::nLinhaPdf - 249, 450, Nil, ::aDest[ "xPais" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 520, ::nLinhaPdf - 248, 545, Nil, "FONE", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   IF ! Empty( ::aDest[ "fone" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 545, ::nLinhaPdf - 249, 595, Nil, '(' + SubStr( ::aDest[ "fone" ], 1, 2 ) + ')' + SubStr( ::aDest[ "fone" ], 3, 4 ) + '-' + SubStr( ::aDest[ "fone" ], 7, 4 ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   // Box do Expedidor
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 318, 295, 054, ::nLarguraBox )

   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 264, 040, Nil, "Expedidor", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   If ! Empty( ::aExped[ "xNome" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 042, ::nLinhaPdf - 265, 295, Nil, ::aExped[ "xNome" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 272, 040, Nil, "Endereço", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   If ! Empty( ::aExped[ "xLgr" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 042, ::nLinhaPdf - 273, 295, Nil, ::aExped[ "xLgr" ] + " " + ::aExped[ "nro" ] + " " + ::aExped[ "xCpl" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   If ! Empty( ::aExped[ "xBairro" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 042, ::nLinhaPdf - 280, 295, Nil, ::aExped[ "xBairro" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 288, 040, Nil, "Município", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   If ! Empty( ::aExped[ "xMun" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 042, ::nLinhaPdf - 289, 240, Nil, ::aExped[ "xMun" ] + " " + ::aExped[ "UF" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf - 288, 260, Nil, "CEP", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   If ! Empty( ::aExped[ "CEP" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 260, ::nLinhaPdf - 289, 295, Nil, SubStr( ::aExped[ "CEP" ], 1, 5 ) + '-' + SubStr( ::aExped[ "CEP" ], 6, 3 ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 296, 042, Nil, "CNPJ/CPF", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   If ! Empty( ::aExped[ "CNPJ" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 042, ::nLinhaPdf - 297, 150, Nil, TRANSF( ::aExped[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   If ! Empty( ::aExped[ "CPF" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 042, ::nLinhaPdf - 297, 150, Nil, TRANSF( ::aExped[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 150, ::nLinhaPdf - 296, 250, Nil, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 245, ::nLinhaPdf - 297, 295, Nil, AllTrim( ::aExped[ "IE" ] ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 304, 042, Nil, "Pais", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   If ! Empty( ::aExped[ "xPais" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 042, ::nLinhaPdf - 305, 150, Nil, ::aExped[ "xPais" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 225, ::nLinhaPdf - 304, 250, Nil, "FONE", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   If ! Empty( ::aExped[ "fone" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 250, ::nLinhaPdf - 305, 295, Nil, '(' + SubStr( ::aExped[ "fone" ], 1, 2 ) + ')' + SubStr( ::aExped[ "fone" ], 3, 4 ) + '-' + SubStr( ::aExped[ "fone" ], 7, 4 ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF

   // Box do Recebedor
   hbnfe_Box_hpdf( ::oPdfPage,  303, ::nLinhaPdf - 318, 290, 054, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 305, ::nLinhaPdf - 264, 340, Nil, "Recebedor", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
   If ! Empty( ::aReceb[ "xNome" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 342, ::nLinhaPdf - 265, 595, Nil, ::aReceb[ "xNome" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 305, ::nLinhaPdf - 272, 340, Nil, "Endereço", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   If ! Empty( ::aReceb[ "xLgr" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 342, ::nLinhaPdf - 273, 588, Nil, ::aReceb[ "xLgr" ] + " " + ::aReceb[ "nro" ] + " " + ::aReceb[ "xCpl" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   If ! Empty( ::aReceb[ "xBairro" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 342, ::nLinhaPdf - 280, 588, Nil, ::aReceb[ "xBairro" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 305, ::nLinhaPdf - 288, 340, Nil, "Município", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   If ! Empty( ::aReceb[ "xMun" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 342, ::nLinhaPdf - 289, 540, Nil, ::aReceb[ "xMun" ] + " " + ::aReceb[ "UF" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 535, ::nLinhaPdf - 288, 555, Nil, "CEP", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   If ! Empty( ::aReceb[ "CEP" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 555, ::nLinhaPdf - 289, 588, Nil, SubStr( ::aReceb[ "CEP" ], 1, 5 ) + '-' + SubStr( ::aReceb[ "CEP" ], 6, 3 ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 305, ::nLinhaPdf - 296, 342, Nil, "CNPJ/CPF", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   If ! Empty( ::aReceb[ "CNPJ" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 342, ::nLinhaPdf - 297, 450, Nil, TRANSF( ::aReceb[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   If ! Empty( ::aReceb[ "CPF" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 342, ::nLinhaPdf - 297, 450, Nil, TRANSF( ::aReceb[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 440, ::nLinhaPdf - 296, 540, Nil, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 540, ::nLinhaPdf - 297, 590, Nil, FormatIE( ::aReceb[ "IE" ], ::aReceb[ "UF" ] ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 305, ::nLinhaPdf - 304, 342, Nil, "Pais", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   If ! Empty( ::aReceb[ "xPais" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 342, ::nLinhaPdf - 305, 450, Nil, ::aReceb[ "xPais" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 520, ::nLinhaPdf - 304, 545, Nil, "FONE", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   If ! Empty( ::aReceb[ "fone" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 545, ::nLinhaPdf - 305, 595, Nil, '(' + SubStr( ::aReceb[ "fone" ], 1, 2 ) + ')' + SubStr( ::aReceb[ "fone" ], 3, 4 ) + '-' + SubStr( ::aReceb[ "fone" ], 7, 4 ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF

   // Box do Tomador
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 347, 590, 026, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 321, 075, Nil, "Tomador do Serviço", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 077, ::nLinhaPdf - 322, 330, Nil, ::aToma[ "xNome" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 337, ::nLinhaPdf - 321, 372, Nil, "Município", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 373, ::nLinhaPdf - 322, 460, Nil, ::aToma[ "xMun" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 495, ::nLinhaPdf - 321, 510, Nil, "UF", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 512, ::nLinhaPdf - 322, 534, Nil, ::aToma[ "UF" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 530, ::nLinhaPdf - 321, 550, Nil, "CEP", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 552, ::nLinhaPdf - 322, 590, Nil, SubStr( ::aToma[ "CEP" ], 1, 5 ) + '-' + SubStr( ::aToma[ "CEP" ], 6, 3 ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 329, 040, Nil, "Endereço", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 042, ::nLinhaPdf - 330, 590, Nil, ::aToma[ "xLgr" ] + " " + ::aToma[ "nro" ] + " " + ::aToma[ "xCpl" ] + ' - ' + ::aToma[ "xBairro" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 337, 042, Nil, "CNPJ/CPF", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )

   IF ! Empty( ::aToma[ "CNPJ" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 042, ::nLinhaPdf - 338, 150, Nil, TRANSF( ::aToma[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   IF ! Empty( ::aToma[ "CPF" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 042, ::nLinhaPdf - 338, 150, Nil, TRANSF( ::aToma[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF

   hbnfe_Texto_hpdf( ::oPdfPage, 150, ::nLinhaPdf - 337, 250, Nil, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 245, ::nLinhaPdf - 338, 295, Nil, FormatIE( ::aToma[ "IE" ], ::aToma[ "UF" ] ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 425, ::nLinhaPdf - 337, 465, Nil, "Pais", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 442, ::nLinhaPdf - 338, 500, Nil, ::aToma[ "xPais" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 520, ::nLinhaPdf - 337, 560, Nil, "FONE", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   If ! Empty( ::aToma[ "fone" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 542, ::nLinhaPdf - 338, 590, Nil, '(' + SubStr( ::aToma[ "fone" ], 1, 2 ) + ')' + SubStr( ::aToma[ "fone" ], 3, 4 ) + '-' + SubStr( ::aToma[ "fone" ], 7, 4 ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF

   // Box do Produto Predominante
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 373, 340, 023, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 350, 150, Nil, "Produto Predominante", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 360, 330, Nil, ::aInfCarga[ "proPred" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   hbnfe_Box_hpdf( ::oPdfPage,  343, ::nLinhaPdf - 373, 125, 023, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 348, ::nLinhaPdf - 350, 470, Nil, "Outras Características da Carga", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 348, ::nLinhaPdf - 360, 470, Nil, ::aInfCarga[ "xOutCat" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 10 )
   hbnfe_Box_hpdf( ::oPdfPage,  468, ::nLinhaPdf - 373, 125, 023, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 473, ::nLinhaPdf - 350, 590, Nil, "Valot Total da Mercadoria", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 473, ::nLinhaPdf - 358, 580, Nil, Trans( Val( ::aInfCarga[ "vCarga" ] ), '@E 9,999,999.99' ), HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalhoBold, 12 )

   // Box das Quantidades
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 398, 090, 025, ::nLarguraBox )
   hbnfe_Box_hpdf( ::oPdfPage,  093, ::nLinhaPdf - 398, 090, 025, ::nLarguraBox )
   hbnfe_Box_hpdf( ::oPdfPage,  183, ::nLinhaPdf - 398, 090, 025, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 373, 090, Nil, "QT./UN./Medida", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   IF Len( ::aInfQ ) > 0
      hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 383, 098, Nil, AllTrim( Tran( Val( ::aInfQ[ 1, 3 ] ), '@E 999,999.999' ) ) + '/' + aUnid[ Val( ::aInfQ[ 1, 1 ] ) + 1 ] + '/' + ::aInfQ[ 1, 2 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 098, ::nLinhaPdf - 373, 190, Nil, "QT./UN./Medida", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   IF Len( ::aInfQ ) > 1
      hbnfe_Texto_hpdf( ::oPdfPage, 098, ::nLinhaPdf - 383, 188, Nil, AllTrim( Tran( Val( ::aInfQ[ 2, 3 ] ), '@E 999,999.999' ) ) + '/' + aUnid[ Val( ::aInfQ[ 2, 1 ] ) + 1 ] + '/' + ::aInfQ[ 2, 2 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 188, ::nLinhaPdf - 373, 250, Nil, "QT./UN./Medida", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   IF Len( ::aInfQ ) > 2
      hbnfe_Texto_hpdf( ::oPdfPage, 188, ::nLinhaPdf - 383, 273, Nil, AllTrim( Tran( Val( ::aInfQ[ 3, 3 ] ), '@E 999,999.999' ) ) + '/' + aUnid[ Val( ::aInfQ[ 3, 1 ] ) + 1 ] + '/' + ::aInfQ[ 3, 2 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   ENDIF

   // Box da Seguradora
   hbnfe_Box_hpdf( ::oPdfPage,  273, ::nLinhaPdf - 383, 320, 010, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 278, ::nLinhaPdf - 373, 400, Nil, "Nome da Seguradora", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 405, ::nLinhaPdf - 373, 580, Nil, ::aSeg[ "xSeg" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Box_hpdf( ::oPdfPage,  273, ::nLinhaPdf - 398, 097, 015, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 278, ::nLinhaPdf - 383, 370, Nil, "Responsável", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 278, ::nLinhaPdf - 389, 370, Nil, aResp[ Val( ::aSeg[ "respSeg" ] ) + 1 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Box_hpdf( ::oPdfPage,  370, ::nLinhaPdf - 398, 098, 015, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 375, ::nLinhaPdf - 383, 465, Nil, "Número da Apólice", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 375, ::nLinhaPdf - 389, 468, Nil, ::aSeg[ "nApol" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )
   hbnfe_Box_hpdf( ::oPdfPage,  468, ::nLinhaPdf - 398, 125, 015, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 473, ::nLinhaPdf - 383, 590, Nil, "Número da Averbação", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 7 )
   hbnfe_Texto_hpdf( ::oPdfPage, 473, ::nLinhaPdf - 389, 590, Nil, ::aSeg[ "nAver" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 7 )

   // Box dos Componentes do Valor da Prestação do Serviço
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 410, 590, 009, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 003, ::nLinhaPdf - 400, 590, Nil, "Componentes do Valor da Prestação do Serviço", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   // Box de Servicos e Valores
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 475, 165, 062, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 413, 085, Nil, "Nome", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 085, ::nLinhaPdf - 413, 165, Nil, "Valor", HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Box_hpdf( ::oPdfPage,  168, ::nLinhaPdf - 475, 165, 062, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 171, ::nLinhaPdf - 413, 251, Nil, "Nome", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 251, ::nLinhaPdf - 413, 330, Nil, "Valor", HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Box_hpdf( ::oPdfPage,  333, ::nLinhaPdf - 475, 165, 062, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 338, ::nLinhaPdf - 413, 418, Nil, "Nome", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 418, ::nLinhaPdf - 413, 495, Nil, "Valor", HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Box_hpdf( ::oPdfPage,  498, ::nLinhaPdf - 444, 095, 031, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 498, ::nLinhaPdf - 417, 590, Nil, "Valor Total do Serviço", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 498, ::nLinhaPdf - 427, 580, Nil, Trans( Val( ::aPrest[ "vTPrest" ] ), '@E 999,999.99' ), HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalhoBold, 12 )
   hbnfe_Box_hpdf( ::oPdfPage,  498, ::nLinhaPdf - 475, 095, 031, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 498, ::nLinhaPdf - 447, 590, Nil, "Valor a Receber", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 498, ::nLinhaPdf - 457, 580, Nil, Trans( Val( ::aPrest[ "vRec" ] ), '@E 999,999.99' ), HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalhoBold, 12 )

   nLinha := 423
   FOR I = 1 TO Len( ::aComp ) STEP 3
      hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - nLinha, 165, Nil, ::aComp[ I, 1 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
      hbnfe_Texto_hpdf( ::oPdfPage, 085, ::nLinhaPdf - nlinha, 165, Nil, Trans( Val( ::aComp[ I, 2 ] ), '@E 999,999.99' ), HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalhoBold, 8 )

      hbnfe_Texto_hpdf( ::oPdfPage, 171, ::nLinhaPdf - nLinha, 251, Nil, ::aComp[ I + 1,1 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
      hbnfe_Texto_hpdf( ::oPdfPage, 251, ::nLinhaPdf - nLinha, 330, Nil, Trans( Val( ::aComp[ I + 1, 2 ] ), '@E 999,999.99' ), HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalhoBold, 8 )

      hbnfe_Texto_hpdf( ::oPdfPage, 338, ::nLinhaPdf - nLinha, 418, Nil, ::aComp[ I + 2,1 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
      hbnfe_Texto_hpdf( ::oPdfPage, 418, ::nLinhaPdf - nLinha, 495, Nil, Trans( Val( ::aComp[ I + 2, 2 ] ), '@E 999,999.99' ), HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalhoBold, 8 )
      nLinha += 10
   NEXT

   // Box das Informações Relativas ao Imposto
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 487, 590, 009, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 003, ::nLinhaPdf - 478, 590, Nil, "Informações Relativas ao Imposto", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   // Box da Situação Tributária
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 514, 155, 027, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 488, 155, Nil, "Situação Tributária", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   If ! Empty( ::aIcmsSN[ "indSN" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 500, 155, Nil, "SIMPLES NACIONAL", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
   ElseIf ! Empty( ::aIcms00[ "CST" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 500, 155, Nil, "00 - Tributação normal do ICMS", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
      nBase := ::aIcms00[ "vBC" ]
      nAliq := ::aIcms00[ "pICMS" ]
      nValor := ::aIcms00[ "vICMS" ]
      nReduc := ''
      nST := ''
   ElseIf ! Empty( ::aIcms20[ "CST" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 500, 155, Nil, "20 - Tributação com BC reduzida do ICMS", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
      nBase := ::aIcms20[ "vBC" ]
      nAliq := ::aIcms20[ "pICMS" ]
      nValor := ::aIcms20[ "vICMS" ]
      nReduc := ::aIcms20[ "pRedBC" ]
      nST := ''
   ElseIf ! Empty( ::aIcms45[ "CST" ] )
      If ::aIcms45[ "CST" ] = '40'
         hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 500, 155, Nil, "40 - ICMS isenção", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
      ElseIf ::aIcms45[ "CST" ] = '41'
         hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 500, 155, Nil, "41 - ICMS não tributada", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
      ElseIf ::aIcms45[ "CST" ] = '51'
         hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 500, 155, Nil, "51 - ICMS diferido", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
      ENDIF
   ElseIf ! Empty( ::aIcms60[ "CST" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 500, 155, Nil, "60 - ICMS cobrado anteriormente por substituição tributária", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
      nBase := ::aIcms60[ "vBCSTRet" ]
      nAliq := ::aIcms60[ "pICMSSTRet" ]
      nValor := ::aIcms60[ "vICMSSTRet" ]
      nReduc := ''
      nST := ::aIcms60[ "vCred" ]
   ElseIf ! Empty( ::aIcms90[ "CST" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 500, 155, Nil, "90 - ICMS Outros", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
      nBase := ::aIcms60[ "vBC" ]
      nAliq := ::aIcms60[ "pICMS" ]
      nValor := ::aIcms60[ "vICMS" ]
      nReduc := ::aIcms90[ "pRedBC" ]
      nST := ::aIcms60[ "vCred" ]
   ElseIf ! Empty( ::aIcmsUF[ "CST" ] )
      hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 500, 155, Nil, "90 - ICMS Outros", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
      nBase := ::aIcmsUF[ "vBCOutraUF" ]
      nAliq := ::aIcmsUF[ "pICMSOutraUF" ]
      nValor := ::aIcmsUF[ "vICMSOutraUF" ]
      nReduc := ::aIcmsUF[ "pRedBCOutraUF" ]
      nST := ''
   ELSE
      hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 500, 155, Nil, "Sem Imposto de ICMS", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
   ENDIF

   // Box da Base De Calculo
   hbnfe_Box_hpdf( ::oPdfPage,  158, ::nLinhaPdf - 514, 080, 027, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 160, ::nLinhaPdf - 488, 238, Nil, "Base De Calculo", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 160, ::nLinhaPdf - 498, 238, Nil, Trans( Val( nBase ), '@E 999,999.99' ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
   // Box da Alíq ICMS
   hbnfe_Box_hpdf( ::oPdfPage,  238, ::nLinhaPdf - 514, 080, 027, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf - 488, 318, Nil, "Alíq ICMS", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf - 498, 318, Nil, Trans( Val( nAliq ), '@E 999,999.99' ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
   // Box do Valor ICMS
   hbnfe_Box_hpdf( ::oPdfPage,  318, ::nLinhaPdf - 514, 080, 027, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 320, ::nLinhaPdf - 488, 398, Nil, "Valor ICMS", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 320, ::nLinhaPdf - 498, 398, Nil, Trans( Val( nValor ), '@E 999,999.99' ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
   // Box da % Red. BC ICMS
   hbnfe_Box_hpdf( ::oPdfPage,  398, ::nLinhaPdf - 514, 080, 027, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 400, ::nLinhaPdf - 488, 478, Nil, "% Red. BC ICMS", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 400, ::nLinhaPdf - 498, 478, Nil, Trans( Val( nReduc ), '@E 999,999.99' ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
   // Box do ICMS ST
   hbnfe_Box_hpdf( ::oPdfPage,  478, ::nLinhaPdf - 514, 115, 027, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 480, ::nLinhaPdf - 488, 590, Nil, "ICMS ST", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 480, ::nLinhaPdf - 498, 590, Nil, Trans( Val( nSt ), '@E 999,999.99' ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )

   // Box dos Documentos Originários
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 526, 590, 009, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 003, ::nLinhaPdf - 517, 590, Nil, "Documentos Originários", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   // Box dos documentos a esquerda
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 626, 295, 100, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 526, 050, Nil, "Tipo DOC", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   IF Len( ::aInfNF ) > 0
      hbnfe_Texto_hpdf( ::oPdfPage, 050, ::nLinhaPdf - 526, 240, Nil, "CNPJ/CPF Emitente", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   ELSEIF Len( ::aInfOutros ) > 0
      hbnfe_Texto_hpdf( ::oPdfPage, 170, ::nLinhaPdf - 526, 240, Nil, "CNPJ/CPF Emitente", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   ELSEIF Len( ::aInfNFe ) > 0
      hbnfe_Texto_hpdf( ::oPdfPage, 050, ::nLinhaPdf - 526, 240, Nil, "CHAVE DE ACESSO DA NF-e", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   ELSE
      hbnfe_Texto_hpdf( ::oPdfPage, 050, ::nLinhaPdf - 526, 240, Nil, "CNPJ/CPF Emitente", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf - 526, 295, Nil, "Série/Nro. Doc.", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )

   // Box dos documentos a direita
   hbnfe_Box_hpdf( ::oPdfPage,  298, ::nLinhaPdf - 626, 295, 100, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 300, ::nLinhaPdf - 526, 345, Nil, "Tipo DOC", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   IF Len( ::aInfNF ) > 0
      hbnfe_Texto_hpdf( ::oPdfPage, 345, ::nLinhaPdf - 526, 535, Nil, "CNPJ/CPF Emitente", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   ELSEIF Len( ::aInfOutros ) > 0
      hbnfe_Texto_hpdf( ::oPdfPage, 465, ::nLinhaPdf - 526, 535, Nil, "CNPJ/CPF Emitente", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   ELSEIF Len( ::aInfNFe ) > 0
      hbnfe_Texto_hpdf( ::oPdfPage, 345, ::nLinhaPdf - 526, 535, Nil, "CHAVE DE ACESSO DA NF-e", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   ELSE
      hbnfe_Texto_hpdf( ::oPdfPage, 345, ::nLinhaPdf - 526, 535, Nil, "CNPJ/CPF Emitente", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   ENDIF
   hbnfe_Texto_hpdf( ::oPdfPage, 535, ::nLinhaPdf - 526, 590, Nil, "Série/Nro. Doc.", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )

   IF Len( ::aInfNFe ) > 0
      nLinha := 536
      FOR I = 1 TO Len( ::aInfNFe ) STEP 2
         IF ! Empty( ::aInfNFe[ I, 1 ] )
            hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - nLinha, 353, Nil, "NF-E", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
            hbnfe_Texto_hpdf( ::oPdfPage, 050, ::nLinhaPdf - nLinha, 240, Nil, ::aInfNFe[ I, 1 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
            hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf - nLinha, 295, Nil, SubStr( ::aInfNFe[ I, 1 ], 23, 3 ) + '/' + SubStr( ::aInfNFe[ I, 1 ], 26, 9 ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
         ENDIF
         IF I + 1 <= Len( ::aInfNFe )
            hbnfe_Texto_hpdf( ::oPdfPage, 300, ::nLinhaPdf - nLinha, 353, Nil, "NF-E", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
            hbnfe_Texto_hpdf( ::oPdfPage, 345, ::nLinhaPdf - nLinha, 535, Nil, ::aInfNFe[ I + 1, 1 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
            hbnfe_Texto_hpdf( ::oPdfPage, 535, ::nLinhaPdf - nLinha, 590, Nil, SubStr( ::aInfNFe[ I + 1, 1 ], 23, 3 ) + '/' + SubStr( ::aInfNFe[ I + 1, 1 ], 26, 9 ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
         ENDIF
         nLinha += 10
      NEXT
   ENDIF

   IF Len( ::aInfNF ) > 0
      nLinha := 536
      FOR I = 1 TO Len( ::aInfNF ) STEP 2
         IF !Empty( ::aInfNF[ I, 4 ] )
            hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - nLinha - 2, 353, Nil, "NOTA FISCAL", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
            IF Val( ::aRem[ "CNPJ" ] ) > 0
               hbnfe_Texto_hpdf( ::oPdfPage, 050, ::nLinhaPdf - nLinha, 240, Nil, TRANSF( ::aRem[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
            ENDIF
            IF Val( ::aRem[ "CPF" ] ) > 0
               hbnfe_Texto_hpdf( ::oPdfPage, 050, ::nLinhaPdf - nLinha, 240, Nil, TRANSF( ::aRem[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
            ENDIF
            hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf - nLinha, 295, Nil, ::aInfNF[ I, 4 ] + '/' + ::aInfNF[ I, 5 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
         ENDIF
         IF I + 1 <= Len( ::aINfNF )
            hbnfe_Texto_hpdf( ::oPdfPage, 300, ::nLinhaPdf - nLinha - 2, 353, Nil, "NOTA FISCAL", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
            IF Val( ::aRem[ "CNPJ" ] ) > 0
               hbnfe_Texto_hpdf( ::oPdfPage, 345, ::nLinhaPdf - nLinha, 535, Nil, TRANSF( ::aRem[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
            ENDIF
            IF Val( ::aRem[ "CPF" ] ) > 0
               hbnfe_Texto_hpdf( ::oPdfPage, 345, ::nLinhaPdf - nLinha, 535, Nil, TRANSF( ::aRem[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
            ENDIF
            hbnfe_Texto_hpdf( ::oPdfPage, 535, ::nLinhaPdf - nLinha, 590, Nil, ::aInfNF[ I + 1, 4 ] + '/' + ::aInfNF[ I + 1, 5 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
         ENDIF
         nLinha += 10
      NEXT
   ENDIF
   IF Len( ::aInfOutros ) > 0
      nLinha := 536
      FOR I = 1 TO Len( ::aInfOutros ) STEP 2
         If ::aInfOutros[ I, 1 ] = '00'
            cOutros := 'DECLARAÇÃO'
         ElseIf ::aInfOutros[ I, 1 ] = '10'
            cOutros := 'DUTOVIÁRIO'
         ElseIf ::aInfOutros[ I, 1 ] = '99'
            cOutros := ::aInfOutros[ I, 2 ]
         ENDIF
         hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - nLinha, 240, Nil, cOutros, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
         IF Val( ::aRem[ "CNPJ" ] ) > 0
            hbnfe_Texto_hpdf( ::oPdfPage, 170, ::nLinhaPdf - nLinha, 240, Nil, TRANSF( ::aRem[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
         ENDIF
         IF Val( ::aRem[ "CPF" ] ) > 0
            hbnfe_Texto_hpdf( ::oPdfPage, 170, ::nLinhaPdf - nLinha, 240, Nil, TRANSF( ::aRem[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
         ENDIF
         hbnfe_Texto_hpdf( ::oPdfPage, 240, ::nLinhaPdf - nLinha, 295, Nil, ::aInfOutros[ I, 3 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
         IF I + 1 <= Len( ::aInfOutros )
            If ::aInfOutros[ I + 1, 1 ] = '00'
               cOutros := 'DECLARAÇÃO'
            ElseIf ::aInfOutros[ I + 1, 1 ] = '10'
               cOutros := 'DUTOVIÁRIO'
            ElseIf ::aInfOutros[ I + 1, 1 ] = '99'
               cOutros := ::aInfOutros[ I + 1, 2 ]
            ENDIF
            hbnfe_Texto_hpdf( ::oPdfPage, 300, ::nLinhaPdf - nLinha, 535, Nil, cOutros, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
            IF Val( ::aRem[ "CNPJ" ] ) > 0
               hbnfe_Texto_hpdf( ::oPdfPage, 465, ::nLinhaPdf - nLinha, 535, Nil, TRANSF( ::aRem[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
            ENDIF
            IF Val( ::aRem[ "CPF" ] ) > 0
               hbnfe_Texto_hpdf( ::oPdfPage, 465, ::nLinhaPdf - nLinha, 535, Nil, TRANSF( ::aRem[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
            ENDIF
            hbnfe_Texto_hpdf( ::oPdfPage, 535, ::nLinhaPdf - nLinha, 590, Nil, ::aInfOutros[ I + 1, 3 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
         ENDIF
         nLinha += 10
      NEXT
   ENDIF

   // Box das Observações Gerais
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 638, 590, 009, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 003, ::nLinhaPdf - 629, 590, Nil, "Observações Gerais", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 668, 590, 030, ::nLarguraBox )
   /*
   ::aCompl[ "xObs" ]:=Upper('Este documento tem por objetivo a definição das especificações e critérios técnicos necessários' +;
   ' para a integração entre os Portais das Secretarias de Fazendas dos Estados e os sistemas de' +;
   ' informações das empresas emissoras de Conhecimento de Transporte eletrônico - CT-e.')
   */
   IF ! Empty( ::aCompl[ "xObs" ] )
      AAdd( aObserv, ::aCompl[ "xObs" ] )
   ENDIF
   IF ! Empty( ::cAdFisco )
      AAdd( aObserv, ::cAdFisco )
   ENDIF
   If ! Empty( ::alocEnt[ 'xNome' ] )
      cEntrega := 'Local de Entrega : '
      If ! Empty( ::alocEnt[ "CNPJ" ] )
         cEntrega += 'CNPJ:' + ::alocEnt[ "CNPJ" ]
      ENDIF
      If ! Empty( ::alocEnt[ "CNPJ" ] )
         cEntrega += 'CPF:' + ::alocEnt[ "CPF" ]
      ENDIF
      If ! Empty( ::alocEnt[ "xNome" ] )
         cEntrega += ' - ' + ::alocEnt[ "xNome" ]
      ENDIF
      If ! Empty( ::alocEnt[ "xLgr" ] )
         cEntrega += ' - ' + ::alocEnt[ "xLgr" ]
      ENDIF
      If ! Empty( ::alocEnt[ "nro" ] )
         cEntrega += ',' + ::alocEnt[ "nro" ]
      ENDIF
      If ! Empty( ::alocEnt[ "xCpl" ] )
         cEntrega += ::alocEnt[ "xCpl" ]
      ENDIF
      If ! Empty( ::alocEnt[ "xBairro" ] )
         cEntrega += ::alocEnt[ "xBairro" ]
      ENDIF
      If ! Empty( ::alocEnt[ "xMun" ] )
         cEntrega += ::alocEnt[ "xMun" ]
      ENDIF
      If ! Empty( ::alocEnt[ "UF" ] )
         cEntrega += ::alocEnt[ "UF" ]
      ENDIF
      AAdd( aObserv, cEntrega )
   ENDIF
   nLinha := 638
   FOR EACH oElement IN aObserv
      DO WHILE Len( oElement ) > 0
         hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - nLinha, 590, Nil, Pad( oElement, 120 ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
         oElement := SubStr( oElement, 121 )
         nLinha += 10
      ENDDO
   NEXT
   /*
   If ! Empty( ::vTotTrib )
    hbnfe_Texto_hpdf( ::oPdfPage, 005 , ::nLinhaPdf-675 , 590, Nil, 'Valor aproximado total de tributos federais, estaduais e municipais conf. Disposto na Lei nº 12741/12 : R$ '+Alltrim(Trans( Val(::vTotTrib) , '@E 999,999.99' )) , HPDF_TALIGN_LEFT , Nil, ::oPdfFontCabecalhoBold, 8 )
   Endif
   */
   // Box dos DADOS ESPECÍFICOS DO MODAL RODOVIÁRIO - CARGA FRACIONADA
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 680, 590, 009, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 003, ::nLinhaPdf - 671, 590, Nil, "DADOS ESPECÍFICOS DO MODAL RODOVIÁRIO - CARGA FRACIONADA", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   // Box do RNTRC Da Empresa
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 698, 140, 018, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 680, 143, Nil, "RNTRC Da Empresa", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 688, 143, Nil, ::aRodo[ "RNTRC" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
   // Box do CIOT
   hbnfe_Box_hpdf( ::oPdfPage,  143, ::nLinhaPdf - 698, 070, 018, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 145, ::nLinhaPdf - 680, 213, Nil, "CIOT", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 145, ::nLinhaPdf - 688, 213, Nil, ::aRodo[ "CIOT" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
   // Box do Lotação
   hbnfe_Box_hpdf( ::oPdfPage,  213, ::nLinhaPdf - 698, 030, 018, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 215, ::nLinhaPdf - 680, 243, Nil, "Lotação", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 215, ::nLinhaPdf - 688, 243, Nil, iif( Val( ::aRodo[ "lota" ] ) = 0, 'Não', 'Sim' ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
   // Box do Data Prevista de Entrega
   hbnfe_Box_hpdf( ::oPdfPage,  243, ::nLinhaPdf - 698, 115, 018, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 245, ::nLinhaPdf - 680, 358, Nil, "Data Prevista de Entrega", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 245, ::nLinhaPdf - 688, 358, Nil, SubStr( ::aRodo[ "dPrev" ], 9, 2 ) + "/" + SubStr( ::aRodo[ "dPrev" ], 6, 2 ) + "/" + SubStr( ::aRodo[ "dPrev" ], 1, 4 ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
   // Box da Legislação
   hbnfe_Box_hpdf( ::oPdfPage,  358, ::nLinhaPdf - 698, 235, 018, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 360, ::nLinhaPdf - 680, 590, Nil, "ESTE CONHECIMENTO DE TRANSPORTE ATENDE", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 360, ::nLinhaPdf - 688, 590, Nil, "À LEGISLAÇÃO DE TRANSPORTE RODOVIÁRIO EM VIGOR", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )

   // Box da IDENTIFICAÇÃO DO CONJUNTO TRANSPORTADOR
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 706, 260, 008, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 003, ::nLinhaPdf - 698, 260, Nil, "IDENTIFICAÇÃO DO CONJUNTO TRANSPORTADOR", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 6 )
   // Box das INFORMAÇÕES RELATIVAS AO VALE PEDÁGIO
   hbnfe_Box_hpdf( ::oPdfPage,  263, ::nLinhaPdf - 706, 330, 008, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 263, ::nLinhaPdf - 698, 590, Nil, "INFORMAÇÕES RELATIVAS AO VALE PEDÁGIO", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 6 )

   // Box do Tipo
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 714, 055, 008, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 707, 055, Nil, "TIPO", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   // Box do PLACA
   hbnfe_Box_hpdf( ::oPdfPage,  058, ::nLinhaPdf - 714, 055, 008, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 060, ::nLinhaPdf - 707, 115, Nil, "PLACA", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   // Box da UF
   hbnfe_Box_hpdf( ::oPdfPage,  113, ::nLinhaPdf - 714, 020, 008, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 115, ::nLinhaPdf - 707, 133, Nil, "UF", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   // Box da RNTRC
   hbnfe_Box_hpdf( ::oPdfPage,  133, ::nLinhaPdf - 714, 130, 008, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 135, ::nLinhaPdf - 707, 260, Nil, "RNTRC", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   // Box dos Dados acima
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 736, 260, 022, ::nLarguraBox )
   nLinha := 714
   FOR I = 1 TO Len( ::aVeiculo )
      hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - nLinha, 055, Nil, aTipoCar[ Val( ::aVeiculo[ I, 10 ] ) + 1 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
      hbnfe_Texto_hpdf( ::oPdfPage, 060, ::nLinhaPdf - nlinha, 115, Nil, ::aVeiculo[ I, 03 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
      hbnfe_Texto_hpdf( ::oPdfPage, 115, ::nLinhaPdf - nlinha, 133, Nil, ::aVeiculo[ I, 11 ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
      hbnfe_Texto_hpdf( ::oPdfPage, 135, ::nLinhaPdf - nlinha, 260, Nil, ::aProp[ "RNTRC" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
      hbnfe_Texto_hpdf( ::oPdfPage, 135, ::nLinhaPdf - nlinha, 260, Nil, ::aRodo[ "RNTRC" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
      nLinha += 05
   NEXT

   // Box do CNPJ EMPRESA FORNECEDORA
   hbnfe_Box_hpdf( ::oPdfPage,  263, ::nLinhaPdf - 736, 110, 030, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 265, ::nLinhaPdf - 707, 373, Nil, "CNPJ EMPRESA FORNECEDORA", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbnfe_Texto_hpdf( ::oPdfPage, 265, ::nLinhaPdf - 717, 373, Nil, ::aValePed[ "CNPJForn" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
   // Box do CNPJ EMPRESA FORNECEDORA
   hbnfe_Box_hpdf( ::oPdfPage,  373, ::nLinhaPdf - 736, 110, 030, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 375, ::nLinhaPdf - 707, 483, Nil, "NÚMERO DO COMPROVANTE", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbnfe_Texto_hpdf( ::oPdfPage, 375, ::nLinhaPdf - 717, 483, Nil, ::aValePed[ "nCompra" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
   // Box do CNPJ RESPONSAVEL PAGAMENTO
   hbnfe_Box_hpdf( ::oPdfPage,  483, ::nLinhaPdf - 736, 110, 030, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 485, ::nLinhaPdf - 707, 590, Nil, "CNPJ RESPONSAVEL PAGAMENTO", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbnfe_Texto_hpdf( ::oPdfPage, 375, ::nLinhaPdf - 717, 483, Nil, ::aValePed[ "CNPJPg" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
   // Box do Nome do Motorista
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 744, 260, 008, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 737, 050, Nil, "MOTORISTA:", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbnfe_Texto_hpdf( ::oPdfPage, 060, ::nLinhaPdf - 737, 260, Nil, ::aMoto[ "xNome" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
   // Box do CPF do Motorista
   hbnfe_Box_hpdf( ::oPdfPage, 263, ::nLinhaPdf - 744, 120, 008, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 265, ::nLinhaPdf - 737, 325, Nil, "CPF MOTORISTA:", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbnfe_Texto_hpdf( ::oPdfPage, 330, ::nLinhaPdf - 737, 383, Nil, TRANS( ::aMoto[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
   // Box do IDENT. LACRE EM TRANSP:
   hbnfe_Box_hpdf( ::oPdfPage, 383, ::nLinhaPdf - 744, 210, 008, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 385, ::nLinhaPdf - 737, 495, Nil, "IDENT. LACRE EM TRANSP.", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbnfe_Texto_hpdf( ::oPdfPage, 500, ::nLinhaPdf - 737, 590, Nil, ::aRodo[ "nLacre" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
   // Box do USO EXCLUSIVO DO EMISSOR DO CT-E
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 752, 380, 008, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 745, 385, Nil, "USO EXCLUSIVO DO EMISSOR DO CT-E", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 753, 385, Nil, ::aObsCont[ "xTexto" ], HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 8 )
   // Box do RESERVADO AO FISCO
   hbnfe_Box_hpdf( ::oPdfPage,  383, ::nLinhaPdf - 752, 210, 008, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 385, ::nLinhaPdf - 745, 495, Nil, "RESERVADO AO FISCO", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )

   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 762, 380, 010, ::nLarguraBox )
   hbnfe_Box_hpdf( ::oPdfPage,  383, ::nLinhaPdf - 762, 210, 010, ::nLarguraBox )
   // Data e Desenvolvedor da Impressao
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 763, 200, NIL, "DATA E HORA DA IMPRESSÃO : " + DToC( Date() ) + ' - ' + Time(), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 4 )
   hbnfe_Texto_hpdf( ::oPdfPage, 500, ::nLinhaPdf - 763, 593, NIL, ::cDesenvolvedor, HPDF_TALIGN_RIGHT, Nil, ::oPdfFontCabecalhoBold, 4 )
   // linha tracejada
   HPDF_Page_SetDash( ::oPdfPage, DASH_MODE3, 4, 0 )
   HPDF_Page_SetLineWidth( ::oPdfPage, 0.5 )
   HPDF_Page_MoveTo( ::oPdfPage, 003, ::nLinhaPdf - 769 )
   HPDF_Page_LineTo( ::oPdfPage, 595, ::nLinhaPdf - 769 )
   HPDF_Page_Stroke( ::oPdfPage )
   HPDF_Page_SetDash( ::oPdfPage, NIL, 0, 0 )

   cMensa := 'DECLARO QUE RECEBI OS VOLUMES DESTE CONHECIMENTO EM PERFEITO ESTADO PELO QUE DOU POR CUMPRIDO O PRESENTE CONTRATO DE TRANSPORTE'
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 782, 590, 009, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 003, ::nLinhaPdf - 773, 590, Nil, cMensa, HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 7 )
   // Box do Nome
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 807, 160, 025, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 782, 163, Nil, "Nome", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   // Box do RG
   hbnfe_Box_hpdf( ::oPdfPage,  003, ::nLinhaPdf - 832, 160, 025, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 005, ::nLinhaPdf - 807, 163, Nil, "RG", HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 8 )
   // Box da ASSINATURA / CARIMBO
   hbnfe_Box_hpdf( ::oPdfPage,  163, ::nLinhaPdf - 832, 160, 050, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 165, ::nLinhaPdf - 822, 323, Nil, "ASSINATURA / CARIMBO", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   // Box da CHEGADA DATA/HORA
   hbnfe_Box_hpdf( ::oPdfPage,  323, ::nLinhaPdf - 807, 120, 025, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 325, ::nLinhaPdf - 782, 443, Nil, "CHEGADA DATA/HORA", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   // Box da SAÍDA DATA/HORA
   hbnfe_Box_hpdf( ::oPdfPage,  323, ::nLinhaPdf - 832, 120, 025, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 325, ::nLinhaPdf - 807, 443, Nil, "SAÍDA DATA/HORA", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   // Box do Número da CTe / Série
   hbnfe_Box_hpdf( ::oPdfPage,  443, ::nLinhaPdf - 807, 150, 025, ::nLarguraBox )
   hbnfe_Texto_hpdf( ::oPdfPage, 445, ::nLinhaPdf - 782, 593, Nil, "Número da CTe / Série", HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
   hbnfe_Texto_hpdf( ::oPdfPage, 445, ::nLinhaPdf - 792, 593, Nil, ::aIde[ "nCT" ] + ' / ' + ::aIde[ "serie" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
   // Box do nome do emitente
   hbnfe_Box_hpdf( ::oPdfPage,  443, ::nLinhaPdf - 832, 150, 025, ::nLarguraBox )
   // Razao Social do Emitente
   IF Len( ::aEmit[ "xNome" ] ) <= 40
      hbnfe_Texto_hpdf( ::oPdfPage, 445, ::nLinhaPdf - 813, 593, Nil, SubStr( ::aEmit[ "xNome" ], 1, 20 ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
      hbnfe_Texto_hpdf( ::oPdfPage, 445, ::nLinhaPdf - 820, 593, Nil, SubStr( ::aEmit[ "xNome" ], 21, 20 ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
   ELSE
      hbnfe_Texto_hpdf( ::oPdfPage, 445, ::nLinhaPdf - 808, 593, Nil, SubStr( ::aEmit[ "xNome" ], 1, 30 ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 6 )
      hbnfe_Texto_hpdf( ::oPdfPage, 445, ::nLinhaPdf - 815, 593, Nil, SubStr( ::aEmit[ "xNome" ], 31, 30 ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 6 )
      hbnfe_Texto_hpdf( ::oPdfPage, 445, ::nLinhaPdf - 822, 593, Nil, SubStr( ::aEmit[ "xNome" ], 61, 30 ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 6 )
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
// Funções repetidas em NFE, CTE, MDFE e EVENTO
// STATIC pra permitir uso simultâneo com outras rotinas

STATIC FUNCTION hbNFe_Texto_Hpdf( oPdfPage2, x1, y1, x2, y2, cText, align, desconhecido, oFontePDF, nTamFonte, nAngulo )

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
      HPDF_Page_SetTextMatrix( oPdfPage2, Cos( nRadiano ), Sin( nRadiano ), -Sin( nRadiano ), Cos( nRadiano ), x1, y1 )
      HPDF_Page_ShowText( oPdfPage2, cText )
   ENDIF
   HPDF_Page_EndText  ( oPdfPage2 )

   HB_SYMBOL_UNUSED( desconhecido )

   RETURN NIL


#ifdef __XHARBOUR__
STATIC FUNCTION hbnfe_Codifica_Code128c( pcCodigoBarra )

   // Parameters de entrada : O codigo de barras no formato Code128C "somente numeros" campo tipo caracter
   // Retorno               : Retorna o código convertido e com o caracter de START e STOP mais o checksum
   // : para impressão do código de barras utilizando a fonte Code128bWin, é necessário
   // : para utilizar essa fonte os arquivos Code128bWin.ttf, Code128bWin.afm e Code128bWin.pfb
   // Autor                  : Anderson Camilo
   // Data                   : 19/03/2012

   LOCAL nI := 0, checksum := 0, nValorCar, cCode128 := '', cCodigoBarra

   cCodigoBarra = pcCodigoBarra
   IF Len( cCodigoBarra ) > 0    // Verifica se os caracteres são válidos (somente números)
      IF Int( Len( cCodigoBarra ) / 2 ) = Len( cCodigoBarra ) / 2    // Tem ser par o tamanho do código de barras
         FOR nI = 1 TO Len( cCodigoBarra )
            IF ( Asc( SubStr( cCodigoBarra, nI, 1 ) ) < 48 .OR. Asc( SubStr( cCodigoBarra, nI, 1 ) ) > 57 )
               nI = 0
               EXIT
            ENDIF
         NEXT
      ENDIF
      IF nI > 0
         nI = 1 // nI é o índice da cadeia
         cCode128 = Chr( 155 )
         DO WHILE nI <= Len( cCodigoBarra )
            nValorCar = Val( SubStr( cCodigoBarra, nI, 2 ) )
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
         // Calcula o checksum
         FOR nI = 1 TO Len( cCode128 )
            nValorCar = Asc ( SubStr( cCode128, nI, 1 ) )
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
            checksum = Mod( ( checksum + ( nI -1 ) * nValorCar ), 103 )
         NEXT
         // Cálculo código ASCII do checkSum
         IF checksum = 0
            checksum += 128
         ELSEIF checksum < 95
            checksum += 32
         ELSE
            checksum +=  50
         ENDIF
         // Adiciona o checksum e STOP
         cCode128 = cCode128 + Chr( checksum ) +  Chr( 156 )
      ENDIF
   ENDIF

   RETURN cCode128
#else

STATIC FUNCTION hbNFe_Zebra_Draw_Hpdf( hZebra, page, ... )

   IF hb_zebra_geterror( hZebra ) != 0
      RETURN HB_ZEBRA_ERROR_INVALIDZEBRA
   ENDIF

   hb_zebra_draw( hZebra, {| x, y, w, h | HPDF_Page_Rectangle( page, x, y, w, h ) }, ... )

   HPDF_Page_Fill( page )

   RETURN 0

#endif

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

STATIC FUNCTION hbNFe_Box_Hpdf( oPdfPage2, x1, y1, x2, y2, nPen )

   HPDF_Page_SetLineWidth( oPdfPage2, nPen )
   HPDF_Page_Rectangle( oPdfPage2, x1, y1, x2, y2 )
   HPDF_Page_Stroke( oPdfPage2 )

   RETURN NIL
