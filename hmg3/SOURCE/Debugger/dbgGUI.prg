
/*----------------------------------------------------------------------------
 HMG DEBUGGER - GUI Debugger for HMG

 Copyright 2015-2016 by Dr. Claudio Soto (from Uruguay).
 mail: <srvet@adinet.com.uy>
 blog: http://srvet.blogspot.com

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor Boston, MA 02110-1301, USA
 (or visit their web site at http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of HMG DEBUGGER.

 The exception is that, if you link the HMG DEBUGGER library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 HMG DEBUGGER library code into it.
 
 add 2004-10-24 by Jimmy
 ON DBLCLICK : Grid ENTER = VK_RETURN
----------------------------------------------------------------------------*/

#pragma DEBUGINFO=OFF

MEMVAR _HMG_SYSDATA, _HMG_MainWindowFirst

#include "hmg.ch"
#include "common.ch"


/*****************************************************************************************************/
#define _HMG_DEBUGGER_NAME_       "HMG Debugger"
#define _HMG_DEBUGGER_ICON_       "_dbgIcon"
/*****************************************************************************************************/

#command IFENTRY( <l> ) => IF <l> == .T.; RETURN; ELSE; <l> := .T.; ENDIF


#define SM_CXVSCROLL   2   // The width of a vertical scroll bar, in pixels.
#define SM_CYHSCROLL   3   // The height of a horizontal scroll bar, in pixels.
#define SM_CXEDGE     45
#define SM_CYEDGE     46

#xtranslate nWIDTH()    =>   GetSystemMetrics( SM_CXVSCROLL )
#xtranslate nHEIGHT()   =>   GetSystemMetrics( SM_CYHSCROLL )


__THREAD STATIC aDebuggerForms := {}
__THREAD STATIC nCurrentLineCode := 0
__THREAD STATIC aRawVars := {}
__THREAD STATIC aGrid_SourceCode := {}
__THREAD STATIC nBtnOption := 0
__THREAD STATIC nComboBoxValue := 1
__THREAD STATIC lShowSplitBox := .T.
__THREAD STATIC hMainMenu := 0


DECLARE WINDOW _HMG_FormDebugger


PROCEDURE InitGUICodeBlocks
// CodeBlock initialization of GUI methods
   HMG_Debugger():bGUIReleaseFormDebugger := {|| ProcInitGUIDebugger (.F.) }
   HMG_Debugger():bGUIDoEvents            := {|| DoEvents() }
   HMG_Debugger():bGUIReleaseAllWindows   := {|| ReleaseAllWindows() }
   HMG_Debugger():bGUIMessageBox          := {|...| DebuggerMessageBox( ... ) }
   HMG_Debugger():bGUIUpdateInfo          := {|| UpdateInfo() }
RETURN


FUNCTION DebuggerMessageBox( ... )
LOCAL i, nRet, cText := ""
   FOR i = 1 TO PCount()
       cText := cText + Iif( ValType( PValue( i ) ) == "A", hb_ValToExp( PValue( i ) ), hb_ValToStr( PValue( i ) ) ) + Space( 1 )
   NEXT
   nRet := MessageBoxIndirect( NIL, cText, _HMG_DEBUGGER_NAME_, hb_bitOR( MB_SYSTEMMODAL, MB_OKCANCEL ), _HMG_DEBUGGER_ICON_ )
   IF nRet == IDCANCEL
      IF MsgYesNo ( "Are you sure you want to EXIT the program ?", _HMG_DEBUGGER_NAME_ ) == .T.
         ReleaseAllWindows()
      ENDIF
   ENDIF
RETURN nRet


#define SB_HORZ   0
#define SB_VERT   1


#define TAB_CODE     1
#define TAB_STACK    2
#define TAB_WATCH    3
#define TAB_CALC     4
#define TAB_VARS     5
#define TAB_AREAS    6
#define TAB_CONFIG   7
#define TAB_ABOUT    8


#define BTN_NONE   0
#define BTN_BP     1
#define BTN_TP     2
#define BTN_WP     3
#define BTN_EDIT   4


#define ID_animate         1
#define ID_step            2
#define ID_trace           3
#define ID_go              4
#define ID_tocursor        5
#define ID_next            6
#define ID_pause           7
#define ID_breakpoint      8
#define ID_tracepoint      9
#define ID_watchpoint      10
#define ID_configuration   11
#define ID_quit            12



*-----------------------------------------------------------------------*
PROCEDURE ProcInitGUIDebugger( lCreate )
*-----------------------------------------------------------------------*
__THREAD STATIC nEventIndex := 0
LOCAL i, bBackColor, bForeColor, cGrid_SourceCode
LOCAL aFiles, lOldMainFirst

   IF ValType( lCreate ) == "L" .AND. lCreate == .F. .AND. IsWindowDefined ( _HMG_FormDebugger ) == .T.
      EventRemove( nEventIndex )
      _HMG_FormDebugger.Release
      nEventIndex := 0
      RETURN
   ENDIF

   IF .NOT. IsWindowDefined( _HMG_FormDebugger )

      InitGUICodeBlocks()

      lOldMainFirst := HMG_ActivateMainWindowFirst( .F. )

#define _HMG_DEBUGGER_MSG_   "Wait while the debugger is loaded ..." + hb_Eol()
HMG_DebuggerWaitMessage( _HMG_DEBUGGER_MSG_ + "( DEFINE WINDOW )" )

      SET FONT TO "Calibri", 11

      #define MIN_WIDTH  650
      #define MIN_HEIGHT 550

      DEFINE WINDOW _HMG_FormDebugger;
         AT 0,0;
         WIDTH 0;
         HEIGHT 0;
         TITLE "HMG Debugger   ( Ctrl+H - Help )";
         ; //TOPMOST;
         ON RELEASE DeleteDbgForm( "_HMG_FormDebugger" );
         ON INTERACTIVECLOSE .F.;
         ON INIT AjustControlSize();
         ON MAXIMIZE AjustControlSize();
         ON SIZE ( Iif( ThisWindow.WIDTH < MIN_WIDTH,   ThisWindow.WIDTH  := MIN_WIDTH,  NIL ),;
                   Iif( ThisWindow.HEIGHT < MIN_HEIGHT, ThisWindow.HEIGHT := MIN_HEIGHT, NIL ),;
                   AjustControlSize() )

         ON KEY RETURN ACTION OnKeyPress( VK_RETURN )
         ON KEY DELETE ACTION OnKeyPress( VK_DELETE )
         ON KEY ESCAPE ACTION OnKeyPress( VK_ESCAPE )

         ON KEY CONTROL+H    ACTION  HotKeyHelp()

         ON KEY F11          ACTION  ShowHideSplitBox()

         ON KEY F3           ACTION  MenuOption( ID_animate )
         ON KEY F8           ACTION  MenuOption( ID_step )
         ON KEY F10          ACTION  MenuOption( ID_trace )
         ON KEY F5           ACTION  MenuOption( ID_go )
         ON KEY F7           ACTION  MenuOption( ID_tocursor )
         ON KEY CONTROL+F5   ACTION  MenuOption( ID_next )
         ON KEY CONTROL+F3   ACTION  MenuOption( ID_pause )
         ON KEY F9           ACTION  MenuOption( ID_breakpoint )
         ON KEY ALT+X        ACTION  MenuOption( ID_quit )

         DEFINE MAIN MENU
            DEFINE POPUP "Run"
                  MENUITEM "&Animate"        +Chr( 9 )+"F3"        ACTION  MenuOption( ID_animate )    TOOLTIP 'Run in Animate mode'                 NAME Menu_Animate    CHECKED
                  MENUITEM "&Step"           +Chr( 9 )+"F8"        ACTION  MenuOption( ID_step )       TOOLTIP 'Run in Single Step mode'             NAME Menu_Step       CHECKED
                  MENUITEM "T&race"          +Chr( 9 )+"F10"       ACTION  MenuOption( ID_trace )      TOOLTIP 'Run in Trace mode'                   NAME Menu_Trace      CHECKED
                  MENUITEM "&Go"             +Chr( 9 )+"F5"        ACTION  MenuOption( ID_go )         TOOLTIP 'Run in Go mode'                      NAME Menu_Go         CHECKED
                  MENUITEM "To &Cursor"      +Chr( 9 )+"F7"        ACTION  MenuOption( ID_tocursor )   TOOLTIP 'Run until current Cursor Position'   NAME Menu_ToCursor   CHECKED
                  MENUITEM "&Next Routine"   +Chr( 9 )+"Ctrl+F5"   ACTION  MenuOption( ID_next )       TOOLTIP 'Run until Next Routine'              NAME Menu_Next       CHECKED
                  SEPARATOR
                  MENUITEM "&Pause"          +Chr( 9 )+"Ctrl+F3"   ACTION  MenuOption( ID_pause )      TOOLTIP 'Pause any run mode'                  NAME Menu_Pause      CHECKED
            END POPUP

            DEFINE POPUP "Point"
                  MENUITEM "&BreakPoint"     +Chr( 9 )+"F9"        ACTION  MenuOption( ID_breakpoint )    TOOLTIP 'Toggle BreakPoint'
                  MENUITEM "&TracePoint"                           ACTION  MenuOption( ID_tracepoint )    TOOLTIP 'Add TracePoint'
                  MENUITEM "&WatchPoint"                           ACTION  MenuOption( ID_watchpoint )    TOOLTIP 'Add WatchPoint'
            END POPUP

            DEFINE POPUP "Setting"
                  MENUITEM "S&etting"         ACTION  MenuOption( ID_configuration )   TOOLTIP 'Enable/Disable Setting'   NAME Menu_Setting CHECKED
            END POPUP

            DEFINE POPUP "Quit"
                  MENUITEM "&Quit"            ACTION  MenuOption( ID_quit )            TOOLTIP 'Exit the debugger and closing the application'
            END POPUP
         END MENU


         DEFINE SPLITBOX

            DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 85,85 IMAGESIZE 64,64 STRICTWIDTH FLAT
               BUTTON Button_1 CAPTION "&Animate"        PICTURE '_animate'    ACTION MenuOption( ID_animate )          TOOLTIP 'Run in Animate mode'
               BUTTON Button_2 CAPTION "&Step"           PICTURE '_step'       ACTION MenuOption( ID_step )             TOOLTIP 'Run in Single Step mode'
               BUTTON Button_3 CAPTION "T&race"          PICTURE '_trace'      ACTION MenuOption( ID_trace )            TOOLTIP 'Run in Trace mode'
               BUTTON Button_4 CAPTION "&Go"             PICTURE '_go'         ACTION MenuOption( ID_go )               TOOLTIP 'Run in Go mode'
               BUTTON Button_5 CAPTION "To &Cursor"      PICTURE '_tocursor'   ACTION MenuOption( ID_tocursor )         TOOLTIP 'Run until current Cursor Position'
               BUTTON Button_6 CAPTION "&Next Routine"   PICTURE '_next'       ACTION MenuOption( ID_next )             TOOLTIP 'Run until Next Routine'
               BUTTON Button_7 CAPTION "&Pause"          PICTURE '_pause'      ACTION MenuOption( ID_pause )            TOOLTIP 'Pause any run mode'
            END TOOLBAR

            DEFINE TOOLBAR ToolBar_2 BUTTONSIZE 85,85 IMAGESIZE 64,64 STRICTWIDTH FLAT
               BUTTON Button_8  CAPTION "&BreakPoint"      PICTURE '_breakpoint'      ACTION MenuOption( ID_breakpoint )      TOOLTIP 'Toggle BreakPoint'
               BUTTON Button_9  CAPTION "&TracePoint"      PICTURE '_tracepoint'      ACTION MenuOption( ID_tracepoint )      TOOLTIP 'Add TracePoint'
               BUTTON Button_10 CAPTION "&WatchPoint"      PICTURE '_watchpoint'      ACTION MenuOption( ID_watchpoint )      TOOLTIP 'Add WatchPoint';
               SEPARATOR
               BUTTON Button_11 CAPTION "S&etting"         PICTURE '_configuration'   ACTION MenuOption( ID_configuration )   TOOLTIP 'Enable/Disable Setting';
               CHECK;
               SEPARATOR
               BUTTON Button_12 CAPTION "&Quit"            PICTURE '_quit'            ACTION MenuOption( ID_quit )            TOOLTIP 'Exit the debugger and closing the application'
            END TOOLBAR

         END SPLITBOX

         @ 0,nWIDTH() LABEL Label_1 VALUE "" AUTOSIZE
         @ 0,0 BUTTON Button_Refresh CAPTION "Refresh" PICTURE "_refresh" LEFT ACTION UpdateGrids() TOOLTIP "Refresh Grid Data" WIDTH 100 HEIGHT 30 FONT "Calibri" SIZE 10 BOLD ITALIC

         DEFINE TAB Tab_1;
            AT 0,0;
            WIDTH 0;
            HEIGHT 0;
            BOLD ITALIC;
            ON CHANGE  UpdateGrids()

            DEFINE PAGE "Source"

