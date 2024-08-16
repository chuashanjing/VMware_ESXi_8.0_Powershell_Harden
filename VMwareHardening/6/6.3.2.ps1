Write-Output '6.3.2 (L1) Host iSCSI client, if enabled, must employ unique CHAP authentication secrets (Manual)'
#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

Write-Output '
Audit
1. Verify CHAP secrets are unique

Remediation
2. Change Values of CHAP secrets
'

$validOption = $false

while (-not $validOption) {
    $option = Read-Host "Please Enter an option (1-2)"

    if ($option -match '^[1-2]$') {
        $validOption = $true

        switch ($option) {

            '1' { 
                    Write-Output '1 - Verify CHAP secrets are unique'
                    $command = Get-VMHost | Get-VMHostHba | Where {$_.Type -eq "Iscsi"} | Select VMHost, Device, ChapType, @{N="CHAPName";E={$_.AuthenticationProperties.ChapName}}
                    $command
                }


            '2' {
                
                    Write-Output '2 - Change Values of CHAP secrets'
                    Write-Output '
                    1. From the vSphere Web Client, select the host. 
                    2. Click Configure then expand Storage. 
                    3. Select Storage Adapters then select the iSCSI Adapter. 
                    4. Under Properties click on Edit next to Authentication. 
                    5. Next to Authentication Method specify the authentication method from the 
                    dropdown. 
                       • None 
                       • Use unidirectional CHAP if required by target 
                       • Use unidirectional CHAP unless prohibited by target 
                       • Use unidirectional CHAP 
                       • Use bidirectional CHAP 
                    6. Specify the outgoing CHAP name. 
                    • Make sure that the name you specify matches the name configured on the 
                      storage side. 
                        • To set the CHAP name to the iSCSI adapter name, select "Use initiator
                          name". 
                        • To set the CHAP name to anything other than the iSCSI initiator name, 
                          deselect "Use initiator name" and type a name in the Name text box. 
                    8. Enter an outgoing CHAP secret to be used as part of authentication. Use the 
                       same secret as your storage side secret. 
                    9. If configuring with bidirectional CHAP, specify incoming CHAP credentials. 
                       • Make sure your outgoing and incoming secrets do not match. 
                    10. If configuring with bidirectional CHAP, specify incoming CHAP credentials. 
                       • Make sure your outgoing and incoming secrets do not match. 
                    11. Click OK. 
                    12. Click the second to last symbol labeled Rescan Adapter
                    '

                }
        }
    }
    else {
        Write-Output 'Invalid option, please try again.'
    }
}

