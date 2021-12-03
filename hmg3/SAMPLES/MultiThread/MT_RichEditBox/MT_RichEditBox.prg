
// Multi-Thread version of RichEditBox demo ( without INHERIT PUBLIC vars ), by Dr. Claudio Soto, March 2017

// NOTE: this is a not convential use of thread, because this way create one new "instance" of HMG for each thread

/**
 * This demo is based on the example: RichDemo
 * Copyright 2003-2009 by Janusz Pora <JanuszPora@onet.eu>
 *
 * Adapted and Enhanced for HMG by Dr. Claudio Soto, April 2014
 *
*/

#include "hmg.ch"

Function Main

   IF !hb_mtvm()
      MSGSTOP("There is no support for multi-threading")
      QUIT
   ENDIF
   
   hb_threadStart( @OLD_MAIN(), 1,  50 )
   hb_threadStart( @OLD_MAIN(), 2, 500 )

   hb_threadWaitForAll()

Return


FUNCTION OLD_MAIN( nThread_Nro , nCol )

   nFontNameValue := 0
   nFontSizeValue := 0
   
   cFind         := ""
   cReplace      := ""
   lDown         := .T.
   lMatchCase    := .F.
   lWholeWord    := .F.

   aFontList := {}
   aFontSize         := {'8','9','10','11','12','14','16','18','20','22','24','26','28','36','48','72'}
   aZoomValue        := {'500%','300%','200%','150%','100%','75%','50%','25%'}
   aZoomPercentage   := { 500  , 300  , 200  , 150  , 100  , 75  , 50  , 25  }
   
   aFontColor       := RTF_FONTAUTOCOLOR
   aFontBackColor   := RTF_FONTAUTOBACKCOLOR
   aBackgroundColor := { 230, 230, 0 } // for default WHITE

   cFileName     := ""
   cAuxFileName  := ""
   aViewRect     := {}

   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 800 HEIGHT 600 ;
      TITLE 'RichEditBox Demo: THREAD '+ hb_NtoS( nThread_Nro ) ;
      NOSIZE;   // MAIN ;
      NOMAXIMIZE
      
      DEFINE STATUSBAR
             STATUSITEM "File: " TOOLTIP "Open File"
             STATUSITEM "" WIDTH 250 TOOLTIP "Select Text Range"
      END STATUSBAR
      
      DEFINE SPLITBOX

         DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 23,23 FLAT

            BUTTON Button_New ;
            TOOLTIP 'New File' ;
            PICTURE 'NEW' ;
            ACTION ( IF ( MsgYesNo ( "Clear the current file ?" , "New" ) , (cFileName := "", Form_1.RichEditBox_1.VALUE := ""), NIL ) ,;
                     Form_1.StatusBar.Item(1) := "File: "+cFileName )


            BUTTON Button_Open ;
            TOOLTIP 'Open File' ;
            PICTURE 'OPEN' ;
            ACTION ( cAuxFileName := GetFile ( { {"RTF files", "*.rtf"} }, NIL, GetCurrentFolder() ),;
                     IF ( EMPTY(cAuxFileName),; 
                     NIL,; 
                   ( cFileName := cAuxFileName, Form_1.RichEditBox_1.RTFLoadFile ( cFileName, 4, .F.), Form_1.StatusBar.Item(1) := "File: "+cFileName ) ) )


            BUTTON Button_Close ;
            TOOLTIP 'Close' ;
            PICTURE 'CLOSE' ;
            ACTION IF ( MsgYesNo ( "Close the current file ?" , "Close" ) , (cFileName := "", Form_1.RichEditBox_1.VALUE := ""), NIL )


            BUTTON Button_Save ;
            TOOLTIP 'Save' ;
            PICTURE 'SAVE' ; 
            ACTION ( cAuxFileName := PutFile ( { {"RTF files", "*.rtf"} }, NIL, GetCurrentFolder(), NIL, cFileName, ".rtf" ),;
                     IF ( EMPTY(cAuxFileName),; 
                     NIL,; 
                   ( cFileName := cAuxFileName , Form_1.RichEditBox_1.RTFSaveFile ( cFileName, 4, .F.), Form_1.StatusBar.Item(1) := "File: "+cFileName ) ) );
                SEPARATOR


            BUTTON Button_Print ;
            TOOLTIP 'Print' ;
            PICTURE 'Printer' ;
            ACTION   Print () ;
            SEPARATOR

            BUTTON Button_Info ;
            TOOLTIP 'About RichEditBox Demo' ;
            PICTURE 'Info' ;
            ACTION  InfoProc()

         END TOOLBAR

            COMBOBOX Combo_3 ;
              ITEMS aZoomValue;
              VALUE 5 ;
              HEIGHT 200;
              FONT 'Tahoma' SIZE 9 ;
              WIDTH 80;
              TOOLTIP 'Zoom Ratio';
              ON CHANGE ( Form_1.RichEditBox_1.Zoom := aZoomPercentage [ Form_1.Combo_3.VALUE ] ,;
                          Form_1.RichEditBox_1.SetFocus )


         DEFINE TOOLBAR ToolBar_2 BUTTONSIZE 23,23 FONT 'ARIAL' SIZE 8  FLAT

            BUTTON Button_BackgroundColor ;
            TOOLTIP 'Background Color' ;
            PICTURE 'BackgroundColor' ;
            ACTION ( aBackgroundColor := GetColor (NIL, NIL, .F.), IF (ValType (aBackgroundColor [1]) == "N",( Form_1.RichEditBox_1.BackgroundColor := aBackgroundColor ) , NIL) );
            DROPDOWN;
            SEPARATOR
               DEFINE DROPDOWN MENU BUTTON Button_BackgroundColor
                  ITEM "Set Default Windows Background Color" ACTION Form_1.RichEditBox_1.BackgroundColor := RTF_AUTOBACKGROUNDCOLOR
               END MENU


            BUTTON Button_Copy ;
            TOOLTIP 'Copy' ;
            PICTURE 'copy' ;
            ACTION Form_1.RichEditBox_1.SelCopy ()

            BUTTON Button_Paste ;
            TOOLTIP 'Paste' ;
            PICTURE 'Paste' ;
            ACTION Form_1.RichEditBox_1.SelPaste ()

            BUTTON Button_Cut ;
            TOOLTIP 'Cut' ;
            PICTURE 'cut' ;
            ACTION Form_1.RichEditBox_1.SelCut ();

            BUTTON Button_Clear ;
            TOOLTIP 'Clear' ;
            PICTURE 'Clear' ;
            ACTION Form_1.RichEditBox_1.SelClear ();
                SEPARATOR

            BUTTON Button_Undo ;
            TOOLTIP 'Undo' ;
            PICTURE 'undo' ;
            ACTION Form_1.RichEditBox_1.Undo ();
                DROPDOWN

               DEFINE DROPDOWN MENU BUTTON Button_Undo
                    ITEM 'Clear Undo Buffer' ACTION ( Form_1.RichEditBox_1.ClearUndoBuffer () ,;
                                                      Form_1.Button_Undo.Enabled := .F. ,;
                                                      Form_1.Button_Redo.Enabled := .F. )
               END MENU


            BUTTON Button_Redo ;
            TOOLTIP 'ReDo' ;
            PICTURE 'redo' ;
            ACTION Form_1.RichEditBox_1.Redo () ;
                SEPARATOR


            BUTTON Button_Find ;
            TOOLTIP 'Find' ;
            PICTURE 'find2' ;
            ACTION ( cFind := Form_1.RichEditBox_1.GetSelectText,;
                     FINDTEXTDIALOG ON ACTION FindReplaceOnClickProc() FIND cFind CHECKDOWN lDown CHECKMATCHCASE lMatchCase CHECKWHOLEWORD lWholeWord )

            BUTTON Button_Repl ;
            TOOLTIP 'Replace' ;
            PICTURE 'repeat' ; 
            ACTION ( cFind := Form_1.RichEditBox_1.GetSelectText,;
                     REPLACETEXTDIALOG ON ACTION FindReplaceOnClickProc() FIND cFind REPLACE cReplace CHECKMATCHCASE lMatchCase CHECKWHOLEWORD lWholeWord )

         END TOOLBAR


         GetFontList ( NIL, NIL, DEFAULT_CHARSET, NIL, NIL, NIL, @aFontList )

         COMBOBOX Combo_1 ;
              ITEMS aFontList;
              VALUE 2 ;
              WIDTH 170;
              HEIGHT 200;
              FONT 'Tahoma' SIZE 9 ;
              TOOLTIP 'Font Name';
              ON GOTFOCUS  ( nFontNameValue := Form_1.Combo_1.VALUE ) ;
              ON CHANGE    ( Form_1.RichEditBox_1.FontName := Form_1.Combo_1.ITEM (Form_1.Combo_1.VALUE) ); 
              ON CANCEL IF ( HMG_GetLastVirtualKeyDown() == VK_ESCAPE, ( HMG_CleanLastVirtualKeyDown(), Form_1.Combo_1.VALUE := nFontNameValue ), NIL ) ;
              BREAK


              COMBOBOX Combo_2 ;
              ITEMS aFontSize ;
              VALUE 3 ;
              WIDTH 40;
              TOOLTIP 'Font Size' ;
              ON GOTFOCUS  ( nFontSizeValue := Form_1.Combo_2.VALUE ) ;
              ON CHANGE    ( Form_1.RichEditBox_1.FontSize := VAL (Form_1.Combo_2.ITEM (Form_1.Combo_2.VALUE)) );
              ON CANCEL IF ( HMG_GetLastVirtualKeyDown() == VK_ESCAPE, ( HMG_CleanLastVirtualKeyDown(), Form_1.Combo_2.VALUE := nFontSizeValue ), NIL ) ;


         DEFINE TOOLBAR ToolBar_3 BUTTONSIZE 23,23 SIZE 8  FLAT 

            BUTTON Button_Bold ;
            TOOLTIP 'Bold' ;
            PICTURE 'Bold' ;
            ACTION Form_1.RichEditBox_1.FontBold := Form_1.Button_Bold.VALUE ;
                CHECK

            BUTTON Button_Italic ;
            TOOLTIP 'Italic' ;
            PICTURE 'Italic' ;
            ACTION Form_1.RichEditBox_1.FontItalic := Form_1.Button_Italic.VALUE ;
                CHECK

            BUTTON Button_Underline ;
            TOOLTIP 'Underline' ;
            PICTURE 'under' ;
            ACTION Form_1.RichEditBox_1.FontUnderline := Form_1.Button_Underline.VALUE ;
                CHECK

            BUTTON Button_StrikeOut ;
            TOOLTIP 'StrikeOut' ;
            PICTURE 'strike' ;
            ACTION Form_1.RichEditBox_1.FontStrikeOut := Form_1.Button_StrikeOut.VALUE ;
                CHECK;    
                SEPARATOR

            BUTTON Button_SubScript ;
            TOOLTIP 'SubScript' ;
            PICTURE 'SubScript' ;
            ACTION  (Form_1.RichEditBox_1.FontScript := IF ( Form_1.Button_SubScript.VALUE, RTF_SUBSCRIPT, RTF_NORMALSCRIPT ),; 
                     Form_1.Button_SuperScript.VALUE := .F.);  
                CHECK

            BUTTON Button_SuperScript ;
            TOOLTIP 'SuperScript' ;
            PICTURE 'SuperScript' ;
            ACTION  (Form_1.RichEditBox_1.FontScript := IF ( Form_1.Button_SuperScript.VALUE, RTF_SUPERSCRIPT, RTF_NORMALSCRIPT ),; 
                     Form_1.Button_SubScript.VALUE := .F.); 
                CHECK;
                SEPARATOR

            BUTTON Button_Link ;
            TOOLTIP 'Set Link on Selected Text' ;
            PICTURE 'Link' ;
            ACTION  Form_1.RichEditBox_1.Link := Form_1.Button_Link.VALUE ;
                CHECK;
                SEPARATOR

            BUTTON Button_FontColor ;
            TOOLTIP 'Font Color' ;
            PICTURE 'FontColor'; 
            ACTION  ( aFontColor := GetColor(Form_1.RichEditBox_1.FontColor, NIL, .F.), IF (ValType (aFontColor [1]) == "N",( Form_1.RichEditBox_1.FontColor := aFontColor ) , NIL) );
            DROPDOWN
               DEFINE DROPDOWN MENU BUTTON Button_FontColor
                  ITEM "Set Default Windows Font Color" ACTION Form_1.RichEditBox_1.FontColor := -1
               END MENU


            BUTTON Button_FontBackColor ;
            TOOLTIP 'Font Back Color' ;
            PICTURE 'FontBackColor' ;
            ACTION  ( aFontBackColor := GetColor ( Form_1.RichEditBox_1.FontBackColor, NIL, .F.), IF (ValType (aFontBackColor [1]) == "N",( Form_1.RichEditBox_1.FontBackColor := aFontBackColor ) , NIL) );
            DROPDOWN;
            SEPARATOR
               DEFINE DROPDOWN MENU BUTTON Button_FontBackColor
                  ITEM "Set Default Font Back Color" ACTION Form_1.RichEditBox_1.FontBackColor := -1
               END MENU

            BUTTON Button_Left ;
            TOOLTIP 'Left Text' ;
            PICTURE 'left' ;
            ACTION ( Form_1.RichEditBox_1.ParaAlignment := RTF_LEFT , OnSelectProc() );
                CHECK GROUP

            BUTTON Button_Center ;
            TOOLTIP 'Center Text' ;
            PICTURE 'center' ;
            ACTION ( Form_1.RichEditBox_1.ParaAlignment := RTF_CENTER , OnSelectProc() );
                CHECK GROUP

            BUTTON Button_Right ;
            TOOLTIP 'Right Text' ;
            PICTURE 'Right' ;
            ACTION ( Form_1.RichEditBox_1.ParaAlignment := RTF_RIGHT , OnSelectProc() );
                CHECK GROUP

            BUTTON Button_Justify ;
            TOOLTIP 'Justify Text' ;
            PICTURE 'Justify' ;
            ACTION ( Form_1.RichEditBox_1.ParaAlignment := RTF_JUSTIFY , OnSelectProc() );
                CHECK GROUP;
                SEPARATOR 

            BUTTON Button_Bulleted ;
            TOOLTIP 'Bulleted Paragraphs' ;
            PICTURE 'Number' ;
            ACTION ( Form_1.RichEditBox_1.ParaNumbering := IF ( Form_1.Button_Bulleted.VALUE, RTF_BULLET, RTF_NOBULLETNUMBER ) , OnSelectProc() );
            CHECK


            #define MIN_PARAINDENT   0 // in mm
            BUTTON Button_Offset2 ;
            TOOLTIP 'Offset Out' ;
            PICTURE 'Offset2' ;
            ACTION (Form_1.RichEditBox_1.ParaIndent := Form_1.RichEditBox_1.ParaIndent - 15, Form_1.RichEditBox_1.ParaIndent := IF (Form_1.RichEditBox_1.ParaIndent < MIN_PARAINDENT, MIN_PARAINDENT, Form_1.RichEditBox_1.ParaIndent))


            #define MAX_PARAINDENT   150 // in mm
            BUTTON Button_Offset1 ;
            TOOLTIP 'Offset in' ;
            PICTURE 'Offset1' ;
            ACTION (Form_1.RichEditBox_1.ParaIndent := Form_1.RichEditBox_1.ParaIndent + 15, Form_1.RichEditBox_1.ParaIndent := IF (Form_1.RichEditBox_1.ParaIndent > MAX_PARAINDENT, MAX_PARAINDENT, Form_1.RichEditBox_1.ParaIndent))
            
            BUTTON Button_LineSpacing ;
            TOOLTIP 'Line Spacing' ;
            PICTURE 'ParaLineSpacing';
            ACTION {|| Nil };
                WHOLEDROPDOWN;
                SEPARATOR 

               DEFINE DROPDOWN MENU BUTTON Button_LineSpacing
                  ITEM "1.0 "   ACTION Form_1.RichEditBox_1.ParaLineSpacing := 1.0
                  ITEM "1.5 "   ACTION Form_1.RichEditBox_1.ParaLineSpacing := 1.5
                  ITEM "2.0 "   ACTION Form_1.RichEditBox_1.ParaLineSpacing := 2.0
                  ITEM "2.5 "   ACTION Form_1.RichEditBox_1.ParaLineSpacing := 2.5
                  ITEM "3.0 "   ACTION Form_1.RichEditBox_1.ParaLineSpacing := 3.0
                  SEPARATOR
                  ITEM "Get Paragraph Line Spacing" ACTION MsgInfo ( "Paragraph Line Spacing : " + HB_NTOS ( Form_1.RichEditBox_1.ParaLineSpacing ) )
               END MENU


            BUTTON Button_Help ;
            TOOLTIP 'Help: Rich Edit Shortcut Keys' ;
            PICTURE 'HelpPic' ;
            ACTION  HelpProc()

         END TOOLBAR

      END SPLITBOX


      @ 80,10 RICHEDITBOX RichEditBox_1 ;
         WIDTH 775 ;
         HEIGHT 450 ;
         VALUE '';
         FONT "Consolas" SIZE 12;
         MAXLENGTH -1;
         NOHSCROLL;
         ON CHANGE ( IF (Form_1.RichEditBox_1.CanUndo,  (Form_1.Button_Undo.Enabled := .T.) ,  (Form_1.Button_Undo.Enabled := .F.)) ,;
                     IF (Form_1.RichEditBox_1.CanRedo,  (Form_1.Button_Redo.Enabled := .T.) ,  (Form_1.Button_Redo.Enabled := .F.)) ) ;
         ON SELECT OnSelectProc ();
         ON LINK   OnLinkProc ();
         ON VSCROLL ( Form_1.RichEditBox_1.Refresh )

      aViewRect := Form_1.RichEditBox_1.ViewRect
         aViewRect [1] = aViewRect [1] + 10   // nLeft
         aViewRect [2] = aViewRect [2] + 10   // nTop
         aViewRect [3] = aViewRect [3] - 10   // nRight
         aViewRect [4] = aViewRect [4] - 10   // nBottom
      Form_1.RichEditBox_1.ViewRect := aViewRect


      Form_1.RichEditBox_1.BackGroundColor := aBackgroundColor

      Form_1.RichEditBox_1.SelectAll ()
         Form_1.RichEditBox_1.FontColor     := aFontColor
         Form_1.RichEditBox_1.FontBackColor := aFontBackColor
      Form_1.RichEditBox_1.UnSelectAll ()
      Form_1.RichEditBox_1.CaretPos := 0

