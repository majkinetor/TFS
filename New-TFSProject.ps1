# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 14-Apr-2016.

<#
.SYNOPSIS
    Create new TFS project
.NOTE
    Not supported on on-premise TFS
#>
function New-TFSProject($Name, $Description) {
    check_credential

    $uri = "$collection_uri/_apis/projects/?api-version=" + $global:tfs.api_version
    $uri
    $body = @{
        name = $Name
        description = $Description
        capabilities = @{
            processTemplate = @{ templateName      = 'Agile' }
            versionControl  = @{ sourceControlType = 'Git' }
        }
    }

    $body = $body | ConvertTo-Json
    $params = @{ Uri = $uri; Method = 'Post'; Body = $body; ContentType = 'application/json' }
    invoke_rest $params
}
