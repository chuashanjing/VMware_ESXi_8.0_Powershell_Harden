Write-Output '7.1 (L1) Virtual machines must enable Secure Boot (Manual)'
#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

$array = @("<VM-NAME1>", "<VM-NAME2>", "<VM-NAME3>", "<ADD MORE IF NEEDED>")

foreach($VM in $array){

    $command = (Get-VM -Name $VM).ExtensionData.Config.BootOptions.EfiSecureBootEnabled 
    $command

#if this cause error, try changing $true to 'True' or 'TRUE'
#we are unsure of this since we do not have the viserver to test out on
    if($command -eq $true){
        Write-Output "$VM is compliant"
    }
    else{

        Write-Output "$VM is not compliant"
        $VMobj = (Get-VM -Name $VM) 
        $ConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec 
        $bootOptions = New-Object VMware.Vim.VirtualMachineBootOptions 
        $bootOptions.EfiSecureBootEnabled = $true 
        $ConfigSpec.BootOptions = $bootOptions 
        $task = $VMobj.ExtensionData.ReconfigVM_Task($ConfigSpec) 
        Write-Object 'Rerun script to view changes'
        
    }

}



