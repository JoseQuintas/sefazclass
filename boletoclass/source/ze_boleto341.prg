/*
Itaú
Outubro/2023
*/

FUNCTION ze_Calculo341( SELF )

   LOCAL cDigitoNBancario

   ::cBancoDigito := "341-7"
   ::cLocalPagto  := "PAGUE PELO APLICATIVO, INTERNET, AGÊNCIAS OU CORRESPONDENTES"
   cDigitoNBancario := ::Modulo10_All( StrZero( ::nAgencia, 4 ) + ;
      Left( StrZero( ::nConta, 6 ), 5 ) + ;
      StrZero( ::nCarteira, 3 ) + ;
      StrZero( ::nBancario, 8 ) )
   ::cBolNumero := StrZero( ::nCarteira, 3 ) + "/" + StrZero( ::nBancario, 8 ) + "-" + cDigitoNBancario
   ::cBolConta  := StrZero( ::nAgencia, 4 ) + " / " + Transform( StrZero( ::nConta, 6 ), "@R 99999-9" )

   // Codigo de barras
   ::cBarras := ;
      StrZero( ::nBanco, 3 ) + ;
      "9" + ;
      StrZero( ::nFatorVen, 4 ) + ;
      StrZero( ::nValor * 100, 10 ) + ;
      StrZero( ::nCarteira, 3 ) + ;
      StrZero( ::nBancario, 8 ) + ;
      cDigitoNBancario + ;
      StrZero( ::nAgencia, 4 ) + ;
      StrZero( ::nConta, 6 ) + ;
      "000"

   RETURN Nil

