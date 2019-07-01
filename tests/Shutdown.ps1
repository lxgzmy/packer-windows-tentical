 
$OctopusURL ='{{user `OctopusURL`}}'
$OctopusAPIKey ='{{user `OctopusAPIKey`}}'

cd "${env:ProgramFiles}\Octopus Deploy\Tentacle"

 & .\tentacle.exe deregister-from --instance "Tentacle" --server $OctopusURL --apiKey $OctopusAPIKey --console | Write-Host
 & .\tentacle.exe service --instance "Tentacle" --install --stop --console | Write-Host