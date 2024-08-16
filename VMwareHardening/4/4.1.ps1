Write-Output '4.1 (L1) Host must configure a persistent log location for all locally stored system logs (Manual)'
#FILL IN THE PLACE HOLDERS IF NEEDED

#TO CONNECT TO SERVER IF NEEDED ELSE CAN BE DONE MANUALLY
#$server = "server address"
#$credential = Get-Credential #prompt for user and password
#Connect-VIServer -Server $server -Credential $credential

#for eg. [datastore1]/systemlogs

Write-Output '
4.1 is considered manual. So I will let you chooose between
manual and automated.

1. Manual
Details: Contains steps for audit and remediation

2. Automated
Details: 
- Require you to fill in a datastore location path placeholder
- It will execute the commands and automatically check and remediate for you.
'

$validOption = $false

while (-not $validOption) {
    $option = Read-Host "Please Enter an option (1-2)"

    if ($option -match '^[1-2]$') {
        $validOption = $true

        switch ($option) {

            '1' { 
                    Write-Output '1 - 4.1 Manual'
                    Write-Output "
                    Audit:
                    To verify persistent logging is configured properly, perform the following from the 
                    vSphere web client: 
                    1. Select the host 
                    2. Click Configure then expand System then select Advanced System Settings. 
                    3. Select Edit then enter Syslog.global.LogDir in the filter. 
                    4. Ensure Syslog.global.logDir field is not empty (null value) or is not set explicitly 
                       to a non-persistent datastore or a scratch partition. 
                       If the Syslog.global.logDir parameter is pointing to 'Scratch' location (i.e. empty (null 
                       value) or is not set explicitly to a non-persistent datastore or a scratch partition), then 
                       ensure that the 'ScratchConfig.CurrentScratchLocation' parameter is also pointing to 
                       persistent storage.
                    "
                    Write-Output "
                    Remediation:
                    To configure persistent logging properly, perform the following from the vSphere web 
                    client: 
                    1. Select the host 
                    2. Click Configure then expand System then select Advanced System Settings. 
                    3. Select Edit then enter Syslog.global.LogDir in the filter. 
                    4. Set Syslog.global.logDir to a persistent location specified as [datastorename] 
                       path_to_file where the path is relative to the datastore. For example, [datastore1] 
                       /systemlogs. 
                    5. Click OK. 
                    "
                }


            '2' {
                    Write-Output '2 - 4.1 Automated'
                    $location = "<PATH_TO_FILE_RELATIVE_TO_DATASTORE>"

                    $command = Get-VMHost | Select Name, @{N="Syslog.global.logDir";E={$_ | Get-AdvancedConfiguration Syslog.global.logDir | Select -ExpandProperty Values}}
                    $command

                    if($command.Count -gt 0){

                        $needRemediation = $false

                        foreach($log in $command){
                            $name = $log.Name
                            $logdir = $log.'Syslog.global.logDir'

                            if($logDir -eq $location){
                                Write-Output "$name is compliant"
                            }
                            else{
                                Write-Output "$name is not compliant"
                                $needRemediation = $true
                            }
                        }

                        if($needRemediation){
                            Write-Output 'Executing remediation command'
                            $command = Get-VMHost | Foreach { Set-AdvancedConfiguration -VMHost $_ -Name Syslog.global.logDir -Value "$location" }
                            Write-Output 'Rerun script to view changes'
                        }

                    }
                }
        }
    }
    else {
        Write-Output 'Invalid option, please try again.'
    }
}




