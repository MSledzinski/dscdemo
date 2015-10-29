Configuration WebServer
{
    Import-DscResource –ModuleName ’PSDesiredStateConfiguration’

    Node $NodeNames 
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
    }
}

$NodeNames = 's1', 's2'
$OutPath = 'c:/DSC/IIS'

WebServer -OutputPath $OutPath

cd $OutPath

return

# o -wait runs as backgoruind job in ps 
Start-DscConfiguration -Path $OutPath -ComputerName 's1' -Verbose -Wait

# verbose output 

Test-DscConfiguration -Path $OutPath -ComputerName 's1'


invoke-command -ComputerName 's1' -ScriptBlock { Remove-Item "c:/temp"  }