Write-Output '7.23 (L1) Virtual machines must not be able to obtain host information from the hypervisor (Automated)'

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential
$result = Get-VM | Get-AdvancedSetting -Name "tools.guestlib.enableHostInfo" | Select Entity, Name, Value
$result

if($result.Count -gt 0){
    
    $needsRemediation = $false

    foreach($setting in $result){
        $vm = $setting.Entity
        $value = $setting.Value

        if($value -eq 'FALSE'){
            Write-Output "$vm is compliant"
        }
        else{
            Write-Output "$vm is not compliant"
            $needsRemediation = $true
        }
    }

    if($needsRemediation) {
        
        Write-Output "Applying remediation method"
        $command = Get-VM | New-AdvancedSetting -Name "tools.guestlib.enableHostInfo" -value $false
        Write-Output "Rerun script to view changes"    
    }
    else{
        Write-Output 'All VMs are compliant. 7.23 is compliant'
    }
}
else{
    Write-Output 'No VMs to check for'
}

#TO DISCONNECT FROM SERVER CAN BE DONE AFTER ALL THE SCRIPT IS COMPLETED
#Disconnect-VIServer -Server $server -Confirm:$false