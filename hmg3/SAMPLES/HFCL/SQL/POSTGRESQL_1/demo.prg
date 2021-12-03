/*
 HMG Grid PostgreSql Demo
 (c) 2010 Roberto Lopez
*/

#include "hmg.ch"

#command USE <(db)> [VIA <rdd>] [ALIAS <a>] [<nw: NEW>] ;
            [<ex: EXCLUSIVE>] [<sh: SHARED>] [<ro: READONLY>] ;
            [CODEPAGE <cp>] [CONNECTION <nConn>] [INDEX <(index1)> [, <(indexN)>]] => ;
         dbUseArea( <.nw.>, <rdd>, <(db)>, <(a)>, ;
                    if(<.sh.> .or. <.ex.>, !<.ex.>, NIL), <.ro.>,  [<cp>], [<nConn>] ) ;
         [; dbSetIndex( <(index1)> )] ;
         [; dbSetIndex( <(indexN)> )]

REQUEST PGRDD
         
Function Main

Local	cServer			:= '127.0.0.1' 
Local	cDataBase		:= 'data1'
Local	cUser			:= 'postgres'	
Local	cPassWord		:= '1234'
Local	nConnectionHandle	:= 0

	nConnectionHandle	:= dbPGConnection( cServer + ";" + cDataBase + ";" + cUser + ";" + cPassWord ) 

	CreateTable( cServer , cDataBase , cUser , cPassWord )

	USE "SELECT * FROM test ;" ALIAS Test NEW VIA "pgrdd" CONNECTION nConnectionHandle

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 800 ;
		HEIGHT 510 ;
		TITLE 'Hello World!' ;
		MAIN

		DEFINE MAIN MENU
			POPUP 'File'
				ITEM 'Append (Alt+A)'            ACTION Form_1.Grid_1.Append
				ITEM 'Save Last Appended Record (Alt+S)'   ACTION Form_1.Grid_1.Save
				ITEM 'Set RecNo'            ACTION Form_1.Grid_1.RecNo := val(InputBox('',''))
				ITEM 'Get RecNo'            ACTION MsgInfo( Str(Form_1.Grid_1.RecNo) )
				ITEM 'Delete'               ACTION Form_1.Grid_1.Delete
				ITEM 'Recall'               ACTION Form_1.Grid_1.Recall
			END POPUP
		END MENU

		@ 10,10 GRID Grid_1 ;
			WIDTH 770 ;
			HEIGHT 440 ;
			HEADERS { 'Code' , 'Name' , 'Salary' , 'Creation' , 'Description' } ;
			WIDTHS { 100 , 120 , 120 , 120 , 120 } ;
			VALUE { 1 , 1 } ;
			COLUMNCONTROLS { aCtrl_1 , aCtrl_2 } ;
			ROWSOURCE "Test" 
      
	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return

Function CreateTable ( cServer , cDataBase , cUser , cPassWord )

Local oServer, oQuery, oRow, i 
Local cQuery

	oServer := TPQServer():New( cServer , cDataBase , cUser , cPassWord )

	if oServer:NetErr()
		MsgStop ( oServer:Error() )
		Exit Program
	endif

	if oServer:TableExists('TEST')
		oQuery := oServer:Execute('DROP TABLE Test')
		oQuery:Destroy()
	endif

	cQuery := 'CREATE TABLE test('
	cQuery += '     Code integer not null primary key, '
	cQuery += '     Name Varchar(40), '
	cQuery += '     Salary Double Precision, '
	cQuery += '     Creation Date, '
	cQuery += '     Description text ) '

	oQuery := oServer:Query(cQuery)

	if oQuery:neterr()
		MsgStop ( oQuery:Error() )
	endif

	oQuery:Destroy()

	For i := 1 To 10

		cQuery := "INSERT INTO test ( code , name , salary , creation , description ) VALUES ( " + str(i) + " , 'Name " + str(i) + " ' , " + str(i*1000) + " , '2010-01-01' , 'Some Text...' );"

		oQuery := oServer:Query(cQuery)

		if oQuery:neterr()
			MsgStop ( 'error' )
			Exit
		endif

	next i

	oQuery:destroy()

	oServer:Commit()

	oServer:Destroy()

Return nil
