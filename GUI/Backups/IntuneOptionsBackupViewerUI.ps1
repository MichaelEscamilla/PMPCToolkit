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
        Title="Intune Options Backup Viewer"
        Height="840" Width="960"
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
        <Style TargetType="RadioButton">
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="Margin" Value="0,2,12,2"/>
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

                    <Border Grid.Column="0"
                            Width="18" Height="18"
                            CornerRadius="9"
                            BorderBrush="#D8ECFF" BorderThickness="1"
                            VerticalAlignment="Center">
                        <TextBlock Text="?"
                                   Foreground="#EAF5FF"
                                   FontWeight="Bold"
                                   HorizontalAlignment="Center"
                                   VerticalAlignment="Center"/>
                    </Border>

                    <TextBlock Grid.Column="1"
                               VerticalAlignment="Center"
                               Margin="8,0,0,0"
                               Foreground="White"
                               FontSize="12"
                               Text="Intune Options Backup Viewer — Review Intune tenant configuration from Publisher backup files."/>

                    <TextBlock Grid.Column="2" VerticalAlignment="Center">
                        <Hyperlink Name="LnkMoreInfo" Foreground="#EAF5FF">(More Info)</Hyperlink>
                    </TextBlock>
                </Grid>
            </Border>

            <!-- Main content -->
            <Grid Grid.Row="1" Margin="10,8,10,8">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="286"/>
                    <ColumnDefinition Width="10"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>

                <!-- Left: Backup / Tenant tree -->
                <GroupBox Grid.Column="0" Header="Intune Tenants" Padding="8">
                    <TreeView Name="TreeBackupTenants"
                              BorderBrush="#D2D2D2"
                              BorderThickness="1"
                              Background="White"/>
                </GroupBox>

                <!-- Right: Intune Options panel -->
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

                        <!-- Authentication Settings -->
                        <GroupBox Margin="0,0,0,8" Padding="8">
                            <GroupBox.Header>
                                <StackPanel Orientation="Horizontal">
                                    <TextBlock Text="Authentication Settings" FontSize="12" VerticalAlignment="Center"/>
                                    <TextBlock Margin="4,0,0,0" VerticalAlignment="Center">
                                        <Hyperlink Name="LnkAuthMoreInfo" Foreground="#1565C0">(More Info)</Hyperlink>
                                    </TextBlock>
                                </StackPanel>
                            </GroupBox.Header>
                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="180"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="84"/>
                                </Grid.ColumnDefinitions>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="6"/>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="6"/>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="6"/>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="6"/>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="10"/>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="6"/>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="6"/>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="6"/>
                                    <RowDefinition Height="Auto"/>
                                </Grid.RowDefinitions>

                                <!-- Tenant Friendly Name -->
                                <TextBlock Grid.Row="0" Grid.Column="0" Text="Tenant Friendly Name:" VerticalAlignment="Center"/>
                                <TextBox Grid.Row="0" Grid.Column="1" Grid.ColumnSpan="2" Name="TxtTenantFriendlyName"/>

                                <!-- Authority -->
                                <TextBlock Grid.Row="2" Grid.Column="0" Text="Authority:" VerticalAlignment="Center"/>
                                <TextBox Grid.Row="2" Grid.Column="1" Grid.ColumnSpan="2" Name="TxtAuthority"/>

                                <!-- Authentication URL -->
                                <TextBlock Grid.Row="4" Grid.Column="0" Text="Authentication URL:" VerticalAlignment="Center"/>
                                <TextBox Grid.Row="4" Grid.Column="1" Name="TxtAuthenticationUrl" Margin="0,0,6,0"/>
                                <Button Grid.Row="4" Grid.Column="2" Name="BtnRestoreAuthUrl" Content="Restore" IsEnabled="False"/>

                                <!-- Graph Base URL -->
                                <TextBlock Grid.Row="6" Grid.Column="0" Text="Graph Base URL:" VerticalAlignment="Center"/>
                                <TextBox Grid.Row="6" Grid.Column="1" Name="TxtGraphBaseUrl" Margin="0,0,6,0"/>
                                <Button Grid.Row="6" Grid.Column="2" Name="BtnRestoreGraphUrl" Content="Restore" IsEnabled="False"/>

                                <!-- Application (Client) ID -->
                                <TextBlock Grid.Row="8" Grid.Column="0" Text="Application (Client) ID:" VerticalAlignment="Center"/>
                                <TextBox Grid.Row="8" Grid.Column="1" Grid.ColumnSpan="2" Name="TxtApplicationId"/>

                                <!-- App Secret / App Certificate radios -->
                                <StackPanel Grid.Row="10" Grid.Column="0" Grid.ColumnSpan="3" Orientation="Horizontal">
                                    <RadioButton Name="RadAppSecret" Content="App Secret" IsChecked="True"/>
                                    <RadioButton Name="RadAppCertificate" Content="App Certificate"/>
                                </StackPanel>

                                <!-- App Secret value -->
                                <TextBlock Grid.Row="12" Grid.Column="0" Text="App Secret:" VerticalAlignment="Center"/>
                                <TextBox Grid.Row="12" Grid.Column="1" Grid.ColumnSpan="2" Name="TxtAppSecret"/>

                                <!-- App Certificate value -->
                                <TextBlock Grid.Row="14" Grid.Column="0" Text="App Certificate:" VerticalAlignment="Center"/>
                                <TextBox Grid.Row="14" Grid.Column="1" Grid.ColumnSpan="2" Name="TxtAppCertificate"/>
                            </Grid>
                        </GroupBox>

                        <!-- Application Options -->
                        <GroupBox Padding="8">
                            <GroupBox.Header>
                                <StackPanel Orientation="Horizontal">
                                    <TextBlock Text="Application Options" FontSize="12" VerticalAlignment="Center"/>
                                    <TextBlock Margin="4,0,0,0" VerticalAlignment="Center">
                                        <Hyperlink Name="LnkAppMoreInfo" Foreground="#1565C0">(More Info)</Hyperlink>
                                    </TextBlock>
                                </StackPanel>
                            </GroupBox.Header>
                            <StackPanel>

                                <!-- Digitally sign -->
                                <CheckBox Name="ChkDigitallySign"
                                          Content="Digitally sign the detection method script and enforce signature checking on the application in Intune"/>

                                <!-- Code-Signing Certificate -->
                                <Grid Margin="0,4,0,6">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="160"/>
                                        <ColumnDefinition Width="*"/>
                                        <ColumnDefinition Width="6"/>
                                        <ColumnDefinition Width="84"/>
                                        <ColumnDefinition Width="6"/>
                                        <ColumnDefinition Width="60"/>
                                    </Grid.ColumnDefinitions>
                                    <TextBlock Grid.Column="0" Text="Code-Signing Certificate:" VerticalAlignment="Center"/>
                                    <TextBox Grid.Column="1" Name="TxtCodeSigningCert"/>
                                    <Button Grid.Column="3" Name="BtnBrowseCert" Content="Browse..." IsEnabled="False"/>
                                    <Button Grid.Column="5" Name="BtnViewCert" Content="View..." IsEnabled="False"/>
                                </Grid>

                                <CheckBox Name="ChkUpdateESP"
                                          Content="Update Enrollment Status Page associations with new application when an updated application is created"/>
                                <CheckBox Name="ChkCopyAssignments"
                                          Content="Copy the assignments from previously created applications or updates when an updated application is created"/>
                                <CheckBox Name="ChkDeleteAssignments"
                                          Content="Delete the assignments from previously created applications or updates when an updated application is created"/>
                                <CheckBox Name="ChkUpdateDependencies"
                                          Content="Update application dependencies from previously created applications when an updated application is created"/>
                                <CheckBox Name="ChkCopyRequirements"
                                          Content="Copy the requirements from previously created applications or updates when an updated application is created"/>

                                <!-- Delete previously created applications -->
                                <CheckBox Name="ChkDeletePreviousApps"
                                          Content="Delete any previously created applications when an updated application is published"/>
                                <Grid Margin="20,2,0,6">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="Auto"/>
                                        <ColumnDefinition Width="48"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <TextBlock Grid.Column="0" Text="Retain up to" VerticalAlignment="Center" Margin="0,0,4,0"/>
                                    <TextBox Grid.Column="1" Name="TxtRetainPreviousApps" Margin="0,0,4,0"/>
                                    <TextBlock Grid.Column="2" Text="previously created applications" VerticalAlignment="Center"/>
                                </Grid>

                                <!-- Delete previously created updates -->
                                <CheckBox Name="ChkDeletePreviousUpdates"
                                          Content="Delete any previously created updates when a new update is published"/>
                                <Grid Margin="20,2,0,6">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="Auto"/>
                                        <ColumnDefinition Width="48"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <TextBlock Grid.Column="0" Text="Retain up to" VerticalAlignment="Center" Margin="0,0,4,0"/>
                                    <TextBox Grid.Column="1" Name="TxtRetainPreviousUpdates" Margin="0,0,4,0"/>
                                    <TextBlock Grid.Column="2" Text="previously created updates" VerticalAlignment="Center"/>
                                </Grid>

                                <!-- Configure maximum runtime -->
                                <Grid Margin="0,2,0,2">
                                    <Grid.ColumnDefinitions>
                                        <ColumnDefinition Width="Auto"/>
                                        <ColumnDefinition Width="48"/>
                                        <ColumnDefinition Width="*"/>
                                    </Grid.ColumnDefinitions>
                                    <TextBlock Grid.Column="0" Text="Configure maximum runtime of Win32 applications to" VerticalAlignment="Center" Margin="0,0,4,0"/>
                                    <TextBox Grid.Column="1" Name="TxtMaxRuntime" Margin="0,0,4,0"/>
                                    <TextBlock Grid.Column="2" Text="minutes" VerticalAlignment="Center"/>
                                </Grid>

                                <!-- Enable available uninstall -->
                                <CheckBox Name="ChkEnableAvailableUninstall"
                                          Content="Enable 'Allow available uninstall'"
                                          Margin="0,4,0,0"/>
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
[System.Windows.Window]$formIntuneOptions = [Windows.Markup.XamlReader]::Load($reader)

