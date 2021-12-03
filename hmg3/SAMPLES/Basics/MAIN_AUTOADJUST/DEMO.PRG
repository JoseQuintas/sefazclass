/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

Function Main()
Private nMainW:=640, nMainH:=490

SET TOOLTIPSTYLE BALLOON

DEFINE WINDOW Form_1 ;
    AT 0,0 ;
    WIDTH nMainW HEIGHT nMainH ;
    TITLE 'HMG Demo' ;
    ICON 'DEMO.ICO' ;
    MAIN ;
    ON INIT AutoAdjust( ThisWindow.Name );
    ON MAXIMIZE AutoAdjust( ThisWindow.Name );
    ON SIZE AutoAdjust( ThisWindow.Name );
    FONT 'Arial' SIZE 10 
  
    ON KEY ESCAPE ACTION ThisWindow.Release
  
    DEFINE STATUSBAR
        STATUSITEM 'HMG Power Ready!' 
    END STATUSBAR

    ON KEY ALT+A ACTION MsgInfo('Alt+A Pressed')

    DEFINE MAIN MENU 
        DEFINE POPUP '&File'
            ITEM 'InputWindow Test' ACTION InputWindow_Click()
            ITEM 'More Tests'   ACTION Modal_CLick()    NAME File_Modal
            ITEM 'Topmost WIndow'   ACTION Topmost_Click()  NAME File_TopMost
            ITEM 'Standard WIndow'  ACTION Standard_Click()
            ITEM 'Editable Grid Test' ACTION EditGrid_Click()
            ITEM 'Child Window Test' ACTION Child_Click()
            SEPARATOR   
            POPUP 'More...'
                ITEM 'SubItem 1'    ACTION MsgInfo( 'SubItem Clicked' )
                ITEM 'SubItem 2'    ACTION MsgInfo( 'SubItem2 Clicked' )
            END POPUP
            SEPARATOR   
            ITEM 'Multiple Window Activation'   ACTION MultiWin_Click() 
            SEPARATOR   
            ITEM 'Capture (Without Arguments)'  ACTION Form_1.Capture() 
            ITEM 'Capture (With Arguments)'     ACTION Form_1.Capture( 'xxx.bmp' , 10,10,200,200 ) 
            SEPARATOR   
            ITEM 'Exit'     ACTION Form_1.Release
        END POPUP
        DEFINE POPUP 'F&older Functions'
            ITEM 'GetWindowsFolder()'   ACTION MsgInfo ( GetWindowsFolder() )
            ITEM 'GetSystemFolder()'    ACTION MsgInfo ( GetSystemFolder() )
            ITEM 'GetMyDocumentsFolder()'   ACTION MsgInfo ( GetMyDocumentsFolder() )
            ITEM 'GetDesktopFolder()'   ACTION MsgInfo ( GetDesktopFolder() )
            ITEM 'GetProgramFilesFolder()'  ACTION MsgInfo ( GetProgramFilesFolder())
            ITEM 'GetTempFolder()'      ACTION MsgInfo ( GetTempFolder() ) 
            SEPARATOR
            ITEM 'GetFolder()'      ACTION MsgInfo(GetFolder())
        END POPUP
        DEFINE POPUP 'Common &Dialog Functions'
            ITEM 'GetFile()'    ACTION Getfile ( { {'Images','*.jpg'} } , 'Open Image' )
            ITEM 'PutFile()'    ACTION Putfile ( { {'Images','*.jpg'} } , 'Save Image' )
            ITEM 'GetFont()'    ACTION GetFont_Click()
            ITEM 'GetColor()'   ACTION GetColor_Click()
        END POPUP
        DEFINE POPUP 'Sound F&unctions'
            ITEM 'PlayBeep()'    ACTION PlayBeep() 
            ITEM 'PlayAsterisk()'    ACTION PlayAsterisk() 
            ITEM 'PlayExclamation()' ACTION PlayExclamation() 
            ITEM 'PlayHand()'    ACTION PlayHand() 
            ITEM 'PlayQuestion()'    ACTION PlayQuestion() 
            ITEM 'PlayOk()'      ACTION PlayOk() 
        END POPUP
        DEFINE POPUP 'M&isc'
            ITEM 'MemoryStatus() Function (Contributed by Grigory Filatov)' ACTION MemoryTest() 
            ITEM 'ShellAbout() Function (Contributed by Manu Exposito' ACTION ShellAbout( "This application", 'AutoAdjust HMG Demo - version 2.0' + ;
                 CRLF + Chr(169)+" Contributed by MigSoft / Danny / Pablo César", LoadTrayIcon(GetInstance(), "MAIN") )
            ITEM 'BackColor / FontColor Clauses (Contributed by Ismael Dutra)' ACTION Color_CLick() 
            SEPARATOR
            ITEM 'Get Control Row Property'     ACTION  MsgInfo ( Str ( ( Form_1.Button_1.Row     ) ) , 'Maximize Button' )
            ITEM 'Get Control Col Property'     ACTION  MsgInfo ( Str ( ( Form_1.Button_1.Col     ) ) , 'Maximize Button' )
            ITEM 'Get Control Width Property'   ACTION  MsgInfo ( Str (  ( Form_1.Button_1.Width   ) ) , 'Maximize Button' )
            ITEM 'Get Control Hetight Property'     ACTION  MsgInfo ( Str (  ( Form_1.Button_1.Height  ) ) , 'Maximize Button' )
            SEPARATOR
            ITEM 'Set Control Row Property'     ACTION Form_1.Button_1.Row      := 35
            ITEM 'Set Control Col Property'     ACTION Form_1.Button_1.Col      := 40
            ITEM 'Set Control Width Property'   ACTION Form_1.Button_1.Width    := 150
            ITEM 'Set Control Hetight Property'     ACTION Form_1.Button_1.Height   := 50
            SEPARATOR
            ITEM 'Set Window Row Property'      ACTION Form_1.Row := 10
            ITEM 'Set Window Col Property'      ACTION Form_1.Col := 10
            ITEM 'Set Window Width Property'    ACTION Form_1.Width := 550
            ITEM 'Set Window Hetight Property'  ACTION Form_1.Height := 400
            SEPARATOR
            ITEM 'Get Window Row Property'      ACTION MsgInfo ( Str ( ( Form_1.Row    ) ) )
            ITEM 'Get Window Col Property'      ACTION MsgInfo ( Str ( ( Form_1.Col    ) ) )
            ITEM 'Get Window Width Property'    ACTION MsgInfo ( Str ( ( Form_1.Width  ) ) )
            ITEM 'Get Window Hetight Property'  ACTION MsgInfo ( Str ( ( Form_1.Height ) ) )
            SEPARATOR
            ITEM 'Execute Command'          ACTION ExecTest()
            SEPARATOR
            ITEM 'Set Title Property'       ACTION Form_1.Title := 'New Title'
            ITEM 'Get Title Property'       ACTION MsgInfo (  ( Form_1.Title ) )
            SEPARATOR
            ITEM 'Set Caption Property'     ACTION SetCaptionTest()
            ITEM 'Get Caption Property'     ACTION GetCaptionTest()
            SEPARATOR
            ITEM 'Get Picture Property'     ACTION MsgInfo (  ( Form_1.Image_1.Picture ) , 'Image_1' ) 
            SEPARATOR
            ITEM 'Set ToolTip Property'     ACTION Form_1.Button_1.ToolTip := 'New ToolTip'
            ITEM 'Get ToolTip Property'     ACTION MsgInfo (  ( Form_1.Button_1.ToolTip ) , 'Maximize Button' )
            SEPARATOR
            ITEM 'Set FontName Property'        ACTION  Form_1.Button_1.FontName := 'Verdana'
            ITEM 'Get FontName Property'        ACTION MsgInfo (  ( Form_1.Button_1.FontName ) , 'Maximize Button' )
            SEPARATOR
            ITEM 'Set FontSize Property'        ACTION Form_1.Button_1.FontSize := 14
            ITEM 'Get FontSize Property'        ACTION MsgInfo ( Str ( ( Form_1.Button_1.FontSize ) ) )
            SEPARATOR
            ITEM 'Set RangeMin Property'        ACTION Form_1.Spinner_1.RangeMin := 1
            ITEM 'Get RangeMin Property'        ACTION MsgInfo ( Str ( ( Form_1.Spinner_1.RangeMin ) ) , 'Spinner_1')
            SEPARATOR
            ITEM 'Set RangeMax Property'        ACTION Form_1.Spinner_1.RangeMax := 1000
            ITEM 'Get RangeMax Property'        ACTION MsgInfo ( Str ( ( Form_1.Spinner_1.RangeMax ) ) ,'Spinner_1')
            SEPARATOR
            ITEM 'Set Grid Caption Property'    ACTION Form_1.Tab_1(1).Grid_1.Caption(1) := 'New Caption'
            ITEM 'Get Grid Caption Property'    ACTION MsgInfo ( ( Form_1.Tab_1(1).Grid_1.Caption(1) ) ,'Grid_1')
            SEPARATOR
            ITEM 'Set RadioGroup Caption Property'  ACTION Form_1.Tab_1(2).Radio_1.Caption(1) := 'New Caption'
            ITEM 'Get RadioGroup Caption Property'  ACTION MsgInfo ( ( Form_1.Tab_1(2).Radio_1.Caption(1) ) ,'Radio_1')
            SEPARATOR
            ITEM 'Set Tab Caption Property' ACTION Form_1.Tab_1.Caption(1) := 'New Caption'
            ITEM 'Get Tab Caption Property' ACTION MsgInfo ( ( Form_1.Tab_1.Caption(1) ) ,'Tab_1')

        END POPUP
        DEFINE POPUP 'H&elp'
            ITEM 'About'        ACTION MsgInfo ("Free GUI Library For Harbour","HMG Main Demo") 
        END POPUP
    END MENU

    DEFINE CONTEXT MENU 
        ITEM 'Check File - More Tests Item' ACTION Context1_Click()
        ITEM 'UnCheck File - More Test Item'    ACTION Context2_Click() 
        ITEM 'Enable File - Topmost Window' ACTION Context3_Click()
        ITEM 'Disable File - Topmost Window'    ACTION Context4_Click()
        SEPARATOR   
        ITEM 'About'                ACTION MsgInfo ("Free GUI Library For Harbour","HMG Main Demo") 
    END MENU

    DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 32, 32 BORDER 

        BUTTON Button_TB1 ;
            PICTURE 'button1.bmp' ;
            ACTION MsgInfo('Click ToolBox 1')

        BUTTON Button_TB2 ;
            PICTURE 'button2.bmp' ;
            ACTION MsgInfo('Click ToolBox 2') ;
            SEPARATOR

        BUTTON Button_TB3 ;
            PICTURE 'button3.bmp' ;
            ACTION MsgInfo('Click ToolBox 3')

    END TOOLBAR
    
    DEFINE LABEL Label_Color
        ROW 396
        COL 330
        VALUE 'Right Click For Context Menu' 
        WIDTH 170 
        HEIGHT 22 
        FONTNAME 'Times New Roman' 
        FONTSIZE 10 
        FONTCOLOR BLUE
    END LABEL

    DEFINE LABEL Label_Color_2
        ROW 85
        COL 10
        VALUE 'ALT+A HotKey Test' 
        WIDTH 170 
        HEIGHT 22 
        FONTNAME 'Times New Roman'
        FONTSIZE 10 
        FONTCOLOR RED
    END LABEL
    
    DEFINE TIMEPICKER TimePicker_1
        PARENT Form_1
        ROW 115
        COL 10
        WIDTH 70
        HEIGHT 22
        FONTNAME 'Times New Roman'
        FONTSIZE 10
        FONTBOLD .F.
        FONTITALIC .F.
        FONTUNDERLINE .F.
        FONTSTRIKEOUT .F.
        TOOLTIP "Set time"
        ONGOTFOCUS Nil
        ONLOSTFOCUS Nil
        ONCHANGE Nil
        TABSTOP .F.
        HELPID 0
        VISIBLE .T.
        VALUE Time()
        FORMAT Nil
        SHOWNONE .F.
        ONENTER Nil
    END TIMEPICKER
    
    DEFINE CHECKBUTTON CheckButton_1
        ROW 200
        COL 140
        CAPTION 'CheckButton!' 
        VALUE .T. 
        TOOLTIP 'CheckButton' 
    END CHECKBUTTON 

    DEFINE BUTTON ImageButton_1
        ROW 200
        COL 250
        PICTURE 'button.bmp' 
        ACTION MsgInfo('Click!') 
        WIDTH 27 
        HEIGHT 27 
        TOOLTIP 'Print Preview'
    END BUTTON

    DEFINE CHECKBUTTON CheckButton_2
        ROW 200
        COL 285
        PICTURE 'open.bmp'
        WIDTH 27 
        HEIGHT 27 
        VALUE .F. 
        TOOLTIP 'Graphical CheckButton'
    END CHECKBUTTON
    
    DEFINE SLIDER Slider_1
        ROW 380
        COL 185
        HEIGHT 30
        RANGEMIN 1
        RANGEMAX 10 
        VALUE 5 
        TOOLTIP 'Slider'
    END SLIDER

    DEFINE TAB Tab_1 ;
        AT 45,195 ;
        WIDTH 430 ;
        HEIGHT 140 ;
        VALUE 1 ;
        TOOLTIP 'Tab Control' 

        DEFINE PAGE '&Grid'

            DEFINE GRID Grid_1
                ROW 30
                COL 10
                WIDTH 410 
                HEIGHT 100 
                HEADERS { '','Last Name','First Name'} 
                WIDTHS { 0,220,220}
                ITEMS { { 0,'Simpson','Homer'} , {1,'Mulder','Fox'} } 
                VALUE 1 
                TOOLTIP 'Grid Control' 
                ONHEADCLICK { {|| MsgInfo('Header 1 Clicked !')} , { || MsgInfo('Header 2 Clicked !')} } 
                IMAGE {"br_no","br_ok"} 
                ONDBLCLICK MsgInfo ('DoubleClick!','Grid') 
            END GRID

        END PAGE

        DEFINE PAGE '&Misc.'

            DEFINE FRAME TabFrame_1
                ROW 45
                COL 80
                WIDTH 130
                HEIGHT 60
            END FRAME

            DEFINE LABEL Label_1
                ROW 55
                COL 90
                VALUE '&This is a Label !!!' 
                WIDTH 100 
                HEIGHT 27 
            END LABEL

            DEFINE CHECKBOX Check_1
                ROW 75
                COL 90
                CAPTION 'Check 1' 
                VALUE .T. 
                TOOLTIP 'CheckBox' 
                ONCHANGE PLAYOK()
            END CHECKBOX

            DEFINE FRAME TabFrame_2
                ROW 45
                COL 240
                WIDTH 125 
                HEIGHT 85
            END FRAME

            DEFINE RADIOGROUP Radio_1
                ROW 50
                COL 260
                OPTIONS { 'One' , 'Two' , 'Three' } 
                VALUE 1 
                WIDTH 100 
                TOOLTIP 'RadioGroup'
                ONCHANGE PLAYOK() 
            END RADIOGROUP

        END PAGE

        DEFINE PAGE '&EditBox'

            DEFINE EDITBOX  Edit_1
                ROW 30
                COL 10
                WIDTH 410 
                HEIGHT 94
                VALUE 'EditBox!!' 
                TOOLTIP 'EditBox' 
                MAXLENGTH 255 
            END EDITBOX

        END PAGE

        DEFINE PAGE '&ProgressBar'

            DEFINE PROGRESSBAR Progress_1
                ROW 80
                COL 120
                RANGEMIN 0
                RANGEMAX 65535      
            END PROGRESSBAR
            
            DEFINE BUTTON Btn_Prg
                ROW 80
                COL 250
                CAPTION '<- !!!' 
                ACTION Animate_CLick() 
                WIDTH 50 
                HEIGHT 28 
                TOOLTIP 'Animate Progressbar'
            END BUTTON

        END PAGE

    END TAB

    DEFINE DATEPICKER Date_1
        ROW 50
        COL 10
        VALUE CTOD('  / /  ') 
        TOOLTIP 'DatePicker Control' 
        SHOWNONE .T.
    END DATEPICKER

    DEFINE BUTTON Button_1
        ROW 200
        COL 10
        CAPTION 'Maximize' 
        ACTION Maximize_Click() 
        TOOLTIP 'Maximize'
    END BUTTON

    DEFINE BUTTON Button_2
        ROW 230
        COL 10
        CAPTION 'Minimize' 
        ACTION Minimize_Click() 
    END BUTTON
    
    DEFINE BUTTON Button_3
        ROW 260
        COL 10
        CAPTION 'Restore' 
        ACTION Restore_Click()
    END BUTTON

    DEFINE BUTTON Button_4
        ROW 290
        COL 10
        CAPTION '&Hide' 
        ACTION Hide_Click()
    END BUTTON
    
    DEFINE BUTTON Button_5
        ROW 320
        COL 10
        CAPTION 'Sho&w' 
        ACTION Show_Click()
    END BUTTON

    DEFINE BUTTON Button_6
        ROW 350
        COL 10
        CAPTION 'SetFocus' 
        ACTION Setfocus_Click()
    END BUTTON

    DEFINE BUTTON Button_7
        ROW 230
        COL 140
        CAPTION 'GetValue' 
        ACTION GetValue_Click()
    END BUTTON

    DEFINE BUTTON Button_8
        ROW 260
        COL 140
        CAPTION 'SetValue' 
        ACTION SetValue_Click()
    END BUTTON

    DEFINE BUTTON Button_9
        ROW 290
        COL 140
        CAPTION 'Enable' 
        ACTION Enable_Click()
    END BUTTON

    DEFINE BUTTON Button_10
        ROW 320
        COL 140
        CAPTION 'Disable' 
        ACTION Disable_Click()
    END BUTTON

    DEFINE BUTTON Button_11
        ROW 350
        COL 140
        CAPTION 'Delete All Items' 
        ACTION DeleteAllItems_Click()
        WIDTH 150 
        HEIGHT 28
    END BUTTON

    DEFINE BUTTON Button_12
        ROW 190
        COL 510
        CAPTION 'Delete Item' 
        ACTION DeleteItem_Click()
    END BUTTON

    DEFINE BUTTON Button_13
        ROW 220
        COL 510
        CAPTION 'Add Item' 
        ACTION AddItem_Click()
    END BUTTON

    DEFINE BUTTON Button_14
        ROW 250
        COL 510
        CAPTION 'Messages' 
        ACTION Msg_Click()
    END BUTTON

    DEFINE BUTTON Button_15
        ROW 280
        COL 510
        CAPTION 'Change Image' 
        ACTION SetPict()
    END BUTTON

    DEFINE FRAME Frame_1    
        ROW     190
        COL 315
        CAPTION 'Frame' 
        WIDTH 170 
        HEIGHT 200 
    END FRAME

    DEFINE COMBOBOX Combo_1
        ROW 210
        COL 335
        ITEMS {'One','Two','Three'} 
        VALUE 2 
        TOOLTIP 'ComboBox' 
    END COMBOBOX

    DEFINE LISTBOX List_1   
        ROW 240
        COL 335
        WIDTH 120 
        HEIGHT 50 
        ITEMS {'Andres','Analia','Item 3','Item 4','Item 5'} 
        VALUE 2  
        TOOLTIP 'ListBox' 
        ONDBLCLICK  MsgInfo('Double Click!','ListBox') 
    END LISTBOX

    DEFINE TEXTBOX Text_pass
        ROW 300
        COL 335
        VALUE 'Secret' 
        PASSWORD .T.
        TOOLTIP 'Password TextBox' 
        MAXLENGTH 16 
        UPPERCASE .T.
    END TEXTBOX
    
    DEFINE TEXTBOX Text_1
        ROW 330
        COL 335
        WIDTH 50 
        VALUE 'Hi!!!' 
        TOOLTIP 'TextBox' 
        MAXLENGTH 16 
        LOWERCASE .T.
        ONLOSTFOCUS MsgInfo('Focus Lost!') 
        ONENTER MsgInfo('Enter pressed')
    END TEXTBOX

    DEFINE TEXTBOX MaskedText
        ROW 330
        COL 395
        WIDTH 80 
        VALUE 12345.12 
        TOOLTIP "TextBox With Numeric And InputMask Clauses" 
        NUMERIC .T.
        INPUTMASK '99999.99' 
        ONCHANGE PlayOk() 
        ONENTER MsgInfo('Enter pressed') 
        RIGHTALIGN .T.
    END TEXTBOX

    DEFINE TEXTBOX Text_2
        ROW 360
        COL 335
        VALUE 123 
        NUMERIC .T.
        TOOLTIP 'Numeric TextBox' 
        MAXLENGTH 16 
        RIGHTALIGN .T.
    END TEXTBOX

    DEFINE SPINNER Spinner_1
        ROW 160
        COL 10
        RANGEMIN 0
        RANGEMAX 10 
        VALUE 5 
        WIDTH 100 
        TOOLTIP 'Range 1,65000'
        FONTBOLD .T.
    END SPINNER

    DEFINE LABEL Label_2
        ROW 385
        COL 15
        HEIGHT 16
        VALUE 'Timer Test:' 
    END LABEL
    
    DEFINE LABEL Label_3
        ROW 385
        COL 90
        WIDTH 60
        HEIGHT 16
    END LABEL

    DEFINE TIMER Timer_1 ;
    INTERVAL 1000 ;
    ACTION Form_1.Label_3.Value := Time() 
    
    DEFINE IMAGE Image_1
        ROW 310
        COL 510
        PICTURE 'Demo.gif' 
        WIDTH 90 
        HEIGHT 90
        STRETCH .F.
    END IMAGE
    
