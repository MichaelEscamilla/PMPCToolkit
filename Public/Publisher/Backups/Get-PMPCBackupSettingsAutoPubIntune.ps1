<#
    .SYNOPSIS
    Retrieves Intune Auto-Publish settings from Patch My PC Publisher backup files.

    .DESCRIPTION
    This function extracts and displays the Intune Auto-Publish configuration settings from
    Patch My PC Publisher backup CAB files. It locates the restored backup folders and searches
    each Settings.xml file for Intune Auto-Publish application and update enrollment settings,
    including their enabled state and configured thresholds.

    .PARAMETER BackupFilesPath
    The path where the backup CAB files are located. Defaults to the current working directory.

    .PARAMETER BackupFolderName
    The name of the folder within the backup location where the restored CAB files will be saved.
    Defaults to "SettingsBackup-Restored".

    .EXAMPLE
    Get-PMPCBackupSettingsAutoPubIntune

    Searches the current directory for backup files and displays the Intune Auto-Publish settings.
#>
function Get-PMPCBackupSettingsAutoPubIntune {
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

    # Get Backup Restored Folders
    $BackupRestoredFoldersObject = Get-BackupRestoredFolders -BackupFilesPath $BackupFilesPath -BackupFolderName $BackupFolderName

    # Search for Intune Auto-Publish Settings in the backup settings files
    Search-BackupSettingsAutoPubIntune -SettingsFileObject $BackupRestoredFoldersObject
}