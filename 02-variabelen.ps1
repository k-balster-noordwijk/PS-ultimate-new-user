# dot sourcen de functies zodat we deze kunnen gebruiken
. .\00-functies.ps1

# laden van de benondigde Assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

do {

$form = New-Object Windows.Forms.Form
$form.Size = New-Object Drawing.Size @(300,600)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(255,255,255,255)
$form.Text = "Gegevens nieuwe gebruiker"
$form.ShowInTaskbar = $False
$form.Name = "Gegevens nieuwe gebruiker"
$Form.FormBorderStyle = 'Fixed3D'
$Form.MaximizeBox = $false
$Form.MinimizeBox = $false

#get base64 string from here: http://www.base64-image.de
#set icon for form using Base64
$base64IconString = "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"
$iconimageBytes = [Convert]::FromBase64String($base64IconString)
$ims = New-Object IO.MemoryStream($iconimageBytes, 0, $iconimageBytes.Length)
$ims.Write($iconimageBytes, 0, $iconimageBytes.Length);
#$alkIcon = [System.Drawing.Image]::FromStream($ims, $true)
$Form.Icon = [System.Drawing.Icon]::FromHandle((new-object System.Drawing.Bitmap -argument $ims).GetHIcon())

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(50,520)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.Enabled = $false
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(140,520)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(260,30)
$label.Text = 'Vul onderstaande gegevens in. Let op alle velden zijn verplicht!'
$form.Controls.Add($label)

# Voornaam
$labelvoornaam = New-Object System.Windows.Forms.Label
$labelvoornaam.Location = New-Object System.Drawing.Point(10,60)
$labelvoornaam.Size = New-Object System.Drawing.Size(260,20)
$labelvoornaam.Text = 'Voornaam:'
$labelvoornaam.add_TextChanged({
	if ($textBoxvoornaam.TextLength -and $textBoxachternaam.TextLength -and $textBoxinitialen.TextLength -ne 0 -and $listBoxintern.SelectedItem -and $listBoxmailbox.SelectedItem -and $listBoxteamstelefonie.SelectedItem -and $null -ne $listBoxclustermanager.SelectedItem) 
		{$okButton.Enabled = $true}
	else{$okButton.Enabled = $false}})
$form.Controls.Add($labelvoornaam)

$textBoxvoornaam = New-Object System.Windows.Forms.TextBox
$textBoxvoornaam.Location = New-Object System.Drawing.Point(10,80)
$textBoxvoornaam.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBoxvoornaam)

# Achternaam
$labelachternaam = New-Object System.Windows.Forms.Label
$labelachternaam.Location = New-Object System.Drawing.Point(10,100)
$labelachternaam.Size = New-Object System.Drawing.Size(260,20)
$labelachternaam.Text = 'Achternaam:'
$labelachternaam.add_TextChanged({
	if ($textBoxvoornaam.TextLength -and $textBoxachternaam.TextLength -and $textBoxinitialen.TextLength -ne 0 -and $listBoxintern.SelectedItem -and $listBoxmailbox.SelectedItem -and $listBoxteamstelefonie.SelectedItem -and $null -ne $listBoxclustermanager.SelectedItem) 
		{$okButton.Enabled = $true}
	else{$okButton.Enabled = $false}})
$form.Controls.Add($labelachternaam)

$textBoxachternaam = New-Object System.Windows.Forms.TextBox
$textBoxachternaam.Location = New-Object System.Drawing.Point(10,120)
$textBoxachternaam.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBoxachternaam)

# Initialen
$labelinitialen = New-Object System.Windows.Forms.Label
$labelinitialen.Location = New-Object System.Drawing.Point(10,140)
$labelinitialen.Size = New-Object System.Drawing.Size(260,20)
$labelinitialen.Text = 'Initialen:'
$labelinitialen.add_TextChanged({
	if ($textBoxvoornaam.TextLength -and $textBoxachternaam.TextLength -and $textBoxinitialen.TextLength -ne 0 -and $listBoxintern.SelectedItem -and $listBoxmailbox.SelectedItem -and $listBoxteamstelefonie.SelectedItem -and $null -ne $listBoxclustermanager.SelectedItem) 
		{$okButton.Enabled = $true}
	else{$okButton.Enabled = $false}})
$form.Controls.Add($labelinitialen)

