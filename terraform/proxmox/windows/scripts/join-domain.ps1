# PowerShell script to join a Windows Server 2025 to an Active Directory Domain

# Step 1: Define the necessary variables
$domainName = "contoso.local"  # Change this to your domain name
$domainAdminUser = "Administrator"  # Change this to a domain admin username
$domainAdminPassword = "P@ssw0rd"  # Change this to the domain admin password

# Convert the password to a secure string
$securePassword = ConvertTo-SecureString $domainAdminPassword -AsPlainText -Force

# Step 2: Create the credentials object
$domainCredential = New-Object System.Management.Automation.PSCredential($domainAdminUser, $securePassword)

# Step 3: Join the server to the domain
Add-Computer -DomainName $domainName -Credential $domainCredential -Restart -Force

# Step 4: Confirmation message
Write-Host "The server is being joined to the domain $domainName and will restart shortly."

# The script will automatically restart the server after it successfully joins the domain.
