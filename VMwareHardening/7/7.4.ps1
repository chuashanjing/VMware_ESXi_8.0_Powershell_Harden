Write-Output '7.4 (L1) Virtual machines should deactivate 3D graphics features when not required (Automated)'

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

$array = @("<VM-NAME1>", "<VM-NAME2>", "<VM-NAME3>", "<ADD MORE IF NEEDED>")

foreach($VM in $array){

    $command = Get-VM -Name $VM | Get-AdvancedSetting mks.enable3d
    $command

    if($command.Count -gt 0){
        
        if($command.Value -eq 'FALSE'){
            Write-Output "$VM is compliant"
        }
        else{
            Write-Output "$VM is not compliant"
            $command = Get-VM -Name $VM | Get-AdvancedSetting mks.enable3d | Set-AdvancedSetting -Value FALSE
            Write-Output 'Rerun script to view changes'
        }

    }
    else{

        Write-Output 'No settings for this VM'

    }
}