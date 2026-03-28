Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="The specified scripts, files and folders are packaged with the application content."
        Height="768" Width="804"
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

        <!-- Top blue info banner -->
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
                           Text="The specified scripts, files and folders are packaged with the application content."/>

                <TextBlock Grid.Column="2" VerticalAlignment="Center">
                    <Hyperlink Name="LnkMoreInfo" Foreground="#EAF5FF">(More Info)</Hyperlink>
                </TextBlock>
            </Grid>
        </Border>

        <!-- Main content -->
        <Grid Grid.Row="1" Margin="10,8,10,8">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="220"/>
                <ColumnDefinition Width="10"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <GroupBox Grid.Column="0" Header="Vendors and Products" Padding="8">
                <Grid>
                    <TreeView Name="TreeVendorsProducts"
                              BorderBrush="#D2D2D2"
                              BorderThickness="1"
                              Background="White"/>
                </Grid>
            </GroupBox>

            <TabControl Grid.Column="2" Name="MainTabs">
                <TabItem Header="Install">
                <Grid Margin="6">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="10"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>

                    <!-- Scripts group -->
                    <GroupBox Grid.Row="0" Padding="8,10,8,8">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="6"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="6"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="6"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="10"/>
                                <RowDefinition Height="1"/>
                                <RowDefinition Height="10"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="6"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="6"/>
                                <RowDefinition Height="Auto"/>
                            </Grid.RowDefinitions>

                            <!-- Pre script row -->
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="24"/>
                                    <ColumnDefinition Width="96"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="32"/>
                                    <ColumnDefinition Width="84"/>
                                </Grid.ColumnDefinitions>

                                <Grid Grid.Column="0" Width="18" Height="18" VerticalAlignment="Center">
                                    <Border CornerRadius="2" Background="#2C5A85" BorderBrush="#1F3F5E" BorderThickness="1"/>
                                    <TextBlock Text=">_" FontSize="9" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                    <Ellipse Width="7" Height="7" Fill="#37B24D" Stroke="#2A8A3A" StrokeThickness="1" HorizontalAlignment="Right" VerticalAlignment="Bottom" Margin="0,0,-3,-3"/>
                                </Grid>
                                <TextBlock Grid.Column="1" VerticalAlignment="Center" Text="Pre Script"/>
                                <TextBox Grid.Column="2" Name="TxtPreScript" Margin="0,0,6,0"/>
                                <Button Grid.Column="3" Name="BtnPreClear" Margin="0,0,6,0" Content="X" Padding="0" IsEnabled="False"/>
                                <Button Grid.Column="4" Name="BtnPreBrowse" Content="Browse..." IsEnabled="False"/>
                            </Grid>

                            <!-- Pre argument -->
                            <Grid Grid.Row="2">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" VerticalAlignment="Center" Text="Argument:"/>
                                <TextBox Grid.Column="1" Name="TxtPreArg"/>
                            </Grid>

                            <!-- Pre vars -->
                            <Grid Grid.Row="4">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" VerticalAlignment="Center" Text="Insert Variable:"/>
                                <TextBlock Grid.Column="1" VerticalAlignment="Center">
                                    <Hyperlink Name="LnkPreVars">%VendorName%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="LnkPreVars2">%ProductName%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="LnkPreVars3">%Version%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="LnkPreVars4">%PackageID%</Hyperlink>
                                </TextBlock>
                            </Grid>

                            <CheckBox Grid.Row="6"
                                      Name="ChkPreStopUpdate"
                                      IsChecked="False"
                                      Margin="0,1,0,1"
                                      Content="Don't attempt software update if the pre script returns an exit code other than 0 or 3010."/>
                            <CheckBox Grid.Row="7"
                                      Name="ChkPreRunBefore"
                                      IsChecked="False"
                                      Margin="0,1,0,1"
                                      Content="Run the pre-update script before performing any auto-close or skip process checks."/>

                            <Border Grid.Row="9" BorderBrush="#CFCFCF" BorderThickness="0,1,0,0"/>

                            <!-- Post script row -->
                            <Grid Grid.Row="11">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="24"/>
                                    <ColumnDefinition Width="96"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="32"/>
                                    <ColumnDefinition Width="84"/>
                                </Grid.ColumnDefinitions>

                                <Grid Grid.Column="0" Width="18" Height="18" VerticalAlignment="Center">
                                    <Border CornerRadius="2" Background="#2C5A85" BorderBrush="#1F3F5E" BorderThickness="1"/>
                                    <TextBlock Text=">_" FontSize="9" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                    <Ellipse Width="7" Height="7" Fill="#37B24D" Stroke="#2A8A3A" StrokeThickness="1" HorizontalAlignment="Right" VerticalAlignment="Bottom" Margin="0,0,-3,-3"/>
                                </Grid>
                                <TextBlock Grid.Column="1" VerticalAlignment="Center" Text="Post Script"/>
                                <TextBox Grid.Column="2" Name="TxtPostScript" Margin="0,0,6,0"/>
                                <Button Grid.Column="3" Name="BtnPostClear" Margin="0,0,6,0" Content="X" Padding="0" IsEnabled="False"/>
                                <Button Grid.Column="4" Name="BtnPostBrowse" Content="Browse..." IsEnabled="False"/>
                            </Grid>

                            <!-- Post argument -->
                            <Grid Grid.Row="13">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" VerticalAlignment="Center" Text="Argument:"/>
                                <TextBox Grid.Column="1" Name="TxtPostArg"/>
                            </Grid>

                            <!-- Post vars -->
                            <Grid Grid.Row="15">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" VerticalAlignment="Center" Text="Insert Variable:"/>
                                <TextBlock Grid.Column="1" VerticalAlignment="Center" TextWrapping="Wrap">
                                    <Hyperlink Name="LnkPostVars">%VendorName%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="LnkPostVars2">%ProductName%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="LnkPostVars3">%Version%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="LnkPostVars4">%PackageID%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="LnkPostVars5">%ReturnCode%</Hyperlink>
                                </TextBlock>
                            </Grid>
                        </Grid>
                    </GroupBox>

                    <!-- Additional files/folders group -->
                    <GroupBox Grid.Row="2" Header="Additional Files and Folders" Padding="8">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="132"/>
                                <RowDefinition Height="10"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="132"/>
                            </Grid.RowDefinitions>

                            <TextBlock Grid.Row="0" Text="Additional files:" VerticalAlignment="Center" Margin="0,0,0,4"/>

                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="32"/>
                                    <ColumnDefinition Width="84"/>
                                </Grid.ColumnDefinitions>
                                <TextBox Grid.Column="0" Name="TxtAdditionalFiles"
                                         Margin="0,0,6,0"
                                         Height="Auto"
                                         TextWrapping="Wrap"
                                         AcceptsReturn="True"
                                         VerticalScrollBarVisibility="Auto"/>
                                <Button Grid.Column="1" Name="BtnFilesClear" Margin="0,0,6,0" Content="X" VerticalAlignment="Top" Height="24" Padding="0" IsEnabled="False"/>
                                <StackPanel Grid.Column="2">
                                    <Button Name="BtnFilesBrowse" Content="Browse..." Height="24" IsEnabled="False"/>
                                </StackPanel>
                            </Grid>

                            <TextBlock Grid.Row="3" Text="Additional folders:" VerticalAlignment="Center" Margin="0,0,0,4"/>

                            <Grid Grid.Row="4">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="32"/>
                                    <ColumnDefinition Width="84"/>
                                </Grid.ColumnDefinitions>
                                <TextBox Grid.Column="0" Name="TxtAdditionalFolders"
                                         Margin="0,0,6,0"
                                         Height="Auto"
                                         TextWrapping="Wrap"
                                         AcceptsReturn="True"
                                         VerticalScrollBarVisibility="Auto"/>
                                <Button Grid.Column="1" Name="BtnFoldersClear" Margin="0,0,6,0" Content="X" VerticalAlignment="Top" Height="24" Padding="0" IsEnabled="False"/>
                                <StackPanel Grid.Column="2">
                                    <Button Name="BtnFoldersBrowse" Content="Browse..." Height="24" IsEnabled="False"/>
                                </StackPanel>
                            </Grid>
                        </Grid>
                    </GroupBox>
                </Grid>
                </TabItem>

                <TabItem Header="Uninstall">
                <Grid Margin="6">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="10"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>

                    <!-- Scripts group -->
                    <GroupBox Grid.Row="0" Padding="8,10,8,8">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="6"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="6"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="6"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="10"/>
                                <RowDefinition Height="1"/>
                                <RowDefinition Height="10"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="6"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="6"/>
                                <RowDefinition Height="Auto"/>
                            </Grid.RowDefinitions>

                            <!-- Pre script row -->
                            <Grid Grid.Row="0">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="24"/>
                                    <ColumnDefinition Width="96"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="32"/>
                                    <ColumnDefinition Width="84"/>
                                </Grid.ColumnDefinitions>

                                <Grid Grid.Column="0" Width="18" Height="18" VerticalAlignment="Center">
                                    <Border CornerRadius="2" Background="#2C5A85" BorderBrush="#1F3F5E" BorderThickness="1"/>
                                    <TextBlock Text=">_" FontSize="9" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                    <Ellipse Width="7" Height="7" Fill="#37B24D" Stroke="#2A8A3A" StrokeThickness="1" HorizontalAlignment="Right" VerticalAlignment="Bottom" Margin="0,0,-3,-3"/>
                                </Grid>
                                <TextBlock Grid.Column="1" VerticalAlignment="Center" Text="Pre Script"/>
                                <TextBox Grid.Column="2" Name="UTxtPreScript" Margin="0,0,6,0"/>
                                <Button Grid.Column="3" Name="UBtnPreClear" Margin="0,0,6,0" Content="X" Padding="0" IsEnabled="False"/>
                                <Button Grid.Column="4" Name="UBtnPreBrowse" Content="Browse..." IsEnabled="False"/>
                            </Grid>

                            <!-- Pre argument -->
                            <Grid Grid.Row="2">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" VerticalAlignment="Center" Text="Argument:"/>
                                <TextBox Grid.Column="1" Name="UTxtPreArg"/>
                            </Grid>

                            <!-- Pre vars -->
                            <Grid Grid.Row="4">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" VerticalAlignment="Center" Text="Insert Variable:"/>
                                <TextBlock Grid.Column="1" VerticalAlignment="Center">
                                    <Hyperlink Name="ULnkPreVars">%VendorName%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="ULnkPreVars2">%ProductName%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="ULnkPreVars3">%Version%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="ULnkPreVars4">%PackageID%</Hyperlink>
                                </TextBlock>
                            </Grid>

                            <CheckBox Grid.Row="6"
                                      Name="UChkPreStopUpdate"
                                      IsChecked="False"
                                      Margin="0,1,0,1"
                                      Content="Don't attempt software update if the pre script returns an exit code other than 0 or 3010."/>
                            <CheckBox Grid.Row="7"
                                      Name="UChkPreRunBefore"
                                      IsChecked="False"
                                      Margin="0,1,0,1"
                                      Content="Run the pre-update script before performing any auto-close or skip process checks."/>

                            <Border Grid.Row="9" BorderBrush="#CFCFCF" BorderThickness="0,1,0,0"/>

                            <!-- Post script row -->
                            <Grid Grid.Row="11">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="24"/>
                                    <ColumnDefinition Width="96"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="32"/>
                                    <ColumnDefinition Width="84"/>
                                </Grid.ColumnDefinitions>

                                <Grid Grid.Column="0" Width="18" Height="18" VerticalAlignment="Center">
                                    <Border CornerRadius="2" Background="#2C5A85" BorderBrush="#1F3F5E" BorderThickness="1"/>
                                    <TextBlock Text=">_" FontSize="9" FontWeight="Bold" Foreground="White" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                    <Ellipse Width="7" Height="7" Fill="#37B24D" Stroke="#2A8A3A" StrokeThickness="1" HorizontalAlignment="Right" VerticalAlignment="Bottom" Margin="0,0,-3,-3"/>
                                </Grid>
                                <TextBlock Grid.Column="1" VerticalAlignment="Center" Text="Post Script"/>
                                <TextBox Grid.Column="2" Name="UTxtPostScript" Margin="0,0,6,0"/>
                                <Button Grid.Column="3" Name="UBtnPostClear" Margin="0,0,6,0" Content="X" Padding="0" IsEnabled="False"/>
                                <Button Grid.Column="4" Name="UBtnPostBrowse" Content="Browse..." IsEnabled="False"/>
                            </Grid>

                            <!-- Post argument -->
                            <Grid Grid.Row="13">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" VerticalAlignment="Center" Text="Argument:"/>
                                <TextBox Grid.Column="1" Name="UTxtPostArg"/>
                            </Grid>

                            <!-- Post vars -->
                            <Grid Grid.Row="15">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" VerticalAlignment="Center" Text="Insert Variable:"/>
                                <TextBlock Grid.Column="1" VerticalAlignment="Center" TextWrapping="Wrap">
                                    <Hyperlink Name="ULnkPostVars">%VendorName%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="ULnkPostVars2">%ProductName%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="ULnkPostVars3">%Version%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="ULnkPostVars4">%PackageID%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="ULnkPostVars5">%ReturnCode%</Hyperlink>
                                </TextBlock>
                            </Grid>
                        </Grid>
                    </GroupBox>

                    <!-- Additional files/folders group -->
                    <GroupBox Grid.Row="2" Header="Additional Files and Folders" Padding="8">
                        <Grid>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="132"/>
                                <RowDefinition Height="10"/>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="132"/>
                            </Grid.RowDefinitions>

                            <TextBlock Grid.Row="0" Text="Additional files:" VerticalAlignment="Center" Margin="0,0,0,4"/>

                            <Grid Grid.Row="1">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="32"/>
                                    <ColumnDefinition Width="84"/>
                                </Grid.ColumnDefinitions>
                                <TextBox Grid.Column="0" Name="UTxtAdditionalFiles"
                                         Margin="0,0,6,0"
                                         Height="Auto"
                                         TextWrapping="Wrap"
                                         AcceptsReturn="True"
                                         VerticalScrollBarVisibility="Auto"/>
                                <Button Grid.Column="1" Name="UBtnFilesClear" Margin="0,0,6,0" Content="X" VerticalAlignment="Top" Height="24" Padding="0" IsEnabled="False"/>
                                <StackPanel Grid.Column="2">
                                    <Button Name="UBtnFilesBrowse" Content="Browse..." Height="24" IsEnabled="False"/>
                                </StackPanel>
                            </Grid>

                            <TextBlock Grid.Row="3" Text="Additional folders:" VerticalAlignment="Center" Margin="0,0,0,4"/>

                            <Grid Grid.Row="4">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="32"/>
                                    <ColumnDefinition Width="84"/>
                                </Grid.ColumnDefinitions>
                                <TextBox Grid.Column="0" Name="UTxtAdditionalFolders"
                                         Margin="0,0,6,0"
                                         Height="Auto"
                                         TextWrapping="Wrap"
                                         AcceptsReturn="True"
                                         VerticalScrollBarVisibility="Auto"/>
                                <Button Grid.Column="1" Name="UBtnFoldersClear" Margin="0,0,6,0" Content="X" VerticalAlignment="Top" Height="24" Padding="0" IsEnabled="False"/>
                                <StackPanel Grid.Column="2">
                                    <Button Name="UBtnFoldersBrowse" Content="Browse..." Height="24" IsEnabled="False"/>
                                </StackPanel>
                            </Grid>
                        </Grid>
                    </GroupBox>
                </Grid>
                </TabItem>
            </TabControl>
        </Grid>

            <!-- Bottom buttons -->
            <Grid Grid.Row="2" Margin="10,0,10,8">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="108"/>
                    <ColumnDefinition Width="10"/>
                    <ColumnDefinition Width="108"/>
                </Grid.ColumnDefinitions>
                <Button Grid.Column="1" Name="BtnOK" Content="OK" Height="24"/>
                <Button Grid.Column="3" Name="BtnCancel" Content="Cancel" Height="24" IsEnabled="False"/>
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


