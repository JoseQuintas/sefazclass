/*
* HMG keyboard events demo
*/

#include "hmg.ch"

PROCEDURE Main

  DEFINE WINDOW wDemo ;
    AT 400, 50 ;
    WIDTH 970 HEIGHT 400 ;
    TITLE 'Keyboard events' ;
		MAIN  

    DEFINE EDITBOX ebDemo
      ROW       10
      COL       10
      WIDTH     930
      HEIGHT    100
      VALUE     ''
      MAXLENGTH -1
    END RICHEDITBOX

    DEFINE TIMER tiDemo INTERVAL 200 ACTION TimerKey()

    @ 120,  70 LABEL   laDown   WIDTH  40 VALUE 'Down'
    @ 120, 510 LABEL   laUp     WIDTH  40 VALUE 'Up'

    @ 150,  10 LABEL   laMsg    WIDTH  40 VALUE 'nMsg'
    @ 150,  70 TEXTBOX tbMsgHD  WIDTH 140 VALUE '' READONLY RIGHTALIGN
    @ 150, 220 TEXTBOX tbMsgDD  WIDTH  90 VALUE '' READONLY RIGHTALIGN NUMERIC
    @ 150, 320 TEXTBOX tbMsgTD  WIDTH 180 VALUE '' READONLY
    @ 150, 510 TEXTBOX tbMsgHU  WIDTH 140 VALUE '' READONLY RIGHTALIGN
    @ 150, 660 TEXTBOX tbMsgDU  WIDTH  90 VALUE '' READONLY RIGHTALIGN NUMERIC
    @ 150, 760 TEXTBOX tbMsgTU  WIDTH 180 VALUE '' READONLY

    @ 180,  10 LABEL   laWPar   WIDTH  40 VALUE 'wParam'
    @ 180,  70 TEXTBOX tbWParHD WIDTH 140 VALUE '' READONLY RIGHTALIGN
    @ 180, 220 TEXTBOX tbWParDD WIDTH  90 VALUE '' READONLY RIGHTALIGN NUMERIC
    @ 180, 510 TEXTBOX tbWParHU WIDTH 140 VALUE '' READONLY RIGHTALIGN
    @ 180, 660 TEXTBOX tbWParDU WIDTH  90 VALUE '' READONLY RIGHTALIGN NUMERIC

    @ 210,  10 LABEL   laLPar   WIDTH  40 VALUE 'lParam'
    @ 210,  70 TEXTBOX tbLParHD WIDTH 140 VALUE '' READONLY RIGHTALIGN
    @ 210, 220 TEXTBOX tbLParDD WIDTH  90 VALUE '' READONLY RIGHTALIGN NUMERIC
    @ 210, 510 TEXTBOX tbLParHU WIDTH 140 VALUE '' READONLY RIGHTALIGN
    @ 210, 660 TEXTBOX tbLParDU WIDTH  90 VALUE '' READONLY RIGHTALIGN NUMERIC

    @ 240,  10 LABEL   laKey    WIDTH  40 VALUE 'nVKey'
    @ 240,  70 TEXTBOX tbKeyHD  WIDTH 140 VALUE '' READONLY RIGHTALIGN
    @ 240, 220 TEXTBOX tbKeyDD  WIDTH  90 VALUE '' READONLY RIGHTALIGN NUMERIC
    @ 240, 320 TEXTBOX tbKeyTD  WIDTH 180 VALUE '' READONLY
    @ 240, 510 TEXTBOX tbKeyHU  WIDTH 140 VALUE '' READONLY RIGHTALIGN
    @ 240, 660 TEXTBOX tbKeyDU  WIDTH  90 VALUE '' READONLY RIGHTALIGN NUMERIC
    @ 240, 760 TEXTBOX tbKeyTU  WIDTH 180 VALUE '' READONLY

    @ 270,  10 LABEL   laName   WIDTH  40 VALUE 'cVKey'
    @ 270,  70 TEXTBOX tbName   WIDTH 140 VALUE '' READONLY
    @ 300,  10 LABEL   laChar   WIDTH  40 VALUE 'cChar'
    @ 300,  70 TEXTBOX tbChar   WIDTH 140 VALUE '' READONLY
    @ 330,  10 LABEL   laID     WIDTH  40 VALUE 'cID'
    @ 330,  70 TEXTBOX tbID     WIDTH 140 VALUE '' READONLY

    ON KEY F2     ACTION NIL
    ON KEY ALT+F2 ACTION NIL
    ON KEY ESCAPE ACTION NIL
    ON KEY TAB    ACTION NIL

	END WINDOW

  ACTIVATE WINDOW wDemo

