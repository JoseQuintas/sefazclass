
#include "hmg.ch"

Function Main()

DEFINE WINDOW Form_1;
    AT 0, 0; 
    WIDTH 800 HEIGHT 500 ;
    TITLE "HMG Control Context Menu" ;
    MAIN
    
    
    DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 85,85 FONT "Arial" SIZE 9 FLAT BORDER
        BUTTON button1 CAPTION "ContexMenu: ON" PICTURE "button1.bmp" ACTION ON_OFF_ContexMenu()
        BUTTON button2 CAPTION "CTRL ContexMenu: ON" PICTURE "button1.bmp" ACTION ON_OFF_CTRL_ContexMenu()
        BUTTON button3 CAPTION "Button 2" PICTURE "button2.bmp" ACTION MSGINFO("ToolButton 3") DROPDOWN
        BUTTON button4 CAPTION "Button 3" PICTURE "button3.bmp" ACTION MsgInfo("ToolButton 4")
    END TOOLBAR

    DEFINE CONTEXT MENU
        ITEM "Global Form 1" ACTION MsgInfo("Global 1")
        ITEM "Global Form 2" ACTION MsgInfo("Global 2")
    END MENU

    DEFINE STATUSBAR FONT "Arial" SIZE 9
        STATUSITEM "Status 1"
        STATUSITEM "Status 2"
        STATUSITEM "Status 3"
    END STATUSBAR

    DEFINE DROPDOWN MENU BUTTON Button2
        ITEM "Item 1" ACTION MsgInfo("DropDown 1")
        ITEM "Item 2" ACTION MsgInfo("DropDown 2")
        ITEM "Item 3" ACTION MsgInfo("DropDown 3")
    END MENU

    DEFINE LABEL Label_1
        ROW    124
        COL    25
        WIDTH  120
        HEIGHT 24
        VALUE "Label_1"
        FONTNAME "Arial"
        FONTSIZE 9
        TOOLTIP ""
        FONTBOLD .F.
        FONTITALIC .F.
        FONTUNDERLINE .F.
        FONTSTRIKEOUT .F.
        HELPID NIL
        VISIBLE .T.
        TRANSPARENT .F.
        ACTION NIL
        AUTOSIZE .F.
        BACKCOLOR NIL
        FONTCOLOR NIL
    END LABEL

    DEFINE BUTTON Button_1
        ROW    157
        COL    25
        WIDTH  100
        HEIGHT 28
        CAPTION "Button_1"
        ACTION   ControlMenu ()
        FONTNAME  "Arial"
        FONTSIZE  9
        TOOLTIP  ""
        FONTBOLD  .F.
        FONTITALIC .F.
        FONTUNDERLINE .F.
        FONTSTRIKEOUT .F.
        HELPID  NIL
        FLAT    .F.
        TABSTOP .T.
        VISIBLE .T.
        TRANSPARENT .F.
    END BUTTON

   DEFINE BUTTON Button_2
        ROW    157
        COL    135
        WIDTH  100
        HEIGHT 28
        CAPTION "Button_2"
        ACTION   NIL
        FONTNAME  "Arial"
        FONTSIZE  9
        TOOLTIP  ""
        FONTBOLD  .F.
        FONTITALIC .F.
        FONTUNDERLINE .F.
        FONTSTRIKEOUT .F.
        HELPID  NIL
        FLAT    .F.
        TABSTOP .T.
        VISIBLE .T.
        TRANSPARENT .F.
    END BUTTON

    DEFINE CHECKBOX Check_1
        ROW    115
        COL    169
        WIDTH  100
        HEIGHT 28
        CAPTION "Check_1"
        VALUE   .F.
        FONTNAME  "Arial"
        FONTSIZE  9
        TOOLTIP  ""
        ONCHANGE  NIL
        FONTBOLD  .F.
        FONTITALIC .F.
        FONTUNDERLINE .F.
        FONTSTRIKEOUT .F.
        BACKCOLOR NIL
        FONTCOLOR NIL
        HELPID  NIL
        TABSTOP .T.
        VISIBLE .T.
        TRANSPARENT .F.
    END CHECKBOX

    DEFINE LISTBOX List_1
        ROW    239
        COL    25
        WIDTH  100
        HEIGHT 100
        ITEMS {"Item1","Item2"}
        VALUE  0
        FONTNAME "Arial"
        FONTSIZE  9
        TOOLTIP   ""
        ONCHANGE  NIL
        FONTBOLD  .F.
        FONTITALIC .F.
        FONTUNDERLINE .F.
        FONTSTRIKEOUT .F.
        BACKCOLOR NIL
        FONTCOLOR NIL
        ONDBLCLICK NIL
        HELPID  NIL
        TABSTOP .T.
        VISIBLE .T.
        SORT .F.
        MULTISELECT .F.
    END LISTBOX

    DEFINE COMBOBOX Combo_1
        ROW    357
        COL    25
        WIDTH  100
        HEIGHT 100
        ITEMS {"Item1","Item2"}
        VALUE 0
        FONTNAME "Arial"
        FONTSIZE 9
        TOOLTIP ""
        ONCHANGE NIL
        FONTBOLD  .F.
        FONTITALIC .F.
        FONTUNDERLINE .F.
        FONTSTRIKEOUT .F.
        HELPID NIL
        TABSTOP .T.
        VISIBLE .T.
        SORT .F.
        ONENTER NIL
        ONDISPLAYCHANGE NIL
        DISPLAYEDIT .F.
    END COMBOBOX

    DEFINE CHECKBUTTON CheckBtn_1
        ROW    197
        COL    25
        WIDTH  100
        HEIGHT 28
        CAPTION "CheckBtn_1"
        VALUE   .F.
        FONTNAME  "Arial"
        FONTSIZE  9
        TOOLTIP   ""
        ONCHANGE  NIL
        FONTBOLD  .F.
        FONTITALIC .F.
        FONTUNDERLINE .F.
        FONTSTRIKEOUT .F.
        HELPID  NIL
        TABSTOP .T.
        VISIBLE .T.
        PICTURE NIL
    END CHECKBUTTON

    DEFINE GRID Grid_1
        ROW    208
        COL    169
        WIDTH  179
        HEIGHT 87
        ITEMS {{"Item1","Item2"},{"Item3","Item4"}}
        VALUE 0
        WIDTHS {60,60}
        HEADERS {'Head1','Head2'}
        FONTNAME "Arial"
        FONTSIZE 9
        TOOLTIP ""
        ONCHANGE NIL
        FONTBOLD .F.
        FONTITALIC .F.
        FONTUNDERLINE .F.
        FONTSTRIKEOUT .F.
        ONDBLCLICK NIL
        ONHEADCLICK NIL
        ONQUERYDATA NIL
        MULTISELECT .F.
        ALLOWEDIT .F.
        VIRTUAL .F.
        NOLINES .F.
        HELPID NIL
        IMAGE NIL
        JUSTIFY NIL
        ITEMCOUNT NIL
        BACKCOLOR NIL
        FONTCOLOR NIL
    END GRID

    DEFINE SLIDER Slider_1
        ROW    307
        COL    169
        WIDTH  120
        HEIGHT 36
        RANGEMIN 1
        RANGEMAX 10
        VALUE 0
        TOOLTIP ""
        ONCHANGE NIL
        HELPID NIL
        TABSTOP .T.
        VISIBLE .T.
        BACKCOLOR NIL
    END SLIDER
  
    DEFINE IMAGE Image_1
        ROW    110
        COL    386
        WIDTH  100
        HEIGHT 100
        PICTURE "image1.bmp"
        HELPID   NIL
        VISIBLE  .T.
        STRETCH  .F.
        ACTION   NIL
    END IMAGE

    
    DEFINE RADIOGROUP RadioGroup_1
        ROW    115
        COL    269
        WIDTH  100
        HEIGHT 50
        OPTIONS {'Option 1','Option 2'}
        VALUE 1
        FONTNAME "Arial"
        FONTSIZE 9
        TOOLTIP ""
        ONCHANGE NIL
        FONTBOLD .F.
        FONTITALIC .F.
        FONTUNDERLINE .F.
        FONTSTRIKEOUT .F.
        HELPID NIL
        TABSTOP .T.
        VISIBLE .T.
        TRANSPARENT .F.
        SPACING 25
        BACKCOLOR NIL
        FONTCOLOR NIL
        HORIZONTAL .F.
    END RADIOGROUP

    DEFINE FRAME Frame_1
        ROW    222
        COL    369
        WIDTH  140
        HEIGHT 61
        FONTNAME "Arial"
        FONTSIZE 9
        FONTBOLD .F.
        FONTITALIC .F.
        FONTUNDERLINE .F.
        FONTSTRIKEOUT .F.
        CAPTION "Frame_1"
        BACKCOLOR NIL
        FONTCOLOR NIL
        OPAQUE .T.
    END FRAME

    DEFINE TAB Tab_1 AT 295,369 WIDTH 150 HEIGHT 90 VALUE 1 FONT "Arial" SIZE 9 TOOLTIP "" ON CHANGE NIL
      PAGE "Page 1"
      END PAGE
      PAGE "Page 2"
      END PAGE
    END TAB

    DEFINE PROGRESSBAR ProgressBar_1
        ROW    359
        COL    169
        WIDTH  120
        HEIGHT 24
        RANGEMIN 1
        RANGEMAX 10
        VALUE 5
        TOOLTIP ""
        HELPID NIL
        VISIBLE .T.
        SMOOTH .F.
        VERTICAL .F.
        BACKCOLOR NIL
        FORECOLOR NIL
    END PROGRESSBAR

    DEFINE TEXTBOX Text_1
        ROW    156
        COL    546
        WIDTH  120
        HEIGHT 24
        FONTNAME "Arial"
        FONTSIZE 9
        TOOLTIP ""
        ONCHANGE NIL
        FONTBOLD  .F.
        FONTITALIC .F.
        FONTUNDERLINE .F.
        FONTSTRIKEOUT .F.
        ONENTER NIL
        HELPID NIL
        TABSTOP .T.
        VISIBLE .T.
        READONLY .F.
        RIGHTALIGN .F.
        MAXLENGTH  NIL
        BACKCOLOR NIL
        FONTCOLOR NIL
        INPUTMASK NIL
        FORMAT NIL
        VALUE  "Text_1"
    END TEXTBOX

    DEFINE EDITBOX Edit_1
        ROW    198
        COL    546
        WIDTH  120
        HEIGHT 120
        VALUE "Edit_1"
        FONTNAME "Arial"
        FONTSIZE 9
        TOOLTIP ""
        ONCHANGE NIL
        FONTBOLD  .F.
        FONTITALIC .F.
        FONTUNDERLINE .F.
        FONTSTRIKEOUT .F.
        HELPID NIL
        TABSTOP .T.
        VISIBLE .T.
        READONLY .F.
        BACKCOLOR NIL
        FONTCOLOR NIL
    END EDITBOX
    
    DEFINE SPINNER Spinner_1
        ROW    360
        COL    546
        WIDTH  100
        HEIGHT 24
        RANGEMIN 1
        RANGEMAX 10
        VALUE 0
        FONTNAME "Arial"
        FONTSIZE 9
        TOOLTIP ""
        ONCHANGE NIL
        FONTBOLD .F.
        FONTITALIC .F.
        FONTUNDERLINE .F.
        FONTSTRIKEOUT .F.
        HELPID NIL
        TABSTOP .T.
        VISIBLE .T.
        WRAP .F.
        READONLY .F.
        INCREMENT 1
        BACKCOLOR NIL
        FORECOLOR NIL
    END SPINNER


