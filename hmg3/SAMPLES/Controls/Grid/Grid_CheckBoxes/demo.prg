#include "hmg.ch"

Function Main
Local aRows

   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 800 ;
      HEIGHT 600 ;
      TITLE "Demo: GRID CheckBox" ;
      MAIN

      aRows := ARRAY (25)
      aRows [1]   := {'Simpson',    'Homer'     }
      aRows [2]   := {'Mulder',     'Fox'       }
      aRows [3]   := {'Smart',      'Max'       }
      aRows [4]   := {'Grillo',     'Pepe'      }
      aRows [5]   := {'Kirk',       'James'     }
      aRows [6]   := {'Barriga',    'Carlos'    }
      aRows [7]   := {'Flanders',   'Ned'       }
      aRows [8]   := {'Smith',      'John'      }
      aRows [9]   := {'Pedemonti',  'Flavio'    }
      aRows [10]  := {'Gomez',      'Juan'      }
      aRows [11]  := {'Fernandez',  'Raul'      }
      aRows [12]  := {'Borges',     'Javier'    }
      aRows [13]  := {'Alvarez',    'Alberto'   }
      aRows [14]  := {'Gonzalez',   'Ambo'      }
      aRows [15]  := {'Gracie',     'Helio'     }
      aRows [16]  := {'Vinazzi',    'Amigo'     }
      aRows [17]  := {'Gracie',     'Royce'     }
      aRows [18]  := {'Samarbide',  'Armando'   }
      aRows [19]  := {'Pradon',     'Alejandra' }
      aRows [20]  := {'Reyes',      'Monica'    }
      aRows [21]  := {'Silva',      'Anderson'  }
      aRows [22]  := {'Machida',    'Lyoto'     }
      aRows [23]  := {'Nogueira',   'Rodrigo'   }
      aRows [24]  := {'Belford',    'Victor'    }
      aRows [25]  := {'Werdum',     'Fabricio'  }


      @ 50,10 GRID Grid_1 ;
         WIDTH 750 ;
         HEIGHT 350 ;
         HEADERS {'Last Name', 'First Name'};
         WIDTHS  {140, 140};
         ITEMS aRows;
         VALUE 1;
         CELLNAVIGATION;
         ON CHECKBOXCLICKED MsgInfo ({"Row: ", This.CellRowClicked, " is checked: ", Form_1.Grid_1.CheckBoxItem (This.CellRowClicked)}, "On CheckBoxClicked")

      Form_1.Grid_1.CheckBoxEnabled := .T.

      @ 450, 155 BUTTON Button_1 CAPTION "CheckBoxEnabled ON/OFF" ACTION Form_1.Grid_1.CheckBoxEnabled := .NOT. Form_1.Grid_1.CheckBoxEnabled
      @ 450, 555 BUTTON Button_2 CAPTION "Check List" ACTION GetListCheckBox()

   END WINDOW

   CENTER WINDOW Form_1

   ACTIVATE WINDOW Form_1

Return



PROCEDURE GetListCheckBox
Local i, cList := ""
   IF Form_1.Grid_1.CheckBoxEnabled == .T.
      FOR i = 1 TO Form_1.Grid_1.ItemCount
         IF Form_1.Grid_1.CheckBoxItem ( i ) == .T.
            cList := cList + Form_1.Grid_1.CellEx (i, 1) +", "+ Form_1.Grid_1.CellEx (i, 2) + HB_OsNewLine()
         ENDIF
      NEXT
      IF EMPTY (cList)
         cList := "Empty List"
      ENDIF
      MsgInfo (cList, "Check List")
   ELSE
      MsgInfo ("CheckBoxEnabled is FALSE")
   ENDIF
RETURN


