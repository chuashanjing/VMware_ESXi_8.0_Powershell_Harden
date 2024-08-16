Write-Output '4.2 (L1) Host must transmit system logs to a remote log collector (Automated)'
#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

$location = "<Correct_Syslog_Global_LogHost_Location>"

$command = Get-VMHost | Select Name, @{N="Syslog.global.logHost";E={$_ | Get-AdvancedSetting Syslog.global.logHost}}
$command

if($command.Count -gt 0){

    $needRemediation = $false

    foreach($log in $command){
        $name = $log.Name
        $syslog = $log.'Syslog.global.logHost'

        if($syslog -eq $location){
            Write-Output "$name is compliant"
        }
        else{
            Write-Output "$name is not compliant"
            $needRemediation = $true
        }

    }

    if($needRemediation){
        # Set Syslog.global.logHost for each host 
        $command = Get-VMHost | Foreach { Set-AdvancedSetting -VMHost $_ -Name Syslog.global.logHost -Value "$location" } 
        Write-Output 'Rerun script to view changes'
    }

}
else{
    Write-Output 'No log collector'
}







