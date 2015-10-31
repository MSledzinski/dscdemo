# litlle bit about resource - test, get, set, report

Configuration WebServer
{
    Import-DscResource –ModuleName ’PSDesiredStateConfiguration’

    Node vm-ms-dsc2.fp.lan 
    {
        WindowsFeature IIS 
        {
            Ensure = 'Present'
            Name = 'Web-Server'
        }

        File CustomLogs 
        {
           Ensure = 'Present'
           Type = 'Directory'
           DestinationPath = 'c:/CustomLogs'
           Attributes = 'Archive'
        }

        Registry RegistryExample
        {
            Ensure = "Present" 
            Key = "HKEY_LOCAL_MACHINE\SOFTWARE\WebCustomKey"
            ValueName = "LogFolder"
            ValueData = "c:/CustomLogs"
        }
    }
}

$OutPath = 'c:/DSC/IIS'

WebServer -OutputPath $OutPath

cd $OutPath

# no meta in MOF name

# !! check features on machine

Test-DscConfiguration -Path $OutPath -ComputerName vm-ms-dsc2.fp.lan -Verbose

# o -wait runs as background job in ps 
Start-DscConfiguration -Path $OutPath -ComputerName vm-ms-dsc2.fp.lan -Verbose -Wait

# verbose output 

Test-DscConfiguration -Path $OutPath -ComputerName vm-ms-dsc2.fp.lan | % ResourcesNotInDesiredState | Format-List

# evil guy comes to box and...
invoke-command -ComputerName vm-ms-dsc2.fp.lan -ScriptBlock { Remove-Item "c:/CustomLogs"  }