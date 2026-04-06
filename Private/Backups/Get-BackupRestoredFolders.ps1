function Get-BackupRestoredFolders {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]
        # The path where the backup files are located. Default is the current directory.
        $BackupFilesPath = "$(Get-Location)",

        [Parameter(Mandatory = $false)]
        [string]
        # The Folder in the backup location where the restored CAB files will be saved.
        $BackupFolderName = "SettingsBackup-Restored"
    )

    # Restore Folder Path
    $RestoreFolderPath = Join-Path -Path "$($BackupFilesPath)" -ChildPath "$($BackupFolderName)"
    Write-Verbose "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Restore Folder Path: [$RestoreFolderPath]"

    # Check if the Restore Folder Path exists, if not run Invoke-PMPCBackupSettingsExtract
    if (-not (Test-Path -Path $RestoreFolderPath)) {
        Write-Verbose "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Restore Folder Path does not exist. Running Invoke-PMPCBackupSettingsExtract..."
        Invoke-PMPCBackupSettingsExtract -BackupFilesPath $BackupFilesPath -BackupFolderName $BackupFolderName
    }

    # Get all Folders in the $RestoreFolderPath
    $RestoreFolders = Get-ChildItem -Path $RestoreFolderPath -Directory
    # Create and array to store folder object
    $RestoreFoldersObject = @()

    # Loop through each Folder and get the folder name
    foreach ($Folder in $RestoreFolders) {
        # Create a object to store the folder info
        $FolderInfo = [PSCustomObject]@{
            Name     = $Folder.Name
            FullName = $Folder.FullName
        }
        # Add the object to the $RestoreFoldersObject array
        $RestoreFoldersObject += $FolderInfo
    }

    # Add the $BackupFilesPath to the $RestoreFoldersObject as the last object in the array
    $BackupFilesPathObject = [PSCustomObject]@{
        Name     = "Current Settings File"
        FullName = $BackupFilesPath
    }
    $RestoreFoldersObject += $BackupFilesPathObject

    return $RestoreFoldersObject
}