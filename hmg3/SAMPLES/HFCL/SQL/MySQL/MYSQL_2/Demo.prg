/*
*
*	HMG MySql Access Sample.
*	Code Contributed by;
*		Mitja Podgornik		<yamamoto@rocketmail.com>
* 
*/

#Include "hmg.ch"

Procedure Main()             

Private oServer:= Nil 
Private cHostName:= "localhost"
Private cUser:= "root"
Private cPassWord:= ""
Private cDataBase:= "NAMEBOOK"                  
Private lLogin:= .F.         

DEFINE WINDOW Form_1 ;
  AT 5,5 ;
  WIDTH 640 ;
  HEIGHT 480;
  TITLE "Harbour + HMG + MySql" ;
  MAIN ;
  NOSIZE ;
  NOMINIMIZE ;
  ON INIT My_SQL_Login() ;
  ON RELEASE My_SQL_Logout()

  DEFINE STATUSBAR 
    STATUSITEM " "
  END STATUSBAR

  DEFINE MAIN MENU
    POPUP "Action"
      ITEM "&Connetct to MySql server, create Database 'NAMEBOOK' and table 'NAMES', insert records from 'Names.dbf'" ACTION Prepare_data()	
      SEPARATOR	                                       			                                    
      ITEM "&View/Edit data from MySql" ACTION Grid_edit()
    END POPUP				
  END MENU                          

END WINDOW

CENTER WINDOW Form_1
ACTIVATE WINDOW Form_1 

Return Nil


*-----------------------------------------------------------------*
Function Grid_edit()
*-----------------------------------------------------------------*

DEFINE WINDOW Grid_Names ;
  AT 5,5 ;
  WIDTH 440 HEIGHT 460 ;
  TITLE "Names" ;
  NOSYSMENU ;
  FONT "Arial" SIZE 09

  @ 10,10 GRID Grid_1 ;
    WIDTH  415 ;
    HEIGHT 329 ;
    HEADERS {"Code", "Name"};
    WIDTHS  {60, 335} ;
    VALUE 1 ;
    ON DBLCLICK Get_Fields(2)

  @ 357,11 LABEL  Label_Search_Generic ;
    VALUE "Search " ;
    WIDTH 70 ;
    HEIGHT 20

  @ 353,85 TEXTBOX cSearch ;
    WIDTH 326 ;
    MAXLENGTH 40 ;
    UPPERCASE  ;
    ON ENTER iif( !Empty(Grid_Names.cSearch.Value), Grid_fill(), Grid_Names.cSearch.SetFocus )

  @ 397,11 BUTTON Bt_New ;
    CAPTION '&New' ;
    ACTION Get_Fields(1)

  @ 397,111 BUTTON Bt_Edit ;
    CAPTION '&Edit' ;
    ACTION Get_Fields(2)

  @ 397,211 BUTTON Bt_Delete ;
    CAPTION '&Delete' ;
    ACTION Delete_Record()

  @ 397,311 BUTTON Bt_exit ;
    CAPTION '&Exit' ;
    ACTION Grid_exit()

END WINDOW 

Grid_Names.cSearch.Value:= "A" 
Grid_Names.cSearch.SetFocus

My_SQL_Connect()
My_SQL_Database_Connect( "NAMEBOOK" )
              
Grid_fill()
             
CENTER WINDOW Grid_Names
ACTIVATE WINDOW Grid_Names

Return Nil



*--------------------------------------------------------------*
Function Grid_fill()                     
*--------------------------------------------------------------*
Local cSearch:= ' "'+Upper(AllTrim(Grid_Names.cSearch.Value ))+'%" '           
Local nCounter:= 0
Local oRow:= {}
Local i:= 0
Local oQuery:= "" 
Local GridMax:= iif(len(cSearch)== 0,  30, 1000000)

DELETE ITEM ALL FROM Grid_1 Of Grid_Names

oQuery := oServer:Query( "Select Code, Name From NAMES WHERE NAME LIKE "+cSearch+" Order By Name" )
If oQuery:NetErr()												
  MsgInfo("SQL SELECT error: " + oQuery:Error())
  RELEASE WINDOW ALL
  Quit
Endif

