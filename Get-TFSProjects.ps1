# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 26-Apr-2016.

<#
.SYNOPSIS
    Get the list of projects from the TFS server
#>
function Get-TFSProjects{
    [CmdletBinding()]
    param()
    check_credential

    $uri = "$collection_uri/_apis/projects?api-version=" + $global:tfs.api_version
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