END WINDOW
CENTER WINDOW Form_1
ACTIVATE WINDOW Form_1
Return Nil

*-----------------------------------------------------------------------------*
Procedure SetPict()
*-----------------------------------------------------------------------------*

    Form_1.Image_1.Picture := 'hmglogo.gif'
    Form_1.ImageButton_1.Picture := 'Open.Bmp'

Return Nil

*-----------------------------------------------------------------------------*
Procedure Maximize_CLick
*-----------------------------------------------------------------------------*

    Form_1.Maximize

Return Nil

*-----------------------------------------------------------------------------*
Procedure SetCaptionTest()
*-----------------------------------------------------------------------------*

    Form_1.Button_1.Caption     := 'New Caption'
    Form_1.Tab_1(2).Check_1.Caption := 'New Caption'
    Form_1.CheckButton_1.Caption    := 'New Caption'
    Form_1.Frame_1.Caption      := 'New Caption'

Return Nil
*-----------------------------------------------------------------------------*
Procedure GetCaptionTest()
*-----------------------------------------------------------------------------*

    MsgInfo ( ( Form_1.Button_1.Caption      ) , 'Button_1' )
    MsgInfo ( ( Form_1.Tab_1(2).Check_1.Caption ) , 'Check_1' )
    MsgInfo ( ( Form_1.CheckButton_1.Caption ) , 'CheckButton_1' )
    MsgInfo ( ( Form_1.Frame_1.Caption       ) , 'Frame_1' )

