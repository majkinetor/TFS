# Author: Miodrag Milic <miodrag.milic@gmail.com>
# Last Change: 26-Apr-2016.

<#
.SYNOPSIS
    Get saved TFS credential from the Windows Credential Manager. If none is available, create and store one.
#>
function Get-SavedCredential {
    [CmdletBinding()]
    param()

    if ($global:tfs.root_url -eq $null) { throw 'You must set $global:tfs.root_url in order to get stored credentials' }
    if (gmo -ListAvailable CredentialManager -ea 0)  {
        $cm = $true
        try {
            Write-Verbose "Trying to get storred credentials for '$($global:tfs.root_url)'"
            $cred = Get-StoredCredential -Target $global:tfs.root_url
        } catch { throw $_ }
    }

    if ($cred -eq $null) { $cred = New-Credential } else { Write-Verbose 'Stored credentials retrieved' }

    $cred
}
