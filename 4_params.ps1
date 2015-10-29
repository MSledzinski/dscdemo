# parametrized configurations 25:00
# mixture of decaltrative and imperative approach - not one right way to use this

# no params
Configuration Params1
{
    Service A
    {
        Name = 'A'
        Ensure = 'Present'
        State = 'Running'
    }

    Service B
    {
        Name = 'B'
        Ensure = 'Present'
        State = 'Running'
    }

    #.... Service N {}
}

# simple params - like in functions - we are getting more imperative
Configuration Params2
{
    param(
        [Parameter(Mandatory = $true)][string[]]$serviceNames
    )


    foreach($name in $serviceNames)
    {
        Service $name
        {
            Name = $name
            Ensure = 'Present'
            State = 'Running'
        }
    }
}

Configuration Params3
{
    # so configuration can become a resource
    Params2 services
    {
        serviceNames = "A", "B", "C"
    }
}


# complicated params - environments
# can be in separate file psd1
$DevConfigData = @{
    AllNodes = @(
        @{
            # node name
            NodeName = "*"

            # set of attrbiutes for all nodes
            # ...
        },

        @{
            NodeName = "dev-vm-1"
            Role = "WebServer"
            SiteName = "devvm1"
        },
        @{
            NodeName = "dev-vm-2"
            Role = "Db"
        }
    );

    NonNodeData = @{
        ConfigFileContent = "dev"
    }
}

$TestConfigData = @{
     AllNodes = @(
        @{
            # node name
            NodeName = "*"

            # set of attrbiutes for all nodes
            # ...
        },

        @{
            NodeName = "test-vm-1"
            Role = "WebServer"
            SiteName = "vm1"

        },
        @{
            NodeName = "test-vm-2"
            Role = "WebServer"
            SiteName = "vm2"
        },
        @{
            NodeName = "test-vm-3"
            Role = "Db"
        }
    );

    NonNodeData = @{
        ConfigFileContent = "test"
    }
}

Configuration EnvConfiguration
{
    Import-DscResource –ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xWebAdministration 

    Node $AllNodes.Where{$_.Role -eq "WebServer"}.NodeName
    {
        WindowsFeature IIS
        {
            Name = "Web-Server"
            Ensure = "Present"
        }

        xWebsite Site
        {
            Name         = $Node.SiteName
            PhysicalPath = $Node.SiteName
            Ensure       = "Present"
            DependsOn = '[WindowsFeature]IIS'
        }    
        
        File ConfigFile
        {
            DestinationPath = "c:/temp/config.txt"
            Contents = $ConfigurationData.NonNodeDAta.ConfigFileContent
        }
    }
}

EnvConfiguration -ConfigurationData $TestConfigData -OutputPath "c:/temp/params"
# EnvConfiguration -ConfigurationData c:/env/test/configdata.psd1 -OutputPath "c:/temp/params"