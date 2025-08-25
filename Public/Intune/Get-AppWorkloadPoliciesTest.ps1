<#
    .DESCRIPTION
        Stolen From: https://www.deploymentresearch.com/read-cmlogs-with-powershell-and-hello-world/
#>

function Get-AppWorkloadPoliciesTest {
    [CmdletBinding()]
    param (
        [string]
        [string]$Path = "$(Get-Location)\AppWorkload*.log",
        [switch]$Latest,
        [switch]$DetectionScript,
        [switch]$RequirementScript
    )

    Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] Searching for [AppWorkload*.log]"
    foreach ($File in $(Resolve-Path $Path)) {
        Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] Found [$File]"
    }

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
                    'Policy Date'      = $PolicyDate.DateTime
                    'App Id'           = $_.Id
                    'App Name'         = $_.Name
                    Revision           = $_.Version
                    Intent             = switch ($_.Intent) {
                        0 { 'Not Targeted' }
                        1 { 'Available' }
                        3 { 'Required' }
                        4 { 'Uninstall' }
                        Default { $_.Intent }
                    }
                    Context            = switch ((ConvertFrom-Json $_.InstallEx).RunAs) {
                        0 { 'USER' }
                        1 { 'SYSTEM' }
                        Default { $InstallEx.RunAs }
                    }
                    TimeFormat         = $_.StartDeadlineEx.TimeFormat
                    StartTime          = if ($_.StartDeadlineEx.StartTime -eq '1/1/0001 12:00:00 AM') { 'ASAP' } else { $_.StartDeadlineEx.StartTime }
                    Deadline           = if ($_.StartDeadlineEx.Deadline -eq '1/1/0001 12:00:00 AM') { 'ASAP' } else { $_.StartDeadlineEx.Deadline }
                    DO                 = switch ($_.DOPriority) {
                        0 { 'Background' }
                        1 { 'Foreground' }
                        Default { $_.DOPriority }
                    }
                    Notifications      = switch ($_.AvailableAppEnforcement) {
                        0 { 'Show All' }
                        1 { 'On Restart' }
                        2 { '2' }
                        3 { 'Hide All' }
                        Default { $_.NotificationPriority }
                    }
                    InstallCommandLine = $_.InstallCommandLine
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
                        
                        if ($_.InstallCommandLine -match 'PatchMyPC-ScriptRunner') {
                            $DetectionObject = [PSCustomObject]@{
                                AppName    = $(Get-PowerShellVariables -ScriptContent $DetectionScriptValue -VariableName "z")
                                AppVersion = $(Get-PowerShellVariables -ScriptContent $DetectionScriptValue -VariableName "d")
                            }
                            # Add to PSCustomObject
                            $CusObj | Add-Member -MemberType NoteProperty -Name 'Detection Script' -Value $DetectionObject
                        }
                        else {
                            # Add to PSCustomObject
                            $CusObj | Add-Member -MemberType NoteProperty -Name 'Detection Script' -Value $DetectionScriptValue
                        }

                        # Check Script Signature Signer
                        if ($DetectionScriptValue -match '# SIG # Begin signature block') {
                            # Convert the detection script string to byte array for Get-AuthenticodeSignature
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
                        $CusObj | Add-Member -MemberType NoteProperty -Name 'Detection Signer' -Value 'Not Signed'
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
                        $CusObj | Add-Member -MemberType NoteProperty -Name 'Requirement Signer' -Value 'Not Signed'
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