param (
    [Parameter(Mandatory = $false)]
    $TreeViewItems
)

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="SMS Provider Backup Viewer"
        Height="640" Width="960"
        WindowStartupLocation="CenterScreen"
        WindowStyle="None"
        ResizeMode="NoResize"
        Background="Transparent"
        AllowsTransparency="True"
        FontFamily="Segoe UI"
        FontSize="12"
        SnapsToDevicePixels="True"
        UseLayoutRounding="True">
    <Window.Resources>
        <Style TargetType="TextBox">
            <Setter Property="Height" Value="24"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Setter Property="Padding" Value="4,0,4,0"/>
            <Setter Property="BorderBrush" Value="#ABADB3"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Background" Value="White"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="IsReadOnly" Value="True"/>
        </Style>
        <Style TargetType="Button">
            <Setter Property="Height" Value="24"/>
            <Setter Property="MinWidth" Value="24"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Padding" Value="8,1,8,1"/>
        </Style>
        <Style TargetType="CheckBox">
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Margin" Value="0,2,0,2"/>
            <Setter Property="IsEnabled" Value="False"/>
        </Style>
        <Style TargetType="GroupBox">
            <Setter Property="Margin" Value="0"/>
            <Setter Property="Padding" Value="8"/>
            <Setter Property="FontSize" Value="12"/>
        </Style>
    </Window.Resources>
    <Border Margin="0"
            CornerRadius="10"
            Background="#F0F0F0"
            BorderBrush="#D8D8D8"
            BorderThickness="1"
            SnapsToDevicePixels="True">
        <Grid Margin="0">
            <Grid.RowDefinitions>
                <RowDefinition Height="36"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="44"/>
            </Grid.RowDefinitions>

            <!-- Top blue banner -->
            <Border Grid.Row="0" Name="TopBanner" Background="#1976C9" CornerRadius="10,10,0,0">
                <Grid Margin="10,0,10,0">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="24"/>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>
                    <TextBlock Grid.Column="0"
                               Text="?"
                               Foreground="#EAF5FF"
                               FontWeight="Bold"
                               HorizontalAlignment="Center"
                               VerticalAlignment="Center"/>
                    <TextBlock Grid.Column="1"
                               VerticalAlignment="Center"
                               Margin="8,0,0,0"
                               Foreground="White"
                               FontSize="12"
                               Text="SMS Provider Backup Viewer — Review SMS Provider connection settings from Publisher backup files."/>
                    <Button Grid.Column="2"
                            Name="BtnCloseBanner"
                            Content="X"
                            Width="22"
                            Height="22"
                            Padding="0"
                            HorizontalAlignment="Right"
                            VerticalAlignment="Center"
                            Background="#1976C9"
                            Foreground="White"
                            BorderBrush="#4D8DC9"/>
                </Grid>
            </Border>

            <!-- Main content -->
            <Grid Grid.Row="1" Margin="10,8,10,8">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="286"/>
                    <ColumnDefinition Width="10"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <!-- Left: Backup Folders tree -->
                <GroupBox Grid.Column="0" Header="Backup Folders" Padding="8">
                    <TreeView Name="TreeBackupFolders"
                              BorderBrush="#D2D2D2"
                              BorderThickness="1"
                              Background="White"/>
                </GroupBox>

                <!-- Right: SMS Provider details panel -->
                <ScrollViewer Grid.Column="2"
                              VerticalScrollBarVisibility="Auto"
                              HorizontalScrollBarVisibility="Disabled">
                    <StackPanel Margin="0">

                        <!-- Selected Backup Folder -->
                        <GroupBox Margin="0,0,0,8" Padding="8" Header="Selected Backup Folder">
                            <Grid>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="6"/>
                                    <RowDefinition Height="Auto"/>
                                </Grid.RowDefinitions>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="96"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="8"/>
                                    <ColumnDefinition Width="108"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Row="0" Grid.Column="0" Text="Backup Folder" VerticalAlignment="Center"/>
                                <TextBox Grid.Row="0" Grid.Column="1" Name="TxtSelectedFolder"/>

                                <TextBlock Grid.Row="2" Grid.Column="0" Text="Folder Path" VerticalAlignment="Center"/>
                                <TextBox Grid.Row="2" Grid.Column="1" Name="TxtSelectedFolderPath"/>
                                <Button Grid.Row="2" Grid.Column="3" Name="BtnOpenFolder" Content="Open Folder" IsEnabled="False"/>
                            </Grid>
                        </GroupBox>

                        <!-- Connection Settings -->
                        <GroupBox Padding="8" Header="Connection Settings">
                            <StackPanel>

                                <!-- SMS Provider Server Name -->
                                <TextBlock Text="SMS Provider Server Name:" Margin="0,0,0,4"/>
                                <TextBox Name="TxtSMSProviderServer" Margin="0,0,0,10"/>

                                <!-- Use Alternate Credentials -->
                                <CheckBox Name="ChkUseAltCredentials"
                                          Content="Use alternate credentials to connect to the SMS Provider"
                                          Margin="0,0,0,10"/>

                                <!-- User Name -->
                                <TextBlock Text="User Name:" Margin="0,0,0,4"/>
                                <TextBox Name="TxtUsername" Margin="0,0,0,10"/>

                                <!-- Password -->
                                <TextBlock Text="Password:" Margin="0,0,0,4"/>
                                <TextBox Name="TxtPassword" Margin="0,0,0,10"/>

                            </StackPanel>
                        </GroupBox>

                    </StackPanel>
                </ScrollViewer>
            </Grid>

            <!-- Bottom buttons -->
            <Grid Grid.Row="2" Margin="10,0,10,8">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="108"/>
                </Grid.ColumnDefinitions>
                <Button Grid.Column="1" Name="BtnClose" Content="Close" Height="24"/>
            </Grid>
        </Grid>
    </Border>
