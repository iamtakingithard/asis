///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Settings
#define Name ReadIni(SourcePath + "\Settings.ini", "Settings", "Name", "")
#define Creator ReadIni(SourcePath + "\Settings.ini", "Settings", "Creator", "")
#define SizeMB ReadIni(SourcePath + "\Settings.ini", "Settings", "Size", "")
#define x64 ReadIni(SourcePath + "\Settings.ini", "Settings", "64BitOnly", "")
#define UWPGame ReadIni(SourcePath + "\Settings.ini", "Settings", "UWPGame", "")
#define ShowLanguageBox ReadIni(SourcePath + "\Settings.ini", "Settings", "ShowLanguageBox", "")
#define UnInstallFolder ReadIni(SourcePath + "\Settings.ini", "Settings", "UnInstallFolder", "")
#define CompactMode ReadIni(SourcePath + "\Settings.ini", "Settings", "CompactMode", "")

// INISettings
#define INISettings ReadIni(SourcePath + "\Settings.ini", "INISettings", "Enable", "")
#define INIFile ReadIni(SourcePath + "\Settings.ini", "INISettings", "INIFile", "")
#define Section ReadIni(SourcePath + "\Settings.ini", "INISettings", "Section", "")
#define Key ReadIni(SourcePath + "\Settings.ini", "INISettings", "Key", "")
#define Value ReadIni(SourcePath + "\Settings.ini", "INISettings", "Value", "")

// ExtractSettings
#define InternalCompression ReadIni(SourcePath + "\Settings.ini", "ExtractSettings", "InternalCompression", "")
#define InternalCompressionType ReadIni(SourcePath + "\Settings.ini", "ExtractSettings", "InternalCompressionType", "")
#define InternalRecords ReadIni(SourcePath + "\Settings.ini", "ExtractSettings", "InternalRecords", "")
#define GameFolder ReadIni(SourcePath + "\Settings.ini", "ExtractSettings", "GameFolder", "")
#define DefaultDir ReadIni(SourcePath + "\Settings.ini", "ExtractSettings", "DefaultInstallDir", "")

// ComponentsSettings
#define UseComponents ReadIni(SourcePath + "Settings.ini", "ComponentsSettings", "Enable", "0")

// Installer
#define WelcomeBackground ReadIni(SourcePath + "\Settings.ini", "Installer", "WelcomeBackground", "")
#define FinishBackground ReadIni(SourcePath + "\Settings.ini", "Installer", "FinishBackground", "")
#define BannerBackground ReadIni(SourcePath + "\Settings.ini", "Installer", "BannerBackground", "")

// Background
#define UseInstallBackground ReadIni(SourcePath + "\Settings.ini", "Background", "Enable", "")
#define Duration ReadIni(SourcePath + "\Settings.ini", "Background", "InstallBGDuration", "")
#define Animation ReadIni(SourcePath + "\Settings.ini", "Background", "InstallBGAnimation", "")
#define BGAfterInstall ReadIni(SourcePath + "\Settings.ini", "Background", "BGAfterInstall", "")

// SystemRequirement
#define UseSystemReq ReadIni(SourcePath + "\Settings.ini", "SystemRequirement", "Enable", "")
#define Processor ReadIni(SourcePath + "\Settings.ini", "SystemRequirement", "Processor", "")
#define VideoRAM ReadIni(SourcePath + "\Settings.ini", "SystemRequirement", "VideoRAM", "")
#define RAM ReadIni(SourcePath + "\Settings.ini", "SystemRequirement", "RAM", "")
#define OS ReadIni(SourcePath + "\Settings.ini", "SystemRequirement", "OS", "")
#define DX ReadIni(SourcePath + "\Settings.ini", "SystemRequirement", "DirectX", "")
#define HWSectionLabelColor ReadIni(SourcePath + "\Settings.ini", "SystemRequirement", "HWSectionLabelColor", "")
#define HWOkLabelColor ReadIni(SourcePath + "\Settings.ini", "SystemRequirement", "HWOkLabelColor", "")
#define HWNotOkLabelColor ReadIni(SourcePath + "\Settings.ini", "SystemRequirement", "HWNotOkLabelColor", "")
#define HWGoodLabelColor ReadIni(SourcePath + "\Settings.ini", "SystemRequirement", "HWGoodLabelColor", "")
#define HWPartiallyGoodLabelColor ReadIni(SourcePath + "\Settings.ini", "SystemRequirement", "HWPartiallyGoodLabelColor", "")
#define HWNotGoodLabelColor ReadIni(SourcePath + "\Settings.ini", "SystemRequirement", "HWNotGoodLabelColor", "")

