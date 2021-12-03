/*
   HMG InputWindow Demo
   By Pablo César Arrascaeta
   23rd, December 2014
*/

#include "hmg.ch"

DECLARE WINDOW _InputWindow

Function Main()
Local cSetLang:="EN"  // PL=Polish, PT=Portuguese, FR=French...

SET NAVIGATION EXTENDED

SET TOOLTIPSTYLE BALLOON
InitMessages(cSetLang)

DEFINE WINDOW Form_1 ;
    AT 0,0 ;
    WIDTH 740 HEIGHT 490 ;
    TITLE 'HMG InputWindow Demo' ;
    MAIN FONT 'Arial' SIZE 10 BACKCOLOR BLUE

   ON KEY ESCAPE ACTION ThisWindow.Release()
    
   @  50,25 BUTTON Button_1 CAPTION "InputWindow (Old version)"        WIDTH 200 ACTION Prepare_InputWindow(1)
   @  90,25 BUTTON Button_2 CAPTION "InputWindow (New version)"        WIDTH 200 ACTION Prepare_InputWindow(2)
END WINDOW
CENTER WINDOW Form_1
ACTIVATE WINDOW Form_1
Return Nil


Function Prepare_InputWindow(nOption)
Local cTitle, aLabels, aInitValues, aFormats, aToolTips, aHotKeys, nRow, nCol, aResults
Local nLabelWidth, lLabelBold, xControlWidth, lControlBold, bCode, aBackColor

Local aGridValues:= {{"Line 1a","Line 1b","Line 1c"},{"Line 2a","Line 2b","Line 2c"},{"Line 3a","Line 3b","Line 3c"}}
Local aGridHeaders:={"Header 1","Header 2","Header 3"}
Local aGridWidths:={80,80,80}

Public nEventIdx                                                           // In case is need to CREATE EVENT

cTitle      := 'InputWindow Test '+If(nOption=1,"(Old version)","(New version)")
aLabels     := { 'Field 1 (TextBox for text)', 'Field 2 (CheckBox):', 'Field 3 (ComboBox)', ; 
                 'Field 4 (DatePicker)', 'Field 5 (Numeric masked TextBox)', ;
                 'Field 6 (Numeric TextBox for integers)', 'Field 7 (EditBox)', ;
                 'Field 8 (Grid)', 'Field 9 (PassWord)', HMG_PadC(' Field 10 (Label) ',35,"─") }
aInitValues := { 'Init Text', .T., 0, Date(), 12.34, 0, 'Memo text', aGridValues, ;
                 "", HMG_PadC(' Label as Control ',38,"─") }
aFormats    := { 20, Nil, {'Option 1','Option 2'}, Nil, '99.99', 10, 50, {aGridHeaders, aGridWidths}, "PASSWORD", Nil }
/*                         +------------------+----------------------+
                           |   aInitValues    |      aFormats        |
 +-------------------------+------------------+----------------------+
 | Label                   |       ""         | Nil                  |
 | TextBox "C"             |       ""         | <= 32                |
 | TextBox "C" (PassWord)  |       ""         | "PASSWORD"           |
 | TextBox "N" (New)       |       9          | 9                    |
 | TextBox "N"(INPUTMASK)  |       9          | Ex: "99.99"          |
 | ComboBox                |       9          | {}                   |
 | CheckBox                |    .T. or .F.    |                      |
 | DatePicker              | CtoD() or Date() |                      |
 | EditBox                 |       ""         | > 32                 |
 | EditBox                 |  Dbf Memo field  |                      |
 | Grid                    |       {{}}       | {{headers},{Widths}} |
 +-------------------------+------------------+----------------------+ */
 
/* From hereunder, it's with new features. */

nRow           := (Form_1.Row)+(Form_1.Button_2.Row)+35                    // Optional
nCol           := 0                                                        // Optional. Force to Center horizontally
aBackColor     := {212,208,200}                                            // Optional
aToolTips   := { "ToolTips 1","ToolTips 2","ToolTips 3", ;                 // Optional
                 "ToolTips 4","ToolTips 5","ToolTips 6", ;
                 "ToolTips 7", "ToolTips 8","ToolTips 9" }
