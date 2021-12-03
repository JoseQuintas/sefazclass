/*
* Contactos
* (C) 2003 Roberto Lopez <mail.box.hmg@gmail.com>
* 
* Contribuciones de mejoramiento del código: Javier Tovar y Pablo César
*
*/

//    El archivo 'hmg.ch' debe ser incluido en todos los programas HMG
#include "hmg.ch"

Function Main
// Inicializacion RDD DBFCDX Nativo

REQUEST DBFCDX , DBFFPT
RDDSETDEFAULT( "DBFCDX" )

SET DATE FRENCH
SET CENTURY ON

/*
Todas los programas HMG, deben tener una ventana principal.
Esta debe ser definida antes que cualquier otra.
*/

// AbrirTablas()

DEFINE WINDOW Principal ;
    AT 0,0 ;
    WIDTH 640 ;
    HEIGHT 480 ;
    TITLE 'Contactos' ;
    MAIN ;
    ON RELEASE CerrarTablas() ;
    ICON 'TUTOR' ON INIT AbrirTablas()

    ON KEY ESCAPE ACTION ThisWindow.Release()

    /*
    DEFINE WINDOW:  Inicia la definicion de la ventana. Debe indicarse un
            nombre de ventana que sera unico para todo el programa.
            (Puede usarse en codigo el mismo nombre mas de una vez
            pero solo una puede estar activa al mismo tiempo)   
    AT:     Indica Fila,Columna del angulo superior izquierdo de la 
            ventana (medida en pixels)
    WIDTH:      Ancho de la ventaba medido en pixels.
    HEIGHT:     Altura de la ventana medida en pixels.
    TITLE:      Titulo de la ventana        
    MAIN:       Indica que se esta definiendo la ventana principal del 
            programa.
    */

    // Definicion del menu principal 
    // Cada menu puede tener multiples POPUPs (submenus)
    // Los popups pueden anidarse sin limites.
    // A continuacion de DEFINE POPUP se indica la etiqueta.
    // El '&' se usa para indicar la 'hot-key' asociada con ese
    // item de menu. En el caso del primer popup, sera ALT+A
    // Cada item de menu se define mediante MENUITEM.
    // La clausula ACTION, indica el procedimiento a ejecutarse
    // cuando el usuario selecciona el item.
    // SEPARATOR Incluye una linea horizontal, usada para separar 
    // items.

    DEFINE MAIN MENU 
        DEFINE POPUP '&Archivo'
            MENUITEM '&Contactos'         ACTION AdministradorDeContactos()
            MENUITEM '&Tipos de Contacto' ACTION AdministradorDeTipos()
            SEPARATOR
            MENUITEM '&Reindexa'          ACTION ReindexaIndices(.T.,.T.)
            SEPARATOR
            MENUITEM '&Salir'             ACTION EXIT PROGRAM
        END POPUP
        DEFINE POPUP 'A&yuda'
            MENUITEM 'A&cerca de...'      ACTION MsgInfo ('Tutor ABM' + Chr(13) + Chr(10) + '(c) 2003 Roberto Lopez'+CRLF+"Contribuciones: Javier Tovar y Pablo César" )
        END POPUP
    END MENU

    // Fin de la definicion del menu principal 

    // El control TOOLBAR puede contener multiples botones de 
    // comando.
    // El tamaño de estos botones es definido por medio de la
    // clausula BUTTONSIZE <Ancho>,<Alto>
    // FLAT crea botones 'planos'
    // RIGHTTEXT indica que el texto de los botones se ubicara
    // a la derecha de su imagen.

    DEFINE TOOLBAR ToolBar_1 FLAT BUTTONSIZE 110,35 RIGHTTEXT BORDER

        BUTTON Button_1 ;
            CAPTION 'Contactos' ;
            PICTURE 'Contactos' ;
            ACTION AdministradorDeContactos()

        // CAPTION Indica el titulo del boton.
        // PICTURE El archivo de imagen asociado (BMP)
        // ACTION Un procedimiento de evento asociado al boton
        // (lo que va a ejecutarse cuando se haga click)

        BUTTON Button_2 ;
            CAPTION 'Tipos Ctto.' ;
            PICTURE 'Tipos' ;
            ACTION AdministradorDeTipos()

        BUTTON Button_3 ;
            CAPTION 'Re-Index' ;
            PICTURE 'Construccion' ;
            ACTION ReindexaIndices(.T.,.T.)
            
            
        BUTTON Button_4 ;
            CAPTION 'Ayuda' ;
            PICTURE 'ayuda' ;
            ACTION MsgInfo ('Tutor ABM' + Chr(13) + Chr(10) + '(c) 2003 Roberto Lopez'+CRLF+"Contribuciones: Javier Tovar y Pablo César" )

    END TOOLBAR

    
    @ 320,410 PROGRESSBAR Progress_1     ;
        RANGE 0 , 1000                   ;
        WIDTH 300                        ;
        HEIGHT 26                        ;
        TOOLTIP "ProgressBar Horizontal" ;
        BACKCOLOR GREEN FORECOLOR RED
    
    // La barra de estado aparece en la parte inferior de la ventana.
    // Puede tener multiples secciones definidas por medio de STATUSITEM
    // Existen dos secciones (opcionales) predefinidas, llamadas 
    // CLOCK y DATE (muestran un reloj y la fecha respectivamente)

    DEFINE STATUSBAR 
        STATUSITEM "(c) 2013 Roberto Lopez - Version 1.1" 
        CLOCK 
        DATE 
    END STATUSBAR

