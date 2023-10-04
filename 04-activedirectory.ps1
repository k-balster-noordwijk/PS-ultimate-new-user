# Tbv willekeurig wachtwoord
$unsecurepassword = GenerateStrongPassword (8)
$securepassword = ConvertTo-SecureString -String "$unsecurepassword" -AsPlainText -Force

# Beschikbaar nummer zoeken in de lokale AD
if ($teamstelefonie -eq 'ja') {
timestamp ; Write-Host "Beschikbaar telefoonnummer wordt gecontroleerd, moment geduld.." -ForegroundColor yellow

$Exclude = 000,002,004,005,012,031,090,095,099,100,110,125,150,155,165,196,199,210,218,232,255,289,295,297,429,444,451,477
$randomnummer = ( Get-Random -Minimum 0 -Maximum 499 ).ToString('000') | Where-Object { $Exclude -notcontains $_}
if ($null -eq $randomnummer) {do {$randomnummer = ( Get-Random -Minimum 0 -Maximum 10 ).ToString('000') | Where-Object { $Exclude -notcontains $_}} until($null -ne $randomnummer)}
$officephone = "+31713660$randomnummer"
$nummeringebruik = Get-ADUser -Filter * -SearchBase "OU=Noordwijk Citrix Users,OU=Noordwijk,DC=noordwijk,DC=local" -properties OfficePhone | Where-Object {($_.OfficePhone -eq $officephone)} | Select-Object -ExpandProperty OfficePhone

if ($officephone -eq $nummeringebruik) {
do
{
$randomnummer = ( Get-Random -Minimum 0 -Maximum 499 ).ToString('000') | Where-Object { $Exclude -notcontains $_}
if ($null -eq $randomnummer) {do {$randomnummer = ( Get-Random -Minimum 0 -Maximum 10 ).ToString('000') | Where-Object { $Exclude -notcontains $_}} until($null -ne $randomnummer)}
$officephone = "+31713660$randomnummer"
$nummeringebruik = Get-ADUser -Filter * -SearchBase "OU=Noordwijk Citrix Users,OU=Noordwijk,DC=noordwijk,DC=local" -properties OfficePhone | Where-Object {($_.OfficePhone -eq $officephone)} | Select-Object -ExpandProperty OfficePhone
}
until($officephone -ne $nummeringebruik)
	}
timestamp ; Write-Host "Beschikbaar telefoonnummer $officephone gevonden.." -ForegroundColor Green
}

# Aanmaken gebruiken en instellen properties
New-ADUser -server ads-001.noordwijk.local -Name "$voornaam $achternaam" -GivenName $voornaam -Surname $achternaam -SamAccountName $samaccountname -UserPrincipalName $samaccountname@noordwijk.nl -Enabled $true -Accountpassword $securepassword -path "OU=Noordwijk Citrix Users,OU=Noordwijk,DC=noordwijk,DC=local"
$User = Get-ADUser -server ads-001.noordwijk.local -Identity $samaccountname -Properties *
$User.description = "$voornaam $achternaam"
$User.initials = "$initialen"
$User.displayname = "$voornaam $achternaam"
$User.pobox = "Postbus 298"
$User.city = "Noordwijk"
$User.state = "Zuid Holland"
$User.postalcode = "2200 AG"
$User.country = "NL"
$User.manager = Get-ADUser -Filter 'Name -eq $clustermanager' | Select-Object -ExpandProperty distinguishedName
$User.department = "$department"
$User.title = "$title"
if ($intern -eq 'ja') {$User.company = "Gemeente Noordwijk"}
if ($teamstelefonie -eq 'ja') {$User.officephone = "$officephone"}
$User.msExchUsageLocation = "NL"
Set-ADUser -Instance $User


# Lid maken van de standaard groepen
$standaardgroepen = 'XenApp Users Noordwijk','Xenapp Telewerkers','CVAD RDS 2019 users','G_L_Adobe_Reader','G_L_Microsoft_Edge','G_L_Notepad_Plus','G_L_Office_2019','G_L_Paint_Net','G_L_Stroomlijn','G_L_VLC','G_L_Xential'
foreach($groep in $standaardgroepen){
    Add-ADGroupMember -server ads-001.noordwijk.local -Identity $groep -Members $samaccountname -ErrorAction SilentlyContinue
}

