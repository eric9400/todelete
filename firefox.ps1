function Get-FirefoxAddon {
    $res = @()

    # Define the path to the Firefox profile directory
    $profileDir = "$env:APPDATA\Mozilla\Firefox\Profiles"

    # Get the list of Firefox profile directories
    try {
        $profileDirs = Get-ChildItem -Path $profileDir -Directory
    }
    catch {
    }

    # Iterate through each profile directory
    foreach ($dir in $profileDirs) {
        # Define the path to extensions.json
        $extensionsFile = Join-Path -P $dir.FullName -ChildPath "addons.json" 

        if (Test-Path $extensionsFile -PathType leaf) {
            $json = Get-Content -Path $extensionsFile -Raw | ConvertFrom-Json
            
            # retrieve each addon's name
            foreach ($addon in $json.addons) {
                $res += $addon.name
            }
        }
    }
    return $res
}

function Get-Firefox {
    $version = Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Mozilla\Mozilla Firefox' -Name "CurrentVersion"
    $addons = Get-FirefoxAddon

    # retrieve certificate information from Firefox
    # $certificates = Get-ChildItem -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Filter "cert*.db" -Recurse | ForEach-Object {
    #     $profileDir = $_.DirectoryName
    #     $certDBPath = Join-Path -Path $profileDir -ChildPath $_.Name
    #     $certDB = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Store -ArgumentList $certDBPath
    #     $certDB.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadOnly)
    #     $certs = $certDB.Certificates
    #     $certDB.Close()
    #     $certs
    # }

    # $certificateInfo = $certificates | Select-Object -Property Subject, Issuer, NotBefore, NotAfter

    # $firefoxInfo.Certificates = $certificateInfo

    $firefoxInfo = @{
        Version      = $version
        Addons       = $addons
        Certificates = $certificateInfo
    }
    return $firefoxInfo
}
