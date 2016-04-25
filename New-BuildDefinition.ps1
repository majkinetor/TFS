# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 25-Apr-2016.

<#
.SYNOPSIS
    Create/import build definition
.EXAMPLE
    New-BuildDefinition -JsonFile BuildXYZ.json

    Create a new build definition using the data in the JSON file 'BuildXYZ.json'
#>
function New-BuildDefinition {
    [CmdletBinding()]
    param (
        #File that contains json description of the build
        [string] $JsonFile
    )
    check_credential

    if (!(Test-Path $JsonFile)) {throw "File doesn't exist: $JsonFile" }

    $uri = "$proj_uri/_apis/build/definitions?api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $body = gc $JsonFile -Raw -ea Stop
    $params = @{ Uri = $uri; Method = 'Post'; Body = $body; ContentType = 'application/json' }
    invoke_rest $params
}
