<#
    .SYNOPSIS
    Extracts all Settings Backup .cab files and restores them to a folder.

    .DESCRIPTION
    This function extracts all Settings Backup .cab files in the specified directory
    and restores them in a folder named "SettingsBackup-Restored" in the current directory.

    .PARAMETER BackupFilesPath
    The path where the backup files are located. Default is the current directory.

    .PARAMETER BackupFolderName
    The name of the folder where the restored files will be saved. Default is "SettingsBackup-Restored".

    .EXAMPLE
    Invoke-PublisherSettingsBackupExtract

    .EXAMPLE
    Invoke-PublisherSettingsBackupExtract -BackupFilesPath "C:\Backups" -BackupFolderName "Restored-Backups"

    .NOTES
    Requires Windows expand.exe utility.
#>

function Invoke-PMPCPublisherSettingsBackupExtract {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]
        # The path where the backup files are located. Default is the current directory.
        $BackupFilesPath = "$(Get-Location)",

        [Parameter(Mandatory = $false)]
        [string]
        # The path where the restored files will be saved. Default is the current directory.
        $BackupFolderName = "SettingsBackup-Restored"
    )

    # Restore Folder Path
    $RestoreFolderPath = Join-Path -Path "$($BackupFilesPath)" -ChildPath "$($BackupFolderName)"
    Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Restore Folder Path: [$RestoreFolderPath]"

    # Delete the $RestoreFolderName folder if it exists
    Remove-Item -Path "$($RestoreFolderPath)" -Recurse -Force -ErrorAction SilentlyContinue

    # Create $RestoreFolderPath
    try {
        # Create the Destination
        $null = New-Item -Path $RestoreFolderPath -ItemType Directory -Force -ErrorAction Stop
    }
    catch {
        Write-Host -ForegroundColor Red "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Failed to create folder: [$RestoreFolderPath]"
        return
    }

    # Get all the Settings Backup .cab files in the $BackupFilesPath
    $SettingsBackupCABFiles = Get-ChildItem -Path $BackupFilesPath -Filter "Settings*.cab"

    # Loop through each CAB file and Extract to a folder named the same as the CAB file
    # Extract to the $RestoreFolderName folder
    foreach ($File in $SettingsBackupCABFiles) {

        try {
            $FolderName = [System.IO.Path]::GetFileNameWithoutExtension($File.Name)
            $RestorePath = "$($RestoreFolderPath)\$FolderName"
            $null = New-Item -Path $RestorePath -ItemType Directory -ErrorAction Stop
        }
        catch {
            Write-Host -ForegroundColor Red "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Failed to create folder: [$RestorePath]"
            break
        }

        try {
            # Extract the contents of the .cab file to the folder
            Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] Extracting: [$($File.Name)]"

            Start-Process -FilePath "C:\Windows\System32\expand.exe" -ArgumentList "-R -F:* `"$($File.FullName)`" `"$RestorePath`"" -WindowStyle Hidden
        }
        catch {
            Write-Host -ForegroundColor Red "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Failed to extract: [$($File)]"
            break
        }
    }
}