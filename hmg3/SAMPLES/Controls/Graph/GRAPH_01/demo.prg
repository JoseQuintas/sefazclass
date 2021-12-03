#include "hmg.ch"

function main

	define window x at 0,0 ;
		width 800 ;
		height 600 ;
		title "Shapes Demo" ;
		main on init drawshapes()

	end window

	x.center

	x.activate

return nil

function drawshapes
msginfo("Lines")
// Line
for i := 1 to 5
   draw line in window x at 40+(i*6),50 to 40+(i*6),200 pencolor {random(255),random(255),random(255)} penwidth i
next i
msginfo("Rectangle")
// Rectangle
draw rectangle in window x at 100,50 to 150,200 pencolor {random(255),random(255),random(255)} penwidth 2 fillcolor {random(255),random(255),random(255)}
msginfo("RoundRectangle")
// Roundrectangle
draw roundrectangle in window x at 180,50 to 230,200 roundwidth 15 roundheight 15 pencolor {random(255),random(255),random(255)} penwidth 2 fillcolor {random(255),random(255),random(255)}
msginfo("Ellipse")
// Ellipse
draw ellipse in window x at 40,300 to 140,400 pencolor {random(255),random(255),random(255)} penwidth 2 fillcolor {random(255),random(255),random(255)}
msginfo("Arc")
// Arc
draw arc in window x at 160,300 to 260,400 from radial 180,350 to radial 200,400 pencolor {random(255),random(255),random(255)} penwidth 5
msginfo("Pie")
// Pie
draw pie in window x at 160,500 to 260,600 from radial 180,550 to radial 200,500 pencolor {random(255),random(255),random(255)} penwidth 2 fillcolor {random(255),random(255),random(255)}
msginfo("Polygon")
// Polygon
draw polygon in window x points {{400,100},{350,50},{300,200},{350,275},{400,340},{500,250},{400,50}} pencolor {random(255),random(255),random(255)} penwidth 2 fillcolor {random(255),random(255),random(255)}
msginfo("Polybezier")
// Polybezier
draw polybezier in window x points {{400,400},{350,350},{300,500},{350,575},{400,640},{500,550},{400,350}} pencolor {random(255),random(255),random(255)} penwidth 2 
return nil
