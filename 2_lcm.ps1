[DSCLocalConfigurationManager()] 
Configuration LCMPush
{
    # in older previews  set differently

    Node vm-ms-dsc2.fp.lan 
    {
        Settings    
        {
            AllowModuleOverwrite = $true
            ConfigurationMode = 'ApplyAndAutoCorrect' # 'ApplyOnce' 'Monitor'
            RefreshMode = 'Push'
            RefreshFrequencyMins = 30
        }
    }
}

$OutPath = 'c:/DSC/LCM'

LCMPush -OutputPath $OutPath 

# show MOF - Meta-Object Facility - http://www.omg.org/spec/MOF/2.4.2/ , instance of OMI in MOF
cd $OutPath 

# set
Set-DscLocalConfigurationManager -ComputerName vm-ms-dsc2.fp.lan -Path $OutPath -Verbose

# check what was set
Get-DscLocalConfigurationManager -CimSession vm-ms-dsc2.fp.lan

# show configuration file on machine
explorer "\\vm-ms-dsc2.fp.lan\c$\windows\system32\configuration"