# Aanmaken userfolders en uitdelen rechten
$userprofile = "\\fil-001\profiles$\$samaccountname"
$userhomedir ="\\fil-001\users$\$samaccountname"
$userdesktop = "\\fil-001\USERFOLDERS$\USERDESKTOP\$samaccountname"
$usertemp = "\\fil-001\USERFOLDERS$\USERTEMP\$samaccountname"

New-Item -Path "$userprofile" -ItemType "directory" | out-null
.\setacl -on "$userprofile" -ot file -actn setprot -rec cont_obj -op "dacl:p_c" | out-null
.\setacl -on "$userprofile" -ot file -actn clear -clr "dacl,sacl" | out-null
.\setacl -on "$userprofile" -ot file -rec cont_obj -actn ace -ace "n:Noordwijk\$samaccountname;p:full;m:set;w:dacl" -ace "n:Noordwijk\Domain Admins;p:full;m:set;w:dacl" -ace "n:SYSTEM;p:full;m:set;w:dacl" | out-null

New-Item -Path "$userhomedir" -ItemType "directory" | out-null
.\setacl -on "$userhomedir" -ot file -actn setprot -rec cont_obj -op "dacl:p_c" | out-null
.\setacl -on "$userhomedir" -ot file -actn clear -clr "dacl,sacl" | out-null
.\setacl -on "$userhomedir" -ot file -rec cont_obj -actn ace -ace "n:Noordwijk\$samaccountname;p:full;m:set;w:dacl" -ace "n:Noordwijk\Domain Admins;p:full;m:set;w:dacl" -ace "n:SYSTEM;p:full;m:set;w:dacl" | out-null

New-Item -Path "$userdesktop" -ItemType "directory" | out-null
.\setacl -on "$userdesktop" -ot file -actn setprot -rec cont_obj -op "dacl:p_c" | out-null
.\setacl -on "$userdesktop" -ot file -actn clear -clr "dacl,sacl" | out-null
.\setacl -on "$userdesktop" -ot file -rec cont_obj -actn ace -ace "n:Noordwijk\$samaccountname;p:full;m:set;w:dacl" -ace "n:Noordwijk\Domain Admins;p:full;m:set;w:dacl" -ace "n:SYSTEM;p:full;m:set;w:dacl" | out-null

New-Item -Path "$usertemp" -ItemType "directory" | out-null
.\setacl -on "$usertemp" -ot file -actn setprot -rec cont_obj -op "dacl:p_c" | out-null
.\setacl -on "$usertemp" -ot file -actn clear -clr "dacl,sacl" | out-null
.\setacl -on "$usertemp" -ot file -rec cont_obj -actn ace -ace "n:Noordwijk\$samaccountname;p:change;m:set;w:dacl" -ace "n:Noordwijk\Domain Admins;p:full;m:set;w:dacl" -ace "n:SYSTEM;p:full;m:set;w:dacl" | out-null

# Terminal server profile path en home folder instellen
$userDN = Get-ADUser -server ads-001.noordwijk.local -identity $samaccountname | Select-Object -expand DistinguishedName
$adsi = [adsi]::new("LDAP://$userDN")

#//Set Settings
$adsi.psbase.InvokeSet("TerminalServicesProfilePath","$userprofile\tsprofiel")
$adsi.psbase.InvokeSet("TerminalServicesHomeDirectory","$userhomedir")
$adsi.psbase.InvokeSet("TerminalServicesHomeDrive","M:")
$adsi.CommitChanges()

# AAD Delta Sync - eerst controleren of er geen sync loopt..
if ($ADSyncConnectorRunStatus -eq "Busy") {timestamp ; Write-Host "Op dit moment loopt er een AAD sync al bezig, moment geduld.." -ForegroundColor Yellow}
do 
{$ADSyncConnectorRunStatus = Invoke-Command -ComputerName adc-001.noordwijk.local -ScriptBlock { Get-ADSyncConnectorRunStatus} | Select-Object -ExpandProperty RunState
}
until ($ADSyncConnectorRunStatus -ne "Busy")

# daarna kunnen we een delta sync aftrappen
Invoke-Command -ComputerName adc-001.noordwijk.local -ScriptBlock { Start-adsyncsynccycle -policytype delta } | Out-Null
timestamp ; Write-Host "AAD Delta sync succesvol gestart.." -ForegroundColor Green