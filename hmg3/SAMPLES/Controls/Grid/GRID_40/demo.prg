
#include "hmg.ch"


#define _DEMO_GRID_

#ifdef _DEMO_GRID_

Function Main
Local aRows

 IF HMG SUPPORT UNICODE RUN
// IF HMG SUPPORT UNICODE STOP


// MsgDebug demo
//---------------------------------------------------------------------------------------
   n:= 10
   aData := { "Number", 38, "aRGB", YELLOW, "Hello" }
//   cMsg  := MsgDebug ( TIME(), aData, {|| NIL}, .F., EVAL({|| DATE ()}), n == 3 )
//-------------------------------------------------------------------------------------


   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 800 ;
      HEIGHT 600 ;
      TITLE "Demo: GRID Extended" ;
      MAIN 

      aRows := ARRAY (20)
      aRows [1]   := {'Simpson',    'Homer',       '555-5555',   1, HMG_TimeToTime( TIME(), _TIMESHORT12H )}
      aRows [2]   := {'Mulder',     'Fox',         '324-6432',   2, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [3]   := {'Smart',      'Max',         '432-5892',   3, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [4]   := {'Grillo',     'Pepe',        '894-2332',   4, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [5]   := {'Kirk',       'James',       '346-9873',   5, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [6]   := {'Barriga',    'Carlos',      '394-9654',   6, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [7]   := {'Flanders',   'Ned',         '435-3211',   7, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [8]   := {'Smith',      'John',        '123-1234',   8, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [9]   := {'Pedemonti',  'Flavio',      '000-0000',   9, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [10]  := {'Gomez',      'Juan',        '583-4832',  10, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [11]  := {'Fernandez',  'Raul',        '321-4332',  11, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [12]  := {'Borges',     'Javier',      '326-9430',  12, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [13]  := {'Alvarez',    'Alberto',     '543-7898',  13, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [14]  := {'Gonzalez',   'Ambo',        '437-8473',  14, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [15]  := {'Batistuta',  'Gol',         '485-2843',  15, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [16]  := {'Vinazzi',    'Amigo',       '394-5983',  16, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [17]  := {'Pedemonti',  'Flavio',      '534-7984',  17, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [18]  := {'Samarbide',  'Armando',     '854-7873',  18, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [19]  := {'Pradon',     'Alejandra',   '???-????',  19, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 
      aRows [20]  := {'Reyes',      'Monica',      '432-5836',  20, HMG_TimeToTime( TIME(), _TIMESHORT12H )} 


      bColor := { || if ( This.CellRowIndex/2 == int(This.CellRowIndex/2) , {128,128,128} , {192,192,192} ) }
      fColor := { || if ( This.CellRowIndex/2 == int(This.CellRowIndex/2) , BLUE , RED ) }


      CellNavigationColor (_SELECTEDCELL_FORECOLOR, BROWN)
      CellNavigationColor (_SELECTEDCELL_BACKCOLOR, GREEN)
      CellNavigationColor (_SELECTEDCELL_DISPLAYCOLOR, .T.)

 
      CellNavigationColor (_SELECTEDROW_FORECOLOR, YELLOW)
      CellNavigationColor (_SELECTEDROW_BACKCOLOR, BROWN)
      CellNavigationColor (_SELECTEDROW_DISPLAYCOLOR, .T.)

 
      @ 50,10 GRID Grid_1 ;
         WIDTH 750 ;
         HEIGHT 140 ;
         HEADERS {'Last Name', 'First Name', '*--- Phone ----------------*', 'Row', 'Time'};
         WIDTHS  {140, 140, 40, 140, 140};
         ITEMS aRows; 
         BACKCOLOR BLACK;         
         FONTCOLOR WHITE;
         BOLD;
         COLUMNCONTROLS {NIL,NIL,NIL, { 'SPINNER', 0 , 50 }, { "TIMEPICKER", _TIMESHORT12H }};
         VALUE 1 EDIT;           
         DYNAMICBACKCOLOR {bColor, bColor, bColor, bColor, bColor};         
         DYNAMICFORECOLOR {fColor, fColor, fColor, fColor, fColor};
         TOOLTIP 'Editable Grid Control'; 
         CELLNAVIGATION


      Form_1.Grid_1.ColumnHEADER (1) :=  "--- Last Name ---"
      Form_1.Grid_1.ColumnWIDTH  (1) := 100
      Form_1.Grid_1.ColumnJUSTIFY (1) := GRID_JTFY_CENTER
      Form_1.Grid_1.ColumnCONTROL  (1) := {'TEXTBOX','CHARACTER','@!'}
      Form_1.Grid_1.ColumnDYNAMICFORECOLOR (1) := {|| BLACK}
      Form_1.Grid_1.ColumnDYNAMICBACKCOLOR (1) := {|| PURPLE}
      Form_1.Grid_1.ColumnVALID (1) := {|| NIL}
      Form_1.Grid_1.ColumnWHEN (1) := {|| NIL}
      Form_1.Grid_1.ColumnONHEADCLICK (1) := {|| MsgInfo (Form_1.Grid_1.ColumnHEADER(1))}

      Form_1.Grid_1.ColumnONHEADCLICK (3) := {|| Form_1.Grid_1.ColumnWIDTH (3) := GRID_WIDTH_AUTOSIZEHEADER}
      Form_1.Grid_1.ColumnONHEADCLICK (5) := {|| Form_1.Grid_1.ColumnWIDTH (5) := GRID_WIDTH_AUTOSIZE}


      Form_1.Grid_1.AddItem   ( {'lolo','JUAN','333-9999', 21, HMG_TimeToTime(TIME(),_TIMESHORT12H)}      )   // Added this item in the END of the GRID 
      Form_1.Grid_1.AddItemEx ( {'Lolo','LOLO','333-9999', 22, HMG_TimeToTime(TIME(),_TIMESHORT12H)}, NIL )   // Added this item in the END of the GRID
      Form_1.Grid_1.AddItemEx ( {'hmg', 'JUAN','333-9999', 23, HMG_TimeToTime(TIME(),_TIMESHORT12H)},   3 )   // Added this item in Row 3

      cPicture := "C:\hmg.3.1.3\DOC\data\HMG_UNICODE_DOC\HMG-UNICODE.bmp"
      //Form_1.Grid_1.BackGroundImage (GRID_SETBKIMAGE_TILE, cPicture, 45, 0)

      n := 5
      flag := .T.
      @ 250,  55 BUTTON Button_1 CAPTION "AddCol" ACTION Form_1.Grid_1.AddColumnEx (NIL, "Col"+alltrim(str(++n)), 100, NIL, {'TEXTBOX','NUMERIC','$ 999,999'})
      @ 250, 155 BUTTON Button_2 CAPTION "DelCol" ACTION IF (n>5, Form_1.Grid_1.DeleteColumn (n--), NIL)
      @ 250, 255 BUTTON Button_3 CAPTION "Change Col #5" ACTION {||flag := .NOT.(flag), Form_1.Grid_1.ColumnCONTROL (5) := IIF (flag == .T.,{ "TIMEPICKER", _TIMESHORT12H },{ "TIMEPICKER", _TIMELONG24H })}
      @ 250, 355 BUTTON Button_4 CAPTION "TEST VELOCITY" ACTION TEST_VELOCITY()


      @ 350, 275 LABEL Label_1 VALUE "" AUTOSIZE

      @ 350, 100 TIMEPICKER TimePicker_1  VALUE "04:30:33 pm" FORMAT _TIMELONG24H SHOWNONE WIDTH 130 FONT "Times New Roman" SIZE 12 BOLD ITALIC UNDERLINE STRIKEOUT TOOLTIP "Clock...";
                 ON GOTFOCUS  {||Form_1.Label_1.Value := "TimePicker1 GotFocus"};  
                 ON CHANGE    {||Form_1.Label_1.Value := "TimePicker1 Change"};  
                 ON LOSTFOCUS {||Form_1.Label_1.Value := "TimePicker1 LostFocus"}; 
                 ON ENTER     {||Form_1.Label_1.Value := "TimePicker1 Enter"} 


      @ 400,  50 BUTTON Button_5 CAPTION "GetTimePicker#1" ACTION MsgInfo({"Value: ",Form_1.TimePicker_1.Value, " Format: ", Form_1.TimePicker_1.Format})
      @ 400, 150 BUTTON Button_6 CAPTION "SetTimePicker#1" ACTION {|| Form_1.TimePicker_1.Format := _TIMESHORT12H, Form_1.TimePicker_1.Value := "18:30:00" }


      DEFINE TIMEPICKER    TimePicker_2
            PARENT         Form_1
            ROW            350            
            COL            500
            WIDTH          200
            HEIGHT         50
            FONTNAME       "Arial"
            FONTSIZE       18
            FONTBOLD       .T.
            FONTITALIC     .T.
            FONTUNDERLINE  .T.
            FONTSTRIKEOUT  .F.
            TOOLTIP        "TimePicker 2"
            ONGOTFOCUS     Form_1.Label_1.Value := "TimePicker2: OnGotFocus"
            ONLOSTFOCUS    Form_1.Label_1.Value := "TimePicker2: OnLostFocus"
            ONCHANGE       Form_1.Label_1.Value := "TimePicker2: OnChange"
            TABSTOP        .T.
            VISIBLE        .T.
            VALUE          Time()
            FORMAT         _TIMESHORT24H
            SHOWNONE       .T.
            ONENTER        Form_1.Label_1.Value := "TimePicker2: OnEnter"
      END TIMEPICKER
      
      
   END WINDOW

   CENTER WINDOW Form_1

   ACTIVATE WINDOW Form_1

Return


//---------------------------------
PROCEDURE TEST_VELOCITY
//---------------------------------
LOCAL t1, t2, t3, t4, i, k, xValue

   MsgInfo ("Test VELOCITY (Read/Write): GRID.Cell() vs. GRID.ExCell()", "BEGIN TEST")

   t1 := HB_MILLISECONDS ()
      FOR i = 1 TO Form_1.Grid_1.ItemCount
         FOR k = 1 TO Form_1.Grid_1.ColumnCount
            xValue := Form_1.Grid_1.Cell (i,k)
            IF k == 1
               xValue := ALLTRIM(STR(i)) +") "+ xValue
            ENDIF
            Form_1.Grid_1.Cell (i,k) := xValue
         NEXT
      NEXT
   t2 := HB_MILLISECONDS ()

   MsgInfo ({"GRID.Cell:",t2-t1," MilliSeconds"}, "END TEST VELOCITY GRID.Cell")


   t3 := HB_MILLISECONDS ()
      FOR i = 1 TO Form_1.Grid_1.ItemCount
         FOR k = 1 TO Form_1.Grid_1.ColumnCount
            xValue := Form_1.Grid_1.CellEx (i,k)
            IF k == 1
               xValue := ALLTRIM(STR(i)) +") "+ xValue
            ENDIF
            Form_1.Grid_1.CellEx (i,k) := xValue
         NEXT
      NEXT
   t4 := HB_MILLISECONDS ()
   
   MsgInfo ({"GRID.CellEx:",t4-t3," MilliSeconds"}, "END TEST VELOCITY GRID.CellEx")
   
   MsgInfo ({"GRID.Cell:",t2-t1," MilliSeconds", CHR(13)+"GRID.CellEx:",t4-t3," MilliSeconds", CHR(13)+CHR(13)+"Read/Write with GRID.CellEx is ",(t2-t1)/(t4-t3)," times more fast that GRID.Cell"},"TEST VELOCITY")
   
RETURN


********************************************************************************************
#else
********************************************************************************************


FUNCTION Main

   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 400 ;
      HEIGHT 300 ; 
      TITLE "Demo: Enable/Disable Window/Control Event" ;
      ON GOTFOCUS Form_ONGOTFOCUS();
      MAIN 

      @ 50,  50 BUTTON Button_1 CAPTION "Click" ACTION MsgInfo ("Hello")
      @ 100, 50 BUTTON Button_2 CAPTION "Minimize" ACTION Form_1.Minimize
      @ 150, 50 TIMEPICKER TimePicker_1 ON GOTFOCUS Control_ONGOTFOCUS ()

   END WINDOW

   CENTER WINDOW Form_1

   ACTIVATE WINDOW Form_1

RETURN


PROCEDURE Form_ONGOTFOCUS
LOCAL i := GetLastActiveControlIndex ()
   DISABLE WINDOW EVENT OF Form_1
   MsgInfo ("ON GOTFOCUS: Form_1 " + IIF (i > 0," - Last Control Focused : "+_HMG_SYSDATA [2] [i],""))
   ENABLE WINDOW EVENT OF Form_1
RETURN


PROCEDURE Control_ONGOTFOCUS
LOCAL i := GetLastActiveFormIndex ()
      DISABLE WINDOW EVENT OF Form_1                  //   -->   StopWindowEventProcedure ("Form_1", .T.)
      DISABLE CONTROL EVENT TimePicker_1 OF Form_1    //   -->   StopControlEventProcedure ("TimePicker_1", "Form_1", .T.)
      MsgInfo ("ON GOTFOCUS: TimePicker_1" + IIF (i > 0," - Last Form Focused : "+_HMG_SYSDATA [66] [i],""))
      ENABLE CONTROL EVENT TimePicker_1 OF Form_1     //   -->   StopControlEventProcedure ("TimePicker_1", "Form_1", .F.)
      ENABLE WINDOW EVENT OF Form_1                   //   -->   StopWindowEventProcedure ("Form_1", .F.)
RETURN


#endif

