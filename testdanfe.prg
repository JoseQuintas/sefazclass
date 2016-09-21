#include "hbclass.ch"

PROCEDURE TesteDanfe

   LOCAL oDanfe

   oDanfe                 := hbnfeDanfe():new()
   oDanfe:cArquivoXml     := "xmlnota.xml"
   oDanfe:cFile           := "xmlnota.pdf"
   oDanfe:cSiteEmitente  := ""
   oDanfe:cEmailEmitente := ""
   oDanfe:cDesenvolvedor := ""
   ? oDanfe:Execute()
   IF .NOT. oDanfe:aRetorno[ "OK" ]
      ? oDanfe:aRetorno[ "MsgErro" ]
   ENDIF
   RUN ( "cmd /c start " + oDanfe:cFile )

   oDanfe := hbnfeDanfeCce():New()
   oDanfe:cSiteEmitente  := ""
   oDanfe:cEmailEmitente := ""
   oDanfe:Execute( MemoRead( "xmlcarta.xml" ), MemoRead( "xmlnota.xml" ), "xmlcarta.pdf" )
   IF oDanfe:cRetorno != "OK"
      ? oDanfe:cRetorno
   ENDIF
   RUN ( "cmd /c start " + oDanfe:cFile )

   RETURN
