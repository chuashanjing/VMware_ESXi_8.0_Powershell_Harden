Write-Output '7.5 (L1) Virtual machines must be configured to lock when the last console connection is closed (Automated)'

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

$result = Get-VM -Name $VM | Get-AdvancedSetting tools.guest.desktop.autolock
$result 

if($result.Count -gt 0){

    $needRemediation = $false

    foreach($settings in $result){

        #BASED ON $RESULT CHANGE ENTITY AND VALUE.
        $vm = $settings.Entity
        $value = $settings.Value

        #CHANGE 'TRUE' to the value based of $result.Value output
        if($value -eq 'TRUE'){
            Write-Output "$vm is compliant"
        }
        else{
            Write-Output "$vm is not compliant"
            $needRemediation = $true
        }

    }

    if(needRemediation){

        $command = Get-VM -Name $VM | Remove-AdvancedSetting -Name tools.guest.desktop.autolock
        Write-Output 'Rerun script to view changes'
    }

}
else{

    Write-Output 'No VMs to check for'

}