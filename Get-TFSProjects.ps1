# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 14-Apr-2016.

<#
.SYNOPSIS
    Get the list of projects from the TFS server
#>
function Get-TFSProjects{
    [CmdletBinding()]
    param(
        # Return raw data instead of the table
        [switch]$Raw
    )
    check_credential

    $uri = "$collection_uri/_apis/projects?api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Get'}
    $r = invoke_rest $params
    if ($Raw) { return $r.value }

    $res = $r.value | select name, description, revision, id
    $res | ft -auto
}
