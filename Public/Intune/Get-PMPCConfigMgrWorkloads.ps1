<#
.SYNOPSIS
    Evaluates ConfigMgr co-management workload capability values and returns the associated workload names.

.DESCRIPTION
    Converts one or more integer capability values from ConfigMgr co-management into human-readable workload names.
    Uses a flags-based enumeration to decode which workloads are offloaded to Intune based on the capability number.
    Supports ConfigMgr 2111 and later.

.PARAMETER capability
    One or more integer capability values to evaluate. Valid range is 1 to 12543.
    A value of 1 indicates co-management is disabled.
    A value of 8193 indicates co-management is enabled with no workloads offloaded.
    Values greater than 8193 represent specific workloads offloaded to Intune.

.OUTPUTS
    System.Collections.Specialized.OrderedDictionary
    Returns an ordered hashtable where each key is the input capability number (as a string)
    and each value is an array of matching workload name strings.

.EXAMPLE
    Get-PMPCConfigMgrWorkloads -capability 8257

    Returns the workloads offloaded to Intune for capability value 8257.

.EXAMPLE
    Get-PMPCConfigMgrWorkloads -capability 8193, 8257, 8321

    Evaluates multiple capability values and returns an ordered hashtable with results for each.


.NOTES
    Workload flags are based on ConfigMgr 2111+.
    CoMgmt_Enabled (8193) is filtered from results when other workloads are present, as its presence is implied.

    ##### From MSEndpointMgr - Ben Whitmore ######
    # https://msendpointmgr.com/2023/02/04/co-management-workloads-capabilities/
#>
Function Get-PMPCConfigMgrWorkloads {
       [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateRange(1,12543)]
        [Int32[]]$capability
    )

    #Create enumurator for workload flags // ConfigMgr 2111+
    [flags()] Enum workloads {
        CoMgmt_Enabled = 8193
        Compliance_Policies = 2
        Resource_Access_Policies = 4
        Device_Configuration = 8
        Windows_Update_Policies = 16
        Client_Apps = 64
        Office_Click2Run_Apps = 128
        Endpoint_Protection = 4128
    }

    #Create an ordered hash table to capture all capabilities
    $allCapabilities = [Ordered]@{}

    ForEach ($capNum in $capability) {

        #Evaluate capabilities 
        If ($capNum -eq 1) {
            $capResult = @("CoMgmt_Disabled")

            #Build hash table of results
            $allCapabilities.Add([string]$capNum, $capResult)
        }
        elseIf ($capNum -eq 8193) {
            $capResult = @("CoMgmt_Enabled_NoWorkloads")

            #Build hash table of results
            $allCapabilities.Add([string]$capNum, $capResult)
        }
        elseIf ($capNum -lt 8193) {
            $capResult = @("Invalid_Workload_Value")

            #Build hash table of results
            $allCapabilities.Add([string]$capNum, $capResult)
        }
        else {
            Try {
                $workload = [workloads]$capNum

                #Build data if a valid flag is matched
                If ($workload -like "*_*") {
              
                    #Filter out CoMgmt_Enabled value - we assume it is enabled if we have a workload match
                    $capabilities = $workload -split ', ' -notmatch 'CoMgmt_Enabled'

                    #Tidy up and export capabilities sorted to an array
                    $capabilities = $capabilities | Sort-Object
                    $capResult = @($capabilities)

                    #Build hash table of results
                    $allCapabilities.Add([string]$capNum, $capResult)
                }
            }
            Catch {
                #Do Nothing, ignore invalid values
            }
        }
    }
    Return $allCapabilities
}