RETURN

PROCEDURE TimerKey()

  LOCAL hMsg := { ;
    0x0100 => 'WM_KEYDOWN'    , ;
    0x0101 => 'WM_KEYUP'      , ;
    0x0102 => 'WM_CHAR'       , ;
    0x0103 => 'WM_DEADCHAR'   , ;
    0x0104 => 'WM_SYSKEYDOWN' , ;
    0x0105 => 'WM_SYSKEYUP'   , ;
    0x0106 => 'WM_SYSCHAR'    , ;
    0x0107 => 'WM_SYSDEADCHAR', ;
    0x0109 => 'WM_UNICHAR'    , ;
    0x0120 => 'WM_MENUCHAR'   , ;
    0x0312 => 'WM_HOTKEY'       }

  LOCAL hKey := { ;
    0x01 => 'VK_LBUTTON'            , ;
    0x02 => 'VK_RBUTTON'            , ;
    0x03 => 'VK_CANCEL'             , ;
    0x04 => 'VK_MBUTTON'            , ;
    0x05 => 'VK_XBUTTON1'           , ;
    0x06 => 'VK_XBUTTON2'           , ;
    0x08 => 'VK_BACK'               , ;
    0x09 => 'VK_TAB'                , ;
    0x0C => 'VK_CLEAR'              , ;
    0x0D => 'VK_RETURN'             , ;
    0x10 => 'VK_SHIFT'              , ;
    0x11 => 'VK_CONTROL'            , ;
    0x12 => 'VK_ALT'                , ;
    0x13 => 'VK_PAUSE'              , ;
    0x14 => 'VK_CAPITAL'            , ;
    0x15 => 'VK_KANA'               , ;
    0x15 => 'VK_HANGEUL'            , ;
    0x15 => 'VK_HANGUL'             , ;
    0x17 => 'VK_JUNJA'              , ;
    0x18 => 'VK_FINAL'              , ;
    0x19 => 'VK_HANJA'              , ;
    0x19 => 'VK_KANJI'              , ;
    0x1B => 'VK_ESCAPE'             , ;
    0x1C => 'VK_CONVERT'            , ;
    0x1D => 'VK_NONCONVERT'         , ;
    0x1E => 'VK_ACCEPT'             , ;
    0x1F => 'VK_MODECHANGE'         , ;
    0x20 => 'VK_SPACE'              , ;
    0x21 => 'VK_PRIOR'              , ;
    0x22 => 'VK_NEXT'               , ;
    0x23 => 'VK_END'                , ;
    0x24 => 'VK_HOME'               , ;
    0x25 => 'VK_LEFT'               , ;
    0x26 => 'VK_UP'                 , ;
    0x27 => 'VK_RIGHT'              , ;
    0x28 => 'VK_DOWN'               , ;
    0x29 => 'VK_SELECT'             , ;
    0x2A => 'VK_PRINT'              , ;
    0x2B => 'VK_EXECUTE'            , ;
    0x2C => 'VK_SNAPSHOT'           , ;
    0x2D => 'VK_INSERT'             , ;
    0x2E => 'VK_DELETE'             , ;
    0x2F => 'VK_HELP'               , ;
    0x30 => 'VK_0'                  , ;
    0x31 => 'VK_1'                  , ;
    0x32 => 'VK_2'                  , ;
    0x33 => 'VK_3'                  , ;
    0x34 => 'VK_4'                  , ;
    0x35 => 'VK_5'                  , ;
    0x36 => 'VK_6'                  , ;
    0x37 => 'VK_7'                  , ;
    0x38 => 'VK_8'                  , ;
    0x39 => 'VK_9'                  , ;
    0x41 => 'VK_A'                  , ;
    0x42 => 'VK_B'                  , ;
    0x43 => 'VK_C'                  , ;
    0x44 => 'VK_D'                  , ;
    0x45 => 'VK_E'                  , ;
    0x46 => 'VK_F'                  , ;
    0x47 => 'VK_G'                  , ;
    0x48 => 'VK_H'                  , ;
    0x49 => 'VK_I'                  , ;
    0x4A => 'VK_J'                  , ;
    0x4B => 'VK_K'                  , ;
    0x4C => 'VK_L'                  , ;
    0x4D => 'VK_M'                  , ;
    0x4E => 'VK_N'                  , ;
    0x4F => 'VK_O'                  , ;
    0x50 => 'VK_P'                  , ;
    0x51 => 'VK_Q'                  , ;
    0x52 => 'VK_R'                  , ;
    0x53 => 'VK_S'                  , ;
    0x54 => 'VK_T'                  , ;
    0x55 => 'VK_U'                  , ;
    0x56 => 'VK_V'                  , ;
    0x57 => 'VK_W'                  , ;
    0x58 => 'VK_X'                  , ;
    0x59 => 'VK_Y'                  , ;
    0x5A => 'VK_Z'                  , ;
    0x5B => 'VK_LWIN'               , ;
    0x5C => 'VK_RWIN'               , ;
    0x5D => 'VK_APPS'               , ;
    0x5F => 'VK_SLEEP'              , ;
    0x60 => 'VK_NUMPAD0'            , ;
    0x61 => 'VK_NUMPAD1'            , ;
    0x62 => 'VK_NUMPAD2'            , ;
    0x63 => 'VK_NUMPAD3'            , ;
    0x64 => 'VK_NUMPAD4'            , ;
    0x65 => 'VK_NUMPAD5'            , ;
    0x66 => 'VK_NUMPAD6'            , ;
    0x67 => 'VK_NUMPAD7'            , ;
    0x68 => 'VK_NUMPAD8'            , ;
    0x69 => 'VK_NUMPAD9'            , ;
    0x6A => 'VK_MULTIPLY'           , ;
    0x6B => 'VK_ADD'                , ;
    0x6C => 'VK_SEPARATOR'          , ;
    0x6D => 'VK_SUBTRACT'           , ;
    0x6E => 'VK_DECIMAL'            , ;
    0x6F => 'VK_DIVIDE'             , ;
    0x70 => 'VK_F1'                 , ;
    0x71 => 'VK_F2'                 , ;
    0x72 => 'VK_F3'                 , ;
    0x73 => 'VK_F4'                 , ;
    0x74 => 'VK_F5'                 , ;
    0x75 => 'VK_F6'                 , ;
    0x76 => 'VK_F7'                 , ;
    0x77 => 'VK_F8'                 , ;
    0x78 => 'VK_F9'                 , ;
    0x79 => 'VK_F10'                , ;
    0x7A => 'VK_F11'                , ;
    0x7B => 'VK_F12'                , ;
    0x7C => 'VK_F13'                , ;
    0x7D => 'VK_F14'                , ;
    0x7E => 'VK_F15'                , ;
    0x7F => 'VK_F16'                , ;
    0x80 => 'VK_F17'                , ;
    0x81 => 'VK_F18'                , ;
    0x82 => 'VK_F19'                , ;
    0x83 => 'VK_F20'                , ;
    0x84 => 'VK_F21'                , ;
    0x85 => 'VK_F22'                , ;
    0x86 => 'VK_F23'                , ;
    0x87 => 'VK_F24'                , ;
    0x90 => 'VK_NUMLOCK'            , ;
    0x91 => 'VK_SCROLL'             , ;
    0x92 => 'VK_OEM_NEC_EQUAL'      , ;
    0x92 => 'VK_OEM_FJ_JISHO'       , ;
    0x93 => 'VK_OEM_FJ_MASSHOU'     , ;
    0x94 => 'VK_OEM_FJ_TOUROKU'     , ;
    0x95 => 'VK_OEM_FJ_LOYA'        , ;
    0x96 => 'VK_OEM_FJ_ROYA'        , ;
    0xA0 => 'VK_LSHIFT'             , ;
    0xA1 => 'VK_RSHIFT'             , ;
    0xA2 => 'VK_LCONTROL'           , ;
    0xA3 => 'VK_RCONTROL'           , ;
    0xA4 => 'VK_LMENU'              , ;
    0xA5 => 'VK_RMENU'              , ;
    0xA6 => 'VK_BROWSER_BACK'       , ;
    0xA7 => 'VK_BROWSER_FORWARD'    , ;
    0xA8 => 'VK_BROWSER_REFRESH'    , ;
    0xA9 => 'VK_BROWSER_STOP'       , ;
    0xAA => 'VK_BROWSER_SEARCH'     , ;
    0xAB => 'VK_BROWSER_FAVORITES'  , ;
    0xAC => 'VK_BROWSER_HOME'       , ;
    0xAD => 'VK_VOLUME_MUTE'        , ;
    0xAE => 'VK_VOLUME_DOWN'        , ;
    0xAF => 'VK_VOLUME_UP'          , ;
    0xB0 => 'VK_MEDIA_NEXT_TRACK'   , ;
    0xB1 => 'VK_MEDIA_PREV_TRACK'   , ;
    0xB2 => 'VK_MEDIA_STOP'         , ;
    0xB3 => 'VK_MEDIA_PLAY_PAUSE'   , ;
    0xB4 => 'VK_LAUNCH_MAIL'        , ;
    0xB5 => 'VK_LAUNCH_MEDIA_SELECT', ;
    0xB6 => 'VK_LAUNCH_APP1'        , ;
    0xB7 => 'VK_LAUNCH_APP2'        , ;
    0xBA => 'VK_OEM_1'              , ;
    0xBB => 'VK_OEM_PLUS'           , ;
    0xBC => 'VK_OEM_COMMA'          , ;
    0xBD => 'VK_OEM_MINUS'          , ;
    0xBE => 'VK_OEM_PERIOD'         , ;
    0xBF => 'VK_OEM_2'              , ;
    0xC0 => 'VK_OEM_3'              , ;
    0xDB => 'VK_OEM_4'              , ;
    0xDC => 'VK_OEM_5'              , ;
    0xDD => 'VK_OEM_6'              , ;
    0xDE => 'VK_OEM_7'              , ;
    0xDF => 'VK_OEM_8'              , ;
    0xE1 => 'VK_OEM_AX'             , ;
    0xE2 => 'VK_OEM_102'            , ;
    0xE3 => 'VK_ICO_HELP'           , ;
    0xE4 => 'VK_ICO_00'             , ;
    0xE5 => 'VK_PROCESSKEY'         , ;
    0xE6 => 'VK_ICO_CLEAR'          , ;
    0xE7 => 'VK_PACKET'             , ;
    0xE9 => 'VK_OEM_RESET'          , ;
    0xEA => 'VK_OEM_JUMP'           , ;
    0xEB => 'VK_OEM_PA1'            , ;
    0xEC => 'VK_OEM_PA2'            , ;
    0xED => 'VK_OEM_PA3'            , ;
    0xEE => 'VK_OEM_WSCTRL'         , ;
    0xEF => 'VK_OEM_CUSEL'          , ;
    0xF0 => 'VK_OEM_ATTN'           , ;
    0xF1 => 'VK_OEM_FINISH'         , ;
    0xF2 => 'VK_OEM_COPY'           , ;
    0xF3 => 'VK_OEM_AUTO'           , ;
    0xF4 => 'VK_OEM_ENLW'           , ;
    0xF5 => 'VK_OEM_BACKTAB'        , ;
    0xF6 => 'VK_ATTN'               , ;
    0xF7 => 'VK_CRSEL'              , ;
    0xF8 => 'VK_EXSEL'              , ;
    0xF9 => 'VK_EREOF'              , ;
    0xFA => 'VK_PLAY'               , ;
    0xFB => 'VK_ZOOM'               , ;
    0xFC => 'VK_NONAME'             , ;
    0xFD => 'VK_PA1'                , ;
    0xFE => 'VK_OEM_CLEAR'            }

  LOCAL hID   := { ;
    VK_A          => 'UNSHIFT+A'  , ;
    VK_B          => 'UNSHIFT+B'  , ;
    VK_C          => 'UNSHIFT+C'  , ;
    VK_D          => 'UNSHIFT+D'  , ;
    VK_E          => 'UNSHIFT+E'  , ;
    VK_F          => 'UNSHIFT+F'  , ;
    VK_G          => 'UNSHIFT+G'  , ;
    VK_H          => 'UNSHIFT+H'  , ;
    VK_I          => 'UNSHIFT+I'  , ;
    VK_J          => 'UNSHIFT+J'  , ;
    VK_K          => 'UNSHIFT+K'  , ;
    VK_L          => 'UNSHIFT+L'  , ;
    VK_M          => 'UNSHIFT+M'  , ;
    VK_N          => 'UNSHIFT+N'  , ;
    VK_O          => 'UNSHIFT+O'  , ;
    VK_P          => 'UNSHIFT+P'  , ;
    VK_Q          => 'UNSHIFT+Q'  , ;
    VK_R          => 'UNSHIFT+R'  , ;
    VK_S          => 'UNSHIFT+S'  , ;
    VK_T          => 'UNSHIFT+T'  , ;
    VK_U          => 'UNSHIFT+U'  , ;
    VK_V          => 'UNSHIFT+V'  , ;
    VK_W          => 'UNSHIFT+W'  , ;
    VK_X          => 'UNSHIFT+X'  , ;
    VK_Y          => 'UNSHIFT+Y'  , ;
    VK_Z          => 'UNSHIFT+Z'  , ;
    VK_0          => '0'          , ;
    VK_1          => '1'          , ;
    VK_2          => '2'          , ;
    VK_3          => '3'          , ;
    VK_4          => '4'          , ;
    VK_5          => '5'          , ;
    VK_6          => '6'          , ;
    VK_7          => '7'          , ;
    VK_8          => '8'          , ;
    VK_9          => '9'          , ;
    VK_F1         => 'F1'         , ;
    VK_F2         => 'F2'         , ;
    VK_F3         => 'F3'         , ;
    VK_F4         => 'F4'         , ;
    VK_F5         => 'F5'         , ;
    VK_F6         => 'F6'         , ;
    VK_F7         => 'F7'         , ;
    VK_F8         => 'F8'         , ;
    VK_F9         => 'F9'         , ;
    VK_F10        => 'F10'        , ;
    VK_F11        => 'F11'        , ;
    VK_F12        => 'F12'        , ;
    VK_SPACE      => 'SPACE'      , ;
    VK_BACK       => 'BACK'       , ;
    VK_TAB        => 'TAB'        , ;
    VK_RETURN     => 'RETURN'     , ;
    VK_ESCAPE     => 'ESCAPE'     , ;
    VK_INSERT     => 'INSERT'     , ;
    VK_DELETE     => 'DELETE'     , ;
    VK_HOME       => 'HOME'       , ;
    VK_END        => 'END'        , ;
    VK_PRIOR      => 'PRIOR'      , ;
    VK_NEXT       => 'NEXT'       , ;
    VK_LEFT       => 'LEFT'       , ;
    VK_UP         => 'UP'         , ;
    VK_RIGHT      => 'RIGHT'      , ;
    VK_DOWN       => 'DOWN'       , ;
    VK_ADD        => 'ADD'        , ;
    VK_SUBTRACT   => 'SUBTRACT'   , ;
    VK_MULTIPLY   => 'MULTIPLY'   , ;
    VK_DIVIDE     => 'DIVIDE'     , ;
    VK_DECIMAL    => 'DECIMAL'    , ;
    VK_NUMPAD0    => 'NUMPAD0'    , ;
    VK_NUMPAD1    => 'NUMPAD1'    , ;
    VK_NUMPAD2    => 'NUMPAD2'    , ;
    VK_NUMPAD3    => 'NUMPAD3'    , ;
    VK_NUMPAD4    => 'NUMPAD4'    , ;
    VK_NUMPAD5    => 'NUMPAD5'    , ;
    VK_NUMPAD6    => 'NUMPAD6'    , ;
    VK_NUMPAD7    => 'NUMPAD7'    , ;
    VK_NUMPAD8    => 'NUMPAD8'    , ;
    VK_NUMPAD9    => 'NUMPAD9'    , ;
    VK_SHIFT      => 'SHIFT+'     , ;
    VK_CONTROL    => 'CONTROL+'   , ;
    VK_ALT        => 'ALT+'         }

  LOCAL nMsgD, nWParD, nLParD, nMsgU, nWParU, nLParU
  LOCAL nKeyD := HMG_GETLASTVIRTUALKEYDOWN(, @nMsgD, @nWParD, @nLParD)
  LOCAL nKeyU := HMG_GETLASTVIRTUALKEYUP(, @nMsgU, @nWParU, @nLParU)
  LOCAL cName := HMG_GETLASTVIRTUALKEYNAME()
  LOCAL cChar := HMG_GETLASTCHARACTER()

  wDemo.tbMsgHD.VALUE  := '0x' + HB_NUMTOHEX(nMsgD)
  wDemo.tbMsgDD.VALUE  := nMsgD
  wDemo.tbMsgTD.VALUE  := IF(HB_HHASKEY(hMsg, nMsgD), hMsg[nMsgD], '')
  wDemo.tbWParHD.VALUE := '0x' + HB_NUMTOHEX(nWParD)
  wDemo.tbWParDD.VALUE := nWParD
  wDemo.tbLParHD.VALUE := '0x' + HB_NUMTOHEX(nLParD)
  wDemo.tbLParDD.VALUE := nLParD
  wDemo.tbKeyHD.VALUE  := '0x' + HB_NUMTOHEX(nKeyD)
  wDemo.tbKeyDD.VALUE  := nKeyD
  wDemo.tbKeyTD.VALUE  := IF(HB_HHASKEY(hKey, nKeyD), hKey[nKeyD], '')

  wDemo.tbMsgHU.VALUE  := '0x' + HB_NUMTOHEX(nMsgU)
  wDemo.tbMsgDU.VALUE  := nMsgU
  wDemo.tbMsgTU.VALUE  := IF(HB_HHASKEY(hMsg, nMsgU), hMsg[nMsgU], '')
  wDemo.tbWParHU.VALUE := '0x' + HB_NUMTOHEX(nWParU)
  wDemo.tbWParDU.VALUE := nWParU
  wDemo.tbLParHU.VALUE := '0x' + HB_NUMTOHEX(nLParU)
  wDemo.tbLParDU.VALUE := nLParU
  wDemo.tbKeyHU.VALUE  := '0x' + HB_NUMTOHEX(nKeyU)
  wDemo.tbKeyDU.VALUE  := nKeyU
  wDemo.tbKeyTU.VALUE  := IF(HB_HHASKEY(hKey, nKeyU), hKey[nKeyU], '')

  wDemo.tbName.VALUE   := cName
  wDemo.tbChar.VALUE   := cChar
  wDemo.tbID.VALUE     := IF(HB_HHASKEY(hID, nKeyD), hID[nKeyD], '')

RETURN
