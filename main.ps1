Import-Module .\applications.ps1
Import-Module .\firefox.ps1
Import-Module .\net.ps1
Import-Module .\security.ps1
Import-Module .\logonCache.ps1
Import-Module .\browser.ps1

function run {
    $net = Get-Net
    $browser = Get-Browser
    $firefox = Get-Firefox
    $logonCache = Get-LogonCache
    $applications = Get-Applications
    $security = Get-Security

    $res = @{
        NET     = $net
        Browser = $browser
        Firefox = $firefox
        LogonCache = $logonCache
        Applications = $applications
        Security = $security
    }
    return $res | ConvertTo-Json -Depth 10
}

run