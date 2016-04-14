$time_format    = "yy-MM-dd HH\:mm"
$collection_uri = "{0}/{1}" -f $global:tfs.root_url, $global:tfs.collection
$proj_uri       = "{0}/{1}" -f $collection_uri, $global:tfs.project

function check_credential() {
    [CmdletBinding()]
    param()

    if ($global:tfs.Credential) {
        Write-Verbose "TFS Credential: $($global:tfs.Credential.UserName)"
        return
    }

    Write-Verbose 'No credentials specified, trying Windows Credential Manager'
    $global:tfs.Credential = Get-TFSSToredCredential
}
