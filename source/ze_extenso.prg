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

#define EXTENSO_UNIDADE { "UM", "DOIS", "TRES", "QUATRO", "CINCO", "SEIS", ;
      "SETE", "OITO", "NOVE", "DEZ", "ONZE", "DOZE", "TREZE", ;
      "QUATORZE", "QUINZE", "DEZESSEIS", "DEZESSETE", "DEZOITO", ;
      "DEZENOVE" }

#define EXTENSO_DEZENA { "DEZ", "VINTE", "TRINTA", "QUARENTA", "CINQUENTA", "SESSENTA", ;
      "SETENTA", "OITENTA", "NOVENTA" }

#define EXTENSO_CENTENA { "CENTO", "DUZENTOS", "TREZENTOS", "QUATROCENTOS", ;
      "QUINHENTOS", "SEISCENTOS", "SETECENTOS", "OITOCENTOS", ;
      "NOVECENTOS" }

#define EXTENSO_GRUPO { "MIL", "MILHAO", "BILHAO", "TRILHAO", "QUATRILHAO", ;
      "QUINTILHAO", "SEPTILHAO", "OCTILHAO", "NONILHAO", "DECILHAO" }

#define EXTENSO_MES { "JANEIRO", "FEVEREIRO", "MARCO", "ABRIL", "MAIO", "JUNHO", "JULHO", ;
      "AGOSTO", "SETEMBRO", "OUTUBRO", "NOVEMBRO", "DEZEMBRO" }

#define EXTENSO_SEMANA { "", "DOMINGO", "SEGUNDA", "TERCA", "QUARTA", "QUINTA", "SEXTA", "SABADO" }

FUNCTION ExtensoDolar( nValor )

   LOCAL cTxt

   cTxt := Extenso( nValor )
   cTxt := StrTran( cTxt, "REAIS", "DOLARES" )
   cTxt := StrTran( cTxt, "REAL", "DOLAR" )

   RETURN cTxt

FUNCTION Extenso( xValue, xFull )

   LOCAL cTxt := "", oExtenso := ExtensoClass():New()

   hb_Default( @xFull, .F. )

   IF ValType( xValue ) == "N"
      cTxt := oExtenso:Extenso( xValue )
   ELSEIF ValType( xValue ) == "D"
      IF ! xFull
         cTxt := StrZero( Day( xValue ), 2 ) + " de " + NomeMes( xValue ) + " de " + StrZero( Year( xValue ), 4 )
      ELSE
         cTxt := oExtenso:Extenso( Day( xValue ) )
         cTxt += " DE " + Nomemes( xValue ) + " DE "
         cTxt += oExtenso:Extenso( Year( xValue ) )
         DO WHILE Space(2) $ cTxt
            cTxt := StrTran( cTxt, Space(2), Space(1) )
         ENDDO
      ENDIF
   ENDIF

   RETURN cTxt

CREATE CLASS ExtensoClass STATIC

   METHOD Extenso( nValor )
   METHOD ExtensoUnidade( nValor )
   METHOD ExtensoDezena( nValor )
   METHOD ExtensoCentena( nValor )
   METHOD ExtensoGrupoMilhar( nPosicao, nValor )
   METHOD ExtensoBloco( cValor )

   ENDCLASS

METHOD Extenso( nValor ) CLASS ExtensoClass

   LOCAL cTxt, cStrValor, cBlocoValor, nCont, lNegativo

   cTxt      := ""
   lNegativo := ( nValor < 0 )
   nValor    := Abs( nValor )
   cStrValor := Str( nValor, 18, 2 )
   FOR nCont = 1 TO 6
      cBlocoValor := Substr( cStrValor, nCont * 3 - 2, 3 )
      IF Val( cBlocoValor ) != 0
         cTxt += ::ExtensoBloco( cBlocoValor ) + ::ExtensoGrupoMilhar( 5 - nCont, Val( cBlocoValor ) ) + iif( nCont > 4, "", " " )
      ENDIF
      IF nCont == 5
         IF Int( nValor ) > 0
            cTxt += iif( int( nValor ) == 1, "REAL", "REAIS" ) + " "
         ENDIF
      ELSEIF nCont == 6
         IF Val( cBlocoValor ) > 0
            cTxt += iif( Val( cBlocoValor ) == 1, "CENTAVO", "CENTAVOS" ) +  " "
         ENDIF
      ENDIF
   NEXT
   IF "ILHAO REAIS" $ cTxt .OR. "ILHOES REAIS" $ cTxt
      cTxt := StrTran( cTxt, "REAIS", "DE REAIS" )
   ENDIF
   IF Left( cTxt, 2 ) == "E "
      cTxt := Substr( cTxt, 3 )
   ENDIF
   cTxt := iif( lNegativo, "*NEGATIVO*", "" ) + cTxt

   RETURN cTxt

METHOD ExtensoUnidade( nValor ) CLASS ExtensoClass

   IF nValor < 0 .OR. nValor > 19
      RETURN ""
   ENDIF

   RETURN EXTENSO_UNIDADE[ nValor ]

METHOD ExtensoDezena( nValor ) CLASS ExtensoClass

   IF nValor < 1 .OR. nValor > 9
      RETURN ""
   ENDIF

   RETURN EXTENSO_DEZENA[ nValor ]

METHOD ExtensoCentena( nValor ) CLASS ExtensoClass

   IF nValor < 1 .OR. nValor > 9
      RETURN ""
   ENDIF

   RETURN EXTENSO_CENTENA[ nValor ]

METHOD ExtensoGrupoMilhar( nPosicao, nValor ) CLASS ExtensoClass

   LOCAL cTxt

   IF nPosicao < 1 .OR. nPosicao > 10
      RETURN ""
   ENDIF

   cTxt := EXTENSO_GRUPO[ nPosicao ]
   IF nValor > 1
      cTxt := StrTran( cTxt, "LHAO", "LHOES" )
   ENDIF

   RETURN cTxt

METHOD ExtensoBloco( cValor ) CLASS ExtensoClass

   LOCAL nCentena, nDezena, nUnidade, cTxt

   nCentena := Val( Substr( cValor, 1, 1 ) )
   nDezena  := Val( Substr( cValor, 2, 1 ) )
   nUnidade := Val( Substr( cValor, 3, 1 ) )
   cTxt = ""
   IF nDezena == 0 .AND. nUnidade == 0
      cTxt += "E " + iif( nCentena == 1, "CEM", ::ExtensoCentena( nCentena ) ) + " "
   ELSE
      IF nCentena > 0
         cTxt += "E " + ::ExtensoCentena( nCentena ) + " "
      ENDIF
      IF nDezena < 2
         cTxt += "E " + ::ExtensoUnidade( nDezena * 10 + nUnidade ) + " "
      ELSE
         cTxt += "E " + ::ExtensoDezena( nDezena )  + " "
         IF nUnidade > 0
            cTxt += "E " + ::ExtensoUnidade( nUnidade ) + " "
         ENDIF
      ENDIF
   ENDIF

   RETURN cTxt

FUNCTION NomeMes( xMes )

   LOCAL cNomeMes := ""

   IF ValType( xMes ) == "D"
      xMes := Month( xMes )
   ENDIF
   DO WHILE xMes > 12
      xMes -= 12
   ENDDO
   IF xMes > 0
      cNomeMes := EXTENSO_MES[ xMes ]
   ENDIF

   RETURN cNomeMes

FUNCTION NomeSemana( dData )

   RETURN EXTENSO_SEMANA[ Dow( dData ) + 1 ]
