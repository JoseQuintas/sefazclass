#Include "hmg.ch"
/*

Exemplo: Pedidos , Itens, Clientes - Maio/2003
Humberto Fornazier - hfornazier@brfree.com.br
Revisado: Roberto lopez - roblez@ciudad.ar

Harbour Compiler (HMG Distribution) 2003.05.03 (Flex)
Copyright 1999-2003, http://www.harbour-project.org/

HMG R.62a Copyright 2002-2003 Roberto Lopez
http://www.hmgforum.com//

*/
Function Main() 			

	Use Pedidos Alias Pedidos New
	Index On Pedido to Pedidos1

	Use Itens Alias Itens New
              Index On Pedido To Itens1

	Use Clientes Alias Clientes New
	Index On Codigo to Clientes1

	DEFINE WINDOW Form_1   ;
	             AT 0,0	              ;
	             WIDTH 510	;  
	             HEIGHT 350	;
	             TITLE "Simples Exemplo (3) - Pedidos X Itens X Clientes";		
	             MAIN	              ;      
	             NOMAXIMIZE	;
	             NOSIZE	

                           @ 010,010 GRID Grid_Pedidos		;
				WIDTH  105			;
				HEIGHT 243			;
				HEADERS {"Pedidos"}		;
				WIDTHS  {100}			;
				FONT "Arial" SIZE 09		;
				ON CHANGE 	( 		;
					Mostra_Itens(),		; 
					Mostra_Cliente() 	;
						)

	              @ 080,130 GRID Grid_Itens			;
			   WIDTH  365			;
	                               HEIGHT 170			;
	                               HEADERS {"Produto","Quant","Unitário","Total"};
	                               WIDTHS  {90,90,90,90}		;
   	                               FONT "Arial" SIZE 09	       	;
			   NOLINES	

                            @ 257,130 LABEL Quant_Itens	;
		            VALUE 'Quant Ítens'		;
		            WIDTH 200		;
		            HEIGHT 30		;
	                          FONT 'Arial' SIZE 10

                            @ 257,365 LABEL Total_Geral	;
		            VALUE 'Total Geral'		;
		            WIDTH 200		;
		            HEIGHT 30		;
	                          FONT 'Arial' SIZE 10

                            @ 010,130 LABEL Label_Cliente	;
		            VALUE 'Cliente'		;
		            WIDTH 400		;
		            HEIGHT 30		;
	                          FONT 'Arial' SIZE 09 BOLD

                            @ 030,130 LABEL Label_Endereco	;
		            VALUE 'Endereço'		;
		            WIDTH 400		;
		            HEIGHT 30		;
	                          FONT 'Arial' SIZE 09 BOLD

                            @ 050,130 LABEL Label_Cidade    	;
		            VALUE 'Cidade'		;
		            WIDTH 200		;
		            HEIGHT 30		;
	                          FONT 'Arial' SIZE 09 BOLD

                            @ 050,430 LABEL Label_Estado	;
		            VALUE 'Estado'		;
		            WIDTH 100			;
		            HEIGHT 30		;
	                          FONT 'Arial' SIZE 09 BOLD	

                           @ 280,010 BUTTON Btn_Imprimir	;
                                    CAPTION '&Imprimir Pedido'	;
                                    WIDTH 120 HEIGHT 25		;
                                    ACTION Imprimir_Pedido()	;
                                    FONT "MS Sans Serif" SIZE 09 FLAT 

	END WINDOW		
	
	/*  ENCHE GRID DOS PEDIDOS CADASTRADOS */ 
              Pedidos->(DBGoTop()) 	 	
	 Do While ! Pedidos->(Eof())    
                     ADD ITEM { Pedidos->Pedido } TO Grid_Pedidos OF Form_1              
                     Pedidos->(DBSkip())
	 EndDo

	MODIFY Grid_Pedidos OF Form_1 VALUE 1

	CENTER WINDOW   Form_1
	ACTIVATE WINDOW Form_1
	Return

/* 
*/
Function Mostra_Itens()	
              Local cPedido	:= PegaValorDaColuna( "Grid_Pedidos" ,  "Form_1" , 1 )
	Local nQuantItens	:= 0
	Local nTotal	:= 0

	 /*  ENCHE GRID DOS ITENS COM O PEDIDO ESCOLHIDO  */ 
	 Itens->(DBSeek( cPedido ))	
	 DELETE ITEM ALL FROM Grid_Itens OF Form_1
	 Do While Itens->Pedido == cPedido .And. ! Itens->(Eof())
                     ADD ITEM { Itens->Produto, Str(Itens->Quant,5), TransForm( Itens->Valor,"@R 999,999.99"), TransForm( Itens->Quant * Itens->Valor,"@R 999,999.99") } TO Grid_Itens OF Form_1  
	       nQuantItens += 1
	       nTotal +=  ( Itens->Quant * Itens->Valor )
                     Itens->(DBSkip())
	 EndDo

	 MODIFY CONTROL Quant_Itens OF Form_1 Value  'Quant Ítens: '+Str(nQuantItens,3)		
	 MODIFY CONTROL Total_Geral OF Form_1  Value  'Total Geral: '+TransForm( nTotal , "@R 999,999.99")
	
               Return Nil

