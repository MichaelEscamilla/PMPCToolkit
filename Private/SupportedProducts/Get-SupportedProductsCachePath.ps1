function Get-SupportedProductsPath {
    [CmdletBinding()]
    param ()

    $ParentPath = "$(($PMPCToolkitModule.Module.DefaultCachePath))"
    $ChildPath = "$(($PMPCToolkitModule.Module.DefaultCacheFolderName))"
    $GrandChildPath = "$(($PMPCToolkitModule.SupportProducts.DefaultCacheFolderName))"

    $Path = Join-Path -Path $ParentPath -ChildPath $ChildPath
    $Path = Join-Path -Path $Path -ChildPath $GrandChildPath

    return $Path
}