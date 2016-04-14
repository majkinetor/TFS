# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 14-Apr-2016.

<#
.SYNOPSIS
    Update/import build definition

.NOTES
    Build definition property "revision" must point to the latest one in order for import to succeed.
    For this reason revision is taken remotely and JSON revision is ignored.
#>
function Update-TFSBuildDefinition {
    [CmdletBinding()]
    param (
        [string] $JsonFile
    )
    check_credential

    if (!(Test-Path $JsonFile)) {throw "File doesn't exist: $JsonFile" }
    $json = gc $JsonFile -ea Stop | ConvertFrom-Json

    #Don't use id from the jsonfile, find by name on TFS
    $remote = Get-TfsBuildDefinition $json.name
    $json.id       = $remote.id
    $json.revision = $remote.revision
    Write-Verbose "Using remote build definition attributes: id $($json.id), revision $($json.revision)"

    $uri = "$proj_uri/_apis/build/definitions/$($json.id)?revision=$($remote.revision)&api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $body   = $json | ConvertTo-Json -Depth 100
    $params = @{ Uri = $uri; Method = 'Put'; Body = $body; ContentType = 'application/json'  }
    invoke_rest $params
}

sal udef Update-TFSBuildDefinition
