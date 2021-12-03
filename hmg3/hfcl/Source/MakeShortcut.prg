#include "hmg.ch"

FUNCTION MakeFDirShortCut(;                  // Make a file or folder shortcut (.lnk file)
                           cTargetFileDir,;          // Full File or Folder name to be targeted   
                           cShortCutTitle,;          // Short-cut (.lnk File) Name  
                           cShortCutTTip,;           // Text to display when mouse over the short cut                         
                           cShortCutFolder,;         // Folder Name for short-cut (.lnk file ) Default is Desktop. 
                           cIcon,;                   // Icon for the shortcut
                           cShortCutWrkdir )         // Working Directory
                       
    LOCAL WshShell  := CreateObject("WScript.Shell"),;   
         cLnkFFNam := cShortCutTitle + ".lnk",;            // Shorcut ( .lnk file ) Full Name 
         lSuccess  := .F.,;
         FileShortcut
   
   HB_Default( @cShortCutTTip, "" )
   HB_Default( @cShortCutFolder, GetDeskTopFolder() )
   HB_Default( @cShortCutWrkdir, cShortCutFolder )
   HB_Default( @cIcon, "" )
   
   cLnkFFNam := cShortCutFolder + IF( HB_URIGHT( cShortCutFolder, 1 ) # "\", "\", "" ) + cLnkFFNam
 
   IF HB_FileExists( cTargetFileDir ) .OR. ;
      HB_DirExists( cTargetFileDir ) 
      
      IF HB_DirExists( cShortCutFolder )
         FileShortcut := WshShell:CreateShortcut( cLnkFFNam )
         FileShortcut:TargetPath := cTargetFileDir
         FileShortcut:Description := cShortCutTTip
         FileShortcut:WorkingDirectory := cShortCutWrkdir
         if HMG_LEN( alltrim( cIcon ) ) > 0
            FileShortcut:IconLocation := cIcon
         endif            
         FileShortcut:Save()
         lSuccess := HB_FileExists( cLnkFFNam )
      ELSE
         MsgStop( cShortCutFolder + " Shortcut Folder not found !", "ERROR!" )       
      ENDIF   
      
   ELSE   
      MsgStop( cTargetFileDir + " Target file or folder not found !", "ERROR!" )       
   ENDIF
   
   WshShell := Nil
  
RETURN lSuccess // MakeFDirShortCut()

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

FUNCTION MakeInternetShortCut(;                  // Make a Internet shortcut (.url file)
                           cTargetURL,;              // Internet address to be targeted   
                           cShortCutTitle,;          // Short-cut (.url File) Name  
                           cShortCutFolder )         // Folder Name for short-cut (.lnk file ) Default is Desktop. 
                       
    LOCAL WshShell  := CreateObject("WScript.Shell"),;
         cUrlFFNam := cShortCutTitle + ".url",;     // Shorcut ( .url file ) Full Name 
         lSuccess := .F.,;
         UrlShortcut
         
   HB_Default( @cShortCutFolder, GetDeskTopFolder() )
   
   cUrlFFNam := cShortCutFolder + IF( HB_URIGHT( cShortCutFolder, 1 ) # "\", "\", "" ) + cUrlFFNam
 
   // IF IsValidURL( cTargetURL ) // ???
      
      IF HB_DirExists( cShortCutFolder )
         UrlShortcut := WshShell:CreateShortcut( cUrlFFNam )
         UrlShortcut:TargetPath := cTargetUrl
         UrlShortcut:Save()
         lSuccess := HB_FileExists( cUrlFFNam )
      ELSE
         MsgStop( cShortCutFolder + " Shortcut Folder not found !", "ERROR!" )       
      ENDIF   
      
*   ELSE   
*      MsgStop( cTargetURL + " Target URL not found !", "ERROR!" )       
*   ENDIF
   
   WshShell := Nil
  
RETURN lSuccess // MakeInternetShortCut()

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~