/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/
*


#include "hmg.ch"

Function Main

	SET TOOLTIPSTYLE BALLOON

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 HEIGHT 490 ;
		TITLE 'வணக்கம். இது HMG' ;
		ICON 'DEMO.ICO' ;
		MAIN ;
		FONT 'Arial' SIZE 10 

		DEFINE STATUSBAR
			STATUSITEM 'உலக மொழிகளில் HMG!' 
		END STATUSBAR

		ON KEY ALT+A ACTION MsgInfo('Alt+A அழுத்தியுள்ளீர்கள்!')

		DEFINE MAIN MENU 
			DEFINE POPUP '&கோப்பு'
				ITEM 'InputWindow சோதனை'	ACTION InputWindow_Click()
				ITEM 'மேலதிக சோதனைகள்'	ACTION Modal_CLick()	NAME File_Modal
				ITEM 'எப்போதும் மேலே இருக்கும் சாளரம்'	ACTION Topmost_Click()  NAME File_TopMost
				ITEM 'சாதாரண சாளரம்'	ACTION Standard_Click()
				ITEM 'திருத்தக் கூடிய அட்டவணை சோதனை' ACTION EditGrid_Click()
				ITEM 'குழந்தைச் சாளர சோதனை' ACTION Child_Click()
				SEPARATOR	
				POPUP 'இன்னும் அதிகமான...'
					ITEM 'உப தெரிவு 1'	ACTION MsgInfo( 'உபதெரிவு தேர்வு செய்யப்பட்டது' )
					ITEM 'உப தெரிவு 2'	ACTION MsgInfo( 'உபதெரிவு தேர்வு செய்யப்பட்டது' )
				END POPUP
				SEPARATOR	
				ITEM 'ஒன்றுக்கும் அதிகமான சாளரங்கள் திறக்கும் சோதனை'	ACTION MultiWin_Click() 
				SEPARATOR	
				ITEM 'படம் பிடிக்க (எந்த உள்ளடக்கமும் இன்றி)'	ACTION Form_1.Capture() 
				ITEM 'படம் பிடிக்க (உள்ளடக்கங்களுடன்)'		ACTION Form_1.Capture( 'xxx.bmp' , 10,10,200,200 ) 
				SEPARATOR	
				ITEM 'வெளியேற'		ACTION Form_1.Release
			END POPUP
			DEFINE POPUP '&அடைவு சார்புகள்'
				ITEM 'விண்டோஸ் அடைவு - GetWindowsFolder()'	ACTION MsgInfo ( GetWindowsFolder() )
				ITEM 'சிஸ்டம் அடைவு - GetSystemFolder()'	ACTION MsgInfo ( GetSystemFolder() )
				ITEM 'டாக்குமெண்ட்ஸ் அடைவு - GetMyDocumentsFolder()'	ACTION MsgInfo ( GetMyDocumentsFolder() )
				ITEM 'டெஸ்க்டாப் அடைவு - GetDesktopFolder()'	ACTION MsgInfo ( GetDesktopFolder() )
				ITEM 'செயலிகள் அடைவு - GetProgramFilesFolder()'	ACTION MsgInfo ( GetProgramFilesFolder())
				ITEM 'தற்காலிக அடைவு - GetTempFolder()'		ACTION MsgInfo ( GetTempFolder() ) 
				SEPARATOR
				ITEM 'அடைவு பெறுதல் - GetFolder()'		ACTION MsgInfo(GetFolder())
			END POPUP
			DEFINE POPUP '&பொது உரையாடல் பெட்டி சார்புகள்'
				ITEM 'கோப்பு தேர்ந்தெடுக்க - GetFile()'	ACTION Getfile ( { {'Images','*.jpg'} } , 'படங்கள் மட்டும்' )
				ITEM 'கோப்பு வைக்க - PutFile()'	ACTION Putfile ( { {'Images','*.jpg'} } , 'படத்தைச் சேமி' )
				ITEM 'எழுத்துரு தேர்ந்தெடுக்க - GetFont()'	ACTION GetFont_Click()
				ITEM 'வண்ணம் தேர்ந்தெடுக்க - GetColor()'	ACTION GetColor_Click()
			END POPUP
			DEFINE POPUP '&ஒலி சார்புகள்'
				ITEM 'பீப் ஒலிக்க - PlayBeep()'	 ACTION PlayBeep() 
				ITEM '* ஒலிக்க - PlayAsterisk()'	 ACTION PlayAsterisk() 
				ITEM '! ஒலிக்க - PlayExclamation()' ACTION PlayExclamation() 
				ITEM 'கைத்தட்டல் - PlayHand()'	 ACTION PlayHand() 
				ITEM 'கேள்வி ஒலி - PlayQuestion()'	 ACTION PlayQuestion() 
				ITEM 'ஒப்புக் கொள்ளும் ஒலி - PlayOk()'		 ACTION PlayOk() 
			END POPUP
			DEFINE POPUP '&இதர'
				POPUP 'நினைவகம்...'
               ITEM 'நினைவக நிலவரம் - MemoryStatus() Function (உபயம் -  Grigory Filatov)' ACTION MemoryTest() 
               ITEM 'பற்றி ShellAbout() Function (உபயம் -  Manu Exposito' ACTION ShellAbout() 
               ITEM 'பின்புல/முன்புல வண்ணம் (உபயம் - Ismael Dutra)' ACTION Color_CLick() 
   			END POPUP
				POPUP 'கட்டுப்பாடு பண்பு பெற'
               ITEM 'கட்டுப்பாடு வரி பெற' 	ACTION 	MsgInfo ( Str ( ( Form_1.Button_1.Row     ) ) , 'பட்டன் வரி' )
               ITEM 'கட்டுப்பாடு கலம் பெற' 	ACTION 	MsgInfo ( Str ( ( Form_1.Button_1.Col     ) ) , 'பட்டன் கலம்' )
               ITEM 'கட்டுப்பாடு அகலம் பெற' 	ACTION 	MsgInfo ( Str (  ( Form_1.Button_1.Width   ) ) , 'பட்டன் அகலம்' )
               ITEM 'கட்டுப்பாடு உயரம் பெற' 	ACTION 	MsgInfo ( Str (  ( Form_1.Button_1.Height  ) ) , 'பட்டன் உயரம்' )
   			END POPUP
				POPUP 'கட்டுப்பாடு பண்பு மாற்ற'
               ITEM 'கட்டுப்பாடு வரி மாற்றம்' 	ACTION Form_1.Button_1.Row 		:= 35
               ITEM 'கட்டுப்பாடு கலம் மாற்றம்' 	ACTION Form_1.Button_1.Col 		:= 40
               ITEM 'கட்டுப்பாடு அகலம் மாற்றம்' 	ACTION Form_1.Button_1.Width 	:= 150
               ITEM 'கட்டுப்பாடு உயரம் மாற்றம்' 	ACTION Form_1.Button_1.Height 	:= 50
   			END POPUP
				POPUP 'சாளரப் பண்பு மாற்ற'
               ITEM 'சாளர வரி மாற்றம்' 		ACTION Form_1.Row := 10
               ITEM 'சாளர கலம் மாற்றம்' 		ACTION Form_1.Col := 10
               ITEM 'சாளர அகலம் மாற்றம்' 	ACTION Form_1.Width	:= 550
               ITEM 'சாளர உயரம் மாற்றம்' 	ACTION Form_1.Height := 400
   			END POPUP
				POPUP 'சாளரப் பண்பு பெற'
               ITEM 'சாளர வரி பெற' 		ACTION MsgInfo ( Str ( ( Form_1.Row    ) ) )
               ITEM 'சாளர கலம் பெற' 		ACTION MsgInfo ( Str ( ( Form_1.Col    ) ) )
               ITEM 'சாளர அகலம் பெற' 	ACTION MsgInfo ( Str ( ( Form_1.Width  ) ) )
               ITEM 'சாளர உயரம் பெற' 	ACTION MsgInfo ( Str ( ( Form_1.Height ) ) )
   			END POPUP
				ITEM 'கட்டளை செயல்படுத்து' 			ACTION ExecTest()
				POPUP 'சாளரத் தலைப்பு'
               ITEM 'சாளரத் தலைப்பு மாற்ற'		ACTION Form_1.Title := 'புதிய தலைப்பு'
               ITEM 'சாளரத் தலைப்பு பெற'		ACTION MsgInfo (  ( Form_1.Title ) )
   			END POPUP
				POPUP 'கட்டுப்பாடு் தலைப்பு'
               ITEM 'கட்டுப்பாடு தலைப்பு மாற்ற'		ACTION SetCaptionTest()
               ITEM 'கட்டுப்பாடு தலைப்பு பெற'		ACTION GetCaptionTest()
   			END POPUP
				POPUP 'கட்டுப்பாடு் படம்'
               ITEM 'கட்டுப்பாடு படம் பெற'		ACTION MsgInfo (  ( Form_1.Image_1.Picture ) , 'படம்_1' ) 
   			END POPUP
				POPUP 'கட்டுப்பாடு் உதவி'
               ITEM 'கட்டுப்பாடு உதவி மாற்ற'		ACTION Form_1.Button_1.ToolTip := 'புதிய உதவிச் செய்தி'
               ITEM 'கட்டுப்பாடு உதவி பெற'		ACTION MsgInfo (  ( Form_1.Button_1.ToolTip ) , 'கட்டுப்பாடு உதவிச் செய்தி' )
   			END POPUP
				POPUP 'கட்டுப்பாடு எழுத்துரு'
               ITEM 'கட்டுப்பாடு எழுத்துரு பெற'		ACTION  Form_1.Button_1.FontName := 'Verdana'
               ITEM 'கட்டுப்பாடு எழுத்துரு மாற்ற'		ACTION MsgInfo (  ( Form_1.Button_1.FontName ) , 'கட்டுப்பாடு எழுத்துரு' )
               ITEM 'கட்டுப்பாடு எழுத்துரு அளவு மாற்ற'		ACTION Form_1.Button_1.FontSize := 14
               ITEM 'கட்டுப்பாடு எழுத்துரு அளவு பெற'		ACTION MsgInfo ( Str ( ( Form_1.Button_1.FontSize ) ) )
   			END POPUP
				POPUP 'வரையறை'
               ITEM 'குறை வரையறை மாற்ற'		ACTION Form_1.Spinner_1.RangeMin := 1
               ITEM 'குறை வரையறை பெற'		ACTION MsgInfo ( Str ( ( Form_1.Spinner_1.RangeMin ) ) , 'ஸ்பின்னர் - 1')
               ITEM 'நிறை வரையறை மாற்ற'		ACTION Form_1.Spinner_1.RangeMax := 1000
               ITEM 'நிறை வரையறை பெற'		ACTION MsgInfo ( Str ( ( Form_1.Spinner_1.RangeMax ) ) ,'ஸ்பின்னர் - 1')
   			END POPUP
				POPUP 'அட்டவணை'
               ITEM 'அட்டவணை தலைப்பு மாற்ற'	ACTION Form_1.Tab_1(1).Grid_1.Caption(1) := 'புதிய தலைப்பு'
               ITEM 'அட்டவணை தலைப்பு பெற'	ACTION MsgInfo ( ( Form_1.Tab_1(1).Grid_1.Caption(1) ) ,'அட்டவணை_1')
   			END POPUP
				POPUP 'ரேடியோ தெரிவாக்கம்'
               ITEM 'ரேடியோ தலைப்பு மாற்ற'	ACTION Form_1.Tab_1(2).Radio_1.Caption(1) := 'புதிய தலைப்பு'
               ITEM 'ரேடியோ தலைப்பு பெற'	ACTION MsgInfo ( ( Form_1.Tab_1(2).Radio_1.Caption(1) ) ,'ரேடியோ_1')
   			END POPUP
				POPUP 'பக்கத் தெரிவாக்கம்'
               ITEM 'பக்கத் தலைப்பு மாற்ற'	ACTION Form_1.Tab_1.Caption(1) := 'புதிய தலைப்பு'
               ITEM 'பக்கத் தலைப்பு பெற'	ACTION MsgInfo ( ( Form_1.Tab_1.Caption(1) ) ,'பக்கம்_1')
   			END POPUP
			END POPUP
			DEFINE POPUP '&உதவி'
				ITEM 'பற்றி'		ACTION MsgInfo ("வணக்கம். இது HMGன் ஒருங்குறி பதிப்பு","HMG பொது பதம்") 
			END POPUP
		END MENU

		DEFINE CONTEXT MENU 
			ITEM 'தெரிவு செய் கோப்பு - மேலதிக சோதனைகள்'	ACTION Context1_Click()
			ITEM 'தெரிவு செய்யாதே கோப்பு - மேலதிக சோதனைகள்'	ACTION Context2_Click() 
			ITEM 'திடமாக்கு கோப்பு - எப்போதும் மேலிருக்கும் சாளரம்'	ACTION Context3_Click()
			ITEM 'முடமாக்கு கோப்பு - எப்போதும் மேலிருக்கும் சாளரம்'	ACTION Context4_Click()
			SEPARATOR	
         ITEM 'பற்றி'		ACTION MsgInfo ("வணக்கம். இது HMGன் ஒருங்குறி பதிப்பு","HMG பொது பதம்") 
		END MENU

		DEFINE LABEL Label_Color
			ROW	70
			COL	10
			VALUE 'சாளரத்தில் வலது கிளிக் செய்க' 
			WIDTH 170 
			HEIGHT 22 
			FONTNAME 'Times New Roman' 
			FONTSIZE 10 
			FONTCOLOR BLUE
		END LABEL

		DEFINE LABEL Label_Color_2
			ROW	45
			COL	10
			VALUE 'ALT+A அழுத்தும் சோதனை' 
			WIDTH 170 
			HEIGHT 22 
			FONTNAME 'Times New Roman'
			FONTSIZE 10 
			FONTCOLOR RED
		END LABEL

      DEFINE CHECKBOX Check_11
         ROW	125
         COL	10
   		CAPTION 'செக் 1' 
         VALUE .T. 
         TOOLTIP 'செக்பாக்ஸ்' 
         ONCHANGE PLAYOK()
      END CHECKBOX
      
      DEFINE RADIOGROUP Radio_11
         ROW	95
         COL	120
         OPTIONS { 'ஒன்று' , 'இரண்டு' , 'மூன்று', 'நான்கு' } 
         VALUE 1 
         WIDTH 60 
         TOOLTIP 'ரேடியோ'
         ONCHANGE PLAYOK() 
      END RADIOGROUP
      
		DEFINE CHECKBUTTON CheckButton_1
			ROW	200
			COL	140
			CAPTION 'செக்பட்டன்!' 
			VALUE .T. 
			TOOLTIP 'செக்பட்டன்!' 
		END CHECKBUTTON	

		DEFINE BUTTON ImageButton_1
			ROW	200
			COL	250
			PICTURE 'button.bmp' 
			ACTION MsgInfo('கிளிக்!') 
			WIDTH 27 
			HEIGHT 27 
			TOOLTIP 'அச்சு முன்பார்வை' 
		END BUTTON

		DEFINE CHECKBUTTON CheckButton_2
			ROW	200
			COL	285
			PICTURE 'open.bmp'
			WIDTH 27 
			HEIGHT 27 
			VALUE .F. 
			TOOLTIP 'வரைபட செக்பட்டன்'
		END CHECKBUTTON

		DEFINE TAB Tab_1 ;
			AT 5,195 ;
			WIDTH 430 ;
			HEIGHT 180 ;
			VALUE 1 ;
			TOOLTIP 'பக்க கட்டுப்பாடு' 

			DEFINE PAGE '&அட்டவணை'

				DEFINE GRID Grid_1
					ROW	30
					COL	10
					WIDTH 410 
					HEIGHT 140 
					HEADERS { '','கடைசி பெயர்','முதல் பெயர்'} 
					WIDTHS { 0,220,220}
					ITEMS { { 0,'ரத்தினகிரி','சுப்பையா'} , {1,'ராஜா','ரமேஷ்'} } 
					VALUE 1 
					TOOLTIP 'அட்டவணை கட்டுப்பாடு' 
					ONHEADCLICK { {|| MsgInfo('தலைப்பு 1 கிளிக் செய்யப்பட்டது !')} , { || MsgInfo('தலைப்பு 2 க்ளிக் செய்யப்பட்டது !')} } 
					IMAGE {"br_no","br_ok"} 
					ONDBLCLICK MsgInfo ('இரட்டை கிளிக்!','அட்டவணை') 
				END GRID

			END PAGE

			DEFINE PAGE '&இதர'

				DEFINE FRAME TabFrame_1
					ROW	45
					COL	80
				        WIDTH 130
					HEIGHT 110
				END FRAME

				DEFINE LABEL Label_1
					ROW 	55
					COL	90
					VALUE '&இது ஒரு லேபிள் !!!' 
					WIDTH 100 
					HEIGHT 27 
				END LABEL

				DEFINE CHECKBOX Check_1
					ROW	80
					COL	90
					CAPTION 'செக் 1' 
					VALUE .T. 
					TOOLTIP 'செக்பாக்ஸ்' 
					ONCHANGE PLAYOK()
				END CHECKBOX

				DEFINE SLIDER Slider_1
					ROW	115
					COL	85
					RANGEMIN 1
					RANGEMAX 10 
					VALUE 5 
					TOOLTIP 'ஸ்லைடர்'
				END SLIDER
				
				DEFINE FRAME TabFrame_2
					ROW	45
					COL	240
					WIDTH 125 
					HEIGHT 110 
				END FRAME

				DEFINE RADIOGROUP Radio_1
					ROW	50
					COL	260
					OPTIONS { 'ஒன்று' , 'இரண்டு' , 'மூன்று', 'நான்கு' } 
					VALUE 1 
					WIDTH 100 
					TOOLTIP 'ரேடியோ'
					ONCHANGE PLAYOK() 
				END RADIOGROUP

			END PAGE

			DEFINE PAGE 'எடிட்பாக்ஸ்'

				DEFINE EDITBOX 	Edit_1
					ROW	30
					COL	10
					WIDTH 410 
					HEIGHT 140 
					VALUE 'எடிட்பாக்ஸ்!!' 
					TOOLTIP 'எடிட்பாக்ஸ்' 
					MAXLENGTH 255 
				END EDITBOX

			END PAGE

			DEFINE PAGE '&முன்னேற்ற அளவை'

				DEFINE PROGRESSBAR Progress_1
					ROW	80
					COL	120
					RANGEMIN 0
					RANGEMAX 65535		
				END PROGRESSBAR
				
				DEFINE BUTTON Btn_Prg
					ROW	80
					COL	250
					CAPTION '<- !!!' 
					ACTION Animate_CLick() 
					WIDTH 50 
					HEIGHT 28 
					TOOLTIP 'முன்னேற்ற அளவை இயக்கம்'
				END BUTTON

			END PAGE

		END TAB

		DEFINE DATEPICKER Date_1
			ROW	10
			COL	10
			VALUE CTOD('  / /  ') 
			TOOLTIP 'தேதி தேர்வு' 
			SHOWNONE .T.
		END DATEPICKER

		DEFINE BUTTON Button_1
			ROW	200
			COL	10
			CAPTION 'முழு அளவு' 
			ACTION Maximize_Click() 
			TOOLTIP 'முழு அளவுக்கு விரி'
		END BUTTON

		DEFINE BUTTON Button_2
			ROW	230
			COL	10
			CAPTION 'சுருக்கு' 
			ACTION Minimize_Click() 
		END BUTTON
		
		DEFINE BUTTON Button_3
			ROW	260
			COL	10
			CAPTION 'மீளமைவு' 
			ACTION Restore_Click()
		END BUTTON

		DEFINE BUTTON Button_4
			ROW	290
			COL	10
			CAPTION '&மறை' 
			ACTION Hide_Click()
		END BUTTON
		
		DEFINE BUTTON Button_5
			ROW	320
			COL	10
			CAPTION '&காட்டு' 
			ACTION Show_Click()
		END BUTTON

		DEFINE BUTTON Button_6
			ROW	350
			COL	10
			CAPTION 'ஃபோகஸ் செய்' 
			ACTION Setfocus_Click()
		END BUTTON

		DEFINE BUTTON Button_7
			ROW	230
			COL	140
			CAPTION 'மதிப்பு பெற' 
			ACTION GetValue_Click()
		END BUTTON

		DEFINE BUTTON Button_8
			ROW	260
			COL	140
			CAPTION 'மதிப்பு மாற்ற' 
			ACTION SetValue_Click()
		END BUTTON

		DEFINE BUTTON Button_9
			ROW	290
			COL	140
			CAPTION 'திடமாக்கு' 
			ACTION Enable_Click()
		END BUTTON

		DEFINE BUTTON Button_10
			ROW	320
			COL	140
			CAPTION 'முடமாக்கு' 
			ACTION Disable_Click()
		END BUTTON

		DEFINE BUTTON Button_11
			ROW	350
			COL	140
			CAPTION 'அனைத்தையும் அழிக்க' 
			ACTION DeleteAllItems_Click()
			WIDTH 150 
			HEIGHT 28
		END BUTTON

		DEFINE BUTTON Button_12
			ROW	190
			COL	510
			CAPTION 'ஒரு வரி அழிக்க' 
			ACTION DeleteItem_Click()
		END BUTTON

		DEFINE BUTTON Button_13
			ROW	220
			COL	510
			CAPTION 'வரி சேர்க்க' 
			ACTION AddItem_Click()
		END BUTTON

		DEFINE BUTTON Button_14
			ROW	250
			COL	510
			CAPTION 'செய்திகள்' 
			ACTION Msg_Click()
		END BUTTON

		DEFINE BUTTON Button_15
			ROW	280
			COL	510
			CAPTION 'படம் மாற்ற' 
			ACTION SetPict()
		END BUTTON

		DEFINE FRAME Frame_1	
			ROW 	190
			COL	315
			CAPTION 'சட்டம்' 
			WIDTH 170 
			HEIGHT 200 
		END FRAME

		DEFINE COMBOBOX Combo_1
			ROW	210
			COL	335
			ITEMS {'ஒன்று','இரண்டு','மூன்று'} 
			VALUE 2 
			TOOLTIP 'கோம்போ பாக்ஸ்' 
		END COMBOBOX

		DEFINE LISTBOX List_1	
			ROW	240
			COL	335
			WIDTH 120 
			HEIGHT 50 
			ITEMS {'சித்திரை','வைகாசி','ஆனி','ஆடி','ஆவணி'} 
			VALUE 2  
			TOOLTIP 'பட்டியல் பாக்ஸ்' 
			ONDBLCLICK 	MsgInfo('இரட்டை கிளிக்!','பட்டியல்') 
		END LISTBOX

		DEFINE TEXTBOX Text_pass
			ROW	300
			COL	335
			VALUE 'Secret' 
			PASSWORD .T.
			TOOLTIP 'கடவுச்சொல் பெட்டி' 
			MAXLENGTH 16 
			UPPERCASE .T.
		END TEXTBOX
		
		DEFINE TEXTBOX Text_1
			ROW	330
			COL	335
			WIDTH 50 
			VALUE 'வணக்கம்!!!' 
			TOOLTIP 'உரைப் பெட்டி' 
			MAXLENGTH 16 
			LOWERCASE .T.
			ONLOSTFOCUS MsgInfo('ஃபோகஸ் இழப்பு!') 
			ONENTER MsgInfo('எண்டர் அழுத்தப்பட்டது')
		END TEXTBOX

		DEFINE TEXTBOX MaskedText
			ROW	330
			COL	395
			WIDTH 80 
			VALUE 12345.12 
			TOOLTIP "எண் மற்றும் உள்ளீட்டுப் போர்வையுடனான உரைப்பெட்டி" 
			NUMERIC .T.
			INPUTMASK '99999.99' 
			ONCHANGE PlayOk() 
			ONENTER MsgInfo('எண்டர் அழுத்தப்பட்டது') 
			RIGHTALIGN .T.
		END TEXTBOX

		DEFINE TEXTBOX Text_2
			ROW	360
			COL	335
			VALUE 123 
			NUMERIC .T.
			TOOLTIP 'எண் உரைப்பெட்டி' 
			MAXLENGTH 16 
			RIGHTALIGN .T.
		END TEXTBOX

		DEFINE SPINNER Spinner_1
			ROW	100
			COL	10
			RANGEMIN 0
			RANGEMAX 10 
			VALUE 5 
			WIDTH 100 
			TOOLTIP 'வரையறை 1,65000'
			FONTBOLD .T.
		END SPINNER

		DEFINE LABEL Label_2
			ROW	380
			COL	15
			VALUE 'கடிகார சோதனை:' 
		END LABEL
		
		DEFINE LABEL Label_3
			ROW	380
			COL	140
		END LABEL

		DEFINE TIMER Timer_1 ;
		INTERVAL 1000 ;
		ACTION Form_1.Label_3.Value := Time() 
		
		DEFINE IMAGE Image_1
			ROW	310
			COL	510
			PICTURE 'Demo.gif' 
			WIDTH 90 
			HEIGHT 90
		END IMAGE
		
	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

