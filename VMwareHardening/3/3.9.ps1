Write-Output '3.9 (L1) Host must automatically deactivate shell services (Automated)'

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

$command = Get-VMHost | Select Name, @{N="UserVars.ESXiShellTimeOut";E={$_ | Get-AdvancedSettings UserVars.ESXiShellTimeOut | Select -ExpandProperty Values}} 
$command

if($command.Count -gt 0){

    $needRemediation = $false

    foreach($hosts in $command){
        $name = $hosts.Name
        $value = $hosts.'UserVars.ESXiShellTimeOut'

        if($value -le '3600'){
            Write-Output "$hosts is compliant"
        }
        else{
            Write-Output "$hosts is not compliant"
            $needRemediation = $true
        }

    }

    if(needRemediation){
        Write-Output 'Setting value to 0 disables ESXiShellTimeout'
        $command = Get-VMHost | Get-AdvancedSetting -Name 'UserVars.ESXiShellTimeOut' | Set-AdvancedSetting -Value "3600"
        Write-Output 'Rerun script to view changes'
    }

}
else{
    Write-Output 'No VMHost to check for'
}



