Write-Output "2.10 (L1) Host must restrict inter-VM transparent page sharing (Automated)"

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

$command = Get-VMHost | Get-AdvancedSetting -Name Mem.ShareForceSalting
$command

if($command.Count -gt 0){
    $needRemediation = $false
    foreach($hosts in $command){

        $name = $hosts.Name
        $value = $hosts.Value
www
        if($value -eq '2'){
            Write-Output "$name is compliant"
        }
        else{
            Write-Output "$name is not compliant"
            $needRemediation = $true
        }
    }
    if($needRemediation){
        $command = Get-VMHost | Get-AdvancedSetting -Name Mem.ShareForceSalting | Set-AdvancedSetting -Value 2
        Write-Output 'Rerun script to view changes'
    }
}


