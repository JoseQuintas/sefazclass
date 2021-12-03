
/*----------------------------------------------------------------------------
 BOS TAURUS - Graphic Library for HMG

 Copyright 2012-2017 by Dr. Claudio Soto (from Uruguay).
 mail: <srvet@adinet.com.uy>
 blog: http://srvet.blogspot.com

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor Boston, MA 02110-1301, USA
 (or visit their web site at http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of BOS TAURUS.

 The exception is that, if you link the BOS TAURUS library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 BOS TAURUS library code into it.
----------------------------------------------------------------------------*/

/*
*******************************************************************************
* ARCHIVO:  BosTaurus.c
* LENGUAJE: HMG
* FECHA:    Setiembre 2012
* AUTOR:    Dr. CLAUDIO SOTO
* PAIS:     URUGUAY
* E-MAIL:   srvet@adinet.com.uy
* BLOG:     http://srvet.blogspot.com
*******************************************************************************
*/


// **********************************************************************************************************************************
//  FUNCTIONS in C
// **********************************************************************************************************************************



#define COMPILE_HMG_UNICODE

#include "HMG_UNICODE.h"


#ifndef WINVER
   #define WINVER 0x0501   // minimum requirements: Windows XP
#endif


#define COBJMACROS

#include <windows.h>
#include <shlobj.h>
#include <commctrl.h>
#include <olectl.h>
#include <time.h>
#include <math.h>
#include <tchar.h>
#include <wchar.h>

#include "hbvm.h"
#include "hbapiitm.h"
#include "hbapi.h"

#include "hbthread.h"
extern HB_CRITICAL_T _HMG_Mutex;   // global Mutex variable defined into c_Thread.c

#ifdef __BORLANDC__
   #ifndef BT_BCC_LINK_LIB
       #define BT_BCC_LINK_LIB  "C:\Borland\BCC55\Lib\PSDK\msimg32.lib"  // If necessary define adequate path in your application before include header files
   #endif
   #pragma comment (lib, BT_BCC_LINK_LIB)   // for Borland C Compiler (HMG Extended)
#endif


// ::::::::::::::::::::::::::::::::::::
// :::   INTERNAL Functions in C    :::
// ::::::::::::::::::::::::::::::::::::



//*************************************************************************************************
//* bt_MsgDebugInfo (_TEXT("Info: Text=%s  Num1=%d  Num2=%d"), String, Num1, Num2);
//*************************************************************************************************
void bt_MsgDebugInfo (TCHAR *Format, ...)
{
   TCHAR Buffer [1024];
   va_list Args;
   va_start (Args, Format);
   wvsprintf (Buffer, Format, Args);
   MessageBox (NULL, Buffer, _TEXT("BT - DEBUG INFO"), MB_OK);
}


//*************************************************************************************************
//* bt_bmp_adjust_rect (&Width1, &Height1, &Width2, &Height2, Mode_Stretch)
//*************************************************************************************************

// Mode_Stretch
#define BT_SCALE   0
#define BT_STRETCH 1
#define BT_COPY    3

void bt_bmp_adjust_rect (int *Width1, int *Height1, int *Width2, int *Height2, int Mode_Stretch)
{
   switch (Mode_Stretch)
   {
        case BT_SCALE:
             if ((int)(*Width2 * *Height1 / *Height2) <= *Width1)
                *Width1=   (int) (*Width2 * *Height1 / *Height2);
             else
                *Height1 = (int) (*Height2 * *Width1 / *Width2);
             break;

        case BT_STRETCH:
             break;

        case BT_COPY:
             *Width1  = *Width2  = min (*Width1,  *Width2);
             *Height1 = *Height2 = min (*Height1, *Height2);
             break;
   }
}


//*************************************************************************************************
//* bt_bmp_is_24bpp (hBitmap) ---> Return TRUE or FALSE
//*************************************************************************************************

BOOL bt_bmp_is_24bpp (HBITMAP hBitmap)
{
   BITMAP bm;
   GetObject (hBitmap, sizeof(BITMAP), (LPBYTE)&bm);
   if (bm.bmBitsPixel == 24)
      return TRUE;
   else
      return FALSE;
}


//*************************************************************************************************
//* bt_bmp_create_24bpp (int Width, int Height) ---> Return hBITMAP
//*************************************************************************************************

HBITMAP bt_bmp_create_24bpp (int Width, int Height)
{
    LPBYTE  Bitmap_mem_pBits;
    HBITMAP hBitmap_mem;
    HDC hDC_mem;
    BITMAPINFO Bitmap_Info;

    hDC_mem = CreateCompatibleDC(NULL);

    Bitmap_Info.bmiHeader.biSize          = sizeof(BITMAPINFOHEADER);
    Bitmap_Info.bmiHeader.biWidth         = Width;
    Bitmap_Info.bmiHeader.biHeight        = -Height;
    Bitmap_Info.bmiHeader.biPlanes        = 1;
    Bitmap_Info.bmiHeader.biBitCount      = 24;
    Bitmap_Info.bmiHeader.biCompression   = BI_RGB;
    Bitmap_Info.bmiHeader.biSizeImage     = 0;
    Bitmap_Info.bmiHeader.biXPelsPerMeter = 0;
    Bitmap_Info.bmiHeader.biYPelsPerMeter = 0;
    Bitmap_Info.bmiHeader.biClrUsed       = 0;
    Bitmap_Info.bmiHeader.biClrImportant  = 0;

    hBitmap_mem = CreateDIBSection(hDC_mem, (BITMAPINFO *) &Bitmap_Info, DIB_RGB_COLORS, (VOID **) &Bitmap_mem_pBits, NULL, 0);

    DeleteDC(hDC_mem);

    return hBitmap_mem;
}


//*************************************************************************************************
//* bt_bmp_convert_to_24bpp (hBitmap, IsDelete_hBitmap_Original) ---> Return New_hBitmap
//*************************************************************************************************

// IsDelete_hBitmap_Original
#define BMP_DELETE_ORIGINAL_HBITMAP      TRUE
#define BMP_NOT_DELETE_ORIGINAL_HBITMAP  FALSE

HBITMAP bt_bmp_convert_to_24bpp (HBITMAP hBitmap_Original, BOOL IsDelete_hBitmap_Original)
{
   HDC memDC1, memDC2;
   HBITMAP hBitmap_New;
   BITMAP bm;

   GetObject (hBitmap_Original, sizeof(BITMAP), (LPBYTE)&bm);
   hBitmap_New = bt_bmp_create_24bpp (bm.bmWidth, bm.bmHeight);

   memDC1 = CreateCompatibleDC(NULL);
   SelectObject(memDC1, hBitmap_Original);

   memDC2 = CreateCompatibleDC(NULL);
   SelectObject(memDC2, hBitmap_New);

   StretchBlt(memDC2, 0, 0, bm.bmWidth, bm.bmHeight, memDC1, 0, 0, bm.bmWidth, bm.bmHeight, SRCCOPY);

   DeleteDC(memDC1);
   DeleteDC(memDC2);

   if (IsDelete_hBitmap_Original)
       DeleteObject (hBitmap_Original);

   return hBitmap_New;
}



//*********************************************************************************************************************
// bt_LoadFileFromResources (FileName, TypeResource) ---> Return hGlobalAlloc
//*********************************************************************************************************************
HGLOBAL bt_LoadFileFromResources (TCHAR * FileName, TCHAR * TypeResource)
{
   HRSRC     hResourceData;
   HGLOBAL   hGlobalAlloc,  hGlobalResource;
   LPVOID    lpGlobalAlloc, lpGlobalResource;
   DWORD     nFileSize;

   hResourceData = FindResource (NULL, FileName, TypeResource);
   if (hResourceData == NULL)
       return NULL;

   hGlobalResource = LoadResource (NULL, hResourceData);
   if (hGlobalResource == NULL)
       return NULL;

   lpGlobalResource  = LockResource (hGlobalResource);
   if (lpGlobalResource == NULL)
       return NULL;

   nFileSize = SizeofResource (NULL, hResourceData);

   hGlobalAlloc = GlobalAlloc (GHND, nFileSize);
   if (hGlobalAlloc == NULL)
   {   FreeResource (hGlobalResource);
       return NULL;
   }

   lpGlobalAlloc = GlobalLock (hGlobalAlloc);
   memcpy (lpGlobalAlloc, lpGlobalResource, nFileSize);
   GlobalUnlock (hGlobalAlloc);

   FreeResource (hGlobalResource);

   return hGlobalAlloc;
}


//*********************************************************************************************************************
// bt_LoadFileFromDisk (FileName) ---> Return hGlobalAlloc
//*********************************************************************************************************************
HGLOBAL bt_LoadFileFromDisk (TCHAR * FileName)
{
   HGLOBAL   hGlobalAlloc;
   LPVOID    lpGlobalAlloc;
   HANDLE    hFile;
   DWORD     nFileSize;
   DWORD     nReadByte;

   hFile = CreateFile (FileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
   if (hFile == INVALID_HANDLE_VALUE)
       return NULL;

   nFileSize = GetFileSize (hFile, NULL);
   if (nFileSize == INVALID_FILE_SIZE)
   {   CloseHandle (hFile);
       return NULL;
   }

   hGlobalAlloc = GlobalAlloc (GHND, nFileSize);
   if (hGlobalAlloc == NULL)
   {   CloseHandle (hFile);
       return NULL;
   }
   lpGlobalAlloc = GlobalLock (hGlobalAlloc);
   ReadFile (hFile, lpGlobalAlloc, nFileSize, &nReadByte, NULL);
   GlobalUnlock (hGlobalAlloc);

   CloseHandle (hFile);

   return hGlobalAlloc;
}

BOOL _bt_OleInitialize_Flag_ = FALSE;

//*************************************************************************************************************
//  bt_LoadOLEPicture (FileName, TypePicture) ---> Return hBitmap  (Load GIF and JPG image)
//*************************************************************************************************************
HBITMAP bt_LoadOLEPicture (TCHAR * FileName, TCHAR * TypePictureResource)
{
   IStream    *iStream;
   IPicture   *iPicture;
   HBITMAP    hBitmap;
   HDC        memDC;
   HGLOBAL    hGlobalAlloc;
   LONG       hmWidth, hmHeight;
   INT        pxWidth, pxHeight;
   POINT      Point;

   if (TypePictureResource != NULL)
       hGlobalAlloc = bt_LoadFileFromResources (FileName, TypePictureResource);
   else
       hGlobalAlloc = bt_LoadFileFromDisk (FileName);

   if (hGlobalAlloc == NULL)
       return NULL;

   if (_bt_OleInitialize_Flag_ == FALSE)
   {   _bt_OleInitialize_Flag_ = TRUE;
       OleInitialize (NULL);
   }

   iPicture = NULL;
   CreateStreamOnHGlobal (hGlobalAlloc, TRUE, &iStream);
   OleLoadPicture (iStream, 0, TRUE, &IID_IPicture, (LPVOID*)&iPicture);
   if (iPicture == NULL)
   {   GlobalFree (hGlobalAlloc);
       return NULL;
   }

   iPicture->lpVtbl->get_Width  (iPicture, &hmWidth);
   iPicture->lpVtbl->get_Height (iPicture, &hmHeight);

   memDC  = CreateCompatibleDC (NULL);
   //SetStretchBltMode (memDC, COLORONCOLOR);
   GetBrushOrgEx (memDC, &Point);
   SetStretchBltMode (memDC, HALFTONE);
   SetBrushOrgEx (memDC, Point.x, Point.y, NULL);


   // Convert HiMetric to Pixel
   #define HIMETRIC_PER_INCH          2540    // Number of HIMETRIC units per INCH
   #define bt_LOGHIMETRIC_TO_PIXEL(hm, ppli)   MulDiv((hm), (ppli), HIMETRIC_PER_INCH)   // ppli = Point per Logic Inch
   #define bt_PIXEL_TO_LOGHIMETRIC(px, ppli)   MulDiv((px), HIMETRIC_PER_INCH, (ppli))   // ppli = Point per Logic Inch

   pxWidth  = bt_LOGHIMETRIC_TO_PIXEL (hmWidth,  GetDeviceCaps (memDC, LOGPIXELSX));
   pxHeight = bt_LOGHIMETRIC_TO_PIXEL (hmHeight, GetDeviceCaps (memDC, LOGPIXELSY));

   hBitmap = bt_bmp_create_24bpp (pxWidth, pxHeight);
   SelectObject (memDC, hBitmap);

   iPicture->lpVtbl->Render  (iPicture, memDC, 0, 0, pxWidth, pxHeight, 0, hmHeight, hmWidth, -hmHeight, NULL);
   iPicture->lpVtbl->Release (iPicture);
   iStream->lpVtbl->Release  (iStream);

   DeleteDC (memDC);
   GlobalFree (hGlobalAlloc);

   return hBitmap;
}




//*************************************************************************************************************
//  GDI Plus: Functions and Definitions
//*************************************************************************************************************



// Begin GDIPLUS Definitions
typedef enum GpStatus {
        Ok                        = 0,
        GenericError              = 1,
        InvalidParameter          = 2,
        OutOfMemory               = 3,
        ObjectBusy                = 4,
        InsufficientBuffer        = 5,
        NotImplemented            = 6,
        Win32Error                = 7,
        WrongState                = 8,
        Aborted                   = 9,
        FileNotFound              = 10,
        ValueOverflow             = 11,
        AccessDenied              = 12,
        UnknownImageFormat        = 13,
        FontFamilyNotFound        = 14,
        FontStyleNotFound         = 15,
        NotTrueTypeFont           = 16,
        UnsupportedGdiplusVersion = 17,
        GdiplusNotInitialized     = 18,
        PropertyNotFound          = 19,
        PropertyNotSupported      = 20,
        ProfileNotFound           = 21
} GpStatus;


#define WINGDIPAPI __stdcall
#define GDIPCONST const
typedef void GpBitmap;
typedef void GpGraphics;
typedef void GpImage;
typedef void *DebugEventProc;


typedef struct GdiplusStartupInput {
        UINT32         GdiplusVersion;
        DebugEventProc DebugEventCallback;
        BOOL           SuppressBackgroundThread;
        BOOL           SuppressExternalCodecs;
} GdiplusStartupInput;


typedef GpStatus WINGDIPAPI (*NotificationHookProc)(ULONG_PTR *token);
typedef VOID WINGDIPAPI (*NotificationUnhookProc)(ULONG_PTR token);


typedef struct GdiplusStartupOutput {
        NotificationHookProc NotificationHook;
        NotificationUnhookProc NotificationUnhook;
} GdiplusStartupOutput;


typedef struct ImageCodecInfo {
        CLSID Clsid;
        GUID FormatID;
        WCHAR *CodecName;
        WCHAR *DllName;
        WCHAR *FormatDescription;
        WCHAR *FilenameExtension;
        WCHAR *MimeType;
        DWORD Flags;
        DWORD Version;
        DWORD SigCount;
        DWORD SigSize;
        BYTE *SigPattern;
        BYTE *SigMask;
} ImageCodecInfo;

typedef struct EncoderParameter {
        GUID Guid;
        ULONG NumberOfValues;
        ULONG Type;
        VOID *Value;
} EncoderParameter;

typedef struct EncoderParameters {
        UINT Count;
        EncoderParameter Parameter[1];
} EncoderParameters;

typedef ULONG ARGB;
typedef GpStatus (WINGDIPAPI *Func_GdiPlusStartup)              (ULONG_PTR*, GDIPCONST GdiplusStartupInput*, GdiplusStartupOutput*);
typedef VOID     (WINGDIPAPI *Func_GdiPlusShutdown)             (ULONG_PTR);
typedef GpStatus (WINGDIPAPI *Func_GdipCreateBitmapFromStream)  (IStream*, GpBitmap**);
typedef GpStatus (WINGDIPAPI *Func_GdipCreateHBITMAPFromBitmap) (GpBitmap*, HBITMAP*, ARGB);
typedef GpStatus (WINGDIPAPI *Func_GdipCreateFromHDC)           (HDC, GpGraphics**);
typedef GpStatus (WINGDIPAPI *Func_GdipDrawImageI)              (GpGraphics*,GpImage*,INT,INT);

typedef GpStatus (WINGDIPAPI *Func_GdipGetImageEncodersSize)    (UINT*, UINT*);
typedef GpStatus (WINGDIPAPI *Func_GdipGetImageEncoders)        (UINT, UINT, ImageCodecInfo*);
typedef GpStatus (WINGDIPAPI *Func_GdipSaveImageToFile)         (GpImage*,GDIPCONST WCHAR*,GDIPCONST CLSID*,GDIPCONST EncoderParameters*);
typedef GpStatus (WINGDIPAPI *Func_GdipLoadImageFromStream)     (IStream*,GpImage**);

// End GDIPLUS Definitions


// GDI Plus Functions
static Func_GdiPlusStartup              GdiPlusStartup;
static Func_GdiPlusShutdown             GdiPlusShutdown;
static Func_GdipCreateBitmapFromStream  GdipCreateBitmapFromStream;
static Func_GdipCreateHBITMAPFromBitmap GdipCreateHBITMAPFromBitmap;

static Func_GdipGetImageEncodersSize    GdipGetImageEncodersSize;
static Func_GdipGetImageEncoders        GdipGetImageEncoders;
static Func_GdipLoadImageFromStream     GdipLoadImageFromStream;
static Func_GdipSaveImageToFile         GdipSaveImageToFile;

// Global Variables
static VOID                 *GdiPlusHandle = NULL;
static ULONG_PTR            GdiPlusToken;
static GdiplusStartupInput  GDIPlusStartupInput;

BOOL bt_Load_GDIplus (void);
BOOL bt_Release_GDIplus (void);

//  Load Library GDI Plus
BOOL bt_Load_GDIplus ()
{
_THREAD_LOCK();
   GdiPlusHandle = LoadLibrary (_TEXT("GdiPlus.dll"));
_THREAD_UNLOCK();
   if (GdiPlusHandle == NULL)
       return FALSE;

_THREAD_LOCK();
   GdiPlusStartup              = (Func_GdiPlusStartup)              GetProcAddress (GdiPlusHandle, "GdiplusStartup");
   GdiPlusShutdown             = (Func_GdiPlusShutdown)             GetProcAddress (GdiPlusHandle, "GdiplusShutdown");
   GdipCreateBitmapFromStream  = (Func_GdipCreateBitmapFromStream)  GetProcAddress (GdiPlusHandle, "GdipCreateBitmapFromStream");
   GdipCreateHBITMAPFromBitmap = (Func_GdipCreateHBITMAPFromBitmap) GetProcAddress (GdiPlusHandle, "GdipCreateHBITMAPFromBitmap");

   GdipGetImageEncodersSize    = (Func_GdipGetImageEncodersSize)    GetProcAddress (GdiPlusHandle, "GdipGetImageEncodersSize");
   GdipGetImageEncoders        = (Func_GdipGetImageEncoders)        GetProcAddress (GdiPlusHandle, "GdipGetImageEncoders");
   GdipLoadImageFromStream     = (Func_GdipLoadImageFromStream)     GetProcAddress (GdiPlusHandle, "GdipLoadImageFromStream");
   GdipSaveImageToFile         = (Func_GdipSaveImageToFile)         GetProcAddress (GdiPlusHandle, "GdipSaveImageToFile");
_THREAD_UNLOCK();

   if ( GdiPlusStartup               == NULL ||
        GdiPlusShutdown              == NULL ||
        GdipCreateBitmapFromStream   == NULL ||
        GdipCreateHBITMAPFromBitmap  == NULL ||
        GdipGetImageEncodersSize     == NULL ||
        GdipGetImageEncoders         == NULL ||
        GdipLoadImageFromStream      == NULL ||
        GdipSaveImageToFile          == NULL)
   {
   _THREAD_LOCK();
       FreeLibrary (GdiPlusHandle);
       GdiPlusHandle = NULL;
   _THREAD_UNLOCK();
       return FALSE;
   }

_THREAD_LOCK();
   GDIPlusStartupInput.GdiplusVersion           = 1;
   GDIPlusStartupInput.DebugEventCallback       = NULL;
   GDIPlusStartupInput.SuppressBackgroundThread = FALSE;
   GDIPlusStartupInput.SuppressExternalCodecs   = FALSE;
_THREAD_UNLOCK();

   if (GdiPlusStartup (&GdiPlusToken, &GDIPlusStartupInput, NULL))
   {
   _THREAD_LOCK();
       FreeLibrary (GdiPlusHandle);
       GdiPlusHandle = NULL;
   _THREAD_UNLOCK();
       return FALSE;
   }

   return TRUE;
}


//  Release Library GDI Plus
BOOL bt_Release_GDIplus ()
{
_THREAD_LOCK();
   BOOL ret;
   if (GdiPlusHandle == NULL)
      ret = FALSE;
   else
   {  GdiPlusShutdown (GdiPlusToken);
      FreeLibrary (GdiPlusHandle);
      GdiPlusHandle = NULL;
      ret = TRUE;
   }
_THREAD_UNLOCK();
   return ret;
}



//*************************************************************************************************************
//  bt_LoadGDIPlusPicture (FileName, TypePicture) ---> Return hBitmap  (Load BMP, GIF, JPG, TIF and PNG image)
//*************************************************************************************************************

HBITMAP bt_LoadGDIPlusPicture (TCHAR *FileName, TCHAR *TypePictureResource)
{
   IStream   *iStream;
   HBITMAP   hBitmap;
   HGLOBAL   hGlobalAlloc;
   GpBitmap  *pGpBitmap;
   ARGB      BkColor;

   if (bt_Load_GDIplus () == FALSE)
       return NULL;

   if (TypePictureResource != NULL)
       hGlobalAlloc = bt_LoadFileFromResources (FileName, TypePictureResource);
   else
       hGlobalAlloc = bt_LoadFileFromDisk (FileName);

   if (hGlobalAlloc == NULL)
       return NULL;

   iStream = NULL;
   if (CreateStreamOnHGlobal (hGlobalAlloc, FALSE, &iStream) == S_OK)
   {   hBitmap = NULL;
       BkColor = 0xFF000000UL;
       GdipCreateBitmapFromStream  (iStream,   &pGpBitmap);
       GdipCreateHBITMAPFromBitmap (pGpBitmap, &hBitmap, BkColor);
       iStream->lpVtbl->Release (iStream);
   }

   bt_Release_GDIplus ();
   GlobalFree (hGlobalAlloc);
   return hBitmap;
}



//***********************************************************************************************************************
// bt_SaveGDIPlusPicture (hBitmap, FileName, TypePicture) // Return TRUE/FALSE  (Save BMP, GIF, JPG, TIF and PNG image)
//***********************************************************************************************************************

// Internal Function: bt_Bitmap_To_Stream () ---> Return hGlobalAlloc
HGLOBAL bt_Bitmap_To_Stream (HBITMAP hBitmap)
{
   HGLOBAL hGlobalAlloc;
   LPBYTE  lp_hGlobalAlloc;
   HDC memDC;
   BITMAPFILEHEADER BIFH;
   BITMAPINFO Bitmap_Info;
   BITMAP bm;
   DWORD nBytes_Bits;

   memDC = CreateCompatibleDC(NULL);
         SelectObject(memDC, hBitmap);
         GetObject(hBitmap, sizeof(BITMAP), (LPBYTE)&bm);

         bm.bmBitsPixel = 24;
         bm.bmWidthBytes = (bm.bmWidth * bm.bmBitsPixel + 31) / 32 * 4;
         nBytes_Bits = (DWORD)(bm.bmWidthBytes * labs(bm.bmHeight));


         BIFH.bfType = ('M' << 8) + 'B';
         BIFH.bfSize = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER) + nBytes_Bits;
         BIFH.bfReserved1 = 0;
         BIFH.bfReserved2 = 0;
         BIFH.bfOffBits = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);


         Bitmap_Info.bmiHeader.biSize          = sizeof(BITMAPINFOHEADER);
         Bitmap_Info.bmiHeader.biWidth         = bm.bmWidth;
         Bitmap_Info.bmiHeader.biHeight        = bm.bmHeight;
         Bitmap_Info.bmiHeader.biPlanes        = 1;
         Bitmap_Info.bmiHeader.biBitCount      = 24;
         Bitmap_Info.bmiHeader.biCompression   = BI_RGB;
         Bitmap_Info.bmiHeader.biSizeImage     = 0; //nBytes_Bits;
         Bitmap_Info.bmiHeader.biXPelsPerMeter = 0;
         Bitmap_Info.bmiHeader.biYPelsPerMeter = 0;
         Bitmap_Info.bmiHeader.biClrUsed       = 0;
         Bitmap_Info.bmiHeader.biClrImportant  = 0;

         hGlobalAlloc = GlobalAlloc (GHND, (DWORD) (BIFH.bfSize));
         if (hGlobalAlloc == NULL)
             return NULL;

         lp_hGlobalAlloc = (LPBYTE) GlobalLock (hGlobalAlloc);

         memcpy (lp_hGlobalAlloc, &BIFH, sizeof(BITMAPFILEHEADER));
         memcpy ((lp_hGlobalAlloc + sizeof(BITMAPFILEHEADER)), &Bitmap_Info, sizeof(BITMAPINFO));
         GetDIBits (memDC, hBitmap, 0, Bitmap_Info.bmiHeader.biHeight, (LPVOID) (lp_hGlobalAlloc + BIFH.bfOffBits), &Bitmap_Info, DIB_RGB_COLORS);


         GlobalUnlock (hGlobalAlloc);
         DeleteDC(memDC);

         return hGlobalAlloc;
}


