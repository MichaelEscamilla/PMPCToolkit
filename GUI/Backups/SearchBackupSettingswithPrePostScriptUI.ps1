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
        Title="The specified scripts, files and folders are packaged with the application content."
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
                <ColumnDefinition Width="286"/>
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

            <Grid Grid.Column="2">
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="8"/>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="10"/>
                    <RowDefinition Height="Auto"/>
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

            <TabControl Grid.Row="2" Name="MainTabs">
                <TabItem Name="TabPMPC" Header="PMPC">
                <Grid Margin="6">
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
                                <TextBox Grid.Column="2" Name="PTxtPreScript" Margin="0,0,6,0"/>
                                <Button Grid.Column="3" Name="PBtnPreClear" Margin="0,0,6,0" Content="X" Padding="0" IsEnabled="False"/>
                                <Button Grid.Column="4" Name="PBtnPreBrowse" Content="Browse..." IsEnabled="False"/>
                            </Grid>

                            <!-- Pre argument -->
                            <Grid Grid.Row="2">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" VerticalAlignment="Center" Text="Argument:"/>
                                <TextBox Grid.Column="1" Name="PTxtPreArg"/>
                            </Grid>

                            <!-- Pre vars -->
                            <Grid Grid.Row="4">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" VerticalAlignment="Center" Text="Insert Variable:"/>
                                <TextBlock Grid.Column="1" VerticalAlignment="Center">
                                    <Hyperlink Name="PLnkPreVars">%VendorName%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="PLnkPreVars2">%ProductName%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="PLnkPreVars3">%Version%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="PLnkPreVars4">%PackageID%</Hyperlink>
                                </TextBlock>
                            </Grid>

                            <CheckBox Grid.Row="6"
                                      Name="PChkPreStopUpdate"
                                      IsChecked="False"
                                      Margin="0,1,0,1"
                                      Content="Don't attempt software update if the pre script returns an exit code other than 0 or 3010."/>
                            <CheckBox Grid.Row="7"
                                      Name="PChkPreRunBefore"
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
                                <TextBox Grid.Column="2" Name="PTxtPostScript" Margin="0,0,6,0"/>
                                <Button Grid.Column="3" Name="PBtnPostClear" Margin="0,0,6,0" Content="X" Padding="0" IsEnabled="False"/>
                                <Button Grid.Column="4" Name="PBtnPostBrowse" Content="Browse..." IsEnabled="False"/>
                            </Grid>

                            <!-- Post argument -->
                            <Grid Grid.Row="13">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" VerticalAlignment="Center" Text="Argument:"/>
                                <TextBox Grid.Column="1" Name="PTxtPostArg"/>
                            </Grid>

                            <!-- Post vars -->
                            <Grid Grid.Row="15">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="120"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <TextBlock Grid.Column="0" VerticalAlignment="Center" Text="Insert Variable:"/>
                                <TextBlock Grid.Column="1" VerticalAlignment="Center" TextWrapping="Wrap">
                                    <Hyperlink Name="PLnkPostVars">%VendorName%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="PLnkPostVars2">%ProductName%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="PLnkPostVars3">%Version%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="PLnkPostVars4">%PackageID%</Hyperlink>
                                    <Run Text="   "/>
                                    <Hyperlink Name="PLnkPostVars5">%ReturnCode%</Hyperlink>
                                </TextBlock>
                            </Grid>
                        </Grid>
                    </GroupBox>

                </Grid>
                </TabItem>
                <TabItem Name="TabInstall" Header="Install">
                <Grid Margin="6">
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

                </Grid>
                </TabItem>

                <TabItem Name="TabUninstall" Header="Uninstall">
                <Grid Margin="6">
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

                </Grid>
                </TabItem>
            </TabControl>

            <!-- Additional files/folders group -->
            <GroupBox Grid.Row="4" Header="Additional Files and Folders" Padding="8">
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
                        <ListView Grid.Column="0" Name="LvwAdditionalFiles"
                                  Margin="0,0,6,0"
                                  BorderBrush="#ABADB3"
                                  BorderThickness="1"
                                  Background="White"
                                  ScrollViewer.VerticalScrollBarVisibility="Auto"/>
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
                        <ListView Grid.Column="0" Name="LvwAdditionalFolders"
                                  Margin="0,0,6,0"
                                  BorderBrush="#ABADB3"
                                  BorderThickness="1"
                                  Background="White"
                                  ScrollViewer.VerticalScrollBarVisibility="Auto"/>
                        <Button Grid.Column="1" Name="BtnFoldersClear" Margin="0,0,6,0" Content="X" VerticalAlignment="Top" Height="24" Padding="0" IsEnabled="False"/>
                        <StackPanel Grid.Column="2">
                            <Button Name="BtnFoldersBrowse" Content="Browse..." Height="24" IsEnabled="False"/>
                        </StackPanel>
                    </Grid>
                </Grid>
            </GroupBox>
            </Grid>
        </Grid>

            <!-- Bottom buttons -->
            <Grid Grid.Row="2" Margin="10,0,10,8">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="108"/>
                </Grid.ColumnDefinitions>
                <Button Grid.Column="1" Name="BtnOK" Content="Close" Height="24"/>
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
            HasChanges    = $false
            AddedCount    = 0
            RemovedCount  = 0
            ModifiedCount = 0
            Summary       = 'Baseline backup'
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
    #$TreeViewItem.Foreground = [System.Windows.Media.Brushes]::DarkSlateGray
    #$TreeViewItem.FontWeight = [System.Windows.FontWeights]::Bold
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
    $TreeVendorsProducts.Items.Clear()

    # Add each Vendor Name to the TreeView
    $TreeViewItem_Parent = New-Object System.Windows.Controls.TreeViewItem
    $TreeViewItem_Parent.Header = "$($HeaderRoot)"

    $previousBackup = $null

    $ObjectData | ForEach-Object {
        # Add each restore folder as a top-level node.
        $TreeViewItem_Folder = New-Object System.Windows.Controls.TreeViewItem
        $TreeViewItem_Folder.Header = $_.Name
        $TreeViewItem_Folder.Tag = $_

        $changeInfo = Get-BackupChangeInfo -CurrentItems @($_.Items) -PreviousItems $(if ($previousBackup) { @($previousBackup.Items) } else { $null })
        Set-BackupTreeNodeHighlight -TreeViewItem $TreeViewItem_Folder -FolderData $_ -ChangeInfo $changeInfo -PreviousBackupName $previousBackup.Name

        foreach ($Group in @($_.Items)) {
            if (-not $Group) {
                continue
            }

            $TreeViewItem_Group = New-Object System.Windows.Controls.TreeViewItem
            $TreeViewItem_Group.Header = if ($Group.Name) { "$($Group.Name)" } else { "Products" }
            $TreeViewItem_Group.Tag = $_

            foreach ($Product in @($Group.Products)) {
                if (-not $Product) {
                    continue
                }

                $ProductName = if ($Product.Product) {
                    "$($Product.Product)"
                }
                elseif ($Product.Name) {
                    "$($Product.Name)"
                }
                else {
                    "$Product"
                }

                $TreeViewItem_Product = New-Object System.Windows.Controls.TreeViewItem
                $TreeViewItem_Product.Header = $ProductName
                $TreeViewItem_Product.Tag = @{
                    Product = $Product
                    Name = $_.Name
                    FullName = $_.FullName
                }

                $TreeViewItem_Group.Items.Add($TreeViewItem_Product)
            }

            if ($TreeViewItem_Group.Items.Count -gt 0) {
                $TreeViewItem_Folder.Items.Add($TreeViewItem_Group)
            }
        }

        $TreeViewItem_Parent.Items.Add($TreeViewItem_Folder)
        $previousBackup = $_
    }
    $TreeVendorsProducts.Items.Add($TreeViewItem_Parent)
    # Expand the root item in the TreeView for better visibility of search results
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