Return Nil
*-----------------------------------------------------------------------------*
Procedure ExecTest()
*-----------------------------------------------------------------------------*

    EXECUTE FILE "NOTEPAD.EXE" 

Return Nil
*-----------------------------------------------------------------------------*
Procedure InputWindow_Click
*-----------------------------------------------------------------------------*
Local Title , aLabels , aInitValues , aFormats , aResults 

Title       := 'InputWindow Test'

aLabels     := { 'Field 1:' , 'Field 2:'    ,'Field 3:'     ,'Field 4:' ,'Field 5:' ,'Field 6:' }
aInitValues     := { 'Init Text', .t.       ,2          , Date()    , 12.34     ,'Init text' }
aFormats    := { 20     , Nil       ,{'Option 1','Option 2'}, Nil       , '99.99'   , 50 }

aResults    := InputWindow ( Title , aLabels , aInitValues , aFormats )

If aResults [1] == Nil

    MsgInfo ('Canceled','InputWindow')

Else

    MsgInfo ( aResults [1] , aLabels [1] )
    MsgInfo ( iif ( aResults [2] ,'.T.','.F.' ) , aLabels [2] )
    MsgInfo ( Str ( aResults [3] ) , aLabels [3] )
    MsgInfo ( DTOC ( aResults [4] ) , aLabels [4] )
    MsgInfo ( Str ( aResults [5] ) , aLabels [5] )
    MsgInfo ( aResults [6] , aLabels [6] )

