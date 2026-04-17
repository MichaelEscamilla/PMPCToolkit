<#
.SYNOPSIS
    Converts a Base64-encoded digest string into a hexadecimal hash string.

.DESCRIPTION
    Takes a Base64-encoded digest value and converts it to its hexadecimal SHA1 hash representation.
    Supports both PowerShell 7+ (using [convert]::ToHexString) and Windows PowerShell 5.1 (using Format-Hex).
    Original concept from Jordan Benzing.

.PARAMETER Digest
    The Base64-encoded digest string to convert. Accepts pipeline input.

.EXAMPLE
    ConvertFrom-PMPCDigest -Digest 'dGVzdA=='

    Converts the Base64 digest string to its hexadecimal hash representation.

.EXAMPLE
    'dGVzdA==' | ConvertFrom-PMPCDigest

    Converts the Base64 digest string via pipeline input.
#>
function ConvertFrom-PMPCDigest {
    [cmdletbinding()]
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [string]$Digest
    )
    if ($PSVersionTable.PSVersion.Major -ge 7) {
        # Convert Digest from base 64 into a byte array (It's just a list of numbers)
        $backwardsByteArray = [convert]::FromBase64String($Digest)
        # Convert each byte in the array, back into it's hex value and merge the stream together to get the hash.
        $Sha1Hash = $backwardsByteArray | ForEach-Object { [convert]::ToHexString($_) } | Out-String -NoNewline
        return $Sha1Hash    
    }
    else {
        # Convert Digest from base 64 into a byte array (It's just a list of numbers)
        $backwardsByteArray = [convert]::FromBase64String($Digest)
        $res = $backwardsByteArray | ForEach-Object { $_ | Format-Hex }
        $res | ForEach-Object { $_.tostring().substring(11, 2) } | ForEach-Object { $Sha1Hash = $Sha1Hash + $_ }
        return $Sha1Hash    
    }
}