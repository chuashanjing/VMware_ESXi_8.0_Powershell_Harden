Write-Output '3.14 (L1) Host must configure the password history setting to restrict the reuse of passwords (Manual)'


#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential


Write-Output '
3.14 is considered manual. So I will let you chooose between
manual and automated.

1. Manual
Details: Contains steps to verify password history

2. Automated
Details: 
- Checks if password history is compliant
- If not, auto configure for you
'

$validOption = $false

while (-not $validOption) {
    $option = Read-Host "Please Enter an option (1-2)"

    if ($option -match '^[1-2]$') {
        $validOption = $true

        switch ($option) {

            '1' { 
                    Write-Output '1 - 3.14 Manual'
                    Write-Output "
                    To verify the password history is set to 5, perform the following: 
                    1. From the vSphere Web Client, select the host. 
                    2. Click Configure then expand System. 
                    3. Select Advanced System Settings then click Edit. 
                    4. Enter Security.PasswordHistory in the filter. 
                    5. Verify that the value for this parameter is set to 5. 
                    "
                    Write-Output "
                    Remediation:
                    To set the password history 5, perform the following: 
                    1. From the vSphere Web Client, select the host. 
                    2. Click Configure then expand System. 
                    3. Select Advanced System Settings then click Edit. 
                    4. Enter Security.PasswordHistory in the filter. 
                    5. Set the value for this parameter is set to 5. 
                    "
                }


            '2' {
                    Write-Output '2 - 3.14 Automated'
                    $command = Get-VMHost | Get-AdvancedSetting Security.PasswordHistory
                    $command

                    if($command.Count -gt 0){
                        $needRemediation = $false
                        foreach($hosts in $command){
                            $name = $hosts.Name
                            $value = $hosts.Value

                            if($value -eq '5'){
                                Write-Output "$name is compliant"
                            }
                            else{
                                Write-Output "$name is not compliant"
                                $needRemediation = $true
                            }
                        }

                        if($needRemediation){
                            $command = Get-VMHost | Get-AdvancedSetting Security.PasswordHistory | Set-AdvancedSetting -Value 5 
                            Write-Output 'Rerun script to view changes'
                        }

                    }
                    else{
                        Write-Output 'No VMHosts to check for'
                    }
                }
        }
    }
    else {
        Write-Output 'Invalid option, please try again.'
    }
}