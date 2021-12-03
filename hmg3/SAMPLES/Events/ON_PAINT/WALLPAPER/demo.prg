
  
#define BMP_ERASE        0     // Borra la imagen de fondo de la ventana
#define BMP_COPY_NORMAL  1     // Pega la imagen al fondo con el tamaño original de la misma
#define BMP_COPY_SCALE   2     // Ajusta proporcionalmente la imagen para que se vea completa en la ventana
#define BMP_COPY_STRETCH 3     // Ajusta el tamaño de la imagen al tamaño de la ventana (no respeta las proporciones originales)


 
#include "hmg.ch" 

Function Main 

PRIVATE hBitmap  := 0
PRIVATE cFileBMP := "cow_book.bmp"
PRIVATE nMode    := BMP_COPY_STRETCH    
PRIVATE Row := 0
PRIVATE Col := 0

    DEFINE WINDOW Win1 ; 
        AT 0,0 ; 
        WIDTH 800 ; 
        HEIGHT 630 ; 
        TITLE 'SET BACKGROUND WINDOW' ; 
        MAIN;  //ON INIT Repaint_Window (); // Invalida toda el area del cliente para que se envie un Msg WM_PAINT para obligar a que se ejecute ON PAINT al iniciarse la ventana		      		
		ON PAINT Paint_Background_Window ();
		ON RELEASE BMP_RELEASE_HANDLE (hBitmap);
		VIRTUAL WIDTH  1100;
        VIRTUAL HEIGHT 1100;


        DEFINE MAIN MENU
               DEFINE POPUP "Automatic" 
                  MENUITEM "Automatic background change" ACTION {||Win1.Flag_Automatic.Checked:=.NOT.(Win1.Flag_Automatic.Checked)} NAME Flag_Automatic CHECKED 
            END POPUP
        END MENU 
        Win1.Flag_Automatic.Checked := .F.
		
        DRAW LINE IN WINDOW Win1 AT 0,400 TO 600,400 PENCOLOR RED PENWIDTH 2

        DEFINE TAB Tab_1 ;
			AT 30,10 ;
			WIDTH 400 ;
			HEIGHT 300 ;	
			VALUE 1 FONT 'ARIAL' SIZE 10
		 
			PAGE 'Page1' 			      
			     @ 55,90 LABEL Label_1 VALUE 'This is Page 1' WIDTH 100 HEIGHT 27
			     @ 100 , 10 EDITBOX ED_ctrl WIDTH 200 HEIGHT 100 VALUE "Hello HMG World" BACKCOLOR YELLOW FONTCOLOR BLUE			     
			END PAGE

		    DEFINE PAGE 'Page2'
				@ 55,90 LABEL Label_2 VALUE 'This is Page 2' WIDTH 100 HEIGHT 27
           END PAGE
        END TAB 
        
              
         @ 10,450 GRID Grid_1 WIDTH 300 HEIGHT 330 ;
            HEADERS {'Column 1','Column 2','Column 3'} ;
            WIDTHS {140,140,140};
            VIRTUAL ;
            ITEMCOUNT 30 ;
            ON QUERYDATA {||This.QueryData := Str ( This.QueryRowIndex ) + ',' + Str ( This.QueryColIndex )}

			
         @ 350,100 IMAGE Image_1 PICTURE 'demo.bmp' WIDTH 160 HEIGHT 120 STRETCH 
         
         @ 500,  50 BUTTON boton_1 CAPTION "On/Off image" ACTION  (IF (Win1.image_1.visible = .T., Win1.image_1.visible := .F., Win1.image_1.visible := .T.))
         @ 500, 200 BUTTON boton_2 CAPTION "On/Off TAB" ACTION  (IF (Win1.Tab_1.visible = .T., Win1.Tab_1.visible := .F., Win1.Tab_1.visible := .T.))
         @ 500, 350 BUTTON boton_3 CAPTION "On/Off GRID" ACTION  (IF (Win1.Grid_1.visible = .T., Win1.Grid_1.visible := .F., Win1.Grid_1.visible := .T.))        

  
         @ 500, 500 BUTTON boton_4 CAPTION "CHANGE" ACTION Background_Change ()        
         @ 500, 650 BUTTON boton_5 CAPTION "ERASE" ACTION Background_Erase ()
                                      

         DRAW LINE IN WINDOW Win1 AT 300,0 TO 300,800 PENCOLOR RED PENWIDTH 3
		 
	     DEFINE TIMER Timer1 INTERVAL 2000 ACTION {||IF(Win1.Flag_Automatic.Checked=.T., Background_Change (), NIL)}
	
    END WINDOW 	
    
	CENTER WINDOW Win1

 
	ACTIVATE WINDOW Win1
        
Return


Procedure Background_Change
Static flag := .T.
          If flag = .F.
             flag = .T.             			
             cFileBMP := "cow_book.bmp"
			 nMode    := BMP_COPY_STRETCH
          else
             flag = .F.                
			 cFileBMP := "sami2.bmp"
             nMode    := BMP_COPY_NORMAL			
          endif
		  
		  Paint_Background_Window ()
return

Procedure Background_Erase    
    nMode    := BMP_ERASE
	Paint_Background_Window ()
return