// Internal Function: bt_GetEncoderCLSID () ---> Return TRUE/FALSE
BOOL bt_GetEncoderCLSID (WCHAR *format, CLSID *pClsid)
{
   UINT  num = 0;          // number of image encoders
   UINT  size = 0;         // size of the image encoder array in bytes
   UINT i;
   ImageCodecInfo *pImageCodecInfo;

   GdipGetImageEncodersSize (&num, &size);
   if(size == 0)
      return FALSE;

   pImageCodecInfo = (ImageCodecInfo*)(malloc(size));
   if(pImageCodecInfo == NULL)
      return FALSE;

   GdipGetImageEncoders (num, size, pImageCodecInfo);

   for(i = 0; i < num; ++i)
   {
      if (wcscmp(pImageCodecInfo[i].MimeType, format) == 0)
      {  *pClsid = pImageCodecInfo[i].Clsid;
         free (pImageCodecInfo);
         return TRUE;
      }
   }
   free(pImageCodecInfo);
   return FALSE;
}


// bt_SaveGDIPlusPicture (hBitmap, FileName, TypePicture) ---> Return TRUE/FALSE  (Save BMP, GIF, JPG, TIF and PNG image)
#define BT_FILEFORMAT_BMP   0
#define BT_FILEFORMAT_JPG   1
#define BT_FILEFORMAT_GIF   2
#define BT_FILEFORMAT_TIF   3
#define BT_FILEFORMAT_PNG   4

BOOL bt_SaveGDIPlusPicture (HBITMAP hBitmap, TCHAR *FileName, INT TypePicture)
{
   CLSID    encoderClsid;
   BOOL     result;
   IStream  *iStream;
   GpImage  *image;
   WCHAR    format [21];
   HGLOBAL  hGlobalAlloc;
   INT      ret1, ret2;
   WCHAR    wFileName [MAX_PATH];

   switch (TypePicture)
   {
        case BT_FILEFORMAT_BMP:
             wcscpy (format, L"image/bmp");
             break;
        case BT_FILEFORMAT_JPG:
             wcscpy (format, L"image/jpeg");
             break;
        case BT_FILEFORMAT_GIF:
             wcscpy (format, L"image/gif");
             break;
        case BT_FILEFORMAT_TIF:
             wcscpy (format, L"image/tiff");
             break;
        case BT_FILEFORMAT_PNG:
             wcscpy (format, L"image/png");
             break;
        default:
             return FALSE;
   }

   if (bt_Load_GDIplus () == FALSE)
       return FALSE;

   result = bt_GetEncoderCLSID ((WCHAR *)format, &encoderClsid);

   if(result == TRUE)
   {
      hGlobalAlloc = bt_Bitmap_To_Stream (hBitmap);
      iStream = NULL;
      if (CreateStreamOnHGlobal (hGlobalAlloc, FALSE, &iStream) == S_OK)
      {
          #ifdef UNICODE
              lstrcpy (wFileName, FileName);
          #else
              MultiByteToWideChar(CP_ACP, 0, FileName, -1, wFileName, MAX_PATH);
          #endif

          ret1 = GdipLoadImageFromStream(iStream, &image);
          ret2 = GdipSaveImageToFile(image, wFileName, &encoderClsid, NULL);   // Save the image

          iStream->lpVtbl->Release (iStream);
          bt_Release_GDIplus ();

          GlobalFree (hGlobalAlloc);   // ADD, September 2016

          if (ret1 == 0 && ret2 == 0)
             return TRUE;
          else
             return FALSE;
      }
   }
   bt_Release_GDIplus ();
   return FALSE; // The File encoder is not installed
}





// ::::::::::::::::::::::::::::::::
// :::       DC Functions       :::
// ::::::::::::::::::::::::::::::::





//*****************************************************************************************
//* BT_STRUCT (Type, hWnd, hBitmap, hDC, PaintStruct)
//*****************************************************************************************

typedef struct
{    INT     Type;
     HWND    hWnd;
     HDC     hDC;
     PAINTSTRUCT PaintStruct;
} BT_STRUCT;


//****************************************************************************************************
//* BT_DC_CREATE (Type, [hWnd | hBitmap]) ---> Return array = {Type, hWnd, hBitmap, hDC, PaintStruct}
//****************************************************************************************************

// Type
#define BT_HDC_DESKTOP          1
#define BT_HDC_WINDOW           2
#define BT_HDC_ALLCLIENTAREA    3
#define BT_HDC_INVALIDCLIENTAREA  4
#define BT_HDC_BITMAP           5

HB_FUNC (BT_DC_CREATE)
{
   INT i;
   HBITMAP hBitmap;
   BT_STRUCT BT;
   ZeroMemory (&BT, sizeof(BT_STRUCT));

   BT.Type = (INT) hb_parni(1);
   switch (BT.Type)
   {
        case BT_HDC_DESKTOP:
             // BT.hDC  = CreateDC (_TEXT("DISPLAY"), NULL, NULL, NULL);
             // BT.hDC  = GetDC (NULL);
             BT.hWnd = GetDesktopWindow();
             BT.hDC  = GetDC (BT.hWnd);
             break;

        case BT_HDC_WINDOW:
             BT.hWnd = (HWND) HMG_parnl (2);
             BT.hDC = GetWindowDC (BT.hWnd);
             break;

        case BT_HDC_ALLCLIENTAREA:
             BT.hWnd = (HWND) HMG_parnl (2);
             BT.hDC = GetDC (BT.hWnd);
             break;

        case BT_HDC_INVALIDCLIENTAREA:
             BT.hWnd = (HWND) HMG_parnl (2);
             BT.hDC = BeginPaint (BT.hWnd, &BT.PaintStruct);
             break;

        case BT_HDC_BITMAP:
             hBitmap = (HBITMAP) HMG_parnl (2);
             BT.hDC  = CreateCompatibleDC(NULL);
             SelectObject(BT.hDC, hBitmap);
             break;

        default:
             hb_ret(); // Return NIL
             return;
   }

   hb_reta (50);   // Return array = {Type, hWnd, hBitmap, hDC, PaintStruct ...}

   hb_storvni   ((INT)      BT.Type,                       -1,  1);  // Type
   HMG_storvnl  ((LONG_PTR) BT.hWnd,                       -1,  2);  // hWnd
   HMG_storvnl  ((LONG_PTR) BT.hDC,                        -1,  3);  // hDC
   // PAINTSTRUCT
   HMG_storvnl ((LONG_PTR)  BT.PaintStruct.hdc,            -1,  4);   // HDC  hdc;
   hb_storvni  ((INT)       BT.PaintStruct.fErase,         -1,  5);   // BOOL fErase;
   hb_storvnl  ((LONG)      BT.PaintStruct.rcPaint.left,   -1,  6);   // RECT rcPaint.left;
   hb_storvnl  ((LONG)      BT.PaintStruct.rcPaint.top,    -1,  7);   // RECT rcPaint.top;
   hb_storvnl  ((LONG)      BT.PaintStruct.rcPaint.right,  -1,  8);   // RECT rcPaint.right;
   hb_storvnl  ((LONG)      BT.PaintStruct.rcPaint.bottom, -1,  9);   // RECT rcPaint.bottom;
   hb_storvni  ((INT)       BT.PaintStruct.fRestore,       -1, 10);   // BOOL fRestore;
   hb_storvni  ((INT)       BT.PaintStruct.fIncUpdate,     -1, 11);   // BOOL fIncUpdate;
   for (i=0; i < 32; i++)
       hb_storvni ((INT) BT.PaintStruct.rgbReserved[i], -1, 12+i);    // BYTE rgbReserved[32];

//   GdiSetBatchLimit (100);
}



//****************************************************************************************************
//* BT_DC_DELETE ({Type, hWnd, hBitmap, hDC, PaintStruct})
//****************************************************************************************************

HB_FUNC (BT_DC_DELETE)
{
   INT i;
   BT_STRUCT BT;

//   GdiSetBatchLimit (0);

   BT.Type     = (INT)  hb_parvni  (1, 1);
   BT.hWnd     = (HWND) HMG_parvnl (1, 2);
   BT.hDC      = (HDC)  HMG_parvnl (1, 3);
   // PAINTSTRUCT
   BT.PaintStruct.hdc            = (HDC)  HMG_parvnl (1,  4);   // HDC  hdc;
   BT.PaintStruct.fErase         = (BOOL) hb_parvni  (1,  5);   // BOOL fErase;
   BT.PaintStruct.rcPaint.left   = (LONG) hb_parvnl  (1,  6);   // RECT rcPaint.left;
   BT.PaintStruct.rcPaint.top    = (LONG) hb_parvnl  (1,  7);   // RECT rcPaint.top;
   BT.PaintStruct.rcPaint.right  = (LONG) hb_parvnl  (1,  8);   // RECT rcPaint.right;
   BT.PaintStruct.rcPaint.bottom = (LONG) hb_parvnl  (1,  9);   // RECT rcPaint.bottom;
   BT.PaintStruct.fRestore       = (BOOL) hb_parvni  (1, 10);   // BOOL fRestore;
   BT.PaintStruct.fIncUpdate     = (BOOL) hb_parvni  (1, 11);   // BOOL fIncUpdate;
   for (i=0; i < 32; i++)
       BT.PaintStruct.rgbReserved[i] = (BYTE) hb_parvni (1, 12+i); // BYTE rgbReserved[32];

   switch (BT.Type)
   {
        case BT_HDC_DESKTOP:
             // DeleteDC (BT.hDC);
             ReleaseDC (BT.hWnd, BT.hDC);
             break;

        case BT_HDC_WINDOW:
             ReleaseDC (BT.hWnd, BT.hDC);
             break;

        case BT_HDC_ALLCLIENTAREA:
             ReleaseDC (BT.hWnd, BT.hDC);
             break;

        case BT_HDC_INVALIDCLIENTAREA:
             EndPaint (BT.hWnd, &BT.PaintStruct);
             break;

        case BT_HDC_BITMAP:
             DeleteDC (BT.hDC);
             break;

        default:
             hb_retl(FALSE);
             return;
   }
   hb_retl(TRUE);
}





// ::::::::::::::::::::::::::::::::
// :::     SCREEN Functions     :::
// ::::::::::::::::::::::::::::::::





//**************************************************************************
//* BT_SCR_GETDESKTOPHANDLE ()
//**************************************************************************

HB_FUNC (BT_SCR_GETDESKTOPHANDLE)
{
   HWND hWnd = GetDesktopWindow ();
   HMG_retnl ((LONG_PTR) hWnd);
}



//**************************************************************************
//* BT_SCR_GETINFO (hWnd, Mode, info)
//**************************************************************************

// Mode
#define BT_SCR_DESKTOP    0
#define BT_SCR_WINDOW     1
#define BT_SCR_CLIENTAREA 2

// Info
#define BT_SCR_INFO_WIDTH  0
#define BT_SCR_INFO_HEIGHT 1

HB_FUNC (BT_SCR_GETINFO)
{
   HWND hWnd;
   HDC hDC = NULL;
   RECT rect;
   INT Mode, info;

   hWnd    = (HWND) HMG_parnl (1);
   Mode    = (INT)  hb_parni (2);
   info    = (INT)  hb_parni (3);

   switch (Mode)
   {    case BT_SCR_DESKTOP:
             break;
        case BT_SCR_WINDOW:
             break;
        case BT_SCR_CLIENTAREA:
             hDC = GetDC (hWnd);
             break;
   }

   switch (Mode)
   {    case BT_SCR_DESKTOP:
             rect.right  = GetSystemMetrics (SM_CXSCREEN);
             rect.bottom = GetSystemMetrics (SM_CYSCREEN);
             break;
        case BT_SCR_WINDOW:
             GetWindowRect(hWnd, &rect);
             rect.right  = rect.right  - rect.left;
             rect.bottom = rect.bottom - rect.top;
             break;
        case BT_SCR_CLIENTAREA:
             GetClientRect(hWnd, &rect);
             ReleaseDC (hWnd, hDC);
             break;
        default:
             rect.right  = 0;
             rect.bottom = 0;
             break;
   }

   if (info == BT_SCR_INFO_WIDTH)
      hb_retnl (rect.right);
   else
      hb_retnl (rect.bottom);
}


//*************************************************************************************************
// BT_SCR_INVALIDATERECT ( hWnd , [ {x_left, y_top, x_right, y_bottom} ] , lEraseBackground )
//*************************************************************************************************

HB_FUNC (BT_SCR_INVALIDATERECT)
{
   RECT rect;
   PHB_ITEM pArrayRect;

   if ( ! HB_ISARRAY (2) )
       hb_retl (InvalidateRect( (HWND) HMG_parnl (1), NULL, hb_parl (3) )); // Invalidate all client area
   else
   {
      pArrayRect = hb_param (2, HB_IT_ARRAY);

      if (hb_arrayLen (pArrayRect) == 4)
      {
         rect.left   = hb_arrayGetNL (pArrayRect, 1);
         rect.top    = hb_arrayGetNL (pArrayRect, 2);
         rect.right  = hb_arrayGetNL (pArrayRect, 3);
         rect.bottom = hb_arrayGetNL (pArrayRect, 4);
         hb_retl (InvalidateRect( (HWND) HMG_parnl (1), &rect, hb_parl (3) )); // Invalidate specific rectangle of client area
      }
      else
         hb_retl (FALSE);
   }
}





// ::::::::::::::::::::::::::::::::
// :::    DRAW hDC Functions    :::
// ::::::::::::::::::::::::::::::::





//***********************************************************************************************************************
//* BT_DRAWEDGE (hDC, nRow, nCol, nWidth, nHeight, nEdge, nGrfFlags)
//***********************************************************************************************************************

HB_FUNC ( BT_DRAWEDGE )
{
   HDC hDC = (HDC) HMG_parnl (1);

   RECT Rect;
   Rect.top    = hb_parni (2);
   Rect.left   = hb_parni (3);
   Rect.right  = hb_parni (4);
   Rect.bottom = hb_parni (5);

   INT Edge     = hb_parni (6);
   INT GrfFlags = hb_parni (7);

   DrawEdge (hDC, &Rect, Edge, GrfFlags);
}



//***********************************************************************************************************************
//* BT_DRAW_HDC_POLY ( hDC, aPointX, aPointY, ColorLine, nWidthLine, ColorFill, nPOLY )
//***********************************************************************************************************************

// nPOLY
#define BT_DRAW_POLYLINE      0
#define BT_DRAW_POLYGON       1
#define BT_DRAW_POLYBEZIER    2

