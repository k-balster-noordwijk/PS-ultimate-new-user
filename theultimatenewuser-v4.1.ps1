Get-PSSession | Remove-PSSession
Clear-Host
$LogfileDateTime = $(get-date -f "yyyyMMdd-HHmmss")
$LogfileDir = "$pwd\Log"
Start-Transcript -Append "$LogfileDir\$LogfileDateTime-debug.log" | Out-Null

# aanroepen van alle sub-scripts
$LASTEXITCODE = 0
If ($LASTEXITCODE -eq 0) {(. .\00-functies.ps1)}
If ($LASTEXITCODE -eq 0) {(. .\01-vereisten.ps1)}
If ($LASTEXITCODE -eq 0) {(Powershell .\02-variabelen.ps1) ; try {(. .\Output.ps1 )} catch {$null}}
If ($LASTEXITCODE -eq 0) {(. .\03-userchecks.ps1)}
If ($LASTEXITCODE -eq 0) {(. .\04-activedirectory.ps1)}
If ($LASTEXITCODE -eq 0 -and $mailbox -eq 'ja') {(. .\05-exchange-online.ps1)}
If ($LASTEXITCODE -eq 0 -and $teamstelefonie -eq 'ja') {(. .\06-microsoft-teams.ps1)}

Stop-Transcript | Out-Null

Remove-item -Path .\Output.ps1 -Force -ErrorAction SilentlyContinue

# Einde script
If ($LASTEXITCODE -eq 0) {
Add-Content -Path "$LogfileDir\$LogfileDateTime-login-$samaccountname.log" -value ('Gebruikersnaam: '+ $samaccountname)
Add-Content -Path "$LogfileDir\$LogfileDateTime-login-$samaccountname.log" -value ('Wachtwoord: '+ $unsecurepassword)
if ($mailbox -eq 'ja') {Add-Content -Path "$LogfileDir\$LogfileDateTime-login-$samaccountname.log" -value ('E-mail: '+ $samaccountname + "@noordwijk.nl")}
If ($teamstelefonie -eq 'ja') {Add-Content -Path "$LogfileDir\$LogfileDateTime-login-$samaccountname.log" -value ('Telefoonummer: '+ $officephone)}
Start-Process -FilePath "$LogfileDir\$LogfileDateTime-login-$samaccountname.log";
}

If ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne 2)  {Write-Warning "Er is iets misgegaan..";Start-Process -FilePath "$LogfileDir\$LogfileDateTime-debug.log"}