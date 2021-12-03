/* SetCueBanner Demo2.prg which works in ANSI and UNICODE
   
     Author: Carlos Britos
Contributor: Pablo César
   
  Important: SetCueBanner() does not show aAnything in Win XP (any Service Pack).
             On some configurations of WinXP, there is a known problem with SetCueBanner().

   Solution: In the Control Panel/Regional and Language Options (On the Languages tab)
         
             The removal of Operating System support for Complex Scripts
             The removal of Operating System support for East Asian languages
*/

#include <hmg.ch>

Function Main
Define window Form_1 at 0, 0 width 400 height 300 main Title "CueBanner Sample"
   DEFINE TEXTBOX Text_1
        ROW    10
        COL    10
        WIDTH  200
      TOOLTIP "Put your name"
    END TEXTBOX

    DEFINE TEXTBOX Text_2
        ROW    40
        COL    10
        WIDTH  200
      TOOLTIP "Put your address"
    END TEXTBOX

    DEFINE EDITBOX Edit_1
        ROW    10
        COL    230
        WIDTH  120
        HEIGHT 110
        VALUE ""
    END EDITBOX

    DEFINE COMBOBOX Combo_1
        ROW    70
        COL    10
        WIDTH  200
        HEIGHT 100
        ITEMS {"Item 1","Item 2","Item 3"}
        VALUE 0
      DISPLAYEDIT .T.      // must be .T. for cuebanner
    END COMBOBOX

    DEFINE SPINNER Spinner_1
        ROW    100
        COL    10
        WIDTH  200
        HEIGHT 24
        RANGEMIN 1
        RANGEMAX 10
        VALUE ""             // must be "" for cuebanner
    END SPINNER

    DEFINE RICHEDITBOX RichEdit_1
        ROW    130
        COL    230
        WIDTH  120
        HEIGHT 90
        VALUE ""
    END RICHEDITBOX
End window
SetCueBanner(GetControlHandle("Text_1","Form_1"),"Enter your name here",.t.) // Third parameter is for not dissapear when getfocus
SetCueBanner(GetControlHandle("Text_2","Form_1"),"Enter address here",.t.)
SetCueBanner(GetControlHandle("Spinner_1","Form_1")[1],"Spinner CueBanner",.t.)
SetCueBanner(FindWindowEx(GetControlHandle("Combo_1","Form_1"),0,"Edit",Nil),"ComboBox CueBanner",.t.)
     
SetCueBanner(GetControlHandle("Edit_1","Form_1"),"EditBox CueBanner",.t.)
SetCueBanner(GetControlHandle("RichEdit_1","Form_1"),"RichEditBox CueBanner",.t.)
Form_1.center
Form_1.activate
Return Nil

#pragma BEGINDUMP

#define COMPILE_HMG_UNICODE  // Remove this for ANSI building
#include <HMG_UNICODE.h>     // Remove this for ANSI building

#include <windows.h>
#include <commctrl.h>

#define EM_SETCUEBANNER  5377  // Set the cue banner with the lParm = LPCWSTR

HB_FUNC( SETCUEBANNER )                   // (nEditHandle, cMsg, lGetFocus) -> nil
{
   #ifdef UNICODE
      LPWSTR lpWCStr = HMG_parc(2) ;
   #else
      LPWSTR lpWCStr = (LPCWSTR) ( hb_parc(2) == NULL ) ? NULL : hb_mbtowc( (const char *) hb_parc(2) ) ;
   #endif
   SendMessage( (HWND) hb_parnl(1), EM_SETCUEBANNER, (WPARAM) hb_parl(3), (LPARAM) (LPCWSTR) lpWCStr ) ;
   SysFreeString( lpWCStr );
}

#pragma ENDDUMP