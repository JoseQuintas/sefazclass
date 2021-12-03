/**
 *
 * WordScribe
 *
 * Based on the Rich Edit demo.
 *
 * Copyright 2003-2009 by Janusz Pora <JanuszPora@onet.eu>
 *
 * Adapted and Enhanced for HMG by Dr. Claudio Soto, April 2014
 *
 * Enhanced for HMG by Kevin Carmody, April 2016
 *
*/

//***************************************************************************

#include "hmg.ch"
#include "hfcl.ch"

#define MIN_PARAINDENT   0 // in mm
#define MAX_PARAINDENT   150 // in mm
#define OFFSET_DLG       30

//***************************************************************************

MEMVAR _HMG_SYSDATA

STATIC cTitle           := 'WordScribe'
STATIC cVersion         := '2.5'
STATIC cCopyright       := 'Copyright © 2003–2009 Janusz Pora' // U+00A9 COPYRIGHT SIGN / U+2013 EN DASH
STATIC cByline2         := 'Enhanced by Dr. Claudio Soto, April 2014'
STATIC cByline3         := 'Enhanced by Kevin Carmody, April 2016'
STATIC cInfoAddr        := 'http://sites.google.com/site/hmgweb/'
STATIC cRegBase         := 'HKEY_CURRENT_USER\Software\WordScribe\'

STATIC nMainRow         := 0
STATIC nMainCol         := 0
STATIC nMainWidth       := 800
STATIC nMainHeight      := 600
STATIC lMainMax         := .N.

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
STATIC aNumFormatLabel  := { ;
  'No bullets or numbering' , ; // RTF_NOBULLETNUMBER
  'Bullets'                 , ; // RTF_BULLET
  'Arabic numerals'         , ; // RTF_ARABICNUMBER
  'Lowercase letters'       , ; // RTF_LOWERCASELETTER
  'Lowercase Roman numerals', ; // RTF_UPPERCASELETTER
  'Uppercase letters'       , ; // RTF_LOWERCASEROMANNUMBER
  'Uppercase Roman numerals'  } // RTF_UPPERCASEROMANNUMBER
STATIC aNumStyleLabel   := { ;
  'Right parenthesis', ; // RTF_PAREN
  'Two parentheses'  , ; // RTF_PARENS
  'Period'           , ; // RTF_PERIOD
  'No punctuation'   , ; // RTF_PLAIN
  'Hidden number'      } // RTF_NONUMBER
  
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

LOCAL aViewRect := {}
LOCAL cDots     := '…' // U+2026 HORIZONTAL ELLIPSIS

