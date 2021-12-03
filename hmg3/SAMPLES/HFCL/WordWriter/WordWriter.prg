/**
 *
 * WordWriter
 *
 * Based on the Rich Edit demo.
 *
 * Copyright 2003-2009 by Janusz Pora <JanuszPora@onet.eu>
 *
 * Adapted and enhanced for HMG by Dr. Claudio Soto, April 2014
 *
 * Enhanced & skinned for HMG By Eduardo L. Azar, December 2014
 *
 * Enhanced for HMG by Kevin Carmody, May 2016
 *
*/
 
//***************************************************************************

#include "hmg.ch"
#include "hfcl.ch"

#define MIN_PARAINDENT   0 // in mm
#define MAX_PARAINDENT   150 // in mm
#define OFFSET_DLG       30

#define KEYNAV_OFF       0
#define KEYNAV_QUAC      1
#define KEYNAV_HOME      2
#define KEYNAV_VIEW      3

//***************************************************************************

MEMVAR _HMG_SYSDATA

STATIC cTitle           := 'WordWriter'
STATIC cVersion         := '2.5'
STATIC cCopyright       := 'Copyright © 2003–2009 Janusz Pora' // U+00A9 COPYRIGHT SIGN / U+2013 EN DASH
STATIC cByline2         := 'Adapted and enhanced by Dr. Claudio Soto, April 2014'
STATIC cByline3         := 'Enhanced and skinned by Eduardo L. Azar, December 2014' 
STATIC cByline4         := 'Enhanced by Kevin Carmody, May 2016'
STATIC cInfoAddr        := 'http://sites.google.com/site/hmgweb/'
STATIC cRegBase         := 'HKEY_CURRENT_USER\Software\WordWriter\'

STATIC nMainRow         := 0
STATIC nMainCol         := 0
STATIC nMainWidth       := 800
STATIC nMainHeight      := 600
STATIC lMainMax         := .N.
STATIC nKeyNav          := KEYNAV_OFF

STATIC nShortRow        := 160
STATIC nShortCol        := 40
STATIC nShortWidth      := 635
STATIC nShortHeight     := 450
STATIC lShortMax        := .N.

STATIC aRecentBases     := {'', '', '', '', '', '', '', '', '', ''}
STATIC aRecentNames     := {'', '', '', '', '', '', '', '', '', ''}

STATIC cFind            := ''
STATIC cReplace         := ''
STATIC lDown            := .Y.
STATIC lMatchCase       := .N.
STATIC lWholeWord       := .N.

STATIC aZoomLabel       := {'500%','300%','200%','150%','100%','75%','50%','25%'}
STATIC aZoomPercentage  := { 500  , 300  , 200  , 150  , 100  , 75  , 50  , 25  }
STATIC nZoomValue       := 100

STATIC aFontList        := {}
STATIC cFontName        := 'Arial'

STATIC aFontSizeLabel   := {'8','9','10','11','12','14','16','18','20','22','24','26','28','36','48','72'}
STATIC aFontSizeValue   := { 8 , 9 , 10 , 11 , 12 , 14 , 16 , 18 , 20 , 22 , 24 , 26 , 28 , 36 , 48 , 72 }
STATIC nFontSize        := 12

STATIC aFontForeColor   := BLACK
STATIC aFontBackColor   := WHITE
STATIC aDocBackColor    := WHITE

STATIC nPrintLeft       := 0
STATIC nPrintTop        := 0
STATIC nPrintRight      := 0
STATIC nPrintBottom     := 0
STATIC nPrintRow        := 10   
STATIC nPrintCol        := 10
STATIC lPrintHead       := .N.
STATIC lPrintNumHead    := .Y.
STATIC cPrintPreHead    := 'Page'
STATIC cPrintPostHead   := ''

STATIC aScriptLabel     := {'Normal', 'Subscript', 'Superscript'}
STATIC aScriptValue     := {RTF_NORMALSCRIPT, RTF_SUBSCRIPT, RTF_SUPERSCRIPT}
STATIC aAlignLabel      := {'Left', 'Center', 'Right', 'Justify'}
STATIC aAlignValue      := {RTF_LEFT, RTF_CENTER, RTF_RIGHT, RTF_JUSTIFY}
STATIC aSpaceLabel      := {'1.0', '1.5', '2.0', '2.5', '3.0'}
STATIC aSpaceValue      := { 1.0,   1.5,   2.0,   2.5,   3.0 }
STATIC nSpaceValue      := 1.0

STATIC aNumFormatLabel  := { ;
  'None'                    , ; // 1
  'Bullets'                 , ; // 2
  'Arabic numerals'         , ; // 3
  'Lowercase letters'       , ; // 4
  'Uppercase letters'       , ; // 5
  'Lowercase Roman numerals', ; // 6
  'Uppercase Roman numerals'  } // 7
STATIC aNumFormatMark   := { ;
  {''   , .N.}, ; // 1
  {'•', .N.}, ; // 2  U+2022 BULLET
  {'1'  , .Y.}, ; // 3
  {'a'  , .Y.}, ; // 4
  {'A'  , .Y.}, ; // 5
  {'i'  , .Y.}, ; // 6
  {'I'  , .Y.}   } // 7
STATIC aNumFormatRef    := { ;
  RTF_NOBULLETNUMBER      , ; // 1
  RTF_BULLET              , ; // 2
  RTF_ARABICNUMBER        , ; // 3
  RTF_LOWERCASELETTER     , ; // 4
  RTF_UPPERCASELETTER     , ; // 5
  RTF_LOWERCASEROMANNUMBER, ; // 6
  RTF_UPPERCASEROMANNUMBER  } // 7
STATIC nNumFormat       := 1

STATIC aNumStyleLabel   := { ;
  'No punctuation'   , ; // 1
  'Period'           , ; // 2
  'Right parenthesis', ; // 3
  'Two parentheses ' , ; // 4
  'Hidden number'      } // 5
STATIC aNumStyleMark    := { ;
  {'' , .Y., '' }, ; // 1
  {'' , .Y., '.'}, ; // 2
  {'' , .Y., ')'}, ; // 3
  {'(', .Y., ')'}, ; // 4
  {'' , .N., '' }  } // 5
STATIC aNumStyleRef     := { ;
  RTF_NONE  , ; // 1
  RTF_PERIOD, ; // 2
  RTF_PAREN , ; // 3
  RTF_PARENS, ; // 4
  RTF_NONUMBER} // 5
STATIC nNumStyle        := 1
STATIC nNumStart        := 1

STATIC cFileName        := ''
STATIC cFileFolder      := ''
STATIC cFileBase        := ''
STATIC cFileExt         := ''

STATIC lWordWrap        := .Y.
STATIC lStatusBar       := .Y.
STATIC lModified        := .N.

STATIC aReadFilter      := { ;
   {'Rich Text Format (*.rtf)', '*.rtf'}, ;
   {'Text Documents (*.txt)'  , '*.txt'}, ;
   {'All Documents (*.*)'     , '*.*'  }  }
STATIC nReadFilter      := 1
STATIC aWriteFilter     := { ;
   {'Rich Text Format (*.rtf)'                 , '*.rtf'}, ;
   {'ANSI Text Document (*.txt)'               , '*.txt'}, ;
   {'Unicode Text Document (*.txt)'            , '*.txt'}, ;
   {'Unicode Text Document, Big Endian (*.txt)', '*.txt'}, ;
   {'UTF-8 Text Document (*.txt)'              , '*.txt'}  }
STATIC nWriteFilter     := 1

//***************************************************************************

PROCEDURE Main(cInitFile)

