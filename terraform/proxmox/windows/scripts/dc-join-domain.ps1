# Define variables
$DomainName = "yourdomain.com"                # Replace with your actual domain name
$NewNetBIOSName = "NEWNETBIOS"                  # Replace with your desired new NetBIOS name
$SafeModeAdministratorPassword = ConvertTo-SecureString "YourSafeModePassword" -AsPlainText -Force
$Credential = Get-Credential -Message "Enter domain administrator credentials"

# Check and rename computer if necessary
if ($env:COMPUTERNAME -ne $NewNetBIOSName) {
    Write-Host "Current computer name is '$env:COMPUTERNAME'. Renaming to '$NewNetBIOSName'..."
    Rename-Computer -NewName $NewNetBIOSName -Force
    Write-Host "The computer will now restart to apply the new name."
    Restart-Computer -Force
    # Exit the script because a restart is required
    exit
}

# If the computer already has the desired name, continue with the promotion.

# Install Active Directory Domain Services feature (if not already installed)
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Promote the server to a domain controller in an existing domain
Install-ADDSDomainController `
    -DomainName $DomainName `
    -InstallDns `
    -Credential $Credential `
    -SafeModeAdministratorPassword $SafeModeAdministratorPassword `
    -Confirm:$false `
    -Force

Write-Host "Domain Controller setup is complete. The server will now restart."
Restart-Computer -Force
