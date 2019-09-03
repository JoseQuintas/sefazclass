/*
ZE_DIGITODOC - Checagem de dígitos de controle
José Quintas

2017.11.27 - Validação PIS
*/

STATIC FUNCTION ValidCnpj( cCnpj )

   LOCAL cNumero, lOk, cPicture := "@R 99.999.999/9999-99"

   cNumero := SoNumeros( cCnpj )
   cNumero := Left( cNumero + Replicate( "0", 12 ), 12 )
   cNumero := cNumero + CalculaDigito( cNumero, "11" )
   cNumero := cNumero + CalculaDigito( cNumero, "11" )
   lOk     := ( SoNumeros( cNumero ) == SoNumeros( cCnpj ) )
   IF lOk
      cCnpj := Pad( Transform( cCnpj, cPicture ), Max( 18, Len( cCnpj ) ) )
   ENDIF

   RETURN lOk

STATIC FUNCTION ValidCpf( cCpf )

   LOCAL cNumero, lOk, cPicture := "@R 999.999.999-99"

   cNumero := SoNumeros( cCpf )
   cNumero := Left( cNumero + Replicate( "0", 9 ), 9 )
   cNumero := cNumero + CalculaDigito( cNumero, "10" )
   cNumero := cNumero + CalculaDigito( cNumero, "10" )
   lOk     := ( SoNumeros( cCpf ) == SoNumeros( cNumero ) )
   IF lOk
      cCpf := Pad( Transform( cCpf, cPicture ), Max( 14, Len( cCpf ) ) )
   ENDIF

   RETURN lOk

FUNCTION ValidCnpjCpf( cCnpj )

   LOCAL lOk

   lOk := ( ValidCnpj( @cCnpj ) .OR. ValidCpf( @cCnpj ) )

   RETURN lOk

FUNCTION FormatCnpj( mCnpjCpf )

   LOCAL mPicture := "@X"

   mCnpjCpf := SoNumeros( mCnpjCpf )
   IF Len( Trim( mCnpjCpf ) ) == 14
      mPicture := "@R 99.999.999/9999-99"
   ELSEIF Len( Trim( mCnpjCpf ) ) == 11
      mPicture := "@R 999.999.999-99"
   ENDIF

   RETURN Pad( Transform( mCnpjCpf, mPicture ), 18 )

FUNCTION ValidRenavam( cRenavam )

   LOCAL nSoma, nCont, nDigito, lOk

   cRenavam := SoNumeros( cRenavam )
   cRenavam := StrZero( Val( cRenavam ), 11 )
   nSoma := 0
   FOR nCont = 1 To 10
      nSoma += ( Val( Substr( cRenavam, nCont, 1 ) ) * Val( Substr( "8923456789", nCont, 1 ) ) )
   NEXT
   nDigito := Mod( nSoma, 11 )
   nDigito := iif( nDigito == 10, 0, nDigito )
   lOk     := ( nDigito == Val( Right( cRenavam, 1 ) ) )

   RETURN lOk

FUNCTION ValidCnhAntiga( cPgu )

   LOCAL Result, PGU_Forn, Dig_Forn, Soma, Mult, J, Digito, Dig_Enc

   Result := .F.
   IF Len( AllTrim( cPgu ) ) != 9
      RETURN Result
   ENDIF
   PGU_Forn := Substr( cPgu, 1, 8 )
   Dig_Forn := Substr( cPgu, 9, 1 )
   Soma := 0
   Mult := 2
   FOR j := 1 to 8
      Soma := Soma + ( Val( Substr( PGU_Forn, j, 1 ) ) * Mult )
      Mult := Mult + 1
   NEXT
   Digito := Int( Mod( Soma, 11 ) )
   IF Digito > 9
      Digito := 0
   ENDIF
   Dig_Enc := AllTrim( Str( Digito ) )
   IF Dig_Forn = Dig_enc
      Result := .T.
   ENDIF
   IF Dig_Forn <> Dig_enc
      Result := .F.
   ENDIF

   RETURN Result

FUNCTION ValidCnhAtual( cCnh )

   LOCAL Result, Cnh_Forn, Dig_Forn, Incr_Dig2, Soma, Mult, J, Digito1, Digito2, Dig_Enc

   Result := .F.
   IF ! ( Len( AllTrim( cCnh ) ) ) = 11
      RETURN Result
   ENDIF
   CNH_Forn := Substr( cCnh, 1, 9 )
   Dig_Forn := Substr( cCnh, 10, 2 )
   Incr_Dig2 := 0
   Soma := 0
   Mult := 9
   FOR j := 1 to 9
      Soma := Soma + ( Val( Substr( CNH_Forn, j, 1 ) ) * Mult )
      Mult := Mult - 1
   NEXT
   Digito1 := Int( mod( Soma, 11 ) )
   IF Digito1 = 10
      Incr_Dig2 := -2
   ENDIF
   IF Digito1 > 9
      Digito1 := 0
   ENDIF
   Soma := 0
   Mult := 1
   FOR j := 1 to 9
      Soma := Soma + ( Val( Substr( CNH_Forn, j, 1 ) ) * Mult)
      Mult := Mult + 1
   NEXT
   IF Int( mod( Soma, 11 ) ) + Incr_Dig2 < 0
      Digito2 := 11 + Int( Mod( Soma, 11 ) ) + Incr_Dig2
   ELSE
      Digito2 := Int( Mod( Soma, 11 ) ) + Incr_Dig2
   ENDIF
   IF Digito2 > 9
      Digito2 := 0
   ENDIF
   Dig_Enc := AllTrim( Str( Digito1 ) ) + AllTrim( Str( Digito2 ) )
   IF Dig_Forn = Dig_enc
      Result := .T.
   ENDIF
   IF ! ( Dig_Forn = Dig_enc )
      Result := .F.
   ENDIF

   RETURN Result

