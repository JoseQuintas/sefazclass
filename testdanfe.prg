#include "hbclass.ch"

PROCEDURE TesteDanfe

   LOCAL oDanfe

   SetMode( 40, 100 )
   CLS
   oDanfe := hbnfeDanfe():new()
   oDanfe:Execute( MemoRead( "xmlnota.xml" ), "xmlnota.pdf" )
   IF oDanfe:cRetorno != "OK"
      ? oDanfe:cRetorno
   ENDIF
   RUN ( "cmd /c start " + oDanfe:cFile )

   oDanfe := hbnfeDanfeCce():New()
   oDanfe:Execute( MemoRead( "xmlcarta.xml" ), MemoRead( "xmlnota.xml" ), "xmlcarta.pdf" )
   IF oDanfe:cRetorno != "OK"
      ? oDanfe:cRetorno
   ENDIF
   RUN ( "cmd /c start " + oDanfe:cFile )

   RETURN
