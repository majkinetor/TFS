# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 26-Apr-2016.

<#
.SYNOPSIS
    Create new TFS project
.EXAMPLE
    New-TFSProject -Name Test -Description 'Test project' -ProcessTemplate Scrum

    Create a new TFS team project with given name and description and use Scrum process template.
#>
function New-TFSProject {
    [CmdletBinding()]
    param(
        #Name for the project
        [string] $Name,
        #Description for the project
        [string] $Description,
        #Version control type for the project
        [ValidateSet( 'Git', 'Tfvc')]
        [string] $SourceControlType='Git',
        #Software development schema for the project
        [string] $ProcessTemplate = 'Agile'
    )
    check_credential

    $uri = "$collection_uri/_apis/projects/?api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $templateId = Get-TFSProcesses | ? name -eq $ProcessTemplate | % id
    if (!$templateId) { throw "No template exists with name: '$ProcessTemplate'" }
    Write-Verbose "Template id for '$ProcessTemplate': $templateId"

    $body = @{
        name = $Name
        description = $Description
        capabilities = @{
            processTemplate = @{ templateTypeId    = $templateId }
            versioncontrol  = @{ sourceControlType = $SourceControlType }
        }
    }

    $body = $body | ConvertTo-Json
    $params = @{ Uri = $uri; Method = 'Post'; Body = $body; ContentType = 'application/json' }
    invoke_rest $params
}
