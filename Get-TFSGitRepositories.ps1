# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 26-Apr-2016.

<#
.SYNOPSIS
    Get the TFS Git repositories
#>
function Get-TFSGitRepositories {
    [CmdletBinding()]
    param ()
    check_credential

    $uri = "$proj_uri/_apis/git/repositories?api-version=" + $tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Get'}
    $r = invoke_rest $params

    $list = @()
    foreach ($r in $r.value) {
        $b = [pscustomobject]@{
            Raw      = $r
            Id       = $r.id
            Name     = $r.name
            Project  = $r.project.name
        }
        $b.PSObject.TypeNames.Insert(0,'TFS.GitRepository')
        $list += $b
    }

    $list
}
