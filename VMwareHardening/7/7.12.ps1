Write-Output '7.12 (L1) Virtual Machines must remove unnecessary serial port devices (Automated)'
# Connect to vSphere Server (if needed) 
# $server = "server address" 
# $credential = Get-Credential 
# Prompt for user and password 
# Connect-VIServer -Server $server -Credential $credential 
# Define the functions for Get-ParallelPort and Remove-ParallelPort
Function Get-SerialPort {
    Param (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
        $VM
    )
    Process {
        Foreach ($VMachine in $VM) {
            Foreach ($Device in $VMachine.ExtensionData.Config.Hardware.Device) {
                If ($Device.gettype().Name -eq "VirtualSerialPort"){
                    $Details = New-Object PsObject
                    $Details | Add-Member Noteproperty VM -Value $VMachine
                    $Details | Add-Member Noteproperty Name -Value $Device.DeviceInfo.Label
                    If ($Device.Backing.FileName) { $Details | Add-Member Noteproperty Filename -Value $Device.Backing.FileName }
                    If ($Device.Backing.Datastore) { $Details | Add-Member Noteproperty Datastore -Value $Device.Backing.Datastore }
                    If ($Device.Backing.DeviceName) { $Details | Add-Member Noteproperty DeviceName -Value $Device.Backing.DeviceName }
                    $Details | Add-Member Noteproperty Connected -Value $Device.Connectable.Connected
                    $Details | Add-Member Noteproperty StartConnected -Value $Device.Connectable.StartConnected
                    $Details
                }
            }
        }
    }
}

Function Remove-SerialPort {
    Param (
        [Parameter(Mandatory=$True,ValueFromPipelinebyPropertyName=$True)]
        $VM,
        [Parameter(Mandatory=$True,ValueFromPipelinebyPropertyName=$True)]
        $Name
    )
    Process {
        $VMSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
        $VMSpec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec
        $VMSpec.deviceChange[0] = New-Object VMware.Vim.VirtualDeviceConfigSpec
        $VMSpec.deviceChange[0].operation = "remove"
        $Device = $VM.ExtensionData.Config.Hardware.Device | Foreach {
            $_ | Where {$_.gettype().Name -eq "VirtualSerialPort"} | Where { $_.DeviceInfo.Label -eq $Name }
        }
        $VMSpec.deviceChange[0].device = $Device
        $VM.ExtensionData.ReconfigVM_Task($VMSpec)
    }
}

Function Get-ParallelPort {
    Param (
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
        $VM
    )
    Process {
        Foreach ($VMachine in $VM) {
            Foreach ($Device in $VMachine.ExtensionData.Config.Hardware.Device) {
                If ($Device.gettype().Name -eq "VirtualParallelPort"){
                    $Details = New-Object PsObject
                    $Details | Add-Member Noteproperty VM -Value $VMachine
                    $Details | Add-Member Noteproperty Name -Value $Device.DeviceInfo.Label
                    If ($Device.Backing.FileName) { $Details | Add-Member Noteproperty Filename -Value $Device.Backing.FileName }
                    If ($Device.Backing.Datastore) { $Details | Add-Member Noteproperty Datastore -Value $Device.Backing.Datastore }
                    If ($Device.Backing.DeviceName) { $Details | Add-Member Noteproperty DeviceName -Value $Device.Backing.DeviceName }
                    $Details | Add-Member Noteproperty Connected -Value $Device.Connectable.Connected
                    $Details | Add-Member Noteproperty StartConnected -Value $Device.Connectable.StartConnected
                    $Details
                }
            }
        }
    }
}

Function Remove-ParallelPort {
    Param (
        [Parameter(Mandatory=$True,ValueFromPipelinebyPropertyName=$True)]
        $VM,
        [Parameter(Mandatory=$True,ValueFromPipelinebyPropertyName=$True)]
        $Name
    )
    Process {
        $VMSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
        $VMSpec.deviceChange = New-Object VMware.Vim.VirtualDeviceConfigSpec
        $VMSpec.deviceChange[0] = New-Object VMware.Vim.VirtualDeviceConfigSpec
        $VMSpec.deviceChange[0].operation = "remove"
        $Device = $VM.ExtensionData.Config.Hardware.Device | Foreach {
            $_ | Where {$_.gettype().Name -eq "VirtualParallelPort"} | Where { $_.DeviceInfo.Label -eq $Name }
        }
        $VMSpec.deviceChange[0].device = $Device
        $VM.ExtensionData.ReconfigVM_Task($VMSpec)
    }
}

$result = Get-VM | Get-SerialPort
$result


if($result.Count -gt 0){   
    $needsRemediation = $false  
    foreach($setting in $result){  
    
        $vm = $setting.VMName  
        $connection = $setting.Connected  
        
        if($connection -eq $true){ 
            
            #IF THIS DONT WORK TRY 'TRUE' or replacing 'True' depends on $result.VMName output

            Write-Output "$vm is compliant"
        } 
        else{
            Write-Output "$vm is not compliant" 
            $needsRemediation = $true  
        }  
    }  

    if($needsRemediation) {  
        Write-Output "Applying remediation method"  
        $command = Get-VM | Get-SerialPort | Remove-SerialPort
        Write-Output 'Rerun script to view changes'       
    }  
    else{   
        Write-Output 'All VMs are compliant. 7.12 is compliant'  
    } 
} 
else{  
    Write-Output 'No VMs to check for' 
} 

# Disconnect from vSphere Server (if connected earlier) # Disconnect-VIServer -Server $server -Confirm:$false