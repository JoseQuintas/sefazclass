************************************************************************
* This is a simple Messenger that was write on HMG and HMG IDE 3
*
* Please, my code is not so good, i know that :D
*
* Thanks Master Roberto Lopez for your great work.
* Thanks to my brothers of job, Aloisio Perreira and Sandro Valérius and
* my wife Jaqueline de Freitas Durço to use, tests and your suggestions.
************************************************************************
* Paulo Sérgio Durço (Vanguarda) January 2010.
* E-Mail vanguarda.one@gmail.com/vanguarda_one@hotmail.com
* Blog   www.hmglights.wordpress.com
************************************************************************

#include <hmg.ch>
#define PROGRAM "HMG Talk"
#define VERSION " Test version "
#define COPYRIGHT " Paulo Sérgio Durço, 2010"

#define		IDI_MAIN	1001

************************************************************************
* This function call the MAIN Window
* and set the environment variables
************************************************************************
Function Main()
   Public c_W_Title   :=  "HMG Talk"
   Public l_Conected  := .f.
   Public lMsg_Balloon:= .f.
   Public c_RingTone  := GetCurrentFolder() + "\Media\Toque(1).Wav"
   
   *Set Multiple Off
   Set deleted On
   
   Load Window Main	
   Main.Center
   Main.Activate
Return Nil

************************************************************************
* This function call the LOGIN Window
************************************************************************
Function Login()
	Load Window Login
	Login.Center
	Login.Activate
Return Nil

************************************************************************
* This function open a conexion with HMG Talk Server with NETIO.
* On server side, a unique table was create.
************************************************************************ 
Function Start_Conexion()
	Public c_Str_Con := "net:" + Alltrim(c_Ip_Server) + ":Messenger.DBF"
	
	waitwindow( "Wait connecting...", .t. )
	if NETIO_CONNECT(Alltrim(c_Ip_Server),"2941")
	    waitwindow()
		waitwindow( "Wait, updating grid...", .t. )
		
	    DBUseArea(.t.,,c_STR_Con,"Messenger",.t.)	

		Public l_Conected := .t.		
		
		Inc_Line(c_NickName,"I´m on-line...")
		
		Main.Text_1.SetFocus()
				
	Else
		MsgInfo("Can´t connect at : " + Alltrim(c_Ip_Server),c_W_Title)
		Main.Release
	Endif
	waitwindow()

Return Nil

************************************************************************
* This function will include a new msg on the database
************************************************************************
Function Inc_Line(c_Nick,c_Msg,lOnline,c_TONick)
	Default lOnline  := .t.
	Default c_TONick := ""
	
	iif( Alltrim( c_TONick ) == "All" , c_TONick := "" , )
	
	if !Empty(c_Msg)
		
		while(!Messenger->(RLock()))
		Enddo
		Messenger->(DbAppend())
		Messenger->COD  	:= Messenger->( LastRec() + 1 )
		Messenger->Nick 	:= c_Nick
		Messenger->MSG  	:= c_Msg + " [" + Time() 
		If !Empty(c_TONick)
			Messenger->MSG  := Alltrim(Messenger->MSG) + " - private to " + ;
			                   Alltrim(c_TONick)
		endif
		Messenger->MSG		:= Alltrim(Messenger->MSG) + "]"
		Messenger->ONLINE 	:= lOnline
		Messenger->TONick	:= c_TONick
		Messenger->(DbCommit())
		Messenger->(DbUnlock())
		Main.Text_1.Value := ""
		Main.Text_1.SetFocus()
		
	endif
Return Nil

