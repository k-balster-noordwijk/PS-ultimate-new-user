# CONNECTIES MET BENODIGDE SERVERS
$computers = "adc-001.noordwijk.local", "exc-001.noordwijk.local", "ads-001.noordwijk.local"

foreach ($computer in $computers){
    if (Test-WSMan -ComputerName $computer -ErrorAction Ignore) {
        Invoke-Command -ComputerName $computer -ScriptBlock {}
    }
    else {
        Write-Warning "Kan niet verbinden met $computer"
		$LASTEXITCODE = 2;  Exit
    }
}

# Controleren of gebruiker lid is van Domain Admins
if(([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Domain Admins"))
{}
else{Write-Warning "Script moet draaien onder een Domain Admin account.." ; $LASTEXITCODE = 2 ;  Exit}

# Controleren of het script als administrator wordt uitgevoerd
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
[Security.Principal.WindowsBuiltInRole] "Administrator")) {Write-Warning "Script moet draaien met Administrator rechten.." ; $LASTEXITCODE = 2 ;  Exit}

# Powershell modules bijwerken / installeren
timestamp ; Write-Host "Powershell modules worden bijgewerkt, moment geduld..." -ForegroundColor yellow
Install-PackageProvider -Name NuGet -Confirm:$False -Force | Out-Null
if (Get-Module -ListAvailable -Name activedirectory) {} else {Get-WindowsCapability -Name RSAT.ActiveDirectory.* -Online | Add-WindowsCapability -Online | Out-Null}
if (Get-Module -ListAvailable -Name AzureAD) {Update-Module -Name AzureAD -Confirm:$False -Force | Out-Null} else {Install-Module AzureAD -Confirm:$False -Force | Out-Null}
if (Get-Module -ListAvailable -Name MicrosoftTeams) {Update-Module -Name MicrosoftTeams -Confirm:$False -Force | Out-Null} else {Install-Module MicrosoftTeams -Confirm:$False -Force | Out-Null}
if (Get-Module -ListAvailable -Name ExchangeOnlineManagement) {Update-Module -Name ExchangeOnlineManagement -Confirm:$False -Force | Out-Null} else {Install-Module ExchangeOnlineManagement -Confirm:$False -Force | Out-Null}
timestamp ; Write-Host "Powershell modules zijn bijgewerkt.." -ForegroundColor Green