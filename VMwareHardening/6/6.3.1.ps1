Write-Output '6.3.1 (L1) Host iSCSI client, if enabled, must employ bidirectional/mutual CHAP authentication (Automated)'
#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

$command = Get-VMHost | Get-VMHostHba | Where {$_.Type -eq "Iscsi"} | Select VMHost, Device, ChapType, @{N="CHAPName";E={$_.AuthenticationProperties.ChapName}}
$command

if($command.Count -gt 0){

    $needRemediation = $false

    foreach($vmhost in $command){
        $hosts = $vmhost.VMHost
        $ChapType = $vmhost.ChapType

        if($ChapType -eq 'Mutual'){
            Write-Output "$hosts is compliant"
        }
        else{
            Write-Output "$hosts is not compliant"
            $needRemediation = $true
        }
    }

    if($needRemediation){
        # Set the Chap settings for the Iscsi Adapter 
        $command = Get-VMHost | Get-VMHostHba | Where {$_.Type -eq "Iscsi"} | Set-VMHostHba # 
        #Use desired parameters here
        
        Write-Output 'Rerun script to view changes'
    }

}
else{

    Write-Output 'No VM host to check for'

}
