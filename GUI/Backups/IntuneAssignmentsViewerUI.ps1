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
        Title="Intune Assignments Viewer"
        Height="740" Width="1675"
        WindowStartupLocation="CenterScreen"
        WindowStyle="None"
        ResizeMode="NoResize"
        Background="Transparent"
        AllowsTransparency="True"
        FontFamily="Segoe UI"
        FontSize="12"
        SnapsToDevicePixels="True"
        UseLayoutRounding="True">
    <!-- ==================== Window Resources / Styles ==================== -->
    <Window.Resources>
        <Style TargetType="Button">
            <Setter Property="Height" Value="24"/>
            <Setter Property="MinWidth" Value="24"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Padding" Value="8,1,8,1"/>
        </Style>
        <Style TargetType="GroupBox">
            <Setter Property="Padding" Value="8"/>
            <Setter Property="FontSize" Value="12"/>
        </Style>
        <Style TargetType="DataGrid">
            <Setter Property="AutoGenerateColumns" Value="False"/>
            <Setter Property="CanUserAddRows" Value="False"/>
            <Setter Property="CanUserDeleteRows" Value="False"/>
            <Setter Property="CanUserResizeRows" Value="False"/>
            <Setter Property="HeadersVisibility" Value="Column"/>
            <Setter Property="GridLinesVisibility" Value="All"/>
            <Setter Property="IsReadOnly" Value="True"/>
            <Setter Property="Background" Value="White"/>
            <Setter Property="BorderBrush" Value="#D2D2D2"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="RowHeaderWidth" Value="0"/>
            <Setter Property="SelectionMode" Value="Single"/>
            <Setter Property="SelectionUnit" Value="FullRow"/>
        </Style>
        <Style TargetType="CheckBox">
            <Setter Property="FontSize" Value="12"/>
        </Style>
    </Window.Resources>

    <!-- ==================== Outer Rounded Border ==================== -->
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

            <!-- ==================== Top Blue Banner ==================== -->
            <Border Grid.Row="0" Name="TopBanner" Background="#1976C9" CornerRadius="10,10,0,0">
                <Grid Margin="10,0,8,0">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="24"/>
                    </Grid.ColumnDefinitions>
                    <TextBlock Grid.Column="0"
                               VerticalAlignment="Center"
                               Foreground="White"
                               FontSize="18"
                               FontWeight="SemiBold"
                               Text="Intune Assignments"/>
                    <Button Grid.Column="1"
                            Name="BtnClose"
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

            <!-- ==================== Main Content (Two-Column Layout) ==================== -->
            <Grid Grid.Row="1" Grid.RowSpan="2" Margin="10,8,10,8">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="300"/>
                    <ColumnDefinition Width="10"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <!-- Left: Backup / Tenant tree -->
                <GroupBox Grid.Column="0" Header="Intune Tenants" Padding="8">
                    <TreeView Name="TreeBackupFolders"
                              BorderBrush="#D2D2D2"
                              BorderThickness="1"
                              Background="White"/>
                </GroupBox>

                <!-- Right: Assignment details panels -->
                <StackPanel Grid.Column="2" Margin="0">

                    <!-- Selected Backup Folder -->
                    <GroupBox Margin="0,0,0,0" Header="Selected Backup Folder">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="24"/>
                                <RowDefinition Height="6"/>
                                <RowDefinition Height="24"/>
                            </Grid.RowDefinitions>
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="96"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="8"/>
                                <ColumnDefinition Width="108"/>
                            </Grid.ColumnDefinitions>
                            <TextBlock Grid.Row="0" Grid.Column="0" Text="Backup Folder" VerticalAlignment="Center"/>
                            <TextBox Grid.Row="0" Grid.Column="1" Name="TxtSelectedFolder" VerticalAlignment="Center"/>

                            <TextBlock Grid.Row="2" Grid.Column="0" Text="Folder Path" VerticalAlignment="Center"/>
                            <TextBox Grid.Row="2" Grid.Column="1" Name="TxtSelectedFolderPath" VerticalAlignment="Center"/>
                            <Button Grid.Row="2" Grid.Column="3" Name="BtnOpenFolder" Content="Open Folder" IsEnabled="False"/>
                        </Grid>
                    </GroupBox>

                    <!-- Required Assignments: auto-installed on enrolled devices -->
                    <GroupBox Margin="0,0,0,0" Header="Required for enrolled devices">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="125"/>
                            </Grid.RowDefinitions>
                            <DataGrid Grid.Row="0" Name="DgRequiredAssignments">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Group Name" Width="160" Binding="{Binding GroupName}"/>
                                    <DataGridTextColumn Header="Mode" Width="80" Binding="{Binding Mode}"/>
                                    <DataGridTextColumn Header="Notification" Width="95" Binding="{Binding Notification}"/>
                                    <DataGridTextColumn Header="DO Priority" Width="90" Binding="{Binding DOPriority}"/>
                                    <DataGridTextColumn Header="Filter Mode" Width="95" Binding="{Binding FilterType}"/>
                                    <DataGridTextColumn Header="Filter" Width="160" Binding="{Binding FilterId}"/>
                                    <DataGridTextColumn Header="Available Time" Width="110" Binding="{Binding AvailableTime}"/>
                                    <DataGridTextColumn Header="Deadline" Width="95" Binding="{Binding Deadline}"/>
                                    <DataGridTextColumn Header="Grace Period" Width="95" Binding="{Binding GracePeriod}"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Grid>
                    </GroupBox>

                    <!-- Available Assignments: visible in Company Portal but not forced -->
                    <GroupBox Margin="0,0,0,0" Header="Available for enrolled devices">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="125"/>
                            </Grid.RowDefinitions>
                            <DataGrid Grid.Row="0" Name="DgAvailableAssignments">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Group Name" Width="160" Binding="{Binding GroupName}"/>
                                    <DataGridTextColumn Header="Mode" Width="80" Binding="{Binding Mode}"/>
                                    <DataGridTextColumn Header="Notification" Width="95" Binding="{Binding Notification}"/>
                                    <DataGridTextColumn Header="DO Priority" Width="90" Binding="{Binding DOPriority}"/>
                                    <DataGridTextColumn Header="Filter Mode" Width="95" Binding="{Binding FilterType}"/>
                                    <DataGridTextColumn Header="Filter" Width="160" Binding="{Binding FilterId}"/>
                                    <DataGridTextColumn Header="Available Time" Width="110" Binding="{Binding AvailableTime}"/>
                                    <DataGridTextColumn Header="Grace Period" Width="95" Binding="{Binding GracePeriod}"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Grid>
                    </GroupBox>

                    <!-- Uninstall Assignments: automatically removed from devices -->
                    <GroupBox Margin="0,0,0,0" Header="Uninstall for enrolled devices">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="125"/>
                            </Grid.RowDefinitions>
                            <DataGrid Grid.Row="0" Name="DgUninstallAssignments">
                                <DataGrid.Columns>
                                    <DataGridTextColumn Header="Group Name" Width="160" Binding="{Binding GroupName}"/>
                                    <DataGridTextColumn Header="Mode" Width="80" Binding="{Binding Mode}"/>
                                    <DataGridTextColumn Header="Notification" Width="95" Binding="{Binding Notification}"/>
                                    <DataGridTextColumn Header="DO Priority" Width="90" Binding="{Binding DOPriority}"/>
                                    <DataGridTextColumn Header="Filter Mode" Width="95" Binding="{Binding FilterType}"/>
                                    <DataGridTextColumn Header="Filter" Width="160" Binding="{Binding FilterId}"/>
                                    <DataGridTextColumn Header="Deadline" Width="110" Binding="{Binding Deadline}"/>
                                    <DataGridTextColumn Header="Grace Period" Width="95" Binding="{Binding GracePeriod}"/>
                                </DataGrid.Columns>
                            </DataGrid>
                        </Grid>
                    </GroupBox>

                    <!-- Note: Override checkbox for manual assignment sync behaviour -->
                    <GroupBox Margin="0,0,0,0" Header="Note">
                        <StackPanel>
                            <CheckBox Name="ChkOverrideManualAssignments"
                                      IsEnabled="False"
                                      Margin="0,0,0,0"
                                      Content="Override manual assignment changes made in Intune during the synchronization of the Publisher"/>
                        </StackPanel>
                    </GroupBox>
                </StackPanel>
            </Grid>

            <!-- ==================== Footer Buttons ==================== -->
            <Grid Grid.Row="2" Margin="10,0,10,8">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="72"/>
                    <ColumnDefinition Width="8"/>
                    <ColumnDefinition Width="72"/>
                </Grid.ColumnDefinitions>
                <Button Grid.Column="3" Name="BtnOk" Content="OK" Width="72"/>
            </Grid>
        </Grid>
    </Border>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
