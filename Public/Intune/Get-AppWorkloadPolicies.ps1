<#
    .DESCRIPTION
        Stolen From: https://www.deploymentresearch.com/read-cmlogs-with-powershell-and-hello-world/
#>

function Get-AppWorkloadPolicies {
    [CmdletBinding()]
    param (
        [string]
        [string]$Path = "$(Get-Location)\AppWorkload*.log",
        [switch]$RequirementScript
    )

    Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] Searching for [AppWorkload*.log]"
    foreach ($File in $(Resolve-Path $Path)) {
        Write-Host -ForegroundColor DarkGray "[$((Get-Date).ToString('HH:mm:ss'))] Found [$File]"
    }

    # Policy Pattern
    [string]$Pattern = '<!\[LOG\[Get policies = \[(.*?)\]\]'

    # Search Log File(s) for the Pattern
    $Match = $null
    $Match = Select-String -Path "$($Path)" -Pattern $Pattern

    # Check if the Pattern was found
    if ($Match) {
        # Parse the Line for the Policy JSON by removing the Start and End Pattern
        $PolicyJson = $null
        $PolicyJson = $Match.Line -replace '^\<\!\[LOG\[Get policies = ', '' -replace '\]LOG\]!>.*', ''

        # Parse the Line for the Date
        $PolicyDate = Read-CMTraceLogLine -LineContent "$($Match.Line)"

        # Convert the String from JSON
        $Policy = $null
        $Policy = $PolicyJson | ConvertFrom-Json -ErrorAction Stop

        $Policy | ForEach-Object {

            # Start Building PSCustomObject
            $PSCustomObject = [PSCustomObject]@{
                Date       = $PolicyDate.DateTime
                Id         = $_.Id
                Name       = $_.Name
                Intent     = switch ($_.Intent) {
                    0 { 'Not Targeted' }
                    1 { 'Available' }
                    3 { 'Required' }
                    4 { 'Uninstall' }
                    Default { $_.Intent }
                }
                Context    = switch ((ConvertFrom-Json $_.InstallEx).RunAs) {
                    0 { 'USER' }
                    1 { 'SYSTEM' }
                    Default { $InstallEx.RunAs }
                }
                TimeFormat = $_.StartDeadlineEx.TimeFormat
                StartTime  = if ($_.StartDeadlineEx.StartTime -eq '1/1/0001 12:00:00 AM') { 'ASAP' } else { $_.StartDeadlineEx.StartTime }
                Deadline   = if ($_.StartDeadlineEx.Deadline -eq '1/1/0001 12:00:00 AM') { 'ASAP' } else { $_.StartDeadlineEx.Deadline }
            }

            # Add Context to PSCustomObject
            $addMemberSplat = @{
                MemberType = 'NoteProperty'
                Name       = 'Context1'
                Value      = switch ((ConvertFrom-Json $_.InstallEx).RunAs) {
                    0 { 'USER' }
                    1 { 'SYSTEM' }
                    Default { $InstallEx.RunAs }
                }
            }
            $PSCustomObject | Add-Member @addMemberSplat

            <#
            # Detection Rules
            $DetectionRule = "$($_.DetectionRule)" | ConvertFrom-Json
            if (!($DetectionRule)) {
                $DetectionRule = $null
            }d
            else {
                $DetectionRuleScript = $DetectionRule.DetectionText | ConvertFrom-Json | Select-Object -ExpandProperty ScriptBody -ErrorAction SilentlyContinue
                if (($null -ne $DetectionRuleScript) -and ($DetectionRuleScript -ne '')) {
                    $DetectionRuleScript = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($DetectionRuleScript))
                }
            }

            # Requirement Rules
            if ($RequirementScript) {
                $RequirementRulesExtended = "$($_.ExtendedRequirementRules)" | ConvertFrom-Json
                if (!($RequirementRulesExtended)) {
                    $RequirementRulesExtended = $null
                }
                else {
                    $RequirementRulesScript = "$($RequirementRulesExtended.RequirementText)" | ConvertFrom-Json | Select-Object -ExpandProperty ScriptBody -ErrorAction SilentlyContinue
                    if (($null -ne $RequirementRulesScript) -and ($RequirementRulesScript -ne '')) {
                        $RequirementRulesScript = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($RequirementRulesScript))
                    }
                }
            }

            # InstallEx
            $InstallEx = "$($_.InstallEx)" | ConvertFrom-Json

            # Delivery Optimization
            $DeliveryOptimization = "$($_.DeliveryOptimization)" | ConvertFrom-Json

            [PSCustomObject]@{
                Id                 = $_.Id
                Intent             = switch ($_.Intent) {
                    0 { 'Not Targeted' }
                    1 { 'Available' }
                    3 { 'Required' }
                    4 { 'Uninstall' }
                    Default { $_.Intent }
                }
                Context            = switch ($InstallEx.RunAs) {
                    0 { 'USER' }
                    1 { 'SYSTEM' }
                    Default { $InstallEx.RunAs }
                }
                DO                 = switch ($_.DOPriority) {
                    0 { 'Background' }
                    1 { 'Foreground' }
                    Default { $_.DOPriority }
                }
                Notifications      = switch ($_.NotificationPriority) {
                    0 { 'All' }
                    1 { '1' }
                    2 { '2' }
                    3 { '3' }
                    Default { $_.NotificationPriority }
                }
                Name               = $_.Name
                StartTime          = if ($_.StartDeadlineEx.StartTime -eq '1/1/0001 12:00:00 AM') { 'ASAP' } else { $_.StartDeadlineEx.StartTime }
                Deadline           = if ($_.StartDeadlineEx.Deadline -eq '1/1/0001 12:00:00 AM') { 'ASAP' } else { $_.StartDeadlineEx.Deadline }
                InstallCommandLine = $_.InstallCommandLine
                InstallerData      = $_.InstallerData
                #FlatDependencies   = $_.FlatDependencies
                FlatDependencies   = switch ($_.FlatDependencies) {
                    ({ $_.Action -eq 110 }) { "Supersedence - Uninstall - $($_.ChildId)" }
                    ({ $_.Action -eq 10 }) { "Supersedence - $($_.ChildId)" }
                    Default { $_.Action }
                }
                RequirementRules   = $RequirementRulesExtended | Select-Object -ExpandProperty Type
                RequirementScript  = $RequirementRulesScript
                DetectionType      = $DetectionRule | Select-Object -ExpandProperty DetectionType
                DetectionScript    = $DetectionRuleScript
            }
            #>

            $PSCustomObject | Sort-Object Name

            $scriptBody = $null
            $RequirementRulesScript = $null

        } | Out-GridView -Title "AppWorkload Policies" -OutputMode Single 
        $Policy.Count
    }
    else {
        Write-Host "No Match Found"
    }
}