PROCEDURE Main

   LOCAL nCont, nOpc := 1, oControlList := Array(21)

   SetMode(25,80)
   SetColor( "W/B" )
   CLS
   FOR nCont = 1 TO 21
      oControlList[ nCont ] := wvgtstRectangle():New()
      oControlList[ nCont ]:Create( ,, { -nCont, -10 }, { 1, -20 } )
   NEXT
   FOR nCont = 1 TO 20
      @ nCont, 10 PROMPT "Element " + Str( nCont, 3 )
   NEXT
   MENU TO nOpc

   AEval( oControlList, { | e | e:Destroy() } )

   RETURN
