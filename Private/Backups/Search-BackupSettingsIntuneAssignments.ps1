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
                        EnforceIntuneAssignments = ($null -ne $SearchPattern.EnforceIntuneAssignments)
                        Assignments = @()
                    }

                    # Get the Assignments for the Product
                    foreach ($IntuneAssignment in $SearchPattern.IntuneAssignments.IntuneAssignment) {
                        $AssignmentDetails = @{}
                        $AssignmentDetails = @{
                            Intent     = $IntuneAssignment.Intent
                            Assignment = @()
                        }

                        $GroupName = $null
                        $Mode = $null
                        $DOPriority = $null
                        $FilterType = $null
                        $FilterId = $null
                        $AvailableTime = $null
                        $Deadline = $null
                        $GracePeriod = $null

                        # Check Target Type
                        switch ($IntuneAssignment.Target.Type) {
                            "IncludedGroup" {
                                $GroupName = $IntuneAssignment.Target.GroupId
                                $Mode = "Included"
                            }
                            "ExcludedGroup" {
                                $GroupName = $IntuneAssignment.Target.GroupId
                                $Mode = "Excluded"
                            }
                            "AllUsers" {
                                $GroupName = "All Users"
                                $Mode = "Included"
                            }
                            "AllDevices" {
                                $GroupName = "All Devices"
                                $Mode = "Included"
                            }
                            default {
                                $GroupName = "Unknown Target Type: $($IntuneAssignment.Target.Type)"
                                $Mode = $null
                            }
                        }

                        if ($Mode -ne "Excluded") {
                            # Delivery Optimization Priority
                            switch ($IntuneAssignment.Settings.DeliveryOptimizationPriority) {
                                "foreground" {
                                    $DOPriority = "Foreground"
                                }
                                "notConfigured" {
                                    $DOPriority = "Background"
                                }
                                $null {
                                    $DOPriority = $null
                                }
                                default {
                                    $DOPriority = "Unknown DO Priority: $($IntuneAssignment.Settings.DeliveryOptimizationPriority)"
                                }
                            }

                            # Filter Type
                            switch ($IntuneAssignment.Target.FilterType) {
                                "none" {
                                    $FilterType = "none"
                                    $FilterId = $null
                                }
                                "include" {
                                    $FilterType = "Include"
                                    $FilterId = $IntuneAssignment.Target.FilterId
                                }
                                "exclude" {
                                    $FilterType = "Exclude"
                                    $FilterId = $IntuneAssignment.Target.FilterId
                                }
                                Default {
                                    $FilterType = "none"
                                    $FilterId = $null
                                }
                            }

                            # Availabile Time
                            if ($IntuneAssignment.Settings.InstallSettings) {
                                if ($null -ne $IntuneAssignment.Settings.InstallSettings.StartDateOffset) {
                                    # Covert Time offset 
                                    $StartDateOffset = [datetime]::ParseExact($IntuneAssignment.Settings.InstallSettings.StartTimeOffset, "yyyy-MM-dd HH:mm:ssZ", [System.Globalization.CultureInfo]::InvariantCulture).ToUniversalTime()
                                    # Get UseLocalTime
                                    if ($IntuneAssignment.Settings.InstallSettings.UseLocalTime -match "true") {
                                        $DeviceTime = "(Device)"
                                    }
                                    else {
                                        $DeviceTime = "(UTC)"
                                    }
                                    $AvailableTime = "+$($IntuneAssignment.Settings.InstallSettings.StartDateOffset) Days at $($StartDateOffset.ToString("hh:mm tt")) $DeviceTime"
                                }
                                else {
                                    $AvailableTime = "ASAP"
                                }
                            }
                            else {
                                $AvailableTime = "ASAP"
                            }

                            # DeadLine
                            if ($IntuneAssignment.Settings.InstallSettings.DeadlineDateOffset) {
                                if ($null -ne $IntuneAssignment.Settings.InstallSettings.DeadlineDateOffset) {
                                    # Covert Time offset 
                                    $DeadlineDateOffset = [datetime]::ParseExact($IntuneAssignment.Settings.InstallSettings.DeadlineTimeOffset, "yyyy-MM-dd HH:mm:ssZ", [System.Globalization.CultureInfo]::InvariantCulture).ToUniversalTime()
                                    # Get UseLocalTime
                                    if ($IntuneAssignment.Settings.InstallSettings.UseLocalTime -match "true") {
                                        $DeviceTime = "(Device)"
                                    }
                                    else {
                                        $DeviceTime = "(UTC)"
                                    }
                                    $Deadline = "+$($IntuneAssignment.Settings.InstallSettings.DeadlineDateOffset) Days at $($DeadlineDateOffset.ToString("hh:mm tt")) $DeviceTime"
                                }
                                else {
                                    $Deadline = "ASAP"
                                }
                            }
                            else {
                                $Deadline = "ASAP"
                            }

                            # Restart Grace Period
                            if ($IntuneAssignment.Settings.RestartSettings) {
                                if ($null -ne $IntuneAssignment.Settings.RestartSettings.Snooze) {
                                $Snooze = " Snooze: $($IntuneAssignment.Settings.RestartSettings.Snooze) min"
                                } else{
                                    $Snooze = $null
                                }
                                $GracePeriod = "$($IntuneAssignment.Settings.RestartSettings.GracePeriod) min - Countdown $($IntuneAssignment.Settings.RestartSettings.Countdown) min$Snooze"
                            }
                            else {
                                $GracePeriod = "Not Configured"
                            }
                        }

                        $AssignmentDetails.Assignment += @{
                            GroupName     = $GroupName
                            Mode          = $Mode
                            Notification  = $IntuneAssignment.Settings.Notifications
                            DOPriority    = $DOPriority
                            FilterType    = $FilterType
                            FilterId      = $FilterId
                            AvailableTime = $AvailableTime
                            Deadline      = $Deadline
                            GracePeriod   = $GracePeriod
                        }
                        
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
            Name = "No Tenant Information Found"
        }
        $Tenants += $TenantInfo
    }

    return $Tenants
}
