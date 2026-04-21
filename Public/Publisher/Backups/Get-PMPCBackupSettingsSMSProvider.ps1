<#
    .SYNOPSIS
    Retrieves SMS Provider settings from Patch My PC Publisher backup files.

    .DESCRIPTION
    This function displays the SMS Provider configuration settings from extracted Patch My PC Publisher
    backup CAB files. It locates the restored backup folders and searches each Settings.xml file for
    SMS Provider settings used by ConfigMgr (Configuration Manager) integrations.

    .PARAMETER BackupFilesPath
    The path where the backup CAB files are located. Defaults to the current working directory.

    .PARAMETER BackupFolderName
    The name of the folder within the backup location where the restored CAB files will be saved.
    Defaults to "SettingsBackup-Restored".

    .EXAMPLE
    Get-PMPCBackupSettingsSMSProvider

    Searches the current directory for backup files and displays the SMS Provider settings.
#>
function Get-PMPCBackupSettingsSMSProvider {
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

    # Add the SMS Provider Search Results to the Backup Restored Folders Object
    foreach ($FolderInfo in $BackupRestoredFoldersObject) {
        $BackupResults = Search-BackupSettingsSMSProviderV2 -SettingsFilePath (Join-Path -Path $FolderInfo.FullName -ChildPath "Settings.xml")
        $FolderInfo | Add-Member -MemberType NoteProperty -Name "SMSProvider" -Value $BackupResults
    }

    & "$($MyInvocation.MyCommand.Module.ModuleBase)\GUI\Backups\SMSProviderBackupViewerUI.ps1" -TreeViewItems $BackupRestoredFoldersObject
}