function Get-Control {
    param([string]$Name)
    $formProperties.FindName($Name)
}
<#
# Install tab controls
$txtPreScript = Get-Control "TxtPreScript"
$txtPreArg = Get-Control "TxtPreArg"
$txtPostScript = Get-Control "TxtPostScript"
$txtPostArg = Get-Control "TxtPostArg"
$txtAdditionalFiles = Get-Control "TxtAdditionalFiles"
$txtAdditionalFolders = Get-Control "TxtAdditionalFolders"
$chkPreStopUpdate = Get-Control "ChkPreStopUpdate"
$chkPreRunBefore = Get-Control "ChkPreRunBefore"

# Uninstall tab controls
$uTxtPreScript = Get-Control "UTxtPreScript"
$uTxtPreArg = Get-Control "UTxtPreArg"
$uTxtPostScript = Get-Control "UTxtPostScript"
$uTxtPostArg = Get-Control "UTxtPostArg"
$uTxtAdditionalFiles = Get-Control "UTxtAdditionalFiles"
$uTxtAdditionalFolders = Get-Control "UTxtAdditionalFolders"
$uChkPreStopUpdate = Get-Control "UChkPreStopUpdate"
$uChkPreRunBefore = Get-Control "UChkPreRunBefore"

$btnOK = Get-Control "BtnOK"
$topBanner = Get-Control "TopBanner"
$treeVendorsProducts = Get-Control "TreeVendorsProducts"

