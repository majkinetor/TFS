# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 25-Apr-2016.

<#
.SYNOPSIS
    Invoke the TFS build
#>
function Invoke-Build {
    [CmdletBinding()]
    param(
        #Build defintion id [int] or name [string]
        $Id
    )
    check_credential

    if ( ![String]::IsNullOrEmpty($Id) -and ($Id.GetType() -eq [string]) ) { $Id = Get-BuildDefinitions -Name $Id | % id }
    if ( [String]::IsNullOrEmpty($Id) ) { throw "Resource with that name doesn't exist" }
    Write-Verbose "Build definition id: '$Id'"

    $uri = "$proj_uri/_apis/build/builds?api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $body = @{ definition=@{ id = $Id } }
    $body = $body | ConvertTo-Json
    $params = @{ Uri = $uri; Method = 'Post'; Body = $body; ContentType = 'application/json' }
    $r = invoke_rest $params
}

sal build Invoke-Build
