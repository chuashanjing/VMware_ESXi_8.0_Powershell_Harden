Write-Output '5.8 (L1) Host should reject promiscuous mode requests on standard virtual switches and port groups (Automated)'

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

# List all vSwitches and their Security Settings 
$command = Get-VirtualSwitch -Standard | Select-Object VMHost, Name, `
    @{Name="MacChanges"; Expression={ if ($_.ExtensionData.Spec.Policy.Security.MacChanges) { "Accept" } else { "Reject" } }}, `
    @{Name="PromiscuousMode"; Expression={ if ($_.ExtensionData.Spec.Policy.Security.PromiscuousMode) { "Accept" } else { "Reject" } }}, `
    @{Name="ForgedTransmits"; Expression={ if ($_.ExtensionData.Spec.Policy.Security.ForgedTransmits) { "Accept" } else { "Reject" } }}
$command

if($command.Count -gt 0){

    $needRemediation = $false  

    foreach($switchs in $command){
        $vm = $switchs.VMHost
        $promiscuous = $switchs.PromiscuousMode

        if($promiscuous -eq "Reject"){
            Write-Output "$vm is compliant"
        }
        else{
            Write-Output "$vm is not complaint"
            $needRemediation = $true   
        }
    }

    if($needRemediation){
        $command = Get-VirtualSwitch -Standard | Select VMHost, Name, ` 
            @{N="MacChanges";E={if ($_.ExtensionData.Spec.Policy.Security.MacChanges) { "Accept" } Else { "Reject"} }}, ` 
            @{N="PromiscuousMode";E={if ($_.ExtensionData.Spec.Policy.Security.PromiscuousMode) { "Accept" } Else { "Reject"} }}, ` 
            @{N="ForgedTransmits";E={if ($_.ExtensionData.Spec.Policy.Security.ForgedTransmits) { "Accept" } Else { "Reject"} }}
        Write-Output 'Rerun script to view changes'
    }
}
else{
    Write-Output "No virtual switches"
}

