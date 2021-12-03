/*----------------------------------------------------------------------------
 HMG Header File --> HMG_UNICODE.h

 Copyright 2012-2017 by Dr. Claudio Soto (from Uruguay).

 mail: <srvet@adinet.com.uy>
 blog: http://srvet.blogspot.com

 Permission to use, copy, modify, distribute and sell this software
 and its documentation for any purpose is hereby granted without fee,
 provided that the above copyright notice appear in all copies and
 that both that copyright notice and this permission notice appear
 in supporting documentation.
 It is provided "as is" without express or implied warranty.

 ----------------------------------------------------------------------------*/


/*****************************************************************************************
*   WINDOWS MACRO DEFINITION
******************************************************************************************/

#ifndef WINVER
   #define  WINVER        0x0501   // Win XP
#endif


#ifndef _WIN32_WINNT
   #define _WIN32_WINNT   WINVER  // ( XP = 0x0501 , Vista = 0x0600 )
#endif


#ifndef _WIN32_IE
   #define _WIN32_IE      0x0600   // Internet Explorer 6.0 (Win XP)
#endif



/*****************************************************************************************
*   HMG INTERNAL MACRO DEFINITION
******************************************************************************************/

#define HMG_MBtoWC(c)   ((c != NULL) ? hb_mbtowc(c) : NULL)  // MultiByteToWideChar( CHAR  ) --> return WCHAR
#define HMG_WCtoMB(c)   ((c != NULL) ? hb_wctomb(c) : NULL)  // WideCharToMultiByte( WCHAR ) --> return CHAR

#define HMG_INTNIL  (INT)(0xEFFFFFFF)



/*****************************************************************************************
*   ANSI/UNICODE MACRO DEFINITION
******************************************************************************************/

#if defined ( COMPILE_HMG_UNICODE ) || defined ( UNICODE ) || defined ( _UNICODE )

   #ifndef COMPILE_HMG_UNICODE
      #define COMPILE_HMG_UNICODE
   #endif

   #ifndef UNICODE
      #define UNICODE
   #endif

   #ifndef _UNICODE
      #define _UNICODE
   #endif

   #include <tchar.h>
   #include <wchar.h>
// #include "hbapi.h"

   #define HMG_CHAR_TO_WCHAR(c)     ((c != NULL) ? hb_osStrU16Encode(c) : NULL)  // return WCHAR
      #define HMG_parc(n)            HMG_CHAR_TO_WCHAR (hb_parc(n))
      #define HMG_parvc(n,i)         HMG_CHAR_TO_WCHAR (hb_parvc(n,i))
      #define HMG_arrayGetCPtr(a,n)  HMG_CHAR_TO_WCHAR (hb_arrayGetCPtr(a,n))

   #define HMG_WCHAR_TO_CHAR(c)      hb_osStrU16Decode(c)                       // return CHAR
      #define HMG_retc(c)            hb_retc    (HMG_WCHAR_TO_CHAR(c))
      #define HMG_storc(c,i)         hb_storc   (HMG_WCHAR_TO_CHAR(c),i)
      #define HMG_storvc(c,l,n)      hb_storvc  (HMG_WCHAR_TO_CHAR(c),l,n)
      #define HMG_retclen(c,l)       hb_retclen (HMG_WCHAR_TO_CHAR(c),l)
      #define HMG_retc_buffer(c)     hb_retc_buffer (HMG_WCHAR_TO_CHAR(c))

      #define HMG_itemPutC(p, c)            hb_itemPutC      (p, HMG_WCHAR_TO_CHAR(c))
      #define HMG_itemPutCL(p, c, l)        hb_itemPutCL     (p, HMG_WCHAR_TO_CHAR(c), l)
      #define HMG_itemPutCConst(p, c)       hb_itemPutCConst (p, HMG_WCHAR_TO_CHAR(c))
      #define HMG_itemPutCLConst(p, c, l)   hb_itemPutCLConst(p, HMG_WCHAR_TO_CHAR(c), l)
      #define HMG_itemPutCPtr(p, c)         hb_itemPutCPtr   (p, HMG_WCHAR_TO_CHAR(c))
      #define HMG_itemPutCLPtr(p, c, l)     hb_itemPutCLPtr  (p, HMG_WCHAR_TO_CHAR(c), l)

   #define _HMG_SupportUnicode_      1  // Set TRUE

   #define HMG_ToUnicode(c) (c)
   #define HMG_ToAnsi(c)    HMG_WCtoMB(c)
   #define HMG_IsAnsi_UnicodeToAnsi(c) (c)

#else

   #include <tchar.h>
   #include <wchar.h>
// #include "hbapi.h"

   #define HMG_CHAR_TO_WCHAR(c)     (c)
      #define HMG_parc(n)            hb_parc (n)
      #define HMG_parvc(n,i)         hb_parvc (n,i)
      #define HMG_arrayGetCPtr(a,n)  hb_arrayGetCPtr (a,n)

   #define HMG_WCHAR_TO_CHAR(c)     (c)
      #define HMG_retc(c)            hb_retc (c)
      #define HMG_storc(c,i)         hb_storc (c,i)
      #define HMG_storvc(c,l,n)      hb_storvc (c,l,n)
      #define HMG_retclen(c,l)       hb_retclen (c,l)
      #define HMG_retc_buffer(c)     hb_retc_buffer (c)

      #define HMG_itemPutC(p, c)            hb_itemPutC      (p, c)
      #define HMG_itemPutCL(p, c, l)        hb_itemPutCL     (p, c, l)
      #define HMG_itemPutCConst(p, c)       hb_itemPutCConst (p, c)
      #define HMG_itemPutCLConst(p, c, l)   hb_itemPutCLConst(p, c, l)
      #define HMG_itemPutCPtr(p, c)         hb_itemPutCPtr   (p, c)
      #define HMG_itemPutCLPtr(p, c, l)     hb_itemPutCLPtr  (p, c, l)

   #define _HMG_SupportUnicode_      0  // Set FALSE

   #define HMG_ToUnicode(c) HMG_MBtoWC(c)
   #define HMG_ToAnsi(c)    (c)
   #define HMG_IsAnsi_UnicodeToAnsi(c) HMG_WCtoMB(c)
