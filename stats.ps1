$banner = @"
 @@@@@@@  @@@  @@@  @@@@@@@@   @@@@@@   @@@@@@@  @@@@@@@@  @@@@@@@    @@@@@@   @@@"  
@@@@@@@@  @@@  @@@  @@@@@@@@  @@@@@@@@  @@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@   @@@"  
!@@       @@!  @@@  @@!       @@!  @@@    @@!    @@!       @@!  @@@  !@@       @@!  
!@!       !@!  @!@  !@!       !@!  @!@    !@!    !@!       !@!  @!@  !@!       !@ 
!@!       @!@!@!@!  @!!!:!    @!@!@!@!    @!!    @!!!:!    @!@!!@!   !!@@!!    @!@  
!!!       !!!@!!!!  !!!!!:    !!!@!!!!    !!!    !!!!!:    !!@!@!     !!@!!!   !!!  
:!!       !!:  !!!  !!:       !!:  !!!    !!:    !!:       !!: :!!        !:!     
:!:       :!:  !:!  :!:       :!:  !:!    :!:    :!:       :!:  !:!      !:!   :!:  
 ::: :::  ::   :::   :: ::::  ::   :::     ::     :: ::::  ::   :::  :::: ::    ::  
 :: :: :   :   : :  : :: ::    :   : :     :     : :: ::    :   : :  :: : :    :::  

"@

function Clear-Console {
    Clear-Host
}


function Show-Banner {
    Write-Host
    $banner
    Write-Host
}

function Set-Title {
    $Title = "Chimera Stats.cc Checker"
    [console]::Title = $Title
}

function Get-OneDrivePath {
    try {
        $oneDrivePath = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\OneDrive").UserFolder
        return $oneDrivePath
    } catch {
        $envOD = Join-Path $env:USERPROFILE "OneDrive"
        if (Test-Path $envOD) {
            return $envOD
        } else {
            return $null
        }
    }
}

function Get-R6Accounts {
    $username = $env:USERNAME
    $oneDrivePath = Get-OneDrivePath

    $paths = @(
        "C:\Users\$username\Documents\My Games\Rainbow Six - Siege"
    )

    if ($oneDrivePath) {
        $paths += Join-Path $oneDrivePath "Documents\My Games\Rainbow Six - Siege"
    }

    $usernames = @()
    foreach ($path in $paths) {
        if ($path -and (Test-Path $path)) {
            $dir = Get-ChildItem -Path $path -Directory | Select-Object -ExpandProperty Name
            $usernames += $dir
        }
    }
    return $usernames | Sort-Object -Unique
}

function Show-Stats {
    $accounts = Get-R6Accounts
    Write-Host ("R6 Accounts Detected`n`n")
    
    foreach ($account in $accounts) {
        Write-Host ("Opening Stats For $account . . .")
        Start-Process "https://stats.cc/siege/$account"
        Start-Sleep -Seconds 0.5
    }
}

Set-Title
Clear-Console
Show-Banner
Show-Stats
Write-Host ("Done!")
exit