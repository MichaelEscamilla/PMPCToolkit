function Get-PMPCBackupSettings {
    # Build function metadata so Out-GridView can show a useful description.
    $functions = Get-ChildItem -Path $PSScriptRoot -Filter "*.ps1" |
        Where-Object { $_.Name -ne "Get-PMPCBackupSettings.ps1" } |
        ForEach-Object {
            $fileContent = Get-Content -Path $_.FullName -Raw
            $synopsisMatch = [regex]::Match(
                $fileContent,
                '(?ms)^\s*<#.*?^\s*\.SYNOPSIS\s*(.*?)^\s*\.(?:DESCRIPTION|PARAMETER|EXAMPLE|NOTES|OUTPUTS)'
            )

            [PSCustomObject]@{
                Name        = $_.BaseName
                Description = if ($synopsisMatch.Success) {
                    ($synopsisMatch.Groups[1].Value -split '\r?\n' | ForEach-Object { $_.Trim() } | Where-Object { $_ }) -join ' '
                } else {
                    'No description available.'
                }
                Path        = $_.FullName
            }
        }

    $selectedFunction = $functions |
        Select-Object Name, Description |
        Out-GridView -Title "Select a Backup Function" -OutputMode Single

    if ($selectedFunction) {
        # If a function is selected, execute it
        $functionPath = Join-Path -Path $PSScriptRoot -ChildPath "$($selectedFunction.Name).ps1"
        Write-Host "Executing function: $($selectedFunction.Name) - $($functionPath)"
       iex $($selectedFunction.Name)
    } else {
        Write-Host "No function selected. Exiting."
    }
}