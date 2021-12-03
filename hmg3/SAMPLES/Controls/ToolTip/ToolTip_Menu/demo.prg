#include "hmg.ch"

Function main()

 SET TOOLTIPSTYLE BALLOON
 
 SET TOOLTIPFORECOLOR TEAL

 SET TOOLTIPCUSTOMDRAW ON


   DEFINE WINDOW Form_1 ;
      TITLE 'ToolTip Menu' ;
      MAIN 

      DEFINE MAIN MENU

         POPUP 'File'
            ITEM 'Open'          ACTION MsgInfo ('File:Open') IMAGE 'Check.Bmp'  TOOLTIP "Open File" 
            ITEM 'Save'          ACTION MsgInfo ('File:Save') IMAGE 'Free.Bmp'   TOOLTIP "Save File"
            ITEM 'Print'         ACTION MsgInfo ('File:Print') IMAGE 'Info.Bmp'  TOOLTIP "Print File"
            ITEM 'Save As...'    ACTION MsgInfo ('File:Save As')                 TOOLTIP "Save As... File"
            ITEM 'HMG Version'   ACTION MsgInfo (HMGVersion())                   NAME MenuItemHMG  TOOLTIP "Current HMG Version"
            SEPARATOR
            ITEM 'Exit'          ACTION MsgInfo ('File:Exit') IMAGE 'Exit.Bmp'   TOOLTIP "Exit App"
         END POPUP

         POPUP 'Test' 
            ITEM 'Item 1'  ACTION MsgInfo ('Item 1')
            ITEM 'Item 2'  ACTION MsgInfo ('Item 2')   TOOLTIP "Menu ToolTip of Item 2"

            POPUP 'Item 3' name test
               ITEM 'Item 3.1'   ACTION MsgInfo ('Item 3.1') NAME MenuItem31   TOOLTIP "Menu ToolTip of Item 3.1"
               ITEM 'Item 3.2'   ACTION MsgInfo ('Item 3.2')
               ITEM 'Item 3.3'   ACTION MsgInfo ( Form_1.MenuItem33.ToolTip ) NAME MenuItem33
            END POPUP

            ITEM 'Item 4'  ACTION MsgInfo ('Item 4')  TOOLTIP "Menu ToolTip of Item 4"
         END POPUP


      END MENU

      @ 100,300 LABEL Label_1 VALUE "HMG is the best" AUTOSIZE TOOLTIP "ToolTip Label_1" FONT "ARIAL" SIZE 18 BOLD
      SET TOOLTIPCUSTOMDRAW CONTROL Label_1 OF Form_1 FORECOLOR BLUE  BALLOON .F. TITLE "Title ToolTip Label" ICON TOOLTIPICON_WARNING_LARGE

   END WINDOW

   Form_1.MenuItem33.ToolTip :=  "Menu ToolTip of Item 3.3"
  
   aFont := ARRAY FONT "Times New Roman" SIZE 14 BOLD ITALIC
   SET TOOLTIPCUSTOMDRAW CONTROL MenuItem33 OF Form_1 FORECOLOR RED ARRAYFONT aFont  TITLE "Title ToolTip Menu" ICON "Tutor.ico"
   
   SET TOOLTIPCUSTOMDRAW CONTROL MenuItemHMG OF Form_1 FORECOLOR RED ARRAYFONT aFont  BALLOON .F.

   ACTIVATE WINDOW Form_1

Return
