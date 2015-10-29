Configuration CustomLogDirectory
{
        Import-DscResource –ModuleName PSDesiredStateConfiguration

        # it is not parametrized as this describes set of machines not particular ones
        Node CustomLogsDirNodes
        {
            File CustomLogs 
            {
               Ensure = 'Present'
               Type = 'Directory'
               DestinationPath = 'c:/CustomLogs'
               Attributes = 'Archive'
            }

            Log AfterDirectoryCreate
            {
                #Microsoft-Windows-Desired State Configuration/Analytic log
                Message = "Created custom logs dir as part of DSC run"
                DependsOn = '[File]CustomLogs' #no guarantee that execution will be top->bottom
            }
        }
}

$nodeName = "fp-pc2686.fp.lan"

$outp = 'c:/DSC/HTTP'
CustomLogDirectory -OutputPath $outp


cd $outp

# after MOF is built - that describes our desired state on nodes that needs to support custom log dir

# get configurationid for the client
$guid = Get-DscLocalConfigurationManager -CimSession $nodeName | % ConfigurationID
$destination = "$env:PROGRAMFILES/WindowsPowerShell/DscService/Configuration/$guid.mof"

# copy our mof as <configuration id>.mof
Copy-Item -Path "$oput/CustomLogsDirNodes.mof" -Destination "$destination"

# generate checksum file, change for every config change
New-DscChecksum $destination

# manual update invoke - but not config passed this time
Update-DscConfiguration -ComputerName $nodeName -Wait -Verbose


# dsc query node status
Get-DscConfigurationStatus -CimSession $nodeName -All

Get-WinEvent -ProviderName "Microsoft-Windows-DSC" -ComputerName $nodeName -MaxEvents 10
# xDSCEventLog module - new diary for more details of details 


# better way to see all
import-module powershellcookbook
Show-Object (Get-DscConfigurationStatus -CimSession $nodeName)


#what if module that is not no a target
