/*
 *
 * HMG Hyperlink Demo
 * Copyright 2005 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
 *
*/

#include "hmg.ch"

Function Main


	DEFINE WINDOW Main_form ;
		AT 0,0 ;
		WIDTH 397 ;
		HEIGHT 168 ;
		TITLE 'HyperLink Demo' ;
		MAIN NOSIZE 

		DEFINE HYPERLINK H1
			ROW		10
			COL		10
			VALUE		'http://www.hmgforum.com/' 
			FONTNAME	'Arial' 
			FONTSIZE	9 
			AUTOSIZE	.T. 
			ADDRESS		'http://www.hmgforum.com/'
			HANDCURSOR	.T.
		END HYPERLINK

		DEFINE HYPERLINK H2
			ROW		40
			COL		10
			VALUE		'mail.box.hmg@gmail.com' 
			FONTNAME	'Arial' 
			FONTSIZE	9 
			AUTOSIZE	.T. 
			ADDRESS		'mail.box.hmg@gmail.com'
			HANDCURSOR	.T.
		END HYPERLINK

           END WINDOW

	CENTER WINDOW Main_form

	ACTIVATE WINDOW Main_form

Return


