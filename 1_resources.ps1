import-module PSDesiredStateConfiguration
get-command PSDesiredStateConfiguration

# installed
Get-DscResource

# available
 Find-DscResource -OutVariable r | measure
 $r | ogv

# X... and C...
 install-module -name cwsman -verbose

 # show example of module-resource
 explorer (Get-DscResource cWSManListener | Select-Object path)