# Create Variables for all the controls in the XAML form
$xaml.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name ($_.Name) -Value $formIntuneOptions.FindName($_.Name) -Scope Global }


function ConvertTo-TenantComparisonState {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [object[]]
        $Items
    )

    return ConvertTo-Json -InputObject @($Items) -Depth 10 -Compress
}

function Get-TenantChangeInfo {
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

    $currentState = ConvertTo-TenantComparisonState -Items $CurrentItems
    $previousState = ConvertTo-TenantComparisonState -Items $PreviousItems

    $hasChanges = ($previousState -ne $currentState)

    return [PSCustomObject]@{
        HasChanges = $hasChanges
        Summary    = if ($hasChanges) { 'Changes detected' } else { 'No changes' }
    }
}

function Set-BackupNodeHighlight {
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

function Update-IntuneTreeView {
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

    # Clear the TreeView
    $TreeBackupTenants.Items.Clear()

    # Create and Add the Root Node for Backups
    $TreeViewItem_Parent = New-Object System.Windows.Controls.TreeViewItem
    $TreeViewItem_Parent.Header = $HeaderRoot

    $previousBackup = $null

    $ObjectData | ForEach-Object {
        # Create a TreeViewItem Object and set the header to the backup folder name
        $TreeViewItem_Folder = New-Object System.Windows.Controls.TreeViewItem
        $TreeViewItem_Folder.Header = "$($_.Name)"
        $TreeViewItem_Folder.Tag = $_

        # Check for Changes
        $ChangeInfo = Get-TenantChangeInfo -CurrentItems @($_.Tenants) -PreviousItems $(if ($previousBackup) { @($previousBackup.Tenants) } else { $null })

        # Update the TreeViewItem Background and Tooltip based on changes
        Set-BackupNodeHighlight -TreeViewItem $TreeViewItem_Folder -FolderData $_ -ChangeInfo $ChangeInfo -PreviousBackupName $previousBackup.Name
        
        # Lets Assume there is only 1 tenant for now
        # Add the Tenant Information as a child node under the backup folder node
        $TreeViewItem_Tenant = New-Object System.Windows.Controls.TreeViewItem
        $TreeViewItem_Tenant.Header = if ($_.Tenants.TenantFriendlyName) { $_.Tenants.TenantFriendlyName } else { "Unknown Tenant" }
        $TreeViewItem_Tenant.Tag = $_
        $TreeViewItem_Tenant.ToolTip = "$($_.Tenants.TenantFriendlyName)"

        $TreeViewItem_Folder.Items.Add($TreeViewItem_Tenant)

        # Add the TreeViewItem to the Parent Node
        $TreeViewItem_Parent.Items.Add($TreeViewItem_Folder)

        # Update the previous backup variable for the next iteration
        $previousBackup = $_
    }

    $TreeBackupTenants.Items.Add($TreeViewItem_Parent)
    # Expand the root item in the TreeView for better visibility of backup folders
    $TreeViewItem_Parent.IsExpanded = $true
}

function Clear-TenantDetails {
    $TxtTenantFriendlyName.Text = ""
    $TxtAuthority.Text = ""
    $TxtAuthenticationUrl.Text = ""
    $TxtGraphBaseUrl.Text = ""
    $TxtApplicationId.Text = ""
    $RadAppSecret.IsChecked = $false
    $RadAppCertificate.IsChecked = $false
    $TxtAppSecret.Text = ""
    $TxtAppCertificate.Text = ""

    $ChkDigitallySign.IsChecked = $false
    $TxtCodeSigningCert.Text = ""
    $ChkUpdateESP.IsChecked = $false
    $ChkCopyAssignments.IsChecked = $false
    $ChkDeleteAssignments.IsChecked = $false
    $ChkUpdateDependencies.IsChecked = $false
    $ChkCopyRequirements.IsChecked = $false
    $ChkDeletePreviousApps.IsChecked = $false
    $TxtRetainPreviousApps.Text = ""
    $ChkDeletePreviousUpdates.IsChecked = $false
    $TxtRetainPreviousUpdates.Text = ""
    $TxtMaxRuntime.Text = ""
    $ChkEnableAvailableUninstall.IsChecked = $false
}

function Set-TenantDetails {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $TenantData
    )

    Clear-TenantDetails

    # Authentication Settings
    $TxtTenantFriendlyName.Text = "$($TenantData.TenantFriendlyName)"
    $TxtAuthority.Text = "$($TenantData.Authority)"
    $TxtAuthenticationUrl.Text = "$($TenantData.AuthenticationUrl)"
    $TxtGraphBaseUrl.Text = "$($TenantData.GraphBaseUrl)"
    $TxtApplicationId.Text = "$($TenantData.ApplicationId)"

    if ($TenantData.AppCertificateEnabled -match 'true') {
        $RadAppCertificate.IsChecked = $true
        $RadAppSecret.IsChecked = $false
        $TxtAppSecret.Text = ""
        $TxtAppCertificate.Text = "$($TenantData.AppCertificateThumbprint)"
    }
    elseif ($null -ne $TenantData.AppSecret) {
        $RadAppSecret.IsChecked = $true
        $RadAppCertificate.IsChecked = $false
        $TxtAppSecret.Text = "$($TenantData.AppSecret)"
        $TxtAppCertificate.Text = ""
    }
    else {
        $RadAppSecret.IsChecked = $false
        $RadAppCertificate.IsChecked = $false
        $TxtAppSecret.Text = ""
        $TxtAppCertificate.Text = ""
    }

    # Application Options
    $ChkDigitallySign.IsChecked = $TenantData.DigitallySignScript -eq $true
    $TxtCodeSigningCert.Text = "$($TenantData.CodeSigningCertificate)"
    $ChkUpdateESP.IsChecked = $TenantData.UpdateESPAssociations -eq $true
    $ChkCopyAssignments.IsChecked = $TenantData.CopyAssignmentsOnUpdate -eq $true
    $ChkDeleteAssignments.IsChecked = $TenantData.DeleteAssignmentsOnUpdate -eq $true
    $ChkUpdateDependencies.IsChecked = $TenantData.UpdateDependencies -eq $true
    $ChkCopyRequirements.IsChecked = $TenantData.CopyRequirements -eq $true
    $ChkDeletePreviousApps.IsChecked = $TenantData.DeletePreviousApplications -eq $true
    $TxtRetainPreviousApps.Text = "$($TenantData.RetainPreviousApplicationsCount)"
    $ChkDeletePreviousUpdates.IsChecked = $TenantData.DeletePreviousUpdates -eq $true
    $TxtRetainPreviousUpdates.Text = "$($TenantData.RetainPreviousUpdatesCount)"
    $TxtMaxRuntime.Text = "$($TenantData.MaxRuntimeMinutes)"
    $ChkEnableAvailableUninstall.IsChecked = $TenantData.EnableAvailableUninstall -eq $true
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

    Clear-SelectedFolder

    $TxtSelectedFolder.Text = "$($SelectedNode.Tag.Name)"
    $TxtSelectedFolderPath.Text = "$($SelectedNode.Tag.FullName)"
    $BtnOpenFolder.IsEnabled = $true
}