DEFINE WINDOW wMain ;
  AT nMainRow, nMainCol ;
  WIDTH nMainWidth HEIGHT nMainHeight ;
  TITLE cTitle ;
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
  ON KEY F1               ACTION ShortCuts()

  DefineMenu()

  DEFINE CONTEXT MENU  

    ITEM '&Copy'               ACTION Copy()
    ITEM 'C&ut'                ACTION Cut()
    ITEM '&Paste'              ACTION Paste()
    SEPARATOR
    ITEM 'Select &all'         ACTION SelectAll()
    SEPARATOR
    ITEM '&Find' + cDots       ACTION FindText()
    ITEM '&Replace' + cDots    ACTION ReplaceText()
    SEPARATOR
    ITEM 'F&ont' + cDots       ACTION FontFormat()
    ITEM 'Para&graph' + cDots  ACTION ParagraphFormat()

  END MENU

  DEFINE SPLITBOX

    DEFINE TOOLBAR tlFile BUTTONSIZE 23,23 FLAT

      BUTTON btNew ;
        TOOLTIP 'New file' ;
        PICTURE 'New' ;
        ACTION NewFile()

      BUTTON btOpen ;
        TOOLTIP 'Open file' ;
        PICTURE 'Open' ;
        ACTION OpenFile()

      BUTTON btClose ;
        TOOLTIP 'Close' ;
        PICTURE 'Close' ;
        ACTION CloseFile()

      BUTTON btSave ;
        TOOLTIP 'Save' ;
        PICTURE 'Save' ; 
        ACTION SaveFile() ;
        SEPARATOR

      BUTTON btPrint ;
        TOOLTIP 'Print' ;
        PICTURE 'Printer' ;
        ACTION   Print(.N.) ;
        SEPARATOR

      BUTTON btShortcuts ;
        TOOLTIP 'Keyboard shortcuts' ;
        PICTURE 'Shortcuts' ;
        ACTION  Shortcuts()

    END TOOLBAR

    COMBOBOX coZoom ;
      ITEMS aZoomLabel ;
      VALUE 5 ;
      HEIGHT 200 ;
      WIDTH 80 ;
      TOOLTIP 'Zoom ratio' ;
      ON CHANGE (wMain.ebDoc.ZOOM := (nZoomValue := INT(aZoomPercentage[wMain.coZoom.VALUE])), ;
                 wMain.ebDoc.SETFOCUS) ;
      ON CANCEL (wMain.ebDoc.SETFOCUS())

    DEFINE TOOLBAR tlEdit BUTTONSIZE 23,23 FONT 'Arial' SIZE 8  FLAT

      BUTTON btCopy ;
        TOOLTIP 'Copy' ;
        PICTURE 'Copy' ;
        ACTION Copy()

      BUTTON btPaste ;
        TOOLTIP 'Paste' ;
        PICTURE 'Paste' ;
        ACTION Paste()

      BUTTON btCut ;
        TOOLTIP 'Cut' ;
        PICTURE 'Cut' ;
        ACTION Cut()

      BUTTON btClear ;
        TOOLTIP 'Delete' ;
        PICTURE 'Delete' ;
        ACTION Deleter()
        SEPARATOR

      BUTTON btUndo ;
        TOOLTIP 'Undo' ;
        PICTURE 'Undo' ;
        ACTION Undo() ;
        DROPDOWN

      DEFINE DROPDOWN MENU BUTTON btUndo
        ITEM 'Clear undo buffer' ACTION ClearUndoBuffer()
      END MENU

      BUTTON btRedo ;
        TOOLTIP 'Redo' ;
        PICTURE 'Redo' ;
        ACTION Redo() ;
        SEPARATOR

      BUTTON btFind ;
        TOOLTIP 'Find' ;
        PICTURE 'Find' ;
        ACTION FindText()

      BUTTON btRepl ;
        TOOLTIP 'Replace' ;
        PICTURE 'Replace' ; 
        ACTION ReplaceText() ;
        SEPARATOR

    END TOOLBAR

    COMBOBOX coFontName ;
      ITEMS aFontList ;
      VALUE 1 ;
      WIDTH 170 ;
      HEIGHT 200 ;
      TOOLTIP 'Font name' ;
      ON CHANGE (wMain.ebDoc.FONTNAME := wMain.coFontName.ITEM(wMain.coFontName.VALUE), ;
                 wMain.ebDoc.SETFOCUS()) ;
      ON CANCEL (wMain.ebDoc.SETFOCUS())

    COMBOBOX coFontSize ;
      ITEMS aFontSizeLabel ;
      VALUE 5 ;
      WIDTH 60 ;
      TOOLTIP 'Font size' ;
      ON CHANGE (wMain.ebDoc.FONTSIZE := VAL(wMain.coFontSize.ITEM(wMain.coFontSize.VALUE)), ;
                 wMain.ebDoc.SETFOCUS()) ;
      ON CANCEL (wMain.ebDoc.SETFOCUS())

    DEFINE TOOLBAR tlText BUTTONSIZE 23,23 SIZE 8  FLAT 

      BUTTON btBold ;
        TOOLTIP 'Bold' ;
        PICTURE 'Bold' ;
        ACTION Bold() ;
        CHECK

      BUTTON btItalic ;
        TOOLTIP 'Italic' ;
        PICTURE 'Italic' ;
        ACTION Italic() ;
        CHECK

      BUTTON btUnderline ;
        TOOLTIP 'Underline' ;
        PICTURE 'Under' ;
        ACTION Underline() ;
        CHECK

      BUTTON btStrikeOut ;
        TOOLTIP 'Strikeout' ;
        PICTURE 'Strike' ;
        ACTION Strikethrough() ;
        CHECK ;    
        SEPARATOR

      BUTTON btSubScript ;
        TOOLTIP 'Subscript' ;
        PICTURE 'Subscript' ;
        ACTION Subscript() ;
        CHECK

      BUTTON btSuperScript ;
        TOOLTIP 'Superscript' ;
        PICTURE 'Superscript' ;
        ACTION Superscript() ;
        CHECK ;
        SEPARATOR

      BUTTON btLink ;
        TOOLTIP 'Set link on selected text' ;
        PICTURE 'Link' ;
        ACTION MakeLink() ;
        CHECK ;
        SEPARATOR

      BUTTON btFontColor ;
        TOOLTIP 'Set font foreground color' ;
        PICTURE 'FontColor' ; 
        ACTION FontForeColor()

      BUTTON btFontBackColor ;
        TOOLTIP 'Set font background color' ;
        PICTURE 'FontBackColor' ;
        ACTION FontBackColor()

      BUTTON btBackgroundColor ;
        TOOLTIP 'Set document background color' ;
        PICTURE 'BackgroundColor' ;
        SEPARATOR ;
        ACTION DocBackColor()

      BUTTON btLeft ;
        TOOLTIP 'Align left' ;
        PICTURE 'Left' ;
        ACTION AlignLeft() ;
        CHECK GROUP

      BUTTON btCenter ;
        TOOLTIP 'Center' ;
        PICTURE 'Center' ;
        ACTION AlignCenter() ;
        CHECK GROUP

      BUTTON btRight ;
        TOOLTIP 'Align right' ;
        PICTURE 'Right' ;
        ACTION AlignRight() ;
        CHECK GROUP

      BUTTON btJustify ;
        TOOLTIP 'Justify' ;
        PICTURE 'Justify' ;
        ACTION AlignJustify() ;
        CHECK GROUP ;
        SEPARATOR 

      BUTTON btBulleted ;
        TOOLTIP 'Bulleted paragraphs' ;
        PICTURE 'Number' ;
        ACTION MakeBullet() ;
        CHECK

      BUTTON btOffset2 ;
        TOOLTIP 'Decrease indent' ;
        PICTURE 'Indent2' ;
        ACTION IndentLeft()

      BUTTON btOffset1 ;
        TOOLTIP 'Increase indent' ;
        PICTURE 'Indent1' ;
        ACTION IndentRight()
    
      BUTTON btLineSpacing ;
        TOOLTIP 'Line spacing' ;
        PICTURE 'ParaLineSpacing' ;
        ACTION NIL ;
        WHOLEDROPDOWN ;
        SEPARATOR 

      DEFINE DROPDOWN MENU BUTTON btLineSpacing
        ITEM '1.0 ' ACTION wMain.ebDoc.PARALINESPACING := 1.0
        ITEM '1.5 ' ACTION wMain.ebDoc.PARALINESPACING := 1.5
        ITEM '2.0 ' ACTION wMain.ebDoc.PARALINESPACING := 2.0
        ITEM '2.5 ' ACTION wMain.ebDoc.PARALINESPACING := 2.5
        ITEM '3.0 ' ACTION wMain.ebDoc.PARALINESPACING := 3.0
        SEPARATOR
        ITEM 'Get paragraph line spacing' ;
          ACTION MSGINFO('Paragraph line spacing: ' + HB_NTOS(wMain.ebDoc.PARALINESPACING))
      END MENU

      BUTTON btWordWrap ;
        TOOLTIP 'Toggle word wrap' ;
        PICTURE 'WordWrap' ;
        SEPARATOR ;
        ACTION WordWrap()

      BUTTON btStatusBar ;
        TOOLTIP 'Toggle status bar' ;
        PICTURE 'StatusBar' ;
        ACTION StatusBar()

    END TOOLBAR

  END SPLITBOX

  DefineDoc()

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

GETFONTLIST(NIL, NIL, NIL, NIL, NIL, NIL, @aFontList)
nPos := ASCAN(aFontList, {|cRow| HMG_LOWER(cRow) == HMG_LOWER(cFontName)})
IF EMPTY(nPos)
  cFontName := 'Arial'
END

RETURN // MainInit

//***************************************************************************

STATIC PROCEDURE RegRead(cKey, xVal)

LOCAL xRead  := WIN_REGREAD(cRegBase + cKey)
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

WIN_REGWRITE(cRegBase + cKey, xWrite)

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
DocSize()
SET DIALOGBOX CENTER OF ('wMain')

RETURN // MainSize

//***************************************************************************

STATIC PROCEDURE DefineMenu

