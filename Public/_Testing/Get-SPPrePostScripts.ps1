function Get-SPPrePostScripts {
    param ([Parameter(Mandatory = $false)]
        [string]
        $SettingsFilePath
    )

    Get-SupportedProducts -NoExplorer

    # Default Destination Path
    $DestinationDefault = Join-Path -Path "$($PMPCToolkitModule.Module.DefaultCachePath)" -ChildPath "$($PMPCToolkitModule.Module.DefaultCacheFolderName)"
    $DestinationDefault = Join-Path -Path $DestinationDefault -ChildPath "$($PMPCToolkitModule.SupportProducts.DefaultCacheFolderName)"

    # Define Supported Products File Name
    $SupportedProductsFile = "$($PMPCToolkitModule.SupportProducts.SupportProductsXMLFileName)"

    # Define Supported Products File FullName
    $SupportedProductsFileFullName = Join-Path $DestinationDefault $SupportedProductsFile

    # Validate the provided file path exists
    if (-not (Test-Path -Path $SupportedProductsFileFullName)) {
        Write-Host "The specified file path does not exist: $SupportedProductsFileFullName" -ForegroundColor Red
        return
    }

    $SPPrePostScripts = Get-ProductsWithPrePostScritps -SettingsFilePath $SupportedProductsFileFullName

    & "$($MyInvocation.MyCommand.Module.ModuleBase)\GUI\PrePostScript\PrePostScriptUI.ps1" -TreeViewItems $SPPrePostScripts
}