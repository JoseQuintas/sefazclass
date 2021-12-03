/*
 * HMG - Harbour Win32 GUI library
 * Copyright 2002-2008 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

Function Main()

set century on
set date ital

   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 200 ;
      HEIGHT 200 ;
      MAIN;
      TITLE 'Button Test'

      DEFINE MAIN MENU
              POPUP 'Test'
                ITEM 'Disable button' ACTION Form_1.Button_1.Enabled := .f.
                ITEM 'Enable button'  ACTION Form_1.Button_1.Enabled := .t.
              END POPUP
      END MENU

      @ 30,70 BUTTON Button_1 PICTURE "button.bmp" WIDTH 50 HEIGHT 50 ACTION getprinter()
      @ 100,70 textbox t1 value date() date 

   END WINDOW

   CENTER WINDOW Form_1

   ACTIVATE WINDOW Form_1

Return
