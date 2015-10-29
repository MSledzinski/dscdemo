[DSCLocalConfigurationManager()] 
Configuration LCMPush
{
    Node $NodeNames 
    {
        Settings    
        {
            AllowModuleOverwrite = $true
            ConfigurationMode = 'ApplyAndAutoCorrect'
            RefreshMode = 'Push'
            RefreshFrequencyMins = 60
        }
    }
}

$NodeNames = 's1', 's2'
$OutPath = 'c:/DSC/LCM'

# genereated metada MOF rather than speficif config MOF - so it runs thru set-dscconfig rather than start-dscconfg

LCMPush -OutputPath $OutPath 

# show MOF
cd $OutPath 

# set
Set-DscLocalConfigurationManager -ComputerName $NodeNames -Path 'c:/DSC/LCM' -Verbose

# check what was set
Get-DscLocalConfigurationManager -CimSession s1, s2

# show configuration file on machine
explorer \\s1\c$\windows\system32\configuration