*-----------------------------------------------------------------------------*
Procedure SetPict()
*-----------------------------------------------------------------------------*

	Form_1.Image_1.Picture := 'hmglogo.gif'
	Form_1.ImageButton_1.Picture := 'Open.Bmp'

Return Nil

*-----------------------------------------------------------------------------*
Procedure Maximize_CLick
*-----------------------------------------------------------------------------*

	Form_1.Maximize

Return Nil

*-----------------------------------------------------------------------------*
Procedure SetCaptionTest()
*-----------------------------------------------------------------------------*

	Form_1.Button_1.Caption 	:= 'புதிய தலைப்பு'
	Form_1.Tab_1(2).Check_1.Caption := 'புதிய தலைப்பு'
	Form_1.CheckButton_1.Caption 	:= 'புதிய தலைப்பு'
	Form_1.Frame_1.Caption 		:= 'புதிய தலைப்பு'

Return Nil
*-----------------------------------------------------------------------------*
Procedure GetCaptionTest()
*-----------------------------------------------------------------------------*

	MsgInfo ( ( Form_1.Button_1.Caption      ) , 'பட்டன்_1' )
	MsgInfo ( ( Form_1.Tab_1(2).Check_1.Caption ) , 'செக்_1' )
	MsgInfo ( ( Form_1.CheckButton_1.Caption ) , 'செக்பட்டன்_1' )
	MsgInfo ( ( Form_1.Frame_1.Caption 	     ) , 'சட்டம்_1' )

