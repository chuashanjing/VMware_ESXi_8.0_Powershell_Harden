Write-Output '5.1 (L1) Host firewall must only allow traffic from authorized networks (Manual)'


#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential


Write-Output '
Audit
1. Steps to confirm access services running on ESXI host is restricted
2. Automated script to confirm access services running on ESXI host is restricted

Remediation
3. Steps to restrict access to services running on ESXi host
'

$validOption = $false

while (-not $validOption) {
    $option = Read-Host "Please Enter an option (1-3)"

    if ($option -match '^[1-3]$') {
        $validOption = $true

        switch ($option) {

            '1' { 
                    Write-Output '1 - Steps to confirm access services running on ESXI host is restricted'
                    Write-Output 'To confirm access to services running on an ESXi host is properly restricted, perform 
                       the following from the vSphere web client: 
                    1. Select a host 
                    2. Click Configure then expand System then select Firewall. 
                    3. Click Edit to view services which are enabled (indicated by a check). 
                    4. For each enabled service, (e.g., ssh, vSphere Web Access, http client) check to 
                       ensure that the list of allowed IP addresses specified is correct.
                    '
                }


            '2' {
                
                    Write-Output '2 - Automated script to confirm access services running on ESXI host is restricted'
                    # List all services for a host 
                    $command1 = Get-VMHost HOST1 | Get-VMHostService 
                    # List the services which are enabled and have rules defined for specific IP ranges to access the service 
                    $command2 = Get-VMHost HOST1 | Get-VMHostFirewallException | Where {$_.Enabled -and (-not $_.ExtensionData.AllowedHosts.AllIP)} 
                    # List the services which are enabled and do not have rules defined for specific IP ranges to access the service 
                    $command3 = Get-VMHost HOST1 | Get-VMHostFirewallException | Where {$_.Enabled -and ($_.ExtensionData.AllowedHosts.AllIP)}    

                    $command1
                    $command2
                    $command3
                }
            
            '3' {
                
                    Write-Output '3 - Steps to restrict access to services running on ESXi host'
                    Write-Output '1. Select a host 
                    2. Click Configure then expand System then select Firewall. 
                    3. Click Edit to view services which are enabled (indicated by a check). 
                    4. For each enabled service, (e.g., ssh, vSphere Web Access, http client) provide a 
                       list of allowed IP addresses. 
                    5. Click OK. 
                    '
                }
        }
    }
    else {
        Write-Output 'Invalid option, please try again.'
    }
}









