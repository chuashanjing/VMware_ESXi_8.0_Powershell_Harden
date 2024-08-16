Write-Output '7.16 (L1) Virtual Machines must deactivate console drag and drop operations (Automated)'

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

$array = @("<VM-NAME1>", "<VM-NAME2>", "<VM-NAME3>", "<ADD MORE IF NEEDED>")

foreach($VM in $array){

    $command = Get-VM -Name $VM | Get-AdvancedSetting isolation.tools.dnd.disable
    
    if($command -eq $null){
        
        Write-Output "$VM is compliant (setting is missing)"
    }
    else {
        
        if($command.Value -eq 'TRUE' -or $command.Value -eq ''){
            Write-Output "$VM is compliant"
        }
        else{
    
            Write-Output "$VM is not compliant. Applying remediation"
            $command = Get-VM -Name $VM | Remove-AdvancedSetting -Name isolation.tools.dnd.disable
            Write-Output 'Rerun script to view changes'
        }
    
    }
}