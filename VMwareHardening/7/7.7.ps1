Write-Output '7.7 (L1) Virtual Machines must limit PCI/PCIe device passthrough functionality (Automated)'

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

$result = Get-VM | Get-AdvancedSetting -Name "pciPassthru*.present" | Select Entity, Name, Value
$result

if($result.Count -gt 0){

    $needRemediation = $false

    foreach($setting in $result){
        
        $vm = $setting.Entity
        $value = $setting.Value

        if($value -eq 'False' -or $value -eq ''){
            Write-Output "$vm is compliant"
        }
        else {
            Write-Output "$vm is not compliant"
            $needRemediation = $true
        }
    
    }
   
    if($needRemediation){
        $command = Get-VM | New-AdvancedSetting -Name "pci.Passthru*.present" -value ""

        #if it does not change, try this below: chatgpt say cis might not work.
        #$command = Get-VM | Set-AdvancedSetting -Name "pci.Passthru*.present" -value ""

        Write-Output 'Rerun to view changes'
    }

}
else{
    Write-Output 'No VMs to check for'
}

