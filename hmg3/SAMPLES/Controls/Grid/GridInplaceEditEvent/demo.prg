
#include "hmg.ch"

Function Main

   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 800 ;
      HEIGHT 550 ;
      TITLE 'Grid Inplace Edit Event' ;
      MAIN 

      aItems := {}
      AADD (aItems, {"Carrot",        5, 30, DATE()+1 })
      AADD (aItems, {"Cauliflower",   0, 31, DATE()+2 })
      AADD (aItems, {"Corn",         15, 32, DATE()+3 })
      AADD (aItems, {"Tomato",        0, 33, DATE()+4 })
      AADD (aItems, {"Zucchini",     20, 34, DATE()+5 })

      @ 10,  10 LABEL Label_1 VALUE "" AUTOSIZE
      @ 50,  10 LABEL Label_2 VALUE "" AUTOSIZE
      @ 100, 10 LABEL Label_3 VALUE "" AUTOSIZE
      @ 150, 10 LABEL Label_4 VALUE "" AUTOSIZE
      @ 200, 10 LABEL Label_5 VALUE "" AUTOSIZE

      @ 250,10 GRID Grid_1 ;
            WIDTH 760 ;
            HEIGHT 240 ;
            HEADERS {'Character','Number','Number','Date'} ;
            WIDTHS {140,140,140,140};
            ITEMS aItems ;
            EDIT;
            CELLNAVIGATION;
            COLUMNCONTROLS { {'TEXTBOX','CHARACTER'}, {'TEXTBOX','NUMERIC'}, {'SPINNER', 1, 50}, {'DATEPICKER','DROPDOWN'} };
            ON INPLACEEDITEVENT ProcGridInplaceEditEvent();
            ON KEY ProcOnKeyEvent();
            ON CLICK ProcOnClickEvent()

   END WINDOW

   CENTER WINDOW Form_1

   ACTIVATE WINDOW Form_1

Return


FUNCTION ProcGridInplaceEditEvent()
STATIC cControlName, cFormParentName

   DO CASE

      CASE This.IsInplaceEditEventInit == .T.

         Form_1.Label_1.VALUE := { "Grid Control: ", This.InplaceEditParentName, ".", This.InplaceEditGridName }

         GetControlNameByHandle ( This.InplaceEditControlHandle, @cControlName, @cFormParentName )

         Form_1.Label_2.VALUE := { "InplaceEdit Control: ", cFormParentName, ".", cControlName,;
                                   " --> ", GetControlTypeByIndex ( This.InplaceEditControlIndex ) }

      CASE This.IsInplaceEditEventRun == .T.

         Form_1.Label_3.VALUE := { "Last Key Press: ", HMG_GetLastVirtualKeyDown(),; 
                                   "    Last Char Press: ", HMG_GetLastCharacter(),; 
                                   "    Current Value: ", GetProperty(cFormParentName, cControlName, "VALUE") }

      CASE This.IsInplaceEditEventFinish == .T.

         Form_1.Label_1.VALUE := "" 
         Form_1.Label_2.VALUE := ""
         Form_1.Label_3.VALUE := ""

   ENDCASE

RETURN NIL


FUNCTION ProcOnKeyEvent()
   Form_1.Label_4.VALUE := "Last On Key Event is fired in: " + IF( This.IsInplaceEditEventRun == .F., "GRID Control", "Grid InplaceEdit Control" ) 
RETURN NIL

FUNCTION ProcOnClickEvent()
   Form_1.Label_5.VALUE := "Last On Click Event is fired in: " + IF( This.IsInplaceEditEventRun == .F., "GRID Control", "Grid InplaceEdit Control" )
RETURN NIL
