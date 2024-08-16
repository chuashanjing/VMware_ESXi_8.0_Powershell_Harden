Write-Output '2.4 (L1) Host image profile acceptance level must be PartnerSupported or higher (Automated)'

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

$needRemediation = $false
Foreach ($VMHost in Get-VMHost ) { 
    $ESXCli = Get-EsxCli -VMHost $VMHost
    $acceptanceLevel = $ESXCli.software.acceptance.get()
    $VMHost |  Select Name, @{N="AcceptanceLevel";E={ $acceptanceLevel }}

    if($acceptanceLevel -eq "VMware Certified" -or $acceptanceLevel -eq "VMware Accepted" -or $acceptanceLevel -eq "Partner Supported"){
        Write-Output "$($VMHost.Name) is compliant"
    }
    else{
       Write-Output "$($VMHost.Name) is not compliant"
       $needRemediation = $true
    }

} 

if($needRemediation){

    Foreach ($VMHost in Get-VMHost ) { 
        $ESXCli = Get-EsxCli -VMHost $VMHost 
        $ESXCli.software.acceptance.Set("PartnerSupported") 
    }

    Write-Output 'Rerun script to view changes'

}