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
   oDanfe:cArquivoNfeXml := "xmlnota.xml"
   oDanfe:cArquivoCceXml := "xmlcarta.xml"
   oDanfe:cSiteEmitente  := ""
   oDanfe:cEmailEmitente := ""
   oDanfe:cFile          := "xmlcarta.pdf"
   oDanfe:Execute()
   IF oDanfe:cRetorno != "OK"
      ? oDanfe:cRetorno
   ENDIF
   RUN ( "cmd /c start " + oDanfe:cFile )

   RETURN
