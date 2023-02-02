/*
REQUEST HB_CODEPAGE_PTISO

FUNCTION Main()

   SetMode( 25, 80 )
   CLS
   ? AliquotaICMS( "SP", "SP" )
   ? AliquotaICMS( "SP", "GO" )
   ? AliquotaICMS( "PR", "GO" )
   ? AliquotaICMS( "GO", "GO" )
   Inkey(0)

   RETURN Nil
*/

FUNCTION ze_AliquotaICMS( cUF1, cUF2 )

   LOCAL nPos, nAliquota, bCode
   LOCAL aList := { ;
      { "AC", "AC", 12 }, ;
      { "AL", "AL", 18 }, ;
      { "AM", "AM", 18 }, ;
      { "AP", "AP", 18 }, ;
      { "BA", "BA", 18 }, ;
      { "CE", "CE", 18 }, ;
      { "DF", "DF", 18 }, ;
      { "ES", "ES", 17 }, ;
      { "GO", "GO", 17 }, ;
      { "MA", "MA", 18 }, ;
      { "MG", "MG", 18 }, ;
      { "MG", "PR", 12 }, ;
      { "MG", "RJ", 12 }, ;
      { "MG", "RS", 12 }, ;
      { "MG", "SC", 12 }, ;
      { "MG", "SP", 12 }, ;
      { "MG", "**", 7 }, ;
      { "MT", "MT", 17 }, ;
      { "MS", "MS", 17 }, ;
      { "PA", "PA", 17 }, ;
      { "PB", "PB", 18 }, ;
      { "PE", "PE", 18 }, ;
      { "PI", "PI", 18 }, ;
      { "PR", "PR", 18 }, ;
      { "RJ", "RJ", 20 }, ;
      { "RJ", "MG", 12 }, ;
      { "RJ", "PR", 12 }, ;
      { "RJ", "RS", 12 }, ;
      { "RJ", "SC", 12 }, ;
      { "RJ", "SP", 12 }, ;
      { "RJ", "**", 7 }, ;
      { "RN", "RN", 18 }, ;
      { "RO", "RO", 17.5 }, ;
      { "RR", "RR", 17 }, ;
      { "RS", "RS", 18 }, ;
      { "RS", "MG", 12 }, ;
      { "RS", "PR", 12 }, ;
      { "RS", "MS", 12 }, ;
      { "RS", "SC", 12 }, ;
      { "RS", "SP", 12 }, ;
      { "RS", "**", 7 }, ;
      { "SC", "SC", 17 }, ;
      { "SC", "MG", 12 }, ;
      { "SC", "PR", 12 }, ;
      { "SC", "MS", 12 }, ;
      { "SC", "PB", 12 }, ;
      { "SC", "RS", 12 }, ;
      { "SC", "SP", 12 }, ;
      { "SC", "**", 7 }, ;
      { "SP", "SP", 18 }, ;
      { "SP", "MG", 12 }, ;
      { "SP", "PR", 12 }, ;
      { "SP", "RJ", 12 }, ;
      { "SP", "RS", 12 }, ;
      { "SP", "SC", 12 }, ;
      { "SP", "**", 7 }, ;
      { "SE", "SE", 18 }, ;
      { "TO", "TO", 18 }, ;
      { "**", "**", 12 } }

   bCode     := { | e | ( e[ 1 ] == cUF1 .OR. e[ 1 ] == "**" ) .AND. ( e[ 2 ] == cUF2 .OR. e[ 2 ] == "**" ) }
   nPos      := hb_ASCan( aList, bCode )
   nAliquota := aList[ nPos, 3 ]

   RETURN nAliquota
