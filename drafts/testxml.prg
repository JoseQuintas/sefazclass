#include "directry.ch"

MEMVAR cFileName, cTxtErro

PROCEDURE Main

   LOCAL cTexto, nPos, aTagsAbre := {}, cTmp, oElement
   PARAMETERS cFileName

   cTexto := MemoRead( cFileName )
   cTxtErro := ""
   DO WHILE .T.
      nPos := hb_At( "<", cTexto, nPos )
      IF nPos < 1
         EXIT
      ENDIF
      IF Substr( cTexto, nPos + 1, 1 ) == "/"
         IF ! ProcFecha( Substr( cTexto, nPos, hb_At( ">", cTexto, nPos ) - nPos ), aTagsAbre )
            EXIT
         ENDIF
      ELSE
         cTmp := Substr( cTexto, nPos, hb_At( ">", cTexto, nPos ) - nPos + 1 )
         IF ! "/>" $ cTmp .AND. ! "/ >" $ cTmp
            AAdd( aTagsAbre, cTmp )
            //? "Abriu " + Atail( aTagsAbre )
         ENDIF
      ENDIF
      nPos := nPos + 3
   ENDDO
   IF Len( aTagsAbre ) == 0
      ? .T.
   ELSE
      cTxtErro += "Em aberto" + hb_Eol()
      FOR EACH oElement IN aTagsAbre
         cTxtErro += oElement + hb_Eol()
      NEXT
      ? cTxtErro
      ? .F.
   ENDIF
   Inkey(0)

   RETURN

FUNCTION ProcFecha( cTag, aTagsAbre )

   LOCAL oElement

   FOR EACH oElement IN aTagsAbre
      IF " " $ oElement
         oElement := Substr( oElement, 1, At( " ", oElement ) - 1 )
      ENDIF
      IF ">" $ oElement
         oElement := Substr( oElement, 1, At( ">", oElement ) - 1 )
      ENDIF
      IF "<" $ oElement
         oElement := Trim( Substr( oElement, 2 ) )
      ENDIF
   NEXT
   cTag := Substr( cTag, 3 )
   IF ">" $ cTag
      cTag := Substr( cTag, 1, At( ">", cTag ) - 1 )
   ENDIF
   IF cTag == Atail( aTagsAbre )
      //? "fechou " + cTag
      hb_ADel( aTagsAbre, Len( aTagsAbre ), .T. )
   ELSE
      IF Len( aTagsAbre ) != 0
         cTxtErro += "erro fechada " + cTag + " esperada " + Atail( aTagsAbre ) + hb_Eol()
      ENDIF
      RETURN .F.
   ENDIF

   RETURN .T.
