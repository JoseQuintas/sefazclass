MEMVAR _HMG_SYSDATA
# include "hmg.ch"

MEMVAR msgarr
MEMVAR fontname
MEMVAR fontsizesstr
MEMVAR headerarr
MEMVAR curpagesize
MEMVAR sizes
MEMVAR headersizes
MEMVAR selectedprinter
MEMVAR columnarr
MEMVAR fontnumber
MEMVAR windowname
MEMVAR lines
MEMVAR cPrintdata
MEMVAR linedata
MEMVAR gridname
MEMVAR ajustifiy
MEMVAR psuccess
MEMVAR showwindow
MEMVAR aColWidths
MEMVAR aprinternames
MEMVAR defaultprinter
MEMVAR lVertLines
MEMVAR lHorLines
MEMVAR nTopMargin
MEMVAR nBottomMargin
MEMVAR nLeftMargin
MEMVAR nRightMargin
MEMVAR papernames
MEMVAR papersizes
MEMVAR printerno
MEMVAR header1
MEMVAR header2
MEMVAR header3
MEMVAR aEditcontrols
MEMVAR xres
MEMVAR maxcol2
MEMVAR curcol1
MEMVAR _asum
MEMVAR mergehead
MEMVAR sumarr
MEMVAR totalarr
MEMVAR spread
MEMVAR aData
MEMVAR lArrayMode
MEMVAR nCustomPaperWidth
MEMVAR nCustomPaperHeight


#define USR_COMP_PROC_FLAG	63
 
*------------------------------------------------------------------------------*
Init Procedure _InitPrintGrid
*------------------------------------------------------------------------------*

	InstallMethodHandler ( 'Print' , 'MyGridPrint' )

Return

*------------------------------------------------------------------------------*
Procedure MyGridPrint (  cWindowName , cControlName , MethodName )
*------------------------------------------------------------------------------*
   
   MethodName := NIL // declared but not used

	If GetControlType ( cControlName , cWindowName ) == 'GRID'

		_gridprint( cControlName , cWindowName)

		_HMG_SYSDATA [USR_COMP_PROC_FLAG] := .T.

	else

		_HMG_SYSDATA [USR_COMP_PROC_FLAG] := .F.

	endif

Return

DECLARE window printgrid

function _gridprint(cGrid,cWindow,fontsize,orientation,aHeaders,fontname1,showwindow1,mheaders,summation,aArrayData,aArrayHeaders,aArrayJustify,aColumnWidths,nPaperSize,nPaperWidth,nPaperHeight,lVerticalLines,lHorizontalLines,nLeft,nTop,nRight,nBottom)
local count1 := 0
local count2 := 0
local maxcol1 := 0
local i := 0
local nDecimals := Set( _SET_DECIMALS)
local aec := ""
local aitems := {}
private msgarr := {}
private fontname := ""
PRIVATE fontsizesstr := {}
PRIVATE headerarr := {}
private curpagesize := 0
PRIVATE sizes := {}
private headersizes := {}
PRIVATE selectedprinter := ""
PRIVATE columnarr := {}
PRIVATE fontnumber := 0
PRIVATE windowname := ""
private lines := 0
private cPrintdata := {}
private linedata := {}
PRIVATE gridname := ""
PRIVATE ajustifiy := {}
PRIVATE psuccess := .f.
PRIVATE showwindow := .f.
PRIVATE aColWidths := {}
PRIVATE aprinternames := aprinters()
PRIVATE defaultprinter := GetDefaultPrinter()
private lVertLines := .f.
private lHorLines := .f.
private nTopMargin := 0.0
private nBottomMargin := 0.0
private nLeftMargin := 0.0
private nRightMargin := 0.0 
private papernames := {;
   "Letter 8 1/2 x 11 in",;               
   "Letter Small 8 1/2 x 11 in",;         
   "Tabloid 11 x 17 in",;                 
   "Ledger 17 x 11 in",;                  
   "Legal 8 1/2 x 14 in",;                
   "Statement 5 1/2 x 8 1/2 in",;         
   "Executive 7 1/4 x 10 1/2 in",;      
   "A3 297 x 420 mm",;                    
   "A4 210 x 297 mm",;                    
   "A4 Small 210 x 297 mm",;              
   "A5 148 x 210 mm",;                    
   "B4 (JIS) 250 x 354",;
   "B5 (JIS) 182 x 257 mm",;              
   "Folio 8 1/2 x 13 in",;                
   "Quarto 215 x 275 mm",;                
   "10x14 in",;                           
   "11x17 in",;                           
   "Note 8 1/2 x 11 in",;                 
   "Envelope #9 3 7/8 x 8 7/8",;          
   "Envelope #10 4 1/8 x 9 1/2",;         
   "Envelope #11 4 1/2 x 10 3/8",;        
   "Envelope #12 4 \276 x 11",;           
   "Envelope #14 5 x 11 1/2",;            
   "C size sheet",;                       
   "D size sheet",;                       
   "E size sheet",;                       
   "Envelope DL 110 x 220mm",;            
   "Envelope C5 162 x 229 mm",;           
   "Envelope C3  324 x 458 mm",;          
   "Envelope C4  229 x 324 mm",;          
   "Envelope C6  114 x 162 mm",;          
   "Envelope C65 114 x 229 mm",;          
   "Envelope B4  250 x 353 mm",;          
   "Envelope B5  176 x 250 mm",;          
   "Envelope B6  176 x 125 mm",;          
   "Envelope 110 x 230 mm",;              
   "Envelope Monarch 3.875 x 7.5 in",;    
   "6 3/4 Envelope 3 5/8 x 6 1/2 in",;    
   "US Std Fanfold 14 7/8 x 11 in",;      
   "German Std Fanfold 8 1/2 x 12 in",;
   "German Legal Fanfold 8 1/2 x 13 in",; 
   "B4 (ISO) 250 x 353 mm",;              
   "Japanese Postcard 100 x 148 mm",;     
   "9 x 11 in",;                          
   "10 x 11 in",;                         
   "15 x 11 in",;                         
   "Envelope Invite 220 x 220 mm",;       
   "RESERVED--DO NOT USE",;               
   "RESERVED--DO NOT USE",;               
   "Letter Extra 9 \275 x 12 in",;        
   "Legal Extra 9 \275 x 15 in",;         
   "Tabloid Extra 11.69 x 18 in",;        
   "A4 Extra 9.27 x 12.69 in",;           
   "Letter Transverse 8 \275 x 11 in",;   
   "A4 Transverse 210 x 297 mm",;         
   "Letter Extra Transverse 9\275 x 12 in",; 
   "SuperA/SuperA/A4 227 x 356 mm",;      
   "SuperB/SuperB/A3 305 x 487 mm",;      
   "Letter Plus 8.5 x 12.69 in",;         
   "A4 Plus 210 x 330 mm",;               
   "A5 Transverse 148 x 210 mm",;         
   "B5 (JIS) Transverse 182 x 257 mm",;   
   "A3 Extra 322 x 445 mm",;              
   "A5 Extra 174 x 235 mm",;              
   "B5 (ISO) Extra 201 x 276 mm",;        
   "A2 420 x 594 mm",;                    
   "A3 Transverse 297 x 420 mm",;         
   "A3 Extra Transverse 322 x 445 mm",;   
   "Japanese Double Postcard 200 x 148 mm",; 
   "A6 105 x 148 mm",;                 
   "Japanese Envelope Kaku #2",;       
   "Japanese Envelope Kaku #3",;       
   "Japanese Envelope Chou #3",;       
   "Japanese Envelope Chou #4",;       
   "Letter Rotated 11 x 8 1/2 11 in",; 
   "A3 Rotated 420 x 297 mm",;         
   "A4 Rotated 297 x 210 mm",;         
   "A5 Rotated 210 x 148 mm",;         
   "B4 (JIS) Rotated 364 x 257 mm",;   
   "B5 (JIS) Rotated 257 x 182 mm",;   
   "Japanese Postcard Rotated 148 x 100 mm",; 
   "Double Japanese Postcard Rotated 148 x 200 mm",; 
   "A6 Rotated 148 x 105 mm",;         
   "Japanese Envelope Kaku #2 Rotated",; 
   "Japanese Envelope Kaku #3 Rotated",; 
   "Japanese Envelope Chou #3 Rotated",; 
   "Japanese Envelope Chou #4 Rotated",; 
   "B6 (JIS) 128 x 182 mm",;           
   "B6 (JIS) Rotated 182 x 128 mm",;   
   "12 x 11 in",;                      
   "Japanese Envelope You #4",;        
   "Japanese Envelope You #4 Rotated",;
   "PRC 16K 146 x 215 mm",;            
   "PRC 32K 97 x 151 mm",;             
   "PRC 32K(Big) 97 x 151 mm",;        
   "PRC Envelope #1 102 x 165 mm",;    
   "PRC Envelope #2 102 x 176 mm",;    
   "PRC Envelope #3 125 x 176 mm",;    
   "PRC Envelope #4 110 x 208 mm",;    
   "PRC Envelope #5 110 x 220 mm",;    
   "PRC Envelope #6 120 x 230 mm",;    
   "PRC Envelope #7 160 x 230 mm",;    
   "PRC Envelope #8 120 x 309 mm",;    
   "PRC Envelope #9 229 x 324 mm",;    
   "PRC Envelope #10 324 x 458 mm",;   
   "PRC 16K Rotated",;                 
   "PRC 32K Rotated",;                 
   "PRC 32K(Big) Rotated",;            
   "PRC Envelope #1 Rotated 165 x 102 mm",; 
   "PRC Envelope #2 Rotated 176 x 102 mm",; 
   "PRC Envelope #3 Rotated 176 x 125 mm",; 
   "PRC Envelope #4 Rotated 208 x 110 mm",; 
   "PRC Envelope #5 Rotated 220 x 110 mm",; 
   "PRC Envelope #6 Rotated 230 x 120 mm",; 
   "PRC Envelope #7 Rotated 230 x 160 mm",; 
   "PRC Envelope #8 Rotated 309 x 120 mm",; 
   "PRC Envelope #9 Rotated 324 x 229 mm",; 
   "PRC Envelope #10 Rotated 458 x 324 mm",; 
   "User Defined",;
}
private papersizes := {{216,279},{216,355.6},{184.1,266.7},{297,420},{210,297},{216,279}}
PRIVATE printerno := 0
PRIVATE header1 := ""
PRIVATE header2 := ""
PRIVATE header3 := ""
private aEditcontrols := {}
private xres := {}
private maxcol2 := 0.0
private curcol1 := 0.0
private _asum := {}
private mergehead := {}
private sumarr := {}
private totalarr := {}
private spread := .f.
private aData := {}
private lArrayMode := .f.
private nCustomPaperWidth := 0.0
private nCustomPaperHeight := 0.0
default cWindow := ""
default cGrid := ""
DEFAULT fontsize := 12
DEFAULT orientation := "P"
default fontname1 := "Arial"
default aheaders := {"","",""}
DEFAULT ShowWindow1 := .f.
default mheaders := {}
default summation := {}
default aArrayData := {}
default aArrayHeaders := {}
default aArrayJustify := {}
default aColumnWidths := {}
default nPaperSize := 0
default nPaperWidth := 0.0
default nPaperHeight := 0.0
default nTop := 20.0
default nBottom := 20.0
default nLeft := 20.0
default nRight := 20.0
default lVerticalLines := .t.
default lHorizontalLines := .t.

windowname := cWindow
gridname := cGrid
showwindow := showwindow1
aData := aclone(aArrayData)
aDataHeaders := aclone(aArrayHeaders)
aColWidths := aclone(aColumnWidths)
nCustomPaperWidth := nPaperWidth
nCustomPaperHeight := nPaperHeight
lVertLines := lVerticalLines
lHorLines := lHorizontalLines
nTopMargin := nTop
nBottomMargin := nBottom
nLeftMargin := nLeft
nRightMargin := nRight 



do case
   case nPaperSize == 0
      curpagesize := 1
   case nPaperSize == 256 // custom
      curpagesize := 119 //HMG_LEN(papernames)
   otherwise
      curpagesize := nPaperSize
endcase      
init_messages()

do case
   case HMG_LEN(aheaders) == 3
      header1 := aheaders[1]
      header2 := aheaders[2]
      header3 := aheaders[3]
   case HMG_LEN(aheaders) == 2
      header1 := aheaders[1]
      header2 := aheaders[2]
   case HMG_LEN(aheaders) == 1
      header1 := aheaders[1]
endcase
if HMG_LEN(mheaders) > 0 .and. valtype(mheaders) == "A"
   mergehead := mheaders
endif
if HMG_LEN(summation) > 0 .and. valtype(summation) == "A"
   sumarr := summation
endif

fontname := fontname1
if HMG_LEN(aData) > 0 // array
   lines := HMG_LEN(aData)
   lArrayMode := .t.
else // grid
   lines := getproperty(windowname,gridname,"itemcount")
   lArrayMode := .f.
endif   
   
IF lines == 0
   msginfo(msgarr[1])
   RETURN nil
ENDIF

IF HMG_LEN(aprinternames) == 0
   msgstop(msgarr[2],msgarr[3])
   RETURN nil
ENDIF
fontsizesstr := {"8","9","10","11","12","14","16","18","20","22","24","26","28","36","48","72"}
FOR count1 := 1 TO HMG_LEN(fontsizesstr)
   IF Val(fontsizesstr[count1]) == fontsize
      fontnumber := count1
   ENDIF
NEXT count1
IF fontnumber == 0
   fontnumber := 1
ENDIF
if lArrayMode
   linedata := aData[1]
else   
   linedata := getproperty(windowname,gridname,"item",1)
endif   
asize(sizes,0)
for count1 := 1 to HMG_LEN(linedata)
   aadd(sizes,0)   
   aadd(headersizes,0)
   if lArrayMode
      aadd(headerarr,aDataHeaders[count1])
   else
      aadd(headerarr,getproperty(windowname,gridname,"header",count1))
   endif   
   aadd(totalarr,0.0)
next count1

if lArrayMode
   aJustify := aclone(aArrayJustify)
else
   i := GetControlIndex ( gridname , windowname )

   aEditcontrols := _HMG_SYSDATA [ 40 ] [ i ] [ 2 ]

   aJustify := _HMG_SYSDATA [ 37 ] [i]
endif
   

FOR count1 := 1 TO HMG_LEN(headerarr)
   AAdd(columnarr,{1,headerarr[count1],sizes[count1],ajustify[count1]})
NEXT count1
FOR count1 := 1 TO HMG_LEN(aprinternames)
   IF HMG_UPPER(AllTrim(aprinternames[count1])) == HMG_UPPER(AllTrim(defaultprinter))
      printerno := count1
      EXIT
   ENDIF
NEXT count1
IF printerno == 0
   printerno := 1
ENDIF

if HMG_LEN(sumarr) > 0
   for i := 1 to HMG_LEN(sumarr)
      aadd(_asum,0.0)
   next i   
   for count1 := 1 to lines
      if lArrayMode
         linedata := aData[count1]
      else
         linedata := getproperty(windowname,gridname,"item",count1)
      endif   
      for count2 := 1 to HMG_LEN(linedata)
         if sumarr[count2,1]
            do case
               case ValType(linedata[count2]) == "N"
                  if .not. lArrayMode
                     xres := _HMG_PARSEGRIDCONTROLS ( AEDITCONTROLS , count2 )
                     AEC := XRES [1]
                     AITEMS := XRES [5]
                     IF AEC == 'COMBOBOX'
                        cPrintdata := aitems[linedata[count2]]
                     else
                        cPrintdata := LTrim( Str( linedata[count2] ) )
                     ENDIF
                  else
                     cPrintdata := LTrim( Str( linedata[count2] ) )
			      endif                     
               case ValType(linedata[count2]) == "D"
                  cPrintdata := dtoc( linedata[count2])
               case ValType(linedata[count2]) == "L"
                  if .not. lArrayMode
                     xres := _HMG_PARSEGRIDCONTROLS ( AEDITCONTROLS , count2 )
                     AEC := XRES [1]
                     AITEMS := XRES [8]
                     IF AEC == 'CHECKBOX'
                        cPrintdata := iif(linedata[count2],aitems[1],aitems[2])
                     else
                        cPrintdata := iif(linedata[count2],"T","F")
                     endif
                  else
                     cPrintdata := iif(linedata[count2],"T","F")
				  endif                      
               otherwise
                  cPrintdata := linedata[count2]
            endcase
            _asum[count2] := _asum[count2] + val(stripcomma(cPrintdata,".",","))
         endif
      next count2
   next count1
   