</Window>
"@

# Create a new XML node reader for reading the XAML content
$reader = New-Object System.Xml.XmlNodeReader $xaml

# Load the XAML content into a WPF window object using the XAML reader
[System.Windows.Window]$formSMSProvider = [Windows.Markup.XamlReader]::Load($reader)

# Create Variables for all the controls in the XAML form
$xaml.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name ($_.Name) -Value $formSMSProvider.FindName($_.Name) -Scope Global }


function ConvertTo-SMSProviderComparisonState {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [AllowNull()]
        [object]
        $Item
    )

    return ConvertTo-Json -InputObject $Item -Depth 5 -Compress
}

function Get-SMSProviderChangeInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [AllowNull()]
        [object]
        $CurrentItem,

        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [object]
        $PreviousItem
    )

    if (-not $PreviousItem) {
        return [PSCustomObject]@{
            HasChanges = $false
            Summary    = 'Baseline backup'
        }
    }

    $currentState  = ConvertTo-SMSProviderComparisonState -Item $CurrentItem
    $previousState = ConvertTo-SMSProviderComparisonState -Item $PreviousItem

    $hasChanges = ($previousState -ne $currentState)

    return [PSCustomObject]@{
        HasChanges = $hasChanges
        Summary    = if ($hasChanges) { 'Changes detected' } else { 'No changes' }
    }
}

function Set-SMSProviderNodeHighlight {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $TreeViewItem,

        [Parameter(Mandatory = $true)]
        $FolderData,

        [Parameter(Mandatory = $true)]
        $ChangeInfo,

        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [string]
        $PreviousBackupName
    )

    $tooltipLines = @([string]$FolderData.FullName)

    if ([string]::IsNullOrWhiteSpace($PreviousBackupName)) {
        $tooltipLines += 'Baseline backup'
    }
    else {
        $tooltipLines += "Compared to: $PreviousBackupName"
        $tooltipLines += "Changes: $($ChangeInfo.Summary)"
    }

    $TreeViewItem.ToolTip = $tooltipLines -join [Environment]::NewLine

    if (-not $ChangeInfo.HasChanges) {
        return
    }

    $TreeViewItem.Background = [System.Windows.Media.Brushes]::LightGoldenrodYellow
}