EndIf

Return Nil
*-----------------------------------------------------------------------------*
Procedure EditGrid_Click
*-----------------------------------------------------------------------------*
Local aRows [20] [3]

    aRows [1]   := {'Simpson','Homer','555-5555'}
    aRows [2]   := {'Mulder','Fox','324-6432'} 
    aRows [3]   := {'Smart','Max','432-5892'} 
    aRows [4]   := {'Grillo','Pepe','894-2332'} 
    aRows [5]   := {'Kirk','James','346-9873'} 
    aRows [6]   := {'Barriga','Carlos','394-9654'} 
    aRows [7]   := {'Flanders','Ned','435-3211'} 
    aRows [8]   := {'Smith','John','123-1234'} 
    aRows [9]   := {'Lopez','Roberto','000-0000'} 
    aRows [10]  := {'Gomez','Juan','583-4832'} 
    aRows [11]  := {'Fernandez','Raul','321-4332'} 
    aRows [12]  := {'Borges','Javier','326-9430'} 
    aRows [13]  := {'Alvarez','Alberto','543-7898'} 
    aRows [14]  := {'Gonzalez','Ambo','437-8473'} 
    aRows [15]  := {'Batistuta','Gol','485-2843'} 
    aRows [16]  := {'Vinazzi','Amigo','394-5983'} 
    aRows [17]  := {'Pedemonti','Flavio','534-7984'} 
    aRows [18]  := {'Samarbide','Armando','854-7873'} 
    aRows [19]  := {'Pradon','Alejandra','???-????'} 
    aRows [20]  := {'Reyes','Monica','432-5836'} 

    DEFINE WINDOW Form_Grid ;
        AT 0,0 ;
        WIDTH 430 HEIGHT 400 ;
        TITLE 'Editable Grid Test'  ;
        MODAL NOSIZE ;
        FONT 'Arial' SIZE 10 

        DEFINE GRID Grid_1
            ROW 10
            COL 10
            WIDTH 405 
            HEIGHT 330 
            HEADERS {'Last Name','First Name','Phone'} 
            WIDTHS {140,140,140}
            ITEMS aRows 
            VALUE 1 
            TOOLTIP 'Editable Grid Control' 
            ALLOWEDIT .T.
        END GRID

    END WINDOW

    Form_Grid.Grid_1.Value := 20

    Form_Grid.Grid_1.SetFocus

    Form_Grid.Center

    Form_Grid.Activate

