$domainName = "contoso.local"
$netbiosName = "contoso"
$safeModeAdminstratorPassword = ConvertTo-SecureString 'BestCloud1!' -AsPlainText -Force
$logpath = "C:\log\log.txt"
$domainMode = "Win2012R2"
$forestMode = "Win2012R2"

# Install Module
Install-WindowsFeature -Name RSAT-AD-PowerShell

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