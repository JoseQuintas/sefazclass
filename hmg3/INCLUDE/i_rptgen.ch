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
	Copyright 1999-2009, http://www.harbour-project.org/

	"WHAT32"
	Copyright 2002 AJ Wos <andrwos@aust1.net> 

	"HWGUI"
  	Copyright 2001-2007 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/

	#xcommand LOAD REPORT <w> ; 
	=> ;
	_HMG_SYSDATA \[ 162 \] := <"w"> ;;
	#include \<<w>.rmg\>  ;;
	#xtranslate \<w\> . Execute ( \<p1\> , \<p2\> ) => ExecuteReport ( \<"w"\> , \<p1\> , \<p2\> )  


* Report Main .................................................................

#xcommand DEFINE REPORT <name> => _DefineReport( <"name">) ; #xtranslate \<name\> . Execute ( \<p1\> , \<p2\> ) => ExecuteReport ( \<"name"\> , \<p1\> , \<p2\> )  

#xcommand END REPORT  => _EndReport() 

#xcommand DEFINE REPORT TEMPLATE => _DefineReport( "_TEMPLATE_" ) 

#xcommand BANDHEIGHT <nValue> => _BandHeight(<nValue>)

* Skip Expression .............................................................

#xcommand ITERATOR <xValue> => _HMG_SYSDATA \[206\] := <{xValue}>
#xcommand STOPPER <xValue> => _HMG_SYSDATA \[207\] := <{xValue}>

* Layout ......................................................................

#xcommand BEGIN LAYOUT => _BeginLayout()
#xcommand ORIENTATION	<nValue> => _HMG_SYSDATA \[155\] := <nValue>
#xcommand PAPERSIZE	<nValue> => _HMG_SYSDATA \[156\] := <nValue>

#xcommand PAPERWIDTH	<nValue> => _HMG_SYSDATA \[118\] := <nValue>
#xcommand PAPERLENGTH	<nValue> => _HMG_SYSDATA \[119\] := <nValue>

#xcommand END LAYOUT  => _EndLayout() 


* Header ......................................................................

#xcommand BEGIN HEADER => _BeginHeader()

#xcommand END HEADER  => _EndHeader() 


* Detail ......................................................................

#xcommand BEGIN DETAIL => _BeginDetail()

#xcommand END DETAIL  => _EndDetail() 


* Data ......................................................................

#xcommand BEGIN DATA => _BeginData()

#xcommand END DATA  => _EndData() 


* Footer ......................................................................

#xcommand BEGIN FOOTER => _BeginFooter()

#xcommand END FOOTER  => _EndFooter() 


* Text ......................................................................

#xcommand BEGIN TEXT => _BeginText()

#xcommand END TEXT  => _EndText() 

#xcommand EXPRESSION <value> ;
	=>;
	_HMG_SYSDATA \[ 116 \] := <"value"> 


* Line ......................................................................

#xcommand BEGIN LINE => _BeginLine()

#xcommand END LINE  => _EndLine() 


* Image ......................................................................

#xcommand BEGIN PICTURE => _BeginImage()

#xcommand END PICTURE  => _EndImage() 

#xcommand FROMROW	<nValue> => _HMG_SYSDATA \[ 110 \] := <nValue>
#xcommand FROMCOL	<nValue> => _HMG_SYSDATA \[ 111 \] := <nValue>
#xcommand TOROW		<nValue> => _HMG_SYSDATA \[ 112 \] := <nValue>
#xcommand TOCOL		<nValue> => _HMG_SYSDATA \[ 113 \] := <nValue>
#xcommand PENWIDTH	<nValue> => _HMG_SYSDATA \[ 114 \] := <nValue>
#xcommand PENCOLOR	<aValue> => _HMG_SYSDATA \[ 115 \] := <aValue>

* Rectangle ...................................................................

#xcommand BEGIN RECTANGLE => _BeginRectangle()

#xcommand END RECTANGLE  => _EndRectangle()

* Misc ************************************************************************

#xtranslate Application.CurrentReport.PageNumber => _HMG_SYSDATA \[ 117 \] 

#xtranslate _PageNo => _HMG_SYSDATA \[ 117 \] 

#xtranslate _PageCount => HMG_LEN (_HMG_SYSDATA \[ 160 \]) 


* Execute *********************************************************************

#xcommand EXECUTE REPORT <ReportName>  ;
=> ;
ExecuteReport ( <"ReportName"> , .f. , .f. )

#xcommand EXECUTE REPORT <ReportName> PREVIEW ;
=> ;
ExecuteReport ( <"ReportName"> , .t. , .f. )

#xcommand EXECUTE REPORT <ReportName> PREVIEW SELECTPRINTER ;
=> ;
ExecuteReport ( <"ReportName"> , .t. , .t. )

#xcommand EXECUTE REPORT <ReportName> FILE <FileName> ;
=> ;
ExecuteReport ( <"ReportName"> , .f. , .f. , <FileName> )


* Layout ......................................................................

#xcommand BEGIN SUMMARY => _BeginSummary()
#xcommand END SUMMARY  => _EndSummary() 


*******************************************************************************

* Group .......................................................................
        
#xcommand BEGIN GROUP => _BeginGroup()


#xcommand GROUPEXPRESSION <value> ;
	=>;
	_HMG_SYSDATA \[ 125 \] := <"value"> 


#xcommand END GROUP  => _EndGroup() 

* Group Header ......................................................................

#xcommand BEGIN GROUPHEADER => _BeginGroupHeader()

#xcommand END GROUPHEADER  => _EndGroupHeader() 

* Group Footer ......................................................................

#xcommand BEGIN GROUPFOOTER => _BeginGroupFooter()

#xcommand END GROUPFOOTER  => _EndGroupFooter() 



