#include <hmg.ch>

* Temporary Table Test by Grigory Filatov
* Slightly modified by Roberto Lopez

Function Main

CreateTemp()
   
   define window winMain ;
      at 0, 0 ;
      width 640 height 480 main ;
      title "Temporary Table" 
      
      DEFINE GRID brwTemp
         COL 0
         ROW 0
         WIDTH 600
         HEIGHT 340
         HEADERS {"Item Code", "Item Description", "Rate"}
         WIDTHS {125, 300, 100}
         ROWSOURCE "curItem"
         COLUMNFIELDS {"itemcd", "itemnm", "rate"}
      END GRID
      
   end window
   
   winMain.center
   winMain.activate

Return

function CreateTemp()
   local aDbf := {}
   aadd(adbf,   {"itemcd", "c",   10, 0})
   aadd(adbf,   {"itemnm", "c",   40,   0})
   aadd(adbf,   {"rate",   "n",    8, 2})
   
   if !hb_dbcreatetemp("curItem", adbf)
      msgbox("Cannot create temporary table: Item")
      RELEASE WINDOW ALL
      return nil
   endif
   
   if select("curItem") = 0
      use curItem new
   endif
   select curItem
   append blank
   curItem->itemcd := "CD"
   curItem->itemnm := "Compact Disc"
   curItem->rate := 10.00
   unlock

return nil