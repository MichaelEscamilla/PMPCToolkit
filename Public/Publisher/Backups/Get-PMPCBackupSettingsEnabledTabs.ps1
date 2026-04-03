
<#
.SYNOPSIS
Retrieves the enabled tabs from backup settings files.

.DESCRIPTION
This function retrieves enabled tabs from settings backup files by scanning the restore folder structure.
It searches through restored CAB file directories and extracts enabled tab information from Settings.xml files.

.PARAMETER BackupFilesPath
The path where the backup files are located. Default is the current directory.

.PARAMETER BackupFolderName
The folder name in the backup location where the restored CAB files are saved. Default is 'SettingsBackup-Restored'.

.OUTPUTS
PSCustomObject
Returns custom objects containing folder names, paths, and enabled tab items found in the backup settings.

.EXAMPLE
Get-BackupSettingsEnabledTabs -BackupFilesPath "C:\Backups" -BackupFolderName "SettingsBackup-Restored"

.NOTES
Requires the Search-BackupSettingsWithPrePostScripts and Search-BackupSettingsEnabledTabs functions.

#>
function Get-PMPCBackupSettingsEnabledTabs {
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

    # Search for enabled tabs in the backup settings files
    Search-BackupSettingsEnabledTabs -SettingsFileObject $BackupRestoredFoldersObject
}