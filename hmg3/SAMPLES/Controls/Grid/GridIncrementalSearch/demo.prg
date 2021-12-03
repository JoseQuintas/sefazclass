

#include "hmg.ch"

Function Main

   SET CODEPAGE TO UNICODE

   public aRows [21] [3]

   aRows [1]    := {'Simpson','Homer','555-5555'}
   aRows [2]    := {'Mulder','Fox','324-6432'} 
   aRows [3]    := {'Smart','Max','432-5892'} 
   aRows [4]    := {'Grillo','Pepe','894-2332'} 
   aRows [5]    := {'Kirk','James','346-9873'} 
   aRows [6]    := {'Barriga','Carlos','394-9654'} 
   aRows [7]    := {'Flanders','Ned','435-3211'} 
   aRows [8]    := {'Smith','John','123-1234'} 
   aRows [9]    := {'Pedemonti','Flavio','000-0000'} 
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


   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 800 ;
      HEIGHT 650 ;
      TITLE "Incremental search in grid" ;
      MAIN 

      @  10, 10 Label L1 ;
         width 80;
         height 20;
         value "Search string:"

      @  10, 100 Label Label_WhatToSearch ;
         width 600;
         height 20;
         value "???";
         autosize

      @  40, 10 Label L2 ;
         width 120;
         height 20;
         value "Last pressed char:"

      @  40, 140 Label Label_PressedChar ;
         width 120;
         height 20;
         value ""
      
      @ 80,10 GRID Grid_1 ;
         WIDTH 760 ;
         HEIGHT 500 ;
         HEADERS {'Last Name','First Name','Phone'} ;
         WIDTHS {140,140,140};
         ITEMS aRows ;
         VALUE 1;
         EDIT;
         JUSTIFY { GRID_JTFY_LEFT,GRID_JTFY_LEFT, GRID_JTFY_RIGHT };
         ON KEY Proc_GridSearchString()

   END WINDOW

   CENTER WINDOW Form_1
   
   ACTIVATE WINDOW Form_1

Return



****************************************************************
 Function Proc_GridSearchString   // New version (April 2014)
****************************************************************
   STATIC nRow := 0
   STATIC cPublicSearchString := ""
   local ch, i, k, cLocalSearchString 
   
   ch := HMG_GetLastCharacter()

   if HMG_GetLastVirtualKeyDown() == VK_BACK   //   backspace
       HMG_CleanLastVirtualKeyDown()
      cPublicSearchString := HB_ULEFT (cPublicSearchString, max(0,HMG_LEN(cPublicSearchString)-1))
      cLocalSearchString := cPublicSearchString
   else
      IF EventMsg() <> WM_CHAR
         Return Nil   // enable processing the current message
      ENDIF
      cLocalSearchString := cPublicSearchString + ch
   endif

   i := 0
   FOR k = 1 TO Form_1.Grid_1.ItemCOUNT
      #define COL_SEARCH   1
      IF HMG_UPPER(HB_ULEFT(Form_1.Grid_1.CellEx(k,COL_SEARCH), HMG_LEN(cLocalSearchString))) == HMG_UPPER(cLocalSearchString)
         i := k
         nRow := k   // remember last found string
         EXIT
      ENDIF
   NEXT

   if i > 0
      Form_1.Grid_1.Value := i                    // found - move pointer of grid
      cPublicSearchString := cLocalSearchString   // remember found string
   else
      Form_1.Grid_1.Value := nRow                 // not found - move pointer of the last found string
   endif

   Form_1.Label_PressedChar.Value := ch
   Form_1.Label_WhatToSearch.Value := cPublicSearchString
// Form_1.Grid_1.SetFocus

return 1   // prevents the processing of the current message


 