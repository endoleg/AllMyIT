function Install-Features {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        $Features,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        $Wizard = $false
    )

    if ($Wizard -eq $true) {
        $Features = Read-Host "which server feature do you want to install ?"
    }

    if (! (Test-Command -Command "Install-WindowsFeature")) {
        Write-Verbose -Message "Device is not a server ! Exit"
    }
    else {
        $InstalledFeatures = Get-WindowsFeature | Where-Object InstallState -eq "Installed"

        foreach ($Feature in $Features) {
    
            if (!($InstalledFeatures.Name -match $Feature)) {
                Write-Host "Installing $Feature"
                Install-WindowsFeature $Feature
            }
            else {
                Write-Host "Feature $Feature is already installed"
            }
        } 
    }
}

function Test-Command {
    param($Command)
 
    $found = $false
    $match = [Regex]::Match($Command, "(?<Verb>[a-z]{3,11})-(?<Noun>[a-z]{3,})", "IgnoreCase")
    if ($match.Success) {
        if (Get-Command -Verb $match.Groups["Verb"] -Noun $match.Groups["Noun"]) {
            $found = $true
        }
    }

    $found
}