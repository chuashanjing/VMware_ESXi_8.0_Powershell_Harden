Write-Output '5.3 (L1) Host must restrict use of the dvFilter network API (Manual)'


#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential


Write-Output '
Audit
1. API Check
Details:
- Make sure it is not used
- If used, make sure the IP is set to a proper IP Address

Remediation
2. Steps to Remove Configuration for dvfilter network API manually
3. Remove configuration for dvfilter network API
Details: Set Net.DVFilterBindIPAddress to null on all hosts
'

$validOption = $false

while (-not $validOption) {
    $option = Read-Host "Please Enter an option (1-3)"

    if ($option -match '^[1-3]$') {
        $validOption = $true

        switch ($option) {

            '1' { 
                    Write-Output '1 - List Net .DVFilterBindIpAddress for each host'
                    $command = Get-VMHost | Select Name, @{N="Net.DVFilterBindIpAddress";E={$_ | Get-AdvancedSetting Net.DVFilterBindIpAddress | Select -ExpandProperty Values}}
                    $command
                }


            '2' {
                
                    Write-Output '2 - Remove Configs Manually'
                    Write-Output '
                    To remove the configuration for the dvfilter network API, perform the following from the 
                    vSphere web client: 

                    1. From the vSphere web client, select the host and click Configure then expand 
                       System 
                    2. Click on Advanced System Settings then Edit. 
                    3. Search for Net.DVFilterBindIpAddress in the filter. 
                    4. Set Net.DVFilterBindIpAddress has an empty value. 
                    5. If an appliance is being used, make sure the value of this parameter is set to the 
                       proper IP address. 
                    6. Enter the proper IP address. 
                    7. Click OK. 
                    '
                }
            
            '3' {
                
                    Write-Output '3 - Set Null value to all Net .DVFilterBindIpAddress on all host'
                    $command = Get-VMHost HOST1 | Foreach { Set-AdvancedSetting -VMHost $_ -Name Net.DVFilterBindIpAddress -IPValue "" }
                    Write-Output 'Rerun script to view changes'
                }
        }
    }
    else {
        Write-Output 'Invalid option, please try again.'
    }
}









