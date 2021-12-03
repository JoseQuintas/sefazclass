#include "hmg.ch"

Function Main

Local aRows := { ;
   { 113.12, date()+ 1, 1,  1, .t. }, ;
   { 123.12, date()+ 2, 2,  2, .f. }, ;
   { 133.12, date()+ 3, 3,  3, .t. }, ;
   { 143.12, date()+ 4, 1,  4, .f. }, ;
   { 153.12, date()+ 5, 2,  5, .t. }, ;
   { 163.12, date()+ 6, 3,  6, .f. }, ;
   { 173.12, date()+ 7, 1,  7, .t. }, ;
   { 183.12, date()+ 8, 2,  8, .f. }, ;
   { 193.12, date()+ 9, 3,  9, .t. }, ;
   { 203.12, date()+10, 1, 10, .f. }, ;
   { 113.12, date()+11, 2, 11, .t. }, ;
   { 123.12, date()+12, 3, 12, .f. }, ;
   { 133.12, date()+13, 1, 13, .t. }, ;
   { 143.12, date()+14, 2, 14, .f. }, ;
   { 153.12, date()+15, 3, 15, .t. }, ;
   { 163.12, date()+16, 1, 16, .f. }, ;
   { 173.12, date()+17, 2, 17, .t. }, ;
   { 183.12, date()+18, 3, 18, .f. }, ;
   { 193.12, date()+19, 1, 19, .t. }, ;
   { 203.12, date()+20, 2, 20, .f. }, ;
   { 113.12, date()+21, 2, 21, .t. }, ;
   { 123.12, date()+22, 3, 22, .f. }, ;
   { 133.12, date()+23, 1, 23, .t. }, ;
   { 143.12, date()+24, 2, 24, .f. }, ;
   { 153.12, date()+25, 3, 25, .t. }, ;
   { 163.12, date()+26, 1, 26, .f. }, ;
   { 173.12, date()+27, 2, 27, .t. }, ;
   { 183.12, date()+28, 3, 28, .f. }, ;
   { 193.12, date()+29, 1, 29, .t. }, ;
   { 203.12, date()+30, 2, 30, .f. }, ;
   { 113.12, date()+31, 2, 31, .t. }, ;
   { 123.12, date()+32, 3, 32, .f. }, ;
   { 133.12, date()+33, 1, 33, .t. }, ;
   { 143.12, date()+34, 2, 34, .f. }, ;
   { 153.12, date()+35, 3, 35, .t. }, ;
   { 163.12, date()+36, 1, 36, .f. }, ;
   { 173.12, date()+37, 2, 37, .t. }, ;
   { 183.12, date()+38, 3, 38, .f. }, ;
   { 193.12, date()+39, 1, 39, .t. }, ;
   { 203.12, date()+40, 2, 40, .f. }  }

   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 1000 ;
      HEIGHT 1000 ;
      TITLE 'Resize Grid Test' ;
      MAIN

      DEFINE MAIN MENU
         DEFINE POPUP 'File'
            MENUITEM 'Get Width'         ACTION MsgInfo ( 'Width:  '         + HB_NTOS ( Form_1.Grid_1.Width       ) )
            MENUITEM 'Get Height'        ACTION MsgInfo ( 'Height:  '        + HB_NTOS ( Form_1.Grid_1.Height      ) )
            MENUITEM 'Get Item Count'    ACTION MsgInfo ( 'Item Count:  '    + HB_NTOS ( Form_1.Grid_1.ItemCount   ) )
            MENUITEM 'Get Rows Per Page' ACTION MsgInfo ( 'Rows Per Page:  ' + HB_NTOS ( Form_1.Grid_1.RowsPerPage ) )
            MENUITEM 'Get Column Count'  ACTION MsgInfo ( 'Column Count:  '  + HB_NTOS ( Form_1.Grid_1.ColumnCount ) )
            SEPARATOR
            MENUITEM 'Set Width'         ACTION Form_1.Grid_1.Width  := Val( InputBox('Enter new Width'  , , HB_NTOS ( Form_1.Grid_1.Width  ) ) )
            MENUITEM 'Set Height'        ACTION Form_1.Grid_1.Height := Val( InputBox('Enter new Height' , , HB_NTOS ( Form_1.Grid_1.Height ) ) )
            SEPARATOR
            MENUITEM 'Exit'            ACTION Form_1.Release
         END POPUP
      END MENU

      @ 10,10 GRID Grid_1 ;
         WIDTH 620 ;
         HEIGHT 330 ;
         HEADERS {'Column 1','Column 2','Column 3','Column 4','Column 5'} ;
         WIDTHS {140,140,140,140,140} ;
         ITEMS aRows ;
         EDIT ;
         COLUMNCONTROLS { ;
            {'TEXTBOX'   , 'NUMERIC' , '$ 999,999.99'} , ;
            {'DATEPICKER', 'DROPDOWN'} , ;
            {'COMBOBOX'  , {'One' , 'Two' , 'Three'}} , ;
            { 'SPINNER'  , 1 , 40 } , ;
            { 'CHECKBOX' , 'Yes' , 'No' } ;
            }

   END WINDOW

   CENTER WINDOW Form_1

   ACTIVATE WINDOW Form_1

Return Nil

