Write-Output '5.7 (L1) Host should reject MAC address changes on standard virtual switches and port groups (Automated)'

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

# List all vSwitches and their Security Settings 
$command = Get-VirtualSwitch -Standard | Select VMHost, Name, ` 
    @{N="MacChanges";E={if ($_.ExtensionData.Spec.Policy.Security.MacChanges) { "Accept" } Else { "Reject"} }}, ` 
    @{N="PromiscuousMode";E={if ($_.ExtensionData.Spec.Policy.Security.PromiscuousMode) { "Accept" } Else { "Reject"} }}, ` 
    @{N="ForgedTransmits";E={if ($_.ExtensionData.Spec.Policy.Security.ForgedTransmits) { "Accept" } Else { "Reject"} }}

$command

if($command.Count -gt 0){

    $needRemediation = $false 

    foreach($switchs in $command){
        $vm = $switchs.VMHost
        $mac_change = $switchs.MacChanges

        if($mac_change -eq "Reject"){
            Write-Output "$vm is compliant"
        }
        else{
            Write-Output "$vm is not complaint"
            $needRemediation = $true   
        }
    }

    if($needRemediation){
        $command = esxcli network vswitch standard policy security set -v vSwitch2 -m false
        Write-Output 'Rerun script to view changes'
    }

}
else{
    Write-Output "No virtual switches"
}