// Text
#define WelcomeLabel1Top ReadIni(SourcePath + "\Settings.ini", "Text", "WelcomeLabel1Top", "")
#define WelcomeLabel2Top ReadIni(SourcePath + "\Settings.ini", "Text", "WelcomeLabel2Top", "")
#define FinishLabel1Top ReadIni(SourcePath + "\Settings.ini", "Text", "FinishLabel1Top", "")
#define FinishLabel2Top ReadIni(SourcePath + "\Settings.ini", "Text", "FinishLabel2Top", "")
#define WelcomeLabel1FontSize ReadIni(SourcePath + "\Settings.ini", "Text", "WelcomeLabel1FontSize", "")
#define WelcomeLabel2FontSize ReadIni(SourcePath + "\Settings.ini", "Text", "WelcomeLabel2FontSize", "")
#define FinishLabel1FontSize ReadIni(SourcePath + "\Settings.ini", "Text", "FinishLabel1FontSize", "")
#define FinishLabel2FontSize ReadIni(SourcePath + "\Settings.ini", "Text", "FinishLabel2FontSize", "")
#define Font ReadIni(SourcePath + "\Settings.ini", "Text", "Font", "")
#define FontColor ReadIni(SourcePath + "\Settings.ini", "Text", "FontColor", "")

// CRCCheck
#define CheckCRC ReadIni(SourcePath + "\Settings.ini", "CRCCheck", "Enable", "")
#define CRCFileName ReadIni(SourcePath + "\Settings.ini", "CRCCheck", "CRCFileName", "")

// Website
#define WebsiteButton ReadIni(SourcePath + "\Settings.ini", "Website", "Enable", "")
#define WebBtnName ReadIni(SourcePath + "\Settings.ini", "Website", "WebsiteButtonText", "")
#define URL ReadIni(SourcePath + "\Settings.ini", "Website", "URL", "")

// Splash
#define Splash ReadIni(SourcePath + "\Settings.ini", "Splash", "Enable", "")
#define SplashFile ReadIni(SourcePath + "\Settings.ini", "Splash", "SplashFile", "")
#define SplashFadeIn ReadIni(SourcePath + "\Settings.ini", "Splash", "SplashFadeIn", "")
#define SplashShow ReadIni(SourcePath + "\Settings.ini", "Splash", "SplashShow", "")
#define SplashFadeOut ReadIni(SourcePath + "\Settings.ini", "Splash", "SplashFadeOut", "")

// Music
#define Music ReadIni(SourcePath + "\Settings.ini", "Music", "Enable", "")
#define MusicFile ReadIni(SourcePath + "\Settings.ini", "Music", "MusicFile", "")
#define MusicVolume ReadIni(SourcePath + "\Settings.ini", "Music", "MusicVolume", "")

// License
#define UseLicense ReadIni(SourcePath + "\Settings.ini", "License", "Enable", "")

// Info Before
#define UseInfo ReadIni(SourcePath + "\Settings.ini", "InfoBefore", "Enable", "")

// Skin
#define Cjstyles ReadIni(SourcePath + "\Settings.ini", "Skin", "EnableCjstyles", "")
#define CjstylesName ReadIni(SourcePath + "\Settings.ini", "Skin", "CjstylesFile", "")
#define CjstylesParam ReadIni(SourcePath + "\Settings.ini", "Skin", "CjstylesParam", "")
#define CjstylesParam StringChange(CjstylesParam, "_INI", ".INI")
#define VCL ReadIni(SourcePath + "\Settings.ini", "Skin", "EnableVCL", "")
#define VCLName ReadIni(SourcePath + "\Settings.ini", "Skin", "VCLFile", "")

// Redists
#define UseRedists ReadIni(SourcePath + "\Settings.ini", "Redists", "Enable", "")

#define Redist1 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist1", "")
#define Redist1Name ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist1Name", "")
#define Redist1Exe32 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist1Exe32", "")
#define Redist1Exe64 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist1Exe64", "")
#define Redist1Param ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist1Param", "")

#define Redist2 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist2", "")
#define Redist2Name ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist2Name", "")
#define Redist2Exe32 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist2Exe32", "")
#define Redist2Exe64 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist2Exe64", "")
#define Redist2Param ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist2Param", "")

