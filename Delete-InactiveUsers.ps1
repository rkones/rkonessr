Import-Module ActiveDirectory

# === SETTINGS ===
$DaysInactive = 90
$LogPath = "C:\Logs\DeletedUsers_$(Get-Date -Format yyyy-MM-dd).log"

# Create log directory if missing
$LogDir = Split-Path $LogPath
If (!(Test-Path $LogDir)) {
    New-Item -Path $LogDir -ItemType Directory | Out-Null
}

Write-Host "Searching for users inactive for $DaysInactive days..." -ForegroundColor Cyan

# === FIND INACTIVE USERS ===
$InactiveUsers = Search-ADAccount -UsersOnly -AccountInactive -TimeSpan "$DaysInactive.00:00:00" |
    Select-Object Name, SamAccountName, LastLogonDate

If ($InactiveUsers.Count -eq 0) {
    Write-Host "No inactive users found." -ForegroundColor Yellow
    Exit
}

Write-Host "`nInactive users found:" -ForegroundColor Green
$InactiveUsers | Format-Table

# === CONFIRMATION ===
$Confirm = Read-Host "`nDo you want to DELETE these users? (Y/N)"

If ($Confirm -ne "Y") {
    Write-Host "Operation cancelled." -ForegroundColor Yellow
    Exit
}

# === DELETE USERS ===
foreach ($User in $InactiveUsers) {
    try {
        Remove-ADUser -Identity $User.SamAccountName -Confirm:$false
        $Message = "$(Get-Date) - Deleted user: $($User.SamAccountName)"
        Add-Content -Path $LogPath -Value $Message
        Write-Host $Message -ForegroundColor Red
    }
    catch {
        $ErrorMsg = "$(Get-Date) - ERROR deleting $($User.SamAccountName): $_"
        Add-Content -Path $LogPath -Value $ErrorMsg
        Write-Host $ErrorMsg -ForegroundColor Yellow
    }
}

Write-Host "`nCompleted. Log saved to: $LogPath" -ForegroundColor Cyan