Return

*-----------------------------------------------------------------------------*
Procedure GetColor_Click
*-----------------------------------------------------------------------------*
Local Color

    Color := GetColor()

    MsgInfo( Str(Color[1]) , "Red Value")   
    MsgInfo( Str(Color[2]) , "Green Value") 
    MsgInfo( Str(Color[3]) , "Blue Value")  

Return Nil

*-----------------------------------------------------------------------------*
Procedure GetFont_Click
*-----------------------------------------------------------------------------*
Local a

    a := GetFont ( 'Arial' , 12 , .f. , .t. , {0,0,255} , .f. , .f. , 0 )

    if empty ( a [1] )

        MsgInfo ('Cancelled')

    Else

        MsgInfo( a [1] + Str( a [2] ) )

        if  a [3] == .t.
            MsgInfo ("Bold")
        else
            MsgInfo ("Non Bold")
        endif

        if  a [4] == .t.
            MsgInfo ("Italic")
        else
            MsgInfo ("Non Italic")
        endif

        MsgInfo ( str( a [5][1]) +str( a [5][2]) +str( a [5][3]), 'Color' )

        if  a [6] == .t.
            MsgInfo ("Underline")
        else
            MsgInfo ("Non Underline")
        endif

        if  a [7] == .t.
            MsgInfo ("StrikeOut")
        else
            MsgInfo ("Non StrikeOut")
        endif

        MsgInfo ( str ( a [8] ) , 'Charset' )

    EndIf

