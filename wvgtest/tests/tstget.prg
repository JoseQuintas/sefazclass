STATIC oControlList := {}

PROCEDURE Main

   LOCAL GetList := {}, xValue1 := 0.00, xValue2 := Space(5), xValue3 := 0.00
   LOCAL xValue4 := Space(20), xValue5 := Space(40)

   SetMode( 25, 80 )
   SetColor( "W/B" )
   CLS
   @ 2, 1 SAY "Any...:" GET xValue1
   @ 3, 1 SAY "Any...:" GET xValue2
   @ 4, 1 SAY "Any...:" GET xValue3
   @ 5, 1 SAY "Any...:" GET xValue4
   @ 6, 1 SAY "Any...:" GET xValue5
   SetPaintGetList( GetList )
   READ

   AEval( oControlList, { | e | e:Destroy() } )

   RETURN

FUNCTION SetPaintGetList( GetList )

   LOCAL oGet, oControl

   FOR EACH oGet IN GetList
      oControl := wvgTstFrame():New()
      oControl:Create( , , { -oGet:Row, -oGet:Col }, { -1, -Len( Transform( oGet:VarGet(), oGet:Picture ) ) } )
      AAdd( oControlList, oControl )
   NEXT

   RETURN NIL