FUNCTION ValidCnhImpresso( cNumero )

   LOCAL lOk := .F., nDigito

   cNumero = SoNumeros( cNumero )
   IF Len( cNumero ) <> 0
      nDigito := 11 - Mod( Val( Substr( cNumero, 1, Len( cNumero ) - 1 ) ), 11 )
      nDigito := iif( nDigito > 9, 0, nDigito )
      lOk := ( nDigito == Val( Substr( cNumero, Len( cNumero ), 1 ) ) )
   ENDIF

   RETURN lOk

FUNCTION ValidGTIN( cCodigo )

   LOCAL lOk := .T., nSoma := 0, nCont, nMultiplicador

   IF Val( cCodigo ) == 0
      cCodigo := Pad( "SEM GTIN", 14 )
   ELSE
      cCodigo := SoNumeros( cCodigo )
      cCodigo := Padl( cCodigo, 14, "0" )
      nMultiplicador = 3
      nSoma := 0
      FOR nCont = 1 To 13
         nSoma += ( Val( Substr( cCodigo, nCont, 1 ) ) * nMultiplicador )
         nMultiplicador := iif( nMultiplicador == 1, 3, 1 )
      NEXT
      nSoma := nSoma - ( Int( nSoma / 10 ) * 10 )
      IF nSoma != 0
         nSoma := 10 - nSoma
      ENDIF
      IF Right( cCodigo, 1 ) != Str( nSoma, 1 )
         lOk := .F.
      ENDIF
   ENDIF

   RETURN lOk

FUNCTION ValidCartao( mNumero )

   LOCAL nCont, mSoma := 0, mMultiplica := 2, lReturn, mSingleNumber, mResultado, mAdiciona

   FOR nCont = Len( Trim( mNumero ) ) - 1 TO 1 STEP -1
      mSingleNumber := Val( Substr( mNumero, nCont, 1 ) )
      mResultado    := mSingleNumber * mMultiplica
      mAdiciona     := Val( Right( Str( mResultado, 2 ), 1 ) )
      IF mResultado > 9
         mAdiciona += Val( Left( Str( mResultado, 2 ), 1 ) )
      ENDIF
      mSoma += mAdiciona
      mMultiplica := iif( mMultiplica == 2, 1, 2 )
   NEXT
   mSoma := Mod( mSoma, 10 )
   mSoma := iif( mSoma == 0, 0, 10 - mSoma )

   lReturn := Str( mSoma, 1 ) == Substr( mNumero, Len( Trim( mNumero ) ), 1 )

   RETURN lReturn

FUNCTION CalculaDigito( cNumero, cModulo )

   LOCAL nFator, nCont, nSoma, nResto, nModulo, cCalculo

   IF Empty( cNumero )
      RETURN ""
   ENDIF
   cCalculo := AllTrim( cNumero )
   IF cModulo $ "10,11"
      nModulo := Val( cModulo )
      nFator  := 2
      nSoma   := 0
      IF nModulo == 10
         FOR nCont = Len( cCalculo ) To 1 Step -1
            nSoma += Val( Substr( cCalculo, nCont, 1 ) ) * nFator
            nFator += 1
         NEXT
      ELSE
         FOR nCont = Len( cCalculo ) To 1 Step -1
            nSoma += Val( Substr( cCalculo, nCont, 1 ) ) * nFator
            IF nFator == 9
               nFator := 2
            ELSE
               nFator += 1
            ENDIF
         NEXT
      ENDIF
      nResto := nSoma - ( Int( nSoma / 11 ) * 11 )
      nResto := 11 - nResto
      IF nResto > 9
         nResto := 0
      ENDIF
      cCalculo := Str(nResto,1)
   ENDIF

   RETURN cCalculo

FUNCTION ValidPis( cPis )

   LOCAL nTotal, nPeso, nResto, nCont, lOk

   cPis := SoNumeros( cPis )
   IF Len( cPis ) != 11
      RETURN .F.
   ENDIF

   nTotal := 0
   nPeso  := 2
   FOR nCont = 10 TO 1 STEP -1
      nTotal += Val( Substr( cPis, nCont, 1 ) ) * nPeso
      nPeso := iif( nPeso == 9, 2, nPeso + 1 )
   NEXT
   nResto := Mod( nTotal, 11 )
   IF nResto <= 1
      nResto := 0
   ELSE
      nResto := 11 - Mod( nTotal, 11 )
   ENDIF
   lOk    := Right( cPis, 1 ) == Str( nResto, 1 )

   RETURN lOk
