[CmdletBinding()]
param (
    [string]$InputPath  = "$PSScriptRoot\PatchMyPC.xml",
    [string]$OutputPath = "$PSScriptRoot\PatchMyPC_AdobeAcrobatOnly.xml"
)

Write-Host "Loading XML: $InputPath"
$xml = [xml](Get-Content -Path $InputPath -Raw -Encoding UTF8)

$smcNs  = 'http://schemas.microsoft.com/sms/2005/04/CorporatePublishing/SystemsManagementCatalog.xsd'
$sdpNs  = 'http://schemas.microsoft.com/wsus/2005/04/CorporatePublishing/SoftwareDistributionPackage.xsd'

$nsMgr = [System.Xml.XmlNamespaceManager]::new($xml.NameTable)
$nsMgr.AddNamespace('smc', $smcNs)
$nsMgr.AddNamespace('sdp', $sdpNs)

# Collect all SoftwareDistributionPackage nodes
$packages = $xml.SelectNodes('//smc:SoftwareDistributionPackage', $nsMgr)

$totalCount  = $packages.Count
$removedCount = 0

foreach ($pkg in $packages) {
    $titleNode = $pkg.SelectSingleNode('sdp:LocalizedProperties/sdp:Title', $nsMgr)
    $title = if ($titleNode) { $titleNode.InnerText } else { '' }

    if (($title -notmatch 'Adobe Acrobat') -or ($title -match '^BaseInstall')) {
        $pkg.ParentNode.RemoveChild($pkg) | Out-Null
        $removedCount++
    }
}

$keptCount = $totalCount - $removedCount
Write-Host "Total packages : $totalCount"
Write-Host "Removed        : $removedCount"
Write-Host "Kept (Acrobat) : $keptCount"

$xml.Save($OutputPath)
Write-Host "Saved filtered XML to: $OutputPath"
