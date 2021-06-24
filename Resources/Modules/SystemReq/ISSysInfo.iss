[code]

const
  Dx_Gpu = 1; // DirectX supported by GPU
  Dx_Sys = 2; // DirectX installed on system
  TF_InBytes = 1;
  TF_InKiloBytes = 2;
  TF_InMegaBytes = 4;
  TF_InGigaBytes = 8;

function GetDiskVolumeName(const RootDir: PAnsichar):PAnsichar; external 'GetDiskVolumeName@files:ISSysInfo.dll stdcall delayload';
function GetFileSystemName(const RootDir: PAnsichar):PAnsichar; external 'GetFileSystemName@files:ISSysInfo.dll stdcall delayload';
function GetVolumeFreeSpace(const RootDir: PAnsichar; const OutSizeType: Byte): Extended; external 'GetVolumeFreeSpace@files:ISSysInfo.dll stdcall delayload';
function GetVolumeSize(const RootDir: PAnsichar; const OutSizeType: Byte): Extended; external 'GetVolumeSize@files:ISSysInfo.dll stdcall delayload';
function GetFixedDrives: PAnsichar; external 'GetFixedDrives@files:ISSysInfo.dll stdcall delayload';

function GetCpuName: PAnsichar; external 'GetCpuName@files:ISSysInfo.dll stdcall delayload';
function GetCpuMaxClockSpeed: integer; external 'GetCpuMaxClockSpeed@files:ISSysInfo.dll stdcall delayload';
function GetCpuCurrentClockSpeed: integer; external 'GetCpuCurrentClockSpeed@files:ISSysInfo.dll stdcall delayload';
function GetCpuRealClockSpeed: integer; external 'GetCpuRealClockSpeed@files:ISSysInfo.dll stdcall delayload';
function GetCpuManufacturer: PAnsichar; external 'GetCpuManufacturer@files:ISSysInfo.dll stdcall delayload';
function GetCpuPhysicalCores: integer; external 'GetCpuPhysicalCores@files:ISSysInfo.dll stdcall delayload';
function GetCpuLogicalCores: integer; external 'GetCpuLogicalCores@files:ISSysInfo.dll stdcall delayload';

function GetGpuName: PAnsichar; external 'GetGpuName@files:ISSysInfo.dll stdcall delayload';
function GetGpuVRam: integer; external 'GetGpuVRam@files:ISSysInfo.dll stdcall delayload';
function GetDirectXVersion(const F_Dx: integer): extended;  external 'GetDirectXVersion@files:ISSysInfo.dll stdcall delayload';
function GetVideoDescription: PAnsichar; external 'GetVideoDescription@files:ISSysInfo.dll stdcall delayload';

function GetHorizontalResolution: PAnsichar; external 'GetHorizontalResolution@files:ISSysInfo.dll stdcall delayload';
function GetVerticalResolution: PAnsichar; external 'GetVerticalResolution@files:ISSysInfo.dll stdcall delayload';
function GetRefreshRate: PAnsichar; external 'GetRefreshRate@files:ISSysInfo.dll stdcall delayload';

function GetAudioDeviceName: PAnsichar; external 'GetAudioDeviceName@files:ISSysInfo.dll stdcall delayload';

function GetTotalVisibleMemory: integer; external 'GetTotalVisibleMemory@files:ISSysInfo.dll stdcall delayload';
function GetFreePhysicalMemory: integer; external 'GetFreePhysicalMemory@files:ISSysInfo.dll stdcall delayload';

function GetOSName: PAnsichar; external 'GetOSName@files:ISSysInfo.dll stdcall delayload';
function GetOSVersionMajor: Cardinal; external 'GetOSVersionMajor@files:ISSysInfo.dll stdcall delayload';
function GetOSVersionMinor: Cardinal; external 'GetOSVersionMinor@files:ISSysInfo.dll stdcall delayload';
function GetOSBuildNumbers: Cardinal; external 'GetOSBuildNumbers@files:ISSysInfo.dll stdcall delayload';
function GetServicePackMajorVersion: Word; external 'GetServicePackMajorVersion@files:ISSysInfo.dll stdcall delayload';
function GetServicePackMinorVersion: Word; external 'GetServicePackMinorVersion@files:ISSysInfo.dll stdcall delayload';
function GetOSArchitecture: Byte; external 'GetOSArchitecture@files:ISSysInfo.dll stdcall delayload';
