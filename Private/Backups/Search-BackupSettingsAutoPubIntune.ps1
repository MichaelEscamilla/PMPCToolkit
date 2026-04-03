function Search-BackupSettingsAutoPubIntune {
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

        $Nodes = @(
            @{
                Name                = "AutoEnrollApplicationsBasedOnIntune";
                Alias               = "Auto-Publish Intune Apps";
                EnabledPath         = $xmlContent.SelectNodes("//IntuneTenants//Tenant").AutoEnrollApplicationsBasedOnIntune;
                ThresholdPath       = $xmlContent.SelectNodes("//IntuneTenants//Tenant").ApplicationThresholdBasedOnIntune;
            },  @{
                Name                = "AutoEnrollUpdatesBasedOnIntune";
                Alias               = "Auto-Publish Intune Updates";
                EnabledPath         = $xmlContent.SelectNodes("//IntuneTenants//Tenant").AutoEnrollUpdatesBasedOnIntune;
                ThresholdPath       = $xmlContent.SelectNodes("//IntuneTenants//Tenant").UpdateThresholdBasedOnIntune;
            }

            foreach ($node in $Nodes) {
                Write-Host "$($node.Alias) Enabled: " -NoNewline
                if ($($node.EnabledPath) -match "true") {
                    Write-Host "$($($node.EnabledPath))" -ForegroundColor Green
                }
                elseif ($($node.EnabledPath) -match "false") {
                    Write-Host "$($($node.EnabledPath))" -ForegroundColor Red
                }
                elseif (-not ([string]::IsNullOrEmpty($node.EnabledPath))) {
                    Write-Host "$($($node.EnabledPath))"
                }
                else {
                    Write-Host "N/A" -ForegroundColor Yellow
                }
                Write-Host "`tThreshold: $($node.ThresholdPath)"
            }
        )
    }
}