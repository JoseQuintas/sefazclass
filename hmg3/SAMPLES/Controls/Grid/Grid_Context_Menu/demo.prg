/*
   Grid Events Demo
   Demo2.prg - ContextMenu and ToolTip for each Grid column
   Enhanced by Pablo César Arrascaeta
   On March 7th, 2015
*/

#include <hmg.ch>

Function Main()
Private cMsg, aRows [21] [3]

aRows  [1]  := {'Simpson',  'Homer',    '555-5555'}
aRows  [2]  := {'Mulder',   'Fox',      '324-6432'}
aRows  [3]  := {'Smart',    'Max',      '432-5892'}
aRows  [4]  := {'Grillo',   'Pepe',     '894-2332'}
aRows  [5]  := {'Kirk',     'James',    '346-9873'}
aRows  [6]  := {'Barriga',  'Carlos',   '394-9654'}
aRows  [7]  := {'Flanders', 'Ned',      '435-3211'}
aRows  [8]  := {'Smith',    'John',     '123-1234'}
aRows  [9]  := {'Pedemonti','Flavio',   '000-0000'}
aRows [10]  := {'Gomez',    'Juan',     '583-4832'}
aRows [11]  := {'Fernandez','Raul',     '321-4332'}
aRows [12]  := {'Borges',   'Javier',   '326-9430'}
aRows [13]  := {'Alvarez',  'Alberto',  '543-7898'}
aRows [14]  := {'Gonzalez', 'Ambo',     '437-8473'}
aRows [15]  := {'Batistuta','Gol',      '485-2843'}
aRows [16]  := {'Vinazzi',  'Amigo',    '394-5983'}
aRows [17]  := {'Pedemonti','Flavio',   '534-7984'}
aRows [18]  := {'Samarbide','Armando',  '854-7873'}
aRows [19]  := {'Pradon',   'Alejandra','???-????'}
aRows [20]  := {'Reyes',    'Monica',   '432-5836'}
aRows [21]  := {'Fernández','Vicente',  '000-0000'}

DEFINE WINDOW Form_1 ;
    AT 0,0 ;
    WIDTH 426 ;
    HEIGHT 395 ;
    TITLE 'Grid Events Demo - ContextMenu for each column' ;
    MAIN NOSIZE
   
   DEFINE STATUSBAR FONT "Courier New" SIZE 9
        STATUSITEM PadC("",75)
    END STATUSBAR
   
    @ 10,10 GRID Grid_1 ;
        WIDTH 400 ;
        HEIGHT 330 ;
        HEADERS {'Column 1','Column 2','Column 3'} ;
        WIDTHS {120,120,120} ;
      TOOLTIP "ToolTip for Grid" ;
      ON CHANGE Define_Column_ToolTip("Form_1","Grid_1") ;
      ITEMS aRows ;
        VALUE {1,1} ;
        CELLNAVIGATION
   
   Define_Control_Context_Menu("Form_1","Grid_1",1) // Needs to start definition for this control
   
END WINDOW
// CREATE EVENT PROCNAME Check_Grid_Events HWND Form_1.Grid_1.HANDLE
SET CONTROL Grid_1 OF Form_1 ONMOUSEEVENT Check_Grid_Events()
CENTER WINDOW Form_1
ACTIVATE WINDOW Form_1
Return Nil

Function Check_Grid_Events()
Local aCell, nMsg := EventMsg()
Static cCtrlSelected:=""

If nMsg == WM_RBUTTONDOWN
   aCell:=GetCellClicked("Form_1","Grid_1")
   SetProperty("Form_1","Grid_1","Value",aCell)
   Define_Control_Context_Menu("Form_1","Grid_1",aCell[2])
Endif
Return Nil

Function GetCellClicked(cForm,cControl)
Local aRet, nIndex:=GetControlIndex(cControl,cForm)
Local aCellData:=_GetGridCellData(nIndex)

aRet:={aCellData[1],aCellData[2]}
Return aRet

Function Define_Control_Context_Menu(cParentForm,cControl,nColumn)
If IsControlContextMenuDefined( cControl, cParentForm )
   ReleaseControlContextMenu( cControl, cParentForm )
Endif
Do Case
   Case nColumn=1
        DEFINE CONTROL CONTEXTMENU &cControl OF &cParentForm
            ITEM "Option 1 (Column 1)" ACTION MsgInfo("Grid Column 1 | Option 1")
            ITEM "Option 2 (Column 1)" ACTION MsgInfo("Grid Column 1 | Option 2")
            ITEM "Option 3 (Column 1)" ACTION MsgInfo("Grid Column 1 | Option 3")
        END MENU
   Case nColumn=2
        DEFINE CONTROL CONTEXTMENU &cControl OF &cParentForm
            ITEM "Option 1 (Column 2)" ACTION MsgInfo("Grid Column 2 | Option 1")
            ITEM "Option 2 (Column 2)" ACTION MsgInfo("Grid Column 2 | Option 2")
            ITEM "Option 3 (Column 2)" ACTION MsgInfo("Grid Column 2 | Option 3")
        END MENU
   Case nColumn=3
        DEFINE CONTROL CONTEXTMENU &cControl OF &cParentForm
            ITEM "Option 1 (Column 3)" ACTION MsgInfo("Grid Column 3 | Option 1")
            ITEM "Option 2 (Column 3)" ACTION MsgInfo("Grid Column 3 | Option 2")
            ITEM "Option 3 (Column 3)" ACTION MsgInfo("Grid Column 3 | Option 3")
        END MENU
EndCase
Return Nil

Function Define_Column_ToolTip(cParentForm,cControl)
Local nColumn:=GetProperty(cParentForm,cControl,"CellColFocused")

Do Case
   Case nColumn=1
        _SetToolTip(cControl,cParentForm,"ToolTip Column 1")
   Case nColumn=2
        _SetToolTip(cControl,cParentForm,"ToolTip Column 2")
   Case nColumn=3
        _SetToolTip(cControl,cParentForm,"ToolTip Column 3")
EndCase
Return Nil