Return Nil
*-----------------------------------------------------------------------------*
Procedure ExecTest()
*-----------------------------------------------------------------------------*

	EXECUTE FILE "NOTEPAD.EXE" 

Return Nil
*-----------------------------------------------------------------------------*
Procedure InputWindow_Click
*-----------------------------------------------------------------------------*
Local Title , aLabels , aInitValues , aFormats , aResults 

Title 		:= 'உள்ளீட்டுச் சாளரச் சோதனை'

aLabels 	:= { 'புலம் 1:'	, 'புலம் 2:'	,'புலம் 3:'		,'புலம் 4:'	,'புலம் 5:'	,'புலம் 6:' }
aInitValues 	:= { 'ஆரம்ப உரை', .t. 		,2			, Date() 	, 12.34 	,'ஆரம்ப உரை' }
aFormats 	:= { 20		, Nil 		,{'வசதி 1','வசதி 2'}, Nil 		, '99.99'	, 50 }

aResults 	:= InputWindow ( Title , aLabels , aInitValues , aFormats )

If aResults [1] == Nil

	MsgInfo ('ரத்து செய்யப்பட்டது','உள்ளீட்டுச் சாளரம்')

Else

	MsgInfo ( aResults [1] , aLabels [1] )
	MsgInfo ( iif ( aResults [2] ,'.T.','.F.' ) , aLabels [2] )
	MsgInfo ( Str ( aResults [3] ) , aLabels [3] )
	MsgInfo ( DTOC ( aResults [4] ) , aLabels [4] )
	MsgInfo ( Str ( aResults [5] ) , aLabels [5] )
	MsgInfo ( aResults [6] , aLabels [6] )

