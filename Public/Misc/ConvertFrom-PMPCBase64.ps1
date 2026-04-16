<#
.SYNOPSIS
    Converts a Base64-encoded string into its decoded UTF-8 text.

.DESCRIPTION
    Takes a Base64-encoded string and decodes it into its original UTF-8 text representation.

.PARAMETER Base64String
    The Base64-encoded string to decode.

.EXAMPLE
    ConvertFrom-PMPCBase64 -Base64String 'dGVzdA=='

    Decodes the Base64 string and returns the original text.

.EXAMPLE
    ConvertFrom-PMPCBase64 -Base64String 'SGVsbG8gV29ybGQ='

    Returns 'Hello World'.
#>
function ConvertFrom-PMPCBase64 {
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