function Clear-SelectedProductDetails {
    $PTxtPreScript.Text = ""
    $PTxtPreArg.Text = ""
    $PTxtPostScript.Text = ""
    $PTxtPostArg.Text = ""
    $PChkPreStopUpdate.IsChecked = $false
    $PChkPreRunBefore.IsChecked = $false

    $TxtPreScript.Text = ""
    $TxtPreArg.Text = ""
    $TxtPostScript.Text = ""
    $TxtPostArg.Text = ""
    $ChkPreStopUpdate.IsChecked = $false
    $ChkPreRunBefore.IsChecked = $false

    $UTxtPreScript.Text = ""
    $UTxtPreArg.Text = ""
    $UTxtPostScript.Text = ""
    $UTxtPostArg.Text = ""
    $UChkPreStopUpdate.IsChecked = $false
    $UChkPreRunBefore.IsChecked = $false

    $LvwAdditionalFiles.Items.Clear()
    $LvwAdditionalFolders.Items.Clear()

    Update-TabHighlights
}

function Set-TabHighlightState {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Windows.Controls.TabItem]
        $Tab,

        [Parameter(Mandatory = $true)]
        [bool]
        $HasData
    )

    if (-not $Tab.Tag) {
        $Tab.Tag = if ($Tab.Header -is [System.Windows.Controls.TextBlock]) {
            $Tab.Header.Text
        }
        else {
            [string]$Tab.Header
        }
    }

    if ($HasData) {
        $Tab.Header = [System.Windows.Controls.TextBlock]@{
            Text       = [string]$Tab.Tag
            FontWeight = [System.Windows.FontWeights]::Bold
            Foreground = [System.Windows.Media.Brushes]::DarkGreen
            Background = [System.Windows.Media.Brushes]::LightGoldenrodYellow
        }
        return
    }

    $Tab.Header = [string]$Tab.Tag
}