EndIf

Return Nil
*-----------------------------------------------------------------------------*
Procedure EditGrid_Click
*-----------------------------------------------------------------------------*
Local aRows [20] [3]

	aRows [1]	:= {'ராஜா','ராமன்','555-5555'}
	aRows [2]	:= {'ராமன்','ரமணி','324-6432'} 
	aRows [3]	:= {'ராகவன்','சந்திரன்','432-5892'} 
	aRows [4]	:= {'ரமணி','சகாதேவன்','894-2332'} 
	aRows [5]	:= {'சந்திரன்','பரணி','346-9873'} 
	aRows [6]	:= {'சகாதேவன்','பரமேஸ்வரன்','394-9654'} 
	aRows [7]	:= {'பரணி','சக்தி','435-3211'} 
	aRows [8]	:= {'பரமேஸ்வரன்','சக்தி','123-1234'} 
	aRows [9]	:= {'சக்தி','இந்திரன்','000-0000'} 
	aRows [10]	:= {'இந்திரன்','அம்புலி','583-4832'} 
	aRows [11]	:= {'அம்புலி','ஆதவன்','321-4332'} 
	aRows [12]	:= {'ஆதவன்','அழகன்','326-9430'} 
	aRows [13]	:= {'அழகன்','இனியன்','543-7898'} 
	aRows [14]	:= {'இனியன்','முருகன்','437-8473'} 
	aRows [15]	:= {'முருகன்','சண்முகன்','485-2843'} 
	aRows [16]	:= {'சண்முகன்','கந்தன்','394-5983'} 
	aRows [17]	:= {'ஜோசப்','அந்தோணி','534-7984'} 
	aRows [18]	:= {'ஜான்','பிரிட்டோ','854-7873'} 
	aRows [19]	:= {'முகமது','இப்ரஹீம்','???-????'} 
	aRows [20]	:= {'அப்துல்','காதர்','432-5836'} 

	DEFINE WINDOW Form_Grid ;
		AT 0,0 ;
		WIDTH 430 HEIGHT 400 ;
		TITLE 'திருத்தத்தக்க அட்டவணை சோதனை'  ;
		MODAL NOSIZE ;
		FONT 'Arial' SIZE 10 

		DEFINE GRID Grid_1
			ROW	10
			COL	10
			WIDTH 405 
			HEIGHT 330 
			HEADERS {'இறுதிப் பெயர்','முதன்மைப் பெயர்','தொலைபேசி'} 
			WIDTHS {140,140,140}
			ITEMS aRows 
			VALUE 1 
			TOOLTIP 'திருத்தத்தக்க அட்டவணை' 
			ALLOWEDIT .T.
		END GRID

	END WINDOW

	Form_Grid.Grid_1.Value := 20

	Form_Grid.Grid_1.SetFocus

	Form_Grid.Center

	Form_Grid.Activate

