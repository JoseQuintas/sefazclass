#include <hmg.ch>

Function Main()
 
   define window main at 0, 0 width 300 height 300 main title 'HMG HPDF Document'
      define button create
         row 100
         col 100
         caption 'HMG HPDF DOC'
         action pdf_create()
      end button
   end window
   main.center
   main.activate

Return

function pdf_create()
   local lSuccess := .f.
   local cLB := chr( 10 )
   SELECT HPDFDOC 'HMG_HPDF_Doc.pdf' TO lSuccess papersize HPDF_PAPER_A4
//   SELECT HPDFDOC 'HMG_HPDF_Doc.pdf' TO lSuccess papersize HPDF_PAPER_USER paperlength 5000 paperwidth 5000
   SET HPDFDOC COMPRESS ALL
   SET HPDFDOC PAGEMODE TO OUTLINE
   SET HPDFINFO AUTHOR      TO 'S. Rathinagiri'
   SET HPDFINFO CREATOR     TO 'S. Rathinagiri'
   SET HPDFINFO TITLE       TO 'HMG_HPDF Documentation'
   SET HPDFINFO SUBJECT     TO 'Documentation of LibHaru/HPDF Library in HMG'
   SET HPDFINFO KEYWORDS    TO 'HMG, HPDF, Documentation, LibHaru, Harbour, MiniGUI'
   SET HPDFINFO DATECREATED TO date() TIME time()
   if lSuccess
      START HPDFDOC
         START HPDFPAGE
            @ 126,  10 HPDFPRINT IMAGE "hmghpdf.png" WIDTH 190 HEIGHT 46
         END HPDFPAGE   
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "Introduction" 
            Draw_HeaderBox()
            Print_Header( "HMG_HPDF Introduction" )
            cContent := "      HMG_HPDF is a small library to create PDF documents in a simple way using xBase syntax. " + ;
                        "Output from HMG programs can be exported to PDF with HMG PRINT like commands. Apart from HMG PRINT " +;
                        "features this library has some additional features also." + ;
                        cLB + ;
                        cLB + ;
                        "      It is based on HPDF in Harbour. HPDF is originally ported from LibHaru to Harbour." +;
                        cLB + ;
                        cLB + ;
                        "USAGE:" + ;
                        cLB + ;
                        cLB + ;
                        "      Just by including the following line into the initial lines of the HMG code, the commands discussed in this" + ;
                        " document can be used. " + ;
                        cLB + ;
                        cLB + ;
                        '#include "hmg_hpdf.ch"'
            Print_Content( cContent )
         END HPDFPAGE
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "General Points" 
            Draw_HeaderBox()
            Print_Header( "General Points" )
            cContent := "1. The unit of measurement in HMG_HPDF is millimeters." + ;
                        cLB + ;
                        cLB + ;
                        "2. The maximum page length/width is 5080 mm." 
            Print_Content( cContent )
         END HPDFPAGE
         SET HPDFDOC ROOTOUTLINE TITLE "Document Handling" NAME "DOC"

        
         // Document Handling
         
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "SELECT HPDFDOC" PARENT "DOC"
            Draw_HeaderBox()
            Print_Header( "SELECT HPDFDOC" )
            cContent := "      This is the command to initialize the HPDFDOC. This is the first command to be used to invoke HMG_HPDF. If you call any other command  " + ;
                        "before calling this command, you will get an error that PDF object is not found. " + ;
                        "All the available papersizes are listed in hmg_hpdf.ch. User can specify his own paper length and width also. The maximum paper length/width is 5080 mm." 
            Print_Content( cContent )
            cSyntax := "SELECT HPDFDOC cPDFFile ;" + ;
                        cLB + ;
	                    "   [ ORIENTATION nOrientation ] ;"  + ;
                        cLB + ;
	                    "   [ PAPERSIZE nPaperSize ] ;" + ;
                        cLB + ;
	                    "   [ PAPERLENGTH nPaperLength ] ;" + ;
                        cLB + ;
	                    "   [ PAPERWIDTH nPaperWidth ]" 
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'SELECT HPDFDOC "sample.pdf"'
            @ 205,  10 HPDFPRINT 'SELECT HPDFDOC "sample.pdf" ORIENTATION HPDF_ORIENT_LANDSCAPE'
            @ 210,  10 HPDFPRINT 'SELECT HPDFDOC "sample.pdf" PAPERSIZE HPDF_PAPER_LEGAL'
            @ 215,  10 HPDFPRINT 'SELECT HPDFDOC "sample.pdf" PAPERLENGTH 300 PAPERWIDTH 300'

         END HPDFPAGE         
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "START HPDFDOC" PARENT "DOC"
            Draw_HeaderBox()
            Print_Header( "START HPDFDOC" )
            cContent := "      This command is used to start the HPDFDOC."
            Print_Content( cContent )
            cSyntax := "START HPDFDOC"
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'START HPDFDOC'
         END HPDFPAGE         
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "END HPDFDOC" PARENT "DOC"
            Draw_HeaderBox()
            Print_Header( "END HPDFDOC" )
            cContent := "      This command is used to close the HPDFDOC and create the PDF file as mentioned in the SELECT HPDFDOC command." + ;
                        "Until this command is executed the PDF file will not be created." 
            Print_Content( cContent )
            cSyntax := "END HPDFDOC"
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'END HPDFDOC'
         END HPDFPAGE         
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "ABORT HPDFDOC" PARENT "DOC"
            Draw_HeaderBox()
            Print_Header( "ABORT HPDFDOC" )
            cContent := "      This command is used to close the HPDFDOC and abort the PDF file creation process." + ;
                        "If this command is executed the PDF file will not be created." 
            Print_Content( cContent )
            cSyntax := "ABORT HPDFDOC"
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'ABORT HPDFDOC'
         END HPDFPAGE
         SET HPDFDOC ROOTOUTLINE TITLE "HPDFINFO" NAME "HPDFINFO" PARENT "DOC"
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "SET HPDFINFO" PARENT "HPDFINFO"
            Draw_HeaderBox()
            Print_Header( "SET HPDFINFO" )
            cContent := "      This command is used to insert some document attributes/properties about the author, creation date etc., " + ;
                        "These informations are meta-data and are not shown inside the PDF document." 
            Print_Content( cContent )
            cSyntax := 'SET HPDFINFO AUTHOR TO cValue' + ;
                        cLB + ;
                        'SET HPDFINFO CREATOR TO cValue' + ;
                        cLB + ;                        
                        'SET HPDFINFO TITLE TO cValue' + ;
                        cLB + ;                        
                        'SET HPDFINFO SUBJECT TO cValue' + ;
                        cLB + ;                        
                        'SET HPDFINFO KEYWORDS TO cValue' + ;
                        cLB + ;                        
                        'SET HPDFINFO DATECREATED TO dValue [ TIME cTimeString ]'  + ;
                        cLB + ;                        
                        'SET HPDFINFO DATEMODIFIED TO dValue [ TIME cTimeString ]' 
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'SET HPDFINFO AUTHOR TO "My Author"'
            @ 205,  10 HPDFPRINT 'SET HPDFINFO CREATOR TO "My Creator"'
            @ 210,  10 HPDFPRINT 'SET HPDFINFO TITLE TO "Doc Title"'
            @ 215,  10 HPDFPRINT 'SET HPDFINFO SUBJECT TO "Doc Subject"'
            @ 220,  10 HPDFPRINT 'SET HPDFINFO KEYWORDS TO "Keyword1, Keyword2"'
            @ 225,  10 HPDFPRINT 'SET HPDFINFO DATECREATED TO date()'
            @ 230,  10 HPDFPRINT 'SET HPDFINFO DATEMODIFIED TO date()'
            @ 235,  10 HPDFPRINT 'SET HPDFINFO DATECREATED TO date() TIME time()'
            @ 240,  10 HPDFPRINT 'SET HPDFINFO DATEMODIFIED TO date() TIME time()'
         END HPDFPAGE
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "GET HPDFINFO" PARENT "HPDFINFO"
            Draw_HeaderBox()
            Print_Header( "GET HPDFINFO" )
            cContent := "      This command is used to retrieve the document attributes/properties about the author, creation date etc., " + ;
                        "already stored in the PDF document to the memory variable specified."   
            Print_Content( cContent )
            cSyntax := 'GET HPDFINFO AUTHOR TO cValue' + ;
                        cLB + ;
                        'GET HPDFINFO CREATOR TO cValue' + ;
                        cLB + ;                        
                        'GET HPDFINFO TITLE TO cValue' + ;
                        cLB + ;                        
                        'GET HPDFINFO SUBJECT TO cValue' + ;
                        cLB + ;                        
                        'GET HPDFINFO KEYWORDS TO cValue' + ;
                        cLB + ;                        
                        'GET HPDFINFO DATECREATED TO cDateTime'  + ;
                        cLB + ;                        
                        'GET HPDFINFO DATEMODIFIED TO cDateTime' 
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'GET HPDFINFO AUTHOR TO cAuthor'
            @ 205,  10 HPDFPRINT 'GET HPDFINFO CREATOR TO cCreator'
            @ 210,  10 HPDFPRINT 'GET HPDFINFO TITLE TO cTitle'
            @ 215,  10 HPDFPRINT 'GET HPDFINFO SUBJECT TO cSubject'
            @ 220,  10 HPDFPRINT 'GET HPDFINFO KEYWORDS TO cKeywords'
            @ 225,  10 HPDFPRINT 'GET HPDFINFO DATECREATED TO cDateTime'
            @ 230,  10 HPDFPRINT 'GET HPDFINFO DATEMODIFIED TO cDateTime'
         END HPDFPAGE
         SET HPDFDOC ROOTOUTLINE TITLE "Miscelleaneous" NAME "MISC" PARENT "DOC"
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "SET HPDFDOC COMPRESS" PARENT "MISC"
            Draw_HeaderBox()
            Print_Header( "SET HPDFDOC COMPRESS" )
            cContent := "      This command is used to apply compression on the document contents. Level of compression can be specified using various parameters."   
            Print_Content( cContent )
            cSyntax := 'SET HPDFDOC COMPRESS NONE|TEXT|IMAGE|METADATA|ALL'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'SET HPDFDOC COMPRESS NONE'
            @ 205,  10 HPDFPRINT 'SET HPDFDOC COMPRESS TEXT'
            @ 210,  10 HPDFPRINT 'SET HPDFDOC COMPRESS IMAGE'
            @ 215,  10 HPDFPRINT 'SET HPDFDOC COMPRESS METADATA'
            @ 220,  10 HPDFPRINT 'SET HPDFDOC COMPRESS ALL'
         END HPDFPAGE
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "SET HPDFDOC PERMISSION" PARENT "MISC"
            Draw_HeaderBox()
            Print_Header( "SET HPDFDOC PERMISSION" )
            cContent := "      This command is used to allow/disallow users to do/deny some operations on the document. This command will be effective only if there is owner/user differentiation using SET PASSWORD command."
            Print_Content( cContent )
            cSyntax := 'SET HPDFDOC PERMISSION TO READ|PRINT|EDIT|COPY|EDIT_ALL'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'SET HPDFDOC PERMISSION TO READ'
            @ 205,  10 HPDFPRINT 'SET HPDFDOC PERMISSION TO PRINT'
            @ 210,  10 HPDFPRINT 'SET HPDFDOC PERMISSION TO EDIT'
            @ 215,  10 HPDFPRINT 'SET HPDFDOC PERMISSION TO COPY'
            @ 220,  10 HPDFPRINT 'SET HPDFDOC PERMISSION TO EDIT_ALL'
         END HPDFPAGE
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "SET HPDFDOC PAGEMODE" PARENT "MISC"
            Draw_HeaderBox()
            Print_Header( "SET HPDFDOC PAGEMODE" )
            cContent := "      This command is used to set the page mode to available page opening modes."
            Print_Content( cContent )
            cSyntax := 'SET HPDFDOC PAGEMODE TO NONE|OUTLINE|THUMBS|FULL_SCREEN'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'SET HPDFDOC PAGEMODE TO NONE'
            @ 205,  10 HPDFPRINT 'SET HPDFDOC PAGEMODE TO OUTLINE'
            @ 210,  10 HPDFPRINT 'SET HPDFDOC PAGEMODE TO THUMBS'
            @ 215,  10 HPDFPRINT 'SET HPDFDOC PAGEMODE TO FULL_SCREEN'
         END HPDFPAGE
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "SET HPDFDOC PASSWORD" PARENT "MISC"
            Draw_HeaderBox()
            Print_Header( "SET HPDFDOC PASSWORD" )
            cContent := "      This command is used to set password for the owner and/or user. The owner will then have more right over the user than specified in SET PERMISSION command. User password is optional in this command."
            Print_Content( cContent )
            cSyntax := 'SET HPDFDOC PASSWORD OWNER cOwnerPass [ USER cUserPass ]'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'SET HPDFDOC PASSWORD TO OWNER "Password_1"'
            @ 205,  10 HPDFPRINT 'SET HPDFDOC PASSWORD TO OWNER "Password_1" USER "Password_2"'
         END HPDFPAGE
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "SET HPDFDOC PAGENUMBERING" PARENT "MISC"
            Draw_HeaderBox()
            Print_Header( "SET HPDFDOC PAGENUMBERING" )
            cContent := "      This command is used to set the page numbering style of the PDF Document and the starting page number to be used for that purpose. " + ;
                        "Lower/Upper case can be used for Roman/Letters number styles. A prefix can be used to attach before the page numbers in thumbnails."
            Print_Content( cContent )
            cSyntax := 'SET HPDFDOC PAGENUMBERING [ FROM <nPage> ];' +;
                       cLB + ;
                       '   [ STYLE DECIMAL|ROMAN|LETTERS ];' +;
                       cLB + ; 
                       '   [ UPPER|LOWER ];' + ;
                       cLB + ;
                       '   [ PREFIX cPrefix ]'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'SET HPDFDOC PAGENUMBERING'
            @ 205,  10 HPDFPRINT 'SET HPDFDOC PAGENUMBERING FROM PAGE 2'
            @ 210,  10 HPDFPRINT 'SET HPDFDOC PAGENUMBERING FROM PAGE 2 STYLE ROMAN'
            @ 215,  10 HPDFPRINT 'SET HPDFDOC PAGENUMBERING FROM PAGE 2 STYLE LETTERS LOWER'
            @ 220,  10 HPDFPRINT 'SET HPDFDOC PAGENUMBERING FROM PAGE 2 STYLE ROMAN PREFIX "Page: "'
         END HPDFPAGE

         // Encoding
         
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "SET HPDFDOC ENCODING" 
            Draw_HeaderBox()
            Print_Header( "SET HPDFDOC ENCODING" )
            cContent := "      This command is used to set the character encoding of the PDF document to correctly show the characters of various languages other than the default language (English). " + ;
                        'Available Character encoding options are StandardEncoding, MacRomanEncoding, WinAnsiEncoding, FontSpecific, ' + ;
                        'ISO8859-2, ISO8859-3, ISO8859-4, ISO8859-5, ISO8859-6, ISO8859-7, ISO8859-8, ISO8859-9, ISO8859-10, ' +;
                        'ISO8859-11, ISO8859-13, ISO8859-14, ISO8859-15, ISO8859-16, CP1250, CP1251, CP1252, CP1253, CP1254, ' +;
                        'CP1255, CP1256, CP1257, CP1258, KOI8-R.' + ;
                        cLB + ;
                        cLB + ;
                        '      Specified character Encoding shall be applied only to the future text rendering. If you want to apply the character encoding to the whole document, call this command immediately after using START HPDFDOC command.'
            @ 110, 10 HPDFURLLINK "Click here for more details about Character Encoding" TO "http://libharu.org/wiki/Documentation/Encodings" SIZE 15 COLOR { 0, 0, 255 }                       
            Print_Content( cContent )
            cSyntax := 'SET HPDFDOC ENCODING TO cEncoding'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'SET HPDFDOC ENCODING TO "CP1251"'
            @ 205,  10 HPDFPRINT 'SET HPDFDOC ENCODING TO "ISO8859-13"'
            @ 210,  10 HPDFPRINT 'SET HPDFDOC ENCODING TO "CP1255"'
         END HPDFPAGE

         // Outline
         SET HPDFDOC ROOTOUTLINE TITLE "Outline" NAME "OUTLINE" 
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "ROOTOUTLINE" PARENT "OUTLINE"
            Draw_HeaderBox()
            Print_Header( "ROOTOUTLINE" )
            cContent := '      Outlines are like Tree control of the PDF pages. It is easy for navigation and arrangement of the whole doc. ' + ;
                        'This command is used to create a simple ROOT. It will not point/refer any page in the PDF doc. NAME clause should be used to refer the name of the root in the future.' + ;
                        'If you omit PARENT, the outline will be a ROOT node. Otherwise, it will be a sub-root of a parent root/node.'
            Print_Content( cContent )
            cSyntax := 'SET HPDFDOC ROOTOUTLINE TITLE cTitle ;' + ;
                        cLB + ;
                        '   NAME cName ;' + ; 
                        cLB + ;
                        '   [ PARENT cParent ]'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'SET HPDFDOC ROOTOUTLINE TITLE "Index" NAME "INDEX"'
            @ 205,  10 HPDFPRINT 'SET HPDFDOC ROOTOUTLINE TITLE "Sub Index" NAME "SUBINDEX" PARENT "INDEX"'
         END HPDFPAGE
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "PAGEOUTLINE" PARENT "OUTLINE"
            Draw_HeaderBox()
            Print_Header( "PAGEOUTLINE" )
            cContent := '      Outlines are like Tree control of the PDF pages. It is easy for navigation and arrangement of the whole doc. ' + ;
                        'This command is used to create the outline reference of the current page in the doc. If the PARENT clause is omitted, the current page will be placed as a root.' + ; 
                        'Use PARENT clause to make the current page reference to be inside a root. The root can be a ROOTOUTLINE or a PAGEOUTLINE referenced by its NAME.' + ;
                        'If you specify NAME clause, the page reference can be used as a ROOT and can be parent of other ROOTOUTLINE or PAGEOUTLINE.' + ;
                        'The current page can be referred in multiple outlines also. This command can be called only between START HPDFPAGE and END HPDFPAGE.' 
            Print_Content( cContent )
            cSyntax := 'SET HPDFDOC PAGEOUTLINE TITLE cTitle ;' + ;
                        cLB + ;
                        '   [ NAME cName ];' + ; 
                        cLB + ;
                        '   [ PARENT cParent ]'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'SET HPDFDOC PAGEOUTLINE TITLE "Index Page" NAME "INDEX"'
            @ 205,  10 HPDFPRINT 'SET HPDFDOC PAGEOUTLINE TITLE "Node Page" PARENT "INDEX"'
            @ 210,  10 HPDFPRINT 'SET HPDFDOC PAGEOUTLINE TITLE "Intermediate Index Page" NAME "IIP" PARENT "INDEX"'
         END HPDFPAGE

         SET HPDFDOC ROOTOUTLINE TITLE "Page Handling" NAME "PAGE"
         SET HPDFDOC ROOTOUTLINE TITLE "Content Handling" NAME "CONTENT"
         SET HPDFDOC ROOTOUTLINE TITLE "Text" NAME "TEXT" PARENT "CONTENT"
         SET HPDFDOC ROOTOUTLINE TITLE "Graphics" NAME "GRAPHICS" PARENT "CONTENT"

         // Page Handling

         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "START HPDFPAGE" PARENT "PAGE"
            Draw_HeaderBox()
            Print_Header( "START HPDFPAGE" )
            cContent := '      This command is used to add a new page to the HPDFDOC. The added page will be the current page until END HPDFPAGE is called. ' +;
                        'Please note that, PAGE once added can not be deleted or removed or moved afterwards. This command can be called only after START HPDFDOC'
            Print_Content( cContent )
            cSyntax := 'START HPDFPAGE' 
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'START HPDFPAGE'
         END HPDFPAGE         
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "END HPDFPAGE" PARENT "PAGE"
            Draw_HeaderBox()
            Print_Header( "END HPDFPAGE" )
            cContent := '      This command is used to close the current page of the HPDFDOC.'
            Print_Content( cContent )
            cSyntax := 'END HPDFPAGE' 
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'END HPDFPAGE'
         END HPDFPAGE         
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "INSERT HPDFPAGE" PARENT "PAGE"
            Draw_HeaderBox()
            Print_Header( "INSERT HPDFPAGE" )
            cContent := '      This command is used to insert a new page before the page number specified. The inserted page will be selected as the current page after this command. All the pages will be shifted down.  This command can not be called inside a current page selection. Please call END HPDFPAGE to close the current page before calling this command.'
            Print_Content( cContent )
            cSyntax := 'INSERT HPDFPAGE BEFORE PAGE nPage' 
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'INSERT HPDFPAGE BEFORE PAGE 3'
         END HPDFPAGE         
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "SELECT HPDFPAGE" PARENT "PAGE"
            Draw_HeaderBox()
            Print_Header( "SELECT HPDFPAGE" )
            cContent := '      This command is used to select an existing page as the current page. This command can not be called inside a current page selection. Please call END HPDFPAGE to close the current page before calling this command.'
            Print_Content( cContent )
            cSyntax := 'SELECT HPDFPAGE nPage' 
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'SELECT HPDFPAGE 3'
         END HPDFPAGE         
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "HMG_HPDF_PAGENO()" PARENT "PAGE"
            Draw_HeaderBox()
            Print_Header( "HMG_HPDF_PAGENO()" )
            cContent := '      This function is used to retrieve the current page number. This command shall be called in between the commands START HPDFPAGE and END HPDFPAGE.'
            Print_Content( cContent )
            cSyntax := 'HMG_HPDF_PAGENO() -> nCurrentPage' 
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'nCurrentPage := HMG_HPDF_PageNo()'
         END HPDFPAGE         
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "HMG_HPDF_PAGECOUNT()" PARENT "PAGE"
            Draw_HeaderBox()
            Print_Header( "HMG_HPDF_PAGECOUNT()" )
            cContent := '      This function is used to retrieve the total pages inside the HPDFDOC at the moment.'
            Print_Content( cContent )
            cSyntax := 'HMG_HPDF_PAGECOUNT() -> nTotPages' 
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT 'nTotalPages := HMG_HPDF_PageCount()'
         END HPDFPAGE         
         
         // TEXT

         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "@..HPDFPRINT" PARENT "TEXT"
            Draw_HeaderBox()
            Print_Header( "@..HPDFPRINT" )
            cContent := '      This command is used to render a single line of text data in the specified font, size, color and alignment at the specified row and column. ' + ;
                        'The text rendered is left aligned unless otherwise specified. Only following Base14 fonts are built-in. ' + ;
                        'Courier, Courier-Bold, Courier-Oblique, Courier-BoldOblique, Helvetica, Helvetica-Bold, Helvetica-Oblique, ' + ;
                        'Helvetica-BoldOblique, Times-Roman, Times-Bold, Times-Italic, Times-BoldItalic, Symbol, ZapfDingbats. The text will be rendered in the current character encoding.' + ;
                        cLB + ;
                        cLB + ;
                        '      Helvetica is the default font if no fontname is specified. Default fontsize is 12.' + ;
                        cLB + ;
                        cLB + ;
                        '      True Type Fonts can also be used if the absolute address of the True Type Font file is mentioned. Otherwise the TTF shall be required at the runtime in the same directory as of the executable file.'
            Print_Content( cContent )
            cSyntax := '@ Row , Col HPDFPRINT cText ;' + ;
                       cLB + ;
	                    '   [ FONT cFontName ] ;' + ;
                       cLB + ;
                       '   [ SIZE nFontSize ] ;' + ;
                       cLB + ;
                       '   [ COLOR aColor ] ;' + ;
                       cLB + ;
                       '   [ CENTER|RIGHT ]'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT '@ 205,  10 HPDFPRINT "This is a sample Text in default font."'
            @ 205,  10 HPDFPRINT "This is a sample Text in default font."
            @ 215,  10 HPDFPRINT '@ 220,  10 HPDFPRINT "This is a sample Text in Times-Roman font." FONT "Times-Roman" SIZE 14'
            @ 220,  10 HPDFPRINT "This is a sample Text in Times-Roman font." FONT "Times-Roman" SIZE 14
            @ 230,  10 HPDFPRINT '@ 235,  200 HPDFPRINT "This is right aligned text" FONT "Courier-Bold" SIZE 14 RIGHT'
            @ 235, 200 HPDFPRINT "This is right aligned text" FONT "Courier-Bold" SIZE 14 RIGHT
            @ 245,  10 HPDFPRINT '@ 250,  105 HPDFPRINT "This is center aligned text" COLOR { 255, 0, 0 } CENTER'
            @ 250,  105 HPDFPRINT "This is center aligned text" COLOR { 255, 0, 0 } CENTER
            @ 260,  10 HPDFPRINT '@ 270,  105 HPDFPRINT "This is text in bigger font size" SIZE 30 COLOR { 255, 0, 0 } '
            @ 270,  10 HPDFPRINT "This is text in bigger font size" SIZE 30 COLOR { 100, 0, 0 } 
            @ 280, 10 HPDFPRINT '@ 290, 10 HPDFPRINT "The font is Tscparan.TTF" FONT "Tscparan.TTF" size 12'
            @ 290, 10 HPDFPRINT "The font is Tscparan.TTF" FONT "Tscparan.TTF" size 12
         END HPDFPAGE         
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "@..HPDFPRINT..TO" PARENT "TEXT"
            Draw_HeaderBox()
            Print_Header( "@..HPDFPRINT..TO" )
            cContent := '      This command is just like the previous command @..HPDFPRINT. However, this command is used to print the text data in multiline. ' + ;
                        'The text will be rendered inside a rectangular area specified in the command. The text can be aligned in JUSTIFY alignment also. ' + ;
                        'All other options are just the same as the previous command.' 
            Print_Content( cContent )
            cSyntax := '@ Row , Col HPDFPRINT cText ;' + ;
                       cLB + ;
                       '   TO ToRow, ToCol ;' + ;
                       cLB + ;
	                    '   [ FONT cFontName ] ;' + ;
                       cLB + ;
                       '   [ SIZE nFontSize ] ;' + ;
                       cLB + ;
                       '   [ COLOR aColor ] ;' + ;
                       cLB + ;
                       '   [ CENTER|RIGHT ]'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT '@ 230,  10 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area left aligned." to 250, 60' size 10
            @ 205,  10 HPDFPRINT '@ 230,  80 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area right aligned." to 250, 130 RIGHT' size 10
            @ 210,  10 HPDFPRINT '@ 230, 150 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area justified." to 250, 200 JUSTIFY' size 10
            @ 215,  10 HPDFPRINT '@ 255, 10 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area justified." to 275, 60 JUSTIFY' size 10

            @ 230,  10 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area left aligned." to 250, 60            
            @ 230,  80 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area right aligned." to 250, 130 RIGHT            
            @ 230, 150 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area justified." to 250, 200 JUSTIFY
            SET HPDFPAGE LINESPACING TO 6
            @ 255, 10 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area justified." to 275, 60 JUSTIFY
            SET HPDFPAGE LINESPACING TO 0
         END HPDFPAGE         
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "SET HPDFPAGE LINESPACING" PARENT "TEXT"
            Draw_HeaderBox()
            Print_Header( "SET HPDFPAGE LINESPACING" )
            cContent := '      This command is used to change the default line spacing in @..HPDFPRINT..TO command.' 
            Print_Content( cContent )
            cSyntax := 'SET HPDFPAGE LINESPACING TO nSpacing'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT '@ 230,  10 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area left aligned." to 250, 60' size 8
            @ 205,  10 HPDFPRINT 'SET HPDFPAGE LINESPACING TO 6' size 8
            @ 210,  10 HPDFPRINT '@ 230,  70 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area left aligned with a different linespacing." to 260, 120' size 8
            @ 215,  10 HPDFPRINT 'SET HPDFPAGE LINESPACING TO 0' size 8
            @ 220,  10 HPDFPRINT '@ 230, 130 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area left aligned line spacing back to normal." to 230, 180' size 8
            

            @ 230,  10 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area left aligned." to 250, 60            
            SET HPDFPAGE LINESPACING TO 6
            @ 230,  70 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area left aligned with a different linespacing." to 260, 120
            SET HPDFPAGE LINESPACING TO 0
            @ 230, 130 HPDFPRINT "This is a small paragraph to be printed inside a rectangular area left aligned line spacing back to normal." to 260, 180         
         END HPDFPAGE         

         
         // GRAPHICS
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "@..HPDFPRINT LINE TO" PARENT "GRAPHICS"
            Draw_HeaderBox()
            Print_Header( "@..HPDFPRINT LINE TO" )
            cContent := '      This command is used to draw a continuous line from the specified location to a specified another location. Color and width of the line can be specified optionally. The default color is black.' 
            Print_Content( cContent )
            cSyntax := '@ Row , Col HPDFPRINT LINE ;' + ;
                       cLB + ;
                       '   TO ToRow, ToCol ;' + ;
                       cLB + ;
                       '   [ PENWIDTH nWidth ] ;' + ;
                       cLB + ;
                       '   [ COLOR aColor ] ;' 
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT '@ 230,  10 HPDFPRINT LINE TO 230,  50'
            @ 205,  10 HPDFPRINT '@ 235,  10 HPDFPRINT LINE TO 235,  50 PENWIDTH 1 COLOR { 255, 0, 0 }'
            @ 210,  10 HPDFPRINT '@ 230,  70 HPDFPRINT LINE TO 250,  70 PENWIDTH 1 COLOR { 255, 0, 0 }'
            @ 215,  10 HPDFPRINT '@ 230, 100 HPDFPRINT LINE TO 250, 150 PENWIDTH 2 COLOR { 255, 0, 255 }'
            @ 230,  10 HPDFPRINT LINE TO 230,  50
            @ 235,  10 HPDFPRINT LINE TO 235,  50 PENWIDTH 1 COLOR { 255, 0, 0 }
            @ 230,  70 HPDFPRINT LINE TO 250,  70 PENWIDTH 1 COLOR { 255, 0, 0 }
            @ 230, 100 HPDFPRINT LINE TO 250, 150 PENWIDTH 2 COLOR { 255, 0, 255 }
         END HPDFPAGE         
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "@..HPDFPRINT RECTANGLE TO" PARENT "GRAPHICS"
            Draw_HeaderBox()
            Print_Header( "@..HPDFPRINT RECTANGLE TO" )
            cContent := '      This command is used to draw a rectangle from the specified location to a specified another location. Color and width of the line can be specified optionally. The default color is black. The rectangle can be filled. Rounded clause will draw a rounded rectangle. Optionally Curve length can also be specified for Rounded rectangle.' 
            Print_Content( cContent )
            cSyntax := '@ Row , Col HPDFPRINT RECTANGLE ;' + ;
                       cLB + ;
                       '   TO ToRow, ToCol ;' + ;
                       cLB + ;
                       '   [ PENWIDTH nWidth ] ;' + ;
                       cLB + ;
                       '   [ COLOR aColor ] ;' + ;
                       cLB + ;
                       '   [ FILLED ];' + ;
                       cLB + ;
                       '   ROUNDED ;' + ;
                       cLB + ;
                       '   [ CURVE nCurve ];'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT '@ 230,  10 HPDFPRINT RECTANGLE TO 250,  50' size 10
            @ 205,  10 HPDFPRINT '@ 230,  60 HPDFPRINT RECTANGLE TO 250, 100 PENWIDTH 1 COLOR { 255, 0, 0 }' size 10
            @ 210,  10 HPDFPRINT '@ 230, 110 HPDFPRINT RECTANGLE TO 250, 150 PENWIDTH 1 COLOR { 255, 0, 0 } FILLED' size 10
            @ 215,  10 HPDFPRINT '@ 260,  10 HPDFPRINT RECTANGLE TO 280,  50 PENWIDTH 2 COLOR { 255, 0, 255 } ROUNDED' size 10
            @ 220,  10 HPDFPRINT '@ 260,  60 HPDFPRINT RECTANGLE TO 280, 150 PENWIDTH 2 COLOR { 255, 0, 255 } ROUNDED CURVE 10' size 10
            @ 225,  10 HPDFPRINT '@ 260, 160 HPDFPRINT RECTANGLE TO 280, 200 PENWIDTH 2 COLOR { 255, 255, 0 } FILLED ROUNDED CURVE 10' size 10
            @ 230,  10 HPDFPRINT RECTANGLE TO 250,  50
            @ 230,  60 HPDFPRINT RECTANGLE TO 250, 100 PENWIDTH 1 COLOR { 255, 0, 0 }
            @ 230, 110 HPDFPRINT RECTANGLE TO 250, 150 PENWIDTH 1 COLOR { 255, 0, 0 } FILLED
            @ 260,  10 HPDFPRINT RECTANGLE TO 280,  50 PENWIDTH 2 COLOR { 255, 0, 255 } ROUNDED
            @ 260,  60 HPDFPRINT RECTANGLE TO 280, 150 PENWIDTH 2 COLOR { 255, 0, 255 } ROUNDED CURVE 10
            @ 260, 160 HPDFPRINT RECTANGLE TO 280, 200 PENWIDTH 2 COLOR { 255, 255, 0 } FILLED ROUNDED CURVE 10
         END HPDFPAGE         
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "@..HPDFPRINT CIRCLE" PARENT "GRAPHICS"
            Draw_HeaderBox()
            Print_Header( "@..HPDFPRINT CIRCLE" )
            cContent := '      This command is used to draw a circle with the given radius having row and col as the center. Color and width of the line can be specified optionally. The default color is black. The circle can be filled. ' 
            Print_Content( cContent )
            cSyntax := '@ Row , Col HPDFPRINT CIRCLE RADIUS nRadius ;' + ;
                       cLB + ;
                       '   [ PENWIDTH nWidth ] ;' + ;
                       cLB + ;
                       '   [ COLOR aColor ] ;' + ;
                       cLB + ;
                       '   [ FILLED ];'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT '@ 230,  40 HPDFPRINT CIRCLE RADIUS 10' 
            @ 205,  10 HPDFPRINT '@ 230,  80 HPDFPRINT CIRCLE RADIUS 10 PENWIDTH 2' 
            @ 210,  10 HPDFPRINT '@ 230, 120 HPDFPRINT CIRCLE RADIUS 10 PENWIDTH 2 COLOR { 0, 0, 255 }' 
            @ 215,  10 HPDFPRINT '@ 230, 160 HPDFPRINT CIRCLE RADIUS 10 COLOR { 0, 0, 255 } FILLED' 
            
            @ 230,  40 HPDFPRINT CIRCLE RADIUS 10
            @ 230,  80 HPDFPRINT CIRCLE RADIUS 10 PENWIDTH 2
            @ 230, 120 HPDFPRINT CIRCLE RADIUS 10 PENWIDTH 2 COLOR { 0, 0, 255 }
            @ 230, 160 HPDFPRINT CIRCLE RADIUS 10 COLOR { 0, 0, 255 } FILLED
         END HPDFPAGE         
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "@..HPDFPRINT ELLIPSE" PARENT "GRAPHICS"
            Draw_HeaderBox()
            Print_Header( "@..HPDFPRINT ELLIPSE" )
            cContent := '      This command is used to draw a ellipse with the given horizontal radius and vertical radius having row and col as the center. Color and width of the line can be specified optionally. The default color is black. The ellipse can be filled. ' 
            Print_Content( cContent )
            cSyntax := '@ Row , Col HPDFPRINT ELLIPSE HORIZONTAL RADIUS nHRadius ;' + ;
                       cLB + ;
                       '   VERTICAL RADIUS nVRadius ;' + ;
                       cLB + ;
                       '   [ PENWIDTH nWidth ] ;' + ;
                       cLB + ;
                       '   [ COLOR aColor ] ;' + ;
                       cLB + ;
                       '   [ FILLED ];'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT '@ 230,  40 HPDFPRINT ELLIPSE HORIZONTAL RADIUS 20 VERTICAL RADIUS 10' size 10
            @ 205,  10 HPDFPRINT '@ 240,  80 HPDFPRINT ELLIPSE HORIZONTAL RADIUS 10 VERTICAL RADIUS 20 PENWIDTH 2' size 10
            @ 210,  10 HPDFPRINT '@ 230, 120 HPDFPRINT ELLIPSE HORIZONTAL RADIUS 20 VERTICAL RADIUS 10 PENWIDTH 2 COLOR { 0, 0, 255 }' size 10
            @ 215,  10 HPDFPRINT '@ 240, 160 HPDFPRINT ELLIPSE HORIZONTAL RADIUS 10 VERTICAL RADIUS 20 COLOR { 0, 0, 255 } FILLED' size 10
            
            @ 230,  40 HPDFPRINT ELLIPSE HORIZONTAL RADIUS 20 VERTICAL RADIUS 10
            @ 240,  80 HPDFPRINT ELLIPSE HORIZONTAL RADIUS 10 VERTICAL RADIUS 20 PENWIDTH 2            
            @ 230, 120 HPDFPRINT ELLIPSE HORIZONTAL RADIUS 20 VERTICAL RADIUS 10 PENWIDTH 2 COLOR { 0, 0, 255 }
            @ 240, 160 HPDFPRINT ELLIPSE HORIZONTAL RADIUS 10 VERTICAL RADIUS 20 COLOR { 0, 0, 255 } FILLED
         END HPDFPAGE         
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "@..HPDFPRINT ARC" PARENT "GRAPHICS"
            Draw_HeaderBox()
            Print_Header( "@..HPDFPRINT ARC" )
            cContent := '      This command is used to draw an arc with given radius from given angle to given another angle. Color and width of the line can be specified optionally. The default color is black.' 
            Print_Content( cContent )
            cSyntax := '@ Row , Col HPDFPRINT ARC RADIUS nRadius ;' + ;
                       cLB + ;
                       '   ANGLE FROM nFromAngle ;' + ;
                       cLB + ;
                       '   TO nToAngle ;' + ;
                       cLB + ;
                       '   [ PENWIDTH nWidth ] ;' + ;
                       cLB + ;
                       '   [ COLOR aColor ] ;'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT '@ 230,  40 HPDFPRINT ARC RADIUS 10 ANGLE FROM 0 TO 180' size 10
            @ 205,  10 HPDFPRINT '@ 230,  80 HPDFPRINT ARC RADIUS 10 ANGLE FROM 90 TO 270 PENWIDTH 2' size 10
            @ 210,  10 HPDFPRINT '@ 230, 120 HPDFPRINT ARC RADIUS 10 ANGLE FROM 30 TO 200 PENWIDTH 2 COLOR { 0, 100, 100 }' size 10

            @ 230,  40 HPDFPRINT ARC RADIUS 10 ANGLE FROM 0 TO 180      
            @ 230,  80 HPDFPRINT ARC RADIUS 10 ANGLE FROM 90 TO 270 PENWIDTH 2
            @ 230, 120 HPDFPRINT ARC RADIUS 10 ANGLE FROM 30 TO 200 PENWIDTH 2 COLOR { 0, 100, 100 }
         END HPDFPAGE
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "@..HPDFPRINT CURVE" PARENT "GRAPHICS"
            Draw_HeaderBox()
            Print_Header( "@..HPDFPRINT CURVE" )
    
            SET HPDFDOC ENCODING TO "WinAnsiEncoding"
            cContent := '      This command is used to draw a Bézier curve from a point taking second point as curvature to the third point. Color and width of the line can be specified optionally. The default color is black.' 

            Print_Content( cContent )
            cSyntax := '@ Row , Col HPDFPRINT CURVE ;' + ;
                       cLB + ;
                       '   FROM FromRow, FromCol ;' + ;
                       cLB + ;
                       '   TO ToRow, ToCol ;' + ;
                       cLB + ;
                       '   [ PENWIDTH nWidth ] ;' + ;
                       cLB + ;
                       '   [ COLOR aColor ] ;'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT '@ 230,  40 HPDFPRINT CURVE FROM 230, 10 TO 250, 30' size 10
            @ 205,  10 HPDFPRINT '@ 230,  80 HPDFPRINT CURVE FROM 230, 100 TO 250, 60 PENWIDTH 2' size 10
            @ 210,  10 HPDFPRINT '@ 230, 120 HPDFPRINT CURVE FROM 230, 160 TO 250, 120 PENWIDTH 2 COLOR { 100, 0, 200 }' size 10
            
            @ 230,  40 HPDFPRINT CURVE FROM 230, 10 TO 250, 30
            @ 230,  80 HPDFPRINT CURVE FROM 230, 100 TO 250, 60 PENWIDTH 2
            @ 230, 120 HPDFPRINT CURVE FROM 230, 160 TO 250, 120 PENWIDTH 2 COLOR { 100, 0, 200 }
         END HPDFPAGE
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "@..HPDFPRINT IMAGE" PARENT "CONTENT"
            Draw_HeaderBox()
            Print_Header( "@..HPDFPRINT IMAGE" )
            cContent := '      This command is used to insert a PNG/JPG format image file from the resource or the given path inside the document at the current location. The image will be stretched according to the given width and length. Specify image type 1 for PNG and 2 for JPG.' 
            Print_Content( cContent )
            cSyntax := '@ Row , Col HPDFPRINT IMAGE cImage ;' + ;
                       cLB + ;
                       '   WIDTH nWidth ;' + ;
                       cLB + ;
                       '   LENGTH nLength' + ;
                       cLB + ;
                       '   TYPE JPG|PNG ;'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT '@ 230,  10 HPDFPRINT IMAGE "hmghpdf.png" TYPE PNG width 100 height 30' size 10
            @ 210,  10 HPDFPRINT '@ 230, 110 HPDFPRINT IMAGE "imgpng" TYPE PNG width 40 height 40' size 10
            @ 220,  10 HPDFPRINT '@ 230, 160 HPDFPRINT IMAGE "imgjpg" TYPE JPG width 40 height 40' size 10

            @ 230,  10 HPDFPRINT IMAGE "hmghpdf.png" width 100 height 30 TYPE PNG
            @ 230, 110 HPDFPRINT IMAGE "imgpng" width 40 height 40 TYPE PNG
            @ 230, 160 HPDFPRINT IMAGE "imgjpg" width 40 height 40 TYPE JPG
         END HPDFPAGE
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "@..HPDFTOOLTIP" PARENT "CONTENT"
            Draw_HeaderBox()
            Print_Header( "@..HPDFTOOLTIP" )
            cContent := '      This command is used to insert a tooltip at the specified place with the specified icon. When the user hovers the mouse over this icon, the tooltip will be displayed.' 
            Print_Content( cContent )
            cSyntax := '@ Row , Col HPDFPRINT TOOLTIP cToolTip ;' + ;
                       cLB + ;
                       '   ICON COMMENT|KEY|NOTE|HELP|' + ;
                       cLB + ;
                       '   NEW_PARAGRAPH|PARAGRAPH|INSERT'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT '@ 240,  10 HPDFTOOLTIP "Comment Tooltip" ICON COMMENT'
            @ 205,  10 HPDFPRINT '@ 250,  10 HPDFTOOLTIP "Key Tooltip" ICON KEY'
            @ 210,  10 HPDFPRINT '@ 260,  10 HPDFTOOLTIP "Note Tooltip" ICON NOTE'
            @ 215,  10 HPDFPRINT '@ 240,  50 HPDFTOOLTIP "Help Tooltip" ICON HELP'
            @ 220,  10 HPDFPRINT '@ 250,  50 HPDFTOOLTIP "New_Paragraph Tooltip" ICON NEW_PARAGRAPH'
            @ 225,  10 HPDFPRINT '@ 260,  50 HPDFTOOLTIP "Paragraph Tooltip" ICON PARAGRAPH'
            @ 230,  10 HPDFPRINT '@ 240,  90 HPDFTOOLTIP "Insert Tooltip" ICON INSERT'
            
            @ 240,  10 HPDFTOOLTIP "Comment Tooltip" ICON COMMENT
            @ 250,  10 HPDFTOOLTIP "Key Tooltip" ICON KEY
            @ 260,  10 HPDFTOOLTIP "Note Tooltip" ICON NOTE
            @ 240,  50 HPDFTOOLTIP "Help Tooltip" ICON HELP
            @ 250,  50 HPDFTOOLTIP "New_Paragraph Tooltip" ICON NEW_PARAGRAPH
            @ 260,  50 HPDFTOOLTIP "Paragraph Tooltip" ICON PARAGRAPH
            @ 240,  90 HPDFTOOLTIP "Insert Tooltip" ICON INSERT
            
         END HPDFPAGE
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "@..HPDFPAGELINK" PARENT "CONTENT"
            Draw_HeaderBox()
            Print_Header( "@..HPDFPAGELINK" )
            cContent := '      This command is used to link a particular page to the specified text.  Font, size, color, alignment options are the same as text data. A BORDER around the link can also be drawn with the optional width parameter.' 
            Print_Content( cContent )
            cSyntax := '@ Row, Col HPDFPAGELINK cLink TO nPage ;' + ;
                      cLB + ;
                      '   [ FONT cFontName ] ;' + ;
                      cLB + ;
                      '   [ SIZE nFontSize ] ;' + ;
                      cLB + ;
	                   '   [ COLOR aColor ] ;' + ;
                      cLB + ;
                      '   [ CENTER|RIGHT ] ;' + ;
                      cLB + ;
                      '   [ BORDER ];' + ;
                      cLB + ;
                      '   [ WIDTH nwidth ]'
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT '@ 230,  10 HPDFPAGELINK "Go to Page 5" TO 5'
            @ 205,  10 HPDFPRINT '@ 230,  70 HPDFPAGELINK "Go to Page 8" TO 8 FONT "Courier" size 18 color { 255, 0, 0 }'
            @ 210,  10 HPDFPRINT '@ 230, 130 HPDFPAGELINK "Go to Page 10" TO 10 color { 255, 0, 0 } BORDER'
            @ 215,  10 HPDFPRINT '@ 250,  10 HPDFPAGELINK "Go to Page 12" TO 12 color { 0, 0, 255 } BORDER WIDTH 1'
            
            @ 230,  10 HPDFPAGELINK "Go to Page 5" TO 5
            @ 230,  70 HPDFPAGELINK "Go to Page 8" TO 8 FONT "Courier" size 18 color { 255, 0, 0 }            
            @ 230, 130 HPDFPAGELINK "Go to Page 10" TO 10 color { 255, 0, 0 } BORDER
            @ 250,  10 HPDFPAGELINK "Go to Page 12" TO 12 color { 0, 0, 255 } BORDER WIDTH 1
         END HPDFPAGE
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "@..HPDFURLLINK" PARENT "CONTENT"
            Draw_HeaderBox()
            Print_Header( "@..HPDFURLLINK" )
            cContent := '      This command is used to link a particular Web URL/E-Mail ID to the specified text.  Font, size, color, alignment options are the same as text data.' 
            Print_Content( cContent )
            cSyntax := '@ Row, Col HPDFURLLINK cLink TO nPage ;' + ;
                      cLB + ;
                      '   [ FONT cFontName ] ;' + ;
                      cLB + ;
                      '   [ SIZE nFontSize ] ;' + ;
                      cLB + ;
	                   '   [ COLOR aColor ] ;' + ;
                      cLB + ;
                      '   [ CENTER|RIGHT ] ;' 
            Print_Syntax( cSyntax )
            @ 190,  10 HPDFPRINT "Examples:" SIZE 15
            @ 200,  10 HPDFPRINT '@ 230,  10 HPDFURLLINK "HMGFORUM" TO "http://www.hmgforum.com" color { 0, 0, 255 }'
            @ 205,  10 HPDFPRINT '@ 235,  10 HPDFURLLINK "Mail me" TO "mailto:srgiri@dataone.in"  color { 0, 0, 255 }'
			@ 230,  10 HPDFURLLINK "HMGFORUM" TO "http://www.hmgforum.com" color { 0, 0, 255 }
			@ 235,  10 HPDFURLLINK "Mail me" TO "mailto:srgiri@dataone.in"  color { 0, 0, 255 }
			
         END HPDFPAGE

         && // Error Messages
         && START HPDFPAGE
            && SET HPDFDOC PAGEOUTLINE TITLE "Error Messages" 
            && Draw_HeaderBox()
            && Print_Header( "Error Messages" )
         && END HPDFPAGE


         // links          
         START HPDFPAGE
            SET HPDFDOC PAGEOUTLINE TITLE "Links" 
            Draw_HeaderBox()
            Print_Header( "Links" )
            @  70,  10 HPDFURLLINK "1. http://www.hmgforum.com" TO "http://www.hmgforum.com" size 15 color { 0, 0, 255 }
            @  80,  10 HPDFURLLINK "2. http://harbour-project.org" TO "http://harbour-project.org" size 15 color { 0, 0, 255 }
            @  90,  10 HPDFURLLINK "3. http://libharu.org" TO "http://libharu.org" size 15 color { 0, 0, 255 }
         END HPDFPAGE
         
         
      END HPDFDOC
   endif   
   execute file 'HMG_HPDF_Doc.pdf'
   
return nil

function Draw_HeaderBox()
   @  10,  10 HPDFPRINT RECTANGLE TO  40, 200 COLOR { 50, 50, 255 } filled
return nil

function Print_Header( cHeader )   
   @  30, 105 HPDFPRINT cHeader SIZE 30 COLOR { 255, 255, 0 } CENTER
return nil

function Print_Content( cContent) 
   @  50,  10 HPDFPRINT  cContent TO 120, 200 JUSTIFY
return nil

function Print_Syntax( cSyntax ) 
   @ 125,  10 HPDFPRINT "Syntax:" FONT "Courier-Bold" size 18 
   @ 130,  10 HPDFPRINT cSyntax TO 180, 200 FONT "Courier-Bold" size 15 JUSTIFY 
return nil