function Update-TabHighlights {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [AllowNull()]
        $ProductData
    )

    $hasPMPCData = $false
    $hasInstallData = $false
    $hasUninstallData = $false

    if ($ProductData -and $ProductData.PrePostScriptInfo) {
        $hasPMPCData = (@($ProductData.PrePostScriptInfo.PreScriptPMPC).Count -gt 0) -or (@($ProductData.PrePostScriptInfo.PostScriptPMPC).Count -gt 0)
        $hasInstallData = (@($ProductData.PrePostScriptInfo.PreScript).Count -gt 0) -or (@($ProductData.PrePostScriptInfo.PostScript).Count -gt 0)
        $hasUninstallData = (@($ProductData.PrePostScriptInfo.PreCommandUninstall).Count -gt 0) -or (@($ProductData.PrePostScriptInfo.PostCommandUninstall).Count -gt 0)
    }

    Set-TabHighlightState -Tab $TabPMPC -HasData $hasPMPCData
    Set-TabHighlightState -Tab $TabInstall -HasData $hasInstallData
    Set-TabHighlightState -Tab $TabUninstall -HasData $hasUninstallData
}

function Set-SelectedProductDetails {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $ProductData
    )

    Clear-SelectedProductDetails

    $PTxtPreScript.Text = "$($ProductData.PrePostScriptInfo.PreScriptPMPC.Path)"
    $PTxtPreArg.Text = "$($ProductData.PrePostScriptInfo.PreScriptPMPC.Args)"
    $PChkPreStopUpdate.IsChecked = $ProductData.PrePostScriptInfo.PreScriptPMPC.Abort -eq $true
    $PChkPreRunBefore.IsChecked = $ProductData.PrePostScriptInfo.PreScriptPMPC.RBSK -eq $true

    $PTxtPostScript.Text = "$($ProductData.PrePostScriptInfo.PostScriptPMPC.Path)"
    $PTxtPostArg.Text = "$($ProductData.PrePostScriptInfo.PostScriptPMPC.Args)"

    $TxtPreScript.Text = "$($ProductData.PrePostScriptInfo.PreScript.Path)"
    $TxtPreArg.Text = "$($ProductData.PrePostScriptInfo.PreScript.Args)"
    $ChkPreStopUpdate.IsChecked = $ProductData.PrePostScriptInfo.PreScript.Abort -eq $true
    $ChkPreRunBefore.IsChecked = $ProductData.PrePostScriptInfo.PreScript.RBSK -eq $true

    $TxtPostScript.Text = "$($ProductData.PrePostScriptInfo.PostScript.Path)"
    $TxtPostArg.Text = "$($ProductData.PrePostScriptInfo.PostScript.Args)"

    $UTxtPreScript.Text = "$($ProductData.PrePostScriptInfo.PreCommandUninstall.Path)"
    $UTxtPreArg.Text = "$($ProductData.PrePostScriptInfo.PreCommandUninstall.Args)"
    $UChkPreStopUpdate.IsChecked = $ProductData.PrePostScriptInfo.PreCommandUninstall.Abort -eq $true
    $UChkPreRunBefore.IsChecked = $ProductData.PrePostScriptInfo.PreCommandUninstall.RBSK -eq $true

    $UTxtPostScript.Text = "$($ProductData.PrePostScriptInfo.PostCommandUninstall.Path)"
    $UTxtPostArg.Text = "$($ProductData.PrePostScriptInfo.PostCommandUninstall.Args)"

    foreach ($File in $ProductData.PrePostScriptInfo.AdditionalFiles) {
        # Add the file to the Additiona FIles ListView
        $LvwAdditionalFiles.Items.Add($File.File)
    }

    foreach ($Folder in $ProductData.PrePostScriptInfo.AdditionalFolders) {
        # Add the folder to the Additional Folders ListView
        $LvwAdditionalFolders.Items.Add($Folder.Folder)
    }

    Update-TabHighlights -ProductData $ProductData
}

#### Form Load #####
$formProperties.Add_Loaded({
        # Update the TreeView
        Update-TreeView -ObjectData $TreeViewItems
    })

$lnkMoreInfo.Add_Click({
        Start-Process "https://learn.microsoft.com/"
    })

$TreeVendorsProducts.Add_SelectedItemChanged({
        $SelectedNode = $TreeVendorsProducts.SelectedItem

        # If no node is selected, clear the product details and selected folder information.
        if (-not $SelectedNode) {
            Clear-SelectedProductDetails
            Clear-SelectedFolder
            return
        }
        # If the selected node doesn't have a Tag property, clear the product details and selected folder information.
        elseif (-not $SelectedNode.Tag) {
            Clear-SelectedProductDetails
            Clear-SelectedFolder
            return
        }
        # If the selected node's Tag property doesn't have a Product, only clear the ProductDetails
        elseif (-not $SelectedNode.Tag.Product) {
            Clear-SelectedProductDetails
            Set-SelectedFolder -SelectedNode $SelectedNode
            return
        }

        # Set the Backup Folder and Product Details
        Set-SelectedFolder -SelectedNode $SelectedNode
        Set-SelectedProductDetails -ProductData $SelectedNode.Tag.Product
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