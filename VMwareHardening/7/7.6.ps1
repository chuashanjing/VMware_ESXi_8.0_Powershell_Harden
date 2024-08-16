Write-Output '7.6 (L1) Virtual Machines must limit console sharing (Automated)'

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

$result = Get-VM | Get-AdvancedSetting -Name "RemoteDisplay.maxConnections" | Select Entity, Name, Value
$result 

if($result.Count -gt 0){

    $needRemediation = $false

    foreach($settings in $result){


        $vm = $settings.Entity
        $value = $settings.Value

        if($value -eq '1'){
            Write-Output "$vm is compliant"
        }
        else{
            Write-Output "$vm is not compliant"
            $needRemediation = $true
        }

    }

    if(needRemediation){
        #CHOOSE 1
        #run the following PowerCLI command for VMs that do not specify the setting
        $command = Get-VM | New-AdvancedSetting -Name "RemoteDisplay.maxConnections" -value 1 -Force
        
        #Run the following PowerCLI command for VMs that specify the setting but have the wrong value for it: 
        #$command = Get-VM | New-AdvancedSetting -Name "RemoteDisplay.maxConnections" -value 1
        Write-Output 'Rerun script to view changes'
    }

}
else{

    Write-Output 'No VMs to check for'

}