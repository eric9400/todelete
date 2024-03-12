function Get-Security
{
    $os_version = Get-WmiObject Win32_OperatingSystem | Select-Object -ExpandProperty 'Version'
    $service_pack = Get-WmiObject Win32_OperatingSystem | Select-Object -ExpandProperty 'ServicePackMajorVersion'
    $patch = Get-HotFix | Select-Object -ExpandProperty 'HotFixID'
    $firewall = Get-NetFirewallProfile | Select-Object Name, Enabled
    $firewallRule = Get-NetFirewallRule | Where-Object { $_.Enabled -eq "True" } | Select-Object -Unique -ExpandProperty DisplayName
    $antivirus = Get-WmiObject -Namespace "root\SecurityCenter2" -Class "AntivirusProduct" | Select-Object -ExpandProperty displayName
    # get antivirus version
    $antivirusVersion = Get-WmiObject -Namespace "root\SecurityCenter2" -Class "AntivirusProduct" | Select-Object -ExpandProperty productVersion


    $security_info = @{
        OSVersion = $os_version
        ServicePack = $service_pack
        InstalledPatches = $patch
        Firewall = $firewall
        FirewallRule = $firewallRule
        Antivirus = $antivirus
        AntivirusVersion = $antivirusVersion
    }
    return $security_info
}

Write-Host (Get-Security | ConvertTo-Json)