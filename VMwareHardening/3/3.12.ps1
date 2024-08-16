Write-Output '3.12 (L1) Host must lock an account after a specified number of failed login attempts (Automated)'

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

$command = Get-VMHost | Get-AdvancedSetting -Name Security.AccountLockFailures
$command

if($command.Count -gt 0){

    $needRemediation = $false

    foreach($hosts in $command){
        $name = $hosts.Name
        $value = $hosts.Value

        if($value -eq '5'){
            Write-Output "$hosts is compliant"
        }
        else{
            Write-Output "$hosts is not compliant"
            $needRemediation = $true
        }

    }

    if(needRemediation){
        $command = Get-VMHost | Get-AdvancedSetting -Name Security.AccountLockFailures | Set-AdvancedSetting -Value 5
        Write-Output 'Rerun script to view changes'
    }

}
else{
    Write-Output 'No VMHost to check for'
}



