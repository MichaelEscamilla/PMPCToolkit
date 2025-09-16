<#
    .SYNOPSIS
    Parses Intune AppWorkload log files to extract information about Win32 App policies, GRS (Global Retry Schedule) details, or ESP (Enrollment Status Page) profile data.
#>

function Get-AppWorkloadPolicies {
    [CmdletBinding()]
    param (
        [string]$Path = "$(Get-Location)\AppWorkload*.log",
        [switch]$Latest,
        [switch]$UninstallCommand,
        [switch]$DetectionScript,
        [switch]$RequirementScript,
        [switch]$GRSInfo,
        [switch]$ESPInfo
    )

    Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] Searching for [AppWorkload*.log]"
    foreach ($File in $(Resolve-Path $Path)) {
        Write-Host -ForegroundColor DarkGray "[$(Get-Date -format G)] Found [$File]"
    }

    if (!$ESPInfo) {
        # Policy Pattern
        [string]$Pattern = '<!\[LOG\[Get policies = \[(.*?)\]\]'

        # Search Log File(s) for the Pattern
        $PatternMatches = $null
        if ($Latest) {
            $PatternMatches = Select-String -Path "$($Path)" -Pattern $Pattern | Select-Object -Last 1
        }
        else {
            $PatternMatches = Select-String -Path "$($Path)" -Pattern $Pattern
        }

        # Check if the Pattern was found
        if ($PatternMatches) {
            # Start Building PSCustomObject
            [Collections.Generic.List[PSCustomObject]]$PolicyApps = @()

            foreach ($Match in $PatternMatches) {
                # Parse the Line for the Policy JSON by removing the Start and End Pattern
                $PolicyJson = $null
                $PolicyJson = $Match.Line -replace '^\<\!\[LOG\[Get policies = ', '' -replace '\]LOG\]!>.*', ''

                # Parse the Line for the Date
                $PolicyDate = Read-CMTraceLogLine -LineContent "$($Match.Line)"

                # Convert the String from JSON
                $Policy = $null
                $Policy = $PolicyJson | ConvertFrom-Json -ErrorAction Stop

                $Policy | ForEach-Object {
                    # Build a PSCustomObject
                    $CusObj = [PSCustomObject] @{
                        'Policy Date'        = $PolicyDate.DateTime
                        'App Id'             = $_.Id
                        'App Name'           = $_.Name
                        Revision             = $_.Version
                        Intent               = switch ($_.Intent) {
                            0 { 'Not Targeted' }
                            1 { 'Available' }
                            3 { 'Required' }
                            4 { 'Uninstall' }
                            Default { $_.Intent }
                        }
                        Context              = switch (($_.InstallEx | ConvertFrom-Json -ErrorAction SilentlyContinue).RunAs) {
                            0 { 'USER' }
                            1 { 'SYSTEM' }
                            Default { ($_.InstallEx | ConvertFrom-Json -ErrorAction SilentlyContinue).RunAs }
                        }
                        TimeFormat           = $_.StartDeadlineEx.TimeFormat
                        StartTime            = if ($_.StartDeadlineEx.StartTime -eq '1/1/0001 12:00:00 AM') { 'ASAP' } else { $_.StartDeadlineEx.StartTime }
                        Deadline             = if ($_.StartDeadlineEx.Deadline -eq '1/1/0001 12:00:00 AM') { 'ASAP' } else { $_.StartDeadlineEx.Deadline }
                        DO                   = switch ($_.DOPriority) {
                            0 { 'Background' }
                            1 { 'Foreground' }
                            Default { $_.DOPriority }
                        }
                        Notifications        = switch ($_.AvailableAppEnforcement) {
                            0 { 'Show All' }
                            1 { 'On Restart' }
                            2 { '2' }
                            3 { 'Hide All' }
                            Default { $_.NotificationPriority }
                        }
                        InstallCommandLine   = $_.InstallCommandLine
                        UninstallCommandLine = $_.UninstallCommandLine
                    }

                    # Add Detection Script to PSCustomObject
                    if ($DetectionScript) {
                        # Check Detection is a Script
                        $DetectionScriptValue = ($_.DetectionRule | ConvertFrom-Json -ErrorAction SilentlyContinue)
                        if ($DetectionScriptValue.DetectionType -eq 3) {
                            # Extract Script Body
                            $DetectionScriptValue = (ConvertFrom-Json ($DetectionScriptValue.DetectionText) | Select-Object -ExpandProperty ScriptBody -ErrorAction SilentlyContinue)
                            # Decode Base64
                            $DetectionScriptValue = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($DetectionScriptValue))
                        
                            # Extract PMPC Variables
                            if ($_.InstallCommandLine -match 'PatchMyPC-ScriptRunner') {
                                $DetectionObject = [PSCustomObject]@{
                                    AppName    = $(Get-PowerShellVariables -ScriptContent $DetectionScriptValue -VariableName "z")
                                    AppVersion = $(Get-PowerShellVariables -ScriptContent $DetectionScriptValue -VariableName "d")
                                }
                                # Add to PSCustomObject
                                $CusObj | Add-Member -MemberType NoteProperty -Name 'Detection Script' -Value $DetectionObject
                            }
                            else {
                                # Add full script to PSCustomObject
                                $CusObj | Add-Member -MemberType NoteProperty -Name 'Detection Script' -Value $DetectionScriptValue
                            }

                            # Check Script Signature Signer
                            if ($DetectionScriptValue -match '# SIG # Begin signature block') {
                                # Convert the detection script string to byte array for Get-AuthenticodeSignature, then parse out the Signer (CN=...)
                                $DetectionScriptSigner = ((Get-AuthenticodeSignature -Content $([System.Text.Encoding]::UTF8.GetBytes($DetectionScriptValue)) -SourcePathOrExtension ".ps1" | Select-Object *).SignerCertificate.Subject -split ',')[0]
                                # Add to PSCustomObject
                                $CusObj | Add-Member -MemberType NoteProperty -Name 'Detection Signer' -Value ($DetectionScriptSigner)
                            }
                            else {
                                $CusObj | Add-Member -MemberType NoteProperty -Name 'Detection Signer' -Value 'Not Signed'
                            }
                        }
                        else {
                            $CusObj | Add-Member -MemberType NoteProperty -Name 'Detection Script' -Value 'Not a Script'
                            $CusObj | Add-Member -MemberType NoteProperty -Name 'Detection Signer' -Value 'N/A'
                        }
                    }

                    # Add Requirement Script to PSCustomObject
                    if ($RequirementScript) {
                        # Check Requirement is a Script
                        $RequirementScriptValue = ($_.ExtendedRequirementRules | ConvertFrom-Json -ErrorAction SilentlyContinue)
                        if ($RequirementScriptValue.Type -eq 3) {
                            # Extract Script Body
                            $RequirementScriptValue = (ConvertFrom-Json ($RequirementScriptValue.RequirementText) | Select-Object -ExpandProperty ScriptBody -ErrorAction SilentlyContinue)
                            # Decode Base64
                            $RequirementScriptValue = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($RequirementScriptValue))

                            if ($_.InstallCommandLine -match 'PatchMyPC-ScriptRunner') {
                                $RequirementObject = [PSCustomObject]@{
                                    AppName    = $(Get-PowerShellVariables -ScriptContent $RequirementScriptValue -VariableName "z")
                                    AppVersion = $(Get-PowerShellVariables -ScriptContent $RequirementScriptValue -VariableName "d")
                                }
                                # Add to PSCustomObject
                                $CusObj | Add-Member -MemberType NoteProperty -Name 'Requirement Script' -Value $RequirementObject
                                #$CusObj | Add-Member -MemberType NoteProperty -Name 'Requirement Script' -Value $RequirementScriptValue
                            }
                            else {
                                # Add to PSCustomObject
                                $CusObj | Add-Member -MemberType NoteProperty -Name 'Requirement Script' -Value $RequirementScriptValue
                            }

                            # Check Script Signature Signer
                            if ($RequirementScriptValue -match '# SIG # Begin signature block') {
                                # Convert the requirement script string to byte array for Get-AuthenticodeSignature
                                $RequirementScriptSigner = ((Get-AuthenticodeSignature -Content $([System.Text.Encoding]::UTF8.GetBytes($RequirementScriptValue)) -SourcePathOrExtension ".ps1" | Select-Object *).SignerCertificate.Subject -split ',')[0]
                                # Add to PSCustomObject
                                $CusObj | Add-Member -MemberType NoteProperty -Name 'Requirement Signer' -Value ($RequirementScriptSigner)
                            }
                            else {
                                $CusObj | Add-Member -MemberType NoteProperty -Name 'Requirement Signer' -Value 'Not Signed'
                            }
                        }
                        else {
                            $CusObj | Add-Member -MemberType NoteProperty -Name 'Requirement Script' -Value 'Not a Script'
                            $CusObj | Add-Member -MemberType NoteProperty -Name 'Requirement Signer' -Value 'N/A'
                        }
                    }

                    # Get GRS Info
                    if ($GRSInfo) {
                        # Store Current App ID
                        $CurrentAppID = $_.Id

                        # GRS Line Pattern
                        [string]$grsPattern = '<!\[LOG\[\[Win32App\]\[GRSManager\].*'

                        # Search for GRS Info
                        $GRSInfoMatches = Select-String -Path "$($Path)" -Pattern $grsPattern

                        # GRS App ID Pattern
                        [string]$grsAppIdPattern = 'Found GRS value: (\d{2}/\d{2}/\d{4} \d{2}:\d{2}:\d{2}) at key (.+)'

                        # Find all the entries with the AppID and the GRS Pattern
                        $GRSInfoMatches = $GRSInfoMatches | Where-Object { $_ -match "$($CurrentAppID)" } | Where-Object { $_ -match $grsAppIdPattern }

                        # Build a Sortable List to find the latest entry
                        [Collections.Generic.List[PSCustomObject]]$EntryObjects = @()
                        foreach ($Entry in $GRSInfoMatches) {
                            # Build a custom object with the info
                            $GRSInfoObject = [PSCustomObject]@{
                                'DateTime' = [datetime]::ParseExact(([regex]::Matches($Entry, '(\d{2}/\d{2}/\d{4} \d{2}:\d{2}:\d{2})')).Value, "MM/dd/yyyy HH:mm:ss", $null)
                                'LineData' = $Entry
                            }
                            # Add to List
                            $EntryObjects.Add($GRSInfoObject)
                        }

                        # Get the latest entry by DateTime
                        $LatestEntry = $EntryObjects | Sort-Object DateTime | Select-Object -Last 1

                        if ($LatestEntry) {
                            # Get RegistryKey and Ensure we are matching on the LatestEntry LineData 
                            $formattedRegistryKey = (($LatestEntry.LineData.ToString() | Select-String -Pattern $grsAppIdPattern).Matches.Groups[2].Value) -replace '=.*', '='
                            $registryKeyToDelete = "HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\Win32Apps\$formattedRegistryKey"

                            $GRSInformation = $null
                            $GRSInformation = [PSCustomObject]@{
                                'GRS Last Attempt (UTC)' = $LatestEntry.DateTime
                                'GRS RegKey'             = $registryKeyToDelete
                            }
                            # Add to PSCustomObject
                            $CusObj | Add-Member -MemberType NoteProperty -Name 'GRS Last Attempt (UTC)' -Value $($GRSInformation.'GRS Last Attempt (UTC)')
                            $CusObj | Add-Member -MemberType NoteProperty -Name 'GRS RegKey' -Value $($GRSInformation.'GRS RegKey')
                        }
                        else {
                            $CusObj | Add-Member -MemberType NoteProperty -Name 'GRS Last Attempt (UTC)' -Value "N/A"
                            $CusObj | Add-Member -MemberType NoteProperty -Name 'GRS RegKey' -Value "N/A"
                        }

                    }

                    # Add PSCustomObject to List
                    $PolicyApps.Add($CusObj)
                }
            }
            $PolicyApps | Sort-Object 'App Name', 'App Id' | Out-GridView -Title "AppWorkload Policies [Total Records: $($PolicyApps.Count)]" -OutputMode Single
        }
        else {
            Write-Host "No Match Found"
        }
    }
    else {
        # ESP Pattern
        [string]$espLogPattern = '^\<\!\[LOG\[\[Win32App\]\[EspManager\] In EspPhase'

        # Search Log File(s) for the Pattern
        $PatternMatches = $null
        $PatternMatches = Select-String -Path "$($Path)" -Pattern $espLogPattern

        # Build a List to find the latest entry
        [Collections.Generic.List[PSCustomObject]]$espAppEntries = @()
        foreach ($Entry in $PatternMatches) {
            # Esp App Info Pattern
            [string]$espAppInfoPattern = 'In EspPhase: ([^\.]+)\. App ([0-9a-zA-Z]{8}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{12})([^\.]+)([0-9a-zA-Z]{8}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{12})?\. App name: (.+?)\]LOG'
            # Esp App Info Match
            $espAppInfo = $($Entry.ToString() | Select-String -Pattern $espAppInfoPattern).Matches.Groups
            # Check for Account Setup
            if ($espAppInfo[3].Value -match 'user') {
                # User ID Pattern
                [string]$UserIDPattern = '[0-9a-zA-Z]{8}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{4}-[0-9a-zA-Z]{12}'
                # Grab the User ID
                $UserID = $($espAppInfo[3].Value | Select-String -Pattern $UserIDPattern).Matches.Value
            }
            else {
                $UserID = 'N/A'
            }
            # Build a PSCustomObject with the Info
            $espApp = [PSCustomObject]@{
                'EspPhase' = $espAppInfo[1].Value
                'User ID'  = $UserID
                'App ID'   = $espAppInfo[2].Value
                'App Name' = $espAppInfo[5].Value
            }
            # Add PSCustomObject to List
            $espAppEntries.Add($espApp)
        }
        # Check entries were found
        if ($espAppEntries.Count -eq 0) {
            Write-Host -ForegroundColor Yellow "[$(Get-Date -format G)] No ESP App Entries Found"
        }
        else {
            # Display the results
            $espAppEntries | Out-GridView -Title "AppWorkload ESP Info [Total Records: $($PatternMatches.Count)]" -OutputMode Single
        }
    }
}