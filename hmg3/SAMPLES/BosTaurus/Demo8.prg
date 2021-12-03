*******************************************************************************
* PROGRAMA: Demo ON PAINT event
* LENGUAJE: HMG
* FECHA:    Setiembre 2012
* AUTOR:    Dr. CLAUDIO SOTO
* PAIS:     URUGUAY
* E-MAIL:   srvet@adinet.com.uy
* BLOG:     http://srvet.blogspot.com
*******************************************************************************


#include "hmg.ch"


FUNCTION MAIN

LOCAL aRows [18] [3]
aRows  [1]:= {"Simpson",   "Homer",     "555-5555"}
aRows  [2]:= {"Mulder",    "Fox",       "324-6432"} 
aRows  [3]:= {"Smart",     "Max",       "432-5892"} 
aRows  [4]:= {"Grillo",    "Pepe",      "894-2332"} 
aRows  [5]:= {"Kirk",      "James",     "346-9873"} 
aRows  [6]:= {"Barriga",   "Carlos",    "394-9654"} 
aRows  [7]:= {"Flanders",  "Ned",       "435-3211"} 
aRows  [8]:= {"Smith",     "John",      "123-1234"} 
aRows  [9]:= {"Pedemonti", "Flavio",    "000-0000"} 
aRows [10]:= {"Gomez",     "Juan",      "583-4832"} 
aRows [11]:= {"Fernandez", "Raul",      "321-4332"} 
aRows [12]:= {"Borges",    "Javier",    "326-9430"} 
aRows [13]:= {"Alvarez",   "Alberto",   "543-7898"} 
aRows [14]:= {"Gonzalez",  "Ambo",      "437-8473"} 
aRows [15]:= {"Vinazzi",   "Amigo",     "394-5983"} 
aRows [16]:= {"Pedemonti", "Flavio",    "534-7984"} 
aRows [17]:= {"Samarbide", "Armando",   "854-7873"} 
aRows [18]:= {"Pradon",    "Alejandra", "???-????"} 


PRIVATE hBitmap := 0 

     DEFINE WINDOW Win1;
            AT 0,0;
            WIDTH  700;
            HEIGHT 600;
            TITLE "Demo8: Draw in BITMAP";
            NOSIZE;
            NOMAXIMIZE;
            MAIN;
            ON INIT     Proc_ON_INIT ();
            ON RELEASE  Proc_ON_RELEASE ();
            ON PAINT    Proc_ON_PAINT ()


            DEFINE TAB Tab_1;
               ROW 100;
               COL 50;
               WIDTH  400;
               HEIGHT 300;
               ON CHANGE Win1.RadioGroup_1.Value := Win1.Tab_1.Value 

               DEFINE PAGE "Image"
                 @ 30, 80 IMAGE Image_1 PICTURE "COWBOOK.bmp" WIDTH 256 HEIGHT 256 
               END PAGE

               DEFINE PAGE "Grid"
                 @ 40, 30  GRID Grid_1;
                           WIDTH  350;
                           HEIGHT 220;
                           HEADERS {"Last Name","First Name","Phone"};
                           WIDTHS {140,140,140};
                           ITEMS aRows;
                           VALUE {1,1};
                           EDIT;
                           JUSTIFY {GRID_JTFY_CENTER, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT};
                           CELLNAVIGATION 
               END PAGE

               DEFINE PAGE "EditBox"
                  @ 50, 50 EDITBOX EditBox_1 WIDTH 300 HEIGHT 120  VALUE "Write your memories here."+CRLF+CRLF BOLD BACKCOLOR ORANGE
               END PAGE 

               DEFINE PAGE "ActiveX"
                   DEFINE ACTIVEX ActiveX_1
                      ROW     60
                      COL     40
                      WIDTH  320  
                      HEIGHT 200  
                      PROGID "ShockwaveFlash.ShockwaveFlash.9"  
                   END ACTIVEX
                   Win1.ActiveX_1.Object:Movie := "http://www.youtube.com/v/58CZcCvwND4&hl=en&fs=1"                  
               END PAGE
               
            END TAB

            @ 450, 200 BUTTON Button_1 CAPTION "On/Off" ACTION {|| Win1.Tab_1.Visible := .NOT.(Win1.Tab_1.Visible), Win1.RadioGroup_1.Visible := Win1.Tab_1.Visible}
            
            @ 230, 500  RADIOGROUP RadioGroup_1 OPTIONS {"Image","Grid","EditBox","ActiveX"} VALUE 1;
                        ON CHANGE Win1.Tab_1.Value := Win1.RadioGroup_1.Value

    END WINDOW

    CENTER WINDOW Win1
    ACTIVATE WINDOW Win1
RETURN Nil


PROCEDURE Proc_ON_INIT
LOCAL hBitmap_aux
LOCAL hDC, BTstruct
   
   hBitmap := BT_BitmapCreateNew (800, 600)

   hDC := BT_CreateDC (hBitmap, BT_HDC_BITMAP, @BTstruct)
     
          BT_DrawGradientFillVertical (hDC, 0, 0, 800, 600, {245,245,245}, BLACK)
     
          nTypeText    := BT_TEXT_TRANSPARENT + BT_TEXT_BOLD    
          nAlingText   := BT_TEXT_LEFT + BT_TEXT_TOP
          nOrientation := BT_TEXT_NORMAL_ORIENTATION
          BT_DrawText (hDC, 20, 50, "My Application - ver. 1.0", "Times New Roman", 24, ORANGE, WHITE, nTypeText, nAlingText, nOrientation)

          nAlingText   := BT_TEXT_CENTER + BT_TEXT_TOP
          BT_DrawText (hDC, 515, 350, "Copyright your programmer with the help of the Graphics Library Bos Taurus", "Book Antiqua", 12, ORANGE, WHITE, nTypeText, nAlingText, nOrientation)

          nAlingText   := BT_TEXT_LEFT + BT_TEXT_TOP
          nOrientation := BT_TEXT_DIAGONAL_ASCENDANT
          BT_DrawText (hDC, 450, 50, "The Power of HMG", "Book Antiqua", 50, {20,20,20}, WHITE, nTypeText, nAlingText, nOrientation)

          BT_DrawRectangle (hDC, 10, 5, 680, 550, GRAY, 3)
  
   BT_DeleteDC (BTstruct)

   hBitmap_aux := BT_BitmapLoadFile ("BosTaurus_Logo.bmp")
   BT_BitmapPaste (hBitmap, 20, 500, 132, 132, BT_SCALE, hBitmap_aux)
   BT_BitmapRelease (hBitmap_aux)
RETURN


PROCEDURE Proc_ON_RELEASE
   BT_BitmapRelease (hBitmap)
RETURN


PROCEDURE Proc_ON_PAINT
LOCAL hDC, BTstruct
  hDC := BT_CreateDC ("Win1", BT_HDC_INVALIDCLIENTAREA, @BTstruct)
         BT_DrawBitmap (hDC, 0, 0, 800, 600, BT_COPY,  hBitmap)
  BT_DeleteDC (BTstruct)
RETURN