//    System.EmptyClipboard

      Form_1.RichEditBox_1.ClearUndoBuffer
      Form_1.Button_Undo.Enabled := .F.
      Form_1.Button_Redo.Enabled := .F.

      
      Form_1.RichEditBox_1.VALUE := "THREAD NRO: " + hb_NtoS( nThread_Nro )  + HB_OSNEWLINE() + HB_OSNEWLINE() +;
                                    "Microsoft said:" + HB_OSNEWLINE() +;
                                    "Unicode is a worldwide character encoding standard that provides a unique number to represent " +;
                                    "each character used in modern computing, including technical symbols and special characters used in publishing. " +;
                                    "Unicode is required by modern standards, such as XML and ECMAScript (JavaScript), and is the official mechanism " +;
                                    "for implementing ISO/IEC 10646 (UCS: Universal Character Set). " +;
                                    "It is supported by many operating systems, all modern browsers, and many other products. " +;
                                    "New Windows applications should use Unicode to avoid the inconsistencies of varied code pages and " +;
                                    "to aid in simplifying localization." + HB_OSNEWLINE() + HB_OSNEWLINE() +;
                                    "Thereby HMG-Unicode is the future in the xBase programming for Windows ..." + HB_OSNEWLINE() +;
                                    "www.hmgforum.com" + HB_OSNEWLINE()

   END WINDOW

   CENTER   WINDOW Form_1
   
   Form_1.COL := nCol

   ACTIVATE WINDOW Form_1