function Update-SMSProviderTreeView {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $ObjectData,

        [string]
        $HeaderRoot = "Backups"
    )

    if (-not $ObjectData) {
        return
    }

    $TreeBackupFolders.Items.Clear()

    $TreeViewItem_Parent = New-Object System.Windows.Controls.TreeViewItem
    $TreeViewItem_Parent.Header = $HeaderRoot

    $previousBackup = $null

    foreach ($Object in $ObjectData) {
        $TreeViewItem_Folder = New-Object System.Windows.Controls.TreeViewItem
        $TreeViewItem_Folder.Header = $Object.Name
        $TreeViewItem_Folder.Tag = $Object

        $ChangeInfo = Get-SMSProviderChangeInfo -CurrentItem $Object.SMSProvider -PreviousItem $previousBackup.SMSProvider
        Set-SMSProviderNodeHighlight -TreeViewItem $TreeViewItem_Folder -FolderData $Object -ChangeInfo $ChangeInfo -PreviousBackupName $previousBackup.Name

        $TreeViewItem_Parent.Items.Add($TreeViewItem_Folder)
        $previousBackup = $Object
    }

    $TreeBackupFolders.Items.Add($TreeViewItem_Parent)
    $TreeViewItem_Parent.IsExpanded = $true
}

function Clear-SMSProviderDetails {
    $TxtSMSProviderServer.Text    = ""
    $ChkUseAltCredentials.IsChecked = $false
    $TxtUsername.Text             = ""
    $TxtPassword.Text             = ""
}

function Set-SMSProviderDetails {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $SMSProviderData
    )

    Clear-SMSProviderDetails

    $TxtSMSProviderServer.Text      = "$($SMSProviderData.SMSProviderServer)"
    $ChkUseAltCredentials.IsChecked = $SMSProviderData.UseAltCredentials -eq "True"
    $TxtUsername.Text               = "$($SMSProviderData.Username)"
    $TxtPassword.Text               = "$($SMSProviderData.Password)"
}

function Clear-SelectedFolder {
    $TxtSelectedFolder.Text     = ""
    $TxtSelectedFolderPath.Text = ""
    $BtnOpenFolder.IsEnabled    = $false
}

function Set-SelectedFolder {
    param (
        [Parameter(Mandatory = $true)]
        $SelectedNode
    )

    $TxtSelectedFolder.Text     = "$($SelectedNode.Tag.Name)"
    $TxtSelectedFolderPath.Text = "$($SelectedNode.Tag.FullName)"
    $BtnOpenFolder.IsEnabled    = $true
}


#### Form Load #####
$formSMSProvider.Add_Loaded({
        Update-SMSProviderTreeView -ObjectData $TreeViewItems
    })

$TreeBackupFolders.Add_SelectedItemChanged({
        $SelectedNode = $TreeBackupFolders.SelectedItem

        if (-not $SelectedNode -or -not $SelectedNode.Tag) {
            Clear-SMSProviderDetails
            Clear-SelectedFolder
            return
        }

        Set-SelectedFolder -SelectedNode $SelectedNode
        Set-SMSProviderDetails -SMSProviderData $SelectedNode.Tag.SMSProvider
    })

$BtnOpenFolder.Add_Click({
        if (-not [string]::IsNullOrWhiteSpace($TxtSelectedFolderPath.Text) -and (Test-Path -LiteralPath $TxtSelectedFolderPath.Text)) {
            try {
                Start-Process -FilePath "explorer.exe" -ArgumentList "/select,`"$($TxtSelectedFolderPath.Text)\Settings.xml`""
                Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] Successfully Opened: [$($TxtSelectedFolderPath.Text)]"
            }
            catch {
                Write-Host "Failed to open the backup folder in File Explorer"
                Write-Error "$($_.Exception.Message)"
            }
        }
    })

$BtnCloseBanner.Add_Click({
        $formSMSProvider.Close()
    })
$BtnClose.Add_Click({
        $formSMSProvider.Close()
    })
$TopBanner.Add_MouseLeftButtonDown({
        $formSMSProvider.DragMove()
    })

$null = $formSMSProvider.ShowDialog()
