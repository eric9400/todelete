function Get-FirefoxAddon {
    $res = @()

    # Define the path to the Firefox profile directory
    $profileDir = "$env:APPDATA\Mozilla\Firefox\Profiles"

    # Get the list of Firefox profile directories
    try {
        $profileDirs = Get-ChildItem -erroraction 'silentlycontinue' -Path $profileDir -Directory
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

    $firefoxInfo = @{
        Version      = $version
        Addons       = $addons
    }
    return $firefoxInfo
}
