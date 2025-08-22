# From Jordan Benzing
function Get-HashFromDigest {
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