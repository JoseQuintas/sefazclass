#include "hbclass.ch"

CREATE CLASS BoletoClass

   VAR    nBanco       INIT 0 // Conforme banco, não é o que parece
   VAR    nAgencia     INIT 0 // Conforme banco, não é o que parece
   VAR    nConta       INIT 0 // Conforme banco, não é o que parece
   VAR    nCarteira    INIT 0
   VAR    cAceite      INIT "N"
   VAR    cNumDoc      INIT "" // Tem banco que limita a números
   VAR    cNumDocAux   INIT ""
   VAR    nBancario    INIT 0 // Itaú limitado a 8 dígitos
   VAR    dDatEmi      INIT Date()
   VAR    dDatVen      INIT Date()
   VAR    nValor       INIT 0
   VAR    nJuros       INIT 0
   VAR    nMulta       INIT 0
   VAR    nProtesto    INIT 0  // inicialmente Santander, dias corridos
   VAR    cEmpNome     INIT ""
   VAR    cEmpCnpj     INIT ""
   VAR    cEmpEnd      INIT ""
   VAR    cEmpBairro   INIT ""
   VAR    cEmpCidade   INIT ""
   VAR    cEmpUF       INIT ""
   VAR    cEmpCEP      INIT ""
   VAR    cCliNome     INIT ""
   VAR    cCliCnpj     INIT ""
   VAR    cCliEnd      INIT ""
   VAR    cCliBairro   INIT ""
   VAR    cCliCidade   INIT ""
   VAR    cCliUF       INIT ""
   VAR    cCliCEP      INIT ""
   VAR    cCliEmail    INIT ""
   VAR    cAvalNome    INIT ""
   VAR    cAvalCnpj    INIT ""
   VAR    nFormato     INIT 0 // Pra exceções temporárias ou não
   // ver manual do banco
   VAR    nMoeda       INIT 9    // No boleto é sempre real
   VAR    nEspecie     INIT 1    // Duplicata mercantil
   VAR    cBolEspecie  INIT "DM" // para o PDF
   VAR    nIdEmpresa   INIT 0    // alguns bancos
   VAR    aMsgCodList  INIT { Space(2), Space(2) } // alguns bancos
   VAR    aMsgTxtList  INIT {}   // alguns bancos
   VAR    cPixCode     INIT ""   // ver banco
   VAR    nRemessa     INIT 1    // ver banco
   // Preenchidos por Calculo() e usados no PDF/boleto
   VAR    cBolNumero   INIT ""
   VAR    cBolConta    INIT ""
   VAR    cBancoDigito INIT ""
   VAR    cBancoNome   INIT ""
   VAR    cLocalPagto  INIT ""
   VAR    cBarras      INIT ""
   VAR    cDigitavel   INIT ""
   VAR    nFatorVen    INIT 0

   METHOD Calcula()
   METHOD Modulo10_All( cNumero )       INLINE Modulo10_All( cNumero )
   METHOD Modulo11_All( cNumero )       INLINE Modulo11_All( cNumero )
   METHOD Modulo11_033( cNumero )       INLINE Modulo11_033( cNumero )
   METHOD Modulo11_237( cNumero )       INLINE Modulo11_237( cNumero )
   METHOD GeraCnab( aBoletoList )

   ENDCLASS

METHOD GeraCnab( aBoletoList ) CLASS BoletoClass

   LOCAL nBanco

   IF Len( aBoletoList ) > 0
      nBanco := aBoletoList[ 1 ]:nBanco
      DO CASE
      CASE nBanco == 33; RETURN ze_Cnab033( aBoletoList )
      CASE nBanco == 237; RETURN ze_Cnab237( aBoletoList )
      CASE nBanco == 341; RETURN ze_Cnab341( aBoletoList )
      CASE nBanco == 422; RETURN ze_Cnab422( aBoletoList )
      ENDCASE
   ENDIF

   RETURN "BANCO NAO DISPONIVEL"

