
Function Enable-DatabaseEncryption{
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER SqlInstance

    .PARAMETER database

    .EXAMPLE
    Enable-DatabaseEncryption

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
        
        
        
                if($SqlInstance.Databases[$database].DatabaseEncryptionKey.State -eq 'Existing'){
                    
                    If($SqlInstance.Databases[$database].EncryptionEnabled -ne $true ){
                        $SqlInstance.Databases[$database].EncryptionEnabled = $true
                        $SqlInstance.Databases[$database].Alter()
                        $SqlInstance.Databases[$database].Refresh()
                    }
                }
                
                Else{
                    Write-Warning -Message "A database encryption key does not exist for this database. Please use Set-DatabaseEncryptionKey first."
                }
                $properties = @(
                    @{Label='DatabaseName';          Expression={$_.Name} }, 
                    @{Label='DatabaseEncryptionKey'; Expression={If($_.DatabaseEncryptionKey.State -eq 'Existing'){$true} Else{$false}  } },
                    @{Label='EncryptionEnabled';     Expression={$_.EncryptionEnabled}},
                    @{Label='EncryptionState';       Expression={$_.DatabaseEncryptionKey.EncryptionState} }
                )
        
                $SqlInstance.Databases[$database] | Select-Object $properties
        
            }
            Catch{
                Throw
            }
        }
        