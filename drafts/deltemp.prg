#include "directry.ch"

PROCEDURE main

   LOCAL aFiles, cPath := "c:\temp\", aItem

   aFiles := Directory( cPath + "*.*" )
   FOR EACH aItem IN aFiles
      fErase( cPath + aItem[ F_NAME ] )
   NEXT

   RETURN
