Write-Output "3.1 (L1) Host should deactivate SSH (Automated)"

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

$command = Get-VMHost | Get-VMHostService | Where { $_.key -eq "TSM-SSH" } | Select VMHost, Key, Label, Policy, Running, Required 
$command

if($command.Count -gt 0){
    $needRemediation = $false
    foreach($hosts in $command){

        $name = $hosts.VMHost
        $policy = $hosts.Policy

        if($policy -eq 'Start and Stop Manually'){
            Write-Output "$name is compliant"
        }
        else{
            Write-Output "$name is not compliant"
            $needRemediation = $true
        }
    }
    if($needRemediation){
        $command = Get-VMHost | Get-VMHostService | Where { $_.key -eq "TSM-SSH" } | SetVMHostService -Policy Off
        Write-Output 'Rerun script to view changes'
    }
}