Define_Control_Context_Menu ("Label_1")
Define_Control_Context_Menu ("Button_1")
Define_Control_Context_Menu ("Button_2")
Define_Control_Context_Menu ("Check_1")
Define_Control_Context_Menu ("List_1")
Define_Control_Context_Menu ("Combo_1")
Define_Control_Context_Menu ("CheckBtn_1")
Define_Control_Context_Menu ("Grid_1")
Define_Control_Context_Menu ("Slider_1")
Define_Control_Context_Menu ("Image_1")
Define_Control_Context_Menu ("RadioGroup_1")
Define_Control_Context_Menu ("Tab_1")
Define_Control_Context_Menu ("ProgressBar_1")
Define_Control_Context_Menu ("ToolBar_1")
Define_Control_Context_Menu ("StatusBar")
Define_Control_Context_Menu ("Spinner_1")
    
    
END WINDOW
CENTER WINDOW Form_1
ACTIVATE WINDOW Form_1
Return Nil



PROCEDURE Define_Control_Context_Menu (cComponent)

Do Case
   Case cComponent="Label_1"
        DEFINE CONTROL CONTEXTMENU &cComponent OF Form_1
            ITEM "Label 1" ACTION MsgInfo("Label 1")
            ITEM "Label 2" ACTION MsgInfo("Label 2")
            ITEM "Label 3" ACTION MsgInfo("Label 3")
        END MENU
   Case cComponent="Button_1"
        DEFINE CONTROL CONTEXTMENU &cComponent OF Form_1
            ITEM "Button 1" ACTION MsgInfo("Button 1")
            ITEM "Button 2" ACTION MsgInfo("Button 2")
            ITEM "Button 3" ACTION MsgInfo("Button 3")
        END MENU
   Case cComponent="Button_2"
        DEFINE CONTROL CONTEXTMENU &cComponent OF Form_1
            ITEM "Button 4" ACTION MsgInfo("Button 4")
            ITEM "Button 5" ACTION MsgInfo("Button 5")
            ITEM "Button 6" ACTION MsgInfo("Button 6")
        END MENU
   Case cComponent="Check_1"
        DEFINE CONTROL CONTEXTMENU &cComponent OF Form_1
            ITEM "Check 1" ACTION MsgInfo("Check 1")
            ITEM "Check 2" ACTION MsgInfo("Check 2")
            ITEM "Check 3" ACTION MsgInfo("Check 3")
        END MENU
   Case cComponent="List_1"
        DEFINE CONTROL CONTEXTMENU &cComponent OF Form_1
            ITEM "List 1" ACTION MsgInfo("List 1")
            ITEM "List 2" ACTION MsgInfo("List 2")
            ITEM "List 3" ACTION MsgInfo("List 3")
        END MENU
   Case cComponent="Combo_1"
        DEFINE CONTROL CONTEXTMENU &cComponent OF Form_1
            ITEM "Combo 1" ACTION MsgInfo("Combo 1")
            ITEM "Combo 2" ACTION MsgInfo("Combo 2")
            ITEM "Combo 3" ACTION MsgInfo("Combo 3")
        END MENU
   Case cComponent="CheckBtn_1"
        DEFINE CONTROL CONTEXTMENU &cComponent OF Form_1
            ITEM "CheckBtn 1" ACTION MsgInfo("CheckBtn 1")
            ITEM "CheckBtn 2" ACTION MsgInfo("CheckBtn 2")
            ITEM "CheckBtn 3" ACTION MsgInfo("CheckBtn 3")
        END MENU
   Case cComponent="Grid_1"
        DEFINE CONTROL CONTEXTMENU &cComponent OF Form_1
            ITEM "Grid 1" ACTION MsgInfo("Grid 1")
            ITEM "Grid 2" ACTION MsgInfo("Grid 2")
            ITEM "Grid 3" ACTION MsgInfo("Grid 3")
        END MENU
   Case cComponent="Slider_1"
        DEFINE CONTROL CONTEXTMENU &cComponent OF Form_1
            ITEM "Slider 1" ACTION MsgInfo("Slider 1")
            ITEM "Slider 2" ACTION MsgInfo("Slider 2")
            ITEM "Slider 3" ACTION MsgInfo("Slider 3")
        END MENU
   Case cComponent="Image_1"
        DEFINE CONTROL CONTEXTMENU &cComponent OF Form_1
            ITEM "Image 1" ACTION MsgInfo("Image 1")
            ITEM "Image 2" ACTION MsgInfo("Image 2")
            ITEM "Image 3" ACTION MsgInfo("Image 3")
        END MENU
   Case cComponent="RadioGroup_1"
        DEFINE CONTROL CONTEXTMENU &cComponent OF Form_1
            ITEM "RadioGroup 1" ACTION MsgInfo("RadioGroup 1")
            ITEM "RadioGroup 2" ACTION MsgInfo("RadioGroup 2")
            ITEM "RadioGroup 3" ACTION MsgInfo("RadioGroup 3")
        END MENU
   Case cComponent="Tab_1"
        DEFINE CONTROL CONTEXTMENU &cComponent OF Form_1
            ITEM "Tab 1" ACTION MsgInfo("Tab 1")
            ITEM "Tab 2" ACTION MsgInfo("Tab 2")
            ITEM "Tab 3" ACTION MsgInfo("Tab 3")
        END MENU
   Case cComponent="ProgressBar_1"
        DEFINE CONTROL CONTEXTMENU &cComponent OF Form_1
            ITEM "ProgressBar 1" ACTION MsgInfo("ProgressBar 1")
            ITEM "ProgressBar 2" ACTION MsgInfo("ProgressBar 2")
            ITEM "ProgressBar 3" ACTION MsgInfo("ProgressBar 3")
        END MENU
   Case cComponent="ToolBar_1"
        DEFINE CONTROL CONTEXTMENU &cComponent OF Form_1
            ITEM "ToolBar 1" ACTION MsgInfo("ToolBar 1")
            ITEM "ToolBar 2" ACTION MsgInfo("ToolBar 2")
            ITEM "ToolBar 3" ACTION MsgInfo("ToolBar 3")
        END MENU
   Case cComponent="StatusBar"
        DEFINE CONTROL CONTEXTMENU &cComponent OF Form_1
            ITEM "StatusBar 1" ACTION MsgInfo("StatusBar 1")
            ITEM "StatusBar 2" ACTION MsgInfo("StatusBar 2")
            ITEM "StatusBar 3" ACTION MsgInfo("StatusBar 3")
        END MENU
   Case cComponent="Spinner_1"
        DEFINE CONTROL CONTEXTMENU &cComponent OF Form_1
            ITEM "Spinner 1" ACTION MsgInfo("Spinner 1")
            ITEM "Spinner 2" ACTION MsgInfo("Spinner 2")
            ITEM "Spinner 3" ACTION MsgInfo("Spinner 3")
        END MENU