$lnkMoreInfo = Get-Control "LnkMoreInfo"
#>

function Update-TreeView {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $XMLData,

        [string]
        $HeaderRoot = "All Products"
    )

    # Check for a null value
    if ([string]::IsNullOrWhiteSpace($XMLData)) {
        return
    }   

    # Clear the TreeView
    $TreeVendorsProducts.Items.Clear()

    # Add each Vendor Name to the TreeView
    $TreeViewItem_Parent = New-Object System.Windows.Controls.TreeViewItem
    $TreeViewItem_Parent.Header = "$($HeaderRoot)"
            
    $XMLData | ForEach-Object {
        # Add each Vendor Name to the TreeView
        $TreeViewItem_Vendor = New-Object System.Windows.Controls.TreeViewItem
        $TreeViewItem_Vendor.Header = $_.name
        $TreeViewItem_Vendor.ToolTip = "$($_.id)"
        $TreeViewItem_Parent.Items.Add($TreeViewItem_Vendor)

        # Loop through each Vendor and add each Product Name to the TreeView
        $_.Product | ForEach-Object {
            # Add each Product Name to the TreeView
            $TreeViewItem_Product = New-Object System.Windows.Controls.TreeViewItem
            if ($_.Capability -ne 'UpdateAndInstall') {
                $TreeViewItem_Product.Header = "$($_.name) - ($($_.Capability))"
            }
            else {
                $TreeViewItem_Product.Header = "$($_.name)"
            }
            $TreeViewItem_Product.ToolTip = "$($_.id)"
            $TreeViewItem_Product.Uid = "$($_.id)"
            $TreeViewItem_Vendor.Items.Add($TreeViewItem_Product)
        }
    }
    $TreeVendorsProducts.Items.Add($TreeViewItem_Parent)
    # Expand the root item in the TreeView for better visibility of search results
    $TreeViewItem_Parent.IsExpanded = $true
}