endif   




   define window printgrid at 0,0 width 700 height 440 title msgarr[4] modal nosize nosysmenu on init initprintgrid() 
      define tab tab1 at 10,10 width 285 height 335
         define page msgarr[5]
            define grid columns
               row 30
               col 10
               width 270
               height 300
               widths {130,60,60}
               justify {0,1,0}
               headers {msgarr[6],msgarr[7],msgarr[57]}
               allowedit .t.
               columncontrols {{"TEXTBOX","CHARACTER"},{"TEXTBOX","NUMERIC","9999.99"},{"COMBOBOX",{msgarr[59],msgarr[60]}}}
               columnwhen {{||.f.},{||iif(printgrid.spread.value,.f.,.t.)},{||.t.}}
               columnvalid {{||.t.},{||columnsizeverify()},{||columnselected()}}
               on lostfocus refreshprintgrid()
            end grid
            /*
            DEFINE button editdetails
               Row 30
               Col 265
               width 16
               height 16
               tooltip msgarr[9]
               picture "edit"
               tabstop .f.
               action editcoldetails()
            END button
            */
         end page
         define page msgarr[16]
            DEFINE label header1label
               Row 30
               Col 10
               width 100
               value msgarr[12]
            END label
            DEFINE textbox header1
               Row 30
               Col 110
               width 165
               on change printgridpreview()
            END textbox
            DEFINE label header2label
               Row 70
               Col 10
               width 100
               value msgarr[13]
            END label
            DEFINE textbox header2
               Row 70
               Col 110
               on change printgridpreview()
               width 165
            END textbox
            DEFINE label header3label
               Row 100
               Col 10
               width 100
               value msgarr[14]
            END label
            DEFINE textbox Header3
               Row 100
               Col 110
               on change printgridpreview()
               width 165
            END textbox
            DEFINE label footer1label
               Row 130
               Col 10
               width 100
               value msgarr[15]
            END label
            DEFINE textbox Footer1
               Row 130
               Col 110
               width 165
               on change printgridpreview()
            END textbox
            define label selectfontsizelabel
               row 160
               col 10
               value msgarr[17]
               width 100
            end label
            define combobox selectfontsize
               row 160
               col 110
               width 50
               items fontsizesstr
               on change fontsizechanged()
            end combobox
            define label multilinelabel
               row 190
               col 10
               value msgarr[18]
               width 100
            end label
            define combobox wordwrap
               row 190
               col 110
               width 90
               items {msgarr[19],msgarr[20]}
               on change printgridpreview()
            end combobox
            define label pagination
               row 220
               col 10
               value msgarr[21]
               width 100
            end label
            define combobox pageno
               row 220
               col 110
               width 90
               items {msgarr[22],msgarr[23],msgarr[24]}
               on change printgridpreview()
            end combobox
            define label separatorlab
               row 250
               col 10
               width 100
               value msgarr[25]
            end label
            DEFINE checkbox collines
               Row 245
               Col 110
               width 60
               on change printgridpreview()
               caption msgarr[26]
            END checkbox
            DEFINE checkbox rowlines
               Row 245
               Col 180
               width 60
               on change printgridpreview()
               caption msgarr[27]
            END checkbox
            define label centerlab
               row 280
               col 10
               width 100
               value msgarr[28]
            end label
            DEFINE checkbox vertical
               Row 275
               Col 110
               width 60
               on change printgridpreview()
               caption msgarr[29]
            END checkbox
            define label spacelab
               row 310
               col 10
               width 100
               value msgarr[54]
            end label
            DEFINE checkbox spread
               Row 305
               Col 110
               width 60
               on change spreadchanged()
               caption msgarr[55]
            END checkbox            
         end page
         define page msgarr[30]
            define label orientationlabel
               row 30
               col 10
               Value msgarr[31]
               width 100
            end label
            define combobox paperorientation
               row 30
               col 110
               width 90
               items {msgarr[32],msgarr[33]}
               on change papersizechanged()
            end combobox
            DEFINE label printerslabel
               Row 60
               Col 10
               width 100
               value msgarr[34]
            END label
            DEFINE combobox printers
               Row 60
               Col 110
               width 165
               items aprinternames
               value printerno
            END combobox
            define label sizelabel
               row 90
               col 10
               width 100
               value msgarr[35]
            end label
            DEFINE combobox pagesizes
               Row 90
               Col 110
               width 165
               items papernames
               on change papersizechanged()
            END combobox
            define label widthlabel
               row 120
               col 10
               value msgarr[36]
               width 100
            end label
            define textbox width
               row 120
               col 110
               width 60
               inputmask "999.99"
               on change pagesizechanged()
               numeric .t.
               rightalign .t.
            end textbox
            define label widthmm
               row 120
               col 170
               value "mm"
               width 25
            end label
            define label heightlabel
               row 150
               col 10
               value msgarr[37]
               width 100
            end label
            define textbox height
               row 150
               col 110
               width 60
               inputmask "999.99"
               on change pagesizechanged()
               numeric .t.
               rightalign .t.
            end textbox
            define label heightmm
               row 150
               col 170
               value "mm"
               width 25
            end label
            define frame margins
               row 180
               col 5
               width 185
               height 80
               caption msgarr[38]
            end frame
            define label toplabel
               row 200
               col 10
               width 35
               value msgarr[39]
            end label
            define textbox top
               row 200
               col 45
               width 50
               inputmask "99.99"
               numeric .t.
               on change printgridpreview()
               rightalign .t.
            end textbox
            define label rightlabel
               row 200
               col 100
               width 35
               value msgarr[40]
            end label
            define textbox right
               row 200
               col 135
               width 50
               inputmask "99.99"
               on change papersizechanged()
               numeric .t.
               rightalign .t.
            end textbox
            define label leftlabel
               row 230
               col 10
               width 35
               value msgarr[41]
            end label
            define textbox left
               row 230
               col 45
               width 50
               inputmask "99.99"
               on change papersizechanged()
               numeric .t.
               rightalign .t.
            end textbox
            define label bottomlabel
               row 230
               col 100
               width 35
               value msgarr[42]
            end label
            define textbox bottom
               row 230
               col 135
               width 50
               inputmask "99.99"
               numeric .t.
               on change printgridpreview()
               rightalign .t.
            end textbox
         end page
         define page msgarr[61]
            define grid merge
               row 30
               col 10
               width 240
               height 240
               headers {msgarr[62],msgarr[63],msgarr[64]}
               widths {40,40,100}
               allowedit .t.
               columncontrols {{"TEXTBOX","NUMERIC","999"},{"TEXTBOX","NUMERIC","999"},{"TEXTBOX","CHARACTER"}}
               columnvalid {{||.t.},{||.t.},{||.t.}}
               on lostfocus mergeheaderschanged()
            end grid
            define button add
               row 30
               col 260
               width 20
               height 20
               caption "+"
               fontbold .t.
               fontsize 16
//               picture "additem"
               action addmergeheadrow()
            end button
            define button del
               row 55
               col 260
               width 20
               height 20
               caption "-"
               fontbold .t.
               fontsize 16
//               picture "delitem"
               action delmergeheadrow()
            end button
            
         end page
      end tab
      define button browseprint1
         row 350
         col 160
         caption msgarr[43]
         action printstart()
         width 80
      end button
      define button browseprintcancel
         row 350
         col 260
         caption msgarr[44]
         action printgrid.release
         width 80
      end button
      define button browseprintreset
         row 350
         col 360
         caption msgarr[66]
         action resetprintgridform()
         width 80
      end button
      DEFINE statusbar
         statusitem msgarr[45] width 200
         statusitem msgarr[10] + "mm "+msgarr[11]+"mm" width 300
      END statusbar
   end window
if nPaperSize == 256 // custom
   printgrid.width.value := nCustomPaperWidth
   printgrid.height.value := nCustomPaperHeight
endif   
printgrid.spread.value := .f.
printgrid.selectfontsize.value := fontnumber
printgrid.pagesizes.value := curpagesize
printgrid.top.value := nTopMargin
printgrid.right.value := nRightMargin
printgrid.bottom.value := nBottomMargin
printgrid.left.value := nLeftMargin
printgrid.collines.value := lVertLines
printgrid.rowlines.value := lHorLines
printgrid.header1.value := header1
printgrid.header2.value := header2
printgrid.header3.value := header3
printgrid.wordwrap.value := 2
printgrid.pageno.value := 2
printgrid.vertical.value := .t.
printgrid.paperorientation.value := IIf(orientation == "P",2,1)

for count1 := 1 to HMG_LEN(mergehead)
   if mergehead[count1,2] >= mergehead[count1,1] .and. iif(count1 > 1,mergehead[count1,1] > mergehead[count1-1,2],.t.)
      printgrid.merge.additem({mergehead[count1,1],mergehead[count1,2],mergehead[count1,3]})
   endif 
next count1
if printgrid.merge.itemcount > 0
   printgrid.merge.value := 1
endif

for count1 := 1 to HMG_LEN(columnarr)
   printgrid.columns.additem({columnarr[count1,2],columnarr[count1,3],1})
next count1
calculatecolumnsizes()
printcoltally()
if printgrid.columns.itemcount > 0
   printgrid.columns.value := 1
endif 
printgridpreview()
printgrid.center
printgrid.activate()
return nil

function refreshprintgrid
printcoltally()
printgridpreview()
return nil

function spreadchanged
calculatecolumnsizes()
refreshprintgrid()
return nil

function initprintgrid
IF .not. showwindow
   IF printgrid.browseprint1.enabled
      printstart()
   ELSE
      printgridinit()
//      printgrid.show
   ENDIF
ELSE
   printgridinit()
//   printgrid.show
ENDIF


return nil

function printcoltally
LOCAL col := 0
local count1 := 0
local count2 := 0
local totcol := 0.0
if .not. iscontroldefined(browseprintcancel,printgrid)
   return nil
endif
if printgrid.spread.value
   for count1 := 1 to HMG_LEN(columnarr)
      IF columnarr[count1,1] == 1
         col := col + max(sizes[count1],headersizes[count1]) + 2 // 2 mm for column separation
         count2 := count2 + 1
      endif
   next count1
   if col < maxcol2 
      totcol := col - (count2 * 2)
      for count1 := 1 to HMG_LEN(columnarr)
         IF columnarr[count1,1] == 1
            columnarr[count1,3] := (maxcol2 - (count2 *2) - 5) * max(sizes[count1],headersizes[count1]) / totcol
         endif
      next count1
      col := maxcol2 - 5
   endif 
else
   for count1 := 1 to HMG_LEN(columnarr)
      IF columnarr[count1,1] == 1
         col := col + columnarr[count1,3] + 2 // 2 mm for column separation
         count2 := count2 + 1
      endif
   next count1
endif
curcol1 := col
printgrid.statusbar.item(2) := msgarr[10]+" "+alltrim(str(curcol1,12,2))+" "+msgarr[11]+" "+alltrim(str(maxcol2,12,2))

IF maxcol2 >= curcol1
   printgrid.browseprint1.enabled := .t.
   printgrid.statusbar.item(1) := msgarr[45]
ELSE
   printgrid.statusbar.item(1) := msgarr[46]
   printgrid.browseprint1.enabled := .f.
   return nil
endif
for count1 := 1 to HMG_LEN(columnarr)
    printgrid.columns.item(count1) := {columnarr[count1,2],columnarr[count1,3],columnarr[count1,1]}
next count1    
return nil

function fontsizechanged
calculatecolumnsizes()
refreshprintgrid()
return nil

function calculatecolumnsizes
LOCAL fontsize1 := 0
local cPrintdata := ""
local count1 := 0
local count2 := 0
local nDecimals := Set( _SET_DECIMALS)
local aec := ""
local aitems := {}
LOCAL totalcol

if .not. iscontroldefined(browseprintcancel,printgrid)
   return nil
endif
if HMG_LEN(aColWidths) > 0
   if lArrayMode
      linedata := aData[1]
   else
      linedata := getproperty(windowname,gridname,"item",1)
   endif
   if HMG_LEN(linedata) <> HMG_LEN(aColWidths)
      return nil // Error!
   endif   
   asize(sizes,0)
   for count1 := 1 to HMG_LEN(linedata)
      aadd(sizes,aColWidths[count1])
      if aColWidths[count1] == 0
         columnarr[count1,1] := 2
      else
         columnarr[count1,1] := 1
      endif       
      columnarr[count1,3] := aColWidths[count1]
   next count1
else
   fontsize1 := val(alltrim(printgrid.selectfontsize.item(printgrid.selectfontsize.value)))
   IF fontsize1 > 0
      if lArrayMode
         linedata := aData[1]
      else
         linedata := getproperty(windowname,gridname,"item",1)
      endif   
      asize(sizes,0)
      asize(headersizes,0)
      for count1 := 1 to HMG_LEN(linedata)
         aadd(sizes,0)   
         aadd(headersizes,0)
      next count1
      for count1 := 1 to lines
         if lArrayMode
            linedata := aData[count1]
         else
            linedata := getproperty(windowname,gridname,"item",count1)
         endif   
         for count2 := 1 to HMG_LEN(linedata)
            do case
               case ValType(linedata[count2]) == "N"
                  if .not. lArrayMode
                     xres := _HMG_PARSEGRIDCONTROLS ( AEDITCONTROLS , count2 )
                     AEC := XRES [1]
                     AITEMS := XRES [5]
                     IF AEC == 'COMBOBOX'
                        cPrintdata := aitems[linedata[count2]]
                     else
                        cPrintdata := LTrim( Str( linedata[count2] ) )
                     ENDIF
                  else
                     cPrintdata := LTrim( Str( linedata[count2] ) )
                  endif   
               case ValType(linedata[count2]) == "D"
                  cPrintdata := dtoc( linedata[count2])
               case ValType(linedata[count2]) == "L"
                  if .not. lArrayMode
                     xres := _HMG_PARSEGRIDCONTROLS ( AEDITCONTROLS , count2 )
                     AEC := XRES [1]
                     AITEMS := XRES [8]
                     IF AEC == 'CHECKBOX'
                        cPrintdata := iif(linedata[count2],aitems[1],aitems[2])
                     else
                        cPrintdata := iif(linedata[count2],"T","F")
                     endif
                  else
                     cPrintdata := iif(linedata[count2],"T","F")
                  endif   
               otherwise
                  cPrintdata := linedata[count2]
            endcase
            sizes[count2] := max(sizes[count2],printlen(alltrim(cPrintdata),fontsize1,fontname))
         next count2
      next count1
      for count1 := 1 to HMG_LEN(headerarr)
          headersizes[count1] := printlen(alltrim(headerarr[count1]),fontsize1,fontname)
      next count1
      totalcol := 0.0
      FOR count1 := 1 TO HMG_LEN(columnarr)
         if HMG_LEN(sumarr) > 0
            if sumarr[count1,1]
               sizes[count1] := max(sizes[count1],printlen(alltrim(transform(_asum[count1],sumarr[count1,2])),fontsize1,fontname))
            endif
         endif
         columnarr[count1,3] := max(sizes[count1],headersizes[count1])
      NEXT count1
   ENDIF
endif
return nil



function printstart
LOCAL row := 0
LOCAL col := 0
LOCAL lh := 0 // line height
LOCAL pageno := 0
LOCAL printdata := {}
LOCAL justifyarr := {}
LOCAL maxrow1 := 0
LOCAL maxcol1 := curcol1
LOCAL maxlines := 0
LOCAL totrows := 0
LOCAL leftspace := 0
LOCAL rightspace := 0
LOCAL firstrow := 0
LOCAL size1 := 0
LOCAL data1 := ""
LOCAL paperwidth := printgrid.width.value
LOCAL paperheight := printgrid.height.value
LOCAL totcols := 0
local papersize := 0
local sizesarr := {}
local totcol := 0
local colcount := 0
local nextline := {}
local nextcount := 0
local count1 := 0
local count2 := 0
local count3 := 0
local count4 := 0
local count5 := 0
local count6 := 0
local count7 := 0
local dataprintover := .t.
local cPrintdata := ""
local nDecimals := Set( _SET_DECIMALS)
local aec := ""
local aitems := {}
local gridprintdata := array(20)
local printername := ""


