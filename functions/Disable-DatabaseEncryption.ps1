
Function Disable-DatabaseEncryption{
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER SqlInstance

    .PARAMETER database

    .EXAMPLE
    Disable-DatabaseEncryption

    .NOTES
        Author : Bert Van Landeghem
        Date   : 2018-02-07 
        To Do: 
    #>

    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory                       = $true,
            Position                        = 0,
            ValueFromPipeline               = $true,
            ValueFromPipelineByPropertyName = $true
            )]
        [Alias("Instance")]
        $SqlInstance,

        [Parameter(
            Mandatory                       = $false,
            Position                        = 1,
            ValueFromPipelineByPropertyName = $true
            )]
            [string]$database # rework to array [string[]]

            )
        
            Try{
                If($SqlInstance.Databases[$database].EncryptionEnabled -ne $false){
                    $SqlInstance.Databases[$database].EncryptionEnabled = $false
                    $SqlInstance.Databases[$database].Alter()
                    $SqlInstance.Databases[$database].Refresh()
                }
        
                $properties = @(
                    @{Label='DatabaseName';          Expression={$_.Name} }, 
                    @{Label='DatabaseEncryptionKey'; Expression={If($_.DatabaseEncryptionKey.State -eq 'Existing'){$true} Else{$false}  } },
                    @{Label='EncryptionEnabled';     Expression={$_.EncryptionEnabled}                     },
                    @{Label='EncryptionState';       Expression={$_.DatabaseEncryptionKey.EncryptionState} }
                )
        
                $SqlInstance.Databases[$database] | Select-Object $properties
        
            }
            Catch{
                Throw
            }
        }
        