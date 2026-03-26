function Get-LatestCatalogPath {
    [CmdletBinding()]
    param ()

    $ParentPath = "$($env:TEMP)\PatchMyPC"
    $ChildPath = "LatestCatalog"

    $Path = Join-Path -Path $ParentPath -ChildPath $ChildPath

    return $Path
}