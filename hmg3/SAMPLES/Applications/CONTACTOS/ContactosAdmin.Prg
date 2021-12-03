#include 'hmg.ch'

Function AdministradorDeContactos
Public Nuevo := .F.		

// La clausula MODAL en la definicion de la ventana, hace que al ser
// activada, sea la unica a la cual el usuario podra tener acceso.

// Las clausulas FONT y SIZE definen el tipo y tamaño por defecto
// para todos los controles pertenecientes a la ventana.

// La clausula ON INIT permite definir un procedimiento que se ejecutara
// durante la inicializacion de la ventana (previa a la activacion) 


DEFINE WINDOW Win_1				;
	AT 0,0					;
	WIDTH 620				;
	HEIGHT 460				;
	TITLE 'Administrador de Contactos'	;
	MODAL   				

	DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 59,35 IMAGESIZE 20,20  FLAT BORDER

		BUTTON PRIMERO 		;
			CAPTION '&Primero' 	;
			PICTURE 'primero'	;
			ACTION ( dBGoTop() , Win_1.grid_1.RecNo := RecNo() ) 

		BUTTON ANTERIOR 	;
			CAPTION '&Anterior' 	;
			PICTURE 'anterior'	;
			ACTION ( dBSkip ( -1 ) , Win_1.grid_1.RecNo := RecNo() ) 

		BUTTON SIGUIENTE	;
			CAPTION '&Siguiente' 	;
			PICTURE 'siguiente'	;
			ACTION ( dBSkip (1) , if ( Eof() , DbGoBottom() , Nil ) , Win_1.grid_1.RecNo := RecNo() ) 

		BUTTON ULTIMO 		;
			CAPTION '&Ultimo' 	;
			PICTURE 'ultimo'	;
			ACTION ( dBGoBottom () , Win_1.grid_1.RecNo := RecNo() )  SEPARATOR 

		BUTTON BUSCAR 		;
			CAPTION '&Buscar' 	;
			PICTURE 'buscar'	;
			ACTION Buscar()

		BUTTON Nuevo 		;
			CAPTION '&Nuevo' 	;
			PICTURE 'nuevo'	;
			ACTION ( Nuevo := .T. , Nuevo() )

		BUTTON EDITAR 		;
			CAPTION '&Editar' 	;
			PICTURE 'editar'	;
			ACTION If ( BloquearRegistro() , ActivarEdicion() , Nil )

		BUTTON ELIMINAR 	;
			CAPTION 'E&liminar'	;
			PICTURE 'borrar'	;
			ACTION Eliminar() 

		BUTTON IMPRIMIR 	;
			CAPTION '&Imprimir'	;
			PICTURE 'imprimir2' ;
			ACTION Imprimir() 

		BUTTON CERRAR 	;
			CAPTION '&Cerrar'	;
			PICTURE 'cerrar' ;
			ACTION Win_1.release 

	END TOOLBAR

	// Comando GRID
	// ------------
	// La clausula HEADERS requiere un array de caracteres conteniendo
	// los encabezados de las columnas del control.
	// La clausula WIDTHS requiere un array numerico conteniendo
	// los anchos de las columnas del control.
	// La clausula WORKAREA requiere el nombre del area de trabajo
	// base para el BROWSE.	
	// La clausula VALUE del comando BROWSE requiere un valor numerico, 
	// conteniendo el numero fisico de registro (RecNo()) que se 
	// seleccionara 
	// La clausula FIELDS requiere un array de caracteres conteniendo
	// los nombres de los campos a mostrar.
	// al crearse el control.
	// La clausula ON CHANGE requiere un procedimiento que se ejecutara
	// cada vez que el registro seleccionado cambie interactiva o 
	// programaticamente.
	// La clausula ON DBLCLICK requiere un procedimiento que se ejecutara
	// cada vez que el usuario haga doble click o presione ENTER.

	@ 56,10 GRID grid_1				;
		WIDTH 190  				;
		HEIGHT 360 				;	
		HEADERS { 'Apellido' , 'Nombres' }	;
		WIDTHS { 100 , 100 }			;
		ROWSOURCE "Contactos"			;
		COLUMNFIELDS { 'Apellido' , 'Nombres' } ;
		ON CHANGE Actualizar() ;
		ON DBLCLICK ( ActivarEdicion() , If ( ! BloquearRegistro() , DesactivarEdicion() , Nil ) )

	// El control FRAME crea un recuadro, habitualmente usado para
	// agrupar controles.

	@ 56,210 FRAME FRAME_1 ;
		WIDTH 400      ;
		HEIGHT 360 				

	// El control LABEL permite mostrar textos.
	// Mediante la clausula VALUE puede establecerse su contenido
	// inicial.

	@ 66 , 220 LABEL LABEL_1 ;
		VALUE 'Apellido:' ;
		WIDTH 80

	// El control TEXTBOX permite ingresar datos de tipo caracter
	// (salvo que se especifique el modificador NUMERIC)
	// La clausula MAXLENGTH indica el limite maximo de caracteres
	// permitidos.

	@ 66 , 290 TEXTBOX Control_1 ;
		MAXLENGTH 25

	@ 66 , 420 LABEL LABEL_2 VALUE 'Tipo:' WIDTH 80

	// El control COMBOBOX muestra una lista de opciones.
	// En este caso, las opciones provienen del campo de una
	// tabla.

	@ 66 , 480 COMBOBOX Control_2 ;
	    VALUE VeTipo() ;
		ITEMSOURCE Tipos->Desc 

	@ 96 , 220 LABEL LABEL_3 ;
		VALUE 'Nombres:' ;
		WIDTH 80

	@ 96 , 290 TEXTBOX Control_3 ;
		MAXLENGTH 25

	@ 126 , 220 LABEL LABEL_4 ;
		VALUE 'Calle:' ;
		WIDTH 80

	@ 126 , 290 TEXTBOX Control_4 ;
		MAXLENGTH 25

	@ 126 , 420 LABEL LABEL_5 ;
		VALUE 'Numero:' ;
		WIDTH 80

	// En este caso, por accion de las clausulas NUMERIC y MAXLENGTH
	// podran ingresarse solo digitos, hasta un maximo de seis.

	@ 126 , 480 TEXTBOX Control_5 ;
		WIDTH 75 ;
		NUMERIC ;
		MAXLENGTH 6

	@ 156 , 220 LABEL LABEL_6 ;
		VALUE 'Piso:' ;
		WIDTH 80

	@ 156 , 290 TEXTBOX Control_6 ;
		WIDTH 45 ;
		NUMERIC ;
		MAXLENGTH 2

	@ 156 , 420 LABEL LABEL_7 ;
		VALUE 'Dpto:' ;
		WIDTH 80

	// La clausula UPPERCASE convierte automaticamente a mayusculas
	// el contenido del control.

	@ 156 , 480 TEXTBOX Control_7 ;
		WIDTH 45  ;
		UPPERCASE ;
		MAXLENGTH 1

	@ 186 , 220 LABEL LABEL_8 ;
		VALUE 'Tel. Part.:' ;
		WIDTH 80

	// La clausula INPUTMASK permite establecer mascaras de 
	// edicion. 
	// En el caso de TEXTBOX de tipo caracter, las mascaras pueden
	// contener '9' indicando digitos y 'A' indicando caracteres
	// alfabeticos. Todos los demas son incluidos literalmente.

	@ 186 , 290 TEXTBOX Control_8 ;
		INPUTMASK '9999-9999'

	@ 186 , 420 LABEL LABEL_9 ;
		VALUE 'Tel. Cel:' ;
		WIDTH 80

	@ 186 , 480 TEXTBOX Control_9 ;
		INPUTMASK '(99) 9999-9999'

	@ 216 , 220 LABEL LABEL_10 ;
		VALUE 'E-Mail:' ;
		WIDTH 80

	@ 216 , 290 TEXTBOX Control_10 ;
		MAXLENGTH 32

	@ 246 , 220 LABEL LABEL_11 ;
		VALUE 'Fecha Nac.:' ;
		WIDTH 80

	// El control DATEPICKER permite ingresar datos de tipo fecha.

	@ 246 , 290 DATEPICKER Control_11 

	@ 276 , 220 LABEL LABEL_12 ;
		VALUE 'Observ.' ;
		WIDTH 80

	// El control EDITBOX, permite ingresar datos de tipo caracter.
	// La diferencia basica con el control TEXTBOX, es que EDITBOX
	// esta pensado para ser usado con textos de gran longitud, por
	// lo cual permite ingresar multiples lineas e incluye barras de
	// desplazamiento horizontal y vertical.

	@ 276 , 290 EDITBOX Control_12 ;
		WIDTH 310 ;
		HEIGHT 90

	// El comando @...BUTTON permite definir botones de comando 
	// independientes.

	@ 376,320 BUTTON ACEPTAR ;
		CAPTION 'A&ceptar' ;
		ACTION AceptarEdicion()

	@ 376,425 BUTTON CANCELAR ;
		CAPTION 'Cancela&r' ;
		ACTION CancelarEdicion()

