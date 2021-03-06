
Function Remove-DatabaseEncryptionKey{
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER SqlInstance

    .PARAMETER database

    .EXAMPLE
    Remove-DatabaseEncryptionKey

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
        # $SqlInstance.Databases[$database].DatabaseEncryptionKey.DropIfExists() # SQL Server 2016
        
        If($SqlInstance.Databases[$database].DatabaseEncryptionKey.State -eq 'Existing'){
            
            $SqlInstance.Databases[$database].DatabaseEncryptionKey.Drop() # SQL Server 2016

        }


    }
    Catch{
        throw
    }
}