aHotKeys       := { { 0, VK_ESCAPE, {|| ThisWindow.Release() } }, ;        // Optional
                    { 0, VK_UP, {|| InsertShiftTab() } }, ;
                    { 0, VK_DOWN, {|| InsertTab() } } }

/*         This must obey the same settings and sequences that are
           described in i_keybd.ch. For example ALT+A must be like this:
                                    { { MOD_ALT, VK_A, <{|| action } > } } 
           Others codeblocks can be added, having many HotKeys             */

nLabelWidth    := 260                                              // Optional. Forcing width sizes
aLabelFColor   := {0,0,200}                                        // Optional
lLabelBold     := .T.                                              // Optional
nAlign         := 1                                                // Optional ( Left/Normal:=0 | Right:=1 | Center:=2 )

If nOption = 2
   xControlWidth  := {150,260,80,90,105,80,260,260,120,260}        // Optional
Else
   xControlWidth  := 250                                           // Optional
Endif
/* Forcing width sizes. xControlWidth can be a fixed value of a 
   variable or an array containing each width size of each control */

lControlBold   := .T.                                              // Optional
               
aStyles        := {{nLabelWidth,lLabelBold,aLabelFColor,nAlign},;  // Need to be declared Bidimensional {{},{}}
                   {xControlWidth,lControlBold}}
               
bCode          := {|| My_UDF()}                                    // Optional. Good to insert UDFs

Do Case
   Case nOption=1
        aResults := InputWindow ( cTitle, aLabels, aInitValues, aFormats )
   Case nOption=2
        aResults := InputWindow ( cTitle, aLabels, aInitValues, aFormats, nRow, nCol, aBackColor, aToolTips, aHotKeys, aStyles, bCode )
EndCase

If aResults [1] == Nil
   MsgInfo ('Cancelled','InputWindow')
Else
   My_MsgDebug(aLabels,aResults)
EndIf
Return Nil

Function My_UDF()
Local i, imax:=CountLabels()

// Set some properties manually (It's just an example)
SetProperty('_InputWindow','Label_1','BackColor',GRAY)
SetProperty('_InputWindow','Label_3','FontColor',GREEN)
SetProperty('_InputWindow','Label_4','FontSize',12)
SetProperty('_InputWindow','Label_2','FontItalic',.t.)
SetProperty('_InputWindow','Control_7','BackColor',YELLOW)
SetProperty('_InputWindow','Control_8','BackColor',{102,102,255})
SetProperty('_InputWindow','Control_5','ReadOnly',.t.)

SetProperty('_InputWindow','Control_9','PassWord',.t.)  // ??
DoMethod('_InputWindow','Control_9','SetFocus')
SetProperty('_InputWindow','Control_10','FontColor',RED)

For i=1 To 3 // 3 Columns
    SetProperty( "_InputWindow","Control_8","HeaderDYNAMICFONT",i, {|| {"Verdana", 9, .T.} } )
    SetProperty( "_InputWindow","Control_8","ColumnDYNAMICFONT",i, {|| {"Courier New", 9, .T.} } )
    SetProperty( "_InputWindow","Control_8","HeaderDYNAMICFORECOLOR",i, {|| BLUE } )
    SetProperty( "_InputWindow","Control_8","HeaderDYNAMICBACKCOLOR",i, {|| {212,208,200} } )
    SetProperty( "_InputWindow","Control_8","ColumnDYNAMICBACKCOLOR",i, {|| {153,153,255} } )
Next

// Set for all fields at LostFocus + Enter + GotFocus (how we can do validations)
For i:=1 to imax
    If _IsControlDefined('Control_'+hb_ValToExp(i),'_InputWindow')
       SetMethodCode('_InputWindow','Control_'+hb_ValToExp(i),'LOSTFOCUS',{||xIfEmpty()})
       SetMethodCode('_InputWindow','Control_'+hb_ValToExp(i),'ENTER',{||InsertTab()})
       SetMethodCode('_InputWindow','Control_'+hb_ValToExp(i),'GOTFOCUS',{||SetFocusColor()})
    Endif
