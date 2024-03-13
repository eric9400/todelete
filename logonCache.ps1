function Get-CachedUsers
{
    $res = @()
    Get-WmiObject Win32_UserProfile | Where-Object { $_.Special -eq $false -and $_.Loaded -eq $false } | ForEach-Object {
        $username = $_.LocalPath.Split('\')[-1]
        if ($username -ne 'Default' -and $username -ne 'Public') {
            $res += $username
        }
    }
    return $res
}

function Get-LogonCache
{
    $connectedUsers = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName
    $cachedUsers = Get-ChildItem -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\ProfileList" | Select-Object -ExpandProperty Name

    $logonCacheInfo = @{
        ConnectedUsers = $connectedUsers
        CachedUsers = $cachedUsers
    }
    return $logonCacheInfo
}
