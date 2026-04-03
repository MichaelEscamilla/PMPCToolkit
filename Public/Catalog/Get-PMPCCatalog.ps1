function Get-PMPCCatalog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]
        $Destination,

        [Parameter(Mandatory = $false)]
        [switch]
        $ExtractAll,

        [Parameter(Mandatory = $false)]
        [switch]
        $NoExplorer
    )

    # Get stored license key
    $LicenseKey = Get-CatalogLicenseKey
    if (-not $LicenseKey) {
        Write-Host -ForegroundColor Red "No license key found. Please save your license key using Save-PMPCCatalogLicenseKey before retrieving the catalog."
        return
    }

    # Default Destination Path
    $DestinationDefault = Join-Path -Path "$($PMPCToolkitModule.Module.DefaultCachePath)" -ChildPath "$($PMPCToolkitModule.Module.DefaultCacheFolderName)"
    $DestinationDefault = Join-Path -Path $DestinationDefault -ChildPath "$($PMPCToolkitModule.Catalog.DefaultCacheFolderName)"

    # Define Latest Catalog Url
    $LatestCatalogUrl = "$($PMPCToolkitModule.Catalog.CatalogURL)$($LicenseKey)"

    # Define Latest Catalog CAB Name
    $CatalogCABFileName = "$($PMPCToolkitModule.Catalog.CatalogCABFileName)"

    # Define Latest Catalog XML Name
    $CatalogXMLFileName = "$($PMPCToolkitModule.Catalog.CatalogXMLFileName)"

    # Define Destination Folder if the parameter was provided
    if ($PSBoundParameters.ContainsKey("Destination")) {
        $LatestCatalogFolder = Join-Path -Path "$($Destination)" -ChildPath "LatestCatalog"
    }
    else {
        $LatestCatalogFolder = "$($DestinationDefault)"
    }

    # Delete Existing $LatestCatalogFolder
    Remove-Item -Path "$($LatestCatalogFolder)" -Recurse -Force -ErrorAction SilentlyContinue
    
    # Create $LatestCatalogFolder
    try {
        # Create the Destination
        $null = New-Item -Path $LatestCatalogFolder -ItemType Directory -Force -ErrorAction Stop
    }
    catch {
        Write-Warning "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Failed to create folder: [$LatestCatalogFolder]"
        $LatestCatalogFolder = "$($DestinationDefault)"
        Write-Warning "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Using default folder: [$LatestCatalogFolder]"

        # Delete Existing $LatestCatalogFolder
        Remove-Item -Path "$($LatestCatalogFolder)" -Recurse -Force -ErrorAction SilentlyContinue
        
        try {
            # Create the Destination
            $null = New-Item -Path $LatestCatalogFolder -ItemType Directory -Force -ErrorAction Stop
        }
        catch {
            Write-Warning "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Failed to create folder: [$LatestCatalogFolder]"
            return
        }
    }

    # Define Latest Catalog CAB File FullName
    $CatalogCABFileNameFullName = Join-Path $LatestCatalogFolder $CatalogCABFileName

    # Define Latest Catalog XML File FullName
    $CatalogXMLFileNameFullName = Join-Path $LatestCatalogFolder $CatalogXMLFileName
    
    # Download the Catalog
    try {
        Write-Verbose "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Downloading: [$LatestCatalogUrl]"
        Invoke-WebRequest -Uri $LatestCatalogUrl -OutFile "$($CatalogCABFileNameFullName)"
        Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Successfully Downloaded Catalog"
    }
    catch {
        Write-Host "Failed to download the Latest Catalog CAB file"
        return
    }

    # Extract the Catalog
    try {
        if ($PSBoundParameters.ContainsKey("ExtractAll")) {
            Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Extracting Full CAB: [$CatalogCABFileName]"
            Start-Process -FilePath "C:\Windows\System32\expand.exe" -ArgumentList "-R -F:* `"$($CatalogCABFileNameFullName)`" `"$LatestCatalogFolder`"" -WindowStyle Hidden -Wait
            Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Successfully Extracted Full CAB: [$CatalogCABFileName]"
        }
        else {
            Write-Verbose "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Extracting: [$CatalogXMLFileName]"
            Start-Process -FilePath "C:\Windows\System32\expand.exe" -ArgumentList "-R -I -F:PatchMyPC.xml `"$($CatalogCABFileNameFullName)`" `"$LatestCatalogFolder`"" -WindowStyle Hidden -Wait
            Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Successfully Extracted: [$CatalogXMLFileName]"
        }
    }
    catch {
        Write-Host "Failed to extract the Latest Catalog XML file to $CatalogXMLFileNameFullName"
        Write-Error "$($_.Exception.Message)"
        return
    }

    # Open the $Destination in File Explorer
    if (-not $NoExplorer) {
        try {
            Write-Verbose "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Opening: [$LatestCatalogFolder]"
            Start-Process -FilePath "explorer.exe" -ArgumentList "$($LatestCatalogFolder)" -Wait
            Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Successfully Opened: [$($LatestCatalogFolder)]"
        }
        catch {
            Write-Host "Failed to open the Latest Catalog folder in File Explorer"
            Write-Error "$($_.Exception.Message)"
            return
        }
    }
}