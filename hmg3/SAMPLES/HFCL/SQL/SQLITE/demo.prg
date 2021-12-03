
* SQLITE Sample by Rathinagiri / MOL / Sudip / Grigory Filatov (HMG Forum)

#include "hmg.ch"

function main
local aTable := {}
local aCurRow := {}
public dbo := nil
public cDBName := "sample.db3"

set century on
set date ital

if .not. file(cDBName)
   create_populate()
else
   connect2db(cDBName)   
endif   

define window sample at 0,0 width 800 height 500 main

define grid table
   row 10
   col 10
   width 780
   height 400
   widths {200,100,100,100,50,200}
   headers {"Text","Number","Floating","Date1","Logic","Text2"}
end grid

define button P_ViewRecord
   row 450
   col 100
   width 140
   height 24
   caption "View record = Giri11"
   action ViewRecord()
end button

define button P_ChangeRecord
   row 450
   col 300
   width 140
   height 24
   caption "Popraw"
   action ChangeRecord()
end button

end window
RefreshTable()
sample.center
sample.activate
return NIL

function RefreshTable

   sample.table.DeleteAllItems()
   
   aTable := sql(dbo,"select * from new where date1 <= "+c2sql(ctod("15-04-2010")))
   for i := 1 to len(aTable)
      aCurRow := aTable[i]
      sample.table.additem({aCurRow[1],str(aCurRow[2]),str(aCurRow[3]),dtoc(aCurRow[4]),iif(aCurRow[5]==1,"True","False"),aCurRow[6]})
   next i
   if sample.table.itemcount > 0
      sample.table.value := 1
   endif
   sample.table.Refresh
return nil   


function create_populate()
local cCreateSQL := "CREATE TABLE new (text VARCHAR(50), number INTEGER PRIMARY KEY AUTOINCREMENT, floating FLOAT, date1 DATE, logic INTEGER, text2  VARCHAR(40))"
local cCreateIndex := "CREATE UNIQUE INDEX unique1 ON new (text,text2)"


if .not. connect2db(cDBName,.t.)
   return nil
endif

if .not. miscsql(dbo,cCreateSQL)
   return nil
endif

if .not. miscsql(dbo,cCreateIndex)
   return nil
endif

for i := 1 to 100
   
cQStr := "insert into new (text,floating,date1,logic,text2) values ("+;
          c2sql("Giri"+alltrim(str(i)))+","+;
          c2sql(123.45)+","+;
          iif(i <= 50,c2sql(date()),c2sql(ctod("18-09-2010")))+","+;
          c2sql(.t.)+","+;
          c2sql("India")+;
          ")"
if .not. miscsql(dbo,cQstr)
   return nil
endif
         
next i

msginfo("Insert Queries Completed!")
         
return nil


function ViewRecord
   local aResult
   
   aResult := sql(dbo, 'Select text2 from new where text = "Giri11"') // for update')
   if !empty(aResult)
      msgbox("Result is: " + aResult[1,1])
   endif
return

function ChangeRecord
   local aTemp := {space(40)}
   
   aTemp := InputWindow("Put your value for TEXT2", {"New value:"}, {space(40)}, {40})
   if aTemp[1] != Nil // changed here
      cQstr := "update new set text2= '" +aTemp[1] +"' where text='Giri11'"
       if !miscsql(dbo,cQstr)
         msginfo("Error during writing!")
      else
         msgbox("TEXT2 saved OK")
         RefreshTable()
      endif
   endif
return