HB_FUNC( BT_DRAW_HDC_POLY )
{
   HDC hDC;
   HPEN hPen;
   HBRUSH hBrush;
   INT nCountX, nCountY;
   COLORREF ColorLine, ColorFill;
   INT nWidthLine, nLen;
   INT nPOLY, i;
   #ifndef __MINGW_H
      POINT aPoint [2048];
   #endif

   hDC        = (HDC)      HMG_parnl (1);
   nCountX    = (INT)      hb_parinfa(2,0);
   nCountY    = (INT)      hb_parinfa(3,0);
   ColorLine  = (COLORREF) hb_parnl  (4);
   nWidthLine = (INT)      hb_parni  (5);
   ColorFill  = (COLORREF) hb_parnl  (6);
   nPOLY      = (INT)      hb_parni  (7);

   nLen = min( nCountX, nCountY );

   if ( nLen > 0 )
   {
      #ifdef __MINGW_H
         POINT aPoint[ nLen ];
      #endif
      for ( i=0; i < nLen; i++ )
      {  aPoint[ i ].x = hb_parvni ( 2, i + 1 );
         aPoint[ i ].y = hb_parvni ( 3, i + 1 );
      }
      SaveDC(hDC);
         hPen = CreatePen(PS_SOLID, nWidthLine, ColorLine);
         SelectObject(hDC, hPen);
         hBrush = CreateSolidBrush( ColorFill );
         SelectObject(hDC, hBrush);

         switch( nPOLY )
         {
            case BT_DRAW_POLYLINE:
               Polyline( hDC, aPoint, nLen );
               break;
            case BT_DRAW_POLYGON:
               Polygon( hDC, aPoint, nLen );
               break;
            case BT_DRAW_POLYBEZIER:
               PolyBezier( hDC, aPoint, nLen );
               break;
         }

      RestoreDC( hDC, -1 );
         DeleteObject( hBrush );
         DeleteObject( hPen );
      hb_retl( TRUE );
   }
   else
      hb_retl( FALSE );
}



//******************************************************************************************************************************
//* BT_DRAW_HDC_ARCX (hDC, x1, y1, x2, y2, XStartArc, YStartArc, XEndArc, YEndArc, ColorLine, nWidthLine, ColorFill, nArcType )
//******************************************************************************************************************************

// nArcType
#define BT_DRAW_ARC     0
#define BT_DRAW_CHORD   1
#define BT_DRAW_PIE     2

HB_FUNC (BT_DRAW_HDC_ARCX)
{
   HDC hDC;
   HPEN hPen;
   HBRUSH hBrush;
   COLORREF ColorLine, ColorFill;
   INT x1, y1, x2, y2, nWidthLine;
   INT XStartArc, YStartArc, XEndArc, YEndArc;
   INT nArcType;

   hDC        = (HDC) HMG_parnl (1);
   x1         = (INT) hb_parni (2);
   y1         = (INT) hb_parni (3);
   x2         = (INT) hb_parni (4);
   y2         = (INT) hb_parni (5);

   XStartArc  = (INT) hb_parni (6);
   YStartArc  = (INT) hb_parni (7);
   XEndArc    = (INT) hb_parni (8);
   YEndArc    = (INT) hb_parni (9);

   ColorLine  = (COLORREF) hb_parnl (10);
   nWidthLine = (INT)      hb_parni (11);
   ColorFill  = (COLORREF) hb_parnl (12);

   nArcType   = (INT)      hb_parni (13);

   SaveDC(hDC);
      hPen = CreatePen(PS_SOLID, nWidthLine, ColorLine);
      SelectObject(hDC, hPen);
      hBrush = CreateSolidBrush( ColorFill );
      SelectObject(hDC, hBrush);

         switch( nArcType )
         {
            case BT_DRAW_ARC:
               Arc (hDC, x1, y1, x2, y2, XStartArc, YStartArc, XEndArc, YEndArc);
               break;
            case BT_DRAW_CHORD:
               Chord (hDC, x1, y1, x2, y2, XStartArc, YStartArc, XEndArc, YEndArc);
               break;
            case BT_DRAW_PIE:
               Pie (hDC, x1, y1, x2, y2, XStartArc, YStartArc, XEndArc, YEndArc);
               break;
         }

   RestoreDC(hDC, -1);

      DeleteObject(hBrush);
      DeleteObject(hPen);
}



//**************************************************************************************************************************
//* BT_DRAW_HDC_FILLEDOBJECT (hDC, x1, y1, Width1, Height1, ColorFill, ColorLine, nWidthLine, Type, RoundWidth, RoundHeight)
//***************************************************************************************************************************

// Type
#define BT_FILLRECTANGLE  1
#define BT_FILLELLIPSE    2
#define BT_FILLROUNDRECT  3  // RoundWidth , RoundHeight
#define BT_FILLFLOOD      4


HB_FUNC (BT_DRAW_HDC_FILLEDOBJECT)
{
   HDC hDC;
   HPEN hPen;
   HBRUSH hBrush;
   COLORREF ColorLine, ColorFill;
   INT x1, y1, Width1, Height1;
   INT nWidthLine, Type, RoundWidth ,RoundHeight;

   hDC         = (HDC)      HMG_parnl (1);
   x1          = (INT)      hb_parni (2);
   y1          = (INT)      hb_parni (3);
   Width1      = (INT)      hb_parni (4);
   Height1     = (INT)      hb_parni (5);
   ColorFill   = (COLORREF) hb_parnl (6);
   ColorLine   = (COLORREF) hb_parnl (7);
   nWidthLine  = (INT)      hb_parni (8);
   Type        = (INT)      hb_parni (9);
   RoundWidth  = (INT)      hb_parni (10);
   RoundHeight = (INT)      hb_parni (11);

   SaveDC(hDC);
     hPen = CreatePen(PS_SOLID, nWidthLine, ColorLine);
     SelectObject(hDC, hPen);
     hBrush = CreateSolidBrush(ColorFill);
     SelectObject(hDC, hBrush);

     switch (Type)
     {    case BT_FILLRECTANGLE:
               Rectangle (hDC, x1, y1, x1+Width1, y1+Height1);
               break;
          case BT_FILLELLIPSE:
               Ellipse  (hDC, x1, y1, x1+Width1, y1+Height1);
               break;
          case BT_FILLROUNDRECT:
               RoundRect (hDC, x1, y1, x1+Width1, y1+Height1, RoundWidth, RoundHeight);
               break;
          case BT_FILLFLOOD:
               ExtFloodFill ( hDC, x1, y1, GetPixel(hDC,x1,y1), FLOODFILLSURFACE );
               break;
     }

   RestoreDC(hDC, -1);

     DeleteObject(hBrush);
     DeleteObject(hPen);
}



//*****************************************************************************************************************************
//* BT_DRAW_HDC_BITMAP (hDC1, x1, y1, Width1, Height1, hBitmap, x2, y2, Width2, Height2, Mode_Stretch, Action, Color_Transp)
//*****************************************************************************************************************************

// Action
#define BT_BITMAP_OPAQUE        0
#define BT_BITMAP_TRANSPARENT   1

HB_FUNC (BT_DRAW_HDC_BITMAP)
{
   HDC hDC, memDC;
   HBITMAP hBitmap;
   INT x1, y1, Width1, Height1, x2, y2, Width2, Height2;
   INT Mode_Stretch, Action;
   COLORREF color_transp;
   POINT Point;

   hDC           = (HDC)      HMG_parnl (1);
   x1            = (INT)      hb_parni (2);
   y1            = (INT)      hb_parni (3);
   Width1        = (INT)      hb_parni (4);
   Height1       = (INT)      hb_parni (5);

   hBitmap       = (HBITMAP)  HMG_parnl (6);
   x2            = (INT)      hb_parni (7);
   y2            = (INT)      hb_parni (8);
   Width2        = (INT)      hb_parni (9);
   Height2       = (INT)      hb_parni (10);

   Mode_Stretch  = (INT)      hb_parni (11);
   Action        = (INT)      hb_parni (12);
   color_transp  = (COLORREF) hb_parnl (13);


   memDC = CreateCompatibleDC(NULL);
   SelectObject(memDC, hBitmap);

   bt_bmp_adjust_rect (&Width1, &Height1, &Width2, &Height2, Mode_Stretch);

   //SetStretchBltMode (hDC, COLORONCOLOR);
   GetBrushOrgEx (hDC, &Point);
   SetStretchBltMode (hDC, HALFTONE);
   SetBrushOrgEx (hDC, Point.x, Point.y, NULL);

   switch (Action)
   {    case BT_BITMAP_OPAQUE:
             StretchBlt     (hDC, x1, y1, Width1, Height1, memDC, x2, y2, Width2, Height2, SRCCOPY);
             break;
        case BT_BITMAP_TRANSPARENT:
             TransparentBlt (hDC, x1, y1, Width1, Height1, memDC, x2, y2, Width2, Height2, color_transp);
             break;
        default:
             hb_retl (FALSE);
             return;
   }

   DeleteDC(memDC);
   hb_retl (TRUE);
}



//**********************************************************************************************************************
//* BT_DRAW_HDC_BITMAPALPHABLEND (hDC, x1, y1, Width1, Height1, hBitmap, x2, y2, Width2, Height2, Alpha, Mode_Stretch)
//**********************************************************************************************************************

// Alpha = 0 to 255
#define BT_ALPHABLEND_TRANSPARENT   0
#define BT_ALPHABLEND_OPAQUE      255

HB_FUNC (BT_DRAW_HDC_BITMAPALPHABLEND)
{
   HBITMAP hBitmap;
   HDC hDC, memDC;
   INT x1, y1, Width1, Height1, x2, y2, Width2, Height2, Mode_Stretch;
   BLENDFUNCTION blend;
   BYTE Alpha;
   POINT Point;

   hDC        = (HDC)  HMG_parnl (1);
   x1         = (INT)  hb_parni (2);
   y1         = (INT)  hb_parni (3);
   Width1     = (INT)  hb_parni (4);
   Height1    = (INT)  hb_parni (5);

   hBitmap    = (HBITMAP) HMG_parnl (6);
   x2         = (INT) hb_parni (7);
   y2         = (INT) hb_parni (8);
   Width2     = (INT) hb_parni (9);
   Height2    = (INT) hb_parni (10);

   Alpha         = (BYTE) hb_parni (11);
   Mode_Stretch  = (INT)  hb_parni (12);


   blend.BlendOp = AC_SRC_OVER;
   blend.BlendFlags = 0;
   blend.AlphaFormat = 0;
   blend.SourceConstantAlpha = Alpha;


   memDC = CreateCompatibleDC(NULL);
   SelectObject(memDC, hBitmap);

   bt_bmp_adjust_rect (&Width1, &Height1, &Width2, &Height2, Mode_Stretch);

   //SetStretchBltMode (hDC, COLORONCOLOR);
   GetBrushOrgEx (hDC, &Point);
   SetStretchBltMode (hDC, HALFTONE);
   SetBrushOrgEx (hDC, Point.x, Point.y, NULL);

   AlphaBlend (hDC, x1, y1, Width1, Height1, memDC, x2, y2, Width2, Height2, blend);

   DeleteDC(memDC);
}



//****************************************************************************************************
// BT_DRAW_HDC_GRADIENTFILL (hDC, x1, y1, Width1, Height1, Color_RGB_O, Color_RGB_D, Mode)
//****************************************************************************************************

// Mode
#define BT_GRADIENTFILL_HORIZONTAL 0
#define BT_GRADIENTFILL_VERTICAL   1

HB_FUNC (BT_DRAW_HDC_GRADIENTFILL)
{
   HDC  hDC;
   TRIVERTEX      Vert [2];
   GRADIENT_RECT  gRect;
   COLORREF  Color_RGB_O, Color_RGB_D;
   ULONG Mode;

   hDC = (HDC) HMG_parnl (1);

   Color_RGB_O = (COLORREF) hb_parnl (6);
   Color_RGB_D = (COLORREF) hb_parnl (7);
   Mode        = (ULONG)    hb_parnl (8);

   Vert [0] .x      = hb_parnl (2);
   Vert [0] .y      = hb_parnl (3);
   Vert [0] .Red    = (USHORT) GetRValue(Color_RGB_O) << 8;
   Vert [0] .Green  = (USHORT) GetGValue(Color_RGB_O) << 8;
   Vert [0] .Blue   = (USHORT) GetBValue(Color_RGB_O) << 8;
   Vert [0] .Alpha  = 0x0000;

   Vert [1] .x      = hb_parnl (2) + hb_parnl (4);
   Vert [1] .y      = hb_parnl (3) + hb_parnl (5);
   Vert [1] .Red    = (USHORT) GetRValue(Color_RGB_D) << 8;
   Vert [1] .Green  = (USHORT) GetGValue(Color_RGB_D) << 8;
   Vert [1] .Blue   = (USHORT) GetBValue(Color_RGB_D) << 8;
   Vert [1] .Alpha  = 0x0000;

   gRect.UpperLeft  = 0;
   gRect.LowerRight = 1;
   GradientFill (hDC, Vert, 2, &gRect, 1, Mode);
}



//*******************************************************************************************************
//* BT_DRAW_HDC_TEXTOUT (hDC, x, y, Text, FontName, FontSize, Text_Color, Back_color, Type, Align, Action)
//*******************************************************************************************************

// Type
#define BT_TEXT_OPAQUE      0
#define BT_TEXT_TRANSPARENT 1

#define BT_TEXT_BOLD        2
#define BT_TEXT_ITALIC      4
#define BT_TEXT_UNDERLINE   8
#define BT_TEXT_STRIKEOUT   16


// Align
#define BT_TEXT_LEFT        0
#define BT_TEXT_CENTER      6
#define BT_TEXT_RIGHT       2

#define BT_TEXT_TOP         0
#define BT_TEXT_BASELINE   24
#define BT_TEXT_BOTTOM      8


HB_FUNC (BT_DRAW_HDC_TEXTOUT)
{
   HDC  hDC;
   HFONT hFont;
   TCHAR *Text, *FontName;
   INT FontSize;
   INT x, y;
   COLORREF Text_Color, Back_Color;
   INT Type, Align;
   double Orientation;

   INT Bold = FW_NORMAL;
   INT Italic = 0, Underline = 0, StrikeOut = 0;


   hDC         = (HDC)      HMG_parnl (1);
   x           = (INT)      hb_parni  (2);
   y           = (INT)      hb_parni  (3);
   Text        = (TCHAR *)  HMG_parc  (4);
   FontName    = (TCHAR *)  HMG_parc  (5);
   FontSize    = (INT)      hb_parni  (6);
   Text_Color  = (COLORREF) hb_parnl  (7);
   Back_Color  = (COLORREF) hb_parnl  (8);
   Type        = (INT)      hb_parni  (9);
   Align       = (INT)      hb_parni (10);
   Orientation = (double)   hb_parnd (11);

   SaveDC( hDC );

   if ((Orientation < (double) -360.0) || (Orientation > (double) 360.0))
       Orientation = (double) 0.0;

   Orientation = Orientation * (double) 10.0;   // Angle in tenths of degrees

   if ((Type & BT_TEXT_TRANSPARENT) == BT_TEXT_TRANSPARENT)
       SetBkMode(hDC, TRANSPARENT);
   else
   {   SetBkMode(hDC, OPAQUE);
       SetBkColor(hDC, Back_Color);
   }

   if ((Type & BT_TEXT_BOLD) == BT_TEXT_BOLD)
       Bold = FW_BOLD;

   if ((Type & BT_TEXT_ITALIC) == BT_TEXT_ITALIC)
       Italic = 1;

   if ((Type & BT_TEXT_UNDERLINE) == BT_TEXT_UNDERLINE)
       Underline = 1;

   if ((Type & BT_TEXT_STRIKEOUT) == BT_TEXT_STRIKEOUT)
       StrikeOut = 1;

   SetGraphicsMode (hDC, GM_ADVANCED);

   FontSize = FontSize * GetDeviceCaps (hDC, LOGPIXELSY) / 72;

        // CreateFont (Height, Width, Escapement, Orientation, Weight, Italic, Underline, StrikeOut,
        //             CharSet, OutputPrecision, ClipPrecision, Quality, PitchAndFamily, Face);
   hFont = CreateFont (0-FontSize, 0, (int)Orientation, (int)Orientation, Bold, Italic, Underline, StrikeOut,
           DEFAULT_CHARSET, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_DONTCARE, FontName);

   SelectObject (hDC, hFont);

   SetTextAlign (hDC, Align);
   SetTextColor (hDC, Text_Color);

   TextOut(hDC, x, y, Text, lstrlen(Text));

/*
   When GetTextExtentPoint32() returns the text extent, it assumes that the text is HORIZONTAL,
   that is, that the ESCAPEMENT is always 0. This is true for both the horizontal and
   vertical measurements of the text. Even if you use a font that specifies a nonzero
   escapement, this function doesn't use the angle while it computes the text extent.
   The app must convert it explicitly.

   SIZE SizeText;
   GetTextExtentPoint32 (hDC, Text, lstrlen(Text), &SizeText);
   hb_reta (2);
   hb_storvnl ((LONG) SizeText.cx, -1, 1);
   hb_storvnl ((LONG) SizeText.cy, -1, 2);
*/

   RestoreDC( hDC, -1 );

   DeleteObject (hFont);
}



//****************************************************************************************************************
//* BT_DRAW_HDC_DRAWTEXT (hDC, x, y, w, h, Text, FontName, FontSize, Text_Color, Back_color, Type, Align, Action)
//****************************************************************************************************************

/*
// Type
#define BT_TEXT_OPAQUE      0
#define BT_TEXT_TRANSPARENT 1

#define BT_TEXT_BOLD        2
#define BT_TEXT_ITALIC      4
#define BT_TEXT_UNDERLINE   8
#define BT_TEXT_STRIKEOUT   16


// Align
#define BT_TEXT_LEFT        0
#define BT_TEXT_CENTER      6
#define BT_TEXT_RIGHT       2

#define BT_TEXT_TOP         0
#define BT_TEXT_BASELINE   24
#define BT_TEXT_BOTTOM      8
*/

HB_FUNC (BT_DRAW_HDC_DRAWTEXT)
{
   HDC  hDC;
   HFONT hFont;
   TCHAR *Text, *FontName;
   INT FontSize;
   INT x, y, w, h;
   COLORREF Text_Color, Back_Color;
   INT Type, Align;
   double Orientation;

   INT Bold = FW_NORMAL;
   INT Italic = 0, Underline = 0, StrikeOut = 0;


   hDC         = (HDC)      HMG_parnl (1);
   x           = (INT)      hb_parni  (2);
   y           = (INT)      hb_parni  (3);
   w           = (INT)      hb_parni  (4);
   h           = (INT)      hb_parni  (5);
   Text        = (TCHAR *)  HMG_parc  (6);
   FontName    = (TCHAR *)  HMG_parc  (7);
   FontSize    = (INT)      hb_parni  (8);
   Text_Color  = (COLORREF) hb_parnl  (9);
   Back_Color  = (COLORREF) hb_parnl (10);
   Type        = (INT)      hb_parni (11);
   Align       = (INT)      hb_parni (12);
   Orientation = (double)   hb_parnd (13);

   SaveDC( hDC );

   if ((Orientation < (double) -360.0) || (Orientation > (double) 360.0))
       Orientation = (double) 0.0;

   Orientation = Orientation * (double) 10.0;   // Angle in tenths of degrees

   if ((Type & BT_TEXT_TRANSPARENT) == BT_TEXT_TRANSPARENT)
       SetBkMode(hDC, TRANSPARENT);
   else
   {   SetBkMode(hDC, OPAQUE);
       SetBkColor(hDC, Back_Color);
   }

   if ((Type & BT_TEXT_BOLD) == BT_TEXT_BOLD)
       Bold = FW_BOLD;

   if ((Type & BT_TEXT_ITALIC) == BT_TEXT_ITALIC)
       Italic = 1;

   if ((Type & BT_TEXT_UNDERLINE) == BT_TEXT_UNDERLINE)
       Underline = 1;

   if ((Type & BT_TEXT_STRIKEOUT) == BT_TEXT_STRIKEOUT)
       StrikeOut = 1;

   SetGraphicsMode (hDC, GM_ADVANCED);

   FontSize = FontSize * GetDeviceCaps (hDC, LOGPIXELSY) / 72;

        // CreateFont (Height, Width, Escapement, Orientation, Weight, Italic, Underline, StrikeOut,
        //             CharSet, OutputPrecision, ClipPrecision, Quality, PitchAndFamily, Face);
   hFont = CreateFont (0-FontSize, 0, (int)Orientation, (int)Orientation, Bold, Italic, Underline, StrikeOut,
           DEFAULT_CHARSET, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_DONTCARE, FontName);

   SelectObject (hDC, hFont);

   SetTextColor (hDC, Text_Color);

   RECT rect;
   SetRect (&rect, x, y, x+w, y+h);

   DrawText (hDC, Text, -1, &rect, DT_NOCLIP | DT_WORDBREAK | /*DT_EXTERNALLEADING |*/ DT_NOPREFIX | Align);

   RestoreDC (hDC, -1);

   DeleteObject (hFont);
}



//*******************************************************************************************************
//* BT_DRAW_HDC_TEXTSIZE (hDC, Text, FontName, FontSize, Type)
//*******************************************************************************************************