Next
Return Nil


Static Function CountLabels()
Local nIdx:=1

Do While _IsControlDefined('Label_'+hb_ValToExp(nIdx),'_InputWindow')
   nIdx++
enddo
nRet:=nIdx-1
Return nRet


Static Function xIfEmpty()
Local aCheckBackColor, cMsg, nOpt
Local cControlName := This.Name
Local xValue := This.Value
Local cControlType:=GetControlType(cControlName,'_InputWindow')

If Empty(xValue)
   StopControlEventProcedure(cControlName, '_InputWindow', .T.)
   If cControlType="COMBO"
      cMsg:="You need to choose an option !"
   ElseIf cControlType="CHECKBOX"
      cMsg:="Option cannot be validated !"
      aCheckBackColor:=GetProperty("_InputWindow",cControlName,"BackColor")
   Else
      If ValType(xValue)="N"
         cMsg:="Value must be greater than zero !"
      Else
         cMsg:="Value is required and can't be empty !"
      Endif
   Endif
   SetProperty('_InputWindow', cControlName, 'BackColor', RED)
   PlayBeep()
   nTypeButton = MB_ICONHAND + MB_RETRYCANCEL   // (i_MsgBox.ch)
   nOpt:=MessageBoxTimeout(cMsg, "Attention: Re-edit this field", nTypeButton, 3000)
   If cControlType="CHECKBOX"
      SetProperty('_InputWindow', cControlName, 'BackColor', aCheckBackColor)
      SetProperty('_InputWindow', cControlName, 'Value', .T.)
   Else
      SetProperty('_InputWindow', cControlName, 'BackColor', WHITE)
   Endif
   If nOpt == 2 //IDCANCEL   // (i_MsgBox.ch)
      If (cControlType="TEXT" .or. cControlType="EDIT")
         DoMethod('_InputWindow', cControlName, 'SetFocus')
         InsertControlZ()                                        // UnDo Texts
      Endif
   Else
      DoMethod('_InputWindow', cControlName, 'SetFocus')
   Endif
   StopControlEventProcedure(cControlName, '_InputWindow', .F.)
Endif
Return Nil

Function SetFocusColor()
Local imax:=CountLabels()
Local i, cThisLabel

For i=1 To imax
    SetProperty("_InputWindow",'Label_'+hb_ValToExp(i),"FontColor",{0,0,200})
    If This.Name='Control_'+hb_ValToExp(i)
       cThisLabel:='Label_'+hb_ValToExp(i)
    Endif
Next
SetProperty("_InputWindow",cThisLabel,"FontColor",RED)
Return Nil

Static Function SetMethodCode( cForm, cControl, cMethod, bCode )
Local nIndex:=GetControlIndex( cControl, cForm )
Local cControlType:=GetControlTypeByIndex (nIndex)

