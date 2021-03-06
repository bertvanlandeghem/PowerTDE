
Function Get-DatabaseEncryption{
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER SqlInstance

    .PARAMETER database

    .EXAMPLE
    Get-DatabaseEncryption

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
        [string[]]$database 

    )
    Begin {
        $ReturnProperties = @(
            @{Label='DatabaseName';          Expression={$_.Name}                                  },
            @{Label='DatabaseEncryptionKey'; Expression={If($_.DatabaseEncryptionKey.State -eq 'Existing'){$true} Else{$false}  } },
            @{Label='EncryptionEnabled';     Expression={$_.EncryptionEnabled}                     },
            @{Label='EncryptionState';       Expression={$_.DatabaseEncryptionKey.EncryptionState} }
        )
    }
    Process{
        # If no database is specified, return the status for all databases
        If($database -eq $null -or [string]::IsNullOrEmpty($database) ){

            $database = $SqlInstance.Databases.Name

        }

        foreach($CurrentDatabase in $database){

            $SqlInstance.Databases[$CurrentDatabase].Refresh()
            $SqlInstance.Databases[$CurrentDatabase] | Select-Object $ReturnProperties
            
        }
    }
}
