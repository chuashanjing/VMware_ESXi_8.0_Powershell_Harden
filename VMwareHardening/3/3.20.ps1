Write-Output '3.20 (L1) Host must enable normal lockdown mode (Automated)'


#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential


Write-Output '
!IMPORTANT READ
Manual mode should be considered since CIS provided normal lockdown mode (3.20)
and strict mode (3.21) with the same command.
I am unable to modify the code myself since I am unable to test it out.
So to prevent any errors, manual is highly recommended.

Verify lockdown mode is enabled and on normal mode
1. Manual (Recommended)
Details: 
- Audit
   • Checks if enabled
   • Allow you to check if lockdown mode is set to normal or strict.
   • For 3.20 it will be normal.
- Remediation
   • Steps to configure normal lockdown mode + enable it (Remediation)

2. Automated (Not recommended)
Details:
- Audit
   • Checks if enabled only.
   • Does not tell you if it is strict or normal
- Remediation
   • Sets lockdown mode to be enabled
'

$validOption = $false

while (-not $validOption) {
    $option = Read-Host "Please Enter an option (1-2)"

    if ($option -match '^[1-2]$') {
        $validOption = $true

        switch ($option) {

            '1' { 
                    Write-Output '1 - Manual
                    '
                    
                    Write-Output '
                    Audit: 
                    To verify lockdown mode is enabled, perform the following from the vSphere web client: 
                    1. From the vSphere Web Client, select the host. 
                    2. Select Configure then expand System and select Security Profile. 
                    3. Verify that Lockdown Mode is set to Normal. 
                    '
                    Write-Output '
                    To enable lockdown mode, perform the following from the vSphere web client: 
                    1. From the vSphere Web Client, select the host. 
                    2. Select Configure then expand System and select Security Profile. 
                    3. Across from Lockdown Mode click on Edit. 
                    4. Click the radio button for Normal. 
                    5. Click OK. 
                    '
                    
                }


            '2' {
                
                    Write-Output '2 - Automated (Not Recommended)'
                    $command = $command = Get-VMHost | Select Name,@{N="Lockdown";E={$_.Extensiondata.Config.adminDisabled}}
                    $command

                    if($command.Count -gt 0){

                        $needRemediation = $false

                        foreach($vmhost in $command){

                            $vmhost = $vmhost.Name
                            $enabled = $vmhost.Lockdown

                            if($enabled -eq 'True'){
                                Write-Output "$vmhost is compliant"
                            }
                            else{
                                Write-Output "$vmhost is not compliant"
                                $needRemediation = $true
                            }

                        }

                        if($needRemediation){
                            $command = Get-VMHost | Foreach { $_.EnterLockdownMode() }
                            Write-Output 'Rerun script to view changes'
                        }

                    }
                    else{
                        Write-Output 'No VMHost'
                    }

                }
        }
    }
    else {
        Write-Output 'Invalid option, please try again.'
    }
}