if lArrayMode
   totrows := HMG_LEN(aData)
else   
   totrows := getproperty(windowname,gridname,"itemcount")
endif   

IF printgrid.printers.value > 0
   printername := AllTrim(printgrid.printers.item(printgrid.printers.value))
ELSE
   msgstop(msgarr[47],msgarr[3])
   RETURN nil
ENDIF

do case
   case printgrid.pagesizes.value == printgrid.pagesizes.itemcount // custom
      papersize := PRINTER_PAPER_USER
   otherwise
      papersize := printgrid.pagesizes.value
endcase

if printgrid.pagesizes.value == printgrid.pagesizes.itemcount // custom
    SELECT PRINTER printername TO psuccess ORIENTATION IIf(printgrid.paperorientation.value == 1,PRINTER_ORIENT_LANDSCAPE,PRINTER_ORIENT_PORTRAIT);
        PAPERSIZE papersize;
        PAPERLENGTH iif(printgrid.paperorientation.value == 1,printgrid.width.value,printgrid.height.value);
        PAPERWIDTH iif(printgrid.paperorientation.value == 1,printgrid.height.value,printgrid.width.value);
        COPIES 1;
        PREVIEW
else
    SELECT PRINTER printername TO psuccess ORIENTATION IIf(printgrid.paperorientation.value == 1,PRINTER_ORIENT_LANDSCAPE,PRINTER_ORIENT_PORTRAIT);
        PAPERSIZE papersize;
        COPIES 1;
        PREVIEW
endif
IF .not. psuccess
   msgstop(msgarr[48],msgarr[3])
   RETURN nil
ENDIF

size1 := val(alltrim(printgrid.selectfontsize.item(printgrid.selectfontsize.value)))

// Save Config
if .not. lArrayMode
   begin ini file "reports.cfg"
   // columns
      gridprintdata[1] := {}
      for count1 := 1 to printgrid.columns.itemcount
         aadd(gridprintdata[1],printgrid.columns.item(count1))
      next count1
   // headers  
      gridprintdata[2] := {}
      aadd(gridprintdata[2],printgrid.header1.value)
      aadd(gridprintdata[2],printgrid.header2.value)
      aadd(gridprintdata[2],printgrid.header3.value)
   // footer
      gridprintdata[3] := printgrid.footer1.value
   //fontsize
      gridprintdata[4] := printgrid.selectfontsize.value
   // wordwrap
      gridprintdata[5] := printgrid.wordwrap.value
   // pagination
      gridprintdata[6] := printgrid.pageno.value
   // collines
      gridprintdata[7] := printgrid.collines.value
   // rowlines
      gridprintdata[8] := printgrid.rowlines.value
   // vertical center
      gridprintdata[9] := printgrid.vertical.value
   // space spread
      gridprintdata[10] := printgrid.spread.value
   // orientation
      gridprintdata[11] := printgrid.paperorientation.value
   // printers
      gridprintdata[12] := printgrid.printers.value
   // pagesize
      gridprintdata[13] := printgrid.pagesizes.value
   // paper width
      gridprintdata[14] := printgrid.width.value
   // paper height
      gridprintdata[15] := printgrid.height.value
   // margin top
      gridprintdata[16] := printgrid.top.value
   // margin right
      gridprintdata[17] := printgrid.right.value
   // margin left
      gridprintdata[18] := printgrid.left.value
   // margin bottom
      gridprintdata[19] := printgrid.bottom.value
   // merge headers data
      gridprintdata[20] := {}
      for count1 := 1 to printgrid.merge.itemcount
         aadd(gridprintdata[20],printgrid.merge.item(count1))
      next count1
      set section windowname+"_"+gridname entry "controlname" to windowname+"_"+gridname
      set section windowname+"_"+gridname entry "gridprintdata1" to gridprintdata[1]
      set section windowname+"_"+gridname entry "gridprintdata2" to gridprintdata[2]
      set section windowname+"_"+gridname entry "gridprintdata3" to gridprintdata[3]
      set section windowname+"_"+gridname entry "gridprintdata4" to gridprintdata[4]
      set section windowname+"_"+gridname entry "gridprintdata5" to gridprintdata[5]
      set section windowname+"_"+gridname entry "gridprintdata6" to gridprintdata[6]
      set section windowname+"_"+gridname entry "gridprintdata7" to gridprintdata[7]
      set section windowname+"_"+gridname entry "gridprintdata8" to gridprintdata[8]
      set section windowname+"_"+gridname entry "gridprintdata9" to gridprintdata[9]
      set section windowname+"_"+gridname entry "gridprintdata10" to gridprintdata[10]
      set section windowname+"_"+gridname entry "gridprintdata11" to gridprintdata[11]
      set section windowname+"_"+gridname entry "gridprintdata12" to gridprintdata[12]
      set section windowname+"_"+gridname entry "gridprintdata13" to gridprintdata[13]
      set section windowname+"_"+gridname entry "gridprintdata14" to gridprintdata[14]
      set section windowname+"_"+gridname entry "gridprintdata15" to gridprintdata[15]
      set section windowname+"_"+gridname entry "gridprintdata16" to gridprintdata[16]
      set section windowname+"_"+gridname entry "gridprintdata17" to gridprintdata[17]
      set section windowname+"_"+gridname entry "gridprintdata18" to gridprintdata[18]
      set section windowname+"_"+gridname entry "gridprintdata19" to gridprintdata[19]
      set section windowname+"_"+gridname entry "gridprintdata20" to gridprintdata[20]
   end ini
endif




start printdoc
row := printgrid.top.value
maxrow1 := printgrid.height.value - printgrid.bottom.value
if printgrid.vertical.value
   col := (printgrid.width.value - curcol1)/2
else
   col := printgrid.left.value
endif
lh := Int((size1/72 * 25.4)) + 1 // line height
start printpage
pageno := 1
IF printgrid.pageno.value == 2
   @ Row,(col+maxcol1 - printlen(msgarr[49]+alltrim(str(pageno,10,0)),size1,fontname) - 5) print msgarr[49]+alltrim(str(pageno,10,0)) font fontname size size1
   row := row + lh
ENDIF
IF HMG_LEN(AllTrim(printgrid.header1.value)) > 0
   @ Row+(lh/2),col+Int(maxcol1/2) print AllTrim(printgrid.header1.value) font fontname size size1+2 center
   row := row + lh + lh
ENDIF
IF HMG_LEN(AllTrim(printgrid.header2.value)) > 0
   @ Row+(lh/2),col+Int(maxcol1/2) print AllTrim(printgrid.header2.value) font fontname size size1+2 center
   row := row + lh + lh
ENDIF
IF HMG_LEN(AllTrim(printgrid.header3.value)) > 0
   @ Row+(lh/2),col+Int(maxcol1/2) print AllTrim(printgrid.header3.value) font fontname size size1+2 center
   row := row + lh + lh
ENDIF


if HMG_LEN(mergehead) > 0
   @ Row ,Col-1  print line TO Row ,col+maxcol1-1 penwidth 0.25
   for count1 := 1 to HMG_LEN(mergehead)
      startcol := mergehead[count1,1]
      endcol := mergehead[count1,2]
      headdata := mergehead[count1,3]
      printstart := 0
      printend := 0
      for count2 := 1 to endcol
         if count2 < startcol
            IF columnarr[count2,1] == 1
               printstart := printstart + columnarr[count2,3] + 2
            endif    
         endif   
         IF columnarr[count2,1] == 1
            printend := printend + columnarr[count2,3] + 2
         endif
      next count2
      if printend > printstart
         IF printLen(AllTrim(headdata),size1,fontname) > (printend - printstart)
            count3 := HMG_LEN(headdata)
            do while printlen(HB_USUBSTR(headdata,1,count3),size1,fontname) > (printend - printstart)
               count3 := count3 - 1
            enddo
         ENDIF
         @ Row,col+printstart+int((printend-printstart)/2) print headdata font fontname size size1 center
         @ Row+lh,col-1+printstart print line TO Row+lh ,col-1+printend penwidth 0.25
      endif    
   next count1
   @ row,col-1 print line to row+lh,col-1 penwidth 0.25
   @ row,col-1+maxcol1 print line to row+lh,col-1+maxcol1 penwidth 0.25
   IF printgrid.collines.value
      colcount := 0
      for count2 := 1 to HMG_LEN(columnarr)
         IF columnarr[count2,1] == 1
            totcol := totcol + columnarr[count2,3]
            colcount := colcount + 1
            colreqd := .t.
            for count3 := 1 to HMG_LEN(mergehead)
               startcol := mergehead[count3,1]
               endcol := mergehead[count3,2]
               if count2 >= startcol 
                  if count2 < endcol 
                     if columnarr[endcol,1] == 1
                        colreqd := .f.
                     else
                        for count7 := count2+1 to endcol
                           if columnarr[count7,1] == 1
                              colreqd := .f.
                           endif
                        next count7
                     endif
                  else
                     colreqd := .t.
                  endif
               endif   
            next count3
            if colreqd    
               @ row,col+totcol+(colcount * 2)-1 print line TO row+lh,col+totcol+(colcount * 2)-1 penwidth 0.25
            endif
         ENDIF
      next count2
   ENDIF
   row := row + lh
else
   @ Row ,Col-1  print line TO Row ,col+maxcol1-1 penwidth 0.25   
endif





firstrow := Row


ASize(printdata,0)
ASize(justifyarr,0)
asize(sizesarr,0)
FOR count1 := 1 TO HMG_LEN(columnarr)
   IF columnarr[count1,1] == 1
      size := columnarr[count1,3]
      data1 := columnarr[count1,2]
      IF printLen(AllTrim(data1),size1,fontname) <= size
         AAdd(printdata,alltrim(data1))
      ELSE // header size bigger than column! to be truncated.
         count2 := HMG_LEN(data1)
         do while printlen(HB_USUBSTR(data1,1,count2),size1,fontname) > size
            count2 := count2 - 1
         enddo
         AAdd(printdata,HB_USUBSTR(data1,1,count2))
      ENDIF
      AAdd(justifyarr,columnarr[count1,4])
      aadd(sizesarr,columnarr[count1,3])
   ENDIF
