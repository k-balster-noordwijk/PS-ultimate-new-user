function Remove-StringSpecialCharacter {
    <#
.SYNOPSIS
    This function will remove the special character from a string.

.DESCRIPTION
    This function will remove the special character from a string.
    I'm using Unicode Regular Expressions with the following categories
    \p{L} : any kind of letter from any language.
    \p{Nd} : a digit zero through nine in any script except ideographic

    http://www.regular-expressions.info/unicode.html
    http://unicode.org/reports/tr18/

.PARAMETER String
    Specifies the String on which the special character will be removed

.PARAMETER SpecialCharacterToKeep
    Specifies the special character to keep in the output

.EXAMPLE
    Remove-StringSpecialCharacter -String "^&*@wow*(&(*&@"
    wow

.EXAMPLE
    Remove-StringSpecialCharacter -String "wow#@!`~)(\|?/}{-_=+*"

    wow
.EXAMPLE
    Remove-StringSpecialCharacter -String "wow#@!`~)(\|?/}{-_=+*" -SpecialCharacterToKeep "*","_","-"
    wow-_*

.NOTES
    Francois-Xavier Cat
    @lazywinadmin
    lazywinadmin.com
    github.com/lazywinadmin
#>
    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [Alias('Text')]
        [System.String[]]$String,

        [Alias("Keep")]
        #[ValidateNotNullOrEmpty()]
        [String[]]$SpecialCharacterToKeep
    )
    PROCESS {
        try {
            IF ($PSBoundParameters["SpecialCharacterToKeep"]) {
                $Regex = "[^\p{L}\p{Nd}"
                Foreach ($Character in $SpecialCharacterToKeep) {
                    IF ($Character -eq "-") {
                        $Regex += "-"
                    }
                    else {
                        $Regex += [Regex]::Escape($Character)
                    }
                    #$Regex += "/$character"
                }

                $Regex += "]+"
            } #IF($PSBoundParameters["SpecialCharacterToKeep"])
            ELSE { $Regex = "[^\p{L}\p{Nd}]+" }

            FOREACH ($Str in $string) {
                Write-Verbose -Message "Original String: $Str"
                $Str -replace $regex, ""
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    } #PROCESS
}


# Functie die ervoor zorgt dat de complexiteit van het wachtwoord voldoet aan de domain policy
Function GenerateStrongPassword ([Parameter(Mandatory=$true)][int]$PasswordLenght)
{
Add-Type -AssemblyName System.Web
$PassComplexCheck = $false
do {
$newPassword=[System.Web.Security.Membership]::GeneratePassword($PasswordLenght,1)
If ( ($newPassword -cmatch "[A-Z\p{Lu}\s]") `
-and ($newPassword -cmatch "[a-z\p{Ll}\s]") `
-and ($newPassword -match "[\d]") `
-and ($newPassword -match "[^\w]")
)
{
$PassComplexCheck=$True
}
} While ($PassComplexCheck -eq $false)
return $newPassword
} #einde functie GenerateStrongPassword

# huidige tijd
Function timestamp{(Write-Host -NoNewLine (Get-Date -Format "[HH:mm] ") -ForegroundColor yellow)}

# Berichtendoos
function Show-MessageBox {  
    [CmdletBinding()]  
    Param (   
        [Parameter(Mandatory = $false)]  
        [string]$Title = 'MessageBox in PowerShell',

        [Parameter(Mandatory = $true)]
        [string[]]$Message,  

        [Parameter(Mandatory = $false)]
        [ValidateSet('OK', 'OKCancel', 'AbortRetryIgnore', 'YesNoCancel', 'YesNo', 'RetryCancel')]
        [string]$Buttons = 'OKCancel',

        [Parameter(Mandatory = $false)]
        [ValidateSet('Error', 'Warning', 'Information', 'None', 'Question')]
        [string]$Icon = 'Information',

        [Parameter(Mandatory = $false)]
        [ValidateRange(1,3)]
        [int]$DefaultButton = 1
    )            

    # determine the possible default button
    if ($Buttons -eq 'OK') {
        $Default = 'Button1'
    }
    elseif (@('AbortRetryIgnore', 'YesNoCancel') -contains $Buttons) {
        $Default = 'Button{0}' -f [math]::Max([math]::Min($DefaultButton, 3), 1)
    }
    else {
        $Default = 'Button{0}' -f [math]::Max([math]::Min($DefaultButton, 2), 1)
    }

    Add-Type -AssemblyName System.Windows.Forms
    # added from tip by [Ste](https://stackoverflow.com/users/8262102/ste) so the 
    # button gets highlighted when the mouse hovers over it.
    [void][System.Windows.Forms.Application]::EnableVisualStyles()

    # Setting the first parameter 'owner' to $null lets he messagebox become topmost
    [System.Windows.Forms.MessageBox]::Show($null, $Message, $Title,   
                                            [Windows.Forms.MessageBoxButtons]::$Buttons,   
                                            [Windows.Forms.MessageBoxIcon]::$Icon,
                                            [Windows.Forms.MessageBoxDefaultButton]::$Default)
}