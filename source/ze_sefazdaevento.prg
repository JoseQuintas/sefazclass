/*
ZE_SPEDDAEVENTO - Documento auxiliar de Eventos
Fontes originais do projeto hbnfe em https://github.com/fernandoathayde/hbnfe
Contribuição DaEvento: MSouzaRunner
*/

#include "common.ch"
#include "hbclass.ch"
#include "harupdf.ch"
#define LAYOUT_LOGO_ESQUERDA        1
#define LAYOUT_LOGO_DIREITA         2
#define LAYOUT_LOGO_EXPANDIDO       3

CREATE CLASS hbnfeDaEvento INHERIT hbNFeDaGeral

   METHOD ToPDF( cXmlEvento, cFilePDF, cXmlAuxiliar )
   METHOD BuscaDadosXML()
   METHOD GeraPDF( cFilePDF )
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

   VAR aCorrecoes
   VAR aInfEvento
   VAR aIde
   VAR aEmit
   VAR aDest

   VAR cFonteEvento      INIT "Times"
   VAR cFonteCorrecoes   INIT "Courier"
   VAR cFonteCode128
   VAR cFonteCode128F
   VAR oPdf
   VAR oPdfPage
   VAR oPDFFontNormal
   VAR oPDFFontBold
   VAR oPdfFontCorrecoes
   VAR nLinhaPDF

   VAR nLarguraBox INIT 0.7
   VAR lLaser      INIT .T.
   VAR lPaisagem
   VAR cLogoFile  INIT ""
   VAR nLogoStyle INIT LAYOUT_LOGO_ESQUERDA

   VAR cRetorno

   ENDCLASS

METHOD ToPDF( cXmlEvento, cFilePDF, cXmlAuxiliar ) CLASS hbnfeDaEvento

   IF Empty( cXmlEvento )
      ::cRetorno := "Não tem conteúdo do XML da carta de correção"
      RETURN ::cRetorno
   ENDIF

   IF cXmlAuxiliar != NIL .AND. ! Empty( cXmlAuxiliar )
      ::cXmlDocumento := cXmlAuxiliar
   ENDIF
   ::cXmlEvento   := cXmlEvento
   ::cChaveEvento := SubStr( ::cXmlEvento, At( "Id=", ::cXmlEvento ) + 3 + 9, 44 )

   IF ! Empty( ::cXmlDocumento )
      ::cChaveNFe := SubStr( ::cXmlDocumento, At( "Id=", ::cXmlDocumento ) + 3 + 4, 44 )
      IF ::cChaveEvento != ::cChaveNFe
         ::cRetorno := "Arquivos XML com Chaves diferentes. Chave Doc: " + ::cChaveNFe + " Chave Evento: " + ::cChaveEvento
         RETURN ::cRetorno
      ENDIF
   ENDIF

   IF ! ::BuscaDadosXML()
      RETURN ::cRetorno
   ENDIF

   IF ! ::GeraPDF( cFilePDF )
      ::cRetorno := "Problema ao gerar o PDF da Carta de Correção"
      RETURN ::cRetorno
   ENDIF
   ::cRetorno := "OK"

   RETURN ::cRetorno

METHOD BuscaDadosXML() CLASS hbnfeDaEvento

   ::aCorrecoes := XmlNode( ::cXmlEvento, "infEvento" )
   ::aCorrecoes := XmlNode( ::aCorrecoes , "evCCeCTe" )
   ::aCorrecoes := MultipleNodeToArray( ::aCorrecoes, "infCorrecao" )

   ::aInfEvento := XmlToHash( XmlNode( ::cXmlEvento, "infEvento" ), { "tpEvento", "nSeqEvento", "verEvento", "xCorrecao" } )
   ::aInfEvento[ "cOrgao" ] := Left( ::cChaveEvento, 2 )

   IF At( "retEventoCTe", ::cXmlEvento ) > 0
      ::aInfEvento := XmlToHash( XmlNode( ::cXmlEvento, "retEventoCTe" ), { "cStat", "xMotivo", "dhRegEvento", "nProt" }, ::aInfEvento )
   ELSE
      ::aInfEvento := XmlToHash( XmlNode( ::cXmlEvento, "retEvento" ), { "cStat", "xMotivo", "dhRegEvento", "nProt" }, ::aInfEvento )
   ENDIF
   ::aIde := hb_Hash()
   ::aIde[ "mod" ]   := DfeModFis( ::cChaveEvento ) // XmlNode( cIde, "mod" )
   ::aIde[ "serie" ] := SubStr( ::cChaveEvento, 23, 3 ) // XmlNode( cIde, "serie" )
   ::aIde[ "nNF" ]   := DfeNumero( ::cChaveEvento ) // XmlNode( cIde, "nNF" )
   ::aIde[ "dhEmi" ] := XmlNode( XmlNode( ::cXmlDocumento, "ide" ), "dhEmi" )

   ::aEmit := XmlToHash( XmlNode( ::cXmlDocumento, "emit" ), { "xNome", "xFant", "xLgr", "nro", "xBairro", "cMun", "xMun", "UF", "CEP", "fone", "IE" } )
   ::aEmit[ "CNPJ" ]    := DfeEmitente( ::cChaveEvento )
   ::aEmit[ "xNome" ]   := XmlToString( ::aEmit[ "xNome" ] )
   ::cTelefoneEmitente  := ::FormataTelefone( ::aEmit[ "fone" ] )

   ::aDest := XmlToHash( XmlNode( ::cXmlDocumento, "dest" ), { "CNPJ", "CPF", "xNome", "xLgr", "nro", "xBairro", "cMun", "xMun", "UF", "CEP", "fone", "IE" } )
   ::aDest[ "xNome" ] := XmlToString( ::aDest[ "xNome" ] )

   RETURN .T.