#### Form Load #####
$formIntuneOptions.Add_Loaded({
        Update-IntuneTreeView -ObjectData $TreeViewItems
    })

$LnkMoreInfo.Add_Click({
        Start-Process "https://patchmypc.com/"
    })

$LnkAuthMoreInfo.Add_Click({
        Start-Process "https://docs.patchmypc.com/installation-guides/intune/azure-app-registration"
    })

$LnkAppMoreInfo.Add_Click({
        Start-Process "https://patchmypc.com/kb/intune-application-creation-options/"
    })

$TreeBackupTenants.Add_SelectedItemChanged({
        $SelectedNode = $TreeBackupTenants.SelectedItem

        # If no node is selected, clear the product details and selected folder information.
        if (-not $SelectedNode) {
            Clear-TenantDetails
            Clear-SelectedFolder
            return
        }
        # If the selected node doesn't have a Tag property, clear the product details and selected folder information.
        elseif (-not $SelectedNode.Tag) {
            Clear-TenantDetails
            Clear-SelectedFolder
            return
        }
        # If the selected node is the Backup folder node, only clear the tenant details
        elseif (($SelectedNode.Header) -eq ($SelectedNode.Tag.Name)) {
            Clear-TenantDetails
            Set-SelectedFolder -SelectedNode $SelectedNode
            return
        }

        Set-SelectedFolder -SelectedNode $SelectedNode
        Set-TenantDetails -TenantData $SelectedNode.Tag.Tenants
    })

$TopBanner.Add_MouseLeftButtonDown({
        try {
            $formIntuneOptions.DragMove()
        }
        catch {
            # Ignore drag exceptions when mouse state is not valid.
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
        $formIntuneOptions.DialogResult = $true
        $formIntuneOptions.Close()
    })

$null = $formIntuneOptions.ShowDialog()
