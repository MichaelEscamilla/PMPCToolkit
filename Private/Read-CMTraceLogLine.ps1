<#
.SYNOPSIS
    Reads a specific line from a CMTrace log file.
.DESCRIPTION
    This function reads line data from a CMTrace formated log file and returns the line content in an object.
.NOTES
    Author: Michael Escamilla
    Date: 2025-07-17
#>
function Read-CMTraceLogLine {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $LineContent
    )
    
    #Create an Enum for the diffrent log levels
    Add-Type -TypeDefinition @"
    public enum LogType
    {
        None,
        Informational,
        Warning,
        Error
     }
"@
    #endregion

    # Validate that the input is CMTrace formatted
    $FormatPattern = "LOG\[(.*?)\]LOG(.*?)time(.*?)date"

    if (([Regex]::Match($LineContent, $FormatPattern)).Success -eq $true) { 
        # Split each Logentry into an array since each entry can span over multiple lines
        $logarray = $LineContent -split "<!"
        foreach ($logline in $logarray) {
            if ($logline) {            
                # split Log text and meta data values
                $metadata = $logline -split "><"

                # Clean up Log text by stripping the start and end of each entry
                $logtext = ($metadata[0]).Substring(0, ($metadata[0]).Length - 6).Substring(5)
            
                # Split metadata into an array
                $metaarray = $metadata[1] -split '"'

                # Rebuild the result into a custom PSObject
                $result += $logtext | select-object @{
                    Label = "LogText"; Expression = { $logtext } },
                    @{Label = "Type"; Expression = { [LogType]$metaarray[9] } },
                    @{Label = "Component"; Expression = { $metaarray[5] } },
                    @{Label = "DateTime"; Expression = { [datetime]::ParseExact(($metaarray[3] + $metaarray[1]).ToString(), "MM-dd-yyyyHH:mm:ss.ffffff", $null) } },
                    @{Label = "Thread"; Expression = { $metaarray[11] } }
            }        
        }

        return $result
    }
}