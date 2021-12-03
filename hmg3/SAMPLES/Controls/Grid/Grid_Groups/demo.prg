
#include "hmg.ch"

Function Main
Local aRows

   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 800 ;
      HEIGHT 600 ;
      TITLE "Demo: GRID Group" ;
      MAIN 

      aRows := ARRAY (25)
      aRows [1]   := {'Simpson',    'Homer',       1}
      aRows [2]   := {'Mulder',     'Fox',         1} 
      aRows [3]   := {'Smart',      'Max',         1} 
      aRows [4]   := {'Grillo',     'Pepe',        1} 
      aRows [5]   := {'Kirk',       'James',       1} 
      aRows [6]   := {'Barriga',    'Carlos',      1} 
      aRows [7]   := {'Flanders',   'Ned',         1} 
      aRows [8]   := {'Smith',      'John',        1} 
      aRows [9]   := {'Pedemonti',  'Flavio',      1} 
      aRows [10]  := {'Gomez',      'Juan',        1} 
      aRows [11]  := {'Fernandez',  'Raul',        1} 
      aRows [12]  := {'Borges',     'Javier',      1} 
      aRows [13]  := {'Alvarez',    'Alberto',     1} 
      aRows [14]  := {'Gonzalez',   'Ambo',        1} 
      aRows [15]  := {'Gracie',     'Helio',       1} 
      aRows [16]  := {'Vinazzi',    'Amigo',       1} 
      aRows [17]  := {'Gracie',     'Royce',       1} 
      aRows [18]  := {'Samarbide',  'Armando',     1} 
      aRows [19]  := {'Pradon',     'Alejandra',   1} 
      aRows [20]  := {'Reyes',      'Monica',      1} 
      aRows [21]  := {'Silva',      'Anderson',    1} 
      aRows [22]  := {'Machida',    'Lyoto',       1}
      aRows [23]  := {'Nogueira',   'Rodrigo',     1} 
      aRows [24]  := {'Belford',    'Victor',      1} 
      aRows [25]  := {'Werdum',     'Fabricio',    1} 


      @ 50,10 GRID Grid_1 ;
         WIDTH 750 ;
         HEIGHT 340 ;
         HEADERS {'Last Name', 'First Name', 'Assistance'};
         WIDTHS  {140, 140, 140};
         ITEMS aRows; 
         COLUMNCONTROLS { NIL, NIL, {'COMBOBOX',{'Confirmed','Unconfirmed'}} };
         COLUMNWHEN  { {||.F.}, {||.F.}, {|| .T. } };
         COLUMNVALID { {||.T.}, {||.T.}, {|| ChangeGroup() } };
         VALUE 1; 
         EDIT;
         CELLNAVIGATION


