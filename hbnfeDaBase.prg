/*
HBNFEDABASE - ROTINAS BASE DE DOCUMENTO AUXILIAR
*/

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


#ifdef __XHARBOUR__
FUNCTION hbnfe_Codifica_Code128c( pcCodigoBarra )

   //  Parameters de entrada : O codigo de barras no formato Code128C "somente numeros" campo tipo caracter
   //  Retorno               : Retorna o código convertido e com o caracter de START e STOP mais o checksum
   //                        : para impressão do código de barras utilizando a fonte Code128bWin, é necessário
   //                        : para utilizar essa fonte os arquivos Code128bWin.ttf, Code128bWin.afm e Code128bWin.pfb
   // Autor                  : Anderson Camilo
   // Data                   : 19/03/2012

   LOCAL nI := 0, checksum := 0, nValorCar, cCode128 := '', cCodigoBarra

   cCodigoBarra = pcCodigoBarra
   IF len( cCodigoBarra ) > 0    // Verifica se os caracteres são válidos (somente números)
      IF int( len( cCodigoBarra ) / 2 ) = len( cCodigoBarra ) / 2    // Tem ser par o tamanho do código de barras
         FOR nI = 1 to len( cCodigoBarra )
            IF ( Asc( substr( cCodigoBarra, nI, 1 ) ) < 48 .OR. Asc( substr( cCodigoBarra, nI, 1 ) ) > 57 )
                nI = 0
	            EXIT
            ENDIF
         NEXT
      ENDIF
      IF nI > 0
         nI = 1 //  nI é o índice da cadeia
         cCode128 = chr(155)
         DO WHILE nI <= len( cCodigoBarra )
            nValorCar = val( substr( cCodigoBarra, nI, 2 ) )
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
	      //  Cálculo código ASCII do checkSum
         IF checksum = 0
            checksum += 128
         ELSEIF checksum < 95
            checksum += 32
         ELSE
            checksum +=  50
         ENDIF
         // Adiciona o checksum e STOP
         cCode128 = cCode128 + Chr( checksum ) +  chr(156)
      ENDIF
   ENDIF

   RETURN cCode128
#else

FUNCTION hbNFe_Zebra_Draw_Hpdf( hZebra, page, ... )

   IF hb_zebra_GetError( hZebra ) != 0
      RETURN HB_ZEBRA_ERROR_INVALIDZEBRA
   ENDIF

   hb_zebra_draw( hZebra, {| x, y, w, h | HPDF_Page_Rectangle( page, x, y, w, h ) }, ... )

   HPDF_Page_Fill( page )

   RETURN 0

#endif

FUNCTION hbNFe_Line_Hpdf( oPdfPage2, x1, y1, x2, y2, nPen, FLAG )

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

FUNCTION hbNFe_Box_Hpdf( oPdfPage2, x1, y1, x2, y2, nPen)

   HPDF_Page_SetLineWidth( oPdfPage2, nPen )
   HPDF_Page_Rectangle( oPdfPage2, x1, y1, x2, y2 )
   HPDF_Page_Stroke( oPdfPage2 )

   RETURN NIL
