Write-Output '2.2 (L1) Host must have all software updates installed (Manual)'

#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

Foreach ($VMHost in Get-VMHost ) { 
$EsxCli = Get-EsxCli -VMHost $VMHost -V2 $EsxCli.software.vib.list.invoke() | Select-Object @{N="VMHost";E={$VMHost}},* 

$EsxCli

Write-Output '
Verify that the patches are up to date.
The following PowerCLI snippet will provide a list of all installed patches
You may also manage updates via VMware Lifecycle Manager located under Menu, 
Lifecycle Manager.
'

Write-Output '
Remediation:
Use VMware Lifecycle Manager to update and upgrade hosts when ESXi is managed 
through VMware vCenter. For standalone hosts use esxcli or API-driven methods for 
applying updates. 
Employ a process to keep ESXi hosts up to date with patches in accordance with 
industry standards and internal guidelines. Leverage the VMware Lifecycle Manager to 
test and apply patches as they become available. 
'
}


