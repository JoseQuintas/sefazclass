/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

FUNCTION Main

  LOCAL bEval, bWrite

  DEFINE WINDOW wEval ;
		AT 0,0 ;
    WIDTH 820 HEIGHT 130 ;
    TITLE "Evaluate expression" ;
		MAIN ;
    FONT "Segoe UI Symbol" SIZE 12

    @  10, 10 TEXTBOX tbEval WIDTH 710 HEIGHT 26;
       VALUE "'Birthday ' + HMG_CHR(0x1F382) + ' Smile ' + HMG_CHR(0x1F60A)"

    @  10,730 BUTTON btEval CAPTION 'Eval' ;
              ACTION {|| bEval:EVAL() } WIDTH 60 HEIGHT 26 

    @  50, 10 TEXTBOX tbValue WIDTH 710 HEIGHT 26 READONLY ;
              VALUE HMG_CESU8( 'Birthday ' + HMG_CHR(0x1F382) + ' Smile ' + HMG_CHR(0x1F60A) )

    @  50,730 BUTTON btWrite CAPTION 'Write' ;
              ACTION {|| bWrite:EVAL() } WIDTH 60 HEIGHT 26

	END WINDOW

  bEval := {||
    LOCAL xVal
    BEGIN SEQUENCE WITH { || BREAK( NIL ) }
      xVal := &( wEval.tbEval.VALUE )
    RECOVER
      xVal := 'Error'
    END
    wEval.tbValue.VALUE := HMG_CESU8( HB_VALTOSTR( xVal ) )
    RETURN NIL
  }

  bWrite := {||
    LOCAL cFile := 'Eval.txt'
    LOCAL cText := HMG_UTF8RemoveBOM ( MEMOREAD( cFile ) )
    LOCAL cEval := HMG_UNCESU8( wEval.tbValue.VALUE )
    IF EMPTY(cText)
      cText := cEval
    ELSE
      cText += E"\r\n" + cEval
    END
    HB_MEMOWRIT( cFile, HMG_UTF8InsertBOM ( cText ) )
    MsgInfo( 'Value written to ' + cFile )
    RETURN NIL
  }

  CENTER WINDOW wEval
  ACTIVATE WINDOW wEval

RETURN NIL
