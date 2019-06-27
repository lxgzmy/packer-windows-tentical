# Install Chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# Globally Auto confirm every action
choco feature enable -n allowGlobalConfirmation


Write-Host "Downloading tentacle"
choco install octopusdeploy.tentacle

# If for whatever reason this doesn't work, check this file:
Start-Transcript -path "C:\TentacleInstallLog.txt" -append

$yourApiKey = "API-LIAZSZAMDLWCQ0L1DBJ5L38TJWK"
$octopusServerUrl = "http://deploy.internal.zip/"
$registerInEnvironments = "cmd"
$registerInRoles = "api"
$octopusServerThumbprint = "E60C8E37DB3A42FBE3CA5C2F6C2076B92BA27E3C"
$tentacleListenPort = 10933
$tentacleHomeDirectory = "$env:SystemDrive:\Octopus"
$tentacleAppDirectory = "$env:SystemDrive:\Octopus\Applications"
$tentacleConfigFile = "$env:SystemDrive\Octopus\Tentacle\Tentacle.config"



# We're going to use Tentacle in Listening mode, so we need to tell Octopus what its IP address is. Since my Octopus server
# is hosted somewhere else, I need to know the public-facing IP address. 
function Get-MyPublicIPAddress
{
  Write-Host "Getting public IP address"
  $downloader = new-object System.Net.WebClient
  $ip = $downloader.DownloadString("http://ifconfig.me/ip")
  return $ip
}

function Install-Tentacle 
{
  param (
     [Parameter(Mandatory=$True)]
     [string]$apiKey,
     [Parameter(Mandatory=$True)]
     [System.Uri]$octopusServerUrl,
     [Parameter(Mandatory=$True)]
     [string]$environment,
     [Parameter(Mandatory=$True)]
     [string]$role
  )

  Write-Output "Beginning Tentacle installation"


  Write-Output "Open port $tentacleListenPort on Windows Firewall"
  & netsh.exe firewall add portopening TCP $tentacleListenPort "Octopus Tentacle"
  if ($lastExitCode -ne 0) {
    throw "Installation failed when modifying firewall rules"
  }
  
  $ipAddress = Get-MyPublicIPAddress
  $ipAddress = $ipAddress.Trim()

  Write-Output "Public IP address: " + $ipAddress
 
  Write-Output "Configuring and registering Tentacle"
  
  cd "${env:ProgramFiles}\Octopus Deploy\Tentacle"

  & .\tentacle.exe create-instance --instance "Tentacle" --config $tentacleConfigFile --console | Write-Host
  if ($lastExitCode -ne 0) {
    throw "Installation failed on create-instance"
  }
  & .\tentacle.exe configure --instance "Tentacle" --home $tentacleHomeDirectory --console | Write-Host
  if ($lastExitCode -ne 0) {
    throw "Installation failed on configure"
  }
  & .\tentacle.exe configure --instance "Tentacle" --app $tentacleAppDirectory --console | Write-Host
  if ($lastExitCode -ne 0) {
    throw "Installation failed on configure"
  }
  & .\tentacle.exe configure --instance "Tentacle" --port $tentacleListenPort --console | Write-Host
  if ($lastExitCode -ne 0) {
    throw "Installation failed on configure"
  }
  & .\tentacle.exe new-certificate --instance "Tentacle" --console | Write-Host
  if ($lastExitCode -ne 0) {
    throw "Installation failed on creating new certificate"
  }
  & .\tentacle.exe configure --instance "Tentacle" --trust $octopusServerThumbprint --console  | Write-Host
  if ($lastExitCode -ne 0) {
    throw "Installation failed on configure"
  }
  & .\tentacle.exe register-with --instance "Tentacle" --server $octopusServerUrl --environment $environment --role $role --name $env:COMPUTERNAME --publicHostName $ipAddress --apiKey $apiKey --comms-style TentaclePassive --force --console | Write-Host
  if ($lastExitCode -ne 0) {
    throw "Installation failed on register-with"
  }
 
  & .\tentacle.exe service --instance "Tentacle" --install --start --console | Write-Host
  if ($lastExitCode -ne 0) {
    throw "Installation failed on service install"
  }
 
  Write-Output "Tentacle commands complete"
}

Install-Tentacle -apikey $yourApiKey -octopusServerUrl $octopusServerUrl -environment $registerInEnvironments -role $registerInRoles