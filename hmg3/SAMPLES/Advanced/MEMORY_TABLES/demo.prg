/*
* HMG - Harbour Win32 GUI library Demo
*
* Copyright 2002-2010 Roberto Lopez <mail.box.hmg@gmail.com>
* http://www.hmgforum.com//
*
* Copyright 2009 Grigory Filatov <gfilatov@freemail.ru>
*
* Based on MEMIO sample included in Harbour distribution
*/

#include "hmg.ch"

REQUEST HB_MEMIO

*--------------------------------------------------------*
Function Main()
*--------------------------------------------------------*

OpenTable() 

   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 640 HEIGHT 480 ;
      TITLE 'Memory File System Demo' ;
      MAIN NOMAXIMIZE 

      DEFINE MAIN MENU
         DEFINE POPUP 'Test'
            ITEM "Exit"      ACTION ThisWindow.Release()
         END POPUP
      END MENU

      @ 10,10 GRID grid_1   ;
         WIDTH 610   ;
         HEIGHT 390   ;   
         HEADERS { 'Code' , 'Name' , 'Residents' } ;
         WIDTHS { 50 , 160 , 100 } ;
         ROWSOURCE "memarea" ;
         COLUMNFIELDS { 'Code' , 'Name' , 'Residents' } ;
         JUSTIFY { GRID_JTFY_LEFT, GRID_JTFY_LEFT, GRID_JTFY_RIGHT } 

   END WINDOW

   CENTER WINDOW Form_1

   ACTIVATE WINDOW Form_1

Return nil

*--------------------------------------------------------*
Procedure OpenTable
*--------------------------------------------------------*

   CreateTable()

   INDEX ON FIELD->RESIDENTS TAG residents

   GO TOP

Return

*--------------------------------------------------------*
Procedure CloseTable
*--------------------------------------------------------*

   DBCLOSEAREA()
   DBDROP("mem:test")  // Free memory resource

Return

*--------------------------------------------------------*
Function CreateTable
*--------------------------------------------------------*

   DBCREATE("mem:test", {{"CODE", "C", 3, 0},{"NAME", "C", 50, 0},{"RESIDENTS", "N", 11, 0}},, .T., "memarea")

   DBAPPEND()
   REPLACE CODE WITH 'LTU', NAME WITH 'Lithuania', RESIDENTS WITH 3369600
   DBAPPEND()
   REPLACE CODE WITH 'USA', NAME WITH 'United States of America', RESIDENTS WITH 305397000
   DBAPPEND()
   REPLACE CODE WITH 'POR', NAME WITH 'Portugal', RESIDENTS WITH 10617600
   DBAPPEND()
   REPLACE CODE WITH 'POL', NAME WITH 'Poland', RESIDENTS WITH 38115967
   DBAPPEND()
   REPLACE CODE WITH 'AUS', NAME WITH 'Australia', RESIDENTS WITH 21446187
   DBAPPEND()
   REPLACE CODE WITH 'FRA', NAME WITH 'France', RESIDENTS WITH 64473140
   DBAPPEND()
   REPLACE CODE WITH 'RUS', NAME WITH 'Russia', RESIDENTS WITH 141900000

Return Nil