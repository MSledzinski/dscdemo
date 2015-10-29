# xPsDscConfiguration modukle
# xDscWebService to setup server
Configuration HTTPPullServer 
{
    Import-DscResource –ModuleName ’PSDesiredStateConfiguration’
    Import-DscResource -ModuleName xPSDesiredStateConfiguration 

    Node localhost
    {
         WindowsFeature DSCServiceFeature
         {
            Ensure = "Present"
            Name = "DSC-Service"
         }

         # pull server definition - most of the values are default ones
         xDscWebService PSDSCPullServer
         {
            Ensure = "Present"
            EndpointName = "PSDSCPullServer"
            Port = 8080
            PhysicalPath = "$env:SystemDrive/inetpub/wwwroot/PSDSCPullServer"
            CertificateThumbPrint = "AllowUnencriptedTraffic" # bad idea, I know :)
            ModulePath = "$env:PROGRAMFILES/WindowsPowerShell/DscService/Modules"
            ConfigurationPath = "$env:PROGRAMFILES/WindowsPowerShell/DscService/Configuration"
            State = "Started"
            DependsOn = "[WindowsFeature]DSCServiceFeature"
         }

         # reporting server definition - most of the values are default ones
         xDscWebService PSDSCComplianceServer
         {
            Ensure = "Present"
            EndpointName = "PSDComplianceServer"
            Port = 9080
            PhysicalPath = "$env:SystemDrive/inetpub/wwwroot/PSDComplianceServer"
            CertificateThumbPrint = "AllowUnencriptedTraffic"
            State = "Started"
            DependsOn = ("[WindowsFeature]DSCServiceFeature", "[xDscWebService]PSDSCPullServer")
         }
    }
}

# build MOF
HTTPPullServer -OutputPath "c:/DSC/HTTP"
cd "c:/DSC/HTTP"
 

# start
Start-DscConfiguration -Path "c:/DSC/HTTP" -ComputerName localhost -Verbose -Wait

#Start-Process -FilePath iexplorer.exe  "http://localhost:8080/PSDSCPullServer.svc"

# odata helper 
# export-odataendpointproxy