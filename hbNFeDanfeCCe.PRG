/*
HBNFEDANFECCE - Funcoes e Classes Relativas a Impressao da Carta de Correção
Usado como Base o Projeto Open ACBR e Sites sobre XML, Certificados e Afins
https://github.com/fernandoathayde/hbnfe
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

CLASS hbNFeDanfeCCe

   METHOD execute()
   METHOD buscaDadosXML()
   METHOD geraCCePDF()
   METHOD cabecalho()
   METHOD destinatario()
   METHOD eventos()
   METHOD rodape()

   VAR cTelefoneEmitente INIT ""
   VAR cSiteEmitente     INIT ""
   VAR cEmailEmitente    INIT ""
   VAR cArquivoNFeXML
   VAR cArquivoCCeXML
   VAR cXMLNFe
   VAR cXMLCCe
   VAR cChaveNFe
   VAR cChaveCCe

   VAR aInfCCe
   VAR aIde
   VAR aEmit
   VAR aDest

   VAR cFonteCCe
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
   VAR lLaser INIT .T.
   VAR lPaisagem
   VAR cLogoFile
   VAR nLogoStyle // 1-esquerda, 2-direita, 3-expandido

   VAR cFile
   VAR aRetorno

   ENDCLASS

METHOD execute() CLASS hbNFeDanfeCCe

   IF ::lLaser <> Nil
      ::lLaser := .T.
   ENDIF
   IF ::cFonteCCe = Nil
      ::cFonteCCe := 'Times'
   ENDIF

   IF ::cFonteCorrecoes = Nil
      ::cFonteCorrecoes := 'Courier'
   ENDIF

   ::aRetorno := hb_Hash()

   IF !FILE(::cArquivoCCeXML)
      ::aRetorno[ 'OK' ] := .F.
      ::aRetorno[ 'MsgErro' ] := 'Arquivo não encontrado ! '+::cArquivoCCeXML
      RETURN(::aRetorno)
   ENDIF
   ::cXMLCCe := MEMOREAD( ::cArquivoCCeXML )
   ::cChaveCCe := SUBS( ::cXMLCCe, AT('Id=',::cXMLCCe)+3+9,44)

   IF !FILE(::cArquivoNFeXML)
      ::aRetorno[ 'OK' ] := .F.
      ::aRetorno[ 'MsgErro' ] := 'Arquivo não encontrado ! '+::cArquivoNFeXML
      RETURN(::aRetorno)
   ENDIF
   ::cXMLNFe := MEMOREAD( ::cArquivoNFeXML )
   ::cChaveNFe := SUBS( ::cXMLNFe, AT('Id=',::cXMLNFe)+3+4,44)

   IF ::cChaveCCe != ::cChaveNFe
      ::aRetorno[ 'OK' ] := .F.
      ::aRetorno[ 'MsgErro' ] := 'Arquivos XML com Chaves diferentes...! ' + ';Chave NF-e: ' + ::cChaveNFe + ';Chave CC-e: ' + ::cChaveCCe
      RETURN(::aRetorno)
   ENDIF

   IF !::buscaDadosXML()
      RETURN(::aRetorno)
   ENDIF

   IF !::geraCCePDF()
      ::aRetorno[ 'OK' ] := .F.
      ::aRetorno[ 'MsgErro' ] := 'Problema ao gerar o PDF da Carta de Correção !'
      RETURN(::aRetorno)
   ENDIF
   ::aRetorno[ 'OK' ] := .T.

   RETURN(::aRetorno)

METHOD buscaDadosXML() CLASS hbNFeDanfeCCe

   LOCAL cInfCCe, cInfCCeRet, cIde, cEmit, cDest

   cInfCCe := hbNFe_PegaDadosXML("infEvento", ::cXMLCCe, "infEvento" )
   ::aInfCCe := hb_Hash()
   ::aInfCCe[ "cOrgao" ] := hbNFe_PegaDadosXML("cOrgao", cInfCCe )
   ::aInfCCe[ "tpEvento" ] := hbNFe_PegaDadosXML("tpEvento", cInfCCe )
   ::aInfCCe[ "nSeqEvento" ] := hbNFe_PegaDadosXML("nSeqEvento", cInfCCe )
   ::aInfCCe[ "verEvento" ] := hbNFe_PegaDadosXML("verEvento", cInfCCe )
   ::aInfCCe[ "xCorrecao" ] := hbNFe_PegaDadosXML("xCorrecao", cInfCCe )

   cInfCCeRet := hbNFe_PegaDadosXML("retEvento", ::cXMLCCe, "retEvento" )
   ::aInfCCe[ "cStat" ] := hbNFe_PegaDadosXML("cStat", cInfCCeRet )
   ::aInfCCe[ "xMotivo" ] := hbNFe_PegaDadosXML("xMotivo", cInfCCeRet )
   ::aInfCCe[ "dhRegEvento" ] := hbNFe_PegaDadosXML("dhRegEvento", cInfCCeRet )
   ::aInfCCe[ "nProt" ] := hbNFe_PegaDadosXML("nProt", cInfCCeRet )

   cIde := hbNFe_PegaDadosXML("ide", ::cXMLNFe )
   ::aIde := hb_Hash()
   ::aIde[ "mod" ] := hbNFe_PegaDadosXML("mod", cIde )
   ::aIde[ "serie" ] := hbNFe_PegaDadosXML("serie", cIde )
   ::aIde[ "nNF" ] := hbNFe_PegaDadosXML("nNF", cIde )
   ::aIde[ "dhEmi" ] := hbNFe_PegaDadosXML("dhEmi", cIde )

   cEmit := hbNFe_PegaDadosXML("emit", ::cXMLNFe )
   ::aEmit := hb_Hash()
   ::aEmit[ "CNPJ" ] := hbNFe_PegaDadosXML("CNPJ", cEmit )
   ::aEmit[ "xNome" ] := XmlToString( hbNFe_PegaDadosXML("xNome", cEmit ) )
   ::aEmit[ "xFant" ] := hbNFe_PegaDadosXML("xFant", cEmit )
   ::aEmit[ "xLgr" ] := hbNFe_PegaDadosXML("xLgr", cEmit )
   ::aEmit[ "nro" ] := hbNFe_PegaDadosXML("nro", cEmit )
   ::aEmit[ "xBairro" ] := hbNFe_PegaDadosXML("xBairro", cEmit )
   ::aEmit[ "cMun" ] := hbNFe_PegaDadosXML("cMun", cEmit )
   ::aEmit[ "xMun" ] := hbNFe_PegaDadosXML("xMun", cEmit )
   ::aEmit[ "UF" ] := hbNFe_PegaDadosXML("UF", cEmit )
   ::aEmit[ "CEP" ] := hbNFe_PegaDadosXML("CEP", cEmit )
   ::aEmit[ "fone" ] := hbNFe_PegaDadosXML("fone", cEmit ) // NFE 2.0
   ::aEmit[ "IE" ] := hbNFe_PegaDadosXML("IE", cEmit )

   TRY
      ::cTelefoneEmitente := TRANSF(SoNumeros(ALLTRIM(hbNFe_PegaDadosXML("fone", cEmit ))),"@R (99) 9999-9999")
   CATCH
      ::cTelefoneEmitente := ""
   END

   cDest := hbNFe_PegaDadosXML("dest", ::cXMLNFe )
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
   TRY
      ::aDest[ "fone" ] := IF(LEN(hbNFe_PegaDadosXML("fone", cDest ))<=8,"00"+hbNFe_PegaDadosXML("fone", cDest ),hbNFe_PegaDadosXML("fone", cDest ))
   CATCH
      ::aDest[ "fone" ] := ''
   END
   ::aDest[ "IE" ] := hbNFe_PegaDadosXML("IE", cDest )

   RETURN(.T.)

METHOD geraCCePDF() CLASS hbNFeDanfeCCe

   LOCAL nItem, nIdes, nItensNF, nItens1Folha
   LOCAL nRadiano, nAltura, nLargura, nAngulo

   // criacao objeto pdf
   ::oPdf := HPDF_New()
   IF ::oPdf == NIL
      ::aRetorno[ 'OK' ] := .F.
      ::aRetorno[ 'MsgErro' ] := 'Falha da criação do objeto PDF da Carta de Correção!'
      RETURN(.F.)
   ENDIF

   /* set compression mode */
   HPDF_SetCompressionMode( ::oPdf, HPDF_COMP_ALL )

   /* setando fonte */
   IF ::cFonteCCe == "Times"
      ::oPdfFontCabecalho := HPDF_GetFont( ::oPdf, "Times-Roman", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Times-Bold", "CP1252" )
    ELSEIF ::cFonteCCe == "Helvetica"
      ::oPdfFontCabecalho     := HPDF_GetFont( ::oPdf, "Helvetica", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Helvetica-Bold", "CP1252" )
    ELSEIF ::cFonteCCe == "Courier-Oblique"
      ::oPdfFontCabecalho     := HPDF_GetFont( ::oPdf, "Courier-Oblique", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Courier-BoldOblique", "CP1252" )
    ELSE
      ::oPdfFontCabecalho     := HPDF_GetFont( ::oPdf, "Courier", "CP1252" )
      ::oPdfFontCabecalhoBold := HPDF_GetFont( ::oPdf, "Courier-Bold", "CP1252" )
   ENDIF

   IF ::cFonteCorrecoes == "Times"
      ::oPdfFontCorrecoes := HPDF_GetFont( ::oPdf, "Times-Roman", "CP1252" )
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
     if !file('fontes\Code128bWinLarge.afm') .or. !file('fontes\Code128bWinLarge.pfb')
        ::aRetorno[ 'OK' ] := .F.
        ::aRetorno[ 'MsgErro' ] := 'Arquivos: fontes\Code128bWinLarge, nao encontrados...!'
        RETURN(.F.)
     endif
     ::cFonteCode128 := HPDF_LoadType1FontFromFile(::oPdf, 'fontes\Code128bWinLarge.afm', 'fontes\Code128bWinLarge.pfb')   && Code 128
     ::cFonteCode128F := HPDF_GetFont( ::oPdf, ::cFonteCode128, "WinAnsiEncoding" )
   #endif

   // final da criacao e definicao do objeto pdf

   ::oPdfPage := HPDF_AddPage( ::oPdf )

   HPDF_Page_SetSize( ::oPdfPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT )
   nAltura := HPDF_Page_GetHeight( ::oPdfPage )    &&  = 841,89
   nLargura := HPDF_Page_GetWidth( ::oPdfPage )    &&  = 595,28

   ::nLinhaPdf := nAltura - 25   && Margem Superior

   nAngulo := 45                   /* A rotation of 45 degrees. */
   nRadiano := nAngulo / 180 * 3.141592 /* Calcurate the radian value. */

   ::cabecalho()
   ::destinatario()
   ::eventos()
   ::rodape()

   ::cFile := iif( ::cFile == NIL, ::cChaveNFe + "-CCe.PDF", ::cFile )

   HPDF_SaveToFile( ::oPdf, ::cFile )
   HPDF_Free( ::oPdf )

   RETURN(.T.)


METHOD cabecalho() CLASS hbNFeDanfeCCe

   LOCAL oImage, hZebra

   hbNFe_Box_Hpdf( ::oPdfPage, 30,::nLinhaPdf-106,   535,  110, ::nLarguraBox )    && Quadro Cabeçalho

   // logo/dados empresa

   hbNFe_Box_Hpdf( ::oPdfPage, 290,::nLinhaPdf-106,  275,  110, ::nLarguraBox )    && Quadro CC-e, Chave de Acesso e Codigo de Barras
   hbNFe_Texto_Hpdf( ::oPdfPage,30, ::nLinhaPdf + 2,     274, Nil, "IDENTIFICAÇÃO DO EMITENTE" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   // alert('nLogoStyle: ' + ::nLogoStyle +';_LOGO_ESQUERDA: ' + _LOGO_ESQUERDA)
   IF EMPTY( ::cLogoFile )
       hbNFe_Texto_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-6 ,  289, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,1)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 14 )
       hbNFe_Texto_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-20,  289, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,2)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 14 )
       hbNFe_Texto_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-42,  289, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
       hbNFe_Texto_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-52,  289, Nil, ::aEmit[ "xBairro" ]+" - "+TRANSF( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
       hbNFe_Texto_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-62,  289, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
       hbNFe_Texto_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-72,  289, Nil, TRIM(IF(!EMPTY(::cTelefoneEmitente),"FONE: "+::cTelefoneEmitente,"")), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
       hbNFe_Texto_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-82,  289, Nil, TRIM(::cSiteEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
       hbNFe_Texto_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-92,  289, Nil, TRIM(::cEmailEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
   ELSE
       IF ::nLogoStyle = _LOGO_EXPANDIDO
          oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
          HPDF_Page_DrawImage( ::oPdfPage, oImage, 55, ::nLinhaPdf - (82+18), 218, 92 )
       ELSEIF ::nLogoStyle = _LOGO_ESQUERDA
          oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
          HPDF_Page_DrawImage( ::oPdfPage, oImage, 36, ::nLinhaPdf - (62+18), 62, 62 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  100, ::nLinhaPdf-6 ,  289, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,1)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  100, ::nLinhaPdf-20 , 289, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,2)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  100, ::nLinhaPdf-42,  289, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  100, ::nLinhaPdf-52,  289, Nil, ::aEmit[ "xBairro" ]+" - "+TRANSF( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  100, ::nLinhaPdf-62,  289, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  100, ::nLinhaPdf-72,  289, Nil, TRIM(IF(!EMPTY(::cTelefoneEmitente),"FONE: "+::cTelefoneEmitente,"")), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  100, ::nLinhaPdf-82,  289, Nil, TRIM(::cSiteEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  100, ::nLinhaPdf-92,  289, Nil, TRIM(::cEmailEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )

		ELSEIF ::nLogoStyle = _LOGO_DIREITA
          oImage := HPDF_LoadJPEGImageFromFile( ::oPdf, ::cLogoFile )
          HPDF_Page_DrawImage( ::oPdfPage, oImage, 220, ::nLinhaPdf - (62+18), 62, 62 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-6 ,  218, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,1)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-20 , 218, Nil, TRIM(MEMOLINE(::aEmit[ "xNome" ],30,2)) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-42,  218, Nil, ::aEmit[ "xLgr" ]+" "+::aEmit[ "nro" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-52,  218, Nil, ::aEmit[ "xBairro" ]+" - "+TRANSF( ::aEmit[ "CEP" ], "@R 99999-999"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-62,  218, Nil, ::aEmit[ "xMun" ]+" - "+::aEmit[ "UF" ], HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-72,  218, Nil, TRIM(IF(!EMPTY(::cTelefoneEmitente),"FONE: "+::cTelefoneEmitente,"")), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-82,  218, Nil, TRIM(::cSiteEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
          hbNFe_Texto_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-92,  218, Nil, TRIM(::cEmailEmitente), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
        ENDIF
   ENDIF

/*
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
*/


   hbNFe_Texto_Hpdf( ::oPdfPage,292, ::nLinhaPdf-2   , 554, Nil, "CC-e" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 18 )
   hbNFe_Texto_Hpdf( ::oPdfPage,296, ::nLinhaPdf-22   , 554, Nil, "CARTA DE CORREÇÃO ELETRÔNICA" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 14 )

   // chave de acesso
   hbNFe_Box_Hpdf( ::oPdfPage, 290,::nLinhaPdf-61 ,  275,  20, ::nLarguraBox )
   hbNFe_Texto_Hpdf( ::oPdfPage,291, ::nLinhaPdf-42   , 534, Nil, "CHAVE DE ACESSO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
   IF ::cFonteCCe == "Times"
      hbNFe_Texto_Hpdf( ::oPdfPage,292, ::nLinhaPdf-49   , 554, Nil, TRANSF(::cChaveNFe, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 10 )
   ELSE
      hbNFe_Texto_Hpdf( ::oPdfPage,292, ::nLinhaPdf-50   , 554, Nil, TRANSF(::cChaveNFe, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 8 )
   ENDIF

   // codigo barras
   #ifdef __XHARBOUR__
        hbNFe_Texto_Hpdf( ::oPdfPage,291, ::nLinhaPdf-65, 555, Nil, CodificaCode128c(::cChaveNFe), HPDF_TALIGN_CENTER, Nil, ::cFonteCode128F, 18 )
   #else
      hZebra := hb_zebra_create_code128( ::cChaveNFe, Nil )
      hbNFe_Zebrea_Draw_Hpdf( hZebra, ::oPdfPage, 300, ::nLinhaPdf-100, 0.9, 30 )
   #endif

   ::nLinhaPdf -= 106

   // CNPJ
   hbNFe_Box_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-20,   535,  20, ::nLarguraBox )    && Quadro CNPJ/INSCRIÇÃO
   hbNFe_Texto_Hpdf( ::oPdfPage,32, ::nLinhaPdf,      160, Nil, "CNPJ" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,31, ::nLinhaPdf-6,    160, Nil, TRANSF(::aEmit[ "CNPJ" ], "@R 99.999.999/9999-99"), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // I.E.
   hbNFe_Box_Hpdf(  ::oPdfPage, 160, ::nLinhaPdf-20,  130,  20, ::nLarguraBox )    && Quadro INSCRIÇÃO
   hbNFe_Texto_Hpdf( ::oPdfPage,162, ::nLinhaPdf,     290, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,161, ::nLinhaPdf-6,   290, Nil, ::aEmit[ "IE" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // MODELO DO DOCUMENTO (NF-E)
   hbNFe_Texto_Hpdf( ::oPdfPage,291, ::nLinhaPdf,     340, Nil, "MODELO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,291, ::nLinhaPdf-6,   340, Nil, ::aIde[ "mod" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // SERIE DOCUMENTO (NF-E)
   hbNFe_Box_Hpdf( ::oPdfPage,  340, ::nLinhaPdf-20,   50,  20, ::nLarguraBox )
   hbNFe_Texto_Hpdf( ::oPdfPage,341, ::nLinhaPdf,     390, Nil, "SERIE" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,341, ::nLinhaPdf-6,   390, Nil, ::aIde[ "serie" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // NUMERO NFE
   hbNFe_Texto_Hpdf( ::oPdfPage,391, ::nLinhaPdf,     480, Nil, "NUMERO DA NF-e" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,391, ::nLinhaPdf-6,   480, Nil, SUBS(STRZERO(VAL(::aIde[ "nNF" ]),9),1,3)+"."+SUBS(STRZERO(VAL(::aIde[ "nNF" ]),9),4,3)+"."+SUBS(STRZERO(VAL(::aIde[ "nNF" ]),9),7,3) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // DATA DE EMISSAO DA NFE
   hbNFe_Box_Hpdf( ::oPdfPage,  480, ::nLinhaPdf-20,   85,  20, ::nLarguraBox )
   hbNFe_Texto_Hpdf( ::oPdfPage,481, ::nLinhaPdf,     565, Nil, "DATA DE EMISSÃO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,481, ::nLinhaPdf-6,   565, Nil, subs(::aIde[ "dhEmi" ],9,2) + '/' + substr(::aIde[ "dhEmi" ],6,2) + '/' + left(::aIde[ "dhEmi" ],4), HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   RETURN NIL

METHOD destinatario() CLASS hbNFeDanfeCCe

   // REMETENTE / DESTINATARIO

	::nLinhaPdf -= 24

   hbNFe_Texto_Hpdf( ::oPdfPage, 30, ::nLinhaPdf  , 565, Nil, "DESTINATÁRIO/REMETENTE" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )

   ::nLinhaPdf -= 9
   // RAZAO SOCIAL
   hbNFe_Box_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-20, 425, 20, ::nLarguraBox )
   hbNFe_Texto_Hpdf( ::oPdfPage,32, ::nLinhaPdf    , 444, Nil, "NOME / RAZÃO SOCIAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,32, ::nLinhaPdf-6  , 444, Nil, ::aDest[ "xNome" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 11)
   // CNPJ/CPF
   hbNFe_Box_Hpdf( ::oPdfPage,455, ::nLinhaPdf-20, 110, 20, ::nLarguraBox )
   hbNFe_Texto_Hpdf( ::oPdfPage,457, ::nLinhaPdf    , 565, Nil, "CNPJ/CPF" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   IF !EMPTY(::aDest[ "CNPJ" ])
      hbNFe_Texto_Hpdf( ::oPdfPage,457, ::nLinhaPdf-6  , 565, Nil, TRANSF(::aDest[ "CNPJ" ], "@R 99.999.999/9999-99") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )
   ELSE
      IF ::aDest[ "CPF" ] <> Nil
         hbNFe_Texto_Hpdf( ::oPdfPage,457, ::nLinhaPdf-6  , 565, Nil, TRANSF(::aDest[ "CPF" ], "@R 999.999.999-99") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )
      ENDIF
   ENDIF

   ::nLinhaPdf -= 20

   // ENDEREÇO
   hbNFe_Box_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-20, 270, 20, ::nLarguraBox )
   hbNFe_Texto_Hpdf( ::oPdfPage,32, ::nLinhaPdf    , 298, Nil, "ENDEREÇO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,32, ::nLinhaPdf-6  , 298, Nil, ::aDest[ "xLgr" ]+" "+::aDest[ "nro" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 9 )
   // BAIRRO
   hbNFe_Box_Hpdf( ::oPdfPage,300, ::nLinhaPdf-20, 195, 20, ::nLarguraBox )
   hbNFe_Texto_Hpdf( ::oPdfPage,302, ::nLinhaPdf    , 494, Nil, "BAIRRO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,302, ::nLinhaPdf-6  , 494, Nil, ::aDest[ "xBairro" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 11 )
   // CEP
   hbNFe_Box_Hpdf( ::oPdfPage,495, ::nLinhaPdf-20, 70, 20, ::nLarguraBox )
   hbNFe_Texto_Hpdf( ::oPdfPage,497, ::nLinhaPdf    , 564, Nil, "C.E.P." , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   TRY
      hbNFe_Texto_Hpdf( ::oPdfPage,497, ::nLinhaPdf-6  , 564, Nil, TRANSF(::aDest[ "CEP" ], "@R 99999-999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )
   CATCH
   END

   ::nLinhaPdf -= 20

   // MUNICIPIO
   hbNFe_Box_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-20, 535, 20, ::nLarguraBox )
   hbNFe_Texto_Hpdf( ::oPdfPage,32, ::nLinhaPdf    , 284, Nil, "MUNICIPIO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,32, ::nLinhaPdf-6  , 284, Nil, ::aDest[ "xMun" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 11 )
   // FONE/FAX
   hbNFe_Box_Hpdf( ::oPdfPage,285, ::nLinhaPdf-20, 140, 20, ::nLarguraBox )
   hbNFe_Texto_Hpdf( ::oPdfPage,287, ::nLinhaPdf    , 424, Nil, "FONE/FAX" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   IF LEN(::aDest[ "fone" ])=10
      hbNFe_Texto_Hpdf( ::oPdfPage,287, ::nLinhaPdf-6  , 424, Nil, TRANSF(::aDest[ "fone" ], "@R (99) 9999-9999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )
   ELSEIF LEN(::aDest[ "fone" ])>10
      hbNFe_Texto_Hpdf( ::oPdfPage,287, ::nLinhaPdf-6  , 424, Nil, TRANSF(::aDest[ "fone" ], "@R +99 (99) 9999-9999") , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )
   ENDIF
   // ESTADO
   hbNFe_Texto_Hpdf( ::oPdfPage,427, ::nLinhaPdf    , 454, Nil, "ESTADO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,427, ::nLinhaPdf-6  , 454, Nil, ::aDest[ "UF" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )
   // INSC. EST.
   hbNFe_Box_Hpdf( ::oPdfPage,455, ::nLinhaPdf-20   , 110, 20, ::nLarguraBox )
   hbNFe_Texto_Hpdf( ::oPdfPage,457, ::nLinhaPdf    , 564, Nil, "INSCRIÇÃO ESTADUAL" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,457, ::nLinhaPdf-6  , 564, Nil, ::aDest[ "IE" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   ::nLinhaPdf -= 20

   RETURN NIL

METHOD eventos() CLASS hbNFeDanfeCCe

   LOCAL cDataHoraReg, cMemo, nI, nCompLinha

   // Eventos
   hbNFe_Texto_Hpdf( ::oPdfPage, 30, ::nLinhaPdf-4 , 565, Nil, "EVENTOS" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )

   ::nLinhaPdf -= 12

   hbNFe_Box_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-20 ,   535,  20, ::nLarguraBox )

   // ORGAO EMITENTE
   hbNFe_Texto_Hpdf( ::oPdfPage,32, ::nLinhaPdf,   90, Nil, "ORGÃO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,32, ::nLinhaPdf-6, 90, Nil, ::aInfCCe[ "cOrgao" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // TIPO DE EVENTO'
   hbNFe_Box_Hpdf( ::oPdfPage,  90, ::nLinhaPdf-20,   60,  20, ::nLarguraBox )
   hbNFe_Texto_Hpdf( ::oPdfPage,92, ::nLinhaPdf,     149, Nil, "TIPO EVENTO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,92, ::nLinhaPdf-6,   149, Nil, ::aInfCCe[ "tpEvento" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // SEQUENCIA  EVENTO
   hbNFe_Texto_Hpdf( ::oPdfPage,152, ::nLinhaPdf,   209, Nil, "SEQ. EVENTO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,152, ::nLinhaPdf-6, 209, Nil, ::aInfCCe[ "nSeqEvento" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // VERSÃO DO EVENTO
   hbNFe_Box_Hpdf( ::oPdfPage,  210, ::nLinhaPdf-20 ,   60,  20, ::nLarguraBox )
   hbNFe_Texto_Hpdf( ::oPdfPage,212, ::nLinhaPdf,      269, Nil, "VERSÃO EVENTO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,212, ::nLinhaPdf-6,    269, Nil, ::aInfCCe[ "verEvento" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // DATA E HORA DO REGISTRO
   hbNFe_Texto_Hpdf( ::oPdfPage,272, ::nLinhaPdf,  429, Nil, "DATA DO REGISTRO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   cDataHoraReg := substr(::aInfCCe[ "dhRegEvento" ],9,2) + '/'
   cDataHoraReg += substr(::aInfCCe[ "dhRegEvento" ],6,2) + '/'
   cDataHoraReg += left(::aInfCCe[ "dhRegEvento" ],4) + '  '
   cDataHoraReg += substr(::aInfCCe[ "dhRegEvento" ],12,8)
   hbNFe_Texto_Hpdf( ::oPdfPage,272, ::nLinhaPdf-6, 429, Nil, cDataHoraReg , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

   // NUMERO DO PROTOCOLO
   hbNFe_Box_Hpdf( ::oPdfPage,  430, ::nLinhaPdf-20,    135,  20, ::nLarguraBox )
   hbNFe_Texto_Hpdf( ::oPdfPage,432, ::nLinhaPdf,       564, Nil, "NUMERO DO PROTOCOLO" , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,432, ::nLinhaPdf-6,     564, Nil, ::aInfCCe[ "nProt" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )

  ::nLinhaPdf -= 20

   // STATUS DO EVENTO
   hbNFe_Box_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-20,  535,  20, ::nLarguraBox )
   hbNFe_Texto_Hpdf( ::oPdfPage,32, ::nLinhaPdf,     564, Nil, "STATUS DO EVENTO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 6 )
   hbNFe_Texto_Hpdf( ::oPdfPage,32, ::nLinhaPdf-6,    60, Nil, ::aInfCCe[ "cStat" ] , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalhoBold, 11 )
   hbNFe_Texto_Hpdf( ::oPdfPage,62, ::nLinhaPdf-6,    564, Nil, ::aInfCCe[ "xMotivo" ] , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 11 )

  ::nLinhaPdf -= 25

   // Correções

   hbNFe_Texto_Hpdf( ::oPdfPage, 30, ::nLinhaPdf , 565, Nil, "CORREÇÕES" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
   hbNFe_Box_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-188 ,   535,  180, ::nLarguraBox )

   ::nLinhaPdf -= 12

   cMemo :=  IF(::aInfCCe[ "xCorrecao" ] <> Nil, ::aInfCCe[ "xCorrecao" ],"")

   cMemo := STRTRAN( cMemo , ";", CHR(13)+CHR(10) )
   nCompLinha := 77
   IF ::cFonteCorrecoes == "Helvetica"
      nCompLinha := 75
   ENDIF

   FOR nI = 1 TO MLCOUNT( cMemo, nCompLinha )
      hbNFe_Texto_Hpdf( ::oPdfPage,38, ::nLinhaPdf    ,564, Nil, UPPER( TRIM( MEMOLINE(cMemo,nCompLinha,nI) ) ), HPDF_TALIGN_LEFT, Nil, ::oPdfFontCorrecoes, 11 )
      ::nLinhaPdf -= 12
   NEXT

   FOR nI=(MLCOUNT( cMemo, nCompLinha )+1) TO 14
      ::nLinhaPdf -= 12
   NEXT

   RETURN NIL

METHOD rodape() CLASS hbNFeDanfeCCe

   LOCAL cTextoCond, nTamFonte

   ::nLinhaPdf -= 13

   IF ::cFonteCCe == "Times"
      nTamFonte = 13
    ELSEIF ::cFonteCCe == "Helvetica"
      nTamFonte = 12
    ELSEIF ::cFonteCCe == "Courier-Oblique"
      nTamFonte = 9
    ELSE
      nTamFonte = 9
   ENDIF

   // Condição de USO

   hbNFe_Texto_Hpdf( ::oPdfPage, 30, ::nLinhaPdf , 535, Nil, "CONDIÇÃO DE USO" , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalhoBold, 6 )
   hbNFe_Box_Hpdf( ::oPdfPage,  30, ::nLinhaPdf-102 ,   535,  94, ::nLarguraBox )
   cTextoCond := 'A Carta de Correção é disciplinada pelo § 1º-A do art. 7º do Convênio S/N, de 15 de dezembro de'
   hbNFe_Texto_Hpdf( ::oPdfPage,34, ::nLinhaPdf - 12    ,564, Nil, cTextoCond , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, nTamFonte )
   cTextoCond := '1970,  e pode ser utilizada para regularização de erro ocorrido na emissão de documento fiscal,'
   hbNFe_Texto_Hpdf( ::oPdfPage,34, ::nLinhaPdf - 24    ,564, Nil, cTextoCond , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, nTamFonte )
   cTextoCond := 'desde que o erro não esteja relacionado com:'
   hbNFe_Texto_Hpdf( ::oPdfPage,34, ::nLinhaPdf - 36    ,564, Nil, cTextoCond , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, nTamFonte )
   cTextoCond := 'I   - As variáveis que determinam o valor do imposto tais como:  Base de cálculo, alíquota,'
   hbNFe_Texto_Hpdf( ::oPdfPage,34, ::nLinhaPdf - 48    ,564, Nil, cTextoCond , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, nTamFonte )
   cTextoCond := '      diferença de preço, quantidade, valor da operação ou da prestação;'
   hbNFe_Texto_Hpdf( ::oPdfPage,34, ::nLinhaPdf - 60    ,564, Nil, cTextoCond , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, nTamFonte )
   cTextoCond := 'II  - A correção de dados cadastrais que implique mudança do remetente ou do destinatário;'
   hbNFe_Texto_Hpdf( ::oPdfPage,34, ::nLinhaPdf - 72    ,564, Nil, cTextoCond , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, nTamFonte )
   cTextoCond := 'III - A data de emissão ou de saída.'
   hbNFe_Texto_Hpdf( ::oPdfPage,34, ::nLinhaPdf - 84    ,564, Nil, cTextoCond , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, nTamFonte )

   // Observações:

   ::nLinhaPdf -= 100

   IF ::cFonteCCe == "Times"
      cTextoCond := 'Para evitar-se  qualquer  sansão fiscal, solicitamos acusarem o recebimento  desta,  na'
      hbNFe_Texto_Hpdf( ::oPdfPage, 34, ::nLinhaPdf-12 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 15 )
      cTextoCond := 'cópia que acompanha, devendo  a  via  de  V.S(as) ficar juntamente com  a nota fiscal'
      hbNFe_Texto_Hpdf( ::oPdfPage, 34, ::nLinhaPdf-26 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 15 )
      cTextoCond := 'em questão.'
      hbNFe_Texto_Hpdf( ::oPdfPage, 34, ::nLinhaPdf-40 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 15 )
   ELSEIF ::cFonteCCe == "Helvetica"
      cTextoCond := 'Para evitar-se qualquer sansão fiscal, solicitamos acusarem  o  recebimento desta, '
      hbNFe_Texto_Hpdf( ::oPdfPage, 34, ::nLinhaPdf-12 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 14 )
      cTextoCond := 'na cópia que acompanha, devendo a via  de  V.S(as) ficar juntamente com  a  nota '
      hbNFe_Texto_Hpdf( ::oPdfPage, 34, ::nLinhaPdf-26 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 14 )
      cTextoCond := 'fiscal em questão.'
      hbNFe_Texto_Hpdf( ::oPdfPage, 34, ::nLinhaPdf-40 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 14 )
   ELSE
      cTextoCond := 'Para evitar-se qualquer sansão fiscal, solicitamos acusarem o recebimento desta,'
      hbNFe_Texto_Hpdf( ::oPdfPage, 34, ::nLinhaPdf-12 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 11 )
      cTextoCond := 'na cópia que acompanha, devendo a via  de  V.S(as) ficar juntamente com  a nota'
      hbNFe_Texto_Hpdf( ::oPdfPage, 34, ::nLinhaPdf-26 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 11 )
      cTextoCond := 'fiscal em questão.'
      hbNFe_Texto_Hpdf( ::oPdfPage, 34, ::nLinhaPdf-40 , 564, Nil, cTextoCond, HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 11 )
   ENDIF

   // Observações:

   ::nLinhaPdf -= 100

   hbNFe_Line_Hpdf( ::oPdfPage, 34, ::nLinhaPdf-12, 270, ::nLinhaPdf-12, ::nLarguraBox)

   hbNFe_Texto_Hpdf( ::oPdfPage, 30,  ::nLinhaPdf-14, 284, Nil, 'Local e data' , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 9 )
   hbNFe_Texto_Hpdf( ::oPdfPage, 304, ::nLinhaPdf-14, 574, Nil, 'Sem outro motivo para o momento subscrevemos-nos.' , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 9 )
   hbNFe_Texto_Hpdf( ::oPdfPage, 304, ::nLinhaPdf-24, 574, Nil, 'Atenciosamente.' , HPDF_TALIGN_LEFT, Nil, ::oPdfFontCabecalho, 9 )

   hbNFe_Line_Hpdf( ::oPdfPage, 34,  ::nLinhaPdf-92, 270, ::nLinhaPdf-92, ::nLarguraBox)
   hbNFe_Line_Hpdf( ::oPdfPage, 564, ::nLinhaPdf-92, 300, ::nLinhaPdf-92, ::nLarguraBox)

   hbNFe_Texto_Hpdf( ::oPdfPage, 30,  ::nLinhaPdf-94, 284, Nil,  trim( memoline(::aDest[ "xNome" ],40,1 ) ) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 9 )
   hbNFe_Texto_Hpdf( ::oPdfPage, 30,  ::nLinhaPdf-108, 284, Nil, trim( memoline(::aDest[ "xNome" ],40,2 ) ) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 9 )
   hbNFe_Texto_Hpdf( ::oPdfPage, 300, ::nLinhaPdf-94,  574, Nil, trim( memoline(::aEmit[ "xNome" ],40,1 ) ) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 9 )
   hbNFe_Texto_Hpdf( ::oPdfPage, 300, ::nLinhaPdf-108, 574, Nil, trim( memoline(::aEmit[ "xNome" ],40,2 ) ) , HPDF_TALIGN_CENTER, Nil, ::oPdfFontCabecalho, 9 )

   RETURN NIL
