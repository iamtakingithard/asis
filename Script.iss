#define ScriptVersion "7.2.0"
;#define DEBUG


#define ScriptVersionInternal "7.2.0"

#include "Settings.ini"

#include "Resources\Modules\External\Settings.iss"
#include "Resources\Modules\External\CustomMessages.iss"
#include "Resources\Modules\External\Languages.iss"
#include "Resources\Modules\External\Messages.iss"

#define Compression "lzma"
#if InternalRecords == "1"
  #include "Records.ini"
#endif

[Setup]
UsePreviousLanguage=yes
UsePreviousAppDir=yes
UsePreviousGroup=yes
DisableWelcomePage=no
DisableProgramGroupPage=yes
DisableDirPage={#CompactMode == "1" ? "yes" : "no"}
DisableFinishedPage={#CompactMode == "1" ? "yes" : "no"}
DisableReadyPage={#CompactMode == "1" || UseRedists == "0" ? "yes" : "no"}
DisableReadyMemo={#CompactMode == "1" ? "yes" : "no"}
ShowLanguageDialog=no
#if UseInfo == "1"
  #ifexist "Setup\InfoBefore.txt"
    InfoBeforeFile=Setup\InfoBefore.txt
  #else
    InfoBeforeFile=Setup\InfoBefore.rtf
  #endif
#endif
WizardImageFile=Setup\{#WelcomeBackground}
WizardSmallImageFile=Setup\{#BannerBackground}
#if FileExists(SourcePath + "Setup.ico")
  SetupIconFile=Setup.ico
#else
  SetupIconFile=Resources\Setup.ico
#endif
AppName={#Name}
AppVersion=1.0
VersionInfoProductVersion={#ScriptVersionInternal}
VersionInfoVersion={#ScriptVersionInternal}
#if VER >= 0x06000000
  WizardStyle=classic
  WizardResizable=no
  WizardSizePercent=100
  UsedUserAreasWarning=no
  UsePreviousPrivileges=no
  #define DefaultDir StringChange(DefaultDir, "{pf}", "{commonpf}")
#endif
DefaultDirName={#DefaultDir}\{#Name}
DefaultGroupName={#Name}
VersionInfoCompany=Advanced Simple Installer Script
OutputBaseFilename=Setup
OutputDir=.
Compression=lzma2
SolidCompression=yes
UninstallFilesDir={app}\{#UnInstallFolder}
Uninstallable=IsUninstallable
UninstallDisplayIcon={uninstallexe}
#if x64 == "1"
  ArchitecturesInstallIn64BitMode=x64
  ArchitecturesAllowed=x64
#endif

#if defined(IS_ENHANCED) || !defined(UNICODE)   /* Don't delete these lines */
  #error "Standard Edition" of Inno Setup "UNICODE" from (JRSoftware) is required to compile this script
#endif


[Files]
; Thanks to Cesar82!
#define public i 0
#define public y 0
#define public n 0
#define public FileLine
#define public FileHandle
#define public FindHandle
#define public FindResult
#define GetEnabled(str Section, str StrValue, str StrName = "") \
  Local[0] = LowerCase(ReadIni(AddBackslash(SourcePath) + "Resources\Compressors\COMPRESSOR.ini", Section, "Type", "")), \
  Local[1] = (ReadIni(AddBackslash(SourcePath) + "Resources\Compressors\COMPRESSOR.ini", Section, "Enabled", "0") == "1"), \
  Local[0] == "" && StrValue != "" ? Local[0] = "x86" : void, \
  Local[2] = Local[0] == Trim(LowerCase(StrName)) + "-" + Trim(LowerCase(StrValue)), \
  Local[3] = Local[0] == Trim(LowerCase(StrName)) + Trim(LowerCase(StrValue)), \
  Pos("-", Local[0]) > 0 ? Local[1] && Local[2] : Local[1] && Local[3]
#define AFR_019 GetEnabled("AFR", "019")
#define SREP_O GetEnabled("SREP", "x86", "O")
#define XTool (ReadIni(AddBackslash(SourcePath) + "Resources\Compressors\COMPRESSOR.ini", "XTool", "Enabled", "0") == "1")
#define ZTool (ReadIni(AddBackslash(SourcePath) + "Resources\Compressors\COMPRESSOR.ini", "ZTool", "Enabled", "0") == "1")
#define RazorPMT GetEnabled("MPZ", "PMT") && (GetEnabled("PMT", "x64") || GetEnabled("PMT", "DUAL"))
#define MpzPMT GetEnabled("MPZ", "PMT") && (GetEnabled("PMT", "") || GetEnabled("PMT", "x86") || GetEnabled("PMT", "DUAL"))
#emit "; AFR_019: Enabled=" + Str(AFR_019) + " - SREP_O: Enabled=" + Str(SREP_O) + " - RazorPMT: Enabled=" + Str(RazorPMT) + " - MpzPMT: Enabled=" + Str(MpzPMT)
#define Name
#define Value
#define Section
#define FileName
#sub DoAddToList
  #define GetItemEnabled(str Item) \
    ReadIni(AddBackslash(SourcePath) + "Resources\Compressors\COMPRESSOR.ini", Item, "Enabled", "0") == "1"
  #define GetItemType(str Item) \
    Local[0] = LowerCase(ReadIni(AddBackslash(SourcePath) + "Resources\Compressors\COMPRESSOR.ini", Item, "Type", "")), \
      Pos("-", Local[0]) > 0 ? Trim(Copy(Local[0], Pos("-", Local[0]) + Len("-"), Len(Local[0]))) : Trim(Local[0])
  #define GetItemName(str Item) \
    Local[0] = LowerCase(ReadIni(AddBackslash(SourcePath) + "Resources\Compressors\COMPRESSOR.ini", Item, "Type", "")), \
      Pos("-", Local[0]) > 0 ? Trim(Copy(Local[0], 0, Pos("-", Local[0]) - 1)) : ""
  #if GetItemEnabled(Section)
    #define ItemName GetItemName(Section)
    #define ItemType GetItemType(Section)
    #if (Value == "") || (ItemType == Value) || ((ItemType == "") && (Value == "x86")) || ((ItemType == "dual") && ((Value == "x86") || (Value == "x64")))
      #if (Name == "") || (ItemName == Name)
        #define TmpInt DimOf(PathList)
        #redim public PathList[TmpInt + 1]
        #redim public DualList[TmpInt + 1]
        #define public PathList[TmpInt] "Resources\Compressors\" + FileName
        #define public DualList[TmpInt] ((ItemType == "dual") && ((Value == "x86") || (Value == "x64")))
        #pragma message "Parsing folder: " + FileName + " >> Type: """ + ItemType + """ >> Value: """ + Value + """ >> IsDual: " + Str(DualList[TmpInt])
      #endif
    #endif
  #endif
#endsub
#define AddToList(str File, str Sec, str Val = "", str Nam = "") /* AddToList(Files, Name, Class, Type) */ \
  FileName = File, Section = Trim(Sec), Value = Trim(LowerCase(Val)), Name = Trim(LowerCase(Nam)), \
    DoAddToList
//////////////////////////// COMPRESSOR //////////////////////////////////////////////////////////
// ---------- Precompressors -------------------------------- /* ------------------------------ */
#expr AddToList("SREP\N\Win64\*.*", "SREP", "x64", "N")       /*       SREP Inside N x64        */
#expr AddToList("SREP\N\Win32\*.*", "SREP", "x86", "N")       /*       SREP Inside N x86        */
#expr AddToList("SREP\N\*.*", "SREP", "", "N")                /*         SREP N Common          */
#expr AddToList("SREP\O\*.*", "SREP", "", "O")                /*             SREP O             */
#expr AddToList("Precomp\Win64\*.*", "PRECOMP", "x64")        /*           Precomp x64          */
#expr AddToList("Precomp\Win32\*.*", "PRECOMP", "x86")        /*           Precomp x86          */
#expr AddToList("Precomp\Win64\X\*.*", "PRECOMP", "x64", "X") /*          PrecompX x64          */
#expr AddToList("Precomp\Win32\X\*.*", "PRECOMP", "x86", "X") /*          PrecompX x86          */
#expr AddToList("AFR\CLS-AFR.dll", "AFR", "019")              /*  Anvil Forge Recompressor 019  */
#expr AddToList("AFR\Alpha7\*.*", "AFR", "020")               /*  Anvil Forge Recompressor 020  */
#expr AddToList("UELR\Win64\*.*", "UELR", "x64")              /*            UELR x64            */
#expr AddToList("UELR\Win32\*.*", "UELR", "x86")              /*            UELR x86            */
#expr AddToList("UELR\*.*", "UELR")                           /*          UELR x64/x86          */
#expr AddToList("OodleRec\Oodle4\*.*", "OodleRec", "Oodle4")  /*         OodleRec Oodle4        */
#expr AddToList("OodleRec\Oodle5\*.*", "OodleRec", "Oodle5")  /*         OodleRec Oodle5        */
#expr AddToList("OodleRec\Oodle6\*.*", "OodleRec", "Oodle6")  /*         OodleRec Oodle6        */
#expr AddToList("OodleRec\Oodle7\*.*", "OodleRec", "Oodle7")  /*         OodleRec Oodle7        */
#expr AddToList("OodleRec\Oodle8\*.*", "OodleRec", "Oodle8")  /*         OodleRec Oodle8        */
#expr AddToList("OodleRec\*.*", "OodleRec")                   /*       OodleRec Common x64      */
#expr AddToList("RazorTools\*.*", "RazorTools")               /*          RazorTools x64          */
#expr AddToList("pZLib3\Win64\*.*", "pZLib3", "x64")          /*            pZLib3 x64          */
#expr AddToList("pZLib3\Win32\*.*", "pZLib3", "x86")          /*            pZLib3 x86          */
#expr AddToList("XTool\Win64\*.*", "XTool", "x64")            /*            XTool x64           */
#expr AddToList("XTool\Win32\*.*", "XTool", "x86")            /*            XTool x86           */
#expr AddToList("XTool\*.*", "XTool")                         /*          XTool Common          */
#expr AddToList("ZSTDRec\*.*", "ZSTDRec")                     /*           ZSTDRec x64          */
#expr AddToList("ZTool\Win64\*.*", "ZTool", "x64")            /*            ZTool x64           */
#expr AddToList("ZTool\Win32\*.*", "ZTool", "x86")            /*            ZTool x86           */
// --------- Complementary Compressor ----------------------- /* ------------------------------ */
#expr AddToList("COMMON\PMT\Win64\*.*", "PMT", "x64")         /*   Parallel Multithreaded x64   */
#expr AddToList("COMMON\PMT\Win32\*.*", "PMT", "x86")         /*   Parallel Multithreaded x86   */
#expr AddToList("COMMON\PMT\*.*", "PMT")                      /* Parallel Multithreaded Common  */
#expr AddToList("COMMON\ZLib\Win64\*.*", "ZLib", "x64")       /*      ZLib x64 XTool/ZTool      */
#expr AddToList("COMMON\ZLib\Win32\*.*", "ZLib", "x86")       /*      ZLib x86 XTool/ZTool      */
#expr AddToList("COMMON\Reflate\Win64\*.*", "Reflate", "x64") /* Reflate x64 pZLib3/XTool/ZTool */
#expr AddToList("COMMON\Reflate\Win32\*.*", "Reflate", "x86") /* Reflate x64 pZLib3/XTool/ZTool */
#expr AddToList("COMMON\Facompress\*.*", "Facompress")        /*     Facompress x86 All Tools   */
// --------- Media Streams Compressor ----------------------- /* ------------------------------ */
#expr AddToList("MSC\TAK\*.*", "MSC", "TAK")                  /*         MSCInside TAK          */
#expr AddToList("MSC\FROG\*.*", "MSC", "FROG")                /*         MSCInside FROG         */
#expr AddToList("MPZ\*.*", "MPZ")                             /*         MPZ Slimmer x86        */
#expr AddToList("MPZ\STANDARD\*.*", "MPZ", "NORMAL")          /*    MPZ Slimmer STANDARD x86    */
#expr AddToList("OGGRE\*.*", "OGGRE", "x86")                  /*           OGGRE x86            */
#expr AddToList("BPK\*.*", "BPK", "x86")                      /*        Bink Pack x86           */
// --------- Final Compressor ------------------------------- /* ------------------------------ */
#expr AddToList("7Zip\Win64\*.*", "7ZIP", "x64")              /*           7Zip x64             */
#expr AddToList("7Zip\Win32\*.*", "7ZIP", "x86")              /*           7Zip x86             */
#expr AddToList("RAZOR\STDIO\*.*", "RAZOR", "STDIO")          /*     RAZOR STDIO Patched x64    */
#expr AddToList("RAZOR\STANDARD\*.*", "RAZOR", "PMT")         /*    RAZOR Archiver + PMT x64    */
#expr AddToList("RAZOR\STANDARD\*.*", "RAZOR", "NORMAL")      /*        RAZOR Archiver x64      */
#expr AddToList("LOLZ\Win64\*.*", "LOLZ", "x64")              /*            LOLZ x64            */
#expr AddToList("LOLZ\Win32\*.*", "LOLZ", "x86")              /*            LOLZ x86            */
#expr AddToList("LOLZ\*.*", "LOLZ")                           /*          LOLZ Common           */
#expr AddToList("ZSTD\Win64\*.*", "ZSTD", "x64")              /*         ZStandard x64          */
#expr AddToList("ZSTD\Win32\*.*", "ZSTD", "x86")              /*         ZStandard x86          */
#expr AddToList("XDelta\*.*", "XDELTA")                       /*          XDelta3 x86           */
#expr AddToList("RAR\*.*", "RAR")                             /*            RAR x86             */
//////////////////////////// COMPRESSOR //////////////////////////////////////////////////////////
#sub AddFile
  #if LowerCase(ExtractFileExt(FindGetFileName(FindHandle))) != 'txt' /* exclude ".txt" files  */
    #if (DualList[i] == 1)
      #define StrPath LowerCase(ExtractFileName(ExtractFilePath(PathList[i])))
      #if Pos("win64", StrPath) + Pos("win32", StrPath) + Pos("x64", StrPath) + Pos("x86", StrPath) == 0
        #define StrPath LowerCase(ExtractFileName(ExtractFilePath(ExtractFilePath(PathList[i]))))
      #endif
      #if (Pos("win64", StrPath) > 0) || (Pos("x64", StrPath) > 0)
        #emit "Source: """ + AddBackslash(ExtractFilePath(PathList[i])) + FindGetFileName(FindHandle) + """; DestName: """ + FindGetFileName(FindHandle) + ".win64""; DestDir: ""COMPRESSORS""; Flags: dontcopy;"
      #else
        #emit "Source: """ + AddBackslash(ExtractFilePath(PathList[i])) + FindGetFileName(FindHandle) + """; DestName: """ + FindGetFileName(FindHandle) + ".win32""; DestDir: ""COMPRESSORS""; Flags: dontcopy;"
      #endif
    #else
      #emit "Source: """ + AddBackslash(ExtractFilePath(PathList[i])) + FindGetFileName(FindHandle) + """; DestDir: ""COMPRESSORS""; Flags: dontcopy;"
    #endif
  #endif
#endsub
#sub AddPathOrFile
  #for {FindHandle = FindResult = FindFirst(PathList[i], 0); FindResult; FindResult = FindNext(FindHandle)} AddFile
  #if FindHandle
    #expr FindClose(FindHandle)
  #endif
  #if FindResult
    #expr FindClose(FindResult)
  #endif
#endsub
#for {i = 0; i < DimOf(PathList); i++} AddPathOrFile
///////////////////////////////////////////////////////////////////////////////////////////
//////////////// FreeArc/ISDone Files /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
Source: "Resources\Compressors\COMMON\DiskSpan\CLS-DISKSPAN.dll"; DestDir: "COMPRESSORS"; Flags: dontcopy
Source: "Resources\Compressors\COMMON\FreeArc\Arc.ini"; DestDir: "COMPRESSORS"; Flags: dontcopy
Source: "Resources\Compressors\COMMON\FreeArc\CLS.ini"; DestDir: "COMPRESSORS"; Flags: dontcopy
Source: "Resources\Compressors\COMMON\FreeArc\UnArc.dll"; DestDir: "COMPRESSORS"; Flags: dontcopy
Source: "Resources\Compressors\COMMON\ISDone\ISDone.dll"; DestDir: "COMPRESSORS"; Flags: dontcopy
Source: "Resources\Compressors\COMMON\ISDone\English.ini"; DestDir: "COMPRESSORS"; Flags: dontcopy
Source: "Resources\Compressors\COMMON\ISDone\French.ini"; DestDir: "COMPRESSORS"; Flags: dontcopy;
Source: "Resources\Compressors\COMMON\ISDone\German.ini"; DestDir: "COMPRESSORS"; Flags: dontcopy;
Source: "Resources\Compressors\COMMON\ISDone\Italian.ini"; DestDir: "COMPRESSORS"; Flags: dontcopy;
Source: "Resources\Compressors\COMMON\ISDone\Spanish.ini"; DestDir: "COMPRESSORS"; Flags: dontcopy;
Source: "Resources\Compressors\COMMON\ISDone\Polish.ini"; DestDir: "COMPRESSORS"; Flags: dontcopy;
Source: "Resources\Compressors\COMMON\ISDone\Russian.ini"; DestDir: "COMPRESSORS"; Flags: dontcopy;
Source: "Resources\Compressors\COMMON\ISDone\PortugueseBrazil.ini"; DestDir: "COMPRESSORS"; Flags: dontcopy;
Source: "Resources\Compressors\COMMON\Split\Split.exe"; DestDir: "COMPRESSORS"; Flags: dontcopy

//////////////// Modules ///////////////////////////////////////////////////////
Source: "Resources\Modules\FolderImage.bmp"; DestDir: "{tmp}"; Flags: dontcopy;
Source: "Resources\Modules\DiskSpaceImage.bmp"; DestDir: "{tmp}"; Flags: dontcopy;
Source: "Resources\Modules\InfoBeforeImage.bmp"; DestDir: "{tmp}"; Flags: dontcopy;
Source: "Resources\Modules\CallbackCtrl.dll"; DestDir: "{tmp}"; Flags: dontcopy;
Source: "Resources\Logo2.bmp"; DestDir: "{tmp}"; Flags: dontcopy;
////////////////////////////////////////////////////////////////////////////////
Source: "Resources\Modules\Music\bass.dll"; DestDir: "{tmp}"; Flags: dontcopy;

#if Splash == "1"
  Source: "Resources\Modules\Splash\isgsg.dll"; DestDir: "{tmp}"; Flags: dontcopy;
  Source: "Setup\{#SplashFile}"; DestDir: "{tmp}"; Flags: dontcopy;
#endif

#if CompactMode == "0"
  Source: "Resources\Modules\Components\SelectComponentsImage.bmp"; DestDir: "{tmp}"; Flags: dontcopy;

  #if UseLicense == "1"
    Source: "Resources\Modules\License\LicenseImage.bmp"; DestDir: "{tmp}"; Flags: dontcopy;
  #endif

  #if UseRedists == "1"
    Source: "Resources\Modules\Redist\SelectRedistsImage.bmp"; DestDir: "{tmp}"; Flags: dontcopy;
  #endif

  #if UseSystemReq == "1"
    Source: "Resources\Modules\SystemReq\ISSysInfo.dll"; DestDir: "{tmp}"; Flags: dontcopy;
    Source: "Resources\Modules\SystemReq\SystemReqImage.bmp"; DestDir: "{tmp}"; Flags: dontcopy;
  #endif

  #if UseInstallBackground == "1"
    Source: "Resources\Modules\InstallBG\InnoCallback.dll"; DestDir: "{tmp}"; Flags: dontcopy
    Source: "Resources\Modules\InstallBG\isSlideShow.dll"; DestDir: "{tmp}"; Flags: dontcopy
  #endif

  #if UseInstallBackground == "1"
    #sub AddFile2
      Source: "Setup\Background\{#i}.jpg"; DestDir: "{tmp}"; Flags: dontcopy
    #endsub
    #for {i = 1; FileExists("Setup\Background\" + Str(i) + ".jpg" ) != 0; i++} AddFile2
  #endif

  #ifexist "Setup\Font.ttf"
    Source: "Setup\Font.ttf"; DestDir: "{tmp}"; Flags: dontcopy;
  #endif

  Source: "Setup\{#FinishBackground}"; DestDir: "{tmp}"; Flags: dontcopy;
  Source: "Setup\{#BannerBackground}"; DestDir: "{tmp}"; Flags: dontcopy;
#endif

#if CheckCRC == "1"
  Source: "Setup\{#CRCFileName}"; DestDir: "{tmp}"; Flags: dontcopy;
  Source: "Resources\Modules\CRC\ISHash.dll"; DestDir: "{tmp}"; Flags: dontcopy;
  Source: "Resources\Modules\CRC\HashCheck.bmp"; DestDir: "{tmp}"; Flags: dontcopy;
#endif

#if Music == "1"
  Source: "Setup\{#MusicFile}"; DestDir: "{tmp}"; Flags: dontcopy nocompression;
#endif

#if UWPGame == "1"
  Source: "Resources\UWP\UWP_Tool.exe"; DestDir: "{tmp}"; Flags: dontcopy;
#endif

#if VCL == "1"
  Source: "Resources\Modules\Style\VclStylesinno.dll"; DestDir: "{tmp}"; Flags: dontcopy;
  Source: "Setup\{#VCLName}"; DestDir: "{tmp}"; Flags: dontcopy;
#elif Cjstyles == "1"
  Source: "Resources\Modules\Style\ISSkin.dll"; DestDir: "{tmp}"; Flags: dontcopy;
  Source: "Setup\{#CjstylesName}"; DestDir: "{tmp}"; Flags: dontcopy;
#endif

Source: "Settings.ini"; DestDir: "{tmp}"; Flags: dontcopy;
#if InternalRecords == "1"
  Source: "Records.ini"; DestDir: "{tmp}"; Flags: dontcopy;
#endif

////////////////////////////////////////////////////////////////////////////////

#ifexist "Registry.iss"
  #include "Registry.iss"
#endif

#if (CompactMode == "0") && (UseSystemReq == "1")
  #include "Resources\Modules\SystemReq\ISSysInfo.iss"
#endif

#if CheckCRC == "1"
  #include "Resources\Modules\CRC\ISHash.iss"
#endif


[Icons]
Name: "{group}\{cm:UninstallProgram,{code:AppName}}"; Filename: "{uninstallexe}"; Check: CreateIcons;
#sub AddShortcut
  #emit "Name: ""{userdesktop}\" + Trim(ReadIni(SourcePath + "\Settings.ini", "Executable" + Str(i), "ShortcutName", "")) + """; " + \
        "FileName: ""{app}\" + Trim(ReadIni(SourcePath + "\Settings.ini", "Executable" + Str(i), "ExePath", "")) + """; " + \
        "WorkingDir: """ + ExtractFileDir("{app}\" + Trim(ReadIni(SourcePath + "\Settings.ini", "Executable" + Str(i), "ExePath", ""))) + """; " + \
        "Parameters: """ + Trim(ReadIni(SourcePath + "\Settings.ini", "Executable" + Str(i), "ExeParam", "")) + """; " + \
        "Check: CreateIcons;"

  #emit "Name: ""{group}\" + Trim(ReadIni(SourcePath + "\Settings.ini", "Executable" + Str(i), "ShortcutName", "")) + """; " + \
        "FileName: ""{app}\" + Trim(ReadIni(SourcePath + "\Settings.ini", "Executable" + Str(i), "ExePath", "")) + """; " + \
        "WorkingDir: """ + ExtractFileDir("{app}\" + Trim(ReadIni(SourcePath + "\Settings.ini", "Executable" + Str(i), "ExePath", ""))) + """; " + \
        "Parameters: """ + Trim(ReadIni(SourcePath + "\Settings.ini", "Executable" + Str(i), "ExeParam", "")) + """; " + \
        "Check: CreateIcons;"

#endsub
#for {i = 1; Trim(ReadIni(SourcePath + "\Settings.ini", "Executable" + Str(i), "ShortcutName", "")) != ""; i++} AddShortcut

[Code]
const
  DI_NORMAL = 3;
  FR_PRIVATE = $10;  {added to compact Mode}
  BASS_SAMPLE_LOOP = 4;
  BASS_ACTIVE_STOPPED = 0;
  BASS_ACTIVE_PLAYING = 1;
  BASS_ACTIVE_STALLED = 2;
  BASS_ACTIVE_PAUSED  = 3;
  BASS_UNICODE = $80000000;
  BASS_CONFIG_GVOL_STREAM = {#MusicVolume};
  EncodingFlag = BASS_UNICODE;
  MB_ICONERROR       = $10;
  MB_ICONQUESTION    = $20;
  MB_ICONWARNING     = $30;
  MB_ICONINFORMATION = $40;
  MB_APPLMODAL       = $00000000;
  MB_SYSTEMMODAL     = $00001000;
  MB_TASKMODAL       = $00002000;
  #if CheckCRC == "1"
    PM_REMOVE = 1;
    WM_QUIT   = 18;
  #endif


type
  TData = record Arc: array of String; end;
  TCallback = function (OveralPct, CurrentPct: integer; CurrentFile, TimeStr1, TimeStr2, TimeStr3: PAnsiChar): Longword;
  TPBProc = function (h:hWnd;Msg,wParam,lParam:Longint):Longint;
  TIniMemory = record Section: String; Key, Value: TArrayOfString; end;
  TRequestDisk = function(APath, AFilename: String): String;
  HSTREAM = DWORD;
  TProc = procedure(HandleW, msg, idEvent, TimeSys: LongWord);
  TTimerProc = procedure(hWnd, uMsg, idEvent, dwTime: LongWord);

  #if AFR_019
    TSystemInfo = record
      wProcessorArchitecture: Word;
      wReserved: Word;
      dwPageSize: DWORD;
      lpMinimumApplicationAddress: Integer;
      lpMaximumApplicationAddress: Integer;
      dwActiveProcessorMask: DWORD;
      dwNumberOfProcessors: DWORD;
      dwProcessorType: DWORD;
      dwAllocationGranularity: DWORD;
      wProcessorLevel: Integer;
      wProcessorRevision: Word;
    end;
  #endif

  #if CheckCRC == "1"
    TMsg = record
      hwnd: HWND;
      message: UINT;
      wParam: Longint;
      lParam: Longint;
      time: DWORD;
      pt: TPoint;
    end;
  #endif

var
  //////////////////////// Check boxes ////////////////////////
  IconsCB, StartMenuCB, CRCCheckCB, PauseCB, UninstallCB, LimitRAMCB: TNewCheckBox;

  ////////////////////////// Buttons //////////////////////////
  {#if Music == "1"}MusicButton,{#endif} PauseButton: TNewButton;
  
  /////////////////////////// Label ///////////////////////////
  LabelCurrFileName, FreeSpaceLabel, NeedSpaceLabel: TLabel;

  ////////////////////////// Integer //////////////////////////
  #if XTool || ZTool || (UWPGame == "1")
    ResultCode: Integer;
  #endif

  //////////////////////// Static Text ////////////////////////
  PercentLabel, ElapsedLabel, RemainingLabel: TNewStaticText;

  //////////////////////// Components /////////////////////////
  #if UseComponents == "1"
    ComponentsList: TNewCheckListBox;
    SelectComponentsLabel, ComponentsDiskSpaceLabel: TNewStaticText;
    CompIndexList: TArrayOfInteger;
    ComponentsPageAvai {#if CompactMode == "1"}, ComponentsPageVisible, ComponentsDiskSpaceLabelVisible{#endif}: Boolean;
    ComponentsSize: Extended;
    {#if CompactMode == "1"}ComponentsOKButton: TNewButton;{#endif}
  #endif

  ///////////////////////// Redists ///////////////////////////
  #if UseRedists == "1"
    RedistsList: TNewCheckListBox;
    Redist1, Redist2, Redist3, Redist4, Redist5, Redist6, Redist7, Redist8, Redist9, Redist10: Integer;
  #endif
  
  /////////////////////////// Others //////////////////////////
  #if Music == "1"
    SoundStream: HSTREAM;
  #endif
  FreeMB, TotalMB: Cardinal;
  StartTick: DWORD;
  ISDoneCancel: Integer;
  ISDoneError: Boolean;
  SplitPct: Longint;
  Data: array of TData;
  InstallationSize: Extended;

  #if CompactMode == "0"
    FolderImage, DiskSpaceImage, InfoBeforeImage, {#if UseRedists == "1"}SelectRedistsImage,{#endif} BannerImage, SelectComponentsImage: TBitmapImage;
    WebsiteButton, AboutButton: TNewButton;
    NeedSizeFreeSizeBevel: TBevel;
    ComponentsPage: TWizardPage;
  #else
    RedistCB: TNewCheckBox;
    AboutButtonCM {#if UseInfo == "1"}, InfoButtonCM{#endif}: TNewButton;
  #endif

  #if (CompactMode == "0") && (UseInfo == "1")
    InfoBeforeMemo: TNewMemo;
  #endif

  #if (CompactMode == "0") && (UseLicense == "1")
    LicenseImage: TBitmapImage;
    LicenseMemo: TNewMemo;
  #endif

  #if (CompactMode == "0") && (UseSystemReq == "1")
    SystemReqPage: TWizardPage;
    SystemReqImage: TBitmapImage;
    Case1: TPanel;
    SysReqCheckLabel, IfReadyLabel, HardwareDetectLabel: TNewStaticText;
    SystemLabel, SystemNameLabel, CPUGHZLabel, GPUGHZLabel, HwLabel: TLabel;
    CPULabel, CPUNameLabel, GPULabel, GPUNameLabel, DirectXLabel, DirectXVersionLabel, RAMLabel, TotalRAMLabel: TLabel;
    ProcessorBevel, VideoCardBevel, DirectXBevel, RAMBevel, SystemBevel, ProcessorNameBevel, VideoCardNameBevel,  DirectXVersionBevel, RAMTotalBevel: TBevel;
    SystemNameBevel, CPUMHZBevel, GPUMHZBevel: TBevel;
    Processor, VideoRam, Ram, OpSystem, DirectX, DX, OSNumber: Integer;
  #endif

  #if (CompactMode == "0") && (UseInstallBackground == "1")
    BackgroundForm: TForm;
    BackgroundButton: TNewButton;
    BackgroundCB: TNewCheckBox;
    CurrentPicture: Integer;
    PicList: TStringlist;
    TimerID: LongWord;
  #endif

  #if CheckCRC == "1"
    #if CompactMode == "0"
      HashImage: TBitmapImage;
    #endif
    CRCPage: TWizardPage;
    CRCInfoMemo, CRCLogMemo: TNewMemo;
    CRCCancelButton, LogButton: TNewButton;
    HashProgressBar1, HashProgressBar2: TNewProgressBar;
    CheckFileLabel, OveralCheckLabel: TLabel;
    HashHdrLabel: TNewStatictext;
    BadFile, MissingFile, FileOK: Integer;
    ContinueHash, Checked: Boolean;
    Msg: Tmsg;
  #endif

#if Music == "1"
  function BASS_Init(device: LongInt; freq, flags: DWORD; win: HWND; clsid: Cardinal): BOOL;
    external 'BASS_Init@files:bass.dll stdcall';
  function BASS_StreamCreateFile(mem: BOOL; f: string; offset1: DWORD; offset2: DWORD; length1: DWORD; length2: DWORD; flags: DWORD): HSTREAM;
    external 'BASS_StreamCreateFile@files:bass.dll stdcall';
  function BASS_Start: BOOL;
    external 'BASS_Start@files:bass.dll stdcall';
  function BASS_Pause: BOOL;
    external 'BASS_Pause@files:bass.dll stdcall';
  function BASS_ChannelPlay(handle: DWORD; restart: BOOL): BOOL;
    external 'BASS_ChannelPlay@files:bass.dll stdcall';
  function BASS_SetConfig(option: DWORD; value: DWORD ): BOOL;
    external 'BASS_SetConfig@files:bass.dll stdcall';
  function BASS_ChannelIsActive(handle: DWORD): DWORD;
    external 'BASS_ChannelIsActive@files:bass.dll stdcall';
  function BASS_Free: BOOL;
    external 'BASS_Free@files:bass.dll stdcall';
#endif

#if AFR_019
  procedure GetSystemInfo(var lpSystemInfo: TSystemInfo);
    external 'GetSystemInfo@kernel32.dll stdcall';
#endif

#if Splash == "1"
  procedure ShowSplashScreen(p1:HWND; p2:AnsiString; p3,p4,p5,p6,p7:integer; p8:boolean; p9:Cardinal; p10:integer);
    external 'ShowSplashScreen@files:isgsg.dll stdcall delayload';
#endif

#if VCL == "1"
  procedure LoadVCLStyle(VClStyleFile: String);
    external 'LoadVCLStyleW@{tmp}\VclStylesInno.dll stdcall delayload';
  procedure UnLoadVCLStyles;
    external 'UnLoadVCLStyles@{tmp}\VclStylesInno.dll stdcall delayload';
#elif Cjstyles == "1"
  procedure LoadSkin(lpszPath: String; lpszIniFileName: String);
    external 'LoadSkin@{tmp}\ISSkin.dll stdcall delayload';
  procedure UnloadSkin();
    external 'UnloadSkin@{tmp}\ISSkin.dll stdcall delayload';
  function ShowWindow(hWnd: Integer; uType: Integer): Integer;
    external 'ShowWindow@user32.dll stdcall';
#endif

#if CheckCRC == "1"
  function TranslateMessage(var lpMsg: TMsg): Boolean;
    external 'TranslateMessage@user32.dll stdcall';
  function DispatchMessage(var lpMsg: TMsg): Boolean;
    external 'DispatchMessageW@user32.dll stdcall';
  function PeekMessage(var lpMsg: TMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL;
    external 'PeekMessageW@user32.dll stdcall';
#endif

function ISDoneInit(RecordFileName:AnsiString; TimeType,Comp1,Comp2,Comp3:Cardinal; WinHandle, NeededMem: longint; callback:TCallback):boolean;
  external 'ISDoneInit@files:ISDone.dll stdcall';
function ISArcExtract(CurComponent:Cardinal; PctOfTotal:double; InName, OutPath, ExtractedPath: AnsiString; DeleteInFile: boolean; Password, CfgFile, WorkPath: AnsiString; ExtractPCF: boolean ): boolean;
  external 'ISArcExtract@files:ISDone.dll stdcall delayload';
function IS7ZipExtract(CurComponent:Cardinal; PctOfTotal:double; InName, OutPath: AnsiString; DeleteInFile:boolean; Password: AnsiString):boolean;
  external 'IS7zipExtract@files:ISDone.dll stdcall delayload';
function ISRarExtract(CurComponent:Cardinal; PctOfTotal:double; InName, OutPath: AnsiString; DeleteInFile:boolean; Password: AnsiString):boolean;
  external 'ISRarExtract@files:ISDone.dll stdcall delayload';
function SrepInit(TmpPath:PAnsiChar;VirtMem,MaxSave:Cardinal):boolean;
  external 'SrepInit@files:ISDone.dll stdcall delayload';
function PrecompInit(TmpPath:PAnsiChar;VirtMem:cardinal;PrecompVers:single):boolean;
  external 'PrecompInit@files:ISDone.dll stdcall delayload';
function FileSearchInit(RecursiveSubDir:boolean):boolean;
  external 'FileSearchInit@files:ISDone.dll stdcall delayload';
function ISDoneStop:boolean;
  external 'ISDoneStop@files:ISDone.dll stdcall';
function ChangeLanguage(Language:AnsiString):boolean;
  external 'ChangeLanguage@files:ISDone.dll stdcall delayload';
function SuspendProc:boolean;
  external 'SuspendProc@files:ISDone.dll stdcall';
function ResumeProc:boolean;
  external 'ResumeProc@files:ISDone.dll stdcall';
procedure ExitProcess(exitCode:integer);
  external 'ExitProcess@kernel32.dll stdcall';
function Exec2 (FileName, Param: PAnsiChar;Show:boolean):boolean;
  external 'Exec2@files:ISDone.dll stdcall delayload';
function AddFontResource(lpszFilename: String; fl, pdv: DWORD): Integer;
  external 'AddFontResourceExW@gdi32.dll stdcall';
function RemoveFontResource(lpFileName: String; fl, pdv: DWORD): BOOL;
  external 'RemoveFontResourceExW@gdi32.dll stdcall';
function GetTickCount: DWORD;
  external 'GetTickCount@kernel32.dll stdcall';
function CallWindowProc(lpPrevWndFunc: Longint; hWnd: HWND; Msg: UINT; wParam, lParam: Longint): Longint;
  external 'CallWindowProcA@user32.dll stdcall';
function SetWindowLong(hWnd: HWND; nIndex: Integer; dwNewLong: Longint): Longint;
  external 'SetWindowLongA@user32.dll stdcall';
function CallBackProc(P:TPBProc;ParamCount:integer):LongWord;
  external 'wrapcallbackaddr@files:CallbackCtrl.dll stdcall';
procedure ClsInit(Path: String; Parent: HWND);
  external 'ClsInit@files:cls-diskspan.dll cdecl';

function ExtractIcon(hInst: Longint; lpszExeFileName: String; nIconIndex: UINT): Longint;
  external 'ExtractIconW@shell32.dll stdcall';
function DrawIconEx(hdc: Longint; xLeft, yTop: Integer; hIcon: Longint; cxWidth, cyWidth: Integer; istepIfAniCur: Longint; hbrFlickerFreeDraw, diFlags: Longint): Longint;
  external 'DrawIconEx@user32.dll stdcall';
function DestroyIcon(hIcon: Longint): Longint;
  external 'DestroyIcon@user32.dll stdcall';
function GetModuleHandle(lpModuleName: Longint): Longint;
  external 'GetModuleHandleA@kernel32.dll stdcall';
function ShellExecute(hWnd: HWND; lpOperation: String; lpFile: String; lpParameters: String; lpDirectory: String; nShowCmd: Integer): THandle;
  external 'ShellExecuteW@shell32.dll stdcall';
function MessageBox(hWnd: HWND; lpText, lpCaption: String; uType: UINT): Integer;
  external 'MessageBoxW@user32.dll stdcall delayload';


function CreateLangDialog(): Boolean;
var
  I: Integer;
  TmpStr: String;
  Params: String;
  Instance: THandle;
  SL1, SL2: TStringList;
  LangList: TStringList;
  LangIcon: Longint;
  LangRect: TRect;
  LangDialogForm: TSetupForm;
  LangDialogLabel: TNewStaticText;
  LangDialogComboBox: TNewComboBox;
  LangDialogOKButton: TNewButton;
  LangDialogCancelButton: TNewButton;
begin
  SL1 := TStringList.Create;                           { Values from LanguageName= key, [LangOptions] section in external language file }
  SL1.Add('English');                                  //'English'
  SL1.Add('Fran'#$00E7'ais');                          //'Fran<00E7>ais'
  SL1.Add('Deutsch');                                  //'Deutsch'
  SL1.Add('Italiano');                                 //'Italiano'
  SL1.Add('Espa'#$00F1'ol');                           //'Espa<00F1>ol'
  SL1.Add('Polski');                                   //'Polski'
  SL1.Add(#$0420#$0443#$0441#$0441#$043A#$0438#$0439); //'<0420><0443><0441><0441><043A><0438><0439>'
  SL1.Add('Portugu'#$00EA's Brasileiro');              //'Portugu<00EA>s Brasileiro'
  SL1.Add(#$010C'e'#$0161'tina');                      //'<010C>e<0161>tina'

  SL2 := TStringList.Create;                           {Values from section [Languages] Name: in script}
  SL2.Add('English');
  SL2.Add('French');
  SL2.Add('German');
  SL2.Add('Italian');
  SL2.Add('Spanish');
  SL2.Add('Polish');
  SL2.Add('Russian');
  SL2.Add('PortugueseBrazil');
  SL2.Add('Czech');

  LangDialogForm := CreateCustomForm();
  try
    with LangDialogForm do
    begin
      ClientWidth  := ScaleX(297);
      ClientHeight := ScaleY(125);
      Position     := poScreenCenter;
      Caption      := SetupMessage(msgSelectLanguageTitle);
      Color        := clBtnFace;
      BorderIcons  := [biSystemMenu];
      ActiveControl := LangDialogOKButton;
    end;

    LangDialogLabel := TNewStaticText.Create(LangDialogForm);
    with LangDialogLabel do
    begin
      Parent := LangDialogForm;
      Left     := ScaleX(56);
      Top      := ScaleY(8);
      Width    := ScaleX(233);
      Height   := ScaleY(39);
      AutoSize := False;
      WordWrap := True;
      Caption  := SetupMessage(msgSelectLanguageLabel);
    end;

    LangDialogComboBox := TNewComboBox.Create(LangDialogForm);
    with LangDialogComboBox do
    begin
      Left     := ScaleX(56);
      Top      := ScaleY(56);
      Width    := ScaleX(233);
      Height   := ScaleY(21);
      Parent   := LangDialogForm;
      Style    := csDropDownList;
      DropDownCount := 16;
      Sorted   := True;
      Items.AddStrings(SL1);
      ItemIndex := 0;
      LangList  := TStringList.Create;
      for I := 0 to SL2.Count - 1 do
      begin
        LangList.Append(SL2.Strings[SL1.IndexOf(LangDialogComboBox.Items.Strings[I])]);
      end;
      ItemIndex := LangList.IndexOf(ActiveLanguage);
    end;

    LangDialogOKButton := TNewButton.Create(LangDialogForm);
    with LangDialogOKButton do
    begin
      Parent := LangDialogForm;
      Left     := ScaleX(133);
      Top      := ScaleY(93);
      Width    := ScaleX(75);
      Height   := ScaleY(23);
      Caption  := SetupMessage(msgButtonOK);
      ModalResult := mrOk;
      Default := True;
    end;

    LangDialogCancelButton := TNewButton.Create(LangDialogForm);
    with LangDialogCancelButton do
    begin
      Parent := LangDialogForm;
      Left     := ScaleX(214);
      Top      := ScaleY(93);
      Width    := ScaleX(75);
      Height   := ScaleY(23);
      Caption  := SetupMessage(msgButtonCancel);
      ModalResult := mrCancel;
    end;

    try
      LangRect.Left   := ScaleX(0);
      LangRect.Top    := ScaleY(0);
      LangRect.Right  := ScaleX(32);
      LangRect.Bottom := ScaleY(32);
      LangIcon := ExtractIcon(GetModuleHandle(0), ExpandConstant('{srcexe}'), 0);
      try
        with TBitmapImage.Create(LangDialogForm) do
        begin
          Parent := LangDialogForm;
          Left     := ScaleX(10);
          Top      := ScaleY(10);
          Width    := ScaleX(32);
          Height   := ScaleY(32);
          with Bitmap do
          begin
            Width := LangRect.Bottom;
            Height := LangRect.Right;
            Canvas.Brush.Color := LangDialogForm.Color;
            Canvas.FillRect(LangRect);
            DrawIconEx(Canvas.Handle, 0, 0, LangIcon, LangRect.Bottom, LangRect.Right, 0, 0, DI_NORMAL);
          end;
        end;
      finally
        DestroyIcon(LangIcon);
      end;
    except
    end;
    if (LangDialogForm.ShowModal = mrOk) then
    begin
      { Collect current instance parameters }
      for I := 1 to ParamCount do
      begin
        TmpStr := ParamStr(I);
        { Unique log file name for the elevated instance }
        if CompareText(Copy(TmpStr, 1, 5), '/LOG=') = 0 then
        begin
          TmpStr := TmpStr + '-localized';
        end;
        { Do not pass our /SL5 switch }
        if CompareText(Copy(TmpStr, 1, 5), '/SL5=') <> 0 then
        begin
          Params := Params + AddQuotes(TmpStr) + ' ';
        end;
      end;
      Params := Params + '/LANG=' + LangList[LangDialogComboBox.ItemIndex];
      Instance := ShellExecute(0, '', ExpandConstant('{srcexe}'), Params, '', SW_SHOW);
      if Instance <= 32 then
        MsgBox(Format('Running installer with selected language failed. Code: %d', [Instance]), mbError, MB_OK);
    end;
  finally
    LangDialogForm.Free();
    Result := False;
  end;
end;


const
  POWER_KB = 1;
  POWER_MB = 2;
  POWER_GB = 3;
  POWER_TB = 4;
  POWER_PB = 5;
  KFactor = 1024;


function FormatBytes(const Bytes: Extended; Offset: Integer; HideZero: Boolean): String;
var
  Idx: Byte;
  Amount: Extended;
  Dms: TArrayOfString;
begin
  Dms := ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
  Amount := Bytes;
  Idx := 0;
  while Amount > (0.9 * KFactor) do
  begin
    Idx := Idx + 1;
    Amount := Amount / KFactor;
  end;
  if Idx = 0 then
    Result := Format('%.0f %s', [Amount, Dms[Idx]])
  else
    Result := Format('%.' + IntToStr(Offset) + 'f %s', [Amount, Dms[Idx]]);
  if Result = '0 B' then
  begin
    if HideZero then
      Result := ''
    else
      Result := '0 Byte';
  end;
end;


function StrToFloatDef(S: String; Def: Extended): Extended;
begin
  if Trim(S) = '' then
    Result := Def
  else
    try
      Result := StrToFloat(S);
    except
      Result := Def;
    end;
end;


function PowerK(Value: Extended; Offset: Integer): Extended;
var
  I: Integer;
begin
  Result := Value;
  for I := 1 to Offset do
    Result := Result * KFactor;
end;


function GetSizeBytes(const Value: String; Default: Extended): Extended;
var
  I: Integer;
  Pt: Integer;
  TmpStr: String;
  Unity: String;
begin
  I := 1;
  Pt := 0;
  Unity := '';
  TmpStr := Trim(Value);
  StringChangeEx(TmpStr, ',', '.', True);
  while Length(TmpStr) >= I do {remove no numeric character}
  begin
    if StrToIntDef(TmpStr[I], 10) = 10 then
    begin
      if (Pt = 0) and (I > 1) and (TmpStr[I] = '.') then
      begin
        Inc(Pt);
        Inc(I);
      end else
      begin
        if (TmpStr[I] <> '.') and (TmpStr[I] <> ' ') and (Length(Unity) < 3) then
          Unity := Unity + TmpStr[I];
        Delete(TmpStr, I, 1)
      end;
    end else
      Inc(I);
  end;
  if TmpStr <> '' then
  begin
    SetLength(Unity, 2);
    case Trim(Uppercase(Unity)) of
      'PB', 'P' : Result := PowerK(StrToFloatDef(TmpStr, Default), POWER_PB);
      'TB', 'T' : Result := PowerK(StrToFloatDef(TmpStr, Default), POWER_TB);
      'GB', 'G' : Result := PowerK(StrToFloatDef(TmpStr, Default), POWER_GB);
      'MB', 'M' : Result := PowerK(StrToFloatDef(TmpStr, Default), POWER_MB);
      'KB', 'K' : Result := PowerK(StrToFloatDef(TmpStr, Default), POWER_KB);
      'BY', 'B' : Result := StrToFloatDef(TmpStr, Default);
      else begin
        if Pos('.', Copy(TmpStr, Pos('.', TmpStr), Length(TmpStr))) > 0 then
        begin
          StringChangeEx(TmpStr, '.', '', True);
          Result := StrToFloatDef(TmpStr, Default);
        end else
          Result := PowerK(StrToFloatDef(TmpStr, Default), POWER_MB);
      end;
    end;
  end else
    Result := Default;
end;


function FormatDiskSpaceLabel(Labl: String; Size: Extended): String;
begin
  Result := Labl;
  StringChangeEx(Result, '[mb] MB', '[size]', True)
  StringChangeEx(Result, '[size]', FormatBytes(Size, 2, True), True);
end;


function NumToStr(Float: Extended): string;
begin
  Result := Format('%.2n', [Float]);
  StringChange(Result, ',', '.');
  while ((Result[Length(Result)] = '0') or (Result[Length(Result)] = '.')) and (Pos('.', Result) > 0) do
    SetLength(Result, Length(Result)-1);
end;


function MbOrTb(Float: Extended): String;
begin
  if Float < KFactor then
    Result := NumToStr(Float) + ' MB'
  else
    if Float/KFactor < KFactor then
      Result := NumToStr(Float / KFactor) + ' GB'
    else
      Result := NumToStr(Float / (KFactor * KFactor)) + ' TB'
end;


procedure GetFreeSpaceCaption(Sender: TObject);
var
  Path: String;
begin
  InstallationSize := {#if UseComponents == "1"}ComponentsSize + {#endif}GetSizeBytes(GetIniString('Settings', 'Size', '0', ExpandConstant('{tmp}\Settings.ini')), 0);
  Path := ExtractFileDrive(WizardForm.DirEdit.Text);
  GetSpaceOnDisk(Path, True, FreeMB, TotalMB);
  #if CompactMode == "0"
    FreeSpaceLabel.Caption := ExpandConstant('{cm:FreeSpace}  ') + MbOrTb(FreeMB) + ' (' + IntToStr((FreeMB * 100) div TotalMB) + '%)';
    NeedSpaceLabel.Caption := ExpandConstant('{cm:NeedSpace}  ') + FormatBytes(InstallationSize, 2, True);
  #else
    FreeSpaceLabel.Caption := 'F: ' + MbOrTb(FreeMB) + ' (' + IntToStr((FreeMB * 100) div TotalMB) + '%)';
    NeedSpaceLabel.Caption := 'N: ' + FormatBytes(InstallationSize, 2, True);
  #endif
  if Extended(FreeMB) < Extended(InstallationSize / PowerK(1, POWER_MB)) then
  begin
    FreeSpaceLabel.Font.Color := clRed;
    WizardForm.NextButton.Enabled := False;
  end else
  begin
    FreeSpaceLabel.Font.Color := NeedSpaceLabel.Font.Color;
    WizardForm.NextButton.Enabled := True;
  end;
end;


#if Music == "1"
procedure MusicButtonClick(Sender: TObject);
begin
  case BASS_ChannelIsActive(SoundStream) of
    BASS_ACTIVE_PLAYING:
    begin
      if BASS_Pause then
        MusicButton.Caption := ExpandConstant('{cm:MusicButtonCaptionSoundOn}');
    end;
    BASS_ACTIVE_PAUSED:
    begin
      if BASS_Start then
        MusicButton.Caption := ExpandConstant('{cm:MusicButtonCaptionSoundOff}');
    end;
  end;
end;
#endif


procedure PauseButtonClick(Sender: TObject);
begin
  if PauseCB.Checked then
  begin
    PauseButton.Caption := ExpandConstant('{cm:Pause}');
    ResumeProc;
  end else
  begin
    PauseButton.Caption := ExpandConstant('{cm:Resume}');
    SuspendProc;
  end;
  PauseCB.Checked := not PauseCB.Checked;
end;


#if (CompactMode == "0") && (UseInstallBackground == "1")
  procedure BackgroundButtonClick(Sender: TObject);
  begin
    if BackgroundCB.Checked then
    begin
      BackgroundButton.Caption := ExpandConstant('{cm:BackgroundON}');
      BackgroundForm.Show;
      WizardForm.BringToFront;
    end else
    begin
      BackgroundButton.Caption := ExpandConstant('{cm:BackgroundOFF}');
      BackgroundForm.Hide;
    end;
    BackgroundCB.Checked := not BackgroundCB.Checked;
  end;
#endif


#if UseComponents == "1"
  procedure ComponentsOnCheck(Sender: TObject);
  var
    I: Integer;
  begin
    ComponentsSize := 0;
    for I := 0 to GetArrayLength(CompIndexList) - 1 do
      if ComponentsList.Checked[CompIndexList[I]] then
        ComponentsSize := ComponentsSize + GetSizeBytes(GetIniString('ComponentsSettings', 'Component' + IntToStr(CompIndexList[I]) + '.Size', '0', ExpandConstant('{tmp}\Settings.ini')), ComponentsSize);
    ComponentsDiskSpaceLabel.Caption := FormatDiskSpaceLabel(SetupMessage(msgComponentsDiskSpaceMBLabel), ComponentsSize + GetSizeBytes(GetIniString('Settings', 'Size', '0', ExpandConstant('{tmp}\Settings.ini')), ComponentsSize));
    ComponentsDiskSpaceLabel.Refresh;
  end;


  function TranslateComponentName(StrName: String): String;
  begin
    case Trim(Uppercase(Copy(StrName, Pos('cm:', LowerCase(StrName)) + Length('cm:'), Length(StrName)))) of
      'EN', 'ENGLISH'   : Result := CustomMessage('CompEnglish');
      'FR', 'FRENCH'    : Result := CustomMessage('CompFrench');
      'DE', 'GERMAN'    : Result := CustomMessage('CompGerman');
      'IT', 'ITALIAN'   : Result := CustomMessage('CompItalian');
      'ES', 'SPANISH'   : Result := CustomMessage('CompSpanish');
      'PL', 'POLISH'    : Result := CustomMessage('CompPolish');
      'RU', 'RUSSIAN'   : Result := CustomMessage('CompRussian');
      'BR', 'BRAZILIAN' : Result := CustomMessage('CompPortugueseBrazil');
      'MX', 'MEXICAN'   : Result := CustomMessage('CompMexican');
      'CZ', 'CZECH'     : Result := CustomMessage('CompCzech');
      else
        Result := StrName;
    end;
  end;


  function IsComponentSelectedByName(const Components: String): Boolean;
  var
    Y: Integer;
    Level: Integer;
    IsChecked: Boolean;
    TmpStr: String;
    Name: String;
  begin
    Result := False;
    if ComponentsPageAvai then
    begin
      if Pos('\', Components) > 0 then
      begin
        Y := 0;
        Level := 0;
        IsChecked := False;
        TmpStr := AddBackslash(Components);
        while (not IsChecked) and (Pos('\', TmpStr) > 0) do
        begin
          Name := Copy(TmpStr, 0, Pos('\', TmpStr) - 1);
          TmpStr := Copy(TmpStr, Pos('\', TmpStr) + 1, Length(TmpStr));
          if Pos('cm:', LowerCase(Name)) > 0 then
            Name := TranslateComponentName(Name);
          for Y := Y to ComponentsList.Items.Count - 1 do
          begin
            if (ComponentsList.ItemLevel[Y] = Level)
            and (CompareText(ComponentsList.ItemCaption[Y], Name) = 0) then
            begin
              if TmpStr = '' then
              begin
                Result := ComponentsList.Checked[Y];
                IsChecked := True;
              end;
              Inc(Level);
              Break;
            end;
          end;
        end;
      end else
      begin
        for Y := 0 to GetArrayLength(CompIndexList) - 1 do
          if CompareText(ComponentsList.ItemCaption[CompIndexList[Y]], Components) = 0 then
          begin
            Result := ComponentsList.Checked[CompIndexList[Y]];
            Break;
          end;
      end;
    end;
  end;


  function IsComponentSelectedByID(const ComponentsID: Integer): Boolean;
  var
    Y: Integer;
  begin
    Result := False;
    if ComponentsPageAvai then
    begin
      for Y := 0 to GetArrayLength(CompIndexList) - 1 do
        if (CompIndexList[Y] = ComponentsID) then
        begin
          Result := ComponentsList.Checked[CompIndexList[Y]];
          Break;
        end;
    end;
  end;
#endif


#if (CompactMode == "1") && (UseComponents == "1")
  procedure ComponentsPageClick(Sender: TObject);
  begin
    ComponentsPageVisible := (not ComponentsPageVisible);
    WizardForm.WelcomePage.Visible := (not ComponentsPageVisible);
    WizardForm.DirEdit.Visible := (not ComponentsPageVisible);
    WizardForm.DirBrowseButton.Visible := (not ComponentsPageVisible);
    WizardForm.NextButton.Visible := (not ComponentsPageVisible);
    WizardForm.ProgressGauge.Visible := (not ComponentsPageVisible);
    WizardForm.CancelButton.Visible := (not ComponentsPageVisible);
    FreeSpaceLabel.Visible := (not ComponentsPageVisible);
    NeedSpaceLabel.Visible := (not ComponentsPageVisible);
    PauseButton.Visible := (not ComponentsPageVisible);
    IconsCB.Visible := (not ComponentsPageVisible);
    UnInstallCB.Visible := (not ComponentsPageVisible);
    #if CheckCRC == "1"
      CRCCheckCB.Visible := (not ComponentsPageVisible);
    #endif
    SelectComponentsLabel.Visible := (not ComponentsPageVisible);
    #if Music == "1"
      MusicButton.Visible := (not ComponentsPageVisible);
    #endif
    #if UseRedists == "1"
      RedistCB.Visible := (not ComponentsPageVisible);
    #endif
    ComponentsList.Visible := ComponentsPageVisible;
    ComponentsDiskSpaceLabel.Visible := ComponentsDiskSpaceLabelVisible and ComponentsPageVisible;
    ComponentsOKButton.Visible := ComponentsPageVisible;
    GetFreeSpaceCaption(nil);
  end;
#endif


function CreateIcons: Boolean;
begin
  Result := IconsCB.Checked;
end;


{For uninstallable checkbox}
function IsUninstallable: Boolean;
begin
  Result := UninstallCB.Checked;
end;


{Checkbox for Start menu icon}
procedure StartMenuCBClick(Sender: TObject);
begin
  if StartMenuCB.Checked then
  begin
    WizardForm.GroupEdit.Enabled := False;
    WizardForm.GroupBrowseButton.Enabled := False;
  end else
  begin
    WizardForm.GroupEdit.Enabled := True;
    WizardForm.GroupBrowseButton.Enabled := True;
  end;
end;


{Centering for Welcome/Finish messages}
procedure Centering(Control: TControl);
begin
  if Assigned(Control) and Assigned(Control.Parent) then
  begin
    Control.Left := (ScaleX(Control.Parent.Width) - ScaleX(Control.Width)) div 2;
  end;
end;


{Website Button Action}
procedure WebsiteClick(Sender: TObject);
var
  ErrorCode: Integer;
begin
  ShellExec('open', '{#URL}', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;


#if VER >= 0x06000000
  const
    SWP_NOSIZE         = $0001;
    SWP_NOZORDER       = $0004;
    SWP_NOACTIVATE     = $0010;
    SWP_NOCOPYBITS     = $0100;
    SWP_NOSENDCHANGING = $0400;
    SWP_FLAGS = SWP_NOSENDCHANGING or SWP_NOCOPYBITS or SWP_NOACTIVATE or SWP_NOZORDER or SWP_NOSIZE;

  function SetWindowPos(hWnd: HWND; hWndInsertAfter: HWND; X, Y, cx, cy: Integer; uFlags: UINT): BOOL;
    external 'SetWindowPos@user32.dll stdcall delayload';

  const
    SPI_GETWORKAREA = $00000030;

  function SystemParametersInfo(uiAction, uiParam: LongWord; var pvParam: TRect; fWinIni: LongWord): BOOL;
    external 'SystemParametersInfoW@user32.dll stdcall delayload';


  procedure OpenBrowser(Url: string);
  var
    ErrorCode: Integer;
  begin
    ShellExec('open', Url, '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
  end;


  procedure AboutLinkClick(Sender: TObject);
  begin
    OpenBrowser('https://fileforums.com/showthread.php?t=99481');
  end;


  procedure AboutFormShow(Sender: TObject);
  var
    PosLeft, PosTop: Integer;
    WorkArea: TRect;
  begin
    SystemParametersInfo(SPI_GETWORKAREA, 0, WorkArea, 0);
    {set left position}
    PosLeft := ((WizardForm.Width - TSetupForm(Sender as TSetupForm).Width) div 2) + WizardForm.Left; {AFLeft}
    if PosLeft < 0 then
      PosLeft := 0
    else
    if PosLeft + TSetupForm(Sender as TSetupForm).Width > WorkArea.Right then
      PosLeft := WorkArea.Right - TSetupForm(Sender as TSetupForm).Width;
    {set top position}
    PosTop := ((WizardForm.Height - TSetupForm(Sender as TSetupForm).Height) div 2) + WizardForm.Top; {AFTop}
    if PosTop < 0 then
      PosTop := 0
    else
      if PosTop + TSetupForm(Sender as TSetupForm).Height > WorkArea.Bottom then
        PosTop := WorkArea.Bottom - TSetupForm(Sender as TSetupForm).Height;
    {apply new positions}
    SetWindowPos(TSetupForm(Sender as TSetupForm).Handle, 0, PosLeft, PosTop, 0, 0, SWP_FLAGS);
  end;


  {About Button Action}
  procedure AboutButtonClick(Sender: TObject);
  var
    AboutForm: TSetupForm;
    AboutOKButton: TNewButton;
    AboutLabel, AboutLink: TNewStaticText;
    LogoImage: TBitmapImage;
  begin
    AboutForm := CreateCustomForm();
    try
      AboutForm.ClientWidth := ScaleX(380);
      AboutForm.ClientHeight := ScaleY(280);
      AboutForm.Caption := SetupMessage(msgAboutSetupTitle);
      #if VER >= 0x06000000 /* Fix to Inno Setup 6 not compile this line (error) */
        AboutForm.OnShow := @AboutFormShow;
      #else
        AboutForm.CenterInsideControl(WizardForm, False);
      #endif

      AboutOKButton := TNewButton.Create(AboutForm);
      AboutOKButton.Parent := AboutForm;
      AboutOKButton.Width := ScaleX(75);
      AboutOKButton.Height := ScaleY(23);
      AboutOKButton.Left := AboutForm.ClientWidth - ScaleX(75 + 10);
      AboutOKButton.Top := AboutForm.ClientHeight - ScaleY(23 + 10);
      AboutOKButton.Caption := SetupMessage(msgButtonOK);
      AboutOKButton.ModalResult := mrOk;
      AboutOKButton.Default := True;

      AboutLabel := TNewStaticText.Create(AboutForm);
      AboutLabel.Parent := AboutForm;
      AboutLabel.Left := ScaleX(5);
      AboutLabel.Top  := ScaleY(160);
      AboutLabel.Width := ScaleX(370);
      AboutLabel.Height := ScaleY(100);
      AboutLabel.Font.Style := [fsBold];
      AboutLabel.Font.Size := 12;
      AboutLabel.Caption := 'Advanced Simple Installer Script v{#Scriptversion}'
                            + #13#10 + 'by Knabberfee + Simorq'
                            + #13#10 + ''
                            + #13#10 + 'Conversion/Repack by {#Creator}';

      AboutLink := TNewStaticText.Create(AboutForm);
      AboutLink.Parent := AboutForm;
      AboutLink.Left := ScaleX(5);
      AboutLink.Top  := ScaleY(260);
      AboutLink.Width := ScaleX(370);
      AboutLink.Height := ScaleY(100);
      AboutLink.Font.Style := [fsBold, fsUnderline];
      AboutLink.Font.Size := 10;
      AboutLink.Font.Color := clFuchsia;
      AboutLink.Cursor := crHand;
      AboutLink.Caption := 'Forum';
      AboutLink.OnClick := @AboutLinkClick;

      ExtractTemporaryFile('Logo2.bmp');
      LogoImage := TBitmapImage.Create(WizardForm);
      with LogoImage do begin
        Name             := 'LogoImage';
        Parent           := AboutForm;
        Left             := ScaleX(5);
        Top              := ScaleY(5);
        Width            := ScaleX(373);
        Height           := ScaleY(149);
        //Bitmap.AlphaFormat := afDefined;
        Bitmap.LoadFromFile(ExpandConstant('{tmp}\Logo2.bmp'));
        ReplaceColor := $0000ff
        ReplaceWithColor := AboutForm.Color
      end;
      AboutForm.ShowModal()
    finally
      AboutForm.Free();
    end;
  end;


  procedure InfoFormShow(Sender: TObject);
  var
    PosLeft, PosTop: Integer;
    WorkArea: TRect;
  begin
    SystemParametersInfo(SPI_GETWORKAREA, 0, WorkArea, 0);
    {set left position}
    PosLeft := ((WizardForm.Width - TSetupForm(Sender as TSetupForm).Width) div 2) + WizardForm.Left; {AFLeft}
    if PosLeft < 0 then
      PosLeft := 0
    else
    if PosLeft + TSetupForm(Sender as TSetupForm).Width > WorkArea.Right then
      PosLeft := WorkArea.Right - TSetupForm(Sender as TSetupForm).Width;
    {set top position}
    PosTop := ((WizardForm.Height - TSetupForm(Sender as TSetupForm).Height) div 2) + WizardForm.Top; {AFTop}
    if PosTop < 0 then
      PosTop := 0
    else
      if PosTop + TSetupForm(Sender as TSetupForm).Height > WorkArea.Bottom then
        PosTop := WorkArea.Bottom - TSetupForm(Sender as TSetupForm).Height;
    {apply new positions}
    SetWindowPos(TSetupForm(Sender as TSetupForm).Handle, 0, PosLeft, PosTop, 0, 0, SWP_FLAGS);
  end;


  procedure InfoButtonClick(Sender: TObject);
  var
    InfoForm: TSetupForm;
    InfoOKButton: TNewButton;
    InfoBeforeMemo: TNewMemo;
  begin
    InfoForm := CreateCustomForm();
    try
      InfoForm.ClientWidth := ScaleX(700);
      InfoForm.ClientHeight := ScaleY(400);
      InfoForm.Caption := SetupMessage(msgWizardInfoAfter);
      #if VER >= 0x06000000 /* Fix to Inno Setup 6 not compile this line (error) */
        InfoForm.OnShow := @InfoFormShow;
      #else
        InfoForm.CenterInsideControl(WizardForm, False);
      #endif

      WizardForm.InfoBeforeMemo.Visible := False;

      InfoBeforeMemo := TNewMemo.Create(WizardForm);
      with InfoBeforeMemo do
      begin
        Parent     := InfoForm;
        Left       := ScaleX(27);
        Top        := ScaleY(30);
        Width      := ScaleX(646);
        Height     := ScaleY(311);
        Color      := TColor($d3d3d3);
        Font.Color := clBlack;
        ScrollBars := ssVertical;
        Text       := WizardForm.InfoBeforeMemo.Text;
        ReadOnly   := True;
      end;

      InfoOKButton := TNewButton.Create(InfoForm);
      InfoOKButton.Parent := InfoForm;
      InfoOKButton.Width := ScaleX(75);
      InfoOKButton.Height := ScaleY(23);
      InfoOKButton.Left := ScaleX(598);
      InfoOKButton.Top := ScaleY(358);
      InfoOKButton.Caption := SetupMessage(msgButtonOK);
      InfoOKButton.ModalResult := mrOk;
      InfoOKButton.Default := True;

      InfoForm.ShowModal()
    finally
      InfoForm.Free();
    end;
  end;
#endif


{DPI Calculator by Yener90}
function DPICalculator(Value: Integer): Integer;
var
  SystemDPI: DWORD;
begin
  if not RegQueryDWordValue(HKCU, 'Control Panel\Desktop', 'LogPixels', SystemDPI) then
    SystemDPI := 96;
  Result := ((96 * 100 / SystemDPI) * Value) / 100;
end;


{Color Converter from BGR to RGB by BAMsE}
function GetValInt(Section, Key: String; Default: Integer): Integer;
begin
  Result := GetIniInt(Section, Key, Default, 0, 0, ExpandConstant('{tmp}\Settings.ini'));
end;


function ColorConverter(InputColor: Integer): Integer;
var
  TmpStr: String;
  i: Integer;
begin
  SetLength(TmpStr, 6);
  for i := 6 downto 1 do
  begin
    TmpStr[i] := '0123456789ABCDEF'[(InputColor and 15) + 1];
    InputColor := InputColor shr 4;
  end;
  while InputColor <> 0 do  
  begin
    TmpStr := '0123456789ABCDEF[(InputColor and 15) + 1]' + TmpStr; {errate - this part not work}
    InputColor := InputColor shr 4;
  end;
  Result := StrToInt('$' + (Copy(TmpStr, 5, 2) + Copy(TmpStr, 3, 2) + Copy(TmpStr, 1, 2)));
end;


#if CheckCRC == "1"
  procedure ProcessMessages(var msg: TMsg);
  begin
    while PeekMessage(msg, 0, 0, 0, PM_REMOVE) do
    begin
      if msg.message = WM_QUIT then break;
      TranslateMessage(msg);
      DispatchMessage(msg);
    end;
  end;


  function KborMborGb(num: extended): ansistring;
  begin
    if num >= (1024*1024*1024) then Result := format('%.2n',[num/(1024*1024*1024)])+' Gb'
      else if num >= (1024*1024) then Result := format('%.2n',[num/(1024*1024)])+' Mb' else
        Result := format('%.2n',[num/1024])+' Kb';
  end;


  function HandleHashes(Filename: Pansichar; FileSize: Extended; FileProgress, TotalFiles, FilesProcessed, StatusCode: Integer): Boolean;
  begin
    case StatusCode of
    DCP_HASH_OK:
        begin
        CRCInfoMemo.Lines.Add(Filename+' ... ' + ExpandConstant('{cm:Hashok}'));
        Inc(FileOK);
        end;
    DCP_FILE_NOT_FOUND:
        begin
        CRCInfoMemo.Lines.Add(Filename+' ... ' + ExpandConstant('{cm:nofile}'));
        Inc(MissingFile);
        end;
    DCP_FILE_HASHING_ABORTED:
        begin
        CRCInfoMemo.Lines.Add(ExpandConstant('{cm:abort}'));
        end;
    DCP_BAD_FILE_HASH:
        begin
        CRCInfoMemo.Lines.Add(Filename+' ... ' + ExpandConstant('{cm:badhash}'));
        Inc(BadFile);
        end;
    DCP_ERROR_GENERAL:
        begin
        CRCInfoMemo.Lines.Add(Filename+' ... ' + ExpandConstant('{cm:generalerr}'));
        end;
    end;
        HashHdrLabel.Caption := ExpandConstant('{cm:Title} ')+Inttostr(round(FilesProcessed*100/TotalFiles))+'%';
        HashProgressBar1.Position := FileProgress;
        HashProgressBar2.Position := round(FilesProcessed*1000/TotalFiles);
        CheckFileLabel.caption := FmtMessage(ExpandConstant('{cm:Label1}'),[Filename,KborMborGb(filesize/100*fileprogress/10),KborMborGb(FileSize)])+' '+inttostr(round(FileProgress/10))+'%';
        OveralCheckLabel.caption := FmtMessage(ExpandConstant('{cm:Label2}'),[inttostr(TotalFiles),inttostr(FilesProcessed),inttostr(FileOK),inttostr(MissingFile),inttostr(BadFile)]);

    ProcessMessages(msg);
    Result := ContinueHash;
  end;


  procedure HandleBtn(sender: TObject);
  begin
    case TNewButton(Sender).Caption of
      ExpandConstant('{cm:verfiles}'):
      begin
        Checked := True;
        CRCCancelButton.Caption := SetupMessage(msgButtonCancel);
        CheckHashesFromFile(ExpandConstant('{tmp}\{#CRCFileName}'),ExpandConstant('{app}'),@HandleHashes,True);
        WizardForm.NextButton.Enabled := Checked;
        CRCCancelButton.Enabled := not Checked;
        LogButton.Enabled := Checked;
        CRCLogMemo.Lines.LoadFromFile(ExpandConstant('{tmp}\Hashes.log'));
      end;

      SetupMessage(msgButtonCancel):
      begin
        LogButton.Enabled := Checked;
        WizardForm.NextButton.Enabled := Checked;
        CRCCancelButton.Enabled := not Checked;
        ContinueHash := not Checked;
      end;
  end;
  end;


  procedure HandleLog(sender: TObject);
  begin
     case TNewButton(Sender).Caption of
      ExpandConstant('{cm:logcapt}'):
        begin
          CRCLogMemo.Show;
          CRCInfoMemo.Hide;
          LogButton.Caption := ExpandConstant('{cm:info}');
        end;

      ExpandConstant('{cm:info}'):
        begin
          CRCLogMemo.Hide;
          CRCInfoMemo.Show;
          LogButton.Caption := ExpandConstant('{cm:logcapt}');
        end;
  end;
  end;
#endif


#if (CompactMode == "0") && (UseSystemReq == "1")
  procedure SystemReq();
  var
    RemoveRunningLabel: String;
    HWScore: Integer;
  begin
    Processor     := {#Processor};
    VideoRam      := {#VideoRAM};
    Ram           := {#RAM};
    OpSystem      := {#OS}
    DirectX       := {#DX};
    SystemReqPage := CreateCustomPage(wpInfoBefore, '', '');
    RemoveRunningLabel := GetGpuName;
    StringChangeEx(RemoveRunningLabel, 'x 1 (Running)', '', true);

    with SystemReqPage.Surface do
    begin
      Name := 'SystemReqPage';
    end;

    SystemReqImage := TBitmapImage.Create(WizardForm);
    with SystemReqImage do
    begin
      Name   := 'SystemReqImage';
      Parent := SystemReqPage.Surface;
      Stretch := True;
      AutoSize := False;
      Left   := ScaleX(0);
      Top    := ScaleY(0);
      Width  := ScaleX(32);
      Height := ScaleY(32);
      ExtractTemporaryFile('SystemReqImage.bmp');
      Bitmap.AlphaFormat := afDefined;
      Bitmap.LoadFromFile(ExpandConstant('{tmp}\SystemReqImage.bmp'));
//      ReplaceColor := $0000ff;
//      ReplaceWithColor := SystemReqPage.Surface.Color;
    end;

    SysReqCheckLabel := TNewStaticText.Create(WizardForm);
    with SysReqCheckLabel do
    begin
      Name     := 'SysReqCheckLabel';
      Parent   := SystemReqPage.Surface;
      WordWrap := True;
      Caption  := ExpandConstant('{cm:SystemReqLabel1}');
//      Left     := SystemReqImage.Left + 42;
//      Top      := ScaleY(0);
      Left     := WizardForm.PageDescriptionLabel.Left;
      Top      := WizardForm.SelectDirLabel.Top;
      Width    := ScaleX(488);
      Height   := ScaleY(50);
    end;

    IfReadyLabel := TNewStaticText.Create(WizardForm);
    with IfReadyLabel do
    begin
      Name    := 'IfReadyLabel';
      Parent  := SystemReqPage.Surface;
      Caption := WizardForm.InfoBeforeClickLabel.Caption;
      Left    := ScaleX(0);
      Top     := ScaleY(216);
      Width   := ScaleX(400);
      Height  := ScaleY(14);
    end;

    HardwareDetectLabel := TNewStaticText.Create(WizardForm);
    with HardwareDetectLabel do
    begin
      Name    := 'HardwareDetectLabel';
      Parent  := SystemReqPage.Surface;
      Caption := ExpandConstant('{cm:SystemReqLabel2}');
      Left    := ScaleX(0);
      Top     := ScaleY(56);
      Width   := ScaleX(287);
      Height  := ScaleY(14);
    end;

    Case1 := TPanel.Create(WizardForm);
    with Case1 do
    begin
      Name       := 'Case1';
      Parent     := SystemReqPage.Surface;
      Left       := ScaleX(0);
      Top        := ScaleY(80);
      Width      := ScaleX(520);
      Height     := ScaleY(150);
      BevelInner := bvNone;
      BevelOuter := bvLowered;
      Color      := clWindow;
      ParentBackground := False;
      Caption := '';
    end;

    //////////////////////////// PROCESSOR ////////////////////////////
    ProcessorBevel := TBevel.Create(WizardForm);
    with ProcessorBevel do
    begin
      Name   := 'ProcessorBevel';
      Parent := Case1;
      Left   := ScaleX(8);
      Top    := ScaleY(8);
      Width  := ScaleX(74);
      Height := ScaleY(18);
      Shape  := bsFrame;
    end;

    CPULabel := TLabel.Create(WizardForm);
    with CPULabel do
    begin
      AutoSize    := False;
      Left        := ScaleX(12);
      Top         := ScaleY(10);
      Width       := ScaleX(68);
      Height      := ScaleY(14);
      Transparent := True;
      Font.Style  := [fsBold];
      Font.Color  := ColorConverter(GetValInt('SystemRequirement', 'HWSectionLabelColor', 0));
      Caption     := 'CPU';
      Parent      := Case1;
    end;

    ProcessorNameBevel := TBevel.Create(WizardForm);
    with ProcessorNameBevel do
    begin
      Name   := 'ProcessorNameBevel';
      Parent := Case1;
      Left   := ScaleX(96);
      Top    := ScaleY(8);
      Width  := ScaleX(329);
      Height := ScaleY(18);
      Shape  := bsFrame;
    end;

    CPUNameLabel := TLabel.Create(SystemReqPage);
    with CPUNameLabel do
    begin
      AutoSize    := False;
      Left        := ScaleX(100);
      Top         := ScaleY(10);
      Width       := ScaleX(410);
      Height      := ScaleY(14);
      Transparent := True;
      Font.Color  := ColorConverter(GetValInt('SystemRequirement', 'HWOkLabelColor', 0));
      Caption     := GetCpuName;
      Parent      := Case1;
    end;

    if (GetCpuMaxClockSpeed) < Processor then
    begin
      CPUNameLabel.Font.Color := ColorConverter(GetValInt('SystemRequirement', 'HWNotOkLabelColor', 0));
      CPUNameLabel.Caption := 'CPU: '+IntToStr(GetCpuMaxClockSpeed)+' MHz,' + (ExpandConstant('  {cm:DirectXNeeded} ')) + '{#Processor}'+' MHz';
    end;

    CPUMHZBevel := TBevel.Create(WizardForm);
    with CPUMHZBevel do
    begin
      Name   := 'CPUMHZBevel';
      Parent := Case1;
      Left   := ScaleX(439);
      Top    := ScaleY(8);
      Width  := ScaleX(74);
      Height := ScaleY(18);
      Shape  := bsFrame;
    end;

    CPUGHZLabel := TLabel.Create(SystemReqPage);
    with CPUGHZLabel do
    begin
      AutoSize    := False;
      Left        := ScaleX(443);
      Top         := ScaleY(10);
      Width       := ScaleX(66);
      Height      := ScaleY(14);
      Transparent := True;
      Font.Color  := ColorConverter(GetValInt('SystemRequirement', 'HWOkLabelColor', 0));
      Caption     := IntToStr(GetCpuMaxClockSpeed)+' MHz';
      Parent      := Case1;
    end;

    if (GetCpuMaxClockSpeed) < Processor then
    begin
      CPUGHZLabel.Font.Color := ColorConverter(GetValInt('SystemRequirement', 'HWNotOkLabelColor', 0));
      CPUGHZLabel.Caption := IntToStr(GetCpuMaxClockSpeed)+' MHz';
    end;


    //////////////////////////// VIDEO CARD ////////////////////////////
    VideoCardBevel := TBevel.Create(WizardForm);
    with VideoCardBevel do
    begin
      Name   := 'VideoCardBevel';
      Parent := Case1;
      Left   := ScaleX(8);
      Top    := ScaleY(32);
      Width  := ScaleX(74);
      Height := ScaleY(18);
      Shape  := bsFrame;
    end;

    GPULabel := TLabel.Create(SystemReqPage);
    with GPULabel do
    begin
      AutoSize    := False;
      Left        := ScaleX(12);
      Top         := ScaleY(34);
      Width       := ScaleX(68);
      Height      := ScaleY(14);
      Transparent := True;
      Font.Style  := [fsBold];
      Font.Color  := ColorConverter(GetValInt('SystemRequirement', 'HWSectionLabelColor', 0));
      Caption     := 'GPU';
      Parent      := Case1;
    end;

    VideoCardNameBevel := TBevel.Create(WizardForm);
    with VideoCardNameBevel do
    begin
      Name   := 'VideoCardNameBevel';
      Parent := Case1;
      Left   := ScaleX(96);
      Top    := ScaleY(32);
      Width  := ScaleX(329);
      Height := ScaleY(18);
      Shape  := bsFrame;
    end;

    GPUNameLabel := TLabel.Create(SystemReqPage);
    with GPUNameLabel do
    begin
      AutoSize    := False;
      Left        := ScaleX(100);
      Top         := ScaleY(34);
      Width       := ScaleX(410);
      Height      := ScaleY(14);
      Transparent := True;
      Font.Color  := ColorConverter(GetValInt('SystemRequirement', 'HWOkLabelColor', 0));
      Caption     := RemoveRunningLabel;
      Parent      := Case1;
    end;

    if GetGpuVRam < VideoRam then
    begin
      GPUNameLabel.Font.Color := ColorConverter(GetValInt('SystemRequirement', 'HWNotOkLabelColor', 0));
      GPUNameLabel.Caption := 'GPU: '+IntToStr(GetGpuVRam)+' MB,' + (ExpandConstant('  {cm:DirectXNeeded} ')) + '{#VideoRAM}'+' MB';
    end;

    GPUMHZBevel := TBevel.Create(WizardForm);
    with GPUMHZBevel do
    begin
      Name   := 'GPUMHZBevel';
      Parent := Case1;
      Left   := ScaleX(439);
      Top    := ScaleY(32);
      Width  := ScaleX(74);
      Height := ScaleY(18);
      Shape  := bsFrame;
    end;

    GPUGHZLabel := TLabel.Create(SystemReqPage);
    with GPUGHZLabel do
    begin
      AutoSize    := False;
      Left        := ScaleX(443);
      Top         := ScaleY(34);
      Width       := ScaleX(66);
      Height      := ScaleY(14);
      Transparent := True;
      Font.Color  := ColorConverter(GetValInt('SystemRequirement', 'HWOkLabelColor', 0));
      Caption     := IntToStr(GetGpuVRam)+' MB';
      Parent      := Case1;
    end;

    if GetGpuVRam < VideoRam then
    begin
      GPUGHZLabel.Font.Color := ColorConverter(GetValInt('SystemRequirement', 'HWNotOkLabelColor', 0));
      GPUGHZLabel.Caption := IntToStr(GetGpuVRam)+' MB';
    end;


    //////////////////////////// RAM ////////////////////////////
    RAMBevel := TBevel.Create(WizardForm);
    with RAMBevel do
    begin
      Name   := 'RAMBevel';
      Parent := Case1;
      Left   := ScaleX(8);
      Top    := ScaleY(80);
      Width  := ScaleX(74);
      Height := ScaleY(18);
      Shape  := bsFrame;
    end;

    RAMLabel := TLabel.Create(SystemReqPage);
    with RAMLabel do
    begin
      AutoSize    := False;
      Left        := ScaleX(12);
      Top         := ScaleY(82);
      Width       := ScaleX(68);
      Height      := ScaleY(14);
      Transparent := True;
      Font.Style  := [fsBold];
      Font.Color  := ColorConverter(GetValInt('SystemRequirement', 'HWSectionLabelColor', 0));
      Caption     := 'RAM';
      Parent      := Case1;
    end;

    RAMTotalBevel := TBevel.Create(WizardForm);
    with RAMTotalBevel do
    begin
      Name   := 'RAMTotalBevel';
      Parent := Case1;
      Left   := ScaleX(96);
      Top    := ScaleY(80);
      Width  := ScaleX(417);
      Height := ScaleY(18);
      Shape  := bsFrame;
    end;

    TotalRAMLabel := TLabel.Create(SystemReqPage);
    with TotalRAMLabel do
    begin
      AutoSize    := False;
      Left        := ScaleX(100);
      Top         := ScaleY(82);
      Width       := ScaleX(410);
      Height      := ScaleY(14);
      Transparent := True;
      Font.Color  := ColorConverter(GetValInt('SystemRequirement', 'HWOkLabelColor', 0));
      Caption     := IntToStr(GetTotalVisibleMemory + 1) + ' MB';
      Parent      := Case1;
    end;

    if (GetTotalVisibleMemory + 1) < RAM then
    begin
      TotalRAMLabel.Font.Color := ColorConverter(GetValInt('SystemRequirement', 'HWNotOkLabelColor', 0));
      TotalRAMLabel.Caption := 'RAM: '+IntToStr(GetTotalVisibleMemory)+' MB,' + (ExpandConstant('  {cm:DirectXNeeded} ')) + '{#RAM}'+' MB';
    end;


    //////////////////////////// DirectX ////////////////////////////
    DirectXBevel := TBevel.Create(WizardForm);
    with DirectXBevel do
    begin
      Name   := 'DirectXBevel';
      Parent := Case1;
      Left   := ScaleX(8);
      Top    := ScaleY(56);
      Width  := ScaleX(74);
      Height := ScaleY(18);
      Shape  := bsFrame;
    end;

    DirectXLabel := TLabel.Create(SystemReqPage);
    with DirectXLabel do
    begin
      AutoSize    := False;
      Left        := ScaleX(12);
      Top         := ScaleY(58);
      Width       := ScaleX(67);
      Height      := ScaleY(14);
      Transparent := True;
      Font.Style  := [fsBold];
      Font.Color  := ColorConverter(GetValInt('SystemRequirement', 'HWSectionLabelColor', 0));
      Caption     := 'DirectX';
      Parent      := Case1;
    end;

    DirectXVersionBevel := TBevel.Create(WizardForm);
    with DirectXVersionBevel do
    begin
      Name   := 'SoundCardNameBevel';
      Parent := Case1;
      Left   := ScaleX(96);
      Top    := ScaleY(56);
      Width  := ScaleX(417);
      Height := ScaleY(18);
      Shape  := bsFrame;
    end;

    DX := Round(GetDirectXVersion(Dx_gpu));

    DirectXVersionLabel := TLabel.Create(SystemReqPage);
    with DirectXVersionLabel do
    begin
      AutoSize    := False;
      Left        := ScaleX(100);
      Top         := ScaleY(58);
      Width       := ScaleX(410);
      Height      := ScaleY(14);
      Transparent := True;
      Font.Color  := ColorConverter(GetValInt('SystemRequirement', 'HWOkLabelColor', 0));
      Caption     := IntToStr(DX)
      Parent      := Case1;
    end;

    if (DX) < DirectX then
    begin
      DirectXVersionLabel.Font.Color := ColorConverter(GetValInt('SystemRequirement', 'HWNotOkLabelColor', 0));
      DirectXVersionLabel.Caption := 'DirectX: '+IntToStr(DX) + (ExpandConstant('  {cm:DirectXNeeded} ')) + '{#DX}'
    end;


    //////////////////////////// SYSTEM ////////////////////////////
    SystemBevel := TBevel.Create(WizardForm);
    with SystemBevel do
    begin
      Name   := 'SystemBevel';
      Parent := Case1;
      Left   := ScaleX(8);
      Top    := ScaleY(104);
      Width  := ScaleX(74);
      Height := ScaleY(18);
      Shape  := bsFrame;
    end;

    SystemLabel := TLabel.Create(SystemReqPage);
    with SystemLabel do
    begin
      AutoSize    := False;
      Left        := ScaleX(12);
      Top         := ScaleY(106);
      Width       := ScaleX(68);
      Height      := ScaleY(14);
      Transparent := True;
      Font.Style  := [fsBold];
      Font.Color  := ColorConverter(GetValInt('SystemRequirement', 'HWSectionLabelColor', 0));
      Caption     := 'System';
      Parent      := Case1;
    end;

    SystemNameBevel := TBevel.Create(WizardForm);
    with SystemNameBevel do
    begin
      Name   := 'SystemNameBevel';
      Parent := Case1;
      Left   := ScaleX(96);
      Top    := ScaleY(104);
      Width  := ScaleX(417);
      Height := ScaleY(18);
      Shape  := bsFrame;
    end;

    SystemNameLabel := TLabel.Create(SystemReqPage);
    with SystemNameLabel do
    begin
      AutoSize    := False;
      Left        := ScaleX(100);
      Top         := ScaleY(106);
      Width       := ScaleX(410);
      Height      := ScaleY(14);
      Transparent := True;
      Font.Color  := ColorConverter(GetValInt('SystemRequirement', 'HWOkLabelColor', 0));
      Caption     := GetOSName+' ('+IntToStr(GetOSArchitecture)+' Bit)';
      Parent      := Case1;
    end;

    OSNumber := StrToInt(IntToStr(GetOSVersionMajor)+IntToStr(GetOSVersionMinor)+IntToStr(GetServicePackMajorVersion));

    if not (OSNumber >= {#OS}) then
    begin
      SystemNameLabel.Font.Color := ColorConverter(GetValInt('SystemRequirement', 'HWNotOkLabelColor', 0));
    end;


    //////////////////////// HW CHECK LABEL ////////////////////////
    HwLabel := TLabel.Create(SystemReqPage);
    with HwLabel do
    begin
      Parent      := Case1;
      AutoSize    := False;
      Left        := ScaleX(8);
      Top         := ScaleY(130);
      Width       := ScaleX(505);
      Height      := ScaleY(14);
      Transparent := True;
      Font.Color  := clGreen;
      Font.Style  := [fsBold];
      Alignment   := taCenter;
    end;


    {Increase points if HW greater or equal}
    HWScore := 0;
    if (GetCpuMaxClockSpeed >= Processor) then Inc(HWScore);
    if (GetGpuVRam >= VideoRam) then Inc(HWScore);
    if ((GetTotalVisibleMemory + 1) >= RAM) then Inc(HWScore);
    if (DX >= DirectX) then Inc(HWScore);
    if (OSNumber >= {#OS}) then Inc(HWScore);

    case HWScore of
      5: begin
        HwLabel.Font.Color := ColorConverter(GetValInt('SystemRequirement', 'HWGoodLabelColor', 0));
        HwLabel.Caption := ExpandConstant('{cm:HwGood}');
      end;
      1..4: begin
        HwLabel.Font.Color := ColorConverter(GetValInt('SystemRequirement', 'HWPartiallyGoodLabelColor', 0));
        HwLabel.Caption := ExpandConstant('{cm:HwPartiallyGood}');
      end;
      0: begin
        HwLabel.Font.Color := ColorConverter(GetValInt('SystemRequirement', 'HWNotGoodLabelColor', 0));
        HwLabel.Caption := ExpandConstant('{cm:HwNotGood}');
      end;
    end;
  end;
#endif


{Controls for resizing wizard}
#if CompactMode == "0"
  procedure ShiftDown(Control: TControl; DeltaY: Integer);
  begin
    Control.Top := Control.Top + DeltaY;
  end;

  procedure ShiftRight(Control: TControl; DeltaX: Integer);
  begin
    Control.Left := Control.Left + DeltaX;
  end;

  procedure ShiftDownAndRight(Control: TControl; DeltaX, DeltaY: Integer);
  begin
    ShiftDown(Control, DeltaY);
    ShiftRight(Control, DeltaX);
  end;

  procedure GrowDown(Control: TControl; DeltaY: Integer);
  begin
    Control.Height := Control.Height + DeltaY;
  end;

  procedure GrowRight(Control: TControl; DeltaX: Integer);
  begin
    Control.Width := Control.Width + DeltaX;
  end;

  procedure GrowRightAndDown(Control: TControl; DeltaX, DeltaY: Integer);
  begin
    GrowRight(Control, DeltaX);
    GrowDown(Control, DeltaY);
  end;

  procedure GrowRightAndShiftDown(Control: TControl; DeltaX, DeltaY: Integer);
  begin
    GrowRight(Control, DeltaX);
    ShiftDown(Control, DeltaY);
  end;

  procedure GrowWizard(DeltaX, DeltaY: Integer);
  begin
    GrowRightAndDown(WizardForm, DeltaX, DeltaY);

    with WizardForm do
    begin
      GrowRightAndShiftDown(Bevel, DeltaX, DeltaY);
      ShiftDownAndRight(CancelButton, DeltaX, DeltaY);
      ShiftDownAndRight(NextButton, DeltaX, DeltaY);
      ShiftDownAndRight(BackButton, DeltaX, DeltaY);
      GrowRightAndDown(OuterNotebook, DeltaX, DeltaY);
      GrowRight(BeveledLabel, DeltaX);

      { WelcomePage }
      GrowDown(WizardBitmapImage, DeltaY);
      GrowRight(WelcomeLabel2, DeltaX);
      GrowRight(WelcomeLabel1, DeltaX);

      { InnerPage }
      GrowRight(Bevel1, DeltaX);
      GrowRightAndDown(InnerNotebook, DeltaX, DeltaY);

      { LicensePage }
      ShiftDown(LicenseNotAcceptedRadio, DeltaY);
      ShiftDown(LicenseAcceptedRadio, DeltaY);
      GrowRightAndDown(LicenseMemo, DeltaX, DeltaY);
      GrowRight(LicenseLabel1, DeltaX);

      { SelectDirPage }
      GrowRightAndShiftDown(DiskSpaceLabel, DeltaX, DeltaY);
      ShiftRight(DirBrowseButton, DeltaX);
      GrowRight(DirEdit, DeltaX);
      GrowRight(SelectDirBrowseLabel, DeltaX);
      GrowRight(SelectDirLabel, DeltaX);

      { SelectComponentsPage }
      GrowRightAndShiftDown(ComponentsDiskSpaceLabel, DeltaX, DeltaY);
      GrowRightAndDown(ComponentsList, DeltaX, DeltaY);
      GrowRight(TypesCombo, DeltaX);
      GrowRight(SelectComponentsLabel, DeltaX);

      { SelectTasksPage }
      GrowRightAndDown(TasksList, DeltaX, DeltaY);
      GrowRight(SelectTasksLabel, DeltaX);

      { ReadyPage }
      GrowRightAndDown(ReadyMemo, DeltaX, DeltaY);
      GrowRight(ReadyLabel, DeltaX);

      { InstallingPage }
      GrowRight(FilenameLabel, DeltaX);
      GrowRight(StatusLabel, DeltaX);
      GrowRight(ProgressGauge, DeltaX);

      { MainPanel }
      GrowRight(Mainpanel, DeltaX);
      ShiftRight(WizardSmallBitmapImage, DeltaX);
      GrowRight(PageDescriptionLabel, DeltaX);
      GrowRight(PageNameLabel, DeltaX);

      { FinishedPage }
      GrowDown(WizardBitmapImage2, DeltaY);
      GrowRight(RunList, DeltaX);
      GrowRight(FinishedLabel, DeltaX);
      GrowRight(FinishedHeadingLabel, DeltaX);
    end;
  end;

  procedure GrowBannerImage(DeltaX, DeltaY: Integer);
  begin
    GrowRightAndDown(WizardForm.MainPanel, DeltaX, DeltaY);
    GrowRightAndShiftDown(WizardForm.MainPanel, DeltaX, DeltaY);
  end;
#endif


procedure InitializeWizard();
var
  IniFile: String;
  #if CompactMode == "0"
    WillkommenLabel1, WillkommenLabel2,
    FertigLabel1, FertigLabel2: TLabel;
  #endif
  #if UseComponents == "1"
    CompName: String;
    I, Y: Integer;
  #endif
  #if VER >= 0x06000000
    X: Integer;
  #endif
begin
  ExtractTemporaryFile('Settings.ini');
  #if VER >= 0x06000000 /* if inno setup 6 or newer */
    WizardForm.CancelButton.Top := WizardForm.NextButton.Top;
    for X := 0 to WizardForm.ComponentCount - 1 do
    begin
      if WizardForm.Components[X] is TNewButton then
        TNewButton(WizardForm.Components[X]).Anchors := [akLeft, akTop]
      else if WizardForm.Components[X] is TNewNotebook then
        TNewNotebook(WizardForm.Components[X]).Anchors := [akLeft, akTop]
      else if WizardForm.Components[X] is TNewStaticText then
        TNewStaticText(WizardForm.Components[X]).Anchors := [akLeft, akTop]
      else if WizardForm.Components[X] is TEdit then
        TEdit(WizardForm.Components[X]).Anchors := [akLeft, akTop]
      else if WizardForm.Components[X] is TNewEdit then
        TNewEdit(WizardForm.Components[X]).Anchors := [akLeft, akTop]
      else if WizardForm.Components[X] is TNewCheckBox then
        TNewCheckBox(WizardForm.Components[X]).Anchors := [akLeft, akTop]
      else if WizardForm.Components[X] is TPasswordEdit then
        TPasswordEdit(WizardForm.Components[X]).Anchors := [akLeft, akTop]
      else if WizardForm.Components[X] is TNewMemo then
        TNewMemo(WizardForm.Components[X]).Anchors := [akLeft, akTop]
      else if WizardForm.Components[X] is TNewComboBox then
        TNewComboBox(WizardForm.Components[X]).Anchors := [akLeft, akTop]
      else if WizardForm.Components[X] is TBevel then
        TBevel(WizardForm.Components[X]).Anchors := [akLeft, akTop]
      else if WizardForm.Components[X] is TBitmapImage then
        TBitmapImage(WizardForm.Components[X]).Anchors := [akLeft, akTop]
      else if WizardForm.Components[X] is TNewRadioButton then
        TNewRadioButton(WizardForm.Components[X]).Anchors := [akLeft, akTop]
      else if WizardForm.Components[X] is TNewCheckListBox then
        TNewCheckListBox(WizardForm.Components[X]).Anchors := [akLeft, akTop]
      else if WizardForm.Components[X] is TNewProgressBar then
        TNewProgressBar(WizardForm.Components[X]).Anchors := [akLeft, akTop]
      else if WizardForm.Components[X] is TRichEditViewer then
        TRichEditViewer(WizardForm.Components[X]).Anchors := [akLeft, akTop]
      else if WizardForm.Components[X] is TPanel then
        TPanel(WizardForm.Components[X]).Anchors := [akLeft, akTop];
    end;
  #endif
  #if UseComponents == "1"
    ComponentsSize := 0;
  #endif
  IniFile := ExpandConstant('{tmp}\Settings.ini');
  #if Music == "1"
    ExtractTemporaryFile('{#MusicFile}');
    if BASS_Init(-1, 44100, 0, 0, 0) then
    begin
      SoundStream := BASS_StreamCreateFile(False,
      ExpandConstant('{tmp}\{#MusicFile}'), 0, 0, 0, 0,
      EncodingFlag or BASS_SAMPLE_LOOP);
      BASS_SetConfig(BASS_CONFIG_GVOL_STREAM, 2500);
      BASS_ChannelPlay(SoundStream, False);
    end;
  #endif
  #if InternalRecords == "1"
    ExtractTemporaryFile('Records.ini');
  #endif
  #if UWPGame == "1"
    ExtractTemporaryFile('UWP_Tool.exe');
  #endif
  #if Splash == "1"
    ExtractTemporaryFile('{#SplashFile}');
    ShowSplashScreen(WizardForm.Handle,ExpandConstant('{tmp}\{#SplashFile}'),{#SplashFadeIn},{#SplashShow},{#SplashFadeOut},0,255,True,$FFFFFF,10);
  #endif
  #if CheckCRC == "1"
    ExtractTemporaryFile('{#CRCFileName}');
  #endif
  WizardForm.WizardSmallBitmapImage.Hide;
  WizardForm.WelcomeLabel1.Hide;
  WizardForm.WelcomeLabel2.Hide;
  WizardForm.FinishedHeadingLabel.Hide;
  WizardForm.FinishedLabel.Hide;

#if (CompactMode == "0")  /* BEGIN Full Mode Wizard Creation */

  #if UseSystemReq == "1"
    SystemReq();
  #endif
  #if UseLicense == "1"
    ExtractTemporaryFile('LicenseImage.bmp');
  #endif
  #if UseInfo == "1"
    ExtractTemporaryFile('InfoBeforeImage.bmp');
  #endif
  #if CheckCRC == "1"
    ExtractTemporaryFile('HashCheck.bmp');
  #endif
  #if UseComponents == "1"
    ExtractTemporaryFile('SelectComponentsImage.bmp');
  #endif
  #if UseRedists == "1"
    ExtractTemporaryFile('SelectRedistsImage.bmp');
  #endif
  ExtractTemporaryFile('FolderImage.bmp');
  ExtractTemporaryFile('DiskSpaceImage.bmp');
  ExtractTemporaryFile('{#BannerBackground}');
  ExtractTemporaryFile('{#FinishBackground}');
  WizardForm.WizardBitmapImage2.Bitmap.LoadFromFile(ExpandConstant('{tmp}\{#FinishBackground}'));

  GrowWizard(ScaleX(103), ScaleY(66));
//  GrowBannerImage(ScaleX(500), ScaleY(0));
  WizardForm.InnerPage.Width := ScaleX(600);
  WizardForm.InnerPage.Height := ScaleY(379);
  WizardForm.WizardBitmapImage.Width := ScaleX(600);
  WizardForm.WizardBitmapImage.Height := ScaleY(379);
  WizardForm.WizardBitmapImage.Parent := WizardForm.WelcomePage;

  WillkommenLabel1               := TLabel.Create(WizardForm);
  WillkommenLabel1.Left          := ScaleX(0);
  WillkommenLabel1.Top           := ScaleY({#WelcomeLabel1Top});
  WillkommenLabel1.Width         := ScaleX(594);
  WillkommenLabel1.Height        := ScaleY(54);
  WillkommenLabel1.AutoSize      := False;
  WillkommenLabel1.WordWrap      := True;
  WillkommenLabel1.Font.Name     := '{#Font}';
  WillkommenLabel1.Font.Size     := DPICalculator({#WelcomeLabel1FontSize});
  WillkommenLabel1.Font.Style    := [fsBold];
  WillkommenLabel1.Font.Color    := ColorConverter(GetValInt('Text', 'FontColor', 0));
  WillkommenLabel1.ShowAccelChar := False;
  WillkommenLabel1.Alignment     := alBottom;
  WillkommenLabel1.Caption       := AppNameOverride(msgWelcomeLabel1);
  WillkommenLabel1.Transparent   := True;
  WillkommenLabel1.Parent        := WizardForm.WelcomePage;
  Centering(WillkommenLabel1);

  WillkommenLabel2               := TLabel.Create(WizardForm);
  WillkommenLabel2.Left          := ScaleX(0);
  WillkommenLabel2.Top           := ScaleY({#WelcomeLabel2Top});
  WillkommenLabel2.Width         := ScaleX(594);
  WillkommenLabel2.Height        := ScaleY(234);
  WillkommenLabel2.AutoSize      := False;
  WillkommenLabel2.WordWrap      := True;
  WillkommenLabel2.Font.Name     := '{#Font}';
  WillkommenLabel2.Font.Size     := DPICalculator({#WelcomeLabel2FontSize});
  WillkommenLabel2.Font.Color    := ColorConverter(GetValInt('Text', 'FontColor', 0));
  WillkommenLabel2.ShowAccelChar := False;
  WillkommenLabel2.Alignment     := alBottom;
  WillkommenLabel2.Caption       := AppNameOverride(msgWelcomeLabel2);
  WillkommenLabel2.Transparent   := True;
  WillkommenLabel2.Parent        := WizardForm.WelcomePage;
  Centering(WillkommenLabel2);

  WizardForm.WizardBitmapImage2.Width := ScaleX(600);
  WizardForm.WizardBitmapImage2.Height := ScaleY(379);

  FertigLabel1               := TLabel.Create(WizardForm);
  FertigLabel1.Left          := ScaleX(0);
  FertigLabel1.Top           := ScaleY({#FinishLabel1Top});
  FertigLabel1.Width         := ScaleX(594);
  FertigLabel1.Height        := ScaleY(54);
  FertigLabel1.AutoSize      := False;
  FertigLabel1.WordWrap      := True;
  FertigLabel1.Font.Name     := '{#Font}';
  FertigLabel1.Font.Size     := DPICalculator({#FinishLabel1FontSize});
  FertigLabel1.Font.Style    := [fsBold];
  FertigLabel1.Font.Color    := ColorConverter(GetValInt('Text', 'FontColor', 0));
  FertigLabel1.ShowAccelChar := False;
  FertigLabel1.Alignment     := alBottom;
  FertigLabel1.Caption       := AppNameOverride(msgFinishedHeadingLabel);
  FertigLabel1.Transparent   := True;
  FertigLabel1.Parent        := WizardForm.FinishedPage;
  Centering(FertigLabel1);

  FertigLabel2               := TLabel.Create(WizardForm);
  FertigLabel2.Left          := ScaleX(0);
  FertigLabel2.Top           := ScaleY({#FinishLabel2Top});
  FertigLabel2.Width         := ScaleX(594);
  FertigLabel2.Height        := ScaleY(234);
  FertigLabel2.AutoSize      := False;
  FertigLabel2.WordWrap      := True;
  FertigLabel2.Font.Name     := '{#Font}';
  FertigLabel2.Font.Size     := DPICalculator({#FinishLabel2FontSize});
  FertigLabel2.Font.Color    := ColorConverter(GetValInt('Text', 'FontColor', 0));
  FertigLabel2.ShowAccelChar := False;
  FertigLabel2.Alignment     := alBottom;
  FertigLabel2.Caption       := AppNameOverride(msgFinishedLabel);
  FertigLabel2.Transparent   := True;
  FertigLabel2.Parent        := WizardForm.FinishedPage;
  Centering(FertigLabel2);

  with WizardForm do
  begin
    Caption                 := ExpandConstant('{code:AppName}');
    Position                := poScreenCenter;
    WizardForm.ClientWidth  := ScaleX(600);
    WizardForm.ClientHeight := ScaleY(429);
  end;

  with WizardForm.NextButton do
  begin
    Parent  := WizardForm;
    Left    := ScaleX(431);
    Top     := WizardForm.CancelButton.Top;
    Width   := ScaleX(79);
    Height  := ScaleY(23);
    TabOrder := 1;
  end;

  with WizardForm.BackButton do
  begin
    Parent  := WizardForm;
    Left    := ScaleX(351);
    Top     := WizardForm.CancelButton.Top;
    Width   := ScaleX(79);
    Height  := ScaleY(23);
    TabOrder := 2;
  end;

  {Banner Image}
  BannerImage := TBitmapImage.Create(WizardForm)
  with BannerImage do
  begin
    Parent   := WizardForm.MainPanel;
    Stretch  := True;
    AutoSize := False;
    Left     := ScaleX(0);
    Top      := ScaleY(0);
//    Width    := ScaleX(600);
//    Height   := ScaleY(58);
    Width    := WizardForm.MainPanel.Width
    Height   := WizardForm.MainPanel.Height;
    Bitmap.LoadFromFile(ExpandConstant('{tmp}\{#BannerBackground}'));
  end;
  ///////////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////// LicensePage ///////////////////////////////////////////
  #if UseLicense == "1"
    LicenseImage := TBitmapImage.Create(WizardForm);
    with LicenseImage do
    begin
      Name             := 'LicenseImage';
      Parent           := WizardForm.LicensePage;
      Stretch          := True;
      AutoSize         := False;
      Left             := ScaleX(0);
      Top              := ScaleY(0);
      Width            := ScaleX(32);
      Height           := ScaleY(32);
      Bitmap.AlphaFormat := afDefined;
      Bitmap.LoadFromFile(ExpandConstant('{tmp}\LicenseImage.bmp'));
//      ReplaceColor     := $0000ff;
//      ReplaceWithColor := WizardForm.LicensePage.Color;
    end;

    with WizardForm.LicenseLabel1 do
    begin
      Caption  := WizardForm.LicenseLabel1.Caption
      WordWrap := True;
      Left     := LicenseImage.Left + ScaleX(42);
      Top      := ScaleY(0);
      Width    := ScaleX(488);
      Height   := ScaleY(50);
    end;

    WizardForm.LicenseMemo.Visible := False;

    LicenseMemo := TNewMemo.Create(WizardForm);
    with LicenseMemo do
    begin
      Parent     := WizardForm.LicensePage;
      Left       := ScaleX(0);
      Top        := ScaleY(50);
      Width      := ScaleX(520);
      Height     := ScaleY(210);
      Color      := TColor($d3d3d3);
      Font.Color := clBlack;
      ScrollBars := ssVertical;
      Text       := WizardForm.LicenseMemo.Text;
      ReadOnly   := True;
    end;
  #endif
  ///////////////////////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////// InfoBeforePage //////////////////////////////////////////
  #if UseInfo == "1"
    InfoBeforeImage := TBitmapImage.Create(WizardForm);
    with InfoBeforeImage do
    begin
      Name             := 'InfoBeforeImage';
      Parent           := WizardForm.InfoBeforePage;
      Stretch          := True;
      AutoSize         := False;
      Left             := ScaleX(0);
      Top              := ScaleY(0);
      Width            := ScaleX(32);
      Height           := ScaleY(32);
      Bitmap.AlphaFormat := afDefined;
      Bitmap.LoadFromFile(ExpandConstant('{tmp}\InfoBeforeImage.bmp'));
//      ReplaceColor     := $0000ff;
//      ReplaceWithColor := WizardForm.InfoBeforePage.Color;
    end;

    WizardForm.InfoBeforeMemo.Visible := False;

    InfoBeforeMemo := TNewMemo.Create(WizardForm);
    with InfoBeforeMemo do
    begin
      Parent     := WizardForm.InfoBeforePage;
      Left       := ScaleX(0);
      Top        := ScaleY(50);
      Width      := ScaleX(520);
      Height     := ScaleY(210);
      Color      := TColor($d3d3d3);
      Font.Color := clBlack;
      ScrollBars := ssVertical;
      Text       := WizardForm.InfoBeforeMemo.Text;
      ReadOnly   := True;
    end;

    with WizardForm.InfoBeforeClickLabel do
    begin
      WordWrap := True;
      Left     := InfoBeforeImage.Left + ScaleX(42);
      Top      := ScaleY(0);
      Width    := ScaleX(488);
      Height   := ScaleY(50);
    end;
  #endif
  ///////////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////// Components ////////////////////////////////////////////
  #if UseComponents == "1"
    #if UseSystemReq == "1"
      ComponentsPage := CreateCustomPage(SystemReqPage.ID, SetupMessage(msgWizardSelectComponents), SetupMessage(msgSelectComponentsDesc));
    #else
      ComponentsPage := CreateCustomPage(wpInfoBefore, SetupMessage(msgWizardSelectComponents), SetupMessage(msgSelectComponentsDesc));
    #endif

    SelectComponentsImage := TBitmapImage.Create(WizardForm);
    with SelectComponentsImage do
    begin
      Name             := 'SelectComponentsImage';
      Parent           := ComponentsPage.Surface;
      Stretch          := True;
      AutoSize         := False;
      Left             := ScaleX(0);
      Top              := ScaleY(0);
      Width            := ScaleX(32);
      Height           := ScaleY(32);
      Bitmap.AlphaFormat := afDefined;
      Bitmap.LoadFromFile(ExpandConstant('{tmp}\SelectComponentsImage.bmp'));
//      ReplaceColor     := $0000ff;
//      ReplaceWithColor := ComponentsPage.Surface.Color;
    end;

    SelectComponentsLabel := TNewStaticText.Create(WizardForm);
    with SelectComponentsLabel do
    begin
      Parent   := ComponentsPage.Surface;
      WordWrap := True;
      ShowAccelChar := False;
      Left     := WizardForm.PageDescriptionLabel.Left;
      Top      := WizardForm.SelectDirLabel.Top;
      Width    := ScaleX(488);
      Height   := ScaleY(50);
      Caption  := SetupMessage(msgSelectComponentsLabel2);
      WizardForm.AdjustLabelHeight(SelectComponentsLabel);
    end;

    ComponentsList := TNewCheckListBox.Create(WizardForm);
    with ComponentsList do
    begin
      Parent := ComponentsPage.Surface;
      Flat   := True;
      Left   := 0;
      Top    := SelectComponentsLabel.Top + SelectComponentsLabel.Height + ScaleY(15);
      Width  := ComponentsPage.SurfaceWidth;
      Height := ComponentsPage.SurfaceHeight - ComponentsList.Top - ScaleY(33);
      OnClickCheck := @ComponentsOnCheck;
    end;

    ComponentsDiskSpaceLabel := TNewStaticText.Create(WizardForm);
    with ComponentsDiskSpaceLabel do
    begin
      Parent   := ComponentsPage.Surface;
      WordWrap := True;
      ShowAccelChar := False;
      Left     := 0;
      Top      := ComponentsList.Top + ComponentsList.Height + ScaleY(10);
      Width    := ComponentsPage.SurfaceWidth;
      Height   := ScaleY(18);
      Caption  := FormatDiskSpaceLabel(SetupMessage(msgComponentsDiskSpaceMBLabel), 0);
      WizardForm.AdjustLabelHeight(ComponentsDiskSpaceLabel);
    end;

    I := 1;
    ComponentsSize := 0;
    SetArrayLength(CompIndexList, 0);
    IniFile := ExpandConstant('{tmp}\Settings.ini');
    ComponentsPageAvai := GetIniBool('ComponentsSettings', 'Enable', False, IniFile);
    if ComponentsPageAvai then
    begin
      if IniKeyExists('ComponentsSettings', 'Component' + IntToStr(I) + '.Name', IniFile) then
      begin
        CompName := CustomMessage('MainFiles');
        if GetIniBool('ComponentsSettings', 'ShowComponentSize', False, IniFile) then
          ComponentsList.AddCheckBox(CompName, FormatBytes(GetSizeBytes(GetIniString('Settings', 'Size', '0', ExpandConstant('{tmp}\Settings.ini')), 0), 2, True), 0, True, False, True, True, nil)
        else
          ComponentsList.AddCheckBox(CompName, '', 0, True, False, True, True, nil);
      end;
      while IniKeyExists('ComponentsSettings', 'Component' + IntToStr(I) + '.Name', IniFile) do
      begin
        CompName := GetIniString('ComponentsSettings', 'Component' + IntToStr(I) + '.Name', '', IniFile);
        if Pos('cm:', LowerCase(CompName)) > 0 then
          CompName := TranslateComponentName(CompName);

        if Trim(GetIniString('ComponentsSettings', 'Component' + IntToStr(I) + '.File', '', IniFile)) = '' then
        begin
          if IniKeyExists('ComponentsSettings', 'Component' + IntToStr(I) + '.Checked', IniFile) then begin
            if GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Exclusive', False, IniFile) then
              ComponentsList.AddRadioButton(CompName, '', GetIniInt('ComponentsSettings', 'Component' + IntToStr(I) + '.Level', 0,0,0, IniFile), GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Checked', True, IniFile), GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Enabled', True, IniFile), nil)
            else
              ComponentsList.AddCheckBox(CompName, '', GetIniInt('ComponentsSettings', 'Component' + IntToStr(I) + '.Level', 0,0,0, IniFile), GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Checked', True, IniFile), GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Enabled', True, IniFile), False, True, nil);
          end else
            ComponentsList.AddGroup(CompName, '', GetIniInt('ComponentsSettings', 'Component' + IntToStr(I) + '.Level', 0,0,0, IniFile), nil);
        end else
        begin
          Y := GetArrayLength(CompIndexList);
          SetArrayLength(CompIndexList, Y + 1);

          if GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Exclusive', False, IniFile) then
            CompIndexList[Y] := ComponentsList.AddRadioButton(CompName, '', GetIniInt('ComponentsSettings', 'Component' + IntToStr(I) + '.Level', 0,0,0, IniFile), GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Checked', True, IniFile), GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Enabled', True, IniFile), nil)
          else
            CompIndexList[Y] := ComponentsList.AddCheckBox(CompName, '', GetIniInt('ComponentsSettings', 'Component' + IntToStr(I) + '.Level', 0,0,0, IniFile), GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Checked', True, IniFile), GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Enabled', True, IniFile), False, True, nil);
          if ComponentsList.Checked[CompIndexList[Y]] then
            ComponentsSize := ComponentsSize + GetSizeBytes(GetIniString('ComponentsSettings', 'Component' + IntToStr(I) + '.Size', '0', IniFile), ComponentsSize);
          if GetIniString('ComponentsSettings', 'Component' + IntToStr(I) + '.Size', '', IniFile) = '' then
            ComponentsDiskSpaceLabel.Hide
        end;
        Inc(I);
      end;
      ComponentsDiskSpaceLabel.Caption := FormatDiskSpaceLabel(SetupMessage(msgComponentsDiskSpaceMBLabel), ComponentsSize + GetSizeBytes(GetIniString('Settings', 'Size', '0', ExpandConstant('{tmp}\Settings.ini')), 0));
      if GetIniBool('ComponentsSettings', 'ShowComponentSize', False, IniFile) then
        for I := 0 to GetArrayLength(CompIndexList) - 1 do
          ComponentsList.ItemSubItem[CompIndexList[I]] := FormatBytes(GetSizeBytes(GetIniString('ComponentsSettings', 'Component' + IntToStr(CompIndexList[I]) + '.Size', '0', IniFile), 0), 2, True);

      if GetIniBool('ComponentsSettings', 'FlatPageMode', False, IniFile) then
      begin
        ComponentsList.Flat := False;
        ComponentsList.BorderStyle := bsNone;
        ComponentsList.ParentColor := True;
        ComponentsList.MinItemHeight := WizardForm.TasksList.MinItemHeight; {22}
      end;
    end;
  #endif
  ///////////////////////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////// SelectDirPage //////////////////////////////////////////
  FolderImage := TBitmapImage.Create(WizardForm);
  with FolderImage do
  begin
    Name             := 'FolderImage';
    Parent           := WizardForm.SelectDirPage;
    Stretch          := True;
    AutoSize         := False;
    Left             := ScaleX(0);
    Top              := ScaleY(0);
    Width            := ScaleX(32);
    Height           := ScaleY(32);
    Bitmap.AlphaFormat := afDefined;
    Bitmap.LoadFromFile(ExpandConstant('{tmp}\FolderImage.bmp'));
//    ReplaceColor     := $0000ff;
//    ReplaceWithColor := WizardForm.SelectDirPage.Color;
  end;

  with WizardForm.SelectDirLabel do
  begin
    Caption  := AppNameOverride(msgSelectDirLabel3);
    Left     := FolderImage.Left + ScaleX(42);
    Top      := ScaleY(0);
    Width    := ScaleX(480);
    Height   := ScaleY(42);
    WordWrap := True;
  end;

  with WizardForm.SelectDirBrowseLabel do
  begin
    Caption := SetupMessage(msgReadyMemoDir);
  end;

  with WizardForm.SelectStartMenuFolderBrowseLabel do
  begin
    Parent   := WizardForm.SelectDirPage;
    Caption  := SetupMessage(msgReadyMemoGroup);
    Left     := ScaleX(0);
    Top      := ScaleY(104);
    Width    := ScaleX(400);
    Height   := ScaleY(14);
    WordWrap := True;
  end;

  with WizardForm.DirEdit do
  begin
    Parent   := WizardForm.InnerPage;
    Left     := ScaleX(40);
    Top      := ScaleY(133);
    Width    := ScaleX(420);
    Height   := ScaleY(21);
    Text     := Utf8toAnsi(WizardForm.DirEdit.Text);
  end;

  with WizardForm.DirBrowseButton do
  begin
    Parent   := WizardForm.InnerPage;
    Left     := ScaleX(470);
    Top      := ScaleY(132);
    Width    := ScaleX(90);
    Height   := ScaleY(23);
  end;

  with WizardForm.GroupEdit do
  begin
    Parent   := WizardForm.SelectDirPage;
    Left     := ScaleX(0);
    Top      := ScaleY(121);
    Width    := ScaleX(420);
    Height   := ScaleY(21);
    Text     := Utf8toAnsi(WizardForm.GroupEdit.Text);
  end;

  with WizardForm.GroupBrowseButton do
  begin
    Parent   := WizardForm.InnerPage;
    Left     := ScaleX(470);
    Top      := ScaleY(192);
    Width    := ScaleX(90);
    Height   := ScaleY(23);
  end;

  StartMenuCB := TNewCheckBox.Create(WizardForm);
  with StartMenuCB do
  begin
    Parent   := WizardForm.SelectDirPage;
    Left     := ScaleX(8);
    Top      := ScaleY(150);
    Width    := ScaleX(333);
    Height   := ScaleY(17);
    Caption  := WizardForm.NoIconsCheck.Caption;
    OnClick  := @StartMenuCBClick;
    Checked  := False;
  end;

  IconsCB := TNewCheckBox.Create(WizardForm);
  with IconsCB do
  begin
    Parent   := WizardForm.SelectDirPage;
    Left     := ScaleX(8);
    Top      := ScaleY(170);
    Width    := ScaleX(333);
    Height   := ScaleY(17);
    Caption  := ExpandConstant('{cm:CreateDesktopIcon}');
    Checked  := True;
  end;

  UninstallCB := TNewCheckBox.Create(WizardForm);
  with UninstallCB do
  begin
    Parent   := WizardForm.SelectDirPage;
    Left     := ScaleX(270);
    Top      := ScaleY(150);
    Width    := ScaleX(240);
    Height   := ScaleY(17);
    Caption  := ExpandConstant('{cm:CreateUninstall}');
    Checked  := True;
  end;

  LimitRAMCB := TNewCheckBox.Create(WizardForm);
  with LimitRAMCB do
  begin
    Parent   := WizardForm.SelectDirPage;
    Left     := IconsCB.Left;
    Top      := ScaleY(190);
    Width    := ScaleX(333);
    Height   := ScaleY(17);
    Caption  := ExpandConstant('{cm:LimitRAMCB}');
    Enabled  := True;
  end;

  NeedSizeFreeSizeBevel := TBevel.Create(WizardForm);
  with NeedSizeFreeSizeBevel do
  begin
    Parent := WizardForm.SelectDirPage;
    Left   := ScaleX(0);
    Top    := ScaleY(220);
    Width  := ScaleX(520);
    Height := ScaleY(39);
    Shape  := bsFrame;
    Style  := bsLowered;
  end;

  FreeSpaceLabel := TLabel.Create(WizardForm);
  with FreeSpaceLabel do
  begin
    Parent     := WizardForm.SelectDirPage;
    Left       := NeedSizeFreeSizeBevel.Left + ScaleX(42);
    Top        := ScaleY(224);
    Width      := ScaleX(450);
    Height     := ScaleY(14);
    Font.Style := [fsBold];
  end;

  NeedSpaceLabel := TLabel.Create(WizardForm);
  with NeedSpaceLabel do
  begin
    Parent     := WizardForm.SelectDirPage;
    Left       := NeedSizeFreeSizeBevel.Left + ScaleX(42);
    Top        := ScaleY(242);
    Width      := ScaleX(450);
    Height     := ScaleY(14);
    Font.Style := [fsBold];
  end;
  WizardForm.DirEdit.OnChange := @GetFreeSpaceCaption;

  DiskSpaceImage := TBitmapImage.Create(WizardForm);
  with DiskSpaceImage do
  begin
    Name             := 'DiskSpaceImage';
    Parent           := WizardForm.SelectDirPage;
    Stretch          := True;
    AutoSize         := False;
    Left             := FolderImage.Left + ScaleX(2);
    Top              := FreeSpaceLabel.Top + ScaleY(1);
    Width            := ScaleX(32);
    Height           := ScaleY(32);
    Bitmap.AlphaFormat := afDefined;
    Bitmap.LoadFromFile(ExpandConstant('{tmp}\DiskSpaceImage.bmp'));
//    ReplaceColor     := $0000ff;
//    ReplaceWithColor := WizardForm.SelectDirPage.Color;
  end;

  #if INISettings == "1"
    with WizardForm.UserInfoNameLabel do
    begin
      Parent   := WizardForm;
      Left     := ScaleX(40);
      Top      := ScaleY(350);
      Caption  := ExpandConstant('{cm:EnterPlayerName}');
//      Autosize := True;
    end;

    with WizardForm.UserInfoNameEdit do
    begin
      Parent   := WizardForm;
//      Left     := ScaleX(40);
      Left     := (WizardForm.UserInfoNameLabel.Width / 2);
      Top      := WizardForm.UserInfoNameLabel.Top;
      Width    := ScaleX(200);
      Height   := ScaleY(21);
      Text     := GetUserNameString;
    end;
  #endif
  ///////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////// CRC Page /////////////////////////////////////////////
  #if CheckCRC == "1"
    ContinueHash := True;

    CRCCheckCB := TNewCheckBox.Create(WizardForm);
    with CRCCheckCB do
    begin
      Parent   := WizardForm.SelectDirPage;
      Left     := ScaleX(270);
      Top      := ScaleY(170);
      Width    := ScaleX(240);
      Height   := ScaleY(17);
      Caption  := ExpandConstant('{cm:CheckCRC}');
    end;

    CRCPage := CreateCustomPage(wpInstalling, '', '');

    HashImage := TBitmapImage.Create(WizardForm);
    with HashImage do
    begin
      Parent   := CRCPage.Surface;
      Stretch  := True;
      AutoSize := False;
      Left     := ScaleX(0);
      Top      := ScaleY(0);
      Width    := ScaleX(32);
      Height   := ScaleY(32);
      Bitmap.AlphaFormat := afDefined;
      Bitmap.LoadFromFile(ExpandConstant('{tmp}\HashCheck.bmp'));
//      ReplaceColor := $0000ff;
//      ReplaceWithColor := CRCPage.Surface.Color;
    end;

    HashHdrLabel := TNewStaticText.Create(WizardForm);
    with HashHdrLabel do
    begin
      Parent   := CRCPage.Surface;
      WordWrap := True;
      Caption  := ExpandConstant('{cm:lblchk}');
      Left     := HashImage.Left + ScaleX(42);
      Top      := ScaleY(0);
      Width    := ScaleX(488);
      Height   := ScaleY(15);
      WordWrap := True;
    end;

    CheckFileLabel := TLabel.Create(WizardForm)
    with CheckFileLabel do
    begin
      Left        := ScaleX(4);
      Top         := ScaleY(34);
      Width       := ScaleX(350);
      Height      := ScaleY(18);
      Caption     := '';
      Transparent := True;
      Parent      := CRCPage.Surface;
    end;

    HashProgressBar1 := TNewProgressBar.Create(WizardForm);
    with HashProgressBar1 do
    begin
      Position := 0;
      Max      := 1000;
      Min      := 0;
      Left     := ScaleX(0);
      Top      := ScaleY(52);
      Width    := ScaleX(520);
      Height   := ScaleY(15);
      Parent   := CRCPage.Surface;
    end;

    OveralCheckLabel := TLabel.Create(WizardForm)
    with OveralCheckLabel do
    begin
      Left        := ScaleX(4);
      Top         := ScaleY(80);
      Width       := ScaleX(350);
      Height      := ScaleY(18);
      Caption     := '';
      Transparent := True;
      Parent      := CRCPage.Surface;
    end;

    HashProgressBar2 := TNewProgressBar.Create(WizardForm);
    with HashProgressBar2 do
    begin
      Position := 0;
      Max      := 1000;
      Min      := 0;
      Left     := ScaleX(0);
      Top      := ScaleY(98);
      Width    := ScaleX(520);
      Height   := ScaleY(15);
      Parent   := CRCPage.Surface;
    end;

    CRCInfoMemo := TNewMemo.Create(WizardForm);
    with CRCInfoMemo do
    begin
      Left       := ScaleX(0);
      Top        := ScaleY(HashProgressBar2.Top) + ScaleY(20);
      Width      := ScaleX(520);
      Height     := ScaleY(150);
      Lines.Text := '';
      ReadOnly   := True;
      ScrollBars := ssVertical;
      Parent     := CRCPage.Surface;
      Tabstop    := False;
    end;

    CRCLogMemo := TNewMemo.Create(WizardForm);
    with CRCLogMemo do
    begin
      Left       := ScaleX(0);
      Top        := ScaleY(HashProgressBar2.Top) + ScaleY(20);
      Width      := ScaleX(520);
      Height     := ScaleY(150);
      Lines.Text := '';
      ReadOnly   := True;
      ScrollBars := ssBoth;
      Parent     := CRCPage.Surface;
      Hide;
      Tabstop    := False;
    end;

    CRCCancelButton := TNewButton.Create(WizardForm);
    with CRCCancelButton do
    begin
      Left    := WizardForm.CancelButton.Left;
      Top     := WizardForm.CancelButton.Top;
      Width   := WizardForm.CancelButton.Width;
      Height  := WizardForm.CancelButton.Height;
      Caption := ExpandConstant('{cm:Verfiles}');
      Parent  := WizardForm;
      Hide;
      OnClick := @HandleBtn;
    end;

    LogButton := TNewButton.Create(WizardForm);
    with LogButton do
    begin
      Left    := (WizardForm.NextButton.Left - WizardForm.NextButton.Width) - ScaleX(10);
      Top     := WizardForm.BackButton.Top;
      Height  := WizardForm.BackButton.Height;
      Caption := ExpandConstant('{cm:LogCapt}');
      Parent  := WizardForm;
      Enabled := False;
      Hide;
      OnClick := @HandleLog;
    end;
  #endif
  ///////////////////////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////// Website / Music / About /////////////////////////////////////
  #if (WebsiteButton == "1") && (Music == "1")
    WebsiteButton := TNewButton.Create(WizardForm);
    with WebsiteButton do
    begin
      Parent  := WizardForm;
      Left    := ScaleX(13);
      Top     := WizardForm.NextButton.Top;
      Width   := ScaleX(156);
      Height  := ScaleY(23);
      #if WebBtnName == ""
        Caption := ExpandConstant('{cm:WebsiteText}');
      #else
        Caption := '{#WebBtnName}';
      #endif
      OnClick := @WebsiteClick;
    end;

    MusicButton := TNewButton.Create(WizardForm);
    with MusicButton do
    begin
      Parent  := WizardForm;
      Left    := ScaleX(170);
      Top     := WizardForm.NextButton.Top;
      Width   := ScaleX(75);
      Height  := ScaleY(23);
      Caption := ExpandConstant('{cm:MusicButtonCaptionSoundOff}');
      OnClick := @MusicButtonClick;
    end;
  #endif

  #if (WebsiteButton == "0") && (Music == "1")
    MusicButton := TNewButton.Create(WizardForm);
    with MusicButton do
    begin
      Parent  := WizardForm;
      Left    := ScaleX(13);
      Top     := WizardForm.NextButton.Top;
      Width   := ScaleX(75);
      Height  := ScaleY(23);
      Caption := ExpandConstant('{cm:MusicButtonCaptionSoundOff}');
      OnClick := @MusicButtonClick;
    end;
  #endif

  #if (WebsiteButton == "1") && (Music == "0")
    WebsiteButton := TNewButton.Create(WizardForm);
    with WebsiteButton do
    begin
      Parent  := WizardForm;
      Left    := ScaleX(13);
      Top     := WizardForm.NextButton.Top;
      Width   := ScaleX(156);
      Height  := ScaleY(23);
      #if WebBtnName == ""
        Caption := ExpandConstant('{cm:WebsiteText}');
      #else
        Caption := '{#WebBtnName}';
      #endif
      OnClick := @WebsiteClick;
    end;
  #endif

  AboutButton := TNewButton.Create(WizardForm);
  with AboutButton do
  begin
    Parent     := WizardForm;
    Left       := ScaleX(579);
    Top        := ScaleY(2);
    Width      := ScaleX(20);
    Height     := ScaleY(20);
    Caption    := '?'
    Font.Style := [fsBold];
    OnClick    := @AboutButtonClick;
  end;
  ///////////////////////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////// Redists /////////////////////////////////////////////
  #if UseRedists == "1"
    SelectRedistsImage := TBitmapImage.Create(WizardForm);
    with SelectRedistsImage do
    begin
      Name             := 'SelectRedistsImage';
      Parent           := WizardForm.ReadyPage;
      Stretch          := True;
      AutoSize         := False;
      Left             := ScaleX(0);
      Top              := ScaleY(0);
      Width            := ScaleX(32);
      Height           := ScaleY(32);
      Bitmap.AlphaFormat := afDefined;
      Bitmap.LoadFromFile(ExpandConstant('{tmp}\SelectRedistsImage.bmp'));
//      ReplaceColor     := $0000ff;
//      ReplaceWithColor := WizardForm.ReadyPage.Color;
    end;

    with WizardForm.ReadyLabel do
    begin
      Caption  := WizardForm.SelectTasksLabel.Caption
      WordWrap := True;
      Left     := SelectRedistsImage.Left + ScaleX(42);
      Top      := ScaleY(0);
      Width    := ScaleX(488);
      Height   := ScaleY(50);
    end;

    RedistsList := TNewCheckListBox.Create(WizardForm);
    with RedistsList do
    begin
      Left             := ScaleX(5);
      Top              := ScaleY(55);
      Width            := ScaleX(512);
      Height           := ScaleY(210);
      RedistsList.Flat := True;
      RedistsList.Parent := WizardForm.ReadyPage;
      if ({#Redist1} = 1) then
      Redist1 := RedistsList.AddCheckBox('{#Redist1Name}', '', 0, True, True, False, True, nil);
      if ({#Redist2} = 1) then
      Redist2 := RedistsList.AddCheckBox('{#Redist2Name}', '', 0, True, True, False, True, nil);
      if ({#Redist3} = 1) then
      Redist3 := RedistsList.AddCheckBox('{#Redist3Name}', '', 0, True, True, False, True, nil);
      if ({#Redist4} = 1) then
      Redist4 := RedistsList.AddCheckBox('{#Redist4Name}', '', 0, True, True, False, True, nil);
      if ({#Redist5} = 1) then
      Redist5 := RedistsList.AddCheckBox('{#Redist5Name}', '', 0, True, True, False, True, nil);
      if ({#Redist6} = 1) then
      Redist6 := RedistsList.AddCheckBox('{#Redist6Name}', '', 0, True, True, False, True, nil);
      if ({#Redist7} = 1) then
      Redist7 := RedistsList.AddCheckBox('{#Redist7Name}', '', 0, True, True, False, True, nil);
      if ({#Redist8} = 1) then
      Redist8 := RedistsList.AddCheckBox('{#Redist8Name}', '', 0, True, True, False, True, nil);
      if ({#Redist9} = 1) then
      Redist9 := RedistsList.AddCheckBox('{#Redist9Name}', '', 0, True, True, False, True, nil);
      if ({#Redist10} = 1) then
      Redist10 := RedistsList.AddCheckBox('{#Redist10Name}', '', 0, True, True, False, True, nil);
    end;
  #endif
  ///////////////////////////////////////////////////////////////////////////////////////////////////

   ///////////////////////////////////////// Installing Page /////////////////////////////////////////
  with WizardForm.ProgressGauge do
  begin
    Parent := WizardForm;
    Left   := ScaleX(6);
    Top    := ScaleY(0);
    Width  := ScaleX(586);
    Height := ScaleY(24);
    Max    := 1000;
  end;

  PauseCB := TNewCheckBox.Create(WizardForm);
  with PauseCB do
  begin
    Parent  := WizardForm;
    Left    := ScaleX(0);
    Top     := ScaleY(0);
    Width   := ScaleX(0);
    Height  := ScaleY(0);
    Visible := False;
    Checked := False;
  end;

  PauseButton := TNewButton.Create(WizardForm);
  with PauseButton do
  begin
    Parent  := WizardForm;
    Left    := (WizardForm.CancelButton.Left - WizardForm.CancelButton.Width) - ScaleX(25);
    Top     := WizardForm.CancelButton.Top;
    Width   := WizardForm.CancelButton.Width;
    Height  := WizardForm.CancelButton.Height;
    Caption := ExpandConstant('{cm:Pause}');
    OnClick := @PauseButtonClick;
  end;

  #if UseInstallBackground == "1"
    BackgroundCB := TNewCheckBox.Create(WizardForm);
    with BackgroundCB do
    begin
      Parent  := WizardForm;
      Left    := ScaleX(0);
      Top     := ScaleY(0);
      Width   := ScaleX(0);
      Height  := ScaleY(0);
      Visible := False;
      Checked := False;
    end;

    BackgroundButton := TNewButton.Create(WizardForm);
    with BackgroundButton do
    begin
      Parent  := WizardForm;
      Left    := ScaleX(13);
      Top     := ScaleY(394);
      Width   := ScaleX(156);
      Height  := ScaleY(23);
      Caption := ExpandConstant('{cm:BackgroundON}');
      OnClick := @BackgroundButtonClick;
    end;
  #endif

  PercentLabel := TNewStaticText.Create(WizardForm);
  with PercentLabel do
  begin
    PercentLabel.Parent     := WizardForm.ProgressGauge.Parent;
    PercentLabel.Left       := (WizardForm.ProgressGauge.Width / 2) - ScaleX(10);
    PercentLabel.Top        := ScaleY(69);
    PercentLabel.Width      := ScaleX(20);
    PercentLabel.Font.Style := [fsBold];
  end;

  ElapsedLabel := TNewStaticText.Create(WizardForm);
  with ElapsedLabel do
  begin
    ElapsedLabel.Parent   := WizardForm.ProgressGauge.Parent;
    ElapsedLabel.Left     := WizardForm.ProgressGauge.Left;
    ElapsedLabel.Top      := ScaleY(69);
    ElapsedLabel.AutoSize := True;
  end;

  RemainingLabel := TNewStaticText.Create(WizardForm);
  with RemainingLabel do
  begin
    RemainingLabel.Parent   := WizardForm.ProgressGauge.Parent;
    RemainingLabel.Left     := ScaleX(437);
    RemainingLabel.Top      := ScaleY(69);
    RemainingLabel.Height   := ScaleY(14);
    RemainingLabel.AutoSize := True;
  end;

#else /* BEGIN Compact Mode Wizard Creation */

  WizardForm.InnerPage.Width := ScaleX(460);
  WizardForm.WizardBitmapImage.Width := ScaleX(0);
  WizardForm.WizardBitmapImage.Height := ScaleY(0);
  WizardForm.WizardBitmapImage2.Width := ScaleX(0);
  WizardForm.WizardBitmapImage2.Height := ScaleY(0);

  with WizardForm do
  begin
    Caption              := ExpandConstant('{code:AppName}');
    Position             := poScreenCenter;
    ClientWidth          := ScaleX(460);
    ClientHeight         := ScaleY(187);
    InnerNotebook.Width  := ClientWidth;
    InnerNotebook.Height := ClientHeight;
    OuterNotebook.Width  := ClientWidth;
    OuterNotebook.Height := ClientHeight;
    WelcomePage.Width    := ClientWidth - 2 * WelcomePage.Left;
    WelcomePage.Height   := ClientWidth - 2 * WelcomePage.Top;
  end;

  {CompactMode}
  with WizardForm.DirEdit do
  begin
    Parent   := WizardForm;
    Left     := ScaleX(6);
    Top      := ScaleY(6);
    Width    := ScaleX(364);
    Height   := ScaleY(21);
    Text     := Utf8toAnsi(WizardForm.DirEdit.Text);
  end;

  {CompactMode}
  with WizardForm.DirBrowseButton do
  begin
    Parent   := WizardForm;
    Left     := ScaleX(380);
    Top      := ScaleY(5);
    Width    := ScaleX(75);
    Height   := ScaleY(23);
    Caption  := '. . .'
  end;

  {CompactMode}
  FreeSpaceLabel := TLabel.Create(WizardForm);
  with FreeSpaceLabel do
  begin
    Parent     := WizardForm;
    Left       := ScaleX(6);
    Top        := ScaleY(28);
    Width      := ScaleX(181);
    Height     := ScaleY(14);
    Font.Style := [fsBold];
  end;

  {CompactMode}
  NeedSpaceLabel := TLabel.Create(WizardForm);
  with NeedSpaceLabel do
  begin
    Parent     := WizardForm;
//    Left       := CRCCheckCB.Left;
    Top        := ScaleY(28);
    Width      := ScaleX(180);
    Height     := ScaleY(14);
    Font.Style := [fsBold];
  end;
  WizardForm.DirEdit.OnChange := @GetFreeSpaceCaption;

  {CompactMode}
  IconsCB := TNewCheckBox.Create(WizardForm);
  with IconsCB do
  begin
    Parent   := WizardForm;
    Left     := ScaleX(6);
    Top      := ScaleY(43);
    Width    := ScaleX(200);
    Height   := ScaleY(17);
    Caption  := ExpandConstant('{cm:CreateDesktopIcon}');
    Checked  := True;
  end;

  {CompactMode}
  CRCCheckCB := TNewCheckBox.Create(WizardForm);
  with CRCCheckCB do
  begin
    Parent   := WizardForm;
    Left     := ScaleX(211);
    Top      := ScaleY(43);
    Width    := ScaleX(159);
    Height   := ScaleY(17);
    Caption  := ExpandConstant('{cm:CheckCRC}');
    #if CheckCRC == "1"
      Enabled := True;
    #else
      Enabled := False;
    #endif
  end;

  #if CheckCRC == "1"
    CRCPage := CreateCustomPage(wpInfoAfter, '', '');
    ContinueHash := True;

    {CompactMode}
    HashHdrLabel := TNewStaticText.Create(WizardForm);
    with HashHdrLabel do
    begin
      Parent   := CRCPage.Surface;
      WordWrap := True;
      Caption  := ExpandConstant('{cm:lblchk}');
      Left     := ScaleX(0);
      Top      := ScaleY(0);
      Width    := ScaleX(0);
      Height   := ScaleY(0);
      WordWrap := True;
    end;

    {CompactMode}
    CheckFileLabel := TLabel.Create(WizardForm)
    with CheckFileLabel do
    begin
      Left        := ScaleX(6);
      Top         := ScaleY(6);
      Width       := ScaleX(364);
      Height      := ScaleY(14);
      Caption     := '';
      Transparent := True;
      Parent      := WizardForm;
    end;

    {CompactMode}
    HashProgressBar1 := TNewProgressBar.Create(WizardForm);
    with HashProgressBar1 do
    begin
      Position := 0;
      Max      := 1000;
      Min      := 0;
      Left     := ScaleX(6);
      Top      := ScaleY(23);
      Width    := ScaleX(364);
      Height   := ScaleY(14);
      Parent   := WizardForm;
    end;

    {CompactMode}
    OveralCheckLabel := TLabel.Create(WizardForm)
    with OveralCheckLabel do
    begin
      Left        := ScaleX(6);
      Top         := ScaleY(43);
      Width       := ScaleX(364);
      Height      := ScaleY(14);
      Caption     := '';
      Transparent := True;
      Parent      := WizardForm;
    end;

    {CompactMode}
    HashProgressBar2 := TNewProgressBar.Create(WizardForm);
    with HashProgressBar2 do
    begin
      Position := 0;
      Max      := 1000;
      Min      := 0;
      Left     := ScaleX(6);
      Top      := ScaleY(60);
      Width    := ScaleX(364);
      Height   := ScaleY(14);
      Parent   := WizardForm;
    end;

    {CompactMode}
    CRCInfoMemo := TNewMemo.Create(WizardForm);
    with CRCInfoMemo do
    begin
      Left       := ScaleX(6);
      Top        := ScaleY(77);
      Width      := ScaleX(364);
      Height     := ScaleY(105);
      Lines.Text := '';
      ReadOnly   := True;
      ScrollBars := ssVertical;
      Parent     := WizardForm;
      Tabstop    := False;
    end;

    {CompactMode}
    CRCLogMemo := TNewMemo.Create(WizardForm);
    with CRCLogMemo do
    begin
      Left       := ScaleX(6);
      Top        := ScaleY(77);
      Width      := ScaleX(364);
      Height     := ScaleY(105);
      Lines.Text := '';
      ReadOnly   := True;
      ScrollBars := ssBoth;
      Parent     := WizardForm;
      Hide;
      Tabstop    := False;
    end;

    {CompactMode}
    CRCCancelButton := TNewButton.Create(WizardForm);
    with CRCCancelButton do
    begin
      Left    := ScaleX(380);
      Top     := ScaleY(75);
      Width   := ScaleX(75);
      Height  := ScaleY(23);
      Caption := ExpandConstant('{cm:Verfiles}');
      Parent  := WizardForm;
      hide;
      OnClick := @HandleBtn;
    end;

    {CompactMode}
    LogButton := TNewButton.Create(WizardForm);
    with LogButton do
    begin
      Left    := ScaleX(380);
      Top     := ScaleY(100);
      Width   := ScaleX(75);
      Height  := ScaleY(23);
      Caption := ExpandConstant('{cm:LogCapt}');
      Parent  := WizardForm;
      enabled := False;
      hide;
      OnClick := @HandleLog;
    end;
  #endif

  {CompactMode}
  UninstallCB := TNewCheckBox.Create(WizardForm);
  with UninstallCB do begin
    Parent   := WizardForm;
    Left     := ScaleX(6);
    Top      := ScaleY(61);
    Width    := ScaleX(200);
    Height   := ScaleY(17);
    Caption  := ExpandConstant('{cm:CreateUninstall}');
    Checked  := True;
  end;

  {CompactMode}
  RedistCB := TNewCheckBox.Create(WizardForm);
  with RedistCB do
  begin
    Parent   := WizardForm;
    Left     := ScaleX(211);
    Top      := ScaleY(61);
    Width    := ScaleX(159);
    Height   := ScaleY(17);
    Caption  := ExpandConstant('{cm:InstallRedistCM}');
    #if UseRedists == "1"
      Enabled := True;
    #else
      Enabled := False;
    #endif
  end;

  {CompactMode}
  LimitRAMCB := TNewCheckBox.Create(WizardForm);
  with LimitRAMCB do
  begin
    Parent   := WizardForm;
    Left     := ScaleX(6);
    Top      := ScaleY(79);
    Width    := ScaleX(364);
    Height   := ScaleY(17);
    Caption  := ExpandConstant('{cm:LimitRAMCB}');
    Enabled  := True;
  end;

  {CompactMode}
  #if Music == "1"
    MusicButton := TNewButton.Create(WizardForm);
    with MusicButton do
    begin
      Parent  := WizardForm;
      Left    := ScaleX(380);
      Top     := ScaleY(30);
      Width   := ScaleX(75);
      Height  := ScaleY(23);
      Caption := ExpandConstant('{cm:MusicButtonCaptionSoundOff}');
      OnClick := @MusicButtonClick;
    end;
  #endif

  {CompactMode}
  with WizardForm.ProgressGauge do
  begin
    Parent := WizardForm;
    Left   := ScaleX(6);
    Top    := ScaleY(126);
    Width  := ScaleX(364);
    Height := ScaleY(21);
    Max    := 1000;
  end;

  {CompactMode}
  PauseCB := TNewCheckBox.Create(WizardForm);
  with PauseCB do
  begin
    Parent  := WizardForm;
    Left    := ScaleX(0);
    Top     := ScaleY(0);
    Width   := ScaleX(0);
    Height  := ScaleY(0);
    Visible := False;
    Checked := False;
  end;

  {CompactMode}
  PauseButton := TNewButton.Create(WizardForm);
  with PauseButton do
  begin
    Parent  := WizardForm;
    Left    := ScaleX(380);
    Top     := ScaleY(100);
    Width   := ScaleX(75);
    Height  := ScaleY(23);
    Caption := ExpandConstant('{cm:Pause}');
    OnClick := @PauseButtonClick;
  end;

  {CompactMode}
  #if (UseComponents == "1")
    SelectComponentsLabel := TNewStaticText.Create(WizardForm)
    with SelectComponentsLabel do
    begin
      Left    := ScaleX(6);
      Top     := ScaleY(167);
      Width   := ScaleX(200);
      Height  := ScaleY(14);
      Caption := ExpandConstant('{cm:SelectComponents}');
      Cursor  := crHand;
      Parent  := WizardForm;
      OnClick := @ComponentsPageClick;
      Visible := False;
    end;

    {CompactMode}
    ComponentsList := TNewCheckListBox.Create(WizardForm);
    with ComponentsList do
    begin
      Parent       := WizardForm;
      Left         := ScaleX(5);
      Top          := ScaleY(5);
      Width        := ScaleX(450);
      Height       := ScaleY(153);
      OnClickCheck := @ComponentsOnCheck;
      Visible      := False;
    end;

    {CompactMode}
    ComponentsOKButton := TNewButton.Create(WizardForm)
    with ComponentsOKButton do
    begin
      Left        := ScaleX(380);
      Top         := ScaleY(159);
      Width       := ScaleX(75);
      Height      := ScaleY(23);
      Parent      := WizardForm;
      Caption     := SetupMessage(msgButtonOK);
      OnClick     := @ComponentsPageClick;
      Visible     := False;
    end;

    {CompactMode}
    ComponentsDiskSpaceLabel := TNewStaticText.Create(WizardForm);
    with ComponentsDiskSpaceLabel do
    begin
      Left          := ScaleX(5);
      Top           := ScaleY(164);
      Width         := ScaleX(372);
      Height        := ScaleY(14);
      Parent        := WizardForm;
      AutoSize      := True;
      WordWrap      := False;
      ShowAccelChar := False;
      Visible       := False;
      Caption       := FormatDiskSpaceLabel(SetupMessage(msgComponentsDiskSpaceMBLabel), 0);
    end;
    I := 1;
    ComponentsSize := 0;
    SetArrayLength(CompIndexList, 0);
    ComponentsDiskSpaceLabelVisible := True;
    ComponentsPageAvai := GetIniBool('ComponentsSettings', 'Enable', False, IniFile);
    if ComponentsPageAvai then
    begin
      if IniKeyExists('ComponentsSettings', 'Component' + IntToStr(I) + '.Name', IniFile) then
      begin
        CompName := CustomMessage('MainFiles');
        if GetIniBool('ComponentsSettings', 'ShowComponentSize', False, IniFile) then
          ComponentsList.AddCheckBox(CompName, FormatBytes(GetSizeBytes(GetIniString('Settings', 'Size', '0', ExpandConstant('{tmp}\Settings.ini')), 0), 2, True), 0, True, False, True, True, nil)
        else
          ComponentsList.AddCheckBox(CompName, '', 0, True, False, True, True, nil);
      end;
      while IniKeyExists('ComponentsSettings', 'Component' + IntToStr(I) + '.Name', IniFile) do
      begin
        CompName := GetIniString('ComponentsSettings', 'Component' + IntToStr(I) + '.Name', '', IniFile);
        if Pos('cm:', LowerCase(CompName)) > 0 then
          CompName := TranslateComponentName(CompName);

        if Trim(GetIniString('ComponentsSettings', 'Component' + IntToStr(I) + '.File', '', IniFile)) = '' then
        begin
          if IniKeyExists('ComponentsSettings', 'Component' + IntToStr(I) + '.Checked', IniFile) then
          begin
            if GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Exclusive', False, IniFile) then
              ComponentsList.AddRadioButton(CompName, '', GetIniInt('ComponentsSettings', 'Component' + IntToStr(I) + '.Level', 0,0,0, IniFile), GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Checked', True, IniFile), GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Enabled', True, IniFile), nil)
            else
              ComponentsList.AddCheckBox(CompName, '', GetIniInt('ComponentsSettings', 'Component' + IntToStr(I) + '.Level', 0,0,0, IniFile), GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Checked', True, IniFile), GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Enabled', True, IniFile), False, True, nil);
          end else
            ComponentsList.AddGroup(CompName, '', GetIniInt('ComponentsSettings', 'Component' + IntToStr(I) + '.Level', 0,0,0, IniFile), nil);
        end else
        begin
          Y := GetArrayLength(CompIndexList);
          SetArrayLength(CompIndexList, Y + 1);

          if GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Exclusive', False, IniFile) then
            CompIndexList[Y] := ComponentsList.AddRadioButton(CompName, '', GetIniInt('ComponentsSettings', 'Component' + IntToStr(I) + '.Level', 0,0,0, IniFile), GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Checked', True, IniFile), GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Enabled', True, IniFile), nil)
          else
            CompIndexList[Y] := ComponentsList.AddCheckBox(CompName, '', GetIniInt('ComponentsSettings', 'Component' + IntToStr(I) + '.Level', 0,0,0, IniFile), GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Checked', True, IniFile), GetIniBool('ComponentsSettings', 'Component' + IntToStr(I) + '.Enabled', True, IniFile), False, True, nil);
          if ComponentsList.Checked[CompIndexList[Y]] then
            ComponentsSize := ComponentsSize + GetSizeBytes(GetIniString('ComponentsSettings', 'Component' + IntToStr(I) + '.Size', '0', IniFile), ComponentsSize);
          if GetIniString('ComponentsSettings', 'Component' + IntToStr(I) + '.Size', '', IniFile) = '' then
            ComponentsDiskSpaceLabelVisible := False;
        end;
        Inc(I);
      end;
      ComponentsDiskSpaceLabel.Caption := FormatDiskSpaceLabel(SetupMessage(msgComponentsDiskSpaceMBLabel), ComponentsSize + GetSizeBytes(GetIniString('Settings', 'Size', '0', ExpandConstant('{tmp}\Settings.ini')), 0));
      if GetIniBool('ComponentsSettings', 'ShowComponentSize', False, IniFile) then
        for I := 0 to GetArrayLength(CompIndexList) - 1 do
          ComponentsList.ItemSubItem[CompIndexList[I]] := FormatBytes(GetSizeBytes(GetIniString('ComponentsSettings', 'Component' + IntToStr(CompIndexList[I]) + '.Size', '0', IniFile), 0), 2, True);

      if GetIniBool('ComponentsSettings', 'FlatPageMode', False, IniFile) then
      begin
        ComponentsList.Flat := False;
        ComponentsList.BorderStyle := bsNone;
        ComponentsList.ParentColor := True;
        ComponentsList.MinItemHeight := WizardForm.TasksList.MinItemHeight; {22}
      end;
    end;
  #endif

  {CompactMode}
  AboutButtonCM := TNewButton.Create(WizardForm);
  with AboutButtonCM do
  begin
    Parent  := WizardForm.WelcomePage;
    Left    := ScaleX(380);
    Top     := ScaleY(167);
    Width   := ScaleX(75);
    Height  := ScaleY(14);
    Caption := '?';
    OnClick := @AboutButtonClick;
  end;

  {CompactMode}
  #if (UseInfo == "1")
    InfoButtonCM := TNewButton.Create(WizardForm);
    with InfoButtonCM do
    begin
      Parent  := WizardForm.WelcomePage;
      Left    := ScaleX(380);
      Top     := ScaleY(151);
      Width   := ScaleX(75);
      Height  := ScaleY(14);
      Caption := 'i';
      OnClick := @InfoButtonClick;
    end;
  #endif

  {CompactMode}
  with WizardForm.CancelButton do
  begin
    Parent  := WizardForm;
    Left    := ScaleX(380);
    Top     := ScaleY(75);
    Width   := ScaleX(75);
    Height  := ScaleY(23);
  end;

  {CompactMode}
  with WizardForm.NextButton do
  begin
    Parent  := WizardForm;
    Left    := ScaleX(380);
    Top     := ScaleY(125);
    Width   := ScaleX(75);
    Height  := ScaleY(23);
  end;

  {CompactMode}
  PercentLabel := TNewStaticText.Create(WizardForm);
  with PercentLabel do
  begin
    PercentLabel.Parent     := WizardForm.ProgressGauge.Parent;
    PercentLabel.Left       := ScaleX(WizardForm.ProgressGauge.Width / 2) - 10;
    PercentLabel.Top        := ScaleY(148);
    PercentLabel.Width      := ScaleX(20);
    PercentLabel.Font.Style := [fsBold];
  end;

  {CompactMode}
  ElapsedLabel := TNewStaticText.Create(WizardForm);
  with ElapsedLabel do
  begin
    ElapsedLabel          := TNewStaticText.Create(WizardForm);
    ElapsedLabel.Parent   := WizardForm.ProgressGauge.Parent;
    ElapsedLabel.Left     := WizardForm.ProgressGauge.Left;
    ElapsedLabel.Top      := ScaleY(148);
    ElapsedLabel.AutoSize := True;
  end;

  {CompactMode}
  RemainingLabel := TNewStaticText.Create(WizardForm);
  with RemainingLabel do
  begin
    RemainingLabel          := TNewStaticText.Create(WizardForm);
    RemainingLabel.Parent   := WizardForm.ProgressGauge.Parent;
    RemainingLabel.Left     := ScaleX(256);
    RemainingLabel.Top      := ScaleY(148);
    RemainingLabel.AutoSize := True;
  end;
#endif /* END Compact Mode Wizard Creation*/
///////////////////////////////////////////////////////////////////////////////////////////////////
end;


procedure UnpackCompressors();
begin
  ExtractTemporaryFile('Arc.ini');
  ExtractTemporaryFile('CLS.ini');
  ExtractTemporaryFile('English.ini');
  try
    ExtractTemporaryFile(ActiveLanguage + '.ini');
  except
    FileCopy(ExpandConstant('{tmp}\English.ini'), ExpandConstant('{tmp}\' + ActiveLanguage + '.ini'), False);
  end;
  ExtractTemporaryFile('UnArc.dll');
  ExtractTemporaryFile('Facompress.dll');
  ExtractTemporaryFile('Facompress_mt.dll');
  ExtractTemporaryFile('split.exe');
  #sub ExtractFile
    #if LowerCase(ExtractFileExt(FindGetFileName(FindHandle))) != 'txt' /* exclude ".txt" files  */
      #if (DualList[I] == 1)
        #define public StrPath LowerCase(ExtractFileName(ExtractFilePath(PathList[I])))
        #if ((Pos("win64", StrPath) > 0) || (Pos("x64", StrPath) > 0))
          #emit "  if IsWin64 then begin"
          #emit "    ExtractTemporaryFile('" + FindGetFileName(FindHandle) + ".win64');"
          #emit "    FileCopy(ExpandConstant('{tmp}\" + FindGetFileName(FindHandle) + ".win64'), ExpandConstant('{tmp}\" + FindGetFileName(FindHandle) + "'), False);"
          #emit "    DeleteFile(ExpandConstant('{tmp}\" + FindGetFileName(FindHandle) + ".win64'));"
          #emit "  end;"
        #else
          #emit "  if not IsWin64 then begin"
          #emit "    ExtractTemporaryFile('" + FindGetFileName(FindHandle) + ".win32');"
          #emit "    FileCopy(ExpandConstant('{tmp}\" + FindGetFileName(FindHandle) + ".win32'), ExpandConstant('{tmp}\" + FindGetFileName(FindHandle) + "'), False);"
          #emit "    DeleteFile(ExpandConstant('{tmp}\" + FindGetFileName(FindHandle) + ".win32'));"
          #emit "  end;"
        #endif
      #else
        #emit "  ExtractTemporaryFile('" + FindGetFileName(FindHandle) + "');"
      #endif
    #endif
  #endsub
  #sub ExtractPathOrFile
    #for {FindHandle = FindResult = FindFirst(PathList[I], 0); FindResult; FindResult = FindNext(FindHandle)} ExtractFile
    #if FindHandle
      #expr FindClose(FindHandle)
    #endif
    #if FindResult
      #expr FindClose(FindResult)
    #endif
  #endsub
  #for {I = 0; I < DimOf(PathList); I++} ExtractPathOrFile
  if LimitRAMCB.Checked then
  begin
    SetIniString('Srep', 'Bufsize', '12m', ExpandConstant('{tmp}\CLS.ini'));
    SetIniString('Srep', 'Memory', '256m', ExpandConstant('{tmp}\CLS.ini'));
    SetIniString('Precomp', 'Memory', '128', ExpandConstant('{tmp}\CLS.ini'));
    SetIniString('Lolz', 'Bufsize', '256k',ExpandConstant('{tmp}\CLS.ini'));
    SetIniString('Lolz', 'MaxThreadsUsage', '2',ExpandConstant('{tmp}\CLS.ini'));
    SetIniString('Lolz', 'MaxMemoryUsage', '50%',ExpandConstant('{tmp}\CLS.ini'));
    SetIniString('Lolz', 'ldmfMaxMemoryUsage', '64m',ExpandConstant('{tmp}\CLS.ini'));
    SetIniString('AFR', 'Threads', '2',ExpandConstant('{tmp}\CLS.ini'));
    SetIniString('uelr', 'ReadBufSize', '1024k',ExpandConstant('{tmp}\CLS.ini'));
    SetIniString('uelr', 'WriteBufSize', '2048k',ExpandConstant('{tmp}\CLS.ini'));
  end;
end;


#if (CompactMode == "0") && (UseInstallBackground == "1")
  function WrapTimerProc(callback:TProc; paramcount:integer):longword;
    external 'wrapcallback@files:Innocallback.dll stdcall';
  function SetTimer(hWnd, nIDEvent, uElapse, lpTimerFunc: LongWord): LongWord;
    external 'SetTimer@user32.dll stdcall';
  function KillTimer(hWnd, nIDEvent: LongWord): LongWord;
    external 'KillTimer@user32.dll stdcall';

  procedure InitializeSlideShow(Hwnd: Thandle; l,t,w,h: integer; Animate: boolean; Stretch:integer);
    external 'InitializeSlideShow@files:isslideshow.dll stdcall';
  procedure DeinitializeSlideShow;
    external 'DeinitializeSlideShow@files:isslideshow.dll stdcall';
  procedure ShowImage(ipath:PAnsiChar; Effect:integer);
    external 'ShowImage@files:isslideshow.dll stdcall';
  function GetSystemMetrics(nIndex : Integer): Integer;
    external 'GetSystemMetrics@user32 stdcall';


  procedure OnTimer(HandleW, msg, idEvent, TimeSys: LongWord);
  begin
    CurrentPicture := CurrentPicture + 1;
    if CurrentPicture = PicList.count + 1 then CurrentPicture := 1;
      ShowImage(PicList.strings[CurrentPicture - 1], 1);
  end;


  procedure MakeSlideShow();
  var
    BGII: Integer;
  begin
    BackgroundForm := TForm.Create(nil);
    BackgroundForm.BorderStyle := bsNone;
    BackgroundForm.Color := clBlack;
    BackgroundForm.Left := ScaleX(0);
    BackgroundForm.Top := ScaleY(0);
    BackgroundForm.Width := ScaleX(GetSystemMetrics(0));
    BackgroundForm.Height := ScaleY(GetSystemMetrics(1));
    BackgroundForm.Visible := True;
    BackgroundForm.Enabled := False;
    PicList := tstringlist.Create;
    #sub ExtractFile2
      ExtractTemporaryFile('{#i}.jpg');
    #endsub
    #for {i = 1; FileExists("Setup\Background\" + Str(i) + ".jpg") != 0; i++} ExtractFile2
  BGII := 1;
  repeat
    PicList.add(ExpandConstant('{tmp}\' +IntToStr(BGII)+ '.jpg'));
    BGII := BGII + 1;
  until FileExists(ExpandConstant('{tmp}\' +IntToStr(BGII)+ '.jpg')) = False;
    BackgroundForm.Show;
    #if Animation == "1"
      InitializeSlideShow(BackgroundForm.Handle, 0, 0, GetSystemMetrics(0), GetSystemMetrics(1), True, 1);
    #else
      InitializeSlideShow(BackgroundForm.Handle, 0, 0, GetSystemMetrics(0), GetSystemMetrics(1), False, 1);
    #endif
    CurrentPicture := 1;
    ShowImage(ExpandConstant('{tmp}\') +  IntToStr(CurrentPicture) + '.jpg', 1);
  end;
#endif


function GetMessage(MsgNum: Integer; Var1, Var2: String): String;
begin
  Result := ExpandConstant('{cm:Message'+IntToStr(MsgNum)+'}');
  StringChange(Result,'%1',Var1);
  StringChange(Result,'%2',Var2);
end;


procedure ProgressLabels(Status, CurrentFile: String);
begin
  WizardForm.StatusLabel.Caption := Status;
  with WizardForm.FilenameLabel do
    Caption := MinimizePathName(CurrentFile, Font, Width);
end;


#ifdef DEBUG
function MyDiskRequest(APath, AFilename: String): String;
var
  MsgResult: Integer;
begin
  Result := APath;
  if not FileExists(AddBackSlash(Result) + AFilename) then
    repeat
      MsgResult := MsgBox(GetMessage(1, AFilename,''), mbConfirmation, MB_OKCANCEL);
      if MsgResult = mrCancel then
        WizardForm.CancelButton.OnClick(nil);
      if (MsgResult = mrOk) and (FileExists(AddBackSlash(Result) + AFilename) = False) then
        if MsgBox(GetMessage(2,'',''), mbConfirmation, MB_YESNO) = mrYes then
          if GetOpenFileName('', Result, '', AFilename + '|' + AFilename, AFilename) then
            Result := ExtractFileDir(Result);
    until (FileExists(AddBackSlash(Result) + AFilename) = True) or (ISDoneError = True);
end;
#endif


function TicksToStr(Value: DWORD): string;
var
  I: DWORD;
  Hours, Minutes, Seconds: Integer;
begin
  I := Value div 1000;
  Seconds := I mod 60;
  I := I div 60;
  Minutes := I mod 60;
  I := I div 60;
  Hours := I mod 24;
  Result := Format('%.2d:%.2d:%.2d', [Hours, Minutes, Seconds]);
end;


function Floater(Float: Extended; Value: Integer): String;
begin
  Result := Format('%.'+IntToStr(Value)+'n', [Float]); StringChange(Result, ',', ',');
  while ((Result[Length(Result)] = '0') or (Result[Length(Result)] = ',')) and (Pos(',', Result) > 0) do
    SetLength(Result, Length(Result)-1);
end;


function ProgressCallback(OveralPct, CurrentPct: Integer; CurrentFile, TimeStr1, TimeStr2, TimeStr3: PAnsiChar): LongWord;
var
  CurTick: DWORD;
begin
  with LabelCurrFileName do
    ProgressLabels(GetMessage(1, '', ''), AddBackSlash(ExpandConstant('{app}')) + CurrentFile);
  if (OveralPct + SplitPct) <= WizardForm.ProgressGauge.Max then
    WizardForm.ProgressGauge.Position := OveralPct + SplitPct;
  OveralPct := (WizardForm.ProgressGauge.Position * 1000) / WizardForm.ProgressGauge.Max;
  PercentLabel.Caption := IntToStr(OveralPct div 10) + '.' + chr(48 + OveralPct mod 10) + '%';
  CurTick := GetTickCount;
  #if CompactMode == "0"
    ElapsedLabel.Caption := ExpandConstant('{cm:ElapsedTime}') + ': ' + TimeStr2;
  #else
    ElapsedLabel.Caption := ExpandConstant('{cm:ElapsedTime}') + ': ' + TimeStr2;
  #endif
  if (CurrentPct > 0) and (GetArrayLength(Data) < 2) then
  begin
    RemainingLabel.Caption := ExpandConstant('{cm:RemainingTime}') + ': ' +TimeStr1
  end else
    if CurrentPct > 0 then
    begin
      RemainingLabel.Visible := True;
    end;
  Result := ISDoneCancel;
end;


function UpdateSource(hFile, NewSource: String):String;
begin
  Result := hFile;
  StringChange(Result, '{src}', NewSource);
  Result := ExpandConstant(Result);
end;


procedure UltraARC_Process;
var
  Data: array of TData;
  i, MsgResult: Integer;
  ComponentFile, SourceDir: String;
  #if AFR_019
    SysInfo: TSystemInfo;
    Threads: Integer;
  #endif
begin
  ForceDirectories(ExpandConstant('{app}\'));
  UnpackCompressors();
  #if UWPGame == "1"
    ShellExec('open', 'cmd.exe', '/c copy /Y "' + ExpandConstant('{tmp}\UWP_Tool.exe') + '" "' + ExpandConstant('{app}\UWP_Tool.exe') + '"', '', SW_Hide, ewWaitUntilTerminated, ResultCode);
  #endif
  #if AFR_019
    GetSystemInfo(SysInfo);
    Threads := SysInfo.dwNumberOfProcessors;
    SetIniString('Afr', 'Threads', IntToStr(Threads), ExpandConstant('{tmp}\CLS.ini'));
  #endif
  SourceDir := ExpandConstant('{src}');
  ISDoneError := false;
  SplitPct := 0;
  if ISDoneInit(ExpandConstant('{tmp}\records.inf'), $F777, 0,0,0, MainForm.Handle, 512, @ProgressCallback) then
  repeat
    ChangeLanguage(ActiveLanguage);
    ClsInit(ExpandConstant('{src}'), WizardForm.Handle);
    if not SrepInit('',512,0) then
      ISDoneError := True;
    if not PrecompInit('',128,0) then
      ISDoneError := True;
    if not FileSearchInit(true) then
      ISDoneError := True;
    SetIniString('Srep', 'TempPath', ExpandConstant('{app}'), ExpandConstant('{tmp}\CLS.ini'));
    SetIniString('Precomp', 'TempPath', ExpandConstant('{app}'), ExpandConstant('{tmp}\CLS.ini'));
    SetIniString('lolz', 'ldmfTempPath', ExpandConstant('{app}'), ExpandConstant('{tmp}\CLS.ini'));
    if not FileExists(ExpandConstant('{tmp}\RAZOR.dll')) then {if not razor stdio patched}
      SetIniString('External compressor:rz,razor', 'unpackcmd', ' rz e -y $$arcpackedfile$$.tmp $$arcdatafile$$.tmp', ExpandConstant('{tmp}\Arc.ini'));
    i := 0;
    repeat
      i := i + 1;
      if GetIniString('Record' + IntToStr(i),'Type','',ExpandConstant('{{#InternalRecords == "1" ? "tmp" : "src"}}\records.ini')) <> '' then
      begin
        SetArrayLength(Data,i);
        SetArrayLength(Data[i - 1].Arc,7);
      end;
    until GetIniString('Record' + IntToStr(i),'Type','',ExpandConstant('{{#InternalRecords == "1" ? "tmp" : "src"}}\records.ini')) = '';
    i := 0;
    repeat
      i := i + 1;
      if GetIniString('Record' + IntToStr(i),'Type','',ExpandConstant('{{#InternalRecords == "1" ? "tmp" : "src"}}\records.ini')) <> '' then
      begin
        Data[i - 1].Arc[0] := GetIniString('Record' + IntToStr(i),'Type','',ExpandConstant('{{#InternalRecords == "1" ? "tmp" : "src"}}\records.ini'));
        if Pos('Split',Data[i - 1].Arc[0]) <> 0 then
        begin
          Data[i - 1].Arc[1] := GetIniString('Record' + IntToStr(i),'Source','',ExpandConstant('{{#InternalRecords == "1" ? "tmp" : "src"}}\records.ini'));
          Data[i - 1].Arc[2] := GetIniString('Record' + IntToStr(i),'Output','',ExpandConstant('{{#InternalRecords == "1" ? "tmp" : "src"}}\records.ini'));
          if Data[i - 1].Arc[0] = 'Split' then
            StringChangeEx(Data[i - 1].Arc[2],'{tmp}','{app}',True)
          else
            StringChangeEx(Data[i - 1].Arc[1],'{tmp}','{app}',True);
          Data[i - 1].Arc[2] := ExpandConstant(Data[i - 1].Arc[2]);
        end else begin
          Data[i - 1].Arc[1] := GetIniString('Record' + IntToStr(i),'Source','',ExpandConstant('{{#InternalRecords == "1" ? "tmp" : "src"}}\records.ini'));
          Data[i - 1].Arc[2] := ExpandConstant(GetIniString('Record' + IntToStr(i),'Output','',ExpandConstant('{{#InternalRecords == "1" ? "tmp" : "src"}}\records.ini')));
        end;
        Data[i - 1].Arc[3] := GetIniString('Record' + IntToStr(i),'Disk','',ExpandConstant('{{#InternalRecords == "1" ? "tmp" : "src"}}\records.ini'));
      end;
    until GetIniString('Record' + IntToStr(i),'Type','',ExpandConstant('{{#InternalRecords == "1" ? "tmp" : "src"}}\records.ini')) = '';
    WizardForm.ProgressGauge.Position := 0;
    WizardForm.ProgressGauge.Max := 0;
    {Set PB for selected components}
    #if UseComponents == "1"
      if ComponentsPageAvai then
      begin
        for I := 0 to GetArrayLength(CompIndexList) - 1 do
          if ComponentsList.Checked[CompIndexList[I]] then
            WizardForm.ProgressGauge.Max := WizardForm.ProgressGauge.Max + 1000;
      end;
    #endif
    i := 0;
    if GetArrayLength(Data) > 0 then
    begin
      if Data[0].Arc[0] <> '' then
      begin
        repeat
          i := i + 1;
            if Data[i - 1].Arc[0] = 'Split' then
              WizardForm.ProgressGauge.Max := WizardForm.ProgressGauge.Max + 100
            else
              WizardForm.ProgressGauge.Max := WizardForm.ProgressGauge.Max + 1000;
        until i = GetArrayLength(Data);
      end;

      i := 0;
      if Data[0].Arc[0] <> '' then
      begin
        repeat

          i := i + 1;
          if Data[i - 1].Arc[0] = 'Freearc_Original' then
          begin
            if not FileExists(UpdateSource(Data[i - 1].Arc[1],SourceDir)) then
            begin
              repeat
                MsgResult := MsgBox(GetMessage(4,ExtractFileName(Data[i - 1].Arc[1]),'')+#13 +
                  GetMessage(5,ExtractFileName(Data[i - 1].Arc[3]),ExtractFileName(Data[i - 1].Arc[1])), mbConfirmation, MB_OKCANCEL);
                if MsgResult = mrCancel then
                   WizardForm.CancelButton.OnClick(nil);
                if (MsgResult = mrOk) and (FileExists(UpdateSource(Data[i - 1].Arc[1],SourceDir)) = False) then
                  MsgResult := MsgBox(GetMessage(4,ExtractFileName(Data[i - 1].Arc[1]),'')+#13 +
                    GetMessage(6,'',''), mbConfirmation, MB_YESNO);
                if MsgResult = mrYes then
                begin
                  if GetOpenFileName('',SourceDir, ExpandConstant('{src}'),ExtractFileName(Data[i - 1].Arc[1]) +
                    '|' + ExtractFileName(Data[i - 1].Arc[1]),
                      ExtractFileName(Data[i - 1].Arc[1])) then
                        SourceDir := ExtractFileDir(SourceDir);
                end;
              until (FileExists(UpdateSource(Data[i - 1].Arc[1],SourceDir)) = True) or (ISDoneError = True);
            end;
            if (not ISDoneError) and (not IniKeyExists('Records2', 'Type', ExpandConstant('{{#InternalRecords == "1" ? "tmp" : "src"}}\records.ini'))) and ({#UseComponents} = 0) then
            begin
              if not ISArcExtract(0, 100, UpdateSource(Data[i - 1].Arc[1],SourceDir), Data[i - 1].Arc[2], '', false, '', ExpandConstant('{tmp}\arc.ini'), Data[i - 1].Arc[2], false) then
                ISDoneError := True;
            end else begin
              if not ISArcExtract(0, 0, UpdateSource(Data[i - 1].Arc[1],SourceDir), Data[i - 1].Arc[2], '', false, '', ExpandConstant('{tmp}\arc.ini'), Data[i - 1].Arc[2], false) then
                ISDoneError := True;
            end;
            end;

            if Data[i - 1].Arc[0] = 'Freearc_Split' then
            begin
              if not FileExists(UpdateSource(Data[i - 1].Arc[1],SourceDir)) then
              begin
                repeat
                  MsgResult := MsgBox(GetMessage(4,ExtractFileName(Data[i - 1].Arc[1]),'')+#13 +
                    GetMessage(5,ExtractFileName(Data[i - 1].Arc[3]),ExtractFileName(Data[i - 1].Arc[1])), mbConfirmation, MB_OKCANCEL);
                  if MsgResult = mrCancel then
                     WizardForm.CancelButton.OnClick(nil);
                  if (MsgResult = mrOk) and (FileExists(UpdateSource(Data[i - 1].Arc[1],SourceDir)) = False) then
                    MsgResult := MsgBox(GetMessage(4,ExtractFileName(Data[i - 1].Arc[1]),'')+#13 +
                      GetMessage(6,'',''), mbConfirmation, MB_YESNO);
                  if MsgResult = mrYes then
                  begin
                    if GetOpenFileName('',SourceDir, ExpandConstant('{src}'),ExtractFileName(Data[i - 1].Arc[1]) +
                      '|' + ExtractFileName(Data[i - 1].Arc[1]),
                        ExtractFileName(Data[i - 1].Arc[1])) then
                          SourceDir := ExtractFileDir(SourceDir);
                  end;
                until (FileExists(UpdateSource(Data[i - 1].Arc[1],SourceDir)) = True) or (ISDoneError = True);
              end;
              if ISDoneError = False then
                if not ISArcExtract(0, 0, UpdateSource(Data[i - 1].Arc[1],SourceDir), Data[i - 1].Arc[2], '', true, '',
                  ExpandConstant('{tmp}\arc.ini'), Data[i - 1].Arc[2], false) then
                    ISDoneError := True;
            end;

            if Data[i - 1].Arc[0] = 'Split' then
            begin
              if not FileExists(UpdateSource(Data[i - 1].Arc[1],SourceDir)) then
              begin
                repeat
                  MsgResult := MsgBox(GetMessage(4,ExtractFileName(Data[i - 1].Arc[1]),'')+#13 +
                    GetMessage(5,ExtractFileName(Data[i - 1].Arc[3]),ExtractFileName(Data[i - 1].Arc[1])), mbConfirmation, MB_OKCANCEL);
                  if MsgResult = mrCancel then
                     WizardForm.CancelButton.OnClick(nil);
                  if (MsgResult = mrOk) and (FileExists(UpdateSource(Data[i - 1].Arc[1],SourceDir)) = False) then
                    MsgResult := MsgBox(GetMessage(4,ExtractFileName(Data[i - 1].Arc[1]),'')+#13 +
                      GetMessage(6,'',''), mbConfirmation, MB_YESNO);
                  if MsgResult = mrYes then
                  begin
                    if GetOpenFileName('',SourceDir, ExpandConstant('{src}'),ExtractFileName(Data[i - 1].Arc[1]) +
                      '|' + ExtractFileName(Data[i - 1].Arc[1]),
                        ExtractFileName(Data[i - 1].Arc[1])) then
                          SourceDir := ExtractFileDir(SourceDir);
                  end;
                until (FileExists(UpdateSource(Data[i - 1].Arc[1],SourceDir)) = True) or (ISDoneError = True);
              end;
              if ISDoneError = False then
              begin
                ProgressLabels(GetMessage(2,'',''),Data[i - 1].Arc[2]);
                if not Exec(ExpandConstant('{tmp}\Split.exe'), '"' + UpdateSource(Data[i - 1].Arc[1],SourceDir) + '"' + ' ' + '"' +
                  Data[i - 1].Arc[2] + '"', '',SW_HIDE, ewWaitUntilTerminated, MsgResult) then
                    ISDoneError := True;
                WizardForm.ProgressGauge.Position := WizardForm.ProgressGauge.Position + 100;
                SplitPct := SplitPct + 100;
              end;
            end;

            if ISDoneError = True then
              Break;
        until i = GetArrayLength(Data);
      end;
    end;
    {Unpack selected components}
    #if UseComponents == "1"
      if ComponentsPageAvai then
      begin
        for I := 0 to GetArrayLength(CompIndexList) - 1 do
          if ComponentsList.Checked[CompIndexList[I]] then
          begin
            ComponentFile := ExpandConstant('{src}\' + GetIniString('ComponentsSettings', 'Component' + IntToStr(CompIndexList[I]) + '.File', '', ExpandConstant('{tmp}\Settings.ini')));
            if (ISDoneError = False) and FileExists(ComponentFile) then
              if not ISArcExtract(0, 0, ComponentFile, ExpandConstant('{app}'), '', false, '', ExpandConstant('{tmp}\arc.ini'), ExpandConstant('{app}'), false) then
                ISDoneError := True;
          end;
      end;
    #endif
  until True;
  ISDoneStop;
end;


#if (CompactMode == "1") && (UseRedists == "1")
  procedure InstallRedistsCMode;
  begin
    WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedistCM}');
    if ({#Redist1} = 1) then
    begin
      WizardForm.ProgressGauge.Hide;
      WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist1}');
      if not IsWin64 then
      begin
        Exec2(ExpandConstant('{#Redist1Exe32}'),'{#Redist1Param}',true);
      end else
      begin
        Exec2(ExpandConstant('{#Redist1Exe64}'),'{#Redist1Param}',true);
        Exec2(ExpandConstant('{#Redist1Exe32}'),'{#Redist1Param}',true);
      end;
    end;
    if ({#Redist2} = 1) then
    begin
      WizardForm.ProgressGauge.Hide;
      WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist2}');
      if not IsWin64 then
      begin
        Exec2(ExpandConstant('{#Redist2Exe32}'),'{#Redist2Param}',true);
      end else
      begin
        Exec2(ExpandConstant('{#Redist2Exe64}'),'{#Redist2Param}',true);
        Exec2(ExpandConstant('{#Redist2Exe32}'),'{#Redist2Param}',true);
      end;
    end;
    if ({#Redist3} = 1) then
    begin
      WizardForm.ProgressGauge.Hide;
      WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist3}');
      if not IsWin64 then
      begin
        Exec2(ExpandConstant('{#Redist3Exe32}'),'{#Redist3Param}',true);
      end else
      begin
        Exec2(ExpandConstant('{#Redist3Exe64}'),'{#Redist3Param}',true);
        Exec2(ExpandConstant('{#Redist3Exe32}'),'{#Redist3Param}',true);
      end;
    end;
    if ({#Redist4} = 1) then
    begin
      WizardForm.ProgressGauge.Hide;
      WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist4}');
      if not IsWin64 then
      begin
        Exec2(ExpandConstant('{#Redist4Exe32}'),'{#Redist4Param}',true);
      end else
      begin
        Exec2(ExpandConstant('{#Redist4Exe64}'),'{#Redist4Param}',true);
        Exec2(ExpandConstant('{#Redist4Exe32}'),'{#Redist4Param}',true);
      end;
    end;
    if ({#Redist5} = 1) then
    begin
      WizardForm.ProgressGauge.Hide;
      WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist5}');
      if not IsWin64 then
      begin
        Exec2(ExpandConstant('{#Redist5Exe32}'),'{#Redist5Param}',true);
      end else
      begin
        Exec2(ExpandConstant('{#Redist5Exe64}'),'{#Redist5Param}',true);
        Exec2(ExpandConstant('{#Redist5Exe32}'),'{#Redist5Param}',true);
      end;
    end;
    if ({#Redist6} = 1) then
    begin
      WizardForm.ProgressGauge.Hide;
      WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist6}');
      if not IsWin64 then
      begin
        Exec2(ExpandConstant('{#Redist6Exe32}'),'{#Redist6Param}',true);
      end else
      begin
        Exec2(ExpandConstant('{#Redist6Exe64}'),'{#Redist6Param}',true);
        Exec2(ExpandConstant('{#Redist6Exe32}'),'{#Redist6Param}',true);
      end;
    end;
    if ({#Redist7} = 1) then
    begin
      WizardForm.ProgressGauge.Hide;
      WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist7}');
      if not IsWin64 then
      begin
        Exec2(ExpandConstant('{#Redist7Exe32}'),'{#Redist7Param}',true);
      end else
      begin
        Exec2(ExpandConstant('{#Redist7Exe64}'),'{#Redist7Param}',true);
        Exec2(ExpandConstant('{#Redist7Exe32}'),'{#Redist7Param}',true);
      end;
    end;
    if ({#Redist8} = 1) then
    begin
      WizardForm.ProgressGauge.Hide;
      WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist8}');
      if not IsWin64 then
      begin
        Exec2(ExpandConstant('{#Redist8Exe32}'),'{#Redist8Param}',true);
      end else
      begin
        Exec2(ExpandConstant('{#Redist8Exe64}'),'{#Redist8Param}',true);
        Exec2(ExpandConstant('{#Redist8Exe32}'),'{#Redist8Param}',true);
      end;
    end;
    if ({#Redist9} = 1) then
    begin
      WizardForm.ProgressGauge.Hide;
      WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist9}');
      if not IsWin64 then
      begin
        Exec2(ExpandConstant('{#Redist9Exe32}'),'{#Redist9Param}',true);
      end else
      begin
        Exec2(ExpandConstant('{#Redist9Exe64}'),'{#Redist9Param}',true);
        Exec2(ExpandConstant('{#Redist9Exe32}'),'{#Redist9Param}',true);
      end;
    end;
    if ({#Redist10} = 1) then
    begin
      WizardForm.ProgressGauge.Hide;
      WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist10}');
      if not IsWin64 then
      begin
        Exec2(ExpandConstant('{#Redist10Exe32}'),'{#Redist10Param}',true);
      end else
      begin
        Exec2(ExpandConstant('{#Redist10Exe64}'),'{#Redist10Param}',true);
        Exec2(ExpandConstant('{#Redist10Exe32}'),'{#Redist10Param}',true);
      end;
    end;
  end;
#endif


procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep = ssInstall) then
  begin
    UltraARC_Process;
  end;

  if (CurStep = ssPostInstall) then
  begin
    #if UseRedists == "1"
      #if CompactMode == "0" /* Install Redist Full Mode */
        if ({#Redist1} = 1) and (RedistsList.Checked[Redist1]) then
        begin
          WizardForm.ProgressGauge.Hide;
          WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist1}');
          if not IsWin64 then
          begin
            Exec2(ExpandConstant('{#Redist1Exe32}'), '{#Redist1Param}',true);
          end else
          begin
            Exec2(ExpandConstant('{#Redist1Exe64}'),'{#Redist1Param}',true);
            Exec2(ExpandConstant('{#Redist1Exe32}'),'{#Redist1Param}',true);
          end;
        end;
        if ({#Redist2} = 1) and (RedistsList.Checked[Redist2]) then
        begin
          WizardForm.ProgressGauge.Hide;
          WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist2}');
          if not IsWin64 then
          begin
            Exec2(ExpandConstant('{#Redist2Exe32}'),'{#Redist2Param}',true);
          end else
          begin
            Exec2(ExpandConstant('{#Redist2Exe64}'),'{#Redist2Param}',true);
            Exec2(ExpandConstant('{#Redist2Exe32}'),'{#Redist2Param}',true);
          end;
        end;
        if ({#Redist3} = 1) and (RedistsList.Checked[Redist3]) then
        begin
          WizardForm.ProgressGauge.Hide;
          WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist3}');
          if not IsWin64 then
          begin
            Exec2(ExpandConstant('{#Redist3Exe32}'),'{#Redist3Param}',true);
          end else
          begin
            Exec2(ExpandConstant('{#Redist3Exe64}'),'{#Redist3Param}',true);
            Exec2(ExpandConstant('{#Redist3Exe32}'),'{#Redist3Param}',true);
          end;
        end;
        if ({#Redist4} = 1) and (RedistsList.Checked[Redist4]) then
        begin
          WizardForm.ProgressGauge.Hide;
          WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist4}');
          if not IsWin64 then
          begin
            Exec2(ExpandConstant('{#Redist4Exe32}'),'{#Redist4Param}',true);
          end else
          begin
            Exec2(ExpandConstant('{#Redist4Exe64}'),'{#Redist4Param}',true);
            Exec2(ExpandConstant('{#Redist4Exe32}'),'{#Redist4Param}',true);
          end;
        end;
        if ({#Redist5} = 1) and (RedistsList.Checked[Redist5]) then
        begin
          WizardForm.ProgressGauge.Hide;
          WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist5}');
          if not IsWin64 then
          begin
            Exec2(ExpandConstant('{#Redist5Exe32}'),'{#Redist5Param}',true);
          end else
          begin
            Exec2(ExpandConstant('{#Redist5Exe64}'),'{#Redist5Param}',true);
            Exec2(ExpandConstant('{#Redist5Exe32}'),'{#Redist5Param}',true);
          end;
        end;
        if ({#Redist6} = 1) and (RedistsList.Checked[Redist6]) then
        begin
          WizardForm.ProgressGauge.Hide;
          WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist6}');
          if not IsWin64 then
          begin
            Exec2(ExpandConstant('{#Redist6Exe32}'),'{#Redist6Param}',true);
          end else
          begin
            Exec2(ExpandConstant('{#Redist6Exe64}'),'{#Redist6Param}',true);
            Exec2(ExpandConstant('{#Redist6Exe32}'),'{#Redist6Param}',true);
          end;
        end;
        if ({#Redist7} = 1) and (RedistsList.Checked[Redist7]) then
        begin
          WizardForm.ProgressGauge.Hide;
          WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist7}');
          if not IsWin64 then
          begin
            Exec2(ExpandConstant('{#Redist7Exe32}'),'{#Redist7Param}',true);
          end else
          begin
            Exec2(ExpandConstant('{#Redist7Exe64}'),'{#Redist7Param}',true);
            Exec2(ExpandConstant('{#Redist7Exe32}'),'{#Redist7Param}',true);
          end;
        end;
        if ({#Redist8} = 1) and (RedistsList.Checked[Redist8]) then
        begin
          WizardForm.ProgressGauge.Hide;
          WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist8}');
          if not IsWin64 then
          begin
            Exec2(ExpandConstant('{#Redist8Exe32}'),'{#Redist8Param}',true);
          end else
          begin
            Exec2(ExpandConstant('{#Redist8Exe64}'),'{#Redist8Param}',true);
            Exec2(ExpandConstant('{#Redist8Exe32}'),'{#Redist8Param}',true);
          end;
        end;
        if ({#Redist9} = 1) and (RedistsList.Checked[Redist9]) then
        begin
          WizardForm.ProgressGauge.Hide;
          WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist9}');
          if not IsWin64 then
          begin
            Exec2(ExpandConstant('{#Redist9Exe32}'),'{#Redist9Param}',true);
          end else
          begin
            Exec2(ExpandConstant('{#Redist9Exe64}'),'{#Redist9Param}',true);
            Exec2(ExpandConstant('{#Redist9Exe32}'),'{#Redist9Param}',true);
          end;
        end;
        if ({#Redist10} = 1) and (RedistsList.Checked[Redist10]) then
        begin
          WizardForm.ProgressGauge.Hide;
          WizardForm.StatusLabel.Caption := ExpandConstant('{cm:InstallingRedist10}');
          if not IsWin64 then
          begin
            Exec2(ExpandConstant('{#Redist10Exe32}'),'{#Redist10Param}',true);
          end else
          begin
            Exec2(ExpandConstant('{#Redist10Exe64}'),'{#Redist10Param}',true);
            Exec2(ExpandConstant('{#Redist10Exe32}'),'{#Redist10Param}',true);
          end;
        end;
      #else /* Install Redist Compact Mode */
        if RedistCB.Checked then
          InstallRedistsCMode;
      #endif
    #endif
    if UninstallCB.Checked then
    begin
      #if VCL == "1"
        FileCopy(ExpandConstant('{tmp}\VclStylesinno.dll'), ExpandConstant('{app}\{#UnInstallFolder}\VclStylesInno.dll'), False);
        FileCopy(ExpandConstant('{tmp}\{#VCLName}'), ExpandConstant('{app}\{#UnInstallFolder}\{#VCLName}'), False);
      #elif Cjstyles == "1"
        FileCopy(ExpandConstant('{tmp}\ISSkin.dll'), ExpandConstant('{app}\{#UnInstallFolder}\ISSkin.dll'), False);
        FileCopy(ExpandConstant('{tmp}\{#CjstylesName}'), ExpandConstant('{app}\{#UnInstallFolder}\{#CjstylesName}'), False);
      #endif
      RegWriteDWordValue(HKLM, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#Name}_is1', 'EstimatedSize',  Round(InstallationSize / PowerK(1, POWER_KB)));
    end;
  end;

  if (CurStep = ssDone) then
  begin
    #if UWPGame == "1"
      Exec2(ExpandConstant('{app}\UWP_Tool.exe'), '', true);
    #endif
    #if CompactMode == "1"
      if (ISDoneError = False) then
      begin
        if (IconsCB.Checked) then
        begin
          MsgBox(AppNameOverride(msgFinishedLabel), mbInformation, MB_OK);
        end else
        begin
          MsgBox(AppNameOverride(msgFinishedLabelNoIcons), mbInformation, MB_OK);
        end;
      end else
      begin
        MsgBox(AppNameOverride(msgSetupAborted), mbInformation, MB_OK);
      end;
    #endif
    #if ZTool
      Exec(ExpandConstant('{sys}\taskkill.exe'), ' /F /IM ZTool.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    #endif
    #if XTool
      Exec(ExpandConstant('{sys}\taskkill.exe'), ' /F /IM XTool.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    #endif
    #if INISettings == "1"
      if FileExists(ExpandConstant('{#INIFile}')) then
        SetIniString('{#Section}', '{#Key}', WizardForm.UserInfoNameEdit.Text, ExpandConstant('{#INIFile}'));
        SetIniString('{#Section}', 'Language', ActiveLanguage, ExpandConstant('{#INIFile}'));
    #endif
  end;
end;


function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := False;
  #if CheckCRC == "1"
    if (PageID = CRCPage.ID) then
      Result := (PageID = CRCPage.ID) and (not CRCCheckCB.Checked or ISDoneError);
  #endif
  #if (CompactMode == "0") && (UseComponents == "1")
    if (PageID = ComponentsPage.ID) then
      Result := (not ComponentsPageAvai);
  #endif
  #if (CompactMode == "1") && (UseInfo == "1")
    if (PageID = wpInfoBefore) then
      Result := True;
  #endif
end;


procedure CurPageChanged(CurPageID: integer);
  #if UseComponents == "1"
  var
    I: Integer;
    CompFile: String;
    ReloadComponents: Boolean;
  #endif
begin

#if CompactMode == "0"  /* Full Installer Mode */

  if CurPageID = wpWelcome then
  begin
    #if UseComponents == "1"
      ReloadComponents := False;
      if ComponentsPageAvai then
      begin
        for I := 0 to GetArrayLength(CompIndexList) - 1 do
        begin
          CompFile := GetIniString('ComponentsSettings', 'Component' + IntToStr(CompIndexList[I]) + '.File', '', ExpandConstant('{tmp}\Settings.ini'));
          if (ExtractFileExt(CompFile) <> '') and (not FileExists(ExpandConstant('{src}\' + CompFile))) then
          begin
            ComponentsList.Checked[CompIndexList[I]] := False;
            ComponentsList.ItemEnabled[CompIndexList[I]] := False;
            ReloadComponents := True;
          end;
        end;
        if ReloadComponents then
        begin
          ComponentsSize := 0;
          for I := 0 to GetArrayLength(CompIndexList) - 1 do
            if ComponentsList.Checked[CompIndexList[I]] then
              ComponentsSize := ComponentsSize + GetSizeBytes(GetIniString('ComponentsSettings', 'Component' + IntToStr(CompIndexList[I]) + '.Size', '0', ExpandConstant('{tmp}\Settings.ini')), ComponentsSize);
          ComponentsDiskSpaceLabel.Caption := FormatDiskSpaceLabel(SetupMessage(msgComponentsDiskSpaceMBLabel), ComponentsSize + GetSizeBytes(GetIniString('Settings', 'Size', '0', ExpandConstant('{tmp}\Settings.ini')), ComponentsSize));
          ComponentsDiskSpaceLabel.Refresh;
        end;
      end;
    #endif
    #if UseInstallBackground == "1"
      BackgroundButton.Hide;
    #endif
    AboutButton.Show;
    PercentLabel.Hide;
    ElapsedLabel.Hide;
    RemainingLabel.Hide;
    PauseButton.Hide;
    WizardForm.DirEdit.Hide;
    WizardForm.DirBrowseButton.Hide;
    WizardForm.GroupEdit.Hide;
    WizardForm.GroupBrowseButton.Hide;
    WizardForm.PageNameLabel.Hide;
    WizardForm.PageDescriptionLabel.Hide;
    WizardForm.ProgressGauge.Hide;
    WizardForm.UserInfoNameLabel.Hide;
    WizardForm.UserInfoNameEdit.Hide;
    #if (WebsiteButton == "1") && (Music == "0")
      WizardForm.NextButton.Top := WizardForm.CancelButton.Top;
      WizardForm.BackButton.Top := WizardForm.CancelButton.Top;
    #endif
    #if (WebsiteButton == "0") && (Music == "1")
      WizardForm.NextButton.Top := WizardForm.CancelButton.Top;
      WizardForm.BackButton.Top := WizardForm.CancelButton.Top;
    #endif
  end;

  #if UseLicense == "1"
    if CurPageID = wpLicense then
    begin
      AboutButton.Hide;
      WizardForm.DirEdit.Hide;
      WizardForm.DirBrowseButton.Hide;
      WizardForm.GroupEdit.Hide;
      WizardForm.GroupBrowseButton.Hide;
      WizardForm.PageNameLabel.Hide;
      WizardForm.PageDescriptionLabel.Hide;
      WizardForm.UserInfoNameLabel.Hide;
      WizardForm.UserInfoNameEdit.Hide;
    end;
  #endif

  #if UseInfo == "1"
    if CurPageID = wpInfoBefore then
    begin
      AboutButton.Hide;
      WizardForm.DirEdit.Hide;
      WizardForm.DirBrowseButton.Hide;
      WizardForm.GroupEdit.Hide;
      WizardForm.GroupBrowseButton.Hide;
      WizardForm.PageNameLabel.Hide;
      WizardForm.PageDescriptionLabel.Hide;
      WizardForm.UserInfoNameLabel.Hide;
      WizardForm.UserInfoNameEdit.Hide;
    end;
  #endif

  #if UseSystemReq == "1"
    if CurPageID = SystemReqPage.ID then
    begin
      AboutButton.Hide;
      WizardForm.DirEdit.Hide;
      WizardForm.DirBrowseButton.Hide;
      WizardForm.GroupEdit.Hide;
      WizardForm.GroupBrowseButton.Hide;
      WizardForm.PageNameLabel.Hide;
      WizardForm.PageDescriptionLabel.Hide;
      WizardForm.UserInfoNameLabel.Hide;
      WizardForm.UserInfoNameEdit.Hide;
    end;
  #endif

  #if UseComponents == "1"
    if CurPageID = ComponentsPage.ID then
    begin
      WizardForm.DirEdit.Hide;
      WizardForm.DirBrowseButton.Hide;
      WizardForm.GroupBrowseButton.Hide;
      WizardForm.UserInfoNameLabel.Hide;
      WizardForm.UserInfoNameEdit.Hide;
    end;
  #endif

  if CurPageID = wpSelectDir then
  begin
    WizardForm.DirEdit.Show;
    WizardForm.DirBrowseButton.Show;
    WizardForm.GroupEdit.Show;
    WizardForm.GroupBrowseButton.Show;
    WizardForm.DiskSpaceLabel.Hide;
    WizardForm.UserInfoNameLabel.Show;
    WizardForm.UserInfoNameEdit.Show;
    StartMenuCB.Show;
    AboutButton.Hide;
    FreeSpaceLabel.Show;
    NeedSpaceLabel.Show;
    GetFreeSpaceCaption(nil);
    IconsCB.Show;
    if ({#UseRedists} = 1) then
    begin
      WizardForm.NextButton.Caption := SetupMessage(msgButtonNext);
    end else
    begin
      WizardForm.NextButton.Caption := SetupMessage(msgButtonInstall);
    end;
  end;

  #if UseRedists == "1"
    if CurPageID = wpReady then
    begin
      WizardForm.NextButton.Caption := SetupMessage(msgButtonInstall);
      WizardForm.ReadyMemo.Hide;
      WizardForm.DirEdit.Hide;
      WizardForm.DirBrowseButton.Hide;
      WizardForm.GroupEdit.Hide;
      WizardForm.GroupBrowseButton.Hide;
      WizardForm.UserInfoNameLabel.Hide;
      WizardForm.UserInfoNameEdit.Hide;
    end;
  #endif

  if CurPageID = wpInstalling then
  begin
    WizardForm.ClientWidth := ScaleX(600);
    WizardForm.ClientHeight := ScaleY(149);
    WizardForm.UserInfoNameLabel.Hide;
    WizardForm.UserInfoNameEdit.Hide;
    WizardForm.ProgressGauge.Show;
    PercentLabel.Show;
    ElapsedLabel.Show;
    WizardForm.PageDescriptionLabel.Hide;
    WizardForm.PageNameLabel.Hide;
    WizardForm.MainPanel.Hide;
    WizardForm.Bevel.Hide;
    WizardForm.Bevel1.Hide;
    WizardForm.DirBrowseButton.Hide;
    WizardForm.DirEdit.Hide;
    WizardForm.GroupEdit.Hide;
    WizardForm.GroupBrowseButton.Hide;
    WizardForm.SelectDirBitmapImage.Hide;
    WizardForm.PageNameLabel.Hide;
    WizardForm.PageDescriptionLabel.Hide;
    WizardForm.StatusLabel.Parent := WizardForm.InnerPage;
    WizardForm.StatusLabel.Left := WizardForm.ProgressGauge.Left;
    WizardForm.StatusLabel.Top := ScaleY(9);
    WizardForm.FileNameLabel.Parent := WizardForm.InnerPage;
    WizardForm.FileNameLabel.Left := WizardForm.ProgressGauge.Left;
    WizardForm.FileNameLabel.Top := ScaleY(26);
    WizardForm.FilenameLabel.Width := WizardForm.ProgressGauge.Width;
    WizardForm.CancelButton.Parent := WizardForm.InnerPage;
    WizardForm.CancelButton.Left := ScaleX(514);
    WizardForm.CancelButton.Top := ScaleY(113);
    WizardForm.ProgressGauge.Top := ScaleY(43);
    PauseButton.Show;
    PauseButton.Left := (WizardForm.CancelButton.Left - WizardForm.CancelButton.Width) - ScaleX(10);
    PauseButton.Top := WizardForm.CancelButton.Top;
    if ({#WebsiteButton} = 1) then
    begin
      WebsiteButton.Hide;
    end;
    #if Music == "1"
      #if UseInstallBackground == "1"
        MusicButton.Left := ScaleX(170);
        MusicButton.Top := WizardForm.CancelButton.Top;
      #else
        MusicButton.Left := ScaleX(11);
        MusicButton.Top := WizardForm.CancelButton.Top;
      #endif
    #endif
    #if UseInstallBackground == "1"
      WizardForm.Position := poScreenCenter;
      WizardForm.Hide;
      MakeSlideShow();
      TimerID := SetTimer(0, 0, {#Duration}, WrapTimerProc(@OnTimer, 4));
      WizardForm.Top := GetSystemMetrics(1) - ScaleY(225);
      WizardForm.Show;
      BackgroundButton.Show;
      BackgroundButton.Left := ScaleX(11);
      BackgroundButton.Top := WizardForm.CancelButton.Top;
    #else
      WizardForm.Position := poScreenCenter;
    #endif
    StartTick := GetTickCount;
    if not IniKeyExists('Record2', 'Type', ExpandConstant('{{#InternalRecords == "1" ? "tmp" : "src"}}\records.ini')) then
      RemainingLabel.Show;
  end;

  #if CheckCRC == "1"
    if CurPageID = CRCPage.ID then
    begin
      #if UseInstallBackground == "1"
        BackgroundButton.Hide;
        #if BGAfterInstall == "0"
          {For DeinitializeSlideShow when finished}
          BackgroundForm.Visible := False
          DeinitializeSlideShow;
          KillTimer(0, TimerID);
        #endif
      #endif
      WizardForm.ClientWidth := ScaleX(600);
      WizardForm.ClientHeight := ScaleY(429);
      WizardForm.StatusLabel.Hide;
      WizardForm.FileNameLabel.Hide;
      WizardForm.MainPanel.Show;
      WizardForm.StatusLabel.Hide;
      WizardForm.PageNameLabel.Hide;
      WizardForm.PageDescriptionLabel.Hide;
      WizardForm.CancelButton.Hide;
      WizardForm.ProgressGauge.Hide;
      WizardForm.UserInfoNameLabel.Hide;
      WizardForm.UserInfoNameEdit.Hide;
      PercentLabel.Hide;
      ElapsedLabel.Hide;
      RemainingLabel.Hide;
      PauseButton.Hide;
      LogButton.Show;
      LogButton.Left := (WizardForm.NextButton.Left - WizardForm.NextButton.Width) - ScaleX(10)
      LogButton.Top := ScaleY(394);
      CRCCancelButton.Show;
      CRCCancelButton.Left := WizardForm.CancelButton.Left
      CRCCancelButton.Top := LogButton.Top
      WizardForm.NextButton.Left := ScaleX(423);
      WizardForm.NextButton.Top := ScaleY(394);
      WizardForm.NextButton.Enabled := Checked;
      WizardForm.NextButton.Caption := SetupMessage(msgButtonNext);
      WizardForm.Position := poScreenCenter;
      #if WebsiteButton == "1"
        WebsiteButton.Show;
        WebsiteButton.Left := ScaleX(13);
        WebsiteButton.Top := ScaleY(394);
        WebsiteButton.Parent := WizardForm;
      #endif
      #if (Music == "1") && (WebsiteButton == "1")
          MusicButton.Left := ScaleX(169);
          MusicButton.Top := ScaleY(394);
      #endif
      #if (Music == "1") && (WebsiteButton == "0")
        MusicButton.Left := ScaleX(13);
        MusicButton.Top := ScaleY(394);
      #endif
    end;
  #endif

  if CurPageID = wpFinished then
  begin
    WizardForm.ClientWidth := ScaleX(600);
    WizardForm.ClientHeight := ScaleY(429);
    #if CheckCRC == "1"
      if not CRCCheckCB.Checked then
      begin
        WizardForm.NextButton.Parent := WizardForm;
        #if UseInstallBackground == "1"
          BackgroundButton.Hide;
          #if BGAfterInstall == "0"
            {For DeinitializeSlideShow when finished}
            BackgroundForm.Visible := False
            DeinitializeSlideShow;
            KillTimer(0, TimerID);
          #endif
        #endif
      end;
      if CRCCheckCB.Checked then
      begin
        CRCCheckCB.Hide;
        CRCCancelButton.Hide;
        LogButton.Hide;
        HashProgressBar1.Hide;
        HashProgressBar2.Hide;
        WizardForm.BackButton.Visible := False;
        WizardForm.NextButton.Parent := WizardForm;
      end;
    #endif
    WizardForm.NextButton.Left := ScaleX(512);
    WizardForm.NextButton.Top := ScaleY(393);
    WizardForm.NextButton.Show;
    WizardForm.CancelButton.Hide;
    WizardForm.UserInfoNameLabel.Hide;
    WizardForm.UserInfoNameEdit.Hide;
    AboutButton.Show;
    PauseButton.Hide;
    PercentLabel.Hide;
    RemainingLabel.Hide;
    ElapsedLabel.Hide;
    WizardForm.ProgressGauge.Hide;
    WizardForm.Position := poScreenCenter;
    WizardForm.WizardBitmapImage2.Width := ScaleX(600);
    WizardForm.WizardBitmapImage2.Height := ScaleY(379);
    WizardForm.WizardBitmapImage2.Show;
    WizardForm.WizardBitmapImage.Hide;
    WizardForm.WizardSmallBitmapImage.Hide;
    #if (WebsiteButton == "1") && (Music == "1") && (UseInstallBackground == "1")
      WebsiteButton.Left := ScaleX(13);
      WebsiteButton.Top := WizardForm.NextButton.Top;
      WebsiteButton.Show;
      MusicButton.Left := ScaleX(170);
      MusicButton.Top := WizardForm.NextButton.Top;
      MusicButton.Show;
      BackgroundButton.Left := ScaleX(246);
      BackgroundButton.Top := WizardForm.NextButton.Top;
      BackgroundButton.Show;
    #endif
    #if (WebsiteButton == "1") && (Music == "1") && (UseInstallBackground == "0")
      WebsiteButton.Left := ScaleX(13);
      WebsiteButton.Top := WizardForm.NextButton.Top;
      WebsiteButton.Show;
      MusicButton.Left := ScaleX(170);
      MusicButton.Top := WizardForm.NextButton.Top;
      MusicButton.Show;
    #endif
    #if (WebsiteButton == "1") && (Music == "0") && (UseInstallBackground == "0")
      WebsiteButton.Left := ScaleX(13);
      WebsiteButton.Top := WizardForm.NextButton.Top;
      WebsiteButton.Show;
    #endif
    #if (WebsiteButton == "0") && (Music == "0") && (UseInstallBackground == "1")
      BackgroundButton.Left := ScaleX(13);
      BackgroundButton.Top := WizardForm.NextButton.Top;
      BackgroundButton.Show;
    #endif
    #if (WebsiteButton == "0") && (Music == "1") && (UseInstallBackground == "1")
      MusicButton.Left := ScaleX(13);
      MusicButton.Top := WizardForm.NextButton.Top;
      MusicButton.Show;
      BackgroundButton.Left := ScaleX(89);
      BackgroundButton.Top := WizardForm.NextButton.Top;
      BackgroundButton.Show;
    #endif
    #if (WebsiteButton == "0") && (Music == "1") && (UseInstallBackground == "0")
      MusicButton.Left := ScaleX(13);
      MusicButton.Top := WizardForm.NextButton.Top;
      MusicButton.Show;
    #endif
    #if (WebsiteButton == "1") && (Music == "0") && (UseInstallBackground == "1")
      WebsiteButton.Left := ScaleX(13);
      WebsiteButton.Top := WizardForm.NextButton.Top;
      WebsiteButton.Show;
      BackgroundButton.Left := ScaleX(170);
      BackgroundButton.Top := WizardForm.NextButton.Top;
      BackgroundButton.Show;
    #endif
  end;
  
#else /* Compact Mode

  if CurPageID = wpWelcome then
  begin
    #if UseComponents == "1"
      ReloadComponents := False;
      SelectComponentsLabel.Show;
    #endif
    WizardForm.CancelButton.Show;
    WizardForm.CancelButton.Parent := WizardForm.WelcomePage;
    WizardForm.NextButton.Show;
    WizardForm.NextButton.Parent := WizardForm.WelcomePage;
    WizardForm.NextButton.Caption := AppNameOverride(msgButtonInstall);
    WizardForm.ProgressGauge.Show;
    WizardForm.ProgressGauge.Enabled := False;
    WizardForm.DiskSpaceLabel.Hide;
    #if UseRedists == "1"
      RedistCB.Enabled := False;
      RedistCB.Checked := False;
    #endif
    #if CheckCRC == "1"
      HashProgressBar1.Hide;
      HashProgressBar2.Hide;
      CheckFileLabel.Hide;
      OveralCheckLabel.Hide;
      CRCInfoMemo.Hide;
      CRCLogMemo.Hide;
      CRCCancelButton.Hide;
      LogButton.Hide;
      HashHdrLabel.Hide;
    #endif
    PauseButton.Show;
    PauseButton.Enabled := False;
    PauseButton.Parent := WizardForm.WelcomePage;
    FreeSpaceLabel.Show;
    FreeSpaceLabel.Parent := WizardForm.WelcomePage;
    NeedSpaceLabel.Show;
    NeedSpaceLabel.Parent := WizardForm.WelcomePage;
    NeedSpaceLabel.Left := CRCCheckCB.Left;
    GetFreeSpaceCaption(nil);
    IconsCB.Show;
    CRCCheckCB.Show;
    UninstallCB.Show;
    PercentLabel.Hide;
    ElapsedLabel.Hide;
    RemainingLabel.Hide;
  end;

  if CurPageID = wpInstalling then
  begin
    WizardForm.CancelButton.Show;
    WizardForm.CancelButton.Parent := WizardForm;
    WizardForm.NextButton.Show;
    WizardForm.NextButton.Parent := WizardForm;
    WizardForm.NextButton.Caption := AppNameOverride(msgButtonInstall);
    WizardForm.NextButton.Enabled := False;
    WizardForm.ProgressGauge.Show;
    WizardForm.ProgressGauge.Enabled := True;
    WizardForm.DiskSpaceLabel.Hide;
    WizardForm.FilenameLabel.Show;
    WizardForm.FilenameLabel.Parent := WizardForm;
    WizardForm.FilenameLabel.Left := WizardForm.ProgressGauge.Left;
    WizardForm.FilenameLabel.Top := ScaleY(107);
    WizardForm.FilenameLabel.Width := WizardForm.ProgressGauge.Width;
    WizardForm.FilenameLabel.Height := ScaleY(14);
    WizardForm.DirBrowseButton.Enabled := False;
    WizardForm.DirEdit.Enabled := False;
    #if Music == "1"
      MusicButton.Parent := WizardForm;
    #endif
    #if UseComponents == "1"
      SelectComponentsLabel.Hide;
    #endif
    PauseButton.Show;
    PauseButton.Enabled := True;
    PauseButton.Parent := WizardForm;
    FreeSpaceLabel.Show;
    FreeSpaceLabel.Enabled := False;
    FreeSpaceLabel.Parent := WizardForm.WelcomePage;
    NeedSpaceLabel.Show;
    NeedSpaceLabel.Enabled := False;
    NeedSpaceLabel.Parent := WizardForm.WelcomePage;
    GetFreeSpaceCaption(nil);
    IconsCB.Show;
    IconsCB.Enabled := False;
    IconsCB.Parent := WizardForm;
    CRCCheckCB.Show;
    CRCCheckCB.Enabled := False;
    CRCCheckCB.Parent := WizardForm;
    UninstallCB.Show;
    UninstallCB.Enabled := False;
    UninstallCB.Parent := WizardForm;
    RedistCB.Enabled := False;
    LimitRAMCB.Enabled := False;
    AboutButtonCM.Enabled := False;
    #if UseInfo == "1"
      InfoButtonCM.Enabled := False;
    #endif
    PercentLabel.Show;
    ElapsedLabel.Show;
    StartTick := GetTickCount;
    if not IniKeyExists('Record2', 'Type', ExpandConstant('{{#InternalRecords == "1" ? "tmp" : "src"}}\records.ini')) then
      RemainingLabel.Show;
  end;

  #if CheckCRC == "1"
    if CurPageID = CRCPage.ID then
    begin
      WizardForm.ClientWidth  := ScaleX(460);
      WizardForm.ClientHeight := ScaleY(187);
      WizardForm.InnerPage.Hide;
      WizardForm.StatusLabel.Hide;
      WizardForm.FileNameLabel.Hide;
      WizardForm.MainPanel.Show;
      WizardForm.StatusLabel.Hide;
      WizardForm.PageNameLabel.Hide;
      WizardForm.PageDescriptionLabel.Hide;
      WizardForm.CancelButton.Hide;
      WizardForm.ProgressGauge.Hide;
      WizardForm.UserInfoNameLabel.Hide;
      WizardForm.UserInfoNameEdit.Hide;
      WizardForm.DirEdit.Hide;
      WizardForm.DirBrowseButton.Hide;
      WizardForm.MainPanel.Hide;
      IconsCB.Hide;
      UninstallCB.Hide;
      CRCCheckCB.Hide;
      RedistCB.Hide;
      LimitRAMCB.Hide;
      PercentLabel.Hide;
      ElapsedLabel.Hide;
      RemainingLabel.Hide;
      PauseButton.Hide;
      HashProgressBar1.Show;
      HashProgressBar2.Show;
      CheckFileLabel.Show;
      OveralCheckLabel.Show;
      CRCInfoMemo.Show;
      CRCCancelButton.Show;
      LogButton.Show;
      HashHdrLabel.Show;
      WizardForm.NextButton.Enabled := Checked;
      WizardForm.NextButton.Caption := SetupMessage(msgButtonNext);
      WizardForm.Position := poScreenCenter;
      WizardForm.InnerNotebook.Hide;
      WizardForm.OuterNotebook.Hide;
      #if UseComponents == "1"
        SelectComponentsLabel.Hide;
      #endif
    end;
  #endif

  if CurPageID = wpFinished then
  begin
    WizardForm.InnerNotebook.Show;
    WizardForm.OuterNotebook.Show;
    #if UseComponents == "1"
      SelectComponentsLabel.Show;
    #endif
    WizardForm.NextButton.Show;
    WizardForm.CancelButton.Hide;
    PauseButton.Hide;
    PercentLabel.Hide;
    ElapsedLabel.Hide;
    WizardForm.Position := poScreenCenter;
  end;
#endif
end;


procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
  SuspendProc;
  Confirm := False;
  Cancel := MessageBox(WizardForm.Handle, Utf8ToAnsi(SetupMessage(msgExitSetupMessage)), Utf8ToAnsi(SetupMessage(msgExitSetupTitle)), MB_ICONINFORMATION or MB_YESNO or MB_TASKMODAL) = IDYES;
//  Cancel := MessageBox(0, 'Msg Text', 'Message box title', MB_OK or MB_ICONERROR or MB_TASKMODAL);
//  Cancel := ExitSetupMsgBox;
  if Cancel then
  begin
    WizardForm.StatusLabel.Width := ScaleX(350);
    WizardForm.StatusLabel.Caption := SetupMessage(msgStatusRollback);
    WizardForm.FilenameLabel.Hide;
    #if ZTool
      Exec(ExpandConstant('{sys}\taskkill.exe'), ' /F /IM ZTool.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    #endif
    #if XTool
      Exec(ExpandConstant('{sys}\taskkill.exe'), ' /F /IM XTool.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    #endif
  end;

  if CurPageID = wpInstalling then
  begin
    if Cancel then
    begin
      ISDoneError := True;
      ISDoneCancel := 1;
      WizardForm.CancelButton.Enabled := False;
      #if CompactMode == "0"
        MsgBox(AppNameOverride(msgSetupAborted), mbInformation, MB_OK);
      #endif
      #if Music == "1"
        BASS_Free;
      #endif
      #if ZTool
        Exec(ExpandConstant('{sys}\taskkill.exe'), ' /F /IM ZTool.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
      #endif
      #if XTool
        Exec(ExpandConstant('{sys}\taskkill.exe'), ' /F /IM XTool.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
      #endif
      DelTree(ExpandConstant('{app}'), True, True, True);
      WizardForm.Close;
      ExitProcess(0);
    end;
  end;
  ResumeProc;
end;


function InitializeSetup(): Boolean;
begin
  Result := True;
  ExtractTemporaryFile('Settings.ini');
  if not FontExists('{#Font}') then
  begin
    ExtractTemporaryFile('Font.ttf');
    AddFontResource(ExpandConstant('{tmp}\Font.ttf'), FR_PRIVATE, 0);
  end;
  #if VCL == "1"
    ExtractTemporaryFile('VclStylesInno.dll');
    ExtractTemporaryFile('{#VCLName}');
    LoadVCLStyle(ExpandConstant('{tmp}\{#VCLName}'));
  #elif Cjstyles == "1"
    ExtractTemporaryFile('ISSkin.dll');
    ExtractTemporaryFile('{#CjstylesName}');
    LoadSkin(ExpandConstant('{tmp}\{#CjstylesName}'), '{#CjstylesParam}');
  #endif
  #if ShowLanguageBox == "1"
    if Pos('/LANG=', UpperCase(GetCmdTail)) = 0 then
      Result := CreateLangDialog;
  #endif
end;


procedure DeinitializeSetup();
begin
  if FileExists(ExpandConstant('{tmp}\Font.ttf')) then
  begin
    RemoveFontResource(ExpandConstant('{tmp}\Font.ttf'), FR_PRIVATE, 0);
  end;
  #if VCL == "1"
    UnLoadVCLStyles();
  #elif Cjstyles == "1"
    ShowWindow(StrToInt(ExpandConstant('{wizardhwnd}')), SW_HIDE);
    UnloadSkin();
  #endif
  #if Music == "1"
    BASS_Free;
  #endif
  #if (CompactMode == "0") && (UseInstallBackground == "1")
    DeinitializeSlideShow;
    KillTimer(0, TimerID);
  #endif
end;


function InitializeUninstall(): Boolean;
begin
  Result := True;
  #if VCL == "1"
    FileCopy(ExpandConstant('{app}\{#UnInstallFolder}\VclStylesInno.dll'), ExpandConstant('{tmp}\VclStylesInno.dll'), False);
    FileCopy(ExpandConstant('{app}\{#UnInstallFolder}\{#VCLName}'), ExpandConstant('{tmp}\{#VCLName}'), False);
    LoadVCLStyle(ExpandConstant('{tmp}\{#VCLName}'));
  #elif Cjstyles == "1"
    FileCopy(ExpandConstant('{app}\{#UnInstallFolder}\ISSkin.dll'), ExpandConstant('{tmp}\ISSkin.dll'), False);
    FileCopy(ExpandConstant('{app}\{#UnInstallFolder}\{#CjstylesName}'), ExpandConstant('{tmp}\{#CjstylesName}'), False);
    LoadSkin(ExpandConstant('{tmp}\{#CjstylesName}'), '{#CjstylesParam}');
  #endif
end;


procedure DeinitializeUninstall();
begin
  #if VCL == "1"
    UnLoadVCLStyles();
  #elif Cjstyles == "1"
    ShowWindow(0, SW_HIDE);
    UnloadSkin();
  #endif
end;


[UninstallDelete]
Type: filesandordirs; Name: {app}
#sub RemoveShortcut
  #emit "Type: Files; Name: ""{userdesktop}\" + Trim(ReadIni(SourcePath + "\Settings.ini", "Executable" + Str(i), "ShortcutName", "")) + ".lnk"";"
  #emit "Type: Files; Name: ""{userprograms}\" + Trim(ReadIni(SourcePath + "\Settings.ini", "Settings", "ShortcutName", "")) + "\" + Trim(ReadIni(SourcePath + "\Settings.ini", "Executable" + Str(i), "ShortcutName", "")) + ".lnk"";"
#endsub
#for {i = 1; Trim(ReadIni(SourcePath + "\Settings.ini", "Executable" + Str(i), "ShortcutName", "")) != ""; i++} RemoveShortcut


#ifdef DEBUG
  #expr SaveToFile(AddBackslash(SourcePath) + "Script_PREPROCESSED.iss")
#endif