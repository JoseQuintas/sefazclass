PROCEDURE Main

   SetMode(33,100)
   CLS
   AltD()
   ? "SP-RN-RS-RJ"
   ? hb_ValToExp( TrajetoMultiplo( "SP", "RN", "RS", "RJ" ) )
   ? hb_ValToExp( TrajetoMultiplo( "SP", "RN", "RS", "RJ", .T. ) )
   ? "SP-SE"
   ? hb_ValToExp( TrajetoMultiplo( "SP", "SE" ) )
   ? "SP-RS"
   ? hb_ValToExp( TrajetoMultiplo( "SP", "RS" ) )
   ? "RR-SP"
   ? hb_ValToExp( TrajetoMultiplo( "RR", "SP" ) )
   ? "SP-RN"
   ? hb_ValToExp( TrajetoMultiplo( "SP", "RN" ) )
   ? "RS-RN"
   ? hb_ValToExp( TrajetoMultiplo( "RS", "RN" ) )
   ? "MG-DF"
   ? hb_ValToExp( TrajetoMultiplo( "MG", "DF" ) )

   Inkey(0)

   RETURN

FUNCTION TrajetoMultiplo( ... )

   LOCAL aUFSource := hb_AParams(), nPos, aUFDestino, aRotaFinal, aRotaOk
   LOCAL cUFOrigem, aItem, cUF, aRotas, aUFList := {}, lIncluiOrigemDestino

   FOR EACH cUF IN aUFSource
      IF ValType( cUF ) == "L"
         lIncluiOrigemDestino := cUF
      ELSE
         IF hb_AScan( aUFList, { | e | e == cUF } ) == 0
            AAdd( aUFList, cUF )
         ENDIF
      ENDIF
   NEXT
   hb_Default( @lIncluiOrigemDestino, .F. )

   // sem parametro
   IF Len( aUFList ) == 0
      RETURN {}
   ENDIF
   // UF única
   IF Len( aUFList ) == 1
      RETURN {}
   ENDIF
   // UF fora da lista
   FOR EACH cUF IN aUFList
      IF hb_AScan( GetVizinhos(), { | e | e[1] == cUF } ) == 0
         RETURN {}
      ENDIF
   NEXT
   // Cria trajetos até todos os destinos
   cUFOrigem := aUFList[ 1 ]
   hb_ADel( aUFList, 1, .T. )
   aUFDestino := aClone( aUFList )
   aRotaOk := {}
   DO WHILE .T.
      // calcula trajeto pra cada uma
      aRotas := {}
      FOR EACH cUF IN aUFDestino
         AAdd( aRotas, TrajetoUF( cUFOrigem, cUF, .T. ) )
      NEXT
      // pega o trajeto mais próximo como primeira passagem, e este passa a ser o início
      ASort( aRotas,,, { | e | Len( e ) } )
      AAdd( aRotaOk, aRotas[ 1 ] )
      nPos := hb_ASCan( aUFDestino, { | e | e == Atail( aRotas[1] ) } )
      cUFOrigem := aUFDestino[ nPos ]
      hb_ADel( aUFDestino, nPos, .T. )
      // acabou a lista, fim
      IF Len( aUFDestino ) == 0
         EXIT
      ENDIF
   ENDDO
   // junta trajetos intermediários
   aRotaFinal := {}
   FOR EACH aItem IN aRotaOk
      FOR EACH cUF IN aItem
         IF Atail( aRotaFinal ) != cUF
            AAdd( aRotaFinal, cUF )
         ENDIF
      NEXT
   NEXT
   IF ! lIncluiOrigemDestino
      hb_ADel( aRotaFinal, 1, .T. )
      hb_ADel( aRotaFinal, Len( aRotaFinal ), .T. )
   ENDIF

   RETURN aRotaFinal

