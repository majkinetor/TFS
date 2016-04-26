# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 26-Apr-2016.

<#
.SYNOPSIS
    Remove tag from TFS build
.EXAMPLE
    Remove-TFSBuildTag 220 production

    Remove tag 'production' from the build with ID 220.
#>
function Remove-TFSBuildTag{
    [CmdletBinding()]
    param(
        #Build ID
        [int]$Id,

        #Tag to remove from the build
        [string]$Tag
    )
    check_credential

    $uri = "$proj_uri/_apis/build/builds/$Id/tags/$($Tag)?api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Delete'}
    $r = invoke_rest $params
    $r.Value
}