LOCAL cTab      := E"\t"
LOCAL cDots     := '…' // U+2026 HORIZONTAL ELLIPSIS

DEFINE MAIN MENU OF wMain

  POPUP '&File'
    ITEM '&New'               + cTab + 'Ctrl+N'  ACTION NewFile()
    ITEM '&Open' + cDots      + cTab + 'Ctrl+O'  ACTION OpenFile()
    POPUP 'R&ecent' + cDots
      ITEM '&1. '  + aRecentBases[ 1] ACTION OpenFile(aRecentNames[ 1])
      ITEM '&2. '  + aRecentBases[ 2] ACTION OpenFile(aRecentNames[ 2])
      ITEM '&3. '  + aRecentBases[ 3] ACTION OpenFile(aRecentNames[ 3])
      ITEM '&4. '  + aRecentBases[ 4] ACTION OpenFile(aRecentNames[ 4])
      ITEM '&5. '  + aRecentBases[ 5] ACTION OpenFile(aRecentNames[ 5])
      ITEM '&6. '  + aRecentBases[ 6] ACTION OpenFile(aRecentNames[ 6])
      ITEM '&7. '  + aRecentBases[ 7] ACTION OpenFile(aRecentNames[ 7])
      ITEM '&8. '  + aRecentBases[ 8] ACTION OpenFile(aRecentNames[ 8])
      ITEM '&9. '  + aRecentBases[ 9] ACTION OpenFile(aRecentNames[ 9])
      ITEM '1&0. ' + aRecentBases[10] ACTION OpenFile(aRecentNames[10])
    END POPUP
    SEPARATOR
    ITEM '&Close'                                ACTION CloseFile()
    ITEM '&Save'              + cTab + 'Ctrl+S'  ACTION SaveFile()
    ITEM 'Save &as' + cDots                      ACTION SaveFileAs()
    SEPARATOR
    ITEM '&Print' + cDots     + cTab + 'Ctrl-P'  ACTION Print(.N.)
    ITEM 'Print pre&view'                        ACTION Print(.Y.)
    ITEM 'Pa&ge setup'                           ACTION PageSetup()
    SEPARATOR
    ITEM 'Shortcu&ts and associations' + cDots   ACTION Associations()
    SEPARATOR
    ITEM 'E&xit'                                 ACTION wMain.RELEASE
  END POPUP

  POPUP '&Edit'
    ITEM '&Undo'              + cTab + 'Ctrl-Z'  ACTION Undo()
    ITEM '&Redo'              + cTab + 'Ctrl-Y'  ACTION Redo()
    ITEM 'C&lear undo buffer'                    ACTION ClearUndoBuffer()
    SEPARATOR
    ITEM '&Copy'              + cTab + 'Ctrl-C'  ACTION Copy()
    ITEM 'Cu&t'               + cTab + 'Ctrl-X'  ACTION Cut()
    ITEM '&Paste'             + cTab + 'Ctrl-V'  ACTION Paste()
    ITEM 'Pa&ste unformatted' + cTab + 'Ctrl-W'  ACTION PasteUnformatted()
    ITEM '&Delete'            + cTab + 'Delete'  ACTION Deleter()
    SEPARATOR
    ITEM 'Select &all'        + cTab + 'Ctrl-A'  ACTION SelectAll()
    SEPARATOR
    ITEM '&Find' + cDots      + cTab + 'Ctrl-F'  ACTION FindText()
    ITEM 'R&eplace' + cDots   + cTab + 'Ctrl-H'  ACTION ReplaceText()
  END POPUP

  POPUP 'F&ormat'
    ITEM '&Font' + cDots                         ACTION FontFormat()
    ITEM '&Text' + cDots                         ACTION TextFormat()
    ITEM '&Paragraph' + cDots                    ACTION ParagraphFormat()
  END POPUP

  POPUP '&View'
    ITEM '&Zoom' + cDots                         ACTION Zoom()
    ITEM 'Zoom &in'   + cTab + 'Ctrl-Keypad-(+)' ACTION ZoomIn()
    ITEM 'Zoom &out'  + cTab + 'Ctrl-Keypad-(-)' ACTION ZoomOut()
    ITEM 'Font &foreground color' + cDots        ACTION FontForeColor()
    ITEM 'Font &background color' + cDots        ACTION FontBackColor()
    ITEM '&Document background color' + cDots    ACTION DocBackColor()
    ITEM '&Word wrap'                            ACTION  WordWrap() ;
                                                 CHECKED NAME miWordWrap
    ITEM '&Status bar'                           ACTION  StatusBar() ;
                                                 CHECKED NAME miStatusBar
  END POPUP

  POPUP '&Help'
    ITEM '&Keyboard shortcuts' + cTab + 'F1'     ACTION Shortcuts()
    SEPARATOR
    ITEM '&About'                                ACTION About()
  END POPUP

END MENU

RETURN // DefineMenu

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
    lWordWrap := lSetWordWrap
    nCaretPos := wMain.ebDoc.CARETPOS
    IF !EX.wMain.ebDoc.SAVEFILE(cTempFile, .N., RICHEDITFILEEX_RTF)
      BREAK
    END
    wMain.ebDoc.RELEASE 
  END

  DEFINE RICHEDITBOX ebDoc
    PARENT    wMain
    ROW       60
    COL       0
    WIDTH     wMain.WIDTH - 17
    HEIGHT    wMain.HEIGHT - 141
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

LOCAL aMainWidth := {1321, 700, 510, 283, 276}
LOCAL nMainWidth := wMain.WIDTH
LOCAL nPos       := ASCAN(aMainWidth, {|nSize| nMainWidth > nSize})
LOCAL nStep      := IF(EMPTY(nPos), LEN(aMainWidth), nPos - 1)
LOCAL nHtOffset  := nStep * 28
LOCAL nStatus    := IF(lStatusBar, 0, 25)

wMain.ebDoc.WIDTH       := wMain.WIDTH - 17
wMain.ebDoc.ROW         := 32 + nHtOffset
wMain.ebDoc.HEIGHT      := wMain.HEIGHT - 113 - nHtOffset
wMain.STATUSBAR.VISIBLE := lStatusBar

RETURN // DocSize

//***************************************************************************

STATIC PROCEDURE EditKey

LOCAL cKey := HMG_GETLASTCHARACTEREX()
LOCAL nKey := HB_UTF8ASC(cKey)

