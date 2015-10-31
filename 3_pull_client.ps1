# guid - machine will use guid to reach out to server to get information, 'I am the guid' , it can be node, role ,environment or other
# first - machine will introduce as name of fqdn - so they go to a property bag of identity claims that was growing - only a platform
[DSCLocalConfigurationManager()]
Configuration LCM_HTTP_Pull
{
    param(
         [Parameter(Mandatory=$true)]
         [string[]]$nodeNames,

         [Parameter(Mandatory=$true)]
         [string]$guid)

    Node $nodeNames
    {
        Settings
        {
            # guid for configuration
            ConfigurationID = $guid

            AllowModuleOverwrite = $true
            ConfigurationMode = 'ApplyAndAutoCorrect'

            # set as pull mode
            RefreshMode = 'Pull'
            RefreshFrequencyMins = 30
        }

        <#
        ConfigurationRepositoryShare DSCSMB 
        {
            Name = 'DSCSMB'
            SourcePath = '\\machine\smb_repo'
        }
        #>

        ConfigurationRepositoryWeb DSCHTTP
        {
            ServerURL = 'http://vm-ms-dsc1:8080/PSDSCPullServer.svc'
            AllowUnsecureConnection = $true
        }
    }
}

$nodeNames = "vm-ms-dsc2.fp.lan"
$guid = [guid]::NewGuid()
$outp = "c:/DSC/HTTP"

LCM_HTTP_Pull -nodeNames $nodeNames -guid $guid -OutputPath $outp

# when mof is built
Set-DscLocalConfigurationManager -ComputerName $nodeNames -Path $outp -Verbose