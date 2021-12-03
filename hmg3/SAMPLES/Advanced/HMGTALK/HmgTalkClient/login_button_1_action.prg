#include "hmg.ch"

declare window Login

Function login_button_1_action
	Public c_Ip_Server := Login.Text_1.Value 
	Public c_NickName  := Login.Text_2.Value
	If Empty(Login.Text_1.Value)
		MsgStop("Type the server IP in here...",c_W_Title)
		Return Nil
	endif
	if Empty(Login.Text_2.Value)
		MsgStop("Type your NickName!",c_W_Title)
		Return Nil
	Endif
	Login.Release
	Start_Conexion()
Return Nil
