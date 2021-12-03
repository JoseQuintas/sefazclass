#include "hmg.ch"
function main
define window x at 0,0 width 640 height 480 title "Shapes" main

	DEFINE MAIN MENU
		DEFINE POPUP 'File'
			MENUITEM 'Erase All' ACTION EraseAll()
		END POPUP
	END MENU

   define splitbox horizontal
   define window y width 640 height 200 splitchild

	DEFINE TEXTBOX TEXT_1
		ROW 10
		COL 10
	END TEXTBOX

   end window
   define window z width 640 height 150 splitchild
   define tab shapes at 10,10 width 600 height 200
      define page "Line"
         define label fromlinerowlabel
            row 60
            col 50
            value "From Row"
            width 90
         end label
         define textbox linerow1
            row 60
            col 150
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label fromlinecollabel
            row 60
            col 210
            value "Col"
            width 90
         end label
         define textbox linecol1
            row 60
            col 310
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label tolinerowlabel
            row 90
            col 50
            value "TO Row"
            width 90
         end label
         define textbox linerow2
            row 90
            col 150
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label tolinecollabel
            row 90
            col 210
            value "Col"
            width 90
         end label
         define textbox linecol2
            row 90
            col 310
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define button line1
            row 90
            col 410
            caption "Draw"
            action drawline1()
         end button
      end page
      define page "Rectangle"
         define label fromrectrowlabel
            row 60
            col 50
            value "From Row"
            width 90
         end label
         define textbox rectrow1
            row 60
            col 150
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label fromrectcollabel
            row 60
            col 210
            value "Col"
            width 90
         end label
         define textbox rectcol1
            row 60
            col 310
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label torectrowlabel
            row 90
            col 50
            value "TO Row"
            width 90
         end label
         define textbox rectrow2
            row 90
            col 150
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label torectcollabel
            row 90
            col 210
            value "Col"
            width 90
         end label
         define textbox rectcol2
            row 90
            col 310
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define button rect1
            row 90
            col 410
            caption "Draw"
            action drawrect1()
         end button
      end page
      define page "Rounded Rectangle"
         define label fromroundrectrowlabel
            row 60
            col 50
            value "From Row"
            width 90
         end label
         define textbox roundrectrow1
            row 60
            col 150
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label fromroundrectcollabel
            row 60
            col 210
            value "Col"
            width 90
         end label
         define textbox roundrectcol1
            row 60
            col 310
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label roundrectwidthlabel
            row 60
            col 410
            value "Width"
            width 60
         end label
         define textbox roundrectwidth
            row 60
            col 470
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label toroundrectrowlabel
            row 90
            col 50
            value "TO Row"
            width 90
         end label
         define textbox roundrectrow2
            row 90
            col 150
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label toroundrectcollabel
            row 90
            col 210
            value "Col"
            width 90
         end label
         define textbox roundrectcol2
            row 90
            col 310
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label roundrectheightlabel
            row 90
            col 410
            value "Height"
            width 60
         end label
         define textbox roundrectheight
            row 90
            col 470
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define button roundrect1
            row 140
            col 350
            caption "Draw"
            action drawroundrect1()
         end button
      end page
      define page "Ellipse"
         define label fromellipserowlabel
            row 60
            col 50
            value "From Row"
            width 90
         end label
         define textbox ellipserow1
            row 60
            col 150
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label fromellipsecollabel
            row 60
            col 210
            value "Col"
            width 90
         end label
         define textbox ellipsecol1
            row 60
            col 310
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label toellipserowlabel
            row 90
            col 50
            value "TO Row"
            width 90
         end label
         define textbox ellipserow2
            row 90
            col 150
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label toellipsecollabel
            row 90
            col 210
            value "Col"
            width 90
         end label
         define textbox ellipsecol2
            row 90
            col 310
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define button ellipse1
            row 90
            col 410
            caption "Draw"
            action drawellipse1()
         end button
      end page
      define page "Arc"
         define label fromarcrowlabel
            row 60
            col 50
            value "From Row"
            width 90
         end label
         define textbox arcrow1
            row 60
            col 150
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label fromarccollabel
            row 60
            col 210
            value "Col"
            width 90
         end label
         define textbox arccol1
            row 60
            col 310
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label toarcrowlabel
            row 90
            col 50
            value "TO Row"
            width 90
         end label
         define textbox arcrow2
            row 90
            col 150
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label toarccollabel
            row 90
            col 210
            value "Col"
            width 90
         end label
         define textbox arccol2
            row 90
            col 310
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label fromarcrrowlabel
            row 120
            col 50
            value "From Radial"
            width 90
         end label
         define textbox arcrow3
            row 120
            col 150
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label fromarcrcollabel
            row 120
            col 210
            value "Col"
            width 90
         end label
         define textbox arccol3
            row 120
            col 310
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label toarcrrowlabel
            row 150
            col 50
            value "TO Radial"
            width 90
         end label
         define textbox arcrow4
            row 150
            col 150
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label toarcrcollabel
            row 150
            col 210
            value "Col"
            width 90
         end label
         define textbox arccol4
            row 150
            col 310
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define button arc1
            row 150
            col 410
            caption "Draw"
            action drawarc1()
         end button
      end page
      define page "Pie"
         define label frompierowlabel
            row 60
            col 50
            value "From Row"
            width 90
         end label
         define textbox pierow1
            row 60
            col 150
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label frompiecollabel
            row 60
            col 210
            value "Col"
            width 90
         end label
         define textbox piecol1
            row 60
            col 310
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label topierowlabel
            row 90
            col 50
            value "TO Row"
            width 90
         end label
         define textbox pierow2
            row 90
            col 150
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label topiecollabel
            row 90
            col 210
            value "Col"
            width 90
         end label
         define textbox piecol2
            row 90
            col 310
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label frompierrowlabel
            row 120
            col 50
            value "From Radial"
            width 90
         end label
         define textbox pierow3
            row 120
            col 150
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label frompiercollabel
            row 120
            col 210
            value "Col"
            width 90
         end label
         define textbox piecol3
            row 120
            col 310
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label topierrowlabel
            row 150
            col 50
            value "TO Radial"
            width 90
         end label
         define textbox pierow4
            row 150
            col 150
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define label topiercollabel
            row 150
            col 210
            value "Col"
            width 90
         end label
         define textbox piecol4
            row 150
            col 310
            value 50
            width 50
            numeric .t.
            rightalign .t.
         end textbox
         define button pie1
            row 150
            col 410
            caption "Draw"
            action drawpie1()
         end button
      end page   
      define page "Colours"
         define label pencolorlabel
            row 60
            col 30
            value "Pen Color"
         end label
         define label penrlabel
            row 60
            col 100 
            value "Red"
            width 50
         end label   
         define textbox penr
            row 60
            col 160
            value 0
            numeric .t.
            rightalign .t.
            width 40
         end textbox
         define label penglabel
            row 60
            col 200 
            value "Green"
            width 50
         end label   
         define textbox peng
            row 60
            col 260
            value 0
            numeric .t.
            rightalign .t.
            width 40
         end textbox
         define label penblabel
            row 60
            col 300 
            value "Blue"
            width 50
         end label   
         define textbox penb
            row 60
            col 360
            value 0
            numeric .t.
            rightalign .t.
            width 40
         end textbox
         define label penwidthlabel
            row 60
            col 400
            value "Width"
            width 50
         end label
         define textbox penwidth
            row 60
            col 460
            value 5
            numeric .t.
            rightalign .t.
            width 40
         end textbox
         define label fillcolorlabel
            row 90
            col 30
            value "Fill Color"
         end label
         define label fillrlabel
            row 90
            col 100 
            value "Red"
            width 50
         end label   
         define textbox fillr
            row 90
            col 160
            value 255
            numeric .t.
            rightalign .t.
            width 40
         end textbox
         define label fillglabel
            row 90
            col 200 
            value "Green"
            width 50
         end label   
         define textbox fillg
            row 90
            col 260
            value 255
            numeric .t.
            rightalign .t.
            width 40
         end textbox
         define label fillblabel
            row 90
            col 300 
            value "Blue"
            width 50
         end label   
         define textbox fillb
            row 90
            col 360
            value 0
            numeric .t.
            rightalign .t.
            width 40
         end textbox
      end page
   end tab
   end window
   end splitbox
