function Get-SettingsWithPrePostScritps {
    param ([Parameter(Mandatory = $false)]
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
        
    $ProductNodes = @(
        @{ Name = "Updates"; Alias = "Updates"; Path = $xmlContent.SelectNodes("//SearchPatterns") },
        @{ Name = "Packages"; Alias = "ConfigMgr Apps"; Path = $xmlContent.SelectNodes("//Packages") },
        @{ Name = "CustomPackages"; Alias = "ConfigMgr Custom Apps"; Path = $xmlContent.SelectNodes("//CustomPackages") },
        @{ Name = "IntuneApplications"; Alias = "Intune Apps"; Path = $xmlContent.SelectNodes("//IntuneTenants//Applications") },
        @{ Name = "IntuneCustomApplications"; Alias = "Intune Custom Apps"; Path = $xmlContent.SelectNodes("//IntuneTenants//CustomApplications") },
        @{ Name = "IntuneUpdates"; Alias = "Intune Updates"; Path = $xmlContent.SelectNodes("//IntuneTenants//Updates") },
        @{ Name = "IntuneCustomUpdates"; Alias = "Intune Custom Updates"; Path = $xmlContent.SelectNodes("//IntuneTenants//CustomUpdates") }
    )

    $productsList = @()

    foreach ($productNode in $ProductNodes) {
        $nodeData = @{
            Name     = $productNode.Alias
            Products = @()
        }

        foreach ($SearchPattern in $productNode.Path.SearchPattern) {
            if (($SearchPattern.RecommendedPreScriptPath) -or ($SearchPattern.RecommendedPostScriptPath) `
            -or ($SearchPattern.PreCommand) -or ($SearchPattern.PostCommand) `
            -or ($SearchPattern.AdditionalFiles) -or ($SearchPattern.AdditionalFolders)) {
                $PrePostScriptInfo = @{
                    PreScriptPMPC = @()
                    PostScriptPMPC = @()
                    PreScript = @()
                    PostScript = @()
                    PreCommandUninstall = @()
                    PostCommandUninstall = @()
                    AdditionalFiles = @()
                    AdditionalFolders = @()
                }

                # Patch My PC Defined Pre Script
                if (($SearchPattern.RecommendedPreScriptPath)) {
                    $PrePostScriptInfo.PreScriptPMPC += @{
                        Type   = "PMPC Pre-Script"
                        Path   = $($SearchPattern.SelectSingleNode("RecommendedPreScriptPath").InnerXml)
                        Args   = $SearchPattern.RecommendedPreScriptArgument
                        Abort  = $SearchPattern.RecommendedPreScriptAbortOnFail
                        RBSK = $($SearchPattern.SelectSingleNode("RecommendedPreScriptPath").RunBeforeSkipOrKill)
                    }
                }

                # Patch My PC Defined Post Script
                if (($SearchPattern.RecommendedPostScriptPath)) {
                    $PrePostScriptInfo.PostScriptPMPC += @{
                        Type   = "PMPC Post-Script"
                        Path   = $($SearchPattern.SelectSingleNode("RecommendedPostScriptPath").InnerXml)
                        Args   = $SearchPattern.RecommendedPostScriptArgument
                    }
                }

                # Pre Install Command
                if (($SearchPattern.PreCommand)) {
                    $PrePostScriptInfo.PreScript += @{
                        Type   = "Pre-Command"
                        Path   = $($SearchPattern.SelectSingleNode("PreCommand").InnerXml)
                        Args   = $SearchPattern.PreCommandArg
                        Abort  = $SearchPattern.AbortOnPreScriptFail
                        RBSK = $($SearchPattern.SelectSingleNode("PreCommand").RunBeforeSkipOrKill)
                    }
                }

                # Post Install Command
                if (($SearchPattern.PostCommand)) {
                    $PrePostScriptInfo.PostScript += @{
                        Type   = "Post-Command"
                        Path   = $($SearchPattern.SelectSingleNode("PostCommand").InnerXml)
                        Args   = $SearchPattern.PostCommandArg
                    }
                }

                # Pre Uninstall Command
                if (($SearchPattern.PreCommandUninstall)) {
                    $PrePostScriptInfo.PreCommandUninstall += @{
                        Type   = "Pre-Uninstall Command"
                        Path   = $($SearchPattern.SelectSingleNode("PreCommandUninstall").InnerXml)
                        Args   = $SearchPattern.PreCommandArgUninstall
                        Abort  = $SearchPattern.AbortOnPreScriptFailUninstall
                        RBSK = $($SearchPattern.SelectSingleNode("PreCommandUninstall").RunBeforeSkipOrKillUninstall)
                    }
                }

                # Post Uninstall Command
                if (($SearchPattern.PostCommandUninstall)) {
                    $PrePostScriptInfo.PostCommandUninstall += @{
                        Type   = "Post-Uninstall Command"
                        Path   = $($SearchPattern.SelectSingleNode("PostCommandUninstall").InnerXml)
                        Args   = $SearchPattern.PostCommandArgUninstall
                    }
                }

                # Additional Files
                if (($SearchPattern.AdditionalFiles)) {
                    foreach ($File in $SearchPattern.AdditionalFiles.File) {
                        $PrePostScriptInfo.AdditionalFiles += @{
                            File = $File
                        }
                    }
                }

                # Additional Folders
                if (($SearchPattern.AdditionalFolders)) {
                    foreach ($Folder in $SearchPattern.AdditionalFolders.Folder) {
                        $PrePostScriptInfo.AdditionalFolders += @{
                            Folder = $Folder
                        }
                    }
                }

                $nodeData.Products += @{
                    Product = $SearchPattern.product
                    PrePostScriptInfo = $PrePostScriptInfo
                }
            }
        }

        $productsList += $nodeData
    }
    
    return $productsList
}