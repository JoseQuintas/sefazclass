/*
Santander
Outubro/2023
*/

FUNCTION ze_Calculo033( SELF )

   ::cBancoDigito := "033-9"
   ::cLocalPagto  := "PAGÁVEL PREFERENCIALMENTE NO SANTANDER"
   ::cBolNumero := StrZero( ::nBancario, 12 )
   ::cBolNumero += ::Modulo11_033( ::cBolNumero )
   ::cBolConta  := Left( StrZero( ::nAgencia, 5 ), 4 ) + " / " + StrZero( ::nIdEmpresa, 9 )

   ::cBarras    := StrZero( ::nBanco, 3 ) + "9" + StrZero( ::nFatorVen, 4 ) + ;
      StrZero( ::nValor * 100, 10 ) + "9" + StrZero( ::nidEmpresa, 7 ) + ;
      ::cBolNumero + "0" + StrZero( ::nCarteira, 3 )

   RETURN Nil

FUNCTION ze_Cnab033( aBoletoList )

   LOCAL cTxt := "", nSequencial := 1, cCodigoTransmissao
   LOCAL oBoleto, nLote := 1, nRemessa := 1, nArquivo := 1

   IF Empty( aBoletoList )
      RETURN Nil
   ENDIF
   IF ValType( aBoletoList ) != "A"
      aBoletoList := { aBoletoList }
   ENDIF
   IF Len( aBoletoList ) == 0
      RETURN Nil
   ENDIF
   oBoleto := aBoletoList[1]

   WITH OBJECT oBoleto
      cCodigoTransmissao := Left( StrZero( :nAgencia, 5 ), 4 ) + StrZero( :nIdEmpresa, 11 )

      /* header */
      /* 001-003 */ cTxt := StrZero( :nBanco, 3 )
      /* 004-007 */ cTxt += "0000"
      /* 008-008 */ cTxt += "0"
      /* 009-016 */ cTxt += Space(8)
      /* 017-017 */ cTxt += iif( IsCnpj( :cEmpCnpj ), "2", "1" )
      /* 018-032 */ cTxt += Padl( SoNumeros( :cEmpCnpj ), 15, "0" )
      /* 033-047 */ cTxt += Pad( cCodigoTransmissao, 15 )
      /* 048-072 */ cTxt += Space(25)
      /* 073-102 */ cTxt += Pad( :cEmpNome, 30 )
      /* 103-132 */ cTxt += Pad( "BANCO SANTANDER", 30 )
      /* 133-142 */ cTxt += Space(10)
      /* 143-143 */ cTxt += "1"
      /* 144-151 */ cTxt += hb_Dtoc( Date(), "DDMMYYYY" )
      /* 152-157 */ cTxt += Space(6)
      /* 158-163 */ cTxt += StrZero( nArquivo, 6 )
      /* 164-166 */ cTxt += "040"
      /* 167-240 */ cTxt += Space(74)
      cTxt += hb_Eol()

      /* header lote */
      /* 001-003 */ cTxt += StrZero( :nBanco, 3 )
      /* 004-007 */ cTxt += StrZero( nLote, 4 )
      /* 008-008 */ cTxt += "1"
      /* 009-009 */ cTxt += "R"
      /* 010-011 */ cTxt += "01"
      /* 012-013 */ cTxt += Space(2)
      /* 014-016 */ cTxt += "030"
      /* 017-017 */ cTxt += Space(1)
      /* 018-018 */ cTxt += iif( IsCnpj( :cEmpCnpj ), "2", "1" )
      /* 019-033 */ cTxt += Padl( SoNumeros( :cEmpCnpj ), 15, '0' )
      /* 034-053 */ cTxt += Space(20)
      /* 054-068 */ cTxt += Pad( cCodigoTransmissao, 15 )
      /* 069-073 */ cTxt += Space(5)
      /* 074-103 */ cTxt += Pad( :cEmpNome, 30 )
      /* 104-143 */ cTxt += Pad( "", 40 ) // msg 1
      /* 144-183 */ cTxt += Pad( "", 40 ) // msg 2
      /* 184-191 */ cTxt += StrZero( nRemessa, 8 )
      /* 192-199 */ cTxt += hb_Dtoc( Date(), "DDMMYYYY" )
      /* 200-240 */ cTxt += Space(41)
      cTxt += hb_Eol()
   ENDWITH

   FOR EACH oBoleto IN aBoletoList
      WITH OBJECT oBoleto
         /* Detalhe P */
         /* 001-003 */ cTxt += StrZero( :nBanco, 3 )
         /* 004-007 */ cTxt += StrZero( nLote, 4 )
         /* 008-008 */ cTxt += "3"
         /* 009-013 */ cTxt += StrZero( nSequencial++, 5 )
         /* 014-014 */ cTxt += "P"
         /* 015-015 */ cTxt += Space(1)
         /* 016-017 */ cTxt += "01"
         /* 018-022 */ cTxt += StrZero( :nAgencia, 5 )
         /* 023-032 */ cTxt += StrZero( :nConta, 10 )
         /* 033-042 */ cTxt += StrZero( :nConta, 10 )
         /* 043-044 */ cTxt += Space(2)
         /* 045-057 */ cTxt += StrZero( :nBancario, 12 ) + oBoleto:Modulo11_033( StrZero( :nBancario, 12 ) )
         /* 058-058 */ cTxt += "5"
         /* 059-059 */ cTxt += "1"
         /* 060-060 */ cTxt += "1"
         /* 061-062 */ cTxt += Space(2)
         /* 063-077 */ cTxt += Pad( :cNumDoc, 15 )
         /* 078-085 */ cTxt += hb_Dtoc( :dDatVen, "DDMMYYYY" )
         /* 086-100 */ cTxt += StrZero( :nValor * 100, 15 )
         /* 101-105 */ cTxt += StrZero( 0, 5 )
         /* 106-106 */ cTxt += Space(1)
         /* 107-108 */ cTxt += "02"
         /* 109-109 */ cTxt += "N"
         /* 110-117 */ cTxt += hb_Dtoc( :dDatEmi, "DDMMYYYY" )
         /* 118-118 */ cTxt += "1"
         /* 119-126 */ cTxt += hb_Dtoc( :dDatVen, "DDMMYYYY" )
         /* 127-141 */ cTxt += StrZero( :nValor * :nJuros / 30, 15 )
         /* 142-142 */ cTxt += "0"
         /* 143-150 */ cTxt += StrZero( 0, 8 )
         /* 151-165 */ cTxt += StrZero( 0, 15 )
         /* 166-180 */ cTxt += StrZero( 0, 15 )
         /* 181-195 */ cTxt += StrZero( 0, 15 )
         /* 196-220 */ cTxt += Space(25)
         IF :nProtesto == 0
            /* 221-221 */ cTxt += "0"  // protestar 1=dias corridos 2=dias úteis 3=usar perfil
            /* 222-223 */ cTxt += "00" // protestar em n dias
         ELSE
            cTxt += "1"
            cTxt += StrZero( :nProtesto, 2 )
         ENDIF
         /* 224-224 */ cTxt += "3"
         /* 225-225 */ cTxt += "0"
         /* 226-227 */ cTxt += "00"
         /* 228-229 */ cTxt += StrZero( 0, 2 )
         /* 230-240 */ cTxt += Space(11)
         cTxt += hb_Eol()

         /* Detalhe Q */
         /* 001-003 */ cTxt += StrZero( :nBanco, 3 )
         /* 004-007 */ cTxt += StrZero( nLote, 4 )
         /* 008-008 */ cTxt += "3"
         /* 009-013 */ cTxt += StrZero( nSequencial++, 5 )
         /* 014-014 */ cTxt += "Q"
         /* 015-015 */ cTxt += Space(1)
         /* 016-017 */ cTxt += "01"
         /* 018-018 */ cTxt += iif( IsCnpj( :cCliCnpj ), "2", "1" )
         /* 019-033 */ cTxt += Padl( SoNumeros( :cCliCnpj ), 15, "0" )
         /* 034-073 */ cTxt += Pad( :cCliNome, 40 )
         /* 074-113 */ cTxt += Pad( :cCliEnd, 40 )
         /* 114-128 */ cTxt += Pad( :cCliBairro, 15 )
         /* 129-136 */ cTxt += Padl( SoNumeros( :cCliCep ), 8, "0" )
         /* 137-151 */ cTxt += Pad( :cCliCidade, 15 )
         /* 152-153 */ cTxt += Pad( :cCliUF, 2 )
         IF Empty( oBoleto:cAvalCnpj )
            /* 154-154 */ cTxt += iif( IsCnpj( :cEmpCnpj ), "2", "1" )
            /* 155-169 */ cTxt += Padl( SoNumeros( :cEmpCnpj ), 15, "0" )
            /* 170-209 */ cTxt += Pad( :cEmpNome, 40 )
         ELSE
            /* 154-154 */ cTxt += iif( IsCnpj( :cAvalCnpj ), "2", "1" )
            /* 155-169 */ cTxt += Padl( SoNumeros( :cAvalCnpj ), 15, "0" )
            /* 170-209 */ cTxt += Pad( :cAvalNome, 40 )
         ENDIF
         /* 210-221 */ cTxt += Replicate( "0", 12 )
         /* 222-240 */ cTxt += Space(19)
         cTxt += hb_Eol()

         IF ! Empty( oBoleto:nMulta )
            /* Detalhe R */
            /* 001-003 */ cTxt += StrZero( oBoleto:nBanco, 3 )
            /* 004-007 */ cTxt += StrZero( nLote, 4 )
            /* 008-008 */ cTxt += "3"
            /* 009-013 */ cTxt += StrZero( nSequencial++, 5 )
            /* 014-014 */ cTxt += "R"
            /* 015-015 */ cTxt += Space(1)
            /* 016-017 */ cTxt += "01"
            /* 018-018 */ cTxt += "0"
            /* 019-026 */ cTxt += StrZero( 0, 8 )
            /* 027-041 */ cTxt += StrZero( 0, 15 )
            /* 042-042 */ cTxt += "0"
            /* 043-050 */ cTxt += StrZero( 0, 8 )
            /* 051-065 */ cTxt += StrZero( 0, 15 )
            /* 066-066 */ cTxt += "1"
            /* 067-074 */ cTxt += hb_Dtoc( oBoleto:dDatVen + 5, "DDMMYYYY" )
            /* 075-089 */ cTxt += StrZero( oBoleto:nValor * oBoleto:nMulta, 15 )
            /* 090-099 */ cTxt += Space(10)
            /* 100-139 */ cTxt += Space(40)
            /* 140-179 */ cTxt += Space(40)
            /* 180-240 */ cTxt += Space(61)
            cTxt += hb_Eol()
         ENDIF
      ENDWITH
   NEXT

   oBoleto := aBoletoList[1]
   WITH OBJECT oBoleto
      /* trailer lote */
      /* 001-003 */ cTxt += StrZero( :nBanco, 3 )
      /* 004-007 */ cTxt += StrZero( nRemessa, 4 )
      /* 008-008 */ cTxt += "5"
      /* 009-017 */ cTxt += Space(9)
      /* 018-023 */ cTxt += StrZero( nSequencial + 1, 6 ) // incluindo header/trailer
      /* 24-240 */ cTxt += Space(217)
      cTxt += hb_Eol()

      /* trailer */
      /* 001-003 */ cTxt += StrZero( :nBanco, 3 )
      /* 004-007 */ cTxt += "9999"
      /* 008-008 */ cTxt += "9"
      /* 009-017 */ cTxt += Space(9)
      /* 018-023 */ cTxt += StrZero( 1, 6 )
      /* 024-029 */ cTxt += StrZero( nSequencial + 3, 6 )
      /* 030-240 */ cTxt += Space(211)
      cTxt += hb_Eol()
   ENDWITH

   RETURN cTxt