#define Redist3 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist3", "")
#define Redist3Name ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist3Name", "")
#define Redist3Exe32 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist3Exe32", "")
#define Redist3Exe64 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist3Exe64", "")
#define Redist3Param ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist3Param", "")

#define Redist4 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist4", "")
#define Redist4Name ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist4Name", "")
#define Redist4Exe32 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist4Exe32", "")
#define Redist4Exe64 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist4Exe64", "")
#define Redist4Param ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist4Param", "")

#define Redist5 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist5", "")
#define Redist5Name ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist5Name", "")
#define Redist5Exe32 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist5Exe32", "")
#define Redist5Exe64 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist5Exe64", "")
#define Redist5Param ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist5Param", "")

#define Redist6 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist6", "")
#define Redist6Name ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist6Name", "")
#define Redist6Exe32 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist6Exe32", "")
#define Redist6Exe64 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist6Exe64", "")
#define Redist6Param ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist6Param", "")

#define Redist7 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist7", "")
#define Redist7Name ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist7Name", "")
#define Redist7Exe32 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist7Exe32", "")
#define Redist7Exe64 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist7Exe64", "")
#define Redist7Param ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist7Param", "")

#define Redist8 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist8", "")
#define Redist8Name ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist8Name", "")
#define Redist8Exe32 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist8Exe32", "")
#define Redist8Exe64 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist8Exe64", "")
#define Redist8Param ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist8Param", "")

#define Redist9 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist9", "")
#define Redist9Name ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist9Name", "")
#define Redist9Exe32 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist9Exe32", "")
#define Redist9Exe64 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist9Exe64", "")
#define Redist9Param ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist9Param", "")

#define Redist10 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist10", "")
#define Redist10Name ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist10Name", "")
#define Redist10Exe32 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist10Exe32", "")
#define Redist10Exe64 ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist10Exe64", "")
#define Redist10Param ReadIni(SourcePath + "\Settings.ini", "Redists", "Redist10Param", "")
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

[Code]
const
  CP_ACP = 0;
  CP_UTF8 = 65001;

function MultiByteToWideChar(CodePage: UINT; dwFlags: DWORD; lpMultiByteStr: PAnsiChar; cbMultiByte: Integer; lpWideCharStr: PAnsiChar; cchWideChar: Integer): Longint;
  external 'MultiByteToWideChar@kernel32.dll stdcall delayload';
function WideCharToMultiByte(CodePage: UINT; dwFlags: DWORD; lpWideCharStr: PAnsiChar; cchWideChar: Integer; lpMultiByteStr: PAnsiChar; cbMultiByte: Integer; lpDefaultChar: Integer; lpUsedDefaultChar: Integer): Longint;
  external 'WideCharToMultiByte@kernel32.dll stdcall delayload';

function Utf8ToAnsi(strSource: String): AnsiString;
var
  nRet2, Len: Integer;
  WideCharBuf, MultiByteBuf: AnsiString;
begin
  Len := Length(strSource);
  SetLength(WideCharBuf, Len * 2);
  SetLength(MultiByteBuf, Len * 2);
  MultiByteToWideChar(CP_UTF8, 0, PAnsiChar(strSource), (-1), WideCharBuf, Length(WideCharBuf));
  nRet2 := WideCharToMultiByte(CP_ACP, 0, PAnsiChar(WideCharBuf), (-1), MultiByteBuf, Length(MultiByteBuf), 0, 0);
  Result := Trim(Copy(MultiByteBuf, 1, nRet2));
end;

function AppName(Default:String): String;
begin
  Result := Utf8ToAnsi(GetIniString('Settings', 'Name', '', ExpandConstant('{tmp}\Settings.ini')));
end;

function AppNameOverride(MsgID: TSetupMessageID): String;
begin
  Result := SetupMessage(MsgID);
  StringChangeEx(Result, '[name]', AppName(''), True);
  StringChangeEx(Result, '[name/ver]', AppName(''), True);
  Result := Result;
end;

function CreateUninstallerMessage(Default:String): String;
begin
  Result := ExpandConstant('{cm:CreateUninstall}');
end;

function IniKeyNotEmpty(Section, Key: String): Boolean;
begin
  Result := GetIniString(Section, Key, '', ExpandConstant('{tmp}\Settings.ini')) <> '';
end;














