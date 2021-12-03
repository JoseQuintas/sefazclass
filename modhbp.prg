#include "directry.ch"

PROCEDURE Main

   SetMode( 30, 100 )
   CLS
   TestAll( hb_cwd() + "hmge\", "hmge.hbc" )
   Inkey(0)

   RETURN

FUNCTION TestAll( cPath, cHbc )

   LOCAL aList, aFile, cFile

   aList := Directory( cPath + "*.*", "D" )
   FOR EACH aFile IN aList
      cFile := Lower( aFile[ F_NAME ] )
      DO CASE
      CASE Right( cFile, 4 ) == ".hbp"
         TestProject( cPath, cFile, cHbc )
      CASE "D" $ aFile[ F_ATTR ]
         IF ! aFile[ F_NAME ] == "." .AND. ! aFile[ F_NAME ] == ".."
            TestAll( cPath + cFile + "\", "../" + cHbc )
         ENDIF
      ENDCASE
      Inkey()
   NEXT

   RETURN Nil

FUNCTION TestProject( cPath, cFile, cHbc )

   LOCAL cTxt, cTxtOld, aList, cItem

   cTxt    := MemoRead( cPath + cFile )
   cTxtOld := cTxt
   IF ! "-hbcontainer" $ cTxt
      IF ! "-w" $ cTxt
         cTxt := "-w0" + hb_Eol() + hb_Eol() + cTxt
      ENDIF
      IF Len( Directory( cPath + "*.fmg" ) ) != 0
         IF ! "-I." $ Upper( cTxt )
            cTxt := "-I." + hb_Eol() + hb_Eol() + cTxt
         ENDIF
      ENDIF
      IF ! "-o" $ cTxt
         cTxt := "-o" + Left( cFile, At( ".", cFile + "." ) -1 ) + hb_Eol() + hb_Eol() + cTxt
      ENDIF
      IF ! cHbc $ Lower( cTxt )
         cTxt := cHbc + hb_Eol() + hb_Eol() + cTxt
      ENDIF
   ENDIF

   aList    := hb_RegExSplit( hb_Eol(), cTxt )

   FOR EACH cItem IN aList
      cItem := AllTrim( cItem )
      IF "-o" $ cItem .AND. ".hbp" $ cItem
         cItem := Left( cItem, Len( cItem ) - 4 )
         ? "corrigindo " + cPath + cFile
      ENDIF
   NEXT
   cTxt := ""
   FOR EACH cItem IN aList
      IF ! "workdir" $ cItem .AND. ! "-inc" $ cItem
         cTxt += cItem + hb_Eol()
      ENDIF
   NEXT
   IF ! cTxt == cTxtOld
      hb_MemoWrit( cPath + cFile, cTxt )
      ? cPath + cFile
   ENDIF

   RETURN Nil

