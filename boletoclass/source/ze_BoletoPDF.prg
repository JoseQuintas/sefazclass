#include "hbclass.ch"

FUNCTION ze_BoletoToPDF( aBoletoList, cFileName )

   LOCAL oBoleto, oPDF

   IF Empty( aBoletoList )
      RETURN Nil
   ENDIF
   IF ValType( aBoletoList ) != "A"
      aBoletoList := { aBoletoList }
   ENDIF
   oPDF := BoletoPDFClass():New()
   oPDF:Begin()
   FOR EACH oBoleto IN aBoletoList
      oPDF:Add( oBoleto )
   NEXT
   IF ! Empty( cFileName )
      oPDF:cFileName := cFileName
   ENDIF
   oPDF:End()

   RETURN oPDF

CREATE CLASS BoletoPDFClass INHERIT PDFClass STATIC

   VAR    nFontSizeXLarge   INIT 13
   VAR    nFontSizeLarge    INIT 11
   VAR    nFontSizeSmall    INIT 6
   VAR    nFontSizeNormal   INIT 9
   VAR    cFontName         INIT "Helvetica"
   VAR    nDrawMode         INIT 2 // mm
   VAR    nPdfPage          INIT 2 // Portrait

   METHOD INIT()
   METHOD Add( oBoleto )
   METHOD DrawBoleto( oBoleto, nVia, nLine )

   ENDCLASS

METHOD INIT() CLASS BoletoPDFClass

   ::SetType( 2 )

   RETURN Nil

METHOD Add( oBoleto ) CLASS BoletoPDFClass

   ::AddPage()

   ::DrawBoleto( oBoleto, 1, 90 )
   ::DrawBoleto( oBoleto, 2, 198 )

   RETURN Nil

