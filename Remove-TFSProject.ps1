# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 25-Apr-2016.

<#
.SYNOPSIS
    Get the TFS project
#>
function Remove-TFSProject {
    [CmdletBinding()]
    param (
        #Id or name of the project
        [string]$Id
    )
    check_credential

    if ($Id.Length -ne 36) { $Id = Get-TFSProject $Id | % id }
    if ($Id -eq $null) { throw "Can't find project with that name or id: '$Id'" }
    Write-Verbose "Project id: $Id"

    $uri = "$collection_uri/_apis/projects/$($Id)?api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Delete' }
    invoke_rest $params
}
