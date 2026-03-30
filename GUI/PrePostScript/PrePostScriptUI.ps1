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
        Height="768" Width="1204"
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
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="10"/>
                    <RowDefinition Height="Auto"/>
                </Grid.RowDefinitions>
            <TabControl Grid.Row="0" Name="MainTabs">
                <TabItem Header="PMPC">
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
                <TabItem Header="Install">
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

                <TabItem Header="Uninstall">
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

function Update-TreeViewV2 {
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

    $ObjectData | ForEach-Object {
        # Add each restore folder as a top-level node.
        $TreeViewItem_Folder = New-Object System.Windows.Controls.TreeViewItem
        $TreeViewItem_Folder.Header = $_.Name
        $TreeViewItem_Folder.ToolTip = "$($_.FullName)"

        foreach ($Group in @($_.Items)) {
            if (-not $Group) {
                continue
            }

            $TreeViewItem_Group = New-Object System.Windows.Controls.TreeViewItem
            $TreeViewItem_Group.Header = if ($Group.Name) { "$($Group.Name)" } else { "Products" }

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
                $TreeViewItem_Product.Tag = $Product

                $ProductDetails = @()
                if ($Product.RecommendedPreScriptPath) { $ProductDetails += "Pre Script: $($Product.RecommendedPreScriptPath)" }
                if ($Product.RecommendedPostScriptPath) { $ProductDetails += "Post Script: $($Product.RecommendedPostScriptPath)" }
                if ($Product.PreCommand) { $ProductDetails += "Pre Command: $($Product.PreCommand)" }
                if ($Product.PostCommand) { $ProductDetails += "Post Command: $($Product.PostCommand)" }
                if ($ProductDetails.Count -gt 0) {
                    $TreeViewItem_Product.ToolTip = ($ProductDetails -join [Environment]::NewLine)
                }

                $TreeViewItem_Group.Items.Add($TreeViewItem_Product)
            }

            if ($TreeViewItem_Group.Items.Count -gt 0) {
                $TreeViewItem_Folder.Items.Add($TreeViewItem_Group)
            }
        }

        $TreeViewItem_Parent.Items.Add($TreeViewItem_Folder)
    }
    $TreeVendorsProducts.Items.Add($TreeViewItem_Parent)
    # Expand the root item in the TreeView for better visibility of search results
    $TreeViewItem_Parent.IsExpanded = $true
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
    $PChkPreStopUpdate.IsChecked = [bool]$ProductData.PrePostScriptInfo.PreScriptPMPC.Abort
    $PChkPreRunBefore.IsChecked = [bool]$ProductData.PrePostScriptInfo.PreScriptPMPC.RBSK

    $PTxtPostScript.Text = "$($ProductData.PrePostScriptInfo.PostScriptPMPC.Path)"
    $PTxtPostArg.Text = "$($ProductData.PrePostScriptInfo.PostScriptPMPC.Args)"

    $TxtPreScript.Text = "$($ProductData.PrePostScriptInfo.PreScript.Path)"
    $TxtPreArg.Text = "$($ProductData.PrePostScriptInfo.PreScript.Args)"
    $ChkPreStopUpdate.IsChecked = [bool]$ProductData.PrePostScriptInfo.PreScript.Abort
    $ChkPreRunBefore.IsChecked = [bool]$ProductData.PrePostScriptInfo.PreScript.RBSK

    $TxtPostScript.Text = "$($ProductData.PrePostScriptInfo.PostScript.Path)"
    $TxtPostArg.Text = "$($ProductData.PrePostScriptInfo.PostScript.Args)"

    $UTxtPreScript.Text = "$($ProductData.PrePostScriptInfo.PreCommandUninstall.Path)"
    $UTxtPreArg.Text = "$($ProductData.PrePostScriptInfo.PreCommandUninstall.Args)"
    $UChkPreStopUpdate.IsChecked = [bool]$ProductData.PrePostScriptInfo.PreCommandUninstall.Abort
    $UChkPreRunBefore.IsChecked = [bool]$ProductData.PrePostScriptInfo.PreCommandUninstall.RBSK

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
}

#### Form Load #####
$formProperties.Add_Loaded({
        # Update the TreeView
        Update-TreeViewV2 -ObjectData $TreeViewItems
    })

$lnkMoreInfo.Add_Click({
        Start-Process "https://learn.microsoft.com/"
    })

$TreeVendorsProducts.Add_SelectedItemChanged({
        $SelectedNode = $TreeVendorsProducts.SelectedItem
        if (-not $SelectedNode) {
            Clear-SelectedProductDetails
            return
        }

        $SelectedData = $SelectedNode.Tag
        if (-not $SelectedData) {
            Clear-SelectedProductDetails
            return
        }
        
        Set-SelectedProductDetails -ProductData $SelectedData
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