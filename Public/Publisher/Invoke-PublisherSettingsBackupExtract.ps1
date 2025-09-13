############################
# This script extracts the all Settings Backup .cab files in the current directory
# and Restores them in a folder named "SettingsBackup-Restored" in the current directory.
############################

function Invoke-PublisherSettingsBackupExtract {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]
        # The path where the backup files are located. Default is the current directory.
        $BackupPath = "$(Get-Location)"
    )

    Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] Backup Path: [$BackupPath]"

    # Restore Folder Name
    $RestoreFolderName = "SettingsBackup-Restored"

    # Delete the $RestoreFolderName folder if it exists
    if (Test-Path -Path "$($BackupPath)\$($RestoreFolderName)") {
        Remove-Item -Path "$($BackupPath)\$($RestoreFolderName)" -Recurse -Force
    }

    # Create the $RestoreFolderName folder
    New-Item -Path "$($BackupPath)" -Name "$($RestoreFolderName)" -ItemType Directory

    # Get all the Settings Backup .cab files
    $SettingsBackupFiles = Get-ChildItem -Path $BackupPath -Filter "Settings*.cab"

    # Loop through each file and extract the contents to the $RestoreFolderName folder
    foreach ($File in $SettingsBackupFiles) {
        # Create a folder named the same as the backup file without the extension
        $FolderName = [System.IO.Path]::GetFileNameWithoutExtension($File.Name)

        # Define restore folder path
        $RestorePath = "$($BackupPath)\$($RestoreFolderName)\$FolderName"

        # Create the restore folder
        New-Item -Path $RestorePath -ItemType Directory

        # Extract the contents of the .cab file to the folder
        Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] Extracting $($File.Name) to $($RestorePath)"

        Start-Process -FilePath "C:\Windows\System32\expand.exe" -ArgumentList "-R -I -F:* `"$($File.FullName)`" `"$RestorePath`"" -WindowStyle Hidden
    }
}