/*
// Type
#define BT_TEXT_BOLD        2
#define BT_TEXT_ITALIC      4
#define BT_TEXT_UNDERLINE   8
#define BT_TEXT_STRIKEOUT   16
*/

HB_FUNC (BT_DRAW_HDC_TEXTSIZE)
{
   HDC  hDC;
   HFONT hFont;
   TCHAR *Text, *FontName;
   INT FontSize;
   INT Type;
   INT Orientation = 0;

   INT Bold = FW_NORMAL;
   INT Italic = 0, Underline = 0, StrikeOut = 0;

   hDC         = (HDC)      HMG_parnl (1);
   Text        = (TCHAR *)  HMG_parc  (2);
   FontName    = (TCHAR *)  HMG_parc  (3);
   FontSize    = (INT)      hb_parni  (4);
   Type        = (INT)      hb_parni  (5);

   SaveDC( hDC );

   if ((Type & BT_TEXT_BOLD) == BT_TEXT_BOLD)
       Bold = FW_BOLD;

   if ((Type & BT_TEXT_ITALIC) == BT_TEXT_ITALIC)
       Italic = 1;

   if ((Type & BT_TEXT_UNDERLINE) == BT_TEXT_UNDERLINE)
       Underline = 1;

   if ((Type & BT_TEXT_STRIKEOUT) == BT_TEXT_STRIKEOUT)
       StrikeOut = 1;

   SetGraphicsMode (hDC, GM_ADVANCED);

   FontSize = FontSize * GetDeviceCaps (hDC, LOGPIXELSY) / 72;

        // CreateFont (Height, Width, Escapement, Orientation, Weight, Italic, Underline, StrikeOut,
        //             CharSet, OutputPrecision, ClipPrecision, Quality, PitchAndFamily, Face);
   hFont = CreateFont (0-FontSize, 0, Orientation, Orientation, Bold, Italic, Underline, StrikeOut,
           DEFAULT_CHARSET, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_DONTCARE, FontName);

   SelectObject (hDC, hFont);

   SIZE SizeText;
   GetTextExtentPoint32 (hDC, Text, lstrlen(Text), &SizeText);
   hb_reta (6);
   hb_storvnl ((LONG) SizeText.cx, -1, 1);
   hb_storvnl ((LONG) SizeText.cy, -1, 2);

   UINT iFirstChar, iLastChar;
   ABCFLOAT ABCfloat;
   iFirstChar = (UINT) Text [0];
   iLastChar  = (UINT) Text [0];
   GetCharABCWidthsFloat (hDC, iFirstChar, iLastChar, &ABCfloat);
   hb_storvnd ((double) (FLOAT)(ABCfloat.abcfA + ABCfloat.abcfB + ABCfloat.abcfC), -1 , 3);
   hb_storvnd ((double) (FLOAT) ABCfloat.abcfA, -1 , 4);
   hb_storvnd ((double) (FLOAT) ABCfloat.abcfB, -1 , 5);
   hb_storvnd ((double) (FLOAT) ABCfloat.abcfC, -1 , 6);

   RestoreDC( hDC, -1 );

   DeleteObject (hFont);
}



//*****************************************************************************************************************************
//* BT_DRAW_HDC_PIXEL (hDC, x, y, Action, Color)
//*****************************************************************************************************************************

// Action
#define BT_HDC_GETPIXEL   0
#define BT_HDC_SETPIXEL   1

HB_FUNC (BT_DRAW_HDC_PIXEL)
{
   HDC hDC;
   INT x, y;
   INT Action;
   COLORREF Color;

   hDC     = (HDC)      HMG_parnl (1);
   x       = (INT)      hb_parni (2);
   y       = (INT)      hb_parni (3);
   Action  = (INT)      hb_parni (4);
   Color   = (COLORREF) hb_parnl (5);

   switch (Action)
   {    case BT_HDC_GETPIXEL:
             Color = GetPixel (hDC, x, y);
             break;
        case BT_HDC_SETPIXEL:
             Color = SetPixel (hDC, x, y, Color);
             break;
   }

   hb_reta (3);
   hb_storvni   ((INT) GetRValue(Color), -1, 1);
   hb_storvni   ((INT) GetGValue(Color), -1, 2);
   hb_storvni   ((INT) GetBValue(Color), -1, 3);
}





//*****************************************************************************************************************************
//* BT_DRAW_HDC_TO_HDC (hDC1, x1, y1, Width1, Height1, hDC2, x2, y2, Width2, Height2, Mode_Stretch, Action, Color_Transp)
//*****************************************************************************************************************************

// Action
#define BT_HDC_OPAQUE        0
#define BT_HDC_TRANSPARENT   1

HB_FUNC (BT_DRAW_HDC_TO_HDC)
{
   HDC hDC1, hDC2;
   INT x1, y1, Width1, Height1, x2, y2, Width2, Height2;
   INT Mode_Stretch, Action;
   COLORREF color_transp;
   POINT Point;

   hDC1          = (HDC)      HMG_parnl (1);
   x1            = (INT)      hb_parni (2);
   y1            = (INT)      hb_parni (3);
   Width1        = (INT)      hb_parni (4);
   Height1       = (INT)      hb_parni (5);

   hDC2          = (HDC)      HMG_parnl (6);
   x2            = (INT)      hb_parni (7);
   y2            = (INT)      hb_parni (8);
   Width2        = (INT)      hb_parni (9);
   Height2       = (INT)      hb_parni (10);

   Mode_Stretch  = (INT)      hb_parni (11);
   Action        = (INT)      hb_parni (12);
   color_transp  = (COLORREF) hb_parnl (13);


   bt_bmp_adjust_rect (&Width1, &Height1, &Width2, &Height2, Mode_Stretch);

   //SetStretchBltMode (hDC1, COLORONCOLOR);
   GetBrushOrgEx (hDC1, &Point);
   SetStretchBltMode (hDC1, HALFTONE);
   SetBrushOrgEx (hDC1, Point.x, Point.y, NULL);


   switch (Action)
   {    case BT_HDC_OPAQUE:
             StretchBlt     (hDC1, x1, y1, Width1, Height1, hDC2, x2, y2, Width2, Height2, SRCCOPY);
             break;
        case BT_HDC_TRANSPARENT:
             TransparentBlt (hDC1, x1, y1, Width1, Height1, hDC2, x2, y2, Width2, Height2, color_transp);
             break;
        default:
             hb_retl (FALSE);
             return;
   }

   hb_retl (TRUE);
}



//**********************************************************************************************************************
//* BT_DRAW_HDC_TO_HDC_ALPHABLEND (hDC1, x1, y1, Width1, Height1, hDC2, x2, y2, Width2, Height2, Alpha, Mode_Stretch)
//**********************************************************************************************************************

// Alpha = 0 to 255
#define BT_ALPHABLEND_TRANSPARENT   0
#define BT_ALPHABLEND_OPAQUE      255

HB_FUNC (BT_DRAW_HDC_TO_HDC_ALPHABLEND)
{
   HDC hDC1, hDC2;
   INT x1, y1, Width1, Height1, x2, y2, Width2, Height2, Mode_Stretch;
   BLENDFUNCTION blend;
   BYTE Alpha;
   POINT Point;

   hDC1       = (HDC)  HMG_parnl (1);
   x1         = (INT)  hb_parni (2);
   y1         = (INT)  hb_parni (3);
   Width1     = (INT)  hb_parni (4);
   Height1    = (INT)  hb_parni (5);

   hDC2       = (HDC)  HMG_parnl (6);
   x2         = (INT)  hb_parni (7);
   y2         = (INT)  hb_parni (8);
   Width2     = (INT)  hb_parni (9);
   Height2    = (INT)  hb_parni (10);

   Alpha         = (BYTE) hb_parni (11);
   Mode_Stretch  = (INT)  hb_parni (12);

   blend.BlendOp = AC_SRC_OVER;
   blend.BlendFlags = 0;
   blend.AlphaFormat = 0;
   blend.SourceConstantAlpha = Alpha;

   bt_bmp_adjust_rect (&Width1, &Height1, &Width2, &Height2, Mode_Stretch);

   //SetStretchBltMode (hDC1, COLORONCOLOR);
   GetBrushOrgEx (hDC1, &Point);
   SetStretchBltMode (hDC1, HALFTONE);
   SetBrushOrgEx (hDC1, Point.x, Point.y, NULL);

   AlphaBlend (hDC1, x1, y1, Width1, Height1, hDC2, x2, y2, Width2, Height2, blend);

}





// ::::::::::::::::::::::::::::::::
// :::     BITMAP Functions     :::
// ::::::::::::::::::::::::::::::::





//**************************************************************************************************
//* BT_BMP_CREATE (Width, Height, Color_Fill_Bk) ---> Return hBITMAP
//**************************************************************************************************

HB_FUNC (BT_BMP_CREATE)
{
   HBITMAP hBitmap_New;
   INT Width, Height;
   COLORREF Color_Fill_Bk;
   HDC memDC;
   RECT Rect;
   HBRUSH hBrush;
   BITMAP bm;

   Width  =        (INT)      hb_parni (1);
   Height =        (INT)      hb_parni (2);
   Color_Fill_Bk = (COLORREF) hb_parnl (3);

   hBitmap_New = bt_bmp_create_24bpp (Width, Height);

   memDC = CreateCompatibleDC(NULL);
   SelectObject(memDC, hBitmap_New);

   GetObject(hBitmap_New, sizeof(BITMAP), (LPBYTE)&bm);
   SetRect (&Rect, 0, 0, bm.bmWidth, bm.bmHeight);

   hBrush = CreateSolidBrush(Color_Fill_Bk);
   FillRect(memDC, &Rect, hBrush);

   DeleteDC(memDC);
   DeleteObject(hBrush);

   HMG_retnl ((LONG_PTR) hBitmap_New);
}



//*************************************************************************************************
//* BT_BMP_RELEASE (hBitmap) ---> Return Success (TRUE or FALSE)
//*************************************************************************************************

HB_FUNC (BT_BMP_RELEASE)
{
   HBITMAP hBitmap = (HBITMAP) HMG_parnl(1);
   hb_retl (DeleteObject (hBitmap));
}



//*************************************************************************************************
//* BT_BMP_LOADFILE (cFileBMP) ---> Return hBITMAP
//*************************************************************************************************

HB_FUNC (BT_BMP_LOADFILE)
{
    HBITMAP hBitmap;
    TCHAR *FileName;

    FileName = (TCHAR *) HMG_parc (1);

  // First find BMP image in resourses (.EXE file)
     hBitmap = (HBITMAP) LoadImage (GetModuleHandle(NULL), FileName, IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION);

  // If fail: find BMP in disk
     if (hBitmap == NULL)
         hBitmap = (HBITMAP) LoadImage (NULL, FileName, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_CREATEDIBSECTION);

  // If fail: find JPG Image in resourses
     if (hBitmap == NULL)
         hBitmap = bt_LoadOLEPicture (FileName, _TEXT("JPG"));

  // If fail: find GIF Image in resourses
     if (hBitmap == NULL)
         hBitmap = bt_LoadOLEPicture (FileName, _TEXT("GIF"));

  // If fail: find PNG Image in resourses
     if (hBitmap == NULL)
         hBitmap = bt_LoadGDIPlusPicture (FileName, _TEXT("PNG"));

  // If fail: find TIF Image in resourses
     if (hBitmap == NULL)
         hBitmap = bt_LoadGDIPlusPicture (FileName, _TEXT("TIF"));

  // If fail: find JPG and GIF Image in disk
     if (hBitmap == NULL)
         hBitmap = bt_LoadOLEPicture (FileName, NULL);

  // If fail: find PNG and TIF Image in disk
     if (hBitmap == NULL)
         hBitmap = bt_LoadGDIPlusPicture (FileName, NULL);

  // If fail load: return zero
     if (hBitmap == NULL)
     {  hb_retnl (0);
        return;
     }

//   if (bt_bmp_is_24bpp (hBitmap) == FALSE)
//       hBitmapFile = bt_bmp_convert_to_24bpp (hBitmap, BMP_DELETE_ORIGINAL_HBITMAP);   // Convert Bitmap in 24bpp

      HMG_retnl ((LONG_PTR) hBitmap);
}


//*********************************************************************************************************************************
//* BT_BitmapLoadEMF ( cFileName, [ aRGBBackgroundColor ], [ nNewWidth ], [ nNewHeight ], [ ModeStretch ] )  ---> Return hBITMAP
//*********************************************************************************************************************************

HB_FUNC (BT_BITMAPLOADEMF)
{
   TCHAR    *FileName       = (TCHAR*)   HMG_parc (1);
   COLORREF BackgroundColor = (COLORREF) RGB ( hb_parvnl(2,1), hb_parvnl(2,2), hb_parvnl(2,3) );
   INT      ModeStretch     = ( HB_ISNUM(5) ? (INT)hb_parnl(5) : BT_SCALE );

   HDC           memDC   = NULL;
   HBITMAP       hBitmap = NULL;
   HENHMETAFILE  hEMF    = NULL;
   ENHMETAHEADER emh;
   HRSRC         hResourceData;
   HGLOBAL       hGlobalResource;
   LPVOID        lpGlobalResource;
   DWORD         nFileSize;
   POINT         Point;
   RECT          Rect;
   INT           nWidth, nHeight;

   // Load MetaFile from Resource
   hResourceData = FindResource (NULL, FileName, _TEXT("EMF"));
   if ( hResourceData )
   {   hGlobalResource = LoadResource (NULL, hResourceData);
       if ( hGlobalResource )
       {    lpGlobalResource = LockResource (hGlobalResource);
            nFileSize = SizeofResource (NULL, hResourceData);
            hEMF = SetEnhMetaFileBits (nFileSize, lpGlobalResource);
       }
   }

   // If fail load MetaFile from Disk
   if (hEMF == NULL)
       hEMF = GetEnhMetaFile (FileName);

   // If fail load from Resource and Disk return Null
   if (hEMF == NULL)
   {  HMG_retnl ((LONG_PTR) NULL);
      return;
   }

   // Get the header of MetaFile
   ZeroMemory (&emh, sizeof(ENHMETAHEADER));
   emh.nSize = sizeof(ENHMETAHEADER);
   if ( GetEnhMetaFileHeader(hEMF, sizeof(ENHMETAHEADER), &emh) == 0 )
   {
      DeleteEnhMetaFile (hEMF);
      HMG_retnl ((LONG_PTR) NULL);
      return;
   }

   nWidth  = HB_ISNUM(3) ? (INT)hb_parnl(3) : (INT) emh.rclBounds.right;   // The dimensions: in device units
   nHeight = HB_ISNUM(4) ? (INT)hb_parnl(4) : (INT) emh.rclBounds.bottom;  // The dimensions: in device units

   if (ModeStretch == BT_SCALE)
        bt_bmp_adjust_rect (&nWidth, &nHeight, (int*)&emh.rclBounds.right, (int*)&emh.rclBounds.bottom, BT_SCALE);

   Rect.left   = 0;
   Rect.top    = 0;
   Rect.right  = nWidth;
   Rect.bottom = nHeight;

   // Create Bitmap
   memDC   = CreateCompatibleDC (NULL);
   hBitmap = bt_bmp_create_24bpp (nWidth, nHeight);
   SelectObject (memDC, hBitmap);

   // Paint the background of the Bitmap
   HBRUSH hBrush = CreateSolidBrush (BackgroundColor);
   FillRect(memDC, &Rect, hBrush);

   GetBrushOrgEx (memDC, &Point);
   SetStretchBltMode (memDC, HALFTONE);
   SetBrushOrgEx (memDC, Point.x, Point.y, NULL);

   // Play MetaFile into Bitmap
   PlayEnhMetaFile (memDC, hEMF, &Rect);

   // Release handles
   DeleteEnhMetaFile (hEMF);
   DeleteDC  (memDC);
   DeleteObject(hBrush);

   HMG_retnl ((LONG_PTR) hBitmap);
}


//*********************************************************************************************************************************
//* BT_DrawEMF ( [ hDC ] , cFileNameOld , cFileNameNew , cFuncNameCallBack )  ---> Return nError, e.g. Zero is OK
//*********************************************************************************************************************************

/*
FUNCTION ProcDrawEMFCallBack( hDC, leftMM, topMM, rightMM, bottomMM, leftPx, topPx, rightPx, bottomPx, IsParamHDC )   // rectangle that bounded the area to draw, in milimeters and pixels
LOCAL Old_PageDC := OpenPrinterGetPageDC()

   OpenPrinterGetPageDC() := hDC
   @ 180, 100 PRINT " Page Number: " + hb_NtoS( nPageNumber++ ) + " of " + hb_NtoS( _HMG_SYSDATA [ 380 ] ) FONT "Arial" SIZE 12
   OpenPrinterGetPageDC() := Old_PageDC

   // MsgDebug( hDC, leftMM, topMM, rightMM, bottomMM, leftPx, topPx, rightPx, bottomPx, IsParamHDC )
RETURN NIL
*/


HB_FUNC (BT_DRAWEMF)
{
   HDC   hDC                = (HDC)    HMG_parnl (1);
   TCHAR *cFileNameOld      = (TCHAR*) HMG_parc  (2);
   TCHAR *cFileNameNew      = (TCHAR*) HMG_parc  (3);
   CHAR  *cFuncNameCallBack = (CHAR* ) hb_parc   (4);

   BOOL IsParamHDC = ( hDC ? TRUE : FALSE );

   HDC           hDC_EMF  = NULL;
   HENHMETAFILE  hEMF_Old = NULL;
   HENHMETAFILE  hEMF_New = NULL;

   ENHMETAHEADER emh;
   HRSRC         hResourceData;
   HGLOBAL       hGlobalResource;
   LPVOID        lpGlobalResource;
   DWORD         nFileSize;


   PHB_DYNS pDynSym = hb_dynsymFindName( cFuncNameCallBack );
   if( pDynSym == NULL )
   {  hb_retni (1);
      return;
   }

   // Load MetaFile from Resource
   hResourceData = FindResource (NULL, cFileNameOld, _TEXT("EMF"));
   if ( hResourceData )
   {   hGlobalResource = LoadResource (NULL, hResourceData);
       if ( hGlobalResource )
       {    lpGlobalResource = LockResource (hGlobalResource);
            nFileSize = SizeofResource (NULL, hResourceData);
            hEMF_Old = SetEnhMetaFileBits (nFileSize, lpGlobalResource);
       }
   }

   // If fail, load MetaFile from Disk
   if (hEMF_Old == NULL)
       hEMF_Old = GetEnhMetaFile (cFileNameOld);

   // If fail load from Resource and Disk return False
   if (hEMF_Old == NULL)
   {  hb_retni (2);
      return;
   }

   // Get the header of MetaFile
   ZeroMemory (&emh, sizeof(ENHMETAHEADER));
   emh.nSize = sizeof(ENHMETAHEADER);
   if ( GetEnhMetaFileHeader(hEMF_Old, sizeof(ENHMETAHEADER), &emh) == 0 )
   {  DeleteEnhMetaFile (hEMF_Old);
      hb_retni (3);
      return;
   }

   if( IsParamHDC )
      hDC_EMF = CreateEnhMetaFile( hDC, cFileNameNew, (RECT *)&emh.rclFrame, _TEXT("") );
   else
   {
      hDC = GetDC( NULL );
      INT iWidthMM  = GetDeviceCaps( hDC, HORZSIZE );
      INT iHeightMM = GetDeviceCaps( hDC, VERTSIZE );
      INT iWidthPx  = GetDeviceCaps( hDC, HORZRES  );
      INT iHeightPx = GetDeviceCaps( hDC, VERTRES  );
      hDC_EMF = CreateEnhMetaFile( hDC, cFileNameNew, (RECT *)&emh.rclFrame, _TEXT("") );

      if (hDC_EMF == NULL)
         ReleaseDC (NULL, hDC);

      emh.rclBounds.left   = (emh.rclFrame.left   / 100) * iWidthPx  / iWidthMM;
      emh.rclBounds.top    = (emh.rclFrame.top    / 100) * iHeightPx / iHeightMM;
      emh.rclBounds.right  = (emh.rclFrame.right  / 100) * iWidthPx  / iWidthMM;
      emh.rclBounds.bottom = (emh.rclFrame.bottom / 100) * iHeightPx / iHeightMM;
   }

   if (hDC_EMF == NULL)
   {  DeleteEnhMetaFile (hEMF_Old);
      hb_retni (4);
      return;
   }

   // Play Old MetaFile into New MetaFile
   PlayEnhMetaFile (hDC_EMF, hEMF_Old, (RECT *)&emh.rclBounds);

   hb_vmPushSymbol (hb_dynsymSymbol ( pDynSym ));
   hb_vmPushNil ();                                       // places NIL at Self
   hb_vmPushNumInt ((LONG_PTR) hDC_EMF );
   hb_vmPushLong   ((LONG) emh.rclFrame.left   / 100 );   // push values in milimeters
   hb_vmPushLong   ((LONG) emh.rclFrame.top    / 100 );
   hb_vmPushLong   ((LONG) emh.rclFrame.right  / 100 );
   hb_vmPushLong   ((LONG) emh.rclFrame.bottom / 100 );
   hb_vmPushLong   ((LONG) emh.rclBounds.left   );        // push values in pixels
   hb_vmPushLong   ((LONG) emh.rclBounds.top    );
   hb_vmPushLong   ((LONG) emh.rclBounds.right  );
   hb_vmPushLong   ((LONG) emh.rclBounds.bottom );
   hb_vmPushLogical((BOOL) IsParamHDC );
   hb_vmDo ( 1+4+4+1 );

   // Release hDC
   hEMF_New = CloseEnhMetaFile (hDC_EMF);

   // Release handles
   DeleteEnhMetaFile (hEMF_Old);
   DeleteEnhMetaFile (hEMF_New);

   if( IsParamHDC == FALSE )
      ReleaseDC (NULL, hDC);

   hb_retni (0);   // OK status
}