RETURN



**********************************************************
PROCEDURE Print
**********************************************************
LOCAL nLeft, nTop, nRight, nBottom, aSelRange
LOCAL lSuccessVar
LOCAL nRow, nCol, nPag

   SELECT PRINTER DIALOG TO lSuccessVar PREVIEW 

   IF lSuccessVar == .T.

      nLeft   := 20   // Left   page margin in milimeters
      nTop    := 20   // Top    page margin in milimeters
      nRight  := 20   // Right  page margin in milimeters
      nBottom := 20   // Bottom page margin in milimeters
      
      aSelRange := { 0, -1 }   // select all text
      
      nPag := 1
      nRow := OpenPrinterGetPageHeight() - 10   // in milimeters
      nCol := OpenPrinterGetPageWidth() / 2     // in milimeters
      
      PrintPageCodeBlock := { || @ nRow , nCol PRINT "Pag. " + HB_NTOS( nPag++ ) CENTER }

      Form_1.RichEditBox_1.RTFPrint ( aSelRange, nLeft, nTop, nRight, nBottom, PrintPageCodeBlock )

   ENDIF
RETURN



**********************************************************
PROCEDURE FindReplaceOnClickProc
**********************************************************
LOCAL lSelectFindText
LOCAL aPosRange := {0,0}

   IF FindReplaceDlg.RetValue == FRDLG_CANCEL   // User Cancel or Close dialog
      RETURN
   ENDIF
   
   cFind           := FindReplaceDlg.Find
   cReplace        := FindReplaceDlg.Replace
   lDown           := FindReplaceDlg.Down
   lMatchCase      := FindReplaceDlg.MatchCase
   lWholeWord      := FindReplaceDlg.WholeWord
   lSelectFindText := .T.

   DO CASE
      CASE FindReplaceDlg.RetValue == FRDLG_FINDNEXT
           aPosRange := Form_1.RichEditBox_1.FindText ( cFind, lDown, lMatchCase, lWholeWord, lSelectFindText )
      
      CASE FindReplaceDlg.RetValue == FRDLG_REPLACE
           aPosRange := Form_1.RichEditBox_1.ReplaceText ( cFind, cReplace, lMatchCase, lWholeWord, lSelectFindText )
      
      CASE FindReplaceDlg.RetValue == FRDLG_REPLACEALL
           aPosRange := Form_1.RichEditBox_1.ReplaceAllText ( cFind, cReplace, lMatchCase, lWholeWord, lSelectFindText )
   ENDCASE

   IF aPosRange [1] == -1
      MsgInfo ("Can't find the text:" + HB_OSNEWLINE() + cFind)
   ELSE
      MoveDialog ( aPosRange [1] )
   ENDIF

