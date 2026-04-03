<#
    .SYNOPSIS
    Removes the stored Patch My PC catalog license key.

    .DESCRIPTION
    Deletes the PMPCCatalogLicenseKey user environment variable for the current user,
    removing the previously stored Patch My PC catalog license key.

    .EXAMPLE
    Remove-PMPCCatalogLicenseKey

    Removes the saved license key for the current user.
#>
function Remove-PMPCCatalogLicenseKey {
    [CmdletBinding()]
    param (
    )
    # Delete the license key from the Environment Variable for the current user
    [System.Environment]::SetEnvironmentVariable("PMPCCatalogLicenseKey", $null, [System.EnvironmentVariableTarget]::User)
}