// Fin de la definicion de la ventana
END WINDOW
// maximizar la ventana 
MAXIMIZE WINDOW Principal 
// Activar la ventana

Principal.Progress_1.Hide

ACTIVATE WINDOW Principal
// El comando ACTIVATE WINDOW genera un estado de espera. 
// El programa estara detenido en este punto hasta que la ventana
// sea cerrada interactiva o programaticamente. Solo se ejecutaran
// los procedimientos de evento asociados a sus controles (o a la 
// ventana misma)
Return Nil

Function AbrirTablas
Local nArea, aMidb
Local lDbf1:=.F., lDbf2:=.F.

nArea := SELECT('Tipos')
IF nArea == 0
   IF !FILE('Tipos.DBF' )
      aMidb:= {{ "Cod_Tipo"   , "N", 03, 0}, ; 
               { "Desc"       , "C", 32, 0}}
      DBCREATE('Tipos.DBF', aMidb )
   ENDIF
   IF !FILE( 'Tipos.CDX' )
      lDbf1:=.T.
   ENDIF
ENDIF

nArea := SELECT('Contactos')
IF nArea == 0
   IF !FILE('Contactos.DBF' )
      aMidb:= {{ "Apellido"   , "C", 25, 0}, ; 
               { "Nombres"    , "C", 25, 0}, ;
               { "Calle"      , "C", 25, 0}, ;
               { "Numero"     , "N", 10, 0}, ;
               { "Piso"       , "N", 02, 0}, ;
               { "Dpto"       , "C", 01, 0}, ;
               { "Tel_Part"   , "C", 16, 0}, ;
               { "Tel_Cel"    , "C", 16, 0}, ;
               { "E_Mail"     , "C", 32, 0}, ;
               { "Fecha_Nac"  , "D", 8, 0}, ;
               { "Observ"     , "M", 10, 0}, ;
               { "Cod_Tipo"   , "N", 03, 0}}
      DBCREATE('Contactos.DBF', aMidb )
   ENDIF
   IF !FILE( 'Contactos.CDX' )
      lDbf2:=.T.
   ENDIF
ENDIF

If lDbf1 .or. lDbf2
   ReindexaIndices(lDbf1,lDbf2)
   DBCLOSEALL()
Endif

USE Tipos INDEX Tipos ALIAS Tipos NEW SHARED
Tipos->(DbGoTop())

USE Contactos INDEX CONTACTOS ALIAS Contactos NEW SHARED
Contactos->(ORDSETFOCUS('Apellido'))
Contactos->(DbGoTop())
Return Nil

Function ReindexaIndices(lArea1,lArea2)
Local nLastRec
Private nRecsDone

DBCLOSEALL()
Principal.Progress_1.Show
If lArea1
   nRecsDone := 0
   Principal.Progress_1.Value := nRecsDone
   USE Tipos ALIAS Tipos EXCLUSIVE
   nLastRec := LastRec()
   INDEX ON STR(Cod_Tipo, 3) TAG Cod_Tipo
   INDEX ON HMG_Upper(Desc) TAG Desc
   REINDEX EVAL {|| InProgress(nLastRec) } EVERY 10
   Tipos->(DBCLOSEAREA())
Endif
If lArea2
   nRecsDone := 0
   Principal.Progress_1.Value := nRecsDone
   USE Contactos ALIAS Contactos NEW EXCLUSIVE
   nLastRec := LastRec()
   INDEX ON HMG_UPPER(Apellido) TAG Apellido
   INDEX ON HMG_UPPER(Nombres) TAG Nombres
   INDEX ON Cod_Tipo TAG Cod_Tipo
   REINDEX EVAL {|| InProgress(nLastRec) } EVERY 10
   Contactos->(DBCLOSEAREA())
Endif     
Principal.Progress_1.Hide
AbrirTablas()
Return Nil

Function InProgress(nLastRec)
nRecsDone := nRecsDone + 10
Principal.Progress_1.Value := ( nRecsDone/nLastRec ) * 100
hb_IdleSleep( 0.2 ) // When dbf is too big, pls cut off this
Return .T.

Function CerrarTablas
DBCLOSEALL()
// FErase("Tipos.cdx") --> not good habit
// FErase("Contactos.cdx") --> not good habit
Return Nil