RETURN



**********************************************************
PROCEDURE MoveDialog ( nPos )
**********************************************************
LOCAL CharRowCol := Form_1.RichEditBox_1.GetPosChar (nPos)
#define OFFSET_DLG 30

   IF CharRowCol [1] <> -1 .AND. CharRowCol [2] <> -1
   
      IF ( FindReplaceDlg.HEIGHT + OFFSET_DLG ) < CharRowCol [1]
         FindReplaceDlg.Row := CharRowCol [1] - ( FindReplaceDlg.HEIGHT + OFFSET_DLG )
      ELSEIF FindReplaceDlg.Row < CharRowCol [1] + OFFSET_DLG
         FindReplaceDlg.Row := CharRowCol [1] + OFFSET_DLG
      ENDIF

   ENDIF

RETURN



**********************************************************
PROCEDURE OnSelectProc
**********************************************************
THREAD STATIC flag := .F.
LOCAL nPos

   IF flag == .T.
      RETURN   // avoid re-entry
   ENDIF
   flag := .T.

   Form_1.StatusBar.Item (2) := "Select Text Range :  " + HB_VALTOEXP (Form_1.RichEditBox_1.SelectRange)

   nPos := ASCAN ( aFontList, Form_1.RichEditBox_1.FontName )
   IF nPos > 0
      Form_1.Combo_1.VALUE := nPos
   ENDIF

   nPos := ASCAN ( aFontSize, HB_NTOS (Form_1.RichEditBox_1.FontSize) )
   IF nPos > 0
      Form_1.Combo_2.VALUE := nPos
   ENDIF

   Form_1.Button_Bold.VALUE        := Form_1.RichEditBox_1.FontBold
   Form_1.Button_Italic.VALUE      := Form_1.RichEditBox_1.FontItalic
   Form_1.Button_Underline.VALUE   := Form_1.RichEditBox_1.FontUnderline
   Form_1.Button_StrikeOut.VALUE   := Form_1.RichEditBox_1.FontStrikeOut
   Form_1.Button_SubScript.VALUE   := IF ( Form_1.RichEditBox_1.FontScript == RTF_SUBSCRIPT,   .T., .F. )
   Form_1.Button_SuperScript.VALUE := IF ( Form_1.RichEditBox_1.FontScript == RTF_SUPERSCRIPT, .T., .F. )
   Form_1.Button_Link.VALUE        := Form_1.RichEditBox_1.Link

   Form_1.Button_Bulleted.VALUE       := IF ( Form_1.RichEditBox_1.ParaNumbering == RTF_BULLET, .T., .F. )
   Form_1.RichEditBox_1.ParaOffset := IF ( Form_1.Button_Bulleted.VALUE, 5, 0)

   DO CASE
      CASE Form_1.RichEditBox_1.ParaAlignment == RTF_LEFT
           Form_1.Button_Left.VALUE := .T.
      CASE Form_1.RichEditBox_1.ParaAlignment == RTF_CENTER
           Form_1.Button_Center.VALUE := .T.
      CASE Form_1.RichEditBox_1.ParaAlignment == RTF_RIGHT
           Form_1.Button_Right.VALUE := .T.
      CASE Form_1.RichEditBox_1.ParaAlignment == RTF_JUSTIFY
           Form_1.Button_Justify.VALUE := .T.
   END CASE

   flag := .F.