#### Form Load #####
$formProperties.Add_Loaded({
        # Get the Latest SupportedProducts.xml
        Get-SupportedProducts

        # Default Destination Path
        $SupportProductsPath = Join-Path -Path "$($PMPCToolkitModule.Module.DefaultCachePath)" -ChildPath "$($PMPCToolkitModule.Module.DefaultCacheFolderName)"
        $SupportProductsPath = Join-Path -Path $SupportProductsPath -ChildPath "$($PMPCToolkitModule.SupportProducts.DefaultCacheFolderName)"
        $SupportProductsPath = Join-Path -Path $SupportProductsPath -ChildPath "$($PMPCToolkitModule.SupportProducts.SupportProductsXMLFileName)"

        # Import the Supported Products XML
        $Global:SupportedProductsXml = [xml](Get-Content -Path $SupportProductsPath)
        Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] [$($MyInvocation.MyCommand.Name)] Successfully imported the supported products XML file"

        # Get All Vendor Names
        $Global:Products = $SupportedProductsXml.SelectNodes("//Vendor")

        # Update the TreeView
        Update-TreeView -XMLData $Global:Products
    })

$lnkMoreInfo.Add_Click({
        Start-Process "https://learn.microsoft.com/"
    })

if ($treeVendorsProducts) {
    $sampleVendor = New-Object System.Windows.Controls.TreeViewItem
    $sampleVendor.Header = "Vendor"

    $sampleProduct = New-Object System.Windows.Controls.TreeViewItem
    $sampleProduct.Header = "Product"

    $null = $sampleVendor.Items.Add($sampleProduct)
    $null = $treeVendorsProducts.Items.Add($sampleVendor)
    $sampleVendor.IsExpanded = $true
}

$topBanner.Add_MouseLeftButtonDown({
        try {
            $formProperties.DragMove()
        }
        catch {
            # Ignore drag exceptions when mouse state is not valid.
        }
    })

$btnOK.Add_Click({
        $formProperties.DialogResult = $true
        $formProperties.Close()
    })

$null = $formProperties.ShowDialog()