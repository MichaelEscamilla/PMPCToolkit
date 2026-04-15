    <#
    .SYNOPSIS
        Imports one or more CSV files and loops through each record.

    .DESCRIPTION
        Imports CSV data from the provided path(s) and iterates over every row.
        For each row, the function builds and outputs a PSCustomObject using only
        the CSV column/value pairs. If -ProcessRecord is provided, the script block
        is invoked for each row with three positional arguments in this order:
        RecordObject, RowNumber, Path.

    .PARAMETER Path
        One or more CSV file paths to import.

    .PARAMETER Delimiter
        The CSV delimiter character. Defaults to a comma.

    .PARAMETER ProcessRecord
        Optional script block to run for each record object. Receives three
        positional arguments: RecordObject, RowNumber, Path.

    .EXAMPLE
        Import-PMPCCsvRecords -Path 'C:\Temp\CompName-PMPC-Uninstall-Hive-Export.csv'
    #>
function Import-PMPCInstalledSoftwareCsv {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('FullName')]
        [ValidateNotNullOrEmpty()]
        [string[]]$Path,

        [Parameter()]
        [char]$Delimiter = ',',

        [Parameter()]
        [scriptblock]$ProcessRecord
    )

    begin {
        $ResolvedPaths = [System.Collections.Generic.List[string]]::new()
    }

    process {
        foreach ($ItemPath in $Path) {
            try {
                $CurrentPath = Resolve-Path -Path $ItemPath -ErrorAction Stop
                foreach ($ResolvedPath in $CurrentPath) {
                    $ResolvedPaths.Add($ResolvedPath.Path)
                }
            }
            catch {
                Write-Error "Could not resolve path '$ItemPath'. $($_.Exception.Message)"
            }
        }
    }

    end {
        foreach ($CsvPath in $ResolvedPaths) {
            try {
                $Records = Import-Csv -Path $CsvPath -Delimiter $Delimiter -ErrorAction Stop
            }
            catch {
                Write-Error "Failed to import CSV '$CsvPath'. $($_.Exception.Message)"
                continue
            }

            $RowNumber = 0
            foreach ($Record in $Records) {
                $RowNumber++
                $RecordProperties = [ordered]@{}

                foreach ($Property in $Record.PSObject.Properties) {
                    $RecordProperties[$Property.Name] = $Property.Value
                }

                $RecordObject = [PSCustomObject]$RecordProperties

                if ($PSBoundParameters.ContainsKey('ProcessRecord')) {
                    try {
                        $Result = & $ProcessRecord $RecordObject $RowNumber $CsvPath
                        if ($null -ne $Result) {
                            $Result
                        }
                    }
                    catch {
                        Write-Error "Error processing row $RowNumber in '$CsvPath'. $($_.Exception.Message)"
                    }
                }
                else {
                    $RecordObject
                }
            }
        }
    }
}