FUNCTION ze_Cnab341( aBoletoList )

   LOCAL cTxt := "", nSequencial := 1
   LOCAL oBoleto

   IF Empty( aBoletoList )
      RETURN Nil
   ENDIF
   IF ValType( aBoletoList ) != "A"
      aBoletoList := { aBoletoList }
   ENDIF
   IF Len( aBoletoList ) == 0
      RETURN Nil
   ENDIF
   oBoleto := aBoletoList[ 1 ]
   WITH OBJECT oBoleto
      /* 001-001 */ cTxt += "0"
      /* 002-002 */ cTxt += "1"
      /* 003-009 */ cTxt += "REMESSA"
      /* 010-011 */ cTxt += "01"
      /* 012-026 */ cTxt += Pad( "COBRANCA", 15 )
      /* 027-030 */ cTxt += StrZero( :nAgencia, 4 )
      /* 031-032 */ cTxt += "00"
      /* 033-038 */ cTxt += StrZero( :nConta, 6 )
      /* 039-046 */ cTxt += Space(8)
      /* 047-076 */ cTxt += Pad( :cEmpNome, 30 )
      /* 077-079 */ cTxt += "341"
      /* 080-094 */ cTxt += Pad( "BANCO ITAU SA", 15 )
      /* 095-100 */ cTxt += hb_Dtoc( Date(), "DDMMYY" )
      /* 101-394 */ cTxt += Space(294)
      /* 395-400 */ cTxt += StrZero( nSequencial++, 6 )
      cTxt += hb_Eol()
   ENDWITH

   FOR EACH oBoleto IN aBoletoList
      WITH OBJECT oBoleto
         /* 001-001 */ cTxt += "1"
         IF Empty( :cAvalCnpj )
            /* 002-003 */ cTxt += iif( IsCnpj( :cEmpCnpj ), "02", "01" )
            /* 004-017 */ cTxt += StrZero( Val( SoNumeros( :cEmpCnpj ) ), 14 )
         ELSE
            IF IsCnpj( :cCliCnpj )
               /* 002-003 */ cTxt += "04"
            ELSE
               /* 002-003 */ cTxt += "03"
            ENDIF
            /* 004-017 */ cTxt += Pad( SoNumeros( :cCliCnpj ), 14 )
         ENDIF
         /* 018-021 */ cTxt += StrZero( :nAgencia, 4 )
         /* 022-023 */ cTxt += "00"
         /* 024-029 */ cTxt += StrZero( :nConta, 6 )
         /* 030-033 */ cTxt += Space(4)
         /* 034-037 */ cTxt += StrZero(0,4) ///// Space(4) // nota 27 //// 2024.05.15 zeros
         IF Empty( :cAvalCnpj )
            /* 038-062 */ cTxt += Pad( oBoleto:cNumDoc, 25 )
         ELSE
            /* 038-062 */ cTxt += Pad( :cNumDocAux, 25 )
         ENDIF
         IF :nCarteira == 112 // itaú irá preencher
            /* 063-070 */ cTxt += Space(8) // escritural o itaú vai preencher
         ELSE
            /* 063-070 */ cTxt += StrZero( :nBancario, 8 ) // direta sequencial
         ENDIF
         /* 071-083 */ cTxt += StrZero( 0, 13 ) // outra moeda
         /* 084-086 */ cTxt += StrZero( :nCarteira, 3 )
         /* 087-107 */ cTxt += Space(21)
         /* 108-108 */ cTxt += "I" // nota 5
         /* 109-110 */ cTxt += "01" // remessa nota 6
         IF Empty( :cAvalCnpj )
            /* 111-120 */ cTxt += Pad( :cNumDoc, 10 ) // nota 18
         ELSE
            /* 111-120 */ cTxt += Pad( Right( :cNumDocAux, 9 ), 9 ) + " "
         ENDIF
         /* 121-126 */ cTxt += hb_Dtoc( :dDatVen, "DDMMYY" )
         /* 127-139 */ cTxt += StrZero( :nValor * 100, 13 )
         /* 140-142 */ cTxt += "341"
         /* 143-147 */ cTxt += StrZero( 0, 5 )
         /* 148-149 */ cTxt += StrZero( :nEspecie, 2 ) // coml.cor
         /* 150-150 */ cTxt += iif( :cAceite == "N", "N", "A" )
         /* 151-156 */ cTxt += hb_Dtoc( :dDatEmi, "DDMMYY" )
         /* 157-158 */ cTxt += StrZero( Val( :aMsgCodList[ 1 ] ), 2 ) /////// 2024.05.15 zeros
         /* 159-160 */ cTxt += StrZero( Val( :aMsgCodList[ 2 ] ), 2 )  /////// 2024.05.15 zeros
         /* 161-173 */ cTxt += StrZero( :nValor * :nJuros / 30, 13 ) // no CNAB 100 é 1.00
         /* 174-179 */ cTxt += StrZero( 0, 6 ) /////// Space(6) //////// 2024.05.15 zeros
         /* 180-192 */ cTxt += StrZero( 0, 13 )
         /* 193-205 */ cTxt += StrZero( 0, 13 )
         /* 206-218 */ cTxt += StrZero( 0, 13 )
         /* 219-220 */ cTxt += iif( IsCnpj( :cCliCnpj ), "02", "01" )
         /* 221-234 */ cTxt += StrZero( Val( SoNumeros( :cCliCnpj ) ), 14 )
         /* 235-264 */ cTxt += Pad( :cCliNome, 30 )
         /* 265-274 */ cTxt += Space(10) // nota 15
         /* 275-314 */ cTxt += Pad( :cCliEnd, 40 )
         /* 315-326 */ cTxt += Pad( :cCliBairro, 12 )     // bairro
         /* 327-334 */ cTxt += Pad( SoNumeros( :cCliCep ), 8 )   // cep
         /* 335-349 */ cTxt += Pad( :cCliCidade, 15 )     // cidade
         /* 350-351 */ cTxt += Pad( :cCliUF, 2 )          // uf
         /* 352-381 */ cTxt += Pad( :cAvalNome, 30 )
         /* 382-385 */ cTxt += Space(4)
         /* 386-391 */ cTxt += hb_Dtoc( :dDatVen, "DDMMYY")
         /* 392-393 */ cTxt += StrZero( 0, 2 )
         /* 394-394 */ cTxt += Space(1)
         /* 395-400 */ cTxt += StrZero( nSequencial++, 6 )
         cTxt += hb_Eol()
      ENDWITH

      WITH OBJECT oBoleto
         IF :nMulta != 0 .AND. .F. // confirmar uso
            /* 001-001 */ cTxt += "2"
            /* 002-002 */ cTxt += "2" // percentual
            /* 003-010 */ cTxt += hb_Dtoc( :dDatVen + 6, "DDMMYYYY" )
            /* 011-023 */ cTxt += StrZero( :nMulta * 100, 13 ) // percentual 2 decimais
            /* 024-394 */ cTxt += Space(371)
            /* 395-400 */ StrZero( nSequencial++, 6 )
            cTxt += hb_Eol()
         ENDIF
      ENDWITH

      WITH OBJECT oBoleto
         IF ! Empty( :cCliEMail )
            cTxt += "5"
            cTxt += Pad( :cCliEmail, 120 )
            cTxt += Space(275)
            cTxt += hb_Eol()
         ENDIF
      ENDWITH

   NEXT
   /* 001-001 */ cTxt += "9"
   /* 002-394 */ cTxt += Space( 393 )
   /* 395-400 */ cTxt += StrZero( nSequencial, 6 )
   cTxt += hb_Eol()

   RETURN cTxt
