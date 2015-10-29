Configuration DevEnvironment
{
    Import-DscResource –ModuleName PSDesiredStateConfiguration
    Import-DscResource -Module cChoco  
    Import-DscResource -Module xSqlPs

    Node DevWorkstation
    {
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
