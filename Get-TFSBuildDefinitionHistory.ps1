# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 26-Apr-2016.

<#
.SYNOPSIS
    Get the build definition history
#>
function Get-TFSBuildDefinitionHistory{
    [CmdletBinding()]
    param(
        # Build definition history id [int] or name [string]
        $Id
    )
    check_credential


    if ( ![String]::IsNullOrEmpty($Id) -and ($Id.GetType() -eq [string]) ) { $Id = Get-TFSBuildDefinitions -Name $Id | % id }
    if ( [String]::IsNullOrEmpty($Id) ) { throw "Build definition with that name or id doesn't exist" }
    Write-Verbose "Build definition history id: $Id"

    $uri = "$proj_uri/_apis/build/definitions/$($Id)/revisions?api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Get' }
    $r = invoke_rest $params

    $list = @()
    foreach ($r in $r.value) {
        $b = [pscustomobject]@{
            Raw         = $r
            Revision    = $r.revision
            ChangeType  = $r.changeType
            ChangedDate = get-date $r.changedDate
            ChangedBy   = $r.changedBy.displayName
            Comment     = $r.comment
        }
        $b.PSObject.TypeNames.Insert(0,'TFS.Definition.History')
        $list += $b
    }
    $list | sort revision -desc
}