RETURN



*****************************************************************
PROCEDURE OnLinkProc
*****************************************************************
   cLink := ALLTRIM ( ThisRichEditBox.GetClickLinkText )

   IF  HMG_LOWER( HB_USUBSTR (cLink,1,7) ) == "http://" .OR. HMG_LOWER( HB_USUBSTR (cLink,1,4) ) == "www." 
       ShellExecute ( NIL, "Open", cLink, NIL, NIL, SW_SHOWNORMAL )

   ELSEIF "@" $ cLink .AND. "." $ cLink .AND. .NOT.( " " $ cLink )
       ShellExecute ( NIL, "Open", "rundll32.exe", "url.dll,FileProtocolHandler mailto:" + cLink, NIL, SW_SHOWNORMAL )

   ELSE
       MsgInfo ( cLink, "On Link" )
   ENDIF

RETURN



*****************************************************************
PROCEDURE HelpProc
*****************************************************************

   Form_1.Button_Help.ENABLED := .F.

   DEFINE WINDOW Form_2 ;
      AT 0,0 ;
      WIDTH 635 HEIGHT 450 ;
      TITLE 'Help: Rich Edit Shortcut Keys' ;
      NOSIZE;
      NOMAXIMIZE;
      ON INIT     ( Form_2.RichEditBox_2.RTFLoadFile ("HelpRTF", .F., 4) );
      ON RELEASE  ( Form_1.Button_Help.ENABLED := .T. );

      @ 10,10 RICHEDITBOX RichEditBox_2 ;
         WIDTH 610 ;
         HEIGHT 400 ;
         MAXLENGTH -1;
         NOHSCROLL;
         READONLY;
         BACKCOLOR YELLOW
         
   END WINDOW

   CENTER   WINDOW Form_2
   ACTIVATE WINDOW Form_2

