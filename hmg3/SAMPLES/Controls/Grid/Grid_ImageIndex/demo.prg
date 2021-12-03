

#include "hmg.ch"


Function Main

   aItems := {}

   AADD (aItems, {"Carrot",        5})
   AADD (aItems, {"Cauliflower",   0})
   AADD (aItems, {"Corn",         15})
   AADD (aItems, {"Tomato",        0})
   AADD (aItems, {"Zucchini",     20})


   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 600 ;
      HEIGHT 400 ;
      MAIN 

      @ 10,10 GRID Grid_1 ;
         WIDTH 550 ;
         HEIGHT 330 ;
         HEADERS {'Product','Stock'} ;
         WIDTHS {250,150};
         ITEMS aItems;
         ON CHANGE Test_Value();
         EDIT;
         CELLNAVIGATION;
         COLUMNCONTROLS { NIL, {'TEXTBOX','NUMERIC'} }

   END WINDOW

   Form_1.Grid_1.ColumnJUSTIFY (2) := GRID_JTFY_RIGHT


   aFont := ARRAY FONT "Calibri" SIZE 11 BOLD ITALIC
   Form_1.Grid_1.ColumnDYNAMICFONT  (1) := {|| IF ( Form_1.Grid_1.CellEx(This.CellRowIndex,2) == 0, aFont, NIL) }
   Form_1.Grid_1.ColumnDYNAMICFONT  (2) := {|| IF ( Form_1.Grid_1.CellEx(This.CellRowIndex,2) == 0, aFont, NIL) }



   Form_1.Grid_1.Image (.T.) := {"_No.bmp", "_Yes.bmp", "_Carrot.png", "_Cauliflower.png", "_Corn.png", "_Tomato.png", "_Zucchini.png" }
                 // ImageIndex -->      0           1              2                   3            4              5                6


   FOR i = 1 TO Form_1.Grid_1.ItemCount
      Form_1.Grid_1.ImageIndex (i,1) := i + 1

      IF Form_1.Grid_1.CellEx (i,2) == 0
        Form_1.Grid_1.ImageIndex (i,2) := 0   // _No.bmp
      ELSE
        Form_1.Grid_1.ImageIndex (i,2) := 1   // _Yes.bmp
      ENDIF
   NEXT


   CENTER WINDOW Form_1

   ACTIVATE WINDOW Form_1

Return


Procedure Test_Value
   IF This.CellColIndex == 2
      nImageIndex := IF ( Form_1.Grid_1.CellEx(This.CellRowIndex,2) == 0, 0, 1)
      Form_1.Grid_1.ImageIndex (This.CellRowIndex,2) := nImageIndex
   ENDIF
Return