Return Nil
*-----------------------------------------------------------------------------*
Procedure MultiWin_Click
*-----------------------------------------------------------------------------*

    If (.Not. IsWIndowActive (Form_4) ) .And. (.Not. IsWIndowActive (Form_5) )

        DEFINE WINDOW Form_4 ;
            AT 100,100 ;
            WIDTH 200 HEIGHT 150 ;
            TITLE "Window 1" ;
            TOPMOST 

        END WINDOW
        DEFINE WINDOW Form_5 ;
            AT 300,300 ;
            WIDTH 200 HEIGHT 150 ;
            TITLE "Window 2" ;
            TOPMOST 

        END WINDOW

        ACTIVATE WINDOW Form_4 , Form_5

    EndIf

Return
*-----------------------------------------------------------------------------*
Procedure Context1_Click
*-----------------------------------------------------------------------------*

    Form_1.File_Modal.Checked := .T.
    MsgInfo ("File - More Tests Checked")

Return Nil
*-----------------------------------------------------------------------------*
Procedure Context2_Click
*-----------------------------------------------------------------------------*

    Form_1.File_Modal.Checked := .F.
    MsgInfo ("File - Modal Window Unchecked")

Return Nil
*-----------------------------------------------------------------------------*
Procedure Context3_Click
*-----------------------------------------------------------------------------*

    Form_1.File_Topmost.Enabled := .T.
    MsgInfo ("File - Topmost Window Enabled")

Return Nil
*-----------------------------------------------------------------------------*
Procedure Context4_Click
*-----------------------------------------------------------------------------*

    Form_1.File_Topmost.Enabled := .F.
    MsgInfo ("File - Topmost Window Disabled")

Return Nil
*-----------------------------------------------------------------------------*
Procedure Animate_CLick
*-----------------------------------------------------------------------------*
Local i

    For i = 0 To 65535 Step 25
        Form_1.Tab_1(4).Progress_1.Value := i
    Next i

Return
*-----------------------------------------------------------------------------*
Procedure Modal_CLick
*-----------------------------------------------------------------------------*

    DEFINE WINDOW Form_2 ;
        AT 0,0 ;
        WIDTH 430 HEIGHT 400 ;
        TITLE 'Modal Window & Multiselect Grid/List Test'  ;
        MODAL ;
        NOSIZE 

        DEFINE BUTTON BUTTON_1
            ROW 10
            COL 30
            CAPTION 'List GetValue' 
            ACTION MultiTest_GetValue()
        END BUTTON
        
        DEFINE BUTTON BUTTON_2
            ROW 40
            COL 30
            CAPTION 'List SetValue' 
            ACTION Form_2.List_1.Value := { 1 , 3 } 
        END BUTTON
        
        DEFINE BUTTON BUTTON_3
            ROW 70
            COL 30
            CAPTION 'List GetItem' 
            ACTION Multilist_GetItem()
        END BUTTON

        DEFINE BUTTON BUTTON_4
            ROW 100
            COL 30
            CAPTION 'List SetItem' 
            ACTION Form_2.List_1.Item ( 1 ) := 'New Value!!' 
        END BUTTON

        DEFINE BUTTON BUTTON_10
            ROW 130
            COL 30
            CAPTION 'GetItemCount' 
            ACTION MsgInfo ( Str ( ( Form_2.List_1.ItemCount ) ) )
        END BUTTON

        DEFINE BUTTON BUTTON_5
            ROW 10
            COL 150
            CAPTION 'Grid GetValue' 
            ACTION MultiGrid_GetValue()
        END BUTTON

        DEFINE BUTTON BUTTON_6
            ROW 40
            COL 150
            CAPTION 'Grid SetValue' 
            ACTION Form_2.Grid_1.Value := { 1 , 3 } 
        END BUTTON

        DEFINE BUTTON BUTTON_7
            ROW 70
            COL 150
            CAPTION 'Grid GetItem' 
            ACTION MultiGrid_GetItem()
        END BUTTON
        
        DEFINE BUTTON BUTTON_8
            ROW 100
            COL 150
            CAPTION 'Grid SetItem' 
            ACTION Form_2.Grid_1.Item(1) := {'Hi','All'} 
        END BUTTON
        
        DEFINE BUTTON BUTTON_9
            ROW 130
            COL 150
            CAPTION 'GetItemCount' 
            ACTION MsgInfo ( Str ( ( Form_2.Grid_1.ItemCount ) ) )
        END BUTTON

        DEFINE LISTBOX List_1
            ROW 180
            COL 30
            WIDTH 100 
            HEIGHT 135 
            ITEMS { 'Row 1' , 'Row 2' , 'Row 3' , 'Row 4' , 'Row 5' } 
            VALUE { 2 , 3 } 
            FONTNAME 'Arial' 
            FONTSIZE 10 
            TOOLTIP 'Multiselect ListBox (Ctrl+Click)' 
            MULTISELECT .T.
        END LISTBOX
        
        DEFINE GRID Grid_1
            ROW     180
            COL     150
            WIDTH       250 
            HEIGHT      135 
            HEADERS     { 'Last Name' , 'First Name' } 
            WIDTHS      { 120 , 120 }
            ITEMS       { { 'Simpson' , 'Homer' } , { 'Mulder' , 'Fox' } , { 'Smart' , 'Max' } } 
            VALUE       { 2 , 3 } 
            FONTNAME    'Arial' 
            FONTSIZE    10 
            TOOLTIP     'Multiselect Grid Control (Ctrl+Click)' 
            ONCHANGE    PlayBeep() 
            MULTISELECT .T.
        END GRID

    END WINDOW

    Form_2.Center

    Form_2.Activate

