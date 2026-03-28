
<#
    .SYNOPSIS
    Downloads and extracts the latest Patch My PC catalog.

    .DESCRIPTION
    This function downloads the latest catalog from Patch My PC using a provided license key.
    It can optionally extract all files from the catalog or just the primary XML file.
    The extracted files are saved to a specified destination folder.

    .PARAMETER License
    The license key required to download the Patch My PC catalog from the API.

    .PARAMETER Destination
    The destination path where the LatestCatalog folder will be created.
    Defaults to the path returned by Get-LatestCatalogPath.

    .PARAMETER ExtractAll
    If specified, extracts all files from the catalog CAB file.
    If not specified, only extracts the PatchMyPC.xml file.

    .EXAMPLE
    Get-LatestCatalog -License "your-license-key"

    Downloads the latest catalog and extracts only the PatchMyPC.xml file to the default location.

    .EXAMPLE
    Get-LatestCatalog -License "your-license-key" -Destination "C:\Custom\Path" -ExtractAll

    Downloads the latest catalog, extracts all files to C:\Custom\Path\LatestCatalog, and opens the folder in File Explorer.

    .NOTES
    This function requires internet connectivity and administrative privileges to create directories.
    It uses expand.exe to extract CAB files and opens the result in Windows File Explorer.
#>
function Get-LatestCatalog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $License,

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

    # Default Destination Path
    $DestinationDefault = Join-Path -Path "$($PMPCToolkitModule.Module.DefaultCachePath)" -ChildPath "$($PMPCToolkitModule.Module.DefaultCacheFolderName)"
    $DestinationDefault = Join-Path -Path $DestinationDefault -ChildPath "LatestCatalog"

    # Define Latest Catalog Url
    $LatestCatalogUrl = "https://api.patchmypc.com/subscriber_download.php?id=$($License)"

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
        Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Successfully Downloaded: [$LatestCatalogUrl]"
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