Endcase
RETURN



Procedure ControlMenu
   IF IsControlContextMenuDefined ( "Image_1", "Form_1") == .T.
      RELEASE CONTROL CONTEXTMENU Image_1 OF Form_1
      // ReleaseControlContextMenu ( "Image_1", "Form_1")
   ENDIF
   
   DEFINE CONTROL CONTEXTMENU Image_1 OF Form_1
      ITEM "New Image 1" ACTION MsgInfo("Image 1")
      ITEM "New Image 2" ACTION MsgInfo("Image 2")
      ITEM "New Image 3" ACTION MsgInfo("Image 3")
   END MENU
   MsgInfo ("Set new CONTROL CONTEXTMENU in Image_1")
Return


PROCEDURE ON_OFF_ContexMenu()
STATIC ON := .T.
    ON := .NOT. (ON)
    IF ON == .T.
       SET CONTEXT MENU ON
       Form_1.ToolBar_1.Button1.CAPTION := "ContexMenu: ON"
    ELSE
       SET CONTEXT MENU OFF
       Form_1.ToolBar_1.Button1.CAPTION := "ContexMenu: OFF"
    ENDIF
    MsgInfo ("Global CONTEXT MENU: "+IF(ON, "Enable","Disable"))
RETURN



PROCEDURE ON_OFF_CTRL_ContexMenu()
STATIC ON := .T.
    ON := .NOT. (ON)
    IF ON == .T.
       SET CONTROL CONTEXT MENU ON
       Form_1.ToolBar_1.Button2.CAPTION := "CTRL ContexMenu: ON"
    ELSE
       SET CONTROL CONTEXT MENU OFF
       Form_1.ToolBar_1.Button2.CAPTION := "CTRL ContexMenu: OFF"
    ENDIF
    MsgInfo ("CONTROL CONTEXT MENU: "+IF(ON, "Enable","Disable"))
RETURN

