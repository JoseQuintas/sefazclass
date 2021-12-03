/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW FORM_MAIN ;
		AT 0,0 ;
		WIDTH 640 HEIGHT 480 ;
		TITLE "IPADDRESS CONTROL DEMO" ;
		MAIN

      @ 10,10 EDITBOX EDITBOX_1 VALUE "" WIDTH 150 HEIGHT 400

      // ip 1

      @ 10,200 LABEL LABEL_1 VALUE "IP ADDRESS 1"

      @ 40,200 IPADDRESS IPADDRESS_1 TOOLTIP "IPADDRESS CONTROL 1" ;
         ON GOTFOCUS  {||AddText("IP1 GOTFOCUS")} ;
         ON CHANGE    {||AddText("IP1 CHANGE")} ;
         ON LOSTFOCUS {||AddText("IP1 LOSTFOCUS")}

		@ 70,200 BUTTON BUTTON_1A CAPTION "SET IP 1" ACTION SetIp1()
		@ 70,350 BUTTON BUTTON_1B CAPTION "GET IP 1" ACTION GetIp1()

      // ip 2

      @ 120,200 LABEL LABEL_2 VALUE "IP ADDRESS 2"

      @ 150,200 IPADDRESS IPADDRESS_2 VALUE {127,0,0,1} TOOLTIP "IPADDRESS CONTROL 2" ;
         ON GOTFOCUS  {||AddText("IP2 GOTFOCUS")} ;
         ON CHANGE    {||AddText("IP2 CHANGE")} ;
         ON LOSTFOCUS {||AddText("IP2 LOSTFOCUS")}

		@ 180,200 BUTTON BUTTON_2A CAPTION "SET IP 2" ACTION SetIp2()
		@ 180,350 BUTTON BUTTON_2B CAPTION "GET IP 2" ACTION GetIp2()

      // ip 3

      @ 230,200 LABEL LABEL_3 VALUE "IP ADDRESS 3"

      @ 260,200 IPADDRESS IPADDRESS_3 VALUE {255,255,255,255} TOOLTIP "IPADDRESS CONTROL 3" ;
         ON GOTFOCUS  {||AddText("IP3 GOTFOCUS")} ;
         ON CHANGE    {||AddText("IP3 CHANGE")} ;
         ON LOSTFOCUS {||AddText("IP3 LOSTFOCUS")}

		@ 290,200 BUTTON BUTTON_3A CAPTION "SET IP 3" ACTION SetIp3()
		@ 290,350 BUTTON BUTTON_3B CAPTION "GET IP 3" ACTION GetIp3()

      @ 350,200 BUTTON BUTTON_4 CAPTION "Clear Text" ACTION FORM_MAIN.EDITBOX_1.VALUE := ""

	END WINDOW

	CENTER WINDOW FORM_MAIN

	ACTIVATE WINDOW FORM_MAIN

Return Nil

Function AddText( t )
Local a := FORM_MAIN.EDITBOX_1.VALUE 
a := a + t + Chr(13) + Chr(10)
	FORM_MAIN.EDITBOX_1.Value := a
Return Nil

// SET

Function SetIp1

	FORM_MAIN.IPADDRESS_1.VALUE := {} // clear ip address

Return Nil

Function SetIp2

	FORM_MAIN.IPADDRESS_2.VALUE := {127,0,0,1}

Return Nil

Function SetIp3

	FORM_MAIN.IPADDRESS_3.VALUE := {255,255,255,255}

Return Nil

// GET

Function GetIp1
Local a := FORM_MAIN.IPADDRESS_1.VALUE
MsgInfo(StrZero(a[1],3)+"."+StrZero(a[2],3)+"."+StrZero(a[3],3)+"."+StrZero(a[4],3),"Info")
Return Nil

Function GetIp2
Local a := FORM_MAIN.IPADDRESS_2.VALUE
MsgInfo(StrZero(a[1],3)+"."+StrZero(a[2],3)+"."+StrZero(a[3],3)+"."+StrZero(a[4],3),"Info")
Return Nil

Function GetIp3
Local a := FORM_MAIN.IPADDRESS_3.VALUE
MsgInfo(StrZero(a[1],3)+"."+StrZero(a[2],3)+"."+StrZero(a[3],3)+"."+StrZero(a[4],3),"Info")
Return Nil


