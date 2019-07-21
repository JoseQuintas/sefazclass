/*
ZE_EXTENSO - EXTENSO DE VALORES
1990.01.28 José Quintas
*/

#include "hbclass.ch"

/* Moedas:
00/00/0000 a 07/10/1833 R    Real/Reis
08/10/1833 a 31/10/1942 Rs   Conto de Reis    1 Rs  = 1000R
01/11/1942 a 12/02/1967 Cr$  Cruzeiro         1 Cr$ = 1 Rs
13/02/1967 a 14/05/1970 NCr$ Cruzeiro Novo    1 NCr$= 1000 Cr$
15/05/1970 a 27/02/1986 Cr$  Cruzeiro         1 Cr$ = 1 Ncr$
28/02/1986 a 15/01/1989 Cz$  Cruzado          1 Cz$ = 1000 Cr$
16/01/1989 a 15/03/1990 NCz$ Cruzado Novo     1 Ncz$= 1000 Cz$
16/03/1990 a 31/07/1993 Cr$  Cruzeiro         1 Cr$ = 1 NCz$
01/08/1993 a 30/06/1994 CR$  Cruzeiro Real    1 CR$ = 10 Cr$
01/07/1994 a atual      R$   Real             1 R$  = 2750 CR$
*/

FUNCTION NomeMes( dData )

   RETURN ze_ExtensoMes( dData )

FUNCTION NomeSemana( dData )

   RETURN ze_ExtensoSemana( dData )

FUNCTION ExtensoDolar( nValor )

   LOCAL cTxt

   cTxt := Extenso( nValor )
   cTxt := StrTran( cTxt, "REAIS", "DOLARES" )
   cTxt := StrTran( cTxt, "REAL", "DOLAR" )

   RETURN cTxt

FUNCTION Extenso( xValue, xFull )

   LOCAL cTxt := ""

   hb_Default( @xFull, .F. )

   IF ValType( xValue ) == "N"
      cTxt := ze_ExtensoDinheiro( xValue )
   ELSEIF ValType( xValue ) == "D"
      IF ! xFull
         cTxt := StrZero( Day( xValue ), 2 ) + " DE " + ze_ExtensoMes( xValue ) + " DE " + StrZero( Year( xValue ), 4 )
      ELSE
         cTxt := ze_ExtensoNumero( Day( xValue ) )
         cTxt += " DE " + ze_ExtensoMes( xValue ) + " DE "
         cTxt += ze_ExtensoNumero( Year( xValue ) )
         DO WHILE Space(2) $ cTxt
            cTxt := StrTran( cTxt, Space(2), Space(1) )
         ENDDO
      ENDIF
   ENDIF

   RETURN cTxt

FUNCTION ze_ExtensoDinheiro( nValor )

   LOCAL cTxt := "", cStrValor, nInteiro, nDecimal

   nValor    := Abs( nValor )
   cStrValor := Str( nValor, 18, 2 )
   nInteiro  := Val( Substr( cStrValor, 1, At( ".", cStrValor ) - 1 ) )
   nDecimal  := Val( Substr( cStrValor, At( ".", cStrValor ) + 1 ) )
   IF nInteiro != 0 .OR. nDecimal == 0
      cTxt += ze_ExtensoNumero( nInteiro ) + " " + iif( nInteiro == 1, "REAL", "REAIS" )
   ENDIF
   IF nDecimal != 0
      IF nInteiro != 0
         cTxt += " E "
      ENDIF
      cTxt += ze_ExtensoNumero( nDecimal ) + " " + iif( nDecimal == 1, "CENTAVO", "CENTAVOS" )
   ENDIF

   RETURN cTxt

