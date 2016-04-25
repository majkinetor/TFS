# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 25-Apr-2016.

<#
.SYNOPSIS
    Get the TFS build definitions
#>
function Get-BuildDefinitions {
    [CmdletBinding()]
    param (
        #Return raw data instead of the table
        [switch]$Raw,
        #Filters to definitions whose names start with this value. Globs supported
        [string]$Name
    )
    check_credential

    if ($Name) { $q_name = 'name=' + $Name + '&' }
    $uri = "$proj_uri/_apis/build/definitions?$($q_name)api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Get'}
    $r = invoke_rest $params
    if ($Raw) { return $r.value }

    $props = 'name', 'id', 'revision',
             @{ N='author' ; E={ $_.authoredBy.displayname } },
             @{ N='edit url'    ; E={ "$proj_uri/_build#definitionId=" + $_.id + "&_a=simple-process" }}
    $r.value | select -Property $props
}

sal defs Get-BuildDefinitions
