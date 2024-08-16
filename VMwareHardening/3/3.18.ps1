Write-Output '3.18 (L1) Host must have an accurate DCUI.Access list (Manual)'


#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential


Write-Output '
1. Verify trusted user list
Details: Make sure proper trusted user list is set for DCUI

2. Set a trusted user list for DCUI
'

$validOption = $false

while (-not $validOption) {
    $option = Read-Host "Please Enter an option (1-2)"

    if ($option -match '^[1-2]$') {
        $validOption = $true

        switch ($option) {

            '1' { 
                    Write-Output '1 - Verify trusted user list
                    '
                    $command = Get-VMHost | Get-AdvancedSetting -Name DCUI.Access
                    $command
                    
                }


            '2' {
                
                    Write-Output '2 - Set a trusted user list for DCUI'
                    Write-Output '
                    To set a trusted users list for DCUI, perform the following from the vSphere web client: 
                    1. From the vSphere Web Client, select the host. 
                    2. Click Configure then expand System. 
                    3. Select Advanced System Settings then click Edit. 
                    4. Enter DCUI.Access in the filter. 
                    5. Set the DCUI.Access attribute is set to a comma-separated list of the users who 
                       are allowed to override lockdown mode. 
                    '

                }
        }
    }
    else {
        Write-Output 'Invalid option, please try again.'
    }
}









