/*
*
*	HMG Basic MySql Access Sample.
*	Roberto Lopez <mail.box.hmg@gmail.com>
*
*	Based Upon Code Contributed by;
*
*		Humberto Fornazier	<hfornazier@brfree.com.br>
*		Mitja Podgornik		<yamamoto@rocketmail.com>
* 
*/

#include "hmg.ch"

*------------------------------------------------------------------------------*
Function Main
*------------------------------------------------------------------------------*

	Private oServer	:= Nil 
	
	DEFINE WINDOW Win_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'MySql Basic Sample' ;
		MAIN ;
		ON INIT Connect() ;
		ON RELEASE Disconnect()

		DEFINE MAIN MENU

			DEFINE POPUP 'File'
				MENUITEM 'Prepare Data'	ACTION Prepare_Data()
			END POPUP

			DEFINE POPUP 'Query'
				MENUITEM 'Open Query WIndow'	ACTION ShowQuery()
			END POPUP

		END MENU

	END WINDOW

	Win_1.Center

	ACTIVATE WINDOW Win_1

Return
*------------------------------------------------------------------------------*
Procedure Connect
*------------------------------------------------------------------------------*
/*

	Class TMySQLServer:

		- Manages access to a MySQL server and returns an oServer object 
		to which you'll send all your queries.

		- Administra el acceso a un servidor MySql y retorna un objeto
		oServer al cual se le enviaran los comandos SQL.

	Method New(cServer, cUser, cPassword): 

		- Opens connection to a server, returns a server object.

		- Abre una conexion a un servidor, retorna un objeto servidor.

	Method NetErr():

		- Returns .T. if something went wrong

		- Retorna .T. en caso de error.

	Method Error():

		- Returns textual description of last error.

		- Retorna la descripcion del ultimo error.

	Method SelectDB(cDBName):

		- Which data base I will use for subsequent queries.

		- Selecciona la base de datos que se usara en los siguientes
		consultas.

*/

	// Connect

	oServer := TMySQLServer():New("localhost", "root", "")

	// Check For Error

	If oServer:NetErr()
		MsgStop(oServer:Error())
		Win_1.Title := 'MySql Basic Sample - Not Connected' 
	Else

		MsgInfo("Connected")
		Win_1.Title := 'MySql Basic Sample - Connected' 

	EndIf

Return
*------------------------------------------------------------------------------*
Procedure Disconnect()
*------------------------------------------------------------------------------*
/*..............................................................................

	Class TMySQLServer - Method Destroy():

		- Closes connection to server.
		
		- Cierra la conexion con un servidor.

..............................................................................*/

	oServer:Destroy()
	Win_1.Title := 'MySql Basic Sample - Not Connected' 

Return

*------------------------------------------------------------------------------*
Procedure ShowQuery ()
*------------------------------------------------------------------------------*
Private cSearch := ''

	// Select DataBase - Seleccionar Base de Datos

	oServer:SelectDB( "NAMEBOOK" )

	// Check For Error - Verificar Errores

	If oServer:NetErr() 
		MsgStop( oServer:Error() )
	Endif 

	Define Window ShowQuery ;
		At 0,0 ;
		Width 640 ;
		Height 480 ;
		Title 'Show Query' ;
		Modal ;
		NoSize

		Define Main Menu
			Define Popup 'Operations'
				MenuItem 'New Query' Action ( cSearch := AllTrim ( InputBox ( "Enter Search String" , "Query By Name") ) , DoQuery ( cSearch ) )
				MenuItem 'Append Row' Action AppendRow()
				MenuItem 'Edit Row' Action EditRow()
				MenuItem 'Delete Row' Action DeleteRow()
				Separator
				MenuItem 'Refresh' Action DoQuery ( cSearch )
			End Popup
		End Menu

		Define Grid Grid_1
			Row 0
			Col 0
			Width 631
			Height 430
			Headers {'Code','Name'}
			Widths {250,250}
		End Grid

	End Window		

	ShowQuery.Center

	ShowQuery.Activate

Return

