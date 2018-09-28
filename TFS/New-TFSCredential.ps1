# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 18-May-2016.

<#
.SYNOPSIS
    Create and optionaly store the TFS credentials
#>
function New-TFSCredential {
    [CmdletBinding()]
    param(
        # TFS credential
        [PSCredential] $Credential
    )

    Write-Verbose "New TFS credentials for '$($global:tfs.root_url)'"
    if ($Credential -eq $null) { $Credential = Get-Credential }
    if ($Credential -eq $null) { Write-Warning 'Aborted'; return }

    if (!(gmo -ListAvailable CredentialManager -ea 0)) { Write-Warning 'CredentialManager module is not available'; return $Credential }

    if (($global:tfs.root_url -eq '') -or ($global:tfs.root_url -eq $null)) { throw 'You must set $global:tfs.root_url in order to store credentials' }

    Write-Verbose "Storing credential for target '$($global:tfs.root_url)'"
    New-StoredCredential -Target $global:tfs.root_url -UserName $Credential.UserName -Password $Credential.GetNetworkCredential().Password -Persist LocalMachine | Out-Null

    return $Credential
}