END WINDOW
DesactivarEdicion()
// Para ejecutar un metodo asociado a un control, debe especificarse
// el nombre de la ventana, usar un punto como separador, el nombre
// del control y finalmente el nombre del metodo, seguido opcionalmente
// por '()'

// El metodo 'SetFocus' le da el foco al control especificado.

Win_1.grid_1.SetFocus

// La sintaxis semi-oop usada tiene, en todos los casos, dos alternativas.
// En este caso seria:
// SETFOCUS grid_1 OF Win_1
// o
// DoMethod( 'Win_1' , 'grid_1' , 'SetFocus' )

Win_1.grid_1.RecNo := Contactos->(RecNo())
CENTER WINDOW Win_1
ACTIVATE WINDOW Win_1
Return Nil

Function DesactivarEdicion
// La propiedad ENABLED es de lectura y escritura, y permite
// determinar o establecer si un control esta activo o no (.t. o .f.)

Win_1.grid_1.Enabled		:= .T.
Win_1.Control_1.Enabled		:= .F. 
Win_1.Control_2.Enabled		:= .F. 
Win_1.Control_3.Enabled		:= .F. 
Win_1.Control_4.Enabled		:= .F. 
Win_1.Control_5.Enabled		:= .F. 
Win_1.Control_6.Enabled		:= .F. 
Win_1.Control_7.Enabled		:= .F. 
Win_1.Control_8.Enabled		:= .F. 
Win_1.Control_9.Enabled		:= .F. 
Win_1.Control_10.Enabled	:= .F. 
Win_1.Control_11.Enabled	:= .F. 
Win_1.Control_12.Enabled	:= .F. 