RETURN



*****************************************************************
PROCEDURE InfoProc
*****************************************************************

   DEFINE WINDOW Form_3 ;
      AT 0,0 ;
      WIDTH 400 HEIGHT 300 ;
      MODAL;
      NOCAPTION;
      NOSIZE

      @ 10,10 RICHEDITBOX RichEditBox_3 ;
         WIDTH  Form_3.ClientAreaWidth  - 20 ;
         HEIGHT Form_3.ClientAreaHeight - 20 ;
         MAXLENGTH -1;
         NOHSCROLL;
         READONLY;
         BACKCOLOR NAVY;
         ON LINK IF ( HMG_UPPER( ALLTRIM (ThisRichEditBox.GetClickLinkText) ) == HMG_UPPER ("Click Here"), Form_3.Release, OnLinkProc ( ThisRichEditBox.GetClickLinkText ) )

         ON KEY  ESCAPE  ACTION Form_3.Release

         CreateTextRTF ()

   END WINDOW

   CENTER   WINDOW Form_3
   ACTIVATE WINDOW Form_3

RETURN


**************************
PROCEDURE CreateTextRTF
**************************

   Form_3.RichEditBox_3.VALUE := " " + HB_OSNEWLINE()

   Form_3.RichEditBox_3.AddTextAndSelect ( -1 ) := "RichEditBox Demo"
      Form_3.RichEditBox_3.FontName      := "Comic Sans MS"
      Form_3.RichEditBox_3.FontSize      := 24
      Form_3.RichEditBox_3.FontBold      := .T.
      Form_3.RichEditBox_3.FontItalic    := .T.
      Form_3.RichEditBox_3.FontColor     := RED

   Form_3.RichEditBox_3.AddTextAndSelect ( -1 ) := HB_OSNEWLINE() + "by Dr. Claudio Soto" + HB_OSNEWLINE()
      Form_3.RichEditBox_3.FontName      := "Book Antiqua"
      Form_3.RichEditBox_3.FontSize      := 16
      Form_3.RichEditBox_3.FontBold      := .T.
      Form_3.RichEditBox_3.FontItalic    := .F.
      Form_3.RichEditBox_3.FontColor     := SILVER
      
   Form_3.RichEditBox_3.AddTextAndSelect ( -1 ) := "srvet@adinet.com.uy "
      Form_3.RichEditBox_3.FontName      := "Arial"
      Form_3.RichEditBox_3.FontSize      := 12
      Form_3.RichEditBox_3.FontBold      := .T.
      Form_3.RichEditBox_3.FontItalic    := .T.
      Form_3.RichEditBox_3.FontColor     := YELLOW
      Form_3.RichEditBox_3.Link          := .T.
      Form_3.RichEditBox_3.AddText (-1)  := HB_OSNEWLINE()

   Form_3.RichEditBox_3.AddTextAndSelect ( -1 ) := "http://srvet.blogspot.com" + HB_OSNEWLINE()
      Form_3.RichEditBox_3.FontName      := "Arial"
      Form_3.RichEditBox_3.FontSize      := 12
      Form_3.RichEditBox_3.FontBold      := .T.
      Form_3.RichEditBox_3.FontItalic    := .T.
      Form_3.RichEditBox_3.FontColor     := YELLOW

      Form_3.RichEditBox_3.AddTextAndSelect ( -1 ) := HB_OSNEWLINE() + "Press ESC or "
      Form_3.RichEditBox_3.FontName      := "Book Antiqua"
      Form_3.RichEditBox_3.FontSize      := 8
      Form_3.RichEditBox_3.FontBold      := .T.
      Form_3.RichEditBox_3.FontItalic    := .F.
      Form_3.RichEditBox_3.FontColor     := { 168, 168, 0}
      Form_3.RichEditBox_3.AddTextAndSelect ( -1 ) := " Click Here "
      Form_3.RichEditBox_3.Link          := .T.
      Form_3.RichEditBox_3.AddTextAndSelect ( -1 ) := " for Close this Window" + HB_OSNEWLINE()

   Form_3.RichEditBox_3.AddTextAndSelect ( -1 ) := " "

   Form_3.RichEditBox_3.SelectAll ()
      Form_3.RichEditBox_3.ParaAlignment   := RTF_CENTER
      Form_3.RichEditBox_3.ParaLineSpacing := 1.5
   Form_3.RichEditBox_3.UnSelectAll ()

RETURN