Return

*-----------------------------------------------------------------------------*
Procedure GetColor_Click
*-----------------------------------------------------------------------------*
Local Color

	Color := GetColor()

	MsgInfo( Str(Color[1]) , "சிவப்பு அளவு")	
	MsgInfo( Str(Color[2]) , "பச்சை அளவு")	
	MsgInfo( Str(Color[3]) , "நீலம் அளவு")	

Return Nil

*-----------------------------------------------------------------------------*
Procedure GetFont_Click
*-----------------------------------------------------------------------------*
Local a

	a := GetFont ( 'Arial' , 12 , .f. , .t. , {0,0,255} , .f. , .f. , 0 )

	if empty ( a [1] )

		MsgInfo ('ரத்து செய்யப்பட்டது')

	Else

		MsgInfo( a [1] + Str( a [2] ) )

		if  a [3] == .t.
			MsgInfo ("தடிமன்")
		else
			MsgInfo ("தடிமன் அல்லாத")
		endif

		if  a [4] == .t.
			MsgInfo ("சாய்வான")
		else
			MsgInfo ("சாய்வில்லாத")
		endif

		MsgInfo ( str( a [5][1]) +str( a [5][2]) +str( a [5][3]), 'வண்ணம்' )

		if  a [6] == .t.
			MsgInfo ("அடிக்கோடு")
		else
			MsgInfo ("அடிக்கோடில்லா")
		endif

		if  a [7] == .t.
			MsgInfo ("அடித்தல்")
		else
			MsgInfo ("அடித்தலில்லா")
		endif

		MsgInfo ( str ( a [8] ) , 'எழுத்தமைவு' )

	EndIf

