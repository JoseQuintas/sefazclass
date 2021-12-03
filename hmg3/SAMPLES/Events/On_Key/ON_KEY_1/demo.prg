/*
* HMG ON KEY Demo
*/

/*

Available Keys 

  UNSHIFT+A         ALT+A             SHIFT+A           CONTROL+A 
  UNSHIFT+B         ALT+B             SHIFT+B           CONTROL+B 
  UNSHIFT+C         ALT+C             SHIFT+C           CONTROL+C 
  UNSHIFT+D         ALT+D             SHIFT+D           CONTROL+D 
  UNSHIFT+E         ALT+E             SHIFT+E           CONTROL+E 
  UNSHIFT+F         ALT+F             SHIFT+F           CONTROL+F 
  UNSHIFT+G         ALT+G             SHIFT+G           CONTROL+G 
  UNSHIFT+H         ALT+H             SHIFT+H           CONTROL+H 
  UNSHIFT+I         ALT+I             SHIFT+I           CONTROL+I 
  UNSHIFT+J         ALT+J             SHIFT+J           CONTROL+J 
  UNSHIFT+K         ALT+K             SHIFT+K           CONTROL+K 
  UNSHIFT+L         ALT+L             SHIFT+L           CONTROL+L 
  UNSHIFT+M         ALT+M             SHIFT+M           CONTROL+M 
  UNSHIFT+N         ALT+N             SHIFT+N           CONTROL+N 
  UNSHIFT+O         ALT+O             SHIFT+O           CONTROL+O 
  UNSHIFT+P         ALT+P             SHIFT+P           CONTROL+P 
  UNSHIFT+Q         ALT+Q             SHIFT+Q           CONTROL+Q 
  UNSHIFT+R         ALT+R             SHIFT+R           CONTROL+R 
  UNSHIFT+S         ALT+S             SHIFT+S           CONTROL+S 
  UNSHIFT+T         ALT+T             SHIFT+T           CONTROL+T 
  UNSHIFT+U         ALT+U             SHIFT+U           CONTROL+U 
  UNSHIFT+V         ALT+V             SHIFT+V           CONTROL+V 
  UNSHIFT+W         ALT+W             SHIFT+W           CONTROL+W 
  UNSHIFT+X         ALT+X             SHIFT+X           CONTROL+X 
  UNSHIFT+Y         ALT+Y             SHIFT+Y           CONTROL+Y 
  UNSHIFT+Z         ALT+Z             SHIFT+Z           CONTROL+Z 
  0                 ALT+0             SHIFT+0           CONTROL+0 
  1                 ALT+1             SHIFT+1           CONTROL+1 
  2                 ALT+2             SHIFT+2           CONTROL+2 
  3                 ALT+3             SHIFT+3           CONTROL+3 
  4                 ALT+4             SHIFT+4           CONTROL+4 
  5                 ALT+5             SHIFT+5           CONTROL+5 
  6                 ALT+6             SHIFT+6           CONTROL+6 
  7                 ALT+7             SHIFT+7           CONTROL+7 
  8                 ALT+8             SHIFT+8           CONTROL+8 
  9                 ALT+9             SHIFT+9           CONTROL+9 
  F1                ALT+F1            SHIFT+F1          CONTROL+F1 
  F2                ALT+F2            SHIFT+F2          CONTROL+F2 
  F3                ALT+F3            SHIFT+F3          CONTROL+F3 
  F4                ALT+F4            SHIFT+F4          CONTROL+F4 
  F5                ALT+F5            SHIFT+F5          CONTROL+F5 
  F6                ALT+F6            SHIFT+F6          CONTROL+F6 
  F7                ALT+F7            SHIFT+F7          CONTROL+F7 
  F8                ALT+F8            SHIFT+F8          CONTROL+F8 
  F9                ALT+F9            SHIFT+F9          CONTROL+F9 
  F10               ALT+F10           SHIFT+F10         CONTROL+F10 
  F11               ALT+F11           SHIFT+F11         CONTROL+F11 
  F12               ALT+F12           SHIFT+F12         CONTROL+F12 
  SPACE             ALT+SPACE         SHIFT+SPACE       CONTROL+SPACE 
  BACK              ALT+BACK          SHIFT+BACK        CONTROL+BACK 
  TAB               ALT+TAB           SHIFT+TAB         CONTROL+TAB 
  RETURN            ALT+RETURN        SHIFT+RETURN      CONTROL+RETURN 
  ESCAPE            ALT+ESCAPE        SHIFT+ESCAPE      CONTROL+ESCAPE 
  INSERT            ALT+INSERT        SHIFT+INSERT      CONTROL+INSERT 
  DELETE            ALT+DELETE        SHIFT+DELETE      CONTROL+DELETE 
  HOME              ALT+HOME          SHIFT+HOME        CONTROL+HOME 
  END               ALT+END           SHIFT+END         CONTROL+END 
  PRIOR             ALT+PRIOR         SHIFT+PRIOR       CONTROL+PRIOR 
  NEXT              ALT+NEXT          SHIFT+NEXT        CONTROL+NEXT 
  LEFT              ALT+LEFT          SHIFT+LEFT        CONTROL+LEFT 
  UP                ALT+UP            SHIFT+UP          CONTROL+UP 
  RIGHT             ALT+RIGHT         SHIFT+RIGHT       CONTROL+RIGHT 
  DOWN              ALT+DOWN          SHIFT+DOWN        CONTROL+DOWN 
  ADD               ALT+ADD           SHIFT+ADD         CONTROL+ADD 
  SUBTRACT          ALT+SUBTRACT      SHIFT+SUBTRACT    CONTROL+SUBTRACT 
  MULTIPLY          ALT+MULTIPLY      SHIFT+MULTIPLY    CONTROL+MULTIPLY 
  DIVIDE            ALT+DIVIDE        SHIFT+DIVIDE      CONTROL+DIVIDE 
  DECIMAL           ALT+DECIMAL       SHIFT+DECIMAL     CONTROL+DECIMAL 
  NUMPAD0           ALT+NUMPAD0       SHIFT+NUMPAD0     CONTROL+NUMPAD0 
  NUMPAD1           ALT+NUMPAD1       SHIFT+NUMPAD1     CONTROL+NUMPAD1 
  NUMPAD2           ALT+NUMPAD2       SHIFT+NUMPAD2     CONTROL+NUMPAD2 
  NUMPAD3           ALT+NUMPAD3       SHIFT+NUMPAD3     CONTROL+NUMPAD3 
  NUMPAD4           ALT+NUMPAD4       SHIFT+NUMPAD4     CONTROL+NUMPAD4 
  NUMPAD5           ALT+NUMPAD5       SHIFT+NUMPAD5     CONTROL+NUMPAD5 
  NUMPAD6           ALT+NUMPAD6       SHIFT+NUMPAD6     CONTROL+NUMPAD6 
  NUMPAD7           ALT+NUMPAD7       SHIFT+NUMPAD7     CONTROL+NUMPAD7 
  NUMPAD8           ALT+NUMPAD8       SHIFT+NUMPAD8     CONTROL+NUMPAD8 
  NUMPAD9           ALT+NUMPAD9       SHIFT+NUMPAD9     CONTROL+NUMPAD9 

*/