[System.Windows.Window]$formIntuneAssignments = [Windows.Markup.XamlReader]::Load($reader)

$xaml.SelectNodes('//*[@Name]') | ForEach-Object {
    Set-Variable -Name $_.Name -Value $formIntuneAssignments.FindName($_.Name) -Scope Script
}

function ConvertTo-ComparisonState {
    param (
        [object[]]$Items
    )
    $lines = foreach ($backup in @($Items)) {
        foreach ($tenant in @($backup.Tenants)) {
            foreach ($node in @($tenant.ProductList)) {
                foreach ($product in @($node.Products)) {
                    foreach ($assignment in @($product.Assignments)) {
                        foreach ($row in @($assignment.Assignment)) {
                            "$($tenant.Name)|$($node.Name)|$($product.ProductName)|$($product.EnforceIntuneAssignments)|$($assignment.Intent)|$($row.GroupName)|$($row.Mode)|$($row.Notification)|$($row.DOPriority)|$($row.FilterType)|$($row.FilterId)|$($row.AvailableTime)|$($row.Deadline)|$($row.GracePeriod)"
                        }
                    }
                }
            }
        }
    }
    return ($lines | Sort-Object) -join "`n"
}

function Get-BackupChangeInfo {
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
        return @{
            HasChanges = $false
            Summary    = 'Baseline backup'
        }
    }
    
    $currentState = ConvertTo-ComparisonState -Items $CurrentItems
    $previousState = ConvertTo-ComparisonState -Items $PreviousItems

    $hasChanges = ($previousState -ne $currentState)
    #$hasChanges = ($PreviousItems -ne $CurrentItems)

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
    #$TreeViewItem.Foreground = [System.Windows.Media.Brushes]::DarkSlateGray
    #$TreeViewItem.FontWeight = [System.Windows.FontWeights]::Bold
}