Return Nil
*-----------------------------------------------------------------------------*
Procedure MultiWin_Click
*-----------------------------------------------------------------------------*

	If (.Not. IsWIndowActive (Form_4) ) .And. (.Not. IsWIndowActive (Form_5) )

		DEFINE WINDOW Form_4 ;
			AT 100,100 ;
			WIDTH 200 HEIGHT 150 ;
			TITLE "சாளரம் 1" ;
			TOPMOST 

		END WINDOW
		DEFINE WINDOW Form_5 ;
			AT 300,300 ;
			WIDTH 200 HEIGHT 150 ;
			TITLE "சாளரம் 2" ;
			TOPMOST 

		END WINDOW

		ACTIVATE WINDOW Form_4 , Form_5

	EndIf

Return
*-----------------------------------------------------------------------------*
Procedure Context1_Click
*-----------------------------------------------------------------------------*

	Form_1.File_Modal.Checked := .T.
	MsgInfo ("கோப்பு->மேலதிகச் சோதனைகள் தேர்ந்தெடுக்கப்பட்டது")

Return Nil
*-----------------------------------------------------------------------------*
Procedure Context2_Click
*-----------------------------------------------------------------------------*

	Form_1.File_Modal.Checked := .F.
	MsgInfo ("கோப்பு->முன்னணிச் சாளரம் தேர்வு நீக்கப்பட்டது")

Return Nil
*-----------------------------------------------------------------------------*
Procedure Context3_Click
*-----------------------------------------------------------------------------*

	Form_1.File_Topmost.Enabled := .T.
	MsgInfo ("கோப்பு->மேற்சாளரம் முடுக்கப்பட்டது")

Return Nil
*-----------------------------------------------------------------------------*
Procedure Context4_Click
*-----------------------------------------------------------------------------*

	Form_1.File_Topmost.Enabled := .F.
	MsgInfo ("கோப்பு -> மேற்சாளரம் முடக்கப்பட்டது")

Return Nil
*-----------------------------------------------------------------------------*
Procedure Animate_CLick
*-----------------------------------------------------------------------------*
Local i

	For i = 0 To 65535 Step 25
		Form_1.Tab_1(4).Progress_1.Value := i
	Next i

Return
*-----------------------------------------------------------------------------*
Procedure Modal_CLick
*-----------------------------------------------------------------------------*

	DEFINE WINDOW Form_2 ;
		AT 0,0 ;
		WIDTH 430 HEIGHT 400 ;
		TITLE 'முன்னணிச் சாளரம் & பலமுகத் தேர்வு அட்டவணை/பட்டியல் சோதனை'  ;
		MODAL ;
		NOSIZE 

		DEFINE BUTTON BUTTON_1
			ROW	10
			COL	30
			CAPTION 'பட்டியல் மதிப்பு பெற' 
         width 150
			ACTION MultiTest_GetValue()
		END BUTTON
		
		DEFINE BUTTON BUTTON_2
			ROW	40
			COL	30
         width 150
			CAPTION 'பட்டியல் மதிப்பு மாற்ற' 
			ACTION Form_2.List_1.Value := { 1 , 3 } 
		END BUTTON
		
		DEFINE BUTTON BUTTON_3
			ROW	70
			COL	30
         width 150
			CAPTION 'பட்டியல் வரி பெற' 
			ACTION Multilist_GetItem()
		END BUTTON

		DEFINE BUTTON BUTTON_4
			ROW	100
			COL	30
         width 150
			CAPTION 'பட்டியல் வரி மாற்ற' 
			ACTION Form_2.List_1.Item ( 1 ) := 'புதிய வரி!!' 
		END BUTTON

		DEFINE BUTTON BUTTON_10
			ROW	130
			COL	30
         width 150
			CAPTION 'எண்ணிக்கை பெற' 
			ACTION MsgInfo ( Str ( ( Form_2.List_1.ItemCount ) ) )
		END BUTTON

		DEFINE BUTTON BUTTON_5
			ROW	10
			COL	200
			CAPTION 'அட்டவணை மதிப்பு பெற' 
         width 150
			ACTION MultiGrid_GetValue()
		END BUTTON

		DEFINE BUTTON BUTTON_6
			ROW	40
			COL	200
         width 150
			CAPTION 'அட்டவணை மதிப்பு மாற்ற' 
			ACTION Form_2.Grid_1.Value := { 1 , 3 } 
		END BUTTON

		DEFINE BUTTON BUTTON_7
			ROW	70
			COL	200
         width 150
			CAPTION 'அட்டவணை வரி பெற' 
			ACTION MultiGrid_GetItem()
		END BUTTON
		
		DEFINE BUTTON BUTTON_8
			ROW	100
			COL	200
         width 150
			CAPTION 'அட்டவணை வரி மாற்ற' 
			ACTION Form_2.Grid_1.Item(1) := {'அனைவருக்கும்','வணக்கம்'} 
		END BUTTON
		
		DEFINE BUTTON BUTTON_9
			ROW	130
			COL	200
         width 150
			CAPTION 'அட்டவணை எண்ணிக்கை பெற' 
			ACTION MsgInfo ( Str ( ( Form_2.Grid_1.ItemCount ) ) )
		END BUTTON

		DEFINE LISTBOX List_1
			ROW	180
			COL	30
			WIDTH 100 
			HEIGHT 135 
			ITEMS { 'வரி 1' , 'வரி 2' , 'வரி 3' , 'வரி 4' , 'வரி 5' } 
			VALUE { 2 , 3 } 
			FONTNAME 'Arial' 
			FONTSIZE 10 
			TOOLTIP 'ஒன்றுக்கும் மேற்பட்டன தெரிவுப் பட்டியல் (Ctrl+Click)' 
			MULTISELECT .T.
		END LISTBOX
		
		DEFINE GRID Grid_1
			ROW		180
			COL		150
			WIDTH		250 
			HEIGHT		135 
			HEADERS		{ 'இறுதிப் பெயர்' , 'முதன்மைப் பெயர்' } 
			WIDTHS		{ 120 , 120 }
			ITEMS		{ { 'முருகன்' , 'சண்முகன்' } , { 'ஜான்' , 'ஜோசப்' } , { 'முகமது' , 'இப்ரஹிம்' } } 
			VALUE		{ 2 , 3 } 
			FONTNAME	'Arial' 
			FONTSIZE	10 
			TOOLTIP		'ஒன்றுக்கும் மேற்பட்டன தெரிவு செய்ய (Ctrl+Click)' 
			ONCHANGE	PlayBeep() 
			MULTISELECT	.T.
		END GRID

	END WINDOW

	Form_2.Center

	Form_2.Activate