HMG_DebuggerWaitMessage( _HMG_DEBUGGER_MSG_ + '( DEFINE PAGE "Source" )' )
               @ 0,0 COMBOBOX ComboBox_SourceCode ITEMS HMG_Debugger():GetSourceFiles() FONT "Arial"  SIZE 10;
                     VALUE 1;
                     ON CHANGE UpdateGrids() ;
                     ON GOTFOCUS  ( nComboBoxValue := _HMG_FormDebugger.ComboBox_SourceCode.VALUE )

               bBackColor := {|| IIF ( This.CellRowIndex == nCurrentLineCode .AND. aGrid_SourceCode[ nComboBoxValue ][2], COLOR_LightGoldenrod1, NIL ) }

               aFiles := HMG_Debugger():GetSourceFiles()

               FOR i := 1 TO Len( aFiles )
HMG_DebuggerWaitMessage( _HMG_DEBUGGER_MSG_ + '( DEFINE PAGE "Source" ) >>> ' + aFiles[ i ] )
                  cGrid_SourceCode := "Grid_SourceCode_" + hb_ntos( i )
                  AAdd( aGrid_SourceCode, { cGrid_SourceCode, .F., aFiles[ i ] } )

                  @ 0,0 GRID &cGrid_SourceCode;
                     WIDTH 0;
                     HEIGHT 0;
                     HEADERS {'Line','Source Code'};
                     WIDTHS  { 0, 0 };
                     FONT "Arial"  SIZE 10  BOLD;
                     BACKCOLOR COLOR_Gainsboro;
                     FONTCOLOR COLOR_DarkGreen;
                     DYNAMICBACKCOLOR { bBackColor, bBackColor };
                     DYNAMICFORECOLOR { {|| GetForeColorSourceCode() }, {|| GetForeColorSourceCode() } };
ON DBLCLICK OnKeyPress( VK_RETURN ); // Jimmy
                     NOLINES

                     SetProperty( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "ColumnDYNAMICFONT", 1, {|| GetFontSourceCode() } )
                     SetProperty( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "ColumnDYNAMICFONT", 2, {|| GetFontSourceCode() } )

                     SetProperty( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "Image", .T., {"_pointer"} )
                     SetProperty( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "PaintDoubleBuffer", .T. )

                     LoadPrg( aGrid_SourceCode[i][1], aFiles[i] )
               NEXT

            END PAGE

            DEFINE PAGE "Stack"

HMG_DebuggerWaitMessage( _HMG_DEBUGGER_MSG_ + '( DEFINE PAGE "Stack" )' )
               bForeColor := {|| IIF ( Empty(_HMG_FormDebugger.Grid_CallStack.CELL(This.CellRowIndex, 2)), COLOR_DarkGreen, NIL ) }

               @ 0,0 GRID Grid_CallStack;
                  WIDTH 0;
                  HEIGHT 0;
                  HEADERS { "Level", "File", "Function", "Line" };
                  WIDTHS  { 80, 150, 300, 100 };
                  FONT "Arial"  SIZE 10  BOLD;
                  BACKCOLOR COLOR_Gainsboro;
                  FONTCOLOR COLOR_NavyBlue;
                  DYNAMICFORECOLOR { bForeColor, bForeColor, bForeColor, bForeColor };
                  NOLINES;
ON DBLCLICK OnKeyPress( VK_RETURN ); // Jimmy
                  TOOLTIP "Press ENTER to see the source code"

                  _HMG_FormDebugger.Grid_CallStack.PaintDoubleBuffer := .T.
            END PAGE

            DEFINE PAGE "Watch"

HMG_DebuggerWaitMessage( _HMG_DEBUGGER_MSG_ + '( DEFINE PAGE "Watch" )' )
               @ 0,0 GRID Grid_Watch;
                  WIDTH 0;
                  HEIGHT 0;
                  HEADERS { "Number", "Type", "Expression", "ValType", "Value", "ValidExpr" };
                  WIDTHS  { 0, 0, 0, 100, 100, 100 };
                  FONT "Arial"  SIZE 10  BOLD;
                  BACKCOLOR COLOR_Gainsboro;
                  FONTCOLOR COLOR_NavyBlue;
                  DYNAMICFORECOLOR { {||GetForeColorWatch()}, {||GetForeColorWatch()}, {||GetForeColorWatch()}, {||GetForeColorWatch()}, {||GetForeColorWatch()}, {||GetForeColorWatch()} };
                  NOLINES;
ON DBLCLICK OnKeyPress( VK_RETURN ); // Jimmy				  
                  TOOLTIP "Press ENTER to edit the expression and press DELETE to delete item"

                  _HMG_FormDebugger.Grid_Watch.PaintDoubleBuffer := .T.

               @ 0,0 LABEL Label_WatchNro  VALUE "" FONT "Arial"  SIZE 10 BACKCOLOR COLOR_Gainsboro FONTCOLOR COLOR_Chocolate4 BOLD ITALIC;
                     TOOLTIP "Watch number"
               SET CONTROL Label_WatchNro  OF _HMG_FormDebugger CLIENTEDGE
               _HMG_FormDebugger.Label_WatchNro.WIDTH := _HMG_FormDebugger.Label_WatchNro.WIDTH / 2

               @ 0,0 LABEL Label_WatchType VALUE "" FONT "Arial"  SIZE 10 BACKCOLOR COLOR_Gainsboro FONTCOLOR COLOR_Chocolate4 BOLD ITALIC;
                     TOOLTIP "Watch type"
               SET CONTROL Label_WatchType OF _HMG_FormDebugger CLIENTEDGE

               @ 0,0 TEXTBOX TextBox_Watch  VALUE "" BOLD BACKCOLOR COLOR_Wheat1 FONT "Arial"  SIZE 10 FONTCOLOR COLOR_Chocolate4;
                     TOOLTIP "Watch expression"
               _HMG_FormDebugger.TextBox_Watch.Enabled := .F.

               _HMG_FormDebugger.Grid_Watch.ColumnWIDTH ( 1 ) := _HMG_FormDebugger.Label_WatchNro.WIDTH  + nWIDTH() / 2
               _HMG_FormDebugger.Grid_Watch.ColumnWIDTH ( 2 ) := _HMG_FormDebugger.Label_WatchType.WIDTH + nWIDTH() / 2
               _HMG_FormDebugger.Grid_Watch.ColumnWIDTH ( 3 ) := 350

            END PAGE

            DEFINE PAGE "Evaluate"

HMG_DebuggerWaitMessage( _HMG_DEBUGGER_MSG_ + '( DEFINE PAGE "Evaluate" )' )
               @ 0,0 GRID Grid_Calc;
                  WIDTH 0;
                  HEIGHT 0;
                  HEADERS { "Expression", "Value" };
                  WIDTHS  { MIN_WIDTH / 2, MIN_WIDTH / 3 };
                  FONT "Arial"  SIZE 10  BOLD;
                  BACKCOLOR COLOR_Gainsboro;
                  FONTCOLOR COLOR_NavyBlue;
                  NOLINES;
ON DBLCLICK OnKeyPress( VK_RETURN ); // Jimmy				  
                  TOOLTIP "Press ENTER to copy expression for evaluate and press DELETE to delete item"

                  _HMG_FormDebugger.Grid_Calc.PaintDoubleBuffer := .T.

               #define TOOLTIP_CALC   "e.g. VarName, FuncName( param1, ... ), VarName := Value, Arr[i,1] := Value, etc."

               @ 0,0 LABEL Label_Calc VALUE "Enter the expression to evaluate:" AUTOSIZE FONT "Arial"  SIZE 10 FONTCOLOR COLOR_Chocolate4 BOLD ITALIC;
                     TOOLTIP TOOLTIP_CALC

               @ 0,0 TEXTBOX TextBox_Calc  VALUE "" BOLD BACKCOLOR COLOR_Wheat1 FONT "Arial"  SIZE 10 FONTCOLOR COLOR_Chocolate4;
                     TOOLTIP TOOLTIP_CALC

            END PAGE

            DEFINE PAGE "Variables"

HMG_DebuggerWaitMessage( _HMG_DEBUGGER_MSG_ + '( DEFINE PAGE "Variables" )' )
               @ 0,0 GRID Grid_Vars;
                  WIDTH 0;
                  HEIGHT 0;
                  HEADERS { "Level", "Scope", "Name", "Type", "Value" };
                  WIDTHS  { 80, 100, 300, 100, 100 };
                  FONT "Arial"  SIZE 10  BOLD;
                  BACKCOLOR COLOR_Gainsboro;
                  FONTCOLOR COLOR_NavyBlue;
                  DYNAMICFORECOLOR { {||GetForeColorVars()}, {||GetForeColorVars()}, {||GetForeColorVars()}, {||GetForeColorVars()}, {||GetForeColorVars()} };
                  NOLINES;
ON DBLCLICK OnKeyPress( VK_RETURN ); // Jimmy				  
                  TOOLTIP "Press ENTER for inspect the value of variables"

                  _HMG_FormDebugger.Grid_Vars.PaintDoubleBuffer := .T.

            END PAGE

            DEFINE PAGE "Areas"