Return Nil
Procedure MultiTest_GetValue
local a , i

    a :=  ( Form_2.List_1.Value )

    for i := 1 to len (a)
        MsgInfo ( str( a[i] ) ) 
    Next i

    If Len(a) == 0
        MsgInfo('No Selection')
    EndIf

Return
Procedure MultiGrid_GetValue
local a , i

    a :=  ( Form_2.Grid_1.Value )

    for i := 1 to len (a)
        MsgInfo ( str( a[i] ) ) 
    Next i

    If Len(a) == 0
        MsgInfo('No Selection')
    EndIf

Return
*-----------------------------------------------------------------------------*
procedure multilist_getitem
*-----------------------------------------------------------------------------*

    MsgInfo (  ( Form_2.List_1.Item ( 1 ) ) ) 

return
*-----------------------------------------------------------------------------*
Procedure MultiGrid_GetItem
*-----------------------------------------------------------------------------*
local a , i

    a := ( Form_2.Grid_1.Item ( 1 ) )

    for i := 1 to len (a)
        MsgInfo ( a[i] ) 
    Next i
Return
*-----------------------------------------------------------------------------*
Procedure Standard_CLick
*-----------------------------------------------------------------------------*
    If .Not. IsWindowDefined ( Form_Std )

        DEFINE WINDOW Form_Std ;
            AT 100,100 ;
            WIDTH 200 HEIGHT 200 ;
            TITLE "Standard Window" ;
            WINDOWTYPE STANDARD ;
            ON INIT { || MsgInfo ("ON INIT Procedure Executing !!!") } ;
            ON RELEASE { || MsgInfo ("ON RELEASE Procedure Executing !!!") }

        END WINDOW

        Form_Std.Activate

    Else
        MsgInfo ("Window Already Active","Warning!")    
    EndIf   

Return Nil
*-----------------------------------------------------------------------------*
Procedure Topmost_CLick
*-----------------------------------------------------------------------------*

    If .Not. IsWIndowActive ( Form_3 )

        DEFINE WINDOW Form_3 ;
            AT 100,100 ;
            WIDTH 150 HEIGHT 150 ;
            TITLE "Topmost Window" ;
            TOPMOST 

        END WINDOW

        Form_3.Center

        Form_3.Activate

    EndIf

Return Nil
*-----------------------------------------------------------------------------*
Procedure Minimize_CLick
*-----------------------------------------------------------------------------*

    Form_1.Minimize

Return Nil
*-----------------------------------------------------------------------------*
Procedure Restore_CLick
*-----------------------------------------------------------------------------*

    Form_1.Restore

Return Nil
*-----------------------------------------------------------------------------*
Procedure Hide_CLick
*-----------------------------------------------------------------------------*

    Form_1.Image_1.Visible  := .f.
    Form_1.Spinner_1.Visible := .f.
    Form_1.Tab_1.Visible    := .f.

Return Nil
*-----------------------------------------------------------------------------*
Procedure Show_CLick
*-----------------------------------------------------------------------------*

    Form_1.Image_1.Visible  := .t.
    Form_1.Spinner_1.Visible := .t.
    Form_1.Tab_1.Visible    := .t.

Return Nil
*-----------------------------------------------------------------------------*
Procedure Setfocus_CLick
*-----------------------------------------------------------------------------*

    Form_1.MaskedText.SetFocus

Return Nil
*-----------------------------------------------------------------------------*
Procedure GetValue_CLick
*-----------------------------------------------------------------------------*
Local s

s =     "Grid:                " + Str (  ( Form_1.Tab_1(1).Grid_1.Value )   )   + chr(13) + chr(10)
s = s + "TextBox:             " +      ( Form_1.Text_1.Value    )   + chr(13) + chr(10)
s = s + "EditBox:             " +      ( Form_1.Tab_1(3).Edit_1.Value   )   + chr(13) + chr(10)
s = s + "RadioGroup:          " + Str (  Form_1.Tab_1(2).Radio_1.Value )    + chr(13) + chr(10)
s = s + "Tab:                 " + Str (  Form_1.Tab_1.Value )   + chr(13) + chr(10)
s = s + "ComboBox:            " + Str (  Form_1.Combo_1.Value ) + chr(13) + chr(10)
s = s + "CheckBox:            " + Iif (  ( Form_1.Tab_1(2).Check_1.Value ) , ".T.",".F."    ) + chr(13) + chr(10)
s = s + "Numeric TextBox:     " + Str (  Form_1.Text_2.Value )  + chr(13) + chr(10)
s = s + "Password TextBox:    " +        Form_1.Text_Pass.Value + chr(13) + chr(10)
s = s + "Slider:          " + Str (  Form_1.Tab_1(2).Slider_1.Value )   + chr(13) + chr(10) 
s = s + "Spinner:             " + Str (  Form_1.Spinner_1.Value )   + chr(13) + chr(10)
s = s + "TextBox (InputMask): " + Str (  Form_1.MaskedText.Value )  + chr(13) + chr(10)
s = s + "DatePicker:          " + Dtoc(  ( Form_1.Date_1.Value )    ) 

MsgInfo ( s , "Get Control Values" )