function Update-TreeView {
    param (
        [Parameter(Mandatory = $true)]
        $ObjectData,

        [string]
        $HeaderRoot = "Backups"
    )

    # Clear existing items
    $TreeBackupFolders.Items.Clear()

    # Create and Add the Root Node for Backups
    $TreeViewItem_Parent = New-Object System.Windows.Controls.TreeViewItem
    $TreeViewItem_Parent.Header = $HeaderRoot

    $previousBackup = $null

    foreach ($Object in $ObjectData) {
        # Create a TreeViewItem for the Backup Folder
        $TreeViewItem_Backup = New-Object System.Windows.Controls.TreeViewItem
        $TreeViewItem_Backup.Header = $Object.Name
        $TreeViewItem_Backup.Tag = @{
            Level    = "BackupFolder"
            Name     = $Object.Name
            FullName = $Object.FullName
            Backup   = $Object
        }

        # Check for Changes
        $ChangeInfo = Get-BackupChangeInfo -CurrentItems @($Object) -PreviousItems $previousBackup
        Set-BackupTreeNodeHighlight -TreeViewItem $TreeViewItem_Backup -FolderData $Object -ChangeInfo $ChangeInfo -PreviousBackupName $previousBackup.Name

        foreach ($Tenant in @($Object.Tenants)) {
            if (-not $Tenant) {
                continue
            }
            $TreeViewItem_Tenant = New-Object System.Windows.Controls.TreeViewItem
            $TreeViewItem_Tenant.Header = if ($Tenant.Name) { "$($Tenant.Name)" } else { "Tenant" }
            $TreeViewItem_Tenant.Tag = @{
                Level    = "Tenant"
                Name     = $Object.Name
                FullName = $Object.FullName
                Tenant   = $Tenant
            }

            foreach ($ProductNode in @($Tenant.ProductList)) {
                if (-not $ProductNode) {
                    continue
                }

                $TreeViewItem_ProductNode = New-Object System.Windows.Controls.TreeViewItem
                $TreeViewItem_ProductNode.Header = $ProductNode.Name
                $TreeViewItem_ProductNode.Tag = @{
                    Level    = "ProductNode"
                    Name     = $Object.Name
                    FullName = $Object.FullName
                    Product  = $ProductNode
                }

                foreach ($Product in @($ProductNode.Products)) {
                    if (-not $Product) {
                        continue
                    }
                    $TreeViewItem_Product = New-Object System.Windows.Controls.TreeViewItem
                    $TreeViewItem_Product.Header = $Product.ProductName
                    $TreeViewItem_Product.Tag = @{
                        Level          = "Product"
                        Name           = $Object.Name
                        FullName       = $Object.FullName
                        ProductDetails = $Product
                    }

                    $TreeViewItem_ProductNode.Items.Add($TreeViewItem_Product)
                }

                $TreeViewItem_Tenant.Items.Add($TreeViewItem_ProductNode)
            }

            $TreeViewItem_Backup.Items.Add($TreeViewItem_Tenant)
        }

        # Add the Backup Folder node to the Root
        $TreeViewItem_Parent.Items.Add($TreeViewItem_Backup)

        # Update the previous backup variable for the next iteration
        $previousBackup = $Object
    }
    $TreeBackupFolders.Items.Add($TreeViewItem_Parent)
    $TreeViewItem_Parent.IsExpanded = $true
}

