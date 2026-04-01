function Search-BackupSettingsEnabledTabs {
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
                Name                = "Updates";
                Alias               = "WSUS Updates";
                EnabledPath         = $xmlContent.SelectNodes("//EnableWsusUpdates").InnerText;
                EnabledProductsPath = $xmlContent.SelectNodes("//SearchPatterns//SearchPattern") 
            }, @{
                Name                = "Packages";
                Alias               = "ConfigMgr Apps";
                EnabledPath         = $xmlContent.SelectNodes("//AllowPackageCreation").InnerText;
                EnabledProductsPath = $xmlContent.SelectNodes("//Packages//SearchPattern") 
            }, @{
                Name                = "CustomPackages";
                Alias               = "ConfigMgr Custom Apps";
                EnabledPath         = $xmlContent.SelectNodes("//AllowPackageCreation").InnerText;
                EnabledProductsPath = $xmlContent.SelectNodes("//CustomPackages//SearchPattern") 
            }, @{
                Name                = "IntuneApplications";
                Alias               = "Intune Apps";
                EnabledPath         = $xmlContent.SelectNodes("//IntuneTenants/Tenant").EnableApplications;
                EnabledProductsPath = $xmlContent.SelectNodes("//IntuneTenants//Applications//SearchPattern") 
            }, @{
                Name                = "IntuneCustomApplications";
                Alias               = "Intune Custom Apps";
                EnabledPath         = $xmlContent.SelectNodes("//IntuneTenants/Tenant").EnableApplications;
                EnabledProductsPath = $xmlContent.SelectNodes("//IntuneTenants//CustomApplications//SearchPattern") 
            }, @{
                Name                = "IntuneUpdates";
                Alias               = "Intune Updates";
                EnabledPath         = $xmlContent.SelectNodes("//IntuneTenants/Tenant").EnableUpdates;
                EnabledProductsPath = $xmlContent.SelectNodes("//IntuneTenants//Updates//SearchPattern") 
            }, @{
                Name                = "IntuneCustomUpdates";
                Alias               = "Intune Custom Updates";
                EnabledPath         = $xmlContent.SelectNodes("//IntuneTenants/Tenant").EnableUpdates;
                EnabledProductsPath = $xmlContent.SelectNodes("//IntuneTenants//CustomUpdates//SearchPattern") 
            }
        )

        foreach ($node in $Nodes) {
            Write-Host "Tab: [$($node.Alias)]"
            Write-Host "`tEnabled: " -NoNewline
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
            Write-Host "`tEnabled Product Count: $($node.EnabledProductsPath.Count)"
        }
    }
}