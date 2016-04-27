# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 26-Apr-2016.

<#
.SYNOPSIS
    Get the TFS build queues
#>
function Get-TFSQueues {
    [CmdletBinding()]
    param ()
    check_credential

    $uri = "$collection_uri/_apis/build/queues?api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Get'}
    $r = invoke_rest $params
    $r.value | select id, name
}