Win_1.Aceptar.Enabled		:= .F.
Win_1.Cancelar.Enabled		:= .F.

// Al cambiar la propiedad ENABLED a un control TOOLBAR, esto tiene efecto
// sobre todos los botones que contenga.

Win_1.ToolBar_1.Enabled		:= .T.
Win_1.grid_1.SetFocus
Return Nil

Function ActivarEdicion
Win_1.grid_1.Enabled		:= .F.
Win_1.Control_1.Enabled		:= .T. 
Win_1.Control_2.Enabled		:= .T. 
Win_1.Control_3.Enabled		:= .T. 
Win_1.Control_4.Enabled		:= .T. 
Win_1.Control_5.Enabled		:= .T. 
Win_1.Control_6.Enabled		:= .T. 
Win_1.Control_7.Enabled		:= .T. 
Win_1.Control_8.Enabled		:= .T. 
Win_1.Control_9.Enabled		:= .T. 
Win_1.Control_10.Enabled	:= .T. 
Win_1.Control_11.Enabled	:= .T. 
Win_1.Control_12.Enabled	:= .T. 

Win_1.Aceptar.Enabled		:= .T.
Win_1.Cancelar.Enabled		:= .T.
Win_1.ToolBar_1.Enabled		:= .F.

Win_1.Control_1.SetFocus
Return Nil

