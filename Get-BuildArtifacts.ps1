# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 14-Apr-2016.

<#
.SYNOPSIS
    Get the build artifacts
#>
function Get-BuildArtifacts{
    [CmdletBinding()]
    param(
        #Build id
        [int]$Id
    )
    check_credential

    $uri = "$proj_uri/_apis/build/builds/$Id/artifacts?api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Get'}
    $r = invoke_rest $params
    $r.value
}
