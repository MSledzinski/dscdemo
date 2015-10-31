Configuration DevEnvironment
{
    Import-DscResource –ModuleName PSDesiredStateConfiguration
    Import-DscResource -Module cChoco  
    Import-DscResource -Module xSqlPs

    Node DevWorkstation
    {
          # problem with windows 8.1 - no servermanager, but dism
          WindowsFeature IIS 
          { 
            Ensure = "Present" 
            Name = "Web-Server"                       
          } 
            
          cChocoInstaller InstallCheco
          {
            InstallDir = "c:\choco"
          }

          cChocoPackageInstaller InstallGit
          {
            Name = "git.install"
            DependsOn = "[cChocoInstaller]installChoco"
          } 

          xSqlServerInstall SqlServerLocal
          {
            SourcePath = "share_with_installer/sqlserver.exe"
            # ...
          }
    }
}
