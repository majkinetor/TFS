# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 25-Apr-2016.

<#
.SYNOPSIS
    Get the TFS build list
.EXAMPLE
    Get-TFSBuilds

    Return last 10 builds
.EXAMPLE
    builds -BuildNumber 80[0-4]

    Return builds 800 - 804

.EXAMPLE
    builds -Definitions Def1, Def2 -MaxBuildsPerDefinition 2

    Return only 2 last builds for definition Def1 & Def 2

.EXAMPLE
    Get-TFSBuilds -Tag production,v1

    Get only builds that are tagged with 'production' and 'v1' keyword
#>
function Get-TFSBuilds {
    [CmdletBinding()]
    param (
        #Return raw data insted of the table
        [switch] $Raw,
        #Maxium number of latest builds to return, by default 10
        [int] $Top=10,
        #Return only builds with the given tags
        [string[]]$Tags,
        #Status filter
        [ValidateSet('inProgress', 'completed', 'cancelling', 'postponed', 'notStarted', 'all')]
        [string]$Status = 'all',
        #Results filter
        [ValidateSet('succeeded', 'partiallySucceeded', 'failed', 'canceled', 'all')]
        [string]$Result = 'all',
        #Definitions filter
        [string[]]$Definitions,
        #The maximum number of builds to retrieve for each definition (default 5). This is only valid when definitions is also specified.
        [int]$MaxBuildsPerDefinition = 5,
        #Builds requested by this user, SAM account name
        [string]$RequestedFor,
        #Filters to builds with build numbers that start with this value. Globs supported
        [string]$BuildNumber,
        #Builds that finished after this time
        [datetime]$MinFinishTime,
        #Builds that finished before this time
        [datetime]$MaxFinishTime,
        #A comma-delimited list of extended properties to retrieve
        [string]$Properties

    )
    check_credential

    $q_top = '$top=' + $Top + '&'
    if ($Result -ne 'all') { $q_result = 'resultFilter=' + $Result + '&' }
    if ($Status -ne 'all') { $q_status = 'statusFilter=' + $Status + '&' }
    if ($Tags)             { $q_tag    = 'tagFilters='   + ($Tags -join ',') + '&' }
    if ($Definitions)      {
        $Definitions | % { $q_definitions += ',' + (Get-TFSBuildDefinition $_).id }
        $q_definitions = 'definitions=' + $q_definitions.Substring(1) + '&'
        $q_definitions += 'maxBuildsPerDefinition=' + $MaxBuildsPerDefinition + '&'
    }
    if ($RequestedFor)  { $q_requestedFor  = 'requestedFor='  + $RequestedFor  + '&' }
    if ($BuildNumber)   { $q_buildNumber   = 'buildNumber='   + $BuildNumber   + '&' }
    if ($MinFinishTime) { $q_minFinishTime = 'minFinishTime=' + (Get-Date $MinFinishTime).ToUniversalTime().ToString('s') + '&' }
    if ($MaxFinishTime) { $q_maxFinishTime = 'maxFinishTime=' + (Get-Date $MaxFinishTime).ToUniversalTime().ToString('s') + '&' }
    if ($Properties)    { $q_properties    = 'properties='    + ($Propeties -join ',') + '&' }

    $query_args = $q_top + $q_tag + $q_status + $q_result + $q_definitions +
                  $q_requestedFor + $q_buildNumber + $q_minFinishTime + $q_maxFinishTime + $q_properties
    $uri = "$proj_uri/_apis/build/builds?$($query_args)api-version=" + $global:tfs.api_version
    Write-Verbose "URI: $uri"

    $params = @{ Uri = $uri; Method = 'Get'}
    $r = invoke_rest $params
    if ($Raw) { return $r.value }

    $props = 'buildNumber', 'result',
             @{ N='Definition'   ; E={ $_.definition.name }},
             @{ N='Start time'   ; E={ (get-date $_.startTime).ToString($time_format) }},
             @{ N='End time'     ; E={ (get-date $_.finishTime).ToString($time_format) }},
             @{ N='Duration (m)' ; E={ [math]::round( ((get-date $_.finishTime) - (get-date $_.startTime)).TotalMinutes, 1)}},
             'tags'


    $r.value | select -Property $props | ft -au
}

sal builds Get-TFSBuilds
