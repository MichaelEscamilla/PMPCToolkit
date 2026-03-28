<#
    Lets steal from @David Segura's Initialize-Module.ps1 and make it our own.
#>
function Initialize-Module {
    [CmdletBinding()]
    param (
        # Specifies a path to one or more locations.
        [Parameter(Mandatory = $false,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Path = "$($MyInvocation.MyCommand.Module.ModuleBase)\module.json",

        [Parameter(Mandatory = $false)]
        [string]
        $VariableName = "$(($MyInvocation.MyCommand.Module.Name).Trim())"
    )
    #=================================================
    $Error.Clear()
    Write-Verbose "[$(Get-Date -format s)] [$($MyInvocation.MyCommand.Name)] Start"
    $ModuleName = $($MyInvocation.MyCommand.Module.Name)
    Write-Verbose "[$(Get-Date -format s)] [$($MyInvocation.MyCommand.Name)] ModuleName: $ModuleName"
    $ModuleBase = $($MyInvocation.MyCommand.Module.ModuleBase)
    Write-Verbose "[$(Get-Date -format s)] [$($MyInvocation.MyCommand.Name)] ModuleBase: $ModuleBase"
    $ModuleVersion = $($MyInvocation.MyCommand.Module.Version)
    Write-Verbose "[$(Get-Date -format s)] [$($MyInvocation.MyCommand.Name)] ModuleVersion: $ModuleVersion"
    #=================================================
    # Import the RAW content of the JSON file
    $rawJsonContent = Get-Content -Path $Path -Raw

    # https://stackoverflow.com/questions/51066978/convert-to-json-with-comments-from-powershell
    $JsonContent = $rawJsonContent -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/'

    $hashtable = [ordered]@{}
    (ConvertFrom-Json $JsonContent).psobject.properties | ForEach-Object {
        $value = $_.Value
        # Expand PowerShell variables (e.g. $env:TEMP) in string values after JSON parsing
        # to avoid backslash-escaping issues with Windows paths in raw JSON
        if ($value -is [System.Management.Automation.PSCustomObject]) {
            $value.psobject.properties | ForEach-Object {
                if ($_.Value -is [string]) {
                    $_.Value = $ExecutionContext.InvokeCommand.ExpandString($_.Value)
                }
            }
        }
        elseif ($value -is [string]) {
            $value = $ExecutionContext.InvokeCommand.ExpandString($value)
        }
        $hashtable[$_.Name] = $value
    }

    Set-Variable -Name $VariableName -Value $hashtable -Scope Global -Force
    #=================================================
    $Message = "[$(Get-Date -format s)] [$($MyInvocation.MyCommand.Name)] End"
    Write-Verbose -Message $Message; Write-Debug -Message $Message
    #=================================================
}