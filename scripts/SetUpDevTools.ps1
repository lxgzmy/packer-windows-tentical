# Install Chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# Globally Auto confirm every action
choco feature enable -n allowGlobalConfirmation

Write-Host "Downloading and install powershell 5"
#choco install powershell

Write-Host "Downloading and install dotnet 4.6.1"
choco install dotnet4.6.1

Write-Host "Downloading and install newrelic"
choco install newrelic-dotnet

# Write-Host "Downloading tentacle"
# choco choco install dotnetcore-sdk

Write-Host "Downloading tentacle"
choco install octopusdeploy.tentacle

Install-Module -Name PsIni -Force
