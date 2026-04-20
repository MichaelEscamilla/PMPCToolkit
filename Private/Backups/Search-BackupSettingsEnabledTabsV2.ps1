function Search-BackupSettingsEnabledTabsV2 {
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

    $Nodes = @(
        @{
            Name                = "Updates"
            Alias               = "WSUS Updates"
            EnabledPath         = $xmlContent.SelectNodes("//EnableWsusUpdates").InnerText
            EnabledProductsPath = $xmlContent.SelectNodes("//SearchPatterns//SearchPattern")
        },
        @{
            Name                = "Packages"
            Alias               = "ConfigMgr Apps"
            EnabledPath         = $xmlContent.SelectNodes("//AllowPackageCreation").InnerText
            EnabledProductsPath = $xmlContent.SelectNodes("//Packages//SearchPattern")
        },
        @{
            Name                = "CustomPackages"
            Alias               = "ConfigMgr Custom Apps"
            EnabledPath         = $xmlContent.SelectNodes("//AllowPackageCreation").InnerText
            EnabledProductsPath = $xmlContent.SelectNodes("//CustomPackages//SearchPattern")
        },
        @{
            Name                = "IntuneApplications"
            Alias               = "Intune Apps"
            EnabledPath         = $xmlContent.SelectNodes("//IntuneTenants/Tenant").EnableApplications
            EnabledProductsPath = $xmlContent.SelectNodes("//IntuneTenants//Applications//SearchPattern")
        },
        @{
            Name                = "IntuneCustomApplications"
            Alias               = "Intune Custom Apps"
            EnabledPath         = $xmlContent.SelectNodes("//IntuneTenants/Tenant").EnableApplications
            EnabledProductsPath = $xmlContent.SelectNodes("//IntuneTenants//CustomApplications//SearchPattern")
        },
        @{
            Name                = "IntuneUpdates"
            Alias               = "Intune Updates"
            EnabledPath         = $xmlContent.SelectNodes("//IntuneTenants/Tenant").EnableUpdates
            EnabledProductsPath = $xmlContent.SelectNodes("//IntuneTenants//Updates//SearchPattern")
        },
        @{
            Name                = "IntuneCustomUpdates"
            Alias               = "Intune Custom Updates"
            EnabledPath         = $xmlContent.SelectNodes("//IntuneTenants/Tenant").EnableUpdates
            EnabledProductsPath = $xmlContent.SelectNodes("//IntuneTenants//CustomUpdates//SearchPattern")
        }
    )

    $tabsList = @()

    foreach ($node in $Nodes) {
        $enabled = if ($node.EnabledPath -match "true") {
            "True"
        }
        elseif ($node.EnabledPath -match "false") {
            "False"
        }
        elseif (-not ([string]::IsNullOrEmpty($node.EnabledPath))) {
            "$($node.EnabledPath)"
        }
        else {
            "N/A"
        }

        $tabsList += @{
            Name                = $node.Alias
            Enabled             = $enabled
            EnabledProductCount = $node.EnabledProductsPath.Count
        }
    }

    return $tabsList
}