IF nKey > 0
  wMain.btUndo.ENABLED := wMain.ebDoc.CANUNDO
  wMain.btRedo.ENABLED := wMain.ebDoc.CANREDO
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

  wMain.miWordWrap.CHECKED      := lWordWrap
  wMain.miStatusBar.CHECKED     := lStatusBar

  wMain.btWordWrap.VALUE        := lWordWrap
  wMain.btStatusBar.VALUE       := lStatusBar

  wMain.btBold.VALUE            := wMain.ebDoc.FONTBOLD
  wMain.btItalic.VALUE          := wMain.ebDoc.FONTITALIC
  wMain.btUnderline.VALUE       := wMain.ebDoc.FONTUNDERLINE
  wMain.btStrikeOut.VALUE       := wMain.ebDoc.FONTSTRIKEOUT
  wMain.btSubScript.VALUE       := (wMain.ebDoc.FONTSCRIPT == RTF_SUBSCRIPT)
  wMain.btSuperScript.VALUE     := (wMain.ebDoc.FONTSCRIPT == RTF_SUPERSCRIPT)
  wMain.btLink.VALUE            := wMain.ebDoc.LINK

  wMain.btBulleted.VALUE        := (wMain.ebDoc.PARANUMBERING > RTF_NOBULLETNUMBER)

  wMain.btLeft.VALUE            := (wMain.ebDoc.PARAALIGNMENT == RTF_LEFT)
  wMain.btCenter.VALUE          := (wMain.ebDoc.PARAALIGNMENT == RTF_CENTER)
  wMain.btRight.VALUE           := (wMain.ebDoc.PARAALIGNMENT == RTF_RIGHT)
  wMain.btJustify.VALUE         := (wMain.ebDoc.PARAALIGNMENT == RTF_JUSTIFY)

  wMain.ebDoc.SETFOCUS

  lRun := .N.

END SEQUENCE

RETURN // Refresh

//***************************************************************************

STATIC PROCEDURE DoLink

LOCAL cLink := ALLTRIM(THISRICHEDITBOX.GETCLICKLINKTEXT)

DO CASE
CASE HMG_LOWER(HB_USUBSTR(cLink,1,7)) == 'http://' .OR. ;
  HMG_LOWER(HB_USUBSTR(cLink,1,8)) == 'https://' .OR. ;
  HMG_LOWER(HB_USUBSTR(cLink,1,6)) == 'ftp://' .OR. ;
  HMG_LOWER(HB_USUBSTR(cLink,1,4)) == 'www.' 
  SHELLEXECUTE(NIL, 'Open', cLink, NIL, NIL, SW_SHOWNORMAL)
CASE '@' $ cLink .AND. '.' $ cLink .AND. .NOT.(' ' $ cLink)
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
  RELEASE MAIN MENU OF wMain
  DefineMenu()
END
wMain.TITLE := IF(EMPTY(cFileBase), '', cFileBase + ' - ') + cTitle
wMain.STATUSBAR.ITEM(1) := cFileName

RETURN // NewFileName

//***************************************************************************

STATIC PROCEDURE NewFile

