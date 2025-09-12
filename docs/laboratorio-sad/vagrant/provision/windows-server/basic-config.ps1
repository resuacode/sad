# Configuración básica de Windows Server 2019/2022

Write-Host "======================================="
Write-Host "Configurando Windows Server para lab"
Write-Host "======================================="

# Configurar zona horaria
Set-TimeZone -Name "Romance Standard Time"

# Configurar red estática
$adapter = Get-NetAdapter | Where-Object {$_.Name -like "*Ethernet*" -and $_.Status -eq "Up"} | Select-Object -First 1
if ($adapter) {
    Remove-NetIPAddress -InterfaceAlias $adapter.Name -Confirm:$false -ErrorAction SilentlyContinue
    Remove-NetRoute -InterfaceAlias $adapter.Name -Confirm:$false -ErrorAction SilentlyContinue
    New-NetIPAddress -InterfaceAlias $adapter.Name -IPAddress "192.168.56.11" -PrefixLength 24 -DefaultGateway "192.168.56.1"
    Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ServerAddresses "8.8.8.8", "8.8.4.4"
}

# Desactivar Windows Defender (solo para laboratorio)
Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue
Set-MpPreference -DisableIOAVProtection $true -ErrorAction SilentlyContinue

# Configurar firewall básico
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

# Habilitar RDP
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Configurar usuarios de laboratorio
$Password = ConvertTo-SecureString "Password123!" -AsPlainText -Force

# Usuario administrador de laboratorio
New-LocalUser -Name "labadmin" -Password $Password -FullName "Lab Administrator" -Description "Administrador del laboratorio"
Add-LocalGroupMember -Group "Administrators" -Member "labadmin"

# Usuario estándar para pruebas
New-LocalUser -Name "labuser" -Password $Password -FullName "Lab User" -Description "Usuario estándar del laboratorio"
Add-LocalGroupMember -Group "Users" -Member "labuser"

# Configurar carpetas compartidas vulnerables para ejercicios
New-Item -ItemType Directory -Path "C:\Shares\Public" -Force
New-Item -ItemType Directory -Path "C:\Shares\Admin" -Force
New-SmbShare -Name "Public" -Path "C:\Shares\Public" -FullAccess "Everyone"
New-SmbShare -Name "Admin" -Path "C:\Shares\Admin" -FullAccess "Administrators"

# Crear archivos de ejemplo con información sensible (para ejercicios)
@"
Archivo de configuración del servidor
Usuario: admin
Password: admin123
Base de datos: server-db
"@ | Out-File -FilePath "C:\Shares\Public\config.txt" -Encoding UTF8

@"
Lista de usuarios del dominio:
- Administrator
- labadmin (Administrador)
- labuser (Usuario estándar)
- guest (Deshabilitado)
"@ | Out-File -FilePath "C:\Shares\Admin\users.txt" -Encoding UTF8

Write-Host "Configuración básica completada"
