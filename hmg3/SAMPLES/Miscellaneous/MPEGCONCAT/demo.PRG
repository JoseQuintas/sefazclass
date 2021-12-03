/*
* 
* Concatena Arquivos MPEG
* Humberto Fornazier - Julho/2002
* hfornazier@brfree.com.br
* 
* xHarbour Compiler Build 0.73.5 (SimpLex )
* Copyright 1999-2002, http://www.xharbour.org http://www.harbour-project.org/
* 
* HMG - Harbour Win32 GUI library - Release 35
* Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
* http://www.hmgforum.com//
*
*/ 
#include "hmg.ch"
#Include "Fileio.CH"
#Include "Directry.CH"
#Define  SISTEMA "Anexador de Arquivos MPG"
#DEFINE  QUEBRA    Chr(13)+Chr(10)
/*
*/

DECLARE WINDOW Frm_Principal 

Procedure Main()

	  Cria_FrmPrincipal()
	  Frm_Principal.Tb_Nome_Arquivo.SetFocus
	  Frm_Principal.Center
	  Frm_Principal.Activate
	  Return Nil
/*
*/
Function Cria_FrmPrincipal()
//	 HB_LANGSELECT("PT")

	 DEFINE WINDOW Frm_Principal AT 0,0	       ;
		WIDTH  480			       ;
		HEIGHT 470			       ;
		TITLE "Anexador de Arquivos MPEG"      ;
		ICON "HB_FILM"                         ;
                MAIN                                   ;
		NOMAXIMIZE			       

		DEFINE STATUSBAR
			STATUSITEM "Connect Sistemas de Informática - email: hfornazier@brfree.com.br" 
		END STATUSBAR

		*------------ Nome do Arquivo --------------------*
		@010,010 FRAME Group_Arquivos_1 WIDTH 450 HEIGHT 40
		@024,020 LABEL	Lb_Nome_Arquivo        ;
			 VALUE "Novo Arquivo"          ;
			 WIDTH	85		       ;
			 HEIGHT 15		       ;
			 FONT "MS Sans Serif" SIZE 8 BOLD

		@020,110 TEXTBOX  Tb_Nome_Arquivo      ;
			 WIDTH 340		       ;
			 VALUE DiskName()+":\"+CurDir()+"\NOVO_ARQUIVO.MPG";
			 FONT "Arial" Size 10          ;
			 TOOLTIP "Digite o Nome do Arquivo a ser Gerado";
			 MAXLENGTH 50
		
		*------------ Grid ----------------*
		@060,010 GRID Grid_Arquivos	   ;
			 WIDTH	315		   ;
			 HEIGHT 329		   ;
			 HEADERS {"Arquivo"}       ;
			 WIDTHS  {310}		   ;
			 FONT "Arial" SIZE 09

		*---------------------- Botoes ---------------------------*
		@060,340 FRAME Group_Arquivos_2 WIDTH 120 HEIGHT 285 OPAQUE

		@ 070,350 BUTTON Adicionar_Arquivo ;
			  CAPTION '&Adicionar'     ;
			  ACTION { || Bt_Adcionar()};
			  FONT "MS Sans Serif" SIZE 09 FLAT

		@ 110,350 BUTTON Exluir_Arquivo        ;
			  CAPTION '&Excluir'           ;
			  ACTION { || Bt_Excluir() }   ;
			  FONT "MS Sans Serif" SIZE 09 FLAT

		@ 150,350 BUTTON Limpar_Arquivo        ;
			  CAPTION '&Limpar'            ;
			  ACTION { || Bt_Limpar()}     ;
			  FONT "MS Sans Serif" SIZE 09 FLAT

		@ 190,350 BUTTON Gerar_Arquivo	       ;
			  CAPTION '&Gerar'             ;
			  ACTION { || Bt_Gerar()}      ;
			  FONT "MS Sans Serif" SIZE 09 FLAT

		@ 230,350 BUTTON Cancelar_Arquivo      ;
			  CAPTION '&Sair'              ;
			  ACTION { || Frm_Principal.Release } ;
			  FONT "MS Sans Serif" SIZE 09 FLAT

		@355,330 ANIMATEBOX Ani_HMG ;
			 WIDTH 300 ;
			 HEIGHT 80 ;
			 FILE 'HMG' AUTOPLAY
        
		DEFINE MAIN MENU
		       POPUP "Sistema"
			      ITEM "&Sair        " ACTION { || Frm_Principal.Release }
		       END POPUP
		       POPUP "Help"
			    ITEM "Ajuda" ACTION { || Ajuda_Sistema() }
			    SEPARATOR
                            ITEM "Sobre" ACTION { || Sobre_o_Sistema() }
		       END POPUP
		END MENU

	 END WINDOW
	 Return Nil    
