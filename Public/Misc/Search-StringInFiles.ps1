function Search-StringInFiles {
    <#
    .SYNOPSIS
        Searches for a string pattern across files in a directory.

    .DESCRIPTION
        Scans all files in the specified directory for lines matching the given search string.
        Results are displayed using Select-String, with each file's name printed as a header.
        Use the -Recurse switch to search subdirectories as well.

    .PARAMETER SearchString
        The string or regex pattern to search for within file contents.

    .PARAMETER Directory
        The directory to search. Defaults to the current working directory.

    .PARAMETER Recurse
        When specified, searches all subdirectories recursively.

    .EXAMPLE
        Search-StringInFiles -SearchString "error"

        Searches for the word "error" in all files in the current directory.

    .EXAMPLE
        Search-StringInFiles -SearchString "TODO" -Directory "C:\Projects\MyApp" -Recurse

        Recursively searches all files under C:\Projects\MyApp for lines containing "TODO".
    #>
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $SearchString,

        [Parameter(Mandatory = $false)]
        [string]
        $Directory = "$(Get-Location)",

        [Parameter(Mandatory = $false)]
        [switch]
        $Recurse
    )

    $Files = Get-ChildItem -Path $Directory -File -Recurse:$Recurse

    foreach ($file in $Files) {
        Write-Host "#### $($File.Name) ######" -ForegroundColor Cyan
        try {
            Select-String -Path $File.FullName -Pattern $SearchString -ErrorAction Stop
        }
        catch {
            Write-Warning "Could not read file: $($file.FullName). Error: $_"
        }
    }
}