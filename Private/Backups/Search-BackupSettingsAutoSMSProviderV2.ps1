function Search-BackupSettingsSMSProviderV2 {
    param (
        [Parameter(Mandatory = $false)]
        [string]
        $SettingsFilePath
    )

    # Validate the provided file path exists
    if (-not (Test-Path -Path $SettingsFilePath)) {
        Write-Host "The specified file path does not exist: $SettingsFilePath" -ForegroundColor Red
        return
    }

    # Load the XML content from the file "Settings.xml"
    [xml]$xmlContent = Get-Content -Path $SettingsFilePath

    $SMSProviderServer      = $xmlContent.SelectSingleNode("//AllowPackageCreation").SccmServer
    $SMSProviderCredentials = $xmlContent.SelectSingleNode("//SmsCredential")

    $useAltCredentials = if ($SMSProviderCredentials.InnerText -match "True") {
        "True"
    }
    elseif ($SMSProviderCredentials.InnerText -match "False") {
        "False"
    }
    else {
        "N/A"
    }

    return @{
        SMSProviderServer  = $SMSProviderServer
        UseAltCredentials  = $useAltCredentials
        Username           = $SMSProviderCredentials.Login
        Password           = $SMSProviderCredentials.Password
    }
}
