Write-Output '3.7 (L1) Host must automatically terminate idle DCUI sessions (Automated)'

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

$command = Get-VMHost | Get-AdvancedSetting -Name UserVars.DcuiTimeOut
$command

if($command.Count -gt 0){

    $needRemediation = $false

    foreach($hosts in $command){
        $name = $hosts.Name
        $value = $hosts.Value

        if($value -le '600'){
            Write-Output "$hosts is compliant"
        }
        else{
            Write-Output "$hosts is not compliant"
            $needRemediation = $true
        }

    }

    if(needRemediation){
        
        $command = Get-VMHost | Get-AdvancedSetting -Name UserVars.DcuiTimeOut | Set-AdvancedSetting -Value 600 
        Write-Output 'Rerun script to view changes'
    }

}
else{
    Write-Output 'No VMHost to check for'
}



