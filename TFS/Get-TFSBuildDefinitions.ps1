# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 26-Apr-2016.

<#
.SYNOPSIS
    Get the TFS build definitions
#>
function Get-TFSBuildDefinitions {
    [CmdletBinding()]
    param (
        #Filters to definitions whose names start with this value. Globs supported.
        [string]$Name
    )
    check_credential

    if ($Name) { $q_name = 'name=' + $Name + '&' }
    $uri = "$proj_uri/_apis/build/definitions?$($q_name)api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Get'}
    $r = invoke_rest $params

    $list = @()
    foreach ($r in $r.value) {
        $b = [pscustomobject]@{
            Raw      = $r
            Id       = $r.id
            Name     = $r.name
            Revision = $r.revision
            Author   = $r.authoredBy.displayname
            EditUrl  = "$proj_uri/_build#definitionId=" + $r.id + "&_a=simple-process"
        }
        $b.PSObject.TypeNames.Insert(0,'TFS.Definition')
        $list += $b
    }

    $list
}

sal defs Get-TFSBuildDefinitions
