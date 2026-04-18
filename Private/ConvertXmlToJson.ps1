#!/usr/bin/env powershell
<#
.SYNOPSIS
    Converts PatchMyPC.xml catalog to JSON format

.DESCRIPTION
    Extracts software update information from PatchMyPC.xml and creates a JSON file
    with Title, TargetProductCode, and ObsoletedPatches for each update.

.PARAMETER XmlPath
    Path to the source PatchMyPC.xml file

.PARAMETER JsonPath
    Path to the output JSON file

.PARAMETER RemoveVersionNumbers
    If $true, removes version numbers from titles (default: $true)

.PARAMETER RemoveDuplicates
    If $true, removes duplicate entries from TargetProductCode arrays (default: $true)

.EXAMPLE
    .\ConvertXmlToJson.ps1 -XmlPath '.\PatchMyPC.xml' -JsonPath '.\AdobeAcrobat.json'
#>

param(
    [Parameter(Mandatory = $false)]
    [string]$XmlPath = ".\PatchMyPC.xml",
    
    [Parameter(Mandatory = $false)]
    [string]$JsonPath = ".\AdobeAcrobat.json",
    
    [switch]$RemoveVersionNumbers = $true,
    
    [switch]$RemoveDuplicates = $true
)

# Validate input file exists
if (-not (Test-Path $XmlPath)) {
    Write-Error "XML file not found: $XmlPath"
    exit 1
}

# Load XML
[xml]$xml = Get-Content $XmlPath

$updates = @()

# Navigate directly through the XML structure without relying on namespace prefixes
# The XML structure is: SoftwareDistributionPackage > LocalizedProperties (for title) and InstallableItem (for codes/patches)

$rootNode = $xml.DocumentElement

# Process each SoftwareDistributionPackage
$packages = $rootNode.ChildNodes | Where-Object { $_.LocalName -eq "SoftwareDistributionPackage" }

foreach ($package in $packages) {
    $title = ""
    $productCodes = @()
    $obsoletedPatches = @()
    
    # Get title from LocalizedProperties
    $localizedPropsList = $package.ChildNodes | Where-Object { $_.LocalName -eq "LocalizedProperties" }
    foreach ($localizedProps in $localizedPropsList) {
        $titleNode = $localizedProps.ChildNodes | Where-Object { $_.LocalName -eq "Title" }
        if ($titleNode) {
            $title = $titleNode.InnerText
            break
        }
    }
    
    # Get product codes and obsoleted patches from InstallableItem > Metadata > MsiPatch
    $installableItems = $package.ChildNodes | Where-Object { $_.LocalName -eq "InstallableItem" }
    
    foreach ($item in $installableItems) {
        $applicabilityRules = $item.ChildNodes | Where-Object { $_.LocalName -eq "ApplicabilityRules" }
        
        foreach ($rule in $applicabilityRules) {
            $metadata = $rule.ChildNodes | Where-Object { $_.LocalName -eq "Metadata" }
            
            foreach ($meta in $metadata) {
                $msiPatchMetadata = $meta.ChildNodes | Where-Object { $_.LocalName -eq "MsiPatchMetadata" }
                
                foreach ($msiMeta in $msiPatchMetadata) {
                    $msiPatch = $msiMeta.ChildNodes | Where-Object { $_.LocalName -eq "MsiPatch" }
                    
                    foreach ($patch in $msiPatch) {
                        # Extract TargetProductCode(s)
                        $tpcNodes = $patch.ChildNodes | Where-Object { $_.LocalName -eq "TargetProductCode" }
                        foreach ($tpcNode in $tpcNodes) {
                            $productCodes += $tpcNode.InnerText
                        }
                        
                        # Extract TargetProduct/TargetProductCode(s)
                        $targetProducts = $patch.ChildNodes | Where-Object { $_.LocalName -eq "TargetProduct" }
                        foreach ($targetProduct in $targetProducts) {
                            $tpChildNodes = $targetProduct.ChildNodes | Where-Object { $_.LocalName -eq "TargetProductCode" }
                            foreach ($tpChild in $tpChildNodes) {
                                $productCodes += $tpChild.InnerText
                            }
                        }
                        
                        # Extract ObsoletedPatch entries
                        $obsoleteNodes = $patch.ChildNodes | Where-Object { $_.LocalName -eq "ObsoletedPatch" }
                        foreach ($obsoleteNode in $obsoleteNodes) {
                            $obsoletedPatches += $obsoleteNode.InnerText
                        }
                    }
                }
            }
        }
    }
    
    # Remove duplicates if requested
    if ($RemoveDuplicates) {
        $productCodes = @($productCodes | Select-Object -Unique)
    }
    
    # Remove version numbers from title if requested
    $cleanTitle = $title
    if ($RemoveVersionNumbers) {
        $cleanTitle = $cleanTitle -replace '\s+\d+\.\d+\.\d+', ''
    }
    
    # Only create entry if we have a title and product codes
    if ($cleanTitle -and $productCodes.Count -gt 0) {
        $updateObj = [PSCustomObject]@{
            Title               = $cleanTitle
            TargetProductCode   = $productCodes
            ObsoletedPatches    = $obsoletedPatches
        }
        
        $updates += $updateObj
    }
}

# Convert to JSON and save
$json = $updates | ConvertTo-Json -Depth 10
$json | Set-Content $JsonPath -Encoding UTF8

Write-Host "Conversion complete!"
Write-Host "  Source: $XmlPath"
Write-Host "  Destination: $JsonPath"
Write-Host "  Records: $($updates.Count)"
Write-Host "  Remove Duplicates: $RemoveDuplicates"
Write-Host "  Remove Version Numbers: $RemoveVersionNumbers"
