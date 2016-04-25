# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 25-Apr-2016.

<#
.SYNOPSIS
    Create new TFS project
#>
function New-Project {
    [CmdletBinding()]
    param(
     [string] $Name,
     [string] $Description,
     [ValidateSet( 'Git', 'Tfvc')]
     [string] $SourceControlType='Git',
     [string] $ProcessTemplate = 'Agile'
    )
    check_credential

    $uri = "$collection_uri/_apis/projects/?api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $body = @{
        name = $Name
        description = $Description
        capabilities = @{
            processTemplate = @{ templateTypeId = 'adcc42ab-9882-485e-a3ed-7678f01f66bc' }
            versioncontrol  = @{ sourceControlType = $SourceControlType }
        }
    }

    $body = $body | ConvertTo-Json
    $params = @{ Uri = $uri; Method = 'Post'; Body = $body; ContentType = 'application/json' }
    invoke_rest $params
}