NEXT count1
printline(row,col,printdata,justifyarr,sizesarr,fontname,size1)
row := row + lh
@ Row,Col-1 print line TO Row,col+maxcol1-1 penwidth 0.25
FOR count1 := 1 TO totrows
   if lArrayMode
      linedata := aData[count1]
   else
      linedata := getproperty(windowname,gridname,"item",count1)
   endif   
   ASize(printdata,0)
   asize(nextline,0)
   FOR count2 := 1 TO HMG_LEN(columnarr)
      IF columnarr[count2,1] == 1
         size := columnarr[count2,3]
         do case
            case ValType(linedata[count2]) == "N"
               if .not. lArrayMode
                  xres := _HMG_PARSEGRIDCONTROLS ( AEDITCONTROLS , count2 )
                  AEC := XRES [1]
                  AITEMS := XRES [5]
                  IF AEC == 'COMBOBOX'
                     cPrintdata := aitems[linedata[count2]]
                  else
                     cPrintdata := LTrim( Str( linedata[count2] ) )
                  ENDIF
               else
                  cPrintdata := LTrim( Str( linedata[count2] ) )
               endif   
            case ValType(linedata[count2]) == "D"
               cPrintdata := dtoc( linedata[count2])
            case ValType(linedata[count2]) == "L"
               if .not. lArrayMode
                  xres := _HMG_PARSEGRIDCONTROLS ( AEDITCONTROLS , count2 )
                  AEC := XRES [1]
                  AITEMS := XRES [8]
                  IF AEC == 'CHECKBOX'
                     cPrintdata := iif(linedata[count2],aitems[1],aitems[2])
                  else
                     cPrintdata := iif(linedata[count2],"T","F")
                  endif
               else
                  cPrintdata := iif(linedata[count2],"T","F")
		       endif                  
            otherwise
               cPrintdata := linedata[count2]
         endcase
         if HMG_LEN(sumarr) > 0
            if sumarr[count2,1]
               cPrintdata := transform(val(stripcomma(cPrintdata,".",",")),sumarr[count2,2])
            endif
         endif   
         data1 := cPrintdata
         if HMG_LEN(sumarr) > 0
            if sumarr[count2,1]
               totalarr[count2] := totalarr[count2] + val(stripcomma(cPrintdata,".",","))
            endif   
         endif 
         IF printLen(AllTrim(data1),size1,fontname) <= size
            aadd(printdata,alltrim(data1))
            aadd(nextline,0)
         ELSE  // truncate or wordwrap!
            IF printgrid.wordwrap.value == 2 // truncate
               count3 := HMG_LEN(data1)
               do while printlen(HB_USUBSTR(data1,1,count3),size1,fontname) > size
                  count3 := count3 - 1
               enddo
               AAdd(printdata,HB_USUBSTR(data1,1,count3))
               aadd(nextline,0)
            ELSE // wordwrap
               count3 := HMG_LEN(data1)
               do while printlen(HB_USUBSTR(data1,1,count3),size1,fontname) > size
                  count3 := count3 - 1
               enddo
               data1 := HB_USUBSTR(data1,1,count3)
               if HB_UTF8RAT(" ",data1) > 0
                  count3 := HB_UTF8RAT(" ",data1)
               endif
               AAdd(printdata,HB_USUBSTR(data1,1,count3))
               aadd(nextline,count3)
            ENDIF
         ENDIF
      else
         aadd(nextline,0)   
      ENDIF
   NEXT count2
   printline(row,col,printdata,justifyarr,sizesarr,fontname,size1,lh)
   Row := Row + lh
   dataprintover := .t.
   for count2 := 1 to HMG_LEN(nextline)
      if nextline[count2] > 0
         dataprintover := .f.
      endif
   next count2
   do while .not. dataprintover
      ASize(printdata,0)
      for count2 := 1 to HMG_LEN(columnarr)
         IF columnarr[count2,1] == 1
            size := columnarr[count2,3]
            data1 := linedata[count2]
            if nextline[count2] > 0 //there is some next line
               data1 := HB_USUBSTR(data1,nextline[count2]+1,HMG_LEN(data1))
               IF printLen(AllTrim(data1),size1,fontname) <= size
                  aadd(printdata,alltrim(data1))
                  nextline[count2] := 0
               ELSE // there are further lines!
                  count3 := HMG_LEN(data1)
                  do while printlen(HB_USUBSTR(data1,1,count3),size1,fontname) > size
                     count3 := count3 - 1
                  enddo
                  data1 := HB_USUBSTR(data1,1,count3)
                  if HB_UTF8RAT(" ",data1) > 0
                     count3 := HB_UTF8RAT(" ",data1)
                  endif
                  AAdd(printdata,HB_USUBSTR(data1,1,count3))
                  nextline[count2] := nextline[count2]+count3
               ENDIF
            else
               AAdd(printdata,"")
               nextline[count2] := 0
            endif
         endif
      next count2
      printline(row,col,printdata,justifyarr,sizesarr,fontname,size1,lh)
      Row := Row + lh
      dataprintover := .t.
      for count2 := 1 to HMG_LEN(nextline)
         if nextline[count2] > 0
            dataprintover := .f.
         endif
      next count2
   enddo

   IF Row+iif(HMG_LEN(sumarr)>0,(3*lh),lh)+iif(HMG_LEN(alltrim(printgrid.footer1.value))>0,lh,0) >= maxrow1 // 2 lines for total & 1 line for footer
      @ Row,Col-1 print line TO Row,col+maxcol1-1  penwidth 0.25
      if HMG_LEN(sumarr) > 0
         row := row + lh
         @ Row,Col-1 print line TO Row,col+maxcol1-1  penwidth 0.25
         ASize(printdata,0)
         FOR count5 := 1 TO HMG_LEN(columnarr)
            IF columnarr[count5,1] == 1
               size := columnarr[count5,3]
               if sumarr[count5,1]
                  cPrintdata := alltrim(transform(totalarr[count5],sumarr[count5,2]))
               else
                  cPrintdata := ""
               endif   
               aadd(printdata,alltrim(cPrintdata))
            ENDIF
         NEXT count5
         printline(row,col,printdata,justifyarr,sizesarr,fontname,size1,lh)      
         Row := Row + lh
         @ Row,Col-1 print line TO Row,col+maxcol1-1  penwidth 0.25
      else
         @ Row,Col-1 print line TO Row,col+maxcol1-1  penwidth 0.25
      endif   
      lastrow := Row
      totcol := 0
      @ firstrow,Col-1 print line TO lastrow,Col-1  penwidth 0.25
      IF printgrid.collines.value
         colcount := 0
         for count2 := 1 to HMG_LEN(columnarr)
            IF columnarr[count2,1] == 1
                  totcol := totcol + columnarr[count2,3]
                  colcount := colcount + 1
                  @ firstrow,col+totcol+(colcount * 2)-1 print line TO lastrow,col+totcol+(colcount * 2)-1 penwidth 0.25
            ENDIF
         next count2
      ENDIF
      @ firstrow,col+maxcol1-1 print line TO lastrow,col+maxcol1-1 penwidth 0.25
      IF HMG_LEN(AllTrim(printgrid.footer1.value)) > 0
         @ Row+(lh/2),col+Int(maxcol1/2) print AllTrim(printgrid.footer1.value) font fontname size size1+2 center
         row := row + lh + lh
      ENDIF
      IF printgrid.pageno.value == 3
         Row := Row + lh
         @ Row,(col+maxcol1 - printlen(msgarr[49]+alltrim(str(pageno,10,0)),size1,fontname) - 5) print msgarr[49]+alltrim(str(pageno,10,0)) font fontname size size1
      ENDIF
      END printpage
      pageno := pageno + 1
      row := printgrid.top.value
      start printpage
      IF printgrid.pageno.value == 2
         @ Row,(col+maxcol1 - printlen(msgarr[49]+alltrim(str(pageno,10,0)),size1,fontname) - 5) print msgarr[49]+alltrim(str(pageno,10,0)) font fontname size size1
         row := row + lh
      ENDIF
      IF HMG_LEN(AllTrim(printgrid.header1.value)) > 0
         @ Row+(lh/2),col+Int(maxcol1/2) print AllTrim(printgrid.header1.value) font fontname size size1+2 center
         row := row + lh + lh
      ENDIF
      IF HMG_LEN(AllTrim(printgrid.header2.value)) > 0
         @ Row+(lh/2),col+Int(maxcol1/2) print AllTrim(printgrid.header2.value) font fontname size size1+2 center
         row := row + lh + lh
      ENDIF
      IF HMG_LEN(AllTrim(printgrid.header3.value)) > 0
         @ Row+(lh/2),col+Int(maxcol1/2) print AllTrim(printgrid.header3.value) font fontname size size1+2 center
         row := row + lh + lh
      ENDIF
      if HMG_LEN(mergehead) > 0
         @ Row ,Col-1  print line TO Row ,col+maxcol1-1 penwidth 0.25
         for count4 := 1 to HMG_LEN(mergehead)
            startcol := mergehead[count4,1]
            endcol := mergehead[count4,2]
            headdata := mergehead[count4,3]
            printstart := 0
            printend := 0
            for count5 := 1 to endcol
               if count5 < startcol
                  IF columnarr[count5,1] == 1
                     printstart := printstart + columnarr[count5,3] + 2
                  endif    
               endif   
               IF columnarr[count5,1] == 1
                  printend := printend + columnarr[count5,3] + 2
               endif
            next count5
            if printend > printstart
               IF printLen(AllTrim(headdata),size1,fontname) > (printend - printstart)
                  count6 := HMG_LEN(headdata)
                  do while printlen(HB_USUBSTR(headdata,1,count6),size1,fontname) > (printend - printstart)
                     count6 := count6 - 1
                  enddo
               ENDIF
               @ Row,col+printstart+int((printend-printstart)/2) print headdata font fontname size size1 center
               @ Row+lh,col-1+printstart print line TO Row+lh ,col-1+printend penwidth 0.25
            endif    
         next count4
         @ row,col-1 print line to row+lh,col-1 penwidth 0.25
         @ row,col-1+maxcol1 print line to row+lh,col-1+maxcol1 penwidth 0.25
         totcol := 0
         IF printgrid.collines.value
            colcount := 0
            for count5 := 1 to HMG_LEN(columnarr)
               IF columnarr[count5,1] == 1
                  totcol := totcol + columnarr[count5,3]
                  colcount := colcount + 1
                  colreqd := .t.
                  for count6 := 1 to HMG_LEN(mergehead)
                     startcol := mergehead[count6,1]
                     endcol := mergehead[count6,2]
                     if count5 >= startcol 
                        if count5 < endcol 
                           if columnarr[endcol,1] == 1
                              colreqd := .f.
                           else
                              for count7 := (count5) + 1 to endcol
                                 if columnarr[count7,1] == 1
                                    colreqd := .f.
                                 endif
                              next count7
                           endif
                        else
                           colreqd := .t.
                        endif
                     endif   
                  next count6
                  if colreqd    
                     @ row,col+totcol+(colcount * 2)-1 print line TO row+lh,col+totcol+(colcount * 2)-1 penwidth 0.25
                  endif
               ENDIF
            next count5
         ENDIF
         row := row + lh
      else
         @ Row ,Col-1  print line TO Row ,col+maxcol1-1 penwidth 0.25   
      endif
      firstrow := Row
      ASize(printdata,0)
      ASize(justifyarr,0)
      asize(sizesarr,0)
      FOR count2 := 1 TO HMG_LEN(columnarr)
         IF columnarr[count2,1] == 1
            size := columnarr[count2,3]
            data1 := columnarr[count2,2]
            IF printLen(AllTrim(data1),size1,fontname) <= size
               AAdd(printdata,alltrim(data1))
            ELSE // header size bigger than column! truncated as of now.
               count3 := HMG_LEN(data1)
               do while printlen(HB_USUBSTR(data1,1,count3),size1,fontname) > size
                  count3 := count3 - 1
               enddo
               AAdd(printdata,HB_USUBSTR(data1,1,count3))
            ENDIF
            AAdd(justifyarr,columnarr[count2,4])
            aadd(sizesarr,columnarr[count2,3])
         ENDIF
      NEXT count2
      printline(row,col,printdata,justifyarr,sizesarr,fontname,size1)
      row := row + lh
      @ Row,Col-1 print line TO Row,col+maxcol1-1 penwidth 0.25
      if HMG_LEN(sumarr) > 0
         ASize(printdata,0)
         FOR count5 := 1 TO HMG_LEN(columnarr)
            IF columnarr[count5,1] == 1
               size := columnarr[count5,3]
               if sumarr[count5,1]
                  cPrintdata := alltrim(transform(totalarr[count5],sumarr[count5,2]))
               else
                  cPrintdata := ""
               endif   
               aadd(printdata,alltrim(cPrintdata))
            ENDIF
         NEXT count5
         printline(row,col,printdata,justifyarr,sizesarr,fontname,size1,lh)
         Row := Row + lh 
         @ Row,Col-1 print line TO Row,col+maxcol1-1  penwidth 0.25
         Row := Row + lh 
         @ Row,Col-1 print line TO Row,col+maxcol1-1  penwidth 0.25
      endif   
   ELSE
      IF printgrid.rowlines.value
         @ Row,Col-1 print line TO Row,col+maxcol1-1 penwidth 0.25
      ENDIF
   ENDIF
NEXT count1
@ Row,Col-1 print line TO Row,col+maxcol1-1 penwidth 0.25
if HMG_LEN(sumarr) > 0
   ASize(printdata,0)
   FOR count5 := 1 TO HMG_LEN(columnarr)
      IF columnarr[count5,1] == 1
         size := columnarr[count5,3]
         if sumarr[count5,1]
            cPrintdata := alltrim(transform(totalarr[count5],sumarr[count5,2]))
         else
            cPrintdata := ""
         endif   
         aadd(printdata,alltrim(cPrintdata))
      ENDIF
   NEXT count5
   printline(row,col,printdata,justifyarr,sizesarr,fontname,size1,lh)      
   Row := Row + lh
   @ Row,Col-1 print line TO Row,col+maxcol1-1  penwidth 0.25
endif   
lastrow := Row
totcol := 0
colcount := 0
@ firstrow,Col-1 print line TO lastrow,Col-1 penwidth 0.25
IF printgrid.collines.value
   for count1 := 1 to HMG_LEN(columnarr)
      IF columnarr[count1,1] == 1
         totcol := totcol + columnarr[count1,3]
         colcount := colcount + 1
         @ firstrow,col+totcol+(colcount * 2)-1 print line TO lastrow,col+totcol+(colcount * 2)-1 penwidth 0.25
      ENDIF
   next count2
ENDIF
@ firstrow,col+maxcol1-1 print line TO lastrow,col+maxcol1-1 penwidth 0.25

IF HMG_LEN(AllTrim(printgrid.footer1.value)) > 0
   @ Row+(lh/2),col+Int(maxcol1/2) print AllTrim(printgrid.footer1.value) font fontname size size1+2 center
   row := row + lh + lh
ENDIF
IF printgrid.pageno.value == 3
   Row := Row + lh
   @ Row,(col+maxcol1 - printlen(msgarr[49]+alltrim(str(pageno,10,0)),size1,fontname) - 5) print msgarr[49]+alltrim(str(pageno,10,0)) font fontname size size1
ENDIF
end printpage
end printdoc
if iswindowactive(printgrid)
   printgrid.release
endif
return nil


FUNCTION printgridtoggle
LOCAL lineno := printgrid.columns.value
if this.cellvalue == 1
   columnarr[lineno,1] := 1
else
   if this.cellvalue == 2
      columnarr[lineno,1] := 2
   endif 
endif   
refreshprintgrid()
RETURN .t.

FUNCTION editcoldetails
LOCAL lineno := printgrid.columns.value
LOCAL columnsize := 0
IF lineno > 0
   printgrid.size.value := columnarr[lineno,3] 
   if ajustify[lineno] == 0 .or. ajustify[lineno] == 2
      return .t.
   else
      return .f.
//      msginfo(msgarr[52])
   endif
ENDIF
RETURN .f.


function printline(row,col,aitems,ajustify,sizesarr,fontname,size1)
local tempcol := 0
local count1 := 0
if HMG_LEN(aitems) <> HMG_LEN(ajustify)
   msginfo(msgarr[53])
ENDIF
tempcol := col
for count1 := 1 to HMG_LEN(aitems)
   njustify := ajustify[count1]
   do case
      case njustify == 0 //left
         @ Row,tempcol print aitems[count1] font fontname size size1
      case njustify == 1 //right
         @ Row,tempcol+sizesarr[count1] print aitems[count1] font fontname size size1 right
      case njustify == 2 // center
         @ Row,tempcol+(sizesarr[count1]/2) print aitems[count1] font fontname size size1 center
   end case
   tempcol := tempcol + sizesarr[count1] + 2
next count1
return nil

function printLen( cString,fontsize,fontname)
return round(gettextwidth(Nil,cString,fontname)*0.072/72*25.4*fontsize,2)

function pagesizechanged
if iscontroldefined(browseprintcancel,printgrid)
   maxcol2 := printgrid.width.value - printgrid.left.value - printgrid.right.value
   printgrid.statusbar.item(2) := msgarr[10]+" "+alltrim(str(curcol1,12,2))+" "+msgarr[11]+" "+alltrim(str(maxcol2,12,2))   
   refreshprintgrid()
endif    
return nil



function papersizechanged
local printername := ""
local papersize := 0
local wo := 0.0
local ho := 0.0
if .not. iscontroldefined(browseprintcancel,printgrid)
   return nil
endif

IF printgrid.printers.value > 0
   printername := AllTrim(printgrid.printers.item(printgrid.printers.value))
ELSE
   msgstop(msgarr[47],msgarr[3])
   RETURN nil
ENDIF

do case
   case printgrid.pagesizes.value == printgrid.pagesizes.itemcount // custom
      papersize := PRINTER_PAPER_USER
   otherwise
      papersize := printgrid.pagesizes.value
endcase

if printgrid.pagesizes.value == printgrid.pagesizes.itemcount // custom
    SELECT PRINTER printername TO psuccess ORIENTATION IIf(printgrid.paperorientation.value == 1,PRINTER_ORIENT_LANDSCAPE,PRINTER_ORIENT_PORTRAIT);
        PAPERSIZE papersize;
        PAPERLENGTH iif(printgrid.paperorientation.value == 1,printgrid.width.value,printgrid.height.value);
        PAPERWIDTH iif(printgrid.paperorientation.value == 1,printgrid.height.value,printgrid.width.value);
        COPIES 1
else
    SELECT PRINTER printername TO psuccess ORIENTATION IIf(printgrid.paperorientation.value == 1,PRINTER_ORIENT_LANDSCAPE,PRINTER_ORIENT_PORTRAIT);
        PAPERSIZE papersize;
        COPIES 1
endif
IF .not. psuccess
   msgstop(msgarr[48],msgarr[3])
   RETURN nil
ENDIF

if papersize <> 256 // not custom
   HO := GETPRINTABLEAREAHORIZONTALOFFSET()
   VO := GETPRINTABLEAREAVERTICALOFFSET()

   printgrid.width.value := GETPRINTABLEAREAWIDTH() + ( HO * 2 )
   printgrid.height.value := GETPRINTABLEAREAHEIGHT() + ( VO * 2 ) 
endif

if printgrid.pagesizes.value > 0
/*
   if printgrid.paperorientation.value == 2 //portrait
      printgrid.width.value := papersizes[printgrid.pagesizes.value,1]
      printgrid.height.value := papersizes[printgrid.pagesizes.value,2]
   else // landscape
      printgrid.width.value := papersizes[printgrid.pagesizes.value,2]
      printgrid.height.value := papersizes[printgrid.pagesizes.value,1]
   endif
  */ 
   maxcol2 := printgrid.width.value - printgrid.left.value - printgrid.right.value
   printgrid.statusbar.item(2) := msgarr[10]+" "+alltrim(str(curcol1,12,2))+" "+msgarr[11]+" "+alltrim(str(maxcol2,12,2))   
endif
if printgrid.pagesizes.value == printgrid.pagesizes.itemcount // custom
   printgrid.width.readonly := .f.
   printgrid.height.readonly := .f.
else
   printgrid.width.readonly := .t.
   printgrid.height.readonly := .t.
endif
refreshprintgrid()
return nil


function printgridpreview
local startx := 10
local starty := 300
local endx := 360
local endy := 690
local maxwidth := endy - starty - (10 * 2) // 10 for each side
local maxheight := endx - startx - (10 * 2)
local width := 0.0 
local height := 0.0
local resize := 1
local curx := 0
local cury := 0
LOCAL lh := 0 // line height
LOCAL pageno := 0
LOCAL printdata := {}
LOCAL justifyarr := {}
LOCAL totrows := 0
LOCAL firstrow := 0
LOCAL size1 := 0
LOCAL data1 := ""
local sizesarr := {}
local totcol := 0
local maxrow1 := 0
LOCAL maxcol1 := 0.0
local pl := 0
local colcount := 0
local nextline := {}
local count1 := 0
local count2 := 0
local count3 := 0
local count4 := 0
local count5 := 0
local count6 := 0
local count7 := 0
local cPrintdata := ""
local nDecimals := Set( _SET_DECIMALS)
local aec := ""
local aitems := {}

if lArrayMode
   totrows := HMG_LEN(aData)
else
   totrows := getproperty(windowname,gridname,"itemcount")
endif   

if .not. iscontroldefined(browseprintcancel,printgrid)
   return nil
endif

width := printgrid.width.value
height := printgrid.height.value
maxcol1 := curcol1


if maxwidth >= width .and. maxheight >= height
   resize := 1 // resize not required
else
   resize := min(maxwidth/width,maxheight/height)
endif

curx := startx + (maxheight - (height * resize))/2 + 10
cury := starty + (maxwidth - (width * resize))/2 + 10
ERASE WINDOW printgrid
DRAW RECTANGLE IN WINDOW printgrid AT curx,cury	TO curx + (height * resize),cury + (width * resize) FILLCOLOR {255,255,255}

