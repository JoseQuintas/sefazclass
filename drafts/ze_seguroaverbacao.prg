/*
9     Código da Empresa Averbação Exemplo 0-PRÓPRIA,1-AT&M 2-QUORUM 3-GEP, 4-ELT
9(9)  Número do documento
9(2)  Modelo 57=CTE, 55=NFE, 99=Outros
9(3)  Série padrão 001
9(14) CNPJ Emissor do documento, invertido, escrito de trás pra frente
9(5)  Código SUSEP da seguradora com o dígito verificador
9(4)  Mês e ano da vigência final da apólice MMYY
9(2)  Dígitos verificadores
Total: 40 caracteres

fonte de referência: http://www.lex.com.br/legis_27520186_DELIBERACAO_N_325_DE_28_DE_SETEMBRO_DE_2017.aspx
*/

PROCEDURE Main

   LOCAL cNumero := "10000234375788918100013162590000001217"

   SetMode( 40, 100 )
   ? cNumero
   ? ValidSeguroAverbacao( @cNumero, .T. )
   ? cNumero
   ? ValidSeguroAverbacao( cNumero )
   Inkey(0)

FUNCTION ValidSeguroAverbacao( cAverbacao, lAdicionaDigito )

   LOCAL nFator, nResult, nDigito1, nDigito2, oElement

   hb_Default( @lAdicionaDigito, .F. )

   IF Len( cAverbacao ) != 40 .AND. ( Len( cAverbacao ) != 38 .OR. ! lAdicionaDigito )
      RETURN .F.
   ENDIF

   nFator  := 0
   nResult := 0
   FOR EACH oElement IN Left( cAverbacao, 38 ) DESCEND
      nFator  := iif( nFator == 9, 1, nFator + 1 )
      nResult += nFator * Val( oElement )
   NEXT
   nResult  := nResult - ( Int( nResult / 11 ) * 11 )
   nDigito1 := iif( nResult < 2, 0, 11 - nResult )
   IF lAdicionaDigito
      cAverbacao += Str( nDigito1, 1 )
   ENDIF

   IF nDigito1 != Val( Substr( cAverbacao, 39, 1 ) )
      RETURN .F.
   ENDIF

   nFator  := 0
   nResult := 0
   FOR EACH oElement IN Left( cAverbacao, 39 ) DESCEND
      nFator  :=  iif( nFator == 9, 1, nFator + 1 )
      nResult += nFator * Val( oElement )
   NEXT
   nResult  := nResult - ( Int( nResult / 11 ) * 11 )
   nDigito2 := iif( nResult < 2, 0, 11 - nResult )
   IF lAdicionaDigito
      cAverbacao += Str( nDigito2, 1 )
   ENDIF

   IF Right( cAverbacao, 2 ) != Str( nDigito1, 1 ) + Str( nDigito2, 1 )
      RETURN .F.
   ENDIF

   RETURN .T.