************************************************************************
* This function read the news messages in the server, and
* add it on grid
************************************************************************
Function Read_MSG()
	Local n_Reg_Grid := Main.Grid_1.ItemCount
	Local a_Msgs	 := {}
	Local i , a , d , n_Rest
	If l_Conected
		if n_Reg_Grid < Messenger->(LastRec()) 
			a_Msgs := Read_Data()
			
			if Len(a_Msgs) > 0
			
				Read_Nicks()
							
				For a := 1 to Len(a_Msgs)			
					Main.Grid_1.AddItem( a_Msgs[a] )
					// It is a little easter egg, put this string in your
					//client, so all clients will down, and not be able 
                                        //to connect on server until that the server is restart.
                                        //Try it on privete message, is very fun.
					Do Case
						Case SubStr(Alltrim(a_Msgs[a][2]),1,08) == "$LINEOFF" 
																	Main.Release
					EndCase
				Next a
							
				if lMsg_Balloon 
					if  Main.Check_1.Value
						for i := 1 to len( a_Msgs )
							MsgBalloon( Alltrim( a_Msgs[i][2] ), ; 
										Alltrim( a_Msgs[i][1] ) +;
														 " Say:" )
						next i
					endif
					
					if  Main.Check_2.Value				
						for e := 1 to 5
							SetProperty("Main","NOTIFYICON",Nil)
							hb_idleSleep(0.105)
							SetProperty("Main","NOTIFYICON","MSG")
							hb_idleSleep(0.105)					
						next e					
					endif
				endif
				
				Main.Label_2.Value := "Last message received at " + ;
									   Time()
									   
				if Alltrim( c_NickName ) != Alltrim( a_Msgs[Len(a_Msgs)][1] )
					if !Main.Check_1.Value .and. !Main.Check_2.Value
						iif(empty(c_RingTone),c_RingTone := "Media\Toque(1).Wav",)
						CallDll32 ( "sndPlaySoundA" , "WINMM.DLL" ,  c_RingTone , 0 )
					endif
				endif
				
			endif				
		endif
		
		if n_Reg_Grid > Messenger->(LastRec())
			for d := 1 to n_Reg_Grid
				Main.Grid_1.DeleteItem(d)
			Next d		
		endif
		
		if Main.Check_3.Value
			Main.Grid_1.Value := Main.Grid_1.ItemCount
		endif
		
	endif
Return Nil

************************************************************************
* This function returns an array with the all news messages
* of the database.
************************************************************************
Function Read_Data()
	Local a_Msg  	 := {}
	Local a_Msgs 	 := {}
	Local i 	 := 0
	Local a_Position := Main.Grid_1.Item(Main.Grid_1.ItemCount)
	Local n_Position := 0 
	
	Messenger->( DbGoTo( Main.Grid_1.ItemCount + 1 ) )	
	While( Messenger->( !EOF() ) )
		
		if Empty(Messenger->TONICK) .or. Alltrim(Messenger->TONICK) == Alltrim(c_NickName) .or. ;
				            	 Alltrim(Messenger->NICK)   == Alltrim(c_NickName)

                                        for i := 1 to Main.Grid_1.ItemCount
                                            aAdd( a_Position, Main.Grid_1.Item(i)[2] )
                                        next i

					if aScan( a_Position, Alltrim(Messenger->MSG) ) > 0
					else
					Aadd( a_Msg, Messenger->NICK )
					Aadd( a_Msg, Messenger->MSG )					
					Aadd( a_Msgs, a_Msg )
					endif
		endif
		a_Msg := {}
		Messenger->(DBSkip(1))
		
	enddo
	
Return a_Msgs

************************************************************************
* This function returns an array with the all NickNames
* logged´s in HMG Talk.
************************************************************************
Function Read_Nicks()
	Local i 	 := 1
        Local a_Nicks	 := {}
	Local n_NoLogged := 0
	Local n_OldItem  := Main.Combo_1.Value
	
	Main.Combo_1.DeleteAllItems
	
	While( i <= Messenger->( LastRec() ) )
	
		Messenger->( DbGoTo( i ) )
		if Messenger->ONLINE
			if Alltrim(Messenger->Nick) != c_NickName
				if aScan( a_Nicks, Alltrim( Messenger->NICK ) ) < 1
					Aadd( a_Nicks, Alltrim( Messenger->NICK ) )
				endif
			endif
		else
			n_NoLogged := aScan( a_Nicks, Alltrim( Messenger->NICK ) )
			if n_NoLogged > 0
				aDel( a_Nicks, n_NoLogged )
			endif
		endif
		i ++
		
	enddo
	
	Aadd( a_Nicks, "All" )

	for i := 1 to len( a_Nicks )
		Main.Combo_1.AddItem( a_Nicks[i] )
	next i 
	
	if n_OldItem < 1 
		Main.Combo_1.Value := Len( a_Nicks )	
	else
		Main.Combo_1.Value := n_OldItem
	endif
	
