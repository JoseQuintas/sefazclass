/*
Bradesco
Outubro/2023
*/

FUNCTION ze_Calculo237( SELF )

   ::cBancoDigito := "237-2"
   ::cLocalPagto  := "PAGÁVEL PREFERENCIALMENTE NA REDE BRADESCO OU BRADESCO EXPRESSO"
   ::cBolNumero := StrZero( ::nCarteira, 2 ) + "/" + ;
      StrZero( ::nBancario, 11 ) + "-" + ;
      ::Modulo11_237( StrZero( ::nCarteira, 2 ) + StrZero( ::nBancario, 11 ) )
   IF ::nFormato == 1
      // deu a entender que P é só quando for zero, mas não é, talvez seja o contrário
      ::cBolConta  := Transform( StrZero( ::nAgencia, 5 ), "@R 9999-9" ) + "/" + ;
         Left( StrZero( ::nConta, 8 ), 7 ) + "-P"
   ELSE
      ::cBolConta := StrZero( ::nAgencia, 4 ) + "/" + ;
         Transform( StrZero( ::nConta, 8 ), "@R 9999999-9" )
   ENDIF

   ::cBarras := StrZero( ::nBanco, 3 )
   ::cBarras += "9"
   ::cBarras += StrZero( ::nFatorVen, 4 )
   ::cBarras += StrZero( ::nValor * 100, 10 )
   IF ::nFormato == 1
      ::cBarras += Left( StrZero( ::nAgencia, 5 ), 4 )
   ELSE
      ::cBarras += StrZero( ::nAgencia, 4 )
   ENDIF
   ::cBarras += StrZero( ::nCarteira, 2 )
   ::cBarras += StrZero( ::nBancario, 11 )
   ::cBarras += Left( StrZero( ::nConta, 8 ), 7 )
   ::cBarras += "0"

   RETURN Nil

