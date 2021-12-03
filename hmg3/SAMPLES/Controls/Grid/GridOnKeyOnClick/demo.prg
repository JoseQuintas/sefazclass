
#include "hmg.ch"

Function Main

public aRows [21] [3]

   aRows [1]   := {'Simpson','Homer','555-5555'}
   aRows [2]   := {'Mulder','Fox','324-6432'} 
   aRows [3]   := {'Smart','Max','432-5892'} 
   aRows [4]   := {'Grillo','Pepe','894-2332'} 
   aRows [5]   := {'Kirk','James','346-9873'} 
   aRows [6]   := {'Barriga','Carlos','394-9654'} 
   aRows [7]   := {'Flanders','Ned','435-3211'} 
   aRows [8]   := {'Smith','John','123-1234'} 
   aRows [9]   := {'Pedemonti','Flavio','000-0000'} 
   aRows [10]   := {'Gomez','Juan','583-4832'} 
   aRows [11]   := {'Fernandez','Raul','321-4332'} 
   aRows [12]   := {'Borges','Javier','326-9430'} 
   aRows [13]   := {'Alvarez','Alberto','543-7898'} 
   aRows [14]   := {'Gonzalez','Ambo','437-8473'} 
   aRows [15]   := {'Batistuta','Gol','485-2843'} 
   aRows [16]   := {'Vinazzi','Amigo','394-5983'} 
   aRows [17]   := {'Pedemonti','Flavio','534-7984'} 
   aRows [18]   := {'Samarbide','Armando','854-7873'} 
   aRows [19]   := {'Pradon','Alejandra','???-????'} 
   aRows [20]   := {'Reyes','Monica','432-5836'} 
   aRows [21]   := {'Fernández','two','0000-0000'} 

   FOR i = 1 TO 21
     AADD (aRows[i],str(i))
   NEXT

   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 800 ;
      HEIGHT 650 ;
      TITLE "CELLNAVIGATION (F9 - On/Off)";
      MAIN 

      @  10, 10 Label Label_1 ;
         width 80;
         height 20;
         value "";
         autosize

      @  30, 10 Label Label_2 ;
         width 80;
         height 20;
         value "";
         autosize


      @ 80,10 GRID Grid_1 ;
         WIDTH 540 ;
         HEIGHT 500 ;
         HEADERS {'Last Name','First Name','Phone',"Num"} ;
         WIDTHS {140,140,140,50};
         ITEMS aRows ;
         VALUE 1;
         EDIT;
         ON CLICK OnClick();
         ON KEY OnKey();
         EDITOPTION GRID_EDIT_DEFAULT

         Form_1.Grid_1.ColumnCONTROL (4) := {"TEXTBOX", "NUMERIC",NIL,NIL}
         Form_1.Grid_1.ColumnJUSTIFY (4) := GRID_JTFY_RIGHT


aGridEditOptions := {GRID_EDIT_DEFAULT, GRID_EDIT_SELECTALL, GRID_EDIT_INSERTBLANK, GRID_EDIT_INSERTCHAR, GRID_EDIT_REPLACEALL}

         @ 80, 570 RADIOGROUP RadioGroup_1;
                   OPTIONS {"GRID_EDIT_DEFAULT", "GRID_EDIT_SELECTALL", "GRID_EDIT_INSERTBLANK", "GRID_EDIT_INSERTCHAR", "GRID_EDIT_REPLACEALL"}; 
                   VALUE 1;
                   WIDTH 200;
                   ON CHANGE ( Form_1.Grid_1.EditOption := aGridEditOptions [ Form_1.RadioGroup_1.VALUE ] )

   END WINDOW

   CENTER WINDOW Form_1

   ACTIVATE WINDOW Form_1

Return



Function OnClick

   Form_1.Label_1.VALUE := "New  Row: "+ HB_NTOS(Form_1.Grid_1.CellRowClicked) + "   New  Col: "+ HB_NTOS(Form_1.Grid_1.CellColClicked) + "   --- ON CLICK ---"
   Form_1.Label_2.VALUE := "Last Row: "+ HB_NTOS(Form_1.Grid_1.CellRowFocused) + "   Last Col: "+ HB_NTOS(Form_1.Grid_1.CellColFocused) + "   --- ON CLICK ---"
Return NIL


Function OnKey
   IF HMG_GetLastVirtualKeyDown() == VK_F9
      HMG_CleanLastVirtualKeyDown()
      Form_1.Grid_1.CellNavigation := .NOT. (Form_1.Grid_1.CellNavigation)
   ENDIF
   Form_1.Label_1.VALUE := "Row: "+ HB_NTOS(Form_1.Grid_1.CellRowFocused) + "   Col:"+ HB_NTOS(Form_1.Grid_1.CellColFocused) + "   --- ON KEY --- "
   Form_1.Label_2.VALUE := ""
Return NIL

