/*----------------------------------------------------------------------------
 HMG - Harbour Windows GUI library source code

 Copyright 2002-2017 Roberto Lopez <mail.box.hmg@gmail.com>
 http://sites.google.com/site/hmgweb/

 Head of HMG project:

      2002-2012 Roberto Lopez <mail.box.hmg@gmail.com>
      http://sites.google.com/site/hmgweb/

      2012-2017 Dr. Claudio Soto <srvet@adinet.com.uy>
      http://srvet.blogspot.com

 This program is free software; you can redistribute it and/or modify it under 
 the terms of the GNU General Public License as published by the Free Software 
 Foundation; either version 2 of the License, or (at your option) any later 
 version. 

 This program is distributed in the hope that it will be useful, but WITHOUT 
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with 
 this software; see the file COPYING. If not, write to the Free Software 
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or 
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text 
 contained in this release of HMG.

 The exception is that, if you link the HMG library with other 
 files to produce an executable, this does not by itself cause the resulting 
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the 
 HMG library code into it.

 Parts of this project are based upon:

	"Harbour GUI framework for Win32"
 	Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 	Copyright 2001 Antonio Linares <alinares@fivetech.com>
	www - http://www.harbour-project.org

	"Harbour Project"
	Copyright 1999-2003, http://www.harbour-project.org/

	"WHAT32"
	Copyright 2002 AJ Wos <andrwos@aust1.net> 

	"HWGUI"
  	Copyright 2001-2007 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/
#xcommand DRAW LINE IN WINDOW <windowname> AT <frow>,<fcol> ;
             TO <trow>,<tcol> ;
             [PENCOLOR <penrgb>] ;
             [PENWIDTH <pnwidth>];
          =>;
          drawline(<"windowname">,<frow>,<fcol>,<trow>,<tcol>,[<penrgb>],<pnwidth>)

#xcommand DRAW RECTANGLE IN WINDOW <windowname> AT <frow>,<fcol> ;
             TO <trow>,<tcol> ;
             [PENCOLOR <penrgb>] ;
             [PENWIDTH <pnwidth>];
             [FILLCOLOR <fillrgb>];
          =>;
          drawrect(<"windowname">,<frow>,<fcol>,<trow>,<tcol>,[<penrgb>],<pnwidth>,[<fillrgb>])

#xcommand DRAW ROUNDRECTANGLE IN WINDOW <windowname> AT <frow>,<fcol> ;
             TO <trow>,<tcol> ;
             ROUNDWIDTH <width>;
             ROUNDHEIGHT <height>;
             [PENCOLOR <penrgb>] ;
             [PENWIDTH <pnwidth>];
             [FILLCOLOR <fillrgb>];
          =>;
          drawroundrect(<"windowname">,<frow>,<fcol>,<trow>,<tcol>,<width>,<height>,[<penrgb>],<pnwidth>,[<fillrgb>])
        
#xcommand DRAW ELLIPSE IN WINDOW <windowname> AT <frow>,<fcol> ;
             TO <trow>,<tcol> ;
             [PENCOLOR <penrgb>] ;
             [PENWIDTH <pnwidth>];
             [FILLCOLOR <fillrgb>];
          =>;
          drawellipse(<"windowname">,<frow>,<fcol>,<trow>,<tcol>,[<penrgb>],<pnwidth>,[<fillrgb>])

#xcommand DRAW ARC IN WINDOW <windowname> AT <frow>,<fcol> ;
             TO <trow>,<tcol> ;
             FROM RADIAL <rrow>, <rcol>;
             TO RADIAL <rrow1>, <rcol1>;
             [PENCOLOR <penrgb>] ;
             [PENWIDTH <pnwidth>];
          =>;
          drawarc(<"windowname">,<frow>,<fcol>,<trow>,<tcol>,<rrow>,<rcol>,<rrow1>,<rcol1>,[<penrgb>],<pnwidth>)

#xcommand DRAW PIE IN WINDOW <windowname> AT <frow>,<fcol> ;
             TO <trow>,<tcol> ;
             FROM RADIAL <rrow>, <rcol>;
             TO RADIAL <rrow1>, <rcol1>;
             [PENCOLOR <penrgb>] ;
             [PENWIDTH <pnwidth>];
             [FILLCOLOR <fillrgb>];
          =>;
          drawpie(<"windowname">,<frow>,<fcol>,<trow>,<tcol>,<rrow>,<rcol>,<rrow1>,<rcol1>,[<penrgb>],<pnwidth>,[<fillrgb>])
          
// Points should be in the format {{row1,col1},{row2,col2},{row3,col3},{row4,col4}.....}                
#xcommand DRAW POLYGON IN WINDOW <windowname> ;
            POINTS <pointsarr> ;
            [PENCOLOR <penrgb>] ;
            [PENWIDTH <penwidth>] ;
            [FILLCOLOR <fillrgb>] ;
         =>;
         drawpolygon(<"windowname">,[<pointsarr>],[<penrgb>],<penwidth>,[<fillrgb>])          

#xcommand DRAW POLYBEZIER IN WINDOW <windowname> ;
            POINTS <pointsarr> ;
            [PENCOLOR <penrgb>] ;
            [PENWIDTH <penwidth>] ;
         =>;
         drawpolybezier(<"windowname">,[<pointsarr>],[<penrgb>],<penwidth>)          

#xcommand ERASE WINDOW <windowname> => erasewindow(<"windowname">)


#xcommand DEFAULT <uVar1> := <uVal1> ;
               [, <uVarN> := <uValN> ] => ;
                  <uVar1> := IIf( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
                [ <uVarN> := IIf( <uVarN> == nil, <uValN>, <uVarN> ); ]

#xtranslate RGB( <nRed>, <nGreen>, <nBlue> ) => ;
              ( <nRed> + ( <nGreen> * 256 ) + ( <nBlue> * 65536 ) )

#xcommand DRAW GRAPH IN WINDOW <window> ;
      AT <nT>,<nL> ;
      TO <nB>,<nR>	;
      TITLE <cTitle>	;
      TYPE PIE ;
      SERIES <aSer> ;
      DEPTH <nD> ;
      SERIENAMES <aName>	;
      COLORS <aColor>			;
		[ <l3D : 3DVIEW> ]		;
		[ <lxVal : SHOWXVALUES> ]	; 
		[ <lSLeg : SHOWLEGENDS> ]	; 
		[ <lNoborder : NOBORDER> ]	; 
      => ;
		DrawPieGraph(<"window">,;
		<nT>,;
		<nL>,;
		<nB>,;
		<nR>,;
		<aSer>,;
		<aName>,;
		<aColor>,;
		<cTitle>,;
		<nD>,;
		<.l3D.>,;
		<.lxVal.>,;
		<.lSLeg.> , <.lNoborder.> )

#define BARS      1
#define LINES     2
#define POINTS    3

#xcommand DRAW GRAPH				;
		IN WINDOW <window>		;
		AT <nT>,<nL>			;
		[ TO <nB>,<nR> ]		;
		[ TITLE <cTitle> ]		;
		TYPE <nType>			;
		SERIES <aSer>			;
		YVALUES <aYVal>		;
		DEPTH <nD>			;
		[ BARWIDTH <nW> ]		;
		HVALUES <nRange>		;
		SERIENAMES <aName>		;
		COLORS <aColor>		;
		[ <l3D : 3DVIEW> ]		;
		[ <lGrid : SHOWGRID> ]	; 
		[ <lxVal : SHOWXVALUES> ]	; 
		[ <lyVal : SHOWYVALUES> ]	; 
		[ <lSLeg : SHOWLEGENDS> ]	; 
		[ LEGENDSWIDTH <nLegendWindth> ] ;
		[ <lNoborder : NOBORDER> ]	; 
=> ;
		GraphShow(<"window">,	;
		<nT>,				;
		<nL>,				;
		<nB>,				;
		<nR>,				;
		Nil,				;
		Nil,				;
		<aSer>,			;
		<cTitle>,			;
		<aYVal>,			;
		<nD>,				;
		<nW>,;
		Nil,			;
		<nRange>,			;
		<.l3D.>,			;
		<.lGrid.>,			;
		.f.,			;
		.f.,			;
		<.lxVal.>,			;
		<.lyVal.>,			;
		<.lSLeg.>,			;
		<aName>,			;
		<aColor>,			;
		<nType>,			;
		.f.,			;
		Nil , <nLegendWindth> , <.lNoborder.> )

#xtranslate PRINT GRAPH [ OF ] <windowname> ;
	[ <lpreview : PREVIEW> ] ;
	[ <ldialog : DIALOG> ] ;
	=>;
	printgraph ( <"windowname"> , <.lpreview.> , <.ldialog.> )



#xtranslate GRAPH BITMAP PIE ;
               SIZE        <nWidth>, <nHeight> ;
               SERIEVALUES <aSerieValues> ;
               SERIENAMES  <aSerieNames> ;
               SERIECOLORS <aSerieColors> ;
               TITLE       <cTitle> ;
               TITLECOLOR  <aTitleColor>;
               DEPTH       <nDepth> ;
               3DVIEW      <l3DView> ;
               SHOWXVALUES <lShowXValues> ; 
               SHOWLEGENDS <lShowLegends> ; 
               NOBORDER    <lNoBorder> ;
               STOREIN     <hBitmapVar> ;
   => ;
   <hBitmapVar> := HMG_PieGraph( <nWidth>, <nHeight>, <aSerieValues>, <aSerieNames>, <aSerieColors>, <cTitle>, <aTitleColor>, <nDepth>, <l3DView>, <lShowXValues>, <lShowLegends>, <lNoBorder> )



#xtranslate GRAPH BITMAP <nGraphType> ; // constants BARS | LINES | POINTS
               SIZE        <nWidth>, <nHeight> ;
               SERIEVALUES <aSerieValues> ;
               SERIENAMES  <aSerieNames> ;
               SERIECOLORS <aSerieColors> ;
               SERIEYNAMES <aSerieYNames> ;
               PICTURE     <cPicture> ;
               TITLE       <cTitle> ;
               TITLECOLOR  <aTitleColor> ;
               HVALUES     <nHValues> ;
               BARDEPTH    <nBarDepth> ; 
               BARWIDTH    <nBarWidth> ;
               SEPARATION  <nSeparation> ;
               LEGENDWIDTH <nLegendWindth> ;
               3DVIEW      <l3DView> ;
               SHOWGRID    <lShowGrid> ;
               SHOWXGRID   <lShowXGrid> ;
               SHOWYGRID   <lShowYGrid> ;
               SHOWVALUES  <lShowValues> ;
               SHOWXVALUES <lShowXValues> ;
               SHOWYVALUES <lShowYValues> ;
               SHOWLEGENDS <lShowLegends> ;
               NOBORDER    <lNoBorder> ;
               STOREIN     <hBitmapVar> ;
   => ;
   <hBitmapVar> := HMG_Graph( <nWidth>, <nHeight>, <aSerieValues>, <cTitle>, <aSerieYNames>, <nBarDepth>, <nBarWidth>, <nSeparation>, <aTitleColor>,; 
                              <nHValues>, <l3DView>, <lShowGrid>, <lShowXGrid>, <lShowYGrid>, <lShowXValues>, <lShowYValues>, <lShowLegends>,; 
                              <aSerieNames>, <aSerieColors>, <nGraphType>, <lShowValues>, <cPicture>, <nLegendWindth> ,<lNoBorder> )