/*
- <ParentWindowName>.<GridControlName>.GroupEnabled [ := | -->] lBoolean
- <ParentWindowName>.<GridControlName>.GroupDeleteAll
- <ParentWindowName>.<GridControlName>.GroupDelete ( nGroupID )
- <ParentWindowName>.<GridControlName>.GroupExpand ( nGroupID )
- <ParentWindowName>.<GridControlName>.GroupCollapsed ( nGroupID )
- <ParentWindowName>.<GridControlName>.GroupAdd    ( nGroupID [, nPosition ] )
- <ParentWindowName>.<GridControlName>.GroupInfo   ( nGroupID ) [ := | -->] { [ cHeader ] , [ nAlignHeader ] , [ cFooter ] , [ nAlingFooter ] , [ nState ] }
- <ParentWindowName>.<GridControlName>.GroupItemID ( nItem )    [ := | -->] nGroupID

nAlignHeader & nAlingFooter   -->   GRID_GROUP_LEFT | GRID_GROUP_CENTER | GRID_GROUP_RIGHT
nState -->   GRID_GROUP_NORMAL | GRID_GROUP_COLLAPSED

*/


      #define GROUP1_ID   100
      #define GROUP2_ID   200

      Form_1.Grid_1.GroupEnabled := .T.

      Form_1.Grid_1.GroupAdd ( GROUP1_ID , NIL )
      Form_1.Grid_1.GroupAdd ( GROUP2_ID , NIL )

      Form_1.Grid_1.GroupInfo ( GROUP1_ID ) := { "List of persons CONFIRMED their attendance of the event" ,     GRID_GROUP_CENTER , " End of the list of Confirmed " ,   GRID_GROUP_RIGHT , GRID_GROUP_NORMAL }
      Form_1.Grid_1.GroupInfo ( GROUP2_ID ) := { "List of persons NOT CONFIRMED their attendance of the event" , GRID_GROUP_CENTER , " End of the list of Unconfirmed " , GRID_GROUP_RIGHT , GRID_GROUP_NORMAL }

      FOR i := 1 TO Form_1.Grid_1.ItemCount
         IF i <= Form_1.Grid_1.ItemCount/2
            Form_1.Grid_1.GroupItemID (i) := GROUP2_ID
            Form_1.Grid_1.CellEx (i,3)    := 2   // Unconfirmed
         ELSE
            Form_1.Grid_1.GroupItemID (i) := GROUP1_ID
            Form_1.Grid_1.CellEx (i,3)    := 1   // Confirmed
         ENDIF
      NEXT


      @ 450,  55 BUTTON Button_1 CAPTION "G1-NORMAL"    ACTION Form_1.Grid_1.GroupExpand ( GROUP1_ID )
      @ 450, 155 BUTTON Button_2 CAPTION "G1-COLLAPSED" ACTION Form_1.Grid_1.GroupCollapsed ( GROUP1_ID )
      @ 450, 355 BUTTON Button_3 CAPTION "G1-GetInfo"   ACTION MsgDebug (Form_1.Grid_1.GroupInfo ( GROUP1_ID ))

      @ 500,  55 BUTTON Button_4 CAPTION "G2-NORMAL"    ACTION Form_1.Grid_1.GroupExpand ( GROUP2_ID )
      @ 500, 155 BUTTON Button_5 CAPTION "G2-COLLAPSED" ACTION Form_1.Grid_1.GroupCollapsed ( GROUP2_ID )
      @ 500, 355 BUTTON Button_6 CAPTION "G2-GetInfo"   ACTION MsgDebug (Form_1.Grid_1.GroupInfo ( GROUP2_ID ))

      @ 450, 555 BUTTON Button_7 CAPTION "Group ON/OFF" ACTION Form_1.Grid_1.GroupEnabled := .NOT. Form_1.Grid_1.GroupEnabled
      @ 500, 555 BUTTON Button_8 CAPTION "List Confirmed" ACTION GetListConfirmed()

   END WINDOW

   CENTER WINDOW Form_1

   ACTIVATE WINDOW Form_1

Return


FUNCTION ChangeGroup
   IF This.CellValue <> Form_1.Grid_1.CellEx ( This.CellRowIndex , This.CellColIndex )
      IF This.CellValue == 1   // Confirmed
         Form_1.Grid_1.GroupItemID ( This.CellRowIndex ) := GROUP1_ID   // Confirmed
      ELSE
         Form_1.Grid_1.GroupItemID ( This.CellRowIndex ) := GROUP2_ID   // UnConfirmed
      ENDIF
   ENDIF
RETURN .T.


PROCEDURE GetListConfirmed
Local i, cList := ""
   FOR i = 1 TO Form_1.Grid_1.ItemCount
      IF Form_1.Grid_1.GroupItemID ( i ) == GROUP1_ID
         cList := cList + Form_1.Grid_1.CellEx (i, 1) +", "+ Form_1.Grid_1.CellEx (i, 2) + HB_OsNewLine()
      ENDIF
   NEXT
   MsgInfo (cList, "Confirmed List")
RETURN