FUNCTION ze_Cnab237( aBoletoList )

   LOCAL cTxt, nSequencial := 1, oBoleto

   IF Empty( aBoletoList )
      RETURN Nil
   ENDIF
   IF ValType( aBoletoList ) != "A"
      aBoletoList := { aBoletoList }
   ENDIF
   //----- registro inicial ---
   oBoleto  := aBoletoList[1]
   WITH OBJECT oBoleto
      /*     */ cTxt := ""
      /* 001-001 */ cTxt += "0"                                // Fixo: 0=Registro inicial
      /* 002-002 */ cTxt += "1"                                // Fixo: ID Remessa
      /* 003-009 */ cTxt += "REMESSA"                          // Fixo: Decricao
      /* 010-011 */ cTxt += "01"                               // Fixo: Codigo de Servico
      /* 012-026 */ cTxt += Pad( "COBRANCA", 15 )              // Fixo: Literal Servico
      /* 027-036 */ cTxt += StrZero( 0, 10 )                   // se o código abaixo for muito grande
      /* 037-046 */ cTxt += StrZero( :nidEmpresa, 10 )  // Código da empresa no Bradesco
      /* 047-076 */ cTxt += Pad( oBoleto:cEmpNome, 30 )        // Nome da empresa
      /* 077-079 */ cTxt += StrZero( :nBanco, 3 )       // Fixo: Codigo do Banco
      /* 080-094 */ cTxt += Pad( "BRADESCO", 15 )              // Fixo: Nome do Banco
      /* 095-100 */ cTxt += hb_Dtoc( :dDatEmi, "DDMMYY" )        // Data da gravacao Dia/Mes/Ano, 2 digitos de cada
      /* 101-108 */ cTxt += Space(8)                           // Espacos
      /* 109-110 */ cTxt += "MX"                               // MX - olhar pag. 16, não tem nada
      /* 111-117 */ cTxt += StrZero( :nRemessa, 7 )        // Num. sequencial de remessa - olhar pag. 16 // nao pode pular, reiniciar ou zerar
      /* 118-394 */ cTxt += Space(277)                         // Espacos
      /* 395-400 */ cTxt += StrZero( nSequencial++, 6 )        // Num. sequencial de registro
      cTxt += hb_Eol()
   ENDWITH
   FOR EACH oBoleto IN aBoletoList
      IF oBoleto:nCarteira == 6
         LOOP
      ENDIF
      WITH OBJECT oBoleto
         // ----- registro detalhe -----
         /* 001-001 */ cTxt += "1"                                   // Fixo: 1=Movimentacao
         /* 002-006 */ cTxt += StrZero( 0, 5 )                       // Opcional: Agencia do Pagador
         /* 007-007 */ cTxt += "0"                                   // Opcional: Digito da Agencia do Pagador
         /* 008-012 */ cTxt += StrZero( 0, 5 )                       // Opcional: Razao da Conta do Pagador
         /* 013-019 */ cTxt += StrZero( 0, 7 )                       // Opcional: Número da Conta do Pagador
         /* 020-020 */ cTxt += "0"                                   // Optional: Digito do Número da Conta do Pagador
         /* 021-021 */ cTxt += "0"                                   // zero
         /* 022-024 */ cTxt += StrZero( :nCarteira, 3 )
         IF :nFormato == 1
            /* 025-029 */ cTxt += Left( StrZero( :nAgencia, 6 ), 5 )
            /* 030-037 */ cTxt += Left( StrZero( :nConta, 8 ), 7 ) + "P"
         ELSE
            /* 025-029 */ cTxt += StrZero( :nAgencia, 5 )
            /* 030-037 */ cTxt += StrZero( :nConta, 8 )
         ENDIF
         /* 038-062 */ cTxt += Space(25)                             // Número de controle do participante - olhar pag. 17
         /* 063-065 */ cTxt += StrZero( 0, 3 )                       // Codigo do banco a ser debitado - olhar pag.17
         /* 066-066 */ cTxt += iif( :nMulta == 0, "0", "2" )    // Multa, 2=percentual, 0=sem multa
         /* 067-070 */ cTxt += StrZero( :nMulta * 100, 4 )    // Percentual de multa - olhar pag 17
         /* 071-081 */ cTxt += StrZero( :nBancario, 11 ) // ID do titulo no banco - olhar pag. 17 - 10 caracteres + digito = 11 caracteres
         /* 082-082 */ cTxt += oBoleto:Modulo11_237( StrZero( :nCarteira, 2 ) + StrZero( :nBancario, 11 ) )  // Digito de controle da ID do titulo
         /* 083-092 */ cTxt += StrZero( 0, 10 )                      // Desconto Bonificacao por dia
         /* 093-093 */ cTxt += "2"                                   // 1=Banco emite, 2=Cliente emite - olhar pag. 19
         /* 094-094 */ cTxt += "N"                                   // N=Nao registra, outracoisa=banco emite para debito automatico - olhar pag. 19
         /* 095-104 */ cTxt += Space(10)                             // Brancos
         /* 105-105 */ cTxt += Space(1)                              // Indicacao de Rateio
         /* 106-106 */ cTxt += Space(1)                              // Enderecamento para aviso de debito
         /* 107-108 */ cTxt += Space(2)                              // Brancos
         /* 109-110 */ cTxt += "01"                                  // Identificacao da ocorrencia - 01=Remessa
         /* 111-120 */ cTxt += Pad( Right( :cNumDoc, 10 ), 10 )    // Número do documento
         /* 121-126 */ cTxt += hb_Dtoc( :dDatVen, "DDMMYY" )     // Data vencto DDMMAA
         /* 127-139 */ cTxt += StrZero( :nValor * 100, 13 )     // Valor do titulo
         /* 140-142 */ cTxt += StrZero( 0, 3 )                       // Zeros - Banco Encarregado da cobranca
         /* 143-147 */ cTxt += StrZero( 0, 5 )                       // Zeros - Agencia depositaria
         /* 148-149 */ cTxt += StrZero( :nEspecie, 2 )
         /* 150-150 */ cTxt += "N"                                   // Sempre N - identificacao
         /* 151-156 */ cTxt += hb_Dtoc( :dDatEmi, "DDMMYY" )       // Data de emissao do titulo DDMMAA
         //IF :nProtesto == 0
            /* 157-158 */ cTxt += "00"                                  // Instrucao - olhar pag. 20 // 00=nada,06=protestar,18=Baixar
            /* 159-160 */ cTxt += "00"                                  // Instrucao - olhar pag. 20 // complemento do anterior, indicando qtde. dias
         //ELSE
         //   cTxt += "06"
         //   cTxt += StrZero( :nProtesto, 2 )
         //ENDIF
         /* 161-173 */ cTxt += StrZero( Round( :nJuros * :nValor / 30, 0 ), 13 )    // Multa por dia - olhar pag. 21
         /* 174-179 */ cTxt += StrZero( 0, 6 )                       // Data limite pra desconto
         /* 180-192 */ cTxt += StrZero( 0, 13 )                      // Valor do desconto
         /* 193-205 */ cTxt += StrZero( 0, 13 )                      // Valor IOF
         /* 206-218 */ cTxt += StrZero( 0, 13 )                      // Valor Abatimento
         /* 219-220 */ cTxt += iif( IsCnpj( :cCliCnpj ), "02", "01" ) // 01=CPF, 02=CNPJ, 98=Nao tem, 99=Outros
         /* 221-234 */ cTxt += StrZero( Val( SoNumeros( :cCliCnpj ) ), 14 )  // Número do CPF ou CNPJ - olhar pag. 21
         /* 235-274 */ cTxt += Pad( :cCliNome, 40 )            // Nome do pagador
         /* 275-314 */ cTxt += Pad( :cCliEnd, 40 )            // Endereco do pagador
         /* 315-326 */ cTxt += Space(12)                             // Primeira mensagem
         /* 327-334 */ cTxt += SoNumeros( :cCliCep )          // CEP
         /* 335-394 */ cTxt += Space(60)                             // Sacador/Avalista ou segunda mensagem
         /* 395-400 */ cTxt += StrZero( nSequencial++, 6 )        // Número sequencial de registro
         cTxt += hb_Eol()
      ENDWITH
   NEXT
   // ----- registro final -----
   /* 001 */ cTxt += "9"                                   // Fixo: 9=Final
   /* 002 */ cTxt += Space(393)                            // Brancos
   /* 395 */ cTxt += StrZero( nSequencial, 6 )    // Número de registro
   cTxt += hb_Eol()
   IF nSequencial == 2
      cTxt := ""
   ENDIF

   RETURN cTxt
