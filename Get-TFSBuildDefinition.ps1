# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 25-Apr-2016.

<#
.SYNOPSIS
    Get the build definition

.EXAMPLE
    PS> Get-BuildDefinition Build1

    Get the build definition by name

.EXAMPLE
    PS> Get-BuildDefinition 5 -OutFile .

    Exports the build defintiion to json file in the current directory. '.' is a special value for the file
    to be automatically named as Project-Build_Name.json in the current directory
#>
function Get-TFSBuildDefinition{
    [CmdletBinding()]
    param(
        #Build defintion id [int] or name [string]
        $Id=0,      #without 0 API by default returns item with id=1...
        #Return raw data instead of table
        [switch]$Raw,
        #Export the build to the specified JSON file
        [string]$OutFile,
        #Revision of the build to get
        [int]$Revision=0
    )
    check_credential

    if ( ![String]::IsNullOrEmpty($Id) -and ($Id.GetType() -eq [string])) { $Id = Get-TFSBuildDefinitions -Name $Id | % id }
    if ( [String]::IsNullOrEmpty($Id) ) { throw "Resource with that name doesn't exist" }
    Write-Verbose "Build definition id: '$Id'"

    if ($Revision) { $rev = "revision=$Revision&" }
    $uri = "$proj_uri/_apis/build/definitions/$($Id)?$($rev)api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Get'}
    $r = invoke_rest $params
    if ($Raw) { return $r }

    $res = $r # | select name, type, quality, queue, Build, Triggers, Options, Variables, RetentionRules, Repository
    if ($OutFile) {
        if ($OutFile -eq '.') { $OutFile = "{0}-{1}.json" -f $global:tfs.project, $r.Name }
        $res | ConvertTo-Json -Depth 100 | Out-File $OutFile -Encoding UTF8
    } else { $res }
}

sal def Get-TFSBuildDefinition