/* 
*/
Function Mostra_Cliente()	
              Local cPedido	:= PegaValorDaColuna( "Grid_Pedidos" ,  "Form_1" , 1 )
 
	Pedidos->(DBSeek( cPedido ))                   && Posiciona no registro do Pedido 
	Clientes->(DBSeek( Pedidos->Cliente ))      && Posiciona o Cliente	
	
	/* Coloca os dados do Cliente nos Respectivos Label's  */
	MODIFY CONTROL Label_Cliente	OF Form_1 Value  'Cliente      '+ Alltrim(Clientes->Nome)
	MODIFY CONTROL Label_Endereco	OF Form_1 Value  'Endereço '	+ Alltrim(Clientes->Endereco)
	MODIFY CONTROL Label_Cidade	OF Form_1 Value  'Cidade      '	+ Alltrim(Clientes->Cidade)
	MODIFY CONTROL Label_Estado	OF Form_1 Value  'Estado  '	+ Alltrim(Clientes->Estado)
	
	Return Nil	

/*
*/
Function PegaValorDaColuna( xObj, xForm, nCol)
	 Local nPos := GetProperty ( xForm , xObj , 'Value' )
	 Local aRet := GetProperty ( xForm , xObj , 'Item' , nPos )
	 Return aRet[nCol]

/*
*/
Function Imprimir_Pedido()           
	Local nQuantItens	:= 0
	Local nTotal	:= 0
	Local cPedido := PegaValorDaColuna( "Grid_Pedidos" ,  "Form_1" , 1 ) 

	If Empty( cPedido )
	  MsgBox("Nenhum Pedido foi Selecionado!!")
	  Return Nil
	EndIf

              Form_1.Btn_Imprimir.Enabled := .F.

              Private nFont := 11
              Private cArquivo := "" 

              Set Printer TO REL.TMP
              Set Printer ON
              Set Console OFF
	
	Pedidos->(DBSeek( cPedido ))                   && Posiciona no registro do Pedido 
	Clientes->(DBSeek( Pedidos->Cliente ))      && Posiciona o Cliente	

	? "Pedido Número: "+cPedido
	? Replicate("-",78)
	? "Cliente            : "+Clientes->Nome
	? "Endereço        : "+Clientes->Endereco
	? "Cidade            : "+AllTrim(Clientes->Cidade)+"/"+Clientes->Estado 	
	? " "
	? "Produto                       Quant             Unitário                Total" 
	? Replicate("-",78)
	     
	Itens->(DBSeek( cPedido ))
              Do While Itens->Pedido == cPedido  .And. ! Pedidos->(Eof())
                   ?    Itens->Produto        + Space(19) 
	     ??  StrZero(Itens->Quant,3) + Space(11)
	     ??  TransForm( Itens->Valor,"@R 999,999.99") + Space(10)   
	     ??  TransForm( Itens->Quant * Itens->Valor,"@R 999,999.99")
                   nQuantItens += 1
	     nTotal +=  ( Itens->Quant * Itens->Valor )
                   Itens->(DBSkip())
	 EndDo
               ? Replicate("-",78)             

              Set Printer TO 
              Set Printer OFF
              Set Console ON
   
               cArquivo :=memoRead("REL.TMP")

               Define Window Form_3;
	           At 0,0              ;
                         Width 450        ;
                         Height 500       ;
                         Title "Impressão do Pedido: "+cPedido;
                         ICON "AGENDA";
                         CHILD ;
                         NOSYSMENU;
	           NOSIZE		;      	
	           ON RELEASE  Form_1.Btn_Imprimir.Enabled := .T.  ;
                         BACKCOLOR WHITE

                        @20,-1 EDITBOX Edit_1 ;
                                   WIDTH 460 ;
                                   HEIGHT 510 ;
                                   VALUE cArquivo ;
		       TOOLTIP "Dados do Pedido "+cPedido ;
                                   MAXLENGTH 255 				

                       @ 01,01 BUTTON Bt_Zoom_Mais  ;
                                    CAPTION '&Zoom(+)'             ;
                                    WIDTH 120 HEIGHT 17    ;
                                    ACTION ZoomLabel(1);
                                    FONT "MS Sans Serif" SIZE 09 FLAT 

                       @ 01,125 BUTTON Bt_Zoom_menos  ;
                                     CAPTION '&Zoom(-)'             ;
                                     WIDTH 120 HEIGHT 17    ;
                                     ACTION ZoomLabel(2);
                                     FONT "MS Sans Serif" SIZE 09 FLAT

                       @ 01,321 BUTTON Sair_1  ;
                                     CAPTION '&Sair'             ;
                                     WIDTH 120 HEIGHT 17    ;
                                     ACTION Form_3.Release;
                                     FONT "MS Sans Serif" SIZE 09 FLAT

               End window

               MODIFY CONTROL Edit_1 OF Form_3 FONTSIZE nFont  

               Center Window Form_3
               Activate Window Form_3
               Return Nil
/*
*/
Function ZoomLabel(nmm)       	
	If nmm == 1 
                  nFont++
	Else
	    nFont--
	Endif
              MODIFY CONTROL Edit_1 OF Form_3 FONTSIZE nFont
	Return Nil
