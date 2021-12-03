# include "hmg.ch"

FUNCTION connect2db(dbname,lCreate)
dbo := sqlite3_open(dbname,lCreate)
IF Empty( dbo )
   msginfo("Database could not be connected!")
   RETURN .f.
ENDIF
RETURN .t.


function sql(dbo1,qstr)
local table := {}
local currow := nil
local tablearr := {}
local rowarr := {}
local datetypearr := {}
local numtypearr := {}
local typesarr := {}
local current := ""
local i := 0
local j := 0
local type1 := ""
if empty(dbo1)
   msgstop("Database Connection Error!")
   return tablearr
endif
table := sqlite3_get_table(dbo1,qstr)
if sqlite3_errcode(dbo1) > 0 // error
   msgstop(sqlite3_errmsg(dbo1)+" Query is : "+qstr)
   return nil
endif 
stmt := sqlite3_prepare(dbo1,qstr)
IF ! Empty( stmt )
   for i := 1 to sqlite3_column_count( stmt )
      type1 := sqlite3_column_decltype( stmt,i)
      do case
         case type1 == "INTEGER" .or. type1 == "REAL" .or. type1 == "FLOAT"
            aadd(typesarr,"N")
         case type1 == "DATE"
            aadd(typesarr,"D")   
         otherwise
            aadd(typesarr,"C")
      endcase
   next i
endif
sqlite3_reset( stmt )
if len(table) > 1
   asize(tablearr,0)
   rowarr := table[2]
   for i := 2 to len(table)
      rowarr := table[i]
      for j := 1 to len(rowarr)
         do case
            case typesarr[j] == "D"
               cDate := substr(rowarr[j],1,4)+substr(rowarr[j],6,2)+substr(rowarr[j],9,2)
               rowarr[j] := stod(cDate)
            case typesarr[j] == "N"
               rowarr[j] := val(rowarr[j])
         endcase      
      next j
      aadd(tablearr,aclone(rowarr))
   next i
endif
return tablearr

function miscsql(dbo1,qstr)
if empty(dbo1)
   msgstop("Database Connection Error!")
   return .f.
endif
sqlite3_exec(dbo1,qstr)
if sqlite3_errcode(dbo1) > 0 // error
   msgstop(sqlite3_errmsg(dbo1)+" Query is : "+qstr)
   return .f.
endif 
return .t.

function C2SQL(Value)

   local cValue := ""
    local cFormatoDaData := set(4)
   do case
      case Valtype(Value) == "N"
         cValue := AllTrim(Str(Value))

      case Valtype(Value) == "D"
         if !Empty(Value)
            cdate := dtos(value)
            cValue := "'"+substr(cDate,1,4)+"-"+substr(cDate,5,2)+"-"+substr(cDate,7,2)+"'"
         else
            cValue := "''"
         endif

      case Valtype(Value) $ "CM"
         IF Empty( Value)
            cValue="''"
         ELSE
            cValue := "'" + value+ "'"
         ENDIF

      case Valtype(Value) == "L"
         cValue := AllTrim(Str(iif(Value == .F., 0, 1)))

      otherwise
         cValue := "''"       // NOTE: Here we lose values we cannot convert

   endcase

return cValue
