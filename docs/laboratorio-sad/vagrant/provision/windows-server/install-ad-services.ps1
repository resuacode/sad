# install-ad-services.ps1 - Instalar Active Directory y servicios críticos

Write-Host "================================================"
Write-Host "Instalando Active Directory y servicios críticos"
Write-Host "================================================"

# Instalar roles de Active Directory
Write-Host "Instalando AD DS..."
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Instalar DNS Server
Write-Host "Instalando DNS Server..."
Install-WindowsFeature -Name DNS -IncludeManagementTools

# Instalar DHCP Server
Write-Host "Instalando DHCP Server..."
Install-WindowsFeature -Name DHCP -IncludeManagementTools

# Instalar Certificate Services (PKI)
Write-Host "Instalando Certificate Services..."
Install-WindowsFeature -Name ADCS-Cert-Authority -IncludeManagementTools

# Instalar File Services
Write-Host "Instalando File Services..."
Install-WindowsFeature -Name FS-FileServer -IncludeManagementTools

# Configurar dominio SAD.local
Write-Host "Configurando dominio SAD.local..."

# Crear contraseña segura para DSRM
$dsrmPassword = ConvertTo-SecureString "DSRMPass123!" -AsPlainText -Force

try {
    # Instalar el bosque de Active Directory
    Install-ADDSForest `
        -DomainName "sad.local" `
        -DomainNetbiosName "SAD" `
        -SafeModeAdministratorPassword $dsrmPassword `
        -InstallDns:$true `
        -NoRebootOnCompletion:$false `
        -Force:$true
        
    Write-Host "Active Directory configurado correctamente"
} catch {
    Write-Host "Error configurando AD: $($_.Exception.Message)"
}

# Configurar DHCP (ejecutar después del reinicio)
# Este script se ejecutará en el próximo arranque
$startupScript = @"
# Configurar DHCP después del reinicio
Add-DhcpServerv4Scope -Name "Lab Network" -StartRange 192.168.56.50 -EndRange 192.168.56.100 -SubnetMask 255.255.255.0
Set-DhcpServerv4OptionValue -DnsServer 192.168.56.11 -Router 192.168.56.1
Restart-Service dhcp
"@

$startupScript | Out-File -FilePath "C:\Windows\System32\configure-dhcp.ps1"

# Configurar Certificate Authority después del reinicio
$caScript = @"
# Configurar CA después del reinicio
Install-AdcsCertificationAuthority -CAType EnterpriseRootCA -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" -KeyLength 2048 -HashAlgorithmName SHA256 -ValidityPeriod Years -ValidityPeriodUnits 10 -Force
"@

$caScript | Out-File -FilePath "C:\Windows\System32\configure-ca.ps1"

Write-Host "Servicios de Windows Server instalados"
Write-Host "El servidor se reiniciará para completar la configuración de AD"