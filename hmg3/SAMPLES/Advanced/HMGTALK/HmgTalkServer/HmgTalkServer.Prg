/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
 *
 *********************************************************************************
 * Simple Server for test with NETIO
 *
 * Created by : Paulo Sérgio Durço - 23/10/2009 8:30 Hrs
 *
 * Thanks Master Roberto Lopez for your great work.
 *********************************************************************************
 * It is HMG SERVERIO with some modifications.
 * update in 27/01/2010
*/



**********************************************************************************
*Function Main
#include "hmg.ch"
Function Main
	Public c_TITLE := "HMG Talk Server"
     Public pListenSocket

     Set Multiple Off

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 587 HEIGHT 173 ;
		TITLE 'Configurations -- HMG Talk Server' ;
		MAIN ;
		ICON "MAIN" ;
		NOTIFYICON "MAIN" ;
		NOTIFYTOOLTIP 'HMG Talk Server' ;
		ON NOTIFYCLICK Show_Status();
		ON INIT Start_Server();
		ON RELEASE Delete_Table();
		SYSMENU .F. ;
		VISIBLE .F. ;
		SIZABLE .F.

		DEFINE NOTIFY MENU
			ITEM 'About...'		ACTION MsgInfo( 'HMG Talk Server', c_TITLE )
			ITEM 'Configurations'	ACTION Show_Config()
			ITEM 'Restart Server'	ACTION Restart_Server()
			SEPARATOR
			ITEM 'Exit Server'  	ACTION Form_1.Release
		END MENU
          @ 10,10 FRAME Frame_1;
		        WIDTH  560;
        		   HEIGHT 120;
			   OPAQUE

          @ 20,20 LABEL Label_1;
		        WIDTH  40;
        		   HEIGHT 20;
        		   VALUE "Port"

          @ 20,110 TEXTBOX Text_1;
		        WIDTH  40;
		        HEIGHT 20;
		        INPUTMASK "9999"

          @ 50,20 LABEL Label_2;
		        WIDTH  90;
			   HEIGHT 20;
			   VALUE "Database Path"

          @ 50,110 TEXTBOX Text_2;
		        WIDTH  410;
			   HEIGHT 20;
			   READONLY;
        		   MAXLENGTH 100;

          @ 50,530 BUTTON Button_1;
     		   CAPTION "...";
			   ON CLICK SetProperty( "Form_1","Text_2","Value",GetFolder ( "Database Path" ) );
		        WIDTH  30;
			   HEIGHT 20

		@ 90,20 BUTTON Button_2;
        		   CAPTION "Restart Server";
        		   ON CLICK Write_Ini();
		        WIDTH  100;
        		   HEIGHT 28

		@ 90,460 BUTTON Button_3;
        		   CAPTION "Close";
        		   ON CLICK Form_1.Hide;
		        WIDTH  100;
        		   HEIGHT 28

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

**********************************************************************************
* Show config window
Function Show_Config()
	Form_1.Restore
Return

**********************************************************************************
* Start the Server
Function Start_Server()
     Local c_Path  := "C:\"
     Local c_Port  := "2941"
	pListenSocket := NIL

	if !File("Config.ini")
	   Begin ini file ("Config.ini")
	      Set Section "CONFIGURATIONS" ENTRY "Port"   To c_Port
	      Set Section "CONFIGURATIONS" ENTRY "Path"   To c_Path
	   End ini
	else
	   Begin ini file ("Config.ini")
	      Get c_Port   Section "CONFIGURATIONS" ENTRY "Port"
	      Get c_Path   Section "CONFIGURATIONS" ENTRY "Path"
	   End Ini
     endif

	Form_1.Text_1.Value := c_Port
	Form_1.Text_2.Value := c_Path

	pListenSocket := netio_mtserver( Val( AllTrim(Form_1.Text_1.Value) ) )

	if empty( pListenSocket )
		SetProperty( "Form_1","NOTIFYICON","STOP" )
		MsgStop( "Cannot start server!", c_TITLE )
	else
	    SetProperty( "Form_1","NOTIFYICON","MAIN" )
		DBCreate( "Messenger.DBF", {{"COD","N",5,0}, {"NICK","C",10,0}, {"MSG","C",200,0}, ;
		                            {"ONLINE","L",1,0}, {"TONICK","C",10,0}} )		
	    Show_Status()									
	endif
Return Nil

**********************************************************************************
Function Delete_Table()
	FErase("Messenger.DBF")
Return Nil

**********************************************************************************
* Stop the Server
Function Stop_Server()
     if !empty( pListenSocket )
		SetProperty( "Form_1","NOTIFYICON","STOP" )
		netio_serverstop( pListenSocket )
		pListenSocket := NIL
//  		Show_Status()
     endif
Return Nil

**********************************************************************************
* Show Server status
Function Show_Status()
     if !empty( pListenSocket )
		MsgInfo( "Hmg Talk Server is running at Port: " ;
                 + AllTrim(Form_1.Text_1.Value) + CHR(13);
                 + "Database Path : " + AllTrim(Form_1.Text_2.Value), c_TITLE )
     else
		MsgInfo( "Hmg Talk Server stoped!", c_TITLE )
     endif
Return Nil

**********************************************************************************
* Restart the Server
Function Restart_Server()
	    Stop_Server()
		Delete_Table()
	    Start_Server()
Return Nil

**********************************************************************************
* Write the INI file with content in text´s box on Form_1 (Config Window)
Function Write_Ini()
	if File("Config.ini")
	   fErase("Config.ini")
     endif

	Begin ini file ("Config.ini")
	   Set Section "CONFIGURATIONS" ENTRY "Port"   To Form_1.Text_1.Value
	   Set Section "CONFIGURATIONS" ENTRY "Path"   To Form_1.Text_2.Value
     End ini

	Restart_Server()
Return Nil