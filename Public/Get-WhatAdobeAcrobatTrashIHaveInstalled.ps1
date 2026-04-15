function Get-WhatAdobeAcrobatTrashIHaveInstalled {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('FullName')]
		[ValidateNotNullOrEmpty()]
		[string[]]$Path
	)

	process {
		Import-PMPCInstalledSoftwareCsv -Path $Path |
			Where-Object {
				$DisplayName = if ($_.PSObject.Properties.Match('DisplayName').Count -gt 0) { $_.DisplayName } else { $_.Displayname }
				$DisplayName -match 'Adobe Acrobat'
			} |
			Select-Object @{
				Name = 'Displayname'
				Expression = {
					if ($_.PSObject.Properties.Match('Displayname').Count -gt 0) {
						$_.Displayname
					}
					else {
						$_.DisplayName
					}
				}
			}, @{
				Name = 'Displayversion'
				Expression = {
					if ($_.PSObject.Properties.Match('Displayversion').Count -gt 0) {
						$_.Displayversion
					}
					else {
						$_.DisplayVersion
					}
				}
			}, @{
				Name = 'RegistryKey'
				Expression = {
					if ($_.PSObject.Properties.Match('RegistryKey').Count -gt 0) {
						$_.RegistryKey
					}
					else {
						$_.Registrykey
					}
				}
			}
	}
}
