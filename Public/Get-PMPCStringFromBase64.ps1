function Get-PMPCStringFromBase64 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Base64String
    )

    try {
        $Bytes = [Convert]::FromBase64String($Base64String)
        $DecodedString = [System.Text.Encoding]::UTF8.GetString($Bytes)
        return $DecodedString
    }
    catch {
        Write-Error "Failed to decode the Base64 string. Please ensure it is a valid Base64 encoded string."
        Write-Error "$($_.Exception.Message)"
        return
    }
}