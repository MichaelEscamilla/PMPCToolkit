function Get-PMPCBackupSettingsPrePostScripts {
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
<#
    # Restore Folder Path
    $RestoreFolderPath = Join-Path -Path "$($BackupFilesPath)" -ChildPath "$($BackupFolderName)"
    Write-Verbose "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Restore Folder Path: [$RestoreFolderPath]"

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
            Items    = @(
                Search-BackupSettingsWithPrePostScripts -SettingsFilePath $($Folder.FullName + "\Settings.xml")
            )
        }
        # Add the object to the $RestoreFoldersObject array
        $RestoreFoldersObject += $FolderInfo
    }
#>
    # Get Backup Restored Folders
    $BackupRestoredFoldersObject = Get-BackupRestoredFolders -BackupFilesPath $BackupFilesPath -BackupFolderName $BackupFolderName

    # Add the Pre/Post Script Search Results to the Backup Restored Folders Object
    foreach ($FolderInfo in $BackupRestoredFoldersObject) {
        $PrePostScriptResults = Search-BackupSettingsWithPrePostScripts -SettingsFilePath (Join-Path -Path $FolderInfo.FullName -ChildPath "Settings.xml")
        $FolderInfo | Add-Member -MemberType NoteProperty -Name "Items" -Value $PrePostScriptResults
    }
    
    & "$($MyInvocation.MyCommand.Module.ModuleBase)\GUI\Backups\SearchBackupSettingswithPrePostScriptUI.ps1" -TreeViewItems $BackupRestoredFoldersObject
}