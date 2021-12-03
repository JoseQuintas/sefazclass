
#xcommand PRINT GRID <cGridName> ;
   OF <cParentName> ;
	[ FONT <cFontName> ]   ;
	[ SIZE <nFontSize> ]   ;
	[ ORIENTATION <cOrientation> ] ;
	[ HEADERS <aHeaders> ] ;
	[ <showwindow : SHOWWINDOW> ] ;
	[ MERGEHEADERS <aMergeHeaders> ] ;
	[ COLUMNSUM <aColumnSum> ] ;
    [ WIDTHS <aColumnWidths> ];
    [ PAPERSIZE <nPaperSize>];
    [ PAPERWIDTH <nPaperWidth>];
    [ PAPERHEIGHT <nPaperHeight>];
	[ <verticallines : VERTICALLINES> ] ;
	[ <horizontallines : HORIZONTALLINES> ] ;
    [ LEFT <nLeft>];
    [ TOP <nTop>];
    [ RIGHT <nRight>];
    [ BOTTOM <nBottom>];
	=> ;
_GridPrint(<"cGridName">,<"cParentName">,<nFontSize>,<cOrientation>,<aHeaders>,<cFontName>,<.showwindow.>,<aMergeHeaders>,<aColumnSum>,{},{},{},<aColumnWidths>,<nPaperSize>,<nPaperWidth>,<nPaperHeight>,<.verticallines.>,<.horizontallines.>,<nLeft>,<nTop>,<nRight>,<nBottom>)

#xcommand PRINT ARRAY <aArrayData> ;
	[ FONT <cFontName> ]   ;
	[ SIZE <nFontSize> ]   ;
	[ ORIENTATION <cOrientation> ] ;
	[ HEADERS <aHeaders> ] ;
	[ <showwindow : SHOWWINDOW> ] ;
	[ MERGEHEADERS <aMergeHeaders> ] ;
	[ COLUMNSUM <aColumnSum> ] ;
	[ ARRAYHEADERS <aArrayHeaders>];
	[ ARRAYJUSTIFY <aArrayJustify>];
    [ WIDTHS <aColumnWidths> ];
    [ PAPERSIZE <nPaperSize>];
    [ PAPERWIDTH <nPaperWidth>];
    [ PAPERHEIGHT <nPaperHeight>];
	[ <verticallines : VERTICALLINES> ] ;
	[ <horizontallines : HORIZONTALLINES> ] ;
    [ LEFT <nLeft>];
    [ TOP <nTop>];
    [ RIGHT <nRight>];
    [ BOTTOM <nBottom>];
	=> ;
_GridPrint('','',<nFontSize>,<cOrientation>,<aHeaders>,<cFontName>,<.showwindow.>,<aMergeHeaders>,<aColumnSum>,<aArrayData>,<aArrayHeaders>,<aArrayJustify>,<aColumnWidths>,<nPaperSize>,<nPaperWidth>,<nPaperHeight>,<.verticallines.>,<.horizontallines.>,<nLeft>,<nTop>,<nRight>,<nBottom>)
	