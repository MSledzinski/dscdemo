Import-Module PSDesiredStateConfiguration
Get-Command -module PSDesiredStateConfiguration

# installed - from module paths
Get-DscResource

# available
 Find-DscResource -OutVariable r | measure
 $r | ogv

# X... and C...
Install-Module -name cWSMan -verbose

 # show example of module-resource
notepad (Get-DscResource xWebAppPool | Select-Object -ExpandProperty path)

Get-DscResource File -Syntax

 # https://gallery.technet.microsoft.com/scriptcenter/DSC-Resource-Kit-All-c449312d
 # https://github.com/PowerShellOrg

 # interesting cross machine dependencies
Get-DscResource WaitFor*
Get-DscResource WaitForAny -Syntax