/*
Safra
outubro/2023
*/

FUNCTION ze_Calculo422( SELF )

   ::cBancoDigito := "422-7"
   ::cLocalPagto  := "PAGÁVEL EM QUALQUER BANCO DO SISTEMA DE COMPENSAÇÃO"
   ::cBolNumero := StrZero( ::nBancario, 9 )
   ::cBolConta  := StrZero( ::nAgencia, 5 ) + " / " + StrZero( ::nIdEmpresa, 9 )

   ::cBarras := StrZero( ::nBanco, 3 ) + "9" + StrZero( ::nFatorVen, 4 ) + ;
      StrZero( ::nValor * 100, 10 ) + Right( ::cBancoDigito, 1 )
   ::cBarras += StrZero( ::nAgencia, 5 ) + StrZero( ::nConta, 9 ) + ;
      StrZero( ::nBancario, 9 ) + "2" // 2=cobrança registrada

   RETURN Nil

FUNCTION ze_Cnab422( aBoletoList )

   LOCAL cTxt := "", nSequencial := 1
   LOCAL oBoleto, nTotal := 0

   IF Empty( aBoletoList )
      RETURN Nil
   ENDIF
   IF ValType( aBoletoList ) != "A"
      aBoletoList := { aBoletoList }
   ENDIF
   oBoleto := aBoletoList[1]

   WITH OBJECT oBoleto
      /* header */
      /* 001-001 */ cTxt := "0"
      /* 002-002 */ cTxt += "1"
      /* 003-009 */ cTxt += "REMESSA"
      /* 010-011 */ cTxt += "01"
      /* 012-019 */ cTxt += "COBRANCA"
      /* 020-026 */ cTxt += Space(7)
      /* 027-040 */ cTxt += StrZero( :nAgencia, 5 ) + StrZero( :nConta, 9 )
      /* 041-046 */ cTxt += Space(6)
      /* 047-076 */ cTxt += Pad( :cEmpNome, 30 )
      /* 077-079 */ cTxt += "422"
      /* 080-090 */ cTxt += Pad( "BANCO SAFRA", 11 )
      /* 091-094 */ cTxt += Space(4)
      /* 095-100 */ cTxt += hb_Dtoc( Date(), "DDMMYY" )
      /* 101-391 */ cTxt += Space(291)
      /* 392-394 */ cTxt += StrZero( :nRemessa, 3 )
      /* 395-400 */ cTxt += StrZero( nSequencial++, 6 )
      cTxt += hb_Eol()
   ENDWITH

   FOR EACH oBoleto IN aBoletoList
      WITH OBJECT oBoleto
         /* Detalhe 1 */
         /* 001-001 */ cTxt += "1"
         /* 002-003 */ cTxt += iif( IsCnpj( :cEmpCnpj ), "02", "01" )
         /* 004-017 */ cTxt += StrZero( Val( SoNumeros( :cEmpCnpj ) ), 14 )
         /* 018-031 */ cTxt += StrZero( :nAgencia, 5 ) + StrZero( :nConta, 9 )
         /* 032-037 */ cTxt += Space(6)
         /* 038-062 */ cTxt += Space(25)
         /* 063-071 */ cTxt += StrZero( :nBancario, 9 )
         /* 072-101 */ cTxt += Space(30)
         /* 102-102 */ cTxt += "0"
         /* 103-104 */ cTxt += "00"
         /* 105-105 */ cTxt += Space(1)
         /* 106-107 */ cTxt += StrZero(0,2)
         /* 108-108 */ cTxt += "1" // ou 2 pra vinculada
         /* 109-110 */ cTxt += StrZero(1,2)
         /* 111-120 */ cTxt += Pad( Right( :cNumDoc, 10 ), 10 )
         /* 121-126 */ cTxt += hb_Dtoc( :dDatVen, "DDMMYY" )
         /* 127-139 */ cTxt += StrZero( :nValor * 100, 13 )
         /* 140-142 */ cTxt += "422"
         /* 143-147 */ cTxt += StrZero(0,5)
         /* 148-149 */ cTxt += StrZero( :nEspecie, 2 )
         /* 150-150 */ cTxt += :cAceite // aceite
         /* 151-156 */ cTxt += hb_Dtoc( :dDatEmi, "DDMMYY" )
         /* 157-158 */ cTxt += iif( :nMulta != 0, "16", "00" )
         /* 159-160 */ cTxt += iif( :nJuros != 0, "01", "00" )
         /* 161-173 */ cTxt += StrZero( :nValor * :nJuros / 30, 13 )
         /* 174-179 */ cTxt += StrZero(0,6)
         /* 180-192 */ cTxt += StrZero(0,13)
         /* 193-205 */ cTxt += StrZero(0,13)
         IF :nMulta == 0
            /* 206-218 */ cTxt += StrZero(0,13)
         ELSE
            /* 206-211 */ cTxt += hb_Dtoc( :dDatVen + 1, "DDMMYY" )
            /* 212-215 */ cTxt += StrZero( :nMulta * 100, 4 )
            /* 216-218 */ cTxt += "000"
         ENDIF
         /* 219-220 */ cTxt += iif( IsCnpj( :cCliCnpj ), "02","01" )
         /* 221-234 */ cTxt += StrZero( Val( SoNumeros( :cCliCnpj ) ), 14 )
         /* 235-274 */ cTxt += Pad( :cCliNome, 40 )
         /* 275-314 */ cTxt += Pad( :cCliEnd, 40 )
         /* 315-324 */ cTxt += Pad( :cCliBairro, 10 )
         /* 325-326 */ cTxt += Space(2)
         /* 327-334 */ cTxt += StrZero( Val( SoNumeros( :cCliCep ) ), 8 )
         /* 335-349 */ cTxt += Pad( :cCliCidade, 15 )
         /* 350-351 */ cTxt += Pad( :cCliUF, 2 )
         /* 352-381 */ cTxt += Pad( :cAvalNome, 30 )
         /* 382-388 */ cTxt += Space(7)
         /* 389-391 */ cTxt += "422"
         /* 392-394 */ cTxt += Right( StrZero( :nRemessa, 9 ), 3 )
         /* 395-400 */ cTxt += StrZero( nSequencial++, 6 )
         nTotal += :nValor
      ENDWITH
      cTxt += hb_Eol()
   NEXT

   oBoleto := aBoletoList[1]

   WITH OBJECT oBoleto
      /* trailer */
      /* 001-001 */ cTxt += "9"
      /* 002-368 */ cTxt += Space(367)
      /* 369-376 */ cTxt += StrZero( nSequencial - 2, 8 )
      /* 377-391 */ cTxt += StrZero( nTotal * 100, 15)
      /* 392-394 */ cTxt += StrZero( :nRemessa, 3 )
      /* 394-400 */ cTxt += StrZero( nSequencial, 6 )
      cTxt += hb_Eol()
   ENDWITH

   RETURN cTxt
