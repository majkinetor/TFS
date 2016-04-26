# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 26-Apr-2016.

<#
.SYNOPSIS
    Add tag to TFS build
#>
function Add-TFSBuildTag{
    [CmdletBinding()]
    param(
        #Build ID
        [int]$Id,

        #Tag to add to the build
        [string]$Tag
    )
    check_credential

    $uri = "$proj_uri/_apis/build/builds/$Id/tags/$($Tag)?api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Put'}
    $r = invoke_rest $params
    $r.Value
}

sal btag Add-TFSBuildTag
