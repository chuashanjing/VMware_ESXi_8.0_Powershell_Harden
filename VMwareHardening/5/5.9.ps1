Write-Output '5.9 (L1) Host must restrict access to a default or native VLAN on standard virtual switches (Automated)'
#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

Write-Output '
Audit
1. Verify native VLAN ID is not being used for port groups

Remediation
2. Stop native VLAN ID for port groups
'

$validOption = $false

while (-not $validOption) {
    $option = Read-Host "Please Enter an option (1-2)"

    if ($option -match '^[1-2]$') {
        $validOption = $true

        switch ($option) {

            '1' { 
                    Write-Output '1 - Verify native VLAN ID is not being used for port groups'
                    $command = Get-VirtualPortGroup -Standard | Select virtualSwitch, Name, VlanID
                    $command
                }


            '2' {
                
                    Write-Output '2 - Stop native VLAN ID for port groups'
                    Write-Output '
                    1. From the vSphere Web Client, select the host. 
                    2. Click Configure then expand Networking. 
                    3. Select Virtual switches. 
                    4. Expand the Standard vSwitch. 
                    5. View the topology diagram of the switch, which shows the various port groups 
                       associated with that switch. 
                    6. For each port group on the vSwitch, verify and record the VLAN IDs used. 
                    7. If a VLAN ID change is needed, click the name of the port group in the topology 
                       diagram of the virtual switch. 
                    8. Click the Edit settings option. 
                    9. In the Properties section, enter an appropriate name in the Network label field. 
                    10. In the VLAN ID dropdown select or type a new VLAN. 
                    11. Click OK.
                    '

                }
        }
    }
    else {
        Write-Output 'Invalid option, please try again.'
    }
}
