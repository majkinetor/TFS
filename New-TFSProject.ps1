# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 25-Apr-2016.

<#
.SYNOPSIS
    Create new TFS project
#>
function New-TFSProject {
    [CmdletBinding()]
    param(
     [string] $Name,
     [string] $Description
    )
    check_credential

    $uri = "$collection_uri/_apis/projects/?api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $body = @{
        name = $Name
        description = $Description
        capabilities = @{
            processTemplate = @{ templateTypeId = 'adcc42ab-9882-485e-a3ed-7678f01f66bc' }
            versioncontrol  = @{ sourceControlType = 'Git' }
        }
    }

    $body = $body | ConvertTo-Json
    $body
    $params = @{ Uri = $uri; Method = 'Post'; Body = $body; ContentType = 'application/json' }
    invoke_rest $params
}