//*************************************************************************************************
//* BT_BMP_SAVEFILE (hBitmap, cFileName, nTypePicture) ---> Return Success (TRUE or FALSE)
//*************************************************************************************************

// nTypePicture
#define BT_FILEFORMAT_BMP   0
#define BT_FILEFORMAT_JPG   1
#define BT_FILEFORMAT_GIF   2
#define BT_FILEFORMAT_TIF   3
#define BT_FILEFORMAT_PNG   4


BOOL bt_bmp_SaveFile (HBITMAP hBitmap, TCHAR* FileName, INT nTypePicture)
{
   HGLOBAL hBits;
   LPBYTE  lp_hBits;
   HANDLE  hFile;
   HDC memDC;
   BITMAPFILEHEADER BIFH;
   BITMAPINFO Bitmap_Info;
   BITMAP bm;
   DWORD nBytes_Bits, nBytes_Written;
   BOOL ret = FALSE;

   if (nTypePicture != 0)
       return (BOOL) bt_SaveGDIPlusPicture (hBitmap, FileName, nTypePicture);

   memDC = CreateCompatibleDC(NULL);
         SelectObject(memDC, hBitmap);
         GetObject(hBitmap, sizeof(BITMAP), (LPBYTE)&bm);

         bm.bmBitsPixel = 24;
         bm.bmWidthBytes = (bm.bmWidth * bm.bmBitsPixel + 31) / 32 * 4;
         nBytes_Bits = (DWORD)(bm.bmWidthBytes * labs(bm.bmHeight));


         BIFH.bfType = ('M' << 8) + 'B';
         BIFH.bfSize = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER) + nBytes_Bits;
         BIFH.bfReserved1 = 0;
         BIFH.bfReserved2 = 0;
         BIFH.bfOffBits = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);


         Bitmap_Info.bmiHeader.biSize          = sizeof(BITMAPINFOHEADER);
         Bitmap_Info.bmiHeader.biWidth         = bm.bmWidth;
         Bitmap_Info.bmiHeader.biHeight        = bm.bmHeight;
         Bitmap_Info.bmiHeader.biPlanes        = 1;
         Bitmap_Info.bmiHeader.biBitCount      = 24;
         Bitmap_Info.bmiHeader.biCompression   = BI_RGB;
         Bitmap_Info.bmiHeader.biSizeImage     = 0; //nBytes_Bits;
         Bitmap_Info.bmiHeader.biXPelsPerMeter = 0;
         Bitmap_Info.bmiHeader.biYPelsPerMeter = 0;
         Bitmap_Info.bmiHeader.biClrUsed       = 0;
         Bitmap_Info.bmiHeader.biClrImportant  = 0;

         hBits = GlobalAlloc (GHND, (DWORD) nBytes_Bits);
         if (hBits == NULL)
             return FALSE;

         lp_hBits = (LPBYTE) GlobalLock (hBits);

         GetDIBits (memDC, hBitmap, 0, Bitmap_Info.bmiHeader.biHeight, (LPVOID) lp_hBits, &Bitmap_Info, DIB_RGB_COLORS);

         hFile = CreateFile (FileName, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN, NULL);

         if (hFile != INVALID_HANDLE_VALUE)
         {  WriteFile(hFile, (LPBYTE)&BIFH,                   sizeof(BITMAPFILEHEADER), &nBytes_Written, NULL);
            WriteFile(hFile, (LPBYTE)&Bitmap_Info.bmiHeader,  sizeof(BITMAPINFOHEADER), &nBytes_Written, NULL);
            WriteFile(hFile, (LPBYTE)lp_hBits,                nBytes_Bits,              &nBytes_Written, NULL);
            CloseHandle (hFile);
            ret = TRUE;
         }
         else
            ret = FALSE;

         GlobalUnlock (hBits);
         GlobalFree (hBits);

   DeleteDC(memDC);
   return ret;
}


HB_FUNC (BT_BMP_SAVEFILE)
{
   HBITMAP hBitmap      = (HBITMAP) HMG_parnl (1);
   TCHAR  *FileName     = (TCHAR *) HMG_parc  (2);
   INT     nTypePicture = (INT)     hb_parnl  (3);
   hb_retl ((BOOL) bt_bmp_SaveFile (hBitmap, FileName, nTypePicture));
}



//**************************************************************************************************
//* BT_BMP_GETINFO (hBitmap, Info, x, y) ---> Return BT_BITMAP_INFO_xxx
//**************************************************************************************************

// Info
#define BT_BITMAP_INFO_WIDTH         0
#define BT_BITMAP_INFO_HEIGHT        1
#define BT_BITMAP_INFO_BITSPIXEL     2
#define BT_BITMAP_INFO_GETCOLORPIXEL 3


HB_FUNC (BT_BMP_GETINFO)
{  HBITMAP hBitmap;
   BITMAP bm;
   HDC memDC;
   COLORREF color;
   INT Info, x, y;


   hBitmap = (HBITMAP) HMG_parnl (1);
   Info    = (INT)     hb_parnl (2);

   GetObject(hBitmap, sizeof(BITMAP), (LPBYTE)&bm);

 /*
   BITMAP:
     LONG bmType;
     LONG bmWidth;
     LONG bmHeight;
     LONG bmWidthBytes;
     WORD bmPlanes;
     WORD bmBitsPixel;
     LPVOID bmBits;
 */

   switch (Info)
   {    case BT_BITMAP_INFO_WIDTH:
             hb_retnl ((long) bm.bmWidth);
             break;
        case BT_BITMAP_INFO_HEIGHT:
             hb_retnl ((long) bm.bmHeight);
             break;
        case BT_BITMAP_INFO_BITSPIXEL:
             hb_retnl ((long) bm.bmBitsPixel);
             break;
        case BT_BITMAP_INFO_GETCOLORPIXEL:
             x = (INT) hb_parni (3);
             y = (INT) hb_parni (4);
             memDC = CreateCompatibleDC(NULL);
             SelectObject(memDC, hBitmap);
             color = GetPixel(memDC, x, y);
             DeleteDC(memDC);
             hb_retnl ((long) color);
             break;
        default:
             hb_retnl (0);
             break;
    }
}



//*************************************************************************************************
//* BT_BMP_CLONE (hBitmap, x1, y1, Width1, Height1) ---> Return new_hBITMAP
//*************************************************************************************************

HB_FUNC (BT_BMP_CLONE)
{
   HBITMAP hBitmap, hBitmap_New;
   INT y1, x1, Width1, Height1;
   HDC memDC1, memDC2;

   hBitmap = (HBITMAP) HMG_parnl (1);
   x1      = (INT)     hb_parni (2);
   y1      = (INT)     hb_parni (3);
   Width1  = (INT)     hb_parni (4);
   Height1 = (INT)     hb_parni (5);


   memDC1 = CreateCompatibleDC(NULL);
   SelectObject(memDC1, hBitmap);

   memDC2 = CreateCompatibleDC(NULL);
   hBitmap_New = bt_bmp_create_24bpp (Width1, Height1);
   SelectObject(memDC2, hBitmap_New);

   BitBlt(memDC2, 0, 0, Width1, Height1, memDC1, x1, y1, SRCCOPY);
   DeleteDC(memDC1);
   DeleteDC(memDC2);

   HMG_retnl ((LONG_PTR) hBitmap_New);
}



//************************************************************************************************************
//* BT_BMP_COPYANDRESIZE (hBitmap, New_Width, New_Height, Mode_Stretch, nAlgorithm) ---> Return new_hBITMAP
//************************************************************************************************************

typedef struct {
   HGLOBAL hGlobal;
   HBITMAP hBitmap;
   LONG    Width;
   LONG    Height;
   LONG    WidthBytes;
   INT     nChannels;
   LPBYTE  lp_Bits;
} bt_BMPIMAGE;


// nAction
#define BT_BMP_GETBITS 0
#define BT_BMP_SETBITS 1


BOOL bt_BMP_BITS (bt_BMPIMAGE *Image, INT nAction)
{
   HDC memDC;
   BITMAPINFO BI;
   BITMAP bm;
   LPBYTE lp_Bits;

   if ((nAction != BT_BMP_GETBITS) && (nAction != BT_BMP_SETBITS))
        return FALSE;

   GetObject(Image->hBitmap, sizeof(BITMAP), (LPBYTE)&bm);

   BI.bmiHeader.biSize          = sizeof(BITMAPINFOHEADER);
   BI.bmiHeader.biWidth         = bm.bmWidth;
   BI.bmiHeader.biHeight        = -bm.bmHeight;
   BI.bmiHeader.biPlanes        = 1;
   BI.bmiHeader.biBitCount      = 24;
   BI.bmiHeader.biCompression   = BI_RGB;
   BI.bmiHeader.biSizeImage     = 0;
   BI.bmiHeader.biXPelsPerMeter = 0;
   BI.bmiHeader.biYPelsPerMeter = 0;
   BI.bmiHeader.biClrUsed       = 0;
   BI.bmiHeader.biClrImportant  = 0;

   bm.bmWidthBytes = (bm.bmWidth * BI.bmiHeader.biBitCount + 31) / 32 * 4;

   if (nAction == BT_BMP_GETBITS)
   {   Image->WidthBytes = bm.bmWidthBytes;
       Image->Height     = bm.bmHeight;
       Image->Width      = bm.bmWidth;
       Image->nChannels  = 3;   //3 bytes per pixel
       Image->hGlobal    = GlobalAlloc (GHND, (DWORD) (bm.bmWidthBytes * labs(bm.bmHeight)));
   }

   if (Image->hGlobal == NULL)
       return FALSE;

   lp_Bits = (LPBYTE) GlobalLock (Image->hGlobal);
   memDC = CreateCompatibleDC(NULL);

   if (nAction == BT_BMP_GETBITS)
       GetDIBits (memDC, Image->hBitmap, 0, bm.bmHeight, (LPVOID) lp_Bits, &BI, DIB_RGB_COLORS);
   else
       SetDIBits (memDC, Image->hBitmap, 0, bm.bmHeight, (LPVOID) lp_Bits, &BI, DIB_RGB_COLORS);

   DeleteDC (memDC);
   GlobalUnlock (Image->hGlobal);
   return TRUE;
}


int bt_BMP_GETBYTE (bt_BMPIMAGE Image, int x, int y, int channel)
{
  if (x >= 0 && x < Image.Width && y >= 0 && y < Image.Height)
      return (int) Image.lp_Bits [(y * Image.WidthBytes) + (x * Image.nChannels + channel)];
  else
     return 0;
}


int bt_BMP_SETBYTE (bt_BMPIMAGE Image, int x, int y, int channel, BYTE value)
{
  if (x >= 0 && x < Image.Width && y >= 0 && y < Image.Height)
      return (int) (Image.lp_Bits [(y * Image.WidthBytes) + (x * Image.nChannels + channel)] = value);
  else
     return -1;
}


HBITMAP bt_BiLinearInterpolation (HBITMAP hBitmap, int newWidth, int newHeight)
{
   double a,b,c,d, Color;
   double x_diff, y_diff, x_ratio, y_ratio;
   int   Row, Col, Channel;
   int   x, y;
   bt_BMPIMAGE Image1, Image2;

   Image1.hBitmap = hBitmap;
   if (bt_BMP_BITS (&Image1, BT_BMP_GETBITS) == FALSE)
       return NULL;

   Image2.hBitmap = bt_bmp_create_24bpp (newWidth, newHeight);
   if (bt_BMP_BITS (&Image2, BT_BMP_GETBITS) == FALSE)
   {   GlobalFree (Image1.hGlobal);
       if (Image2.hBitmap != NULL)
           DeleteObject (Image2.hBitmap);
       return NULL;
   }

   Image1.lp_Bits = (LPBYTE) GlobalLock (Image1.hGlobal);
   Image2.lp_Bits = (LPBYTE) GlobalLock (Image2.hGlobal);

   y_ratio = (double)Image1.Height / (double)Image2.Height;
   x_ratio = (double)Image1.Width  / (double)Image2.Width ;

   for (Row=0; Row < Image2.Height; Row++)
   {
      for (Col=0; Col < Image2.Width;  Col++)
      {
           x = (int)(x_ratio * Col);
           y = (int)(y_ratio * Row);

           x_diff = (double)((x_ratio * Col) - x);
           y_diff = (double)((y_ratio * Row) - y);

           for (Channel=0; Channel < 3; Channel++)   // color channel C = R,G,B
           {
              a = (double)bt_BMP_GETBYTE (Image1, (x+0), (y+0), Channel);
              b = (double)bt_BMP_GETBYTE (Image1, (x+1), (y+0), Channel);
              c = (double)bt_BMP_GETBYTE (Image1, (x+0), (y+1), Channel);
              d = (double)bt_BMP_GETBYTE (Image1, (x+1), (y+1), Channel);

              // Color = A(1-w)(1-h) + B(w)(1-h) + C(h)(1-w) + D(wh)
              Color = a*(1.00-x_diff)*(1.00-y_diff) + b*(x_diff)*(1.00-y_diff) + c*(y_diff)*(1.00-x_diff) + d*(x_diff*y_diff);

              bt_BMP_SETBYTE (Image2, Col, Row, Channel, (BYTE) Color);
           }
      }
   }
   GlobalUnlock (Image1.hGlobal);
   GlobalUnlock (Image2.hGlobal);

   bt_BMP_BITS (&Image2, BT_BMP_SETBITS);

   GlobalFree (Image1.hGlobal);
   GlobalFree (Image2.hGlobal);

   return Image2.hBitmap;
}


// nAlgorithm
#define BT_RESIZE_COLORONCOLOR   0
#define BT_RESIZE_HALFTONE       1
#define BT_RESIZE_BILINEAR       2


HB_FUNC (BT_BMP_COPYANDRESIZE)
{
   BITMAP bm;
   HBITMAP hBitmap1, hBitmap_New;
   INT Width1, Height1;
   INT New_Width, New_Height, Mode_Stretch, nAlgorithm;
   HDC memDC1, memDC2;
   POINT Point;

   hBitmap1      = (HBITMAP)  HMG_parnl (1);
   New_Width     = (INT)      hb_parni (2);
   New_Height    = (INT)      hb_parni (3);
   Mode_Stretch  = (INT)      hb_parni (4);
   nAlgorithm    = (INT)      hb_parni (5);
   hBitmap_New   =  NULL;

   memDC1 = CreateCompatibleDC(NULL);
   SelectObject(memDC1, hBitmap1);
   GetObject(hBitmap1, sizeof(BITMAP), (LPBYTE)&bm);

   Width1  = (INT) bm.bmWidth;
   Height1 = (INT) bm.bmHeight;
   bt_bmp_adjust_rect (&New_Width, &New_Height, &Width1, &Height1, Mode_Stretch);

   if (nAlgorithm == BT_RESIZE_COLORONCOLOR || nAlgorithm == BT_RESIZE_HALFTONE)
   {
      hBitmap_New = bt_bmp_create_24bpp (New_Width, New_Height);

      memDC2 = CreateCompatibleDC(NULL);
      SelectObject(memDC2, hBitmap_New);

      if (nAlgorithm == BT_RESIZE_COLORONCOLOR)
          SetStretchBltMode (memDC2, COLORONCOLOR);
      else
      {
         GetBrushOrgEx (memDC2, &Point);
         SetStretchBltMode (memDC2, HALFTONE);
         SetBrushOrgEx (memDC2, Point.x, Point.y, NULL);
      }
      StretchBlt (memDC2, 0, 0, New_Width, New_Height, memDC1, 0, 0, bm.bmWidth, bm.bmHeight, SRCCOPY);

      DeleteDC(memDC2);
   }

   DeleteDC(memDC1);


   if (nAlgorithm == BT_RESIZE_BILINEAR)
       hBitmap_New = bt_BiLinearInterpolation (hBitmap1, New_Width, New_Height);

   HMG_retnl ((LONG_PTR) hBitmap_New);
}



//*****************************************************************************************************************************
//* BT_BMP_PASTE (hBitmap_D, x1, y1, Width1, Height1, hBitmap_O, x2, y2, Width2, Height2, Mode_Stretch, Action, Color_Transp)
//*****************************************************************************************************************************

// Action
#define BT_BITMAP_OPAQUE        0
#define BT_BITMAP_TRANSPARENT   1

HB_FUNC (BT_BMP_PASTE)
{
   HBITMAP hBitmap_D, hBitmap_O;
   INT x1, y1, Width1, Height1, x2, y2, Width2, Height2;
   INT Mode_Stretch, Action;
   HDC memDC_D, memDC_O;
   COLORREF color_transp;
   POINT Point;

   hBitmap_D     = (HBITMAP)  HMG_parnl (1);
   x1            = (INT)      hb_parni (2);
   y1            = (INT)      hb_parni (3);
   Width1        = (INT)      hb_parni (4);
   Height1       = (INT)      hb_parni (5);

   hBitmap_O     = (HBITMAP)  HMG_parnl (6);
   x2            = (INT)      hb_parni (7);
   y2            = (INT)      hb_parni (8);
   Width2        = (INT)      hb_parni (9);
   Height2       = (INT)      hb_parni (10);

   Mode_Stretch  = (INT)      hb_parni (11);
   Action        = (INT)      hb_parni (12);
   color_transp  = (COLORREF) hb_parnl (13);


   memDC_D = CreateCompatibleDC(NULL);
   SelectObject(memDC_D, hBitmap_D);

   memDC_O = CreateCompatibleDC(NULL);
   SelectObject(memDC_O, hBitmap_O);

   bt_bmp_adjust_rect (&Width1, &Height1, &Width2, &Height2, Mode_Stretch);

   //SetStretchBltMode (memDC_D, COLORONCOLOR);
   GetBrushOrgEx (memDC_D, &Point);
   SetStretchBltMode (memDC_D, HALFTONE);
   SetBrushOrgEx (memDC_D, Point.x, Point.y, NULL);


   switch (Action)
   {    case BT_BITMAP_OPAQUE:
             StretchBlt     (memDC_D, x1, y1, Width1, Height1, memDC_O, x2, y2, Width2, Height2, SRCCOPY);
             break;
        case BT_BITMAP_TRANSPARENT:
             TransparentBlt (memDC_D, x1, y1, Width1, Height1, memDC_O, x2, y2, Width2, Height2, color_transp);
             break;
        default:
             hb_retl (FALSE);
             return;
   }

   DeleteDC(memDC_D);
   DeleteDC(memDC_O);
   hb_retl (TRUE);
}



//**********************************************************************************************************************
//* BT_BMP_PASTE_ALPHABLEND (hBitmap_D, x1, y1, Width1, Height1, hBitmap_O, x2, y2, Width2, Height2, Alpha, Mode_Stretch)
//**********************************************************************************************************************

// Alpha = 0 to 255
#define BT_ALPHABLEND_TRANSPARENT   0
#define BT_ALPHABLEND_OPAQUE      255

