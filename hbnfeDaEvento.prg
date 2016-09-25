/*
HBNFEDAEVENTO - DOCUMENTO AUXILIAR DO EVENTO
Fontes originais do projeto hbnfe em https://github.com/fernandoathayde/hbnfe

2016.09.24.1100 - Início de alterações pra qualquer documento
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
#define _LOGO_ESQUERDA        1
#define _LOGO_DIREITA         2
#define _LOGO_EXPANDIDO       3

CLASS hbnfeDaEvento

   METHOD Execute( cXmlEvento, cXmlDocumento, cFilePDF )
   METHOD BuscaDadosXML()
   METHOD GeraPDF()
   METHOD Cabecalho()
   METHOD Destinatario()
   METHOD Eventos()
   METHOD Rodape()

   VAR cTelefoneEmitente INIT ""
   VAR cSiteEmitente     INIT ""
   VAR cEmailEmitente    INIT ""
   VAR cXmlDocumento     INIT ""
   VAR cXmlEvento
   VAR cChaveNFe
   VAR cChaveEvento

   VAR aInfEvento
   VAR aIde
   VAR aEmit
   VAR aDest

   VAR cFonteEvento
   VAR cFonteCorrecoes
   VAR cFonteCode128
   VAR cFonteCode128F
   VAR oPdf
   VAR oPdfPage
   VAR oPdfFontCabecalho
   VAR oPdfFontCabecalhoBold
   VAR oPdfFontCorrecoes
   VAR nLinhaPDF

   VAR nLarguraBox INIT 0.7
   VAR lLaser      INIT .T.
   VAR lPaisagem
   VAR cLogoFile
   VAR nLogoStyle // 1-esquerda, 2-direita, 3-expandido

   VAR cFile
   VAR cRetorno

   ENDCLASS

METHOD Execute( cXmlEvento, cXmlDocumento, cFilePDF ) CLASS hbnfeDaEvento

   hb_Default( @::lLaser, .T. )
   hb_Default( @::cFonteEvento, "Times" )
   hb_Default( @::cFonteCorrecoes, "Courier" )

   IF Empty( cXmlEvento )
      ::cRetorno := "Não tem conteúdo do XML da carta de correção"
      RETURN ::cRetorno
   ENDIF
   //IF Empty( cXmlDocumento )
   //   ::cRetorno := "Não tem conteúdo do XML da nota"
   //   RETURN ::cRetorno
   //ENDIF
   IF ! Empty( cFilePDF )
      ::cFile := cFilePDF
   ENDIF

   ::cXmlEvento   := cXmlEvento
   ::cChaveEvento := Substr( ::cXmlEvento, At( "Id=", ::cXmlEvento ) + 3 + 9, 44 )

   IF .NOT. Empty( cXmlDocumento )
      ::cXmlDocumento   := cXmlDocumento
      ::cChaveNFe := Substr( ::cXmlDocumento, At( "Id=", ::cXmlDocumento ) + 3 + 4, 44 )
      IF ::cChaveEvento != ::cChaveNFe
         ::cRetorno := "Arquivos XML com Chaves diferentes. Chave Doc: " + ::cChaveNFe + " Chave Evento: " + ::cChaveEvento
         RETURN ::cRetorno
      ENDIF
   ENDIF

   IF ! ::BuscaDadosXML()
      RETURN ::cRetorno
   ENDIF

   IF ! ::GeraPDF()
      ::cRetorno := "Problema ao gerar o PDF da Carta de Correção"
      RETURN ::cRetorno
   ENDIF
   ::cRetorno := "OK"

   RETURN ::cRetorno

METHOD BuscaDadosXML() CLASS hbnfeDaEvento

   LOCAL cInfEvento, cInfEventoRet, cIde, cEmit, cDest

   cInfEvento := XmlNode( ::cXmlEvento, "infEvento" )
      ::aInfEvento := hb_Hash()
      ::aInfEvento[ "cOrgao" ]     := Left( ::cChaveEvento, 2 ) // XmlNode( cInfEvento, "cOrgao" )
      ::aInfEvento[ "tpEvento" ]   := XmlNode( cInfEvento, "tpEvento" )
      ::aInfEvento[ "nSeqEvento" ] := XmlNode( cInfEvento, "nSeqEvento" )
      ::aInfEvento[ "verEvento" ]  := XmlNode( cInfEvento, "verEvento" )
      ::aInfEvento[ "xCorrecao" ]  := XmlNode( cInfEvento, "xCorrecao" )

   cInfEventoRet := XmlNode( ::cXmlEvento, "retEvento" )
      ::aInfEvento[ "cStat" ]       := XmlNode( cInfEventoRet, "cStat" )
      ::aInfEvento[ "xMotivo" ]     := XmlNode( cInfEventoRet, "xMotivo" )
      ::aInfEvento[ "dhRegEvento" ] := XmlNode( cInfEventoRet, "dhRegEvento" )
      ::aInfEvento[ "nProt" ]       := XmlNode( cInfEventoRet, "nProt" )

   cIde := XmlNode( ::cXmlDocumento, "ide" )
      ::aIde := hb_Hash()
      ::aIde[ "mod" ]   := Substr( ::cChaveEvento, 21, 2 ) // XmlNode( cIde, "mod" )
      ::aIde[ "serie" ] := Substr( ::cChaveEvento, 23, 3 ) // XmlNode( cIde, "serie" )
      ::aIde[ "nNF" ]   := Substr( ::cChaveEvento, 26, 9 ) // XmlNode( cIde, "nNF" )
      ::aIde[ "dhEmi" ] := XmlNode( cIde, "dhEmi" )

   cEmit := XmlNode( ::cXmlDocumento, "emit" )
      ::aEmit := hb_Hash()
      ::aEmit[ "CNPJ" ]    := Substr( ::cChaveEvento, 7, 14 ) // XmlNode( cEmit, "CNPJ" )
      ::aEmit[ "xNome" ]   := XmlToString( XmlNode( cEmit, "xNome" ) )
      ::aEmit[ "xFant" ]   := XmlNode( cEmit, "xFant" )
      ::aEmit[ "xLgr" ]    := XmlNode( cEmit, "xLgr" )
      ::aEmit[ "nro" ]     := XmlNode( cEmit, "nro" )
      ::aEmit[ "xBairro" ] := XmlNode( cEmit, "xBairro" )
      ::aEmit[ "cMun" ]    := XmlNode( cEmit, "cMun" )
      ::aEmit[ "xMun" ]    := XmlNode( cEmit, "xMun" )
      ::aEmit[ "UF" ]      := XmlNode( cEmit, "UF" )
      ::aEmit[ "CEP" ]     := XmlNode( cEmit, "CEP" )
      ::aEmit[ "fone" ]    := XmlNode( cEmit, "fone" ) // NFE 2.0
      ::aEmit[ "IE" ]      := XmlNode( cEmit, "IE" )
      ::cTelefoneEmitente := XmlNode( cEmit, "fone" )
      IF .NOT. Empty( ::cTelefoneEmitente )
         ::cTelefoneEmitente := Transform( SoNumeros( ::cTelefoneEmitente ), "@R (99) 9999-9999" )
      END

   cDest := XmlNode( ::cXmlDocumento, "dest" )
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
      ::aDest[ "fone" ]    := XmlNode( cDest, "fone" )
      IF Len( ::aDest[ "fone" ] ) <= 8
         ::aDest[ "fone" ] := "00" + ::aDest[ "fone" ]
      ENDIF
      ::aDest[ "IE" ] := XmlNode( cDest, "IE" )

   RETURN .T.

METHOD GeraPDF() CLASS hbNfeDaEvento

   // /////////////////////////////////////// LOCAL nItem, nIdes, nItensNF, nItens1Folha
   LOCAL nAltura // ///////////////////////// nRadiano, nLargura, nAngulo

   // criacao objeto pdf
   ::oPdf := HPDF_New()
   IF ::oPdf == NIL
      ::cRetorno := "Falha da criação do objeto PDF da Carta de Correção!"
      RETURN ::cRetorno
   ENDIF

   /* set compression mode */
   HPDF_SetCompressionMode( ::oPdf, HPDF_COMP_ALL )

   /* setando fonte */
   IF ::cFonteEvento == "Times"
      ::oPdfFontCabecalho     := HPDF_GetFont( ::oPdf, "Times-Roman", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Times-Bold", "CP1252" )
    ELSEIF ::cFonteEvento == "Helvetica"
      ::oPdfFontCabecalho     := HPDF_GetFont( ::oPdf, "Helvetica", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Helvetica-Bold", "CP1252" )
    ELSEIF ::cFonteEvento == "Courier-Oblique"
      ::oPdfFontCabecalho     := HPDF_GetFont( ::oPdf, "Courier-Oblique", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Courier-BoldOblique", "CP1252" )
    ELSE
      ::oPdfFontCabecalho     := HPDF_GetFont( ::oPdf, "Courier", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Courier-Bold", "CP1252" )
   ENDIF

   IF ::cFonteCorrecoes == "Times"
      ::oPdfFontCorrecoes     := HPDF_GetFont( ::oPdf, "Times-Roman", "CP1252" )
    ELSEIF ::cFonteCorrecoes == "Helvetica"
      ::oPdfFontCorrecoes     := HPDF_GetFont( ::oPdf, "Helvetica", "CP1252" )
    ELSEIF ::cFonteCorrecoes == "Courier-Oblique"
      ::oPdfFontCorrecoes     := HPDF_GetFont( ::oPdf, "Courier-Oblique", "CP1252" )
    ELSEIF ::cFonteCorrecoes == "Courier-Bold"
      ::oPdfFontCorrecoes     := HPDF_GetFont( ::oPdf, "Courier-Bold", "CP1252" )
    ELSE
      ::oPdfFontCorrecoes     := HPDF_GetFont( ::oPdf, "Courier", "CP1252" )
   ENDIF

   #ifdef __XHARBOUR__
     IF ! File( 'fontes\Code128bWinLarge.afm' ) .OR. ! File( 'fontes\Code128bWinLarge.pfb' )
        ::cRetorno := "Arquivos: fontes\Code128bWinLarge, nao encontrados"
        RETURN cRetorno
     ENDIF
     ::cFonteCode128  := HPDF_LoadType1FontFromFile( ::oPdf, 'fontes\Code128bWinLarge.afm', 'fontes\Code128bWinLarge.pfb' )   && Code 128
     ::cFonteCode128F := HPDF_GetFont( ::oPdf, ::cFonteCode128, "WinAnsiEncoding" )
   #endif

   // final da criacao e definicao do objeto pdf

   ::oPdfPage := HPDF_AddPage( ::oPdf )

   HPDF_Page_SetSize( ::oPdfPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT )
   nAltura := HPDF_Page_GetHeight( ::oPdfPage )    &&  = 841,89
   // ///////////////////nLargura := HPDF_Page_GetWidth( ::oPdfPage )    &&  = 595,28

   ::nLinhaPdf := nAltura - 25   && Margem Superior

   /////////////////////nAngulo := 45                   /* A rotation of 45 degrees. */
   // //////////////////nRadiano := nAngulo / 180 * 3.141592 /* Calcurate the radian value. */

   ::Cabecalho()
   ::Destinatario()
   ::Eventos()
   ::Rodape()

   ::cFile := iif( ::cFile == NIL, ::cChaveNFe + "-110110.PDF", ::cFile ) // 110110 é o evento carta de correção

   HPDF_SaveToFile( ::oPdf, ::cFile )
   HPDF_Free( ::oPdf )

   RETURN .T.

METHOD Cabecalho() CLASS hbnfeDaEvento

   LOCAL oImage, hZebra

   hbNFe_Box_Hpdf( ::oPdfPage, 30, ::nLinhaPDF - 106,   535,  110, ::nLarguraBox )    && Quadro Cabeçalho

   // logo/dados empresa

   hbNFe_Box_Hpdf( ::oPdfPage, 290, ::nLinhaPDF - 106,  275,  110, ::nLarguraBox )    && Quadro CC-e, Chave de Acesso e Codigo de Barras
   hbNFe_Texto_hpdf( ::oPdfPage, 30, ::nLinhaPdf + 2,     274, Nil, "IDENTIFICAÇÃO DO EMITENTE" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   // alert('nLogoStyle: ' + ::nLogoStyle +';_LOGO_ESQUERDA: ' + _LOGO_ESQUERDA)
   IF EMPTY( ::cLogoFile )
       hbNFe_Texto_hpdf( ::oPdfPage,  30, ::nLinhaPDF - 6 ,  289, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ], 30, 1 ) ) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 14 )
       hbNFe_Texto_hpdf( ::oPdfPage,  30, ::nLinhaPDF - 20,  289, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ], 30, 2 ) ) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 14 )
       hbNFe_Texto_hpdf( ::oPdfPage,  30, ::nLinhaPDF - 42,  289, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
       hbNFe_Texto_hpdf( ::oPdfPage,  30, ::nLinhaPDF - 52,  289, Nil, ::aEmit[ "xBairro" ]+" - "+ Transform( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
       hbNFe_Texto_hpdf( ::oPdfPage,  30, ::nLinhaPDF - 62,  289, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
       hbNFe_Texto_hpdf( ::oPdfPage,  30, ::nLinhaPDF - 72,  289, Nil, TRIM( iif( ! Empty( ::cTelefoneEmitente ), "FONE: " + ::cTelefoneEmitente, "" ) ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
       hbNFe_Texto_hpdf( ::oPdfPage,  30, ::nLinhaPDF - 82,  289, Nil, TRIM( ::cSiteEmitente ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
       hbNFe_Texto_hpdf( ::oPdfPage,  30, ::nLinhaPDF - 92,  289, Nil, TRIM( ::cEmailEmitente ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
   ELSE
       IF ::nLogoStyle = _LOGO_EXPANDIDO
          oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
          HPDF_Page_DrawImage( ::oPdfPage, oImage, 55, ::nLinhaPdf - (82+18), 218, 92 )
       ELSEIF ::nLogoStyle = _LOGO_ESQUERDA
          oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
          HPDF_Page_DrawImage( ::oPdfPage, oImage, 36, ::nLinhaPdf - (62+18), 62, 62 )
          hbNFe_Texto_hpdf( ::oPdfPage,  100, ::nLinhaPDF - 6 ,  289, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ],30,1)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
          hbNFe_Texto_hpdf( ::oPdfPage,  100, ::nLinhaPDF - 20 , 289, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ],30,2)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
          hbNFe_Texto_hpdf( ::oPdfPage,  100, ::nLinhaPDF - 42,  289, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_hpdf( ::oPdfPage,  100, ::nLinhaPDF - 52,  289, Nil, ::aEmit[ "xBairro" ]+" - "+ Transform( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_hpdf( ::oPdfPage,  100, ::nLinhaPDF - 62,  289, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_hpdf( ::oPdfPage,  100, ::nLinhaPDF - 72,  289, Nil, TRIM( iif( ! Empty( ::cTelefoneEmitente ),"FONE: " + ::cTelefoneEmitente, "" ) ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_hpdf( ::oPdfPage,  100, ::nLinhaPDF - 82,  289, Nil, TRIM( ::cSiteEmitente ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_hpdf( ::oPdfPage,  100, ::nLinhaPDF - 92,  289, Nil, TRIM( ::cEmailEmitente ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )

		ELSEIF ::nLogoStyle = _LOGO_DIREITA
          oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
          HPDF_Page_DrawImage( ::oPdfPage, oImage, 220, ::nLinhaPdf - (62+18), 62, 62 )
          hbNFe_Texto_hpdf( ::oPdfPage,  30, ::nLinhaPDF - 6 ,  218, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ], 30, 1 ) ) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
          hbNFe_Texto_hpdf( ::oPdfPage,  30, ::nLinhaPDF - 20 , 218, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ], 30, 2 ) ) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
          hbNFe_Texto_hpdf( ::oPdfPage,  30, ::nLinhaPDF - 42,  218, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_hpdf( ::oPdfPage,  30, ::nLinhaPDF - 52,  218, Nil, ::aEmit[ "xBairro" ]+" - "+ Transform( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_hpdf( ::oPdfPage,  30, ::nLinhaPDF - 62,  218, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_hpdf( ::oPdfPage,  30, ::nLinhaPDF - 72,  218, Nil, TRIM( iif( ! Empty( ::cTelefoneEmitente ), "FONE: " + ::cTelefoneEmitente, "" ) ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_hpdf( ::oPdfPage,  30, ::nLinhaPDF - 82,  218, Nil, TRIM( ::cSiteEmitente ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_hpdf( ::oPdfPage,  30, ::nLinhaPDF - 92,  218, Nil, TRIM( ::cEmailEmitente ), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
        ENDIF
   ENDIF

/*
      IF EMPTY( ::cLogoFile )
          hbNFe_Texto_hpdf( ::oPdfPage, 71, ::nLinhaPdf   , 399, Nil, "IDENTIFICAÇÃO DO EMITENTE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
          hbNFe_Texto_hpdf( ::oPdfPage, 71, ::nLinhaPDF - 6 , 399, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ],30,1)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
          hbNFe_Texto_hpdf( ::oPdfPage, 71, ::nLinhaPDF - 18, 399, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ],30,2)), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
          hbNFe_Texto_hpdf( ::oPdfPage, 71, ::nLinhaPDF - 30, 399, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_hpdf( ::oPdfPage, 71, ::nLinhaPDF - 38, 399, Nil, ::aEmit[ "xBairro" ]+" - "+ Transform( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_hpdf( ::oPdfPage, 71, ::nLinhaPDF - 46, 399, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_hpdf( ::oPdfPage, 71, ::nLinhaPDF - 54, 399, Nil, TRIM(IF(! Empty(::cTelefoneEmitente),"FONE: "+::cTelefoneEmitente,"")), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_hpdf( ::oPdfPage, 71, ::nLinhaPDF - 62, 399, Nil, TRIM(::cSiteEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          hbNFe_Texto_hpdf( ::oPdfPage, 71, ::nLinhaPDF - 70, 399, Nil, TRIM(::cEmailEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
       ELSE
          IF ::nLogoStyle = _LOGO_EXPANDIDO
             oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
             HPDF_Page_DrawImage( ::oPdfPage, oImage, 6, ::nLinhaPdf - (72+6), 328, 72 )
          ELSEIF ::nLogoStyle = _LOGO_ESQUERDA
             oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
             HPDF_Page_DrawImage( ::oPdfPage, oImage,71, ::nLinhaPdf - (72+6), 62, 72 )
              hbNFe_Texto_hpdf( ::oPdfPage,135, ::nLinhaPDF - 6 , 399, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ],30,1)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
              hbNFe_Texto_hpdf( ::oPdfPage,135, ::nLinhaPDF - 18, 399, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ],30,2)), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
              hbNFe_Texto_hpdf( ::oPdfPage,135, ::nLinhaPDF - 30, 399, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
              hbNFe_Texto_hpdf( ::oPdfPage,135, ::nLinhaPDF - 38, 399, Nil, ::aEmit[ "xBairro" ]+" - "+ Transform( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
              hbNFe_Texto_hpdf( ::oPdfPage,135, ::nLinhaPDF - 46, 399, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
              hbNFe_Texto_hpdf( ::oPdfPage,135, ::nLinhaPDF - 54, 399, Nil, TRIM(IF(! Empty(::cTelefoneEmitente),"FONE: "+::cTelefoneEmitente,"")), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
              hbNFe_Texto_hpdf( ::oPdfPage,135, ::nLinhaPDF - 62, 399, Nil, TRIM(::cSiteEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
              hbNFe_Texto_hpdf( ::oPdfPage,135, ::nLinhaPDF - 70, 399, Nil, TRIM(::cEmailEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
          ELSEIF ::nLogoStyle = _LOGO_DIREITA
             oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
             HPDF_Page_DrawImage( ::oPdfPage, oImage,337, ::nLinhaPdf - (72+6), 62, 72 )
            hbNFe_Texto_hpdf( ::oPdfPage, 71, ::nLinhaPDF - 6 , 335, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ],30,1)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
            hbNFe_Texto_hpdf( ::oPdfPage, 71, ::nLinhaPDF - 18, 335, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ],30,2)), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 12 )
            hbNFe_Texto_hpdf( ::oPdfPage, 71, ::nLinhaPDF - 30, 335, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_hpdf( ::oPdfPage, 71, ::nLinhaPDF - 38, 335, Nil, ::aEmit[ "xBairro" ]+" - "+ Transform( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_hpdf( ::oPdfPage, 71, ::nLinhaPDF - 46, 335, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_hpdf( ::oPdfPage, 71, ::nLinhaPDF - 54, 335, Nil, TRIM(IF(! Empty(::cTelefoneEmitente),"FONE: "+::cTelefoneEmitente,"")), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_hpdf( ::oPdfPage, 71, ::nLinhaPDF - 62, 335, Nil, TRIM(::cSiteEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
            hbNFe_Texto_hpdf( ::oPdfPage, 71, ::nLinhaPDF - 70, 335, Nil, TRIM(::cEmailEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 8 )
           ENDIF
      ENDIF
*/

   hbNFe_Texto_hpdf( ::oPdfPage,292, ::nLinhaPDF - 2   , 554, Nil, "CC-e" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 18 )
   hbNFe_Texto_hpdf( ::oPdfPage,296, ::nLinhaPDF - 22   , 554, Nil, "CARTA DE CORREÇÃO ELETRÔNICA" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 14 )

   // chave de acesso
   hbNFe_Box_Hpdf( ::oPdfPage, 290,::nLinhaPDF - 61 ,  275,  20, ::nLarguraBox )
   hbNFe_Texto_hpdf( ::oPdfPage,291, ::nLinhaPDF - 42   , 534, Nil, "CHAVE DE ACESSO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
   IF ::cFonteEvento == "Times"
      hbNFe_Texto_hpdf( ::oPdfPage,292, ::nLinhaPDF - 49   , 554, Nil, Transform( ::cChaveEvento, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
   ELSE
      hbNFe_Texto_hpdf( ::oPdfPage,292, ::nLinhaPDF - 50   , 554, Nil, Transform( ::cChaveEvento, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
   ENDIF

   // codigo barras
#ifdef __XHARBOUR__
   hbNFe_Texto_hpdf( ::oPdfPage,291, ::nLinhaPDF - 65, 555, Nil, hbnfe_CodificaCode128c(::cChaveNFe), HPDF_TALIGN_CENTER, Nil, ::cFonteCode128F, 18 )
#else
   hZebra := hb_zebra_create_code128( ::cChaveEvento, Nil )
   hbNFe_Zebra_Draw_Hpdf( hZebra, ::oPdfPage, 300, ::nLinhaPDF - 100, 0.9, 30 )
#endif

   ::nLinhaPdf -= 106

   // CNPJ
   hbNFe_Box_Hpdf( ::oPdfPage,  30, ::nLinhaPDF - 20,   535,  20, ::nLarguraBox )    && Quadro CNPJ/INSCRIÇÃO
   hbNFe_Texto_hpdf( ::oPdfPage,32, ::nLinhaPdf,      160, Nil, "CNPJ" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage,31, ::nLinhaPDF - 6,    160, Nil, Transform(::aEmit[ "CNPJ" ], "@R 99.999.999/9999-99"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // I.E.
   hbNFe_Box_Hpdf(  ::oPdfPage, 160, ::nLinhaPDF - 20,  130,  20, ::nLarguraBox )    && Quadro INSCRIÇÃO
   hbNFe_Texto_hpdf( ::oPdfPage,162, ::nLinhaPdf,     290, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage,161, ::nLinhaPDF - 6,   290, Nil, ::aEmit[ "IE" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // MODELO DO DOCUMENTO (NF-E)
   hbNFe_Texto_hpdf( ::oPdfPage,291, ::nLinhaPdf,     340, Nil, "MODELO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage,291, ::nLinhaPDF - 6,   340, Nil, ::aIde[ "mod" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // SERIE DOCUMENTO (NF-E)
   hbNFe_Box_Hpdf( ::oPdfPage,  340, ::nLinhaPDF - 20,   50,  20, ::nLarguraBox )
   hbNFe_Texto_hpdf( ::oPdfPage,341, ::nLinhaPdf,     390, Nil, "SERIE" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage,341, ::nLinhaPDF - 6,   390, Nil, ::aIde[ "serie" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // NUMERO NFE
   hbNFe_Texto_hpdf( ::oPdfPage,391, ::nLinhaPdf,     480, Nil, "NUMERO DA NF-e" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage,391, ::nLinhaPDF - 6,   480, Nil, Substr( StrZero( Val( ::aIde[ "nNF" ]),9),1,3)+"."+Substr( StrZero( Val( ::aIde[ "nNF" ]),9),4,3)+"."+Substr( StrZero( Val( ::aIde[ "nNF" ]),9),7,3) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // DATA DE EMISSAO DA NFE
   hbNFe_Box_Hpdf( ::oPdfPage,  480, ::nLinhaPDF - 20,   85,  20, ::nLarguraBox )
   hbNFe_Texto_hpdf( ::oPdfPage,481, ::nLinhaPdf,     565, Nil, "DATA DE EMISSÃO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage,481, ::nLinhaPDF - 6,   565, Nil, Substr( ::aIde[ "dhEmi" ],9,2) + '/' + Substr( ::aIde[ "dhEmi" ],6,2) + '/' + left(::aIde[ "dhEmi" ],4), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   RETURN NIL

METHOD Destinatario() CLASS hbnfeDaEvento

   // REMETENTE / DESTINATARIO

	::nLinhaPdf -= 24

   hbNFe_Texto_hpdf( ::oPdfPage, 30, ::nLinhaPdf  , 565, Nil, "DESTINATÁRIO/REMETENTE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )

   ::nLinhaPdf -= 9
   // RAZAO SOCIAL
   hbNFe_Box_Hpdf( ::oPdfPage,  30, ::nLinhaPDF - 20, 425, 20, ::nLarguraBox )
   hbNFe_Texto_hpdf( ::oPdfPage,32, ::nLinhaPdf    , 444, Nil, "NOME / RAZÃO SOCIAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage,32, ::nLinhaPDF - 6  , 444, Nil, ::aDest[ "xNome" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 11)
   // CNPJ/CPF
   hbNFe_Box_Hpdf( ::oPdfPage,455, ::nLinhaPDF - 20, 110, 20, ::nLarguraBox )
   hbNFe_Texto_hpdf( ::oPdfPage,457, ::nLinhaPdf    , 565, Nil, "CNPJ/CPF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   IF ! Empty(::aDest[ "CNPJ" ])
      hbNFe_Texto_hpdf( ::oPdfPage,457, ::nLinhaPDF - 6  , 565, Nil, Transform(::aDest[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )
   ELSE
      IF ::aDest[ "CPF" ] <> Nil
         hbNFe_Texto_hpdf( ::oPdfPage,457, ::nLinhaPDF - 6  , 565, Nil, Transform(::aDest[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )
      ENDIF
   ENDIF

   ::nLinhaPdf -= 20

   // ENDEREÇO
   hbNFe_Box_Hpdf( ::oPdfPage, 30, ::nLinhaPDF - 20, 270, 20, ::nLarguraBox )
   hbNFe_Texto_hpdf( ::oPdfPage, 32, ::nLinhaPdf    , 298, Nil, "ENDEREÇO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage, 32, ::nLinhaPDF - 6  , 298, Nil, ::aDest[ "xLgr" ]+" "+::aDest[ "nro" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 9 )
   // BAIRRO
   hbNFe_Box_Hpdf( ::oPdfPage, 300, ::nLinhaPDF - 20, 195, 20, ::nLarguraBox )
   hbNFe_Texto_hpdf( ::oPdfPage, 302, ::nLinhaPdf    , 494, Nil, "BAIRRO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage, 302, ::nLinhaPDF - 6  , 494, Nil, ::aDest[ "xBairro" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 11 )
   // CEP
   hbNFe_Box_Hpdf( ::oPdfPage, 495, ::nLinhaPDF - 20, 70, 20, ::nLarguraBox )
   hbNFe_Texto_hpdf( ::oPdfPage, 497, ::nLinhaPdf    , 564, Nil, "C.E.P." , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage, 497, ::nLinhaPDF - 6  , 564, Nil, Transform(::aDest[ "CEP" ], "@R 99999-999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   ::nLinhaPdf -= 20

   // MUNICIPIO
   hbNFe_Box_Hpdf( ::oPdfPage,  30, ::nLinhaPDF - 20, 535, 20, ::nLarguraBox )
   hbNFe_Texto_hpdf( ::oPdfPage,32, ::nLinhaPdf    , 284, Nil, "MUNICIPIO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage,32, ::nLinhaPDF - 6  , 284, Nil, ::aDest[ "xMun" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 11 )
   // FONE/FAX
   hbNFe_Box_Hpdf( ::oPdfPage,285, ::nLinhaPDF - 20, 140, 20, ::nLarguraBox )
   hbNFe_Texto_hpdf( ::oPdfPage,287, ::nLinhaPdf    , 424, Nil, "FONE/FAX" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   IF LEN( ::aDest[ "fone" ] ) = 10
      hbNFe_Texto_hpdf( ::oPdfPage,287, ::nLinhaPDF - 6  , 424, Nil, Transform( ::aDest[ "fone" ], "@R (99) 9999-9999" ) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )
   ELSEIF LEN( ::aDest[ "fone" ] ) > 10
      hbNFe_Texto_hpdf( ::oPdfPage,287, ::nLinhaPDF - 6  , 424, Nil, Transform( ::aDest[ "fone" ], "@R +99 (99) 9999-9999" ) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )
   ENDIF
   // ESTADO
   hbNFe_Texto_hpdf( ::oPdfPage,427, ::nLinhaPdf    , 454, Nil, "ESTADO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage,427, ::nLinhaPDF - 6  , 454, Nil, ::aDest[ "UF" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )
   // INSC. EST.
   hbNFe_Box_Hpdf( ::oPdfPage,455, ::nLinhaPDF - 20   , 110, 20, ::nLarguraBox )
   hbNFe_Texto_hpdf( ::oPdfPage,457, ::nLinhaPdf    , 564, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage,457, ::nLinhaPDF - 6  , 564, Nil, ::aDest[ "IE" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   ::nLinhaPdf -= 20

   RETURN NIL

METHOD Eventos() CLASS hbnfeDaEvento

   LOCAL cDataHoraReg, cMemo, nI, nCompLinha

   // Eventos
   hbNFe_Texto_hpdf( ::oPdfPage, 30, ::nLinhaPDF - 4 , 565, Nil, "EVENTOS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )

   ::nLinhaPdf -= 12

   hbNFe_Box_Hpdf( ::oPdfPage,  30, ::nLinhaPDF - 20 ,   535,  20, ::nLarguraBox )

   // ORGAO EMITENTE
   hbNFe_Texto_hpdf( ::oPdfPage,32, ::nLinhaPdf,   90, Nil, "ORGÃO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage,32, ::nLinhaPDF - 6, 90, Nil, ::aInfEvento[ "cOrgao" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // TIPO DE EVENTO'
   hbNFe_Box_Hpdf( ::oPdfPage,  90, ::nLinhaPDF - 20,   60,  20, ::nLarguraBox )
   hbNFe_Texto_hpdf( ::oPdfPage,92, ::nLinhaPdf,     149, Nil, "TIPO EVENTO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage,92, ::nLinhaPDF - 6,   149, Nil, ::aInfEvento[ "tpEvento" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // SEQUENCIA  EVENTO
   hbNFe_Texto_hpdf( ::oPdfPage,152, ::nLinhaPdf,   209, Nil, "SEQ. EVENTO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage,152, ::nLinhaPDF - 6, 209, Nil, ::aInfEvento[ "nSeqEvento" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // VERSÃO DO EVENTO
   hbNFe_Box_Hpdf( ::oPdfPage,  210, ::nLinhaPDF - 20 ,   60,  20, ::nLarguraBox )
   hbNFe_Texto_hpdf( ::oPdfPage,212, ::nLinhaPdf,      269, Nil, "VERSÃO EVENTO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage,212, ::nLinhaPDF - 6,    269, Nil, ::aInfEvento[ "verEvento" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // DATA E HORA DO REGISTRO
   hbNFe_Texto_hpdf( ::oPdfPage,272, ::nLinhaPdf,  429, Nil, "DATA DO REGISTRO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   cDataHoraReg := Substr( ::aInfEvento[ "dhRegEvento" ],9,2) + '/'
   cDataHoraReg += Substr( ::aInfEvento[ "dhRegEvento" ],6,2) + '/'
   cDataHoraReg += left(::aInfEvento[ "dhRegEvento" ],4) + '  '
   cDataHoraReg += Substr( ::aInfEvento[ "dhRegEvento" ],12,8)
   hbNFe_Texto_hpdf( ::oPdfPage,272, ::nLinhaPDF - 6, 429, Nil, cDataHoraReg , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // NUMERO DO PROTOCOLO
   hbNFe_Box_Hpdf( ::oPdfPage,  430, ::nLinhaPDF - 20,    135,  20, ::nLarguraBox )
   hbNFe_Texto_hpdf( ::oPdfPage,432, ::nLinhaPdf,       564, Nil, "NUMERO DO PROTOCOLO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage,432, ::nLinhaPDF - 6,     564, Nil, ::aInfEvento[ "nProt" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

  ::nLinhaPdf -= 20

   // STATUS DO EVENTO
   hbNFe_Box_Hpdf( ::oPdfPage,  30, ::nLinhaPDF - 20,  535,  20, ::nLarguraBox )
   hbNFe_Texto_hpdf( ::oPdfPage,32, ::nLinhaPdf,     564, Nil, "STATUS DO EVENTO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_hpdf( ::oPdfPage,32, ::nLinhaPDF - 6,    60, Nil, ::aInfEvento[ "cStat" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )
   hbNFe_Texto_hpdf( ::oPdfPage,62, ::nLinhaPDF - 6,    564, Nil, ::aInfEvento[ "xMotivo" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 11 )

  ::nLinhaPdf -= 25

   // Correções

   hbNFe_Texto_hpdf( ::oPdfPage, 30, ::nLinhaPdf , 565, Nil, "CORREÇÕES" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
   hbNFe_Box_Hpdf( ::oPdfPage,  30, ::nLinhaPDF - 188 ,   535,  180, ::nLarguraBox )

   ::nLinhaPdf -= 12

   cMemo := ::aInfEvento[ "xCorrecao" ]

   cMemo := STRTRAN( cMemo , ";", CHR(13)+CHR(10) )
   nCompLinha := 77
   IF ::cFonteCorrecoes == "Helvetica"
      nCompLinha := 75
   ENDIF

   FOR nI = 1 TO MLCOUNT( cMemo, nCompLinha )
      hbNFe_Texto_hpdf( ::oPdfPage,38, ::nLinhaPdf    ,564, Nil, UPPER( TRIM( MemoLine( cMemo,nCompLinha,nI) ) ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCorrecoes, 11 )
      ::nLinhaPdf -= 12
   NEXT

   FOR nI=(MLCOUNT( cMemo, nCompLinha )+1) TO 14
      ::nLinhaPdf -= 12
   NEXT

   RETURN NIL

METHOD Rodape() CLASS hbnfeDaEvento

   LOCAL cTextoCond, nTamFonte

   ::nLinhaPdf -= 13

   IF ::cFonteEvento == "Times"
      nTamFonte = 13
   ELSEIF ::cFonteEvento == "Helvetica"
      nTamFonte = 12
   ELSEIF ::cFonteEvento == "Courier-Oblique"
      nTamFonte = 9
   ELSE
      nTamFonte = 9
   ENDIF

   // Condição de USO

   hbNFe_Texto_hpdf( ::oPdfPage, 30, ::nLinhaPdf , 535, Nil, "CONDIÇÃO DE USO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
   hbNFe_Box_Hpdf( ::oPdfPage,  30, ::nLinhaPDF - 102 ,   535,  94, ::nLarguraBox )
   cTextoCond := 'A Carta de Correção é disciplinada pelo § 1º-A do art. 7º do Convênio S/N, de 15 de dezembro de'
   hbNFe_Texto_hpdf( ::oPdfPage,34, ::nLinhaPdf - 12    ,564, Nil, cTextoCond , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, nTamFonte )
   cTextoCond := '1970,  e pode ser utilizada para regularização de erro ocorrido na emissão de documento fiscal,'
   hbNFe_Texto_hpdf( ::oPdfPage,34, ::nLinhaPdf - 24    ,564, Nil, cTextoCond , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, nTamFonte )
   cTextoCond := 'desde que o erro não esteja relacionado com:'
   hbNFe_Texto_hpdf( ::oPdfPage,34, ::nLinhaPdf - 36    ,564, Nil, cTextoCond , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, nTamFonte )
   cTextoCond := 'I   - As variáveis que determinam o valor do imposto tais como:  Base de cálculo, alíquota,'
   hbNFe_Texto_hpdf( ::oPdfPage,34, ::nLinhaPdf - 48    ,564, Nil, cTextoCond , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, nTamFonte )
   cTextoCond := '      diferença de preço, quantidade, valor da operação ou da prestação;'
   hbNFe_Texto_hpdf( ::oPdfPage,34, ::nLinhaPdf - 60    ,564, Nil, cTextoCond , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, nTamFonte )
   cTextoCond := 'II  - A correção de dados cadastrais que implique mudança do remetente ou do destinatário;'
   hbNFe_Texto_hpdf( ::oPdfPage,34, ::nLinhaPdf - 72    ,564, Nil, cTextoCond , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, nTamFonte )
   cTextoCond := 'III - A data de emissão ou de saída.'
   hbNFe_Texto_hpdf( ::oPdfPage,34, ::nLinhaPdf - 84    ,564, Nil, cTextoCond , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, nTamFonte )

   // Observações:

   ::nLinhaPdf -= 100

   IF ::cFonteEvento == "Times"
      cTextoCond := 'Para evitar-se  qualquer  sansão fiscal, solicitamos acusarem o recebimento  desta,  na'
      hbNFe_Texto_hpdf( ::oPdfPage, 34, ::nLinhaPDF - 12 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 15 )
      cTextoCond := 'cópia que acompanha, devendo  a  via  de  V.S(as) ficar juntamente com  a nota fiscal'
      hbNFe_Texto_hpdf( ::oPdfPage, 34, ::nLinhaPDF - 26 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 15 )
      cTextoCond := 'em questão.'
      hbNFe_Texto_hpdf( ::oPdfPage, 34, ::nLinhaPDF - 40 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 15 )
   ELSEIF ::cFonteEvento == "Helvetica"
      cTextoCond := 'Para evitar-se qualquer sansão fiscal, solicitamos acusarem  o  recebimento desta, '
      hbNFe_Texto_hpdf( ::oPdfPage, 34, ::nLinhaPDF - 12 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 14 )
      cTextoCond := 'na cópia que acompanha, devendo a via  de  V.S(as) ficar juntamente com  a  nota '
      hbNFe_Texto_hpdf( ::oPdfPage, 34, ::nLinhaPDF - 26 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 14 )
      cTextoCond := 'fiscal em questão.'
      hbNFe_Texto_hpdf( ::oPdfPage, 34, ::nLinhaPDF - 40 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 14 )
   ELSE
      cTextoCond := 'Para evitar-se qualquer sansão fiscal, solicitamos acusarem o recebimento desta,'
      hbNFe_Texto_hpdf( ::oPdfPage, 34, ::nLinhaPDF - 12 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 11 )
      cTextoCond := 'na cópia que acompanha, devendo a via  de  V.S(as) ficar juntamente com  a nota'
      hbNFe_Texto_hpdf( ::oPdfPage, 34, ::nLinhaPDF - 26 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 11 )
      cTextoCond := 'fiscal em questão.'
      hbNFe_Texto_hpdf( ::oPdfPage, 34, ::nLinhaPDF - 40 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 11 )
   ENDIF

   // Observações:

   ::nLinhaPdf -= 100

   hbNFe_Line_Hpdf( ::oPdfPage, 34, ::nLinhaPDF - 12, 270, ::nLinhaPDF - 12, ::nLarguraBox)

   hbNFe_Texto_hpdf( ::oPdfPage, 30,  ::nLinhaPDF - 14, 284, Nil, 'Local e data' , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 9 )
   hbNFe_Texto_hpdf( ::oPdfPage, 304, ::nLinhaPDF - 14, 574, Nil, 'Sem outro motivo para o momento subscrevemos-nos.' , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 9 )
   hbNFe_Texto_hpdf( ::oPdfPage, 304, ::nLinhaPDF - 24, 574, Nil, 'Atenciosamente.' , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 9 )

   hbNFe_Line_Hpdf( ::oPdfPage, 34,  ::nLinhaPDF - 92, 270, ::nLinhaPDF - 92, ::nLarguraBox)
   hbNFe_Line_Hpdf( ::oPdfPage, 564, ::nLinhaPDF - 92, 300, ::nLinhaPDF - 92, ::nLarguraBox)

   hbNFe_Texto_hpdf( ::oPdfPage, 30,  ::nLinhaPDF - 94, 284, Nil,  trim( MemoLine( ::aDest[ "xNome" ],40,1 ) ) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 9 )
   hbNFe_Texto_hpdf( ::oPdfPage, 30,  ::nLinhaPDF - 108, 284, Nil, trim( MemoLine( ::aDest[ "xNome" ],40,2 ) ) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 9 )
   hbNFe_Texto_hpdf( ::oPdfPage, 300, ::nLinhaPDF - 94,  574, Nil, trim( MemoLine( ::aEmit[ "xNome" ],40,1 ) ) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 9 )
   hbNFe_Texto_hpdf( ::oPdfPage, 300, ::nLinhaPDF - 108, 574, Nil, trim( MemoLine( ::aEmit[ "xNome" ],40,2 ) ) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 9 )

   RETURN NIL