Procedure Paint_Background_Window
STATIC Old_cFileBMP:="", flag_change := .F.

       If  Old_cFileBMP <> cFileBMP
	       Old_cFileNMP := cFileBMP
		   BMP_RELEASE_HANDLE (hBitmap)
		   hBitmap := BMP_LOAD_FILE (cFileBMP)
		   flag_change := .T.
	   Endif
	   
	   If nMode = BMP_COPY_NORMAL
    	  Row := -Win1.VscrollBar.value
          Col := -Win1.HscrollBar.value		  
	   Else
    	  Row := 0
          Col := 0
	   Endif
	   
	   hWnd := GetFormHandle ("Win1")	   
	   BMP_PAINT (hWnd, hBitmap, nMode, Row, Col, 1000, 1000)
	   	   
       If flag_change := .T.
	      flag_change := .F.
	      Repaint_Window ()		      
	   Endif  	     	   
Return


Procedure Repaint_Window
	//InvalidateRect (GetFormHandle(ThisWindow.Name), {0,0,400,300}, .F.)  // Example: Invalidate only half superior of client area
	InvalidateRect (GetFormHandle(ThisWindow.Name), NIL ,.F.)   // Invalidate all client area
Return



*#########################################################################################################################
*   FUNCIONES EN C        
*#########################################################################################################################

#pragma begindump

#include <shlobj.h>   
#include <winuser.h>
#include <windows.h>
#include "hbapi.h"


#define BMP_ERASE        0
#define BMP_COPY_NORMAL  1
#define BMP_COPY_SCALE   2
#define BMP_COPY_STRETCH 3

//*************************************************************************************************
// BMP_LOAD_FILE (cFileBMP)
//*************************************************************************************************
HB_FUNC (BMP_LOAD_FILE)
{   
   HBITMAP hBitmap;    
   char *cFileName;

   cFileName = (char *) hb_parcx (1);
    
   hBitmap = (HBITMAP)LoadImage(NULL, cFileName, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_CREATEDIBSECTION);
          
   if (hBitmap == NULL)
       hBitmap = (HBITMAP)LoadImage(GetModuleHandle(NULL), cFileName, IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION);
                          
   hb_retnl( (LONG) hBitmap );      
}

//*************************************************************************************************
// BMP_RELEASE_HANDLE (hBitmap)
//*************************************************************************************************
HB_FUNC (BMP_RELEASE_HANDLE)
{   
   hb_retni ((int) DeleteObject ((HBITMAP) hb_parnl (1)));
}


//*************************************************************************************************
// BMP_PAINT (hWnd, hBitmap, nMode, Row, Col, Row2, Col2)
//*************************************************************************************************

HB_FUNC (BMP_PAINT)
{
   HWND hWnd;
   HBITMAP hBitmap;
   HDC memDC, hDC;
   RECT rect;
   BITMAP bm;
   int nMode;

   hWnd     = (HWND)    hb_parnl (1);
   hBitmap  = (HBITMAP) hb_parnl  (2);
   nMode    = hb_parni (3);
   
   GetClientRect(hWnd, &rect);

   //hDC = GetDC (hWnd);   // obtine un hDC para toda el area del cliente (se puede pintar en cualquier lugar del area del cliente)
   PAINTSTRUCT ps;   
   hDC = BeginPaint (hWnd, &ps);  // obtiene un hDC solo para el area invalida (area que debe ser repintada) en un mensaje WM_PAINT    
		
   if (nMode == BMP_ERASE)
       FillRect(hDC,&rect,(HBRUSH) GetSysColorBrush(COLOR_BTNFACE));    
   else
   {
       FillRect(hDC,&rect,(HBRUSH) GetSysColorBrush(COLOR_BTNFACE)); // borra la imagen anterior antens de asignar otra
     
       memDC = CreateCompatibleDC(hDC);
              
       SelectObject(memDC, hBitmap);
       
       rect.top    = hb_parnl (4);
       rect.left   = hb_parnl (5);
 
       if (nMode == BMP_COPY_NORMAL)           
	   {    
	       rect.bottom = hb_parnl (6);	   
           rect.right  = hb_parnl (7);
		   BitBlt(hDC, rect.left, rect.top, rect.right, rect.bottom, memDC, 0, 0, SRCCOPY);
	   }
     
		
       GetObject(hBitmap, sizeof(BITMAP), (LPSTR)&bm);
                
       if (nMode == BMP_COPY_SCALE)
       {  if ((int) bm.bmWidth * rect.bottom / bm.bmHeight <= rect.right)
		      rect.right= (int) bm.bmWidth * rect.bottom / bm.bmHeight;
	      else		
		      rect.bottom = (int) bm.bmHeight * rect.right / bm.bmWidth;
                 
          StretchBlt(hDC, rect.left, rect.top, rect.right, rect.bottom, memDC, 0, 0, bm.bmWidth, bm.bmHeight, SRCCOPY);
       }
                
       if (nMode == BMP_COPY_STRETCH)
           StretchBlt(hDC, rect.left, rect.top, rect.right, rect.bottom, memDC, 0, 0, bm.bmWidth, bm.bmHeight, SRCCOPY);
                        
       DeleteDC(memDC);     
   }

   //EndPaint (hWnd, hDC); //Elimina el hDC y Valida el area pintada    
   ReleaseDC(hWnd, hDC);   //Elimina el hDC pero NO Valida el area pintada
                           //Al no validar el area pintada permite que los procesos de pintura siguientes encadenados puedan usar hDC = BeginPaint (hWnd, &ps); 

}


#pragma enddump