HB_FUNC (BT_BMP_PASTE_ALPHABLEND)
{
   HBITMAP hBitmap_D, hBitmap_O;
   HDC memDC_D, memDC_O;
   INT x1, y1, Width1, Height1, x2, y2, Width2, Height2, Mode_Stretch;
   BLENDFUNCTION blend;
   BYTE Alpha;
   POINT Point;

   hBitmap_D  = (HBITMAP) HMG_parnl (1);
   x1         = (INT)     hb_parni (2);
   y1         = (INT)     hb_parni (3);
   Width1     = (INT)     hb_parni (4);
   Height1    = (INT)     hb_parni (5);

   hBitmap_O  = (HBITMAP) HMG_parnl (6);
   x2         = (INT)     hb_parni (7);
   y2         = (INT)     hb_parni (8);
   Width2     = (INT)     hb_parni (9);
   Height2    = (INT)     hb_parni (10);

   Alpha         = (BYTE) hb_parni (11);
   Mode_Stretch  = (INT)  hb_parni (12);


   blend.BlendOp = AC_SRC_OVER;
   blend.BlendFlags = 0;
   blend.AlphaFormat = 0;
   blend.SourceConstantAlpha = Alpha;


   memDC_D = CreateCompatibleDC(NULL);
   SelectObject(memDC_D, hBitmap_D);

   memDC_O = CreateCompatibleDC(NULL);
   SelectObject(memDC_O, hBitmap_O);

   bt_bmp_adjust_rect (&Width1, &Height1, &Width2, &Height2, Mode_Stretch);

   //SetStretchBltMode (memDC_D, COLORONCOLOR);
   GetBrushOrgEx (memDC_D, &Point);
   SetStretchBltMode (memDC_D, HALFTONE);
   SetBrushOrgEx (memDC_D, Point.x, Point.y, NULL);

   AlphaBlend (memDC_D, x1, y1, Width1, Height1, memDC_O, x2, y2, Width2, Height2, blend);

   DeleteDC(memDC_D);
   DeleteDC(memDC_O);
}



//********************************************************************************
//* BT_BMP_CAPTURESCR (hWnd, x1, y1, Width1, Height1, Mode) ---> Return new_hBITMAP
//********************************************************************************

// Mode
#define BT_BITMAP_CAPTURE_DESKTOP    0
#define BT_BITMAP_CAPTURE_WINDOW     1
#define BT_BITMAP_CAPTURE_CLIENTAREA 2

HB_FUNC (BT_BMP_CAPTURESCR)
{
   HWND hWnd;
   HBITMAP hBitmap;
   HDC hDC, memDC;
   INT x1, y1, Width1, Height1, Mode;

   hWnd    = (HWND) HMG_parnl (1);
   x1      = (INT)  hb_parni (2);
   y1      = (INT)  hb_parni (3);
   Width1  = (INT)  hb_parni (4);
   Height1 = (INT)  hb_parni (5);
   Mode    = (INT)  hb_parni (6);

   switch (Mode)
   {    case BT_BITMAP_CAPTURE_DESKTOP:
             // hWnd = GetDesktopWindow();
             hDC = GetDC (hWnd);
             break;
        case BT_BITMAP_CAPTURE_WINDOW:
             hDC = GetWindowDC (hWnd);
             break;
        case BT_BITMAP_CAPTURE_CLIENTAREA:
             hDC = GetDC (hWnd);
             break;
        default:
             hb_retnl(0);
             return;
   }

       hBitmap = bt_bmp_create_24bpp (Width1, Height1);

       memDC = CreateCompatibleDC(NULL);
       SelectObject(memDC, hBitmap);

       BitBlt(memDC, 0, 0, Width1, Height1, hDC, x1, y1, SRCCOPY);

       DeleteDC(memDC);

   switch (Mode)
   {    case BT_BITMAP_CAPTURE_DESKTOP:
        case BT_BITMAP_CAPTURE_WINDOW:
        case BT_BITMAP_CAPTURE_CLIENTAREA:
             ReleaseDC (hWnd, hDC);
             break;
   }

   HMG_retnl ((LONG_PTR) hBitmap);
}



//**************************************************************************************************
//* BT_BMP_PROCESS (hBitmap, Action, Value)
//**************************************************************************************************

// Action                                       Value
#define BT_BMP_PROCESS_INVERT        0          // NIL
#define BT_BMP_PROCESS_GRAYNESS      1          // Gray_Level     = 0 to 100%
#define BT_BMP_PROCESS_BRIGHTNESS    2          // Light_Level    = -255 To +255
#define BT_BMP_PROCESS_CONTRAST      3          // Contrast_Angle = angle in radians
#define BT_BMP_PROCESS_MODIFYCOLOR   4          // { R = -255 To +255, G = -255 To +255, B = -255 To +255 }
#define BT_BMP_PROCESS_GAMMACORRECT  5          // {RedGamma = 0.2 To 5.0, GreenGamma = 0.2 To 5.0, BlueGamma = 0.2 To 5.0}


// Gray_Level = 0 To 100%
#define BT_BITMAP_GRAY_NONE 0
#define BT_BITMAP_GRAY_FULL 100

// Light_Level = -255 To +255
#define BT_BITMAP_LIGHT_BLACK -255
#define BT_BITMAP_LIGHT_NONE  0
#define BT_BITMAP_LIGHT_WHITE 255


HB_FUNC (BT_BMP_PROCESS)
{
   typedef struct {
     BYTE R;
     BYTE G;
     BYTE B;
   } bt_RGBCOLORBYTE;

   #define bt_RGB_TO_GRAY(R,G,B) (INT)((FLOAT)R * 0.299 + (FLOAT)G * 0.587 + (FLOAT)B * 0.114)
   #define bt_GAMMA(index,gamma) (min (255, (INT)((255.0 * pow(((DOUBLE)index/255.0), (1.0/(DOUBLE)gamma))) + 0.5)))
 //  redGamma[i] = (byte)           Min (255, (int)(( 255.0 *Pow(i/255.0, 1.0/g_red)) + 0.5));

   HGLOBAL hBits;
   LPBYTE  lp_Bits;
   DWORD nBytes_Bits;
   HBITMAP hBitmap;
   HDC memDC;
   BITMAPINFO BI;
   BITMAP bm;
   bt_RGBCOLORBYTE *RGBcolor;
   register INT x, y;
   BYTE GrayValue;
   FLOAT GrayLevel=0;
   INT LightLevel=0, RLevel=0, GLevel=0, BLevel=0;
   DOUBLE ContrastAngle, ContrastConstant=0, ContrastValue;
   DOUBLE RedGamma, GreenGamma, BlueGamma;
   BYTE   RedGammaRamp   [256];
   BYTE   GreenGammaRamp [256];
   BYTE   BlueGammaRamp  [256];
   INT i, Action;

   hBitmap    = (HBITMAP)  HMG_parnl (1);
   Action     = (INT)      hb_parni (2);

   switch (Action)
   {    case BT_BMP_PROCESS_INVERT:
             break;

        case BT_BMP_PROCESS_GRAYNESS:
             GrayLevel = (FLOAT) hb_parnd (3) / 100.0;
             if (GrayLevel <= 0.0 || GrayLevel > 1.0)
             {   hb_retl (FALSE);
                 return;
             }
             break;

        case BT_BMP_PROCESS_BRIGHTNESS:
             LightLevel = (INT) hb_parni (3);
             if ((LightLevel < -255)|| (LightLevel == 0) ||(LightLevel > 255))
             {    hb_retl (FALSE);
                  return;
             }
             break;

        case BT_BMP_PROCESS_CONTRAST:
             ContrastAngle = (DOUBLE) hb_parnd (3);
             if (ContrastAngle <= 0.0)
             {   hb_retl (FALSE);
                 return;
             }
             ContrastConstant = tan (ContrastAngle * M_PI / 180.0);
             break;

        case BT_BMP_PROCESS_MODIFYCOLOR:
             if (!HB_ISARRAY(3) || hb_parinfa(3,0) != 3)
             {    hb_retl (FALSE);
                  return;
             }
             RLevel = (INT) hb_parvni (3, 1);
             GLevel = (INT) hb_parvni (3, 2);
             BLevel = (INT) hb_parvni (3, 3);
             if ((min (min (RLevel, GLevel), BLevel)  < -255) || (max (max (RLevel, GLevel), BLevel) > 255))
             {    hb_retl (FALSE);
                  return;
             }
             break;

        case BT_BMP_PROCESS_GAMMACORRECT:
             if (!HB_ISARRAY(3) || hb_parinfa(3,0) != 3)
             {    hb_retl (FALSE);
                  return;
             }
             RedGamma   = (DOUBLE) hb_parvnd (3, 1);
             GreenGamma = (DOUBLE) hb_parvnd (3, 2);
             BlueGamma  = (DOUBLE) hb_parvnd (3, 3);
             for (i=0; i < 256; i++)
             {    RedGammaRamp   [i] = (BYTE) bt_GAMMA (i, RedGamma);
                  GreenGammaRamp [i] = (BYTE) bt_GAMMA (i, GreenGamma);
                  BlueGammaRamp  [i] = (BYTE) bt_GAMMA (i, BlueGamma);
             }
             break;

        default:
             hb_retl (FALSE);
             return;
   }


   GetObject(hBitmap, sizeof(BITMAP), (LPBYTE)&bm);

   BI.bmiHeader.biSize          = sizeof(BITMAPINFOHEADER);
   BI.bmiHeader.biWidth         = bm.bmWidth;
   BI.bmiHeader.biHeight        = bm.bmHeight;
   BI.bmiHeader.biPlanes        = 1;
   BI.bmiHeader.biBitCount      = 24;
   BI.bmiHeader.biCompression   = BI_RGB;
   BI.bmiHeader.biSizeImage     = 0;
   BI.bmiHeader.biXPelsPerMeter = 0;
   BI.bmiHeader.biYPelsPerMeter = 0;
   BI.bmiHeader.biClrUsed       = 0;
   BI.bmiHeader.biClrImportant  = 0;

   bm.bmWidthBytes = (bm.bmWidth * BI.bmiHeader.biBitCount + 31) / 32 * 4;
   nBytes_Bits  = (DWORD)(bm.bmWidthBytes * labs(bm.bmHeight));

   hBits = GlobalAlloc (GHND, (DWORD) nBytes_Bits);
   if (hBits == NULL)
   {   hb_retl (FALSE);
       return;
   }
   else
      lp_Bits = (LPBYTE) GlobalLock (hBits);

   memDC = CreateCompatibleDC(NULL);
   GetDIBits (memDC, hBitmap, 0, bm.bmHeight, (LPVOID) lp_Bits, &BI, DIB_RGB_COLORS);

   for (y = 0; y < bm.bmHeight; y++)
   {
       RGBcolor = (bt_RGBCOLORBYTE *) (lp_Bits + (LONG) (y) * bm.bmWidthBytes);

       for (x = 0; x < bm.bmWidth; x++)
       {
           if (Action == BT_BMP_PROCESS_INVERT)
           {   RGBcolor->R = (BYTE)(255 - RGBcolor->R);
               RGBcolor->G = (BYTE)(255 - RGBcolor->G);
               RGBcolor->B = (BYTE)(255 - RGBcolor->B);
           }

           if (Action == BT_BMP_PROCESS_GRAYNESS)
           {   GrayValue = (BYTE) bt_RGB_TO_GRAY (RGBcolor->R, RGBcolor->G, RGBcolor->B);
               RGBcolor->R = RGBcolor->R + (GrayValue - RGBcolor->R) * GrayLevel;
               RGBcolor->G = RGBcolor->G + (GrayValue - RGBcolor->G) * GrayLevel;
               RGBcolor->B = RGBcolor->B + (GrayValue - RGBcolor->B) * GrayLevel;
           }

           if (Action == BT_BMP_PROCESS_BRIGHTNESS)
           {   RGBcolor->R = ((RGBcolor->R + LightLevel < 0) ? 0 : ((RGBcolor->R + LightLevel > 255) ? 255 : (RGBcolor->R + LightLevel)));
               RGBcolor->G = ((RGBcolor->G + LightLevel < 0) ? 0 : ((RGBcolor->G + LightLevel > 255) ? 255 : (RGBcolor->G + LightLevel)));
               RGBcolor->B = ((RGBcolor->B + LightLevel < 0) ? 0 : ((RGBcolor->B + LightLevel > 255) ? 255 : (RGBcolor->B + LightLevel)));
           }

           if (Action == BT_BMP_PROCESS_CONTRAST)
           {   ContrastValue = 128 + (RGBcolor->R - 128) * ContrastConstant;
               RGBcolor->R = (BYTE)((ContrastValue < 0) ? 0 : ((ContrastValue > 255) ? 255 : ContrastValue));
               ContrastValue = 128 + (RGBcolor->G - 128) * ContrastConstant;
               RGBcolor->G = (BYTE)((ContrastValue < 0) ? 0 : ((ContrastValue > 255) ? 255 : ContrastValue));
               ContrastValue = 128 + (RGBcolor->B - 128) * ContrastConstant;
               RGBcolor->B = (BYTE)((ContrastValue < 0) ? 0 : ((ContrastValue > 255) ? 255 : ContrastValue));
           }

           if (Action == BT_BMP_PROCESS_MODIFYCOLOR)
           {   RGBcolor->R = ((RGBcolor->R + RLevel < 0) ? 0 : ((RGBcolor->R + RLevel > 255) ? 255 : (RGBcolor->R + RLevel)));
               RGBcolor->G = ((RGBcolor->G + GLevel < 0) ? 0 : ((RGBcolor->G + GLevel > 255) ? 255 : (RGBcolor->G + GLevel)));
               RGBcolor->B = ((RGBcolor->B + BLevel < 0) ? 0 : ((RGBcolor->B + BLevel > 255) ? 255 : (RGBcolor->B + BLevel)));
           }

           if (Action == BT_BMP_PROCESS_GAMMACORRECT)
           {   RGBcolor->R = RedGammaRamp   [ RGBcolor->R ];
               RGBcolor->G = GreenGammaRamp [ RGBcolor->G ];
               RGBcolor->B = BlueGammaRamp  [ RGBcolor->B ];
           }

           RGBcolor ++;
       }
   }

   SetDIBits (memDC, hBitmap, 0, bm.bmHeight, lp_Bits, &BI, DIB_RGB_COLORS);
   DeleteDC (memDC);

   GlobalUnlock (hBits);
   GlobalFree (hBits);
   hb_retl (TRUE);
}



//**************************************************************************************************
//* BT_BMP_FILTER3X3 (hBitmap, aFilter)
//**************************************************************************************************

typedef struct {
     BYTE R;
     BYTE G;
     BYTE B;
   } bt_RGBCOLORBYTE;
                                                                 // Divisor  Bias
#define  BT_Kernel3x3Filter1  {  1,  1,  1,  1,  1,  1,  1,  1,  1,       9,    0 } // Smooth
#define  BT_Kernel3x3Filter2  {  0,  1,  0,  1,  4,  1,  0,  1,  0,       8,    0 } // Gaussian Smooth
#define  BT_Kernel3x3Filter3  {  0, -1,  0, -1,  9, -1,  0, -1,  0,       5,    0 } // Sharpening
#define  BT_Kernel3x3Filter4  { -1, -1, -1, -1,  8, -1, -1, -1, -1,       1,  128 } // Laplacian
#define  BT_Kernel3x3Filter5  {  1,  0,  0,  0,  0,  0,  0,  0, -1,       1,  128 } // Emboss 135°
#define  BT_Kernel3x3Filter6  {  0,  1,  0,  0,  0,  0,  0, -1,  0,       2,  128 } // Emboss 90° 50%

bt_RGBCOLORBYTE bt_ConvolutionKernel3x3 (bt_RGBCOLORBYTE *Y_previous, bt_RGBCOLORBYTE *Y_current, bt_RGBCOLORBYTE *Y_posterior, INT K[])
{
    bt_RGBCOLORBYTE RGBcolor;
    INT Red, Green, Blue;
    INT Divisor = K [ 9];
    INT Bias    = K [10];

    if (Divisor == 0) Divisor = 1;

        //   Y-1,X-1                    Y-1,X+0                    Y-1,X+1
        //   Y+0,X-1                  [ Y+0,X+0 ]                  Y+0,X+1
        //   Y+1,X-1                    Y+1,X+0                    Y+1,X+1
    Red  = ((Y_previous -1)->R *K[0] + (Y_previous +0)->R *K[1] + (Y_previous +1)->R *K[2] +                    // Y_previous  = Y-1,X+0
            (Y_current  -1)->R *K[3] + (Y_current  +0)->R *K[4] + (Y_current  +1)->R *K[5] +                    // Y_current   = Y+0,X+0
            (Y_posterior-1)->R *K[6] + (Y_posterior+0)->R *K[7] + (Y_posterior+1)->R *K[8] ) / Divisor + Bias;  // Y_posterior = Y+1,X+0

   Green = ((Y_previous -1)->G *K[0] + (Y_previous +0)->G *K[1] + (Y_previous +1)->G *K[2] +
            (Y_current  -1)->G *K[3] + (Y_current  +0)->G *K[4] + (Y_current  +1)->G *K[5] +
            (Y_posterior-1)->G *K[6] + (Y_posterior+0)->G *K[7] + (Y_posterior+1)->G *K[8] ) / Divisor + Bias;

   Blue  = ((Y_previous -1)->B *K[0] + (Y_previous +0)->B *K[1] + (Y_previous +1)->B *K[2] +
            (Y_current  -1)->B *K[3] + (Y_current  +0)->B *K[4] + (Y_current  +1)->B *K[5] +
            (Y_posterior-1)->B *K[6] + (Y_posterior+0)->B *K[7] + (Y_posterior+1)->B *K[8] ) / Divisor + Bias;

   #define bt_BoundRange(Value,RangeMin,RangeMax) ((Value < RangeMin)? RangeMin : ((Value > RangeMax)? RangeMax : Value))

   RGBcolor.R = (BYTE) bt_BoundRange(Red,   0, 255);
   RGBcolor.G = (BYTE) bt_BoundRange(Green, 0, 255);
   RGBcolor.B = (BYTE) bt_BoundRange(Blue,  0, 255);

    return RGBcolor;
}


