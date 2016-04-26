# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 26-Apr-2016.

<#
.SYNOPSIS
    Get the build definition

.EXAMPLE
    PS> Get-TFSBuildDefinition Build1

    Get the build definition by name.

.EXAMPLE
    PS> Get-TFSBuildDefinition Build1 -OutFile build1.json

    Exports the build definition named Build1 to JSON file 'build1.json' in the current directory.

.EXAMPLE
    PS> Get-TFSBuildDefinition 5 -OutFile .

    Exports the build definition to json file in the current directory. '.' is a special value for the file
    to be automatically named as <Project>-<BuildName>.json in the current directory.
#>
function Get-TFSBuildDefinition{
    [CmdletBinding()]
    param(
        #Build defintion id [int] or name [string]
        $Id=0,      #without 0 API by default returns item with id=1...
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
    if (!$OutFile)  { return $r }

    if ($OutFile -eq '.') { $OutFile = "{0}-{1}.json" -f $global:tfs.project, $r.Name }
    $r | ConvertTo-Json -Depth 100 | Out-File $OutFile -Encoding UTF8
}

sal def Get-TFSBuildDefinition
