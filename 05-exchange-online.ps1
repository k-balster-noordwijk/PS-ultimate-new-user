# i.v.m. licentie ExchangeOnline (zie membership rules dynamische groep License_Exchange_Online)
if ($teamstelefonie -eq 'nee' -and $mailbox -eq 'ja') {Set-ADUser -server ads-001.noordwijk.local -Identity $samaccountname -OfficePhone "+31713660"}

# Aanmaken mailbox on premise
timestamp ; Write-Host "Mailbox wordt aangemaakt, moment geduld.." -ForegroundColor yellow
$scriptBlock = {
    . .\Output.ps1
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "http://exc-001.noordwijk.local/PowerShell/" -Authentication Kerberos
    Import-PSSession $Session -DisableNameChecking | Out-Null
    Enable-RemoteMailbox -Identity "$samaccountname@noordwijk.nl" -RemoteRoutingAddress "$samaccountname@noordwijknl.mail.onmicrosoft.com" | Out-Null
    Remove-PSSession $Session 
    }  
Start-Process Powershell.exe -NoNewWindow -ArgumentList ("-ExecutionPolicy Bypass -noninteractive -noprofile " + $scriptBlock) -PassThru -Wait | Out-Null

# wachten totdat de mailbox is aangemaakt aan de EXO kant..
$exomailbox = Get-EXOMailbox -Identity "$samaccountname@noordwijk.nl" -ErrorAction silentlycontinue
if ($null -eq $exomailbox){
do {$exomailbox = Get-EXOMailbox -Identity "$samaccountname@noordwijk.nl" -ErrorAction silentlycontinue}
until ($null -ne $exomailbox)
timestamp ; Write-Host "Mailbox $samaccountname@noordwijk.nl succesvol aangemaakt.." -ForegroundColor Green
}

# maiblox default config
Get-EXOMailbox -Identity "$samaccountname@noordwijk.nl" | Set-MailboxRegionalConfiguration -Language "nl-NL" -LocalizeDefaultFolderName | Out-Null

# aanpassen standaard agenda rechten
Set-MailboxFolderPermission -Identity "$samaccountname@noordwijk.nl:\Agenda" -User Default -AccessRights LimitedDetails | Out-Null
Add-MailboxFolderPermission -Identity "$samaccountname@noordwijk.nl:\Agenda" -User klantcontact -AccessRights Reviewer | Out-Null

# Netjes afsluiten van de Powershell sessie
Disconnect-ExchangeOnline -Confirm:$false | Out-Null