DEFINE WINDOW wMain ;
  AT nMainRow, nMainCol ;
  WIDTH nMainWidth HEIGHT nMainHeight ;
  TITLE 'Document • ' + cTitle ; // U+2022 BULLET
  ICON 'MainIcon' ;
  ON INIT Refresh() ;
  ON SIZE MainSize(.N.) ;
  ON MAXIMIZE MainSize(.Y.) ;
  ON RELEASE MainExit(.N.) ;
  MAIN
  
  DEFINE STATUSBAR
    STATUSITEM ''          TOOLTIP 'Current file'
    STATUSITEM '' WIDTH 25 TOOLTIP 'Document modified'
    STATUSITEM '' WIDTH 40 TOOLTIP 'Caps lock on'
    STATUSITEM '' WIDTH 40 TOOLTIP 'Num lock on'
    STATUSITEM '' WIDTH 40 TOOLTIP 'Insert mode on'
    STATUSITEM '' WIDTH 25
  END STATUSBAR

  DEFINE TIMER tiStatus INTERVAL 200 ;
    ACTION {||
      wMain.STATUSBAR.ITEM(2) := IF(lModified         , '✽', '') // U+273D HEAVY TEARDROP-SPOKED ASTERISK
      wMain.STATUSBAR.ITEM(3) := IF(ISCAPSLOCKACTIVE(), 'CAP', '')
      wMain.STATUSBAR.ITEM(4) := IF(ISNUMLOCKACTIVE() , 'NUM', '')
      wMain.STATUSBAR.ITEM(5) := IF(ISINSERTACTIVE()  , 'INS', '')
      RETURN NIL
      }
  
  ON KEY CONTROL+N        ACTION NewFile()
  ON KEY CONTROL+O        ACTION OpenFile()
  ON KEY CONTROL+S        ACTION SaveFile()
  ON KEY CONTROL+P        ACTION Print(.N.)
  ON KEY CONTROL+B        ACTION Bold()
  ON KEY CONTROL+I        ACTION Italic()
  ON KEY CONTROL+U        ACTION Underline()
  ON KEY CONTROL+W        ACTION PasteUnformatted()
  ON KEY CONTROL+F        ACTION FindText()
  ON KEY CONTROL+H        ACTION ReplaceText()
  ON KEY CONTROL+ADD      ACTION ZoomIn()
  ON KEY CONTROL+SUBTRACT ACTION ZoomOut()
  ON KEY F1               ACTION Shortcuts()

  ON KEY ALT+A      ACTION MainKey('A')
  ON KEY ALT+B      ACTION MainKey('B')
  ON KEY ALT+C      ACTION MainKey('C')
  ON KEY ALT+D      ACTION MainKey('D')
  ON KEY ALT+E      ACTION MainKey('E')
  ON KEY ALT+F      ACTION MainKey('F')
  ON KEY ALT+G      ACTION MainKey('G')
  ON KEY ALT+H      ACTION MainKey('H')
  ON KEY ALT+I      ACTION MainKey('I')
  ON KEY ALT+J      ACTION MainKey('J')
  ON KEY ALT+K      ACTION MainKey('K')
  ON KEY ALT+L      ACTION MainKey('L')
  ON KEY ALT+M      ACTION MainKey('M')
  ON KEY ALT+N      ACTION MainKey('N')
  ON KEY ALT+O      ACTION MainKey('O')
  ON KEY ALT+P      ACTION MainKey('P')
  ON KEY ALT+Q      ACTION MainKey('Q')
  ON KEY ALT+R      ACTION MainKey('R')
  ON KEY ALT+S      ACTION MainKey('S')
  ON KEY ALT+T      ACTION MainKey('T')
  ON KEY ALT+U      ACTION MainKey('U')
  ON KEY ALT+V      ACTION MainKey('V')
  ON KEY ALT+W      ACTION MainKey('W')
  ON KEY ALT+X      ACTION MainKey('X')
  ON KEY ALT+Y      ACTION MainKey('Y')
  ON KEY ALT+Z      ACTION MainKey('Z')
  ON KEY ALT+0      ACTION MainKey('0')
  ON KEY ALT+1      ACTION MainKey('1')
  ON KEY ALT+2      ACTION MainKey('2')
  ON KEY ALT+3      ACTION MainKey('3')
  ON KEY ALT+4      ACTION MainKey('4')
  ON KEY ALT+5      ACTION MainKey('5')
  ON KEY ALT+6      ACTION MainKey('6')
  ON KEY ALT+7      ACTION MainKey('7')
  ON KEY ALT+8      ACTION MainKey('8')
  ON KEY ALT+9      ACTION MainKey('9')
  ON KEY ESCAPE     ACTION MainKey('-')

  DEFINE CONTEXT MENU  

     ITEM 'Copy'              IMAGE 'CopyMin'          ACTION Copy()
     ITEM 'Paste'             IMAGE 'PasteMin'         ACTION Paste()
     SEPARATOR
     ITEM 'Bold'              IMAGE 'BoldMin'          NAME miBold          CHECKED ACTION Bold()
     ITEM 'Italic'            IMAGE 'ItalicsMin'       NAME miItalic        CHECKED ACTION Italic()
     ITEM 'Underline'         IMAGE 'UnderlineMin'     NAME miUnderline     CHECKED ACTION Underline()
     ITEM 'Strikethrough'     IMAGE 'StrikethroughMin' NAME miStrikethrough CHECKED ACTION Strikethrough()
     ITEM 'Subscript'         IMAGE 'SubscriptMin'     NAME miSubscript     CHECKED ACTION Subscript()
     ITEM 'Superscript'       IMAGE 'SuperscriptMin'   NAME miSuperscript   CHECKED ACTION Superscript()
     SEPARATOR
     ITEM 'Left alignment'    IMAGE 'AlignLeftMin'     NAME miAlignLeft     CHECKED ACTION AlignLeft()
     ITEM 'Center alignment'  IMAGE 'AlignCenterMin'   NAME miAlignCenter   CHECKED ACTION AlignCenter()
     ITEM 'Right alignment'   IMAGE 'AlignRightMin'    NAME miAlignRight    CHECKED ACTION AlignRight()
     ITEM 'Justify alignment' IMAGE 'AlignJustifyMin'  NAME miAlignJustify  CHECKED ACTION AlignJustify()

  END MENU

  // Quick access

  @   8,  11 IMAGE imSave ;
             PICTURE 'SaveMain' ;
             ACTION SaveFile() ;
             TOOLTIP 'Save the active document (Ctrl-S)'

  @  24,  11 LABEL laSave ;
             VALUE 'S' ;
             WIDTH 16 HEIGHT 16 CENTERALIGN ;
             BACKCOLOR WHITE BORDER INVISIBLE

  @   8,  31 IMAGE imNew ;
             PICTURE 'NewMain' ;
             ACTION NewFile() ;
             TOOLTIP 'Create a new document (Ctrl-N)'

  @  24,  31 LABEL laNew ;
             VALUE 'N' ;
             WIDTH 16 HEIGHT 16 CENTERALIGN ;
             BACKCOLOR WHITE BORDER INVISIBLE

  @   8,  51 IMAGE imOpen ;
             PICTURE 'OpenMain' ;
             ACTION OpenFile() ;
             TOOLTIP 'Open an existing document (Ctrl-O)'

  @  24,  51 LABEL laOpen ;
             VALUE 'O' ;
             WIDTH 16 HEIGHT 16 CENTERALIGN ;
             BACKCOLOR WHITE BORDER INVISIBLE

  @   8,  71 IMAGE imPrint ;
             PICTURE 'PrintMain' ;
             ACTION Print(.N.) ;  
             TOOLTIP 'Print the document (Ctrl-P)'

  @  24,  71 LABEL laPrint ;
             VALUE 'P' ;
             WIDTH 16 HEIGHT 16 CENTERALIGN ;
             BACKCOLOR WHITE BORDER INVISIBLE

  @   8,  91 IMAGE imShortcuts ;
             PICTURE 'Shortcuts' ;
             ACTION Shortcuts() ;  
             TOOLTIP 'Keyboard shortcuts (F1)'

  @  24,  91 LABEL laShortcuts ;
             VALUE 'K' ;
             WIDTH 16 HEIGHT 16 CENTERALIGN ;
             BACKCOLOR WHITE BORDER INVISIBLE

  // Tab labels

  @  47,  21 LABEL laFile ;
             VALUE 'F' ;
             WIDTH 16 HEIGHT 16 CENTERALIGN ;
             BACKCOLOR WHITE BORDER INVISIBLE

  @  47,  66 LABEL laHome ;
             VALUE 'H' ;
             WIDTH 16 HEIGHT 16 CENTERALIGN ;
             BACKCOLOR WHITE BORDER INVISIBLE

  @  47, 111 LABEL laView ;
             VALUE 'V' ;
             WIDTH 16 HEIGHT 16 CENTERALIGN ;
             BACKCOLOR WHITE BORDER INVISIBLE

  DEFINE TAB taTop AT 30,  0 WIDTH wMain.WIDTH HEIGHT 115 ;
    ON CHANGE MainTabChange()

    PAGE 'File ▼' // U+25BC BLACK DOWN POINTING TRIANGLE

    END PAGE

    PAGE 'Home'

      // Clipboard frame

      @  92,   8 LABEL laClipboard ;
                 VALUE 'Clipboard' ;
                 WIDTH 107 CENTERALIGN ;
                 TRANSPARENT 

      @  32,  11 IMAGE imPaste ;
                 PICTURE 'Paste' ;
                 ACTION Paste() ;
                 TOOLTIP 'Paste (Ctrl-V)'

      @  14,  27 LABEL laPaste ;
                 VALUE 'P' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  32,  62 IMAGE imCut ;
                 PICTURE 'Cut' ;
                 ACTION Cut() ;
                 TOOLTIP 'Cut (Ctrl-X)'

      @  14,  66 LABEL laCut ;
                 VALUE 'X' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  32,  88 IMAGE imCopy ;
                 PICTURE 'Copy' ;
                 ACTION Copy() ;
                 TOOLTIP 'Copy (Ctrl-C)'

      @  14,  92 LABEL laCopy ;
                 VALUE 'C' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57,  62 IMAGE imDelete ;
                 PICTURE 'Delete' ;
                 ACTION Deleter() ;
                 TOOLTIP 'Delete (Delete key)'

      @  81,  66 LABEL laDelete ;
                 VALUE 'D' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57,  88 IMAGE imPasteUnform ;
                 PICTURE 'PasteUnform' ;
                 ACTION PasteUnformatted() ;
                 TOOLTIP 'Paste text without formatting (Ctrl-W)'

      @  81,  92 LABEL laPasteUnform ;
                 VALUE 'W' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  29, 116 LABEL laClipboardLine ;
                 WIDTH 1 HEIGHT 80 BORDER

      // Font frame
        
      @  92, 120 LABEL laFont ;
                 VALUE 'Font' ;
                 WIDTH 179 CENTERALIGN ;
                 TRANSPARENT 

      @  33, 123 COMBOBOX coFontName ;
                 ITEMS aFontList;
                 VALUE 1 ;
                 WIDTH 131 HEIGHT 100 ;
                 FONT 'Calibri' SIZE 9 BOLD ;
                 TOOLTIP 'Change the font name' ;
                 ON CHANGE (wMain.ebDoc.FONTNAME := (cFontName := wMain.coFontName.ITEM(wMain.coFontName.VALUE)), ;
                            wMain.ebDoc.SETFOCUS()) ;
                 ON CANCEL (wMain.ebDoc.SETFOCUS())
            
      @  14, 181 LABEL laFontName ;
                 VALUE 'M' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  33, 257 COMBOBOX coFontSize ;
                 ITEMS aFontSizeLabel ;
                 VALUE 3 ;
                 WIDTH 40 HEIGHT 100;
                 FONT 'Calibri' SIZE 9 BOLD ;
                 TOOLTIP 'Change the font size' ;
                 ON CHANGE (wMain.ebDoc.FONTSIZE := (nFontSize := VAL(wMain.coFontSize.ITEM(wMain.coFontSize.VALUE))), ;
                            wMain.ebDoc.SETFOCUS()) ;
                 ON CANCEL (wMain.ebDoc.SETFOCUS())

      @  14, 269 LABEL laFontSize ;
                 VALUE 'M' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57, 123 IMAGE imBold ;
                 PICTURE 'BoldOff' ;
                 ACTION Bold() ;
                 TOOLTIP 'Bold (Ctrl-B)'
    
      @  81, 127 LABEL laBold ;
                 VALUE 'B' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57, 148 IMAGE imItalic ;
                 PICTURE 'ItalicsOff' ;
                 ACTION Italic() ;
                 TOOLTIP 'Italic (Ctrl-I)'

      @  81, 152 LABEL laItalic ;
                 VALUE 'I' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57, 173 IMAGE imUnderline ;
                 PICTURE 'UnderlineOff' ;
                 ACTION Underline() ;
                 TOOLTIP 'Underline (Ctrl-U)'
    
      @  81, 173 LABEL laUnderline ;
                 VALUE 'U' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57, 198 IMAGE imStrikethrough ;
                 PICTURE 'StrikethroughOff' ;
                 ACTION Strikethrough() ;
                 TOOLTIP 'Strikethrough'

      @  81, 213 LABEL laStrikethrough ;
                 VALUE 'S' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57, 229 IMAGE imSubscript ;
                 PICTURE 'SubscriptOff' ;
                 ACTION Subscript() ;  
                 TOOLTIP 'Subscript'
    
      @  81, 233 LABEL laSubscript ;
                 VALUE '2' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57, 254 IMAGE imSuperscript ;
                 PICTURE 'SuperscriptOff' ;
                 ACTION Superscript() ; 
                 TOOLTIP 'Superscript'

      @  81, 252 LABEL laSuperscript ;
                 VALUE '3' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57, 285 IMAGE imFontOptions ;
                 PICTURE 'FontOptions' ;
                 ACTION  Fontformat() ; 
                 TOOLTIP 'Font options'
        
      @  81, 285 LABEL laFontOptions ;
                 VALUE 'M' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  29, 303 LABEL laFontLine ;
                 WIDTH 1 HEIGHT 80 BORDER

      // Paragraph frame

      @  92, 307 LABEL laParagraph ;
                 VALUE 'Paragraph' ;
                 WIDTH 147 CENTERALIGN ;
                 TRANSPARENT 

      @  32, 310 IMAGE imListApply ;
                 PICTURE 'ListApply' ;
                 ACTION ListApply() ; 
                 TOOLTIP ListLabel()
        
      @  14, 314 LABEL laListApply ;
                 VALUE 'A' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  32, 333 IMAGE imListSet ;
                 PICTURE 'ListSet' ;
                 ACTION ListFormat() ; 
                 TOOLTIP 'Select list type'
        
      @  14, 331 LABEL laListSet ;
                 VALUE 'O' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  32, 352 IMAGE imIndentLeft ;
                 PICTURE 'IndentLeft' ;
                 ACTION IndentLeft() ;
                 TOOLTIP 'Decrease indent'

      @  14, 353 LABEL laIndentLeft ;
                 VALUE 'T' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  32, 375 IMAGE imIndentOpt ;
                 PICTURE 'IndentOpt' ;
                 ACTION IndentOffset() ;  
                 TOOLTIP 'Indent options'

      @  14, 373 LABEL laIndentOpt ;
                 VALUE 'G' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  32, 388 IMAGE imIndentRight ;
                 PICTURE 'IndentRight' ;
                 ACTION IndentRight() ;
                 TOOLTIP 'Increase indent'

      @  14, 393 LABEL laIndentRight ;
                 VALUE 'V' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  32, 417 IMAGE imLineSpaceApply ;
                 PICTURE 'LineSpaceApply' ;
                 ACTION LineSpaceApply() ;  
                 TOOLTIP E"Apply line spacing\nLine spacing: " + HB_NTOS(nSpaceValue)

      @  14, 421 LABEL laLineSpaceApply ;
                 VALUE 'Q' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  32, 440 IMAGE imLineSpaceSet ;
                 PICTURE 'LineSpaceSet' ;
                 ACTION LineSpace() ;  
                 TOOLTIP 'Select line spacing'
        
      @  14, 438 LABEL laLineSpaceSet ;
                 VALUE 'N' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57, 310 IMAGE imAlignLeft ;
                 PICTURE 'AlignLeftOff' ;
                 ACTION AlignLeft() ;
                 TOOLTIP 'Align text to left'

      @  81, 315 LABEL laAlignLeft ;
                 VALUE 'L' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57, 339 IMAGE imAlignCenter ;
                 PICTURE 'AlignLeftOff' ;
                 ACTION AlignCenter() ;
                 TOOLTIP 'Align text to center'

      @  81, 339 LABEL laAlignCenter ;
                 VALUE 'C' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57, 368 IMAGE imAlignRight ;
                 PICTURE 'AlignRightOff' ;
                 ACTION AlignRight() ;
                 TOOLTIP 'Align text to right'

      @  81, 373 LABEL laAlignRight ;
                 VALUE 'R' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57, 397 IMAGE imAlignJustify ;
                 PICTURE 'AlignJustifyOff' ;
                 ACTION AlignJustify() ;
                 TOOLTIP 'Justify text'

      @  81, 402 LABEL laAlignJustify ;
                 VALUE 'J' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57, 426 IMAGE imLink ;
                 PICTURE 'Link' ;
                 ACTION MakeLink() ;
                 TOOLTIP 'Create link'

      @  81, 431 LABEL laLink ;
                 VALUE 'K' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  29, 458 LABEL laParagraphLine ;
                 WIDTH 1 HEIGHT 80 BORDER

      // Editing frame

      @  92, 462 LABEL laEditing ;
                 VALUE 'Editing' ;
                 WIDTH 61 CENTERALIGN ;
                 TRANSPARENT 

      @  32, 469 IMAGE imUndo ;
                 PICTURE 'Undo' ;
                 ACTION wMain.ebDoc.UNDO() ;  
                 TOOLTIP 'Undo'

      @  14, 473 LABEL laUndo ;
                 VALUE 'Z' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  32, 495 IMAGE imRedo ;
                 PICTURE 'Redo' ;
                 ACTION wMain.ebDoc.REDO() ;
                 TOOLTIP 'Redo'

      @  14, 499 LABEL laRedo ;
                 VALUE 'Y' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57, 465 IMAGE imFind ;
                 PICTURE 'Find' ;
                 ACTION FindText() ;
                 TOOLTIP 'Find (Ctrl-F)'

      @  81, 473 LABEL laFind ;
                 VALUE 'F' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57, 495 IMAGE imReplace ;
                 PICTURE 'Replace' ;
                 ACTION ReplaceText() ;
                 TOOLTIP 'Find and replace (Ctrl-H)'
        
      @  81, 501 LABEL laReplace ;
                 VALUE 'H' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  29, 527 LABEL laEditingLine ;
                 WIDTH 1 HEIGHT 80 BORDER

    END PAGE

    PAGE 'View'

      // Colors frame

      @  92,   8 LABEL laColors ;
                 VALUE 'Colors' ;
                 WIDTH 81 CENTERALIGN ;
                 TRANSPARENT 

      @  32,  11 IMAGE imDefFontFColor ;
                 PICTURE 'DefFontFColor' ;
                 ACTION wMain.ebDoc.FONTCOLOR := -1 ;  
                 TOOLTIP 'Use default font color'

      @  14,  15 LABEL laDefFontFColor ;
                 VALUE 'E' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  32,  34 IMAGE imSelFontFColor ;
                 PICTURE 'SelFontFColor' ;
                 ACTION FontForeColor() ;
                 TOOLTIP 'Select font color'

      @  14,  32 LABEL laSelFontFColor ;
                 VALUE 'F' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  32,  50 IMAGE imDefFontBColor ;
                 PICTURE 'DefFontBColor' ;
                 ACTION wMain.ebDoc.FONTBACKCOLOR := -1 ;  
                 TOOLTIP 'Use default font background color'

      @  14,  54 LABEL laDefFontBColor ;
                 VALUE 'J' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  32,  73 IMAGE imSelFontBColor ;
                 PICTURE 'SelFontBColor' ;
                 ACTION FontBackColor() ;
                 TOOLTIP 'Select font background color'
       
      @  14,  71 LABEL laSelFontBColor ;
                 VALUE 'K' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57,  30 IMAGE imDefBackColor ;
                 PICTURE 'DefBackColor' ;
                 ACTION wMain.ebDoc.BACKGROUNDCOLOR := -1 ;  
                 TOOLTIP 'Use default document background color'

      @  81,  34 LABEL laDefBackColor ;
                 VALUE 'A' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57,  53 IMAGE imSelBackColor ;
                 PICTURE 'SelBackColor' ;
                 ACTION DocBackColor() ;  
                 TOOLTIP 'Select document background color'

      @  81,  51 LABEL laSelBackColor ;
                 VALUE 'B' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  29,  91 LABEL laColorsLine ;
                 WIDTH 1 HEIGHT 80 BORDER

      // Window frame

      @  92,  95 LABEL laWindow ;
                 VALUE 'Window' ;
                 WIDTH 91 CENTERALIGN ;
                 TRANSPARENT 

      @  32,  98 COMBOBOX coZoom ;
                 ITEMS aZoomLabel ;
                 VALUE 5 ;
                 WIDTH 52 HEIGHT 200 ;
                 FONT 'Calibri' SIZE 9 BOLD ;
                 TOOLTIP 'Zoom ratio' ;
                 ON CHANGE (wMain.ebDoc.ZOOM := (nZoomValue := INT(aZoomPercentage[wMain.coZoom.VALUE])), ;
                            wMain.ebDoc.SETFOCUS) ;
                 ON CANCEL (wMain.ebDoc.SETFOCUS())

      @  14, 116 LABEL laZoom ;
                 VALUE 'Z' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57,  98 IMAGE imZoomIn ;
                 PICTURE 'ZoomIn' ;
                 ACTION ZoomIn() ;  
                 TOOLTIP 'Zoom in the document (Ctrl-Keypad-(+))'

      @  81, 102 LABEL laZoomIn ;
                 VALUE 'I' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57, 126 IMAGE imZoomOut ;
                 PICTURE 'ZoomOut' ;
                 ACTION ZoomOut() ;  
                 TOOLTIP 'Zoom out the document (Ctrl-Keypad-(-))'

      @  81, 130 LABEL laZoomOut ;
                 VALUE 'O' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  32, 158 IMAGE imWordWrap ;
                 PICTURE 'WordWrapOff' ;
                 ACTION WordWrap() ;  
                 TOOLTIP 'Switch word wrap on or off'

      @  14, 162 LABEL laWordWrap ;
                 VALUE 'W' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  57, 158 IMAGE imStatusBar ;
                 PICTURE 'StatusBarOff' ;
                 ACTION StatusBar() ;
                 TOOLTIP 'Switch the status bar on or off'

      @  81, 162 LABEL laStatusBar ;
                 VALUE 'S' ;
                 WIDTH 16 HEIGHT 16 CENTERALIGN ;
                 BACKCOLOR WHITE BORDER INVISIBLE

      @  29, 190 LABEL laWindowLine ;
                 WIDTH 1 HEIGHT 80 BORDER

    END PAGE

  END TAB

  // Document
                
  DefineDoc()
  wMain.taTop.VALUE := 2

END WINDOW

IF lMainMax
  MAXIMIZE WINDOW wMain
END
MainSize(lMainMax)
IF !EMPTY(cInitFile)
  OpenFile(cInitFile)
