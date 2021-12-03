#include <hmg.ch>


Function Main
Local aItems := {}

	aadd ( aItems , { 4 , 'Item 01' } )
	aadd ( aItems , { 2 , 'Item 02' } )
	aadd ( aItems , { 5 , 'Item 03' } )
	aadd ( aItems , { 1 , 'Item 04' } )
	aadd ( aItems , { 3 , 'Item 05' } )
	aadd ( aItems , { 7 , 'Item 06' } )

	Load Window Main
	Center Window Main
	Activate Window Main

Return