$textBoxinitialen = New-Object System.Windows.Forms.TextBox
$textBoxinitialen.Location = New-Object System.Drawing.Point(10,160)
$textBoxinitialen.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBoxinitialen)

# Afdeling
$labeldepartment = New-Object System.Windows.Forms.Label
$labeldepartment.Location = New-Object System.Drawing.Point(10,180)
$labeldepartment.Size = New-Object System.Drawing.Size(260,20)
$labeldepartment.Text = 'Afdeling:'
$labeldepartment.add_TextChanged({
	if ($textBoxvoornaam.TextLength -and $textBoxachternaam.TextLength -and $textBoxinitialen.TextLength -ne 0 -and $listBoxintern.SelectedItem -and $listBoxmailbox.SelectedItem -and $listBoxteamstelefonie.SelectedItem -and $null -ne $listBoxclustermanager.SelectedItem) 
		{$okButton.Enabled = $true}
	else{$okButton.Enabled = $false}})
$form.Controls.Add($labeldepartment)

$textBoxdepartment = New-Object System.Windows.Forms.TextBox
$textBoxdepartment.Location = New-Object System.Drawing.Point(10,200)
$textBoxdepartment.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBoxdepartment)

# Functie
$labeltitle = New-Object System.Windows.Forms.Label
$labeltitle.Location = New-Object System.Drawing.Point(10,220)
$labeltitle.Size = New-Object System.Drawing.Size(260,20)
$labeltitle.Text = 'Functie:'
$labeltitle.add_TextChanged({
	if ($textBoxvoornaam.TextLength -and $textBoxachternaam.TextLength -and $textBoxinitialen.TextLength -ne 0 -and $listBoxintern.SelectedItem -and $listBoxmailbox.SelectedItem -and $listBoxteamstelefonie.SelectedItem -and $null -ne $listBoxclustermanager.SelectedItem) 
		{$okButton.Enabled = $true}
	else{$okButton.Enabled = $false}})
$form.Controls.Add($labeltitle)

$textBoxtitle = New-Object System.Windows.Forms.TextBox
$textBoxtitle.Location = New-Object System.Drawing.Point(10,240)
$textBoxtitle.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBoxtitle)

# Intern
$labelintern = New-Object System.Windows.Forms.Label
$labelintern.Location = New-Object System.Drawing.Point(10,260)
$labelintern.Size = New-Object System.Drawing.Size(260,20)
$labelintern.Text = 'Intern:'
$form.Controls.Add($labelintern)

$listBoxintern = New-Object System.Windows.Forms.ComboBox
$listBoxintern.Location = New-Object System.Drawing.Point(10,280)
$listBoxintern.Size = New-Object System.Drawing.Size(260,20)
$listBoxintern.DropDownHeight = 80
$listBoxintern.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$listBoxintern.add_SelectedIndexChanged({
	if ($textBoxvoornaam.TextLength -and $textBoxachternaam.TextLength -and $textBoxinitialen.TextLength -ne 0 -and $listBoxintern.SelectedItem -and $listBoxmailbox.SelectedItem -and $listBoxteamstelefonie.SelectedItem -and $null -ne $listBoxclustermanager.SelectedItem) 
		{$okButton.Enabled = $true}
	else{$okButton.Enabled = $false}})
#$listBoxintern.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#000000")
#$listBoxintern.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#FFFFFF")

[void] $listBoxintern.Items.Add('Ja')
[void] $listBoxintern.Items.Add('Nee')

# Mailbox
$labelmailbox = New-Object System.Windows.Forms.Label
$labelmailbox.Location = New-Object System.Drawing.Point(10,300)
$labelmailbox.Size = New-Object System.Drawing.Size(260,20)
$labelmailbox.Text = 'Mailbox:'
$form.Controls.Add($labelmailbox)

$listBoxmailbox = New-Object System.Windows.Forms.ComboBox
$listBoxmailbox.Location = New-Object System.Drawing.Point(10,320)
$listBoxmailbox.Size = New-Object System.Drawing.Size(260,20)
$listBoxmailbox.DropDownHeight = 80
$listBoxmailbox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$listBoxmailbox.add_SelectedIndexChanged({
	if ($textBoxvoornaam.TextLength -and $textBoxachternaam.TextLength -and $textBoxinitialen.TextLength -ne 0 -and $listBoxintern.SelectedItem -and $listBoxmailbox.SelectedItem -and $listBoxteamstelefonie.SelectedItem -and $null -ne $listBoxclustermanager.SelectedItem) 
		{$okButton.Enabled = $true}
	else{$okButton.Enabled = $false}})

