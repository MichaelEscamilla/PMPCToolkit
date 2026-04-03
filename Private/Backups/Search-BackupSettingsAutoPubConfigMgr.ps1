function Search-BackupSettingsAutoPubConfigMgr {
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
                Name  = "ScanSccm";
                Alias = "ConfigMgr Scan Tool Settings";
                Path  = $xmlContent.SelectNodes("//ScanSccm");
            }

            foreach ($node in $Nodes) {
                Write-Host "SQL Server                                   : $($node.Path.InnerText)"
                Write-Host "SQL DB                                       : $($node.Path.Database)"
                Write-Host "Auth Method                                  : $($node.Path.AuthMethod)"

                Write-Host "Auto Enroll Updates                          : " -NoNewline
                if ($($node.Path.AutoEnrollUpdates) -match "true") {
                    Write-Host "$($node.Path.AutoEnrollUpdates)" -ForegroundColor Green
                }
                elseif ($($node.Path.AutoEnrollUpdates) -match "false") {
                    
                    Write-Host "$($node.Path.AutoEnrollUpdates)" -ForegroundColor Red
                }
                Write-Host "`tUpdate Threshold                     : $($node.Path.UpdateThreshold)"

                Write-Host "`tAs Metadata Only                     : " -NoNewline
                if ($($node.Path.AutoEnrollUnderThresholdAsMetadataOnly) -match "true") {
                    Write-Host "$($node.Path.AutoEnrollUnderThresholdAsMetadataOnly)" -ForegroundColor Green
                }
                elseif ($($node.Path.AutoEnrollUnderThresholdAsMetadataOnly) -match "false") {
                    Write-Host "$($node.Path.AutoEnrollUnderThresholdAsMetadataOnly)" -ForegroundColor Red
                }

                Write-Host "Auto Enroll Applications                     : " -NoNewline
                if ($($node.Path.AutoEnrollApplications) -match "true") {
                    Write-Host "$($node.Path.AutoEnrollApplications)" -ForegroundColor Green
                }
                elseif ($($node.Path.AutoEnrollApplications) -match "false") {
                    Write-Host "$($node.Path.AutoEnrollApplications)" -ForegroundColor Red
                }
                Write-Host "`tApplication Threshold                : $($node.Path.ApplicationThreshold)"
            }
        )
    }
}