Return Nil
*-----------------------------------------------------------------------------*
Procedure SetValue_CLick
*-----------------------------------------------------------------------------*

     Form_1.Tab_1(1).Grid_1.Value   := 2 
     Form_1.Text_1.Value    := "New Text value" 
     Form_1.Tab_1(3).Edit_1.Value   := "New Edit Value" 
     Form_1.Tab_1(2).Radio_1.Value  := 4
     Form_1.Tab_1.Value     := 2 
     Form_1.Tab_1(2).Check_1.Value  := .t. 
     Form_1.List_1.Value    := 1 
     Form_1.Combo_1.Value   := 1 
     Form_1.Date_1.Value    := CTOD("02/02/2002") 
     Form_1.Tab_1(2).Label_1.Value  := "New Label Value" 
     Form_1.Text_2.Value    := 999 
     Form_1.Timer_1.Value   := 500 
     Form_1.MaskedText.Value := 12.34 
     Form_1.Spinner_1.Value := 6
Return Nil
*-----------------------------------------------------------------------------*
Procedure Enable_CLick
*-----------------------------------------------------------------------------*

    Form_1.Button_1.Enabled     := .T. 
    Form_1.Button_2.Enabled     := .T. 
    Form_1.Button_3.Enabled     := .T. 
    Form_1.Button_4.Enabled     := .T. 
    Form_1.Button_5.Enabled     := .T. 
    Form_1.Button_6.Enabled     := .T. 
    Form_1.Timer_1.Enabled      := .T. 
    Form_1.Spinner_1.Enabled    := .T. 
    Form_1.Tab_1(2).Radio_1.Enabled         := .T. 
    Form_1.Tab_1.Enabled        := .T. 
Return Nil
*-----------------------------------------------------------------------------*
Procedure Disable_CLick
*-----------------------------------------------------------------------------*

    Form_1.Button_1.Enabled     := .F. 
    Form_1.Button_2.Enabled     := .F. 
    Form_1.Button_3.Enabled     := .F. 
    Form_1.Button_4.Enabled     := .F. 
    Form_1.Button_5.Enabled     := .F. 
    Form_1.Button_6.Enabled     := .F. 
    Form_1.Timer_1.Enabled      := .F. 
    Form_1.Spinner_1.Enabled    := .F. 
    Form_1.Tab_1(2).Radio_1.Enabled         := .F. 
    Form_1.Tab_1.Enabled        := .F. 

Return Nil
*-----------------------------------------------------------------------------*
Procedure DeleteAllItems_CLick
*-----------------------------------------------------------------------------*

    Form_1.Tab_1(1).Grid_1.DeleteAllItems
    Form_1.List_1.DeleteAllItems 
    Form_1.Combo_1.DeleteAllItems

Return Nil
*-----------------------------------------------------------------------------*
Procedure DeleteItem_CLick
*-----------------------------------------------------------------------------*

    Form_1.Tab_1(1).Grid_1.DeleteItem ( 1 )
    Form_1.List_1.DeleteItem ( 1 )
    Form_1.Combo_1.DeleteItem ( 1 )

Return Nil
*-----------------------------------------------------------------------------*
Procedure AddItem_CLick
*-----------------------------------------------------------------------------*

    Form_1.Tab_1(1).Grid_1.AddItem ( { 1,"Kirk","James"} )
    Form_1.List_1.AddItem ( "New List Item"  )
    Form_1.Combo_1.AddItem (  "New Combo Item" )

Return Nil
*-----------------------------------------------------------------------------*
Procedure Msg_CLick
*-----------------------------------------------------------------------------*

    MsgBox      ("MessageBox Test","MsgBox")
    MsgInfo     ("MessageBox Test","MsgInfo")
    MsgStop     ("MessageBox Test","MsgStop")
    MsgExclamation  ("MessageBox Test","MsgExclamation")
    MsgYesNo    ("MessageBox Test","MsgYesNo")
    MsgOkCancel ("MessageBox Test","MsgOkCancel")
    MsgRetryCancel  ("MessageBox Test","MsgRetryCancel")

Return Nil
*-----------------------------------------------------------------------------*
Procedure MemoryTest
*-----------------------------------------------------------------------------*

    MsgInfo(str(MemoryStatus(1)), "Total memory in MB")
    MsgInfo(str(MemoryStatus(2)), "Available memory in MB")
    MsgInfo(str(MemoryStatus(3)), "Total page memory in MB")
    MsgInfo(str(MemoryStatus(3)-MemoryStatus(4)), "Used page memory in MB")
    MsgInfo(str(MemoryStatus(6)), "Available virtual memory in MB")

Return
*-----------------------------------------------------------------------------*
Procedure Color_CLick
*-----------------------------------------------------------------------------*
DEFINE WINDOW Form_Color ;
    AT 100,100 ;
    WIDTH 200 HEIGHT 200 ;
    TITLE 'Color Window' ;
    BACKCOLOR RED

    DEFINE LABEL Label_9
        ROW 10
        COL 10
        VALUE 'A COLOR Label !!!' 
        WIDTH 140 
        HEIGHT 30 
        FONTNAME 'Times New Roman' 
        FONTSIZE 12 
        BACKCOLOR RED 
        FONTCOLOR YELLOW 
        FONTBOLD .T.
    END LABEL 

    DEFINE LABEL Label_99
        ROW 60
        COL 10
        VALUE 'Another COLOR Label !!!' 
        WIDTH 180 
        HEIGHT 30 
        FONTNAME 'Times New Roman' 
        FONTSIZE 10 
        BACKCOLOR WHITE 
        FONTCOLOR RED 
        FONTBOLD .T.
    END LABEL
END WINDOW
Form_Color.Activate
Return Nil

Procedure Child_CLick
DEFINE WINDOW ChildTest ;
    AT 100,100 ;
    WIDTH 200 HEIGHT 200 ;
    TITLE 'Child Window' ;
    CHILD

END WINDOW
ChildTest.Activate
Return Nil