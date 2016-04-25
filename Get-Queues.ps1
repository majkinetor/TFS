# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 19-Apr-2016.

<#
.SYNOPSIS
    Get the TFS build queues
#>
function Get-Queues {
    [CmdletBinding()]
    param (
        [switch] $Raw
    )
    check_credential

    $uri = "$collection_uri/_apis/build/queues?api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Get'}
    $r = invoke_rest $params
    if ($Raw) { return $r.value }

    $props = 'id', 'name', 'url'

    $r.value | select -Property $props | ft -au
}
