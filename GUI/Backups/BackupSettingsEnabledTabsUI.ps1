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
        Title="Enabled Tabs Backup Viewer"
        Height="840" Width="1204"
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

            <!-- Top blue info banner -->
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
                            Text="Enabled Tabs Backup Viewer — Review enabled tabs and product counts from Publisher backup files."/>
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

                <GroupBox Grid.Column="0" Header="Backup Folders" Padding="8">
                    <TreeView Name="TreeBackupFolders"
                              BorderBrush="#D2D2D2"
                              BorderThickness="1"
                              Background="White"/>
                </GroupBox>

                <Grid Grid.Column="2">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="8"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>

                    <!-- Selected Backup Folder -->
                    <GroupBox Grid.Row="0" Padding="8" Header="Selected Backup">
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

                    <!-- Enabled Tabs Details -->
                    <GroupBox Grid.Row="2" Header="Enabled Tabs" Padding="8">
                        <ListView Name="LvwEnabledTabs"
                                  BorderBrush="#D2D2D2"
                                  BorderThickness="1"
                                  Background="White"
                                  ScrollViewer.VerticalScrollBarVisibility="Auto"
                                  ScrollViewer.HorizontalScrollBarVisibility="Auto">
                            <ListView.View>
                                <GridView>
                                    <GridViewColumn Header="Tab Name" Width="220" DisplayMemberBinding="{Binding Name}"/>
                                    <GridViewColumn Header="Enabled" Width="100">
                                        <GridViewColumn.CellTemplate>
                                            <DataTemplate>
                                                <TextBlock Text="{Binding Enabled}" FontWeight="Bold">
                                                    <TextBlock.Style>
                                                        <Style TargetType="TextBlock">
                                                            <Style.Triggers>
                                                                <DataTrigger Binding="{Binding Enabled}" Value="True">
                                                                    <Setter Property="Foreground" Value="#2E7D32"/>
                                                                </DataTrigger>
                                                                <DataTrigger Binding="{Binding Enabled}" Value="False">
                                                                    <Setter Property="Foreground" Value="#C62828"/>
                                                                </DataTrigger>
                                                                <DataTrigger Binding="{Binding Enabled}" Value="N/A">
                                                                    <Setter Property="Foreground" Value="#F9A825"/>
                                                                </DataTrigger>
                                                            </Style.Triggers>
                                                        </Style>
                                                    </TextBlock.Style>
                                                </TextBlock>
                                            </DataTemplate>
                                        </GridViewColumn.CellTemplate>
                                    </GridViewColumn>
                                    <GridViewColumn Header="Product Count" Width="120" DisplayMemberBinding="{Binding EnabledProductCount}"/>
                                </GridView>
                            </ListView.View>
                        </ListView>
                    </GroupBox>
                </Grid>
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
[System.Windows.Window]$formProperties = [Windows.Markup.XamlReader]::Load($reader)

# Create Variables for all the controls in the XAML form
$xaml.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name ($_.Name) -Value $formProperties.FindName($_.Name) -Scope Global }


function ConvertTo-BackupComparisonState {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [object[]]
        $Items
    )

    return ConvertTo-Json -InputObject @($Items) -Depth 10 -Compress
}

function Get-BackupChangeInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [object[]]
        $CurrentItems,

        [Parameter(Mandatory = $false)]
        [AllowNull()]
        [object[]]
        $PreviousItems
    )

    if (-not $PreviousItems) {
        return [PSCustomObject]@{
            HasChanges = $false
            Summary    = 'Baseline backup'
        }
    }

    $currentState = ConvertTo-BackupComparisonState -Items $CurrentItems
    $previousState = ConvertTo-BackupComparisonState -Items $PreviousItems

    $hasChanges = ($previousState -ne $currentState)

    return [PSCustomObject]@{
        HasChanges = $hasChanges
        Summary    = if ($hasChanges) { 'Changes detected' } else { 'No changes' }
    }
}

function Set-BackupTreeNodeHighlight {
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

    $tooltipLines = @(
        [string]$FolderData.FullName
    )

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

function Update-TreeView {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $ObjectData,

        [string]
        $HeaderRoot = "Backups"
    )

    # Check for a null value
    if (-not $ObjectData) {
        return
    }
    # Clear the TreeView
    $TreeBackupFolders.Items.Clear()

    # Add the root node
    $TreeViewItem_Parent = New-Object System.Windows.Controls.TreeViewItem
    $TreeViewItem_Parent.Header = "$($HeaderRoot)"

    $previousBackup = $null

    $ObjectData | ForEach-Object {
        # Add each restore folder as a top-level node
        $TreeViewItem_Folder = New-Object System.Windows.Controls.TreeViewItem
        $TreeViewItem_Folder.Header = $_.Name
        $TreeViewItem_Folder.Tag = $_

        $changeInfo = Get-BackupChangeInfo -CurrentItems @($_.Items) -PreviousItems $(if ($previousBackup) { @($previousBackup.Items) } else { $null })
        Set-BackupTreeNodeHighlight -TreeViewItem $TreeViewItem_Folder -FolderData $_ -ChangeInfo $changeInfo -PreviousBackupName $previousBackup.Name

        $TreeViewItem_Parent.Items.Add($TreeViewItem_Folder)
        $previousBackup = $_
    }

    $TreeBackupFolders.Items.Add($TreeViewItem_Parent)
    # Expand the root item in the TreeView for better visibility
    $TreeViewItem_Parent.IsExpanded = $true
}

function Clear-SelectedFolder {
    $TxtSelectedFolder.Text = ""
    $TxtSelectedFolderPath.Text = ""
    $BtnOpenFolder.IsEnabled = $false
}

function Set-SelectedFolder {
    param (
        [Parameter(Mandatory = $true)]
        $SelectedNode
    )
    $TxtSelectedFolder.Text = "$($SelectedNode.Tag.Name)"
    $TxtSelectedFolderPath.Text = "$($SelectedNode.Tag.FullName)"
    $BtnOpenFolder.IsEnabled = $true
}

function Clear-EnabledTabsDetails {
    $LvwEnabledTabs.Items.Clear()
}

function Set-EnabledTabsDetails {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $TabItems
    )

    Clear-EnabledTabsDetails

    foreach ($Tab in $TabItems) {
        $item = [PSCustomObject]@{
            Name                = $Tab.Name
            Enabled             = $Tab.Enabled
            EnabledProductCount = $Tab.EnabledProductCount
        }
        $LvwEnabledTabs.Items.Add($item)
    }
}

#### Form Load #####
$formProperties.Add_Loaded({
        # Update the TreeView
        Update-TreeView -ObjectData $TreeViewItems
    })

$TreeBackupFolders.Add_SelectedItemChanged({
        $SelectedNode = $TreeBackupFolders.SelectedItem

        # If no node is selected, clear everything
        if (-not $SelectedNode) {
            Clear-EnabledTabsDetails
            Clear-SelectedFolder
            return
        }
        # If the selected node doesn't have a Tag property, clear everything
        elseif (-not $SelectedNode.Tag) {
            Clear-EnabledTabsDetails
            Clear-SelectedFolder
            return
        }

        # Set the Backup Folder info and populate the enabled tabs list
        Set-SelectedFolder -SelectedNode $SelectedNode
        Set-EnabledTabsDetails -TabItems @($SelectedNode.Tag.Items)
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
        $formProperties.Close()
    })
$BtnClose.Add_Click({
        $formProperties.Close()
    })
$TopBanner.Add_MouseLeftButtonDown({
        $formProperties.DragMove()
    })

$null = $formProperties.ShowDialog()