/*
*/
Function Sobre_o_Sistema()
	 PlayExclamation()
         MsgINFO (PadC("*** Anexador de Arquivos MPEG ***",60)+QUEBRA+;
                  PadC(" ",30)+QUEBRA+;
                  PadC(" Humberto_Fornazier  hfornazier@brfree.com.br",60)+QUEBRA+;
                  PadC(" ",30)+QUEBRA+;
			  PadC(" Desenvolvido com xHarbour 0.73.5 + HMG (Release 35)",60)+QUEBRA+;
                  PadC(" ",30)+QUEBRA+;
                  PadC("HMG / Roberto Lopez / Arqentina",60)+QUEBRA+;
                  PadC("mail.box.hmg@gmail.com = www.geocities.com/harbour_HMG",60)+QUEBRA+;
                  PadC(" ",30)+QUEBRA+;
                  PadC("xHarbour Compiler Build 0.73.5 (SimpLex)",60)+QUEBRA+;
                  PadC("http://www.xharbour.org http://www.harbour-project.org/",60),SISTEMA)
         Return NIL
/*
*/
Function Ajuda_Sistema()
	 PlayExclamation()
         MsgINFO (PadC("*** Anexador de Arquivos MPEG ***",60)+QUEBRA+;
                  PadC(" ",30)+QUEBRA+;
		  PadC(" Adcionar  =  Adiciona Arquivo no GRID          ",60)+QUEBRA+;
		  PadC(" Excluir   =  Exclui   Arquivo no GRID          ",60)+QUEBRA+;
		  PadC(" Limpar    =  Exclui   Todos os Arquivos do GRID",60)+QUEBRA+;
		  PadC(" Gerar     =  Gera     Arquivo                  ",60)+QUEBRA+;
		  PadC(" Sair      =  Termina Programa                  ",60)+QUEBRA+;
		  PadC(" ",60),SISTEMA)
         Return NIL
/*
*/
Function Bt_Adcionar()
	 Local cArquivo := ""
	 If ! ChangeNomeArquivo()
	    Return Nil
	 EndIf
	 cArquivo := GetFile()
	 If ! Empty( cArquivo )
	    Frm_Principal.Grid_Arquivos.AddItem ( { cArquivo } )
	 Endif
	 Return Nil
/*
*/
Function Bt_Limpar()
	 Frm_Principal.Grid_Arquivos.DeleteAllItems()
	 Frm_Principal.Tb_Nome_Arquivo.SetFocus  
	 Return Nil
/*
*/
Function Bt_Excluir()
	 Local ni := Frm_Principal.Grid_Arquivos.Value 
	 If ni != 0
	    Frm_Principal.Grid_Arquivos.DeleteItem( ni )
	 EndIf
	 Frm_Principal.Tb_Nome_Arquivo.SetFocus
	 Return Nil
/*
*/
Function Bt_Gerar()
	 Local Novo_Arquivo := AllTrim( Frm_Principal.Tb_Nome_Arquivo.Value )
	 Local arq1
	 Local arq2
	 Local i
	 Local aarq := {}
	 Local buffer
	 Local tam
	 Local tg
	 Local inicio
	 Local aItens
	 Local QtItens :=  Frm_Principal.Grid_Arquivos.ItemCount

	 If QtItens == 0
	    MsgInfo("Nenhum Arquivo foi Selecionado!!")
	    Frm_Principal .Tb_Nome_Arquivo.SetFocus
	    Return Nil
	 EndIf

	 If ! Empty( Novo_Arquivo ) .And. Right( Novo_Arquivo , 3 ) != "MPG"
	    Novo_Arquivo += ".MPG"
	 EndIf
     
	 arq1 := FCreate( Novo_Arquivo , FC_NORMAL )

	 If ! File( Novo_Arquivo )
	    MsgINFO("Arquivo << "+Novo_Arquivo+" >> não foi Criado..."+QUEBRA+"Verifique o Caminho Correto!!")
	    Frm_Principal.Tb_Nome_Arquivo.SetFocus 
	    Return Nil
	 EndIf

	 inicio := 1

	 For i := 1 To QtItens
	     aItens := Frm_Principal.Grid_Arquivos.Item (i)
	     aDados := Directory( AllTrim( aItens[ 1 ] ) )
	     arq2 := FOpen( aDados[ 1 ][ F_NAME ] )
	     tam  := aDados[ 1 ][ F_SIZE ]
	     Do While .T.
		tg := Iif( tam > 50000, 50000, tam )
		buffer := Space( tg )
		FRead( arq2, @buffer, tg )
		FWrite( arq1, buffer, tg )
		tam -= 50000
		If tam <= 0
		   Exit
		EndIf
	     EndDo
	     inicio += aDados[ 1 ][ F_SIZE ]
	     FClose( arq2 )
	 Next

	 FClose( arq1 )
	 MSGINFO(" Arquivo "+Novo_Arquivo+" Gerado!!",SISTEMA)
	 Frm_Principal.Tb_Nome_Arquivo.SetFocus   
	 Return Nil
/*
*/
Function ChangeNomeArquivo()
	 lRet := .T.
	 If Empty(  Frm_Principal.Tb_Nome_Arquivo.Value )
	    MsgINFO("Nome do Arquivo não foi informado!!")
	    lRet := .F.
	 EndIf
	 Frm_Principal.Tb_Nome_Arquivo.SetFocus
	 Return lRet