METHOD GeraPDF( cFilePDF ) CLASS hbNfeDaEvento

   LOCAL nAltura

   // criacao objeto pdf
   ::oPdf := HPDF_New()
   IF ::oPdf == NIL
      ::cRetorno := "Falha da criação do objeto PDF da Carta de Correção!"
      RETURN ::cRetorno
   ENDIF

   /* set compression mode */
   HPDF_SetCompressionMode( ::oPdf, HPDF_COMP_ALL )

   /* setando fonte */
   DO CASE
   CASE ::cFonteEvento == "Times" ;           ::oPDFFontNormal := HPDF_GetFont( ::oPdf, "Times-Roman",     "CP1252" ) ; ::oPDFFontBold := HPDF_GetFont( ::oPdf, "Times-Bold",          "CP1252" )
   CASE ::cFonteEvento == "Helvetica" ;       ::oPDFFontNormal := HPDF_GetFont( ::oPdf, "Helvetica",       "CP1252" ) ; ::oPDFFontBold := HPDF_GetFont( ::oPdf, "Helvetica-Bold",      "CP1252" )
   CASE ::cFonteEvento == "Courier-Oblique" ; ::oPDFFontNormal := HPDF_GetFont( ::oPdf, "Courier-Oblique", "CP1252" ) ; ::oPDFFontBold := HPDF_GetFont( ::oPdf, "Courier-BoldOblique", "CP1252" )
   OTHERWISE ;                                ::oPDFFontNormal := HPDF_GetFont( ::oPdf, "Courier",         "CP1252" ) ; ::oPDFFontBold := HPDF_GetFont( ::oPdf, "Courier-Bold",        "CP1252" )
   ENDCASE

   DO CASE
   CASE ::cFonteCorrecoes == "Times" ;           ::oPdfFontCorrecoes := HPDF_GetFont( ::oPdf, "Times-Roman",     "CP1252" )
   CASE ::cFonteCorrecoes == "Helvetica" ;       ::oPdfFontCorrecoes := HPDF_GetFont( ::oPdf, "Helvetica",       "CP1252" )
   CASE ::cFonteCorrecoes == "Courier-Oblique" ; ::oPdfFontCorrecoes := HPDF_GetFont( ::oPdf, "Courier-Oblique", "CP1252" )
   CASE ::cFonteCorrecoes == "Courier-Bold" ;    ::oPdfFontCorrecoes := HPDF_GetFont( ::oPdf, "Courier-Bold",    "CP1252" )
   OTHERWISE ;                                   ::oPdfFontCorrecoes := HPDF_GetFont( ::oPdf, "Courier",         "CP1252" )
   ENDCASE

   // final da criacao e definicao do objeto pdf

   ::oPdfPage := HPDF_AddPage( ::oPdf )

   HPDF_Page_SetSize( ::oPdfPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT )
   nAltura := HPDF_Page_GetHeight( ::oPdfPage )    // = 841,89
   // ///////////////////nLargura := HPDF_Page_GetWidth( ::oPdfPage )    &&  = 595,28

   ::nLinhaPdf := nAltura -25   // Margem Superior

   // ///////////////////nAngulo := 45                   /* A rotation of 45 degrees. */
   // //////////////////nRadiano := nAngulo / 180 * 3.141592 /* Calcurate the radian value. */

   ::Cabecalho()
   ::Destinatario()
   ::Eventos()
   ::Rodape()

   HPDF_SaveToFile( ::oPdf, cFilePDF )
   HPDF_Free( ::oPdf )

   RETURN .T.

