#include "hmg.ch"

Function Main
   PRIVATE aTypeItems :={;
                         "EAN13","EAN8","UPCA","UPCE","CODE39","ITF","MSI","CODABAR",;
                         "CODE93","CODE11","CODE128","PDF417","DATAMATRIX","QRCODE"}

   PRIVATE aValues :={;
                         "477012345678","1234567","01234567891","123456","ABC123","12345678901","1234","1234567",;
                         "-1234","ABC-123","Code 128","Hello, World of Harbour!!! It's 2D barcode PDF417 :)",;
                         "Hello, World of Harbour!!! It's 2D barcode DataMatrix :)","http://harbour-project.org/"}
   PRIVATE aBarColor := { 0, 0, 0 }
   PRIVATE aBackColor := { 255, 255, 255 }
   
   define window barcode at 0, 0 width 300 height 310 main title 'HMG - BarCode Generator'
      define label barcodetypelabel
         row 10
         col 10
         width 100
         value 'Select a Type'
      end label
      define combobox type
         row 10
         col 110
         width 100
         items aTypeItems
         ON CHANGE barcode.code.value := aValues [ barcode.Type.value ]         
      end Combobox           
   
      define label codelabel
         row 40
         col 10
         width 100
         value 'Enter the Code'
      end label
      define textbox code
         row 40
         col 110
         width 120
//         maxlength 13
      end textbox
      define label widthlabel
         row 70
         col 10
         width 100
         value 'Line Width'
      end label
      define spinner linewidth
         row 70
         col 110
         width 80
         value 2
         rightalign .t.
         rangemin 1
         rangemax 200
      end spinner
      define label heightlabel
         row 100
         col 10
         width 100
         value 'Barcode Height'
      end label
      define spinner lineheight
         row 100
         col 110
         width 80
         value 110
         rightalign .t.
         increment 10
         rangemin 10
         rangemax 2000
      end spinner
      define checkbox showdigits
         row 130
         col 10
         width 120
         caption 'Display Code'
         value .t.
      end checkbox
      define checkbox checksum
         row 130
         col 150
         width 120
         caption 'Checksum'
         value .t.
      end checkbox
      define checkbox wide2_5
         row 160
         col 10
         width 120
         caption 'Wide 2.5'
         onchange iif( this.value, barcode.wide3.value := .f., )
      end checkbox
      define checkbox wide3
         row 160
         col 150
         width 120
         caption 'Wide 3'
         onchange iif( this.value, barcode.wide2_5.value := .f., )
      end checkbox
      define label barcolor
         row 190
         col 10
         width 100
         fontcolor { 0, 0, 0 }
         value 'Barcode Color' 
         fontsize 16
         tooltip 'Click to change color!'
         action changebarcolor()
         alignment center
      end label
      define label backgroundcolor
         row 190
         col 150
         width 100
         backcolor { 255, 255, 255 }
         value 'Back Color' 
         fontsize 16
         tooltip 'Click to change color!'
         action changebackcolor()
         alignment center
      end label
      
      define button ok
         row 230
         col 60
         width 90
         caption 'Show Barcode'
         action createbarcode()
      end button
      define button png
         row 230
         col 160
         width 90
         caption 'Save to PNG'
         action createbarcodepng()
      end button
      
   end window
   barcode.type.value := 1
   barcode.center
   barcode.activate
Return


function CreateBarCode
   local hBitMap

   hBitMap := HMG_CreateBarCode( barcode.code.value,;
                   barcode.type.item( barcode.type.value ),;
                   barcode.linewidth.value,;
                   barcode.lineheight.value,;
                   barcode.showdigits.value,;
                   '',;
                   aBarColor,;
                   aBackColor,;
                   barcode.checksum.value,;  // checksum
                   barcode.wide2_5.value,;  // wide2_5
                   barcode.wide3.value )  // wide3                    
   IF hBitMap == 0
      RETURN Nil
   ENDIF      

   SET WINDOW barcode TRANSPARENT TO 150   // nAlphaBlend = 0 to 255 (completely transparent = 0, opaque = 255)

   DEFINE WINDOW Form1;
      AT BT_DesktopHeight()/2, BT_DesktopWidth()/2 ;
      WIDTH  BT_BitmapWidth  ( hBitmap ) + 100;
      HEIGHT BT_BitmapHeight ( hBitmap ) + 100;
      TITLE 'Display Bar Code' ;
      MODAL;
      ON RELEASE {|| BT_BitmapRelease ( hBitmap ), SET WINDOW barcode TRANSPARENT TO OPAQUE }

      @ 10, 10 IMAGE Image1 PICTURE ""
      BT_HMGSetImage ("Form1", "Image1", hBitmap)
   END WINDOW
   FLASH WINDOW Form1 COUNT 5 INTERVAL 50
   ACTIVATE WINDOW Form1
         
RETURN NIL   


function CreateBarCodepng
   local cImageFileName := ''
   cImageFileName := putfile( { { "PNG Files", "*.png" } }, "Save Barcode to PNG File" )
   if HMG_len( cImageFileName ) == 0
      return nil
   endif
   if file( cImageFileName )
      if msgyesno( 'Image file already exists. Do you want to overwrite?' )
         ferase( cImageFileName )
      else
         return nil
      endif
   endif
   HMG_CreateBarCode( barcode.code.value,;
                   barcode.type.item( barcode.type.value ),;
                   barcode.linewidth.value,;
                   barcode.lineheight.value,;
                   barcode.showdigits.value,;
                   cImageFileName,;
                   aBarColor,;
                   aBackColor,;
                   barcode.checksum.value,;  // checksum
                   barcode.wide2_5.value,;  // wide2_5
                   barcode.wide3.value )  // wide3                    
   if file( cImageFileName )
      _Execute ( GetActiveWindow() , , cImageFileName, , , 5 )
   endif         
RETURN NIL 

function changebarcolor
   local aColor := getcolor( barcode.barcolor.fontcolor )
   if valtype( acolor[ 1 ] ) == 'N'
      barcode.barcolor.fontcolor := aColor
      aBarColor := aColor
   endif   
return nil
   

function changebackcolor
   local aColor := getcolor( barcode.backgroundcolor.backcolor )
   if valtype( acolor[ 1 ] ) == 'N'
      barcode.backgroundcolor.backcolor := aColor
      aBackColor := aColor
   endif
return nil