[void] $listBoxmailbox.Items.Add('Ja')
[void] $listBoxmailbox.Items.Add('Nee')

# Teams telefonie
$labelteamstelefonie = New-Object System.Windows.Forms.Label
$labelteamstelefonie.Location = New-Object System.Drawing.Point(10,340)
$labelteamstelefonie.Size = New-Object System.Drawing.Size(260,20)
$labelteamstelefonie.Text = 'Teams telefonie:'
$form.Controls.Add($labelteamstelefonie)

$listBoxteamstelefonie = New-Object System.Windows.Forms.ComboBox
$listBoxteamstelefonie.Location = New-Object System.Drawing.Point(10,360)
$listBoxteamstelefonie.Size = New-Object System.Drawing.Size(260,20)
$listBoxteamstelefonie.DropDownHeight = 80
$listBoxteamstelefonie.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$listBoxteamstelefonie.add_SelectedIndexChanged({
	if ($textBoxvoornaam.TextLength -and $textBoxachternaam.TextLength -and $textBoxinitialen.TextLength -ne 0 -and $listBoxintern.SelectedItem -and $listBoxmailbox.SelectedItem -and $listBoxteamstelefonie.SelectedItem -and $null -ne $listBoxclustermanager.SelectedItem) 
		{$okButton.Enabled = $true}
	else{$okButton.Enabled = $false}})

[void] $listBoxteamstelefonie.Items.Add('Ja')
[void] $listBoxteamstelefonie.Items.Add('Nee')

# Cluster manager
$clustermanagers = Get-ADGroupMember -Identity G_CMA | Select-Object -ExpandProperty name

$labelclustermanager = New-Object System.Windows.Forms.Label
$labelclustermanager.Location = New-Object System.Drawing.Point(10,380)
$labelclustermanager.Size = New-Object System.Drawing.Size(260,20)
$labelclustermanager.Text = 'Cluster manager:'
$form.Controls.Add($labelclustermanager)

$listBoxclustermanager = New-Object System.Windows.Forms.ComboBox
$listBoxclustermanager.Location = New-Object System.Drawing.Point(10,400)
$listBoxclustermanager.Size = New-Object System.Drawing.Size(260,20)
$listBoxclustermanager.DropDownHeight = 80
$listBoxclustermanager.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$listBoxclustermanager.add_SelectedIndexChanged({
	if ($textBoxvoornaam.TextLength -and $textBoxachternaam.TextLength -and $textBoxinitialen.TextLength -ne 0 -and $listBoxintern.SelectedItem -and $listBoxmailbox.SelectedItem -and $listBoxteamstelefonie.SelectedItem -and $null -ne $listBoxclustermanager.SelectedItem) 
		{$okButton.Enabled = $true}
	else{$okButton.Enabled = $false}})

@($clustermanagers) | ForEach-Object {[void] $listBoxclustermanager.Items.Add($_)}
[void] $listBoxclustermanager.Items.Add('Desiree Thissen')

$form.Topmost = $true

$form.Controls.Add($listBoxintern)
$form.Controls.Add($listBoxmailbox)
$form.Controls.Add($listBoxteamstelefonie)
$form.Controls.Add($listBoxclustermanager)
$form.Add_Shown({$textBoxvoornaam.Select()})
$form.Add_Shown({$textBoxachternaam.Select()})
$form.Add_Shown({$textBoxinitialen.Select()})
$form.Add_Shown({$textBoxtitle.Select()})
$form.Add_Shown({$textBoxdepartment.Select()})

if ($textBoxvoornaam.TextLength -and $textBoxachternaam.TextLength -and $textBoxinitialen.TextLength -ne 0 -and $listBoxintern.SelectedItem -and $listBoxmailbox.SelectedItem -and $listBoxteamstelefonie.SelectedItem -and $null -ne $listBoxclustermanager.SelectedItem) {$okButton.Enabled = $True}

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::CANCEL) {Clear-Host ; Write-Warning "Invullen gegevens geannuleerd.." ; $LASTEXITCODE = 1;  Exit}

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $voornaam = $textBoxvoornaam.Text
	$achternaam = $textBoxachternaam.Text
	$initialen = $textBoxinitialen.Text
	$title = $textBoxtitle.Text
	$department = $textBoxdepartment.Text
	$intern = $listBoxintern.SelectedItem.ToString()
	$mailbox = $listBoxmailbox.SelectedItem.ToString()
	$teamstelefonie = $listBoxteamstelefonie.SelectedItem.ToString()
	$clustermanager = $listBoxclustermanager.SelectedItem
	$voorletter = $voornaam.ToLower().Substring(0,1)
	$samaccountname = "$voorletter"+"."+"$achternaam".ToLower().Replace(' ', '')
	
	

