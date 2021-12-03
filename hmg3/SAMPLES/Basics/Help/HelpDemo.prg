
// Modified version of help demo in MiniGui SAMPLES\BASIC\HELP\Demo.prg

#include "hmg.ch"

Function Main()

  DEFINE WINDOW Form_1 ;
    AT 0,0 ;
    WIDTH 600 HEIGHT 400 ;
    TITLE 'Help Demo' ;
    ICON 'HelpDemo.ico' ;
    MAIN ;
    FONT 'MS Sans Serif' SIZE 10 ;
    HELPBUTTON

    SET HELPFILE TO 'HelpDemo.chm' 

    DEFINE MAIN MENU 
      POPUP '&File'
        ITEM '&Open' ACTION MsgInfo('Clicked Open')
        SEPARATOR
        ITEM 'E&xit' ACTION Form_1.RELEASE
      END POPUP
      POPUP '&Help'
        ITEM '&Help '   ACTION DISPLAY HELP MAIN 
        ITEM 'H&ypertext' ACTION DISPLAY HELP CONTEXT 'HelpDemo1.html'
        ITEM '&Graphics' ACTION DISPLAY HELP POPUP 'HelpDemo2.html'
        SEPARATOR
        ITEM '&About'   ACTION MsgInfo(HMGVersion(), "About")
      END POPUP
    END MENU

    DEFINE STATUSBAR FONT 'MS Sans Serif' SIZE 9
      STATUSITEM "F1 - Help" WIDTH 100
      CLOCK 
      DATE 
    END STATUSBAR

    @  50,100 LABEL Label ;
    VALUE "Press F1, or click the help button in the upper right and then click a button." ;
    AUTOSIZE

    @ 100,100 BUTTON Button_0 ;
    CAPTION 'Button 0' ;
    ACTION MsgInfo('Clicked Button 0' + CHR(10) + 'This button does not have a HELPID.')

    @ 150,100 BUTTON Button_1 ;
    CAPTION 'Button 1' ;
    ACTION MsgInfo('Clicked Button 1' + CHR(10) + 'This button has HELPID "HelpDemo1.html".') ;
    HELPID 'HelpDemo1.html'

    @ 200,100 BUTTON Button_2 ;
    CAPTION 'Button 2' ;
    ACTION MsgInfo('Clicked Button 2' + CHR(10) + 'This button has HELPID "HelpDemo2.html".') ;
    HELPID 'HelpDemo2.html'

  END WINDOW

  CENTER WINDOW Form_1

  ACTIVATE WINDOW Form_1

Return Nil