Return Nil
Procedure MultiTest_GetValue
local a , i

	a :=  ( Form_2.List_1.Value )

	for i := 1 to len (a)
		MsgInfo ( str( a[i] ) ) 
	Next i

	If Len(a) == 0
		MsgInfo('எதையும் தேர்ந்தெடுக்கவில்லை')
	EndIf

Return
Procedure MultiGrid_GetValue
local a , i

	a :=  ( Form_2.Grid_1.Value )

	for i := 1 to len (a)
		MsgInfo ( str( a[i] ) ) 
	Next i

	If Len(a) == 0
		MsgInfo('எதையும் தேர்ந்தெடுக்கவில்லை')
	EndIf

Return
*-----------------------------------------------------------------------------*
procedure multilist_getitem
*-----------------------------------------------------------------------------*

	MsgInfo (  ( Form_2.List_1.Item ( 1 ) ) ) 

return
*-----------------------------------------------------------------------------*
Procedure MultiGrid_GetItem
*-----------------------------------------------------------------------------*
local a , i

	a := ( Form_2.Grid_1.Item ( 1 ) )

	for i := 1 to len (a)
		MsgInfo ( a[i] ) 
	Next i
Return
*-----------------------------------------------------------------------------*
Procedure Standard_CLick
*-----------------------------------------------------------------------------*
	If .Not. IsWindowDefined ( Form_Std )

		DEFINE WINDOW Form_Std ;
			AT 100,100 ;
			WIDTH 200 HEIGHT 200 ;
			TITLE "வழமையான சாளரம்" ;
			WINDOWTYPE STANDARD ;
			ON INIT { || MsgInfo ("சாளரம் திறக்கும் போது செயல்படவேண்டியது !!!") } ;
			ON RELEASE { || MsgInfo ("சாளரம் மூடும் போது செயல்படவேண்டியது !!!") }

		END WINDOW

		Form_Std.Activate

	Else
		MsgInfo ("சாளரம் ஏற்கனவே திறக்கப்பட்டுள்ளது","எச்சரிக்கை!")	
	EndIf	

Return Nil
*-----------------------------------------------------------------------------*
Procedure Topmost_CLick
*-----------------------------------------------------------------------------*

	If .Not. IsWIndowActive ( Form_3 )

		DEFINE WINDOW Form_3 ;
			AT 100,100 ;
			WIDTH 150 HEIGHT 150 ;
			TITLE "முன்னணிச் சாளரம்" ;
			TOPMOST 

		END WINDOW

		Form_3.Center

		Form_3.Activate

	EndIf

Return Nil
*-----------------------------------------------------------------------------*
Procedure Minimize_CLick
*-----------------------------------------------------------------------------*

	Form_1.Minimize

Return Nil
*-----------------------------------------------------------------------------*
Procedure Restore_CLick
*-----------------------------------------------------------------------------*

	Form_1.Restore

Return Nil
*-----------------------------------------------------------------------------*
Procedure Hide_CLick
*-----------------------------------------------------------------------------*

	Form_1.Image_1.Visible 	:= .f.
	Form_1.Spinner_1.Visible := .f.
	Form_1.Tab_1.Visible 	:= .f.

Return Nil
*-----------------------------------------------------------------------------*
Procedure Show_CLick
*-----------------------------------------------------------------------------*

	Form_1.Image_1.Visible 	:= .t.
	Form_1.Spinner_1.Visible := .t.
	Form_1.Tab_1.Visible 	:= .t.

Return Nil
*-----------------------------------------------------------------------------*
Procedure Setfocus_CLick
*-----------------------------------------------------------------------------*

	Form_1.MaskedText.SetFocus

Return Nil
*-----------------------------------------------------------------------------*
Procedure GetValue_CLick
*-----------------------------------------------------------------------------*
Local s

s =     "அட்டவணை:                " + Str (  ( Form_1.Tab_1(1).Grid_1.Value ) 	)	+ chr(13) + chr(10)
s = s + "உரைப்பெட்டி:             " +      ( Form_1.Text_1.Value 	)	+ chr(13) + chr(10)
s = s + "திருத்தும்பெட்டி:             " +      ( Form_1.Tab_1(3).Edit_1.Value 	)	+ chr(13) + chr(10)
s = s + "ரேடியோ:          " + Str (  Form_1.Tab_1(2).Radio_1.Value )	+ chr(13) + chr(10)
s = s + "பக்கம்:                 " + Str (  Form_1.Tab_1.Value )	+ chr(13) + chr(10)
s = s + "கோம்போபாக்ஸ்:            " + Str (  Form_1.Combo_1.Value )	+ chr(13) + chr(10)
s = s + "செக்பாக்ஸ்:   	      " + Iif (  ( Form_1.Tab_1(2).Check_1.Value ) , ".T.",".F."	) + chr(13) + chr(10)
s = s + "எண் உரைப்பெட்டி:     " + Str (  Form_1.Text_2.Value )	+ chr(13) + chr(10)
s = s + "கடவுச்சொல் பெட்டி:    " +        Form_1.Text_Pass.Value	+ chr(13) + chr(10)
s = s + "ஸ்லைடர்:	      " + Str (  Form_1.Tab_1(2).Slider_1.Value )	+ chr(13) + chr(10)	
s = s + "ஸ்பின்னர்:             " + Str (  Form_1.Spinner_1.Value )	+ chr(13) + chr(10)
s = s + "உள்ளீடு போர்வையுடனான உரைப்பெட்டி: " + Str (  Form_1.MaskedText.Value )	+ chr(13) + chr(10)
s = s + "தேதித்தெரிவன்:          " + Dtoc(  ( Form_1.Date_1.Value )	) 

MsgInfo ( s , "கட்டுப்பாட்டு மதிப்புகள்" )