END
ACTIVATE WINDOW wMain

RETURN // Main

//***************************************************************************

INIT PROCEDURE MainInit

LOCAL nPos

SET FONT TO 'Verdana', 9
SET TOOLTIPSTYLE BALLOON 
SET NAVIGATION EXTENDED
SELECT PRINTER DEFAULT   

cFileFolder := GETMYDOCUMENTSFOLDER()

RegRead('wMain\Row'             , @nMainRow           )
RegRead('wMain\Col'             , @nMainCol           )
RegRead('wMain\Width'           , @nMainWidth         )
RegRead('wMain\Height'          , @nMainHeight        )
RegRead('wMain\Max'             , @lMainMax           )
RegRead('wShort\Row'            , @nShortRow          )
RegRead('wShort\Col'            , @nShortCol          )
RegRead('wShort\Width'          , @nShortWidth        )
RegRead('wShort\Height'         , @nShortHeight       )
RegRead('wShort\Max'            , @lShortMax          )
RegRead('ebDoc\Zoom'            , @nZoomValue         )
RegRead('ebDoc\FontName'        , @cFontName          )
RegRead('ebDoc\FontSize'        , @nFontSize          )
RegRead('ebDoc\FontColor1'      , @aFontForeColor[1]  )
RegRead('ebDoc\FontColor2'      , @aFontForeColor[2]  )
RegRead('ebDoc\FontColor3'      , @aFontForeColor[3]  )
RegRead('ebDoc\FontBackColor1'  , @aFontBackColor[1]  )
RegRead('ebDoc\FontBackColor2'  , @aFontBackColor[2]  )
RegRead('ebDoc\FontBackColor3'  , @aFontBackColor[3]  )
RegRead('ebDoc\BackgroundColor1', @aDocBackColor[1]   )
RegRead('ebDoc\BackgroundColor2', @aDocBackColor[2]   )
RegRead('ebDoc\BackgroundColor3', @aDocBackColor[3]   )
RegRead('ebDoc\WordWrap'        , @lWordWrap          )
RegRead('ebDoc\StatusBar'       , @lStatusBar         )
RegRead('ebDoc\PrintLeft'       , @nPrintLeft         )
RegRead('ebDoc\PrintTop'        , @nPrintTop          )
RegRead('ebDoc\PrintRight'      , @nPrintRight        )
RegRead('ebDoc\PrintBottom'     , @nPrintBottom       )
RegRead('ebDoc\PrintRow'        , @nPrintRow          )
RegRead('ebDoc\PrintCol'        , @nPrintCol          )
RegRead('ebDoc\PrintHead'       , @lPrintHead         )
RegRead('ebDoc\PrintNumHead'    , @lPrintNumHead      )
RegRead('ebDoc\PrintPreHead'    , @cPrintPreHead      )
RegRead('ebDoc\PrintPostHead'   , @cPrintPostHead     )
RegRead('File\FileFolder'       , @cFileFolder        )
RegRead('File\ReadFilter'       , @nReadFilter        )
RegRead('File\WriteFilter'      , @nWriteFilter       )
RegRead('Recent\File01Base'     , @aRecentBases[ 1]   )
RegRead('Recent\File01Name'     , @aRecentNames[ 1]   )
RegRead('Recent\File02Base'     , @aRecentBases[ 2]   )
RegRead('Recent\File02Name'     , @aRecentNames[ 2]   )
RegRead('Recent\File03Base'     , @aRecentBases[ 3]   )
RegRead('Recent\File03Name'     , @aRecentNames[ 3]   )
RegRead('Recent\File04Base'     , @aRecentBases[ 4]   )
RegRead('Recent\File04Name'     , @aRecentNames[ 4]   )
RegRead('Recent\File05Base'     , @aRecentBases[ 5]   )
RegRead('Recent\File05Name'     , @aRecentNames[ 5]   )
RegRead('Recent\File06Base'     , @aRecentBases[ 6]   )
RegRead('Recent\File06Name'     , @aRecentNames[ 6]   )
RegRead('Recent\File07Base'     , @aRecentBases[ 7]   )
RegRead('Recent\File07Name'     , @aRecentNames[ 7]   )
RegRead('Recent\File08Base'     , @aRecentBases[ 8]   )
RegRead('Recent\File08Name'     , @aRecentNames[ 8]   )
RegRead('Recent\File09Base'     , @aRecentBases[ 9]   )
RegRead('Recent\File09Name'     , @aRecentNames[ 9]   )
RegRead('Recent\File10Base'     , @aRecentBases[10]   )
RegRead('Recent\File10Name'     , @aRecentNames[10]   )

GetFontList(NIL, NIL, DEFAULT_CHARSET, NIL, NIL, NIL, @aFontList)
nPos := ASCAN(aFontList, {|cRow| HMG_LOWER(cRow) == HMG_LOWER(cFontName)})
IF EMPTY(nPos)
  cFontName := 'Arial'
END

RETURN // MainInit
   
//***************************************************************************

STATIC PROCEDURE RegRead(cKey, xVal)

LOCAL xRead  := REGISTRYREAD(cRegBase + cKey)
LOCAL cRType := VALTYPE(xRead)
LOCAL cVType := VALTYPE(xVal)

DO CASE
CASE cVType == 'C' .AND. cRType == 'C'
  xVal := xRead
CASE cVType == 'N' .AND. cRType == 'N'
  xVal := xRead
CASE cVType == 'L' .AND. cRType == 'N'
  xVal := !EMPTY(xRead)
END

RETURN // RegRead

//***************************************************************************

STATIC PROCEDURE MainExit(lSub)

IF lModified .AND. MSGYESNO('Save changes?', cTitle)
  SaveFile()
END

IF !lMainMax
  nMainRow    := wMain.ROW
  nMainCol    := wMain.COL
  nMainWidth  := wMain.WIDTH
  nMainHeight := wMain.HEIGHT
END

RegWrite('wMain\Row'             , nMainRow           )
RegWrite('wMain\Col'             , nMainCol           )
RegWrite('wMain\Width'           , nMainWidth         )
RegWrite('wMain\Height'          , nMainHeight        )
RegWrite('wMain\Max'             , lMainMax           )
RegWrite('wShort\Row'            , nShortRow          )
RegWrite('wShort\Col'            , nShortCol          )
RegWrite('wShort\Width'          , nShortWidth        )
RegWrite('wShort\Height'         , nShortHeight       )
RegWrite('wShort\Max'            , lShortMax          )
RegWrite('ebDoc\Zoom'            , nZoomValue         )
RegWrite('ebDoc\FontName'        , cFontName          )
RegWrite('ebDoc\FontSize'        , nFontSize          )
RegWrite('ebDoc\FontColor1'      , aFontForeColor[1]  )
RegWrite('ebDoc\FontColor2'      , aFontForeColor[2]  )
RegWrite('ebDoc\FontColor3'      , aFontForeColor[3]  )
RegWrite('ebDoc\FontBackColor1'  , aFontBackColor[1]  )
RegWrite('ebDoc\FontBackColor2'  , aFontBackColor[2]  )
RegWrite('ebDoc\FontBackColor3'  , aFontBackColor[3]  )
RegWrite('ebDoc\BackgroundColor1', aDocBackColor[1]   )
RegWrite('ebDoc\BackgroundColor2', aDocBackColor[2]   )
RegWrite('ebDoc\BackgroundColor3', aDocBackColor[3]   )
RegWrite('ebDoc\WordWrap'        , lWordWrap          )
RegWrite('ebDoc\StatusBar'       , lStatusBar         )
RegWrite('ebDoc\PrintLeft'       , nPrintLeft         )
RegWrite('ebDoc\PrintTop'        , nPrintTop          )
RegWrite('ebDoc\PrintRight'      , nPrintRight        )
RegWrite('ebDoc\PrintBottom'     , nPrintBottom       )
RegWrite('ebDoc\PrintRow'        , nPrintRow          )
RegWrite('ebDoc\PrintCol'        , nPrintCol          )
RegWrite('ebDoc\PrintHead'       , lPrintHead         )
RegWrite('ebDoc\PrintNumHead'    , lPrintNumHead      )
RegWrite('ebDoc\PrintPreHead'    , cPrintPreHead      )
RegWrite('ebDoc\PrintPostHead'   , cPrintPostHead     )
RegWrite('File\FileFolder'       , cFileFolder        )
RegWrite('File\ReadFilter'       , nReadFilter        )
RegWrite('File\WriteFilter'      , nWriteFilter       )
RegWrite('Recent\File01Base'     , aRecentBases[ 1]   )
RegWrite('Recent\File01Name'     , aRecentNames[ 1]   )
RegWrite('Recent\File02Base'     , aRecentBases[ 2]   )
RegWrite('Recent\File02Name'     , aRecentNames[ 2]   )
RegWrite('Recent\File03Base'     , aRecentBases[ 3]   )
RegWrite('Recent\File03Name'     , aRecentNames[ 3]   )
RegWrite('Recent\File04Base'     , aRecentBases[ 4]   )
RegWrite('Recent\File04Name'     , aRecentNames[ 4]   )
RegWrite('Recent\File05Base'     , aRecentBases[ 5]   )
RegWrite('Recent\File05Name'     , aRecentNames[ 5]   )
RegWrite('Recent\File06Base'     , aRecentBases[ 6]   )
RegWrite('Recent\File06Name'     , aRecentNames[ 6]   )
RegWrite('Recent\File07Base'     , aRecentBases[ 7]   )
RegWrite('Recent\File07Name'     , aRecentNames[ 7]   )
RegWrite('Recent\File08Base'     , aRecentBases[ 8]   )
RegWrite('Recent\File08Name'     , aRecentNames[ 8]   )
RegWrite('Recent\File09Base'     , aRecentBases[ 9]   )
RegWrite('Recent\File09Name'     , aRecentNames[ 9]   )
RegWrite('Recent\File10Base'     , aRecentBases[10]   )
RegWrite('Recent\File10Name'     , aRecentNames[10]   )

IF lSub
  RELEASE WINDOW MAIN
END

RETURN // MainExit

//***************************************************************************

STATIC PROCEDURE RegWrite(cKey, xVal)

LOCAL xWrite := 0
LOCAL cVType := VALTYPE(xVal)

DO CASE
CASE cVType == 'C'
  xWrite := xVal
CASE cVType == 'N'
  xWrite := xVal
CASE cVType == 'L'
  xWrite := IF(xVal, 1, 0)
END

REGISTRYWRITE(cRegBase + cKey, xWrite)

RETURN // RegWrite

//***************************************************************************

STATIC PROCEDURE MainSize(lSetMax)

IF lSetMax != NIL
  lMainMax := lSetMax
END
IF !lMainMax
  nMainRow    := wMain.ROW
  nMainCol    := wMain.COL
  nMainWidth  := wMain.WIDTH
  nMainHeight := wMain.HEIGHT
END

wMain.taTop.WIDTH := wMain.WIDTH
DocSize()
SET DIALOGBOX CENTER OF ('wMain')

RETURN // MainSize

//***************************************************************************

STATIC PROCEDURE DefineDoc(lSetWordWrap)

LOCAL aViewRect     := {}
LOCAL cTempFile     := GETTEMPFOLDER() + '_richedit.rtf'
LOCAL lInit         := (lSetWordWrap == NIL)
LOCAL nCaretPos     := 0
LOCAL nIniFontSize  := nFontSize
LOCAL nIniZoomValue := nZoomValue

BEGIN SEQUENCE

  IF !lInit
    IF lSetWordWrap == lWordWrap
      BREAK
    END
    IF !EX.wMain.ebDoc.SAVEFILE(cTempFile, .N., RICHEDITFILEEX_RTF)
      BREAK
    END
    nCaretPos := wMain.ebDoc.CARETPOS
    wMain.ebDoc.RELEASE 
    lWordWrap := lSetWordWrap
  END

  DEFINE RICHEDITBOX ebDoc
    PARENT    wMain
    ROW       143
    COL       0
    WIDTH     wMain.WIDTH - 17
    HEIGHT    wMain.HEIGHT - 204
    VALUE     ''
    FONTNAME  cFontName
    FONTSIZE  nFontSize
    MAXLENGTH -1
    HSCROLL   lWordWrap
    ONCHANGE  EditKey()
    ONSELECT  Refresh()
    ONLINK    DoLink()
    ONVSCROLL wMain.ebDoc.REFRESH
  END RICHEDITBOX
  DocSize()

  IF !lInit
    IF !EX.wMain.ebDoc.LOADFILE(cTempFile, .N., RICHEDITFILEEX_RTF)
      BREAK
    END
    DELETE FILE (cTempFile)
  END
  aViewRect := wMain.ebDoc.VIEWRECT
  aViewRect[1] += 10 // nLeft
  aViewRect[2] += 10 // nTop
  aViewRect[3] -= 10 // nRight
  aViewRect[4] -= 10 // nBottom
  wMain.ebDoc.VIEWRECT := aViewRect
  wMain.ebDoc.CARETPOS := nCaretPos
  ClearUndoBuffer()
  wMain.ebDoc.FONTSIZE := (nFontSize := nIniFontSize) // work around bug
  wMain.ebDoc.ZOOM     := (nZoomValue := nIniZoomValue) // work around bug
  wMain.ebDoc.SETFOCUS

END SEQUENCE

RETURN // DefineDoc

//***************************************************************************

STATIC PROCEDURE DocSize

LOCAL nStatus := IF(lStatusBar, 0, 25)

wMain.ebDoc.WIDTH       := wMain.WIDTH - 17
wMain.ebDoc.HEIGHT      := wMain.HEIGHT - 204 + nStatus
wMain.STATUSBAR.VISIBLE := lStatusBar

RETURN // DocSize

//***************************************************************************

STATIC PROCEDURE EditKey

LOCAL cKey := HMG_GETLASTCHARACTEREX()
LOCAL nKey := HB_UTF8ASC(cKey)

IF nKey > 0
  wMain.imUndo.ENABLED          := wMain.ebDoc.CANUNDO
  wMain.imRedo.ENABLED          := wMain.ebDoc.CANREDO
  wMain.imBold.PICTURE          := IF(wMain.ebDoc.FONTBOLD     , 'BoldOn'         , 'BoldOff')
  wMain.imItalic.PICTURE        := IF(wMain.ebDoc.FONTITALIC   , 'ItalicsOn'      , 'ItalicsOff') 
  wMain.imUnderline.PICTURE     := IF(wMain.ebDoc.FONTUNDERLINE, 'UnderlineOn'    , 'UnderlineOff') 
  wMain.imStrikethrough.PICTURE := IF(wMain.ebDoc.FONTSTRIKEOUT, 'StrikethroughOn', 'StrikethroughOff') 
  wMain.imSubscript.PICTURE     := IF(wMain.ebDoc.FONTSCRIPT == RTF_SUBSCRIPT  , 'SubscriptOn'  , 'SubscriptOff'  ) 
  wMain.imSuperscript.PICTURE   := IF(wMain.ebDoc.FONTSCRIPT == RTF_SUPERSCRIPT, 'SuperscriptOn', 'SuperscriptOff') 
  wMain.imWordWrap.PICTURE      := IF(lWordWrap , 'WordWrapOn' , 'WordWrapOff' )
  wMain.imStatusBar.PICTURE     := IF(lStatusBar, 'StatusBarOn', 'StatusBarOff')
  lModified := .Y.
END

RETURN // EditKey

//***************************************************************************

STATIC PROCEDURE Refresh

STATIC lRun := .N.

