function Search-BackupSettingsSMSProvider {
    param (
        [Parameter(Mandatory = $false)]
        [array]
        $SettingsFileObject
    )

    # Loop through the Object array
    foreach ($BackupFolder in $SettingsFileObject) {
        Write-Host "####### Processing #####" -ForegroundColor Yellow
        Write-Host -ForegroundColor DarkGray "Folder: $($BackupFolder.Name)"

        # Load the XML content from the file "Settings.xml"
        [xml]$xmlContent = Get-Content -Path "$($BackupFolder.FullName)\Settings.xml"

        $SMSProviderServer = $xmlContent.SelectSingleNode("//AllowPackageCreation").SccmServer;
        $SMSProviderCredentials = $xmlContent.SelectSingleNode("//SmsCredential");

        Write-Host "SMS Provider Server: [$($SMSProviderServer)]" -ForegroundColor Cyan
        Write-Host "Use Alt Credentials: " -NoNewline
        if (($SMSProviderCredentials.InnerText) -match "True") {
            Write-Host "$($SMSProviderCredentials.InnerText)" -ForegroundColor Green
        } else {
            Write-Host "$($SMSProviderCredentials.InnerText)" -ForegroundColor Red
        }
        Write-Host "`tUsername   : [$($SMSProviderCredentials.Login)]"
        Write-Host "`tPassword   : [$($SMSProviderCredentials.Password)]"
    }
}