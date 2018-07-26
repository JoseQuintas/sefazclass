#include "directry.ch"

MEMVAR cFileName

PROCEDURE Main

   LOCAL x, nPos, aTagsAbre := {}, cTmp
   PARAMETERS cFileName

   x := MemoRead( cFileName )

   DO WHILE .T.
      nPos := hb_At( "<", x, nPos )
      IF nPos < 1
         EXIT
      ENDIF
      IF Substr( x, nPos + 1, 1 ) == "/"
         ProcFecha( Substr( x, nPos, hb_At( ">", x, nPos ) - nPos ), aTagsAbre )
      ELSE
         cTmp := Substr( x, nPos, hb_At( ">", x, nPos ) - nPos )
         IF ! "/" $ cTmp
            AAdd( aTagsAbre, cTmp )
            ? "Abriu " + Atail( aTagsAbre )
         ENDIF
      ENDIF
      nPos := nPos + 3
   ENDDO
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
      ? "fechou " + cTag
      hb_ADel( aTagsAbre, Len( aTagsAbre ), .T. )
   ELSE
      ? "erro " + cTag + " esperada " + Atail( aTagsAbre ) +  "Len() " + Str( Len( aTagsAbre ) )
      FOR EACH oElement IN aTagsAbre
         ? oELement
      NEXT
      Inkey(0)
      QUIT
   ENDIF

   RETURN NIL
