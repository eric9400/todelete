function Get-InstalledSoftware
{
    $res = @()
    $InstalledSoftware = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
    foreach ($obj in $InstalledSoftware)
    {
        # remove unnecessary null values
        if ($null -eq $obj.GetValue('DisplayName'))
        {
            continue
        }
        $tmp = @{
            Name = $obj.GetValue('DisplayName')
            Version = $obj.GetValue('DisplayVersion')
        }
        $res += $tmp
    }
    return $res
}

function Get-Applications {
    # retrieve installed software
    $installedSoftware = Get-InstalledSoftware

    # retrieve running scheduled tasks
    $scheduledTasks = Get-ScheduledTask | Where-Object { $_.State -eq "Running" } | Select-Object -ExpandProperty TaskName

    # retrieve running processes
    $runningProcesses = Get-Process | Select-Object -ExpandProperty ProcessName -Unique

    # retrieve open ports
    $openPorts = Get-NetTCPConnection | Where-Object { $_.State -eq "Listen" } | Select-Object -ExpandProperty LocalPort | Sort-Object -Unique
    
    # retrieve start menu items, lnk files are shortcuts
    $startMenu = Get-ChildItem -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs" -Recurse | Where-Object { $_.Extension -eq ".lnk" } | Select-Object -ExpandProperty Name

    $applicationsInfo = @{
        Software = $installedSoftware
        ScheduledTasks = $scheduledTasks
        RunningProcesses = $runningProcesses
        OpenPorts = $openPorts
        StartMenu = $startMenu
    }

    return $applicationsInfo
}