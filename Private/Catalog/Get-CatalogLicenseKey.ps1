function Get-CatalogLicenseKey {
    [CmdletBinding()]
    param ()

    # Retrieve the license key from the Environment Variable for the current user
    $LicenseKey = [System.Environment]::GetEnvironmentVariable("PMPCCatalogLicenseKey", [System.EnvironmentVariableTarget]::User)

    if ($LicenseKey) {
        # Convert the secure string back to plain text
        $LicenseKey = ConvertTo-SecureString -String $LicenseKey
        $LicenseKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($LicenseKey))
        return $LicenseKey
    }
    else {
        return $null
    }
}