FUNCTION TrajetoUF( cUFOrigem, cUFDestino, lIncluiOrigemDestino )

   LOCAL aList, aList2, aTrajeto, aNewList, cUF, xItem, xItem2
   LOCAL aResultado

   hb_Default( @lIncluiOrigemDestino, .F. )
   // origem = destino
   IF cUFOrigem == cUFDestino
      RETURN iif( lIncluiOrigemDestino, { cUFOrigem }, {} )
   ENDIF

   // UF inválida
   IF hb_AScan( GetVizinhos(), { | e | e[1] == cUFOrigem } ) == 0 .OR.  ;
      hb_ASCan( GetVizinhos(), { | e | e[1] == cUFDestino } )  == 0
      RETURN {}
   ENDIF

   // traça rotas a partir da origem
   aList := { { cUFOrigem, { cUFOrigem } } }
   DO WHILE .T.
      IF Len( aList ) == 0
         EXIT
      ENDIF
      IF Len( aList[1][2] ) > 20
         RETURN {} // Quase o Brasil inteiro na lista
      ENDIF
      FOR EACH xItem IN aList
         IF xItem[1] == cUFDestino
            aResultado := xItem[2]
            IF ! lIncluiOrigemDestino
               hb_ADel( aResultado, 1, .T. )
               hb_ADel( aResultado, Len( aResultado ), .T. )
            ENDIF
            RETURN aResultado
         ENDIF
      NEXT
      cUF := aList[1][1]
      aList2 := aList[1][2]
      hb_ADel( aList, 1, .T. )
      aTrajeto := GetVizinhos( cUF )
      FOR EACH xItem IN aTrajeto
         aNewList := {}
         FOR EACH xItem2 IN aList2
            IF hb_AScan( aNewList, xItem2 ) == 0
               AAdd( aNewList, xItem2 )
            ENDIF
         NEXT
         IF ! Empty( aNewList )
            AAdd( aNewList, xItem )
            AAdd( aList, { xItem, aNewList } )
         ENDIF
      NEXT
   ENDDO

   ? "Não foi possível encontrar trajeto entre " + cUFOrigem + " e " + cUFDestino
   RETURN NIL

FUNCTION GetVizinhos( cUF )
   LOCAL aList := { ;
      { "AC", { "AM", "RO" } }, ;
      { "AL", { "PE", "SE", "BA" } }, ;
      { "AP", { "PA" } }, ;
      { "AM", { "RR", "PA", "MT", "RO", "AC" } }, ;
      { "BA", { "SE", "AL", "PE", "PI", "TO", "GO", "MG", "ES" } }, ;
      { "CE", { "PI", "PE", "PB", "RN" } }, ;
      { "DF", { "GO" } }, ;
      { "ES", { "BA", "MG", "RJ" } }, ;
      { "GO", { "DF", "MG", "BA", "TO", "MT", "MS" } }, ;
      { "MA", { "PI", "TO", "PA" } }, ;
      { "MT", { "PA", "TO", "GO", "MS", "RO", "AM" } }, ;
      { "MS", { "MT", "GO", "MG", "SP", "PR" } }, ;
      { "MG", { "SP", "RJ", "ES", "BA", "GO", "MS" } }, ;
      { "PA", { "AP", "MA", "TO", "MT", "AM" } }, ;
      { "PB", { "RN", "CE", "PE" } }, ;
      { "PR", { "SP", "MS", "SC" } }, ;
      { "PE", { "PB", "CE", "PI", "BA", "AL" } }, ;
      { "PI", { "MA", "TO", "BA", "PE", "CE" } }, ;
      { "RJ", { "ES", "MG", "SP" } }, ;
      { "RN", { "PB", "CE" } }, ;
      { "RS", { "SC" } }, ;
      { "RO", { "AC", "AM", "MT" } }, ;
      { "RR", { "AM", "PA" } }, ;
      { "SC", { "PR", "RS" } }, ;
      { "SP", { "RJ", "MG", "MS", "PR" } }, ;
      { "SE", { "BA", "AL" } }, ;
      { "TO", { "MA", "PI", "BA", "GO", "MT", "PA" } } ;
   }
   LOCAL nPos

   IF pCount() == 0
      RETURN aList
   ENDIF
   nPos  := hb_ASCAN( aList, {|e| e[1] == cUF } )

   IF nPos > 0
      RETURN aList[ nPos, 2 ]
   ENDIF

   RETURN {}

FUNCTION PostQuitMessage(); RETURN Nil
FUNCTION AppVersaoExe(); RETURN ""
FUNCTION FW_gt(); RETURN Nil
