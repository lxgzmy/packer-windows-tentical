Write-Host "Install Nuget Package manager"
Install-PackageProvider -Name NuGet -Force -Confirm:$false

Write-Host "Install PsIni Module"
Install-Module -Name PsIni -Force -Confirm:$false

Write-Host "Register Scripts"
$scriptsConfig = @{
    StartExecutePSFirst = 'true'
    EndExecutePSFirst =   'true'
}
$startup = @{
    '0CmdLine' =    'C:\Windows\Temp\tests\startup.ps1'
    '0Parameters' = ''
}
$shutdown = @{
    '0CmdLine' =    'C:\Windows\Temp\tests\shutdown.ps1'
    '0Parameters' = ''
}
$newIniContent = [ordered] @{ 
    ScriptsConfig = $scriptsConfig
    Startup =       $startup 
    Shutdown =      $shutdown
}
$newIniContent | Out-IniFile -filePath C:\Windows\System32\GroupPolicy\Machine\Scripts\psScripts.ini -encoding Unicode -force