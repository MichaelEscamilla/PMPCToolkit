function Search-BackupSettingsIntuneAssignments {
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
        
    # Get the Intune Tenant Node
    $TenantsNode = $xmlContent.SelectSingleNode("//IntuneTenants");

    $Tenants = @()

    if ($null -ne $TenantsNode) {
        foreach ($TenantInfo in $TenantsNode.Tenant) {
            $TenantInformation = @{
                Name        = $TenantInfo.FriendlyName
                TenantInfo  = $TenantInfo
                ProductList = @()
            }

            $ProductNodes = @(
                @{ Name = "IntuneCustomApplications"; Alias = "Intune Custom Apps"; Path = $xmlContent.SelectNodes("//IntuneTenants//CustomApplications") },
                @{ Name = "IntuneApplications"; Alias = "Intune Apps"; Path = $xmlContent.SelectNodes("//IntuneTenants//Applications") },
                @{ Name = "IntuneCustomUpdates"; Alias = "Intune Custom Updates"; Path = $xmlContent.SelectNodes("//IntuneTenants//CustomUpdates") },
                @{ Name = "IntuneUpdates"; Alias = "Intune Updates"; Path = $xmlContent.SelectNodes("//IntuneTenants//Updates") }
            )
            
            $productsList = @()
            
            foreach ($Node in $ProductNodes) {
                $ProductNode = @{
                    Name     = $Node.Alias
                    Products = @()
                }

                foreach ($SearchPattern in $Node.Path.SearchPattern) {
                    $ProductNode.Products += @{
                        ProductName = $SearchPattern.product
                        Product     = $SearchPattern
                        Assignments = @()
                    }

                    # Get the Assignments for the Product
                    foreach ($IntuneAssignment in $SearchPattern.IntuneAssignments.IntuneAssignment) {
                        $AssignmentDetails = @{}
                        $AssignmentDetails = @{
                            Intent     = $IntuneAssignment.Intent
                            Assignment = @()
                        }

                        # Check Target Type
                        Write-Host "Target Type: $($IntuneAssignment.Target.Type)" -ForegroundColor Green
                        switch ($IntuneAssignment.Target.Type) {
                            "IncludedGroup" {
                                $GroupName = $IntuneAssignment.Target.GroupId
                            }
                            "AllUsers" {
                                $GroupName = "All Users"
                            }
                            "AllDevices" {
                                $GroupName = "All Devices"
                            }
                            default {
                                $GroupName = "Unknown Target Type: $($IntuneAssignment.Target.Type)"
                            }
                        }

                        # Check IncludeMode
                        switch ($IntuneAssignment.Target.Type) {
                            "IncludedGroup" {
                                $Mode = "Include"
                            }
                            Default {
                                $Mode = "Default"
                            }
                        }

                        # Filter Type
                        switch ($IntuneAssignment.Target.FilterType) {
                            "none" {
                                $FilterType = "none"
                            }
                            Default {
                                $FilterType = "DefaultFilter"
                            }
                        }

                        $AssignmentDetails.Assignment += @{
                            GroupName     = $GroupName
                            Mode          = $Mode
                            FilterType    = $FilterType
                        }
                        Write-Host "Assignment Details: $($AssignmentDetails.Assignment | Out-String)" -ForegroundColor Yellow
                        $ProductNode.Products[-1].Assignments += @($AssignmentDetails)
                    }
                }
                
                $productsList += $ProductNode
            }

            $TenantInformation.ProductList = $productsList

            $Tenants += $TenantInformation
        }
    }
    else {
        $TenantInfo = @{
            TenantFriendlyName = "No Tenant Information Found"
        }
        $Tenants += $TenantInfo
    }
    <#
    $ProductNodes = @(
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
    #>
    return $Tenants
}
