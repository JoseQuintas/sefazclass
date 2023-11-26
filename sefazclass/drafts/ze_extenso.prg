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
         cTxt := StrTran( cTxt, "DE REAIS", "" )
         cTxt := StrTran( cTxt, "REAIS", "" )
         cTxt := StrTran( cTxt, "REAL", "" )
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

   LOCAL cTxt := ""

   DO CASE
   CASE nValor == 1;  cTxt := "UM"
   CASE nValor == 2;  cTxt := "DOIS"
   CASE nValor == 3;  cTxt := "TRES"
   CASE nValor == 4;  cTxt := "QUATRO"
   CASE nValor == 5;  cTxt := "CINCO"
   CASE nValor == 6;  cTxt := "SEIS"
   CASE nValor == 7;  cTxt := "SETE"
   CASE nValor == 8;  cTxt := "OITO"
   CASE nValor == 9;  cTxt := "NOVE"
   CASE nValor == 10; cTxt := "DEZ"
   CASE nValor == 11; cTxt := "ONZE"
   CASE nValor == 12; cTxt := "DOZE"
   CASE nValor == 13; cTxt := "TREZE"
   CASE nValor == 14; cTxt := "QUATORZE"
   CASE nValor == 15; cTxt := "QUINZE"
   CASE nValor == 16; cTxt := "DEZESSEIS"
   CASE nValor == 17; cTxt := "DEZESSETE"
   CASE nValor == 18; cTxt := "DEZOITO"
   CASE nValor == 19; cTxt := "DEZENOVE"
   ENDCASE

   RETURN cTxt

METHOD ExtensoDezena( nValor ) CLASS ExtensoClass

   LOCAL cTxt := ""

   DO CASE
   CASE nValor == 2; cTxt := "VINTE"
   CASE nValor == 3; cTxt := "TRINTA"
   CASE nValor == 4; cTxt := "QUARENTA"
   CASE nValor == 5; cTxt := "CINQUENTA"
   CASE nValor == 6; cTxt := "SESSENTA"
   CASE nValor == 7; cTxt := "SETENTA"
   CASE nValor == 8; cTxt := "OITENTA"
   CASE nValor == 9; cTxt := "NOVENTA"
   ENDCASE

   RETURN cTxt

METHOD ExtensoCentena( nValor ) CLASS ExtensoClass

   LOCAL cTxt := ""

   DO CASE
   CASE nValor == 1; cTxt := "CENTO"
   CASE nValor == 2; cTxt := "DUZENTOS"
   CASE nValor == 3; cTxt := "TREZENTOS"
   CASE nValor == 4; cTxt := "QUATROCENTOS"
   CASE nValor == 5; cTxt := "QUINHENTOS"
   CASE nValor == 6; cTxt := "SEISCENTOS"
   CASE nValor == 7; cTxt := "SETECENTOS"
   CASE nValor == 8; cTxt := "OITOCENTOS"
   CASE nValor == 9; cTxt := "NOVECENTOS"
   ENDCASE

   RETURN cTxt

METHOD ExtensoGrupoMilhar( nPosicao, nValor ) CLASS ExtensoClass

   LOCAL cTxt := ""

   DO CASE
   CASE nPosicao == 1;  cTxt := "MIL"
   CASE nPosicao == 2;  cTxt := "MILHAO"
   CASE nPosicao == 3;  cTxt := "BILHAO"
   CASE nPosicao == 4;  cTxt := "TRILHAO"
   CASE nPosicao == 5;  cTxt := "QUATRILHAO"
   CASE nPosicao == 6;  cTxt := "QUINTILHAO"
   CASE nPosicao == 7;  cTxt := "SEPTILHAO"
   CASE nPosicao == 8;  cTxt := "OCTILHAO"
   CASE nPosicao == 9;  cTxt := "NONILHAO"
   CASE nPosicao == 10; cTxt := "DECILHAO"
   ENDCASE
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

   LOCAL aMeses, cNomeMes := ""

   aMeses := { "JANEIRO", "FEVEREIRO", "MARCO", "ABRIL", "MAIO", "JUNHO", "JULHO", "AGOSTO", "SETEMBRO", "OUTUBRO", "NOVEMBRO", "DEZEMBRO" }
   IF ValType( xMes ) == "D"
      xMes := Month( xMes )
   ENDIF
   DO WHILE xMes > 12
      xMes -= 12
   ENDDO
   IF xMes > 0
      cNomeMes := aMeses[ xMes ]
   ENDIF

   RETURN cNomeMes

FUNCTION NomeSemana( dData )

   LOCAL acText := { "", "DOMINGO", "SEGUNDA", "TERCA", "QUARTA", "QUINTA", "SEXTA", "SABADO" }

   RETURN acText[ Dow( dData ) + 1 ]
