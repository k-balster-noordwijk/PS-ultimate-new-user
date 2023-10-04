$outputfile = Test-Path -Path .\Output.ps1 -PathType Leaf
if ($outputfile -like "False") {Clear-Host ; Write-Warning "Aanmaken gebruiker geannuleerd.."  ; $LASTEXITCODE = 2 ;  Exit }

# Checks of het account niet al bestaat en zo niet dan aanmaken
# AD ACCOUNT CHECK
$AllADUsers = Get-ADUser -Server ads-001.noordwijk.local -Filter * -SearchBase "DC=noordwijk,DC=local" | Select-Object -ExpandProperty SamAccountName
if ($AllADUsers -match $samaccountname) {$samaccountname = $initialen.ToLower().SubString(0,2)+".$achternaamzonderspaties".ToLower()}
if ($AllADUsers -match $samaccountname) {$samaccountname = $initialen.ToLower().SubString(0,3)+".$achternaamzonderspaties".ToLower()}
if ($AllADUsers -match $samaccountname) {Clear-Host ; Write-Warning "$samaccountname lijkt al te bestaan" ; $LASTEXITCODE = 2 ;  Exit}

# EMAIL / ALIAS CHECK
$mailaccount = Get-ADObject -Properties mail, proxyAddresses -Filter {mail -eq "$samaccountname@noordwijk.nl" -or proxyAddresses -eq "smtp:$samaccountname@noordwijk.nl"} | Select-Object -ExpandProperty mail
if ($null -ne ($mailaccount)) {Clear-Host ; Write-Warning "Mail account of alias bestaat al"  ; $LASTEXITCODE = 2 ;  Exit }

# USERFOLDERS CHECKS
$userprofilecheck = Test-Path "\\fil-001\profiles$\$samaccountname"
$userhomedircheck = Test-Path "\\fil-001\users$\$samaccountname"
$userdesktopcheck = Test-Path "\\fil-001\userfolders$\userdesktop\$samaccountname"
$usertempcheck = Test-Path "\\fil-001\userfolders$\usertemp\$samaccountname"

#USERFOLDERS PATHS
$userprofilepath = "\\fil-001\profiles$\$samaccountname"
$userhomedirpath = "\\fil-001\users$\$samaccountname"
$userdesktoppath = "\\fil-001\userfolders$\userdesktop\$samaccountname"
$usertemppath = "\\fil-001\userfolders$\usertemp\$samaccountname"

#USERFOLDERS CHECK WARNING IF EXISTS
if (($userprofilecheck ) -contains $True) {$userprofileexist = "$userprofilepath"}
if (($userhomedircheck) -contains $True) {$userhomedirexist = "$userhomedirpath"}
if (($userdesktopcheck) -contains $True) {$userdesktopexist = "$userdesktoppath"}
if (($usertempcheck) -contains $True) {$usertempexist = "$usertemppath"}

$userfolders = @(
"`n","Let op! de volgende paden bestaan al:",
"`n",
"`n",$userprofileexist
"`n",$userhomedirexist
"`n",$userdesktopexist
"`n",$usertempexist
"`n",
"`n","Wil je bovenstaande map(pen) verwijderen?"
)

if (($userprofilecheck -or $userhomedircheck -or $userdesktopcheck -or $usertempcheck) -contains $True) {$verificatie = Show-MessageBox -Title 'Userfolders bestaan al' -Message $userfolders -Icon Warning -Buttons YesNoCancel}

if ($verificatie -eq "Cancel") {Clear-Host ; Write-Warning "Aanmaken gebruiker geannuleerd.." ; $LASTEXITCODE = 2;  Exit}

#USERFOLDERS DELETE
if ($verificatie -eq 'Yes'){
Remove-Item -Recurse -Force "$userprofilepath" -ErrorAction silentlycontinue
Remove-Item -Recurse -Force "$userhomedirpath" -ErrorAction silentlycontinue
Remove-Item -Recurse -Force "$userdesktoppath" -ErrorAction silentlycontinue
Remove-Item -Recurse -Force "$usertemppath" -ErrorAction silentlycontinue
timestamp ; Write-Host "Userfolders succesvol verwijderd" -ForegroundColor green
}

# Na alle userchecks gaan we verbinden met de eventuele clouddiensten
# Teams
if ($teamstelefonie -eq 'ja') 
{
timestamp ; Write-Host "Inloggen op Teams Admin Center.." -ForegroundColor yellow
try {connect-MicrosoftTeams -ErrorAction Stop | Out-Null} catch {if ($_.FullyQualifiedErrorId -eq "Connect-MicrosoftTeams,Microsoft.TeamsCmdlets.Powershell.Connect.ConnectMicrosoftTeams") {Clear-Host ; timestamp ; Write-Warning "Invullen credentials geannuleerd.." ; $LASTEXITCODE = 2; Exit }}
try {$teamscon = Get-AssociatedTeam -ErrorAction Stop} catch {timestamp ; Write-Warning "Inloggen op Teams Admin Center mislukt.." ; $LASTEXITCODE = 1 ; Exit}
if ($null -ne $teamscon) {timestamp ; Write-Host "Succesvol verbonden met Teams Admin Center.." -ForegroundColor green}
}
# Azure AD
if ($teamstelefonie -eq 'ja') 
{
timestamp ; Write-Host "Inloggen op Azure AD.." -ForegroundColor yellow
try {connect-AzureAD -ErrorAction Stop | Out-Null} catch {if ($_.FullyQualifiedErrorId -eq "Connect-AzureAD,Microsoft.Open.Azure.AD.CommonLibrary.ConnectAzureAD") {Clear-Host ; timestamp ; Write-Warning "Invullen credentials geannuleerd.." ; $LASTEXITCODE = 2; Exit}}
try {$aadcon = Get-AzureADTenantDetail -ErrorAction Stop} catch {timestamp ; Write-Warning "Inloggen op Azure AD mislukt.." ; $LASTEXITCODE = 1 ; Exit}
if ($null -ne $aadcon) {timestamp ; Write-Host "Succesvol verbonden met Azure AD.." -ForegroundColor green}
}
# Exchange Online, deze moet als laatste anders krijg je fouten!!
if ($mailbox -eq 'ja') 
{
timestamp ; Write-Host "Inloggen op Exchange Online.." -ForegroundColor yellow
try {Connect-ExchangeOnline -ShowBanner:$false -ErrorAction Stop | Out-Null} catch {$_.Exception.InnerException ; Clear-Host ; timestamp ; Write-Warning "Invullen credentials geannuleerd.." ; $LASTEXITCODE = 2; Exit}
try {$exocon = Get-EXOMailbox -ResultSize 1 -ErrorAction Stop} catch {timestamp ; Write-Warning "Inloggen op Exchange Online mislukt.." ; $LASTEXITCODE = 1 ; Exit}
if ($null -ne $exocon) {timestamp ; Write-Host "Succesvol verbonden met Exchange Online.." -ForegroundColor green}
}