end window
x.center
x.activate
return nil

function drawline1
draw line in window y at z.linerow1.value,z.linecol1.value to z.linerow2.value,z.linecol2.value pencolor {z.penr.value,z.peng.value,z.penb.value} penwidth z.penwidth.value
return nil

function drawrect1
draw rectangle in window y at z.rectrow1.value,z.rectcol1.value to z.rectrow2.value,z.rectcol2.value pencolor {z.penr.value,z.peng.value,z.penb.value} penwidth z.penwidth.value fillcolor {z.fillr.value,z.fillg.value,z.fillb.value}
return nil

function drawroundrect1
draw roundrectangle in window y at z.roundrectrow1.value,z.roundrectcol1.value to z.roundrectrow2.value,z.roundrectcol2.value roundwidth z.roundrectwidth.value roundheight z.roundrectheight.value pencolor {z.penr.value,z.peng.value,z.penb.value} penwidth z.penwidth.value fillcolor {z.fillr.value,z.fillg.value,z.fillb.value}
return nil

function drawellipse1
draw ellipse in window y at z.ellipserow1.value,z.ellipsecol1.value to z.ellipserow2.value,z.ellipsecol2.value pencolor {z.penr.value,z.peng.value,z.penb.value} penwidth z.penwidth.value fillcolor {z.fillr.value,z.fillg.value,z.fillb.value}
return nil

function drawarc1
draw arc in window y at z.arcrow1.value,z.arccol1.value to z.arcrow2.value,z.arccol2.value from radial z.arcrow3.value,z.arccol3.value to radial z.arcrow4.value,z.arccol4.value pencolor {z.penr.value,z.peng.value,z.penb.value} penwidth z.penwidth.value 
return nil

function drawpie1
draw pie in window y at z.pierow1.value,z.piecol1.value to z.pierow2.value,z.piecol2.value from radial z.pierow3.value,z.piecol3.value to radial z.pierow4.value,z.piecol4.value pencolor {z.penr.value,z.peng.value,z.penb.value} penwidth z.penwidth.value fillcolor {z.fillr.value,z.fillg.value,z.fillb.value}
return nil

Function EraseAll()

	ERASE WINDOW Y

Return Nil