function Set-SelectedProductDetails {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $ProductData
    )
    
    foreach ($Assignment in $ProductData.Assignments) {
        # Convert the Assignment hashtable to a custom object for easier binding to the DataGrid
        [PSCustomObject]$PSObjectAssignment = $Assignment.Assignment | ConvertTo-Json | ConvertFrom-Json
        # Add to the DataGrid
        switch ($Assignment.Intent) {
            "Required" {
                # Leaving these here for the future. Will reset the column widths initialls before setting the items
                #$DgRequiredAssignments.Columns | ForEach-Object { $_.Width = [System.Windows.Controls.DataGridLength]::SizeToHeader }
                $DgRequiredAssignments.Items.Add($PSObjectAssignment)
                # Resize the columns to fit the content
                $DgRequiredAssignments.Columns | ForEach-Object { $_.Width = [System.Windows.Controls.DataGridLength]::Auto }
            }
            "Available" {
                $DgAvailableAssignments.Columns | ForEach-Object { $_.Width = [System.Windows.Controls.DataGridLength]::SizeToHeader }
                $DgAvailableAssignments.Items.Add($PSObjectAssignment)
                $DgAvailableAssignments.Columns | ForEach-Object { $_.Width = [System.Windows.Controls.DataGridLength]::Auto }
            }
            "Uninstall" {
                $DgUninstallAssignments.Columns | ForEach-Object { $_.Width = [System.Windows.Controls.DataGridLength]::SizeToHeader }
                $DgUninstallAssignments.Items.Add($PSObjectAssignment)
                $DgUninstallAssignments.Columns | ForEach-Object { $_.Width = [System.Windows.Controls.DataGridLength]::Auto }
            }
        }
    }

    # Set the override checkbox state and enable it if there are any assignments
    $ChkOverrideManualAssignments.IsChecked = $ProductData.EnforceIntuneAssignments -eq $true
}

function Clear-ProductDetails {
    $DgRequiredAssignments.Items.Clear()
    $DgAvailableAssignments.Items.Clear()
    $DgUninstallAssignments.Items.Clear()
    $ChkOverrideManualAssignments.IsChecked = $false
}

function Set-SelectedFolder {
    param (
        [Parameter(Mandatory = $true)]
        $SelectedNode
    )
    Clear-ProductDetails
    $TxtSelectedFolder.Text = "$($SelectedNode.Tag.Name)"
    $TxtSelectedFolderPath.Text = "$($SelectedNode.Tag.FullName)"
    $BtnOpenFolder.IsEnabled = $true
}

#### Form Load #####
$formIntuneAssignments.Add_Loaded({
        Update-TreeView -ObjectData $TreeViewItems
    })

$TreeBackupFolders.Add_SelectedItemChanged({
        $SelectedNode = $TreeBackupFolders.SelectedItem

        Clear-ProductDetails
        
        Set-SelectedFolder -SelectedNode $SelectedNode

        if ($SelectedNode.Tag.Level -eq 'Product') {
            Set-SelectedProductDetails -ProductData $SelectedNode.Tag.ProductDetails
        }
    })

$BtnOpenFolder.Add_Click({
        if (-not [string]::IsNullOrWhiteSpace($TxtSelectedFolderPath.Text) -and (Test-Path -LiteralPath $TxtSelectedFolderPath.Text)) {
            try {
                # Open the backup folder in File Explorer with the file selected
                #Start-Process -FilePath "explorer.exe" -ArgumentList "$($TxtSelectedFolderPath.Text)"
                Start-Process -FilePath "explorer.exe" -ArgumentList "/select,`"$($TxtSelectedFolderPath.Text)\Settings.xml`""
                Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] Successfully Opened: [$($TxtSelectedFolderPath.Text)]"
            }
            catch {
                Write-Host "Failed to open the backup folder in File Explorer"
                Write-Error "$($_.Exception.Message)"
            }
        }
    })

$BtnClose.Add_Click({ 
        $formIntuneAssignments.Close()
    })
$BtnOk.Add_Click({
        $formIntuneAssignments.Close()
    })

$TopBanner.Add_MouseLeftButtonDown({
        $formIntuneAssignments.DragMove()
    })

$null = $formIntuneAssignments.ShowDialog()