$MessageBody = "Kloppen onderstaand gegevens?`n `nVoornaam: $voornaam`n `nAchternaam:  $achternaam`n `nInitialen: $initialen`n `nFunctie: $title`n `nAfdeling: $department`n `nIntern: $intern`n `nMailbox: $mailbox`n `nTeams telefonie: $teamstelefonie`n `nClustermanager: $clustermanager`n"
$verificatie = Show-MessageBox -Title 'Controle gegevens nieuwe gebruiker' -Message $MessageBody -Icon Question -Buttons YesNoCancel

if ($verificatie -eq "Cancel") {Clear-Host ; Write-Warning "Invullen gegevens geannuleerd.." ; $LASTEXITCODE = 2;  Exit}

}
}
until ($verificatie -eq "Yes")

# Indien aanwezig eerste verwijderen
Remove-item -Path .\Output.ps1 -Force -ErrorAction Ignore

if ($verificatie -eq "Yes") {

# Mocht het samaccountname langer zijn dan 20 karakters geef dan een aangepaste versie op
if ($samaccountname.length -gt 20 -or $samaccountname.length -le 2) {
	do {
$form = New-Object Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(400,150)
$form.Text = "Gegevens nieuwe gebruiker"
$form.StartPosition = 'CenterScreen'
$Form.FormBorderStyle = 'Fixed3D'

#get base64 string from here: http://www.base64-image.de
#set icon for form using Base64
$base64IconString = "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"
$iconimageBytes = [Convert]::FromBase64String($base64IconString)
$ims = New-Object IO.MemoryStream($iconimageBytes, 0, $iconimageBytes.Length)
$ims.Write($iconimageBytes, 0, $iconimageBytes.Length);
#$alkIcon = [System.Drawing.Image]::FromStream($ims, $true)
$Form.Icon = [System.Drawing.Icon]::FromHandle((new-object System.Drawing.Bitmap -argument $ims).GetHIcon())


$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(100,80)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(200,80)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(400,20)
if ($samaccountname.length -gt 20) {$label.Text = 'Gebruikersnaam is langer dan 20 karakters. Geef aangepaste variant op:'}
if ($samaccountname.length -le 2) {$label.Text = 'Gebruikersnaam is korter dan 3 karakters. Geef aangepaste variant op:'}
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($textBox)

$form.Topmost = $true

$form.Add_Shown({$textBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::CANCEL) {Clear-Host ; Write-Warning "Invullen gegevens geannuleerd.." ; $LASTEXITCODE = 2;  Exit}

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $samaccountname = $textBox.Text
}
	  } 
	  while($samaccountname.length -gt 20 -or $samaccountname.length -le 2)
}
# Exporteren naar Output.ps1 om weer in te lezen. Dit script is STA (single threaded aparatment) en geeft problemen met andere scripts, vandaar deze workaround.
Add-Content -Path .\Output.ps1 -value ('$voornaam = '+"""$voornaam""")
Add-Content -Path .\Output.ps1 -value ('$achternaam = '+"""$achternaam""")
Add-Content -Path .\Output.ps1 -value ('$initialen = '+"""$initialen""")
Add-Content -Path .\Output.ps1 -value ('$title = '+"""$title""")
Add-Content -Path .\Output.ps1 -value ('$department = '+"""$department""")
Add-Content -Path .\Output.ps1 -value ('$intern = '+"""$intern""")
Add-Content -Path .\Output.ps1 -value ('$mailbox = '+"""$mailbox""")
Add-Content -Path .\Output.ps1 -value ('$teamstelefonie = '+"""$teamstelefonie""")
Add-Content -Path .\Output.ps1 -value ('$clustermanager = '+"""$clustermanager""")
Add-Content -Path .\Output.ps1 -value ('$voorletter = '+"""$voorletter""")
Add-Content -Path .\Output.ps1 -value ('$samaccountname = '+"""$samaccountname""")
}