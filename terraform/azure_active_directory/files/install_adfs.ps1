$domainName = "${domain_name}"
$domainNetbiosName = "${netbios_name}"
$safeModeAdminstratorPassword = ConvertTo-SecureString "${password}" -AsPlainText -Force

Write-Output "Installing Windows Feature for AD-FS..."

# Install ADFS role
Install-WindowsFeature -Name ADFS-Federation -IncludeManagementTools

# Start ADFS service
Start-Service adfssrv