*------------------------------------------------------------------------------*
Function DoQuery( cSearch )
*------------------------------------------------------------------------------*
/*..............................................................................

	Class TMySQLServer - Method Query(cQuery):

		- Gets a textual query and returns a TMySQLQuery or TMySQLTable 
		object.

		- Obtiene una consulta y retorna un objeto TMySQLQuery o 
		TMySQLTable 

	Class TMySQLQuery:

		- A standard query to an oServer with joins. Every query has a 
		GetRow() method which on every call returns a TMySQLRow object 
		which, in turn, contains requested fields.
		Query objects convert MySQL answers (which is an array of 
		strings) to clipper level types.
		At present time N (with decimals), L, D, and C clipper types 
		are supported.

		- Una consulta estandar a un objeto oServer con joins. Cada
		consulta tiene un metodo GetRow(), el cual en cada llamada, 
		retorna un objeto TMySQLRow, el que contiene los campos 
		requeridos.
		Los objetos Query convierten las respuestas MySql (la cual es
		un array de cadenas) a tipos Clipper.
		Actualmente los tipos N (con decimales), L, D, and C son 
		soportados.

	Class TMySQLQuery - Method LastRec() :

		- Number of rows available on answer.

		- Numero de filas disponibles en la respuesta.		

	Class TMySQLQuery - Method Skip() :

		- Same as clipper ones.

		- Identico al de Clipper.

	Class TMySQLQuery - Method Destroy():

		- Destroys specified query object.

		- Destruye el objeto Query especificado.		

	Class TMySQLQuery - Method GetRow(nRow):

		- Return Row n of answer.

		- Retorna ¤a fila n de una respuesta.

	Class TMySQLRow:

		- Every row returned by a SELECT is converted to a TMySQLRow 
		object. This object handles fields and has methods to access 
		fields given a field name or position.

		- Cada fila retornada por un SELECT es convertida a un 
		objeto TMySQLRow- Este objeto maneja campos y tiene metodos
		para accederlos dado un nombre de campo o una posicion.

	Class TMySQLRow - Method FieldGet(cnField):

		- Same as clipper ones, but FieldGet() and FieldPut() accept a 
		string as field identifier, not only a number.

		- Identico al de Clipper, excepto que acepta una cadena de
		caracteres como identificador de campo (no solo un numero).

..............................................................................*/

Local oQuery
Local oRow
Local i
Local aQuery := {}

	cSearch := '"' + cSearch + "%" + '"'

	oQuery := oServer:Query( "Select Code, Name From Names Where Name Like " + cSearch + " Order By Name" )

	If oQuery:NetErr()												
		MsgStop ( oQuery:Error() )
		Return
	Endif

	ShowQuery.Grid_1.DeleteAllItems()

	For i := 1 To oQuery:LastRec()

		oRow := oQuery:GetRow(i)
		
		ShowQuery.Grid_1.AddItem ( { Str(oRow:fieldGet(1), 8) , oRow:fieldGet(2) } )

		oQuery:Skip(1)

	Next

	oQuery:Destroy()

Return ( aQuery )

*------------------------------------------------------------------------------*
Procedure DeleteRow()
*------------------------------------------------------------------------------*
Local oQuery
Local aGridRow
Local i
Local cCode

	i := ShowQuery.Grid_1.Value

	if i == 0 
		Return
	EndIf

	if MsgYesNo("Are You Sure")

		aGridRow	:= ShowQuery.Grid_1.Item (i)
		cCode		:= aGridRow [1]

		oQuery := oServer:Query( "DELETE FROM NAMES WHERE CODE = " + cCode )

		If oQuery:NetErr()												
			MsgStop ( oQuery:Error() )
			Return
		Endif

		oQuery:Destroy()

		DoQuery ( cSearch )

	EndIf

Return

*------------------------------------------------------------------------------*
Procedure EditRow()
*------------------------------------------------------------------------------*
Local oQuery
Local aGridRow
Local i

Local aResults 	
Local cCode
Local cName
Local cEMail

	i := ShowQuery.Grid_1.Value

	if i == 0 
		Return
	EndIf

	aGridRow	:= ShowQuery.Grid_1.Item (i)
	cCode		:= aGridRow [1]

	oQuery:= oServer:Query( "Select * From NAMES WHERE CODE = " + AllTrim(cCode))

	If oQuery:NetErr()												
		MsgStop(oQuery:Error())
		Return Nil
	Else

		oRow	:= oQuery:GetRow(1)
		cCode	:= Alltrim(Str(oRow:fieldGet(1)))
		cName	:= AllTrim(oRow:fieldGet(2))
		cEMail	:= AllTrim(oRow:fieldGet(3))                  
		oQuery:Destroy()

		aResults := InputWindow	(;
					'Edit Row'			, ;
					{ 'Name:' , 'Email:' }, ;
					{ cName , cEmail }	, ;
					{ 40 , 40 }			;
					)

		If aResults [1] != Nil
	
			cName		:= AllTrim(aResults [1])
			cEMail		:= AllTrim(aResults [2])

			oQuery		:= oServer:Query( "UPDATE NAMES SET  Name = '"+cName+"' , eMail = '"+cEMail+"'  WHERE CODE = " + AllTrim(cCode) )

			If oQuery:NetErr()												
				MsgStop(oQuery:Error())
			Else
				DoQuery ( cSearch )
			EndIf

		EndIf

	EndIf

Return
*------------------------------------------------------------------------------*
Procedure AppendRow()
*------------------------------------------------------------------------------*
Local oQuery
Local aGridRow
Local i
Local cQuery
Local aResults 	
Local cCode
Local cName
Local cEMail


	aResults := InputWindow ( ;
				'Append Row' , ;
				{ 'Name:' , 'Email:' } , ;
				{ '' , '' } , ;
				{ 40 , 40 } ;
				)

	If aResults [1] != Nil
	
		cCode	:= ""
		cName	:= AllTrim(aResults [1])
		cEMail	:= AllTrim(aResults [2])

		cQuery := "INSERT INTO NAMES VALUES ( '' , '"+ AllTrim(cName)+"'  , '"+cEmail+ "' ) "

		oQuery	:= oServer:Query( cQuery )

		If oQuery:NetErr()												
			MsgStop(oQuery:Error())
		Else
			DoQuery ( cName )
		EndIf

	EndIf