Return Nil
*-----------------------------------------------------------------------------*
Procedure SetValue_CLick
*-----------------------------------------------------------------------------*

	 Form_1.Tab_1(1).Grid_1.Value 	:= 2 
	 Form_1.Text_1.Value 	:= "புதிய உரை" 
	 Form_1.Tab_1(3).Edit_1.Value 	:= "புதிய மதிப்பு" 
	 Form_1.Tab_1(2).Radio_1.Value 	:= 4
	 Form_1.Tab_1.Value 	:= 2 
	 Form_1.Tab_1(2).Check_1.Value 	:= .t. 
	 Form_1.List_1.Value 	:= 1 
	 Form_1.Combo_1.Value 	:= 1 
	 Form_1.Date_1.Value 	:= CTOD("02/02/2002") 
	 Form_1.Tab_1(2).Label_1.Value 	:= "புதிய லேபிள் மதிப்பு" 
	 Form_1.Text_2.Value 	:= 999 
	 Form_1.Timer_1.Value 	:= 500 
	 Form_1.MaskedText.Value := 12.34 
	 Form_1.Spinner_1.Value := 6
Return Nil
*-----------------------------------------------------------------------------*
Procedure Enable_CLick
*-----------------------------------------------------------------------------*

	Form_1.Button_1.Enabled 	:= .T. 
	Form_1.Button_2.Enabled 	:= .T. 
	Form_1.Button_3.Enabled 	:= .T. 
	Form_1.Button_4.Enabled 	:= .T. 
	Form_1.Button_5.Enabled 	:= .T. 
	Form_1.Button_6.Enabled 	:= .T. 
	Form_1.Timer_1.Enabled 		:= .T. 
	Form_1.Spinner_1.Enabled 	:= .T. 
	Form_1.Tab_1(2).Radio_1.Enabled 		:= .T. 
	Form_1.Tab_1.Enabled 		:= .T. 
Return Nil
*-----------------------------------------------------------------------------*
Procedure Disable_CLick
*-----------------------------------------------------------------------------*

	Form_1.Button_1.Enabled 	:= .F. 
	Form_1.Button_2.Enabled 	:= .F. 
	Form_1.Button_3.Enabled 	:= .F. 
	Form_1.Button_4.Enabled 	:= .F. 
	Form_1.Button_5.Enabled 	:= .F. 
	Form_1.Button_6.Enabled 	:= .F. 
	Form_1.Timer_1.Enabled 		:= .F. 
	Form_1.Spinner_1.Enabled 	:= .F. 
	Form_1.Tab_1(2).Radio_1.Enabled 		:= .F. 
	Form_1.Tab_1.Enabled 		:= .F. 

Return Nil
*-----------------------------------------------------------------------------*
Procedure DeleteAllItems_CLick
*-----------------------------------------------------------------------------*

	Form_1.Tab_1(1).Grid_1.DeleteAllItems
	Form_1.List_1.DeleteAllItems 
	Form_1.Combo_1.DeleteAllItems

Return Nil
*-----------------------------------------------------------------------------*
Procedure DeleteItem_CLick
*-----------------------------------------------------------------------------*

	Form_1.Tab_1(1).Grid_1.DeleteItem ( 1 )
	Form_1.List_1.DeleteItem ( 1 )
	Form_1.Combo_1.DeleteItem ( 1 )

Return Nil
*-----------------------------------------------------------------------------*
Procedure AddItem_CLick
*-----------------------------------------------------------------------------*

	Form_1.Tab_1(1).Grid_1.AddItem ( { 1,"ராஜா","ராணி"} )
	Form_1.List_1.AddItem ( "புதிய பட்டியல் வரி"  )
	Form_1.Combo_1.AddItem (  "புதிய கோம்போ வரி" )

Return Nil
*-----------------------------------------------------------------------------*
Procedure Msg_CLick
*-----------------------------------------------------------------------------*

	MsgBox		("செய்திப் பெட்டி சோதனை","செய்திப்பெட்டி")
	MsgInfo 	("தகவல் பெட்டி சோதனை","தகவல்")
	MsgStop 	("நிறுத்தம் சோதனை","நிறுத்து!")
	MsgExclamation 	("ஆச்சரியப் பெட்டி சோதனை","ஆச்சரியம்!")
	MsgYesNo	("ஆம் இல்லை பெட்டி சோதனை","ஆம் இல்லை பெட்டி")
	MsgOkCancel	("சரி ரத்து சோதனை","சரி அல்லது ரத்து")
	MsgRetryCancel  ("மீளமைவு ரத்து சோதனை","மீளமைவு அல்லது ரத்து")

Return Nil
*-----------------------------------------------------------------------------*
Procedure MemoryTest
*-----------------------------------------------------------------------------*

	MsgInfo(str(MemoryStatus(1)), "மொத்த நினைவகம் MBஇல்")
	MsgInfo(str(MemoryStatus(2)), "காலி நினைவகம் MBஇல்")
	MsgInfo(str(MemoryStatus(3)), "மொத்த பக்க நினைவகம் MBஇல்")
	MsgInfo(str(MemoryStatus(3)- MemoryStatus(4)), "பயன்படுத்தப்பட்ட பக்க நினைவகம் MBஇல்")
	MsgInfo(str(MemoryStatus(6)), "காலி மாய நினைவகம் MBஇல்")

Return
*-----------------------------------------------------------------------------*
Procedure Color_CLick
*-----------------------------------------------------------------------------*
	DEFINE WINDOW Form_Color ;
		AT 100,100 ;
		WIDTH 200 HEIGHT 200 ;
		TITLE 'வண்ணச் சாளரம்' ;
		BACKCOLOR RED

		DEFINE LABEL Label_9
			ROW	10
			COL	10
			VALUE 'வண்ணப் பெயர் !!!' 
			WIDTH 140 
			HEIGHT 30 
			FONTNAME 'Times New Roman' 
			FONTSIZE 12 
			BACKCOLOR RED 
			FONTCOLOR YELLOW 
			FONTBOLD .T.
		END LABEL 

		DEFINE LABEL Label_99
			ROW	60
			COL	10
			VALUE 'மற்றுமொரு வண்ண லேபிள் !!!' 
			WIDTH 180 
			HEIGHT 30 
			FONTNAME 'Times New Roman' 
			FONTSIZE 10 
			BACKCOLOR WHITE 
			FONTCOLOR RED 
			FONTBOLD .T.
		END LABEL
	END WINDOW

	Form_Color.Activate

Return Nil
*-----------------------------------------------------------------------------*
Procedure Child_CLick
*-----------------------------------------------------------------------------*
	DEFINE WINDOW ChildTest ;
		AT 100, 100 ;
		WIDTH 200 HEIGHT 200 ;
		TITLE 'குழந்தைச் சாளரம்' ;
		CHILD

	END WINDOW

	ChildTest.Activate

Return Nil
