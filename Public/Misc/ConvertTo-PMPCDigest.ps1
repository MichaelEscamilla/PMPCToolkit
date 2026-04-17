<#
.SYNOPSIS
    Converts a SHA1 hash string into a Base64-encoded digest string.

.DESCRIPTION
    Takes a hexadecimal SHA1 hash string and converts it to its Base64-encoded digest representation.
    Supports both PowerShell 7+ (using [convert]::FromHexString) and Windows PowerShell 5.1.

.PARAMETER Hash
    The hexadecimal SHA1 hash string to convert. Accepts pipeline input.

.EXAMPLE
    ConvertTo-PMPCDigest -Hash '7465737400'

    Converts the SHA1 hash string to its Base64 digest representation.

.EXAMPLE
    '7465737400' | ConvertTo-PMPCDigest

    Converts the SHA1 hash string via pipeline input.
#>
function ConvertTo-PMPCDigest {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [string]$Hash
    )
    if ($PSVersionTable.PSVersion.Major -ge 7) {
        # Convert the hex string back into a byte array
        $byteArray = [convert]::FromHexString($Hash)
        # Convert the byte array to a Base64 string
        $Digest = [convert]::ToBase64String($byteArray)
        return $Digest
    }
    else {
        # Convert the hex string back into a byte array two characters at a time
        $byteArray = [byte[]]::new($Hash.Length / 2)
        for ($i = 0; $i -lt $Hash.Length; $i += 2) {
            $byteArray[$i / 2] = [convert]::ToByte($Hash.Substring($i, 2), 16)
        }
        # Convert the byte array to a Base64 string
        $Digest = [convert]::ToBase64String($byteArray)
        return $Digest
    }
}