size1 := val(alltrim(printgrid.selectfontsize.item(printgrid.selectfontsize.value)))

maxrow1 := curx + ((printgrid.height.value - printgrid.bottom.value) * resize)
curx := curx+ (printgrid.top.value * resize)
maxcol1 := (maxcol1) * resize
if printgrid.vertical.value
   cury := cury + ((printgrid.width.value - curcol1)/2 * resize)
else
   cury := cury + (printgrid.left.value * resize)
endif

lh := (Int((size1/72 * 25.4)) + 1) * resize // line height
pageno := 1
IF printgrid.pageno.value == 2
   pl := printlen(msgarr[49]+alltrim(str(pageno,10,0)),size1,fontname)*resize
   draw line in window printgrid at curx,cury+maxcol1 - pl to curx,cury+maxcol1
   curx := curx + lh
ENDIF
IF HMG_LEN(AllTrim(printgrid.header1.value)) > 0
   pl := printlen(AllTrim(printgrid.header1.value),size1,fontname) * resize
   draw line in window printgrid at curx+(lh/2),cury + ((maxcol1 - pl)/2) to curx+(lh/2),cury + ((maxcol1 - pl)/2) + pl
   curx := curx + lh + lh
ENDIF
IF HMG_LEN(AllTrim(printgrid.header2.value)) > 0
   pl := printlen(AllTrim(printgrid.header2.value),size1,fontname) * resize
   draw line in window printgrid at curx+(lh/2),cury + ((maxcol1 - pl)/2) to curx+(lh/2),cury + ((maxcol1 - pl)/2) + pl
   curx := curx + lh + lh
ENDIF
IF HMG_LEN(AllTrim(printgrid.header3.value)) > 0
   pl := printlen(AllTrim(printgrid.header3.value),size1,fontname) * resize
   draw line in window printgrid at curx+(lh/2),cury + ((maxcol1 - pl)/2) to curx+(lh/2),cury + ((maxcol1 - pl)/2) + pl
   curx := curx + lh + lh
ENDIF


if HMG_LEN(mergehead) > 0
   draw line in window printgrid at curx,cury to curx,cury+maxcol1-(1*resize)
   for count1 := 1 to HMG_LEN(mergehead)
      startcol := mergehead[count1,1]
      endcol := mergehead[count1,2]
      headdata := mergehead[count1,3]
      printstart := 0
      printend := 0
      for count2 := 1 to endcol
         if count2 < startcol
            IF columnarr[count2,1] == 1
               printstart := printstart + columnarr[count2,3] + 2
            endif    
         endif   
         IF columnarr[count2,1] == 1
            printend := printend + columnarr[count2,3] + 2
         endif
      next count2
      if printend > printstart
         IF printLen(AllTrim(headdata),size1,fontname) > (printend - printstart)
            count3 := HMG_LEN(headdata)
            do while printlen(HB_USUBSTR(headdata,1,count3),size1,fontname) > (printend - printstart)
               count3 := count3 - 1
            enddo
         ENDIF
         pl := printlen(AllTrim(headdata),size1,fontname) 
         draw line in window printgrid at curx+(lh/2),cury + (printstart * resize) + ((((printend-printstart) - pl)/2)*resize) to curx+(lh/2),cury + (printstart * resize) + ((((printend-printstart) - pl)/2)*resize)+(pl*resize)
         draw line in window printgrid at curx+lh,cury+(printstart*resize) TO curx+lh,cury+(printend*resize)
      endif    
   next count1
   draw line in window printgrid at curx,cury to curx+lh,cury
   draw line in window printgrid at curx,cury+maxcol1-(1*resize) to curx+lh,cury+maxcol1-(1*resize)
   IF printgrid.collines.value
      colcount := 0
      for count2 := 1 to HMG_LEN(columnarr)
         IF columnarr[count2,1] == 1
            totcol := totcol + columnarr[count2,3]
            colcount := colcount + 1
            colreqd := .t.
            for count3 := 1 to HMG_LEN(mergehead)
               startcol := mergehead[count3,1]
               endcol := mergehead[count3,2]
               if count2 >= startcol 
                  if count2 < endcol 
                     if columnarr[endcol,1] == 1
                        colreqd := .f.
                     else
                        for count7 := count2+1 to endcol
                           if columnarr[count7,1] == 1
                              colreqd := .f.
                           endif
                        next count7
                     endif
                  else
                     colreqd := .t.
                  endif
               endif   
            next count3
            if colreqd    
               draw line in window printgrid at curx,cury-1+((totcol+(colcount * 2)) * resize) to curx+lh,cury-1+((totcol+(colcount * 2)) * resize)
            endif
         ENDIF
      next count2
   ENDIF
   curx := curx + lh
else
   draw line in window printgrid at curx,cury to curx,cury+maxcol1-(1*resize)
endif



firstrow := curx
//draw line in window printgrid at curx,cury to curx,cury+maxcol1-(1*resize)
ASize(printdata,0)
ASize(justifyarr,0)
asize(sizesarr,0)
FOR count1 := 1 TO HMG_LEN(columnarr)
   IF columnarr[count1,1] == 1
      size := columnarr[count1,3]
      data1 := columnarr[count1,2]
      IF printLen(AllTrim(data1),size1,fontname) <= size
         AAdd(printdata,alltrim(data1))
      ELSE // header size bigger than column! to be truncated.
         count2 := HMG_LEN(data1)
         do while printlen(HB_USUBSTR(data1,1,count2),size1,fontname) > size
            count2 := count2 - 1
         enddo
         AAdd(printdata,HB_USUBSTR(data1,1,count2))
      ENDIF
      AAdd(justifyarr,columnarr[count1,4])
      aadd(sizesarr,columnarr[count1,3])
   ENDIF
NEXT count1
printpreviewline(curx+(lh/2),cury,printdata,justifyarr,sizesarr,fontname,size1,resize)
curx := curx + lh
draw line in window printgrid at curx,cury to curx,cury+maxcol1-(1*resize)
FOR count1 := 1 TO totrows
   if lArrayMode
      linedata := aData[count1]
   else
      linedata := getproperty(windowname,gridname,"item",count1)
   endif   
   ASize(printdata,0)
   asize(nextline,0)
   FOR count2 := 1 TO HMG_LEN(columnarr)
      IF columnarr[count2,1] == 1
         size := columnarr[count2,3]
         do case
            case ValType(linedata[count2]) == "N"
               if .not. lArrayMode
                  xres := _HMG_PARSEGRIDCONTROLS ( AEDITCONTROLS , count2 )
                  AEC := XRES [1]
                  AITEMS := XRES [5]
                  IF AEC == 'COMBOBOX'
                     cPrintdata := aitems[linedata[count2]]
                  else
                     cPrintdata := LTrim( Str( linedata[count2] ) )
                  ENDIF
               else
                  cPrintdata := LTrim( Str( linedata[count2] ) )
			   endif                     
            case ValType(linedata[count2]) == "D"
               cPrintdata := dtoc( linedata[count2])
            case ValType(linedata[count2]) == "L"
               if .not. lArrayMode
                  xres := _HMG_PARSEGRIDCONTROLS ( AEDITCONTROLS , count2 )
                  AEC := XRES [1]
                  AITEMS := XRES [8]
                  IF AEC == 'CHECKBOX'
                     cPrintdata := iif(linedata[count2],aitems[1],aitems[2])
                  else
                     cPrintdata := iif(linedata[count2],"T","F")
                  endif
               endif   
            otherwise
               cPrintdata := linedata[count2]
         endcase
         data1 := cPrintdata
         IF printLen(AllTrim(data1),size1,fontname) <= size
            aadd(printdata,alltrim(data1))
            aadd(nextline,0)
         ELSE
            IF printgrid.wordwrap.value == 2
               count3 := HMG_LEN(data1)
               do while printlen(HB_USUBSTR(data1,1,count3),size1,fontname) > size
                  count3 := count3 - 1
               enddo
               AAdd(printdata,HB_USUBSTR(data1,1,count3))
               aadd(nextline,0)
            ELSE
               count3 := HMG_LEN(data1)
               do while printlen(HB_USUBSTR(data1,1,count3),size1,fontname) > size
                  count3 := count3 - 1
               enddo
               data1 := HB_USUBSTR(data1,1,count3)
               if HB_UTF8RAT(" ",data1) > 0
                  count3 := HB_UTF8RAT(" ",data1)
               endif
               AAdd(printdata,HB_USUBSTR(data1,1,count3))
               aadd(nextline,count3)
            ENDIF
         ENDIF
      else
         aadd(nextline,0)   
      ENDIF
   NEXT count2
   printpreviewline(curx+(lh/2),cury,printdata,justifyarr,sizesarr,fontname,size1,resize)
   curx := curx + lh
   dataprintover := .t.
   for count2 := 1 to HMG_LEN(nextline)
      if nextline[count2] > 0
         dataprintover := .f.
      endif
   next count2
   do while .not. dataprintover
      ASize(printdata,0)
      for count2 := 1 to HMG_LEN(columnarr)
         IF columnarr[count2,1] == 1
            size := columnarr[count2,3]
            data1 := linedata[count2]
            if nextline[count2] > 0 //there is some next line
               data1 := HB_USUBSTR(data1,nextline[count2]+1,HMG_LEN(data1))
               IF printLen(AllTrim(data1),size1,fontname) <= size
                  aadd(printdata,alltrim(data1))
                  nextline[count2] := 0
               ELSE // there are further lines!
                  count3 := HMG_LEN(data1)
                  do while printlen(HB_USUBSTR(data1,1,count3),size1,fontname) > size
                     count3 := count3 - 1
                  enddo
                  data1 := HB_USUBSTR(data1,1,count3)
                  if HB_UTF8RAT(" ",data1) > 0
                     count3 := HB_UTF8RAT(" ",data1)
                  endif
                  AAdd(printdata,HB_USUBSTR(data1,1,count3))
                  nextline[count2] := nextline[count2]+count3
               ENDIF
            else
               AAdd(printdata,"")
               nextline[count2] := 0
            endif
         endif
      next count2
      printpreviewline(curx+(lh/2),cury,printdata,justifyarr,sizesarr,fontname,size1,resize)
      curx := curx + lh
      dataprintover := .t.
      for count2 := 1 to HMG_LEN(nextline)
         if nextline[count2] > 0
            dataprintover := .f.
         endif
      next count2
   enddo

   IF curx+lh >= maxrow1
      draw line in window printgrid at curx,cury to curx,cury+maxcol1-(1*resize)
      lastrow := curx
      totcol := 0
      draw line in window printgrid at firstrow,cury to lastrow,cury
      IF printgrid.collines.value
         colcount := 0
         for count2 := 1 to HMG_LEN(columnarr)
            IF columnarr[count2,1] == 1
               colcount := colcount + 1
               totcol := totcol + columnarr[count2,3]
               draw line in window printgrid at firstrow,cury+(totcol+(colcount * 2)-1) * resize to lastrow,cury+(totcol+(colcount * 2)-1) * resize
            ENDIF
         next count2
      ENDIF
      draw line in window printgrid at firstrow,cury+maxcol1-(1*resize) to lastrow,cury+maxcol1-(1*resize)
      IF HMG_LEN(AllTrim(printgrid.footer1.value)) > 0
         pl := printlen(AllTrim(printgrid.footer1.value),size1,fontname) * resize
         draw line in window printgrid at curx+(lh/2),cury + ((maxcol1 - pl)/2) to curx+(lh/2),cury + ((maxcol1 - pl)/2) + pl
         curx := curx + lh + lh
      ENDIF
      IF printgrid.pageno.value == 3
         pl := printlen(msgarr[49]+alltrim(str(pageno,10,0)),size1,fontname)*resize
         draw line in window printgrid at curx,cury+maxcol1 - pl to curx,cury+maxcol1
         curx := curx + lh
      ENDIF
      count1 := totrows
   ELSE
      IF printgrid.rowlines.value
         draw line in window printgrid at curx,cury to curx,cury+maxcol1-(1*resize)
      ENDIF
   ENDIF
NEXT count1
draw line in window printgrid at curx,cury to curx,cury+maxcol1-(1*resize)
lastrow := curx
totcol := 0
colcount := 0
draw line in window printgrid at firstrow,cury to lastrow,cury
IF printgrid.collines.value
   for count1 := 1 to HMG_LEN(columnarr)
      IF columnarr[count1,1] == 1
         totcol := totcol + columnarr[count1,3]
         colcount := colcount + 1
         draw line in window printgrid at firstrow,cury+(totcol+(colcount * 2)-1) * resize to lastrow,cury+(totcol+(colcount * 2)-1) * resize
      ENDIF
   next count1
ENDIF
draw line in window printgrid at firstrow,cury+maxcol1-(1*resize) to lastrow,cury+maxcol1-(1*resize)
IF HMG_LEN(AllTrim(printgrid.footer1.value)) > 0
   pl := printlen(AllTrim(printgrid.footer1.value),size1,fontname) * resize
   draw line in window printgrid at curx+(lh/2),cury + ((maxcol1 - pl)/2) to curx+(lh/2),cury + ((maxcol1 - pl)/2) + pl
   curx := curx + lh + lh
ENDIF
IF printgrid.pageno.value == 3
   pl := printlen(msgarr[49]+alltrim(str(pageno,10,0)),size1,fontname)*resize
   draw line in window printgrid at curx,cury+maxcol1 - pl to curx,cury+maxcol1
   curx := curx + lh
ENDIF
return nil


function printpreviewline(row,col,aitems,ajustify,sizesarr,fontname,size1,resize)
local tempcol := 0
local count1 := 0
local pl := 0
if HMG_LEN(aitems) <> HMG_LEN(ajustify)
   msginfo(msgarr[53])
ENDIF
tempcol := col
for count1 := 1 to HMG_LEN(aitems)
   njustify := ajustify[count1]
   pl := printlen(AllTrim(aitems[count1]),size1,fontname) * resize
   do case
      case njustify == 0 //left
         draw line in window printgrid at row,tempcol to row,tempcol+pl
      case njustify == 1 //right
         draw line in window printgrid at row,tempcol+((sizesarr[count1] + 2) * resize)-pl to row,tempcol+((sizesarr[count1] + 2) * resize)
      case njustify == 2 //center not implemented
         draw line in window printgrid at row,tempcol to row,tempcol+pl
   end case
   tempcol := tempcol + ((sizesarr[count1] + 2) * resize)
next count1
return nil

function columnsizeverify
local lineno := printgrid.columns.value
if .not. iscontroldefined(browseprintcancel,printgrid)
   return nil
endif
IF lineno > 0
   if this.cellvalue >= max(sizes[lineno],headersizes[lineno])
      columnarr[lineno,3] := this.cellvalue
      return .t.
   else
      if ajustify[lineno] == 1
         return .f.
      else
         columnarr[lineno,3] := this.cellvalue
         return .t.
      endif   
   endif
ENDIF
return .t.

function columnselected
local lineno := printgrid.columns.value
if .not. iscontroldefined(browseprintcancel,printgrid)
   return nil
endif
IF lineno > 0
   if this.cellvalue == 1
      columnarr[lineno,1] := 1
   else
      columnarr[lineno,1] := 2
   endif
endif
return .t.

function columnsumchanged
/*
local lineno := printgrid.columns.value
if .not. iscontroldefined(browseprintcancel,printgrid)
   return nil
endif
IF lineno > 0
   columnarr[lineno,4] := this.cellvalue
endif
*/
return .t.



function columntypeverify
/*
LOCAL lineno := printgrid.columns.value
IF lineno > 0
   if ajustify[lineno] == 0 .or. ajustify[lineno] == 2
      return .f.
   else
      return .t.
   endif
ENDIF
*/
return .f.

function mergeheaderschanged
local count1 := 0
local linedetails := {}
asize(mergehead,0)
for count1 := 1 to printgrid.merge.itemcount
   linedetails := printgrid.merge.item(count1)
   if linedetails[2] >= linedetails[1] .and. iif((count1 > 1 .and. HMG_LEN(mergehead) > 0),linedetails[1] > mergehead[count1-1,2],.t.)
      aadd(mergehead,{linedetails[1],linedetails[2],linedetails[3]})
   else 
      msgstop(msgarr[65]+alltrim(str(count1)))
   endif 
