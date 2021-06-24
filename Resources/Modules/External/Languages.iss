[Languages]
#if (UseLicense == "1") && (CompactMode == "0")
  Name: "English"; MessagesFile: "Resources\Languages\English.isl"; LicenseFile: "Setup\EULA\English.rtf";
  #ifexist "Setup\EULA\French.rtf"
    Name: "French"; MessagesFile: "Resources\Languages\French.isl"; LicenseFile: "Setup\EULA\French.rtf";
  #else
    Name: "French"; MessagesFile: "Resources\Languages\French.isl"; LicenseFile: "Setup\EULA\English.rtf";
  #endif
  #ifexist "Setup\EULA\German.rtf"
    Name: "German"; MessagesFile: "Resources\Languages\German.isl"; LicenseFile: "Setup\EULA\German.rtf";
  #else
    Name: "German"; MessagesFile: "Resources\Languages\German.isl"; LicenseFile: "Setup\EULA\English.rtf";
  #endif
  #ifexist "Setup\EULA\Italian.rtf"
    Name: "Italian"; MessagesFile: "Resources\Languages\Italian.isl"; LicenseFile: "Setup\EULA\Italian.rtf";
  #else
    Name: "Italian"; MessagesFile: "Resources\Languages\Italian.isl"; LicenseFile: "Setup\EULA\English.rtf";
  #endif
  #ifexist "Setup\EULA\Spanish.rtf"
    Name: "Spanish"; MessagesFile: "Resources\Languages\Spanish.isl"; LicenseFile: "Setup\EULA\Spanish.rtf";
  #else
    Name: "Spanish"; MessagesFile: "Resources\Languages\Spanish.isl"; LicenseFile: "Setup\EULA\English.rtf";
  #endif
  #ifexist "Setup\EULA\Polish.rtf"
    Name: "Polish"; MessagesFile: "Resources\Languages\Polish.isl"; LicenseFile: "Setup\EULA\Polish.rtf";
  #else
    Name: "Polish"; MessagesFile: "Resources\Languages\Polish.isl"; LicenseFile: "Setup\EULA\English.rtf";
  #endif
  #ifexist "Setup\EULA\Russian.rtf"
    Name: "Russian"; MessagesFile: "Resources\Languages\Russian.isl"; LicenseFile: "Setup\EULA\Russian.rtf";
  #else
    Name: "Russian"; MessagesFile: "Resources\Languages\Russian.isl"; LicenseFile: "Setup\EULA\English.rtf";
  #endif
  #ifexist "Setup\EULA\PortugueseBrazil.rtf"
    Name: "PortugueseBrazil"; MessagesFile: "Resources\Languages\BrazilianPortuguese.isl"; LicenseFile: "Setup\EULA\PortugueseBrazil.rtf";
  #else
    Name: "PortugueseBrazil"; MessagesFile: "Resources\Languages\BrazilianPortuguese.isl"; LicenseFile: "Setup\EULA\English.rtf";
  #endif
  #ifexist "Setup\EULA\Czech.rtf"
    Name: "Czech"; MessagesFile: "Resources\Languages\Czech.isl"; LicenseFile: "Setup\EULA\Czech.rtf";
  #else
    Name: "Czech"; MessagesFile: "Resources\Languages\Czech.isl"; LicenseFile: "Setup\EULA\English.rtf";
  #endif
#else
  Name: "English"; MessagesFile: "Resources\Languages\English.isl"; 
  Name: "French"; MessagesFile: "Resources\Languages\French.isl";
  Name: "German"; MessagesFile: "Resources\Languages\German.isl"; 
  Name: "Italian"; MessagesFile: "Resources\Languages\Italian.isl"; 
  Name: "Spanish"; MessagesFile: "Resources\Languages\Spanish.isl";
  Name: "Polish"; MessagesFile: "Resources\Languages\Polish.isl";
  Name: "Russian"; MessagesFile: "Resources\Languages\Russian.isl";
  Name: "PortugueseBrazil"; MessagesFile: "Resources\Languages\BrazilianPortuguese.isl";
  Name: "Czech"; MessagesFile: "Resources\Languages\Czech.isl";
#endif

#if UseLicense == "0"
  Name: "English"; MessagesFile: "Resources\Languages\English.isl"
  Name: "French"; MessagesFile: "Resources\Languages\French.isl"
  Name: "German"; MessagesFile: "Resources\Languages\German.isl"
  Name: "Italian"; MessagesFile: "Resources\Languages\Italian.isl"
  Name: "Spanish"; MessagesFile: "Resources\Languages\Spanish.isl"
  Name: "Polish"; MessagesFile: "Resources\Languages\Polish.isl"
  Name: "Russian"; MessagesFile: "Resources\Languages\Russian.isl"
  Name: "PortugueseBrazil"; MessagesFile: "Resources\Languages\BrazilianPortuguese.isl"
  Name: "Czech"; MessagesFile: "Resources\Languages\Czech.isl"
#endif