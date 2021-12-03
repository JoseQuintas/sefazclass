#include 'hmg.ch'

procedure main()

	SET LANGUAGE TO SPANISH

	define window pr_form ;
		at 0,0 ;
		width 100;
		height 100 ;
		title 'DO REPORT Test' ;
		main 

		DEFINE MAIN MENU
			POPUP 'File'
				ITEM 'Do Report Test' ACTION printtest()
			END POPUP
		END MENU

	end window

	activate window pr_form

Return Nil

function printtest()
use test
index on first to lista
****
set date ansi
set century on

	DO REPORT ;
		TITLE		'INFORME DE ARTISTAS DE CINE | segundo titulo'			;
		HEADERS		{'','','',''} , {'SIMPLE','APELLIDO','DOBLE','INGRESOS'}	;
		FIELDS		{'code','last','BIO','incoming'}				;
		WIDTHS		{10,20,25,14}							;
		TOTALS		{.F.,.F.,.F.,.T.}						;
		NFORMATS	{'','','','999,999,999.99'}					;
		WORKAREA	Test								;
		LPP		50								;
		CPL		80								;
		LMARGIN		2								;
		PAPERSIZE	DMPAPER_A4							;
		PREVIEW										; 
		SELECT										;
		MULTIPLE									;
		GROUPED BY	'first'								;
		HEADRGRP	'Name'	

    
Return Nil