next count1
printgridpreview()
return nil


function addmergeheadrow
local from1 := 1
local to1 := 1
if HMG_LEN(mergehead) > 0
   if mergehead[HMG_LEN(mergehead),2] < HMG_LEN(columnarr)
      from1 := mergehead[HMG_LEN(mergehead),2] + 1
      to1 := from1
      printgrid.merge.additem({from1,to1,""})
      mergeheaderschanged()
   endif
else
   printgrid.merge.additem({from1,to1,""})
   mergeheaderschanged()
endif
return nil

function delmergeheadrow
local lineno := printgrid.merge.value
if lineno > 0
   printgrid.merge.deleteitem(lineno)
   if lineno > 1
      printgrid.merge.value := lineno - 1
   else
      if printgrid.merge.itemcount > 0
         printgrid.merge.value := 1
      endif
   endif
   mergeheaderschanged()
endif
return nil
  

function stripcomma(string,decimalsymbol,commasymbol)
LOCAL xValue := ""
local i := 0
local char := ""
default decimalsymbol := "."
default commasymbol := ","
string := alltrim(string)

for i := HMG_LEN(string) to 1 step -1
   char := HB_USUBSTR(string,i,1)
   if HMG_ISDIGIT(char) .or. char == decimalsymbol
      xvalue := char+xvalue
   endif
next i
if HB_UAT("-",string) > 0 .or. HB_UAT("DB",string) > 0 .or. (HB_UAT("(",string) > 0 .and. HB_UAT(")",string) > 0)
   xvalue := "-"+xvalue
endif
return xvalue

function printgridinit
local gridprintdata := array(20)
local count1 := 0
local controlname := ""
local linedata := {}
gridprintdata[1] := {}
gridprintdata[2] := {}
gridprintdata[3] := ""
gridprintdata[4] := 0
gridprintdata[5] := 0
gridprintdata[6] := 0
gridprintdata[7] := .f.
gridprintdata[8] := .f.
gridprintdata[9] := .f.
gridprintdata[10] := .f.
gridprintdata[11] := 0
gridprintdata[12] := 0
gridprintdata[13] := 0
gridprintdata[14] := 0.0
gridprintdata[15] := 0.0
gridprintdata[16] := 0.0
gridprintdata[17] := 0.0
gridprintdata[18] := 0.0
gridprintdata[19] := 0.0
gridprintdata[20] := {}
if .not. file("reports.cfg") .or. HMG_LEN(aColWidths) > 0 
   return nil
endif
begin ini file "reports.cfg"
   if lArrayMode
      return nil
   endif
   get controlname section windowname+"_"+gridname entry "controlname" default ""
   if HMG_UPPER(alltrim(controlname)) == HMG_UPPER(alltrim(windowname+"_"+gridname))
      get gridprintdata[1] section windowname+"_"+gridname entry "gridprintdata1"
      get gridprintdata[2] section windowname+"_"+gridname entry "gridprintdata2"
      get gridprintdata[3] section windowname+"_"+gridname entry "gridprintdata3"
      get gridprintdata[4] section windowname+"_"+gridname entry "gridprintdata4"
      get gridprintdata[5] section windowname+"_"+gridname entry "gridprintdata5"
      get gridprintdata[6] section windowname+"_"+gridname entry "gridprintdata6"
      get gridprintdata[7] section windowname+"_"+gridname entry "gridprintdata7"
      get gridprintdata[8] section windowname+"_"+gridname entry "gridprintdata8"
      get gridprintdata[9] section windowname+"_"+gridname entry "gridprintdata9"
      get gridprintdata[10] section windowname+"_"+gridname entry "gridprintdata10"
      get gridprintdata[11] section windowname+"_"+gridname entry "gridprintdata11"
      get gridprintdata[12] section windowname+"_"+gridname entry "gridprintdata12"
      get gridprintdata[13] section windowname+"_"+gridname entry "gridprintdata13"
      get gridprintdata[14] section windowname+"_"+gridname entry "gridprintdata14"
      get gridprintdata[15] section windowname+"_"+gridname entry "gridprintdata15"
      get gridprintdata[16] section windowname+"_"+gridname entry "gridprintdata16"
      get gridprintdata[17] section windowname+"_"+gridname entry "gridprintdata17"
      get gridprintdata[18] section windowname+"_"+gridname entry "gridprintdata18"
      get gridprintdata[19] section windowname+"_"+gridname entry "gridprintdata19"
      get gridprintdata[20] section windowname+"_"+gridname entry "gridprintdata20"
      // columns
      printgrid.columns.deleteallitems()
      asize(columnarr,0)
      for count1 := 1 to HMG_LEN(gridprintdata[1])
         linedata := gridprintdata[1,count1]
         aadd(columnarr,{int(linedata[3]),linedata[1],linedata[2],ajustify[count1]})
         printgrid.columns.additem({linedata[1],linedata[2],int(linedata[3])})
      next count1   
      if printgrid.columns.itemcount > 0
         printgrid.columns.value := 1
      endif         
      // headers
      printgrid.header1.value := iif(HMG_LEN(alltrim(header1)) == 0,gridprintdata[2,1],header1)
      printgrid.header2.value := iif(HMG_LEN(alltrim(header2)) == 0,gridprintdata[2,2],header2)
      printgrid.header3.value := iif(HMG_LEN(alltrim(header3)) == 0,gridprintdata[2,3],header3)
      // footer
      printgrid.footer1.value := gridprintdata[3]
      //fontsize
      printgrid.selectfontsize.value := int(gridprintdata[4])
      // wordwrap
      printgrid.wordwrap.value := int(gridprintdata[5])
      // pagination
      printgrid.pageno.value := int(gridprintdata[6])
      // collines
      printgrid.collines.value := gridprintdata[7]
      // rowlines
      printgrid.rowlines.value := gridprintdata[8]
      // vertical center
      printgrid.vertical.value := gridprintdata[9]
      // space spread
      printgrid.spread.value := gridprintdata[10]
      // orientation
      printgrid.paperorientation.value := gridprintdata[11]
      // printers
      printgrid.printers.value := int(gridprintdata[12])
      // pagesize
      printgrid.pagesizes.value := gridprintdata[13]
      // paper width
      printgrid.width.value := gridprintdata[14]
      // paper height
      printgrid.height.value := gridprintdata[15]
      // margin top
      printgrid.top.value := gridprintdata[16]
      // margin right
      printgrid.right.value := gridprintdata[17]
      // margin left
      printgrid.left.value := gridprintdata[18]
      // margin bottom
      printgrid.bottom.value := gridprintdata[19]
      // merge headers data
      printgrid.merge.deleteallitems()
      for count1 := 1 to HMG_LEN(gridprintdata[20])
         linedata := gridprintdata[20,count1]
         printgrid.merge.additem({int(linedata[1]),int(linedata[2]),linedata[3]})
      next count1
      if printgrid.merge.itemcount > 0
         printgrid.merge.value := 1
      endif         
      printcoltally()
      printgridpreview()
   endif
end ini
return nil

function resetprintgridform
local controlname := ""
if msgyesno(msgarr[67])
   if .not. file("reports.cfg")
      return nil
   endif
   begin ini file "reports.cfg"
      if lArrayMode
         return nil
      endif
      get controlname section windowname+"_"+gridname entry "controlname" default ""
      if HMG_UPPER(alltrim(controlname)) == HMG_UPPER(alltrim(windowname+"_"+gridname))
         del section windowname+"_"+gridname
      endif
   end ini
   printgrid.merge.deleteallitems()
   printgrid.spread.value := .f.
   printgrid.collines.value := .t.
   printgrid.rowlines.value := .t.
   printgrid.wordwrap.value := 2
   printgrid.pageno.value := 2
   printgrid.vertical.value := .t.
   for count1 := 1 to HMG_LEN(mergehead)
      if mergehead[count1,2] >= mergehead[count1,1] .and. iif(count1 > 1,mergehead[count1,1] > mergehead[count1-1,2],.t.)
         printgrid.merge.additem({mergehead[count1,1],mergehead[count1,2],mergehead[count1,3]})
      endif 
   next count1
   if printgrid.merge.itemcount > 0
      printgrid.merge.value := 1
   endif
   calculatecolumnsizes()
   papersizechanged()
endif
return nil


function init_messages
local cLang := Set ( _SET_LANGUAGE )
IF _HMG_SYSDATA [ 211 ] == 'FI'      // FINNISH
   cLang := 'FI'
ELSEIF _HMG_SYSDATA [ 211 ] == 'NL'   // DUTCH
   cLang := 'NL'
ENDIF