LOCAL nPos

BEGIN SEQUENCE

  IF lRun
     BREAK // avoid re-entry
  END
  lRun := .Y.

  cFontName := wMain.ebDoc.FONTNAME
  nPos := ASCAN(aFontList, {|cRow| HMG_LOWER(cRow) == HMG_LOWER(cFontName)})
  IF EMPTY(nPos)
    cFontName := 'Arial'
    nPos := ASCAN(aFontList, cFontName)
  END
  wMain.coFontName.VALUE := nPos

  nFontSize := wMain.ebDoc.FONTSIZE
  nPos := ASCAN(aFontSizeValue, nFontSize)
  IF EMPTY(nPos)
    nFontSize := 12
    nPos := ASCAN(aFontSizeValue, nFontSize)
  END
  wMain.coFontSize.VALUE := nPos

  nZoomValue := INT(wMain.ebDoc.ZOOM)
  nPos := ASCAN(aZoomPercentage, nZoomValue)
  IF EMPTY(nPos)
    nZoomValue := 100
    nPos := ASCAN(aZoomPercentage, nZoomValue)
  END
  wMain.coZoom.VALUE := nPos

  wMain.imBold.PICTURE          := IF(wMain.ebDoc.FONTBOLD     , 'BoldOn'         , 'BoldOff')
  wMain.imItalic.PICTURE        := IF(wMain.ebDoc.FONTITALIC   , 'ItalicsOn'      , 'ItalicsOff') 
  wMain.imUnderline.PICTURE     := IF(wMain.ebDoc.FONTUNDERLINE, 'UnderlineOn'    , 'UnderlineOff') 
  wMain.imStrikethrough.PICTURE := IF(wMain.ebDoc.FONTSTRIKEOUT, 'StrikethroughOn', 'StrikethroughOff') 
  wMain.imSubscript.PICTURE     := IF(wMain.ebDoc.FONTSCRIPT == RTF_SUBSCRIPT  , 'SubscriptOn'  , 'SubscriptOff'  ) 
  wMain.imSuperscript.PICTURE   := IF(wMain.ebDoc.FONTSCRIPT == RTF_SUPERSCRIPT, 'SuperscriptOn', 'SuperscriptOff') 
  wMain.imWordWrap.PICTURE      := IF(lWordWrap , 'WordWrapOn' , 'WordWrapOff' )
  wMain.imStatusBar.PICTURE     := IF(lStatusBar, 'StatusBarOn', 'StatusBarOff')
  wMain.miBold.CHECKED          := wMain.ebDoc.FONTBOLD
  wMain.miItalic.CHECKED        := wMain.ebDoc.FONTITALIC
  wMain.miUnderline.CHECKED     := wMain.ebDoc.FONTUNDERLINE
  wMain.miStrikethrough.CHECKED := wMain.ebDoc.FONTSTRIKEOUT
  wMain.miSubscript.CHECKED     := wMain.ebDoc.FONTSCRIPT == RTF_SUBSCRIPT  
  wMain.miSuperscript.CHECKED   := wMain.ebDoc.FONTSCRIPT == RTF_SUPERSCRIPT

  SWITCH wMain.ebDoc.PARAALIGNMENT
  CASE RTF_LEFT
    wMain.imAlignLeft.PICTURE    := 'AlignLeftOn'
    wMain.imAlignCenter.PICTURE  := 'AlignCenterOff'
    wMain.imAlignRight.PICTURE   := 'AlignRightOff'
    wMain.imAlignJustify.PICTURE := 'AlignJustifyOff'
    wMain.miAlignLeft.CHECKED    := .Y.
    wMain.miAlignCenter.CHECKED  := .N.
    wMain.miAlignRight.CHECKED   := .N.
    wMain.miAlignJustify.CHECKED := .N.
    EXIT
  CASE RTF_CENTER
    wMain.imAlignLeft.PICTURE    := 'AlignLeftOff'
    wMain.imAlignCenter.PICTURE  := 'AlignCenterOn'
    wMain.imAlignRight.PICTURE   := 'AlignRightOff'
    wMain.imAlignJustify.PICTURE := 'AlignJustifyOff'
    wMain.miAlignLeft.CHECKED    := .N.
    wMain.miAlignCenter.CHECKED  := .Y.
    wMain.miAlignRight.CHECKED   := .N.
    wMain.miAlignJustify.CHECKED := .N.
    EXIT
  CASE RTF_RIGHT
    wMain.imAlignLeft.PICTURE    := 'AlignLeftOff'
    wMain.imAlignCenter.PICTURE  := 'AlignCenterOff'
    wMain.imAlignRight.PICTURE   := 'AlignRightOn'
    wMain.imAlignJustify.PICTURE := 'AlignJustifyOff'
    wMain.miAlignLeft.CHECKED    := .N.
    wMain.miAlignCenter.CHECKED  := .N.
    wMain.miAlignRight.CHECKED   := .Y.
    wMain.miAlignJustify.CHECKED := .N.
    EXIT
  CASE RTF_JUSTIFY
    wMain.imAlignLeft.PICTURE    := 'AlignLeftOff'
    wMain.imAlignCenter.PICTURE  := 'AlignCenterOff'
    wMain.imAlignRight.PICTURE   := 'AlignRightOff'
    wMain.imAlignJustify.PICTURE := 'AlignJustifyOn'
    wMain.miAlignLeft.CHECKED    := .N.
    wMain.miAlignCenter.CHECKED  := .N.
    wMain.miAlignRight.CHECKED   := .N.
    wMain.miAlignJustify.CHECKED := .Y.
    EXIT
  END

  wMain.ebDoc.SETFOCUS

  lRun := .N.

END SEQUENCE

RETURN // Refresh

//***************************************************************************

STATIC PROCEDURE MainKey(cKey)

LOCAL hOffKey := { ;
  'F' => {|| wMain.taTop.VALUE := 1}, ;
  'H' => {|| MainHomeKey(.Y., .Y.) }, ;
  'V' => {|| MainViewKey(.Y., .Y.) }  }

LOCAL hQuacKey := { ;
  'F' => {|| wMain.taTop.VALUE := 1}, ;
  'H' => {|| MainHomeKey(.Y., .Y.) }, ;
  'K' => {|| Shortcuts()           }, ;
  'N' => {|| NewFile()             }, ;
  'O' => {|| OpenFile()            }, ;
  'P' => {|| Print(.N.)            }, ;
  'S' => {|| SaveFile()            }, ;
  'V' => {|| MainViewKey(.Y., .Y.) }  }

LOCAL hHomeKey := { ;
  'A' => {|| ListApply()       }, ;
  'B' => {|| Bold()            }, ;
  'C' => {|| Copy()            }, ;
  'D' => {|| Deleter()         }, ;
  'E' => {|| AlignCenter()     }, ;
  'F' => {|| FindText()        }, ;
  'G' => {|| IndentOffset()    }, ;
  'H' => {|| ReplaceText()     }, ;
  'I' => {|| Italic()          }, ;
  'J' => {|| AlignJustify()    }, ;
  'K' => {|| MakeLink()        }, ;
  'L' => {|| AlignLeft()       }, ;
  'M' => {|| FontFormat()      }, ;
  'N' => {|| LineSpace()       }, ;
  'O' => {|| ListFormat()      }, ;
  'P' => {|| Paste()           }, ;
  'Q' => {|| LineSpaceApply()  }, ;
  'R' => {|| AlignRight()      }, ;
  'S' => {|| Strikethrough()   }, ;
  'T' => {|| IndentLeft()      }, ;
  'U' => {|| Underline()       }, ;
  'V' => {|| IndentRight()     }, ;
  'W' => {|| PasteUnformatted()}, ;
  'X' => {|| Cut()             }, ;
  'Y' => {|| wMain.ebDoc.REDO()}, ;
  'Z' => {|| wMain.ebDoc.UNDO()}, ;
  '2' => {|| Subscript()       }, ;
  '3' => {|| Superscript()     }, ;
  '-' => {|| MainQuacKey(.Y.)  }  }

LOCAL hViewKey := { ;
  'A' => {|| wMain.ebDoc.BACKGROUNDCOLOR := -1}, ;
  'B' => {|| DocBackColor()                   }, ;
  'E' => {|| wMain.ebDoc.FONTCOLOR := -1      }, ;
  'F' => {|| FontForeColor()                  }, ;
  'I' => {|| ZoomIn()                         }, ;
  'J' => {|| wMain.ebDoc.FONTBACKCOLOR := -1  }, ;
  'K' => {|| FontBackColor()                  }, ;
  'O' => {|| ZoomOut()                        }, ;
  'S' => {|| StatusBar()                      }, ;
  'W' => {|| WordWrap()                       }, ;
  'Z' => {|| Zoom()                           }, ;
  '-' => {|| MainQuacKey(.Y.)                 }  }

SWITCH nKeyNav
CASE KEYNAV_OFF

  IF HB_HHASKEY(hOffKey, cKey)
    hOffKey[cKey]:EVAL()
  END
  EXIT

CASE KEYNAV_QUAC

  MainQuacKey(.N.)
  IF HB_HHASKEY(hQuacKey, cKey)
    hQuacKey[cKey]:EVAL()
  END
  EXIT

CASE KEYNAV_HOME

  MainHomeKey(.N., .Y.)
  IF HB_HHASKEY(hHomeKey, cKey)
    hHomeKey[cKey]:EVAL()
  END
  EXIT

CASE KEYNAV_VIEW

  MainViewKey(.N., .Y.)
  IF HB_HHASKEY(hViewKey, cKey)
    hViewKey[cKey]:EVAL()
  END
  EXIT

END

RETURN // MainKey

//***************************************************************************

STATIC PROCEDURE MainQuacKey(lSet)

nKeyNav := IF(lSet, KEYNAV_QUAC, KEYNAV_OFF)
wMain.laSave.VISIBLE      := lSet
wMain.laNew.VISIBLE       := lSet
wMain.laOpen.VISIBLE      := lSet
wMain.laPrint.VISIBLE     := lSet
wMain.laShortcuts.VISIBLE := lSet
wMain.laFile.VISIBLE      := lSet
wMain.laHome.VISIBLE      := lSet
wMain.laView.VISIBLE      := lSet

RETURN // MainQuacKey

//***************************************************************************

STATIC PROCEDURE MainHomeKey(lSet, lPage)

nKeyNav := IF(lSet, KEYNAV_HOME, KEYNAV_OFF)
IF lPage
  wMain.taTop.VALUE := 2
END
wMain.laPaste.VISIBLE          := lSet
wMain.laCut.VISIBLE            := lSet
wMain.laCopy.VISIBLE           := lSet
wMain.laDelete.VISIBLE         := lSet
wMain.laPasteUnform.VISIBLE    := lSet
wMain.laFontName.VISIBLE       := lSet
wMain.laFontSize.VISIBLE       := lSet
wMain.laBold.VISIBLE           := lSet
wMain.laItalic.VISIBLE         := lSet
wMain.laUnderline.VISIBLE      := lSet
wMain.laStrikethrough.VISIBLE  := lSet
wMain.laSubscript.VISIBLE      := lSet
wMain.laSuperscript.VISIBLE    := lSet
wMain.laFontOptions.VISIBLE    := lSet
wMain.laListApply.VISIBLE      := lSet
wMain.laListSet.VISIBLE        := lSet
wMain.laIndentLeft.VISIBLE     := lSet
wMain.laIndentOpt.VISIBLE      := lSet
wMain.laIndentRight.VISIBLE    := lSet
wMain.laLineSpaceApply.VISIBLE := lSet
wMain.laLineSpaceSet.VISIBLE   := lSet
wMain.laAlignLeft.VISIBLE      := lSet
wMain.laAlignCenter.VISIBLE    := lSet
wMain.laAlignRight.VISIBLE     := lSet
wMain.laAlignJustify.VISIBLE   := lSet
wMain.laLink.VISIBLE           := lSet
wMain.laUndo.VISIBLE           := lSet
wMain.laRedo.VISIBLE           := lSet
wMain.laFind.VISIBLE           := lSet
wMain.laReplace.VISIBLE        := lSet

RETURN // MainHomeKey

//***************************************************************************

STATIC PROCEDURE MainViewKey(lSet, lPage)

nKeyNav := IF(lSet, KEYNAV_VIEW, KEYNAV_OFF)
IF lPage
  wMain.taTop.VALUE := 3
END
wMain.laDefFontBColor.VISIBLE := lSet
wMain.laSelFontBColor.VISIBLE := lSet
wMain.laDefFontFColor.VISIBLE := lSet
wMain.laSelFontFColor.VISIBLE := lSet
wMain.laDefBackColor.VISIBLE  := lSet
wMain.laSelBackColor.VISIBLE  := lSet
wMain.laZoom.VISIBLE          := lSet
wMain.laZoomIn.VISIBLE        := lSet
wMain.laZoomOut.VISIBLE       := lSet
wMain.laWordWrap.VISIBLE      := lSet
wMain.laStatusBar.VISIBLE     := lSet

RETURN // MainViewKey

//***************************************************************************

STATIC PROCEDURE MainTabChange

STATIC nOldPage := 2

SWITCH wMain.taTop.VALUE
CASE 1
  FileMenu()
  wMain.taTop.VALUE := nOldPage
  EXIT
CASE 2
  nOldPage := 2
  SWITCH nKeyNav
  CASE KEYNAV_QUAC
    MainQuacKey(.N.)
    EXIT
  CASE KEYNAV_VIEW
    MainViewKey(.N., .N.)
    MainHomeKey(.Y., .N.)
    EXIT
  END
  EXIT
CASE 3
  nOldPage := 3
  SWITCH nKeyNav
  CASE KEYNAV_QUAC
    MainQuacKey(.N.)
    EXIT
  CASE KEYNAV_HOME
    MainHomeKey(.N., .N.)
    MainViewKey(.Y., .N.)
    EXIT
  END
  EXIT
END

RETURN // MainTabChange

//***************************************************************************

STATIC PROCEDURE FileMenu

LOCAL aMainRowCol := EX.wMain.GETSCREENPOS( ;
  wMain.taTop.ROW + 20, wMain.taTop.COL)
LOCAL bNew
LOCAL bOpen
LOCAL bSave
LOCAL bSaveAs
LOCAL bPrint
LOCAL bPreview
LOCAL bPageSetup
LOCAL bAbout
LOCAL bAssoc
LOCAL bExit
LOCAL bRecent
LOCAL bSelect := {|| NIL}
LOCAL nSelect

