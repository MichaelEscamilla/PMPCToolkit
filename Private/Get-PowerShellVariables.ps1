function Get-PowerShellVariables {
    param(
        [string]$ScriptContent,
        [string]$VariableName = $null
    )
    
    # Pattern to match variable assignments with quoted values
    $pattern = '\$(\w+)\s*=\s*([''"])([^\2]*?)\2'
    $matches = [regex]::Matches($ScriptContent, $pattern)
    
    $variables = @{}
    foreach ($match in $matches) {
        $varName = $match.Groups[1].Value
        $varValue = $match.Groups[3].Value
        $variables[$varName] = $varValue
    }
    
    if ($VariableName) {
        return $variables[$VariableName]
    } else {
        return $variables
    }
}