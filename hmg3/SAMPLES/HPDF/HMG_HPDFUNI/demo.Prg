#include <hmg.ch>

Function Main()
 
   define window main at 0, 0 width 300 height 300 main title 'HMG HPDF Document'
      define button create
         row 100
         col 100
         caption 'HMG HPDF UNICODE'
         action pdf_create()
      end button
   end window
   main.center
   main.activate

Return

function pdf_create()
   local lSuccess := .f.
   local cLB := chr( 10 )
   SELECT HPDFDOC 'HMG_HPDF_UNI.pdf' TO lSuccess papersize HPDF_PAPER_A4
   if lSuccess
      START HPDFDOC
         START HPDFPAGE
            /* UTF8 */
//            msginfo( str( HPDF_UseUTFEncodings( _HMG_SYSDATA[ 150 ][ 1 ] ) ) )
//            msginfo( str( HPDF_SetCurrentEncoder( _HMG_SYSDATA[ 150 ][ 1 ], 'UTF-8' ) ) )
//            SET HPDFDOC ENCODING TO "UTF-8"            
//            HPDF_GetFont( _HMG_SYSDATA[ 150 ][ 1 ], 'latha.ttf', "UTF-8" )
            @ 280, 10 HPDFPRINT UNICODE '@ 290, 10 HPDFPRINT "The font is பொது குறிப்புகள்" ' to 300, 300 size 12
         END HPDFPAGE
      END HPDFDOC
   endif   
   execute file 'HMG_HPDF_UNI.pdf'
return nil