HB_FUNC (BT_BMP_FILTER3X3)
{
   #define N 3
   #define HALF ((N-1)/2)
   #define nMATFILTER (N*N+2)

   HGLOBAL hBits_O, hBits_D;
   LPBYTE  lp_Bits_O, lp_Bits_D;
   DWORD nBytes_Bits;
   HBITMAP hBitmap;
   HDC memDC;
   BITMAPINFO BI;
   BITMAP bm;
// bt_RGBCOLORBYTE *RGBcolor_O;
   bt_RGBCOLORBYTE *RGBcolor_D, RGBcolor_Ret;
   bt_RGBCOLORBYTE *RGBcolor_Yprevious_Xcurrent, *RGBcolor_Ycurrent_Xcurrent, *RGBcolor_Yposterior_Xcurrent;
   register INT x, y;
   INT i, MatKernel3x3Filter [nMATFILTER];


   hBitmap    = (HBITMAP) HMG_parnl (1);
   if (!HB_ISARRAY(2) || hb_parinfa(2,0) != nMATFILTER)
   {    hb_retl (FALSE);
        return;
   }
   for (i=0; i < nMATFILTER; i++)
        MatKernel3x3Filter [i] = (INT) hb_parvni (2, i+1);


   GetObject(hBitmap, sizeof(BITMAP), (LPBYTE)&bm);

   BI.bmiHeader.biSize          = sizeof(BITMAPINFOHEADER);
   BI.bmiHeader.biWidth         = bm.bmWidth;
   BI.bmiHeader.biHeight        = -bm.bmHeight;
   BI.bmiHeader.biPlanes        = 1;
   BI.bmiHeader.biBitCount      = 24;
   BI.bmiHeader.biCompression   = BI_RGB;
   BI.bmiHeader.biSizeImage     = 0;
   BI.bmiHeader.biXPelsPerMeter = 0;
   BI.bmiHeader.biYPelsPerMeter = 0;
   BI.bmiHeader.biClrUsed       = 0;
   BI.bmiHeader.biClrImportant  = 0;


   bm.bmWidthBytes = (bm.bmWidth * BI.bmiHeader.biBitCount + 31) / 32 * 4;
   nBytes_Bits  = (DWORD)(bm.bmWidthBytes * labs(bm.bmHeight));

   hBits_O = GlobalAlloc (GHND, (DWORD) nBytes_Bits);
   if (hBits_O == NULL)
   {   hb_retl (FALSE);
       return;
   }

   hBits_D = GlobalAlloc (GHND, (DWORD) nBytes_Bits);
   if (hBits_D == NULL)
   {   GlobalFree (hBits_O);
       hb_retl (FALSE);
       return;
   }

   lp_Bits_O = (LPBYTE) GlobalLock (hBits_O);
   lp_Bits_D = (LPBYTE) GlobalLock (hBits_D);

   memDC = CreateCompatibleDC(NULL);

   GetDIBits (memDC, hBitmap, 0, bm.bmHeight, (LPVOID) lp_Bits_O, &BI, DIB_RGB_COLORS);

   for (y = 0; y < bm.bmHeight; y++)
   {
//     RGBcolor_O = (bt_RGBCOLORBYTE *) (lp_Bits_O + (LONG) (y) * bm.bmWidthBytes);
       RGBcolor_D = (bt_RGBCOLORBYTE *) (lp_Bits_D + (LONG) (y) * bm.bmWidthBytes);

       for (x = 0; x < bm.bmWidth; x++)
       {
           if ((y >= HALF && y < (bm.bmHeight - HALF)) && (x >= HALF && x < (bm.bmWidth - HALF)))
           {
              RGBcolor_Yprevious_Xcurrent  = (bt_RGBCOLORBYTE *) (lp_Bits_O + (LONG) (y-1) * bm.bmWidthBytes + x * sizeof (bt_RGBCOLORBYTE));
              RGBcolor_Ycurrent_Xcurrent   = (bt_RGBCOLORBYTE *) (lp_Bits_O + (LONG) (y+0) * bm.bmWidthBytes + x * sizeof (bt_RGBCOLORBYTE));
              RGBcolor_Yposterior_Xcurrent = (bt_RGBCOLORBYTE *) (lp_Bits_O + (LONG) (y+1) * bm.bmWidthBytes + x * sizeof (bt_RGBCOLORBYTE));

              RGBcolor_Ret = bt_ConvolutionKernel3x3 (RGBcolor_Yprevious_Xcurrent,
                                                      RGBcolor_Ycurrent_Xcurrent,
                                                      RGBcolor_Yposterior_Xcurrent,
                                                      MatKernel3x3Filter);
              RGBcolor_D->R = RGBcolor_Ret.R;
              RGBcolor_D->G = RGBcolor_Ret.G;
              RGBcolor_D->B = RGBcolor_Ret.B;

/*
              #define BT_FILTER_NONE     0
              #define BT_FILTER_FULL   255
              INT Alpha = 200;  // transparent = color origin = 0 To 255 = opaque = full filter color
              RGBcolor_D->R = (BYTE)((RGBcolor_Ret.R * Alpha + RGBcolor_O->R * (255 - Alpha)) / 255);
              RGBcolor_D->G = (BYTE)((RGBcolor_Ret.G * Alpha + RGBcolor_O->G * (255 - Alpha)) / 255);
              RGBcolor_D->B = (BYTE)((RGBcolor_Ret.B * Alpha + RGBcolor_O->B * (255 - Alpha)) / 255);
*/
           }
//         RGBcolor_O ++;
           RGBcolor_D ++;
       }
   }

   SetDIBits (memDC, hBitmap, 0, bm.bmHeight, lp_Bits_D, &BI, DIB_RGB_COLORS);

   DeleteDC (memDC);

   GlobalUnlock (hBits_O);
   GlobalUnlock (hBits_D);

   GlobalFree (hBits_O);
   GlobalFree (hBits_D);

   hb_retl (TRUE);
}



//***********************************************************************************************************************
//* BT_BMP_TRANSFORM (hBitmap, Mode, Angle, Color_Fill_Bk) ---> Return New_hBitmap
//***********************************************************************************************************************

// Mode
#define BT_BITMAP_REFLECT_HORIZONTAL 1
#define BT_BITMAP_REFLECT_VERTICAL   2
#define BT_BITMAP_ROTATE             4

// Angle (mode rotate) = 0 to 360º
// Color_Fill_Bk (mode rotate) = color to fill the empty spaces the background

HB_FUNC (BT_BMP_TRANSFORM)
{
   HDC memDC1, memDC2;
   HBITMAP hBitmap_O, hBitmap_D;
   BITMAP bm;
   INT Width, Height, Mode;
   FLOAT Angle;
   double radianes, x1, y1, x2, y2, x3, y3;
   XFORM xform1  = {1, 0, 0, 1, 0, 0}; // Normal
   XFORM xform2  = {1, 0, 0, 1, 0, 0}; // Normal
   XFORM xform_D = {1, 0, 0, 1, 0, 0}; // Normal
   RECT rectang;
   HBRUSH hBrush;
   COLORREF Color_Fill_Bk;
   POINT Point;

   const double pi = 3.141592;
   #define dABS(n) ((double)n >= 0.0 ? (double) n : (double) -n)
   #define SCALING(n) ((double)n > 1.0 ? (double) (1.0/n) : (double) 1.0)

   hBitmap_O      = (HBITMAP)  HMG_parnl (1);
   Mode           = (INT)      hb_parnl (2);
   Angle          = (FLOAT)    hb_parnd (3);
   Color_Fill_Bk  = (COLORREF) hb_parnl (4);

   memDC1 = CreateCompatibleDC(NULL);
   SelectObject(memDC1, hBitmap_O);
   GetObject(hBitmap_O, sizeof(BITMAP), (LPBYTE)&bm);

   Width  = bm.bmWidth;
   Height = bm.bmHeight;


   memDC2 = CreateCompatibleDC(NULL);
   SetGraphicsMode(memDC2, GM_ADVANCED);

   if ((Mode & BT_BITMAP_REFLECT_HORIZONTAL) == BT_BITMAP_REFLECT_HORIZONTAL)
   {   xform1.eM11 = (FLOAT) -1.0;
       xform1.eDx  = (FLOAT)  (Width -1);

       if ((Mode & BT_BITMAP_ROTATE) == BT_BITMAP_ROTATE)
            xform1.eDx  = (FLOAT)   Width;
   }

   if ((Mode & BT_BITMAP_REFLECT_VERTICAL) == BT_BITMAP_REFLECT_VERTICAL)
   {   xform1.eM22 = (FLOAT) -1.0;
       xform1.eDy  = (FLOAT)  (Height -1);

       if ((Mode & BT_BITMAP_ROTATE) == BT_BITMAP_ROTATE)
            xform1.eDy  = (FLOAT)  Height;
   }

   if ((Mode & BT_BITMAP_ROTATE) == BT_BITMAP_ROTATE)
   {
      if ((Angle <= 0.0) || (Angle > 360.0))
           Angle = 360.0;

       // Angle = angulo en grados
       radianes = (2*pi) * (double)Angle / (double)360.0;

       // x1,y1 = W,0
       // x2,y2 = W,H
       // x3,y3 = 0,H

       // A = angle in radians
       // new_x = (x * cos A) - (y * sin A)
       // new_y = (x * sin A) + (y * cos A)


       x1 = ((double)Width * cos(radianes));
       y1 = ((double)Width * sin(radianes));

       x2 = ((double)Width * cos(radianes)) - ((double)Height * sin(radianes));
       y2 = ((double)Width * sin(radianes)) + ((double)Height * cos(radianes));

       x3 =  - ((double)Height * sin(radianes));
       y3 =    ((double)Height * cos(radianes));


       xform2.eM11 = (FLOAT)  cos (radianes);
       xform2.eM12 = (FLOAT)  sin (radianes);
       xform2.eM21 = (FLOAT) -sin (radianes);
       xform2.eM22 = (FLOAT)  cos (radianes);
       xform2.eDx  = (FLOAT)  0.0;
       xform2.eDy  = (FLOAT)  0.0;


       if (Angle <= 90.0)
       {  xform2.eDx  = (FLOAT)  -x3;
          xform2.eDy  = (FLOAT)  0.0;

          Width  = (LONG)dABS((x3-x1));

          Height = (LONG)dABS(y2);
       }

       if ((Angle > 90.0) && (Angle <= 180.0))
       {  xform2.eDx  = (FLOAT)  -x2;
          xform2.eDy  = (FLOAT)  -y3;

          Width  = (LONG)dABS(x2);

          Height = (LONG)dABS((y3-y1));
       }

       if ((Angle > 180.0) && (Angle <= 270.0))
       {  xform2.eDx  = (FLOAT)  -x1;
          xform2.eDy  = (FLOAT)  -y2;

          Width  = (LONG)dABS((x3-x1));

          Height = (LONG)dABS(y2);
       }

       if ((Angle > 270.0) && (Angle <= 360.0))
       {  xform2.eDx  = (FLOAT)  0.0;
          xform2.eDy  = (FLOAT)  -y1;

          Width  = (LONG)dABS(x2);

          Height = (LONG)dABS((y3-y1));
       }

       Width++;
       Height++;

       if ((Angle == 0.0) || (Angle == 180.0) ||(Angle == 360.0))
       {    Width  = bm.bmWidth;
            Height = bm.bmHeight;
       }
       if ((Angle == 90.0) || (Angle == 270.0))
       {    Width  = bm.bmHeight;
            Height = bm.bmWidth;
       }

   }

   hBitmap_D = bt_bmp_create_24bpp (Width, Height);
   SelectObject(memDC2, hBitmap_D);

   //SetStretchBltMode (memDC2, COLORONCOLOR);
   GetBrushOrgEx (memDC2, &Point);
   SetStretchBltMode (memDC2, HALFTONE);
   SetBrushOrgEx (memDC2, Point.x, Point.y, NULL);

   hBrush = CreateSolidBrush (Color_Fill_Bk);
   SelectObject(memDC2, hBrush);
   SetRect  (&rectang, 0, 0, Width, Height);
   FillRect (memDC2, &rectang, hBrush);

   CombineTransform (&xform_D, &xform1, &xform2);
   SetWorldTransform(memDC2, &xform_D);

   StretchBlt(memDC2, 0, 0, bm.bmWidth, bm.bmHeight, memDC1, 0, 0, bm.bmWidth, bm.bmHeight, SRCCOPY);

   DeleteDC (memDC1);
   DeleteDC (memDC2);
   DeleteObject(hBrush);

   HMG_retnl ((LONG_PTR) hBitmap_D);
}



//************************************************************************************************************
//* BT_BMP_CLIPBOARD_ISEMPTY () ---> Return TRUE (Empty clipboard: DIB format) or FALSE (Not empty clipboard)
//************************************************************************************************************

HB_FUNC (BT_BMP_CLIPBOARD_ISEMPTY)
{
   if (IsClipboardFormatAvailable (CF_DIB))
      hb_retl (FALSE);   // Not empty clipboard
   else
      hb_retl (TRUE);    // Empty clipboard
}



//************************************************************************************************************
//* BT_BMP_CLEAN_CLIPBOARD () ---> Return Success (TRUE or FALSE)
//************************************************************************************************************

HB_FUNC (BT_BMP_CLEAN_CLIPBOARD)
{
   HWND hWnd;
   if (!IsClipboardFormatAvailable (CF_DIB))
   {    hb_retl (FALSE);
        return;
   }

   hWnd = (HWND) HMG_parnl (1);
   if (!OpenClipboard (hWnd))
   {    hb_retl (FALSE);
        return;
   }

   EmptyClipboard();
   CloseClipboard();
   hb_retl (TRUE);
}



//*************************************************************************************************
//* BT_BMP_GET_CLIPBOARD (hWnd) ---> Return hBitmap (Success) or 0 (Failure or Clipboard Empty DIB format)
//*************************************************************************************************

HB_FUNC (BT_BMP_GET_CLIPBOARD)
{
   HWND hWnd;
   HGLOBAL hClipboard;
   HDC memDC;
   HBITMAP hBitmap;
   BITMAPINFO BI;
   LPBITMAPINFO lp_BI ;
   LPBYTE lp_Bits, lp_Bits2, lp_Clipboard;
   WORD nBytes_Offset;

   if (!IsClipboardFormatAvailable(CF_DIB))
   {    hb_retnl (0);
        return;
   }

   hWnd = (HWND) HMG_parnl (1);
   if (!OpenClipboard (hWnd))
   {   hb_retnl (0);
       return;
   }

   hClipboard = GetClipboardData(CF_DIB);
   if (hClipboard == NULL)
   {   CloseClipboard();
       hb_retnl (0);
       return;
   }


   lp_Clipboard = (LPBYTE) GlobalLock(hClipboard);

   lp_BI        = (LPBITMAPINFO) lp_Clipboard;

   nBytes_Offset = 0;
   if (lp_BI->bmiHeader.biBitCount == 1) nBytes_Offset = sizeof (RGBQUAD) * 2;
   if (lp_BI->bmiHeader.biBitCount == 4) nBytes_Offset = sizeof (RGBQUAD) * 16;
   if (lp_BI->bmiHeader.biBitCount == 8) nBytes_Offset = sizeof (RGBQUAD) * 256;

   lp_Bits = (LPBYTE) (lp_Clipboard + (sizeof (BITMAPINFOHEADER) + nBytes_Offset));

   BI.bmiHeader.biSize          = sizeof(BITMAPINFOHEADER);
   BI.bmiHeader.biWidth         = lp_BI->bmiHeader.biWidth;
   BI.bmiHeader.biHeight        = lp_BI->bmiHeader.biHeight;
   BI.bmiHeader.biPlanes        = 1;
   BI.bmiHeader.biBitCount      = 24;
   BI.bmiHeader.biCompression   = BI_RGB;
   BI.bmiHeader.biSizeImage     = 0;
   BI.bmiHeader.biXPelsPerMeter = 0;
   BI.bmiHeader.biYPelsPerMeter = 0;
   BI.bmiHeader.biClrUsed       = 0;
   BI.bmiHeader.biClrImportant  = 0;

   memDC = CreateCompatibleDC(NULL);

      hBitmap = CreateDIBSection (memDC, &BI, DIB_RGB_COLORS, (VOID **) &lp_Bits2, NULL, 0);
      SetDIBits(memDC, hBitmap, 0, BI.bmiHeader.biHeight, lp_Bits, lp_BI, DIB_RGB_COLORS);

   DeleteDC(memDC);

   GlobalUnlock(hClipboard) ;
   CloseClipboard() ;

   HMG_retnl ((LONG_PTR) hBitmap);
}



//*************************************************************************************************
//* BT_BMP_PUT_CLIPBOARD (hBitmap) ---> Return Success (TRUE or FALSE)
//*************************************************************************************************

HB_FUNC (BT_BMP_PUT_CLIPBOARD)
{
   HWND hWnd;
   HGLOBAL hClipboard;
   HDC memDC;
   HBITMAP hBitmap;
   BITMAPINFO BI;
   BITMAP bm;
   DWORD nBytes_Bits, nBytes_Total;
   LPBYTE lp_Clipboard;

   hWnd    = (HWND)    HMG_parnl (1);
   hBitmap = (HBITMAP) HMG_parnl (2);


   GetObject(hBitmap, sizeof(BITMAP), (LPBYTE)&bm);

   BI.bmiHeader.biSize          = sizeof(BITMAPINFOHEADER);
   BI.bmiHeader.biWidth         = bm.bmWidth;
   BI.bmiHeader.biHeight        = bm.bmHeight;
   BI.bmiHeader.biPlanes        = 1;
   BI.bmiHeader.biBitCount      = 24;
   BI.bmiHeader.biCompression   = BI_RGB;
   BI.bmiHeader.biSizeImage     = 0;
   BI.bmiHeader.biXPelsPerMeter = 0;
   BI.bmiHeader.biYPelsPerMeter = 0;
   BI.bmiHeader.biClrUsed       = 0;
   BI.bmiHeader.biClrImportant  = 0;

   bm.bmWidthBytes = (bm.bmWidth * BI.bmiHeader.biBitCount + 31) / 32 * 4;

   nBytes_Bits  = (DWORD)(bm.bmWidthBytes * labs(bm.bmHeight));
   nBytes_Total = sizeof(BITMAPINFOHEADER) + nBytes_Bits;

   if (!OpenClipboard (hWnd))
   {
       hb_retl (FALSE);
       return;
   }


   hClipboard = GlobalAlloc (GHND, (DWORD) nBytes_Total);
   if (hClipboard == NULL)
   {   CloseClipboard();
       hb_retl (FALSE);
       return;
   }

   lp_Clipboard = GlobalLock (hClipboard);

   memcpy (lp_Clipboard, &BI.bmiHeader, sizeof(BITMAPINFOHEADER));

   memDC = CreateCompatibleDC(NULL);
   GetDIBits (memDC, hBitmap, 0, bm.bmHeight, (LPVOID) (lp_Clipboard + sizeof(BITMAPINFOHEADER)), &BI, DIB_RGB_COLORS);

   GlobalUnlock(hClipboard);

   EmptyClipboard();
   SetClipboardData (CF_DIB, hClipboard);
   CloseClipboard();

   DeleteDC(memDC);

   hb_retl (TRUE);
}





// ::::::::::::::::::::::::::::::::::::
// :::   MISCELLANEOUS Functions    :::
// ::::::::::::::::::::::::::::::::::::





//******************************************
//* BT_DELAY_EXECUTION (nMilliSeconds)
//******************************************

HB_FUNC (BT_DELAY_EXECUTION)
{
   clock_t inicio = clock ();
   clock_t ciclos = (clock_t) hb_parnl (1);

   while (clock () - inicio <= ciclos);
}



//*********************************************************
//* BT_DELAY_EXECUTION_WITH_DOEVENTS (nMilliSeconds)
//*********************************************************
HB_FUNC (BT_DELAY_EXECUTION_WITH_DOEVENTS)
{
   MSG Msg;
   clock_t inicio = clock ();
   clock_t ciclos = (clock_t) hb_parnl (1);

   while (clock () - inicio <= ciclos)
   {     if (PeekMessage((LPMSG) &Msg, 0, 0, 0, PM_REMOVE))
         {
            TranslateMessage (&Msg);
            DispatchMessage  (&Msg);
         }
   }
}



//*****************************************************
//* BT_SCR_SHOWCURSOR (lOnOff) ---> Show/Hide Cursor
//*****************************************************
HB_FUNC (BT_SCR_SHOWCURSOR)
{
   hb_retni (ShowCursor (hb_parl(1)));
}



//***************************************************************************
//* BT_STRETCH_RECT (@Width1, @Height1, @Width2, @Height2, Mode_Stretch)
//***************************************************************************

HB_FUNC (BT_STRETCH_RECT)
{
   INT Width1, Height1;
   INT Width2, Height2;
   INT Mode_Stretch;

   Width1        = (INT) hb_parni (1);
   Height1       = (INT) hb_parni (2);
   Width2        = (INT) hb_parni (3);
   Height2       = (INT) hb_parni (4);
   Mode_Stretch  = (INT) hb_parnl (5);

   if (HB_ISBYREF(1) && HB_ISBYREF(2) && HB_ISBYREF(3) && HB_ISBYREF(4))
   {
      bt_bmp_adjust_rect (&Width1, &Height1, &Width2, &Height2, Mode_Stretch);
      hb_storni (Width1,  1);
      hb_storni (Height1, 2);
      hb_storni (Width2,  3);
      hb_storni (Height2, 4);
      hb_retl (TRUE);
   }
   else
      hb_retl (FALSE);
}


//*******************************************************************************************************
//* BT_TEXTOUT_SIZE (hWnd, Text, FontName, FontSize, Type) --> { nW , nH }
//*******************************************************************************************************

/*
// Type
#define BT_TEXT_BOLD        2
#define BT_TEXT_ITALIC      4
#define BT_TEXT_UNDERLINE   8
#define BT_TEXT_STRIKEOUT   16
*/

