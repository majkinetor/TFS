# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 26-Apr-2016.

<#
.SYNOPSIS
    Get the TFS project details
.EXAMPLE
    Get-TFSProject ProjectXYZ

    Get the project 'ProjectXYZ' by its name
.EXAMPLE
    Get-TFSProject 1

    Get the project by its TFS numeric id
#>
function Get-TFSProject {
    [CmdletBinding()]
    param(
        #Id or name of the project
        [ValidateNotNullOrEmpty()]
        [string]$Id
    )
    check_credential

    $uri = "$collection_uri/_apis/projects/$($Id)?includeCapabilities=true&api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Get'}
    invoke_rest $params
}