#endif



/*****************************************************************************************
*   32-64 BITS MACRO DEFINITION
******************************************************************************************/

//   __int64      = 64-bit signed integer
// INT and LONG   = 32-bit signed integer

#if defined ( _WIN64 )

   // INT_PTR   --> __int64
   // LONG_PTR  --> __int64
   // UINT_PTR  --> unsigned __int64
   // ULONG_PTR --> unsigned __int64

   #define _HMG_Win64_       1   // Set TRUE

   #define HMG_parnl         hb_parnll
   #define HMG_parvnl        hb_parvnll
   #define HMG_retnl         hb_retnll
   #define HMG_retnllen      hb_retnlllen
   #define HMG_stornl        hb_stornll
   #define HMG_storvnl       hb_storvnll
   #define HMG_arraySetNL    hb_arraySetNLL
   #define HMG_arrayGetNL    hb_arrayGetNLL


#else

   // INT_PTR   --> int
   // LONG_PTR  --> long
   // UINT_PTR  --> unsigned int
   // ULONG_PTR --> unsigned long

   #define _HMG_Win64_       0   // Set FALSE

   #define HMG_parnl         hb_parnl
   #define HMG_parvnl        hb_parvnl
   #define HMG_retnl         hb_retnl
   #define HMG_retnllen      hb_retnllen
   #define HMG_stornl        hb_stornl
   #define HMG_storvnl       hb_storvnl
   #define HMG_arraySetNL    hb_arraySetNL
   #define HMG_arrayGetNL    hb_arrayGetNL

#endif


// WPARAM   --> UINT_PTR
// LPARAM   --> LONG_PTR
// HANDLE   --> LONG_PTR
// LRESULT  --> LONG_PTR



/*****************************************************************************************
*   MACRO DEFINITION FOR THREAD
******************************************************************************************/


// Thread Local Storage ( inline  declaration, compiler extension )
//       __thread             --> GNU-C, CLANG and BORLAND-C
//       __declspec( thread ) --> MSVC, WATCOM-C and DMC
//#if 1
//   #define __TLS__   __thread   // add in hbmk2 command line  -ldflag=-ldflag="-static-libgcc  -static-libstdc++  -static -lpthread" ( for gcc.exe static link pthread library )
//   #define __with__TLS__
//#else
   #define __TLS__
//#endif


#if 1
   #define _THREAD_LOCK()     hb_threadEnterCriticalSection( &_HMG_Mutex )
   #define _THREAD_UNLOCK()   hb_threadLeaveCriticalSection( &_HMG_Mutex )
#else
   #define _THREAD_LOCK()
   #define _THREAD_UNLOCK()
#endif



/*****************************************************************************************
*   MACRO DEFINITION FOR CALL DLL FUNCTION
******************************************************************************************/

#define HMG_DEFINE_DLL_FUNC(\
                             _FUNC_NAME,             \
                             _DLL_LIBNAME,           \
                             _DLL_FUNC_RET,          \
                             _DLL_FUNC_TYPE,         \
                             _DLL_FUNC_NAMESTRINGAW, \
                             _DLL_FUNC_PARAM,        \
                             _DLL_FUNC_CALLPARAM,    \
                             _DLL_FUNC_RETFAILCALL   \
                            )\
\
_DLL_FUNC_RET _DLL_FUNC_TYPE _FUNC_NAME _DLL_FUNC_PARAM \
{\
_THREAD_LOCK();\
   typedef _DLL_FUNC_RET (_DLL_FUNC_TYPE *PFUNC) _DLL_FUNC_PARAM;\
   static PFUNC pfunc = NULL;\
   if (pfunc == NULL)\
   {\
      HMODULE hLib = LoadLibrary (_TEXT (_DLL_LIBNAME) );\
      pfunc = (PFUNC) GetProcAddress (hLib, _DLL_FUNC_NAMESTRINGAW);\
   }\
_THREAD_UNLOCK();\
   if(pfunc == NULL)\
      return ((_DLL_FUNC_RET) _DLL_FUNC_RETFAILCALL);\
   else\
      return pfunc _DLL_FUNC_CALLPARAM;\
}

/*
Example:

HMG_DEFINE_DLL_FUNC ( win_Shell_GetImageLists,                            // user function name
                      "Shell32.dll",                                      // dll name
                      BOOL,                                               // function return type
                      WINAPI,                                             // function type
                      "Shell_GetImageLists",                              // dll function name
                      (HIMAGELIST *phimlLarge, HIMAGELIST *phimlSmall),   // dll function parameters (types and names)
                      (phimlLarge, phimlSmall),                           // function parameters (only names)
                      FALSE                                               // return value if fail call function of dll
                    )


HB_FUNC ( BT_GETSYSTEMICONIMAGELIST )
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

*/


void HMG_Trace( const char * file, int line, const char * function, TCHAR * fmt, ... );