METHOD Cabecalho() CLASS hbnfeDaEvento

   ::DrawBox( 30, ::nLinhaPDF -106,   535,  110, ::nLarguraBox )    // Quadro Cabeçalho

   // logo/dados empresa

   ::DrawBox( 290, ::nLinhaPDF -106,  275,  110, ::nLarguraBox )    // Quadro CC-e, Chave de Acesso e Codigo de Barras
   ::DrawTexto( 30, ::nLinhaPdf + 2,     274, Nil, "IDENTIFICAÇÃO DO EMITENTE", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 6 )
   // alert( 'nLogoStyle: ' + ::nLogoStyle +'; LAYOUT_LOGO_ESQUERDA: ' + LAYOUT_LOGO_ESQUERDA )
   IF ::cLogoFile == NIL .OR. Empty( ::cLogoFile )
      ::DrawTexto( 30, ::nLinhaPDF -6,  289, Nil, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 14 )
      ::DrawTexto( 30, ::nLinhaPDF -20,  289, Nil, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 2 ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 14 )
      ::DrawTexto( 30, ::nLinhaPDF -42,  289, Nil, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )
      ::DrawTexto( 30, ::nLinhaPDF -52,  289, Nil, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )
      ::DrawTexto( 30, ::nLinhaPDF -62,  289, Nil, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )
      ::DrawTexto( 30, ::nLinhaPDF -72,  289, Nil, iif( Empty( ::cTelefoneEmitente ), "", "FONE: " + ::cTelefoneEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )
      ::DrawTexto( 30, ::nLinhaPDF -82,  289, Nil, Trim( ::cSiteEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )
      ::DrawTexto( 30, ::nLinhaPDF -92,  289, Nil, Trim( ::cEmailEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )
   ELSE
      IF ::nLogoStyle = LAYOUT_LOGO_EXPANDIDO
         ::DrawJPEGImage( ::cLogoFile, 55, ::nLinhaPdf - ( 82 + 18 ), 218, 92 )
      ELSEIF ::nLogoStyle = LAYOUT_LOGO_ESQUERDA
         ::DrawJPEGImage( ::cLogoFile, 36, ::nLinhaPdf - ( 62 + 18 ), 62, 62 )
         ::DrawTexto( 100, ::nLinhaPDF -6,  289, Nil, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )
         ::DrawTexto( 100, ::nLinhaPDF -20, 289, Nil, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 2 ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )
         ::DrawTexto( 100, ::nLinhaPDF -42,  289, Nil, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
         ::DrawTexto( 100, ::nLinhaPDF -52,  289, Nil, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
         ::DrawTexto( 100, ::nLinhaPDF -62,  289, Nil, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
         ::DrawTexto( 100, ::nLinhaPDF -72,  289, Nil, iif( Empty( ::cTelefoneEmitente ), "", "FONE: " + ::cTelefoneEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
         ::DrawTexto( 100, ::nLinhaPDF -82,  289, Nil, Trim( ::cSiteEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
         ::DrawTexto( 100, ::nLinhaPDF -92,  289, Nil, Trim( ::cEmailEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )

      ELSEIF ::nLogoStyle = LAYOUT_LOGO_DIREITA
         ::DrawJPEGImage( ::cLogoFile, 220, ::nLinhaPdf - ( 62 + 18 ), 62, 62 )
         ::DrawTexto( 30, ::nLinhaPDF -6,  218, Nil, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 1 ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )
         ::DrawTexto( 30, ::nLinhaPDF -20, 218, Nil, Trim( MemoLine( ::aEmit[ "xNome" ], 30, 2 ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )
         ::DrawTexto( 30, ::nLinhaPDF -42,  218, Nil, ::aEmit[ "xLgr" ] + " " + ::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
         ::DrawTexto( 30, ::nLinhaPDF -52,  218, Nil, ::aEmit[ "xBairro" ] + " - " + Transform( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
         ::DrawTexto( 30, ::nLinhaPDF -62,  218, Nil, ::aEmit[ "xMun" ] + " - " + ::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
         ::DrawTexto( 30, ::nLinhaPDF -72,  218, Nil, iif( Empty( ::cTelefoneEmitente ), "", "FONE: " + ::cTelefoneEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
         ::DrawTexto( 30, ::nLinhaPDF -82,  218, Nil, Trim( ::cSiteEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
         ::DrawTexto( 30, ::nLinhaPDF -92,  218, Nil, Trim( ::cEmailEmitente ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
      ENDIF
   ENDIF

   /*
   IF EMPTY( ::cLogoFile )
   ::DrawTexto( 71, ::nLinhaPdf   , 399, Nil, "IDENTIFICAÇÃO DO EMITENTE" , HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   ::DrawTexto( 71, ::nLinhaPDF - 6 , 399, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ],30,1)) , HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
   ::DrawTexto( 71, ::nLinhaPDF - 18, 399, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ],30,2)), HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
   ::DrawTexto( 71, ::nLinhaPDF - 30, 399, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 71, ::nLinhaPDF - 38, 399, Nil, ::aEmit[ "xBairro" ]+" - "+ Transform( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 71, ::nLinhaPDF - 46, 399, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 71, ::nLinhaPDF - 54, 399, Nil, IF( Empty(::cTelefoneEmitente),"", "FONE: "+::cTelefoneEmitente), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 71, ::nLinhaPDF - 62, 399, Nil, TRIM(::cSiteEmitente), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 71, ::nLinhaPDF - 70, 399, Nil, TRIM(::cEmailEmitente), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ELSE
   IF ::nLogoStyle = LAYOUT_LOGO_EXPANDIDO
   ::DrawJPEGImage( ::cLogoFile, 6, ::nLinhaPdf - (72+6), 328, 72 )
   ELSEIF ::nLogoStyle = LAYOUT_LOGO_ESQUERDA
   ::DrawJPEGImage( ::cLogoFile, 71, ::nLinhaPdf - (72+6), 62, 72 )
   ::DrawTexto( 135, ::nLinhaPDF - 6 , 399, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ],30,1)) , HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
   ::DrawTexto( 135, ::nLinhaPDF - 18, 399, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ],30,2)), HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
   ::DrawTexto( 135, ::nLinhaPDF - 30, 399, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 135, ::nLinhaPDF - 38, 399, Nil, ::aEmit[ "xBairro" ]+" - "+ Transform( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 135, ::nLinhaPDF - 46, 399, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 135, ::nLinhaPDF - 54, 399, Nil, IF( Empty(::cTelefoneEmitente),"","FONE: "+::cTelefoneEmitente), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 135, ::nLinhaPDF - 62, 399, Nil, TRIM(::cSiteEmitente), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 135, ::nLinhaPDF - 70, 399, Nil, TRIM(::cEmailEmitente), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ELSEIF ::nLogoStyle = LAYOUT_LOGO_DIREITA
   ::DrawJPEGImage( ::cLogoFile, 337, ::nLinhaPdf - (72+6), 62, 72 )
   ::DrawTexto( 71, ::nLinhaPDF - 6 , 335, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ],30,1)) , HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
   ::DrawTexto( 71, ::nLinhaPDF - 18, 335, Nil, TRIM( MemoLine( ::aEmit[ "xNome" ],30,2)), HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
   ::DrawTexto( 71, ::nLinhaPDF - 30, 335, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 71, ::nLinhaPDF - 38, 335, Nil, ::aEmit[ "xBairro" ]+" - "+ Transform( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 71, ::nLinhaPDF - 46, 335, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 71, ::nLinhaPDF - 54, 335, Nil, IF( Empty(::cTelefoneEmitente),"","FONE: "+::cTelefoneEmitente), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 71, ::nLinhaPDF - 62, 335, Nil, TRIM(::cSiteEmitente), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 71, ::nLinhaPDF - 70, 335, Nil, TRIM(::cEmailEmitente), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ENDIF
   ENDIF
   */

   IF ::aInfEvento[ "tpEvento" ] == "110110"
      ::DrawTexto( 292, ::nLinhaPDF -2, 554, Nil, "CC-e", HPDF_TALIGN_CENTER, ::oPDFFontBold, 18 )
      ::DrawTexto( 296, ::nLinhaPDF -22, 554, Nil, "CARTA DE CORREÇÃO ELETRÔNICA", HPDF_TALIGN_CENTER, ::oPDFFontBold, 14 )
   ELSE
      ::DrawTexto( 292, ::nLinhaPDF -2, 554, Nil, "EVENTO", HPDF_TALIGN_CENTER, ::oPDFFontBold, 18 )
      DO CASE
      CASE ::aInfEvento[ "tpEvento" ] == "110111"
         ::DrawTexto( 296, ::nLinhaPDF -22, 554, Nil, "CANCELAMENTO", HPDF_TALIGN_CENTER, ::oPDFFontBold, 14 )
      OTHERWISE
         ::DrawTexto( 296, ::nLinhaPDF -22, 554, Nil, "EVENTO " + ::aInfEvento[ "tpEvento" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 14 )
      ENDCASE
   ENDIF

   // chave de acesso
   ::DrawBox( 290, ::nLinhaPDF -61,  275,  20, ::nLarguraBox )
   ::DrawTexto( 291, ::nLinhaPDF -42, 534, Nil, "CHAVE DE ACESSO", HPDF_TALIGN_LEFT, ::oPDFFontBold, 6 )
   IF ::cFonteEvento == "Times"
      ::DrawTexto( 292, ::nLinhaPDF -49, 554, Nil, Transform( ::cChaveEvento, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )
   ELSE
      ::DrawTexto( 292, ::nLinhaPDF -50, 554, Nil, Transform( ::cChaveEvento, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   ENDIF

   // codigo barras
#ifdef __XHARBOUR__
   ::DrawTexto( 291, ::nLinhaPDF -65, 555, Nil, ::xHarbourCode128c( ::cChaveNFe ), HPDF_TALIGN_CENTER, Nil, ::cFonteCode128F, 18 )
#else
   ::DrawBarcode128( ::cChaveEvento, 300, ::nLinhaPDF -100, 0.9, 30 )
#endif

   ::nLinhaPdf -= 106

   // CNPJ
   ::DrawBox( 30, ::nLinhaPDF -20,   535,  20, ::nLarguraBox )    // Quadro CNPJ/INSCRIÇÃO
   ::DrawTexto( 32, ::nLinhaPdf,      160, Nil, "CNPJ", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   ::DrawTexto( 31, ::nLinhaPDF -6,    160, Nil, Transform( ::aEmit[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )

   // I.E.
   ::DrawBox( 160, ::nLinhaPDF -20,  130,  20, ::nLarguraBox )    // Quadro INSCRIÇÃO
   ::DrawTexto( 162, ::nLinhaPdf,     290, Nil, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   ::DrawTexto( 161, ::nLinhaPDF -6,   290, Nil, ::aEmit[ "IE" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )

   // MODELO DO DOCUMENTO (NF-E)
   ::DrawTexto( 291, ::nLinhaPdf,     340, Nil, "MODELO", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 6 )
   ::DrawTexto( 291, ::nLinhaPDF -6,   340, Nil, ::aIde[ "mod" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )

   // SERIE DOCUMENTO (NF-E)
   ::DrawBox( 340, ::nLinhaPDF -20,   50,  20, ::nLarguraBox )
   ::DrawTexto( 341, ::nLinhaPdf,     390, Nil, "SERIE", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 6 )
   ::DrawTexto( 341, ::nLinhaPDF -6,   390, Nil, ::aIde[ "serie" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )

   IF DfeModFis( ::cChaveEvento ) == "57" // At( "retEventoCTe",::cXmlEvento) > 0
      // NUMERO CTE
      ::DrawTexto( 391, ::nLinhaPdf,     480, Nil, "NUMERO DO CT-e", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 6 )
      ::DrawTexto( 391, ::nLinhaPDF -6,   480, Nil, SubStr( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), 1, 3 ) + "." + SubStr( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), 4, 3 ) + "." + SubStr( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), 7, 3 ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )
   ELSE
      // NUMERO NFE
      ::DrawTexto( 391, ::nLinhaPdf,     480, Nil, "NUMERO DA NF-e", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 6 )
      ::DrawTexto( 391, ::nLinhaPDF -6,   480, Nil, SubStr( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), 1, 3 ) + "." + SubStr( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), 4, 3 ) + "." + SubStr( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), 7, 3 ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )
   ENDIF
   // DATA DE EMISSAO DA NFE
   ::DrawBox( 480, ::nLinhaPDF -20,   85,  20, ::nLarguraBox )
   ::DrawTexto( 481, ::nLinhaPdf,     565, Nil, "DATA DE EMISSÃO", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 6 )
   ::DrawTexto( 481, ::nLinhaPDF -6,   565, Nil, SubStr( ::aIde[ "dhEmi" ], 9, 2 ) + '/' + SubStr( ::aIde[ "dhEmi" ], 6, 2 ) + '/' + Left( ::aIde[ "dhEmi" ], 4 ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )

   RETURN NIL

METHOD Destinatario() CLASS hbnfeDaEvento

   // REMETENTE / DESTINATARIO

   ::nLinhaPdf -= 24

   IF At( "retEventoCTe", ::cXmlEvento ) > 0  // runner
      ::DrawTexto( 30, ::nLinhaPdf, 565, Nil, "DESTINATÁRIO", HPDF_TALIGN_LEFT, ::oPDFFontBold, 6 )
   ELSE
      ::DrawTexto( 30, ::nLinhaPdf, 565, Nil, "DESTINATÁRIO/REMETENTE", HPDF_TALIGN_LEFT, ::oPDFFontBold, 6 )
   ENDIF
   ::nLinhaPdf -= 9
   // RAZAO SOCIAL
   ::DrawBox( 30, ::nLinhaPDF -20, 425, 20, ::nLarguraBox )
   ::DrawTexto( 32, ::nLinhaPdf, 444, Nil, "NOME / RAZÃO SOCIAL", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   ::DrawTexto( 32, ::nLinhaPDF -6, 444, Nil, ::aDest[ "xNome" ], HPDF_TALIGN_LEFT, ::oPDFFontBold, 11 )
   // CNPJ/CPF
   ::DrawBox( 455, ::nLinhaPDF -20, 110, 20, ::nLarguraBox )
   ::DrawTexto( 457, ::nLinhaPdf, 565, Nil, "CNPJ/CPF", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   IF ! Empty( ::aDest[ "CNPJ" ] )
      ::DrawTexto( 457, ::nLinhaPDF -6, 565, Nil, Transform( ::aDest[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )
   ELSE
      IF ::aDest[ "CPF" ] <> Nil
         ::DrawTexto( 457, ::nLinhaPDF -6, 565, Nil, Transform( ::aDest[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )
      ENDIF
   ENDIF

   ::nLinhaPdf -= 20

   // ENDEREÇO
   ::DrawBox( 30, ::nLinhaPDF -20, 270, 20, ::nLarguraBox )
   ::DrawTexto( 32, ::nLinhaPdf, 298, Nil, "ENDEREÇO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   ::DrawTexto( 32, ::nLinhaPDF -6, 298, Nil, ::aDest[ "xLgr" ] + " " + ::aDest[ "nro" ], HPDF_TALIGN_LEFT, ::oPDFFontBold, 9 )
   // BAIRRO
   ::DrawBox( 300, ::nLinhaPDF -20, 195, 20, ::nLarguraBox )
   ::DrawTexto( 302, ::nLinhaPdf, 494, Nil, "BAIRRO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   ::DrawTexto( 302, ::nLinhaPDF -6, 494, Nil, ::aDest[ "xBairro" ], HPDF_TALIGN_LEFT, ::oPDFFontBold, 11 )
   // CEP
   ::DrawBox( 495, ::nLinhaPDF -20, 70, 20, ::nLarguraBox )
   ::DrawTexto( 497, ::nLinhaPdf, 564, Nil, "C.E.P.", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   ::DrawTexto( 497, ::nLinhaPDF -6, 564, Nil, Transform( ::aDest[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )

   ::nLinhaPdf -= 20

   // MUNICIPIO
   ::DrawBox( 30, ::nLinhaPDF -20, 535, 20, ::nLarguraBox )
   ::DrawTexto( 32, ::nLinhaPdf, 284, Nil, "MUNICIPIO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   ::DrawTexto( 32, ::nLinhaPDF -6, 284, Nil, ::aDest[ "xMun" ], HPDF_TALIGN_LEFT, ::oPDFFontBold, 11 )
   // FONE/FAX
   ::DrawBox( 285, ::nLinhaPDF -20, 140, 20, ::nLarguraBox )
   ::DrawTexto( 287, ::nLinhaPdf, 424, Nil, "FONE/FAX", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   ::DrawTexto( 287, ::nLinhaPDF -6, 424, Nil, ::FormataTelefone( ::aDest[ "fone" ] ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )
   // ESTADO
   ::DrawTexto( 427, ::nLinhaPdf, 454, Nil, "ESTADO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   ::DrawTexto( 427, ::nLinhaPDF -6, 454, Nil, ::aDest[ "UF" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )
   // INSC. EST.
   ::DrawBox( 455, ::nLinhaPDF -20, 110, 20, ::nLarguraBox )
   ::DrawTexto( 457, ::nLinhaPdf, 564, Nil, "INSCRIÇÃO ESTADUAL", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   ::DrawTexto( 457, ::nLinhaPDF -6, 564, Nil, ::aDest[ "IE" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )

   ::nLinhaPdf -= 20

   RETURN NIL

METHOD Eventos() CLASS hbnfeDaEvento

   LOCAL cDataHoraReg, cMemo, nCont, nCompLinha, oElement, cGrupo, cCampo, cValor

   // Eventos
   ::DrawTexto( 30, ::nLinhaPDF -4, 565, Nil, "EVENTOS", HPDF_TALIGN_LEFT, ::oPDFFontBold, 6 )

   ::nLinhaPdf -= 12

   ::DrawBox( 30, ::nLinhaPDF -20,   535,  20, ::nLarguraBox )

   // ORGAO EMITENTE
   ::DrawTexto( 32, ::nLinhaPdf,   90, Nil, "ORGÃO", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 6 )
   ::DrawTexto( 32, ::nLinhaPDF -6, 90, Nil, ::aInfEvento[ "cOrgao" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )

   // TIPO DE EVENTO'
   ::DrawBox( 90, ::nLinhaPDF -20,   60,  20, ::nLarguraBox )
   ::DrawTexto( 92, ::nLinhaPdf,     149, Nil, "TIPO EVENTO", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 6 )
   ::DrawTexto( 92, ::nLinhaPDF -6,   149, Nil, ::aInfEvento[ "tpEvento" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )

   // SEQUENCIA  EVENTO
   ::DrawTexto( 152, ::nLinhaPdf,   209, Nil, "SEQ. EVENTO", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 6 )
   ::DrawTexto( 152, ::nLinhaPDF -6, 209, Nil, ::aInfEvento[ "nSeqEvento" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )

   // VERSÃO DO EVENTO
   ::DrawBox( 210, ::nLinhaPDF -20,   60,  20, ::nLarguraBox )
   ::DrawTexto( 212, ::nLinhaPdf,      269, Nil, "VERSÃO EVENTO", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 6 )
   ::DrawTexto( 212, ::nLinhaPDF -6,    269, Nil, ::aInfEvento[ "verEvento" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )

   // DATA E HORA DO REGISTRO
   ::DrawTexto( 272, ::nLinhaPdf,  429, Nil, "DATA DO REGISTRO", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 6 )
   cDataHoraReg := SubStr( ::aInfEvento[ "dhRegEvento" ], 9, 2 ) + '/'
   cDataHoraReg += SubStr( ::aInfEvento[ "dhRegEvento" ], 6, 2 ) + '/'
   cDataHoraReg += Left( ::aInfEvento[ "dhRegEvento" ], 4 ) + '  '
   cDataHoraReg += SubStr( ::aInfEvento[ "dhRegEvento" ], 12, 8 )
   ::DrawTexto( 272, ::nLinhaPDF -6, 429, Nil, cDataHoraReg, HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )

   // NUMERO DO PROTOCOLO
   ::DrawBox( 430, ::nLinhaPDF -20,    135,  20, ::nLarguraBox )
   ::DrawTexto( 432, ::nLinhaPdf,       564, Nil, "NUMERO DO PROTOCOLO", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 6 )
   ::DrawTexto( 432, ::nLinhaPDF -6,     564, Nil, ::aInfEvento[ "nProt" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )

   ::nLinhaPdf -= 20

   // STATUS DO EVENTO
   ::DrawBox( 30, ::nLinhaPDF -20,  535,  20, ::nLarguraBox )
   ::DrawTexto( 32, ::nLinhaPdf,     564, Nil, "STATUS DO EVENTO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 6 )
   ::DrawTexto( 32, ::nLinhaPDF -6,    60, Nil, ::aInfEvento[ "cStat" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 11 )
   ::DrawTexto( 62, ::nLinhaPDF -6,    564, Nil, ::aInfEvento[ "xMotivo" ], HPDF_TALIGN_LEFT, ::oPDFFontBold, 11 )

   ::nLinhaPdf -= 25

   // Correções

   ::DrawTexto( 30, ::nLinhaPdf, 565, Nil, "CORREÇÕES", HPDF_TALIGN_LEFT, ::oPDFFontBold, 6 )
   ::DrawBox( 30, ::nLinhaPDF -188,   535,  180, ::nLarguraBox )

   ::nLinhaPdf -= 12

   IF Len( ::aCorrecoes ) > 0

      FOR EACH oElement IN ::aCorrecoes
         cGrupo := XmlNode( oElement, 'grupoAlterado' )
         cCampo := XmlNode( oElement, 'campoAlterado' )
         cValor := XmlNode( oElement, 'valorAlterado' )
         ::DrawTexto( 38, ::nLinhaPdf,564, Nil, 'Alterado = Grupo : '+cGrupo+' - Campo : '+cCampo+' - Valor : '+cValor , HPDF_TALIGN_LEFT, ::oPdfFontCorrecoes, 11 )
         ::nLinhaPdf -= 12
      NEXT
      FOR nCont = ( Len( ::aCorrecoes ) + 1 ) TO 14
         ::nLinhaPdf -= 12
      NEXT

   ELSE

      cMemo := ::aInfEvento[ "xCorrecao" ]

      cMemo := StrTran( cMemo, ";", Chr( 13 ) + Chr( 10 ) )
      nCompLinha := 77
      IF ::cFonteCorrecoes == "Helvetica"
         nCompLinha := 75
      ENDIF

      FOR nCont = 1 TO MLCount( cMemo, nCompLinha )
         ::DrawTexto( 38, ::nLinhaPdf,564, Nil, Upper( Trim( MemoLine( cMemo, nCompLinha, nCont ) ) ), HPDF_TALIGN_LEFT, ::oPdfFontCorrecoes, 11 )
         ::nLinhaPdf -= 12
      NEXT

      FOR nCont = ( MLCount( cMemo, nCompLinha ) + 1 ) TO 14
         ::nLinhaPdf -= 12
      NEXT
   ENDIF

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
   ::DrawTexto( 30, ::nLinhaPdf, 535, Nil, "CONDIÇÃO DE USO", HPDF_TALIGN_LEFT, ::oPDFFontBold, 6 )
   IF At("retEventoCTe",::cXmlEvento) > 0  // runner
      ::DrawBox( 30, ::nLinhaPDF -126 ,   535, 118 , ::nLarguraBox )
      cTextoCond := 'A Carta de Correção é disciplinada pelo Art. 58-B do CONVÊNIO/SINIEF 06/89: Fica permitida a'
      ::DrawTexto( 34, ::nLinhaPdf -12,564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, nTamFonte )
      cTextoCond := 'utilização  de carta  de  correção, para  regularização  de  erro  ocorrido  na  emissão  de'
      ::DrawTexto( 34, ::nLinhaPdf -24,564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, nTamFonte )
      cTextoCond := 'documentos  fiscais  relativos à prestação de serviço  de  transporte, desde  que o erro não'
      ::DrawTexto( 34, ::nLinhaPdf -36,564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, nTamFonte )
      cTextoCond := 'esteja relacionado com :'
      ::DrawTexto( 34, ::nLinhaPdf -48,564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, nTamFonte )
      cTextoCond := 'I   - As variáveis que determinam o valor  do imposto  tais como: base de cálculo, alíquota,'
      ::DrawTexto( 34, ::nLinhaPdf -60,564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, nTamFonte )
      cTextoCond := '      diferença de preço, quantidade, da prestação;'
      ::DrawTexto( 34, ::nLinhaPdf -72,564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, nTamFonte )
      cTextoCond := 'II  - A correção de dados cadastrais que  implique mudança do emitente,  tomador,  remetente'
      ::DrawTexto( 34, ::nLinhaPdf -84,564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, nTamFonte )
      cTextoCond := '      ou do destinatário;'
      ::DrawTexto( 34, ::nLinhaPdf -96,564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, nTamFonte )
      cTextoCond := 'III - A data de emissão ou de saída.'
      ::DrawTexto( 34, ::nLinhaPdf -108,564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, nTamFonte )
      // Observações:
      ::nLinhaPdf -= 124
   ELSE
      ::DrawBox( 30, ::nLinhaPDF -102,   535,  94, ::nLarguraBox )
      cTextoCond := 'A Carta de Correção é disciplinada pelo § 1º-A do art. 7º do Convênio S/N, de 15 de dezembro de'
      ::DrawTexto( 34, ::nLinhaPdf -12,564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, nTamFonte )
      cTextoCond := '1970,  e pode ser utilizada para regularização de erro ocorrido na emissão de documento fiscal,'
      ::DrawTexto( 34, ::nLinhaPdf -24,564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, nTamFonte )
      cTextoCond := 'desde que o erro não esteja relacionado com:'
      ::DrawTexto( 34, ::nLinhaPdf -36,564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, nTamFonte )
      cTextoCond := 'I   - As variáveis que determinam o valor do imposto tais como:  Base de cálculo, alíquota,'
      ::DrawTexto( 34, ::nLinhaPdf -48,564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, nTamFonte )
      cTextoCond := '      diferença de preço, quantidade, valor da operação ou da prestação;'
      ::DrawTexto( 34, ::nLinhaPdf -60,564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, nTamFonte )
      cTextoCond := 'II  - A correção de dados cadastrais que implique mudança do remetente ou do destinatário;'
      ::DrawTexto( 34, ::nLinhaPdf -72,564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, nTamFonte )
      cTextoCond := 'III - A data de emissão ou de saída.'
      ::DrawTexto( 34, ::nLinhaPdf -84,564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, nTamFonte )
      // Observações:
      ::nLinhaPdf -= 100
   ENDIF

   IF ::cFonteEvento == "Times"
      cTextoCond := 'Para evitar-se  qualquer  sansão fiscal, solicitamos acusarem o recebimento  desta,  na'
      ::DrawTexto( 34, ::nLinhaPDF -12, 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 15 )
      cTextoCond := 'cópia que acompanha, devendo  a  via  de  V.S(as) ficar juntamente com  a nota fiscal'
      ::DrawTexto( 34, ::nLinhaPDF -26, 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 15 )
      cTextoCond := 'em questão.'
      ::DrawTexto( 34, ::nLinhaPDF -40, 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 15 )
   ELSEIF ::cFonteEvento == "Helvetica"
      cTextoCond := 'Para evitar-se qualquer sansão fiscal, solicitamos acusarem  o  recebimento desta, '
      ::DrawTexto( 34, ::nLinhaPDF -12, 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 14 )
      cTextoCond := 'na cópia que acompanha, devendo a via  de  V.S(as) ficar juntamente com  a  nota '
      ::DrawTexto( 34, ::nLinhaPDF -26, 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 14 )
      cTextoCond := 'fiscal em questão.'
      ::DrawTexto( 34, ::nLinhaPDF -40, 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 14 )
   ELSE
      cTextoCond := 'Para evitar-se qualquer sansão fiscal, solicitamos acusarem o recebimento desta,'
      ::DrawTexto( 34, ::nLinhaPDF -12, 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 11 )
      cTextoCond := 'na cópia que acompanha, devendo a via  de  V.S(as) ficar juntamente com  a nota'
      ::DrawTexto( 34, ::nLinhaPDF -26, 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 11 )
      cTextoCond := 'fiscal em questão.'
      ::DrawTexto( 34, ::nLinhaPDF -40, 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 11 )
   ENDIF

   // Observações:

   ::nLinhaPdf -= 100

   ::DrawLine( 34, ::nLinhaPDF -12, 270, ::nLinhaPDF -12, ::nLarguraBox )

   ::DrawTexto( 30,  ::nLinhaPDF -14, 284, Nil, 'Local e data', HPDF_TALIGN_CENTER, ::oPDFFontNormal, 9 )
   ::DrawTexto( 304, ::nLinhaPDF -14, 574, Nil, 'Sem outro motivo para o momento subscrevemos-nos.', HPDF_TALIGN_LEFT, ::oPDFFontNormal, 9 )
   ::DrawTexto( 304, ::nLinhaPDF -24, 574, Nil, 'Atenciosamente.', HPDF_TALIGN_LEFT, ::oPDFFontNormal, 9 )

   ::DrawLine( 34,  ::nLinhaPDF -92, 270, ::nLinhaPDF -92, ::nLarguraBox )
   ::DrawLine( 564, ::nLinhaPDF -92, 300, ::nLinhaPDF -92, ::nLarguraBox )

   ::DrawTexto( 30,  ::nLinhaPDF -94, 284, Nil,  Trim( MemoLine( ::aDest[ "xNome" ], 40, 1 ) ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 9 )
   ::DrawTexto( 30,  ::nLinhaPDF -108, 284, Nil, Trim( MemoLine( ::aDest[ "xNome" ], 40, 2 ) ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 9 )
   ::DrawTexto( 300, ::nLinhaPDF -94,  574, Nil, Trim( MemoLine( ::aEmit[ "xNome" ], 40, 1 ) ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 9 )
   ::DrawTexto( 300, ::nLinhaPDF -108, 574, Nil, Trim( MemoLine( ::aEmit[ "xNome" ], 40, 2 ) ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 9 )

   ::Desenvolvedor()

   RETURN NIL
