function Get-SupportedProducts {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]
        $Destination = "$(Get-SupportedProductsPath)"
    )

    # Define Supported Products Url
    $SupportedProductsUrl = "https://api.patchmypc.com/downloads/xml/supportedproducts.xml"

    # Define Supported Products File Name
    $SupportedProductsFile = "SupportedProducts.xml"

    # Define Destination Folder if the parameter was provided
    if ($PSBoundParameters.ContainsKey("Destination")) {
        $SupportedProductsFolder = Join-Path -Path "$($Destination)" -ChildPath "SupportedProducts"
    }
    else {
        $SupportedProductsFolder = "$(Get-SupportedProductsPath)"
    }

    # Delete Existing $SupportedProductsFolder
    Remove-Item -Path "$($SupportedProductsFolder)" -Recurse -Force -ErrorAction SilentlyContinue

    # Create $SupportedProductsFolder
    try {
        # Create the Destination
        $null = New-Item -Path $SupportedProductsFolder -ItemType Directory -Force -ErrorAction Stop
    }
    catch {
        Write-Warning "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Failed to create folder: [$SupportedProductsFolder]"
        $SupportedProductsFolder = "$(Get-SupportedProductsPath)"
        Write-Warning "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Using default folder: [$SupportedProductsFolder]"

        # Delete Existing $SupportedProductsFolder
        Remove-Item -Path "$($SupportedProductsFolder)" -Recurse -Force -ErrorAction SilentlyContinue
        
        try {
            # Create the Destination
            $null = New-Item -Path $SupportedProductsFolder -ItemType Directory -Force -ErrorAction Stop
        }
        catch {
            Write-Warning "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Failed to create folder: [$SupportedProductsFolder]"
            return
        }
    }

    # Define Supported Products File FullName
    $SupportedProductsFileFullName = Join-Path $SupportedProductsFolder $SupportedProductsFile

    # Download the Supported Products XML
    try {
        Write-Verbose "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Downloading: [$SupportedProductsUrl]"
        $SupportedProductsXmlRaw = Invoke-WebRequest -Uri $SupportedProductsUrl -UseBasicParsing
        Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Successfully downloaded: [$SupportedProductsUrl]"
    }
    catch {
        Write-Host "Failed to download the supported products XML file from $SupportedProductsUrl"
        Write-Error "$($_.Exception.Message)"
        return
    }

    # Save the supported products XML file
    try {
        Write-Verbose "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Saving: [$SupportedProductsFileFullName]"
        $SupportedProductsXmlRaw.Content | Out-File -FilePath "$($SupportedProductsFileFullName)" -Encoding utf8 -Force
        Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Successfully saved: [$SupportedProductsFileFullName]"
    }
    catch {
        Write-Host "Failed to save the supported products XML file to $SupportedProductsFileFullName"
        Write-Error "$($_.Exception.Message)"
        return
    }

    # Open the folder containing the Supported Products XML file
    try {
        Write-Verbose "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Opening: [$SupportedProductsFolder]"
        Start-Process -FilePath "explorer.exe" -ArgumentList "$($SupportedProductsFolder)" -Wait
        Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Successfully opened:[$SupportedProductsFolder]"
    }
    catch {
        Write-Host "Failed to open the folder containing the supported products XML file at $SupportedProductsFolder"
        Write-Error "$($_.Exception.Message)"
        return
    }
}