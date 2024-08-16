Write-Output '7.15 (L1) Virtual Machines must remove unnecessary floppy devices (Automated)'

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential
$result = Get-VM | Get-FloppyDrive | Select Parent, Name, Connection State
$result

if($result.Count -gt 0){
    
    $needsRemediation = $false

    foreach($setting in $result){
        $vm = $setting.Parent
        $connection = $setting.ConnectionState

        if($connection -eq 'Disconnected'){ 

        #IF Disconnected is causing the error try changing to the connection state presented by $result
        #Cant test the scripts since no have vshpere environment:)

            Write-Output "$vm is compliant"
        }
        else{
            Write-Output "$vm is not compliant"
            $needsRemediation = $true
        }
    }

    if($needsRemediation) {
        
        Write-Output "Applying remediation method"
        $command = Get-VM | Get-FloppyDrive | Remove-FloppyDrive
        Write-Output "Rerun script to view changes"    
    }
    else{
        Write-Output 'All VMs are compliant. 7.15 is compliant'
    }
}
else{
    Write-Output 'No VMs to check for'
}

#TO DISCONNECT FROM SERVER CAN BE DONE AFTER ALL THE SCRIPT IS COMPLETED
#Disconnect-VIServer -Server $server -Confirm:$false