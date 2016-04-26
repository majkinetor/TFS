# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 14-Apr-2016.

<#
.SYNOPSIS
    Get the TFS Git repositories
#>
function Remove-TFSGitRepository {
    [CmdletBinding()]
    param (
        #Name of the repository
        [string] $Name
    )
    check_credential

    $id = Get-TFSGitRepositories -Raw | ? name -eq $Name | % id
    Write-Verbose "Repository id: $id"

    $uri = "$proj_uri/_apis/git/repositories/$($id)?api-version=" + $tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Delete' }
    invoke_rest $params
}
