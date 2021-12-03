/*
* HMG Data-Bound Grid Demo
* (c) 2010 Roberto Lopez
*/

#include <hmg.ch>

Function Main

   SET CELLNAVIGATIONMODE EXCEL

   define window sample at 0, 0 width 320 height 200 title 'Sample Cell Navigation Downwards...' main
      define grid grid_1
         row 10
         col 10
         width 300
         height 150
         widths { 100, 170 }
         headers { 'Sl.No.', 'Name' }
         cellnavigation .t.
         columnwhen { {|| .t. }, {|| .t. } }
         columncontrols { { 'TEXTBOX', 'NUMERIC', '999' }, { 'TEXTBOX', 'CHARACTER' } }
         allowedit .t.
         items { { 0, '' }, { 0, '' }, { 0, '' }, { 0, '' }, { 0, '' }, { 0, '' }, { 0, '' }, { 0, '' }, { 0, '' } }
      end grid         
   end window
   sample.center
   sample.activate
   Return