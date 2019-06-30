
$scriptsConfig = @{
    StartExecutePSFirst = 'true'
    EndExecutePSFirst =   'true'
}
$startup = @{
    '0CmdLine' =    'C:\Windows\Temp\Startup.ps1'
    '0Parameters' = ''
}
$shutdown = @{
    '0CmdLine' =    'C:\Windows\Temp\Shutdown.ps1'
    '0Parameters' = ''
}
$newIniContent = [ordered] @{ 
    ScriptsConfig = $scriptsConfig
    Startup =       $startup 
    Shutdown =      $shutdown
}
$newIniContent | Out-IniFile -filePath C:\Windows\System32\GroupPolicy\Machine\Scripts\psScripts.ini -encoding Unicode -force