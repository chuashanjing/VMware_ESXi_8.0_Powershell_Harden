Write-Output '6.4.1 (L1) Host SNMP services, if enabled, must limit access (Manual)'
#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

Write-Output '
Audit
1. Check SNMP is being used
2. View SNMP Configuration of a host

Remediation
3. Disable SNMP if not needed
4. Update the host SNMP Configuration
Auditing is recommended to be done first
'

$validOption = $false

while (-not $validOption) {
    $option = Read-Host "Please Enter an option (1-4)"

    if ($option -match '^[1-4]$') {
        $validOption = $true

        switch ($option) {

            '1' { 
                    Write-Output '1 - Check SNMP is being used'
                    $command = esxcli system snmp get 
                    $command

                    if($command.Enabled -eq 'true'){
                        Write-Output 'SNMP is being used, refer to vSphere Monitoring and Performance guide,
                        chapter 8 for steps to verify the parameters
                        '
                    }
                    else{
                        Write-Output 'SNMP is not being used. It is compliant.'
                    }
                }


            '2' {
                
                    Write-Output '2 - View SNMP Configuration of a host'
                    $command = Get-VMHostSnmp
                    $command

                }


            '3' {
                
                    Write-Output '3 - Disable SNMP if not needed' 
                    $command = esxcli system snmp set --enable false
                    Write-Output 'Rerun script to view changes'
                
                }



            '4' { 
                    
                    Write-Output '4 - Update the host SNMP Configuration'
                    $command = Get-VmHostSNMP | Set-VMHostSNMP -Enabled:$true -ReadOnlyCommunity '<secret>'
                    Write-Output 'Rerun script to view changes' 
                    
                }
        }
    }
    else {
        Write-Output 'Invalid option, please try again.'
    }
}







