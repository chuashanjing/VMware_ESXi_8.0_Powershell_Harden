Write-Output '7.2 (L1) Virtual machines must require encryption for vMotion (Manual)'
#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

$array = @("<VM-NAME1>", "<VM-NAME2>", "<VM-NAME3>", "<ADD MORE IF NEEDED>")

foreach($VM in $array){

    $command = (Get-VM -Name $VM).ExtensionData.Config.MigrateEncryption
    $command

    if($command -eq 'required'){
        Write-Output "$VM is compliant"
    }
    else{

        Write-Output "$VM is not compliant"
        $VMview = Get-VM -Name $VM | Get-View  
        $ConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec 
        $ConfigSpec.MigrateEncryption = New-Object 
        VMware.Vim.VirtualMachineConfigSpecEncryptedVMotionModes 
        $ConfigSpec.MigrateEncryption = "required" 
        $VMview.ReconfigVM_Task($ConfigSpec)
        Write-Object 'Rerun script to view changes'
        
    }

}



