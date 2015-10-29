# xPsDscConfiguration modukle
# xDscWebService to setup server
Configuration HTTPPullServer 
{
    Import-DscResource –ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xPSDesiredStateConfiguration 

    Node localhost
    {
        # raw IIS + needed features, no mgmt tools
         WindowsFeature DSCServiceFeature
         {
            Ensure = "Present"
            Name = "DSC-Service"
         }
         
         # pull server definition - most of the values are default ones
         xDSCWebService PSDSCPullServer
         {
            Ensure = "Present"
            EndpointName = "PSDSCPullServer"
            Port = 8080
            PhysicalPath = "$env:SystemDrive/inetpub/PSDSCPullServer"
            CertificateThumbPrint = "AllowUnencryptedTraffic" # bad idea, I know :)
            ModulePath = "$env:PROGRAMFILES/WindowsPowerShell/DscService/Modules"
            ConfigurationPath = "$env:PROGRAMFILES/WindowsPowerShell/DscService/Configuration"
            State = "Started"
            DependsOn = "[WindowsFeature]DSCServiceFeature"
         }

         # reporting server definition - most of the values are default ones
         xDSCWebService PSDSCComplianceServer
         {
            Ensure = "Present"
            EndpointName = "PSDComplianceServer"
            Port = 9080
            PhysicalPath = "$env:SystemDrive/inetpub/PSDComplianceServer"
            CertificateThumbPrint = "AllowUnencryptedTraffic"
            State = "Started"
            IsComplianceServer = $true
            DependsOn = ("[WindowsFeature]DSCServiceFeature", "[xDscWebService]PSDSCPullServer")
         }
    }
}

# build MOF
HTTPPullServer -OutputPath "c:/DSC/HTTP"
cd "c:/DSC/HTTP"
 

# start
Start-DscConfiguration -Path "c:/DSC/HTTP" -ComputerName localhost -Verbose -Force -Wait

# a litlle buit of struggle with isapi handlers and web.config structure (locked secions at parent level) and... after ~1,25h

#  "http://localhost:8080/PSDSCPullServer.svc"

# odata helper 
# export-odataendpointproxy