do case

   case cLang == "TRWIN" .OR. cLang == "TR"
      msgarr := {"Yazd?r?lacak bir s,ey yok",;
                 "Kurulu yaz?c? yok!",;
                 "Yazd?rma Sihirbaz?",;
                 "Rapor Yaz?c?",;
                 "Sütunlar",;
                 "Sütun Ad?",;
                 "Genis,lik (mm)",;
                 "Yaz?c? seçimi için bir sütunu çift t?klay?n",;
                 "Metin sütun genis,lig(ini deg(is,tir",;
                 "Toplam Genis,lik :",;
                 "d?s,?nda",;
                 "Bas,l?k 1",;
                 "Bas,l?k 2",;
                 "Bas,l?k 3",;
                 "Altl?k 1",;
                 "Rapor Özellikleri",;
                 "Font Boyutu",;
                 "Uzun Sat?r",;
                 "Sözcük kayd?r",;
                 "Kes",;
                 "Sayfalama",;
                 "Kapal?",;
                 "Üst",;
                 "Alt",;
                 "Izgara Sat?rlar?",;
                 "Sütun",;
                 "Sat?r",;
                 "Sayfa Ortalama",;
                 "Dikey",;
                 "Sayfa/Yaz?c?",;
                 "Bask? Yönü",;
                 "Manzara",;
                 "Portre",;
                 "Yaz?c?: ",;
                 "Sayfa Boyutu",;
                 "Sayfa Genis,lig(i",;
                 "Sayfa Yükseklig(i",;
                 "Kenar Bos,luklar? (mm)",;
                 "Üst",;
                 "Sag(",;
                 "Sol",;
                 "Alt",;
                 "Yazd?r",;
                 "I.ptal",;
                 "Yazd?rma Sihirbaz?na Hos,geldiniz",;
                 "Sayfan?n alabileceg(inden fazla sütun seçtiniz!",;
                 "Bir Yaz?c? Seçmelisiniz!",;
                 "Yaz?c? seçilmedi! Yaz?c? var m? denetle.",;
                 "Sayfa No. :",;
                 "Boyut :",;
                 "Tamam",;
                 "Metin türü d?s,?nda Sütun Boyutu deg(is,tirilemez!",;
                 "Yanas,t?rma sabitleri düzgün verilmedi.",;
                 "Whitespace",; //54
                 "Spread",; //55
                 "Apply",; //56
                 "Include",;//57
                 "Sum",;//58
                 "Yes",;//59
                 "No",;//60
                 "Merge Header",; //61
                 "From",; //62
                 "To",; //63
                 "Header",; //64
                 "There is an error in Merge Head definition in line no.",; //65
                   "Reset Form",; //66
                   "All the previous report configuration for this report will be lost! Are you sure to reset the form?",; // 67
                   }
     case cLang ==  "CS" .OR. cLang == "CSWIN"
        msgarr := {"Nothing to print",;    //1
                   "No printers have been installed!",;  //2
                   "Print Wizard",;  //3
                   "Report Writer",; //4
                   "Columns",; //5
                   "Name of the Column",; //6
                   "Width (mm)",; //7
                   "Double Click a Column to toggle between selecting and not selecting for printing.",; //8
                   "Edit Text Column Size",; //9
                   "Total Width :",; //10
                   "out of",;  //11
                   "Header 1",;  //12
                   "Header 2",; //13
                   "Header 3",; //14
                   "Footer 1",; //15
                   "Report Properties",; //16
                   "Font Size",; //17
                   "Lengthy Line",; //18
                   "Word Wrap",; //19
                   "Truncate",; //20
                   "Pagination",; //21
                   "Off",; //22
                   "Top",; //23
                   "Bottom",; //24
                   "Grid Lines",; //25
                   "Column",; //26
                   "Row",; //27
                   "Page Center",; //28
                   "Vertical",; //29
                   "Page/Printer",; //30 
                   "Orientation",; //31
                   "Landscape",; //32
                   "Portrait",; //33
                   "Printer: ",; //34
                   "Page Size",; //35
                   "Page Width",; //36
                   "Page Height",; //37
                   "Margins (mm)",; //38
                   "Top",; //39
                   "Right",; //40
                   "Left",; //41
                   "Bottom",; //42
                   "Print",; //43
                   "Cancel",; //44
                   "Welcome to Print Wizard",; //45
                   "You had selected more columns than to fit in a page!",; //46
                   "You have to select a printer!",; //47
                   "Printer could not be selected! Check Availability of Printer.",; //48
                   "Page No. :",; //49
                   "Size :",; //50
                   "Done",; //51
                   "Size of Columns other than text type can not be modified!",; //52
                   "Justification constants not given properly.",; //53
                   "Whitespace",; //54
                   "Spread",; //55
                   "Apply",; //56
                   "Include",;//57
                   "Sum",;//58
                   "Yes",;//59
                   "No",;//60
                   "Merge Header",; //61
                   "From",; //62
                   "To",; //63
                   "Header",; //64
                   "There is an error in Merge Head definition in line no.",; //65
                   "Reset Form",; //66
                   "All the previous report configuration for this report will be lost! Are you sure to reset the form?",; // 67
                   }
     case cLang == "HR852"
   /////////////////////////////////////////////////////////////
   // CROATIAN
   ////////////////////////////////////////////////////////////
        msgarr := {"Nothing to print",;    //1
                   "No printers have been installed!",;  //2
                   "Print Wizard",;  //3
                   "Report Writer",; //4
                   "Columns",; //5
                   "Name of the Column",; //6
                   "Width (mm)",; //7
                   "Double Click a Column to toggle between selecting and not selecting for printing.",; //8
                   "Edit Text Column Size",; //9
                   "Total Width :",; //10
                   "out of",;  //11
                   "Header 1",;  //12
                   "Header 2",; //13
                   "Header 3",; //14
                   "Footer 1",; //15
                   "Report Properties",; //16
                   "Font Size",; //17
                   "Lengthy Line",; //18
                   "Word Wrap",; //19
                   "Truncate",; //20
                   "Pagination",; //21
                   "Off",; //22
                   "Top",; //23
                   "Bottom",; //24
                   "Grid Lines",; //25
                   "Column",; //26
                   "Row",; //27
                   "Page Center",; //28
                   "Vertical",; //29
                   "Page/Printer",; //30 
                   "Orientation",; //31
                   "Landscape",; //32
                   "Portrait",; //33
                   "Printer: ",; //34
                   "Page Size",; //35
                   "Page Width",; //36
                   "Page Height",; //37
                   "Margins (mm)",; //38
                   "Top",; //39
                   "Right",; //40
                   "Left",; //41
                   "Bottom",; //42
                   "Print",; //43
                   "Cancel",; //44
                   "Welcome to Print Wizard",; //45
                   "You had selected more columns than to fit in a page!",; //46
                   "You have to select a printer!",; //47
                   "Printer could not be selected! Check Availability of Printer.",; //48
                   "Page No. :",; //49
                   "Size :",; //50
                   "Done",; //51
                   "Size of Columns other than text type can not be modified!",; //52
                   "Justification constants not given properly.",; //53
                   "Whitespace",; //54
                   "Spread",; //55
                   "Apply",; //56
                   "Include",;//57
                   "Sum",;//58
                   "Yes",;//59
                   "No",;//60
                   "Merge Header",; //61
                   "From",; //62
                   "To",; //63
                   "Header",; //64
                   "There is an error in Merge Head definition in line no.",; //65
                   "Reset Form",; //66
                   "All the previous report configuration for this report will be lost! Are you sure to reset the form?",; // 67
                   }
     case cLang == "EU"
   /////////////////////////////////////////////////////////////
   // BASQUE
   ////////////////////////////////////////////////////////////
        msgarr := {"Nothing to print",;    //1
                   "No printers have been installed!",;  //2
                   "Print Wizard",;  //3
                   "Report Writer",; //4
                   "Columns",; //5
                   "Name of the Column",; //6
                   "Width (mm)",; //7
                   "Double Click a Column to toggle between selecting and not selecting for printing.",; //8
                   "Edit Text Column Size",; //9
                   "Total Width :",; //10
                   "out of",;  //11
                   "Header 1",;  //12
                   "Header 2",; //13
                   "Header 3",; //14
                   "Footer 1",; //15
                   "Report Properties",; //16
                   "Font Size",; //17
                   "Lengthy Line",; //18
                   "Word Wrap",; //19
                   "Truncate",; //20
                   "Pagination",; //21
                   "Off",; //22
                   "Top",; //23
                   "Bottom",; //24
                   "Grid Lines",; //25
                   "Column",; //26
                   "Row",; //27
                   "Page Center",; //28
                   "Vertical",; //29
                   "Page/Printer",; //30 
                   "Orientation",; //31
                   "Landscape",; //32
                   "Portrait",; //33
                   "Printer: ",; //34
                   "Page Size",; //35
                   "Page Width",; //36
                   "Page Height",; //37
                   "Margins (mm)",; //38
                   "Top",; //39
                   "Right",; //40
                   "Left",; //41
                   "Bottom",; //42
                   "Print",; //43
                   "Cancel",; //44
                   "Welcome to Print Wizard",; //45
                   "You had selected more columns than to fit in a page!",; //46
                   "You have to select a printer!",; //47
                   "Printer could not be selected! Check Availability of Printer.",; //48
                   "Page No. :",; //49
                   "Size :",; //50
                   "Done",; //51
                   "Size of Columns other than text type can not be modified!",; //52
                   "Justification constants not given properly.",; //53
                   "Whitespace",; //54
                   "Spread",; //55
                   "Apply",; //56
                   "Include",;//57
                   "Sum",;//58
                   "Yes",;//59
                   "No",;//60
                   "Merge Header",; //61
                   "From",; //62
                   "To",; //63
                   "Header",; //64
                   "There is an error in Merge Head definition in line no.",; //65
                   "Reset Form",; //66
                   "All the previous report configuration for this report will be lost! Are you sure to reset the form?",; // 67
                   }
     case cLang == "EN"
   /////////////////////////////////////////////////////////////
   // ENGLISH
   ////////////////////////////////////////////////////////////
        msgarr := {"Nothing to print",;    //1
                   "No printers have been installed!",;  //2
                   "Print Wizard",;  //3
                   "Report Writer",; //4
                   "Columns",; //5
                   "Name of the Column",; //6
                   "Width (mm)",; //7
                   "Double Click a Column to toggle between selecting and not selecting for printing.",; //8
                   "Edit Text Column Size",; //9
                   "Total Width :",; //10
                   "out of",;  //11
                   "Header 1",;  //12
                   "Header 2",; //13
                   "Header 3",; //14
                   "Footer 1",; //15
                   "Report Properties",; //16
                   "Font Size",; //17
                   "Lengthy Line",; //18
                   "Word Wrap",; //19
                   "Truncate",; //20
                   "Pagination",; //21
                   "Off",; //22
                   "Top",; //23
                   "Bottom",; //24
                   "Grid Lines",; //25
                   "Column",; //26
                   "Row",; //27
                   "Page Center",; //28
                   "Vertical",; //29
                   "Page/Printer",; //30 
                   "Orientation",; //31
                   "Landscape",; //32
                   "Portrait",; //33
                   "Printer: ",; //34
                   "Page Size",; //35
                   "Page Width",; //36
                   "Page Height",; //37
                   "Margins (mm)",; //38
                   "Top",; //39
                   "Right",; //40
                   "Left",; //41
                   "Bottom",; //42
                   "Print",; //43
                   "Cancel",; //44
                   "Welcome to Print Wizard",; //45
                   "You had selected more columns than to fit in a page!",; //46
                   "You have to select a printer!",; //47
                   "Printer could not be selected! Check Availability of Printer.",; //48
                   "Page No. :",; //49
                   "Size :",; //50
                   "Done",; //51
                   "Size of Columns other than text type can not be modified!",; //52
                   "Justification constants not given properly.",; //53
                   "Whitespace",; //54
                   "Spread",; //55
                   "Apply",; //56
                   "Include",;//57
                   "Sum",;//58
                   "Yes",;//59
                   "No",;//60
                   "Merge Header",; //61
                   "From",; //62
                   "To",; //63
                   "Header",; //64
                   "There is an error in Merge Head definition in line no.",; //65
                   "Reset Form",; //66
                   "All the previous report configuration for this report will be lost! Are you sure to reset the form?",; // 67
                   }
     case cLang == "FR"
   /////////////////////////////////////////////////////////////
   // FRENCH
   ////////////////////////////////////////////////////////////
        msgarr := {"Nothing to print",;    //1
                   "No printers have been installed!",;  //2
                   "Print Wizard",;  //3
                   "Report Writer",; //4
                   "Columns",; //5
                   "Name of the Column",; //6
                   "Width (mm)",; //7
                   "Double Click a Column to toggle between selecting and not selecting for printing.",; //8
                   "Edit Text Column Size",; //9
                   "Total Width :",; //10
                   "out of",;  //11
                   "Header 1",;  //12
                   "Header 2",; //13
                   "Header 3",; //14
                   "Footer 1",; //15
                   "Report Properties",; //16
                   "Font Size",; //17
                   "Lengthy Line",; //18
                   "Word Wrap",; //19
                   "Truncate",; //20
                   "Pagination",; //21
                   "Off",; //22
                   "Top",; //23
                   "Bottom",; //24
                   "Grid Lines",; //25
                   "Column",; //26
                   "Row",; //27
                   "Page Center",; //28
                   "Vertical",; //29
                   "Page/Printer",; //30 
                   "Orientation",; //31
                   "Landscape",; //32
                   "Portrait",; //33
                   "Printer: ",; //34
                   "Page Size",; //35
                   "Page Width",; //36
                   "Page Height",; //37
                   "Margins (mm)",; //38
                   "Top",; //39
                   "Right",; //40
                   "Left",; //41
                   "Bottom",; //42
                   "Print",; //43
                   "Cancel",; //44
                   "Welcome to Print Wizard",; //45
                   "You had selected more columns than to fit in a page!",; //46
                   "You have to select a printer!",; //47
                   "Printer could not be selected! Check Availability of Printer.",; //48
                   "Page No. :",; //49
                   "Size :",; //50
                   "Done",; //51
                   "Size of Columns other than text type can not be modified!",; //52
                   "Justification constants not given properly.",; //53
                   "Whitespace",; //54
                   "Spread",; //55
                   "Apply",; //56
                   "Include",;//57
                   "Sum",;//58
                   "Yes",;//59
                   "No",;//60
                   "Merge Header",; //61
                   "From",; //62
                   "To",; //63
                   "Header",; //64
                   "There is an error in Merge Head definition in line no.",; //65
                   "Reset Form",; //66
                   "All the previous report configuration for this report will be lost! Are you sure to reset the form?",; // 67
                   }
     case cLang == "DEWIN" .OR. cLang == "DE"
   /////////////////////////////////////////////////////////////
   // GERMAN
   ////////////////////////////////////////////////////////////
        msgarr := {"Nothing to print",;    //1
                   "No printers have been installed!",;  //2
                   "Print Wizard",;  //3
                   "Report Writer",; //4
                   "Columns",; //5
                   "Name of the Column",; //6
                   "Width (mm)",; //7
                   "Double Click a Column to toggle between selecting and not selecting for printing.",; //8
                   "Edit Text Column Size",; //9
                   "Total Width :",; //10
                   "out of",;  //11
                   "Header 1",;  //12
                   "Header 2",; //13
                   "Header 3",; //14
                   "Footer 1",; //15
                   "Report Properties",; //16
                   "Font Size",; //17
                   "Lengthy Line",; //18
                   "Word Wrap",; //19
                   "Truncate",; //20
                   "Pagination",; //21
                   "Off",; //22
                   "Top",; //23
                   "Bottom",; //24
                   "Grid Lines",; //25
                   "Column",; //26
                   "Row",; //27
                   "Page Center",; //28
                   "Vertical",; //29
                   "Page/Printer",; //30 
                   "Orientation",; //31
                   "Landscape",; //32
                   "Portrait",; //33
                   "Printer: ",; //34
                   "Page Size",; //35
                   "Page Width",; //36
                   "Page Height",; //37
                   "Margins (mm)",; //38
                   "Top",; //39
                   "Right",; //40
                   "Left",; //41
                   "Bottom",; //42
                   "Print",; //43
                   "Cancel",; //44
                   "Welcome to Print Wizard",; //45
                   "You had selected more columns than to fit in a page!",; //46
                   "You have to select a printer!",; //47
                   "Printer could not be selected! Check Availability of Printer.",; //48
                   "Page No. :",; //49
                   "Size :",; //50
                   "Done",; //51
                   "Size of Columns other than text type can not be modified!",; //52
                   "Justification constants not given properly.",; //53
                   "Whitespace",; //54
                   "Spread",; //55
                   "Apply",; //56
                   "Include",;//57
                   "Sum",;//58
                   "Yes",;//59
                   "No",;//60
                   "Merge Header",; //61
                   "From",; //62
                   "To",; //63
                   "Header",; //64
                   "There is an error in Merge Head definition in line no.",; //65
                   "Reset Form",; //66
                   "All the previous report configuration for this report will be lost! Are you sure to reset the form?",; // 67
                   }
   case cLang == "IT"
   /////////////////////////////////////////////////////////////
   // ITALIAN
   ////////////////////////////////////////////////////////////
        msgarr := {"Nothing to print",;    //1
                   "No printers have been installed!",;  //2
                   "Print Wizard",;  //3
                   "Report Writer",; //4
                   "Columns",; //5
                   "Name of the Column",; //6
                   "Width (mm)",; //7
                   "Double Click a Column to toggle between selecting and not selecting for printing.",; //8
                   "Edit Text Column Size",; //9
                   "Total Width :",; //10
                   "out of",;  //11
                   "Header 1",;  //12
                   "Header 2",; //13
                   "Header 3",; //14
                   "Footer 1",; //15
                   "Report Properties",; //16
                   "Font Size",; //17
                   "Lengthy Line",; //18
                   "Word Wrap",; //19
                   "Truncate",; //20
                   "Pagination",; //21
                   "Off",; //22
                   "Top",; //23
                   "Bottom",; //24
                   "Grid Lines",; //25
                   "Column",; //26
                   "Row",; //27
                   "Page Center",; //28
                   "Vertical",; //29
                   "Page/Printer",; //30 
                   "Orientation",; //31
                   "Landscape",; //32
                   "Portrait",; //33
                   "Printer: ",; //34
                   "Page Size",; //35
                   "Page Width",; //36
                   "Page Height",; //37
                   "Margins (mm)",; //38
                   "Top",; //39
                   "Right",; //40
                   "Left",; //41
                   "Bottom",; //42
                   "Print",; //43
                   "Cancel",; //44
                   "Welcome to Print Wizard",; //45
                   "You had selected more columns than to fit in a page!",; //46
                   "You have to select a printer!",; //47
                   "Printer could not be selected! Check Availability of Printer.",; //48
                   "Page No. :",; //49
                   "Size :",; //50
                   "Done",; //51
                   "Size of Columns other than text type can not be modified!",; //52
                   "Justification constants not given properly.",; //53
                   "Whitespace",; //54
                   "Spread",; //55
                   "Apply",; //56
                   "Include",;//57
                   "Sum",;//58
                   "Yes",;//59
                   "No",;//60
                   "Merge Header",; //61
                   "From",; //62
                   "To",; //63
                   "Header",; //64
                   "There is an error in Merge Head definition in line no.",; //65
                   "Reset Form",; //66
                   "All the previous report configuration for this report will be lost! Are you sure to reset the form?",; // 67
                   }
     case cLang == "PLWIN"  .OR. cLang == "PL852"  .OR. cLang == "PLISO"  .OR. cLang == ""  .OR. cLang == "PLMAZ"
   /////////////////////////////////////////////////////////////
   // POLISH
   ////////////////////////////////////////////////////////////
        curpagesize := 5
        msgarr := {"Brak danych do druku!",;    //1
                   "Brak zainstalowanych drukarek w systemie!",;  //2
                   "Kreator wydruku",;  //3
                   "Kreator zapisu",; //4
                   "Kolumny",; //5
                   "Nazwa kolumny",; //6
                   "Szerokos'c' (mm)",; //7
                   "Kliknij dwa razy na kolumnie, aby ja; zaznaczyc'/odznaczyc' do wydruku",; //8
                   "Zmien' rozmiar kolumny tekstowej",; //9
                   "Ca?kowitta szerokos'c':",; //10
                   "z",;  //11
                   "Nag?ówek 1",;  //12
                   "Nag?ówek 2",; //13
                   "Nag?ówek 3",; //14
                   "Stopka 1",; //15
                   "W?asnos'ci raportu",; //16
                   "Rozmiar czcionki",; //17
                   "D?ugie teksty",; //18
                   "Zawijanie s?ów",; //19
                   "Obcie;cie",; //20
                   "Numeracja stron",; //21
                   "Wy?a;czona",; //22
                   "Góra",; //23
                   "Dó?",; //24
                   "Linie siatki",; //25
                   "Kolumna",; //26
                   "Wiersz",; //27
                   "Centruj strone;",; //28
                   "Pionowy",; //29
                   "Strona/Drukarka",; //30
                   "Orientacja",; //31
                   "Pozioma",; //32
                   "Pionowa",; //33
                   "Drukarka: ",; //34
                   "Rozmiar strony",; //35
                   "Szerokos'c' strony",; //36
                   "Wysokos'c' strony",; //37
                   "Marginesy (mm)",; //38
                   "Górny",; //39
                   "Prawy",; //40
                   "Lewy",; //41
                   "Dolny",; //42
                   "Drukuj",; //43
                   "Anuluj",; //44
                   "Witaj w Kreatorze Wydruku",; //45
                   "Wybra?es' wie;cej kolumn, niz. moz.na zmies'cic' na stronie!",; //46
                   "Musisz wybrac' drukarke;!",; //47
                   "Nie moz.na wybrac' drukarki! Sprawdz' jej doste;pnos'c'.",; //48
                   "Numer strony:",; //49
                   "Rozmiar:",; //50
                   "Wykonano",; //51
                   "Nie moz.na zmieniac' rozmiau nietekstowych kolumn!",; //52
                   "Justyfikacja okres'lona nieprawid?owo.",; //53
                   "Puste przestrzenie",; //54
                   "Rozszerz",; //55
                   "Zastosuj",; //56
                   "Do?a;cz",;//57
                   "Suma",;//58
                   "Tak",;//59
                   "Nie",;//60
                   "Do?a;cz nag?ówek",; //61
                   "Od",; //62
                   "Do",; //63
                   "Nag?ówek",; //64
                   "Pojawi? sie; b?a;d w definicji do?a;czanego nag?ówka w linii  nr ",; //65
                   "Reset Form",; //66
                   "All the previous report configuration for this report will be lost! Are you sure to reset the form?",; // 67
                   }
     case cLang == "pt.PT850"
   /////////////////////////////////////////////////////////////
   // PORTUGUESE
   ////////////////////////////////////////////////////////////
        msgarr := {"Nothing to print",;    //1
                   "No printers have been installed!",;  //2
                   "Print Wizard",;  //3
                   "Report Writer",; //4
                   "Columns",; //5
                   "Name of the Column",; //6
                   "Width (mm)",; //7
                   "Double Click a Column to toggle between selecting and not selecting for printing.",; //8
                   "Edit Text Column Size",; //9
                   "Total Width :",; //10
                   "out of",;  //11
                   "Header 1",;  //12
                   "Header 2",; //13
                   "Header 3",; //14
                   "Footer 1",; //15
                   "Report Properties",; //16
                   "Font Size",; //17
                   "Lengthy Line",; //18
                   "Word Wrap",; //19
                   "Truncate",; //20
                   "Pagination",; //21
                   "Off",; //22
                   "Top",; //23
                   "Bottom",; //24
                   "Grid Lines",; //25
                   "Column",; //26
                   "Row",; //27
                   "Page Center",; //28
                   "Vertical",; //29
                   "Page/Printer",; //30 
                   "Orientation",; //31
                   "Landscape",; //32
                   "Portrait",; //33
                   "Printer: ",; //34
                   "Page Size",; //35
                   "Page Width",; //36
                   "Page Height",; //37
                   "Margins (mm)",; //38
                   "Top",; //39
                   "Right",; //40
                   "Left",; //41
                   "Bottom",; //42
                   "Print",; //43
                   "Cancel",; //44
                   "Welcome to Print Wizard",; //45
                   "You had selected more columns than to fit in a page!",; //46
                   "You have to select a printer!",; //47
                   "Printer could not be selected! Check Availability of Printer.",; //48
                   "Page No. :",; //49
                   "Size :",; //50
                   "Done",; //51
                   "Size of Columns other than text type can not be modified!",; //52
                   "Justification constants not given properly.",; //53
                   "Whitespace",; //54
                   "Spread",; //55
                   "Apply",; //56
                   "Include",;//57
                   "Sum",;//58
                   "Yes",;//59
                   "No",;//60
                   "Merge Header",; //61
                   "From",; //62
                   "To",; //63
                   "Header",; //64
                   "There is an error in Merge Head definition in line no.",; //65
                   "Reset Form",; //66
                   "All the previous report configuration for this report will be lost! Are you sure to reset the form?",; // 67
                   }
     case cLang == "RUWIN"  .OR. cLang == "RU866" .OR. cLang == "RUKOI8"
   /////////////////////////////////////////////////////////////
   // RUSSIAN
   ////////////////////////////////////////////////////////////
        msgarr := {"Nothing to print",;    //1
                   "No printers have been installed!",;  //2
                   "Print Wizard",;  //3
                   "Report Writer",; //4
                   "Columns",; //5
                   "Name of the Column",; //6
                   "Width (mm)",; //7
                   "Double Click a Column to toggle between selecting and not selecting for printing.",; //8
                   "Edit Text Column Size",; //9
                   "Total Width :",; //10
                   "out of",;  //11
                   "Header 1",;  //12
                   "Header 2",; //13
                   "Header 3",; //14
                   "Footer 1",; //15
                   "Report Properties",; //16
                   "Font Size",; //17
                   "Lengthy Line",; //18
                   "Word Wrap",; //19
                   "Truncate",; //20
                   "Pagination",; //21
                   "Off",; //22
                   "Top",; //23
                   "Bottom",; //24
                   "Grid Lines",; //25
                   "Column",; //26
                   "Row",; //27
                   "Page Center",; //28
                   "Vertical",; //29
                   "Page/Printer",; //30 
                   "Orientation",; //31
                   "Landscape",; //32
                   "Portrait",; //33
                   "Printer: ",; //34
                   "Page Size",; //35
                   "Page Width",; //36
                   "Page Height",; //37
                   "Margins (mm)",; //38
                   "Top",; //39
                   "Right",; //40
                   "Left",; //41
                   "Bottom",; //42
                   "Print",; //43
                   "Cancel",; //44
                   "Welcome to Print Wizard",; //45
                   "You had selected more columns than to fit in a page!",; //46
                   "You have to select a printer!",; //47
                   "Printer could not be selected! Check Availability of Printer.",; //48
                   "Page No. :",; //49
                   "Size :",; //50
                   "Done",; //51
                   "Size of Columns other than text type can not be modified!",; //52
                   "Justification constants not given properly.",; //53
                   "Whitespace",; //54
                   "Spread",; //55
                   "Apply",; //56
                   "Include",;//57
                   "Sum",;//58
                   "Yes",;//59
                   "No",;//60
                   "Merge Header",; //61
                   "From",; //62
                   "To",; //63
                   "Header",; //64
                   "There is an error in Merge Head definition in line no.",; //65
                   "Reset Form",; //66
                   "All the previous report configuration for this report will be lost! Are you sure to reset the form?",; // 67
                   }
     case cLang == "ES"  .OR. cLang == "ESWIN"
   /////////////////////////////////////////////////////////////
   // SPANISH
   ////////////////////////////////////////////////////////////

        msgarr := {"Nada para imprimir",;
                   "No hay impresoras instaladas!",;
                   "Asistente de Impresión",;
                   "Generador de Reportes",;
                   "Columnas",;
                   "Nombre de la columna",;
                   "Ancho (mm)",;
                   "Doble clic en una columna para seleccionar o deselecionarla para impresión",;
                   "Editar tamaño del texto de columna",;
                   "Ancho Total :",;
                   "out of",;
                   "Encabezado 1",;
                   "Encabezado 2",;
                   "Encabezado 3",;
                   "Pie de Página 1",;
                   "Propiedades del Reporte",;
                   "Tamaño de Fuente",;
                   "Línea larga",;
                   "Ajuste de Línea",;
                   "Truncar",;
                   "Paginación",;
                   "Apagado",;
                   "Superior",;
                   "Inferior",;
                   "Líneas de Grilla",;
                   "Columna",;
                   "Fila",;
                   "Centrado de Página",;
                   "Vertical",;
                   "Página/Impresora",;
                   "Orientación",;
                   "Horizontal",;
                   "Vertical",;
                   "Impresora: ",;
                   "Tamaño de Página",;
                   "Ancho de Página",;
                   "Altura de Página",;
                   "Márgenes (mm)",;
                   "Superior",;
                   "Derecho",;
                   "Izquierdo",;
                   "Inferior",;
                   "Imprimir",;
                   "Cancelar",;
                   "Bienvenido al asistente de Impresión",;
                   "Ha seleccionado más columnas de las que entran en una página!",;
                   "You have to select a printer!",;
                   "La impresora no puede ser seleccionada! Verifique la disponibilidad de la impresora.",;
                   "Página Nro. :",;
                   "Tamaño :",;
                   "Hecho",;
                   "EL tamaño de las columnas que no sean del tipo texto no pueden modificarse!",;
                   "Constantes de justificación no dadas apropiadamente.",;
                   "Whitespace",; //54
                   "Spread",; //55
                   "Apply",; //56
                   "Include",;//57
                   "Sum",;//58
                   "Yes",;//59
                   "No",;//60
                   "Merge Header",; //61
                   "From",; //62
                   "To",; //63
                   "Header",; //64
                   "There is an error in Merge Head definition in line no.",; //65
                   "Reset Form",; //66
                   "All the previous report configuration for this report will be lost! Are you sure to reset the form?",; // 67
                   }
     case cLang == "FI"
   ///////////////////////////////////////////////////////////////////////
   // FINNISH
   ///////////////////////////////////////////////////////////////////////
        msgarr := {"Nothing to print",;    //1
                   "No printers have been installed!",;  //2
                   "Print Wizard",;  //3
                   "Report Writer",; //4
                   "Columns",; //5
                   "Name of the Column",; //6
                   "Width (mm)",; //7
                   "Double Click a Column to toggle between selecting and not selecting for printing.",; //8
                   "Edit Text Column Size",; //9
                   "Total Width :",; //10
                   "out of",;  //11
                   "Header 1",;  //12
                   "Header 2",; //13
                   "Header 3",; //14
                   "Footer 1",; //15
                   "Report Properties",; //16
                   "Font Size",; //17
                   "Lengthy Line",; //18
                   "Word Wrap",; //19
                   "Truncate",; //20
                   "Pagination",; //21
                   "Off",; //22
                   "Top",; //23
                   "Bottom",; //24
                   "Grid Lines",; //25
                   "Column",; //26
                   "Row",; //27
                   "Page Center",; //28
                   "Vertical",; //29
                   "Page/Printer",; //30 
                   "Orientation",; //31
                   "Landscape",; //32
                   "Portrait",; //33
                   "Printer: ",; //34
                   "Page Size",; //35
                   "Page Width",; //36
                   "Page Height",; //37
                   "Margins (mm)",; //38
                   "Top",; //39
                   "Right",; //40
                   "Left",; //41
                   "Bottom",; //42
                   "Print",; //43
                   "Cancel",; //44
                   "Welcome to Print Wizard",; //45
                   "You had selected more columns than to fit in a page!",; //46
                   "You have to select a printer!",; //47
                   "Printer could not be selected! Check Availability of Printer.",; //48
                   "Page No. :",; //49
                   "Size :",; //50
                   "Done",; //51
                   "Size of Columns other than text type can not be modified!",; //52
                   "Justification constants not given properly.",; //53
                   "Whitespace",; //54
                   "Spread",; //55
                   "Apply",; //56
                   "Include",;//57
                   "Sum",;//58
                   "Yes",;//59
                   "No",;//60
                   "Merge Header",; //61
                   "From",; //62
                   "To",; //63
                   "Header",; //64
                   "There is an error in Merge Head definition in line no.",; //65
                   "Reset Form",; //66
                   "All the previous report configuration for this report will be lost! Are you sure to reset the form?",; // 67
                   }
     case cLang == "NL"
   /////////////////////////////////////////////////////////////
   // DUTCH
   ////////////////////////////////////////////////////////////
        msgarr := {"Nothing to print",;    //1
                   "No printers have been installed!",;  //2
                   "Print Wizard",;  //3
                   "Report Writer",; //4
                   "Columns",; //5
                   "Name of the Column",; //6
                   "Width (mm)",; //7
                   "Double Click a Column to toggle between selecting and not selecting for printing.",; //8
                   "Edit Text Column Size",; //9
                   "Total Width :",; //10
                   "out of",;  //11
                   "Header 1",;  //12
                   "Header 2",; //13
                   "Header 3",; //14
                   "Footer 1",; //15
                   "Report Properties",; //16
                   "Font Size",; //17
                   "Lengthy Line",; //18
                   "Word Wrap",; //19
                   "Truncate",; //20
                   "Pagination",; //21
                   "Off",; //22
                   "Top",; //23
                   "Bottom",; //24
                   "Grid Lines",; //25
                   "Column",; //26
                   "Row",; //27
                   "Page Center",; //28
                   "Vertical",; //29
                   "Page/Printer",; //30 
                   "Orientation",; //31
                   "Landscape",; //32
                   "Portrait",; //33
                   "Printer: ",; //34
                   "Page Size",; //35
                   "Page Width",; //36
                   "Page Height",; //37
                   "Margins (mm)",; //38
                   "Top",; //39
                   "Right",; //40
                   "Left",; //41
                   "Bottom",; //42
                   "Print",; //43
                   "Cancel",; //44
                   "Welcome to Print Wizard",; //45
                   "You had selected more columns than to fit in a page!",; //46
                   "You have to select a printer!",; //47
                   "Printer could not be selected! Check Availability of Printer.",; //48
                   "Page No. :",; //49
                   "Size :",; //50
                   "Done",; //51
                   "Size of Columns other than text type can not be modified!",; //52
                   "Justification constants not given properly.",; //53
                   "Whitespace",; //54
                   "Spread",; //55
                   "Apply",; //56
                   "Include",;//57
                   "Sum",;//58
                   "Yes",;//59
                   "No",;//60
                   "Merge Header",; //61
                   "From",; //62
                   "To",; //63
                   "Header",; //64
                   "There is an error in Merge Head definition in line no.",; //65
                   "Reset Form",; //66
                   "All the previous report configuration for this report will be lost! Are you sure to reset the form?",; // 67
                   }
     case cLang == "SLWIN" .OR. cLang == "SLISO" .OR. cLang == "SL852" .OR. cLang == "" .OR. cLang == "SL437"
     /////////////////////////////////////////////////////////////
   // SLOVENIAN
   ////////////////////////////////////////////////////////////
        msgarr := {"Nothing to print",;    //1
                   "No printers have been installed!",;  //2
                   "Print Wizard",;  //3
                   "Report Writer",; //4
                   "Columns",; //5
                   "Name of the Column",; //6
                   "Width (mm)",; //7
                   "Double Click a Column to toggle between selecting and not selecting for printing.",; //8
                   "Edit Text Column Size",; //9
                   "Total Width :",; //10
                   "out of",;  //11
                   "Header 1",;  //12
                   "Header 2",; //13
                   "Header 3",; //14
                   "Footer 1",; //15
                   "Report Properties",; //16
                   "Font Size",; //17
                   "Lengthy Line",; //18
                   "Word Wrap",; //19
                   "Truncate",; //20
                   "Pagination",; //21
                   "Off",; //22
                   "Top",; //23
                   "Bottom",; //24
                   "Grid Lines",; //25
                   "Column",; //26
                   "Row",; //27
                   "Page Center",; //28
                   "Vertical",; //29
                   "Page/Printer",; //30 
                   "Orientation",; //31
                   "Landscape",; //32
                   "Portrait",; //33
                   "Printer: ",; //34
                   "Page Size",; //35
                   "Page Width",; //36
                   "Page Height",; //37
                   "Margins (mm)",; //38
                   "Top",; //39
                   "Right",; //40
                   "Left",; //41
                   "Bottom",; //42
                   "Print",; //43
                   "Cancel",; //44
                   "Welcome to Print Wizard",; //45
                   "You had selected more columns than to fit in a page!",; //46
                   "You have to select a printer!",; //47
                   "Printer could not be selected! Check Availability of Printer.",; //48
                   "Page No. :",; //49
                   "Size :",; //50
                   "Done",; //51
                   "Size of Columns other than text type can not be modified!",; //52
                   "Justification constants not given properly.",; //53
                   "Whitespace",; //54
                   "Spread",; //55
                   "Apply",; //56
                   "Include",;//57
                   "Sum",;//58
                   "Yes",;//59
                   "No",;//60
                   "Merge Header",; //61
                   "From",; //62
                   "To",; //63
                   "Header",; //64
                   "There is an error in Merge Head definition in line no.",; //65
                   "Reset Form",; //66
                   "All the previous report configuration for this report will be lost! Are you sure to reset the form?",; // 67
                   }
      OtherWise
   /////////////////////////////////////////////////////////////
   // DEFAULT (ENGLISH)
   ////////////////////////////////////////////////////////////
        msgarr := {"Nothing to print",;    //1
                   "No printers have been installed!",;  //2
                   "Print Wizard",;  //3
                   "Report Writer",; //4
                   "Columns",; //5
                   "Name of the Column",; //6
                   "Width (mm)",; //7
                   "Double Click a Column to toggle between selecting and not selecting for printing.",; //8
                   "Edit Text Column Size",; //9
                   "Total Width :",; //10
                   "out of",;  //11
                   "Header 1",;  //12
                   "Header 2",; //13
                   "Header 3",; //14
                   "Footer 1",; //15
                   "Report Properties",; //16
                   "Font Size",; //17
                   "Lengthy Line",; //18
                   "Word Wrap",; //19
                   "Truncate",; //20
                   "Pagination",; //21
                   "Off",; //22
                   "Top",; //23
                   "Bottom",; //24
                   "Grid Lines",; //25
                   "Column",; //26
                   "Row",; //27
                   "Page Center",; //28
                   "Vertical",; //29
                   "Page/Printer",; //30 
                   "Orientation",; //31
                   "Landscape",; //32
                   "Portrait",; //33
                   "Printer: ",; //34
                   "Page Size",; //35
                   "Page Width",; //36
                   "Page Height",; //37
                   "Margins (mm)",; //38
                   "Top",; //39
                   "Right",; //40
                   "Left",; //41
                   "Bottom",; //42
                   "Print",; //43
                   "Cancel",; //44
                   "Welcome to Print Wizard",; //45
                   "You had selected more columns than to fit in a page!",; //46
                   "You have to select a printer!",; //47
                   "Printer could not be selected! Check Availability of Printer.",; //48
                   "Page No. :",; //49
                   "Size :",; //50
                   "Done",; //51
                   "Size of Columns other than text type can not be modified!",; //52
                   "Justification constants not given properly.",; //53
                   "Whitespace",; //54
                   "Spread",; //55
                   "Apply",; //56
                   "Include",;//57
                   "Sum",;//58
                   "Yes",;//59
                   "No",;//60
                   "Merge Header",; //61
                   "From",; //62
                   "To",; //63
                   "Header",; //64
                   "There is an error in Merge Head definition in line no.",; //65
                   "Reset Form",; //66
                   "All the previous report configuration for this report will be lost! Are you sure to reset the form?",; // 67
                   }
endcase
return nil