Return

*------------------------------------------------------------------------------*
Function Prepare_data()
*------------------------------------------------------------------------------*

	My_SQL_Database_Create( "NAMEBOOK" )
	My_SQL_Database_Connect( "NAMEBOOK" )
	My_SQL_Table_Create( "NAMES" )
	My_SQL_Table_Insert( "NAMES" )

Return Nil

*------------------------------------------------------------------------------*
Function  My_SQL_Database_Create( cDatabase )
*------------------------------------------------------------------------------*
Local i:= 0
Local aDatabaseList:= {} 

	cDatabase:=Lower(cDatabase)

	If oServer == Nil 
		MsgInfo("Not connected to SQL server!")
		Return Nil
	EndIf

	aDatabaseList:= oServer:ListDBs()

	If oServer:NetErr() 
		MsGInfo("Error verifying database list: " + oServer:Error())
		Release Window ALL
	Endif 

	If AScan( aDatabaseList, Lower(cDatabase) ) != 0
		MsgINFO( "Database allready exists!")
		Return Nil
	EndIf 

	oServer:CreateDatabase( cDatabase )

	If oServer:NetErr() 
		MsGInfo("Error creating database: " + oServer:Error() )
	Endif 

Return Nil

*------------------------------------------------------------------------------*
Function My_SQL_Database_Connect( cDatabase )
*------------------------------------------------------------------------------*
/*..............................................................................

	Class TMySQLServer - Method ListDBs()

		- Returns an array with list of data bases available.

		- Retorna un array con la lista de bases de datos disponibles.

	Class TMySQLServer - ListTables()

		- Returns an array with list of available tables in current
		database.

		- Retorna un array con la lista de tablas disponibles en la
		base de datos actual.

..............................................................................*/

Local i:= 0
Local aDatabaseList:= {}                                           

	cDatabase:= Lower(cDatabase)
	If oServer == Nil 
		MsgInfo("Not connected to SQL server!")
		Return Nil
	EndIf

	aDatabaseList:= oServer:ListDBs()
	If oServer:NetErr() 
		MsGInfo("Error verifying database list: " + oServer:Error())
		Release Window ALL
	Endif 

	If AScan( aDatabaseList, Lower(cDatabase) ) == 0
		MsgINFO( "Database "+cDatabase+" doesn't exist!")
		Return Nil
	EndIf 

	oServer:SelectDB( cDatabase )
	If oServer:NetErr() 
		MsgStop("Error connecting to database "+cDatabase+": "+oServer:Error() )
	Endif 

Return Nil

*------------------------------------------------------------------------------*
Function My_SQL_Table_Create( cTable )				
*------------------------------------------------------------------------------*
Local i:= 0
Local aTableList:= {}                                           
Local aStruc:= {}            
Local cQuery 

	If oServer == Nil
		MsgStop("Not connected to SQL Server...")
		Return Nil
	EndIf
              
	aTableList:= oServer:ListTables()
	If oServer:NetErr() 
		MsgStop("Error getting table list: " + oServer:Error() )
		Return
	Endif 

	If AScan( aTableList, Lower(cTable) ) != 0
		MsgStop( "Table "+cTable+" allready exists!")
		Return
	EndIf 

	cQuery:= "CREATE TABLE "+ cTable+" ( Code SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT ,  Name  VarChar(40) ,  eMail  VarChar(40) , PRIMARY KEY (Code) ) "  
	oQuery := oServer:Query( cQuery )											
	If oServer:NetErr() 
		MsgStop("Error creating table "+cTable+": "+oServer:Error() )
		Return
	Endif 

	oQuery:Destroy()     
							
Return Nil
            
*------------------------------------------------------------------------------*
Function My_SQL_Table_Insert( cTable )				
*------------------------------------------------------------------------------*
Local cQuery:= ""    
Local NrReg:= 0            

	If ! MsgYesNo( "Import data from NAMES.DBF to table Names(MySql) ?" ) 
		Return Nil
	EndIf                    

	If !File( "NAMES.DBF" ) 
		MsgBox( "File Names.dbf doesn't exist!" )
		Return Nil
	EndIf

	Use Names Alias Names New
	go top

	Do While !Eof()

		cQuery := "INSERT INTO "+ cTable + " VALUES ( '"+Str(Names->Code,8)+"' , '"+ AllTrim(Names->Name)+"' , '"+Names->Email+ "' ) "   
		oQuery := oServer:Query(  cQuery )
		If oServer:NetErr() 
			MsGInfo("Error executing Query "+cQuery+": "+oServer:Error() )
			EXIT 
		Endif 

		oQuery:Destroy()
                      
		NrReg++

		skip

	EndDo

	use

	MsgInfo( AllTrim(Str(NrReg))+" records added to table "+cTable)       

Return Nil

