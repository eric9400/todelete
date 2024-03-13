function Get-Net {
    # retrieve IPv4 address
    $ipAddress = (Get-NetIPAddress -AddressFamily IPv4).IPAddress

    # retrieve MAC address
    $macAddress = (Get-NetAdapter | Where-Object { $_.Status -eq "Up" }).MacAddress

    # retrieve default gateway
    $defaultGateway = (Get-NetRoute -AddressFamily IPv4 | Where-Object { $_.DestinationPrefix -eq "0.0.0.0/0" }).NextHop

    # retrieve Wi-Fi name
    $wifiNetwork = (Get-NetConnectionProfile).Name

    # retrieve VPN/Proxy config
    # TODO
    # $proxyVPNConfig = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" | Select-Object -ExpandProperty ProxyServer

    # retrieve domain name
    $domainName = (Get-WmiObject Win32_ComputerSystem).Domain

    # retrieve Windows/DNS name
    $computerName = $env:COMPUTERNAME

    $networkInfo = @{
        IPv4Address    = $ipAddress
        MACAddress     = $macAddress
        DefaultGateway = $defaultGateway
        WiFiNetwork    = $wifiNetwork
        # TODO
        # ProxyVPNConfig = $proxyVPNConfig
        DomainName     = $domainName
        ComputerName   = $computerName
    }

    return $networkInfo
}