#include "hmg.ch"

Function Main
Local bBlock

	DEFINE WINDOW Win_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'Hello World!' ;
		MAIN  

    ON KEY UNSHIFT+A ACTION MsgInfo ('Unshift+A')
		ON KEY SHIFT+A ACTION MsgInfo ('Shift+A')
		ON KEY TAB ACTION MsgInfo ('TAB')
		ON KEY RETURN ACTION MsgInfo ('RETURN')
		ON KEY CONTROL+END ACTION MsgInfo ('CONTROL+END')
    ON KEY CONTROL+ADD ACTION MsgInfo ('CONTROL+ADD')
		ON KEY ESCAPE ACTION MsgInfo ('ESCAPE')
		ON KEY ALT+C ACTION MsgInfo ('ALT+C')

		DEFINE BUTTON Button_1
			ROW 10
			COL 10
			CAPTION 'Activate F2'
			ACTION EnableF2()
		END BUTTON

		DEFINE BUTTON Button_2
			ROW 40
			COL 10
			CAPTION 'Release F2'
			ACTION DisableF2()
		END BUTTON

		DEFINE BUTTON Button_3
			ROW 70
			COL 10
			CAPTION 'Store Key Test'
			ACTION StoreTest()
		END BUTTON

	END WINDOW

	ACTIVATE WINDOW Win_1

Return

Procedure EnableF2()
	ON KEY F2 OF Win_1 ACTION MsgInfo ('F2')
Return

Procedure DisableF2()
	RELEASE KEY F2 OF Win_1
Return

Procedure StoreTest()
Local bBlock

	STORE KEY RETURN OF Win_1 TO bBlock

	RELEASE KEY RETURN OF Win_1

	ON KEY RETURN OF Win_1 ACTION Eval ( bBlock )

Return