For i := 1 To oQuery:LastRec()
  nCounter++
  If nCounter ==  GridMax
    Exit
  Endif                   
  oRow := oQuery:GetRow(i)
  ADD ITEM {  Str(oRow:fieldGet(1), 8), oRow:fieldGet(2) } TO Grid_1 Of Grid_Names
  oQuery:Skip(1)
Next

oQuery:Destroy()

Grid_Names.cSearch.SetFocus  

Return Nil



*--------------------------------------------------------------*
Function Grid_exit()                          
*--------------------------------------------------------------*
  Grid_Names.Release
Return Nil   



*--------------------------------------------------------------*
Function  Get_Fields( status )    
*--------------------------------------------------------------*
Local pCode:= AllTrim(GetColValue("Grid_1", "Grid_Names", 1 ))            
Local cCode:= ""
Local cName:= ""
Local cEMail:= ""
Local oQuery  
Local oRow:= {}
            
If status == 2
  oQuery:= oServer:Query( "Select * From NAMES WHERE CODE = " + AllTrim(pCode))
  If oQuery:NetErr()												
    MsgInfo("SQL SELECT error: " + oQuery:Error())
    Return Nil
  Endif               
  oRow:= oQuery:GetRow(1)
  cCode:=Alltrim(Str(oRow:fieldGet(1)))
  cName:= AllTrim(oRow:fieldGet(2))
  cEMail:= AllTrim(oRow:fieldGet(3))                  
  oQuery:Destroy()
EndIf         
              
DEFINE WINDOW Form_4 ;
  AT 0,0 ;
  WIDTH 485 HEIGHT 240 ;
  TITLE iif( status==1 , "Add new record" , "Edit record" )  ;			
  NOMAXIMIZE ;
  FONT "Arial" SIZE 09

  @ 20,30 LABEL Label_Code ;
    VALUE "Code" ;
    WIDTH 150 ;
    HEIGHT 35 ;
    BOLD

  @ 55, 30 LABEL Label_Name ;
    VALUE "Name" ;
    WIDTH 120 ;
    HEIGHT 35 ;
    BOLD

  @ 90,30 LABEL Label_eMail ;
    VALUE "e-Mail" ;
    WIDTH 120 ;
    HEIGHT 35 ;
    BOLD

  @ 24,100 TEXTBOX p_Code ;
    VALUE cCode ;
    WIDTH 50 ;			
    HEIGHT 25 ;
    ON ENTER iif( !Empty(Form_4.p_Code.Value), Form_4.p_Name.SetFocus, Form_4.p_Code.SetFocus ) ;
    RIGHTALIGN

  @ 59,100 TEXTBOX  p_Name ;
    HEIGHT 25 ;
    VALUE cName ;
    WIDTH 350 ;
    ON ENTER iif( !Empty(Form_4.p_Name.Value),  Form_4.p_eMail.SetFocus, Form_4.p_Name.SetFocus )
									
  @ 94,100 TEXTBOX  p_eMail ;
    HEIGHT 25 ;
    VALUE cEMail ;
    WIDTH 350 ;
    ON ENTER Form_4.Bt_Confirm.SetFocus

  @ 165,100 BUTTON Bt_Confirm ;
    CAPTION '&Confirm' ;
    ACTION Set_Record( status )

  @ 165,300 BUTTON Bt_Cancel ;
    CAPTION '&Cancel' ;
    ACTION Form_4.Release

END WINDOW

Form_4.p_Code.Enabled:= .F.

CENTER WINDOW Form_4
ACTIVATE WINDOW Form_4

Return Nil



*--------------------------------------------------------------*
Function GetColValue( xObj, xForm, nCol)
*--------------------------------------------------------------*
  Local nPos:= GetProperty(xForm, xObj, 'Value')
  Local aRet:= GetProperty(xForm, xObj, 'Item', nPos)
Return aRet[nCol] 



*--------------------------------------------------------------*
Function Set_Record( status )
*--------------------------------------------------------------*
Local gCode:= AllTrim(GetColValue("Grid_1", "Grid_Names", 1 ))
Local cCode:= AllTrim(Form_4.p_Code.Value)
Local cName:= AllTrim(Form_4.p_Name.Value)
Local cEMail:= AllTrim(Form_4.p_EMail.Value)
Local cQuery      
Local oQuery      

