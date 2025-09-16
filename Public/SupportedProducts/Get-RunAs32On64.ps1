function Get-RunAs32On64 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [switch]
        # Returns the Total count of products with the 'RunAs32On64' node
        $Count,

        [Parameter(Mandatory = $false)]
        [switch]
        # Returns the Names of products with the 'RunAs32On64' node
        $ReturnName
    )

    # Get the Latest SupportedProducts.xml
    Update-SupportedProducts

    # Get Cache Folder
    $SupportedProductsFolder = Get-SupportedProductsCachePath
    Write-Verbose -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Supported Products Cache Folder: [$SupportedProductsFolder]"

    # Import the Supported Products XML
    $SupportedProductsXml = [xml](Get-Content -Path $SupportedProductsFolder\SupportedProducts.xml)
    Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Successfully imported the supported products XML file"

    # Get All Products with the 'RunAs32On64' node
    $Products = $SupportedProductsXml.SelectNodes("//RunAs32On64")

    if ($Count) {
        return $Products.Count
    }
    elseif ($ReturnName) {
        return $Products.ParentNode.name
    }
    else {
        return $Products.ParentNode
    }
}