Do Case
   Case nIndex=0
   Case cControlType = "COMBO"
        Do Case
           Case cMethod='DISPLAYCHANGE'
                _HMG_SYSDATA [  6 ][nIndex] :=  bCode
           Case cMethod='LISTDISPLAY'
                // _HMG_aControlInputMask [nIndex] := bCode
           Case cMethod='LOSTFOCUS'
                _HMG_SYSDATA [ 10 ][nIndex] :=  bCode
           Case cMethod='GOTFOCUS'
                _HMG_SYSDATA [ 11 ][nIndex] :=  bCode
           Case cMethod='CHANGE'
                _HMG_SYSDATA [ 12 ][nIndex] :=  bCode
           Case cMethod='ENTER'
                _HMG_SYSDATA [ 16 ][nIndex] :=  bCode
           Case cMethod='LISTCLOSE'
                // _HMG_aControlPicture[nIndex] :=  bCode
        EndCase
   Case cControlType = "TEXT" .or. cControlType = "NUMTEXT" .or. cControlType = "MASKEDTEXT"
        Do Case
           Case cMethod='LOSTFOCUS'
                _HMG_SYSDATA [ 10 ][nIndex] :=  bCode
                SetProperty(cForm, cControl, cMethod, bCode)
           Case cMethod='GOTFOCUS'
                _HMG_SYSDATA [ 11 ][nIndex] :=  bCode
           Case cMethod='CHANGE'
                _HMG_SYSDATA [ 12 ][nIndex] :=  bCode
           Case cMethod='ENTER'
                _HMG_SYSDATA [ 16 ][nIndex] :=  bCode
        Endcase
   Case cControlType = "EDIT"
        Do Case
           Case cMethod='LOSTFOCUS'
                _HMG_SYSDATA [ 10 ][nIndex] :=  bCode
           Case cMethod='GOTFOCUS'
                _HMG_SYSDATA [ 11 ][nIndex] :=  bCode
           Case cMethod='CHANGE'
                _HMG_SYSDATA [ 12 ][nIndex] :=  bCode
        EndCase
   Case cControlType = "DATEPICK"
        Do Case
           Case cMethod='LOSTFOCUS'
                _HMG_SYSDATA [ 10 ][nIndex] :=  bCode
           Case cMethod='GOTFOCUS'
                _HMG_SYSDATA [ 11 ][nIndex] :=  bCode
           Case cMethod='CHANGE'
                _HMG_SYSDATA [ 12 ][nIndex] :=  bCode
           Case cMethod='ENTER'
                _HMG_SYSDATA [ 6 ][nIndex] :=  bCode
        EndCase
   Case cControlType = "CHECKBOX"
        Do Case
           Case cMethod='LOSTFOCUS'
                _HMG_SYSDATA [ 10 ][nIndex] :=  bCode
           Case cMethod='GOTFOCUS'
                _HMG_SYSDATA [ 11 ][nIndex] :=  bCode
           Case cMethod='CHANGE'
                _HMG_SYSDATA [ 12 ][nIndex] :=  bCode
           Case cMethod='ENTER'
                _HMG_SYSDATA [ 6 ][nIndex] := bCode
        EndCase
   Case cControlType = "GRID"
        Do Case
           Case cMethod='LOSTFOCUS'
                _HMG_SYSDATA [ 10 ][nIndex] :=  bCode
           Case cMethod='GOTFOCUS'
                _HMG_SYSDATA [ 11 ][nIndex] :=  bCode
           Case cMethod='CHANGE'
                _HMG_SYSDATA [ 12 ][nIndex] :=  bCode
           Case cMethod='ENTER'
                _HMG_SYSDATA [ 16 ][nIndex] := .T.
        EndCase
EndCase
DO Events
Return Nil


Function ResetAllKeys(aHotKeys)
If ValType(aHotKeys)='A'
   For i := 1 to HMG_Len ( aHotKeys )
       _ReleaseHotKey ( "_InputWindow" , aHotKeys[i,1] , aHotKeys[i,2] )
   Next
Endif
Return Nil


Function OnExit( aHotKeys )
If ValType(nEventIdx)="N"
   EventRemove ( nEventIdx )
Endif
ResetAllKeys( aHotKeys )
Return .T.


Function My_MsgDebug(aLbls,aCtrls)
Local i, aMsg
SET DATE FORMAT TO "dd/mm/yyyy"

aMsg := {}
For i = 1 To Len(aLbls)
    Aadd(aMsg,{AllTrim(Str(i))+". " ,aLbls[i],If(ValType(aCtrls[i])="D",DtoC(aCtrls[i]),hb_ValToExp(aCtrls[i]))})
Next

DEFINE WINDOW _MsgDebug AT 132 , 235 WIDTH 640 HEIGHT 350 ;
    TITLE "InputWindow results" MODAL

   ON KEY ESCAPE ACTION ThisWindow.Release()

    DEFINE GRID Grid_1
        ROW    20
        COL    10
        WIDTH  605
        HEIGHT 290
        ITEMS aMsg
        VALUE 1
        WIDTHS { 30, 280, 390 }
        HEADERS {''}
        FONTNAME "Arial"
        FONTSIZE 9
        SHOWHEADERS .F.
        CELLNAVIGATION .F.
        NOLINES .T.
    END GRID

END WINDOW
CENTER WINDOW _MsgDebug
ACTIVATE WINDOW _MsgDebug
Return Nil
