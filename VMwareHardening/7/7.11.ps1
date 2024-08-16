Write-Output '7.11 (L1) Virtual machines must remove unnecessary USB/XHCI devices'
# Connect to vSphere Server (if needed) 
# $server = "server address" 
# $credential = Get-Credential 
# Prompt for user and password 
# Connect-VIServer -Server $server -Credential $credential 
# Define the functions for Get-ParallelPort and Remove-ParallelPort

$result = Get-VM | Get-UsbDevice
$result 

if ($result.Count -gt 0){

    $needRemediation = $false

    foreach ($usb in $result){
    
        $vm = $usb.Parent
        $connection = $usb.ConnectionState

        if($connection -eq 'Connected'){
            Write-Output "$vm is connected and is being used. Thus it is necessary, and it is compliant"
        }
        else{
            Write-Output "$vm is not connected but not removed"
            $needRemediation = $true
        }
    
    }

    if($needRemediation) {
        $command = Get-VM | Get-USBDevice | Remove-UsbDevice
        Write-Output 'Rerun script to view changes'
    
    }

}
else{

    Write-Output "No VMS to check for"
    
}