METHOD DrawBoleto( oBoleto, nVia, nLine ) CLASS BoletoPDFClass

   LOCAL cRawLogotipo, aMsgTxtList := {}, cTxt

   cRawLogotipo := Logotipo( oBoleto:nBanco )
   IF oBoleto:nJuros != 0
      AAdd( aMsgTxtList, "APÓS VENCIMENTO COBRAR R$" + ;
         Transform( oBoleto:nValor * oBoleto:nJuros / 30 / 100, "@E 999,999.99" ) + " POR DIA DE ATRASO" )
   ENDIF
   IF oBoleto:nMulta != 0
      AAdd( aMsgTxtList, "MULTA APÓS VENCIMENTO R$" + ;
         Transform( oBoleto:nValor * oBoleto:nMulta / 100, "@E 999,999.99" ) )
   ENDIF
   IF hb_AScan( oBoleto:aMsgCodList, { | e | e == "43" } ) != 0
      AAdd( aMsgTxtList, "SUJEITO A PROTESTO SE NÃO FOR PAGO NO VENCIMENTO" )
   ELSE
      IF oBoleto:nProtesto != 0
         AAdd( aMsgTxtList, "PROTESTAR EM " + Ltrim( Str( oBoleto:nProtesto, 2 ) ) + " DIAS" )
      ENDIF
   ENDIF
   FOR EACH cTxt IN oBoleto:aMsgTxtList
      AAdd( aMsgTxtList, cTxt )
   NEXT
   ::DrawLine( nLine - 7, 20, nLine - 7, 197, 1 )
   IF ! Empty( cRawLogotipo )
      ::DrawMemImageBox( nLine, 20, nLine + 7, 46, cRawLogotipo )
   ENDIF
   IF nVia == 1
      ::DrawText( nLine, 159, "Recibo do Pagador",, ::nFontSizeNormal )
   ENDIF
   ::DrawLine( nLine + 2, 55, nLine + 8, 55 )
   ::DrawLine( nLine + 2, 71, nLine + 8, 71 )
   ::DrawText( nLine + 7, 75, Transform( oBoleto:cDigitavel, "@R 99999.99999 99999.999999 99999.999999 9 99999999999999" ), , ::nfontsizeLarge )

   ::DrawText( nLine + 7, 58, oBoleto:cBancoDigito, , ::nfontsizeXLarge )
   ::DrawLine( nLine + 9, 158, nLine + 68, 158 )
   ::DrawLine( nLine + 9,  20, nLine + 9, 197 )

   ::DrawText( nLine + 13,  20, "Local de Pagamento", , ::nfontsizeSmall )
   ::DrawText( nLine + 13, 159, "Vencimento", , ::nfontsizeSmall )
   ::DrawText( nLine + 16,  20, oBoleto:cLocalPagto, , ::nfontsizeNormal )
   ::DrawText( nLine + 16, 159, hb_Dtoc( oBoleto:dDatVen, "DD/MM/YYYY" ), , ::nfontsizeNormal )

   ::DrawLine( nLine + 17,  20, nLine + 17, 197 )
   ::DrawText( nLine + 19,  20, "Beneficiário" )
   ::DrawText( nLine + 19,  127, "CNPJ/CPF" ,, ::nFontSizeSmall )
   ::DrawText( nLine + 19, 159, "Agência/Código Beneficiário", , ::nfontsizeSmall )
   ::DrawText( nLine + 22,  20, oBoleto:cEmpNome, , ::nFontSizeNormal )
   ::DrawText( nLine + 22,  127, FormatCnpj( oBoleto:cEmpCnpj ),, ::nFontSizeNormal )
   ::DrawText( nLine + 25,  20, oBoleto:cEmpCEP + " " + oBoleto:cEmpEnd + " " + oBoleto:cEmpCidade + " " + oBoleto:cEmpUF, , ::nFontSizeNormal )
   ::DrawText( nLine + 25, 159, oBoleto:cBolConta, , ::nfontsizeNormal )

   ::DrawLine( nLine + 26,  20, nLine + 26, 197 )

   ::DrawLine( nLine + 26,  48, nLine + 38,  48 )
   ::DrawLine( nLine + 26,  76, nLine + 38,  76 )
   ::DrawLine( nLine + 26, 104, nLine + 38, 104 )
   ::DrawLine( nLine + 26, 132, nLine + 38, 132 )

   ::DrawText( nLine + 28,  20, "Data do Documento", , ::nfontsizeSmall )
   ::DrawText( nLine + 28,  51, "No.Documento", , ::nfontsizeSmall )
   ::DrawText( nLine + 28,  79, "Espécie Doc", , ::nfontsizeSmall )
   ::DrawText( nLine + 28, 107, "Aceite", , ::nfontsizeSmall )
   ::DrawText( nLine + 28, 137, "Data Processamento", , ::nfontsizeSmall )
   ::DrawText( nLine + 28, 159, "Nosso Número", , ::nfontsizeSmall )
   ::DrawText( nLine + 31,  20, hb_Dtoc( oBoleto:dDatEmi, "DD/MM/YYYY" ), , ::nfontsizeNormal )
   ::DrawText( nLine + 31,  51, oBoleto:cNumDoc, , ::nfontsizeNormal )
   ::DrawText( nLine + 31,  79, oBoleto:cBolEspecie, , ::nfontsizeNormal )
   ::DrawText( nLine + 31, 107, oBoleto:cAceite, , ::nfontsizeNormal )
   ::DrawText( nLine + 31, 137, hb_Dtoc( Date(), "DD/MM/YYYY" ), , ::nfontsizeNormal )

   ::DrawText( nLine + 31, 159, oBoleto:cBolNumero, , ::nfontsizeNormal )

   ::DrawLine( nLine + 32,  20, nLine + 32, 197 )

   ::DrawText( nLine + 34,  20, "Uso do Banco", , ::nfontsizeSmall )
   ::DrawText( nLine + 34,  51, "Carteira", , ::nfontsizeSmall )
   ::DrawText( nLine + 34,  79, "Espécie", , ::nfontsizeSmall )
   ::DrawText( nLine + 34, 107, "Quantidade", , ::nfontsizeSmall )
   ::DrawText( nLine + 34, 135, "Valor", , ::nfontsizeSmall )
   ::DrawText( nLine + 34, 159, "(-) Valor do Documento", , ::nfontsizeSmall )
   ::DrawText( nLine + 37,  51, StrZero( oBoleto:nCarteira, 3 ), , ::nfontsizeNormal )
   ::DrawText( nLine + 37,  79, "R$", , ::nfontsizeNormal )
   ::DrawText( nLine + 37, 175, Transform( oBoleto:nValor, "@E 999,999,999.99" ), , ::nfontsizeNormal )

   ::DrawLine( nLine + 38,  20, nLine + 38, 197 )
   ::DrawText( nLine + 40,  20, "Instruções de responsabilidade do BENEFICIÁRIO",, ::nfontSizeSmall )
   ::DrawText( nLine + 40, 159, "(-) Desconto/Abatimento", , ::nfontsizeSmall )

   ::DrawText( nLine + 42,  20, "Qualquer dúvida sobre este boleto, contate o BENEFICIÁRIO", , ::nfontsizeSmall )
   FOR EACH cTxt IN aMsgTxtList
      ::DrawText( nLine + 42 + ( cTxt:__EnumIndex * 3 ),  20, cTxt, , ::nfontsizeNormal )
   NEXT
   IF nVia == 2 .AND. ! Empty( oBoleto:cPixCode )
      ::DrawBarcodeQRCode( nLine + 39, 128, 0.8, oBoleto:cPixCode )
   ENDIF

   ::DrawLine( nLine + 44, 158, nLine + 44, 197 )

   ::DrawLine( nLine + 50, 158, nLine + 50, 197 )
   ::DrawText( nLine + 52, 159, "(+) Juros/Multa", , ::nfontsizeSmall )

   ::DrawLine( nLine + 56, 158, nLine + 56, 197 )

   IF nVia == 2 .AND. ! Empty( oBoleto:cPixCode )
      ::DrawText( nLine + 58, 20, "Escolha a forma mais conveniente pra realizar seu pagamento. Código de Barras ou QRCode",, ::nFontSizeSmall )
      ::DrawText( nLine + 60, 20, "Basta acessar o aplicativo da sua instituição financeira e utilizar apenas uma das opções",, ::nFontSizeSmall )
      ::DrawText( nLine + 62, 20, "Pix Copia e Cola",, ::nFontSizeSmall )
      ::DrawText( nLine + 64, 20, Left( oBoleto:cPixCode, 80 ) )
      ::DrawText( nLine + 66, 20, Substr( oBoleto:cPixCode, 81 ) )
   ENDIF

   ::DrawLine( nLine + 62, 158, nLine + 62, 197 )
   ::DrawText( nLine + 64, 159, "(=) Valor Cobrado", , ::nfontsizeSmall )

   ::DrawLine( nLine + 68,  20, nLine + 68, 197 )
   ::DrawText( nLine + 71,  20, "Pagador:",, ::nFontSizeSmall )
   ::DrawText( nLine + 71,  30, oBoleto:cCliNome, , ::nfontsizeNormal )
   ::DrawText( nLine + 71, 150, "CNPJ",, ::nFontSizeSmall )
   ::DrawText( nLine + 71, 170, FormatCnpj( oBoleto:cCliCnpj ),, ::nFontSizeNormal )
   ::DrawText( nLine + 74,  30, oBoleto:cCliEnd, , ::nfontsizeNormal )
   ::DrawText( nLine + 77,  30, oBoleto:cCliCep + " " + oBoleto:cCliEnd + " " + oBoleto:cCliCidade + " " + oBoleto:cCliUF, , ::nfontsizeNormal )

   ::DrawText( nLine + 82,  20, "Beneficiário final",, ::nFontSizeSmall )
   IF ! Empty( oBoleto:cPixCode )
      ::DrawText( nLine + 82, 150, "CNPJ",, ::nFontSizeSmall )
   ELSE
      ::DrawText( nLine + 82,  42, oBoleto:cAvalNome, , ::nfontsizeNormal )
   ENDIF

   ::DrawText( nLine + 82,  18, oBoleto:cBancoNome, , ::nfontsizeSmall,,90 )

   ::DrawLine( nLine + 84,  20, nLine + 84, 197 )
   IF nVia == 1
      ::DrawText( nLine + 86, 145, "Autenticação Mecânica", , ::nfontsizeSmall )
   ELSE
      ::DrawText( nLine + 86, 145, "Ficha de Compensação", , ::nFontsizeSmall )
      ::DrawText( nLine + 88, 145, "Autenticação Mecânica", , ::nfontsizeSmall )
      ::DrawI25BarCode( nLine + 86, 20, 10, oBoleto:cBarras )
   ENDIF

   RETURN Nil

STATIC FUNCTION Logotipo( nBanco, cRawLogotipo )

   cRawLogotipo := ze_BinaryFromSQL( "banco" + StrZero( nBanco, 3 ) + ".jpg" )

   RETURN cRawLogotipo