HMG_DebuggerWaitMessage( _HMG_DEBUGGER_MSG_ + '( DEFINE PAGE "Areas" )' )
               @ 0,0 GRID Grid_Areas;
                  WIDTH 0;
                  HEIGHT 0;
                  HEADERS {'Alias','Area','RDD Name','Reccount','Recno','Bof','Eof','Found','Deleted','dbFilter', 'ordName', 'ordKey'};
                  WIDTHS  { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
                  FONT "Arial"  SIZE 10  BOLD;
                  BACKCOLOR COLOR_Gainsboro;
                  FONTCOLOR COLOR_NavyBlue;
                  NOLINES;
                  TOOLTIP "Available work areas";
ON DBLCLICK OnKeyPress( VK_RETURN ); // Jimmy				  
                  ON CHANGE ( UpdateGridRec() , _HMG_FormDebugger.Grid_Areas.SETFOCUS )

                  _HMG_FormDebugger.Grid_Areas.PaintDoubleBuffer := .T.


               @ 0,0 GRID Grid_Rec;
                  WIDTH 0;
                  HEIGHT 0;
                  HEADERS {'Name', 'Type', 'Length', 'Value'};
                  WIDTHS  { 0, 0, 0, 0 };
                  FONT "Arial"  SIZE 10  BOLD;
                  BACKCOLOR COLOR_Gainsboro;
                  FONTCOLOR COLOR_DarkGreen;
                  NOLINES;
ON DBLCLICK OnKeyPress( VK_RETURN ); // Jimmy				  
                  TOOLTIP "Value of current RECORD in the selected work area"

                  _HMG_FormDebugger.Grid_Rec.PaintDoubleBuffer := .T.

            END PAGE

            DEFINE PAGE "Setting"

HMG_DebuggerWaitMessage( _HMG_DEBUGGER_MSG_ + '( DEFINE PAGE "Setting" )' )
                  @ 0,0 FRAME Frame_Config WIDTH 0 HEIGHT 0

                  @ 0,0 CHECKBOX CheckBox_Config1 CAPTION "Allow Tracing of Code Blocks"       VALUE .T. FONT "Arial"  SIZE 10  ITALIC BOLD ON CHANGE( HMG_Debugger():lCBTrace := _HMG_FormDebugger.CheckBox_Config1.VALUE, HMG_Debugger():SetCBTrace( HMG_Debugger():lCBTrace ) )
                  @ 0,0 CHECKBOX CheckBox_Config2 CAPTION "Stop at BreakPoint in Animate mode" VALUE .T. FONT "Arial"  SIZE 10  ITALIC BOLD ON CHANGE( HMG_Debugger():lAnimateStopBP := _HMG_FormDebugger.CheckBox_Config2.VALUE )
                  @ 0,0 CHECKBOX CheckBox_Config3 CAPTION "Stop at TracePoint in Animate mode" VALUE .T. FONT "Arial"  SIZE 10  ITALIC BOLD ON CHANGE( HMG_Debugger():lAnimateStopTP := _HMG_FormDebugger.CheckBox_Config3.VALUE )
                  _HMG_FormDebugger.CheckBox_Config1.WIDTH := GetTextWidth (NIL, _HMG_FormDebugger.CheckBox_Config1.CAPTION, _HMG_SYSDATA [ 36 ] [ _HMG_FormDebugger.CheckBox_Config1.INDEX ] ) + 50
                  _HMG_FormDebugger.CheckBox_Config2.WIDTH := GetTextWidth (NIL, _HMG_FormDebugger.CheckBox_Config2.CAPTION, _HMG_SYSDATA [ 36 ] [ _HMG_FormDebugger.CheckBox_Config2.INDEX ] ) + 50
                  _HMG_FormDebugger.CheckBox_Config3.WIDTH := GetTextWidth (NIL, _HMG_FormDebugger.CheckBox_Config3.CAPTION, _HMG_SYSDATA [ 36 ] [ _HMG_FormDebugger.CheckBox_Config3.INDEX ] ) + 50

                  @ 0,0 LABEL Label_Config VALUE "Speed in Animate mode ( in milliseconds ) " AUTOSIZE FONT "Arial"  SIZE 10  ITALIC BOLD
                  @ 0,0 SPINNER Spinner_Config  RANGE 0, 65534 VALUE 0 FONT "Arial"  SIZE 10  ON CHANGE( HMG_Debugger():nSpeed := _HMG_FormDebugger.Spinner_Config.VALUE )

                  @ 0,0 BUTTON Button_Config1 CAPTION "Load" PICTURE "_open" LEFT ACTION LoadSettings()
                  @ 0,0 BUTTON Button_Config2 CAPTION "Save" PICTURE "_save" LEFT ACTION SaveSettings()

            END PAGE

            DEFINE PAGE "About"

HMG_DebuggerWaitMessage( _HMG_DEBUGGER_MSG_ + '( DEFINE PAGE "About" )' )
               @ 0, 0 IMAGE Image_1 PICTURE "_about" TOOLTIP "Click here for open the blog of author: http://srvet.blogspot.com" ON CLICK ShellExecute(0, "open", "rundll32.exe", "url.dll,FileProtocolHandler http://srvet.blogspot.com", NIL, 1)
               SetWindowCursor (_HMG_FormDebugger.Image_1.HANDLE, IDC_HAND)

            END PAGE

         END TAB

      END WINDOW

HMG_DebuggerWaitMessage( _HMG_DEBUGGER_MSG_ + '( ACTIVATE WINDOW )' )
      AddDbgForm( "_HMG_FormDebugger" )

      hMainMenu := GetMenu( _HMG_FormDebugger.HANDLE )
      SetMenu( _HMG_FormDebugger.HANDLE, 0 )   // Hide Main Menu

      EnableConfig( .F. )
      MenuCheckRunMode( ID_pause )
      _HMG_FormDebugger.Menu_Setting.CHECKED := .F.
      _HMG_FormDebugger.NoClose := .T.
      _HMG_FormDebugger.WIDTH  := 700
      _HMG_FormDebugger.HEIGHT := GetDesktopRealHeight()
      _HMG_FormDebugger.ROW    := GetDesktopRealTop()
      _HMG_FormDebugger.COL    := ( GetDesktopRealLeft() + GetDesktopRealWidth()  - _HMG_FormDebugger.WIDTH )
      _HMG_FormDebugger.SHOW
      CREATE EVENT PROCNAME HMG_ShowEventMonitor() STOREINDEX nEventIndex

      HMG_DebuggerWaitMessage()

      ACTIVATE WINDOW DEBUGGER _HMG_FormDebugger   // Activate Window and Install Hooks without calling the Message Loop
      HMG_ActivateMainWindowFirst( lOldMainFirst )

      IF hb_FileExists( HMG_Debugger():cSettingsFileName )
         RestoreSettings( HMG_Debugger():cSettingsFileName )
      ELSE
         HMG_Debugger():cSettingsFileName := ""
      ENDIF

      _HMG_FormDebugger.REDRAW
      DoEvents()

   ENDIF

RETURN


PROCEDURE HotKeyHelp
__THREAD STATIC lEntry := .F.
LOCAL cText := ""
   IFENTRY( lEntry )
   cText := cText + "Alt+D"   +Chr( 9 )+ "On/Off"         + hb_eol()
   cText := cText + "Alt +/-" +Chr( 9 )+ "Transparency"   + hb_eol()
   cText := cText + "Alt+F9"  +Chr( 9 )+ "Top/Bottom"     + hb_eol()
   cText := cText + "Alt+M"   +Chr( 9 )+ "Release Memory" + hb_eol()
   cText := cText + "F11"     +Chr( 9 )+ "ToolBar/Menu"   + hb_eol()
   cText := cText + "Alt+X"   +Chr( 9 )+ "Quit"           + hb_eol()
   cText := cText + hb_eol()
   cText := cText + "Ctrl+H"  +Chr( 9 )+ "Help"         + hb_eol()
   cText := cText + "F3"      +Chr( 9 )+ "Animate"      + hb_eol()
   cText := cText + "F8"      +Chr( 9 )+ "Step"         + hb_eol()
   cText := cText + "F10"     +Chr( 9 )+ "Trace"        + hb_eol()
   cText := cText + "F5"      +Chr( 9 )+ "Go"           + hb_eol()
   cText := cText + "F7"      +Chr( 9 )+ "To Cursor"    + hb_eol()
   cText := cText + "Ctrl+F5" +Chr( 9 )+ "Next Routine" + hb_eol()
   cText := cText + "Ctrl+F3" +Chr( 9 )+ "Pause"        + hb_eol()
   cText := cText + "F9"      +Chr( 9 )+ "BreakPoint"   + hb_eol()
   MessageBoxIndirect( NIL, cText, _HMG_DEBUGGER_NAME_ + " - Help", hb_bitOR( MB_SYSTEMMODAL, MB_OK ), _HMG_DEBUGGER_ICON_ )
   lEntry := .F.
RETURN


PROCEDURE MenuOption( nID )
   MenuCheckRunMode( nID )
   SWITCH nID
      CASE ID_animate         ; HMG_Debugger():Animate()          ; EXIT
      CASE ID_step            ; HMG_Debugger():Step()             ; EXIT
      CASE ID_trace           ; HMG_Debugger():Trace()            ; EXIT
      CASE ID_go              ; HMG_Debugger():Go()               ; EXIT
      CASE ID_tocursor        ; ToCursor()                        ; EXIT
      CASE ID_next            ; HMG_Debugger():SetNextRoutine()   ; EXIT
      CASE ID_pause           ; HMG_Debugger():Pause()            ; EXIT
      CASE ID_breakpoint      ; ToggleBreakPoint()                ; EXIT
      CASE ID_tracepoint      ; AddWatchIni( BTN_TP )             ; EXIT
      CASE ID_watchpoint      ; AddWatchIni( BTN_WP )             ; EXIT
      CASE ID_configuration   ; EnableConfig()                    ; EXIT
      CASE ID_quit            ; Quit()                            ; EXIT
   ENDSWITCH
RETURN


PROCEDURE MenuCheckRunMode( nID )
   _HMG_FormDebugger.Menu_Animate.CHECKED    := .F.
   _HMG_FormDebugger.Menu_Step.CHECKED       := .F.
   _HMG_FormDebugger.Menu_Trace.CHECKED      := .F.
   _HMG_FormDebugger.Menu_Go.CHECKED         := .F.
   _HMG_FormDebugger.Menu_ToCursor.CHECKED   := .F.
   _HMG_FormDebugger.Menu_Next.CHECKED       := .F.
   _HMG_FormDebugger.Menu_Pause.CHECKED      := .F.
   SWITCH nID
      CASE ID_animate         ; _HMG_FormDebugger.Menu_Animate.CHECKED    := .T.   ; EXIT
      CASE ID_step            ; _HMG_FormDebugger.Menu_Step.CHECKED       := .T.   ; EXIT
      CASE ID_trace           ; _HMG_FormDebugger.Menu_Trace.CHECKED      := .T.   ; EXIT
      CASE ID_go              ; _HMG_FormDebugger.Menu_Go.CHECKED         := .T.   ; EXIT
      CASE ID_tocursor        ; _HMG_FormDebugger.Menu_ToCursor.CHECKED   := .T.   ; EXIT
      CASE ID_next            ; _HMG_FormDebugger.Menu_Next.CHECKED       := .T.   ; EXIT
      CASE ID_pause           ; _HMG_FormDebugger.Menu_Pause.CHECKED      := .T.   ; EXIT
   ENDSWITCH
RETURN


PROCEDURE ShowHideSplitBox
   lShowSplitBox := .NOT. lShowSplitBox
   IF lShowSplitBox == .T.
      SetMenu( _HMG_FormDebugger.HANDLE, 0 )
      ShowWindow( GetSplitBoxHANDLE( "_HMG_FormDebugger" ) )
   ELSE
      HideWindow( GetSplitBoxHANDLE( "_HMG_FormDebugger" ) )
      SetMenu( _HMG_FormDebugger.HANDLE, hMainMenu )
   ENDIF
   AjustControlSize()
   RedrawWindow( _HMG_FormDebugger.Label_1.HANDLE )
RETURN


PROCEDURE AddDbgForm( cFormName )
   AAdd( aDebuggerForms, GetFormHandle( cFormName ) )
RETURN

FUNCTION DeleteDbgForm( cFormName )
LOCAL i := AScan( aDebuggerForms, GetFormHandle( cFormName ) )
   IF i > 0
     hb_ADel( aDebuggerForms, i, .T. )
   ENDIF
RETURN i


PROCEDURE ViewVars()
LOCAL cVarName, cValType
LOCAL xVarValue, aVar, aColor
LOCAL nPos := _HMG_FormDebugger.Grid_Vars.VALUE
   IF nPos >= 1 .AND. nPos <= _HMG_FormDebugger.Grid_Vars.ITEMCOUNT
      aColor := GetForeColorVars( nPos )
      aVar := aRawVars[ nPos ]
      cVarName  := HMG_Debugger():VarGetName( aVar )
      cValType  := HMG_Debugger():VarGetValType( aVar )
      xVarValue := HMG_Debugger():VarGetValue( aVar )
      DisplayVars ( cVarName, xVarValue, aColor )
   ENDIF
RETURN


PROCEDURE DisplayVars ( cVarName, xVarValue, aColor )
#define _GRIDNAME_ "GridVars2"
LOCAL cFormName := "_HMG_dbgVar_" + cVarName
LOCAL cGridName := _GRIDNAME_
LOCAL cTitle, nRow, aInfo
LOCAL aItems, aObjRawValue
LOCAL cFormAux, cGridAux
LOCAL nCol, lOldMainFirst

   cFormName := StrTran( cFormName, " ")   // remove all spaces
   cFormName := StrTran( cFormName, "'")   // remove all quotes
   cFormName := StrTran( cFormName, '"')   // remove all double quotes
   cFormName := StrTran( cFormName, "]")
   cFormName := StrTran( cFormName, "[", "_")
   cFormName := StrTran( cFormName, ":", "_")

   GetControlNameByHandle( GetFocus(), @cGridAux, @cFormAux )
   nRow := GetProperty( cFormAux, cGridAux, "VALUE" )
   nCol := Iif ( cGridAux == _GRIDNAME_ , 1 , 3 )
   _HMG_FormDebugger.TextBox_Calc.VALUE := GetProperty( cFormAux, cGridAux, "CELL", nRow, nCol )

   IF ValType( xVarValue ) == "A" .AND. Len( xVarValue ) > 0        // Array
      aItems := HMG_Debugger():GetArrayInfo( cVarName, xVarValue )
   ELSEIF ValType( xVarValue ) == "H" .AND. Len( xVarValue ) > 0    // Hash
      aItems := HMG_Debugger():GetHashInfo( cVarName, xVarValue )
   ELSEIF ValType( xVarValue ) == "O"                               // Object
      aItems := HMG_Debugger():GetObjectInfo( cVarName, xVarValue, @aObjRawValue )
      IF Len( aItems ) == 0
         PlayExclamation()
         RETURN
      ENDIF
   ELSE
      PlayExclamation()
      RETURN
   ENDIF

   IF _IsWindowDefined( cFormName )
      DoMethod( cFormName, "RELEASE" )
   ENDIF

      IF ValType( xVarValue ) $ "AH"
         cTitle := cVarName + " [ 1 ... " + hb_ntos( Len( xVarValue ) ) + " ] "   // Array and Hash
      ELSE
         cTitle := cVarName + " is of class: " + xVarValue:ClassName()   // Object
      ENDIF

      aInfo := GET_HMG_SYSDATA()
      _HMG_SYSDATA [ 223 ] := ""

      lOldMainFirst := HMG_ActivateMainWindowFirst( .F. )

      DEFINE WINDOW &cFormName;
         AT 0,0;
         WIDTH  MIN_WIDTH;
         HEIGHT MIN_HEIGHT;
         TITLE cTitle;
         ON INIT     Ajust( cFormName, cGridName );
         ON MAXIMIZE Ajust( cFormName, cGridName );
         ON SIZE     Ajust( cFormName, cGridName );
         ON RELEASE  DeleteDbgForm( cFormName )

         @ nHEIGHT() , nWIDTH() GRID &cGridName;
            WIDTH 0;
            HEIGHT 0;
            HEADERS { "Name", "Type", "Value" };
            WIDTHS  { 300, 100, 100 };
            ITEMS aItems;
            FONT "Arial"  SIZE 10  BOLD;
            BACKCOLOR COLOR_Gainsboro;
            FONTCOLOR COLOR_NavyBlue;
            DYNAMICFORECOLOR { {|| aColor }, {|| aColor }, {|| aColor } };
            NOLINES;
ON DBLCLICK OnKeyPress_DisplayVars( VK_RETURN, cFormName, cGridName, xVarValue, aObjRawValue, aColor ) ;			
            TOOLTIP "Press ENTER for inspect the value of variables"

         ON KEY RETURN ACTION OnKeyPress_DisplayVars( VK_RETURN, cFormName, cGridName, xVarValue, aObjRawValue, aColor )
         ON KEY ESCAPE ACTION OnKeyPress_DisplayVars( VK_ESCAPE, cFormName )

         SetProperty( cFormName, cGridName, "PaintDoubleBuffer", .T. )
         SetProperty( cFormName, cGridName, "ColumnWIDTH", 1, GRID_WIDTH_AUTOSIZE )
         SetProperty( cFormName, cGridName, "ColumnWIDTH", 3, GRID_WIDTH_AUTOSIZE )

         IF GetProperty( cFormName, cGridName, "ColumnWIDTH", 1 ) < 300
            SetProperty( cFormName, cGridName, "ColumnWIDTH", 1, 300 )
         ENDIF
         IF GetProperty( cFormName, cGridName, "ColumnWIDTH", 3 ) < 100
            SetProperty( cFormName, cGridName, "ColumnWIDTH", 3, 100 )
         ENDIF

      END WINDOW
      AddDbgForm( cFormName )

      CENTER WINDOW &cFormName
      ACTIVATE WINDOW DEBUGGER &cFormName   // Activate Window without calling the Message Loop and Not Exit the App at Close this Form
      HMG_ActivateMainWindowFirst( lOldMainFirst )

      PUT_HMG_SYSDATA( aInfo )

RETURN


PROCEDURE OnKeyPress_DisplayVars( nVKey, cFormName, cGridName, xVarValue, aObjRawValue, aColor )
LOCAL cVarName, nRow
   IF nVKey == VK_RETURN
      nRow := GetProperty( cFormName, cGridName, "VALUE" )
      cVarName := GetProperty( cFormName, cGridName, "CELL", nRow, 1 )
      IF nRow > 0 .AND. .NOT. Empty( cVarName )
         DO CASE
            CASE ValType( xVarValue ) == "A"
                 DisplayVars( cVarName, xVarValue[ nRow ], aColor  )
            CASE ValType( xVarValue ) == "H"
                 DisplayVars( cVarName, hb_HValueAt( xVarValue, nRow ), aColor )
            CASE ValType( xVarValue ) == "O"
                 DisplayVars( cVarName, aObjRawValue[ nRow ], aColor  )
         ENDCASE
      ENDIF
   ELSEIF nVKey == VK_ESCAPE
      DoMethod( cFormName, "RELEASE" )
   ENDIF
RETURN


PROCEDURE Ajust( cFormName, cGridName )
LOCAL nWidth  := GetProperty( cFormName, "WIDTH"  ) - GetProperty( cFormName, cGridName, "COL" ) - GetSystemMetrics( SM_CXEDGE ) - nWIDTH()  * 2
LOCAL nHeight := GetProperty( cFormName, "HEIGHT" ) - GetProperty( cFormName, cGridName, "ROW" ) - GetSystemMetrics( SM_CYEDGE ) - nHEIGHT() * 3
   SetProperty( cFormName, cGridName, "WIDTH", nWidth )
   SetProperty( cFormName, cGridName, "HEIGHT", nHeight )
RETURN


FUNCTION GET_HMG_SYSDATA()
LOCAL aInfo := ARRAY( 21 )
   aInfo[  1 ] := _HMG_SYSDATA [ 223 ]   // _HMG_ActiveFormName
   aInfo[  2 ] := _HMG_SYSDATA [ 214 ]   // _HMG_TempWindowName
   aInfo[  3 ] := _HMG_SYSDATA [ 235 ]   // LOAD WINDOW optional row
   aInfo[  4 ] := _HMG_SYSDATA [ 236 ]   // LOAD WINDOW optional col
   aInfo[  5 ] := _HMG_SYSDATA [ 237 ]   // LOAD WINDOW optional width
   aInfo[  6 ] := _HMG_SYSDATA [ 238 ]   // LOAD WINDOW optional height
   aInfo[  7 ] := _HMG_SYSDATA [ 183 ]   // _HMG_FrameLevel
   aInfo[  8 ] := _HMG_SYSDATA [ 181 ]   // _HMG_MainHandle
   aInfo[  9 ] := _HMG_SYSDATA [ 240 ]   // Parent Window Active
   aInfo[ 10 ] := _HMG_SYSDATA [ 215 ]   // _HMG_ActiveFormNameBak
   aInfo[ 11 ] := _HMG_SYSDATA [ 224 ]   // _HMG_ActiveFontName
   aInfo[ 12 ] := _HMG_SYSDATA [ 182 ]   // _HMG_ActiveFontSize
   aInfo[ 13 ] := _HMG_SYSDATA [ 264 ]   // _HMG_BeginWindowActive
   aInfo[ 14 ] := _HMG_SYSDATA [ 265 ]   // _HMG_BeginTabActive
   aInfo[ 15 ] := _HMG_SYSDATA [ 164 ]   // _HMG_MainIndex
   aInfo[ 16 ] := _HMG_SYSDATA [  55 ]   // ToolTip Style
   aInfo[ 17 ] := _HMG_SYSDATA [  56 ]   // ToolTip BackColor
   aInfo[ 18 ] := _HMG_SYSDATA [  57 ]   // Tooltip ForeColor
   aInfo[ 19 ] := _HMG_SYSDATA [ 225 ]   // _HMG_ActiveTabName
   aInfo[ 20 ] := _HMG_SYSDATA [ 342 ]   // _HMG_DefaultFontName
   aInfo[ 21 ] := _HMG_SYSDATA [ 343 ]   // _HMG_DefaultFontSize
RETURN aInfo


FUNCTION PUT_HMG_SYSDATA( aInfo )
   _HMG_SYSDATA [ 223 ] := aInfo[  1 ]
   _HMG_SYSDATA [ 214 ] := aInfo[  2 ]
   _HMG_SYSDATA [ 235 ] := aInfo[  3 ]
   _HMG_SYSDATA [ 236 ] := aInfo[  4 ]
   _HMG_SYSDATA [ 237 ] := aInfo[  5 ]
   _HMG_SYSDATA [ 238 ] := aInfo[  6 ]
   _HMG_SYSDATA [ 183 ] := aInfo[  7 ]
   _HMG_SYSDATA [ 181 ] := aInfo[  8 ]
   _HMG_SYSDATA [ 240 ] := aInfo[  9 ]
   _HMG_SYSDATA [ 215 ] := aInfo[ 10 ]
   _HMG_SYSDATA [ 224 ] := aInfo[ 11 ]
   _HMG_SYSDATA [ 182 ] := aInfo[ 12 ]
   _HMG_SYSDATA [ 264 ] := aInfo[ 13 ]
   _HMG_SYSDATA [ 265 ] := aInfo[ 14 ]
   _HMG_SYSDATA [ 164 ] := aInfo[ 15 ]
   _HMG_SYSDATA [  55 ] := aInfo[ 16 ]
   _HMG_SYSDATA [  56 ] := aInfo[ 17 ]
   _HMG_SYSDATA [  57 ] := aInfo[ 18 ]
   _HMG_SYSDATA [ 225 ] := aInfo[ 19 ]
   _HMG_SYSDATA [ 342 ] := aInfo[ 20 ]
   _HMG_SYSDATA [ 343 ] := aInfo[ 21 ]
RETURN NIL


PROCEDURE SaveSettings()
__THREAD STATIC lEntry := .F.
LOCAL cFileName
   IFENTRY( lEntry )
   cFileName := PutFile ( { {'HMG Debugger Files','*.dbg'} } , _HMG_DEBUGGER_NAME_ + ": Save Settings", NIL, NIL, HMG_Debugger():cSettingsFileName )
   IF .NOT. Empty( cFileName )
      HMG_Debugger():cSettingsFileName := cFileName
      HMG_Debugger():SaveSettings( cFileName )
   ENDIF
   lEntry := .F.
RETURN


PROCEDURE LoadSettings()
__THREAD STATIC lEntry := .F.
LOCAL cFileName
   IFENTRY( lEntry )
   cFileName := GetFile ( { {'HMG Debugger Files','*.dbg'} } , _HMG_DEBUGGER_NAME_ + ": Load Settings" )
   IF .NOT. Empty( cFileName )
      HMG_Debugger():cSettingsFileName := cFileName
      RestoreSettings( cFileName )
   ENDIF
   lEntry := .F.
RETURN


PROCEDURE RestoreSettings( cFileName )
   HMG_Debugger():RestoreSettings( cFileName )
   _HMG_FormDebugger.CheckBox_Config1.VALUE := HMG_Debugger():lCBTrace
   _HMG_FormDebugger.CheckBox_Config2.VALUE := HMG_Debugger():lAnimateStopBP
   _HMG_FormDebugger.CheckBox_Config3.VALUE := HMG_Debugger():lAnimateStopTP
   _HMG_FormDebugger.Spinner_Config.VALUE   := HMG_Debugger():nSpeed
RETURN


PROCEDURE Quit
__THREAD STATIC lEntry := .F.
LOCAL nRet
   IFENTRY( lEntry )
   nRet := MessageBoxIndirect( NIL, "Are you sure you want to EXIT the program ?", _HMG_DEBUGGER_NAME_, hb_bitOR( MB_SYSTEMMODAL, MB_OKCANCEL ), _HMG_DEBUGGER_ICON_ )
   IF nRet == IDOK
      HMG_Debugger():Quit()
   ENDIF
   lEntry := .F.
RETURN


PROCEDURE RepaintGridRow ( cFormName, cGridName, nRow )
LOCAL xValue := GetProperty( cFormName, cGridName, "ITEM", nRow)
   SetProperty( cFormName, cGridName, "ITEM", nRow, xValue )
RETURN


PROCEDURE ToggleBreakPoint
__THREAD STATIC lEntry := .F.
LOCAL i := _HMG_FormDebugger.ComboBox_SourceCode.VALUE
LOCAL nLine := GetProperty( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "VALUE" )
LOCAL cFileName := _HMG_FormDebugger.ComboBox_SourceCode.ITEM( _HMG_FormDebugger.ComboBox_SourceCode.VALUE )
LOCAL cMsg
   IFENTRY( lEntry )
   IF _HMG_FormDebugger.Tab_1.VALUE <> TAB_CODE
      _HMG_FormDebugger.Tab_1.VALUE := TAB_CODE
      MessageBoxIndirect( NIL, "Toggle BreakPoint : First select the line in the source code.", _HMG_DEBUGGER_NAME_, hb_bitOR( MB_SYSTEMMODAL, MB_OK ), _HMG_DEBUGGER_ICON_ )
   ELSEIF HMG_Debugger():IsValidStopLine( cFileName, nLine )
      HMG_Debugger():BreakPointToggle( cFileName, nLine )
      RepaintGridRow( "_HMG_FormDebugger", aGrid_SourceCode[i][1], nLine )
   ELSE
      cMsg := "Toggle BreakPoint : Invalid line of code ( # "+ hb_ntos(nLine) +" )"
      i := HMG_Debugger():GetNextValidStopLineEx( cFileName, nLine )
      IF HMG_Debugger():IsValidStopLine( cFileName, i )
         cMsg = cMsg + Repl( HB_OSNewLine(), 2 ) + "The next valid line of code is ( # "+ hb_ntos(i) +" )"
      ELSE
         cMsg = cMsg + Repl( HB_OSNewLine(), 2 ) + "It does not exist next valid line of code in this file"
      ENDIF
      MessageBoxIndirect( NIL, cMsg, _HMG_DEBUGGER_NAME_, hb_bitOR( MB_SYSTEMMODAL, MB_OK ), _HMG_DEBUGGER_ICON_ )
   ENDIF
   lEntry := .F.
RETURN


PROCEDURE AddWatchIni( nOption )
   nBtnOption := nOption
   IF nBtnOption == BTN_WP .OR. nBtnOption == BTN_TP
      IF _HMG_FormDebugger.Tab_1.VALUE <> TAB_WATCH
         _HMG_FormDebugger.Tab_1.VALUE := TAB_WATCH
      ELSE
         UpdateGridWatch()
      ENDIF
      _HMG_FormDebugger.TextBox_Watch.Enabled := .T.
      _HMG_FormDebugger.Label_WatchNro.VALUE  := "New"
      _HMG_FormDebugger.Label_WatchType.VALUE := Iif( nBtnOption == BTN_WP, "WatchPoint", "TracePoint" )
      _HMG_FormDebugger.TextBox_Watch.VALUE   := ""
      _HMG_FormDebugger.TextBox_Watch.SETFOCUS
   ENDIF
RETURN


PROCEDURE ToCursor
__THREAD STATIC lEntry := .F.
LOCAL i := _HMG_FormDebugger.ComboBox_SourceCode.VALUE
LOCAL nLine := GetProperty( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "VALUE" )
LOCAL cFileName := _HMG_FormDebugger.ComboBox_SourceCode.ITEM( _HMG_FormDebugger.ComboBox_SourceCode.VALUE )
LOCAL cMsg
   IFENTRY( lEntry )
   IF HMG_Debugger():IsValidStopLine( cFileName, nLine )
      HMG_Debugger():SetToCursor( cFileName, nLine )
   ELSE
      _HMG_FormDebugger.Tab_1.VALUE := TAB_CODE
      cMsg := "To Cursor : Invalid line of code ( # "+ hb_ntos(nLine) +" )"
      i := HMG_Debugger():GetNextValidStopLineEx( cFileName, nLine )
      IF HMG_Debugger():IsValidStopLine( cFileName, i )
         cMsg = cMsg + Repl( HB_OSNewLine(), 2 ) + "The next valid line of code is ( # "+ hb_ntos(i) +" )"
      ELSE
         cMsg = cMsg + Repl( HB_OSNewLine(), 2 ) + "It does not exist next valid line of code in this file"
      ENDIF
      MessageBoxIndirect( NIL, cMsg, _HMG_DEBUGGER_NAME_, hb_bitOR( MB_SYSTEMMODAL, MB_OK ), _HMG_DEBUGGER_ICON_ )
   ENDIF
   lEntry := .F.
RETURN


PROCEDURE EvaluateExp( cExpr )
LOCAL lValid, cResult, cValue
   IF .NOT. Empty( cExpr )
      cValue := HMG_Debugger():GetExprValue( cExpr, @lValid )
      cResult := __dbgValToStr( cValue )
      _HMG_FormDebugger.Grid_Calc.AddItem( { cExpr, cResult } )
   ENDIF
RETURN


PROCEDURE OnKeyPress( nVKey )
LOCAL cFileName, nLineCode
LOCAL cType, i, nRet
LOCAL cExpr, nWatch
LOCAL hWnd := GetFocus()

   DO CASE

      CASE _HMG_FormDebugger.ComboBox_SourceCode.HANDLE == hWnd
         IF nVKey == VK_RETURN
            DoMethod( "_HMG_FormDebugger", aGrid_SourceCode[ _HMG_FormDebugger.ComboBox_SourceCode.VALUE ][1], "SETFOCUS" )
         ELSEIF nVKey == VK_ESCAPE
            _HMG_FormDebugger.ComboBox_SourceCode.VALUE := nComboBoxValue
            DoMethod( "_HMG_FormDebugger", aGrid_SourceCode[ _HMG_FormDebugger.ComboBox_SourceCode.VALUE ][1], "SETFOCUS" )
         ENDIF

      CASE _HMG_FormDebugger.Grid_CallStack.HANDLE == hWnd
         IF nVKey == VK_RETURN
            cFileName := AllTrim( _HMG_FormDebugger.Grid_CallStack.CELL (_HMG_FormDebugger.Grid_CallStack.VALUE, 2 ) )
            i := AScan( HMG_Debugger():GetSourceFiles(), cFileName )
            IF .NOT. Empty( cFileName ) .AND. i > 0
               _HMG_FormDebugger.ComboBox_SourceCode.VALUE := i
               nLineCode := Val( _HMG_FormDebugger.Grid_CallStack.CELL (_HMG_FormDebugger.Grid_CallStack.VALUE, 4 ) )
               SetProperty( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "VALUE", nLineCode )
               _HMG_FormDebugger.Tab_1.VALUE := TAB_CODE
               DoMethod( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "SETFOCUS" )
            ENDIF
         ENDIF

      CASE _HMG_FormDebugger.Grid_Watch.HANDLE == hWnd

         IF nVKey == VK_RETURN
            cType := AllTrim( _HMG_FormDebugger.Grid_Watch.CELL( _HMG_FormDebugger.Grid_Watch.CellRowFocused, 2 ) )
            IF cType $ "wp,tp"
               _HMG_FormDebugger.Label_WatchNro.VALUE  := _HMG_FormDebugger.Grid_Watch.CELL( _HMG_FormDebugger.Grid_Watch.CellRowFocused, 1 )
               _HMG_FormDebugger.Label_WatchType.VALUE := Iif( cType == "wp", "WatchPoint", "TracePoint")
               _HMG_FormDebugger.TextBox_Watch.VALUE   := _HMG_FormDebugger.Grid_Watch.CELL( _HMG_FormDebugger.Grid_Watch.CellRowFocused, 3 )
               nBtnOption := BTN_EDIT
               _HMG_FormDebugger.TextBox_Watch.ENABLED := .T.
               _HMG_FormDebugger.TextBox_Watch.SETFOCUS
               _PushKey (VK_END)
            ENDIF
         ELSEIF nVKey == VK_DELETE .AND. _HMG_FormDebugger.Grid_Watch.CellRowFocused > 0
            nRet := MessageBoxIndirect( NIL, "Are sure you want to DELETE the item # "+ hb_ntos( _HMG_FormDebugger.Grid_Watch.CellRowFocused ) +" ?", _HMG_DEBUGGER_NAME_, hb_bitOR( MB_SYSTEMMODAL, MB_OKCANCEL ), _HMG_DEBUGGER_ICON_ )
            IF nRet == IDOK
               HMG_Debugger():WatchDelete( _HMG_FormDebugger.Grid_Watch.CellRowFocused )
               _HMG_FormDebugger.Grid_Watch.DeleteItem( _HMG_FormDebugger.Grid_Watch.CellRowFocused )
            ENDIF
            _HMG_FormDebugger.Grid_Watch.SETFOCUS
         ENDIF

      CASE _HMG_FormDebugger.TextBox_Watch.HANDLE == hWnd
         cExpr  := _HMG_FormDebugger.TextBox_Watch.VALUE
         nWatch := Val( _HMG_FormDebugger.Label_WatchNro.VALUE )
         IF .NOT. Empty( cExpr ) .AND. ( nBtnOption == BTN_WP .OR. nBtnOption == BTN_TP .OR. nBtnOption == BTN_EDIT )
            IF nVKey == VK_RETURN
               IF nBtnOption == BTN_WP
                  HMG_Debugger():WatchPointAdd( cExpr )
               ELSEIF nBtnOption == BTN_TP
                  HMG_Debugger():TracePointAdd( cExpr )
               ELSEIF nBtnOption == BTN_EDIT .AND. nWatch > 0
                  HMG_Debugger():WatchSetExpr( nWatch, cExpr )
               ENDIF
               UpdateGridWatch()
            ENDIF
         ENDIF
         IF nVKey == VK_RETURN .OR. nVKey == VK_ESCAPE
            _HMG_FormDebugger.Label_WatchNro.VALUE  := ""
            _HMG_FormDebugger.Label_WatchType.VALUE := ""
            _HMG_FormDebugger.TextBox_Watch.VALUE   := ""
            _HMG_FormDebugger.TextBox_Watch.Enabled := .F.
            nBtnOption := BTN_NONE
         ELSEIF nVKey == VK_DELETE
            SendMessage( _HMG_FormDebugger.TextBox_Watch.HANDLE, WM_KEYDOWN, VK_DELETE, 0 )
            SendMessage( _HMG_FormDebugger.TextBox_Watch.HANDLE, WM_KEYUP,   VK_DELETE, 0 )
         ENDIF

      CASE _HMG_FormDebugger.TextBox_Calc.HANDLE == hWnd   // OnEnter Method
         IF nVKey == VK_RETURN
            EvaluateExp( _HMG_FormDebugger.TextBox_Calc.VALUE )
            _HMG_FormDebugger.TextBox_Calc.VALUE := ""
         ELSEIF nVKey == VK_DELETE
            SendMessage( _HMG_FormDebugger.TextBox_Calc.HANDLE, WM_KEYDOWN, VK_DELETE, 0 )
            SendMessage( _HMG_FormDebugger.TextBox_Calc.HANDLE, WM_KEYUP,   VK_DELETE, 0 )
         ENDIF

      CASE _HMG_FormDebugger.Grid_Calc.HANDLE == hWnd
         IF nVKey == VK_RETURN
            _HMG_FormDebugger.TextBox_Calc.VALUE := _HMG_FormDebugger.Grid_Calc.CELL( _HMG_FormDebugger.Grid_Calc.CellRowFocused, 1 )
            _HMG_FormDebugger.TextBox_Calc.SETFOCUS
         ELSEIF nVKey == VK_DELETE
            _HMG_FormDebugger.Grid_Calc.DeleteItem( _HMG_FormDebugger.Grid_Calc.CellRowFocused )
            _HMG_FormDebugger.Grid_Calc.SETFOCUS
         ENDIF

      CASE _HMG_FormDebugger.Grid_Vars.HANDLE == hWnd
         IF nVKey == VK_RETURN
            ViewVars()
         ENDIF

   ENDCASE

RETURN



PROCEDURE EnableConfig( lValue )
   IF ValType( lValue ) == "U"
      IF lShowSplitBox == .T.
         lValue := _HMG_FormDebugger.Button_11.VALUE
         _HMG_FormDebugger.Menu_Setting.CHECKED := lValue
      ELSE
         lValue := .NOT. _HMG_FormDebugger.Menu_Setting.CHECKED
         _HMG_FormDebugger.Menu_Setting.CHECKED := lValue
         _HMG_FormDebugger.Button_11.VALUE := lValue
      ENDIF
      _HMG_FormDebugger.Tab_1.VALUE := TAB_CONFIG
   ENDIF
   SetProperty( "_HMG_FormDebugger", "CheckBox_Config1", "ENABLED", lValue )
   SetProperty( "_HMG_FormDebugger", "CheckBox_Config2", "ENABLED", lValue )
   SetProperty( "_HMG_FormDebugger", "CheckBox_Config3", "ENABLED", lValue )
   SetProperty( "_HMG_FormDebugger", "Label_Config",     "ENABLED", lValue )
   SetProperty( "_HMG_FormDebugger", "Spinner_Config",   "ENABLED", lValue )
   SetProperty( "_HMG_FormDebugger", "Button_Config1",   "ENABLED", lValue )
   SetProperty( "_HMG_FormDebugger", "Button_Config2",   "ENABLED", lValue )
RETURN


FUNCTION GetForeColorSourceCode()
LOCAL i, cFileName, aBreakPoints
   cFileName := aGrid_SourceCode[ nComboBoxValue ][3]
   aBreakPoints := HMG_Debugger():GetBreakPoints()
   FOR i := 1 TO Len ( aBreakPoints )
      IF aBreakPoints[i,1] == This.CellRowIndex .AND. aBreakPoints[i,2] == cFileName
         RETURN COLOR_Red
      ENDIF
   NEXT
RETURN IIF (This.CellColIndex == 2, COLOR_NavyBlue, NIL)


FUNCTION GetFontSourceCode()
LOCAL i, cFileName, aBreakPoints
   cFileName := aGrid_SourceCode[ nComboBoxValue ][3]
   aBreakPoints := HMG_Debugger():GetBreakPoints()
   FOR i := 1 TO Len ( aBreakPoints )
      IF aBreakPoints[i,1] == This.CellRowIndex .AND. aBreakPoints[i,2] == cFileName
         RETURN { "ARIAL", 10, .T., .T. }
      ENDIF
   NEXT
RETURN NIL


FUNCTION GetForeColorWatch
LOCAL aColor := NIL
LOCAL aWatch := HMG_Debugger():GetWatch()
   IF aWatch [ This.CellRowIndex ] [ 1 ] == "tp" .AND. aWatch [ This.CellRowIndex ] [ 4 ] == .T.
      aColor := COLOR_Red
   ENDIF
RETURN aColor


FUNCTION GetForeColorVars( nRow )
LOCAL aColor := NIL
   hb_default( @nRow, This.CellRowIndex )
   DO CASE
      CASE "Public"  $ _HMG_FormDebugger.Grid_Vars.CELL( nRow, 2 ); aColor := COLOR_ForestGreen
      CASE "Private" $ _HMG_FormDebugger.Grid_Vars.CELL( nRow, 2 ); aColor := COLOR_Blue4
      CASE "STATIC"  $ _HMG_FormDebugger.Grid_Vars.CELL( nRow, 2 ); aColor := COLOR_OrangeRed
      CASE "Local"   $ _HMG_FormDebugger.Grid_Vars.CELL( nRow, 2 ); aColor := COLOR_Purple
   ENDCASE
RETURN aColor


PROCEDURE AjustControlSize
LOCAL i, aux

   // LABEL CONTROL
      //_HMG_FormDebugger.Label_1.ROW  := GetSplitBoxHEIGHT( "_HMG_FormDebugger" ) + 1
      _HMG_FormDebugger.Label_1.ROW  := Iif( lShowSplitBox == .T., GetSplitBoxHEIGHT( "_HMG_FormDebugger" ), 0 ) + nHEIGHT()*0.33

   // TAB CONTROL
      //_HMG_FormDebugger.Tab_1.ROW    := nHEIGHT()*2 + GetSplitBoxHEIGHT( "_HMG_FormDebugger" )
      _HMG_FormDebugger.Tab_1.ROW    := nHEIGHT()*2 + Iif( lShowSplitBox == .T., GetSplitBoxHEIGHT( "_HMG_FormDebugger" ), 0 )
      _HMG_FormDebugger.Tab_1.COL    := nWIDTH()
      _HMG_FormDebugger.Tab_1.WIDTH  := _HMG_FormDebugger.WIDTH - nWIDTH()*3
      _HMG_FormDebugger.Tab_1.HEIGHT := _HMG_FormDebugger.HEIGHT - _HMG_FormDebugger.Tab_1.ROW - nHEIGHT()*4

   // BUTTON REFRESH
      _HMG_FormDebugger.Button_Refresh.ROW := _HMG_FormDebugger.Tab_1.ROW + TabCtrl_AdjustRect( _HMG_FormDebugger.Tab_1.HANDLE, .F. )[2] - _HMG_FormDebugger.Button_Refresh.HEIGHT - 1 - GetSystemMetrics( SM_CYEDGE )
      _HMG_FormDebugger.Button_Refresh.COL := _HMG_FormDebugger.Tab_1.COL + _HMG_FormDebugger.Tab_1.WIDTH - _HMG_FormDebugger.Button_Refresh.WIDTH - 1 - GetSystemMetrics( SM_CXEDGE )


   // TAB_ABOUT
      _HMG_FormDebugger.Image_1.ROW := (_HMG_FormDebugger.Tab_1.HEIGHT - _HMG_FormDebugger.Image_1.HEIGHT)/2
      _HMG_FormDebugger.Image_1.COL := (_HMG_FormDebugger.Tab_1.WIDTH  - _HMG_FormDebugger.Image_1.WIDTH )/2

   // TAB_CODE
      FOR i := 1 TO Len( HMG_Debugger():GetSourceFiles() )
         AdjustCtrlInTab( aGrid_SourceCode[i][1], "Tab_1", "_HMG_FormDebugger" )
         IF i == 1
            _HMG_FormDebugger.ComboBox_SourceCode.COL   := GetProperty( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "COL")
            _HMG_FormDebugger.ComboBox_SourceCode.ROW   := GetProperty( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "ROW")
            _HMG_FormDebugger.ComboBox_SourceCode.WIDTH := GetProperty( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "WIDTH")
         ENDIF
         aux := _HMG_FormDebugger.ComboBox_SourceCode.ROW + nHEIGHT() * 2.5
         SetProperty( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "ROW", aux )
         aux := GetProperty( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "HEIGHT" ) - nHEIGHT() * 2.5
         SetProperty( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "HEIGHT", aux )
      NEXT

   // TAB_STACK
      AdjustCtrlInTab( "Grid_CallStack", "Tab_1", "_HMG_FormDebugger" )

   // TAB_WATCH
      AdjustCtrlInTab( "Grid_Watch", "Tab_1", "_HMG_FormDebugger" )
      _HMG_FormDebugger.Grid_Watch.HEIGHT   := _HMG_FormDebugger.Grid_Watch.HEIGHT - _HMG_FormDebugger.TextBox_Watch.HEIGHT - nHEIGHT()
      _HMG_FormDebugger.Label_WatchNro.ROW := _HMG_FormDebugger.Grid_Watch.ROW + _HMG_FormDebugger.Grid_Watch.HEIGHT + nHEIGHT()
      _HMG_FormDebugger.Label_WatchNro.COL := _HMG_FormDebugger.Grid_Watch.COL

      _HMG_FormDebugger.Label_WatchType.ROW := _HMG_FormDebugger.Label_WatchNro.ROW
      _HMG_FormDebugger.Label_WatchType.COL := _HMG_FormDebugger.Label_WatchNro.COL  + _HMG_FormDebugger.Label_WatchNro.WIDTH + nWIDTH() / 2

      _HMG_FormDebugger.TextBox_Watch.ROW   := _HMG_FormDebugger.Label_WatchNro.ROW
      _HMG_FormDebugger.TextBox_Watch.COL   := _HMG_FormDebugger.Label_WatchType.COL + _HMG_FormDebugger.Label_WatchType.WIDTH + nWIDTH() / 2
      _HMG_FormDebugger.TextBox_Watch.WIDTH := _HMG_FormDebugger.Grid_Watch.WIDTH - _HMG_FormDebugger.Label_WatchNro.WIDTH  - _HMG_FormDebugger.Label_WatchType.WIDTH - nWIDTH()

   // TAB_CALC
      AdjustCtrlInTab( "Grid_Calc", "Tab_1", "_HMG_FormDebugger" )
      _HMG_FormDebugger.TextBox_Calc.WIDTH := _HMG_FormDebugger.Grid_Calc.WIDTH
      _HMG_FormDebugger.Grid_Calc.HEIGHT   := _HMG_FormDebugger.Grid_Calc.HEIGHT - _HMG_FormDebugger.TextBox_Calc.HEIGHT - _HMG_FormDebugger.Label_Calc.HEIGHT - nHEIGHT()
      _HMG_FormDebugger.Label_Calc.ROW     := _HMG_FormDebugger.Grid_Calc.ROW + _HMG_FormDebugger.Grid_Calc.HEIGHT + nHEIGHT()
      _HMG_FormDebugger.Label_Calc.COL     := _HMG_FormDebugger.Grid_Calc.COL
      _HMG_FormDebugger.TextBox_Calc.ROW   := _HMG_FormDebugger.Label_Calc.ROW + _HMG_FormDebugger.Label_Calc.HEIGHT
      _HMG_FormDebugger.TextBox_Calc.COL   := _HMG_FormDebugger.Label_Calc.COL

   // TAB_VARS
      AdjustCtrlInTab( "Grid_Vars", "Tab_1", "_HMG_FormDebugger" )

   // TAB_AREAS
      AdjustCtrlInTab( "Grid_Areas", "Tab_1", "_HMG_FormDebugger" )
      AdjustCtrlInTab( "Grid_Rec", "Tab_1", "_HMG_FormDebugger" )
      _HMG_FormDebugger.Grid_Areas.HEIGHT := _HMG_FormDebugger.Grid_Areas.HEIGHT / 2 - nHEIGHT() / 2
      _HMG_FormDebugger.Grid_Rec.HEIGHT   := _HMG_FormDebugger.Grid_Rec.HEIGHT   / 2 - nHEIGHT() / 2
      _HMG_FormDebugger.Grid_Rec.ROW      := _HMG_FormDebugger.Grid_Areas.ROW + _HMG_FormDebugger.Grid_Areas.HEIGHT + nHEIGHT()

   // TAB_CONFIG
         AdjustCtrlInTab( "Frame_Config", "Tab_1", "_HMG_FormDebugger" )
         _HMG_FormDebugger.CheckBox_Config1.ROW := _HMG_FormDebugger.Frame_Config.ROW + nHEIGHT() * 1.50
         _HMG_FormDebugger.CheckBox_Config1.COL := _HMG_FormDebugger.Frame_Config.COL + nWIDTH()  * 2
         _HMG_FormDebugger.CheckBox_Config2.ROW := _HMG_FormDebugger.Frame_Config.ROW + nHEIGHT() * 4.00
         _HMG_FormDebugger.CheckBox_Config2.COL := _HMG_FormDebugger.Frame_Config.COL + nWIDTH()  * 2
         _HMG_FormDebugger.CheckBox_Config3.ROW := _HMG_FormDebugger.Frame_Config.ROW + nHEIGHT() * 6.50
         _HMG_FormDebugger.CheckBox_Config3.COL := _HMG_FormDebugger.Frame_Config.COL + nWIDTH()  * 2
         _HMG_FormDebugger.Label_Config.ROW     := _HMG_FormDebugger.Frame_Config.ROW + nHEIGHT() * 9.50
         _HMG_FormDebugger.Label_Config.COL     := _HMG_FormDebugger.Frame_Config.COL + nWIDTH()  * 2
         _HMG_FormDebugger.Spinner_Config.ROW   := _HMG_FormDebugger.Label_Config.ROW
         _HMG_FormDebugger.Spinner_Config.COL   := _HMG_FormDebugger.Label_Config.COL + _HMG_FormDebugger.Label_Config.WIDTH + nWIDTH() / 2
         _HMG_FormDebugger.Button_Config1.ROW   := _HMG_FormDebugger.CheckBox_Config1.ROW
         _HMG_FormDebugger.Button_Config1.COL   := _HMG_FormDebugger.Frame_Config.COL + _HMG_FormDebugger.Frame_Config.WIDTH - _HMG_FormDebugger.Button_Config1.WIDTH - nWIDTH()
         _HMG_FormDebugger.Button_Config2.ROW   := _HMG_FormDebugger.CheckBox_Config2.ROW
         _HMG_FormDebugger.Button_Config2.COL   := _HMG_FormDebugger.Frame_Config.COL + _HMG_FormDebugger.Frame_Config.WIDTH - _HMG_FormDebugger.Button_Config2.WIDTH - nWIDTH()
RETURN


PROCEDURE AdjustCtrlInTab( cGridName, cTabName, cFormName )
LOCAL nRow, nCol, nWidth, nHeight
LOCAL hWndTab      := GetControlHandle( cTabName, cFormName )
LOCAL nTabWIDTH    := GetProperty( cFormName, cTabName, "WIDTH" )
LOCAL nTabHEIGHT   := GetProperty( cFormName, cTabName, "HEIGHT" )
   nCol    := TabCtrl_AdjustRect( hWndTab, .F. )[1] + nWIDTH()
   nRow    := TabCtrl_AdjustRect( hWndTab, .F. )[2] + nHEIGHT()
   nWidth  := TabCtrl_AdjustRect( hWndTab, .F. )[3]*2 + nTabWIDTH  - GetSystemMetrics( SM_CXEDGE ) - nWIDTH() * 2
   nHeight := TabCtrl_AdjustRect( hWndTab, .F. )[4]*2 + nTabHEIGHT - GetSystemMetrics( SM_CYEDGE ) - nHEIGHT() * 3
   _SetControlSizePos( cGridName, cFormName, nRow, nCol, nWidth, nHeight )
RETURN


PROCEDURE UpdateGrids
LOCAL i

   DO CASE

      CASE _HMG_FormDebugger.Tab_1.VALUE == TAB_ABOUT
         _HMG_FormDebugger.Button_Refresh.HIDE

      CASE _HMG_FormDebugger.Tab_1.VALUE == TAB_CODE
         _HMG_FormDebugger.Button_Refresh.HIDE
         nComboBoxValue := _HMG_FormDebugger.ComboBox_SourceCode.VALUE
         FOR i := 1 TO Len( HMG_Debugger():GetSourceFiles() )
            IF nComboBoxValue == i
               DoMethod( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "SHOW" )
            ELSE
               DoMethod( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "HIDE" )
            ENDIF
         NEXT


      CASE _HMG_FormDebugger.Tab_1.VALUE == TAB_STACK
         UpdateGridCallStack()
         _HMG_FormDebugger.Button_Refresh.SHOW

      CASE _HMG_FormDebugger.Tab_1.VALUE == TAB_WATCH
         UpdateGridWatch()
         _HMG_FormDebugger.Button_Refresh.SHOW

      CASE _HMG_FormDebugger.Tab_1.VALUE == TAB_CALC
         _HMG_FormDebugger.Button_Refresh.HIDE
         _HMG_FormDebugger.TextBox_Calc.SETFOCUS

      CASE _HMG_FormDebugger.Tab_1.VALUE == TAB_VARS
         UpdateGridVars()
         _HMG_FormDebugger.Button_Refresh.SHOW

      CASE _HMG_FormDebugger.Tab_1.VALUE == TAB_AREAS
         UpdateGridAreas()
         UpdateGridRec()
         _HMG_FormDebugger.Button_Refresh.SHOW

      CASE _HMG_FormDebugger.Tab_1.VALUE == TAB_CONFIG
         _HMG_FormDebugger.Button_Refresh.HIDE

   ENDCASE

RETURN


PROCEDURE UpdateGridCallStack()
LOCAL i, aProcStack, nValue
   nValue := _HMG_FormDebugger.Grid_CallStack.VALUE
   aProcStack := HMG_Debugger():GetProcStack()
   _HMG_FormDebugger.Grid_CallStack.DisableUpdate
   _HMG_FormDebugger.Grid_CallStack.DeleteAllItems
   FOR i := 1 TO Len( aProcStack )
      _HMG_FormDebugger.Grid_CallStack.AddItem( aProcStack[ i ] )
   NEXT
   _HMG_FormDebugger.Grid_CallStack.EnableUpdate
   _HMG_FormDebugger.Grid_CallStack.SetFocus
   _HMG_FormDebugger.Grid_CallStack.VALUE := nValue
RETURN


PROCEDURE UpdateGridVars()
LOCAL i, aVars, nValue, aBVars
   aRawVars := {}
   aVars := HMG_Debugger():GetVars( @aBVars )
   nValue := _HMG_FormDebugger.Grid_Vars.VALUE
   _HMG_FormDebugger.Grid_Vars.DisableUpdate
   _HMG_FormDebugger.Grid_Vars.DeleteAllItems
   FOR i := 1 TO Len( aVars )
      IF .NOT. "_HMG_" $ aVars[ i ][ 3 ]   // not show internal HMG variables
         _HMG_FormDebugger.Grid_Vars.AddItem( aVars[ i ] )
         AAdd( aRawVars, aBVars[ i ] )
      ENDIF
      DoEvents()
   NEXT
   _HMG_FormDebugger.Grid_Vars.ColumnWIDTH ( 2 ) := GRID_WIDTH_AUTOSIZE
   _HMG_FormDebugger.Grid_Vars.ColumnWIDTH ( 3 ) := GRID_WIDTH_AUTOSIZE
   _HMG_FormDebugger.Grid_Vars.ColumnWIDTH ( 5 ) := GRID_WIDTH_AUTOSIZE
   _HMG_FormDebugger.Grid_Vars.VALUE := nValue
   _HMG_FormDebugger.Grid_Vars.EnableUpdate
//   _HMG_FormDebugger.Grid_Vars.SetFocus
RETURN


PROCEDURE UpdateGridWatch()
LOCAL i, aWatchInfo
   _HMG_FormDebugger.Grid_Watch.DisableUpdate
   _HMG_FormDebugger.Grid_Watch.DeleteAllItems
   FOR i := 1 TO HMG_Debugger():WatchCount()
      aWatchInfo := HMG_Debugger():WatchGetInfo( i )
      hb_AIns( aWatchInfo, 1, Str( i ), .T. )   // insert watch number in the first column of grid
      aWatchInfo[ 6 ] := Iif( aWatchInfo[ 6 ] == ".T.", "Yes", "No")   // lValidExpr
      _HMG_FormDebugger.Grid_Watch.AddItem( aWatchInfo )
   NEXT
   _HMG_FormDebugger.Grid_Watch.EnableUpdate
   _HMG_FormDebugger.Grid_Watch.SetFocus
RETURN


PROCEDURE UpdateGridAreas()
LOCAL i, aAreas := HMG_Debugger():GetAreas()
   _HMG_FormDebugger.Grid_Areas.DisableUpdate
   _HMG_FormDebugger.Grid_Areas.DeleteAllItems
   FOR i := 1 TO Len( aAreas )
      _HMG_FormDebugger.Grid_Areas.AddItem( aAreas[ i ] )
   NEXT
   FOR i := 1 TO _HMG_FormDebugger.Grid_Areas.ColumnCOUNT
      _HMG_FormDebugger.Grid_Areas.ColumnWIDTH ( i ) := GRID_WIDTH_AUTOSIZEHEADER
   NEXT
   _HMG_FormDebugger.Grid_Areas.EnableUpdate
   _HMG_FormDebugger.Grid_Areas.SetFocus
RETURN


PROCEDURE UpdateGridRec()
LOCAL i, aRec, cAlias
   cAlias := _HMG_FormDebugger.Grid_Areas.CELL( _HMG_FormDebugger.Grid_Areas.VALUE, 1 )
   IF "*" $ cAlias
      cAlias := SubStr( cAlias, 2 )
   ENDIF
   aRec := HMG_Debugger():GetRec( cAlias )
   _HMG_FormDebugger.Grid_Rec.DisableUpdate
   _HMG_FormDebugger.Grid_Rec.DeleteAllItems
   FOR i := 1 TO Len( aRec )
      _HMG_FormDebugger.Grid_Rec.AddItem( aRec[ i ] )
   NEXT
   _HMG_FormDebugger.Grid_Rec.ColumnWIDTH( 1 ) := IIF( Len( aRec ) > 0, GRID_WIDTH_AUTOSIZE, GRID_WIDTH_AUTOSIZEHEADER )
   _HMG_FormDebugger.Grid_Rec.ColumnWIDTH( 2 ) := GRID_WIDTH_AUTOSIZEHEADER
   _HMG_FormDebugger.Grid_Rec.ColumnWIDTH( 3 ) := GRID_WIDTH_AUTOSIZEHEADER
   _HMG_FormDebugger.Grid_Rec.ColumnWIDTH( 4 ) := IIF( Len( aRec ) > 0, GRID_WIDTH_AUTOSIZE, GRID_WIDTH_AUTOSIZEHEADER )
   _HMG_FormDebugger.Grid_Rec.EnableUpdate
   _HMG_FormDebugger.Grid_Rec.SetFocus
RETURN


FUNCTION LoadPrg( cGrid_SourceCode, cFileName )
LOCAL i, aLineCode
   aLineCode := HMG_Debugger():LoadSourceFile( cFileName )
   DoMethod( "_HMG_FormDebugger", cGrid_SourceCode, "DisableUpdate" )
   DoMethod( "_HMG_FormDebugger", cGrid_SourceCode, "DeleteAllItems" )
HMG_DebuggerWaitMessage_SetProgressbar( 1, 1, Len( aLineCode ), .F. )
   FOR i := 1 TO Len( aLineCode )
      IF i == 1
         aLineCode [i] := HMG_UTF8RemoveBOM( aLineCode [i] )
      ENDIF
      IF HMG_IsCurrentCodePageUnicode() == .T. .AND. HMG_IsUTF8( aLineCode [i] ) == .F.
         aLineCode [i] := HMG_ANSI_TO_UNICODE( aLineCode [i], NIL )
      ELSEIF HMG_IsCurrentCodePageUnicode() == .F. .AND. HMG_IsUTF8( aLineCode [i] ) == .T.
         aLineCode [i] := hb_UTF8ToStr( aLineCode [i], NIL )
      ENDIF
      DoMethod( "_HMG_FormDebugger", cGrid_SourceCode, "AddItem", { Str( i, 6, 0 ), RTrim( aLineCode[ i ] ) } )
      SetProperty( "_HMG_FormDebugger", cGrid_SourceCode, "ImageIndex", i, 1, -1 )
HMG_DebuggerWaitMessage_SetProgressbar( i )
      DoEvents()
   NEXT
HMG_DebuggerWaitMessage_SetProgressbar( 1, 1, 100, .T. )
HMG_DebuggerWaitMessage( _HMG_DEBUGGER_MSG_ + '( DEFINE PAGE "Source" )' )
   SetProperty( "_HMG_FormDebugger", cGrid_SourceCode, "ColumnWIDTH", 1, GRID_WIDTH_AUTOSIZE )
   SetProperty( "_HMG_FormDebugger", cGrid_SourceCode, "ColumnWIDTH", 2, GRID_WIDTH_AUTOSIZE )
   DoMethod( "_HMG_FormDebugger", cGrid_SourceCode, "EnableUpdate" )
   DoMethod( "_HMG_FormDebugger", cGrid_SourceCode, "SetFocus" )
RETURN Len( aLineCode )



*-----------------------------------------------------------------------*
PROCEDURE UpdateInfo()
*-----------------------------------------------------------------------*
__THREAD STATIC i := 1
LOCAL nProcLevel := HMG_Debugger():aCurrentLineInfo[ 1 ]
LOCAL cFileName  := HMG_Debugger():aCurrentLineInfo[ 2 ]
LOCAL cFuncName  := HMG_Debugger():aCurrentLineInfo[ 3 ]
LOCAL nLineCode  := HMG_Debugger():aCurrentLineInfo[ 4 ]
LOCAL cInfo      := HMG_Debugger():aCurrentLineInfo[ 5 ]
LOCAL lIni := .F.


   _HMG_FormDebugger.Label_1.FONTCOLOR := Iif( Empty( cInfo ), BLACK, RED )
   _HMG_FormDebugger.Label_1.VALUE := hb_ValToExp( HMG_Debugger():aCurrentLineInfo )

   IF nCurrentLineCode == 0
      lIni := .T.
   ENDIF

   aGrid_SourceCode[ i ][ 2 ] := .F.
   RepaintGridRow ( "_HMG_FormDebugger", aGrid_SourceCode[i][1], nCurrentLineCode )
   SetProperty( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "ImageIndex", nCurrentLineCode, 1, -1 )

   i := AScan( HMG_Debugger():GetSourceFiles(), cFileName )
   _HMG_FormDebugger.ComboBox_SourceCode.VALUE := i
   nComboBoxValue := i


   nCurrentLineCode := nLineCode
   ListView_EnsureVisible ( GetProperty( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "HANDLE" ), nCurrentLineCode )

   aGrid_SourceCode[ i ][ 2 ] := .T.
   RepaintGridRow ( "_HMG_FormDebugger", aGrid_SourceCode[i][1], nCurrentLineCode )
   SetProperty( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "ImageIndex", nCurrentLineCode, 1, 0 )

   IF lIni == .T.
      SetProperty( "_HMG_FormDebugger", aGrid_SourceCode[i][1], "VALUE", nCurrentLineCode - 1 )
   ENDIF

   UpdateGrids()

RETURN


**************************************************************************************************


*-----------------------------------------------------------------------*
FUNCTION HMG_ShowEventMonitor()
*-----------------------------------------------------------------------*
__THREAD STATIC nAlphaBlend := 255
__THREAD STATIC lTop_HMG_FormDebugger := .T.
LOCAL i, cFormName


   FOR i := 1 TO Len( aDebuggerForms )
      EnableWindow( aDebuggerForms[ i ] )   // avoid disable FormMonitor for Modal Windows and dialog box
   NEXT


//**************************************************
// RELEASE MEMORY
//**************************************************

   IF HMG_GetLastVirtualKeyUp() == VK_M .AND. HMG_VirtualKeyIsPressed( VK_ALT ) == .T.
      HMG_CleanLastVirtualKeyUp()   // avoid re-entry
      RELEASE MEMORY
   ENDIF


//**************************************************
// SET DEBUGGER MONITOR TRANSPARENCY
//**************************************************

   // When nAlphaBlend is 0, the window is completely transparent. When nAlphaBlend is 255, the window is opaque.

   IF HMG_GetLastVirtualKeyUp() == VK_ADD .AND. HMG_VirtualKeyIsPressed( VK_ALT ) == .T.   // Increment Transparency
      HMG_CleanLastVirtualKeyUp()   // avoid re-entry
      nAlphaBlend := nAlphaBlend - 50
      nAlphaBlend := Iif( nAlphaBlend < 50, 50, nAlphaBlend )
      FOR i := 1 TO Len( aDebuggerForms )
         GetFormNameByHandle( aDebuggerForms[ i ], @cFormName )
         SET WINDOW &cFormName TRANSPARENT TO nAlphaBlend
      NEXT

   ELSEIF HMG_GetLastVirtualKeyUp() == VK_SUBTRACT .AND. HMG_VirtualKeyIsPressed( VK_ALT ) == .T.  // Increment Opacity
      HMG_CleanLastVirtualKeyUp()   // avoid re-entry
      nAlphaBlend := nAlphaBlend + 50
      nAlphaBlend := Iif( nAlphaBlend > 255, 255, nAlphaBlend )
      FOR i := 1 TO Len( aDebuggerForms )
         GetFormNameByHandle( aDebuggerForms[ i ], @cFormName )
         SET WINDOW &cFormName TRANSPARENT TO nAlphaBlend
      NEXT
   ENDIF


//**************************************************
// TOP/BOTTOM MONITOR
//**************************************************

   #define HWND_NOTOPMOST   -2
   #define HWND_TOPMOST     -1
   #define HWND_TOP          0
   #define HWND_BOTTOM       1

   IF HMG_GetLastVirtualKeyUp() == VK_F9 .AND. HMG_VirtualKeyIsPressed( VK_ALT ) == .T.   // Set Top-Bottom Monitor
      HMG_CleanLastVirtualKeyUp()   // avoid re-entry
      SetForegroundWindow( _HMG_FormDebugger.HANDLE )
      lTop_HMG_FormDebugger := HMG_IsWindowStyle ( _HMG_FormDebugger.HANDLE, WS_EX_TOPMOST, .T. )
      lTop_HMG_FormDebugger := .NOT.( lTop_HMG_FormDebugger )
      SetWindowPos( _HMG_FormDebugger.HANDLE, Iif( lTop_HMG_FormDebugger, HWND_TOPMOST, HWND_NOTOPMOST ), 0, 0, 0, 0, hb_bitOR( SWP_NOMOVE, SWP_NOSIZE ) )
   ENDIF


//**************************************************
// ACTIVATE/DEACTIVATE MONITOR DEBUGGER
//**************************************************

   IF HMG_GetLastVirtualKeyUp() == VK_D .AND. HMG_VirtualKeyIsPressed( VK_ALT ) == .T.   // Alt+D
      HMG_CleanLastVirtualKeyUp()   // avoid re-entry
      IF HMG_Debugger():lDeactivate == .F.
         HMG_Debugger():Animate()
         HMG_Debugger():lDeactivate := .T.
         FOR i := 1 TO Len( aDebuggerForms )
            HideWindow( aDebuggerForms[ i ] )
         NEXT
      ELSE
         HMG_Debugger():Pause()
         HMG_Debugger():lDeactivate := .F.
         UpdateInfo()
         FOR i := 1 TO Len( aDebuggerForms )
            ShowWindow( aDebuggerForms[ i ] )
         NEXT
      ENDIF
   ENDIF

RETURN NIL


#if 0
*-------------------------------------------------------------*
PROCEDURE HMG_DebuggerWaitMessage( cMsg, cTitle, lEnabled )
*-------------------------------------------------------------*
__THREAD STATIC nEventIndex := 0
LOCAL lOldMainFirst

   IF .NOT. IsWindowDefined( _HMG_FormDebuggerMessage ) .AND. ValType( cMsg ) == "C"
      lOldMainFirst := HMG_ActivateMainWindowFirst( .F. )
      DEFINE WINDOW _HMG_FormDebuggerMessage;
         AT 0,0;
         WIDTH  500;
         HEIGHT 120;
         TITLE iif( ValType( cTitle ) <> "C", ( _HMG_DEBUGGER_NAME_ + " - " + GetProgramFileName() ), cTitle );
         NOSYSMENU;
         NOSIZE;
         NOMINIMIZE;
         NOMAXIMIZE;
         TOPMOST;
         CHILD

         #define _CY    nHEIGHT()
         #define _CX    nWIDTH()*2
          @ _CY, _CX LABEL Label_1;
                  VALUE  cMsg;
                  WIDTH  _HMG_FormDebuggerMessage.ClientAreaWidth - _CX*2;
                  HEIGHT 30;
                  CENTERALIGN

         @ ( _HMG_FormDebuggerMessage.Label_1.ROW + _HMG_FormDebuggerMessage.Label_1.HEIGHT + 1) , _HMG_FormDebuggerMessage.Label_1.COL ;
                  PROGRESSBAR Progressbar_1  RANGE 0, 100 ;
                  WIDTH _HMG_FormDebuggerMessage.Label_1.WIDTH   HEIGHT 25

         SET PROGRESSBAR Progressbar_1 OF _HMG_FormDebuggerMessage ENABLE MARQUEE

      END WINDOW
      DEFAULT lEnabled TO .F.
      IF ValType( lEnabled ) == "L"
         _HMG_FormDebuggerMessage.ENABLED := lEnabled
      ENDIF
      CENTER WINDOW _HMG_FormDebuggerMessage
      CREATE EVENT CODEBLOCK {|| DoEvents() } STOREINDEX nEventIndex
      ACTIVATE WINDOW DEBUGGER _HMG_FormDebuggerMessage  // Activate Window and Install Hooks without calling the Message Loop
      HMG_ActivateMainWindowFirst( lOldMainFirst )

   ELSEIF IsWindowDefined( _HMG_FormDebuggerMessage ) .AND. ValType( cTitle ) == "C"
         _HMG_FormDebuggerMessage.TITLE := cTitle

   ELSEIF IsWindowDefined( _HMG_FormDebuggerMessage ) .AND. ValType( cMsg ) == "C"
         _HMG_FormDebuggerMessage.Label_1.VALUE := cMsg

   ELSEIF IsWindowDefined( _HMG_FormDebuggerMessage ) .AND. ValType( cMsg ) == "U"
      _HMG_FormDebuggerMessage.RELEASE
      EventRemove( nEventIndex )
      nEventIndex := 0
      DoEvents()

   ELSEIF IsWindowDefined( _HMG_FormDebuggerMessage ) .AND. ValType( lEnabled ) == "L"
         _HMG_FormDebuggerMessage.ENABLED := lEnabled

   ENDIF

   DoEvents()
RETURN


*--------------------------------------------------------------------------------------------*
PROCEDURE HMG_DebuggerWaitMessage_SetProgressbar( nValue, nRangeMin, nRangeMax, lMarquee )
*--------------------------------------------------------------------------------------------*
   IF  IsControlDefined ( Progressbar_1, _HMG_FormDebuggerMessage )

      IF ValType( nRangeMin ) == "N"
         _HMG_FormDebuggerMessage.Progressbar_1.RANGEMIN := nRangeMin
      ENDIF

      IF ValType( nRangeMax ) == "N"
         _HMG_FormDebuggerMessage.Progressbar_1.RANGEMAX := nRangeMax
      ENDIF

      IF ValType( nValue ) == "N"
         _HMG_FormDebuggerMessage.Progressbar_1.VALUE := nValue
      ENDIF

      IF ValType( lMarquee ) == "L"
         IF lMarquee == .T.
            SET PROGRESSBAR Progressbar_1 OF _HMG_FormDebuggerMessage ENABLE MARQUEE
         ELSE
            SET PROGRESSBAR Progressbar_1 OF _HMG_FormDebuggerMessage DISABLE MARQUEE
         ENDIF
      ENDIF

      DoEvents()
   ENDIF
RETURN

#else
*------------------------------------------------------------*
PROCEDURE HMG_DebuggerWaitMessage(); RETURN
PROCEDURE HMG_DebuggerWaitMessage_SetProgressbar(); RETURN
*------------------------------------------------------------*
#endif

