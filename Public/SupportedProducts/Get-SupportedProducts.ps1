function Get-SupportedProducts {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]
        $FilePath = "$(Get-SupportedProductsCachePath)"
    )

    # Define Supported Products Url
    $SupportedProductsUrl = "https://api.patchmypc.com/downloads/xml/supportedproducts.xml"

    # Define Supported Products File Name
    $SupportedProductsFile = "SupportedProducts.xml"

    # Cache Folder
    $SupportedProductsFolder = "$($FilePath)"
    if (-not(Test-Path $SupportedProductsFolder)) {
        $null = New-Item -Path $SupportedProductsFolder -ItemType Directory -Force
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
    catch [System.UnauthorizedAccessException] {
        Write-Warning "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Failed to save: [$SupportedProductsFileFullName] due to insufficient permissions."
        # Change to the default path and try saving again
        $SupportedProductsFolder = "$(Get-SupportedProductsCachePath)"
        $SupportedProductsFileFullName = Join-Path $SupportedProductsFolder $SupportedProductsFile
        Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Saving: [$SupportedProductsFileFullName]"
        try {
            $SupportedProductsXmlRaw.Content | Out-File -FilePath "$($SupportedProductsFileFullName)" -Encoding utf8 -Force
            Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Successfully saved: [$SupportedProductsFileFullName]"
        }
        catch {
            Write-Host "Failed to save the supported products XML file to the default path: $SupportedProductsFileFullName"
            Write-Error "$($_.Exception.Message)"
            return
        }
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
        $_
        return
    }
}