Function VeTipo()
Local nRet
Local nRecno:=Win_1.grid_1.RecNo

DBSELECTAREA( 'Tipos')
Goto nRecno
nRet:=Contactos->COD_TIPO
DBSELECTAREA( 'Contactos')
Return nRet

Function CancelarEdicion()
DesactivarEdicion()
Actualizar()
UNLOCK
Nuevo := .F.
Return Nil

Function AceptarEdicion()
Local nNuevoRecNo

DesactivarEdicion()

// Cuando un control COMBOBOX esta vinculado al campo de una tabla
// mediante la clausula ITEMSOURCE, la propiedad value, indica el numero
// fisico del registro cuyo contenido se ha seleccionado.
// En este caso, ese valor se usa para posicionarse en el area 'Tipos' 
// de tal forma de acceder al codigo de tipo que sera guardado en la
// tabla 'Contactos'
// Para el resto de los campos, simplemente se guarda en cada uno
// el contenido de la propiedad 'Value' del control correspondiente.
// Eligiendo el control adecuado para cada campo, no se requiere ninguna 
// conversion de tipos.
// Debe tenerse cuidado, en los campos de tipo numerico y caracter, 
// de establecer mediante la clausula MAXLENGTH o una mascara de 
// edicion, la longitud maxima de los datos ingresado para evitar errores 
// de overflow al grabar los datos en la tabla.

Tipos->(DbGoTo (Win_1.Control_2.Value))

If Nuevo == .T.
	Contactos->(DbAppend())
	Nuevo := .F.
else
	Contactos->( dbGoTo ( Win_1.Grid_1.RecNo ) )
EndIf

nNuevoRecNo := Contactos->( RecNo() )

Contactos->Apellido	 := Win_1.Control_1.Value
Contactos->Cod_Tipo	 := Tipos->Cod_Tipo 
Contactos->Nombres	 := Win_1.Control_3.Value
Contactos->Calle	 := Win_1.Control_4.Value
Contactos->Numero	 := Win_1.Control_5.Value
Contactos->Piso		 := Win_1.Control_6.Value
Contactos->Dpto		 := Win_1.Control_7.Value
Contactos->Tel_Part	 := Win_1.Control_8.Value
Contactos->Tel_Cel	 := Win_1.Control_9.Value
Contactos->E_Mail	 := Win_1.Control_10.Value
Contactos->Fecha_Nac := Win_1.Control_11.Value
Contactos->Observ	 := Win_1.Control_12.Value

// El metodo 'Refresh' actualiza el grid de acuerdo a los datos 
// actuales de la tabla.
// debe ejecutarse cada vez que necesitemos estar seguros de que
// estamos trabajando con datos actualizados.

Win_1.grid_1.Refresh

// Si se esta agregando un registro, se cambia la seleccion del
// grid a ese registro, cambiando su propiedad recno al numero
// fisico del registro nuevo.

If Nuevo == .T.
	Win_1.grid_1.RecNo := nNuevoRecNo
EndIf
UNLOCK
Return Nil

Function Nuevo()
// Se asignan valores iniciales a los controles.

Win_1.Control_1.Value := ''
Win_1.Control_2.Value := 0
Win_1.Control_3.Value := ''
Win_1.Control_4.Value := ''
Win_1.Control_5.Value := 0
Win_1.Control_6.Value := 0
Win_1.Control_7.Value := ''
Win_1.Control_8.Value := ''
Win_1.Control_9.Value := ''
Win_1.Control_10.Value := ''
Win_1.Control_11.Value := CtoD ('01/01/1960')
Win_1.Control_12.Value := ''

ActivarEdicion()
Return Nil

Function Actualizar()
// Este procedimiento, actualiza el contenido de los controles
// que permiten ver y editar el contenido de la tabla.
// Para ello, se asigna a la propiedad value el contenido actual
// del campo que corresponde a cada control.