IF !lModified .OR. MSGYESNO('Clear the current file?', 'New')
  NewFileName('')
  wMain.ebDoc.RELEASE
  DefineDoc()
  lModified := .N.
  wMain.ebDoc.SETFOCUS
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
  AT wMain.ROW + 160, wMain.COL + 40 ;
  WIDTH 600 HEIGHT 430 ;
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
             WIDTH 310 HEIGHT 355

  @  40, 110 BUTTON btPrint ;
             CAPTION 'Select printer' ;  
             ACTION bPrint:EVAL() ;
             WIDTH 100 HEIGHT 25

  @  90,  20 LABEL laPrinterName ;
             VALUE 'Printer name' ;
             AUTOSIZE

  @  90, 105 TEXTBOX tbPrinterName ;
             WIDTH 200 ;
             VALUE OPENPRINTERGETNAME() READONLY

  @ 120,  20 LABEL laPageHeight ;
             VALUE 'Page height (mm)' ;
             AUTOSIZE

  @ 120, 265 TEXTBOX tbPageHeight ;
             WIDTH 40 ;
             VALUE OPENPRINTERGETPAGEHEIGHT() READONLY ;
             NUMERIC INPUTMASK '999'

  @ 150,  20 LABEL laPageWidth ;
             VALUE 'Page width (mm)' ;
             AUTOSIZE

  @ 150, 265 TEXTBOX tbPageWidth ;
             WIDTH 40 ;
             VALUE OPENPRINTERGETPAGEWIDTH() READONLY ;
             NUMERIC INPUTMASK '999'

  @ 180,  20 LABEL laPrintHeight ;
             VALUE 'Printable area height (mm)' ;
             AUTOSIZE

  @ 180, 265 TEXTBOX tbPrintHeight ;
             WIDTH 40 ;
             VALUE GETPRINTABLEAREAHEIGHT() READONLY ;
             NUMERIC INPUTMASK '999'

  @ 210,  20 LABEL laPrintWidth ;
             VALUE 'Printable area width (mm)' ;
             AUTOSIZE

  @ 210, 265 TEXTBOX tbPrintWidth ;
             WIDTH 40 ;
             VALUE GETPRINTABLEAREAWIDTH() READONLY ;
             NUMERIC INPUTMASK '999'

  @ 240,  20 LABEL laPrintVOffset ;
             VALUE 'Printable area vertical offset (mm)' ;
             AUTOSIZE

  @ 240, 265 TEXTBOX tbPrintVOffset ;
             WIDTH 40 ;
             VALUE GETPRINTABLEAREAVERTICALOFFSET() READONLY ;
             NUMERIC INPUTMASK '999'

  @ 270,  20 LABEL laPrintHOffset ;
             VALUE 'Printable area horizontal offset (mm)' ;
             AUTOSIZE

  @ 270, 265 TEXTBOX tbPrintHOffset ;
             WIDTH 40 ;
             VALUE GETPRINTABLEAREAHORIZONTALOFFSET() READONLY ;
             NUMERIC INPUTMASK '999'

  @   5, 330 FRAME frAlign ;
             CAPTION 'Margins' ;
             WIDTH 255 HEIGHT 145

  @  30, 340 LABEL laLeftMargin ;
             VALUE 'Left margin (mm)' ;
             AUTOSIZE

  @  30, 530 TEXTBOX tbLeftMargin ;
             WIDTH 40 ;
             VALUE nPrintLeft ;
             NUMERIC INPUTMASK '999'

  @  60, 340 LABEL laRightMargin ;
             VALUE 'Right margin (mm)' ;
             AUTOSIZE

  @  60, 530 TEXTBOX tbRightMargin ;
             WIDTH 40 ;
             VALUE nPrintRight ; 
             NUMERIC INPUTMASK '999'

  @  90, 340 LABEL laTopMargin ;
             VALUE 'Top margin (mm)' ;
             AUTOSIZE

  @  90, 530 TEXTBOX tbTopMargin ;
             WIDTH 40 ;
             VALUE nPrintTop ; 
             NUMERIC INPUTMASK '999'

  @ 120, 340 LABEL laBottomMargin ;
             VALUE 'Bottom margin (mm)' ;
             AUTOSIZE

  @ 120, 530 TEXTBOX tbBottomMargin ;
             WIDTH 40 ;
             VALUE nPrintBottom ; 
             NUMERIC INPUTMASK '999'

  @ 155, 330 FRAME frHeader ;
             CAPTION 'Header' ;
             WIDTH 255 HEIGHT 205
                      
  @ 180, 340 CHECKBOX cbHeader ;
             CAPTION 'Include header' ;
             WIDTH 210 HEIGHT 23 ;
             VALUE lPrintHead ;
             ON CHANGE bHeader:EVAL(wPageSetup.cbHeader.VALUE)

  @ 210, 340 LABEL laHeaderRow ;
             VALUE 'Offset from top (mm)' ;
             AUTOSIZE

  @ 210, 530 TEXTBOX tbHeaderRow ;
             WIDTH 40 ;
             VALUE nPrintRow ; 
             TOOLTIP 'Distance of center of header from top side of page' ;
             NUMERIC INPUTMASK '999'

  @ 240, 340 LABEL laHeaderCol ;
             VALUE 'Offset from left (mm)' ;
             AUTOSIZE

  @ 240, 530 TEXTBOX tbHeaderCol ;
             WIDTH 40 ;
             VALUE nPrintCol ; 
             TOOLTIP 'Distance of center of header from left side of page' ;
             NUMERIC INPUTMASK '999'

  @ 270, 340 CHECKBOX cbPageNumber ;
             CAPTION 'Include page number in header' ;
             WIDTH 210 HEIGHT 23 ;
             VALUE lPrintNumHead

  @ 300, 340 LABEL laHeaderPreText ;
             VALUE 'Header pre text' ;
             AUTOSIZE

  @ 300, 440 TEXTBOX tbHeaderPreText ;
             WIDTH 130 ;
             VALUE cPrintPreHead ; 
             MAXLENGTH 40 ;
               TOOLTIP 'Header text before page number; max 40 characters' 

  @ 330, 340 LABEL laHeaderPostText ;
             VALUE 'Header post text' ;
             AUTOSIZE
      
  @ 330, 440 TEXTBOX tbHeaderPostText ;
             WIDTH 130 ;
             VALUE cPrintPostHead ; 
             MAXLENGTH 40 ;
             TOOLTIP 'Header text after page number; max 40 characters'

  @ 370, 215 BUTTON btOk ;
             CAPTION 'OK' ;  
             ACTION PageSetupSave() ;
             WIDTH 80 HEIGHT 25

  @ 370, 305 BUTTON btCancel ; 
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
  AT wMain.ROW + 160, wMain.COL + 40 ;
  WIDTH 440 HEIGHT 240 ; 
  TITLE 'Shortcuts and file associations' ; 
  MODAL NOSIZE ;
  ON INIT AssocInit(@lDeskShort, @lMenuShort, @lRtfAssoc, @lTxtAssoc)

  @  10,  10 LABEL lbWarn ;
             VALUE 'Run this program as Administrator to change the following settings.' BOLD ;
             AUTOSIZE

  @  40,  10 CHECKBOX ckDeskShort ;
             CAPTION 'Include WordScribe shortcut on desktop' ;
             WIDTH 420 ;
             VALUE .N.

  @  70,  10 CHECKBOX ckMenuShort ;
             CAPTION 'Include WordScribe shortcut on start menu' ;
             WIDTH 420 ;
             VALUE .N.

  @ 100,  10 CHECKBOX ckRtfMenu ;
             CAPTION 'Include WordScribe as "Open with" item on right click menu for RTF files' ;
             WIDTH 420 ;
             VALUE .N.

  @ 130,  10 CHECKBOX ckTxtMenu ;
             CAPTION 'Include WordScribe as "Open with" item on right click menu for TXT files' ;
             WIDTH 420 ;
             VALUE .N.

  @ 170, 135 BUTTON btOk ;
             CAPTION 'OK' ;  
             ACTION AssocSet(lDeskShort, lMenuShort, lRtfAssoc, lTxtAssoc) ;
             WIDTH 80 HEIGHT 25

  @ 170, 225 BUTTON btCancel ; 
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

lDeskShort := FILE(cDeskDir + 'WordScribe.lnk')
lMenuShort := FILE(cMenuDir + 'WordScribe.lnk')

