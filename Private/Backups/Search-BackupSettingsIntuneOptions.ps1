function Search-BackupSettingsIntuneOptions {
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

    #TODO: Refactor to handle multiple tenants. Check Intune Assignments for Inspiration
    # Get the Intune Tenants Node
    $TenantsNode = $xmlContent.SelectSingleNode("//IntuneTenants");

    $Tenants = @()

    if ($null -ne $TenantsNode) {
        foreach ($TenantNode in $TenantsNode.SelectNodes("Tenant")) {
            $TenantInformation = @{
                Name                            = $TenantNode.FriendlyName
                TenantFriendlyName              = $TenantNode.FriendlyName

                Authority                       = $TenantNode.Authority
                AuthenticationUrl               = $TenantNode.AuthenticationUrl
                GraphBaseUrl                    = $TenantNode.BaseUrl

                ApplicationId                   = $TenantNode.ApplicationId
                AppSecret                       = $TenantNode.ApplicationSecret
                AppCertificateEnabled           = $TenantNode.ApplicationCertificateThumbprint.Enabled
                AppCertificateThumbprint        = $TenantNode.SelectSingleNode("ApplicationCertificateThumbprint").InnerText

                DigitallySignScript             = $TenantNode.SignDetectionScripts
                CodeSigningCertificate          = $TenantNode.SelectSingleNode("CodeSigningCertificateThumbprint").InnerText

                UpdateESPAssociations           = $TenantNode.UpdateEspAssociation
                CopyAssignmentsOnUpdate         = $TenantNode.CopyAssignments
                DeleteAssignmentsOnUpdate       = $TenantNode.DeleteAssignments
                UpdateDependencies              = $TenantNode.UpdateAppDependencies
                CopyRequirements                = $TenantNode.CopyRequirements
                DeletePreviousApplications      = $TenantNode.DeleteApp
                RetainPreviousApplicationsCount = $TenantNode.RetainApp
                DeletePreviousUpdates           = $TenantNode.DeleteUpdates
                RetainPreviousUpdatesCount      = $TenantNode.RetainUpdates
                MaxRuntimeMinutes               = if ($null -ne $TenantNode.Win32MaxRuntime) { $TenantNode.Win32MaxRuntime } else { 120 }
                EnableAvailableUninstall        = $TenantNode.AllowAvailableUninstall
            }
            $Tenants += $TenantInformation
        }
    }
    else {
        $TenantInformation = @{
            TenantFriendlyName = "No Tenant Information Found"
        }
        $Tenants += $TenantInformation
    }
    return $Tenants
}
