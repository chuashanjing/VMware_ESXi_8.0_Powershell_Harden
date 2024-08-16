Write-Output "2.6 (L1) Host must have reliable time synchronization sources (Automated)"

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

Write-Output '
The output might not show NTP Client, NTP Service Status,
NTP Servers and Time Synchronization.
MANUAL is recommended

1. Manual
Details: Steps for NTP configuration
2. Automated
Details: Automated but might not configure according to manual method
'
$validOption = $false

while (-not $validOption) {
    $option = Read-Host "Please Enter an option (1-2)"

    if ($option -match '^[1-2]$') {
        $validOption = $true

        switch ($option) {

            '1' { 
                    Write-Output '1 - Steps for NTP configuration'
                    Write-Output '
                    Audit:
                    To confirm NTP synchronization is enabled and properly configured, perform the 
                    following from the vSphere Web Client: 
                    1. Select a host 
                    2. Click Configure then expand System then select Time Configuration. 
                    3. Verify that Time Synchronization is set to Automatic 
                    4. Verify that the NTP Client is set to Enabled 
                    5. Verify that the NTP Service Status is Running 
                    6. Verify that appropriate NTP servers are set. 
                    '

                    Write-Output '
                    Remediation:
                    To enable and properly configure NTP synchronization, perform the following from the 
                    vSphere web client: 
                    1. Select a host 
                    2. Click Configure then expand System then select Time Configuration. 
                    3. Select Edit next to Network Time Protocol 
                    4. Select the Enable box, then fill in the appropriate NTP Servers. 
                    5. in the NTP Service Startup Policy drop down select Start and stop with 
                       host. 
                    6. Click OK.
                    '

                }


            '2' {

                    Write-Output '2 - Manual for NTP configuration'
                    
                    $ntpserver = "<NTP_Server.com>", "<NTP_SERVER2.com>"

                    $command = Get-VMHost | Select Name, @{N="NTPSetting";E={$_ | Get-VMHostNtpServer}}
                    $command

                    if($command.Count -gt 0){
                        foreach($vmhost in $command){
                            $name = $vmhost.Name
                            $ntp = $vmhost.NTPSetting

                            if($ntp -eq $ntpserver){
                                Write-output "$name is compliant"
                            }
                            else{
                                Write-output "$name is not compliant"
                                $needRemediation = $true
                            }
                        }
                        if($needRemediation){
                            
                            $command = Get-VMHost | Add-VMHostNtpServer $ntpserver
                        }
                    }
                    else{
                        Write-Output 'No VMHost to check for'
                    }



                }
        }
    }
    else {
        Write-Output 'Invalid option, please try again.'
    }
}

