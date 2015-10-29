$DscSharePath = "c:/DSC/PULL_SMB"

# configure SMB
New-Item -Path $DscSharePath  -ItemType Directory
New-SmbShare -Name DSCSMB -Path $DscSharePath -ReadAccess Everyone -FullAccess Administrator -Description "Test DSC smb"
