
#include "hmg.ch"


Function Main

   aItems := {}

   AADD (aItems, {"Carrot",        5, "A"})
   AADD (aItems, {"Cauliflower",   0, "B"})
   AADD (aItems, {"Corn",         15, "C"})
   AADD (aItems, {"Tomato",        0, "D"})
   AADD (aItems, {"Zucchini",     20, "E"})


   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 600 ;
      HEIGHT 400 ;
      MAIN 

      @ 10,10 GRID Grid_1 ;
         WIDTH 550 ;
         HEIGHT 330 ;
         HEADERS {'Product','Stock','Supplier'} ;
         WIDTHS {250,150,100};
         ITEMS aItems;
         EDIT;
         CELLNAVIGATION;
         COLUMNCONTROLS { NIL, {'TEXTBOX','NUMERIC'}, NIL }
         
         Form_1.Grid_1.ColumnJUSTIFY (2) := GRID_JTFY_RIGHT
         Form_1.Grid_1.ColumnJUSTIFY (3) := GRID_JTFY_CENTER

         aFont := ARRAY FONT "Calibri" SIZE 12 BOLD ITALIC
         Form_1.Grid_1.ColumnDYNAMICFONT  (1) := {|| IF ( Form_1.Grid_1.CellEx(This.CellRowIndex,2) == 0, aFont, NIL) }
         Form_1.Grid_1.ColumnDYNAMICFONT  (2) := {|| IF ( Form_1.Grid_1.CellEx(This.CellRowIndex,2) == 0, aFont, NIL) }


         // Dynamic Header
         Form_1.Grid_1.HeaderDYNAMICFONT (1) := {|| ARRAY FONT "Arial"   SIZE 12 ITALIC UNDERLINE }
         Form_1.Grid_1.HeaderDYNAMICFONT (3) := {|| ARRAY FONT "Calibri" SIZE 12 BOLD   }
         
         Form_1.Grid_1.HeaderDYNAMICFORECOLOR (1) := {|| HeaderForeColor() }
         Form_1.Grid_1.HeaderDYNAMICFORECOLOR (2) := {|| HeaderForeColor() }
         Form_1.Grid_1.HeaderDYNAMICFORECOLOR (3) := {|| HeaderForeColor() }

   END WINDOW

   CENTER WINDOW Form_1

   ACTIVATE WINDOW Form_1

Return


Function HeaderForeColor
Local aColor
   IF This.CellColIndex == 1
      aColor := BLUE
   ELSEIF This.CellColIndex == 2
      aColor := RED
   ELSE
      aColor := NIL
   ENDIF
Return aColor