If status == 1
  cQuery := "INSERT INTO NAMES (Name, eMail)  VALUES ( '"+AllTrim(cName)+"' , '"+cEmail+ "' ) "
Else
  cQuery := "UPDATE NAMES SET  Name = '"+cName+"' , eMail = '"+cEMail+"'  WHERE CODE = " + AllTrim(gCode)
Endif

oQuery:=oServer:Query( cQuery )
If oQuery:NetErr()												
  MsgInfo("SQL UPDATE/INSERT error: " + oQuery:Error())
  Return Nil
Endif				

oQuery:Destroy()
					 																			
MsgInfo( iif(status== 1, "Record added", "Record updated") )

Form_4.Release

Grid_Names.cSearch.Value:=Left(cName, 1)

Grid_Names.cSearch.SetFocus  

Grid_fill() 

Return Nil           



*--------------------------------------------------------------*
Function Delete_Record()
*--------------------------------------------------------------*
Local gCode:= AllTrim(GetColValue("Grid_1", "Grid_Names", 1 ))
Local gName:= AllTrim(GetColValue("Grid_1", "Grid_Names", 2 ))
Local cQuery      
Local oQuery      
                        
If MsgYesNo( "Delete record: "+ gName+ "??" ) 
  cQuery:= "DELETE FROM NAMES  WHERE CODE = " + AllTrim(gCode)         
  oQuery:=oServer:Query( cQuery )
  If oQuery:NetErr()												
    MsgInfo("SQL DELETE error: " + oQuery:Error())
    Return Nil
  EndIf
  oQuery:Destroy()			 																			
  MsgInfo("Record deleted!")
  Grid_fill() 
EndIf
Return Nil           



*--------------------------------------------------------------*
Function  My_SQL_Login() 
*--------------------------------------------------------------*

DEFINE WINDOW Form_0 ;
  AT 0,0 ;
  WIDTH 280 HEIGHT 200 ;
  TITLE 'Login MySql' ;
  NOSYSMENU ;
  FONT "Arial" SIZE 09
                                                   
  @ 24,30 LABEL Label_HostName ;
    VALUE "HostName/IP" ;
    WIDTH 150 ;
    HEIGHT 35 ;
    BOLD

  @ 59,30 LABEL Label_User ;
    VALUE "User" ;
    WIDTH 120 ;
    HEIGHT 35 ;
    BOLD

  @ 94,30 LABEL Label_Password ;
    VALUE "Password" ;
    WIDTH 120 ;
    HEIGHT 35 ;
    BOLD

  @ 20,120 TEXTBOX p_HostName ;
    HEIGHT 25 ;      
    VALUE cHostName ;                                      
    WIDTH 120 ;			
    ON ENTER iif( !Empty(Form_0.p_HostName.Value),  Form_0.p_User.SetFocus, Form_0.p_HostName.SetFocus )

  @ 55,120 TEXTBOX  p_User ;
    HEIGHT 25 ;
    VALUE cUser ;
    WIDTH 120 ;
    ON ENTER iif( !Empty(Form_0.p_User.Value), Form_0.p_Password.SetFocus, Form_0.p_user.SetFocus  )
									
  @ 90,120 TEXTBOX  p_password ;
    VALUE cPassWord ;
    PASSWORD ;
    ON ENTER Form_0.Bt_Login.SetFocus

  @ 130,30 BUTTON Bt_Login ;
    CAPTION '&Login' ;
    ACTION SQL_Connect()

  @ 130,143 BUTTON Bt_Logoff ;
    CAPTION '&Cancel' ;
    ACTION Form_1.Release

END WINDOW

CENTER WINDOW Form_0
ACTIVATE WINDOW Form_0

Return Nil

              
*--------------------------------------------------------------*
Function SQL_Connect()                            
*--------------------------------------------------------------*
cHostName:= AllTrim(  Form_0.p_HostName.Value )
cUser:= AllTrim( Form_0.p_User.Value )
cPassWord:= AllTrim( Form_0.p_password.Value )

