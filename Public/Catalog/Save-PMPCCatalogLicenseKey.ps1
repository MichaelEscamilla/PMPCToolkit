<#
    .SYNOPSIS
    Prompts for and stores the Patch My PC catalog license key.

    .DESCRIPTION
    Prompts the current user for a Patch My PC catalog license key as a SecureString,
    serializes it by using ConvertFrom-SecureString, and stores the encrypted value
    in the PMPCCatalogLicenseKey user environment variable.

    .EXAMPLE
    Save-PMPCCatalogLicenseKey

    Prompts for the license key and saves it for the current user.

    .NOTES
    The stored value can only be decrypted by the same user account on the same machine.
#>
function Save-PMPCCatalogLicenseKey {
    [CmdletBinding()]
    param (
    )

    # Prompt the user to enter their license key
    $LicenseKey = Read-Host -Prompt "Please enter your Patch My PC Catalog License Key" -AsSecureString
    if (-not $LicenseKey) {
        Write-Host -ForegroundColor Red "No license key entered. Please try again."
        return
    }

    # Convert the license key to a secure string
    $LicenseKey = ConvertFrom-SecureString -SecureString $LicenseKey

    # Save the license key file as an Envionment Variable for the current user
    [System.Environment]::SetEnvironmentVariable("PMPCCatalogLicenseKey", $LicenseKey, [System.EnvironmentVariableTarget]::User)
    Write-Host -ForegroundColor Green "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] License key saved successfully for the current user."
}