DEFINE WINDOW wFileMenu ;
  AT aMainRowCol[1], aMainRowCol[2] ;
  WIDTH 500 HEIGHT 520 ;
  MODAL NOSIZE NOCAPTION

  bNew       := {|| bSelect := {|| NewFile()     }, wFileMenu.RELEASE}
  bOpen      := {|| bSelect := {|| OpenFile()    }, wFileMenu.RELEASE}
  bSave      := {|| bSelect := {|| SaveFile()    }, wFileMenu.RELEASE}
  bSaveAs    := {|| bSelect := {|| SaveFileAs()  }, wFileMenu.RELEASE}
  bPrint     := {|| bSelect := {|| Print(.N.)    }, wFileMenu.RELEASE}
  bPreview   := {|| bSelect := {|| Print(.Y.)    }, wFileMenu.RELEASE}
  bPageSetup := {|| bSelect := {|| PageSetup()   }, wFileMenu.RELEASE}
  bAssoc     := {|| bSelect := {|| Associations()}, wFileMenu.RELEASE}
  bAbout     := {|| bSelect := {|| About()       }, wFileMenu.RELEASE}
  bExit      := {|| bSelect := {|| wMain.RELEASE }, wFileMenu.RELEASE}
  bRecent    := {|nFile| 
    IF !EMPTY(aRecentBases[nFile])
      nSelect := nFile
      bSelect := {|| OpenFile(aRecentNames[nSelect])}
      wFileMenu.RELEASE
    END
    RETURN NIL
    }

  EX.wFileMenu.DRAWBORDER

  @  10,  10 IMAGE imNew ;
             PICTURE 'New' ;
             ACTION bNew:EVAL() ;
             TOOLTIP 'Create a new document (Ctrl-N)'

  @  25,  65 LABEL laNew ;
             VALUE '&New' ;
             ACTION bNew:EVAL() ;
             TOOLTIP 'Create a new document (Ctrl-N)' ;
             AUTOSIZE

  @  60,  10 IMAGE imOpen ;
             PICTURE 'Open' ;
             ACTION bOpen:EVAL() ;
             TOOLTIP 'Open an existing document (Ctrl-O)'

  @  75,  65 LABEL laOpen ;
             VALUE '&Open' ;
             ACTION bOpen:EVAL() ;
             TOOLTIP 'Open an existing document (Ctrl-O)' ;
             AUTOSIZE

  @ 110,  10 IMAGE imSave ;
             PICTURE 'Save' ;
             ACTION bSave:EVAL() ;
             TOOLTIP 'Save the active document (Ctrl-S)'

  @ 125,  65 LABEL laSave ;
             VALUE '&Save' ;
             ACTION bSave:EVAL() ;
             TOOLTIP 'Save the active document (Ctrl-S)' ;
             AUTOSIZE

  @ 160,  10 IMAGE imSaveAs ;
             PICTURE 'SaveAs' ;
             ACTION bSaveAs:EVAL() ;
             TOOLTIP 'Save a copy of the document'

  @ 175,  65 LABEL laSaveAs ;
             VALUE 'Save &as' ;
             ACTION bSaveAs:EVAL() ;
             TOOLTIP 'Save a copy of the document' ;
             AUTOSIZE

  @ 210,  10 IMAGE imPrint ;
             PICTURE 'Print' ;
             ACTION bPrint:EVAL() ;
             TOOLTIP 'Print the document (Ctrl-P)'

  @ 225,  65 LABEL laPrint ;
             VALUE '&Print' ;
             ACTION bPrint:EVAL() ;
             TOOLTIP 'Print the document (Ctrl-P)' ;
             AUTOSIZE

  @ 260,  10 IMAGE imPreview ;
             PICTURE 'PrintPreview' ;
             ACTION bPreview:EVAL() ;
             TOOLTIP 'Preview printed appearance before printing'

  @ 275,  65 LABEL laPreview ;
             VALUE 'Print pre&view' ;
             ACTION bPreview:EVAL() ;
             TOOLTIP 'Preview printed appearance before printing' ;
             AUTOSIZE

  @ 310,  10 IMAGE imPageSetup ;
             PICTURE 'PageSetup' ;
             ACTION bPageSetup:EVAL() ;
             TOOLTIP 'Change page layout settings'

  @ 325,  65 LABEL laPageSetup ;
             VALUE 'Pa&ge setup' ;
             ACTION bPageSetup:EVAL() ;
             TOOLTIP 'Change page layout settings' ;
             AUTOSIZE

  @ 360,  10 IMAGE imAssoc ;
             PICTURE 'Assoc' ;
             ACTION bAssoc:EVAL() ;
             TOOLTIP 'Control how Windows launches this program'

  @ 365,  65 LABEL laAssoc ;
             VALUE E"Short&cuts and\nassociations" ;
             ACTION bAssoc:EVAL() ;
             TOOLTIP 'Control how Windows launches this program' ;
             WIDTH 120 HEIGHT 30

  @ 410,  10 IMAGE imAbout ;
             PICTURE 'About' ;
             ACTION bAbout:EVAL() ;
             TOOLTIP 'About WordWriter'

  @ 425,  65 LABEL laAbout ;
             VALUE 'Abou&t' ;
             ACTION bAbout:EVAL() ;
             TOOLTIP 'About WordWriter' ;
             AUTOSIZE

  @ 460,  10 IMAGE imExit ;
             PICTURE 'Exit' ;
             ACTION bExit:EVAL() ;
             TOOLTIP 'Exit WordWriter'

  @ 475,  65 LABEL laExit ;
             VALUE 'E&xit' ;
             ACTION bExit:EVAL() ;
             TOOLTIP 'Exit WordWriter' ;
             AUTOSIZE

  @   0, 180 FRAME frRecent ;
             WIDTH 2 HEIGHT wFileMenu.HEIGHT

  @  25, 200 LABEL laRecent ;
             VALUE 'Recent documents' BOLD ;
             AUTOSIZE

  IF !EMPTY(aRecentBases[ 1])
    @  45, 200 LABEL laRecent01 ;
               VALUE '&1   ' + aRecentBases[ 1] ;
               ACTION bRecent:EVAL( 1) ;
               TOOLTIP aRecentNames[ 1] ;
               AUTOSIZE
  END

  IF !EMPTY(aRecentBases[ 2])
    @  70, 200 LABEL laRecent02 ;
               VALUE '&2   ' + aRecentBases[ 2] ;
               ACTION bRecent:EVAL( 2) ;
               TOOLTIP aRecentNames[ 2] ;
               AUTOSIZE
  END

  IF !EMPTY(aRecentBases[ 3])
    @  95, 200 LABEL laRecent03 ;
               VALUE '&3   ' + aRecentBases[ 3] ;
               ACTION bRecent:EVAL( 3) ;
               TOOLTIP aRecentNames[ 3] ;
               AUTOSIZE
  END

  IF !EMPTY(aRecentBases[ 4])
    @ 120, 200 LABEL laRecent04 ;
               VALUE '&4   ' + aRecentBases[ 4] ;
               ACTION bRecent:EVAL( 4) ;
               TOOLTIP aRecentNames[ 4] ;
               AUTOSIZE
  END

  IF !EMPTY(aRecentBases[ 5])
    @ 145, 200 LABEL laRecent05 ;
               VALUE '&5   ' + aRecentBases[ 5] ;
               ACTION bRecent:EVAL( 5) ;
               TOOLTIP aRecentNames[ 5] ;
               AUTOSIZE
  END

  IF !EMPTY(aRecentBases[ 6])
    @ 170, 200 LABEL laRecent06 ;
               VALUE '&6   ' + aRecentBases[ 6] ;
               ACTION bRecent:EVAL( 6) ;
               TOOLTIP aRecentNames[ 6] ;
               AUTOSIZE
  END

  IF !EMPTY(aRecentBases[ 7])
    @ 195, 200 LABEL laRecent07 ;
               VALUE '&7   ' + aRecentBases[ 7] ;
               ACTION bRecent:EVAL( 7) ;
               TOOLTIP aRecentNames[ 7] ;
               AUTOSIZE
  END

  IF !EMPTY(aRecentBases[ 8])
    @ 220, 200 LABEL laRecent08 ;
               VALUE '&8   ' + aRecentBases[ 8] ;
               ACTION bRecent:EVAL( 8) ;
               TOOLTIP aRecentNames[ 8] ;
               AUTOSIZE
  END

  IF !EMPTY(aRecentBases[ 9])
    @ 245, 200 LABEL laRecent09 ;
               VALUE '&9   ' + aRecentBases[ 9] ;
               ACTION bRecent:EVAL( 9) ;
               TOOLTIP aRecentNames[ 9] ;
               AUTOSIZE
  END

  IF !EMPTY(aRecentBases[10])
    @ 270, 200 LABEL laRecent10 ;
               VALUE '1&0  ' + aRecentBases[10] ;
               ACTION bRecent:EVAL(10) ;
               TOOLTIP aRecentNames[10] ;
               AUTOSIZE
  END

  @  10, 465 BUTTON btCancel ;
             CAPTION '×' BOLD FLAT ; // U+00D7 MULTIPLICATION SIGN
             ACTION wFileMenu.RELEASE ;
             WIDTH 25 HEIGHT 25

  ON KEY ALT+N ACTION bNew:EVAL()
  ON KEY ALT+O ACTION bOpen:EVAL()
  ON KEY ALT+S ACTION bSave:EVAL()
  ON KEY ALT+A ACTION bSaveAs:EVAL()
  ON KEY ALT+P ACTION bPrint:EVAL()
  ON KEY ALT+V ACTION bPreview:EVAL()
  ON KEY ALT+G ACTION bPageSetup:EVAL()
  ON KEY ALT+C ACTION bAssoc:EVAL()
  ON KEY ALT+T ACTION bAbout:EVAL()
  ON KEY ALT+X ACTION bExit:EVAL()

  ON KEY ALT+1 ACTION bRecent:EVAL( 1)
  ON KEY ALT+2 ACTION bRecent:EVAL( 2)
  ON KEY ALT+3 ACTION bRecent:EVAL( 3)
  ON KEY ALT+4 ACTION bRecent:EVAL( 4)
  ON KEY ALT+5 ACTION bRecent:EVAL( 5)
  ON KEY ALT+6 ACTION bRecent:EVAL( 6)
  ON KEY ALT+7 ACTION bRecent:EVAL( 7)
  ON KEY ALT+8 ACTION bRecent:EVAL( 8)
  ON KEY ALT+9 ACTION bRecent:EVAL( 9)
  ON KEY ALT+0 ACTION bRecent:EVAL(10)

  ON KEY ESCAPE ACTION wFileMenu.RELEASE

END WINDOW 
   
ACTIVATE WINDOW wFileMenu

bSelect:EVAL()

RETURN // FileMenu

//***************************************************************************

STATIC PROCEDURE DoLink

LOCAL cLink := ALLTRIM(THISRICHEDITBOX.GETCLICKLINKTEXT)

DO CASE
CASE HMG_LOWER(HB_USUBSTR(cLink,1,7)) == 'http://' .OR. ;
   HMG_LOWER(HB_USUBSTR(cLink,1,8)) == 'https://' .OR. ;
   HMG_LOWER(HB_USUBSTR(cLink,1,6)) == 'ftp://' .OR. ;
   HMG_LOWER(HB_USUBSTR(cLink,1,4)) == 'www.' 
   SHELLEXECUTE(NIL, 'Open', cLink, NIL, NIL, SW_SHOWNORMAL)
CASE '@' $ cLink .AND. !('/' $ cLink)
   SHELLEXECUTE(NIL, 'Open', 'rundll32.exe', 'url.dll,FileProtocolHandler mailto:' + cLink, NIL, SW_SHOWNORMAL)
OTHERWISE
   MSGEXCLAMATION('Cannot launch ' + cLink +'', cTitle)
END

RETURN // DoLink

//***************************************************************************

STATIC PROCEDURE NewFileName(cNewName)

LOCAL nPos

