
Function Set-DatabaseEncryptionKey{
    <#
    .SYNOPSIS

    .DESCRIPTION

    .PARAMETER SqlInstance

    .PARAMETER database

    .EXAMPLE
    Set-DatabaseEncryptionKey

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
        [string]$database,  # rework to array [string[]]

        [Parameter(
            Mandatory                       = $false,
            Position                        = 2,
            ValueFromPipelineByPropertyName = $true
            )]
        [string]$EncryptingCertificateName  = "TDE_Cert" #currently fixed name we're using.
    )
    Try{

        # Defaults to ServerCertificate encryption type (SQL certificate)
        # once testable, we can differentiate to ServerAsymmetricKey using Safenet EKM

        $EncryptorName = $EncryptingCertificateName

        If( $SqlInstance.Databases[$database].DatabaseEncryptionKey.State -ne 'Existing')
        {
            $DatabaseEncryptionKey                     = New-Object Microsoft.SqlServer.Management.Smo.DatabaseEncryptionKey
            $DatabaseEncryptionKey.Parent              = $SqlInstance.Databases[$database]
            $DatabaseEncryptionKey.EncryptorName       = $EncryptorName
            $DatabaseEncryptionKey.EncryptionType      = [Microsoft.SqlServer.Management.Smo.DatabaseEncryptionType]::ServerCertificate
            $DatabaseEncryptionKey.EncryptionAlgorithm = [Microsoft.SqlServer.Management.Smo.DatabaseEncryptionAlgorithm]::Aes256
            $DatabaseEncryptionKey.Create()
            $DatabaseEncryptionKey.Refresh()
        }   

        $Returnroperties = @(
            'EncryptionAlgorithm' ,  
            'EncryptionState',       
            'EncryptorName',         
            'EncryptionType',        
            'CreateDate',            
            'ModifyDate',            
            @{Label='Thumbprint'  ;       Expression={$bytes = [System.Text.Encoding]::Unicode.GetBytes($_.Thumbprint) ; [System.Text.Encoding]::ASCII.GetString( $bytes) }},      
            'State'                 
        )


        $SqlInstance.Databases[$database].DatabaseEncryptionKey | Select-Object $Returnroperties

    }
    Catch{
        throw
    }
}