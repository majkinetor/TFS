# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 26-Apr-2016.

<#
.SYNOPSIS
    Get the list of team projects from the TFS server
#>
function Get-TFSProjects{
    [CmdletBinding()]
    param(
        #Maxium number of team projects to return, by default 100
        [int] $Top=100,
        #Number of team projects to skip, by default 0
        [int] $Skip=0
    )
    check_credential

    $q_top  = '$top=' + $Top + '&'
    $q_skip = '$skip=' + $Skip + '&'
    $query_args = $q_top + $q_skip
    $uri = "$collection_uri/_apis/projects?$($query_args)api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Get'}
    $r = invoke_rest $params

    $list = @()
    foreach ($r in $r.value) {
        $b = [pscustomobject]@{
            Raw         = $r
            Name        = $r.name
            Description = $r.description
            Revision    = $r.revision
            Id          = $r.id
        }
        $b.PSObject.TypeNames.Insert(0,'TFS.Project')
        $list += $b
    }

    $list
}
