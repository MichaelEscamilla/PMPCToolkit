function Invoke-ExpandCAB {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Cab,
        [Parameter(Mandatory = $true)]
        [string]$expectedFile
    )

    Write-Verbose "Expanding CAB File: [$Cab]"

    # Define an Extraction Target Folder
    $TargetFolder = "$Cab.dir"

    # Check if the Target Folder Already Exists
    if (Test-Path -Path $TargetFolder) {
        # Remove the Target Folder
        Remove-Item -Path $TargetFolder -Recurse -Force
        Write-Verbose "Removed folder: [$TargetFolder]"
    }
    Write-Verbose "Expanding [$Cab] to [$TargetFolder]"

    # Create the Target Folder
    New-Item -Force $TargetFolder -ItemType Directory | Out-Null
    Write-Verbose "Created folder: [$TargetFolder]"

    
    $Shell = New-Object -ComObject Shell.Application
    $Exception = $null
    try {
        if ($Shell) {
            $SourceCab = $Shell.NameSpace($Cab).Items("PatchMyPC.xml")
            $DestinationFolder = $Shell.NameSpace($TargetFolder)
            $DestinationFolder.CopyHere($SourceCab)
            Write-Verbose "Extracted CAB File: [$Cab] to [$TargetFolder]"
        }
        else {
            throw "Failed to create Shell.Application COM object."
        }
    }
    catch {
        $Exception = $_.Exception
    }
    finally {
        # Release the Shell COM Object
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Shell) | Out-Null
        # This line forces a garbage collection to occur, which attempts to reclaim memory occupied by unreachable objects.
        [System.GC]::Collect()
        # This line forces the garbage collector to wait for all pending finalizers to complete before continuing.
        [System.GC]::WaitForPendingFinalizers()
    }

    # Check if an Error Occurred
    if ($Exception) {
        throw "Failed to decompress $Cab. $($Exception.Message)."
    }

    # Check if the Expected File Exists
    if (!(Test-Path -Path $expectedFile)) {
        throw "Failed to extract the expected file: [$expectedFile]"
    }

    Return $expectedFile
}