oServer := TMySQLServer():New(cHostName, cUser, cPassWord )
If oServer:NetErr() 
  MsGInfo("Error connecting to SQL server: " + oServer:Error() )
  Release Window ALL
  Quit
Endif               	

MsgInfo("Connection to MySql server completed!")

lLogin := .T.

Form_0.Release

Return Nil                     



*--------------------------------------------------------------*
Function Prepare_data()
*--------------------------------------------------------------*
My_SQL_Connect()                            
My_SQL_Database_Create( "NAMEBOOK" )
My_SQL_Database_Connect( "NAMEBOOK" )
My_SQL_Table_Create( "NAMES" )
My_SQL_Table_Insert( "NAMES" )
My_SQL_Logout()     
Return Nil



*--------------------------------------------------------------*
Function  My_SQL_Connect()                            
*--------------------------------------------------------------*
If oServer != Nil
  Return Nil
Endif
oServer := TMySQLServer():New(cHostName, cUser, cPassWord )
If oServer:NetErr() 
  MsGInfo("Error connecting to SQL server: " + oServer:Error() )
  Release Window ALL
  Quit
Endif 
Return Nil 


*--------------------------------------------------------------*
Function  My_SQL_Database_Create( cDatabase )
*--------------------------------------------------------------*
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
  Quit
Endif 

If AScan( aDatabaseList, Lower(cDatabase) ) != 0
  MsgINFO( "Database allready exists!")
  Return Nil
EndIf 

oServer:CreateDatabase( cDatabase )
If oServer:NetErr() 
  MsGInfo("Error creating database: " + oServer:Error() )
  Release Window ALL
  Quit
Endif 

Return Nil


*--------------------------------------------------------------*
Function My_SQL_Database_Connect( cDatabase )
*--------------------------------------------------------------*
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
  Quit
Endif 

If AScan( aDatabaseList, Lower(cDatabase) ) == 0
  MsgINFO( "Database "+cDatabase+" doesn't exist!")
  Return Nil
EndIf 

oServer:SelectDB( cDatabase )
If oServer:NetErr() 
  MsGInfo("Error connecting to database "+cDatabase+": "+oServer:Error() )
  Release Window ALL
  Quit
Endif 

Return Nil


*--------------------------------------------------------------*
Function My_SQL_Table_Create( cTable )				
*--------------------------------------------------------------*
Local i:= 0
Local aTableList:= {}                                           
Local aStruc:= {}            
Local cQuery 

If oServer == Nil
  MsgInfo("Not connected to SQL Server...")
  Return Nil
EndIf
              
aTableList:= oServer:ListTables()
If oServer:NetErr() 
  MsGInfo("Error getting table list: " + oServer:Error() )
  Release Window ALL
  Quit
Endif 

If AScan( aTableList, Lower(cTable) ) != 0
  MsgINFO( "Table "+cTable+" allready exists!")
  Return Nil
EndIf 

cQuery:= "CREATE TABLE "+ cTable+" ( Code SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT ,  Name  VarChar(40) ,  eMail  VarChar(40) , PRIMARY KEY (Code) ) "  
oQuery := oServer:Query( cQuery )											
If oServer:NetErr() 
  MsGInfo("Error creating table "+cTable+": "+oServer:Error() )
  Release Window ALL		
  Quit
Endif 

oQuery:Destroy()     
							
Return Nil

            
*--------------------------------------------------------------*
Function My_SQL_Table_Insert( cTable )				
*--------------------------------------------------------------*
Local cQuery:= ""    
Local NrReg:= 0            

If ! MsgYesNo( "Import data from NAMES.DBF to table Names(MySql) ?" ) 
  Return Nil
EndIf                    

Form_1.StatusBar.Item(1):= "Exporting from Names.DBF to Names(MySql) ..."                                        
                
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

Form_1.StatusBar.Item(1):= " "
MsgInfo( AllTrim(Str(NrReg))+" records added to table "+cTable)       

Return Nil


*--------------------------------------------------------------*
Function My_SQL_Logout()                              
*--------------------------------------------------------------*
  if oServer != Nil                     
    oServer:Destroy()
    oServer := Nil
  EndIf
Return Nil
