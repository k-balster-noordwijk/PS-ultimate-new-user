# controleren van een Phone system licentie net zo lang totdat hij op de gebruiker staat
timestamp ; Write-Host "Teams telefonie wordt aangemaakt, moment geduld.." -ForegroundColor yellow
do
{
$licentie = Get-AzureADUser -SearchString "$samaccountname@noordwijk.nl" | Select-Object -ExpandProperty AssignedPlans | Where-Object {$_.ServicePlanId -eq "4828c8ec-dc2e-4779-b502-87ac9ce28ab7"} | Select-Object -ExpandProperty CapabilityStatus
}
until($licentie -eq "Enabled")

# Zodra er een licentie geconstateerd is wordt EnterpriseVoice Enabled
Try {Set-CsPhoneNumberAssignment -Identity "$samaccountname@noordwijk.nl" -EnterpriseVoiceEnabled $true -ErrorAction Stop} catch {timestamp ; Write-Warning $Error[0] ; $LASTEXITCODE = 1 ; EXIT}
do
{
$EnterpriseVoiceEnabled = Get-CsOnlineUser -Identity "$samaccountname@noordwijk.nl" |  Select-Object -ExpandProperty "EnterpriseVoiceEnabled"
}
until($EnterpriseVoiceEnabled -eq "True")

# Zodra EnterpriseVoice Enabled is kunnen we het telefoonummer koppelen
Try {Set-CsPhoneNumberAssignment -Identity "$samaccountname@noordwijk.nl" -PhoneNumber "$officephone" -PhoneNumberType DirectRouting -ErrorAction Stop} catch {timestamp ; Write-Warning $Error[0] ; $LASTEXITCODE = 1 ; EXIT}
do
{
$CsPhoneNumberAssignment = Get-CsPhoneNumberAssignment -AssignedPstnTargetId "$samaccountname@noordwijk.nl" | Select-Object -ExpandProperty "TelephoneNumber"
}
until($CsPhoneNumberAssignment -eq $officephone)

# Default policies
Grant-CsTeamsCallingPolicy -Identity "$samaccountname@noordwijk.nl" -PolicyName "NL-VCIO365 - AllowCalling-NoVoiceMail"
Grant-CsOnlineVoiceRoutingPolicy -Identity "$samaccountname@noordwijk.nl" -PolicyName "NL-VCIO365 - International"
Grant-CsTenantDialPlan -Identity "$samaccountname@noordwijk.nl" -PolicyName NL-VCIO365
Grant-CsCallingLineIdentity -Identity "$samaccountname@noordwijk.nl" -PolicyName Gemeente-Noordwijk

timestamp ; Write-Host "Teams telefoonnummer: $officephone succesvol aangemaakt.." -ForegroundColor Green

# Netjes afsluiten van de Powershell sessies
Disconnect-MicrosoftTeams -Confirm:$false | Out-Null
Disconnect-AzureAD -Confirm:$false | Out-Null