Return Nil

************************************************************************
* Show message for all when close HMG TAlk
*************************************************************************
Function Close_Msg()
	If l_Conected
		Inc_Line(c_NickName,"I´m off-line now...",.f.)
	Endif
Return Nil

************************************************************************
* Change variable lMsg_Balloon
************************************************************************
Function Change_lMsg(lStatus)
	lMsg_Balloon := lStatus
	If !lMsg_Balloon 
		Main.Text_1.SetFocus()
	endif
Return Nil

************************************************************************
* Restore window MAIN 
************************************************************************
Function Show_talk()
	lMsg_Balloon := .f.	
	Main.Restore
Return Nil

************************************************************************
* Change mode, messages on tray, silent mode or only sound.
************************************************************************
Function Change_Mode(nItem)
	Do case
		Case nItem = 1
			If Main.Check_1.Value
				Main.Check_2.Value := .f.
			endif
		Case nItem = 2
			If Main.Check_2.Value
				Main.Check_1.Value := .f.
			endif			
	endcase
Return Nil




************************************************************************
* This part of the code, was copied of TrayBalloon demo avaliable on HMG Extended
* This source was writen by Grigory Filatov
************************************************************************
*--------------------------------------------------------*
Static Procedure ActivateNotifyMenu()
*--------------------------------------------------------*
	DEFINE NOTIFY MENU OF MAIN
		ITEM 'A&bout...'	ACTION ShellAbout( "About " + PROGRAM + "#", ;
			PROGRAM + VERSION + CRLF + "Copyright " + Chr(169) + COPYRIGHT, ;
			LoadTrayIcon(GetInstance(), "Speak1.ico") )
		SEPARATOR	
		ITEM 'E&xit'		ACTION MAIN.Release
	END MENU

Return


*--------------------------------------------------------*
Static Procedure MsgBalloon( cMessage, cTitle )
*--------------------------------------------------------*
	Local i := Ascan( _HMG_SYSDATA, GetFormHandle("Main") )

	Default cMessage := "Prompt", cTitle := PROGRAM

	ShowNotifyInfo( _HMG_SYSDATA[i], .F. , NIL, NIL, NIL, NIL )

	ShowNotifyInfo( _HMG_SYSDATA[i], .T. , LoadTrayIcon( GetInstance(), ;
		"Speak1.ico" ), "", cMessage, cTitle )

Return

/*
 * C-level
*/
#pragma BEGINDUMP

#define _WIN32_IE      0x0500
#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400
#include <shlobj.h>

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"

static void ShowNotifyInfo(HWND hWnd, BOOL bAdd, HICON hIcon, LPSTR szText, LPSTR szInfo, LPSTR szInfoTitle);

HB_FUNC ( SHOWNOTIFYINFO )
{
	ShowNotifyInfo( (HWND) hb_parnl(1), (BOOL) hb_parl(2), (HICON) hb_parnl(3), (LPSTR) hb_parc(4), 
			(LPSTR) hb_parc(5), (LPSTR) hb_parc(6) );
}

static void ShowNotifyInfo(HWND hWnd, BOOL bAdd, HICON hIcon, LPSTR szText, LPSTR szInfo, LPSTR szInfoTitle)
{
	NOTIFYICONDATA nid;

	ZeroMemory( &nid, sizeof(nid) );

	nid.cbSize		= sizeof(NOTIFYICONDATA);
	nid.hIcon		= hIcon;
	nid.hWnd		= hWnd;
	nid.uID			= 0;
	nid.uFlags		= NIF_INFO | NIF_TIP | NIF_ICON;
	nid.dwInfoFlags		= NIIF_INFO;

	lstrcpy( nid.szTip, TEXT(szText) );
	lstrcpy( nid.szInfo, TEXT(szInfo) );
	lstrcpy( nid.szInfoTitle, TEXT(szInfoTitle) );

	if(bAdd)
		Shell_NotifyIcon( NIM_ADD, &nid );
	else
		Shell_NotifyIcon( NIM_DELETE, &nid );

	if(hIcon)
		DestroyIcon( hIcon );
}

#pragma ENDDUMP