cFileName := cNewName
nPos      := HB_UTF8RAT('\', cFileName)
IF EMPTY(nPos)
  cFileFolder := GETMYDOCUMENTSFOLDER()
  cFileBase   := cFileName
  cFileName   := cFileFolder + '\' + cFileBase
ELSE
  cFileFolder := HB_UTF8LEFT(cFileName, nPos - 1)
  cFileBase   := HB_UTF8SUBSTR(cFileName, nPos + 1)
END
nPos     := HB_UTF8RAT('.', cFileBase)
cFileExt := IF(nPos < 2, '', HB_UTF8SUBSTR(cFileBase, nPos + 1))
IF !EMPTY(cNewName)
  nPos := ASCAN(aRecentNames, {|cRow| HMG_UPPER(cRow) == HMG_UPPER(cFileName)})
  IF !EMPTY(nPos)
     ADEL(aRecentBases, nPos)
     ADEL(aRecentNames, nPos)
  END
  AINS(aRecentBases, 1)
  AINS(aRecentNames, 1)
  aRecentBases[1] := cFileBase
  aRecentNames[1] := cFileName
END
wMain.TITLE := IF(EMPTY(cFileBase), 'Document', cFileBase) + ' • ' + cTitle // U+2022 BULLET
wMain.STATUSBAR.ITEM(1) := cFileName

RETURN // NewFileName

//***************************************************************************

STATIC PROCEDURE NewFile

IF !lModified .OR. MSGYESNO('Clear the current file?', 'New')
  NewFileName('')
  wMain.ebDoc.RELEASE
  DefineDoc()
  lModified := .N.
END

RETURN // NewFile

//***************************************************************************

STATIC PROCEDURE OpenFile(cNewFileName)

IF lModified .AND. MSGYESNO('Save changes?', 'Open')
  SaveFile()
END

IF EMPTY(cNewFileName)
  cNewFileName := GETFILE(aReadFilter, 'Open', cFileFolder, NIL, NIL, nReadFilter)
END

IF !EMPTY(cNewFileName)
  NewFileName(cNewFileName)
  ReadFile()
  lModified := .N.
END

RETURN // OpenFile

//***************************************************************************

STATIC PROCEDURE ReadFile

LOCAL nFormat        := GETRICHEDITFILETYPE(cFileName, .Y.)
LOCAL nTxtReadFilter := IF(HMG_UPPER(cFileExt) == 'TXT', 2, 3)

SWITCH nFormat
CASE RICHEDITFILEEX_RTF
  nReadFilter  := 1
  nWriteFilter := 1
  EXIT
CASE RICHEDITFILEEX_ANSI
  nReadFilter  := nTxtReadFilter
  nWriteFilter := 2
  EXIT
CASE RICHEDITFILEEX_UTF16LE
  nReadFilter  := nTxtReadFilter
  nWriteFilter := 3
  EXIT
CASE RICHEDITFILEEX_UTF16BE
  nReadFilter  := nTxtReadFilter
  nWriteFilter := 4
  EXIT
CASE RICHEDITFILEEX_UTF8
  nReadFilter  := nTxtReadFilter
  nWriteFilter := 5
  EXIT
END
BEGIN SEQUENCE
  IF !EX.wMain.ebDoc.LOADFILE(cFileName, .N., nFormat)
    BREAK
  END
  wMain.ebDoc.ZOOM := nZoomValue
  ClearUndoBuffer()
RECOVER
  MSGEXCLAMATION('Cannot open ' + cFileName, 'Open')
END SEQUENCE

RETURN // ReadFile

//***************************************************************************

STATIC PROCEDURE CloseFile

IF MSGYESNO('Close the current file?', 'Close')
  NewFileName('')
  lModified := .N.
END

RETURN // CloseFile

//***************************************************************************

STATIC PROCEDURE SaveFile

IF EMPTY(cFileName)
  SaveFileAs()
ELSE
  WriteFile()
END

RETURN // SaveFile

//***************************************************************************

STATIC PROCEDURE SaveFileAs

LOCAL lUnicode := EX.wMain.ebDoc.HASNONASCIICHARS
LOCAL cNewFileName

IF lUnicode
  IF nWriteFilter == 2
    nWriteFilter := 3
  END
ELSE
  IF nWriteFilter >= 3
    nWriteFilter := 2
  END
END

cNewFileName := PUTFILE(aWriteFilter, 'Save As', cFileFolder, ;
  NIL, cFileName, @cFileExt, @nWriteFilter)

IF !EMPTY(cNewFileName) .AND. (!lUnicode .OR. nWriteFilter != 2 .OR. ;
  MSGYESNO('This document contains Unicode characters, which will be lost if you save to an ANSI file.  Proceed?', cTitle))
  NewFileName(cNewFileName)
  WriteFile()
END

RETURN // SaveFile

//***************************************************************************

STATIC PROCEDURE WriteFile

LOCAL nFormat

BEGIN SEQUENCE
  SWITCH nWriteFilter
  CASE 1
    nFormat := RICHEDITFILEEX_RTF
    EXIT
  CASE 2
    nFormat := RICHEDITFILEEX_ANSI
    EXIT
  CASE 3
    nFormat := RICHEDITFILEEX_UTF16LE
    EXIT
  CASE 4
    nFormat := RICHEDITFILEEX_UTF16BE
    EXIT
  CASE 5
    nFormat := RICHEDITFILEEX_UTF8
    EXIT
  END
  IF !EX.wMain.ebDoc.SAVEFILE(cFileName, .N., nFormat)
    BREAK
  END
  lModified := .N.
RECOVER
  MSGEXCLAMATION('Cannot save to ' + cFileName, 'Save')
END SEQUENCE

RETURN // WriteFile

//***************************************************************************

STATIC PROCEDURE Print(lPreview)

LOCAL aSelect   := {0, -1}  
LOCAL cPreHead  := IF(EMPTY(cPrintPreHead), '', cPrintPreHead + ' ')
LOCAL cPostHead := IF(EMPTY(cPrintPostHead), '', ' ' + cPrintPostHead)
LOCAL lPrint    := .N.
LOCAL nPage     := 1
LOCAL bPage

DO CASE
CASE !lPrintHead
  bPage := {|| NIL}
CASE !lPrintNumHead
  bPage := {|| @ nPrintRow, nPrintCol PRINT cPreHead + cPostHead}
OTHERWISE
  bPage := {|| @ nPrintRow, nPrintCol PRINT cPreHead + HB_NTOS(nPage++) + cPostHead}
END

IF !lPreview
  SELECT PRINTER DIALOG EX TO lPrint
ELSE
  SELECT PRINTER DIALOG EX TO lPrint PREVIEW
END
IF lPrint
  wMain.ebDoc.RTFPRINT(aSelect, nPrintLeft, nPrintTop, nPrintRight, nPrintBottom, bPage)
END

RETURN // Print

//***************************************************************************

STATIC PROCEDURE PageSetup

LOCAL bHeader
LOCAL bPrint

DEFINE WINDOW wPageSetup;
  AT wMain.ROW + 145, wMain.COL + 10;
  WIDTH 620 HEIGHT 430 ;
  TITLE 'Page Setup' ;
  MODAL NOSIZE

  bHeader := {|lSet|
    wPageSetup.laHeaderRow.ENABLED      := lSet
    wPageSetup.tbHeaderRow.ENABLED      := lSet
    wPageSetup.laHeaderCol.ENABLED      := lSet
    wPageSetup.tbHeaderCol.ENABLED      := lSet
    wPageSetup.cbPageNumber.ENABLED     := lSet
    wPageSetup.laHeaderPreText.ENABLED  := lSet
    wPageSetup.tbHeaderPreText.ENABLED  := lSet
    wPageSetup.laHeaderPostText.ENABLED := lSet
    wPageSetup.tbHeaderPostText.ENABLED := lSet
    RETURN NIL
    }
  bPrint := {|| 
    SELECT PRINTER DIALOG
    wPageSetup.tbPrinterName.VALUE  := OPENPRINTERGETNAME() 
    wPageSetup.tbPageHeight.VALUE   := OPENPRINTERGETPAGEHEIGHT()
    wPageSetup.tbPageWidth.VALUE    := OPENPRINTERGETPAGEWIDTH()
    wPageSetup.tbPrintHeight.VALUE  := GETPRINTABLEAREAHEIGHT()
    wPageSetup.tbPrintWidth.VALUE   := GETPRINTABLEAREAWIDTH()
    wPageSetup.tbPrintVOffset.VALUE := GETPRINTABLEAREAVERTICALOFFSET()
    wPageSetup.tbPrintHOffset.VALUE := GETPRINTABLEAREAHORIZONTALOFFSET()
    RETURN NIL
  }

  @   5,  10 FRAME frPage ;
             CAPTION 'Page dimensions' ;
             WIDTH 320 HEIGHT 355

  @  40, 115 BUTTON btPrint ;
             CAPTION 'Select printer' ;  
             ACTION bPrint:EVAL() ;
             WIDTH 100 HEIGHT 25

  @  90,  20 LABEL laPrinterName ;
             VALUE 'Printer name' ;
             AUTOSIZE

  @  90, 110 TEXTBOX tbPrinterName ;
             WIDTH 200 ;
             VALUE OPENPRINTERGETNAME() READONLY

  @ 120,  20 LABEL laPageHeight ;
             VALUE 'Page height (mm)' ;
             AUTOSIZE

  @ 120, 270 TEXTBOX tbPageHeight ;
             WIDTH 40 ;
             VALUE OPENPRINTERGETPAGEHEIGHT() READONLY ;
             NUMERIC INPUTMASK '999'

  @ 150,  20 LABEL laPageWidth ;
             VALUE 'Page width (mm)' ;
             AUTOSIZE

  @ 150, 270 TEXTBOX tbPageWidth ;
             WIDTH 40 ;
             VALUE OPENPRINTERGETPAGEWIDTH() READONLY ;
             NUMERIC INPUTMASK '999'

  @ 180,  20 LABEL laPrintHeight ;
             VALUE 'Printable area height (mm)' ;
             AUTOSIZE

  @ 180, 270 TEXTBOX tbPrintHeight ;
             WIDTH 40 ;
             VALUE GETPRINTABLEAREAHEIGHT() READONLY ;
             NUMERIC INPUTMASK '999'

  @ 210,  20 LABEL laPrintWidth ;
             VALUE 'Printable area width (mm)' ;
             AUTOSIZE

  @ 210, 270 TEXTBOX tbPrintWidth ;
             WIDTH 40 ;
             VALUE GETPRINTABLEAREAWIDTH() READONLY ;
             NUMERIC INPUTMASK '999'

  @ 240,  20 LABEL laPrintVOffset ;
             VALUE 'Printable area vertical offset (mm)' ;
             AUTOSIZE

  @ 240, 270 TEXTBOX tbPrintVOffset ;
             WIDTH 40 ;
             VALUE GETPRINTABLEAREAVERTICALOFFSET() READONLY ;
             NUMERIC INPUTMASK '999'

  @ 270,  20 LABEL laPrintHOffset ;
             VALUE 'Printable area horizontal offset (mm)' ;
             AUTOSIZE

  @ 270, 270 TEXTBOX tbPrintHOffset ;
             WIDTH 40 ;
             VALUE GETPRINTABLEAREAHORIZONTALOFFSET() READONLY ;
             NUMERIC INPUTMASK '999'

  @   5, 335 FRAME frAlign ;
             CAPTION 'Margins' ;
             WIDTH 270 HEIGHT 145

  @  30, 345 LABEL laLeftMargin ;
             VALUE 'Left margin (mm)' ;
             AUTOSIZE

  @  30, 550 TEXTBOX tbLeftMargin ;
             WIDTH 40 ;
             VALUE nPrintLeft ;
             NUMERIC INPUTMASK '999'

  @  60, 345 LABEL laRightMargin ;
             VALUE 'Right margin (mm)' ;
             AUTOSIZE

  @  60, 550 TEXTBOX tbRightMargin ;
             WIDTH 40 ;
             VALUE nPrintRight ; 
             NUMERIC INPUTMASK '999'

  @  90, 345 LABEL laTopMargin ;
             VALUE 'Top margin (mm)' ;
             AUTOSIZE

  @  90, 550 TEXTBOX tbTopMargin ;
             WIDTH 40 ;
             VALUE nPrintTop ; 
             NUMERIC INPUTMASK '999'

  @ 120, 345 LABEL laBottomMargin ;
             VALUE 'Bottom margin (mm)' ;
             AUTOSIZE

  @ 120, 550 TEXTBOX tbBottomMargin ;
             WIDTH 40 ;
             VALUE nPrintBottom ; 
             NUMERIC INPUTMASK '999'

  @ 155, 335 FRAME frHeader ;
             CAPTION 'Header' ;
             WIDTH 270 HEIGHT 205
                  
  @ 180, 345 CHECKBOX cbHeader ;
             CAPTION 'Include header' ;
             WIDTH 225 HEIGHT 23 ;
             VALUE lPrintHead ;
             ON CHANGE bHeader:EVAL(wPageSetup.cbHeader.VALUE)

  @ 210, 345 LABEL laHeaderRow ;
             VALUE 'Offset from top (mm)' ;
             AUTOSIZE

  @ 210, 550 TEXTBOX tbHeaderRow ;
             WIDTH 40 ;
             VALUE nPrintRow ; 
             TOOLTIP 'Distance of center of header from top side of page' ;
             NUMERIC INPUTMASK '999'

  @ 240, 345 LABEL laHeaderCol ;
             VALUE 'Offset from left (mm)' ;
             AUTOSIZE

  @ 240, 550 TEXTBOX tbHeaderCol ;
             WIDTH 40 ;
             VALUE nPrintCol ; 
             TOOLTIP 'Distance of center of header from left side of page' ;
             NUMERIC INPUTMASK '999'

  @ 270, 345 CHECKBOX cbPageNumber ;
             CAPTION 'Include page number in header' ;
             WIDTH 220 HEIGHT 23 ;
             VALUE lPrintNumHead

  @ 300, 345 LABEL laHeaderPreText ;
             VALUE 'Header pre text' ;
             AUTOSIZE

  @ 300, 460 TEXTBOX tbHeaderPreText ;
             WIDTH 130 ;
             VALUE cPrintPreHead ; 
             MAXLENGTH 40 ;
             TOOLTIP 'Header text before page number; max 40 characters' 

  @ 330, 345 LABEL laHeaderPostText ;
             VALUE 'Header post text' ;
             AUTOSIZE
  
  @ 330, 460 TEXTBOX tbHeaderPostText ;
             WIDTH 130 ;
             VALUE cPrintPostHead ; 
             MAXLENGTH 40 ;
             TOOLTIP 'Header text after page number; max 40 characters'

  @ 370, 225 BUTTON btOk ;
             CAPTION 'OK' ;  
             ACTION PageSetupSave() ;
             WIDTH 80 HEIGHT 25

  @ 370, 315 BUTTON btCancel ; 
             CAPTION 'Cancel' ;  
             ACTION wPageSetup.RELEASE ; 
             WIDTH 80 HEIGHT 25

  bHeader:EVAL(lPrintHead)
  ON KEY RETURN ACTION PageSetupSave()
  ON KEY ESCAPE ACTION wPageSetup.RELEASE

END WINDOW 
   
ACTIVATE WINDOW wPageSetup

RETURN // PageSetup

//***************************************************************************

STATIC PROCEDURE PageSetupSave

nPrintLeft     := wPageSetup.tbLeftMargin.VALUE
nPrintRight    := wPageSetup.tbRightMargin.VALUE
nPrintTop      := wPageSetup.tbTopMargin.VALUE
nPrintBottom   := wPageSetup.tbBottomMargin.VALUE
nPrintRow      := wPageSetup.tbHeaderRow.VALUE
nPrintCol      := wPageSetup.tbHeaderCol.VALUE
lPrintHead     := wPageSetup.cbHeader.VALUE
lPrintNumHead  := wPageSetup.cbPageNumber.VALUE
cPrintPreHead  := ALLTRIM(wPageSetup.tbHeaderPreText.VALUE)
cPrintPostHead := ALLTRIM(wPageSetup.tbHeaderPostText.VALUE)

wPageSetup.RELEASE

RETURN // PageSetupSave

//***************************************************************************

STATIC PROCEDURE Associations

LOCAL lDeskShort, lMenuShort, lRtfAssoc, lTxtAssoc

DEFINE WINDOW wAssoc ; 
  AT wMain.ROW + 145, wMain.COL + 10 ;
  WIDTH 490 HEIGHT 240 ; 
  TITLE 'Shortcuts and file associations' ; 
  MODAL NOSIZE ;
  ON INIT AssocInit(@lDeskShort, @lMenuShort, @lRtfAssoc, @lTxtAssoc)

  @  10,  10 LABEL lbWarn ;
             VALUE 'Run this program as Administrator to change the following settings.' BOLD ;
             AUTOSIZE

  @  40,  10 CHECKBOX ckDeskShort ;
             CAPTION 'Include WordWriter shortcut on desktop' ;
             WIDTH 470 ;
             VALUE .N.

  @  70,  10 CHECKBOX ckMenuShort ;
             CAPTION 'Include WordWriter shortcut on start menu' ;
             WIDTH 470 ;
             VALUE .N.

  @ 100,  10 CHECKBOX ckRtfMenu ;
             CAPTION 'Include WordWriter as "Open with" item on right click menu for RTF files' ;
             WIDTH 470 ;
             VALUE .N.

  @ 130,  10 CHECKBOX ckTxtMenu ;
             CAPTION 'Include WordWriter as "Open with" item on right click menu for TXT files' ;
             WIDTH 470 ;
             VALUE .N.

  @ 170, 160 BUTTON btOk ;
             CAPTION 'OK' ;  
             ACTION AssocSet(lDeskShort, lMenuShort, lRtfAssoc, lTxtAssoc) ;
             WIDTH 80 HEIGHT 25

  @ 170, 250 BUTTON btCancel ; 
             CAPTION 'Cancel' ;  
             ACTION wAssoc.RELEASE ;
             WIDTH 80 HEIGHT 25

  ON KEY RETURN ACTION AssocSet(lDeskShort, lMenuShort, lRtfAssoc, lTxtAssoc)
  ON KEY ESCAPE ACTION wAssoc.RELEASE

END WINDOW 

ACTIVATE WINDOW wAssoc

RETURN // Associations

//***************************************************************************

STATIC PROCEDURE AssocInit(lDeskShort, lMenuShort, lRtfAssoc, lTxtAssoc)

LOCAL cThisExe := GETPROGRAMFILENAME()
LOCAL cDeskDir := C_GETSPECIALFOLDER(CSIDL_COMMON_DESKTOPDIRECTORY) + '\'
LOCAL cMenuDir := C_GETSPECIALFOLDER(CSIDL_COMMON_STARTMENU) + '\Programs\'
LOCAL cData

lDeskShort := FILE(cDeskDir + 'WordWriter.lnk')
lMenuShort := FILE(cMenuDir + 'WordWriter.lnk')

BEGIN SEQUENCE
  cData := WIN_REGREAD('HKLM\Software\Classes\.rtf\OpenWithProgIds\WordWriter.rtf')
  IF !HB_ISSTRING(cData)
    lRtfAssoc := .N.
    BREAK
  END
  cData := WIN_REGREAD('HKLM\Software\Classes\WordWriter.rtf\shell\open\command\')
  IF HB_ISSTRING(cData) .AND. HMG_UPPER(cThisExe) $ HMG_UPPER(cData)
    lRtfAssoc := .Y.    
    BREAK
  END
  lRtfAssoc := .N.
END SEQUENCE

BEGIN SEQUENCE
  cData := WIN_REGREAD('HKLM\Software\Classes\.txt\OpenWithProgIds\WordWriter.txt')
  IF !HB_ISSTRING(cData)
    lTxtAssoc := .N.
    BREAK
  END
  cData := WIN_REGREAD('HKLM\Software\Classes\WordWriter.txt\shell\open\command\')
  IF HB_ISSTRING(cData) .AND. HMG_UPPER(cThisExe) $ HMG_UPPER(cData)
    lTxtAssoc := .Y.    
    BREAK
  END
  lTxtAssoc := .N.
END SEQUENCE

wAssoc.ckDeskShort.VALUE := lDeskShort
wAssoc.ckMenuShort.VALUE := lMenuShort
wAssoc.ckRtfMenu.VALUE   := lRtfAssoc
wAssoc.ckTxtMenu.VALUE   := lTxtAssoc

RETURN // AssocInit

//***************************************************************************

STATIC PROCEDURE AssocSet(lDeskShort, lMenuShort, lRtfAssoc, lTxtAssoc)

LOCAL cDeskDir := C_GETSPECIALFOLDER(CSIDL_COMMON_DESKTOPDIRECTORY) + '\'
LOCAL cMenuDir := C_GETSPECIALFOLDER(CSIDL_COMMON_STARTMENU) + '\Programs\'
LOCAL cThisExe := GETPROGRAMFILENAME()
LOCAL cData

DO CASE
CASE !lDeskShort .AND. wAssoc.ckDeskShort.VALUE
  MAKEFDIRSHORTCUT(cThisExe, 'WordWriter',, cDeskDir)
CASE lDeskShort .AND. !wAssoc.ckDeskShort.VALUE
  FERASE(cDeskDir + 'WordWriter.lnk')
END

DO CASE
CASE !lMenuShort .AND. wAssoc.ckMenuShort.VALUE
  MAKEFDIRSHORTCUT(cThisExe, 'WordWriter',, cMenuDir)
CASE lMenuShort .AND. !wAssoc.ckMenuShort.VALUE
  FERASE(cMenuDir + 'WordWriter.lnk')
END

DO CASE
CASE !lRtfAssoc .AND. wAssoc.ckRtfMenu.VALUE
  cData := WIN_REGREAD('HKLM\Software\Classes\.rtf\OpenWithProgIds\WordWriter.rtf')
  IF !HB_ISSTRING(cData)
    WIN_REGWRITE('HKLM\Software\Classes\.rtf\OpenWithProgIds\WordWriter.rtf', '')
  END
  WIN_REGWRITE('HKLM\Software\Classes\WordWriter.rtf\', 'Rich Text Document')
  WIN_REGWRITE('HKLM\Software\Classes\WordWriter.rtf\shell\open\command\', '"' + cThisExe + '" "%1"')
CASE lRtfAssoc .AND. !wAssoc.ckRtfMenu.VALUE
  WIN_REGDELETE('HKLM\Software\Classes\.rtf\OpenWithProgIds\WordWriter.rtf')
  WIN_REGDELETE('HKLM\Software\Classes\WordWriter.rtf\shell\open\command\')
  WIN_REGDELETE('HKLM\Software\Classes\WordWriter.rtf\shell\open\')
  WIN_REGDELETE('HKLM\Software\Classes\WordWriter.rtf\shell\')
  WIN_REGDELETE('HKLM\Software\Classes\WordWriter.rtf\DefaultIcon\')
  WIN_REGDELETE('HKLM\Software\Classes\WordWriter.rtf\')
END

DO CASE
CASE !lTxtAssoc .AND. wAssoc.ckTxtMenu.VALUE
  cData := WIN_REGREAD('HKLM\Software\Classes\.txt\OpenWithProgIds\WordWriter.txt')
  IF !HB_ISSTRING(cData)
    WIN_REGWRITE('HKLM\Software\Classes\.txt\OpenWithProgIds\WordWriter.txt', '')
  END
  WIN_REGWRITE('HKLM\Software\Classes\WordWriter.txt\', 'Text Document')
  WIN_REGWRITE('HKLM\Software\Classes\WordWriter.txt\shell\open\command\', '"' + cThisExe + '" "%1"')
CASE lTxtAssoc .AND. !wAssoc.ckTxtMenu.VALUE
  WIN_REGDELETE('HKLM\Software\Classes\.txt\OpenWithProgIds\WordWriter.txt')
  WIN_REGDELETE('HKLM\Software\Classes\WordWriter.txt\shell\open\command\')
  WIN_REGDELETE('HKLM\Software\Classes\WordWriter.txt\shell\open\')
  WIN_REGDELETE('HKLM\Software\Classes\WordWriter.txt\shell\')
  WIN_REGDELETE('HKLM\Software\Classes\WordWriter.txt\DefaultIcon\')
  WIN_REGDELETE('HKLM\Software\Classes\WordWriter.txt\')
END

wAssoc.RELEASE

RETURN // AssocSet

//***************************************************************************

STATIC PROCEDURE Bold

wMain.ebDoc.FONTBOLD := !(wMain.ebDoc.FONTBOLD)
Refresh()

RETURN // Bold

//***************************************************************************

STATIC PROCEDURE Italic

wMain.ebDoc.FONTITALIC := !(wMain.ebDoc.FONTITALIC)
Refresh()

RETURN // Italic

//***************************************************************************

STATIC PROCEDURE Underline

wMain.ebDoc.FONTUNDERLINE := !(wMain.ebDoc.FONTUNDERLINE)
Refresh()

RETURN // Underline

//***************************************************************************

STATIC PROCEDURE Strikethrough

wMain.ebDoc.FONTSTRIKEOUT := !(wMain.ebDoc.FONTSTRIKEOUT)
Refresh()

RETURN // Strikethrough

//***************************************************************************

STATIC PROCEDURE Subscript

wMain.ebDoc.FONTSCRIPT := IF(wMain.ebDoc.FONTSCRIPT == RTF_SUBSCRIPT, ;
  RTF_NORMALSCRIPT, RTF_SUBSCRIPT)
Refresh()

RETURN // Subscript

//***************************************************************************

STATIC PROCEDURE Superscript

wMain.ebDoc.FONTSCRIPT := IF(wMain.ebDoc.FONTSCRIPT == RTF_SUPERSCRIPT, ;
  RTF_NORMALSCRIPT, RTF_SUPERSCRIPT)
Refresh()

RETURN // Superscript

//***************************************************************************

STATIC PROCEDURE AlignLeft

wMain.ebDoc.PARAALIGNMENT := RTF_LEFT
Refresh()

RETURN // AlignLeft

//***************************************************************************

STATIC PROCEDURE AlignCenter

wMain.ebDoc.PARAALIGNMENT := RTF_CENTER
Refresh()

RETURN // AlignCenter

//***************************************************************************

STATIC PROCEDURE AlignRight

wMain.ebDoc.PARAALIGNMENT := RTF_RIGHT
Refresh()

RETURN // AlignRight

//***************************************************************************

STATIC PROCEDURE AlignJustify

wMain.ebDoc.PARAALIGNMENT := RTF_JUSTIFY
Refresh()

RETURN // AlignJustify

//***************************************************************************

STATIC PROCEDURE MakeLink

wMain.ebDoc.LINK := .Y.

RETURN // MakeLink

//***************************************************************************

STATIC PROCEDURE ClearUndoBuffer

wMain.ebDoc.CLEARUNDOBUFFER()
wMain.imUndo.ENABLED := .N.
wMain.imRedo.ENABLED := .N.

RETURN // ClearUndoBuffer

//***************************************************************************

STATIC PROCEDURE Copy

wMain.ebDoc.SELCOPY()

RETURN // Copy

//***************************************************************************

STATIC PROCEDURE Cut

wMain.ebDoc.SELCUT()

RETURN // Cut

//***************************************************************************

STATIC PROCEDURE Paste

wMain.ebDoc.SELPASTE()

RETURN // Paste

//***************************************************************************

STATIC PROCEDURE PasteUnformatted

LOCAL cStr   := GETCLIPBOARD()
LOCAL nCaret := wMain.ebDoc.CARETPOS

wMain.ebDoc.ADDTEXT(nCaret) := cStr
wMain.ebDoc.CARETPOS := nCaret + HB_UTF8LEN(cStr)

RETURN // PasteUnformatted

//***************************************************************************

STATIC PROCEDURE Deleter

wMain.ebDoc.SELCLEAR()

RETURN // Deleter

//***************************************************************************

STATIC PROCEDURE FindText

cFind := wMain.ebDoc.GETSELECTTEXT

FINDTEXTDIALOG ON ACTION DoFindReplace() ;
  FIND cFind CHECKDOWN lDown CHECKMATCHCASE lMatchCase ;
  CHECKWHOLEWORD lWholeWord

RETURN // FindText

//***************************************************************************

STATIC PROCEDURE ReplaceText

cFind := wMain.ebDoc.GETSELECTTEXT

REPLACETEXTDIALOG ON ACTION DoFindReplace() ;
  FIND cFind REPLACE cReplace CHECKMATCHCASE lMatchCase ;
  CHECKWHOLEWORD lWholeWord

RETURN // ReplaceText

//***************************************************************************

STATIC PROCEDURE DoFindReplace

LOCAL lSelectFindText
LOCAL aPosRange := {0,0}

IF FindReplaceDlg.RETVALUE == FRDLG_CANCEL   
   RETURN
END

cFind           := FindReplaceDlg.FIND
cReplace        := FindReplaceDlg.REPLACE
lDown           := FindReplaceDlg.DOWN
lMatchCase      := FindReplaceDlg.MATCHCASE
lWholeWord      := FindReplaceDlg.WHOLEWORD
lSelectFindText := .Y.

SWITCH FindReplaceDlg.RETVALUE
CASE FRDLG_FINDNEXT
  aPosRange := wMain.ebDoc.FINDTEXT(cFind, lDown, lMatchCase, lWholeWord, lSelectFindText)
  EXIT
CASE FRDLG_REPLACE
  aPosRange := wMain.ebDoc.REPLACETEXT(cFind, cReplace, lMatchCase, lWholeWord, lSelectFindText)
  EXIT
CASE FRDLG_REPLACEALL
  aPosRange := wMain.ebDoc.REPLACEALLTEXT(cFind, cReplace, lMatchCase, lWholeWord, lSelectFindText)
  EXIT
END

IF aPosRange[1] == -1
   MSGINFO('Cannot find the text:' + HB_OSNEWLINE() + cFind)
ELSE
   MoveFindReplace(aPosRange[1])
END

RETURN // DoFindReplace

//***************************************************************************

STATIC PROCEDURE MoveFindReplace(nPos)

LOCAL CharRowCol := wMain.ebDoc.GETPOSCHAR(nPos)

IF CharRowCol[1] != -1 .AND. CharRowCol[2] != -1
  IF FindReplaceDlg.HEIGHT + OFFSET_DLG < CharRowCol[1]
    FindReplaceDlg.Row := CharRowCol[1] - (FindReplaceDlg.HEIGHT + OFFSET_DLG)
  ELSEIF FindReplaceDlg.Row < CharRowCol[1] + OFFSET_DLG
    FindReplaceDlg.Row := CharRowCol[1] + OFFSET_DLG
  END
END

RETURN // MoveFindReplace

//***************************************************************************

STATIC PROCEDURE FontFormat

LOCAL aFont := GETFONT( ;
  wMain.ebDoc.FONTNAME     , ;
  wMain.ebDoc.FONTSIZE     , ;
  wMain.ebDoc.FONTBOLD     , ;
  wMain.ebDoc.FONTITALIC   , ;
  wMain.ebDoc.FONTCOLOR    , ;
  wMain.ebDoc.FONTUNDERLINE, ;
  wMain.ebDoc.FONTSTRIKEOUT  )

LOCAL aDiff    := ARRAY(LEN(aFontSizeValue))
LOCAL nNewSize := aFont[2]
LOCAL nMinPos  := 1
LOCAL nMinDiff := 0

IF !EMPTY(aFont[1])
  AEVAL(aDiff, {|xRow, nPos| ;
    aDiff[nPos] := ABS(aFontSizeValue[nPos] - nNewSize)})
  nMinDiff := aDiff[nMinPos]
  AEVAL(aDiff, {|nDiff, nPos| ;
    IF(nDiff < nMinDiff, (nMinPos := nPos, nMinDiff := nDiff), NIL)}, 2)
  aFont[2] := aFontSizeValue[nMinPos]
  wMain.ebDoc.FONTNAME          := (cFontName := aFont[1])
  wMain.ebDoc.FONTSIZE          := (nFontSize := aFont[2])
  wMain.ebDoc.FONTBOLD          := aFont[3]
  wMain.ebDoc.FONTITALIC        := aFont[4]
  wMain.ebDoc.FONTCOLOR         := (aFontForeColor := aFont[5])
  wMain.ebDoc.FONTUNDERLINE     := aFont[6]
  wMain.ebDoc.FONTSTRIKEOUT     := aFont[7]
  Refresh()
END

RETURN // FontFormat

//***************************************************************************

STATIC PROCEDURE ListFormat

LOCAL aListRowCol := EX.wMain.taTop.GETSCREENPOS( ;
  wMain.imListApply.ROW + wMain.imListApply.HEIGHT, wMain.imListApply.COL)

DEFINE WINDOW wList ;
  AT aListRowCol[1], aListRowCol[2] ;
  WIDTH 410 HEIGHT 335 ; 
  MODAL NOSIZE NOCAPTION

  EX.wList.DRAWBORDER

  @  35,  10 FRAME frList ;
             CAPTION 'List style' ;
             WIDTH 230 HEIGHT 210

  @  60,  20 RADIOGROUP rgNumFormat ;
             OPTIONS aNumFormatLabel ;  
             VALUE nNumFormat ;  
             WIDTH 210 ;
             SPACING 25 ;
             ON CHANGE ListUpdate()

  @  35, 250 FRAME frNum ;
             CAPTION 'Numbering' ;
             WIDTH 150 HEIGHT 210
    
  @  60, 260 RADIOGROUP rgNumStyle ;
             OPTIONS aNumStyleLabel ;  
             VALUE nNumStyle ;  
             WIDTH 130 ;
             SPACING 25 ;
             ON CHANGE ListUpdate()

  @ 195, 260 LABEL laNumStart ;
             VALUE 'Start with' ;
             AUTOSIZE

  @ 195, 350 TEXTBOX tbNumStart ;
             WIDTH 40 ;
             VALUE nNumStart ;
             NUMERIC INPUTMASK '999'

  @ 245,  95 FRAME frSample ;
             CAPTION '' ;
             WIDTH 230 HEIGHT 40

  @ 260, 105 LABEL laNumSample ;
             VALUE ListSample(nNumFormat, nNumStyle) ;
             WIDTH 205 HEIGHT 20

  @ 295, 165 BUTTON btOk ;
             CAPTION 'OK' ;  
             ACTION ListSave() ; 
             WIDTH 80 HEIGHT 25

  @  10, 375 BUTTON btCancel ;
             CAPTION '×' BOLD FLAT ; // U+00D7 MULTIPLICATION SIGN
             ACTION wList.RELEASE ;
             WIDTH 25 HEIGHT 25

  ON KEY RETURN ACTION ListSave()
  ON KEY ESCAPE ACTION wList.RELEASE

END WINDOW 

ACTIVATE WINDOW wList

RETURN // ListFormat

//***************************************************************************

STATIC PROCEDURE ListUpdate

wList.laNumSample.VALUE := ;
  ListSample(wList.rgNumFormat.VALUE, wList.rgNumStyle.VALUE)

RETURN // ListUpdate

//***************************************************************************

STATIC FUNCTION ListSample(nFormat, nStyle)

LOCAL aFormat := aNumFormatMark[nFormat]
LOCAL aStyle  := aNumStyleMark[nStyle]
LOCAL cBullet := ''
LOCAL cSample := ''

IF !aFormat[2]
  wList.rgNumStyle.ENABLED := .N.
  cBullet := aFormat[1]
ELSE
  wList.rgNumStyle.ENABLED := .Y.
  IF !aStyle[2]
     cBullet := ''
  ELSE
     cBullet := aStyle[1] + aFormat[1] + aStyle[3]
  END
END
cSample := cBullet + '   Sample list item'

RETURN cSample // ListInit

//***************************************************************************

STATIC FUNCTION ListLabel

LOCAL cLabel := E"Apply list to text\nList style: " + ;
  aNumFormatLabel[nNumFormat] + ;
  IF(aNumFormatMark[nNumFormat][2], ;
  E"\nNumbering style: " + aNumStyleLabel[nNumStyle], '')

RETURN cLabel // ListLabel

//***************************************************************************

STATIC PROCEDURE ListSave

nNumFormat := wList.rgNumFormat.VALUE
nNumStyle  := wList.rgNumStyle.VALUE
nNumStart  := wList.tbNumStart.VALUE
wMain.laListApply.TOOLTIP := ListLabel()
wList.RELEASE
ListApply()

RETURN // ListSave

//***************************************************************************

STATIC PROCEDURE ListApply

wMain.ebDoc.PARANUMBERING := aNumFormatRef[nNumFormat]
wMain.ebDoc.PARAOFFSET := 5        
IF aNumFormatMark[nNumFormat][2]
  wMain.ebDoc.PARANUMBERINGSTYLE := aNumStyleRef[nNumStyle]
  wMain.ebDoc.PARANUMBERINGSTART := nNumStart
ELSE
  wMain.ebDoc.PARANUMBERINGSTYLE := RTF_NONE
  wMain.ebDoc.PARANUMBERINGSTART := 0
END

RETURN // ListApply

//***************************************************************************

STATIC PROCEDURE LineSpace

LOCAL aLineSpaceRowCol := EX.wMain.taTop.GETSCREENPOS( ;
  wMain.imLineSpaceApply.ROW + wMain.imLineSpaceApply.HEIGHT, wMain.imLineSpaceApply.COL)

DEFINE WINDOW wLineSpace ; 
  AT aLineSpaceRowCol[1], aLineSpaceRowCol[2] ;
  WIDTH 140 HEIGHT 245 ; 
  MODAL NOSIZE NOCAPTION ;
  ON INIT LineSpaceInit()

  EX.wLineSpace.DRAWBORDER

  @  35,  10 FRAME frLineSpace ;
             CAPTION 'Line spacing' ;
             WIDTH 120 HEIGHT 160

  @  60,  50 RADIOGROUP rgLineSpace ;
             OPTIONS aSpaceLabel ;  
             VALUE 1 ;  
             WIDTH 60 ;
             SPACING 25

  @ 205,  30 BUTTON btOk ;
             CAPTION 'OK' ;  
             ACTION LineSpaceSave() ; 
             WIDTH 80 HEIGHT 25

  @  10, 105 BUTTON btCancel ; 
             CAPTION '×' BOLD FLAT ; // U+00D7 MULTIPLICATION SIGN
             ACTION wLineSpace.RELEASE ; 
             WIDTH 25 HEIGHT 25

  ON KEY RETURN ACTION LineSpaceSave()
  ON KEY ESCAPE ACTION wLineSpace.RELEASE

END WINDOW 

ACTIVATE WINDOW wLineSpace

RETURN // LineSpace

//***************************************************************************

STATIC PROCEDURE LineSpaceInit

LOCAL nPos := ASCAN(aSpaceValue, nSpaceValue)

wLineSpace.rgLineSpace.VALUE := IF(EMPTY(nPos), 1, nPos)

RETURN // LineSpaceInit

//***************************************************************************

STATIC PROCEDURE LineSpaceSave

nSpaceValue := aSpaceValue[wLineSpace.rgLineSpace.VALUE]
wMain.laLineSpaceApply.TOOLTIP := ;
  E"Apply line spacing\nLine spacing: " + HB_NTOS(nSpaceValue)
wLineSpace.RELEASE
LineSpaceApply()

RETURN // LineSpaceSave

//***************************************************************************

STATIC PROCEDURE LineSpaceApply

wMain.ebDoc.PARALINESPACING := nSpaceValue

RETURN // LineSpaceApply

//***************************************************************************

STATIC PROCEDURE IndentOffset

LOCAL aInOffRowCol := EX.wMain.taTop.GETSCREENPOS( ;
  wMain.imIndentLeft.ROW + wMain.imIndentLeft.HEIGHT, wMain.imIndentLeft.COL)

DEFINE WINDOW wInOff ; 
  AT aInOffRowCol[1], aInOffRowCol[2] ;
  WIDTH 230 HEIGHT 200 ;
  MODAL NOSIZE NOCAPTION

  EX.wInOff.DRAWBORDER

  @  35,  10 FRAME frIndent ;
             CAPTION 'Indent text' ;
             WIDTH 210 HEIGHT 55

  @  60,  20 LABEL laIndent ;
             VALUE 'Indent from left (mm)' ;
             AUTOSIZE

  @  60, 170 TEXTBOX tbIndent ;
             WIDTH 40 ;
             VALUE wMain.ebDoc.PARAINDENT ;
             NUMERIC INPUTMASK '99'

  @  95,  10 FRAME frOffset ;
             CAPTION 'Offset text' ;
             WIDTH 210 HEIGHT 55
            
  @ 120,  20 LABEL laOffset ; 
             VALUE 'Offset from left (mm)' ;
             AUTOSIZE

  @ 120, 170 TEXTBOX tbOffset ; 
             WIDTH 40 ;
             VALUE wMain.ebDoc.PARAOFFSET ;
             NUMERIC INPUTMASK '99'

  @ 160,  75 BUTTON btOk ;
             CAPTION 'OK' ;  
             ACTION IndentOffsetSave() ;
             WIDTH 80 HEIGHT 25

  @  10, 195 BUTTON btCancel ; 
             CAPTION '×' BOLD FLAT ; // U+00D7 MULTIPLICATION SIGN
             ACTION wInOff.RELEASE ; 
             WIDTH 25 HEIGHT 25

  ON KEY RETURN ACTION IndentOffsetSave()
  ON KEY ESCAPE ACTION wInOff.RELEASE

END WINDOW 

ACTIVATE WINDOW wInOff

RETURN // IndentOffset

//***************************************************************************

STATIC PROCEDURE IndentOffsetSave

wMain.ebDoc.PARAINDENT := wInOff.tbIndent.VALUE
wMain.ebDoc.PARAOFFSET := wInOff.tbOffset.VALUE
wInOff.RELEASE

RETURN // IndentOffsetSave

//***************************************************************************

STATIC PROCEDURE IndentLeft

wMain.ebDoc.PARAINDENT := MIN(MAX_PARAINDENT, wMain.ebDoc.PARAINDENT - 5)

RETURN // IndentLeft

//***************************************************************************

STATIC PROCEDURE IndentRight

wMain.ebDoc.PARAINDENT := MAX(MIN_PARAINDENT, wMain.ebDoc.PARAINDENT + 5)

RETURN // IndentRight

//***************************************************************************

STATIC PROCEDURE FontForeColor

LOCAL aGetColor := GETCOLOR(aFontForeColor, NIL, .Y.)

IF VALTYPE(aFontForeColor[1]) == 'N'
  wMain.ebDoc.FONTCOLOR := (aFontForeColor := aGetColor)
END

RETURN // FontForeColor

//***************************************************************************

STATIC PROCEDURE FontBackColor

LOCAL aGetColor := GETCOLOR(aFontBackColor, NIL, .Y.)

IF VALTYPE(aGetColor[1]) == 'N'
  wMain.ebDoc.FONTBACKCOLOR := (aFontBackColor := aGetColor)
END

RETURN // FontBackColor

//***************************************************************************

STATIC PROCEDURE DocBackColor

LOCAL aGetColor := GETCOLOR(aDocBackColor, NIL, .Y.)

IF VALTYPE(aGetColor[1]) == 'N'
  wMain.ebDoc.BACKGROUNDCOLOR := (aDocBackColor := aGetColor)
END

RETURN // DocBackColor

//***************************************************************************

STATIC PROCEDURE Zoom

LOCAL aZoomRowCol := EX.wMain.taTop.GETSCREENPOS( ;
  wMain.coZoom.ROW + wMain.imWordWrap.HEIGHT, wMain.coZoom.COL)

DEFINE WINDOW wZoom ; 
  AT aZoomRowCol[1], aZoomRowCol[2] ;
  WIDTH 140 HEIGHT 320 ; 
  MODAL NOSIZE NOCAPTION ;
  ON INIT ZoomInit()

  EX.wZoom.DRAWBORDER

  @  35,  10 FRAME frZoom ;
             CAPTION 'Zoom' ;
             WIDTH 120 HEIGHT 235

  @  60,  45 RADIOGROUP rgZoom ;
             OPTIONS aZoomLabel ;  
             VALUE 1 ;  
             WIDTH 60 ;
             SPACING 25

  @ 280,  30 BUTTON btOk ;
             CAPTION 'OK' ;  
             ACTION ZoomSave() ;
             WIDTH 80 HEIGHT 25

  @  10, 105 BUTTON btCancel ; 
             CAPTION '×' BOLD FLAT ; // U+00D7 MULTIPLICATION SIGN
             ACTION wZoom.RELEASE ; 
             WIDTH 25 HEIGHT 25

  ON KEY RETURN ACTION ZoomSave()
  ON KEY ESCAPE ACTION wZoom.RELEASE

END WINDOW 

ACTIVATE WINDOW wZoom

RETURN // Zoom

//***************************************************************************

STATIC PROCEDURE ZoomInit

LOCAL nPos := ASCAN(aZoomPercentage, nZoomValue)

wZoom.rgZoom.VALUE := IF(EMPTY(nPos), 1, nPos)

RETURN // ZoomInit

//***************************************************************************

STATIC PROCEDURE ZoomSave

nZoomValue := aZoomPercentage[wZoom.rgZoom.VALUE]
wZoom.RELEASE
wMain.ebDoc.ZOOM := nZoomValue

RETURN // ZoomSave

//***************************************************************************

STATIC PROCEDURE ZoomIn

LOCAL nPos1 := ASCAN(aZoomPercentage, nZoomValue)
LOCAL nPos2 := MAX(1, IF(EMPTY(nPos1), 5, nPos1) - 1)

nZoomValue := aZoomPercentage[nPos2]
wMain.ebDoc.ZOOM := nZoomValue

RETURN // ZoomIn

//***************************************************************************

STATIC PROCEDURE ZoomOut

LOCAL nPos1 := ASCAN(aZoomPercentage, nZoomValue)
LOCAL nPos2 := MIN(LEN(aZoomPercentage), IF(EMPTY(nPos1), 5, nPos1) + 1)

nZoomValue := aZoomPercentage[nPos2]
wMain.ebDoc.ZOOM := nZoomValue

RETURN // ZoomIn

//***************************************************************************

STATIC PROCEDURE WordWrap

DefineDoc(!lWordWrap)

RETURN // WordWrap

//***************************************************************************

STATIC PROCEDURE StatusBar

lStatusBar := !lStatusBar
DocSize()
Refresh()

RETURN // StatusBar

//***************************************************************************

STATIC PROCEDURE Shortcuts

LOCAL cShortFile := GETSTARTUPFOLDER() + '\Shortcuts.chm'

IF FILE(cShortFile)
  SHELLEXECUTE(NIL, 'Open', cShortFile, NIL, NIL, SW_SHOWNORMAL)
ELSE
  MSGEXCLAMATION('Cannot open ' + cShortFile, 'Shortcuts')
END

RETURN // Shortcuts

//***************************************************************************

STATIC PROCEDURE About

DEFINE WINDOW wAbout ; 
  AT 0, 0 ;
  WIDTH 575 HEIGHT 245 ;
  TITLE 'About ' + cTitle ;
  MODAL NOSIZE

  @  10,  10 IMAGE imProduct ;
             PICTURE 'MainImage'

  @  10, 160 LABEL laName ;
             VALUE cTitle ;
             AUTOSIZE ;
             FONT 'Verdana' ;
             SIZE 24

  @  50, 160 LABEL laVersion ;
             VALUE 'Version ' + cVersion ;
             AUTOSIZE

  @  70, 160 LABEL laCopyright ;
             VALUE cCopyright ;
             AUTOSIZE

  @  90, 160 LABEL laByline2 ;
             VALUE cByline2 ;
             AUTOSIZE

  @ 110, 160 LABEL laByline3 ;
             VALUE cByline3 ;
             AUTOSIZE

  @ 130, 160 LABEL laByline4 ;
             VALUE cByline4 ;
             AUTOSIZE

  @ 150, 160 HYPERLINK hyProduct ;
             VALUE   'Made with HMG' ;
             ADDRESS cInfoAddr ;
             AUTOSIZE

  @ 175, 260 BUTTON btOk ;
             CAPTION '&Ok' ;
             ACTION wAbout.RELEASE ;
             WIDTH 55 HEIGHT 25

  ON KEY RETURN ACTION wAbout.RELEASE
  ON KEY ESCAPE ACTION wAbout.RELEASE

END WINDOW 

CENTER WINDOW wAbout
ACTIVATE WINDOW wAbout

RETURN // About

//***************************************************************************

PROCEDURE MsgDbg(cStat, ...)

LOCAL aVars := {...}
LOCAL cName := ''
LOCAL cType := ''
LOCAL cVal  := ''
LOCAL cVars := ''
LOCAL nVar  := 0
LOCAL nVars := LEN(aVars)
LOCAL xVal  := NIL

FOR nVar := 1 TO nVars STEP 2
  cName := aVars[nVar]
  xVal  := aVars[nVar + 1]
  cType := VALTYPE(xVal)
  // cVal := HB_VALTOEXP(xVal)
  SWITCH cType
  CASE 'C'
  CASE 'M'
    cVal := IF('"' $ xVal, "'" + xVal + "'", '"' + xVal + '"')
    EXIT
  CASE 'N'
    cVal := LTRIM(STR(xVal))
    EXIT
  CASE 'D'
    cVal := 'd"' + LEFT(HB_TSTOSTR(xVal, .Y.), 10) + '"'
    EXIT
  CASE 'T'
    cVal := 't"' + HB_TSTOSTR(xVal, .Y.) + '"'
    EXIT
  CASE 'L'
    cVal := '.' + TRANSFORM(xVal, 'Y') + '.'
    EXIT
  CASE 'A'
    cVal := 'ARRAY(' + LTRIM(STR(LEN(xVal))) + ')'
    EXIT
  CASE 'H'
    cVal := 'HASHN(' + LTRIM(STR(LEN(xVal))) + ')'
    EXIT
  CASE 'O'
    cVal := xVal:CLASSNAME + ' object'
    EXIT
  CASE 'B'
    cVal := '{|_| _}'
    EXIT
  CASE 'S'
    cVal := '@' + xVal:NAME + '()'
    EXIT
  CASE 'P'
    cVal := '<Pointer 0x' + NUMTOHEX(xVal) + '>'
    EXIT
  CASE 'U'
    cVal := 'NIL'
    EXIT
  OTHERWISE
    cVal := 'Unknown type ' + cType
  END
  cVars += cName + ' = ' + cVal + CRLF
NEXT

IF !MSGYESNO(cVars + CRLF + CRLF + 'Continue?', ;
  IF(EMPTY(cStat), 'Debug', cStat))
  wMain.RELEASE
END

RETURN // MsgDbg

//***************************************************************************
