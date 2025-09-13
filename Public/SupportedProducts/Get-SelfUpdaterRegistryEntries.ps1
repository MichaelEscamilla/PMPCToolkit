function Get-SelfUpdaterRegistryEntries {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $Name
    )

    # Get Cache Folder
    $SupportedProductsFolder = Get-SupportedProductsCachePath
    Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] Supported Products Cache Folder: [$SupportedProductsFolder]"

    # Import the Supported Products XML
    $SupportedProductsXml = [xml](Get-Content -Path $SupportedProductsFolder\SupportedProducts.xml)
    Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] Successfully imported the supported products XML file"

    # Get All Products with the 'Self-Updater' node
    $Products = $SupportedProductsXml.SelectNodes("//Self-Updater")

    # Get parent nodes (products)
    $ParentNodes = $Products.ParentNode

    # If Name parameter is specified, filter by product name (case-insensitive, partial match)
    if ($Name) {
        $ParentNodes = $ParentNodes | Where-Object { $_.name -like "*${Name}*" }
    }

    # Build and return an array of objects, one per Product, with all Registry nodes in an array
    $Results = New-Object -TypeName PSCustomObject
    foreach ($product in $ParentNodes) {
        $selfUpdater = $product.'Self-Updater'

        $selfUpdaterEntries = foreach ($entry in $selfUpdater.ChildNodes) {
            [PSCustomObject]@{
                Action  = $entry.Action
                Key = $entry.Key
                Value = $entry.Value
                WOW6432Node = $entry.WOW6432Node
                Type = $entry.Type
                Data = $entry.InnerXML
            }
        }

        # Add the self-updater entries to the product object
       $Object = [PSCustomObject]@{
            Name     = $product.name
        }

        # loop through the Entries in $selfUpdaterEntries
        foreach ($entry in $selfUpdaterEntries) {
            # Add the Entry to the product object
            $Object | Add-Member -MemberType NoteProperty -Name "$($entry.Value)" -Value $entry
        }

        $Object
    }
}