HB_FUNC (BT_TEXTOUT_SIZE)
{
   HDC  hDC;
   HFONT hFont;
   SIZE SizeText;
   HWND hWnd;
   TCHAR *Text, *FontName;
   INT FontSize;
   INT Type;

   INT Bold = FW_NORMAL;
   INT Italic = 0, Underline = 0, StrikeOut = 0;

   hWnd        = (HWND)     HMG_parnl (1);
   Text        = (TCHAR *)  HMG_parc  (2);
   FontName    = (TCHAR *)  HMG_parc  (3);
   FontSize    = (INT)      hb_parni  (4);
   Type        = (INT)      hb_parni  (5);

   hDC = GetDC (hWnd);

   if ((Type & BT_TEXT_BOLD) == BT_TEXT_BOLD)
       Bold = FW_BOLD;

   if ((Type & BT_TEXT_ITALIC) == BT_TEXT_ITALIC)
       Italic = 1;

   if ((Type & BT_TEXT_UNDERLINE) == BT_TEXT_UNDERLINE)
       Underline = 1;

   if ((Type & BT_TEXT_STRIKEOUT) == BT_TEXT_STRIKEOUT)
       StrikeOut = 1;

   FontSize = FontSize * GetDeviceCaps (hDC, LOGPIXELSY) / 72;   // Size of font in logic points

   hFont = CreateFont (0-FontSize, 0, 0, 0, Bold, Italic, Underline, StrikeOut,
           DEFAULT_CHARSET, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH | FF_DONTCARE, FontName);

   SelectObject (hDC, hFont);

/*
   When GetTextExtentPoint32() returns the text extent, it assumes that the text is HORIZONTAL,
   that is, that the ESCAPEMENT is always 0. This is true for both the horizontal and
   vertical measurements of the text. Even if you use a font that specifies a nonzero
   escapement, this function doesn't use the angle while it computes the text extent.
   The app must convert it explicitly.
*/

   GetTextExtentPoint32 (hDC, Text, lstrlen(Text), &SizeText);
   hb_reta (2);
   hb_storvnl ((LONG) SizeText.cx, -1, 1);
   hb_storvnl ((LONG) SizeText.cy, -1, 2);

   ReleaseDC (hWnd, hDC);
   DeleteObject (hFont);
}




/************************************************************************************************/



const double pi = 3.14159265358979323846;

//        BT_MathPI ()
HB_FUNC ( BT_MATHPI )
{
   hb_retnd ((double) pi);
}


//        BT_MathSIN ( AngleInDegrees )
HB_FUNC ( BT_MATHSIN )
{
   double AngleDegrees = (double) hb_parnd (1);
   double AngleRadians = (2*pi) * AngleDegrees / (double)360.0;
   hb_retnd ((double) sin (AngleRadians));
}


//        BT_MathCOS ( AngleInDegrees )
HB_FUNC ( BT_MATHCOS )
{
   double AngleDegrees = (double) hb_parnd (1);
   double AngleRadians = (2*pi) * AngleDegrees / (double)360.0;
   hb_retnd ((double) cos (AngleRadians));
}


//        BT_MathTAN ( AngleInDegrees )
HB_FUNC ( BT_MATHTAN )
{
   double AngleDegrees = (double) hb_parnd (1);
   double AngleRadians = (2*pi) * AngleDegrees / (double)360.0;
   hb_retnd ((double) tan (AngleRadians));
}


//        BT_MathCircumferenceY ( Radius, AngleInDegrees ) --> nRow
HB_FUNC ( BT_MATHCIRCUMFERENCEY )
{
   double Radius       = (double) hb_parnd (1);
   double AngleDegrees = (double) hb_parnd (2);
   double AngleRadians = (2*pi) * AngleDegrees / (double)360.0;
   double y = sin (AngleRadians) * Radius;
   hb_retnd ((double) y);
}


//        BT_MathCircumferenceX ( Radius, AngleInDegrees ) --> nCol
HB_FUNC ( BT_MATHCIRCUMFERENCEX )
{
   double Radius       = (double) hb_parnd (1);
   double AngleDegrees = (double) hb_parnd (2);
   double AngleRadians = (2*pi) * AngleDegrees / (double)360.0;
   double x = cos (AngleRadians) * Radius;
   hb_retnd ((double) x);
}


//        BT_MathCircumferenceArcAngle ( Radius, Arc ) --> AngleInDegrees
HB_FUNC ( BT_MATHCIRCUMFERENCEARCANGLE )
{
   double Radius = (double) hb_parnd (1);
   double Arc    = (double) hb_parnd (2);
   double Longitude    = (2*pi) * Radius;
   double AngleDegrees = Arc * (double)360.0 / Longitude;
   hb_retnd ((double) AngleDegrees);
}


//        BT_SelectObject (hDC, hGDIobj)
HB_FUNC ( BT_SELECTOBJECT )
{
   HDC hDC         = (HDC)     HMG_parnl (1);
   HGDIOBJ hGDIobj = (HGDIOBJ) HMG_parnl (2);
   HGDIOBJ hGDIobjOld = SelectObject (hDC, hGDIobj);
   HMG_retnl ((LONG_PTR) hGDIobjOld );
}


//        BT_DeleteObject (hGDIobj)
HB_FUNC ( BT_DELETEOBJECT )
{
   HGDIOBJ hGDIobj = (HGDIOBJ) HMG_parnl (1);
   hb_retl ((BOOL) DeleteObject (hGDIobj));
}


//        BT_RegionCreateElliptic (nCol1, nRow1, nCol2, nRow2)
HB_FUNC ( BT_REGIONCREATEELLIPTIC )
{
   HRGN hRgn = CreateEllipticRgn ( hb_parni(1), hb_parni(2), hb_parni(3), hb_parni(4) );
   HMG_retnl ((LONG_PTR) hRgn );
}


//        BT_RegionCombine ( @hRgnDest, hRgnSrc1, hRgnSrc2, nCombineMode ) --> nResult
HB_FUNC ( BT_REGIONCOMBINE )
{
   HRGN hRgnSrc1     = (HRGN) HMG_parnl (2);
   HRGN hRgnSrc2     = (HRGN) HMG_parnl (3);
   INT  nCombineMode = (INT)  hb_parni  (4);
   if ( HB_ISBYREF (1) )
   {  HRGN hRgnDest = CreateRectRgn (0, 0, 0, 0);   // This region must exist before CombineRgn() is called
      INT ret = CombineRgn (hRgnDest, hRgnSrc1, hRgnSrc2, nCombineMode);
      if (ret == ERROR)
         DeleteObject (hRgnDest);
      else
         HMG_stornl ((LONG_PTR) hRgnDest, 1);
      hb_retni ((INT) ret);
   }
   else
      hb_retni ((INT) ERROR);
}


//        BT_RegionFrame (hDC, hRgn, aColor, nWidth, nHeight)
HB_FUNC ( BT_REGIONFRAME )
{
   HDC hDC   = (HDC)  HMG_parnl (1);
   HRGN hRgn = (HRGN) HMG_parnl (2);
   HBRUSH hBrush = CreateSolidBrush (RGB (hb_parvni(3,1), hb_parvni(3,2), hb_parvni(3,3)) );
   INT nWidth  = (INT) hb_parni (4);
   INT nHeight = (INT) hb_parni (5);
   hb_retl ((BOOL) FrameRgn (hDC, hRgn, hBrush, nWidth, nHeight));
}



/************************************************************************************************/



HMG_DEFINE_DLL_FUNC ( win_Shell_GetImageLists,                            // user function name
                      "Shell32.dll",                                      // dll name
                      BOOL,                                               // function return type
                      WINAPI,                                             // function type
                      "Shell_GetImageLists",                              // dll function name
                      (HIMAGELIST *phimlLarge, HIMAGELIST *phimlSmall),   // dll function parameters (types and names)
                      (phimlLarge, phimlSmall),                           // function parameters (only names)
                      FALSE                                               // return value if fail call function of dll
                    )


//        BT_ImageListGetSystemIcon ( [ lLargeIcon ] ) --> hImageList ( You NEVER add, remove or delete icons from the System Imagelist )
HB_FUNC ( BT_IMAGELISTGETSYSTEMICON )
{
   BOOL lLargeIcon = (BOOL) hb_parl (1);
   HIMAGELIST himlLarge = NULL;
   HIMAGELIST himlSmall = NULL;
   win_Shell_GetImageLists (&himlLarge, &himlSmall);
   if ( lLargeIcon )
      HMG_retnl ((LONG_PTR) himlLarge);
   else
      HMG_retnl ((LONG_PTR) himlSmall);
}


//       BT_ImageListExtractIcon
HB_FUNC (BT_IMAGELISTEXTRACTICON)
{
   HIMAGELIST himl = (HIMAGELIST) HMG_parnl (1);
   INT      nIndex = (INT)        hb_parni  (2);
   HICON hIcon = ImageList_ExtractIcon (0, himl, nIndex);
   HMG_retnl ((LONG_PTR) hIcon);
}


#ifdef UNICODE
HMG_DEFINE_DLL_FUNC ( win_StrRetToBuf,
                      "Shlwapi.dll",
                      HRESULT,
                      WINAPI,
                      "StrRetToBufW",
                      (STRRET *pstr, LPCITEMIDLIST pidl, LPTSTR pszBuf, UINT cchBuf),
                      (pstr, pidl, pszBuf, cchBuf),
                       -1
                     )
#else
HMG_DEFINE_DLL_FUNC ( win_StrRetToBuf,
                      "Shlwapi.dll",
                      HRESULT,
                      WINAPI,
                      "StrRetToBufA",
                      (STRRET *pstr, LPCITEMIDLIST pidl, LPTSTR pszBuf, UINT cchBuf),
                      (pstr, pidl, pszBuf, cchBuf),
                       -1
                     )
#endif


TCHAR * bt_LocalDateTimeToDateTimeANSI (TCHAR *cLocalDateTime)
{
   int i;
   TCHAR cDateFormat [80];
   TCHAR Year [12], Month [12], Day [12], Time [24];
   TCHAR *p2 = cLocalDateTime;
   GetLocaleInfo (LOCALE_USER_DEFAULT, LOCALE_SSHORTDATE, cDateFormat, sizeof(cDateFormat)/sizeof(TCHAR));
   TCHAR *p = cDateFormat;

   ZeroMemory (Year,  sizeof(Year));
   ZeroMemory (Month, sizeof(Month));
   ZeroMemory (Day,   sizeof(Day));

   while ( *p != 0 )
   {
      if ((*p == _TEXT('y') || *p == _TEXT('Y')) && (Year [0] == 0))
      {  i = 0;
         while (_istdigit (*p2))
            Year [i++] = *p2++;
         while (! _istdigit (*p2))
            p2++;
      }
      if ((*p == _TEXT('m') || *p == _TEXT('M')) && (Month [0] == 0))
      {  i = 0;
         while (_istdigit (*p2))
            Month [i++] = *p2++;
         while (! _istdigit (*p2))
            p2++;
      }
      if ((*p == _TEXT('d') || *p == _TEXT('D')) && (Day [0] == 0))
      {  i = 0;
         while (_istdigit (*p2))
            Day [i++] = *p2++;
         while (! _istdigit (*p2))
            p2++;
      }
      p++;
   }
   if (lstrlen(Month) == 1)
   {   Month [1] = Month [0];
       Month [0] = _TEXT('0');
   }
   if (lstrlen(Day) == 1)
   {   Day [1] = Day [0];
       Day [0] = _TEXT('0');
   }
   lstrcpy (Time, p2);
   wsprintf (cLocalDateTime, _TEXT("%s/%s/%s  %s"), Year, Month, Day, Time);
   return cLocalDateTime;
}


TCHAR * bt_SpaceToBlank (TCHAR *cStr)
{  TCHAR *p = cStr;
   while ( *p != 0 )
   {  if ( _istspace (*p) )   // space character (0x09 – 0x0D or 0x20)
         *p = _TEXT(' ');
      p++;
   }
   return cStr;
}


#define BT_DIRECTORYINFO_NAME                      1
#define BT_DIRECTORYINFO_DATE                      2
#define BT_DIRECTORYINFO_TYPE                      3
#define BT_DIRECTORYINFO_SIZE                      4
#define BT_DIRECTORYINFO_FULLNAME                  5
#define BT_DIRECTORYINFO_INTERNALDATA_TYPE         6
#define BT_DIRECTORYINFO_INTERNALDATA_DATE         7
#define BT_DIRECTORYINFO_INTERNALDATA_IMAGEINDEX   8

#define BT_DIRECTORYINFO_INTERNALDATA_FOLDER         "D-"
#define BT_DIRECTORYINFO_INTERNALDATA_HASSUBFOLDER   "D+"
#define BT_DIRECTORYINFO_INTERNALDATA_NOFOLDER       "F"

#define BT_DIRECTORYINFO_INFOROOT       -1
#define BT_DIRECTORYINFO_LISTALL         0
#define BT_DIRECTORYINFO_LISTFOLDER      1
#define BT_DIRECTORYINFO_LISTNONFOLDER   2


#ifndef SFGAO_STREAM
   #define SFGAO_STREAM   0x00400000
#endif

//        BT_DirectoryInfo ( [nCSIDL | cPath] , [nTypeList] , @nIndexRoot, @CSIDL_Name ) --> { { Data1, Data2, Data3, ... } , ... }
HB_FUNC ( BT_DIRECTORYINFO )
{
   LPITEMIDLIST  pidlFolders = NULL;
   LPITEMIDLIST  pidlItems = NULL;
   IShellFolder2 *psfFolders = NULL;
   IShellFolder  *psfDeskTop = NULL;
   LPENUMIDLIST ppenum = NULL;
   ULONG celtFetched, chEaten, uAttr;
   HRESULT hr;
   STRRET strDispName;
   DWORD nFlags;
   BOOL Found_Ok;
   TCHAR cDisplayData  [MAX_PATH];
   TCHAR cFullPath     [MAX_PATH];
   TCHAR cDateTime     [80];
   TCHAR cInternalType [33];
   SHELLDETAILS psd;
   SHFILEINFO psfi;
   int nCSIDL = -1;

   CoInitialize (NULL);

   hr = SHGetDesktopFolder (&psfDeskTop);

   if ( HB_ISCHAR (1) )
   {   TCHAR *cPath = (TCHAR*) HMG_parc (1);
       hr = IShellFolder2_ParseDisplayName (psfDeskTop, NULL, NULL, HMG_ToUnicode(cPath), &chEaten, &pidlFolders, NULL);
   }
   else
   {   nCSIDL = HB_ISNUM (1) ? hb_parni (1) : CSIDL_DRIVES;
       hr = SHGetFolderLocation (NULL, nCSIDL, NULL, 0, &pidlFolders);
       if ( HB_ISBYREF (4) )
       {   TCHAR cParsingName [ MAX_PATH ] = {0};
           IShellFolder2_GetDisplayNameOf (psfDeskTop, pidlFolders, SHGDN_INFOLDER, &strDispName);
           win_StrRetToBuf(&strDispName, pidlItems, cParsingName, MAX_PATH);
           HMG_storc (cParsingName, 4);
        }
   }

   if (hr != S_OK)
     return;


   if ( HB_ISBYREF (3) )
   {
      SHGetFileInfo ((LPCTSTR) pidlFolders, 0, &psfi, sizeof (SHFILEINFO), SHGFI_PIDL | SHGFI_SYSICONINDEX );
      hb_storni ( psfi.iIcon , 3 );
   }

   switch ( hb_parni (2) )
   {
      case BT_DIRECTORYINFO_LISTFOLDER:     nFlags = SHCONTF_FOLDERS;    break;
      case BT_DIRECTORYINFO_LISTNONFOLDER:  nFlags = SHCONTF_NONFOLDERS; break;
      default: nFlags = SHCONTF_FOLDERS | SHCONTF_NONFOLDERS;
   }

   hr = IShellFolder2_BindToObject (psfDeskTop, pidlFolders, NULL, &IID_IShellFolder2, (LPVOID *) &psfFolders);

   if (hr != S_OK || hb_parni (2) == BT_DIRECTORYINFO_INFOROOT)
   {
      if (pidlFolders)
         CoTaskMemFree (pidlFolders);
      IShellFolder2_Release (psfDeskTop);
      return;
   }

   hr = IShellFolder2_Release (psfDeskTop);

   hr = IShellFolder2_EnumObjects (psfFolders, NULL, nFlags, &ppenum);
   if (hr != S_OK)
       return;

   PHB_ITEM pArray = hb_itemArrayNew (0);
   PHB_ITEM pSubarray = hb_itemNew (NULL);

   while ((hr = IEnumIDList_Next (ppenum, 1, &pidlItems, &celtFetched) == S_OK) && (celtFetched == 1))
   {
      Found_Ok = FALSE;

      uAttr = SFGAO_FOLDER | SFGAO_STREAM | SFGAO_ISSLOW;
      hr = IShellFolder2_GetAttributesOf (psfFolders, 1, (LPCITEMIDLIST *) &pidlItems, &uAttr);

      if ((nFlags & SHCONTF_FOLDERS) && (uAttr & SFGAO_FOLDER) && !(uAttr & SFGAO_STREAM) && !(uAttr & SFGAO_ISSLOW))
      {
         uAttr = SFGAO_HASSUBFOLDER;
         IShellFolder2_GetAttributesOf (psfFolders, 1, (LPCITEMIDLIST *) &pidlItems, &uAttr);
         if (uAttr & SFGAO_HASSUBFOLDER)
            lstrcpy (cInternalType, _TEXT(BT_DIRECTORYINFO_INTERNALDATA_HASSUBFOLDER));   // Folder with Sub-Folder
         else
            lstrcpy (cInternalType, _TEXT(BT_DIRECTORYINFO_INTERNALDATA_FOLDER));   // Folder without Sub-Folder
         Found_Ok = TRUE;
      }
      else if (nFlags & SHCONTF_NONFOLDERS)
      {
         lstrcpy (cInternalType, _TEXT(BT_DIRECTORYINFO_INTERNALDATA_NOFOLDER));   // File
         Found_Ok = TRUE;
      }

      if ( Found_Ok )
      {
         hb_arrayNew   ( pSubarray, 8 );

         IShellFolder2_GetDetailsOf (psfFolders, pidlItems, 0, &psd);   // Name
         win_StrRetToBuf(&psd.str, pidlItems, cDisplayData, MAX_PATH);
         hb_arraySetC  ( pSubarray, BT_DIRECTORYINFO_NAME, HMG_WCHAR_TO_CHAR (cDisplayData) );

         IShellFolder2_GetDetailsOf (psfFolders, pidlItems, 3, &psd);   // Date
         win_StrRetToBuf(&psd.str, pidlItems, cDisplayData, MAX_PATH);
         hb_arraySetC  ( pSubarray, BT_DIRECTORYINFO_DATE, HMG_WCHAR_TO_CHAR (bt_SpaceToBlank(cDisplayData)) );
         lstrcpy (cDateTime, cDisplayData);

         IShellFolder2_GetDetailsOf (psfFolders, pidlItems, 2, &psd);   // Type
         win_StrRetToBuf(&psd.str, pidlItems, cDisplayData, MAX_PATH);
         hb_arraySetC  ( pSubarray, BT_DIRECTORYINFO_TYPE, HMG_WCHAR_TO_CHAR (bt_SpaceToBlank(cDisplayData)) );

         IShellFolder2_GetDetailsOf (psfFolders, pidlItems, 1, &psd);   // Size
         win_StrRetToBuf(&psd.str, pidlItems, cDisplayData, MAX_PATH);
         hb_arraySetC  ( pSubarray, BT_DIRECTORYINFO_SIZE, HMG_WCHAR_TO_CHAR (bt_SpaceToBlank(cDisplayData)) );

         IShellFolder2_GetDisplayNameOf (psfFolders, pidlItems, SHGDN_FORPARSING, &strDispName);   // FullName
         win_StrRetToBuf(&strDispName, pidlItems, cFullPath, MAX_PATH);
         hb_arraySetC  ( pSubarray, BT_DIRECTORYINFO_FULLNAME, HMG_WCHAR_TO_CHAR (cFullPath) );

         hb_arraySetC  ( pSubarray, BT_DIRECTORYINFO_INTERNALDATA_TYPE, HMG_WCHAR_TO_CHAR (cInternalType) );   //   D+ | D- | F

         bt_LocalDateTimeToDateTimeANSI (cDateTime);
         hb_arraySetC  ( pSubarray, BT_DIRECTORYINFO_INTERNALDATA_DATE, HMG_WCHAR_TO_CHAR (cDateTime) );   // YYYY:MM:DD  HH:MM:SS

         SHGetFileInfo ((LPCTSTR) cFullPath, 0, &psfi, sizeof (SHFILEINFO), SHGFI_SYSICONINDEX );
         hb_arraySetNI  ( pSubarray, BT_DIRECTORYINFO_INTERNALDATA_IMAGEINDEX, (INT) psfi.iIcon );   // nImageIndex

         hb_arrayAddForward ( pArray, pSubarray );

      }
      CoTaskMemFree(pidlItems);

   }
   IEnumIDList_Release (ppenum);

   CoTaskMemFree (pidlFolders);
   IShellFolder2_Release (psfFolders);

   hb_itemReturnRelease (pArray);
   hb_itemRelease (pSubarray);
}



