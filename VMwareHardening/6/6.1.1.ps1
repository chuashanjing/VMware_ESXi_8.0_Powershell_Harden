Write-Output '6.1.1 (L1) Host CIM services, if enabled, must limit access (Manual)'
#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

Write-Output '
Audit
1. Verify CIM access is limited
Details: Check for a limited-privileged service account with the following CIM roles applied: 
Host.Config.SystemManagement Host.CIM.CIMInteraction

Remediation
2. Limit CIM access (Select and it will execute command)
'

$validOption = $false

while (-not $validOption) {
    $option = Read-Host "Please Enter an option (1-2)"

    if ($option -match '^[1-2]$') {
        $validOption = $true

        switch ($option) {

            '1' { 
                    Write-Output '1 - Verify CIM access is limited'
                    $command = Get-VMHostAccount
                    $command
                }


            '2' {
                
                    Write-Output '2 - Limit CIM access'
                    #Create a new host user account - Host Local connection required
                    $command = New-VMHostAccount -ID "ServiceUser" -Password "<password>" -UserAccount

                }
        }
    }
    else {
        Write-Output 'Invalid option, please try again.'
    }
}



