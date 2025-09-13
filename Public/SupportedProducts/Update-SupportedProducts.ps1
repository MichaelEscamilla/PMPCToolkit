function Update-SupportedProducts {
    [CmdletBinding()]
    param (
    )

    # Define Supported Products Url
    $SupportedProductsUrl = "https://api.patchmypc.com/downloads/xml/supportedproducts.xml"

    # Define Supported Products File Name
    $SupportedProductsFile = "SupportedProducts.xml"

    # Cache Folder
    $SupportedProductsFolder = Get-SupportedProductsCachePath
    if (-not(Test-Path $SupportedProductsFolder)) {
        $null = New-Item -Path $SupportedProductsFolder -ItemType Directory -Force
    }

    # Define Supported Products File FullName
    $SupportedProductsFileFullName = Join-Path $SupportedProductsFolder $SupportedProductsFile

    # Download the Supported Products XML
    try {
        $SupportedProductsXmlRaw = Invoke-WebRequest -Uri $SupportedProductsUrl -UseBasicParsing
        Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] Successfully downloaded the supported products XML file from [$SupportedProductsUrl]"
        $SupportedProductsXmlRaw.Content | Out-File -FilePath $SupportedProductsFileFullName -Encoding utf8 -Force
        Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] Successfully saved the supported products XML file to [$SupportedProductsFileFullName]"
    }
    catch {
        Write-Host "Failed to download the supported products XML file from $SupportedProductsUrl"
        return
    }
}