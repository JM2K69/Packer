function Enable-UAC(){
    $numVersion = (Get-CimInstance Win32_OperatingSystem).Version
    $numSplit = $numVersion.split(".")[0]
 
    if ($numSplit -eq 10) {
        Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value "5"
    }
    elseIf ($numSplit -eq 6) {
        $enumSplit = $numSplit.split(".")[1]
        if ($enumSplit -eq 1 -or $enumSplit -eq 0) {
            Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value "1"
        } else {
            Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value "3"
        }
    }
    elseIf ($numSplit -eq 5) {
        Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value "1"
    }
    else {
        Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value "3"
    }
    Write-Host "Successfully enable UAC!"
}
Enable-UAC

Disable-UAC