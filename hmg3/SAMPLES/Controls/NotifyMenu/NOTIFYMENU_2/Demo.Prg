/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

Function Main

	Public NFlag := .f.

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 HEIGHT 480 ;
		TITLE 'Notifycation Icon Demo (Based Upon a Contribution Of Grigory Filatov)' ;
		MAIN ;
		NOTIFYICON 'DEMO.ICO' ;
		NOTIFYTOOLTIP 'HMG Power Is Here Too!!' ;
		ON NOTIFYCLICK ProcessNotify()

		DEFINE NOTIFY MENU 
			ITEM 'About...'	ACTION MsgInfo('HMG Notify Icon Demo')
			ITEM 'Change Notify Icon' 	ACTION Form_1.NotifyIcon := 'DEMO2.ICO'
			ITEM 'Change Notify Tooltip'	ACTION Form_1.NotifyTooltip := 'New Tooltip'
			ITEM 'Get Notify Icon Name'	ACTION MsgInfo ( Form_1.NotifyIcon ) 
			ITEM 'Get Notify Icon Tooltip'	ACTION MsgInfo ( Form_1.NotifyTooltip ) 
			SEPARATOR	
			ITEM 'Exit Application'	ACTION Form_1.Release
		END MENU

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

Function ProcessNotify()

	If nflag == .f.
		Form_1.Hide
		nflag := .t.
	Else
		Form_1.Restore
		nflag := .f.
	EndIf

Return

