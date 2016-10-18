function test-var() {
     $input | % { if (!(Test-Path Env:$_)) {throw "Environment Variable $_ must be set"} }
}

function Publish-PSGallery() {
    Write-Host 'Publishing to Powershell Gallery'

    'NuGet_ApiKey' | test-var
    $params = @{
        Path        = "$PSScriptRoot\TFS"
        NuGetApiKey = $Env:NuGet_ApiKey
    }
    Publish-Module @params
}

if (Test-Path $PSScriptRoot/vars.ps1) { . $PSScriptRoot/vars.ps1 }
Publish-PSGallery
