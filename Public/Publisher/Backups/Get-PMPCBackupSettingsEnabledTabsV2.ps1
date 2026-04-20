<#
    .SYNOPSIS
    GUI - Retrieves enabled tab settings from Patch My PC Publisher backup files and displays them in a GUI.

    .DESCRIPTION
    This function displays enabled tab configuration settings from extracted Patch My PC Publisher
    backup CAB files. It locates the restored backup folders, searches each Settings.xml file for
    enabled tabs and their product counts, and opens a graphical interface displaying the results
    in a list view for easy review.

    .PARAMETER BackupFilesPath
    The path where the backup CAB files are located. Defaults to the current working directory.

    .PARAMETER BackupFolderName
    The name of the folder within the backup location where the restored CAB files will be saved.
    Defaults to "SettingsBackup-Restored".

    .EXAMPLE
    Get-PMPCBackupSettingsEnabledTabsV2

    Searches the current directory for backup files and opens the Enabled Tabs settings GUI.
#>
function Get-PMPCBackupSettingsEnabledTabsV2 {
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

    # Add the Enabled Tabs Search Results to the Backup Restored Folders Object
    foreach ($FolderInfo in $BackupRestoredFoldersObject) {
        $EnabledTabsResults = Search-BackupSettingsEnabledTabsV2 -SettingsFilePath (Join-Path -Path $FolderInfo.FullName -ChildPath "Settings.xml")
        $FolderInfo | Add-Member -MemberType NoteProperty -Name "Items" -Value $EnabledTabsResults
    }

    & "$($MyInvocation.MyCommand.Module.ModuleBase)\GUI\Backups\BackupSettingsEnabledTabsUI.ps1" -TreeViewItems $BackupRestoredFoldersObject
}
