<#
.SYNOPSIS
Identifies installed Adobe Acrobat products and matches them against known Patch My PC MSP target product codes.

.DESCRIPTION
Reads a Patch My PC installed software CSV file or a product code and compares the results against the
bundled AdobeAcrobat.json reference data. Returns matching entries that include the MSP title,
the matched product code, and all associated target product codes.

.PARAMETER Path
One or more paths to Patch My PC installed software CSV files. Accepts pipeline input.
Each file is scanned for entries whose DisplayName contains 'Adobe Acrobat', and any matching
registry keys are looked up in AdobeAcrobat.json.

.PARAMETER ProductCode
A single product code (GUID) to look up directly in AdobeAcrobat.json without processing a CSV file.

.EXAMPLE
Get-PMPCWhatAdobeAcrobatTrashIHaveInstalled -Path "C:\Temp\InstalledSoftware.csv"

Processes the specified CSV file and outputs any Adobe Acrobat entries that match known MSP product codes.

.EXAMPLE
Get-PMPCWhatAdobeAcrobatTrashIHaveInstalled -ProductCode "{AC76BA86-1033-FFFF-7760-BC15014EA700}"

Looks up the specified product code directly in AdobeAcrobat.json and returns the matching MSP entry.
#>
function Get-PMPCWhatAdobeAcrobatTrashIHaveInstalled {
	[CmdletBinding(DefaultParameterSetName = 'Path')]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'Path')]
		[Alias('FullName')]
		[ValidateNotNullOrEmpty()]
		[string[]]$Path,

		[Parameter(Mandatory = $true, ParameterSetName = 'ProductCode')]
		[string]$ProductCode
	)

	# Compare the RegistryKey value against the Json AdobeAcrobat.json in the Private folder
	$AdobeAcrobatMSP = Get-Content -Path "$($MyInvocation.MyCommand.Module.ModuleBase)\Private\AdobeAcrobat.json" | ConvertFrom-Json

	if ($PSCmdlet.ParameterSetName -eq 'ProductCode') {
		$matchingEntry = $AdobeAcrobatMSP | Where-Object { $_.TargetProductCode -match $ProductCode }
		if ($matchingEntry) {
			[PSCustomObject]@{
				Title              = $matchingEntry.Title
				MatchedProductCode = ($matchingEntry.TargetProductCode | Where-Object { $_ -match $ProductCode })
				TargetProductCode  = $matchingEntry.TargetProductCode
			}
		}
		else {
			Write-Host "No match found in AdobeAcrobat.json for ProductCode: $ProductCode" -ForegroundColor Yellow
		}
		return
	}

	foreach ($FilePath in $Path) {
		Write-Host "Processing file: $FilePath" -ForegroundColor Cyan
		$InstSoftCSVAdobe = $null
		$InstSoftCSVAdobe = Import-PMPCInstalledSoftwareCsv -Path $FilePath |
		Where-Object {
			$DisplayName = if ($_.PSObject.Properties.Match('DisplayName').Count -gt 0) { $_.DisplayName } else { $_.Displayname }
			$DisplayName -match 'Adobe Acrobat'
		}

		if ($InstSoftCSVAdobe) {
			Write-Host "Found in CSV: Adobe Acrobat Software: " -NoNewline -ForegroundColor Red
			Write-Host ""
			Write-Host "$($InstSoftCSVAdobe | Select-Object DisplayName, DisplayVersion, RegistryKey | Out-String)" -ForegroundColor Red

			$matchingEntry = $null
			foreach ($software in $InstSoftCSVAdobe) {
				foreach ($PC in $AdobeAcrobatMSP.TargetProductCode) {

					if ($software.RegistryKey -match $PC) {
						$matchingEntry = $AdobeAcrobatMSP | Where-Object { $_.TargetProductCode -match "$($software.RegistryKey)" } | Select-Object Title, TargetProductCode | Format-Table
					}
					$matchingEntry = $AdobeAcrobatMSP | Where-Object { $_.TargetProductCode -match "$($software.RegistryKey)" }
				}
				if ($matchingEntry) {
					Write-Host "Match found for $($software.DisplayName) with RegistryKey: $($software.RegistryKey)" -ForegroundColor Green
					#$matchingEntry | Select-Object Title, @{Name='TargetProductCode';Expression={$_.TargetProductCode | Where-Object { $_ -match $software.RegistryKey }}} | Format-Table
					[PSCustomObject]@{
						Title              = $matchingEntry.Title
						MatchedProductCode = ($matchingEntry.TargetProductCode | Where-Object { $_ -match $software.RegistryKey })
						TargetProductCode  = $matchingEntry.TargetProductCode
					}
				}
			}
		}
		else {
			Write-Host "No Adobe Acrobat software found in CSV: $FilePath" -ForegroundColor Yellow
		}
	}
}