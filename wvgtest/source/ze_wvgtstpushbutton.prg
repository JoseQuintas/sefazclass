#include "hbclass.ch"
#include "wvtwin.ch"
#include "wvgparts.ch"

CREATE CLASS wvgTstPushButton INHERIT wvgPushButton

   VAR    lImageSizeMax INIT .F.
   METHOD setCaption( xCaption, cDll )

ENDCLASS

METHOD wvgTstPushButton:setCaption( xCaption, cDll )

   LOCAL nLoadFromResByIdNumber := 0
   LOCAL nLoadFromResByIdName   := 1
   LOCAL nLoadFromDiskFile      := 2
   LOCAL aSize, nWidth, nHeight

   __defaultNIL( @xCaption, ::caption )
   HB_SYMBOL_UNUSED( cDll )

   ::caption := xCaption

   IF HB_ISSTRING( xCaption )
      IF ".ICO" == Upper( Right( ::caption, 4 ) )
         wvg_SendMessage( ::hWnd, BM_SETIMAGE, IMAGE_ICON, wvg_LoadImage( ::caption, nLoadFromDiskFile, IMAGE_ICON ) )
      ELSEIF ".BMP" == Upper( Right( ::caption, 4 ) )
         wvg_SendMessage( ::hWnd, BM_SETIMAGE, IMAGE_BITMAP, wvg_LoadImage( ::caption, nLoadFromDiskFile, IMAGE_BITMAP ) )
      ELSE
         wvg_SendMessageText( ::hWnd, WM_SETTEXT, 0, ::caption )
      ENDIF

   ELSEIF HB_ISNUMERIC( xCaption )  /* Handle to the bitmap */
      wvg_SendMessage( ::hWnd, BM_SETIMAGE, IMAGE_BITMAP, ::caption )

   ELSEIF HB_ISARRAY( xCaption )
      ASize( xCaption, 4 )
      IF HB_ISCHAR( xCaption[ 1 ] )
         wvg_SendMessageText( ::hWnd, WM_SETTEXT, 0, xCaption[ 1 ] )
      ENDIF
      IF ! Empty( xCaption[ 2 ] )
         aSize := ::CurrentSize()
         IF ::lImageSizeMax
            nWidth := aSize[1] // aSize[ 1 ] - 8
            nHeight := aSize[2] // aSize[ 2 ] - wvt_GetFontInfo()[ 6 ] - 8
         ELSE
            nWidth  := Min( aSize[1], aSize[2] ) / 2
            nHeight := nWidth
         ENDIF
         SWITCH xCaption[ 2 ]
         CASE WVG_IMAGE_ICONFILE
            wvg_SendMessage( ::hWnd, BM_SETIMAGE, IMAGE_ICON, wvg_LoadImage( xCaption[ 3 ], nLoadFromDiskFile, IMAGE_ICON, nWidth, nHeight ) )
            EXIT
         CASE WVG_IMAGE_ICONRESOURCE
            IF HB_ISSTRING( xCaption[ 3 ] )
               wvg_SendMessage( ::hWnd, BM_SETIMAGE, IMAGE_ICON, wvg_LoadImage( xCaption[ 3 ], nLoadFromResByIdName, IMAGE_ICON, nWidth, nHeight ) )
            ELSE
               wvg_SendMessage( ::hWnd, BM_SETIMAGE, IMAGE_ICON, wvg_LoadImage( xCaption[ 3 ], nLoadFromResByIdNumber, IMAGE_ICON, nWidth, nHeight ) )
            ENDIF
            EXIT
         CASE WVG_IMAGE_BITMAPFILE
            wvg_SendMessage( ::hWnd, BM_SETIMAGE, IMAGE_BITMAP, wvg_LoadImage( xCaption[ 3 ], nLoadFromDiskFile, IMAGE_BITMAP, nWidth, nHeight ) )
            EXIT
         CASE WVG_IMAGE_BITMAPRESOURCE
            IF HB_ISSTRING( xCaption[ 3 ] )
               wvg_SendMessage( ::hWnd, BM_SETIMAGE, IMAGE_BITMAP, wvg_LoadImage( xCaption[ 3 ], nLoadFromResByIdName, IMAGE_BITMAP, nWidth, nHeight ) )
            ELSE
               wvg_SendMessage( ::hWnd, BM_SETIMAGE, IMAGE_BITMAP, wvg_LoadImage( xCaption[ 3 ], nLoadFromResByIdNumber, IMAGE_BITMAP, nWidth, nHeight ) )
            ENDIF
            EXIT
         ENDSWITCH
      ENDIF
   ENDIF

   RETURN Self
