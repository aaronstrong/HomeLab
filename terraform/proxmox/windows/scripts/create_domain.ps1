$domainName = "contoso.local"
$netbiosName = "contoso"
$safeModeAdminstratorPassword = ConvertTo-SecureString 'BestCloud1!' -AsPlainText -Force
$logpath = "C:\log\log.txt"
$domainMode = "Win2025"
$forestMode = "Win2025"

# Install Module
Install_WindowsFeature -Name AD-Domain-Services, DNS -IncludeManagementTools
Install-WindowsFeature -Name RSAT-AD-PowerShell -IncludeManagementTools

# Import Active Directory Module into the PowerShell Session
Import-Module ActiveDirectory

# Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false  `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode $domainMode -ForestMode $forestMode `
-DomainName $domainName `
-DomainNetbiosName $netbiosname `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-SafeModeAdministratorPassword $safeModeAdminstratorPassword `
-Force:$true