METHOD Calcula() CLASS BoletoClass

   LOCAL cCampoLivre

   ::nFatorVen   := ::dDatVen - Stod( "19971007" )
   DO WHILE ::nFatorVen > 9999
      ::nFatorVen -= 9000
   ENDDO

   DO CASE
   CASE ::nBanco == 33;  ze_Calculo033( Self )
   CASE ::nBanco == 237; ze_Calculo237( Self )
   CASE ::nBanco == 341; ze_Calculo341( Self )
   CASE ::nBanco == 422; ze_Calculo422( Self )
   OTHERWISE
      ze_Calculo000( Self )
   ENDCASE

   // dígito igual pra todos os bancos
   ::cBarras     := Stuff( ::cBarras, 5, 0, ::Modulo11_All( ::cBarras ) )

   // linha digitável igual pra todos os bancos
   cCampoLivre  := Substr( ::cBarras, 20 )
   ::cDigitavel := Substr( ::cBarras, 1, 4 ) + Substr( cCampoLivre, 1, 5 )
   ::cDigitavel += ::Modulo10_All( ::cDigitavel )
   ::cDigitavel += Substr( cCampoLivre, 6, 10 )  + ::Modulo10_All( Substr( cCampoLivre, 6, 10 ) )
   ::cDigitavel += Substr( cCampoLivre, 16, 10 ) + ::Modulo10_All( Substr( cCampoLivre, 16, 10 ) )
   ::cDigitavel += Substr( ::cBarras, 5, 1 )
   ::cDigitavel += Substr( ::cBarras, 6, 14 )

   RETURN Nil

// genérico, usado na linha digitável
STATIC FUNCTION Modulo10_All( cNumero )

   LOCAL nFator := 2, nSoma := 0, cValor, nResto, cDigito

   FOR EACH cDigito IN cNumero DESCEND
      cValor := StrZero( Val( cDigito ) * nFator, 2 )
      nSoma  += ( Val( Substr( cValor, 1, 1 ) ) + Val( Substr( cValor, 2, 1 ) ) )
      nFator := iif( nFator == 2, 1, 2 )
   NEXT
   nResto := 10 - Mod( nSoma, 10 )
   nResto := iif( nResto == 10, 0, nResto )
   cDigito := Str( nResto, 1 )

   RETURN cDigito

// genérico, usado no código de barras
STATIC FUNCTION Modulo11_All( cNumero )

   LOCAL nFator := 2, nSoma := 0, nResto, cDigito

   FOR EACH cDigito IN cNumero DESCEND
      nSoma += ( Val( cDigito ) * nFator )
      nFator := iif( nFator == 9, 2, nFator + 1 )
   NEXT
   nResto  := 11 - Mod( nSoma, 11 )
   nResto  := iif( nResto == 0 .OR. nResto > 9, 1, nResto )
   cDigito := Str( nResto, 1 )

   RETURN cDigito

// Santander 033 Nosso Numero
STATIC FUNCTION Modulo11_033( cNumero )

   LOCAL nFator := 2, nSoma := 0, cDigito

   FOR EACH cDigito IN cNumero DESCEND
      nSoma += ( Val( cDigito ) * nFator )
      nFator := iif( nFator == 9, 2, nFator + 1 )
   NEXT
   nSoma := 11 - Mod( nSoma, 11 )
   nSoma := iif( nSoma > 9, 0, nSoma )
   cDigito := Str( nSoma, 1 )

   RETURN cDigito

// Bradesco 237 Nosso Numero
STATIC FUNCTION Modulo11_237( cNumero )

   LOCAL nSoma := 0, nResto, cDigito, nFator := 2

   FOR EACH cDigito IN cNumero DESCEND
      nSoma  += Val( cDigito ) * nFator
      nFator := iif( nFator == 7, 2, nFator + 1 )
   NEXT
   nResto := 11 - Mod( nSoma, 11 )
   IF nResto == 11
      cDigito := "0"
   ELSEIF nResto == 10
      cDigito := "P"
   ELSE
      cDigito := Str( nResto, 1 )
   ENDIF

   RETURN cDigito

STATIC FUNCTION ze_Calculo000( Self )

   ::cBancoDigito := "ERRO"
   ::cLocalPagto  := "INVALIDO"
   ::cBarras      := Replicate( "0", 43 )
   ::cBolNumero   := "INVALIDO"
   ::cBolConta    := "INVALIDO"

   RETURN Nil

/*
Anotação

STATIC FUNCTION CampoCNAB( nIni, nFim, xValue )

   LOCAL nLen

   nLen := nFim - nIni + 1

   IF ValType( xValue ) == "N"
      xValue := StrZero( xValue, nLen )
   ELSE
      xValue := Pad( xValue, nLen )
   ENDIF

   RETURN nLen
*/

/*
Bradesco nFormato 1 - com P no dígito da conta mas cadastra com zero
*/

