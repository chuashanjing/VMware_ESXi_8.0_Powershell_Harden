Write-Output '7.26 (L1) Virtual machines must limit the size of diagnostic logs (Automated)'

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential
$result = Get-VM | Get-AdvancedSetting -Name "log.rotateSize" | Select Entity, Name, Value
$result

if($result.Count -gt 0){
    
    $needsRemediation = $false

    foreach($setting in $result){
        $vm = $setting.Entity
        $value = $setting.Value

        if($value -eq 1024000){
            Write-Output "$vm is compliant"
        }
        else{
            Write-Output "$vm is not compliant"
            $needsRemediation = $true
        }
    }

    if($needsRemediation) {
        
        Write-Output "Applying remediation method"
        $command = Get-VM | New-AdvancedSetting -Name "log.rotateSize" -value "1024000"
        Write-Output "Rerun script to view changes"    
    }
    else{
        Write-Output 'All VMs are compliant. 7.26 is compliant'
    }
}
else{
    Write-Output 'No VMs to check for'
}

#TO DISCONNECT FROM SERVER CAN BE DONE AFTER ALL THE SCRIPT IS COMPLETED
#Disconnect-VIServer -Server $server -Confirm:$false