BEGIN SEQUENCE
  cData := WIN_REGREAD('HKLM\Software\Classes\.rtf\OpenWithProgIds\WordScribe.rtf')
  IF !HB_ISSTRING(cData)
    lRtfAssoc := .N.
    BREAK
  END
  cData := WIN_REGREAD('HKLM\Software\Classes\WordScribe.rtf\shell\open\command\')
  IF HB_ISSTRING(cData) .AND. HMG_UPPER(cThisExe) $ HMG_UPPER(cData)
    lRtfAssoc := .Y.    
    BREAK
  END
  lRtfAssoc := .N.
END SEQUENCE

BEGIN SEQUENCE
  cData := WIN_REGREAD('HKLM\Software\Classes\.txt\OpenWithProgIds\WordScribe.txt')
  IF !HB_ISSTRING(cData)
    lTxtAssoc := .N.
    BREAK
  END
  cData := WIN_REGREAD('HKLM\Software\Classes\WordScribe.txt\shell\open\command\')
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
  MAKEFDIRSHORTCUT(cThisExe, 'WordScribe',, cDeskDir)
CASE lDeskShort .AND. !wAssoc.ckDeskShort.VALUE
  FERASE(cDeskDir + 'WordScribe.lnk')
END

DO CASE
CASE !lMenuShort .AND. wAssoc.ckMenuShort.VALUE
  MAKEFDIRSHORTCUT(cThisExe, 'WordScribe',, cMenuDir)
CASE lMenuShort .AND. !wAssoc.ckMenuShort.VALUE
  FERASE(cMenuDir + 'WordScribe.lnk')
END

DO CASE
CASE !lRtfAssoc .AND. wAssoc.ckRtfMenu.VALUE
  cData := WIN_REGREAD('HKLM\Software\Classes\.rtf\OpenWithProgIds\WordScribe.rtf')
  IF !HB_ISSTRING(cData)
    WIN_REGWRITE('HKLM\Software\Classes\.rtf\OpenWithProgIds\WordScribe.rtf', '')
  END
  WIN_REGWRITE('HKLM\Software\Classes\WordScribe.rtf\', 'Rich Text Document')
  WIN_REGWRITE('HKLM\Software\Classes\WordScribe.rtf\shell\open\command\', '"' + cThisExe + '" "%1"')
CASE lRtfAssoc .AND. !wAssoc.ckRtfMenu.VALUE
  WIN_REGDELETE('HKLM\Software\Classes\.rtf\OpenWithProgIds\WordScribe.rtf')
  WIN_REGDELETE('HKLM\Software\Classes\WordScribe.rtf\shell\open\command\')
  WIN_REGDELETE('HKLM\Software\Classes\WordScribe.rtf\shell\open\')
  WIN_REGDELETE('HKLM\Software\Classes\WordScribe.rtf\shell\')
  WIN_REGDELETE('HKLM\Software\Classes\WordScribe.rtf\DefaultIcon\')
  WIN_REGDELETE('HKLM\Software\Classes\WordScribe.rtf\')
END

DO CASE
CASE !lTxtAssoc .AND. wAssoc.ckTxtMenu.VALUE
  cData := WIN_REGREAD('HKLM\Software\Classes\.txt\OpenWithProgIds\WordScribe.txt')
  IF !HB_ISSTRING(cData)
    WIN_REGWRITE('HKLM\Software\Classes\.txt\OpenWithProgIds\WordScribe.txt', '')
  END
  WIN_REGWRITE('HKLM\Software\Classes\WordScribe.txt\', 'Text Document')
  WIN_REGWRITE('HKLM\Software\Classes\WordScribe.txt\shell\open\command\', '"' + cThisExe + '" "%1"')
CASE lTxtAssoc .AND. !wAssoc.ckTxtMenu.VALUE
  WIN_REGDELETE('HKLM\Software\Classes\.txt\OpenWithProgIds\WordScribe.txt')
  WIN_REGDELETE('HKLM\Software\Classes\WordScribe.txt\shell\open\command\')
  WIN_REGDELETE('HKLM\Software\Classes\WordScribe.txt\shell\open\')
  WIN_REGDELETE('HKLM\Software\Classes\WordScribe.txt\shell\')
  WIN_REGDELETE('HKLM\Software\Classes\WordScribe.txt\DefaultIcon\')
  WIN_REGDELETE('HKLM\Software\Classes\WordScribe.txt\')
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

STATIC PROCEDURE MakeBullet

wMain.ebDoc.PARANUMBERING := ;
  IF(wMain.ebDoc.PARANUMBERING == RTF_NOBULLETNUMBER, ;
  RTF_BULLET, RTF_NOBULLETNUMBER)
Refresh()

RETURN // MakeBullet

//***************************************************************************

STATIC PROCEDURE IndentLeft

wMain.ebDoc.PARAINDENT := MIN(MAX_PARAINDENT, wMain.ebDoc.PARAINDENT - 5)

RETURN // IndentLeft

//***************************************************************************

STATIC PROCEDURE IndentRight

wMain.ebDoc.PARAINDENT := MAX(MIN_PARAINDENT, wMain.ebDoc.PARAINDENT + 5)

RETURN // IndentRight

//***************************************************************************

STATIC PROCEDURE Undo

wMain.ebDoc.UNDO()

RETURN // Undo

//***************************************************************************

STATIC PROCEDURE Redo

wMain.ebDoc.REDO()

RETURN // Redo

//***************************************************************************

STATIC PROCEDURE ClearUndoBuffer

wMain.ebDoc.CLEARUNDOBUFFER()
wMain.btUndo.ENABLED := .N.
wMain.btRedo.ENABLED := .N.

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

STATIC PROCEDURE SelectAll

wMain.ebDoc.SELECTALL()

RETURN // SelectAll

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

BEGIN SEQUENCE

  IF FindReplaceDlg.RETVALUE == FRDLG_CANCEL
    BREAK
  END

  cFind           := FindReplaceDlg.FIND
  cReplace        := FindReplaceDlg.REPLACE
  lDown           := FindReplaceDlg.DOWN
  lMatchCase      := FindReplaceDlg.MATCHCASE
  lWholeWord      := FindReplaceDlg.WHOLEWORD
  lSelectFindText := .Y.

  SWITCH FindReplaceDlg.RetValue
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

END SEQUENCE

RETURN // DoFindReplace

//***************************************************************************

STATIC PROCEDURE MoveFindReplace(nPos)

LOCAL aCharPos := wMain.ebDoc.GETPOSCHAR(nPos)

IF aCharPos[1] != -1 .AND. aCharPos[2] != -1
  DO CASE
  CASE FindReplaceDlg.HEIGHT + OFFSET_DLG < aCharPos[1]
    FindReplaceDlg.ROW := aCharPos[1] - (FindReplaceDlg.HEIGHT + OFFSET_DLG)
  CASE FindReplaceDlg.ROW < aCharPos[1] + OFFSET_DLG
    FindReplaceDlg.ROW := aCharPos[1] + OFFSET_DLG
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
  wMain.ebDoc.FONTNAME      := (cFontName := aFont[1])
  wMain.ebDoc.FONTSIZE      := (nFontSize := aFont[2])
  wMain.ebDoc.FONTBOLD      := aFont[3]
  wMain.ebDoc.FONTITALIC    := aFont[4]
  wMain.ebDoc.FONTCOLOR     := (aFontForeColor := aFont[5])
  wMain.ebDoc.FONTUNDERLINE := aFont[6]
  wMain.ebDoc.FONTSTRIKEOUT := aFont[7]
  Refresh()
END

RETURN // FontFormat

//***************************************************************************

STATIC PROCEDURE TextFormat

DEFINE WINDOW wText ; 
  AT wMain.ROW + 160, wMain.COL + 40 ;
  WIDTH 340 HEIGHT 160 ; 
  TITLE 'Text' ; 
  MODAL NOSIZE ;
  ON INIT TextInit()

  @   5,  10 FRAME frAlign ;
             CAPTION 'Alignment' ;
             WIDTH 100 ;
             HEIGHT 110

  @  25,  15 RADIOGROUP rgScript ;
             OPTIONS aScriptLabel ;  
             VALUE 1 ;  
             WIDTH 90 ;
             SPACING 25 

  @   5, 115 FRAME frIndent ;
             CAPTION 'Attributes' ;
             WIDTH 100 ;
             HEIGHT 110

  @  25, 125 CHECKBOX ckLink ;
             CAPTION 'Link' ;
             WIDTH 80 ;
             VALUE .N.

  @  25, 240 BUTTON btOk ;
             CAPTION 'OK' ;  
             ACTION TextSet() ;
             WIDTH 80 HEIGHT 25

  @  55, 240 BUTTON btCancel ; 
             CAPTION 'Cancel' ;  
             ACTION wText.Release ;
             WIDTH 80 HEIGHT 25

  ON KEY RETURN ACTION TextSet()
  ON KEY ESCAPE ACTION wText.RELEASE

END WINDOW 

ACTIVATE WINDOW wText

RETURN // TextFormat

//***************************************************************************

STATIC PROCEDURE TextInit

wText.rgScript.VALUE := MAX(1, ASCAN(aScriptValue, wMain.ebDoc.FONTSCRIPT))
wText.ckLink.VALUE   := wMain.ebDoc.LINK

RETURN // TextInit

//***************************************************************************

STATIC PROCEDURE TextSet

wMain.ebDoc.FONTSCRIPT := aScriptValue[wText.rgScript.VALUE]
wMain.ebDoc.LINK       := wText.ckLink.VALUE
wText.RELEASE

RETURN // TextSet

//***************************************************************************

STATIC PROCEDURE ParagraphFormat

LOCAL lNum
LOCAL xNew, xOld

DEFINE WINDOW wPar ; 
  AT wMain.ROW + 160, wMain.COL + 40 ;
  WIDTH 370 HEIGHT 440 ; 
  TITLE 'Paragraph' ; 
  MODAL NOSIZE ;
  ON INIT ParagraphInit()

  @   5,  10 FRAME frAlign ;
             CAPTION 'Alignment' ;
             WIDTH 70 ;
             HEIGHT 135

  @  25,  15 RADIOGROUP rgAlign ;
             OPTIONS aAlignLabel ;  
             VALUE 1 ;  
             WIDTH 60 ;
             SPACING 25 

  @   5,  85 FRAME frIndent ;
             CAPTION 'Spacing' ;
             WIDTH 175 ;
             HEIGHT 135

  @  30,  95 LABEL laLeftIndent ; 
             VALUE 'Left indent (mm)' ;
             AUTOSIZE

  @  30, 195 TEXTBOX tbLeftIndent ;
             WIDTH 40 ;  
             VALUE 1 ;
             NUMERIC INPUTMASK '999'

  @  60,  95 LABEL laLeftOffset ; 
             VALUE 'Left offset (mm)' ;
             AUTOSIZE

  @  60, 195 TEXTBOX tbLeftOffset ;
             WIDTH 40 ;  
             VALUE 1 ;
             NUMERIC INPUTMASK '999'

  @  90,  95 LABEL laLineSpace ; 
             VALUE 'Line spacing' ;
             AUTOSIZE

  @  90, 180 COMBOBOX coLineSpace ;
             ITEMS aSpaceLabel ;
             VALUE 2 ;
             WIDTH 60 ;
             HEIGHT 200 ;
             DISPLAYEDIT ;
             ON GOTFOCUS  (xOld := wPar.coLineSpace.DISPLAYVALUE) ;
             ON LOSTFOCUS (xNew := VAL(wPar.coLineSpace.DISPLAYVALUE), ;
                           IF(xNew >= 0.2 .AND. xNew < 100, ;
                           NIL, wPar.coLineSpace.DISPLAYVALUE := xOld))

  @ 145,  10 FRAME frNum ;
             CAPTION 'Bullets and numbering' ;
             WIDTH 340 ;
             HEIGHT 250

  @ 165,  15 RADIOGROUP rgNumFormat ;
             OPTIONS aNumFormatLabel ;  
             VALUE 1 ;  
             WIDTH 185 ;
             SPACING 25 ;
             ON CHANGE (lNum := (wPar.rgNumFormat.VALUE >= RTF_ARABICNUMBER), ;
                        wPar.rgNumStyle.ENABLED := lNum, ;
                        wPar.laNumStart.ENABLED := lNum, ;
                        wPar.tbNumStart.ENABLED := lNum  )

  @ 165, 210 RADIOGROUP rgNumStyle ;
             OPTIONS aNumStyleLabel ;  
             VALUE 1 ;  
             WIDTH 185 ;
             SPACING 25 

  @ 360,  15 LABEL laNumStart ; 
             VALUE 'Starting number' ;
             AUTOSIZE

  @ 360, 110 TEXTBOX tbNumStart ;
             WIDTH 40 ;
             VALUE 1 ;
             NUMERIC INPUTMASK '999'

  @  25, 270 BUTTON btOk ;
             CAPTION 'OK' ;  
             ACTION ParagraphSet() ;
             WIDTH 80 HEIGHT 25

  @  55, 270 BUTTON btCancel ; 
             CAPTION 'Cancel' ;  
             ACTION wPar.Release ;
             WIDTH 80 HEIGHT 25

  ON KEY RETURN ACTION ParagraphSet()
  ON KEY ESCAPE ACTION wPar.RELEASE

END WINDOW 

ACTIVATE WINDOW wPar

RETURN // ParagraphFormat

//***************************************************************************

STATIC PROCEDURE ParagraphInit

LOCAL nParAlign     := wMain.ebDoc.PARAALIGNMENT
LOCAL nParIndent    := wMain.ebDoc.PARAINDENT
LOCAL nParOffset    := wMain.ebDoc.PARAOFFSET
LOCAL nParSpacing   := wMain.ebDoc.PARALINESPACING
LOCAL nParNumFormat := wMain.ebDoc.PARANUMBERING
LOCAL nParNumStyle  := wMain.ebDoc.PARANUMBERINGSTYLE
LOCAL nParNumStart  := wMain.ebDoc.PARANUMBERINGSTART
LOCAL lNum          := (nParNumFormat >= RTF_ARABICNUMBER)

wPar.rgAlign.VALUE            := ASCAN(aAlignValue, nParAlign)
wPar.tbLeftIndent.VALUE       := nParIndent
wPar.tbLeftOffset.VALUE       := nParOffset
wPar.coLineSpace.DISPLAYVALUE := STR(MIN(99, nParSpacing), 4, 1)
wPar.rgNumFormat.VALUE        := nParNumFormat
wPar.rgNumStyle.VALUE         := MAX(1, IF(lNum, nParNumStyle, RTF_PERIOD))
wPar.tbNumStart.VALUE         := IF(lNum, nParNumStart, 1)
wPar.rgNumStyle.ENABLED       := lNum
wPar.laNumStart.ENABLED       := lNum
wPar.tbNumStart.ENABLED       := lNum

RETURN // ParagraphInit

//***************************************************************************

STATIC PROCEDURE ParagraphSet

LOCAL nParAlign     := wPar.rgAlign.VALUE
LOCAL nParIndent    := wPar.tbLeftIndent.VALUE
LOCAL nParOffset    := wPar.tbLeftOffset.VALUE
LOCAL nParSpacing   := VAL(wPar.coLineSpace.DISPLAYVALUE)
LOCAL nParNumFormat := wPar.rgNumFormat.VALUE
LOCAL nParNumStyle  := wPar.rgNumStyle.VALUE
LOCAL nParNumStart  := wPar.tbNumStart.VALUE
LOCAL lNum          := (nParNumFormat >= RTF_ARABICNUMBER)

wPar.RELEASE
wMain.ebDoc.PARAALIGNMENT      := aAlignValue[nParAlign]
wMain.ebDoc.PARAINDENT         := nParIndent
wMain.ebDoc.PARAOFFSET         := nParOffset
wMain.ebDoc.PARALINESPACING    := nParSpacing
wMain.ebDoc.PARANUMBERING      := nParNumFormat
IF lNum
  wMain.ebDoc.PARANUMBERINGSTYLE := nParNumStyle
  wMain.ebDoc.PARANUMBERINGSTART := nParNumStart
ELSE
  wMain.ebDoc.PARANUMBERINGSTYLE := RTF_NOBULLETNUMBER
  wMain.ebDoc.PARANUMBERINGSTART := 0
END

RETURN // ParagraphSet

//***************************************************************************

STATIC PROCEDURE Zoom

DEFINE WINDOW wZoom ; 
  AT wMain.ROW + 160, wMain.COL + 40 ;
  WIDTH 220 HEIGHT 310 ; 
  TITLE 'Zoom' ;
  MODAL NOSIZE ;
  ON INIT ZoomInit()

  @   5,  10 FRAME frZoom ;
             CAPTION 'Zoom' ;
             WIDTH 195 HEIGHT 235

  @  30,  90 RADIOGROUP rgZoom ;
             OPTIONS aZoomLabel ;  
             VALUE 1 ;  
             WIDTH 110 ;
             SPACING 25

  @ 250,  25 BUTTON btOk ;
             CAPTION 'OK' ;  
             ACTION ZoomSave() ;
             WIDTH 80 HEIGHT 25

  @ 250, 115 BUTTON btCancel ; 
             CAPTION 'Cancel' ;  
             ACTION wZoom.RELEASE ; 
             WIDTH 80 HEIGHT 25

  ON KEY RETURN ACTION ZoomSave()
  ON KEY ESCAPE ACTION wZoom.RELEASE

END WINDOW 

ACTIVATE WINDOW wZoom

RETURN // Zoom

//***************************************************************************

STATIC PROCEDURE ZoomInit

LOCAL nPos := ASCAN(aZoomPercentage, nZoomValue)

wZoom.rgZoom.VALUE := IF(EMPTY(nPos), 5, nPos)

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
Refresh()

RETURN // WordWrap

//***************************************************************************

STATIC PROCEDURE StatusBar

lStatusBar := !lStatusBar
DocSize()
Refresh()

RETURN // StatusBar

//***************************************************************************

STATIC PROCEDURE FontForeColor

LOCAL aGetColor := GETCOLOR(aFontForeColor, NIL, .N.)

IF VALTYPE(aGetColor[1]) == 'N'
  wMain.ebDoc.FONTCOLOR := (aFontForeColor := aGetColor)
END

RETURN // FontForeColor

//***************************************************************************

STATIC PROCEDURE FontBackColor

LOCAL aGetColor := GETCOLOR(aFontBackColor, NIL, .N.)

IF VALTYPE(aGetColor[1]) == 'N'
  wMain.ebDoc.FONTBACKCOLOR := (aFontBackColor := aGetColor)
END

RETURN // FontBackColor

//***************************************************************************

STATIC PROCEDURE DocBackColor

LOCAL aGetColor := GetColor(aDocBackColor, NIL, .N.)

IF VALTYPE(aGetColor[1]) == 'N'
  wMain.ebDoc.BACKGROUNDCOLOR := (aDocBackColor := aGetColor)
END

RETURN // DocBackColor

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
  AT 0,0 ;
  WIDTH 450 HEIGHT 225 ;
  TITLE 'About ' + cTitle ;
  MODAL NOSIZE

  @  10,  10 IMAGE imProduct ;
             PICTURE 'MainImage'

  @  10, 160 LABEL laName ;
             VALUE cTitle ;
             AUTOSIZE ;
             FONT 'Arial' ;
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

  @ 130, 160 HYPERLINK hyProduct ;
             VALUE 'Made with HMG' ;
             ADDRESS cInfoAddr ;
             AUTOSIZE

  @ 155, 195 BUTTON btOk ;
             CAPTION '&Ok' ;
             ACTION wAbout.RELEASE ;
             WIDTH 55 ;
             HEIGHT 25

  ON KEY RETURN ACTION wAbout.RELEASE
  ON KEY ESCAPE ACTION wAbout.RELEASE

END WINDOW

wAbout.btOk.SETFOCUS
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

IF !MsgYesNo(cVars + CRLF + CRLF + 'Continue?', ;
  IF(EMPTY(cStat), 'Debug', cStat))
  wMain.RELEASE
END

RETURN // MsgDbg

//***************************************************************************

