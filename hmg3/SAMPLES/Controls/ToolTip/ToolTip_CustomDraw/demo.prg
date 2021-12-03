
#include "hmg.ch"

Function Main

 PRIVATE  lOnToolTipCustomDraw := .T.

 SET TOOLTIPSTYLE BALLOON
 
 SET TOOLTIPFORECOLOR BLUE

 SET TOOLTIPCUSTOMDRAW TO lOnToolTipCustomDraw   // For default ToolTip Custom Draw is OFF

 
    DEFINE WINDOW Form_1 TITLE "ToolTip Custom Draw" MAIN 

      @ 200,250 LABEL Label_1 ;
      AUTOSIZE ;
      VALUE 'Click me On/Off TOOLTIP Custom Draw!' ;
      ACTION SetOnOff();
      FONT 'Arial' SIZE 24;
      TOOLTIP "ToolTip Label 1"

      @ 50,50 LABEL Label_2 ;
      AUTOSIZE ;
      VALUE 'Hello HMG World' ;
      TOOLTIP "ToolTip Label 2 of Form_1"

      @ 150,50 LABEL Label_3 ;
      AUTOSIZE ;
      VALUE 'Label with Default ToolTip' ;
      TOOLTIP "ToolTip Default"

   END WINDOW

   aFont := ARRAY FONT "Arial" SIZE 12 BOLD UNDERLINE
   SET TOOLTIPCUSTOMDRAW CONTROL Label_1 OF Form_1 FORECOLOR RED  ARRAYFONT aFont
   
   aFont := ARRAY FONT "Times New Roman" SIZE 10 BOLD ITALIC
   SET TOOLTIPCUSTOMDRAW CONTROL Label_2 OF Form_1  ARRAYFONT aFont  BALLOON .F.  TITLE "Title Label"  ICON TOOLTIPICON_INFO_LARGE  // "Tutor.ico"

// SET TOOLTIPCUSTOMDRAW CONTROL Label_1 OF Form_1   // Remove tooltip custom draw of the control
   
   ACTIVATE WINDOW Form_1

Return


PROCEDURE SetOnOff
   lOnToolTipCustomDraw := .NOT. lOnToolTipCustomDraw
   SET TOOLTIPCUSTOMDRAW TO lOnToolTipCustomDraw
   MsgInfo ({"ToolTip Custom Draw is: ", ToolTipCustomDrawIsActive ()})
RETURN
