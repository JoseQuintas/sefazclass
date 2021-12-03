#include <hmg.ch>
REQUEST HB_GT_WIN_DEFAULT
Function Main

        Load Window Main
        Main.Center
        Main.Activate

Return

Function _Connect()
     Local c_STR_Con := "net:"

     c_STR_Con := c_STR_con + AllTrim(Main.Text_1.Value) + ":" ;
                            + AllTrim(Main.Text_3.Value) + ":" ;
					   + AllTrim(Main.Text_2.Value)

	if NETIO_CONNECT("127.0.0.1","2941")
	     DBUseArea(.t.,,c_STR_Con,AllTrim(Main.Text_2.Value))
 		EDIT EXTENDED
     endif

Return Nil