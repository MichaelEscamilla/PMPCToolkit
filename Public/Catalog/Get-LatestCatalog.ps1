function Get-LatestCatalog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $License,

        [Parameter(Mandatory = $false)]
        [string]
        $Destination = "$(Get-LatestCatalogPath)",

        [Parameter(Mandatory = $false)]
        [switch]
        $ExtractAll
    )

    # Define Latest Catalog Url
    $LatestCatalogUrl = "https://api.patchmypc.com/subscriber_download.php?id=$($License)"

    # Define Latest Catalog CAB Name
    $LatestCatalogFileCAB = "Catalog.cab"

    # Define Latest Catalog XML Name
    $LatestCatalogFileXML = "PatchMyPC.xml"

    # Define Destination Folder if the parameter was provided
    if ($PSBoundParameters.ContainsKey("Destination")) {
        $LatestCatalogFolder = Join-Path -Path "$($Destination)" -ChildPath "LatestCatalog"
    }
    else {
        $LatestCatalogFolder = "$(Get-LatestCatalogPath)"
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
        $LatestCatalogFolder = "$(Get-LatestCatalogPath)"
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
    $LatestCatalogFileCABFullName = Join-Path $LatestCatalogFolder $LatestCatalogFileCAB

    # Define Latest Catalog XML File FullName
    $LatestCatalogFileXMLFullName = Join-Path $LatestCatalogFolder $LatestCatalogFileXML

    # Download the Catalog
    try {
        Write-Verbose "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Downloading: [$LatestCatalogUrl]"
        Invoke-WebRequest -Uri $LatestCatalogUrl -OutFile "$($LatestCatalogFileCABFullName)"
        Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Successfully Downloaded: [$LatestCatalogUrl]"
    }
    catch {
        Write-Host "Failed to download the Latest Catalog CAB file"
        return
    }

    # Extract the Catalog
    try {
        if ($PSBoundParameters.ContainsKey("ExtractAll")) {
            Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Extracting Full CAB: [$LatestCatalogFileCAB]"
            Start-Process -FilePath "C:\Windows\System32\expand.exe" -ArgumentList "-F:* `"$($LatestCatalogFileCABFullName)`" `"$LatestCatalogFolder`"" -WindowStyle Hidden -Wait
            Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Successfully Extracted Full CAB: [$LatestCatalogFileCAB]"
        }
        else {
            Write-Verbose "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Extracting: [$LatestCatalogFileXML]"
            Start-Process -FilePath "C:\Windows\System32\expand.exe" -ArgumentList "-R -I -F:PatchMyPC.xml `"$($LatestCatalogFileCABFullName)`" `"$LatestCatalogFolder`"" -WindowStyle Hidden -Wait
            Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Successfully Extracted: [$LatestCatalogFileXML]"
        }
    }
    catch {
        Write-Host "Failed to extract the Latest Catalog XML file to $LatestCatalogFileXMLFullName"
        Write-Error "$($_.Exception.Message)"
        return
    }

    # Open the $Destination in File Explorer
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