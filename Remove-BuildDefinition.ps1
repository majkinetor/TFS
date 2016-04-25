# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 25-Apr-2016.

<#
.SYNOPSIS
    Remove the TFS build definition
#>
function Remove-BuildDefinition {
    [CmdletBinding()]
    param(
        #Build defintion id [int] or name [string]
        $Id
    )
    check_credential

    if ( ![String]::IsNullOrEmpty($Id) -and ($Id.GetType() -eq [string]) ) { $Id = Get-BuildDefinitions -Name -$Id | % id }
    if ( [String]::IsNullOrEmpty($Id) ) { throw "Resource with that name doesn't exist" }
    Write-Verbose "Build definition id: $Id"

    $uri = "$proj_uri/_apis/build/definitions/$($Id)?api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Delete'}
    invoke_rest $params
}

sal rmdef Remove-BuildDefinition
