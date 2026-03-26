function Get-SupportedProductsPath {
    [CmdletBinding()]
    param ()

    $ParentPath = "$($env:TEMP)\PatchMyPC"
    $ChildPath = "SupportedProducts"

    $Path = Join-Path -Path $ParentPath -ChildPath $ChildPath

    return $Path
}