STATIC FUNCTION ze_ExtensoNumero( nValor, nGrupo )

   LOCAL cTxt := "", cStrValor, nCentena, nResto, cTxtGrupo := "", lNegativo
   LOCAL aList := { "", "MIL", "MILHAO", "BILHAO", "TRILHAO", "QUATRILHAO", ;
      "QUINTILHAO", "SEPTILHAO", "OCTILHAO", "NONILHAO", "DECILHAO" }

   hb_Default( @nGrupo, 1 )
   lNegativo := ( nValor < 0 )
   nValor    := Abs( nValor )
   cStrValor := StrZero( nValor, 16 )
   nCentena  := Val( Right( cStrValor, 3 ) )
   nResto    := Val( Substr( cStrValor, 1, Len( cStrValor ) - 3 ) )
   IF nCentena != 0
      IF nCentena > 0
         cTxtGrupo := aList[ nGrupo ]
         IF nCentena > 1
            cTxtGrupo := StrTran( cTxtGrupo, "LHAO", "LHOES" )
         ENDIF
      ENDIF
      cTxt := ze_ExtensoCentena( nCentena ) + " " + cTxtGrupo
   ENDIF
   IF nResto != 0 .AND. nGrupo < Len( aList )
      cTxt := ze_ExtensoNumero( nResto, nGrupo + 1 ) + " E " + cTxt
   ENDIF
   IF nGrupo == 1
      IF nValor == 0
         cTxt := "ZERO"
      ENDIF
      cTxt := iif( lNegativo, "*NEGATIVO* ", "" ) + AllTrim( cTxt )
   ENDIF

   RETURN cTxt

STATIC FUNCTION ze_ExtensoUnidade( nValor )

   LOCAL aList := { "UM", "DOIS", "TRES", "QUATRO", "CINCO", "SEIS", ;
      "SETE", "OITO", "NOVE", "DEZ", "ONZE", "DOZE", "TREZE", ;
      "QUATORZE", "QUINZE", "DEZESSEIS", "DEZESSETE", "DEZOITO", ;
      "DEZENOVE" }

   RETURN aList[ nValor ]

STATIC FUNCTION ze_ExtensoDezena( nValor )

   LOCAL aList := { "DEZ", "VINTE", "TRINTA", "QUARENTA", "CINQUENTA", "SESSENTA", ;
      "SETENTA", "OITENTA", "NOVENTA" }
   LOCAL cTxt := "", nDezena, nUnidade

   IF nValor > 0
      nDezena := Int( nValor / 10 )
      nUnidade := Mod( nValor, 10 )
      IF nValor < 20
         cTxt += ze_ExtensoUnidade( nValor )
      ELSE
         cTxt += aList[ nDezena ]
         IF nUnidade != 0
            cTxt += " E " + ze_ExtensoUnidade( nUnidade )
         ENDIF
      ENDIF
   ENDIF

   RETURN cTxt

STATIC FUNCTION ze_ExtensoCentena( nValor )

   LOCAL aList := { "CENTO", "DUZENTOS", "TREZENTOS", "QUATROCENTOS", ;
      "QUINHENTOS", "SEISCENTOS", "SETECENTOS", "OITOCENTOS", ;
      "NOVECENTOS" }
   LOCAL nCentena, nDezena, cTxt := ""

   nCentena := Int( nValor / 100 )
   nDezena  := Mod( nValor, 100 )
   IF nValor > 0
      IF nCentena == 1 .AND. nDezena == 0
         cTxt += "CEM"
      ELSE
         IF nCentena != 0
            cTxt += aList[ nCentena ]
         ENDIF
         IF nDezena != 0
            IF nCentena != 0
               cTxt += " E "
            ENDIF
            cTxt += ze_ExtensoDezena( nDezena )
         ENDIF
      ENDIF
   ENDIF

   RETURN cTxt

STATIC FUNCTION ze_ExtensoMes( xMes )

   LOCAL cNomeMes := ""
   LOCAL aList := { "JANEIRO", "FEVEREIRO", "MARCO", "ABRIL", "MAIO", "JUNHO", "JULHO", ;
      "AGOSTO", "SETEMBRO", "OUTUBRO", "NOVEMBRO", "DEZEMBRO" }

   IF ValType( xMes ) == "D"
      xMes := Month( xMes )
   ENDIF
   DO WHILE xMes > 12
      xMes -= 12
   ENDDO
   IF xMes > 0
      cNomeMes := aList[ xMes ]
   ENDIF

   RETURN cNomeMes

STATIC FUNCTION ze_ExtensoSemana( dData )

   LOCAL aList := { "", "DOMINGO", "SEGUNDA", "TERCA", "QUARTA", "QUINTA", "SEXTA", "SABADO" }

   RETURN aList[ Dow( dData ) + 1 ]

