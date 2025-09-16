@{
    # Script module or binary module file associated with this manifest.
    RootModule           = 'PMPCToolkit.psm1'

    # Version number of this module.
    ModuleVersion        = '0.0.8'

    # Supported PSEditions
    CompatiblePSEditions = @('Desktop', 'Core')

    # ID used to uniquely identify this module
    GUID                 = 'e3b2a7c6-4f8a-4e6a-9b2a-2c4e8d6f1a7b'

    # Author of this module
    Author               = 'Michael Escamilla'

    # Company or vendor of this module
    CompanyName          = 'MichaelTheAdmin'

    # Copyright statement for this module
    Copyright            = '(c) Michael Escamilla. All rights reserved.'

    # Description of the functionality provided by this module
    Description          = 'Patch My PC Toolkit'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion    = '5.1'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport    = @(
        'Get-RunAs32On64'
        'Update-SupportedProducts'
        'Invoke-PublisherSettingsBackupExtract'
        'Get-HashFromDigest'
        'Get-AppWorkloadPolicies'
        'Get-AppWorkloadPoliciesTest'
        'Get-SelfUpdaterRegistryEntries'
    )

    PrivateData          = @{
        PSData = @{
            Tags         = @('PatchMyPC', 'Toolkit')
            ProjectUri   = 'https://github.com/MichaelEscamilla/PMPCToolkit'
            LicenseUri   = 'https://github.com/MichaelEscamilla/PMPCToolkit/blob/master/LICENSE'
            # IconUri = 'https://path/to/icon.png'
            ReleaseNotes = 'Initial release of PMPCToolkit'
        }
    }
}

