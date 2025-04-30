
# Broadcast environment variable changes system-wide (WM_SETTINGCHANGE)
$HWND_BROADCAST = [IntPtr]::Zero
$WM_SETTINGCHANGE = 0x1A
$timeout = 5000
$sendMessageTimeout = @"
using System;
using System.Runtime.InteropServices;
public class PInvoke {
    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern bool SendMessageTimeout(IntPtr hWnd, uint Msg, UIntPtr wParam, IntPtr lParam, uint fuFlags, uint uTimeout, out IntPtr lpdwResult);
}
"@
Add-Type -TypeDefinition $sendMessageTimeout -Language CSharp

[IntPtr]$result = [IntPtr]::Zero
[void][PInvoke]::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE, [UIntPtr]::Zero, [IntPtr]::Zero, 2, $timeout, [ref]$result)

Write-Host "Environment variables updated."

# Stop the service
.\nssm stop "FlexIt Analytics"

# Wait until the service is fully stopped
$serviceName = "FlexIt Analytics"
do {
    Start-Sleep -Seconds 2
    $status = (Get-Service -Name $serviceName).Status
    Write-Host "Waiting for service '$serviceName' to stop... Current status: $status"
} while ($status -ne "Stopped")

Write-Host "Service '$serviceName' has stopped successfully."

# Start the service
.\nssm start "FlexIt Analytics"

# Keep the container running
ping -t localhost > $null
