Write-Output '3.3 (L1) Host must deactivate the ESXi Managed Object Browser (MOB) (Automated)'

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

$command = Get-VMHost | Get-AdvancedSetting -Name Config.HostAgent.plugins.solo.enableMob
$command

if($command.Count -gt 0){

    $needRemediation = $false

    foreach($hosts in $command){
        $name = $hosts.Name
        $value = $hosts.Value

        if($value -eq 'false'){
            Write-Output "$hosts is compliant"
        }
        else{
            Write-Output "$hosts is not compliant"
            $needRemediation = $true
        }

    }

    if(needRemediation){
        
        Write-Output '
        To disabled MOB, perform the following from the vSphere Web Client: 
        1. Select a host 
        2. Click Configure then expand System then select Advanced System Settings. 
        3. Click Edit then search for Config.HostAgent.plugins.solo.enableMob
        4. Set the value to false. 
        5. Click OK. 
        '
    }

}
else{
    Write-Output 'No VMHost to check for'
}



