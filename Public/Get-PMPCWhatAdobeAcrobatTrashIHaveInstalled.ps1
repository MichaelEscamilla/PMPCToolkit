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
				Title             = $matchingEntry.Title
				MatchedProductCode = ($matchingEntry.TargetProductCode | Where-Object { $_ -match $ProductCode })
				TargetProductCode = $matchingEntry.TargetProductCode
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
						Title             = $matchingEntry.Title
						MatchedProductCode = ($matchingEntry.TargetProductCode | Where-Object { $_ -match $software.RegistryKey })
						TargetProductCode = $matchingEntry.TargetProductCode
					}
				}
			}
		}
		else {
			Write-Host "No Adobe Acrobat software found in CSV: $FilePath" -ForegroundColor Yellow
		}
	}
}