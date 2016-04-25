# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 14-Apr-2016.

<#
.SYNOPSIS
    Get the TFS Git repositories
#>
function Get-GitRepositories {
    [CmdletBinding()]
    param (
        #Return raw data insted of the table
        [switch] $Raw
    )
    check_credential

    $uri = "$proj_uri/_apis/git/repositories?api-version=" + $tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Get'}
    $r = invoke_rest $params
    if ($Raw) { return $r.value }

    $props = 'name', 'id', @{ N='project'; E={ $_.project.name }}
    $r.value | select -Property $props | ft -au
}