// En el caso del COMBOBOX, se asigna a la propiedad value, el numero
// de registro que contiene el codigo que corresponde a la descripcion	
// de tipo que debe mostrarse.

Contactos->( dbGoTo ( Win_1.Grid_1.RecNo ) )
Win_1.Control_1.Value	:= Contactos->Apellido	
Win_1.Control_2.Value	:= VeTipo()
Win_1.Control_3.Value	:= Contactos->Nombres	
Win_1.Control_4.Value	:= Contactos->Calle	
Win_1.Control_5.Value 	:= Contactos->Numero	
Win_1.Control_6.Value	:= Contactos->Piso		
Win_1.Control_7.Value 	:= Contactos->Dpto		
Win_1.Control_8.Value	:= Contactos->Tel_Part	
Win_1.Control_9.Value	:= Contactos->Tel_Cel	
Win_1.Control_10.Value	:= Contactos->E_Mail	
Win_1.Control_11.Value	:= Contactos->Fecha_Nac	
Win_1.Control_12.Value	:= Contactos->Observ	
Return Nil

Function BloquearRegistro()
Local RetVal

// La funcion 'MsgExclamation' muestra una venta con un mensaje (primer 
// parametro) un titulo (segundo parametro) un icono de exclamacion y
// el boton aceptar.

Contactos->( dbGoTo ( Win_1.Grid_1.RecNo ) )	

If Contactos->(RLock())
	RetVal := .t.
Else
	MsgExclamation ('El Registro Esta Siendo Editado Por Otro Usuario. Reintente Mas Tarde')
	RetVal := .f.
EndIf
Return RetVal

Function Eliminar
If MsgYesNo ( 'Esta Seguro')

	Win_1.grid_1.Delete

EndIf
Return Nil

Function Buscar
Local nCol:=Win_1.grid_1.Value[2]
Local Buscar := HMG_Upper ( AllTrim ( InputBox( 'Ingrese Apellido a Buscar:' , 'Busqueda' ) ) )

If .Not. Empty(Buscar)
    DBSetOrder(nCol)
	If Contactos->(DbSeek(Buscar))
		Win_1.grid_1.RecNo := Contactos->(RecNo())
	Else
		MsgExclamation('No se encontraron registros')
	EndIf

EndIf
Return Nil

Function Imprimir()
Local RecContactos , RecTipos

// El comando DO REPORT permite generar de una forma muy facil, un
// reporte sin necesidad de definirlo mediante un archivo externo.
// TITLE es el titulo principal del reporte
// La clausula HEADERS requiere dos arrays de caracteres que indican
// Dos lineas de titulo asociadas a cada una de las columnas del reporte.
// La clausula FIELDS, requiere un array de caracteres indicando los campos
// que corresponden a cada columna.
// La clausula WIDTHS requiere un array numerico indicando el ancho (en caracteres)
// de cada columna
// La clausula WORKAREA Indica el area de trabajo 
// LPP indica las lineas por pagina 
// CPL Indica los caracteres por linea
// LMARGIN Indica el margen izquierdo (medido en caracteres)
// PREVIEW Indica que se mostrara una ventana de vista preliminar.

RecContactos := Contactos->(RecNo())
RecTipos := Tipos->(RecNo())

Select Contactos
Set Relation To Cod_Tipo Into Tipos
Go Top

DO REPORT								;
	TITLE 'Contactos'						;
	HEADERS  {'','','','',''} , {'Apellido','Nombres','Calle','Numero','Tipo'};
	FIELDS   {'Contactos->Apellido','Contactos->Nombres','Contactos->Calle','Contactos->Numero','Tipos->Desc'};
	WIDTHS   {10,15,20,7,15} 						;
	TOTALS   {.F.,.F.,.F.,.F.,.F.}					;
	WORKAREA Contactos						;
	LPP 50								;
	CPL 80								;
	LMARGIN 5							;
	PREVIEW							

Select Contactos
Set Relation To

Contactos->(DbGoTo(RecContactos))
Tipos->(DbGoTo(RecTipos))
Return NIl